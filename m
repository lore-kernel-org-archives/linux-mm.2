Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4926D606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Ot+uCYWT
Received: by kanga.kvack.org (Postfix)
	id CE61F6B05B1; Thu,  5 Nov 2026 12:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97976B05B2; Thu,  5 Nov 2026 12:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85736B05B3; Thu,  5 Nov 2026 12:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2096B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:47:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 254BF40BFE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:47:14 +0000 (UTC)
X-FDA: 85401796788.21.21A0298
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 35E601C000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:47:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ot+uCYWT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793900832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7CVsHNeSf8tfZg5LWh+qjeeCQrrxtUufcT7wYfpMs4=;
	b=f/FX9EirMVHtkHDGGDhDPozOnFfPBjpBF28/ZzfmXSflsvC/ycX4NzE0sHsB/zMZXaCTRK
	0FHbZqGle0lOy5W82MOZZDISC5QSfuqnjUzsajToNBrRrDO0DpShSVAyqkT7LjG+w6vYjl
	98A4F0A+dYEur5nmX7NhS8Q3WhSOcMw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793900832;
	b=zfAPrbQkxpkHcvKyyFmtOwqLIxzrQwRXk9IDVNHkd7kCqahVz09SoU7JJbUyoS9fJWmWUG
	NQEFRvXdsk3MaCqRZbatJY9nwieGfOmHK67zBrDI8V51q9hZHkJku92nR6qeVP8RfinLtD
	d6DOj7w+1D6od7PpX71pFNM5CVGHiGo=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Ot+uCYWT;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a20d7a8984so56925e9.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 09:47:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793900831; cv=none;
        d=google.com; s=arc-20260327;
        b=P3ciRwnSQd5B8/OHY3GD6iZk9etMdRWmsqITs9WQl0dvXSjaGDMDJ5V2RFHIWTCOJI
         q9igL7qTEGPkYyDZsJmeLiVDnZftzh8Uaf0l69bR6wFJLfRBxwDMZM8JP2pzC6zbWSHU
         dFqYVeIMAVn2VO7ztGNT3zIN67e3G53dL9gXk43qL0OZyZYvKzWtn0BcqZZhikREf8y9
         LGMVSP83YUnEfYScKz4klaXn+LOu6AEfiiRdl1+IbEMemG01YiOYCMSODM6mCJEmFUcm
         f2wmqd0WeWSeTh9O8gzI15G1vOjkyPIZfGmOxOLnAbkfQ5hf2SUpe1CGlwQo8k1moN9F
         paJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t7CVsHNeSf8tfZg5LWh+qjeeCQrrxtUufcT7wYfpMs4=;
        fh=rAv7HOZ+ygsqFakmxyDPqHRFtm8g7KpHVprFn31+aPw=;
        b=hgyutg2BtHH9KRZO6j31FHk0i+tuZ7gMQ0p2wvjt81t5tTYqVtePJyr+95t3GpDAa/
         JY5kea0sQa5a2YNHwBKymInmivpGQPOL79o3bw2Q+92ofFyxlqo47Y8SoBjJhuWMkts0
         3dsIMthgvJLLYD2jmkwzB92ZsYzZkd5oKxhjEoGeP/gte79x83/V6IgN6F9UDNCxcXbc
         GkRJeoMoLoS/d5+4xEJauRQnCfzHTlY4U9V7FYMSqGPRLs8V48lWPh8i7QnAn9SjE21s
         jtnatf22I722/xoQ/x75sfibSEs2dpq0jHxBYZRBkaU5RFJF/U/WGYNKkFpKIQg7hI3e
         kQRQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793900831; x=1794505631; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t7CVsHNeSf8tfZg5LWh+qjeeCQrrxtUufcT7wYfpMs4=;
        b=Ot+uCYWTAIP2RWAseGj2zM9xroYTXYkSnWVfpVxaKxr9M3q8D67Pg08a4XnjSWJnjF
         Gx4QnrVEAtOhCrNjl61k5BF+50uUMZWlqb779I7NqQGhmFMLELiZAmRzFephSXziQCgv
         v5XT7JCf9sDVHo26ZpLeEYUF1DKaVTbpy7GqGIBNf+E+Vs3uzEPkf8TxTwM8rdTMpIs8
         J6AGLwkha4pHru7ThksFD8KMEGiCutn6GKIMMvzFQ+CYB4jSbWdYyy9LeuxcqVAs43AN
         ZgJ6z2J6g1iIcpQIJnWsq/Ej5rC07o2teo+5pi6j5fSM/RS0VjYpnPD34f6s23ImK0Qs
         wq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793900831; x=1794505631;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t7CVsHNeSf8tfZg5LWh+qjeeCQrrxtUufcT7wYfpMs4=;
        b=ehcuIO1E8Qmvx3soCVN98R9v2HMNa6SbqOoT56Wi4cFtLjm7nFWjsImF9cLB5xy4Ug
         h7xuorr9Fx2qsFyJulkX2zBtKg8XdknnQbTlJz1PDlic4jojtAkpzZ91QkQKqRAPBhv8
         PpiP4IFC4rs6gIcQ2YiFMwmz0TJg6F7OmQoNe5peFTAHuSH7+L7lIt3WEVsJBbheu+oJ
         ij3iUIuqftTjrw41o/TbW+KXTR3CvtcV5UUIz9h4PtC0SRtf4plCzDMki590KcJyGs//
         52hxxYVIiNrwJ46FvNHJY9Znk2f6tGCOH5a9/++5YCD0oByCzzffygVpOFkHgSnvFKNJ
         GojA==
