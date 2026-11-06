Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26AFD606A32C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 18:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PSeEhVOt
Received: by kanga.kvack.org (Postfix)
	id 299C86B05B2; Fri,  6 Nov 2026 13:35:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A476B05B3; Fri,  6 Nov 2026 13:35:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139486B05B4; Fri,  6 Nov 2026 13:35:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1B786B05B2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 13:35:09 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F14AA6801
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:35:09 +0000 (UTC)
X-FDA: 85405546338.25.3158E84
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CA0E40004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:35:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PSeEhVOt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793990107;
	b=nZS4LeiMtOcPXZv2Sl7kVPhbDH/KqZ7njtfMrTZxDR4nTLgapEeo8eICLljo5xIkaPQ5zb
	psC/shWwFJEHKhsuo8NmgzYHenJC57FgquGwFo3VFchLuDtRTN35duwURCoEbPS9v41ctz
	S4XOsnnAlMkcT4Su/+BJskDwNQKW9L8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793990107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UH/Hta2lyoHkUcT4IvrcuLRLPnshJas/+Ow5OCaITFo=;
	b=KoD8qDHtM/aQDI6FFDYxU5pfRxLZoVemw1q1bthUDi8v/f6a2qkzQWa3LmMCRAUzS9HgRe
	y9nk+VlLCh3yeeIbjit3VcuDGmLB6pjJLudeaBTeuElGRZiAjt4jzZxjaHhVl8jKBjYjhH
	nTmfsB25H6glhr1fT/UMWc6xF9SpC+I=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=PSeEhVOt;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of elver@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=elver@google.com
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-14394530ec6so1418037c88.1
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 10:35:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793990106; cv=none;
        d=google.com; s=arc-20260327;
        b=X5Ktq9hdYCm0YW0XMSDE45ihZ5ym79RYYpxhJLE+1GZ4Wq3tB8PtRXQmD85OCqNeX0
         QbzQXbn5ky+BpL0lDJK8V033MYXq3e+5i6T7EXDyRRGSAjCYIdRTmhtgIxNda/mqGkwx
         J4JnS49VHelIs5pNgsB8uM0+brzJco8b3PEMqijmlUZmIv5H3XMCYbd3A8HjDwtAZv2q
         MOXzeJmlVjsq+XT6gRf/q2IHKLj281OJxhktGmD+U6OWJp7q3Z+mNlubw8FuP5zrPiki
         exe7+j0SlFQx6iE+K7GyG/iehXtOVivvf8i+zXfOCV9bfXHp3dALbuFC4rq5QaTbpLmZ
         tPPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=UH/Hta2lyoHkUcT4IvrcuLRLPnshJas/+Ow5OCaITFo=;
        fh=WAnUCRpUeYEnaM48XTfkt7NdwR6VqjmjamV2siHSRq0=;
        b=QgSXW2qU2boANIyCJv41ECjWt6RfIl9NdB3h14WF5fZRa90og9WSuejKfthkVRQkzI
         23xFe71ATNVFVvi9bXlCld5s6ZWs+Z9pF3rTrkfWcMHSoUz5eV/rmxZj61JDbfxlCWzY
         fZAr7SKQEQL08YCyOsmPvNqITlhPMT5fFaqfaDsfWKlp1OkBuJbT+AKHK31CNVwC+Eba
         bNaJGRUaiuSww2Xr8lzDZVLOkDxco+KpyKE2tI+M4MN8zqg7TvczCON8lOtBbYOVQrLv
         DkQf/5PuELi9XsMOGNW5Z28+f9Mb6yaYWn+kr6l74DZIJJ9YwcXtc8p8CKylsoft/TxW
         PrXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793990106; x=1794594906; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UH/Hta2lyoHkUcT4IvrcuLRLPnshJas/+Ow5OCaITFo=;
        b=PSeEhVOtg1ETlYhoWMRmlWTC/BNj5+dw6mMI1uRL/EBskpXzvupHzYf1VkcvCSnSf4
         f31k9yhvWA1jEwlYIbgM4SaoNX2rvLTfcxh8PQLz0/a1sJaATpxr6LSd6r4ur1hZQ4NZ
         W8YM9bdeYhUCGcaYFz+2iyK2+SEJDjQjP0uf9uXk4cvp+K/tjA4JggacMpuEo4UMYjDT
         T1qMa/28azwt8JidptKqLz5aFB6SL7yp9f82Hsy+wXLIwnrxmUk9sf6+3UfP7IWlz9kd
         XxJbplgJDwIrAfrwYcsuBl0iD7ivNgqij8JwPUHBA4vcQgkTG+Utd3vvDHOH8oiUqDPJ
         WFVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793990106; x=1794594906;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=UH/Hta2lyoHkUcT4IvrcuLRLPnshJas/+Ow5OCaITFo=;
        b=po0vZ5OupPkleKvQd7wUEBPwNRLfFpOnbKK1IRNkdb2XUsr58WjvIOtohiuouKUiuK
         okYjEUcP1ZFrV1hmJYogPBRaQboVk0p1KCkj/uCgLmnHcYGd+vdtDt2b52qYYljQhGaI
         EEkXigSn8Rl/ws8F6ur0e3watcVWNknncY0bYxx6Coy6qTyMyD73EtvTiCJHBI1yWqrh
         RrLvHe8QPd3XUS4Jr1mYIrhEF4ZaIk1oG02fOOknTBE2tk4Mqo9a1p1bqwA4kQs+UGrL
         rPHi9n3/elnF/S0YiTsf0zH+0BSe6F0Zfnejf0odn6oOGudkOt740XRj9Ywa1CJWuSA2
         wsrg==
