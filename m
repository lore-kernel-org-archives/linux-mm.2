Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2BFFCD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 09:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6FE6B0005; Wed, 27 May 2026 05:11:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60576B008A; Wed, 27 May 2026 05:11:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28026B008C; Wed, 27 May 2026 05:11:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9DF6C6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 05:11:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5038C8FAE8
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:11:39 +0000 (UTC)
X-FDA: 84812631918.15.5DE96AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id A67D620002
	for <linux-mm@kvack.org>; Wed, 27 May 2026 09:11:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ9+zHsT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779873097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w8SNyfroetexR/rsWgkA/TlWiipBp7W7BaOHpufW7us=;
	b=AManDYDTJQqQm7NMeU3Z+VLzr6M21l8nQ91mFuSEHDjFzWOoR2cqdyzvyYfLNw4X8matcJ
	woTp1ul/rd+C2jy9w8IapYq/4u7F214CnD2bTZhdB8JWspxIpNj2MLsWNEnY42LiKNSdYn
	YVJkrSRTNfKB3gS3VbKnCCET190eLso=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ9+zHsT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779873097; a=rsa-sha256;
	cv=none;
	b=lCLodK7N8G8EiLNQfsA33U8eZeALaHJtLAdI+M5z7Z8cronzhif/+PqgFlysppigicjvem
	O1icFVNIrGdmB6UGUowosmnXJSCtS3RS/qt0uMBfgI9DcK7jgYLxN0FHRnoHwFHZcPYqh9
	1UqN3xQXvzeqGL/V0wCzm3bkcYKDRRw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C873600B0;
	Wed, 27 May 2026 09:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBB1F000E9;
	Wed, 27 May 2026 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779873096;
	bh=w8SNyfroetexR/rsWgkA/TlWiipBp7W7BaOHpufW7us=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dQ9+zHsTB5S8+cja+lPli2tAY5+rNntkB5VeiOTEpY+C+NfY++AcNcBmEyJ9mkNP+
	 Ss3skkru5b9Xx6jjSLC4Kak3xr6/+2TbdnHybyrf4PfNOx1C0zsF8CZRrNPy9h/GDr
	 055IOD7o0EWmIb9z2wC6R0m+GhluIF05AtDyKnDPGE5xqE6vjiu5NyVvsggY7ZOU+G
	 sIMXNFpKI2wNq8hlxyEqT5iaTDPDanW5rm5WTeqddt3FExgugOtMakhdBcOhEI3ZaL
	 4XZPoFhBdJcblxf4qRrvuYgP4rJTYoE8SWlx3fY5xsZTm+Ed3cW4sWQbbdj5ne6V/B
	 oYky6JCrszNZw==
