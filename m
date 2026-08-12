Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE83DC5DF65
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 22:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A5176B0168; Wed, 12 Aug 2026 18:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CB66B017C; Wed, 12 Aug 2026 18:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 492DC6B017E; Wed, 12 Aug 2026 18:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CCC86B0168
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:33:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 990D5A03BB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:33:40 +0000 (UTC)
X-FDA: 85094070600.17.C74BEBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D134840003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 22:33:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxnDcAN9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786574019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHVs81CE2IQ9JD4d8n66KMCOswlVQXDqi/24OSbt1Sk=;
	b=NO9Lfdh6uHm2xecWALeLF9XmbAoQFN6R2sLGkTc+aYRVXU0ShXhaIoo7NhiP71JvcxGj7h
	aExXasQIQpvGVhhysV5b1DEqU05BhDq1SOibZIxuYaoXmxsdNHLRNED4/ycSv2//dmEKQg
	HIDmLXA4fk9mMHVXFDdKwFQIbGy6p3Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxnDcAN9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786574019;
	b=3kVK8UCF5PNRTSX0GaRscozyjA4VGu3rTKf9peSoWAoBSqyAkEtb22oecIMdQyAVlClkDY
	XUCr6HZUss2IC1qaPu18/GS0hYwFqavvbPipGMwr6Kojtw1AqmwD7zrNo4uXu6uS1PBlVh
	sdhSqjb8/M67NfWzI174X7DsAHD6CTA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD844414B4;
	Wed, 12 Aug 2026 22:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6503E1F00A3F;
	Wed, 12 Aug 2026 22:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786574017;
	bh=aHVs81CE2IQ9JD4d8n66KMCOswlVQXDqi/24OSbt1Sk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NxnDcAN9Z4zXwB8VaQ4ooTdrRgky6Q8zLm6mxJ1RjWe0Ovnre8a/4e3j/pRx23n0/
	 cgEf7TjrJMOhg0gmXjJXZ4JO3u25sFIG+ohZ87f1hnkqMiFEbX7HY4rFnFRxcBbrlh
	 tarqc9v8P+vKy7klLcouGokQZCYzNvAPTFlHUzDvkg0nGKbkA5JZXjdnJZSEsnLwSd
	 kSwV3PlOUlPY3k2iIRlibhfvsba3Q+ayHFC5C16qaWaoflAOG0WuK1M2/oFs8EbGqQ
	 7FfrFAcQJBPX6Dt+03UO4/bZ+nDwz1sfdBzJP5rXNK3BVTpjgRsNEjab5htv4BFZXL
	 /sa4Zn9VXn4YQ==
Date: Wed, 12 Aug 2026 17:33:36 -0500
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: linaro-mm-sig@lists.linaro.org, Sumit Semwal <sumit.semwal@linaro.org>,
	Russell King <linux@armlinux.org.uk>, linux-tegra@vger.kernel.org,
	linux-mm@kvack.org, Maxime Ripard <mripard@kernel.org>,
	Yury Norov <yury.norov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	iommu@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	linux-trace-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	David Hildenbrand <david@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>, Simona Vetter <simona@ffwll.ch>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Sowjanya Komatineni <skomatineni@nvidia.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	John Stultz <jstultz@google.com>,
	"T.J. Mercier" <tjmercier@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Masami Hiramatsu <mhiramat@kernel.org>, devicetree@vger.kernel.org,
	Mike Rapoport <rppt@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Suren Baghdasaryan <surenb@google.com>, Chun Ng <chunn@nvidia.com>,
	Thierry Reding <treding@nvidia.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Will Deacon <will@kernel.org>, David Airlie <airlied@gmail.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jonathan Hunter <jonathanh@nvidia.com>
Subject: Re: [PATCH v4 02/10] dt-bindings: display: tegra: Document memory
 regions
Message-ID: <178657401505.1337249.16016860893024599580.robh@kernel.org>
References: <20260807-tegra-vpr-v4-0-5510d16af89e@nvidia.com>
 <20260807-tegra-vpr-v4-2-5510d16af89e@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-tegra-vpr-v4-2-5510d16af89e@nvidia.com>
