Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04379FAD3E7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 04:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F8C6B0005; Thu, 23 Apr 2026 00:10:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06416B008A; Thu, 23 Apr 2026 00:10:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF6056B008C; Thu, 23 Apr 2026 00:10:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD38B6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:10:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2D879C1BE5
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:10:35 +0000 (UTC)
X-FDA: 84688494030.27.31CD16F
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39B724000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 04:10:33 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hi2OtozD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776917433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r/tj/y20ZJgcb/msiuUY5DD5bvgoSHlI/PC6yRg7HYk=;
	b=FzNSxYe/awE6p4nLdGMW0jlqMMCSTElH5prh04wcGAm8W7/fcwhDCmvS5ZLZ14tozMnzbM
	FKtVyRu8y/GC8QJ2ZBSKx+msEQQ6aW7u6W0NPGcXdc/zgyjcXdWbYIgeFlx3n2Q8P3aHgU
	nfoRYPZ3fIfa3SbtoTpn2itmD+fEWz0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hi2OtozD;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776917433; a=rsa-sha256;
	cv=pass;
	b=oL8VR3iTovnc3ClBSQblIk9Ja8BbMJ5tPHDuxPfQaUCcVMxXQr1vO8lTPOqXBJhVI/Rch9
	Zn1d5aRsALDvKvKAeGBQswgvKA0vLxAArPM5VeuuSP+7/dEWjUCXLLNG6qyyCq3qZ9RfsW
	6nqwqwGlhMhfe0S6nVT2aXHssKLysHE=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-50d836552daso3484421cf.0
        for <linux-mm@kvack.org>; Wed, 22 Apr 2026 21:10:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776917432; cv=none;
        d=google.com; s=arc-20240605;
        b=RwJRU7GjZDqUgkWw5pQDmu1qScOPcZIvJWi7t2+3v6iLoRlmjlClJIe0XizZbdwLxB
         190qN+8zx5AK6kO6PyyKQZ5llCJ7ffWZi4rc7BQDPNxmXolIqQ2Aw69s4ajbsttMfnLN
         K39yP/YX1AT+fGOQz9vbNTx75PuRDuBGrqEQKweT8VrqcPtIa3uxMwz89wkU5H3fWNz0
         2IRhaFWtvzlB8FVtLWtGwojm7S+LlXaZR0Q4y/5/SrDMN5SEGxWB6yXvGZNjYr4sYdL0
         SNLumkfzNAgjUVsqn6m53XVY4nvyE25y55gXBkvkD/IzG396qtlXqVSPR8k9QGw2xJpk
         40ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=r/tj/y20ZJgcb/msiuUY5DD5bvgoSHlI/PC6yRg7HYk=;
        fh=tuiJN4ruKKiPII3a0siz6UO5dwZ85HmlVbBW8nDTxew=;
        b=GJGthVxo4iWPK8vRMIgFjIsRO4jMTLyXt710u0Hi3IdftsOunrCH2O/apl1aAUi4kU
         8kD8Catcj6NXSOXRja5QqcG2DYIWMYq97lntoZjYYln3NOH+YuXwv3hFAgUfgKp470N8
         UP7DKdMQw1reNNm9Xx4ILIbw/WqGYDQwWTv6EVfpbCn+IoeViYl61LHbws2AkQA7uQx4
         idSHbKQv3bV6B8yyryDN31n5gbbKZ1+Pv2wnaDe17IZX+abq+DsVv+aNhlMRDWWwuVT1
         M8d1aRb/Ou7vXpWhAbrWtSuFn+PN8k+hIzVO3Tz4ro4r1YGUaiLIhjpxk21EuuvWb4Fj
         GZNw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776917432; x=1777522232; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r/tj/y20ZJgcb/msiuUY5DD5bvgoSHlI/PC6yRg7HYk=;
        b=Hi2OtozDPXMO17m+v1yB1GwvRJrwVwJsSl7YvprA0eO0tLlGUApFx1nZVxHOaKvm17
         mVfc6mmmIAG158KrEDihU+FWitGXZFC1wIUQOwLFGpCLSz+7aOGfiQaRePa5qf5SJjZr
         Fj9E0ES8hWoLMUlXwuYMiTi2Npn2PEAecwRU1fXVe+y3dpCVfufeJ0TpmqanJ5xm7zO+
         6zMPcu2ki1MtpmiXHa9kMp6o5znCiQyFk2G4qKZavSd1kR2UizWt4S+FI5Eyr9RaIQqD
         vgJgI8tJqApD18xQyd/0h0s+yzeG2/1UejJg7K3MgNAdosL1K4cVXjxGJrY/cC6Us4t9
         Gx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776917432; x=1777522232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=r/tj/y20ZJgcb/msiuUY5DD5bvgoSHlI/PC6yRg7HYk=;
        b=AgQil6Ip4knPW4iPAmUkNF8duonhzFAVSkcFveQs1NKJQFU62kYTLUgEYhrIUQ7T/a
         Lw9NIKzrwbzxbLq6Z1OmdLQOpT3OYRtlOFDNqM/yNk0Kd35kP8HSCz5btAdWjfHm3BYc
         asziiI0ok8EOq0r9YRTBYF0ZiL8KN3hBG4fzGIX7OUVLia61ASJded9UilMZj1lWM9xz
         IAfdG9e0dfun0WTIQvGhoAJ4OUeL0ce/lLYdDMxpnJqbgUHS5JEVBO22gACoLRKU9v2q
         RNVJTdPl1QxZPuqgQV2UUHffDhWvQATzmpSTSZgl/VOZZk+VB58vlPscPFgAZEBMwZTA
         BFaw==
