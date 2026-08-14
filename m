Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2AF3C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 18:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CEA36B06FB; Fri, 14 Aug 2026 14:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E1F6B06FD; Fri, 14 Aug 2026 14:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D106B06FE; Fri, 14 Aug 2026 14:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 39F616B06FB
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 14:06:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31253A021B
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:06:09 +0000 (UTC)
X-FDA: 85100654058.15.5E67D25
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4523D20006
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 18:06:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Po8COkfe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786730767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
	b=prLY8l+MmDl8xq/rZygEsKYWOQkBdeMxR1KL8i7H6hRCNU6hqv4TL2KHTcIlElLG7rzN0w
	NsqeF+T2MDVrgzGi4FPBD9NkMozQIVAur82qbjs3j2or425l/DCAqDvvMNLDKKKutoVYrQ
	XMMki/AtgHCD8Z6SAWwGDS/v67Uvl6U=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Po8COkfe;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf31.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786730767;
	b=iabzH3XtDDZVlv4OwmSy/OQsbVmnkYwLqjBP1G/bxhQSoXeFG1mLIbbn5K7by4qjEzGQML
	1oql+lIB08w8izVUy/4+tHBOyetY5YrREAeC7u9CzQ9Qa3/ImH+bFqUxNo3n+ffanuBRy1
	FPLP6nBja1Awz1d2P0vBp2zCiAkVqkc=
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1670dad7a8so219375666b.3
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 11:06:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786730766; cv=none;
        d=google.com; s=arc-20260327;
        b=qinq49n4sq5Vxa7NboFYQ5Qv9g9s54OM/u8g8fw7oakc8d929EptnHkB8VSmByn/Ws
         odGCN+hWXVStEwBdCwuwhNNGA174fQ0eQvBC+jwDhp+yMV0MyEa/iwlT+bo5rCC/Xidw
         AHBSRlOqfU8VfxjL0g/9xv5GiCLP3rBouz246QjaX9/WDbuVUXL1vQyzkXpfKy4bEHdm
         A40FOp8KkuQdF7rQPUen0P8/reCpKQwzniebflrpk8ihEi8DPk5KZ3Jj2yZfcOjNGYoe
         y8kfO3SjFRA9gvaVuzQOMt5FOwmJ8macOjhZaXCULfHg5XF4886YZPzVlkrSEnpKlTIm
         n4kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        fh=iR4cXIiEYCdF3LD5LDxAS+1EYwBkFML5wOTgOEO0CUw=;
        b=GFPwie/eJCFCNASsRL3eP10F4fHS6LOtC9L392WF5O6uJKZFtDuvXhwAT+puXOdJVs
         Y1rRk0k76oO1ZsuF7TK2IP0pwgbB7Oz0gjyo69qw65Xoo+y1gC4j/qKBLyxozBx9+G5T
         CTZFMHyQ3xk/s6bFkJFRRGAo31QgFpOziKx7b7c1vQM/+rX98PHNVx6UdHENds6KlJDT
         TY4xTkxPrhvZXSKaJr+0UBKYkgs1/z2plx6BchCYAbAADjyz4W/WXqav46Q8soCXTTiT
         HcFgnRlrn/Uo54KRblDMPd7xT/2AEAaEF6yrY4xVTq0BDfwWZZmi9tpraDLpbtSta3k9
         pQSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786730766; x=1787335566; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        b=Po8COkfeZChHYJN20/yDY1TxHCzvoyfUn5mWliKxDdnY6A3pkuB9Nt4pjPwOJaHT/y
         F3ErE9K78CieEATTJ411wQz0b4mxZEuGraUFs7144/O1Npb4M/rQNvqkXof53FN6vN6u
         DCB0t83HnLCxFtfj28TRUGYlnnoVH0UcEq8ha4cK5bPqvs1huhwdMGnOGVuLIck3jGLw
         rMzURNl2zaFvCPP97tAS1oCd7XX1Mss6yiv9mnB1ep7PappXBZ452oQLH8WebFsmvCic
         zFeERM82C8nW3jhOk4zhqSGCqG9e+u9ltZKl1CFQFLB9P9T2odMbI8V7zM/pzc+5pM3s
         pnXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786730766; x=1787335566;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zm4Hmz4cnln8QUqQ6YrVjCpF/yuLG0D7za0RMRiIjkY=;
        b=ittS4PShtLTta5mdeIjGLP8kHJiy0Nz2mn1QErM/m1ejZQZnh22kmMOyBrQ0WbDj+H
         FcrsIRsiUkqwGmShMkD75m45pzSlsJUV6VoxqVS9gLmpHHzstNT/YIi/PdYXdJyzGs/R
         VyPnRw1TqqtuqsFSVZrUEUkM+Rz99K7eFoAa0h833+/UsgcXoHjy2pHkwx4O24uRKMgN
         EiWEFJDEyooKu+NuxRTUiUyoyP30bnn3DwayCJOmdHpdeRIxgoRc8kneIHj8HmINlhvx
         6/Lk7mcCcKck06iheql4g1ei/Bs68tNN5e8mnymEyul45iSS72nDTMIPdYEjFO/QDP2U
         4ilQ==
