Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF344CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 16:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2519B8E000D; Thu, 25 Sep 2025 12:23:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2290A8E0001; Thu, 25 Sep 2025 12:23:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118608E000D; Thu, 25 Sep 2025 12:23:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EE6CC8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 12:23:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C15EB58ED3
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:23:21 +0000 (UTC)
X-FDA: 83928292602.12.0DCA93F
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7696C40017
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 16:23:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=liIKkcX5;
	spf=pass (imf04.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758817398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sVLfD6QI3aBalttz5ofGckCWcaUeaFqR+l9M9pjcrz8=;
	b=67hJF6cJhAZj+psq4QQTsiNUQJixPkC+S6Dw3YfP86PosMN/QAk3t2qhQwqpbJSm//GQbr
	SUayXv5Vf0Lk/YeOJOzl9w7iCrwCbiW8IUB1Et3JWH+fffA8a/Lfv2NfPFE7Ha6hHExqN3
	SejhXky9vp+H3uCwpLMp1VoBk11Rxtc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758817398; a=rsa-sha256;
	cv=none;
	b=L2Z1OlBmacJ2A9bia4lOIs9T3yw1sVuPC1kFkzOzL8MhBJcXfM581h7HiBBriNZJMsRFJ7
	YNWls0tCWG5eXiQ1joTE3f1GaigOtxW43ZfoFxzC2ByOxIAfCcxt+RSUYwuHqIRj2laz8h
	2KGGiR4/UC283JAYVTaHBqzMXNJaWHA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=liIKkcX5;
	spf=pass (imf04.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62fa8d732daso2215041a12.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758817397; x=1759422197; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sVLfD6QI3aBalttz5ofGckCWcaUeaFqR+l9M9pjcrz8=;
        b=liIKkcX5OSeKfKdWAaU346tv9Bjshx4vrPjXJCcE6/09x8KwBLTEoxtzYIViBaFVLF
         2y8zd4qWZ4xnWUjE0X1FJ2xvzR0UktM6xEKcPRh4IZZrGBKXTmqWOVCySyATCnLrKyBk
         n2/gZwcOoKMgWmKFIwVW75RLG6mzIV27BscmMOloSkA0k0gt7FcmKW4aD/YJVqsLlYbM
         Xk+YZB8pE0FJHvcrBgETbyNGNggkrgw97UkZ/r3tVCHajMqnwKcZlcmf0HwinYC3U0R7
         OFqbA/Xd9I+HUV6Zg0E0gNG5aM2drDEqcBkUWQfPs4yv3HrjkFk1NkYuZUGkNVA77LjH
         CxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758817397; x=1759422197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sVLfD6QI3aBalttz5ofGckCWcaUeaFqR+l9M9pjcrz8=;
        b=FgPUK1udInh9KK+QsmYSWndFpAplZpAxxOZX8mS1NCv+5o8OYTZ1PrQI1o4J4nlTWW
         hlYmvVFBv2oKVzZa1knmXU2nL3gr2+Io9KfBeEshCb41we6QjQUtPwC2v6mX/qsDNcrY
         s+Xn+r7HikrGVm8DXGK0yRp+JQKRdFIyjcQXmFuhthQDAdzrAGlC6R5twmXfeM6ZuTkX
         WDhLptJm5JjFgflbwuUltM0Egy0bUL1f6yYf8KmLZafGdMhWbZIf3I/N0Z74ZNy8oXLM
         0yfMyioVnU4D/OwRyfjcOshesBpXROSDhHfe5JXa24pdY7lls23SO3Nq+rxRjCpVELk+
         Lm5A==
X-Forwarded-Encrypted: i=1; AJvYcCWpnudW7bA1Du6oNhYDh5PCvLhk0rr7KrSaSRr4mXbpBAC/QWne+Chpj5MjlrmB9n5kS+pc3Op77Q==@kvack.org
X-Gm-Message-State: AOJu0YzzTdRgVpl4+KNbyA/acV8/xvLWUqp3hnerjA5FPzn7xJMi/zx/
	wQEnI5/og6o62NC/6JjXt3/nQ3m7giv7MVsRuytVLXbOdDTIloH7QruPjp1vuwc79Jv46Ud1OFH
	WYEnPCfPMdhbTkiDvZZj0Pa4JyJAZEj8=
X-Gm-Gg: ASbGnctgtXUjCCvlJfE9KuesEIzzdckQR8wO3onq5PQIwWMqWeVhT5gnt3JLyciEPDx
	jC0QJVuOHPBxsgsLfoS9/n0G1Dp6MVmCOxSRjyH07LLMRiqr45Nmk4kJqAHDvjR26UjpafTjx6Z
	lnJhquN1v87t7CKhMp1HSS17JykShgSHgmjsxDkelrYC+q3sDHDd56VE/tkU9lByBVNL0mFtbSb
	/UwzkJyk/zqhA==
X-Google-Smtp-Source: AGHT+IHrLfqKU+fL92X7D5u431cMJZPJyrtVkhiVpqdBaM41xpe5f3nevQqNwe3zgdGq42HMPJgytQhdodbZUNRWfwg=
X-Received: by 2002:a17:907:961f:b0:b04:c7c5:499d with SMTP id
 a640c23a62f3a-b34be7cef09mr433129366b.47.1758817396702; Thu, 25 Sep 2025
 09:23:16 -0700 (PDT)
MIME-Version: 1.0
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com> <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com> <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com> <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com> <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
In-Reply-To: <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 25 Sep 2025 09:23:05 -0700
X-Gm-Features: AS18NWDY4BleLREPHkOm-WtFq5BXfe1lid1VqVLM4gXE_Ot-5sNbySege7rDVV0
Message-ID: <CAHbLzkrstjnEVUzz2==A2Z+CJToOgU6YU2MasdK49o-0-jW2yw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: Zi Yan <ziy@nvidia.com>
Cc: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, David Hildenbrand <david@redhat.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7696C40017
X-Stat-Signature: 7hwkbebg36n1ka9hbwwjtu6ddus4kfx9
X-Rspam-User: 
X-HE-Tag: 1758817398-170321
X-HE-Meta: U2FsdGVkX1/0OzOVESguq0VJVvYTNTNjSAzSz2jBt/vrrCZO9JqVat31YA84Nn2Q0KhGD1JsKtwxIa1DgOt5GsgjW/UppMUjYRsglDlmEnUd4GNkNXYZ/ly9KG7NFvBftdC8uc05SVm0gqQc0i+zwS82AwtcgUYrStRht7r0nteiCYokONnv6Nym17igVUZve75nHzsmiHCj6ftr7BuM2+omRiMEGD+CawlX2gXLZPDi2sqdu5a95/u+OME0/WAbB5WPbCMZJcG236AAHsanqkWrq/o7E8QJrzGfpfvJP8+JEjuX59rKcNa0OA0sLtcFstKSuYAO0wqwWxNbNiN0P4h/TYV7MG9+F0h43zbo0CR9aKu/X3XjI2vvVEvtqiBYR0QtxP+F+B5UQx2SZEoMolW2s9kNVLXelafIvjgbDlxqHb0OVqnzT1A1S0Zo0nii6XgdfQTmEeCVTx7cp8rCC4jVBRmlaiFCNy/OP/eAa+m81A07bXj7QyVLhGalaujZ5sICk0OY4UX9lo3cDK+IwmWsbxLt2bjZAyXDgNXG/zyKJh61/kjzBbRxZ/ForOR4yjPgH9M7SeLK8xLSUAIiwejrwPWFq1r25B7nA0ZMkuy0Wzfoq7TyzlHhibr9gPOW111GgO38483w6SHBoOgcsMxg0oyVp/KEJ3Qwnk078oBMCR1gITN8LhJgvXIlTCd1FNMco7I0cyanOJUV4S4JiaUGCJriY8jVcLM+7h4NTcnGv21CcvwbDkE396DhsmjPVtQB/zg5xlswW2MdkEVnbZeUhcHpUWZgHxHfwbPHN3+LRCAlanpIME61f8tvcVwtsfHXvXoHtaDHOHo8lLOQtZlrSAa8ZjZOR/WjpjBJgbAXgLr2PahtADceY3VuTIlx71IGrSs5pSi2f6dfSKlyaXw/0FkAYIgUiVYkSJrb6YV32Ogy7FXHhkE9WBs/2aPb0hN57n/9tVhMn82Ofai
 ziJVm6ue
 uuhOjc0cEpcym90qPVthHZVhnMUGufR/cQNxWBe7ZSyFRbcotB+ChfSYYggQPsvQapjFdbn//LA0NRSmRJH9jTwdLgBafQjZZhaJzuNleL3E18buOINiLsmdQ+U1gKnpdseAPuH10lqHpVLXAMjnhwA2yhTOjflDmFOZxvtseu2Qd97EwAmzME3RgpOBPuVLGC3hg0qfg8LLqICmtDZYhS7P+KVaoCAoFZK0276ggDmuW5ybBDDIIg9keYiWwPpLWC4T38CU4XguK5oPqWRVIUwWP4TzpjeGbdXVRD4od4KiRiWxraIEz6lKQFPdv1Rv10Io8rlN126C2ydTrFUE+hY0Z9unGvvC0+lREq9KNJiVFHC140gsERp2Sdnfctdst9gSrgwUSinkJTD2UNWrvzlznsducblcxK6qYyXMhWPvCZQQiSo8oBqIsUzi1i/PEqq9LSZFGr90sJnLwDmPQZm9Ovw41N84vJMZqzoHOKDyfsiNbpfQR8HJ+v0uVRnte9FRHr/fO/VIe3Ai5HQie8SCjxDY2NLG+IWrK094bo6saNwjLm5vLKte1Aw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 7:45=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 25 Sep 2025, at 8:02, Pankaj Raghav (Samsung) wrote:
>
> >>>>
> >>>> We might just need (a), since there is no caller of (b) in kernel, e=
xcept
> >>>> split_folio_to_order() is used for testing. There might be future us=
es
> >>>> when kernel wants to convert from THP to mTHP, but it seems that we =
are
> >>>> not there yet.
> >>>>
> >>>
> >>> Even better, then maybe selected interfaces could just fail if the mi=
n-order contradicts with the request to split to a non-larger (order-0) fol=
io.
> >>
> >> Yep. Let=E2=80=99s hear what Luis and Pankaj will say about this.
> >>
> >>>
> >>>>
> >>>>
> >>>> +Luis and Pankaj for their opinions on how LBS is going to use split=
 folio
> >>>> to any order.
> >>>>
> >>>> Hi Luis and Pankaj,
> >>>>
> >>>> It seems that bumping split folio order from 0 to mapping_min_folio_=
order()
> >>>> instead of simply failing the split folio call gives surprises to so=
me
> >>>> callers and causes issues like the one reported by this email. I can=
not think
> >>>> of any situation where failing a folio split does not work. If LBS c=
ode
> >>>> wants to split, it should supply mapping_min_folio_order(), right? D=
oes
> >>>> such caller exist?
> >>>>
> >
> > I am not aware of any place in the LBS path where we supply the
> > min_order. truncate_inode_partial_folio() calls try_folio_split(), whic=
h
> > takes care of splitting in min_order chunks. So we embedded the
> > min_order in the MM functions that performs the split instead of the
> > caller passing the min_order. Probably, that is why this problem is
> > being exposed now where people are surprised by seeing a large folio
> > even though they asked to split folios to order-0.
> >
> > As you concluded, we will not be breaking anything wrt LBS as we
> > just refuse to split if it doesn't match the min_order. The only issue =
I
> > see is we might be exacerbating ENOMEM errors as we are not splitting a=
s
> > many folios with this change. But the solution for that is simple, add
> > more RAM to the system ;)
> >
> > Just for clarity, are we talking about changing the behaviour just the
> > try_to_split_thp_page() function or all the split functions in huge_mm.=
h?
>
> I want to change all the split functions in huge_mm.h and provide
> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_=
folio().
>
> Something like below:
>
> 1. no split function will change the given order;
> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_ord=
er
> is smaller than mapping_min_folio_order().
>
> In this way, for an LBS folio that cannot be split to order 0, split
> functions will return -EINVAL to tell caller that the folio cannot
> be split. The caller is supposed to handle the split failure.

Other than making folio split more reliable, it seems like to me this
bug report shows memory failure doesn't handle LBS folio properly. For
example, if the block size <=3D order-0 page size (this should be always
true before LBS), memory failure should expect the large folio is
split to order-0, then the poisoned order-0 page should be discarded
if it is not dirty. The later access to the block will trigger a major
fault.
But with LBS, the block size may be greater than order-0 page size, so
the large folio is actually backed by one single block, so memory
failure should discard the whole large folio instead of one order-0
page in the large folio. IOW, memory failure should expect to see
large folio.

Thanks,
Yang

>
> WDYT?
>
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index f327d62fc985..e15c3ca07e33 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -387,34 +387,16 @@ int folio_split(struct folio *folio, unsigned int n=
ew_order, struct page *page,
>   * Return: 0: split is successful, otherwise split failed.
>   */
>  static inline int try_folio_split(struct folio *folio, struct page *page=
,
> -               struct list_head *list)
> +               struct list_head *list, unsigned int order)
>  {
> -       int ret =3D min_order_for_split(folio);
> -
> -       if (ret < 0)
> -               return ret;
> -
> -       if (!non_uniform_split_supported(folio, 0, false))
> +       if (!non_uniform_split_supported(folio, order, false))
>                 return split_huge_page_to_list_to_order(&folio->page, lis=
t,
> -                               ret);
> -       return folio_split(folio, ret, page, list);
> +                               order);
> +       return folio_split(folio, order, page, list);
>  }
>  static inline int split_huge_page(struct page *page)
>  {
> -       struct folio *folio =3D page_folio(page);
> -       int ret =3D min_order_for_split(folio);
> -
> -       if (ret < 0)
> -               return ret;
> -
> -       /*
> -        * split_huge_page() locks the page before splitting and
> -        * expects the same page that has been split to be locked when
> -        * returned. split_folio(page_folio(page)) cannot be used here
> -        * because it converts the page to folio and passes the head
> -        * page to be split.
> -        */
> -       return split_huge_page_to_list_to_order(page, NULL, ret);
> +       return split_huge_page_to_list_to_order(page, NULL, 0);
>  }
>  void deferred_split_folio(struct folio *folio, bool partially_mapped);
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 5acca24bbabb..faf5da459a4c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3653,8 +3653,6 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>
>                 min_order =3D mapping_min_folio_order(folio->mapping);
>                 if (new_order < min_order) {
> -                       VM_WARN_ONCE(1, "Cannot split mapped folio below =
min-order: %u",
> -                                    min_order);
>                         ret =3D -EINVAL;
>                         goto out;
>                 }
> @@ -3986,11 +3984,6 @@ int min_order_for_split(struct folio *folio)
>
>  int split_folio_to_list(struct folio *folio, struct list_head *list)
>  {
> -       int ret =3D min_order_for_split(folio);
> -
> -       if (ret < 0)
> -               return ret;
> -
>         return split_huge_page_to_list_to_order(&folio->page, list, ret);
>  }
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index 91eb92a5ce4f..1c15149ae8e9 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -194,6 +194,7 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
>         size_t size =3D folio_size(folio);
>         unsigned int offset, length;
>         struct page *split_at, *split_at2;
> +       unsigned int min_order;
>
>         if (pos < start)
>                 offset =3D start - pos;
> @@ -223,8 +224,9 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
>         if (!folio_test_large(folio))
>                 return true;
>
> +       min_order =3D mapping_min_folio_order(folio->mapping);
>         split_at =3D folio_page(folio, PAGE_ALIGN_DOWN(offset) / PAGE_SIZ=
E);
> -       if (!try_folio_split(folio, split_at, NULL)) {
> +       if (!try_folio_split(folio, split_at, NULL, min_order)) {
>                 /*
>                  * try to split at offset + length to make sure folios wi=
thin
>                  * the range can be dropped, especially to avoid memory w=
aste
> @@ -254,7 +256,7 @@ bool truncate_inode_partial_folio(struct folio *folio=
, loff_t start, loff_t end)
>                  */
>                 if (folio_test_large(folio2) &&
>                     folio2->mapping =3D=3D folio->mapping)
> -                       try_folio_split(folio2, split_at2, NULL);
> +                       try_folio_split(folio2, split_at2, NULL, min_orde=
r);
>
>                 folio_unlock(folio2);
>  out:
>
>
> Best Regards,
> Yan, Zi
>