X-Forwarded-Encrypted: i=1; AFNElJ9bwlOYhmgEgtLmuKqS0KK3MMFYADc+h6zmtJjAPMRAIr9mcaiWTjbyN9C+jVD7aX9ufNHB7LDxVg==@kvack.org
X-Gm-Message-State: AOJu0YwtQ4HSGmVbU8Rj7ctRPcdcGUpelEiRVed5mbMIibzAQ7vA+LAR
	XdbgmqZtX5juMdFpJ5Qxod0pbyxtnxfoDzOemv6+ZH4ZPv9WZoV1ThuIWrfoSU5lLvFIXMjgBMn
	M18XfLU5jmIKNemvJNK+cs8OesybGdYpv2neCtO/DEMcjXwvv0S7pSEX81+w=
X-Gm-Gg: AeBDievBAW/bXjd8cCg98KItmGoeE+YIMEw13Tg2vzXSzLiRuQCYy+65m5srq03b5QD
	LtZsy+RsEreaWphMEV1b0zB/imehpcR8FC7URqHrr8zY6XgO7kDNstjZTNshtgnzkzBEn7gmiaQ
	eXQJ1pdwWp841OH0kJis9d75GjGYPdDYMripIjSWtQ9xPGj0Wd7GS5FQzsjGn1H+S+sJzaOG5A5
	mcKo1EcpJJqAZp32xBEcX4fPoq6YpDNhhAo5f2vBe5/1VWdg90PvUH7u35VOkNdb7m9Grv9/ocG
	z9heNan4jHkkCu0F01Xgv+1zjrl2FV1kT9rdTA==
X-Received: by 2002:ac8:5512:0:b0:50e:5c9d:49c7 with SMTP id
 d75a77b69052e-50e5c9d4c3dmr50774891cf.7.1776917431606; Wed, 22 Apr 2026
 21:10:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260421031406.1189000-1-hao.ge@linux.dev> <CAJuCfpHvCODeKG1y3Ndte9immkW6cUzqsaduOozSEhDv17x82w@mail.gmail.com>
 <a4d4ac18-fbae-4ace-8f1c-651c8fefcf38@linux.dev>
