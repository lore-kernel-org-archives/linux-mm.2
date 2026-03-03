Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 952BCEDEBEA
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 19:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F22766B00B1; Tue,  3 Mar 2026 14:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECB6E6B00B2; Tue,  3 Mar 2026 14:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCADD6B00B3; Tue,  3 Mar 2026 14:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CAB6B6B00B1
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 14:50:37 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 953611B7513
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:50:37 +0000 (UTC)
X-FDA: 84505794114.04.E5D8C08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id E6FD21C0002
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 19:50:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHOngpwl;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772567436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ANPBgiBdp/ufFe/6nV0Mso+/P/6GKB28IBB2YrdPqJc=;
	b=SAC4F0AGvntsEKPcZVlZt4l8YwPHWkMq9NYNbCdGcpRBHgRJDMaVYeokdNiGbfrRJywplv
	tYELC55SXCG+ieum7kb6yGlyJl8XdagL1qHzutPfU0B3mCoX/YMDo4J0BWuiT7y0ZcFfLV
	dvBzJpiw4OolY6a618l4v3WVfUjlrBk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772567436; a=rsa-sha256;
	cv=none;
	b=b9ejGhDr6Fu/SfNMr1JNNyNMbXjA6BNuB985kBfx/9pGxoZYBBdqRbNt6OHYaHu6yvnxOi
	zgB0ClTYqwUZT0TmIqT4w0sdyWHEzvFqBdpfucN9yJNqxTXaUTqg1HgYJnHcuCJAtio5rT
	pD9oR+7GtDmOLNXsrUkKdSJ0pxLVxy4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHOngpwl;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C902B40904;
	Tue,  3 Mar 2026 19:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49640C116C6;
	Tue,  3 Mar 2026 19:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772567434;
	bh=XDC0haHYwaNKHX2Q2sFwYd1iadMZeI+Z0ehZ14CSn/M=;
	h=From:To:Cc:Subject:Date:From;
	b=jHOngpwlKulDRgYX88YQHyUwJADWAAuzA8SzIB/EpHRVMQ9aReAqgeM/pErhG8Puq
	 pcLeUbI76+MQ1gRZp1p/7O8zNkAE0WbH8XK+3BG4Qnxh23/Y/+jsoMGRjy/lYi+DW8
	 v9VHjKPHMqkBsugTvusfoO6m9dLfCxyQu8VoWv7Ss+1rAcn+cjDH/wJpniMOvJUPl3
	 8Zu/ST63bqH0Mz+PRS3+LZleY42BPeQXqdmjI9KfOcs7whiacRjkwFd7K9aXVNaBTY
	 IE4OamsjTl1QAlkCjYvhoZu0qwCl3amtaY0nH65Bh0U4Kz8+PLbxfnYYF7CipRNC8V
	 zOUsrJmZH7SWw==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] MAINTAINERS, mailmap: update email address for Lorenzo Stoakes
Date: Tue,  3 Mar 2026 19:50:25 +0000
Message-ID: <20260303195025.1170895-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d47nm635ui8pmtnwd9skza4ja1ng9yy4
X-Rspam-User: 
X-Rspamd-Queue-Id: E6FD21C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772567435-935902
X-HE-Meta: U2FsdGVkX1+VDEdbBXih7OB/CrKArNpAYvq4tZfL6PZ5Rh95voxSBMUiVinTdY0AjsWM81vIFcn0XyS3fq4rfvZpaAg9A7CSuGGLRKdoE331eAWXHW0hmFaWgE+11S+UxMb6kxZNLp76hJbPwx32jl7krPWxHy8kDkbzYhYoryP/pozoE6gic11qh7VqXdbHB1eh/ZQkJUv0AlNX3unF4bwpdbjCy0HJi5v3bSfH83f1N8bbsm90TU8Ww/tVJAeWTv746DBxLQKsTilPELh6ZzKuSu53wPANprA/WdeNXjTBTltgSy1aPuZkZdPChdmjI0MtcGmoiONoi3b+tOBSaJyuVvItN9d8DvAiDfeC22ZbSjYp06Svw5NHnYE5J7YE/2bvlEY9WnkFaO5RrLjm3p9giEbsKtLwS76HtZi935TZQ7JQVRbSWPoYDmALpeM6jrwEYTP22UGK8MQFb+z8YD58Qm+isS6JPr51ixaf9MC7tYlFnjM79cjsWWSKp7XSqBJpWvhVzJB2UgvxAxfFeUwlcwzX0RVIYXw+YQ30nR2Olvk6xGoYSZsHVXaDjaA+gpajVTrBnMk8XPwoojzpohS70vtfM6OpMiohiRWVnWH1tBKTvleiMAESmuzVlwxrpVPig35jIaHnhV/2eGW3wnVxm3FRNxsdRnqcTxALnJFF7/Jo25Hu3ZqbNv8sQBm8sfxh6QAVDopSArENQOU+ttruR+RFKTdiyqMWJt1mVm1W875ze4PL+Hsq1/Q0JR7b7Tku+tuwAJ4Wk3OONxHZvUPT7+G2Afzmr/3L0f0uEZpkTQC3Q7IIC1WDXZDJaT1aC/dhiPfCCssSxLfypun/zZMdDJYUZC5788o+UF3MqMPyMQmXWMyYe19zijKcaun9I97x/sJ/R6NpzNV1HAKfVWt4erfBx1I9GF0N+bjK9HZnvnKk9hCt42Rtm623hZOKJmLa/kPGx4ebXFzFaTh
 xQdPr0ox
 UXnLpZfKnaUn/DxDz8tgRSAB7tH8BmSHSSxaemQHx4zeW7SHQzbE6OeTT+sAyRrH3+kCHVcja0i9M3qHa5V+pg1+efUHkIQQSbDovus1hMHRGlyAWsN7JVLHWEBBs0wgLDE0iDEKOpQjpGlGir3amvDMkK0mvBOs+cVytDc8QS50MRrSfoH8guJAYoVYGpE1HnpyYQKjn3JoFCVUZSNPE+FltfLZmRd96fO7RsR55c02sthy57y8uh4joDazt173sTOnWM4UlrITl+fOJuBveVZ2xwC4tCKLXZ+3ABKZ7RWx41UTl2mYLy+TszOYsGzX4vt1KBfIHs/EgFjjkMx6RvZFnclM8rkQFzlv345BVO90AZgax/NAEgQ+OiHmk0oE5OaSJde1NUdqAuI9a7QpcQp7MQlZvMzYRpdh5DdzPxwzVRhZvvQXy6qqBIpQ+njCwmLy5KtFY+ExRfQQuM3PqgFzaF7Ads/bOU1pi0DdAW4Gzz56wHjbAcqizMyyejcRxIsFjc0qixcM+W5aQ4faEn3AFwjw6RYd4/0hkGpZ0QXHAOIZPiV5D6QS6Xrh4QRMhswWw7Hv67n8h13IjtLEqs/jNqhIvRLK7mIlLd8gvi1pfItj8nrfhEjDsAm1VV8BF20y+P7mXrJBBrW5T+HA/bl4rgr3jDGZSL5SXsidASvfpGLBGjXpbVSL505CKt6f7LgugSm/epbq9wRpGliPr34TlpdzOYGc06EdhER1Z9WwSHlBCe5B66BWC02r9YB/6+8Koft80Pvj/ndm0mJDktWHotBOuqjQNlKmZ3N3dTPHDQ0nSUk4Ww7NnQtc0wguGxe/3dgLIuVw9zKrTqCF757v5s3+0bKtTqKcCfcTg0DSzamxnglJi6FnZcooHBfRbUGz5L0jwsvRZcQaRx2AEQjqrgHebDoIfxW3C7AkEs4iEsiaZpisUOX39D7UHgiSLGrN9xNaiNLRUh8+vaMlHj0xcwIEj
 cNOL+Wef
 u31dT1xOavI3o81+IXE7xA8kpN/9kTE8xVVTqmud3iyH20k/OHwMXJtB/2odleo5BmdTkCkW1+TKGV+ySmf2WuqirCqPyFK0YmB/g0IYjkS/WORh4c6yPck6vzcoUHUX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I want to experiment with a new email setup, and using the @kernel.org
