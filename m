Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD472D3B7E5
	for <linux-mm@archiver.kernel.org>; Sun, 28 Dec 2025 18:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF2A76B0005; Sun, 28 Dec 2025 13:39:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9FE86B0089; Sun, 28 Dec 2025 13:39:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC086B008A; Sun, 28 Dec 2025 13:39:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA8EC6B0005
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 13:39:53 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56B19C147C
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:39:53 +0000 (UTC)
X-FDA: 84269743866.09.EE0DA26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id B68C2120011
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:39:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LUXibuFv;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766947191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TMfUVMvvq7EbCICMBIGTvOSyYGcC69m4w9fJt+SkX08=;
	b=K594Cuxu0xiLNX/xMzooyi8pNXXTiJT+MFVTpb0s2rF8JJXq1x/gaU/jB5zuf1XcK+Mpp+
	QIIvA6f1a0MeNDQv08hjiWp8w876DbcRpf7rD089o0z9nVlgN5Qh5W1fvIpNCT5zWvTEY+
	5jynLHAJFgs09Gq4rGrh8LOvjMXnXV8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LUXibuFv;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766947191; a=rsa-sha256;
	cv=none;
	b=MMDzzWMmlSDlPg+i2aqlbOBLtAiFPQt0jCZwnJwSIJecwd2IYGHiocLfzw3W13DFA1v4sh
	M4RJPMolA9zzVt2IIZAgBCd7peCRK3Hid0N1Ucjn1V8IWfBUWmiYfBjS7CEk96lyY2dc0C
	ESzicceU5fDWkCfTfLq58v83v8PP00o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0836860055
	for <linux-mm@kvack.org>; Sun, 28 Dec 2025 18:39:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874EAC4CEFB;
	Sun, 28 Dec 2025 18:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766947190;
	bh=ciQXy86RgfhF/JwMoiPRFmXrwDhJWLlPq9Q8wigsJuU=;
	h=From:To:Cc:Subject:Date:From;
	b=LUXibuFvSETnIIK49egmoOsK9bw6dIOXm5jtZhwG7qSzLSGvIiJXdcF0Y2XUG8OqR
	 73G6VTNJDGRi5fN9j8aphgX5acotMb/tbl+EApGC56QZFzaAPW+AyiTQw+FHpDwI+O
	 Hne3foc7BXtsqKhHmKBUpkfghTf3pp1hqgU63Co6h4iQMXGYy9smUHXuqqQU2GySH7
	 mCD/xl9FUZl6lAs93SDdHY2v3HytR3Ye+zV8W1ZgsU2a4DAJgok/82XzZLXf4jF+CG
	 k56td36Cq8r7Twc2ga0LlprykzfPmKL9uHeW/0R6ge93FOOBlZhOMk7le+Ux3mkSee
	 uvkM0FHOU2aWA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] memblock test: include <linux/sizes.h> from tools mm.h stub
Date: Sun, 28 Dec 2025 20:39:42 +0200
Message-ID: <20251228183942.3628918-1-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: ew9c7cqo4qftwfgoqhn1hhbooefjtb5r
X-Rspam-User: 
X-Rspamd-Queue-Id: B68C2120011
X-HE-Tag: 1766947191-792933
X-HE-Meta: U2FsdGVkX1/myU/yB9lzYuFaOYMzRbo6onRFp6/B9J/iBZJtZpCD9M+aRvq/Po0E2LFV/32x+ksdVxmSOqqVQ8oXezJiey6aEVPw8dCdEYhSaBywWfL+QJy3Q/pg9JSArejnglGUkSovw/16i1uVPJJpCG0f5lCluMC5pCwwPSM6tDj++E3Xt1cw2w9D+5UaqFgiUpu/fzcre5kaKxcM5TcpUpNHCNOLt0APQBDpkvhbq5WAzNN24ihxanRuYchSx/68OPZpbARL8IcQlzJ4n4di0Ce6M2uoW5dNF23qGak5T+ZVHF0lbWy42X+uuydgp2Si1QwDoQVGojbK7Yw77Rr7F7Y3CkPt3HfVsVjKXcn4Dtgs+Uj1EVHou+x9PRaYvfPxLvAhyxPUJwiR+v6YVSmAGlZVuqIs+EAuM8qyw2fuXscvNaYdiKSSkZa7b4O26VW2VgOfrX2P8F67AucjrArljNZfHNrcoLMCIwCjFFpvvbxEjXr6FdY7jrpg2v8jK2zx0NaHPFrPhbX+T7WD3EgAG5vtGQsE3B8Ep2wS6PX89d2HYhdyGh+qFdff9Hqb10qYWhDjcObzKrAuhvMlKlOEESPoCAoOl0Cy9Kx4d63UA61/dZPzry9WqQeD52LkhmXOcwb1Wa7+H00b7gi3BCg/6UUE3FP4JFfibcV4qQ08nPC2tHyMhXUIjEsfcSgLVq6N+E4HSukwE5V+4BNmbn/HKl151jdEydTF42RAfFXcLj67rVci+Es3hY84DdDDr2xAhv5x+U3MhxQTvZ6XDv52N0+8W0zQDYb76zOh8ar++KjZszzzvIvImusERnUCXG54qdgDpTXeBZsj/K096oBZYSjhaCVXPPYAJ2tkkzDgce+cZ/myZyV8WJLCQlDeA9imMK0sd9DTL+WEMhcCq9Enw7h9o0gmnl01Akkxe4UO6tNxQSmiXokY9/sK2uxjaAd8tjJr05Wuz1utxes
 7dN5gZ+i
 fpkTqi4pC9Jyen/4Mtrbq8Q6o2h7o4gX5zsavDZbdfxZkMLreROWKPoasNz9CSbndVAHPbLgXKfjClcAu5QfF+kvAA84XHmfNtTlmqu0Pe39ehXxGU90QCX2Jai2MoJhBAtfyJXdIKxzqSgJvVCp5gBU5jNfWLW3cl52LqRDV6D52seUiMf4n02vVBoiJkTTQ0P090lw6qjyB9V7r7U2JTlhtzoCOctQbmIV0RNDeYkRs2TJ+h8tRwzaeQlDa8VmgZHUY5RLX9XuFlbmtdykVxQeYZXhgKNZuKmF0qkswUQ7HG+bgUXJMm0VJCGTj+5/AX8BSqE75TPpHLLRPBySSk3iSgIeuk/la+SmmCohCyAEuiz4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

memblock test compilation fails:

memblock.c: In function ‘memblock_validate_numa_coverage’:
memblock.c:784:58: error: ‘SZ_1M’ undeclared (first use in this function)
  784 |                 mem_size_mb = memblock_phys_mem_size() / SZ_1M;
      |                                                          ^~~~~

The SZ_1M is defined in sizes.h, but it is not included by stub version of
mm.h in tools/include/linux.

Add include of sizes.h to tools/include/linux/mm.h to fix the compilation
of memblock tests.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/include/linux/mm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/linux/mm.h b/tools/include/linux/mm.h
index 677c37e4a18c..028f3faf46e7 100644
--- a/tools/include/linux/mm.h
+++ b/tools/include/linux/mm.h
@@ -4,6 +4,7 @@
 
 #include <linux/align.h>
 #include <linux/mmzone.h>
+#include <linux/sizes.h>
 
 #define PAGE_SHIFT		12
 #define PAGE_SIZE		(_AC(1, UL) << PAGE_SHIFT)
-- 
2.51.0


