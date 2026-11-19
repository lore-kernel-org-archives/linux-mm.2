Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE08E606A32C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 23:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=cMwd+ouE
Received: by kanga.kvack.org (Postfix)
	id D5B846B070F; Thu, 19 Nov 2026 18:28:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D32EB6B0712; Thu, 19 Nov 2026 18:28:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C47F46B0713; Thu, 19 Nov 2026 18:28:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91BC96B070F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:28:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13C4CC0C92
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:28:28 +0000 (UTC)
X-FDA: 85453459896.24.FCB2AE9
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1E8C620003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:28:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cMwd+ouE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of nilayvaish@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=nilayvaish@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795130906;
	b=QG91q8+tG6mvKo3pmw9u/RUs6IEY7RnSGoy+tqkMHQ6El8m8OV36jG2/a2EXCdRVgpzmnw
	HausU7X2IIjkRqhqzUxZTrTNohak4+LFyqkCkMkCIt8q/RE0l8shbnqjTD5F2gYckeJ7jW
	tyqoLu40qEKWr6qGdfxMDaPLbC7CdIg=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795130906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1GzTQLbcvr2B8pZzy6gTMzT58ROAMc3lyTn0CSd+rPM=;
	b=QQyZoWJD41Ax5lGVbbl9ntoHVtCZs60ssuL2KaTGg2TDrjJvNKWL1xeGbjH+cO9DPIXHbg
	oEwICKmstl1ru0GqnQ80mGqOf6hZw/pJQSccM05mweqyi4Nqpt4hdL4h28UUAs9cnLOtBc
	5hEjvpi4kuwzzdvQYJG0iCqpsTnfjUQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=cMwd+ouE;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of nilayvaish@google.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=nilayvaish@google.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c40e30c26a4so315769666b.0
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:28:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795130904; cv=none;
        d=google.com; s=arc-20260327;
        b=SvpVSTU8U47Eytz2gMSIOviewCw/3blIp26iQx5ublw8rwAsaTBbsfc5c90etYJ4YP
         8CvRMUZuNeCju8fZdVDBYkwXkqxsNIZY8AYQVm+5CNBQ4s7tQs+qKa+5OGLkDgiafS0N
         aGh8l9XH4sxNiXwoHl3hHcKde2DVkE/k2UCEgilvGumxDDSSWgTB3i4OuB4U00qj61tp
         wNnXmr1n8zW+sAvnJ7RgktMQ+znM2r0r8ceIHOZi4Im6MmFgYv8dapx2Vg7MdbKVYzhW
         pKMwBLfXQp7fJsVtJrfk4zP+5cahwLBcRbmsEESX7VOv8Y+CKSz3UnkozAhZvRBgo74z
         5wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1GzTQLbcvr2B8pZzy6gTMzT58ROAMc3lyTn0CSd+rPM=;
        fh=80ly53i86KuYH71S6M+irU6IMdcwQV8qTyjPlqrkFgY=;
        b=GQwNNvjtCUJyLT2bNsY3vvmzKJhi3hTVF48WkP6Q+76dr257aRaMKlX6M3gaJ0RioF
         eUZvhczcs+f5CfrEQit4pllDNCYJcl8L3nCsbZp16qnjbObDP0sExKPf3d3Fk493sDcH
         wOwV38I6YEoycQduq+C0LjiYXq9BSDUrH5oqxvA1IuXmNAzedn+8ZDDffjEu639YC/r4
         ZDDNpTHpUZ2hpRK+rf5IA7Lf8IWlAJy4IJs1sRs1bIOplVtmnGQp3Hd4Q01QhN7xRJoo
         gALC/07SH6t8Iifltsko3n3rW5GiXeFp5jve9wcgJtwETmKe0wyNfz017Hr4CjOb1cuV
         DwoA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795130904; x=1795735704; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1GzTQLbcvr2B8pZzy6gTMzT58ROAMc3lyTn0CSd+rPM=;
        b=cMwd+ouEB8vRf3uRee8k8i8Y9bve47bsAK/Pu0WOEHWggfKM7baZQKHkY3F5DHQMmv
         1KIPyQO4DYX5xzvyeUBe0GQ3S85TDYrg6dA+8eq0NiVky9Mig5IokAWs6Pc1tfm6+v1s
         DtC/Vt32uc5f+vPCgnzSj1ZqqTb1WTwg+ctLPBCFTt7sAqF+OLHRVRVgNauOrS81V+JA
         7LiD3Lmd7gIQzbH/dkXXvvGm8ZeH5zEXfvLUyV2DF4jm2we+l8w+ELlyh16YHmgabOxL
         GzxI1LdwMe5n8hJ+rfFhNIFDD9W4EZ7akkwhOihFqD9oN5XI9lzLMOQGuIdVrc2zgtkQ
         UlVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795130904; x=1795735704;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1GzTQLbcvr2B8pZzy6gTMzT58ROAMc3lyTn0CSd+rPM=;
        b=V9t8JMwxdtFcmZQv89RZ+eubXCBr8z+xjiBMJUw35SzWxJgdmekM47D9LHwmcGHXxx
         fAFOjbXlCB7xvqL4NbBMtMTLPUToa5mVQxS11sq/617kxD76mk92LiNBj/eBd3axYBZT
         +FSU75ad0zG2/oTJZ3SNBbFQl+4AmIt2WjXoRRknF7a1gxK6yMAzo5US1/s/dBiDBKkW
         VO/0BSAQnU9D0knfif/KD44KIn4oHKgkHXTrVJpiLKPNEdIr9oLmT0PiisT9wkvWUX7O
         GuoqTPtEi/09+y+k7WNeb6+l+VjaFt23EPzKelcCpPjoMEIeROY5bI7NIKDbyBMu3fLb
         9Yrw==
