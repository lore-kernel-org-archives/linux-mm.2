Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC254C624D4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DBE96B00A2; Thu,  3 Sep 2026 03:41:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58CD56B00A3; Thu,  3 Sep 2026 03:41:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4556C6B00A4; Thu,  3 Sep 2026 03:41:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 200546B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B36E640463
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:32 +0000 (UTC)
X-FDA: 85171656024.29.680B961
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05D85180002
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="qygBbDf/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="99/QUoc8";
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421291;
	b=MVcv5+B0zjtFFEhaT3bJks+G+usftb2J6s0Uui6ZyGZDpXRm1KHysY7KguNrfpwCVImuJL
	O9c48L8yaGThGI0SAYbYFCb3ZuSrl21G2uFywFY1iRFOB+4UQ9j2yRKNT8kUwnVZcrIEdP
	c1QJiBxiyPQnvY4xohfYuI6eLHink0Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b="qygBbDf/";
	dkim=pass header.d=linutronix.de header.s=2020e header.b="99/QUoc8";
	spf=pass (imf16.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ViTmWloD5J2eKVReHF1z7HtFirOwWOw1jQ1azvN/uQ=;
	b=EVCpCdGfmObm0hty885D/a2+9QPlVp2dKobcu64F1h3UPqtYojEz5hx9Rmti6TRAMfJX8J
	8xeiSV03UwYPtR9eJV5csO5/l6krVXisT7bkohhRNZUx+p9ZRNkxKy0e87pVvpoSrynWpC
	7HB4fHNW+y8Y7C/y77EGgQ7ZyBElntU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ViTmWloD5J2eKVReHF1z7HtFirOwWOw1jQ1azvN/uQ=;
	b=qygBbDf/i/ChTAwdDHX/OMkpJmg3bx6WNehWxnz/a/QG/CS7FCGINzvET8JahA42fqomF9
	0tA/fgeQbgmMTbTiQjN7PdJlMV7Y11X8gID4ivpxX9BwP+ezfa5IJUGKanG/XPsFRFZvzW
	+w91JMBD2jwTIuY19qA66NaWObSbeT+v9qSA/aXqJ/r7GLtPWY+L4rF0kBBhrcq0sS9IS1
	YH38iFpVF78cVoohANLZiDMxyNqiEUlth5rF658DWk6HyldpYOdOSloQqohF0RloLbf5f+
	O1QY45sabtAAMz5DyzbmCTCGTzJvoZxmpqGlyZ73gD3OpdV5mqJKFQtQUXHgsw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8ViTmWloD5J2eKVReHF1z7HtFirOwWOw1jQ1azvN/uQ=;
	b=99/QUoc8tSeZF+1c6hGSR5xjtwKPDTxKJiyjGqHWes2RoXstjBOuax6m03o+e/SbOdYvh9
	hLslsBJWfKFMgqDg==
Date: Thu, 03 Sep 2026 09:41:19 +0200
Subject: [PATCH v2 04/15] ARM: drop custom asm/auxvec.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-4-5bc32a71e3d8@linutronix.de>
References: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
In-Reply-To: <20260903-at-vector-size-arch-v2-0-5bc32a71e3d8@linutronix.de>
To: Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, 
 linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 linux-mips@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-sh@vger.kernel.org, linux-alpha@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=523;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=4mJFyYPX7/9EiMcEouBDn+ZTTOxkaHBJ3RQn0m6AUq0=;
 b=sVImdxunzIXRXXF2KzwDmKwk5x92lBY65ndCWzK3uf7dXH1bpo1cEYC44cBh8xKpT1XJtE/ZI
 nX8kEx7kkkRCESasFd8Wvn+OVgSU5t7OhvXleYrjtpeuaW16BitTJtC
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Rspam-User: 
X-Stat-Signature: szj1qzm8m9a7f441t5oh9y6u78bdxp5h
X-Rspamd-Queue-Id: 05D85180002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788421290-99102
X-HE-Meta: U2FsdGVkX1+888Cyd1Ek5M2+rVvoCaSgK5QqbCKRT6gs0Wzr/yULJTTgrjdIK64fcpbbPZ+GJm+Xmo6CvCYLQ1ES0gT4TrBV9vjh6Tdzbfl/7qlH3Ycel7TGEVS5Kq+fOJKf0GMSGYAv5Pazn0k1Ojd0/YFq6GIi882f1pXX1VbfvkqOzMOHdPJ5/ejPftjrm9ZxTQbLZbJvIh+8eD+k+oMq8i1VbVFQYCdN9n0ArEi/CQf72O+TDJJaks+4NNpUAVtbl/CYu5N1JLCucXLy6KxJaYPG4K3ODxF6a3JhLsTSAiook5QX0negJmz3uyQIHyZ3A8yyK1kxNq1465FXPi3l9tnFV+UPiWbsrGZD386ESdEAnIAVbrZDWL04TVbnTrTWg8Ob+e0QvhZ5E1zreHKJibr37ZvDId9F/u3f6bumtUL3VbYx78roFe/hkYuFVnb46PeRyNRE6DkQCJ0o0OGlIfe/+aiJR4LnAOC11KasvpeLzztsONvQ8fl3NswPN0t3R5uSZprQQ3L8NeGa6EexWIBn4D5yUHbqyurZFCWefHB74u0nzZaJJOBpdHumPe69o5eHwaPKGsEQmDJHmnRab6rDSdI1lu7ruJEBrwS+uYH6Xd5GK5X5ilfPKRxtwn7c68dtIEdlsn2nviSjfKJisX2qHHFDDf4nwbFj5NFymnWdp0IygwUYqSqgSCCQVsu84p70FzZh/zMu3xrapJTPuV6aoeT76YeU9XTG1zfZG81OIapIlvv4i6mzYVEGvUFvyjV+Z7NO1ZjgBi1+rZZ+i/jrrDZ0klyZJk2EbqkDYxbmBG6dWo5A59eBXQ0koweg/dGUI6GOBWJqGenluzjLaaJWHz+OJH6eq+FdO5VThD7COy316tTjYyLfTcHeR4ZQ+r+rkRYaB0WnZfjCRml4cgkuBE9d5qNiDAYJQRRsozunzmz8etu+6suALWmBUBWu/58NdzrZKLStkRc
 zlQl639k
 L74hpq4EB+b/SaWGYUdw9umkJp5ywMORhJIftVuD+mmNfEC3OuZVnktVZ72Dl1XCUGA2kDMWQGhIYJAdpme23XyiV1OyZCbn0391Rk3Cl6gtpKJFsksvnqcphDV7AmiAOq5gI/owjTy9BhH4sQYeFTgmkZoH/oUGAEEdxUMAePCe+OjLUZoRoBzNQ+SvVfxefGfkBYK/BqlP8HM1Igs8swxYsoxiiBOKXaPH4o+sAn2s/jbJKx00NC8sfHrunrCrS7LYfC/MXVwsziOaz23FAA55KKDPqHMRZP94yLRrLiNHHNaiGjWP4PyVK15js1smBnRAwYj8bD/OjaYozMjKrCX4xaWAdRX7p2Uy9j7ihzz9M4Fw74JyLiTaYEYjFRpXN53mK+JlsIOjwGrsCxOOFTQEcIG5PItXVkcgD2PTVc+VmkaGa6Exc8YXJR7oX+YbudI0l9ZDlI/SCh2LfnuSOCyvx6jT2WxUaFAvoZTrDEKAHMuzdU23k5VRpqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the introduction of asm-generic/auxvec.h, this header unnecessary.

Drop it.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 arch/arm/include/asm/auxvec.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/include/asm/auxvec.h b/arch/arm/include/asm/auxvec.h
deleted file mode 100644
index fbd388c46299..000000000000
--- a/arch/arm/include/asm/auxvec.h
+++ /dev/null
@@ -1 +0,0 @@
-#include <uapi/asm/auxvec.h>

-- 
2.55.0


