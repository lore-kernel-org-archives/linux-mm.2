Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 815D0C5AC7A
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 15:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EF6E6B0098; Fri,  7 Aug 2026 11:55:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49F2B6B0099; Fri,  7 Aug 2026 11:55:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3674E6B009B; Fri,  7 Aug 2026 11:55:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 057E56B0098
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 11:55:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 70D241603A2
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:55:01 +0000 (UTC)
X-FDA: 85074922002.11.8243879
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A577980002
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 15:54:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PlQ/rN8e";
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786118099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s5UylNYDTspcuu9MwQe+nNCZE8i0u6cLYLoMeIJYIfc=;
	b=TzB+7HUkWDHbwOwaKJxkeR5he4unQit214gd/5h0kY7DokmR37yddFQJsuj1GQUdQXXsOK
	5QvmiKatFUCnlcTERFyrOZZlCt8PH1XU3wJ90CZKSmclB5Z47WnxHSJwHryP+KwZYfE1cU
	ciazx9ndVCh0uNy7THWttt9oVz1RaoE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PlQ/rN8e";
	spf=pass (imf02.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786118099;
	b=kb+RaJpHz+RT5ydaxDudCzHbF7xHlPWIXsQF1S0pi+kexdzj4xxg9H6hwPShwDPBZo6gM0
	MNLVmSWacNbyLcaqKYYO0esknGLULBGFQKUbNzOGLWbNq+pBCurrxmLGQOCDpgEXl/6zI7
	RugJf2ddFvbjdTNmcF1F8jaVPGN//M8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE2CE43D45;
	Fri,  7 Aug 2026 15:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00DCE1F00A3A;
	Fri,  7 Aug 2026 15:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786118098;
	bh=s5UylNYDTspcuu9MwQe+nNCZE8i0u6cLYLoMeIJYIfc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PlQ/rN8eifYQ8QVCPMrG4ANWTYv8vhyu1GIGyz4VGfEy8FUqVhPCgJphWSPd/6xMf
	 SooHgkkSnrIkXwMCG2Cm6Nm14nXXNCS8efjorqIpn3gRKSytiWk1PyT/vgpnTnmOkf
	 4kIVTZJ1oyYTLsMMTrb7rp55T28DKmIwX1RNQBd7Cz0HlUUPmsNPRxGcjxAa5h6Bwv
	 aFYcKOrtza4aDpGIdCICWJJFI0RxMaEy8rZbfasBeNq0tdGoubUKE70+OPP/o9RpKa
	 N2haZ2J7Q97xRwDDfzQKufCVrb2wMuE4tttRw7ilmLO8lpIw8wJzf3IOnTfxY4i3ED
	 7DryO57FWTh8g==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 07 Aug 2026 17:54:23 +0200
Subject: [PATCH v4 03/10] dt-bindings: gpu: host1x: Document memory-regions
 for NVDEC
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260807-tegra-vpr-v4-3-5510d16af89e@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1073; i=treding@nvidia.com;
 h=from:subject:message-id; bh=YiLAGkzcznmBG0BMFt9ttJjGeSWnN/89E2oKOOw+7sE=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqdf/GR37sAZjqZHl9vjJq9BhScKylddewXFQ68
 Zlr4w9zmyqJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCanX/xgAKCRDdI6zXfz6z
 oW8xD/9C++PytcJnk3HXIfiT/huNGT/Ml4Mq3xayTRIIuViQuWMsLPhfCgi/ucIJdzk6RTskLSa
 x3yaOEVaKZ+Bd7KcishV/Bpnt6AR4PtAuibHchQvuMFd+eTrgao2hVopJ3G7a4pZsloaPzcNEDB
 +V7A6HFw01zNF56Qi1fiQmyz2jCeyCJ134mCwv72gnhTLUauwn7RgmH28JmTKV8TWWp4oGSa6OB
 cKIHBNJeyTbloYJ9v0TsFW70gvesfwdNVmiOTdyvmXQIaWiQNHQJ33PFnOw3Nr0Dr9l5fftIqjx
 EFnH42dJM6/ozMfQDTPo6ZWTw1DjsrS3vmQPA8IoJSINJJ9/BLzERlNMlS8YwP/4OQg4W2NYG8D
 D+1EBXcdNFLdNK2/PdXfpSMAU1G9uWVrLE1kWsTvXxsAljD34OrfvYJtiHBPLsBiL2UrPUoGMan
 ncHpe1rl5LMCQqHi+nfbZ6W4/H3qL7itpAuiunjnsHqW0lP0nSO4SeS3i1enyVT0cP2rNvU1cm/
 1lAvHLJICevyWHAmAKiNA6ZiepaOaKVL3y0u2MHkF1g5yj2q5yQWK/+BHI6dIN6ZG/FGrHyqe9Q
 3fY0OViQXFucoWk4ffPbbUD+lgrkADuXPKcbaIrFifd7mhD272tQnTPAECE5hqJv7qdks4lH6Yv
 ku8EZDSZYiNXi/Q==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Stat-Signature: ta7ak6nt7qhmjmnrqg3n7gtexjps5x8o
X-Rspamd-Queue-Id: A577980002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786118099-323507
X-HE-Meta: U2FsdGVkX19LS7P7HY4QJpfSlhNDCJgmCs3LUHjdfUc1zXLyv6tgUrjhULwuB1yW7ll+jMD1IUJHUl06XyOnE67AgBrEeyOFi6RSHQyOjF/iHR0vnxRu/oSBhHKCoEO/+LHBEGr6agzzC5gRA69hFYalALJ5LIK+9IWoszuJX0suH1PNhsuhGeY1MdwsBXy/BidJ7PYhTko3vnoWk3WHMVutr+s8w50Tj92zHlWMaeM68mR1jNVKftbftCFgqiMgBywm8ARVVjcZq5UobyL8gJCcgQ2FiavlQvtgabBuR8z18xSZpJE7AKeZEcrryv03xZz7/AN0t7fN3rVGQSEwi7hkkXC9g7tYd9KFXS8lq6mofgN/Hxm7iYPCeXeM/UWJQ8uFJX+Nb/Xkof/H79Wvw8UtkJWVIkUzC3xJ9EJU7K7JmDkPQIDNAIPdhObWpb9NiCZgyT2Mopn8h/fz8n7++UnGIi/ZW6EIapTzHUgkJ6PkaxJDv289+6Goi8keMs7V/hWNHmZqaEikl8MraSHET8lR0BOLqDE3y0rWjHSRPjQHhsZhysyYaMxGNB4vLUVYzAxMK7HWWIWm7tYCiyNpsKWaOLP0c9pXk5SjZCJdI1YqXA/QDYjVn45WySxoSc9qE6td1B35UhBvFq9JmIDn4O8BX6q7wV6GHyBbHPsDneq+KSNLs4JJd1cy9wywRbt3Ma/loIuYTG9YDgw3O7XOcsealVsgSfm9Djb1jR+dQkoCMG1hMsGBFEW4Kehyp9o8vcYf+8fH6gcSe1njCHurQaysXIsuvWYNy+bzl7GImz0lu8z+ESnlB7RxbtZZZJlxgVJx2M4V9RxCitrmsaWT8d56wJx0f0t80PRCsDGWqEtZhsOnAtRy7IS8mheERoC6Oltp4gAl0I4ntyGLvIi324uXBAEN8l9Key0ZyHm0n8767eMpnohhrtof7U8yVmB6Y24BBKlRfKvsPYyDc3Q
 eN56eMyt
 7kIKMatqo2y2l/xE8R1IcRZZKauZKwAVpSbxk7GIbWIXnmsD3mknEQkOGjHo8+2/Mae6VbM9yZ9ywaB5dTVNRKaNagKjHetE8XwbR2El6JND1LLi3sXSc9iDIzPa/sxnY7vzuPD0xRCY0yusYT/sYA96xHYvkramgQaqt+XrQP8Tv5omdfv4By73Ej79bL69g+gHfomKsh3/KH+Mc1W9vdI5rlXR5F0t9Hl85ZVdd9fsJ26h3vF2V5GfCQPEVwlTUTQQSIzE6iXYMSyxwEdr/TYkhvoaSGgcJhFJb2Bzg3cnrChzAKlZh8qKSeQ==
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


