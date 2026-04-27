Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312A4FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BCE66B0092; Mon, 27 Apr 2026 12:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 994D96B0093; Mon, 27 Apr 2026 12:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883AD6B0095; Mon, 27 Apr 2026 12:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 744476B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:23:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5CD5E1A0AF1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:03:01 +0000 (UTC)
X-FDA: 84704804562.15.467EAD9
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id F193F4000C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:02:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UDUBXRJJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777305779; a=rsa-sha256;
	cv=pass;
	b=q6KXRnQeeC2gAt/aR7fNum1ZcmLnWoISmPpYDJ398/JFJiaiFTcqwO9ygft6+iCb2CtkNE
	ZwqnOvYEtuiJZCaIB46R3azGzOx4LFH7K/3VjxH/coeaNl2Ojw2AFwEZUDKT1c+rWPUUN0
	jFalWOpaHAaJoeDxe0MRApniF8yJ+zQ=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UDUBXRJJ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777305779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2T/G9yBekMmiiVNBvcix2ubemboaIfcWaARB37V3yNA=;
	b=k91IQ55Wk8wJ5nWxwIQZICVrgUc/wAa/8ITsaF7p4lVR05zO6WFBUqxEN1D2bl+5Ro1hA6
	ChOHhvxt+40cMH/1L4xGCic5776MbDYeQiybNB9Pqg70hzzfMXnRlDNP2u5htCc29JrcPF
	8vEAabdNzXBH9gCN9d9tb76XjMBsVeQ=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67148a70f8aso84360a12.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 09:02:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777305777; cv=none;
        d=google.com; s=arc-20240605;
        b=gTUi4waYegLHQ3p28qNUxEMZ9btAMfRzm00wK5Dm4E4rzM5jgt5k+FRwuX1QMUsOwJ
         f43yCBwycP7958Wm6qf9D3EHvC1kobFd4ajeZ8ZCCZddH7NTEWC6Dqk053rAutQ8uNtT
         Xoy7lHSUuV32it4v4RJ9O/82a6I8O6UZ7XALWtu48ckpj3Hpg134iMpNhux3n7UY52CZ
         kuKnsDmJU3gimmpYc4QNEK3TdHD8mQaaNHubQvd1EFq7rhNKnYMH0rVXUSLar4+du3OZ
         xUa1c2i1gkUWxO2y8pSuVfOJlJf1cz6B93/mkjxs+epx6YaOBvfyOqw96oC7IiYqYFAu
         wozQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2T/G9yBekMmiiVNBvcix2ubemboaIfcWaARB37V3yNA=;
        fh=bnV7E1zL3NmW9+lnjDaIyGWdfUB1uzPeoxFyx6hUpsU=;
        b=Uo+dXWkJOKmg6+AJtsblIX4wmAh7s1GrYiUSEQ5watc73LIRnCsI+16skW6wzOG9w0
         qbznIqkn+WicZf4gpOILXI/ht0EUep7SE74RG0WyV7N8tWgvzpwWnRAIRleFtcztwVju
         3iwfpB06g/reJrbbWrzE+vR7SDygh+yv7+rCCPaGBBD0ARewP7NkNuVivIRW4sQwwMx/
         6aofFcK00ucC98jUtt7COBvy1P/z1Q8GXO0lt8Okfpe0FJhI7Inq4s8YNn5YCILGLvWp
         R4BLcL2zp4uD1EdtycSyM2KA3IE6sQLBQNhZcPRNU7o97lQVoYaleCUQh4gAAney+he7
         NKmQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777305777; x=1777910577; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2T/G9yBekMmiiVNBvcix2ubemboaIfcWaARB37V3yNA=;
        b=UDUBXRJJ6lIazQmYj4V/gemQ8OYH/C6uTXggpNiO+iuVU2HidIU1dAKQOK7FHEa1ey
         QmRMZAwKOdWPl7WKFinWGjcZ3BmZyeREwLaIPgguwuwV4GnZUfp5Lul8St8O66jqE4OU
         kauIkQud6E+On5p4poHLnhsVUKtbmQXSgP6905bZrhY76sKeuRvqZqzmS1dFV63joIRf
         PuCjTe90Ocu1p20ogW7mdIw0PwVbv+CfPj0T6Zn2x6tR+th+QXGW2py1zUfyRqHNeYIR
         J3eJB4THsYg3EahSMcDdRE/hjBmNpGru0I4JDMgAhbABKxSC3wMb2ujZ5Bp7FNbjdHxp
         EmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777305777; x=1777910577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2T/G9yBekMmiiVNBvcix2ubemboaIfcWaARB37V3yNA=;
        b=ckHQcAr5X7qtW+B8Ki9EUP26irHg3WK6RU0r/hBoA3IlliDe2Dssq7YjCy68FLg5Lf
         Sr2935baJHEGQ/LvJxs05RjOyIz7RJFvV2OohPyL8mx2j87QBxuknbEz1dQN4jkp+SFA
         AqDjFE6MO+BXSarbsXUgbcq3V8UKMhqJ4IJwnL1DPrnZeF91w090lWL/cHLeniOVlMgj
         ysF2OM4nAFkYslC8w5oETLfHBtKmcgXajxM4FhigXCFxjmnDnSpBOJK/7GSZyhU0m2E4
         SyGWJ70FfPeRNduta8fMsztSulXbnVyrnDda86+3anarj5ATatJuvZqPXayOGsnjtDd0
         Gi4g==
