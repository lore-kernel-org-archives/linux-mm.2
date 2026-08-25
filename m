Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C758C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 18:21:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F06B6B0092; Tue, 25 Aug 2026 14:21:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C8886B0095; Tue, 25 Aug 2026 14:21:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290076B0096; Tue, 25 Aug 2026 14:21:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0082C6B0092
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:21:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 87FAF8011D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:21:03 +0000 (UTC)
X-FDA: 85140608406.13.AF616BE
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id B44BDC0009
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 18:21:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMxyPdUz;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787682061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
	b=V9SnTg/oO4EQrMGPH0LiUbKWLQp/yD4IxVQXhVr/EyiUhvM+5ilVOg5SHTDxsLAHcBETHC
	9Crotami/aGa2X1VeuUPUSO5P2x0BP3K2svpyJiXUtI4fOBG2fcQxQMPg/PBQZOm5rHumN
	CtedtY8sXderfXHpivHvD3aEq7b8nNk=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787682061;
	b=TKR70lu+Ehq48dlkxQqitJxqqIZE/YYE3cxRxbF01SY0xcXksdIn4hwqY3nIR2B3V8E40L
	Qx5BmsHShEnCgLP0zBZq535VJQjpCeYgzndiiil/3IgMHen/XZQ9I8yNAPUsKxc+nn6A9F
	6xqS3WUg5mIdYdLrDWzJgQoMtOy4cF8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMxyPdUz;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c2074710751so934211366b.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 11:21:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787682060; cv=none;
        d=google.com; s=arc-20260327;
        b=kr/MUBRi1OiE9yHIy02J1pu84N6sdn/apMa0wlehlJJPUYjHMadbv3jfs/oLSD815g
         HR11/8TF0gKqf42WnXPUXxP+41FA0KBPObMTH7UFP/v07MBke2n8HnJ+R3Ul1ooSJxjk
         u0C9xXSne7qG6NHc/0cJy//ufU/UKGdGFYkxeNfadgYLtna9KL6AZLsetrQJi42qJyKp
         O19+3ge+/F62txBudZtjOLS3NrcbvxDs8WMxxXDaJrzGeUCvE6OSUJ5xrEuGEwFp6T3J
         PTXtv650jmEUURREYbM4ezKfNUN6ck52AS+XBshGwm8vuDKMP/neilHx85TtXPUkf/i1
         UgQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        fh=sSxWdZkaFVeQjqnPWV27Nlezj+mkFUIjYDnQV3tX/BQ=;
        b=J84JXBvcodMTTXyqxf4l5lqzB+rMvrfcffS0WzuoAVl3LiK46OYe5MkPOOwfAB1aCf
         CFI7NwIPbrndkkOUjECOa9+NNLa/TT6bHmNlgpyu2vzcx8b0SWldW/Fx+l04MGsAjax1
         7CoVzWSLfbO7JyvNts3/A6dq8K+cLGuox2oC2jTltRzkRFaixWD8RDcZetPsi2/ABR1y
         izVENROP+APVqIyORfzxwHGPij8UMWm1sglQAw2ehJX4stIckl2OzVNgS09A65NH8u3w
         XpydR07DRm6n8yeTFw4haCeDcSjcEMgWYzBSDrVuZPGeWZli/+dWrx5fU9N1yFb+tT3d
         ulaA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787682060; x=1788286860; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        b=NMxyPdUzTCcn71mu36dZgP6SW9lJA0I4W0cwAWqVzSjAOkd8iw8qWegyvWR4Y90DWT
         YdMltem2LAQfJlgMhVtqW6BVUBw/7LV8ybDNptW9ULCpd2V7JfJH/8UhkcCyap+eUIrp
         FAmYx6PeYGe5l2sf6bZCJjWGsi1t2kw/SCcMHx5dDB7rqMlzLK0zsXjfLZymOYKmZovN
         4OBajQPsbscOEk13MXlRpOG7gHWzBmQUnLu5nUeA8H+N8uq4gUXqC//X7VHqSgZdeAek
         nYBDH5gbEU0N2owPRU9uHZQ1KLZbVmj5NsQeOmDA/ZWoC6DlgCGOtblSQEUJnGxfYEuS
         tkkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787682060; x=1788286860;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ODQhhb/CDE443Rj/4ZuYP20/0K8ohc51c/+lKvAoakc=;
        b=DzLc7wosXf7sb8xdSLAmwkc3G/J/FYlin03WhCguMZl+sik0qugbxajrtB/7LLb2ph
         t//uUEIQI7RnDaGDtYmVNE02skUAfV6C1fJgtzSuswVqluw3QtQKSqdl0F2ODnvkqMHO
         PfS5VcQHDeRZV1tdnxrjsa1y/5pzCE+7TDgNQEqeiNE1PdGyGPaO8Z8/D2uk69xLpAgM
         KjY3V18LIP+0ZO5aAmMeyT8cBlYAHP+cI6UoNSVxl8O471B7tIzwKIC3nObGJTXKRNPK
         +5CTF0g63LghByEOcCXa14e0xlQL/WItpL33/U9ieY+U02gc4mXD8GsPVl8nO31cY6Wj
         BDeg==
