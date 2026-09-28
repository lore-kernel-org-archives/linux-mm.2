Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91544C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72A436B008C; Mon, 28 Sep 2026 04:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 704516B0092; Mon, 28 Sep 2026 04:40:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 617736B0093; Mon, 28 Sep 2026 04:40:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E83A6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:40:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B46514013B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:13 +0000 (UTC)
X-FDA: 85262523906.06.9F3C781
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 01605C000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:40:11 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DjfX74fr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790584812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bGJHJrOH+riYBdOov+lE8FQ5rx8dbnRY2szuLD404PY=;
	b=zmrcfwSdh0SCLisrTTKrQlwnjp+0ZgqusnVFj3nt+LHR5DzKjmifPbVXxQMvK6kwTF6nNk
	Qt3lDfejGrr3BCxt6W6cXlyzWsY45dohNtsH52p5ctK9zpkMiqopDTMNSx3jgFqy/HICWo
	TEfZZQZBJmj+QspXoYQYToi4Ce8A2Fc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DjfX74fr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790584812;
	b=PmKqJoOPQfdQcXjgcShMYWU8nQevQR4oNbtjsl15IRfDvI7DIk93u4nv6IcLmOw44nnrGT
	oEiqCRHmHDhOoWEKWCJPVVo3T5Bx8KoLHDwuQo1YK6y8Sy29bX/C77Aaboq/7/w5t3Vck9
	lJOCQcBsMwzxJ2oh+OYutX4fQkP33kU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7BBC5601FF;
	Mon, 28 Sep 2026 08:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878901F00893;
	Mon, 28 Sep 2026 08:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790584811;
	bh=bGJHJrOH+riYBdOov+lE8FQ5rx8dbnRY2szuLD404PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjfX74frxAWYMyUFQtctBiJmVvoieVS4KbUstf41uWpfgYe9XU6SBJTiYPEKy05bW
	 Av6Wp2MbeN2MAsvyTLwige6CW21NJtEDMHa2kdPHER7QdvkknnBTXJOeCZp7q/it3u
	 NTpy71mDmE3en438Lq4teRmKUMT6yYkwMaoWwwUHGYL8Ah+dg3rnV8uw85z27obf7p
	 jmekeMJEeBwZuUXwjPAhfQg42yx3VaiHsbZDX7lUAIAnT9ey6SmZqIDRSmMSnIqwSO
	 zD7wRSvydvw4xPprUp8m9oyr53dTKoIyjDm7whej4IbvWgTpOJF0hoKWWlvoe6TEO/
	 +EKCMXDJ7ubmA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH 2/3] mm/damon/core: reduce stack usage further
