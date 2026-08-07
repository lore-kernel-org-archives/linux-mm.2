Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AFF2C5AC82
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27DB86B0095; Fri,  7 Aug 2026 11:54:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255476B0096; Fri,  7 Aug 2026 11:54:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BDD6B0098; Fri,  7 Aug 2026 11:54:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D69576B0095
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:54:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 63A3F40416
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:58 +0000 (UTC)
X-FDA: 85074921876.02.0D5D5F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 96726140012
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:56 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUEFBcDW;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wDjxUjdvFqDKE7ihsNogWEq3nkXdKHutOxMVaNR4wo=;
	b=ddyHc/ArDu0QEljhMHXlTRiSWx46jallPx4aN8ZncdBFEhg+B8YndnYDXJFoEtTN8XY3/G
	wQGAZGofeth3oxVFlTcYcq5M0l4fqwv6MQvTSicFrRCEHFFhLN+RX0VEGFDoCXQQ1j1FFM
	PaseAqIfmmCYEQqB0JTCCb2XMZ8ddiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118096;
	b=w9RW6qbbj8l2fG02rSjRQB7Ev+hoPKNcmuHuOYsNRlKn/DMmhFkYhx97SwAdx3gS8t8FUP
	Tm91W1neQb3SvUHnfaQyM41pKykn8/1zdpKtzBfN0UoC3fo7QjdAy4iZ7LjSoB1cnY4yvr
	3J3prbGijyvUOqKGZezN7hWHPtnVdbk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lUEFBcDW;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33C8D6136E;
	Fri,  7 Aug 2026 15:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316B81F00A3D;
	Fri,  7 Aug 2026 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118095;
	bh=6wDjxUjdvFqDKE7ihsNogWEq3nkXdKHutOxMVaNR4wo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lUEFBcDWqEtThoK6tc3nxddKzJe1BgQodn0goRpTcmjY0lcM22DQBkMWkv4gLSyq4
	 mtMnd72OftgpI7xVHzSOu9/2X+AKglVA3ebalGrTzmM2eTyXqXYJoJbN1IJ1IjA1Mt
	 9SxqOY1pkYYD4pWvRCReDTOvurB0QhS81JdiRrE51VTq+MyQODh5oJ1IaUcChqbYTr
	 vh3mUYwlBRtPtpU+tL2lBj3f5k1MHKLjLB2Hf8r4q5NuKyrDwFvichDPdIc8pkzlkq
	 v//itfaZ69ELcWZa5fkwYyTKzApzDLXrHhaM2wXnfa3WZHDUqWi5pfAZM9V/bIqdec
	 RUTuFuUEpyYfQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:22 +0200
Subject: [PATCH v4 02/10] dt-bindings: display: tegra: Document memory
 regions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-2-5510d16af89e@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3599; i=treding@nvidia.com;
 h=from:subject:message-id; bh=OEbbK13gPXvWULmBiveQ1tyvB4IMXtbDFRxjKTDEMPs=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/G3HrHADPh/Ggndr9/FKGgb6VqppJr/NF9L
 +/yWDD6NkuJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xgAKCRDdI6zXfz6z
 oYXfD/9Fc1X90Pg5FyqxkYpZ7BOZ2ex2bRQheV4r3UOvlCp0A3WBc5aUjgqIsDyYehKISoSRfSC
 MDaOdZ8pBxT2BSdBfkArlaMQTMLJ/H567FU74PNLwiarZOfqV901vdBRWFRcONvfoWEPALAHUD7
 fpa/p5r1MeLxONleVuq1YFijGYDCC0M3l2WEdAWUsY/9E6PTPaiNwICkoxhY7tKAh9j5mDEgTk3
 s4KWx8BNKdWwrqlLuZ4uKQSqp68NysM1LkYSdtPCVVX1lPkqPATpZ1C9X6JmOzu2MiLr+w8CGqM
 2O5JxmI51KzP+dmKyHeuIZMkkLaSbOyGa3xqGd7mCO2XvlhoxWewWCe9AI3tFDrjHVe8+t522ig
 5h7jCZlBVszKpLcI//08B37OFdg9fe+TqhWuSb0FZ930UUWv3rlpWWCWLnj3R1jMM6lOqKsJeYJ
 rnP96XEPSLMSJSgWiovbqx8LF1B54UaH1E/K2OSrsJSR/YgLAbeW7w+Wb2ruJHSJvuz6OqGDXBm
 kTYkvP8vb9494/B3hQRJ1GuYEjAbpGy3YPt/tHDabflvZyUSRws+X/J7b87upvpUMutwwWiPRa5
 7qsp2Vdz19nC+0hqoC4HAgHOIS3F3Drl+t1oTGkLadJhjxB8ZboE43Nci/rwf6PQhph/mjvFNYl
 Tgq5MAtxJ26oLnQ==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: jbdtny4ymhhzjzh97pmatacamdrea7q9
