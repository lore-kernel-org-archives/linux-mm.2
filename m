Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32138CCF2C9
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:27:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1106E6B0095; Sun, 18 Oct 2026 08:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090236B0099; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCCA6B0096; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE6C6B0092
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1637A8050D
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:48 +0000 (UTC)
X-FDA: 85335673416.20.07ADCFC
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6948540002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=XOKoEzin;
	spf=pass (imf12.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326466;
	b=OqylzNkXVx/0he/NuND49nhM7LHiOLH2d8VlTlHv/SiBMTCLcZxxYd8+5legQENtMFlcwI
	NgDGZCTQRw+J51DoIg9f2S7q4TfMM/JT7N124GXAnrKi1OPFfRI20dXxsy/VFdRYT0YTuR
	L8dC0n13Gof3fy/gd85U4Gm/KaFMsls=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=XOKoEzin;
	spf=pass (imf12.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lYkr+husjlk64iLj9K/N8BDK8HbaHvelmyk4t5RYKIE=;
	b=PC4z/ZmwzQuPZIjpRq1d2eAJTRN0eBGpMz1Az3pYGotoImp9YoF4+tfoXr0wXCFHpuKFPH
	DXrEmNiBMRan2WFVV2x63xZS3w+HjdHg9/tDEBi8EKcXKjeeSHcZWAkMcsCdY26qFQKMWz
	g2k+nFEVrXinQjwFA5yPD8zX2ESZ/Bo=
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792326465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=lYkr+husjlk64iLj9K/N8BDK8HbaHvelmyk4t5RYKIE=;
	b=XOKoEzinrSofyoPTQy8RmxgyigBmHkTwjEOouaBzs8DaJgvpEgGuYf07MTNk1r0plL//ZT
	BhI62j8GlGTUsiIpOsu24dFCaeyKTIQAzabV3NasVEXyjBK5rPW1grKH1LFlDtHsHTvkcr
	Q5OWUXMigj0q607Gji1n3040QHYYx8U=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	Jan Engelhardt <jengelh@inai.de>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>
Subject: [PATCH v2 0/3] sparc64: Randomize mmap base and PIE executables
Date: Sun, 18 Oct 2026 14:27:31 +0200
Message-ID: <20261018122734.2594904-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6948540002
X-Rspam-User: 
X-Stat-Signature: 95qtzqrp9e45bkgi195ttpd87688p6go
X-HE-Tag: 1792326466-898851
X-HE-Meta: U2FsdGVkX19sg8g181Btse10FggzXs5RHC2BJrVrkaeQZmUEKGugbhPYqrJcRIyCVikZaSjgTG5j71SnlFDpIxCxC1t5jCPsqvrYoYhoWnZowC3wroUW6dltNXjWNWxDnIBUPPgGL0IsTf8WaCQWmjk3OqB3g5BBAzYsbmk/8iRqwK1TQ7HCvLbYAUiDBCxChe/PcQ6B2Yx1yGkyohNEtw4LJIAEYPiKBCdvT0X8tjRCo9n/zsVQxxK6rRCrOxVJiPCNruEY9e/GWxiG0MJodSsoXIUMb6NsWxdtOrMqKA7hPUQEkgGRIHgqNxeidjIdt0gUnx+GEo9RE3gdrTmKrq3Gtn7l0zBFzGhUUkPvBr5YprW/TInL7WmXGaRzijmgIsHjnBgvKLPvoC90mbClia4LG6S6T1UAmeOjM/tMh3rXOwwsIzFLVMkGrKog3bfiLHEt55sf58L8cius/leC6bM7YOOFbmgh23Ba+YdmvCVYjkHfJ5y0unsj9HC6nwWqXmTCv+zXQPHROFs6lKFaJzXbOcVe1rTTdwHyiMpYonrB/SsQbEhRXGe6AiJe0RxoB66KlVnFmty3KkcrAeGzSTc5lGt1hOULze0Wd9Yx/qmtOEO/o+AAXUaub8qHjQ0ImvaaSh+qrqsqIjsHxkPJDa7J4ktfIn4NsrI5Uym9T0ja6exSbNJXMtQaKVpUXjQ6rpgZTD5nWE2RZ6EarqRE+oHNeuyS0SzAD04fp2VfTSUlZNZNExQXkvc1mYfud9NuU4Ubghg5B3Hp5jMfZPBQ3uvHzD5+dgV6nekD2m7obI+nm6cBwZU2Cj9ZH7wNvYM5sDTYvB4b0qwzhuTX27AN7oDMb9NHKlAWidJO7PwwMEeV9kzhPW8fSDhKCIxe5odZh/OOVK/Ux6y3HFNKH2MJ8aOh9sLQrByzIqgbJJDQOYZt/2BK5wf3HIjZ3QAxnauGrbDr6/HjHP2eHNLR9TQ
 klCQNWj3
 C4NpIof444F6QyWJxWOKz+x6ygEEbbaPQt0bFTB3vytXVhUdRPLRbV9U79X2gnWPg8plNkIA1kUuKLiEbKEyDvjQNym3/GxLd4dBV2ToXTk4vpY62jnu1MnfYxKbYs0YiZVZJr+wtq0IrQiOmm6mJ9mn0rzQW0h9AWaMmbunqL/aPON6A7QRQPqVcNw==
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
mm->mmap_base again, which it has ignored since v3.8. Patch 2 moves the
32-bit PIE base out of the legacy mmap area, so that patch 3 can select
ARCH_HAS_ELF_RANDOMIZE and randomize PIE executables and brk as on
other architectures.

Found while adding PIE support to the sparc64 Go port:
https://github.com/sparclinux/issues/issues/119

Tested on a T4-1 and a T7-1 (sun4v) and a V240 (sun4u), with 64-bit and
32-bit userland. With the series the program image, brk, shared
libraries and mmap base move between runs, and with
randomize_va_space=0 or setarch -R the layout is the same as before.
The exec and mm selftests, glibc's elf and nptl tests, the Python test
suite and a kernel build give the same results with and without the
series.

Changes in v2:
- New patch 2: move COMPAT_ELF_ET_DYN_BASE below the 32-bit legacy mmap
  base, so a 32-bit PIE and the brk of an explicitly executed loader no
  longer land in the mmap area (Sashiko). Tested on the T4 with 32-bit
  userland, including PIEs with large p_align.
- Add Jan's Tested-by to patches 1 and 3.

v1: https://lore.kernel.org/all/20261017100451.2266781-1-stian@itx.no/

Stian Halseth (3):
  sparc64: Start bottom-up mmap searches at mm->mmap_base
  sparc64: Move the 32-bit PIE base below the legacy mmap base
  sparc64: Randomize the load address of PIE executables

 .../features/vm/ELF-ASLR/arch-support.txt      |  2 +-
 arch/sparc/Kconfig                             |  1 +
 arch/sparc/include/asm/elf_64.h                |  2 +-
 arch/sparc/kernel/sys_sparc_64.c               | 18 ++++++++++++++----
 4 files changed, 17 insertions(+), 6 deletions(-)


base-commit: 24a19b953e2a3d0ea5a8c4951a0ab8f32720c907
-- 
2.43.0


