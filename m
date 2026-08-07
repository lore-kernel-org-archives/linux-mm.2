Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBDB7C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90C86B00A1; Fri,  7 Aug 2026 11:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C69806B00A2; Fri,  7 Aug 2026 11:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09F46B00A3; Fri,  7 Aug 2026 11:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AEC86B00A1
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:55:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFC62A2014
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:20 +0000 (UTC)
X-FDA: 85074922800.17.F6F7A80
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4121820005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:19 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAc7ypy7;
	spf=pass (imf31.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6i7xakpX8Dwar6IEApYmKxiKoL21IvPSWS9A/gXEcg=;
	b=FO366ebKlmtqTKbEZckRsyLEhtjr3NSRL+AjxOJ8R8DTZfF8Hy5Svq9Eft98OniueFbySB
	4MnmF/B5MJVc8s0aiLjdpdWJsNwQWeZr1unrWUfyCPJg3nmRuD9FB/phegyyOFWk1CyNhW
	kUg7uw4ye22WbT9pq75ViU/5X9cjDlc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118119;
	b=m8D9fcLfQeCLnaAtihd0mAK+NIOaPPgVzH/QWCUd9261i29Qv2aKQ0qQpXDUc8Dr0igSbw
	Lf3SOseahAgkb+zAYMMSUPNWE6ts3N5A1eCcvtSsU1B0GgyaPKo490wkGRfuTVJGdWxL7p
	iA/hc/VZiH12kIX5xHFT7mcxS9x73T0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TAc7ypy7;
	spf=pass (imf31.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E06D56187B;
	Fri,  7 Aug 2026 15:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6A61F000E9;
	Fri,  7 Aug 2026 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118118;
	bh=G6i7xakpX8Dwar6IEApYmKxiKoL21IvPSWS9A/gXEcg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TAc7ypy7uy91ocURkv9VM/VMtzRJ1CwREqZd4iBKT3JROVnFb01mez/Uwhm9yVGpN
	 i8V2wU7wKgygYtaxlvDmpDVDt8EsK6siaBgcHkEdLsEZCJ46BS9RCX9VLXvvIA1RcK
	 n1KgqLVkt3oOEfgydBBTeg9nwj5NFYzTLxgHLRiAN23R7QitKVmk79fE6dqzbZjFLl
	 o9F8U9BVxffM3anm0tZpSwbFSn1sSS6DS5i0Q8LMa0B2dPWNohm6YTPmAD4jwHQmVM
	 sGhu67Ke+TEBcBvNot6xMeM54JhEnQc4vQAwT4RzvNnNU55F5VLwqfwT5IBeeyEXnE
	 M4YC+WGPOs0Sw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:30 +0200
Subject: [PATCH v4 10/10] arm64: tegra: Add VPR placeholder node on
 Tegra264
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-10-5510d16af89e@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2208; i=treding@nvidia.com;
 h=from:subject:message-id; bh=Amv4qp5tX12gNsVMO5kThf6U9odepWbA842/SdJEBzY=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/HprxUEDkF7YNXkuUx3mD3Wv6Omp42ATta0
 okbOTVnGuSJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xwAKCRDdI6zXfz6z
 oTzpEACqvEWstLuzYaAPJDeIP3lR2uFYwKEtVCmeV8hHU/eQlcRERFHPgVJkx3ul/gh0GpGqpgS
 A0I5u8OVTzyn/6T334TyhKeK7V9sXxOEitUpKQOWg+3mltay5WBq9Y9JlPffkH6k75ysySB7jEH
 vHQwMIYq9rigJMZF//LFimhtQSZGp029lTxH3Hzyffe6qTBHlkPGBl2/FkIs9M4Mo2iHW0570kc
 +gLMw33NycSpoR0dK8KCY9g4ypDp2jneqDNzHSu/lVDqVD7mCWG3Tc/OaD8Uk8RGHegrUdNUuuz
 K51HXP7iMjyJ5eSX3fjprfmzpdgPd+ksntEacG7XFMt7hdrjQxRD9fG/xgsNyS8isxdSHuEDImQ
 3u9yj/6OXOOyFRCPcejWzS1efdAo3+pUe/pAIukmzk5HTo3r/wx41sAGS2qNLwl0ZU5SgkJ2Du2
 Mm32mnY1iKAVKI7xqkIR0osPAlSahomBfoHcAgtqydpeBNz9PbdP147LEvKw3lo4+J/5kY0lTvD
 RCrTASguilnGOPdOLD+axzj624w7lhWauT+/pw7nbDUFMBDrjFDoIVJAnEpfVh3rEt6d1eEc8vo
 AiZrARs8IJVMHXsQgzypvz7SSdoo4KZzNMdZ4+rdCcrLOt4anb2Rr43fki67HI7H9BR+CGDJHPA
 KmaaDqlprG0hTfg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4121820005
X-Stat-Signature: mjoms34b9yfbjgwjadjo5ficnd5hqnmq
X-HE-Tag: 1786118119-813368
X-HE-Meta: U2FsdGVkX19WyZrRaziSzzJTbRiODc9f7tyxwbk1oLndu1mxJy5imbk/zRRiOuaLIsFdKk7GkGAJbsuY/ojl1DT/d5GoyH2faqfyCBVCJD3/fFWNdhFSwhEWID7K9iAnkJHiN9rn4Rh/sUeyEHXRlslbH8OdXLM/Izfeq7j8m5Cw/dTZkJ59jXYDaa6my/dXYdfyf4czPnzv2TnuQ866B54s7XNyPHtUp8f+FIStW/p6vi+PAgn2vvbFKQhyZiJYua/b5bRGvfy9EF45JP19mHC1IWvyA4RWh7abWYFbqX2Qje+zdbVJ50L25EKezcvfXrDRORvSgyCOV7+HET+kDQUkcx0KU/4NF52Fm+ZuDxZA07l6eG8p60B0B0+JuFVaM8tJwXXpPY4k6xr25LFjYNz323LBSiUM95H+3CJjFsDQRMCSMzJ+GIDenR5etuUiIVeXoCCOo5lu3MGBYSwIrHDkpW8N9BdDYZjbLTxtBgpxtA8m0xpOiDmxU8XimFsdbyGVF3jFC+xs0CY/yNeBgN32JH9AYBSCMWJQiVKucyDDM5U3R8vcZJpV9I0i+8sd8993OSZt9CGSTsI1D9bcj4YVW5lYtZiExHm0YIMkaw54RlBA/xMai5xAaJSuy+ryV6rv8HJM+krEva6xKfQVGXhT/WQLRTYPYy5igVrJQbIeKcF4yUu42wP4jndH9d1DuVSRZe0whzeozkDa0QSIX2dBi+PcaVKh4eTD5qvWFEDAhAMd0jcYjtdrEGMqLE/0I2ucUh3CfTLSQ6m1VoI29Xudb3LaEAfAYCBscNOzmHxwoO3/5keNYltt8SUuUjrlyUtUAxCNV1Hz9UD5SqcqqaLkYb8g3SOpGW/SXui6vdo2yyfKd9TmcAeXkXPqiwEXA6VDn0uPJWDBaQovZ+314ha+8NN55sdv7+v4XipT5xKmvHLcIELRadDXOAuC5w9KvnsRTVG0j5hH58T6cte
 l3HG8s1Z
 EDxyEtjv67S1JVpesxhVZKSOmdW/djfctGFmxVod7ckPPjYHEGBWPcRKVFoCzlNvB3E1QESxpcyvdGaz83qbVM/XtoD4lYhTLd/LCECm7u92gbpuz28DPSIrI0lwI+AubUMLcFA+HySDsrXBdPSWwgJaX+EXemyrztMmUAAHyprQRSrAGB4X4BHWEJd9QKfaDtTPCjBKw1uAsinLugkqpt7isijIgH/zMxoeOM5onKlzmT53bsZrxCNbzbg09twJwyaY8+JAy4qc7qdyg42boiPPFOVTs/KTkFIVCCKqNMdpiB3iKjVOmyLNumIpu2lW5y/l1gKhQ9IGmpu0CXe4sffOarg==
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
2.54.0


