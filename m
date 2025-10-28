Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CA44CCF9EF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25CE8E018E; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC428E018C; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9279A8E018E; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73EEC8E0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F21612A593
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:23 +0000 (UTC)
X-FDA: 84046969566.02.7C12D99
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf30.hostedemail.com (Postfix) with ESMTP id 85CB280007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=n3Cna5cw;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf30.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=noNlmxCJE3KO/lPWg5rcvAC/N6+hMXNKqLIKFsG5DTo=;
	b=Od1ctZ6O3SPsxmnQOrPAGYKeq67sNGiNccpEpHrLLrI4r+VFlVxW6tFzEfSnXj0GX5PwhG
	6RPpE/otO5JSn8KNLocBHMg8GXKpMMeq7KI/qm+01gicrH4oCdvVPyMXyZfcTlLkrh0Yjc
	vTXWm+YHYK/mOgNRlc3MCaswbr70TFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643041; a=rsa-sha256;
	cv=none;
	b=aTQXw6810BsVgz5+7NtfJmuBwqtosdv8rp7KXV0ElilaFpmrl7WWS0Xx/ouhL8HiKdnc/M
	lXxWKjHcLcwn7UnOI5009nwaop4vmum7CP+oHBXKei7eJ27Vl9l0y+Pvj57hhzhpt818Px
	75SC6li2oD74IFqJcFlI27i9zEJmqD0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=n3Cna5cw;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf30.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643037;
	bh=xB7h3ce2gbt35UPG3jOGIq2cIVnYk+vgnnNmKPQ3hUc=;
	h=From:Subject:Date:To:Cc:From;
	b=n3Cna5cwrHoFXFZwXsYyr7xr8U1JWDVfqk8mrpEf4PO2s+yHzfo9ae9GaHIoF8OAT
	 pZxv9lkhfM75w4QdyKXmE+mYxFbn4uRlRg22lrILG3xbdF/DL60Hb0d1d53sXXv02R
	 62OfOdhoO6A1fBQUiI+iFw7EzH6AhO4EqQgAt/tg=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 00/10] um: remove vDSO passthrough on 32bit x86
Date: Tue, 28 Oct 2025 10:15:35 +0100
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIALeJAGkC/x3MQQ6CMBAF0KuQWTtJHQHRqxAWYL8wiVDSgcaEc
 Hcbl2/zDjJEhdGzOCgiqWlYMq6Xgl5Tv4xg9dkkTir3kIr3+cMRc0jgmwy68WrYfeDkLXAzOLl
 LiaaWmnKxRrz1++/b7jx/CUHeqW4AAAA=
