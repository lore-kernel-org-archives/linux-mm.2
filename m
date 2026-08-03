Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 746BFC55822
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 17:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D266B0088; Mon,  3 Aug 2026 13:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DDD26B0092; Mon,  3 Aug 2026 13:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5B66B0093; Mon,  3 Aug 2026 13:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 127826B0088
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:26:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C9451C1343
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:26:18 +0000 (UTC)
X-FDA: 85060636836.16.DAC232A
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id 196714000B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 17:26:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcGx2QH+;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785777976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEAN21CbnYulWRvHH3VOFW9BXSHzD7GgPZMrbMx7rZk=;
	b=zW3QZXz4n0UuQc/aY7lhXQLOLmnKfa4woUmNaViSRaohWd9ZdeMHaazigTRVONkzFCvlQO
	Bo4lsu8aaZr1sQf8hbHU31fhqMsCcbSfTnoEi+pWDBfNQicYf+ivYqtL9k1X5HEmtmStJo
	7IYnoUSHKKX9GWjh1soP33PXkI9Mnmw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785777976;
	b=WHdLpgl9LCbmp8HEkrfH+rMOtRGVQ0yFbq5eWY7OG09kHuvK45rvaxSV3MG5fn1TmxxHiF
	T/x1c3p0X0UcMh410eSlZMUxW08FgLG9N9/dCMarklF5WdScBzjgBLIuVpqAqvRD91LIPv
	xH/NF89pFH5ybCsKFjubqLsgZAfXUpg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mcGx2QH+;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c15ca7a7ca9so362747266b.0
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 10:26:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785777975; cv=none;
        d=google.com; s=arc-20260327;
        b=WbNqyRmsav/bzEkdB9pzerMou5Wy81eNnXe2oPRuWA577OjRPipPU33St23V9x1IRG
         TJIcEWXKFXh9ph5/2iVrhDEOT/Xr3n13cZTm6Kkvdx6227/QP6jhQoO1svsiMH1pnZ0F
         AW8n16r4mNzVPFzlHPE/BicTsbfKaaaa1QA0pdbos6BJL7pQkUahDygJModJpY9MT9xX
         D++/JJOlx0fkm3u7SXW4+MPYHcYEZQcRM5eWY386IJ3IX3b4ik7fq3pBn4JqrSOvvKif
         qikWlVW1y1TcFeItT5rx4JvKR8pHGx6MwAoI+tAMt4hPP4SXWKFIZqst0cfeN6DnN2i0
         56Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EEAN21CbnYulWRvHH3VOFW9BXSHzD7GgPZMrbMx7rZk=;
        fh=AoLS0VlDmZ1Q9WDwItrKS6qR3UYYqcOTVyzZZRjqM2A=;
        b=r4UjG/nOl66Q9RcqDq/JcWfTj4NIPOky/Hdq4hLeuJoAOS2Y29lZZ1nPnDH/u+EuYD
         Mw3cTrqqStmKtfsnNvrxOtQLLukPDclJ2K17mXIN9DWytEFpVymA1FcV/dcyhhuTcI6l
         6/e/5po12NM+rL/LK1KphlSKB+cVxjspx4A9ySD75mn24MfZeZr0l34w4pxzE4RAuKYF
         weQjaMQolmHn+yoAaBakqOgH4V2JnEnLqe+U6nN+4UdPEXjMsyFivL65M+bPVIL5ST+g
         tpQ9qOxuBGFWAs9Io0QC2iBseFICJnd/s6FdSSocbN4YEUvTi8DYQcKcEhjVjCCtql7e
         tvIQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785777975; x=1786382775; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EEAN21CbnYulWRvHH3VOFW9BXSHzD7GgPZMrbMx7rZk=;
        b=mcGx2QH+M7ZbEcpNOcyqZ1P0OFVlDEUI3CcP2drcaEfvnwL3G43fC0HthmU+hlAEnc
         Lw6xnOnV81t5HcPNVN2liSiUqYVY06T4EMhufGb798HPtIIbdxLSuZwNuSmi1zoWe6y7
         U3UQI5OLcGfgwC7SOJFDUvg/ghv65N4OIcLWWVK6mysoeD9wslNk+I4fCSPOLET0XHQE
         WaYPOa2emVcvERnToPZT65LFxqUpcXj0A6jNcblH/wFZqJYmHnKBza31PaW18OKmtXji
         zBs6QEu/ztunrAeZ3xEaWNDx5IuA82fjqdGGYOz3kyEfh5m5mEQb6YKZuclqbeuV7Uyh
         Em7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785777975; x=1786382775;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EEAN21CbnYulWRvHH3VOFW9BXSHzD7GgPZMrbMx7rZk=;
        b=Vxa0m7rqOOWJ7bp7PjJqZYVeSGOEawOUt+Dpqr1VsHJMw04XR08/rVHL4vLib/A9Em
         iYq9AdNRyhlboaIZ8cY1LQ401NPla3Vo41nXpgZvmU62lemmMal0YiUzl8cUprQ439av
         fa8iifE5io41OstrfooZswfB6N6g2s04wSf6g1xrEG6EfITo3AE2AsUZcXHrT/v4yO7n
         eoSEqIfNwJQwttj9YgD3oa0ktZsRLWOUoaXCkgKoqOnvwZBbmMPV14fJqSiXh8wOYXr5
         I2KJpRXTB9zvs81QWNbtChZThcvhiEfALymrGRm6ZjLYIDI8yKbcFooIi6KprnUpdvvW
         Uggw==
