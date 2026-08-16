Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCE6C5DF66
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 09:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669176B0349; Sun, 16 Aug 2026 05:59:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640C06B034A; Sun, 16 Aug 2026 05:59:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D546B034B; Sun, 16 Aug 2026 05:59:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 346BC6B0349
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 05:59:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC5F21C1822
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:59:41 +0000 (UTC)
X-FDA: 85106685762.07.C59F3A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 15461100004
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 09:59:39 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1kKAbt4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786874380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7MREgld/BLjhaewklUc18IFPosE8Z7M0EaKNZ/CkJ0=;
	b=LNdcDxs1E43GDrw7QvOpCNC0O+tKsgiGBtKEcKPKME404fZG2oOxC7ukvC3L181TfVSjg6
	IezWGeEfPpDlkC3YfUDpgg3UsWYXy3r0mCtDzuBz5t7Yv5z3qInD9cP8B4s8uQsRT81I/V
	Ybloc8PJrKJs0vqmxySdCO/M3avsVZk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1kKAbt4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786874380;
	b=FJ3X/YOyitSr+amzcL+jniowGQ9ppzm6ers1L+tXy2NBnNxSB+Q5qRIN+7mrjkUCx4eJkJ
	0Hq7ljfAULU4Y2r+JQ1p6pI5j9oCpCHsIuhyD+x+0l8n4AYtpVwZDS2HxrqJ3JaqGWhqBf
	B0CNYM0jf4wR7sjj1eoW9pB9IajBsNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64F7A4397F;
	Sun, 16 Aug 2026 09:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF871F000E9;
	Sun, 16 Aug 2026 09:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786874379;
	bh=d7MREgld/BLjhaewklUc18IFPosE8Z7M0EaKNZ/CkJ0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S1kKAbt43t6hwTScs3DwkHJJCMlc7M7Ahq7fHaDVhxBEhEvHNLosu2UR1yXTrueFL
	 7CYT6F6LwZ4HsykK3FexnQN55RsVnCXzo0j3TTUr35kykQY03pIh4bIclOjim6FmQJ
	 X1qqD3+n2MJuioOA6Hm124D8c8bt8TpNy4BBI2JRwnteGGeH2c0GgNB8DmzJbAFw+V
	 nJNTCzD11VXk+k3chuvzXEhTx8Ztzd8H0BpkohlKoKKugqYXEJU+o9hFAyUPf6sSic
	 56UA8arTMiPOyvCey3yuknsaYM2vajh+PXaCI6L5wMOMcMYwKh+lvtJxSLiXXE6AKo
	 xv7oC/UfH7PKA==
Date: Sun, 16 Aug 2026 10:25:22 +0100
From: Harry Yoo <harry@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: Re: [PATCH] mm: memcg: fix slab over-accounting for in-object objcg
 metadata
