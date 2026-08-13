Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1C08C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 16:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2F926B0536; Thu, 13 Aug 2026 12:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0116B0537; Thu, 13 Aug 2026 12:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6736B0538; Thu, 13 Aug 2026 12:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CFD26B0536
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:03:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB9E7120172
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:03:25 +0000 (UTC)
X-FDA: 85096715970.20.8444A11
Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9CD8720006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 16:03:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ALzKO3Yp;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.2 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786637004;
	b=6UuutBl7V0840OrLZYwEldonwxHQM502XIOJfoGxweT5D3Ek3PZlAbtkEqgjyHA15p1Yvx
	hopQc0sPlC65TuLa6e3Hg26G9PMwAtkcl+rrAxgTq5qo/v1ud5rh4GMLbtikc/ETf5Muky
	n0GmJdjhhwuSxpESZQhddgSJd1WhGyE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ALzKO3Yp;
	spf=pass (imf03.hostedemail.com: domain of dongtai.guo@linux.dev designates 95.215.58.2 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786637004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCiQ2PIGfe2qaMn38Q/OEHxu2Z2ztzJDsBcYH2TPtp8=;
	b=A5B/SYABtsjZn1EZzIXCqgA3kNVgP+TwkrhZOr6q//mGY02dlYRmNCJMiFmbFRSW7q4D3j
	/Ci+tT0mnnF0eVlymuMa0dgkgx9Chsicx6iMxcGu3YyXRIFGnyX5hrIDuZ6cWviqUvpigS
	w3yjqqRGf35dfltn5hSKu7qi1XlAnpM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TfiVg463NFynci603WWT4ZTChHOhrPxJeP6Z8Zrf2Es=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786637002; v=1; x=1787241802;
 b=ALzKO3YpoY3N1iThVZbD0TbWi+NXqxICt9DzFGr7lxwyIcM7cLGNVLA1otFyhM/m31IlbyIF
 UO/deUUjX9b95x8Z2SPSahwSuE9elB2HSLiXoc1/qcQp5HPau3g7wgbs3XgnPvWqcRLGKCGFPAC
 3deVPpYXCQdKzwRCE3b3A23I=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 86f3e37813a2a36a;
	Thu, 13 Aug 2026 16:03:14 +0000
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: chenhuacai@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	shuah@kernel.org,
	ardb@kernel.org,
	guodongtai@kylinos.cn,
	kernel@xen0n.name,
	graf@amazon.com,
	liukexin@kylinos.cn,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-efi@vger.kernel.org
Subject: Re: [PATCH v4 4/4] selftests/kho: add LoongArch vmtest support
Date: Fri, 14 Aug 2026 00:03:07 +0800
Message-ID: <20260813160307.15130-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
References: <CAAhV-H7+1bv6ULPO1+SZ5R=XFxNTh+54rqnYQUAW26kF83kiMg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9CD8720006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9erfhc9wcnikndfnp6n87w78mahbo7ho
X-HE-Tag: 1786637003-307094
X-HE-Meta: U2FsdGVkX18Ihw0waU0qUSKMzqKhKy5Vron2O4GgDPBaA8taGJyJnqxnkhVZN/IdeJlLZMSvw2gFZFPGUyfE7n0aFztAm0RWAjWg5l0CwwYx3CJLbfTYjXNINC/qsWPxVVgJQ3XS4VFonuF57VdD0RIwyUaulAuViFcnVg2eMuM16TAlR5xTNuRZOvTdK7U+TstJiO+fhYkIfy9Y2maNUfe9jR/7vndfjpoQgtCiy7ovz7wIuDbr3UYGtARdGKWQGMwwAPx0Of5aAw3//ifw6AXESBnFFELkA4SZR54bJZWF7OsSvbul6bxukJMguyjaKtxThW5MWc17Xfj1k4iVXYo9ptQ0SCgSjkUkL8ZjD3T1TqDUV84iz3WOJtvkHIINvdL4WAkb0jWrh67CSQU5Phup8w5Th5iV765EwxN6wwPDr0xfBvZMEbJLjqGzyuwyzkz2e1xHPuhLJV7X6O9XeBLOk2DKFx1BxCc7o3/MozjFGxIfvDxEJIy8XvGLqVsVG9DbmqV0bZ4QtQ0aLp5NCd8xZs+dTSn0JGUgiEXaWG/+U4HQJiqn/LehApjGZ5X+qez/EPFGmA8hfW9j3WTQefDRF19VYqBDCMQkMTu+p3kBtGcc9VYkSt7mrTqHQMR4BZupUo038YFNNELW/FYPTNLMyvhs1sXc4tV+WsCIWgkPAwPBFt//gz+8su70b4Iy/g+gkB5yvKpClJeV0Xr+LWFOITs98sjHmVTcYs14Ygk+GEA/nJtn45d1ziY1sWZHl9dY0EKcb4ihSIbTgCLGBqkXwKrZoU61qIIHtjVTh+DqHkNNm0T0qbT4cMXDBu5wq2vmnD3pAGeBeEdmaA7xi4xIxTCcmx39RpyLgG3DFUFzbWZFWyo0QzF3y1cNbAaEIb6vkhvDIAujaTz6/NREKjZwNJAcEyeT5svC+7PZQOXlQqN7S7BqhtSo7hTKL+fQVcowVYHQEOnNK55oTKh
 iE3wxm4v
 YBqc94AjPPFmDnlF0HXEJ8G5YmmJHmbXdTYMy8RobIIZeb0HyHuuhdMYFpbBcxGhbItz/wqyjfjzP9ryGjxLFY2SiFwO3MeyXfl66q9bT04JWr7PQJFlOYaRHlBls/yTpBD7PXq9Kmn1TmNj4Y8Mvjoq7au4J6kZ1QXocVTIJdlvZp/bVF7K+OzODglXCeMpi4CO9Ni7QYzdfoIeM6ey3OWDFEvDCM642ltL6iAfdkBNFrVD91rlaRMmoaaThB0+mpfkOPOfpOcMmkj0gUdhr0nkB4guZKzD4lk+nZ3+2s2wbTcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

On Sun, 9 Aug 2026 at 12:16, Huacai Chen <chenhuacai@kernel.org> wrote:
> You never answer me why in your test you should disable i8042 from V1
> until V4. In normal use we use a single kernel for both host and guest.

I owe you an apology: I did not actually understand your question. I
thought the commit message had already explained the reason (the
i8042_flush() panic), so I treated it as answered and never addressed
what you were really asking. Let me answer it directly now.

You are right that this is not just a selftest detail. i8042 is built on
every LoongArch kernel: arch/loongarch/Kconfig selects
ARCH_MIGHT_HAVE_PC_SERIO, and KEYBOARD_ATKBD and MOUSE_PS2 (both default
y) select SERIO_I8042 under it. So your "single kernel for host and
guest" point is correct -- a normal defconfig kernel has i8042 built in.

On the QEMU virtual machine there is no i8042, so PNP finds nothing and
i8042_pnp_init() falls back to probing the i8042 status and data
registers (I8042_STATUS_REG, I8042_DATA_REG) directly. On LoongArch those
registers are memory-mapped, and on the virtual machine they are not backed
by any device, so i8042_flush() takes a page fault and the kernel panics
before userspace. A normal LoongArch defconfig kernel booted as a QEMU
guest hits the same panic -- the "# CONFIG_SERIO_I8042 is not set" in
loongarch.conf is only a workaround to let the KHO selftest boot, not a
fix.

The real fix is separate from the KHO series: make i8042 bail out on
LoongArch when ACPI/PNP does not describe a controller, so the direct-port
fallback never runs. I have prepared that as a standalone patch -- the
relevant hunk is below -- and will send the full patch separately. The
selftest workaround can be dropped once it lands.

diff --git a/drivers/input/serio/i8042-acpipnpio.h b/drivers/input/serio/i8042-acpipnpio.h
--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1633,8 +1633,14 @@ static int __init i8042_pnp_init(void)
 #else
		pr_info("PNP: No PS/2 controller found.\n");
 #if defined(__loongarch__)
-		if (acpi_disabled == 0)
-			return -ENODEV;
+		/*
+		 * LoongArch legacy I/O ports are memory-mapped and are not
+		 * safely probeable when no controller is present: a direct
+		 * probe faults on the QEMU virtual machine and on any FDT-based
+		 * boot.  Do not fall back to probing them directly; if ACPI/PNP
+		 * did not describe a controller, assume there is none.
+		 */
+		return -ENODEV;
 #else
                if (x86_platform.legacy.i8042 !=
                                X86_LEGACY_I8042_EXPECTED_PRESENT)

Thanks,
George

