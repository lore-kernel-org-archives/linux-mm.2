Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C01B606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q9Ml+7XL
Received: by kanga.kvack.org (Postfix)
	id 262BF6B05C2; Tue,  3 Nov 2026 03:28:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213926B05C3; Tue,  3 Nov 2026 03:28:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DC306B05C4; Tue,  3 Nov 2026 03:28:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2A366B05C2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66068140317
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:43 +0000 (UTC)
X-FDA: 85393131726.29.2BDF1CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A307C4000B
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9Ml+7XL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694521;
	b=RmZqR2prRcdgDESVpsxtMiwKL1Q04QAaLG96dzGH2JdyDY3ht/DmJ4sYS3KunF0X4wgQOq
	rtObs+48u7mOeDKJJ9Blpj4vfeA8YQ2U3s/IUMnuFStR4qEdhJEY2lp/X34AaraCc8IbVe
	mN/T/SYHabZpwY1zJRU3cVL+c+l11Ys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q9Ml+7XL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+r8pnwhMHB5jLX3oATZwY65Zu2eC59JDXV4HC2urFtw=;
	b=JElY98fKT5gSiW1BgIcBlql8/VIYeiG79mBUiJsdCopjw0B9zN3TSQsT1Mi/2I7cINrZTX
	Hz7/hMARd0Ndyv5B4fpinR6hpSs85mvemTjM8ksU/OBrEdFUOSsQk/l/kpU5d1SMPLRX52
	2pqqCeEqf08GobobVzxRZhYjoGVMaPw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 426C360416;
	Tue,  3 Nov 2026 08:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246291F00919;
	Tue,  3 Nov 2026 08:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694521;
	bh=+r8pnwhMHB5jLX3oATZwY65Zu2eC59JDXV4HC2urFtw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Q9Ml+7XL7Kuk3GUTX3YwuXtB84wQiQO212b9iapqYfTrZMxSxUD9870E4QjPxde7Z
	 +VBXPp2BK4psoSYwtPWPFT0lNNU5ZOfRj1/xsEtAJVXdO6Yl1K8ZqHSXE9REXO8T+O
	 flqv7GTIsCyTzpdfyOaCRz40r5ihfxv0RwZ50H/Dr/CMH0JCUEfazP8VPnRYp3xBm+
	 uoQqlp/wXSp/ulahJmYjE4RLhwo6Nv06EtnyIcosgU8Tctx76oAEKSpZMiwvj/YQ6b
	 rMu9iK7DbIvjNFY4qzFi0F6Abd80x9PzgoqsmkT97vq3vp+xz4K82f6T7dEWLq3cO9
	 HteKyHxjiGzkA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 03 Nov 2026 08:27:46 +0000
Subject: [PATCH 5/5] mm/khugepaged: drop/reacquire mmap read lock if
 skipped enough VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-khugepaged-latency-fix-v1-5-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
