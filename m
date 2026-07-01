Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A604C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E376B00B7; Wed,  1 Jul 2026 12:09:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC8276B00B8; Wed,  1 Jul 2026 12:09:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDE0A6B00B9; Wed,  1 Jul 2026 12:09:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A686E6B00B7
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 300AC1403DE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:13 +0000 (UTC)
X-FDA: 84940692186.22.4123D21
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5BC031C0008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gnz+D3Id;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922151;
	b=Xe3NHot6fB522Lc2Gan1KWaKzc4lrX3zW6P4gdBHyTX4SSzvYCJXxcgguZVXyex6YKfY+r
	nmQqI9SHxecIfV4zumLo62NBzxCF/1nEJguWB6LbWf4sDHSnzZ5L1PfPqM6JBR1mmlU2aA
	v3DQlShgCnEkIn+URLH+9fyFDAhaD7M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Unwf8Y0GemNXKUGqAL43H7EkFPlfBNoXdpGfDkeiBE=;
	b=7Afm2WOYp8SnossqU4jGVK4b6gZahFTxwrNgHOppt1qsDiu6FCSBD1j7FfFsyVdjVZsqKh
	zYwQlGAX9npHvAZnDZsJ6UDhv9ukICDsop39IRFm6mtkbClDOqNjbm/IMSZKNvNFmyhYk2
	y2gRHosqfEqimf4jTlH1QKJqSk4/PIQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gnz+D3Id;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C37143FCB;
	Wed,  1 Jul 2026 16:09:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD1C1F000E9;
	Wed,  1 Jul 2026 16:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922150;
	bh=4Unwf8Y0GemNXKUGqAL43H7EkFPlfBNoXdpGfDkeiBE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gnz+D3IdUXuVOVWa2GuAO0CPnDVDuNPxI0bxMgZ1CCLbmQcqis6eHmiljYSyH8TnG
	 lOk6cRve/V3j/loIu/rENCmrvJBobhijsDx+AMjsTpwtosFcJF5Wd62yTvThRTU6yO
	 fWFx+x5b5isRCdasal1QqDMqQpaCR1AoyM0V0t3FQnYkNbBMpw5t5REqFCXOHYvHqg
	 hw2gQQbs+1bC7Nh8wvxOctHBYU2LuWbx3mS2ooAYXkKhA8GF6kk5NEMl8mPwCC3OV0
	 TQjUPAo/t65zBhrwie/hGhZFf3fFJgm6KRRuzaJLDsLsPTXznFleLh1sLZBThbdUXB
	 YQ87n7zoHi5tw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:21 +0200
Subject: [PATCH v3 10/11] arm64: tegra: Hook up VPR to host1x
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-10-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
In-Reply-To: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
To: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Russell King <linux@armlinux.org.uk>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=treding@nvidia.com;
 h=from:subject:message-id; bh=KF8Sd3fIMlXn3DnsH8XZMC5FC5yldMYPw2MRMs8ZODU=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuGsBSQajHtTbkOtmApHYHmsA/lKcquSASmn
 d1AOS3I8s2JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hgAKCRDdI6zXfz6z
 ofmvD/oDrWOX50ibPn/1LcDdJ3M9JnaVCPT2pPYYaw4cvn8H7q7fnN45m4ssG0YXlBdvz/7SLCO
 sObxoQ3IIsIxrb+wMNWFi9d7GsP8EUeXCznhiQfIE1Cz88QTGcbB7nZiJczuTRgJytA3A0VaR4G
 2XC1Z+NHQth/+RFR0UjpMrIfr5llRXuZvkNe5carFTuXwZla98IWzpyIiNyRBu0+DYY04TCags4
 5dwj34kqTpvIKgtBURuhEfCRroDZzosR7KiH+UV2dFVxCcGw3cHc8/Qf9d78QKWAmO83v6GsNnG
 t59v7fBWy22fdMA2mHpAHmhF7xbS3mLPxz3VaXYrGPXocZvJyCHtB8NS6RQ+xd34T+KBcAiPGtt
 8kTD3x3xxjDELR6YubpWrO23cXTlK1BcDF/mjjOkB3QvVtHK+quJNQ94RyNsY9SlbAoEj8JYWBl
 K0Wkm8GXRAaKFGGVpOZxp/pmaPFlHMF4RTe5vBC0bVdpRUFU1DOt0dohjjr5YRJeOcK5zt92nfW
 NRcJsCqmOleJzM9iDcsnlUHyn4piqtCK0yxh8RuCvL5Ow7bIRnlxavAp5INYCcDhQxDDH0gvzNC
 XjFfyfbKFLQAP4DX5EWs5PopJ6VVeO2W6YJeQP5ZAZdQMeoUgFF0d6ZeVVGsgSeK41R1awYuLII
 qe1pmdgXywpsyGQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Stat-Signature: 3mcqga1wm78z85934hshr4c4ac6odqzn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5BC031C0008
