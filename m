Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ED53CCF9EE
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 09:17:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D2280130; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DE648012F; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554FF8012E; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2998280130
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:17:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0EB458CA9
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:26 +0000 (UTC)
X-FDA: 84046969692.23.BC57A38
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	by imf12.hostedemail.com (Postfix) with ESMTP id D3A5D4000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:17:24 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=EMVGtZMP;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf12.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761643045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r+OpakVxPJ/8rFYZ6shm+dgcRKRinbxn3aHYzX6Nx9A=;
	b=ISEegNVX9ghe3gps6rVS/sPJaaxk8IZjAAUVDyfYvbxNamoU9oX1SquhGSlP1hHMisrV9C
	1jBSiaP3Tv3rOOVqRl6441nHc/+Ca74q5+mKFkeeMBs6rA2wJRLQd71TQi1drWOOR23Tm0
	uFdtFmyJVxsJiyLPA169UomBKzQgRus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761643045; a=rsa-sha256;
	cv=none;
	b=35BQbVsBGvWTfmns33nU93I5ISSjBC+eqjkpc8yHxzTzf+0gquSOQxU/yhMcq1za6oWvg4
	HjrU2+IsO3HxIXcqmGOTNq+3Qw4+diNirotw54Z9z7ld5TKzk5hC7t9obaq351xgljPlYH
	WauPJTE9odi6hNFAEEBehfEZCxtucQo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=weissschuh.net header.s=mail header.b=EMVGtZMP;
	dmarc=pass (policy=quarantine) header.from=weissschuh.net;
	spf=pass (imf12.hostedemail.com: domain of linux@weissschuh.net designates 159.69.126.157 as permitted sender) smtp.mailfrom=linux@weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1761643039;
	bh=QvY+nAXDRHky/oaQZhIuoK3hf3WfhaB7cgzN/dQrG7M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=EMVGtZMPhsecf5rpkJJ/jcc3uyvDjTFHD2vNe/tl526UmuYjZKm36042T/jZYyorp
	 fvLPcNE5mwYXs0SzI2Et9znl+dcWpVVVSfbmN7Bq3fMSrcw4jQr2MMgH6IjpcKI0z6
	 1x3jeHenNrFto9cZMgy3jsqz9/MfdcOnj4CBY3Mg=
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Date: Tue, 28 Oct 2025 10:15:44 +0100
Subject: [PATCH 09/10] x86/um: Remove FIXADDR_USER_START and
 FIXADDR_USE_END
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20251028-uml-remove-32bit-pseudo-vdso-v1-9-e930063eff5f@weissschuh.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1761643036; l=1070;
 i=linux@weissschuh.net; s=20221212; h=from:subject:message-id;
 bh=QvY+nAXDRHky/oaQZhIuoK3hf3WfhaB7cgzN/dQrG7M=;
 b=6eLwZ6/9TeBOy4ZjspiFcrQRDfICig8yzA6Y3xnYNYR2RoI6gjbrzGzbn6VKROBqqC7L1VjTm
 x5TBTjM7lAGDRSthAoXmnP69TGoARREVZ8AWHbT3bsy56gshRzuxU42
X-Developer-Key: i=linux@weissschuh.net; a=ed25519;
 pk=KcycQgFPX2wGR5azS7RhpBqedglOZVgRPfdFSPB1LNw=
