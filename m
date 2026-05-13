Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B332CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 006DE6B008C; Wed, 13 May 2026 04:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF9E46B0092; Wed, 13 May 2026 04:51:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E10476B0093; Wed, 13 May 2026 04:51:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D49586B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:51:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F97C8DC53
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:23 +0000 (UTC)
X-FDA: 84761777646.16.DE33D2D
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id C6C4C1C0004
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:51:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="H/HdWazh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3iDsEagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3iDsEagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778662281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kMquGiE7Olhi5zdaQGRvKk6+GrMbjQ9R7siYApby0ZQ=;
	b=S/S3cTSFvwY3SdBOIjaHeo/Fh+Y5gSJ5uPdR8+gN9x4jM3n+yXdzOePqg+CA4yj/8072uh
	GNY1ArpAGcwbGBkk6z+LfHdM/hGYOvv//ItbndFy3KunMQBwx6hElDKfH4O4aZjD+P19eI
	mjJvVky788FHI74ZpGLAgHgtNg9Liu8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778662281; a=rsa-sha256;
	cv=none;
	b=tvxvO4/PciQhmhWUqY+hqB7bsQhkhqu6Ov2ACpjJvopBVFUkV0juHNcTd0h0sDzs8LewXD
	/u+HssQbgUwssopSwEoQGcf6b8UmMuTDFtdkddl6smv5kEd1tKF2zKMP7qLLuIqMuiWbmY
	anOHMjdC8YNKIiky2dg/3mzErkRHSL8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="H/HdWazh";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3iDsEagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3iDsEagsKCGcOTTSbTSPFSLLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--joonwonkang.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2ba224c3ffdso97616505ad.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 01:51:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778662280; x=1779267080; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kMquGiE7Olhi5zdaQGRvKk6+GrMbjQ9R7siYApby0ZQ=;
        b=H/HdWazhicgPG4TEUAtKwHc/Pq3A/En9Q8ssbPCQyq86PWtoE5ZGZWQ08Ah/+RXqBj
         i1kJjhyiW6rh2DUJRmluMud8eqeD/pcZdsROr+GO6sA0QaDFDn390HlX9MNMdukKpwJA
         ythciwtAPm9H5X/JWhCgDlt04S+76RA5HvjUoTgWTt7syjPL/auhe50uwk+HNhntVMs0
         ZAPnQ5wxFQ+bU5/IttAiD1/fLUnXtQ5QLCewH81DSKFjo4uskkF6JL+vcn25jFSsYzXf
         1C93hUXZ6GaMWTaSKFsEzfajfueUPrOVQHuHBs/3Nqy2UaQUcqd+vX9ilM99pJ2klufz
         +1Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778662280; x=1779267080;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kMquGiE7Olhi5zdaQGRvKk6+GrMbjQ9R7siYApby0ZQ=;
        b=drUo8WMfeuPvToxZRQkV8Fn8mAKgMRyh/VN5BHehRbmqGe2O+Ab7cMoZtvTi3EnXBY
         itb+oN/1ylXyldIqStjvXBn1xTsA5GJLi4EDtzrZzdhjPCsyvP4/+uyHkKwYmdPn6Dxm
         2yfdnBEEWEfat+jAPPeg/eYQSl6YMyj219KyZPf1h7IN1FVruIwRFUCkrZoNwIx/eojf
         /Bp5uhl887umFfAVbpkx/HAicm+xZNavTlTJLan+8L2lnXG8GsmQ/ia9Jnr6J1LJv1W1
         a9q9WliOd6RveiaThWo0hSGV78lQ7axiv5j1a+4pqVZRO3yep2LFUY4jfzJn/A+Xw8X1
         PI/w==
X-Forwarded-Encrypted: i=1; AFNElJ/D+cI8rrhMZq/6c8fBKZtetufSvAmVaZHwmAyZwVDU3TNIX1wWv8s3fEnltsQs8OwwEtqO800cgA==@kvack.org
X-Gm-Message-State: AOJu0YyZWCwuXm4HbZYnCPWWISzfS/kv3mVU4rqNfKB29xYqgUch0DSB
	LGufBYL/GKde2MHWY2x0UdAyqOa5Dh8/iF0QBGQtKACjtfIQgyfgZq8sB/RD79Lf/2QzfIn1uD5
	mMLjhBXV2lX9criO0rpCTMndNXA==
X-Received: from pgnd8.prod.google.com ([2002:a63:7348:0:b0:c80:1fe6:ac57])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:748f:b0:3a2:d79c:416d with SMTP id adf61e73a8af0-3af8328bba6mr2763689637.43.1778662280073;
 Wed, 13 May 2026 01:51:20 -0700 (PDT)
