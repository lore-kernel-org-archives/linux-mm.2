Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F506CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 01:46:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657428E000A; Mon, 15 Sep 2025 21:46:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607D58E0001; Mon, 15 Sep 2025 21:46:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6AB8E000A; Mon, 15 Sep 2025 21:46:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBEE8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:46:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB982BB459
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:46:14 +0000 (UTC)
X-FDA: 83893423068.08.CA5B9E4
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0FC4420008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:46:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QI3/qn7Y";
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757987173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UPA1toQr5uAUN1v43j1zuAajDVGqxLAPWCvchR38lKM=;
	b=HRUqldQEVaz1STs4EHa0HFUsjzRrRVDO0sjJk10F8jvQihrKfDdjZfVUXKxJj3FBiSRLfm
	m6IoIfgM3CxVHzcZPuPspVNleKVVpWaemvXFmcDRHdRmT4cKZmOpUxyGV29fj3ZC1mJgZG
	XADTB2plgq2rDJ3TnDJnvWuM4ujKjX4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757987173; a=rsa-sha256;
	cv=none;
	b=or7taUQ564XXA5EAzga0ZyvlCwQGAe3HZrqE7bI6r8erD5Mfbk6WQdg0r+WR1SsqwJzxe/
	Ai9cra/Wl/KKi3L2Jd5nNXtAfcthVFaA+UP3kU8pZ5VDJXkmjbW684vFeppVZG8jWWqo4p
	Ztk9HCFMoC9LUdNCHiyiX79LR2t/4wY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="QI3/qn7Y";
	spf=pass (imf03.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-77264a94031so3530066b3a.2
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757987172; x=1758591972; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UPA1toQr5uAUN1v43j1zuAajDVGqxLAPWCvchR38lKM=;
        b=QI3/qn7YjVZ1ab9OPU8wVeLzBRrKyyGPT5+DNwrgoR21npMv6SR1b6FeMUyPAXrs1c
         5hNEkuFUwK5U++EJEEoWfViUoEUu180pUy+EFyuRovQ+dpyOHNPdGwOLtV3u4TAdJnqP
         XV1Hg6C4nw694plH5bELNZa/u8r9lxhJr6pu61IfBfmvYFXG+m0swO9vC3BLbhjIaShQ
         aRH9LtsUGQ1myiHOuVA0hqjM/XyzRAro4rlKkB7tLBKikxIs7isEcg/9TQytRv2+7ONs
         lb5PmSFbPkcQmhF7yl7KHZ4v5gnZJDaDuAcv0A+JNHk74pLeTjM39TblIvh3YIjGoKcC
         yv4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757987172; x=1758591972;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UPA1toQr5uAUN1v43j1zuAajDVGqxLAPWCvchR38lKM=;
        b=rPFwV4ruWOjo6N0DnvFya0yFqjRfezDBLEYiVejj2OawMunePj7hoFvqxnuii5RoRT
         yaSeTKX2M2WmKjaNy6V59bC/K8xhAyZ81LnsHjQTts1hLFhPgDQEa9zA7AmBqjbtfpDw
         Mq1uhpUFF4CsTz9azFGfQkw3I3NsSFO6/O0k6WD4LGNKZfojWkb45EAzrrZI+Jq256i7
         3x3v6ObfUyl0ADXl4GPw6tTQCt/rL6RaOCpZqDqNlB+0bH6fsErcPYQbniyZj9Ae5kSo
         /k5WDeaXftMXOXdq7oZmCGH+LNE0GjAc2LmrHtVJ2pIT2CjZJXgtErF/jmATvsvof3Rj
         fSJw==
X-Forwarded-Encrypted: i=1; AJvYcCUsrGs1O4xdu9mTDRlSStJAx9yCVljhXsIz7gNtyU24+GsT5CL9F5byEEzkv5p4YRV63rHil9s/Xw==@kvack.org
X-Gm-Message-State: AOJu0YxKRM+6lxWpuTs36jzHqV4PZPv11AO5mW71+k5DL4YjDv67WQjG
	TX8aXmTlhmGSBqMvY+yn5ZGKhm24GQ422hP85eoRrmZouEI8ANDXDcxq
X-Gm-Gg: ASbGncvcjDkxv4H98c2mHUrsrYsmO5z/4sWZnOKIIHycDMoKFvEMgAG2PxEkU0fnIWY
	7kGZrm3S4/QkvD7plB6N5edFvWCWII5kLJjYgzHSVwNJt6MlQH0kY/U3YAIIC88MfkWvdEWdOnP
	wVeKtKcF1nm1nLQEMwGV0Ue5fU1GjlbUpYTIByltp7LFUtZVhDuA/NNuZeQNqeQr2D/BahlW0ws
	l3nP6gcOHzscfKsabVkvr1dv9dpN7Z/IQ9P5XXLRD51HCjVYi+/cSKbZbwqEWNUl/aumgzAwj83
	2qUKHdsU54vWHwTHYZt2Ql1wJL6tAJa68JbL1Cs0KLpAjG73FBtg4AVv4nnBcackrASBaX3v4ox
	T0zlsGXcIG29AGpLTnhwHEDlRgIIITgFmgyVVgt2+oEy/qWaGdossUBRA3NhoYIA=
X-Google-Smtp-Source: AGHT+IER7qsmDirvUDqEQs1xBs7R9YKNdkm4YW+QWuf/8YIZY7n0KTnKwU0FcGZ00OJo4PN1/sUNaQ==
X-Received: by 2002:a05:6a20:2583:b0:24d:56d5:369e with SMTP id adf61e73a8af0-2602a593376mr19411514637.3.1757987171893;
        Mon, 15 Sep 2025 18:46:11 -0700 (PDT)
Received: from localhost.localdomain ([2001:558:600a:7:44e6:767e:cc5a:a060])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a36c78b5sm13253263a12.21.2025.09.15.18.46.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 15 Sep 2025 18:46:11 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org,
	linux-mm@kvack.org
Cc: vbabka@suse.cz,
	harry.yoo@oracle.com,
	shakeel.butt@linux.dev,
	mhocko@suse.com,
	bigeasy@linutronix.de,
	andrii@kernel.org,
	memxor@gmail.com,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	rostedt@goodmis.org,
	hannes@cmpxchg.org
Subject: [PATCH slab] slab: Clarify comments regarding pfmemalloc and NUMA preferences
Date: Mon, 15 Sep 2025 18:46:09 -0700
Message-Id: <20250916014609.47273-1-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0FC4420008
X-Stat-Signature: onm5tue1ec6pdgcyy4jgifh1kuwjw3hi
X-Rspam-User: 
X-HE-Tag: 1757987172-543770
X-HE-Meta: U2FsdGVkX1/6fFi17Iw+Evxkoy/nL+rWx+URbw/fw1q6NX4kpkQUAmB9o7hZ2V6R65ILA1VroUkji2HJcvrebfxBf+m0Zn9KOOxGWqYkjCSGbMZ1Vlw9cgaVKakHjbz8PR8ZWcSO+5iPZA2KOEtHQ677SRq0ozTJHlPVPVotIOjuXdx73K1Me/EohcTEjPBbDCoCaOyW4UrBQq9ib4UTbMN43zBYsvK7OoK5FHVno1famdYC0lMHAZPHRXdhb+XCDZ/nP78ch8KKC7uDYK1DvNscmdtqzuUqw82g/8TnIjjc2LNwliF+EFusmcYn+lpP8a7V4F2BzkWJW2rV8rjJXTV5N5+6pc3CTszRFROqpqkcIsPsQQBrhpskSyGPxogADpyuJtKLXyy4TX5nA67pVDJSKCj8HPZDx7u0PBQmjkRox9C46TojncmloOz/rlgxk/SExKo8NTEZRQ9tquXcQy+DBhGbZcOIaodFYJGUhSLuIocbZ1uMMAbXsvnsG7utbDtRV/PX+HhmXAQY94ZY+WbkwKHs0x5d9vXfYW6kG5S2LMSChAL9LLjuFyo7pRSO/s2cfcTG/JTu4oR0kouLahfhnqGoNVK6GTM+leqE/7Ww0Mx85rEkAjaWIsrXmPENXlHj00rtFO7+TUYi5SxqT+ayTDyRITfPoPUjpCPRQqaEcbeUlFi+XXkp/jyYWK8DGKUExs8GfNH7gbjnKLW7X1F5BtBpCDcrIEFsFKkKNyRCb37yD7yls+SiMjbhAZmpyk2W+M1coRCiCHgeG0ZVDPF+wapy2SU0IC033JpkuJSKBP/sNbc4+5iQ2FLGRZiY94YH71chmkN2mG5BRtXYez3lz4kSTRLBHZR95ub8mgmntIGmW1aW+T8o8y/Q37C0DHx+ZN44KryQa+9Np0ocXKCdeeKzk3jplE97WA7mnLaDsimLleAGQ0fJfYMKTW3OixN6pUp+1pkDgtvYesa
 3wB8OvsC
 i8KfPAGXzjWxQs9vpE1uPw0/hvYjfcv/8q0oS/xTV6nO5hboUtUtBTYjDKNw6fXkjVqEMqlwpYcdtVINNwhUil8x313/tufYSFZJvznDqrzgxda9aE4d0UmKalAqjCjJ+f6xoIA1fVreGhbIi2bpL50baOTel4mvnCUBnhtTjHAQHrsyvI/VeDmhPFvam4l2ZEjnQMy5rxLq2XVKh4+rWYbGsMEVcDlNeFpgYI9Mg7p2Rfpteu04DcpAdD91+PfOcVh7xSocVRlThxqAEXFdvYCHk3dFsPDnxLTGhAULKaEw9T9NQKRW5cOXnguMj7/Lprgh9P6d0d9e8IXRCZpRXrkTPgE3f3C5qlA+tYmCT7IgfDDs2JJ19fudss0mrAflUBDI53R/1MEv2Owa0kwXearqRztwKfM1p7Dmp6p+/JPf2t2USic9rL1bWkyAq9qQ42XPfERBgDrp4NzppnNkMJUvSUbS13vqrTF506ksIfy5nkkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexei Starovoitov <ast@kernel.org>

Clarify comments regarding pfmemalloc and NUMA preferences
when ___slab_alloc() operating in !allow_spin mode.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 mm/slub.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 83983de948f3..c995f3bec69d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4456,9 +4456,17 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		/*
 		 * same as above but node_match() being false already
 		 * implies node != NUMA_NO_NODE.
-		 * Reentrant slub cannot take locks necessary to
-		 * deactivate_slab, hence ignore node preference.
-		 * kmalloc_nolock() doesn't allow __GFP_THISNODE.
+		 *
+		 * We don't strictly honor pfmemalloc and NUMA preferences
+		 * when !allow_spin because:
+		 *
+		 * 1. Most kmalloc() users allocate objects on the local node,
+		 *    so kmalloc_nolock() tries not to interfere with them by
+		 *    deactivating the cpu slab.
+		 *
+		 * 2. Deactivating due to NUMA or pfmemalloc mismatch may cause
+		 *    unnecessary slab allocations even when n->partial list
+		 *    is not empty.
 		 */
 		if (!node_isset(node, slab_nodes) ||
 		    !allow_spin) {
@@ -4547,11 +4555,6 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 		slab = slub_percpu_partial(c);
 		slub_set_percpu_partial(c, slab);
 
-		/*
-		 * Reentrant slub cannot take locks necessary for
-		 * __put_partials(), hence ignore node preference.
-		 * kmalloc_nolock() doesn't allow __GFP_THISNODE.
-		 */
 		if (likely(node_match(slab, node) &&
 			   pfmemalloc_match(slab, gfpflags)) ||
 		    !allow_spin) {
-- 
2.47.3


