Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAF20C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 19:53:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E51A6B00A9; Wed,  1 Jul 2026 15:53:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5959B6B00AB; Wed,  1 Jul 2026 15:53:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484776B00AC; Wed,  1 Jul 2026 15:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9616B00A9
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 15:53:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 716B7A047D
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:53:15 +0000 (UTC)
X-FDA: 84941256750.25.5C36AB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id D4F9340007
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 19:53:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVQu4w7P;
	spf=pass (imf17.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782935593;
	b=5ZgJrQe/PxF1JQoSVbuejrgkeN8XtI68ntovvy+hb+sGLrR2IZF5zKc93jVrWg/qtw3nG5
	+52H9mrsWueQvB5hoHUQiaSdYl4Tdra/s7Eyach38jQq3cVsPaMFp0FDf11WAp5K3I+sEA
	tKCC6+otGHB06YSJqwnJvOghIaSJ+C8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782935593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fzFM+3fnKG0YLEDmBIloyOG/31SnlMJCbijzwmUNu+0=;
	b=L7pYPFmSNmG84sUk7LTqe5YBc4h5bsLc194WEcj7M7EegP1isKIbuGTjXROFo7EuhRIxPl
	aH+SoGegik/iogaH9TFPm0+CrSdLRBpF0FjwfGItK/aSZuiXVKYHki6Sq4spsRbUurZqmh
	8vN9Fg1Vuaz9jGnlwszMjRcHyfoOLbI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVQu4w7P;
	spf=pass (imf17.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 12DEE601DF;
	Wed,  1 Jul 2026 19:53:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4A41F00A3A;
	Wed,  1 Jul 2026 19:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782935592;
	bh=fzFM+3fnKG0YLEDmBIloyOG/31SnlMJCbijzwmUNu+0=;
	h=Date:From:Cc:To:In-Reply-To:References:Subject;
	b=dVQu4w7P3dCUJ5KBUDAc4q3L1wAsQVNP/nKMxUpjt8ZiS/3HdSIMwTOljW8/JVMl0
	 DD5yfBvXaIX6yid82xMVg80tHH93ROwQVaAxzACoOABqbDYaCrwrCdnMp9yQjhfmtv
	 yM/CK/nD1+sWbi/uI5coRQ1PFmO6naJBOghjrbGdQihcbAPR/R2fxRSZsHfL3/gAe1
	 dMrlH6WU1wKStdUEBTtzKgxEFvCZ0V/P2NzUQYLEfQBmrAPn+66TFX5UaD09Y1Jc/x
	 xn/7dzGPjhWgaqehG2ONJtZ4IjW23B2TJGgOkXsKOGFoAeMGU/E2Pcw/2APB/MHO/i
	 qx3e+GdTEgJqA==
Date: Wed, 01 Jul 2026 14:53:11 -0500
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: "Rob Herring (Arm)" <robh@kernel.org>
Cc: linaro-mm-sig@lists.linaro.org, Lorenzo Stoakes <ljs@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Thomas Zimmermann <tzimmermann@suse.de>, Yury Norov <yury.norov@gmail.com>, 
 linux-media@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Jonathan Hunter <jonathanh@nvidia.com>, linux-s390@vger.kernel.org, 
 Masami Hiramatsu <mhiramat@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Mikko Perttunen <mperttunen@nvidia.com>, 
 David Hildenbrand <david@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Simona Vetter <simona@ffwll.ch>, Mike Rapoport <rppt@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Robin Murphy <robin.murphy@arm.com>, Russell King <linux@armlinux.org.uk>, 
 dri-devel@lists.freedesktop.org, Maxime Ripard <mripard@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Brian Starkey <Brian.Starkey@arm.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 John Stultz <jstultz@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Thierry Reding <thierry.reding@gmail.com>, devicetree@vger.kernel.org, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 linux-arm-kernel@lists.infradead.org, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-mm@kvack.org, 
 Sumit Semwal <sumit.semwal@linaro.org>, Will Deacon <will@kernel.org>, 
 Thierry Reding <treding@nvidia.com>, 
 Luca Ceresoli <luca.ceresoli@bootlin.com>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sowjanya Komatineni <skomatineni@nvidia.com>, linux-tegra@vger.kernel.org, 
 Conor Dooley <conor+dt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 "T.J. Mercier" <tjmercier@google.com>, David Airlie <airlied@gmail.com>
To: Thierry Reding <thierry.reding@kernel.org>
In-Reply-To: <20260701-tegra-vpr-v3-2-d80f7b871bb4@nvidia.com>
References: <20260701-tegra-vpr-v3-0-d80f7b871bb4@nvidia.com>
 <20260701-tegra-vpr-v3-2-d80f7b871bb4@nvidia.com>
Message-Id: <178293559078.1610192.17087150631381044391.robh@kernel.org>
Subject: Re: [PATCH v3 02/11] dt-bindings: display: tegra: Document memory
 regions
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D4F9340007
X-Stat-Signature: iqcec4wchn6m3i4dfzcyxxmca3ofuk7i
X-HE-Tag: 1782935593-183650
X-HE-Meta: U2FsdGVkX1+stmP5H+ySYfxSRaam9vmNH8uAuGt6b1E+NqkBLeZeZ67LD2Y3WzGkolVFiA6yczU+pws5AUlrzX6xkVR/3ZlGn2O/PPUFs0iY/MvZXU72V6uRys3lvcdBoIeR77um+mEOur40bPnlSR9dN74UA8/mn6T8unY5IWLT2GdO8DC3y1czrgXwG10uxhYcy4aoJHyUmcbxgby+tyTZiJdAFriwjtCzrpMPrFvwS0uZtLH+geMAsBUs9RtxZw+CIsApK0Sz8rL6SHQUorVkScUOrpYV/XBIJmgywC3wYiHzohQftOnOaNfzuMQvL72A8kZ8ZgXPSWy8UldcmbS7NAvOV24BbBda7YJUcZcxTyYFEK0//eXAdEBZbhDIgcUE2xu0MfG35jxoGXBw1x3p4OVTSEbuaCdmLa3YqxBFKHyTXttQJTNfHZDcax6c13LZJUlBdAWrk+7r4WXvaGo/SQcxDtYOaLukXhKQ2xs9vthCFbLCvacmHzWvppT0O5WVAeBeEwaIatoL2jbJmBQ0oH1zoLtEF9g54eGsD1t2eQFK5MB2T1rLHGZ4/TAlFgF7Nv8ZPMkOLB5HxNyfS9GVbgckD8uiXSL3tw9dtm+tFYabnVvqz7TPT5qcqUtZDvxHU3NKKnxn8Su8JuyTSbTdEGPOkH8lWReNLWV5WY5TzwTw0LjIMHELA36h7WWBSJ4QHKp7OioNi2P5xRrjW71RM25L72FKPZPeN0UyOyP93WBIb6PZN34K7aOGXiuXSz2XhZiAr3w0fPI6kl4+ZX4Ed0+PaB8/PXeWWB2h0yrTBNTQK72WDTQ5oS7TtE0K2uVZYz0+cf/SSQqi3vcxqExg7lC2meZ5dQi+0DEaWAqIUruMh9k144EB53SzjOrYsqz00iNWYLmJRMCtuW7DscZhlQoFAH7aVgdCDnZcyWWMJBR0JqYaobcKLapJ9PNWTfg+KCtPFln7lUgR9bS
 ecADN64K
 UwgdbBBa/y2B1Pun0T3aQkj+lWz1jv+r3a7GTHpbmToouvzTHicbNHJWdUxxNxr0I5uXLqVTt0CzV6wIdYFb74eiCBVJk8od8/awr4V0UuJpdBlmJDQxwfH9wy/fBaZMBggY6ZxXx8ADzRkFi5b/ZfYpwnUu7WOyQFZjl/pna9DYm8Q/YRJjl5CNU9jurPLU+fZ3J8l5KSsUW3j3xH6dwN/zdRpeL26cvTDNUvh/pnkyNbXe5ONtgHq9CG07Qmp42LRnZF9QV2/54vrxgTFr78paSA6AHj2TQnisNaiKHUkuX9ooOKdeegvE6A38+IyebLFcS5kor/w7TbZC41w3CJVJA06S7CY+rnZxC+7TqRBUDW2KduT+KizP2yP6kWFBLKimvoQ2i/mtt7zCw++ymB8Rv4Azg43OSa1DrDxOu2NdMcT7CQoj86ejSoaraAZYAnRqdPL8uz0pVTA/3kBdqy/WQJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, 01 Jul 2026 18:08:13 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the memory-region and memory-region-names properties to the bindings
> for the display controllers and the host1x engine found on various Tegra
> generations. These memory regions are used to access firmware-provided
> framebuffer memory as well as the video protection region.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v3:
> - document properties for VIC
> ---
>  .../devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml |  8 ++++++++
>  .../devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml  | 10 ++++++++++
>  .../devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml   | 10 +++++++++-
>  .../bindings/display/tegra/nvidia,tegra20-host1x.yaml          |  7 +++++++
>  4 files changed, 34 insertions(+), 1 deletion(-)
> 

My bot found errors running 'make dt_binding_check' on your patch:

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: 'anyOf' conditional failed, one must be fixed:
	'maxitems' is not one of ['$ref', 'additionalItems', 'additionalProperties', 'allOf', 'anyOf', 'const', 'contains', 'default', 'dependencies', 'dependentRequired', 'dependentSchemas', 'deprecated', 'description', 'else', 'enum', 'exclusiveMaximum', 'exclusiveMinimum', 'items', 'if', 'minItems', 'minimum', 'maxItems', 'maximum', 'multipleOf', 'not', 'oneOf', 'pattern', 'patternProperties', 'properties', 'required', 'then', 'typeSize', 'unevaluatedProperties', 'uniqueItems']
	'type' was expected
	from schema $id: http://devicetree.org/meta-schemas/keywords.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names:items: {'enum': ['framebuffer', 'protected']} is not of type 'array'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: Additional properties are not allowed ('maxitems' was unexpected)
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names:items: {'enum': ['framebuffer', 'protected']} is not of type 'array'
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml
/builds/robherring/dt-review-ci/linux/Documentation/devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml: properties:memory-region-names: Additional properties are not allowed ('maxitems' was unexpected)
	from schema $id: http://devicetree.org/meta-schemas/string-array.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.kernel.org/project/devicetree/patch/20260701-tegra-vpr-v3-2-d80f7b871bb4@nvidia.com

The base for the series is generally the latest rc1. A different dependency
should be noted in *this* patch.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit after running the above command yourself. Note
that DT_SCHEMA_FILES can be set to your schema file to speed up checking
your schema. However, it must be unset to test all examples with your schema.


