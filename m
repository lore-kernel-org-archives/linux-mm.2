Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4D9F459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:44:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114F76B008A; Fri, 10 Apr 2026 13:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0774C6B0092; Fri, 10 Apr 2026 13:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6BD6B0093; Fri, 10 Apr 2026 13:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E2B8B6B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:44:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8C3013B0AD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:27 +0000 (UTC)
X-FDA: 84643370574.07.A313C3F
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf26.hostedemail.com (Postfix) with ESMTP id E48EF140008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:44:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iP9YB975;
	spf=pass (imf26.hostedemail.com: domain of 3-DbZaQsKCCEGLLKTLKH7KDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--joonwonkang.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3-DbZaQsKCCEGLLKTLKH7KDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775843065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7Ka07oUOZomwbpEjcVO6ENMHmqIY1HgspyQLxIrvAo=;
	b=jD0bL+s9eba56DyPwjkq26DWJo0qaMXd9tHxON3VvKaZD2PGDlcpSsMHn5+4u4J5DMn7g4
	ST6GOnJ9h3yZoOaOXiJSiD5kMRB4VEW1QW1HMKGYfsDMPxM5Lt35vmsKzCBWPilQ1EyVeR
	sZvh0OFI76S/8Nb24rhBYwfQNZsKiZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775843066; a=rsa-sha256;
	cv=none;
	b=JqchDIZwKdFlaVs828wxlki3xWbTAtCyqzWA3KpaWZx40Yot6I8QqqSCf+kRyKE4aIA4eM
	6q+u9iOoNkBwxSdDE5ea4Uvh/N8HPbijoRyCifASYbI3rTJBlOdiRI6BrzE21TiD/l+8R5
	RqvmWyPUOx+i0+oVyVdhAIK3gndt9Sc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iP9YB975;
	spf=pass (imf26.hostedemail.com: domain of 3-DbZaQsKCCEGLLKTLKH7KDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--joonwonkang.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3-DbZaQsKCCEGLLKTLKH7KDDLLDIB.9LJIFKRU-JJHS79H.LOD@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c83bd48afso1257787b3a.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775843065; x=1776447865; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W7Ka07oUOZomwbpEjcVO6ENMHmqIY1HgspyQLxIrvAo=;
        b=iP9YB975k22rFUJJigRsjpnnCIq54QRwKYminV4VMJ2tMmTJkhZZUISRtXngBZRYoF
         FD49m05rAXqARkfXD20WBXwCuE7dPUXXDyW5Q9be60vegmvoW2zJNpEx+vwrW3JhuOcU
         2hk0djZFZukwMPp5JyFMLgqVejeMIDqnAaEjt3MvVEsJSh49Xax+1efG0QUoL0AEhK64
         NB5YKwFS+Xt/WjGgI/LPS3vyv+UXMuGfXc4aQSqNv5GscR6AjveFC7bpOwOaLRXBDOLV
         hMj07fPk3PRmtvKCPG06ZQlHA0zycwVCOXcgY2R2iEbmtPzBYpFMldgekP3JQLSSlGA0
         smWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775843065; x=1776447865;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W7Ka07oUOZomwbpEjcVO6ENMHmqIY1HgspyQLxIrvAo=;
        b=NKXB5DMamEAGZYWI92a2JOzxYw1xsxTdblmDbQTsiFs9bk5x0X260twNzYHLFYa8J3
         dpISmwSXoSMha+QXW0Oj7Egyp7lz26tUTm31FHhgLI7DVY7Xly2UO9eBoTezEk1NT9m3
         D+JLPFFmkyB5uaXj/YJ4ACeWPO35LILMkvfCAb0h2nD60mE0dJG6/qfD/nRMvwnfRrX2
         PxzzwHsdK/D8QOXUh8EVlYnpWcnLemvY0syoyj7aqXrHvkAIZyC/zXDoCfFhOHw3NNNl
         2ly8hvgoNJFUjvTSFvjxYcXptNxOS+SfHhPi3ttKMZQyRnHAWU7SNAAGkdJnvC2xzR+0
         17zw==
X-Forwarded-Encrypted: i=1; AJvYcCXwKdivPPHppJmpiLNsF1rnFFpmJdhOn2CglKraorTlR93BVgaPBaQWvhwh47wPKBCaKUBLC4dQDA==@kvack.org
X-Gm-Message-State: AOJu0YyZX/1/1XrNQe5w29HBeJaQfkjNwsBbXigXlI+xXQg/4LIoUqtM
	Q9bbiqz8ayP74k4Z8e7D+b2Gn5t07pcGoivWpKV2c5qluWLf1SiwNf97Wyqe1U8426JjVKlW7f7
	tyi2+Qz7oEgJ9AfGt9HAxv+qFCg==
X-Received: from pfqn30.prod.google.com ([2002:aa7:985e:0:b0:829:700a:a1d2])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2791:b0:82c:f035:6748 with SMTP id d2e1a72fcca58-82f0c253756mr4814567b3a.42.1775843064389;
 Fri, 10 Apr 2026 10:44:24 -0700 (PDT)
Date: Fri, 10 Apr 2026 17:44:16 +0000
In-Reply-To: <20260410174417.1450834-1-joonwonkang@google.com>
Mime-Version: 1.0
References: <20260410174417.1450834-1-joonwonkang@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410174417.1450834-2-joonwonkang@google.com>
Subject: [PATCH v3 2/3] percpu: Do not trust hint starts when they are not set
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, 
	Joonwon Kang <joonwonkang@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E48EF140008
X-Stat-Signature: hrnba383i855rg48ftqrcb7hsdwtt79j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775843065-707363
X-HE-Meta: U2FsdGVkX19cOhgpmzv9LMwfgjatwoi4R4uwocxfRzIhU4GK5ZyjsUMzwD1zpcAMtqNhYDHt29qR1+OEMDyIE/6xX7Fx0HvI5+7eBQmWjMTxQBgwvJzzgVGmip7r+2+CCS6xvnN0AahYlPnYOgil+B0tNJr5pkDd3zj8lDJsOi2Rg86zcjujScEY04EJKOndykN8XRtZvh5hJvfDjY2mwIcAue4lrpOAqRR5MHpXxgxV67vo0QAe8Yiyw0uMOOYJqd2RlwziVhdP9AeqJe0lxJ1A4Fc3VYJeWAjB5+oir15UEP79YPyhI43nltQk18CSTKyJ+/6lghUtflqnKfTUa9uepXgypc2BnZaeMKLD4raNy8BS1mKxAcMF4gb8HLXYKCpekEAGVQPA0ELIGO6ywDsjvU4Hi/wjxpXF962K8JE7Z+s9gdWkDhoeu8jjP0N4B+iNki93j7D3FiJC1iRt5gszE06fOGzFR0eNLb+fQ4jDoebZ5AvgR9SDUrBSrnwHvDs0/eaAUK4bJd3OwiDi4RyupejS4Yc5FdeKcirGw4gKynvj0ay5uH+EXbBOOaAl1LFaAKJrjOaIrrRAFlV0bfdjskkxzsJWEDo1Y2ay2POLq99+iPJCkMuhQKiv+2Z8hyAItwEGXNEyibu2QodMgQ68FBybZB6sggKpj9gGXhda4PHwOeTs1Tfz4yed6SNL93I0+qvkgbHjr7OsKuQnWrJUmDSKpKvm+0nrjQtlzxY4a32j4Pt/5Ie1cTMT2BZBKXzlo7lGl/VSpA7jhigmoVO2t/yZ4NRiCRqBETHX4HpnzgflGmckejeYW1RpCmEBjz9xnLZH9npxoZzLUo2bgXdGfDE42W0QtRHbGVfRsnvE1i/Vgp9vA9yjn7aBomREG2YERmJ4Sn4Ct4kpm1sYof/HTGFD2toIUK9nAPN8PoYGX6XnT9hYXmlzo9n3eoXaDUICHPDtLVppu5pe5DB
 enAy38UV
 S/1nZaBTQINTCHmzsL9J/ryQ54WY99f95pylfk33fgWCPlLeI2Q1EQPHlv7A2+tgIWcvkd953F8tA8CqlWoRczAjuNKT8td/ee2LXhytRaGw9Uqg8dxB6umqvnbcGN7nG7Ob2nHxpMES2Ygi8jCOAlwTeec5QNncFrUgYSf3Y4eCgJ/K701VGdrOgm9M4P+Z4JhRpQYFLEirRYGOq+tHmZsi2bSOLzDBX4Cb5uoLj7Pil7G+8fozfBP8Tppb7bYQ5n+cvP/gtY29l+npA64Rf4aGzyr6gPtKH9tU7dMi3TF2AAJDiLJs5JjFgUpMsbn+qPJifgoi9lgWRZpYHrFSEwi+dioSVbMwNzYKvNsE/8rtz11mday0rQWzNx9PMp6vbcNmiyyWH8Ry2IBFNnr65gCoH9I2x0TOZgh8dURNaLJoJJLAb1sVjhMT08xKPGnKqtW31a25vEmXilMlGIcuWnhEn/Tsff/F/NqeOHHrLmSd4ultj3wHpuvThDd5MhN2Y2f2HugTcVVWy3Nd60nDvIFEY+XmM4jN1gOX1qqTukvmXIfEK9yn4mujaWSoFindCThciwmh4SkWYtnqScJTht21k/bJrDZCq55NMpurt3WI3hppsGWo799gAc710H0dLOH5HOzfQxy6eEuURl6JU5PbswBQ5AqiXtjm3xf3y5i8fw6gfVQbpLJrZLhIxdZwD/8HU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

contig_hint_start can be trusted outside the hint update function since
it will be updated everytime contig_hint is broken. On the other hand,
scan_hint_start might still be invalid anywhere in the code due to the
broken scan_hint not being updated promptly. If those starts are trusted
when they are not set, it could lead to false invalidation or update of
the hints.

Signed-off-by: Joonwon Kang <joonwonkang@google.com>
---
v3: Initial version.

 mm/percpu.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3ecd86096641..f16533ed4a49 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -638,6 +638,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
 	if (end == block->nr_bits)
 		block->right_free = contig;
 
+	if (block->contig_hint == 0) {
+		block->contig_hint = contig;
+		block->contig_hint_start = start;
+		block->scan_hint = 0;
+		return;
+	}
+
 	if (contig > block->contig_hint) {
 		/* promote the old contig_hint to be the new scan_hint */
 		if (start > block->contig_hint_start) {
@@ -845,7 +852,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 					PCPU_BITMAP_BLOCK_BITS,
 					s_off + bits);
 
-	if (pcpu_region_overlap(s_block->scan_hint_start,
+	if (s_block->scan_hint &&
+	    pcpu_region_overlap(s_block->scan_hint_start,
 				s_block->scan_hint_start + s_block->scan_hint,
 				s_off,
 				s_off + bits))
@@ -889,7 +897,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 			/* reset the block */
 			e_block++;
 		} else {
-			if (e_off > e_block->scan_hint_start)
+			if (e_block->scan_hint && e_off > e_block->scan_hint_start)
 				e_block->scan_hint = 0;
 
 			e_block->left_free = 0;
@@ -922,7 +930,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
 	if (nr_empty_pages)
 		pcpu_update_empty_pages(chunk, -nr_empty_pages);
 
-	if (pcpu_region_overlap(chunk_md->scan_hint_start,
+	if (chunk_md->scan_hint &&
+	    pcpu_region_overlap(chunk_md->scan_hint_start,
 				chunk_md->scan_hint_start +
 				chunk_md->scan_hint,
 				bit_off,
-- 
2.53.0.1213.gd9a14994de-goog