In-Reply-To: <a4d4ac18-fbae-4ace-8f1c-651c8fefcf38@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 22 Apr 2026 21:10:20 -0700
X-Gm-Features: AQROBzCJ36sVwmtihTngzABjqp-3ERznZxS0VlEc2338SklS4LNkitV30x0SAoQ
Message-ID: <CAJuCfpGOd=p4UOkn1UF=KmAFL6Xxm4FGomZt83eRj_cjeUxAjw@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 39B724000D
X-Stat-Signature: tkbbn9jun1ij56zxxu4b5qtgqwnf4h7m
X-Rspam-User: 
X-HE-Tag: 1776917433-506557
X-HE-Meta: U2FsdGVkX1+6KF98fRrQAfuQB1L89EdQnNCPjXzugyw35qwZ8vtZ56zQIU+NHA1zT4zst2SeGUs+gH3693wOXa1MbgGALvr4TYxhVKf1tZ+PPHtV4FfgWNAGS7GyLUuksObFsJn+p0ZriLbXB5UEJDHl0aTLqnbwGnsZdynxWui+Q/Vl3C3A2ewsaMP5Kl/na9gSdtGvm5INr82+iybh03I2jPmc0Qig+3+n6H8UCKYX488pnr07Cm2B1lOh0HeQm6yZC267Ct/n9aGiKyQZR+FuqVRqZ5sOUMCHpPtZcjFHLo0TeEAf0RcsPAkhZE53Q82B5II7tlm4d+NKuTyFANWA+eYEFEQaPqjIoip9CuX05eiDc1caQCrRSlGw3xLSJby1WtKOtWqurAEvWqapBQR3+6/oIuyDv8DOTn87sW07frotrGtiqMzJOOPtS95fSi1rHLvysvUkM7CwbpfLaMTHLkTpQ0bpXb3FjKNdnFD+PDzU9Glo76g6lJxWOj651VX+xw1dJWWPG8r3IZ34oHzNsjrdTBSSnSDa88g0bocQDLsogn01vrgQmjzwW0TBpKS+iwtm/UF41RHv0FP5Ec7zVSj23GLxCQFa3dSjW/UBP+GfZplUeC0Z3rpeZWg2mAbEccJzu0EJ7zmUhUNrYEU3gATtAdXcB6AcekhzhKAmqhpT+HHPAaH/jaBqLei8hYuADXyJg+2G+rFd1y3u7IUYErTKbxLzkNlp6R+CNI5xAQHEsD/wZi0/diZ92EprTXq6YbC3Cq0w1wl8qMviJHdc91sn9lZjF+A1QvaNQfotA+YQ+wUrsGLgCUeKMl9sD0IapGOgH/AXB9S56aHulGxbG9ptdv0S03R1c10nWRn3UHHtaN986rRwye1kEMF5wM6bCf10H07b5412E8OVFfUkqnWWOqLyKsqdx52i3ifPSIKr01gwugBzG+Cl/EzLTlyjoCdA8B69YKoXw9h
 SUfbb7Dd
 UR+MlA5NJIPOUpDywU1N0oKud/unJ30sLAa8eB/yXoLEW3FS9tfVpMNriXFFltDF2aE1WU0iocWldRLvvPW5pbXlK7zyWaM9itfgHwTWzvH4U0SjOHDJTLDOCeCFW9JtaDVIDVBLVaOD3pUje8prP34YfoKVHgTMmb11P0CsFOW0l7wASvQ1feW4H1KqlM1DmDNllSIsVMPzuDtCvmJ/3Cb/YmlYd3f0GY+5sXhmLLHPPdUqpY7cwmv/zHmndBJaMwtENA3LLVrsLDybqWOoBAkUxkRMZI8nbUv236DMrz+4NUpEoYXaft1ElynX8J81ubQjjyBf3SFuBj+/JNJIDoZccNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 7:10=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/4/23 01:32, Suren Baghdasaryan wrote:
> > On Mon, Apr 20, 2026 at 8:15=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> Pages allocated before page_ext is available have their codetag left
> >> uninitialized. Track these early PFNs and clear their codetag in
> >> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> >> warnings when they are freed later.
> >>
> >> Currently a fixed-size array of 8192 entries is used, with a warning i=
f
> >> the limit is exceeded. However, the number of early allocations depend=
s
> >> on the number of CPUs and can be larger than 8192.
> >>
> >> Replace the fixed-size array with a dynamically allocated linked list.
> >> Each page is carved into early_pfn_node entries and the remainder is
> >> kept as a freelist for subsequent allocations.
> >>
> >> The list nodes themselves are allocated via alloc_page(), which would
> >> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() ->
> >> alloc_early_pfn_node() and recurse indefinitely.  Introduce
> >> __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT bit) and pass
> >> gfp_flags through pgalloc_tag_add() so that the early path can skip
> >> recording allocations that carry this flag.
> Hi Suren
> > Hi Hao,
> > Thanks for following up on this!
>
> Happy to help further develop this feature.
>
> Feel free to reach out if there's anything else I can do.
>
>
> >
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >> v2:
> >> - Use cmpxchg to atomically update early_pfn_pages, preventing page le=
ak under concurrent allocation
> >> - Pass gfp_flags through the full call chain and use gfpflags_allow_bl=
ocking()
> >>    to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC=
 in process context
