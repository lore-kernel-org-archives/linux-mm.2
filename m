Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D7BCCF9EF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7498E0006; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAFA58E018F; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B85F8E0006; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37E1B8E0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:24 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05A811402F1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
X-FDA: 84046969608.20.70BC17C
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6676FA0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=A7PL0Uet;
	spf=pass (imf25.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2l+TS1LMPx7p4hg9dw/BzaoTvSuCmUu6gVv2GXD+OOk=;
	b=pI1oa/kIA1H8PQDX7ijsrqFyhjKpkfWD1r2iCpGOijr21S72CT4tdCUFY1plHsMVLAhD8h
	Yxv0oGEIxvYJsqa/QcQijIYcoLm/tv4bUZH8we2bJ/WOyQQU3dvmSzpm0KiauLBosgxCsc
	u+MO6Jo6lTc3WXYrIkfLkZggBmoe0I8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=A7PL0Uet;
	spf=pass (imf25.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643042; a=rsa-sha256;
	cv=none;
	b=XlfNIMxHxN0VHu27BAMM2o5e+cvK7hWoYM2KK8Df3XrWc3Hy/J3tMdRVG3kfzLCe9FiSAV
	GjFDdEU++9Qi5U5q+yl0pqfSqLd6AbwkkJsRx8vgzqMW3VtMFWGVD4H1pvAzYru84BXQQM
	UKq9lqKfE/+8ftmN0tqQTIodaX+fqRI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643037;
	bh=wVCfXhX9gFOuIM1xQSYX/MuDADsnjta9ksjbCV8j1aI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=A7PL0Uetb0vlc4ijKa9jjavmz5+neq80T0IwIUe00l43iq8uhX14/EuBt+ppWAmDl
	 KUf0q8mnw6o2DB3eCoB98duMuZSTfwBSxMkqpziZzyXFjCEzZw2205LxAL7wXOtD3W
	 32oxXXyxHPoHZBqibMOS/9ma5dHYKOaK9T1jjWzo=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:36 +0100
Subject: [PATCH 01/10] um: Split out default elf_aux_platform
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-1-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=1040;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=wVCfXhX9gFOuIM1xQSYX/MuDADsnjta9ksjbCV8j1aI=;
 b=LhVFRghTmmP714gZhBulmaoihKd0f0VHzMs3eM+Bz2Cmqsv3SkDHbn+Naifonr7vh0qOBz1qm
 +z67DoHCAyeBU8AmUiQXuyNKzejI1lEP2jTG2CUIC4+3TqOBckzoq7J
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6676FA0006
X-Stat-Signature: s1kadx64t99aodi67dafr59as5zfj18g
X-Rspam-User: 
X-HE-Tag: 1761643042-212500
X-HE-Meta: U2FsdGVkX1/iNSNfSba1Q7Iol2aTo4eSa4dEfErYwtZPFIhy7S+0PPRyU7O++2fClAV2veZUkYpDaj6uiiKKEwxipjnm5DBFZkfBFwxAABRVyjzDzdeWS6/36K6FTuLlVx9cLbq0FqGnMTrBUvQZ5osoTxeDzD4VeAscG+Q9UvLQcEwZyV2jgscsQtbsI3dHj6Sxaa8hh6P8qBsu4851W0axYBmcuMn9/Vl1v4YWO5uOblIQIXeDwZKXfcIm3sAmfuFC7WiJvmf6+frbuQWScsYFj20LHJ9UjVIY8qi7/IaCkBIipadrk6Mh+aBr1VL7o5ZJNDVXAJUkYjV8rjWB3JsTyOeEmW+kd071eThRL/yK+2IaDx6FyzVJYksLBgdDc75M3bFzZppAQP9Sy29Vh8WLqphtkWKxeFKNelZOyJDF8MucvG1uaQYA/cpfXSmhTTnkObbbmZv2eDJvw3kVP60ls21iAApEWqQPWHwHLm/klDYBsMkth3vsxZxIRff2MSc+W3+Q4OTyG4EVVDslV8YMhdRh3A/ziZv23uWXCQUJ0IS32xGpFQa6Z0uV7/4m4oSlhS3COfPo+MNuyVuvrNL5tnOagz7g0LouqRKW52esBVXxxQY1DJqTJf4IC0Br75u5e4VBipjlX8k+9jVdW5pAMzmYJNoTths40i+jKrZfSkHizgmDIHFQxLyHLiajooQaa5stNbnyf3my0zorGpjP7qASmdZ6A1GmOMofuyrx7ZSzqDt60pIPYz3v2Y+LFC8o+46Al24wXSkTEHBOapqiHqSa1lhgFiX7J/umFI/bvFjtHPheK8hn43+p+ojB2KnxC1ub+PQrqk53pNgBj7+20R6NB2T8qmjcaba/VRl09/MTM6uhQxY8l2/ZrNV1lFz8YcCVNXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Setting all auxiliary vector values to default values if one of them
was not provided by the host will discard perfectly fine values.

Move the elf_aux_platform fallback to its own conditional.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/um/os-Linux/elf_aux.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/os-Linux/elf_aux.c b/arch/um/os-Linux/elf_aux.c
index 0a0f91cf4d6d..a62fe39e85c9 100644
--- a/arch/um/os-Linux/elf_aux.c
+++ b/arch/um/os-Linux/elf_aux.c
@@ -62,14 +62,16 @@ __init void scan_elf_aux( char **envp)
 		}
 	}
 	if ( ! __kernel_vsyscall || ! vsyscall_ehdr ||
-	     ! elf_aux_hwcap || ! elf_aux_platform ||
+	     ! elf_aux_hwcap ||
 	     ! page_size || (vsyscall_ehdr % page_size) ) {
 		__kernel_vsyscall = 0;
 		vsyscall_ehdr = 0;
 		elf_aux_hwcap = 0;
-		elf_aux_platform = "i586";
 	}
 	else {
 		vsyscall_end = vsyscall_ehdr + page_size;
 	}
+
+	if (!elf_aux_platform)
+		elf_aux_platform = "i586";
 }

-- 
2.51.1.dirty