X-Forwarded-Encrypted: i=1; AL+hErGqER5o5ab1C4bCFG0fsW/DJ7xuwgTkDPMCzB2XlUwHvRTe+vk5OROtFElflawG0sZTGmipRxqACg==@kvack.org
X-Gm-Message-State: APuU4Z8vASX3y9MVsDumnxaYoQvlRkBKHD827DLor/Lb26pMj6rmgeq7
	vTFq02T67wR06o+vcG89MwW/R87S8/921jcE//MsUjkmNnr05DOFTdo+SLBwz6cNj7+EafXjYik
	OF3wcV0ZylZa2wKgrbCln+epWLekkvLRRyQGTowGj
X-Gm-Gg: AYBFou2lVcOLwhgtvUy8AzG9lrB1IjD+f1nEVHUoeX+/kqstGoPT7zt9YJ6Xx0AHobm
	3OKDQJ7IXELtD8d1iFsCMkj6+gq1L55TdrKQPJ997OiVO1f9wWem2GVgKiUsS7fH8mEOBKoGgQd
	647i+UniEI46cJjaTrnoQADNRFl9lYjJHMCslEUDinxmy4absfQ/i2Ib/9TTVakzATrFebvcplL
	i4SUroH7s+iRxYAiptUSw42/ua28GNmuiCrskTZP6LSqyoAL9KahcQkVIsTPGNTyV5nFBM3TJ0U
	90kNM24gNJoUNpuhFUi+O67hTt4Tn/UGMYfAm7NXkhCafTr40lZkH7HsFpy0vNdCJZf+1Z58cAy
	naJrnsjya+nBfkVd0Obc4hyHZlUki620riC4p+DhrUXS+muxN2Dyq5VoZAN8ReAJDA5SODRLCiX
	FpHrt4ZXXNtk1pRlnTasG7bh7WVrApmUK+Ya0PKKh95FgO
X-Received: by 2002:a17:907:9408:b0:c4c:9abd:7373 with SMTP id
 a640c23a62f3a-c5131a91cc7mr291756266b.33.1795130903971; Thu, 19 Nov 2026
 15:28:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261118230044.683221-1-nilayvaish@google.com>
 <1CB074CC-E9E3-436D-8D04-8C203C825E82@nvidia.com> <72E0E689-0FA4-4DB9-B978-711EF6DEC490@nvidia.com>
