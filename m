Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E6ED41C17
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:44:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831776B000C; Thu, 11 Dec 2025 05:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808CF6B000D; Thu, 11 Dec 2025 05:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EB86B000E; Thu, 11 Dec 2025 05:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 632ED6B000C
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:44:12 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 12BE61A084F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:12 +0000 (UTC)
X-FDA: 84206855544.09.F820845
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6E49F40006
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXtVyLRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765449850; a=rsa-sha256;
	cv=none;
	b=pLP3BXqn8z3/BbCD5CNNqHIGEBNSEl+nIbDyT0uGUJRR0IDc/Co92ZTnyG5n1eFGCN97eH
	KZuEwk5tAw0DFKp+GLowC/ECIbsvsEfJKIemDbWbPYoW5Xyike2ZWsLFhIcAlFFVp2bR8f
	o/qRL2twjgYBXcIA6eGMwSEoCDvib0s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXtVyLRF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765449850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUzGgpMGevinKaBWx6ZjTzFY0phpKwDvqrGh1AM2ZcU=;
	b=35BoD/7tnXv1Ae7esHvSjM5TCbisManrutnlRpURf0vbxaFEJKVzcGpPvggViS2kMHkJva
	2IOzu9rxl+l+pj10rSdbl3121DxQFcTwWMBUrbazvAEq65w+9eY1Z6+GZQ9VokahSXCvTZ
	HJtok3J0FLabEkL3vYYXRagYi5u31Xc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E1C8C60151;
	Thu, 11 Dec 2025 10:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99F56C4CEF7;
	Thu, 11 Dec 2025 10:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765449849;
	bh=AW/I4n2Zznh3mDRmErapu5OH/Tja5kRysX9LI6GHSSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SXtVyLRFXLgpEWU+aax8xuITVDHdmrMq+nnthPMygNMw5SkAnUEj6yknaLr4eWU3f
	 6eFi4lDk28GP9T46f4tUYnCS7/MoJp9AOPZayUCFHJc/RDkimACUxwqXl2Kx0UEub3
	 wPvDrZ3rddz9+9Cc7N36icqNi117vRnZ1aew/G1A3D1ipWNu62Jc0XwLVoZDwVulog
	 Z1C5glIzpBNfTlRotN0Nd+vnZqwUV7633bgj7S+uChyIWfpOnPjAlnEcaifU3k4s0d
	 4L7rpMWLyJ7ubUoXq5olYCWQA5BQkHKRiB8DLYM3OUmLDN1tlY/DyMFg6xwXntnF/A
	 gqG3ttEBz+EaQ==
Date: Thu, 11 Dec 2025 11:44:04 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v6 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <2335917d123891fec074ab1b3acfb517cf14b5a7.1765449750.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765449750.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765449750.git.alx@kernel.org>
X-Stat-Signature: tbq646j1swym7xhyecx5rxia1xmmy1wn
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E49F40006
X-Rspamd-Server: rspam01
X-HE-Tag: 1765449850-453739
X-HE-Meta: U2FsdGVkX19haaQ+RUyoEwUdLlX5eHFAGJ6g0jqhoevF0a9pxYWZRuiVOhMuOwgoCzx8ebgIkEdaXHSm9CYkDpTfl4TAoE1XsiADd9LPsgxYDBkTj72WNM4DnbhVprgvNLKWaea2p7eZ8cLKFJ4h9OsrwKDjM7m9SjcLGWYcEoxZIjuCc/6A5HZmQvxs9kC/koNICM+v5WL6fF81USZA7IBH71/vOql1QFhynUPRz2wQuQPuD4D8MurrdAqvygQd6j2K81eaXdho6+0bRMbZuZR5LsiN7IFTOLza4vJj9IpIAba+E1a6nJfxjKgtQ9daje9615ouIPYXrlrYLiyN2mw71JYPGyR3S3ms7K8FXK6bixwBJ/lYNL8D4EHDM2f6ukjalrlBXDS2QKY7GRccD7XCrKHFpPnp95N5k5Bc1kodZ1jBmdhBirFlA6GcxQ9p5BqoeHTc+yx51J+F4+Vk1lRSmx3laFvlK+6qRuICIDcIO85qlCwO0Mi7xfSHUZVTQqVjwqhO7B9kfEWWVqWDiCZhf9axUW30cQvrqKSoS5wIegVaepDCs1ZtmW4XhFdXOdECJw3Iw2YLyug7QcwPMr6F5LsPq7iRZCabMJWrzMTeiWOBFyTiDsQmIKeXj5V+rxwbxyMDfrCsGyUTIbcIrq7kEcGlVKWyOeraPP8kljTMTzuz4iU3iOfwMfJG3W1nzHr7aiMlOHu0Z6pGNcHsX3qGBuQ2I3KxEG8RWN2KtE1X2EDUljcabH+yUBuSBoKysg+cdak5QM85MAlEK+wJqa9HvTcED7s0xt/uuh9gACIy1lrs58ZGT8cdFs+FGxhc01j+SvlHIQ1UcXtd0VZXTNJo1fnOvknRjRz6AhcFAaap3KFznhTaZOGoFz8tayvCC/gg1sffd+/vR/RAwFQu84mmWilGzc4n9RgM+5YZck0P2rVxZy0z7xe8EkJ7Q3ykKuP0HPKnhDVPaWySU3B
 MH1USVdb
 cvqWRvMGRZsQwXj8ji5ZcUPAVbcZ4QIFJrC/UQezq8p1QgjchncNpB5G8iBQyOHfsUdNasN046olRqSIREAHdF94BBlXgr18ej+dNa60w0NW00IG+eb55Aglmds5tBxnVfH1IaBjYxXjfci/ClJd1aHdonApNvoFs+c8nmESjOLiiq7PItx5WL2I8on3QsgOlrAGwYKKTVgVziYybdztRQucajZAqcxT2YhKVtHcoZc5JhztWUgAwc9qrQqLUZGV7DhURf8O7WinRAhuS6XRoyZtbhceai9/AejA/INkv7aEyN7X55cSZvjjkM4u9C6yHX89jgaXPlFCA8eN36cuoAV6g/a7JSHq9Wwb3ndSEq+bphvFcwm6tD5WQlb2Bo1yF3kFra9s4HsaSn0jdDYV/4dpRsozzsW403BzCwuSd/CHFQGo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There aren't any bugs in this code; it's purely cosmetic.

By using ARRAY_END(), we prevent future issues, in case the code is
modified; it has less moving parts.  Also, it should be more readable
(and perhaps more importantly, greppable), as there are several ways of
writing an expression that gets the end of an array, which are unified
by this API name.

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


