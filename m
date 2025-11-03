Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24B50CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 09:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8128480007; Mon,  3 Nov 2025 04:03:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA5D8E002A; Mon,  3 Nov 2025 04:03:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700B880007; Mon,  3 Nov 2025 04:03:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7768E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 04:03:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F0E5D140AD7
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:03:08 +0000 (UTC)
X-FDA: 84068706456.01.7085233
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id EEA50140014
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 09:03:06 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nWD5UfQo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762160587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9T7VVeR5SZ1Y+UtEgoxTT2SUnCxjpaxNBL714fyXlfQ=;
	b=6DRiNzxNxScJ031A2007dIIXvaBl/s+Au7wuY3hzlwaRkkuZktLlBn4q111OIBQxgU8sFw
	zt3N1TfEXTMqMHy8jLR4Do4ILg1uZm1KrjVbR5G1LTmGK52V8Lszfj931Wmu7bU907Ez1K
	uxSjv+QN0ipATFVyb56Uv1z8wCPw8qc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762160587; a=rsa-sha256;
	cv=none;
	b=u2mIEEFWNE/GyyFh1WFZT0SpaF41Kfwf++TCoEJOx8wRuuI1LZOsl/kxQm9FYuPZrWHfqp
	V2UXZGAJEByrCa1jnw7qJdOE2setW8OPtUqHTGSD91tpMBO8d/AUAXMNBi3luJMDBq4HsA
	cC3BRrYpLKtLrgj72iTrWPEibbiCVUc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nWD5UfQo;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b6d78062424so819710666b.1
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 01:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762160585; x=1762765385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9T7VVeR5SZ1Y+UtEgoxTT2SUnCxjpaxNBL714fyXlfQ=;
        b=nWD5UfQo6/PJUGttAS2+5rSOLEcQaFFhASyL2UZcELohfIq3yM0LdHQ8JBOttZDcko
         2L3dWmem1ChcmXjKPQQ5Ikc/6JNcTVZs9hX/7s+bo6dUosuPQEOEpRGzVu6rfivRxvLz
         oDxEDXiMij6bqRK2s/9+gMFjwmXjzNiLfWOtYsEskgv+DyVkHP9p2tUip0rMwlzd9Koc
         Myub0iMf7YFZ3UijqW78lXN/54OqUz7v4V3xQfnauQEYRfWvjamHYSVIgwcrY8BLPFIk
         JrIvnoQrnVhpIctLfLx86VX528shRlqDBEQzDvkVd4RfMht1gdyAH7Q1A1wzC7uZnZ9N
         stEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762160585; x=1762765385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9T7VVeR5SZ1Y+UtEgoxTT2SUnCxjpaxNBL714fyXlfQ=;
        b=EEbrEtWs4kdaG6ux2uBKui/30yfNVFcCTu1gc027bz/xsegfJvHHqlirVWWPSdiSm9
         jYJPn1T5VTCU0a2gohrwEdR7k23Yf+/r1xdAuipOKRdDBLy3lxok0gUO1dFTxgBv/mQn
         Zwap/YWk6FZ4FagnpiNlDgfVgr9fUh3ujmEirqOrv2zfVlU0ARyGDrH0jbHnwTSR4tKB
         JbLvjv9OFu/Rc4+1GKby9qcs3RlD+D6QcjG6zSS2N6woXVfRuvjKjjGeC6G6vJKxevtW
         gRCVx/Jm196Gj3Cw/NK2FpvnG6kVLO68WQqoITxoR/rgjWsKmnWOS7fkgNhSzZqNI1lD
         YUpA==
X-Gm-Message-State: AOJu0YwtUy1nsjLIvnPxx4OTZPAMYqJGhZcBoZ8/Js4WGJnW9rdfp0rr
	ENQhrC3Dgg8/qCzJBT1pAEDaZkVMap7sWJQ6qYgKPYbVAjXHv9RJYxhTPwHznCtKpjhAWTz9bGU
	6phncuA+4wlG5WbDo6He7KHJLtcNB+xA=
