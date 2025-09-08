Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90D2DCAC588
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 10:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E12988E000B; Mon,  8 Sep 2025 06:53:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1F98E0001; Mon,  8 Sep 2025 06:53:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB1408E000B; Mon,  8 Sep 2025 06:53:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B570B8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 06:53:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E78413C07C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:53:55 +0000 (UTC)
X-FDA: 83865772830.24.9C89601
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 67C131C0006
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:53:53 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="j/cR8YVf";
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757328833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgsaZMjtQ1nfPWVLymR5YRqCNScFdlNY/fedrrZ30qw=;
	b=oN4ABVZsRJqNGTVOkOHsXTdd4vK7BA7dXrx5DOjymXRjKp+wBt26iuzRThnce+To5WjPvA
	/x7Sq8jrXBJIa/C9joFdvZn6r3yDN2y85xeHVLEcIZC3gk6wFklDa1sf0YlP0ROt9sWh/I
	NdK+8u2bNRLFZbvrydkcLx31L++tPV0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="j/cR8YVf";
	spf=pass (imf18.hostedemail.com: domain of hughd@google.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=hughd@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757328833; a=rsa-sha256;
	cv=none;
	b=R+IgyJ/rjbOquM7/Pqost8UTEVOybuNSMpP0WOeqVXAXPyXjZRZ5QnO+8dTkuz3XIvI2SV
	bGfH6RW8iZCjAQlUQ7jUbRVpBjscJVjEGk2gJhp4IJdgZYu/Ti1oUubRojSZs2MNHH+jpL
	fAm7a0JWO9nF0GyQrC/fiLNFJp0kpws=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-723bc91d7a6so34726787b3.3
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 03:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757328832; x=1757933632; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hgsaZMjtQ1nfPWVLymR5YRqCNScFdlNY/fedrrZ30qw=;
        b=j/cR8YVfh6aZcBEE5NzR4rkDkIdUcRqFveuSOCynMwrUXKjZvv4GfGfYGi9thF7417
         UFya9W6z0B6T3zRj33qQbmBuVNwmUeixsIadZHM6X4ihpigApDJyZM+Y4LkPGaKtRh/5
         xRO1m4ln2bC2H+3g0uXIxZgxRnGQRxzp0EG6MFhC4CET57Yw71ZrNm/NT6O2Tjmul5mI
         RDSfdCOrIP9jEuVk2/5Wzj2h3nx0Mpe+g0CAgrBeVurBAehoEtrr1yPZtq9V41cpFkzX
         FRFtQEKhlrCIDTD0yZZUh4UnGHLZ3eAuxwNG7Kmm/J5YeFvGkrZwbcXQ7msR9O46xSDl
         lAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757328832; x=1757933632;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hgsaZMjtQ1nfPWVLymR5YRqCNScFdlNY/fedrrZ30qw=;
        b=PpHjFS4qYopNKiQO3Y7z2LJQu3BzYZxTfiaNszNRMCRLtuk4NkgWYvmd9mpMU5zcWg
         zetF6PvAwQ3TU7k9M1qS45hJsHTm6nmm1g5b2PDvyjGprZ5NGrb/pFZvoBZ75n1SW+xb
         FjVO7OhZZMrxZk7jiTzaerqVttFxUIZrUL0bya01UnQH0BG2REZ3Ci9p4Km6gieFwd1j
         UiAlF93xMp0TdpW7J9QdNu5BS/ZwMsrHQGZcCmh8JPfL5FV1ovNsKobg3MjhucxxpXHI
         SqW3LeEVaz/bH4fyYE15IcDo3KXTR9e8dPiM/AoVtiKgsi4o92zKgfGmHPX5BRyxXdNY
         3Trw==
X-Forwarded-Encrypted: i=1; AJvYcCWG1Y761xuO+kHbUOFgYuG6idhG0+3Izn4pkOiwM/nB+VZD5a58H7sSkhETDb7YagnUWMjy1MgCFg==@kvack.org
X-Gm-Message-State: AOJu0YzQ+3UqSp+g4Frqqc+UwmLo97CI/uA9T9073zlKfrrBha+y8Luw
	d8D8RG/KeFtyorq2SGYeEO2HZ9GEZwYV8YwKomQpTjlkQZ7xbxkGlUldpewK0/q/eQ==
X-Gm-Gg: ASbGncsffznlQCiZPdOowR211z5s0ayTd0tkdVc9Wrc0/0MnGRI6wAdg2eOJ3KUPYnX
	T2g5fyXOA9Q6qvnGpadHUERk1Mrg1K295HnQTDhpozXYcUdqyoK/6LD8cNhmHIP3hEvcqPiK3rZ
	UjBB7vIg/E6SRg8sSfkr+nvVRmTQ2BBCo2fcxDJOGrZqZjyi32T3UaOrimQV78QVMs6jZNQ1YF8
	FUj7pRXf7aEfvAugw74V5Of6lfw0Ev6DOwTMwZ2vltwknM+664TyY4ZU6ByY0G/ILJaWr2eKpFx
	2hNC63wAkb25imqabS5/1geN2jhxM9vmhfD9sv/XSogFJpqE/EHDNSVu9RO38R/NU2ZI+dESfoT
	/P79/ezK5+ZN/1yqTt+TC8zQrec0JppykzqDd7b/W6WbbebpndD2/YXIu32BS/GzUMXzySa8FL8
	69gbgPU0yg460pdN5SMAKVRKaX
X-Google-Smtp-Source: AGHT+IEKWzx9Hc2XCk5oIcV+B3S/rNO3qOJ8GVrhjQ0LXcFxCv/BtadhhiEaA1CrBuEKAraRp6Gazw==
X-Received: by 2002:a05:690c:940a:20b0:729:df2d:4a23 with SMTP id 00721157ae682-729df3c9addmr27962547b3.32.1757328832031;
        Mon, 08 Sep 2025 03:53:52 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-723a834c9adsm52211527b3.28.2025.09.08.03.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 03:53:50 -0700 (PDT)
Date: Mon, 8 Sep 2025 03:53:48 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: David Hildenbrand <david@redhat.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Christoph Hellwig <hch@infradead.org>, Keir Fraser <keirf@google.com>, 
    Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
    Frederick Mayle <fmayle@google.com>, Peter Xu <peterx@redhat.com>, 
    "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
    Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>, 
    Alexander Krabler <Alexander.Krabler@kuka.com>, 
    Ge Yang <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>, 
    Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>, 
    Axel Rasmussen <axelrasmussen@google.com>, 
    Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
    Konstantin Khlebnikov <koct9i@gmail.com>, linux-kernel@vger.kernel.org, 
    linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm/gup: local lru_add_drain() to avoid
 lru_add_drain_all()
In-Reply-To: <e3922760-b074-4d5a-bf4a-9d7cf7f5f914@redhat.com>
Message-ID: <b2aca727-ecb8-5429-e418-e8bcbc8df070@google.com>
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com> <165ccfdb-16b5-ac11-0d66-2984293590c8@google.com> <e3922760-b074-4d5a-bf4a-9d7cf7f5f914@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 67C131C0006
X-Stat-Signature: c3gzofd13xyy5kgdfg6q1euubw4na76x
X-Rspam-User: 
X-HE-Tag: 1757328833-338496
X-HE-Meta: U2FsdGVkX18fDhCdW036KMxd9J2ZZn0bKp4+oChggWThlUP+IZAw6oHTjWYJD2DY5ztqdIhc542EF1/CdaoJMshtNh2GMjBJ6y6QbTW5ZOgXnWtqOhwxnbX8iMPFfWqy19D2u81+BGFdd+JQw2QESkXFutuyWag2/0KFUgwBTYRzuHLFGD1zbW2bQnV1MBf/Gm/pDCleFFHOdBMFgbtEXhNwbJLtYU8gkpS/RFzIppnWg8sZ/Q1+fux6TPQIrJpH40epw9XJlkDyRLQ9BMlEWaLdeZpl6gIZkFcfwJISV1W++R8z2+VpgxDbSAPslZj0amEmdxHPGjnuobP7cKu/gUMXFsznFH5qHnMeY09D3MDSuTgaauLe/rVNlbEamG0MSZKRbgCTOvCfVWbqdf1ndbuycLSw7cPyMLtFxpBotvIg75UL/kZ0DauA5CEvHz1+n6NtNxc36xqhxF0MO1fvcE74ACNwwOI99fj3vNq1KQREXjUtR/Aw/IdcQ2R7ZaD4y9Q8ucf+n3bv+kKvJceNMXI9Qi39aNEMEPHrD7y7ZoKhGAxpf7XRV2LBzka7MZJZniV/Teo29LE2hMFeT1qnm+L9LkSyL8HOyndyicWgBv4khVddlOl3A7Csj1n6giqKWgqPoWqnILsgj+g1YKARpBiJE4JdjzFGWhU8ZATgeflw52PmLUWswuwCQMFU080gvLeImvXXrX198Ob6o8ZK8hYc3FqhHgp7MDi0VDUZOZexoDcoD8TaxquscrT3lBP7XUDZUOqSdr6yRn5pFU4WGYnT83ilbEkwqRmPkNK9a/MHgBJQKqw9gjv6K+JcezLaXklLnO/iLCV8TDpsDJeqxcmMg9DiPk4+CPoUjMNBjblprvetgnvTWoSWyyW8oucZKyvdZ+PE/A26cJgD53fBpUaQ3VEvdketF8SbwS8+sihUcQdaxqolERORsEUM6JhrU2wNFwM8oFCodBT9fHu
 LF3Shh6N
 3OzHOOq07p3D9/treiAPz+yS4xeOythd8unpE+3KcyyqOuJT3+Wd16RbZ+Epo4pA6Yca4xgWsVVKJuttkz8+NOvqHkA5iw4vokC+u8KzN7U4pkcGWbXDzCpSHmLgrvaaOUCHxD/A2XKn/Dwmisu8M6pGMNa3bAVD/15e9+edwt0M1KT2U2ke2hvXStiX+JXzuebtVTHs5TPuxEEfHdEegK5bPilUh/dgTs8jyeuuMqK+kBTCtir5xr+VYSUcdV1PeRazHjISMhlB0E2oXRq9vMoY8n1EKIuU55VoW3A0+Ktmdy0zOEsgxpMOfXmRlvAzEmF6QR8RnXsO3YC+z7kt+1xMdI09B+Pk+69lOYFLnDiG7migGXWnYnjNKzY6hqJKIJcMjKF07+SoohbdEMHFmHruhJ/uR3ZamojQFKHyq8DtIaxEqFxQQ/j1pdUrW9cxZ9De/9uM09RLLeT5+FNS+k4KrRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Sep 2025, David Hildenbrand wrote:
> On 31.08.25 11:08, Hugh Dickins wrote:
> > In many cases, if collect_longterm_unpinnable_folios() does need to
> > drain the LRU cache to release a reference, the cache in question is
> > on this same CPU, and much more efficiently drained by a preliminary
> > local lru_add_drain(), than the later cross-CPU lru_add_drain_all().
> > 
> > Marked for stable, to counter the increase in lru_add_drain_all()s
> > from "mm/gup: check ref_count instead of lru before migration".
> > Note for clean backports: can take 6.16 commit a03db236aebf ("gup:
> > optimize longterm pin_user_pages() for large folio") first.
> > 
> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Cc: <stable@vger.kernel.org>
> > ---
> >   mm/gup.c | 2 ++
> >   1 file changed, 2 insertions(+)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 82aec6443c0a..9f7c87f504a9 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -2291,6 +2291,8 @@ static unsigned long
> > collect_longterm_unpinnable_folios(
> >    struct folio *folio;
> >    long i = 0;
> >   +	lru_add_drain();
> > +
> >    for (folio = pofs_get_folio(pofs, i); folio;
> >         folio = pofs_next_folio(folio, pofs, &i)) {
> >   
> 
> Do we really want to drain all the time we enter
> collect_longterm_unpinnable_folios(), or only if we detect an actual problem?
> (unexpected reference?)

It looked nice and simple to me (hmm, where's the blank line before
lru_add_drain() gone? weird, something wrong with my mail setup),
I've never avoided an lru_add_drain() before; but you're right,
we dom't need to do that every time, fixed in v2 - thanks.

Hugh

