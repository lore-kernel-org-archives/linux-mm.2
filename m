Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B92CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 01:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBA18E0037; Wed, 12 Nov 2025 20:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A71A78E002F; Wed, 12 Nov 2025 20:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C44E8E0037; Wed, 12 Nov 2025 20:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7291B8E002F
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:47:35 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A0AB89898
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:35 +0000 (UTC)
X-FDA: 84103896870.07.53181BB
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 54754A0010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 01:47:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="P/zTPggY";
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf25.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762998453; a=rsa-sha256;
	cv=none;
	b=HU1YXAa5CylzyXzJaIp2FB2EqXH1GT3KhMkXeOBgpoLx5ACOQtTRvH60X9+GiVRwtWvYaz
	7tvSVkXPK2hSvCg4Q4e7OVmO9bHepk31J7RXbIv2MvZprC0d5qFErsvwPMAacjV+MBHvGF
	uYManrUhBn0LWgSc9o7s0sHh734MnUs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b="P/zTPggY";
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf25.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762998453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hmm07HI+8fQZ9dsXPTz2+pE8ZdXEYclRtD5hDrzxz+A=;
	b=S3N9J/8e5BifdrYSSXofqd5CJsP5YGH5uFpNxsRXOCY/Ud7mGEcRXJtUrRN7jVUnEEXXSd
	NJHzJk14HhlM7ZoN+oEUK/Pza7RNL1NnVwJR8QN2ubTQCouNUOjhNGW6NlwJmVNV9HYbE+
	A9A5AqYX+owshGmrXJoL4yNEJGuKZ5M=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2953ad5517dso3385455ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 17:47:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1762998452; x=1763603252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hmm07HI+8fQZ9dsXPTz2+pE8ZdXEYclRtD5hDrzxz+A=;
        b=P/zTPggYHSyryz/x+n8RbX+ACKAAT7r0mpz/O+Ls8wulJv6mNAGscsKpx048e/mrZ7
         dcJHLHd1635WtaODnN39ERpcQlUcuD3q4M4jeqc2afqLxZBmJ8+Jmhd6Gsf+hDHPT29E
         TnPNuPrhxUWXVoF40U6t1dYc2tB38OfjcR4lL2186HCG91DR5fTVHIyRVFppjewZA7Zo
         OUc6Ea/yN8qwHel4LqgajLOHqbjechAyBu9p5uWBscBGYZWlcLotW7GBT5sL0W7SDiP/
         B+pvpytxWHjeV42P9QoFO8fvpTggE1bpfjjckYkWWJre6SI7JQDcMPJOHe/5GlRbTd+Z
         QbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762998452; x=1763603252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hmm07HI+8fQZ9dsXPTz2+pE8ZdXEYclRtD5hDrzxz+A=;
        b=Jhf9NWHOJwqAy7zVYNQ5UI6rFXgj++qyREzmsB7iFg9oq0O+ZRu+j7PvCWfejMTxeU
         3vOuGbOE5ICkODbq2Dq9PjQWEaEhx2j4AkWMKH+o3rX6CXNpUe9DgRJuHss88sQwwPpB
         6CDMNYHDyiARyIzymtC0cZ1swtSmC8prfq8jBc/OnfHe7Aw5co7UBvX7UAgo/XEwqHyD
         GIDoxCMAcEE/IjUAjQCTfmEcTwnSu34gWyQX4eI1Y8EIBOiZwze7ZZULWIhQ3BEGyB2d
         Ljpz7zZ3MaUsgSXL/Mc0/hkAl8B/tWlY5XWI5X41XV4kw/6QF2nAVdW0Jcbd237uOurQ
         kLYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp7Wocw4aF2EGSlPNpMbs1G0TyiyMtmwaXmsa+MIbdSG9jszl6yvvvR6gCH/AYS7MbMWoJHr/4+A==@kvack.org
X-Gm-Message-State: AOJu0YyphUAsXL9bpjS62MhxcZN/7HlaY37Y+mrGsN1u1z0BRibvn1T0
	Ncy4ksyfITz9h6Wv0ilszUd3u2zNmqa/w49L1o92QLZXb27BtmP+GBNGWxWzP3Ar7pc=
X-Gm-Gg: ASbGncvXjjivk+AOmvRgjxm8sf4vWcUsc7AZtZ68/ED0Oxzz0HXEg2uy+zHx+oJ3iJL
	y57QFWSoCnSwMFOBTerqjvpMTgWNOnHZYiojbdhNifNM7WcvXjLDtTZXW4dNBnrN177ibT5xT57
	xam99+DcFD5Hjd3g7Ien1ipeouaSOZjdi2n20iup1RHxpkocuSGYGwMoTOWXlr9fkhEOeM8C8s8
	4Ra3ub+kft5uXZLgDHoKkbRieRO4Txbs2o/Kc27t3q4XkEeX70ToLe8RvPtCru47rnHs1SlPwQ9
	Ta2zF38J0hexMFeNRPzfVRIsj+z50ZWQ+37uvzvyNwF8HXBaUOKUM7DGe+7m2FEHZxfYjTWxm4T
	yoGPRLQUbfQttGLp7cjWG+f19gRjR9txLK/4c9+Sfh6AnlYVwvVG2qd77aWCu/CIJVkxs7oh/gb
	Vc/Vm0Of/G4tHtXE/2BIrF5A==
