Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53276D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:07:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 994506B02E6; Thu, 22 Jan 2026 13:07:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941986B02E8; Thu, 22 Jan 2026 13:07:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877D46B02EB; Thu, 22 Jan 2026 13:07:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2EE6B02E6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:07:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2FC8C590E5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:07:18 +0000 (UTC)
X-FDA: 84360381756.11.737477F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 79770180013
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:07:16 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4MgO7ir;
	spf=pass (imf24.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J1iah2o7/LzvIl+W22dB5OdIx1VbHVSymKcC8M2ld0M=;
	b=3/kSK392VaconO0V5r1gK7gA9D0dQSUrfgeTJuMRtB7R0KOlI4O7o55p8U4ZNNwkOmXD5M
	CjgWL9sQz9nr+xDk7MhIHO3pZFnLRqzTDVn/wqhhKd8HSSkKht+WOp3UaQDR/j0mJlkxq6
	fAFu/miuUS/MWvxMqE9WwIZ1dkRuSAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769105236; a=rsa-sha256;
	cv=none;
	b=c+Nz9il59ojDJ+6zMexH/TFQqkNhafeGyFn3AWi9cwg96KOVxsjflXz4GP55YrI0H0hdjx
	0uk2IZ2miPtCT00L0AlCIKxsjhP7zVr9MkZuogKajSAgV38QJc1b589Vjg6+FSddfvU0B3
	V1CwN3vrXGrJ5AHS/AZ3rTO0VckjCRA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=c4MgO7ir;
	spf=pass (imf24.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A57C2600C3;
	Thu, 22 Jan 2026 18:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341C7C116D0;
	Thu, 22 Jan 2026 18:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769105235;
	bh=wN9ZCmjUsgfm4qkKjFTDF64YeJA5BNp7YAJTNuGgBb4=;
	h=From:Date:Cc:To:In-Reply-To:References:Subject:From;
	b=c4MgO7irYFYpWutLr0jQKY0uG14Vqd4Y/5+kkzg9eaGXtd56moCVDxGqPKiepWBth
	 QKKK5QmGYbs7p1OgqhKnF1tCMz8p9C3Y9m/jDkESZoIh+8C5H1KXSA4tOK7dYDPpwO
	 +eNOn+ODS83WwbgX+ofyDqd35rV7WfjoddjsUz0hJa/6YHobjeC1/fm1xWJSDBt8LS
	 /tN278Ak1fBKL8azaz3kyPlindBX+8nxnipLvX0aw4YASoMIoyjl4lSE2FE/gsZe7K
	 KFJIXjZp7X+DfcW3A0f5H3fyk3U0Vbo0XRh0bJ75o1nyA15lU6Nwx99NfFJ0PlyW6K
	 L/nW7xTaA2aTQ==
From: Rob Herring <robh@kernel.org>
Date: Thu, 22 Jan 2026 12:07:14 -0600
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Cc: Conor Dooley <conor+dt@kernel.org>, Simona Vetter <simona@ffwll.ch>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, 
 David Hildenbrand <david@redhat.com>, 
 "T . J . Mercier" <tjmercier@google.com>, David Airlie <airlied@gmail.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, linaro-mm-sig@lists.linaro.org, 
 Sumit Garg <sumit.garg@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
 linux-tegra@vger.kernel.org, linux-mm@kvack.org, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 John Stultz <jstultz@google.com>
To: Thierry Reding <thierry.reding@kernel.org>
In-Reply-To: <20260122161009.3865888-1-thierry.reding@kernel.org>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
Message-Id: <176910484137.3006995.3850336645613910946.robh@kernel.org>
Subject: Re: [PATCH v2 00/10] dma-bug: heaps: Add Tegra VPR support
X-Rspamd-Queue-Id: 79770180013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: hwsa4tbiqg13gx4skx46g7fjq99b46xa
X-HE-Tag: 1769105236-212195
X-HE-Meta: U2FsdGVkX1+SiJxT7nQQMrpbhmxxs+Z78RhUL5zzuw3H0hWzADk1NLa733PWIB+tysK5jLVtaFFaeIGB6SHugezlqHMU+9eMMc1EMrSt0zfWL4jMc8kGO6sJBw+phpXqaffWToDVllJMM+QOouIn8O/TtnAb7JW4kr5olGcSyfdp9K6qVq2ebn9wmWxNAT5fuxLW1anwHEFsvMmw7dK094tS+yo0Kv/suJ2CvZC3eQcoHtY/Jk986X+Nzq0GsPcjA8UcPJngH5EcaW7QgURu1JrdNnc4umN7uYPFhWL/edgzHj5D1tQfxvijZZDeeSDrS+/slYYFvrP9irOWzWdyMqaqwzKBQHc9KXRyd4SUpZtdBBjMgvDAdsB4hblg2AcnVpou/iE82xNTcmHsB+zFaPFXFpfV2ysJYUit7xEBBdBNOnIZlSuMgKypH/0Es0Li6GGDNWvZR+lW8plP21Q/Py+NzhXwESxCdL+nBWRQcF83HoPZzjJLs3Hu7EP4u5uV5UBpqWe571jLlbeJVZm7JrdWn5Hb/8A3ReCRtkozaQs8uuSK+5HKE/8waj2lPtEPHmGPwQl9oaFYIvrjxmVWzQF7g03YYPVjaDNSl+ZkBIwi/w7USYJMsHZEUTXdh2K5LlfGocisi+KpFD69yJgExJZ7CoO3TnRNIQq74TPQS1qDSC+6456zKRvd5ZbSGG2TVSOJNt5bWe2d5OS3EJcOE+ZxCQXuuja7gWf/0jUCG/m1e4KdGWIp4IXU1U02TXwHYx0dFcEDuO7nmeFasVEP5KcNh4i0mpRprN8OUNkQQ0VPA5RrGxRXBhI/jLPEThc/P5YSM/93UcgBDcok6iaIdU1IJLSTPuNShov63w2SzZ2tbWskzYVRvWUCrnHogcMtOgMahMsCjN90tXX1yRlKIfw6m3Aw10vQFc5JlgQtkXDEUS6HEWbqQ+ODu2CvoP5YTZ99NaGuxe48ypiaVnA
 eflRxYi9
 aERNkehAQPxuz8WJXmK6JV09u+Zv/OwIEqiD7qSDPoMHF+MaaMjcRI5Ey+xCjPFmf1lIOIMYo8vGDMpd70ctEm+y70+4anMfLdXSdQsgTRsSMW6RPK7js01Ffrawf+K3Bw71Ev4aFRKEo+lDmsLUe5Yb59fJ1LM6WaxN7oTAJQDd2jCUAcCWEYvIWP3XceYVnxJY4yxzADbhJKf15sUy4pS0TEbW8TARKcULjVxTaUlBpQd59ifFpeb+vrQaSfJO+sNRedzlhfLqC3FY+NN7cW80gdF5ImOACYx/BoKy9OgljgfvHgScXSbIhe9HEku7BwyMB2z0a8GaxwDBhv/Fp6GMnBr35kRutsIszRLUyywB1vBgH0DhCRxI9EHB0SZ8pRxbFOmIyMsnx69OZXBfwCbfnMCjMXaBkHmes7HLjO5pfnMsFe4j+icEqmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, 22 Jan 2026 17:09:59 +0100, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Hi,
> 
> This series adds support for the video protection region (VPR) used on
> Tegra SoC devices. It's a special region of memory that is protected
> from accesses by the CPU and used to store DRM protected content (both
> decrypted stream data as well as decoded video frames).
> 
> Patches 1 and 2 add DT binding documentation for the VPR and add the VPR
> to the list of memory-region items for display and host1x.
> 
> Patch 3 adds bitmap_allocate(), which is like bitmap_allocate_region()
> but works on sizes that are not a power of two.
> 
> Patch 4 introduces new APIs needed by the Tegra VPR implementation that
> allow CMA areas to be dynamically created at runtime rather than using
> the fixed, system-wide list. This is used in this driver specifically
> because it can use an arbitrary number of these areas (though they are
> currently limited to 4).
> 
> Patch 5 adds some infrastructure for DMA heap implementations to provide
> information through debugfs.
> 
> The Tegra VPR implementation is added in patch 6. See its commit message
> for more details about the specifics of this implementation.
> 
> Finally, patches 7-10 add the VPR placeholder node on Tegra234 and hook
> it up to the host1x and GPU nodes so that they can make use of this
> region.
> 
> Changes in v2:
> - Tegra VPR implementation is now more optimized to reduce the number of
>   (very slow) resize operations, and allows cross-chunk allocations
> - dynamic CMA areas are now trackd separately from static ones, but the
>   global number of CMA pages accounts for all areas
> 
> Thierry
> 
> Thierry Reding (10):
>   dt-bindings: reserved-memory: Document Tegra VPR
>   dt-bindings: display: tegra: Document memory regions
>   bitmap: Add bitmap_allocate() function
>   mm/cma: Allow dynamically creating CMA areas
>   dma-buf: heaps: Add debugfs support
>   dma-buf: heaps: Add support for Tegra VPR
>   arm64: tegra: Add VPR placeholder node on Tegra234
>   arm64: tegra: Add GPU node on Tegra234
>   arm64: tegra: Hook up VPR to host1x
>   arm64: tegra: Hook up VPR to the GPU
> 
>  .../display/tegra/nvidia,tegra186-dc.yaml     |   10 +
>  .../display/tegra/nvidia,tegra20-dc.yaml      |   10 +-
>  .../display/tegra/nvidia,tegra20-host1x.yaml  |    7 +
>  .../nvidia,tegra-video-protection-region.yaml |   55 +
>  arch/arm/mm/dma-mapping.c                     |    2 +-
>  arch/arm64/boot/dts/nvidia/tegra234.dtsi      |   60 +
>  arch/s390/mm/init.c                           |    2 +-
>  drivers/dma-buf/dma-heap.c                    |   56 +
>  drivers/dma-buf/heaps/Kconfig                 |    7 +
>  drivers/dma-buf/heaps/Makefile                |    1 +
>  drivers/dma-buf/heaps/cma_heap.c              |    2 +-
>  drivers/dma-buf/heaps/tegra-vpr.c             | 1265 +++++++++++++++++
>  include/linux/bitmap.h                        |   25 +-
>  include/linux/cma.h                           |    7 +-
>  include/linux/dma-heap.h                      |    2 +
>  include/trace/events/tegra_vpr.h              |   57 +
>  mm/cma.c                                      |  187 ++-
>  mm/cma.h                                      |    5 +-
>  18 files changed, 1713 insertions(+), 47 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
>  create mode 100644 drivers/dma-buf/heaps/tegra-vpr.c
>  create mode 100644 include/trace/events/tegra_vpr.h
> 
> --
> 2.52.0
> 
> 
> 


My bot found new DTB warnings on the .dts files added or changed in this
series.

Some warnings may be from an existing SoC .dtsi. Or perhaps the warnings
are fixed by another series. Ultimately, it is up to the platform
maintainer whether these warnings are acceptable or not. No need to reply
unless the platform maintainer has comments.

If you already ran DT checks and didn't see these error(s), then
make sure dt-schema is up to date:

  pip3 install dtschema --upgrade


This patch series was applied (using b4) to base:
 Base: attempting to guess base-commit...
 Base: tags/next-20260121 (exact match)
 Base: tags/next-20260121 (use --merge-base to override)

If this is not the correct base, please add 'base-commit' tag
(or use b4 which does this automatically)


New warnings running 'make CHECK_DTBS=y for arch/arm64/boot/dts/nvidia/' for 20260122161009.3865888-1-thierry.reding@kernel.org:

arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 263, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 263, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 263, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 263, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 248, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 248, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 248, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 248, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 260, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['reusable']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} should not be valid under {'required': ['no-map']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
	{'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['size']}, {'required': ['reg']}
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): 'oneOf' conditional failed, one must be fixed:
		'iommu-addresses' is a required property
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: video-protection-region@0 (nvidia,tegra-video-protection-region): {'compatible': ['nvidia,tegra-video-protection-region'], 'status': ['disabled'], 'no-map': True, 'reg': [[0, 0, 0, 0]], 'size': 1879048192, 'alignment': 1048576, 'reusable': True, 'phandle': 272, '$nodename': ['video-protection-region@0']} is valid under each of {'required': ['compatible', 'size']}, {'required': ['compatible', 'reg']}
	from schema $id: http://devicetree.org/schemas/reserved-memory/nvidia,tegra-video-protection-region.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: /bus@0/i2c@31e0000/audio-codec@1c: failed to match any schema with compatible: ['realtek,rt5640']
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'connector' is a dependency of 'usb-role-switch'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-sim-vdk.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: /bus@0/i2c@31c0000/audio-codec@1c: failed to match any schema with compatible: ['realtek,rt5640']
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'connector' is a dependency of 'usb-role-switch'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-1: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb3-0: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb3-1: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'connector' is a dependency of 'usb-role-switch'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): phy-mode: ['10gbase-r'] does not contain items matching the given schema
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0000.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0000.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']
arch/arm64/boot/dts/nvidia/tegra234-p3740-0002+p3701-0008.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'connector' is a dependency of 'usb-role-switch'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3768-0000+p3767-0005.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: /bus@0/i2c@31e0000/audio-codec@1c: failed to match any schema with compatible: ['realtek,rt5640']
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-0: 'connector' is a dependency of 'usb-role-switch'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb2-1: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb3-0: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: padctl@3520000 (nvidia,tegra234-xusb-padctl): ports:usb3-1: 'port' does not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/phy/nvidia,tegra194-xusb-padctl.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: ethernet@6800000 (nvidia,tegra234-mgbe): phy-mode: ['10gbase-r'] does not contain items matching the given schema
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: ethernet@6900000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: ethernet@6a00000 (nvidia,tegra234-mgbe): 'snps,axi-config', 'stmmac-axi-config' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: vic@15340000 (nvidia,tegra234-vic): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/display/tegra/nvidia,tegra124-vic.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: nvdec@15480000 (nvidia,tegra234-nvdec): 'memory-region', 'memory-region-names' do not match any of the regexes: '^pinctrl-[0-9]+$'
	from schema $id: http://devicetree.org/schemas/gpu/host1x/nvidia,tegra234-nvdec.yaml
arch/arm64/boot/dts/nvidia/tegra234-p3737-0000+p3701-0008.dtb: /gpu@17000000: failed to match any schema with compatible: ['nvidia,ga10b']