X-Change-ID: 20250925-uml-remove-32bit-pseudo-vdso-8b02724e8626
To: Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>
Cc: linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=1974;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=xB7h3ce2gbt35UPG3jOGIq2cIVnYk+vgnnNmKPQ3hUc=;
 b=fy3Gznoqa4idS4vD+Qw7c736OSjfulXJWRQdumuwvFU5YCVJrhuicwaakAQoBCgYhdehVlJzU
 ntwkq3FfWbvCXZdNvbbkRNDKA4+YT8j8iaJXv5Yyc1gTYwqKH/G2rWl
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Queue-Id: 85CB280007
X-Rspamd-Server: rspam02
X-Stat-Signature: nw4rmh3iyuxgdbdjq653k9r41actijng
X-HE-Tag: 1761643041-285623
X-HE-Meta: U2FsdGVkX1+vSOcIPj9s4K/9r90/SupKp+9un9v7n5IJULLnZH3bjFPZoVeQDSkdfoLmPL0hmhLIKcoWP+6w/M5yUdA/pBmr8Ks13BwbfRgGVvXwtZHmCw9/OgER5HwRbWXUygfF8NEOBddRPnjOZXXLgi47KqVVinyzxdE2rKN43uT8q1djeXh6UPxxxJwmnUUY1VAymSxQ8P0N8QPRiotOtCu4JL82Zl9gZ3v7QFzlzAas3PgdQtVkvZeD4LqYZ8fz1ZeRTi41fAGRZQTV6mGai7U5ZQg+OvybP8fnYygBNGnc5exq4+4YFdoMdA7qcnN6yI+wfrCgjYPPyzm/nu8KIso5UzvNxeTAUNOVcKf6j+IUOwOVkaUgpjA2tQDbCNPrlxIrECdtw3um/53rOuM6yzE0hp0A4Kb7OJU7/339AK6E4/wuI8Ftaa3OOud5nPhH1zdw+1Bcsf5LVkCal+4rhMMooE3ZO1SR27Ml+6sWvKAzcauNNH+ajfFCvheJfxbjL8l3jWbVJ8xZpwT3cSELe8iWP+GfJ5uSzflXZFFv1jBUTeZfPHWXDCRlushdsRAlIfk7/RmP2hySpiw5noZqMsxC6yRzNd6DNKlEu6vyV608iTVTzZMfQwmdIptpIzjB8+hnFv3pFMCKtpTE47a/EHvbGwTs/iRzqTtSLcHI82OuXof5SiWPU6dGAHwc9UrwtNfgMgz/giaT14GYcPDrMDjVvQ0Rsb4vdnE5jT6wy2wgNJ+PaiAQS7X0Fv5DR/eirwUC4FRMZoI9OA+CMqkeOqZEaxopMm4UQty0HxtsW2LtGs50RCQDQ1jQKPAGPNVVw+tTt6BA1w7ntiuIQtiXtbEgFpkDCohu0OutN4IuOH6pQ2svUaZ+F82SA2IHe0E0uLghVrKi1xXIGHpk2Vj2Jn5RK3ybYNrlm9kp7fBfX9a+4O9fEzPRcGEpLPO7bDhMksm0qu4eVw4VPON
 yOHOHvgt
 ZbxaWu3bAiNE6YExeaQArEqO3vItPEh6vSsq4mX8Z+z/wr6roj0PtfPrvWOyWWPZ4uz7kpEHWZcRMNXN9CPYNaCVH4A+6ykmsZOqJAMPQkme5Ud6i7n5UT4kKNUxfBWSn8rDdBMfpMbEWn6wVqPxc2F7JQU4B0ZOYg2gzVP0gN9Q1IXw30Yoo2+9xXDTeeLmvLq+HLp/qvP/dRypsnQjiU5FB2V7ZYF9rbUizGqkZjk7Laqbs2Mr/2BsC1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inheriting the vDSO from the host is problematic. The values read
from the time functions will not be correct for the UML kernel.
Furthermore the start and end of the vDSO are not stable or
detectable by userspace. Specifically the vDSO datapages start
before AT_SYSINFO_EHDR and the vDSO itself is larger than a single page.

This codepath is only used on 32bit x86 UML. In my testing with both
32bit and 64bit hosts the passthrough functionality has always been
disabled anyways due to the checks against envp in scan_elf_aux().

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
Thomas Weißschuh (10):
      um: Split out default elf_aux_platform
      x86/um: Move ELF_PLATFORM fallback to x86-specific code
      um: Split out default elf_aux_hwcap
      x86/um: Do not inherit vDSO from host
      x86/um: Drop gate area handling
      um: Remove fixaddr_user_init()
      um: Remove redundant range check from __access_ok_vsyscall()
      um: Remove __access_ok_vsyscall()
      x86/um: Remove FIXADDR_USER_START and FIXADDR_USE_END
      um: Always set up AT_HWCAP and AT_PLATFORM

 arch/um/include/asm/page.h    |   4 --
 arch/um/include/asm/uaccess.h |   9 +---
 arch/um/kernel/mem.c          | 107 ------------------------------------------
 arch/um/os-Linux/Makefile     |   4 +-
 arch/um/os-Linux/elf_aux.c    |  37 +++------------
 arch/um/os-Linux/main.c       |   4 --
 arch/um/os-Linux/user_syms.c  |   6 ---
 arch/x86/um/Kconfig           |   4 --
 arch/x86/um/Makefile          |   5 +-
 arch/x86/um/asm/elf.h         |  39 ++-------------
 arch/x86/um/elfcore.c         |  78 ------------------------------
 arch/x86/um/mem_32.c          |  50 --------------------
 12 files changed, 15 insertions(+), 332 deletions(-)
---
base-commit: 83e4187d1b952c36ffc2d01a2e532ad8a9e80a76
change-id: 20250925-uml-remove-32bit-pseudo-vdso-8b02724e8626

Best regards,
-- 
Thomas Weißschuh <linux@weissschuh.net>