X-Google-Smtp-Source: AGHT+IHJJ32S+3DmD1CuHHRA6pREy7usForarOqF2N3irQZblubt51Eou/L7IV170eSGC/5u/UdVRQ==
X-Received: by 2002:a17:902:e841:b0:295:86a1:5008 with SMTP id d9443c01a7336-2984edec288mr76669175ad.38.1762998452211;
        Wed, 12 Nov 2025 17:47:32 -0800 (PST)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2ccae8sm4986485ad.98.2025.11.12.17.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 17:47:31 -0800 (PST)
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
Subject: [PATCH v3 22/22] riscv: dts: eswin: eic7700: Use physical memory ranges for DMA
Date: Wed, 12 Nov 2025 17:45:35 -0800
Message-ID: <20251113014656.2605447-23-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251113014656.2605447-1-samuel.holland@sifive.com>
References: <20251113014656.2605447-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 54754A0010
X-Stat-Signature: ne39twmkzh9izq66tkhs37u87n83sotg
X-HE-Tag: 1762998453-332235
X-HE-Meta: U2FsdGVkX1/90Id/ipm/vW+FRrr+KVbkjYK6OdhOnarvIRczygQ8dKBk0NGJvaVP2kd7O9wWSuvck2HzABQcDnzs/GwKiN9EVEscKHVgTI8zgZXVKW7jyc0aDlN6ODHvgiNn0M5Ib/yKlb3p1E/5Zs0WE6RooeTp71Ucx45qm7D0MtozXtKh65Ip78qK/9YAltasA9d2NqV67wNAycPN0kDAxJdHffABz5WdaYJEBVAdqPTOEp5dANjUelVOQlJYNINOLPgtwbxer1GXL7waKSscHslWFONrbPK+zZjnHlYnIPyvPO8bn2QpYE4nrcvt8JWj9Sohv7in+q8yc4h8DC5s3LyJK3/dTeOecZ+y9FcZHGkepOE+qSvlzKvZZa+iZIpqIuyDVymX8OzBWhfk0RpZG7QnXY82jJ8bauAmeNPzlhg4j3L24oQQ1b9y9jCR4TWGbvxKBjF7wjj5FniOPHscW1cj32L+2ejdf5jpDBgy4MXyX4q0v1B37FlpngnG43QSPWoVCDWmYzZV33emGv09qDW9BT1YxbPmbLyNEf68GXPIMB7K+/pU4Cc5AdrSKD1M6/3HEk0KGvGnBiznLLIDujHLOxS86S1VQzCGYgLdYBqsA3/DTP1f5WuEZJHahyNNdleuxV78kCvRydLTEatz75G7W/aUiNLNSzAkuFLHd4YyZE8unvgYr/l34JfyA/UPzhsVo5Ur/WgzLe4rS23SGrqgFEl24KxDBqwvIb3bWRJYJZembcjiehh2RaZHz0R6l4nXP0V2YV3ewrW6ZPjyzzYJw3VUlByHtJb2VYbLZQLeCud8WWjDbdUFOdclCRnSBk78akE+BsP36/vDUp7myqZluTGZ7nXfDW1bzfQB5xvPKRASFCEpSjgHD7Vfh18cn3dbuR6ZG5Hsq2XPaj7A4f1qKn/bij8r+3jBtTAt3Hu2KI72mCx/YL+R1lbHM6T7KKDrbhWqO27J1mP
 OFC2utZE
 HbDoZJp7jrrWYsNcy151jQXFHTj3wRJ0aMOCQAYH3khtmrnDo6GUFf8l3A14lCrZ6fThMYVf6hiPTb44R3EweqAz8FUWDpI/4SYZYEvz0jXDDh6UPwO/+4EPeIcBX9iXQBQ/TPiMx96zP2iqGH6mqOnkv9KedxxEqfj6NLWvLEOwiroaDWhF8C3W0R7deMd34haB1SpP99Imfc97MRKnD2teM/rqBweovMctYfuXk1JECCuRotQM6tOz6bacAwYeXykubzIoFD/a1V48ys8fGIIbZ8BCgMf/re50DKwPJk50sjvvpJpcoeNlOEqfb4DcRzJWa8JICjgLkAudczPmPHpSGBZAXelFXsDSCS9lzce3Ggg/Ex1gAErpG08T0ixMJkfhrzJs2t/C7SlwvI1W6gpjH0lJLR7lXcffEUOZlurw6DGqZW9911IpqNw==
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

Changes in v3:
 - Fix the entry number of the paired region in the DT

Changes in v2:
 - New patch for v2

 arch/riscv/Kconfig.socs                | 2 ++
 arch/riscv/boot/dts/eswin/eic7700.dtsi | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
index a8950206fb75..df3ed1d322fe 100644
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
index c3ed93008bca..d566bca4e09e 100644
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
+		<0x0c0 0x00000000 0x010 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(0)) 0x0>;
 
 	cpus {
 		#address-cells = <1>;
-- 
2.47.2


