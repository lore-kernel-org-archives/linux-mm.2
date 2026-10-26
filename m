Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC16D606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=E3iBpB3+
Received: by kanga.kvack.org (Postfix)
	id F28FD6B05B0; Mon, 26 Oct 2026 06:25:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDA196B05B1; Mon, 26 Oct 2026 06:25:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF00C6B05B2; Mon, 26 Oct 2026 06:25:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BE5776B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 06:25:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EAA6A0741
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:25:09 +0000 (UTC)
X-FDA: 85364394738.04.1ACF1C6
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id A9984C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 10:25:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3iBpB3+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793010307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vC3+m1bXV4BFKZGwxaXpJ49T5jUkMEzs9Tuz0+gllWI=;
	b=Ea1OSxUU3hP6919pLklow61Wk3TtQq7xMPtkHkXCFdwZyxVcb/TkSAdYMdNxYCLraQ99o8
	7ylEMnQbY0ip7DhIiu0duDzye7KR7yqZWp7K8yxJhHhhDziRBQyPcFn9yENwGece+68Xsw
	+0RcSv59FgB7BWPsMa+Z/qTUeg41xWk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E3iBpB3+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793010307;
	b=uqLJlga1jbCvlWB1vLfL1eIF4JNVowD4dtfN8UxqYcW78v1YMAOOxLq2vl49Y8oMdmIgFa
	I79MG6VxVvw56tmTq+7seZzdfloIuCDcyVS0Nf974pcQSKaLDvGJkKzNLiVHZ4eCcOZqqE
	EfNeWFzFltg9Je5ErfJYzXwGQW0xQ38=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so3254216a12.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793010306; x=1793615106; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=vC3+m1bXV4BFKZGwxaXpJ49T5jUkMEzs9Tuz0+gllWI=;
        b=E3iBpB3+CvIjcuovx6M6yEun/0In6QSSmpbFE/qB1amK+byF7eH8D7DkxU/x+DlqOF
         hky33wC18sAZ0ZFQcmucZd74HrSnp3oyKNx/ra6kimeOYFV4AfUPQrBdFon9sT6YVauJ
         nYxd2wpovZ83v08S6ZEq7J53xGlxvW4/fDajhoR4OBAE/Hipl08P/GMs89ZNXPN3QUUa
         jTFJ2FDwzCncsSGA0mPR8Zqqys96ucTmm7Sh+mtNQkCJpxQqOl9pGPYR2Xgk0y+yzP9F
         W96/3IneKFSjkdSX7ZubaiLKQD6FnGHqKbkhwjK9G7pceUBTBJWKnRTcBDN1DyziioTo
         F8YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793010306; x=1793615106;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vC3+m1bXV4BFKZGwxaXpJ49T5jUkMEzs9Tuz0+gllWI=;
        b=nXC+efiZTJrXeyOUtxq4MnHhgtcbWR6KMncPQuEL91nZmMTSWmEuY9KpGyS1sVb2AX
         WuRXHB5QukZlFG7Ourp0TuVX5G7jp49v0s7USg4vU0WG7y84w52SPpFj4lFl/v+JD82e
         qAlPYBWMOq/TDDPzFDPfvmeU/XilAxyBiq6fb/G10MmUEnMlybLT3rlw/v6OfuOpOokg
         yC8I/rtj0ba/0EQymGAChE11GbrmcFlj4CiJc5/uFiaKJS6MMlfe821PDa0KbELV0ZtZ
         Tq6+sDjNRJjPk2iYZtVHUjDSfFXvi4EvpFXZ4TkeyHFO7V0onmX51JI/N6Z7I434pDTT
         br5g==
X-Gm-Message-State: AFq9FYLPlML89Nzz6nvYcWUnc9RIO5Lo7iauxEMDNgCXy4HvCdC4UvSx
	f8rCnu2dJj/ZJcwt5c8QfoktoWXRLezshxQY0/gvYs4yEA1CmCzZsXkykSQ2VsSx
X-Gm-Gg: AYBFou3D9DnrNY+WZ+CMCJ93zxvxPWOlXMzluxp43DlCzEkGwMe+LvBVUXL4KbZNkHx
	BYoUqFd6g0Jn312ewNTsFEy4p6YTCVI325z0R1959UulzRJy7vmaRix+H9pUJOIi9oXG13ZRK9k
	zvBfkFQFZ1q/F4QuZpDXsERakkk8IYfFgX+aty2hifaWglwtqbF9M0ye4V68PImUB0t+FlVKB/+
	/nq5GGpW/sE9MF9ILIUZ+uJTtoBRkDGfgp5FeWAeFkxOLJFOyoxwpET8pKCrwYEMiCqKTyX6GwA
	ouTgHRx1hIzFCJe3kj/iIsQP7/yqcv0tDB3SbBxR8nRk9BCz3C9oeds3P3DvbLj3R3c7loIs5aJ
	EbwDXGdWlnGLUOFAq1CY0EEdEfJ1eJE+sdNkuTPuqJ2ISUznSMUEGX9GhtC3+esry3L0NLPGBer
	t4hwkRQ0RSji+s+W1ElCRWkVAz8Smu9N7nDr9WArOREwqLpSaCjSgLPT+oCmtFRBvwVLh3GcECC
	CSEVZi/733DZjc96LBrFRl7bNGn1ZtLy2ZbCgkz7rhUZCE=
