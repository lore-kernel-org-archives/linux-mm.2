Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C5C9C5AC82
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 03:36:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B5946B007B; Sun,  9 Aug 2026 23:36:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1667F6B008A; Sun,  9 Aug 2026 23:36:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055966B008C; Sun,  9 Aug 2026 23:36:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5E466B007B
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 23:36:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D9D27A2893
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:36:23 +0000 (UTC)
X-FDA: 85083947046.01.E87BF17
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 012B7100005
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 03:36:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EYDavEcJ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786332982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLQJq5G+7lEO8q36b2mv1yMCYoZ1x/NgyUsbF06t2iY=;
	b=2Ng8MUFIhnS72WaaoWxAhQ0lcWmwkcbwe4imK1FuIxdsG6+ZLkE73gI0AJ0uUHeXNITnDo
	zU8FPDtnZxjlissBWi5bYpcz3jRHlvnplM2ivXmi+8RRfwJyPzMw5L4EtnEJ4dpP7EMNE+
	au579vCbFP1ZHFiG3RJHjGLV3WY2SLk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786332982;
	b=3NlQBuEyQgR3tIospb3Vp9BxJS9N3dDVtwLMtQEnkR/KfDWTSrupkqzz2r7ghvXodqQbJl
	sbfY8+UQaQA80YtCGvH9D8OYkY3LjKWXOg+88d/n62Ubj5tkFj1s6cqC52clvPS21g9GGF
	L9BoheEpgXmivCAgnmxlQr47gq4QM94=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EYDavEcJ;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c15e2dab83eso199503166b.1
        for <linux-mm@kvack.org>; Sun, 09 Aug 2026 20:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786332980; cv=none;
        d=google.com; s=arc-20260327;
        b=ZOIG720A7xhhs2iHB+ZhuNpG9L0yS3nOZgiXS/xEFHkiyjScyB+6KREbXLKp7dQJfA
         9+epQMAfMEVs9ulQNJFYpLEWB7zixjFcXFr/ft41Yf6B7/qDEH/p4cNg876Tvj4cXidU
         Lwfputdf1RPCgHOaAEy9KhWXBde77wE5/kE6kty+i6FSl5YRGGvWw/7QIq59pWwHtVq0
         o/FbyGvK86Edjgd4qgIDsoiOHZp9B90sMIC0iio1d16naD7AXB1epxNTeOTNPAhcVodz
         snK2drNrGhCiaSuIqvQkO9e7Fjg7YXQjrJsGWXMjzeCDzStlv00E7dtYJ2+pR/HFBxnJ
         XycA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yLQJq5G+7lEO8q36b2mv1yMCYoZ1x/NgyUsbF06t2iY=;
        fh=3eK/jkbZOoHc15VoUJwOGUryFf50diLm6hH5FkYkqeM=;
        b=e4DAaDL/PHp7T96q4LCg1i1F0RrKeOZLq//gU5Zi92M/BFxLIcjAzX/hsN/ejzP+Su
         y8OD0aZ3R4SpQQCBvVIfY6K2l9Va8Ua2HChP5hf6mx40PPVcpT8R0uFTZEKrU8esHwXD
         RMWhBBaIpInfbH0FhVRHFWr9nw4BDfGDQG6j5IPzcvaVrnsKXR7o1MG4g4VisBMCIDV1
         C9p5D+Vw0ewvFGpRzvWXq8vG5iiqFOGiRfUb/JZ+HBXTwvNb+FwN3sS2ru4uLypUlEjm
         +2Tfm3AWml7QaNbSQ3zzBZLVOOiH3gtUJVFejZzQDQoamunAXGHrcMDsHgVE053YH2oA
         IVYQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786332980; x=1786937780; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yLQJq5G+7lEO8q36b2mv1yMCYoZ1x/NgyUsbF06t2iY=;
        b=EYDavEcJD23OKFztTLFD3gXM1n0QUSNmcl2YauMczi2H27qB6EcyCAHhzLTcSNde7i
         Xo4Y0DRZpvKQFhXCpZCGPt9K7Z928UXvOmbXYUm0FKQpSQhTAjP2SmHkjsHWrdvfIcu0
         B1hXPJGi0OSi5qKyVPZc/UdOETwY+WPfELRMT5PMLW6dcoGoEzOGcGgK9wMkCaiEmE8B
         IPoW77OgetWZSPAO5PuEISimafq0VI2lzIvQbYIDTKLv8ql2u6qydkiXtkLE5bBXCEaY
         UAk1GIDRYk41hL5316Gd1cmePZ2djYUohAjGXEQefnJ5zLOlSsoLxYmavgV7HLAP07kZ
         1TcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786332980; x=1786937780;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yLQJq5G+7lEO8q36b2mv1yMCYoZ1x/NgyUsbF06t2iY=;
        b=amFdhRThEhsCj9EWtRl1I9lXnZ+JIol2ex7xKYM45oCHM0TTYIP7dA+J6jEu/ggUeb
         qVYJM3GNb0Q+83IpxEAe/TrDatVwLMgzH92PllmMzR0UgVI7/EZG6hXSYVqgu1TGGCgk
         DSpXvBje0gvkX1LevQJXB2Ns8HmMwRBm8+s0aO3Ld5q2Qo3erpOfYCBjanDw0H1+4Kr7
         jMJiElY/h/Vs/KHImSfM4gBaXfzV7T8zh/EDYvwC++iEgQMTsOiq+c8YA2FaiGvu90My
         4+fLKJLk3ZUPJQZ3cwbGEM0jsvgBydHPrS83JvNkvPRHKMm58joGM9T8PwYE2JLMfuy2
         TSbQ==
