Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEC051099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B93D6B00A1; Fri, 20 Mar 2026 14:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 091F16B00AE; Fri, 20 Mar 2026 14:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F10186B00AF; Fri, 20 Mar 2026 14:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E202B6B00A1
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:14:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 82DE6140278
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:58 +0000 (UTC)
X-FDA: 84567242676.22.40C74FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF7EC4000E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ee5VGMoe;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774030496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JUxdoo4poRF4jK1QqjZctec0Mtz1WV0V+FrsQzJBpog=;
	b=r0PiKGHDhnL1H/Hv5xXO8QWn1S233CQBigwUHdS5vw1sdCKBUoszFH2rN47GQ3L3vkciXs
	8Znl2S9Lw/6IFPmotUwcjmy9hHB3D7A3udVZZEb2ZlOhxjWPS0YaPysIx8K+ejJml2G8oa
	jrLpWew7H5Ggqlu8ys3H9PvXleszgSA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ee5VGMoe;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774030497; a=rsa-sha256;
	cv=none;
	b=0tq5KQrFjflnJ0fAhzyCK4aKbppGvVt4mMoegGF3kzehsc4z+DlxZETFWujU8VxqnYWm6l
	+v65BTLA7BLTewVYyQxgaXrzJL3/WCsAvA5k+I1fLgbx6VOYAICp/kMmSW4N4VcqdXfI1+
	UjZLnvqOz+aGhyzgIcE10RNhB6CNW+o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8ED5E43B13;
	Fri, 20 Mar 2026 18:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E187C4CEF7;
	Fri, 20 Mar 2026 18:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774030495;
	bh=2ud9VVAGIb5J70qS+Aq6s18YBJv2+0N0qOqGnKGdgDk=;
	h=From:To:Cc:Subject:Date:From;
	b=Ee5VGMoe+t1f0NUSaMeg/sco6qzmM6ZNRxu4N8IG5OP4PVX5FiPArqac31P1/7EtH
	 HZz2E+aTuhNaRchPmfEjZI7clp9RAxbklKrbXDDIyK/rbb49IUqtKvB+7ldapRt/4R
	 +W/NHE386gOb5/wnEgIOqkgtbWMU3EJTMvVNm/zxrtATibPBZBO+XHxddlu2BOCXlU
	 DqFjzcraHrG7Y8sWJDkQ+LY5Av05wozxumH8l+VCcJ8KJ0DRUeXD+Aue8vFLiTxkhQ
	 15LtpqCPguOUxuidWaulPkClTGQtHjnOgMqIfyL+cKu741hcJud1OHbtAE/dmWAg2E
	 ZbyklwE5H2MFw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 00/13] mm/huge_memory: refactor zap_huge_pmd()
Date: Fri, 20 Mar 2026 18:14:50 +0000
Message-ID: <cover.1774029655.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BF7EC4000E
X-Rspamd-Server: rspam08
X-Stat-Signature: djs8z356yziukfu4skq34w869kmutrpn
X-HE-Tag: 1774030496-50684
X-HE-Meta: U2FsdGVkX1/mOkZyfeMCaxlIxngQ7Yad0pO/ybrXAwX5ULqqjFn8mgQ6xcUAL4m8Bc3mkaSWuVzc/9iMycwmKF0XbL9D/qSGivtBp2YDT2pBgrmHq5fZxYFyrZaqeFafQD4/l9pbTbjdHRR3ECFbTTfwFsKd2HUcjaZVzQ9d7JFCPETeBMtT+axUGTz0n/oQbpDbx4RwFYyfHuDiENbqIhf00CoUwZJpqyBfhbeXdk6ff9x5HAUgfTq/iCH4P+/8cHG89U1rjMnhtr33nWW7eFV8bU19yudH3JZbKd8CQjXNvJB4fCKeANm9BJXGFP2lF37/EyhcSmeU101jPOORKjlTclnLlJeMDJtAFzN8D4lKcMSLM9oyBNqBohmyY7PoQuqv/SQ3AruX7ZOi0e1IGlAq3h/1wT2gQs0T1zSoGzuloii8ki4sTMOtIVCMhxDbGa7m9E5PR6u870luTQQG1+Pm8AYvnmpVotwo2r2vxwe2UYeYJtpzfEUG2Vl7q1Tvk7t5v5yCbMSLxvvSc8i+znQK+bn0iC6sM7x6YX/rC6rEPnsX8wKTg8DK8VKrueLKT5pD8WrfYrJ9hkisNljHJJOViW/5UXnFP1aPKZQ1bnspHV8lS9F5PVn3GmGIUvGvEDwWmKaDXllmQVFGG6CYXmxS1ygcdgDI0lzrp8peguB32ZlwY1gAik6O4mp09HQ9BxZ3v4YV+YK/pxDnZXRjeJPY++PL36TxxURRIVAQepG37JSzINLDO1hLQnLX1nKIGWv8aJpwtMsdOixev+SsayHHAP8Lj4KlQlR7Nh91NiVbkPCsYsxfilmRJyedFJys6DMhuQOYTOydeHlsu2gL0J8Rl+bcMJPuuaa6Du/lS3YM5MLBvKOrkGFi31ojcGOElKTVEtbSP1+dmZjBAnE+AKX9yiJo6EEMp8Aw5BF2BLRFtQBU9TPApf9oo2usDSth6ntOySZ44Q36dkeJcg0
 dS+dRzvp
 tQTNSFrz/4A5fIcVOuVM1uMjASjCJMNX0lUOGvNxpz4ty3iUrxchitsan/LdupWFhvzVoklbnQNb1xlLiLlLVT8BNVEBeQ7fuOMquq2tZ5QEMQhWIwqvMJjqx240QbDwU5mnLOY0XlRzUSheQULWUdDK8DoGBNHpve/mPc/ItZt3t0+FGcO67yaRVlMUPHxqpp2GUWo909FlwjvsWN2Jz3ASaw4ojJpMlkVOKBskLrIOvvZzR44FB9cC2MN7CdCnp6mRPDaFLc/nYuFJGI5qFuqiZzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The zap_huge_pmd() function is overly complicated, clean it up and also add
