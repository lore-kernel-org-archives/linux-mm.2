Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 770F1CD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 02:02:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31D56B0005; Fri, 19 Jun 2026 22:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE1126B008A; Fri, 19 Jun 2026 22:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B83F46B008C; Fri, 19 Jun 2026 22:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 718DE6B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:02:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB432C2BAE
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:02:38 +0000 (UTC)
X-FDA: 84898641996.19.BD92BFB
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F97240006
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 02:02:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ax5/4LZ7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781920956;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UGv+Ltfx7xpehBvF7h2TbxSb0mrqZVXeNckTo1OWitc=;
	b=jj+I+cYkkWpFIleaHyyQgzNPMeF+SBCLs1bUI2Ogg4wHZ34MlQMkHw2aS09rJaKc2OInxL
	mai2kvWyFdfcdNKhrnEwhIhQU8cCfAlo2+NozOYOQMjULL47J0aF6ddgaLqW64OQwXj6Av
	2sSyaBs+DDH582e2y6EIfdJLkKl6RPM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781920956;
	b=bD7RVYkUPxo8HJP/vxbjvl3alvxVMj7eNJGVrAmhf4ejY/JyEETodbZ97klw5+Z99KvJ0i
	2URWnkuUGhDeUBNKS4sXSQm6ZlH+JO6oI7GM+mylB78T7+oem38FRH04QyBYJLcRysWQMI
	vWWELiUmfTHd0QynF9TyYdki0puHnJI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ax5/4LZ7";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c07ea058c1aso399595866b.2
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781920955; x=1782525755; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UGv+Ltfx7xpehBvF7h2TbxSb0mrqZVXeNckTo1OWitc=;
        b=ax5/4LZ7tQGRkDCvpPdiFQhkMu3QbCalKedoo3zWHHFSAAdflvcb8dNH1AMMWRsFIl
         XwiOYe3QvegaIiCnJV9D11fziD2o2H7N6hIrdUJ9kIWy8AhZlntqgzvCQSG6p8tVLP9v
         erN3GACxipVKCmNcPK+/kEFOjmcVM/RDpsobUqetJE++Q3toy2PTvY5+5WqiAEPjSdiF
         MSo6/RLUPoFp7tEtXl/iG/TbSpeFNr8FGSnmvVnBOVfZDgFRle3vx+Wi3k2M9uyKRjM2
         KDZcdJsL0MaBKc74vKHIm/LKaqSxuy0V31lPkqVDRTctefIwrpBIuPauKb8w1ExbEWHt
         7LkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781920955; x=1782525755;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGv+Ltfx7xpehBvF7h2TbxSb0mrqZVXeNckTo1OWitc=;
        b=kKBCTa0zg+l7CVFjTrd3MWxBsMW56v4Xpnb8SJ2lywsUcOt5F/4NCk1fL9So1O7SBy
         ZRuMOWOxD561WTN8CLtNYxGp7qreonWsCwyQNVq+ofLUaM8an4HP6lyloUUdUVVYNBb2
         BcJ81nADXSxaEcDJ82OGsiyj4NyX+CSTi/oFxM6SFU5oJaX957GaVO/DlVj9CtMUBUnA
         OClqt+rdIAMl5K4D/lpJcnz63Msf6MRhvF5XTi2w17Sfn1Nhy8Nkw04nB60aexIZl2dK
         /eG21alW82YV3ANh0jXiyvlsE1PjXJ2oxiUOyLsAjI1Aeyw8VFzr1gbwfQCzb8wbRiut
         kvVg==
X-Forwarded-Encrypted: i=1; AFNElJ8mDmjk0JYThz6pnR6wWmCqxtcWa4LoDeo52JBnRbZU+z6kFRdUvRNagL61i5cR8sfS9NnjtllRXw==@kvack.org
X-Gm-Message-State: AOJu0YxBwolbE3BufSlwoJ0nw6UqRJbhoHXf0jioSEbWR+s3P6JUBlNE
	RSFnLcWyE+o9l34Ee6jfVaI6l1HkFYTQwiw2Qh2W9YmVt8dLhnZkCPvD
