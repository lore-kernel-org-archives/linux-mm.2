Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D83BECD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BACDE8E0031; Wed, 12 Nov 2025 20:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABFE88E002F; Wed, 12 Nov 2025 20:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFEA8E0031; Wed, 12 Nov 2025 20:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84B8C8E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:26 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 52163C04A3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:26 +0000 (UTC)
X-FDA: 84103896492.13.3F56F6C
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B2E1C000E
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=JX1Zna97;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998444; a=rsa-sha256;
	cv=none;
	b=OhHJBIWD0WM9TKKe5y+4v2uPbZCBL2MGNXNjCk/TRr3kKe1JPzrePcMq+aC+0GVrcH5U4q
	D8NfZE9vEVgetH7S/lMTmNH7uI81xFEmbgzEsBxsnrT+fAm2v4TLvhriE0MFFG5G6u1CX8
	A+dzyhrkWgJmujveyhp3f/CXuaVU0tY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=JX1Zna97;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf10.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tvwsP9vvABxxjFo83LMGwuoc9gJFKDbkPSolQxDxUQ=;
	b=nqSMFrUj4odn1G972y5cGC+OiwDQy5/w9+IUG+Cep9rHWvCrYfBkXmziIUcYad/zF7OLdv
	jeP9ALJPeu89TFqVolE6osXvGFXb5XCqPAkHCoL70mo2GF2aPWrJ+QEBh64BK+cI+jqVJN
	EN8aK2yw5aVn/cE9331xxmnuotI8Kro=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2984dfae043so2458315ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998443; x=1763603243; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3tvwsP9vvABxxjFo83LMGwuoc9gJFKDbkPSolQxDxUQ=;
        b=JX1Zna9717AwLXrdR1WRSRGW9humkiDPQW1pktruwckBCgSEj4vJ3e8j2+1ZKHUDbq
         WZIc5m4U34dG9pLPxNxoBK7ucjZ3mLUvZ+phHPmhDoKIkAEJwenKEcvhUOfhLgdnsLMd
         F+GPaE2gM5fIL61sUcBiSb7LJ77caaxsc0XpCUC2t19Xlnvvv8ucQ7jAFR0zaqErfvCp
         KWJ8rkyVNi0b9eIzbVXVaNnwu60zY2KZxF9UDZ5UhQAITxdg9JPJsVZW7z1HK20yNQFe
         FBEu6inYxS5ZV+MG7mV5did/WzzJb+MhVIiTxxG2yvjB2jopcdxLrK5/pUaPhpJqByTx
         XA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998443; x=1763603243;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3tvwsP9vvABxxjFo83LMGwuoc9gJFKDbkPSolQxDxUQ=;
        b=gOVZ4Gcm6v9trFAcCJznVEtxxA246TmoCSynCHdWh9XDrvHS9oypmUhMaM8OsR2kYY
         8iP0bFV2jD/maIJ0MtQU4G6Uiv9c+sTbPh/z2lIWvRKCYkYtr/fTA/DBIyXR3DvtVVtZ
         Z8IdYhxXPshBRjeIy6H8oDX4vRcPIPXYty7GsJ1eo9KFxDAidAkk6etkD8kjtuxI8XA4
         OluAQ0cvtXwNeZk2YrLRAAENhpK+C3BXSpHGuu8F/wTdigt22Brltp+/7gp2c44KDMJf
         TS10elvRbXmj0+10PjJUYjr0OFt/icczt5MGx2/MtPtN6HgTpSeEvlFu/BzSOEwgZ4nO
         36BA==
X-Forwarded-Encrypted: i=1; AJvYcCX3/Cv/TB4zHuT+yhGdCqfIjZo+1t8tNVKH5yAn+EOeBBSnCKbyT34y8m680fl+ca5dTfRqGCxQuQ==@kvack.org
X-Gm-Message-State: AOJu0Yxf3X8wqUzqb/cH9onG+n8/8Coo8sp36id8mnsfCq7jUm3WV+lb
	nh+dafaQS4dhS4Ok4n822NwDWDmJP4EoBzMD+/ueOL5bbPw/eshRQO2gX/dhgJSVj4g=
