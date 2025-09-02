Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97FFCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E758E002E; Tue,  2 Sep 2025 11:47:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDDE8E0002; Tue,  2 Sep 2025 11:47:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CCD78E002E; Tue,  2 Sep 2025 11:47:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2631B8E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:47:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E563D1DCBB9
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:19 +0000 (UTC)
X-FDA: 83844739398.13.70E82DB
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0D2A540009
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:47:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Egm2k5gX;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828038; a=rsa-sha256;
	cv=none;
	b=zSaRpmgvuuHz0Yqre3nYGaRnm7AyZkKg8Mzhn1CDRh5xCBX8lJzZyIeQ3y06h+kdpnRwhL
	qM8VhCLWJWozIgMVq8hog898Uf1BJ2qlcvPC2GpWQLigN3B/SwhQ0CrBH0jfmNt1oab0v0
	B6tzK2Mi3mpPs20wF1ZADHrIszzEi+g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Egm2k5gX;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=thierry.reding@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sg/JpW3SvRZNED9bEp4vwHJ/+yfFIdl8fwvEoOosPbg=;
	b=XsWeq99Pzlzh4DCD4rvFmZ6s1xJ1bJQ4D9qcCLd7gefd48cEZZbMts5CADHCRBXmBUjbyT
	z1R7KXiTwaaK9PCJN5ypHOcGKbLKquiHz9qZZK8Azhr67wKFlDYXEul9OkyC/ZIQwkgWhP
	4NfA0UK69Ik1WGAkoRjF9+v8OifRqhI=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45b9853e630so8483605e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828037; x=1757432837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg/JpW3SvRZNED9bEp4vwHJ/+yfFIdl8fwvEoOosPbg=;
        b=Egm2k5gX6wVqITvBEpQs0F99n3l4zodun9oDWc1jjqEec7GqgepuH64/a7c+kiaRQn
         a0n2uM4Kpc+gr2YXmMnjNPL6/KD/qhTLOUrKpMp1qMLBlnKLDyTIRo3NLT7rz0pGae02
         RYKfe9iDzXFL809YEf44rjDEyGFxW3CRecbQR/IjbxVL10eJ7cqTzWf5j9/ENbIjh+Q7
         +HDTXuZEFaeG09n7OKGQKpAjVGrlj8RZpF6/eEHnZ/oyer1h+eE/HehGSI+2VZ7HVSFa
         IrDmTHFvik1GwunucTrW8ubkMIdmzp9tD1EIr2doFBiF8MiqThv/DenzdjdoyhGOx2DB
         NhqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828037; x=1757432837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Sg/JpW3SvRZNED9bEp4vwHJ/+yfFIdl8fwvEoOosPbg=;
        b=QUQH+nBZ1wHGh5B2Me6mQmk20rz7QvbH+ctc0g17av9sJiV/TIVE2Ck7LRisAn2UB6
         S4ffnsN01mxe4alcMXdqs8QYvpt/L4TO7Qog5TYpoBWm9Ik4hjW2IHSbXHSuWDkq1RU/
         ZdfAJTPbnWrNuxDzMu92kDdoLlEPNylTstTcZ/TbK+J4TfVCFyynz0MxDfSgozrDtSZH
         /cuXUgMKBRvgLrR9UuwwmByVYpt+wx7vHvDJSJAwNbNrvYpekAoEWIGxu/UaLsrQUA9S
         xY3oIwsLusF+s/FnXl1MoWzMN74d6Dr2XXvmKrCuseBJ4GYiJ1bcJK71YcsrugWNrxan
         D9Jw==
X-Forwarded-Encrypted: i=1; AJvYcCUE5UmhPEiXVFaH7QrhLGKP+cPti+hlkdKA3Tpf2VINJMEMyOomZbTLF7AU+2CIrJbvhYGZFB3j3Q==@kvack.org
X-Gm-Message-State: AOJu0Yzzl3EYJtk/qMuhDaiQDaCrKDmk73t/0tU8WVd7/fzLqDIZ2NCa
	zB+VVCVb+LQJdCeWfG+/2njm8voGF1MBce1c+nnoXY/aZaxVr6XsvPR1
X-Gm-Gg: ASbGncu6aJQUeKhrWORQX21WfG6O9KPvwCbm3r5OvQ3IOBSJHDQvC9tsAxXorPldMKB
	AbGD037xP3ySIP5TkZ5Rj8zFqTQ6Nv8rO4OC7tAw9cROf3cKi0f2vOKPd8Sk9Qpq06AekcO6sNz
	vowid5JbXXYAcJwBEUF1pC3AwghHK2g9nSrRQIijO0WXed0meV+v6dt85rvvKeBoJh3xBzC8YnY
	q2Ky8hz0ZsTvmeJzMRRCVAcTv/fSpB4oAv38EuINLic3tUAC3YdB2OyTw/0pcKr/7bdIH7P8O0a
	1YI6m8XkYt8noAdc/6Ra9QIy0lgACd29I3kWE2cSNMUsim5bf7BaMXJm+uBRm6d+vVnyhsTVw1G
	AV46ckC0LDEM06uU6n8bLhyA5A0ddL0564+o92InmwQwzvs0U01lALA6UFUkJ238ULNvO5D1xm6
	2mrQJD5GKORstYHANZf1bU40NG
