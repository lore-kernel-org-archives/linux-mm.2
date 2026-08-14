Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86AE1C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:30:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C358F6B06E0; Fri, 14 Aug 2026 11:30:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E0D6B06E2; Fri, 14 Aug 2026 11:30:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9D66B06E0; Fri, 14 Aug 2026 11:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7797D6B06E0
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:30:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D7E41C0159
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:30:00 +0000 (UTC)
X-FDA: 85100260560.03.91AFDB3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4CF7140003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TlY9dOe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsqfU4rnOxCjbdNELUfPy2EP2mOE10vhuCcFu2B7Ivw=;
	b=0x9+GCNptqTYeSSfgQT1pVwsXaguwnjI28ow/L+RdTYPs0h11LWrwmwzgMt2P0lf+8wJ10
	BfpdmoTZlea1+09rbN9HjozuAmd32shrvkIpTjPb7+D3UvMI1eozx+tO6oiRAWu6QEqLDX
	i1IQJxPbmLwPy0lUYgUQCHDV21pPFtw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TlY9dOe/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721398;
	b=gUDKqTR7FIKyYaYBnpSFpU6SVqXgCoRDxn1o7jvUdlrJ2fkGhq8DST8SnlO5/FwgtSmXQg
	illcAZeLt3cqSz0uCQX90SyD38HtZ9dCDlyBQ7OXi6rRUmgQNINDduA6VjRgFai9F1wtXk
	7FeE1p6fJzlD4StHh7uR7cksUKFx/ek=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE51060A69;
	Fri, 14 Aug 2026 15:29:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3671F000E9;
	Fri, 14 Aug 2026 15:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721397;
	bh=YsqfU4rnOxCjbdNELUfPy2EP2mOE10vhuCcFu2B7Ivw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TlY9dOe/m49Es17ojXqtIC6JsPPLhB51fuiigq9mhO0OsfqU/dpS8ol9VSMirZnys
	 N+Sz7Y0JvYdHmVXeGhp8lyOGBKXLCZRDGKUGk5Af1VVt5A0DxxrqHZrIW1wv7HVEuI
	 Gk+W6MGpvoBmb3bQILgXFn225Y9gykLhrAfhdMmbi+FyWEntwqfXVZkEOkp7M44puc
	 DdILQj4CoIG67RY/8F1SNui1WxkIqGgZT9PlkkXmIAnN0eqFymVnrX5PDfHaPLYabi
	 jDEZUsxAYgC7oqJaLzWt+C0vDZoz/Gpks+B5Y/ifhVblSniSS/eCj9O87aYsKWHVt6
	 c94JDdp63Kh4A==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:17 +0200
Subject: [PATCH v5 09/10] arm64: tegra: Hook up VPR to host1x
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-9-71832b5d0246@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=treding@nvidia.com;
 h=from:subject:message-id; bh=uOEc0ecGZ8h9g47cFlkUo3cheaRQXqI5mvM+m7jx2j8=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRYQ9J+7I4U2eaXmCOV49EwtyF4cmPzXhSyC
 Tq+2quY1HaJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80WAAKCRDdI6zXfz6z
 oU/AD/0XRytJsEu68Ff0PfHtnK+eBBRHrioM9YqCgL5aBA80Zw/VnVUReuBPZZ6wyk2zAETMZGU
 I06nPkJi6TA/NwJwuc2pygr5F7fDVmL+rsO38ovw2JGgCdiCOciqpsd9cDqquDI59a5dwo1VULN
 LhvF8edxPjVFQlcCRihSuMvlOuhwngvYJ2or6ng0CLh4w4xrPsFCPTG9eh0hUvQQIdMeyIroGug
 K6+q4Y/za6Isw3zXh++Yb7elZScIp3dPC96xEpF67MVqJ5Zr+Hdt2BoC1OUWAX2vCNXn+ezHxLW
 CnjP4Y5h6zOC7WNnucPZGvecau6mMIU3EEXqKy/OehY0OFZujo6EsFJsopFibt1OIZ5L1oXcq8N
 TwU08UiHSX7OCL7SpcZ8vIG/093IzXWnkkZL8sfsc1Ygg1QL2oervYhf+zsLFMlHu7FMt4UqouL
 hNmstA9OD+5jBqNaSQ112uV2CINjMclaevNLLjm48+z6m363cfrD102Ybu9PjEibOoT/psH5Am2
 mLHTSjBZblYA78ADS4coEm/4O7B2/Nwu4Lv2dGanNcw5Ey1unUinkIQrexFKxH1rNu3GpEqyAGE
 SAy3sjcVNL3Paa25oMm2xMKJ+zD9mjY3+e/sYwrE6sW/OnXgp6X1KggP85+52DqrsX0GcezgMAk
 C3trgaesgMJRKPg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: 1zoxqs8gd3y7f14w3gyib7t5oyzpkw4p