X-Gm-Gg: ASbGncvkh3EKLw8QDL9nRD+DjMZl/9SZA9xo+1PoDOw5qg5o3gZOGwShLePUbL95X36
	pixWWyzkE6S3dPInJFg3jMiTlB0gemmdDjl7UL1zzTBayc27sBqDsWenV64oH2NZULGjrj0WeP7
	MyQ75xd6m62FSbSzpm9Jw28ktoqWty6RM/O62+mbWUF+oSUkrUcMsJxFJV4AwMQ9UdbMxSInJ3U
	LW8fDzVY5WIh+98dYCQnrVe9QJmYglC27qW89CGRnjUZxX6hwi6qQ6Mdhtj8Zfa6hh9yrNYj9rT
	OCmGDKHcKq/zcOJvb0NaF8ATPyDaqZVy8aypU5MBIj8VAW6y7zIpvTKlvDBpR98Xxv6kM6tCklH
	bofNEX4cDV0ceiFCWuGWe77BlBeprafdoOnkXTcvkp+sPc7tjkN2TEfSPgT9qCWMGnCAPUN+Cjz
	QwdPioXdLzJ5wH1FphnHFELA==
X-Google-Smtp-Source: AGHT+IEzjGNl3Wyy3hzWqL7on4A+1Kg8RojXA788MVa4vlvrwXnh7VKjWrR3/ZaKHRkhd2fy7O+m8w==
X-Received: by 2002:a17:902:d4c8:b0:297:f8d9:aae9 with SMTP id d9443c01a7336-2984edde647mr68226655ad.51.1762998443331;
        Wed, 12 Nov 2025 17:47:23 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:23 -0800 (PST)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org
Cc: devicetree@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Conor Dooley <conor@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Rob Herring <robh+dt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Andrew Jones <ajones@ventanamicro.com>
Subject: [PATCH v3 16/22] riscv: alternative: Add an ALTERNATIVE_3 macro
Date: Wed, 12 Nov 2025 17:45:29 -0800
Message-ID: <20251113014656.2605447-17-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6B2E1C000E
X-Stat-Signature: sc3dkpypqo66bkjjtic887qktf5d6imf
X-HE-Tag: 1762998444-740567
X-HE-Meta: U2FsdGVkX1/acMn8q9+VoN0lzoBUwontt2P//B04DQi14/0ca0Q1RoR5y0Qof538NJ6CRiHocggQiHqSChf+2DOb0LhSyhF4as0KTqdHZouQ4uocHSsQQAigTlj0gTJPJfHHKiwR5I94/j9ZU/OOVQko1Y69f35tkwysMJ4Q38UKSRMvak55C8Pg6R5sWwDR2e10ogczq5SWIfTpu3/DJD03LUD9PoaUCOhx14xCu8SHSbiCteD1+fuwjhKImaZuOyZ/Ek2skNUHpMzLmNfNJ55WEKsHXvIHeKEuv3iE8W0Q51e/EFziEp5ZYzAGMmTUrWfJri01zuzFcga1zxvf1aehrDEEwnpgJWmTmWXxt92xLLPxPanjGfzIXDz8gEwrgPz1XVROo3PhQLpyb0Yufv7xxFsMjPzOIE6shh5wFPG3kzMrJh+QPa2+TvSjU7tArnbCcJ1Q9FU7kavyXGAl3DQmWjVVblWTh2yn0Zwim+F2Di4y0jvXzzbKoGwVCXoV1zVt9tnIkdmjCJ/390ND7a2P6+Tcfhk6sLy8xY8OnFB4h1GnSnrkK2A74vRG3fUrDt1OxAYfG7q7Pnv/0enuQl7m8WIXAXiAg9c7JLPfTpBU7exsEZIaq4vGt7So3ph98Rqn3sEiMpcm0mDTTt3R0dcltmnGEidkRveRYPqU7fVFNQJuT6Fj0yppBAxzI2rLBtdaYTyvMQtMc6wkHmfZ4IljXosoTezl6fMbnIuJhsHWw74dpXxA/J+JblZmeOyHjZJHYGMHXo8IrfNaiTItvoZ1D82QJShjcrHeWF61BTyfWDqzD0ooqLJZAHuCPvN3uyhzscGSYeYfDMj1/OrZncRADlbVTitT8WZ1C0uHlz81LcN422RAYEtk49iilrtntSXK0sZvpX+eL2rbHRwFkgFWzfTZQd0h3bwr2mbQ9r8xJj5uxNKL1F/bsmHk4shYku3W/rlHuIOoelfDEEA
 toJ7Y80h
 vaZNnGvTiPt9FDL2NxIfz27BPE3cRClLu5oVOV04Z/4DM15Jv9J6Ejyhg2jdNJ+gZsj89HkNhl9YlkIDzaFwFuvAKT0KgjAjXIHUvcjoi4BZ7POve8/znlLR2z5/Zi7Jb5rG7BFJx6w3W+hRx7bl9w1K+dgLvZV1G4m9iFKW/DpH8w1xA7A+ZTzx1OjDejWW/r9ZycA5OobS+nIewY9c5JJrutqznq1OmjauqZkVVGxvn2gifpNHtcxTle1FqEB2dNJoddIEy1yb7vHmCX3N7jJbKKAFsgR4vFiXGBBU1FMMlWP5tgCCByZZkoEElfvgHonpkfrm6v2uHAI06qDmt/f7rAIaR4JRJbyLwBQZe1SaLsAVPwkdGrlFt6GDQ/0sCzA5l99YY9l1mDJq7EqZG2+c+ldcfg5la/mQhrdipuCCVvr0vWDxifuzaOzubHXjlu3qxZrtB2zRTVFq1Q2PZHih6PXL0POPZ+JX0gnbDTViO52tYRAL95Ssj4vCoaMj4PaSI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ALT_FIXUP_MT() is already using ALTERNATIVE_2(), but it needs to be
