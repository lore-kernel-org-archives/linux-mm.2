Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC0F2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6DD66B00B6; Wed,  1 Jul 2026 12:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D926B00B7; Wed,  1 Jul 2026 12:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6A16B00B8; Wed,  1 Jul 2026 12:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 61ACD6B00B6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D78A440424
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:09 +0000 (UTC)
X-FDA: 84940692018.29.069D0BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 11946140019
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rujoh72K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922148;
	b=LHNHjefbF1ulk0hQ4KCpoyumR60Ded5RtA+BHXprDiCIwYcBc9Zvu9rKzH3yGJQxLEnS1s
	sfpjgrIq2jjHqihSw6d9jjk4zcA7uByIxBWq5jBLSSNS7XmOaMf5aRVvrVinh8UNPpkBit
	RTTmve3nTVq66wtPqefRwuu5zU6c4O0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ebEB2H/J6xhmM8tGmq1WgsfMgc2XbNLRd0nmJfEaDE=;
	b=10U6+3uCWtkak+NPicp6rlPwZUDWcrsOsGbuDoMFHE7tDGWViYm0JdnIAZNhmEjHjzE/T/
	gSRku2WiaM/YgnCFjpVGJIy7zbjoBu67kfK/4/dtxchHO+uqk5OXJ6j1Ghisx/HTSN/Mxx
	Uc2L8QPbVzDC2KGQiYmhaCm112BL3qU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rujoh72K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F7C3601E3;
	Wed,  1 Jul 2026 16:09:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF0A1F000E9;
	Wed,  1 Jul 2026 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922147;
	bh=4ebEB2H/J6xhmM8tGmq1WgsfMgc2XbNLRd0nmJfEaDE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Rujoh72K+7mKLkPmqRGDKQkhroD5icrZjC2k0laKUACn0kCABee63Qx8ywXLJJIQH
	 FJb0pEm0zcakzYB9kLuqGE+4ZzDn8Tpp+ATkiPleRFEy1e+GnDXwY4n/Us1Vv34962
	 5ypVutFB/TRPN7vKL1Xtt0pZWfVX2QEYOiGoTV5dtJeOZI+lRdptUHJnHV28hjr7hw
	 BReJd/LP3wt2HhmhoHcVGlztSKBaxA79LDA7Wrp8acnjL0CBpO88EeQs04bOBbkpT7
	 lIBeq4K/gN+2QvQHfKz8yVIEKdQuDHk7YtCl0R7z/EvOKyInp9QuEdkNEhXWEV9aqJ
	 moBMfguO53JjQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:20 +0200
Subject: [PATCH v3 09/11] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-9-d80f7b871bb4@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2272; i=treding@nvidia.com;
 h=from:subject:message-id; bh=cpp7dV4YiiVdoQORWHY6AiIPwXT+RsNUal3/UnQC4ww=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuGwnRPRpVQVZ6UBvUUz+OLr+gka5kyQDAfR
 yg2FhOV/9GJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hgAKCRDdI6zXfz6z
 oS8cD/wKULL/QmET3qER/1nkL84RxQ97TT70Q/7Es3JacxJ2AE+h+MiTYPq79T3eRoAtxp6I2Ut
 g1+1ebxljtq7bwKstf7510aaJp1dUtjfXMpXuPWJnJLiH4rJZphJTXDyfEGiYka9hzjzSe4LmJF
 CUjUx5PhEWCwyJ9hCeCmV5kfzc31QUrgg5uWDf2+v7SvcAMIFdVOm1qx8PIpBReJGIlO6UGWzMH
 NUi9fQrZ20gVRL6eTCVurLZMn8Hf7Ktjnjkgp6Zx3xjzn5CgUCfB/TkKnY5aSzenXCwaSSY6aAy
 pHPH4ZMutpi/rRlvZ/IgD45h9IgVweFuZ8NIP0/Bc5aUAn3boChMy+bVjkYM34LB7r2Xe6dQoR9
 KbnCHJwSBl8avlapXDnu0NIVzDFlHwoCQHOmoFaHhdgkjCCG5gxtjoND9875T/AHg2AwtK9Dm7w
 AyOvCqUrKsBXwXK/nGqc4aooupRFGMd19I/xb+Hj+HBEY1vdbHFv9pWjpJqQA/M3ctUwHJ1gvdK
 CSVhfWxXoODKmWUv1ATW/Wd5aKhpf8emoK4EZqUrJwbSc3y0jzoeo4I5K7ui3gbrTqmkRj+UHKz
 YuEC4Ts9vSuskwF3ixXjRl2mn2lcGh/4IiIAEL9DTE4w7QtbF/X/cgyZyytPI7/rMWfeXy4bR2u
 6tRViqbLmT1FpLg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 11946140019