X-Gm-Gg: AfdE7cmAItG+890NwoRDGlKWNRpwgi+ypCSRkPY0ouvUm1cxKBU/a7dWuWiNrCAxTD5
	uZVDv9rjVDsKUN/yK9mm3CUH2Pe6lT31J/gGoOKyanf/HKhCIvryKwut+/qKAREURItd4Sxda9P
	gIwKpnon/qi23sGH4gr7zBUEY1zIStU8QwdtGaTaElkxIicrPN+mwel4yV53j09GXx5k6xn6hTt
	mO1/OS8Openj38n2FF5FulgLgXNx8VapDI0plUhu3CN9FtRCGsMjSrvXgabGvPTnn7sli/1//z/
	R2htwXFXbx1Z+02Pz8jVZSzu+AmqcJ33uluzCShTFa08u1qkSLs+2McI7LjtaqF9CTAIxmmBqLk
	JOGniTo5ZLuvj8nprnEnrg0ry1i0a8vFVhOaCqXnakYWWVDuA+IIA9w/lpmylKZfOiKi8IG+YVx
	oaxLnHXt+9DK6tv0d+bzBsZQ==
X-Received: by 2002:a17:907:3f96:b0:bec:2a21:785c with SMTP id a640c23a62f3a-c097b080e9amr309603866b.23.1781920954647;
        Fri, 19 Jun 2026 19:02:34 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c5e49a9fbsm46361166b.12.2026.06.19.19.02.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Jun 2026 19:02:33 -0700 (PDT)
Date: Sat, 20 Jun 2026 02:02:32 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260620020232.53ifdvjnypcz55ot@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260619023025.vqx2dsitxffuuwh3@master>
 <20260619121909.90510-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260619121909.90510-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 9F97240006
X-Stat-Signature: 3dfiwapt3jbwigw6ji9h8e976ay391ai
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781920956-138447
X-HE-Meta: U2FsdGVkX1+fNz8Fkj0rcmSmM2eB/ZXYEGh0XTXJiCT9ORpYaFku/lItJvipcpI99i8ESx4XGR/7QiGrzoZV7C4KyMoB0yFCjjbbzfhZhZaf8SjM566HXdNBLwUdDSGBEW+EMu+lyQMDHXfiE36/ISIPCENc0+ErNjcSsthvVaQSu0Iknpdkv/7iTtj6w2TYCiK9cFvr2WyOAUOCJtbwCfDHcOjeQS/O2JDmaiZyBeDazEljH+R6YoROkA9kwPkGdzQtHKy36noP3BBRfcwkxxhVBP3lyd4DWvVwaP3M42uNib5Ng2K4cQ53yclW1OFDhJrjLyngMabn1MyWD8oRuHKNgjSuVcgKqYT/6pOgzHCbIiVgUmou9lsQUz5KuHQuGLS4Qsd12dOqYFbtxVk4Loew6ruQ5kE8bg3ffX3hDmuW3PNLP2MVLjqXZCA6dFo1/8mg4otxpbpoh5afMPJym4CXxW5biewoppCQF2DjpZ/Hz8WSHaQpdM8JQkBbFL2oI2+xHOqWGS+v1NK2+nWKKCr/388sLxfitzVCgoWbq8eWstNHC+2K56pE6+GdknFidpr9C/9RvOIqJcqgMHTdUlyXeioTYXYD1sML4mZAlXAxbhLrGEaD5PFVloNlKAV8uCKoi6U9EuKuf+3a7kFe6W2foe6jtvrikatv9ltiItnaHBRta42ODiSEASs2xvywVUDaY8/e9rzr4PoMhD2KGaUomf0iUsVBchHtsXe31N5NQGqk2v0vPn5s4HZli4Be/0FPabQn7r9Gqn0cgmvcD7+FtjRgqluGj6fUBkIzSnNGBHTajU6uy5v+I3AUUALKZIsHaUhRh1ncONKQvnbElkgjazHT9e4dEUQopHcIJ20U8lkCA/kgZlUuaXLmr9ZCRksO2bqJrDarscAgefkgp5TomFitvWq4aEp87eOPU8P+oi1WWbj/Cw7PMr/ZadMyOEDw8bpSoyo1sAEV+Jl
 p/o0KYB2
 yepd11zPernpnedSwdaUvqNbOoCkqkbQXIw5Tuw2b4sKX0z9DjlJw+r0wC7J0HW8Ssxz3RSYOjIWoTrenAQyUMK5HQBs3XrCisekfs82P+O546d5Rdwafm2BybC9S15koQFajTaet1kvPhbY85LVTyv86v4eeuYNEJcJPIxlpGMHUqTvMkeF88S9bVvOOmGpJbiGpV94vIqiw4zyMPSACovxsDQ5w7QQoKWsZShZx+BxNQSei9G7ooK7wG8jHEeQ8fcpgbldengyKWjrtR5STz/bskxy7nGp0xB3tJ+O5Nv/4X+gCDZAZrJDkmSTzy5jscUNHdi6ligaM7ExturYapYG2WzmJA0rYXtfOmg0xQpHT2vfuAZHab9D1x9h1J16i7gbQL0A8rAj5EsnwIntT+0j+vDFg9WFOKKpM6WbIJtZu1FFx8LpxmjLXMMmcjSOs2bfJuG1WZWGPsB64KdrmcG1xTIXyw9XuR7MwdKjDibvvNCT12kTL8lo15nS7Jz8w5YOVTi1vPl6nx+SWExNhvPh8bxvLN3mBrYomWF0DLg/0KNlt2PagzTVNlnyt9SpCO9rM6UnfSVxATRaYFwlJJNq17Unp1XiiMBFY318wu45/MsB9l4bKubrQZF5SqpnUPqqqIwn2O/T/XVKYQDks8rATXzrS/YcKwFlcCVFJuSKlhVXyyJTX4W9tpm1F3EoPJ2amdtucxGne+6v0FbJBmvr4+aBOYckOK/UlBwBXuqmlZ17Z3xtSF0LZiyMa4IBD0APDFHHa2ci2GfkZSd8lG1Z+habCCybSHuZMV+LmpcbDEeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 08:19:09PM +0800, Lance Yang wrote:
