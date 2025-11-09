Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AC0CCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F16488E0008; Sun,  9 Nov 2025 14:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEC828E0002; Sun,  9 Nov 2025 14:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDD028E0008; Sun,  9 Nov 2025 14:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C80E08E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:48:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95BA9593E1
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:51 +0000 (UTC)
X-FDA: 84092106462.09.437B172
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0017A1C000A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuyLJvOX;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JQbX0SYa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762717729; a=rsa-sha256;
	cv=fail;
	b=b32MDPTRLdAwVOQ2wEUKfPKq3t97KGwjEfHTt1kpXR5g0f9eJ8DFqErK+A+KiTK4+BIZkM
	aZQ4Z1ut0ETk/KL3PxU9UehtczRcJOiUtVkeBgaVTXV3c4TeN+EG/lu3xP1jMpRHdtmDDF
	dWZP+1SWO9B4R2VGin9Vc0lin0/4IG0=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cuyLJvOX;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JQbX0SYa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762717729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SyD7wRt/mfijbblI79CRl9e76BRavXQyqr+l5ZBChP8=;
	b=oeIDDp+1TLQFqClS5eXiFxgdrDid9ILNXHa4jd1IxUn2ta+bEu714spiFKOF4xLGzVX3T6
	juEGsJcX0Gz02Tap62FEFou2PFfRuqsyNuolp9cdywEz/pAbTLPRZkhfGI0B1xI7pJyKLD
	yUTz5Cgb8ZX4Gb9wUJdlrnJ+w67+f8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25A204459D
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559BAC4CEF7;
	Sun,  9 Nov 2025 19:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717728;
	bh=59w6p5OIO0ukVj/H6iWXGVoWsjSUgZ8nYZ9Xx2PeP8w=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=cuyLJvOXPlS8IVsLWtcUaESKUNmOD+xHgATI5z3cxeb7tF2HI2eXwKjS2oc+w+7bb
	 mwSqLY6u9hsV0jvux9TTkwq3faU4TtbDQmQrP2QEvHZdyIh2zmvpXOHU9tnuKYyfa6
	 /9BqgBJ/gtRsL+ms3URRwBrKmLaLCuiDzm4jbwMhH/CeRfH5t3Q48b1xelgjiNoGlk
	 ymGyYcG7VeBi1wQVX4+Rl/bUdS8NHSctTip7sk8PBP0f21Mw93XVaecEaUZ17EAMMk
	 MNGJILuvlitZaN24ELnqCHgwuF2weUPi70bX0wZgPh7ROoQHmsT9/OdM06EV7zWcqC
	 ZlDDrLtOuCSkg==
