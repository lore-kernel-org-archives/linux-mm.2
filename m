Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 762FBCD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 01:00:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E4B6B008C; Thu, 18 Jun 2026 21:00:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BF376B00B7; Thu, 18 Jun 2026 21:00:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEAD6B00DE; Thu, 18 Jun 2026 21:00:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15DE36B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 21:00:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 880731A02E8
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:00:11 +0000 (UTC)
X-FDA: 84894855822.27.AD230C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8B834180013
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:00:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyJ6mCIh;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781830809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6SFE2oQzeZFnXkqCkeyFad/nYElmYu9Pye6H+bNxYI=;
	b=k1FlZfVoZpQsAAGiojG8oYTGKCH9Fl97mo+WqlJSiAStJjpceWMt8ZzpJ+KzPNpHVh/IuE
	os+Qv0TRmb72CoN+MWTqZCpJPwvKn2WAhvSW4qlC6frTsLevh/XXDezlsz3ADpobHMDuhl
	2DkxCXnpBlVPlJNNbM3Z9a2NuWAz6VU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HyJ6mCIh;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781830809;
	b=cpIlfon+7wWjp7KbqzZTGy3utf8XwPnXcoYgZlrqwF31jgcjpzjB/bedKvmEqOrLwp11bT
	XekIfSgNJ5YBVBlZcgYtgqW5Kb1oir8szXgyh5xuvbZkqnDdZ42LT+GotB8mxMNmz4vdos
	XXbJcipA6m8yYLwKPkbzG0aUNBRTkL0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7DE843F19
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A07E1F000E9
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781830808;
	bh=l6SFE2oQzeZFnXkqCkeyFad/nYElmYu9Pye6H+bNxYI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HyJ6mCIhP8WH+EMNPrvJDKLqVtbjk+mitDHbUMW32HsLmjzMCy+rufwPi74sYRWGa
	 F7cKF4dqL3CL868toxbS9C6LIL25mM7OEE/cpf5kvStMPJDVNqwOwaVNvKGzmPfLq0
	 l5ZekcnGJwPtMp53v3GHvMaaWMSWMSlzHEoUmWYSC67MCsqKr4NAP7pd04bGzX0zeR
	 IrLVU0C0Yy73suw2uSbTHZuEJy6ZSnIXROapwAi4FG7vlb437whQs5gsIzYwrVspxI
	 oc84u5RCecDYaa0p/C0aU7MKfC0YasLKqo7fxqE0OvwzBriW6QRF69umq3JaYhfZXa
	 EN4ooFbmIDZWA==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-915b5ce94c7so191945185a.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 18:00:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9zm7hYH2CYs4MMEofFMbZdb/mEB+HM+I8oNs57qKsWif7SWjouAETOyobMXKTee/y6/m1Lpgi4gw==@kvack.org
X-Gm-Message-State: AOJu0YxIwAKfGgGjGpI3pe0ZQAlvOjkS7D/4WrmaSqXDGjQrenl0JhGX
	SIUf/C3XFjgUCa28RlO3tyh7ap0f8q+8cMmSDw5DqORL21yN5d4sBYOkMGTCTS+jtwSZDigPZwI
	FuTFLqiFF3jZXYWbdExAJ6X0ekoiQPp0=
X-Received: by 2002:a05:620a:6f04:b0:915:d322:c46c with SMTP id
 af79cd13be357-9208e49915fmr254848185a.7.1781830808004; Thu, 18 Jun 2026
 18:00:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260618221720.71768-1-baohua@kernel.org> <CAA1CXcABVASpEiK-NksA6sfZm0yssiFO0VS7KKELd5kzOONjbg@mail.gmail.com>
