Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED03CCD189
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9239C8E0059; Wed,  8 Oct 2025 21:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 883B48E0002; Wed,  8 Oct 2025 21:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7749D8E0059; Wed,  8 Oct 2025 21:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5382A8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11C4511A7FD
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:05 +0000 (UTC)
X-FDA: 83976917850.02.A340838
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 40C53140007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="kn233/qd";
	spf=pass (imf09.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975143; a=rsa-sha256;
	cv=none;
	b=bDQ//MIRoTT1SSVEHsvuep0HDY3jQjn/ritJR1o3ePpRHDEnY7kmWRqB0dTkDdpGNSCAct
	wmoEq5VIoARK6QoARxnLsmRWorJuFmGanui6Ymr4chsTef2Z8I/oQz5VHfTdu1UVcfo0zU
	5+TUTw3oXyJ1VoHhHXBE5cf8t/BaQDY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="kn233/qd";
	spf=pass (imf09.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n103/Zzy6dOfBxJ4uy1kIK0G1FNuk9TvEmc6PK6Kghg=;
	b=NnGmpjiE13RzG+1EBEmWgJFD0kdGI3uYC1fG4cNp3S6sWUv179rpbEPQKdhjoj9SZEasME
	7oMtFv/V6cRWrgsZLGqftql2vkq2Zg68mLvmV/Pm+BIpNgQ648+fatYsRPiR1ClMUQshy0
	vFF0HASASinkazbYUK5yhg/DEKHK+gU=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b633b54d05dso239827a12.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975142; x=1760579942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=n103/Zzy6dOfBxJ4uy1kIK0G1FNuk9TvEmc6PK6Kghg=;
        b=kn233/qdeDZpFWPm9p5RuCdl48vb8uDpX0octWs5nYvmnExHBV7Y2eDc/dk1k5DBKJ
         fRzSrsAWOqMlCjUqHT7SDTB/hT1cPWEeId1SUED+aHX8+XeX6Ep+VG+3drx5ljhutbpQ
         uLwi1GC2vicnAZ91qvIJCW++Dk7sudJDDmMgkUzmpCIn5wHo44pqnzAA7xpjI+uYVNBF
         4ptWQzhWueiwLZWTswAh2zLdBjsC7klK2J1BPZREV7Nxgis4NjH/2p/XbIeKLxVqn2P/
         O5AHNMOGihZ5PEy3PGIJ34qrYSb/dMyy4dqNcmuAPKkJ7BCoarzV9S3Op7IEHObaxhgp
         exIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975142; x=1760579942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=n103/Zzy6dOfBxJ4uy1kIK0G1FNuk9TvEmc6PK6Kghg=;
        b=lHWrIJzd8lRuuPfO9d9EBpotFaGCFVyvCmqKw8LNNvFK8DibMSbjJ7VcExd94EOLD+
         e+/CD5/G/BIT3Szw1PhqTvyiQS3S92DxTHjLR0CMtqMTHxnCCLovAmjclwRz60xrVpZt
         tfxrTz2ck3YYETsT5S+7NOUdV2qoGmlx3JPi90K43NGGQp0eBdO0ZisrXuBaKkx/3zqC
         LGgzpXmvNy90i7C0DQBZc1A58l5Nb1nzJnSbAnCXlJ2HW8pgZruZKL+TzK5Utsws9LdZ
         GZAlblaNdzZHZTC1PTgagl8AF9lZdGyq69fqFRRj1dsrv4r9naF42+x6bmlwHZFrj1le
         qbjg==
X-Forwarded-Encrypted: i=1; AJvYcCW+Q0Qft4vVtyVJt4gDW6t0teLWSB27GImmrpAlpd4YVTSznJDnv8Gr8ElpBbdPQ9XD8hzaJcWd+A==@kvack.org
X-Gm-Message-State: AOJu0Yx1QlLRAq9vRBMY7y1p5WzT/cPLjGKBZ/TjHuCmUkmxVAonqBJO
	cxfNy7vDAFZ9znZCm9AWP2GFxURErxtUq5V/sK+VjFlB7OWB2Uu299iRcO138fnOWDs=
X-Gm-Gg: ASbGncvwEGG82cG2C75aUq3VWM2f1n1ErjTdp+B9OSUKjgCUGtBdrLBaPXB7lE+tdFp
	j/6QeadW5Gzo7oV0I78fdSHXGW5oXs3OczOv0qjQENv0I+i7GoOLE2ZNF6zK/9VsfSxmwIPvBgB
	+PtxvoTXvh0QGq6MlwFAr4mngdBtyo4jJTtKIb6qGu5L6amQIMDS/Xgq9mhpaWc+86geehZK0uM
	LaWtGMQL9Zq0fRPt1dDzu6s5PoP/jYqtlq6xFazuIgBI9e2WSI+HzpgQ/lPRFwzGExjqY0pLZFT
	wyUTyMZUqncf57e+0//r5Bdc45cbywq7zrB4ONSAhRpwETDR5entw5yh8LFTC5pqcXoZ4+W5sk6
	5DQSPUpSYrb1VMy+SDpT5/n+wsM4jj88xJBZHN6WY6qYbxXxPTeGGJGnOXU8sxgXJKQ2i
X-Google-Smtp-Source: AGHT+IFWJLoMlJoGXelrIQt9ocniJALkCftXGohMVp8CEHqCZlMQayonVPQ6X5ZOtEekzhDbe0VYyw==
X-Received: by 2002:a17:903:1a03:b0:269:8059:83ab with SMTP id d9443c01a7336-290272e1ccamr67703105ad.51.1759975141970;
        Wed, 08 Oct 2025 18:59:01 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.59.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:59:01 -0700 (PDT)
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
Subject: [PATCH v2 17/18] riscv: dts: starfive: jh7100: Use physical memory ranges for DMA
Date: Wed,  8 Oct 2025 18:57:53 -0700
Message-ID: <20251009015839.3460231-18-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: g15h181p5ittbb87b7u5n6ye8widmpq5
X-Rspamd-Queue-Id: 40C53140007
X-Rspamd-Server: rspam09
X-HE-Tag: 1759975143-160376
X-HE-Meta: U2FsdGVkX190taRRcB7UBAVAbFbE8E/27U8ZssMMfPJxeu02/eqWjSJ/B0H2PFShFzqzHblotrEPNdY/pXmclaZgRciFIuTMZa0KKyji5RfJI38bpdvQOmVi8p/biXuCfkXxPBB+GMDvNpvf3AIyOO41kNgP/kUISMDpg2jTHcrMLmVZQ86s78TX/SksGbnJ0K8W7qMtjbULxRLnM43DMscJAYyLO+Ew/8iYyhRkrHFGwBRG1jNy+IwjDIdksseBU6uG3uzKtdAGtYUjem42F+AqukGKP/yjFI63hw1Kol4bzVjolubpssb6GgkZEV/paPjDPOIXjwMLmKQ22J9BH7AayyOb8jwN8ecHm4s5WRVo7LF5TsqZXwPXhORslvTNVDPeQG+oV5cCScwSLAxJ2vxy2uM9vWyCZPmv/X6YwiCugTKMBBTdJz+IhF4tpzhx/6M1D3IziT0gnraZdyq6Sfn8Gb25I0jMrcm37zOhKJeNqOPg/ETuqDQjrwOM348e7pjPSxN/yABnzD1uJVj6hwlKI1YL7Rtz9AFAVMFk1Sfj4NsWDfb/xK0xaFwe8/xZCKQ1zLTdH5IMO08BzaE2Ak42yzBBk3MIoIOKHrZ6sLPZNv0PeOuyXQxOlEw0QCFLSfZ+UqcdWVhCd2o8flHADdRr1Q3I1tN7Y+AvCExbZ+Xs4hP+0+lztEdlwxwYOt/De+tbgDQ1dQZhjQa91Yz/LMeEHx16efM8QPBr2DAZiPITUVdubMvoWeVXqrf7sF8ueVNyeR4FP8UHbQmMYVZp/vv3o0KD9hzbWZJ7K8x3pHaFUvYxhCJod28qYWiBV2YnbzfduoxxjbaByeclbaW2XiUJiEGKvd/XOX5DUJWwXjo8p1+fxnbD9xwYqMEnS1545krymPg6+ePysMFynRCypARwadTxDcy+he0Et94Sug/Uc7dM9qG61E+pydovHiJvPCscZZYJNaDA9XNXNQu
 5Hr6XJb0
 RLTCvx770QvBs0ZCe9853bPD4TC/CyIfJs/nRe8bkFL0ShBvVmoOYevScF+kP3StsFonyVrjoDvqDjAQbbvFEbHu4bu5w9TWHOPXK6ArpoUSjBAIOqUDA4g3dS+FBUMrpocf0quTqCOaArcLePoR9axzngAOovM6r83vSrDPM8+1dj7bvFxC/t7ofG6brlqApczRYYBVOF0KwHEknR4GA+au/Trit8LkQufqxsmbB6CvitjLiYJVs7pkNtMPl9pF2VnjCKT1BFporneWnmPjWUmr5ECxTsgU/yV2PeL5s/s/yfc2GgGo1ndrZ4hv61NnQ5wo0Z4RLB3nXUTIj5UujNV2/Ito+TTq9nHFwdjr36MEj34wsE8YTz+dXcLs+hXhoc+rhdKMvzGK5IgjyMRYjyAaS8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

JH7100 provides a physical memory region which is a noncached alias of
normal cacheable DRAM. Now that Linux can apply PMAs by selecting
between aliases of a physical memory region, any page of DRAM can be
marked as noncached for use with DMA, and the preallocated DMA pool is
no longer needed. This allows portable kernels to boot on JH7100 boards.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
 - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected

 arch/riscv/Kconfig.errata                     | 19 ---------------
 arch/riscv/Kconfig.socs                       |  2 ++
 .../boot/dts/starfive/jh7100-common.dtsi      | 24 -------------------
 arch/riscv/boot/dts/starfive/jh7100.dtsi      |  4 ++++
 4 files changed, 6 insertions(+), 43 deletions(-)

diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index e318119d570de..62700631a5c5d 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -53,25 +53,6 @@ config ERRATA_SIFIVE_CIP_1200
 
 	  If you don't know what to do here, say "Y".
 
-config ERRATA_STARFIVE_JH7100
-	bool "StarFive JH7100 support"
-	depends on ARCH_STARFIVE
-	depends on !DMA_DIRECT_REMAP
-	depends on NONPORTABLE
-	select DMA_GLOBAL_POOL
-	select RISCV_DMA_NONCOHERENT
-	select RISCV_NONSTANDARD_CACHE_OPS
-	select SIFIVE_CCACHE
-	default n
-	help
-	  The StarFive JH7100 was a test chip for the JH7110 and has
-	  caches that are non-coherent with respect to peripheral DMAs.
-	  It was designed before the Zicbom extension so needs non-standard
-	  cache operations through the SiFive cache controller.
-
-	  Say "Y" if you want to support the BeagleV Starlight and/or
-	  StarFive VisionFive V1 boards.
-
 config ERRATA_THEAD
 	bool "T-HEAD errata"
 	depends on RISCV_ALTERNATIVE
diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index 848e7149e4435..a8950206fb750 100644
--- a/arch/riscv/Kconfig.socs
+++ b/arch/riscv/Kconfig.socs
@@ -50,6 +50,8 @@ config SOC_STARFIVE
 	bool "StarFive SoCs"
 	select PINCTRL
 	select RESET_CONTROLLER
+	select RISCV_DMA_NONCOHERENT
+	select RISCV_NONSTANDARD_CACHE_OPS
 	select ARM_AMBA
 	help
 	  This enables support for StarFive SoC platform hardware.
diff --git a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
index ae1a6aeb0aeaa..47d0cf55bfc02 100644
--- a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
@@ -42,30 +42,6 @@ led-ack {
 		};
 	};
 
-	reserved-memory {
-		#address-cells = <2>;
-		#size-cells = <2>;
-		ranges;
-
-		dma-reserved@fa000000 {
-			reg = <0x0 0xfa000000 0x0 0x1000000>;
-			no-map;
-		};
-
-		linux,dma@107a000000 {
-			compatible = "shared-dma-pool";
-			reg = <0x10 0x7a000000 0x0 0x1000000>;
-			no-map;
-			linux,dma-default;
-		};
-	};
-
-	soc {
-		dma-ranges = <0x00 0x80000000 0x00 0x80000000 0x00 0x7a000000>,
-			     <0x00 0xfa000000 0x10 0x7a000000 0x00 0x01000000>,
-			     <0x00 0xfb000000 0x00 0xfb000000 0x07 0x85000000>;
-	};
-
 	wifi_pwrseq: wifi-pwrseq {
 		compatible = "mmc-pwrseq-simple";
 		reset-gpios = <&gpio 37 GPIO_ACTIVE_LOW>;
diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
index 7de0732b8eabe..34ff65d65ac7e 100644
--- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
+++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
@@ -7,11 +7,15 @@
 /dts-v1/;
 #include <dt-bindings/clock/starfive-jh7100.h>
 #include <dt-bindings/reset/starfive-jh7100.h>
+#include <dt-bindings/riscv/physical-memory.h>
 
 / {
 	compatible = "starfive,jh7100";
 	#address-cells = <2>;
 	#size-cells = <2>;
+	riscv,physical-memory-regions =
+		<0x00 0x80000000 0x08 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0x0>,
+		<0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(1)) 0x0>;
 
 	cpus: cpus {
 		#address-cells = <1>;
-- 
2.47.2