X-Gm-Message-State: AOJu0Ywd8pFESuD+YZPugiKXJD48StUKzrgn6qc1EvfTCo66CslpMnVP
	YNKmOR/r83p+z6pA9XTGGoTt7jdZJnP9O7+haPb+Mmg3Fl9kCB/6S5Gx2M/FFRy/ItDx8/rnH9W
	B3O+6eqeqsIOlqWuetA8bamEjFg0Ij24=
X-Gm-Gg: AR+sD12toiER47A9UgzOJWocrWo1j52B1ovHaRFr5C0YRL8TB8Iq+3qtSl2Xf0azZch
	C2lg/rFVMdJKmJik9XMHIGs8n9ug1HAmJGrG5JRbmXRQM2x3CjOaez0SJ/Vh+iDqhHqBBwBXS+3
	fXzbSNo9pHh8vuL/ThSvQ5DN9CTEoFSaL9iz6vVFk9fvqIIn1kQ3hFHOxYmtlPx3Sc/cLb4YtaW
	IM2sByufvTwBCFuxJD7z9xGW4LV6LS94Lsp6WOuYzFoyztnwte60z3WcNaAuIvNwCr9b5LbDdaK
	eZcL0s37t6yy6O4OI0d6CeWfUIlFZNivD3y2JEYWXy1viGaJ6S7XxNv6V/H3ovr/FRHXTCk5Q5v
	KlA==
X-Received: by 2002:a17:907:c02:b0:c1f:c061:569a with SMTP id
 a640c23a62f3a-c2129b5b0fbmr346098166b.7.1786730765397; Fri, 14 Aug 2026
 11:06:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com>
 <20260804-mglru-fg-v1-9-4d8dad39dad6@tencent.com> <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
In-Reply-To: <CAGsJ_4zVhK9SvHEd+OFAHSu-OgTiAtk-ZU5OQVx5RwBYmc9r7w@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 15 Aug 2026 02:05:28 +0800
X-Gm-Features: AcwNN1WIkKuwTmt7PEJzah-_70R5p92KJ_QmRackAHM_2sCEQfB9h1jocetz118
Message-ID: <CAMgjq7DupViQ_MbZCMRSb_Bw57C+Lcg2fFnpaJ1xsjftzYHUSA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 4523D20006
X-Rspamd-Server: rspam07
X-Stat-Signature: jpw1gsrdbs8zc93pcbemw6a1sw3fkmdm
X-HE-Tag: 1786730767-26077
X-HE-Meta: U2FsdGVkX1/z0N9QLcI9WrGdyOGPJ5NRw5bb+Y96I9P3LflRxvze2svDyKyaVL+qtxSJEtCp2NL68QaDhNfKNWy6513wWpWOWQksOvcogwqPamspQP7MacGbDXW1IYKqgTo5kZmI3qeC74hW/Egws/6vIOFKyTkI4X/rYeP17faOs4w1pa91deMoRy6OXpkVs22/Jy/ZOSRnvhFeljKISwaHMBC5nwrtEWeCz+7lntaw2LRbP5V3Gb4y0PlklFE2u9W7ynybsSrdeheUPH8x8UjIXKL4gMOrkDMQw+CjZT1Atbhr5/+1MhQ9Q9T21sEhPfiba9nPlAozqAb1HLwfrVRuHYGFMbf5i+RSYmal97h8V7pPzvBLahFvOV82a/NPbZQpoEk2NNjVfBn2x2sMeYkQxq+HHC/5eTUdLzI8nq56A2rMKl27L1+pdowf7EaLLjK03jZl86ZKd2PoZ5fvuarwLCY24oUllpuCVYrKTG22nqRXqUKmcJRKh89y8tOMqPTZOa1fT/DvwC+kBO1GGw0pmMl4Ab3cLYWNNXC5eSF1AE66h5zoxVlfNxM2CIShPH+8gDIgkghUztuTzpLm4LCed70UyJgdgELM28Phb9BkNdj8QDWeBkHQAgSf2Tz4ZFaXggezYHEWvwKBV9CjR17RO1786QstBm3becwmo4Ry7YcE/dATonnnO4Hmin/3ID+qTNhvgBYMjZM97sifimPzfEl3P6jLsT3Fptyjc6madox7Ru3tCwdia3eHj25YVbX3rCNG6ORl/QjDhf4Ex69YcBKUMyNWHkrwyEIY+Y2xjQ1k31errfwcjlbOtz9zH+T7XOSST88iQJv0CzFIY75X0ID4j8cmyUEDq/ld7FCUcAbv/CGXybRA+DvOmUIHRTg88onDmyvcFEHYLiKhwkFIvTs+uD1p9vuzyYwa9tHoUE7cxhYZwrTg1fhHHjH2VQLAYXiVgT1kIXWDZyF
 cbaK8kN/
 ZQ0PUsA7wUZDCTLHb+yyuY416wvrbL4kr7hp5L1BRGmdsBJuZLNSqjJT/40kAI0jse7wathZkUClkOn/GEtKLD6Ccux7Y/Kb/rPFPtKZ2jNqQ1LEQNJE+88yAJUZMucV0NIv+om0J6OyKVL4QbymDK7TRGRFHOyXPHXgUA2vmr/7deqyZzYSc4YqzqqHj3P/UPUM58EGf3rWsnMl6of/PDyAh4ChK6nyZXfSdyFCwTVSJNczmZPF8StUxKwraAXgCwJBQMyy7MLDr+8GdFFchjeMjvKxN2t/k013PvUPZ0WA7u2BI7sp2679s7ogbuG4ZLG8Vw5lrQINdit+0j3ou5wJeAY6MQ7hlOuE1og/jXUNKwPHZsAP/RPYXeAaVBIHAjB+yOTdJupOtD8N6rGOa9euPv2nofjUUxeuOQmDf2o28iqcy0k2L96A3cTywYqxaOkIP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 14, 2026 at 3:19=E2=80=AFPM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Aug 4, 2026 at 3:47=E2=80=AFAM Kairui Song via B4 Relay
