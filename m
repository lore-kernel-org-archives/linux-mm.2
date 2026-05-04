Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22CCACD3426
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 09:33:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAFDA6B008C; Mon,  4 May 2026 05:33:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF8316B008A; Mon,  4 May 2026 05:33:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3376B0092; Mon,  4 May 2026 05:33:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744886B008A
	for <linux-mm@kvack.org>; Mon,  4 May 2026 05:33:38 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73182160442
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:37 +0000 (UTC)
X-FDA: 84729224874.19.F4106D9
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D04340006
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:33:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZfEnFY9m;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=desvd651;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777887215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AX3UrfvA1Ikfg089WZjhUzDCbqXp2g4JW2YQG6OsmjU=;
	b=qSkBbqrNt0jzy7kEkwHW9b2z5GIyiI5thIOJq2JCiOkC2T1xk29eSeF+UsK9mF8QnYlSVs
	ijexq6rtqUvkn751VHEDIqkFHLbwQC6F+ctBUHlb3eYnC+YPXpu1lGzvyiAvYRL5g8JRpu
	AABCW2ucjSfp/NoVQT6z9zj1pRVgRCs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=ZfEnFY9m;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=desvd651;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777887215; a=rsa-sha256;
	cv=none;
	b=dsGpYHoyxndIv3Iv8fNhAtdA90Xq4wqnTXLaM7qycs07X8PVdcUOnn2ssz10tcFRXw1HH7
	nuvDbI8s1Mo2KO8cWutv2KYVRnCOSQbg/qrZ7RD3S8pIKoBk9p9hIrYC41hRhgfVuUhdem
	2FiFbPyYC22wqUaEr6NpjEe2ts93H/8=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1777887213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AX3UrfvA1Ikfg089WZjhUzDCbqXp2g4JW2YQG6OsmjU=;
	b=ZfEnFY9mf0iJZB1ywy4UBaWbZrc8H/EtXlIfbBtfonmSQSi2Am5KYfHBpV464WS0iKBQVk
	6v5ZWvddDmCBlBV6ifCojrzz5ZmWlZymKx08Vhmsx3PaIqzeiLQKLjSS4nCV8fDXzlgvvJ
	rbnYq640vbPkkr3ZwcpdcGcj7PDaQIWiEj0Re5BcyHA+dlbBYcDZyGYiqqPjjlfWwt8fI1
	BtY+bvEi3g54Wp66xeAsMpAMmpmQ3qGGHfUgPPQ2oLjfTo9P7/E4P8xN3U4sw7yeQOsSj9
	fLIiA/IC7ghbqQx5j9hCDkBnKUz1LzCG0YrIyP2UNZpTkGo9hUrHXB19fEqR7A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1777887213;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AX3UrfvA1Ikfg089WZjhUzDCbqXp2g4JW2YQG6OsmjU=;
	b=desvd651teQu4s3xchQ3J/eCMojhKG1JMLBIUG7dUu/RPjOGwGT2ntEK8YhMREvL4L9KFL
	c1ifPU38TgG8EEDw==