X-Rspamd-Queue-Id: 96726140012
X-HE-Tag: 1786118096-919363
X-HE-Meta: U2FsdGVkX1+yQzGBIBmo5HJlfFXISWiOnct50ME0tbFa7sVLLZGi+/KMcEeTFtxOo7aGY7uJ5NwjjF9XPwaeqU5ultreGqss7iaeqIGeaVmD2x4iP5ts1UgxnSZiTGIpjTJh/UzV1IjCafweQnx/yBcxWzccM25f/6l52t5IWVQZrbJve3KqTYuhWq2V5JX7V68HJD/7VICtkIecCb6oLWUyL06n+4DAkRd3Gzrg25mDZ/Nbja09/rnF5fxmGeosT2RcZA5YB3af3fYWuVDp8Am7svKNGRnVR+dF6KAh2aqxbgOBvmD1I/ogc4qHuZXRKfqKDJqT4eGKGxpZ5QO4n9S/oMPaMyWEkKZyJaJIaWpyUO3Q9eyS0aGMXFuIft+wkBRBz5RQmjbjXKKDEoDhjlZX1wBgCjppPhmlzJ+ExxRNEb7RCdMO6Yo/0Wv9HkW/jRDNtuI92RHoaET2kp+hfuT5GoHN0uPFyxIBNdrnvqq0bdYdc4xJPAzS72eAccaF5W1aDkC02uyCZ0Y3Hv/T/eDxgc9c/Lt7wfzKGdaI8YYxh46M/wysobQMPN8mozboTa2XE2mxYD6ZnapBsywMtfXyEdJPRtw756ZvvjCbJ40xsCr4R493dEitfeIwmOnb62jMhG/UWAGsu/IBLPFsqWhS0tQNMiaW5KrlHjk+TnueYQ/ZzrrVklxi+O0gUA0z80pn6fhlBD0ZL5JFlHFVHvxd7/8hqF8vZ0kuxuzd5P5lqRSfDcT6LxUGn18ZsRkwCurbSILbqlLxIAcj3tjNqeaVsZ6AINzKVMP2jBu86oNAHZ97Hk4jRZq9ePwxq78ULR6joVo6ZcjgoTagJ1BIRokWMe8Jx2xUCwvGqehTQ9Bqtb9LlFwG3f3j9Tj6qfy7lQSGXN0U0ts0gVKyAOhavQ76YoRy39LVlZuGGLMSzJ7oKPuf4fxItb3fLKtxNWXb4BMq26kv2cfXEIvnx8E
 3lUNTCaP
 7rNL0jt+j9eRJAZocCYPLDJuJXPrWBl4w1F2aMHDFp2oHtuxqeBZn1X3ja81ab3oBajcVhftVjQeqs49sUz7t/PGnS1sh8j7PjMDHDfARYlBvJq/NbjTfT+Xlz4gMA0dCIiMNh3QYEvaDDrVcwoXUMGaIlzAjVlqU2HGwlAjDrJe9UPHYt0TZwiErfV72oppm+FqlWidpdD8Ddfqqa0uBE1n7Tfa7MR7q8aoOibqZI48YLZtL+De0OAIrrdy70hMJ2trlIoUwHLjVXcYqXSe7ORMJzb5ZwM94MX/lXpSJ7U7lMuOSCsnN+gr9tw==
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
2.54.0