In-Reply-To: <72E0E689-0FA4-4DB9-B978-711EF6DEC490@nvidia.com>
From: Nilay Vaish <nilayvaish@google.com>
Date: Thu, 19 Nov 2026 15:27:47 -0800
X-Gm-Features: AclHuK8xjVL7ZpvdmZpixIraolc1ihaB4NwpDYE2FF0Mc1K3pFOQ9Hepjtwwk2I
Message-ID: <CAJm2bjqm_uK=vPbY5hi8CEuHUJmidUYzRn=Y6TAnuhhRjLt9NA@mail.gmail.com>
Subject: Re: [PATCH] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
To: Zi Yan <ziy@nvidia.com>, Zenghui Yu <zenghui.yu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Balbir Singh <balbirs@nvidia.com>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1E8C620003
X-Stat-Signature: 5dbai86uatrmptbf9z6dwhq7w1ig7tb4
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam01
X-HE-Tag: 1795130905-810693
X-HE-Meta: U2FsdGVkX18wsX00KxWZtyX/0PXP2F7cDK5fJRF9Kwrq0g2yJq2m/TLKR1ch0qhDicvCE216ZUrx7WjK4s7xSiT4Jr+BqY41J3MYv4P7gx9uxzdcx1v9XP+hvu0waEDcPHIy8U8j23btd3qvUzBc97x5S31pRV/zVlyCspgyVRZJDDaml+Xep0FKg8hJFSlaMdqCrYPCewrPoSSFYIedtL3CiJb3dsbfHUhuW2NyGGu37LzEBS1w18R3ww18j7tdX7b2nxTWv7rMbGWuOGwYnJzZB3Tb7CjAYjmvnuREAD5kXlWKg/bu9D7NPyeOznN2ziBmkhhWzynL/tMg3tKsdORXnqeXTmcHBGjdEnXde7Irxmzb/pZ3ptR2C9c/vBJVRBH+f2L1xa/kmO04sI2sQZqBz8k+rpzuqCC7iGdvdBkgMMTvx5C6HtrXHvKnSgZh4EdaKvni9bqBG/2Zb989OHAACGX+CPNra4KLZRVbxuT2y2nF7UR8fvQ7w94kbvOc1pKZT9vlVFjrPLp+wmeJx63ejXyKDH6lAnT20E0/PnuLn1YPVNR3O5lpBqGa52pjib0YI0AezzmZzqD7LOpTb0Jg7o4vUF0MThYZLm2mycK4OEhIQCui3jzqfrmKSj6pO4EfQSfMF6+pUe5FL/VRIB05mfJGTGH7HTWgHA6VOonjOpy5bLyOxZDPKBe3GYzhz9g11r7mZRR28l5pwuzolbRabsB+9zDaIzAUQ3VHDteX8dGiwwdhBi3eSuPswVH/mW4ZDLLG4IckibhNrx57PSyef4tYkpbxvGJR9PewGsaRLHBwnLOqFmtN6L0t60TunPfD4FfL325Yg0yMxYZ1sn9F7JhNAz8gwtGUCQ0l6ODLDXeGIGv/3vjz1kAeIz1ivcggzllFa3X0vfxBhH/dDuUcSpbqWeI2VnHvTOhdY3TNd/eDC2/W3FUPs4Q4flgfIVq9pLZUMhsSIN4+/y+
 uIiIiyP1
 iV/2x4Pr7hra42VUph3sPelL/jXpTnweZK12F6SUKQePZssPQe9LKCo5Lrfcb8gAslR/EupN2YYHtTTyaF//RiyboT4/NE+c+ljOyWIfEk3yaDbe2+AGiIftFmoaGFRJnwJxSoZOHx2occh313FpG33n5TaRgeDe+X7XZQsiv8QPz8YGqabz6EADeygOL2C3l7EKG7tBXPmASyLjeQHgJzfGbC/wJtansbruxkehZWLlORoPlPQ+mOoogPiWaJ/Fld38JnI/g1OFlwjcio90M2IVm2y30E8J3vvsqsR3Q6LRJRBIRT8KzefAWqabHMZv3xaOk68e/bdD481RHUKuRd0mCYELcH1udOV+Yf5qZd4Dok+lc/r0j9XTxM6cEKxAr4Ap5U8wEiZOX+/2L5GpuKlww1lsMyPWK5GUyb+YNMmvF0oSocqdWs0WLNNYLtuEF5DRKnHDX4zo1NcrMuXGIFdrgwAUSIoQ5bQcxf1snnkhYsQyZ0t/T+QZEoadrnINPzYImYNfOSlhF7vbZMj/ALPLmTH1FGiVR3MYbJyaHeZgd35f9T6llaNBC5YaOsY6wmMjXdOx08NvJo9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Zi Yan, thanks for the review.  I'm about to send a v2 that only
replaces the pfn_to_page(page_to_pfn())
round trips with plain struct page arithmetic, as you suggested

Zenghui Yu: Thanks for testing the patch!  v2 has no functional
changes.  If you get a chance to run it, would you mind
replying with a Tested-by tag?

Thanks,
Nilay

