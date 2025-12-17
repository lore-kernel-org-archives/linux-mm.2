Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79377D6406D
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5272A6B0005; Tue, 16 Dec 2025 21:35:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AA796B0089; Tue, 16 Dec 2025 21:35:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9346B008A; Tue, 16 Dec 2025 21:35:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26EE46B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:35:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B168D608A3
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:35:48 +0000 (UTC)
X-FDA: 84227397576.01.7A0F1E7
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86B58100006
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:35:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPlXnag5;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765938947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiBf13gs6B66pnEdGZ4uqxqCSotFnbkUNxUPZPxNybY=;
	b=xAjnEB8wcAebDrMqJx5/CpvB6ACetOOI3gAYthFJdi/R6+K0fstt/jRdQWZhXlWKx0l7+q
	5KTkOy/C3U0aFvaDL9VfbHywT6I8whNuWwji658+lHKydmeEkOPXtXGa6IrZgSNyOLTvXi
	AAykPlLnD135ijzSW/UPFYjc8JcTwAs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tPlXnag5;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765938947; a=rsa-sha256;
	cv=none;
	b=xvsL4CFD6DWCEGIvWI+Guskill2bvMk4KG4a3Qy9wg+EXuf779Ci9rSBnZZd+JfQVezWkX
	hRZOGwtbg+EUKtQV6GjnHhF7NLvVY48l727nNSD1Oglo1IGvW0ZwN/R2MH7ZO4BqE5zuKp
	G75RmPS19XIqOhslq/ZlRkIsUvZuxU4=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765938944;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fiBf13gs6B66pnEdGZ4uqxqCSotFnbkUNxUPZPxNybY=;
	b=tPlXnag5gfhKjhwnnAiJWQYLhdWF/esHQ5Mk8SE1604YTqnG4BbID6U9G60CQt+Zvebo+S
	/XvMC3bjpDYWMwcXPbbp7+lCwv1DGzfgKYk4p6rpO3kPg41uXxeuzPaIiwifKr7z+uqlsK
	htQSnWK+wCWYajamAOD3NdXEUA0lC6c=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH] mm: memcg: fix unit conversion for K() macro in OOM log
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251216212054.484079-1-shakeel.butt@linux.dev>
Date: Wed, 17 Dec 2025 10:35:03 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Vlastimil Babka <vbabka@suse.cz>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Chris Mason <clm@fb.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <ACCDA933-E222-4890-A29E-2C77CD4DE35A@linux.dev>
References: <20251216212054.484079-1-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86B58100006
X-Stat-Signature: zpryc8w3djy3ci1fq9z4p7poaiy59naq
X-HE-Tag: 1765938946-128578
X-HE-Meta: U2FsdGVkX18FSWLva7dd5p6L/h77ugA8MiMIifl23kNC1y5W++WYt619edAaUK5URayio89bM+sR5gEbYi8QKpUpZ7JSnxumrwiWSw4HP2Haw09SIf9xd2uRAcz7TY6feUQNKrndhGeTuDYUs6jcoO/ZG2o0UvvisK2mJkFNeuXFKIbk+E1ggPvdby6Zk1cCfrqUjMNc+neOEhnAsVh3DeULryCH49+dgeCBrfz54MO8XVezSGrfG0Gbn7Kx+OJ6VmPbhPSFHyXo6aqau4i6NMuwYPpeEyWTl8/VywxR/WCtcJbKPRz4jvSEtjbFbqXpXzhsQsgmL7nBuFZlj4X5E00RWsGTqjVaoFm6PCgFgjCmpJdZkVYhgHY2wVNrJnBU5yPcUUiQvI1nfIxf5ZQcdZLhf3nEIkicay0yry3NqQFboG6vT5mp/6PYp2QeN+G9xhOXFiCNy6gWalGQHjRHMopmWeGMmWcE+usP2HshX7GCfHQuiFiLncz5nVGF+5+Vv7V793mKAnYyg6p7PE/VlT+6sO1eWe9fsi03jTy8tkGHAf+OGhz1ebdINyMxSsn60fprUxgkJ88lBCkLkj54ur2kb3XWr7fuyN3Mcu+N67uzsVg99LEd2g6ZkAk6WUYf8mreHp3XxkbBDnjoff0b49AHa/YM2YrtCiKAJ0Pz8pEc49dPAoTzolfT6sMb9bEj7ZoZ7M70d3kZZFprM9+g+MEQP8DlDbOWrJZ4sZk6K4KLkMwL0SKBJISDPyIqMv8iYQtiBw6YDfz1OmDHtzXqZhOTSYb693nDPNj/SuvBNlszLWcweXMcRFfxD7x58f6Z8/diRPp/V5lOL+GPZIe+KmAtSgNRfaYhcXzENDSnIhBaHUKfPLF/MNkQ97AXDXHx3f5emYdQZIyhu01PpwkuT8GY7lde7Sp/YjJO180q8Jr8qkOmLz32JIBlrYjd/1bnlV+GluCo3UDC/DMGl6W
 8WQpqUoR
 W2zol3vdMjwSiaGCsmGy5oEbNXvmIu5Rf6qFJZfu446VE8NWK/dKYWMD/1641N2VTPQTGTEDiTknf4hrAtTTeP8HgYVooYe2rYZa2lFKAI5yuNuVCJitHbsI9XeKMPiOYYiDeS4VwuDfkHgVDzvIPx4nTFrt8T2SUglmB4eQburQPC0YTNQuqlo2xd5gn7jbYrNT535esPBXZDs9Rp9+BS9J5mG80xeKwXjySVGaL06AdxBshnWP4u8RqasuftHOrGMcX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 17, 2025, at 05:20, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> The commit bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom
> or alloc failures") added functionality to dump memcg protections on =
OOM
> or allocation failures. It uses K() macro to dump the information and
> passes bytes to the macro. However the macro take number of pages
> instead of bytes. It is defined as:
>=20
> #define K(x) ((x) << (PAGE_SHIFT-10))
>=20
> Let's fix this.
>=20
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reported-by: Chris Mason <clm@fb.com>
> Fixes: bc8e51c05ad5 ("mm: memcg: dump memcg protection info on oom or =
alloc failures")

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


