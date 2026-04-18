Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75F81F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 12:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6470D6B02B1; Sat, 18 Apr 2026 08:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61EA46B02B2; Sat, 18 Apr 2026 08:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55BB96B02B3; Sat, 18 Apr 2026 08:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4667A6B02B1
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 08:02:44 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6EA55B98F5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:02:43 +0000 (UTC)
X-FDA: 84671539806.22.C044129
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9FF4214000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 12:02:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qQ83Nuwq;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776513761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Qetlnm4e+XrEXNG3Zh4y9W22aO5fsOvf9oaAnfoSnoU=;
	b=5S4p5fO+oO9HLhL9rdSuoX2AXL2nAUQWYuZw6TILfMQuLq7pDTTF75SJ6vNxgnkCFE4tEs
	rHt4gsZsNQuZ6nsbGxgu/jz0al3XQKnYC1+DsOLU9EPoQkNRcMd5A5d5lg0tlWmsgQ42CI
	espCldAwEgAyJr+gBFx0vH/PMGk50yw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776513761; a=rsa-sha256;
	cv=none;
	b=wxOvkCO+iRuaRXZsMQ4iWWYO4pzGGctq73meu8XSQtWmBwompFAk3vQW5ncgDPfbcoe0qt
	bMNJa35omUxMstUQ3m18uTOha3B3NkN9IgIC5LrkSES/4ffV8p+OgOMIdjnG83Bn3iHqna
	bLTEtWBGgFrqMtjapf0xRslf4pQY1qQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qQ83Nuwq;
	spf=pass (imf23.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E70E4098D;
	Sat, 18 Apr 2026 12:02:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B65C19424;
	Sat, 18 Apr 2026 12:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776513759;
	bh=V21UBvOvP9U1CNNiWuxT19jVga3l3Si1jOPiw9tClSE=;
	h=From:To:Cc:Subject:Date:From;
	b=qQ83NuwqB9njQ7mPhF4bpNVfiYQ1WC+RMpv3Ll4wqGImrbkRy3IsYcge8vGLjU+MY
	 nCE+RGS7QSuTQyb7zqZCeN2In+Z5GsaUFuX/IxunDGt+pKGGFnlvg1jvHRpiR/c6SD
	 0WwRuE3lgaO6gSuFo2aF/2sw4X8E7BUKnq2seCLXbhQVNm90XnFkuqXR//Mmh2Fd0p
	 BKl/PSB6TEr5WZinAJp0DI9k6N7eoZskv/sG5qWb0DUXE7Y7wKHBJfb1cyl4L8FIS9
	 RXur0jR0g+nQ2aEIjgBl/1JulaMcYvdDmW9NnWG8C81V2NVfltNdEeAVGTYDy4AJUJ
	 qnQbInlN6rbXQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
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
	Will Deacon <will@kernel.org>
Subject: [PATCH] mm/mglru: Use folio_mark_accessed to replace folio_set_active in PF
Date: Sat, 18 Apr 2026 20:02:33 +0800
Message-Id: <20260418120233.7162-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: og616h4djhawk7ereir94ce3odm6bkr6
X-Rspam-User: 
X-Rspamd-Queue-Id: 9FF4214000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1776513761-951834
X-HE-Meta: U2FsdGVkX19XM5IS3L0frXl/L5vrRgCUVPDoLD40Lq/d7x5XEqYAYj9gN/HIJXZrXVyDuLDkr/9DfspGBdGg1CoNVEVqmzOy31X3EH7AIjY5KNmg7iODh3Hmz7aAnqqyki2G+XM7cvYGUwolHecl4g+v2QdSjRw4DVLOeiq4Mc8u+eCB/tl/BRqfoHfeEQLXmUJ2QKYBVDsKatQuPsqwOTMfelft7gihoJKi4dh9QcQnGqPaZqbcxdIKD7eArvqPG1jexVOjldUQwgqy+a998YoI+1R1Y6VaK7VqnDfK01txll/UQeaHjQo7eDdc4Na+MDJo5nJAd98gLx0yh0Ku5jrFEfdWB/NJwUkRjzIIWVYbCJRYpj0A28hHyo54EGvCmJf1I9lX7nXQElJ5JbzTWrzaF/h+oFhK7EZ/0QxIcQEcHuX3hnGIIydCnhsVxNAK6g6acrg98DdRZW9EKvsFHi40rc0xK/pQrE+st+/AMMHJe550vX9JrasoS5WcLww6EVPDUvEYdsN4Kfws3faVLdVPsPdBimLBvw3kkS/VD+IzKe6eqcLHwIKJ915cclZr2OqFKOiLdlfltVMUNV5zvYbhB1c0fm3YaIIiI9PLBDsPpBxsxLdlfP1LACr7v2Uwl4UuBYJJjkrMelcdwTyDdZ/b01yUUVAYXsFGWq4qwbBoyFrRI2dYZ6zNWo1BNUD4ImP462j1b/kZI2TTtQZbodK+kPzNuz/QWp2AYi4vZDaH9OWQ9wKW/da8e1BAZUJb6MOi79Qi0TMrt6PNsZtJZxKdQzax9gmRjtWdDqj95SY8STI/HJgTk2NgQ9HDHk+Qu3q41ddU8kRdU7tnoNBR4AD9SHB2hewtDlfqrzhHB8rRltoxdbDmFBrdESW4ldHcfaPB3FKuC5belKEkLZ6u8oQLCXolSJOEGu3T7wfK655WK9LolR864KuYSW3qpdGkYWWIik9Nab4TUmULbDe
 qClqiZEn
 4PWLW8Htvkr+3uE5nH1mTZTOjVBKEtN33rUt+5BnadNyeUICFgZA6BwbJIOOqpzhpzjbvLTNa/HCShALFCBPSNork0IgsfxQq1WKP1gYQtSWl50x+65De3I4foWKhMlyVBWsx/PUZwqqMkvifSxL3HjS+DPSSmNBJXUxNrVmTfZlibs64FkTAkuiWBrw6AwNNDsBsRt7T9gtSHNJWli3HhW+OWQ1jQeetqkxai5cVjRP332ovsCbyUNkkE6/ScPUkqFx+677/519iU7AcOlZOxuiC6kWJHIf4LFmysBs0zBHKwyCGlh1jcCBUkzG1QDXTR6Yc1M2vbRzXH6DFfy7XTDbNbNNIEjS4i518mGb1p3rwmdA7JmqA62Cc+NMYgXHuODbMEHkN6AW7mLcgpdG7vneTGXB6scsu2NwTzbhWV7fK5LUYn/DCt7fZsOWmzwXFOvvQ7vlHL/gWm7DEyRThPnika9ccnSn+6eOKmWMKYMVXt3IxRgHGLhlSNMpCyrPd/FH9h8px7OHCmxTspR+W/02iGTv1TepI/uNnt0Rk7tKYC9qGpBa/0R8ROWXF8PCAEvmqelP3aQQYOlyU7p3OdoXwWdvBh6WsqT83
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MGLRU gives high priority to folios mapped in page tables.
As a result, folio_set_active() is invoked for all folios
read during page faults. In practice, however, readahead
can bring in many folios that are never accessed via page
tables.

A previous attempt by Lei Liu proposed introducing a separate
LRU for readahead[1] to make readahead pages easier to reclaim,
but that approach is likely over-engineered.

Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
protection"), folios with PG_active were always placed in
the youngest generation, leading to over-protection and
increased refaults. After that commit, PG_active folios
are placed in the second youngest generation, which is
still too optimistic given the presence of readahead. In
contrast, the classic active/inactive scheme is more
conservative.

This patch switches to folio_mark_accessed(). If
folio_check_references() later detects referenced PTEs,
the folio will be promoted based on the reference flag
set by folio_mark_accessed().

The following uses a simple model to demonstrate why the current
code is not ideal. It runs fio-3.42 in a memcg, reading a file in a
strided pattern—4KB every 64KB—to simulate prefaulted pages that may
not be accessed.

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
bandwidth of 58.5 MiB/s, because prefaulted but unused pages occupy
hot positions, continuously pushing out the real working set and
causing incorrect reclaim. With the patch, we observed 0 refaults
and bandwidth increased to 5078 MiB/s.

Note that this patch does not benefit any platform other than arm64,
since commit 315d09bf30c2 ("Revert "mm: make faultaround produce old
ptes"") reverted the change that made prefault PTEs “old”, after it
was identified as the cause of a ~6% regression in UnixBench on x86.
This was due to reports that x86 uses an internal microfault mechanism
for HW AF. The hardware access flag mechanism is relatively expensive
and can lead to a ~6% UnixBench regression when prefaulted PTEs are
not marked young directly in the page fault path, especially when
UnixBench runs without any memory pressure[2].

Thanks to Will for raising this for arm64—“Create ‘old’ PTEs for
faultaround mappings on arm64 with hardware access flag” [3].
This is also thanks to arm64 microarchitectures, which incur zero cost
for HW AF handling.

It may be time for x86 and other architectures to revisit
whether HW AF is truly costly on their platforms, given that
the original x86 regression was reported 10 years ago.

For those who want to try the model on x86, you will need the
following in arch/x86/include/asm/pgtable.h.

 #define arch_wants_old_prefaulted_pte arch_wants_old_prefaulted_pte
 static inline bool arch_wants_old_prefaulted_pte(void)
 {
 	return true;
 }

Lance and Xueyuan made a huge contribution to this patch
through testing. They truly worked over weekends and after
work hours. If this patch deserves any credit, it belongs to
them.

[1] https://lore.kernel.org/linux-mm/20250916072226.220426-1-liulei.rjpt@vivo.com/
[2] https://lore.kernel.org/lkml/20160606022724.GA26227@yexl-desktop/
[3] https://lore.kernel.org/lkml/20210120173612.20913-1-will@kernel.org/
Tested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
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
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 -rfc was:
 [PATCH RFC] mm/mglru: lazily activate folios while folios are really mapped
 https://lore.kernel.org/linux-mm/20260225212642.15219-1-21cnbao@gmail.com/

 mm/swap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de987..e3cf703ccb89 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -512,7 +512,7 @@ void folio_add_lru(struct folio *folio)
 	/* see the comment in lru_gen_folio_seq() */
 	if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
 	    lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
-		folio_set_active(folio);
+		folio_mark_accessed(folio);
 
 	folio_batch_add_and_move(folio, lru_add);
 }
-- 
2.39.3 (Apple Git-146)


