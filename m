Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 259A4C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65AA6B00A0; Fri,  7 Aug 2026 11:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3DFF6B00A1; Fri,  7 Aug 2026 11:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D52F56B00A2; Fri,  7 Aug 2026 11:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AFCA16B00A0
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:55:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39ACA12040E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:18 +0000 (UTC)
X-FDA: 85074922716.20.BA84558
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7ED5B120014
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNrolTQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KjPz5KwM66IHcFzGpdKpQJgkWaAK9L9PN1QCj6ca7gQ=;
	b=2izaQ+q7ppcAGx0qSPF65TPBbUWZQPDTwcRExWEYAyONuExk/sVvcTPUEpL1E6tbs6UExi
	BF0RGu1OSoS2mItSfWmh5qIswSUP7FLSoUryYibdFuw0DevvGZsYMDLgajh/yPMjFKv3/T
	IxcQj7QLg2/Lo/kgRP+ngWzo8FtnsIk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cNrolTQm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118116;
	b=Yo708PNGivgWk0mjgRSZ8/q1njOJ914WgxLPot1ZwIUn5RknJXxZaxnjD1pR6d9YAQWfme
	ohuB9+IhT0bn62VRi303AqNbeOnZVGX3hpaqbk0oEDLTSs/hxsF2wrmRcNI/sfve5gE6Iv
	zErJtqol8zvXnpQoCnq0bktSsteQ2PA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BACB61838;
	Fri,  7 Aug 2026 15:55:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C951F00A3E;
	Fri,  7 Aug 2026 15:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118115;
	bh=KjPz5KwM66IHcFzGpdKpQJgkWaAK9L9PN1QCj6ca7gQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cNrolTQm1/q8IL28eVEOolVQMIRFnza+QcUGUVLy7nMEC/yyPDAK32Qh5K0RBKcyz
	 vj4RenmjDyzPA2c+xGTWludAszihdu83+QQ+qni8lzjjHK1shqUSdhz9MgOYs29uRA
	 a8odOqEpPaBmNLa/+N8kAs/t2lWPCQJzT0tichG1kNmR4En6qmz8eCY/uQRZBDDS6F
	 h+Hc9C5VthdRp2SjO4gk3zuf5svHPsrT8/eZsrAU8sdPc6dADX5+DyJ+xawITsFt8D
	 k80LyPf0g30sFLD2NLv4REAXsD1/FydGXxziLjboGoAkX3YOo2dwmsf9i5TkKCTx2S
	 WBQzd1qTcDFcQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:29 +0200
Subject: [PATCH v4 09/10] arm64: tegra: Hook up VPR to host1x
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-9-5510d16af89e@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=treding@nvidia.com;
 h=from:subject:message-id; bh=SIlRPF7qu85T+f5aFGG9WDkYzCh0TW4FAKVAomtiir0=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/H6GNQlJYOHGN/qoBdCS0jUkzXd4Vk6jQ2h
 JTmD3cBCLSJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xwAKCRDdI6zXfz6z
 oWzMEACIqA/jqNSmmZn/+8D+rbaLVylaNfVjA7uZNJ57u1sidQXKebOXtVoyQn/K+mkeIrhc18N
 O+MFVibwolAWA6T/YnMm1JQH2bxX4ZTFMLzCAh3+eCCHG4CMHp7FDgtzCqcHIBZ1HWSK6bcFn1N
 sAAyjbWG5ZscARPYtRKWr9MI3LRbVNFXabmrRHsh+ChHRM1BudWu6ST5fHq8LdxRkllaIGdU2yi
 xNfUSEflctaaxUdMpfVySJAyM9nF2b3pc2E07nicqP+hrQcjKyJQvgqrqlbaxyFY2Jl66w3FtI2
 7AdCE7W82qsEM+kGkH9aCYuPnZP1ENoeHIrX1VKxPrKsE4xrJORxV1+IARsXJHpwHjo66VwAFjM
 lkxoYFqvmSrKeqwnuqsomNdND8l2ilrbkfMiu8jsma4HRrndgM0NlOXVZTP1z7SOhHRYe9tvW66
 xsHf9OtWLpk/FF/SW7LCaouMUY0WsRQmxQIGv3OsPTMBZnj/OSeyd5pnE6NbyFgo/otthZQf/LE
 fAbCehBm5llGIt1F492e79yn9aWdeLrzrceTWpQqkCYZLCyTsh/J9bRcSA10NMDX8Xa43hQzqdX
 XU7wl1wan+4Gi6e9dehNJZNAivrEy55D536uGWR1iaIsq4RssrzIROnSReMp84W9rsL+MmV5DJN
 bR3HYD9oivnT1Kw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 3up6tck4eejmrdwjqf314cnsbpj41hxc
