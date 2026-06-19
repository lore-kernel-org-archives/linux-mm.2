Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 346DECD98F6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 02:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F416B00B5; Thu, 18 Jun 2026 22:30:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADFD36B00B6; Thu, 18 Jun 2026 22:30:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DDA6B00B7; Thu, 18 Jun 2026 22:30:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66FBE6B00B5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 22:30:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C970A8D0C0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:30:29 +0000 (UTC)
X-FDA: 84895083378.01.7995ECA
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id D6E1120002
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 02:30:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lknuxpJY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781836227;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWxQsRnQ7R4yFYJGO8X5rI9njC1Ydr1XnXNU26v/VMI=;
	b=VDHxeIDvuNVqBVemDV+aIw99aOfO05IbvVxcB0RLkqlRKdWooJgJHG5w1q6Zk8P8U24ylG
	ETOFgZgzqAItydlUdpm1si+9szFs5ndKai2hsahVwsu2h81B5e8XYB3czP9uLynpfkBIYH
	2P8NKa/PpqFq2rTdhkOFHS13tfpqtKM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781836227;
	b=NQg2MunSM+hk3WfnVFXnaROZtMu1CPzTLY+YvT8ZZs953Oe4CQT4fb6t+fRQgRo/7gO6Ej
	gOGSjDdl02vHpzP/HEx7P8e2B6Jq4a1vJuA3cOGjDCr2Bb3H4zASJSb67tCW2251N3wpfm
	+ZGszQTIA1gYDiqvviIu8K38vYRSGRs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lknuxpJY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51778077b28so16478631cf.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 19:30:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781836227; x=1782441027; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SWxQsRnQ7R4yFYJGO8X5rI9njC1Ydr1XnXNU26v/VMI=;
        b=lknuxpJYpQ5Zo8D9MaOchdPm1fS0Lq8lGeYZ/72A4f4bdAtPrtbvZ2WEaMc3H6Dtc4
         zxiuiQuT9AYEfrQIFiefSY+Q4ZDKv+KdqkZmFj3rUZFn7IACGA5n0oYQfpXNg+RhqVVF
         s1NSy4dxpj675nfz2OnHogNVijJg8c4dbDZ3Pf+BNV3uaG6PKR18pcbCyBVI6jTdMnWA
         YqdIT/SUP1gMCiGbyKSU4gQPr9tMtINZ2z+WevlmL/FEaHcJTjgcngCWB4dZW9nqypAn
         ZqLDqGYzMh+1fly/ctIXh1fiYyEvhaRUFLcfXOmn76ZzWC+9q8x3Qzqa3pAw23wIMdil
         bGXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781836227; x=1782441027;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SWxQsRnQ7R4yFYJGO8X5rI9njC1Ydr1XnXNU26v/VMI=;
        b=PIerF6q0SXDlvIhaJu5sHSlIAN5FIS5HVsZ9YkwKmP8hmGZiJ5XqxOSP5DclW/mzR2
         WnMreDIN1De7PelP9st4PEgDsEUTuKBJnYwym4OsHVVo0R88CyNuVl+xHXwBajDMs6B5
         xQJHT60vpKLfhQeKST6iPnf5JwcRb/U3juTxj4hZQuvf3p5lzZeX40F4ZG0zj+7aAxdm
         Fz5yvkaWes1nYmlXN6w6zquN4cqcVGZhOQRNoeCXNHiQtr6cIlf0ABKbfUETf5YZTqXA
         xgxqlFWi5VKDKanXkHzIpfGHanX2LbziVdlFH2hDgq1w405yJmyNcxBEKbG7ftx6GIBc
         WBVA==
X-Forwarded-Encrypted: i=1; AFNElJ/68SzJAb3MRuajp3iXxc9Sq+rD83ZaLhh8oFxhvEmSYY4LqGDlpofDxvvyINzViE2EDAvCQq1gsg==@kvack.org
X-Gm-Message-State: AOJu0YwFtznRKs9PhrQUH7zuzwJmTSvsoDb68h3yvyP7SjDV9FdY3Kgy
	MTLw7appzMIZJDm8AY2sU1dMQZLel3a9lBZstBB9Spk8GOja8CTOrcUU
