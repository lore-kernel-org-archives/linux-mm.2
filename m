Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68617C5B572
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 00:13:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 122116B032A; Fri, 14 Aug 2026 20:13:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D34B6B032E; Fri, 14 Aug 2026 20:13:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2B0C6B032F; Fri, 14 Aug 2026 20:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BBFF06B032A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 20:13:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F3831601ED
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:13:35 +0000 (UTC)
X-FDA: 85101579990.13.78E1FD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 717504000B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:13:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqRaavVT;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786752813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9jvOz7gLQ+ALLm0WYnHzgNDgyhzkJGjXvSYPB3mG6sY=;
	b=P/91VJQTBgiPKD7DzOPWXuVSuahq/sovYOYisCl/VOFGphGxQPFscYlIeWfFiItHEt4jfS
	+NgpHFSE44tg8FZIO2dhsbS4zSqG64VEDZ3XyTAjyBk1zAG8iizTI0bziKlWfGfsuWPNmr
	hE31FyFI8uGqB8OMHBwaCBqJGyQYw50=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786752813;
	b=fRtWtVEQQXhGVT/ecMlukCcEeNapD4RGJ6Amf7wA6CD6dS4ECLJLfWXOIl7ETG6Xk1FKfL
	uJvoNDurqJh6rlEuCzYTF9YqpBQrx8r/HMO/HiJMYdRXMkyHBhNRvfHoTmzG5g1E7bCga8
	Y4NXTudm1TliPcZgV+9SI3o3E1M63kc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OqRaavVT;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BDD244F55
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:13:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C2C1F000E9
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 00:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786752812;
	bh=9jvOz7gLQ+ALLm0WYnHzgNDgyhzkJGjXvSYPB3mG6sY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OqRaavVTLTB6+pGlpaFtF1hKxM337GE1EmRZ0uz7SQlcMizjiUiwEmluGlnzCYPaB
	 CXC6X30Iwpc/MqwC32lGpUkvZoSONrkU8jW3OkSrqh2x4SJdGH7zSsdfPpHg1GjQve
	 i9L/OvZ7UjtniNQxXLnqvcsuQ8sdSlcIX7t4KgwQgV6w2khlfJQiNfzD6YCgwYpIqx
	 uWaklQmv3jiK0nxz8ohKram8wI3hq7+4RDtpZQc4+c8LwJjMG+G35OlMXWZY8bzDKZ
	 tSpWxaeIJO4GbVKKT5BKKwMYfB9ZX8FS38sontxXwwEndImmdQ7ZkC1DB9bjsdU1lW
	 C0JXgK4qKHI4w==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e7c6ec9dbso79156385a.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 17:13:32 -0700 (PDT)
X-Gm-Message-State: AOJu0YyWCzzFGKb6FsjChSSFQTCMPbL0/RA38A7kGxS0RZ9iKLgHz1+t
	Je262sEFkZ3Pr3B2DDaGsbRBWitVOn01ly7MdRkr8duFb4lulylaI0MjVscOUJ0ph7SJ2G+Pf0Z
	NfrnGLge50v5a6Ti+nkQO2trwYdQ+Chc=
X-Received: by 2002:a05:620a:26ca:b0:936:af34:ea68 with SMTP id
 af79cd13be357-936d2340858mr789756885a.22.1786752811745; Fri, 14 Aug 2026
 17:13:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
 <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
