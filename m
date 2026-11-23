Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0C7606A6A9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.a=rsa-sha256 header.s=2020 header.b=eVR3Ru4Y;
	dkim=pass header.d=linutronix.de header.i=@linutronix.de header.a=ed25519-sha256 header.s=2020e header.b=fb+iCiKk
Received: by kanga.kvack.org (Postfix)
	id CDE626B05B0; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60FF6B05BE; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54956B05C0; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F9A26B05BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:37:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F0631C420B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:30 +0000 (UTC)
X-FDA: 85465881060.06.08D756E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C085100006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:37:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eVR3Ru4Y;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fb+iCiKk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795426648;
	b=diW6tpvPGumkidQMCvsQ2IxG2CO46Y/WX1A5WVKBXtD8Tm6LipzNCcSTat2hlTGW/fy+p2
	n+xlnE1rbgqygB8ciUnwjbE3BJUW5+a/ZOmYfK6VSDtOcHkQAN5tfWVTvAZfWjsLFEPMjL
	GoUW42xHdgTCHBIMLbI9+m2phPEDUjw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795426648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=12rCIot4Q1y046Vzp8EdeFdJZwXEj1gxqogCrSz0YUU=;
	b=ojZr9+kJ8ZC/uUqUaiSAGPCgjA2qs0pTNLMbZWIBDaaMaRDB8KUvYe75BZXPQLcrXNoVCK
	qFZl366tsccVDzS1dEcM2D34r+Uvv/P+bWln5N5x99/KIRCe+eRQL3oYNWwi9ssrlBBADg
	rAcX+l9br4ErsDCGEViQGXtEdwiWim0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eVR3Ru4Y;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=fb+iCiKk;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf14.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1795426646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=12rCIot4Q1y046Vzp8EdeFdJZwXEj1gxqogCrSz0YUU=;
	b=eVR3Ru4YMLUxoE2oBeLnHegybGHZ1wA0UbD4tiFIxf5sSlq+p3wJdzZpk1ObDTCcQrza1z
	sy98hHXx+8xzinXaJ18cQFrVUiJIc/UcxxCx104dR5eQpHKjKHCYzESkf81Gf3OdfKYFU/
	eii4VqnD+bVQRxDevExQLyGum7btdJKvvpx3Yr5ardHDzDIHP6aGihnfy+77XqVSz6ZQgt
	47xh6w/Vwimk/bHTNf5kdhLgywTu1BYGw396QHdIBvHSpQXvrSULdDcD2Khd3VZ6kMCHkn
	cKpXfzLviy+wczOkqv+t1GeRU7hURAtZmDFbfCzTh8szA5wnR/Jki6meRytmbQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1795426646;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=12rCIot4Q1y046Vzp8EdeFdJZwXEj1gxqogCrSz0YUU=;
	b=fb+iCiKkolSfl3maExBNRcPmG1YtwmtD8FIgojBmtd/T7xWBvxDvLsmVcOv8h0gdh8FVpL
	vvdYhx+u/oAeYgDg==