Received: from mp2.migadu.com ([2001:41d0:403:4876::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by ms17.migadu.com with LMTPS
	id mMZRO1fvEGn8pwAAe85BDQ:P1
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:28 +0100
Received: from aspmx1.migadu.com ([2001:41d0:403:4876::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by mp2.migadu.com with LMTPS
	id mMZRO1fvEGn8pwAAe85BDQ
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:28 +0100
X-Envelope-To: foss@alejandro-colomar.es
ARC-Seal: i=1; s=key1; d=alejandro-colomar.es; t=1762717525; a=rsa-sha256;
	cv=none;
	b=t3K8+LOKIGi3fqNButK0FYaKIcyPQ3Ay4gUosmY6Ie9IhTe+n1hYuGcbj2pwX+xT0sVGW+
	EYI69jTvWfbSCt3RU3ByMT/fDlXHG/mAFRe0Mocc82s/7Zpw1/n4e0ouw9SyV9woMmuTYK
	vv+Fhg7w26l2A3ov78MpMq9mzZ0gj4ja1+ZNF6C0j/qJNvCF01Qq0KkM4LJL1nNll5iSrH
	4Bc9gg6TazobR7UbdFAvZZ21CTzwyvQiTV3lW81QCt+afmFtNyzMd5ZR8pgVBtlYkbo6kn
	AoGSOjRgisFJ/iKgKpRQ4sTyTvEoL0/j4UeBwfNQISNAb877VuLJ+WiKBxCYrQ==
ARC-Authentication-Results: i=1;
	aspmx1.migadu.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JQbX0SYa;
	spf=pass (aspmx1.migadu.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alejandro-colomar.es; s=key1; t=1762717525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyD7wRt/mfijbblI79CRl9e76BRavXQyqr+l5ZBChP8=;
	b=Av+oC8EcVZOzEpfirMqTfjPMzjkK3do4ouaqes9SLia3y+QIMIiUnnHjm1gnMSl0JQ7+y6
	rl1Ae9CDbw72ztXFPacDZulJsQqVzgwXhw6bSImIihDDvIqotoDFEuTtgkcDiW/rTCrH6+
	W66uNroJKCF5SDzF1zQQXItNDYRzv4yPsq3m3Tbmq0B/DTiEncyr+257JrsEYVvVohCnoM
	YvLuI7DHUTQogZsRKMJKWpPULai0oaJwY1GKJM94CFjxSFNijHIJ3ZjzZQ6hO2mSIGPd4U
	KC/rPcta5l/XkjvPCz4NBNHDA7BlceoBeIpD/9/m3jkpBmcBuF79z4amtukZ2w==
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aspmx1.migadu.com (Postfix) with ESMTPS id 702BAD7A60
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:25 +0100 (CET)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90F6060007
	for <foss@alejandro-colomar.es>; Sun,  9 Nov 2025 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 509C9C19423; Sun,  9 Nov 2025 19:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8DCC4CEF7;
	Sun,  9 Nov 2025 19:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717524;
	bh=59w6p5OIO0ukVj/H6iWXGVoWsjSUgZ8nYZ9Xx2PeP8w=;
	h=Date:From:Cc:Subject:References:In-Reply-To:From;
	b=JQbX0SYaltov8l0e0BerHUgvsTz54JcE1WPi6+4IiR+p1BvijSeI6ervSU80qRB+o
	 FllD2PIOOkkHC1jHSIgDYpBWYqel4+midyGZUl4R+xxrygeMdm6HSkxBJgh6rf/NEs
	 JVfor2abuR3KKFGj6Iy1HM0rPYkx5G2R1V/ojEXpRLLEyykJGBaQVFVi6eWXDR65+c
	 06zNA3/i+qvGWdyu/4nUFlEJk+/jlCC33rWbmEYSTZLTCpcsXFBJbwZfNqdUFNoX5j
	 ycmH0B9510YwmOK0QK0jb10tG6mFU0ZlmeJ6qjczeBMPAjtOGBEx1SpNHhYbpYDzip
	 gzn+IOntLahvw==
Date: Sun, 9 Nov 2025 20:45:19 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v4 3/4] kernel: Fix off-by-one benign bugs
Message-ID: <ca8dec7f5bc9e5b49693681d770231448f99df79.1762717358.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1762717358.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Migadu-Flow: FLOW_IN
X-Migadu-Country: SG
X-Migadu-Spam-Score: -1.11
X-Migadu-Queue-Id: 702BAD7A60
X-Migadu-Scanner: mx10.migadu.com
X-TUID: yG/nyHhor1Yn
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0017A1C000A
X-Stat-Signature: h63etynjkt3ywzg5k3d8ptos6ny9ueq8
X-Rspam-User: 
X-HE-Tag: 1762717728-796879
X-HE-Meta: U2FsdGVkX191UNvsk7sjLHm5YUkpBSSQbfQlLnwlgQuKyiwm05gCOXx5d2ETrVmPrzaxbeHXFizC+LqDoO+GZO4CNPK1pZDLjmziFTgc/Lnlx6K3D6MF03e3jKpPfDPez3rZ5jK/OTVnYZhbpB0pRNIuFSmB4q3ShjZfJ+flc65srssOxvNUv3fb0tQV3rek25efMF+iA3ulG5EbwBkIFwQX1U1cHIi6GdPvxK0m8DqZlrgtDICNC2fiuwcvI4UG+QbO/L3Z0LyQ41ghoXTnxTWiaYiYkyg6L0GHuYOAhooqm4w93KrLs/hl/E7uiQyIXOM1Kpb5Ygqtlc1gz9WWKU5RT92jAYyj7j6TxluebqcJ3UV2DcKUjBmio/yVTrYFeIbzgIC7Y9kaFQVT7jcl1/YMaJpAA9fGRfgaT/E2pc6lDMv2flT+UN2f5Dl+1H5Vnzth66vLxX0AwrPDKt1WtPqqPyoG5iZDh+oQIOyhaQquY6Z7iJc4oPuvPabtWHdLwZ7B/5wpczlLzhffJnyIg1cLcfCxGCioYLCLDUL19J23qHj9BQw1XZFnonMbGH3+Ma9HcOjg3nWMh5ubGL+9lBE8g5IoE6nwz1kYXEHv0gHn4yPFytSmy83qZU+WmqUY5skUrQLaIT9dVQIGWY9xfrNTVL9T0CciLCKI9MZBaArwjryEx2e29+Gin59PQ9kT+MjXyyLGFenDkShBdlhDk2gJghd9dc7Dd9l4EXRdlBLkV44E9i/Il7NtEoo6MYuVUer6jHCTdCWknoMe4wRwvMDF+mPHo9VGqPUpOBVd3nMOK98EjIyB9BgDVR4SOfk+ZkUi3pnz4/rrlZcCC54Jjh0ZQdMn5IYI1hD6DRazkWbsoQBzcxS8RdUvNbEqUk4cUavE4qWspkjgetcS0YFeV1H2LNksUsnAxsCpNW34LS/CRl0kdsiWqsh+LRdcft/Dd2vEdnp7h80Btht2A7r
 poapSy+U
 q8UnU/ymSoKLihSJTWZtsBaU3Bopd4DSYPm0873c/05qoqKSxWma9bGTXcrvffkJf0hjBEsEqfRZQ28CYSWOQWb6j0E1NitmG+NOp1G2CqP4YhO70JfIS5PrVv/j+Y32mHevBh6LxgKF05BOyCpcEcCl/oq0jHX7wNasu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We were wasting a byte due to an off-by-one bug.  s[c]nprintf()
doesn't write more than $2 bytes including the null byte, so trying to
pass 'size-1' there is wasting one byte.

This is essentially the same as the previous commit, in a different
file.

Cc: Marco Elver <elver@google.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Christopher Bazley <chris.bazley.wg14@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Alejandro Colomar <alx@kernel.org>
---
 kernel/kcsan/kcsan_test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/kcsan/kcsan_test.c b/kernel/kcsan/kcsan_test.c
index 219d22857c98..8ef8167be745 100644
--- a/kernel/kcsan/kcsan_test.c
+++ b/kernel/kcsan/kcsan_test.c
@@ -176,7 +176,7 @@ static bool __report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	cur += scnprintf(cur, end - cur, "BUG: KCSAN: %s in ",
 			 is_assert ? "assert: race" : "data-race");
 	if (r->access[1].fn) {
@@ -200,7 +200,7 @@ static bool __report_matches(const struct expect_report *r)
 
 	/* Access 1 */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 	if (!r->access[1].fn)
 		cur += scnprintf(cur, end - cur, "race at unknown origin, with ");
 
-- 
2.51.0


