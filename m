Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81F4C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09006B0092; Fri,  7 Aug 2026 11:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1276B0093; Fri,  7 Aug 2026 11:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8CE6B0095; Fri,  7 Aug 2026 11:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 613FF6B0092
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:54:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB8E2A1545
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:55 +0000 (UTC)
X-FDA: 85074921750.27.7C5A747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 116B32000E
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L9/vaU28";
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118094;
	b=gT5Q5S03aV+yd8eUPyl6i7FjdtBULYJRSYf5psYTI5wrQM2/bYKAb0FKvfwZDHFZmwnaEt
	KCT/Zq5F1Yv9wHsNawY2DhHHAn83WRvgJmBU+shZG+nxtjOf1P1kPL78MEN7/jz97VrzxJ
	0Wyz8DVfUPGU7I/5+pAWf2X8GTVZCLw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L9/vaU28";
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykeOEQlLlU5byclmJBGc372vDaHoHNudhBcZEUEFoRg=;
	b=SSwyWwy+C5GpAbKN/aK+EeR0pJu19y4SoxYN+z6uTZpE4e5Rb/AtGai/YKSzEB2pdPUjBe
	DqlNq2DAy3L9QiCAlUxm/Uw0KV2NawBNaac0MIsr4dRMH08r238GXvtJ0Kay2skaJMVerp
	toYEYlJAxo8jVOs5sV0i79bwl9M3hqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6726561383;
	Fri,  7 Aug 2026 15:54:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6464B1F000E9;
	Fri,  7 Aug 2026 15:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118093;
	bh=ykeOEQlLlU5byclmJBGc372vDaHoHNudhBcZEUEFoRg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=L9/vaU28UNv62SnECYD569FN/8Q/JU7ZwIh3KP7rhV/KnVlXC3jQMLzxY6+pIpys4
	 P8fsKooUoOhflZ+QtAR0Q3i9IjTv0xTdVH7wMnHohP+NjAKa/cW4BzES1jXLTr20/O
	 Wizfo6cB42UxSd+mbtHo+Kb07P7jSApXI77uFFc1K5oUjz3iP04pnMy73/diUuaSIe
	 Kj1YNZd+ZAPyJ+KF8HkkjMT5YaUvLTDL658lod6mujAT7oKRUrTO09gOcd071GMrLo
	 +uQ1LRp4/c3pLX9n8A2QfPKqIUZPNEapWJmqypquLsIeFEXBf2A/p56UvlF7JGnDiw
	 wlj2eV37R23vw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:21 +0200
Subject: [PATCH v4 01/10] dt-bindings: reserved-memory: Document Tegra VPR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-1-5510d16af89e@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3632; i=treding@nvidia.com;
 h=from:subject:message-id; bh=jo2vnekdZsouYUQf+QH67E3qqmxhXj9IA93KgM9Y+BM=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/FNHgyQa15FevY1/thrxD0sB9vo4bnOIRT8
 tp/CjNUXkKJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xQAKCRDdI6zXfz6z
 oaq/D/0eCojgoB3KJavlR6xgbEUetRljxwEn+8PW//EIz+hJVhhvezJ6kJu/yS2njhI6JLTnskl
 +ukeJ4O1Imw3Wd4xMY+3+44ReNFBaiapc2Q+Aeq4QkJSS5qaoEikCq/so8K5hUmK61JbIFJZkNT
 OckYBwMIuKziiVatVEIIeKTcuxNwA11rt1ErtYxgeafbmnUKc61x1uI0csmPxCpNYcXA9+p9Gvj
 ck3a0bKdwaaPtVN+vCfpg+iMvOG9LazfYuwcIIQyrWsnsRCHV2NJxyLfgdam1S4TLWTjmLf/ZJ4
 ctTNHn5y63okLyCPhlNWoRXhifKPzmVg/G+lHXnTuZIEMaiW2H6NyABda1PgrTjegT8U9gQXMgn
 Z2L6p/VBKIzakTuvzMEqpSbwHcLHz6qUcXzcZ+o+UjGooECbmUUPtKl7QoYTlxJki559rAwCSIW
 ykU/R7yhnasDijco7sB2WWNZ/EbtSfZpcQkUMnPBGSrZqOElwqA+wI6BgEuQ65/Mm1y8v3i5gZS
 MHVB1mafczj3DYdFViJkl9sizdKHGs/pqdEAue9zPcDlE4pXBL4LRWwGLRRGR/kDfFDUmN7F+ss
 v50LxtjiThULT5XhW3Fs67stkNOr/rar4iiLFpjCsZkS28nMKvgAjZ+DeLHuC2IC7vaWwNTiiEX
 1c3+W/HsKGw5IMg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 116B32000E
