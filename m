Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A2EECD9B2
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 22:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CF846B0092; Thu,  5 Feb 2026 17:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 179A76B0096; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35246B0092; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B123A6B0092
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 17:23:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2C300BA815
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:23:35 +0000 (UTC)
X-FDA: 84411830790.27.E675887
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6F6C14000D
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:23:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GfTbs036;
	spf=pass (imf07.hostedemail.com: domain of 3ZBiFaQ4KCPsmrugdqulfkdugvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ZBiFaQ4KCPsmrugdqulfkdugvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770330213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G5PGmS6R2KdOtcRkYwYkwwECXFYWNB6Un/sFM3sIK7Y=;
	b=EJFEH720N5I4dXicacZv7NHGnxfZYGJXqQoJmfx3yFCexJ4WUdKFXPtJGwZc2bI6AIS0n2
	SDyh2q1Y5A0zml6ppcvxFqICb2Lsfd6OemIVNIbpYLVuLRj4MNscNFIbmqfvBR5DLw/6Wi
	wXMU8SqArwTpWMAYaGwOizjxdVUH5g4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=GfTbs036;
	spf=pass (imf07.hostedemail.com: domain of 3ZBiFaQ4KCPsmrugdqulfkdugvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jordanrichards.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3ZBiFaQ4KCPsmrugdqulfkdugvjrrjoh.frpolqx0-ppnydfn.ruj@flex--jordanrichards.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770330213; a=rsa-sha256;
	cv=none;
	b=PEflvPdmZiN2FBkoTbPdtzD/0Z8p/FszF6SQ3biZKOFkD18wa3U831M/VuIfzzEASw0eNQ
	2zl9ysrW31JHNwtlAFFNnlIn1j93F704QjVMciHW0H03FaPYw3CRThcmcwTJpKovB2sPEX
	rciP2Ex8dv8nvaecva7od7XErDJhN5s=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2b7eddde359so126014eec.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 14:23:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770330212; x=1770935012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G5PGmS6R2KdOtcRkYwYkwwECXFYWNB6Un/sFM3sIK7Y=;
        b=GfTbs036TJJZJL4p221nNx90Ipoh3X4PHlJy82zlk1UsLqsyKalCpZXRBYbWvTUGfr
         eB+tDoQG94/tFWle7l4VfKQaurTDX7oqGHcwkEXF9Jba6a5+PpgYuuExEmMZEZ4FX3nH
         uMq7p+KEwSknVbWFsH5NdtEvgApSQPhXjH5BMLvgkH2rCYbxYe+oIePjebG6cVrXbp/z
         UmF3m1E5IFeLisT4H7CMM4f0FLSeh1I+CQmdAT1Obss3m8nKfBdfYG0vgimhdiXSgKFB
         Dkrwbv2Ju9vomfj1kUSe0bPHluUliYN4GQeqjS0k78gHuFC6paSeqxlUFvwCt5g2o2Vg
         ZvSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770330212; x=1770935012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G5PGmS6R2KdOtcRkYwYkwwECXFYWNB6Un/sFM3sIK7Y=;
        b=vM4VXFxjLqOujrw/ec9kijRPZObjTKDt+5R3XHCuNoR1QnCT7RS8xoDS3LNcNZXem8
         eA8fsLZ8WwGgnE/5Y1tcmUAF3Lh86nD1/vcHMiuzPhDU2+FzXX35lK1Fm2rePs1YaGZl
         Lb+ysrNnH8wSIAXUaOym2sAUgbKR0o4pm2gVamAFDT93V38J1C/GaNNAI+cCM11EdnXj
         hWPz2zYhkzmgobo8eoL+MEfJqwEsKc/aZzWRpf1CHnJUz62BT2X+3McnVRoPCwztGdjZ
         FH+I1hCctCv76/XuXnM3Gj+QiXhAxBd+Tyr6q+BATadD66Gn6YGbVfdsNGwZs9eLv03w
         Lkgg==
X-Forwarded-Encrypted: i=1; AJvYcCXK77rn+f52LwPvABQCi6HhbJS19lPtT0Tpa3Q/34PebRid2aRguoqhvITTrD44adpojbOJvJLORQ==@kvack.org
X-Gm-Message-State: AOJu0YxXxVVHSMuhhw2cfugZaIbJz1kSkWJyg8vzKlJPHbcuZ4gPKdhZ
	kg2Lz8hvl/ygj4Q96f0Pa2A6P32PHxM9rpoUQsUhvvnpWoNdsW3RgmhP/dJvUn9qs9WIRU6cxd3
	HOZDuLKdg6lrSFsa/OTzH4YZf39biBLfUZM5E3g==
X-Received: from dycrq11.prod.google.com ([2002:a05:693c:2c0b:b0:2b7:51c8:b523])
 (user=jordanrichards job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2b0f:b0:2a4:3593:ddf9 with SMTP id 5a478bee46e88-2b856a45ee5mr281136eec.38.1770330212288;
 Thu, 05 Feb 2026 14:23:32 -0800 (PST)
Date: Thu,  5 Feb 2026 22:23:28 +0000
In-Reply-To: <20260205222329.2419035-1-jordanrichards@google.com>
Mime-Version: 1.0
References: <20260205222329.2419035-1-jordanrichards@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260205222329.2419035-2-jordanrichards@google.com>
Subject: [PATCH v2 1/2] tools/nolibc: add ftruncate()
From: Jordan Richards <jordanrichards@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jason Miu <jasonmiu@google.com>, David Matlack <dmatlack@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Jordan Richards <jordanrichards@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: xtt8mnnnfwjj5po7n4dmz8b1t3ocru3k
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F6C14000D
X-HE-Tag: 1770330213-943593
X-HE-Meta: U2FsdGVkX1/u6AmQXVgtJjNRZCHPxXcxVOo56HazjDJVn75NG3yAqn3RF3x1l4ZocIqGcELTnT7HIFH9Gooaq4+hTwv6CA0YKZvkHGc/hREcjNVDEe9+LCuvcY+B7OUsbav7QhD58FdWh5nILYYCHGBMGizGWG2uxAxKLZB7N6rLvrk6+zf9npHsj6iKVBLTKdDRckYCQvZnAAmMtPUWgsWqxaC+uDpweFhaYekZXLEvGXg757aKy4H3Um5s/elXppcDjf2k+QLosRs7PrUSOH3RoJNCWbXUS9my4egAl+HjI4snEYrD5Api3IVe1CWWsky0e47cHliD8xm2AnwDBQ2zCUxS50vgf178IEk9HuJdFuLtwaf+YJGb1VtnLuObJWMV4DNkjxJS2UnIkFhnf8bE/RKWvqBwUBzW7CyXdAUG6Ni7z5eichgdAF2ajiOD+7TSsX+Nqkv7IlerX/L/EYlWtxxKIUUlZosC6y8KzX/McndumjBNqzmHANXZa9iVCVbVfqzqwGojKX0EUFOCx7PEzrwIc00YaI1qZraUrbSs/7KoHkBAZLenxcejHNRoYvfncBxW4kqrOa15NjxpDQYivxBhN0F4Y8RXhnZIGpllCLrXpMq3rLMuc/3m7mvn+WR4xBV6d6vFcnIoKwNAE5gOSZkAwUZXGnH6q4Fa4mT2iss7n/34OguWiQFBVAle+lCFGDOd+FjHAv6NZ1hEXJB4aqyzLH8PfRaSYg0/Kb0Q5NYAiDwmI3E2wnX8z8vIx1cTCSO7ikuqk19ACH+QwSZZexbK9Jo7W90mHFA7ZRMqqvcw3/QHj77gd3JHUggbnp/Tv1cvEZf4oDIBbEYlvyIwXSeXi/g5XY8Fo+44qxKzv4dHsUgHDnSEirRSb9D8aVOlxbPuOpEdGP//BUfy09ICjhiqC3pZ6BJfRQkdcIjo6f4Bmk9xzInptK0xf5d4Dh75peWASqSxzZCspPd
 8lzSJyNe
 KFKzvcm8h3zwQJjhJjnW4sSaPkzI43B9MrgarQmiAH+txr8pooofQ7hBz6/uyLczvFGumXBL3wo+VIiOlLt/swaPqpz1rFZJnykzb2P1y12gKsHGbJFp8+P2Dnps64/SKyISmi8qcFxQYrOZcWKkL//pkWcXwLaFqxRI4W2X+lzKE9ktuXWG/cmDzpzn9Dn1q9VwdV8jrrtsK4QGIurCQHFhq0B3Vk1fTgQPL3lawm4nccHQIT4MjGZ57z2//Og04OZ3b1WD49Ucj2TouJl6d6GGflnNoQzzEA9KAoGtWJV0VS/E1IGDI8NcWFO27cAqTlBRgiQSP8tKYAr0VQlQP1MBvke9ddOUuvkkFdnD+meC2ajm7Kz13MOOo/1p1MG60/rUfev25oBkIoLOZAKDLs2l4r2XzoKkhZDPGVtRqOagZ0ZREOIKroo67Vc44ys9c10BoK0xIwehXao1Mx0FCKP0Loaw7++krXsyiXlELSi3PDXF6DVDr2oFpCtv4eqDHDEZKj7xLZSPxzsCXc/hTCDd4k0JjctauXkURjIjwaPWJtXGhe8PuPf6nL8PBz3Q21wD1s4XJvryvQXTBnZQAIvZPFopJt+vLQUFqcsCYDhN7jFhI8BkfEmoGp3zRsMLv9JkF6e9gO1aR3Q/PizMSeiVfAoJHyVK9eWoY14aleWf08y14+DF6xw7z4Sy3CzjKa3d0wWbcOI8cywBT3rdQs2coIZskV0TqLoid
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

---
 tools/include/nolibc/unistd.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/include/nolibc/unistd.h b/tools/include/nolibc/unistd.h
index bb5e80f3f05d..845d10f48fd0 100644
--- a/tools/include/nolibc/unistd.h
+++ b/tools/include/nolibc/unistd.h
@@ -48,6 +48,17 @@ int access(const char *path, int amode)
 	return faccessat(AT_FDCWD, path, amode, 0);
 }
 
+static __attribute__((unused))
+int sys_ftruncate(int fd, off_t length)
+{
+	return my_syscall2(__NR_ftruncate, fd, length);
+}
+
+static __attribute__((unused))
+int ftruncate(int fd, off_t length)
+{
+	return __sysret(sys_ftruncate(fd, length));
+}
 
 static __attribute__((unused))
 int msleep(unsigned int msecs)
-- 
2.53.0.rc2.204.g2597b5adb4-goog


