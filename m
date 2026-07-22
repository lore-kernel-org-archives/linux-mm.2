Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A78C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 18:45:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7436B00AA; Wed, 22 Jul 2026 14:45:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EEB6B00AB; Wed, 22 Jul 2026 14:45:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6464E6B00BB; Wed, 22 Jul 2026 14:45:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDCE6B00BA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:45:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A66F61C0454
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:45:02 +0000 (UTC)
X-FDA: 85017289644.22.0C22FE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id B443B20006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 18:45:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnG2Zqb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784745900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x44uhZbq2B9G2E9nG+czfwtCtF+7aytn//SENl8MBaQ=;
	b=PNr9mihrIIuoSoZDdXwAyqdNPeygri/jj9itPmInMysavz1BQ6Xfe5UBl8GHgoARFDeTh6
	iz5LK70MjpIMolCIaDpGjxZdbnfWIhkl5LpEL2TQGjGZpRBYnZlIiA7E9KiE2nkTNn71ry
	k2dSNa0Fbrof+wuYW1YP+fGONqsrvs0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VnG2Zqb3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784745900;
	b=eozr5gaMvagQY8kPdAhXE0yDL+4m52CbVvzwG521yB6F9U/DyJ8FYhNtpJV9LhfqcgyatK
	1GVPoEqfL2Z8JuHnK/fdeVtmxmw1/NVhUPr+OXJ6zNlusNP5MOxep3+EOsEho8NLSmGYY/
	t0la6B8Entu8YYZa6/qIMeGAl60L3to=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97DFA40621;
	Wed, 22 Jul 2026 18:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DE41F000E9;
	Wed, 22 Jul 2026 18:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784745899;
	bh=x44uhZbq2B9G2E9nG+czfwtCtF+7aytn//SENl8MBaQ=;
	h=From:Date:Subject:To:Cc;
	b=VnG2Zqb3URkf57II21CdKuzRq8Rny3mmyTDuzOgM5COBWIhT2h8jrvP9GFOo3Lti6
	 ePo6HWikoWfq/fG6d4ALd4SnanDRGFVGZQyl5fL7IYCJTSz/c33ld0TuUwly9J0DzN
	 VJ7qR6bUgOt1eSCs2sla+y5Uro9SSORWEDynyIM4fXc2u0jAOLy0B5m1PGZDRkpEfQ
	 bWETfre6N/5x/oWeyReX4VqwP3qntBd9CKMKMLXSByXWWvQippZjMxEuUZ88MVEtW2
	 CmZpzm30AJ9ZlvJ2qm+M2kr5mh8kr0qltv/Xh9/bAIHwqAuTE4Zs+9h2PSmU4HC+do
	 z8fRaWy422GrA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 22 Jul 2026 19:44:43 +0100
Subject: [PATCH] x86/elf: Correct comment for STACK_RND_MASK()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-fix-x86-comment-v1-1-605080af988d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJoPYWoC/yXM0QpAQBCF4VfRXJtitUNeRS5Yg1GWdpGSd7e4/
 Oqc/wLPTthDGV3g+BAviw1I4wjM2NiBUbpgUImiJFcKeznxLAjNMs9sN2x6ItKZzlLdQXitjsP
 kK1b1b7+3E5vtzcB9P5iL1JBzAAAA
X-Change-ID: 20260722-fix-x86-comment-af666535315d
To: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Kees Cook <kees@kernel.org>, Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1357; i=ljs@kernel.org;
 h=from:subject:message-id; bh=ISIwp/sXQobVv07RweLH6MaBMg/gxKujXMAO7JcPE94=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIS+ecG7n9kZMMuPF3q2tay56W3fi+Xye355F829VIzS
 /7uyK4/HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZhIy3yGf2Zp2oYuyUuKJPbt
 8dotlvZ3W9ffpwd/Hw1rvW946/8er7OMDB8ZFqXFur7a9CGKt+ijiGzquwa7fT0HugMmSU7u+q/
 DwAkA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B443B20006
