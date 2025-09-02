Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75FA7CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22528E002C; Tue,  2 Sep 2025 11:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A82878E0002; Tue,  2 Sep 2025 11:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972678E002C; Tue,  2 Sep 2025 11:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81B9B8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 47AB082F38
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:10 +0000 (UTC)
X-FDA: 83844739020.01.9021F63
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5C0B2140003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eqvltAeJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828028; a=rsa-sha256;
	cv=none;
	b=QCO6f+DZ5+4Nk01aDF+nqYKurcLW8eXbmKlBR7M0cq/OlKtICaxXz+hQ38uomUZ/0xZrvH
	UP7LPFwLNFjCwohOUjdxVkFTSo1f6VPMEYDI8efAU3SXsnF1r0vu4BFR8FEF6GWpLNmIuz
	EoPl5TTRIJfq62KBLZjiMfgey7ips9E=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=eqvltAeJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gR4jf6n49qoeIQa6xtB93bVvXG27Wam54T0FJ3gzKRg=;
	b=dm8FetKpqIUGUsn+Bf4DKMAxz9UzqBbnsPRwu/R26O4xg8wc+y3p0qzWJFlIC4+EkOVs+v
	T65EdnnHlrAYavrj3EBmhQdVEkWc3lsm4mvLTh8Mf6PijIWfmOcM8J8iOIpEXMW9Vlib/1
	a3e/17BC+0zFct8QGhQQaXqJjHlliRc=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-45b79ec2fbeso37672885e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828027; x=1757432827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gR4jf6n49qoeIQa6xtB93bVvXG27Wam54T0FJ3gzKRg=;
        b=eqvltAeJ9qFgCM35nHpD/nm6xYZp4Fg2hEZzqSMAf1LJNV+c4sbeL0Uib1U4+tljDg
         sfGB+6/ljT3dK7VESY8TDuLEvwzdz6moNn4opV4ZmVRHCLUxM+HAmowQcKXfYZauT2Nk
         OiEONYzuLmb6VRlhEOEZzBAdPH7dq1dxab/jKJGp3WQGs9DjP6eH7iD9Ai9p9Kr/HBef
         qmtmczPHmMAYZg6/+wXCFxitphFsIUD/O6jkJjPcnS09heAIGgJn8h6IOlC+aWzQAum7
         4ziZF99w814HBz565teaKDLxMVWQjpKXaNJMa0YZqWyk+H4ISHfzUCr/tI2HS8VHE7qy
         sNbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828027; x=1757432827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gR4jf6n49qoeIQa6xtB93bVvXG27Wam54T0FJ3gzKRg=;
        b=C6NSA+XwstQUozduBncORPmpuqslUvcl6QLtTc/FKRlKO2YRONdWFMDeTz0bvCgAc+
         7nTl5epNbBnxoKjz1yWmUdQrfqP3QN0gHKcA+jSgbGg5Kc3FKRvAy9pFw4yGnHG1LWk3
         1mpCjBrqqzWxRDIarkX4tGEVvP50QL21HpBUe4bVpuh4Dqn+hNi1KZgAP+cstHEQGGe+
         PxTT483mzdnkrC5BFsXvjUTOhAkxhTCW0s9wP5KEZFhS6jp5tRjcL/xdW0Hz00gWMYRy
         YuCwd/OHDIcQILsHPaNdtALc1uqfAUqA+e/DSBsRD0+qRrINypuOGwxxnEByVZF+MVgS
         3siw==
X-Forwarded-Encrypted: i=1; AJvYcCW1qgfT+WnAVwvKIbeR8JrIUn36rG8lH5+VeA0f7qgrbg+jn9cbaLSa9WLVZyi9UPl6+44Fv9Iukg==@kvack.org
X-Gm-Message-State: AOJu0YzuKeH+QKVyaf5NZu81FYvabXZuBTgi8llF90MuQ/fxOR34dH1K
	7h9nF/BTuukUkZvagLaG0TP7SAjpmA+Oh6fUK8Dr1RgwRJKQWoOwSv+v
X-Gm-Gg: ASbGnctb7ZMZSDO5rXoj8SO+RM+2F/16GnjRY4DoHb/ysQJ4mZrA8xX4yKw39ExZgpX
	/t2MDkV+LXtOXj92XatoMZk/q5s2d4wpuOmUiwe3wv2RLauy2S1qpEkYQz/AYh0FmFkfHa+z+wa
	d7o8vjynVaQ9GxpSqPRt5UL05cLFE3hKE7C8kdcXD2gKAW4LX+1tFTmpQYmCbi0v1pEXwfA8u/T
	zMdHK+o53vMR/KtrFc8//NMl+Hm5bJiPLE/sPxoDn3ALRATZe3Ng5Nihben6nw9KrNY8MikSmkZ
	soXt/7OjlBI9RO4eVOSUo1F1H2alnvc6Xv/uXAYLdguUJ8C46I2ltybAAs3bpOdD3AI0uNnnYMV
	KgyhWOEGoO6J/diBGgD4rEzANq7GNnfaexfxmw+xjiQl7JbGOQKlTisjej5KmFCAKv6u5Ibk/mD
	kjzKfAK12O66h8+Q==
X-Google-Smtp-Source: AGHT+IFNHaA5Mk/OTIBuSkxqD2TLa8EhamiFfXy+xcSVyFlskbg2S2fkWFhv/WICHcU/8LVjc1jWCQ==
X-Received: by 2002:a05:600c:524b:b0:45b:8482:b9b9 with SMTP id 5b1f17b1804b1-45b85e429f4mr103133785e9.35.1756828026881;
        Tue, 02 Sep 2025 08:47:06 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b6b1cdf05sm163708975e9.1.2025.09.02.08.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:47:01 -0700 (PDT)
