Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B6C8FC5903
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFCA36B008A; Thu, 26 Feb 2026 02:19:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D276B008C; Thu, 26 Feb 2026 02:19:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D6736B0092; Thu, 26 Feb 2026 02:19:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCFD6B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:19:57 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38BA05BF4E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:19:57 +0000 (UTC)
X-FDA: 84485758434.18.8FC1D32
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7164440003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:19:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fF853wqr;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772090395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=npaXqvVXjWOnjtn7obYuDFYCJUrNtZ/favP3D0wZMkA=;
	b=qgw3wRj4yH9C1Ppj7J76rnWxc9OrG72EtVdfb/xsdktBhsfVLYPtvQZ7yCBxqiSTHbNWpM
	3l7hTpdGipm+/CjrL2jWzuwaaNAMo0Zdl+9MicEDDFhOB7A5cvAuYd/FIaitfEvonHwbDm
	+6EobZm0/mofC0z4TiDF1aQtF0zeDzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772090395; a=rsa-sha256;
	cv=none;
	b=6PCuAXKNs1Wao8tQZ8SO/5zISK0bCqkTSY1Gp+LveCBLAstgOEA4SHv8CQ9RTms8qBF1SB
	c3ihLGsFnY9zLY+gG/dUbctxPeGEHtm+BlrefEGzFwD17xauM4JQpfhSXQfyOYphrT20FC
	gIFcDPjTY4jBlAEnNynbe7brGx1E2Ng=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fF853wqr;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772090393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=npaXqvVXjWOnjtn7obYuDFYCJUrNtZ/favP3D0wZMkA=;
	b=fF853wqr32BSDTUbGd1rY6RRHLFU34YixtCz6yx6IB5YlxaWnDUycHWULYIe2HbWLdoh97
	gysH/UA7f3RNXtn7fyFtmmhpPNQVo8NOBLYHAwzGVGHYr/ecB5Qx+0Gh7ID6ZyHMGI0P6S
	DRemCPK5n1vwGXFdeO/5lQaPB1huL8M=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.400.21\))
Subject: Re: [PATCH] mm: Do not allocate shrinker info with
 cgroup.memory=nokmem
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
Date: Thu, 26 Feb 2026 15:19:02 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jan Kara <jack@suse.cz>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F51915F-374B-4C69-8853-D980908BFDE8@linux.dev>
References: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
To: =?utf-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: dzacimjw4xwqa4gjs4t6b8pf68rhd5mq
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7164440003
X-HE-Tag: 1772090395-688157
X-HE-Meta: U2FsdGVkX1+nQ38V4W830FQBpjmCpw2T6EZWZgWQ9KET6KRFZm18zy22ZauNYLw0ihDHoI1y43rhpG01M/IxI9eB1auAFgZQ2gwmzPEs83k6hlkxB/MRyYqiik2fuhj4G93Udyg9epUt2D18P40h72SGvJwKmgXlFB3ioATEVPX6TVrSqko5gZVtpHoYbVrQEjDAu1JsRHN3KEW44LzN+k4vkbaxCmVryet+00OuBiJGEyEebjBDAXKb/+bsnywgbHzqFsXS1nGgWKPfeoCt+dgodNGtOQftV9NtVNinDa4bMeLfNHTXbZ+2If8IAIDk74QsLPF4mqrzCcf1Rkk3VVq1fNJczxa3PWHYmFYLRLCo/xYFw0F1gkCYN0FzVnoSkxo0rIRQNHhEwAW7TBy+KBMM8TqGlpto69SEzzXGWvy24NpodQFHQqzZ7xKV5F4X1XEiTYoM0ZR2BSvSUmYhYXxd/khLjcwA8r88Kpn3pOXusGwYtEpRePBpUNqhjC4zacKAqwcHgoL2mP7EyFLLEHCx1L3TaNCjGao8dABcyycfItJ731pe1F82LZ3oVU1S7zpX7ZzBR/L795n4DaAx+mOyZGz1RYGhpjrLRWwVmXlqXIpn6moA5n8BKn5DWg+xoFghdrwrJvF36T0Oby28pHKVbDH+R1dHqRD9OS3n+LBcP/Lw64MCQJvdwMX90Ma4Falzr6rLZHMd+dx3qYLw62nqI4hA9Po0+l7ZnkDeynwBJeHKHfi9oodsh4GptxWGwr+DZF/WZYY35AN4mwqZwVgY6+vBWNdFCkMWTXbb9hUYpaMGiK1kuEGd3eS61ahVeWdv+fKN9ANDkOfKLpVNY5FBQBuwsRffvzeUb4syMUPyP5acgLxa0o+4cKYM/8HVENDCfaIsfqxV1A3afhzuTayPp9/GHVNd665x4XJZHYrD+cLXvK9OWVoOgzLpZDTQ7RI0IPOWZ5QXPkDmQGZ
 e2aJ/Pm/
 GnsTmA6sTSA9GWH4BU/UnmMz13TPcyRFiD6hV+dYUlIVZqE5bFhsCsZoxaQMm8RPq057023MKP4H8mz1y72BdCw/iXnjofEl/GxJ5CUsutOhLGY4+vWQ7xkS8rHn/HXnVyxCMbSonA22r6aGaNQR2yVwFsudNmbArzVx/BHUhAjLH+leIGTF2gVG010quwDoisnsGLWw9JIEaIVuwkey/Td3YIXevprqupYpTMCsj/mK4bG0wbWGGkmCK1w+Prms3OxMGlIewfY2g7XNhukz8qCB8fyvEcI7f/sGwNyjsn2QgQYk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Feb 26, 2026, at 02:38, Michal Koutn=C3=BD <mkoutny@suse.com> =
wrote:
>=20
> There'd be no work for memcg-aware shrinkers when kernel memory is not
> accounted per cgroup, so we can skip allocating per memcg shrinker =
data.
> This saves some memory, avoids holding shrinker_mutex with =
O(nr_memcgs)
> and saves work in shrink_slab_memcg().
>=20
> Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel =
memory
> so nokmem should not disable their per-memcg behavior. Such shrinkers
> (e.g.  deferred_split_shrinker) still need access to per-memcg data =
(see
> also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
> memcg kmem")).
>=20
> The savings with this patch come on container hosts that create many
> superblocks (each with own shrinker) but tracking and processing
> per-memcg data is pointless with nokmem (shrink_slab_memcg() is
> partially guarded with !memcg_kmem_online already).
>=20
> The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
> memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
> registered before first non-root memcg is mkdir'd.
>=20
> Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks


