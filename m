Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6203C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 08:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6516F6B008C; Mon,  4 Aug 2025 04:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629406B0093; Mon,  4 Aug 2025 04:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 566046B0095; Mon,  4 Aug 2025 04:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 47DEE6B008C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 04:50:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD0721411A9
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:50:01 +0000 (UTC)
X-FDA: 83738452602.22.B2A28D3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2AEAA180009
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:49:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OCAcQDmA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.7) smtp.mailfrom=yi1.lai@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754297399; a=rsa-sha256;
	cv=none;
	b=lclhdI8obLMuaLhfAvKzO2fYH8VHnKSiv8xSXgpYvV3uPFZLbcnSnACtw1hXjsGfaYrRUJ
	24zmg/SV6UEBbf3F7WS/9/tKW7HsyutIfHdMNCjzxBy2ihhZO1Rr7W7u51CEV8kK2feq6C
	G+Mnb9+lBaNP+AZ/xzbBGYGqq1ff5jk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=OCAcQDmA;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf24.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.7) smtp.mailfrom=yi1.lai@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754297399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pIjeXLyQSjWiwJ3CXEkx1rU6B5/eFVSoEv0sAkmdIHk=;
	b=hh/aIrfYSfhDlyI157RiH+/XURuGP8YrO97W+d8kcOUl+BNFq1+5780acz6WoM5heRxYft
	MxOkdMESm1thHdRTEfqDVZkt8+cLvmYaFIC74HflfHnZDMWGucPbT37zN7ue0cPh2GaXWq
	2rUYf8Z8ZYcnrBaCSelsI1BpXRf+Hw0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754297399; x=1785833399;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OE8DCHLkOjXraIy9L8Rlx5syMeADjgWTJOCY9F+7ouM=;
  b=OCAcQDmAIs9+Oh4U7iZAfIrHG8ETe4GpERhu/dy17EYRvWTRoAl6ir1h
   pYpPouFDLyJZOBe8WfBhdKJecsAlx1uEQVpbYG7xgNOy/6FiVUIV5ciPY
   3urkuPOLoVaF0g9BBeUe0UQ0jn7opgGaKlL/NY/h27DYiY/y3g+Lbciqo
   f8FZQ9GuxR9RQYuUUoMIM9aEEeplqdy5TNTDySZzdnaV1Ax+ZGJJWRpYu
   LnPNGK/rq9A7D2Dk6+QOA87AnZ0D4dwsFv2GSUpz59lfQyhfXR5E3aevJ
   uCSq9b3jJwX77IaRWeMC3yAVGRCUI8VkqstS7jkiCIpGIjZMBQ6pHmA3A
   w==;
X-CSE-ConnectionGUID: Z4TYgV+tSfy83zTR+I4ypQ==
X-CSE-MsgGUID: OEKDltt1RxCA9ApFERUP4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11511"; a="82002474"
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="82002474"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 01:49:51 -0700
X-CSE-ConnectionGUID: /1A55KLXQ4eC/wnpkngSSw==
X-CSE-MsgGUID: Fy/qhbotSmCMeWPChw5yrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,258,1747724400"; 
   d="scan'208";a="194937262"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.53])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 01:49:48 -0700
Date: Mon, 4 Aug 2025 16:49:45 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: David Hildenbrand <david@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>, Barry Song <21cnbao@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>, yi1.lai@intel.com
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
Message-ID: <aJB0Kdc6cx1lGkdb@ly-workstation>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
 <4fa8f492-c7ef-451c-8dc7-38b031c8a092@bytedance.com>
 <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d9d0890e-2837-49dc-9ca8-1d6c28e95a21@redhat.com>
