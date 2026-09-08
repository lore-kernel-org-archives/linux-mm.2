Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E243C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18A706B0098; Tue,  8 Sep 2026 10:59:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13BBA6B0099; Tue,  8 Sep 2026 10:59:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 028E76B009B; Tue,  8 Sep 2026 10:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D874B6B0098
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:59:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 754451A01EB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:59:51 +0000 (UTC)
X-FDA: 85190904582.30.19F178A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA37F4000C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:59:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QvGYzZvW;
	spf=pass (imf27.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788879589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjLxlDjwVMKv9IYIkt+Ko/Nyuaq1pNIEbnWW+mI79fE=;
	b=ZTLoMGuUbLoY6wyoRD0ag/EwnNGIldxqAd3ZqFntTq+Q0BAoaGSbCrccSOeqxCuLAIdL8F
	Gzfcos8TcuibPXuo01m6OaNgsdYXgEEW09LOfWCWjhwNcmU3D7ClpgR9G/vzmAknrNz63t
	BH22qsdD8AkZsajKXqPfjsvDFG93Q20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788879589;
	b=8hnH5vrqzBGytOSNMG9CrDcsZxVziF8+9NlmQfAAj13ZJwcHSzKP9/0qjoT0lwMLewaCmt
	i4Ri6y7dcT9daCX1uu5PKrqAtyFRfH3YLH6jkei4IbYHdory4ZTd4Vtx35EMQhvS9vLO6z
	uHfJhB2hc0j3Jznq7AzdADV2/Gy2cfw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QvGYzZvW;
	spf=pass (imf27.hostedemail.com: domain of robh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 56357601FD;
	Tue,  8 Sep 2026 14:59:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B47B31F00A3A;
	Tue,  8 Sep 2026 14:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788879589;
	bh=mjLxlDjwVMKv9IYIkt+Ko/Nyuaq1pNIEbnWW+mI79fE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QvGYzZvW6Biq/bKb+ElGh8jCXJmgfMxoVL0Otn2vzu3W/Xmg9Bv+JC3DvUD+LuWy4
	 5zHSOarYcP9CaGN7JAmEgbOcuiq5k4yqeVAeBse1GJx2ytaLCk7BgTyJ9K90260SkQ
	 +QqOg36QieaIouCcAp5vjxWrkrJVoBQmG3a7dNypT5QdKVWri9HRkytxVHW5G0Sh9K
	 cUTG68rmgshSn7vU79mx+3naUuCrNIHt8nqtZFbsEmVDRSI8g4TNkpBD5lsw00gxQq
	 FgKaSVtHrOlKhSwHL37yeayu9D9QlIaagzVnoJAVY9TyBXnfhIJfBQT4BlKyzMoCSa
	 ZC8kDVt3Wo8hQ==
Date: Tue, 8 Sep 2026 09:59:29 -0500
From: Rob Herring <robh@kernel.org>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>,
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
	Will Deacon <will@kernel.org>, Chun Ng <chunn@nvidia.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Thierry Reding <thierry.reding@gmail.com>,
	devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-s390@vger.kernel.org, linux-mm@kvack.org,
	iommu@lists.linux.dev, linaro-mm-sig@lists.linaro.org,
	linux-trace-kernel@vger.kernel.org,
	Thierry Reding <treding@nvidia.com>
Subject: Re: [PATCH v6 06/12] of: Export of_node_to_nid()
Message-ID: <20260908145929.GB3123582-robh@kernel.org>
References: <20260904-tegra-vpr-v6-0-79042cfa8de5@nvidia.com>
 <20260904-tegra-vpr-v6-6-79042cfa8de5@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260904-tegra-vpr-v6-6-79042cfa8de5@nvidia.com>
X-Stat-Signature: qrtdn8tgcrgcrjc73gacirfm1n3zu4md
X-Rspam-User: 
X-Rspamd-Queue-Id: EA37F4000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1788879589-177071
X-HE-Meta: U2FsdGVkX1+ljzvIi8I6q5trMMoyX0obgyaQwqyNDcuiUzGh2d1HLH1PLtu+v7qGcL9CwnfNlQ3D7c+0XTt8ifrRbdVvenv0xEIMZWuSrdUfw0ZJMhv5Fr5xz51SXH8tBe5OuBJ7LwGDg/ZgLNoDzFp/jhTqdG/HQBfG7fe+SBaW1xPcxZbRGMhYIUAQinp+j5pa4PssR5jJIIyaBk9KVN7KABlYT5AAEqCXID6ccN3Hu4eO9Tu0gCc+euFE23E3BK2bIeK4YD+zBcm6S1MQesbuQ5WrvjZVnyQE+6fSw2JTalBABWCoetZlRMqUyp1yJlD/ljwiA9eyzM/0ZpoeehiZ2HE2qpOcx35RAWvlUXYMsBJ6P3ED2CuNmHqV3wSfUmiPKFDBPKBOuSFieVxZd61TSPG7iy8u/eaVqAyvcv2M3W46da00pZSdh0okgjU1aG42eROsFnMdaDq2hxLBI1t9mK8yWdRtlofbcMCfDIqpQWY8NJN3QEAcBFkjn3ddYYvh2o53ZitLJv5WzERx8bZe2CN0vaplbGe3CPMOcE8AJQgKLTQCf7K4RC3Vr9rzY/ZQT16deSny/UV8tT1GL3fXaaS2JaS++8gGeOSv/Szn7SNXJUJXBNNdL6yazLBcuAOgIlI/NXs5JomVPTogl/BxWXknZVnJjYtKlaN8xHrcQUqLov1xkP4lfG+CdYO/HtHgHSK3kqSlQ/p710wBJMeOsLQvxHwpY6S/5pNipNN5jJslKzAGPMto15jzH78aiLNS3OJ5BQpcfZMcxlD/kKJblSZl+ftNw8nnoID8Xr/fseTiOUMVHkRfyWeWF/XH8Gq2wYywLn7MdK1D74b8i/7G478hGb+4XOIaeAZUbGkB9/DYCune4oE5aPRjbFeq19DchrV2lGmBfKh+CwnP0iVvVG3pchxEEWWj+iXUUwl4s5PteQfDB4xa/AdVIj6qfVSAH21bsGxaoQhCxFK
 5YwkNTF4
 K+qzUChKwRIVqOrzcTvvgsuGu8+wTRV6R1IhahEfyYYmbGufJTZ4T1G0RLNeJxl68DwJOlIcrRa6sVQLTEWtXerPjurkESV4ESlxXvPxB7CsoIQMZxmi+1lcKxWVDJuQt4usR7LvnoHSM9IzqqwkjN8DGYg1OA1xCplAuiJg/TDzyjA5QmQV3L2FoErzljamIjh1u9uhBcFHbX3+IGQ16yLcaa/RPP8Jz+XV9TArbVe/fU5ZM89VRlMoqFkDPC7vgYRABHJn/hGTRNpXBghsFoEXLvMcoDx7w5NzOmU2RknWTqweu6KExgZ5MpkwiI/Rm8DOZZB6AdI7NPqqTYDibmgdmy7AwlZUtFHxj8DTQ4Uz16uKqFBb8m5uaIfvvugNmqHOhB0DfdGZ8qQGfFFJ0/Cytt0rWPk94nI30WeI4MTaS2UmJmu8C0xKLkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 12:44:57PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> Drivers buildable as a module may want to use this, so export it.

We need a specific reason/driver. Otherwise, that's every API function. 

It doesn't look to me like the VPR driver ever actually uses the NID.

> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/of/of_numa.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
> index 230d5f628c1b..da2e9bd1717c 100644
> --- a/drivers/of/of_numa.c
> +++ b/drivers/of/of_numa.c
> @@ -171,6 +171,7 @@ int of_node_to_nid(struct device_node *device)
>  
>  	return NUMA_NO_NODE;
>  }
> +EXPORT_SYMBOL(of_node_to_nid);

Assuming this is still needed, EXPORT_SYMBOL_GPL.

Rob

