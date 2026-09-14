Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EC8C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:03:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40DEA6B0088; Mon, 14 Sep 2026 04:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E55D6B008C; Mon, 14 Sep 2026 04:03:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D7CB6B0092; Mon, 14 Sep 2026 04:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05B5D6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:03:32 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6E5451C30DE
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:03:32 +0000 (UTC)
X-FDA: 85211628264.26.ED7BD89
Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	by imf05.hostedemail.com (Postfix) with ESMTP id 80748100009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:03:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RaQSvdUN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789373010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PgULmz9i2Qwcri2yHYDZqepvUuzd3K1cSL90kcD0hpk=;
	b=NQamqq9H6ZXwCQXGcOLDJWxFPqet3+H5AouTMqGI0keU/ADr+UVF8isafGPQJjMkELokKF
	FZTHEVvjUCgMYAM7t80NkZYNQ67XOk2C86VpSo7WKiZzKV8HsqECQIFHA2IpKSitvWBIhh
	dueKUiJPCi3sPmpF1yj//YKUVaQ0Odo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789373010;
	b=iExgM0/v45iI9VX9YyJ28wKqOJzwlA00cgzvV93dZkRE54L2sXa3Rz3kFTVA8WrvYZw4sp
	eg1PoIeMALgRkWkyLjvPaY5c/RNlVkPxlZgKuL4aZ1+qWf0dssxP+iutzGJoYsKBdhwzVx
	f3rpKn3XgiVzxkmJt3TXSfI95uVCv1c=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RaQSvdUN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 74.125.228.76 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a9c0cd47bbso2429229a12.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 01:03:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789373009; cv=none;
        d=google.com; s=arc-20260327;
        b=HMdl3S/binczyo8W40jNCnGPe7rOZ6VaBcaRi3ozcNXFbLeboCmdbWQQAvQQbyviXl
         KBwtjZUcaStbMd5dFVvS9RmDjW1UOFgY/W2avVg8QleFunYY76Mgc/FFBKpUH2+fsyqk
         e1dW8mC/Bh7nSX+r2OvVIZrSSR15njGYP8hmECzfCJivYX7w4DctMgTbu83kHTWajMy+
         gwVGRK7O+MmOmy/VuypPEIuz2nHQ6GB5fdcSXtzbKHLjWb3Xy0LK9uEbnU+KQ5JRhRvf
         agGp49OjJJrcke04dV+Eq+ubhUj1hdU1ZuhrMGQMLqwrxiiV3STtKg3Bko+Xu+vcD79R
         e3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PgULmz9i2Qwcri2yHYDZqepvUuzd3K1cSL90kcD0hpk=;
        fh=4y2VCicNH/Z8/ds5Pzr0bDDVObP4tJi2nl+VRd1+W1I=;
        b=TFF7FlIOj1nDRFhV79FlD+ZQqN4HRsgza1eybcFOW4iGOfshrFBWT9EORgENniPBK/
         mHBXTkA6WyKLpkJySDCuSpNzdYzk1XTp8nIooYW8X7NoSGfJZEntp6JzjtKt+zEjPP3N
         asingrlNYMOh7Ctidotxemb1JfJk299c8P/YkJ0pfOmdQVqcN9UYqXDhIUm8ZXRob+7C
         pDx1OpQlOXYaQKe8yaENB87VNGHXzYhu6JGguHkfy2cvjChrP1wqFiGg3wjvwYavOpxZ
         PqV7I6mxJovRwYI1P6Egee94P8IsT7kFKuM1PUB6RriYAyi7kI3EPrfLmAIz/+ayYgy3
         b7Fg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789373009; x=1789977809; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PgULmz9i2Qwcri2yHYDZqepvUuzd3K1cSL90kcD0hpk=;
        b=RaQSvdUNIOWcsjMGZImHGSksH/eAnC755cKc2uOSa/ea6d/CGlejhVbKVFDri4hK2s
         DBW7D56+KEQ6pEdPv6ATTDvGnyAeGjU7hOJZXhw6i7sOFqtZpnmilwN20Hwef3GOcSOU
         +a3fUQUSBNkj6tj3BTPljc5HRCzvcTU2bk42/PksuAWQeWI74KRBsruPjqzQeguiM/e8
         hPLoZFKNbXjMIQn2X+w2lndN0m1AKdsPboWJda/HRLG7ml4+XaeecBRAnGuhx1JD6ODy
         qy8ikXhLkjbJ1z9MCS+W1/aD539e8H/p63DeXPulPAdHnKjCQuC9xLGpdHWNmyezONZb
         Guvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789373009; x=1789977809;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PgULmz9i2Qwcri2yHYDZqepvUuzd3K1cSL90kcD0hpk=;
        b=TnMHAnH9o1472f5RrcUQxE2ZtM1xvJrc7tY//7dDRpwY9+x82NWLxq3pIxqEjg6AvK
         npyDSY/1N+lFKfjxok4+zGfa39ijDJOpAiu4tK8LJJbCqW6VeShziv9G2Gr5ICL4PWrI
         MXq1qyog3fA2soPfAL4TpjjjNBjxYUQIlgxmIsFsU18IM6lpIF9O0LnTw5m/2TYjNKoA
         5loj5YqPQPz+IfuOp16yp9px3887YijM/Vf3a2yUyj+RRatab6kwScEyusgwcOHWyZFG
         4u48e4ap9oCijaBb56czDBEXyer1jDk6OF7YBjCS7YgPEpQrC+CXVm/1vfF4B6MHfmhz
         TR1w==
