Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066BCC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:08:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2BAA6B00A8; Wed,  1 Jul 2026 12:08:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC5E6B00A9; Wed,  1 Jul 2026 12:08:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB9A6B00AB; Wed,  1 Jul 2026 12:08:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90EE26B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:08:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1623240411
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:47 +0000 (UTC)
X-FDA: 84940691094.26.7732835
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 41F8E14000F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnlPXo6K;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922125;
	b=FCuog3wSxk5SK69U1TFcvqBp9g0ol+n46w/dXTOGKyYopAYX1wE1+fIChds7DNw7vB0w2o
	smLbNTwNTH97ye9o0NYDY8lAg34/5WbsWdAq+5qGP1JEFoloylx7zlbcmSeIGoo2YoWhrl
	I0mZiXur8CcfqdoW5n/hWudM300Q9k0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMG99KrASAgPXd7BmpIGuOHPcTsSyUSkLuJtJkK3AE0=;
	b=ox+lKWgQQbvDO1OL3INS5pu+KcaWAhp04SlEsi7AZmI8R4dPFYPfiSGAAceOclqC34k8jS
	jhMJlhF9RjZEjuRYJSAHspjpoLKmN+28Zvz1PuZd0zP9aCtJvY/Kgvs+0Zj3bFs3RALmIE
	XHh6Aeri2k50OQ+RQwVIKm7WrsoyG+c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DnlPXo6K;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A05B60138;
	Wed,  1 Jul 2026 16:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76C911F000E9;
	Wed,  1 Jul 2026 16:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922124;
	bh=nMG99KrASAgPXd7BmpIGuOHPcTsSyUSkLuJtJkK3AE0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DnlPXo6Ku9YJptA/pggWMvD5eX/ACYGiV21WcxQyB3m2e5Auu38mbBzZym7IH8B/A
	 G1MUaejXd15Dt1XkJ/Jx1JAYpMFVA/xGd0jSaRdg/qJEk6XocnfcUBqOO8ZSjNbKs2
	 YFyECU9egBeZcHK8H5BNwFmXoJvQZqVi+eVGoEdDTOuWO/n63YRYG6qOtBsQCx+1JX
	 kwYxxAt1MkjDcBrIcGNt5xNCIp3b6+AgdZKf9h1JHsmmG9MoxwjNZFnwvnupqgjt4T
	 6js+9fPkQ01TueCeOF9UHamaqhusMu4eCXCr23h8rf3Zm2jPKxto1VD3OYcFIXHlGV
	 veZlGGZ8FyWwQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:12 +0200
Subject: [PATCH v3 01/11] dt-bindings: reserved-memory: Document Tegra VPR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-1-d80f7b871bb4@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3519; i=treding@nvidia.com;
 h=from:subject:message-id; bh=DfAPq+WrFjXuxENDtD3cOfZznmCd6BODekDyNN2sHyM=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqRTuF+wqCHtBjl7P+pNku92FShBXmKUOKJc/BE
 Rq91UpauHyJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCakU7hQAKCRDdI6zXfz6z
 oVsRD/9Lu0d/mH9amkHL1bT4wtGLxaWbO0BXEuEJlCKoQj6WgB53dHFEmpkZnFGdAFGWalJcHAl
 lDGfP7r3CexIdmXNF33PjJCYZxsNw2mWMX5KwZWGfRSw/fxUQ2mQqo9sxkwvI7/f7GuCQa3yE4E
 lUJgDfRJeqXLCPKHjD05sc2lvcx3P10FKeQoRUZCHwODIA2FVjwiGSdObMQ09OkKMPAFY+wGtrN
 WpH4UWUdwUM3ppw89khez3D9sdmQT7cptx+6D70C42Okc3XMhY42eNHkhfMjJ1ppjag9sWuQ/k1
 ZiQBIsrL6rYJ7oobxibfPNWfhDqFUc0gg+ljdFkL8vY/ktkkXRddpHPTIR+fKfGDaZH5PTF5FtS
 VXeQYa0Gdb3EBNpC9jQrnaE8vFSb3o7Emh2VxQgvIHDtxnsOp2Rz41kAd32/nwwU6msVOJcMxZb
 Abs5M2i0Ucs993gi8+Q6f0XLRgrzgDkVafgKOpt+oEG0vqApZn9lJ+GRLMcS83xtW4C3Hekwndq
 ceQi9dUsW+79FdTdKnoJ+8dlAv2JiHPc9CKABXKvN7stLbJXWZ865CPMkJlURRaRvzCN0HSiUAY
 4sZSHfnY5XjOq/f9OohstHiENl1z0Z/7xIvq3bObJWGdKJquNyyEoMsLSgdlsd+Kji8+fERs9c/
 BJ1kujm/cPoxkbA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Stat-Signature: ymp8c57m8ns9npqpdsbba3c9aeac38s6
