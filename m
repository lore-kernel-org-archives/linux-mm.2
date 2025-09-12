Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51281CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 23:35:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB9098E0006; Fri, 12 Sep 2025 19:35:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68408E0001; Fri, 12 Sep 2025 19:35:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 957498E0006; Fri, 12 Sep 2025 19:35:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 83B788E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 19:35:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EEBB160946
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:35:37 +0000 (UTC)
X-FDA: 83882207514.21.6F4E5DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id C68B940003
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 23:35:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScTQ65BQ;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757720135;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HPCu1pwVM4Drx10GdaCY7ng58mnQe58dpSzFUAkQI+A=;
	b=Lp1VSGwohZMx0QPIxrf/AdN85wMssp/YsYQONDmPMeMUB06XpUD0L3qSCFciT0QRY/AXWv
	vponnR4ntB6WeLoFGccjrZpSgAu/B2tqcpNVw5v8WCs62L46pftF4KtOvbHWF4PdYbJ5AH
	+osaHGbJZkKXwazmP+U/57cTndkhJbw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757720135; a=rsa-sha256;
	cv=none;
	b=PBq6SstINf4bceNhFdB9lhaHVmzi7hR1KVQhNiraq6X6cJ2ZywYHxiSpZMwqXrOaWfEyVB
	43t3KKgCe4CaGo1Pc76+RDsP8tLFR2m6WathfAMWXq93/ApR3vlLblDpRueCAGfLG1oqoF
	qIQwAZJAwfzcbH+PdhlM2WnNkzEJGMw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ScTQ65BQ;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757720134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HPCu1pwVM4Drx10GdaCY7ng58mnQe58dpSzFUAkQI+A=;
	b=ScTQ65BQwwRj/Z5fI8iKcxH2hBZRQ3XNLOAYgWZr7KYBUWk1c+XwBOS57vv+oQ7l8RaDSG
	hxJ9w8njRSGtKzTeEl+pm8VNRK92WIVLwX0CApIn/iX9X2kexB2iYembG5C+ERsBrzyMvX
	4uFh9ZlvxPBbvPG3Z3YDz4LyTQO4gLc=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-gpGQE5urOuKu_CEEHOuLKQ-1; Fri, 12 Sep 2025 19:35:33 -0400
X-MC-Unique: gpGQE5urOuKu_CEEHOuLKQ-1
X-Mimecast-MFC-AGG-ID: gpGQE5urOuKu_CEEHOuLKQ_1757720132
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-7216c46b069so25867627b3.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 16:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757720132; x=1758324932;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HPCu1pwVM4Drx10GdaCY7ng58mnQe58dpSzFUAkQI+A=;
        b=ISK0p2G0EFJ0FA41Ejq19OHPaHPOnwBsXe2Vhfzlu2GgORthYdDAgXawq3vT39F+BD
         gAiqt2JQuP3oS7RaAsOUgBk3zhRK2oH40SXXsFa/Sp1oEhchN7grgLXJeR5P+equWAbR
         +fkCBtH+balMhxag4i4IsZ5ijAtDKqvuFjJLjMbnMMo+zgcwvq26Oemx+m8/o1gxXiA9
         rn8ApG9iWYs6OYrJoCN2cgzQsOY88+g4E5xKI7JZNj2xwIgD9eRPuouZiAo01M5fzJ7R
         3U/tHc2VFJm98N2imRtyiph5kwGX8pNgyVQehHpFqhyFgAqTV7hCi5d2eEUCznOTRFIy
         NCiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZzY0mjaA6Wh2ZOXrugR9R3FswMpbvspEROH9d+Xk4N3jPjIdNyHcx5xGQRV0S56HXgfXyilajjA==@kvack.org