On Thu, Nov 19, 2026 at 7:38=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On 18 Nov 2026, at 18:24, Zi Yan wrote:
>
> > On 18 Nov 2026, at 18:00, Nilay Vaish wrote:
> >
> >> For device-private memory, test_hmm backs each fake device folio with
> >> real system RAM of the same order, allocated with folio_alloc() in
> >> dmirror_devmem_alloc_page().
> >>
> >> When the core MM splits a large device-private folio, the driver's
> >> ->folio_split() callback, dmirror_devmem_folio_split(), has to split
> >> the backing memory as well. It does that by hand: clear_compound_head(=
)
> >> on the tail pages, folio_reset_order() on the head page, and
> >> folio_set_count() on each of them. dmirror_devmem_free() then frees
> >> every backing page as an order-0 page.
> >>
> >> This open-coded split does not split the allocator's metadata. The
> >> allocation tag and the page_owner record still describe one high-order
> >> allocation, and PG_head stays set on the head page. When the pages are
> >> freed one by one, the tag is debited for only one page when the head i=
s
> >> freed, and the tail pages carry no tag at all. With
> >> CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading th=
e
> >> module reports the leak:
> >>
> >>   lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page ha=
s 16744448 allocated at module unload
> >>
> >> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers=
:
> >>
> >>   alloc_tag was not set
> >>   WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d=
0
> >>
> >> The backing memory is a private buffer of the test driver and nothing
> >> requires it to be a folio. Allocate it with alloc_pages() instead and
> >> split it right away with split_page(), which splits the allocation tag=
,
> >> page_owner and memcg state and is already exported to modules. It is
> >> still allocated as one high-order block rather than as individual
> >> order-0 pages because the driver finds the backing page of the Nth pag=
e
> >> of a device folio by offsetting from the first backing page, so the
> >> backing pages have to be physically contiguous. Every backing page is
> >> then an independent order-0 page for its whole lifetime, so
> >> dmirror_devmem_folio_split() only has to point the new device folio at
> >> its backing page, and dmirror_devmem_free() frees the backing pages on=
e
> >> at a time.
> >>
> >> As the backing pages no longer form a folio, take the order from the
> >> device folio rather than from the backing page, and index and copy the
> >> backing pages individually instead of using folio_page() and
> >> folio_copy().
> >>
> >> With this patch the device-private HMM selftests pass and the module
> >> unloads without the messages above.
> >>
> >> Fixes: 56ef39899643 ("mm/memremap: add driver callback support for fol=
io splitting")
> >> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> >> Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe3=
9c8f4de@linux.dev/
> >> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> >> Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c=
035ea@kernel.org/
> >> Signed-off-by: Nilay Vaish <nilayvaish@google.com>
> >> ---
> >>  lib/test_hmm.c | 41 +++++++++++++++++------------------------
> >>  1 file changed, 17 insertions(+), 24 deletions(-)
> >
> >
> >>
> >> diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> >> index b409c42bfe6f..371ead009f8a 100644
> >> --- a/lib/test_hmm.c
> >> +++ b/lib/test_hmm.c
> >> @@ -201,6 +201,7 @@ static void dmirror_device_evict_chunk(struct dmir=
ror_chunk *chunk)
> >>      migrate_device_range(src_pfns, start_pfn, npages);
> >>      for (i =3D 0; i < npages; i++) {
> >>              struct page *dpage, *spage;
> >> +            unsigned int j;
> >>
> >>              spage =3D migrate_pfn_to_page(src_pfns[i]);
> >>              if (!spage || !(src_pfns[i] & MIGRATE_PFN_MIGRATE))
> >> @@ -227,7 +228,9 @@ static void dmirror_device_evict_chunk(struct dmir=
ror_chunk *chunk)
> >>                      dst_pfns[i] |=3D MIGRATE_PFN_WRITE;
> >>              if (order)
> >>                      dst_pfns[i] |=3D MIGRATE_PFN_COMPOUND;
> >> -            folio_copy(page_folio(dpage), page_folio(spage));
> >> +            for (j =3D 0; j < (1U << order); j++)
> >> +                    copy_highpage(pfn_to_page(page_to_pfn(dpage) + j)=
,
> >> +                                  pfn_to_page(page_to_pfn(spage) + j)=
);
> >
> > struct page should be contiguous if their PFNs are contiguous.
> > There is no need to do this conversion, right?
> >
> > In addition, dpage, based on the comment before BACKING_PAGE,
> > is device memory, so it should also be allocated using alloc_pages()
> > like rpage. Am I getting it wrong?
>
> I misread the comment, dpage is destination page. It can be ZONE_DEVICE
> page or system memory depending on functions.
>
>
> Best Regards,
> Yan, Zi