X-Forwarded-Encrypted: i=1; AKwUvBxMN1CW9/bPpPEYVJfu4W3ZQqBh7orPIahZo8BWYXlT8D2RR29iDVDQaZouuVa1SPNMRMNDf+Zh+A==@kvack.org
X-Gm-Message-State: AFuF++lgPgkKGhwSpn+Gq4YC8IhQ4vJKpjiZH57oJ8lKyCeLbujzZAXi
	V33l7QHdKVP7NlkVn7GxkHRD16vlirfupS/3DOoNpOioKmz7K47+NGCWshcg+uWVTRt5TcvyeE9
	PtCDt1glnpPuW8hUCy31RnAYuoRoxTjw=
X-Gm-Gg: AYBFou3qXo6koUIL57bleH1NE89oNTAQEtzcRDPWoDNZiERPy3qtdMXEfBp/1V4TfU3
	UbwcPIB/aSJWtINGP7yIYO5Q+XawWr8CNXW/VrIaDS+5XJlmRqfk2TOiaDMOWo93KgwNOg9Z6ii
	JJNQYEth1MJAkZJcgGtfzcLUAC8kcn9lUCNUMIlVElhjVQ/lmcDBLZBkhN70VZH4MxbJzKm8+k3
	HOTSbuZGGg0NG/t9TOdrmks/3+alz1wmFqb/ZoIi83nsQWukkg1a0MgL1OfIg0s3JB5U8mSYcaE
	E3PRjerJ81VlPbHJVGHEyGRKWdydUOxr0qe0wicYRLTYMFZRzdOFGaWjVNA5XF3g1p7mPTrRJM0
	o+VtplTsJ8To7ZL2eHAUKgvF5
X-Received: by 2002:a17:907:1c09:b0:c29:61b9:7b3b with SMTP id
 a640c23a62f3a-c29b8798ddcmr75929166b.49.1789373008506; Mon, 14 Sep 2026
 01:03:28 -0700 (PDT)