X-Gm-Message-State: AOJu0YwQ6GrIa5kbOkUYZjr9OvmS/SC4LOb/EDtDIDpF+giphJ98nCIK
	Kjo6B9CrRoMVEBuXtPrNxlfiJEbtdPlVoOZ1WKEgWxecB/WoT4LCRJX/JsbNAv5BxQqZCSqmGCS
	RUAhXRCgnPvTSqgAbYGX902cB2LFPYXO6D/DKPM4VEOJXaj5DqZomEUti4oUKoNs8gF2vruRCBm
	LeVbWdMybjAi7AxezGQecfp2tG1R4=
X-Gm-Gg: ASbGncsQ96o9kFQ9PowaghiF7sjO0yrSVihAAJ2ebuhcCkG/cTxUjSdHJ34EEHdjfCZ
	LUp6lWLqaOrFcRDIGG7IzPdtCYL8mGsGl3UwuZCgMytxrxG+N5V8zWffli/ZnnSqWhqPX16qTWB
	3Dn0zmSvU4kKjPD4mr6gN98t5OEYAx3g5xRyw=
X-Received: by 2002:a05:690c:6ac2:b0:729:677e:b7b with SMTP id 00721157ae682-73065fa0c40mr46615157b3.47.1757720132253;
        Fri, 12 Sep 2025 16:35:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFf6FRXt0puU/GkbiNMmkdOBMh3PmcUJa8ItdRIcV21DzC27xRjlQRyXSqK3+grheHlKb8t0P44+F+NVaC7sWY=
X-Received: by 2002:a05:690c:6ac2:b0:729:677e:b7b with SMTP id
 00721157ae682-73065fa0c40mr46614957b3.47.1757720131865; Fri, 12 Sep 2025
 16:35:31 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
In-Reply-To: <43f42d9d-f814-4b54-91a6-3073f7c7cedf@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 12 Sep 2025 17:35:05 -0600
X-Gm-Features: Ac12FXwW-JyuDr21ldb1iQAOW2JaSV_ia9I1rYO-9C_34jUWMMoQfpgn4vajl84
Message-ID: <CAA1CXcAenBm4=V1=-bXmruL85MfyqTXu5_-BmzGfOEaQ4z-Tdg@mail.gmail.com>
Subject: Re: [PATCH v11 00/15] khugepaged: mTHP support
To: David Hildenbrand <david@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, jglisse@google.com, 
	surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com, 
	richard.weiyang@gmail.com, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, jannh@google.com, pfalcato@suse.de
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: b-s-r8LhejN3CRoeoPDYYp2SEh1QCpJnnGUe9fF4zDA_1757720132
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C68B940003
X-Stat-Signature: b8515st1n4ebsgerjzorz5i37g9iq1pn
X-Rspam-User: 
X-HE-Tag: 1757720134-143902
X-HE-Meta: U2FsdGVkX1+fYT1xYiVb10ITKx1PrQtqeuKjRJw7wq5NJsAimHwa+lkVXpFY0ZZoQYBorxpxTSOZDexS6C2FEMZAVEtr7wdz6H0wOT06+CeUJqDJ7NvM0QlQ7Ab4mBvnaqG0DnvVmfUS9oXH3SSLajAsGMzbjavfyuQuFo4k89AuBuVkKdZ7a+evbnieanoHBMOwmJJOvJbMkFC/YdQhi8ReK01vv6RYjm1Tcn1MUibp/J2ViFkkdDElwpWwhuKGU6SD9EPcIfgQ92LWuzPAYQyGSGD+4WpbspIEMLiQ72bKQgPogC+WIqWhkMwaAFkwKPiAJcNVrtmCzBiFsd3dCvnn3wgRjW8GO4bjKhG2mHa11aHTYJ8N7v6YzMBZiPOJv06t8gnfXPp3nzFqg73uH25PvRc83VzRIz1B9W+KR7vra4mIaPxmIR7ieuUpSTRo/YWAefMK0dEj1ep7p68Jhm1UYbXH4Ng3W+d9bSEdAa6loEJHHygLWrprg+oJ8a+TFOtDFQ1nBnx+3QSc6zE4Osc/R3jmyGjDLAGossbj9Yvrx10rYaDKoJlWH0x/Bha9uVvsCViXiIYg6bEC3yXIm5HJtDi0kV88OE/pxqtbYlr0ylbd7cYKYKLbQpWASHwVcSHJuv2EdtKIUf7cgSM0dwnHxiqK1Tbd8EhkipEkkianiW9l0dhI6QNqWxlM/G9/cU0lau6Vx73sC/oZbgxQwVUO7j/QJhkXznZskaXzpVoOhXHQgJL9nruN3gtP5uYZYCaT1JxkwSo8T5ddkZ167EpVKOyLwsTN79zFLtdrOnErqDE1acSqjCKqXO+/DjY95EfRVZZvSCLq19PyUs79bk1jqQo15tGErP7FiKy3S/Q2rjjg9p2kdCwxpiVntkX4SMLx+EVB4liLY5QCZzdME9llGWNFhAiJn9ElC+H4+BIkU9vIy2DpTXBAD7e2cvzvyinFMZ5gPJh2inx9Vlr
 xZ4dj5Uv
 FhUlag8Qk63BN8QlfbU8Uo8NCulJElWgi3mhBdDpUAazn88TUbk4LKfObTFN9yrm0jfHjp65QD+V9lZQx1sOMnXh+iXqaDeILPVsrFc+VCngPCWqjtQD3/alaCFOok7wI6sTRIrJC30btZoeavJQNkMJTrlyhYjVmEfXL8WbgirCV/RdepOLRWSKdIIhpmbhsd6FYoDBoQCFidi3q2+7WtryYcRfY1U096JV3KvTqoCi5nvLerDbJC3vpkr+cMEyYLHE1+2JLEBdYUkqWDsvyYczbE4i1Nu43H/SCBlMp5cCf5se78qaLJLPr7cPI3oQ/kU1yDrzvsOcbk887Y2gpJz0rPB3Dqb3PzWZ/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 7:48=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> > On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >> The following series provides khugepaged with the capability to collap=
