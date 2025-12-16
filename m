Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98CAD5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:00:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C3A56B0089; Tue, 16 Dec 2025 02:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A1276B008A; Tue, 16 Dec 2025 02:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B7326B008C; Tue, 16 Dec 2025 02:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE616B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:00:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 011CA60387
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:00:51 +0000 (UTC)
X-FDA: 84224436744.05.4DFAC34
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 18C10180011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:00:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+ZcAHvy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765868450; a=rsa-sha256;
	cv=none;
	b=N1LYa+w2oZIjJ1awHdzTWIE1oTDUIVl6iMD4esGEjHr2XCxIJDFBwpCN/8X3wdmiZRMSfR
	QxFq1axTyP4VycZmEP3uEYXxUeVhCLaV81vvY37B4mRJzU1jShBl/wSJerBCAPB7F6tHqQ
	A7SELNKQ5U7d5BXp8kLOIi1IKD5iipE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+ZcAHvy;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765868450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFAmpRfxxeFHVpZ67Bvb+vEc5qUXOEU1rpTMEK2KAsI=;
	b=YUW4a7iodlC6OLq08kUwowZfeeuo0+4bdSSsrzJackRUsh57Tbxlb97c7UTIlgvhsiAIWR
	6S25Qekbf9xJ5LaBFnv5BeKSNj/XZQkYkjO+P6zDNlQuuvrhtonMhpM1SCO/B/gnBLbTPn
	eovbnRlh5jNh74plx27E6WkbJkTcKQg=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a099233e8dso23280215ad.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765868449; x=1766473249; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QFAmpRfxxeFHVpZ67Bvb+vEc5qUXOEU1rpTMEK2KAsI=;
        b=O+ZcAHvynQX3GYLMeqw8zD/SbIgEkwag2Fg5mfYMgrPFdznkuU3ZDZzGWTg6zkEebl
         l4QU4388ohoXTtfvKtZzW61YE2NtWRbHD3M5OuVSP4xFBKWzuCrLKva+k28Zr8OnMO2z
         DrEtBMLxijM/eW3eamQ6Dsla1f2XfnwDy1SPgrMNl3Am09J2Vr/ZISekfdOtNNwPNtkf
         LxLHnya6JKAFePzIJWx4TrPsiDinff+e65QASFhAMW//J91PcMX+Z0EJz2GWff4lWLKs
         8Z1UpmQmVzGgLsBZnEvltToWDSXW4BIoXQ4rX6rpe6tlZHfIfUSZGdjJC2NkVuOIqM9c
         m2Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765868449; x=1766473249;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFAmpRfxxeFHVpZ67Bvb+vEc5qUXOEU1rpTMEK2KAsI=;
        b=b+ZUL4CBSEpjsvFkFUHCZ/54BXTVPH3FLoZGLlJ3Zjo+5esVUc7qbo1NGE5u8l6k/K
         K0T6jrHU1LAN8hm/3HhiIOjbjcDQ31TmzfJIJy8/enJ5BcCIvWqI7sp1NSK346tSiUDm
         9Uc5iQTsO8zHO4K8z+FkA0/hxTwiPTHfuwMliSHRzexB9kwnbZjRDnldh5kfeTc4mDsU
         1otBikTCuaIFYPASNH+Mr7O7Ucs/LZhjPeJ35NXnEiEGO73BaSXgKeuztLn+PbvBQYEa
         U5S1XYgMw9KDSlDkqwmDvMmL2xySOdYcxopd3j+hGAUj3aZad0cgxWdnBR0ie0veKJvr
         YU5w==
X-Forwarded-Encrypted: i=1; AJvYcCX+8SryBJWZX8oFBFBCI9KQP12dc6/wS9ljXNtgx1e2kYDB27uZ2Mu4cYO3STlMRqs/aDsHxBQxaA==@kvack.org
X-Gm-Message-State: AOJu0Yw1rbO5F9EQfLmpJ2sD/RFYWCVb71MX6rq7k9aOP8DIGIDoP1GS
	6lHQnnTytD6tfdVKszYBCQxzynhB2U68SHOqB2hIXPO6kxtAWQceootbyTt/f8x4