X-Google-Smtp-Source: AGHT+IG6QkcfvyEfQHcIkt21AHSSn0KPT2FNEyPTNaag6qHbdAblJtYW9hhT/NvtJKA8YQoxfOyM0A==
X-Received: by 2002:a05:6000:2011:b0:3c7:36f3:c352 with SMTP id ffacd0b85a97d-3d1df444ad2mr8516244f8f.59.1756828036486;
        Tue, 02 Sep 2025 08:47:16 -0700 (PDT)
Received: from localhost (p200300e41f1c4d00f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:4d00:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3d0f85c287fsm18228079f8f.52.2025.09.02.08.47.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:47:13 -0700 (PDT)
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
Subject: [PATCH 9/9] arm64: tegra: Hook up VPR to the GPU
Date: Tue,  2 Sep 2025 17:46:29 +0200
Message-ID: <20250902154630.4032984-10-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250902154630.4032984-1-thierry.reding@gmail.com>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D2A540009
X-Stat-Signature: quuqx6n38e4hto4w4w8fzijka5saai6i
X-Rspam-User: 
X-HE-Tag: 1756828037-591004
X-HE-Meta: U2FsdGVkX19QSFh/LouY4E6xEbeAbvhoUjV0nWndBiluXlDZCp+VfK1iTTw5e9V7rwY/60j1ymQH0kS2C9FA2vEqzrbjz39cEuST9dvZ3nXb/6fdM9TnT9qYOFoJyT6LfoPFoPlXTACBXcx6Tlbcs2cmy1UJeZr3IuiRLHyAYjwkF0Z6aOCg1VZF2615hJrqq8kxDBCmTTmgSWrhMRO/jOUgo8NeEwYRbJTQBb7vQkIQwEqmHv4G/aHAKkEVpsHmJCsE4fgimcpExYyt2dgCQbM2bTL7Z2FJPF/AG2B39AhgHBsv383M3zy1+XWcZc+Ebl0BNdSkdF2tFn1MTyWVpm81Fb5xkqlkqzpkdCcZhQHVOQyqMQoUEK4ubTzRBtRVuMYYiDwxu8ie9sRTllv0ZG221Qp261GPPuAdkSgKUqKYy1JkdhKWlrgoC7ESE+vuHK4sCJQIvXzdrlDDEmo3HvXrk2ciRF3BEqkoYI0eOu4bskZQZE4rTk+RnFY3NBpsUXcGAa1Ekr7kgn1BBW/K7lg9jGMHpU2XMEFxDMvJLwDWZ0iiOe6le7DvPb3Fo+d2onuXVVRebus6zxAFWYr/5s8X/gA9EEJWEWjUcqZfFNni5W6F0rlmbgI+dy3CB2wNxJKhL+5xzUAY5BonQSx8dZi309vp7/9uSu9nlixRCU3BvJaldczNbEsHSEsAfwGoQmdA2ZG/uXKNLjHSergFzQTFuLpiIuasPayvEBsosj91bkJR+MTjsUVJs5wXIqTee2mcGrg1ij4Pq9HQIiAEXALdlIuXzxuCu+lsMRJ04CpaZXd6zcNiiLPvxOQHN8UHA04Pl1ntBMcFFk6dvLVKuXysGOGC7nABhtACdpIG0KicusFyEQaKY1ur3ZNM/VPDT9KUbScNmId4PafSsQaw5qy7DYeLdXEEaMWiG/SUbzFg5z11yaE1W2crrKUoXy7KS17t9EuGAoUDef2YSeT
 gIyKPAce
 vTapnQ96X8zO3+NLRCcRy7GmfIn7LUx1sg4a8GUzAdVc5H9pD9MQ/og5mZfS3g4ZOsQpCE3rqCJySdP9RfbSSfbYDLTnf7OC07BMYFtxl7IQrMxvAtWI5BqyZAkhkxRykPQW73WdW1fD27tEnxupgz9h80PhkH3jOC3uuilu9BZlVT900+jC+3kbSO3yE+BiNgRifuxbVa/2lZPXBziZ1aUBEnCzvLFlUoN5ttaoNOP6kjdOHfwCW3qODmpmMpUmHg9kReqFtR/225o2Ub+v2/OvXrrYDF1p9G4HppGVd2P0GxfIA5xgmZ7hXpUlLTkn6iMetMLC/Yrq5qyCviKs1OkIHw8E3VjEZFmJv2uekF+fs2vSvke+B9qecxjtfwWZlHjc34cbVJ7oeMpTyrun7a3bnnfFowXl7tFFnDPl7SakZnqKgXKB9ln4OSGNCNk/8+3edCSlUCc3c0qFMSau0XDoPqNGX0PdDAAqyFfeZYTROBcnDulGyLR4L+K5RDu8hoMoFt3PG+8BbbBnQ4dt6aNbYPYCPux6opBSa860MxMIS2bi5DhHy9cX+2BJD9qj6nW1Aj53i10W60bzgOlVDlC97kdfMeIoGkGd5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The GPU needs to be idled before the VPR can be resized and unidled
afterwards. Associate it with the VPR using the standard memory-region
device tree property.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 0b9c2e1b47d2..98d87144a2e4 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5280,6 +5280,9 @@ gpu@17000000 {
 			 <&bpmp TEGRA234_CLK_GPC1CLK>;
 		clock-names = "sys", "gpc0", "gpc1";
 		resets = <&bpmp TEGRA234_RESET_GPU>;
+
+		memory-region-names = "vpr";
+		memory-region = <&vpr>;
 	};
 
 	sram@40000000 {
-- 
2.50.0


