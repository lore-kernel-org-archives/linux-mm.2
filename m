Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C80F7C624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94996B0092; Fri,  4 Sep 2026 07:41:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47BC6B0098; Fri,  4 Sep 2026 07:41:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33906B0099; Fri,  4 Sep 2026 07:41:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96BFC6B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:41:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1C785120E42
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:41:22 +0000 (UTC)
X-FDA: 85175889204.08.848FEBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64B97C0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:41:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiADOeqn;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788522080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVcKEaA4QKNBqPQxG7kCkdRB1jRFfjMN2gDUjmG9sC4=;
	b=d5wxuvckJ++nl+lI8OQo8f/dVHjZwdImNzu7+G5m7dFURvZCwkjUcgWFiQwqoRgkTq6Q6+
	/Ntu1dzKg4+2TKklmiNBU2rVyBsQ0PvtrNlN81QCxvGU5FMqv/cczpXk/SlsE8K8oIetVg
	7ePkEtFOBJgaIQch/xdHt+iVzCHVxb0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788522080;
	b=ebWZwk1XJ+gvfVdImz0ivf8UgczR4dt54NmqzoAJJ5ucMOfl3qjjxF6F8BIaOHuB+DeCVu
	m02XDjdtd9uQFD3XEN+TV5rzDuhxJPyItrKW6BOp+rVfVB6V0WkkCusOVlUznjTS1+0bFX
	X4ZH+8oAHdGjpBqKlZfjzq981WpNV74=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AiADOeqn;
	spf=pass (imf28.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F6B043E76;
	Fri,  4 Sep 2026 11:41:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6381A1F00A3E;
	Fri,  4 Sep 2026 11:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788522079;
	bh=AVcKEaA4QKNBqPQxG7kCkdRB1jRFfjMN2gDUjmG9sC4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AiADOeqnGMHeLkfaGNji1T3Dj3iV1UB/ASC2xLDgi7AfO3Xx5O8iq6YxSwXlm2j4e
	 +kp9dklRJ7+iqSVX2PJ5wPUaOLeh0xL3AG7uZXSajQB8Ueai6Q/MwLs+2KsniKywT4
	 ng5I34uDzQcmVKk7eyz2TXtpx4Ht+KP87LPZnCDOBaW8k2Rs8suvD9hMRM0s3nI03H
	 khymos7oQULP1MD/xvWmlFFMgkHQ9XejH5YMHiX3uh0rmk92ZYbQ98AlvpLzDSohTg
	 v3IUX38C/8KGCNvpFnTzHhpBe9kqorbNRNmkYYevlia5fsjiGh0O87jfvbAnvMeM0J
	 1APOUvIK5UabA==
Date: Fri, 4 Sep 2026 12:41:05 +0100
From: Will Deacon <will@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Russell King <linux@armlinux.org.uk>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chun Ng <chunn@nvidia.com>, Mark Rutland <mark.rutland@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>, vdonnefort@google.com
Subject: Re: [PATCH v6 00/12] dma-buf: heaps: Add support for Tegra VPR
Message-ID: <apquUWgrD9C2jWQ0@willie-the-truck>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
X-Stat-Signature: dsugjs6mccusosz6xzwwmytyomf77iiu
X-Rspamd-Queue-Id: 64B97C0007
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788522080-661455
X-HE-Meta: U2FsdGVkX18gh8m9ANo+dnzPVGR8+rOUtT6XcEAbWzkUt4N3oO5UiG0AVh7vL1a/SxVgb0zF4rKiw/VDAwXF7YrI8Q8wwtNSIQIbhAThM9tXFW8aIe6LCZI3YLPvIhlNRHCkyqJR+i2NPMhy0BZeEHnYI+siweonvdOMzp5u4hUA5OcszIc3ZuTugvpgFe8/cFH1kwMIihhLKhbeC7e/umHQjc0nU/aTpQFzSeU598fCQsJ22ElLLvCiVGbvi1qIEs8DoZpwHFKg2+ctS4qh2e2Goqtqetx/vVcv4Soq8LKJg5P7k/OEBzkzgtMdFQ2WdmOvWsoQBetCvIMrUraroHMMG5ihpKpedSnJ5xe2cjFHbAtdk+8PCbdFh9tEZeDmdFHkN94jUc3agaXOIekSmd6dRTJ3vLlZvGPPhhVxfDSPcsbU1Ey5rRPrKJpCIxhJ94xnITrdFiQVn6SD10EK8paRABWmbsO0mzuhY02h+EDd1WEH0LsRIxbu4O+Lks3cWwXCNfZF322S8Nq6Hl6yxjBH1sp6RDHTHC50GXFx5fNzaWpPcj+L73uDRDtJt75X/GDdkHCuStw0PIEndSWbb9kG0hGaFQB0PsElWx7sz0cqjlvtBdBqYLnTfQ3op0RGakq3XOka0U1jLYE7JZ2AvkmS012bbRJo3gKLD3OVp2iobE24xpyfKpkWkRYj5WmqKjtcre1ZwIzorSZtvjl39R8NR1GrcP8fz9u0tih9G1/nkXHKSJjGHKbBZJY1E/EOBFqnefiBS5EkMF47zMjUkVJu8Dhig2MJ6eLsoQ+BiXn5JNUUBczdTzqVzyztAW/rpDl12vWKaIXJa9pIQ/GHCYnkK1ci3qfWKtojV0kHx5sRMtUdFgGuK6aEBz5JNlqzF6vmFD7h/YSweTJmvoqSAxGivOnMIl5493jSDnoXrJLPoPLzrTGlk/Z7qsQfx6TJh6qtjk8IbXn9EDKI1lk
 gVXSeoLn
 l+23s0Ey6GFrP8XiblkL3hzI6Hssi+lgTYXwmhK+164rVfbJpz8PvYF+bBvtrsxOXairCn83HTW8MJyIyXsaoMB4GB/B/HHENbl28kBkU6zB3gCCTyXEJz6kWhfEQ1uqy6GrUIm0j14v4qKDwlSZ0Z4dmvVNbBtZdZfRZdPTUFtqOMOedo06nVRRaKYz5zUiDZApFof7kvDMqS6KmX8U5/S7q9pCrJO6jtREI511+cpXbjG4Df5zZ7Lkmfv01bWTtXJRWNq7TM8T7Wb9CmuISkHO6o4urNBznP2ZS3Mex6GQovAw/NS7LKCbzcm42Rs8tZt/5IKwmFNuvtSezUK823UIpXp1aLXVfci47+IBPXIZ8fn0qlprTTcyv5hNMD3mi0OKjNwUE8K0RbALJig7AhN2xkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Thierry,

On Fri, Sep 04, 2026 at 12:44:51PM +0200, Thierry Reding wrote:
> This series adds support for the video protection region (VPR) used on
> Tegra SoC devices. It's a special region of memory that is protected
> from accesses by the CPU and used to store DRM protected content (both
> decrypted stream data as well as decoded video frames).
> 
> Patches 1 through 3 add DT binding documentation for the VPR and add the
> VPR to the list of memory-region items for display, host1x and NVDEC.
> 
> The set_direct_map_*_noflush() functions that will be used later in this
> series are exported in patch 4 so that the drivers that use them can be
> built as a module.
> 
> Patch 5 adds bitmap_allocate(), which is like bitmap_allocate_region()
> but works on sizes that are not a power of two.
> 
> The of_node_to_nid() function is exported in patch 6 because it is used
> in a later patch adding a driver that can be built as a module.
> 
> Patch 7 introduces new APIs needed by the Tegra VPR implementation that
> allow memory to be allocated at a fixed offset within a CMA area. Tegra
> VPR needs this in order to implement its own allocator on top of CMA to
> meet the strict hardware requirements. This replaces the dynamic CMA
> area creation patch from earlier versions.

Did you get a chance to see how this could work with Vincent's series:

https://lore.kernel.org/r/20260902104712.2399797-1-vdonnefort@google.com

? I think that should remove your reliance on can_set_direct_map() and
mean that you can retain block mappings for most of the linear mapping.

Looks like you forgot to cc him, so I added him here.

Cheers,

Will

