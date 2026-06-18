Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBE8CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7CB6B0088; Thu, 18 Jun 2026 04:16:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F616B008C; Thu, 18 Jun 2026 04:16:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B953B6B0092; Thu, 18 Jun 2026 04:16:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 978546B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:16:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 992D71C2F43
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:10:00 +0000 (UTC)
X-FDA: 84892310160.11.22DD21A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8E10B4000D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:09:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uLPXuD4N;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hPz+/6ozPt/d74JBAdAyoBjizvXRlrgjpuqP5wOKvag=;
	b=GlhgLZHZhnYt5BdvepHLNKHPs1FMcjzsj1bCO7xWzVYRnEUSeF6upImNVDQ4mkRL43AiME
	84bv66wRVVSWBTy/E6tAP2vQyK+7dUHm6yw7FMqcaSPvxRIbcV7DF+NIFlrFBtq7qfPmxv
	wRd4oGxCS29VXXiEP7r/V4Q33OKlJ1g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uLPXuD4N;
	spf=pass (imf11.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770198;
	b=WUvMwucMq4tKgeiZ2lPie62X1vHiUFhaqu0Bwh3edsgDZhlcSwD4NjhaKTVrsTgRou2PYJ
	RiqkieGWCrgFt1f01fon+66Z0+Q16tbdAz+TyhnXVoTXp9D2Ey7/TXMtGjbROYCt8vZECv
	e/e8nwuHmlfbUmKza+qy64M0O/yVS8Q=
Date: Thu, 18 Jun 2026 16:09:44 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781770196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hPz+/6ozPt/d74JBAdAyoBjizvXRlrgjpuqP5wOKvag=;
	b=uLPXuD4NEEQLwI/WTOt7gNtfmYXk+DRz/v5gPNoYBL6JiuYWOC4+KiGR3iVq3QdkgA3ih6
	QiIuV951SK9PzO02tMc9C8sWK8BnaFdXeIquOeXMnz6gGNfGCDXlhYoVk/RWqc/dEb7xNr
	9CLAngLDI8yBa2rXlvgZeq7y1B7VVLE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 10/15] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
Message-ID: <ajOns5I57UrExxW6@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-slab_alloc_flags-v3-10-ce1146d140fb@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8E10B4000D
X-Stat-Signature: 55zkw18cmzyqcth73pr5twrdexiz5hm7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781770198-130222
X-HE-Meta: U2FsdGVkX1/ARE112nHehtmyLDVJ3q3ptasd9EwMYzdWPU9pz7Z9LJnf7dTeSfBSbFBKHm77tTF2NICUeYvlWIq1G0o6kujnIBr5jZHVanDE4DMknL8eDRrBK4pNrKY7SG5TIklIyM7ddRy/PyyIY4jJJ+GGUfjJBa+czI+bpiGHvaI6gcQVgFeFraYXTP4oO3HwCXnbEGuchOAcBEC+PB7YZgflAmotyF8nw87AdTL1mzWNzDXcOML/G7uaU6NNjhTQ68e5Xf+XLsn6VtbGudl+/22bvjzSw3w9QseS2hxS5f+85AZfpvq3TEzyHxMmmcOie3/6ey5arLw9paolRlECBWnctH66T0OQstmIcylsMGJZGZLXdt1vx8XkS03ALjutDo6gr1hyTUJd9RWd5XPZZr0IZyxFUv7nKlvP23E5qbLAK4hIYIHEgCXVbmmMuK4v7PSBmBu1F2Xeev9BvYHCz6SkY4mRjEIVCXtkEmSvLyZg1B1Iqa6zSIbzNZJ7g+HiQAi6tqlHV1h68irFHBlb/XERzzTFswu/LfTX6pAjI+9RjbDxmN0iSgDPYeoF8IbYj+688Z1HmVHQOSEa7n+ONI2TIETLlLJazAZjlwglbCeYLjlbHeueM3f4/WI6SZsRFSUkZhn1aKmJcaw97xQE04LKknY8EpNjNvN0l4NnyV/rcoy6I1ZWvHi6sCxuyYrqPYV4IYP6ZloBmA1R2v+X7cD3jMPFAq3Jr2FZFFNpe/pQt2RnpLJHdQ5f1L4RUQkyQxZ3weB5NlkPDeF1kTGLFt3PZ/JaO1YbAlGcaKDv0b6cEctwtiHfnEYMaDLOujqMhhzBvJ2azXRV74AziyuKrLf9tH91t8e9QaWEJCqEQ+3Ccf8RgqUCNjjyCnvZHgeNN0gI+Gcbp4XpdEY5RlfWoCDN+2ZaM0LgNOXkxt1Ry8LzHsQvYI742/5vPm4hrDxUWUwM3wKGYVkbBNC
 DnKPw5Vn
 mK1FyecgyWymBAkj6Zh6tyVt3bkIk52uo78+xhuJ+96UtwlggFx/A3EbY4gK2sOEu44pjAiyu7JRx6vJ5qqg5+k/lC2hnNTwSFvThNf+Ulsv0qF0NSYfyKAJ4vC3H4tUwKeyG05srvik4dH97bLL3n+6yfD1gExap9zRf8UyN9cRTGWVXM2Ktk/5x8vkNuMxSFHspkK/vilCtSHrTxdOe1vm2Ext3cOEPcpKH66W/o3T3kXvBjF7gNGwfwhzo8KTvzxFVqn5mce/6uDDmlBd45wxoCIHYhzYye1rJpV4VJdOdehmGSunrWdibwx37xMHMdgfg0bzKux9KEF5bX+SSAB+QbkBt4qTER1Lb9Meu0CQDxvlYhGoiyYVqMhA3rvXvsv0e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 01:54:43PM +0200, Vlastimil Babka (SUSE) wrote:
> The last user of gfpflags_allow_spinning() in slab is
> alloc_from_pcs_bulk(), which is only called from
> kmem_cache_alloc_bulk().
> 
> It turns out that gfpflags_allow_spinning() is not necessary, because
> kmem_cache_alloc_bulk() is only expected to be called from context that
> does allow spinning, so simply replace it with 'true'. This means we can
> also drop the gfp parameter from alloc_from_pcs_bulk().
> 
> With that, we can remove the "@flags must allow spinning" part of the
> kernel doc, as there is no more connection to the gfp flags in the slab
> implementation.
> 
> Also remove a comment in alloc_slab_obj_exts() because there should be
> no more false positives possible due to gfp_allowed_mask during early
> boot.
> 
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

