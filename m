Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D31A0CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117276B0005; Tue, 26 May 2026 23:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C1BF6B008A; Tue, 26 May 2026 23:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2516B008C; Tue, 26 May 2026 23:56:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D88FF6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:56:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 589E2A047D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:22 +0000 (UTC)
X-FDA: 84811837404.29.0FC48C6
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F3354000C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:56:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TSpL2QII;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779854180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RxMDxUFcPbBPwBEt4PBCTfJq2IW5Ah8RnYDYNKcrQ98=;
	b=DS5BPT3DM2lxaVpWYmAQlQt5PkRjtEgxq572qfcl7YpatVdij/Sxp1DJ2OHA2pheYpjaPl
	7frRmRxMamVl0pizxVMPuHX9nRJXKsZoqrIA+nuuvMazBy0nYYD/mV+ppcLy26pFtZ8e4Z
	YAPwQBx2LZl93Ol0/8sbCKHrJNzEBAE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TSpL2QII;
	spf=pass (imf07.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779854180; a=rsa-sha256;
	cv=none;
	b=3B8ico8sencLjMcNi0VSpFOhrhOzH0+r+ToIr/WBs4G9RXdmoQkDBPC1JE9pN/J0IjWOw5
	MSJP8fXkLoFM0MuFniGe/uO4xbJSskiMCs2/c9hv2pquZ9TiHcYIYFsDW9RCmqQTPzTD/o
	87DyjM5QZnNS7eQBDlldDsV+QkMn3dA=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-368889be63aso842652a91.3
        for <linux-mm@kvack.org>; Tue, 26 May 2026 20:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779854179; x=1780458979; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RxMDxUFcPbBPwBEt4PBCTfJq2IW5Ah8RnYDYNKcrQ98=;
        b=TSpL2QIITsmm08fowKENbpAhEUoL3/JMBbv0Mpz2CtMVCZX/Syj17qONENLaLEuv74
         oNjNG0DbJt46iO6BS1VdI07SuwQa+P8XpvG7/yE8lRRF/ie2odR/c+PYQAQIm/H1FFfy
         VROVvzgvYNPoQIt4QonQTofLeBsf9J8LedNJ1FiKoSTs/o3B5b7hrgMji2Vy6SMh30p6
         q6XUdbE/2mEKNHcieRSbX8JoVLBbSMPD/V9l6mUPQrk4087Hmq38AJyIJzEo0OaBtl1y
         EDo5QvaWUr9UxlqD5ntur3x6sfTcWdDbpjnkUDdg7efn7fd/smEfnPdLyiCc8UDKtBoo
         Q/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779854179; x=1780458979;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RxMDxUFcPbBPwBEt4PBCTfJq2IW5Ah8RnYDYNKcrQ98=;
        b=RZvM1TTkmMUPyUHNVbmXWOag91nmKmLgnU+89FPgP50f5dE5C3nCYuusCe0R6wfsWz
         HOE85Dowglk+96p9iPFiUNU6j+3zqagWPcC6aqv/HZJ5chhT+cutOq2LmuEUmT6gHu0j
         xT4Zgji4CQS/xP7EZP2eLn57BsJmWYdjvqddDCi9GEOqb0H+n4i/OMTzi2n1bU4T4M4C
         RktOBdP1m/y5W+ANBorkwYzFD7ia139Uiz0M6gw8siIkMNNMYTyHWdpSUL1XZFuL3pbn
         m1EH+KkE4LHzIghmEJ5mH4/NOl2rpebfbWrpfWHA7m1ChceKN8ARIQzNwmmgbKNjPltK
         ADUQ==
X-Forwarded-Encrypted: i=1; AFNElJ+yojtc0d/UUlLfZGjvw3dlSvRU7AtWShGmmPxVSinDC4mIv7K+tFrTAeckHHvrzxLEeQxalgct7A==@kvack.org
X-Gm-Message-State: AOJu0YybYDlyf6PQpDATOjXU4HPypZb6JU3IZ0wER4pwZSanOUQRU0gy
	BtPimT6rE11d81aT8OKGCsAw3UfVmVyWzoz2Ti/8PgN5VW6cThAvT2U+
X-Gm-Gg: Acq92OE9bseoCZ3FdmJGQS+KpBunckvn8fKQM2vVIbfhb5bUi2pQP8Ee4t7Pxiai05a
	TVryRT1rPaKCICyzMoCE/X18TNVgJzRu8WW8a9oHLf4PjivrUG2HfxdghJdIdTw2QTmx1JcNsB8
	9TGovv3YvW4eNgNAgzyaNdBHBFn8OWDzZl+qieCRhAR6wASteC53tkTAheRYA7nqkEN+ZqeizET
	aqUztS0d/hGRToNR0OL7ZKIRwyJ4LvkFx8GndigAtDWDm+55jDXVT9aoM6iEl7Kzo18j21mWpac
	fmBpWZtsPrZDuYLCOfNiWvtIxvP8VROz+9pnXFCuW0dhns+tECe9SE4UZZLYn817BgrbtXJ7FG5
	IcL+3mSG+NVTd32F6/ZNM6QCL/EJVfIeCEwBROowMpp9kbzgyo4fwineCEloF/rocxsWOGQRymR
	eOVqQ8nbnWLF8/4jul40MwEDzaumBDjUfnDlGGYiDPBXOE+xV2/dKmFnu7gNw8psOI2/3sqohK+
	jim6UyvasjGd0C65fKZcU5B9gD9mBgDozzXyA==
X-Received: by 2002:a05:6a21:3a85:b0:3a3:1814:20a2 with SMTP id adf61e73a8af0-3b328fa5bbemr10771158637.5.1779854178589;
        Tue, 26 May 2026 20:56:18 -0700 (PDT)
Received: from firefly-aio-3588q.. ([36.28.158.221])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-841d70f1ed8sm828385b3a.43.2026.05.26.20.56.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 20:56:18 -0700 (PDT)
From: Xueyuan chen <xueyuan.chen21@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	yang@os.amperecomputing.com,
	jannh@google.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [RFC PATCH 0/3] make persistent huge zero folio read-only
Date: Wed, 27 May 2026 11:56:04 +0800
Message-ID: <20260527035607.14919-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ymupfqh95r6j1kny4xnx77584cdynd4o
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3354000C
X-HE-Tag: 1779854180-529172
X-HE-Meta: U2FsdGVkX1+QlrJH/fWA8pqe37OUwo4cMGKSM4bvTh+ZVZkNBDt8ZBst81STcTaU4KA03NKKHWvlGqB7rpfeyJPYaFmVPbtlaFu7dCTpkNaUuLEY4VirFi2ic/Pi4z5VhOKQ2LQcciKNnBrgUltYYSOgc9obfONOLY9IkV6ovgpLCKkr1kR3QsU0g5phD7GP7t75z1P+hmokzHuURxLPMVog3IIs4Af8O44f2AqvHZRNrfHbGD0rvKkMZTRCHIxlZzX80CAc0rT55CWRxnyOtSt+BL9fwcgB4tK662j1ebhMPLCo0ICDXnJS5am1uGlf7Fjp18+SgP8sBiICq+qhOBs/FKn+Ch/KTQMWdpBNMvXj4pouQ5Dob0F6Ha2u7R+8SLLrPWV7NvmuNMAhG8rD0IEpQtuKEPwGLfxWeHWQDEbmqfBAb9YrXRS5xESSf0eVrISv6Aba3iEaHxNMhoMOczUkuolTR8cGWe4CjFVaDyMf6JFd+J6AWJKdDPEEgX6M/T6WPvhVkT0n5L2j7UG4mTnPQgnSRRu2xJT5+Zw9XU3GPlP39PjekMRlVdmyoxwrCuRmwcxTILdAZ6XWtR/OSo/+XEb1RLSm0+bkHnXfVw+/P0EFVkLzp1FiAFjHVt4hMo5hIqKeO1Gf8GZVABtvefVpk0HnoegwsZ5GMtQ9kqGcS8g/ZUuTAxDk2/I/R9SEJ0TqxrYO4uMLgla4U/EXuzyUT7j6Bpr9SX6iuFEjjUorRNjTMMlnbvkEcrQAVGBEw22tRST/QWOtmBFAhHC+Fjurqg+xW+4Je01xvO+7dcqVhBg5+ggedyCmg7ZkejwvtROmjk6CFKsqSr+2OjbQKfIoGqBeoilJekUtpm508ZTj/NxTl3q4fBX3CpEbHtYvETVz1BdYlPGhxJ2pAreF7Bm3PiEtcMYYyUgWYyrD6r48OgMYJ6qSC8WdmJcus7arjUvbyniwUu8F5rdqv4s
 iTQRMfTS
 q1C1zXydPco+WLRPEc+AUxEMic0X2vlnkzA+jO3ycHqSv/+KNYR2SEbK5LFCjg9SzRWtILyT7Ji1GP+7iZ6qEqMsYf18zYxVjHPN8+gNsity43cAKW0AkNdPp0xXuR/v2agPch5g75cJTdhI5SCapaLW8FJPWBA4dy4rf/2xXcMakilOglLrxi/chQalq22Qh8D8VWY45ghYRmkspXEi2pPh4j5hkJhfxvY7TZXXY8xC7/BBffZSD2B7m/39eSjN0oY0WEYEhkPp2h2E1KRi5cIyeEHCk4+Klq5m2wk9Nr1kgnAz74yGcuPTMrE2KTYsYLL2wLgstC0uIYePSoP6pWNAXNibJD03euRyMHazhCMpAvscqtOlw74FjgdFyf1gPyFAAcAuEE67klSOEjlgm6TPwzN7ZSm36WioAgK3UY97SpOiBgyCoKloIwsa0ZSkuuv0+Nr4oqZ3ezYQXZm9yPl/eb/WqwuL+fg9sclLTjiYoBr6ZnXbCTkeZ8fSuyAIKDdg+7LhJdeAjeuI8mryJk/KETJ6SnFBVbY4/yOTiOLq7settNqCWioMdXkno71xqDUUPcZG4+A4s6+WZsn/pgfZGLtr6wyfe3kBjQZolJaxEMGo+MviPaYijPraRJ7Hzyqzl97UicC8itKp+tsJ4pRAum4CJv/A9b+Eyqa76nXIEKbcRJHztfbt5bYllpFhFPvqbGFy2nF/NAQtPmxdknrfPCVu6StZB4aTR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Xueyuan Chen <xueyuan.chen21@gmail.com>

Hi all,

This series makes the persistent huge zero folio read-only in the direct
map.

The motivation comes from Jann Horn's read-only zero page work[1] and the
follow-up discussion[2] with Yang Shi. As Jann pointed out, the kernel has
had bugs, including security bugs, where pages taken with read-only
semantics were later written to. For the huge zero folio, making the direct
map read-only turns such writes into faults instead of silently corrupting
shared zero contents.

The permission change is best effort. If the architecture cannot safely
make the direct map read-only, the kernel keeps using the writable
persistent huge zero folio.

Patch 1 adds the generic support for making the persistent huge zero folio
read-only. Patches 2 and 3 add arm64 and x86 support.

[1] https://lore.kernel.org/linux-mm/20260508-ro-zeropage-v1-1-9808abc20b49@google.com/
[2] https://lore.kernel.org/linux-mm/CAHbLzkrXXe7r3n3jXgDKtwZhRqj=jDx9E6dLOULohnhBguvi9A@mail.gmail.com/

Xueyuan Chen (3):
  mm: make persistent huge zero folio read-only
  arm64/mm: make huge zero folio read-only in linear map
  x86/mm: make huge zero folio read-only in direct map

 arch/arm64/Kconfig       |  1 +
 arch/arm64/mm/pageattr.c | 16 ++++++++++++++++
 arch/x86/Kconfig         |  1 +
 arch/x86/mm/init.c       | 11 +++++++++++
 include/linux/huge_mm.h  |  5 +++++
 mm/Kconfig               | 17 +++++++++++++++++
 mm/huge_memory.c         | 25 ++++++++++++++++++++++++-
 7 files changed, 75 insertions(+), 1 deletion(-)

-- 
2.47.3


