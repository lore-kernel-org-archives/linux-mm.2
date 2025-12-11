Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4888D41C17
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 10:44:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523FE6B000A; Thu, 11 Dec 2025 05:44:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D42F6B000C; Thu, 11 Dec 2025 05:44:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EABC6B000D; Thu, 11 Dec 2025 05:44:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 303916B000A
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:44:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA7198B163
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:06 +0000 (UTC)
X-FDA: 84206855292.23.4D4A8F0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6028140009
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 10:44:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pFRMtGnp;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765449845; a=rsa-sha256;
	cv=none;
	b=xDU2G0nzakQURttYIcCNoMaFycgFtmANwQfp0tNORaqjX0TKgmwJEsdCP65F2ILqsnlBx8
	KlJDkf3ZVRI1dCAO3F8DpMfBGULIiKIYFiwbggrYZ+yN5GuNXarzuDSb7paDFvciBXvjSI
	OtJVz8M8LiVid6GXjBCtCAjx1plVrdw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765449845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyD7wRt/mfijbblI79CRl9e76BRavXQyqr+l5ZBChP8=;
	b=Xzn06vfFJg8F99QzS1e7WcCEujUIaw3O5kb2O1lXlk2+8CAedfIDq8AhO/2h91dsc7CzD+
	8ISzADnZfkdhvq2Wpx5Ol3BIeN6tG3QrXQdIKRon3FCizqJrZ3PW0glph2qsydTSi29NUi
	3fJB3536kTpw6sdOReP8zd/QCc/Z5Sw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pFRMtGnp;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E9995601A7;
	Thu, 11 Dec 2025 10:44:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4F1C113D0;
	Thu, 11 Dec 2025 10:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765449844;
	bh=59w6p5OIO0ukVj/H6iWXGVoWsjSUgZ8nYZ9Xx2PeP8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pFRMtGnp9RaLnA9mlaRXpbbMcuS+xYuOfR1yP6HZrKcoc1/kbsmlAEIHzj+qjL/Ou
	 U53bywg7t70e7VKIw/XqRSiv+S0O2zunvOs/eXkSnpZF0g8gt4Lae1hMLpmx4ywwNm
	 mdTyld7hpKguk9olXKkALV9XX78jXdmALbMUCNzijnYtPlOKMlF/tlVhCFoeEoB+2K
	 +PHtP9fdooYv+bVZMN46dtP3AHSa0okswCjS58gPniD6jvbPLIsii2pj0QLg7Px5cn
	 KG/x74sgOdKag8Q6WbRyvmpuKMYgg8OSY4ykcYEM3Y4uobRBYPvGW/qDk8wxab+d+a
	 gzpaE4JsJytvw==
Date: Thu, 11 Dec 2025 11:44:00 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v6 3/4] kernel: Fix off-by-one benign bugs
Message-ID: <b4a945a4d40b7104364244f616eb9fb9f1fa691f.1765449750.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1765449750.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1765449750.git.alx@kernel.org>
X-Rspamd-Queue-Id: 6028140009
X-Stat-Signature: 3racxj3skjt63wistdzqmga6nz3j1gk8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765449845-215653
X-HE-Meta: U2FsdGVkX1/fDYgM7wdZe06KacCa7m1eaSR7Joh9BusuRkLKz1xWSDWjph1/YReBdOxmStbnuq7PASxxvAZYGPXtP+RfNaVVjiWhGC8HcQqeTI6KfZAP7C14OdUcHHzH1gREwK7SgBqluMLe21yEkPnkev1KyUJ/LSBTp3DnWtMfgcaCwvTbLxoMoudcUFDdkGarkgYGHwmEjtqye1nvpJXBxye1Fr9LXbEMZdlJ4NteCGwITvH/RxaAkw0Z3OJZHlUIT65KSW47wkL5Sv0YVAVxplaAcobc22sGKox+ilzSo6HjmCHxQLV686vMHz9txqTACXxBY7/ooLlYWq6TzYj7fMrp+JcrCBVgp/OBOZzqFll3SYkX/PpWb0t2z8MlYEbS1z1b29eyq3qUcHOEYj+xb+1zUqpEKMq1ojCNDwVLbELM8qkpRMtjSZ21umcwHv0fyD6ASdTUBfP6JuTBL9ylqTpIyvJ3arSgoPqW8ACd9WkEEzcvBbKmXcpQ5huxx2VrqzY0IaOMzcxZ2ZChsik9huyFt2wh32PEDUYZ6Ga+1kBkH2fpmsxs0DjMOt4r7X3FWQwFgDJXlO9uLe6ffsgXZTUN4ZsNFWiOCDj+buIiOCHluJcxQ5QOKIKNdm3PqA683TZuHUuUZvwpfbdLpNOKzgH8otLlgXa+dh27rViFtW9lVDvMQ4uI0gMoOpCwCE9pMkVeUksQAdn6mtv/UexGS8Jd4LBpj7c+4JqBhdiCSzYUa9xAqPPbjPr96UnJIM4Z2sl5SDVSkQKiHnpgVrihvmXhoE5myfCG22A6Dw5II0Z8TcOM8ZKzNqusGmZj8i1C2+ZoQf+hG88lGCE5On3nV05ti7zq1c8N1ygvfS4EmSzOUV+p5U47ibh5wgehMdz67CW30Jwlu2NyTCwjrm/6c+jz8I39aKHU1ZRvDhu325BsaTRSSzGt/RrjV7SFjbjc5nF1KQGbOBat3uZ
 M0EkHBc+
 EeB8t0psAQKhITH9CWOtxynsSqscVFDvYQXfW+VS67rjm0HpdHNiU5OF4yrxDWDaA3qIisWMYABiiNeHn82tmaEEXEeGj8WG94p6QfZSwOWBDEYkF851TmWIRV074osvOuSi9TpnWpBE6ZXoxDgWenDvWuDGYFdCDbMQSHFCPLZu/Bnpz33+12NdVdoFkPtRH9/moJWbnGscDe1FaHl4GOOxjdDq7XDpDkPtdvQ3b0RHdkkRc/i1lJLTmrtxc+AyQMMGKKcUSHGsAdZV6FMCiXiUS6FBU9qQQ6Fd9AOL4BdNIs3X6comheMuuFjNEJYhE9x8nKV5I6EY1pYY5YPyI3/7AiETH/YwFrBDW83rXOGuE2UrxD888bXppTBIoG0PHX3h1HBt5VQ2jIXxBnlNk2CCVSc2PcGLWAFov+aYG7PM+nX29bS+ZQKJTUMvKDJQTCNHddmFY+1SHUhV4IuMbTFs+ICg+2ebykPYK5AFem2LklHXxuVYTzqVAqi//Cekl5zSkjOkuzJSSmP5TaBxvM4wNlAgrLadhSsxE
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


