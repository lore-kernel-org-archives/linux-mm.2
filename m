Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1490BC5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B722E6B06E2; Fri, 14 Aug 2026 11:30:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4B3B6B06E3; Fri, 14 Aug 2026 11:30:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67C46B06E4; Fri, 14 Aug 2026 11:30:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1466B06E2
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:30:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D911440192
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:30:02 +0000 (UTC)
X-FDA: 85100260644.05.D151717
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 21D0018000C
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:30:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyLKd7df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uaLT8Pt+Su2uzISlW009doIM0VJ15n6/6fL5974J+dg=;
	b=v+slNykMrG0+vDafYn9F1HI61HErpjRfkMu/gOe99/YS3SL78lJNSYo+Ayvbijx1HpYcWs
	BNdjclcY2n9unnkkEEEdwC1ze43C2SyBBn0F1MNW2t6apxydGX7YOvFMI+s2djVT3Qyazu
	E1LZ+igNzdavSU/yDYfi2tUH4DmhHKY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dyLKd7df;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721401;
	b=i80+ULHnzWA9I0yW+M1wyZ8vvvNYev4pqUiJh+5OaYHpZxGoKtj/D7ZM7ktwGUTaQATCAU
	uKdza5lbsuwJ/Wy//zK/JWXZYMKIaTrGfwOGoc+dIQkUUe7Lu8viK2FBQMrhsteahZl75o
	b4lTXu16yho1Rk7jArm2YzX97rh1MCM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC40460A73;
	Fri, 14 Aug 2026 15:30:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70961F000E9;
	Fri, 14 Aug 2026 15:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721400;
	bh=uaLT8Pt+Su2uzISlW009doIM0VJ15n6/6fL5974J+dg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dyLKd7dfiBNnwmTsFUCJeuYgeUh8Ew4Yy3vfvAWnGGsbpXhsuQXVd8XQ9w2HaM6Zu
	 QgBFaTPJEssOx024yYFYiy0ikk8y+yf6M2aqF58IXU4qyJA374I2BXJ7LsBV6pl8DT
	 5Xj+P2HKB2Pvpmjt6zEYOI340apfB0nAFJ7XkX9fme6Uj6Sja0Sl4FcAYaZnu8TMkU
	 guyQVkgOZfVNqwCLYiPXu0ohVQDFkAnBDc0rCPHMOOb+6qmvJLpRHkLxEJw7lW+vos
	 Ntys2s5CLDmS3/R8vkRNfeJVwr6Ss0RjKsCRj38cipYc0tgAJxcOXlAUDB4Z8VRD4s
	 iGqg8t0wrurrw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:18 +0200
Subject: [PATCH v5 10/10] arm64: tegra: Add VPR placeholder node on
 Tegra264
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-10-71832b5d0246@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2208; i=treding@nvidia.com;
 h=from:subject:message-id; bh=db5pktqTEHmL7nm7eEWg8RTfTXMm0eSnWFgz4562xI4=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRZRCHM4P+QZFcsZdjlqbbApnEWVTk6Wm7E+
 KnIdEu0AYmJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80WQAKCRDdI6zXfz6z
 oSXAD/9osIn6vKwbtFrpb26y/g3b9z+UjI1W3E3npab2OW3Xl4zfKOoluxB7F9krSl7aDrrKhw9
 uI7kMIHw32NFU50O6kjYGE1Zi6s89gv4UeeYqNiIPtYqyU3dVS6/wt2AN2eoQgD6y5y7lgsX+a2
 b+TaC+idL5S+NJxjlha1/Ax3mH0kmL/NYjMVT2F+OWOfJDFbmYtwCkXa/bnlAJaExbFvVow52w3
 lKV4KUg+Q1zuwcv9wWrrkcEOElranQ1b5jO/E27+zvhIle3MhK/RkJOKCiRlFR7g1/oAIVHCYVx
 vLgtY9ifFDRxVuTQrWHpCJcq9q+YtSAZUiM4WjJutFgVF0fejgX7YDv23ar7NkoI7I+eiHqKv7r
 KznaE0HyuGIGpGExgj3QeEEMVqz7I4xibixSV+MPk2EVlm16ZcqShTUu9ZaIadCxfAS1rcRqSz1
 Cz/etrRh+A2EV+V+tgDcNBE5kmN6YvTZE826o1yVVtSAVlrf7S4s/rOnwfRHTxTH7Ek3OWUkdpR
 kuXJlxiZ+xIKx4VQ9y03bVyg+FeLRphkOO952z6VQq5Gk13e02mBOUG2liVGPh70aWOmkoXVhtN
 b268m+4V1J8PieinrHxibQ6o225G8PrDeNOSGlbNKkQf6afUzpcG51yPU2vS4//Wl7rnKmgE8qO
 nrj9H5tdo/9uipA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 21D0018000C
