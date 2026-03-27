Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 653EE10AB830
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 14:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0B66B0096; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88186B0098; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5996B0099; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB1266B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 10:26:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 61FADE171E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:11 +0000 (UTC)
X-FDA: 84592067742.10.2AA747C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id D55908000E
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=is4rSzNP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774621569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PephsX9SldnlnYssErliPg/ZZ5YZ6g7SdOx89RD3gHQ=;
	b=SFykIu8moFk4Zq8/ogizBJ5wWzUyvnH6X1k1D/V4jOHDOILzYWB2/aO92x1BPVgBtX2CcD
	kZ2g2rtmfdNBKFXklsqbkT9HEPgNWcuIrBQP+Ndt/zezg/c94wpZ+wJko7np3NlXL6ZX/9
	MHq9VeMSej2Eq4ND71tXq342YcIY9e4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774621569; a=rsa-sha256;
	cv=none;
	b=ph0Z8XrGvPk0tEB2ugOzxxYdT6sQp+F197z7jq7lrcVdf3A4U378SZiMBe1K7FTZGHgKN0
	NQ1iBj1efyl1/WT44nyGF+hdKVift99x0f6HazY5cNUcLw5ZGt0mqtUinxYKUfMrEfaxLK
	m6d9KUuRCjDJbfdHzUFJYewY1eaBSic=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=is4rSzNP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1026E60054;
	Fri, 27 Mar 2026 14:26:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ABDC19423;
	Fri, 27 Mar 2026 14:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774621568;
	bh=d66lxQH+dgjLSvHH2YVQ1SE5I6mwDEHa8Tb0MRJAXn0=;
	h=From:To:Cc:Subject:Date:From;
	b=is4rSzNPi7o9FVMxVUPZZTobzL57fC6GgLlnwJga61pjmm9tCr5h8Jyfy83rArlzT
	 EwclD4muTv8KgQf8YeKv1o5/9kYyCIgwCGscfn0CXsXZLQoOyC5Kzzcnx8dZcMaREy
	 EClRnJs+qonm8x/cOAJvwED53utcN/ZPoyhI+D33YEitCPtDVNFcwkGE/Ll3yP+pFA
	 caGVR7ly0Y7m9XJfAkWtIwwo1Z/PCtRaJ21ZySYV1SQex4pZK0K02mgdKst8sZSrBy
	 PB5i42QuZAboo52Yc2TlaLemNNHsl9cIQPTUrU/7JVSivKYWl32+8Sykaa9tbgk30q
	 hZHVERs3PZmqQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 14 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 0/2] mm/damon/core: fix damon_call()/damos_walk() vs kdmond exit race
Date: Fri, 27 Mar 2026 07:26:02 -0700
Message-ID: <20260327142605.4834-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D55908000E
X-Stat-Signature: 7ft38z6rhnqpze9zuhtdf76zbmx55zjr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774621569-376748
X-HE-Meta: U2FsdGVkX18kN9UfhovT5gEUV9AJ5M3Cu5RVW/oF18EFFpgeq8EIOdJFBGP+mxdX7vcZl2/hGBF23NLn7LtHemM2hw6Gz0MGSWrNiuYAf6/8024vps7A9/DdCNmahPFjxOtc8FluycRZ9nUANKyG8n6AsCj/fDdkjGNeHHAWkLJtvCEc7nKd4sP8T2N+5rSoCSJTrQMHArzcdl/XrHDecabrVhCxXPmlmN+GEEdEzqwJmjHrNNEZByvgvNz6krp9i3AQlP6SK9HV2nN+4dlMjZ9X3p/G/txNY9kYRX5WkmAfw09u+P5xcT6qpUagouRmRy/ZyubNBz/vu/wrMfR6lKMSMR1/AukLHZ4WlznaeNgZLnqJpvPlPn1/XR8Sqj6vfX5KQtG5oIdmFpl6E08a1FCpGYP5PJQ022mnQhuW+jX89wBdSPv2ImFpg7GQxrqjl+ZmeF6a2R89a/GmpdEA6XGj6o8Fuzz2mdJHfN982pASHZw9BzyCxdRLQIMor7j8w6l+6dD4bQ9nraFDYLkPBV1qJKlVf2Lm8OCYfAFk7Cj4LR31Qf4jsL8YdFKiR4R9h31f066EFM9NrhPwyQcfZwcAplFQ/SKLMSHWn3RQbEVdwSdxax8RyaEGJtnKzk2U7d6uj9toi1sB9KbLDMOXEUAMXGjXoCCAeJ+ZnEKbRJcBvUBcK3mzW+HnPxtfiOpj/br36zJeNgs5cLDlkSdqsDgXSyWQMAWtpk3snA4px9AowetnSg1QETz5xMleAQ1+mZaKsS2f/wApJNVaXXbAUj/0ht5BU60WUwOFZY+RXyrPWTrDt6NMkwWsazbYuj2wL0TiALQOQezl5EL2Y/Rzk9ThVskUivyQbcyD10zrLiFJftmwkKDjqEBH3inuUGU6zMd1yFcd6QvGXu+hPAnBsRmQPWtVAyJisHqR76QomGFZKtZIQN2LYhdLDUKYrD+uxRKfdhtJ0A2B2MYs+dx
 /vVRkInm
 PlohHkHCiUJaMwk5SDaalxXTe8dgZt9f1nS9uXO8N99nvBlHkIoDFhDJyipLnBBnZ4YAREAkNTyshpvs2MKkW+qZ3FSSVweSC1RBXJy51jn7Jofq8VUW5wrNyOGZpbXXpxbc79NxbM0t2woCHV/Xc5JozJwgmPZj/Nl13CTk1HuY6hy91kcjLJIX9lRJ8HenPPkqwpTG9BufHfWiRvu8J1U51biCtx0nOsbR82GYShsdl0B+c9/6Qzmuub9VAN82AI0lQUjzDV8Fm2AavRjKjZ+5I1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_call() and damos_walk() can leak memory and/or deadlock when they
are called while the kdamond is terminating.  Fix those.

Changes from RFC v2
(https://lore.kernel.org/20260327004952.58266-1-sj@kernel.org)
- Update and wordsmith commit message.
- Add damos_walk() race fix.
Changes from RFC v1
(https://lore.kernel.org/20260326062347.88569-3-sj@kernel.org)
- Clarify damon_call() call condition.
- Init call_controls_obsolete before kdamond_started completion.
- Wordsmith commit message.
- Split out repeat_call_control leak fix from the series.

SeongJae Park (2):
  mm/damon/core: fix damon_call() vs kdamond_fn() exit race deadlock
  mm/damon/core: fix damos_walk() vs kdamond_fn() exit race deadlock

 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 66 ++++++++++++++++++-------------------------
 2 files changed, 30 insertions(+), 38 deletions(-)


base-commit: 1f03f2e753209de7ef14a675a55453d74c9df5d2
-- 
2.47.3

