Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73946C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:46:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4756B00A6; Fri,  4 Sep 2026 06:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B2E6B00A7; Fri,  4 Sep 2026 06:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452FB6B00A9; Fri,  4 Sep 2026 06:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 191096B00A6
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3AEB80803
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:54 +0000 (UTC)
X-FDA: 85175749428.25.1DB9883
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DBC2D40002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YP9DP3WW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tp5ZGMgCkDYYyYju3vZvBz8YmJ8LdRAUta1tmaeUPO4=;
	b=lLQ1ekdn58ExZnhzdHICTt0rbVyHp2JVeI6Km67s+mr2e+hiaXcaCif80SmWVu9uV045J7
	6YKshTjkPqLnDYpmxR0ZB0/E3NFPTOvfoBSKRHTKvj4W/ASIrV9bhtwkUavOv5VEOMGD4d
	76urT3QC0dL2XLIXGCBbfKccizwOs7E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518753;
	b=j7W1XM8tLPXVv1OQfQu0pQPiL/Q5HWqAu1NBlFdrk6/Uu4a2kug3EqI8HB/rPYq4mmyhBp
	24r522DThdv2QW5ow/BSeU9RdIUV1+frOccc3czcWFqP0Lse6hYmiuYkq+bgCCQ6dXRbas
	/6pSKuncGBme1E7zIGHJguVzGORCMLE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YP9DP3WW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FAEA41502;
	Fri,  4 Sep 2026 10:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590C11F00A3D;
	Fri,  4 Sep 2026 10:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518752;
	bh=tp5ZGMgCkDYYyYju3vZvBz8YmJ8LdRAUta1tmaeUPO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YP9DP3WWRHbpiBvqdRY47YbL8PcKvkW6ZXkIs1iXMKrHnkCIpHGrZPLBccBF7fo+9
	 LV2JfjAHdxT74nfkVvRATWOGtmNEYIfha/f9lSFm+oRgKm90U62Knia62E+zDOb5h8
	 BQHGnIwPgCVW2OaNJzvAXlgTZb2AbvzmXnUwyoIQQbE5eGYFWO1Di0Lr+YUVs2rnf0
	 r7W6QnGFNrRfOdMjFQ+XjH/4PTzUJexNHgYqqxF0Lu30hod7dzL+Wyz/10mkHaqB/T
	 O/hvZ9CjdZzI1ffSGAwm/du+AWBMSAkXfEGbuPOSnZdgEhDQUX68+TcEIjfSjIePTl
	 aQbfiX0MrZCSg==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:45:03 +0200
Subject: [PATCH v6 12/12] arm64: tegra: Add VPR placeholder node on
 Tegra264
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-12-79042cfa8de5@nvidia.com>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
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
 Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>, 
 Saravana Kannan <saravanak@kernel.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-mm@kvack.org, iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org, 
 linux-trace-kernel@vger.kernel.org, Thierry Reding <treding@nvidia.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2208; i=treding@nvidia.com;
 h=from:subject:message-id; bh=R7+I3znIc+C4CFBfwF3uhHrkIxj2+n+gJD2B2rW3tV0=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE7rP80/4E7a4eMykLVRISmqrRHTPAuxP98w
 IQWcaSm6L+JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOwAKCRDdI6zXfz6z
 oaKNEACHyKhsBTZ1ctuBVdFSOjnEQ57mTqBOSye23UOv+Cr1ljxFp2QbH5hIEcClwoZOO9RCHkp
 Ta4o8lXpIGEeh0Os6ntBR3KiBB3v0WNaZwRZMwygvkxDFdGVgZv+m77w6UjOiNOOiwCO3J5sAXi
 Z1LPXrk5DPnIVRNxKPWenoikUckPR8eZDbkLjzC4i1lugL0pzKxtYA/KfhtpKQ3ySP74CCNVlLR
 lIV7U3WbT+g1GKMvtGNimuiIRl5iPmXfM+hs0uLpc9uWLGhsLMVfGVUTCmjIDDgabJWY1W/ikVx
 oKbI5FF342XhJ+LD2NO99czozExIVH/xTcwhhijOUOMPZ5WCV20Z2Ct1BlhkN8a3yK8CweWyWvN
 0OoosKFHIGaJw/ZXOKhzODb3vrk0W1sMsJMrrRbAWpXoeNWJhh26wKyk5uZ5kypmlSSv6tSUmSS
 0i60LJTaLmdfnl5vZnL2nKNBmpjWdZnT9lhXfDn4/v+saokkEIbUkA5QzpPBWsc/EQSwKN79Hjc
 t6gbLAylaeVwcS6w/AalDjDGEDVGDQ//gIHc4WSypdbJIpT4N2qhlCQaTIHyq3NxEj8C24lCtvz
 vJBUWMxwp8mg/mGygNuSa9PivjI7QtLST0GOLttf8SYkBQ0Fa3MYv1YSkoYYglsWVF3WDMfY8I5
 2up7C/PXiHlgD7Q==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DBC2D40002