X-Rspamd-Queue-Id: 4CF7140003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786721398-259355
X-HE-Meta: U2FsdGVkX1/ZL93f2cMnFaBfJkGekWobdQxO46+4fNGTNkFX6TzwPfVX+Wqplp3SYBUfsGxmzIZNE8Udo+n4JtRlCPFJ5ck+ia+sk5b8iWQB9r73SkJzx72Nlt3vEkgHXn5mj4tezKF0YVzsNRQiMTo3IxmZWDhn3/YeGOkG/a9fLD2WrMomG07YyN294N3lvzjUsQmGD8ZVYQYMqyr2Xn5976hISLypg+CnVCEO0hFKV4omOWIFlqEOzIeaaEQDRLrfqG2jlm9qDBLIyLvdkCYCt27OOmaPpuGHpqZLiz7eXIv2FSNfCLTKZW+lGNLwecdPTdEVaOQLCKQb1awbLKmCAzbiRHSRewQhA0oMaWVt9mNO00VWj+FpAwn1QQ7mJrGxTQ9IT0mOk+tdMJhr7b+E56lV2nkMXnJ1yzujHxOE2PJpBCWgBAitBjMNUT6JL+TCDonimZC9BMweUvn210KR+LBkE8bVfEE3nbYvLDeMiLBQYf8luSToWJkz8H2VRnIYDNWTf8O+QfcxrDvhj/AZpHMcHdgHzrCHyr7CwJSGUv+DqeCqLW9zuP2g9gecGMDdy+hr0A6MUZvrxjAU1FnOQFtlwx2lM9kfgrYYzUyy5qJ6+cMRyzZgVgOs64fctmjX4HNKui+606OBoP2fnSL2JBpULyj5U/SWhFgeMSMTVSd0pMe+0f9NUtL/0ZqYqk+n9O2VkZpNrkQIAg/iQS40Z6eMMSUrUoHqhjvnF0diqLo5qKV7/8g/MYCVGxqGty4n+ykepxHshpjNm4yIHWofOElFvGCsUSJahZupJ73HQlIE5nzrJDKGbN4EMotQcSFO79lqlkfFf1NzH67qlYZUsbVec6nJX1k8NAlBk6t+8ksMz1fJc5twTg5go1JdXNPADlnaL8iyO2XVvLSTVaEJ4YiFi+YDHZvfXptPXA/h0aqx2H537jJwGl+hmXhjXvTnLT3x7VvWVPL7w2D
 mxXbJKxh
 hBGmKXVYzJq1BmaI9oz+U1GH3pNe08t9JS/DnOVOgMjQpEL1GfsQlyGXnmiDaxJaCMY0GsHwHHT21nwA/RtgrhIo6uRB+Fcmplci9udHdToBwhMsUh1jpag7KCMMiDpeURmXVi1Wc7urr5pBcm7OFgOu61qOHnov+Jy02wm3G5R/tEg4J1PM4aHBSuUC+IfwUk0zghynmJVTnK0fgYIrwQuhse5SEGPKnvxlyf8xvTsxm3AodkDof3z8/AEr90qLlxHzvuIJfX1+pSREgyTfGYBe+191IhhjgZCM0JLZC94ln6H3d72QB1s/BCadCImvV+xqcSYJBBsVgPKFvoUXrxmTb+9l1DedCEjMJJXGYDmvhQn1l/FnLuylDzIXY6TJDrl1wHoNTUTHOOxL9Ko6PQWnoCgCCqMrDGYWVMoU3K4j3IFahG2xFEZoPDNkl8pJ7xtgvX3QcRa3kWykq2+vryUhUDQ==
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
2.55.0


