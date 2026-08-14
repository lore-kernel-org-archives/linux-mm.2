Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48EC1C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:30:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445D16B06DD; Fri, 14 Aug 2026 11:29:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E166B06E0; Fri, 14 Aug 2026 11:29:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339766B06DD; Fri, 14 Aug 2026 11:29:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1B9D6B06DD
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:29:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 48BDE1A010B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:57 +0000 (UTC)
X-FDA: 85100260434.18.AC5C619
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 824CE40008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NcMsbplE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Jc01ta292IyzRQJ7S0gkfePZTtvrNXCh0bWGk/zJv0=;
	b=YnQb1Jn77/tejLq6qY5SVP+IinF0Qx6rB1p7nnPD1AraBAO1EpUFbj0iBmogAXPP7zf+sj
	1d9MkhqBPJwD4aZbRuvNnedrpnLZnGTyk8Nsl9IkxU949MeNRbD2aox2KFw1ULIsat1+Gh
	vla0WhSn3Ro3MoNr7AFsAsBMuW3jaAE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NcMsbplE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721395;
	b=Leu1zm8KV5rgeBkWGz5oBJB+0+sczuehsouvnnXQ2xhpIsfgnmVoMnOHBcx5bLkj0VLtjS
	JeSM1fHNcDcw2F1J/YBgdZR5C0jdqXgDiRw5HaNT6+fcgn0XepdjdBLqNGnV4XFqjyzFv6
	ZjFH3r5RoMw4R035Jugop1pI/GvR1Wo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1F6F6601E0;
	Fri, 14 Aug 2026 15:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190991F00A3D;
	Fri, 14 Aug 2026 15:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721394;
	bh=3Jc01ta292IyzRQJ7S0gkfePZTtvrNXCh0bWGk/zJv0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NcMsbplEtDdQm6kh/SGOLa0/RJQNEWfL/2BfcjnGXSUNBYosAjU0UjnY9lqbWaoJ9
	 Nie8FAah4yhGJ55myjaV0rn9kAUDHZlcnnA+8c5Ga8uNtWAPWYt/+gaPFZvtFNJmg+
	 s2FlVihIsR7NcKRwbaa2oktybdQRP+j1QOkgPiNqzBx8fXZA15gdbWHnJ9QBSTzLLX
	 2CV2SXUi9O995eCjstVnkSWEbxVghqpUOFlq58CjSA4RzlNCqWradz6dV6lzuwzLE3
	 D7Q+CFhySsr0Na19Z8tc/Rb4CPGtlNnqorlvDV4iVdM7N22Ei7ksrkpadYIYCCUZa8
	 TP7eYcE7F23Ag==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:16 +0200
Subject: [PATCH v5 08/10] arm64: tegra: Add VPR placeholder node on
 Tegra234
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-8-71832b5d0246@nvidia.com>
References: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
In-Reply-To: <20260814-tegra-vpr-v5-0-71832b5d0246@nvidia.com>
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
 h=from:subject:message-id; bh=tluD4wsCTEuKp0Tp27V1iO02LeJ7xPXs3NTBGtUc+lo=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRYDbNpqpdmgbeamv4SdSlpqySEBNbb9exns
 Tov5wvAxDaJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80WAAKCRDdI6zXfz6z
 oWaID/0QBemia5v7XUxUcYFPeszOyYomA7N68168MqyiTj7lE0A+c9LcFnN5wTRYmZjQ3lubFAT
 F2HaLwt+kPeF/rzJ8ZkcCgRjp4ZJ+jhGFu+IkvpzRy/idEkblTNtJiSVFRxmNjv1VfbeFSHaiG7
 Bp8voh2mGvgzmRKPeSasjQeBZkcuhByhnkjeirZ2Z7bryipcJKMcGc2LykMBFp1I/LhMQugP8mp
 MmUexP9jDjXpoSc6lpg8hC0MyZ95YAwh8cv/dztaihtWMEP8i+zfe14J2jhGA+DuxxNStXOVSSd
 okTJkF3HU2vgfHQ9ffWlLUpBWuLHdV5++fA9pLVApYRlfM2p4eN9F0RuOvbJMTri5w2OhlwoFs9
 yBn8zjkPEdjbeEr3dJr8GNBsdBd/2E+646SwOz2H/FymQfdcO2KZ1fCNqoY6zcxJm29FO989zw9
 WsnYje5s5jmPWh4vTbHXKbsGhg6Nrij/0aIpuQfrKEWH4HgVECEezUGJvGV7GGfcWb8l/w8oKjm
 FFczQ7Y6jWGGk3R68xW7D//Bq15sv4ee0TV7zgIiywdgvrhMK5PkD7+htoOPyb/7O2Ch09ZZWOu
 Pfs9PIILCsG6PBXjil+eqWs1zcmONmwP+iRo7XXXIl3db+vvHbSZcivk5Oi67d6NvBIouAaEx0o
 WkPiMhhZYK2UFTw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: dp1kwjsy9q9bkwtkzfymwu8hu4dwi5eb
