Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF31ECCFA1A
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 18:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A0B38E0018; Sun,  9 Nov 2025 13:07:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277CD8E0002; Sun,  9 Nov 2025 13:07:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18E948E0018; Sun,  9 Nov 2025 13:07:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06D408E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 13:07:12 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B756D13C005
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:11 +0000 (UTC)
X-FDA: 84091850262.11.BBD71D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 16F05C000A
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 18:07:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m75WjUhq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762711630; a=rsa-sha256;
	cv=none;
	b=eLPDPaeUACt/S79d1czMmBHP+6uPInBzoYynjVrH4HN2gF5/GpXe36x7Xokq+XGNre6M/k
	dJzQwlkiAi5RgSwnUYRsM+9Ov19NU7ONhUPpSnTS2wZ3P30/NTMB9ti/wg/TPO3LP9MQ7l
	E0/Pz/+sw+2nHdfFX1lrNsGneR56my4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m75WjUhq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762711630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SyD7wRt/mfijbblI79CRl9e76BRavXQyqr+l5ZBChP8=;
	b=7KaV/3sWGVuS6lmujgj9jCz2ux29RRNBkhfgCSVE/F6Ner+8bRcIS62/u3dWTivUHwBQzI
	Ce71ARw/FMUXG5tncvdxQahRPvMtfeDMoIiGvCoUNBKGy3zfZdcAc7iW2uAQOFuV5doTA/
	Fja67E0m/h6Q4buxaTCp1DYzRYvbvqE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3555344500;
	Sun,  9 Nov 2025 18:07:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4887CC4CEF8;
	Sun,  9 Nov 2025 18:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762711629;
	bh=59w6p5OIO0ukVj/H6iWXGVoWsjSUgZ8nYZ9Xx2PeP8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m75WjUhql6v/TjVEVnpOWQ1J/FB300lERpRYAirZ1FL9l76CpCRBfww1t2a35snQD
	 tJHog/nimE0l2EWB/xf3G7qrVi9oDltBkClxF+5wivdARDiJS82n+dVL+gBKvKd8BR
	 v/8JUuiy6YMgm4mnDcTl44gppUgZ/Wyo5IFO+cH2sa9UGBl+NBzQtaPOFGfayVhBD+
	 867kDhk1O0Gc6+aNChoD4zHmiq4wxs2CHEGKY/HJnXV/ww0wv+WJhTpq7pcJlFswDD
	 AecDB2oiiUD1yMcLmdGjs44qVENg+pvI5a2EtLzvTW+1c+3RwlEOqTma9hq9YQhjBj
	 MpMRGrTMqp8EQ==
Date: Sun, 9 Nov 2025 19:07:04 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 3/4] kernel: Fix off-by-one benign bugs
Message-ID: <d8128f0c8b9fcf5be9684eeee650c24ede242b8e.1762711279.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1758806023.git.alx@kernel.org>
 <cover.1762711279.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1762711279.git.alx@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 16F05C000A
X-Stat-Signature: cski4hssmspryei5yfg93s371yjo5rsb
X-Rspam-User: 
X-HE-Tag: 1762711629-423137
X-HE-Meta: U2FsdGVkX18Pcm1lsqgBXm7j3Achor5nij18UT9v5HMGXyL6bUZ4OLd3Vq8rkJmIuc8HA3gjmKk5WSt8YcWyYeakx2UT158FBAgaH7M5lJOPQHjul517u0KOf9vodd8iV5xMlllRO8UWEDiBSwimRabdl4tgJHqzWb8ZLaH4VfMF+ReR+DUEZMmdpFc7LtKvZ2Hbv6wBLh1WPxPYsZKBxPmZ/O5HPkvSdx3lm4BO/f4sulEzTPvn+BhV/Y+iNEcpIk9bq3JfSN4xk1jMpxrGk9VuC81BSiUccCrKdxT3l15bzk1Rd7aVwFxohJtOBb6npy5SBZn68fFQJgeWFSDKViaw4xehjsn7UpjJDmHFCF7x8ArTVgwZnea53TLagMHoGErnYyADsHd5cWNjL7I3IW9wDHi0djlurF+f9MDKV1y1AY47EK94j/ciaWjLMY24s/1FoSm9+HQdQ+QZYG/NOxkpH5uuJ7ykr9kLM1vkPUDJkhgpWKQ/IFnaLhqhOWDw7e6Dua3/5iC4+a/dPwhij+3bDR2Xo9xsmyfehAzFp+ysZY8KKThOVg9BhNE+v3Z/uSvIPZ6rd079Pbdk4p1eaE8TFlMxzrch10kOf8o6kq82kh8jHRzVlvUxXZXER1dh9SkWROSWqXXbuNnu4EySCaLqy+d+iS8TA3YLIFNX82l/YyW7d5RRvr/0biW1EY4kDXbm2eJ/CI3xTHbJdT2g1yUBwSo2WzCFjXlyJlzPj+snnXz55aKUQEILWemfLc6O3kZhtTFGwsuToj9E7MMjjqYEVNLMYtKl2c339goaACLanqbpOnTZmU+dNPOfQAgMArLGu1kO6gJgrzLw0sJLoavrxZTEcLYl93aUEuIQcHZadSvlnu7HAGXgEevo55BPxTdJqR6GNNf0fTjllYZmY/EpDLM9xQrr2qTinkbx++N/hFhQTUqHa+zrwK6XoHGXDTM1ylA6pQUyCms+oS8
 QTe4XRTk
 joDm3j70wiElZcsn+b2uhZkhzETKDiShgAZVmjTprMuT33yw5R+BjuHoTDvea35HUt/54yIC9FikFm/FSexSl4HkPxVucwpQFCfo6mcWiwWUwVbUexWaX8ga2J1s3OVIwxpXegD8nNQrmXJyX/cjUwpM1ynS0A+haUAmw28vkT0hrlBPkhXunnAj1kwTA4NFVWhq1La6T3V1O6qS9Doo+YGNL3mVHHeuTDMBT1XQZds1g2x0SXb15PXV5ZQM1fY6tXzpL55/7Lg2gZZQHLmyogXF5atc5EklIGwt9UxRq21SKoF7JThmS/8bejjaZ03F9NzwYCLUQ6GK/doAIxzddD2SnlwO4bcm6CzUomsym9Mh6GMTOQVNSvXPrXWhSN6PcLtyd+dzhGdR5H/YiJXnBfoJmhyxw6rni53Shwu6AZxq1shbFXHNxiTQNx1i3gNuY7M2ckTZVsjaPv6E0BF+5GnxEkUwYK0SQ5cy9xn4/+UVp+Vxh32lqoRRfHlmXDzz63uSESLslJ1YQRIu62bTaH2VYm8VlPc6hpSzc
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


