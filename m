Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BFB606A685
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 11:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=tPgSojfu
Received: by kanga.kvack.org (Postfix)
	id 22D566B09CB; Wed, 25 Nov 2026 06:52:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 205C26B09CD; Wed, 25 Nov 2026 06:52:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A256B09CE; Wed, 25 Nov 2026 06:52:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E326D6B09CB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 06:52:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74E9A120DDD
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:21 +0000 (UTC)
X-FDA: 85473478482.08.24D2DCF
Received: from mta0.migadu.com (out-51.mta0.migadu.com [91.218.175.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8E5F31C0009
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 11:52:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPgSojfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795607539;
	b=On75a6d/tIXtwSukEYrn6baL9yWaigZDQBbdIVq3CNMKv96gYUVcbeiJg4jjp6fEszAaOf
	DMLbMMXqUqE6yBjArBeuaHaMcHodCott7lWniksYXY84AVh0DKPaBvr5ynuB8Y4BGgJB80
	kDgP1cqJZNUVG2oRyX4ubIQoRYQoRfQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795607539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=S1YMVyf7QK6He1+IyuB7Pm33iIetDfvYmZuuN7H0dqQ=;
	b=E70zNzfGKscDCh962pcM0AmwpHoZI/14yDyJFSrRpptxt9jBCULw9t1IA2HFZ9M62YDTdO
	qvX0UgFk0dfD4BHwcSEatZAxWQ68KX5azrvvzm6Dn871jKkwMQaJpeKFtY6afc8gQP94Tl
	NpCnVZhZ3L0Pmkjy+hC8j71Dvq5OPKc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPgSojfu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.51 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z2CkT54kqOKU8KO1wfVbTT+XpYAEM4nHWLOF/HfPCiY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795607536; v=1; x=1796212336;
 b=tPgSojfuEuVoGk0j32eGGhBR9EsilOWfRlLfRAqEWE9srgW5jCUcvIgCk2O8IompGsr4F252
 UIDEJMjPLzHQ947AuWj19VyWRAKZOZA0SUi4nyBvAbNQppYVHA5EwGoL0n8X7eynLfdvDmZyNc+
 ehEZ2O/RvYyJjZKUgGoJxAwQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3cd877cfbc249f6d;
	Wed, 25 Nov 2026 11:52:16 +0000
X-Mizu-Trace-ID: 3cd877cfbc249f6d
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 0/3] fs/proc/task_mmu: smaps fixes for non-present and device-private PMDs
Date: Wed, 25 Nov 2026 03:49:56 -0800
Message-ID: <20261125115014.4014507-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 8E5F31C0009
X-Stat-Signature: qgxnpj9qk6zh11zxxza6zsk36exa4151
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795607539-817413
X-HE-Meta: U2FsdGVkX1+4xN6SXCDJPwnvBkXhI0SozgoZY0xkseRtVEuYWMYHw0FLL2tk2r/mTwwGC35nWvtqQtba31y6lgIEwPumntlOEBKdmljSXGrT5Ncmluf9xhwfvc/HbRzm6zCVJquXFEaaJld9BUIEDGer5M0lV7LuV4ryiIEBg1lDmFPjbtud7Kl2oaoAlJlbgLQiHEluwDjIUDZqT1DWEGCkeZB1i4nq6q4C0qGftZ3ekqWN36FfTiJvJipIALDkXgnof/jTOD0P8HirnTdaKIKlDp9jiADWipBmjK+VuUedpnaFB+byNDyvHDrhLJf/dbKl9pAh2oz6PaKRLEAVsTyFpbDIj/kDWIUkFd0KPEwG0rds5OQeY3O7+jkzxT/Gz7yYdpoh83eK3x6g1GcVspzuKskf9Eo6JjoEi1FVI85bRMPugv718Gw/2aktPhurI9TeJt0RLaSAY29p8hEQrvidk4nmPIyWxxi/u7WCINL3s0srjwb8B+DuLxHzulC7rCVVDLPRIhqnLoew3jom2bsLbVWCmseVd03m557x9Kzb3+W160KiAg9jL3dh3WoQ8WgPoVWY5bRIGodIFJYp4576Pf8rENTZ6NGrYvRhuOoV8VlfYwMMMr/Huu4thcDX0mEMDbqNzg3UdegiMll4ut7blQxNkXs2BRSYboOuDqxXGHzFdQzAXsK1Q7ekwPbV3UUXce7aRSBvPXreKi4EvEKc2yo0BQDlndXF/grCzDPBf0S8rABHpIXsP/vkBiWQRiWwI+y1gWOKxAMqjiLNuwVlJQ6jRl12Jn+UXqx64ph+GbOJYL/G1Xg2Y7uw5E242fTr9Amsn6XopMiQTr4VhKs1Fv28JdQH5zUmobTLfnrr5nvFqLhqxCLa72iom2F3+UTPKKWODQyDqJ9oo+khEQZcd6HCVxyjzri7pcc+CYphpkJz75sdeW7gJ6QHx/ZIvHZed7Ion92O0g5MTVl
 rskpRBZj
 IQuzv20fTEVNJj7CISp6Gc4bJhyT3SD9lC+TZ9w5+cgnWNKHdOkflslsQTSk1XxvX0uHU7ZGMLh+85x8PQOFtPwDJBsEvZFqtkC7sFNZVV9u5JRtW0E8r+e76qQgOphIsvY79ROrTsUBNibrhmLwNqdKTfRqhjBpfhA/Du++EmCPrVXL+LfmbWeZp9YuvTNZnK1BMD8T168BcOnaOQfh5KNnZobS1p5D0YsTj/kTsCfjFauoOu+zejw8Y49wKymEkW8wtuez0j1SDgzykuSaxv+Fjm3Y1m/Iqnn+6hHiFVt1bRf2MM1ecnXQ9X8oG9ZIlm4s2pIm2aaLHEteKc161vxWWbsdR5Zx9Ef2ARZSR7iwQQBXSokTDQaLERBhYRHczTEMY8GKp8VuOhrR6P+kYOjQC8CAVEna+VOcl3h4XMS0K5tq0/3WZ76+/utdeMn75jvPpXVCk7ExMx6r6kdfiygOrWZdGZVu4lGyfnS8rOd6ETPDHLp/l0Qnc7uemy8WzJt1HcrhnDzLPT7o6z213mISGjHgorKJYPxg8OznBZSz7EE4nE5fhIH9YCSzr/uDOE3TGo8TAeuyprvc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series contains two fixes for the smaps PMD path, plus the cleanup
they build on. They were extracted from the work on PMD swap entries for
anonymous THPs [1] and can be merged independently.

1. Read the PMD once in smaps_pmd_entry(), the way smaps_pte_entry()
   already does. No functional change.

2. Stop reading the accessed and dirty bits out of a non-present PMD
   in smaps, where they encode the softleaf entry rather than
   accessed/dirty state.

3. Account device-private PMDs using mapcounts in smaps, matching the
   PTE path. Shared mappings get proportional PSS, and exclusive
   mappings are counted as private.

This applies on top of mm-new (5bd93e4b0b35).

v3 -> v4: https://lore.kernel.org/r/20261123163301.1568240-1-usama.arif@linux.dev/
- Patches 1 and 2 of v3 have been picked up in mm/core.git
  (migrate-7.5.misc and core-7.5.misc), so this revision only carries
  the three smaps patches, renumbered 1-3 (David). The patch numbers in
  the older entries below are the ones from the five patch series.
- Patch 1: make pmdval const (Lorenzo).
- Collect the Reviewed-by tags from v3.

v2 -> v3: https://lore.kernel.org/r/20261116063624.1382944-1-usama.arif@linux.dev/
- Patch 2: move the hwpoison check to the top of the batching block, so
  the two bit tests run before the page table scan rather than after
  it (David, Zi Yan, Kiryl).
- Patch 3 is new: read the PMD once with pmdp_get(), so patch 4 only
  has to move pmd_young() and pmd_dirty() under the present branch
  (Kiryl). Patch 4 is unchanged in effect and keeps its v2 tags.
- Collect the Reviewed-by tags from v2.

v1 -> v2: https://lore.kernel.org/r/20261111113904.650722-1-usama.arif@linux.dev/
- Patch 2: use the existing folio_contain_hwpoisoned_page()
  rather than adding a helper that scans every page of the folio
  (Lorenzo, David). Only skip batching for anon folios, since
  falling back for a freshly read folio frees it with the poisoned
  page in it, and the retried fault can get the same block back.
- Collect the Reviewed-by and Acked-by tags from v1.

[1] PMD-level swap entries for anonymous THPs:
https://lore.kernel.org/r/20261002095503.3585565-1-usama.arif@linux.dev/
 
Usama Arif (3):
  fs/proc/task_mmu: read the PMD once in smaps_pmd_entry()
  fs/proc/task_mmu: don't read young/dirty from a non-present PMD in
    smaps
  fs/proc/task_mmu: account device-private PMDs as present in smaps

 fs/proc/task_mmu.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

-- 
2.53.1-Meta


