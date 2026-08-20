Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55488C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 09:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2EE6B008C; Thu, 20 Aug 2026 05:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67AE56B0092; Thu, 20 Aug 2026 05:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5914C6B009D; Thu, 20 Aug 2026 05:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31FB46B008C
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 05:40:46 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98B5112040B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:40:45 +0000 (UTC)
X-FDA: 85121153250.09.F8A3EC6
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8A2D140006
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 09:40:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NqlO/OGV";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787218843;
	b=Hu3grkXZvEgNOsAeVPjkCVGqDN7a5ahKJyCNL92oP+DmcWn8myxPotf/gj5wwwR0XAyxhW
	TpdJ/XEBE5AROpZxULLI3osfipXWs4T5Tyjoi9MxpMUUbazJ4XJuf6XMcGfEqjw3zS0yq1
	Nax9FN2cYxHDsdPCAX+RZq0X7u1PLvE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="NqlO/OGV";
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787218843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
	b=pEn0wdQBBORnsL9kb6PMvsL//FUivjQrVjWLbbIO4P54fU/YiMNykajSryvaxv8Eo4T+4Y
	djf9OD6VwzUSHmkBPPKBXGXjHOxP51s8oyFjtRabqnHkXFfpxX4AJ2xrjBjJCOZ4eMDU+m
	Azg571i1xHlhUJazxubxr7UrLEHsq8M=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c16794450aeso286321366b.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:40:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787218842; cv=none;
        d=google.com; s=arc-20260327;
        b=GStQapjVjRcxUfbe+AgDnG8ShJymvgDX1B0WyyybDuJYXUx1xAh8ErAKLtRK7A9uuw
         WfaTh2y8nw61FtjvQNLw+xf+mVLpFtPTtRpRvKBd+HSfYQGRtpuF6VYz+alMoMVKdaFU
         +gl5MDnYvvSjbSVNO12Rp9bpAn7S2xB71KyPP23L1NpRmqG0xjsLvQ2tCZgqJb3Q34am
         ZCCMY6wETruhuMBImsUYeZhqmdfBCKAEDrfK3ukTCQ304i23z5UZ4b8y83p+nnCel5rS
         YGqAQbRBBUOrwMamNkCQnN0EmAZreZ/rneKC/hQca66JRGT8yQtlwH8ncJfGGG6tuCFl
         m/TQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        fh=Tegm9b/wb9oeluhlaL11P0PiP4fwGOgkoLy+Bqu40rk=;
        b=mzIe+icg6KqPfjvrl1aNeiSg2Mh2ra4EL2BNc5M2HRmyv6NLV57Oxnil9/zUgwipOi
         xDErfMo3OTwAczylUJVPOnfZr0jrWkAOR0W9WjrV99B/CSIvpC95YiNHnuqPv56RYvbB
         WzX6aER9jnrXt2cLLFKE/gp9Tx/CeyaHi7IKOB1/VGXOuJfoljtJX5DZF1RAB1l14Oq1
         fU1zKjjXZlGK/FbKFQlqcXfieT4x+bf40SydQ6+AU7N3W23hivMZo8hBnHYz6Zc/GTag
         F3hC1utksBVeHVzDiBqmKdl0aKzfod1LmIRUVshLQr3/LpUafWJjSlqg2z9A/xvE+RKn
         FeDg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787218842; x=1787823642; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        b=NqlO/OGVC52lE02WuzvSI6PXhKo4WmDjs0Q0CZTlFMmEibIJiHUzTDZz9LpTNVh0Ks
         tVo9HVtHV4kJFfP0DYzOWxiXxjV2r7groKnKr7cVsG/Pfu4MBBqbuZ9Ty68jsMDS6ZVg
         2IBWIF9tR0EodfID1UYeUUJaWT9fRLqhrf0AA8jZf8PEKamGmTB+5brGmC5gz/i8sNSx
         Znn9sWUPjAgTFMGOu2O4aIKUj4xIW8jlCrg5cyU7w7WnedX++SfW01BpF52104A0AZe4
         W+tEveELV7rdALMsBBy9PkF5p5XDixOa32n/7hyj1Z9dUXwMynFkkq2hvTfRV1k559tt
         NWmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787218842; x=1787823642;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yBtmafbOayxaPZWLoQ+wO4hHf1gY8nYnCw9TiJ7qd/c=;
        b=DYLjAu6oiIfRRf8CdF1s4iULeSpEoth25ol4UxzdIvIKcqXCUCkFUQ1Lj7IeXY6Zi0
         PzEsgtryjDCwi/HIRo1LyDK8UCr+x91wZH8FYMrIFZNb+I2YuxdEwLVLIcLsZgJ3YjDm
         Zm3+pcNgyPhsELrzf7qg3SjYqU/SYK4XdYJeFMmEgwEGKWU0YukAgk6LT8awpSnig7Zx
         stYcoAmf2gUPDrS7FLw08AdO3BQr8a7MtnBJgzotBDRLIt8fDbtc/d85lYP1ITm/asAp
         7GP/BFBcE1k2DMA5cATYz69bjqoFEaD1S5JAcMP7vcvdbL0+GyV/XArq0GEaWIGX9IxV
         UQ2g==
