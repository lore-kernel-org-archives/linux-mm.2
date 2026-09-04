Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE11C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6A0E6B0096; Fri,  4 Sep 2026 06:45:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C411A6B0098; Fri,  4 Sep 2026 06:45:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31016B0099; Fri,  4 Sep 2026 06:45:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7960C6B0096
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D5DC3A4EEF
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:26 +0000 (UTC)
X-FDA: 85175748252.20.C4C54C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 237D620002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7qjQCNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eBlEuAoqOked/LKJu9mRAOEywcTF2CIu7f/dTPjyTCg=;
	b=onNLhVmrTe9sha6vAQ1ngGeTvMOgRTTzbEeAbz+mgc9kM7fBIhKVYHk9FQ/Mxtd1wGRZi4
	fN66L+UZTZ61L4qYkr7DM/MBg0ZLGGmMB01NbUtKzoPJy8A1iRTOORrHVByJC+B4DvRSyJ
	L8CU5oSbv/qbuGwM95a5LYWiFbVQ+Hk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7qjQCNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518725;
	b=VQrPMlptlVRRYvpCGgnxdyWlUfCkabRiHZ3lQeF4BgIr9EPn7d+udnTLGrM3QO8rjafjfB
	vVgIBsYTsFiDsD9mQg5MfMBcEYXEwpzy4Zy2oprS41jNmkG9sh4r05OYeSKd2ilyEc2gNv
	S62WV7h4q7xNh8N7NJ9fz2u7xHMstcE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A4E860A7A;
	Fri,  4 Sep 2026 10:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5888C1F00A3F;
	Fri,  4 Sep 2026 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518724;
	bh=eBlEuAoqOked/LKJu9mRAOEywcTF2CIu7f/dTPjyTCg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W7qjQCNSCGZXXbyc8J6OTl+dQX2qqTPLVjOZKbya9DaDtLYXNDq7yOSjCiH1Fzmgo
	 j56j7wBwCKgUFodXzPAzL44OFOVSiFiFB0CvB/ZPoNY++4LLfUpv/1blCs5hrACui9
	 7s3xQ8px/dRmqO1WqB7SNO1OwaM8sT6TH0S7lQdEJ5iufiYOMh563huoUusBqCgBCB
	 zhHSeRVxDESEqeAASr3hnpXE5pStPPx3KVcFlwkWCZcMWP/CilLTYfN9qTVoErlRHl
	 4e5cB+aYiwobAfiBrDJkRzORM9Qlzq/j4AcH/+K0EYc4RubGDf6QCNgHP2XBX7SfFv
	 lmBN6OJRScywQ==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:53 +0200
Subject: [PATCH v6 02/12] dt-bindings: display: tegra: Document memory
 regions
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-2-79042cfa8de5@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3649; i=treding@nvidia.com;
 h=from:subject:message-id; bh=pBYGfO+OoRCfoGlySA1v5aSrpzUlJ6EhDp5j2u2Nips=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6g4z7jq+Sip+gg86QNRWNnQFHfWBE9B9un
 WUw4njXGJ+JAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 oTHMD/9TaZE5hzVAIbzqNa7syKW4k6S0ycYYYrVebi+lRO2QXDPm/tiDrM/ofrEIhvjWjXhW6Sd
 vhsLe4VBQt5yWfvAQpdM7PkubSeMTlUl/kdcw18kKnGBzhK8BLC1EzF6+JsNcBHxlCj005NiZnv
 EGUWrm6j4L7rV0ZB56H/YkwhfZakABtZzFtWy1Yfq7pOhVfJsrSkvNJBqJuH9DAAmuGIHEckjee
 5ExquwU8/hHHEod/bY8sGI4eDSLUOlotFszxJwKNPVm1uTrYp7Nm5G/2AysJTTQFUJi3ZDtQL23
 EEv7fLVyDGez4estd42id989nAFMj9+W74/fntP858iqMU1Nto0lx8CN5vLdGFgbl31BK4xjPk2
 CMDIGbPh9gAr0h5ODf9C2XizTrcP0s7kJL7pDwKFcW96yuRRWeFt4AzlYmVjYYoy4iD8S57QLM0
 iszSa/8npHYY5cwXNF1+27CG7wfaeEoD86ohEqnukcb5BtUvO7yLGGPT1FSakUf9b95savaDHDQ
 48J3/vfeH9HEU7THe9IdVTzFGFEZCQamYrYCA/dkcc9Ba3fMbJhJiWd6yXSueej1R/H/jm0d34t
 633FWGP86kmFzarMQXxJcNsP0IMtCM02qoW1TN0rPTFHOzlA16p6cgHvrJm95lWm0j/lYcXDkZc
 FajeSlJPG5eUtcA==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7qdtmndii698exfkjksj8qmgrhnahtth