> <devnull+kasong.tencent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Complement MGLRU's eviction-time tier-PID protection with access-time
> > frequency-guided promotion.  Introduce a unified set of helpers built b=
ased
> > on referenced (access) count of a folio.
> >
> > Each access increments a folio's referenced count stored in folio flags
> > (refs), refs still mappes to a logarithmic tier just like before, but w=
ith
> > more formal bit definitions, a few special thresholds are introduced:
> > LRU_REFS_REFERENCED (1), LRU_REFS_WORKINGSET (2), LRU_REFS_PROTECTED (3=
),
> > and LRU_REFS_MAX(7). When it reaches certain threshold, the folio is
> > promoted proactively instead of wait for the PID controller to kick in.
> >
> > Also simplify MGLRU's usage of PG_workingset and PG_referenced, now
> > these 2 flags are purely used as the lower 2 bit of refs for MGLRU. Thi=
s
> > doesn't effect classical LRU in any way. This will actually simplify an=
d
> > make MGLRU's certain metric reading more accurate, and reduced MGLRU's
> > original tier / referenced count bit by one since only one extra bit is
> > now needed to record a max referenced count of 7 (previously 2 extra bi=
ts
> > are needed). This changes make sense because MGLRU doesn't have demotio=
n
> > so these 2 flags are never separately useful for MGLRU.
> >
> > This addresses several shortcomings of the old model:
> [...]
>
> > + * Update the folio's lru refs indicator without taking the folio lock=
,
> > + * isolation, or lruvec lock. Used by both page table access (@is_faul=
t=3Dtrue)
> > + * and by file access (@is_fault=3Dfalse).
> > + */
> > +int folio_inc_lru_refs(struct folio *folio, bool is_fault, bool is_exe=
c)
> > +{
>
>
> This is really hard to follow, especially with call sites like:
>
> folio_inc_lru_refs(folio, true, false);
> folio_inc_lru_refs(folio, false, false);
>
> The reader needs to remember what the first true and the second
> false represent, which makes the call sites quite opaque.
>
> Could we have something like this instead?
>
> #define LRU_REFS_FAULT BIT(0)
> #define LRU_REFS_EXEC BIT(1)
>
> folio_inc_lru_refs(folio, LRU_REFS_FAULT);
> folio_inc_lru_refs(folio, 0);
> folio_inc_lru_refs(folio, LRU_REFS_EXEC);
> folio_inc_lru_refs(folio, LRU_REFS_EXEC | LRU_REFS_FAULT);

Thanks very much for the review and suggestion!

Good idea, but to distinguish from macros like LRU_REFS_PROTECTED and
LRU_REFS_WORKINGSET, which are special referenced count number, maybe
LRU_REF_EXEC and LRU_REF_FAULT? BTW we have macros like
FOLIOREF_RECLAIM_CLEAN, FOLIOREF_KEEP, and folio_referenced, etc.,
which are commonly used already, that's one main hint behind the name
choice here.

