Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6005EC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 03:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE506B0096; Tue, 22 Jul 2025 23:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C84C66B009C; Tue, 22 Jul 2025 23:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC13B6B009E; Tue, 22 Jul 2025 23:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8B86B0096
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 23:55:28 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B1CDB9A3A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:55:28 +0000 (UTC)
X-FDA: 83694164736.04.0001B26
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 45140C0005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 03:55:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FeS9bFEd;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.214.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753242926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YRcngTOmImRVZlU/kPn2yZwK6WlVIM67jiQ/OO/PWc=;
	b=wxkwPQb8NYbPnDv1oiUAR6++sk459G+E/VdGsXO3UlHXSWG6NQzc1L+/xZTvNxfl6sRdYw
	usPLwoy3O2Fdsd3Nhpg3orfaoHjxD/RIKC6TNFRxTLcHN2LWJveMJt4tY5siiXfrAiL+Al
	zBNB5PN4WsrsjLMK6kBY/reY1qXqD8M=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=FeS9bFEd;
	spf=pass (imf28.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.214.178 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753242926; a=rsa-sha256;
	cv=none;
	b=3quQw9ueO0ZAB+gb5vldtq5kpZ3OWKr1Jcgi1k5d2JRG9vbQELneCVv5flhLMDv6y9XDE3
	aZr5L9tfm1xkskTv/ylYqfM2OnrvlV2xdc702sOP2UyZ8p7KPLRUr2KSW1Rmh4xq5I7c+0
	EGM0FhFH9+3aPCJbqnnGw0BVzLVTIdI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-234c5b57557so55036225ad.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1753242925; x=1753847725; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3YRcngTOmImRVZlU/kPn2yZwK6WlVIM67jiQ/OO/PWc=;
        b=FeS9bFEdJ68+qQRy1CHmhYwSWM/d9uGIX5tjhOwDnmhAwOz8p7EVTfkhsQ8+5HyawE
         dWzXJ1xlOiA/iwH/YUMWGtwRki/gRZOuK2SqD3/q4hQMD2ALu4FAYeR1yw/pGlGp+dp2
         Wj74fHkgGA9wLJOVFBdDEpw2NBcA/CYIcVi74uXSpoEP7ffwPg/Vv2FZgH1MYTqpDTWt
         jWGV2OpqF1uNiAlJj+GVFw0W2Yvx3djEJIHrToGUzMF6yLet4ouE3wdmMpz8AOGxlTmT
         glPa2El8Tq+u3Hc8mH0BXr/ytiKJvWARnN3kJAEBqyqM8F7Z6SXRhk1wo4HyoTyEU6xB
         t2Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753242925; x=1753847725;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3YRcngTOmImRVZlU/kPn2yZwK6WlVIM67jiQ/OO/PWc=;
        b=n0aU7hhJPN3Nj6mzKis8K5alVcM9OhaRPRWGStkaYLRp2TxqXYjdX36NmFndGzmOwf
         RAzUDb626cxF/0tL0LJdZ9dzVAW31NRvLHWdnaaQ3bcPSini7DOd57n2StVXfrugAe2C
         d/sVML6Bp4xN6HqUcEwJQAB0abne95KDVZpKSlHyR+Nt5TY2xCxo/6J2ZHgD07mlJ9ze
         pPR09/Wagm2i3pBop5JPevYoqOhYflfia+jAB4ooCa1Xrnu7Ll5SF8IEJhai7UikuZVS
         NQuHSxb3svHA1+WXk9WEMwCM4yqqO6cIfEDe5Kdoy3B6pvq0m0o1P5fqzEWCoGaytEGw
         8Bcg==
X-Forwarded-Encrypted: i=1; AJvYcCUWHc1XKujhFNvUMrPZPvv3UXfFzYW+mhesrFV2uzPvkZNnJT7I3gCnbR8NeTUjIOQZ+QfJ2kQrSw==@kvack.org
X-Gm-Message-State: AOJu0YxOoL/e/OvDeewfzEByVnGSwwSnbgwj3ZlgKxc3Syf2D7+ssNqs
	7lKLwt/eP42qwj/IvuqZgg9thSc2Wrt2rDGAhsKr9FyoJPaKmmB9RWN6qTnaSWLeWQc=
X-Gm-Gg: ASbGncuQZLTY4mpFLlBauf5w14DsUuNGDjWEbrQ9IoZajAUfIgmeSfUMflo1yFrljVZ
	cE7BBW2oGkURMq1N+EQZ0gfORnyAY8XkCu3p8dQ8BpFgCxyqEkfNnf84fI4e9p/5jOVCdRuoGJP
	Olc4FiYSCsmy+QfizX//qf0MPqZOXnxSJL5R/i5IIx9ipAOSnxvriky0f6PXtOlfwH16Haj9hX9
	6cMm6LR/wAaGt5zk5zJeTUMlmnALyEALWb/U0QD+dRNntw9cxVjjryIHtNmFdXoJ+iLcu8/eq8w
	Doj/aTro6JWxSRcyhEiq9Tvw3VmqlhdvzwfWU3KPs82nrl1w98v/1yAhY88BcrX2DyjgEx40KgJ
	Noz9zS6iUIUAE4+HK1/UeXalD63ZwAC8aJn80lunD7Ai27Q==
X-Google-Smtp-Source: AGHT+IFPdkG2Deg66tYuBh/VvcuRb6SoC/z/9RlnC+W1ttjW1jVLRuT1P2yag8dd/CsKREgJkG37KA==
X-Received: by 2002:a17:902:e747:b0:234:c2e7:a0e4 with SMTP id d9443c01a7336-23f98164db9mr18866095ad.3.1753242924942;
        Tue, 22 Jul 2025 20:55:24 -0700 (PDT)
Received: from ziepe.ca (S010670037e345dea.cg.shawcable.net. [68.146.128.183])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23e3b6efb69sm85898495ad.195.2025.07.22.20.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Jul 2025 20:55:23 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1ueQZe-0003Gp-Gf;
	Wed, 23 Jul 2025 00:55:22 -0300
Date: Wed, 23 Jul 2025 00:55:22 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Christoph Hellwig <hch@infradead.org>
Cc: Yonatan Maman <ymaman@nvidia.com>,
	=?utf-8?B?SsOpcsO0bWU=?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Leon Romanovsky <leon@kernel.org>, Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Alistair Popple <apopple@nvidia.com>,
	Ben Skeggs <bskeggs@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Or Har-Toov <ohartoov@nvidia.com>,
	Daisuke Matsuda <dskmtsd@gmail.com>, Shay Drory <shayd@nvidia.com>,
	linux-mm@kvack.org, linux-rdma@vger.kernel.org,
	dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, Gal Shalom <GalShalom@nvidia.com>
Subject: Re: [PATCH v2 4/5] RDMA/mlx5: Enable P2P DMA with fallback mechanism
Message-ID: <aIBdKhzft4umCGZO@ziepe.ca>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-5-ymaman@nvidia.com>
 <aH3mTZP7w8KnMLx1@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH3mTZP7w8KnMLx1@infradead.org>
X-Stat-Signature: 3e4t9bcnupuha1grgwb7qqpwckqg4bxa
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45140C0005
X-Rspam-User: 
X-HE-Tag: 1753242926-321367
X-HE-Meta: U2FsdGVkX18/XbEqyCgYpw2xxRDhHIteMrnHrGUO2vBZuYinusVXYkLAd7C2MgMup4p3cGzKDUB8LiU1k5YfIPhQtC+PC23B0XmfUOdvjmqNk5ZkSftagFAD7pAO0hAjs9IrL9FL7u38CBPrMep+YIkBvd06IPP6uq/1seY2FJuXADBt0dOUgxzKijXaWTjd+hW8y+nwgoIIP1+JqKTjn9K9FLYHsK0YkRoyZeRuiotGrIRyq8jngClGoieMjkKSg6ZuREju9y3+eJnmAwJIlC1JjDyRNPkCz83zxPikik4n5Jb4HTyLEXdFl8mN3KIPQAiCm8+Zpv1h6rotX/eNuNy50DFG9D8kAiVwhwkkXK3f31XNvPxmUgwdNwkG42SRpHzoMw01L7fuOq8RMk5tcYsml4+jUl/HRldjKhRq5p8uMrzffSkbd0U5l5BD+dRiMfxm5RijVAwwsE+hSjIHjYY5iD/xEOjKd+w2DPyNAr2qK+cXORwcAP/J7Q88VWUN9Nv2gwEw6a4VQO9vGTx6vp096d9P012uJJ3cfmS8iCq6GIUp6gb9KPtr6oCGWA6ImHnXl7RwjAhvMOkab4kUcRVU/XaRhV6vrxNAxEuEXYonick8EZdWFuxfgCEaPwq6wbn5hw6mlV757VfsIoMUWCneq/0ylqlh5skpqz/BoqVkUar+oXDSZQmuaLjv2EwdLSwxuSefZA8BkmWhzN4fKi3QuRAr9Bhzso34wCZ2kZgiABhEgZL2SNtvKAbmiQHjfMssexFSyhQiC6n2QFB14nuV4nQBj5MeOMGCwZGq3ViIaIG3e1Q5D3Lk+bAEe0msfEUn+YLafNWjS111QWTbZ3gwWIOmUG8igfoKGI2GQWtOnSt01IlgfiqdSQvHGEI06WXda43ap/vmwsTbiZ/wwsVq0nC9DuLz1B4DA/3RT0L62yxGwqaZkDdt3D0s1cfB3X/RZyG4ATjXV6RH6X/
 NQKS8JPh
 6eqWZeQ4JxXfx4TWFRw8RP6LF9ocz4LNc6lJM9GfW5Y+75ezSkdLK5L2cyRa6HfPdW6h+D2nnzuSABx+mIe5f/koCezBCs2OTn7tcaIxvOVDBOAGrxTc97jWvE5QdVvYTwHJmpVbwqxPGqtzpSEdmW3UvnS2EX0OEOboYMtSOUPrToLtArQ2UZLeQjXG1S8qcs6qt8zS46BP3odIbQmGX1Ltv4GmWie2L/8BpYJSiKrm7HXiUdF2PzdbW3Exjfci6bRJYPoMPSs2lK3YlQ+KHtqh9EkEJxztUrvKJXK6gEHcJUbXo3fwlZ3sG2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 21, 2025 at 12:03:41AM -0700, Christoph Hellwig wrote:
> On Fri, Jul 18, 2025 at 02:51:11PM +0300, Yonatan Maman wrote:
> > From: Yonatan Maman <Ymaman@Nvidia.com>
> > 
> > Add support for P2P for MLX5 NIC devices with automatic fallback to
> > standard DMA when P2P mapping fails.
> 
> That's now how the P2P API works.  You need to check the P2P availability
> higher up.

How do you mean?

This looks OKish to me, for ODP and HMM it has to check the P2P
availability on a page by page basis because every single page can be
a different origin device.

There isn't really a higher up here...

Jason