X-Rspamd-Queue-Id: 237D620002
X-HE-Tag: 1788518724-881275
X-HE-Meta: U2FsdGVkX19aOHXmlRCrjkF1XOm+uWxyYds30bprpdJU0Ai5t/GMXuMf62meyvbLr8AKeEko9ZXoSMFTqp7cTTIrLgAf+GiHcLOTfNyGx4DUy+0/1SH0ZF8Up3aGgvpL+pJgwbe9mA3+bPiN2c1kvDeAHVzwWYeWfmwI0OyQnXWTTuQVvS6RzNS9WSPhqu8ZHsVGJ80C1awalLYon5faMYuup+jzRU11JkbairReCh6smVbtsAl4oLJA9/CU26DxpPnzYVOIqdgE1TnMa8ITdFJlxtsK8cVTzzEdnXby7WRJdR/b6zxXazjk4qZLHBEE1ysLbPNbKWUKQo1yh0GTk5djZigP8aEO9WlhVBxqCx4+SS0lKi6asemlBiDsUCxaaX9Aw2xEv4245sRQMchCsm5fZrHJoRwZIR/+sT+rvCbvKiyqAAbzj+sBDsuz2jEcrr/QGMdM027VDa+IJm8M3Sft4eVaJoDYT+BKGM0XbEPJkPY/mAS5bkac3NErq1EzP0Xw5bqs3ce27POLZTC2qe59lcJPsVxYkd/pMdLhmLzKKkSoem38ZdNPtXE+BZfVvQigevnJPTywtm3NVVA2C4J/l/DNIlgIu2PpIPtVLk9A2h8Mk/4WW8PY4Xgn5so50IPn8MkuMHpuqRvZkpr/suYReWB6y9QmS+vqDQqceFqtbMWV19kEqIaHh+1NYDCiHjzuMudwSpP4oii+6ii2+v6cIQjyGmGjz5d3EJVhBS4ssp3FTbxbtuVblxlLSHUaAuJEL39KZ5UnodUg2ZJAEjzaeEqZPkgTFiL5QRvPcE+0sNtKI4YV4UFKANtbW4U7wrCVKCI47gopf6b0acPyFg2b1Q0hb38B3KKAC/BmgymEhiwMZk3SkcpkiHe0nZTW3fTONIC1xGKUcWYnibjA7nfbzuMKBtmhxT1U4ln/UemEbdRq+LQ7twhnybUHceMhvZaCh2+Qw6qJ8RW8//h
 0jP4QJuH
 32jHB8wijX8ZQBoHmf3wxseU6GlLdQjCKdkocMDVv8QBoqFer52MTQNFcRk5RvUMMTlMRtBhzHW8OVHtGR33jVugZvHOMuZKLbdzC+NeJiFx35lEzY4IpAtdNrsVyZnG7VNSu4m5gMLwr3geOu0lsJWVgzz16WCXmAcfXpPdPMPqxdkwCvR1V8sbOSMXhm2B8ik7iJjBTVZznkOkC5sZweLSTPj7CXPvirM3X9ZEjjQVA0wNRszvwf3HOyb3P5uOczB50kpjzi6GxTMXj++5D1tn4KMRKrY347C/+QO/8/eoHodi53SCUKMMEkTRSXbmKQn9inrs1NGuG0VE=
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


