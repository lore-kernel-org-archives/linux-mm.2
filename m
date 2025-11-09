Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E3FCCF9F8
	for <linux-mm@archiver.kernel.org>; Sun,  9 Nov 2025 19:48:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726AB8E0006; Sun,  9 Nov 2025 14:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FE608E0002; Sun,  9 Nov 2025 14:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C4F68E0006; Sun,  9 Nov 2025 14:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47EDA8E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 14:48:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E93C9899EC
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:35 +0000 (UTC)
X-FDA: 84092105790.29.758D9B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5C08E40007
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eb1I7HCC;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzHcwtHD;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}");
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762717713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:resent-to:
	 resent-from:resent-message-id:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=DXKtenz6DaLMGUShcrB400tfbTGBqWhLKx1FA2IPRio=;
	b=c61rFjYQRn7MllC17/uMmW3g/5SziV5klEH5OcWhWoxJ3gcVzzqPG7M0gkOtdVSlkM3m82
	MwVFZBzJf70cUcByNjcpqTsFflzJHSnBdklongb50xvkMict73CoIStYsSljKv47+NaJ+I
	fqyTH+YfO7kV1RsYSVzu8/MM4fLcPsI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1762717713; a=rsa-sha256;
	cv=fail;
	b=5YJbvLEORk4yZixLV0BIHDNzvtK7MGE0ZnOtOIDx0p7Wuz/zCzaGSdGAp/LbvC8Rzt0w/u
	n4sLGEE8kavbs97H6Gsvbhfoa2cU1CuOWhK3sEXIniKhSROAbxY26c5hkRC0cySRzcX1vv
	16y1EiqhOlrbdbntMM8RFMHUSIcYb+4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eb1I7HCC;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzHcwtHD;
	arc=reject ("signature check failed: fail, {[1] = sig:alejandro-colomar.es:reject}");
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C031160052
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 19:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8802C4CEFB;
	Sun,  9 Nov 2025 19:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717712;
	bh=Rsfmd7zbC+kSZ3iat7Z+yufKodHJKLHaalHhwgTU+L8=;
	h=Resent-From:Resent-Date:Resent-To:Date:From:To:Cc:Subject:
	 References:In-Reply-To:From;
	b=eb1I7HCCZeEl6TCepnay1U+s2KFjSh1MyvtgkYfyFuJ3HSVrTWcljHA1plfYUGj0c
	 maL7IP8wIIgBgbjDuQPKpOKNyOLra1FK6aQqTv6MRu7bmlemlXFcuEQEMYueHo/gTe
	 zHzjiUxQJaReJDZEw3oM/LAJ6NxdLBJwx+jbJz2hrlD/PiXzRIZvNvUzYvH9hoqRAG
	 2zlVOwmXqr26At0w5y4mAehBzSp8PwE+Q0OeCe34WMSeczy8Kbnvcdkr29cGOsFXdK
	 rmVrGBGemYg8g95YKZGLybpTo7DN31YaDtrukpKE27OMMUdP7jdP0+sYaoU57EPCf8
	 v3DCjrSyOHqcQ==