X-Forwarded-Encrypted: i=1; AKwUvByxQJFx/PQXl4SSDB1T03eYiE1rvRFLSNsH2R8AXmbtGlSr2pjjVwG3DB47CeJblRooANePMRstLA==@kvack.org
X-Gm-Message-State: APuU4Z9GVxbaZ0LMgybY0WpABR8RZFMliO+k+Wu8KWL8OM8cGQ8R9h6T
	A7ADMx+QSRmjoNls3JK/Xq0xly8JRUijxKXJcRhi7f5K2X5p0Y2uCThs4sJlg4p8kT1ahfzZjdy
	kopws/uBegt+Yo6psDeADWygja0L+uNFzIUK+Nt8C
X-Gm-Gg: AYBFou3n8pbeU6rkP701AZkz51WYHJdYOtxfJsRFXQItIueJlFcQ60fcOoMJNgwjf4b
	aRrCygWkcpigBjm/iGXwest1th3y2tcIkysrrn3YeIuYlmN+XR0+s2Oa9Cck00X/2lhzWNhS0Du
	745GCHhJi9bvRZsiM1S6LAKtR78QaEx6E9+3YDpQO0rG2lnlp86rI8J4GD5QCemsfFrRgJS8DBv
	Lw68WJcJs16U93+kaMDo9su6AUi0whq0a3qWXvB1cOi8l5CnHKk8lxFP0aZR+7LVs3Qoqkigq5r
	gx8Zx7+WR5Hdi/kH8lNkjWFSkLTEYHVdAIxpFzeb0nJ48rN3FfOva0nDWduPIWMVApt03shNoEu
	k0keFYgH8Bejo0M8N76Ki6wN7CC3iM/zK6gXDx0eVSByc8CYLiiJcl8OhWp0iojoDafZw
X-Received: by 2002:a05:600d:4441:20b0:4a1:98b1:1de9 with SMTP id
 5b1f17b1804b1-4b59672bca5mr659135e9.13.1793900830268; Thu, 05 Nov 2026
 09:47:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105020324.2011790-1-mkbund@amazon.com>
