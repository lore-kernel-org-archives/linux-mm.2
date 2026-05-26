Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EDA6CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:09:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5F8D6B00A0; Tue, 26 May 2026 09:09:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35DD6B00A1; Tue, 26 May 2026 09:09:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972CF6B00A2; Tue, 26 May 2026 09:09:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86D126B00A0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:09:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 533C51A040F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:09:47 +0000 (UTC)
X-FDA: 84809603214.24.A0DFD0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9235DC0016
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:09:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqfzhVvX;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6V4hnJj1JqVqfqsfY3L4+1KunXCdfTgD+ix64T7uE08=;
	b=Jg9VX600Ns397ewsokvphYVMBtxLGyG56M9bxbbAnAqVNOS8iemWjcqTih76Kf5yAyXJCu
	XJYrHu30w4q2HhwcySFQY4c7APCRE86YzCmIaIieuCU+IEAmW5ShPY6jyrWksykjCgTtOK
	pPkpoxhaGHDJYaCaNNu24XRaYnK9GSo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DqfzhVvX;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800985; a=rsa-sha256;
	cv=none;
	b=wpTN2+F1j8W8HQxGm0UjRtf4igj0of/SqqsskPoVlSXKwpSh0DtLPgCGn4BP0sUowJfSuh
	/YbY3EHDyHpVUIFrsZzXR8QIyPvOkY7wjnz+Y0kjece+kxR9+AsqNPWIabZ7AXhYvELbXM
	C5sIwZd1XDcvDYdL0s2GHs7R+HFioos=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EBA541ABD;
	Tue, 26 May 2026 13:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444A61F000E9;
	Tue, 26 May 2026 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779800984;
	bh=6V4hnJj1JqVqfqsfY3L4+1KunXCdfTgD+ix64T7uE08=;
	h=From:To:Cc:Subject:Date;
	b=DqfzhVvXcRXLgltGb2fggRsxmLbOBLAu1+aZ6eKRFRMNEuSlTXmPEqX+Zvf+JHTbD
	 NdWAJY3MwXhwPaUbjhTB8O/75yw3ym7hjQic2+5wYlsp1OtLyHSkxNwoSH2hbTG85M
	 tXGoROKi0LLeA5+Xw9GqHmwwRkAykanXhHt7nKWQ3KW/hKW65BiJI9jvZoK3vd+o/t
	 6YFUZBdE8ju5qRKV0V+QgP5pxZfDBIO7uk3f/cEWWtcjdvUmrvV+CPWkaZvWcSM16Y
	 kH5MO3p58eH9Xt9MYp8Hh4yk1bHe/6J4urbsZ977hh3htMEnB6iv+qN6J40oxFcMFW
	 ovQ+nD36/zaEg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	wangzicheng <wangzicheng@honor.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lei Liu <liulei.rjpt@vivo.com>,
	Matthew Wilcox <willy@infradead.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Will Deacon <will@kernel.org>,
	Kalesh Singh <kaleshsingh@google.com>