>
>On Fri, Jun 19, 2026 at 02:30:25AM +0000, Wei Yang wrote:
>>On Wed, Jun 17, 2026 at 08:18:15AM +0000, Wei Yang wrote:
>>>On Wed, Jun 17, 2026 at 10:32:11AM +0800, Lance Yang wrote:
>>>>
>>>>On Tue, Jun 16, 2026 at 11:50:22PM +0000, Wei Yang wrote:
>>>>>On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>>>>>>
>>>>>>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>>>>>[...]
>>>>>>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>>index 2ccbabfb2cc1..21635fab209c 100644
>>>>>>>--- a/mm/page_vma_mapped.c
>>>>>>>+++ b/mm/page_vma_mapped.c
>>>>>>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>>> 		 */
>>>>>>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>>>>>> 
>>>>>>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>>>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>>>-			pmde = *pvmw->pmd;
>>>>>>>-			if (!pmd_present(pmde)) {
>>>>>>>-				softleaf_t entry;
>>>>>>>-
>>>>>>>-				if (!thp_migration_supported() ||
>>>>>>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>>>>>>-					return not_found(pvmw);
>>>>>>>-				entry = softleaf_from_pmd(pmde);
>>>>>>>-
>>>>>>>-				if (!softleaf_is_migration(entry) ||
>>>>>>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>>>>-					return not_found(pvmw);
>>>>>>>-				return true;
>>>>>>>-			}
>>>>>>>-			if (likely(pmd_trans_huge(pmde))) {
>>>>>>>-				if (pvmw->flags & PVMW_MIGRATION)
>>>>>>>-					return not_found(pvmw);
>>>>>>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>>-					return not_found(pvmw);
>>>>>>>-				return true;
>>>>>>>-			}
>>>>>>>-			/* THP pmd was split under us: handle on pte level */
>>>>>>>-			spin_unlock(pvmw->ptl);
>>>>>>>-			pvmw->ptl = NULL;
>>>>>>>-		} else if (!pmd_present(pmde)) {
>>>>>>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>>>-
>>>>>>>-			if (softleaf_is_device_private(entry)) {
>>>>>>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>>>-				return true;
>>>>>>>-			}
>>>>>>>+		if (pmd_present(pmde)) {
>>>>>>>+			if (!pmd_leaf(pmde))
>>>>>>>+				goto pte_table;
>>>>>>>+			if (pvmw->flags & PVMW_MIGRATION)
>>>>>>>+				return not_found(pvmw);
>>>>>>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>>+				return not_found(pvmw);
>>>>>>>+		} else if (pmd_is_migration_entry(pmde)) {
>>>>>>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>>>+
>>>>>>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>>>>>>+				return not_found(pvmw);
>>>>>>
>>>>>>Looked at history a bit, and I wonder if this changed something old
>>>>>>here ...
>>>>>>
>>>>>>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>>>>>>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>>>>>>including not_found() cases. So lockless PMD read was just a filter ...
>>>>>>
>>>>>>With this fix, true case gets final pmd_same() check, but this
>>>>>>not_found() case happens before taking PTL.
>>>>>>
>>>>>>So a !PVMW_MIGRATION walker could race with someone, e.g.
>>>>>>remove_migration_pmd(): we make the not_found() decision from old PMD
>>>>>>value that still says "migration", while real *pvmw->pmd may already be
>>>>>>present again. We return without ever taking PTL :)
>>>>>>
>>>>>
>>>>>Hi, Lance
>>>>>
>>>>>Thanks for take a look.
>>>>>
>>>>>I am trying to understand the scenario you mentioned. Let's say A migrate a
>>>>>pmd and B want to unmap the pmd.
>>>>>
>>>>>            A                                        B
>>>>>
>>>>>  try to migrate a pmd
>>>>>  pmd is set to migration entry
>>>>>                                           unmap the pmd ...
>>>>>  managed to finish migration
>>>>>                                           ...still see migration entry,
>>>>>                                           so skipped and unmap fail
>>>>>
>>>>>Would this be a timing case? Even B grab the PTL, it still could see migration
>>>>>entry if B visit pmd before A finish migration.
>>>>>
>>>>>Maybe I miss something, look forward your insight.
>>>>
>>>>Right, seeing migration entry while migration is still ongoing is fine.
>>>>
>>>>What I meant was this ordering:
>>>>
>>>>  CPU 0: pmde = pmdp_get_lockless(...); /* migration */
>>>>  CPU 1: remove_migration_pmd() restores PMD to present
>>>>  CPU 0: returns not_found() from old pmde, without ever taking PTL and
>>>>         rechecking *pvmw->pmd
>>>>
>>>>So issue is not seeing migration entry itself, but making final
>>>>not_found() decision from stale lockless PMD value ...
>>>>
>>>>Before this patch, PMD migration case took PTL before making that
>>>>decision ...
>>>>
>>>
>>>Yes, this patch changes the decision making condition for pmd entry. Thanks
>>>for pointing out.
>>>
>>>Hmm... I took another look into current pte handling and find for pte entry,
>>>we did two phase check:
>>>
>>>  * map_pte() without ptl
>>>  * check_pte() with ptl
>>>
>>>While check_pte() do extra pfn range check, map_pte() doesn't.
>>>
>>>This means for pte entry, we may face the same situation as you describe: 
>>>make the decision before grab PTL. Till now, it looks reasonable.
>>>
>>>But one thing jumped at me, PVMW_SYNC. When this flag is specified, all check
>>>is done under PTL. But now for pmd entry, we don't have a chance to do so.
>>>
>>>And as the comment says in try_to_migrate_one()
>>>
>>>	/*
>>>	 * When racing against e.g. zap_pte_range() on another cpu,
>>>	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
>>>	 * try_to_migrate() may return before folio_mapped() has become false,
>>>	 * if page table locking is skipped: use TTU_SYNC to wait for that.
>>>	 */
>>>
>>>I tracked down to commit a98a2f0c8ce1 ('mm/rmap: split migration into its own
>>>function'), but not getting more detail on reasoning. Not fully understand it
>>>yet, but it seems there is some race between migration and unmap which is
>>>protected by PTL?
>>>
>>>Will look into this to get more detail.
>>>
>>
>>After going through the history, I found this:
>>
>>   commit 732ed55823fc3ad998d43b86bf771887bcc5ec67
>>   Author: Hugh Dickins <hughd@google.com>
>>   Date:   Tue Jun 15 18:23:53 2021 -0700
>>   
>>       mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
>>
>>This one fix the race mentioned above: we expect mapcount is 0, but is not.
>
>Cool, thanks!
>
>I do want to spend more time on this refactor. It is touching some subtle
>page_vma_mapped_walk() rules, so I don't want to skim and guess ...
>
>One case I can pin down now is device-private: the PTE side gives us a
>clear rule to compare against :)
>
>On the PTE side:
>
>1) PVMW_SYNC set, PVMW_MIGRATION set
>
>  map_pte() uses pte_offset_map_lock(), so it takes PTL first.
>  check_pte() then runs under PTL. Since PVMW_MIGRATION is set,
>  check_pte() requires a migration entry, so device-private is rejected.
>
>2) PVMW_SYNC set, PVMW_MIGRATION clear
>
>  map_pte() takes PTL first. check_pte() then runs under PTL.
>  Since PVMW_MIGRATION is clear, device-private can be a normal mapping,
>  but check_pte() still checks entry type and PFN range.
>
>3) PVMW_SYNC clear, PVMW_MIGRATION set
>
>  map_pte() first does a lockless read. A non-present, non-none PTE can
>  still be a candidate, so map_pte() takes PTL. check_pte() then rejects
>  device-private, because PVMW_MIGRATION requires a migration entry.
>
>4) PVMW_SYNC clear, PVMW_MIGRATION clear
>
>  map_pte() first does a lockless read. A device-private PTE can be a
>  normal mapping candidate, so map_pte() takes PTL. check_pte() then
>  checks entry type and PFN range under PTL.
>
>On the PMD device-private side, before this patch, all four cases go
>through the same code once the lockless PMD read sees a device-private
>entry:
>
>- lockless read PMD into pmde
>- pmde is non-present
>- decode pmde as a softleaf entry
>- entry is device-private
>- take pmd_lock()
>- return true
>
>So compared with the PTE side:
>
>A) PVMW_SYNC set, PVMW_MIGRATION set
>
>  PTE rejects device-private under PTL.
>
>  PMD returns true.
>
>  This does not match. The PMD code misses the PVMW_MIGRATION direction
>  check, and does not reread/revalidate PMD under pmd_lock().
>
>B) PVMW_SYNC set, PVMW_MIGRATION clear
>
>  PTE can accept device-private, but only after locked check_pte()
>  validation.
>
>  PMD also returns true.
>
>  The direction is OK, but the final check is missing. PMD returns true
>  from the lockless PMD classification, without PMD revalidation and
>  without check_pmd() PFN-range check.
>
>C) PVMW_SYNC clear, PVMW_MIGRATION set
>
>  PTE can reach locked check_pte() from the lockless candidate, but
>  check_pte() rejects device-private.
>  
>  PMD returns true.
>
>  Same mismatch as case A: missing PVMW_MIGRATION direction check, and no
>  locked PMD revalidation.
>
>D) PVMW_SYNC clear, PVMW_MIGRATION clear
>
>  PTE can accept device-private after locked validation.
>
>  PMD also returns true.
>
>  Direction is OK here as well, but the PMD code still has no final
>  locked check matching check_pte(): no PMD reread/revalidation, and no
>  check_pmd() PFN-range check.
>

Thanks for the detailed analysis.

>>
>>IIUC, if we apply the change in this patch, the affected case is
>>pmd_is_migration_entry(). In case someone else has cleared it but not update
>>mapcount yet, try_to_migrate() would return before folio_mapped() is false.
>>
>>Thanks Lance for raise the question.
>>
>>If above analysis is true, I haven't got a neat way to take this into
>>consideration.
>>
>>BTW, for a fix, I am thinking to keep it simple and direct. So how about leave
>>the refactor as a followup cleanup?
>
>So for a fix, let's line up the PTE and PMD rules first :D
>

Sure.

Based on your above analysis, looks the change in v1 [1] is the right
direction, IIUC.

So I will send v3 based on this with comment adjust according to Lorenzo's
comment.

[1]: https://lore.kernel.org/linux-mm/20260508013728.21285-1-richard.weiyang@gmail.com/

>Cheers, Lance
>
>>-- 
>>Wei Yang
>>Help you, Help me
>>

-- 
Wei Yang
Help you, Help me