MIME-Version: 1.0
References: <20260911092012.92399-1-alex@ghiti.fr> <20260911092012.92399-2-alex@ghiti.fr>
In-Reply-To: <20260911092012.92399-2-alex@ghiti.fr>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 14 Sep 2026 16:02:52 +0800
X-Gm-Features: AcwNN1XvVdcGmFCu1YfSgAuFunR0wpVdzybQilaaiJVxZ7W1LpJIzbod2cFjOcs
Message-ID: <CAMgjq7DwWYNrmqsvEGYkSepwnFLcqHpiyRJJRyKLCBnByvS+=w@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] mm: swap: move LRU insertion out of the swap cache allocator
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kunwu Chan <kunwu.chan@gmail.com>, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 80748100009
X-Stat-Signature: nqdsdouyjwfu31jyukkjxo9pxbyy4feb
X-HE-Tag: 1789373010-2466
X-HE-Meta: U2FsdGVkX18xBzPMpUu0oigjYGsTxj2+59fcwd6pQ2WDSghdLDjHJ6Bf/2a70+Ps/wterDjM0En1KLkxEeyFj8+cuDTTNwq4i9KzeGBThv5sLUKAXGbYvbE3sGtlvewwRE8Py5nm3tokX58dBvXaURfjDbmyHzN2c+24A+6r1ldfzztL8B8M10FXSOs6Y+vX5C76a3MNUCxXJoq8mtY0R/ucsj1/pVFNAtxCJSilKE2ir9GrCQwc/m3wp3GPcmLeNN2FQDgrhtvFU7uuCuN6U57r2nEOM/Gnv2gQ/pzAUaanayRoaLwTvvwUY3GA/3jEMbQIPtnIdGTSpyeItG7pmm2uf/jgxIhWbVbqpH8XhjA4rF8qqzcp0Hd5BJWgXIWYfzJPYkypKu4b4tpVOukxmgPCkxd1agAv12RJW3U8QhkIO3T1kUlGKCiutiRTOTX7YSxvfo7wrE1E5iPEgCc0/HhuYTHRf7W29G+2SQ3H3G/ahn1YyniOU4aGA7zQ26Eo0xJqBfrM590L/Oe8tw9FYABH9rMhi3SxphL6nzySZNyeTFyFjiolWpJiZ2KuxXifRvnrgpONRaGksQ8zX7JeRZNurMQNePi6RziYhnv4dsc96XtMg8hoW4+CGgDIBZJ4ojDWcbZmJb8igrQZwpmiEOF+q3dHBC2/eoOXZerCiNCEuzOiD4fgCE0q4gZlVNwLo67YLS4dFf0jAdSIz14Qccf1J3h8E0Mm1Sue9VPbe0N04gXoRyneS9p2VqZsFHDlbKt/lBaHucjk5Zi7VariTCNvHPlU9HhhgoscgDV7x/TKxkadSFBwDNOcDcqo5AsQJkW2Ym/PSXt/ZShz8YCy+erVenSH0pJSrmbd6vBBjVopXddaV17QLLxaLlWj5hnVoQJ4wl+8CAZec2wDUfdz+PDutUqgMbP/7jYxExQA5dxbTVJ6DNJUTGhwRnHf6GT668Zqg/1ySSWrYwSlmDo
 bAyahYqK
 8kc+lfu17+zm3fgbrFk6MdQXybhWJUpwSbGch9pMsASrRXsGUtQkRsClKfepCzS82jqqctgVL/TWKXzthVjPUgQMIsMr7J8oR2Y9ewIvIffC3E7+D7FsMcnmJHMMa3qaKNe6+ENHaDB4IwZVdspex9lzY34zxtbRbHNroQDkDxrclG/AAWzPkyC+0ayITE5pcQph5JP00pbSn81XOxet5MyVRQiNK//nC4dFUWjIKICNR9zIhvd+GuGHKNpbruV1/l0MOBQp6m+LZOWJ4lR3l5coYXYas3fIdqO13ufuHw+RZBdne5aqdY/pmgoEBzutKb98i4vUDgwVESExMZIyhbhQHoA9/V5OWW1DmbBcHZbhwAoP2bkmolvf23z2vHA8X5nOMLj61oUbe1PZbYEjD+GMPLx0v6xJjZt6cYepLryXVxcKvHhf09fKvR91B7FIL4teE8OBtGnRICEzdEepprFrGZeAzvaBu99wKw9KnoeYaabWONXiWDxfNjVXhveBBV2l/T0iK7SpktZU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 5:47=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> This is a preparatory patch.
>
> __swap_cache_alloc_folio() adds the new folio to the LRU itself, which

I think you mean:
"swap_cache_alloc_folio() adds the new folio to the LRU itself"

__swap_cache_alloc_folio is the new name you introduced in this patch.

> leaves its callers no way to act on the folio before it becomes visible
> to reclaim.  Two users need exactly that:
>
>  - moving the refault evaluation out of the swap cache folio allocation
>    requires it to happen before folio_add_lru(): that consumes PG_active
>    to file the folio on the inactive or the active list, and under MGLRU
>    it also reads PG_workingset to pick the generation.  Setting either
>    flag afterwards does not move the folio;
>
>  - zswap writeback dropbehind needs the buffer folio to stay off the LRU
>    entirely, as the per-CPU LRU batch would hold a reference on it and
>    keep remove_mapping() from freeing it once writeback completes.
>
> Defer the LRU insertion to the callers of __swap_cache_alloc_folio():

And you defer the LRU insertion and and rename the helper.

> each of them adds the folio right after the allocation, so there is no
> functional change intended.
>
> Suggested-by: Kairui Song <kasong@tencent.com>
> Reviewed-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap.h       |  6 +++---
>  mm/swap_state.c | 20 ++++++++++++--------
>  mm/swapfile.c   |  2 +-
>  mm/zswap.c      |  5 +++--
>  4 files changed, 19 insertions(+), 14 deletions(-)

Everything else looks good.

Reviewed-by: Kairui Song <kasong@tencent.com>

