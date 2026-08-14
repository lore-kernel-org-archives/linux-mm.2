Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA61C5DF6A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 15:29:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7F96B06D3; Fri, 14 Aug 2026 11:29:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB09F6B06D5; Fri, 14 Aug 2026 11:29:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE756B06D6; Fri, 14 Aug 2026 11:29:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 876666B06D3
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:29:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8899AC015E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:43 +0000 (UTC)
X-FDA: 85100259846.15.0C4526A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC62B80004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 15:29:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flinAHY2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786721381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hagYf35q6G2UhsHzty44d2izTZaC/NeM9Zitkk0WHRQ=;
	b=2VnETXiBY9LjcqH9RkrFIPHP/pJYyFGUem7sRjtktSZW8QlmWX41LI5c1fbrOmGdAuYdYM
	m1/16CzmhaMsX+qZgWLIvNMGAhJngeAORzp7F5L+ti91E9no27wBg24CdWC/kj9jAj5FuQ
	QrZdL4GoinvPxMONxj+PTMNKCN3zhXc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=flinAHY2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of thierry.reding@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786721381;
	b=z3/hD+AmDZ9k1agv0Rg1dXSL62zrvwd3rDG6LtC0C88adFi9QzvKKzWbz5MdRjeFncJZFy
	6LTYf54Oygiink1/fewQaj3m6V8lbBpKLTBWuuoUMlzZnv4BqR8nvEAWwmFO2orVATXHcR
	x9Mns49KQm2woiHYQtHVd1PB+DhuM6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB29760A72;
	Fri, 14 Aug 2026 15:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6F381F000E9;
	Fri, 14 Aug 2026 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786721380;
	bh=hagYf35q6G2UhsHzty44d2izTZaC/NeM9Zitkk0WHRQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=flinAHY2TCzAQp51/VofbBun1xlQT2bmsz0G1F/e/noxEOuSLeCum+o7maLYlpqmQ
	 /fCNRK5u2pVUDff9WOpgjdwfv0VumaETvgyjBD4m7+9abjd9YoLuS7S3vH2wdng+V6
	 uj7WjDBEYfLKM0HpZIxqjl1aAMkhgGMzLDS8HyEPqzQENhaojB43Nb+uGZYwrR+2S9
	 AmOQ7kiZ37CH0EhkOYKjVh1rHWwCiz9CFNYIp+EQLcshpuHC8XmP2t6KaIqriIeuuk
	 1mU79Rz9lLEOUmvrPQziSTmt4Y/uAz4fcbHpt43cs5nOKiBPHM6LWTWen7lsSUWhav
	 YJb4sUfspUFpw==
From: Thierry Reding <thierry.reding@kernel.org>
Date: Fri, 14 Aug 2026 17:29:11 +0200
Subject: [PATCH v5 03/10] dt-bindings: gpu: host1x: Document memory-regions
 for NVDEC
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-tegra-vpr-v5-3-71832b5d0246@nvidia.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1123; i=treding@nvidia.com;
 h=from:subject:message-id; bh=96od8SnVSYMiavrRwbh7Ehk1YxWlsQuy9Uk4ZKu5YoI=;
 b=owEBbQKS/ZANAwAKAd0jrNd/PrOhAcsmYgBqfzRXzzaJcNN7yh/4w8KOcdpo2zu6d8W+euiDX
 mBrAATLPxSJAjMEAAEKAB0WIQSI6sMIAUnM98CNyJ/dI6zXfz6zoQUCan80VwAKCRDdI6zXfz6z
 oTw8EACuc0eBM13PSAlDb5GHdm6QtW4MAiTJa1Pw+FwiKHMIRJpmpzbu0iIG0ZOdmChmnu2ClwP
 s3gbqJ6YRrL9ruy46tyMj0RVjZmP+8itbMFX9Dzx1WQ20c6wSYZPljF4/NT2DncBSidJT9msAw/
 Isipo/ka6MqadTIpfMi+veITAsnb1pJn0wugYxr/lecYT1Qqk8pwaBDtrh6QcceAiyT4XfUkuG/
 V6wZv8UbLps/2wgNoUPKoxF2rAqYsH4936MxwWMKbqK9HdO39ObjyAvfkRyBoSyITu9IEC+Tvz7
 VGGB576u4oSzVEUSJCQfgVFE1uvf4l1aOpmgYgzzp4PRcRg8nuu6eyjSjJ1TtNl+zU8SU6uthvC
 zv49vGosmKrQ385BX94aSlQ356vW9xuaN96c66oAzrSwDFpyXthbnEQLJoOBaKQVQFbaQMfvGwX
 CgTQD4FXkcZnm85qZr6J0K8TKMtlY/NPvtDpB9kMN93B/PVT5GASAQI2wE9uKDq1Tq30K+I68c3
 zO9oJ9WO09izzerU9CXmI42KivHR3h5CUiTV4O0eeAE+LvA7T/kgD2XTTur3s7VQgqJhDK66iGI
 lXeWljmZ6k5XjRnwmsNoncXTKdLTviNhoB4KcPTqULm8/kGAKhLCJD0fdHxTor05+AjZx3SixcW
 eHXtvYBAnuEhCfw==