X-Forwarded-Encrypted: i=1; AFNElJ+4tCRRhuSJQ5EqaP6k0T6dGQjpWXH8haXVdgXBDeBv2JMP2hPl6QXHJkfR0YB0HH72K/HS3dr5iA==@kvack.org
X-Gm-Message-State: AOJu0YzL9XKlmOr+u0DE4N8waTLmC4oMQIW5uZMKBNTAfd2FaRlTzMYT
	J/oUSdk6s1aY5txlW5xuqJ8iTKQ+HFDU1J7USrY09karCcvkYN2P/pHdrS0sIuu3b/AR0vs3Fse
	WHCT/afGfEeubE2v0bVqX1Tr6BHk9vynpiD1xnMNJ
X-Gm-Gg: AeBDieuikb5CEufc67q01wfjp2axxBACP0E1AsKlKWtAzfH16x833wCzKhvOjW7DL9D
	+soeVWl+O+uSo/Cuygcu6cphc5mxIYwEfCkvqtHnF1av4iOz3hMn4pv7SfqPsCfTbGBBaret0AV
	mC53TXQVd9W92seZYh03vD1JbTYGIZtYH/UFn77ObpGcMSbpWKJKYaGsheAOto9k4uk2IlqKAHL
	4gRUvGPr1AhJn6eU/f0AwEDieKWORYYWinRsK27QV9LZImXjcnb8CWITC/s5J5V3w5prjIiTkXz
	NFb0BzVuzOa410GaQEua9imch6I=
X-Received: by 2002:aa7:c4f1:0:b0:676:67ec:abaf with SMTP id
 4fb4d7f45d1cf-679b623aae8mr304a12.3.1777305776018; Mon, 27 Apr 2026 09:02:56
 -0700 (PDT)