X-Rspam-User: 
X-Stat-Signature: hh1e81gcemmfszdywzoq3kah54bhjj5n
X-HE-Tag: 1784745900-356760
X-HE-Meta: U2FsdGVkX19lVoTuulVRWvd9t0lVuSDXr3/0aY42anx+UHGLJfXx2H9d0kfNxOols8SjILr7gTn7kLK7smwvUZ8QQx1qSpE+EPOU9NASjyGz8HhBvmHCFdRj6lVT1LrBp3IYqLRULgRRwkn5ZLY7RN4FN/YcFAGihtZIZ+4CD/r7PdgdYNKgIHFOTbx/5gdEpUoHfhOv9QfMCFc6eyIn8Y1lZRK37hpKV9bJO9edTVM8KNj5KRWCfyHE0TeRiMkYBLGteJS2mSvojbQEPPUcy0BVbdBam1X2iL4SW7hItVXxCcaejMxHn07wXahMDj1cLIBnHJ/nlvFxJNQ0BKeU2h+KLbplZPR+OQOZILpvl5YImDNYntH5I0i7fqPsHHYJhwO3RBygxnHRTNV7Vcm0ujCgzyW+KpD94i9oQY2cPscHlXtW/zdiDaCKtqFkQ4amUJKCvLGv4gVCKcJheabPCL2zJyy+Z0enH0wM083pa286pTVjX/GZ1QFmBo3C13zI7uFgeahE/hD/QR0gnkN6A5Rf+JOw65HxVChx/xLV9Rlbd7h0Now3ItrTRq6Fj8K9ktfBvRb78EYC6XqZyheYlwwaKxpj3FOwJGnsCdfXOHwJxju3kj0q2vT7LEDHLsaf7WFUmvDEyPveOQOxG6GfWl2Sp6UAOEF1aZqHQPtEWFJdCZnZBit0gfoEBEK3i9cpLaHNDdBZN81eqCErPqkTzo24tCo35oULm9d4pb41gOsaY7xGMAEWgxkFjtog2fW2KSC3BQNfivUu9+ah01Cs4jLuOyXxAi49AFtjoGnTTx98eo8FuepvdjNT0vzmcqRF/AHdr6DtgFt+0vUHOWUrlbSN7cmzoymvVR3tIcORsIV83fEx9JcNfUmYYgFrXplLvhvUO4EjCsPOAbIoKIm/Jvo6PUQXLmm9b6UPTkVu3TZqbQmA3UoPtcyJpQLgP1BAhWAgB0rN8FkGEVpucvm
 vQ3ZvCEY
 FwlHUgBaVAfAbiGOblKIdO1VWx+PieZlmLyLhYGwU/vlflGkkfjWuZ48x4+USaWDsLRHPP4/saoyHBTuOgeMndDSrbHuasonIVTdWUbl59yVVD1B87Og+gtqT+lpq745UNFpn3b1Akh6QjoDGRx1K6LPLQ320Q8km2LxvMXlcc/lFJnI60lm+oE1ibEVuBj2JXjXMDMnp7CK3b8y7aklxTUHYLH0svF69Olf1QMJHlCzXyj+k0+soyx7/nah1arNkLBSPgqCOAXYRfPszfia+W6V4TXtw+j8MycTC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 913bd9060195 ("[PATCH] x86_64: Increase the variability of the
process stack on 64bit architectures"), merged in 2006, increased stack
randomisation from 8 MiB to an ostensible 1 GiB for 64-bit systems.

However the commit actually introduced a mask of 0x3fffff * 4 KiB pages
which provides 16 GiB of randomisation, not 1 GiB.

It appears Andi perhaps typo'd an additional 'f', as 0x3ffff would indeed
provide the stated 1 GiB.

Since this value has been in use for 20 years it seems sensible to retain
it, so correct the comment instead.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 arch/x86/include/asm/elf.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 0de9df759c99..4133c790e71a 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -322,7 +322,7 @@ extern unsigned long get_sigframe_size(void);
 
 #else /* CONFIG_X86_32 */
 
-/* 1GB for 64bit, 8MB for 32bit */
+/* 16GB for 64bit, 8MB for 32bit */
 #define __STACK_RND_MASK(is32bit) ((is32bit) ? 0x7ff : 0x3fffff)
 #define STACK_RND_MASK __STACK_RND_MASK(mmap_is_ia32())
 

---
base-commit: 248951ddc14de84de3910f9b13f51491a8cd91df
change-id: 20260722-fix-x86-comment-af666535315d

Cheers,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


