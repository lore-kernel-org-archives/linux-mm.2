Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2627C982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 02:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD5B16B00A9; Mon, 21 Sep 2026 22:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAC0D6B00AA; Mon, 21 Sep 2026 22:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC2466B00AB; Mon, 21 Sep 2026 22:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A770E6B00A9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:11:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D5811A026E
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:11:51 +0000 (UTC)
X-FDA: 85239772422.04.FCDF735
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 92874180003
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:11:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KYKN49lN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=KYKN49lN;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790043108;
	b=BOpBFjh0oqmk/d1Bq51Sk6YL9zpBoeMv5f76euU1qYIIn6ZA1Ifs0AYGVeUw0ujfXytlN9
	XnMNiJTFC74WE8i1I9IDqPGjy/IKILdJiFgu6TMn45ubHmEFGXHQxp5dbacILa0RDP3JKf
	B2xbSsTi6543cJkWgL0lUPxpDizoyGc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790043108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4aHnmTK0A1G18pdWv4Fj/LMRrVly9Y3MfKQf61geNE=;
	b=gf1EDFiQ0ZgIu1u76AlKPNGNmhHNaE2/193bpi2skMYGd+Hq2q1XXf1nhpMtleWmC8vBX+
	9PVKMLLAfhGbhAyVS5cDLopMhkBz9RWSIEq7hqT9BJqmEV6AbdUxAqAyGz5/pDP60PJvV9
	2RSUErFNRcxJPwUMa60HymS2LEPN4bY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790043108;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z4aHnmTK0A1G18pdWv4Fj/LMRrVly9Y3MfKQf61geNE=;
	b=KYKN49lN6hl6jRcC7ZzpfVqFNN5UQgQa8bao4fwPnn/R1vgfiZSkuCDXI0YoiMx6ZnUKb+
	abDL2q69ySxcn7Qm3OvagGKVBrN00KCZyoGSuHHsl5aOwIZ/2uCH78YcZDPoGBsIlvMzx8
	gWefxS17i7tE25bxemwUq9EEiUV46Zg=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-e83UIR-aOFmFpnqvRnw2KQ-1; Mon, 21 Sep 2026 22:11:46 -0400
X-MC-Unique: e83UIR-aOFmFpnqvRnw2KQ-1
X-Mimecast-MFC-AGG-ID: e83UIR-aOFmFpnqvRnw2KQ_1790043106
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-93a0c7126e7so640902985a.2
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 19:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790043106; x=1790647906;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Z4aHnmTK0A1G18pdWv4Fj/LMRrVly9Y3MfKQf61geNE=;
        b=fVBrbkDaI8Mf3WPOs9ALgw2+WyG+Pk4wYHDPikR4O906GqAGkYAPaAo6NWwns4X2jV
         JR9e2TZCrLj8czh6BzP+hizasnYot5O7muaGYbbz1zC42Vq2Tb3W5YqeWW8dl+C9nrMg
         Ftgu5QYOAtsHESdE5QpwWvbig7pJKgsR3GJxN7Cc8OEvqMsVP63dm8TTljpU0xZL+Qdr
         wDdyuzJ6Vi7RpyAJDs2AhNpkMddodnbB+u/Z1vVl3r4HD29MYTjo/JoLJSbliDBp6iI+
         GVVEREOolx8u/SfBEBS9NZ/12SCNKEds3wBiEDwH8eowPB9sRhO2pYtR0SrWpWIvcVf7
         D2Pg==
X-Forwarded-Encrypted: i=1; AKwUvBwIQACOjt9Nu69+mIM63TQiNVRh8Za6JLvp5LnVBojO8dyFvPfxI4c6RzPrV2x6Q/05nhG+7xtaEQ==@kvack.org
X-Gm-Message-State: AFuF++l10K957xHRXXFH7uWhReVLak08dLD8YsuEJIHUubWRXLpTDugo
	I2ZMseab9Wla85gzUNrPe00XxabAXkEGYYRngNCjcI+zcBWFIGFUaSwf7HakD/9hmCzBy6153MK
	lOZig76r4jd5qzXLfnqcrTKU6FRICnDiIR0vuOEGOjgV/Y5fqo19XgCPMNLqunPz6ag==