X-Gm-Message-State: AOJu0YwnDY3zRar69qPDeikKKkLN5iNdsLBDljxZSJnXaHDNN4Y9FnyC
	gIkiP2pTS3eVbaf3iZsS4zzPzdg1x8sXCEEtp+7R0IWNJuZxKKyNw8Bbxs5xrRv9fHQD8vsnYVX
	ymbiov8pof8YTYGZFM5NEaGMRi6Pxm1o=
X-Gm-Gg: AR+sD11oZUBS1vxHpUVZv5VQvvOsErzScsED90oJVvYVW35ikxFQOUtrRQ9B9Wl9A/s
	W1hhg93irczFRtQJCVY+s3vieH3WvgVBaKUJJ/0j8ZWEpElllDALoh3MyYWpf12nXieFWG33vOn
	K98DReWw8dDea2F4jF/wX2NQ/vHWgBeXtm2dBee3yBmcCFHxxCfE9ouP7BXmaBXu1cwOFD9juXP
	Xx1/h0DF03O7f+Y6/brfDS0MSAac6I3JZjI4XOwyLrCRfT1W/RcxZAmZI50zmMiKxm1MMpNVEic
	8/756SMu7mWnEDSMoUlmyMJnvHlcloj6RmA6/ephv/2nfK+EzGx5U/zhqTzXwz2k1J0/2y1Vv2z
	6Cg==
X-Received: by 2002:a17:907:d409:b0:c16:2139:dae4 with SMTP id
 a640c23a62f3a-c207eb4f778mr1046123466b.6.1786332980141; Sun, 09 Aug 2026
 20:36:20 -0700 (PDT)
MIME-Version: 1.0
References: <20260808-swap-thp-cleanup-v1-0-689939a7ccc3@tencent.com>
 <20260808-swap-thp-cleanup-v1-5-689939a7ccc3@tencent.com> <DKK1E8OEGPDZ.3NO34RHQEGIRJ@nvidia.com>
