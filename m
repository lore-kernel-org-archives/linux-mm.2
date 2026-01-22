Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FE2D3EE89
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0FD6B0282; Thu, 22 Jan 2026 11:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9F16B0286; Thu, 22 Jan 2026 11:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC706B0287; Thu, 22 Jan 2026 11:10:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 891076B0282
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:21 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63DA41A043F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:21 +0000 (UTC)
X-FDA: 84360087042.13.F7C7508
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id C415540006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qg+sVNEq;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z9vVViweHtq7wuscpdvJdRX/l0VDshcBuuhGULqjHGs=;
	b=PdIz5kkRDTM3PJ0CDWh1ukwO2xCDiQCHDiCH+MW+wocg/K6A5ijhzjM3AE4soRS4zGhpgQ
	5LgHy7dIVX+r8unbsf1D4tXMGOfABulpQTUpAN77O6kPkN8Igxef4ZM9qwHm94zSC6mfUr
	jRTWLPq1Hl9HPibfK9ghi4uic7Ix0BA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098219; a=rsa-sha256;
	cv=none;
	b=20glNrmb2KfWZCHy09nh/B9owIb7ido1c9URZMcmAgSFsuYS5SF3ApJ6Rv5N9cUoTeBp6l
	40sHp/kKzLrXGYEn8CAE8TkPS4Vxr6GwVm7ImkvLKTwvStj2yzQdaZk4uYwPASzZXS++zQ
	8bG9ULy46S7X5jRLRMMxQfcXSdERDj8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qg+sVNEq;
	spf=pass (imf04.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5024E600C3;
	Thu, 22 Jan 2026 16:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B674C116C6;
	Thu, 22 Jan 2026 16:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098219;
	bh=wprP5qSFccWPgCsBEyBcH1cv+pmmiGrAaswb0KExp1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qg+sVNEqkTWkKuBV8wwZkfUMtNnpz21o2pnCIbPK6JFd1GTpwksfgK5rI/SLZW7uu
	 8q5fKDiVr/3uxG0owtnmWMQGpzenZAz2DKxPSfWSU+8KRA/u40ZlO9UW/A+roJKS/U
	 ML7S7DE7XmZCQLTiGtartsWl3WrcJpxMnCm856DYR/ojhsaBNkLaoVRQwxKErrhkQd
	 nyVlO/WcBRdoZkYgQGpMIVtb4pWIcwDCGt5I7CcWth3/y5RSpDLypse6ZvrbY1WcKy
	 B1Azpbu28TqnrZw2ONDq3mqMk/EPIzQ9pmTYvawFdj0s+GCFjD/vo/MgbG/rju3yaH
	 knfsE2mphcFFA==
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
Subject: [PATCH v2 01/10] dt-bindings: reserved-memory: Document Tegra VPR
Date: Thu, 22 Jan 2026 17:10:00 +0100
Message-ID: <20260122161009.3865888-2-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C415540006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4uasgif8x9ctgwmx51359xhfhdz1gd8s
X-HE-Tag: 1769098219-115527
X-HE-Meta: U2FsdGVkX1+RItoLOPZD7whFPOvXb8jsAz0BjpBV69P9GOF9G6ZmIUCycu4/E79nZOzWwsyC0hxAytCaaqLk9ktrFRf3+aTmX93saTZZm39D2+9xT/wwNgF+7Txz+wKsRD8/MfCzqsSrMb1dHiZ4eqPcUJp8F6MSdG7fVM+M8umOfbLM4r2LYQi8s1LJpV/yeLD1sOoXY/so0t43LSrxiCCmh6xK3Li8CG0rgcl27yb5JJud2Bp7PTlPvBqWCxzZJdnQpjQtUF3t+Vyv+7kvdqtgK2L6IGyNYcj6UMRPY8VC4UWwfgW3kkLroNzVL5Z+uIrybtCsRUcjsfngYKXz9X9Om8Y7I6yVKAIv8B/pvK3r4nr8t63EhUjo3gQAlCTYNGwmckaCVRU/hQxbb2e54GDELJXiOZgRps++A+W2Wfllj5r2PazA6D1srxkLzMX1LQY2QP38lgaeprj7S3eMtfUnio9TuN87z+UGX/tjwCTGJW7b7Cyj48AfT0CeY/FJz3hOj885M9n78fu+uheGWtaNB/uNvHp55hMi7BE50B9JzDdIp8WU6II1+4M9GWWBx6riU/FJvfnIWTDibsvpXikNIdIRuNYXnH6kPlBXjU8oFdAJRqvetlfB3aNPTC/E1lLhPuNYbnKxKS9ZnN0yZqdaAQO0Qx6TxV+tl3gFHTa6Y9xgMguKNRWHooyZjNGM83zG7nf2piNPzAnWamnSzQk3iPOahFu9JEEkE8OgG38I2xV9bde2CSKNV31PgWN6o9PRiCACfwn6Dos4slW8SfhFQGwQChUZt6vdVUoSeZFprD/P0Vxb8IF/ty8+a8Dcj5TeAsX2MD2O/NUOuuLjJqJOSiPhpK0XUl8W+cGeonCAOYsd2JkxLOdeMPIYEgDB+urhQYIFGnXm+uyn8NJPjbXPCZBn2BGmYs8ciAp/0Nz72LPrfvNoWvPWIMunriX+DPQwUx7tnrbZ2ZPWFm9
 zCPhhxtS
 OD+IBmPI4NH8SF3YWjW2bEQBnOwYJhfNkQytstTHSXMq+soYSIvOcmeS/cnWQhsBZYLRal6SmtVrnt7OCZKVojURKM9lQnjxNWKACrjdgFNbjNr+qsEbV02xooFcn8iKk0stxCjC1cZ+9zf1pHkrzZXuz0dbyppvdQllLrJueLII7BIzO0sK7fa0k4BE8o+oTBzF3b5eOGcROfH1+PSXs/B97hC5UOSbsLP5e5P9sKWvnLfM2HRgWMj1eGsbxac2fj5lQv3L+oIvLGCDWqThhapBuF5MfdVADJ9t76bF2x0aVqFbcXH3Ar0DR/IEM24kYfUEPDIZaVnLAzcL6B/XQkv+nAljsR9iXi/7D5Uk+SuZbn7ubJfNW+ehImW5OMPPu04NW5H3hrQZgi+GeKe5SN7YcnFsc5xMw616s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 .../nvidia,tegra-video-protection-region.yaml | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml

diff --git a/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
new file mode 100644
index 000000000000..c13292a791bb
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
@@ -0,0 +1,55 @@
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
-- 
2.52.0