> >> ---
> >>   include/linux/alloc_tag.h |  22 +++++++-
> >>   lib/alloc_tag.c           | 102 ++++++++++++++++++++++++++----------=
--
> >>   mm/page_alloc.c           |  29 +++++++----
> >>   3 files changed, 108 insertions(+), 45 deletions(-)
> >>
> >> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >> index 02de2ede560f..2fa695bd3c53 100644
> >> --- a/include/linux/alloc_tag.h
> >> +++ b/include/linux/alloc_tag.h
> >> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag=
_read(struct alloc_tag *tag)
> >>   }
> >>
> >>   #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >> +/*
> >> + * Skip early PFN recording for a page allocation.  Reuses the
> >> + * %__GFP_NO_OBJ_EXT bit.  Used by alloc_early_pfn_node() to avoid
> >> + * recursion when allocating pages for the early PFN tracking list
> >> + * itself.
> >> + *
> >> + * Callers must set the codetag to CODETAG_EMPTY (via
> >> + * clear_page_tag_ref()) before freeing pages allocated with this
> >> + * flag once page_ext becomes available, otherwise
> >> + * alloc_tag_sub_check() will trigger a warning.
> >> + */
> >> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> >> +
> >> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> >> +{
> >> +       return !(gfp_flags & __GFP_NO_CODETAG);
> >> +}
> >>   static inline void alloc_tag_add_check(union codetag_ref *ref, struc=
t alloc_tag *tag)
> >>   {
> >>          WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> >> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union cod=
etag_ref *ref)
> >>   {
> >>          WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >>   }
> >> -void alloc_tag_add_early_pfn(unsigned long pfn);
> >> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >>   #else
> >>   static inline void alloc_tag_add_check(union codetag_ref *ref, struc=
t alloc_tag *tag) {}
> >>   static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> >> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> >> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t g=
fp_flags) {}
> >> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return =
true; }
> >
> > If CONFIG_MEM_ALLOC_PROFILING_DEBUG=3Dn why should we record early pfns=
?
> Good point! I'll address this in the next patch.
> >>   #endif
> >>
> >>   /* Caller should verify both ref and tag to be valid */
> >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> index ed1bdcf1f8ab..cfc68e397eba 100644
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -766,45 +766,75 @@ static __init bool need_page_alloc_tagging(void)
> >>    * Some pages are allocated before page_ext becomes available, leavi=
ng
> >>    * their codetag uninitialized. Track these early PFNs so we can cle=
ar
> >>    * their codetag refs later to avoid warnings when they are freed.
> >> - *
> >> - * Early allocations include:
> >> - *   - Base allocations independent of CPU count
> >> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_in=
it,
> >> - *     such as trace ring buffers, scheduler per-cpu data)
> >> - *
> >> - * For simplicity, we fix the size to 8192.
> >> - * If insufficient, a warning will be triggered to alert the user.
> >> - *
> >> - * TODO: Replace fixed-size array with dynamic allocation using
> >> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> >>    */
> >> -#define EARLY_ALLOC_PFN_MAX            8192
> >> +struct early_pfn_node {
> >> +       struct early_pfn_node   *next;
> >> +       unsigned long           pfn;
> >> +};
> >> +
> >> +#define NODES_PER_PAGE         (PAGE_SIZE / sizeof(struct early_pfn_n=
ode))
> >>
> >> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> >> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> >> +static struct early_pfn_node *early_pfn_list __initdata;
> >> +static struct early_pfn_node *early_pfn_freelist __initdata;
> >> +static struct page *early_pfn_pages __initdata;
> > This early_pfn_node linked list seems overly complex. Why not just
> > allocate a page and use page->lru to place it into a linked list? I
> > think the code will end up much simpler.
>
> Ah, yes! You mentioned this before, but I misunderstood your point.
>
> I apologize for the confusion. I'll optimize this in the next revision.
>
> >
> >> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >> +static struct early_pfn_node *__init alloc_early_pfn_node(gfp_t gfp_f=
lags)
> >>   {
> >> -       int old_idx, new_idx;
> >> +       struct early_pfn_node *ep, *new;
> >> +       struct page *page, *old_page;
> >> +       gfp_t gfp =3D gfpflags_allow_blocking(gfp_flags) ? GFP_KERNEL =
: GFP_ATOMIC;
> >> +       int i;
> >> +
> >> +retry:
> >> +       ep =3D READ_ONCE(early_pfn_freelist);
> >> +       if (ep) {
> >> +               struct early_pfn_node *next =3D READ_ONCE(ep->next);
> >> +
> >> +               if (try_cmpxchg(&early_pfn_freelist, &ep, next))
> >> +                       return ep;
> >> +               goto retry;
> >> +       }
> >> +
> >> +       page =3D alloc_page(gfp | __GFP_NO_CODETAG | __GFP_ZERO);
>
> One more question: since this is called in an RCU context, should we use
> GFP_ATOMIC by default?

You mean it might be called in RCU context, right? If so then I think
we should not use GFP_ATOMIC when GFP_KERNEL can be used.

>
> Also, should we remove GFP_KSWAPD_RECLAIM here? I'm not entirely sure,
> but I recall Sashiko mentioned a warning about this before:
>
> ---
>
> page =3D alloc_page(GFP_ATOMIC | __GFP_NO_CODETAG | __GFP_ZERO);
>
> Sashiko's concerns:
>
> Can this lead to a deadlock by introducing lock recursion?
> alloc_early_pfn_node() is invoked as a post-allocation hook for early boo=
t
> pages via pgalloc_tag_add(). GFP_ATOMIC includes __GFP_KSWAPD_RECLAIM,
> which triggers wakeup_kswapd() and acquires scheduler locks.
> If the original allocation was made under scheduler locks and intentional=
ly
> stripped __GFP_KSWAPD_RECLAIM to prevent recursion, does this hardcoded
> GFP_ATOMIC force it back on? Should the hook inherit or constrain its fla=
gs
> based on the caller's gfp_flags instead?
>
> ---
>
> Even though this only happens during early boot, should we handle it
> more safely?

That seems reasonable. Any reason you are not doing simply: page =3D
alloc_page(gfp_flags | __GFP_NO_CODETAG | __GFP_ZERO); ? IOW why
aren't you simply inheriting the flags?

>
> >> +       if (!page)
> >> +               return NULL;
> >> +
> >> +       new =3D page_address(page);
> >> +       for (i =3D 0; i < NODES_PER_PAGE - 1; i++)
> >> +               new[i].next =3D &new[i + 1];
> >> +       new[NODES_PER_PAGE - 1].next =3D NULL;
> >> +
> >> +       if (cmpxchg(&early_pfn_freelist, NULL, new + 1)) {
> >> +               __free_page(page);
> >> +               goto retry;
> >> +       }
> >>
> >>          do {
> >> -               old_idx =3D atomic_read(&early_pfn_count);
> >> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> >> -                       pr_warn_once("Early page allocations before pa=
ge_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> >> -                                     EARLY_ALLOC_PFN_MAX);
> >> -                       return;
> >> -               }
> >> -               new_idx =3D old_idx + 1;
> >> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_i=
dx));
> >> +               old_page =3D READ_ONCE(early_pfn_pages);
> >> +               page->private =3D (unsigned long)old_page;
> >> +       } while (cmpxchg(&early_pfn_pages, old_page, page) !=3D old_pa=
ge);
> > I don't think this whole lockless schema is worth the complexity.
> > alloc_early_pfn_node() is called only during early init and is called
> > perhaps a few hundred times in total. Why not use a simple spinlock to
> > synchronize this operation and be done with it?
>
> I initially used a simple spinlock, but Sashiko raised a good point in
> his review:
>
> https://sashiko.dev/#/patchset/20260319083153.2488005-1-hao.ge%40linux.de=
v
>
> Since alloc_early_pfn_node() is called during early init from an unknown
> context, in the early page allocation path,
>
> a lockless approach is safer. However, you're right that if we use
> page->lru as a linked list (which you suggested earlier),
>
> the code becomes much simpler. I plan to simplify the code and continue
> using the lockless approach in the next version.