In-Reply-To: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3038; i=ljs@kernel.org;
 h=from:subject:message-id; bh=7szhW9anHqn+tjJY4eGPLfmwS6rN78UkiZRvp6JyL8E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezub5E/2p1nzGvw2RC0/PE9vdXPljkpbzJDbPr2eLw
 x1/n/10taOUhUGMi0FWTJHl+Rfx/UEiYfM6L/i7wcxhZQIZwsDFKQATWefPyLCsRGvj9/87Q+ON
 +JuWvbHUvszw8+Zn+4x4771vXJxDSiYyMlw0E30iNvGZe2Vzo2Vi4cx5afFFmneO+J/RuPjGyi3
 QigcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 7oa6rtmoycum491zu686yeux9tar5hry
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A307C4000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793694521-728203
X-HE-Meta: U2FsdGVkX19lH1+wgwAFrOLK+1IcZjIMAz8SfRpfXg1R6cYCjEBOrLwKWKP3pxfBjJmhwkN2H3Zf5ne6OJtG5ndrYVOTedxTJD9NILdiHdWB6Bke9+83uGQEwSW/WLPPQ8TD0FVs2t1owQ2wFf1dKpDuL/moe7nkLhCagXWVLM8OGf+HXa7xpOraogfHagV86f2eKfJGdU8QU+v3kcttrIkXLFym3W3yA1UeojHS5gFDaaAK7gUHZMkuGt4QYVFMHdmnFw+myqhc6rmkqKKif/E4rGuhg0mE6F4UBxmowDqHRyysfHVw3NfyJzlxmuNbUtnpDWayfjCf+vkGqd1Tbe2k1N3xuI0mJwLlxdn941FecblWZPcW/wRDxpcwqbYlheVjySTS8+vtiB49RfUOHBqOkeYUY2yx6OwIhxnx8LoHGd8HMGK+KYtEkQzbqXhll3Rms6Q0tMLTfGpKMgJXABZt81Gzq7yTc/DevpSYH1VWB3IMWNcnRnktPCMY6ACCM6P1SSx+tG0cXFT7Aq3ywnS9d2XrLeyHRYLDyKi/nlYwZBjtCZDb8OK5KFl6/UF5EEaLdHjjtWKthBnnB81KuEoUT7553J20dvmcW89PRq9zp77gm/JOOLQRALLrFpHJeq2Xq3iMFk102hCmVw2Fog3kLBp83CjrWV3TaHeIXeJLrqnrV9AUKCg0hXiZTk78PJ58yPN3e8TYoG8+lFbY6PENXNEp40mvMaVxM1Baunu3CI+LPHpkzA0XNZctJV3rjpkCkxadJzGjQ8bel6UWCZIWbHaWc62QeOgW7vlIvOSDEb+kgixCnv5ffmF6+7DhKDY6hjadvQLxxOmp0iMyLE9iNnHODNGICu8zqRWMAeeygwBKEm1zkeSLEcdWIOm4rZGiqIvERCpVHpX53mjIb4/aFpY+yCnnRwfUlyxJUXRoN57x8K6RY3dczJAwe3PLYa5oUEX15gOY1+2Ex8L
 z7FtsONp
 MC5ZJDzLONEExIqAS/NkFlJZAoIjY567wwNVElrliJ4Pm2nWGbIxMif5rpV1r8U4kHaqmPKaCEFez8eTghTv0LZNQpMTs1mfF+SewtaX7CPA12rndyCSzTPhFdjXWhkrpgNKtOuq3BbtIhrH1zAiL5HE7cOK/l5vpoRs1cHx+Hig+qI3GQbcCQro+Bhk5HsR0wql7SdHxz8O7V6MP+d9BLhHS48+PWNlZR/fRJfO2Gl9ZTkQoeKuw5bFXig==
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

It charges cc->progress 1 page against the 8 * HPAGE_PMD_NR budget when
these are encountered, however only checking this budget once an eligible
PMD-spanning VMA is encountered.

It can therefore hold the mmap read lock for a long time if there are a
large number of ineligible VMAs present in an mm, over which time no mmap
write locks (and thus no VMA write locks) can be acquired.

Address this by dropping + re-acquiring the mmap read lock after
KHUGEPAGED_MAX_SKIP_BATCH VMAs have been processed. Use the newly
introduced mmap_read_lock_nosteal() to ensure queued writers take
precedence when doing so.

This was tested locally with ~1M ineligible VMAs mapped ahead of a
collapsible region of memory, and resulted in a reduced mmap_lock hold time
of 170us down from 95ms.

This was also observed to reduce mmap_lock stalls in concurrent threads of
a similar duration.

KHUGEPAGED_MAX_SKIP_BATCH was derived empirically to a conservative value
of 1024 VMAs, which should not interfere with mm's that have an ordinary
number of VMAs.

Local measurements indicated no change for ordinary use cases, so this is
all upside.

This work came out of investigations into mmap stalls when getting latency
numbers for an unrelated patch series.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 216c4b8d28c4..b9c72ee8b421 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+/*
+ * The number of VMAs with nothing to scan to walk before dropping and
+ * reacquiring the mmap_lock to relieve lock contention.
+ */
+#define KHUGEPAGED_MAX_SKIP_BATCH 1024
+
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
@@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	unsigned int skipped = 0;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
@@ -2951,6 +2958,14 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			/* Unable to collapse, skip to the next candidate. */
 			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
 			cc->progress++;
+			if (++skipped >= KHUGEPAGED_MAX_SKIP_BATCH) {
+				/* Skipped a lot of VMAs, so wait for writers. */
+				mmap_read_unlock(mm);
+				cond_resched();
+				mmap_read_lock_nosteal(mm);
+				vma_iter_set(&vmi, mm_slot->address);
+				skipped = 0;
+			}
 			continue;
 		}
 		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);

-- 
2.56.0


