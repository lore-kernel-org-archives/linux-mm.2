Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD55B60A2603
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OovIHZa3
Received: by kanga.kvack.org (Postfix)
	id 04DB36B05C5; Tue, 10 Nov 2026 12:19:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3FCC6B05C6; Tue, 10 Nov 2026 12:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B826B05C7; Tue, 10 Nov 2026 12:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B66116B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:19:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43F041409EE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:37 +0000 (UTC)
X-FDA: 85419871194.11.A48A145
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 65FEC18000E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OovIHZa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFrBAQI4dIm/fP3ro/XqhmpHfLGZgz+aDz0WQQ1iWt4=;
	b=vb7/iLIXVZBoyN23Nj50efReLAEElZuPY7UdTLwcZKWlB8HXA8man6F5t6TY6u549qflII
	EegElzRP3sHoTrUeZcrTnXNeLZmdqKaUl3mUxqJ6nH4g4gn1Xbeji3JjF6+8AT8qbIkVQI
	XoSG06efDiMtb/Id1vLGz25getGgQt4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OovIHZa3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331175;
	b=1u5MCRGR7OFH4wObPF4UIfY9LVeU80SAycCtM9Y94BeEOv8XnwVOwUxjJDSrqR+hI6Kykl
	+lmLHaXy33tF31LMpWsbsExDKluXaRBgqWKCduM/8I3psgdHAuh79pr0wp+VqbbQ9WcqXA
	7GrSnToqIjfpwVYozavlOwL67yVXQg4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A8A2140F7E;
	Tue, 10 Nov 2026 17:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBBF1F0089F;
	Tue, 10 Nov 2026 17:19:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331174;
	bh=KFrBAQI4dIm/fP3ro/XqhmpHfLGZgz+aDz0WQQ1iWt4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OovIHZa3P7XGNFcuOtc9v4pvh1X4IidT9UiIpEQNMPNShZLqJRZLcslYhiieRMeGa
	 I3GVMyyox1TGLLEHeVvRbPwbdZp96PbI1kbgYhgDjMAcmpkrWYXwcw9ei8wPvJloem
	 Y4BzjUsCkU5mhvc4i7md/MaP4Noq6wuHmqd8IkK8VyrRnu4qShhW4HMRLo8oj0XPc4
	 02cgY3EsknZOVNUQ92+gwHgnZPH/+tgv1ZpTLO+OiAT0cpVVIXp5kgN0X7SoVhQe0H
	 8cmG+zn7sPo4HOjmAq0ktxpUuk2llP+vnTQUVON7GM2eR/ncoMijuIzUnL9odkLvxE
	 NgPWs82P0dxng==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 17:19:13 +0000
