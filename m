Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F395D3E781
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 22:46:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8415E6B000A; Wed, 10 Dec 2025 17:46:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819806B000C; Wed, 10 Dec 2025 17:46:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72FF86B000D; Wed, 10 Dec 2025 17:46:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 631926B000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 17:46:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38117134FB6
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:51 +0000 (UTC)
X-FDA: 84205047822.16.1EBFB74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 90EEF2000A
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 22:46:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFWUzHtI;
	spf=pass (imf03.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765406809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyD7wRt/mfijbblI79CRl9e76BRavXQyqr+l5ZBChP8=;
	b=D4M5JWvFuwqfwNeW8Gx/5eQ8MtUgCNBcrxqSKpuamrjLc8XGNMlT6Xl5x1SNjMk9JvGcY4
	spto/91+HFmvWoaQkFIIwFRI5LsFIGuIl5vFJWBV0L5mWqIMXDBfd4bnZ5VH32UmC7FqKb
	gq1I+YwfedRt0cvbvwphs+aUB2DaCzA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765406809; a=rsa-sha256;
	cv=none;
	b=BEX1KGGxOy84ILlfvM4RGbqPBFGjhZB/KJAOiEO9Wr1yo5T7nSvJFj8hdwBE26z1XjSta/
	F9e6T7KrCYSAkMfSpTUJPpehan+6Gj+9GF1W+zIbTcMQRvqYdd/Cp+8G2Ozypj5yhYjsoE
	J1eItVH0+WA2wfV97h0Lzw9vMdTeeNA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uFWUzHtI;
	spf=pass (imf03.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 12507601A0;
	Wed, 10 Dec 2025 22:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8716C4CEF1;
	Wed, 10 Dec 2025 22:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765406808;
	bh=59w6p5OIO0ukVj/H6iWXGVoWsjSUgZ8nYZ9Xx2PeP8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uFWUzHtIKq0MdPLcgSoXxbDdivKFxFKV1hp7nbScDSw1btmYrugRIksf/Ptp01M6P
	 MH/3J8wMmqP/NL0xrOyoLEBzAV5DQ+QdLkUn0SgOnVnNi3aQGTOQ/EQYFE2ZfVY8H1
	 ovFvbVl0+hw+plYIJRA4vCwoRvqijDh/qoAduzz2EuOgrrpmdesVezoJqdTpp1seyY
	 A9avXq9Rh6ynPSwej7BJ6us7vJZ7qwBKNlTLq/Ni8QWAJ6YPTO7fHRDdngC+frYVyg
	 uUCHwHPv+9I5WsIRW5WKvWB5Pgbsi9FqrOpZScgd/Vq+4SSF7iFhzE6nvTqCjhd/bb
	 jnVTodwRHhf0w==
Date: Wed, 10 Dec 2025 23:46:44 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v5 3/4] kernel: Fix off-by-one benign bugs
Message-ID: <b4a945a4d40b7104364244f616eb9fb9f1fa691f.1765406337.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765406336.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765406336.git.alx@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 90EEF2000A
X-Stat-Signature: 418hfjw38qf3uar3tdjb1jco8dn3wo9j
X-Rspam-User: 
X-HE-Tag: 1765406809-964917
X-HE-Meta: U2FsdGVkX198IoGPN5uIe0YKqXTmd6If1ioWhubqLPd63WX50FXjmGGEiDndwa602n35g25AChNN2bvTBK7xRhsPQxoGzntMMU77WEhT12anISrCmAQCSRr3nejPXkFF+G/l6SWnfXtsFJkiFWqJQv9LVcsq1sfV0DFAtFZQgQzuZWze3ivu4AKPkoCcY5F6pgourjecnLWAKGmTr/j+aJmIpz25XEz6eI6xtCJ9lRlf+TuVoZu+xHI7YGduvtD629PHOHiWUbOva5fIEtjMKjUIbwI35FxbVxp+jTLg7Kz4LRt0ea6JRhsyLXG3sdvMnAZ1oh70uLZfw++zxizlZwK/oyEscEPDhhCuWu5PsMbcaqwlCG+vWltRY/50M3Afn4GOOOqVrkWO0ix2JrgIp0YisVHlFVOhMm8gIjru8x95IWcsbTanq9i5Io0Ro3+TViXedwF+kIzsDaU+KFEN0b7O9uXuaQQ13d47jJ+Q3Ac3qep7StTgl5oRYFTtForqTBBusZ+liM368GVZ4GMbk11p2O3NysFkRLA/JnPPNm++gNDpVHTdE6qQax/YTpD5tGKrqJTUJBmU1fQtBtTh6URP+Vcx+EoROKwCyhpV67QTdgtj5X44CU2eLBVCewbEQsx0vxIWneZ0Ibhnz0+2Ia5pf1HDCDLrd4tywq619kOZtogCtYI3Ko0JrFrY3KS1e/9lwqwUv3t5D1KNilvM63ozmkw/wqCrWEOLD72mZdqrkJwEJip3FxxEupzVDFle8XtxJccCCfmeSyfxd95QRWhRZE9KJaYf5Crf+HuNzm4QuYMFlJ/HMHH1RTbDg/LLGsldrgwsmA8+im2TJ6GthkyKml5Hnc4gIBrKH1ihQqe9+SY6GUI69QhiOUvbcy0Ldwu/KOphfXKpnMGYUvFxK9DT2hkQ8RAagHR8YRoKmJJ4qcgw8UdW5nFAkQT4zvnq8kSJis5vROImNg625NQ
 WjaS9ONe
 5gLwyY6UboUybvhQQlm03BVmMVROvmEyVX5P+WCk6Dr2YzF8kwrA3q8NuSJgkuX7doT9QWkv7daZyoZxduQkQLqzhfx3r6nVLADraoWLBj/STJnofmPd518JHSn2w4K+WZikJtBMIuSVnfdFk8gqM0tIl7xBlu66sxQgTIVK+ykpdZviCxqJddBSNlYKhNCz4KHIlT2lsg5e5gGnmXCk9Ol/zj+uTHo/rM/xY5FZw1cxBvMQTS62c9XpeZbazO8TDv2GMCjEcjXIN/4oZMfosdc8nL05/Gx83KmL5nNTys10nsE+EFdsAg0GK4tuNA+9/7GBKMmVxvz/kL3LRmboiSskuWEce/T7KCLFWpKlsAske27LiqkmEuZcqiA0UxAVSoueDPdqJ3SBuKhhWOcKhEhyR7GfO+nInAo7U8deQ4toWjB1w3io+RbFUXqq/ZQN2CFP67AcYJM/34vTE2XrDl2tCKFTWDmo6dICdeKym6gelGisGI2iNvfz7mtsX7ikDnloKbLaSHCj2SgM7ELIv5qkzJJftie4reAA8
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