X-Rspamd-Queue-Id: 824CE40008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786721395-887822
X-HE-Meta: U2FsdGVkX185jxulWDAHkeQt7uPsxeN7e5xGLc6j7hu8qKJQYy4lL4L7MNoE8Q0ONqR+Mj5j2FKxCW7iXH3X4nVgUZqwgRElFnHfK5BSBfcmFvkvRgJYkb/8NGlK9lBVg+TFapYkwd8UZUE6Mb5ze8JNxIwjjNS0wAYxsVkoLg3nYSEp5UPdWyFJbGOMzX2OLbRruXdILutIRPB4/sS3ecGVfGZnpt0Q/AvE8R7TbaouTReS8Ak9P+hy6D0bAcXcQEri4w99bIjdh28cStZGu1vPpm61OhFaAzSv1Le6kNWhQ3Fxz5dHlFiEh/pNzpT5aVxH4Hq6EZO8CLA6jhwIpyJ40SuLfYSKbCI/iL+p6tMVgAxJC2zkjosqLLsVv07qqc6byYyg8xZuZuQlrKwUJMJ8vwEQbOBRssDykgB+i+Dw/ghBVIZkvqHnGKPlGGvXKDGgl/7i8+yxSrNVP49w5tJ7bf84YcJGH+0JFADGWJjXWAqzn73Dl376X0Ct1fx76Fq5uWtmVjvtXd6KXs73KUIVcYP+OcLy/R4lInbrWeL47zFv+L+EDabgkMuP12xbQuMQXApl52nyZVpbBFaIfkxcDlb+KOloqnnEHfT/Xhhoo3imGywbx1zPc5fAEOyJa7ypEIDXImBHcO6FfjNF65070BiVSgeCFTfjQDrzMv2f6cxzifZg8C4XpNPfMhYBc8DOsvo28jVCki+ckCQjHGDtNCAULChcktYWXrcFFLsCIKf2MEMgW4XoOCKMAq4jrleCo5hbavmW4nLeaA/uPCwUEQXdxc9rWX3ZI6NhSrUN+7wy8YPOzHy+sB4LgJw5Vdbcdxty7IOtJn/ITskV51GS+jicCH9/4KrxPGDyaAOZm8s/jw+e42mb1i15ggY35qdoWDEEWinA7kF5sAm7sUXadDJUOEpcO7Y49jTre3vYtmo7XimVtzijAfbctzA1JM9WOEZRl0A3cEco1pQ
 dU3wD5WF
 3kNLr13Af491SzlzC+xcHyyeU49yeZ6CJCZSysbSTR+VQRjIFDmL08VNHTCf/rAcrGHOef3KHPJPQ8JqCU8QjHPmFkHlQ/47COZPS4ZnDvskpVAVcRN8G1wqToY0Cb6fnW+HbDKYNSLo7sStVV1lDhVxYTYXD52LZ78c8lezbUn4gPhURtaZwhILCHJlbZHUQ4Yn9EBfWpgXd0nfIV4I40Z+oksbSJX6de+TiKvauBGPa8UyvbgYCm4hQ5LPkiYy1pErbshdQJn89lycZ67PMwDabz6Tp7rP2v4pJOPKT34PCfxoVjb4AjWpRK8ahdfNwnkbpuPbixvPbNRUDaLBinWtUC+absR1BMyVgSeCbw3UxvxVwGX1n6yGRZUNV3YoLBU3Oyy+BG/02m2JKfgN71ZyXed6I5oJvQGXmb7s0uGIt6W01+xiJF4xxdctsj5PxeGlHeFp8rhodpBFYQaRZrt9I8g==
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
2.55.0


