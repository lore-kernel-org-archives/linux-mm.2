Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2503D3EE8E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 125276B0290; Thu, 22 Jan 2026 11:10:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C31B6B0292; Thu, 22 Jan 2026 11:10:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E474D6B0293; Thu, 22 Jan 2026 11:10:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C84E96B0290
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:38 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B557160442
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:38 +0000 (UTC)
X-FDA: 84360087756.15.CAA1795
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id EB6EA2000D
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbN8XEHw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098237; a=rsa-sha256;
	cv=none;
	b=W7otbWafIRqPk3XyVOxgL58+yYvX4LVSVHrrEkEOeOTfqd8ThMueSGH8aPtbtNjrylhyV0
	yxvNwK+bFWVSD1TLN20NxMOn/ReiqHsDQNkTBeAn5khsKU/AfeFcdnqI4X7Uh7afB9dC87
	+7LC7ckyE+gTEE8ihpF2n2QSyLODVw4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VbN8XEHw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KKX97alVc3uCMGOeaUO6TRl+cQzdvqebk81QMWlUHYQ=;
	b=qHivuyECnK+aHFKvcXEhQaC6JWIM2aEbn/H0n7+IB7qf18iFv7PJ3RkNrguld7526maihC
	5pjxjJSxQWymfbt22/MUVnRO6sninAUIxnVg13RobGZbgX6UM/9GBX5fMAqq9nypjxmXXM
	ilUovXVRGxwVlSJiHzc6SLkKQzIn5nY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C5F74439C;
	Thu, 22 Jan 2026 16:10:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6A8C116C6;
	Thu, 22 Jan 2026 16:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098236;
	bh=m7OZFi6NVZYBpVcc9Brq/11LIbbM8dBnjfFzHERIm1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbN8XEHw72VeMDyuWqKNlM0ZYRmW15E1SiTonTzrWsxolsQ4dOtRG3H0Q3oacARgr
	 bFDLpvE2ygRw/Mc8R87hyuIfTIxn1xu+KLATFEaXyv/4z55VOSKFNmREjuqTs/Dahk
	 dms0BlkPbL7CRlYKFiXkoU+2PR/GQZAeGtTSc1buSKNKtiqa9ZLm0maslOdswqYrOD
	 LWMOZiXZUHJO6QgvKrYMXChxOf3/BcNGcRUs1mpia0ZOOhyeg2g9FEUC4mL2X6HSeh
	 SlkxzQvkwdEx0CMkjHOLPZZq7ivthjMo060+NWqljOZURFE4k2TgKhQFGXTFzt6kCN
	 KnKc6oBQtrc1g==
From: Thierry Reding <thierry.reding@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Sumit Semwal <sumit.semwal@linaro.org>
Cc: Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T . J . Mercier" <tjmercier@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Sumit Garg <sumit.garg@kernel.org>,
	dri-devel@lists.freedesktop.org,
	devicetree@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org
Subject: [PATCH v2 07/10] arm64: tegra: Add VPR placeholder node on Tegra234
Date: Thu, 22 Jan 2026 17:10:06 +0100
Message-ID: <20260122161009.3865888-8-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EB6EA2000D
X-Stat-Signature: d71wngtrojn7ynoccp7y9dhoqx4s33nj
X-HE-Tag: 1769098236-243816
X-HE-Meta: U2FsdGVkX19W7ju06boIJ5+FfDuYhfZdgkNDqS5wbOiPqUhDN3f9S0JJxtuZe10mH+xVhkt2vbDBXaLySCGmZqZCFmK4O6NUuhlEdQPB00RRGJNjD06LOyM40wuFcz18z1WF8f2BUE34Fr3GxvmAQrcUZJksSwY1sk8SUMm6tigLHK9KgFhdoKExvOqVf1Ltdsz/Sv7Ek+FlQ3eKyr5NwokVAmVO8JRz9jepDoLQ5PbS3uoH3Kkw0ih4u2OI6jtMZN1CYTOVhGGL/AWm+8rw1A/ictyDxBvaacf8zIar7cjROp4sznb0kOYTmzTebH6h4SKUf2RWtS1W7cR3y4QCjZqGc8/CXGRLOISVsy96quhyWNeIWINREA8X7Co1c9pnz1LcZc+m4qJl1vdyKckEYU2uQ8zuVMhcinVJEZdAuIyiGXWOoNXJGnX5LAEdXw8OXhnm2o2ULwLH7S3f/JvcllGaH84tsH4UR4LwfogaulV0l/QlW5HJ4KcSZvY7Zcg0cjKNfXhAGqa2glq9trd0N5qEKXTaru03/6//qXyz0z6jLOZhbQ1vqONP/FxHD7GgF7lGUpi5eqw4azreg74CwE3sEnEmjaUT68YO/cg8t5y1QCGPC6qcpoSTRVzuftOUdAKQtS+0gCphQxpGqkugSL7HdYiXPq9pWdpHbmWUSo4N3w8HZZWjhfJu2ldFxMU4F1WqKt+ddkUD3clbP3jXRAnZXppcXf5jWJ8U3Nwq5HtyUiUymi3++nyXm/m7pfbiSG58uGdmd75llsZi/jfxiWpk3mDXyEZ2QOHPtcsRzY/1VjAh2qEf0rjQJGYJdItj5FTG7bc2IvyZyXN5qyb9oBrjsE4kc6PjVlVCN5NieGUWwbKSvviP0i5gvCixaNre2PaYf+dQXMt9S6QePPIRccr8D1wI8n0mAd2cp7big2PQSXRR9pYAlYiS1zTPT2mHuaUnrkqYT/rD7shDfaZ
 GrMOUrAn
 LMeGn/MXwQFq2gxpyTn8PdW83cU2fMBFGc6VgmCtLmv6I1R9NHhM59TurnhXAYKRvp8+csJnFDTQ831DqNJ5+wIYVIuIXuBobfZQbqOCiwIWjXJCV3c1sTpcm+S97aXULa90wUkdlWjL+rVZ04tY2+m+uQkSNuURKX0wy+sjzX7f/8c1HzrxesahULy4GXtLOPrV+bidepsUV1iJ/Vao6t3u2oxtW19ib+PS1/STe38cNTBC+6AyvkW/6J1PFQxI/QcICAsOxADXpedK05SigGGGHC5f1Jd/heZPRse/KYixhnDe1rfWmL+7VXHnDKht1tzIYpZbK6tAMaiLNjgq27P+isQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 34 ++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 850c473235e3..62a5dfde9e38 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -29,6 +29,40 @@ aliases {
 		i2c8 = &dp_aux_ch3_i2c;
 	};
 
+	reserved-memory {
+		#address-cells = <2>;
+		#size-cells = <2>;
+		ranges;
+
+		vpr: video-protection-region@0 {
+			compatible = "nvidia,tegra-video-protection-region";
+			status = "disabled";
+			no-map;
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
+			 * The firmware is responsible for removing the
+			 * unused set of properties.
+			 */
+
+			/* fixed VPR */
+			reg = <0x0 0x0 0x0 0x0>;
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
2.52.0