In-Reply-To: <20261105020324.2011790-1-mkbund@amazon.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 5 Nov 2026 09:46:58 -0800
X-Gm-Features: AclHuK_j4wCRIwrIm4OfRctJi3UAwMmRbwXOunnldIs9qbpBDveUjPWb7R2WdPY
Message-ID: <CACw3F50bfsm0pZoEYL=y_9yiQ2XEQTjCE=496D-=MJbRnXGhQQ@mail.gmail.com>
Subject: Re: [PATCH] mm/hugetlb: add htlb_dissolve vmstat event
To: Mark Bundschuh <mkbund@amazon.com>
Cc: akpm@linux-foundation.org, muchun.song@linux.dev, osalvador@suse.de, 
	david@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9by1o43bani1cidgdbujupd9sh3gr91c
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 35E601C000A
X-HE-Tag: 1793900832-474652
X-HE-Meta: U2FsdGVkX1+knTy9dMA+dsAOola9pJcvs5TFgcrpj/kuYNHmDOn8SEqbvItGJZ7Hz3AU3KfAjksFEixuFKT2LC7k2HtaPsDNMZCKhKZOO/pqYEktD26TjOxDaWolEhPBGVxpLRu8pT2k4Qmhpql91/h6Z1wco+rjr7NsrR0HGr056B/DjyTq9flKgPoD/hSZlc8uqDfvL123Dcv2DFfmvnwLMASBNwJdpi5AqIf71GHj8hJaSpJAyqPWNv3SE4xFxq+EvvVQamdcct9WrTBmZ65LCNiEnmMuWkTxGmHsH/MgiaJjDbproulgWgjErHly41TK0O9Xv/VDChedpNAe+A2xz+k6hVxkYhutmcE2VSO3PW1mrD4g30sZtLJj5nPzPmqwRs4kNKsYeHbe1wAwogYosZhzfUJs5PZHaf8AGsSawVvFTpPhF2v62c5vi4m2lVnLoBpYBp+7pgZYQBE39TXx1OGKdWbUwtaZSM8PGd5HBmb5wygiz8Yy2OOdfz6vcDfIRmsckP1aMOp1mD/CUmEf1K5lgMF6EkuczMp5B7Qf6RBLxQq6KtpKhCtPKHR4s1AIcC3WHS+hG/aKdOVOaxawAwca3mofn/Ba0Fw8Qs8Pa6b2pPcoco76LFMNWdDonUJcFPHhvprv4PgALOtoKweF5eajZBE8chqc22GfnAj0ErywWjn7/XgUCI+DfjrEOo/+sRnYCEACcV+oLeLAQ12+CfMGI78gOxHRAmGhqXNCUiEQsPzckHSh9VtMBq77pVlBqUejieCNIsP6fdbU2L3E4r8jm3Jw2+ORinS9p387mXrKxNRzAXnfqLMwa9s/5B3A7hvgskBTkuj5igzxEQQhX641/RuKAb4asNoXsEbeF0W2hY1JaN9rixB3v7wzD8mFXcBCWu/QAcTg0qDCC3WVpcS3O/NHjG6ALxCq/gn0KAXVC2VHK2OB3tRaL2T2zecC87eIedIzL7yw+mm
 R9r/mHhP
 iqDQ3rkfr1KTuBjtVAdNokjkkzo5xboWugAVbaVbDGdWK87WfIR8v54Ylb0soalfto4FwSGL5KB3uyIFMc4xTwJFidn2C5JZxJBfcjrV5+eNdw8GIibMzBWrdWL8iX/u1EE9FbAezDfKnMMYMWr9uSAviZdA3/U6aFvP4CKOXwdADJJT4Mfv4KLCG7DieiK/2L1gY5cISFThebPgbvIsxZkSGl2dfDZCL0piFg+6HTh0yFSFB2rsihZfAX++hAQ0+f+diLt5s8uWXWnP7eVQePRYXMjuFSAfUGnTGCEIR3ztdtg7UmDOMjvPvFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 6:03=E2=80=AFPM Mark Bundschuh <mkbund@amazon.com> w=
rote:
>
> Memory offline and memory failure handling dissolve free hugetlb folios
> and lower nr_hugepages. Nothing records this, so when the pool shrinks
> it is hard to tell whether that or a write to nr_hugepages caused it.
>
> Add an htlb_dissolve event, counted for each folio that
> dissolve_free_hugetlb_folio() frees.
>
> Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
> ---
>  include/linux/vm_event_item.h | 1 +
>  mm/hugetlb.c                  | 1 +
>  mm/vmstat.c                   | 1 +
>  3 files changed, 3 insertions(+)
>
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.=
h
> index 2628ccda076a..822fe862e5b3 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -71,6 +71,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>  #endif
>  #ifdef CONFIG_HUGETLB_PAGE
>                 HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
> +               HTLB_DISSOLVE,
>  #endif
>  #ifdef CONFIG_CMA
>                 CMA_ALLOC_SUCCESS,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da5d04edf7c1..7c79523b2a3c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2047,6 +2047,7 @@ int dissolve_free_hugetlb_folio(struct folio *folio=
)
>                 }
>
>                 update_and_free_hugetlb_folio(h, folio, false);
> +               count_vm_event(HTLB_DISSOLVE);

What if update_and_free_hugetlb_folio() failed / bailed out?

>                 return rc;
>         }
>  out:
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index a3e809c57f29..6282eef7074a 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1397,6 +1397,7 @@ const char * const vmstat_text[] =3D {
>  #ifdef CONFIG_HUGETLB_PAGE
>         [I(HTLB_BUDDY_PGALLOC)]                 =3D "htlb_buddy_alloc_suc=
cess",
>         [I(HTLB_BUDDY_PGALLOC_FAIL)]            =3D "htlb_buddy_alloc_fai=
l",
> +       [I(HTLB_DISSOLVE)]                      =3D "htlb_dissolve",
>  #endif
>  #ifdef CONFIG_CMA
>         [I(CMA_ALLOC_SUCCESS)]                  =3D "cma_alloc_success",
>
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> --
> 2.50.1
>
>

