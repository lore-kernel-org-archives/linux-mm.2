Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F1EFCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 730A86B0098; Mon, 25 May 2026 08:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708596B009D; Mon, 25 May 2026 08:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D976B00A0; Mon, 25 May 2026 08:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBC16B0098
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:32:15 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0A2FC16161C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:32:15 +0000 (UTC)
X-FDA: 84805879830.27.AFA0B22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 656DE1C000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:32:13 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acqgUbrM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779712333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=lq1hhMcZSc4bzpk+pP8rA71YpSzcnilUE2l2IgB4YxY=;
	b=w4cA6gfGlW8QslUHxKePJrfP244bdwpRJVt2fVTa60/L1yt0KibdMU2Rk2QAECB1PEUKdN
	a4PUUN3AEp5oIsZM3FfuUkVztRkM5vARGDYvSjq8EiYfy4i2ov3nWMhn1m6eSe8/Pjy0WW
	QromOq+0di0u3ZGFLft1JJNWhF7MfAw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=acqgUbrM;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779712333; a=rsa-sha256;
	cv=none;
	b=llBoljhS2ctoMsHAYyiYpvtkKrJCjH4AeAJwXobdKEq7DHRR8cUBgYoNB3j8EQFJser/JW
	dvhWUZuDkSGzYsVO+plLg0uNF/hjLwhJq9pfYQqZdD9vZO0aXA2wgXFQXS9u6VUMX71a20
	uNvKJsi+gvd+5bZx9xmtC2EnVJhgRiA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E47E415EB;
	Mon, 25 May 2026 12:32:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F671F00A3A;
	Mon, 25 May 2026 12:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779712332;
	bh=lq1hhMcZSc4bzpk+pP8rA71YpSzcnilUE2l2IgB4YxY=;
	h=From:To:Cc:Subject:Date;
	b=acqgUbrMlubnoz+wa+E0pM/77JO66PoMW4lWUmsbl6qZTM9IGS3TmS9921ODBX/Xp
	 4kmClexamPheD8LhLJ1kAD681tnvYytHoESmXu64/dMvxAJRqBqqntwaQ63kjs05lE
	 D3K1I1jcG6j9tN57JAhUi3o014MOFgp+KUxmr6AzWEHtot3YXbzPD5K30wFg6JMXp0
	 e68YYaS+wFyGoFO/JFc2hhRdE/OudJLd0r5jVXHgnUWDVKo+wwcxVQIx3Co+GYCeKg
	 sxKOS4T366mXYuFvDEs5YNY33QqZiQrlEK3wSBC2OYngK6Un11xZv4cM/NM1c4JtgF
	 UrkwJ5cviXnzg==
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
Subject: [PATCH v2] mm/mglru: use folio_mark_accessed to replace folio_set_active
Date: Mon, 25 May 2026 20:32:05 +0800
Message-Id: <20260525123205.51874-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 656DE1C000B
X-Rspam-User: 
X-Stat-Signature: 46whsxwob6wznz4sjhfhpcin37zdhawp
X-HE-Tag: 1779712333-818392
X-HE-Meta: U2FsdGVkX1/LZzhVcUHYmdsaMKOimdNc6rO4vX3BVSUI6FZ2nNZ/EEjQLCNJB90Kmmncsn+VKDaxomDC2o8Gb3s3G/qprqS9rKt62oLu5DPA7qLg2ge6+eHMAg8zFOnmu43yj+r4yv8PyijbJpOrQyYF3hauDn0E/mX+3/re1q5Bwl8lrOi8KzyVDTr2nOjOpFPGpUG9EMHVlD9JMwNBUnrNWU2wA6HQ+0dbCOxKr7aEojWhJF19aamxFWW9iATo9y28lXKSMqIqh/5FA0RlFP0TPRobD3bUN30EZDBkVFfIq51BQIao4gQtMYQnoq6JQyF7OjYfPi1eb60UhoYGZakh9DJ8IswhPScgJjsME8byfpuHcFBDMBYJerBgJB7UI5dH5tf6c6lRcCNsr5RDFfLCvxyQGDQhjnwuYe8Ti8IClZxDT5Pl2Sp49v+8qGhoS/Ru2uWLWD/7qMfZyzvjEtURyHjgiZzpY/AUwkjTp+bWvrxIdSK9tlfTuee5G5xNjuCNm2mazp/u1FDt77e3xf7MdyGDExgNLC3z36BW1PGvdAAypGafoB8KTgIHuQkS6W7Kg69nvy7q6LfZ6G0Ckc37XUzHaHKDqSOOIYqVyxwDHO+R7euUt8USCiPP8iOyhiYurjVYNQNjfxpCrk6U8ya/NNMlwAQWHr1xkVMzleTNuEvC5lMbNmthbHH8JO82JnMmBRTBsnQO4KsSHAyVdoclWfnsd0OCR0U7xv2TlMFD5cwsE0J+a5vMpFd+w6IaiQ8W+9nhS8ctHguWDXAyFKa7gfVIKbioM1xU6LMJ8IagTb2QyDRPt/2L8+RBtFLrLpk5k9sFvXzPXK8j7n++Vyg/FI3ONiHZg1nIqXlhnWOaxzIBiCjNao4+0ksyMstfwi7wSWWdnTO6s49InraHUQ7YvrRpEV4ZuEDYx6SVeZ4cwH/vPPoH2BuyA3j7ZyhBqW3XrQ7abJM74/OUDb+
 alCQHjP2
 LkJ58Wc4bnnh9fo5bS+ftxZ7ccm3bu01tZs3IVcpXeDBiazM3CX4/D2GTRoyoLCM1YHlv1JYaN2O2PBkf5aofUYgr0+rg9SWazo90w6dJtem4THyQk+GQX0O1MS9wX62i6+Apo4WnEgvCbILClmPW0h3SKL31FrBQ/uLNXqQ/7AqE9RM81cD6wYoyj64WAQ3knGyV7VRCm2lEpIWqSmHe2HKOkncAzB6CJoeJF6tNlFKb4WKbxKFm7dnPqlT5JUJgWKWj6iKmoqsX0xBrTBENCtW5RctkINKr35oZoyUJNyRZeXLwkKTayECTLW4v9NsWrzawzAGLO+BIPJ91A8qBrDaF0GgI27UBFg+WQO5w+JrtUxLCzZdXHIzsBQPuYJWCDX7JFm2R/OMIpqVHZbYrQH6id3575Z9Sj5m9hUubkTcHMqNOo/ehDszszle4qmdOQ6muJRSf2D+uFqW/FIZyWmkMn5KjeDmARBEd9H2mEWQMIqdUqUegj1eZ86OlLcC5R2cKQzihT1tmC0ma550bdZBjpCt3poYi8lw9/FeyD0QFjXOx61EF8642vXpZxaPcwRZ4yZPeqaI2IwDi5VNf6/JWEwRonl6l5fLf
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