X-Received: by 2002:a17:906:3a88:b0:c49:901c:d9f with SMTP id a640c23a62f3a-c49901c2556mr174648266b.49.1793010305891;
        Mon, 26 Oct 2026 03:25:05 -0700 (PDT)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd52435asm298667066b.36.2026.10.26.03.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 03:25:05 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH] mm/vmalloc: Bail out if in softirq context
Date: Mon, 26 Oct 2026 11:25:03 +0100
Message-ID: <20261026102503.30860-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A9984C0002
X-Stat-Signature: rz9eigtox19f16m8rsxgsiouysoaod4i
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793010307-633805
X-HE-Meta: U2FsdGVkX18ZtDCooHANFn4Q2t2XHyrbSeYJmR9chhhNAQvt90nstTh4YhMXYNk7eS+tE8WB22KIkljjVnm11QihoIq4mQemYIDVBIRPzSSOK3JE323QNAU1wgzxTXerRStjOXAXtwdi92wWZ6g2yl7nPZ8ZI1zONEDvD6o23gg48YcpgSgXHbs0oWUlaxJEo8OTtAVRrD2/YIzn4ueIRa18bnmlssQGXo2HCZAoOSwvMSBZIIoofLNV0FYjB7UmBs8L+QRllsAFgjbpA2YP0qiMBJ0rKa+695tk7rxf809Fet7EC32F7AapBbSgIx882Andwd/trEBndtD5TZnua3d2pAenGKwpI+n+AA5qyxc/e07eDEbYhU8geXVDssGhD4xB40a8S0P6uq4hjtkt6rCN++LAnlcivImEP9cI2fpUgKs2cNPJjHxRl3bDWB5zKG+DEgJLC4jPU5Q3TWqfy8AfPEvic0ulUwLupZ6LDNjXW+dHGWVaw8bFU1pg2t3f6IlPq4BhVpjgf9+ixN4+JpKXGQeBh92jzlUwqvPlch/I1P0quRea88ywWmwaGKqfNzPSzX2ntwcyLF6erCGnXB/JW4J3vPJKFxdHPBf0MaIHg82tnxkME5qooV+v5GJOYaH7IYLmN3ZY71upHp8XokQyRGKwHtt3jN4xD4KWFqL1/lzNu/vZw8hGDWV8pi+n+zcwLAdI93L7clSKk0n0EQeKl7atkpumDmdJjfZhQJwJwu42DSGC/sVEyNYDdYG9A0KcRM9m3x0OqdltJneWOFE05zlc0ZurIWCf/8gcsd8M4JbubKNA/xS2FmeTj2m/ob9tuYyP44oZ6IE6o0Xrx8bYCVRdqweOI1B5N4B2XeGIn2H8LxsPDpjt1IfLzBn3cRQnyMSKP3oS21u+nOg04imAM/R+GQpxkCN9qyC0F72aRO8nfS3pLAOCSkQ8BqXFFxK94B5kUsgVY28L1ZZ
 prnSI7jk
 MK7FpmJtzRqe3jI8JQbFyzd+MZqv4zd6yk5oNHgMkqq7NnjCRvU9SyaqylpsBWn4FvWoXxs7P/Tdu3VMEoG5l0yQeG/QcnEzKG4HdzU2bV+jVl3s9z0gU4Ij94bor6ezApivxnSQQfOcTWQZlivKsB0rBBepbIY1yVVfKdtEzWj1y1TOuy7d+uO5LiHbWfVadi374wL8ruErVx5UtwApCtEj3S+zAnqmLGT/XfY/MI4LVAqGGjk8Nc0RCRDoFYv5L+siv7Ii/pChH2rKxtgT5DGE6dzcmuhWj9mbWzGzGFI2UObXbhp0eENwWmom8i8r6Evei4ae4RSLRfnsdNtB4IfPBDyzf/xzVpCfZ6qK7suoPhJR69DKplYZvnyTWjjQTuYOcuRHmtpKnOus7Nzhz5038YRUu68+b4v2ZMVpzkFkdpgnxIadPGBksugQixv5z3oXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vmalloc() is not allowed to be invoked from the NMI,
hard-irq and softirq contexts because doing so may
deadlock on internal locks.

Commit 04aa71da5f35 ("mm/vmalloc: do not trigger BUG()
on BH disabled context") replaced the deprecated in_interrupt()
macro with explicit in_nmi() and in_hardirq() checks, but
unintentionally dropped the softirq context check.

Example:

<snip>
vzalloc() in a task
 spin_lock(&vn->busy.lock)
  <------ Hard irq
   irq_exit()
    process softirq on the same CPU
     vmalloc()
      spin_lock(&vn->busy.lock)
       spins forever
<snip>

Restore the check by checking the caller's context with
the in_serving_softirq() helper. Note that, it is still
allowed to invoke vmalloc() with disabled bottom halves.

Replace BUG_ON() with WARN_ON_ONCE() for in_nmi() and
in_hardirq() case.

Cc: David Hildenbrand (Arm) <david@kernel.org>
Fixes: 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled context")
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7521b9b3bfd2..36e6e3be6ba4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3252,7 +3252,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
 	struct vm_struct *area;
 	unsigned long requested_size = size;
 
-	BUG_ON(in_nmi() || in_hardirq());
+	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
+	if (in_serving_softirq())
+		return NULL;
+
+	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
+		return NULL;
+
 	size = ALIGN(size, 1ul << shift);
 	if (unlikely(!size))
 		return NULL;
-- 
2.47.3


