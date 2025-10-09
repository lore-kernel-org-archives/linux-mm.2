Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A18CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A32FA8E005A; Wed,  8 Oct 2025 21:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E3EC8E0002; Wed,  8 Oct 2025 21:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C1648E005A; Wed,  8 Oct 2025 21:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6756A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20AF5160919
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:06 +0000 (UTC)
X-FDA: 83976917892.25.B35A807
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1EB0EA0008
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=nAinBtTx;
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6BAMdYf9jYg430LRuIQ/78MgeGFhJjBTPRUD+PdvqOQ=;
	b=lu2FrbccISM/2NNZqz5hc0PMjF+nXz9vtBqSE4GmFsCY+MXbkD9okZrNo8Ld+GMkYA6ox3
	brFqAEX/+nhulPRfG9zqv+0oJWqb1HILXDFlkIRL2CTGoxykMzf2QL9H344SdFb5NWGTac
	q1N5+pLzuqO5TMO4QV1sp+ji6oUl8y4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=nAinBtTx;
	spf=pass (imf15.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975144; a=rsa-sha256;
	cv=none;
	b=hsx6nl5wKcRcbunSdRptcojX3Z08Xl9yvLhkWPivt4gxI/hYeSPq4JRIPxuR4ZGH2VsSTv
	0IwEV38VIva3KwIh1BVCqiikY2eOg83rxJkIndwJVDPXVdY5fjsQFudyGhyzX2gOpNCKtR
	3dot6qE2bNd/pEBZPZ0HK8aKMm8mw1E=
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b6093f8f71dso237363a12.3
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975143; x=1760579943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BAMdYf9jYg430LRuIQ/78MgeGFhJjBTPRUD+PdvqOQ=;
        b=nAinBtTxxta7nL66SG4kzuycdGjsfgZPiZ2THB+M3GRP+dBMnAdR31mlTBqkSNFAFp
         H1t77IZgHiE3DKLmORASk4Ae3Ck6fWa74kV/+YUqCw9Mi400AkF323Fd8bXoUsptMv70
         oMUFI7e0SvbkI5XdbvHWiizUiUEPVIaFjeJxOHgZ/NmAHV8cNKIPWe+TyDmeOP+9AGJb
         cd3+btS/ygpT1CTJMKbuCWzwzzWQCzRz40ECmI1W2UiZWrtY47+qeVK0fA4ptlQpherf
         y/xP9WJHr/nSrhonKgR+J4LwpL7yktoZPxf3Vi+r5n3igaXjfm40Tc8pLjVPq5AnA6x9
         BtKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975143; x=1760579943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6BAMdYf9jYg430LRuIQ/78MgeGFhJjBTPRUD+PdvqOQ=;
        b=WcBHowVPqPX4d1QK7va85rYbsCRwUPBfTePW+2w3qN37jAzHYmQ3vI5C1themLISWh
         b3dYhDphfD1E4jsuNpwoEvVcIJOvIL9z89njXTvdYiPCHQ83oy+0YKUquBWYHv0bIpNn
         n8RxDksJjKLlEPSK/+f9JbAQLgbV97V96vfKCa/DecyrqQG2WnMrmAn3aDxjYOhol90u
         os5JQcWN+qKnzMFtQljKfH5drOGan92FQgF0znjjGjh6nczH8skYGrEluvlZoTxEEcck
         SKyvEMkzCTheE29rAGeh7Um42nvcFoZoUy45g/pk5WmTrWqX2ie3f3sQwNFpHr0dX+Fa
         3nvg==
X-Forwarded-Encrypted: i=1; AJvYcCUEHs7tS8/3B+PCyQnAAdHxoJ7KQHpt2LvCsRICU3t7UisvQGWxqiAcnPeBJ2vN3/HhyaxJsaBpVQ==@kvack.org
X-Gm-Message-State: AOJu0YyWQAWzvNyrqqqknI4BcJwrNtSJd9mpsl6ryDp+oE/2m7LL2eSM
	2z0mmqvAxD4m4u0hUoh6HMxCjBuHo9Ug7UT+5RMZE4x4M2xyW+ybU7TzPzSgGs9bQ0Q=
X-Gm-Gg: ASbGncsdXAAoSf0btL267u+8/NUu2BkqMfuSdxYRwScrJyhzqjXPPYjcw4r4IpANr+j
	vX29ESKlnXJp+6O5K2/MktOj+vPXC4gGhTWbD0XbBa9vImBpdySriaus0XuSES296yJ8P/g66A+
	YbsezMKen4WiQSIyp7aOAJn3DuTyJ/x2CG5A73/Ius0rfpyFLoR6Rz2NXh8mm+RBJ5grPGCP8oX
	YT+hg4/oJJUbg6xQ2nubonXmyKWMyR0zTngjKSBlv1gq6f2EGdhINhm11N0FwwUedzWfjEE0nWr
	BY5jNTpUsiNGBy5O/LFMGSth86jXSXPj6NZmbtMDN6yGMw+umXQ+8XXPLj60AiENKw/6vqQFc2p
	4SZnloPKCcjCCYT6p8/4yQClZagaK6vDNpZU07bt4UkhjN/rAtoJjwfLXteWZ0L+R0u0STlsJOv
	BnHB8=
X-Google-Smtp-Source: AGHT+IFH8AKgqsZnk4E4iyKT3yuRTpeHrZ3gNSsclL9XuJ0PoMWOCXT4FRimy04nwWVVyn2iJvf1+Q==
X-Received: by 2002:a17:903:910:b0:240:3b9e:dd65 with SMTP id d9443c01a7336-290273eddc4mr77201595ad.38.1759975143155;
        Wed, 08 Oct 2025 18:59:03 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:59:02 -0700 (PDT)
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
Subject: [PATCH v2 18/18] riscv: dts: eswin: eic7700: Use physical memory ranges for DMA
Date: Wed,  8 Oct 2025 18:57:54 -0700
Message-ID: <20251009015839.3460231-19-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: as3qrdg6nr4x9as4gwj3773jq1mhdrus
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1EB0EA0008
X-HE-Tag: 1759975143-48335
X-HE-Meta: U2FsdGVkX1+yh/BHcV16gwSQsWLMgKomDhl2WT/wV3PBDgwFYihyu8iQw5UfcPVNxF+sk1DaXpJ/3AE71+ntn2JtkESWXYfEhaW8g5yDUkCamEtGBsREAqC2igP7DeNTTXyCYdkihe05ddiZjpJTyvNXPzpdmiknT8v8m5m9bKPYjxhYZbGuFST5yIFmmRodF9153iEdO0WS1jSux1de0lOGDq3ZznVcgK4mF5LJPnkaX/Y/DM6dfxKiYkOBgr8olbdBi6YcWAfxUN78i6MVIGuy97dw6adKITgQbbKW5oHHajYf9cdVA+gzPobwXFJ06xij9L3qE9Uw6gE0qWAyZXLE9hW2Bw9RrJjbyGCiJ1+szxa+xDLIfTqpndCrMNVnl6RloE6EOIWp+rhXb7WNXaUoYaA/mkI4CCmPLAPAFF0QDEIrMosXawfl0zrOGbciTK5BCRb9DpDqjwkQPMz0KJ3pXWesWc5HM1aoxvFNKxaMdYcy+9JRqhbgJkfaLxQ0UGJB9TxQ/kMR8DmcUdxQWmd/lM8LfGY9c7bidS8Yhw452J2O61DORa3rjwrCPUCMMS0J+40hgb9sSd330Ra03X5c3p1kn00y8cD7lkq/nFOhuQ3dE11HtOwcgwaNkZL+qLB41rlMMH7M5NeZd+sF1IN++xzO1PIf32pQHhlNGlj1lZ8wwJyoVE3XzmOHn1x7/h+QatH3k83bCsEP7OFmytQ7q0gHa5hC4vmdIskHJyjmCs+lI/97sXGpihxkAcZ/BVpeTx5/AUWc4QANWnipGrun9q7jwp0CcRbO2UvY8Q1XObjPLTgEl20GYZsDWkiHD7WxUrAk+zSTkOZxjiAjkSRdGR4LoxRRZ7sU1yBo2rB+EU0U7CgbgjeH2jbMGbEQ0AbL9frQCjjuabX1SCyCF0JA1EjMv3rqZdHjO1bM9PzwB85zAxossmOlOnHxiH8pLvY53KKsDJRdi6pyi41
 tw8/hc0+
 +Dv/r0OC6xiHch1YydeMMy0Y3ey0j7A0Q9RiHWSj3beztDAukqNffm5eXiiSl4MAnXl71Ujw3dkotDEkUE592SgGnnYVUI6yB4zZdFKsCouZMThUc5/6CbCNOA/cBe9agU+/buZmFhhVUYfXC/MrpUYWpsz1afUT/onFR4w2NWLNKY0o27mId77Bg7P7MdyUZAmfZQkoIrM5reKOd3keh4SleOH/qhIGW/xuw46KDOuq5NRDjqZNihMy6DuJ4E5Y2IWO7wgrIzaW0Lih9x7veNqoge+DExG072uo1wRljWmlxkGLkf37DtyZ394UssvzXhybca1p7/uP7FdkTaH1nsZ6oQnoKfWMl8DgaWEHZ2oM+swFxDXcNL0jNzRd3PRHIKUt/bNhys3DP4iHq2pfUjELmRdkxGCA8/8Vn7JmiZEcJZLRve6ArW72kJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

EIC7700 provides a physical memory region which is a noncached alias of
normal cacheable DRAM. Declare this alias in the devicetree so Linux can
allocate noncached pages for noncoherent DMA, and M-mode firmware can
protect the noncached alias with PMPs.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 arch/riscv/Kconfig.socs                | 2 ++
 arch/riscv/boot/dts/eswin/eic7700.dtsi | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index a8950206fb750..df3ed1d322fe7 100644
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -9,6 +9,8 @@ config ARCH_ANDES
 
 config ARCH_ESWIN
 	bool "ESWIN SoCs"
+	select RISCV_DMA_NONCOHERENT
+	select RISCV_NONSTANDARD_CACHE_OPS
 	help
 	  This enables support for ESWIN SoC platform hardware,
 	  including the ESWIN EIC7700 SoC.
diff --git a/arch/riscv/boot/dts/eswin/eic7700.dtsi b/arch/riscv/boot/dts/eswin/eic7700.dtsi
index c3ed93008bca1..09292910065b2 100644
--- a/arch/riscv/boot/dts/eswin/eic7700.dtsi
+++ b/arch/riscv/boot/dts/eswin/eic7700.dtsi
@@ -5,9 +5,14 @@
 
 /dts-v1/;
 
+#include <dt-bindings/riscv/physical-memory.h>
+
 / {
 	#address-cells = <2>;
 	#size-cells = <2>;
+	riscv,physical-memory-regions =
+		<0x000 0x80000000 0x00f 0x80000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0x0>,
+		<0x0c0 0x00000000 0x010 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(1)) 0x0>;
 
 	cpus {
 		#address-cells = <1>;
-- 
2.47.2