Message-ID: <ee817070-cc7a-40d5-92a4-2bd8e9e65fbe@kernel.org>
Date: Wed, 27 May 2026 11:11:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: improve the kmem_cache_alloc_bulk API
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>, Harry Yoo <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Jesper Dangaard Brouer <hawk@kernel.org>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20260527070239.2252948-1-hch@lst.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260527070239.2252948-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A67D620002
X-Stat-Signature: g8ku1rmxxerhqchwqmjpmsermw3m9xw8
X-Rspam-User: 
X-HE-Tag: 1779873097-336801
X-HE-Meta: U2FsdGVkX18A/MpLXbAEf9IrL/GQ+ggvma0GRDRUMT+A3hSXgiBOmGI/GDqJrl2aNrdCGfyasJJIRggURItXcCNJWM0o8vi+LJMNsrf+sLVcLCdqB9mKLSmKWw0wb4oGhupoQDMB5yWnYobFG0U56t9yhV8PxeMgfV8C9rErGQRhO5OJGMd2PxyCX6v+CHmRoI5ySG7YVAnGnvAilhOyrn+Q0fUMgU2dpaMZrEgnodrr6+EEWOC0msQeiIt+d43MU9RRc9J63w6uD9b10cMKnMeReWSmuv9Mzzcq3KZ5PctLnXMtsLA6Sd6H3HvDcRWG5Qj235W/yOjMeglJXrDh3pMJ1Uz+bKColtBTa7t3upZ7VqM7L49VhbDsvbUJZ6HJSZaYBJf8K+Asy3KOEhuhjg8rqM4+NnP1pnAcQSLz7aHWjypQG8rgRJfY3x9p/6Eh5uJDeebQCu3Mxjd6esXeUOEvgPRSuzOSm507xV61kh4ZWAK7yR1HALAOxRMz7GX6XuBbf82qqiQgyspt4Ao4v2vyfmMgVr5nYiPt+3VMKv11ZtNYIQDgVWfXgXUOvqX5zBDg45Vg61sq2WDEdJRxHxQgEC4CF/sqZNkw+V/E7VSX1dg451cRpzesVo25hEPmHvD8aNB9p4zZ8Wv28eJftq5o/Y0N4lNBMEX13ADAWtJl/ghdeUVqs/1tDTSHdF0FtYv/g0nq2TM8MwtaxpHTNgboKLwyZcoisR+36TtImVpjrqhF4t0OJu3UdcbBhuPZTG+oaulkaN7BK5iTT4tTTsrx5lWjbVbPYc4UTiH/4g4a88Pi611T361471PR5zFOgQObGUuME7hYjbuYsPnt1X6OGnljwVFfepK9OkEvQi3RaDFQ1OrF0v35TaRJORaSt87JfFFFGKWFBHUML8+Wv7l9qxa42bXann3+zn99WulF7GJiHVUk0BHl4GeI9nt9M1ppkn9izBEwwYsK66H
 MW1m9LB3
 jAUhV9Q+FFu5+NMFq+h3vxj+9+EGh472P+KKlqg58fUSQ03zeobs8CVDdO4RdkZdCdz5kejIMLaLPSk4B1a1nPGT0ReCgvqsSeYtv8UgyJv1FK13SasUpQAe4oqrr9hdsWyR8HvO0NhHO3zZOM5nP4GTJfbRaF/CAvFJGCV/xH0xtanaJwpyVWoo4x+us8d1qLkVLVxamB1jIvVKwbxHPXSPYAfuSiwr3eo1HkyZtdtpoQ/v+GmMrH/jrm2diQyjpvnvSUkbEQtQaLmcfEXy9hipj0LK83yS/U4Qk4qdhZeTmF+Z9snjw2C1/Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/27/26 09:02, Christoph Hellwig wrote:
> Hi all,
> 
> kmem_cache_alloc_bulk has a very unintuitive and undocumented return
> value convention.  Fix that and add documentation.
> 
> Note that the few comments explaining it mention that the gfp flags
> must allow "spinning".  That's not really a term used in the memory
> allocator, is this supposed to mean "block" or "sleep"?

Page allocator now has alloc_pages_nolock() for when no spinning is
possible, and it uses ALLOC_TRYLOCK internally.

Slab has kmalloc_nolock() relying on that when it needs new pages.

In terms of gfp flags, such context is currently indicated by lack of
__GFP_KSWAPD_RECLAIM, where lack of __GFP_DIRECT_RECLAIM only means "no
sleeping" - see gfpflags_allow_spinning(). Slab uses it internally as
there's no ALLOC_TRYLOCK, but also there are callers from memcg and stackdepot.

Like the rest of gfp flags it's far from ideal, maybe we'll figure out a
better design eventually.

> Diffstat:
>  drivers/gpu/drm/msm/msm_iommu.c       |    6 +--
>  drivers/gpu/drm/panthor/panthor_mmu.c |   12 ++-----
>  include/linux/slab.h                  |    6 ++-
>  io_uring/io_uring.c                   |   23 +++++--------
>  lib/test_meminit.c                    |   19 +++++------
>  mm/kasan/kasan_test_c.c               |    5 +-
>  mm/kfence/kfence_test.c               |    9 ++---
>  mm/slub.c                             |   58 ++++++++++++++++++----------------
>  net/bpf/test_run.c                    |    7 +---
>  net/core/skbuff.c                     |   23 +++++++------
>  tools/include/linux/slab.h            |    2 -
>  tools/testing/shared/linux.c          |   19 ++++-------
>  12 files changed, 92 insertions(+), 97 deletions(-)


