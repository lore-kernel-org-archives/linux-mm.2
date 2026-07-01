Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32406C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31BF56B00B8; Wed,  1 Jul 2026 12:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F26B6B00B9; Wed,  1 Jul 2026 12:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E1046B00BA; Wed,  1 Jul 2026 12:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D50216B00B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:09:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D8521C7027
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:15 +0000 (UTC)
X-FDA: 84940692270.17.0B0E618
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 882C4C0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:09:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRqxn+xA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922153;
	b=f+C2r2LR7WgM/aKaotU2tjxtv+G3uGpYbzyekpPIBc/TjBoUoUWa6v9ignTCFtkFZomTHp
	Z6KdLYNBkNYfgmPN7VC1znoTKEcr+Y51OBqLC/nSP5aD9tdC3JSTw76gL9Ja1PAVL78S/S
	pZhCRU9ZT8vMgtUEXap+4HsD70DQlPg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZ1ua092sFPJbERnBLwgyQPXHI/AIXZthh7+PsUJfz0=;
	b=f1iq4KYMwuwkKBlAm0CFg7YZoZSP8VzATdyrVdmD6w/Q2ROns2mHn+TOO2XezuYSsiBRRQ
	aY/2n/T0IdYeXNnr/q5cd22ZBIGOkWhF8bCQZ1ckTAF+/jNXCmhlGuLREpzWw/brjY4sB4
	N8iD9E87gyUPdvzS062vjWdttstIXNs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MRqxn+xA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15F4A601DF;
	Wed,  1 Jul 2026 16:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 135A41F00A3E;
	Wed,  1 Jul 2026 16:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922152;
	bh=NZ1ua092sFPJbERnBLwgyQPXHI/AIXZthh7+PsUJfz0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MRqxn+xAkXOJJLLhdGBoaVL0dEVa/CDsnQMn9qp9ZF1Oujk8XW+LUtpt68psqUmu4
	 oZWoT7wSka6UJCE6aAuTR36fM9bmBCjZECh3RENSfvxEpKTaYpfZ66aJp7RGiQh7pS
	 o6b8e7u0SpgKxF6jINcLov7ZVqNcrDrycMit6hs33UvOKY2ILCzwpQhm74Fw5YGNNf
	 VUwKeQeL2qtN7xY11U8I3dePTm6oxTceB5XCBD6bLgiKYHyvBCo0hVdGXzyYVFLKyH
	 f8voI1pinD/fjU4aEO5A6KaxA9PeQKuCDylB75Nn0J0dmTxTRql8V2lPTv+7B9ACEV
	 cojxbCS4VzmrA==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:22 +0200
Subject: [PATCH v3 11/11] arm64: tegra: Add VPR placeholder node on
 Tegra264
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-11-d80f7b871bb4@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2208; i=treding@nvidia.com;
 h=from:subject:message-id; bh=UDPMoi7c/r2YYc7KMYasNvRmmrFnb+/8WQEYBHJoT9o=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuGsc2UqwsB18Ps0JNikBH538NWGoIW6yQyT
 jBWP077JiKJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hgAKCRDdI6zXfz6z
 oWYQD/4zNJzhF0ziH/cfp++YEWF2QzkCBtNhxlib5GS0I1XV2iIewgNdcCwyxmX5iJepLKIfpTF
 MI8uKdvbIH/rmjtfgZhLdieCQdJqxJjnUWpEPpHNDezJRFN5KAGFBa0JyDU8TwgpPWetpMpVjoi
 JtOdfDqoTulUptfcs2SnD464Cc7ULfNYO9pqD/zJ1inq5qNZeBpC/WV29fMPwNgyTk33TcYZgTh
 JQMlIV9KsjBq9UGt3g5as6AyxLkK4n870/MrIjOTAlIlG0s3dMb3TuRSRseoAZzMatNsLKoBfDv
 3LqE29PjChBqoRhBF+74YxKk1M6vUz1Xk6hntBgcKMnATrZrXQTm9RCgqSx+E0sFxBbO5wkwl4A
 HQWbmwu0/nCUYjnSHWE7QqKWaoDnl7RvUNNkfxKA/JMlXG6qtNpGC0NsOfOBKauSfg/4MVcKd7v
 x3kBNBh+1yJMVNl5dD9HFy3hOs7EDlz5B8wD3o7taIbseFcbfLfuneSlHkB9Ar8bWAqnMQDdNZf
 qvh5iEwypLCoSYFLV96TaHcV80M8qqmGoU7nPSjhbaGLuqtx2VOyK4Lg68R3+G3zfF7XOHOzpGM
 nLfJbw6vtU4JZFhzyD3NXUzQ/3xSUuHcS7uGJf6i4/ph51+s+Zh4Ik7+mTAn6T48fzuMV/Vq6km
 8q9G/imB3ixEDzQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 882C4C0005