X-Forwarded-Encrypted: i=1; AKwUvByVNfEOa6VHOv9hw1HHWF//+2OXA4SMug/p38qMsmQjQCUsRoYKZhzvPoFjXqQYWAJnm36Up80Q7Q==@kvack.org
X-Gm-Message-State: APuU4Z+GRK5YGzxIe2EWUwmoNQ6RIWdRb0InmE/A5iAY4Bgu4CVR5blr
	A25Ut1vv4/V+7/4ad9+Pqw6Ei4C06Wr4pxjCoZEzkEYTQ3Vr9TZ9lRcjdE4rZQRadjRumdal6KU
	7NL6fl92Ssz7keD31RiSKGW4uuKFXK3Cee2bUIhL/
X-Gm-Gg: AYBFou1ss3Hiws2SBSj8g8N1xsr/GtH5O3V+N91uS3x1aPuOLJ/YW4NQAgkJJWPs+Oj
	oPVo6R7jIDeOdEDnH+pEIbzm61dtJKx9qMQk8EUvWxdbN6UPMvQOFp80xBjyyp/zuhLcBkMWmHT
	XpeByz14b1kTeHg1jipt/EVqHAHkp4uUy0QNRlk8UsVuXSPtODGVu4uUUD7iCc0HmUDhgJqNxpB
	iDjpYvhapOboj221HP9daPw5ldX/DOGZ80OyRplXR5gBVY574dSegehGqEHfL1VhpCujjAU6AQf
	F8zbg9Sj6QSkxvyXVi1Vs/GDhmVmUyuC4ORLGEEmefvGt05ZpH0SNgYgIXjHTjfmVLHaGTa9f82
	7LrTTl4D7AqaNB9BP1d2cS4gc37ohUPgoBiwxeviW13GzifWTmJmIULnZxdZB7w9b7o4J
X-Received: by 2002:a05:701b:2506:b0:1a7:d426:6dd2 with SMTP id
 a92af1059eb24-1b25d322b55mr3491861c88.26.1793990105326; Fri, 06 Nov 2026
 10:35:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <ateDvB145CN_R7CA@elver.google.com> <au24u-HWyVtBZME3@matt-Precision-5490>
In-Reply-To: <au24u-HWyVtBZME3@matt-Precision-5490>
From: Marco Elver <elver@google.com>
Date: Fri, 6 Nov 2026 19:34:27 +0100
X-Gm-Features: AclHuK_U2ZATam6HkOZCXfRZSs7AvPTdqKY_KXL2msL8epn5ZENB2X755bCf0HU
Message-ID: <CANpmjNMP=NdD8ZE9rPwikUBcLwc8V=J648X05YGPn41yAZ5hmw@mail.gmail.com>
Subject: Re: [PATCH RFC v2 00/11] stackdepot: reduce memory use for persistent
 stack records with a trie
To: Matt Fleming <mfleming@cloudflare.com>
Cc: Caleb Kan <calebkan1106@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, 
	Vlastimil Babka <vbabka@kernel.org>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 8CA0E40004