X-Gm-Gg: ASbGncv5TTgcyA/Wn/zrW0rG5SiNQU4J9iAe5LQrAFCl7H5AIcufNonvX5NazRUm1DZ
	Uer+uOFclmqFul4LHSx04VVREUtk2uY0yhqAStJC97W/gV7H3tVFt3Yw3au8Cgpw52miwOztdA+
	ir6TnwIf8u6Guz+dr3X4ivs1o1BKNwdtQgD6wFs+aHWqKYo9nZ2EiBShEpcnBUyMxxfy2Ju/iqj
	3O1gYKaIP3EO/2TDPidXg+tOsvraoGbQYJ9Mc6R3+pZYlC8ye9cCUvK9cjM8tthuYbjJLC9pXA=
X-Google-Smtp-Source: AGHT+IFCBRuHUUpuZZVGb4J6LbfjdzLPr770yQ4KDIf8nZ/dKWtpeEeM9Jjed5KRUXQQcX5vBySRqJsHRHWU8GqbVS0=
X-Received: by 2002:a17:907:3d0a:b0:b3d:200a:bd6e with SMTP id
 a640c23a62f3a-b7070732726mr1059895366b.47.1762160584911; Mon, 03 Nov 2025
 01:03:04 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-1-3d43f3b6ec32@tencent.com> <ufy26fqfvaxqjywneec3hcuky7ozpa2fm63pxcuuberrvicffv@bkblomeix35w>
 <CAGsJ_4x1P0ypm70De7qDcDxqvY93GEPW6X2sBS_xfSUem5_S2w@mail.gmail.com>
In-Reply-To: <CAGsJ_4x1P0ypm70De7qDcDxqvY93GEPW6X2sBS_xfSUem5_S2w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 3 Nov 2025 17:02:28 +0800
X-Gm-Features: AWmQ_bmASoQJptoYUDSSf0xtLCvU3CgV-TSaLDOVl7Wku35dACNX6xNRDzn0jTc
Message-ID: <CAMgjq7A+OBoH71qo=Vt65BeV7M9uOvkJ+9pQX2eq4-tqcKwVwg@mail.gmail.com>
Subject: Re: [PATCH 01/19] mm/swap: rename __read_swap_cache_async to swap_cache_alloc_folio
To: Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: qh3tshpobwzdccuqciopwkfh4pbrt9cb
X-Rspam-User: 
X-Rspamd-Queue-Id: EEA50140014
X-HE-Tag: 1762160586-790799
X-HE-Meta: U2FsdGVkX18O66ysxPaIQoAQr+XK479ngRoIx3JMMZdqMTMjHOSimnvd3/HWZZkuPDTCupIi4+tCVRa/i3V0hoO8M4+7+hc7x7VeYO9AtcSd/+XrgM4vc7/EZHpf/f4XkfMWZ3UScJBSHkmMJzOncPWK09+8rmlz2IxEQ/hy2Q5TcGfMBvR9OF9mIVSxWuJKN//3XMc3MkluZ+nkC8xhroZO3wyYnD5uF+zNhIeTqrsqvjHLj20LJiL/7F8nWBs14vSHMnCG0zZEzhMTYlBf0/BVTz5hUjWPGhf/GiPiBp1o/cQ20AANS19+kn/mySBpuE5LQGki4ffvB5iWqOdv+fb2aj24CRWW70zHhkW3QaC+K1cGnhkrYJRaKGLrFWqTmASCHrM8H0pLw2Yx92lS+Uu3r9lBlV7jm1MxDYeL8u1inOjYKBLbC7/Nc2KKKxnE9hrddpxp1RH8i6QR6Muz013K3wOmTDaso55Ea9PnLTWk+pM+ZkN5vt4AVAA3RAYxGA7zUMlYeEnlSRyyFNyOHfI4EZNHG/zbv2afdfC6wFrvHpDSWB930UlD8urqwNQf3bYpCx3b3ycOrBXf0F8cuTrfF31W/ACCcyyeEmJjf9DRESPPywVwtWJO2W7i4qa5/B1eWKoXjIFiKaLxa5m0cqRB5PAmxnOwEYlPJRg105UfdwA2kW12zkLkmF6UdDx6Mpewd+n3+Cd2j/1Tezhf3+zaLzs/U5Kzk9FehVCReCN5xWKCLvF2JLqv0tqnkAoO8aNIkW6zSUN0NIcSM3qBmm6WtMyyfuhQQZGyEcnQs/VVL7g3nx2LVYy0RCXGq9ZhSAlnhDGeek8bcntauPUJvCIUCqXAOv0q96bv76+sqtSxZ9t8MhDfwj46IHbM6/PNWOsHDNdyZhkO0/0VJZm37cSRxunGGDYUuW2BAOUByPSrk53/BJP5mBlGozB0RctdCTfihiQXMSIlnqpE658
 C6QYKlSc
 nUvrQWvvGfytkdjUIkPxZsSqHjRy5d1jUJ7pdpQ0tgRiWY95SpjONUrUEZkT/3f6npF/SNk3Kg+eCnM/djDbJ0tn8dY4cwKKLXKpEZcZvJzv5yEbEZyxmta+QGyk6Hpxw742oIUFW5Qo2/F9Jv5OGhLTQkOl1k1EPOoncK5cj/vWQJy5/XCFidGnqzOsok0SVgoEg+SgVYPjPj4sk1OywWaqvOKFPLm4ziU7sf7Bx4y100nn7uvh+tl2ORlUk/AJbCe8pPHsEsVTHQh7eg0zNxJYWDEThJTxm8btXg+q0ShYasljiTqAhV6BFOgDwHyvb7Q/3O0kar56aG+LRQoC502C3PNdqlmc447ZWBRBusSbCpT4+AwqfLKi2AmDQetsLe8qKXF6EVZcOTw5ndgr3Qz4gfUzXqWoorG/fVzSq7INxP5g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 4:28=E2=80=AFPM Barry Song <baohua@kernel.org> wrote=
