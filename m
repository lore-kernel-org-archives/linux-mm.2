Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87702C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 02:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF4218E0002; Mon,  4 Aug 2025 22:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA52C8E0001; Mon,  4 Aug 2025 22:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB588E0002; Mon,  4 Aug 2025 22:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD5B8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 22:52:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 12D5981C89
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:52:22 +0000 (UTC)
X-FDA: 83741180124.15.830D6C3
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56E9E160005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 02:52:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GZW3I7N7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf08.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=yi1.lai@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754362340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0Kbk4Afk9UxSpI6Jdc9G1A4F1Ue48VKQMrYHkfI/H8=;
	b=ANUMZvKwE/fcB5Uqd6wNReW6MCtqbzT1GElN4gCeXV5kfXYRJjU3uky6PM/0f6KRBUG6s9
	24C6CTynyvIUpz1WBWI/aF+1/q3qEbGQGnaA8PE72RLhv0/GbrBIEbPjg4WAf54EcZZN77
	8VgYkiC8j00S6YmzY/1eaNJcoaYklYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754362340; a=rsa-sha256;
	cv=none;
	b=PnzzGSkFNHy5KcA79AeTRfr+TcBhgX7f0DWNoMkGo5YXzrWMDFZwSPQg/PxlAmfSkouO2x
	US4bgiRDB0zVixJiOsB2wKjO8lqyuA9+K4AgnUOon0P9VhUzQ51cI9fGh6UE0LKxzhUC/o
	nwnZvpDie1Qq9ytJBp4WVPksVxmxwlE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=GZW3I7N7;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf08.hostedemail.com: domain of yi1.lai@linux.intel.com has no SPF policy when checking 192.198.163.17) smtp.mailfrom=yi1.lai@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754362339; x=1785898339;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=xWrtF2tYxg+vd0XZ4zy3xUBL5mHYjDp8KuWsqUmiJ64=;
  b=GZW3I7N7hTmtoJNvoxcH2NC1cFNoTrIjEcGB3CrH10RWURRdkRlFRWsB
   xyXxULkqDAFNVtdXEbAdD9XDiw465pNTAnGJSUQMXiVVER+BUKenNbels
   sf8cCdfi/T+kxs2THNzv0hdGZ+wHebYkm2Jet8XpCckaR5THL5vaVAtSG
   aymvgzmXuOvrvl1QOcz2P3sg9KauzIecRqURy9ouQfE62kFJ8TVsAmnED
   vHcL6IPMmzAGbyCk+q9VoIDCADjscgKIRTqHSPPGc7kRBMGbcpGca9HJT
   tK7Q5AwZvf2uNia3edXSBLhpJcUVjXqokQ9vPgcB6P8k3WdcLmDRF8bfM
   w==;
X-CSE-ConnectionGUID: slNAvu7CQ2alradbfOZKsA==
X-CSE-MsgGUID: zEpQilNPRoqrY/VhxxrJ4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11512"; a="56558370"
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="56558370"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 19:52:17 -0700
X-CSE-ConnectionGUID: +QD27GhQRrGOrsaI9i9K0w==
X-CSE-MsgGUID: jd9PHEawTMeqV1/KL6z4Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,265,1747724400"; 
   d="scan'208";a="195169335"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.182.53])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2025 19:52:14 -0700
Date: Tue, 5 Aug 2025 10:52:10 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Barry Song <21cnbao@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>, yi1.lai@intel.com
Subject: Re: [PATCH v4] mm: use per_vma lock for MADV_DONTNEED
Message-ID: <aJFx2mg5RRq1uzvR@ly-workstation>
References: <20250607220150.2980-1-21cnbao@gmail.com>
 <aJAFrYfyzGpbm+0m@ly-workstation>
 <1d1d97f9-2a67-4920-850e-accf4c82440e@redhat.com>
 <CAGsJ_4ypaAySaWyatH4Vu_dz--gEXUWk3yAQwM_8JTdR6U3fQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ypaAySaWyatH4Vu_dz--gEXUWk3yAQwM_8JTdR6U3fQA@mail.gmail.com>