X-Rspamd-Queue-Id: 41F8E14000F
X-Rspamd-Server: rspam06
X-HE-Tag: 1782922125-622125
X-HE-Meta: U2FsdGVkX1/U5sFjE/a2WzE804cBgsRANciN5zBgjjV2fh7JB+N4QIroQCf33KebP1VVzT9ho3xds8ZidlWjNxN172b09ydwbxQy3g6aBZKbg/xyA6MnTxabaDofNTbKwk2Sxko+dRmxub3Ma4Pgb1h5WuwS/WrkuCLnUj6swvkoSK+0+i35Rsyv1fXX2aX0IBKP6I5bXFkZ92aapaFR2SsJGG3P5V+G5LSpDo2S2UBkkkUM+OMmoZFr3LmpfM6RzWDHqqpbsWV2OLmzDO+/2vul3NFI0rroEdp3Cmf6ZLB9gsTc391yGvV4vWxw4Uh3m8uuWsRAvvsk1lrABGNtl9p5na14yDqRqd3zFHJ7AEszi2OXJIQGJ+aeCuyDE1a3Wjtu1Ri6qT3FE9c0a2qpLggsKV45l4FeJ1JiV/Jxp02GxydKDbR4fP8t7P6WWMJv9DI7JvNVq5e3bYY9GMpL/2g9H17UYNi8Hkddv7kPq2GRkZ0ZERKh2tf5LL1DuQI127auuhCNqX3fVB1zSp56fyz5h4PuDo/2hFd4QHoPAsibIwMCrchRg6k+T3mRBvW3/1I3KcZIok3W5iC4MmCNFDxlobr4saPGVYxuZUa++DMVJsCg2WKLgWNBD3/6mjU01Ss3JYW1r2M6UETshkFpDWZEBvTDwVcKpdJAT9m8cDOEUJpd1bmPvBHlmGBKR9VIRrFmakVA/3hyNCgiJych2NP1MK/y4ZR4nRiN/S511AiVv+tznarVWQoFNQf5gn7QLtgP7Ue2usPnm7tXaRap+ps6Hwv/bo+iB6dlRohpgQm95kR2Hh18xRYOhg+Um8R5YrCCc2ZP4HjbKmBTUifwVVv8OEe8D861qbXSYFTu7Nh2912DZUoHibhUZ15WyqSPEk5w0rc46dxlnol3Nn/U97Pd1Bry+pqPo8n006QH4EIrawtkea3mBUlPrjom/udsbDqDSn3oSqHr9AT4wNl
 m9wYeECK
 CzfDbjWSV/3B1pNgwTTtGaciXAb9flK1QDgCOCygocZdYxZhaRzj3hB2C5UHHEYNtNw+P1G1eYWPGRz5DashyAtx/H9Wn4Qexcz/t6k6fMC3RngK9pVywSPI7ZrWVG+rRHht4L2U4HF+JsGwL8gJaMsEEvaFgUneuaaYX2X9HY+72pXez8Ckv2VLGnozJ6fLD7SE/K2pqLufxW6rZ5rxK6V+N1lCxH25iAmNPotLPH+zL7An6M5y4FKUvUQ1mM/XAY1wUn8693sufNEtnMMBDf++CzxPRuuctqIdn5zC0y7+Wp9QiHHH2Cz7uKOh02iJWObBc5TICKSfJhM2W6mi1Q/q62LoxWtgvH2P3to0Q+1+wcXaH5NpdgIbeMXbgyZQnURZizsGXhyMujuHJSZi/CDnmLoHVM1yPrjKD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The Video Protection Region (VPR) found on NVIDIA Tegra chips is a
region of memory that is protected from CPU accesses. It is used to
decode and play back DRM protected content.

It is a standard reserved memory region that can exist in two forms:
static VPR where the base address and size are fixed (uses the "reg"
property to describe the memory) and a resizable VPR where only the
size is known upfront and the OS can allocate it wherever it can be
accomodated.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v2:
- add examples for fixed and resizable VPR
---
 .../nvidia,tegra-video-protection-region.yaml      | 76 ++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
new file mode 100644
index 000000000000..1c524bae9ce3
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
@@ -0,0 +1,76 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVIDIA Tegra Video Protection Region (VPR)
+
+maintainers:
+  - Thierry Reding <thierry.reding@gmail.com>
+  - Jon Hunter <jonathanh@nvidia.com>
+
+description: |
+  NVIDIA Tegra chips have long supported a mechanism to protect a single,
+  contiguous memory region from non-secure memory accesses. Typically this
+  region is used for decoding and playback of DRM protected content. Various
+  devices, such as the display controller and multimedia engines (video
+  decoder) can access this region in a secure way. Access from the CPU is
+  generally forbidden.
+
+  Two variants exist for VPR: one is fixed in both the base address and size,
+  while the other is resizable. Fixed VPR can be described by just a "reg"
+  property specifying the base address and size, whereas the resizable VPR
+  is defined by a size/alignment pair of properties. For resizable VPR the
+  memory is reusable by the rest of the system when it's unused for VPR and
+  therefore the "reusable" property must be specified along with it. For a
+  fixed VPR, the memory is permanently protected, and therefore it's not
+  reusable and must also be marked as "no-map" to prevent any (including
+  speculative) accesses to it.
+
+allOf:
+  - $ref: reserved-memory.yaml
+
+properties:
+  compatible:
+    const: nvidia,tegra-video-protection-region
+
+dependencies:
+  size: [alignment, reusable]
+  alignment: [size, reusable]
+  reusable: [alignment, size]
+
+  reg: [no-map]
+  no-map: [reg]
+
+unevaluatedProperties: false
+
+oneOf:
+  - required:
+      - compatible
+      - reg
+
+  - required:
+      - compatible
+      - size
+
+examples:
+  - |
+    /* resizable VPR */
+    protected {
+      compatible = "nvidia,tegra-video-protection-region";
+
+      size = <0x0 0x70000000>;
+      alignment = <0x0 0x100000>;
+      reusable;
+    };
+
+  - |
+    /* fixed VPR */
+    protected@2a8000000 {
+      compatible = "nvidia,tegra-video-protection-region";
+
+      /* fixed VPR */
+      reg = <0x2 0xa8000000 0x0 0x70000000>;
+      no-map;
+    };

-- 
2.54.0


