Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34FBCA0FFF
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 16:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07BC76B0006; Sat, 30 Aug 2025 12:40:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053946B0007; Sat, 30 Aug 2025 12:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC166B0008; Sat, 30 Aug 2025 12:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA08F6B0006
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 12:40:13 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5512C140200
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:40:13 +0000 (UTC)
X-FDA: 83833986306.06.92226BA
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9A4EAA0010
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 16:40:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gu72uzER;
	spf=pass (imf25.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756572011; a=rsa-sha256;
	cv=none;
	b=tnT6FPjaAsV0Vt6TkEATJWJDaFnstzk2dGNlLgdrM6ZqEa+2nWmNr+ZRAZbAnb136kLbAG
	sCrE5DY5YKLKFCwTHhk1kEZiH5+Cy0hlTwp0vNiqxx8kwFOfsPb8Q/Hxs8ovAPd1SdPbo9
	I02hz1D4IdT0L296HuVfJ5PMR0qWcuw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Gu72uzER;
	spf=pass (imf25.hostedemail.com: domain of reddybalavignesh9979@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=reddybalavignesh9979@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756572011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=umXY/sVFrobJbUWoqmBQ/Qv6pKkoNjnUmJcqq9vp6mE=;
	b=N2KBcNgzdmJsuoeowSNJFtaBWPsqhcYmATB0tMDnjH8WYnYhXTvbcCAgXm8RCW5Nby3jg+
	UveyuRF5ysZZDrcJchboIO7kkfRI6GfijnMnxZAlEEdjd83BDXZlwbiAoJIte1xS4xa0ph
	0OBfW4QwIgWHUP7ZSQOCTlYMgLuK6jY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-249406d5878so5810775ad.0
        for <linux-mm@kvack.org>; Sat, 30 Aug 2025 09:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756572010; x=1757176810; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=umXY/sVFrobJbUWoqmBQ/Qv6pKkoNjnUmJcqq9vp6mE=;
        b=Gu72uzER8HFNvu/ZATR8VK91+gG6e8+n1YuZsyJa1cDSkub45+M4swDWOGmgTEKeSU
         15Q5HrVPsPn+jHNba/PJnaHq4t/ekKrAvkDYwfxqbwvj7vy+sCTBMb0LWhrm7HnQrLqa
         BLDcmw9u8AoqnnFUmIr33Fo8Wwzfit5LBY+Az7aXBWXK6OhTb4UBdjqkviSiDzkKbB7Z
         3fypMpn7/fBU8eG1gz4HQuMbzB/czftg4JAAojXQQDm5+WKFLaOzITP2kuuiyPDyL2Bc
         RKPHY4vuLhL+98RR9s84q5VWtemYIFKLpRUQjwq5nDG04vSLaH67d97joS3tX/hD8Xho
         U7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756572010; x=1757176810;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=umXY/sVFrobJbUWoqmBQ/Qv6pKkoNjnUmJcqq9vp6mE=;
        b=WDGc3cIoA8vj//3simYoWCCMhNTIDUAGOcXne4kfqLEZ5jdCYA/iUdwW3DmyIwaXh1
         RoSTkrKJhgYhEQ6VoOc+PrQ1SRCQVGbkbqTlpRGnJjs2iOQ4fmNgB6QEss6Q/trI6Xgg
         jqenVtdb9KLkoBp1wWM9kiu3C7wgVyZh54O5PQwlmEXwbO4NWdumGmQSSiHFG99NBC63
         QihpLaDOZWk5eK170zXyyGoAibqaaLdwBQ3dCd2EWJlVIGiLFVZrusZTVtMbGPfxb5eo
         LX6zRmxPeE5kbt/gMgurXlrAk9Ndnjb64vcWbbTqkz/HJOC853tgacp9pcRmtGx883bT
         9LyA==
X-Forwarded-Encrypted: i=1; AJvYcCWcqXJBYox3880xWd1ZvCcOZwBih4qCOZc+lFViKdPba5681vb8lvxbWHT4qwxIWG0s2lXtao3LWw==@kvack.org
X-Gm-Message-State: AOJu0YwnwQeqMvWfVxvENBW4qX0AQIa+nMUy3oezzZSM781kYp9zeKDM
	I/Z/QCEAK6W7sGjPxhMuO5XwPz+NtGTPDwX5y95W7TuOaXVrDJp4Vg+qyRX6D+UWhII=
X-Gm-Gg: ASbGnct7OSI2G74o/rRfv0oRWJ3Qn3KfgsgSxykySdV96AJ1qHplBzNZQO+3zD2u8dl
	v82GooVWin86oCpTcdlHkvkYehtX/LDR6Ept5xJHlvKw+Rt9SOPoAlXUZS1p1nl4vYSFVpZ9pyr
	UlKTyGK9rPVJ/wTLXyjxKTZERSS3qNyY6ltsPzicExL/ah0h07qw3QOBCF5yTkpy2mOHIp3hNe6
	43dD2k3xhGWmXzxfSvbGAr64ZJYIbuJ5iRkNrT10LEKFK5LcjGq2+rod8eZ6PIhOAawk8AOYU1z
	nRDlkw6jwTl4znNFApGD+XI1mkYMBCBOkFUoeENvwkGtXmSwEUA1BZmY+OG5Tkyn4JhpqiiIiKG
	J/z/Q7eYJ/yJtbR+7yLJBy03nPN8Ia8CJUCFzhL4j5F5D7nmHr24Dhi9Hp3h4EUt+n0KVK48myS
	sbYBZ5flQztU9KuESMxg==
X-Google-Smtp-Source: AGHT+IE0qvn0lpqX25l+3cOwT3j9bj2TKFinqvBV0K6OyVVKM3QLpi3xCHtF0y/H1wsrzDBxclGbMw==
X-Received: by 2002:a17:903:41c9:b0:249:147:95bb with SMTP id d9443c01a7336-249448de13fmr29396525ad.13.1756572010388;
        Sat, 30 Aug 2025 09:40:10 -0700 (PDT)
Received: from server.. ([103.251.57.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24903702396sm56975555ad.14.2025.08.30.09.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Aug 2025 09:40:09 -0700 (PDT)
From: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
To: reddybalavignesh9979@gmail.com,
	akpm@linux-foundation.org,
	richard.weiyang@gmail.com
Cc: Liam.Howlett@oracle.com,
	davem@davemloft.net,
	david@redhat.com,
	edumazet@google.com,
	gnoack@google.com,
	horms@kernel.org,
	kuba@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	mic@digikod.net,
	ming.lei@redhat.com,
	pabeni@redhat.com,
	rppt@kernel.org,
	shuah@kernel.org,
	skhan@linuxfoundation.org,
	surenb@google.com,
	vbabka@suse.cz
Subject: [PATCH v2 1/2] selftests: Centralize include path for kselftest.h and kselftest_harness.h
Date: Sat, 30 Aug 2025 22:09:48 +0530
Message-ID: <20250830163949.20952-2-reddybalavignesh9979@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250830163949.20952-1-reddybalavignesh9979@gmail.com>
References: <20250827144733.82277-1-reddybalavignesh9979@gmail.com>
 <20250830163949.20952-1-reddybalavignesh9979@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9A4EAA0010
X-Stat-Signature: qww9fjsxcoqg8ahatb7bwzat3ojbgya4
X-Rspam-User: 
X-HE-Tag: 1756572011-513944
X-HE-Meta: U2FsdGVkX1/LdB3W2amIfT15h6GrsV2U5BdUxYbkLHVPpv67GhQSaPec/hT/z9AR+JOMeVXR5kLBEm3JxAzbd8V6KXVdizZYVA6njDddcVJTanc8JpXnXYMxmxEYBO4hi6fQJG9v3ay1dGzu1+6nqU/uROvzSRfKJm0agwDPOLeO4zVllF+XHd1KHzu3TcRqAPy9PuCxMlI9hUWX71LU8ka9y0irl9dbl81D7bg/5sSYqriX6pQsUODKmrRicZS5fBM6VTsN34RqJQ/P/1XjDs/o8Eb7TZmElds21I1jE7b241B/ioORlqnll4/f+x9CEY5OUbYgzh3qGCYwznNSGaYrCdHpw1Qr6FctajzZOpDqL4tJnqbzl97JtVGz3gZoILWfkq8y9hFXIvoN1yZ7i8zkXf9qqTJTt1UrqWo0GCZEkKLcjnD/x8WUW3ZwDhgKRgoPlTAOeC05Xn8mG1pBGniaBZSUZZprn2J9C5zzUSNbMDeq7JiRSAvBBZ8GRVT4dPPjluWbo3e0k4OzhoR7XlvgemEDJIlrkjW5EsE/HB6G4xpREHSfoP7VgwbsDlBv5tE/5Iw8ozeEa/bN1+nMXTl2VpxFdnT53G+mW13Zvd/qPdrHW3Cf5SsZKXUaVv1+vl9ksdBpCzCo92n+Pi+0cLDiK8iADFSyOLff+U1+5qH+HmMaOZojMbOaKlOs2iQHo+cSFQVMzAxuNqS0EzJOn+uVGtViNaquKSOASMnEv8UmPmGq9FBnM+8AfmBiGCIq0eFgnUd+M9wbnH3DQUVXZinqVW9bBOYSFVaiqFFja41Vibag7BWcSxIWxP7Iv13QbjP+LDFmnn6nNBgx89HAz7fyDIQDN2CijntNIpPOST2h2TqMPCllSmpZof8B6HYPIzanD4D8IoWxn056vQpi0nEjwcVmyn4knmhlmkslaI87ITPPQSw4YnI3ZsRexgRrw6IT8UgXkwYRmQY15g9
 zaD9SchZ
 V8ChdYMAmuIxDoUCzjreSUD1kVa7TzLSMxh1i8TNVv7+WM69v1XsGUiZOy27pixymVMpZwrdN8FTpBAepZm7XOCFHQzUOG0DOaoT0MiI5Wu+QqFOZtaF06vDfMPQEbT6TkPFp0Mrb2sQXwWK8klL8UA85warMeIHGYuYvw7nelThnB4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add compile flag in lib.mk, to include the selftest/
directory while building.

Suggested-by: Wei Yang <richard.weiyang@gmail.com>

Signed-off-by: Bala-Vignesh-Reddy <reddybalavignesh9979@gmail.com>
---
 tools/testing/selftests/lib.mk | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 530390033929..975840bb5477 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -199,6 +199,8 @@ clean: $(if $(TEST_GEN_MODS_DIR),clean_mods_dir)
 # Build with _GNU_SOURCE by default
 CFLAGS += -D_GNU_SOURCE=
 
+CFLAGS += -I${top_srcdir}/tools/testing/selftests
+
 # Enables to extend CFLAGS and LDFLAGS from command line, e.g.
 # make USERCFLAGS=-Werror USERLDFLAGS=-static
 CFLAGS += $(USERCFLAGS)
-- 
2.43.0


