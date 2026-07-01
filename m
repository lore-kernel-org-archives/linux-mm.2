Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49018C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 16:08:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38FE56B00AD; Wed,  1 Jul 2026 12:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33F8D6B00AE; Wed,  1 Jul 2026 12:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E03C6B00AF; Wed,  1 Jul 2026 12:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E31816B00AD
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:08:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EE9640401
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:52 +0000 (UTC)
X-FDA: 84940691304.15.8D65A2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 94D27180015
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 16:08:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VySaHdDZ;
	spf=pass (imf16.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782922130;
	b=ySF05jfl0j6TLvX2nwfjwm95ZSIbhC2bNdhQTn4eTYsn/iIMIzxUtg7LcOiqYbaBgzHB5Z
	kDR1Cd1ofXwllWQ1AwY1FUtZuQOw3Cwe2i5329zxJphNNTXawVW9eiTHyZbqUlII6Jrrdy
	5bQ1Vlhlg7llj24/+wwG/NiThBFDxD4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782922130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5UylNYDTspcuu9MwQe+nNCZE8i0u6cLYLoMeIJYIfc=;
	b=SfJ9P8mZtoPTH0VpQIJB6OrpkTdOkS6fWQZf7uobsdHNEUryes+Baav6NSQy9CLsli0tPF
	1Uu1Hs04QnGVrC8XOk7H8GKaOqo7A3CYYjzYmaQU/K02KPxGHXCHXQuHB8IWASdtJHN+eE
	A9+/1NmF5UoWdK2dkTjdVufbKJbT0N0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VySaHdDZ;
	spf=pass (imf16.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E66F143D40;
	Wed,  1 Jul 2026 16:08:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C421F00A3E;
	Wed,  1 Jul 2026 16:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782922129;
	bh=s5UylNYDTspcuu9MwQe+nNCZE8i0u6cLYLoMeIJYIfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VySaHdDZoDiJzUm+97zbd0xZo4HMp6Hfn2fMQvLrLwb5XXMhno3TqC9g5nITaD6C2
	 QcoZDYhaz8CSM6nl54LKWdZPg4JvN9LZiJZ1ghCSZZ+0UWSzFcDSd41v3mA8FbQ0tv
	 lhP/RQFj8HymUZfo8xgw4whmaSMk3PlCphdNFJNouyFcFBUylKA9La0MY6PfKRXv+l
	 mjED68ijJASgQSo00QyI5Uk823Kqk4O1T5vFPUmW3CxIuXEHzu5FF500FP23KgieDI
	 Saj/33mlVh0Bc09l8g9w4SnZWNDl1kfSUjojpWPgG3KlvKhkeRnE9fwsee5JU1xoaQ
	 fCN014hGMv2Og==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Wed, 01 Jul 2026 18:08:14 +0200
Subject: [PATCH v3 03/11] dt-bindings: gpu: host1x: Document memory-regions
 for NVDEC
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260701-tegra-vpr-v3-3-d80f7b871bb4@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=treding@nvidia.com;
 h=from:subject:message-id; bh=YiLAGkzcznmBG0BMFt9ttJjGeSWnN/89E2oKOOw+7sE=;
 b=kA0DAAoB3SOs138+s6EByyZiAGpFO4Wi6nVkH8SB1XxCYsDBFk1RCy3m6me3qImXpoqxvKh66
 IkCMwQAAQoAHRYhBIjqwwgBScz3wI3In90jrNd/PrOhBQJqRTuFAAoJEN0jrNd/PrOhtx8QAL24
 JFZ1eyoK168npHmVnch9YgVz+PSE7M0Wqwi8uUTcVivjEoiQ6p6pa0SeTBugcnaQb3QBo0JrLUH
 o3clj6tNA211B6HFML1dhEO7HKR8sJZ/48FQrzKH5/hNriAnSUr8GsNYN+EbMiJretpSJj8F6Vr
 5sNqDyQ9NJHdbJxxJ0WQgMEa1P3vLc25Sn9UCcBg2Vze+51uVnXJgM1JqTFXusf2HcdLzzBF5f/
 v8pd0wYGl4VDcrtfffFbgv2zptz5kwuHmwQwdA1TJZ1l9t0Fl9plXga8LaILGNBoiFy6ecl7dDA
 sVoQJgj8vyBXwRk5q4Dzo1u4FNC+5cl1OLJZkpcULDxkj6eyfnx23iY7OkXgCRz2PLUtvjhpTZ4
 QYTY1DyX9rlQFrlzy3aajhQtUhH15tx7rLFy/0DnxQbaJeYMMjcEu/DIx/+K4xfNPXr2KcnNfKP
 BbgkgSpR8yCTKCZDQYAubaDvQOUeWULBVkzsXU2S3gqX1Puf/e4Ge7ei4P7s1ruNjSFpMmzWbxt
 9y/W0XfJuIQzLIvozsP7xEQhIgospemSYCrQzf3qbPGYuNW/JbSiC/H6ahdoaDTyKJkkrl2te+h
 +WhWkbwXbu9bYoSe6dUf4gCoSZ/gYYT5sLIDONwrOZRjSdV8d2zo9HehXb3+r1imNr35qn32lf+
 y/wAZ
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 94D27180015
X-Stat-Signature: wrmc8sue5hg8dekszz6rrhgpskqccnxx
X-HE-Tag: 1782922130-546228
X-HE-Meta: U2FsdGVkX19/yLl5WKFqwcwCZu5PwORmI063S5cV50sdiwbH3RGvzvIL4XkHq1Y6UVKpWMYFDd4T0tISwsYVbOhZeQ4EGo76u5Mur3nsvccMlA4bgQeZaVy0tqLkWji7bmjc7IEQIS09w/fEMPqJl/hYucGiApehACGvpGqqr3mnfYRJPVyED9oXhpyXOEK8S8MslNmq171OJ6hCTjWPb+6FBOijIDGZTNmGs78XYOiBms2YkUhV9s/e9ZwhU9ZCL0e4+D+TM4dyhjmC+SnzC3akirRlitlPBkZGSuUHkAB6RO0z4XSXF1lQFbRMI4xVBoftMUTyfLiRzE1C4CTSAPb0A101yhxfRQQSOZYzPmJW0r6o690zKrvq63yP3lqTCd8xoMP3M52YbT3ZSdrcT46QN6/1t6XBX5Avi3Ff9TW3wHppLIXjil0OA4AvZ6g1l9LYR7vUA0YdPX9lRcGLQwQUBR/GO/LmAlgdBl9gzvDVDB2oib8qWQcnDKXZGe2Axvu711DnuDgN/dZLY8KMemqVrwhS9lRtNVsajX6jJ79+OxjjhaEs8VXqgNHfDf7FYV4TfFenNK0wnRNGLQ01jTtR5TNmxS+rLj2IC4xLktr6pHYSDmnGUFiY9yp53LktPCxC6RtKFZCy1FFQjTZ7etmZwQB1UYg+RQWQNuKEyMkRHVZh02f4Tv54nagwQOcE9v6Tfk4PlVzpWQQ/TGW5qdnQS3dAIzZmnNaunDuWaTNeAwJQ+liv0YKPzj4LMK7MR9Y6jWskxyZ4fegu8UDVQ3fXFYDEoS/lABNsmw9P1mbdEYfb5TeRsXKRBnObMbqlyWSlwTzJuI6nvX3GvHmsePM5SfZmvE3NCLJt9YeoGjkH/Tj0hIOrzjAyPqnhhBBqjfztpV9qqF+u4xE0ouE7f9Z1ILU2DCM+bqho5OF0agStZQqwc+W4Is+EH5/pBJTykCKP8fsNUwd65gWRkoJ
 GjSPrAef
 z6JEgxc1bwbxN5AADr2LLubQAgfrRJGj1Cb3t29Ig6wPE1Xt5dku8SCi3asYL7fDpHd7SY5aTK0FTRlpBtBywOSOcIhoRUgVhpyeOrivoAVx6dpwEL1ZutiTxL21HuzUZOP7JxJJRchDQ2IPofD3tnIrO2SwHsqvjKi9p2i7ImafIbBkoZHXnKLylXV7/SAsnMJCadCo1y0N9M5deixQtOXbv2AyuQUuU6oYbdGvkD0mowVoi5+Z8wvJTUw90BMcRkqZxmpatc/sUjPlnE66YTL3c9Y0CE20PNF6Xx+NTYCCZj1tkcSGcYjroIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Thierry Reding <treding@nvidia.com>

The video protection region is a reserved memory region that can be used
for secure video playback. NVDEC can access this region to decode images
into securely.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 .../devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml     | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
index 4eb325cfd296..bcaaabca945d 100644
--- a/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
+++ b/Documentation/devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml
@@ -60,6 +60,14 @@ properties:
       - const: dma-mem
       - const: write
 
+  memory-region:
+    items:
+      - description: reference to the video protection memory region
+
+  memory-region-names:
+    items:
+      - const: protected
+
   nvidia,memory-controller:
     $ref: /schemas/types.yaml#/definitions/phandle
     description:

-- 
2.54.0