X-Stat-Signature: 33dybjkdawbzd1977fz5b1xq8a3yf8an
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1793990107-730431
X-HE-Meta: U2FsdGVkX18IJKC0el5CygEfo1X1A32QKAQvTWqTLkyLKSslpZh/s/6obToQZB86ewDi+FykWxL95T3B/dSBgtnx2swgvw5NoflHK3RBPSMZn6cDDIh9cvAFAcMyvzBhIyczpaPR6adiK0HD3r5jDpdEe1XlW8RXIPhjPKnQyRQGUjRdAhd8C4rxqKeCaTKLzwX09Ayta4mllw1sZXRf/erwOg3bmUOWg+4XPRIERz3yyCcFjGw63Z3QD+pPMGBBwIhUcn6OrGZu9jCkl6I2MSVs2SHRv5y6oEwYJSJ6Ks4MxofDAom9RR+9DwfTzao2P3xzaG8lT5ZICoPDio6BkVd2hoAQIIrA54TtZ3ZEhbTSkQnF92PZvlGB3TXktTm/KNUH+KNBQabd2K8JemFu4jJ/u5bWQvP+AG5qtR/jIhVl7xegnaE+nq55M13S3Jv2xU+X8tigQYLl07wpoQmH4/CpRdFiRdlgbPF/6DZvNLX9+N4e6twPvPa78FDK6xBNFHFb1rDIoON6cm0TmO8mJZgyOvjG6+CKYU+Vo2QJprT4t0fiY7rkzBMrJWfesQuKy7a8F9PkBjmAc2tmKyDgFjdFClGnqXtlX5aewiiuRLQqZf8Z/7YqH4HKYv27TrUr8gJnRhFQSlD4PHTSC203hFbVhDsrsHExysCHjXdbQbtfogqZhSkdmRvAgKiOwVWRCQOZYDHpdhBceJ6Opdx7GnTrhhdRC/vdUmxcsBzfpD3Ylh0NjVZLyALgm0fL6fF0UKMs/QaAtShk8etYlYKlh21FSABhLVZE1TrbdZBt1jAeDh28y07EdHPAVhjzLEUnNfnQ1gssqelD/T+lpxTesMo1hVWC2llHN6Pxh766VZZdbgZyt2WhyamKyDzxq5JL1BULSsY4CHA0GLYc5n+sTCDCcWiPPwpTnVmzd80QVN8GeuS9Mbzg4vsbh2O4ek98ZGPc7D+ZpLjSvD/Pi45
 qdf/XxVi
 4Ea/r6uCPQndkK1mOeOCYINFwveGbdMBd9D/i9Qc1ROrxC9YhUvNV0XZ7EMOY8ZUkOE1uB+/R+571Z5Mnaism1XXgbRABxXnkjLRpvtVzeUqBgCqYct3sCDiE+Tvf8IY0tJWcqCB/kNu4C7M5a1KrBGmq/KKtMQSTEKmp8pxQXp9CF9DW8aU0SUYmn1lIZsHGCOG0OW+P6u4V8r7sTVCPoqCc5/8BC7UJvU/PLLzqp9Wi65ZXutn3z6kLmXD/YfdGzKy+Tm3eLrIjyjqBfProgB5vVnV9DM10CBm4KGZf7TCZzA1t8+6biIpKXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 6 Nov 2026 at 14:18, Matt Fleming <mfleming@cloudflare.com> wrote:
>
> (Sorry for the delay)
>
> On Tue, Oct 20, 2026 at 03:07:40PM +0000, 'Marco Elver' via kernel-team wrote:
> > On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> > > Hi,
> > >
> > > This series reduces the memory used by persistent stack depot records by
> > > sharing common frame prefixes in a path-compressed trie.
> > >
> > > Cloudflare runs KASAN on pre-production servers so allocation and free
> > > stack traces are available when diagnosing memory-safety bugs. On some of
> > > these servers, stack depot exhausted its pool budget even after we raised
> > > stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
> > > persistent trace returns no handle and a later KASAN report can lose the
> > > history needed to explain the bug.
> > >
> > > With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
> > > Doubling the limit again would allow 1 GiB, but it would not change the
> > > linear growth: the hash backend shares identical complete traces, while
> > > two traces that differ by one frame are still stored independently.
> > >
> > > The trie is opt-in and disabled by default.
> >
> > Have you measured how much of the memory reduction comes simply from
> > storing 32-bit compressed frames (patch 9) directly inside the existing
> > hash-backed struct stack_record? That alone cuts frame storage by
> > ~40-45% across *all* callers (including page_owner and KASAN aux stacks)
> > with O(1) lookups and none of the trie/bitmap/RCU complexity.
>
> Yeah 40-45% is the right ballpark. In our measurements, using 32-bit
> frames gets us around 41.8% reduction in stack depot pool usage.
>
> > If prefix sharing is still needed on top of that, deduplicating
> > fixed-size (e.g. 4- or 8-frame) immutable segments from caller to
> > callee in the existing hash table (chained via parent_handle) would
> > avoid mutable child arrays, RCU retirement, and the bitmap allocator
> > entirely.
>
> That's an interesting idea. I'll take a look at that so we can compare
> numbers.
>
> In the meantime, should I send a series that just does the 32-bit
> compressed frames?

Yes, if you see it provides real benefits on its own. It's also a lot
simpler, and having that as an independent series might be a lot less
contentious.