se
> >> anonymous memory regions to mTHPs.
> >>
> >> To achieve this we generalize the khugepaged functions to no longer de=
pend
> >> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track indiv=
idual
> >> pages that are occupied (!none/zero). After the PMD scan is done, we d=
o
> >> binary recursion on the bitmap to find the optimal mTHP sizes for the =
PMD
> >> range. The restriction on max_ptes_none is removed during the scan, to=
 make
> >> sure we account for the whole PMD range. When no mTHP size is enabled,=
 the
> >> legacy behavior of khugepaged is maintained. max_ptes_none will be sca=
led
> >> by the attempted collapse order to determine how full a mTHP must be t=
o be
> >> eligible for the collapse to occur. If a mTHP collapse is attempted, b=
ut
> >> contains swapped out, or shared pages, we don't perform the collapse. =
It is
> >> now also possible to collapse to mTHPs without requiring the PMD THP s=
ize
> >> to be enabled.
> >>
> >> When enabling (m)THP sizes, if max_ptes_none >=3D HPAGE_PMD_NR/2 (255 =
on
> >> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - 1 f=
or
> >> mTHP collapses to prevent collapse "creep" behavior. This prevents
> >> constantly promoting mTHPs to the next available size, which would occ=
ur
> >> because a collapse introduces more non-zero pages that would satisfy t=
he
> >> promotion condition on subsequent scans.
> >
> > Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> > all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
>
> BTW, I thought further about this and I agree: if we count zero-filled
> pages towards none_or_zero one we can avoid the "creep" problem.
>
> The scanning-for-zero part is rather nasty, though.
IIRC me and David have discussed this in the past and decided to avoid
this approach at the moment because it would be complicated and
"nasty".
>
> --
> Cheers
>
> David / dhildenb
>