X-HE-Tag: 1782922151-416983
X-HE-Meta: U2FsdGVkX1/bVVk+o17l1Z4F/hgxPPn17l+QSVcTZ1eEllVFc4hk9Nh1GCO8Ap3FvwR9SSpTx7urVXv6eYtHJh319Rc9LPDsnbHXyxYgL7bk3BBMmdknTzJtrOI/cOrkeNGoxP6UnmR+dcboaaGNrxfCgbVd/eP6Jrms8wlqM2Ab49iTB6vYTU/gjyCFZRGp14J/jWEpzQ0GDGwcLLPWOLElhsgR3PbX19LE4bJLq1E7VRSsZb6QTe2pGahwwDeCm0xrI8Q6WGqhlLD9P8GJ0Cw3Kq5Pvh2tyQW2PkkDvaq0NUX2nHfuCXkAKtlf05wCFJ4Xb7qMHt4x75NPs8XIIlO68ZCU4yNf9FdxihtX+AJbn2KWh0Kq73tWlk9Jm/iHRfKeKR0g4Uszsb1QJNWlbiUvxVgMluWqTdvj9TXN23h1rjScmSzoYaWelU6hMMykcgbHnFoqQKObBCZBIVN1Z0m/COvgL2lBr5Hk7ukBh6NGjRoQpEo7Sxq/ZCM8IqWEQrShR+TBlggaDLvY6sdd+X9djfmCMDNXqXWSiIEuQMXREDsqt0l51B9D4maXetZ/L00ncia+95xVpHXYlFQFGXTV0U9oB4SgM9YEH/R1lAabzFog/q/VA4bnmf2fu+BPeLGDohNzK+72fy72gphHIXiRmLj4unYbbg5QcbA9h3z3uNplYaX17hs94G+1VZJbWvMT55fLXI3ps+eqspRugnMY8c1+kzTTcPhCJ74IZnJvH6u0ObwSlrK4pqXdwWQ9E6WbshlBTIE3n+oywyDlZ6zy9J3UU1Tych0F48KIsPFoZGBzBn/2i4TIovGUY5QRcH6/LLd8bhULihi/FkFwyUHt+6mwaeTgXXl2QMb8DOoDCfjyKJfLl8IvkXzChawnpagWHIclvfqmK1/rnxudBqnJxsOs5MO++95iPh34E38UxKLYGYbFcw7Mo4w74FHXiCcnbAgP0gwuGEa3Py6
 XqBaJ5b2
 4rMesBdlSmjMTJo8ZWHiDUazRTvxivWwfbKzA5RHUPIkmUEAM5I0VXwNdweZqQhEUgXn1NIPJyDzX276qBw1O6B5KLBMjfCr7XjTZ+wDrYRMCjCLPRbkEwjVJvmxX+ep8f8jZgiWLgau9O8rRhBKtwG2ZnqInvMZqRnygwqCYbIBCMAI80UckhAWO6o+aduUnaBG2G7mxVvTcCHOM8B9FgaT4IGp3GBQCb/tLPqzH8tD6eIoslRFuobLLGeiUfBbT9qTqR3YgDfJi7XBCozoNsw5P2zGqvzT6vTUYB/xZ1BV8sb/QZOXlk3TyzsuHdKgeeBo9DZOJEiZES2l6zizlZwNaLVRbgMjLmlbH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The host1x needs access to the VPR region, so make sure to reference it
via the memory-region property.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 52ff11873580..38637e8e6fc9 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -4479,6 +4479,9 @@ vic@15340000 {
 				interconnect-names = "dma-mem", "write";
 				iommus = <&smmu_niso1 TEGRA234_SID_VIC>;
 				dma-coherent;
+
+				memory-region = <&vpr>;
+				memory-region-names = "protected";
 			};
 
 			nvdec@15480000 {
@@ -4497,6 +4500,9 @@ nvdec@15480000 {
 				iommus = <&smmu_niso1 TEGRA234_SID_NVDEC>;
 				dma-coherent;
 
+				memory-region = <&vpr>;
+				memory-region-names = "protected";
+
 				nvidia,memory-controller = <&mc>;
 
 				/*

-- 
2.54.0


