Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE1F0CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 23:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143948E000C; Tue, 16 Sep 2025 19:09:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F44A8E0001; Tue, 16 Sep 2025 19:09:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24D68E000C; Tue, 16 Sep 2025 19:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E13038E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:09:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88F1F5876C
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:09:41 +0000 (UTC)
X-FDA: 83896657362.18.D04DAC8
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id A265FC000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:09:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bwi1mSSk;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758064179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZoWPSr5f5pxAJKEGF4VF+yUZq/h9CKKdkAf/iFmmuY=;
	b=gHMTCIvYrNNSAn4b2/+aORRBm/PYj9KM3bn+EulJ/AUdBe5RoFXtJBBM4lzA+4ai7dJDLO
	4Ib3Sx4EttRR8fl/67pyPU68W+dSmDkk2ccwH0Nkkmo0AcMVjHnuGHS9Wip4NFql2WKr7b
	Ek/vrAqhxyRCIgWWCJfuqOjQ8rrHLWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758064179; a=rsa-sha256;
	cv=none;
	b=pGgPdw/Z9xIsWf2Q361r2OAN3GcN5hf9PuUYnyukcyUjUEI1sbFjCCKeyn5gy3Uk07H5aU
	zPls+5Xm9ALfgeTVsyBM7LM6ONT+O7Xw67OGtLKAUFKJXZi6/VKni7wOXkJV4HsEFnFL1I
	5arjahaZZWdzxlPHO39nOjSxlyPr2io=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bwi1mSSk;
	spf=pass (imf28.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.221.176 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-54488e51c37so2238486e0c.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758064178; x=1758668978; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZoWPSr5f5pxAJKEGF4VF+yUZq/h9CKKdkAf/iFmmuY=;
        b=Bwi1mSSkBPXobSa+a5GK0EVMY6OWVqQLO+DpleJ+yr+OygTwjeVDPLz3heLNT3MCtL
         WHc9YGWrtzxt7O1eimQWSQmpwN29X0TeWyIff6Ng2nTUTbMiH6aBLZp7dLUh4kbdqBL2
         CUIc86lhIvb7NyvudPYYe9MdVBpmlTHpcYSKGJGOcOA+TYmNKBtzc7Fd7smUi/i8E8VD
         15av5/uy1nRc2wwcl7qSlb7k17mdvnRqD4wWDYF8XNYENFWiLnuoiCO06clvttSiCw98
         zdgRUaVhFLPO2J/65Y/h9gdV3vED6F6wZQPflY7xQuboHpaB+yfyUWUNXFnm0JnC9Sb/
         U4Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758064178; x=1758668978;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZoWPSr5f5pxAJKEGF4VF+yUZq/h9CKKdkAf/iFmmuY=;
        b=G3FtKsIHa3y60OKmf+di8yFLzHvnOXMLX9mUq2dVqEEHW6xMs5HEmAF67Siu4bNGCH
         i5gE/oXUfDxfmgyPv8EBrCEjOXDUvXVFyZQjdzOASF4YfOWN5A3QAAGzSgaWktUGHy+C
         YqNZHZP5MrNmCb7APsNyq2dy2sG4C9Pa1djQTliNzHYlxMtXFbo/w1z2BeIDiEXtpkTl
         OfDTLGjU7iLMp+tB7x5FwLes/WjreoHiummxCwh7PBoq0nzdisSS+0Qw7EwzmBQl/5Kv
         JNr+rE8yt8BC3aqZtfXvKsEdiooKslBbAm3TJjrMWikBNzzmvUJkvyLNf9W0bzlrRNdP
         Cfwg==
X-Forwarded-Encrypted: i=1; AJvYcCUPoJSslJPISVvMGt1UEReY3sJTFmwPyAt8dbdkY9BOuZDxl70xmhEmiy4ezupnN2LjCy5KYLk7Xg==@kvack.org
X-Gm-Message-State: AOJu0YzhEhkJdQ6+lBX/1CB6an460kEQkVED8ZTpL5azTmnfDvvIJ3Z/
	mKrdWaP6+cUCyNEwpzorq1dcpLNaxgP6HH8qijKjba6ix9CuVZKacD0SqbHObKD1Nis4T8vA7kK
	mQ00UJ06k6i6P5cMoanJyxKEoAcywHXA=
X-Gm-Gg: ASbGncs4ZOpaimeT3cjhh1uftH0LbyDS0pXbLrCd47BIf2W5MjXrXAQRY4MlIyXWUYq
	4S60XdQQ7wHLw/UrOFVIynKhvVJznWyjtigQk0cF1aPkitd5P1U42LyV6UvZqav+1UnSCKHt2uO
	AfLyScw9McjDbZ51AJ3IMK32QyM++e9ppzKiqG+aMeuA0N/uxOcyfWTZLlr6y89JE4+VfO2w/fD
	ub6Xuh5q477MgRxPnkSO4q61OOdAfEVsl5BbRtnX7SvhHcuOYJr
X-Google-Smtp-Source: AGHT+IFH4dLKUMqa34fjb7j6T5CwS42y15aQ209a+zQSgeA70wSL2jbR4X0awUWxCCck1q1twgB/TcPSg/vrP+5Dojc=
X-Received: by 2002:a05:6122:16a8:b0:544:754e:a51f with SMTP id
 71dfb90a1353d-54a60b94058mr70697e0c.11.1758064178419; Tue, 16 Sep 2025
 16:09:38 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com> <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
In-Reply-To: <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 07:09:27 +0800
X-Gm-Features: AS18NWBpp6Do-OXSJCLFlf8g1JUBc_W37C6J4z5CgCnsoFNYj4_QvYdIiMAeazc
Message-ID: <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gk56kithmyx6kw8wu5x67c79mi5h9u7i
X-Rspamd-Queue-Id: A265FC000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758064179-637795
X-HE-Meta: U2FsdGVkX19GxvteBE6Hr+I+enJhTyopzN2brzeeD5fzXEtlX0p+ULfQLdbXBFjciv7Dnk8+Ds6mH0EIQrZBoCLf2P0VXy/TCpVvzCBHY6WvZTLiBLZQ0gLAusnBxO3NEzWjbGWta1oIYYQoJ0VzgON8tOMkw6W9dCVn29iQLUU0VIg+3ZlxADSO3BwpqXCLzG3oi6E6zeFyunChyhRWHoaYNjxA+ExdcqAn+CNN46vUYin1/UL+ReS1Nhq0N5xY9BIUIs3IBmyQc1xtAvfOvh3HdNWXGurSvFMR4jUmsZjXaD4AjNthSQhblLAcJOxfEbAzzs6wkfUsQ2rIOT9WW9SNvJKX+EWQ0cP68vqpbL9Nes3QJdXl+AUgciJtA0dif4NKYZrO6dL19GIUT2rn/APlbUEb7Tb7ucUkZjdfGcZfbX7zvnXY9ejyJCN44gJ5K2HNoJnMdHxgk6bj1sb5g5fLqNP5fpxGCGSrzWFOPHY4W9EAhC698YeBoR5aDP5NHMdNM662H0an8Z6Mur1xM7cGfXIQ8QTe6gWkbTSNs+0DL8zCNVoSON2oulyrsyX1tksZ9IeBcX1pvbCJ3hvwyYlQBIsvS72mBRqqXW5gmEJAzEspSoO0EvbpW6f8FWsr9NdpO+KiXzZz+tRGBc04tdLnP79/eit3BqYV6SxEKVH+MHuT03gZFsmrXH/kFcGdJnuCxTVUgokCbmdI7yZ0o27ekucOKEBe+oLmZgObvLLyQLUAjDHZxlRX6tdiLixq6jnYTtjOgAqO+ONP7ZHvpi1j+0sXIn9kVulM6n0IXvSBMDvScvF0gW5DkgFeABItV2wxBxXiwyWI1mZJvoj/5ky6q6sHuJ54io+IiCAQWIDOD6eH1394FfbXjIKR2BeftJGtRIF10WBpLDslBkegrrJqHVlYSfLaBIVktnBLfJtWbdTYlvRWUc+VmCnfj3YRWjMc2wjDKf2OzsBrim4
 +rqbdmLY
 9bp7pQhF5JUmQiXLpFYj48yh5xk/dVti83akeoB7YN/r7346PaRHDL+lZzwtX26uQnv2WrBOzuQSRDkHy/AjOygTRUzErODEBbxzNSdtvJxlw5H/4U6ZK762R1daBIiL/mtt+CaWDSxv+PrZ70MCExNDsyJG1Upd2YGq2alO4O3ZMtQrQDE4Yz1LGzwcCZodmVzvFKMNR8CS9rp6CnT7t3NjhkA60aeQLvmpUwyfdTESTUm9/t101l83v/an5qYPhgL/MEdbYxOonm7A719WjHdrTgl939zvBNsiQftjSS47x/Sn8ZzwCSZS3ujcmfo97dTiXybB/l0UhUBttzwjYe3hGgbiw+pmlsL0m1nTR1JaRX1R1Hzt4l8EDuTnN9W/fI0K4wrnPiwjnsZklfcpIRuG5bI5j+ldZD1+/3Yfgpr00Se1XNzAjfFmqoKcEeDPRB2pTc2JPEMc9YD9A91SVHtldFmL2jwWSsI+JJXcv/zJeuB0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 6:42=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 16, 2025 at 3:00=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Wed, Sep 17, 2025 at 12:01=E2=80=AFAM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > From: Chris Li <chrisl@kernel.org>
> > >
> > > Swap table is the new swap cache.
> > >
> > > Signed-off-by: Chris Li <chrisl@kernel.org>
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  Documentation/mm/index.rst      |  1 +
> > >  Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++=
++
> > >  MAINTAINERS                     |  1 +
> > >  3 files changed, 74 insertions(+)
> > >  create mode 100644 Documentation/mm/swap-table.rst
> > >
> > > diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
> > > index fb45acba16ac..828ad9b019b3 100644
> > > --- a/Documentation/mm/index.rst
> > > +++ b/Documentation/mm/index.rst
> > > @@ -57,6 +57,7 @@ documentation, or deleted if it has served its purp=
ose.
> > >     page_table_check
> > >     remap_file_pages
> > >     split_page_table_lock
> > > +   swap-table
> > >     transhuge
> > >     unevictable-lru
> > >     vmalloced-kernel-stacks
> > > diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-=
table.rst
> > > new file mode 100644
> > > index 000000000000..acae6ceb4f7b
> > > --- /dev/null
> > > +++ b/Documentation/mm/swap-table.rst
> > > @@ -0,0 +1,72 @@
> > > +.. SPDX-License-Identifier: GPL-2.0
> > > +
> > > +:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.c=
om>
> > > +
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +Swap Table
> > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > +
> > > +Swap table implements swap cache as a per-cluster swap cache value a=
rray.
> > > +
> > > +Swap Entry
> > > +----------
> > > +
> > > +A swap entry contains the information required to serve the anonymou=
s page
> > > +fault.
> > > +
> > > +Swap entry is encoded as two parts: swap type and swap offset.
> > > +
> > > +The swap type indicates which swap device to use.
> > > +The swap offset is the offset of the swap file to read the page data=
 from.
> > > +
> > > +Swap Cache
> > > +----------
> > > +
> > > +Swap cache is a map to look up folios using swap entry as the key. T=
he result
> > > +value can have three possible types depending on which stage of this=
 swap entry
> > > +was in.
> > > +
> > > +1. NULL: This swap entry is not used.
> > > +
> > > +2. folio: A folio has been allocated and bound to this swap entry. T=
his is
> > > +   the transient state of swap out or swap in. The folio data can be=
 in
> > > +   the folio or swap file, or both.
> >
> > This doesn=E2=80=99t look quite right.
> >
> > the folio=E2=80=99s data must reside within the folio itself?
>
> For swap out cases that is true. The swap in case you allocate the
> folio first then read data from swap file to folio. There is a window
> swap file that has the data and folio does not.
>
> > The data might also be in a swap file, or not.
>
> The data only in swap file is covered by "data can be in the folio or
> swap file", it is an OR relationship.
>
> I think my previous statement still stands correct considering both
> swap out and swap in. Of course there is always room for improvement
> to make it more clear. But folio always has the data is not true for
> swap in. If you have other ways to improve it, please feel free to
> suggest.

I assume you=E2=80=99re referring to the swapin case where a folio has been
allocated and added to the swap cache, but it=E2=80=99s still being read an=
d
hasn=E2=80=99t been updated yet?

I assume it could be something like:
The data may be in the folio or will be placed there later. It could
also reside in the swap file.

Alternatively, leave it unchanged.

>
>
> > On a 32-bit system, I=E2=80=99m guessing the swap table is 2 KB, which =
is about
> > half of a page?
>
> Yes, true. I consider that but decide to leave it out of the document.
> There are a lot of other implementation details the document does not
> cover, not just this aspect. This document provides a simple
> abstracted view (might not cover all the detail cases). One way to
> address that is add a qualification "on a 64 bit system". What do you
> say? I don't want to talk about the 32 bit system having half of a
> page in this document, I consider that too much detail. The 32 bit
> system is pretty rare nowadays.

I=E2=80=99d prefer that we remove all descriptions about matching PAGE_SIZE=
,
since we would need to double-check every case, like 16 KB or 64 KB pages.

For ARM64 with a 16 KB page size, the last-level index uses 24:14.
For ARM64 with a 64 KB page size, it uses 28:16[1]. For them, 512 entries
are not one PAGE.

[1] https://developer.arm.com/documentation/101811/0104/Translation-granule

Thanks
Barry

