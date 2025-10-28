Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44130CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BA3D8E018C; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641B38E018F; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46EAD8E018C; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C7EE8012C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D49F013AD7A
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:23 +0000 (UTC)
X-FDA: 84046969566.30.36FBA9C
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1A1372000B
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=CE5XHoGR;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf03.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EiHGljfTW0x0l5Vc7RJb/kYc0HBlu5rG5oIX59OO+Bs=;
	b=LyFhYXLh65j+VpFN1MuRfW56fTpNJj6lNSkuaT9/Wn2920Hr2kX9zozj9g/hRNgKB25h4F
	nAVY/D1BHCSc0jbWPJrj/puMMoWiq4adgSrdi3usHAjOTVbrrGD4XnnSgO3oVS5kEM9gOz
	mfqmiIURMHmNdIXToYDlMVADzktRBHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643042; a=rsa-sha256;
	cv=none;
	b=kqOAjNelUdqcuKeGId8MGwnoa6SCcgWb1bm8JGDsEX46dV+8Uy5s/V9G9gksG7MvZRIXHf
	a9DkPvItEETdSI+HaZI44Ze1nwBsBZHk1WY6p8Vs5ywRtTY+qKLhq+Qqzs/+0czWaQMDyh
	2gW9Iav+E9fOzL9qQghWxwN8ANZPJ+8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=CE5XHoGR;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf03.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643038;
	bh=YqbPywoFtgBAhJ6lpmIQMDms46YwcEmQamcwJS8MPbA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=CE5XHoGRDOoEaApc47qhv03YYfsONq7VVJBZYwGRaTvmwBAKafmHL//ik2DKXPkzf
	 gmwMlPdlLoBW9Pslfdm3bV3rdqFBhSGicrpArS95CHSqRb+3j7c2ofH6sBIUnJNaYX
	 IC6g6scpP8vwjDCqa6dH6izhO9s5oDYMgFcnwOeA=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:37 +0100
Subject: [PATCH 02/10] x86/um: Move ELF_PLATFORM fallback to x86-specific
 code
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-2-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=1152;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=YqbPywoFtgBAhJ6lpmIQMDms46YwcEmQamcwJS8MPbA=;
 b=E3/22t0NPJGkRhdvBg2Xoo5C1xY8YBwldw9w21HcwS212L3vjfQkTyETGfgzLIK9fKxWFFmwW
 ah2FjRnmpmfB6dME8TsAbEtIgVmUPZDKctooDkcmJY7upgfRJ4JUimC
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A1372000B
X-Rspamd-Server: rspam02
X-Stat-Signature: qsj7of8zwzd9z94ukqbrgq3cfaznw5j1
X-HE-Tag: 1761643041-285115
X-HE-Meta: U2FsdGVkX1+7yjWOl+gbK0SxRSczPMLRS4ZZAFfiRrFFWFUy5sZm8u0tPDrW/Lm5UpWnqiUlggqfKxkAXIDAHfuSY9oHM8WlDgcVgL6jrfb89eD8fBHkj7EhiaNvOsGsAhCG6+rrfoe94YxtISfY4SDHQjZkEP2GfyqVVwt8M+gSf5GZ8Gaa2iW+Evwas9xOj2LB8XcmHhk3ZM/s/vpEzzaZ33eGNkoqsoUuPd150coweNO7/oE9sbanIAKnDmBcYumyoKNNytHfe6ahxeAH3OD40aMS171g9A0GgAAEOInA+HfdD4keFyxfEM39jpGj/QE5dOiV06uoca2FeGAhywREY++ryYa2zGFGeg46MC8bDIf1DQjOXeZrs4jLykRVylGF8lDIs2ICHGct9XJ/1kdFYKlTfh5d7A6wiKBd7jxMrzojjf37xgIJGtgKag+gkP2xCzouDtoYGlx8VlIZq9RC70wFQaoy4pOIGn1Aq++Bc7cfZVnCemajW+YoaSYDeQNdv+A7wHG3zSVKh6lXgQYzTWMWJ0UJdLivIMitj3lZwsW3BwtCkFHwUsP8jaTKi7yFvMWZjbX3AK64Mg5SKV2jU3cj+z1eqSFmQdnMB0bL4NVekwoSyuaDB5ZPinM7Sl8KM4w4XE5hOth3W3JBI8IxkI5MeSwNvpquzSbXOZ/I6UgnycUjBKYWRkYZNgH1IzYTdWuFpmHCXEduAnoYh0yBPPVutXYpZAJkdZmO6teYBGATINU+VDuLbuScu5X2fyMCbZDo0AGPBrZkNR35e6Q6H/sJXUREYhiQ9kfnztuBfMRgVKyf2QK2CzwmXC9A9Up6kcTe12Cw+ZPwl7yZVudUkGOKHpt9hEJOl67bzxGZkn8rFYeczyMbGnPh2uGG3/G5bO9utuDwnbeAf/GGkgBCbwbsqth3rDuTPZc4SuX+p4JJ2CB/1HMW49mFHeXi2eNLWowj94IltokCUr7
 cytJBBFC
 dAyKbrycLXRlv8dMSUmFTy9bsPVz25CTITUWDfMxsk5XVUr46CW+96D6rm4Kjrj+3fcVJC4KCfJQh/ep9DB80P2qXrTm2EmcTWW54Wr1lnVjJjWQniHVBJ4+4GwwTVFKr/T3/nMbLPNZyh/5pNjzoyQhHbFay+miBTHFIQGVyNqEkCcgDjYAHphu0aqavZkYCAJMhsxvkfFD1K3kohPmAQZKab0DqPxCjY6x3y83xcB09XdJ1R5Ak1zFgVguFYfjMBd2Oi5aJBEuUV5iemI6wmqRxDK01lkqPxbfFy7uO2rwrZ54=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The generic UM code should not have references to x86-specific value.

Move the fallback into the x86-specific header.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/os-Linux/elf_aux.c | 3 ---
 arch/x86/um/asm/elf.h      | 3 ++-
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index a62fe39e85c9..4aadb9ea5ae3 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -71,7 +71,4 @@ __init void scan_elf_aux( char **envp)
 	else {
 		vsyscall_end = vsyscall_ehdr + page_size;
 	}
-
-	if (!elf_aux_platform)
-		elf_aux_platform = "i586";
 }
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 62ed5d68a978..e7a045e01471 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -69,7 +69,8 @@
 } while (0);
 
 extern char * elf_aux_platform;
-#define ELF_PLATFORM (elf_aux_platform)
+#define ELF_PLATFORM_FALLBACK "i586"
+#define ELF_PLATFORM (elf_aux_platform ?: ELF_PLATFORM_FALLBACK)
 
 extern unsigned long vsyscall_ehdr;
 extern unsigned long vsyscall_end;

-- 
2.51.1.dirty


