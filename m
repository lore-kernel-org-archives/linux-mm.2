Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2856606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 12:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nvjMdyTR
Received: by kanga.kvack.org (Postfix)
	id E15E96B05C0; Fri, 27 Nov 2026 07:29:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEDCE6B05C1; Fri, 27 Nov 2026 07:29:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB7156B05C2; Fri, 27 Nov 2026 07:29:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A250D6B05C0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 07:29:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 230EF12025A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:29:31 +0000 (UTC)
X-FDA: 85480829742.07.AA48335
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf29.hostedemail.com (Postfix) with ESMTP id 21CD312000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:29:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nvjMdyTR;
	spf=pass (imf29.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795782569;
	b=FzsrgvG+3agkYrisS2LlhTVLP4XucVKqq9I4BgfO1vsWecrlTr5P4fZvrBfsESqtDBEtz8
	/Dl2Ci+UmZtzXfln96W4TC9cGW3rSaYxFqnU/ovk422IcVywkgqy6FHqf1/eYMlsY01hMT
	Cdg4FZwBEB159OE0B0+W1W60zCu6hEY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795782569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
	b=ukaCj0xZQCpwhD+QbtHLU/U5mGbP/kAeWIg0fn2/BTghDBCSv9wP2GfEQg62Z04nCQVtgN
	rU1rLMTiK3tEDkY/zHVk9MeaaGtrbKhHEiy6RCeiUJj8VwcOefHKsigxusQr2uD/mHTpbb
	sTctOiNtsPe/RN5oZRYXAh9aY2Or3vg=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nvjMdyTR;
	spf=pass (imf29.hostedemail.com: domain of lrizzo@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=lrizzo@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-55dd1f9b760so134641cf.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:29:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795782568; cv=none;
        d=google.com; s=arc-20260327;
        b=fCelyWIfDu+bpA12f1PMuSeCewA20hxgIv/xmQt5orlH+VGjqroyzrekASXqw+rZ8m
         y4Qq5ZLIvTAKS/L1c/3lBghhFmqFgFFcEnUbLAuJctaw3jkldsc9LwEk34VIF11CBfEA
         cKgVS4K6bK/USeGyQ6EpKgcTUuZH0W+82mcpSM5hn+nv3bqFP9+Dkhp+NYwXquX426mh
         KNsIjKz7mYJRV6mRp8R9u4nQGqpbhTyVBFxx75ZZIf2FaAQ0QB27hdhRcp/RMvgRzVML
         euwQbxLh5Nc3HuQdhnVzHR4ULtsO5RRdMLtLUlJct57aIvqf1HfCcY4V8jQ3AV08VNzI
         NF8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        fh=ALCx6GZeB/X6wNTWl6lcqlkv9UAZ87YrP4nzxhmyoQU=;
        b=rc+Y2KaCOcCZx2+qxeHitfyrNx/qfd0yXVyLwmvgw3gAAawTYEmbwE9mEReFOXicrI
         CvQnVZ5/z+aJmN0os3sIRNGutsfFnewXMq3cIlFFCtRmRySymatUFllWf2GjafpeCVO4
         gOhjYeyUqyocQ7IPiM2B5Y74dzD+NuHqmo/zBqMHrOg4qzxv7ACxN9iumphd14RDPE+4
         rreLJxiNG24GGbwxL5pAlnJx5QEhqWbGnWxal1TXVDR1+N+XXI8d7Ts3FDY/q6CXIY0w
         H5U7nWsZtlzje22Vt2DxnWNbZn7R/XRDANlVZ2P6z2Gp74yluaVemtswA4ZpYNqaHvwS
         aHPg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795782568; x=1796387368; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        b=nvjMdyTRD8P8rwjE1aORcIhAgEjMkgxnfPCV9cntw4+H3FQ7bqYQ32pHL6YUgDPh9J
         5Gp0Do8SSgUC8YGtN4vNGtjWGrpoWEy1X5nzxIpBhyInfCVBWWklsYIQ4hNXAvI06ZJT
         yECe2cgEsHpgvYg+fljFRJv4nfZBpi7u9SMo8tDsG93wCz7PA0qmySr0aKLEDNRpiSX6
         7ltbQ9G0MwMibpnX4Hq4pk3N4OvumClRNSgiRtUWb7VRgDUBqYnzfrKLZ36HYb9ljzlh
         avbK3qj7HTaL3Vh9LVe62ffjql5UCUZ3jZsZZrQNBW8W7dtEOtcNDg2vdQEg+suaICbq
         HPcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795782568; x=1796387368;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gXf5stEDIYuDZVQjUcNyW733hx6qDRKNZoyJXoBIROc=;
        b=XCUh4fQUKTIvrMMT+qBfmpuH7Mo1Obcq9ejVg+qMgsK1CfaAacjWHpGIogKROAa1dO
         n9HBY2Cpn6Y6U6PvYpmDUFefjzt3CglR0llfeKsziNLIrtpHNGa33twn3Upov6cTSrMQ
         69gpucKdIe65BQu1tsjW6pmJIZ0fhrtJsur338/ND1ihI0Wh5MfrtQWVIGZYZ9nc/KEb
         vqD3Z4LY/B689tAjZS5iIBeypGQXQ2hLZi5UdfMO/SR2wxbcSuBWdKMcNnBltaDjpmcs
         KW2XJO+bXp2Nqy95vaLemkXn1m0gFumMBsfiz0c4nqI4NkQHX1KWzLp0GtE2kwP7s4L/
         1ubA==
X-Forwarded-Encrypted: i=1; AL+hErE2Q2kAbmqPwp+LLqo1CPo3fPZj3Pad9UF9khGqAv1ysOAkh2W4U1DTEREUFN7iCbOZF2XuFOn5Rg==@kvack.org
X-Gm-Message-State: APuU4Z/2N2CzSODPhUYMYVifrqnsyytJIgNvVE5OClnGxHM/niiaecrJ
	lYZYuEPZxniWyJtQaN1yqjd0Q0KMRK/WZlweL5/AsX6f8FqDyVh5nQXvV17k+j7V+8N725bPSm9
	4FlnD6T6urIBfwE98OeCR/VfJgdEznIQYgr3XiBCE
X-Gm-Gg: AZFdTZf59+YRFsdiYelS+BNURhkZLC9ZEWcwmoUR6J0WdpwJjgA5DfggDmvhvqO7J2v
	nxDbfgzKNZBJ/nmkI3b+SbZOlCeG9gJKGCKlBXNtw66E+keGky5OYOcgfzTpVtQSMGQaP8YrrK7
	FgfomYV6XnP0TdPtxZVg0v8iVYURV1+q6Ilu9a7Qg2XPJ5IESY4X5gWcZhFS4dS2X+E3KsY9k4W
	IlVFXRhPLTTO0Pgx2E4yg9Fq2hHPXoyACdysaa5sYXM8n8QPfka/BroHZLbFzD9cX73KkhKVFqZ
	KvCbIdz9LcG62I7RXK5jJYLeWIuNghCnifImJPjzz0exu/AAd7QcU78iiU17ku5H0TCxWblICmq
	xWwc55rx+apzIEWDEF08QodmKK1YhvB47IT6Z7g==
X-Received: by 2002:a05:622a:a14:b0:536:6ae9:f55f with SMTP id
 d75a77b69052e-55d8900bdcfmr34062041cf.7.1795782567558; Fri, 27 Nov 2026
 04:29:27 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261109182533.3594984-1-lrizzo@google.com> <20261120010655.467825-1-lrizzo@google.com>
 <20261120135013.GO3115493@ziepe.ca> <CAMOZA0LmZ9PFzxLcc1SuS8piFyZu6P=vX_qR2jy-3QRUoNCUKA@mail.gmail.com>
 <1f10002ea9ee16a17087bd06e4a1685a973fdf6e.camel@linux.ibm.com>
 <CAMP57yVZx=s-JXHfQfd_ouv2jV6MMsJXpxVLkQQHG=7qfFVJfA@mail.gmail.com> <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
In-Reply-To: <d42bd9452d00a0b2a5b7d6652d556c9fc8d2c830.camel@linux.ibm.com>
From: Luigi Rizzo <lrizzo@google.com>
Date: Fri, 27 Nov 2026 13:28:50 +0100
X-Gm-Features: Aa3M54o01jhZM9dCQYVFb8_-yMQWCkVYamRB04RwDLjyCo_Cf-5r3I24fRo_Jr4
Message-ID: <CAMOZA0JMZ8wUrV08YznFUH7AkmyqXcNdzfd26KsoTtzqt69SVA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/25] PISA: Pre-mapped IOVA Superpage Allocator
 for DMA and CoCo
To: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Naman Gulati <namangulati@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Jens Axboe <axboe@kernel.dk>, 
	"David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Luigi Rizzo <rizzo.unipi@gmail.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Rafael J . Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Simon Horman <horms@kernel.org>, Jesper Dangaard Brouer <hawk@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Willem de Bruijn <willemb@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Joshua Washington <joshwash@google.com>, 
	Harshitha Ramamurthy <hramamurthy@google.com>, Alexander Lobakin <aleksander.lobakin@intel.com>, 
	Christoph Hellwig <hch@lst.de>, Dragos Tatulea <dtatulea@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org, 
	iommu@lists.linux.dev, netdev@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Queue-Id: 21CD312000C
X-Stat-Signature: 36f48rdfy3y7krau41okc4r5xj3obnwg
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795782568-443723
X-HE-Meta: U2FsdGVkX19VaB0gyHAQ9MLDrD1bNw7tiLJinMhGXMtMipWDs/B6naM4gV5JBHpr+if8iFKWQFDbGxFHqhYB1zY5hieGe+ThhpkzTzg84UfRj2tkAs4/8H2j4/ccOqZUj/he5XtI04jxki7DIyP5TfwN9I7pUMiP46nIN/KxiCrZ/w/PMbjSyqbHKW1fdm8lr3JOkdNU1nINQF7h+3TUBjpyS/1bMu6rB8P7Wx8yCMhQpirL1OQ8RJwPY2ilbPqjcxT5gtmEF2TLO8qFrSKpFgLOpGJ8rqJmYvPVVFk9P77fVqYfGTlTSBiiLT1idv8C75jnwXD+Vu+MmRXWczpnjKq5Xbo6vumg/6WENCRc9jscORBUMKQIny8KZoL/cJ+gEAJjKQK0NaPsls7Pty/PipaeQZGqDVNo9ThRxmiayEDPRpy7EVyVA6XnWNClmLxfxEGO6BM/ksQC50/Fm4J2d//Cn6YHxTQcfKTeA8uX8rMlyl4SekRgKE/kAGkrL8fdwfOaKEmIvlLGPrMS1BhIeziSg+/DLHusGgiZgPPN2E2zsurCc4F4+xLq7QoRUDFXotd/JQOJOXIMYLiJpoUTdrmhuqZO6KdgjbiyilKE23KIPGtYuRQVES5Ufji7Ev81nyj9V25Y3b8kBbMJWf/5xuDKWpeYi+Lqs5PfultzjKzbdju5iGFRNTQ4LHTyHwVg2cRZN+P6QwCZfxH5cSNiD/09l0+aVSIZ+RoeiXh6d2OjdFWB1x1d1MNY8KgnMw87YzsZM36QCFuy1OCtmPkmRWQHpdn2FlOfoIK23VFbql//vkCOh5EcBic90z81geyGiJ6C4DiWZ9idQJxaeOCcg+Dy/azVjzIdzAKuethz+UIlOtO/l23s1fELTUSvdhXVzdRTouVBo1T7lO+2KJoS7lZVohDe16HHb6nQPphFAvWbf8r95Sgh2sQsKT70EumBg2Yceb8hZ3dNZzYM7Ca
 yPfJuoBy
 YUjtqlAQ8tw035JaSIQcbfLT9fK7Z6NYA5HaEOaiss9e4dEmMGX7WTVW6sEmvetx3HqZV4gu6CDAlBYNnBNzheYn8cpgLG3bPsayxlPW/NIHE8JIp/4QsUrrYIbuQKTP++4xBRd49y/3rlQEVPUtWbj16Y4A9rFAdUMnpt6KjSEYI/ioE2Fq+/g9cZHkSx4E8eHWVs4AlJqbL9KH9sx7FHkb8UUUEYYtSRE9QAplYUX6+mbvD0cIRVvgwSiuYkhfx6L5p8hVWDpYTbpfixhjzR4DFDsx1dy6EAezsNPDjCeNaBaaYALSvgYWMOdEj+FDzsfDmwk0vic9fyfb23h3L7JCYmsyb+HR9oQWxLiRWuTpBag3oOJAqdfrPWrYfRfCw/jS0qo9s0WiX5jjA4JKnpXDHsaIObgwCkSaO6tYTH+yK5KLLxR2jXH6vDpyxuBQyDr5iW1MW1BRUhLss4smLI4yftfufN0iT3ClG2qAI+6N9v6Ljj+FSjs65FKQq/7HNQFfb35R24LgWK9e1Yn6jXFbUgGH30dSl699n1y7yuIdluPW72x2/LKnvGPU4igm8vNALw/Viy8LH9/TyrgoFOiAG6x5GOWuGHrtUH7gyZxCgS5Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Catching up on a few comments:

On Thu, Nov 26, 2026 at 9:46=E2=80=AFPM Niklas Schnelle <schnelle@linux.ibm=
.com> wrote:
>
> On Mon, 2026-11-23 at 09:50 -0800, Naman Gulati wrote:
> > On Mon, Nov 23, 2026 at 2:10=E2=80=AFAM Niklas Schnelle <schnelle@linux=
.ibm.com> wrote:
...
> > > I think that approach would also align with Jason's idea to keep thin=
gs
> > > within the network stack and to work with the tools we have until the=
ir
> > > limits become very clear.
> >
> > Hi Niklas,
> >
> > I have been working on this idea exactly - extending the network
> > page-pool with a memory provider that allocates large pages, splitting
> > them into N smaller pages that all share a single IOMMU entry. I
> > breifly shared my approach in the v1 PMD series [1]. I'm readying a
> > short RFC to share shortly, would appreciate your feedback.
> >
> >
> > [1] https://lore.kernel.org/netdev/CAMP57yWvHO0pWCR3-9q1gtwVe8WV4Y6i69t=
rmw+BJRVYf3JB1g@mail.gmail.com/
> >
>
> Hi Naman,
>
> This does look more contained, but I'd say you should still go simpler
> and fewer steps per series. Some thoughts:
...
> - This is still a LOT of churn, my gut says much of the benefit should
> be possible with much less churn. It's really too much to follow but a
> cursory look makes me feel like there is duplication between rx and tx,
> which is weird since for the pre-mapping they should be quite similar.
> There also seems to be very little integration with the existing page
> pool, rather it seems to set up a parallel mechanism for the pre-mapped
> buffers. Really in a first step I think we "just" want to use a more
> efficient DMA mapping and contiguous memory chunks for the page pool
> and also keep the page pool API unchanged as much as possible.

The implementations seem large because they expose limitations
in the current kernel code (or our understanding of it;
but the proof is in the pudding). Networking for one, since you
mention it: the tx path allocates memory in many places without any
hint on how the memory will be used (loopback or device with IOMMU ?
cleartext or encrypted?).

If we limit to the easy parts (e.g. just network RX) we may avoid
some churn but we will not resolve the problems arising
from reasonably strict IOMMU deployments on large systems:
- IOTLB thrashing (network traffic uses separate PTEs for
  rx buffers, rx headers, tx_buffers, tx headers). Rx buffers
  are only 25..50% of the total. See [1] for some data.
- per-buffer VM exits on overcommitted VMs (same problem as above)
- IOMMU unmap serialization (with strict DMA, I measured over 10us under lo=
ad)
- swiotlb copy cost (on tx and a backlogged queue, most of the copies
  happen on the TX softirq handler).

Also we will not be able to see what is lacking in the current kernel
code to address all the above.

What I wanted to do with my series (Request-For-Comment, for a reason)
was to identify the components we presumably need (meaning: implement,
or figure out where they already exist and actually do what we need)
and get an idea of how intrusive the changes would be.

Then it is completely fair to say that the goal is not worth the effort
and should not be pursued, or to take the low-hanging fruits out of it.

cheers
luigi

[1] Here is an experiment with a system using bidirectional TCP
traffic on multiple NICs, where IOTLB thrashing becomes a bottleneck.
Below is how total throughput (TCP payload TX+RX across all NICs)
changes using 2MB mappings for different regions.
We really need to cover them all to recover the performance
of identity mode

Use of 2MB mappings         total TCP throughput Gbps
-----------------------------------------------------
none                                  440
rings                                 572
rx_buf rings                          577
rx_buf tx_hdr                         572
rx_buf tx_buf                         649
rx_buf rx_hdr                         674
rx_buf rx_hdr tx_buf                  716
rx_buf tx_buf tx_hdr                  734
rx_buf rx_hdr tx_buf tx_hdr rings     744
identity mode                         744
------------------------------------------------------

