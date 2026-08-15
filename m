Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AB20C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 09:20:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C636B07B6; Sat, 15 Aug 2026 05:20:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3C2E6B07B7; Sat, 15 Aug 2026 05:20:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2AD06B07B8; Sat, 15 Aug 2026 05:20:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A84326B07B6
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:20:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4AB77A035B
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 09:20:42 +0000 (UTC)
X-FDA: 85102958724.24.06D9221
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 712801C0006
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 09:20:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C5WqwLrh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786785639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
	b=XoXCjwZ8FPRC/ZdGAKYJ9KZTHcPklBeMxQFB7L8xlYNySDs6HglpQS7et4RsXcrIrzy6Vb
	1ZcYKgpNwLzrnLhDq/qVukk3IU8KG9nDDY8gqUvsR8pGcy3y6TNpLqLes8DFcqfZwarN76
	WxzBnPORbZk8xBZJPYvGVLaeSm6KPG0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=C5WqwLrh;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786785639;
	b=SfDuftPEGGdNMV0mY4pOEzvfr4u3xspQbx0fYGiBPd1nqQQm8grgZhQUCQADqpKtpv8QfH
	R5gtnNeV4En2u8XSMEUv1mZJzSVxWjbqEP5MtfUIgs4B0rsM5Y2DgX2O+zcG/b5S1ZK6jo
	yOmda59yTpwlvmCStnBlDMMTqI48Dic=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c15e2dab83eso293695166b.1
        for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:20:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786785638; cv=none;
        d=google.com; s=arc-20260327;
        b=j2EkPv5OOCbG4SemEvv1bdcNxMQgtzkSo7XtYSDEZa5mBwVqrOeDX3t2wSXOFC6+1V
         oygMryvDWW0zXRHpH0LpcgRhFKgbPgqqEA9GWxjmT48OGfU9HUdjFqaxfy+09iyjdbke
         aMWvIRzUOq7E5ENGqNn6p8X60MxBjX9yR2pLZ+oXn0N53yq9yqbmDwVJgulAIwvWkerd
         xE6gEw0irNxAovO++JlEWY7CgmWsMo+jTh2GplJ09Ki//BcuD4AZARvq3+DZ9NdOEwLw
         HhVCRfehRmCU7wLLhG5layQ/+KdPMv9TZIb/0M0KaME6oLJkyo0pgqGRnihzuQabOfxk
         kQNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        fh=iR4cXIiEYCdF3LD5LDxAS+1EYwBkFML5wOTgOEO0CUw=;
        b=OLRYc6PjwbKey2hCAb1HiJ4lHJAMP03B4ZYtX3x6gCytqRyI1+3VUkdnSAEIV2MYix
         zddovdJe2Mrjf+oCJ0lSS4SFXdritBsGxtFDNWmvNNQ0X0jL1vMtABp36CEFrEYOFNFb
         zSGC2J71S+DmBomhgMRh/DMHcmrcl5uBmBafDw/g5jOZ+vIwLuMSNq49/R5w9drrDzhT
         KLTeHpgf0qjAFzNLVmkiU+HT6tmg1XuFABxIBfLPkfrlZTfTV9Bf2yqi2YNJ6+xWem5d
         UUuqGrmMqXAElK7FJZ4gzWtV2dSJ5Gnqsn5VHJ6olLuxKMQuMdq5o/kkvjU1ZrLJI4Av
         eGpA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786785638; x=1787390438; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        b=C5WqwLrh3ZFllYZ/bEC/OTfGjE07VYJICfkr3sDG3i9PlopThTknBesm8Fe4VR0IGT
         /LdOo7ATiDOWaSMv2AvnCAkYjdL6IATgyCSvqJimZOQ58g+duJMKkiPHkIc+5PbIo6P1
         EYh16DnpHjbCLelFRfbwLKdjR21/SSgaQPKkdgIFC11vifJMAREIi3q21diIZNCG8DbD
         PwuAafyWc27U4XLltR7mnCAPY5agVrvpjnGUmJzDLRgSk4dVjlnV1SnQKzqk0+iY8sjl
         5UkRgUp3JEO1iNjnmEEQ/Jz/0196NS+Eyl0h79xhsemBmwroeer0ViJMVBKlPt9JFkSZ
         hl4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786785638; x=1787390438;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cGIHvMdb6k99fqHGsYD8RBx3vvRhyGoxqfHlvr/UKEI=;
        b=qpz93LxayCHfgB9DJTBdH6IVSbgHSOXMk0zIDkZHo0ATveg0IUhC6o72KNl5ecGrCX
         MQ80Hgbd911G3T4a07PUBsiLSoG/UaGMRwMiSpesKazA+ljTK0Q4b107XNlBjCrvMhCt
         aTyM5VNzPGl64+GB3CZe9OjcKeXydz5r46l1U83dQGQZnUKvS6hkSU5vaw544bPbi+Z0
         L+BTOkCl1sVbzfUVAT7tLQWTbIS6Svp82WeR54aHTyhI2toICpZXRWOLio7U9qb8lr7q
         88/g4F033yiA8lfGXnS7LSxZWl2Yx6C24UKbM0f6gFpGKUEVQT2BsVpKB8aM83ERC+Ly
         NE2g==
