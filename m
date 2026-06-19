Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23489CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 12:19:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12E926B0088; Fri, 19 Jun 2026 08:19:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF806B008A; Fri, 19 Jun 2026 08:19:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F128D6B008C; Fri, 19 Jun 2026 08:19:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C421E6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:19:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43524C1DE0
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:19:33 +0000 (UTC)
X-FDA: 84896567826.11.E200926
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A55A20006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 12:19:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SYHIcvZi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781871571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dLm3urJYs5AqA6zRwvG9Uk+mzQxTsxzJze3iYFghqEc=;
	b=EVpXCjwrtBFexuiObDeqOij80jBeZIs3IOThQID0B0dXdMzJYRuKHhbj1V0w6kXgErtQcd
	ypz3e1/zI1YGN+AeXU+f40skRWRhysdr3or1Mqep5sGG26jqdDfgALgKNWdM8q4hWknWoz
	mvQdCBmYYD1XqfR4RX6nhJS00QsUHE0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781871571;
	b=0wbi63d/2dBkkuKoyLmqK5RYqk6mM+CR7OqKc/12wDI5dIbHATZIxkDhhZAB/q42BPXkdQ
	zqZhoAoI1g3S319UZ5QGXeU73EJhnnACdkfQfjuK2NVHdNpoNgsIQvvz9kaO2FkWC8Fsfc
	ajreVNBOZzctWn89b59DfTjg7mzyeUk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SYHIcvZi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781871569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dLm3urJYs5AqA6zRwvG9Uk+mzQxTsxzJze3iYFghqEc=;
	b=SYHIcvZiwt9Zl68PpyP3bg+XFvc+XdLp7zeGn6eskBJ+tAdJdOUp/LdciSnR683a5vNCDj
	pFiY0QDo9Ns9Nh46Bko1USgKKqh2jJQtbIUeVp7zhhi9qj3NPju/qYoxadx8g5rbBm+By9
	CT8eI/4HA8WsjAE7Vsvq1yXMAM86iPE=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	balbirs@nvidia.com,
	ziy@nvidia.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Fri, 19 Jun 2026 20:19:09 +0800
Message-Id: <20260619121909.90510-1-lance.yang@linux.dev>
In-Reply-To: <20260619023025.vqx2dsitxffuuwh3@master>
References: <20260619023025.vqx2dsitxffuuwh3@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A55A20006
X-Stat-Signature: g5djxut7erkuogzjr6p6ag3z638rp5eu
X-HE-Tag: 1781871571-768529
X-HE-Meta: U2FsdGVkX1/Z6evbeQXcVZUvBcW6aZDIdstEyXqhL1DVtdNamoNuMDkaiaIONUV7p+LQ4jm/7auEzfbcADwVHJ/UFJzvP8d18w7W5aUJca8YVP9kOuP/lo05EPZ2rjkEkgqiM0moz1HqV395BVKULTz61SbxO0i9G6Te7LxqNsmfuUbmMAcnDMa7NrQ94mo09BaON8hdyQdSOUoE8xeggmU2ymZvOC9tG24U9YzKPaBS1spMFocXtEDZiF3pP2uzf8drU7x4UWkoHUq8XRSDEPHheMDwe52GyommzXCp9mNCKYXFY+I900LI7iohyjVICM+UkfWPFUBsX0wX7SLV+SFZ8MI64FkAF0QazIvuSv6w2tSlRHIHL0nRjzHii26SI0A0cuMnzBE2zqADOxFeDLqaWX/8Kbb6CjB6a3aCCwPqvrhhTlw4dUfhFU1BOcnYy4Cm6w2RdCuUGwNxYrjWITDNxc0UrIawOGLXrz0CWIcvH6dXYThb9AxQcxwNMKBRseRw2VnVIlQYfoDhOh2PnILkadq3k8+r1JlQjGZFw+suTkr/FmPRdoGbH5YALS8LiZq7oe954QE7xb/UALmnBmqlZYMwGsrdMohh5VuTEpDLDvloIz5wj0Yc490OBsR+CoW1j4S45B2QTcXsie6ISdWxwhw6fOH2F4FS5OD4JtncyzAGEZsLynD34T2R5g92BYAFqUm/MBEwflawa6k6LPGoHM3VaNlfOfBvOQjjIMQKfqpFMmXdE9uMNzN3ALj1m+yJFpT4+mGRP94AQZEbjSRprx1Z8IiQMO/BINFN1Om1FzdoGwNg29EBRdmSZwv9Dr7dP+keRB0VETdbammjfLy8YorB3oJmIJcnREudra6Kck0nv99ODoRw49PSsKgwCmDozuN+gLkPXWfAeR+0zab/7dMbIY+yEemSSMV3xZL5zP331pdySV9UbDUJkyoHHtkXAvbeZX9atlsuh+S
 MADBMrFL
 vZz3rg0+FKgEppmwFlmD1AdUc0kCvy2N/reQvZ6laYKSOjTVjE1QtbOy6VsfJdBHEP74Xl22OgLh8xF74iqWsA3Sehlmn/dEvj6S+nA3iTCmi1pOYkDsbaFgukS8BU8Q5l2118wFqDPdZa/XPbi3OqmS3YZ0i/71z2YrY67NWQn1BmCDq3VT4wfZQzkliOUfWqkViwr7QY5/NnhfzAJsWgicJlEVe3k23YyjLQp1U0TnGQ0/z7CKEfvshNAwAmU+HNOk6g67jlp0uVXmXp0Vc8/pgV+8iSBH3zRgeE0CKOOEfq37wIU7agaz+CWvRmVstr0+YRuNoUNu7Avgxy7TNyyEcp4RGqfpXTMBfGs6VsKb3TCU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 19, 2026 at 02:30:25AM +0000, Wei Yang wrote:
>On Wed, Jun 17, 2026 at 08:18:15AM +0000, Wei Yang wrote:
>>On Wed, Jun 17, 2026 at 10:32:11AM +0800, Lance Yang wrote:
>>>
>>>On Tue, Jun 16, 2026 at 11:50:22PM +0000, Wei Yang wrote:
>>>>On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>>>>>
>>>>>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>>>>[...]
>>>>>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>>>index 2ccbabfb2cc1..21635fab209c 100644
>>>>>>--- a/mm/page_vma_mapped.c
>>>>>>+++ b/mm/page_vma_mapped.c
>>>>>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>>>> 		 */
>>>>>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>>>>> 
>>>>>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>>-			pmde = *pvmw->pmd;
>>>>>>-			if (!pmd_present(pmde)) {
>>>>>>-				softleaf_t entry;
>>>>>>-
>>>>>>-				if (!thp_migration_supported() ||
>>>>>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>>>>>-					return not_found(pvmw);
>>>>>>-				entry = softleaf_from_pmd(pmde);
>>>>>>-
>>>>>>-				if (!softleaf_is_migration(entry) ||
>>>>>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>>>-					return not_found(pvmw);
>>>>>>-				return true;
>>>>>>-			}
>>>>>>-			if (likely(pmd_trans_huge(pmde))) {
>>>>>>-				if (pvmw->flags & PVMW_MIGRATION)
>>>>>>-					return not_found(pvmw);
>>>>>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>-					return not_found(pvmw);
>>>>>>-				return true;
>>>>>>-			}
>>>>>>-			/* THP pmd was split under us: handle on pte level */
>>>>>>-			spin_unlock(pvmw->ptl);
>>>>>>-			pvmw->ptl = NULL;
>>>>>>-		} else if (!pmd_present(pmde)) {
>>>>>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>>-
>>>>>>-			if (softleaf_is_device_private(entry)) {
>>>>>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>>>-				return true;
>>>>>>-			}
>>>>>>+		if (pmd_present(pmde)) {
>>>>>>+			if (!pmd_leaf(pmde))
>>>>>>+				goto pte_table;
>>>>>>+			if (pvmw->flags & PVMW_MIGRATION)
>>>>>>+				return not_found(pvmw);
>>>>>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>>>+				return not_found(pvmw);
>>>>>>+		} else if (pmd_is_migration_entry(pmde)) {
>>>>>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>>>>>+
>>>>>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>>>>>+				return not_found(pvmw);
>>>>>
>>>>>Looked at history a bit, and I wonder if this changed something old
>>>>>here ...
>>>>>
>>>>>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>>>>>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>>>>>including not_found() cases. So lockless PMD read was just a filter ...
>>>>>
>>>>>With this fix, true case gets final pmd_same() check, but this
>>>>>not_found() case happens before taking PTL.
>>>>>
>>>>>So a !PVMW_MIGRATION walker could race with someone, e.g.
>>>>>remove_migration_pmd(): we make the not_found() decision from old PMD
>>>>>value that still says "migration", while real *pvmw->pmd may already be
>>>>>present again. We return without ever taking PTL :)
>>>>>
>>>>
>>>>Hi, Lance
>>>>
>>>>Thanks for take a look.
>>>>
>>>>I am trying to understand the scenario you mentioned. Let's say A migrate a
>>>>pmd and B want to unmap the pmd.
>>>>
>>>>            A                                        B
>>>>
>>>>  try to migrate a pmd
>>>>  pmd is set to migration entry
>>>>                                           unmap the pmd ...
>>>>  managed to finish migration
>>>>                                           ...still see migration entry,
>>>>                                           so skipped and unmap fail
>>>>
>>>>Would this be a timing case? Even B grab the PTL, it still could see migration
>>>>entry if B visit pmd before A finish migration.
>>>>
>>>>Maybe I miss something, look forward your insight.
>>>
>>>Right, seeing migration entry while migration is still ongoing is fine.
>>>
>>>What I meant was this ordering:
>>>
>>>  CPU 0: pmde = pmdp_get_lockless(...); /* migration */
>>>  CPU 1: remove_migration_pmd() restores PMD to present
>>>  CPU 0: returns not_found() from old pmde, without ever taking PTL and
>>>         rechecking *pvmw->pmd
>>>
>>>So issue is not seeing migration entry itself, but making final
>>>not_found() decision from stale lockless PMD value ...
>>>
>>>Before this patch, PMD migration case took PTL before making that
>>>decision ...
>>>
>>
>>Yes, this patch changes the decision making condition for pmd entry. Thanks
>>for pointing out.
>>
>>Hmm... I took another look into current pte handling and find for pte entry,
>>we did two phase check:
>>
>>  * map_pte() without ptl
>>  * check_pte() with ptl
>>
>>While check_pte() do extra pfn range check, map_pte() doesn't.
>>
>>This means for pte entry, we may face the same situation as you describe: 
>>make the decision before grab PTL. Till now, it looks reasonable.
>>
>>But one thing jumped at me, PVMW_SYNC. When this flag is specified, all check
>>is done under PTL. But now for pmd entry, we don't have a chance to do so.
>>
>>And as the comment says in try_to_migrate_one()
>>
>>	/*
>>	 * When racing against e.g. zap_pte_range() on another cpu,
>>	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
>>	 * try_to_migrate() may return before folio_mapped() has become false,
>>	 * if page table locking is skipped: use TTU_SYNC to wait for that.
>>	 */
>>
>>I tracked down to commit a98a2f0c8ce1 ('mm/rmap: split migration into its own
>>function'), but not getting more detail on reasoning. Not fully understand it
>>yet, but it seems there is some race between migration and unmap which is
>>protected by PTL?
>>
>>Will look into this to get more detail.
>>
>
>After going through the history, I found this:
>
>   commit 732ed55823fc3ad998d43b86bf771887bcc5ec67
>   Author: Hugh Dickins <hughd@google.com>
>   Date:   Tue Jun 15 18:23:53 2021 -0700
>   
>       mm/thp: try_to_unmap() use TTU_SYNC for safe splitting
>
>This one fix the race mentioned above: we expect mapcount is 0, but is not.

Cool, thanks!

I do want to spend more time on this refactor. It is touching some subtle
page_vma_mapped_walk() rules, so I don't want to skim and guess ...

One case I can pin down now is device-private: the PTE side gives us a
clear rule to compare against :)

On the PTE side:

1) PVMW_SYNC set, PVMW_MIGRATION set

  map_pte() uses pte_offset_map_lock(), so it takes PTL first.
  check_pte() then runs under PTL. Since PVMW_MIGRATION is set,
  check_pte() requires a migration entry, so device-private is rejected.

2) PVMW_SYNC set, PVMW_MIGRATION clear

  map_pte() takes PTL first. check_pte() then runs under PTL.
  Since PVMW_MIGRATION is clear, device-private can be a normal mapping,
  but check_pte() still checks entry type and PFN range.

