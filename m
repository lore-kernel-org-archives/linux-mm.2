Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53AB7606A31F
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 07:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A9E2gjqZ
Received: by kanga.kvack.org (Postfix)
	id 5CCD26B05B0; Wed, 28 Oct 2026 03:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57DA96B05B1; Wed, 28 Oct 2026 03:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 445F46B05B5; Wed, 28 Oct 2026 03:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F35B6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 03:43:34 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57944140BC9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:32 +0000 (UTC)
X-FDA: 85371245064.24.AD07E72
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6FF1440003
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:43:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A9E2gjqZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793173410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
	b=ahGFPbCCN4Nr5XTwikr+CO9YjU5MOpZUa6QC2BdHfb5FZd/vfqVjdsJ1ry7odML+7N6Gz/
	RoPqZEatJLB1BRdjfxrwF8LDwnFDBdFStQpBW5dS4fTssVbLRnFwQzMx5w9wyNPGltUYFc
	szCpemT9jAUPAZ1rE/9TZqHf4fP6lvM=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A9E2gjqZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793173410;
	b=kzlvM0WH3PTeh6hcadJqqiqCUiF5EDKghAe7qCiKRLnmidojxeL4yonstvJ86I9dU8pTld
	E5Fg9c9NW+t4r9sYs9HlQcvWjEaQNZFnoF3sJwOtHDRlCsy0UoBpSB6McQD0mAr8f0Xt60
	rHfm+kPSILncl6xccF15YU6W54dSxHc=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c37b612635bso77688166b.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:43:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793173409; cv=none;
        d=google.com; s=arc-20260327;
        b=MeZlagqsAUTpS9Nhj5pFr0xnl019NYNqv2NzTOktrRHd8pFehrsl7+/4ii+QaQEL1m
         McH53kT8EXxzDdwxwbbSStUwowwVWY0FqrN8/Rnro6ahxCZ7OjdlxZtqvBNT/7o4mV9o
         LUGC2IXqL/2sOEaTETmV9tFBlHbdtrjcMlzoaWfvimsyj/I8QSof0YJVwU8TFLKeVE4Y
         tFjCfVrgALqTPd5wtT9/76zE6UPirT0O4oTIjNuJBTTyDlPjNhdeS9wn8dASjcZCaT5y
         OxiXKVVS8g0hes3WjRnmFL2AfMMYfCIzRcpILBkdcnBVK+Z1X3BlOXN62pHYG4kG0lkg
         BI4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        fh=aupM/Tyy4iQCJVLqQOAUKfxN58KS3Uu7rYUkWfpSkQ8=;
        b=CrTlXNKRR4cOiVYw1eR7bs2pLmFfl74OfiFn69TyqJOtLOEpwGkOT/eUnZIQFi0t6Q
         AwU+AqEJQVXjQGmi6pm3jOCk5ZLo35IIPupCDO/WRBmiARq0m7t1bEZL1vX+NlR1935s
         g2mD/5R+O+j8pXqjF8GZOF35VWShaL6ZP56KNPpd3vniicOtzrl7MfOlmwDFr6USFiFB
         sqGNOygXR66pRTHjMqPoXWz8foyAmVWeu/+BIzpuKwo+QITyCjpyEOhmU2OnEnfc7XMp
         pQ78xGN57liLne63yAxZGPceVP/pKY+Di2R1HgRZbn+s8wbZ+KyXBTKyiwUBUZlWPE1w
         3T2w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793173409; x=1793778209; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        b=A9E2gjqZbE7PDfXZpqk0gomNlCSGDMAsn1v6ywgqqT0/eQ0SQbVHqHdRgtFxz44OhP
         wx1jBA6vTJkD5gp2l3MTCWRZKoS4PhpZ6vzJv9G/LuI7bYjin/ru//G7EQbv3VG0rB2U
         o9sq6j5a6yyjuj5zsoQuNnMuzw/JyJgsKHDZjfI0hJgm/lelrNdYURqVPVX+O0PbHDGc
         vLcwjksUS52a0/d2wiycnax0bHA4GeOiXiLLmMLcW9aVMmQ0eA72msV2izJiY6waNbHm
         e+hmDxTceAgidsJqP7cVvNZEW0xdlBvjzD1aFVrCWzhurRJeDNEkNLMcqDcX/1/SsiEx
         yT+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793173409; x=1793778209;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nskSZD59o5Wku3VNP5CAyzpTIbm3E/kieBuAkeS4vuo=;
        b=YQNk8Hvh3oZV2/ruog6Ij2N4RUsauv+KFlKwzTHn6FIpcFv++7mABNLk7xsD57ItAc
         fomR+ace9PDXMaAFXgguK9Nfmd8Xf+oILqIn8KsTwChc3+OwbiAFNZ1L7Mlry1RMGcRI
         diVPD/Q8olue5b2xAYYRMBEwUAfPooytBFGNmdI0YavGVI+/lxjyNlI3889yuBrysJ8v
         Ev7x6/KIGh03O5SQE8G3kXJ775dAkHA+BZAzv24B8gz/zWP9ExHFvOnsPZjaJB4IFGu+
         fuK3vp5gR1+c+fj1RFfRX1cjhjTUeVHVuozIEA1MGvAjuFGU/qhrE4F+P4Vzt2Uptxce
         4/UQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYoVP31HQ01z5o3B+P9RWzoA/usoEI842lVRCINYTCTGliWmsuoDqFI64FaU0cP0f3/Xb3Rzkbmw==@kvack.org
