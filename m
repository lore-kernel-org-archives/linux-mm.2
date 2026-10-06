Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADD5CA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 06:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1756B0092; Tue,  6 Oct 2026 02:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 580E56B0093; Tue,  6 Oct 2026 02:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 496B76B0095; Tue,  6 Oct 2026 02:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26F4F6B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 02:17:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92617A053B
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:07 +0000 (UTC)
X-FDA: 85291193694.05.B552D64
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id C46EB40004
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 06:17:05 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bF4zpql5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791267425;
	b=vJ7HUbQRl8bp10vS0ZXbQ3TYk3g32ctBq1ZQtpkqSN8P6Zfk5gfHs5ix2GHUIpExKH/PCv
	dxJRggTZro6dTLOtYxk6ZPsXnIbn/781/yNmF/coYEwHQzWUpqWWEmvrenQMe6qpxlGC4B
	yT6qSQclXOKNWMpYJr/cswEsE5bOvfA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bF4zpql5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of adrianhuang0701@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=adrianhuang0701@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791267425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3jlBcrEL7AxGWXF4qOYzXsJylUauI2sPDbkv+5OBUgw=;
	b=JwZ8OKbsegFu9kjQYsJ/cKEjeXQkyi6qAkzHqEP/1K0vCX8tQLzC/nb+IJaKoQD72Q2nAI
	04vUDGtU+LlBFEGPHDibj53ixzPpmuZJfeUDBB8fRK0lErmsYOJ5bVvAGrtQPqXPTNIySK
	99YPykf53N1bCdU2lPGO98jABEO5HBw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc4e9e56e9aso92917a12.2
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 23:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791267424; x=1791872224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3jlBcrEL7AxGWXF4qOYzXsJylUauI2sPDbkv+5OBUgw=;
        b=bF4zpql5jia5vNmEtAnjpwt0XX8d2USRhTgeCD0hBq8wCGGINLvqgI1Dzx6Egu56bD
         ep+9Z62rfEr8FThDtoUSIqyh9G9cKMgYnFmQCONBIlkFDmm5k7KdsIRYdGLb+upYQltW
         lCwy8gP4SBH1hzreqJEZNEj+DWae2kTyaVXWARsG0BsIBhWAVaENdCIPfHTiI3FWdvuc
         F7dQLjayrxjMVLJOwCupn0Ywm/aW4YbbR2BfUJxfWdTFJspkP1nd9e5PNQkkGfcBtPmF
         CqDN+OPoqay9ZDc0LNWnBo5rQM2KGdIJXgPIIxvOPz9rtdWx3gtZ+cneLOQeU6RkmY2K
         5qFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791267424; x=1791872224;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3jlBcrEL7AxGWXF4qOYzXsJylUauI2sPDbkv+5OBUgw=;
        b=evQWV0ZV5JkhM7yrBqhoDcMcH3wORJHBKd+8YfvIxS9z9ElLe6ZERRueHqaiIwYe0y
         1sGPl0LC5RHol/MWkG/cJJ9viIuovYLl+sHn5kYQkssa3E6HpSiv+wVZpFTvQhmZBw+a
         B5kXbKNybBw0O0KAzuBSacpAlyrkdlTSEKhttI6v8LW7DUGsLrJsDewIxQxEafgTg4Fb
         rKD/lf4vJfWM5dHqSVC+ITSQW6/NmBD6Iub5FVi0exMPb2SNsta/9wNINh7AY8KVUMmk
         RHuqeTmpO+p1TEjydoDzH8beeYP3iOhc4c6+Hg1v2A4e9mZ6or9lEykb43qP7JgQG0Cy
         wiLg==
X-Forwarded-Encrypted: i=1; AKwUvBz3FYQgby4YrDbHPZJoYraD8EnfSokUBvOoKF94JZ24cICd+SjCbD5mGid7v50MWqAb1iy4W0Bz9g==@kvack.org
X-Gm-Message-State: AFq9FYI683eRvvv7eLodfHbK2LuEcdrd9BsKSVHYxZ4cIi4xYJ1zOhdB
	K6zvqUch/GCAiaIFlx8u+TnFx/FC6IqlQ+HZztvDkAFvVt/cbWFB3p3/
X-Gm-Gg: AYBFou1htwW+VIaIezVsglM5kj9EcSEEkzEbEZEfIDJpZBUgmJw8gQqb62LjSoQXgn7
	OSzt9lN4Voy2g2GxABKvjJMQ5V8uDeath21MOd3X5RP5w5ImJFNR5ThYpdyq0O8O1W76ug+VwTo
	B9uYaKUTlNycA+9UWzcf/j9RsaRb+KYYFxk3mEh1LBmx6+Hb3tg0V0VCX3UgX7t+NW72D1ISf3m
	rl7DFUksRcSWFt8+wuCfqjnCIrOdRGWBQJBxNDxkmf9odrTcTPXOuriRWOCpgk2VI6iob5aEu35
	jbBCYVfrD5hxf4GGUWrNFybNb5xiAdgQoIKL/KLvlAnbBFGbx9i6JXLMYkIEgYzX4X8nn5PCNay
	c7fhZSVjAIJAZQ7XOk0NILK0NzIJR+vA7wHq3k1blcf3vc1TALYm1QjJj2e4sIG3qJodQCg4442
	YG5XXH4oOTFgV6iOKa3QZbrHadT4x7cuMVyHBPn9oqUeg5GRpnKPyjaVqod51aT3SYCbVzNiZKu
	YKXMatcFT9ozVJeyyeVim8Rang5SXgISU1VvS07URfmthbVU/iSrGwHzmHIiTfPgetfpetYDE/m
	SGoKKu+TO7YzUVq2