In-Reply-To: <CAA1CXcABVASpEiK-NksA6sfZm0yssiFO0VS7KKELd5kzOONjbg@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 19 Jun 2026 08:59:57 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xq_-dcDxuOpkgjgHVL2kz1t0jCmF6-ky6zeLJ=7PKdkw@mail.gmail.com>
X-Gm-Features: AVVi8CeVlUWEj4MTDblDlVVsQhkWxiTFCKwTjBZk8Ug5aGEa50WpbwRBtGF79To
Message-ID: <CAGsJ_4xq_-dcDxuOpkgjgHVL2kz1t0jCmF6-ky6zeLJ=7PKdkw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: Nico Pache <npache@redhat.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nanzhe Zhao <zhaonanzhe@xiaomi.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8B834180013
X-Stat-Signature: zphceqbqmn6195okq8ubuf4gijtc9w4o
X-HE-Tag: 1781830809-102701
X-HE-Meta: U2FsdGVkX1/YG2nReAtZo9fvV09Z73pWO4MCCGWeD2wOXo+aPIRvTSXN5rJiRnKZeG34tkk7/qQkKw8NPUvCJIJWp56joYOLsLsp+juFbDRjptlw7+GxooRbA0YpYfnI5UJA0cwyzQyIeKEy0AiOxuMRbk4wUxT0T/jbUBhbKv3sy4naoCz3eBLKUSBO6HIPhVLdCKyHFVTyC0YBYyS0/r7iZUUsA7WFfH2P6QfMG3SWYdN9ZF88EurYfE88KssT159Q/bcH5Ois5b9CbCnJVQgAf262U7sc9l+XcsnYXRZB3KlixkQnUMTiRDn4kAY3m3Ro11ImCxh6JPFOHVzve70LXS8AmDIQ4qs6D2rzbYGdH+4hXmCz9p+L1e3yo6cPlLxCYwbo6EATkXQF/uAOfwwFc2YuHAxZN/bqhlSleWl9SKdbOcDVbr0smBgbMJyUh3yrUO9fydsVNKR1lH5zo4JKN1hpWCTjjXYlAlbfAQR2MZJRPJrEOql0Rdrt2H4r1dflvcQgm3vieNa0pDTsvmIpv6lau3aeumymbRCfp74OTwjEOLZbyZVdGgxCbBydj74sH316IlTFYvRi4FZduuqaeFoe39zJ+lWiUIrRteoeQkQ2vDST5tXvgU1UJenRcG7E9fG4l1BDyMjxoC6Fak5HXHNwifasIJWEsQy49fRFvXdmdimoS1gxVe8HVjxaThsD5bAEKMhoOp49a+zaT49oliY7CZn4KosEfT87HlFj6YoZtSB2ots6EkWpzYqn/Jo+ImSOffcDzERsHVT2a/63631NyiECPtztCwKQ4+0/gyiJtzxrHTktybhAax497OteNhzWMnvLmf6Ln+PdFvzATn9sVTyPh6ag60+yxm+ianT09mRo//KdnDkMgaTU8yyUzkr2Hn3eu/ptKnejfnoL7DJH7fHEj7zdMC9dtyNE5tSEIBaagPaPkyG81cK9IE5V1LOCskXVY267cDY
 CkBA3LR3
 6EwZ406WhrBW4Kt9+ljXiMA/ellTSlCIyE6uR5Exj3mRVXczC5wFZDkDIlyQgnisslJd0edrA0NaHxbWrmUtdl4FhefFPbxFDW/vhpmsiUtspxYlC4xYXE1B/I+dzU7MBUTeTWCbkwdR/giMp6+5JXkq4XKCtlTBJ0QWXFnhKFZiQAu+9e/pmVsoTl0cWjRcC0WCcVLc26TZiTWfLjUMzbFVaXc0+JlC1qWpwDv9IqgCT5Em27DTM+NCqrJWNJtTfgooQPkIkJCBCzoOjXZv8fwfu/GaPpNA7v97Tjir4tbHUJyPxWAwoUv/3jYXIQP/Vh8UG7wFJB5We0JjgLXffEr8j9MYCtCPyF9juhCb2NWqcWoY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 7:45=E2=80=AFAM Nico Pache <npache@redhat.com> wrot=
e:
>
> On Thu, Jun 18, 2026 at 4:17=E2=80=AFPM Barry Song (Xiaomi) <baohua@kerne=
l.org> wrote:
> >
> > When swap is disabled or exhausted, swap slot allocation
> > may fail during swapout, causing large folios to be split
> > into small folios. The splitting is reasonable when we
> > truly fail to obtain contiguous swap slots, but it is
> > pointless in the no-space case.
>
> Hi Barry,
>
> Are we sure splitting is pointless?  Since b1f202060afe ("mm: remap
> unused subpages to shared zeropage when splitting isolated thp") a
> split can lead to memory reclaim.
>
> I've been far removed from the reclaim code for quite some time but im
> assuming in this case we can actually reclaim some unused memory which
> might be beneficial if there is memory pressure. However there are
> some discussions on whether we should further guard this zeropage
> remapping behavior [1].

Hi Nico,
nice to hear your feedback.

We already have code to split partially unmapped subpages
to reclaim memory before folio_alloc_swap(folio):

                                /*
                                 * Split partially mapped folios right away=
.
                                 * We can free the unmapped pages without I=
O.
                                 */
                                if
(data_race(!list_empty(&folio->_deferred_list) &&
                                    folio_test_partially_mapped(folio)) &&
                                    split_folio_to_list(folio, folio_list))
                                        goto activate_locked;

But it seems you are suggesting that we could split even
fully mapped folios, possibly to look for zero-filled
subpages within them?

I feel this only makes sense when there is an actual split
requirement. In cases where we are running out of swap or
swap is unavailable, forcing a split seems incorrect. Even in
a normal mTHP case without swapping involved, an mTHP can
still contain zero-filled subpages.

Recently, we did a number of experiments to relocate
zero-filled pages to zero_pfn by forcing SWAPOUT, and then
mapping them back to zero_pfn during swapin via my previous
RFC - mm: map zero-filled pages to zero_pfn while doing
swap-in[1]. However, we found no improvement in reducing
memory usage, as these zero-filled pages are quite volatile
and are quickly overwritten with non-zero data. So I gave
up efforts to detect zero-filled pages and perform
zero_pfn remapping.

In conclusion, I feel it is not useful to detect zero-filled
subpages, since they are quickly replaced by non-zero data.
In our experiments, we triggered forced SWAPOUT every minute
after detecting zero-filled pages, but found no reduction in
memory usage.

[1] https://lore.kernel.org/linux-mm/20241212073711.82300-1-21cnbao@gmail.c=
om/

>
> [1] - https://lore.kernel.org/lkml/20260609114619.144416-1-npache@redhat.=
com/

Best Regards
Barry