This patch switches to using folio_mark_accessed(). If
folio_check_references() later detects referenced PTEs, the folio
will be promoted based on the reference flag set by
folio_mark_accessed(). We should also adjust
WORKINGSET_ACTIVATE and lru_gen_folio_seq(); for example, we should
not unconditionally protect anon folios accordingly.

The following uses a simple model to demonstrate why the current code is
not ideal. It runs fio-3.42 in a memcg, reading a file in a strided
pattern—4KB every 64KB—to simulate prefaulted pages that may not be
accessed.

 #!/bin/bash

 CG_NAME="mglru_verify_test"
 CG_PATH="/sys/fs/cgroup/$CG_NAME"
 MEM_LIMIT="400M"
 HOT_SIZE="600M"

 # 1. Environment Setup
 sudo rmdir "$CG_PATH" 2>/dev/null
 sudo mkdir -p "$CG_PATH"
 sudo chown -R $USER:$USER "$CG_PATH"
 echo "$MEM_LIMIT" > "$CG_PATH/memory.max"

 # 2. Prepare Data Files
 dd if=/dev/urandom of=hot_data.bin bs=1M count=600 conv=notrunc 2>/dev/null
 sync
 echo 3 > /proc/sys/vm/drop_caches

 # 3. Start Workload (Working Set)
 (
     echo $BASHPID > "$CG_PATH/cgroup.procs"
     exec ./fio-3.42 --name=hot_ws --rw=read --bs=4K --size=$HOT_SIZE --runtime=600 \
          --zonemode=strided --zonesize=4K --zonerange=64K \
         --time_based --direct=0 --filename=hot_data.bin --ioengine=mmap \
          --fadvise_hint=0 --group_reporting --numjobs=1 > fio.stats
 ) &
 WORKLOAD_PID=$!

 # 4. Waiting for hot data to warm up
 sleep 30
 BASE_FILE=$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | awk '{print $2}')

 # 5. Running workload for 60second
 sleep 60

 # 6. Report refault and IO bandwidth
 FINAL_FILE=$(grep "workingset_refault_file" "$CG_PATH/memory.stat" | awk '{print $2}')
 FINAL_D_FILE=$((FINAL_FILE - BASE_FILE))
 echo "File Refault Delta is $FINAL_D_FILE"

 kill $WORKLOAD_PID 2>/dev/null
 sleep 2
 grep -E "READ|WRITE" fio.stats \
 | awk '{for(i=1;i<=NF;i++){if($i ~ /^bw=/) bw=$i; if($i ~ /^io=/) io=$i} print $1, bw, io}'
 rm -f hot_data.bin fio.stats