extended to handle a fourth case. Add ALTERNATIVE_3(), which extends
ALTERNATIVE_2() with another block of new content.

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v2)

Changes in v2:
 - Fix erroneously-escaped newline in assembly ALTERNATIVE_CFG_3 macro

 arch/riscv/include/asm/alternative-macros.h | 45 ++++++++++++++++++---
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/riscv/include/asm/alternative-macros.h b/arch/riscv/include/asm/alternative-macros.h
index 9619bd5c8eba..e8bf384da5c2 100644
--- a/arch/riscv/include/asm/alternative-macros.h
+++ b/arch/riscv/include/asm/alternative-macros.h
@@ -50,8 +50,17 @@
 	ALT_NEW_CONTENT \vendor_id_2, \patch_id_2, \enable_2, "\new_c_2"
 .endm
 
+.macro ALTERNATIVE_CFG_3 old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				new_c_2, vendor_id_2, patch_id_2, enable_2,	\
+				new_c_3, vendor_id_3, patch_id_3, enable_3
+	ALTERNATIVE_CFG_2 "\old_c", "\new_c_1", \vendor_id_1, \patch_id_1, \enable_1 \
+				    "\new_c_2", \vendor_id_2, \patch_id_2, \enable_2
+	ALT_NEW_CONTENT \vendor_id_3, \patch_id_3, \enable_3, "\new_c_3"
+.endm
+
 #define __ALTERNATIVE_CFG(...)		ALTERNATIVE_CFG __VA_ARGS__
 #define __ALTERNATIVE_CFG_2(...)	ALTERNATIVE_CFG_2 __VA_ARGS__
+#define __ALTERNATIVE_CFG_3(...)	ALTERNATIVE_CFG_3 __VA_ARGS__
 
 #else /* !__ASSEMBLER__ */
 
@@ -98,6 +107,13 @@
 	__ALTERNATIVE_CFG(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1)	\
 	ALT_NEW_CONTENT(vendor_id_2, patch_id_2, enable_2, new_c_2)
 
+#define __ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				   new_c_2, vendor_id_2, patch_id_2, enable_2,	\
+				   new_c_3, vendor_id_3, patch_id_3, enable_3)	\
+	__ALTERNATIVE_CFG_2(old_c, new_c_1, vendor_id_1, patch_id_1, enable_1,	\
+				   new_c_2, vendor_id_2, patch_id_2, enable_2)	\
+	ALT_NEW_CONTENT(vendor_id_3, patch_id_3, enable_3, new_c_3)
+
 #endif /* __ASSEMBLER__ */
 
 #define _ALTERNATIVE_CFG(old_c, new_c, vendor_id, patch_id, CONFIG_k)	\
@@ -108,6 +124,13 @@
 	__ALTERNATIVE_CFG_2(old_c, new_c_1, vendor_id_1, patch_id_1, IS_ENABLED(CONFIG_k_1),	\
 				   new_c_2, vendor_id_2, patch_id_2, IS_ENABLED(CONFIG_k_2))
 
+#define _ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
+				  new_c_2, vendor_id_2, patch_id_2, CONFIG_k_2,		\
+				  new_c_3, vendor_id_3, patch_id_3, CONFIG_k_3)		\
+	__ALTERNATIVE_CFG_3(old_c, new_c_1, vendor_id_1, patch_id_1, IS_ENABLED(CONFIG_k_1),	\
+				   new_c_2, vendor_id_2, patch_id_2, IS_ENABLED(CONFIG_k_2),	\
+				   new_c_3, vendor_id_3, patch_id_3, IS_ENABLED(CONFIG_k_3))
+
 #else /* CONFIG_RISCV_ALTERNATIVE */
 #ifdef __ASSEMBLER__
 
@@ -118,11 +141,17 @@
 #define __ALTERNATIVE_CFG(old_c, ...)		ALTERNATIVE_CFG old_c
 #define __ALTERNATIVE_CFG_2(old_c, ...)		ALTERNATIVE_CFG old_c
 
+#define _ALTERNATIVE_CFG_3(old_c, ...)	\
+	ALTERNATIVE_CFG old_c
+
 #else /* !__ASSEMBLER__ */
 
 #define __ALTERNATIVE_CFG(old_c, ...)		old_c "\n"
 #define __ALTERNATIVE_CFG_2(old_c, ...)		old_c "\n"
 
+#define _ALTERNATIVE_CFG_3(old_c, ...)	\
+	__ALTERNATIVE_CFG(old_c)
+
 #endif /* __ASSEMBLER__ */
 
 #define _ALTERNATIVE_CFG(old_c, ...)		__ALTERNATIVE_CFG(old_c)
@@ -147,15 +176,21 @@
 	_ALTERNATIVE_CFG(old_content, new_content, vendor_id, patch_id, CONFIG_k)
 
 /*
- * A vendor wants to replace an old_content, but another vendor has used
- * ALTERNATIVE() to patch its customized content at the same location. In
- * this case, this vendor can create a new macro ALTERNATIVE_2() based
- * on the following sample code and then replace ALTERNATIVE() with
- * ALTERNATIVE_2() to append its customized content.
+ * Variant of ALTERNATIVE() that supports two sets of replacement content.
  */
 #define ALTERNATIVE_2(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
 				   new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2)		\
 	_ALTERNATIVE_CFG_2(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,	\
 					new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2)
 
+/*
+ * Variant of ALTERNATIVE() that supports three sets of replacement content.
+ */
+#define ALTERNATIVE_3(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,		\
+				   new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2,		\
+				   new_content_3, vendor_id_3, patch_id_3, CONFIG_k_3)		\
+	_ALTERNATIVE_CFG_3(old_content, new_content_1, vendor_id_1, patch_id_1, CONFIG_k_1,	\
+					new_content_2, vendor_id_2, patch_id_2, CONFIG_k_2,	\
+					new_content_3, vendor_id_3, patch_id_3, CONFIG_k_3)
+
 #endif
-- 
2.47.2