X-Stat-Signature: naiqdgbxf7wc9d36ujqe34uhcbysup56
X-HE-Tag: 1782922153-198102
X-HE-Meta: U2FsdGVkX19RXkzPKfCFTy4wUPa12cufuDeH/h/BUur5THpIk5tGPAAqkLdWCWLZrSuifHhdH4NHS/az7EA53qqtd79LQYvr6IynJ1hsVz5SyBDdFbP2otIATiCya9C2AOveI7FKmuF9aNe/c0kl+HhykN4kaHIdcWbDQ3UPCGFP2sIsSSZFCaHzE8Tn6F4bmU62yD7MS+WVEDZAiz2BxmVNjKt33ZQr1HtzFygvUT7Qh3oJKAx3bvjfiLaZTv6Wf5yHqzKyyUmTCRi1f/9q6T2zFv/lrt5Y3Zae1iyOUTatPDmAghXrr7T1oAp4T0kMkRKZh+86XvdWmq6QFBwW8Qz4MCh+sKyyZXWwtxMATbzCgQXedoHcg2y0M/bW5EnBXYjuo66noyzDMZh2jjQDxxolLgoa4CuhdsHYQC6c2SRJAfZnE+w5XVexJCmZgLcPSZkH0bGLG+Q/IkSjqtS4tHXZXaXXfON9scoR6d1B8OQtfVIFWPg5pxY9h4kYgeJGcH7OqCyDUoybVqNSqEowIjqbdJfs8KvjQqvfOza1NsmZPRb/KrOBLj9k0/c2sSvw5+0BG2TlFg/4v7clTya0IIVJ/u+18teO1iumcpNgPLZFP8+G9amqvKPyzA3nKt76tmp7NYjU+L0nmgSYn7Ep0wjpySKo9UZp7enUdIYzqFiCvs5PauNsaEiNMPHYI6geZdwSQE2hmwNhkwRCvAcqS1p/JCRMAKIcoYjHtO6xFXlP0J6eEI/Fr1OrxCdHLKMWmX3uq6c0J0aDCaltzOJy0czjz1ZkJg8z+hlUweAshjGEbo6S6hWab9ymS47rA9EFDnb01r7kDNWaUAYpuC7t7quKd55Nu1msirGA9kEfCg3zgQ1q9j59KDd/owQTdOMu9EqQziVAAoLAUZbSzaJnVoRnmKFFI0cpbXIos0yQz8RoqEPPq4eWwPr8QxINLDG0jv5j0NhktFJ2JDWsRsl
 gCs8z+/b
 yz38Ek2y9oAUiEEtUIsQ0+Wzqz1U4R0tnO6Y3e9Apw1Ie29HJl56q2xXPd7RaPvlPToU8NCfMq652ZwadxUxpSXXUQFn6gimCKijOPkCAsZ09mSN2kf5/ZC7iXh6WjWrOV3k5kPQsK2401ydgbdchl35LGUIfSQNCJofMigNRwRtEweRMx9vYRmIHBoyP3Mz1NcljdnACrGuZaAJpTRsQq4YiEAobGNdBnTFYm2tFAz2xY9MgVRwMRHELMhpAKQYVQYoscQctZqTwfXCzNAiogVyct638ALNlZ8U69k4kZ5rkKTZQUWV974pfX/gRTJz3pSt75AsckzZc8npVT73/OV7f6+bDx12H2NtG
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
 arch/arm64/boot/dts/nvidia/tegra264.dtsi | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra264.dtsi b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
index 4c701abd25a8..85a18d99d643 100644
--- a/arch/arm64/boot/dts/nvidia/tegra264.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
@@ -24,6 +24,39 @@ shmem_bpmp: shmem@86070000 {
 			reg = <0x0 0x86070000 0x0 0x2000>;
 			no-map;
 		};
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
 	};
 
 	/* SYSTEM MMIO */

-- 
2.54.0