:
> > > +/**
> > > + * swap_cache_alloc_folio - Allocate folio for swapped out slot in s=
wap cache.
> > > + * @entry: the swapped out swap entry to be binded to the folio.
> > > + * @gfp_mask: memory allocation flags
> > > + * @mpol: NUMA memory allocation policy to be applied
> > > + * @ilx: NUMA interleave index, for use only when MPOL_INTERLEAVE
> > > + * @new_page_allocated: sets true if allocation happened, false othe=
rwise
> > > + * @skip_if_exists: if the slot is a partially cached state, return =
NULL.
> > > + *                  This is a workaround that would be removed short=
ly.
> > > + *
> > > + * Allocate a folio in the swap cache for one swap slot, typically b=
efore
> > > + * doing IO (swap in or swap out). The swap slot indicated by @entry=
 must
> > > + * have a non-zero swap count (swapped out). Currently only supports=
 order 0.

Hi Yosry and Barry, thanks for the review.

> >
> > Is it used for swap in? That's confusing because the next sentence
> > mention that it needs to be already swapped out.

Yes, swap in is the typical user, swap_vma_readahead calls this
function directly, allocate a folio then initiate the swap in IO.

I'm not sure why it is confusing. A swapped out slot getting swapped
in seems a very common thing?

> >
> > I suspect you're referring to the zswap writeback use case, but in this
> > case we're still "swapping-in" the folio from zswap to swap it out to
> > disk. I'd avoid mentioning swap in here because it's confusing.

Oh, I thought the zswap writeback is considered a kind of swap out :),
since it's technically writing data from ram to swap device.

>
> I assume you mean avoiding any mention of swap-out? As for swap-out, we=
=E2=80=99re
> swapping a folio out from the LRU =E2=80=94 we=E2=80=99re not allocating =
a new folio.
>
> BTW, this sentence also feels a bit odd to me. I=E2=80=99d prefer removin=
g
> =E2=80=9Cswap out=E2=80=9D from
> =E2=80=9Cdoing IO (swap in or swap out)=E2=80=9D.

How about "doing IO (e.g. swap in or zswap writeback)"? Swap-in is a
very common user, and zswap writeback can be mentioned explicitly.

>
> Thanks
> Barry