address is the easiest way to have flexibility on this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 .mailmap    |  3 ++-
 MAINTAINERS | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/.mailmap b/.mailmap
index 7d5a6cc3909f..04318e1f2607 100644
--- a/.mailmap
+++ b/.mailmap
@@ -495,7 +495,8 @@ Lior David <quic_liord@quicinc.com> <liord@codeaurora.org>
 Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@linaro.org>
 Loic Poulain <loic.poulain@oss.qualcomm.com> <loic.poulain@intel.com>
 Lorenzo Pieralisi <lpieralisi@kernel.org> <lorenzo.pieralisi@arm.com>
-Lorenzo Stoakes <lorenzo.stoakes@oracle.com> <lstoakes@gmail.com>
+Lorenzo Stoakes <ljs@kernel.org> <lstoakes@gmail.com>
+Lorenzo Stoakes <ljs@kernel.org> <lorenzo.stoakes@oracle.com>
 Luca Ceresoli <luca.ceresoli@bootlin.com> <luca@lucaceresoli.net>
 Luca Weiss <luca@lucaweiss.eu> <luca@z3ntu.xyz>
 Lucas De Marchi <demarchi@kernel.org> <lucas.demarchi@intel.com>
diff --git a/MAINTAINERS b/MAINTAINERS
index 61bf550fd37c..3812b95a211d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16653,7 +16653,7 @@ F:	mm/balloon.c
 MEMORY MANAGEMENT - CORE
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -16783,7 +16783,7 @@ F:	mm/workingset.c
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -16874,7 +16874,7 @@ R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <zhengqi.arch@bytedance.com>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/vmscan.c
@@ -16883,7 +16883,7 @@ F:	mm/workingset.c
 MEMORY MANAGEMENT - RMAP (REVERSE MAPPING)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Rik van Riel <riel@surriel.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Vlastimil Babka <vbabka@kernel.org>
@@ -16928,7 +16928,7 @@ F:	mm/swapfile.c
 MEMORY MANAGEMENT - THP (TRANSPARENT HUGE PAGE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Zi Yan <ziy@nvidia.com>
 R:	Baolin Wang <baolin.wang@linux.alibaba.com>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
@@ -16968,7 +16968,7 @@ F:	tools/testing/selftests/mm/uffd-*.[ch]
 
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
@@ -16984,7 +16984,7 @@ F:	rust/kernel/page.rs
 MEMORY MAPPING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
 R:	Pedro Falcato <pfalcato@suse.de>
@@ -17014,7 +17014,7 @@ MEMORY MAPPING - LOCKING
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Suren Baghdasaryan <surenb@google.com>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
 L:	linux-mm@kvack.org
@@ -17029,7 +17029,7 @@ F:	mm/mmap_lock.c
 MEMORY MAPPING - MADVISE (MEMORY ADVICE)
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
-M:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+M:	Lorenzo Stoakes <ljs@kernel.org>
 M:	David Hildenbrand <david@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Jann Horn <jannh@google.com>
@@ -23172,7 +23172,7 @@ K:	\b(?i:rust)\b
 
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
-R:	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
+R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <Liam.Howlett@oracle.com>
 R:	Uladzislau Rezki <urezki@gmail.com>
-- 
2.53.0