X-Gm-Gg: AfdE7clBmqZov2wiRgCPVFsdQIGsRuxopSOrJNewNcvnR6dD/URG+raA/mdItCM1cjW
	37VYtXcFruWcRBmYfyJB7sDALZChj4uV2EAV5TgRrGt++DZb4gKmlEms6pDoGkpRLkDKvcN3Rtq
	lhppe41oiIpxzbfHwXgv/UJJgaM8LzF6U3BceLPmECv+j1NWBS4er+Z3kxMEo86ZKmBi3QyXx3U
	Tc2jJnTLLa2fCE+v64kl8tsIfmfSi/zkOyCsXncx0FHDBDHWgkHjk0+AqoK8aYfAosICS2OlPF6
	b8ap2D7zOPqd9PbtVsgGMBcuWlb6oBz9lwMYs7XvNMS3s2qHAf6UuI4XQv7/yhBD3CGNLo+vKao
	bUw9orhkjvlG2pC8RBKW4rXSYotJLvNn8zqWgUTESWNle9Ks37OteKSHH0wsgw+dAPTf5Ikq76K
	NIKnKW34G3DSsRd9tfJjyAlA==
X-Received: by 2002:a05:622a:1149:b0:517:c65c:488b with SMTP id d75a77b69052e-519e45c2d72mr30506691cf.0.1781836226907;
        Thu, 18 Jun 2026 19:30:26 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-519e60ee850sm9152701cf.24.2026.06.18.19.30.26
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 18 Jun 2026 19:30:26 -0700 (PDT)
Date: Fri, 19 Jun 2026 02:30:25 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
	david@kernel.org, ljs@kernel.org, riel@surriel.com,
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
	jannh@google.com, balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260619023025.vqx2dsitxffuuwh3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616235022.iesy2jeb2p7zof2l@master>
 <20260617023211.80409-1-lance.yang@linux.dev>
 <20260617081815.kq6g3rjtomudxca5@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617081815.kq6g3rjtomudxca5@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D6E1120002
