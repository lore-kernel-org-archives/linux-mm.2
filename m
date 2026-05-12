Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40432CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:35:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C876B008A; Tue, 12 May 2026 10:35:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DD2E6B008C; Tue, 12 May 2026 10:35:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CC3B6B0092; Tue, 12 May 2026 10:35:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A2E06B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:35:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D2D51A04E0
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:35:47 +0000 (UTC)
X-FDA: 84759016734.25.A818038
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2064118000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:35:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CRcadGLv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596545;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FZWzQImWOyWQ14r2Z/b/dDDI7psqgO5EhZ1ndo1M8aw=;
	b=lhbDXe/bMD1UkRlpv3VQ6p0tkFGKOmI1nruJWYbX1yXp126qmmN4tad1NIS5uuNOlNlstE
	hFC0opYZpFIoypUJ1H3Mm592J5XtFSbgfk8JPT7vlYhAV+KI08jRZdQ+4PijMrZSues95I
	T7A7eW6Nuw9UzyxsPu0d6IHzbJK+z8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596545; a=rsa-sha256;
	cv=none;
	b=onpDfiRjcMNQr6DLJJPTvqnH7MtAlMRnjHwVnLX6HWCDsyF+5mRoVc6h5aU1TCZXAIedF3
	z7+v637UCVKCa8IQnarGP8a7uMvD/6s4G4Ld8+wApYnKnWn1u4kvWqfYFjLWabIPkBBJTe
	uPXsuZQk7CCaofxh0KESl0lhRDIhaVo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CRcadGLv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-488b8bc6bc9so35253825e9.3
        for <linux-mm@kvack.org>; Tue, 12 May 2026 07:35:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778596543; x=1779201343; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FZWzQImWOyWQ14r2Z/b/dDDI7psqgO5EhZ1ndo1M8aw=;
        b=CRcadGLvvih5mdd1IMxMa6bB2HkdOCv0Pp6QdJMhaD8GhyCxGElKmEBa6PZwUotZsu
         ED0Xu1t0HR2Xj+G2nmqoZMM7Pc8K9XwgPwSJQeFg9V9W7nuuqwgayPBsfYCIgEXYGxvm
         ibd3DmwworUTREOfetgUf/uDyaHcQJI9V4Qs++S0S1FnNPKDYYMFL1G89a9CE1D9jUrj
         kJXLrFGgpTxq6u0p3dyagXGNxHwANkgs/jOnTP9yiT1tUolEaHQgoJtSjdVvzWpaQjd+
         CjnwRyCqz5S2ee2XKkdcJp/QxCSdM1NjQRqgNlxTJc0DgJYvty8b8u7RzNF1Uwl0N7Un
         ONWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778596543; x=1779201343;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FZWzQImWOyWQ14r2Z/b/dDDI7psqgO5EhZ1ndo1M8aw=;
        b=j3VG16Tbs2z2ucMfubiMe1qIiXBfOOBRMOE90btJxq3bZdH2PnhDjTbzhrjWH3PMPL
         L+82HH3yW0E3OsWv8hrJO5Hk3BVCxqB2jpQL6q7XtKKb8f3PRXfZ46o9n+8a0b/aT5NL
         sn6gbxrTRGdIXlk8GtNHWJxZCSmsvsDNpcp6RiYc02GAzUyTDO8YRoGbseGOOmrYw5h5
         uOwmU2PNPWlQaqFRwNjLS2Jhx55VFlExgC3UuBEraT8pG41CodaYd6RfBjcUTrSgU4fS
         GKjtLOwLpdejYbbgAEe0p7pbxsM+K667A6mR+cdMJQre1Gb24liSBr2iwA0KBOK5opu/
         kXXw==
X-Forwarded-Encrypted: i=1; AFNElJ91qx4yZL5FkekxN1sS0joqxoVNMwyGXwIAzPFl/QKsnN9iyGjHLywUhJEuuWtE0+iVxdElKjOFLA==@kvack.org
X-Gm-Message-State: AOJu0Yw5kawd3ABdOKYKpsUBQHlMgsynCvRUVj9OaX+KvU4mPaYtVOtz
	wpdMZGBHXzgl/s+rvRQqum9bAISh62AU+xfEvhDKnZoaCd8slmBiIcbl