MIME-Version: 1.0
References: <20260423083756.157902-1-hao.ge@linux.dev>
In-Reply-To: <20260423083756.157902-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Apr 2026 09:02:43 -0700
X-Gm-Features: AVHnY4Jk2bq6V_DLtkELrG_BWjQMoxeGiTxH7hgb2dHYhq4GCReoKXKXRDv08nc
Message-ID: <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 7ybz796zrzoxxgqgf1w1acsoea691rkr
X-Rspam-User: 
X-Rspamd-Queue-Id: F193F4000C
X-Rspamd-Server: rspam07
X-HE-Tag: 1777305778-430246
X-HE-Meta: U2FsdGVkX19Iq19/xgmTdO5457Km8zD1RykoOyjLnrMkxgwwwTAyi7brSQ83KFO/oZ0PPGwvULEFn+FdPjAJDjMHBys4HLi52Jzqe/4O2YD3vWN8bfptmaOGocS7TIQam2GAYC8YxyHI533+xKCpYt6Q0QtLLIElqauZQlnuzosQdQ0TVqQ8Fdm2TsjRo9jtNQy5gjcVd57C/S2JnAV6a1oHCB04wM/A1P6s+9B3f3DN2hrHahq1Tw5QJfDx00kdErvzJNiVjxH8WEuKnZNh6ckDxJIehnc86oE760aXZWXJrQfmYM+Nyd0dGOC/lALjqwCRiYhwxN75EvMiLU/u74RNbkjkxDgg96PT98/NdWbZZhQhO92ChoaHDfhlt/iCDM42O4d+212gXi1gQuNeWyPLPK2iQXJV3TD2TR6TkmLFpDzdsU7jiirBc7fQnKvr/aWBIlD8xTdW6ULXeVlEkO47JTgPyC1YKLzUMxYIP8zqhV71SPjhlwe1CsIuxF6lWn9iHJs84QcLgh784RX4ak+ZrjR/h+siIzj1nxKOIeb0rrIWCrHfLTLQ16BWWpnSdpOQTey3lWpw1GGOzKfDE2cMYAw6bAvlkiUhg8H00WpsPnc+9yOj8uDrmsCWa8BFH/oomaaDVLpGXMaM4Frf2ugixDlndXD8UBfunwXaA/RxjEM4AjYQLrYEtq33VdzO9rpz44i2bfs7TXIiTwz7dDou4isfhsiVllU82AqFijVL84dKEe4QiX/jBcVdm5qaZi0mssHldB8aeXsvIcDWzssJt4j5/Hq5XaaMJq+pTFIq/ACMiYYfSAy4SgaGl7PYuJumpYCG2G8WeXE+VJXpAPL5Y8UM/5jRlo4gDQWxpbCGdjhU6nNoQLnBfwjWcnLhdMnRpfToaYNgZfiY4770K5uuCwYLOKz+HMksa8N5evqSiCXGlZVGEAJXoYyISZlWAF2r/O5E5t7cRyNqDJf
 rrFAlzdn
 tmmhmWhmKtr7G6B2m778e4kREfLpqhJW90uFwfAWaqNCU0BwKHUB//U/MVoDm5WDjYW8V9cp3vCbR+9/fhcK1mmO/u7P3AY4vOcMBBqd1NtV1mZcmkwSsVX7lTo3EIJyNXPYYVkWC/b820NiqrtNqZ/vvjoEEqxwmZAUdAJ5AfiUGq+VJQk/4xuXwH66w5yZZfxOOzqkOK29bgc8Aa4TJyHxdH2XBO7Z4fJcTBFguE1YqdBYlRZ34i7BxvxGbylx0I90UK7J3rghyZuRWwbDA3fFwxwiWzi2IeXiBNpNacI+6YH1t1pHTmHVTSD7y6bdeMfLEJI9tSzybsD3l18mGiEJRNtZFQPc8Yj3T2b/hJrflP0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 1:39=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Pages allocated before page_ext is available have their codetag left