X-Stat-Signature: weyfs71ohu9ist6uxkezk1qmtx8qwcqz
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786118093-57724
X-HE-Meta: U2FsdGVkX19flOJeM71p0vBhQwZ5b0wd6FCeM8BnWxNHOTEepCKKiVlE8B1wn0judyiwaDLLWAmj6MxIX/7hBoTWAmm++rv67NvABLddkK19b9/A3P4kWiKTVzGKlgkpYqoY7whMM+IUAacypIJ+5CZdlsq8a/hI5IdHyoI8OOKnXDu1Gh5OCT3utuT7l+GfhV/qdVAM6+1fx1DQq6/+BN1lbrmypdLqtIXr32Zu0cVwTgmIRXkwZW1m+qsNhuqOHe4sCJ43CPw6/tiGz3L3NheQgcXy7Yv/2VQfjhh6lVSerTPows4kEk6shVNyZZQvKw32lQeaa7wLCcIEIOXmMDz4sYZuEFpx2BzRN09+zr+iQtBZJnlCmiRogiaCX67hyzj5cleCimFo67vs8XfKLj3uRJw9tnbZJKNOkYaw4Y1BUfYUB+bbV89z8AW9zxlXcwtNwqGVIpQT3vRQg8VPWeZyhlHk3OJUQ/hiEL2tKJgkzCAr13UsF/VSfQRGBEhZ1Ki3B9Cknw9JjWZpverBZsqvYiF4LPE37wY55sk0IFxLUahiwBzv1Mjla1J+JrOMwmvLoQdf/PhTvlAy2/I964mCIUX7Oiov7eBV06VbiBzxPMZugSBtl0hQy7lygZosw9pPjeUFN5iaApv9WcNEXwZDi44dpXyD3nhaMDpYwVq6sy54c8qJOtNaowdwFJUJ5TkYc5WMOoqjkJsMo+oxzLonicBf+KPAhxx8CbxClNg5txRmo3AdHbOZqYIgVz+au4qfclEZGSXVYSjPwNfGO5k81WNA2vkUP/xV/hcootb3P/BJNmWGJOEvUfztMaLsH2lHyzYDhX/GYggjP3mEPXtV9mY3hxzaOLvqFOGHm4N8aOJQkfjKJ2aZEVP43XPAMWQcDE6ldfv3i5QFMtFH0PpJ++q1PFX5KZ0R2xd/4G28b7SvyEt9Gfs0yIX9KqIrOC1pgbWbKJJEDR8ifvV
 VgwCRxcp
 3tXHSdOc/7IjZL/zrj9b3auMfuT6nHJqwz8lQLoRN0uJDW8QSyH2ED6gPLDp5oXFIBho9cqEGyye1or9r7sIw0SlT5R2amt6IvRAPEGwhl3Yno34RvH4yg/WSvAnnYjoeTmUAqW86dGgz7k1IhHx2YnJwlMCJ5aCxbh8yJ3Waka/ro0K60MhCOwoUaLe0uD+qT3qBYaz+waw5VmxrtcXWKp6e7aZ91DUCB+VOOe2Vi7srGlTb50gCvmQNvaVTqkvGhbMQKR8Is00MftuqiEKXQsp2Vv4w5bIBm0a+iFT2xVCIMZ+9al+GINTJhmuPlbNGCiAdLWcwoxIyIyKk4Lo1T0MRMtNC1TdhAUpdRotCGqoEUfkXhURbw9fa2o/t1c7iCXv5hov/gq+0XiPL/GRns2QE82OeDuoVbk54
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
Changes in v4:
- move oneOf into allOf for a bit more tidiness
- fix example "reg" property

Changes in v3:
- add examples for fixed and resizable VPR
---
 .../nvidia,tegra-video-protection-region.yaml      | 75 ++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
new file mode 100644
index 000000000000..862bfd391378
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
@@ -0,0 +1,75 @@
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
+  - oneOf:
+      - required:
+          - compatible
+          - reg
+
+      - required:
+          - compatible
+          - size
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
+    protected@a8000000 {
+      compatible = "nvidia,tegra-video-protection-region";
+
+      /* fixed VPR */
+      reg = <0xa8000000 0x70000000>;
+      no-map;
+    };

-- 
2.54.0


