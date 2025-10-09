Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F099CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE9F8E0043; Wed,  8 Oct 2025 21:58:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96DC58E0002; Wed,  8 Oct 2025 21:58:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8365B8E0043; Wed,  8 Oct 2025 21:58:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 70DB68E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3ACAC13BEBF
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:56 +0000 (UTC)
X-FDA: 83976917472.06.5BF38F3
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8FC3B40004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QLqhI3fn;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf17.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975134; a=rsa-sha256;
	cv=none;
	b=4QA2WaQfa5a6o64B/GwW5V3PRr7xSRIovzyKsaj0yvjsj6IQUllPfkg/iGBZT2dQmSPnAY
	2cMFVIoWXMKUadjhrx/2L+TWk/GTcohPcnGjz5w+ATYU37LgQPRAfWQh22LX4gEo8KWmCU
	v2OYpbkhDctCzY1Y/tEQvYwH58lrIVk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=QLqhI3fn;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf17.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FfdCPw2IgJr1hV5CQEQggBFG3P5nbVH7ubzcz6g7ycw=;
	b=bsZRJA5XN8IqiiZL+DUta3RHm9Ou2pU8raQaAC+lbFFQYigo0vuK/EaFdQ152YHp/nTcU+
	kgBIJmMW/z9hUhHLjp53DyrdMs+F6dDvG8D7WQ+q5MvviLurIw61zRGMD/3y+wSIZMJ/Ck
	1eEkmUKzTp8Q1ZUbcTNZys6VFgdTKNI=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-271d1305ad7so7151995ad.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975133; x=1760579933; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FfdCPw2IgJr1hV5CQEQggBFG3P5nbVH7ubzcz6g7ycw=;
        b=QLqhI3fnYGirg0t9lRltt4OI7py2PrC0lpcuxJoCCQT7ROJQANjH3mOGOLyVdppolw
         Ew4cUwO4PT0+DXlTMqQBV+OKNxTJFYXSaEjmBXc3ehPv9YpKefc6b5G4de6nf14f+Ezm
         J+TmHHFtxFzRHgqXX+5eXOEbojTwQdThxDEnrb4qcUHUW6eBlPGIS0mc7A+BMjpUS5Kz
         VrU5+WpDzJnsudAO4mLmG+wteAAuc1da4Di4Ds2nTHwGxH/b+DSm12Yo9bHIUuoMMt60
         pgdHSMHaK75qzWJSjAYbFPW2QKzhfptePRc3GK8MxlVb/IVXC8HQxWfDOd251pB0S5si
         vaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975133; x=1760579933;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FfdCPw2IgJr1hV5CQEQggBFG3P5nbVH7ubzcz6g7ycw=;
        b=Yr1SuvuVkGkeXlwNT0QSdMOMeuTbzGwgGsYQQ5DSo9VSTKmMCw1Z3D5HmnIyBREj3y
         DLJ7cVL3nyFGuObfvKNqr7LkukLMToqOa72CwF1OjxiMEFiKvzBHdmxrEY1lhwPTcpHV
         MCq/5BKuMXH75J6gdijwtsHyb0oEK7V9NI64VjKSvS03h70qnIBkLov4cm4fBEF8Ea9M
         ijtlVvEYZQR4mLJXNG0rlc1T+Jekp1e50eHjKpNbTfvLIQmwnH23+K/jOXObc9SG08Ki
         3HltaGGApFz6ZF5G4l312W2l6ak9ebZp0GA+I1ZqwkEz9s0IhwZ6bDVSpf+0HpxEIVqi
         3wVg==
X-Forwarded-Encrypted: i=1; AJvYcCUW41byZXi0QJn7lKwOLfzjB/EVIkirtSWHFSwy7NyZCIP4lXEJtQmPkW02kbxTb/n+a4ts1lSExg==@kvack.org
X-Gm-Message-State: AOJu0YwFybEQNkHnNpC1oPQA+W4rxZSO+sysxGLpDpW8vwWoGcffc11C
	FgurZ2JHXWwmODbbE4Ph+Z4n1movxqPTR9yP8WLrAdPegjPLdMWLC2h0rcbhMF9beyk=
X-Gm-Gg: ASbGncvRCr9VsW0CR+CbTTnTUfLrM2p8wZ+PkxSY+g+JIl5DVeWVkUxOvjcoqN/zN51
	ntgphGcxb9uWwQOR1ghe1rnA1i1FonV9OUtOybmhIxSB48ObrJI0mzpft5UHwhVv/E2R3/CzS3f
	b7rwGWFusOU9Dxcl6YJtM0uD+NKi4I7ZLljCfCroWnCgOeuIzBklwLjYClYr9Nmy+DlXfhHSXmN
	vfY54CBv/VTZALp2UsJc1yacNgOk2a9gggw24Iyhlm9Hs0zQfv4rOBHrawbb5vfNn9AMU1hWjtR
	V3LL8Z+WgHWfBT/kVVbPy4klD7HwqZs7zjVZKgY2odqZuSpERO3uqgdN87c3mFOnSEIye7/T0R4
	gjM9biZMcgrPItt5Rob3ufidgMHOlJqsFRUJwmMkMTehYZF1pfugHL8puSKwGIDKzdQDu
