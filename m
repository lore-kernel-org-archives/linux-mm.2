Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73824C79F85
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786E96B0092; Fri,  4 Sep 2026 06:45:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7384B6B0095; Fri,  4 Sep 2026 06:45:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64E686B0096; Fri,  4 Sep 2026 06:45:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 307386B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:25 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ACE2A1607F4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:24 +0000 (UTC)
X-FDA: 85175748168.18.8C49063
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D48B814000B
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cflxm78z;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y3WFbhYTWczQCYOlTAjPPPmhWM8d8ALyu3lGu1XHIBs=;
	b=WzVbPeRCqExrRlAP0i17XM3C9ij26UmZMfecFxr0+LXhPN6lr9cNkbUw+lk2XbvnhwXB9N
	5WZgZ1cu19uF8RYztdv28QPb/zw/10cpkwof+sFILfUZHJyeHl/EWYH0rivDcW0dJwryAR
	/tsokyQf0yZpVsXPAUvx4HduBPLbDXs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cflxm78z;
	spf=pass (imf23.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518722;
	b=SeNcC1TrH4Ask9V4L98vB26WBOscz3apKt61w3brBqfuAzl5M5C9ZuBQH1IYjqe3JtoAsm
	4ig1Nr7bnnE9PnP50thpBvQji2N/7kUCFZHKaUb7C2Q1SzQnU5AgMJU8/3qtIGATeWgN6D
	dCsre3GGpR0RVmhXSaPOXl3H1lNZ3Xk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64F2541AB0;
	Fri,  4 Sep 2026 10:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B8E1F00A3E;
	Fri,  4 Sep 2026 10:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518721;
	bh=Y3WFbhYTWczQCYOlTAjPPPmhWM8d8ALyu3lGu1XHIBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cflxm78zPmElmE79iVcRd1zqdWwKbB4Zuq5lic8TpSsLVgJl4AqcQcagMqfeRPj85
	 svKzabACAzvErzQkWT5N8s5+IxHwcDEiVqY689SsTuv2KhZ9GUlFY0F397vVXjWez9
	 hcwtkLVZYSwarBuibgpTXgdnRSgBQboRTa8mw2PC3YnNJoDdtZlTAHFUk2PwEY9r7h
	 ybXL0oUr0EwOMc9koSzfmcziqzqzxXoRTO50bqSnjxc3+UmGN3sdKnOUw7Di4qeALO
	 A5he+y5G5OuiUxq/Rf/KF6CoGPjEQngWPPqY38JqnTCSgH0/ipUKCgpVBGQuhNylsg
	 50lpEBsavz90Q==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:52 +0200
Subject: [PATCH v6 01/12] dt-bindings: reserved-memory: Document Tegra VPR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-1-79042cfa8de5@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3632; i=treding@nvidia.com;
 h=from:subject:message-id; bh=lz5bdbUU9mR9/O2pGRVuSC+tGOj+4+d05JhFJg7QQcs=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE51zTFtK6El9Uth1TluaNXciidz0p6cGBHQ
 NSYqEB7AryJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOQAKCRDdI6zXfz6z
 oSJ9D/9ZyCFmV1msw3xlBtwgra24KMR9ILpX76qpP+kK/qxdJvKDzwFdwwQRA1uMjJNDCW3mT3q
 zbfvq/xX3Y0eVt2VK4WRewsIq2wWSVufBxpNWS8TFruIMf11mLI8TCxIpFsR+dsYmZXY6OL99vV
 SyNSKWOG6qCGYK+2RzJt4nfu1fxdW1xryTIyVso9W0Q3cmJAVar0WEtyodRdSx2uvFK4+Ex6pTG
 luJH1DEukYK0ylguH0nqIN3LgWIp6JefXc2/v9JWfDpR87IOTqYpHQC7l4iI/NleUABkrCcal0p
 fc0vRk/G+CL6agZUAHz9rfVmH9hG5OqceR4PjZZNyU6WXnV6NeRVO3p2zDzth9bFgPZojE4GUKG
 z2SkJcI/G++md69sTsESemWU13EWwEXg0M3k+sInpMyi6R72Mr4vCs2JQwhMs3lsh1LZcifjFPk
 b7V2nRhgoSWQZwDE96l8InInujIRlVwAiDDr5N8IgyqMHQ4sWWxl/lklqubJ+wj1bIVSmFkzzNw
 ulTGoFPU8Bui/9xo7Lf5jTgCIY2YvmjmXxx+HuaCBsgxifZddSQE5jVO+j1E85TyzS7tCttrju6
 QgpkuWQrqwiH317BklyAntuKRIk81U8JfN6LZEcs2eelmldYc+GqPmyMr9vvSfWtQvLzu0khEGv
 7N/GuHEDDe6KEGg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: np9sjfwu79nxr46whscgw3obxg6gphw4
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D48B814000B
X-Rspam-User: 
X-HE-Tag: 1788518722-941445
X-HE-Meta: U2FsdGVkX1+RdJP9LYecTvsvQuu2hLsuU4xfGy2PcVVWmW/3MHWv+KxsvsUyRWi+U1ALLXiAAAnP1a0nU2goO597i7ev0TiQqivGCHr79boT5fW9Mo4k8CkIrM7qC+c3mmWncghC/pBBXHvMPSNger8glxG/S56oeCs/2+f0aIpKhqn5RMZwPbyHGYm9IvoicPg51ccnr7f1i9dQzcvHj1X1S1GMxP5K57qxe3voPoIYyuH2M0r9IxUaL+oj8mbfrSS2tlFhlq4hWaFHRZDtioeGp7W4J83+jQzcJx6/V7iDjP1u3ZH8i0KCi5CzYQ0fJ0s6K1Q2qZfdLC/56IIluI7QsdofQe/riCXBr9U/LfUJadKtntKLqAgxUdBCcZ1W/ROCdu+ntuuVhNNb9Av3vLzDx4cqIYAwKR4KaOC0WQNtz/RnHizv2hwN6um1kCF2vEn7O92f6apcyzwKadXdbqPkAo2xNJcVHciwHoLF00DtaUlHFNcWo2omtAniguQxEoYwqu2mALiPCu2Kz+cD5xpEYKn2DszkZs9DCiooj6BYiLrze1ijmTCJZ3wgeh+A6x37owezD2xrzb6EFM0bpywI3j8lUYXKZyl0zIiH5j2tdz19us1xOGddZ2TGx5BkT2CAGNTWNcfnCoHEmgQNEXNcTsEOOU8rjro5VF5BpIjqXi9fnb30NuMglrjLTU1GcRSYyIqcLE2Z7Rm6XPIwgRq9nPGlPku/AI2sid/E7eVl4FprjdNyYX6BrssK+uxpKrbP9JRaUJQ/yu8Kh4cFqXy8c0TUPHWYoLLKbNkNBfLHe5TNTTRUDOoIMFNNSUoEDuNbX4eXbHRZJf4A/1LjMC+eRwGTfGwUEfI+4Wa5vhX38eyP3i5xgpTqo66WgN4B+7iJDwcRJapsWuNoMtpwpHnIYUaEcWA+wO41H925HBNJRaQgzwWCVmwymjUzpw7G3j/ATHfveKa6aJ+znUh
 +/6RcNQI
 ujmoTZfN3x8cUuTcH45y3CGT9ocW6KFwGRvtC1jK1Ww+aT8MJn0OlR4kekY5JukkHWVMRauxHtXYQCuKG+OMyVixqJfMMguKHNkC5UNNa5yO+VIbK0yuR6RVujN273tV+cg/bBMB/Hjb4nysPAz0zIPCINGbK/vdRvIH9XCxfpAxa8AfL1KQmnYCY4wTOAITqjk8pMVc89UT/Hj8e5U4WqVFt4NhDBDeuK0b1b0gIkcVnS46vKVJlZ4KjITPMJZuIQOadYZNm1SvKCPFQTkaDs5Ve2Zj9eN88qrCzYgvDGvZ86ntR9zE3fkUlQ5RPBk3sHznYQZ9jH1Ebb+bB5SHM/Ck1cwdPo3RID7V0QVZhi0qjQA5Bcj4Suy38F6zzlJsVBLQl6Dj+uzY3vdLct5ofNpTghYwJondVxf1W
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
2.55.0