> uninitialized. Track these early PFNs and clear their codetag in
> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> warnings when they are freed later.
>
> Currently a fixed-size array of 8192 entries is used, with a warning if
> the limit is exceeded. However, the number of early allocations depends
> on the number of CPUs and can be larger than 8192.
>
> Replace the fixed-size array with a dynamically allocated linked list
> of pages. Each page stores PFNs in its page body and uses page->lru
> to link to the next page, with page->private tracking the number of
> used slots.
>
> The list pages themselves are allocated via alloc_page(), which would
> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_EXT
> bit) and pass gfp_flags through pgalloc_tag_add() so that the early path
> can skip recording allocations that carry this flag.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> v3:
> - Simplify linked list: use page->lru for chaining and page->private as
>   slot counter, removing the early_pfn_node struct and freelist (suggeste=
d
>   by Suren Baghdasaryan)
> - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
>   __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
>   because __alloc_tag_add_early_pfn() is invoked under rcu_read_lock().
>
> v2:
> - Use cmpxchg to atomically update early_pfn_pages, preventing page leak =
under concurrent allocation
> - Pass gfp_flags through the full call chain and use gfpflags_allow_block=
ing()
>   to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATOMIC in =
process context
> ---
>  include/linux/alloc_tag.h |  22 ++++++-
>  lib/alloc_tag.c           | 118 +++++++++++++++++++++-----------------
>  mm/page_alloc.c           |  23 ++++----
>  3 files changed, 97 insertions(+), 66 deletions(-)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 02de2ede560f..ce9b478033bf 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_tag_re=
ad(struct alloc_tag *tag)
>  }
>
>  #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> +/*
> + * Skip early PFN recording for a page allocation.  Reuses the
> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to avoid
> + * recursion when allocating pages for the early PFN tracking list
> + * itself.
> + *
> + * Callers must set the codetag to CODETAG_EMPTY (via
> + * clear_page_tag_ref()) before freeing pages allocated with this
> + * flag once page_ext becomes available, otherwise
> + * alloc_tag_sub_check() will trigger a warning.

nit: Callers must... sounds like someone who uses
__alloc_tag_add_early_pfn() has to do something extra, however
clear_page_tag_ref() is done by clear_early_alloc_pfn_tag_refs(), so
callers don't really need to do this. I suggest rephrasing as:

Codetags of the pages allocated with __GFP_NO_CODETAG should be
cleared (via clear_page_tag_ref()) before freeing the pages to prevent
alloc_tag_sub_check() from triggering a warning.

> + */
> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> +
> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> +{
> +       return !(gfp_flags & __GFP_NO_CODETAG);
> +}
>  static inline void alloc_tag_add_check(union codetag_ref *ref, struct al=
loc_tag *tag)
>  {
>         WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union codeta=
g_ref *ref)
>  {
>         WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
>  }
> -void alloc_tag_add_early_pfn(unsigned long pfn);
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
>  #else
>  static inline void alloc_tag_add_check(union codetag_ref *ref, struct al=
loc_tag *tag) {}
>  static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_=
flags) {}
> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { return fal=
se; }
>  #endif
>
>  /* Caller should verify both ref and tag to be valid */
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index ed1bdcf1f8ab..a00dc5a867e4 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(void)
>   * Some pages are allocated before page_ext becomes available, leaving
>   * their codetag uninitialized. Track these early PFNs so we can clear
>   * their codetag refs later to avoid warnings when they are freed.
> - *
> - * Early allocations include:
> - *   - Base allocations independent of CPU count
> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_init,
> - *     such as trace ring buffers, scheduler per-cpu data)
> - *
> - * For simplicity, we fix the size to 8192.
> - * If insufficient, a warning will be triggered to alert the user.
> - *
> - * TODO: Replace fixed-size array with dynamic allocation using
> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
>   */
> -#define EARLY_ALLOC_PFN_MAX            8192
> +#define EARLY_PFNS_PER_PAGE            (PAGE_SIZE / sizeof(unsigned long=
))
>
> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> +static struct page *early_pfn_current __initdata;

So, instead of using early_pfn_current as the head page and then
page->lru.next directly, I would suggest having "struct llist_head
early_pfn_head;" as the list head and either using page->pcp_llist to
link the pages or even better, adding a "struct llist_node llist;"
into the union containing "struct list_head lru;". Note that
llist_add() uses try_cmpxchg(), so the link addition is atomic.
And you should probably use folios rather than pages to follow the new tren=
ds.

