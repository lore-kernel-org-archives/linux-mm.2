Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB535606A326
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YLUSZFxp
Received: by kanga.kvack.org (Postfix)
	id AA6526B05A7; Tue, 20 Oct 2026 22:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A57356B05A8; Tue, 20 Oct 2026 22:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 945AF6B05A9; Tue, 20 Oct 2026 22:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63FD96B05A7
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:30:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BC1CAC0439
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:30:15 +0000 (UTC)
X-FDA: 85345053990.18.62BF482
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1130814000A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:30:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YLUSZFxp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792549814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UpWlAbXZ3XIxfmYcSBSEV2A521nrJ8xRsK3NaAAoXRQ=;
	b=JRLo90Kj2/87IRZCLUHwBgG7jtK+z8MTD7THP+rk6ztvp3J97haX12Lj4CeJv/xbhI7DDW
	UCBcRcMosXqqyaf912QxX13z17Gbg58vBacmM0LfHFwS9VKywpQ63sIKFG0FuFavB4keM8
	dyifcXiXwA8Bwd5lk17MiJsJxocGYlM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YLUSZFxp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792549814;
	b=W0dotqRXHiomkHTMYF+qbOox2JkORFKxZXnX6suPuNCDiYUC5I0Jmce97duJVLAakhn9Wv
	ewagin1xtBjwoabF00+BrqkYs4v/yaZhvx0+zx27jLAZj9+aOAeOXAn5lDQNQywTr3gSux
	3RWAEyVb6udvcKbMoaKbjge9YT9GV8Q=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6767d92cde6so218330d50.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 19:30:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792549813; x=1793154613; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=UpWlAbXZ3XIxfmYcSBSEV2A521nrJ8xRsK3NaAAoXRQ=;
        b=YLUSZFxpEY/6TGYlj7JfxLPjjvaZEKz2CEAW4qKqGUr2Df+SE/AQSl32H8jaT2sFMu
         A3XinZ5+oJ5VkfKTatOXqGvEImbF8rHj1XXoVFdwGKYoAgYyTLPNqM9wMJss44wWeTs8
         cwP58NnZC4sZJUnwNMqPmiGQoHdvkSRxkebqrCJ0UuCPeNKcR+8MpvXzVgoe5N9woIhG
         JhEbHoZQK26PGi3KEx/kRoAXRV5kN7FwvrmKQtDpbvo1feY3Suxd+6uIAcCF2uGNc/5f
         yv5mwsfAfScjeHT6DlLzN8y/Kxl/B1n8g31nf70wEbVD6tKqdFSFohWdcL/xIJtPZWEc
         NAXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792549813; x=1793154613;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UpWlAbXZ3XIxfmYcSBSEV2A521nrJ8xRsK3NaAAoXRQ=;
        b=B192XG2siuZzrztkb6p4OobdUhlC/4YZZ6FDtykll5TWjiWfI6NFhpmfS95f2gS2yG
         2sKksxbtXtQr/qP6VegZkHFd4uN6MAVA/v8JdLfn7lqO9kK/DgpusKlJ9+tGzcaqLX1m
         k4yZMSr0IErRIka6Oqgdh4LPR8vSKYK/Zm/t0EhyFjAIvjD+tGWUnQqxLN7/ypSfBuJD
         nOql5QvhUIkeh8LMDDs7R97JnIwCR8dYcPn5bXipCVEIatc/xHYlLAyF3tx4C0vuAZ9p
         VPpUiQ8StgfZA900FHX20ZkOUV2YxGV4+qL3bX6ISZMT857dB8U8MMnKIz2EoYsd8n0u
         djCA==
X-Forwarded-Encrypted: i=1; AKwUvByc+WL5DkE6MnqHweaxTQ5zxmcnB6fK60eDcG/R0mkN6jWpWpOC8hlU/5I7f/LUWuqSFZ704t9egg==@kvack.org
X-Gm-Message-State: AFq9FYLNLBhbdDIoglKKVT6tO1eANbLF6XBzPKiIpOm8AnJg5PHYw4dP
	RzPCfGu1/wCJVJWOdePAnfndma92Z+06jUcXdkPur8H7rGFFST6gN1e9
