Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0A73CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 23:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCF818E0006; Tue, 16 Sep 2025 19:48:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7F9D8E0001; Tue, 16 Sep 2025 19:48:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C478E8E0006; Tue, 16 Sep 2025 19:48:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB3358E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 19:48:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41035140381
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:48:12 +0000 (UTC)
X-FDA: 83896754424.06.F89E22B
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 67989C0006
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:48:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hma9pPuc;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758066490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AX2Uhe2shIBkYU8CsbbK5nYq6dNzTDggl7Aa2/+nUuQ=;
	b=ExOQtuQ2Vy+MXT89fJy1dSkheQXYr1AucQe+2qXDYWnP6EAdStTjhMs4rPO58doAf4a6G1
	lh+JaBYRMzIC0RVqwTWHp7wSbracKo2JeszuzR16ATwM7nK0f/eyfCxewF1cAzm4+Iy+5d
	11c7bAcXHCcapBykUv91EGg3d7Cz1AQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hma9pPuc;
	spf=pass (imf22.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758066490; a=rsa-sha256;
	cv=none;
	b=GDivjt61wNA4oOyzkBycazxd5edpZTZPayblTJOs8WDhASMY3KaJ6jkG39oXdImJ8EtrlW
	hBAh2xzNTuPzSS+itFNepxX089S0Qus0lpViO9FmJItC8pfdR0n/INWnzcBBgNx/+wgeh/
	uP9OH6nXjRl+w1mqM8WOPaCt0rjwdJo=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-8df145abb2eso429893241.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758066489; x=1758671289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AX2Uhe2shIBkYU8CsbbK5nYq6dNzTDggl7Aa2/+nUuQ=;
        b=hma9pPucbsrCQ6s38JjYmPvJq7cWwx657lH7R1z6raiRhLMxUkMZ2FEYkibbSr3dnZ
         1m4uq+IcDMjrf0XxZkucS3oDl5SBzkx9F+k38PBWvFxpRm8XmRDcqBITS+yBcAURK7ik
         LRhnV8N1I0jxakSN1yVL72qHtpOYDZDlRAnTqCAiRQV7HD8qFW5swTai9C8/ixhBvP+8
         88UKcYCvdM8gMRxaH75lYWOJ09kGwhEAmt/bBhTkS/OxMGmTjpt6yfgow5AwCs6+MkHz
         DVYMdkkUxhaJ09noiAXEK2O/Yf1S6TVvwK/vRaNILZLdICAJbBtqXd9AjyMUWiXcAgjv
         N8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758066489; x=1758671289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AX2Uhe2shIBkYU8CsbbK5nYq6dNzTDggl7Aa2/+nUuQ=;
        b=tuOXTkH5lFkDxfCbZBYEF7TOZQIH7/7jz5aa76IEqmXoJMrb4VdsBY/WNl/bHbw5H0
         hNN6yjFkRIpeatRF39DLeqmnYvWcbN8jpGcmYb+pV7qhCA+hDerT+WUP8s7b52jLutdO
         w6rA9VkEV1V8g84BBUxG68nklxqlKZdg456YP63orIRJEtyeaf1e93XH/2NoB+no7EOC
         iHQW50EFbalYycCm6RUl3Mt/lx0bCtr6sZCeal/hcxTyHKAXloFAJbWAZQK/If1w80rT
         J3/5nAUvgTJTxTou2fO3XtJZt4QHO6O+1cgw9xcR4RYzAGlf5viiAIWJrUD0kxwp9wfP
         fDmw==
X-Forwarded-Encrypted: i=1; AJvYcCWO/zcj2JsTnlaW4iwzTkwwJSxuY5ZSUBR4KJTsp2XJcZBIvyDcbWLeGSofZapXzWh30fdnjqlyRQ==@kvack.org
X-Gm-Message-State: AOJu0YxOA50Ca1M1sAeYZS5pWSgb4Op/eFt7PdjcPbxPgP0HASqYNSRr
	PqOzDZMrIA7HzdLNJFmFPFOgDqOcH5IRF9A63pZ+DoimzNRHgKQ2Ets7drKotr3uc64jZleT29K
	6Fv4JEb7U6gsh7R/7MJ/OZv19KOEpnp0=
X-Gm-Gg: ASbGncsM0X4YneWoL646TU1UkdCsi6Mr6+Zyha2X/Z+AYLpzo3QsjDtjtiz2qJyL2el
	KnCZuvTD4FR6cXY5t4ouzANNKrJXR4tp7hVp9aLfILcZaaBHyXZOFGnmWbCAiVe4AoXdAPFPMac
	JGPh7JAw+Z/bFSaHb1GWkVixduJOBIeF/ZaQ1TQwdEKv6cIaFuxzoiCE002+7jsz66Wf7cCc3dS
	VjDUqA2w8dTbM31T6O52I8kXBiuJK03BTwGQ1z3Qw==
X-Google-Smtp-Source: AGHT+IE+A5eH4A9XbrcV6L3/iogkJLV7v3HZJWYSYnyfskZz0vpYrpSeiq5AxvLwi2VwAg9k/O0XILXcjesfeyLPwWU=
X-Received: by 2002:a05:6102:5345:b0:4e2:a235:24d1 with SMTP id
 ada2fe7eead31-56d77a41f0cmr59406137.4.1758066489375; Tue, 16 Sep 2025
 16:48:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com> <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
In-Reply-To: <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 17 Sep 2025 07:47:57 +0800
X-Gm-Features: AS18NWDx8V6TSFDsmNKOJekO1Fe4wrTlWrhxUHp7P6KzNek6fCA9KPdH7ss8W_I
Message-ID: <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
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
X-Rspamd-Queue-Id: 67989C0006
X-Rspamd-Server: rspam05
X-Stat-Signature: ytdoz5c51gmiig3a683r3hazgegtk6zk
X-Rspam-User: 
X-HE-Tag: 1758066490-430730
X-HE-Meta: U2FsdGVkX1+30Hi0BwsFyYPL725RcLR1w0RnsLeeROlkgU0Sa6d0cWEqh71M4jCfMGJh+DaYJSO/E1Y5B06ku8/cDKrQb42P4K+HxZBB3zLG0dHtz9pw6mYcBFhmNzRPRG77VoWS1C3EDT8wTk4iXvMNvmQ0EWmi5sRNgRO5KGxNBSlY3sW+UbYZkxFeS51dG9X4ppIcZ9eDgGbP5OtRdGdrRxjN7emnvS0QL4ms1UHrEgqkPMRLY7FmTCAOj899n/F8EG6KjJCPwRnvTtRM9mj76Mv5VqyGI0zKnOADppxZRyNqrlzMZ2z/ZMtv5l0NdF0Xwkt80p0RZfImV3igM7rEYyY4Rkg7pFL9kHG5+oAk8Ju5KqtNQYr90GuhfPj1A42g1BvHPKIpltAwEB+j/jKTb9PQKP6O2y1L93uBlyHrkKWiTDIvsvoNqxBtjddSGmI+neLtS3fDbRAKbGR4darJqBePNmiz7CRSgNiv3xLqy0+tlu59G3NtGoL8SFiTyrjooZiF2P+Zb1aJKiMofbAnCY3iCNwxxvRUxLWyGEJgDsyeugrmtVz7+PFUyrmwd0RcFSIlLPypRRPw3lEC3sA5im0VpezRf5BJdgbMWh7/bDRiFAGoHRiKAmojKlmVend07CEyYNh58kDHK91JA+xYUaUVDb4yReLoFhhEf5pwc60N2O6uS2i7z4E1MXFuN75ppf9Ko2x7HtyLNz0GYJ4gnNJRfNwS2hUr1aJodMlKCxlEr1q2X0HAzxHdlA5SFSnu4iXAtf+5bJTQtmdhbRMrDmmiV7B/azGICGf6UZs7ILNs1Ygdi4hiBOAQw+Nfq78w2TII5Wigmn/cD5HYXVE0Sl+8Q7Au3kZg6Oomif2VYs6YOouwNMrZ5HhSKTbp80R5JeIf3wJqwsMoXyVo8a/pKLXLk4y1fWd6v4EnukuwZLby0H7a3JZNdUE6HrWgtnqFrR03qkpQvI0820N
 ikB2jrPq
 BkzWg5dcaCCPtjKYi0BbEhTrQNmmtbV2rq3uKXS6B52EHaniHFqM7Xb+L5Xe1RzpZzc+BacR9skg7WndfZiJnynSiVJJ3IJW9XqqFnyZ/NYPRisH2xJxRi4twqgmaz6Y4ZblopVEzcD9UOKp+9aGUiY/WRO+l8CRVJfwp6FwkcdU8mu9fUcokDO8UZ5V5mJcek+nJC7gu8ksvlvII/92w7kkOZrlT169KmVKptB/rHgaYcmVvml3bIHcwwDHoHfaPr2AhumkTAPm7vumDc009o/4l+QdHPFXGltTcMz1UwOxSUjkkP0XPfzdchfFXvVQcNCEBJx+ZHJ7gJy0wcs6Tvz/wh5okWwQK8jtdLq0QraPyue7hsjir7g5Kog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 7:29=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote:
>
> On Tue, Sep 16, 2025 at 4:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> > > I think my previous statement still stands correct considering both
> > > swap out and swap in. Of course there is always room for improvement
> > > to make it more clear. But folio always has the data is not true for
> > > swap in. If you have other ways to improve it, please feel free to
> > > suggest.
> >
> > I assume you=E2=80=99re referring to the swapin case where a folio has =
been
> > allocated and added to the swap cache, but it=E2=80=99s still being rea=
d and
> > hasn=E2=80=99t been updated yet?
>
> Right. That is the case swapfile has the data and folio does not.
>
> >
> > I assume it could be something like:
> > The data may be in the folio or will be placed there later. It could
> This is for swap in only, does not describe the swap out case.
>
> > also reside in the swap file.
>
> Right and it did not have the same coverage about data that can be
> both in the folio and swapfile. Sorry about the pedantic. If we want
> to improve it, we might want to cover the same level of detail.
>
> > Alternatively, leave it unchanged.
> I think considering the swap out and swap in case, the original is
> fine. The reader will need to make some effort to map to what it does
> in the code, at least the description is correct.

Ok.

>
> >
> > >
> > >
> > > > On a 32-bit system, I=E2=80=99m guessing the swap table is 2 KB, wh=
ich is about
> > > > half of a page?
> > >
> > > Yes, true. I consider that but decide to leave it out of the document=
.
> > > There are a lot of other implementation details the document does not
> > > cover, not just this aspect. This document provides a simple
> > > abstracted view (might not cover all the detail cases). One way to
> > > address that is add a qualification "on a 64 bit system". What do you
> > > say? I don't want to talk about the 32 bit system having half of a
> > > page in this document, I consider that too much detail. The 32 bit
> > > system is pretty rare nowadays.
> >
> > I=E2=80=99d prefer that we remove all descriptions about matching PAGE_=
SIZE,
>
> I am fine with that as well.
>
> > since we would need to double-check every case, like 16 KB or 64 KB pag=
es.
>
> The cluster size is determined by the last to second level page table
> page size. I fail to see why 16KB matters here for the cluster. Are
> you saying in the 16KB page size case, the custer size is 512/4 =3D 128
> swap entry per cluster?
>
> > For ARM64 with a 16 KB page size, the last-level index uses 24:14.
> > For ARM64 with a 64 KB page size, it uses 28:16[1]. For them, 512 entri=
es
> > are not one PAGE.
>
> Now you got me curioused.
>
> In your above two examples, what is the respected swap cluster swap entry=
 size?
> In other words, how much entry does one swap cluster hold?
>
> Sorry I am not very familiar with the ARM page tables.

Oh, my mistake=E2=80=94I recalculated:

For a 16 KB page size, SWAPCLUSTER_SIZE will be 2^11 =3D 2048, so the swap
table is 2048 * 8 =3D 16 KB.
For a 64 KB page size, SWAPCLUSTER_SIZE will be 2^13 =3D 8192, so the swap
table is 8192 * 8 =3D 64 KB.

This approach still seems to work, so the 32-bit system appears to be
the only exception. However, I=E2=80=99m not entirely sure that your descri=
ption
of =E2=80=9Cthe second last level=E2=80=9D is correct. I believe it refers =
to the PTE,
which corresponds to the last level, not the second-to-last.
In other words, how do you define the second-to-last level page table?

Thanks
Barry