3) PVMW_SYNC clear, PVMW_MIGRATION set

  map_pte() first does a lockless read. A non-present, non-none PTE can
  still be a candidate, so map_pte() takes PTL. check_pte() then rejects
  device-private, because PVMW_MIGRATION requires a migration entry.

4) PVMW_SYNC clear, PVMW_MIGRATION clear

  map_pte() first does a lockless read. A device-private PTE can be a
  normal mapping candidate, so map_pte() takes PTL. check_pte() then
  checks entry type and PFN range under PTL.

On the PMD device-private side, before this patch, all four cases go
through the same code once the lockless PMD read sees a device-private
entry:

- lockless read PMD into pmde
- pmde is non-present
- decode pmde as a softleaf entry
- entry is device-private
- take pmd_lock()
- return true

So compared with the PTE side:

A) PVMW_SYNC set, PVMW_MIGRATION set

  PTE rejects device-private under PTL.

  PMD returns true.

  This does not match. The PMD code misses the PVMW_MIGRATION direction
  check, and does not reread/revalidate PMD under pmd_lock().

B) PVMW_SYNC set, PVMW_MIGRATION clear

  PTE can accept device-private, but only after locked check_pte()
  validation.

  PMD also returns true.

  The direction is OK, but the final check is missing. PMD returns true
  from the lockless PMD classification, without PMD revalidation and
  without check_pmd() PFN-range check.

C) PVMW_SYNC clear, PVMW_MIGRATION set

  PTE can reach locked check_pte() from the lockless candidate, but
  check_pte() rejects device-private.
  
  PMD returns true.

  Same mismatch as case A: missing PVMW_MIGRATION direction check, and no
  locked PMD revalidation.

D) PVMW_SYNC clear, PVMW_MIGRATION clear

  PTE can accept device-private after locked validation.

  PMD also returns true.

  Direction is OK here as well, but the PMD code still has no final
  locked check matching check_pte(): no PMD reread/revalidation, and no
  check_pmd() PFN-range check.

>
>IIUC, if we apply the change in this patch, the affected case is
>pmd_is_migration_entry(). In case someone else has cleared it but not update
>mapcount yet, try_to_migrate() would return before folio_mapped() is false.
>
>Thanks Lance for raise the question.
>
>If above analysis is true, I haven't got a neat way to take this into
>consideration.
>
>BTW, for a fix, I am thinking to keep it simple and direct. So how about leave
>the refactor as a followup cleanup?

So for a fix, let's line up the PTE and PMD rules first :D

Cheers, Lance

>-- 
>Wei Yang
>Help you, Help me
>

