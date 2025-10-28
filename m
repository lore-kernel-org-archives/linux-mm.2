Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4608DCCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F8908E0141; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF9B8E018C; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705F58E0141; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 57E5F8E0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D8C181A040F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:22 +0000 (UTC)
X-FDA: 84046969524.13.78E76BF
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E0651A0014
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=U+a6P211;
	spf=pass (imf19.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooKBC1eDKfdKcleVvvkixZdpBL8Ich2YbLbfX/B4glQ=;
	b=3J3YDLxGJSMwpjXThAMIktDVdJwnBqShr21I8KZeMFa6Cqn/8TjS5OF0BOopfWgagyWVyI
	hqld0cnAklgVXcT55BP1vIMsh7t4QNYSRbvRlT6PG9q/YEyTgeYeCtgI8SJL/s+hJprMu3
	+FQfm4E8sA0HzT1KmUt0Jqa/nDPDgs4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=U+a6P211;
	spf=pass (imf19.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643041; a=rsa-sha256;
	cv=none;
	b=AdpKXPnr0EmwqyquXAjyi70Y0OnFW7UhQkYig/cP8gUJqpWnrgP0jGGwQGDjrNZYXTz0xN
	iVUUQoof+Fvk/0KAAKWCS2QEziWIGDTOVTAjE6tQs9qxNBuTELcqaXtCkuVLdCSoIDfBr7
	PuIqsLwvI1DOkx4oy1IDbgHDCmfV+PY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643037;
	bh=pLpK9WMmHxQL+UmXL2BRNL9YHlr3HJAmGpPpWZh9za0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=U+a6P211/4XvUxWAKsYQOUFks4HNaWzQk8OLSQf9m41OMxtrAQAM4Bw89Ces0WUiX
	 v0AHKlr7R/J5zIR02pXLsR95jwlpU7cs9/lmyuvXp6pFW5X9JIFdzeidNG9xyOlrHO
	 2uNN9h3tYOgq87JRV/pzbYC8noegWMFq7VlBTxdE=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:38 +0100
Subject: [PATCH 03/10] um: Split out default elf_aux_hwcap
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-3-e930063eff5f@weissschuh.net>
References: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
In-Reply-To: <20251028-uml-remove-32bit-pseudo-vdso-v1-0-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=941;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=pLpK9WMmHxQL+UmXL2BRNL9YHlr3HJAmGpPpWZh9za0=;
 b=O5gJ+jOwEsAHrk5KZPP4TwQau/fdz95vgKIKxfOYVp6/PV/ok0lwndsYaEsJfWY4HcGigVgsg
 LyWjDLG7c/TBFz9ODtVE6y69f4yeLZPtk2aonTCktjVxwFlAwClOMI2
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Stat-Signature: 5mddwrewfhrgd93o4ez3t6h4bo4599df
X-Rspamd-Queue-Id: 2E0651A0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761643040-516852
X-HE-Meta: U2FsdGVkX1+gUBolMZttF4Z6wDmYtZxq26YRreVyKSwONleVUtQ8QjLtUcImDtUJkWPWq4LFFmbtPJgtr3C96sG7odQZWhkBPNao7tLGcHhg7he6HskOBM//WFfZlY2R1l+aP6WTikGd6FZNo8JhHooIaX5wboqOZKhLzxjCzl6WUzWzjbWiYiTzmDUBobezLv6u6TaTY3yqt6HjYQoYNXwQQwyX369kQy3JblGBuL0yPkzTTI2+VXMWf5vqEzFCIxb+wRb8IEtcErfL2J8S8sbo/RhEBnz+CNWucPlqzE3UXS8JnAfqTGo7pI9TIwoSZB0a9S69LlY72p/9Nv4xuJ5Yix5GD3kzy8iTGdl9yBxJSxxF25gmNB+iPIEyJF25g5SjuAFmkqJ23sbz7eHHB04xuW58M9cue75eqjIU2zMv6z4lM/NE73IOjUL/gLhsyfXk/sLFrfLF+vme1YOtRjqLZDnkjuZ1veJTStOGlUZ+V/u+3DqGpalYqqJjsPSeoljZGjxQXC+ATo06WhWKQ6wmfqfRwILuhHn5Aifj2r6swWhWtZPb/TbfCQZt/ULQX2kuPagea0R22kn+THznmZ4bLnLEkV7NuQgA834A0tGOa3ziz1eILGQnQbDBotDS5b3AJFTAc2LFV3ntwJpNVHzzi6UeikXhPlYkC1GeqttTL/rjTeIeCohxBVaf3UtzF+/jZlus3ExzgaTneBJ2sNcTsFWq3myPhiDqyTK0yW12yLcKNdVvBxNxLN0S3x0MQ4JQVj3GzFMdpfiWlqfuST/Npafs6Mz75V9G+5+kPac4mgzRK1hkumqg/sRlOXOVQDe699G9NUdZOPnsC3TftY/7OnWRF6PhQb0IF0z9nlrzhJqz976ys/bO98/X/m9JkakdB5z3ShY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setting all auxiliary vector values to default values if one of them
was not provided by the host will discard perfectly fine values.

Remove the elf_aux_platform fallback from the vDSO ones.
As zero is the correct fallback anyways, don't create a new conditional.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/os-Linux/elf_aux.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index 4aadb9ea5ae3..9ee0e3199790 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -62,11 +62,9 @@ __init void scan_elf_aux( char **envp)
 		}
 	}
 	if ( ! __kernel_vsyscall || ! vsyscall_ehdr ||
-	     ! elf_aux_hwcap ||
 	     ! page_size || (vsyscall_ehdr % page_size) ) {
 		__kernel_vsyscall = 0;
 		vsyscall_ehdr = 0;
-		elf_aux_hwcap = 0;
 	}
 	else {
 		vsyscall_end = vsyscall_ehdr + page_size;

-- 
2.51.1.dirty