X-Stat-Signature: hxjaxkknobqtf5sjzcya9scdoe6pm9o5
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786721400-748402
X-HE-Meta: U2FsdGVkX193Bu99LMx2MW3x4hjOpRCzxO2NIPqZ4Ilwgf+mVwgb0y3oxz0/cReA+84TW+doB0ohtnHnZ4MlqC2DlKCeuv87pVtYgrrtAVldEK1mdULOcCJ7/EXD/S6kJfiWhtBo8JOegj7DuYmOPpwmNj/VYPBLwsyH+KhE1MtfTx/by1WhIAOmunpV4aR0aq3iQ2UBSe3xnlxCEgXv9gH03dOrBogovoMhbQalBk95b1RWOjmuPAY+5ENBrlMWMSN5EkaE419zbortld2bQ6Kbas2dD2bGIcQIz3pI5P53WaXL89MMJlLccpm/sTQ9GcTEZz+ftF0tI0WHp/ZTiga9ks2t4hIuFzb9K67hdsh3GOnBTfaRQGCKzQK4jJhILr51XnOjoTZ9Snl8pZtoVQYSP4DP4V6fLmjgoAtTijmZLMpkw4iypFBPoBhahYFAxI1i0XV9ez5gSibGzwzG60M5pFssM8eslVZM6RJrBdDQ0UpF7ukwByACevsm54HW4l2HgqILFHnDv1cGVsLuVFzjeK3OqC7Lzcihev7sNpip4Gv838SW1L9LPSQrZxS9sSRsi/XmJKPr/6uaQLssCAAEzrqxvoTKJ2g+oLJqFxGVmH8IiYamkFRjXyol+hK/5vV2hMrVl+J1oHtpungTcl7UArDcEr/T//LynT6BXy80xcyxZHOlRB1ef6YbilE7Afg3vlPAxQ9K/nFbIDxd4YOZUxfpyXwDOrQZGaE5ncIMq3m+qatS2wQ57dFfNiGKl13ye56dyyeNI+0ysaY87EUVTuuKghRp/6cLgHdN3XaQOOaNLyzfzRVKKlXpbvuk20GUdP1zt+GhFRYkdJ4rH4s8/T3ho4sM/Q/66ciHNJnTnyRmkjkutRlZfvv7l7bSKLi+B6i6qFkof1IyWsFaD/mO/6aMKPosHCN4I/9oGps7IhuVaFi/7flYK4Gy/zlw0i4U7Y1bvWgBxrCWO42
 lMMQr8tc
 hYGJsgbr5BICr3P8hE9CRCMNZbT2M3Fr9XbsB+xxB2CTQW2QtKugJonES/5FLtEnvnlSktduXF+77//JEnrAfddQgaWrTYgosPTblAse5pk5dcCNm8bGFCF24BSWwfKH0dB+6NQ3WmdlyA4li8ffcdm1as8vzxp6nXLySEoq73uCN9PYkPZ7ATyQbvnw76juPhc5W0Agg/dSF5fWiB+sA3sSloDt9kYIi/vGPIOagKDS7yJPac3ySE01ItooPZMMezXzkis22x2lNuo6zYU1M3ozhDpEsII+Sj8sYCEkXezUF5cfsmr4sd17Q1K2snZEVIYI9KSj8N0muBjE9xFQQzZ49Rcy/teMDpmzPtgBYTjSl+3MAmRNVDMGc6Mhu3XDNcuPLINESeNCEauQE3yl2aklK7ZWZd5lo6HdQRMlC6zt9ixlne0mD+KaHGc9B+asHc2UrnzRpkdlr1OxQESKmzpkG7w==
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
index 31bd29df8e46..b3a8ea64aa37 100644
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
2.55.0


