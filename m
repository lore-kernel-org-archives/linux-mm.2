Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77709CD3442
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 07:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1DF46B0088; Thu,  7 May 2026 03:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEB56B008A; Thu,  7 May 2026 03:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD916B008C; Thu,  7 May 2026 03:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEF16B0088
	for <linux-mm@kvack.org>; Thu,  7 May 2026 03:57:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 07A2C1C0E44
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:57:05 +0000 (UTC)
X-FDA: 84739868010.23.8B7CF7F
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf19.hostedemail.com (Postfix) with ESMTP id D7E871A0002
	for <linux-mm@kvack.org>; Thu,  7 May 2026 07:57:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vse98iuF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778140623;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0agWKanvAyq61LGD/L2X+iCr+SiGgxdDdUDpBphxVc=;
	b=ZD4jXtXp6R9M0OFC1sJJviI2GH1RASYX3IgNI5glD8waQrFK9YWHJfJPwIFbTHWn8HV6Gx
	UECoe4rRpEblTJPFG/yVn+UqlPm5tv/fpHwamIOGHpX0GidQtLntxAYioVtYR9YypppcT3
	VWtMsIM7CVTGiOlPYxcraShLCujobUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778140623; a=rsa-sha256;
	cv=none;
	b=pRurlSP05GpMnu4kOs9ShacpM8V9WwabRr1Aec1bBsOxdWJ4CojmgUc0Ht4pxNAzbSpCCE
	aaZy5H0u5AfPpRT3rjmyLT4ggG2clKuOzJkWjaFrsqAJSAxuA9SouxAUbL2sI04NifK8n7
	AGpgIe8JexzXZieCWEkIH6PBn4wbyPQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Vse98iuF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso6124715e9.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 00:57:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778140621; x=1778745421; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x0agWKanvAyq61LGD/L2X+iCr+SiGgxdDdUDpBphxVc=;
        b=Vse98iuFDbnw3E/tF+OdOQa0l43ZynUS+w1x+uIdt0oa6zBXUlx477uQ48bdO3kV9Z
         FvtMLucf+LMKjkZ9IpnHaYCoh+zTCfMqaxthI2vIBD57I6FW+H3TMHd9MTmxGc4POct3
         vovKDgR+ua20ODKNn5LJJgKz3ej/nqmiIc0q5iuClOJme0BznbFKZ4tCHi5CJIPXQ+1f
         nmvNSy6d7k5TaOVeaLsIVRs0lGYcW4oC2grwnOlkeVgu3kNr0/Jf4IuKPNCuqXJ4CLxH
         7HzU2avmh18lJ4kUFFOfA4sp6vxfJVgs2P/MeL12sKB8QBJXGrb68P16BHrT06xWTu0F
         0IDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778140621; x=1778745421;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x0agWKanvAyq61LGD/L2X+iCr+SiGgxdDdUDpBphxVc=;
        b=gsoq8kRmQejIaNET6cNfdboXbewsfRJSScQfzm35zXVvE/xpjZMdicGl7tvHBpGHSu
         O3bWXVibm/HaDBLMRzNno/VKobv97OjSkcM34vFWRGI6IdUwansnfS4Ab4p55PwrYB+5
         ywJ+qagMKMN5NXe4Wnd3tA2k1SkgNyajIJ1Cy7KhUHtwmj7KyU9rurbZtI1GdnAccEfa
         82vf6aTMH9Y/aURHlz56J4ZGh2p7NwPgTDDReUN4aIASdd8c7OqeHGUOc1z4mlnEJOWw
         izoS7qiA9ItQcs1Xk2cZFQI3hRxYwrVm1fvw4goQUJ+0zwifCUhK/LrZ6xuhaAVxdpIq
         Drwg==
X-Forwarded-Encrypted: i=1; AFNElJ8KkmdIbl2YFT+cylkmE7lQKS1Wx3i2kNn9mIb4yo0C624d5rRIxYCuFPK87sXeU7p/F7Dhd/cLXA==@kvack.org
X-Gm-Message-State: AOJu0YzReUgL9cT1CXLFM3xAYk648KL24y3KakEkaroRmwDHqrm40FTR
	EbtpbEaUGrXBi3xIJEndv8ZgqEouP9rf8VNYRLyQiGMb2NpKKea2kLbs