X-Gm-Message-State: AFq9FYLDLR3blj/+sOge/pBAIzQjJUGkAy+NLbfz5NIgamcQn596WPcV
	PaViOsiAMRXC/SdxvAEDtAbEdIbPcJMMSEu+9NlzI3muSuria6ZPPVk2JxydzFUJwq8P2YdeMxs
	E9kOha4OHjCXaev7CdC4Zkwpy2sdkbis=
X-Gm-Gg: AYBFou21a6u1fK1qc+3zIs9J/WnTtiectkxf01i/U8dFqV59NAQYH3eW0tKUrE3PgnY
	JhdPrM9fNch3iIBLTZsK6I6en6E0XqoJdWB03E5M9X4G44pXSbizGlnYMqSab+uHy7cREh8sRjK
	zxTZevkWJCJmbIFmKVo9zYmSYXgSRZojKXSq6fD9gSqs2nXwG7xDrNcCiDSWIEs+nDqUm/55i56
	kHu+xEal46nP/sFGa7wguuYvMJhmFrbh8bQbGFQHUYbbRL0f1KPbucanYQbTMWahfawUFgO1US/
	y4URv4gklvbHqfekaPT6IsHOQdIntWKNLXBWMfmL6lTiQXPXv3HAVtFwNn5RF14e7n/MaykoGmy
	mAR+PT5quJFfaseBLQtTyHa4moQvU3bdDS+cKK7IfipNZouPoFwxJ3UutSY4YWjYQQSqrPQ==
X-Received: by 2002:a17:907:6e8c:b0:c29:5172:6151 with SMTP id
 a640c23a62f3a-c49bdfdf3d0mr122319066b.45.1793173408903; Wed, 28 Oct 2026
 00:43:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <5fdb3777-95a2-48f9-bb38-aa4ba3c96a81@kernel.org>
 <CAKEwX=MuW6q354nB3tyFTM8d3ox7LRaqcSfUxeATR=Sop5mZPw@mail.gmail.com>
 <5ca344de-bc34-4a9b-ab85-f553811a1d9c@kernel.org> <CAKEwX=N05iOC4hmiyTt5OxjAsOfU7_V8xGfmK_RgUyrKtuyUTA@mail.gmail.com>
 <CAMgjq7DJwGCHCAchcfi2Kcu+XHx2YnKXDj53e0t2kpG_GSejkQ@mail.gmail.com>
 <aqgMCIOFi0dKx_6L@fedora> <CACePvbVMFA9N0nQers=sOnSXGbNhtNE0ewq47AJEH5Cr8imQXA@mail.gmail.com>
 <CAKEwX=OMYhUs3tt7jUzEzxsOW3yA2JmzpwwxVBP2eZuHOFu=vw@mail.gmail.com>
 <CACePvbUMjRgK=dQzLjECgBXaUtQSPdAnBXL1Y4=Kh5d15swYvQ@mail.gmail.com>
 <5c8a2b7b-b76d-4bba-92e1-ec3d66794273@kernel.org> <20261014195354.GA371161@cmpxchg.org>
 <CAKEwX=Mwc+D+AN-B5T7p=80fqCDijdsiJjd6aN_3YMrEQjyvwQ@mail.gmail.com>
 <a24ca7b8-8b42-43f3-ad72-afe62f97f76c@kernel.org> <CAKEwX=OdbOrFbdihntP3rmcWJUyM1UpYa5n+pYjt_feMQwx8yA@mail.gmail.com>
 <CAKEwX=PCSyCEAqxeOH6CkCMu1eB3xUn3iz5XNuTbpDM3EmWYAg@mail.gmail.com>
 <c6e62e80befa886fccd36d34a39cf56ea5b9c9c2.camel@surriel.com>
 <CAMgjq7CN7qTes+OXvCfsgPOnbtyY7YPytTEP3zZJTBxrGZ5JnA@mail.gmail.com>
 <12081d266e4846f23faacfc65c7be7da4ed013a9.camel@surriel.com>
 <CAMgjq7Cjt==BxXPNw5HjiA0hjxhfzWn=9gDQ+2x-rdrEQBWTeg@mail.gmail.com> <CAKEwX=P_3W+MAFe80MZ5FT0mytv-UDzfmbyBiNsYR5XjC5emSQ@mail.gmail.com>