X-Received: by 2002:a17:90b:4a47:b0:3a0:9640:8043 with SMTP id 98e67ed59e1d1-3a873517b39mr304141a91.15.1791267424571;
        Mon, 05 Oct 2026 23:17:04 -0700 (PDT)
Received: from AHUANG12-3ZHH9X.lenovo.com (61-221-208-111.hinet-ip.hinet.net. [61.221.208.111])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8533aba95sm3662789a91.2.2026.10.05.23.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 23:17:03 -0700 (PDT)
From: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
To: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	ahuang12@lenovo.com,
	"Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Subject: [PATCH 0/3] Docs/admin-guide/mm/damon: Minor fixes
Date: Tue,  6 Oct 2026 14:15:46 +0800
Message-Id: <20261006061549.627-1-adrianhuang0701@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wuhk5xbfpxjpcozu7rn8mq8kkgxxhccg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C46EB40004
X-HE-Tag: 1791267425-650253
X-HE-Meta: U2FsdGVkX1/ijiVOa0pEy/eKgeInVyZSkkNJmjRo+OGrQLHKYzGJtzwqu4CS9qBUp4FtC8gbYx4qU32dFR+OExCEzoilK3z3TOo9XU5jNljLSE1FiAS70h4m0feWNiWuqZk6Eh8Sl9iXSGlRqv/6Ixx4QcMmJLkMqv4ZRUKpEAb1O+ok2kC43On1MH2FcJvM7IGEiwfuuP4LgNohmt3BawB77wHGeHgcqa55FXZEaJfkI9jYByieYKiEeujIahU2SEqvfT7NFdPm90H/cZl37fE0g9oFYoyDTCEecfKYfp2OGaeQD0Gy5QK7oKaGR4wJvsUe6qcmEgqnJ96IS3FN2vnwi2KnDk/ApZMZZjsEGg/kRVjsYkNT8aGHyA6L9QqPbV7tlYWKzDNJbT1RAVrCQI0Qc9wSsut0Vad+wAYhgpB6kN2/9fCwro7F5mnv/jvoNr3OrnfT7SB6rWQTkFtQRBM6apQ2S5an+w94fsfgTFbaf9tmAGW0QI5RI24sS+1SPVxxVFQQxogqirLUq+FANvA+JQTt0lUafbahl/Z4W11vxUVnCjfeet+M4JIaVjGlR4cgw6zvRojYqDOG/S7ky4B8auBJwJniUkkzFsWJ6UrocIclXt32gsN3jN3kaI9cTx5+2omMpGuU9kboLuUpbjE2JMogKq0Oq/IM74bfcI0wBz2thqFHKob1FblXRa4fbti2A5gb82QPiPrYgBWL9iS4Y9sCfVbQIrJj32KNo6M+knOM0VzL2cpZfJKLIXjcagbGHWvcUET2n3whT4gC/P5KFjy9uf/wkgX/lu86CfYoSPlDwPmtare3vx2mJfqLUfyEPkenmVxeYqGFiiH5Zr5TLLFFV9CQJcitvR/mGCHlSMi/6l245LXmdI4pG64NAdb+N2nXc41agnSTraraiMKe/G50oqFOlewObPuR1YgPIXZxAR6t7XmBUO02WMWaIvvIEuXOMtOP4nPq+De
 fh8O2S8Y
 RvJKBlTGlv+EBaFpozCICxZRoiMATYaNWCgweq5yXEmO9UMQhwFauZxdQlSkTUBC3GMTIkGv9DSaJyH5Y2tKD3A5cd9FonU1CJa/0XXeyAhbEVpYre8bFCglFUZH1SC6qjvyyhO6dVL8qa3tHQApWjBPIlwp1UsYzBG6WBMN0aEutvVQcd4lXSrp3ZwwiFzl9TdzvPycViFtDKzpfu0lTsbUiFeoKpwj/hI0UpdMre42N6tk4oKRELCXDKdAmIefoWR3rEu9M/OujyyozK+fpQd7zdsqXg561VD8+A5dNO6ZYi9Q5oyKyZyzYJjDoCSXQ9RH0lgxN+lxemJmh8qg5RLkzsaoKYdwcdl2EiG5KkqpustHgnCtUYRBvqeyUgTD7qRHmpRb9vBOTwRk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This small patch series fixes various typos, copy-paste mistakes, and an
incorrect command syntax in the DAMON documentation files.

Adrian Huang (Lenovo) (3):
  Docs/admin-guide/mm/damon: Fix various typos
  Docs/admin-guide/mm/damon/lru_sort: Fix copy-paste mistakes
  Docs/admin-guide/mm/damon/usage: Fix incorrect option syntax in perf
    example

 Documentation/admin-guide/mm/damon/lru_sort.rst | 6 +++---
 Documentation/admin-guide/mm/damon/reclaim.rst  | 4 ++--
 Documentation/admin-guide/mm/damon/start.rst    | 6 +++---
 Documentation/admin-guide/mm/damon/stat.rst     | 2 +-
 Documentation/admin-guide/mm/damon/usage.rst    | 2 +-
 5 files changed, 10 insertions(+), 10 deletions(-)

-- 
2.43.0