Date: Mon, 04 May 2026 11:33:17 +0200
Subject: [PATCH v6 01/11] kbuild: doc: add label for userprogs section
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260504-kunit-kselftests-v6-1-712d3d526d97@linutronix.de>
References: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
In-Reply-To: <20260504-kunit-kselftests-v6-0-712d3d526d97@linutronix.de>
To: Nathan Chancellor <nathan@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>, 
 Brendan Higgins <brendan.higgins@linux.dev>, Shuah Khan <shuah@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Nicolas Schier <nicolas.schier@linux.dev>, 
 Kees Cook <kees@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Christoph Hellwig <hch@lst.de>, Luis Chamberlain <mcgrof@kernel.org>, 
 David Gow <david@davidgow.net>, Rae Moar <raemoar63@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
 linux-doc@vger.kernel.org, workflows@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Christophe Leroy <chleroy@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Masahiro Yamada <masahiroy@kernel.org>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777887211; l=835;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=f2sOt9t/Nc7lPFpTZEDpIpO59t74OzxRJgeKcPUSTUw=;
 b=DyzVL+xRfpFMe5PKS783jTTg3qoqmzhHUZ/6MOAtZDAx+lIJdXP5aUWBZRLCxDwqpa+DBjMr0
 OzcGhakd3wbBfx39rgZhAF4A3/a69mMob7GDZWZXTJML3mGcL0DyBTH
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: 8kj358mzrytj3f7ywx79c6f1uzxrq5kq
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D04340006
X-Rspam-User: 
X-HE-Tag: 1777887215-547278
X-HE-Meta: U2FsdGVkX1/uHsAiq1gMngSycI70LMMYLRfDE/ovKkAMivVJwWMnxYD24PrRTpt/AAgmfjE+uN6yYVl9IqXjqghJO9e2Vpkah97Vs/2cz6fSiMFjdB5ZCqaam5d2dyHJ2LQm3DGv15/W722Ucjh0Frh541AcinfGoRqd6nynYEzY6j1KvB0uVIzC6tKnJSMf050WhRosWQJYZo+OOnXHW8Y+0DOAWYkUo1VA+2eEtOy67God+6X5TUFGkh1Rrtm5Fix2Qgo8sCHpCsSF3elz1MdatNBeEZfN6gKxSNkDQGQwYBpmOF6bl9sye1V2X6qNd8iS0QfbbpMyxi5RMZsxSNoCZFXeYEiQ3+YFWwn9J3U63T0t0HjjjeG0iFZTG6+xmgZ7wfVEMK2I6iRng8Wzuq0i+qv61CUsTQ28Z34WPuSu5+gOsrJ0vaXQUXIHXKj6lmMRFT9HyRqm5a8/SEbWgx9h5cJTeBQP8ceCuDyhxWEKXM69G1dQ2gWGpWP1zCAxe2SkTDyiMO6+XJeBsC1pLKu/zgCfPdBhBcD0C1p5wLwzhvmwDNA/aaGff3js5BddaIMHGCzVJTDFPkZpDAx5gQJoHAqg4PP9qJzv7selu6Wc+Il64WGxFrAwrGOKcTSmLGYq0GHtyKPREWa11LFweCAs780UW377/ILIBeCn6CkLtXNqacvyNlcatmF+R0b4IISSluT8zn+8o+VHBroJhhNTnhZA8l0s6RinUtQNFqcaWp9sN5d4KiXa9EPYkDHlXXdbAG11pG8KCEmFj0AVqZetkTsbc2rjcWMIJwaUhSaJIx1e5rItOOKnqwoFGQBjgWHMg0cyGlpV9SqxattV2JOLsz+uOnBs6tnFjHG75/gRBcRtQEgw8yrH1YTynxynS1dtiD9tTIlQVZ56iDANaUAAgY7J7UDTUV2ZvI9LwTOktvvHs6vgiFQ2MnjRps6rDbJqjACABnEPW6PnaTM
 GWSQNFdM
 noOg/wLzFym1vEX1DD1ApT2hiJKgw5ux5L7hx63lV50XTRaw1nOYJiZe7ELVAavPgvv85EoMARap3RRwiBuBMCOHXZtFdJH3jMOF95HseH+J0PapL+oDMQO38rGAQ1eNhK/H1rE0CD0XmwdOGyK9fFKu8wckT/2yexPmRxEOi6pqw4d40VoWztnFtLLritb8D3neArAXGBl5aTFcnl6uBug76EcvJF2nXYHgPd8YaoQHYkZ9vmSa/D9bcBTxS4JbZpIP7QTEF/JKjbwuzRzlFz6z91AbP4aEPyyrzqgSE586l+2BLbpdlfEX8Hi81e8wkm4UO6j59RWR8z2+4/2SyMZLV2ckga6DtDV6FN9Kw/35MwSubWCdcfAWRcNEHaP9s80udLU7Ftt8LywL6FCtyRoR1jyG8G6cRj5jc9ToqWjAkir3JX6Lxffl9FC/Hkh1gKLGoJyxGTBQHfAiFoNSFQtDCwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some upcoming documentation will link directly to the userprogs section.

Add a label to the section so it can be referenced.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Nicolas Schier <n.schier@avm.de>
Acked-by: Masahiro Yamada <masahiroy@kernel.org>
---
 Documentation/kbuild/makefiles.rst | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/kbuild/makefiles.rst b/Documentation/kbuild/makefiles.rst
index 24a4708d26e8..6e54ad4cfecb 100644
--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -891,6 +891,8 @@ This is possible in two ways:
     This will tell kbuild to build lxdialog even if not referenced in
     any rule.
 
+.. _kbuild_userprogs:
+
 Userspace Program support
 =========================
 

-- 
2.53.0