Date: Mon, 28 Sep 2026 01:39:56 -0700
Message-ID: <20260928083959.4030-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260928083959.4030-1-sj@kernel.org>
References: <20260928083959.4030-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jh1fhxyugodbwmgxwtn1zdzwi58ir3qk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 01605C000B
X-HE-Tag: 1790584811-129693
X-HE-Meta: U2FsdGVkX1/LkXPAp+2KSydPOR6EyV4ImhUEajOFtpM4O9b+uJ9qtQC7zeUv51DXzotx1aY1R0v40dgXAg4+68Sj0DfS5EyWZlqc1lLkv4AGLQSlUraHK0D1Jr4e3UEQuUoacdEa1hmnz/kUkuAu6t3Q80w2RGMPhhE1xQrnW9jQcdqRMdTI7aqO8OSwh6DRSwd3rTRSlCp61djGuRxfKc/wwD646C8aTzT+fXw6VS0j+3dDPemkIbs9JW0jZT2eKPfJv3y5lrzpe/3/3Pz3Q1d3VeElZVy70dknQVHDlo0ZwyvtbyRfss0r21b4rRczw8Cuu4S8p5IZuUMxNh+hNjd9SFpLc2X6XrxcTeRg+gMuBBrqgUoj4obggmdVe1/U2p91q+pC7TDxAAOZMo57ygqM/05bGTw1ef1Mb4vH7Tull7SlbLZJtp3BfHMycuKsnKA2sL5io8Pnah7YsWA2X6QYPrvnY21rfFP4bQviwrYkFfTsQF6Ey6Jojd1eJFeh1vaZg+RFVJgH6MjwenZcw8iSDZdjxKAihZmwaP66wJU9VGsMOtSJ8fDe780M0ZEW590DdMiRGUbTP0agCOiVa5QLP6IlRCQH0VaoKY152hb0jbqeV9uM4TJk2oHCDYQYU6uW78vJbO3i/U95JBytDCWaf7FQm5UY2qmDW5HAXeoXpuRbFhlj46M3fJm54GNiZWcGmJfk/X5PQYUeq7RFlIh35GgyBrmzr4kTFkaD+ICjuCf4SSFwTjNecYjWOR6bl8Ai0gSC5LHcTIGkVf7at4rJO0P+R+v1tUPCZUMk8ZYCeWLJTKJNutT2oi2+UDGp4AwQ9LD7qZdY86UaugSySPMQ4cbxyD9zSET5VMylpPsdYdSp9Vu5NbAzKkVZGvFjk/aso2znloavnw3dmajYWFPteLNonPdo+PKSE/l6FgtXiTMeNshQ9BINBERHBgo2qFzLBuE3dnWtiZ6qA0a
 T9iqB2uG
 CN+a8RSQKl4g7CW+BplFT5zoRFUVezo3JOyIxBW+6OAJQiPJXr9dO/hWB4/WeS4QsbIk8aMg/wevVhuXu3jYfNmQWXOgVhdmAg6Z+bwGZqOy/t4kYa8lOVQrUMTpcsLv+khmgS8ViB5fPQtP5tpgXJCtce/wE7elmDZlI0ZJgu8+NtbVE6QV1j8JzKD9E3sZoKE4V9pAiShgDtzmoPqCb4eIAlxEt2JZ81I00rgtHrHWZDEAdXQiEQ8jgzOZujrTxMaz9ZLPz/gNbzsZdUsQXJaB3joFMIPBafYyFkSJlfJ3t9PcUtQHgmP3hagqze3ItbZWG3v6oj6Qpdr3I3/QyAotQFoNI00gbpvck
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Arnd Bergmann <arnd@arndb.de>

In a previous patch, I had annotated kdamond_tune_intervals() as
noinline_for_stack in order to not exceed the stack frame warning
limit. Unfortunately, my current linux-next randconfig builds show
a similar problem again with clang-21:

mm/damon/core.c:3953:12: error: stack frame size (1288) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3953 | static int kdamond_fn(void *data)

Do the same thing with kdamond_apply_schemes(), kdamond_merge_regions(),
and kdamond_split_regions(), which also have individually large stacks.
This should work to keep the deepest total stack depth down much more
as well as avoid the warning.

I also tried to reduce the complexity of kdamond_fn() itself by splitting
out the while() loop into a separate function. While this arguably led
to slightly more readable code, it had no effect on the total stack
usage and just made the new function the largest stack user and had
a nonzero risk of me getting the conversion wrong.

Fixes: 5a00cae64de1 ("mm/damon/core: reduce kernel stack usage")
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260925130254.4022227-1-arnd@kernel.org
- Collect R-b: from SJ.
- Rebase to the latest mm-new.
- Update subject prefix.

 mm/damon/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 733025b36745..0e375f4445fd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3433,7 +3433,7 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 	trace_call__damos_stat_after_apply_interval(cidx, sidx, &s->stat);
 }
 
-static void kdamond_apply_schemes(struct damon_ctx *c)
+static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damos *s;
@@ -3589,8 +3589,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
  * while DAMON is running.  For such a case, repeat merging until the limit is
  * met while increasing @threshold up to possible maximum level.
  */
-static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
-				  unsigned long sz_limit)
+static noinline_for_stack void kdamond_merge_regions(struct damon_ctx *c,
+						     unsigned int threshold,
+						     unsigned long sz_limit)
 {
 	struct damon_target *t;
 	unsigned int nr_regions;
@@ -3734,7 +3735,7 @@ static void damon_split_some_regions(struct damon_ctx *ctx,
  * split was unnecessarily made, later 'kdamond_merge_regions()' will revert
  * it.
  */
-static void kdamond_split_regions(struct damon_ctx *ctx)
+static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
-- 
2.47.3

