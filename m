Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53723CD4F35
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D0D8E002B; Wed, 12 Nov 2025 20:47:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7148E0014; Wed, 12 Nov 2025 20:47:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F608E002B; Wed, 12 Nov 2025 20:47:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2612B8E0014
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:19 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E3E7012D7D2
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:18 +0000 (UTC)
X-FDA: 84103896156.03.942E668
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0EC5F20008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mnvKyiQo;
	spf=pass (imf03.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FhqbfzFBgO5voylyQ1oE0qebaNihNkFkz8eAAFF/X6s=;
	b=hCYeHazIuXp9cnNTW0SWkks4lt7nXXFWrr2P1R3MfSCQSe9334X0Haq/giEvAmuGpcOub9
	ev9VVFAZvBG0VRYZkKZ81wVR4LU0868sBb/y2XqbYZumAM408Vtq5LFaoG/glmxLvFaTYk
	sOaI9dDntE0zCDSDb2qRxJSm56fxIQ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=mnvKyiQo;
	spf=pass (imf03.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998437; a=rsa-sha256;
	cv=none;
	b=8pnl1kkREIyqu1ZTETxusv6zq2HDSjqFDlVcYPOACSJiaBlEk1Y3REugFIiAUU3Z0m15SC
	N5a5EpXDuJGvlKPXc86BrESIJDxAPMhaLr7Cdlp+SR9rrYm3cg42vSqK2qQrqS52pQGZI1
	MPJ7woZjTGIs+PpfQvGoG5QkYOycwkg=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2984dfae0acso3102765ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998436; x=1763603236; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FhqbfzFBgO5voylyQ1oE0qebaNihNkFkz8eAAFF/X6s=;
        b=mnvKyiQohMCKf4nQ7Hceq5WF7bGfvsedVJX86tB6uCQI0NxMxObn8TGckgDEwyKVUB
         E1VHpxRj0ZUSUz1fYk0sxvkpOcvShjDdjJ11lu2ufoqpjKXE6jAVmBU+xt2CDn7E8j1X
         35Q6EVF2FpgySa237k4br7ZR0Veo8TCTdgpqjZQi3viqN6/VEnDVwh1OFZA9wzhRwlfk
         4ol8beLGzMJUJ/dq6GjXIMW6HvnQTsp++BS6J1aT1D7YiqjY2eB1MpXKmkwI3TbsU/TT
         9n+9wRAhRxqyUo27lT/wvTwFyrXtzeSyG8r4GkJvSsZeEjDoOChbM+sijnNWTm0v9lj1
         VyWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998436; x=1763603236;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=FhqbfzFBgO5voylyQ1oE0qebaNihNkFkz8eAAFF/X6s=;
        b=Se8B2nkWQJ9rYsh0d1+QNUeC884VXDhcYEOXXDT/SvZJCPbktD99vRV4FhZnqG7a+Z
         SdIujLBHBTElmSugRXBZ9pxVLwbkG6jDPFkUr6jcoQf1rKhxKjZRCv37aJvOLbXpwRKR
         LCcvC/bQXG8j31aikTFdgaB7MEOdQlPqU+foHgpgtYVINJv7YoEiX5QI5YNoM3zls6nt
         PNJkmsDrdvG4zwlmwNp8ROGYmwxgmP1qhW8CV03a1knQyoS7jlh59cSSEs25S2i0eiL4
         M5RY7m4i5GUeVlo9uJFf5hS++ZzbeQZumCp7gU9dkJOlf26xsQb1G0oqjg1FOc6NOA4W
         UNXQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwGpTw5FK4Vq7UosB01j5B4KEpgpPYrT7rEmrwGyHO8WUQFANpRNN28gZpj0KhfEPLW29JIIKhhw==@kvack.org
X-Gm-Message-State: AOJu0Yx8oFK/UF4McJZTMZM/RPsvzuFrXCEnq9VUY9QWBjC1BxMdetCS
	dq7QmMnOwv64I/SZeEWx4TSF9pYmOmtt9RscSI/jhtkf1X7pzZ+Kj5EQv4EoB2AY0JI=
X-Gm-Gg: ASbGncviSSXYfpKkyS2wpXXmH9PYzR/YdG0eAR0Fo3TmrCCTVcj8EyWquzlz8Z0Buve
	joiDEyhvDDN7UFvX0LuGGQY03z8l4iZku8b63gtCWWY3DGwuUkIc/u/OIF54h/DiMRsNn9aB1MJ
	3dsbq/cCT2DUxoU8WKj+s1Qygra3wlloYEXykNe+VSy+dHSEsznanrDmGmqGXRU2RboNU0lBikc
	BM9w26MnuZulHlP4GtTnYGR9yZTlcQNDnUyAO71LcPFTaqTsnxF7yQhdY34lLrcW9+7Z2M80yxY
	rKxCGHG7vh02n3jWBx/wxHDgf4ThFA3vO+O5OFdEkZpNWarN97d4LH0qrKg8Lfs5/0+CePEI+Py
	+rLXCoc46FRSGdxcy2jbC3X1lL7UyT3Hw5KEJvfZDUjxYGBMz4VJ7Y6+HbcuH5eePkpLGBie72t
	2qCiGIXCVPQjlJ8rjrKg1RPk1eqg4e7POi
X-Google-Smtp-Source: AGHT+IFU3ZD0WgCFLGesvoHcSqmefP/DlaLr5QtMhOO16RVbV2tzjU8K9lCg5h0K2mU/+/PVAIgbRA==
X-Received: by 2002:a17:902:fc86:b0:298:1156:acd5 with SMTP id d9443c01a7336-2984edcaeccmr67224805ad.39.1762998435872;
        Wed, 12 Nov 2025 17:47:15 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:15 -0800 (PST)
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
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v3 11/22] riscv: mm: Simplify set_p4d() and set_pgd()
Date: Wed, 12 Nov 2025 17:45:24 -0800
Message-ID: <20251113014656.2605447-12-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0EC5F20008
X-Stat-Signature: 6hx764bhuc8t6ufckat4wkmpn5m4i3xi
X-Rspam-User: 
X-HE-Tag: 1762998436-547410
X-HE-Meta: U2FsdGVkX18wl0N6FkGic1o3MfjsL1/pDkniCZ2p05pCqW+3oiafkAEdVUNeXG35YAtO5hIuWZYwQLblNmWYfsNmVJFjE+WhHWVB0OWxwjg2cKAnJwa7zUBNHbF/VoItN1y/2rihipJ/x66QkibxKrIUj/zdyDOn3PxSHb7yuMvmdlrqFEsMe7LAAliyc9RJc4nlkufopIAYrXD1Q8bC4UfSR+8lx3fLdz+X1LdtgVZVrgMtlFp85HIwGHh0u/2i3T/zT0fW74wzbqBiittsSvlACiF52ehsqkvNgd04vEW9TWhRi3CKt+06Ft1lYJg6D9fgTjjdYGsiR1oFBjYyRCcSevx7OtACjsWC4YYAOuobXW6dfAzeF4KNUuRizHWXeYDi6roCCFCmSFjd2tB0w4BnBpVTnUxxcB7xQ+amI0w9FQ6N7HinLr0Asca9pbCsNWE0GFYl4vEaXMdd6sXqwqqOEKPcofWUiQtfbK4jva1635nwlUBTbUAhHuTRqHMy+RH3CBMHYb5lShg0dJezSpY7NKr6o/F8+tLaUqMAc/+J/nH/Osu7qbPtwTyf9x5f1NGU4Mq4Sdq1XUMGXdPlCcnnU7fNrJ+JGa/vNqUjlySDtl05Eng76NwNoeOfjSJg8lbj3oK1LCodYQPL2iClykuHEcUy3vYtXeWCiCRT8+tz+mNz+GY5rXcisekjnRpIUQ44R9W+bMPzK3E6/EYhjpE6WPgYg3sFDN75UWNI9M90obMRmaON2rnP+tMAhpnQ83hfa0U/EJZVeb4r1AafcxywcA5ugLbXdPH6vw3gpWhFdctBaTogTvjul5YalXI2kwVqxzkdhs+KaA66nAzWvYcgbPCKqwGtNdXH4+ZqTyAKuNMStO8pZTUfa7+8fSuLPSC3I8sGY2sUMmTlPNzK6wwibzfxXIdwIzp0HyfYKOckDfFGZCA59HYVxk3oKj6CXm2n+3wgRGJza3+CAjK
 EO7VsnQO
 WpOT/bYFOK8LFXfuwTsyD02Vp08Viv277SL/mhwv2Td4qDjxxzXPwRhEkRp+Sz9YVomvchNQuqHqJILlXdqnyh18m7rwy2RzORsQBvcJtwjSFxqw36aFLtOKCCcq5W53NSJqOrJ7pyswipbRcOk2dc/qw3QQKo5Qv4AWlXPpbN9Fd5vbTkiq8Pt643HBTmoMd5CNz4hgCE0NeOApnlbf3V/nY8qIXCTZTquxtMn5aMvm0y2vJBtVnGk+isdYhVpvlib3WJ/yaA5w+NwvWTafLOt/khGPBvWeGUGDWUfBLQPreYyF1dutMRDlA6uuLcPzZ3+/iyNL4SciHts4789F5c+ExDyAuNzPkAeA0z+cVl9xq6BYLGUEHJT/os9VQ7n4n5ujpgz+iOC//xkfX/nS+KGp3fxoa+emvxtCkRrueTl0zwC4H9iruskEU9xin5L/soXxU
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

(no changes since v2)

Changes in v2:
 - New patch for v2

 arch/riscv/include/asm/pgtable-64.h | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index 6e789fa58514..5532f8515450 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -275,10 +275,7 @@ static inline unsigned long _pmd_pfn(pmd_t pmd)
 
 static inline void set_p4d(p4d_t *p4dp, p4d_t p4d)
 {
-	if (pgtable_l4_enabled)
-		WRITE_ONCE(*p4dp, p4d);
-	else
-		set_pud((pud_t *)p4dp, (pud_t){ p4d_val(p4d) });
+	WRITE_ONCE(*p4dp, p4d);
 }
 
 static inline int p4d_none(p4d_t p4d)
@@ -342,10 +339,7 @@ pud_t *pud_offset(p4d_t *p4d, unsigned long address);
 
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