In-Reply-To: <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 15 Aug 2026 08:13:20 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
X-Gm-Features: AUfX_mz01S3FRaDWxpmO125End5DGeS2QEpieNwXWJUlW3ZhqthGFxzRQRVC5uM
Message-ID: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: rsfzst83m7hz9zfge8mh8rx54jc3y4pd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 717504000B
X-HE-Tag: 1786752813-386790
X-HE-Meta: U2FsdGVkX1/7n/3hP92/FgzRjiZQpHc2EaMe7lItb3Qxp26Zt3bjFCUpNjSXzU/kgrl21QuSWZvFZ7e36JZ0oO+tFF1UvlBIbASKKMdpjgSjqVJYHMoYe7UYXTCVfCm89jrHAMHHke0lHGOJIrN5ZPeKi7LFkHLj45pYlxtaVmpCVFJONNCfB5miWjdTj8nZqHjQB3REnRWDdVrSnVLSep+zl5BE0jzK5spetHeZo3EL66Ux9rFV8X2Kdfn0tKBM3aspOdxgTP+WgEftV745JrtUWkTpXEGLu29NvwiSxPsUNh2ufO22KFYsXkALamn2YhtzGb4/KQ6WHPGXfEbBm8rAO7X0jg9KkSTGCxlnkWJMLDImiyXj6qCmwBq+Q0ATAYUODsNnWQZ5w1EKltGw4LPTZjCanNQXLqHfvGm+7JSQWi855Zxo04wWZl6Wiej0VMWShU72Wf4owfPUM22ZOtuHsfdsWRNnKbdc1q5pWLT0Kfo0qv5kGItZnwUnKtfScuE451znd2eAjiZ5MuG+1Fb3EDuKdFzHtfiVCBUHNPtvEQahvkWhuqGosnhau8daQRVcP/LDo1nqFC2i+pr3wkjP41aQc91odx3avNtydNfA/cuZLvuXYVVfKdCEHj0S5Ck9W153POOvYX2H4bTOXF+Plw5OZeEhjBKPDiPCAWz8OLiK7x+SM4MMK2iPcm7RwRHV3L0ia00xRBf919294ZxI1cTb7HKapjUTig3xSwpPV7uF4alrnXkJw/kErHVXrEgrt/UJ8cthf5F1O7ot0lexfBpX5q8He4ytxzc+T2LqTe6R1RvRt+oBxhN5K7KYeuhSpmQMA+klEKgyMCMuQXirq+15ES9P8lChTy1FeXy5gkA8VYxgQbHQQGi8oFgLc3VkqiVxCfPVXd4dQnNC6TMxj0becrNfQXxnli6w001mWZ6c0jzncCtdlFZ6m6aN4cXStmOW/bPliyJVGvX
 kObIo4OA
 Z0HicHy0icUcygJMeLiw5uGA8Sdw1mwTO30xFO8fshfaf2ApjuQ54st6P7LhiW6j80mmJGldqTr3Bsbr3vDh4VCbSZ9cLBCAV+FR8ilTzhGqkv30oqHfbITr7BubzfC7mCRJoNHRgAfd7l+++YQkiWbFvzmcLgc9sW3GYV5HDsrXnMyOnlcVZqy1sC5bgKnnmX3r6hxslgcZd88HPubmy+5MeoOd/Qc3eIdf/IKubjkLpF6SVOeFySzBqZVhp7xj1qP9E0mXbH/RVWi1TJehRNoLRoFgtKFDkt9TXmjJY+LHNTUnB09nLqTo4Tkc8aiOmjd7qxhTYcRd9MIKI7dHyMNu1B+BkUg+kUytzn5djtCYWbcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 2:06=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Fri, Aug 14, 2026 at 3:19=E2=80=AFPM Barry Song <baohua@kernel.org> wr=
ote:
> >
> > On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Complement MGLRU's eviction-time tier-PID protection with access-time
> > > frequency-guided promotion.  Introduce a unified set of helpers built=
 based
> > > on referenced (access) count of a folio.
> > >
> > > Each access increments a folio's referenced count stored in folio fla=
gs
> > > (refs), refs still mappes to a logarithmic tier just like before, but=
 with
> > > more formal bit definitions, a few special thresholds are introduced:
> > > LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED =
(3),
> > > and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> > > promoted proactively instead of wait for the PID controller to kick i=
n.
> > >
> > > Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> > > these 2 flags are purely used as the lower 2 bit of refs for MGLRU. T=
his
> > > doesn't effect classical LRU in any way. This will actually simplify =
and
> > > make MGLRU's certain metric reading more accurate, and reduced MGLRU'=
s
> > > original tier / referenced count bit by one since only one extra bit =
is
> > > now needed to record a max referenced count of 7 (previously 2 extra =
bits
> > > are needed). This changes make sense because MGLRU doesn't have demot=
ion
> > > so these 2 flags are never separately useful for MGLRU.
> > >
> > > This addresses several shortcomings of the old model:
> > [...]
> >
> > > + * Update the folio's lru refs indicator without taking the folio lo=
ck,
> > > + * isolation, or lruvec lock. Used by both page table access (@is_fa=
ult=3Dtrue)
> > > + * and by file access (@is_fault=3Dfalse).
> > > + */
> > > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_e=
xec)
> > > +{
> >
> >
> > This is really hard to follow, especially with call sites like:
> >
> > folio_inc_lru_refs(folio, true, false);
> > folio_inc_lru_refs(folio, false, false);
> >
> > The reader needs to remember what the first true and the second
> > false represent, which makes the call sites quite opaque.
> >
> > Could we have something like this instead?
> >
> > #define LRU_REFS_FAULT BIT(0)
> > #define LRU_REFS_EXEC BIT(1)
> >
> > folio_inc_lru_refs(folio, LRU_REFS_FAULT);
> > folio_inc_lru_refs(folio, 0);
> > folio_inc_lru_refs(folio, LRU_REFS_EXEC);
> > folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);
>
> Thanks very much for the review and suggestion!
>
> Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
> LRU_REFS_WORKINGSET, which are special referenced count number, maybe
> LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
> FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
> which are commonly used already, that's one main hint behind the name
> choice here.

Yep, LRU_REF_FAULT and LRU_REF_EXEC sound good to me.

BTW, is FAULT really the right term here? It looks like you're
actually using it to indicate the result of PTE scanning.

In the other place, you use "promote" instead:

+static inline int folio_inc_lru_refs(struct folio *folio, bool
promote, bool is_exec)
+{
+       return 0;
+}

So perhaps LRU_REF_MAPPED  would be more appropriate?

Best Regards
Barry

