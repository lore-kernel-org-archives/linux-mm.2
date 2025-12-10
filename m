Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 029F7D3B9AB
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D2746B000C; Wed, 10 Dec 2025 17:46:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8DA6B000D; Wed, 10 Dec 2025 17:46:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BEE56B000E; Wed, 10 Dec 2025 17:46:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8406B000C
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:46:57 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D7DDA134FAF
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:56 +0000 (UTC)
X-FDA: 84205048032.11.E8F8A86
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3256310000F
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGoU5FeA;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX8msigRXIApZg9OK2U1b7wFE91+OTEGS3ZaY6JDHQU=;
	b=rlqDcAiLCvgpYKQMe4kol5F9h9LC2cavv/vFOtg7vhP6lUMDleWIkOg7sR61zI8Gks4AXI
	bZmUBE/UBv84yiEOpS6O+w/Xg0JhpD1cQSp/3Ze0e+bv7tIi8d8TAJ9vNxEoDqsamZet3G
	N5jFcQfdko+b/L5MPPfHpQBrwUHaiq4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406815; a=rsa-sha256;
	cv=none;
	b=mC5Dlep2dUOLUdv//BjpzM/41b/E6Z8g969nricSNiyxPkfm9gsJ57dpLD6vDoQa2pTj6y
	kTqXL1tJ2AsGJlfCBG+ysuNrtHClmZHtiRLvX+vdaEJTdGCi4h70wLKEf/cZs7HnUxf+qR
	3Kh5dRDZ6N9XWQc06KwolhZ+AGtk4jU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vGoU5FeA;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 511E644442;
	Wed, 10 Dec 2025 22:46:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 512BAC4CEF1;
	Wed, 10 Dec 2025 22:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765406814;
	bh=kaO5/IVrebOzmYLwKVSEsBGlfzzeuU+iOQME8bN/Vgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vGoU5FeA59wGMSVS/oe23fWJODFVAbgzS4TcYIXkiWJIUE+7GrBl7g2Qpeg9uOn0d
	 ZK00h9Z0EtzY+hPQRSo5DJkabZRWE9HFCHSOYexrt5maRs8wzmewyQSPGTkU7xNh3a
	 gt/dlmG6YjYgf8l8gF/eLOqgvc2tqR8KGQxTJLlCkLoz9GexcBaQ8kw/0Dmuf01Xqo
	 auN2YfkoPj3OnFSvjHJ8SohgdmxRYL/MG0QgNP4H2d4MGxh0zFh2b9FnEmzYuk6t3a
	 ZiVkdDbK9d1tEo8vTv1q9B88mkl+36z7MpDjhClKZguV0Ucy1bxBSStUTCRmNKe8HP
	 JFNC7pLZiMo5g==
Date: Wed, 10 Dec 2025 23:46:49 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v5 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <e7bde864b0394dd0946b5227c6afac7c05560654.1765406337.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765406336.git.alx@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3256310000F
X-Stat-Signature: uy935eq1co57fmprkadh3qmz7qq55mbr
X-Rspam-User: 
X-HE-Tag: 1765406815-882404
X-HE-Meta: U2FsdGVkX1+8S9tU0sMADWsKbDK5k5MBq9kOgeJ1a1ectIs+9i1HlPuOd8Nvmkk6+C3GYqIYx81hGoFV4ZdBzx6WKcSwA057Q4sLyN1VEZ81L5JHqMxagaNSDAAcr7/5XIDif9Er247XaRcL3mn0EVhR14QVAk3lmh2btes4CryUdz6berfns1QyHBvTDS52wGV/vtHofXw+L0WQB4Wj7VxfCI2Ba9dhKFQOAKU5q4c56+g6nOAt4MGOpu0Zvja4VFVdT8aObJ1lv+zJ+KbwQUzsEuxN6TDGaITbvlJSe5krOUCd5nFj0M9IlAhmoWuc6MpIZWcn05ISLvp/ZFFWCqLs4cRJGe2sl4mas6IPaaCbHsKqqgpSQBnUGDhqIdUuvBxErU+BezTMiYDJADo7qRPxej/OGNlhryvzDQxo5BQ7MJM0xKv6Orng6EMjSkb9GecoZKOAJt87lKhYkPhZKmBAP7iX1ZUQPuG5VDiLj5lrpnTaRvCb7KqnJvtJZLS6iyX97/74MI4se5AX6GLnJBcN4qOSQZD7IvG+q3Zns8U7chPtBdP/syK1MxHJYSot+dJFebwCsDyVBZEa90AyYCJqFt1uLA0EgFwXSQTaDhenK9AU+CdLdiXj94spXIhowE6UQs+QVEz+Knrn/H5Wz2Cfa+HYQkdhaotqR7kWdS13CLWe5wy4d1qBbPTdirzNEdndg3espsskKPtocuoZtYQJ/+Dses8FQdB0fZ4qeTU+b37iWAHAak/x4Xa8BZIFuOOM18OKfQO7p5oE8y6hCZBeaZOXbOi5Tpnf2LFx4/Bork89qc9h6bE39rpQU3+IkN2pbl85eO7Dx0NoAZRcF0jnZLDQRB1iFzVNalQl5h/UNymh0Fhu2W3M4In7o85G/dHmng8xl6qbr27EVpzjpl6K4uqRzBpmJrL5k1k7kPKtpljJfEernrtqmOCry+nxY2xCdQfkS3LV/dwCxRH
 ZmDnx/kc
 fWnYf6dg17plVVt+QbHR69Twb31dYYpZxVKhF0BLEHAyaIKhq5G5YUFRYc8o8L7GW1tbQ3NgHffWgDVsaaGhVYSxEKoYV27pK5Nab10YDyth7qp794ThWGyQrQjJg6HtFNEevNFu3cmtaPnz2h4AYtpUVZbupcDKMHStLMVKT2dLNkaNVN5kajFqvwDzQvhk3wc6cd++7DJjcUOZwrVKSQQLt9jkOND64e3zmuaXCk433Y39WlqhmW+8aIdS7JTtstFZxBYo3FDumcdEUE4FP61BXaXfcRwaMGHNA7s5YGHvxzCGotQKxnlN0I1pxxSqRhtPmlN5BJQ1Rq9PRlyF1KLSukMpyjIm7l6fWwQRAIz0YxCR9gZaylI8hOJ8rZqActYvxD1yTWpBZ4yytZEk9f4Lb1ytvKSAA/f5BV4O44ayoKuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Cc: Kees Cook <kees@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 mm/kmemleak.c      | 2 +-
 mm/memcontrol-v1.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 1ac56ceb29b6..fe33f2edfe07 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -510,7 +510,7 @@ static void mem_pool_free(struct kmemleak_object *object)
 {
 	unsigned long flags;
 
-	if (object < mem_pool || object >= mem_pool + ARRAY_SIZE(mem_pool)) {
+	if (object < mem_pool || object >= ARRAY_END(mem_pool)) {
 		kmem_cache_free(object_cache, object);
 		return;
 	}
diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 6eed14bff742..b2f37bd939fa 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -1794,7 +1794,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 
 	mem_cgroup_flush_stats(memcg);
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 		seq_printf(m, "%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
 						   false));
@@ -1805,7 +1805,7 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
 		seq_putc(m, '\n');
 	}
 
-	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
+	for (stat = stats; stat < ARRAY_END(stats); stat++) {
 
 		seq_printf(m, "hierarchical_%s=%lu", stat->name,
 			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
-- 
2.51.0