X-Developer-Key: i=treding@nvidia.com; a=openpgp;
 fpr=88EAC3080149CCF7C08DC89FDD23ACD77F3EB3A1
X-Rspam-User: 
X-Stat-Signature: 1xghehbf7ncyc35q8c97n6mwdsho4ehg
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC62B80004
X-HE-Tag: 1786721381-41821
X-HE-Meta: U2FsdGVkX1/fG7r+K/p20GvK0eKf7IPhJ5K5QhxomS9VfjiP0YMM+8rKkwj1bssSYpFcJo3VwfMKp+L+ZUinjUCbc7ewVtYy9FxKo5ltW2Q5M99DdFEeSBrt9eofuaBDJmrT6t83vKtN6Tem7bZRlV/AAXSYp9T3ddyjdGqdU+8wp3V+rxznnJuKb1bX59w+szr6GebjcORXdv1MQD3+8gOFjV53FD2w2XMJJt1jX2Q6IaFki9bZUSS60YC9F9MSp6fP3O2oYk7gA0SanocsWfTHaEK5vwqhO0tTrQb02gsUarkwDyie3cpjMTsWeu5a3YLgEoGSXuOXnh1kRp51wvFvls7Nx3i2JV57W2IQ+JsUlfKtS+S5YldgrjJWHgM2f2SPDETHSRConiBY76SUV6X1MkW3uCGdSRHmY5DfWGU127VYh4gg+15WWIbsQhGLCBmZWb1z5LcEYPcIZI86K51+iIqw1ehFnJxiOGDYgpn+aosRbzsIGu5zjyaP5iLdptnDTPlm2cLWhuwd1C3UQxSLZX8fyLr9DFw0emuasMN6CsXVQ0o5FGMpqwX67B8Nt28iANBdGDIQkQgxOa1Nini5JxT/Pj2iCDoqpvAgGChHenHTqLdnYl1ORmnUH6K2kQcm8tG4W2IfFt3zGZUzuSMps37WJdHfwJx104s3ghagWFexb/zt3+MEye8TP860KVmz51ce6Fpj+FV4RQHpw9pbnpoqPVsFqg+aRyfwbPUJCHqcIi7JS6WDbcUHBIzdOWsQE4yFsFEUSp23ilav2x3Qhrp6lalXnXlQzPF8SaWmdWPCs28zmQa30W6LtBDWosFbuETn3ZQR26/9U7P7ChBK51Wx6jDWw80DwVYg0rDRGeFggrTSxijAkG6JUcXB7CyHkayEjtDJ1fmeDazmX8iazgc7stoFKWLFb/ut+xI4R72WCM8UHNPmfYxdZlCr9p2gwnedtajgxFf45x9
 i7NUdq5h
 AM6t/8R7KCcxwvttWq82GXq3QFj76+2CW8WW+BJq/NKvqzN86w16SVMV3MDlXlVnCATB2e7NedphCVTKFNLMK393MQLDLRrAH3dwIKMja/imoE8gJM6p5h72mWkSKnNzuYe2YBfWE/G7fE7JOdRUCkxksh4fidON3Of/ljGH+rQ72pgR36QEyGd1LvTPMeBNDNhWP841ShbsKAArpDna+UzmeVlQk0s3WGyV1SkmZSc8/+dyAdPbPGJ3+EQbxMz6abQymuTjDt3K+DUD4c5OLwJyEQxXhgbqHfiZj7SkZkMHS69OhovdAslAqmIsZdu1YLL2NyzjbCOYrA2Q=
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


