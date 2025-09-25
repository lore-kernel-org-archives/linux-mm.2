Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC467CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 17:26:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D8B98E000D; Thu, 25 Sep 2025 13:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B0328E0001; Thu, 25 Sep 2025 13:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5978E000D; Thu, 25 Sep 2025 13:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4678E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:26:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B3BD786DF3
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:26:54 +0000 (UTC)
X-FDA: 83928452748.30.2787D29
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf29.hostedemail.com (Postfix) with ESMTP id C594A120007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:26:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkT0JyNK;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758821212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hxzv2cBWff/v6c1vesRxyiI+Yy9Izb2fQv+kxW/dGpA=;
	b=4f0dPJcfkVONljBIdIzVYQPqclv6vFapP16RXNzQrqTDRP+ibS/b4Yw8Ee9QCvgbrYjeZ2
	hx1ICsMghIaMs0zu/g8FpOeFNqg3ixM0zs3dRWv6y5xeW2V9EHnRs1b6In0auWGnUGHxLz
	dGedaMzr+JNeUgbyLvpn6u+NqQCuG/M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fkT0JyNK;
	spf=pass (imf29.hostedemail.com: domain of shy828301@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758821212; a=rsa-sha256;
	cv=none;
	b=zEwGddn3o20bhcXBU1RCklCraPI9O1rofCEu2XHBk0FF7zCoa0fyQyqstXU1tbJ0PDPv1p
	ZzjxPi1qDPP+rNNZxIFSPdL6D8wWlFTLusZOdX3uVFnPEfa+B+S4QHIxxxl7daScp/v0nt
	PPw2YOMV6WaDHusagAhYLEldf8DMLjw=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b2d92b52149so246871666b.1
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758821211; x=1759426011; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hxzv2cBWff/v6c1vesRxyiI+Yy9Izb2fQv+kxW/dGpA=;
        b=fkT0JyNK2zA3y9ySFh4dbAqF6ondq4lxmmHXqGan7I8Lb2CgQFtsUP0l+WcNPMe5UN
         /JaegCRLR7oKg/JcM8tWtSq7ue88sl4nesYBd86r5n9JKU0GXlOCt8SB0dFWFY07NrYt
         Hw1P66nqoGLtQdEk9+539qM+pwZgguAdqamgT9PovUk2noTdIVtSxaqe2pV+Y07uDh2g
         BiPQPywHGHBfRamsUi0Lp80nRJbC88gvoBMGvJQGFBcn1RFkjSlVsDgk83jttnbBLoEG
         qbpWGS0Fy8PkKPBHKhMjNctKaOCIhf9GUR39qfVi9vneDAn2sgUb5LDD0qIuoPon+0v6
         47dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758821211; x=1759426011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hxzv2cBWff/v6c1vesRxyiI+Yy9Izb2fQv+kxW/dGpA=;
        b=CgnQS1aAWWZSK1olRWdkibfHybE3l5GqWLDnYVVMUYd5p9m8AjDJ4aXGK7LVMqlnTK
         XHztuqCYHFuLWZ18cTbInEvOexPWpkvBViLFE0bhDNdC5qi3jhQewUZ9pXQzoFgH2JE+
         zbiFl/pw1JWAj9ilHzU3wWrqiv1ISjeKDbf+YFzUxwQgddoxpx255is0uPTOZ9ulSgFo
         xMLlduve0iIq1/BgD17pdZmRMa/m0TUbrEDBdecRWp3L5H/0kHsokRNk9u4S5lcuDfBH
         qYAWoztX4rsWcl+H0qhLY/tRAVF3XfP6RXqKBmJrtJAXZtsYPC+nFji/rilgHZwRE17P
         L53g==
X-Forwarded-Encrypted: i=1; AJvYcCXefTrgRgK/NVR77Oj8ST/5iCUstVKvpdUPrjxXLDUd4wwiwA33JBFm9wcX5L9yEQxSo4ixOr8RHA==@kvack.org
X-Gm-Message-State: AOJu0YzvRdLAJVlhXaDNNYs0EdebVeqxi+uxwl1Ybpaov5rmIvqw+5SJ
	Vqi5lH5kaCCOeKwJZb/Ez+LbN/aEzIG7TSQr7ZnSLgNqIrgt/sledrnuDqqD/j/ZQp9spAiIqZ8
	03xqe/9xnpLInVAY+KIU8yfTgaS4h/WE=
X-Gm-Gg: ASbGncvmTh6AzHEmRmJ/KQTwkyk9lpvFqrYX9z4bzXmluXeVny6D1O3zSgqFzXTqrLi
	WAdBnpWYseotIe5diLdyIFpzxKgmWoUbOMFfsRkozC4lAb+VndBMR/yFHuRVWVTiyQOygo/HF/u
	kym67DQDvgOWti37P87pYmsau0TfDSTt0ZcfnCDsC2dLu13u7O3o/TjP4+lVKX0pCS0Qvrrko5K
	+o=
X-Google-Smtp-Source: AGHT+IEjzLFBbzflK4F+frlRfcbPaspWQC9oQPfqbZdjRXB0LrK0sUdF9qQBxVp9KRq1FroodJ/I2IDpzawl6coBJMs=
X-Received: by 2002:a17:907:2da7:b0:b30:daf3:a5a0 with SMTP id
 a640c23a62f3a-b34bad2253cmr480436066b.42.1758821210852; Thu, 25 Sep 2025
 10:26:50 -0700 (PDT)
MIME-Version: 1.0
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com> <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com> <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com> <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com> <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com> <CAHbLzkrstjnEVUzz2==A2Z+CJToOgU6YU2MasdK49o-0-jW2yw@mail.gmail.com>
 <ec108aa2-88ae-42bb-a64d-ef12867526c4@redhat.com>
In-Reply-To: <ec108aa2-88ae-42bb-a64d-ef12867526c4@redhat.com>
From: Yang Shi <shy828301@gmail.com>
Date: Thu, 25 Sep 2025 10:26:39 -0700
X-Gm-Features: AS18NWA7mmHpaW4unFP9jmKD9f1afbd8FCzR488IcF67iAHmHq3JAN9lKlZCtYo
Message-ID: <CAHbLzkryOopTOJ1gXmQiveZtuDfqSyYTO5WsfvrFcNjiHJV3cw@mail.gmail.com>
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: David Hildenbrand <david@redhat.com>
Cc: Zi Yan <ziy@nvidia.com>, "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	syzbot <syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nao.horiguchi@gmail.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C594A120007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x19bohi9cokk4gszqw6mgni5o5gjomun
X-HE-Tag: 1758821212-563493
X-HE-Meta: U2FsdGVkX1+21ycrEZTIPZXi/enY4+4tBx0Tl/oKUAmCzrP5O3lRasSH51AtVNgGNhgURshWtEj+1gZhSd6aTjamudY25V/YD8MeyNv0VBgFSpeRvOvjYZt5mrZwKpWMjbA1umO9MYavmBS5vq7orydks+jb0l2LhN+f6DhR0oZpH/qHljHZzhI96gjBKcCz1GQIReihAsKsu6+tD3md2r09iBfR9756t5KbTSaQnx5nKc1FKvwJzQt8IGsh6HAyTdVn1jW+VsfpUB7pXK1nFTrO5eiS0o1Es60B/aSiPvmomrytlrnopv8P+g6vOP+t+ppAzVljg/CdVvqdiS6yUdytw/rLz/vvAzgN/CEn789JovWXVwmsenjTPrkPqgTOCLMjKsGapreDCH+dGyETw/sBbLMwvQjAklpJFQVHnHwTaana3uSIVErSE7eKJZE9naZmyG5o8H4lKJi43/CO4ceX+KWUFEPNfEXWpJ5KJMcIufllWPT89Jkk+Zib30jt96FTGqw2CrejNG/5JpvU5FtoOjkOwCHSic7dkc8H0P84wN32kqIm/bVonaH4/a+uu33PXaI8ekSGzbcCwL8Tzo9qQwDbz5LxPxXXPGrMwgIS7WT0BmmiWznRe1DcWCfPjzAanYhHxJXfuxNC3WchInw3aGnssq0w69/rJpjgE95d4Vvh2z4OvsvsmrCsf8GPHuIGlmQNC5sOYb3eRByd3N83/uqbMr0yw8oH98azDNgBgTb6IaBGWHxPdLQEFQ+Pn52+ikNqjJQUjN3RUMlST/8aYWNX12abw2B4g2VYqgrNGTJpTPypYDzDuu3kJL/GtbPzW/pq131Jo1xzK66MTiIjmHdYBzCko2DipKyqQETkU0Kwi3C3dAZVPbk9B1h6S8wFi9nCkNj0ki9p8gLvmreAO8eq4UPaepW9BlJ/GdIdPulgjAuFCU51c3aP46tLzmU+bXzliuOGsZT4SpV
 kpafPoyW
 rOQ3UaGOf54XedsXLDB38zkNgH+S2pyjM34FgqBOyNU0v/luY5+J92+y8U1w/ecIhPe1Y7zd8C9v3s/Pbr+OBqgQqHPmsLpOoH56Y5CEqPWmIO/LrTi+Pv7GPQfIz16jAD9K/tPlq45yi5hws2NELQ+lsUyWVvlVS0J0yykO/TdVB1WIUKMqEZlmIXtEboBxDQhU+Q6hWXivRKy3DefIQ0L5qSPGwWWlj5TKArq/tcjG0aI3y6IgGsVejVl7D3gzJ+q8daVs/Tdl3eChiv6DN54J4V6CRZXt226Qwn0Bv/6QWnM2V4LsgQyPzu3+fU6Z6RqqDTUV5RcVIhCJO4UVRAhe1dYO1tjz7Vkj3YojVBgR0dh2xhPLZJzhMekCmJtDXJMs0JdmyeK9G/Zwm7Rhg4n79A9kD+OX2uBPCjG3QMi8l7tqzlwVJU/JQv6WyLkYtaJcea5PCjF5QYq+jkmukp5qiE/JFtgJWsxDF6uGzbHfSeIL+1SXiQdVoZN02dqGr0WMNioOsiABqU9Q+pW/LHXAjPhE5Wt/nlS06s00qG2ooSVZiTV+W+c4ZmmSCLIJ40QClvWeGwcV24uARXwZs+Qp4stm3K/H47Kn3EorQsxuQe9zpzWr6DBrByEKUf3nyc7zY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 9:48=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 25.09.25 18:23, Yang Shi wrote:
> > On Thu, Sep 25, 2025 at 7:45=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 25 Sep 2025, at 8:02, Pankaj Raghav (Samsung) wrote:
> >>
> >>>>>>
> >>>>>> We might just need (a), since there is no caller of (b) in kernel,=
 except
> >>>>>> split_folio_to_order() is used for testing. There might be future =
uses
> >>>>>> when kernel wants to convert from THP to mTHP, but it seems that w=
e are
> >>>>>> not there yet.
> >>>>>>
> >>>>>
> >>>>> Even better, then maybe selected interfaces could just fail if the =
min-order contradicts with the request to split to a non-larger (order-0) f=
olio.
> >>>>
> >>>> Yep. Let=E2=80=99s hear what Luis and Pankaj will say about this.
> >>>>
> >>>>>
> >>>>>>
> >>>>>>
> >>>>>> +Luis and Pankaj for their opinions on how LBS is going to use spl=
it folio
> >>>>>> to any order.
> >>>>>>
> >>>>>> Hi Luis and Pankaj,
> >>>>>>
> >>>>>> It seems that bumping split folio order from 0 to mapping_min_foli=
o_order()
> >>>>>> instead of simply failing the split folio call gives surprises to =
some
> >>>>>> callers and causes issues like the one reported by this email. I c=
annot think
> >>>>>> of any situation where failing a folio split does not work. If LBS=
 code
> >>>>>> wants to split, it should supply mapping_min_folio_order(), right?=
 Does
> >>>>>> such caller exist?
> >>>>>>
> >>>
> >>> I am not aware of any place in the LBS path where we supply the
> >>> min_order. truncate_inode_partial_folio() calls try_folio_split(), wh=
ich
> >>> takes care of splitting in min_order chunks. So we embedded the
> >>> min_order in the MM functions that performs the split instead of the
> >>> caller passing the min_order. Probably, that is why this problem is
> >>> being exposed now where people are surprised by seeing a large folio
> >>> even though they asked to split folios to order-0.
> >>>
> >>> As you concluded, we will not be breaking anything wrt LBS as we
> >>> just refuse to split if it doesn't match the min_order. The only issu=
e I
> >>> see is we might be exacerbating ENOMEM errors as we are not splitting=
 as
> >>> many folios with this change. But the solution for that is simple, ad=
d
> >>> more RAM to the system ;)
> >>>
> >>> Just for clarity, are we talking about changing the behaviour just th=
e
> >>> try_to_split_thp_page() function or all the split functions in huge_m=
m.h?
> >>
> >> I want to change all the split functions in huge_mm.h and provide
> >> mapping_min_folio_order() to try_folio_split() in truncate_inode_parti=
al_folio().
> >>
> >> Something like below:
> >>
> >> 1. no split function will change the given order;
> >> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_=
order
> >> is smaller than mapping_min_folio_order().
> >>
> >> In this way, for an LBS folio that cannot be split to order 0, split
> >> functions will return -EINVAL to tell caller that the folio cannot
> >> be split. The caller is supposed to handle the split failure.
> >
> > Other than making folio split more reliable, it seems like to me this
> > bug report shows memory failure doesn't handle LBS folio properly. For
> > example, if the block size <=3D order-0 page size (this should be alway=
s
> > true before LBS), memory failure should expect the large folio is
> > split to order-0, then the poisoned order-0 page should be discarded
> > if it is not dirty. The later access to the block will trigger a major
> > fault.
>
> Agreed that larger-folio support would be nice in memory-failure code,
> but I recall some other areas we recently touched that are rather hairy.
> (something around unmap_poisoned_folio()).

I had been busy on some arm64 stuff, I didn't follow up the recent
development too closely, you meant this one?
https://lore.kernel.org/linux-mm/20250627125747.3094074-3-tujinjiang@huawei=
.com/

It seems like we need more work to support large folio for memory failure.

Thanks,
Yang

>
> The BUG at hand is that we changed splitting semantics without taking
> care of the actual users.
>
> --
> Cheers
>
> David / dhildenb
>