In-Reply-To: <CAKEwX=P_3W+MAFe80MZ5FT0mytv-UDzfmbyBiNsYR5XjC5emSQ@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 28 Oct 2026 15:42:52 +0800
X-Gm-Features: AclHuK-cU-BwWpWyYgAak_kB-Mx6gRxkfBQhQnfBmZqza-WmMuBHvINcokofiDk
Message-ID: <CAMgjq7Bie8raWzLB9H+u0eX=FrUKw638mXcRQD-Qahe5qCiMtw@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Nhat Pham <nphamcs@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6FF1440003
X-Stat-Signature: ty4de8dc8bnan3qk4sr7km9p14j976t9
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793173410-875029
X-HE-Meta: U2FsdGVkX1+Pqa4yXbnkMDpnuEEb/QLKGl60G2swCMzZTTWhZbzyQDALDV15G6vQJy61C+dA25F2+RNU5QNjHky/NIGQlPc7jz6sQQx/Vxa1CDVQcmUAypsQalcjbSe23NeMothKEpeGU42JRvj3h16G/32m4Wag4nEYVZjzUdH2OM58XBqIP7I2BwsoLeYJvPSYsuMGMjBVFnPrGyGtYOA0WwXTL6/3imlPKoTQDTuLEeUeaqezubKQf5UJrJKDFETUKM59rvC1Hgp5ajjAaqd6xICvbRdEagLAZbRqNxQi0cyLv39qYTwoqcs2N003JYiNZshlrhwcBk3RlXszSBFp9KWCJrssngYUnuv5Gv6I/f9mDS6V0EkQLCB042MJYqHJTUxmKYZz3KfBI4o9z5mzg7EtgPFQVxQ3t+9/+aTsvdXFUwMaOsH417aC6Z88ZX+cUISWzthJLJgabn9lr6bg7nhhFhI+IvP7ExSv8tO1IN3XPE9QerlpA+JMAHon/978m9CMGQe9PMYmNnamZTI5+z8wiCvgVot8Dh5hEvL6mBn0oW5tSkM6hbV9eON13krmo9ajebcsZZSx2uEV5FzWOkJSO8+PLLE1kHvZH2YilAhe9qU5hvomkFC4RSbD34M4/XRe4yCN9v4WhCZOp2rjRWUZro+HSoC4Dd4MTUKJJau6Qq5AM+TMrxzIgiDxf3LipN65xtIWlKdcnZVYwxOi3W6nTfX9jucSt6aoOllO/BrtWcm52mgCaI6Hav4b8N6SWUDhgfmGvaQnS5dQVj4PwGAYFfPeDjHGm4pN9yoclpAViaoqYaR+o1CnlmEbdLLJHCSKEA394tOJ1p/OzwvcWmIjK4n1W1BZC6v33A2MOwNT2wNUAUq4GR5TjvTVzgcoSZgM1/A9Mxqjgz/wowVP4Y6upgADBUzkSdww8NyYYL1Phq3ZtzGzHPgrDfuFeXirjk+hvg3LJUYkw00
 eDzhCzEp
 KHLG+Y9VCB8NY/6jhZ3Wk1DZBl4lZiGSQ2raDHJv0PM4FXTgTyRVIzfAU96EY68OR6z3A1fSxtoQDkkv0y3AgNVypniM0JSs9parxvMyZqNyvx0fC52AHxw42f1/KdnEn6utb7ZPNMWNX1Bdh0BQJYdoDiYWMqQ1rBG6iSiep/VYWmfUiF1YeQGCwVUDBu0qW1wrjtX8SrgjES5CdJKILAAam0F4NSlLg1aTsweDQZoi1bayjBwnijfDQm+DXKlpOPUD0UuH8nAFLbdUtDzpDHCrPBuPfKVF1F8AiFco6nuCMinbbn8h7UP0JwXo4TwBYL93iLXLNJVEDBpDb3bqxbwfvIzdJ5R+SSihOiHmCFerCwDSx0oh6VYUVzeyEJaqwYvvukn/0RzoCx9esQKdbodlb/uhXHTjO1csBcualOcZ7Rs1BCz9/CL3c7LRNo7YzMW9+gyt1tEza42aVTGbOr32cnydxdLJvPZnpf9ATFj1gGYbLcKmIZaWCztgUA5IiNyjGtpiCVnWe60HG80BLC5QoCl8o2+GFns9AkBbE7qX2XlxIXIzsw2Q4ZfmX5CvvvAN4k8qyCjixdGv/JnIEFS5lEgp0Tsn2MonV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:01=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Sat, Oct 24, 2026 at 9:22=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Rik van Riel <riel@surriel.com> =E4=BA=8E 2026=E5=B9=B410=E6=9C=8825=E6=