X-Gm-Gg: AYBFou0U2LVijnVQVO/8S6yMjc4RF0KbElygze6I9CrIWMwg6L7CdnBXzz801W1pVuf
	cfzXIModJLtGALu3Nonv6o3dZ7hXVrykQ9S42rTTVLgVfYT1pNw2qFmC9EZ76w/MoRAr5vZdzhQ
	DKhNcaIiQR4bRf7PZpbQsficQLyQBdF4DwBCP4AgwDzJUieoAqWacOTHVx7WmzylEiVT9B+LwQG
	KymnJGaSGLwI5/SNMrVB8Jd9pAN4HKpDpI4k2AiecTVnJvtmfEtK3+ruq3/d/OiqtY0+8blm7kB
	UiUjD3jy1twl+DtVT0tQjNb+/kHsrXwE7XRCmpj+onNxh6bc1j4B6p47mydQvzWr0Ej0US8d64N
	u/3g=
X-Received: by 2002:a05:620a:bd3:b0:93a:82a:71e5 with SMTP id af79cd13be357-93c15d86b94mr360801685a.19.1790043106240;
        Mon, 21 Sep 2026 19:11:46 -0700 (PDT)
X-Received: by 2002:a05:620a:bd3:b0:93a:82a:71e5 with SMTP id af79cd13be357-93c15d86b94mr360797685a.19.1790043105768;
        Mon, 21 Sep 2026 19:11:45 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9140249fcedsm4229616d6.12.2026.09.21.19.11.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 19:11:45 -0700 (PDT)
Message-ID: <2e6802a6-9815-4fcd-ad72-136efb599d1d@redhat.com>
Date: Mon, 21 Sep 2026 22:11:44 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] mm: thp: always enable mTHP support
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com
References: <20260921103620.3431087-1-usama.arif@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <20260921103620.3431087-1-usama.arif@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LxLeXhnuTMZE72GrdH6oSE3nUKfRul-aeUaaA_xW8zY_1790043106
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 92874180003
X-Stat-Signature: phspcy1gjwurypu97yemingt6m7g7h6n
X-Rspamd-Server: rspam01
X-HE-Tag: 1790043108-381405
X-HE-Meta: U2FsdGVkX1+W7n4ZE5+wd9oLPwJaS622G8S6uOPnvtTTLEh1Qb4750TiPmsHpwLtxvYFmbLPrGI/cbmk6k3cZDiPF3uwhxrUyH7p8fwl92/EvdlV9qPfhmoreKbL3RoajkvPEy0IOirPV+1pFT04j2270M+NDxPHtLE8xqApfBlxXZdNCQ295rbpp5LTY2WsHKR/kpwVN+gWdzXiKsRZqLStWaCwNqZ12M97h/f6mHm7XpKewMW+qUXfy47UkjwlAOGccpNzac26LT6/lPUni9925iXAlfMRcMsXkZ09PTsmJMFOkVW6i98oyONODHVcD4e2eMYvjt54YayLP0oOEnCTRL8paUkS2eNiJiQEbdGy/m72nK1l7447BTxmIp8KhQd+gswhVOiEw56ybi5brx1+kJI2Fqi8EZChRobXQKZq2q7MitJwMvzIKVuQ2+TY1PMO3ePKESeLGIVwkq36o12wq2EalXDxp4qDOIXNmXhc69ADqFTgy86tNxAxzlH4UqK5m3h3Mcy8vccxN2KX+xWKV4kW1la6hacd/z/WmDzBWxCqvh8UGGzBspgg0TNEhRUsOeHCH50Y2JwC8uK6ntQI9v/QzWsEyVVfGHWR5j9v9q68Hw6UTWqx2A6qxVF4UqusyWrjMStsFmnvMjUgdCnwNn2zWj/ibvn0NGfCqw62Sy/kZmdBnAB8awkeIg+V3vEI+yDHcAYjuwQzbvNJwW321WTBJPcpYJLCVjZ4wz04w+ch1f9wAWMzF0CR/y1an5lc2lH8dJuCCKKPI3U6jSsW9JehVVsS+M6I2gP5h1QS1XHmlTVU6DywgiO58Pyi8tTEE9sWnelDnDtS5x3Hrr1LhwRTjQo+82yaOy+b5uVtY8b9vtD8ebl3R4St7LnlBLUd9O9qpxt80eRCB/n3a/FZx4yOJWBN1zASJYcgRu388XNZy2/UoZG0gYxTvHwCCuXB3lP60hOxgDwTkiU
 maPU2RwF
 zARnP6/YUYXwcsLr3H5oySiAG/xw4OEjq+Adw2GYNx+maRCAxXDNnSpG4b1z3seTyJfSGwEjXY/rbiMiVJAMe63vE4fmSSOs3eBYhtlpgNSxmHBOLArIkTRQTar4EbMf8qWT0S2L1Pg1/h60vy4ZFiImB1NvQ3Kl+WqQgHVAcUnpa0bgb3oT+UQGXqs7Ts+xJSLjB4ThkHxY+ceYrd4v7cns/Xa8GF4AdiSHJqlXLdLISLgVwS14LIYosGf5rgbdlvcVVFLj1jra9XEcMTpNZRD8VMCIWdDp9+uE0y5vB3284Jbw/8RN3uB+TVpPMXb2bodb+5DHFaq6cxqq5Y1TSkIcxLgFbfmSel+FB6L3TaQIXppQB6+PENP2Ucb2zHt22QoTYEvDCAbyWk6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/21/26 6:36 AM, Usama Arif wrote:
> On Fri, 18 Sep 2026 10:01:35 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:
> 
>>
>>
>> On 9/18/26 6:37 AM, Usama Arif wrote:
>>>
>>>
>>> On 18/09/2026 02:45, Luiz Capitulino wrote:
>>>> Introduction
>>>> ============
>>>>
>>>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>>>> lacks support for PMD-sized pages, the THP code disables all THP, including
>>>> mTHP.
>>>
>>>
>>> Hi Luiz,
>>>
>>> Sorry for asking this so late in the series, but which CPUs lack support for
>>> PMD sized pages?
>>>
>>> Is this series mainly for PowerPC?
>>
>> No :)
>>
>> The architectures that have conditional PMD page support (ie. discovered
>> at run-time via has_transparent_hugepage()) are x86, s390, powerpc and
>> mips.
>>
>> For x86 for example, even on 64-bit there are cases where the PSE bit
>> may not be present (eg. some errata and by hypervisor CPUID masking).
>>
>> That being said, the main goal of the series is that
>> has_transparent_hugepage() is overloaded: it has different semantics on
>> those architectures and is used to gate all THP support (which is not
>> the right thing to do for mTHP).
> 
> Thanks for clearing that and the patches.
> 
> They all look good to me, apart from the the comment in the last patch.
> 
> Feel free to add
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> 
> to all of them apart from last.
> 
> One nit: I would put the above goal of clean up at the start of the
> coverletter, instead of starting with adding mTHP support for CPUs
> that lack PMD.

Thanks Usama, I appreciate the review. I'll do this if I need to send a
new version.

