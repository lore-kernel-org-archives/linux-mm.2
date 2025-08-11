Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3A6AC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740816B00D8; Mon, 11 Aug 2025 02:59:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718216B00DA; Mon, 11 Aug 2025 02:59:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6068D6B00DC; Mon, 11 Aug 2025 02:59:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FE736B00D8
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:59:14 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BAD4D11715C
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:59:13 +0000 (UTC)
X-FDA: 83763574986.22.28D3F86
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 17D0BA0005
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:59:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b10u5cTj;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754895552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuOu3OMLWRZy/GrYfsj1vU+FzwQIbj3WgU0WMDegCto=;
	b=YqV23MPjHe1BnlbwteWkJt3b0pgqSfy4OwQj6/rirXZk/UjgeOZDb/GJfbmIYJwr7EaVQx
	KQXLuICTsXgyKkkCZW98xVMfi4iGvGvpBHds5gaIxp3IOgZe1vSk6zTpmomzLP/k3hHpoS
	Oz1PQpujWbYP4flcDpcYn3wRHUdAfzM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=b10u5cTj;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754895552; a=rsa-sha256;
	cv=none;
	b=xM8HA+NkWs3Qc8wdRNXB0eK9h48nt90hTADfDNItY9Lp4vzcHjVYUeAE1ZBHfJZoUE0l/k
	w7LvtNhH1APdKc6oJ6YrsbJUwud5cofZD5j2UloRlbr8/zagAWSQcpU76D9835RuSBkuA7
	V61BIRTmdxxCH7V23LZYTPAzdlkoNHI=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-70a57a8ffc3so38208527b3.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:59:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754895551; x=1755500351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TuOu3OMLWRZy/GrYfsj1vU+FzwQIbj3WgU0WMDegCto=;
        b=b10u5cTjduazs3FhpDuE2uT3Bx+pdQ30PUHT7xIjHgWBjRb2D4zlYGXba1SyuUX+I9
         PU8yQpZE6kxXMiR4g2iduBfN46oTj48/uNgX4NikyGkvEXYxFb5TesjszhdrdBZwtlfa
         yYgz8Oc/IG06fTCDo1y05cHllmlDsrBiKZXwhrDjv0lBkPQiWlBzh2udLO1OuvBpNdmK
         8Gc2s/67slAZU70qOW2996/0UUerWr/oPNQ6s3uOpMwXuXyUkBFfceyflzbcxL+akOVM
         rfdGF+joe0lChGTW5ZTBLVHhaOrmvF70hl2jIdnUoajpNNBIvdCHUUNg8lOap1lHItLa
         PxLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754895551; x=1755500351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TuOu3OMLWRZy/GrYfsj1vU+FzwQIbj3WgU0WMDegCto=;
        b=D+q/6EYlgLlNc327LUHSWop1mh54hwkOtlVqBAkQdy9TsmVrUw4YGA9WSECHTUwDxG
         LgegCTZajOdbtfKN+RE3sHN1psk0kAU/Jtr4AaG+cJuZ91I7BVt/b0WraVjcbFb7IxK+
         0Zu16AdzE6pJdhnTdsk217VSPdgVJ7MFKWbBYvli70uqY5CQH86YnNgj1oRPjtJ4BQwI
         RLLRCy5skVEz9Xt3KMQ3hfTEvfmF+SHan1WClm4ly3rk0nR1414LDl4Vk5BS4kj8EWd9
         Js1NwpnBA+g/grWzy4ZXMyOfrGSsvrTExUwThC5l5tkUUK74chTTWPrT/+5m4clz3pjX
         gV7g==
X-Forwarded-Encrypted: i=1; AJvYcCWH5jzOMtjq+oTYzxMLz9uMNZCHOnk9LQ0Yua3AIdc5JFTYLYJ+7Fue6eHql2cdYjf1WIzTfroh+w==@kvack.org
X-Gm-Message-State: AOJu0YwaPU1RPzU8kSwbG0y9NJFFWe01Z0HFdJYqoRPEUYSrZvoO3VU8
	H9pcNeiyd/nS7A4BbuExsJGtD/jBt6X4acvsdmyPH29YEkoagQHp15VEkURejGzMzvA9ACkm3ZG
	G/1VBfRHHl8Ha3//fYMomWvzaC+dUh+E=
X-Gm-Gg: ASbGnctZm225aa3Beg+g/Vcv2ywPXprTDNVJhm8rtK7N0iDVgfGzWDdMrMX4gXQdVbe
	m7gnH71OwLJN3cMgQlMDnnRimxwfgoXzBW6Xr7e+kpMLNftRtrTYFwpS2W99FnKeL8o/TIgwiGK
	5eUVELkem1yZtASbBErUqJTCS5cfVZPQ3NNoflZ2Bzd7g8Vat3p3VnFhdxdQQOEaM0f4HXS0N5m
	Z1znAY=
X-Google-Smtp-Source: AGHT+IEbcYjT+506lJ1E8j322xg7JOfAMpd/UJ9FVya57rTPDfeGc0w3hklgL2ebknAB2dJaYt27gaIWwQkN8hNl6h4=
X-Received: by 2002:a05:690c:868a:10b0:71b:fa04:d16e with SMTP id
 00721157ae682-71bfa04dc14mr94083937b3.16.1754895551013; Sun, 10 Aug 2025
 23:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250808190144.797076-1-ziy@nvidia.com> <20250808190144.797076-2-ziy@nvidia.com>
