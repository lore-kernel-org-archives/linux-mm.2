Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C4FCCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37B988E003D; Wed,  8 Oct 2025 21:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32C758E0002; Wed,  8 Oct 2025 21:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CD4A8E003D; Wed,  8 Oct 2025 21:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 048CE8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C5AA21A0882
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:53 +0000 (UTC)
X-FDA: 83976917346.12.B697989
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf05.hostedemail.com (Postfix) with ESMTP id E513510000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dIaSPQG8;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6MxHL3qUwy+t0aO6eARfxrO+qA5Rm8YXQr0n5njGXfs=;
	b=UA1qgd7G5Di2dWraEAFeCluwkyhV6t6qZki8ROn3Q4LIwB6I+QgR20ZXcz3BOGDZFnlMAp
	GjrLUaIwg2QbY2gj4vs2PWxb6gLvmG3egV53GGSAKQAFUmqQDhQlHhhjqUW39840OI/4aA
	hg+9igd429tbcfwXqor/XqTOLtaPXNA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=dIaSPQG8;
	spf=pass (imf05.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975132; a=rsa-sha256;
	cv=none;
	b=e5WIiImeZ0GIR7xzluTh2QVUM3AaE0Tob1Vp3xfAsan8e0EQPYUagKXg7Slyiq8ALXgywR
	JL96bDlErd9Z4xQEmnhP/cqw5FZipuenQ5oPHZxfiJb1tzrKk/+yFsBpSP8VAsYnKE+O68
	9vA3cdbodquZ0cL/Ig/yqagmXAW/VdM=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-28e8c5d64d8so4006595ad.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975131; x=1760579931; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MxHL3qUwy+t0aO6eARfxrO+qA5Rm8YXQr0n5njGXfs=;
        b=dIaSPQG85PykcdQNgGCEh905kW3qynddpO5rZD90UUGI5IB3uvBEHW8uc6kusRJTcR
         FmH71cxiNiKn/sSP5WWhpCWc9EEbe79C/JIGTMX9VB87+KaWTSFEHwPgrJjXKiiWvV74
         nL37UrwbtVALlTIyUax9hzQZ8MH7Ey3WuJDQk1g/MaitlHC8TBQFa4lD8YoY2O1e9cHP
         4Crf6VR2yeaHI15Hp/0+OFvtbVEiVYBDddgKmlAokb9nB3lJYt7uURYoMXRUwtjcCsOa
         eA7vu1XG+VY2H2CT+EShhdEdwRvxqF7XZ6B20uriK2QqzLJehrO4j8YjEhx2SzTtu/kd
         zjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975131; x=1760579931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MxHL3qUwy+t0aO6eARfxrO+qA5Rm8YXQr0n5njGXfs=;
        b=q3S8oO/zJphuP44XEpFHXVq7fMsXAK/CcUfJFUfn2GYR8bJvieY3GX04c2yErT1mWT
         JGAhrvgm3sWL9zKpEoOBu5utURDyOaHyVNEpvxCnM0pLInOmaXM4VLkUfrgtYU9P2lCF
         kxfykhpm5ll2bBJ0wiaB07WIlH+K3zsMgMy5fDVRTdfcsgmUkN5RZifWx+Sn5TpvK271
         mXvoUiBGSlXrLUieKfigomPL5Uowpmg/RHu6ePxaeLjmBnxvMcVMR90LGcKnG3CKItXy
         RIL7h9V4+alh+tBy7nUzTa6JdIbwmWdgfKKacADjbTuTnddYRnKtuPDliX7P7imnMw9J
         qdQw==
X-Forwarded-Encrypted: i=1; AJvYcCUKlvjKZMASQt+VsR2YKpNec5OGTksV6iK4r5lZcS0EINThDe7hit7Xf7mhy17ywAseMl33vIY9gg==@kvack.org
X-Gm-Message-State: AOJu0Yyfjtwr/E2Sl+bNNoO7dQEqTIsbF+1QF+yJqKQGePOFY9Gq/IUU
	BN/p27uBMhdSuQovCXTPo80GaB1wFdLU+jF7ce8AK9JMxeA4PoBmvrhquy92GTlSEVQ=
X-Gm-Gg: ASbGncvYyUIYkKHGJZHzZccrxmTb25d5+bn4GadLI61JHgiN5Q/6WE0MvwUGipeE9n/
	C7QIepPXjxmbwjBRi0xRt27lGWtokkQhfhdVQ2wb5mto7lKm3J5GzwRSHcNysQWQmGU6aC4DR8r
	0CzU51i0YCgl+YIMhoIYbhw0UzBSFuNPNBgcUqiEnGkTbwRKuPGqqrUSs/gHh/yfAO88TPVcUpq
	jiBW7F/QLiQiZuEAimi5I5PiHXnmbS196HCuktJXSSytVNgCx9EcX7OrWdubNT5/sRz2doB5eSB
	N/8D7poBKbhqcASQz8gFUM9RhlTqi2al8NBGdr5VjSUHn6SN3IX1nHlHcd//apESQCmofHNHoMf
	z1BiXJe7IAaPIUhLTC1Rjs1QAR1l6vXq3UMBpgHfZc1BdBLcXymn1hVlagtwJZYKT+Cje
X-Google-Smtp-Source: AGHT+IFWANPjuzJhuuxubYaVO2GJhHx+Uq0HfBlhgHOgbCi5OPe5NLGhSbpBSxbnLiNpsX7PUf8iug==
X-Received: by 2002:a17:902:d592:b0:240:48f4:40f7 with SMTP id d9443c01a7336-290273edf23mr67433045ad.39.1759975130859;
        Wed, 08 Oct 2025 18:58:50 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:50 -0700 (PDT)
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
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 08/18] riscv: mm: Simplify set_p4d() and set_pgd()
Date: Wed,  8 Oct 2025 18:57:44 -0700
Message-ID: <20251009015839.3460231-9-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6rrip9yq14nas776p9444op8gngn4yhs
X-Rspamd-Queue-Id: E513510000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1759975131-610699
X-HE-Meta: U2FsdGVkX1/9NT22smkBf5g5tTGAZj5jPyZxENgqdZqIItebdj4vKBRx1ybw/qYK7lpAj6rcx29/1ns2aivkGyhPkURgrojHmFqBkE7KAK39HWtVI3kMh550MZX/VVEITWqz4y7GhxKCSV71sK1IZMOhXtx25oehR9pycI8aQITWZbQsU/rguUbdYiN9fXZX26132V92BBeQrCjxP8bkkKFb3uic+d/UUz6DoB5qL7FTzSJ5F+uLKJIxuJedyv9kYbo/38H3rA9qjl+L+0RWPbsl+ws37NJRTZm6QOYL2i+tpOGML3qp1zYKFNCzHdbgcQff05cDHSw1tGRIMJtak166VRYA9z8Q42f482Wk+eDkqvly2S172EKlg9tlZQNIHadJA2XkRy1vXfwiSFNaameKeIY+ikmWb/vy2pHyvYoSKFjcnnWIu2G66WbazojSmG1ttRvqpVrcHx4p4A8BBl15MfzZAOq8ZMFGBKg9bztIe44EAFZ8tRAOjINdxmThc+cc2JhNWxyjDxHzAzxr/KA6mvJcOFjGfKwzsfY8yerJC6G1D0uViHtwbMmORswwwi421eCrGvOQP5WPnG3yBPqrpNi8Qx9rYP4aP7u//n829fxHj6D4MmhSimMk4/3txKIKOGx4M/XRHeP89e4YcdKUuYEGlIFsvp1ijYwxsYFObfiiLcqxm54UXhczAfC9XIXhlYK2GexYUjWRZyNFU2KqTc79Kg2fZtetHH2sFj4UcvGq3I0zeUiUwyFLG+6GjEjOB8IiFcLttLbscVgg/zg1Lk7V56LwK0sZOPD+Ij/OQm/02JkMRGTz3LDOfqri2QW3mQ+voaXaxY9K5iuiT15vvq0tFfdqKueZbJW8sNfjRO9nD9AIuRaOOMILY5/AYvzwLf67ptrgVtsMiWM8PZyQjOgsYqNLVTzLu26xCf03BVV+aldNai7eD9WhRyX9cBQ0TThal9Ztw5AoAAg
 2Aqqi/Ha
 ZEdBNT50IIS/m6sYXAQe7CerakVL2rhFmF0hjWOb8n/Fg1BI3lPBd6vI2xonLOWWLNCDHhGl+v3zSiY9uFBQvSLXd/5a3NBKEJvidi/GJguz6g0fsiQdiExtC/GwX6MmuDsI/Srqf/f+g4kbs5cFDgOCOOGiQIhrYF7gEkLAOCmJ5ReNpTNxmOBOwZC5zoQMvie7SfRDdrLyCLNOJMEMVyH9zsGum/ByQXsVftERWoxQ/zNS9flIs10qLbjCP+eoq7jzy9lL8GkcPJBxUB6Ct4hVs3XJMo8yoyP2JSdLhJyoCWnVN50FcNwUMGiha+JmKe7Gb3Vfv5eyI2VxRhmjGu+560s0ZFbpNg0XAG569ZkXTMWUX8/0abMseP/GoWEirRl85mKUXSFmeOWzJfgiLTtaM1qbBpk3UNVOPmeHL/xzseH1mFGKBw5G4eRiAaLqMLlDu/t+TJHmqAayY2p0fpNi2uczCGgGXCqNeJ9rtz8qnAWU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

RISC-V uses the same page table entry format and has the same atomicity
requirements at all page table levels, so these setter functions use the
same underlying implementation at all levels. Checking the translation
mode to pick between two identical branches only serves to make these
functions less efficient.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 arch/riscv/include/asm/pgtable-64.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 1018d22169013..7eb23c24310f9 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -273,10 +273,7 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
-	if (pgtable_l4_enabled)
-		WRITE_ONCE(*p4dp, p4d);
-	else
-		set_pud((pud_t *)p4dp, (pud_t){ p4d_val(p4d) });
+	WRITE_ONCE(*p4dp, p4d);
 }
 
 static inline int p4d_none(p4d_t p4d)
@@ -340,10 +337,7 @@ pud_t *pud_offset(p4d_t *p4d, unsigned long address);
 
 static inline void set_pgd(pgd_t *pgdp, pgd_t pgd)
 {
-	if (pgtable_l5_enabled)
-		WRITE_ONCE(*pgdp, pgd);
-	else
-		set_p4d((p4d_t *)pgdp, (p4d_t){ pgd_val(pgd) });
+	WRITE_ONCE(*pgdp, pgd);
 }
 
 static inline int pgd_none(pgd_t pgd)
-- 
2.47.2


