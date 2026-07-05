Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4EFC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 17:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 130C96B00A0; Sun,  5 Jul 2026 13:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E18F6B00A1; Sun,  5 Jul 2026 13:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB6E6B00A2; Sun,  5 Jul 2026 13:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2DA26B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 13:58:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29ED1C06C1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:50 +0000 (UTC)
X-FDA: 84955483620.16.8B5B435
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3476280003
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 17:58:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NlcASEN3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783274328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KGgWauQAkj2SDmk4deqkuvHV3S2v6YDLgT1EvMcqLdA=;
	b=xpW7lIu5bCz4Z0bSBzNhDmalxxsYD0qQE4aByyMpqaH+bJUHUZ6s9tz18XCUHX/Q+VH2Sg
	u/WMX2JzpxmXsllFyHbYTrn/Xrks7e0ZTOm2D22Kzr0/7pjpq2XqIzrlgHlGHQeepEhsgX
	KQKdNWCQa4wak26DvZmXGQgZB5TcKEA=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=NlcASEN3;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783274328;
	b=f+4GNFeoxwtA3AU49Klsr0sfy/oQy5wOGo3Pe+bpt7osYgg5+uohWtf9f4fF0ryy0ot0H+
	3sqJHCPdYREjt8U0M0ltV/8sfyFzoLYxvGnldKRq7gCevwcWQzIBJkScuwrq9QTMNFnRlm
	Sf8+54QdfbYMv3UIZCx8e0Pd8IRFRnE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493c556ada3so140835e9.0
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 10:58:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783274327; cv=none;
        d=google.com; s=arc-20260327;
        b=Rzavi367X4QS8HrcNxpsLP+rWIVRjA/+pRFIP1nXh9sISF1eHqjyxgUtijaUiEJvKJ
         T7A4Vzj0ndgdHTIsB2TGR9pa+ziguKc0exaMF54Et6b6ohT7NZoTeO6M/10RMZekHbCC
         AUkbB6uNJg3FaH6Kd90YVCSjmADrCE5UQSitPssRSBhQGunARt8qXOW70DEVq9ePMRgb
         qNhzBYokNVNriuBPjJo4PSnDuUIWEeXSCypHegruOJXnscoOkP4Aa8YoGAzpqGvi4CyD
         VfGs6p79BHrtOWHLTzZT++f0A2wCVixfG7OQIt0LzZLQKvTUTCKNf5dhGqlF09tPuAcX
         eXQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KGgWauQAkj2SDmk4deqkuvHV3S2v6YDLgT1EvMcqLdA=;
        fh=jGZ39YVQ5zJ5JQg/9Xaf7BvdInWa93Dm9AoaPH9kQWk=;
        b=Ebzn+cThd99XKgIGzQzZ0kgwRkO4xVz3wdHhkZDIW1JklAXtKavBe6a6cfXy1Hmrnl
         EQvZetn8BnwNiMdeN+Q6GdkDh6TkW4f38FmXmMeJn9YB+/8GK49JvoPyqiUCYFm3A0u2
         +vdYajXUjACrYkiYGNAkWC3tqhQVlvvPaUV60vwUKKIjJTL8JBNGijOr8VUSUCLsNtYG
         q7FQ+DSOQ6UT+5DcFEzbUdMgO8USFp4E6KjmXYhlg+N5vNWz196kiN0Y0lOEiJVFszn8
         Uaw8yAhduFCHLbdo+hLKh5pZkOWowWHfAAPbJvjQwusu6DRuk08xW7iK1Dg3QdCX82q6
         KixA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783274327; x=1783879127; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KGgWauQAkj2SDmk4deqkuvHV3S2v6YDLgT1EvMcqLdA=;
        b=NlcASEN3vNxlX4RvXo179s9QvJr8vyu10UrnVZmMO0yqiUiWLCeIg6e3rNkVZ4BQ3q
         nTDchVl2j1u6ZEP87UwahEDs6PcKFvAMidm0xUTHpEkSnamZ91xchsdLpYvO2YiF3Ac3
         TcL4JKylyKOjAa3SN18UHLYh7kaweD246Ja5MWeQuRPvz7AywPNawU5oyQkhtlmn0bek
         bTkNr3ivmGKAnGRKpnjvG2Ohj8K1DwtXKEOsYa4F88gk5x7AZl0DdMqBeDOaGJKoqmVF
         RJKdu/B9S1NAWpFbX2UzJBpa4zH+ONkCdxPRNC+CGIBdY1fDNH+m7qIG6Zn/WwKCtq+t
         S0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783274327; x=1783879127;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KGgWauQAkj2SDmk4deqkuvHV3S2v6YDLgT1EvMcqLdA=;
        b=fk0gVi2KRf6lqYb/txQfBrbOdcv34vv+wo5RyUc26FMSvOOVZZWuNZDXor6riFQ4er
         G8ZQEkAxmJFrTg81KL4ZoQQTDJ5c/gkr7mBA3oIR1PNweF48m+MDfayEkPtbwRbU85sW
         mnDkz7jkeBykNpgedJH1DPSOB2In+rhgQfp1l2PC3XxT0q38IoYHcHCViJ6pe8Tsh/Pk
         NBLcinRTMqP6d9lYPBFTbtYOIRq3qfADzgZC/92i0DG1/86ezG+Rbb6jnqbhStLiYJFO
         mOzVaITMF7rCV6SwycpVEp81gWLfwnJFv7JYqNO5axS/PYuNWM9rOvB4fWyrAyxE11Hr
         8DLQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq/HlEbBBnaRn/cFw11qTzpalW5F0KyAcOUjGW0Rq10MOk9+5W9aJ9Z/1EWl1/n4o3hiXf0KNxT/A==@kvack.org