X-Gm-Gg: AYBFou36QR1eYVU90BxNIhRwPmrTJnn/6BzImb7MHzYTKs0xpRJNtn9RZ+Nn9j+nWVD
	fEekgc2wfkSSWB6vu43t2YGYK2sAGMu1BiUVTpdPtQewqmllvO3If4ExaZ25tBX+/rjrnIGuxhj
	o9yrsIC+tibsfWZy3wuu0+UUn339ZiJiwNWom0sNBdUYrgUncTtHHu0NglMOVDDti/Dhqz8/Mgi
	pHyh6oGUpxXQigbCZX4pY9e2umoinHsq53jbuMF7GviCQXhG9gddkjq4Z9fgkph2UI5L3oQNkIr
	iqRvBdMaWnOzfwwEIUkUQK0fx+A7WUADnzL5xaH+8pAJ9H6ZUfsjnfqHjDLcqmUEvWQcybJxLFl
	DVrsW+8ldFzDERDBwlumeAHjBpGBATkG31+6hvC/ZFxuJXya45Pq2fMFsRexAGR/6W/2kgqhUJT
	YbMDmRe8yu2ereol81VkpCbEwiC9mKCUMpFRIE5RJf4f9TxSk+Y5bUaQmkM2oiF04UY5x/VL78e
	W1co4gsxgX4YmVYvRdJRIiBEgApwdS1tv+x8w2J0x20q5pGKC5xUKf4yB4UiDpklvdy7BnhuyGo
	LiSB1EF44rHq0f2p+5L0vifq1uyetCBM
X-Received: by 2002:a05:690e:b87:b0:679:98dc:b39e with SMTP id 956f58d0204a3-67a0e589c18mr438090d50.80.1792549813020;
        Tue, 20 Oct 2026 19:30:13 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:4e::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a0e4914eesm468827d50.4.2026.10.20.19.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 19:30:12 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/percpu: clean up callers of pcpu_obj_full_size()
Date: Tue, 20 Oct 2026 19:30:11 -0700
Message-ID: <20261021023011.3199331-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1130814000A
X-Stat-Signature: 93yc47699qk7i5pp4uh5syknmgqdipms
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792549813-285519
X-HE-Meta: U2FsdGVkX19k62g0Fs8Zk/F+h2ejuSxzLPRHlDc2WHDnxDXMcH5c9qSykBhCka99zTo6QhJTUzxxTuibdukvgsfLYlVFa4o2BpiEF9wLtyfrzezILMyx/ivzB/mVn9JXxwl+dLBb8WM0QNVVzpUJ/F/dxNrjuS5QGAo16kli3872Kypid/J62trU5kKmSbkXwmVBMy5JwYVdG/GM9q6BIAaQxShzIp8YwJoMbOmEd3pzMoYnHjpXAg+Sqmgvl7IZdw6E+d8azy5Lcwh9PSJkAK0YWKRl1Y3a+8nsQIimQHxSYMjlydbw1W58wcUxRVD5YpXvYBF2n6DEgTevaOmBjulxl29dD/zEJ3MZO7NcqTi5msZ6I47XvrS0V7/W8+ZuFAbaE+pCbPo3iIpywhpXPTWbnJRzHVy61KT+GgR35NwZRKu7mIdWqYE49tuST0tQg2YPIeWH05PKhXbT2GYYd0qGZhCLUYkNOVaL1u6Y1paQ9aR7tHPukdFCdvroWr2GiSd4DXjdXGlegcKC27RlECVCFAYe5pRXvQlxCLXcNQVZwnmoY0kDeWxLR27GaePuCe6txK6iOuwlj84ENM7We9yUk7S1GdHjIntY0RQrDCghfb/V/aMY1XeSBVvmRBirMIy7r1cU08YUF7kizcXm9w7TeNcU0NRaW7YZz4dG+HGf5tYfeJn6deksAH/qXu7vcpd6HSwkC3RW21m1mOg2rdif2YExIf4Y4eqI5v+YgNsh5Vf6uJC0z4NubPAdUdGBiHxwG5asRIrShRST6gjwpDXgjE/F1RSdQSBBHX3iScnFwA0UFETIYgdoCzHy/szf8SkE/3M7OmZ2Bhq+yYZCJVSwofM8WN9wTzh8AAEOcbOsfcFv2AZxNYndLpGnDC1QMJSGU4sh/jKYurojL7ZjVkuAzVDNTtGgQ0RusQRAtzixzsj2ah5t5Uca6Gb/UbwyC3QMmpj96k0t+Rdj92q
 woCTcDoc
 mwzxo+EzAnaJ1ttfaw/a8yJPwrzAUM1PZmCxKjmbMF+RQoM/81+tDh/97vStrIo0/qrmO9lrnlmd9GKi0xkxlhyQ6EzHJZgq59eRTWqIM/CwuIWo8V5XICJYaZOl1N4MkvLzy0bKbUUkUKHlw8E7Dh0E80k5TfZW5DOykJewCDgeY7z12gjEKZZmWLx1ioNeP/gVpJ6iAws2EEy6dUjJqRFmlNMTH2kSF2nkp2+HrDZsTBSn7SmzIjjZNgg0egkfIO4lABX/l6tNWXTOZd32ftzJY9UeXoD8fRaoVhKhR1XCdWEqTY5SzdYxDOip0sISx9QvxgsrGa1wtNmb9kMVjbVU9g3JYcscU6EgjsGHYG/TEcmnttQWEHYm3Z6NhZ94ndn8F+KW8XcbXmZDmryCvVFwLF1tYThivhYcCtH86LljcdX9rcdnWCmnp6XoHnpk0kZ53Ddm31SUulCt15E4nGSQFcxcLDy3RZBKtUxTBbJli8jWG2RtXLtPh7ZSHCpwrpW3OUr3TTnEkUSB2tJJ1DmR+0B1AXvpUro4guVNeR4iRhQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The size of a pcpu allocation can be interpreted in two ways:
