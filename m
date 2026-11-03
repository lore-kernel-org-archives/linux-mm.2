Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 818D6606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LZ9GBgE+
Received: by kanga.kvack.org (Postfix)
	id A53286B05B6; Tue,  3 Nov 2026 03:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01856B05B7; Tue,  3 Nov 2026 03:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3546B05B8; Tue,  3 Nov 2026 03:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A23C6B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CB57A7D5D
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:07 +0000 (UTC)
X-FDA: 85393130214.04.33F7A22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 411A080005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ9GBgE+;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Fsirq8b1tOF7xGnt9JKmVFznOcgYPeH7MNBVIQjnYAw=;
	b=bCZgCO/GjibVcF0jTpmG+A6G0Rn1d7Lp+W+geenEPK5j0RG9jgdwHmRONAZoJBMYrio1YF
	b0Y85nxEmVoGYx4thTjHTZNSDsagHq/vZBdl3/BUplqaRcGz74WZJRBiV7liv9a7jsrYQC
	kjk8PkUQzXEbn3LtU0888rJnpAipq2Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LZ9GBgE+;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694485;
	b=Bwxl3HpKB6kGDNsh3c2zTaPp0LQEYjygE51azXqmCsYYx1apdKtp//6CoFXPNkNK7h4JMo
	O+xa41MLWIFh5vrK5GIPqS+z/iTZKabanxLKcsTWL83uNoKBgCzcyji8HqeDua7a+Lq947
	CvFvtk5i+8GD83BKA7sQj/P0/hxF/ug=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC74660416;
	Tue,  3 Nov 2026 08:28:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555311F0093A;
	Tue,  3 Nov 2026 08:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694484;
	bh=Fsirq8b1tOF7xGnt9JKmVFznOcgYPeH7MNBVIQjnYAw=;
	h=From:Subject:Date:To:Cc;
	b=LZ9GBgE+6z1dxJNlGmIEYbLWgU8h2E5PEdgyN9NKIA0VaGVcncEmxMrB5iadlM0Nn
	 lsxYS0s1MojLzCDJY9sOIFOIJt/X+v8MKTTZWds8jgIGWH8h2Ju5yHVQidwK1mFeMR
	 rXY/zje18Dsq4xDwAicEhbhn3NgIwuQ6pkbID6UUZ4WhIsiuRJbihFd3AFGx/rTi1N
	 OcrV0rXbke+zBcKyezsU2LFhsgS70ul3cwXf90UCjYrNFT9bs8x4SCBx8Ntwz74mVD
	 nW00LouKPe+96bRnfEQYDH4NAdlTxzOweBU2JDDAv47nmuKo0RdRIbdUXefB4m1wFt
	 2NEGdQbb6sFIQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH 0/5] mm/khugepaged: bound mmap_lock hold time when walking
 an mm's VMAs
Date: Tue, 03 Nov 2026 08:27:41 +0000
Message-Id: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x2M0QqEIBQFfyXucxdMSmh/JXoQPdmlxUIriujfV
 /ZxBmYeykiCTJ/qoYRTsqyxQFNX5GYbA1h8YdJKm0bpnpf5CNhsgOev3RHdzZNc3Kq277wxsJ2
 iEm8JRf/Hw/i+P04JZmRoAAAA
