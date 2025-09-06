Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F4B1CA1012
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 06:40:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DE0B8E0007; Sat,  6 Sep 2025 02:40:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6278E0003; Sat,  6 Sep 2025 02:40:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2988E0007; Sat,  6 Sep 2025 02:40:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E4208E0003
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 02:40:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1E50B1A0297
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:40:13 +0000 (UTC)
X-FDA: 83857875906.18.421E117
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf07.hostedemail.com (Postfix) with ESMTP id F30F340008
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 06:40:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XvGGOAj9;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757140811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqIvGeRaxAz05kA2S50rycLnEg9Gm/547IL4mmKsRZg=;
	b=5tViYkSJm78iVfh4Ijhb6MXvherB5dDhe3RtvdlQWCljNwRpaov3Z3hjdQ5q6Eo9tKRmR7
	9Gd0Mvs24kvZdvYR8+NORpQB/MDBDIoSsSvjd7xohlyt9aYkI4wcupMbgVbU4EZ0N0RwtZ
	oNvKrHOZnK8KmIaOJseATA6hKtYiE1M=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XvGGOAj9;
	spf=pass (imf07.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757140811; a=rsa-sha256;
	cv=none;
	b=MpnJ7w/LoMnbmFaaajso726lNtD4UbZ2EbKwBvdbDCSabW8jqsWrXNpsEXBP7Eol7FX22C
	jqAbH3Ngh11a0eVioaUPub6JwjXbnA9VY1NsxrKBAfISgJlvJD5ggpytFvjsiHdDbXtQVB
	TvZh+SG0qWeHV1jWddCU/vFztRVY+Ws=
X-Forwarded-Encrypted: i=1; AJvYcCXEQh59HX3VVygirzORdmhCDRcjFGgKny88zkKEss2wcv53ieFCbaf3HLPgMppjwWuqWGv/1covhA==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757140809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gqIvGeRaxAz05kA2S50rycLnEg9Gm/547IL4mmKsRZg=;
	b=XvGGOAj9YfKkoyJ3SkxMpgm4zh/2PW/rupKgqzh3BDsQMMQl43fzfXQ4bba3hOmsSX1NWW
	QXZDwSEvKI/vUp9nM5dAkycGgsmvxbe1w1YNaJ+UNxEhEQz+5bdMS4gzOzTt1OkjnidJ3Y
	l0Cul3EaVDVTeP1eTsXFKw/noHVXnuU=
X-Gm-Message-State: AOJu0Yypp7OyAdn94BvCyosX+gIXPes53+Xuvx49V7ZVR8QeXAexs52Q
	VDnZhJMRN0kIeN9Iw/ABVkbpAMz0zxI+T+vYPrteS5c1wcp2XPzmSx4mLjwUAQ9yGnVMr8LjvBx
	dyEioHxAAu7X/LFUAUrgtbtnugzs6VDQ=
X-Google-Smtp-Source: AGHT+IH8BlxPCXehT53D8cOwU9O0/ODblCgSZL9wMB8fWtgq2u1xvZZjoe9oV/6yUXkduX62o+onvNt2qPaa49Vvms8=
X-Received: by 2002:a05:6214:1948:b0:716:fdea:db16 with SMTP id
 6a1803df08f44-72bbf3fb1eamr69690796d6.12.1757140804761; Fri, 05 Sep 2025
 23:40:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250905141137.3529867-1-david@redhat.com>
In-Reply-To: <20250905141137.3529867-1-david@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Sat, 6 Sep 2025 14:39:26 +0800
X-Gmail-Original-Message-ID: <CABzRoyYutoeA-OX_Y99pYy6cYxb0iYXpWK8Js5jn_Xp2JYyaDg@mail.gmail.com>
X-Gm-Features: Ac12FXxJgS1tMi1cNEiT_Y8dnTFoVxumeja2536-J7u_yM_UU8Y0HYuyc3aPuek
Message-ID: <CABzRoyYutoeA-OX_Y99pYy6cYxb0iYXpWK8Js5jn_Xp2JYyaDg@mail.gmail.com>
Subject: Re: [PATCH v1] mm/huge_memory: fix shrinking of all-zero THPs with
 max_ptes_none default
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F30F340008
X-Stat-Signature: rxprb7bz33j6in37641n3dwyrd5sg7rw
X-Rspam-User: 
X-HE-Tag: 1757140810-891476
X-HE-Meta: U2FsdGVkX19An94GmvUXuwA9jxMXgri/O77HmNgQN1qJYMhxudQoDcUAVJom86Nkrt7B+MWTQxjFMzCAFH9AiTGa3aAjb1K9rSiGa1thgEQSF3GpTHsNSQZVV9yMliJADmjlsL30Lg64Dsoje5JIukvAxzmAmFYCpRwk43kbchaxeObYmiYrjn9Oxh2poWVrJfN7se4aq3LLIKPPb7lqWFRinLZ70NYKpa8nfpLn/z28YkCVuUfjnV1RHlk0ED05+eHqpuNBlz5YD8ulEDsfb3O34+Pk/ULo9y/HYV6l9VXB09tv2oosqQYAkxWA1/eh4wu8gbuynziEHRPhJ/WZ/c6fSNnpFomUPXcEn45IiZbOYuV4KiTRknkVl0Qz62Jf5xMD/xauUY9HYdRugAxdVjZEJ9lQm7EyYc/XGbW24p9FtEp4g53HdmycnrmFBcqTsaJbJVm4hIPGc+xla15H9TDdRnUXlSbt88YJBbHROHMcwxniLgpMChXOmjy6me+KluZAU4tb3S+IpjBdVxRXyD6D9JB0Q0VNNOFaMNc26GwNLDD53kDq+ZypxtsqpNVvAnKxkqQmKM1wkSoPLdt5gidwxjAoGcSkYKpHQyXQhiCU+71Fsecxo60Q/k+OjWoto+YM4BQ87pBV6qDFHZA4TGKAKJ16PWRbaFblEmIj6ldBZ1LK4lpKZFSi/VQjXUWy/pq83H3XAmhFq6fh4e2TSuTby1uXFwpcZ0vgc3lBxTxnT1ZDcA5Vif84NVydkyC7U0HCQnCoMtk6rXlUEZpLZYPOgWcHZ6rU3Z+qxUrfLeWJ/oKQma+IOPmdDTiT02JJ6ML6U8DKr5RnIIRkCNfYSRmM4HbIvsVItdLRm4ebtvLUKPtIwmeclPP69HLims4M1EXI5JOts0n8myxfIndVwAtHr0kj8MkO9SQifKiCcXn4QnHxAUXh0vMBepsCKDV/GQ+pXikjV8lzHJWmpWs
 +paVJim/
 udBlls2A8NsJo9XVbATLk2S2yboYb63gwT7XpXgSmVVvOPSIvLBK6aV+J1XVtNZ27aw3PL4CtUZ1IBLCLOLg5iROdogDmamx8STkg2onj036gZJz00ZZcM6svS59OjbL0UBp4h8+8fAByQlz5prSmbwtRgeJAGaSFb0FveGT6LTDSJ3kUunb4suyxcF3qs+dKzG+AiOuJzo8IOFoRjK+xS4TDY0/P4O3HfhSTqoF/iSKFhsd7YUl5fk2nJzzTgHOfpEa94dbN929vkprUDrpQ4NI83ygZDBU3T80WJ94GIZoMbV1eW/845WNVZXnJd4t36pV8ABmJUfgU6aKPiOnJBAWAdwU5NcvZdEnKfGDoOWek7RsrXXSl8QGrU0XUANJnOzzoTHRxA9rzqIYmb7gEzcXI50TNiwUQ2cjTR/ZPBMfNPHvuja2KLadDEsHpVpwpCfP1cJogH2aZGvv1Ffs6V//hqkme3OUoPgF6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 10:14=E2=80=AFPM David Hildenbrand <david@redhat.com=
> wrote:
>
> We added an early exit in thp_underused(), probably to avoid scanning
> pages when there is no chance for success.
>
> However, assume we have max_ptes_none =3D 511 (default).
>
> Nothing should stop us from freeing all pages part of a THP that
> is completely zero (512) and khugepaged will for sure not try to
> instantiate a THP in that case (512 shared zeropages).
>
> This can just trivially happen if someone writes a single 0 byte into a
> PMD area, or of course, when data ends up being zero later.
>
> So let's remove that early exit.
>
> Do we want to CC stable? Hm, not sure. Probably not urgent.
>
> Note that, as default, the THP shrinker is active
> (/sys/kernel/mm/transparent_hugepage/shrink_underused =3D 1), and all
> THPs are added to the deferred split lists. However, with the
> max_ptes_none default we would never scan them. We would not do that. If
> that's not desirable, we should just disable the shrinker as default,
> also not adding all THPs to the deferred split lists.
>
> Easy to reproduce:
>
> 1) Allocate some THPs filled with 0s
>
> <prog.c>
>  #include <string.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <unistd.h>
>  #include <sys/mman.h>
>
>  const size_t size =3D 1024*1024*1024;
>
>  int main(void)
>  {
>          size_t offs;
>          char *area;
>
>          area =3D mmap(0, size, PROT_READ | PROT_WRITE,
>                      MAP_ANON | MAP_PRIVATE, -1, 0);
>          if (area =3D=3D MAP_FAILED) {
>                  printf("mmap failed\n");
>                  exit(-1);
>          }
>          madvise(area, size, MADV_HUGEPAGE);
>
>          for (offs =3D 0; offs < size; offs +=3D getpagesize())
>                  area[offs] =3D 0;
>          pause();
>  }
> <\prog.c>
>
> 2) Trigger the shrinker
>
> E.g., memory pressure through memhog
>
> 3) Observe that THPs are not getting reclaimed
>
> $ cat /proc/`pgrep prog`/smaps_rollup
>
> Would list ~1GiB of AnonHugePages. With this fix, they would get
> reclaimed as expected.
>
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Signed-off-by: David Hildenbrand <david@redhat.com>

Good catch! Feel free to add:
Reviewed-by: Lance Yang <lance.yang@linux.dev>

Cheers,
Lance

> ---
>  mm/huge_memory.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 26cedfcd74189..aa3ed7a86435b 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4110,9 +4110,6 @@ static bool thp_underused(struct folio *folio)
>         void *kaddr;
>         int i;
>
> -       if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
> -               return false;
> -
>         for (i =3D 0; i < folio_nr_pages(folio); i++) {
>                 kaddr =3D kmap_local_folio(folio, i * PAGE_SIZE);
>                 if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
> --
> 2.50.1
>
>