X-Stat-Signature: orqjyngb1cyo3g34mankzeq4nwq6fnkh
X-Rspam-User: 
X-HE-Tag: 1788518752-713829
X-HE-Meta: U2FsdGVkX1910QorRf8ZZHW7V20bxfWYAg0GeT+S++03lTsd2JlstFUA3VM4mQeeWiXfLpGfKw3ZR89K7vOTJujJFwvM9g50LJpMIscE2A51oAIkb7oottiaX4Or/cISuH+6q3fOvDBeLvRQS/XuA1+9DXUQGHA5W/aq9JLbrSukV5nE929qXdPeaoUySyVa48Uu8vmcI5gJM4Iqz1ug+cWsL+ZDAEWKemVGzOYZAnuiv0jLHklKNxDWFsE5ze6O3heBs5oM7grJfv6h7mAk3Ri6x+rlw0m9EyuW3Ub6lUk+vc0JrDRjbE3VEjgTujvo2ohE2zMPzAJMOynKzCyqwJAxWzWEE+Xqnr8cueP9y+U+FafCaCW5GsxS30yBcrEzYIF178ZQKLTkZjUgZX3cr3W2Mw37am6vroZQSpjb9QvFw7gEEoZ1UaFif1dXSQM1rVi2uuNyXeI4BvcbIYL09OMfmj1n9wqmAg13NEV2bUVgH9lWQv4mSKJDEGPiUBRvWtDWC/gPIAM8VY9T2uuXGfe3YNgudT2XfuTHVYMwrRCWZM0mYMvFEJ3Om+90fiSvqmtP9uUA9z2S1r12IXD5lZFNv/GSHHHmwCOgSBLrTOZ+wxXqHjqUD4EwZC1Z+BYHsf+v7/g0Yc0w3jSLSyQOHrE0xchJldzUlaQcL4+qM4IZIFZ2ZWY5w8uq88tDSymfZ6yfPgzRKq8wFgzHJfPQdDpwFzt1ARl8S5BcOKTqz1SyCdh7rdqHyGC3jU6P8cbRkDBphVoNCgCT5Qpd28FYdchuE2jG8eEt4qyBsXGMLPd8tc5BzD+KmfYnYjsEP9EX0brsHAuOmP6lYub06XUFf1rUgYOhCGFBMtwM1YOYY1OVo4BQK1zxHi+fO74CxxrcIyeqg6l0Lw/RJ/nVvpJ6oPQ28kFEAWJsUAZ2lJXDkwCfXWAclGar/4iJ0VYk1zABKQ86eEHcq5xk6QHkXZ6
 UxJpM2f1
 E9fsN4s5iO5slthxOCBVJrEzL4roetxKx54jf2xbkLiX6mp3fDx/Z10UBZvN3y5Dp2i9JpCDv9glY5zYk7XDwE55224zDKQ+fBTqd3CaE1enX9hpwPBVHh+qpVn8HT7n6e++VtCnlRRKxdCidOtcJRq/sX4t2LZWXp6C8Cc9IZCoejf0ACj6iqM39Rfx049bSSzm+i2jdTDwIyqCig9zSZAkgiuK+Bv8ypT6ANMVdJ+H2KOorS/t1hmXoEoeredQzSnZD241IlxQ0pw1vmFSCGmn033L75qHslCPauI0z2lF3DLhlz7+sSCH65fIvIxeLFOdzVSfgwMSFmFDzNSI3leAWaGuUsulKmWqL
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
index 964f18b256b1..998f7e28b9cb 100644
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


