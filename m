Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9213DD3EE8A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 034026B0286; Thu, 22 Jan 2026 11:10:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005A16B0288; Thu, 22 Jan 2026 11:10:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E52686B0289; Thu, 22 Jan 2026 11:10:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D26186B0286
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:10:24 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9B3B16044A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:24 +0000 (UTC)
X-FDA: 84360087168.15.859D067
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 007041C0015
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:10:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P643mR3S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769098223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vktLTCO4oVSPSGmW5h4KyJplbMaSYQdm7/DggjGaWc=;
	b=nGgRyGa4RKwaLABsQ4iBTIpn/hXGlBIq4WFGJGCtt0pjQuc7N9IJrgHpBkq1rA80AfQWXm
	p00Rb1fsJucUyq7xjo74+HcbLYmQ9GMlUj/5jW2tq+Cy5kPzWHoqDbW5JCh5eAi6/DGcUD
	4vmrWHTZhMOpmAEkudlJUD/ODRE2ujY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769098223; a=rsa-sha256;
	cv=none;
	b=r1tiHUIjoJ0hoHbDVYiAoOjvT7a+T02MP9td9wRJ0nwwD98RWKj7ZNiqZ9/nlY/8djFlAB
	Nu4XARlYSGMpQc4SINjtmXljYG4dvYIisjQP1CIei2M+1QKbHSyEqvsWfY6yKkfF3aDlTR
	iAOWFgDCxVQTYSoYBu6WKaj3QRLjt6Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P643mR3S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07FDF443A6;
	Thu, 22 Jan 2026 16:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B004C19422;
	Thu, 22 Jan 2026 16:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769098221;
	bh=2ICIoqHo9Cyhdy3+VtN+IUzW5+JGRQYoDcB2EFnohLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P643mR3S+IDJaAPZiWwUtAcaWx//W+DWn1viojKNZ1sAIk/4Gyaq3Esjn9VI+dNkq
	 aV34yMJuRdLhfDZBO4jW3OtAeULLLLKNvWDbFEcE/PuxaCU0U0ubuXbPZHVyizqdiB
	 SHo1uN2IPS/hDePMAk4HmZ3HRYzPbFUk2NlP3nHnrg7K7h1hyDChhNtPsaeadLRucn
	 SXDX1HxtDKyL4zKZOsfkHGkhx7Hir01tr6GE9ICYcRZ3DTSgVVrEUeLxP2YWBkIYe8
	 Ul/dOCC0pRWf590X3fPIE3awh+sXtefl6YU48cXLlMKOw4+pDnAiM7U/BV6tafZ34l
	 PWGKJHo2bEDHA==
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
Subject: [PATCH v2 02/10] dt-bindings: display: tegra: Document memory regions
Date: Thu, 22 Jan 2026 17:10:01 +0100
Message-ID: <20260122161009.3865888-3-thierry.reding@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 007041C0015
X-Stat-Signature: f9js9fx3sphahdst4xb4fy3egjcgyp3a
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769098222-394092
X-HE-Meta: U2FsdGVkX18ZOiog0yIVv3mWjrHLZqVI/3dA9oTZy21bVgdJmykp4FAXI7GPI3o5O7lChdqz/jwu441t9VeVqN2++APwnZHqq+tZb5W+YUsD3hMzlmv/AaVtQyWi5ejPXiqiP0L/gJQCh7Q0D/6uZidOfiMpXUSQydkErc/K9fx6NV060FqOGAZxz0RofXHh1S02Sosgily7LBbMWBeMAFNWy6l4JmJEtNE8o8Fdexq0jicUEn16Z7D/8M5t0VN6BkmgoRc3cmUO4xJdFJSlTRUtKIZSyRmjE9M9FS7UUvYzQMp487s2bTTZFyiq3lA+k53yScTmqGAarMzD0F1CRL+iGlafqWeWmnbWwWwEWm+vPXFBpozh+3tUwa6wR8sCryAv8eRifie0siC1ILor7ao4by9xosrpNdbrYvjKnpZgQDZEURJgRRjbJSv50qwJO6H08wF6m/6/U0IsNNEmQfpzz2uFNbe1a+owdurd2I02C7WiKs+zpe9OpAkcdoiFzms/DCBlBB3baxX/HaP1Rb5m/ZeCnCgGACiUEhg0oU8b8SMQQMuqutXYoWi6aKIgY90zzlbzmtyi+3s3snAbXrBRYS00MoGWdtpFwRyjNvsOkvwE7DjzliqLik441PBzHg9gRnSU0GxMuYKFqkzMG5EH4ivV9LW48UkgjpX5SYMYhhrNrBZa4l25Cng0sT9/VUqK6dV7cwkx6Ujw5AftUO7PGr5eRgAdGNU30PQl8H5+DYu4C0X9hRppJARjkpau4k5AFlHutltc8fEJLb+g8E0nr52dpZUeF0sH+k18DDso5JbsPpTcjBWYwc4HAKqMFcMl1sMzJUZO8J5IS1iJADrdc7cFE92F49vMqA9SpQAtSpMT4hj9Ti0iICGcT/qhYNZsFBS0PResRRXMX3bU7yoa+l43Gzl2sMq2I3CaY3i8g+OBZYCg/Vg4Dnh60MnnL+4e5ApWqY/adLerDiq
 vTR/dAZU
 QzpbRC4HKYhSReJ2NUzGIhpnijERTYqY06HuX31XIY9qN0FpaWUdNlJNUoC99fze63EtHQc/ifkyFUuk9JNzc2/uk3hIV7FbyQH0JCWCLYcKFpoNA3z5b1kk1VL+FDQtwNflkkOh68jU3mdT2CjQa96oNNFytJrGOWNIgmGkQcW29+zzNVE+m9aXE51SBxNoW2257By+Y4jm5yVtwgka6Gu4XKgd9S7W76l7y2MSy1jnSuSAIluFG/YzTV39BiWbAPGq1wJiUYv2gv+++zl9zhGNQ9Gq+CS/niKKaW6ep2jDLvXWtBznUKKw46Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 .../bindings/display/tegra/nvidia,tegra186-dc.yaml     | 10 ++++++++++
 .../bindings/display/tegra/nvidia,tegra20-dc.yaml      | 10 +++++++++-
 .../bindings/display/tegra/nvidia,tegra20-host1x.yaml  |  7 +++++++
 3 files changed, 26 insertions(+), 1 deletion(-)

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
index 69be95afd562..a012644eeb7d 100644
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
+    maxitems: 2
 
   nvidia,head:
     $ref: /schemas/types.yaml#/definitions/uint32
diff --git a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
index 3563378a01af..f45be30835a8 100644
--- a/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
+++ b/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-host1x.yaml
@@ -96,6 +96,13 @@ properties:
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
2.52.0