X-Google-Smtp-Source: AGHT+IECa/siV4SXNVKe+S+DKZ7Fr1sjCiPZn21F/lR8t8KUoN1d0luw1JkzSMcpjXsSdsF0G571uw==
X-Received: by 2002:a17:903:94f:b0:290:26fb:2b91 with SMTP id d9443c01a7336-2902724dc96mr73646385ad.0.1759975133415;
        Wed, 08 Oct 2025 18:58:53 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:53 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: [PATCH v2 10/18] riscv: ptdump: Only show N and MT bits when enabled in the kernel
Date: Wed,  8 Oct 2025 18:57:46 -0700
Message-ID: <20251009015839.3460231-11-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 17h13q5bnrcfutpind38wmx9ta71s7yp
X-Rspamd-Queue-Id: 8FC3B40004
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759975134-223612
X-HE-Meta: U2FsdGVkX1+X+mD2+DV11f3yS4bHXMJcxCWZY0smhWmKKaZFuznRK2s7CXrsmb7weS8SXrjG+qrGVWngZlbaSNgI3UTyUsigC4SFonDmovy3WN2MSLxEiRVZO8c4EDTTcX7ow22D+/XC8US5JRw2iPdFj+m8WgmV+ZGDuJ/raGfsh0Sy5ZfTw6ynUPiUeL5SDfXM05quEzR/dgzdPY6TQ6yv04dwSjhFRbmFzQfDxqZ7ssqLq/63ZZbCxRofypUm7xfzXI1Tj7KuBS11FQOPIYqYzM0/e49WBOwTQE0dOFOLRFyXUIWFZZKtDOaaAyb02AR1uEQFXZAJvGhdSKvMAKhhI3Byh6EtkgrJQqYgXuqRoKAmNoNM2UsWLMps4hw6XNWGCcr27u00tveYgTgqJszTzHpqeTjxMWxS3p/JS7ceVxAuoFgqCzZTqRnLzEai1k31Ou3HTJ7cHVDtc5yM5cHdcu+ogUgomfNQ2P5voULvA+P8uzR33Pk1SGghMpfJ1ajzclASJmWDAWKkFbiTPL9qIKBgXU8zCdJaa4e/EJFNPHpYE3kGBPKAuQD8XkYTfpBq41qxYMg2UGu8lfAzhvLAwRN5XD1tsafYA2Ju35jQdxD97OHh8BsvW8wufumWavAlZHNJUquNV25lO/O3Xb2tOGga3g7KRs5LgVAlVj69vgRLK4LegKw4L+Q+Bu2JSEb/Z0aUMymARXVv79T9bWxdjhB42FUPpi1IyhAeLxl4X5zdFFtuDvLiI2wRl487y6cyFLyucWsDkRSGAR+qtpP+3YAexh53FosnbYxXmb6aM8OnK527RO72TVLH1GwenDA0Zn7oUNDVAmS3Y0sSIfCLbcFghp91R8CFl69pZF/sd6LcDb6De7SYI9+ItMuTUw0Bi9uDklLqJyDGgSsfxIqdqRLa6zpobNKCwwOvnhO2EIJLuSOyf0Ldls7NGVsojmXGWFvkYrsvAZxMZuY
 PEhGqvD/
 OsdjQNQHo+hOmz16bLXDIXZT6w31VkgMIiB2hx75OMHSxzAo377JWAn/Lf3DWKAsjexM6dycn+Mzg7ojMD7OqvZq1sp40/G1IZ2tD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the Svnapot or Svpbmt extension is not implemented, the
corresponding page table bits are reserved, and must be zero. There is
no need to show them in the ptdump output.

When the Kconfig option for an extension is disabled, we assume it is
not implemented. In that case, the kernel may provide a fallback
definition for the fields, like how _PAGE_MTMASK is defined on riscv32.
Using those fallback definitions in ptdump would produce incorrect
results. To avoid this, hide the fields from the ptdump output.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/mm/ptdump.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/mm/ptdump.c b/arch/riscv/mm/ptdump.c
index 3b51690cc8760..6608162459ae0 100644
--- a/arch/riscv/mm/ptdump.c
+++ b/arch/riscv/mm/ptdump.c
@@ -134,11 +134,13 @@ struct prot_bits {
 
 static const struct prot_bits pte_bits[] = {
 	{
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_RISCV_ISA_SVNAPOT
 		.mask = _PAGE_NAPOT,
 		.set = "N",
 		.clear = ".",
 	}, {
+#endif
+#ifdef CONFIG_RISCV_ISA_SVPBMT
 		.mask = _PAGE_MTMASK_SVPBMT,
 		.set = "MT(%s)",
 		.clear = "  ..  ",
@@ -214,7 +216,7 @@ static void dump_prot(struct pg_state *st)
 		if (val) {
 			if (pte_bits[i].mask == _PAGE_SOFT)
 				sprintf(s, pte_bits[i].set, val >> 8);
-#ifdef CONFIG_64BIT
+#ifdef CONFIG_RISCV_ISA_SVPBMT
 			else if (pte_bits[i].mask == _PAGE_MTMASK_SVPBMT) {
 				if (val == _PAGE_NOCACHE_SVPBMT)
 					sprintf(s, pte_bits[i].set, "NC");
-- 
2.47.2