X-Gm-Gg: Acq92OHYVFZPArM/fOytHI+vTKfO+FCf1iTWFZiqW+Q+0xC5QO7JzGS6Hw62k5zXg6s
	GCY+Hk+LsdkW6iTEYUW4grD5kC2DMro3aKurSHHwINgzZrOEnsafX+V+vf8RU0xi6g3iNWoeiLU
	zcd99zW2PC17CAgBQ1xhP9qUtpS5Eo272JaGUZf3xRGmJ3f9F05Gba6o08KkeeZsDqi4ppZ43L5
	uOeJ35pyRKf9RIBAUs5UD1uXO9UDU36CSXUkBjjs38UYcT/1A8374po1Z5NYS/EjYwSnPwQOWez
	h+aGToCmgld7NabIf2yNyUT63huxj8puUXIRfjMsfNXNhDM7Uj2DiSsD4gIF6a7adxDY69tFE3N
	fgYYwSTiWzRPyN1tBby2hbQhbLUbvVvHmVa+GMTtBPgRtLGOomTeM285XETdekLw0IS3dtrR8Ze
	S3gSaaX4X3gOghosn70Qusow==
X-Received: by 2002:a05:600c:a11a:b0:48e:635a:18d2 with SMTP id 5b1f17b1804b1-48e8fe4dc0bmr38431565e9.2.1778596543205;
        Tue, 12 May 2026 07:35:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fc8cd49fesm3135415e9.0.2026.05.12.07.35.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 May 2026 07:35:42 -0700 (PDT)
Date: Tue, 12 May 2026 14:35:42 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, sj@kernel.org, ziy@nvidia.com, linux-mm@kvack.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260512143542.izpp3gu4iqxttw3f@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260508013728.21285-1-richard.weiyang@gmail.com>
 <5e9ee072-b927-41e0-ba98-c9fdf11eccbc@nvidia.com>
 <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0aab59b8-71c5-4059-8281-5dd876946528@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2064118000C
X-Stat-Signature: emtojsgcao8mnhnunb5repx1ieuj65fc
X-Rspam-User: 
X-HE-Tag: 1778596544-937966
X-HE-Meta: U2FsdGVkX18yWEWPKZY7lZMBVW+pIWm5NEAOCh1SMPejvfXupFOWnMbEAwqgRDRNewIylRtXrqUNEzPDgL7Xw003sHj+OxL8Kgu+i0JXbNHadYXIJSbm/UIxGozTN7zTKrUP9brtXlTJZDJHnehau6im2niWuAaOrykhOsjaxRJZnpoUIRF5uyri4lF46oWZp4MQVTJBbtqzCUQmzeojwR3Yx6tCTY4CM9jZzBqY8a0QMHghd+Mc0N39osASuZxM1tUHIgzOCZ/FP9YkBp8wrhkKD1O1gmPYF14qYfr14oaxta0GiUFI5p2mePscX7D9tVrMGT/Hydjn1f/3m4p9UFb2hjLYUdVHjjlZf5+pTjY2mk4FBjZoMFUvuPiWHpy52vF+IAb+f1WuxdIMJ6+mv1e0tXQ06GPEsRXIFvwDX7P/uwbHDfmbUomOG1oQmWrgMHiyhsvtaSVi1S325LCHNCABbEXaXnCzhWVfhpNEHKqN0ZQUt2VxERXHATCcHyhcNiKU1BXK+e2Y2u7CQx1UTrGW+pGBULAqTepfx/yM3Xu6N5RQgb9e9jguIx2k1Nmc9VrLDlFoO8SwxKoeIaWjzT0LHDGLa+gsU07tPjLLOw1oD8h6wH/r9NNCvbCQ47MWP2dVpaYMpdU2P3WTqelJgiwSfLj6ue/j2Vc6vnF4WtlqDkeZid0Sa2ea0cyGR0I3sHZZVvnauxCZ1LkkJEvX99B0LUI2O8LaWQme3emiT5sW6w5j1Yw4WF+wg7mSNkHRs3cUZV+i3T6cxZzI8aNyGWDIiT9KgjSCfMVJRCiYHEBDE0hQZqruQDjM9/AhenPKJPwGODXXW7+BmR3eWifaRkoIPwLqkNcRIKGNWiJhXFDZ3jSBXhmTjPsH9xrSLT6eGRoS54vtmGAcLQs+E18F81MkgrP3JPzfO7OAe4HV9Tga/TPzq03cQd61A598qKDc5DQZgpXRDWX/b9L7336
 lYDEO2yi
 gB5Gy7wfLZzGXIXro224q8qLgJhGW3eU4pN1XtZup5NWB60SdEPTJPxlcL12ThFMkUB8ux6VPc513K9wK91NiaRKEGp8nxdpXF5vjx1EHExxPUQgF9xzVNXhAhdDn1yrbXC9uqGey47cNavJ3J53YqNpVMKs6N8PeHBeZM9uA5RX3bDjOCr2w9px+nFsB0LW0v8WnrGVdp+6zMQvj+fV1q1RbYpP147V10I9wnQ8AeU9eM60shs6ls5N7xdoYcVYhCHryvZalAiXcIAEB/GYmy+v+2L3JlubvrfgP2LfYh3GbN5NSmgFZM9lZIWwOHQ9weo3Abr+M+cGxCjfHPhbZSlk6UO6TlhnJMd77Bv39rg4Umb3oIBpdKs3CaDIpZCF/DVW7a63v0RwD5Qpoq+Lp0jwvcHNlzjEESw21+MHyw6n4lMVFkoLRr+8oUhvZ7E0T/8N6jFkVnRRpg+MuVRNR57ANlP3j5MEg3X6157515nG4Iak5EYs6iby4SqBU2cpZdUrkE+9vrQMn1OVWI7qNqCH/T1lItRr1MI8pBc+RPimwbcNlr9Ib1RomoykkF2atxh3zwY+myuMpn7OsJdphIFTi0l04DXXfRsaDDshhbhMNRtkEVVdBl/p/SjfsvC45DRvWd/dGb99x2yav6JcvYMBCWMFAYsmZReYkg1QgSTOCXyjRWa7pzJdzXFlDhBhRTlZgnNDyu3J2MR/LitNn+9TsASb9ObOG9HttjaFZTHyQoTxe+wEMJAQx8A1+npjTANBsbCZ+O+C//4VY95U04/TDF8/+8jnrdZZJnwdMw25GCss1D7XXEfMc43UPgqK1csTprzLLdD+H7h0983Vf2ulfj5MkaLb8vvFjc3LstcQmZmTEtC4SlmlKPv3L1NH42cgun/2lexJbeG2oABseY1VyFTDpeavENkWU2rlBxU9iFHu8UUf5wDAwpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 02:43:54PM +0200, David Hildenbrand (Arm) wrote:
>On 5/9/26 00:48, Balbir Singh wrote:
>> On 5/8/26 11:37, Wei Yang wrote:
>>> For pmd_trans_huge() and pmd_is_migration_entry(), we does following
>>> before return the pmd entry:
>>>
>>>   * re-validate pmd entry
>>>   * check PVMW_MIGRATION
>>>   * check_pmd()
>>>   * handle on pte level if split under us
>>>
>>> But for device-private pmd, we just return after pmd_lock(). This may
>>> lead to inproper situation.
>>>
>> 
>> Could you elaborate a more on the improper situation?
>> 
>>> This patch fixes commit 65edfda6f3f2 ("mm/rmap: extend rmap and migration
>>> support device-private entries") by following the same pattern as
>>> pmd_trans_huge() and pmd_is_migration_entry().
>>>
>>> Fixes: 65edfda6f3f2 ("mm/rmap: extend rmap and migration support device-private entries")
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Balbir Singh <balbirs@nvidia.com>
>>> Cc: SeongJae Park <sj@kernel.org>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: <stable@vger.kernel.org>
>>> ---
>>>  mm/page_vma_mapped.c | 34 +++++++++++++++++++++++-----------
>>>  1 file changed, 23 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>> index a4d52fdb3056..5d337ea43019 100644
>>> --- a/mm/page_vma_mapped.c
>>> +++ b/mm/page_vma_mapped.c
>>> @@ -269,21 +269,33 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>  			spin_unlock(pvmw->ptl);
>>>  			pvmw->ptl = NULL;
>>>  		} else if (!pmd_present(pmde)) {
>>> -			const softleaf_t entry = softleaf_from_pmd(pmde);
>>> +			softleaf_t entry = softleaf_from_pmd(pmde);
>>>  
>>>  			if (softleaf_is_device_private(entry)) {
>>>  				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>> -				return true;
>>> -			}
>>> -
>>> -			if ((pvmw->flags & PVMW_SYNC) &&
>>> -			    thp_vma_suitable_order(vma, pvmw->address,
>>> -						   PMD_ORDER) &&
>>> -			    (pvmw->nr_pages >= HPAGE_PMD_NR))
>>> -				sync_with_folio_pmd_zap(mm, pvmw->pmd);
>>> +				entry = softleaf_from_pmd(*pvmw->pmd);
>>> +
>>> +				if (softleaf_is_device_private(entry)) {
>> 
>> Do we need to check softleaf_is_device_private() twice, can't we hold the pmd
>> lock and check once?
>
>I think what we try to do here is, is to only grab the lock if we verified that there is something of interest in there.
>
>I wonder if we should rewrite that whole thing to just do a pmd_same() check after grabbing the lock.
>
>Something a lot cleaner like:
>
>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>index a4d52fdb3056..de6a255cc847 100644
>--- a/mm/page_vma_mapped.c
>+++ b/mm/page_vma_mapped.c
>@@ -242,40 +242,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>                 */
>                pmde = pmdp_get_lockless(pvmw->pmd);
> 
>-               if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>-                       pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-                       pmde = *pvmw->pmd;
>-                       if (!pmd_present(pmde)) {
>-                               softleaf_t entry;
>-
>-                               if (!thp_migration_supported() ||
>-                                   !(pvmw->flags & PVMW_MIGRATION))
>-                                       return not_found(pvmw);
>-                               entry = softleaf_from_pmd(pmde);
>-
>-                               if (!softleaf_is_migration(entry) ||
>-                                   !check_pmd(softleaf_to_pfn(entry), pvmw))
>-                                       return not_found(pvmw);
>-                               return true;
>-                       }
>-                       if (likely(pmd_trans_huge(pmde))) {
>-                               if (pvmw->flags & PVMW_MIGRATION)
>-                                       return not_found(pvmw);
>-                               if (!check_pmd(pmd_pfn(pmde), pvmw))
>-                                       return not_found(pvmw);
>-                               return true;
>-                       }
>-                       /* THP pmd was split under us: handle on pte level */
>-                       spin_unlock(pvmw->ptl);
>-                       pvmw->ptl = NULL;
>-               } else if (!pmd_present(pmde)) {
>-                       const softleaf_t entry = softleaf_from_pmd(pmde);
>-
>-                       if (softleaf_is_device_private(entry)) {
>-                               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>-                               return true;
>-                       }
>+               if (pmd_present(pmde)) {
>+                       if (!pmd_leaf(pmde))
>+                               goto pte_table;
>+                       if (pvmw->flags & PVMW_MIGRATION)
>+                               return not_found(pvmw);
>+                       if (!check_pmd(pmd_pfn(pmde), pvmw))
>+                               return not_found(pvmw);
>+               } else if (pmd_is_migration_entry(pmde)) {
>+                       softleaf_t entry = softleaf_from_pmd(pmde);
>+
>+                       if (!(pvmw->flags & PVMW_MIGRATION))
>+                               return not_found(pvmw);
>+                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+                               return not_found(pvmw);
>+               } else if (pmd_is_device_private_entry(pmde)) {
>+                       softleaf_t entry = softleaf_from_pmd(pmde);
> 
>+                       if (pvmw->flags & PVMW_MIGRATION)
>+                               return not_found(pvmw);
>+                       if (!check_pmd(softleaf_to_pfn(entry), pvmw))
>+                               return not_found(pvmw);
>+               } else {
>                        if ((pvmw->flags & PVMW_SYNC) &&
>                            thp_vma_suitable_order(vma, pvmw->address,
>                                                   PMD_ORDER) &&
>@@ -285,6 +273,15 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>                        step_forward(pvmw, PMD_SIZE);
>                        continue;
>                }
>+
>+               /* Double-check under PTL that the PMD didn't change. */
>+               pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>+               if (pmd_same(pmde, pmdp_get(pvmw->pmd)))
>+                       return true;
>+               spin_unlock(pvmw->ptl);
>+               pvmw->ptl = NULL;
>+               goto restart;
>+pte_table:
>                if (!map_pte(pvmw, &pmde, &ptl)) {
>                        if (!pvmw->pte)
>
>
>
>
>There is likely room to clean this up / compress it further.

I tried to compress above logic like this, hope it could look cleaner.

	if (pmd_trans_huge(pmde) || pmd_is_valid_softleaf(pmde)) {
		unsigned long pfn;
		bool is_migration = pmd_is_migration_entry(pmde);
		bool for_migration = !!(pvmw->flags & PVMW_MIGRATION);

		if (is_migration != for_migration)
			return not_found(pvmw);

		if (pmd_trans_huge(pmde))
			pfn = pmd_pfn(pmde);
		else
			pfn = softleaf_to_pfn(softleaf_from_pmd(pmde));

		if (!check_pmd(pfn, pvmw))
			return not_found(pvmw);
	} else if (!pmd_present(pmde)) {

>I'll note that this now also adds proper check_pmd() checks to pmd_is_device_private_entry().
>
>The not_found(pvmw) if check_pmd() fails is rather weird ... but likely this works because
>THPs can really only be mapped through one PMD, and we always will look at the right spot ...
>
>-- 
>Cheers,
>
>David

-- 
Wei Yang
Help you, Help me

