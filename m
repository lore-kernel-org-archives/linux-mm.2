Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2100C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1A2C6B009D; Thu,  3 Sep 2026 03:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0816B00A2; Thu,  3 Sep 2026 03:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0C516B009D; Thu,  3 Sep 2026 03:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEEDA6B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:41:32 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FD731C214B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:32 +0000 (UTC)
X-FDA: 85171656024.04.DD17756
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E3408000E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:41:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zc+fw1vP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rh+ETLVc;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HcMZPcEqwvVMhaVCt8MkUvZh7YAwKSLLYydvmnNx69g=;
	b=rd3jIvvPR4VuI9BARy6gHbbfy4q2N6y3LhE61nXQtWsW9nsLJRAS7Qw9Xjli/s/yMVK3At
	h8CBf/3kG23mft2VYtgr36RFtHIgDJ4ZxhSaPLUp0Jnv1Z4k6mMUxyzY6rYGWsjjInHuzu
	JFci6GGon3ffO5VkUjoO5rHucwIpEII=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=zc+fw1vP;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=rh+ETLVc;
	spf=pass (imf30.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421289;
	b=Du7wtAwskB4tLWrLHigbf3JgztRZmNpicaKV12bO1pu/TYP2T9ExO3Hh7ZRg+g7d8E8V1M
	h6j74gK0sc5WQ1YF6NP3LOa7SyTHeiIpMZUU3mo+D7WsIVnIswt5MIbuTN2kR78aaGm9HW
	9Lj1Zw1Qz/rrVDdIGZ3egIV3G9T7ucU=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1788421287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcMZPcEqwvVMhaVCt8MkUvZh7YAwKSLLYydvmnNx69g=;
	b=zc+fw1vPS28yXzWhjuVq688bLTlDJP+PQOO2TZg5QcxVNPZStsrnS4EMvXTkuI9WChAUF6
	e98Za95kruhvUKHM3/b34Kuksc7kVeCyI/v89gq/la6051sO7iVJiyemzT0SlIcVMLtp3V
	LBVntQcEnLcQP4mEFAOmRCGnVFjObZYQoy8t1OzlP6lakHcsrKvjUzVXe8XXr5xuJfGQOC
	1qK1oo84uH3RvHqkEN4CnRtgprm3+1bwVoDYK5JM2mCOVa3NMbngliORKzy3gImZ0p3Mdn
	KA4/eGPfFEVefv27hiUMV5YSZZf9/EbNiLhBwaHSRIcgEWjR+hD3IjTxfTw0+w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1788421287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HcMZPcEqwvVMhaVCt8MkUvZh7YAwKSLLYydvmnNx69g=;
	b=rh+ETLVcunE+DHaXRlcjbRGQypXlRas7Gz8RSxyOEQznbIdmSjOOp7xhZp8qA1klyLJlHr
	4QVBYU6drJOyTJAg==
Date: Thu, 03 Sep 2026 09:41:16 +0200
Subject: [PATCH v2 01/15] MAINTAINERS: exec: Add more auxvec.h variants
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260903-at-vector-size-arch-v2-1-5bc32a71e3d8@linutronix.de>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788421286; l=977;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=Nm/6hJEAPks30y7LVA2Wwufq3vVlMHx1IoW0kUFRRys=;
 b=qmIl+ksPTFbWALcvC6gLtF0MRDI5uk7fAOGtmCm6fQ86AWfo/5KOuP/P3VXL2cXkfCyJKwCbQ
 KGGjiCPlRFCAaRujs1d1gu5uZskagQtGmtcqSJJWjBWfEVKN728cCnc
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: x16wec94y1xs11uiwdpk3wap7ruwxeua
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4E3408000E
X-Rspam-User: 
X-HE-Tag: 1788421289-968146
X-HE-Meta: U2FsdGVkX1+KwfGClZy1EU+ebdOLaPpy8k2J0LHYf0VjZzxZyc+QILjgCIvKP9A063+HzVZRnDLmzCwg0nWYX4bIh7mFhwt+xR+y6x/f7ihe/HeB9NwmTql7juZZPIK58WgjT3OTASdLKTsZLKwz0Rwq4foFwj7XFvIg2IBjpm0g3fUiJtIhsZZXvXF2yQivzYKo+LsD0NODpAf3Q08cgdSa/f6aWM/xMPn8gTqTb7SV6hxb7bH6PSWmfJoUzrryH7+wnoqIHgftdtsdpgPjDqoWGu+xxazcJZvdDcUEI1SuEAw7YCaHr/Z1FJ1lxfM2hqTzkDTctlF1O07mkmQwCCiE/Kk+gjNgiNCTOvD3l0zrRHPod803WvTXR6PL6+dSZR+wwgmnuJw/fnYffLJ0H987ImHntPbiLUc8BRZZIW8O+8RzGBWQyeBZ67fFLYYypyQ7zkOBrtMJb8jrYnUfjNl9p8zS7OIDNfKyZ76iPV9CQd9nUqjHViHj8MJcxXSw0Hq6lmlFMqI9em+XGRb9Q8AQWkywnTdcDas0FNnz2IMfS6WhQX9ZKevq33os+BYc8ajgkxjALxQyzw5aJm9tmnpCBVobKpi8vNWkHOaNV5CtF2Kgc8wOH+vTTLnriIH6dQXLbRDonKlx+xhD7xB1kPJ7WRMXMrxX5irSikA5VW9cSNaItemSHO0Ti9iCwmD8qgqgniI2XrXwAHajiVXes/8mkYlsKxkG7GVDRfCGhNxuF1vvgWxuF66bW76U+/I316LlohibuYfF++0oaTvuzJM9SFIrMKlU0dVU82Ze1hIXOHTk4WTHq8heIAH5C9eSFbdzyHp4amWQB7VVR6XDhqOGghdDkZ1AM7zYyC6uU8ot/GiGDZ5KdZxr1Sd+NX5cWiPBhuvyQUTVpsI9+y5IbE0fFT0FdfSJaF9iOGf9lGV5iU61mXCxcucfXpQlUxfNzt83FALpQFFo2YTkmyT
 1kTn7TZg
 vM53LLg5O1BXJI+tWZwAH/IZw65kNyl6jjuH89yX5SdbCunGE8QMr/H1yxvmXujKs9d9e6CfjnqHsR8eZo4HCUk+V5mind84o6OoA4st3gkG9y3r8aS5qXNW21WNYBB9TbkmSIfzOVyL5zbDs2+7WD3H1Fwp/nMNZbSN9q2SU2IV3JrmEYQ3PcItdI2BwDzGRlvYQoKlAcZPhndM37+IATsKULNyuiMa740FSae3V0MDTQUewS+fz/4Wd4z9b0mJT5yw7/WU1kUqdffSdaQGdughw0cAha+kBqLZEiBRAS9LIXXw41qoMK836Wg+bxnlfSL95L3ERFuE0226oLHR50yCB4ZN8Mtlc5kmxIgMWSxpN3oA4X/z9XXTax3TX35+U7AtgAzxFyq/RnMYnZckWyasHPrsKsrCwrpfRF3h/6puRT3izFUqjA5RnWk+/2VpZMGtX5wjDfO/VIa1aw/+/VQmL756q/Yus8CtiHOqCH7KfTyb4+NDVmjRJaSuulzEl3t7L/aK9QxeRUZkaHjwyzxXWeQceSNvIB3cfDk2J0uI6m5gStRVYd9q8+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are quite a few auxvec.h headers. Mark all of them maintained
as part of 'EXEC & BINFMT API, ELF'.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Reviewed-by: Kees Cook <kees@kernel.org>
---
 MAINTAINERS | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3a19da74d00c..42715aea210b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -9808,13 +9808,16 @@ L:	linux-mm@kvack.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git for-next/execve
 F:	Documentation/userspace-api/ELF.rst
+F:	arch/*/include/uapi/asm/auxvec.h
 F:	fs/*binfmt_*.c
 F:	fs/Kconfig.binfmt
 F:	fs/exec.c
 F:	fs/tests/binfmt_*_kunit.c
 F:	fs/tests/exec_kunit.c
+F:	include/linux/auxvec.h
 F:	include/linux/binfmts.h
 F:	include/linux/elf.h
+F:	include/uapi/asm-generic/auxvec.h
 F:	include/uapi/linux/auxvec.h
 F:	include/uapi/linux/binfmts.h
 F:	include/uapi/linux/elf.h

-- 
2.55.0


