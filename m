Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D57C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89A1F6B00A5; Fri,  4 Sep 2026 06:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871746B00A6; Fri,  4 Sep 2026 06:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7603D6B00A7; Fri,  4 Sep 2026 06:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4ED636B00A5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D59A5A4F1A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:51 +0000 (UTC)
X-FDA: 85175749302.30.1C9D2A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2133A4000A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIcZYSNz;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YsqfU4rnOxCjbdNELUfPy2EP2mOE10vhuCcFu2B7Ivw=;
	b=BkDIyt7wd4qnQHiy4fX6soQimv0cwndfC6XFJFB8L0VEZ8Rq0mncUld7wQdHHCV/GUMofl
	6ZKyGhoY/idbWglZod+wXVCv2WTlcS5XFP8h7u4A7ROHaLWuAKusSOSiqKoxgwwPc0x8ZH
	urMO6M5rSB+XEyLaqcKcYOVUUfQ5h5I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eIcZYSNz;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518750;
	b=zQh5ATzU11udqy4ry/9toFpJH/tPpHe0A9zOWo7u7BJzjWeyEqwGx+9h3rNCB5aMNPxbwH
	KBumyHZ+Tbz8G3Js4tr+H01fgzJoVGSkk+oMMUytzf28PreG5iXSy57L4WmFxcm1p1NBaL
	UWmoNJ06ukPlIayzY9h8q/VXu1pJM5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C77D43DD5;
	Fri,  4 Sep 2026 10:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98C051F00ACA;
	Fri,  4 Sep 2026 10:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518749;
	bh=YsqfU4rnOxCjbdNELUfPy2EP2mOE10vhuCcFu2B7Ivw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eIcZYSNz+EMU1wJDbnZ7IB4nUkt6pmqiN9ypT7xdXDKBetutOJBe6ISblfxsuhABO
	 8gu9ZrpfWEV8GuQQaIkVaMrKKTsBcPI1a9LVKBPB6lp4vFb4p6MUt1o8J+f8Q9JQ+5
	 i1zu5i2VpZDULgo04uuwuPTweSqZrxltdhEJW978nE2aEbSz4ONKWizPqUykM5cINR
	 3Eb4qo29Q25adrLfYNlJiAtOTc4+PdXD6tmqo+3aZAtdCE2rvKqnUXcieI52wq03YJ
	 TckMPq3pX9hclABWT2q5hTtbU0BdWb1968ZkMkzAaazhu2nK5fftv2/tqDszxW0Iii
	 /VFNdlKvValtg==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:45:02 +0200