X-Gm-Message-State: AOJu0YzTidXz0mbNQg9WFb+UPeBWQ7b/ogvtSAMi6mnleTyOINiNIp2d
	17xV6VcwXgEUh6/kgLmIXgKqbhMmy925EN2oYRnT4A8JuL5JOnQBWvgP94Bni6ApRWZE0eA2iW0
	1f2P3D7a3TiQctY3n+Ngh0OEbT20fU/ZewNf8xf3w
X-Gm-Gg: AfdE7cmScjgoEalIIzkHfhhKhR5WlY09DNyxkImpDTi4A6NFIPYFEQgQGXGBruE7jBa
	NP4pLL59bfmvHUKgsZUb2qWfR9IjZdOQT4C6UMLMf2VsHCgDr+7c66KD5xLL7Sx3H9Nj7lwvfXw
	iVLBBDdeEATJwWEpc2ZaiTNo2qveSfHi7k34OB5TnWR/60lR+3ivEeVUl6EGtIdo+MAOIuu0wM3
	gb8RzVMYcZAYD2HiNkMQyPJvHBccE0LTqrXOnRu18QMOA1xdpqxiSw0SLSqvuhlxr+uT6RXODDv
	EGx4MDpFKvMlPrqPv8lgtlCm4MxwfyteVUrGytuC
X-Received: by 2002:a05:600c:63d6:b0:493:be38:fa5a with SMTP id
 5b1f17b1804b1-493d5068c86mr900855e9.10.1783274326487; Sun, 05 Jul 2026
 10:58:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com> <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com> <5942d4d2-5719-4196-af49-b35cf5f7b88d@kernel.org>
 <CACw3F51GgF1CQ=hU2E50cnKUkDdc3zyS4in9QGCog1oY3-BSqw@mail.gmail.com> <dd603d35-a435-413c-bb5a-0a9d2b0367fe@kernel.org>
In-Reply-To: <dd603d35-a435-413c-bb5a-0a9d2b0367fe@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 5 Jul 2026 10:58:33 -0700
X-Gm-Features: AVVi8CenWiJ3DgL2m4IH2Qj-dnpR_fR4EEunUw1IMD8fsgQQP2U2JM_5Wv8UI9k
Message-ID: <CACw3F518_LnncNsVM6w5y8siX9t1k-sbrAwjLnrOCdUxFPzxLg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: osalvador@suse.de, Miaohe Lin <linmiaohe@huawei.com>, lorenzo.stoakes@oracle.com, 
	jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
	david@kernel.org, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ljs@kernel.org, osalvador@kernel.org, 
	willy@infradead.org, Zi Yan <ziy@nvidia.com>, harry.yoo@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3476280003
