Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DACAD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCA866B0292; Thu, 22 Jan 2026 11:10:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3BCB6B0294; Thu, 22 Jan 2026 11:10:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900266B0295; Thu, 22 Jan 2026 11:10:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78A356B0292
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 46491D2BA7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:41 +0000 (UTC)
X-FDA: 84360087882.03.4A0634B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 91008C0004
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXNZYYif;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WL2W/ZDkHyvzso2YcHTRw/lMxAY8yln4p4mC/TC5im4=;
	b=ZCdXoWsWQioSZrbLao2AZhWx1OdY9S1EcSiDuXbpS3MrdJ63k3GgoHCx/4mnDs5150uIWU
	GK6Y8i8lKEM7OuD1JFoFiu7QXKjDD/U+82/yRbjD4whB4eWwUciR+mQlPZmMQnp0VaTqTn
	w+torSk3N1T9NgxzdjB3fcVu/wjRFvI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZXNZYYif;
	spf=pass (imf28.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098239; a=rsa-sha256;
	cv=none;
	b=bOJHSuYqDw2WAJlv9pJ0lBkaLjcOqIRrqKzE0UKmgWgQdXXOIm5kmqvVMyRjGhPsaIRLWP
	lwguMVb7nKwtG0+eexLe0ZoRQoALO8873v6rnlz0C4+thRKCKpVYGhrurfjfKTU/yCce8a
	Y5l5vM1mij81K7EX77CzYXISRN2luTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C59714437C;
	Thu, 22 Jan 2026 16:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DD1DC116D0;
	Thu, 22 Jan 2026 16:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098238;
	bh=lNdb2W7doKmrgjPjgeTtoM+R64zDLdfcfrtXbX1koE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZXNZYYifm9VfYi+kclez8EXzUF8ZUAOh0AcT+MNc0D0RXJqfYWLhzByjq5MlhFmtd
	 sRi82Cb1e2BEjdoX46KkmpvNQlwDNUbBT6soROJTmNcTVp6R5V6mnZ8R+wCv2EWXX/
	 Kje8r41oR9ZvA5l07jd8nek36Ds7WLXFX5eopUTuk+FBIjaeG+nnDGS7sPlx3YOwBd
	 H9BaINgwXQO+IksIcJQf2upD/v8eG5jRlow2zE4OaI8yOpyAYyXLx9L5hrUxwWtr57
	 Vu5Fk8cQFq/REpI7FBn2B1cZSt5DkI1BTUqr1097jyARnhabib/vLus1qLBadiD8Gs
	 8QvTL4WtyNSuw==
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
Subject: [PATCH v2 08/10] arm64: tegra: Add GPU node on Tegra234
Date: Thu, 22 Jan 2026 17:10:07 +0100
Message-ID: <20260122161009.3865888-9-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91008C0004
X-Stat-Signature: u368b67r5wytfcu19itmb1w88ns4ak7n
X-Rspam-User: 
X-HE-Tag: 1769098239-984717
X-HE-Meta: U2FsdGVkX19EVpkUA6dSxGcpG56z5+PL5eJm8MmF0127xrric9e6mDO2fR0KwwtXl/N7nKbAfBPXr8s9AYtDzvEVYgfAtOVN18PbeEnj5C/9rHLJXbVmUUNzGgkd18jwHBZV6mT0U8xDe3yQMY0cA+gBFm0/Cu96C1jsvkYXoQdsSSa2oCGfFKrP73g+oZcOG6atspMRUoHGRlkSgwGRiuZMuiuUtxvOPp/s8HM+Y2gY8ChY6SlrQWaOUQMDmFkEmlmuoXbzd6fN7i2+3KxwpblEJ8V4UlPevTb3iaCNZiEPtR0tBH8dIzUvUqL9G3l6LriFIhYf7M7lUpp4O7XuwXnIzLGRwA3Q7SDzs4v1Hvxumr3MyipciUkbRcu8G8v9Z76sJ8gxq6t9MTG/vjPkrVjJnIaI8j4yIougI7jPq+eGg1uk70KaJAa5g68lypbmPUq05xdKYKrTlOSQA63dwzR+zJlJRRDILjYfb0ndCno8HZpiEfaNhFSGaZQaWIyjva+tUdlL2Cgujb1ozy8vm/ZE4I07ONnBw4+tpGMgQUciaeNkRqtkL7sZB/i8Fyoo21eVpi2ARjv4s9YdPQH80fsDSoEZ3ggfz5p9GTqf4uJr5mZGMthPfejdvCLGAABODMJpD5rP+w/t0jdM3YlvDq2ap6cmRMqWlF3tpYODqKdaMlPWZcfpfYPo3iuuOUCfbBsMyNLhw7IoaaBIICeMrnK5LG6BOn6QlpZTSPkQ+6QBaz1VQ8sYml67JTMbgLimE1w8VXjdrg6D+PC6QKlmq2rioNgsJ1TzphyaU/FYji3szEu3aJK46lTU1gIrf8nRWTJZTwwRgxvf9bCGG0GHtHPUSkROhZDkRz1VQ16ufW7NUDiBtNt9E2vlCFDFA/pk/wZPI7Z+cAgklpoQsDBzw/ViGse9W3WuGLwumDPUH2u0YaA/PYTdM7ubWhYH4h0hRfTEdQCodbz/szRfs+e
 73tvyR+p
 L0jrANnEDFLBL3AHHQ666cBbFTDNasvxwqyKZSRnmgo6KAJGA/Ua3+0zuQHS8cXAZBIXWCq8EVIl3VyaaPW7v2+rlNcg7YHodHwbJK3ti8TE3meqZFnq7Ta1nqVqcWtH+/42ZXHcUvHVGnDcddZ+jSk5qCaUXWd6eGZHD6dZmVVlJDd9KE5TrfYRgjdGg4ekW9u6g18otk5LzScMzs/vqV7qGaGkBLJWIB7G2Icezr4BK9n+61zrSfRKOY018V55OYUN19Jlxaw3mOexaHy3zEiNRsU01+Pbb+ZkWZFcKd/oibIJBqLxVxheBVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 62a5dfde9e38..5f67d9b57226 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -5317,6 +5317,23 @@ pcie-ep@141e0000 {
 		};
 	};
 
+	gpu@17000000 {
+		compatible = "nvidia,ga10b";
+		reg = <0x0 0x17000000 0x0 0x1000000>,
+		      <0x0 0x18000000 0x0 0x1000000>;
+		interrupts = <GIC_SPI 67 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 68 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 70 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 71 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-names = "nonstall", "stall0", "stall1", "stall2";
+		power-domains = <&bpmp TEGRA234_POWER_DOMAIN_GPU>;
+		clocks = <&bpmp TEGRA234_CLK_GPUSYS>,
+			 <&bpmp TEGRA234_CLK_GPC0CLK>,
+			 <&bpmp TEGRA234_CLK_GPC1CLK>;
+		clock-names = "sys", "gpc0", "gpc1";
+		resets = <&bpmp TEGRA234_RESET_GPU>;
+	};
+
 	sram@40000000 {
 		compatible = "nvidia,tegra234-sysram", "mmio-sram";
 		reg = <0x0 0x40000000 0x0 0x80000>;
-- 
2.52.0


