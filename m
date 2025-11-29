Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BAF8D116EA
	for <linux-mm@archiver.kernel.org>; Sat, 29 Nov 2025 00:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471CA6B0022; Fri, 28 Nov 2025 19:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4235F6B0023; Fri, 28 Nov 2025 19:34:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311196B0027; Fri, 28 Nov 2025 19:34:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D84D6B0022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 19:34:20 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D99C513B947
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:34:19 +0000 (UTC)
X-FDA: 84161773038.21.5544F0C
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 371E2C0014
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 00:34:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SC0ZTCJn;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764376458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0LIoMkm8VlNObboFBdEcs3weDam3kwF5HK+sgGgvZ4U=;
	b=X3wZ/QAp2H7ER/Hz/wDcTBFoihMjQhGuLSN2EJG0koN9JrNXUk3ixml5ynLmm/Nh1vVGAc
	lhg6Ia21Ws1G/o+n6+1JdDTqQpIdeA8S0OBirhrfo9ABCe50e52nT07dR1x7QXQWBcJOSM
	RlU4UhGJ8CxWc8uoXmRxBtpOmqgnc6U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764376458; a=rsa-sha256;
	cv=none;
	b=cE8Fjb9wQcbTqenfTuPL0sCRgcWKJBEtSHh2E9iusgBQCzQzUiYm0Zg7LFvXq1Yb23wgV1
	JawAr5GfG0DFE6gpC9PkpY8KNEWvH2g1Z300XFmYNR6d9+ZGu0WQemizaDK+A291pK7hOG
	hxbYbT3dmwxC/u79kysrW22FVvQhOJ0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SC0ZTCJn;
	spf=pass (imf10.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b2dcdde65bso324944085a.0
        for <linux-mm@kvack.org>; Fri, 28 Nov 2025 16:34:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764376457; x=1764981257; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0LIoMkm8VlNObboFBdEcs3weDam3kwF5HK+sgGgvZ4U=;
        b=SC0ZTCJn3kJRP0a08OdzPFP6A6RXtRxkvTx7UCk/1E1KC67LiRXovj+VaImS1SqTuv
         BYWo87B3MKmlW2MvP8uWBEJmPXy7Rtr88i6LL9tEFY1lbqzqZM4EzCXOX/HWPYo3a2tw
         mVsDRce3/SMgoanfWohVBT7iq2i8T5IZbiZYxVBoMUEkHF06xACm2Rr7Iub+ReYckaZF
         IvAb5t6f+V3eI+LGTiYwZU8lSITCDE+bVER/fqRSp+GlCLZUokNfmmCeaqwTmJFYt64I
         OTI5SR3vaDvddpDo4n+rAI6pEdyyYcqgiKCmxgeKyUB3d9iFX6xcJQS8BZO62a+665cx
         Z5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764376457; x=1764981257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0LIoMkm8VlNObboFBdEcs3weDam3kwF5HK+sgGgvZ4U=;
        b=oV7Kw3XfIQr5LDtNUbpApSTEq1juI7eikBxWL+5gWC5NrSttyca5F0QAGuQpTmOeVJ
         dJHGj9svd1TskbL4nsvlMGBbBZ75oUQHVUYtPUZ4eRcLisUMpOk+QheAMgyrDrsU58eP
         oXPBWSdmnU38ZYoNDeTKDVnIrROJnfbzpsZLQ1DOEnHzD+SZiVUyy7+2xZmLpOlnDX7h
         l9LHFG8STT80h1+gs/k4EoTJvk1PFAiuq2YK2ex/sVQbJRYqD8Zj/Zb6M2vdO9UlTiOO
         /DosZJkJjlt5skVNfMw52X0FE+oEUGyr9aOlEUXD8+/z2MD8oGsAGcWm2lhiD2iO8i0Z
         cNiw==
X-Forwarded-Encrypted: i=1; AJvYcCUTHe/vyhRLF6Klg5CHVBbFvsVpekZ12cT+RWVdKF3zUSW4x2NKoyzSYrLiOHiDhI82JIZhaAAGaQ==@kvack.org
X-Gm-Message-State: AOJu0Yz8dbjD5HX6enzlf/KLILXaP1mWhZUpKJJW3uIuF8stO0pRuuOa
	3C0FnNoYmI62H3kssh56DsmKPhd4NlarWtR6qNoAcNmP4B1iE/D4NB+N7pZeBMzcVDQu2WDXoW/
	taLfTTC348AjarXQxlhFJW1Ukz92vV5EjeJ2kqX4=
X-Gm-Gg: ASbGncsOuoIzpMScAjgjrvjacwd6tNHLKEt1v+52ptSZTD0LQXDhmUILDkAtQ62qoRH
	1JebJdjtRwC7sGCploGo+ASQ34hbxiKsrIwZEcPgFMXWj9/NH0KGxYKZB1dD1ofV2c+alajU715
	PvwnFH/L5NdRAOmhkMm5ray9qHBlh1o3T36lRRT2ZLIiRsd4TkoCUmt4VT5V1bQLAfSamAR3UG4
	gkTAF4prgF+Ezd4TqmKz//Bhe9dmSAUOdHQGut852ysAgp/KcZ1Umkn9PQvSn03UAtByw==
X-Google-Smtp-Source: AGHT+IEbUPZDvnyNglI2OWwgsuu+vyYqCq79PWwMFoEQUdoukJlE4Lt8HmKth1H6eHeP0lj+ow5ncWaYCAkBHb4Lsuc=
X-Received: by 2002:a05:620a:470b:b0:8b2:5649:25ef with SMTP id
 af79cd13be357-8b4ebd6f9a8mr2259431885a.21.1764376457167; Fri, 28 Nov 2025
 16:34:17 -0800 (PST)
MIME-Version: 1.0
References: <cover.1764297987.git.zhanghongru@xiaomi.com> <37a6c6c35e029c3429f236d5895c898140d991eb.1764297987.git.zhanghongru@xiaomi.com>
In-Reply-To: <37a6c6c35e029c3429f236d5895c898140d991eb.1764297987.git.zhanghongru@xiaomi.com>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 29 Nov 2025 08:34:05 +0800
X-Gm-Features: AWmQ_bkfbqokitJitenFR-9cRpY-w671GN7adMcziPGloKczpfaF3VCVdqIWYCo
Message-ID: <CAGsJ_4wB-H0+gLgzHBU_AB6DYLd3MbByKgjK51SP6ukR4DksMQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/page_alloc: add per-migratetype counts to buddy allocator
To: Hongru Zhang <zhanghongru06@gmail.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, david@kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	Hongru Zhang <zhanghongru@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 6dcc3whmyzjpfsm77hx77zgi788eoyf3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 371E2C0014
X-HE-Tag: 1764376458-835335
X-HE-Meta: U2FsdGVkX19PSrUgur/akcYWUARkKyMfBEV7fLVwLpyl3a2I5Kc7Vt/ZYtwKCzswggrAtwFwyLq/J71pcBXMY2P9czE6JEXhOgT3GiAN6gcGZI/O1AbaR4RjCAqJCJCY3bHA0uqLKZZqiqY5nPxqasiut1GGfTKj+jtPUroeusoeRKILOkWlcDNe+etV7D2kVKYwBlI1x0bU6F8a2aWnNk0TdFINcNEovu6NAV51NRjUATY+O3q740aunWXllRoilX9TIu5EdRc71bsu6EFGOl2r6/tkpEFw8fhJ7AfJ/LfAETcl6Vp09OyjHfpGgFFL3LD8zw4Y/YW6vgd8+WUUvG7kdg198huec8kHNpDr5TpXbBrbqVTY3etbMf81xIL0Wl/fAc78wJpjORiUx7GVaIP+gbQcaORIdTjgbe71I39OagzLPhtdx6ZwDIXh0mhaiMa/czHXR9fjvr9GP549SaL3oHf3euEjMrW8bAfkjieJS60JVMObepsGaqA1IsdNTTooZ3Hn+WGiC1/oWkl0Y01nGdtUGIzJaYy5bFpWJMGDOf7l+opbKk7WRo0vg6s4Q72ppSHfSLYnjP5jSl3bXRdiOD2k3JsbjajucoyY202E+XFEuf1/thW+62u2alAh7lIk6vSQSKeNQpx4X1UJ8GRFwJU9ePpvZfIMIIO9O/VEby4x4GXB1gnd4L1TR3263GfSobaych/wU8/O7IAxU9o9mHdQCmAQ1ohkzYviOX0KEhxGWJQuGvEVtBupisQfd8dIg4fzNhqXyh92p/ecPReSUAavElpzK7GtFwvUrao+c5fdoeLbS/PLGWx6vZZMa9vf/J3+xcgVWRDPIvhZQ7NkvERikPJVWGb/tanwQiDCzoS7m3h60ONgx0xZx2sm6s2TudGfRlQpDAOwlTko9c+lUtWx8QlgYOPArEnspdHF0eiX5CxPkpATMyM7SBWH1Ow70ROutb+EXS75o5Y
 KCOuQrdc
 xitk/Avc8T4FvE2U1JLUShqk9X91FNH5Xznao9dkX14F2Fw5blHRacm6sLEaKRFosYPdcEr6zuQYiM44Zxmu5Zh23GKHXmkDYMyvg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 11:12=E2=80=AFAM Hongru Zhang <zhanghongru06@gmail.=
com> wrote:
>
[...]
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ed82ee55e66a..9431073e7255 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -818,6 +818,7 @@ static inline void __add_to_free_list(struct page *pa=
ge, struct zone *zone,
>         else
>                 list_add(&page->buddy_list, &area->free_list[migratetype]=
);
>         area->nr_free++;
> +       area->mt_nr_free[migratetype]++;
>
>         if (order >=3D pageblock_order && !is_migrate_isolate(migratetype=
))
>                 __mod_zone_page_state(zone, NR_FREE_PAGES_BLOCKS, nr_page=
s);
> @@ -840,6 +841,8 @@ static inline void move_to_free_list(struct page *pag=
e, struct zone *zone,
>                      get_pageblock_migratetype(page), old_mt, nr_pages);
>
>         list_move_tail(&page->buddy_list, &area->free_list[new_mt]);
> +       area->mt_nr_free[old_mt]--;
> +       area->mt_nr_free[new_mt]++;

The overhead comes from effectively counting twice. Have we checked whether
the readers of area->nr_free are on a hot path? If not, we might just drop
nr_free and compute the sum each time.

Buddyinfo and compaction do not seem to be on a hot path ?

Thanks
Barry