Subject: [PATCH v3 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-khugepaged-latency-fix-v3-3-6eea743cf9a3@kernel.org>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
In-Reply-To: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3442; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ckbCh9orwtsZv4mAlUI9tJN6KMn95OOQcVZzcKqPlhw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+B4keLg0QF968ozFY+mzChkmtB+YKftN3Yw15KKwh6
 7+zs6u8o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPxrmb4X9x3/dTurd6Pjvzu
 Ej1oeq5p2pLPf+RTQzzS3U/dbDjcYMPIsGNurzzz878TMjQfduf/vSpu0WPQkGkzbze7ye/LF99
 NZQYA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65FEC18000E
X-Stat-Signature: 4w8oetijbj34rwgm58niwtgadtk5jbut
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794331175-935358
X-HE-Meta: U2FsdGVkX18YV6hUnSSA9fTNDMwXRzFD59HLJcVmwMc9XX4xVBD/Z6Cfh3eIbn2a8bHHBERAeKX3N5J1G+pjqpAS3tFHlU9b7KGDjmTSn2JTTb5k6/BNv6FgluG4YLLql4/krve/m51eGpINjIM0gFhhS8CHmOl6a95a83BheeUhoyyJn8De4PzDhsmXBeuP7n3YLh3qbFpdyOqtzECPkqogWKmT4hMOG4Lsu2x/Hyi1xjctVy78VvrdA9kKOv5N3pSkCUT/rWGW/suA/havmL6ev/BBgk7/CKDmUGGlkD2Uv7hX6YnGra465ihYeprqjTda2jYQEdzEKANucbbgBkBYVsI0aMdiwSy8SJ21b022KFXjIpWO2GTwYnyZ30l56FDqp9sgGhVny1Kt/bcC94tqJoJioLaM6Lj8i9pDNKQdaXO8cHeXqmZNkfAXuBe8P55DraEq+9XbDOgr8Bf3iKG8N43WQs9zek9o12mKH1yT7Xwnczs+TbmfRHBBvUgGcDh9iJ+ZXMS1wbxRnur+C4DcNdW4XN+OydF4j5qEkHFn8En0Ly6LkNbh0zczPwf+CnGz5NualoMGMfncyfAiSwuDcS2ST//4td522XwNwpCxKC1uYqYLeymfFXIzV1bj00DY8CqhaSJOatdi0TNlTfBw+xLJtvkLMiqtajkAI8I1AHUol5lQzHbJe13uZkG5bsamcAx0imw1BMaNCO2ASgZYYJzDcm9gbBigsYKdQSEJS7Q+2OubmbzQtFffH4b9t+K9vmT7bC3AiyphUrus6CBj1xDXloXT1VxBm3958L36tNki0Q4Cej2NTePKShkqGlGAGchSc4XAD5Ph8v1wEbigPET8ufVFLl//McqqzAiVj18rQ4dT0/LH0dYKgMnFwtArgYQA+QrW+w2uH3HuP7SWHRleeJy0epC/dyYTktAUEwI4IYdgNef9KAddNbPZbxWKvRhSCPQZ1zzsMYH
 R2rAkLUT
 rN1vZrcApYi8L60eXYbyv1Cj9SJo9ARNYoIBJRlnvOgpOLSySfMQ8ek21HXh4o1GfgK/r4gfr8BLwWpNHHSU7TdqS49d8457flx9cuFu9/pb8PkWC+LNMEf97V/9zi7RFR8sC8WfS2014iVeDOOzn+mDeDz7abvfMnePz5VgGv7cyzlc/GP1on8nYICA2AdUMbRTl+dwBquQVnuEFt/ib/1dYimXQ+mPadpP4u3YLxgJnoxVUpHnLTfdCRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

khugepaged walks an mm's VMAs under the mmap read lock in
collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
them if encountered.

It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
when these are encountered, however only checking this budget once an
eligible PMD-spanning VMA is encountered.

It can therefore hold the mmap read lock for a long time if there are a
large number of ineligible VMAs present in an mm, over which time no mmap
write locks (and thus no VMA write locks) can be acquired.

Address this by checking whether the mmap lock is contended after 1-10
ms (depending on CONFIG_HZ), i.e. the granularity of jiffies. This is a
long time for a lock to be held, so is a reasonable compromise for
determining when best to do this.

Skipping an ineligible VMA costs ~100 ns on tested hardware (x86 server),
so a batch of 1024 bounds the lock hold to ~100 us without expensive
high-grained timer checks.

This scales for large numbers of VMAs, and tests with ~1M ineligible VMAs
reduced the maximum mmap read lock hold time from ~93ms to ~110us.

This was also observed to reduce mmap_lock stalls in concurrent threads of
a similar duration. Note that a reader re-acquiring the lock can currently
steal it from a writer that is queued but not yet running, so the full
benefit to writers depends on the linked rwsem change.

Local measurements indicated no change for ordinary use cases, so this is
all upside.

This work came out of investigations into mmap stalls when getting latency
numbers for an unrelated patch series.

Link: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 7d1414a9b2a5..59bbef61f104 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,6 +66,13 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+/*
+ * The number of VMAs to walk before checking for, and relieving, mmap lock
+ * contention. This bounds the maximum mmap read lock to an estimated ~100 -
+ * 300us depending on hardware.
+ */
+#define KHUGEPAGED_MAX_VMA_SCAN_BATCH 1024
+
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
@@ -2910,6 +2917,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	unsigned int nr_vmas_batch = 0;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
@@ -2942,6 +2950,18 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
+		/* Relieve mmap lock contention after walking a batch of VMAs. */
+		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH) {
+			nr_vmas_batch = 0;
+			if (mmap_lock_is_contended(mm)) {
+				mmap_read_unlock(mm);
+				cond_resched();
+				mmap_read_lock(mm);
+				vma_iter_set(&vmi, mm_slot->address);
+				continue;
+			}
+		}
+
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;

-- 
2.56.0