Message-ID: <aoF-MIwlfeI78Aox@ubuntu-vm-arm64>
References: <20260812124858.73487-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260812124858.73487-1-guopeng.zhang@linux.dev>
X-Stat-Signature: dxgti3brxucoietxasqn77fxizt7p7i6
X-Rspamd-Queue-Id: 15461100004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786874379-103251
X-HE-Meta: U2FsdGVkX1+oWMy6ulNzoqmOwzkYwsUgr7r2GDPpwi3fjNlznzEf8pk8A58cqRt3BUHlzU1XUdIaIlvOzlU4pPxffVE5hU125zeHOGllvqvz08TEtCIK+Gm05mIqr/zkKpdp8Mu9GPhzRmw4Aly33lcRjWiDUZNtPT58abc8T+3YrfIwAdUlt135DG/R9HJxefdwfcTq1bnoy4fy/vBr/xNdjtbQUohSo1MBk7yBHnYDlQNllzqU2c1LpIebIZwMoh4TS+7TEc59tZrHgzKGCkI9zVxWfqYJoxjgmyVD26gNAaWQNa8Q9DbvDKPIAJO4FtWR/JYxL08xfQWin3Cb4Vxd3/MoyO9Vuu1RfJrMlIY/UdGppW4SIslU3nTHYyy4nO5Q28wJyihk8S5Jg4Qpf4+9/o3fhkxGS57nd7hgmRrtZ2TYbYR8tN2VrU4Ah3UnB++8s/DV1HofQ81e3lh1BHTAW2iDDlJXHfaiPXw+rcXq5Xmv/BnGgzp3KJc2e9LhGohOorIrAuS74jdFC91irc/qihScE90Pk9xpTLghEJzTo5ueZH6+BpUCjJUZzpYqgYbpoalea4BIPX+GSMJIK8sbunEnQGReEbMoMWc2qbJ8TkymDkBpuRnPI2xn3Y3sf9KyHnWyoElv2KV72cxWMtHFROgPlDpinFjc6PB8C9GILts0dv6kidOPpPL5CHbhCKHUp6bkppiq6BJetKdpny6uF6f5pU18TezImKY/DjLgqhAmH/d/CgJjV7WTRNPt9CEusH3irSQtWAokiJca5UINzZycTKJ/ewrTCCt0Tb6+kh9w8ssRo5si+zCEk+4KKNq7Tlvzhg1ShURD3o1Pk//ZVlJkXKZs1cpMlJHjezKqPFh98Rrkyb2DmzuG7mrpDQ2wPjXvJ7ZWrl7BEKQKx43YP/FTppe9OOQItDVcfA76fEcKbck8bT7joPzHePNx7e4LbX23cK7kaOpDCOJ
 NliyZWwZ
 A61f2YvSu7C9GkP3Vx1KoUi8Zmu8WnUf+LDw+uZB+FpwZzYEl297M7dsqOmqLQADQ8GlJWQsfZGmBaljYTAzIYQywjcP494iXIUWit+FbGXAoGt7mfGtJELKRMngyu2zbXbzyvMkGCVtziwSbw8oG8z7Xv6My2q3lTUDM/GAUjnC6DWXrR9Csm6mFzhLnBaimDCa9u+Gw8TYYKop86HuhXSEl5xHC8ySOF8HeJmg+l9ZChcBqpzfhduVWRrcVNz/Zz97cIaF5U1oKhJ77miaNni+tPtSzNf/VatM6xyVZ3idkiDwCki9cNh+kGeXrweOAgyEMFnmpjTIodDREoxJNsr5P0yDkM2dtS8I7md3KC5OFbgA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 08:48:58PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> obj_full_size() adds the size of an obj_cgroup pointer to s->size to
> account for slabobj_ext storage, which normally resides outside the
> object.
> 
> Since commit a77d6d338685 ("mm/slab: place slabobj_ext metadata in
> unused space within s->size"), slabobj_ext can reside in object padding
> already covered by s->size. The extra charge then accounts for the same
> memory twice.
> 
> The per-slab obj_exts_in_object bit introduced by commit b5bc35ace2c5
> ("mm/slab: replace slab.stride with obj_exts_in_object") identifies this
> layout. Use it to omit the extra charge only for in-object metadata.
> Unlike in-object metadata, slab-leftover and separately allocated metadata
> are not covered by the per-object s->size charge, so retain the existing
> charge for those cases.
> 
> Reported-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> Link: https://lore.kernel.org/all/20260310113804.245647-1-ranxiaokai627@163.com/
> Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> ---
>  mm/memcontrol.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d1312441a02b..aef480f46891 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3526,12 +3526,16 @@ void obj_cgroup_uncharge(struct obj_cgroup *objcg, size_t size)
>  	refill_obj_stock(objcg, size, true);
>  }
>  
> -static inline size_t obj_full_size(struct kmem_cache *s)
> +static inline size_t obj_full_size(struct kmem_cache *s, struct slab *slab)
>  {
>  	/*
>  	 * For each accounted object there is an extra space which is used
> -	 * to store obj_cgroup membership. Charge it too.
> +	 * to store obj_cgroup membership. Charge it too, unless it is stored
> +	 * in object padding already covered by s->size.
>  	 */
> +	if (obj_exts_in_object(slab))
> +		return s->size;
> +
>  	return s->size + sizeof(struct obj_cgroup *);

From correctness terms of view, even this is not 100% correct because
it doesn't account for the metadata for memory allocation profiling.

But as Vlastimil questioned 5 months ago [1]: is it worth the
complexity? Will simply charging s->size always make difference in
practice?

[1] https://lore.kernel.org/linux-mm/e7ccb3b0-791e-4e01-86c3-65b613e3cc5a@kernel.org

