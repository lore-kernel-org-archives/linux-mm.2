Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62FE0C43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:53:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067626B00A8; Wed,  1 Jul 2026 15:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33516B00A9; Wed,  1 Jul 2026 15:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCC06B00AB; Wed,  1 Jul 2026 15:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEBA86B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:53:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DD4271A04C5
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:53:14 +0000 (UTC)
X-FDA: 84941256708.09.0498286
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43596A0005
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:53:13 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SW5Xw1L4;
	spf=pass (imf15.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782935593;
	b=WQihJJ00Z75+ovbmDm/t3lFGzOZqhZHsFF2AB1lzj4j6P9ty9/fZ1D0ErlAR95hfJSGH3E
	/c7AjReJUtjQq5cTUbNl6Up8E4pNmU7VDRErelXSv/mD03f0gu4QJlP5ODKZPSsRce3mcu
	jNnf6/BX6ZZkN9NQhzdjQkvgqQWhSOM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782935593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Btp8Coh0/YDoX5eWIBILnB6rkqO9aOJKzbTAJEfWmYk=;
	b=pSA5cPD9rcZeP9JbNj0OjE+7T+zZ6AicUyCTgOyP/4z0R2/0VX7iMoDRUfu9um0rITiovw
	/IUoxSxyR00TT0wj8aNKluGOHWI9QrIBTMIqHE0kVuWGiBNAfgOXZgtp00vZukWvOhiRch
	aYXZa+kcS1NoReeZ4/zp/oNi+A4VfIU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SW5Xw1L4;
	spf=pass (imf15.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2744433C5;
	Wed,  1 Jul 2026 19:53:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA4B1F000E9;
	Wed,  1 Jul 2026 19:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782935591;
	bh=Btp8Coh0/YDoX5eWIBILnB6rkqO9aOJKzbTAJEfWmYk=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=SW5Xw1L4n6km0go7iiQIUMhYp6NAfj0RV6eYQqCVHodCALEB8dTOYsfQaNULAMbqI
	 xB7nUW5AdUfmj/kfqGM0ge94GbUCCvRDC/EQnSopZqdpLC3YWJPU3hhxzoB7TiuMXK
	 rgwksGyFQDkLQ4L1Zv//reedGipqwPdRgCwYfIYn7SUowcW/xIaoKQgA7tLYyowF21
	 vtZqvsjUt5lA/qYPA9GV1RiCdmGczJhLUDM+otUG+k4cTl/W4Sjha1gMK6icACBU9B
	 4gKGJaZ253aNPnE8hxuMfX5mHW4TnINK1IFn2iP7EiwQlNNuW7HvzKuCaOFexbJrlV
	 u/4ONeNo3HSXg==
Date: Wed, 01 Jul 2026 14:53:10 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 dri-devel@lists.freedesktop.org, David Hildenbrand <david@kernel.org>, 
 Yury Norov <yury.norov@gmail.com>, linux-media@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
 Simona Vetter <simona@ffwll.ch>, linux-trace-kernel@vger.kernel.org, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 linux-mm@kvack.org, Russell King <linux@armlinux.org.uk>, 
 Will Deacon <will@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
 David Airlie <airlied@gmail.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 linaro-mm-sig@lists.linaro.org, Heiko Carstens <hca@linux.ibm.com>, 
 Sumit Semwal <sumit.semwal@linaro.org>, Thierry Reding <treding@nvidia.com>, 
 Maxime Ripard <mripard@kernel.org>, 
 Thierry Reding <thierry.reding@gmail.com>, John Stultz <jstultz@google.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Brian Starkey <Brian.Starkey@arm.com>, 
 Mikko Perttunen <mperttunen@nvidia.com>, Michal Hocko <mhocko@suse.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, 
 devicetree@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>, 
 linux-tegra@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Conor Dooley <conor+dt@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "T.J. Mercier" <tjmercier@google.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, iommu@lists.linux.dev, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>
To: Thierry Reding <thierry.reding@kernel.org>
In-Reply-To: <20260701-tegra-vpr-v3-1-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-1-d80f7b871bb4@nvidia.com>
Message-Id: <178293558945.1610040.13281502080616690110.robh@kernel.org>
Subject: Re: [PATCH v3 01/11] dt-bindings: reserved-memory: Document Tegra
 VPR
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 43596A0005
X-Rspam-User: 
X-Stat-Signature: jpb7ssfmgjf5qbmamhpjxusmzigxju3t
X-HE-Tag: 1782935593-355260
X-HE-Meta: U2FsdGVkX1+XMBnq5dOnJMTx7btRqQYF6lT4T2UqKpLjX6WuX3XhSS4bqQElfHWZO7h2jBa99qeO8idaWmSLJanoykvFyK+s8S6rWZvkPSPgTh/9+7CO+trX+9yzt/JAi64FHkLxnaty86p6v4Fe+Zxa1rnYGvjZSyRcACPoxTeRMVJm6KcU/qK0NyZep3u8bSkGFpQq0Okk19sBv8uW5LNvKKccxVMrINeXClYiU75DSsyiajNU+YtppWQtVxlw8NaJuMq3IvwTzBEMflukwijxK+8UowyfhYyusQfMRBqemTEJ+eaNgrkUVpMok5xKbZbfOUw2UkY6BavwwuQc6vjhknKtpjzr4qh5ov1h0rWL6jalkeE2jnGXLmxIvTnXzeqFLOMF6RDfBHLzCWa7dfwtFfgarqBY7B7AZO0UNsVDDfkHpGLlOOYkPCQpzRNb5Eae1qDjcNE3lrdIKeCZ4LRg36uZi7wuDWb4X8+KNedXy+nE5LNqdW8fXpyeHxeMFo4OYWrC7cJGHWfi5efEpN2HK+fgGX0ZXdHwUod92B2dCjA8WuIqDyHuf66fUYyCNCV2qA2w7Wty0rAJR++UrXWeg+egTIWI6yA7lJ9Ibox4vIua+YjdQXKP1buoWRJBYveYUJy43NTyb87ivr9CRQYSv5rNOY8pQtp/c3Drj0unAGnKhGmGfV6vZibIgYFaPXzn5JAor1z7EmC0Mqco8egGLOLSgiQ2oyft8uC4QPAAEbdmhPtq+cUAvOhcPYksPTTSBqF3UXIwKlbMBqyrbyazPedq7jxE7WGdPW/B9U0Mnu/hG9G9dQLfaGQbwTHUCdNvXp6f5IwAx5el1YvW4Fd94Q+rqLltYMhMjfPc0Dvaet7r6gDef1FmUmP700pmbNWvKB6GdKdFIPSX9/T2SzL+jlYSV201U88vzejrbs8JbBk17ooTBd0gV4N7r1FgeQFTWG1hmkXayGsbacX
 oaVAMya4
 IJ2OmcJFIRMcvWndhPlz8UVNaBs5aENKze3+9t5dXPqz5NqMQnDYwDNu8TMF6bguSzCQGbhs+BU2KjXC9uPmslA0ntxmooTbpoEkkp74jkxGsXHz+/biXvJq3vnhaoZHHppKyezQPjONrerX6Vgil7jDZNrlu7HPTCP7QEC3xVguHDpKbbVwbvXjiSA1beA54iVIxgDPQDfMR/lbn6EbgReooCOmnyqfVziclK0X/AsJuENlrwtI2XD9WhgzBq6yVdmxCnBN8upGTplHg42HDQGtW4GZvCqna0dMAg8vRL2QPYm6SaeQAyZlAiJu70AeCgm1NR4/JkazU78gSDlWNP7fuV+I4mKuFDVdvxpIWuFC7WVHdVrBljEy3pVeBsY9jTsHPX+H7cJ+IKTjVla1MLukw5AhPiJBGFZ+GzPOmj5SI2kv3XzY66N57zhWpn7GuUwV58Hs4oXE/HuuL5VKnnd7WNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 01 Jul 2026 18:08:12 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The Video Protection Region (VPR) found on NVIDIA Tegra chips is a
> region of memory that is protected from CPU accesses. It is used to
> decode and play back DRM protected content.
> 
> It is a standard reserved memory region that can exist in two forms:
> static VPR where the base address and size are fixed (uses the "reg"
> property to describe the memory) and a resizable VPR where only the
> size is known upfront and the OS can allocate it wherever it can be
> accomodated.
> 
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v2:
> - add examples for fixed and resizable VPR
> ---
>  .../nvidia,tegra-video-protection-region.yaml      | 76 ++++++++++++++++++++++
>  1 file changed, 76 insertions(+)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.example.dtb: protected@2a8000000 (nvidia,tegra-video-protection-region): reg: [[2, 2818572288], [0, 1879048192]] is too long
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.example.dtb: protected@2a8000000 (nvidia,tegra-video-protection-region): Unevaluated properties are not allowed ('no-map', 'reg' were unexpected)
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260701-tegra-vpr-v3-1-d80f7b871bb4@nvidia.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