X-Gm-Gg: AeBDieu6VEvMwUDreApBahUOz/RXTOtN5KP+Nd5VsFMMKS/rv8hHx7mC+SIjPWL+3Un
	xxb7tEAPZqHia94iFJy4Qwaid6wo5a4AxxyI9E1VBHHM2tq4wEp3n7NGhzPc7LDDtLNuEMneoXI
	bw4e6O1oRuL2uSFB2kqLO4sS4i+0yEHSbnPeDdy/F34+a7GrHBXV5Ts/3c1HmCUPVl7VXENwsch
	xr/S50KgJgnfWkxlawWeLfUeCuiuWGwxgpLLPAvDjsKE5bHcWOXyzshFrCvGoVHxQ6Xrx0eLkiH
	xJ4wBFHE7BEHQPs2/O0Nb0bQ8fXG2EO3VWjGr6fYtqs1SakrS14TO+H5Na+31PK49oGCgdyqmhD
	heDfUfrHz4vQyPzzHDhnZTSHUWKI8kHfbhSUfERhSnftT5s1PCJ1GRreX04+EVtj4PbBu63z4Ho
	n6DjIogg1hVPwR2cePNa8oyhF08f7w8pI4GpMPc4/dZgc=
X-Received: by 2002:a05:600d:18:b0:488:b811:51c4 with SMTP id 5b1f17b1804b1-48e51f3c4f4mr85509295e9.25.1778140620808;
        Thu, 07 May 2026 00:57:00 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e5389da63sm106218795e9.4.2026.05.07.00.56.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 07 May 2026 00:57:00 -0700 (PDT)
Date: Thu, 7 May 2026 07:56:59 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
	ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
	riel@surriel.com, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, shuah@kernel.org, linux-mm@kvack.org,
	Gavin Guo <gavinguo@igalia.com>
Subject: Re: [PATCH 1/2] mm/huge_memory: return true if
 split_huge_pmd_locked() split PMD to migration entry
Message-ID: <20260507075659.mverdcmofmoymtmf@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260415010839.20124-1-richard.weiyang@gmail.com>
 <20260415010839.20124-2-richard.weiyang@gmail.com>
 <79e164a2-47ce-4a02-82f5-164515760b6d@kernel.org>
 <20260426091957.a227zxgkqapibtud@master>
 <c71930ae-19d9-4b3b-a74d-3de3261c4d43@kernel.org>
 <20260429024913.iepoi7cit3xnwca2@master>
 <413feed4-6aab-43d9-b7e5-a9386fa79f4b@kernel.org>
 <20260503003818.t35q5roc7osx6se2@master>
 <ccb23360-d257-491e-926e-2a7f7b9c98c6@kernel.org>
 <20260505031514.hlnn5o7wkad4teo2@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260505031514.hlnn5o7wkad4teo2@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D7E871A0002