X-Stat-Signature: mzjuwknh163gu5pprtsyryutddwadqc6
X-HE-Tag: 1782922147-944677
X-HE-Meta: U2FsdGVkX19ebiFB0WC92rDErwvkCuEPa4bems60DshYZxJRyfYvIg/h5vQNy0dbv3ZZ9DmU+n42Bs3CdL1W/zhl5WdLSCSPAzYWpy/lf/dXBpNrwXepBuhXX8yOzWbIh5pzzNf9seICbsAxsu7oBZMmD1wNlIeToGP7IJY0/ggeQNR1O95RWKmFEkZLWOjtUcE61bDY0r7o04QH81p1dVUDity9wLLv6aMAoazuHQ1SHn8OSYkUdn7XTOb5PQag9kkG3erWR7HhODcHzpvdk0rTbJMe4v1qOuNBa6Xbt4prwlUfuD3KJ9V/y/HeasXwUrfOj5bvp5183Og/PALRJPbKJtuEa2Orh/reQn+QSLldfFDjQRpy7gn871a2zVX4V3e7skyEiiYJ0N/BxreiHxgcmcqWt0Xjub2sElJD4zI63BCUfyy1n96CCQ9c5/5K4b6FGUxzt4xjYJQytANov+5bWYw5M5M0ZKGySik+G21vQ+7ve39omkGHQsEtv5GosXLek40waRtp5TtP+KU+Vlpg+cbc5hq9DdaJ8s6IVfLPL/vzWoPvxcrcKrvRpz2XCZxgyrOyWr1Q1LkvhLLMdCsQcNwKHqXBBRoOluTXkokdhQodjFOZjW4fQXgihc9mXmYAa4zF0NmvikP5+7/NcNcMME0fqoz+OYtzzwWjecS8VnKSRXhOAQroDtrzM0i0ST62wG/M+79qelxlNhMqtiTyPtls7X3XgkrHSMe/c4YLvGZsDumVH4HZVyDvFbD6DVTzRf5CFNN9JMB8yY3XspH0NvgJ1eVfdjOYFvLhJgIlr9oHqbsxkkjDSe1Av1YS6xcO9f1LseEg2HfsLqwnBozJGN5L9rTOH/kDiKIj/Bdvn6wV8KeHvw94mmzgMan9+GqNa4UMm0yAvmV4SFVv59048BEW3vNI7rjootP8wgbyHRa/abO18KPwsV1W+7BTpaez7cwDtZ0AMYkcEB7
 GjpFrLnq
 OLGkx+dUozpK7PIzGXlLZ5pF94PBAvpBIWQgvSZSZ2L/w0VZE7YUZUYIme0xOj+vxoALaNmynV2MbqUEqt49dbJSuNBJKCpMDm0bRjUzBDRbDT0uEQs70uBB0PVzSk/0z2WZBSMsk9mJ4GTbevgbOjTibspj19zxi8xFEEMGnFo58K5ZTk8iH5PB+dmhNH5GI3TcCqDOyPzq5DwTO6gL2j5HSxBaDME3O4n1GViPXIkDYbHiwY5XmqqFzQrUhSLuFU81aqzgw/mwEFoUVmTk2wAbHkedWPJJX9Mceqq0ul/LpZfPczXfv5TpHfSJKLLjDJeR2fZv13BV8vHH9Ph1z1TymiQoh4FW5zBYi
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
index 8e0c51e496e2..52ff11873580 100644
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