In-Reply-To: <20250808190144.797076-2-ziy@nvidia.com>
From: Barry Song <21cnbao@gmail.com>
Date: Mon, 11 Aug 2025 14:58:58 +0800
X-Gm-Features: Ac12FXxoqfvnZ6zVcvsM3WYdQubEnyeJWwkI1SyNlh9YvtyzjV1u_HW36tSML5E
Message-ID: <CAGsJ_4y23gxB+P8=WkBe+oU9j+1YDZmBUTdE2=aw40O78DA7Yg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] mm/huge_memory: add new_order and offset to
 split_huge_pages*() pr_debug.
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 17D0BA0005
X-Rspamd-Server: rspam06
X-Stat-Signature: ppjb7f4efq6rc3useczydbj7ihhsd5gb
X-HE-Tag: 1754895551-171443
X-HE-Meta: U2FsdGVkX18KaKYjvjMHNbZQvfNrRDqEy46af8n4FUjP2HA7UI8l1KHXTdn09i5LafAuKeiCBLoKk4M4Sp3vZrUednu+16M3OmQ/CTPtgMGzPYiut4bQG+5enrNPrev73GcaAC3LZRIbirPjDoDdyzKcz+gR+20WHZkkTXHsMxgW8z+04dbLO9+bmFfxdvK5vfqFx0s9hVWSihS7BBt1rmwjZx9nPTxKC3Zia4KwHl6vtlNx0KEi5pbrNWpYSHsi4x5gZdpNq/zXxTWmXgjZJqGh2dpinGznG11squTU5q/Qaxd/cQOYdVqOQOgTr9goIj4mig/dAsbzNL3RCDDtTMRaMDG5td6OjGs6yWqGruyEQBYx1YIQsF19cQIoZjXCu1Jf01gIQmoVEfMXRh65sDrkUq2oB01mVNm7cmQg4VEftksgWLtPpZ+YAYYcebqUhh20fVP1t0yqw9tpmFN9wTMj5KBhEtH59zM7TQ+BsZHsLOVq2Z6YvWS8/SCCsvASNfk1Beh0HyD74Ou4Z5Xw1dExxEaWlrL0RaiLkxREpLI2StzBzl9GU6/e58X/XH1b2bhnHtVA3Lw+XL6OBbs+IA9xoL8TExx5/vde2/S5CVaHoiiXCqDZDi1NIIDZk0scA7JC4Iw+cPnrDzMGWEXZFRhcHCUIWRgGtmxNMuV7pB8slyRWZMDZ2vlEaRq59my99VX/HjSYz+A3oc32s+jgqlnG2uiy0tXwi4d0C1jIM7M1RGFzXLl3g/8qEQ160uZ2TtM6h5Rn95FZdYlZt8ELLtJRn8JtAovmPcpaiS0PTamvp/thL5amopKn+OWMdw7vGUUPEVj/xE+Odl7kCj6cI5Z/VT2+Ocp4p9FTrHWwQFkELjThCo29eRfQitT8i3TlsK0swdnQQE5MQlMeuKvazaKTJDdtytgej0+IV3CAfDdhPl3/8dPEj2zTiCO4xtZYX5If1ApNX+FA3S3xZrP
 QbB8M8is
 ME1fvijwNIn1MOPuRwTs4Noqwx3NX+cnOZxXE0u0xefwxiiMZFbCUJw3SaeTW8Wj/llLGVH1Kx0ous0fvE+2eEnzVAoORD2LOxg9DAsCGIHzPauqHk2b0NACliF0u99PqbXv1sPt+4cc07hU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 9, 2025 at 3:02=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> They are useful information for debugging split huge page tests.
>
> Signed-off-by: Zi Yan <ziy@nvidia.com>

LGTM.
Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/huge_memory.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 2b4ea5a2ce7d..ebf875928bac 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4327,8 +4327,8 @@ static int split_huge_pages_pid(int pid, unsigned l=
ong vaddr_start,
>                 goto out;
>         }
>
> -       pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx]\n",
> -                pid, vaddr_start, vaddr_end);
> +       pr_debug("Split huge pages in pid: %d, vaddr: [0x%lx - 0x%lx], ne=
w_order: %u, in_folio_offset: %ld\n",
> +                pid, vaddr_start, vaddr_end, new_order, in_folio_offset)=
;
>
>         mmap_read_lock(mm);
>         /*
> @@ -4438,8 +4438,8 @@ static int split_huge_pages_in_file(const char *fil=
e_path, pgoff_t off_start,
>         if (IS_ERR(candidate))
>                 goto out;
>
> -       pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx=
 - 0x%lx]\n",
> -                file_path, off_start, off_end);
> +       pr_debug("split file-backed THPs in file: %s, page offset: [0x%lx=
 - 0x%lx], new_order: %u, in_folio_offset: %ld\n",
> +                file_path, off_start, off_end, new_order, in_folio_offse=
t);
>
>         mapping =3D candidate->f_mapping;
>         min_order =3D mapping_min_folio_order(mapping);
> --
> 2.47.2
>

Thanks
Barry