X-Rspam-User: 
X-Rspamd-Queue-Id: D3A5D4000F
X-Rspamd-Server: rspam02
X-Stat-Signature: qehmkf3x3sxqghooe6a1sr7ao87uimji
X-HE-Tag: 1761643044-923111
X-HE-Meta: U2FsdGVkX19BjTquZ383pFUnEZWN+lqzKh3Pkf/QW7DJNDAqgC9PAU5ehyqf+Q8ASkKpXfEY/4bPXWidMJ0nsJkMEv7GXQmDCZPQvvfTHXjS6rJK6h2JzrlnDWAJxA+OAVKx7HSL680osDpvCKAEV7FQQqOXkzWkIuvM9SO62J7LRCvPvIr7LYJq4G1U1t+yXRCHQcUGAUITcRsdBHBN7KgfjUsWNevoHVGNgHaZPbFFbt1eyxs5mOpZmuoABOprshvrTJh1REMtfb6p7XYFLxEb1ej3vs+8x2QeyKK5tx1gzeNLvBwW8GIltrcDQXhIxH52dsXwKUqA90XhWOC1ZLFH3FFVuxhxMB/Rf5DUu9WWJ5vUjoxty17Vc+JVLLtVe7IU+dZC6HAvy6tv7bD0tLECQ39kzbxux96eISOUGQFkbRoF5yycHlRiQl+kzVV3GYpG9l7Frs1o6LYyM5Zp79dGAOTQaRdy8eIG92nahkGjKNfoeQ+CyZufdyd0x9YEnb7iKRTo1mDiD3X4NMeen7WrpAln5O26+r27d+6FQ5kPVCrrXzcGtvvlMAhaXvF/3D9rYNJaxdh5Z4RJ0n2i06IrbjPSNum2RO+omeiij71W+p7XgmscJrkM3ViFrk3Y4AUzEHYXckWhTJvnRbq3RVrcdMiRwdCcmQ+GLeUKMFoqgAip5HtTWY9uc0Akiw6EEgeiVjwvh4KFMjh64ffQrIzXTEpC+9mGdpF1H3GKNBjfoo7b8574VVX2iKrFXcy8g7fapWmK+enTEKOM+NrZxgNf5FAThoTc4UIWN0lJMLxaiB1Dl9GV4vHfqqOWeb8uA07o/52/Eq8mKA6CaurNU9gfdcCvuUiIDYMyH+WKJ8wrdhY3+/ZFDemvQnQ1Y/EhypOe5Z1vnW6MsDyp6jyQUls6jMy/Y60LiSxT3H8PfyCxOSGkujva/uYtC9dmW8xdHTLhXrLmr8W9D5Qj3+r
 AS5doPhe
 8bA3K8eaAcid3Hn17XVvQHw7uxBvc0/PFdZGT4rtqDyTzMzGohNfwfdamO9T3puhbtmqCmX945Z61uqnoOcQrmrZ+jke4B1POY7yoYghMCp7tZUECwUhZSLTcP1j5pU0ZA8Du0enk4qr4L2IQdlQuIkvjDSUotIKBE8K3ZjikcjB2p6zG1S939Evrefm+S1JK8mbh7YFBK3g7bbGr05kikSu06zDKovweWX67p5F5SxUfdmIuQ1LJy8DCwaJiLwlcpLVtL9mn7AfEl7NQbKVzsq1ROtHK4Fv+i71DCu8v8DI3ZLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no users left.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
---
 arch/x86/um/asm/elf.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 8d7df4684c38..fdd5a612f678 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -72,10 +72,6 @@ extern char * elf_aux_platform;
 #define ELF_PLATFORM_FALLBACK "i586"
 #define ELF_PLATFORM (elf_aux_platform ?: ELF_PLATFORM_FALLBACK)
 
-/* No user-accessible fixmap addresses, i.e. vsyscall */
-#define FIXADDR_USER_START      0
-#define FIXADDR_USER_END        0
-
 #else
 
 /* x86-64 relocation types, taken from asm-x86_64/elf.h */
@@ -157,10 +153,6 @@ extern char * elf_aux_platform;
 
 #define ELF_PLATFORM "x86_64"
 
-/* No user-accessible fixmap addresses, i.e. vsyscall */
-#define FIXADDR_USER_START      0
-#define FIXADDR_USER_END        0
-
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES 1
 struct linux_binprm;
 extern int arch_setup_additional_pages(struct linux_binprm *bprm,

-- 
2.51.1.dirty