X-Change-ID: 20261029-khugepaged-latency-fix-40495d66ea50
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2978; i=ljs@kernel.org;
 h=from:subject:message-id; bh=XXzzroOk3JzB70Kjl+zLo7wwLJmwdmiu+XnhF/h0hi0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezub07jtZPs3hZ101N694fbdfzVdvDfXOirsP7zjdK
 Ty/fTdXRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACay4SfDH45qsUkXUpPyPOuV
 hQ8qTPq0ym/p2gu71rXsvLd35p77DlWMDKcOPHCefaTv0bWucqn0xLC23xmPc37VS0ztSUpYUio
 wkxEA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: mym8us1xzzw8oipsybkzxp3z97bwhx4s
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 411A080005
X-HE-Tag: 1793694485-785531
X-HE-Meta: U2FsdGVkX19Ab5s2k5YjS8vofTKNTStoIu8O+EMpQK8Fxnj9K1qY7zXfx6p858kmNOsI+2nLkr3M9F0KbDlZqv2jDR3MyRF5VLrd6afOgrSvaGEhdhebEdlv/C83z5qT6fwlhTXnVgdaUGSVR1QbGrLzy8HJfk2eqmx2Gcwuv52bYvVu1d1nVZWB79eab7MaYeDF8ox0x0BnozUtCaMF2HOJ5sEzHpuWvGY3TgaMWrvZ/G8kjrbGUJxW1Gnp1R3/NfPdm2VQxl9fVnwgupcjzrzFNTHw9TMM+wZ7dbdHKfCQABqKuPJD/rYjSkPcDZltZ4rAG4dqqiQt2TZtuI0sJ5hDdTVscTi8jgTUVuUFvhuOC7SkP+uE5r2biNPVyY1AAv0Y8r7aXH99Wii+ZzD0DapbLVsPMe5TqDdU00GB6LQ0yT6mIIZPjCAa9L3HCDGU4qAPtBGHZ/iDtQiyUgt1tKFQ0Fo2A9XzX6AGJJKF9MiYr5CvMcTcFYIwoD/mePJ5bYexttJKGhcOVqogBkGnHHy0xUfbhReE5cV6531fwPHRDJ1lUXfCZOdh42U2hkE4Msp57ht0N5sbQ9OydrI1d22lv5sCpvlYXGG1XOClF5I9FijRPBsgM+WI2AIEBr/tKavxzITQyg6anSKhJyR/AfhluL/n2bZsepsvmpsCYPcIFG2FQQi3LepZv9nrzHd0y9McFRRriA/rKNVcV89iMjBYVgpDKF9yLZX4BPHcVELJ79W7eCnCUQD5F9OkkJQ9XvXx0bHIcV1aA/PJyHyXBSGIrj4LMpKnI2TIgVXn4Mlkip/a/DIX/44eior7hPFSr1SS2W5j4pD7E4tNxRQ6/H2HxtVgEshkpJTM9hrWozlMJ5cpZuAOgeNnUztQ67FB7EkmyfWzIkqnv6YE9z+KVgOv/dKA3YxnOF48LliRUtjbw7eEzDbXfTfG1qopa+LE8dMd3cexGPYKK5HEzrn
 UxsC5Xbv
 FKDS/ED5xe8B5LVZfV2VXT+Nm5dz6GHSwDxtBzRkfSTCqCbACDBElGYm1lvKYxk3fp7KPXCA83jkZCvC8DikgFvtWjLy1j+T4AtYiWunjzfG2rPTyXTjsW8o7nmF1a+ggV8M797yBjXLeASZn69ibm4ePdTRapriwy+SjtKvBhiVg6ggUbeeXakPl2FWGfYeBjo6uMakUuAi91xSjxgcRGkqv+eOwTXbo/U4PLZVGg6Ac0daZtpKxjC4ManOat3D/N8bGG5JG8lowNhzeImPA58EkFiWo6CFIUQlm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series introduces a couple small changes to khugepaged to improve its
behaviour both in the face of mm->mmap_lock contention and to reduce that
lock contention when possible.

It also updates other places which release the mmap read lock to allow mmap
contended mmap write locks a chance to make progress (BPF iterators and
/proc/$pid/maps + friends).

Looking at the first change - if the mmap lock is contended, an attempted
mmap trylock in collapse_scan_mm_slot() will result in the scan being
aborted wherever it happens to be, and when next the mm is processed it
starts from the beginning again.

If an mm has a lot of ineligible VMAs and is undergoing significant
mmap_lock contention, collapsing the eligible VMAs there can take a very
long time.

Patch 2 of the series fixes this (patch 1 is a prerequisite) by keeping
track of where khugepaged was in the mm before aborting the scan.

This issue was noticed during some work in which an mm was instantiated
with a large number of small VMAs under significant mmap_lock contention,
during which collapse was observed to take 10.8s. With this patch applied
it took 3.6s to collapse the same mm.

Patch 3 introduces new rwsem primitives - down_read_nosteal() and
down_read_killable_nosteal() - to allow for read locks to be taken without
stealing them from a queued write lock.

Patch 4 adds mmap lock wrappers for this - mmap_read_lock_nosteal() and
mmap_read_lock_killable_nosteal() and updates callers which release the mmap
read lock on contention - BPF iterators + /proc/$pid/maps et al.

Finally, patch 5 uses this to have khugepaged release + reacquire the mmap
read lock in the face of a large number of ineligible VMAs.

This was also observed as part of the previously mentioned work in the form
of mmap lock stalls, which patch 5 resolves.

Importantly, none of the changes introduces any regressions for khugepaged
anywhere. It is all upside, and implemented conservatively.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (5):
      Revert "mm/khugepaged: remove definition of struct khugepaged_mm_slot"
      mm/khugepaged: scan mm's more efficiently under mmap_lock contention
      locking/rwsem: add down_read[_killable]_nosteal()
      mm: add and use mmap_read_lock[_killable]_nosteal() on contention
      mm/khugepaged: drop/reacquire mmap read lock if skipped enough VMAs

 include/linux/mmap_lock.h |  44 +++++++++++++++++++
 include/linux/rwsem.h     |   2 +
 kernel/bpf/task_iter.c    |   2 +-
 kernel/locking/rwsem.c    |  71 ++++++++++++++++++++++++------
 mm/khugepaged.c           | 108 ++++++++++++++++++++++++++++++----------------
 mm/mmap_lock.c            |   2 +-
 6 files changed, 178 insertions(+), 51 deletions(-)
---
base-commit: 34f88a114888c9dba49e45f2b0c2a3e83c4c871c
change-id: 20261029-khugepaged-latency-fix-40495d66ea50

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