X-Stat-Signature: x4ncrhzxzhyfp9byafn4kecfpwa4x6gh
X-HE-Tag: 1781836227-894904
X-HE-Meta: U2FsdGVkX1/0VNbSaSA3bNEnRVAM/RIeN2TV+Ofo8kdqfLU7z0mzh77Lw2Qbk0GfoVE2u2IEFnvq03mrlpHoL0YB0j0J0yKyWQCWLsbyl0uzu2Ly6UPNWxv7tkYcY1zuimWAhwGnJ7/WAsK6guNsFy640ujVOkt+ifaP/HKZBQBEdoFd9zUsTsCPJSgqPL1UFkcAn52ndYFydbhCHdo51trVywFO+K6mQEez6u1hil0PMNsW73X7xwkoHL9Wz3ZKenAgtqUKYf9yuSv2RUomNqq/LdAqqmcTTDlr3VnEXxTYRulDAbmaTYjXIn3WHApdS0aiJ08boF8ysNu8g3BzR43xPTDmZ83pSsGbKiiBWt1JtmfBBq6DyqqAc71vZydIU3KNoNvr7bP/do5ynaZpWzr7Z3Glsmqp/GBO6ayU+iaIj0NsxxzCjrE5y79kTEx3CiI9S1snQsSHsfCpXkTk0+HGkgXssG+1ZJ6LkgJzAKEt2RksjQB/v2C79nSxvIJ9KPtbABOAB5pgXU90lOvqX5TyGO5dpMVHjiZRsrNc2e1UhlxQXfTJFxBQQ3dICmvVZZOTHZC6tjD/AbbxQbPTNPAd4pZQx7fKD+/XvmeaRb8BNSJtg+vLUeVWNbc+e4EUaGgFvpMB2EUCa52fu7VmdFXcDNhXg8hq3VyTxKBpU7/T1BGcx81TnTxZ6rPIkqfMd1nUcAH+/YdQBrGj1ShKJ6HcTgUtv9HF2pG3Wsqvp3gpqBFK9zbziVfWuP5QZ2Ev9IQearuyay7LevzQbqtIj98nTeILQWyjNp3thLJpF4EcSjf+iUC3h1sam9EaGyOdg1w8NGB6g59oy5vZQSMn8Bcgzxdv5gBtJLPJ+hd3O1y4LnFnoNNEh6j/sVhO+/jdU6Q0eW+AxT1ECrDb5U8f8GGB/nO6sOmJu621T/NsY/UDMuABn/KhJc+mPIG14tGYQHKUdlxxaFOcN7sN91/
 IYHNt6tK
 pD1imaKiRESFBxqm/LNqcX87cARcfZHtqP9dLstx+//grue3dpBmkAMgfMqVxusVMWwou2t7GZj64kCUVyWyUgq9TIU7tbo3ntyjHnYw2fF71siWtCaWtgOdXpGYfN+ipFv/J7v4I7pgHvBL4UB2o5dMD2tqDYnk00kvQiGqbcTE2SImr47ZeCymLjqh2udJLJLzixDYCWr69wg7AAPTvDr4RC3/VC0RyP0KFdrIVOOwXHpHN/l1UpWFWI9eUuhkUaOyj48y57W5ARKjLMI1LnbPzOhvFNtiXq6Hs5CCpWVJq52bdb3h4RV5nFEK8hPk7XKLyp9WpaRsp2REnCNMKpw2ksZYYMOSYFojbpxytushIMyn5dLbdHMduAXWF7o9Dmw06yPBE1wVI30rDRqDYuUwMoV8nuJpVS5Nj6pt/8yP22b0ghihlxplXVBbURAPn8LdWF7BV1GtQF51GzKEIEB1YwqakbIYB5C+nV/m6VHJrkEqrLT8ZXXAopb/Vgn0LkutgLXKDiL20qtEkvXGD++VC8orsr0KBtSJxzkJzPS3usESllLo3vbTbTcGI5cKVFQ2arkYbBmAWEARnvRIQ6z0gayLW2JIpZsar7rdat/f+dY3jqOG39SwNkHw6dONmi40siCNJ2epkL2nTPpAO3LNXOnvq5cGN8mRfsBoXVGtQrf+8YLUiX8S7dyF7bCieVWt4nRdy8pN71+8gpHcDpjxOu5IaASUQct4iAsYLokhrHbTshP1cZifKvn4wpVAvtgyf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 08:18:15AM +0000, Wei Yang wrote:
>On Wed, Jun 17, 2026 at 10:32:11AM +0800, Lance Yang wrote:
>>
>>On Tue, Jun 16, 2026 at 11:50:22PM +0000, Wei Yang wrote:
>>>On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>>>>
>>>>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>>>[...]
>>>>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>index 2ccbabfb2cc1..21635fab209c 100644
>>>>>--- a/mm/page_vma_mapped.c
>>>>>+++ b/mm/page_vma_mapped.c
>>>>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>> 		 */
>>>>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>>>> 
>>>>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>-			pmde = *pvmw->pmd;
>>>>>-			if (!pmd_present(pmde)) {
>>>>>-				softleaf_t entry;
>>>>>-
>>>>>-				if (!thp_migration_supported() ||
>>>>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>>>>-					return not_found(pvmw);
>>>>>-				entry = softleaf_from_pmd(pmde);
>>>>>-
>>>>>-				if (!softleaf_is_migration(entry) ||
>>>>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>>-					return not_found(pvmw);
>>>>>-				return true;
>>>>>-			}
>>>>>-			if (likely(pmd_trans_huge(pmde))) {
>>>>>-				if (pvmw->flags & PVMW_MIGRATION)
>>>>>-					return not_found(pvmw);
>>>>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>-					return not_found(pvmw);
>>>>>-				return true;
>>>>>-			}
>>>>>-			/* THP pmd was split under us: handle on pte level */
>>>>>-			spin_unlock(pvmw->ptl);
>>>>>-			pvmw->ptl = NULL;
>>>>>-		} else if (!pmd_present(pmde)) {
>>>>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>-
>>>>>-			if (softleaf_is_device_private(entry)) {
>>>>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>-				return true;
>>>>>-			}
>>>>>+		if (pmd_present(pmde)) {
>>>>>+			if (!pmd_leaf(pmde))
>>>>>+				goto pte_table;
>>>>>+			if (pvmw->flags & PVMW_MIGRATION)
>>>>>+				return not_found(pvmw);
>>>>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>+				return not_found(pvmw);
>>>>>+		} else if (pmd_is_migration_entry(pmde)) {
>>>>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>+
>>>>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>>>>+				return not_found(pvmw);
>>>>
>>>>Looked at history a bit, and I wonder if this changed something old
>>>>here ...
>>>>
>>>>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>>>>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>>>>including not_found() cases. So lockless PMD read was just a filter ...
>>>>
>>>>With this fix, true case gets final pmd_same() check, but this
>>>>not_found() case happens before taking PTL.
>>>>
>>>>So a !PVMW_MIGRATION walker could race with someone, e.g.
>>>>remove_migration_pmd(): we make the not_found() decision from old PMD
>>>>value that still says "migration", while real *pvmw->pmd may already be
>>>>present again. We return without ever taking PTL :)
>>>>
>>>
>>>Hi, Lance
>>>
>>>Thanks for take a look.
>>>
>>>I am trying to understand the scenario you mentioned. Let's say A migrate a
>>>pmd and B want to unmap the pmd.
>>>
>>>            A                                        B
>>>
>>>  try to migrate a pmd
>>>  pmd is set to migration entry
>>>                                           unmap the pmd ...
>>>  managed to finish migration
>>>                                           ...still see migration entry,
>>>                                           so skipped and unmap fail
>>>
>>>Would this be a timing case? Even B grab the PTL, it still could see migration
>>>entry if B visit pmd before A finish migration.
>>>
>>>Maybe I miss something, look forward your insight.
>>
>>Right, seeing migration entry while migration is still ongoing is fine.
>>
>>What I meant was this ordering:
>>
>>  CPU 0: pmde = pmdp_get_lockless(...); /* migration */
>>  CPU 1: remove_migration_pmd() restores PMD to present
>>  CPU 0: returns not_found() from old pmde, without ever taking PTL and
>>         rechecking *pvmw->pmd
>>
>>So issue is not seeing migration entry itself, but making final
>>not_found() decision from stale lockless PMD value ...
>>
>>Before this patch, PMD migration case took PTL before making that
>>decision ...
>>
>
>Yes, this patch changes the decision making condition for pmd entry. Thanks
>for pointing out.
>
>Hmm... I took another look into current pte handling and find for pte entry,
>we did two phase check:
>
>  * map_pte() without ptl
>  * check_pte() with ptl
>
>While check_pte() do extra pfn range check, map_pte() doesn't.
>
>This means for pte entry, we may face the same situation as you describe: 
>make the decision before grab PTL. Till now, it looks reasonable.
>
>But one thing jumped at me, PVMW_SYNC. When this flag is specified, all check
>is done under PTL. But now for pmd entry, we don't have a chance to do so.
>
>And as the comment says in try_to_migrate_one()
>
>	/*
>	 * When racing against e.g. zap_pte_range() on another cpu,
>	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
>	 * try_to_migrate() may return before folio_mapped() has become false,
>	 * if page table locking is skipped: use TTU_SYNC to wait for that.
>	 */
>
>I tracked down to commit a98a2f0c8ce1 ('mm/rmap: split migration into its own
>function'), but not getting more detail on reasoning. Not fully understand it
>yet, but it seems there is some race between migration and unmap which is
>protected by PTL?
>
>Will look into this to get more detail.
>

After going through the history, I found this:

   commit 732ed55823fc3ad998d43b86bf771887bcc5ec67
   Author: Hugh Dickins <hughd@google.com>
   Date:   Tue Jun 15 18:23:53 2021 -0700
   
       mm/thp: try_to_unmap() use TTU_SYNC for safe splitting

This one fix the race mentioned above: we expect mapcount is 0, but is not.


IIUC, if we apply the change in this patch, the affected case is
pmd_is_migration_entry(). In case someone else has cleared it but not update
mapcount yet, try_to_migrate() would return before folio_mapped() is false.

Thanks Lance for raise the question.

If above analysis is true, I haven't got a neat way to take this into
consideration.

BTW, for a fix, I am thinking to keep it simple and direct. So how about leave
the refactor as a followup cleanup?

-- 
Wei Yang
Help you, Help me