an assert in the case that we encounter a buggy PMD entry that doesn't
match expectations.

This is motivated by a bug discovered [0] where the PMD entry was none of:

* A non-DAX, PFN or mixed map.
* The huge zero folio
* A present PMD entry
* A softleaf entry

In zap_huge_pmd(), but due to the bug we manged to reach this code.

It is useful to explicitly call this out rather than have an arbitrary NULL
pointer dereference happen, which also improves understanding of what's
going on.

The series goes further to make use of vm_normal_folio_pmd() rather than
implementing custom logic for retrieving the folio, and extends softleaf
functionality to provide and use an equivalent softleaf function.

[0]:https://lore.kernel.org/all/6b3d7ad7-49e1-407a-903d-3103704160d8@lucifer.local/


v3:
* Propagated tags, thanks everybody!
* Fixed const vma parameter in vma_is_special_huge() in 1/13 as per
  Sashiko.
* Renamed needs_deposit -> has_deposit as per Kiryl, better describing the
  situation as we're zapping deposited tables, not depositing them.
* Initialised has_deposit to arch_needs_pgtable_deposit(), and updated huge
  zero page case to account for that as per Kiryl.
* Dropped separated logic approach as per Baolin.
* Added 'No functional change intended.' caveats.
* Removed seemingly superfluous, inconsistent pot-folio_remove_rmap_pmd()
  mapcount sanity checks.
* De-duplicated tlb->mm's.
* Separated folio-specific logic into another function.
* Added softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio() functions.
* Add and use normal_or_softleaf_folio_pmd() to make use of
  vm_normal_folio_pmd() and pmd_to_softleaf_folio() for obtaining the
  folio.
* Add and use has_deposited_pgtable() to figure out deposits.
* Added a bunch of explanatory comments as per Baolin.

v2:
* Added tags thanks everybody!
* Fixed issue with returning false on bug case potentially looping forever as
  per Baolin.
* Fixed further issue in bug path in 5/8 with double pte unlock.
* Add patch to use vm_normal_folio_pmd() as per David.
https://lore.kernel.org/all/cover.1773924928.git.ljs@kernel.org/
v1:
https://lore.kernel.org/all/cover.1773865827.git.ljs@kernel.org/

Lorenzo Stoakes (Oracle) (13):
  mm/huge_memory: simplify vma_is_specal_huge()
  mm/huge: avoid big else branch in zap_huge_pmd()
  mm/huge_memory: have zap_huge_pmd return a boolean, add kdoc
  mm/huge_memory: handle buggy PMD entry in zap_huge_pmd()
  mm/huge_memory: add a common exit path to zap_huge_pmd()
  mm/huge_memory: remove unnecessary VM_BUG_ON_PAGE()
  mm/huge_memory: deduplicate zap deposited table call
  mm/huge_memory: remove unnecessary sanity checks
  mm/huge_memory: use mm instead of tlb->mm
  mm/huge_memory: separate out the folio part of zap_huge_pmd()
  mm: add softleaf_is_valid_pmd_entry(), pmd_to_softleaf_folio()
  mm/huge_memory: add and use normal_or_softleaf_folio_pmd()
  mm/huge_memory: add and use has_deposited_pgtable()

 include/linux/huge_mm.h |   8 +-
 include/linux/leafops.h |  39 +++++++++-
 include/linux/mm.h      |  16 ----
 mm/huge_memory.c        | 168 +++++++++++++++++++++++++---------------
 4 files changed, 143 insertions(+), 88 deletions(-)

--
2.53.0

