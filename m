Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6210DCAC59A
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B072C8E0019; Tue, 16 Sep 2025 05:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8FA48E0001; Tue, 16 Sep 2025 05:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894A18E0019; Tue, 16 Sep 2025 05:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5608E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AA571A0903
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:34 +0000 (UTC)
X-FDA: 83894520108.26.1EA0B1B
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 507F08000F
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNMtmfmD;
	spf=pass (imf02.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dn/O6EVQArdDsuUvojtCYkGjh1nRaP/fdtC5qzIrIQ0=;
	b=8huRT9MNfpBAKQaPh2cSLXn0/N3IEi5c3JSsGIOmnLUN6RdgLWXmd3FliIPOLkeI76TVfk
	f0DCnTwLvFSnTGfuSxkD9YwW3vijzBkWcFy0tHlsfjnxLuUereLIP9ncvZtUe0+ZvUCo7/
	WZlxAEXhVhTuKvRH2VSfg/HVTpOtr+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013292; a=rsa-sha256;
	cv=none;
	b=RSNKeLG4ig8U7mLMBKf27yKvOjFT0dW/HnfT8peZjzyzt+psTplQx5TznaqYhjeaEFHH7G
	kfrnfCiNcz/fewjY7S/K1L8Ir361O7OLbEgxCckhUywKGJN84LK80A1nvm1zt6BAdiEywg
	/I4vIP6S7PoLO57z1HRyTxijV0A7rGM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NNMtmfmD;
	spf=pass (imf02.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45dcff2f313so31922685e9.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013291; x=1758618091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dn/O6EVQArdDsuUvojtCYkGjh1nRaP/fdtC5qzIrIQ0=;
        b=NNMtmfmDnyBZM/vuge1BiJgzKxc9NvGFGfkSWJnooLam5PqOOd8RXZO6MgeOwaBjqi
         oSClHeoi7GDTDufGmULb+98ZUtQQ8DKDU+qZPyv11LeHtgK59Soa2B0VMfwW459V5Zs+
         419FpsVl0wK/xz9cAf3UVgjeriF/zjlXrqFzYcQkLhsX1xLZHDMF86N8zJ59c/+iupAJ
         Yy9X37f7HPhx+f2Lbd05sXmY8SLivvjDud1UlY9xFZTE0+0tPD6xjmqoUIvYpx7GtPks
         P1qfo12k2OxwjtXrzxRy7kG99e+jhBldQyHl3qlZa24ZXKUnNjiLmnuzgBRIwfTfZFWp
         NEjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013291; x=1758618091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Dn/O6EVQArdDsuUvojtCYkGjh1nRaP/fdtC5qzIrIQ0=;
        b=hRPXaO6HH4phMfmNRCHp96A1yw2jPPh9EJN9M9yXzl5e30YM+rcVejKaPK2kuK498U
         SSD+yFD+zqgOacEyrPM+NR9sOBexVDq0TdOr942iXUiE3JqFjVCm5b/eLjBO4PFTl9mX
         jyI4HpMs+qPmprhb9FPf5l6cE5/F70ojPyWhJsgr9PnVrwWK1wZR8iyRe9OAy+UAicV8
         LcKB+ysRcxdE0JpuW9GYHkXbJceNkUrdgG1G6onowalp9PHCKwpLEUmn7OS98PQgmn/X
         q01U63NE4eRECtI/G8j6u5qs039BeQpgdxOpCwwE0rUzoH9EfeQh7y6gANU+mGlomM9D
         bfsg==
X-Forwarded-Encrypted: i=1; AJvYcCVPZ73hJwVisArvQuS/NG6VQiEC10wOMjD0NiJGjwsOoFOBdoOJwaexzqZyhilMxuvq9E6tOeXOHQ==@kvack.org
X-Gm-Message-State: AOJu0YxDk085yz1lv628VfCcWoHcZ5a3gtBrTTwhA92gc3Ja9zVm5rXE
	3+MsHHwk6g5LAecZYeL2PRMqAnCgFebVsyU4J/QIOGNo6vnSL3211sWx
X-Gm-Gg: ASbGncvhq7ufO1uXWeCoBuqs60iq2axLXV56fYs9r6olyYveIDG4z6zrYK2byTzp2o3
	8GLIDr+PieIIqV4P31r7IsqIcDU9pDUzpQQNJGc2IYTIHdH5P8XxW0ZYeoUPdDhVSWmVPsjhV+V
	qBM6q6wTnynskLJaKmKdoL6joIF2Mzdq4738GrK2BgTYgHp6jT5IXDOLGMCpZogi+0KjLGHgq1I
	q2986tplqi1nijhDmJegb/dble5Y5x6vLtRcFOIkOfZh9sQYujbD6KYiUDmPQEqayZ1LADgexnC
	xCD2t2GpHXR9kxRkDhffUbujQxBurwxW6+YIKRvBu08Vac3iIrbaR6Ny2MWTQND999mKdx/S6vf
	Qok5i+ZysATgKGlEqUBDL9fbGIW/O5Tcht2uVhluERfLfoimgkj2O4VZBBYPMtysCrCRqeBZRbh
	zsO4F2aaC+E0R0
X-Google-Smtp-Source: AGHT+IHITqnIEWy8SR8VOuG/NaO5QPHcpXy3zWJ0Y1P3XtsNJD2TrXAHW1mpeJ/+27n2bIwqaq7a+A==
X-Received: by 2002:a05:600c:a0b:b0:45b:74fc:d6ec with SMTP id 5b1f17b1804b1-45f211ca9dbmr161791435e9.8.1758013290736;
        Tue, 16 Sep 2025 02:01:30 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:29 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v1 10/10] MAINTAINERS: add maintainer information for KFuzzTest
Date: Tue, 16 Sep 2025 09:01:09 +0000
Message-ID: <20250916090109.91132-11-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
In-Reply-To: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
References: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 507F08000F
X-Stat-Signature: 3ouhcjft8zh4jjfodwznwhy41a3p8kam
X-Rspam-User: 
X-HE-Tag: 1758013292-113629
X-HE-Meta: U2FsdGVkX19eeu+n/NwQARKYLLW8HTincFpemQe+MpljEOW8rmDaenIKIZ27bSrz8ZbzZTgCnKdQkpa8H1WUxghLkp1kyGnfvj/3dpXF+wuxIroBQkObJQ86RDoTfTTJACGl7z+RkWUjj3mUyX3bK7uF6T1ZakdnqVqAPK1uME2OazS/Vfzkeq0FaiWdJ7MhoJ2BGDb9HSW2/8vGvlRrw/RFC2xy6NkJaeyFrlK4VRnwVggfhoCccwgNQK36ci1/NxfQm0rAKwtP+sjZpltGlisKrSKaL6kdvl2MtI4ABkBsAhvTwRJ90uzGLSwF6CMP45ku/eciTQVHkeZQo0kqXQWZ6zkOoqfIjhrFNMQ4y3yoqY3573Qehd9340DOnASZlmZAMsl5pdJki89tU9FiwNVnoxvzest3IBVW50DrTHp9uTpzataeeY9trTVzIOrzwDojZMoWDKPd4p2zZgonwxuTNPJphGmaXq12yLTnILJh2yPnISx/13pCRVkcPQ4sxUOVWunwf/uRdaSG5iNKcTofOJm6BsODFSM376DDE1GGRnklji3NZocJmSnt9/NV0ppDEOu/y1E/76ijAyc7FEfzHmErMFLJgleWwljmtzz5cnJz8j/BNDhXhrsmcOFDv2rpgoYwjWw9wmfBoem400Tf3qIAzB0ZAePnepsgI+1cSsxO+BzRynWorszCCo5F0A4IPHvLPG2rv5IFNbzNVv4o+NXIXctzRAmfF8cnkYxoHrj6tPuI88LJc4rv0ylzNWt8F3fdQ8u5JIDXJVWtITP1/C7UKP+1FgzjoSG+lUEg/K8WWazC6DlLLmffxV84s/NgIVkbKWbFecjDChR9F9XkiGl227DgFiDdFlr6/x0MjCpROdJcrHODQC7xnfoDF7scwDS11sM1df6s+uf10eQARAvUG5tfpt6LZDQJqKv4LQAfaOKgEg5x07dqI+LKjUd9BraECEtJY76t41I
 qdKiq+80
 2c5Wfr2ixgC+Obhe7HNLxaGiSWMIWKsApQQtIIQD89Zp9OqIcpmTc1iaWNGWrvprrY0a9c/HGeoDgkklbsUBIVBNZUMnRdbUaC7aQtUfR6yTgUZz8qkpnlqgQxiCsxiKlCJO5drNyQrVx1YjV0vkSYWXV8By+xyXkxL+KA78CANTScS2DssH1LM8JMneNxFeJ5CGQgQNvoAAzG/mNuRJkokNyJPmpr3GMDQADveNZtTdWj+jVQ22kLVP4HffC7xFaFF5FfRmjJUqvlf0EvCDwZ8X2GWEXr/RdsMufeOXmqqset4U6mSX1Z1ZMhp/2nwE2g6ZW6x/fPGLEx0CNe5TU6siaM+EZW5679OGMzK8t4FvsUZR4bayQZoY/yo7YMdX9Pds0gj7dm/gxB4xy7ACo2ldKgAhJOJgi3FEYNIs0QpHXX9lqjNSfDrgrYi4m++Bf3ILU2F9N6Vd6upNrrSWF/M+z6spxdLpNZid4FoLy3Crtp4guo2yAAYVnvxdorTJzYEWfh1Iw5lPwgj94POzr+gxmXaxsDZ3zrucBwjrsKY0KW56us8pR4fXOJ6pWP0AUAeS6KQ9EthIs2QE3n+Jikq4nLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Add myself as maintainer and Alexander Potapenko as reviewer for
KFuzzTest.
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 6dcfbd11efef..14972e3e9d6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13641,6 +13641,14 @@ F:	include/linux/kfifo.h
 F:	lib/kfifo.c
 F:	samples/kfifo/
 
+KFUZZTEST
+M:  Ethan Graham <ethan.w.s.graham@gmail.com>
+R:  Alexander Potapenko <glider@google.com>
+F:  include/linux/kfuzztest.h
+F:  lib/kfuzztest/
+F:  Documentation/dev-tools/kfuzztest.rst
+F:  tools/kfuzztest-bridge/
+
 KGDB / KDB /debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
 M:	Daniel Thompson <danielt@kernel.org>
-- 
2.51.0.384.g4c02a37b29-goog