X-Stat-Signature: w7zig1hfxypory78zq4w7zk7yaqh4wrs
X-Rspam-User: 
X-HE-Tag: 1778140622-366437
X-HE-Meta: U2FsdGVkX19UmollZv8oarWPpTgysWLFKXCgxZKc30D53SMNe8p1M5f88cM15/u92sQOZxRAIHJHCYIRUOUO5YFr8EiBaiMc9utJN/KKYGkITaMn0yGzLa0nnHksw6rAdwWTx47F8NX1+ukZe/N3UZeYE2kCAs93NHppdrOt7Lvh2Ldyvtwl9s4MhI8SExgi6Dv2f/OHNQoqwJFf8SaE/qkQ46u0gtzdVoaweFBg9rcT3UO9u6GIkWuw/ELuSPDJfQH/+xWmrt56gvZVi2RQsprgnG355lyq39n4gpV5EudvP0qcA+3AOtnjWubUqv8i3Y3Hle3BrvIG8pQqb7Pa9vM3TE++EBz3buoHxZ2ah7fmUEOW1X1zvkZW1PJyoPUlIuNUJ7+eiLh/yWicSXci8NovgWvwBFYZIZr5eLDOa47BqILUr6OcN1DPVhgm677dzqPCBvrVlW7itHBLJKFBvosUDnwzpfLaktTbvbH1SmS6ZYkYqwwRTFMu2TKFlUjQf2nG6tsYuakLdxKrTHdbA69GgnQwcAQvAbXfzWJ53q8n9aNILvmiptvnjZ3qkRUtzznYNb7wW93YJeB4H+k0M3XRqnW1lTMvAsSH+1cuM3ZX6Nkcvg2GzW3hWHDyG0HKUoz1BanKqwfUbOvRn8H12lXk/91O2I1h/74BIdtJOrwUWxuBtOrMY34mVY/v4yaUnw56Dp4zXfG0DwV6GR/KM3qpCO30qBtzTx/o6bZNvfeUI++5z7DlUYCF8LPAQCpLh8PF05JfSof3Is1EV7pIcL8Rei/22NfV6vupR9YnT3Cq8Zg2bKj/bNvOWSzRQtgIy4Vk4C0BHQ3zz80mwLSpnkkZX+EMHhBTfK0gyePu2ciQH4Z7SvqeMitqYrO0hJKWJZQXdXK6IF6rRX5t1ToTfiOVXykgqG4PrJFcOZ1cXw7+UMvs4foTRfLriOu2HgCdgoe3f56ZPB+8pFL+rKL
 7eQF7Cc5
 6HdakTxAlXk87TN/xj7ggDt6Q88zCCGlUy+fEQ1fn74xFKDkEttD+dn9OvNL0emaaC/8l2F+vfs5d4YL5PerG8PHubYJ3fDvVxFKBBZywLsswqv86LRhnmsZf5o1UFa0Db5/yOv+1eyFqLbLQuzG50L4u3DgHWYUqJpD/w0dBq9RCXnILdywBW+McxAriSmZK4JMDdawOhy86kyN6Gotfwx74/UhXfCyIVorILqQzhtlA66pwenzXPW9ylLsCkErF/pJ11uiqK9dd29sheLcq1VMrPsWpHGb3wgiqGw6JZUiYmhFxWEQcVP9rszO8aRJgWI5DeBpK+IAX7WLmo93k1GHXfXmMwTt3Jbw5Oz5gV9SJnPxcz4rb6HhRUDsqliB9b+XtNrdmUj74mW2AiybPKAixDrRgYAK95e+N8dPxqvP+KSAROrQth09QhPzriK8TZgK5vYAVe4Wi9PYzTxVx573Nt6de4T/fYXMjKHqzmcKB/JLEfEcbugrte8Dc57gFnFfU4FsG6ZPbEqrUZyrwW31/f0wG8ZrmYwDmKZIt56476V1snJTpJJi17rcuI4CCiZnjaSe5YPm+j7dbYDohcCfBWdwtMUdKbXslWbzGNLcFdOQv5nLirpUC4xsuDT6q/LtzOv77XnZL6hsrf7qHeVsxIRyNGI7d0kf1T5tvu0C0rOZqXnovdsuXYhqfV57O32DgKZn59e9+wl2G3DdjrKORp0FnRYQvgnW7GCnboFq4w4KtUBrTrhAi17GjG6+ZUtdrd5XsOjD7yS0+J1uRiqHeGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 05, 2026 at 03:15:14AM +0000, Wei Yang wrote:
>On Mon, May 04, 2026 at 02:44:43PM +0200, David Hildenbrand (Arm) wrote:
>>On 5/3/26 02:38, Wei Yang wrote:
>>> On Wed, Apr 29, 2026 at 08:55:07AM +0200, David Hildenbrand (Arm) wrote:
>>>> On 4/29/26 04:49, Wei Yang wrote:
>>>>>
>>>>> Below is my proposed change:
>>>>>
>>>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>> index a4d52fdb3056..6e915d35ae54 100644
>>>>> --- a/mm/page_vma_mapped.c
>>>>> +++ b/mm/page_vma_mapped.c
>>>>> @@ -273,17 +273,21 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>  
>>>>>  			if (softleaf_is_device_private(entry)) {
>>>>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>> -				return true;
>>>>> +				if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd)))
>>>>> +					return true;
>>>>
>>>> As we have a softleaf entry, I assume we wouldn't expect to get any other bits
>>>> (access/dirty) set until we grab the lock. Verifying
>>>> softleaf_is_device_private() again would be better cleaner, though.
>>>>
>>> 
>>> Got it.
>>> 
>>>> But really, I do wonder if we should just have a "goto retry" back to the "pmde
>>>> = pmdp_get_lockless(pvmw->pmd);" instead?
>>>>
>>> 
>>> Sounds reasonable. See below.
>>> 
>>>>
>>>> And now I wonder why we don't have a check_pmd() handling in there? :/
>>>>
>>>> Should we check for the pfn here?
>>> 
>>> Thanks for pointing out. I think you are right.
>>> 
>>> After re-read the code, more questions come up my mind. I am afraid we need
>>> more cleanup for page_vma_mapped_walk().
>>> 
>>> Below is my finding based on current understanding:
>>> 
>>> 1. thp_migration_supported() seems not necessary
>>> 
>>>    The code reaches here means pmd_is_migration_entry() return true, which
>>>    means CONFIG_ARCH_ENABLE_THP_MIGRATION is set, otherwise
>>>    softleaf_from_pmd() should return softleaf_mk_none() which is not a
>>>    migration softleaf.
>>>    
>>>    CONFIG_ARCH_ENABLE_THP_MIGRATION is set in turn means
>>>    CONFIG_TRANSPARENT_HUGEPAGE is set, so thp_migration_supported() must
>>>    returns true.
>>> 
>>> 2. if migration entry change under us, we may need to handle on pte level
>>> 
>>>    In pmd_is_migration_entry() -> !pmd_present() branch, we have:
>>> 
>>> 		if (!softleaf_is_migration(entry) ||
>>> 		    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>> 			return not_found(pvmw);
>>> 		return true;
>>> 
>>>    But I think we need do this:
>>> 
>>> 		if (softleaf_is_migration(entry)) {
>>> 			if (check_pmd(softleaf_to_pfn(entry), pvmw))
>>> 				return not_found(pvmw);
>>> 			return true;
>>> 		}
>>> 
>>>    Per my understanding, if the pmd_is_migration_entry() change under us, we
>>>    need to handle on pte level. Just like pmd_trans_huge() case. Break the
>>>    loop and return false seems not consistent.
>>> 
>>> 3. add proper check for device private entry
>>> 
>>>    For device private entry, currently we just grab lock and return. While
>>>    according to the handling to pmd_trans_huge() and pmd_is_migration_entry(),
>>>    we should:
>>> 
>>>      * re-validate it is still device private entry after pmd_lock()
>>>      * check PVMW_MIGRATION
>>>      * check_pmd()
>>> 
>>> 4. consolidate pmd entry handling
>>> 
>>>    Per my understanding, there are 4 cases for pmd entry handling:
>>> 
>>>      * pmd_trans_huge()
>>>      * pmd_is_migration_entry()
>>>      * pmd_is_device_private_entry()
>>>      * !pmd_present()
>>> 
>>>    Now we handle them in a mixed state check, which complicates the logic. And
>>>    the first three share similar logic. (If my above analysis is correct.)
>>> 
>>>      * grab pmd_lock()
>>>      * re-validate pmde
>>>      * check PVMW_MIGRATION
>>>      * check_pmd
>>> 
>>>    Here I would like to take a more bold step: consolidate handling for these
>>>    three cases.
>>> 
>>>    Below is what it would look like.
>>> 
>>> 	pmde = pmdp_get_lockless(pvmw->pmd);
>>> 
>>> 	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
>>> 		unsigned long pfn;
>>> 		bool is_migration;
>>> 		bool for_migration;
>>> 
>>> 		pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> 		if (pmd_same(pmde, pmdp_get_lockless(pvmw->pmd))) {
>>> 			is_migration = pmd_is_migration_entry(pmde);
>>> 			for_migration = !!(pvmw->flags & PVMW_MIGRATION);
>>> 
>>> 			if (is_migration != for_migration)
>>> 				return not_found(pvmw);
>>> 
>>> 			if (pmd_trans_huge(pmde))
>>> 				pfn = pmd_pfn(pmde);
>>> 			else
>>> 				pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));
>>> 
>>> 			if (!check_pmd(pfn, pvmw))
>>> 				return not_found(pvmw);
>>> 
>>> 			return true;
>>> 		}
>>> 		/* THP pmd was split under us: handle on pte level */
>>> 		spin_unlock(pvmw->ptl);
>>> 		pvmw->ptl = NULL;
>>> 	} else if (!pmd_present(pmde)) {
>>> 		if ((pvmw->flags & PVMW_SYNC) &&
>>> 		    thp_vma_suitable_order(vma, pvmw->address,
>>> 					   PMD_ORDER) &&
>>> 		    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> 			sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>> 
>>> 		step_forward(pvmw, PMD_SIZE);
>>> 		continue;
>>> 	}
>>> 
>>> 5. use "goto retry"
>>> 
>>>    As you mentioned above. Instead of "handle on pte level", go to
>>>    pmdp_get_lockless() for retry. This looks more reasonable to me.
>>>>
>>>>> +				/* THP pmd was split under us: handle on pte level */
>>>>> +				spin_unlock(pvmw->ptl);
>>>>> +				pvmw->ptl = NULL;
>>>>
>>>>
>>>>
>>>>> +			} else {
>>>>> +				if ((pvmw->flags & PVMW_SYNC) &&
>>>>> +				    thp_vma_suitable_order(vma, pvmw->address,
>>>>> +							   PMD_ORDER) &&
>>>>> +				    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>> +					sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>>> +
>>>>> +				step_forward(pvmw, PMD_SIZE);
>>>>> +				continue;
>>>>>  			}
>>>>> -
>>>>> -			if ((pvmw->flags & PVMW_SYNC) &&
>>>>> -			    thp_vma_suitable_order(vma, pvmw->address,
>>>>> -						   PMD_ORDER) &&
>>>>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>>>> -
>>>>> -			step_forward(pvmw, PMD_SIZE);
>>>>> -			continue;
>>>>>  		}
>>>>>  		if (!map_pte(pvmw, &pmde, &ptl)) {
>>>>>  			if (!pvmw->pte)
>>>>>
>>>>> After this, we could simplify the logic in try_to_migrate_one() as:
>>>>>
>>>>> @@ -2471,14 +2471,10 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>                                  * so we can detect this scenario and properly
>>>>>                                  * abort the walk.
>>>>>                                  */
>>>>> -                               if (split_huge_pmd_locked(vma, pvmw.address,
>>>>> -                                                     pvmw.pmd, true)) {
>>>>> -                                       page_vma_mapped_walk_done(&pvmw);
>>>>> -                                       break;
>>>>> -                               }
>>>>> -                               flags &= ~TTU_SPLIT_HUGE_PMD;
>>>>> -                               page_vma_mapped_walk_restart(&pvmw);
>>>>> -                               continue;
>>>>> +                               ret = split_huge_pmd_locked(vma, pvmw.address,
>>>>> +                                                     pvmw.pmd, true);
>>>>> +                               page_vma_mapped_walk_done(&pvmw);
>>>>> +                               break;
>>>>>                         }
>>>>
>>>> Right. But just to be clear: Let's split the page_vma_mapped_walk() validation
>>>> (which looks like a bugfix to me) from the other optimization.
>>>>
>>> 
>>> Sure, maybe we can split the page_vma_mapped_walk() cleanup out to another
>>> patch set for better reviewing?
>>
>>Yes, but I assume it could even be fixes?
>
>Agree.
>
>For those above proposed changes, #2 and #3 is proper to be fixes.
>
> 2. if migration entry change under us, we may need to handle on pte level

When preparing a fix for this, I can't find a bug case.

If a pmd migration entry split under us, it becomes a pmd_present() entry.
While the related check is in !pmd_present(). So the split case is not
affected.

There is one little behavioral change in commit 616b8371539a.

  Before commit 616b8371539a, when pmd_trans_huge() is zapped after
  pmd_lock(), it still continue on pte level and then return false.

  After commit 616b8371539a, zapped pmd_trans_huge() is caught by
  !pmd_present(), then return not_found() directly.

But I can't say this is a bug.

After all, I would put related change to cleanup instead of bug fix.

> 3. add proper check for device private entry
>
>The corresponding commit to fix are
>
>   commit 616b8371539a6c487404c3b8fb04078016dab4ba
>   Author: Zi Yan <zi.yan@cs.rutgers.edu>
>   Date:   Fri Sep 8 16:10:57 2017 -0700
>   
>       mm: thp: enable thp migration in generic path
>
>   commit 65edfda6f3f2e58f757485a056e4f1775a1404a8
>   Author: Balbir Singh <balbirs@nvidia.com>
>   Date:   Wed Oct 1 16:56:55 2025 +1000
>
>       mm/rmap: extend rmap and migration support device-private entries
>
>As Andrew suggested, I would send fixes and cleanup separately.
>
>After all these settled down, I will respin this thread.
>
>-- 
>Wei Yang
>Help you, Help me

-- 
Wei Yang
Help you, Help me