=97=A5=E5=91=A8=E6=97=A5 02:16=E5=86=99=E9=81=93=EF=BC=9A
> > >
> > > On Sat, 2026-10-24 at 23:50 +0800, Kairui Song wrote:
> > > > On Sat, Oct 24, 2026 at 4:03=E2=80=AFAM Rik van Riel <riel@surriel.=
com>
> > > > wrote:
> > > > >
> > > > > On Fri, 2026-10-23 at 10:24 -0700, Nhat Pham wrote:
> > > > > >
> > > > > > * Swapoff: this was brought up as a request, but we ran out of
> > > > > > time
> > > > > > before we could discuss the motivations and use cases behind
> > > > > > them.
> > > > > > Folks interested, could you explain as a follow-up?
> > > > >
> > > > > This is one that I really don't understand.
> > > > >
> > > > > In my mind, we have vswap sitting as kind
> > > > > of a swap VFS between the rest of the system
> > > > > and the swap devices:
> > > > >
> > > > > +-------+     +------------+
> > > > > > vswap |-----| swap cache |
> > > > > +---+---+     +------------+
> > > > >     |
> > > > >     +----------+-----------+
> > > > >     |          |           |
> > > > > +---+---+  +---+---+   +---+---+
> > > > > > swap  |  | zswap |   | zram  |
> > > > > > file  |  |       |   |       |
> > > > > +-------+  +-------+   +-------+
> > > > >
> > > > > When a page is unmapped from userspace by the
> > > > > reclaim code, it goes into the swap cache.
> > > > >
> > > > > The vswap layer then decides where to store it
> > > > > at eviction time. This is configurable by userspace.
> > > > >
> > > > > If the zswap pool is shrunk, the vswap layer knows
> > > > > where to put the data next. There is no need to
> > > > > change page table entries to indicate that the
> > > > > data was moved from zswap to a swap file.
> > > > >
> > > > > If we decide to disable one of the backing swap
> > > > > devices, the vswap layer can just move the data
> > > > > into the swap cache, and the page reclaim code
> > > > > can evict it into a different backing store, if
> > > > > needed.
> > > >
> > > > And in this case we want to disable vswap itself.
> > >
> > > OK, so you are looking for a way to totally depopulate
> > > the swap cache, in addition to swap files, zswap, etc?
> > >
> > > I think we can accomplish that by simply keeping the
> > > current swapoff code around, which scans through the
> > > virtual memory of all processes and brings the memory
> > > out of swap.
> >
> > Yeah, that's the right starting point. The scan itself can also be
> > optimized to be cheaper or better later on, but that's orthogonal.
> >
> > > > I also hope there is a way to release swap metadata completely too.
> > > > e.g. for fs, you at least have umount, and can rmmod the fs itself
> > > > afterwards. We also have many ways to bypass the page cache. In cas=
es
> > > > where a virtual layer is just a burden, we want raw physical swap,
> > > > and
> > > > the ability to swap off that too.
> > >
> > > The VM cannot operate without the swap cache, though.
> > >
> > > That is very much built into core parts of the VM.
> >
> > I never meant to strip swap cache out of VM... The opposite, actually
> > :), most of my work over the last couple of years has been about
> > removing the paths that bypass the swap cache (e.g. the
> > SWP_SYNCHRONOUS_IO fast path), to get a simpler model and better
> > performance.
> >
> > What I'd like is for swapoff of the last swap device to return the
> > system to its pre-swapon state: no leftover swap metadata, no leftover
> > per-slot or per-cgroup data or statistic, and ideally no residual cost
> > in the fast paths (e.g. minor fault).
>
> So basically remapping? I don't think that's terribly hard to do. I
> mean the swapoff code is still there, so it's just the question of
> exposing an off knob, basically?
>
> But wouldn't MADV_WILLNEED be the better tool here? Or is it not reliable=
?

I think I've mentioned it above? You will have to iterate through
every process in every container every namespace, from userspace, and
do some remote memory access / control on all of them, which is really
not a good solution.. It's not reliable and is really hard to maintain
or deploy..