X-Gm-Message-State: AOJu0YyiyYVeORNzhd9ywobMsN+aDvZAXaQdrCu+uG4DH2J40GBpBns5
	Jh3V2KufeJ0oWDGfDlXHHcTFL95quui3BOeOGAfzIpwO01C2MgDsJpxtXAzYgQR3+P9XKPXNbiH
	eAeD3Yj39nNH5yhkkE1AzUeZ+awXxyl0=
X-Gm-Gg: AR+sD114J0YonhItAkn3nmQbYG08zy9N/+XTV/COg1OH2uwR/xUYP9QKoF8Xkw0UdYR
	2GFjOXhyyDnc2HmHeafARK2t+CzLHCY++brbytCtdbiRYg89VxNo5gd71N1lbi75NW8hG6r+Yl9
	d7/Q/PupNrfY6VH2c50EkVmr4uo9TtpEtnPCgLV6/w53390kdO3Ljv0OUYgAjaxSnRdBMVZJdOP
	qdU4uAs2QqOPT0fVrRfyBCrQsHlYqnGJ5NVLkznGQ0/e5WMGhtESdmEheTCxpneue0dNXnmegJl
	C5rkq8FeUVkKJcQEiYvoDXcFqg+5RKw4tDI2HqahYjeZ8M83fpc4G/szUVlTrqPTum7mWqbaRDY
	EaQ==
X-Received: by 2002:a17:907:c02:b0:c1f:c061:569a with SMTP id
 a640c23a62f3a-c2129b5b0fbmr558940366b.7.1786785637644; Sat, 15 Aug 2026
 02:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
 <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com> <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