1. The size of the allocation attributable to a single CPU.
2. The total size of the allocation across all CPUs, including the
   allocation overhead (for obj_cgroup membership).

In most accounting paths for percpu memory, we need the second
definition (full size). Make this more obvious by coalescing the
callers of pcpu_obj_full_size() and renaming the parameter to full_size
to distinguish between the two definitions above.

No functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
v1 --> v2
- Renamed the function parameter from size to full_size where
  appropriate now that pcpu_obj_full_size(size) is passed in, as
  suggested by Harry Yoo.
- Wordsmithing.

 mm/percpu.c | 63 +++++++++++++++++++++++++++++------------------------
 1 file changed, 34 insertions(+), 29 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index d7883507dc151..b22a16980f646 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1611,7 +1611,7 @@ static struct pcpu_chunk *pcpu_chunk_addr_search(void *addr)
 }
 
 #ifdef CONFIG_MEMCG
-static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
+static bool pcpu_memcg_pre_alloc_hook(size_t full_size, gfp_t gfp,
 				      struct obj_cgroup **objcgp)
 {
 	struct obj_cgroup *objcg;
@@ -1623,7 +1623,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 	if (!objcg || obj_cgroup_is_root(objcg))
 		return true;
 
-	if (obj_cgroup_charge(objcg, gfp, pcpu_obj_full_size(size)))
+	if (obj_cgroup_charge(objcg, gfp, full_size))
 		return false;
 
 	*objcgp = objcg;
@@ -1632,7 +1632,7 @@ static bool pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp,
 
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
-				       size_t size)
+				       size_t full_size)
 {
 	if (!objcg)
 		return;
@@ -1643,14 +1643,15 @@ static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 
 		rcu_read_lock();
 		mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-				pcpu_obj_full_size(size));
+				full_size);
 		rcu_read_unlock();
 	} else {
-		obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+		obj_cgroup_uncharge(objcg, full_size);
 	}
 }
 
-static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off,
+				 size_t full_size)
 {
 	struct obj_cgroup *objcg;
 
@@ -1662,57 +1663,59 @@ static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 		return;
 	chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].cgroup = NULL;
 
-	obj_cgroup_uncharge(objcg, pcpu_obj_full_size(size));
+	obj_cgroup_uncharge(objcg, full_size);
 
 	rcu_read_lock();
-	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B,
-			-pcpu_obj_full_size(size));
+	mod_memcg_state(obj_cgroup_memcg(objcg), MEMCG_PERCPU_B, -full_size);
 	rcu_read_unlock();
 
 	obj_cgroup_put(objcg);
 }
 
 #else /* CONFIG_MEMCG */