X-Gm-Gg: AY/fxX6Rip8tpA6oYqA/o3VxJYKrtswDddw9crAGXfe/A2df231QFAF3V3Cp+c/AXQ8
	+VJzX6K41UVzcQvLOcre8/5Mj1HfLL8g+DkUSxasuAgUcaAlbDU6/9xGoXngLWMfEbjHNYpzVQm
	RaEzMIpE2FbHoO++vJdvgECOos2Td6FWgJY+V8S8MJ4dDcPS0jrrhYC5QNfAwuI9fDx/HgVITPb
	7hPHHbHCc7/mu5K+Ce/JQCEm3LuFzea1yv7zmlv9rJXWvRAomwp0yEpk29oreAPIy0y/8qqpP37
	CCqTaYx7VBtnS4MqCnTu5I0/CoYXnA5j1gnszxT/BOsckoHWMuIE1Q6LAahFs14TpGdCIBXSlNy
	pdk9qzmcV/i9Xrl09gUrZE7Hk0Qqt2g/pYIUMtuapuo/aCyImY+G74WyUld0QAmLFwHAKBtAOAH
	u2cZf0LqcZR1r+e2s3+6Weau6H
X-Google-Smtp-Source: AGHT+IGh6bmnUUir8G3p+H40K0uXG1XJ8Ee1y80UE7dusYw6M34uFWl8fwWh7yEEQaUxMtCplSPWHQ==
X-Received: by 2002:a17:902:d58a:b0:2a0:c1f5:c695 with SMTP id d9443c01a7336-2a0c1f5cf3amr79926245ad.16.1765868448784;
        Mon, 15 Dec 2025 23:00:48 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a146538c6dsm3036695ad.52.2025.12.15.23.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 23:00:48 -0800 (PST)
Date: Tue, 16 Dec 2025 15:00:22 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, oe-kbuild-all@lists.linux.dev, ziy@nvidia.com, baohua@kernel.org, 
	lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 3/4] mm: khugepaged: move mm to list tail when
 MADV_COLD/MADV_FREE
Message-ID: <besdqn664ys7izgipfi5wloy4kmscosipizpbxt3hig6zvo2cz@yibkwnkitc7h>
References: <20251215090419.174418-4-yanglincheng@kylinos.cn>
 <202512160400.pTmarqg6-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202512160400.pTmarqg6-lkp@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 18C10180011