X-Gm-Message-State: AOJu0Yyk9qxSRFtYfsin6PYnJJJNTjheb9lRvsYxTBYASC9bJ/TCaWaQ
	Sopuqp/xqko4HvVTANlL3/HGODfzv6SJHb7NZZ6GSTen5FrCg7ufMiAb0p6dSHZDExCcgPPU0Lf
	VE0bE0znNF0iHoaApUA/GlFyV9w6HLuQ=
X-Gm-Gg: AR+sD12L7T8509RxdyG8rT4YEvnAo4bFMJ0uEsu0ygzZtKsQbpGKHGQ/IhAET65jkQG
	O2nKegtZTReXyt2mY/znPqH55LFASrmQBePZyoWkGa8I0FzBvnTuE7hKkyB2ZNoF58gBUhXVsT9
	/slBiTd7+pZTJMKA4ArZ4/peq0WDqJNwIVObmgH+NS6nRaJoRAasD76laFf0qNu6iFssFMrqxOe
	ox4QJ6jN40+4/jiCNhBgASgFyOVUfz+eBen57ta76ImGZb3VloZwH7UYeNQNLDEQE90n3t7TcAM
	v9s6C0KyxuGO3Tb4OqqqUkny0+Vv976JurX05e0vYjDqQGgdx0HZrxGGwHdP9vDTnOlMT2sSq3R
	m
X-Received: by 2002:a17:907:3ea8:b0:c21:3fa7:5a6f with SMTP id
 a640c23a62f3a-c242e3eadf0mr738216466b.24.1787218841867; Thu, 20 Aug 2026
 02:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
 <20260818-mglru-flags-cleanup-v1-6-8dbbdac0d28c@tencent.com>
 <5db7dbfe-ec22-4a25-a85d-497e6ed1f8b1@linux.alibaba.com> <CAMgjq7Bz5Kz0YxFcVwbWV4bh_T4qQH0vZYbxFCXDtLzeX5hjtQ@mail.gmail.com>
 <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