> 
> Thanks,
> Usama
> 
>>
>>>
>>> Thanks,
>>> Usama
>>>
>>>>
>>>> This happens because the has_transparent_hugepage() helper is overloaded:
>>>> its name implies it checks whether THP is enabled, but on some architectures
>>>> it actually checks whether the CPU supports PMD-sized pages. In addition,
>>>> the THP and shmem code have a big switch on has_transparent_hugepage().
>>>>
>>>> This series solves this by decoupling THP availability checking from
>>>> querying CPU support for PMD-sized pages. THP availability can be checked
>>>> with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE). For querying PMD-sized page
>>>> support, this series introduces a new helper called pgtable_has_pmd_leaves(),
>>>> which is independent of THP, has well defined semantics and can be used
>>>> in fast paths.
>>>>
>>>> Core THP code and shmem can use pgtable_has_pmd_leaves() to determine
>>>> PMD-sized THP support at page fault time (or folio allocation time for
>>>> shmem), leaving THP and shmem always enabled for other THP sizes. For
>>>> architectures and CPUs that do support PMD-sized pages there's no
>>>> intended change in behavior.
>>>>
>>>> We also convert each user of has_transparent_hugepage(), and the related
>>>> helper thp_disabled_by_hw(), to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
>>>> and/or pgtable_has_pmd_leaves() according to the call site's check semantics.
>>>> On s390, powerpc, mips and x86 the arch has_transparent_hugepage()
>>>> implementation is moved out of the CONFIG_TRANSPARENT_HUGEPAGE guard and
>>>> renamed to arch_has_pmd_leaves().
>>>>
>>>> Thanks to David Hildenbrand for suggesting this improvement and for
>>>> providing initial guidance (all bugs and misconceptions are mine).
>>>>
>>>> This applies to mm-new 93f615a22169 ("mm/swap, PM: hibernate: atomically
>>>> replace hibernation pin").
>>>>
>>>> Reporting availability of PMD-sized pages to user-space
>>>> =======================================================
>>>>
>>>> Before this series, not having PMD pages available would shut down THP support
>>>> meaning that /sys/kernel/mm/transparent_hugepage would not be available.
>>>> After this series, /sys/kernel/mm/transparent_hugepage and hpage_pmd_size are
>>>> always available but hugepages-<PMD-size>kB is only available if PMD-sized
>>>> pages are supported.
>>>>
>>>> To me this seems logical, as hugepages-<size>kB is only available if <size>
>>>> is supported. If this is correct, then MM kselftests that depend on PMD-sized
>>>> pages will need to be updated to check for it as they fail with this series
>>>> applied when PMD-sized pages are not available.
>>>>
>>>> The alternative is changing hpage_pmd_size: either don't create the file
>>>> when PMD-sized pages are not available or set hpage_pmd_size=0. My concern
>>>> is that this could be considered an ABI breakage as this file was never
>>>> reported to be optional or report a zero value.
>>>>
>>>> Testing
>>>> =======
>>>>
>>>> - Ran MM kselftests on x86_64 and s390
>>>> - Tested all mTHP sizes allocation on x86_64 (with and without PMD-sized
>>>>     pages available)
>>>> - Tested shmem with within_size w/ mTHP on x86_64 (with and without
>>>>     PMD-sized pages available)
>>>> - Performed defconfig build on x86_64, s390, arm64, powerpc, and mips
>>>>
>>>> NOTES:
>>>>     * I'm forcing arch_has_pmd_leaves() off on x86 to simulate not having
>>>>       PMD-sized pages available
>>>>
>>>>     * Running the MM kselftests when PMD pages are not available causes some
>>>>       tests that depend on PMD-sized THP pages to fail as noted earlier
>>>>
>>>> Changelog
>>>> =========
>>>>
>>>> v8
>>>> --
>>>> - Fixed build breakage on MIPS (Lance)
>>>> - Rebased on top of mm-new (fixed conflicts in include/linux/pgtable.h and
>>>>     mm/shmem.c - dropped a Reviewed-by as a result)
>>>>
>>>> v7
>>>> --
>>>> - Applied on top of latest mm-new
>>>> - Improved various changelogs including cover-letter
>>>> - Changed arch_has_pmd_leaves() default implementation to use IS_ENABLED()
>>>>     instead of IS_BUILTIN()
>>>>
>>>> v6
>>>> --
>>>> - Rebased on top of mm-unstable (required a minor conflict resolution)
>>>> - Added more Reviewed-by and Acked-by tags
>>>>
>>>> v5
>>>> --
>>>> - Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
>>>> - Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
>>>> - Added new patch changing shmem_getattr() to set blksize according to
>>>>     highest supported THP order (Baolin)
>>>> - Added new patches to move has_transparent_hugepage() out of
>>>>     CONFIG_TRANSPARENT_HUGEPAGE guards
>>>> - shmem_allowable_huge_orders(): rename variable and only disable
>>>>     PMD_ORDER (David)
>>>> - Added <linux/jmp_label.h> to include/linux/pgtable.h
>>>> - Added new tags and removed Reviewed-by from changed patches
>>>>
>>>> v4
>>>> --
>>>> - Used static key for pgtable_has_pmd_leaves() API (Lance)
>>>> - Moved shmem pgtable_has_pmd_leaves() check to
>>>>     shmem_allowable_huge_orders() (Baolin)
>>>> - Default pgtable_has_pmd_leaves() implementation to
>>>>     IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
>>>> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
>>>>
>>>> v3
>>>> --
>>>> - Rebased on top of latest Linus tree
>>>> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
>>>> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>>>>     with early_param handlers clearing CPU feature flags
>>>> - Fixed build error with CONFIG_MMU=n (kernel test robot)
>>>> - Fixed huge_anon_orders_inherit default setting when !pgtable_has_pmd_leaves() (Baolin)
>>>> - Small commit changelog improvements
>>>>
>>>> v2
>>>> --
>>>> - Added support for always enabling mTHPs for shmem (Baolin)
>>>> - Improved commits changelog & added reviewed-by
>>>>
>>>> v1
>>>> --
>>>> - Call init_arch_has_pmd_leaves() from start_kernel()
>>>> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
>>>> - Clear PUD_ORDER when clearing PMD_ORDER (David)
>>>> - Small changelog improvements (David)
>>>> - Rebased on top of latest mm-new
>>>>
>>>> Luiz Capitulino (14):
>>>>     docs: tmpfs: remove implementation detail reference
>>>>     mm: shmem: shmem_getattr(): set blksize to highest supported THP order
>>>>     mm: introduce pgtable_has_pmd_leaves()
>>>>     drivers: dax: use pgtable_has_pmd_leaves()
>>>>     drivers: nvdimm: use pgtable_has_pmd_leaves()
>>>>     mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>>>>     mm: shmem: allow THP support determination at folio allocation time
>>>>     s390: move has_transparent_hugepage() out of THP guard
>>>>     powerpc: move has_transparent_hugepage() out of THP guard
>>>>     mips: move has_transparent_hugepage() out of THP guard
>>>>     x86: move has_transparent_hugepage() out of THP guard
>>>>     treewide: introduce arch_has_pmd_leaves()
>>>>     mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>>>>     mm: thp: always enable mTHP support
>>>>
>>>>    Documentation/filesystems/tmpfs.rst           |  5 ++--
>>>>    arch/mips/include/asm/pgtable.h               |  6 ++--
>>>>    arch/mips/mm/pgtable.c                        | 25 ++++++++++++++++
>>>>    arch/mips/mm/tlb-r4k.c                        | 22 --------------
>>>>    arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>>    arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>>    arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
>>>>    arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
>>>>    arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
>>>>    arch/s390/include/asm/pgtable.h               |  6 ++--
>>>>    arch/x86/include/asm/pgtable.h                | 12 ++++----
>>>>    drivers/dax/dax-private.h                     |  2 +-
>>>>    drivers/nvdimm/pfn_devs.c                     |  6 ++--
>>>>    include/linux/huge_mm.h                       |  7 -----
>>>>    include/linux/pgtable.h                       | 21 ++++++++++++--
>>>>    mm/debug_vm_pgtable.c                         | 20 ++++++-------
>>>>    mm/huge_memory.c                              | 27 ++++++++++++-----
>>>>    mm/memory.c                                   | 11 ++++++-
>>>>    mm/mm_init.c                                  |  1 +
>>>>    mm/shmem.c                                    | 29 ++++++++++++-------
>>>>    20 files changed, 144 insertions(+), 100 deletions(-)
>>>>
>>>
>>
>>
> 