X-Rspamd-Queue-Id: D134840003
X-Stat-Signature: z6x7t4uoot4oybu98j3yx7yx3kxp98wm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786574018-314662
X-HE-Meta: U2FsdGVkX1/flXMaPfsaMoY9EuLjZCxB/o2UvjCB8Y6lqZ0CBQH07bMYPEBXlckGcjnsDb1HVetpQze5R0tkxgUnfr3g7ecwEfammHYgraiVR01fVZwkIBYYhAOhXmiT2oJMKbPy0iB7Rcooh6qKRSkxyLaU4KfMn72jQYlDiVeElhMvklYsBpipXEw7Pgjh6D9prHOoXKe7m3ajwXRrt15804XAvVmANu3X0jpcBp1s+uFjCZXR1FjqLYYWRyOYlQ8m/xczhold1gpSF0FqZUWLkR4Tq7nEEbE9xnIUKdxdlBZsMLh13FW+ZfI/MOD+9cfLCABsiDg6HFzMG1rDNfyXnW5twgUZnGeuX6IA0KpEdm4g0jq9bRwfcGW/pqAiUn2tpPVhNcZ9pnWKnfzXF0+PuiKxUy9uTB+fkxWutM+c/qnB1QXxYhx4udHgvK3KMKOyOUxE6Xk5CZfxy2qDibMKLjddMwelAxbBb1x1XNe+oa7+bnohDg5PLUYxDbk/hw9lSOysVIP7V+hX1MNM2KEE8ABetUGCIdg1YlfGLaT+LkR3ZqYHholaScifN3UySMyXB3IEZjPqDYzAWWYKtt5tJRVUxswY9KEdzm9X6xL37Pw+Nxk9prgitNtfhNrWLL0cVX/0fWFxAIfOym1Vvq1saGUOdb7vL0degwLWHgIqWRLNmTASPtFZR+AY+J6qTjXW4vBP9N/5RXT/kJyoL4VXe6gYn9rJkEs8n0IrxOsJDAmOOkbQ7lKfj4IcNOmBO72krt9TM/JxHgy2y0ZBDEsweMYnXv0iRlaXhmd6/irf6hFLuSNM+XaZ7+xidknhio38lQ4b6dxrZmpWIAiERFKzTyo5y81h46WM1bTgH7qOXmNgXqhhWAiFmzPOxaHCQ0HNjdNv5J+6S3gFNl3BB2BU1rvZDUnt+Mb661Eoa+qmbp5mkK1t/f4MV0tV13wI6aPvSbDJ+Ih57+7qcQ2
 6wgvU09f
 wuwK/PuOHVvUbJKLMjdts/FHcJVZXrfy3L4oFMzpc6YUc7z2wlaNbEjDd3q2pYK5/pIqAZJbBTrOFwjMa9iiER23zW2Xm9I4X54Ka6ddIp8lebz1U2dgNXoxJCX1PkCtdl61p7iYRfVx42afympl0S8fyIHA5yz2ZidkWHC1UGWALD96+hiByMn5hg5nl7oE6iruKA1WFFw5UQ9K6wWA7kcS3OtY8Qp4dBGeNrPTTDiNIKDDu2GAiL3QIuAnDqxDV0cDCK9qlG34yqpCl1qIpZ9UUNh2GEicYtYxNaplWxzTpyrQzlYO+ISD2RD3yMXq7vWFRQ22OxV8vemGgZA/x81ftUBa15gA9jfc2LBhmAFh2KW2BitzYfXtQw27zFf4tnu/2HBKkP7eEY189dSp7EznrF6Uv0c1BTiPG1bGxI5qDQB3sXpFQjm/5xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, 07 Aug 2026 17:54:22 +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Add the memory-region and memory-region-names properties to the bindings
> for the display controllers and the host1x engine found on various Tegra
> generations. These memory regions are used to access firmware-provided
> framebuffer memory as well as the video protection region.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Changes in v4:
> - typofix
> 
> Changes in v3:
> - document properties for VIC
> ---
>  .../devicetree/bindings/display/tegra/nvidia,tegra124-vic.yaml |  8 ++++++++
>  .../devicetree/bindings/display/tegra/nvidia,tegra186-dc.yaml  | 10 ++++++++++
>  .../devicetree/bindings/display/tegra/nvidia,tegra20-dc.yaml   | 10 +++++++++-
>  .../bindings/display/tegra/nvidia,tegra20-host1x.yaml          |  7 +++++++
>  4 files changed, 34 insertions(+), 1 deletion(-)
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>