>
> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gf=
p_flags)
>  {
> -       int old_idx, new_idx;
> +       struct page *page;
> +       unsigned long idx;
>
>         do {
> -               old_idx =3D atomic_read(&early_pfn_count);
> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> -                       pr_warn_once("Early page allocations before page_=
ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> -                                     EARLY_ALLOC_PFN_MAX);
> -                       return;
> +               page =3D READ_ONCE(early_pfn_current);
> +               if (!page || READ_ONCE(page->private) >=3D EARLY_PFNS_PER=
_PAGE) {
> +                       gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECLAIM;
> +                       struct page *new =3D alloc_page(gfp | __GFP_NO_CO=
DETAG);
> +
> +                       if (!new) {
> +                               pr_warn_once("early PFN tracking page all=
ocation failed\n");
> +                               return;
> +                       }
> +                       new->lru.next =3D (struct list_head *)page;
> +                       if (cmpxchg(&early_pfn_current, page, new) !=3D p=
age) {
> +                               __free_page(new);
> +                               continue;
> +                       }
> +                       page =3D new;
>                 }
> -               new_idx =3D old_idx + 1;
> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> +               idx =3D READ_ONCE(page->private);
> +               if (idx >=3D EARLY_PFNS_PER_PAGE)
> +                       continue;
> +               if (cmpxchg(&page->private, idx, idx + 1) !=3D idx)
> +                       continue;
> +               break;

nit: This would read more easily:

               if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx)
                        break;


> +       } while (1);
>
> -       early_pfns[old_idx] =3D pfn;
> +       ((unsigned long *)page_address(page))[idx] =3D pfn;
>  }
>
> -typedef void alloc_tag_add_func(unsigned long pfn);
> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags);
>  static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __refdata =
=3D
>         RCU_INITIALIZER(__alloc_tag_add_early_pfn);
>
> -void alloc_tag_add_early_pfn(unsigned long pfn)
> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
>  {
>         alloc_tag_add_func *alloc_tag_add;
>
> @@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn)
>         rcu_read_lock();
>         alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_ptr);
>         if (alloc_tag_add)
> -               alloc_tag_add(pfn);
> +               alloc_tag_add(pfn, gfp_flags);
>         rcu_read_unlock();
>  }
>
>  static void __init clear_early_alloc_pfn_tag_refs(void)
>  {
> -       unsigned int i;
> +       struct page *page, *next;
> +       unsigned long i;
>
>         if (static_key_enabled(&mem_profiling_compressed))
>                 return;
> @@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_refs(v=
oid)
>         /* Make sure we are not racing with __alloc_tag_add_early_pfn() *=
/
>         synchronize_rcu();
>
> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> -               unsigned long pfn =3D early_pfns[i];
> -
> -               if (pfn_valid(pfn)) {
> -                       struct page *page =3D pfn_to_page(pfn);
> -                       union pgtag_ref_handle handle;
> -                       union codetag_ref ref;
> -
> -                       if (get_page_tag_ref(page, &ref, &handle)) {
> -                               /*
> -                                * An early-allocated page could be freed=
 and reallocated
> -                                * after its page_ext is initialized but =
before we clear it.
> -                                * In that case, it already has a valid t=
ag set.
> -                                * We should not overwrite that valid tag=
 with CODETAG_EMPTY.
> -                                *
> -                                * Note: there is still a small race wind=
ow between checking
> -                                * ref.ct and calling set_codetag_empty()=
. We accept this
> -                                * race as it's unlikely and the extra co=
mplexity of atomic
> -                                * cmpxchg is not worth it for this debug=
-only code path.
> -                                */
> -                               if (ref.ct) {
> +       for (page =3D early_pfn_current; page; page =3D next) {
> +               for (i =3D 0; i < page->private; i++) {
> +                       unsigned long pfn =3D ((unsigned long *)page_addr=
ess(page))[i];

This page_address() can be done in the outer loop since the page does
not change inside the inner loop.

> +
> +                       if (pfn_valid(pfn)) {
> +                               union pgtag_ref_handle handle;
> +                               union codetag_ref ref;
> +
> +                               if (get_page_tag_ref(pfn_to_page(pfn), &r=
ef, &handle)) {
> +                                       /*
> +                                        * An early-allocated page could =
be freed and reallocated
> +                                        * after its page_ext is initiali=
zed but before we clear it.
> +                                        * In that case, it already has a=
 valid tag set.
> +                                        * We should not overwrite that v=
alid tag
> +                                        * with CODETAG_EMPTY.
> +                                        *
> +                                        * Note: there is still a small r=
ace window between checking
> +                                        * ref.ct and calling set_codetag=
_empty(). We accept this
> +                                        * race as it's unlikely and the =
extra complexity of atomic
> +                                        * cmpxchg is not worth it for th=
is debug-only code path.
> +                                        */
> +                                       if (ref.ct) {
> +                                               put_page_tag_ref(handle);
> +                                               continue;
> +                                       }
> +
> +                                       set_codetag_empty(&ref);
> +                                       update_page_tag_ref(handle, &ref)=
;
>                                         put_page_tag_ref(handle);
> -                                       continue;
>                                 }
> -
> -                               set_codetag_empty(&ref);
> -                               update_page_tag_ref(handle, &ref);
> -                               put_page_tag_ref(handle);
>                         }
>                 }
>
> +               next =3D (struct page *)page->lru.next;
> +               clear_page_tag_ref(page);
> +               __free_page(page);
>         }
>  }
>  #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 04494bc2e46f..5b7b234967a5 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
>  /* Should be called only if mem_alloc_profiling_enabled() */
>  static noinline
>  void __pgalloc_tag_add(struct page *page, struct task_struct *task,
> -                      unsigned int nr)
> +                      unsigned int nr, gfp_t gfp_flags)
>  {
>         union pgtag_ref_handle handle;
>         union codetag_ref ref;
> @@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, struct =
task_struct *task,
>                 update_page_tag_ref(handle, &ref);
>                 put_page_tag_ref(handle);
>         } else {
> -               /*
> -                * page_ext is not available yet, record the pfn so we ca=
n
> -                * clear the tag ref later when page_ext is initialized.
> -                */
> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> +
>                 if (task->alloc_tag)
>                         alloc_tag_set_inaccurate(task->alloc_tag);
> +
> +               /*
> +                * page_ext is not available yet, record the pfn so the
> +                * tag ref can be cleared later when page_ext is initiali=
zed.
> +                */
> +               if (should_record_early_pfn(gfp_flags))
> +                       alloc_tag_add_early_pfn(page_to_pfn(page), gfp_fl=
ags);

Any reason for changing the order of alloc_tag_add_early_pfn() and
alloc_tag_set_inaccurate()? I liked the previous version where we
explain why this is done at the very beginning of the block. You could
also call should_record_early_pfn() from inside
alloc_tag_add_early_pfn(), which would keep both
should_record_early_pfn() and __GFP_NO_CODETAG definitions local to
alloc_tag.c.

>         }
>  }
>
>  static inline void pgalloc_tag_add(struct page *page, struct task_struct=
 *task,
> -                                  unsigned int nr)
> +                                  unsigned int nr, gfp_t gfp_flags)
>  {
>         if (mem_alloc_profiling_enabled())
> -               __pgalloc_tag_add(page, task, nr);
> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
>  }
>
>  /* Should be called only if mem_alloc_profiling_enabled() */
> @@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struct all=
oc_tag *tag, unsigned int nr)
>  #else /* CONFIG_MEM_ALLOC_PROFILING */
>
>  static inline void pgalloc_tag_add(struct page *page, struct task_struct=
 *task,
> -                                  unsigned int nr) {}
> +                                  unsigned int nr, gfp_t gfp_flags) {}
>  static inline void pgalloc_tag_sub(struct page *page, unsigned int nr) {=
}
>  static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, unsigned=
 int nr) {}
>
> @@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page, unsi=
gned int order,
>
>         set_page_owner(page, order, gfp_flags);
>         page_table_check_alloc(page, order);
> -       pgalloc_tag_add(page, current, 1 << order);
> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
>  }
>
>  static void prep_new_page(struct page *page, unsigned int order, gfp_t g=
fp_flags,
> --
> 2.25.1
>