Subject: [PATCH v3] mm/mglru: use folio_mark_accessed to replace folio_set_active
Date: Tue, 26 May 2026 21:09:38 +0800
Message-Id: <20260526130938.66253-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 84bq8h7uc5trh7d733meed9yfre4yow1
X-Rspamd-Queue-Id: 9235DC0016
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779800985-676183
X-HE-Meta: U2FsdGVkX19MFU/pWIU7zgUx0m+r0Li7R81C5P91P/oB/EWR57zaNVToZzNih1sWm7DydwZuha9HHb47yNHi9z16Uw6PDq5aPRhgvjkJhuTSBxEsTt3xDfHbgFVHFqt9znxFp7oxhY9WtaUJXG/V9ULixB2tCJ9H//JUiZU0xNahoBMJxrLpQfXWuqOweha0LSuFdn9Jf2bx8Zw4lJO3DGncbkGebl13F5HEfpTToOOfO2sNSQazd2PBCdcygrNaWPnO2ckip/tV6muekFSI4w9kw5sozi+a9NHgGQ4KGIcYlqTpZLRMPMOwelf2rd+NDQSjyfXCbeqVs0/Tj0xgoi9H9kj9TqkB3subXq9dYbrcd1mfM4VxR44nB/CKdUD2HOFBXNcQ1FurI3wKBAjXdiCMpkWL2uEHBkJA5dP24oelowyxxqljY3EK+F5gdWH/RtV10EUTW1otI0cjD0EOx/TGcjnSJhNTusH3aK+ggvhwJplhU3pzVrNJhjnH1Bv71XuEGLbMKk66GiTGeI58+bV+AEXy8/al68TquNO5Mq7n44ux30ynACrF5to0JLQIlFLy7Z53NkxJit5euAqlQID2ImfTNWNblApve206ZjeJloY0tFfGsWPA/I08CJv2I9ZYqwnu3rhVzCf+4kWLuFDVHJFOETO7Gw0qH/FstsOP9rUdriMl2kRywI+aZImJ6VhCJlFIN7kq0Fiq+3n3CdHevHctLldGIlpfqKmf7hZMQ4rvCi6b/ODcsZqTl1VCXLQcs7nuzuANifSIyCbjwZqNV4cKFrP9e47EHZwc6sqa2r9NaSWUseSBV6WucyRIsaPpVGXiuZ/gEGbtM6GfI9DwHoRCLPiXEt21NfSIKQnOG1Rb0Uko9h3KqAExjH/9aS3Aa0iaHsJYBfehGh2lj+8TT4DuxGDu7RwplhADDhDXLXOHKPWd67J8vpSWnNynIgvq2njX/87cvsHc6EQ
 TGhR0cKB
 fhqDBJxAdt2iKdiBSgwSMNG3w+nraV8MBG3NI/wvRE+UmTmOk3qg4FSUUrEnEJPA0U9gZfppeVzVnOYPRGmXz5aaQ9+KDeYRhfIRrQtSMhJaIHvB7sVBijDsGlnpm8Kv1HvD8d3efMrfXccFRV4dNurkbYWbPsbwejTSY53ezDBCSxHd5fAMOveI0hVy6AE0i06pT92SdAex2tkUIJH/C74IjzD3+mRezGsi9mrdKuDw/ADbAjr7msfay16PQ7ihUyz3X9Qwr3eNho1LNmlg37QwprwEpCOD+accBkmXZkCMj3Pjta7lkKNI4sWgmXfGU8TpRppi1zOPmnUHaqWgpJGocklJ8ybjRU9Ik+XLBR+xijLOn7kk/7rzdg4Gr5nQMxhrcLBdZaztgAN+z1oZWli7CjV/U3uh/DCNvY0dn78PfVxVE8LLuEu5/mU3NFzziCr9SzOCJ6w4vj8S3JMcjGx60hivfeyVKOxUQgPCXdHNZlVcshDYT4TaX1ZFsDeUSr8XHHaQfa3zvrwgMzHB1+BQdPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MGLRU gives high priority to folios mapped in page tables. As a result,
folio_set_active() is invoked for all folios read during page faults. In
practice, however, readahead can bring in many folios that are never
accessed via page tables.

A previous attempt by Lei Liu proposed introducing a separate LRU for
readahead[1] to make readahead pages easier to reclaim, but that approach
is likely over-engineered.

Before commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
folios with PG_active were always placed in the youngest generation,
leading to over-protection and increased refaults. After that commit,
PG_active folios are placed in the second youngest generation, which is
still too optimistic given the presence of readahead. In contrast, the
classic active/inactive scheme is more conservative.

This patch switches to using folio_mark_accessed() and
begins prefaulted file folios from the second oldest
generation instead of active generations.
We should also adjust the following accordingly:
- WORKINGSET_ACTIVATE: aligned with setting active for refaulted workingset
  folios;
- lru_gen_folio_seq(): place (pre)faulted file folios into the second
oldest generation;
- promote second-scanned folios to workingset in
folio_check_references(): we now have to depend on
folio_lru_refs() > 1, since we previously relied on PG_referenced
being set during the first scan, but PG_referenced is now set
earlier.