X-Rspamd-Queue-Id: 7ED5B120014
X-HE-Tag: 1786118116-371836
X-HE-Meta: U2FsdGVkX1/RiBjVV85qtRl5bKogxwHHLAV75ui2nFlmC9m+WpiLbfjH6own/awhrwm4JsOODI2VXbkq+92wyN7Va5NywR/9x1NgJVgcwhJ4LCm63MdvKxkP1uSekZg8NOLzmIczhqCzyLhwaLbXhxnzHi8bFG5iHVHdsYori/Gt4WTCeufrhY9bCIziS2Lr6JBJHikd+ezqIW4mefvJnVjtuvX3e9PQ5HaEEm/HkdP+NPpSiOme5aFyL/s4ghx2zub30IRVKSghv5aSyG/JYwE/Fp1PzoxtfTf5BwXEUQPzVlcClIfLzbM00xAFY9Dd8YitwVZK02lXBiNkdnOKIuVpC/y+PpyMc6EtbShvBXZrZm6jafRdQq7u+AsdnZNPkg+Z6djeuOGDOJV9FxYKdCudtGL3fFBJKrvnYDFhf/km6x9zhIbTrGZ8TVV6YIPKQuWBlN8N3YCWCNb86gWFf3uosmo30rdiTZVdJsyxNsIdF/AcuNQUdruz5E2R42YZmJA4fi/GNcg4JLmHzLV0FxKaODtJVIieGHRd1/PrNIenA3ipQ3Go3X/gXKpJLXWFeJceWg9jp4KNlufBd/1NL0JHl2OqgL7iGfcQ933bajTRtqFK1997kT87IMM0fUgYt35/FK0hnDW+u/43rCkFX6MIU4j5zIMPD9C10fUF4PKQ/XhcI4Qx/AMhmabXhywmyg3l9w2hQdeJkMwFaZXDNpGrrItlNvzpTuS/rYJHALySRB7VdeS/qpfTERHejM7X5KnXz3jdxPSG5wKGvK+xDvw9jLXes31+d7H2RNT0I8PsZ1SKgvDcwOS1sAoVOImFYd2YQGOOcUEIuL+K2QdO2VULb5W18Y6ijTnNJhkz2V25MnsUzf+sqiMUgqU0RwThcmGe7wCY30DoKhjxRxr9jlxGLHSUmgvia7IxraEE47YrovwLafKFNEnPgY2+6kTh/ALq6K22XPo8/AKlM+X
 kx0dcDI1
 7mornwIKZo446tVhzBNdoE3L+FrEIo7oFlYkYnbMOaEEtjPrEBJToJeWs939B8L+BDWhvMBMSNMkwQzQx7MhracyPhnXOB1rAPlCEieugf6DbObTMepGjZxzjrzk39f/Q5LBYUSPx49A8vPnM5O+1aGe7iU2cFqPvnbyi8VH8W2lRPp0q70A63MWoinvlhu/+YVcf62giPLPSGpJAikT+4Kf7f6RiU7bDiynNX88BvxvOW+4bduLD3OwsNZwqfNTv1X4zy7CPqIOFa0l4HeRRRkRfXfhaLa1ydLiqxCmIEqZVt4UP7/XhgKDEKUDrmJ6xzVmRPyEoGBrFzU0WmG1FEC1rZQ==
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
index 6c4739efc8a5..c6a5ced069e7 100644
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


