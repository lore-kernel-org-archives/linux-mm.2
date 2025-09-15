Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2732CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 11:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6D48E0014; Mon, 15 Sep 2025 07:42:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 267638E0001; Mon, 15 Sep 2025 07:42:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 156538E0014; Mon, 15 Sep 2025 07:42:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F206D8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 07:42:06 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5F5F13B51D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:42:06 +0000 (UTC)
X-FDA: 83891295852.19.E381D5D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 18B52C0004
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:42:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHL9B3GO;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757936524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jetKzgnC0kf/tMxkplSpD2U5KJC1XxnyLmVwB6VPHc8=;
	b=77WPxKtvZwAXyduIbA0yZM3/p4BNiwPtuCossHlbxE5kzMCEzHxHpPKvVSfX7N7XOGTddL
	2xpLi99DT7qMayyFi7YIXLUTJ1g9R08ebw9izPa9C1mkKtE0OoU63TFuFRklmiBZUCpH/Z
	pDMIUyvy5uS7bPGLSoInVLoRwy/ab9s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hHL9B3GO;
	spf=pass (imf28.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757936524; a=rsa-sha256;
	cv=none;
	b=KrWi6HQ09M7Q+kmi7z+9ezR8es8F/PKquQ0eZHPOxiQPS+k3EuaptR5aLi0KDeiyKydmG/
	NOixhIjts5xVwhrjAwGo/z62kzEJFB36s8DUx3ufuzdvzgnB7sLCQp/oD4W2VWoSSOrmKF
	XDZP9/8WbXVnzUoOQhGhQiIB817xZGw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757936523;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jetKzgnC0kf/tMxkplSpD2U5KJC1XxnyLmVwB6VPHc8=;
	b=hHL9B3GO9FmQQ7TCIQsu0i2Iy2kDNb+2fLdNrDKvrJiEviuzhljRGoaDCe0tleS1NkyRhX
	CGeoLm00WpA2G1yNYyy1ybmCApMXjaIk131HDC3LptwLIOKk3hhrzEROq9CPMqGj6XKIBt
	qX+Ymm3BLChQW0NN7C0kDi8VWqwD/Rg=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-646-JgiDYHFdPxC4hTqfe8oYmA-1; Mon, 15 Sep 2025 07:42:01 -0400
X-MC-Unique: JgiDYHFdPxC4hTqfe8oYmA-1
X-Mimecast-MFC-AGG-ID: JgiDYHFdPxC4hTqfe8oYmA_1757936520
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-62cc6f82436so795990d50.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 04:42:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757936520; x=1758541320;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jetKzgnC0kf/tMxkplSpD2U5KJC1XxnyLmVwB6VPHc8=;
        b=mRY22FSuymVAjA5RG9ycKQomF4nhnjb2CszZRSvdhdT4nqoQb/BhbIAVMoJqrHarfJ
         IKZvXibPsOI5aDDRFz6LPwnlN5PAR1AYVYUnGRDwSJsp2J0nJj/Me0l7HK4oa9q2Jrs/
         WAspK6GS458OhHt9RoGre4fQ9fgT1H+h2N4VYnygB1dBu9i2iUZkYN447P2uRDjtFhz2
         9Obtdmq0TZ5pPughPRlJtmfsZfHnIfivu/5s3/312MrQeniXgnObGtF8W8s/ZojVI5ND
         WvAMqUgwrWiJUy81ls85Wur5RX5P/jF0iSlyTlpc2+lvG4WGIsMWXbOb+kceBF5dn9vS
         ua1A==
X-Forwarded-Encrypted: i=1; AJvYcCWmjRBMbRc0NcHM9oUyOwi2RO/pClKU7e5pzyw7lp6cu9srLwi/n0qc7HD+DWPar7fWqiR//vnDlg==@kvack.org
X-Gm-Message-State: AOJu0YyYAqntZDV69VHQZkb9Kp8NpA/S541wHplaJ7QWzZ/Fh9Tn7shJ
	CjP+bS9XEg3bTjWKf0JYS2grl0XYtuLvVef5rKtqlPvtkpDsnew1PK6RBDxrFGCRg8xM5rDIP7Q
	q4GJByyIlQlgl9hD9rA6OHN+hjfT/WvxUt7kHBoYLajv3HQI28ei3x0X7vuzHjBnwIcUzDyVWW6
	EI7jHScjiF8T/SjtaYBKNglE35seU=
X-Gm-Gg: ASbGncuL4+feLVzu7deSEKUsh8VEh/8hTADR5c2q1qGwVSHdGXHq16MyFFs+gGS6v3f
	9j39pknd6IA0xAO4s3nnmfxQuPyheR9cRPxCKq9zU9OBn37ZYeauGNr23Np7WNzVRQRi37pk91e
	zofM0D+Vx75litIAx9Mqusoe4hZ/GzMe19tuU=
X-Received: by 2002:a05:690e:154f:10b0:600:f8c2:2264 with SMTP id 956f58d0204a3-6271e757025mr8221708d50.7.1757936519594;
        Mon, 15 Sep 2025 04:41:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF+2fM9emJqvUpuZ268rgUX/jln8QeTUIjYl3juPQj3Z71mljgmQdIGdpez0kkKWnT/IJwGwmxXt26NdlfJBT0=
X-Received: by 2002:a05:690e:154f:10b0:600:f8c2:2264 with SMTP id
 956f58d0204a3-6271e757025mr8221675d50.7.1757936519121; Mon, 15 Sep 2025
 04:41:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250912032810.197475-1-npache@redhat.com> <ppzgohmkll7dbf2aiwhw7f4spf6kxjtwwe3djkx26pwy4ekrnd@mgeantq5sn2z>
 <d0e81c75-ad63-4e37-9948-3ae89bc94334@redhat.com> <CAA1CXcA+pb5KvEnJJqdf1eSjaFiBZ82MRB+KDmyhj3DbiQqOxg@mail.gmail.com>
 <enrgrocqajwu5d3x34voghja7pbvau45oobxgabawrly44ld4u@ahch3xn6rtq5> <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
In-Reply-To: <cd8e7f1c-a563-4ae9-a0fb-b0d04a4c35b4@redhat.com>
From: Nico Pache <npache@redhat.com>
Date: Mon, 15 Sep 2025 05:41:33 -0600
X-Gm-Features: Ac12FXyJM85m-bPFRumN9WnXWH69lYhLxvXB956KqiAEAlRwvSQY7icqmcQvpts
Message-ID: <CAA1CXcD1BhXqYM7oOTLuqPHyWSztdCEk462sYXFXxJCmOpe_Rg@mail.gmail.com>
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
X-Mimecast-MFC-PROC-ID: PQWOHUd6dMYSKOKL4n0bbReXl9IxqN3opwv6DvklkKg_1757936520
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 18B52C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5uhgzkrea3b9t8eqxmhs43cz9t9d6a44
X-HE-Tag: 1757936523-835213
X-HE-Meta: U2FsdGVkX18YAbj4SVnDVuYhfFE3y/JGe1+Z6AMu5PYqROsMuayYuCmdiEJsdl2Bthcd8lBF+zzxV2SHXediqxw1NAf+on+UDnpeaNsPVdsawUnvPy3MNcyWyelBinoqOZmFkFHHk21nW1UP4WDU1f+VrCqpSwkPcqgcKvKVxuQ90an6CxsTZJbEn+dMQYQVp57AYIBs05b2llpSREZuZ+oGYFUIbnyfQUy6fQFrzB+eV/hofEiQJQTEtzsxy8CdpAYWMU1sQPy/mDbfmv9zJyxZ5Q4qaYEZ3wJvZSykdONZczi+Gkw05MqRYoLQbC5uWgkZy/1Ap4m7FaQi7KqEfyXnf21spC0+YY4Ex9DAVAy8HRJFxYUFYyAuKFoPJ5NpwqCiZH6D/+pv8WLodTZTyv3fwdIFeV2GXpLGpjKyDUCCfzTStOHfZbCH8hHYedU7KnO6mACDhBPMtu7bM86VfniI5KWHBzOJNDWLc80EO5kO36ERNQhAm9yhs4hlp52i7ehpFkl84/PADV5oySPBvqbu0SbZ+0KtBDAfAuf1unXKG6+SDZapmqD3AqbV6KZtT3z5ipr34xoHqYDJ8Q0c++ZB8Q6YEojduo5GC69jYdGcc0feHr7Vhv4+qSVDcUVhvjDtBXD0Q/LgXqGKQt6mTXOD3kGb16061k2L5BTRKqzftZzbFuJuHw2sfG4vdYwe7jDZ2xOlhiYRKJD0MaN27URWlhOzD8AARzye3nszpSKEaCwEcu7Tl7IjxHSMj061tp2iE/WSYGtwU5wNuKHtKrBsI+BzNhwTFsa01tMLhnF70qC4VS/7EbH9Ak8lpQbfRlqe/U8MAySsTjMr1dl5zv4HXFDVBzCH3ZcUiRUBg+K1sYnMEnp2eit/OUtZ0Rkd13AHx7Y8TJs/poi20wS4ErmXVmwDNfWxczWPdIF0bVG6wY01k7XIuOhQqMO91xCNTqfqNd8XQNkVn8XWDVw
 d4aeMp0o
 sNs9DiSYlicBYisJ5ok42zMn1R6pVsDGAztcWNOnOq0cLq8R2mw5Vei5aQlA2OZ9QCGZhbynROmWR3VtoHVEQBxHDH5DIiDaf7s42+dXhHqVBZz1ASy4xz6rz25zuh5purELBRwOCkP25rvaGqH/4rxbcSR042H/7a7mYexEuVoam781L5agca/beUbOPgy7m07m/eA2ecBLp+TgT8x9e8DfcgTkVObHCKdA0cPJ+8C/8J3jf4PZ91oBm7NuxEFERBeHrMYjDy9iQCREDJP1tTysLdaKogcQJr1JyrtEIV5q5GXmndQZNXf1Lf+FTY50UD9VcYdr418GcOJZq7w6vf+cmpaS24L+B9R+3DdWrUxtQubq+MOvyM64pDKNUej+ZrR3+n3D++qLk/M2n/sLzjevVWo4cW+LAmqBBQdcK9Kp4VFFnoV+EHkkrlvb50NpGTl3P
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 4:22=E2=80=AFAM David Hildenbrand <david@redhat.com=
> wrote:
>
> On 15.09.25 11:22, Kiryl Shutsemau wrote:
> > On Fri, Sep 12, 2025 at 05:31:51PM -0600, Nico Pache wrote:
> >> On Fri, Sep 12, 2025 at 6:25=E2=80=AFAM David Hildenbrand <david@redha=
t.com> wrote:
> >>>
> >>> On 12.09.25 14:19, Kiryl Shutsemau wrote:
> >>>> On Thu, Sep 11, 2025 at 09:27:55PM -0600, Nico Pache wrote:
> >>>>> The following series provides khugepaged with the capability to col=
lapse
> >>>>> anonymous memory regions to mTHPs.
> >>>>>
> >>>>> To achieve this we generalize the khugepaged functions to no longer=
 depend
> >>>>> on PMD_ORDER. Then during the PMD scan, we use a bitmap to track in=
dividual
> >>>>> pages that are occupied (!none/zero). After the PMD scan is done, w=
e do
> >>>>> binary recursion on the bitmap to find the optimal mTHP sizes for t=
he PMD
> >>>>> range. The restriction on max_ptes_none is removed during the scan,=
 to make
> >>>>> sure we account for the whole PMD range. When no mTHP size is enabl=
ed, the
> >>>>> legacy behavior of khugepaged is maintained. max_ptes_none will be =
scaled
> >>>>> by the attempted collapse order to determine how full a mTHP must b=
e to be
> >>>>> eligible for the collapse to occur. If a mTHP collapse is attempted=
, but
> >>>>> contains swapped out, or shared pages, we don't perform the collaps=
e. It is
> >>>>> now also possible to collapse to mTHPs without requiring the PMD TH=
P size
> >>>>> to be enabled.
> >>>>>
> >>>>> When enabling (m)THP sizes, if max_ptes_none >=3D HPAGE_PMD_NR/2 (2=
55 on
> >>>>> 4K page size), it will be automatically capped to HPAGE_PMD_NR/2 - =
1 for
> >>>>> mTHP collapses to prevent collapse "creep" behavior. This prevents
> >>>>> constantly promoting mTHPs to the next available size, which would =
occur
> >>>>> because a collapse introduces more non-zero pages that would satisf=
y the
> >>>>> promotion condition on subsequent scans.
> >>>>
> >>>> Hm. Maybe instead of capping at HPAGE_PMD_NR/2 - 1 we can count
> >>>> all-zeros 4k as none_or_zero? It mirrors the logic of shrinker.
> >>>>
> >>>
> >>> I am all for not adding any more ugliness on top of all the ugliness =
we
> >>> added in the past.
> >>>
> >>> I will soon propose deprecating that parameter in favor of something
> >>> that makes a bit more sense.
> >>>
> >>> In essence, we'll likely have an "eagerness" parameter that ranges fr=
om
> >>> 0 to 10. 10 is essentially "always collapse" and 0 "never collapse if
> >>> not all is populated".
> >> Hi David,
> >>
> >> Do you have any reason for 0-10, I'm guessing these will map to
> >> different max_ptes_none values.
> >> I suggest 0-5, mapping to 0,32,64,128,255,511
> >
> > That's too x86-64 specific.
Its technically formulated from:

X =3D ( HPAGE_PMD_NR >> (5 - n) ) - 1
where n is the value of eagerness and X is the number of none_ptes we allow
so 5 =3D=3D (512 >> 0) - 1 =3D 511
     4 =3D=3D (512 >> 1) - 1 =3D 255
     3 =3D=3D 128 - 1 =3D 127
....

Any scale we use will suffer from inaccuracy
Currently this fits well into the bitmap algorithm because the lower
you go in the bitmap (smaller orders), the more inaccurate the
max_ptes_none (or any scale to that matter) will have on the value.
for example: a 16kB mTHP is 4 pages. you really only have 4 options
for the number of none_ptes you will allow, so any scale will be
rounded heavily towards the lower orders.
128 (max_ptes_none) >> (9 (pmd_order) - 2 (collapse order)) =3D 1 none pte =
allowed
255 >> 7 =3D 1 none_pte allowed
no value inbetween these has any effect
where as
127 >> 7 =3D 0

So using a consistent scale that is relative to the number of PTEs in
a given mTHP I think is the most straightforward approach.


> >
> > And the whole idea is not to map to directly, but give kernel wiggle
> > room to play.
>
> Initially we will start out simple and map it directly. But yeah, the
> idea is to give us some more room later.
>
> I had something logarithmic in mind which would roughly be (ignoring the
> the weird -1 for simplicity and expressing it as "used" instead of
> none-or-zero)
>
> 0 -> ~100% used (~0% none)
> 1 -> ~50% used (~50% none)
> 2 -> ~25% used (~75% none)
> 3 -> ~12.5% used (~87.5% none)
> 4 -> ~11.25% used (~88,75% none)
> ...
> 10 -> ~0% used (~100% none)
I think this scale is too specific, I think it would be easier to map
to the one above for the reasons stated there. There would be little
to no benefit to having such small adjustments between 4-10

Let me know what you think
-- Nico
>
> Mapping that to actual THP sizes (#pages in a thp) on an arch will be eas=
y.
>
> --
> Cheers
>
> David / dhildenb
>


