Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C642C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 22:34:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D204D6B017E; Wed, 12 Aug 2026 18:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7CB6B017F; Wed, 12 Aug 2026 18:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0E6B6B0182; Wed, 12 Aug 2026 18:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98B296B017E
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:34:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 179D51A04E0
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:34:18 +0000 (UTC)
X-FDA: 85094072196.14.358F177
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6DE23100005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:34:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGPTP03w;
	spf=pass (imf14.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786574056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zIJaVQwgy3+phEYTr1LnspZFuRmzeHEpVwwk/PBOaCo=;
	b=cII8Ds75bj2kQVWCk9kplxz3Gor1pa2IcnCh0jg0y6OG6zaKMA8PCmCPkJQBai4Kp4ZsaD
	8Ry+Cs8HY+OpY1HWvVzqD4WPC+LIHDyd32h/iaAnW3MhfX9E7g04DM/Hiqk5UjKMwTZX6D
	lWUIB8HT/9HUmVFiWhoUczROGIb9GW8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786574056;
	b=6kEvvVdgsfwMIAU5JkgvNZihY5m0Oy2yHu3yBL/qO8dWrSbtgsZtoJrpT0aYm9qNAmGyXf
	HhhuOp1MEsEdsLHXIbRNPwnjEPA+ntoUnW3/dBaLeZWDW97hMsHgqINrLDjEOI4QCDf7Tj
	ZehVJ4ijSHPb+bhi0JOEUuVpj3tsd7o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGPTP03w;
	spf=pass (imf14.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AC30E40AA8;
	Wed, 12 Aug 2026 22:34:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BCDE1F000E9;
	Wed, 12 Aug 2026 22:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786574055;
	bh=zIJaVQwgy3+phEYTr1LnspZFuRmzeHEpVwwk/PBOaCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cGPTP03wUG80YmVMBODmbasm4ppKUGuWWZcUwvqj46epN/xQO8bSWtSuxBsSzMTrm
	 xVAi3EIOLC10qfV/rs8N0KHo3fqQtHQdL7PQ9jXzPzkuVeIBgKcwXHU3KIX+2rD14R
	 n6ah8z+Q/9HwjWNp7R/I9R0wQg4Yqkc7nhslLLwNSozuRhmUl3Vy8JXtLk5xybQM0J
	 /guRBSF2oOcCa+eBmtvEvHHraXmiyJe77EreH8uPP6jDQdm9BoLpnGwAGlm0CPZIyj
	 oMUvUbXA8fJ9m9NcDjx70rQLJkU+OPiUVZtIs87OoQOux+/pyvd4DhAO9Twdc+Sp3T
	 Op1aDi3RrsjGA==
Date: Wed, 12 Aug 2026 17:34:14 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Conor Dooley <conor+dt@kernel.org>,
	Sven Schnelle <svens@linux.ibm.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	dri-devel@lists.freedesktop.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Heiko Carstens <hca@linux.ibm.com>, Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	David Hildenbrand <david@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	linux-trace-kernel@vger.kernel.org,
	Vasily Gorbik <gor@linux.ibm.com>,
	Russell King <linux@armlinux.org.uk>,
	John Stultz <jstultz@google.com>,
	linux-arm-kernel@lists.infradead.org,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	iommu@lists.linux.dev, Mike Rapoport <rppt@kernel.org>,
	Chun Ng <chunn@nvidia.com>, linux-media@vger.kernel.org,
	Thomas Zimmermann <tzimmermann@suse.de>,
	"T.J. Mercier" <tjmercier@google.com>, linux-kernel@vger.kernel.org,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	devicetree@vger.kernel.org, Will Deacon <will@kernel.org>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Yury Norov <yury.norov@gmail.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Thierry Reding <treding@nvidia.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Simona Vetter <simona@ffwll.ch>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linaro-mm-sig@lists.linaro.org,
	Steven Rostedt <rostedt@goodmis.org>,
	David Airlie <airlied@gmail.com>,
	Maxime Ripard <mripard@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Robin Murphy <robin.murphy@arm.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4 03/10] dt-bindings: gpu: host1x: Document
 memory-regions for NVDEC
Message-ID: <178657405441.1338311.10765338394838016729.robh@kernel.org>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-3-5510d16af89e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-tegra-vpr-v4-3-5510d16af89e@nvidia.com>
X-Rspam-User: 
X-Stat-Signature: ji6fxrtihci7xg7u51g7hrrw76q5smei
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6DE23100005
X-HE-Tag: 1786574056-216416
X-HE-Meta: U2FsdGVkX1/4lCzlN24yOYIONPk3Bt5QztJVIktrFzX+GL6urJ7m0vwmzOxgbaGeyAlh+17UaPQCA89+b8L2GPO0iGQQ76ziIOhBrq3ujv6iF0Cuv10ZoSlgthZXFltiLLXUCb1NqTHZGuakFC3ZNF18rM7VplZDmKvRuYetEAlcu3YSRFtUH7rTCcDUvue5sHmGUEpf4ol23jkvaLjDlS6Zn00X6yLb8SAUn5+YnbCZIYWBq9db2WPJnjOoGMHFa8sNpHvsxkMCHwzqINo1LW9CDhQEOwwJCsCfXLUzNshm7F88HrPOdREPD2S2Y0vkrGNnrDYV3Ou2uwP8DBwOntl248jFaYXu+xGecp+pZepaIZFg99CqPbAxbu19G+H10phN0bY5Zq5lEFrp5lwvjgfgmXXGDSwlXcvzm/tyrTF8u7AzPJf8OYjrpOvqwBgahbOzpwiuOlWnMp0iwXpAaSFtdsYqE8eMrPOVRuJrE7qgo/scU0kjPyUrPjGxW1f0QS+Tddn4A1Z8MKMECb7h3miiR+WMDE6phj8Ylded2w7YeBlbWLzYKRHVOXlcqPd7bQSspWGuGB/mMKZlsLoJrJ9mOhSEclagCLyW1yzeqwCIpYHhhXj/lKIXVx/RrvhUv4OSVd5HACqPKcrFRKE/f9WMqAatCysmmLeJZfYTJqtpJklSEjHQ5lAFE63/Y8NGPfiR6m5e+TKeDKhBWn9y/BBKEoTdK/oq5Msj/bc6yyzNYgBto/XdnaSz/K+LWg7aUQw77/PhAqDVzF0tHoEb12iLHVc2EWLuoCMcE3wlx/ZO3DroEnP6+cLFzGv5gqGgx750nJNaCn3BvVZyObFdKT44UZQM59+5cQEeOje6vYoDk0nvNO2trloupHXEIv7r6OXZwsk85lWSz5L8rxWLpA4K54lql2ptnovQi3Ryrm0ZijI2pVZnbnkzQckzdxxGluaFw21x3brbQJ8eY14
 cbloXvLY
 TL97HVTIkbFRL7eoypTeqiq4ThVS6s/eoNByzMKcFg1AJ34usDqi8g4H6bHU7INU86Nny6EDA7ILlzFT7ygfMN35HdEDC1sDpoXV0iYcsYN4SfQCQmTtBpzE8JU7HPgo54tWBHsNekB/NsYyM1/mHywRbgKcEFXQvFAcfwCaVsuTL1UpE6irF65N1aU9tX3jKZ5GBylr3MXG2DPvz7glJN1AURI8KPsrfoGBOD68SFid6wHyWoN09vs/+VnV0En7gm90/xRjwdGd76NQsBSGSxsHANEgpkFAyhbfG2mrGQHZdEA02INe8sn+TVaNVRyxoAegDEQb+BHxP/Cj5Y8zTUXpE3Y1zLgXxBt+25bm4urZCLHgnz3O1/ZBNVIK5agaPLLImDqry1bB2VymUXG8ZD1kvGI3/mGlyAlqvSeVO2zso+G41+Ocjxl81hQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 07 Aug 2026 17:54:23 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> The video protection region is a reserved memory region that can be used
> for secure video playback. NVDEC can access this region to decode images
> into securely.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  .../devicetree/bindings/gpu/host1x/nvidia,tegra234-nvdec.yaml     | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