X-Stat-Signature: dja51k8hxhdwx3iztxnegn1yfrj3sdxq
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AEAA180009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754297398-219438
X-HE-Meta: U2FsdGVkX1+ereqjZIqeZb/EMAa7/8L86s0Uu9bfXuYylFXd1hHXkfft6mMYAN+tWDk1mI+3ykURChJB7BAok5Ke+RGxejIa6yP1xSiUnmIjhDrdVvYEEAJmx7vCC2122xrOHA6yLX9HBIAaszJVrHInYpUaFX8UcmoExHkIjWRIt2OCAFgKpOlkE7WyLuwfqzkl+is1USRTJFmNPd+J3GFUe8C2VLFK4fUCXG9IVsjMcGqSAKT/qZfoXQzT6+h/MFZEf+IHZhGIkPqKlOSW8zNm9KtCcZuNVmtGxfAWGViQStzYh7Q7NSkkbvpHsamwuVx8v5NEKDto2LedhTfO0JJFnWFsJduTpw29f58913SMvwYiu7Pi5acAiPgzD71FLhCrTiI409KlOZbtkBoe3lrLhI66FjEqSESFgzUZBW9AAyFOT9Tpw+llH0Ek+7/nRcGADCi9ogCQXP9Hc8mQVNxHBF+mG7m2oAKvxLUOzDWWPpPB9EPjDVuk3b3UaidvuIdY32eGJ5g5xyB7Olg8IWq5Rg7MK0z6zH6plSCbx8pVeEjyd+Ojg09lnZ4iLhNXmFgVKKUpIJBVC10S8JnnvwRMglfdKVEpxO9KtnhoZMJyZ5EYRhD02ipf1YTIsqWyn3I/EH5jTnFne4wSguASvGKiJcu8opT/tUMNSJNt04YMP56nTcFhYFLQmekzdEmjiUI1mwyFhQag9WNXnbOUPyO03ddwL1q34VC9T8H8aNkvp9n43ahnKXN/AWRRPyj+Jm9+oMj80bh6VbTq1NPi53y+DOSTDI3Q5GaXdW8XrsPrSiKnJrrL39GVSEq/5DcVMZ7BZ3EsRwmoTq2h8B0vcdDkA5QG8MocDXgyPY8u1om67aFHQ37ru7+blgZZHEryiJfobhUa0HuU5R1gC20w5diml2z1nxUBXo8E/HBGcNoN/jaJymrdqaHmTzCdZm5VayWC7q3J4MghQyRolv7
 JyDqX0dK
 U+c/NH4aIb9tcUhHW0wdERIjqDYALkHU1YtuEQEwH4N/2nuJAtAGanqhvlh8TteYYu3RRBwhqHAuJKprWJG9MEICcnCgSY//CjJf5Em1IHs3yf93Wp9mUnCq13/XRw9coazPV5erCbx4cGVPGX6kVpR2yltof1O9M6S8BciO1hFF98u30V+LEYvNu8Tm9onnOc8JnX+qy9CpztTa/3dYQby/rtvL/oCS8KX8Pt3JEytN+Njmn5teE7Zaqc9EBLMeBJL5t1u1+6gct43pz+V+q9zkvlI+jR2DRsCRpSj9kkTaxsG1W8Wgd5dViXCiq0Q8YzAm7iHcXzlUJPgpwkNaVF6mOpv2G69WQy0cUX0406YIPU3bSpVV97HdEPcRY/Rfzm8Naq2TlOYh8VS4L76kZqPMtjscgCuhq8Eua
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 10:30:45AM +0200, David Hildenbrand wrote:
> On 04.08.25 10:26, Qi Zheng wrote:
> > 
> > 
> > On 8/4/25 3:57 PM, David Hildenbrand wrote:
> > > On 04.08.25 02:58, Lai, Yi wrote:
> > > > Hi Barry Song,
> > > > 
> > > > Greetings!
> > > > 
> > > > I used Syzkaller and found that there is general protection fault in
> > > > __pte_offset_map_lock in linux-next next-20250801.
> > > > 
> > > > After bisection and the first bad commit is:
> > > > "
> > > > a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> > > > "
> > > > 
> > > > All detailed into can be found at:
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock
> > > > Syzkaller repro code:
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock/repro.c
> > > > Syzkaller repro syscall steps:
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock/repro.prog
> > > > Syzkaller report:
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock/repro.report
> > > > Kconfig(make olddefconfig):
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock/kconfig_origin
> > > > Bisect info:
> > > > https://github.com/laifryiee/syzkaller_logs/tree/
> > > > main/250803_193026___pte_offset_map_lock/bisect_info.log
> > > > bzImage:
> > > > https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/
> > > > main/250803_193026___pte_offset_map_lock/bzImage_next-20250801
> > > > Issue dmesg:
> > > > https://github.com/laifryiee/syzkaller_logs/blob/
> > > > main/250803_193026___pte_offset_map_lock/next-20250801_dmesg.log
> > > 
> > > Skimming over the reproducer, we seem to have racing MADV_DONTNEED and
> > > MADV_COLLAPSE on the same anon area, but the problem only shows up once
> > > we tear down that MM.
> > > 
> > > If I would have to guess, I'd assume it's related to PT_RECLAIM
> > > reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
> > > does not indicate that CONFIG_PT_RECLAIM was set.
> > 
> > On the x86_64, if PT_RECLAIM is not manually disabled, PT_RECLAIM should
> > be enabled
> 
> That's what I thought: but I was not able to spot it in the provided config
> [1].
> 
> Or is that config *before* "make olfconfig"? confusing. I would want to see
> the actually used config.
> 
> 
>
My kernel compiling steps:
1. copy kconfig_origin to kernel_source_folder/.config
2. make olddefconfig
3. make bzImage -jx

I have also uploaded the actual .config during compiling. 
[2] https://github.com/laifryiee/syzkaller_logs/blob/main/250803_193026___pte_offset_map_lock/.config
CONFIG_ARCH_SUPPORTS_PT_RECLAIM=y
CONFIG_PT_RECLAIM=y
 
> [1] https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/kconfig_origin
> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

