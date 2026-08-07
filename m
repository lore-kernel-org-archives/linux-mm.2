Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CA0C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786E26B009F; Fri,  7 Aug 2026 11:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75F1F6B00A0; Fri,  7 Aug 2026 11:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 676396B00A1; Fri,  7 Aug 2026 11:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30B336B009F
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:55:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6AD11603DE
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:15 +0000 (UTC)
X-FDA: 85074922590.04.B03EDDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id D1CEB20003
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fG521HT/";
	spf=pass (imf31.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mPDOfOXe06M0GKcvxWZbAFqQkr5StCJEdDzYqLh0o2k=;
	b=Vb+HhF4QoE9l4RNQSUlnyJ3gmcexJ3ibotxJ/5FwFh+cSVBBAK3WaNSfw265o8/NdgQhI2
	Dn0HEHHowKKqL1HFFKGbsdimo84xu1Ya2rLJNGPsVeU1SCqOgkqZAq1XhKo5bww1b187DC
	I6BLfGsP3NvM3wYNTjscLf+S7jMPSck=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118113;
	b=2g/TWkm9w6Tk3mEuJ3f/HdkTed4c7YriIS0vz2MlBmbD+oPp4ZQDdxvSR59TBXQThEubNU
	o8JzELAsKWjIsN6vUKeImkAubNWxsBJ5/WtRZdBcf6BsxeQgFZAEg+OAn4WWahFb07fb9S
	OYDSBo97EDM45sZbkNRDg2lw+mnqaBU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fG521HT/";
	spf=pass (imf31.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23AF142000;
	Fri,  7 Aug 2026 15:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C2791F000E9;
	Fri,  7 Aug 2026 15:55:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118113;
	bh=mPDOfOXe06M0GKcvxWZbAFqQkr5StCJEdDzYqLh0o2k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fG521HT/IirI5WHvsg3ZD+uAs3zdmwK92FygXkTKjBCm/AcOJlDxUvw9uwlkuAhF3
	 cZpLNPl6qGRdBNVS94jMATZ+sZ6d2dbsGanY/frc2XiCgrymAvc+c1QbHtjq2/OQ9j
	 eBgh+tNAFyLu19jjIMD6BS6Vb5dUVLkGICWThBqjCxK42klQ+GxbmJ7p2xfiweNWny
	 I9hZtEFpBV/bhq3COaZAsw0W6lkR99pGQ0GDyQengRi02T8pS+XEtr7LF2RJnCfM6r
	 xwnFsoOWY7plkQC3852lSZGS8eH8FyArearoAUeAE6fX2qA+7fF99cjXcrklLce+va
	 N2+XIGk+NG55w==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:28 +0200
Subject: [PATCH v4 08/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-8-5510d16af89e@nvidia.com>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
In-Reply-To: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
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
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Chun Ng <chunn@nvidia.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2272; i=treding@nvidia.com;
 h=from:subject:message-id; bh=0/rttmORifSF/NkVAelHN1lJzwrp59wyKhJRifwD9aU=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/HOH6+K4FOB3lnMZFEOz9yewRutVo8PCLVT
 aE24DZ6Fl+JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xwAKCRDdI6zXfz6z
 oZy4D/9Lh/3uB7Bu63ko1oCw6H8IhK2lPxhqPwXGKEeKQ4yz7BSw10VkW2Mh+7lM3Pv22ZqOztJ
 jB/jULLtQVwQTTatNrM+oC8x/HghXonSRb4BYR9ioSnogKZEok3zpAR+7M4dCV7eB3OhnrYPNMQ
 Eg6dSiMAT5ttcuM9uYlG/X0cQOBQqIlAQRuzzIlLFiIY/+pYX7QuVF8lcJJTO9jEJ6rOa2iwAt4
 h676JKAwYhz6pN08f+bVZptuVlb1Odo2ryD97nT7I1TXoT8WFveS/ZXGh5Shc+qNjUgp6tSWgSb
 T8PsItgz5exnBkUNJh9DJk4HRpPpLtSkJ0eMlWKX08yvjZPFhwugZrgwR1hrPKs0+ObHhysTQ8b
 5uv9esl8qnvMYSW05/DzJ1gGjEAnRsF4N9KjOc7vNpEfidXg541PdvwsDHiFh6yTSoFvLiKVRKs
 1bgru+oVbwyswYNJXQ5b8C2BiRmucpYXSKirAmbAJqGnJjQCQhIJenOVT32G6eTFTyr1HAKdbnj
 8vHDcDebJXpgk8Ozne9EC9ebSAAJyiBwt1hOh6QlospttywdJUXMaekw6JQm618xVCaqe316lGH
 UKKZJQWHWE7B8u1/40KpOr/SRpPpoplczQiM4yntSYyh6kKjIngCbACIZKVbhgbY7FnL2tlFFuS
 O2RKTF7rW11YLww==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D1CEB20003
X-Stat-Signature: mijc6mja5cyiykypmag6n6psmhfidsku
X-Rspam-User: 
X-HE-Tag: 1786118113-755356
X-HE-Meta: U2FsdGVkX182PdEep1CPAwd6AKc00poMx6SA1DbP03b4exQx2DYwt9hd/23I85JTsbDPrQPgx+pwDH33X1g3b37j1xYBS3vma8bShl0jQqPRyU9ikIwOTErfIqq6G1z/y/+Akj0Ib4QmsfUYY9m6seO/QSymA046vXKtT86+0qpKHjuV1CQuRh2QkbnE2TCCOr/LmYOxgFHrLDue5LIsLjrRUJuDiA8Z0/r6tegX8QsCIhF9xQ772XqzxL02GZCby4Ozj7PvBMd26UQmfpCsSl+bK5DF8kh+8x2YHlI0s0s+zHbihPotJ7zEdNjGvHD/tMAzqIhkuMuWrK3bHzLDFHY1SBztJAXTe+/N8cJOcoE6EqqRBqd1gJWNAyRllRJsHv0OFErFTBrZp6eSEkUi2JUDEdNc77/RZObgqEUXoxb8vK6G6dPbMn/W+bQIX40XvAAUla/GGR3VMNC58wW7ZKL5tj9OmHGDWx0jGlFMwWDkbotWNxqEGFQTyPtpnPftCFSksHDSt71irUNedEuXeX+s437wEn1dMQYeVwwk99IOF0SEZsbElNYQGwc+yjOlTyP3q9l2l+no6SlFrccqDg92eZ2XbKfu8vtKaaQNJCGYv6eOUbzio5RZ7AFyH9sG7lRityZ36aNH9yv5EhKUlYheOlE00sATLjcmTGkV02mMcuTahtxjBh0cKU83/cAZWdffVvJcmM/sBgVGzvfgwKVounAsJy7tuaI/WRd9Q/Vk/AbX5xWKawJy9XD8/LgWzZfaEdnqfNY3pdKBJaUw9CMCbLPERRi3n9m+5qDHPg+ujy8F3O9dyHJjqi3a2klqJYKhK0iMcg+tT4hNXF0dLiRBWdVz7cD7KwukXbZDrK5yPrmRwEfwlOU2qkuYCM+ZQCyfiC0dNyxGV5ikOpkLrOqQ6+bbra3ie0qztqHx4Tm0QnXCykPZJ12rq9/4kxxUoBFe5J/IUuQ48Vkm5tx
 /Z9WyheH
 5VqVRn46SDjYrrlvlBc8FiWtDH09rh5BnEFn1auIEBv+UNdAYghLtLj2/lqMbS/X1/3DnalJkjAJDX1ij19UDEj5FhjrnCpg0m6k6zNYrrU/PNfDYNzQMjLmojvXB6vBl9EwHnf+WiXfLKSggOqER04BQ++b4vczpx0bR2OmXB/0UkBJ33tjXYvRp6Ezclg2P/vgR4oT2U0d6SvIEHrq7qxQXmLmOz9/3qweZo2ST55r5m7Rph2WuRl2C0aw4Nt2nnOar0T7goKZDf8H7ql4UKca2OMQhNjUnHZHgAOgLa857b/brLql31jR6U6Y8sGEya+smLmxYu3LMaDgWFiL0vzaeRVtTr11n2ygB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

This node contains two sets of properties, one for the case where the
VPR is resizable (in which case the VPR region will be dynamically
allocated at boot time) and another case where the VPR is fixed in size
and initialized by early firmware.

The firmware running on the device is responsible for updating the node
with the real physical address for the fixed VPR case and remove the
properties needed only for resizable VPR. Similarly, if the VPR is
resizable, the firmware should remove the "reg" property since it is no
longer needed.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v3:
- comment out fixed VPR properties, assume resizable by default
- rename node to "protected"
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 39 ++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 5e29316a4d75..6c4739efc8a5 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -29,6 +29,45 @@ aliases {
 		i2c8 = &dp_aux_ch3_i2c;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		vpr: protected {
+			compatible = "nvidia,tegra-video-protection-region";
+			status = "disabled";
+
+			/*
+			 * Two variants exist for this. For fixed VPR, the
+			 * firmware is supposed to update the "reg" property
+			 * with the fixed memory region configured as VPR.
+			 *
+			 * For resizable VPR we don't care about the exact
+			 * address and instead want a reserved region to be
+			 * allocated with a certain size and alignment at
+			 * boot time.
+			 *
+			 * The below assumes resizable VPR by default. If the
+			 * firmwares sets up fixed VPR, it is responsible for
+			 * adding the missing "reg" property, removing any of
+			 * the unused properties, as well as adding a unit-
+			 * address matching the "reg" property.
+			 */
+
+			/* fixed VPR */
+			/*
+			reg = <0x0 0x0 0x0 0x0>;
+			no-map;
+			*/
+
+			/* resizable VPR */
+			size = <0x0 0x70000000>;
+			alignment = <0x0 0x100000>;
+			reusable;
+		};
+	};
+
 	bus@0 {
 		compatible = "simple-bus";
 

-- 
2.54.0


