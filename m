Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 064DBCCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 10:05:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDCCD6B008A; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB5E6B0092; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0FB6B008C; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98AA76B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 06:05:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A17112025F
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:10 +0000 (UTC)
X-FDA: 85331685180.01.3901F2C
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F76A140006
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:05:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=UuKUJYUC;
	spf=pass (imf09.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792231508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yRhFdLBL4t8sg9K3bLI8rm4y+3N0uLfoGZpRMgEEt3g=;
	b=CJW1BIO8+pf91hN078ZoWZVnfqqHCIrytvV+sOwrjxbXIZfy7sqAKGMuFMIB6wi+Gcyqpu
	F1acdpCbYydcwSw/zjW7i6+l0ac4n4fceX2NU1UzHmvQHjWjERTvm6TEK9x9wNzmyEJjWf
	yPZWrFWJIzK6UQGKCxpxcCFJ5jLtz/Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=UuKUJYUC;
	spf=pass (imf09.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792231508;
	b=gJymBVppZFY72OtowfFRkW0iDxWlp/0MkjPj7gDFqnCen/D9JDRU2M6+M7SOFaAFjjekQ1
	JEhhIQ/WlaTKwN1xPfiqQOTSKlZB9X2HZ0GCq/sny5Q7d8X/dvocWzjNxWG/EI8IsHxnX1
	XRUHF/t4rpxsaYi44/BgSM2i1/BvDBU=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792231506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yRhFdLBL4t8sg9K3bLI8rm4y+3N0uLfoGZpRMgEEt3g=;
	b=UuKUJYUCnz1kmck6qfdZGwFxsrBF00gCwHJ1BFU1WVvodz6uT0e/v/1jXfn8doksv3Mor8
	0cSWrsXT2AgoxZ7tZEqZEsZr6UTJZLo/N8GB8Pzt2DnSznmYiPsDjqtsY6ZYRPoCewGF2/
	kzfogMZoA+Yws/vpgXkg2KXQjqJJB10=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH 0/2] sparc64: Randomize mmap base and PIE executables
Date: Sat, 17 Oct 2026 12:04:49 +0200
Message-ID: <20261017100451.2266781-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: copokc3jczetrgkc8rz6iockjgn9km3p
X-Rspamd-Queue-Id: 8F76A140006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792231508-183013
X-HE-Meta: U2FsdGVkX19aP3uHlre5+1nr0s3lbd81L9FxcxfDtttlHvOSuQW3PMBPZb9p8R0KByL/WsR+RwQmBdgz0fe8aK9dBPBK9pGL6ugXdl99iJBVnUEjev9+7dp9CDX2xNnNxBXTgmWiLEhitMyccMOZt4hznoZ+L9KNyhoEdRQPQWPHmq/rqKNjSIt0sFLifFJe+3EXfMwjXUZQAwHOeMs5RzZmPdbwNNdHOZ/cEiprSn86eGTD4QVzCKMBBncMYFjDudlhk2ANmHbsaLEXmzwDevIQFnWOTIxXpW0c9IZ5foI/U9x3hBXaFWe2gdzv/HhnMDr7ko5vNRp1MRDX1PVw0irqg/AQzOrD2xgkoo859ekN5FJKpIPPF9HJfBypahXl3H9ssLcWfDotWV/Isat6j1enSHweCZVCdX8NpFQCqryiLsP856/gEr202zT7utPnEvbB+oPuJEeZhTXjZemUDQAr9/XF8V7gI3z64Fx2xsfc7xxV0ewIYB5a/AFK1QV/oNH8p2VnzNSsQLLlCaPtPLr2OmRwUxFMe7mgduwPeSG0Wc1NHHPskJj38Nh2s/aDHmnxQLlVYd33KPJXmqX9W484eff8Tl2TgSDYdwQKtbBGLkaNO+3MIgzXrePNsunA0Ol/XTDa7qnwzU+4Yp2errkNJuMHVamAHJbTpfn7BgoNrsoIHAS0jN0qfH5vXllcMWBkUzIDTNIDfhdJZEGWLYi9gKkhm6CS59vi6+a+J/VUqAgor+fH0rZHtbvt5R/r7hH/2xZPVOyiyAgN5cACVXAZKGIMVViccOBr57GXhDvGI8RkkAqnz66h0Q+iLIM6pOVqGmYXxqebaMnu9wuLGYcBHvl50Wi4OpaFvO/Caqzl7PFJr++ZmOA4wYWfEn8LMFDLyEBGX1796iBcIJHDV7co7ZxSYqHmpKA9f9Bsz3186OKIeZPFtnCeTXpKb6mNVaT3NcV/VUsKE6URaJa
 QHjQN7Vv
 Xad3ILGeW/T7w7GoVFXflacFtyoCzvTj5bzS41ktzR+EWF1AFf0Sb2VciYlmQD63XxCFiHvDCiiLJKFU5rgBUs5WJjwKF4VprO0H/3Odr5Ln6a7DA+85hvFDFGCb9G0722WtUiJcMofFu64EiBZc8IXrTyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On sparc64 a 64-bit process gets little address space randomization:
the stack moves, but shared libraries, anonymous mappings, PIE
executables and the brk heap land at the same address on every run.

Patch 1 makes arch_get_unmapped_area() start at the randomized
mm->mmap_base again, which it has ignored since v3.8. Patch 2 selects
ARCH_HAS_ELF_RANDOMIZE so that PIE executables and brk are randomized
as on other architectures.

Found while adding PIE support to the sparc64 Go port:
https://github.com/sparclinux/issues/issues/119

Tested on a T4-1 and a T7-1 (sun4v) and a V240 (sun4u), with 64-bit and
32-bit userland. With the series the program image, brk, shared
libraries and mmap base move between runs, and with
randomize_va_space=0 or setarch -R the layout is the same as before.
The exec and mm selftests, glibc's elf and nptl tests, the Python test
suite and a kernel build give the same results with and without the
series.

Stian Halseth (2):
  sparc64: Start bottom-up mmap searches at mm->mmap_base
  sparc64: Randomize the load address of PIE executables

 .../features/vm/ELF-ASLR/arch-support.txt      |  2 +-
 arch/sparc/Kconfig                             |  1 +
 arch/sparc/kernel/sys_sparc_64.c               | 18 ++++++++++++++----
 3 files changed, 16 insertions(+), 5 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0