Received: from mp2.migadu.com ([2001:41d0:403:4876::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by ms17.migadu.com with LMTPS
	id 4BY9NVHvEGlGGQAAe85BDQ:P1
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:22 +0100
Received: from aspmx1.migadu.com ([2001:41d0:403:4876::])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	by mp2.migadu.com with LMTPS
	id 4BY9NVHvEGlGGQAAe85BDQ
	(envelope-from <alx@kernel.org>)
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:22 +0100
X-Envelope-To: foss@alejandro-colomar.es
ARC-Seal: i=1; s=key1; d=alejandro-colomar.es; t=1762717521; a=rsa-sha256;
	cv=none;
	b=BP8FKr6DRiFBBzpqL+zzwK54NQu64z4zhtZVdD9wmJhcczVXMlfDedQyZHfvIlYm6Ic2jg
	dO+41hRCp/uYscq7IJvCyXS4zYvcsi1hvAxI2LNepMpmrsh0JlGw1u2v8gngCFi58uDOmW
	cHZyt8SgArOvBwhWygbcjS/WnUFvKm4m7sriEH9gtovtc20JuIAlRQWkgsN/MvCaRRZCRi
	DiUoQ1YUR9McwnHnUbB03o1DmlHsSau0N7C1YInCUnw52REb0z75Lct5cDmhmHqHmCprFF
	FWcXk4YUyI1OLVLaMH/dWu/wRSrEO+qv6KPTFNHqzaVHldZm8F95fX4h5zD/MQ==
ARC-Authentication-Results: i=1;
	aspmx1.migadu.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LzHcwtHD;
	spf=pass (aspmx1.migadu.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
	d=alejandro-colomar.es; s=key1; t=1762717521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXKtenz6DaLMGUShcrB400tfbTGBqWhLKx1FA2IPRio=;
	b=mm4jNvLfEK/8RhG/MG/mSrpZ88IsYmzSM2Tz5PWdCvCOgAO9h0M5bUoTXAq0rICFRq/XgE
	sa8vGwtASLrmaZxWR8lCW7rUVIhfiqqVopG2UTiXg4qQeYpMAFO1xOCV2NKMCb68xeLVVl
	S2NSska/YDo6wrxmBR+Rkqx1yboW1PgOEywo3XNk9gDcl7PLmcGQGGczGQH9IRsFG5dhf5
	brLFoT910GEh24AZh1pIlHkVgM2XI48jdAkXP8hOwsK48Vq5CL+UrhbZGx5lyBZu94z0T+
	uOw4fZWyBALhFHYDE6v56cRSuB8QAjkri0QP55kFjlrDdPfh30qTYkBZks8IEA==
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aspmx1.migadu.com (Postfix) with ESMTPS id 0F58FD7D2D
	for <foss@alejandro-colomar.es>; Sun, 09 Nov 2025 20:45:21 +0100 (CET)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 864A560008
	for <foss@alejandro-colomar.es>; Sun,  9 Nov 2025 19:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 49AE3C4CEF8; Sun,  9 Nov 2025 19:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A87C19425;
	Sun,  9 Nov 2025 19:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762717519;
	bh=Rsfmd7zbC+kSZ3iat7Z+yufKodHJKLHaalHhwgTU+L8=;
	h=Date:From:Cc:Subject:References:In-Reply-To:From;
	b=LzHcwtHDsuLU7WJ43kChp8Y+U1WEmrxpjOY+pOb0QZbgixTyvkxjiOmTAz/8B7wB3
	 TWRbDRfB+aNdheUwVW1cfS8JWxcQiLKvrtkH02tsYcG0Z2bz3lCEcvOgNqgwsPjZyg
	 7v0kIE1uGa5DM4QMsOns7CWZi+U26E1EzKbssrZTLidqQcLb9//0yDLLp2a54Svq62
	 H2U9GnqsJzOoqYfhWKxnp+GhqcXm6A0hw8t+Sh8WOKHhvrbfdn6lMtpXx1R5jotnX/
	 4ALKg7RUgbX/WgieaY7soOYa+PMEMhjaxSHeNMIBynget4wtlxnX1cjqzuNZVJij0M
	 xtOabPQWJ8XTQ==
Date: Sun, 9 Nov 2025 20:45:14 +0100
From: Alejandro Colomar <alx@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Alejandro Colomar <alx@kernel.org>, Kees Cook <kees@kernel.org>, 
	Christopher Bazley <chris.bazley.wg14@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@suse.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Jann Horn <jannh@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Maciej W. Rozycki" <macro@orcam.me.uk>
Subject: [PATCH v4 2/4] mm: Fix benign off-by-one bugs
Message-ID: <ac55d92551e43bdb7494911babc4fef939baf12f.1762717358.git.alx@kernel.org>
X-Mailer: git-send-email 2.51.0
References: <cover.1762717358.git.alx@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <cover.1758806023.git.alx@kernel.org>
X-Migadu-Flow: FLOW_IN
X-Migadu-Country: SG
X-Migadu-Spam-Score: -1.11
X-Migadu-Queue-Id: 0F58FD7D2D
X-Migadu-Scanner: mx10.migadu.com
X-TUID: hEYmiNksznMd
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C08E40007
X-Stat-Signature: 8373g515rr8eqzf8dk4utkumz9zcaxi3
X-HE-Tag: 1762717713-324638
X-HE-Meta: U2FsdGVkX18mIzntf+XxaA8/fqyVIktNWzPtX4fiD7jKWBMHxScFFbhqHpezhQo/acERfmxIthehCB/jDiUfDDq5nn5UWhwCB8DeZHr+KkK51u4aOefX3hCnmbILO6Hz5pe+tJF0l1AseLvH+MWCK6SikNgvQ4bh/ZrEeAJP6QSjEebsuZ5F/D5wqCFwyRRQm/1XCbwf+kTs7+rXU8/J5ljo1cn7hgYgIOGZfnNbB4HM+rQtJIpf0dw243WsSBbGHCYUz52Rc2iHzf3IkFL8XSQzUohEKQhlqkLjstftCF+tBBb4KtWLByUW4Ine7+S1mrE0eCHJk0xag8gi8M6k7RANZHq5TbOqURtcH3GSbv+vVozT43UP+XkO1bn3VN5XcAbvRcbNtHZskvS5vdOViTUb1d08+71gxfNYqYN74xq/E3u6eKclk9kBLsa+3UzKIN1gFyiQ/acLidmg5OJ97y6gdClpgD+ub8Lzgtwmp7caBupaNGDD1/eqFldofx7atMworsL/U6Y4XJtMY0SP17BaeH29T0ZPhK6XkHgz5GPc0dCNNVaeD1zkMqnpjFh5KZfSPZJJgDVTL1y4DldMga223kwvNh8SlpEEKzQSJCCI2PCzX8e8j4AzZdgC/Vk9Dp+maTC7QLt1JhnxlR30Drw6WuM36DeGgmYFnnBHu3zRwY2u2WM2NqCwkH2xnCJ7Sk3+eWadv2IhF0CUqACsEgDTJxKfUA7ZK65p5zeRTfnlrs+PCRGjE3hvPYC0P2csOS9iV5uu8wZcwtran62sRDk5anKOSV4hkTLfzRVgtg8fgHEM4afcBSirI/SxG2P38kTF77SBvA0DG5lQgMH7ZM35AAA4HHArNWTL5JOcSHQSTjo4zTIIMjFLW7QM+EQeyG3j6c029Z44md6WCgBtMd/vSkC7Sw0LPNwi3E33tmGlFhDy4fPVlIB3N8Rebq/G5cb4V6x0qQaaZUwAzLH
 0k4KmnVR
 2KTAdv2cU7kVt/dYWbkPP2c5UugQjNUutBEYEs7jlMSG9sZwkYivRkoagvutttLahjnCHNlJbTGyxoIBEuJ5UJugP5tOxr/q5WnibHaMq3lmxy9wfga01ZRfe7d+B35PiUp6hM+8CVQXBgXRYBTFtWLw0xsEc2t2XcfRmKVTqk8wjfKW0d+90/4wzRoc08NVLY5mCcuoTD+PvAcgoO63bkiFXrJ89dLror5iwm+l+8R6vy2mGQ/cN8aXSehZ59IMteFFTKngtDZFqUCVQSsjuzYMD/hloCyYh+h+PfMk5fpv9BBGb1ED7khZusF7zwShZKlYzQNFUcuFB+CljkEN/SEWcX5eO6JyuKGGFPXbifF1CP2ErM2WjWR1+ojXXdqERGKkz5orC0h0r4xdR1AgR9tf6STQhqjZH3tndv0RHxq9FYHksmX5J3fueDbmTYkgDiACh6QNhf7Dt71f5p73qYhfaHDs99l34wV6fVxAbwKDhlZ+UhDfc27Dexp9A9HwfbLF+cgT6KQYl//+R6WzCw8MH5hGvfaphEUK6orpC1wSZIp38hgFrSTDjJ2bo6csCd+vVb9tay/br/xBp4waWoLG7u3gJW/QzvdQmEJCH+VMDG0N65iixGawS0UmsaSV6vIdwRlner1oZM4ZKWqASDjcCl/Ue7MBDxi0o3NB7XADSHLdtnOEYAlyyCEH+BO+HGDFg8beTyZ97aphNmX/JVFYWT4FUmZacqmvt
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

Acked-by: Marco Elver <elver@google.com>
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
Message-ID: <515445ae064d4b8599899bf0d8b480dadd2ff843.1752182685.git.alx@kernel.org>
---
 mm/kfence/kfence_test.c | 4 ++--
 mm/kmsan/kmsan_test.c   | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index 00034e37bc9f..5725a367246d 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -110,7 +110,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expect[0];
-	end = &expect[0][sizeof(expect[0]) - 1];
+	end = ARRAY_END(expect[0]);
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
 		cur += scnprintf(cur, end - cur, "BUG: KFENCE: out-of-bounds %s",
@@ -140,7 +140,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Access information */
 	cur = expect[1];
-	end = &expect[1][sizeof(expect[1]) - 1];
+	end = ARRAY_END(expect[1]);
 
 	switch (r->type) {
 	case KFENCE_ERROR_OOB:
diff --git a/mm/kmsan/kmsan_test.c b/mm/kmsan/kmsan_test.c
index 902ec48b1e3e..b5ad5dfb2c00 100644
--- a/mm/kmsan/kmsan_test.c
+++ b/mm/kmsan/kmsan_test.c
@@ -105,7 +105,7 @@ static bool report_matches(const struct expect_report *r)
 
 	/* Title */
 	cur = expected_header;
-	end = &expected_header[sizeof(expected_header) - 1];
+	end = ARRAY_END(expected_header);
 
 	cur += scnprintf(cur, end - cur, "BUG: KMSAN: %s", r->error_type);
 
-- 
2.51.0