X-Rspamd-Server: rspam10
X-Stat-Signature: q5dqz9ht39g63chqf5icxaatuzszgtsg
X-HE-Tag: 1765868449-182574
X-HE-Meta: U2FsdGVkX1/h0KZI6Phl5u1OWlG8NqGto0AbC97dB2SxnV9cdKo2YjJUtyBCp/KxKAC4N+2D4CHcDWQaApIcDBziE6YqtnRzNGjJ3HHDYyfLUPdq6jNicUmw3kRJB88YJa12xLLvQHVwHsjTELhtwDz2GHBYoujlrvEF5e8ddkPQCiqR48crdv/jTU+9jbUhEupFUIwauqgM2KdAl8qKlgEde9GfHBtkPh34zzQOAz47WK1CPWQlxrCRugagLYxiVj6sfkvOA6r1+5pDpM9QwvQopjOUV045m+GN32cCTQmzQVbyexWEuNDqvPkV+M9ZWb/ZIQtUf+/diuyQWJ1k5zgGOJ9VbARHLzDolNxVxtp8jBF3eajhG4rboqgbCjtVh1H9b3eRYZUVs8f40/oUw2roGJpUJbuoVhLcV4LaeQ+ukjpZ9FLr24l1MUV7ZtM3fonGvpBvsSacxAlSPpdOWwi4TaUEVE7whb6FS8VEQDHAeEkbz3Zg0CqtO07CRfJW3SR7Mnq08EhJl0X/HzfEqBf9+n5RRNB2sZx3jS6JuD5/sPXTioWu4Q9mrd6Gc55XUkmUWYsKx62aOOv+dqRxsYvzzXVXwyzUJ88B/5hlqi3pmSYl2YCnOsulKGzr0T1oHcScmqYv/aPRJC+CFLqBQ6nAzBkqVJduc8srsuwTjjQ2bFxbb/eE9DpriWwo0VM9WTIES7yovRa/j32OdT1kMw+y1WbM3Vv6rqdbWHjhwybmdYjckg0QG5NwkRknekyvGsXUxW6hBIfHq5jkDvlgsnhNz7Msc/M4CGJjdj1ZK1XwS7+sRO8FUUcElRTD0zuzMKi0Tg+W859DwB5QKbylO3Ac0K8Yxree7xmaK8/fAiH17UWiN/eCuDyuXJ9cqLvd66/45ssIQm4WYAvoEXPrnpVYaCiJwqi0UaNwZSWxzGn9K80LLRjN+dGbsm53vBiZ2geFf2fYr/G38QKrXgN
 auhOLDny
 5pVFLJKga4kQIrML/6Dh1hezrTzLsWV6s1xN4qVyMsno3Zj3km5IG3jeSyog9HYQS1KrmHXbMrDjMFh4YpIs+K2VcxkUKuVFOTjhYeZJeIZbA923LCP9/ff438p6RGgPwQWqFg/skQLTNESf3cl9D7bArSDd6NOmOeRhbditUS9xBAmaDAz0GGQqWUOhOxJIoFo3DTLmzpKZ51tUjWK0gvxiRuec/6Lkbodkz0sOkLPwheaIvMJRilA3aQmBfUaCluF/lx4UeRaKjpci9RYuo395Kg+QjrJPsH9qAwwov4V/ihg8J1cw4ByzmienWy8kWiaiBh11sJQDMA5HUBHZD1zNn7OHRRHd8V4ay4ArOIEp2Jdqs2Hi9wbfb3KEbdgcWvosgXljFD8w4Qz4gZ9wxeNtn1h0HDx/gUfhUfoH00vRxTkX29kusYyjwlGbCr/LVGdiqUiflhK4gdxcpkjhgGxxV0kDwLIPw2jZTscIc3VvYlP1RSrZSd4/G/H+N/rcRhM8Yk0+d87+OCZ/Xh7a3L9MrC9MO94Q1ONBs0lDhNNa/jPBGWcw9pNsf7BQvhOBgSdStOga2mK3k1llcXSXSv1pKnC72WAoNo8l0cpjzYshgfHQ0R4F8kABuUf/u6fbMA1dY8NCORNUOU447qLJPvkVmlaZP985ee4DD35/jPx13rS1LPw8z7P5I1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 05:12:16AM +0800, kernel test robot wrote:
> Hi Vernon,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.19-rc1 next-20251215]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251215090419.174418-4-yanglincheng%40kylinos.cn
> patch subject: [PATCH 3/4] mm: khugepaged: move mm to list tail when MADV_COLD/MADV_FREE
> config: arc-allnoconfig (https://download.01.org/0day-ci/archive/20251216/202512160400.pTmarqg6-lkp@intel.com/config)
> compiler: arc-linux-gcc (GCC) 15.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160400.pTmarqg6-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512160400.pTmarqg6-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
>    mm/madvise.c: In function 'madvise_cold':
> >> mm/madvise.c:609:9: error: implicit declaration of function 'khugepaged_move_tail'; did you mean 'khugepaged_exit'? [-Wimplicit-function-declaration]
>      609 |         khugepaged_move_tail(vma->vm_mm);
>          |         ^~~~~~~~~~~~~~~~~~~~
>          |         khugepaged_exit

When CONFIG_TRANSPARENT_HUGEPAGE is disabled, trigger this build errors.
I'll fix it in the next version, Thanks!

>
> vim +609 mm/madvise.c
>
>    595
>    596	static long madvise_cold(struct madvise_behavior *madv_behavior)
>    597	{
>    598		struct vm_area_struct *vma = madv_behavior->vma;
>    599		struct mmu_gather tlb;
>    600
>    601		if (!can_madv_lru_vma(vma))
>    602			return -EINVAL;
>    603
>    604		lru_add_drain();
>    605		tlb_gather_mmu(&tlb, madv_behavior->mm);
>    606		madvise_cold_page_range(&tlb, madv_behavior);
>    607		tlb_finish_mmu(&tlb);
>    608
>  > 609		khugepaged_move_tail(vma->vm_mm);
>    610
>    611		return 0;
>    612	}
>    613
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--
Thanks,
Vernon