X-Stat-Signature: 7pdxj3fppcer6ffchewax9a9mmfjw6bx
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783274328-722630
X-HE-Meta: U2FsdGVkX1/tfjBVIDHvxjfrm9cEyeSaXAKcaxEl7GgCnDAnDGIUH+u3UKL+4RfUBk/9Da5Z0dab3E7pYpi2litV65IwEf/5zOQ+W6BD2kjRW+D/7ilUloHPXF4BdzTgNgCIWBaI6gqCH9N7nWSi6muWQFc5ziW8iDgBu9aNKUIwGengm/MeY+EAnO+45098LIziMEzLZEipyG5nQnanw0PoWW9DZt2A7ibA1k/8UIufyMNx8oYZjou7f5NLd082k7l5an+qKo17k0dew7EBeGx/LNeIVVR32QEDEcrikyH6eJKOph3yA9dUVa+pVNS3FESNFFVPpuif9ictcLIxzcy7X3pZY9FmkrH1OLpYazvwPKCQbGfWlpGe+OtaPO9yhxtWtzQKcHe4BUkccwwCeAoMW12vWo0AYuv/wjpxMcKptk4Ki0q0SFF/hhKsGYVgUDr7v4ryNiXRAS8NTRAAjYJR60JHAQZ3QCySySHDc1Kd4sW/TzE3OgSe3lWVowL2b99W9hC1HIYOSVqb/ujxqwDgYH0hLQsavK60tmIAPVpZRsDBFoJC4cSw7VisooGgznZ13e0EuwpHl9cVgFJbSmCDqzsrz5fz/I8wbURAUNkNEO+0Lpj6pjjt7CeqMEXGwJ52+Z6seMuunMVHVkXFlyOWzzi6fWs6U20+3g1SgCo1UAKUP4+Fmw2F50qYOep1+thhMD3/IoCVhriANX+DXYOIJKaZqMFcdRTnDoPPmb7pGRWn4NrDHXpBoVJdZeYu+rU6ADUjIMSuJvqGXJDmyKLwXPf9QBEbSsgNxScRDoJxLJwAGNCSFbYXpC/YZY/QrRKRxY1ER0o2+bKH8lEmx0uGCxwNQN5oEI8xH4Cx0a0SaWZR2PKXBIL4aqWf2GBotlWA3OlcpKroSMxDT04lRp/4ETYiBncydgOr1NsXbU80nb6DKgxBkOVL29JC+3K7kzUPqADQYfnz2HFRDTh
 63ACL2RK
 2Wiova3Wori9f6ykIxLi3kxliebik43x+XE6TV8DhxsujNIlnnvcK1+8nbx69mv7A2xYRRMyLh3AJNKtGtc3gG/Pig/FcXaIg6x+G/wUCfjlGRE9DBmDsIP22iLlLUQ/u7ACzySnFzetU7dRnK3F5OoUgsg/+rQhgGnGQp11mgVli1PArCyk33ENlwTeOkz91SJ4NHV/po64n+zJl0+92/rzwwXLxVnOd5Sc8DvsorspBCNnNSo9nWl3iHAXqv6N64Nc6b+UHtisPq/ZP/KE2r5P8xvrxEpE0Iska3ALqY0wOmn2Efmi+23zed37S57DtkvYacmHbtjcxgd69Dfl3/MlRJ1LK8sprUgST2aOGWC1KyGnC5QUKrOP9jHrHr85DFvMc678Sx0MJbUjFiHSUXwcjR6QzgNz5xmYp73repsQzJ0YJVmbMq7cq+L41NMJwYbxXt37Fcq/a+V1NJKwYQFbr1eLbMzvwT11ro3Xx1P3Z/GEpt7PUi9GlpDtvP8D2BJ1FnqHxzRRyFnwiuI9bxPrasCWgjL9C5WE5ulq24kI6M9E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 1:30=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/22/26 03:12, Jiaqi Yan wrote:
> > On Thu, Jun 18, 2026 at 8:02=E2=80=AFAM Vlastimil Babka (SUSE)
> > <vbabka@kernel.org> wrote:
> >>
> >> On 6/16/26 08:53, Miaohe Lin wrote:
> >> > On 2026/6/16 11:23, Jiaqi Yan wrote:
> >> >> On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wr=
ote:
> >> >>>
> >> >>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
> >> >>>
> >> >>>> On 2026/5/31 13:58, Jiaqi Yan wrote:
> >> >>>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB foli=
o
> >> >>>>> becomes non-HugeTLB, and it is released to buddy allocator
> >> >>>>> as a high-order folio, e.g. a folio that contains 262144 pages
> >> >>>>> if the folio was a 1G HugeTLB hugepage.
> >> >>>>>
> >> >>>>> This is problematic if the HugeTLB hugepage contained HWPoison
> >> >>>>> subpages. In that case, since buddy allocator does not check
> >> >>>>> HWPoison for non-zero-order folio, the raw HWPoison page can
> >> >>>>> be given out with its buddy page and be re-used by either
> >> >>>>> kernel or userspace.
> >> >>>>>
> >> >>>>> Memory failure recovery (MFR) in kernel does attempt to take
> >> >>>>> raw HWPoison page off buddy allocator after
> >> >>>>> dissolve_free_hugetlb_folio(). However, there is always a time
> >> >>>>> window between dissolve_free_hugetlb_folio() frees a HWPoison
> >> >>>>> high-order folio to buddy allocator and MFR takes HWPoison
> >> >>>>> raw page off buddy allocator.
> >> >>>>>
> >> >>>>> Another similar situation is when a transparent huge page (THP)
> >> >>>>> runs into memory failure but splitting failed. Such THP will
> >> >>>>> eventually be released to buddy allocator when owning userspace
> >> >>>>> processes are gone, but with certain subpages having HWPoison.
> >> >>>>>
> >> >>>>> One obvious way to avoid both problems is to add page sanity
> >> >>>>> checks in page allocate or free path. However, it is against
> >> >>>>> the past efforts to reduce sanity check overhead [1,2,3].
> >> >>>>>
> >> >>>>> Introduce free_has_hwpoisoned() to only free the healthy pages
> >> >>>>> and to exclude the HWPoison ones in the high-order folio.
> >> >>>>> The idea is to iterate through the sub-pages of the folio to
> >> >>>>> identify contiguous ranges of healthy pages.
> >> >>>>>
> >> >>>>> free_has_hwpoisoned() is added in free_pages_prepare() as
> >> >>>>> a shortcut and is only invoked if PG_has_hwpoisoned indicates
> >> >>>>> HWPoison page exists and after checks and preparations in
> >> >>>>> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> >> >>>>> can re-use free_prepared_contig_range() [4] to decompose healthy
> >> >>>>> ranges into the largest possible chunks of different orders.
> >> >>>>> Every chunk meets the requirements to be freed via free_one_page=
().
> >> >>>>>
> >> >>>>> free_has_hwpoisoned() has linear time complexity wrt the number
> >> >>>>> of pages in the folio. While the power-of-two decomposition
> >> >>>>> ensures that the number of calls to the buddy allocator is
> >> >>>>> logarithmic for each contiguous healthy range, the mandatory
> >> >>>>> linear scan of pages to identify PageHWPoison() defines the
> >> >>>>> overall time complexity. For a 1G hugepage having 8 HWPoison
> >> >>>>> pages, free_has_hwpoisoned() takes around 1ms on average on
> >> >>>>> a system having 56 Intel Skylake physical cores. This is
> >> >>>>> 15x to the case of freeing no HWPoison page. The cost is far
> >> >>>>> from triggering soft lockup, and fair for handling exceptional
> >> >>>>> hardware memory errors.
> >> >>>>>
> >> >>>>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send=
-email-mgorman@techsingularity.net
> >> >>>>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send=
-email-mgorman@techsingularity.net
> >> >>>>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@su=
se.cz
> >> >>>>> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.a=
njum@arm.com
> >> >>>>>
> >> >>>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >> >>>>
> >> >>>> Thanks for your update. This patch looks good to me while some co=
mments below.
> >> >>>>
> >> >>>>> ---
> >> >>>>>  mm/page_alloc.c | 85 ++++++++++++++++++++++++++++++++++++++++++=
+++++++
> >> >>>>>  1 file changed, 85 insertions(+)
> >> >>>>>
> >> >>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> >>>>> index e47679e7a9db..03df929abca6 100644
> >> >>>>> --- a/mm/page_alloc.c
> >> >>>>> +++ b/mm/page_alloc.c
> >> >>>>> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP=
_BOOT_MASK;
> >> >>>>>  unsigned int pageblock_order __read_mostly;
> >> >>>>>  #endif
> >> >>>>>
> >> >>>>> +static void free_has_hwpoisoned(struct page *page, unsigned int=
 order);
