Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8469DC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 07:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6B66B010C; Thu, 24 Jul 2025 03:30:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A76FE6B0110; Thu, 24 Jul 2025 03:30:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93ECD6B010C; Thu, 24 Jul 2025 03:30:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7917A6B0103
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 03:30:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 213A55863A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:30:43 +0000 (UTC)
X-FDA: 83698335966.06.37E37CB
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 03FF420016
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 07:30:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wcm48Xl9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753342241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0ieeULae3wZoXFYbacES0pRJT+dyok9yRpzdF6F6T0=;
	b=dRtniYrEl9dNzqv8J7d+GUR+AM2+Z9yl7bqAUnLFHKaaTjuPI72n8vy/b0C3xnWHNEYfPn
	fEwXTRFZw88Of62kPxhEbvRUr9ldSlJwPb4aoII9tgIX93yibsJhu1rt0cTABKO8WwL1KN
	o80V93BfVUMnEU4X0K8ukKbfBeJBgys=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Wcm48Xl9;
	spf=none (imf13.hostedemail.com: domain of BATV+9f1e8e75762dfc1a426e+8005+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+9f1e8e75762dfc1a426e+8005+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753342241; a=rsa-sha256;
	cv=none;
	b=gJ36va9zN9DVeAOFZup/rKsNKaWN/o6JBy4k0N7pE9v/80shMTecJD+vpDRnEtodOkjhdc
	KkWVfnVVQeOOhhQlLSn5RGUxfGjRYi7Dg/aKb2z1wGY/mY9V9LQB0ni/qVC/0Nh9Et4ZTv
	ofB7LcHqum4pOytbspmBBfX2JScFcMg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x0ieeULae3wZoXFYbacES0pRJT+dyok9yRpzdF6F6T0=; b=Wcm48Xl9he+9gkl3mD7JfqaQce
	x8ztVwaaQNB53A5F0yo+KJrnZBPNw4lAAfrPl0N8sY5OVPJkJwDMEuhieCsS8U2mg6MaQuEwoJP8A
	xMtVgtwNnUmpskEXT899TV8M6A/t15OZ56RkAqlELlIhtEg6MJI7GHk5/pnYN3CooEIxTiMxJOupF
	e/fzMsUaHaqch4kbHHT4PsbtVhXeYYpulwGUn4Mg0RNT9PSKNDvu085SQy4hz65m6cPkTug6Yab24
	Ok2AgKIsmRhAGwRl+UsJpcNYYufuJ2+ztViaJE6jZJ4iGTvhPqtPDql8iGT7pCunDpG/dtx/NVm61
	BqqmT/kw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueqPS-00000006i6Y-1TLE;
	Thu, 24 Jul 2025 07:30:34 +0000
Date: Thu, 24 Jul 2025 00:30:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@infradead.org>,
	Yonatan Maman <ymaman@nvidia.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
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
Message-ID: <aIHhGi3adOiLykJn@infradead.org>
References: <20250718115112.3881129-1-ymaman@nvidia.com>
 <20250718115112.3881129-5-ymaman@nvidia.com>
 <aH3mTZP7w8KnMLx1@infradead.org>
 <aIBdKhzft4umCGZO@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIBdKhzft4umCGZO@ziepe.ca>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: sujxq85x777hem6c5coogtz7rhyc1hfr
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 03FF420016
X-Rspam-User: 
X-HE-Tag: 1753342239-956017
X-HE-Meta: U2FsdGVkX1+6pYzT+yk6tgOratt96NzhOvw8bb6Z8Zc9Y1NFV0vyp6zHOW+3DV/aqzuvGJeIBpc5oL/y75WUz8NSm5MXXwHiLIU6wWuPz2w6WUT7ORuzaWCDUTEmufekYaP2w4JKE+QVASq6IZ46GKqOYtueORa6LxbWc6XUuDImG+1DccerJlTr/BvdP2Zhi97B6E6kr842D3h/zmhlWiI4u1wTlvGV9a1YgxH+FlMS7ohmKnzEoB57xfA8RP62NmD3XhHNp9GCGB64EwtfEmgEIAV9/10DiOHYsMAyKlNn1EOZs8JTaWKn9AhvzdepVt8MHi1slum8peL8KZ0k4wstkNl4TqxEtyuMcscz1SZmoyQSyrPSktxNKR75UjQLW3RRDClDs8fLEmbF3OOY1hOUh6Pw29BVUg/cDYIj9iP/1rrQRVNypZDqJRKN7cHSzWDpnW28Uu2kcm7lqg83D+icMMhVIyaO033opyDib/eZu4askshw0NKilZRrJNaYT+JyMt72iKK+134H5CsUCqOfM3W+ODlgR1qpMQHsObFhtZ3Ox3y+DKp5XkqCqce4WvxJXoW1cTCjwj2Tz8GDTatS918URfP0YCNEsua10n8aKOXYZ1u6hwRwgNBb1L1Acwz1D3K5N9PYhhCBxVBD50gKbM8rHEdtL62LeNMrDB+c4AciChwac7WqeoiThnfBTXMXNVZlGWRNeIvLZSlukEEbCVnxn/8/WedZM45sPVmUpUtM7w5r7/Hpd7g0NovCzsUfyMor7w+lgUIF9SaeejVn+LHG4bPg2VoHrbeLIMxfhVqRQTiYCTW7qurlqEw70EnyVi6GpSsDRaFTuw8AFwC9N4ganAfBAGeH4VrCtHENcgrFZlXrFj84s852Q4taGTbAdO4lKVoJi4Bigb/G0jPx41MfSpuKKvDE1CTdav0YWWqNKRLiWmSnvaBU18YRxLAPdPVpTskX+S3oK91
 17ZkFXDl
 IfcLUgZN/43+BDn5Df9Bql8jYSe9yqzm4wvElonCbUOiUGURZTgVAWsnXMhvO8HuDbFFFIn8/2q96Qm5AuZO2OhxL2k6Jxa/Zn8JL3Xh5dJTMIzQQ55rrP7GpYdyUbXjXP7gPmCXxsmXCN7CVO2qjIY9YHLd7hA9UzYMTyFyHKM52RY2DgvA+4+xn19160W4WPWVkn7u4Kg7rmCwZq5tIypNOTP4yxbvot3R4t3sHmwNYj1eYnC9ytbELH8CMHK8+v/aGBgsArsxkv8vuGnadmQCF4KghCn0lOSuWiUwlf1cV0/PXoLQ0uM7WZVF7dhldQDgXmYtGaj8XaZkuxuI1eT6zmV7L1KTlRbrRU0VScUXYmSdTcmR4PRXW+NEy6VDJmk9uWBOb6ogl0sgueRz4hScxTtA92ZbwBQt8QCMyXLYZpeRXIBILvou+rJaTA9+TALwQeySrH5a/u4k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 12:55:22AM -0300, Jason Gunthorpe wrote:
> On Mon, Jul 21, 2025 at 12:03:41AM -0700, Christoph Hellwig wrote:
> > On Fri, Jul 18, 2025 at 02:51:11PM +0300, Yonatan Maman wrote:
> > > From: Yonatan Maman <Ymaman@Nvidia.com>
> > > 
> > > Add support for P2P for MLX5 NIC devices with automatic fallback to
> > > standard DMA when P2P mapping fails.
> > 
> > That's now how the P2P API works.  You need to check the P2P availability
> > higher up.
> 
> How do you mean?
> 
> This looks OKish to me, for ODP and HMM it has to check the P2P
> availability on a page by page basis because every single page can be
> a different origin device.
> 
> There isn't really a higher up here...

The DMA API expects the caller to already check for connectability,
why can't HMM do that like everyone else?


