Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E056CD4F3B
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF558E0036; Wed, 12 Nov 2025 20:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5699B8E002F; Wed, 12 Nov 2025 20:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F988E0036; Wed, 12 Nov 2025 20:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 08A4A8E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA9DC59619
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:33 +0000 (UTC)
X-FDA: 84103896786.19.A449036
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id EE9B81A0008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CeC9R4mY;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIyypInid2MwkGhGpFAF1f6X6i4zsYo4yuxmmc6uQIY=;
	b=VDMWv3tY++3L3z4rlT58rcdR3jUaoYC++Kvq/NdGeAaQjL7eZuJYwC0Qa+KfgPVWPgwkqJ
	RtGOFIHqo9IYGVylvrHhdED1HcX1QCerWBSVzaLN3DsMAlwT1jbhgKZjNgRZRgsST7uskU
	YkI1tbpYQk4zXeBXZwpp/fVz9YrdFjg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CeC9R4mY;
	spf=pass (imf19.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998452; a=rsa-sha256;
	cv=none;
	b=fGJGmtu3C2gk9yKt0HgYvaFMVHlLHfHdpEpIX0N5V3uqLGuVnrir1ugxkyekapIzLPXUCc
	7lKw19Ugw6mjsJVftofGyk9DyzKp4AAD3Qoj2WWi89JKwvOVVsqsg1rLT09KlZPqZTgVEd
	3NBM/GWr2j2JAVjaoaegh31SuGKwiKE=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-298144fb9bcso2810495ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998451; x=1763603251; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wIyypInid2MwkGhGpFAF1f6X6i4zsYo4yuxmmc6uQIY=;
        b=CeC9R4mYEShI7aa464w1oYjWr+sRMBcFQr6NUs8muh2lzbcBEsH5ChqOlQnpSzj7PA
         cj604zPYzA+M9934a9aPOxACr8N2n3JiPCnTSHpmbGTD6yv5wrQRV1XIsq3VjuO+87Cg
         TcKvBM1Cz3NHnp+rXgqwkS0ukZ08KjMLyayFARi8+1ptJAccOBQB5iypJfttcWtHZPYT
         svnD45gHSDrpWd43rYdbDFXS7XiQnYo4c0lV85iC8LPV+iNcz58j6UISdNbdErAWOjxb
         xygNTtTZ3hyMehI0cIetjWKPCY/WE2Q5zLGU2hpPTSqdHqEEga0sDroQ4iMaPU+QEnOx
         UwpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998451; x=1763603251;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wIyypInid2MwkGhGpFAF1f6X6i4zsYo4yuxmmc6uQIY=;
        b=wkW+d9m3QaFKQsa0aYdWfqz4NRwcBrd/6J1P3zS9NpDPos6oObzU2yFNhsuFfDhXmQ
         yqsRXr0YR7tfsSx3nW3BZ4oJQ8ia0LmKFYDQZOcbS9PFbpqstAw2yfxhuX99b7k2qALU
         sKHceosLKP/Axm1C3YX24YIZ/TXSl2F2o/X66kVz802N29jBYVlzWrbY51Nd1m4YQfLl
         M5+vS+wMYlnSiEtwJJJVNoTxGGmEa6F4a51pxx9TMi6oL4CT7XwZG/CcguoyZBg57lfU
         +LUgyIqdTYvyAJf4melh94oyDraY3mFUmVHpnoO3CZb7w7vYQ7wl0GiCjh1a/dYNWYVY
         h82w==
X-Forwarded-Encrypted: i=1; AJvYcCXBasTdSPC0gUjsD+rqn7316zZcdAtXqMq4hYl/2IlLEA6JFTAO99HvkSw36qJOSQlbGbrBU9LMRQ==@kvack.org
X-Gm-Message-State: AOJu0YzHjxuHbwU/D9uudOrfwspnvp0lt3NGWep6Nnj2NYa52Ux1hI+J
	kBW1bWJhsBfIevRsHCE4ELEDGoHRUANgxc2+Ir5f1u5o2ZkGm6zVJDYaMfPQnvV/sGo=
X-Gm-Gg: ASbGncs/zrvNTPf59ZgOiiyUrsaCGERvDCWnCOu33I8bn4VRcEj5Ww3IdlcuttI65C6
	E2eJbuS/FwPbE5lWgpkbOa5bG19UzCKmEEGEG2gx8g7Y6khwvz9ntN8wWtHjNHo9HODydnkvGAX
	nwLiXtOeLixz16kWdNrmTNLm2f98ZXoIje7dpIVJpHGzm+pGnHsrSq1x2RM7I9mxeXet7rnKoG2
	PMqNuhX2iX0dHMgvqSsmzAOT/kkLxu6vUuvA+6AoR7CDobNF/FyfwseBjUnS4OY2wkBkm6EPtMU
	x3D/HTHQoyXB3xiyW88IuG9jS0Xw15xb5Gy/rhnuhqoTfFwXtuv9JX0mdAynK3XdQHnExyf6bEw
	PyrM7mMfHvlhYzboq28iKTMaHDiyR4YB5hxrcSEUeQbMvwAq3XpAzyX/a9QMXN3rg3CZM5n9QER
	hQ50XPdoSM7ta8ciwTjPl4Dg==
X-Google-Smtp-Source: AGHT+IGhzNzxLSTgH/bqs1xeC15DK1E1CUXXoyAWh/vc5uUnq6cTBbEqNw4BT6XDJfCz+C9XpqJ0wg==
X-Received: by 2002:a17:902:ec84:b0:268:cc5:5e4e with SMTP id d9443c01a7336-2984ed30d0dmr70448205ad.1.1762998450749;
        Wed, 12 Nov 2025 17:47:30 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:30 -0800 (PST)
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
Subject: [PATCH v3 21/22] riscv: dts: starfive: jh7100: Use physical memory ranges for DMA
Date: Wed, 12 Nov 2025 17:45:34 -0800
Message-ID: <20251113014656.2605447-22-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EE9B81A0008
X-Stat-Signature: 4dfnj9q7bd3kzy5aqubo96wdtcz1x7bf
X-Rspam-User: 
X-HE-Tag: 1762998451-746064
X-HE-Meta: U2FsdGVkX18tRQJ84T6KdUIlhMuxMeWN1j2/fgJ4jutM1YfNdlzj5l8CdgzTDrGhgtZ+apm307SqxmD3M3cRfSkiZY22pFE49XZdQb9g8jLqoiNCkxgeDEyDv8s10pVTt7QDvGW90HbMZvGVFjmb9fYT5F6v2gC/vyUthl8VzpHzHpvgcKPRf4s5qfxxyyYti/nrJKgigSXiqlBF8YPWlDb0p7LXUAFA7ta4201pY6CrwckGWg08f50mKOX89v5fRrLDXvoyV7n0aOvIanhc1zVYQVsWaQla+lXwEOfX+XXvnnnLHwx2cuSUxK8yBFhnt1pz+sBOyzeKiojvJC/DHGZPwbEzNzUE8IBK7a8d5mPPt578E/MV3OFHVYzNbTFdSBqqqytaThfyuBK3tcs4v8tWgvvEESdqNdhIx5rN7jdaySbFVjomUCPXQqqNO3g8VJ/rHkrNjORQW8G7Za4zyGhJqtCTwsTVa7CkDbPY5HtHkGb6oSW4MgxKl6HWolqlWyV7zppZu28i+rYc215MssJqR3Fvy8RjUEO2t7cBjUvZe9oDG7Jd7L0j4MQcZ9PKZWGCb2/MZBTf1u2AeA+s6E/k4AQ+gv1BEBlX3AFDhnLxlSGCZzZlvjMW65E2MadPXAccJJjhGFAA97nO089atIVUmAqbaL7b0YfZaYDUgkwe0Zsh45/vQhjEnBN3tEh2uESy7FlivIqWtpu4/VoXg4/tIeUZSqUBpJsSwu/dSvUcVUY9Wqd57NkkN5+wtwvpe6fdEgyIInH+YPdGBjEyn16UaigkVHV3dRGnq+EtTX963Q1Zj7NfWMn/iWEl2R4V/G+sjZpB3IDPDe8Jf+9D94vNlf2P+Uk7QSBQY1qzqIW3N5x4n3cd2PoXy8SEB04OTKniano4carbNlkkpmKA2q0PE+H7yOxuPXPvQudute4zUq3GkffJmb1C09Iinu/aD/fdoqPxKE6z6GpjeQe
 DttReOnS
 sAXG1pT0+Qi4dBkf4Z7AIx1wu8jBI+LKeBMiXQK/M5Wq8SZoB/vN8LhfkmLDgbRqdENP/L2YttBRphDgHDnVJg8Vqg8ZZmprGpgGbQnM786VECCTMWQcazbsR4nzaDc4c51GCREsX36QT8oPy4ymG92izbFTaOcbbgJCCjYYgM7HIhzQKKnlRx6aMe1g9I7S7YYdhiBRw5ENHbBtzbTv4v/lgv2GEqD6aB+/aHVoVkQNLqetBmDwG+OqOjmn0GQqetPlLFcNCivm6bVbUptJmcfKS4Lis2kqQ7WY9tbCQosKzg7M8xGYCs4QNnpIO7hljhad+myNdneqrhx3IcP2uDms6xSnMU7tSPcRS3PZjH3d9EngFAmGJyPBhUfqAPqjwOixwvbLToccSJMnWDIqcqj41iQ==
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

Changes in v3:
 - Fix the entry number of the paired region in the DT
 - Keep the ERRATA_STARFIVE_JH7100 option but update its description

Changes in v2:
 - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
 - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected

 arch/riscv/Kconfig.errata                     |  9 +++----
 arch/riscv/Kconfig.socs                       |  2 ++
 .../boot/dts/starfive/jh7100-common.dtsi      | 24 -------------------
 arch/riscv/boot/dts/starfive/jh7100.dtsi      |  4 ++++
 4 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
index 46a353a266e5..be5afec66eaa 100644
--- a/arch/riscv/Kconfig.errata
+++ b/arch/riscv/Kconfig.errata
@@ -77,13 +77,11 @@ config ERRATA_SIFIVE_CIP_1200
 	  If you don't know what to do here, say "Y".
 
 config ERRATA_STARFIVE_JH7100
-	bool "StarFive JH7100 support"
+	bool "StarFive JH7100 support for old devicetrees"
 	depends on ARCH_STARFIVE
 	depends on !DMA_DIRECT_REMAP
 	depends on NONPORTABLE
 	select DMA_GLOBAL_POOL
-	select RISCV_DMA_NONCOHERENT
-	select RISCV_NONSTANDARD_CACHE_OPS
 	select SIFIVE_CCACHE
 	default n
 	help
@@ -93,7 +91,10 @@ config ERRATA_STARFIVE_JH7100
 	  cache operations through the SiFive cache controller.
 
 	  Say "Y" if you want to support the BeagleV Starlight and/or
-	  StarFive VisionFive V1 boards.
+	  StarFive VisionFive V1 boards with older devicetrees that reserve
+	  memory for DMA using a "shared-dma-pool". If your devicetree has
+	  the "riscv,physical-memory-regions" property, you should instead
+	  enable RISCV_ISA_XLINUXMEMALIAS and use a portable kernel.
 
 config ERRATA_THEAD
 	bool "T-HEAD errata"
diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index 848e7149e443..a8950206fb75 100644
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
index ae1a6aeb0aea..47d0cf55bfc0 100644
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
index 7de0732b8eab..c7d7ec9ed8c9 100644
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
+		<0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(0)) 0x0>;
 
 	cpus: cpus {
 		#address-cells = <1>;
-- 
2.47.2


