Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C601606A686
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=La2MMcwW
Received: by kanga.kvack.org (Postfix)
	id EACBC6B05BE; Wed,  4 Nov 2026 13:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83716B05C5; Wed,  4 Nov 2026 13:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A016B05C6; Wed,  4 Nov 2026 13:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A42936B05BE
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:04:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1C7CCA8546
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:04:42 +0000 (UTC)
X-FDA: 85398212004.30.C48CADD
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	by imf04.hostedemail.com (Postfix) with ESMTP id C9F664000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:04:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=La2MMcwW;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Azf6TC2ItbtESITBREZK8lgVBXV8KG+jdp6q1EsvJTQ=;
	b=yeg9bT2qooJco5VmhnPJXz7Rb4n5jxFX5F5sKoxbgFsV26bq6C410R+jG3CF05udTPmw+d
	xaqIQJVXqNusO0uYm3h3EoGGGbhBA8oaDqeNR1g1s4CAMbKkOrPG3L/VihTHoZixH/kSQe
	naum8FAzQQ8gOnpNXM7Rv4n3SA20QjA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793815480;
	b=IiRzKAfEoM9XZPtO8MuuE531mL9dFfghKGQZYEQdjJZqpdRHvtrMvY/6LCLAd236U7DD0E
	H1RcYguZtFPEwCMlXoK3p8y0/evCudVfuEIGbEiM+Z0oG9YyXwgSw8mSwdEjxZcDQdFz4C
	xlc4tmMFMOhjryUvjJ0eOAAGX/eOngM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=La2MMcwW;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ORJcbkhhXOFfbATzkO8WtvYxCcPTsF3B0i26iSqffrs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793815478; v=1; x=1794420278;
 b=La2MMcwWMgi4PDijnNwiMykgsWgwQKq3xxZaQP+o1XbRcOLU6VPacO/eMm5RbZfSvR/wZQbb
 amJlgSL8pAcV+020YY30LZF0v65t7tjDi2oBFRy28M+TkDUuBF0/mn8/ZGtRoE798iIDyt5u0V7
 je1XeJ3ANoc8688UwP0qfwbg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 257a1af166e02d15;
	Wed, 04 Nov 2026 18:04:38 +0000
X-Mizu-Trace-ID: 257a1af166e02d15
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: "Zi Yan" <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	linux-mm@kvack.org,
	ying.huang@linux.alibaba.com,
	"Baoquan He" <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	"Nico Pache" <nico.pache@linux.dev>,
	"Liam R.Howlett" <liam@infradead.org>,
	ryan.roberts@arm.com,
	"Vlastimil Babka" <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com
Subject: Re: [PATCH v8 10/30] mm: make PMD migration-entry splitting explicit
Date: Wed,  4 Nov 2026 10:04:33 -0800
Message-ID: <20261104180435.1520363-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <DLZ48KMS7YG8.3BTM0UUU8CTU2@nvidia.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: hmcouewf1uehywtnzxrypu34dm4q66cg
X-Rspamd-Queue-Id: C9F664000A
X-Rspam-User: 
X-HE-Tag: 1793815479-903728
X-HE-Meta: U2FsdGVkX19rD2Vh2ghv7IVU+4kraaBiQu2pYE236B4YTgppnS9wlYrz404yr3OeCnnzGxe+vz51Vjp9IKWzM3bBriXrzt1V2yeBVqEpSUgUM3p39ySQWqZdOT6A8xNZbp1mK6KkNqHAEwzcR+YrvFA6arG4EAKGHSg4eLumeCaXzyDy74ycxrdtJNDqnL8hLwrVzBYKongbMWYUi/oBccM69w/VCM5ANOQIg1OVLhPVQgbOvo2xm+xrCrRfi6w42Js8hxo3rrgRcOfrd00QfxUI3t6KUZ53jH12wXyOaHbg+G5JymrMpEXpOPof4juFCA8vAI9DGAb8ZOlEtOtMxDG3yUePHO5xb/gvGgjWHqyQsSYpG3iDtreVym7ljgTJbBgUIiAgTM6zhwT5+qJR1Ir4FNTMCiGFvsOVSuD8aEXkxBRFaZjHvuGFjQo8uYzhrQuG3o3qj5tA4Alw8XHlym79mWRBzf3bpyORb1hstkZV2J+K6UgdXdcdILICUhyb2tzcRkClkoshdT/u7kGP+DeQe/WdQo56WH3lRlDa0HiSZlTuJ5WFYK2KdhhPb9XyindBzz4AFRPaBFYHYw5p0+P3NbG7S9ZaNdIqqF+OBneTwt6SpgyCECQ+VzPxPcYRC3uujQ89XrFjx7298ewCgy44HTBpTdjJ7GVSxGO3PupZPbp+xUJoFiEcEhmDAdh1wIUCgJoG0jUdW1uHsQ53YwdPSkjbd88Ht0gZQFMp5SnEecd2XWN0eL/obIKcBLkcq6ROTgbm+sQ21LBaXU6CmHrinINAnDv9aHTYwjJTJaIIikNL0w9SrHNTfwSQPXZDcDRj+BfwAbTA3WuuE0pxA5bOrMm+JHf0PT1XKHyYnuZhctZpHc1QnUzYDlCPB/KqXcivKQYRazit+8AhrzVsGi8oM94/xQQTSa6gkgqZOUH92NStqNV8msDGMQk/Q0TmhxSK/Mu72ujDwjIna/n
 xEBQJgUQ
 9NNEYfKioCKQIJ7KdWWIPryJiAbiLGB2cD2VERkP3ijDJr6CywMvuxnCUBi7WrkYAm/0G7AhdXFLfLD4a95zvzaboX8YkjwTd/UpoPoTOgpeslpvRFj6WT/2xRduuzAn65RD21GTdCtBSeCKjfuprPVrcAYY5j4gi+dFGyE7OUe/8bpJdLHMwPyexFXYiWEG5Htr2vDXrIdMfk/V+SZhvayaXmSatTCyJxf2iLP+2sukIdFiQyepaWTEgc6ig5v956wYoH4qmOHfYcUaEf3eQFkOB2UBGeNMGe7AjzdEoCXNIUUKxSrgIvSExHzhq4VF3hmWwVl9L5a7JitY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 07 Oct 2026 22:53:51 -0400 "Zi Yan" <ziy@nvidia.com> wrote:

> On Fri Oct 2, 2026 at 5:52 AM EDT, Usama Arif wrote:
> > __split_huge_pmd() and friends take a "freeze" boolean that every caller
> > has to pass and almost every caller passes as false. The name says nothing
> > about what it selects, and the one thing it does select - PTE migration
> > entries instead of PTE mappings - is only ever wanted by the rmap migration
> > path.
> >
> > Rename it to to_migration_entries, keep it private to mm/huge_memory.c,
> > and add split_pmd_to_migration_entries() for try_to_migrate_one(), the only
> > caller that wants it.
> >
> > migrate_vma_split_unmapped_folio() also passed freeze=true, but only ever
> > runs on a PMD that is already a migration entry, which the generic helper
> 
> Is it always a PMD migration entry? Can a concurrent MADV_DONTNEED zap
> the PMD migration entry or split it with a partial zap? Although it
> does not affect the correctness of the patch.
> 

Yes. Migration holds mmap_lock for reading, and MADV_DONTNEED can
clear or split the migration PMD without taking the source folio
lock. The PMD need not still be a migration entry when the split
helper checks it.

> If that concurrent zap is possible, the existing code can leak a ref,
> causing the folio to be not freed, since
> split_huge_pmd_address(freeze=true) does not drop the folio refcount
> when the PMD is zapped or becomes a PTE page.
>

Agreed. The old extra folio_get() leaks if the helper finds an empty
PMD or a PTE table and returns without consuming that reference.
folio_split_unmapped() can then fail because of the unexpected ref.

> We might want a separate fix for it.
> 

Extracted it into a separate prerequisite fix, with your Reported-by,
a Fixes tag and stable Cc. It removes the extra reference and passes
freeze=false using the old API. An existing migration PMD becomes
PTE migration entries either way; a concurrent zap or split no longer
leaves an extra reference behind.


> Actually, Mika Penttilä's "migrate on fault for device pages"[1] also
> talks about the race.
> 
> [1] https://lore.kernel.org/r/20260924065313.899730-1-mpenttil@redhat.com
> 
> > expands into PTE migration entries either way. Its folio_get() only existed
> > to balance the put_page() that freeze=true performs, so both go.
> >
> > split_pmd_to_migration_entries() is only ever handed a present or
> > device-private PMD, so assert that in __split_huge_pmd_locked() instead of
> > silently skipping anything else.
> >
> > Other than that assertion, no functional change intended.
> >
> > Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Usama Arif <usama.arif@linux.dev>
> > Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> > ---
> >  include/linux/huge_mm.h | 21 ++++++------
> >  mm/huge_memory.c        | 74 ++++++++++++++++++++++++++---------------
> >  mm/memory.c             |  4 +--
> >  mm/migrate_device.c     |  7 +---
> >  mm/mprotect.c           |  2 +-
> >  mm/rmap.c               |  8 ++---
> >  6 files changed, 65 insertions(+), 51 deletions(-)
> >
> 
> <snip>
> > diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> > index 0c437004329d9..4a0b61d50d222 100644
> > --- a/mm/migrate_device.c
> > +++ b/mm/migrate_device.c
> > @@ -918,12 +918,7 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
> >  	unsigned long flags;
> >  	int ret = 0;
> >  
> > -	/*
> > -	 * take a reference, since split_huge_pmd_address() with freeze = true
> > -	 * drops a reference at the end.
> > -	 */
> > -	folio_get(folio);
> > -	split_huge_pmd_address(migrate->vma, addr, true);
> > +	split_huge_pmd_address(migrate->vma, addr);
> >  	ret = folio_split_unmapped(folio, 0);
> >  	if (ret)
> >  		return ret;
> 
> This part can be a separate fix for the refcount leak.
> 
> Otherwise, LGTM.
> 
> 
> -- 
> Best Regards,
> Yan, Zi
> 
> 