Subject: [PATCH v6 11/12] arm64: tegra: Hook up VPR to host1x
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-11-79042cfa8de5@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1002; i=treding@nvidia.com;
 h=from:subject:message-id; bh=uOEc0ecGZ8h9g47cFlkUo3cheaRQXqI5mvM+m7jx2j8=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE7YpgB+UW4bihyCTOissm5QATEBPRPgX85W
 J6eTpZr/RqJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOwAKCRDdI6zXfz6z
 oQ2TD/sHzBA2pRG369bC31+gXcK7TapnCz45reqcz4nihHa3IPi+ER91aVZ02HHKlgS8XCmhR5H
 NQCQtM9uARyGfjdGOuPIYCIeSUJ2tUpUscrh0pzM1PlO2B5R/o/IuOvBpaYXDXo8utSe5muX4xM
 1gx8QtCKLfBq/Qp6R5ac6C/ybJtthKei5x8m8FH2opPQ+Kw7ZhODt0tIA6Kyz3EUuyXr1oOaLSl
 d1uHqpDMyBFcRo9v38nbm9Gu9tcHcee4LYaCWSjp2e27lqDB5ynyOxYPiVqhUPDHODEnE40GSF0
 HCPOGK8aWmRdKrLYiiZrnyc34ZDX5tukJ9ylMT6Gsoili58f1VQbTP38Vflhxl3r+ijmgi3XmRs
 ombeMOdZvJxHCvsaXignsftiQQ8DNLv6+zTkTbGznqfjb1New6aYPoS2HRZ0d82MDn9BFWP/6KN
 NG2PW/g99K10YYoTpZYQ0lyQAa5zfAh/tKEkwb8avEoHXswF5fUp+Dx+pD1cXlev/6LeEiHtJe7
 E/UxTdopwiGCS7COTxnXp/OTH4M7HCrZavExIayJrB8QFFTsfsTtCCdXB1doBC4SAKbDYAfuV3+
 Spwv2ajjV1+ob6L4xpL2aITbV7myXUR8GNx919nAJ2d/FleBjFqIl4+PTBjwErta9Mb7Y0V92l2
 3X0W6eay5myH43Q==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: od1gdunqo9zz7zwag6zmexc9sd6x5q41
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2133A4000A
X-Rspam-User: 
X-HE-Tag: 1788518749-549677
X-HE-Meta: U2FsdGVkX19kbD52IFVtqkyldFZkBpjfDtB/4ePxkyqkuv9RDAwGZUV0vzECTGm19RjAFs9FbCTZtbv68G2RcxsQ70rIrUyXKa7wjFr2MHdl8WaSsXhP8+a/bI0NwFzYJ1UtlHlek0+wHjP7wzhQhJ3caCBt7l6UfdbOaKgTXAqyruu7Aqgu2t/uK1UKMNns6RViC1HCxmx5okAR7QAb325/JI5hUEMVxxJKgWUrCrZpCIEif4zKK75WfzS2fsItm0vWKN3bpsq98keXHaubJYF/plcNVSVorwNDsOGvPpauei5sdw0x+aVpENsxhwDdUwDro9sJMLDqi+WoUg4Us918YZH8dr/narK9tUy6slZMaA6etVXnAmhNHr5VaQRyY0wTMqPtZbIgWw/8jVNTh1orKjDSgtJURjMjzK0CjQr7arbVq4oTBLXtyU/JFAVo+yZBYlYWoyKvatsnl4ao5mqwJPYSxCO/RAqxxg+mcIbix2jIv6Ti7KmGbUXYpRgLDYrwYJsjHsDcw724QklhpQAmEQy+x0x2MVHxfuYRc8DYyzSRC5Air9CvsShYsRXeEIE4h3cdCxDMFuIWGypVFe7PNZNRvG/KcdkzB0BzYWf9YuPYcfKIeWhsxAu0whkZe/a600Qq3lVkRl8ieA/PN2PuouEMJWFbQnruNIifTd65ytDhJZHcL+JHjvryyDRd0UUoknx26wW3OB3Zoed4Pvtk8oRolSYUIzP/ASUIZVvE9UuwkkfUgpoBiHmlSdJkpNFkOGP9o9hif/3LbIvwNrdnAT1ahW67bQ6KWepSs4M1U/R1npznxHNW3gSYLYCGTcQsPFjFbUlCe2sec6mpsQXL9NTer8XNG96X8M/boIjITOkuYNQ9Kg1ehPw/DKHnA6tgeyf4gsYF7B1IwoLFDUf/63gQ6vaMoALHEuWYNNHHiRmGkl9VLeLNYGkkNo20A2Ith0u6ffmaHAQ3vTr
 wfGJF8Wq
 i9XMTKwh7GeFo3pOpjQu4Up69SAfYk4W08gPwzqRgjBhNjyh4KgSHoA8Ow+0eiDfiG8UcedqZn3qa1vf3YUr/eFtf6c1mmEUYh2fluL6V801eT6k4i6GjMyznd/Ac+/CfXXLa5oTCRTdeeIRQ29GSN6QKTX+jBjp8QgmcQ9mn6ZEsmObxNECYbAgI+8IVIXF1flcWDNlYR8AsHP750KqoKzwDwOJEmRPJfqC+6M3B4fU1jJmlY53NewEMUDR60OC7Bs9RneF/MvNtBLzy0ZDHuQ6hrIWCMCWRbftFeLOCNsLPAL0Uyf80JMUq1vmNONZfCWpUvIUxCUWbEmzkZjrJyZXieMc4QPyUSPQ2
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