X-Rspamd-Queue-Id: 56E9E160005
X-Stat-Signature: gs57xyusz8hjyuu4kspeakqczh8h78ux
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754362339-813840
X-HE-Meta: U2FsdGVkX1+JmqZbTHhmWs5LK58WgT+20DzbvAKkeNLBUkSNnJjXN6pIrkd2u9edzcQ6DI7Izk2MdwAjlCE84RSK0OvLpEzh8NZNbcYabGn0r3uqTt3UclhIbLbB4ML7J/57fmOgKGN4vLYF+T1wgW3hRz+1bxwqPlM90hv7Yd5YT9ockvkEDFfasCjV8/pW5TI2mG0qCLOOSq0W9ndgPxIu5bnIMJI0yuu9XO02o+HCkbAMCZw/oKXAxWdSQZh2wz3fBQDzAZF6McQdrMUVNpe8o6AbDXfgsIRUUnNlH/1l5YG16r1ZS2BoKo+pNGtvEV/+Cn75RCaMar6nmEYMXDH+T4khfejpHmVS3vI2mXNWOBgM8q0BoUjVf0yPpogjIDOCenB5rtwicjl2OqGaRHwPxeSaGLkM8KuS2rMolguUVObEp6QrIkjKuOJ0KhvQwOHrg0puRMgMwthfjpEZ+h2gbQwbBY3xN+OpGQ4NyHNXYjS1wzi9cDz486++D63XWYp5N0X1ADnXAlCDGsA2xWyihGLtTxHYv59ED889uvzMS3rU+dtB+N0Wxp/ny3Dps5+aC7K+bbh0CvnRUz7NRoFdvO6GzgtEHZhOOmE8lTMAwtMHP6X6/TQfSLjqlyzCvwOq1fU7ydnqRc+MDro6/kJESZ4oi2/paaHO7/CAb+Tigf/O94XWJ2hz9hV/i/g6OPBVitZjdqmptdGGS20thJiXo8wAcHDqyj0ZfjnbEonvdhPCJFBY8p4MrmfYaRjX51yJWGWoFLRmYFCPK1dV4VkFOXXD/3SKI4VG1lniBErCg15gDPA2foXCTZhvd/R8va1Oj1aSKMh/Rie/Z+yTKmJFSHyHpznkCMf44lvp8sPP1lukBi+XNl8JSwftvTaVOLO3YRbd/gWVAYs5VxURm7SbN0AyekUO2znRN7c7JUaAUybiAD+NWzds0cVIcSzdotCmGjRRlxJhNf7IT9G
 1JV8zq/f
 Rtsw+p3GSR0Tls/vlXsDRfRMw/oiA3ONrobHjfJZ6FgjECxeJgqvs3cqJ321TFfcMACGX6v2phX6Woc+KQ4R1jwKu7HUeUCOp13eeveSn+UmpP4HrUufWRHdGn0En/ox9c189VW9q/WGJYL81zAQnzNSFwzSa4Ps5DZ/4urt6hc+TB5jL1hvJlkK/bnJWzgDGN/OKPF1NE0c1hguWDp9KePjDrCNIec/YK8jz6q2+SYvwBt8yeC3om2OQoZ+rSrjvARDZDmdtb1cOk5hVTNJP4GwRmEgg6PiZJG08eeY/sIBYEjI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 05, 2025 at 09:48:32AM +1200, Barry Song wrote:
> On Mon, Aug 4, 2025 at 7:57 PM David Hildenbrand <david@redhat.com> wrote:
> >
> > On 04.08.25 02:58, Lai, Yi wrote:
> > > Hi Barry Song,
> > >
> > > Greetings!
> > >
> > > I used Syzkaller and found that there is general protection fault in __pte_offset_map_lock in linux-next next-20250801.
> > >
> > > After bisection and the first bad commit is:
> > > "
> > > a6fde7add78d mm: use per_vma lock for MADV_DONTNEED
> > > "
> > >
> > > All detailed into can be found at:
> > > https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock
> > > Syzkaller repro code:
> > > https://github.com/laifryiee/syzkaller_logs/tree/main/250803_193026___pte_offset_map_lock/repro.c
> > > Syzkaller repro syscall steps:
> [...]
> >
> > Skimming over the reproducer, we seem to have racing MADV_DONTNEED and
> > MADV_COLLAPSE on the same anon area, but the problem only shows up once
> > we tear down that MM.
> >
> 
> This seems to be where the race happens.
> Hi Lai, can you also double check if the below diff fixes the problem?
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 374a6a5193a7..6b40bdfd224c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_struct
> *mm, unsigned long address,
>         if (result != SCAN_SUCCEED)
>                 goto out_up_write;
>         /* check if the pmd is still valid */
> +       vma_start_write(vma);
>         result = check_pmd_still_valid(mm, address, pmd);
>         if (result != SCAN_SUCCEED)
>                 goto out_up_write;
> 
> -       vma_start_write(vma);
>         anon_vma_lock_write(vma->anon_vma);
> 
>         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
>

Applied this change on top of both linux-next next-20250801 and
next-20250804 separately. Issue cannot be reproduced using the
reproducer.
 
> > If I would have to guess, I'd assume it's related to PT_RECLAIM
> > reclaiming empty page tables during MADV_DONTNEED -- but the kconfig
> > does not indicate that CONFIG_PT_RECLAIM was set.
> >
> > --
> > Cheers,
> >
> > David / dhildenb
> >
> 
> Thanks
> Barry

