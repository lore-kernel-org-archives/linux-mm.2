Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD438C61DD6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 10:45:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1EE6B0098; Fri,  4 Sep 2026 06:45:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479486B0099; Fri,  4 Sep 2026 06:45:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3910D6B009B; Fri,  4 Sep 2026 06:45:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 082EF6B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 06:45:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8610EC07B0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:29 +0000 (UTC)
X-FDA: 85175748378.06.A266F1E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B112840007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 10:45:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4VteYfZ;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788518727;
	b=YXKL9TGKTv2VMH1xMiOAjruNiWSSC6tdVkkurtf24SxCq7YcoMbndylcDyztsLlwdlz+nD
	Q5DM9xXMiTJ46hFUMvykR7MI+hfIA0nGKcBvXhXUoFVQfHnbF+guvT6KGE8n75U3N09d38
	Fz1HQ9/0vJDOnBZRPsCr5ibq9tywOUE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P4VteYfZ;
	spf=pass (imf17.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788518727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hagYf35q6G2UhsHzty44d2izTZaC/NeM9Zitkk0WHRQ=;
	b=jBru3LPyv4Om+Wn94SqTaSZ+Uqigbhsd0TP/kjAHmleknNmHyA2+61ogIDgx7EqSrqFkAe
	q+/Kn0njD+7QvmRe6VazRlN7oBkGWZExLkhEvn7GFGP6KTxCYnY7DkHBaKMkIZhoxZiewG
	XF+MhRdlhso9KWlzUTvSCX4m/guU4BY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EED1B435D7;
	Fri,  4 Sep 2026 10:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 211151F00A3E;
	Fri,  4 Sep 2026 10:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518726;
	bh=hagYf35q6G2UhsHzty44d2izTZaC/NeM9Zitkk0WHRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P4VteYfZoOUKRz6lqankTJMKJHc22APwmujZJPl/o9mFh+IaXlyFuO4ak0voN5g1+
	 SkPOsetnsV8OgScpk2tWZMqM6V6brZ2/wcoAJdD37U/u1/ZUhg5SWVOjIeHELTS65P
	 pbrK8W62YAb2sNPLRs8sJuv4H8SIWeVvm/qt2Bop5lmROPJTj6ET2fTuqE1+ltqHmJ
	 cdFluDoQEkGzlkB2wggIhYLNLCP+idVVB06/yEMa5e2gQXMUSkDDSzsSzyojU8FSGA
	 q3Le5bnorB5CtElF/RC4Yo0O8r1V1S75q7G6ZZomHcMbEjcxVMbnTKjkjyZ8sS5iWJ
	 jw0cjbyxhhxxA==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 04 Sep 2026 12:44:54 +0200
Subject: [PATCH v6 03/12] dt-bindings: gpu: host1x: Document memory-regions
 for NVDEC
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-tegra-vpr-v6-3-79042cfa8de5@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1123; i=treding@nvidia.com;
 h=from:subject:message-id; bh=96od8SnVSYMiavrRwbh7Ehk1YxWlsQuy9Uk4ZKu5YoI=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqmqE6a7RpJI/GCW4mTGRJ87hxtCRDZnRUuKBN7
 pMhWoYQXcOJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCapqhOgAKCRDdI6zXfz6z
 occEEACxZ8dNEU7BnEN2Ha6fyLYWa+f1AwIxLCAG071sdb02B+kE1t9bISlQZt9JywhEH3ommb6
 efRnWfcpz3n38v0h0WnFrjzBJgURRzhc3NWBBpF4on5vJuXUFd14lhkleafdS1eTlcX+2jhKsX1
 seoHP+vg0Ks6FKmpTL0OKgtrKgy6ku+wkPNhK2pUylTPM4v6NP9j5OEKOCJ2TkFjwRUx1/i6viq
 j2hDpWCI+onyBKR5P5Lf90rVaBhYDO8zZpivHAvfwexg/kCj+UCVg0GE6cwNIo6e3AOYZS4fYUC
 E9H4MftsWwewlBj1Zq2KjRC3hyTfWS5DLPp59ZRTbgeLWg8iA5wuGJ/ED+CIHYUvticQ93nMVA1
 n7gvWqthSmuAunsNZx8nmg0jwJYFVmG38lGOYm2wYbwE9brDWT2neM6V2lM3zvfaNDffWqDy3mq
 hYEZq1xglKDRgNdZ+JPDMHDHHc0dL+1HqbX46xkB0bO/vni8UXpBZTLR/vikYgRGc6l+a0/Bxs+
 6/BcZttVbk+FEyNWKKHRCbF9oeSxsA6iPh/5W7ER4DU5e8yF0DlSE0KEpIkxMbhHTPVwqvQewrW
 zHc6+V4hT2sFlQ1D1Y7fcOVlrGyML932LvpQOio2aw9cbloake8bpTwzaOZi7hyrxZ99VMjAQLt
 EEsWSIg7v53KUNg==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B112840007
X-Stat-Signature: r59t1q81zixne4qd5aqd5igi8r5f59tx
X-HE-Tag: 1788518727-858132
X-HE-Meta: U2FsdGVkX1+SMNd/3piBhnZqycMc7aJopnp0umv2BFrSSZPtpB/1P1t4ozAiyNeRS87W3cFGbMu+1EijA/vuJmjUfmkIHu6jjCBLZfifSMilnoUzlrc3mfCsUmkN6EVn45ZE88MTqsDN70jJlTN/CNxJYBQGwNagiBr2eUw9dVOH762zEMotWhqd0/mYmGHZ89CygnqozEVhd6eK4q/JwE5NtJi+CUIOxw+keC0ir9xI1Eu/JA77MIpQs7XX6r4/XzgYH7TpDNfQS+JMdTyDR/EU4PH5BwOCugitZFZCbUo+K4Xyfn12Y6mN+TV4tejAYSaj/oKruRZsC5laI7ZJzKiWonqFGQ/0CGUuwlha3ZQm2DldRj55fU3qf3R+LGjzaHhBdROZhICWxH4ipJLPxBN/s+S3+pbXiQj31pczOBv/PRwdjheqjgPvyDHSs6Oz3giNn1SyRrjRRR+EDSq06Xa+hu/kysGD4LXuQTqNhdZvZHCyZr8LQfCQJFEGK/052JPsnFUFCIG/I2tOGxEBfFzasPnaMpPvfDKNik8kaHZ05/HojeY+HDqZymWYDc7/OfNwF9nS+2IuSe7cX6TmFjB4MQG/MNynYRIqTMlPHWWaoL1Z9ZXsMblROom8SrnraebP+RQ1oZDkTkeBWH0fVY/DNPW8pY94TubVt6DewaIGrW0ONTUngBl4UHwApnT0FbEvrOzvyzqkxjBE+cuDjpTwMI3UR++qmq5zi4MNUSPs93ARrMdYWHrQAwyLIaWTcbKKXomfs0iZAmYFPGON5BXukh3S/fk5Dnie74P6YwN1BlIsyAVQSxRkPTfYyinzTIfNyzb97Mx6jM/1ud/2h5MthU3MfPFu7THTjrTIhaIxvrCWJWVh1pvImbeYefp5NkuOBuqUq8FXGX1bklSCoDm2OihZPxvnANE4ntk+mwRFSpmv35lN4wf2qYI+Nvvge7xd0xEuX0+6UU79C85
 Lxvn8mg6
 zUwsXOZd54UH9QOngnkiFjiU6HQCx03slxLLskONNAjcwu3QnlAajCP1dDVg8DWve+qSwRnCrCytME7c9SPmltspC2gsSFKR1j+8IMceMi/r1P85G/T6Pu/4dt3NrxdQS1CfBibQTTck0kT9Zi5XoYDUuYKs1qltzmFLK73Y34u1dxtU+yr5dKcBsima33mvuGoCGGbOkJ4unRuZ5SKeGY0GkDyOft7TwGoO/mbIfY1ycT4B4brYwhfyAs167f/2UAKokcGggsgVQNy17yukFPFQoCguEtBJ67TBghEjiqS3n/ZPqfwWXqHCEKv76ntHI2sAmbFRPAk2hXlg=
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

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
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
2.55.0