In-Reply-To: <DKK1E8OEGPDZ.3NO34RHQEGIRJ@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 10 Aug 2026 11:35:43 +0800
X-Gm-Features: AUfX_mzTrzJ0lwFbbSxNsYhM_xsUsWMc2wdF_J8gimKxTXTperVV-iRWiRP6JBM
Message-ID: <CAMgjq7D=o3MMEroOU-RxsQrjX2DzJhDdi0YcK=wEz9c8yE=wrQ@mail.gmail.com>
Subject: Re: [PATCH RFC 05/13] mm/huge_memory: consolidate irq and locking for
 folio split
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 012B7100005
X-Stat-Signature: r6p1wnr5pccrrsmue1yrrad5etdhgckc
X-Rspam-User: 
X-HE-Tag: 1786332981-780415
X-HE-Meta: U2FsdGVkX1+Kt3fPYabYDoUiDHjV6r8UXE3TkATaw7H1243hEoXwDDT6nG/qS8LrSjDyzlerlQ+D72R9/myDRjGbnj8F4IxWoOKkwwYII+dk8nq0KI1I/U/v6uTXCaOVlgwe/g80ncBAylh3Ab1zEBvzFC54b14cQZJmeqW1NCS9WosQqK2Am3dJlsAOpe5gMyg8DGgpBlqrqy81whpt5MI6f4guLVSvccK/VVX8q0nY0+ofm9g4eXy03XdQQZ/gEXnujJkq1sT2IvMId8PyegcJ9YOkEOnZfmQNbBnWLHjoV3Ii1dwhWWVGQKSy4hGshKdQQVihimuVpJGm8CChF/Xt9fLPZsltIAQno6+djYgmVs89Kfwzchsc2aRKXxZT8khs6VUOg3rbhMu7eNrpLmqkXzGwH+VPDonjbQRCsgYPA8DQCqU0hsBithAs3owZeU+MW46pQxXMcTECh7uzuxMEHjc9E9kcS8HmTl6Y+1TSFWbgIzRwzotjORN7UKwTetNAh5OHGPTQbrxijrE33KeQcxwUvNl119uuoF+lS52Xw4wF5LkOxam9B1tFMC5DpDP4vq+kHMaHFy9/DiGm4zuxUohAH45gWXN1oBRVknsZOgMuBkparC1xObKlzwgngH2OfNytyqcdanSqHypPaEvm4OU34D68XOJlTu+3u8eA+KZAQWNxbSghaZesyo+2fCKVjdUJ0IHzRHPqd/r/DZHt1yOdKT8Qx9PpCSOwuc1gDdcDBvyHv9Hsqinf/pnY2Xwld7AYDp2TSl+Ot8/ni+AbydKrCas3DCDAkNB4OvqicF3fuxR8Oh5P+/h4QVUX6DZ+foiCKZaDBgA2IAPEtg1tcScV1h21GlPmhyVhOWzZg7ItyWQu8NY5Cj0c+ryaDjX1mTBHZ/HaLqhtHB8nOPivpvA01hCV9uuvOmB47+S/rokmQIJAeV5pLZIzhaXFF0rO2/41zVr2wQHLN5j
 /3Qhbp+v
 vOEH0lxxqxRECZqpiL6And8JFVyPIkNok8XEAc+G9+mLVexLZF/a+Qrs5NmGilWnbBReZIh46zUiJh7A/sl/oPqCvyLiGM5Uzn9v94CjFVPM8l9SemU/8ZJz4t8ecoJI1kTYcSRsf2a9Dz5V9kxPa8ELdWOwZVYkE9ouDQ0V0qPJp/puPb+euytKJalWUTbe9dM5QdU7UtCi3dOMVBE8n1CmeLyQETmrvijzLK933bgYrIFWqd/sU/SgeHC2VQ+XwGM5MptQEyNx3nWHzMU8Kq2DWBTdu78I/Hv3Vwh26vr6On8Gh17jpkfPkrqkaQNdAaVThizQlaG6mnb4vO+rhXHaO0uk9YNKE9bhA8kBsXPntC59TXNfY6ZShCTK7WqrbNT07wYygyZAEaNAFA4YWaFGwoPQkX9bpmipz9DZxpLy4Vkr5d9WjinjfPzJ0T0SfDj+z73YgQrmGOpaltgvcWgbC+CnNgPo0bHIADiiUbCHM9CAz5m+scOWE7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 9, 2026 at 9:54=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Fri Aug 7, 2026 at 5:17 PM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Let each split helper handle its own locking instead of relying on
> > the caller, so both paths follow the same convention and __folio_split(=
)
> > can drop its local irq handling and fail label, preparing for further
> > cleanup.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 52 ++++++++++++++++++++++++------------------------=
----
> >  1 file changed, 24 insertions(+), 28 deletions(-)
> >
>
> <snip>
>
> anon part is not changed.

Right, I can mention this in commit message.

>
> > @@ -4035,8 +4039,21 @@ static int __folio_freeze_split_unmapped_file(st=
ruct folio *folio, unsigned int
> >       struct lruvec *lruvec;
> >       int ret;
> >
> > -     if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
> > -             return -EAGAIN;
> > +     xas_lock_irq(xas);
>
> local_irq_disable() + xas_lock() is replaced by xas_lock_irq(). Are they
> equivalent? Codex told me that the latter no longer prevents preemption
> on RT kernel and can lengthen folio split process if it is preempted. It
> is worth spell out in the commit message after you verify it.

It's a typical RT tradeoff, but I think it's actually an improvement?
The old behavior was an actual RT anti-pattern, RT cares more about
latency. I also traced other freeze & filemap update user, most are
using xas_lock_irq, and that seems better. I'll mention this in commit
message.

> > +
> > +     /*
> > +      * Check if the folio is present in page cache.
> > +      * We assume all tail are present too, if folio is there.
> > +      */
>
> xas_reset() is gone here. It seems to be a no-op, since xas is not
> walked yet. But it is better to mention it in the commit message.

Will do.

Thanks for the review!

