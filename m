Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E502C5CFCF
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA206B06D1; Fri, 14 Aug 2026 11:29:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0734F6B06D3; Fri, 14 Aug 2026 11:29:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECB886B06D4; Fri, 14 Aug 2026 11:29:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B6DF76B06D1
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:29:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4E55C160173
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:40 +0000 (UTC)
X-FDA: 85100259720.04.0F6BE0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 81412180003
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:38 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQYinDf8;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721378;
	b=cKNG2k1cXYyI/j/YCgeGVnV5lFv25c6vFiQuGhbriFqNLwDvIDeGc2WkoK6EyjTtBQPq1g
	fpKtUaRjsxyf7je0s/h2t/upBrDu0Yi/Z3aOXLAjuZXgKe/1h3fnqJ55UUl7qzzmNJ82JB
	07t9wtiFNNt+pe1TxWOuDabEoUSnvGE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SQYinDf8;
	spf=pass (imf24.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBlEuAoqOked/LKJu9mRAOEywcTF2CIu7f/dTPjyTCg=;
	b=8cAGUZHkBwZpW8sn5+btU/Yl88bzX/RrTz0GG+z4TPHbZ89NjeQ/Y4sOPtxWlME/Nvxf0W
	7URu7BrVtRss+mgUwXAhNPYK71wiR3JgpYrPDkI3D7jhepT2uyg0d63CRFXeHxsy4hn1Lo
	8PTPiRlcowclhOWrOLcrv5tuhcyuh5k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE9094002F;
	Fri, 14 Aug 2026 15:29:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026D31F00A3A;
	Fri, 14 Aug 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721377;
	bh=eBlEuAoqOked/LKJu9mRAOEywcTF2CIu7f/dTPjyTCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SQYinDf84Qyd8J39yvDDkE+2yMa0qkyakiGRRmXf/fx0fg4kEyB3/sFc3snNGwS4a
	 gZYSriilhL0IMm0YA0eTk+Fr6+tib5AjGC+psqwuOr58cPmjYAIuQzHxP0Ge6jse5c
	 SYvbKj5F6GHpZyOthwjNwOz8ZbWANjEirhoY4Es1XYu7sKTCZsKE/pVkWklj/YJyCn
	 1Kxbk35QjJ2mW8iRQFaDdfUyLz4khPYq4BpXf8zT3m4sYZxyiEfY2ONGzN2rFEwQDd
	 9zml7Ja1+KceKUU1i9huNizcSLqzefA6V4HsIplKC9KeQgA7MEOtO96w4DwQS+9MES
	 DZXezd2+lIsYw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:10 +0200
Subject: [PATCH v5 02/10] dt-bindings: display: tegra: Document memory
 regions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-2-71832b5d0246@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3649; i=treding@nvidia.com;
 h=from:subject:message-id; bh=pBYGfO+OoRCfoGlySA1v5aSrpzUlJ6EhDp5j2u2Nips=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRXaRTeDiDu4YBKZoD7GNeMdeApLEEF/47+P
 Qs7Dg4EFyCJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80VwAKCRDdI6zXfz6z
 oUKBEACxEJAOL5zdS5PgXCqYYzzNGiLLXVhgFzk9U1eqr3vc0dKYuq2vq77WgkFBI5rq7KrvFNH
 9h3HArdCO4FtE5FqV3SMFXSGQgi45SAZ/XdBjP1goIG38+OdMbFWNyaOl9YPEvNDN1Yn7P9Xjvg
 VrX6hTODGnRwC3W6pjviCz9yboRmRInlgIzCKkXCwYKMoH0Jru+o0ghVJ+EEuVUjG+92JbtTYRf
 ISKuI3IJKNrZBVSEG7TmHBxpAbWMvPLrFyPR5GV1L8sQL/eR3VjObNlgyJ6fCXo66ArRvJXUoIn
 5JE4la8W3ApL+k4SCDAA9iSSdm5qpPhWD+xbbh5q57FsGCQliDaDBGt3j0iwRWrh5vboKT8Vy2L
 iCnF1QDKpvsQgkZKor/kBAT0A+cS9EEvqyaPiVfnPr9MV4DM7rZLblI8afcRz+AlbF+SPprte76
 InWAWIl0Y+51c4Sy6SDRSNjQfRxRTmP5DjmykikMD6ItCdY2igse1frokTOU9npaT0QZcLbuRiy
 qEu5R3XiC+4VApabAOIRvpF2wKDaaBhtaUZuXb9C8A6fslgF/VvQUMsiI9R2P7+w3B5kxhUYgpa
 rqyzS0AgP0wdt22bH0ObJuoXXTtOjm/ualj5F/PXaPsdAmBCavu2SzT89QueATL3Xdx8JV9IzeN
 l2c2CdbqjX3XlyQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Queue-Id: 81412180003
X-Rspam-User: 
X-Stat-Signature: okf4qnhtucjxwo6xrgspx9ux5xehixeg
X-Rspamd-Server: rspam06
X-HE-Tag: 1786721378-827986
X-HE-Meta: U2FsdGVkX185S76dOKVrEgLy1D94WsaPI7e3B2Aix+FxfS3UkJFFUwuWVaClj+/vop85sZ8rMDL1lPzd6R3lzVhT+AJ+yehJiSX4Lxu5NMm2P4q6Sq3Sajr/J2iGppkFjZqMk3k+28kRevYjS/q8gSNwchtlJuJw+yfBjoc/jzCeIq9WBO+psUR45ldgEPw8uCy/qiUYxblH+dVxM8vjHuSdY1aXdrf72bcG73Tywz+xWP/faeaCga8++7XJEMUFSuJJ32tStAsKu64iNCQcVUgFqokL8/vXAkgBCM5xAw7ZFQLgdcy0YLFVYSZ01td/VDAW+Zd23iDYzDHvg+vzOcXVs4WqRW6xiE0apX84Tp9CuBAbM/q6uxn37C8PdMx+bERBg0skKpZJV2gmu1xBo3z38xuKqzaySyXqpcstIegzcoW+eNx5pNGm+9ZuEtDmjIvG04ruevQzkP1Wbn2Up4VaSC4jPhRqERG/XCsQg11a1n9GCabIgh66Zr9cFKwsrarBc3Meid+mDE1GyiWTma6Hq7IFIt5GNTcSkEbyVRbiCyRSPsA2qfTW/Y+9HZA+AD2kR2fG3EUneXwHs9Bd9dIbe6LxDKtiTuvmpNPaWxH4Pr6djNF6oj5xO5vRtl8mJ6ord+olpLnknOYLCOX3Sxfc0m6ocfxMuqM9BMgfMP+jE2mba7mE/VDfKQ1+fO2dpWCGTwjTUDNaRTcDjurD1Whe9+belrkWQqCOJ95zPxah5HNaWuMqw5/blOe/cfBNkoVdO6Y+r/KSbO7kjKk2XadHoyXqwOIspIrdbKvVpmdag8xy6GySVRzoRLxycuF+Ezy8JKRB6KDE2qhLMhzCzi+lyNAwG16aLfX6iLDtbhEuNUv2VUfbxePgx8+HB09BrfgxolyLwMpy6o8TwPq6mskvJPglN5cHCCBRhbdih3S/1XfZznuNah5fzWwvO2lxtJiS7T01gu8MewjmxC1
 ph/HI6RQ
 OCnMuL7HHNZ36qkTgX86/ehyIH2ti4I5IRY9XyNOxyWg21qwloXPEHqxIE0Z9jtn9kqr3E02rVbSc2PPwURnOIRz0sEgeqV15Qs8kf+uXSf6u5yXY/TT+sh3o1T1my7unta5wsPg50cUY/J52s9KjzB33MrFaTCg1oBRFcwr9vhtUwlNCrtIRxxlWVk1AdtQDsbCJNjXCK3zF6Zbkrjl0+uY/cZJmd8Rf4PjVlg56rW+TM1pVR/1lkYNEQ46J49i6UPVoAHU837gJB3yPsgBIsYFoBl/rsV0aFBwCC2UeoxGZ+zk7GaQ1grLc3z0nEId8IKUFgh8LWekvfhPO1Q5x1N3zcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

Add the memory-region and memory-region-names properties to the bindings
for the display controllers and the host1x engine found on various Tegra
generations. These memory regions are used to access firmware-provided
framebuffer memory as well as the video protection region.

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v4:
- typofix

Changes in v3:
- document properties for VIC
---
 .../devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml |  8 ++++++++
 .../devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml  | 10 ++++++++++
 .../devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml   | 10 +++++++++-
 .../bindings/display/tegra/nvidia,tegra20-host1x.yaml          |  7 +++++++
 4 files changed, 34 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml
index bdf981781bd5..fdd3fe9e2547 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml
@@ -68,6 +68,14 @@ properties:
       - const: dma-mem # read
       - const: write
 
+  memory-region:
+    items:
+      - description: reference to the video protection memory region
+
+  memory-region-names:
+    items:
+      - const: protected
+
   dma-coherent: true
 
 additionalProperties: false
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
index ce4589466a18..881bfbf4764d 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml
@@ -57,6 +57,16 @@ properties:
       - const: dma-mem # read-0
       - const: read-1
 
+  memory-region:
+    minItems: 1
+    maxItems: 2
+
+  memory-region-names:
+    items:
+      enum: [ framebuffer, protected ]
+    minItems: 1
+    maxItems: 2
+
   nvidia,outputs:
     description: A list of phandles of outputs that this display
       controller can drive.
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
index 69be95afd562..3bf06dcd6198 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml
@@ -65,7 +65,15 @@ properties:
     items:
       - description: phandle to the core power domain
 
-  memory-region: true
+  memory-region:
+    minItems: 1
+    maxItems: 2
+
+  memory-region-names:
+    items:
+      enum: [ framebuffer, protected ]
+    minItems: 1
+    maxItems: 2
 
   nvidia,head:
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
index 8312b7699cbe..420a1fe5ee80 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
@@ -98,6 +98,13 @@ properties:
     items:
       - description: phandle to the HEG or core power domain
 
+  memory-region:
+    maxItems: 1
+
+  memory-region-names:
+    items:
+      - const: protected
+
 required:
   - compatible
   - interrupts

-- 
2.55.0