In-Reply-To: <43bbc1de-039d-422d-9119-c7392e0229c6@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Thu, 20 Aug 2026 17:40:04 +0800
X-Gm-Features: AcwNN1VA46_KpTMs79ty-j9XeTd7zcF2C5_Wk1dEwysbQv0vrgYxQy3Z5NAPDZQ
Message-ID: <CAMgjq7DiEYvURA_jykn=s20mr-cOAtJcmdau+byJ_qX_+-YqXg@mail.gmail.com>
Subject: Re: [PATCH 6/7] mm/mglru: fix potential generation folio number leak
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B8A2D140006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: s4mq95wyzjez7jpa76b6wjczrsj7xnci
X-HE-Tag: 1787218843-367815
X-HE-Meta: U2FsdGVkX1/vpsndbscxgR54sbh+6WNIKk2ilXFOUY+Mege63S7mJNz0lzInM9rmLTAB03xmA8+q82ABcQQYSq/f0v8C31k+A5+51c2uav5yQoNo9ZM/KZ/3lF6XzVJlrPSLWTJta/KqA8w83GdgotjkAB3tuaC8Z2qjflZ1HIVYJJeak7r43FSIpMGdl8aQxKC9a0lHgBRvyBu4quKp/9XYm5oJOZWq/SL8HbJh+IE2aCxtGFiDQhoFsuY/E2F/nFeg7bWqOlaIRVnJpSKsRUs9rwFq5FOqpHuI49piax70hbb8ulbgWzroO6QKyL79wvmu+6MUaFReTntkEZsT/Hf58Zh9agP0rRgJ3DWjBCLdQEsVa6uUiS/MIWfm8FUz+Hq30Jk42ZiXf3fcN9/jIB2iw6K8W7UJw4ND9t14lyclD/Bu3cPJtIqcuOdcqeMHjsmhuimpYXA/0hFU7vzv5ZkpkFGdqwDQ9gudQ3lL/PG4ImtFUKwUppAyRIpmsGomVcFR1DACBa/n4+f/ZTMsWNMra7FjAX+ebPpGgWjsOBtMKG6VYS8lHdAOF01LTg00dxP5B2z+qeyMdk93F3eMj0+MwhBmD5EEJg4Kwsxbm7EN1GO4oBHPBrCfi0+e8jYy/CSvG3vkfnDs5J70OMHMF6eHzjPMlSjZxY+/AHqc+/4mVgqcQ6Pt0vAqH29YafeiaWv44JsjDrt7qqioSWtWcZYqbZWd31HISHBWisydXuyA4HqSYJ44vajR/5wt0AcvCZpzrkm5uiO5VEXVdIWBihRluAJLqPEAsB/cDxauUbLvRVli5HkX8op7uWHZkegxPtbY3cInoZQvqQn56HAu/r+RyRHLsZr7BUKpnBUAGJfVe9tiM/F6DFTJMSN4qU8vEZs/j4Noid3oS9vNKgCpopBZx8HWxTG4A1WMKcuipseUGUC6mr6/zGOYE2pQ7yxqYmFJzHCDJrEIbeAWHCA
 U254Xr1R
 eUWqoKBB5sw1WWxlUNsRskx4JrkxeBebKux6dG0ALs8ZE+3IGhrYDeryeQwY3eUZ5WSAYmH38BkP8k45NYNbDbI9L0OtSAYdjTKFmI3tzi24jMY8zH9WdIN2oOpBJRGOZWRDvGJw/NjVV6QweBWEnyG7bfmBjHmaNnTeEqa9rYvVs+So7N5v1lLQ/ykVfyf+8SCS72xSidYGuoLQVUL2aC6Q4r8lxywTs+tY+JOAOl4+C+ol3eFmbIr2Hc4nGeMaf2KJjlRwzHceGgi1luFkOxU9Kn686QTKlJPj4nQ34rebwc7TgMJXiSkC0oPz3VcAdiXmuEKhPCV6X+nyMLQ2UhUiY3GVT5Q+C+FhyzHUVxfTbZ+OkdmCH9ME1Sj+kdBw2wEfTDU8BkNMqMkO8QoziHgF6881jKuygDdrDMFoURdvKaMGcKdZaZlWXdj2nZ0q93m16
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 20, 2026 at 4:53=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 8/20/26 11:45 AM, Kairui Song wrote:
> > On Thu, Aug 20, 2026 at 9:52=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >> On 8/18/26 1:38 PM, Kairui Song via B4 Relay wrote:
> >>> From: Kairui Song <kasong@tencent.com>
> >>>
> >>> Each generation of MGLRU accounts anon and file folio numbers
> >>> separately. The page table walker's update_batch_size() derives the
> >>> anon / file type of a folio from its current flags, but the page tabl=
e
> >>> walk holds neither the lruvec lock nor the folio lock, so the type ca=
n
> >>> change during that period.
> >>
> >> Right.
> >>
> >>> MADV_FREE's lazyfree path clears PG_swapbacked under the lruvec lock,
> >>> so the folio is no longer considered on the anon LRU list. Lazyfreed
> >>> folios can also be changed back to the anon list again. If the flip
> >>> lands between folio_update_gen()'s cmpxchg and the type read in
> >>> update_batch_size(), the batched delta pair is applied to the wrong
> >>> type. The anon and file generation counters then carry phantom deltas
> >>> that nothing reconciles, permanently skewing lrugen->nr_pages and the
> >>> reclaim budgets derived from it.
> >>
> >> But I think the problem occurs between update_batch_size() and
> >> sort_folio(). update_batch_size() only updates the anon or file folio
> >> statistics, while sort_folio() moves promoted folios to the
> >> corresponding type's list:
> >>
> >> /* promoted */
> >> if (gen !=3D lru_gen_from_seq(lrugen->min_seq[type])) {
> >>          list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
> >>          return true;
> >> }
> >>
> >> If the folio's anon/file type changes between these two steps (e.g., a
> >> lazyfree folio), it would lead to what you described: "The anon and fi=
le
> >> generation counters then carry phantom deltas that nothing reconciles,
> >> permanently skewing lrugen->nr_pages and the reclaim budgets derived
> >> from it."
> >
> > Actually no, the counters follow eventual consistency (note the word
> > "permanently"), we are fine with a drift as long as it will eventually
> > be corrected. Lazy promotions creates counter drift from the physical
> > location, but that is actually fixed by the sort_folio.
> >
> > Now, for the type issue, use the lazyfree case as example (I think
> > that's actually the only place,), lru_lazyfree will remove the folio
> > form lruvec before marking it !PG_swapbacked, so during that removal
> > period, the gen bits are zero (folio's gen =3D=3D -1), so any lazy
> > promotion CAS won't touch the counter, and only folio_update_gen will
> > do it since folio_inc_gen only handles on list folios. The
> > PG_swapbacked clearing in lazyfree only happens on folio wich has gen
> > =3D=3D -1 (off-list). And it makes sense since update PG_swapbacked nee=
d
> > to update the counter and move the folio.
> >
> > And if the CAS happends before the list removal, the list removal, the
> > folio is on the anon list, so the CAS is moving a folio in the anon
> > list, folio_update_gen will call update_batch_size asking it to update
> > the anon counters, we are fine after this commit. (Before this commit,
> > the CAS is moving a folio in the anon list but update_batch_size may
> > occur on file coutners). The list removal will update the anon
> > counter, and the subsequent list addition will account for the right
> > file counter.
> >
> > And if the CAS happens after the list add, we are still fine since the
> > file counter is charged and sees a file type here.
>
> Thanks for the expalnation. Now I see the problem and I think your are
> right.
>
> (This involves the combination of the gen counter and the folio's type,
> so it would be better to have a diagram describing the race, otherwise
> it's indeed hard to follow.)

Thanks for the confirmation, I'll try my best but that's hard to
describe :(, will also try send a proper cleanup later maybe also
clean up and merge PG_lru if doable to make the convention cleaner.