Ok, let's see the result and decide then. Allocating a page from NMI
context sounds extreme to me. I would expect NMI context to use only
preallocated memory.

>
>
> >> +
> >> +       return new;
> >> +}
> >> +
> >> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t=
 gfp_flags)
> >> +{
> >> +       struct early_pfn_node *ep =3D alloc_early_pfn_node(gfp_flags);
> >>
> >> -       early_pfns[old_idx] =3D pfn;
> >> +       if (!ep)
> >> +               return;
> >> +
> >> +       ep->pfn =3D pfn;
> >> +       do {
> >> +               ep->next =3D READ_ONCE(early_pfn_list);
> >> +       } while (!try_cmpxchg(&early_pfn_list, &ep->next, ep));
> >>   }
> >>
> >> -typedef void alloc_tag_add_func(unsigned long pfn);
> >> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
> >>   static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refda=
ta =3D
> >>          RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >>
> >> -void alloc_tag_add_early_pfn(unsigned long pfn)
> >> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >>   {
> >>          alloc_tag_add_func *alloc_tag_add;
> >>
> >> @@ -814,13 +844,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
> >>          rcu_read_lock();
> >>          alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr=
);
> >>          if (alloc_tag_add)
> >> -               alloc_tag_add(pfn);
> >> +               alloc_tag_add(pfn, gfp_flags);
> >>          rcu_read_unlock();
> >>   }
> >>
> >>   static void __init clear_early_alloc_pfn_tag_refs(void)
> >>   {
> >> -       unsigned int i;
> >> +       struct early_pfn_node *ep;
> >> +       struct page *page, *next;
> >>
> >>          if (static_key_enabled(&mem_profiling_compressed))
> >>                  return;
> >> @@ -829,14 +860,13 @@ static void __init clear_early_alloc_pfn_tag_ref=
s(void)
> >>          /* Make sure we are not racing with __alloc_tag_add_early_pfn=
() */
> >>          synchronize_rcu();
> >>
> >> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> >> -               unsigned long pfn =3D early_pfns[i];
> >> +       for (ep =3D early_pfn_list; ep; ep =3D ep->next) {
> >>
> >> -               if (pfn_valid(pfn)) {
> >> -                       struct page *page =3D pfn_to_page(pfn);
> >> +               if (pfn_valid(ep->pfn)) {
> >>                          union pgtag_ref_handle handle;
> >>                          union codetag_ref ref;
> >>
> >> +                       page =3D pfn_to_page(ep->pfn);
> >>                          if (get_page_tag_ref(page, &ref, &handle)) {
> >>                                  /*
> >>                                   * An early-allocated page could be f=
reed and reallocated
> >> @@ -861,6 +891,12 @@ static void __init clear_early_alloc_pfn_tag_refs=
(void)
> >>                  }
> >>
> >>          }
> >> +
> >> +       for (page =3D early_pfn_pages; page; page =3D next) {
> >> +               next =3D (struct page *)page->private;
> >> +               clear_page_tag_ref(page);
> >> +               __free_page(page);
> >> +       }
> >>   }
> >>   #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >>   static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 04494bc2e46f..4e2bfb3714e1 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
> >>   /* Should be called only if mem_alloc_profiling_enabled() */
> >>   static noinline
> >>   void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> >> -                      unsigned int nr)
> >> +                      unsigned int nr, gfp_t gfp_flags)
> >>   {
> >>          union pgtag_ref_handle handle;
> >>          union codetag_ref ref;
> >> @@ -1294,21 +1294,30 @@ void __pgalloc_tag_add(struct page *page, stru=
ct task_struct *task,
> >>                  update_page_tag_ref(handle, &ref);
> >>                  put_page_tag_ref(handle);
> >>          } else {
> >> -               /*
> >> -                * page_ext is not available yet, record the pfn so we=
 can
> >> -                * clear the tag ref later when page_ext is initialize=
d.
> >> -                */
> >> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> >> +
> >>                  if (task->alloc_tag)
> >>                          alloc_tag_set_inaccurate(task->alloc_tag);
> >> +
> >> +               /*
> >> +                * page_ext is not available yet, skip if this allocat=
ion
> >> +                * doesn't need early PFN recording.
> >> +                */
> >> +               if (unlikely(!should_record_early_pfn(gfp_flags)))
> >> +                       return;
> >> +
> >> +               /*
> >> +                * Record the pfn so the tag ref can be cleared later
> >> +                * when page_ext is initialized.
> >> +                */
> >> +               alloc_tag_add_early_pfn(page_to_pfn(page), gfp_flags);
> > nit: This seems shorter and more readable:
> >
> >                 if (unlikely(should_record_early_pfn(gfp_flags)))
> >                              alloc_tag_add_early_pfn(page_to_pfn(page),
> > gfp_flags);
>
> OK, will improve it in the next version.

Thanks,
Suren.

>
>
> Thanks for taking the time to review and provide these suggestions!
>
> Thanks
>
> Best Regards
>
> Hao
>
> >>          }
> >>   }
> >>
> >>   static inline void pgalloc_tag_add(struct page *page, struct task_st=
ruct *task,
> >> -                                  unsigned int nr)
> >> +                                  unsigned int nr, gfp_t gfp_flags)
> >>   {
> >>          if (mem_alloc_profiling_enabled())
> >> -               __pgalloc_tag_add(page, task, nr);
> >> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
> >>   }
> >>
> >>   /* Should be called only if mem_alloc_profiling_enabled() */
> >> @@ -1341,7 +1350,7 @@ static inline void pgalloc_tag_sub_pages(struct =
alloc_tag *tag, unsigned int nr)
> >>   #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>
> >>   static inline void pgalloc_tag_add(struct page *page, struct task_st=
ruct *task,
> >> -                                  unsigned int nr) {}
> >> +                                  unsigned int nr, gfp_t gfp_flags) {=
}
> >>   static inline void pgalloc_tag_sub(struct page *page, unsigned int n=
r) {}
> >>   static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsi=
gned int nr) {}
> >>
> >> @@ -1896,7 +1905,7 @@ inline void post_alloc_hook(struct page *page, u=
nsigned int order,
> >>
> >>          set_page_owner(page, order, gfp_flags);
> >>          page_table_check_alloc(page, order);
> >> -       pgalloc_tag_add(page, current, 1 << order);
> >> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >>   }
> >>
> >>   static void prep_new_page(struct page *page, unsigned int order, gfp=
_t gfp_flags,
> >> --
> >> 2.25.1
> >>