Subject: [PATCH v3 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Date: Mon, 23 Nov 2026 10:37:05 +0100
Message-Id: <20261123-at-vector-size-arch-v3-0-d342dae9e843@linutronix.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23NQQ6CMBCF4auQrq2ZTiOCK+9hXJQylUlMMS02K
 OHuFly4kOU/yftmEpECUxSnYhKBEkfufQ69K4TtjL+R5Da3QMASFNTSDDKRHfogI79JmmA7WRI
 4pNq5qilFXj4COR5X9XLN3XHMg9f6JKnl+vU04KaXlARplHKgG4PWVOc7++cQes/jviWxmAl/T
 g1628HsHBqr0RwV6fbPmef5A6qlb4UCAQAA
X-Change-ID: 20260109-at-vector-size-arch-6e0f2e9ff8b6
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, 
 Paul Walmsley <pjw@kernel.org>, Andy Chiu <andybnac@gmail.com>, 
 Magnus Lindholm <linmag7@gmail.com>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795426640; l=3299;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=0K3qhqEWg64tqQPsXMhmXxkKgiRN0V2EEQPpHTYxv4A=;
 b=Fe8nQiRi3Kfc2ylHmmPvMPRVTTjkYlaqoKTjn4kvNkLesW4z62H7gN1D51+mJJRRBnWysks5K
 2YBQSucEVjaDRaSt/FqXQnlQcInw1lzhzM2T6nWBTe45/TAM3F1ehFZ
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4C085100006
X-Stat-Signature: yei4b1txd6mu1748ttmfp7tszex36prg
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795426648-51477
X-HE-Meta: U2FsdGVkX18ubAcW12aUXKjDN0gE9e/EoRQU4xaqzHdKwMXCjgvfP5DGLTzxenDkkg+Plvc539xZVW8R3MuQsA1ySyHFGNYOaT5yNbrtamn/kN80+m0+C09KcTp7z0csBQiI7xsMqxn1qnhUpnY9wM/cGKr3XBJuMkovU7QLaaHqRDbkTHI6KXmtO7B2QmlAEXe2wO5qk3rSkGT6vEdSLJ6lA8QDlCXYa4o+roI4tcoOhahDPalyDTJzUIDlUugJ3dH+XHrxwDpFSxO+nxMHKG5CqrxoW/FvGtjqJIRCZvtxuRrZlMBfkf15Mwhxk0fAuGYRklsc7R1FAjPG6sbxVy9BUh6Ck1S6bgnsFaP7omF7fE7nMVRV0rnt1CP3K3TfNIiuNvcoEfhqrgjhBtGI3ihJkR8/BQNxNsEIjHPrYD2IwX2YVX6DaUb3Ixite95a3XVTdc5WhswxachKeNUlNn7MewcVWlWiInYYp6ivnqOclLbHc4J8KoST5ikoYpca9/b47OGIzYfwA1oogfrzZ5vyUkUzj0h+8HGlwXVtRs0RvbtYVOGdu+ToVedEjJ2DURJ0dyXf+SW3pQNDCAj2TV5d2zUjX8fB018VsHGjJxCNIfjdYU3tAWjS7Cq7rRbw4c8EU9oyLVvZFGAVDJ8Uf8OLZpMZS0k6n7iN76JV7/VInE5GTnfCiANVyVe+PAMQpOXgBZZygQrsNRKyzWOYM2A2ly7CIF3Stbd5m29vDq67aTo8vp+S1kM1ta8Lv3SdM6shJZNyhlRPE/PkJpYdW7XevjVm7RByVhAxhEd6IYu2aMCMCAGpa5c0lVBi9a6589hmQx+0XG4nJaWeX4e9XRuONVsxxU0l6nYafNrQehRg2GYtXRjhf31a8oieMISk6Lt51m8lIJGp/lhJi49F5EKkMIYsJitoJ+gu9hJxm8T19dvsVyQ3EFlJVkc9UyiwTtjLMPLRyIjXiS+VkUY
 BIRBhfil
 VIPsq3iV7iAl+NsUiWYw8hxgrmnoWRQRTchxFOuT1VIJWK6FKaTl50pLKR2Ot1hUG9gFMlV7jRPYHctdVz2s3U4V17SWctmVzCa59wGkbg+fWKI01XjYWa/Aki0wNRjLtL5yuqBfKObogBlZ3k0CtV6k7mPuISox+ddRSLTsYqpr7TrxiT8ebv+s+jgd/HjlzDww0lKSOC7LXSFM/dR0nnGo6ThIa+Z6zIeqcI58PqFqR83AnV4DZyd3Xy2Yl19RxRCURZ7C5FLx65w6I5ZXXb/Tr3+YDul9a4iOD3Z0UWOq6qlL7uQidDvtvKA7NImPbhrXffSX1RqL0eFTRHRPzG09o5hRCOIBDwiJFHeJKjqGcnaOgORG0ej6whXCi5M6uJZEVMJ5MVFcq1LKUdS2BQKviYUJhvA6QcIqbNPVyXFhULS3xb6gQblT/1iV/hoku4ZkMy/XoznvpggVQxJG0es8fOJcDFVk+UU+7kE4VkkXz9CbwjCJwgRUjtnWcxYdFkCCjpiPXytkVzipndTeRh8HpF5h/C7mBu573CZ6QNxC8XFklmH8LO/9PYaeLRxluQJZEpiSmhlwjyveKUU8KsKh+ZZjNV7sPyMUZE8C/nR8WxK1Mj4qyU+CtLjW78jfqwti7vibZEkNYwGFarTA7TwJnHZyu79FE8r+882ZY/uiLw2DH0eSkmoZIA/4Or2el2d3NfAWKEYCtqzW8vT73DO+JuQU//bGOa47SBmx9pyQMOZIVmOTbtuxjSiaeVoOiKhVV/J93o+r2Qml1jEKQOzl7WA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to kernel-internal headers.

Meant to be applied through the asm-generic or execve tree.
The default recipient list was huge. I trimmed it to only the
architecture lists.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
Changes in v3:
- Rebase on v7.3-rc1.
- Fix some include guards.
- Link to v2: https://patch.msgid.link/20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de

Changes in v2:
- Rebase on v7.3-rc1.
- Pick up tags.
- Link to v1: https://lore.kernel.org/r/20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de

---
Thomas Weißschuh (15):
      MAINTAINERS: exec: Add more auxvec.h variants
      auxvec.h: Move AT_VECTOR_SIZE definitions to linux/auxvec.h
      asm-generic: add an in-kernel auxvec.h header
      ARM: drop custom asm/auxvec.h
      x86: Remove AT_VECTOR_SIZE_ARCH from UAPI
      arm64: Remove AT_VECTOR_SIZE_ARCH from UAPI
      RISC-V: Remove AT_VECTOR_SIZE_ARCH from UAPI
      LoongArch: Remove AT_VECTOR_SIZE_ARCH from UAPI
      s390: Remove AT_VECTOR_SIZE_ARCH from UAPI
      powerpc: Remove AT_VECTOR_SIZE_ARCH from UAPI
      MIPS: Remove AT_VECTOR_SIZE_ARCH from UAPI
      sparc: Remove AT_VECTOR_SIZE_ARCH from UAPI
      sh: Remove AT_VECTOR_SIZE_ARCH from UAPI
      alpha: remove AT_VECTOR_SIZE_ARCH from UAPI
      auxvec.h: Drop fallback AT_VECTOR_SIZE_ARCH

 MAINTAINERS                              |  5 +++++
 arch/alpha/include/asm/auxvec.h          |  7 +++++++
 arch/alpha/include/uapi/asm/auxvec.h     |  8 +++-----
 arch/arm/include/asm/auxvec.h            |  1 -
 arch/arm64/include/asm/auxvec.h          |  7 +++++++
 arch/arm64/include/uapi/asm/auxvec.h     |  6 ++----
 arch/loongarch/include/asm/auxvec.h      | 14 ++++++++++++++
 arch/loongarch/include/uapi/asm/auxvec.h |  8 +++-----
 arch/mips/include/asm/auxvec.h           | 17 +++++++++++++++++
 arch/mips/include/uapi/asm/auxvec.h      |  8 +++-----
 arch/powerpc/include/asm/auxvec.h        |  7 +++++++
 arch/powerpc/include/uapi/asm/auxvec.h   |  6 ++----
 arch/riscv/include/asm/auxvec.h          | 13 +++++++++++++
 arch/riscv/include/uapi/asm/auxvec.h     |  2 --
 arch/s390/include/asm/auxvec.h           |  7 +++++++
 arch/s390/include/uapi/asm/auxvec.h      |  6 ++----
 arch/sh/include/asm/auxvec.h             |  7 +++++++
 arch/sh/include/uapi/asm/auxvec.h        |  8 +++-----
 arch/sparc/include/asm/auxvec.h          |  6 ++++++
 arch/sparc/include/uapi/asm/auxvec.h     |  8 +++-----
 arch/x86/include/asm/auxvec.h            | 12 ++++++++++++
 arch/x86/include/uapi/asm/auxvec.h       | 13 +++----------
 include/asm-generic/Kbuild               |  1 +
 include/asm-generic/auxvec.h             |  7 +++++++
 include/linux/auxvec.h                   |  5 +++++
 include/linux/mm_types.h                 |  6 ------
 26 files changed, 139 insertions(+), 56 deletions(-)
---
base-commit: a6b4ba7acc23ac0fb680449981982f308ea75036
change-id: 20260109-at-vector-size-arch-6e0f2e9ff8b6

Best regards,
--  
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