X-Forwarded-Encrypted: i=1; AHgh+RqcFn8NOADHT5+WlIInaL7FkT2D0ui+sEVqLbMDgZT1lQAHt6EalLfPeuEyzNJqhDZrumf6xRSi7g==@kvack.org
X-Gm-Message-State: AOJu0YwCoJ4rJHjr/mE6lJnuS9TMflecOsmBSVaUhuEKpir+9efzJRKk
	GUEX0IUKEen2T2ImoHaln7SiY0ETWG609qEVFpBxq7AJ1D5rYvfwxZ+ikeLYl/TNv457Rr5eDmr
	yD4eerus8qAEhxu3jdelE12Wqx9QeL34=
X-Gm-Gg: AR+sD10k5gYeFBPUcUMO0TmOoliLZVo6hhz1cag7btCdxAeqhDEOImf0jONaSdyLSf8
	il7mcd9HFdYmVZcHW/v96fxyzhYRkMXnf9yKX4+L33dlvTtgaFp85S5MqpC4zH8mLFo6i2Lyfxp
	yrRXSTjtzZ7kLPOU7L3QTw/XvyyJNpl2/wmyS33Ka5vXxkrrxrR0XNpG0c01bcwT9XmuLEWIw6G
	rCUDmwXnOdONmpOsIs1JL8X6peCOqJ72om6wq8RCD9OpLDH04526ATkO8vnxRJQUnpVirhP2suG
	CPhasUsXfOocA4oncvX9ksj7VtEq4BuZ1L8cwuGZlFnovFDWWcYZGleNL3yriJGe+DyAY/aTqrD
	njg==
X-Received: by 2002:a17:906:fe4d:b0:c19:5a94:411e with SMTP id
 a640c23a62f3a-c1fe7f9ec8amr1056858766b.15.1785777974228; Mon, 03 Aug 2026
 10:26:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260730-add-gfp_account-to-xas_split_alloc-v2-0-5a56c2361d85@nvidia.com>
 <20260730-add-gfp_account-to-xas_split_alloc-v2-1-5a56c2361d85@nvidia.com>
 <am28pV2PEfHsi4p-@lucifer> <DKFEEI2EDS4F.1AHGKB1EL6XRG@nvidia.com>
 <anCtxQE5hDUH5N6a@lucifer> <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