Without the patch, we observed 12883855 file refaults and a very low
bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy hot
positions, continuously pushing out the real working set and causing
incorrect reclaim. With the patch, we observed 0 refaults and bandwidth
increased to 5078 MiB/s.

Running the same test on x86:
w/o patch:
File Refault Delta is 3240029
READ: bw=13.2MiB/s io=1183MiB

w/ patch:
File Refault Delta is 0
READ: bw=7708MiB/s io=676GiB

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
real	1m48.915s
user	25m31.261s
sys	3m43.685s
pswpin: 915629
pswpout: 3207173
pgpgin: 5249268
pgpgout: 13154492
swpout_zero: 816100
swpin_zero: 15676
refault_file: 257271
refault_anon: 931259

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
 -v2:
 * Fix WORKINGSET_ACTIVATE - workingset will be set to active during refault;
 * Avoid unconditional protecting anon folios in lru_gen_folio_seq();
 * Also adjusted workingset set accordingly in folio_check_references().

 -v1:
 https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/

 -rfc was:
 [PATCH RFC] mm/mglru: lazily activate folios while folios are really mapped
 https://lore.kernel.org/linux-mm/20260225212642.15219-1-21cnbao@gmail.com/

 include/linux/mm_inline.h | 7 +++----
 mm/swap.c                 | 8 ++++++--
 mm/vmscan.c               | 3 ++-
 mm/workingset.c           | 8 ++++----
 4 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index a171070e15f0..c637e679a450 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -242,12 +242,11 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 		gen = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
 		gen = MAX_NR_GENS;
-	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
-		 (folio_test_reclaim(folio) &&
-		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
+	else if (folio_test_reclaim(folio) &&
+		  (folio_test_dirty(folio) || folio_test_writeback(folio)))
 		gen = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - folio_test_workingset(folio);
+		gen = MAX_NR_GENS - folio_test_workingset(folio) || folio_test_referenced(folio);
 
 	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
 }
diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..f320f93d60df 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -511,8 +511,12 @@ void folio_add_lru(struct folio *folio)
 
 	/* see the comment in lru_gen_folio_seq() */
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
index e452cb043d46..48355f10542b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -848,7 +848,8 @@ static bool lru_gen_set_refs(struct folio *folio)
 		return false;
 	}
 
-	set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
+	if (folio_test_active(folio))
+		set_mask_bits(&folio->flags.f, LRU_REFS_FLAGS, BIT(PG_workingset));
 	return true;
 }
 #else
diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..2f0c08aa8623 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -319,11 +319,11 @@ static void lru_gen_refault(struct folio *folio, void *shadow)
 
 	atomic_long_add(delta, &lrugen->refaulted[hist][type][tier]);
 
-	/* see folio_add_lru() where folio_set_active() will be called */
-	if (lru_gen_in_fault())
-		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
-
 	if (workingset) {
+		if (lru_gen_in_fault()) {
+			folio_set_active(folio);
+			mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);
+		}
 		folio_set_workingset(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + type, delta);
 	} else
-- 
2.34.1


