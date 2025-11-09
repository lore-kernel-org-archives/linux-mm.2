Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA02CCCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:07:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363EC8E001A; Sun,  9 Nov 2025 13:07:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 315308E0002; Sun,  9 Nov 2025 13:07:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 252328E001A; Sun,  9 Nov 2025 13:07:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1227B8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:07:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CCB838993A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:16 +0000 (UTC)
X-FDA: 84091850472.01.2FBF4A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 291E44000A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lfFWJIcM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711635; a=rsa-sha256;
	cv=none;
	b=S1ol13DY45nqFEfnMvCJD1C0lpmaCkluCAerBO3epJJz4SqV3rVYHgEtPovBx8712REOe2
	S1kf0LMW9kmrA4Wpoo2hnWKGtw8gB9dgjCMRrtO/dWzoQJW1OY6IztpwJ0e7m3xNZUjIQf
	ud2ei441RRd9QKQQg3mpGJNE7sYQNHQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lfFWJIcM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jX8msigRXIApZg9OK2U1b7wFE91+OTEGS3ZaY6JDHQU=;
	b=lYNHuDaZ/3rzRp/Mb+lSZY6GHyZ0I1M/geOh7y+6Fk9w9ItNoYtGdXOv/hjdu9+3/1NN90
	JfHRcbJkaQ5TUnqUiyadO4/0ZCVh2tVKjTanLPyZbMuy6RFJGcJ2AcwHo45GzR1gtuF4H0
	Vv5an37bkri2/1xVprjbQf0hvZE6nwo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 58EB24435E;
	Sun,  9 Nov 2025 18:07:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B83C4CEF8;
	Sun,  9 Nov 2025 18:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711634;
	bh=kaO5/IVrebOzmYLwKVSEsBGlfzzeuU+iOQME8bN/Vgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lfFWJIcMlKISISBM1E6H9raA2HPW4eVb8izpDAHamiPCRjD9yz+rZZO+Q2fJ3fIXx
	 l1CrIWkSYtNrr/srw+vokFdC8aiM6GL5aGBKc6F8r4V5qMYs0AxX9bTPuHWRPhh6n2
	 y0NWPsbo9B6lxCCQd8dhvtmkirgpH0ZDyIFEMIxcynaGsxqLqL5fsUYr6cfgTCtjvw
	 Zx3Q+0RBAImo8DEEGO2wRWn+jYk8COlkpo7xghPZVTF2XugmThkdlwkZZM2bYJrJDa
	 VtbMFW7txrWkaU9GSXR6/PG4XJG+RJx3GkyPJ7c9xO8tp1noYhZAKeu4H1Q3GQ2+W+
	 13LM5qdxHEEhw==
Date: Sun, 9 Nov 2025 19:07:09 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 4/4] mm: Use ARRAY_END() instead of open-coding it
Message-ID: <9646a1d194a5d2f310d4272f9c240453e68c2147.1762711279.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1762711279.git.alx@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 291E44000A
X-Stat-Signature: bub5uoiy5y3ha561fuewnr3ywyajcr66
X-HE-Tag: 1762711634-379551
X-HE-Meta: U2FsdGVkX1+SSU/5/Y+3wP8xCU0NXlhgSirTCDBvAACHeYy8qdovud5Q+KUHe7/isz5LpBKmdclBmDJo3lc+v+5MZgGCA3vs21dtv0778LnnrVHr/ZfsH9akbLBmZ/Wkxs2ZQgIHmxSxzZyySbZd0K9T9A2jCTeEKr2ChiJPO3GkpuiQVqPbspTR1fKAZquhO/gnORqYt2JcNI+DBwqTFon5H3DUxZXeowbJLXbWgaV9OHH7L0JL7m7RHJpzpVzD7NJH44Rc1IEvDXpeJgSHUKUq/G11wn42SoNt4BB8B4Hxx8mYnxwpVPVuZ7FkdbdQEa7WfOeJDJm2Uq1zXlpZb0Exu9uGAe+V7R/PCYEzuCepwSCbCNZoXkpx9n+aN6q6OmcUn36Os9IHoJtWygDCjf9Kitcw9A4Z8M52Byo9ixCvqH/XpnZahahKepu3ypWJFtwVaeAFbAihtB0iJtkVaLfoCrGA44HKcD/JeIZ11u1gKwFkVcY8Kx8IJVPEmaZaH3Z8VDv8x9SoU/7Up18Qllenrlk57OkfNNMNkrx2woBl4fi7DD2dUVWpTITKqOcKb02cOZk38rd2rR54x/KApLy4US+84Z1ox0V5GZe6P2BtS7FxuVJJ9xebozCEKL+MvjCSCVA2wYBFesybUmXhPSp68DgmxZ+j6WutV8k554OvZI3ybTUrmwml5EAIT9Cz+e50KJ1CTNOmv/Zjq9sSY6o0jhgkDMiNxT7PYgh93UBRpQ+nG/9W1OuebY65SHe0RYJ/U1b/D1h+s+TtNk12mMssxFPUx3Ot8D1w3lFJtDkkGv/5djefSSZp7/AncryFLbKRwklD3FKEMjyNprxHRHF+qP/gZ/ERRAK+LZzGj33wAOJCczTJcVo3iokxOMpSMMfDgoOUE49eiCz2cu6hnrz51Wa/H074JTJQ/j6axOMI1DSnm9wo2pBdfSwbr2+De/FwLlVoM/mOhey8Ef1
 c1PfZAYW
 kL8v52t4h6AU7LFd0W1954iYLnxFAC+gczf7J1ZnLgu+eBVovZuos16G66JEWCS05XKt7bHr2mlJnmB16hR8AUc1b2fMgHPqEpn/hgwRJNqRATzXZJXMI7/gJCAkrvdf85zKtJaeIsDR/T0bLF1lE6+6zaajOV6OZtze6ZSI711bswldw+wb2hb23nWBYIZOqxLPeXAUS7LfTHrdVjZ8vGpQCn2StKiELCjd25d9/UX4a1lO6yLtfsEOq2X87dU81r+/IioB13Xnpo0tsivYQFQzp+Lize88iwq2K6UezrscouSkugORDhHALzQ2uYHDlS5bTMyOf5cimUri3nSCaA3nm+RvpZwTKLGVnGnB1pUa7/KzaOUIEx/gRyMOHba9qnbgt1kudx4kgrecHyEse2jYxplIOS//R/ss1YUazojhlm4o=
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


