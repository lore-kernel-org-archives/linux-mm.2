Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D07DD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D8FF6B0294; Thu, 22 Jan 2026 11:10:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A6C76B0296; Thu, 22 Jan 2026 11:10:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2756B0297; Thu, 22 Jan 2026 11:10:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C8416B0294
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A5BFD2BE0
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:44 +0000 (UTC)
X-FDA: 84360088008.25.581F659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7690140014
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTGUpU3Z;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+/yj/4csgiXQAIn4zwpIztRE5FJZkQ6otcCk3HYOCE=;
	b=sUidT0jLLeLtk0TY6fQ3jIi1SyKIUhNWoS1ZgG++96QBcZpO1t/S/E7DRqgJttCs/K2k9W
	18aC+HO84Syk9jq6MeW+QCBrAmOp2RVrajI05DwK3HNfCN7XKyEC2zDF+jIjejkVOntzjc
	MpLIGl7X7r7d+/VzqJtP0uNyvqEYWno=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uTGUpU3Z;
	spf=pass (imf11.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098242; a=rsa-sha256;
	cv=none;
	b=rNR2ExsHlt+5sMDRbOn96XrNg1u3UIvA9uXTuV7tI0JYVFfqK1Y3L9lRFbbLbgwm5721NA
	8S7hdDbgMohqK+i/5YlvDbhRtSQKj6YIj9Gnhl8F6L6DStqzVQUm+szGvA78HzTMXvBqrc
	FhYFAnQQ0zh3zm2/+J4PRaYmtq6DqOg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B48C44404;
	Thu, 22 Jan 2026 16:10:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0395BC2BCAF;
	Thu, 22 Jan 2026 16:10:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098241;
	bh=03W+miu9snDAt7mFvXpzGvadHlBQWH/FakrfAMWKksA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTGUpU3ZmFiFvnjDXKELVR1KdEj2L7iy6TSUNG9eYUXeIteqryu0VBNTFn9B3W1a6
	 hjZGmjAuLTXkBVKn+uWqQfrFkscEMjBipQgzR0Ic/gDLWHXfwb7GtnI5Yp13zlzMtJ
	 i5uKRoBz8IAsSCEkbnweSF+AcfjkxnaOA0Z/KKTuAfgiYJs/Azupp1VUfCSl7txw8T
	 BfIVNQerwdBwKwDYx1V85Fps4MFUwOcOWC94GZit9kYDF+vW1CpUAMjkmdn29+RyHP
	 6NnTuC97wKAoi5VkqI6OFrEpyv3EcC7sGn1pL4QV+e7KOvNG3Kj0tftF19Jw8DTjTT
	 xvpJA4fIdhQdQ==
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
Subject: [PATCH v2 09/10] arm64: tegra: Hook up VPR to host1x
Date: Thu, 22 Jan 2026 17:10:08 +0100
Message-ID: <20260122161009.3865888-10-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4wamgtmnuoqw6mtrosi91rpxwin5ysta
X-Rspamd-Queue-Id: 7690140014
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769098242-432457
X-HE-Meta: U2FsdGVkX1/sIlMxsGyhYHUaFy885pM1sVKzqkLj8Om3R98XzSyo7UDBVC8eC5B85qsQ4Uhud/A4OXjX0/LjGbikUHj1PO5L/8k0A5fu2R67uaYJWXs3/f5m2uoIebO4E1bE2pCLDzXRIBf3WV79j59JnfIgGeU/+oQlOQjEYNQCIth9Ujf5e4RX4NA7ju4xTUN7VWa1Yu1dWYZJ34PIQCXCHZpP0/2x9mh6TrpUO0P5lCJdRpZlOFATIqgjmINE6NlS1hYC9zFj556pNVCnizZQyAjxOhy9GBhmFH/RfpiS1tnmKs8HOrftiSz6HWJHCrXWaLUx4nZIlqfhPzjScyyyesGPRpXW/hj/GHehJBr9/3L9pCHG9+GlQaZ+BzCWzkDQmUnlAXJiJEDxnqz7/a8sfjDOUoJ0C/F4rp/aMmsSe3+xhdl5YJf1euwDM2bJbzE5wP3EWDFeC482bLpsn3a1o8Ov0FZug4VUFDuPZ0Iz7u2EV+SzmDyBhkea8kqBF3wdFv4GI6NadKjJQujKMYbgJVF5Q3LoLYtzmissToiZz02x3SABcjs2zTg0oGqo1UyNFx8/yCqsEPP6S9L07KVYzMSr1gfH2aAc/gDWKeQYxc4b3LDi9dlNHw+wk3PSJRkCegaCuWb1tVoJQKWnaAAFZW2t7jS3tZMojttF2tEM+BgUl9lq/ENdFFvzieWtsfYchlMBvhINXhWOf1ZSZ0BTx+6USPHslTgfKQEg3ZyZV7L8RuDaOX+bPRSIWclVVjAWFvqEGk5QAUN2Ztr34y5wLHIRQj9hpBLXZYpXdYHRDm3oQvMLoppEMP9tBhJaRWNp4zl2bDBY2f6k5VtsDZ0yaJHmHOGe5EImbhfOj19btIQvLx4mlS6kte2e42gK9ytaRPQwO++kXO3igjv0HzAvoZ1pDNeSpOeLiOeH8lsgpaqmsubFWcDh5aj2YzLjmb49eLr4VaYN1xx911X
 yXbYO9ZB
 UgcIIjUy5n5mgI2vcb2zKJBJ5MZua2CI2S7vh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 5f67d9b57226..cfffa4f2f196 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -4474,6 +4474,9 @@ vic@15340000 {
 				interconnect-names = "dma-mem", "write";
 				iommus = <&smmu_niso1 TEGRA234_SID_VIC>;
 				dma-coherent;
+
+				memory-region = <&vpr>;
+				memory-region-names = "protected";
 			};
 
 			nvdec@15480000 {
@@ -4492,6 +4495,9 @@ nvdec@15480000 {
 				iommus = <&smmu_niso1 TEGRA234_SID_NVDEC>;
 				dma-coherent;
 
+				memory-region = <&vpr>;
+				memory-region-names = "protected";
+
 				nvidia,memory-controller = <&mc>;
 
 				/*
-- 
2.52.0