-static bool
-pcpu_memcg_pre_alloc_hook(size_t size, gfp_t gfp, struct obj_cgroup **objcgp)
+static bool pcpu_memcg_pre_alloc_hook(size_t full_size, gfp_t gfp,
+				      struct obj_cgroup **objcgp)
 {
 	return true;
 }
 
 static void pcpu_memcg_post_alloc_hook(struct obj_cgroup *objcg,
 				       struct pcpu_chunk *chunk, int off,
-				       size_t size)
+				       size_t full_size)
 {
 }
 
-static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_memcg_free_hook(struct pcpu_chunk *chunk, int off,
+				 size_t full_size)
 {
 }
 #endif /* CONFIG_MEMCG */
 
 #ifdef CONFIG_MEM_ALLOC_PROFILING
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
-				      size_t size)
+				      size_t full_size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, pcpu_obj_full_size(size));
+			      current->alloc_tag, full_size);
 	}
 }
 
-static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off,
+				     size_t full_size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
 		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      pcpu_obj_full_size(size));
+			      full_size);
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
-				      size_t size)
+				      size_t full_size)
 {
 }
 
-static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
+static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off,
+				     size_t full_size)
 {
 }
 #endif
@@ -1744,7 +1747,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	int slot, off, cpu, ret;
 	unsigned long flags;
 	void __percpu *ptr;
-	size_t bits, bit_align;
+	size_t bits, bit_align, full_size;
 
 	gfp = current_gfp_context(gfp);
 	/*
@@ -1773,6 +1776,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	size = ALIGN(size, PCPU_MIN_ALLOC_SIZE);
 	bits = size >> PCPU_MIN_ALLOC_SHIFT;
 	bit_align = align >> PCPU_MIN_ALLOC_SHIFT;
+	full_size = pcpu_obj_full_size(size);
 
 	if (unlikely(!size || size > PCPU_MIN_UNIT_SIZE || align > PAGE_SIZE ||
 		     !is_power_of_2(align))) {
@@ -1781,7 +1785,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		return NULL;
 	}
 
-	if (unlikely(!pcpu_memcg_pre_alloc_hook(size, gfp, &objcg)))
+	if (unlikely(!pcpu_memcg_pre_alloc_hook(full_size, gfp, &objcg)))
 		return NULL;
 
 	if (!is_atomic) {
@@ -1793,7 +1797,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		if (gfp & __GFP_NOFAIL) {
 			mutex_lock(&pcpu_alloc_mutex);
 		} else if (mutex_lock_killable(&pcpu_alloc_mutex)) {
-			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+			pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 			return NULL;
 		}
 	}
@@ -1903,12 +1907,11 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 	kmemleak_alloc_percpu(ptr, size, gfp);
 
 	trace_percpu_alloc_percpu(_RET_IP_, reserved, is_atomic, size, align,
-				  chunk->base_addr, off, ptr,
-				  pcpu_obj_full_size(size), gfp);
+				  chunk->base_addr, off, ptr, full_size, gfp);
 
-	pcpu_memcg_post_alloc_hook(objcg, chunk, off, size);
+	pcpu_memcg_post_alloc_hook(objcg, chunk, off, full_size);
 
-	pcpu_alloc_tag_alloc_hook(chunk, off, size);
+	pcpu_alloc_tag_alloc_hook(chunk, off, full_size);
 
 	return ptr;
 
@@ -1938,7 +1941,7 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		mutex_unlock(&pcpu_alloc_mutex);
 	}
 
-	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, size);
+	pcpu_memcg_post_alloc_hook(objcg, NULL, 0, full_size);
 
 	return NULL;
 }
@@ -2242,6 +2245,7 @@ void free_percpu(void __percpu *ptr)
 	struct pcpu_chunk *chunk;
 	unsigned long flags;
 	int size, off;
+	size_t full_size;
 	bool need_balance = false;
 
 	if (!ptr)
@@ -2262,10 +2266,11 @@ void free_percpu(void __percpu *ptr)
 		WARN_ON_ONCE(1);
 		return;
 	}
+	full_size = pcpu_obj_full_size(size);
 
-	pcpu_alloc_tag_free_hook(chunk, off, size);
+	pcpu_alloc_tag_free_hook(chunk, off, full_size);
 
-	pcpu_memcg_free_hook(chunk, off, size);
+	pcpu_memcg_free_hook(chunk, off, full_size);
 
 	/*
 	 * If there are more than one fully free chunks, wake up grim reaper.
-- 
2.53.0-Meta