> >> >>>>>  static void __free_pages_ok(struct page *page, unsigned int ord=
er,
> >> >>>>>                          fpi_t fpi_flags);
> >> >>>>>  static void reserve_highatomic_pageblock(struct page *page, int=
 order,
> >> >>>>> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(=
struct alloc_tag *tag, unsigned int nr)
> >> >>>>>
> >> >>>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >> >>>>>
> >> >>>>> +/*
> >> >>>>> + * Returns
> >> >>>>> + * - true: checks and preparations all good, caller can proceed=
 freeing.
> >> >>>>> + * - false: do not proceed freeing for one of the following rea=
sons:
> >> >>>>> + *   1. Some check failed so it is not safe to proceed freeing.
> >> >>>>> + *   2. A compound page has some HWPoison pages. The healthy pa=
ges
> >> >>>>> + *      are already safely freed, and the HWPoison ones isolate=
d.
> >> >>>>> + */
> >> >>>>>  static __always_inline bool __free_pages_prepare(struct page *p=
age,
> >> >>>>>              unsigned int order, fpi_t fpi_flags)
> >> >>>>>  {
> >> >>>>> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_=
prepare(struct page *page,
> >> >>>>>      bool init =3D want_init_on_free();
> >> >>>>>      bool compound =3D PageCompound(page);
> >> >>>>>      struct folio *folio =3D page_folio(page);
> >> >>>>> +    /*
> >> >>>>> +     * When dealing with compound page, PG_has_hwpoisoned is cl=
eared
> >> >>>>> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
> >> >>>>> +     *
> >> >>>>> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_=
SECOND.
> >> >>>>> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is=
_bad() will
> >> >>>>> +     * confuse and complaint that the first tail page is still =
active.
> >> >>>>> +     */
> >> >>>>> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(f=
olio);
> >> >>>>>
> >> >>>>>      if (fpi_flags & FPI_PREPARED)
> >> >>>>>              return true;
> >> >>>>> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_=
prepare(struct page *page,
> >> >>>>>
> >> >>>>>      debug_pagealloc_unmap_pages(page, 1 << order);
> >> >>>>>
> >> >>>>> +    /*
> >> >>>>> +     * After breaking down compound page and dealing with page =
metadata
> >> >>>>> +     * (e.g. page owner and page alloc tags), take a shortcut i=
f this
> >> >>>>> +     * was a compound page containing certain HWPoison subpages=
.
> >> >>>>> +     */
> >> >>>>> +    if (should_fhh) {
> >> >>>>> +            free_has_hwpoisoned(page, order);
> >> >>>>> +            return false;
> >> >>>>> +    }
> >> >>>>
> >> >>>> When the code reaches here, the hwpoisoned pages have passed thro=
ugh kernel_poison_pages,
> >> >>>> kasan_poison_pages, kernel_init_pages, arch_free_page... These fu=
nctions might write to
> >> >>>> the hwpoisoned pages. Is it safe to do so?
> >> >>>
> >> >>> At least, kernel_poison_pages() writes to the page. It probably sh=
ould be
> >> >>> moved up, somewhere like above kernel_poison_pages().
> >> >>
> >> >> Writing to HWPoison pages (location having memory error) is usually
> >> >> safe, as in it doesn't cause a machine check exception. Memory
> >> >
> >> > In x86, set_mce_nospec is called for hwpoisoned pages. So writing to
> >> > HWPoison pages would cause unexpected page fault in kernel?
> >> >
> >> > Thanks.
> >>
> >> Seems we'll have to extract everything between kernel_poison_pages() a=
nd
> >> debug_pagealloc_unmap_pages() to a function, don't call it when should=
_fhh
> >> is true and instead call it in free_has_hwpoisoned() on pages that are=
 not
> >> HWPoison? I think it's acceptable to do it there one page at a time in=
 order
> >
> > Let's say I extract everything between kernel_poison_pages() and
> > debug_pagealloc_unmap_pages() into __free_pages_sanitize(page, order).
> > How about adding an extra bool to let __free_prepared_contig_range()
> > to do __free_pages_sanitize() for a block of pages?
>
> Sure, let's see how it will look like.
>
> > This doesn't really matter to kernel_poison_pages() and
> > clear_highpages_kasan_tagged() because they deal with pages one by
> > one. However, it seems more efficient for kasan_poison() and
> > debug_pagealloc_unmap_pages().
> >
> > BTW, I wonder whether I should carry over the fpi_t flags from
> > __free_pages_prepare() into free_has_hwpoisoned() and
> > __free_prepared_contig_range()? Right now the intended code paths to
> > get to __free_pages_prepare() all just have FPI_NONE, e.g.
> > free_frozen_pages() and free_unref_folios(). So I didn't complicate
> > things further.
>
> If it helps, why not. Maybe have a new fpi_t flag instead of a new bool t=
hen?

Yeah, thanks for the good idea! It is done in v6 that I just sent out.

>
> >> not to complicate things as most of that stuff is debug-only and we're
> >> handling a rare event.
>