From: Thierry Reding <thierry.reding@gmail.com>
To: Thierry Reding <thierry.reding@gmail.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH 7/9] arm64: tegra: Add GPU node on Tegra234
Date: Tue,  2 Sep 2025 17:46:27 +0200
Message-ID: <20250902154630.4032984-8-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C0B2140003
X-Stat-Signature: ds169sr8x6uc9w87w9qoea31q4h4ecjb
X-HE-Tag: 1756828028-949815
X-HE-Meta: U2FsdGVkX1/PTjB+eUBe/HpwljIY+Y3oF4hZuFVcQBe2Cq6i/cwF++JPXxkJi+MLPJeE3NRyhG2eA27ks7VMOOqB36UTrVs/rkfMGWwJdIvlvRVqOlwSduMzE8tdbhuDVuW3UGKHhbH7UBMZjmGEZ8BkdglzSUyDGdCcX4M97PrCk8XrQlPoU311PR7zFbAuK3UXJOocmO3632xEfLAfQ0Mz3pYTmAp784rkfb1WgC6U7vKhnz9UVBffb6ahPXaIWDGuGg2e/uIWnFo1KTzxRLGYBsgba9WO9bmaZ8Lw3Yktxon/filtj6cWxFAfBQELnT6Nz6Ttjv8/YV+dSxWwJVYZt0FrnKbd8zRzPJ3lJ/Fgbm3dsZxLH3RFo1bvMcB2IVaZ6rVM7VFW5qQX1s8h+RNahVEkyAV7xdmV1aRnkvilUz6TcnWznFlynk6UWeN4vwfy4WCx5YlxT/T9GuO20utBD0Mg8L+zwFR7vITwGlfNb8oBBsy0hv57PcqAQL76OFnelmf0E16plfXWt5Ega0cTrGGm6EVkIJ0eb7llEhDogkWe2GB34k3BELP2unbesQdU8TK6u/WSF+bZSFr7Bch3oYntOuvWaNKmbb9x7n/GqIJZyv3eFPtKjIYGNKpWl71e6naE56iMFjeIX6QtbE00OI3nYGZeBuONGHitujiAWj+SG4/0c9wi2sjH5P/oCznMUXnORt+OIVSre3aTdq7W+TsfZC9Qkfwflz42WoSegDDIZhkczAENzFQeYgHGuwqJw7ryyyGTShBOO9MSVbVcS1hCLVsj5nGBh5LjwjwwJf/MeCapk0nMZL1TyTjbnCothHrC0hvZ1pqcRY0QboLIKtnAI/F+ke+l6BPEj25GPiYIOPvFiquQ23WgU+yHMUJmcRZ48TIXa8CQHtQrM+G/4BaaIDesg/NUc5mVroINpM3SZYYLWH4aecYosPXm0hn0khyOmkFSeKdlCmK
 ycNlYqqQ
 VgYr+6s8ipa9NNw/KZw/ODHH2LxwaTxKjaatFbC2pDbOE6ZDFb56icyMXwDsCtq534h8qETdTN3JtipbmZIjP02iP1+QejJgSNcQTmSj21NVgPchKNGqzKJz/DPaF5DqPDOT9zZVjyJ22bp6p7t0ipLccyc8ICRSOWL4Vs3TpcITiivefUvRK89TjzyjkCHzeS17YVJ+9Q1Fk7h1+DUrSxmpippp18tI2dRyeXTdI5hqaM7V7VRGN+o+nm2NT1j0KCpghc4bQQkKXrlxLOTRok5o7gpVxNvv2dIPmFeOPZMEgozt2WMX9U/341z1JN2YS2DpGGB0BfRT9WRufooAOuk3g0GdF7upXRw8lfmP+jXxyAIkyWQGFHy5hrG1jq2hk4oIbXrgZ/5bTHzc7f25OCQZvxy+2eswAfqZ7PV1tb6N9SNX6S4Hl4PlGhRS+bFNcrhROC0gks+of2egoJUGSjlnmEenPgMoi56aS8O/Lh//06oD7l/zAX/AnbaPN1HAfebSgJuihs2jUXLFjeb+vb4Nzx+j8zucsuFh/t0o7H7jpVr6gDZCbpuzhwtVJPNgzbqPt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 4d572f5fa0b1..4f8031055ad0 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5262,6 +5262,23 @@ pcie-ep@141e0000 {
 		};
 	};
 
+	gpu@17000000 {
+		compatible = "nvidia,ga10b";
+		reg = <0x0 0x17000000 0x0 0x1000000>,
+		      <0x0 0x18000000 0x0 0x1000000>;
+		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "nonstall", "stall0", "stall1", "stall2";
+		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_GPU>;
+		clocks = <&bpmp TEGRA234_CLK_GPUSYS>,
+			 <&bpmp TEGRA234_CLK_GPC0CLK>,
+			 <&bpmp TEGRA234_CLK_GPC1CLK>;
+		clock-names = "sys", "gpc0", "gpc1";
+		resets = <&bpmp TEGRA234_RESET_GPU>;
+	};
+
 	sram@40000000 {
 		compatible = "nvidia,tegra234-sysram", "mmio-sram";
 		reg = <0x0 0x40000000 0x0 0x80000>;
-- 
2.50.0