In-Reply-To: <DKFEUPDED2AF.22PKCFTWTG6G5@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Aug 2026 01:25:37 +0800
X-Gm-Features: AUfX_mx1M6m7_LvJBKtV1764_tGRnsG4N-gDuqyCqQSvzFO3b_VTSjTaLVFxSCE
Message-ID: <CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory: use folio's memcg inside __folio_split()
To: Zi Yan <ziy@nvidia.com>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	William Kucharski <william.kucharski@oracle.com>, David Hildenbrand <david@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8jfgkqukir5z6fj14akfnkgkuuky53jk
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 196714000B
X-HE-Tag: 1785777975-629584
X-HE-Meta: U2FsdGVkX18LQfLwU0u97YjRqzPNP+oPW6h/7jYCSqs6TeIUQ8lvJkSDHc9egyIx7s58GBuSz14biTzZgXVIMG3wFN8RoKAur+oNa84vtWu+BRLn9+frPpax0bTVdAQLzIzwdrlZquYalDtLOMeITzoktAUxWIcNTswfOaH6SLm6XUkO7J+6ojmK8HO9fkdL+fXRxQDYdo6eVr8qTwOTpWhCOoGS+t2ap12WQ7NdhDPncqgGbnT8X6rrBrUQL//YD2l2Aewt7F7jrDFT10Tki+xeNVkkBemNexnTXwUkDYFOUpBVNUvIDe2lu9BRShpmpMRh2IaCRA2QsSLM2mz6iRX2GeCk9sGoV9EWZ4m+s5/XYbirGJSdHYIy1p4pyc1spB9Ss0umkIi5MJJEohgqYk7rGHj7tcn/mSitH2sz6uZ01D7z+HJ5xJNpub+BsQDZtV8HDplJHTmu+M4No3WnWvrVR8Pzkvfux5ur5+GzJl6n47Pu9IXosmoe6SGTRjDnQxbFjXPjsSwEVRq5Es0ir5rkxUuka6YxSU+XciS2qyYKH1m4PczmwbmR8HuS2eoV4rKJ2PamSi9FfKMNCHmbeMi7X3EAVv2utgxMXoBqRtbsHWz+hpK/1g9kY9eNnabRRI/4MksUS4WcSv/JuM740hgfZkpopVSe+/aJBHI1GTOyyiYEZLmErxH9O6r6uEgnYB/geuTB4gy8NgE6qICkJAOa+AeUrWvMl45ER/ffPV8E6ZRxp7o9niA8DHDuRqFZ5tbniMfC/oqQIeaITCEW+NzwwofhYEnfuuxo+sdo18fXdPvRIkKfHksw6ud1lwt7TuGrhMt52hxQS/UL4/mXWxcoEFxcTFTP8R6iaFNbfvdZosScxKtqiSj6sE3dihiAJvBoTKhyHkVO+DYMPdsVrjOg83jFM/GwxRe6JxpxPrT2WFAHDBEqK9eBPpSnjmtPxj7za12NMQHw9Ots/4R
 rGGEdN1r
 GOmZyl1T6Vsp7p99FAX5tgf2pYanp1w+ADqIc9aCMiTK0fwF6xCGZkXRFmADPtxeOoMj+djXZoPINZ4urMuZPdNrQ/eoejm1a4IgKns5TobsU1G9VCpl6YpemXcRpkGxALpfXbYklaJ6nB5H+UzYiAkNUWf3zrm4o/lo/ygELm5sI+Ble3tySyxo/AbFpW8fcSCVnHUuvOsk1x7gG/ESHvMd8ZiQgo0LtN3NJde2YflVbJK5OHQ/5pkbL4a8Ed+VB1Zhveo2seSqBRlyerdNZr5VHUdcjwGd2K7HwnhAQNRFGf4mWDkH+jpt79eNX40BFYNHMvJRUmOhENScTbVRsxS104dxZNlh0zebR5NSRNiR32gewqeYxFsjIq/o0aikMrdgp2OMJFgQsed3SfMazXaYhan3A/IG8ZSKMQqUIl8KB/s7jwbLwRs6qWigX9dmguRHnsb9hjqLWB61ufEaiMG3XJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 4, 2026 at 12:53=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Mon Aug 3, 2026 at 11:07 AM EDT, Lorenzo Stoakes (ARM) wrote:
> > No __folio_split().
> >
> > Comment about cleanup.h really was the whole pattern of goto xxx for va=
rious
> > levels of unwinding things.
> >
> > But really I mean the folio splitting code in general, there's a lot of
> > massive-complicated-functions with a million things going on at once,
> > __folio_freeze_and_split_unmapped() is another.
> >
> > Feels like we should really have this stuff in something like mm/folio.=
c anyway
> > too now that's renamed :)
> >
>
> I agree that __folio_split() is handling multiple cases, anon, shmem,
> pagecache, all together. Do you prefer:
>
> 1. split __folio_split() to handle each case in a separate function with
> some code duplication, like xarray for pagecache and shmem,
> freeze/unfreeze folio for all;

Hi all,

Do you like a __folio_freeze_split_unmap /
__folio_freeze_split_unmap_file split? :),  I'm asking this as I'm
currently trying to sort up the mess about swap cache in huge_memory.c
and found it will be much cleaner if we move file related code into
__folio_freeze_split_unmap_file, and let __folio_freeze_split_unmap
handle anon and swap cache, and then saw the discussion here. (A bit
more detail on this, I think we ca just assume we just don't need or
want shmem swapcache split, because shmem swap cache is meant to be an
intermediate state during IO, and shmem drops swap cache once IO
compete, and hybrid half-tmpfs-half-swap state is really ugly and
should be avoided competely, swap cache lookup is still fine for shmem
just make sure the folio is not in shmem's mapping).

LOC seems lower with the split and swap part cleaned, they really
don't share much logic anyway, except for a for loop for putting the
splitted folio back to filemapping / swap cache, and a folio freeze
check.

And after doing that, for swap, splitting clean swap cache and
splitting swap cache to higher order are easily supported, a few ugly
checks are gone, we can't do that now partly because the code there is
really complex.