In-Reply-To: <CAGsJ_4xhxELewwy=X+K8WurSnLDzaz2kD384gt93Ha=uVpyHDA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 17:20:00 +0800
X-Gm-Features: AcwNN1UD6wlSIq4Zi3TIXvS0pqcdHhg-sYrZC--Sr_V-rOxVKiGYqZ0gVdl_kYo
Message-ID: <CAMgjq7DYpcA9Xu+NTzHk=N--CC_oPV=1Wj9ZcJRjDonZA9iqWg@mail.gmail.com>
Subject: Re: [PATCH RFC 09/15] mm/mglru: frequency guided workingset promotion (MGLRU-FG)
To: Barry Song <baohua@kernel.org>
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
X-Rspamd-Queue-Id: 712801C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: 75png4y856segrwjyefqjdpdcd8gyxtb
X-HE-Tag: 1786785639-475988
X-HE-Meta: U2FsdGVkX19JvvqL+xpwfazUddazwyS37zkIwFFZyfJdNfybcrk9SY1Z53SO4403VD/LrkbyirNgVN7s2by7LVbLgKyqlxE41xYzAl9XlcSYVOww5UCwSpJRnS5CdSYKv7ygfMMV9tojYz4UTQ4+BUpeamzQy/fnK/xX2HCJPnbOVhh2H0IzzTS5yj4yTQENPoC7ensdd3vABRLRBPGvnfWX4vLha6dUjEfnHmylXheL/7h4w4tecxzjjGEVlo3yHDRV1M4ZWdKBDzPUMrfGBDdCmAGeMCn6LSngpywdvzhWMuCruq6TPJlpaONuRY8a2gHIxvC+WqZjwfKQVGFxrAQ9Y/zSReeX/N/lG7L767/fnVSrad/A2JI6fecQYq/nDUrom7TPaH8yZ/ETcayUEE+kmtzKRKcKKYmyxs95/CrOSkrj1Djh3N/wYoezV8izHcI3w6DuwyzjkfskJcgv2t1pfg86B7IgI432LMkY7OPtZwkz2Q85RQY/oftc5w+rBJ0b2z4xg51L1TinXgIGXVRiDrFcq9lBQkoVgv0t81fdc9w0CQCRUs8Qr9jFFcCAI8HnuG5R6wDUIMfLed2ow1DV9pxMU5P77Q5Luap8hlb8ydWgWs2YtJyRrqdxR7A+TIweyfJJVxgAmVFP8wKKS9dlC7khRbYr+mw1jFRhmCEyHJfLCZaXYAMNTUKJzc6Vmi43VfnPAPHu6aG9dzjPLaMSIev1TIa5rgDGOau7gRBiqkRr0Hn82rKVJa9d3wJ+PaeJ/uVwLDJSCuePAkTkfWIfLn6ygYjDQXykcNeNZwaSoBI+jJjRN/LKpSrjlHkS/xskePArCaFK+mCdzFIrjbNdAhlMWWd8NucBW/exsQeBxLA8I2lzl4MrfPs2R8Pn5VbEx3zYo8vd9D4f24YKC/MWz7OPypKCdmosBCFruMqDnsU8JaQmoFw5VfWdUxXkzeoOwNZCVTtYwmT1bH0
 ecw9WZfV
 qVu569nQCr0P7k2qdTxDpY5q0C7XrQ1PwXIeuP2czM4MaX51RYUESbcOxSB9YOPBrD75OW6wLbLQtjjOgIRun3PBHiksoYdLYzXs0N4Wozmzpxbp5NUiRQZSSTqDiPO0SLRvx5WhH6s1oEXWW/kHtPMLXw1/BUJX0NWDlsAt4xQtzRJmOJib9k3kaNBmsLo7MKOG2AjnTgkTnjlFwLx/lIwTkuAlzbxudygw0yuOCu99gH4dydpG7AN17yhkpzgl2aq5DOJ2SP1T9VDcKTv4fSB4wVIVmavO+3OscIeV2Un9HHOw2Pn4VGY4moxC8l6xr+KQVtwPSCvlOT21UDXeYbqK2Jg0kVrfrPJhCsG/KVkzn9ydaungxXHp5yAX3aYUeNrBJxwgiwGbyAxuq5Vin3OlgRew5y4+iRZt3qWLRFu5HcAz/T2BHax7QhLV3KYAVbN56
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 8:13=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sat, Aug 15, 2026 at 2:06=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Thanks very much for the review and suggestion!
> >
> > Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
> > LRU_REFS_WORKINGSET, which are special referenced count number, maybe
> > LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
> > FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
> > which are commonly used already, that's one main hint behind the name
> > choice here.
>
> Yep, LRU_REF_FAULT and LRU_REF_EXEC sound good to me.
>
> BTW, is FAULT really the right term here? It looks like you're
> actually using it to indicate the result of PTE scanning.
>
> In the other place, you use "promote" instead:
>
> +static inline int folio_inc_lru_refs(struct folio *folio, bool
> promote, bool is_exec)
> +{
> +       return 0;
> +}
>
> So perhaps LRU_REF_MAPPED  would be more appropriate?

Sound reasonalbe, it idea behind that name is that if the folio is
evicted, that access will cause a major fault. I'm fine with both
name.

