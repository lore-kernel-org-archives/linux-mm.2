Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12D6ACA1011
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 16:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DD488E0006; Wed,  3 Sep 2025 12:45:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B5078E0002; Wed,  3 Sep 2025 12:45:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CAB98E0006; Wed,  3 Sep 2025 12:45:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7078E0002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 12:45:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6107863AC
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:45:30 +0000 (UTC)
X-FDA: 83848514820.17.C4E689B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 583351C0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 16:45:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UkWhlLvR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756917929; a=rsa-sha256;
	cv=none;
	b=RLdvo+oX4RcgOiS3RIV6aW83EqSmOnm3ZKshzds7T7IMuKQN3lvUvvfWhxOxTvXVVp2gY4
	niCXRkiy0uZXSxZpRSUmm6Y0KGtOpBWfcmzBnDyJ/S2HV0Nxt+16KibrovwZSe7OVtYBzp
	XQfluKSmouKFHAo+1YHEf9DJRvQslho=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UkWhlLvR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756917929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GNjz6ireZy+p3cAv2x37qZF4cjRqc9AMo4/Pb+kdJcM=;
	b=R0HRWgNScj9tOV6MWuIbJyVqwzpqTjchua34V57/JBZSUSli0gvyqLHLs6Ue+faU/lyBB4
	nEeBbjYaS9fp7IR5co1TZutohBqT4jhq0CJxSRgXqfxvvE0T4i3pWRGU+ruCk2oRKAwNRO
	CWJ2JPoSfEkyRlflRTC71vL3zrz/q0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A71C46013F;
	Wed,  3 Sep 2025 16:45:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4FCC4CEE7;
	Wed,  3 Sep 2025 16:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756917928;
	bh=1QCnhHk4YrbcljgZa4CIM09QqYheSpXKbkWo83aUiBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UkWhlLvRnJr6ayb4Mng7/14tuavR02NoAo9XeCgTB/5K3v5y26XRy3pL1nHIvzpVo
	 Dn38VyfEu5u4ggHiuf1rlqoblQScmF2gjYxPS26gnp/84X6prefSXBDc4SGcU4jVmV
	 GgByW2YTigHjEiJ5pghcpSJ6FL20HQZZiwYDM9E6Is2l5xL/z2SlqQrmZyd62mHfef
	 kHNH2kx4gOmI+ozktvajibFsYx6syJhF5oL43UkIn1HNWfgVDoQJx6Fyv2lTYgnXUY
	 Y76w5eD/VP6VjR/Rgij0/nEUdUcV+LE/WBEqS2iY+YWtX/nGpN5ubrn9oP9U7/I1j0
	 7bgomSEmNytEw==
Date: Wed, 3 Sep 2025 11:45:27 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: "T.J. Mercier" <tjmercier@google.com>,
	Conor Dooley <conor+dt@kernel.org>, Simona Vetter <simona@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	John Stultz <jstultz@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
	Brian Starkey <Brian.Starkey@arm.com>, linux-mm@kvack.org,
	Mike Rapoport <rppt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	devicetree@vger.kernel.org,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH 1/9] dt-bindings: reserved-memory: Document Tegra VPR
Message-ID: <175691792593.2483010.8132765871876943036.robh@kernel.org>
References: <20250902154630.4032984-1-thierry.reding@gmail.com>
 <20250902154630.4032984-2-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902154630.4032984-2-thierry.reding@gmail.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 583351C0009
X-Stat-Signature: ypzx8m9ya8ij7ih7p4txtrba8gw3d5je
X-HE-Tag: 1756917929-165449
X-HE-Meta: U2FsdGVkX19KtfN34Bnklg4cnKmwWHv/+qWjHbI5RKVyppYA3/o1pxyrrz7RrDYwlFt1X8q3yg7fNwWe6uZwhUBwUluU9tJ7KPjSQqqBlv9Njl+LFVCfp87XqfD2hKJT9Au1oG3fY2zW7PH+Q5K1yMWt+SxsfCfQYPq6dxe8UgMbP62osAavPcxjnn78nr23wUaWhfn2zmdRa3QyAlEzp9kL/hyiV27Gcohxvwpq4joJc6K///dTDxUyVPHOQaTSslTha8CFVYIXliPrO31JhqT9x/XHOFThxG4ux6a75o2fXgEo64ZBlZx/43XYHGL4pppEua0JncZOa5Hyimm4/3WgUr7Ibha0xI7IJM5OIFeUZZNiU++ZI+vYK76kIlO4Bw+nk9Zo3MihckVDS2gvZkBhagSNE+0EODyz9VbMlu5ecLOobGG65bW36Ua+c5RzPNJ7mZ490hWlGm0/V4IWkR0JNTPrMeA36PC0xiCYZ8pgZdnT5jpXmuKTAhD9e9HTjRbvSrcTTqJpOJpnubR6bDOXtG/7EShg1+xmLwN7FBdWf6ueUGfhB2Qs5CYvnVXLKkz0mkKzFk5q4jQF4zhzWKMWC0bOrMGRcAAzqWuRUIMV3+IpQEdRx45f16wEzLEb8Ua3o+wzgLzKNDURj8RWAew88IgY10LsZH14AK0WjlNz1Yzoo45hYuxebXL9gYh4m0V8f0VMN7tEPGddz7J211TZ/a8Lom4N0CcTuO9QtlyYNbN6Nz4BX2qWXt8DeRo1vKts604TLGjH/S8Lhe9tbxbs10lY2pRl65GLUkWvkw2wcFU+T09HdnSzFsBVhWH24Po3aY5N2C9kpOS+fPqREGSW9+BkVRsqKfPfPkoI9WWaqjXgzBz+8cGn+T2+2f2eo4VW5RruSEhlS6YZ0goUzaKPvHnRYlboF8Qn3hec+LbzYKatLNuzoXTNtGIAlqS9oZOI/HCAXoMl11JkI3y
 DDTf+lyG
 1Xk3wUAS3IiUZPgpJq+2xjXDCcZkryi6EYKqJqUgSWZubTVMnokBzTjYnDzNaUCtIE8V+tGZfNTPe5bczs71B5m3w3AchgZ2OPuODPsxOGhuQNoChezLOQ0+TySysnrqQWzbG2MpagW0wY/llHKjfbu95gZ/nZjO06iHh8zw8NzzUWYfSGcpIaAQwZesPXVshYKG+G90x5MzOh90d3dYOwH36gOD6v56Kc031zLmEPdmnw+kmxWFQ5/p9jE64SpBAsm6ohFeDTySW/FhCe1BF9OCyVQfNVZ0q9SmA8iAwHR2u36QN8Ai340j2aGi+I4NxO99k/doqW3AVz5KRDQRPjeCFAiB860Wg4a0h14oeSnhY5F4+Ne8UTZjb0A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, 02 Sep 2025 17:46:21 +0200, Thierry Reding wrote:
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
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  .../nvidia,tegra-video-protection-region.yaml | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reserved-memory/nvidia,tegra-video-protection-region.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