Date: Wed, 13 May 2026 08:51:13 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
Message-ID: <20260513085117.1024175-1-joonwonkang@google.com>
Subject: [PATCH v6 1/4] percpu: Fix wrong chunk hints update
From: Joonwon Kang <joonwonkang@google.com>
To: dennis@kernel.org, tj@kernel.org, cl@gentwo.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, dodam@google.com, joonwonkang@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6C4C1C0004
X-Stat-Signature: qy35cpff8m8saikzp7okopz5wqgtkzca
X-Rspam-User: 
X-HE-Tag: 1778662281-548255
X-HE-Meta: U2FsdGVkX1+G055R2ftuBIPiJfDX0RuWIQ8VQLuWEGVmIxpSu/kPc+0rGQqpSFR+EDuoLp3IjIr9GRRMI7+VjnuffFvGv/YBdyf8CCFej4hVcvxe3o6RlZD6pIqxmVoLeu/vc4YxXk23A32ye8aoWnRlKHc59bre0LLY7gRHx/ZnxSdkhHuaWIVTUPs1VMM34I37y9E+PFqxqzdortpYvjyaPJxVOcu3VKfHfP+WXnwwCLVhvtfhBMesrOi1Z257pTOrLaRN9gsZE38vpubjhfHrWv66YCIj5VHDIShnCwjcMi9f+INJWgAlM0soYnwcuiQ8TH2WEwrePOxfsalUMhFCgFB5Y5jUjbGH0hxa07/CefRR/tn5N4NUP+W6EcR6UTtNikksUCt4arO+cGVMaANbDOrq+3SZhHC4yGdiXEimz1RtP6efLmo57QWO0yoWQ6z2E91ZhHh2PtvmWJiUH/g1w7hzxkF0qLu8WjXk14vP6tRjv6aqXgO1CWi/ZBMtuNmb+qVxx4+9ZMWCLzwJRQ3GlBKztUQXNM0Y3Fo2Rt5wIQTCzAK2E4C43IqaSghwJsz7m6jjJLgqVumf1lDhMmkhepgf64O9dFjkvKlAlrSmUvtEG9MigWaWGefUv4OjSAyO27xfPa0k1QvvAqx2Wai0WfE6p3oaF9UHJLGoAw41L1NhPHUgNC8oZ8LY3RBtw5SDUnh60h2AVDnNFQpv+TWPgpM9DO9V5ClypaRvlh40e3b+QxCyM6w5vVrmU1w2QPUWSOnCRC30cVKSQkj8ztxBTnSDHye9eNm87Wpzbq+Rd5YH8svAD4TpZJAkHqv9ypJDaRB1GbycxNuJHWh4ICvLGAK8t+WD3TFw6YB3cFeYuo15dKnEkouLu6p19AJ0bQG+/R/5RHEQjl6dndUysWCD1dXeYfVB0Vh2YXFfRGYs/NLZKv9Vk2sVOpmUlM8FTrFTPMuUCIA5UGxNzA7
 rXorZ1p/
 fUNcyH3TgaW5rsq+UR3gkcv33xM5vxvQ4kLv+vWntnLatPZaJILeiakJh79M0gjs7cxMgc47bhlTmERX7CXEipPfjRrToL5WKbt0t/uiRs5NsNGmbhAl8jZ6tBzTmsrkbDX9z20jAZRm3FC2e3Prg7bByUpb1w+bR//qIiTj3xuHTrKZhTK9/YMTdU9Y/2RZMboPHGooRaXsZjCPBt0umKWOsir4DsFolzOcUjPwdJcVO/G9gYcJRJPo1pU8YEHodzJ/iQvsj0nP7Rca3+k1jVaFvZtWuUNkunDeJwTQj62CX3OZo4Hq4H3dPjhiiJZvqNFeomLVMdQuoEXR5t7K8WSGPNhpeGe2R9w2M4F4/bP2q+cnGyWTzsYPg1LfzNaopynb2WAVJPHjubDbPtDOpg+BnotUxZrPqzOdBUMvbo4KB65GmxA3OmpG7VmbP1hZ2kbTFCeU0TyRqUzPRN6/gPUY+0AbPkSEB8v0kvnoNqPQ4dCClIMhBjeybuwx3wbsrIYG8ScYlq0IHBgQKIhWpWZtXjN/+3jpwMrNSIIxJD0gJdJpYe1TGQYaJJNgERLo6WFQYvBSuE25BfEVJYxXIYOW3wLhUuZNNT+YB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chunk end offset was set to a block end offset, which could prevent
chunk hints from being updated correctly. It was observed that the chunk
free size gets minus or shorter than the actual free size due to this.
This commit fixes it.

Fixes: 92c14cab4326 ("percpu: convert chunk hints to be based on pcpu_block_md")
Signed-off-by: Joonwon Kang <joonwonkang@google.com>
Reviewed-by: Dennis Zhou <dennis@kernel.org>
---
v5-v6: No change.
v4: Add Fixes tag.
v3: Initial version.

 mm/percpu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..3ecd86096641 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1054,7 +1054,7 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
 	else
 		pcpu_block_update(&chunk->chunk_md,
 				  pcpu_block_off_to_off(s_index, start),
-				  end);
+				  pcpu_block_off_to_off(e_index, end));
 }
 
 /**
-- 
2.54.0.563.g4f69b47b94-goog


