Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32432C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D70B66B0099; Tue, 21 Jul 2026 09:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48056B009B; Tue, 21 Jul 2026 09:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5E406B009D; Tue, 21 Jul 2026 09:53:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A1C1F6B0099
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:53:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 268458016F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:53:41 +0000 (UTC)
X-FDA: 85012926642.18.07F73A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 87B244000D
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:53:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUeIFeUP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784642019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=mNf/cdUew/gFGj0UFSuzSVbRHcS8f/SY3lXxbgCeCu4=;
	b=bQPMWg/Am1S4B3bBCzqB+fORRgqTXL+HZgPlhNw5YKvUO3RoUW7e1g3088CBemeZ/gx3Gj
	kDRZEwgvJZSasdFny1/R75wi/EIJ7KwXRIrhpIftilqTx0Jvtj8t9JR+1U2GUZSyaDefgg
	86gE9h8DTwNPBW2rq/BsrjQHXR3PBxQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784642019;
	b=miRA2jkyCFBKxN0ElZiuL01oo+VPJzpwhmi3bf7MIz0pkDiH1+dIK+SzT41gx6P4yX2HFv
	DRwUhzX8bV2fyBpfoCw4x3c4CukzbnQ3ZBND7wP75wxLQdZrXgs/Jey+YKDJhtR+PRcEcg
	/AR7lEnen+qCwFbSZto7FMTTT6Kehyk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QUeIFeUP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE02F4055B;
	Tue, 21 Jul 2026 13:53:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1751F00A3D;
	Tue, 21 Jul 2026 13:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784642018;
	bh=mNf/cdUew/gFGj0UFSuzSVbRHcS8f/SY3lXxbgCeCu4=;
	h=From:To:Cc:Subject:Date;
	b=QUeIFeUPOXu3qMfEeS+/Rqs9h9/7NJsOupUeDwYD7GSAlbFjqoilBhGwPe4jwcvC2
	 AMbAFEbCQpr1VD9E5QXep4JTCjj+OZzRzWfJd8X0Wp+nw6gWPU34OiJzZAleZPTtoF
	 V7VS0ioGlZ19N631rBoQxZc8Iczav011yqFA30FidUWH2fIvZBcUOybfKDWLM5UvXp
	 ERxkSFfTnpxx/V/yl0NSJX94ENzNNwBkZuYjVj5VnFSct4n2V11BFYUtwsLAuJeVJ/
	 KPlqv3DuutJ5QXVbnmG/JvL22MYJOgqLnGev/ndwKqR6NUGFzpQFARvEPsDrqHFgXt
	 pjawHD4fZ3XVg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xuewen Wang <wangxuewen@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2] mm/damon: remove trailing semicolons after function definitions
Date: Tue, 21 Jul 2026 06:53:31 -0700
Message-ID: <20260721135333.241106-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: myscx9dhbcytrfca8t1zqhtz3e8d5hry
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 87B244000D
X-HE-Tag: 1784642019-849370
X-HE-Meta: U2FsdGVkX1/eqnQolhrfHD7PeHmVgl+Puh/K83J1uRxWWQzUwkzhU8A3Q5wj4Ofe3eBR831la0ExxUgUu/SPUKoPpUsfJA0Oisrpvx2pQpgVCVitiuaJ4e2IsQUc81HKjQSDG5keKXZxlSIqvZlnstWreImDQWuqCd7sJJRYS6PefpIhuqTdQrKHKMQ3j8yJUBZ+rLob5AMnQH/2ylFl6uxXsFknIGYPQm2U66tdCqgAs9wUMVf1UbtHbK+tokiEpa7qlK5/nSfIYR8NWWUyHt9xKGADnhMsP4ojnvzW4zCXC3nXZbNw0/o33O1WlWvbDxmZephJx16NFJl3+vczlwVKbXyCW9NbeCwGo0BkUY0F2pzwMzWjopHAeNwnJNdKic3PCjK6QDJIbc2oqRoO9ZYcRpj73ju5ocP3uX0O6Q8K9HjjPZpraURLAmtMziB1tJuuDyhCgdgUP6GDIsAJ7V1nJny5PxRoblbmU5THQXshOHirgk8eftk6x6JHLHiuh0HWBHZByjnZLzU6OHhxfWgFiF+gdLBrj/K0mNzbRm/0959esyYGDbzaujs281X0MMIWmYMcdI0ZX6MN5uAKahyL30s8+Y+ugNvrNTg3Ts4U4j62WxMEYzrzRNharch3HKppQM64cDxuWu8shLjkFhlWGvyYaDZotM4ndZ5f5mz50KtQgcri7ehekckJLIcS4ELcL4oy1kKAo2qBc9n/3EBBN2xyu8VBm4qS4geUoitVxa1fdJLlb/7pbl0rBY5/0RkoSrRbIgZrInYKI6Abcn6lzGyCrC3zNSnyQS/rL7PjTsXJr3sXhoterCxfFz0FcSoH+/pWrrnSAM11ClCa+VvUL3x6NxBf+AMLVj8D1R+vsLZmEEsf8DUSx6OayGkrjlkargtvENBF5Bi5PFfYgMZSBc5o8TY7QufBvAIPckJ5n7XXc05qeIBRsiWCMjWSA7WTCx2TLa5fYpAOMc0
 VoFISzzg
 AUpytAiQppsB8Y+lLsBNfwTCNhaYSZWkk4vO8UwLThHla3NAtM/5ydgVbwXFeDWvQ4GY2rESPnVy0yhtK+OvQJCDRjIz6Ftiqsx27j7iL0Vy5VvIhXtp/QWEdCld3YhDvdOLR68noPS7jAvFwpLq5ZRQSyhkcncBe7spW87RvmGElGPuXKMqDKIzCuzhPaNRZS9sjzZkhSW4zS7P1WRxcZ0PyLlNq1uDDOkMOAdRDAcs08eY2uSX2S4ERaGeYimHz/ChBthkWFcUePaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xuewen Wang <wangxuewen@kylinos.cn>

Three function definitions terminate with '};' instead of '}',
which is unnecessary and inconsistent with kernel coding style:

- damon_pa_initcall() in paddr.c
- damon_va_initcall() in vaddr.c
- damos_get_some_mem_psi_total() in core.c

No functional change intended.

Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260714075358.1592393-1-wangxuewen@kylinos.cn
- Collect R-b: from SJ.
- Rebase to the latest mm-new.

 mm/damon/core.c  | 2 +-
 mm/damon/paddr.c | 2 +-
 mm/damon/vaddr.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e0122376f43d4..644daf5a16560 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2791,7 +2791,7 @@ static u64 damos_get_some_mem_psi_total(void)
 static inline u64 damos_get_some_mem_psi_total(void)
 {
 	return 0;
-};
+}
 
 #endif	/* CONFIG_PSI */
 
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e4f98d67461f5..5a6a78054784a 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -447,6 +447,6 @@ static int __init damon_pa_initcall(void)
 	};
 
 	return damon_register_ops(&ops);
-};
+}
 
 subsys_initcall(damon_pa_initcall);
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d487b7a4a1042..4976775fe2762 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -959,7 +959,7 @@ static int __init damon_va_initcall(void)
 	if (err)
 		return err;
 	return damon_register_ops(&ops_fvaddr);
-};
+}
 
 subsys_initcall(damon_va_initcall);
 

base-commit: 4304be1e26c22e99b8719c5093ece877708b53e7
-- 
2.47.3