On x86, running a kernel build inside a memcg with a 1GB memory
limit using 20 threads.

w/o patch:
real	1m50.764s
user	25m32.305s
sys	4m0.012s
pswpin: 1333245
pswpout: 4366443
pgpgin: 6962592
pgpgout: 17780712
swpout_zero: 1019603
swpin_zero: 14764
refault_file: 287794
refault_anon: 1347963

w/ patch:
real	1m48.879s
user	25m29.224s
sys	3m37.421s
pswpin: 568480
pswpout: 2322657
pgpgin: 4073416
pgpgout: 9613408
swpout_zero: 593275
swpin_zero: 9118
refault_file: 262505
refault_anon: 577550

active/inactive LRU:

real	1m49.928s
user	25m28.196s
sys	3m40.740s
pswpin: 463452
pswpout: 2309119
pgpgin: 4438856
pgpgout: 9568628
swpout_zero: 743704
swpin_zero: 7244
refault_file: 562555
refault_anon: 470694

Lance and Xueyuan made a huge contribution to this patch through testing.

[1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Kairui Song <kasong@tencent.com>
Cc: Qi Zheng <qi.zheng@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: wangzicheng <wangzicheng@honor.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lei Liu <liulei.rjpt@vivo.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Cc: Will Deacon <will@kernel.org>
Cc: Kalesh Singh <kaleshsingh@google.com>
---
 -v3:
 * Fix 2nd pte-scanned promotion in folio_check_references(), per Kairui;
 * Restore anon folios behaviour in lru_gen_folio_seq(), per Kairui;
 -v2:
 https://lore.kernel.org/linux-mm/20260525123205.51874-1-baohua@kernel.org/
 * Fix WORKINGSET_ACTIVATE - workingset will be set to active during refault;
 * Avoid unconditional protecting anon folios in lru_gen_folio_seq();
 * Also adjusted workingset set accordingly in folio_check_references().
 -v1:
 https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/
 -rfc was:
 [PATCH RFC] mm/mglru: lazily activate folios while folios are really mapped
 https://lore.kernel.org/linux-mm/20260225212642.15219-1-21cnbao@gmail.com/

 include/linux/mm_inline.h |  2 +-
 mm/swap.c                 | 16 +++++++++++++---
 mm/vmscan.c               |  6 +++++-
 mm/workingset.c           | 10 ++++++----
 4 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f0..a8430a7ae054 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -247,7 +247,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - folio_test_workingset(folio);
+		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..a44829dcde7a 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -509,10 +509,20 @@ void folio_add_lru(struct folio *folio)
 			folio_test_unevictable(folio), folio);
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 
-	/* see the comment in lru_gen_folio_seq() */
+	/*
+	 * For refaulted workingset folios, set PG_active so they
+	 * can be added to active generations.
+	 * For prefaulted file folios, folio_mark_accessed() sets
+	 * PG_referenced so lru_gen_folio_seq() places them into
+	 * the second oldest generation.
+	 */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
-	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC)) {
+		if (folio_test_workingset(folio))
+			folio_set_active(folio);
+		else if (!folio_test_referenced(folio))
+			folio_mark_accessed(folio);
+	}
 
 	folio_batch_add_and_move(folio, lru_add);
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index e452cb043d46..745a55a3f7de 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -848,7 +848,11 @@ static bool lru_gen_set_refs(struct folio *folio)
 		return false;
 	}
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+	/* Promote on second access */
+	if (folio_lru_refs(folio) > 1)
+		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+	else
+		folio_mark_accessed(folio);
 	return true;
 }
 #else
diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..f351798e723a 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,11 +319,13 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
-	/* see folio_add_lru() where folio_set_active() will be called */
-	if (lru_gen_in_fault())
-		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
-
 	if (workingset) {
+		/*
+		 * see folio_add_lru(), where folio_set_active() is
+		 * called for workingset folios
+		 */
+		if (lru_gen_in_fault())
+			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
-- 
2.34.1