X-Gm-Message-State: AFuF++kpjy/ysS5n7mFtHO43KnWHLzN6I3dEwh1tnfvl61xzcOUJe/mt
	bco5hk5TXTE2RgC0lFXmgG7uZVwn+ecx81TL4MMKpwJA4xD3MkspY5tDTI5rWUHdmZCrr0icw6N
	re3RNPV+lIzOr3pX5t/cEgnioj8pNTx4=
X-Gm-Gg: AR+sD11AO9wH736lpgB7JKvJwXW/8eL087LYaPVU5yKsVxyf6+Isic29Q8AuKhLqYTs
	R3dr25VQUs8JNKxZVjdQFNFA1mY942FSbv0bweC87Gp6JJrT7OxjeuUAN7dfvBBaIno1N0D6U0O
	dZ66bxJ336Afmvn03KT61JBzjTr9MZ1tiVhZhL0y6tr2rM7VssJGsSCGrADie8jWT2TVRGIKkoZ
	jUaE59XMhhGUnSx8NgqJJqPE5skIOV9euy3T8YNd+Of3sooyZGVZaCEp1hRZ6bT1c8sYqfeMapI
	tb4KlrckeQn1svJ9DNOLh7vu13n71vyhbBYumpI29Jrd8pJooudmvHZA8EP7MLfRDs6+fxc0R3y
	jZ7uZJbObmlRw
X-Received: by 2002:a17:906:6315:b0:c1c:4e36:eec6 with SMTP id
 a640c23a62f3a-c250c608d86mr52189466b.18.1787682059979; Tue, 25 Aug 2026
 11:20:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com> <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 26 Aug 2026 02:20:22 +0800
