Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76873E9B36D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 12:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F1E96B0093; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998056B008A; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 849166B0092; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 717236B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 07:25:49 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C03013C176
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:49 +0000 (UTC)
X-FDA: 84501044418.04.3D5182F
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1EDC140005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:25:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="XTq/Qbds";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=f3MlQqxs;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772454347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Q8M0BzYT+8nDvDRpeOPQrwaX+SE1r8gh99dGV2h1fFk=;
	b=jIIDLW7u/iIQoK/WCUBVgCcw4FxQ1c9ynx73rYmu5ukJMWc/uu6GOXXp/yFDAKjYzTfT3B
	Bp+gvq6s8YyebwphxRmXc5e/nB3wu1Gar28C+HYqpflJfy0jjro3Z5QnBauFdV2gZzDceL
	58jBEUO5AVeH/RcnRJg21CYhbHs1GFk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772454347; a=rsa-sha256;
	cv=none;
	b=coEyckXLlzdBcFymVbObL9Hm4DGK6u3FheoMX0ehgrM3TQpAU95Hs2TqlCpddPTMmWMB0+
	TUoIGL4LX1FrH247+mwYFFWCeGbkE2VO1LfVnWzj/FtDsR6Ci23K/IbZGlzNRPkN8KHCEK
	4mQtKLh7zPQeC8j2aBYeLpN96LciKy4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="XTq/Qbds";
	dkim=pass header.d=linutronix.de header.s=2020e header.b=f3MlQqxs;
	spf=pass (imf01.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1772454344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q8M0BzYT+8nDvDRpeOPQrwaX+SE1r8gh99dGV2h1fFk=;
	b=XTq/Qbdsmdrjjgi15d+mbxPv7MA1pmSdTxIgk0x+7gQ1SBn3Qk50BPvaiHTGQy/qTkOET0
	CGc+OMjOeQ/n2dA3JdyCWwjrdxy0uscngADbfRLK8WmqnacdFL6h4HVWXe+3LbMBHdWR9X
	qZ74nUVL9W2j3VLfwuTKczYIjFgmRo5MMH5f83HQtqnIdi+gp6yskGE9pemAt/5epkD38A
	sdonFKgtjJGoOsIGmpIH2kKpN+TtX6hvt/oaC/e+zE3Kp4IcFO+phZTmHZCNcZy7Qe9ryj
	DSBSapJLSRTcmYCf4GVgZP161CF/lM2AnixGVHOK2waHFibtLc9ifGRmcjG1Rw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1772454344;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Q8M0BzYT+8nDvDRpeOPQrwaX+SE1r8gh99dGV2h1fFk=;
	b=f3MlQqxsNMwSdSaceDHlFwzKoTlTmrVShpKlZNDhQVk9O7AG1ihqK0Tpn92+Xr2oztP91Z
	NrP6Rmm8D/oDiRBw==
Subject: [PATCH 00/15] exec: Remove AT_VECTOR_SIZE_ARCH from UAPI
Date: Mon, 02 Mar 2026 13:25:24 +0100
Message-Id: <20260302-at-vector-size-arch-v1-0-a11f03ba2ca8@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MQQ5AMBBG4avIrE1SXTS4ilhU/WU2yFRESO+us
 fwW772UoIJEffWS4pIk+1bQ1BWF1W8LWOZissY605iO/ckXwrkrJ3nAXsPKDiZadDG2k6NSHoo
 o938dxpw/BDR+BWUAAAA=
X-Change-ID: 20260109-at-vector-size-arch-6e0f2e9ff8b6
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772454343; l=2953;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=JDTHLUTBRhLdtWzI+cYwcXmhsRHrVsJSh1vwEnoNL54=;
 b=J6CYW4wsSS52A+nGxs9gwUdPdfHUZDIYWEVVGw/G+GXj/VTqu7W4L6C1R+uvBZbzZsf4FisCc
 r+YyP25hcjyC3G9P+jLo1JOj2qTAaURruN7qUwKyoqSA+FQdhvM39MD
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1EDC140005
X-Stat-Signature: r5p16hoo5hrzkou1mass9fcr5uboppe8
X-Rspam-User: 
X-HE-Tag: 1772454346-729894
X-HE-Meta: U2FsdGVkX19qt7tZhsN/xN0Rfeal/pRHO1b+dbBUaR9VgiCabHSFiBfcQwUFiVUPx605NHMfTbsn+pYTIp0nI6ydGd2fRPfY81ApkR66PBMkU7g6TUgyMlpq00HrOwhc/pfGIt/ER7olBOBYeeUf5lJa7REWHf8VTfvysCS+kUbSkXvACF3tZemh4DonjlK2e8+7uQt7xkw64YlFjvQjhryjJEUC+HfucU6QB01dfqVdIuF16FfMhW9+fchOkMxRNLGp5hxUQbP3hZnjc3UK63xSS2b7CW2FylqnJY73qWN4V/sCPGRMPxcoia0g6xzWUXB1R7Z0MOih8Q+uXpDNoTwgHBbpRzZPhZJw3OVCAxBfD/VdWtNgJ/x1WwzpFxLoFTeG1ms/9ZFQX8ZYZ1A+Rcx3UvthGLTFgD7ehEOUIcBXVLwHl/EtHaaNyfi+f2p3R7ZiodoMmLL72M184Lu7G1dRKCOiJEzE6vQESmhsoLzYDEFY2VfJ12SoczUo4u+V1kfSq9C8l3Z4jTXKTk37F2//LHci9LHFQYYrv3ewMEdtAMkTeoucpIrMAuHt/NsXGlLJqJ8dWhTAuZYpiObSKOavy9VzUzY72BOJhgkqAH0ce33SrPTFQPZyVr/8X5DddT0DnCOg/AhsgtZXwO1vV3ZcJgYxD/n47n2v4dytSwZ1a8XmbYvRHnW+j7pEx2GV+d6ao4N8hYbwKQOwxl9eJqIUthRP0XbeLTeUzwmUN+CJZ78tnlR1ulkz4nOY9N3uphyvQ5HDUgFtp5ZrkfNeDLwrce4KEBxDJes12A9Jc+z1qqo+TEPevCZFWfDqFyo5v3bvdUDM6HLtXTG/oH+wVthySzG2MS3Pm0Kt+WNZPFfdfNFm2k8s+6tbJctoHq4MLTqERk+FSKTShT24pgq2knnIV56Z+adq9UqHCMR9Q0ht5I5UxWcDsFEuZPL9T9tppF7ropn5TEFRLkJaOeq
 +Sr5N2UL
 +djdyzEM7eFslbtisH9AD3qFOSYbZhKGPIZ/EGpy1jaE294Ih/6notIydxtjDHP1VuyI5RuBxEu2USPrTBa5BrjO8dTzJ/4yVd9SRZIXlFHt0J08Xv0uoFsK/cHEpOum+MtbdaKD93laVz9tFOFdO9ai3XjiMSKeZ6uzi0XbrDeCpfbM9M81wZbQ078uqEP89Lg2MWzTfHIGSaVWZ1GcuRETlTPliYbc1HYRSuDakqX2fDaeEVUuIvqvJAsuEZrL9PjYtlexbkeThu4hmtmqG4/qKfZGW6YiLqx3XKFEvE6rXZ+zqD+6YAfNOcU07dc8cE30dTECSmwAUC3fOFPQZbhydp5sY/YF2HE7rXhgAnnTNSIoNbTSgKkfuMien4r4PfVJDeJC29aOIxRC8BEHQQDm0wJ0If6njkHS8XEr8pYo+hrMkMMa/xXAPlAPQFU+JOOV4nOQ0OB57Ys5dsVF9NdAduwd0+sBcpwgE3HQdy64i4J5tPStAU5vEufR0wd+8CnieDZVPu4w153c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is nothing userspace can do with this value. In the kernel is
always combined with AT_VECTOR_SIZE_BASE, which is not exposed to
userspace and also changes from time to time.

Move the symbol to kernel-internal headers.

Meant to be applied through the asm-generic tree.
The default recipient list was huge. I trimmed it to only the
architecture lists.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
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
base-commit: f6b3b0a4c85882ad75bce3b093173203e3f39f28
change-id: 20260109-at-vector-size-arch-6e0f2e9ff8b6

Best regards,
-- 
Thomas Weißschuh <thomas.weissschuh@linutronix.de>