X-Gm-Features: AcwNN1U_5z30Xb0y454YfAJGi9xba_Kr9vW4b5gdWTy2Z2qEjtPAhDL3tECEXfo
Message-ID: <CAMgjq7BheDgQZa0=KiRnxVwky9by5LA=iaexfPfT0WftgfL=qQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B44BDC0009
X-Stat-Signature: mbct55yod1rrtqanu1h1rip94o5akt59
X-HE-Tag: 1787682061-123525
X-HE-Meta: U2FsdGVkX19O1x/jFEw5vMHS3vB1DMD56z4QGirqTln6ssEFTkMFEFTg4gZIYMN7UatyxxOgXC50mlYS8cbpNC2v8/FrZIT+DNpizEr9U82R3b9AWKyyGBzn8nsMAoz/apqbGyL9v9OITcplZ5EwiYK7Lijy23m64hsDw/ACiLPwEkGiWTdGsmaXqPKpGdOD4+lFTs0MbljLp/yNhJOy1gmMrCCtmFyfKAphGuPoRQ7kK252HdfSljzFVk0sEn0Lc/xiwhbwhBTW3dDMLIMe6J6cOjqzRsIIdOIsfP42FGfHvShqKVoeZ/v20uiRQunda+grqv3KcW3sjo85mlLXps5s+bPubFfFaCsvPQVlSwZFIFgoofKaxODLzlhPLBHBtBH9qfNE8sEPoKdHnl6lT2RR8rRtIx1cM7GGSk396Yb1+CpoYVeQtjxIk6cWiTWinzn7sMebY0TpipdDjb1NcJfqhVxUHzjd4UsjAjaplxlWuoMw4sG/SglTHuPh+GC89aELhxU6glP50bWk9b5a9D9qUijUTd8RI7isF21PQRivTRvNemkNjsxqQ53B/sqKZ8hgxPuC3HRElRYBdsAJY2kjXX5VlW1O4ae3xqBlBZTYgKUcHTY8Sl5/kSlSsswVCTusG0kZDTl8H/lXz16kl1shY1G6Ph0SEGnjr1pzvpO0HmiPuhJ3P7VYTw3lVuBI4lUzNooEM8CFHTgIYtB9cML6qdNRxnONm4DRwoqCb10poOivLFqEwkFcaAWQyOnh44YnxQCcnH112WMYtQLxiYHekN8RSUOumRVIEO2i2G3s5Xd4RySruI2jS5o3IVvDa28r5Gs7K7/Kz2bnnbxvP0wayb7UUiB1vPwBOux2rXiM2xTkIhP5xT/18y9gBwngaE3PpIfL0RSwn7lCsGFJMBaBjmYn+/97dBOUsfLX6FJeTQ6jLHqC4zHr6+A7FOP8n/X81fw1LrnlfBDj12X
 ryW9ryfK
 +qXQkE00LhTBTiGxH+DLcYA6pkD/VC91XPIvAuo9gII1406ByerDrVAzGuHsrLLn17qB4iNy3HwasVdkldFby70Rmqw3+T7BtfTwI3/MmpHtlFN/suiIJZR0OOPsMJBDCXPyAZkn+GYT97IXI48TY3B4mJ2pz8eBYksudxLgp8hCSPK1UjTEzyokruU/3f/bpGL8dlbg4+FeFsnGiOUoAGETSuMmS6Q7jsacz7760zMykpM6GPKvSY1OHJBjMver6kbiD+rJFaHpthDQTH69iMo/rcoPVxS9SSkoeMwS58w/KCnfaL3VKodi2AxpSV9rV7tcKY9+zlzpJw+XSoGkUWZG4sZpg6WS3ML6lYS67Nx73bKnLP6XUhy6Ji/LW2D+cKIhlKe0RwGw37mqfnlsW1jXK2Mjh8cRSe0hUWhcye811tWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko reports (TLDR: false positive, please ignore)

commit 381ba2d1b94989f14f9427e1427b761444230107
Author: Kairui Song <kasong@tencent.com>

mm/mglru: introduce helpers for manipulating gen and refs flags

This commit introduces helpers for adjusting a folio's refs and generation
info, replacing direct bit operations on folio->flags.f. No functional
changes are intended, splitting some combined atomic operations into two.

> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 621c8653d8f7e..edfaf26618120 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h

[ ... ]

> @@ -270,7 +331,7 @@ static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
>   gen = lru_gen_from_seq(seq);
>   flags = (gen + 1UL) << LRU_GEN_PGOFF;
>   /* see the comment on MIN_NR_GENS about PG_active */
> - set_mask_bits(&folio->flags.f, LRU_GEN_MASK | BIT(PG_active), flags);
> + set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active), flags);

This is a pre-existing issue, but since this line is being modified, does
it miss clearing the tier bits (LRU_REFS_FLAGS) when updating the MGLRU
generation?

When a folio moves to a new generation, its tier bits should be cleared so
tracking starts fresh. Failing to clear them can leave stale access counts
that inflate the folio's tier, which might distort eviction logic and cause
thrashing under memory pressure.

Since this path is executed by memory pressure or page faults triggering
MGLRU page additions, should LRU_REFS_FLAGS be included in the cleared
mask here?

===

Not really, MGLRU somehow currently keep PG_workingset once set, also
PG_referenced is a bit special. In fact, the usage isn't very clearly
defined, which I think we can sanitize with MGLRU-FG later, but not
now.

