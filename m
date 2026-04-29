Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A42EBCCFA13
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1861F6B009B; Wed, 29 Apr 2026 14:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1336B6B009D; Wed, 29 Apr 2026 14:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023126B009E; Wed, 29 Apr 2026 14:20:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DEC8A6B009B
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2B421B94DC
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:26 +0000 (UTC)
X-FDA: 84712408452.08.F219DC2
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id A3E6BA0004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WKuMcq0j;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9M0B+brb4So2TiCU6ZP3BLVOwtv02uBu/D6HTKzFiw=;
	b=lw8b6AqFby/tWymGGwR5xkZAGi2+rOcsf6fjlVoRU0N7mFJdrrTu8uRoQObVwE2iTaXZz4
	dsLhJtpnMJAUt06uu+Tivt+/X9kBMHXmgFVKpXRqsYw8clBp3ZLe/NfPlYwLh7oWbZK7+n
	qtLMfiyHQ7604pmPNcLVIoHb9jzDAFg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777486824; a=rsa-sha256;
	cv=pass;
	b=IRUuZcqVcIO8x0fle+z03rX8cdQZdrn5ptlV68w4v1bNNj4T9HVKLebZT2Uwv7X3NyeIYv
	Z5OlN3XWLROctdr9PM9/87Yu0sQbif4VPdyh6PaYmmFn9frWi+mfMkr94CrmFAI5o+YpMX
	f4YvaJjIs+lux06rz4OVZeiNwVtXdk8=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WKuMcq0j;
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d864c23bdso63631cf.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 11:20:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777486824; cv=none;
        d=google.com; s=arc-20240605;
        b=ZINY6eWexsJkfsl55qsDcdDP4x2X/oLKHiuKALeZ0J01u/WyqitPQz/MukNxDiLYSu
         YiBkj/FF5yVicEuCOc//IPEja2xrTCBjcn86meis040DTen68vEAtSKoXH8vSpgrfcjf
         L/i7DwtxtD4lGr3DbV2TF1X09CsC/vDpXMUrHxGJdsqWSJaONk6VFNuWdGGBZeOp5e4X
         cjv0V5K4OV2AZSVm8IcyYKPM5QsKFe7lgIez5MV0DBPYwqBeFWcuZbXHVP21wmA7NNzQ
         9MV5XPeNp+rPU2pXzG+mT+axjoLA9t0nZaFBYcN5b36g344mgBVOhx1O43wneRka59of
         sLAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J9M0B+brb4So2TiCU6ZP3BLVOwtv02uBu/D6HTKzFiw=;
        fh=EiW82wIGZDXKb+wc5BfTO0hIBY0ZSCSeelWq6EocA5E=;
        b=FoB9w4Irmp2lUx54hKMO7CBSUKL7ZQUh2dOrhsv3y4O/RcNKN4MKl5embm+Q8dqVbM
         36bDXHiOk3uN7KTFU5q1p/zuU6J8hIagJCIetXZ1IU52swt0WlqnBMaHV6mBf28KLPlC
         uscRYiJ+JV95r+dhj05gprjMBTVjbqathGapFfU8CcStZrEU3ish30K8E3q+JtxLIaFo
         hq4oRNwI8rgTJO1ywnoYshwju7Z09YEt0sRdFD9X3uK5H082YRpVjnjyrbypMsX1e52+
         z9Rl162++T0kR8aZxu1BsOoFnEbDp8vFCU6HAjrocBCEQXVBVe679fMWlwqg0RPb8Fa1
         lbVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777486824; x=1778091624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J9M0B+brb4So2TiCU6ZP3BLVOwtv02uBu/D6HTKzFiw=;
        b=WKuMcq0jnHvB6G2enwd2+JupTPwM7wdJN4+953FkLE/QxKqIR67dwUvxJok4Bn4vXm
         6jnByxVyjRgBszwBChtXxkFC08fJJygOC0KXji8SRq+7CAG5zlaH188RxrCg41Jo5t6Q
         NcmXJJE2c2NqOyavjUTVDBLw7otew8LPg8siXY3JolAhDwi1cnROo+C0cuomGRZ75/5g
         a2Zio2ZQfFXEnDy1ipzaDwHk/pEDHj8mbnwTwVPSHertyGLAycqawysfmr9oreXJVjmU
         mt2W04BMoRSMJCQcIFzoOv04xWNS28JEMSARsWdrQ5N/57MoGNDP83Cq2SHgwzlYo7GQ
         eLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777486824; x=1778091624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J9M0B+brb4So2TiCU6ZP3BLVOwtv02uBu/D6HTKzFiw=;
        b=mQNYjdxH1rJfJVhtme/1XBIA4WlHU0pwz4HU0B+SM47PVb6bVCeWVwR8hFmXnd6hfx
         gzQ+GG1r885zV1vXq8ygNKN4r7FZBqTTdYC74AK4eJ20BfrrtSTPa+c7QKbGLird2UW1
         heWTTnkwMfaS750MBbqchJUEX76NXvqZTTu9RyXlTSkZI8gGpKceM19+AmI/a4y0Ay/j
         wRe/V4G8LcHRA62Oj1x+pBWoDElOsvvre52ilv8raI+xLg6E6O9AP+pfTKEh08RFRxsR
         uIyGyh1iRyLm57YZ6Ma+jofGd16HIXT8cxRzar1JJXfzVv/5dCln8CME2+MAOxJzcRCw
         al4w==
X-Forwarded-Encrypted: i=1; AFNElJ/kL61rG+POJL+F8h/Czx6/yB03SU+etJl3Gw773zn3v0OBWbg8yYIzoEbJB31dBSymOXjeMIH9lQ==@kvack.org
X-Gm-Message-State: AOJu0YzjbCJakyy+s4/wNHlR1E3HXxItF4s73lyJcu6teaxaod0hGTb5
	D2k6jHYVQu6Qz/GQTsXpuzG6SS1KV/vJJnaoTSoIIV1l0Vvf8JnVPqEOEs9uCUtrN/Dq2rvS3+K
	j6x27dY5VPH2bWmPKMM7SEqAosmG5SyHCZK1cG6hPaUslQ7+wq9b1LEaY
X-Gm-Gg: AeBDiesLAr2mmKyq4ZWACkCHZb1bJJvMxStshMgdudLAIaR/qj+pBiX5HWuAQFazi0K
	oxXql94TQIoqMQoQbBDmi8IgplGsscOQVmGwMcBBzlmTFUcNOGF+UGO8pHiw8Iq0mGV+q1pSb5S
	nq4WXEwaTQ34fxvuglUz4H3Z/qxBzSZgW2noIf1esVqGdikT5CVYEysLjQCPGAgyOUNS4cEIsYW
	6nShY8RMjWeZutjVkelQhvHguwMySMntyOs5NT7esLOlPGufuC+GEKH0M/Vrrx0YHlG42iZZkzo
	cIbe2AaNgT+w23LocmfUvvX+OAdaOGjUsgTjEbt1yVjF2joyQXQwVue1gB+TqjX6wcJanQ==
X-Received: by 2002:ac8:5e14:0:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-51028fc6372mr632201cf.9.1777486822925; Wed, 29 Apr 2026
 11:20:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260423083756.157902-1-hao.ge@linux.dev> <CAJuCfpEy=rDFRhS+X-a5t-UquPi7veMRmyZzxR_9Z-WKagwFaw@mail.gmail.com>
 <b4735edb-55f9-4562-a0d0-a10e1788979a@linux.dev> <CAJuCfpHNgajyeYf5NFQL+4uLb57xw979Bf1Neqx2_u0=7NLJew@mail.gmail.com>
 <0563248b-25e6-4ed2-b528-d1d0345c856d@linux.dev>
In-Reply-To: <0563248b-25e6-4ed2-b528-d1d0345c856d@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Apr 2026 11:20:10 -0700
X-Gm-Features: AVHnY4IXEj2ngJ9GlzZ3e4pNGBAF4NPSx5AHy7kLs-cf1Mes54SfeIsWPT6w0JQ
Message-ID: <CAJuCfpF7HW9=BYd5yWoWGMrx=Q7HSiHqaEmUVg5aw0O9qYzwdw@mail.gmail.com>
Subject: Re: [PATCH v3] mm/alloc_tag: replace fixed-size early PFN array with
 dynamic linked list
To: Hao Ge <hao.ge@linux.dev>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A3E6BA0004
X-Stat-Signature: 7crp46bjzufsx1mh73bra4dr8bpdig3d
X-Rspam-User: 
X-HE-Tag: 1777486824-651651
X-HE-Meta: U2FsdGVkX19djFaFP82+tDL2CqjgF0m75+85HVjnQ0B2f9NRuhv+K+gBwn2x1S97FjjcW5w8UnxEWJHCgqpKHNX/jcTPJWsuLRORoQvIM1cGVHNgeo27LbkigaSphq1NHMuDa8PhRb0VXDWLANEPCAYt+ipsuBBhqABh2Kgm9eMUDgswrGaC7NdrFlRjx2Efcv7Ij4jKpfWR36h6zn8YPxdNn9Yn1Mz+Q0hF0f2DWPT06uHMbIUruZCstscYbFdIJtTOQrzEJ42SixCLV2CyVmAPo3Qyh1a81FEbN/t3zAFaVlFUS+XRyCCBMDzZ1kJFnPR2NFVz/mnr5ltPANqnsiBMXr0H5oxG8vQDhJ/i2pR1ucIeKmlrqE7drlkJpHgz4sMuSiAX1qdEqz65aqJTKr/W8+47g5bpceJvbi4WZcVgeyuVVfrtxNQEX+/2YEkcebWZIO1rf20AVnu9NMb1GL/aFfGSsTTvYv0Xb+C7SxsEjhoPtWDnV9vJqnYD46PIfhP+OZeV+onvVT+4ZC64LybyKmnIQi3HuyPTFboQNemxhnNcoki2/5vGGhhWbqZrxSweeVL21FtDGYxGWmJYrL2ocU2w9wfAI3anFD3Ej567EYQoqgDBlP5k4uR9BCggCBs5qSBLlrL7qo+BroHri8YsC5NC5Re8EslaulTMkxwoSrgdYsQJDqkcAlpuYXIFjmVRNiiSnZ0hdyN7j4LfUS/ZYhVopP8eO/vtdalCXfm6IHJPEBun467hwL3Y7uCeXzwGh8k2oIXv5yV4WxsBLfIumh9hfmf+eVqd1419u8GLwByiep4o8EwIWRyn8uFExso3kPucKpxhrAYmfid3Nplko/8rh/Ye5lkQC5uH5zsWakS1m73MMoNVzu+IpUvia3/9b9y/1I7lwTEJM+DPNPLBzlgI5vDqEicJ7CZPIvvtINUgE9kF/xxvT0qmpgrngme41u2NWyrjmxSg2ME
 VqVHyksJ
 Rr8dLaIUjvAtEW3KKtpg2Dx1fYivuEhJ0i20oy/LtGOepRQEySZH4VeIvS5jM3hI9O5gGRNvk6dTKK50gFlaxwmrbz0Pyus2rw9df5ESb68sCsqWKGD70hp6EagBfqZntdDNrOmti4cydh+GjtPOoYvQQtQiwhhBRca4DjxaoR/cspZ5jdjD2RbEDZz4KaaTJL0kUwS2npzULyZHG8DE7/vEJWDrcwDwDYmZFsl8igq10jPBW5f2zCE20mdQnaMs908fdnQKqkgSiwToX12Us6cCPLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 12:04=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/4/29 13:47, Suren Baghdasaryan wrote:
> > On Mon, Apr 27, 2026 at 8:01=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >> Hi Suren
> >>
> >>
> >> Thanks a lot for your review and suggestions.
> >>
> >>
> >> On 2026/4/28 00:02, Suren Baghdasaryan wrote:
> >>> On Thu, Apr 23, 2026 at 1:39=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wro=
te:
> >>>> Pages allocated before page_ext is available have their codetag left
> >>>> uninitialized. Track these early PFNs and clear their codetag in
> >>>> clear_early_alloc_pfn_tag_refs() to avoid "alloc_tag was not set"
> >>>> warnings when they are freed later.
> >>>>
> >>>> Currently a fixed-size array of 8192 entries is used, with a warning=
 if
> >>>> the limit is exceeded. However, the number of early allocations depe=
nds
> >>>> on the number of CPUs and can be larger than 8192.
> >>>>
> >>>> Replace the fixed-size array with a dynamically allocated linked lis=
t
> >>>> of pages. Each page stores PFNs in its page body and uses page->lru
> >>>> to link to the next page, with page->private tracking the number of
> >>>> used slots.
> >>>>
> >>>> The list pages themselves are allocated via alloc_page(), which woul=
d
> >>>> trigger __pgalloc_tag_add() -> alloc_tag_add_early_pfn() and recurse
> >>>> indefinitely. Introduce __GFP_NO_CODETAG (reuses the %__GFP_NO_OBJ_E=
XT
> >>>> bit) and pass gfp_flags through pgalloc_tag_add() so that the early =
path
> >>>> can skip recording allocations that carry this flag.
> >>>>
> >>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>>> ---
> >>>> v3:
> >>>> - Simplify linked list: use page->lru for chaining and page->private=
 as
> >>>>     slot counter, removing the early_pfn_node struct and freelist (s=
uggested
> >>>>     by Suren Baghdasaryan)
> >>>> - Pass gfp_flags through alloc_tag_add_early_pfn() but strip
> >>>>     __GFP_DIRECT_RECLAIM instead of selecting GFP_KERNEL/GFP_ATOMIC,
> >>>>     because __alloc_tag_add_early_pfn() is invoked under rcu_read_lo=
ck().
> >>>>
> >>>> v2:
> >>>> - Use cmpxchg to atomically update early_pfn_pages, preventing page =
leak under concurrent allocation
> >>>> - Pass gfp_flags through the full call chain and use gfpflags_allow_=
blocking()
> >>>>     to select GFP_KERNEL vs GFP_ATOMIC, avoiding unnecessary GFP_ATO=
MIC in process context
> >>>> ---
> >>>>    include/linux/alloc_tag.h |  22 ++++++-
> >>>>    lib/alloc_tag.c           | 118 +++++++++++++++++++++------------=
-----
> >>>>    mm/page_alloc.c           |  23 ++++----
> >>>>    3 files changed, 97 insertions(+), 66 deletions(-)
> >>>>
> >>>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >>>> index 02de2ede560f..ce9b478033bf 100644
> >>>> --- a/include/linux/alloc_tag.h
> >>>> +++ b/include/linux/alloc_tag.h
> >>>> @@ -150,6 +150,23 @@ static inline struct alloc_tag_counters alloc_t=
ag_read(struct alloc_tag *tag)
> >>>>    }
> >>>>
> >>>>    #ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>>> +/*
> >>>> + * Skip early PFN recording for a page allocation.  Reuses the
> >>>> + * %__GFP_NO_OBJ_EXT bit.  Used by __alloc_tag_add_early_pfn() to a=
void
> >>>> + * recursion when allocating pages for the early PFN tracking list
> >>>> + * itself.
> >>>> + *
> >>>> + * Callers must set the codetag to CODETAG_EMPTY (via
> >>>> + * clear_page_tag_ref()) before freeing pages allocated with this
> >>>> + * flag once page_ext becomes available, otherwise
> >>>> + * alloc_tag_sub_check() will trigger a warning.
> >>> nit: Callers must... sounds like someone who uses
> >>> __alloc_tag_add_early_pfn() has to do something extra, however
> >>> clear_page_tag_ref() is done by clear_early_alloc_pfn_tag_refs(), so
> >>> callers don't really need to do this. I suggest rephrasing as:
> >>>
> >>> Codetags of the pages allocated with __GFP_NO_CODETAG should be
> >>> cleared (via clear_page_tag_ref()) before freeing the pages to preven=
t
> >>> alloc_tag_sub_check() from triggering a warning.
> >> That's reasonable.
> >>
> >> I will adjust the wording in v2.
> >>>> + */
> >>>> +#define __GFP_NO_CODETAG       __GFP_NO_OBJ_EXT
> >>>> +
> >>>> +static inline bool should_record_early_pfn(gfp_t gfp_flags)
> >>>> +{
> >>>> +       return !(gfp_flags & __GFP_NO_CODETAG);
> >>>> +}
> >>>>    static inline void alloc_tag_add_check(union codetag_ref *ref, st=
ruct alloc_tag *tag)
> >>>>    {
> >>>>           WARN_ONCE(ref && ref->ct && !is_codetag_empty(ref),
> >>>> @@ -163,11 +180,12 @@ static inline void alloc_tag_sub_check(union c=
odetag_ref *ref)
> >>>>    {
> >>>>           WARN_ONCE(ref && !ref->ct, "alloc_tag was not set\n");
> >>>>    }
> >>>> -void alloc_tag_add_early_pfn(unsigned long pfn);
> >>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags);
> >>>>    #else
> >>>>    static inline void alloc_tag_add_check(union codetag_ref *ref, st=
ruct alloc_tag *tag) {}
> >>>>    static inline void alloc_tag_sub_check(union codetag_ref *ref) {}
> >>>> -static inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> >>>> +static inline void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t=
 gfp_flags) {}
> >>>> +static inline bool should_record_early_pfn(gfp_t gfp_flags) { retur=
n false; }
> >>>>    #endif
> >>>>
> >>>>    /* Caller should verify both ref and tag to be valid */
> >>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>> index ed1bdcf1f8ab..a00dc5a867e4 100644
> >>>> --- a/lib/alloc_tag.c
> >>>> +++ b/lib/alloc_tag.c
> >>>> @@ -766,45 +766,49 @@ static __init bool need_page_alloc_tagging(voi=
d)
> >>>>     * Some pages are allocated before page_ext becomes available, le=
aving
> >>>>     * their codetag uninitialized. Track these early PFNs so we can =
clear
> >>>>     * their codetag refs later to avoid warnings when they are freed=
.
> >>>> - *
> >>>> - * Early allocations include:
> >>>> - *   - Base allocations independent of CPU count
> >>>> - *   - Per-CPU allocations (e.g., CPU hotplug callbacks during smp_=
init,
> >>>> - *     such as trace ring buffers, scheduler per-cpu data)
> >>>> - *
> >>>> - * For simplicity, we fix the size to 8192.
> >>>> - * If insufficient, a warning will be triggered to alert the user.
> >>>> - *
> >>>> - * TODO: Replace fixed-size array with dynamic allocation using
> >>>> - * a GFP flag similar to ___GFP_NO_OBJ_EXT to avoid recursion.
> >>>>     */
> >>>> -#define EARLY_ALLOC_PFN_MAX            8192
> >>>> +#define EARLY_PFNS_PER_PAGE            (PAGE_SIZE / sizeof(unsigned=
 long))
> >>>>
> >>>> -static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> >>>> -static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> >>>> +static struct page *early_pfn_current __initdata;
> >>> So, instead of using early_pfn_current as the head page and then
> >>> page->lru.next directly, I would suggest having "struct llist_head
> >>> early_pfn_head;" as the list head and either using page->pcp_llist to
> >>> link the pages or even better, adding a "struct llist_node llist;"
> >>> into the union containing "struct list_head lru;". Note that
> >>> llist_add() uses try_cmpxchg(), so the link addition is atomic.
> >> Adding a struct llist_node into the page union only for the
> >> CONFIG_MEM_ALLOC_PROFILING_DEBUG feature,
> >>
> >> which may not be quite appropriate from a design perspective.
> >>
> >>> And you should probably use folios rather than pages to follow the ne=
w trends.
> >>>
> >>>> -static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >>>> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp=
_t gfp_flags)
> >>>>    {
> >>>> -       int old_idx, new_idx;
> >>>> +       struct page *page;
> >>>> +       unsigned long idx;
> >>>>
> >>>>           do {
> >>>> -               old_idx =3D atomic_read(&early_pfn_count);
> >>>> -               if (old_idx >=3D EARLY_ALLOC_PFN_MAX) {
> >>>> -                       pr_warn_once("Early page allocations before =
page_ext init exceeded EARLY_ALLOC_PFN_MAX (%d)\n",
> >>>> -                                     EARLY_ALLOC_PFN_MAX);
> >>>> -                       return;
> >>>> +               page =3D READ_ONCE(early_pfn_current);
> >>>> +               if (!page || READ_ONCE(page->private) >=3D EARLY_PFN=
S_PER_PAGE) {
> >>>> +                       gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECL=
AIM;
> >>>> +                       struct page *new =3D alloc_page(gfp | __GFP_=
NO_CODETAG);
> >>>> +
> >>>> +                       if (!new) {
> >>>> +                               pr_warn_once("early PFN tracking pag=
e allocation failed\n");
> >>>> +                               return;
> >>>> +                       }
> >>>> +                       new->lru.next =3D (struct list_head *)page;
> >>>> +                       if (cmpxchg(&early_pfn_current, page, new) !=
=3D page) {
> >>>> +                               __free_page(new);
> >>>> +                               continue;
> >>>> +                       }
> >>
> >> I also considered using llist_head initially.  like this
> >>
> >> static LLIST_HEAD(early_pfn_pages);
> >>
> >> static void __init __alloc_tag_add_early_pfn(unsigned long pfn, gfp_t
> >> gfp_flags)
> >> {
> >>           struct page *page;
> >>           unsigned long idx;
> >>
> >>           do {
> >>                   page =3D llist_first(&early_pfn_pages);
> >>                   if (!page || READ_ONCE(page->private) >=3D
> >> EARLY_PFNS_PER_PAGE) {
> >>                           gfp_t gfp =3D gfp_flags & ~__GFP_DIRECT_RECL=
AIM;
> >>                           struct page *new =3D alloc_page(gfp |
> >> __GFP_NO_CODETAG);
> >>
> >>                           if (!new) {
> >>                                   pr_warn_once("early PFN tracking pag=
e
> >> allocation failed\n");
> >>                                   return;
> >>                           }
> >>                           new->private =3D 0;
> >>                           llist_add(&new->pcp_llist, &early_pfn_pages)=
;
> >>                           page =3D new;
> >>                   }
> >>                   idx =3D READ_ONCE(page->private);
> >>                   if (idx >=3D EARLY_PFNS_PER_PAGE)
> >>                           continue;
> >>                   if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx=
)
> >>                           break;
> >>           } while (1);
> >>
> >>           ((unsigned long *)page_address(page))[idx] =3D pfn;
> >> }
> >>
> >>
> >> The problem is that llist_add() retries internally until it succeeds.
> >>
> >> When multiple CPUs concurrently see that the head page is NULL or full=
 ,
> >>
> >> they each allocate a new tracking page and all insertions succeed:
> >>
> >> CPU0: head page A is full or NULL, allocates B, llist_add(B) =E2=86=92=
 head=3DB=E2=86=92A
> >>
> >> CPU1: head page A is full or NULL, allocates C, llist_add(C) =E2=86=92=
 head=3DC=E2=86=92B=E2=86=92A
> >>
> >> CPU0: claims slot 0 in B
> >>
> >> CPU1: claims slot 0 in C
> >>
> >> Now the head is C. Once C fills up, a new page D is allocated and
> >> becomes the new head. But B still has ~511 unused slots and will never
> >>
> >> be the head again =E2=80=94 we only ever look at llist_first(). Those =
slots are
> >> permanently wasted.
> >>
> >> That's why I used struct page *early_pfn_current with direct cmpxchg =
=E2=80=94
> >> the loser frees its page and retries, avoiding the waste.
> >>
> >> That said, I may be missing something. Is there a way to use llist tha=
t
> >> avoids this? I'd appreciate your thoughts.
> > No, I think you are right, that retry logic in llist_add() does not
> > work for our case. I think the code you have works, but the way it
> > uses page attributes is kinda hacky and confusing. If we have to open
> > code the linked list handling then maybe just do this:
> >
> > struct pfn_arr_hdr {
> >      struct pfn_arr *next;
> >      atomic_t count;
> > };
> >
> > #define PFN_ARR_SIZE ((PAGE_SIZE - sizeof(struct pfn_arr_hdr)) /
> > sizeof(unsigned long))
> >
> > struct pfn_arr {
> >      struct pfn_arr_hdr hdr;
> >      unsigned long pfns[PFN_ARR_SIZE];
> > };
> >
> > So, instead of allocating pages, you use kmalloc() to allocate struct
> > pfn_arr and fill pfn_arr.pfns until it's full using pfn_arr.hdr.count
> > to track the array size. When current pfn_arr is full, you allocate a
> > new pfn_arr and link them via pfn_arr.hdr.next atomically, the way you
> > are doing with pages. That seems cleaner to me. WDYT?
>
> Actually, using kmalloc() would not be safe either, as page allocations
> can occur before kmalloc() becomes available.

I see.

>
> For example:
>
> memblock_free_all()       =E2=86=90 buddy allocator ready
>
> mem_init()
>
>      preallocate_vmalloc_pages()
>
>          p4d_alloc() / pud_alloc()
>
>              alloc_pages() -> triggers alloc_tag_add_early_pfn()
>
> kmem_cache_init() -> kmalloc becomes available
>
> Using alloc_page() is the safest choice =E2=80=94 the very fact that we r=
each
> alloc_tag_add_early_pfn() means a page allocation via the buddy
>
> allocator has already succeeded, so the buddy allocator is guaranteed to
> be ready.
>
> How about keeping alloc_page() but mapping the page body to a proper stru=
ct?
>
> struct pfn_pool {
>
>      struct pfn_pool *next;
>
>      atomic_t count;
>
>      unsigned long pfns[];
>
> };
>
> The first few bytes of the page hold metadata (next pointer and slot
> count), the remainder stores PFNs.
>
> WDYT?

Yeah, that sounds good to me.

>
> Thanks.
>
> Best regards.
>
> Hao
>
> >
> >>
> >>>> +                       page =3D new;
> >>>>                   }
> >>>> -               new_idx =3D old_idx + 1;
> >>>> -       } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new=
_idx));
> >>>> +               idx =3D READ_ONCE(page->private);
> >>>> +               if (idx >=3D EARLY_PFNS_PER_PAGE)
> >>>> +                       continue;
> >>>> +               if (cmpxchg(&page->private, idx, idx + 1) !=3D idx)
> >>>> +                       continue;
> >>>> +               break;
> >>> nit: This would read more easily:
> >>>
> >>>                  if (cmpxchg(&page->private, idx, idx + 1) =3D=3D idx=
)
> >>>                           break;
> >> will fix in the next version.
> >>>> +       } while (1);
> >>>>
> >>>> -       early_pfns[old_idx] =3D pfn;
> >>>> +       ((unsigned long *)page_address(page))[idx] =3D pfn;
> >>>>    }
> >>>>
> >>>> -typedef void alloc_tag_add_func(unsigned long pfn);
> >>>> +typedef void alloc_tag_add_func(unsigned long pfn, gfp_t gfp_flags)=
;
> >>>>    static alloc_tag_add_func __rcu *alloc_tag_add_early_pfn_ptr __re=
fdata =3D
> >>>>           RCU_INITIALIZER(__alloc_tag_add_early_pfn);
> >>>>
> >>>> -void alloc_tag_add_early_pfn(unsigned long pfn)
> >>>> +void alloc_tag_add_early_pfn(unsigned long pfn, gfp_t gfp_flags)
> >>>>    {
> >>>>           alloc_tag_add_func *alloc_tag_add;
> >>>>
> >>>> @@ -814,13 +818,14 @@ void alloc_tag_add_early_pfn(unsigned long pfn=
)
> >>>>           rcu_read_lock();
> >>>>           alloc_tag_add =3D rcu_dereference(alloc_tag_add_early_pfn_=
ptr);
> >>>>           if (alloc_tag_add)
> >>>> -               alloc_tag_add(pfn);
> >>>> +               alloc_tag_add(pfn, gfp_flags);
> >>>>           rcu_read_unlock();
> >>>>    }
> >>>>
> >>>>    static void __init clear_early_alloc_pfn_tag_refs(void)
> >>>>    {
> >>>> -       unsigned int i;
> >>>> +       struct page *page, *next;
> >>>> +       unsigned long i;
> >>>>
> >>>>           if (static_key_enabled(&mem_profiling_compressed))
> >>>>                   return;
> >>>> @@ -829,37 +834,42 @@ static void __init clear_early_alloc_pfn_tag_r=
efs(void)
> >>>>           /* Make sure we are not racing with __alloc_tag_add_early_=
pfn() */
> >>>>           synchronize_rcu();
> >>>>
> >>>> -       for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> >>>> -               unsigned long pfn =3D early_pfns[i];
> >>>> -
> >>>> -               if (pfn_valid(pfn)) {
> >>>> -                       struct page *page =3D pfn_to_page(pfn);
> >>>> -                       union pgtag_ref_handle handle;
> >>>> -                       union codetag_ref ref;
> >>>> -
> >>>> -                       if (get_page_tag_ref(page, &ref, &handle)) {
> >>>> -                               /*
> >>>> -                                * An early-allocated page could be =
freed and reallocated
> >>>> -                                * after its page_ext is initialized=
 but before we clear it.
> >>>> -                                * In that case, it already has a va=
lid tag set.
> >>>> -                                * We should not overwrite that vali=
d tag with CODETAG_EMPTY.
> >>>> -                                *
> >>>> -                                * Note: there is still a small race=
 window between checking
> >>>> -                                * ref.ct and calling set_codetag_em=
pty(). We accept this
> >>>> -                                * race as it's unlikely and the ext=
ra complexity of atomic
> >>>> -                                * cmpxchg is not worth it for this =
debug-only code path.
> >>>> -                                */
> >>>> -                               if (ref.ct) {
> >>>> +       for (page =3D early_pfn_current; page; page =3D next) {
> >>>> +               for (i =3D 0; i < page->private; i++) {
> >>>> +                       unsigned long pfn =3D ((unsigned long *)page=
_address(page))[i];
> >>> This page_address() can be done in the outer loop since the page does
> >>> not change inside the inner loop.
> >> will fix in the next version.
> >>>> +
> >>>> +                       if (pfn_valid(pfn)) {
> >>>> +                               union pgtag_ref_handle handle;
> >>>> +                               union codetag_ref ref;
> >>>> +
> >>>> +                               if (get_page_tag_ref(pfn_to_page(pfn=
), &ref, &handle)) {
> >>>> +                                       /*
> >>>> +                                        * An early-allocated page c=
ould be freed and reallocated
> >>>> +                                        * after its page_ext is ini=
tialized but before we clear it.
> >>>> +                                        * In that case, it already =
has a valid tag set.
> >>>> +                                        * We should not overwrite t=
hat valid tag
> >>>> +                                        * with CODETAG_EMPTY.
> >>>> +                                        *
> >>>> +                                        * Note: there is still a sm=
all race window between checking
> >>>> +                                        * ref.ct and calling set_co=
detag_empty(). We accept this
> >>>> +                                        * race as it's unlikely and=
 the extra complexity of atomic
> >>>> +                                        * cmpxchg is not worth it f=
or this debug-only code path.
> >>>> +                                        */
> >>>> +                                       if (ref.ct) {
> >>>> +                                               put_page_tag_ref(han=
dle);
> >>>> +                                               continue;
> >>>> +                                       }
> >>>> +
> >>>> +                                       set_codetag_empty(&ref);
> >>>> +                                       update_page_tag_ref(handle, =
&ref);
> >>>>                                           put_page_tag_ref(handle);
> >>>> -                                       continue;
> >>>>                                   }
> >>>> -
> >>>> -                               set_codetag_empty(&ref);
> >>>> -                               update_page_tag_ref(handle, &ref);
> >>>> -                               put_page_tag_ref(handle);
> >>>>                           }
> >>>>                   }
> >>>>
> >>>> +               next =3D (struct page *)page->lru.next;
> >>>> +               clear_page_tag_ref(page);
> >>>> +               __free_page(page);
> >>>>           }
> >>>>    }
> >>>>    #else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>> index 04494bc2e46f..5b7b234967a5 100644
> >>>> --- a/mm/page_alloc.c
> >>>> +++ b/mm/page_alloc.c
> >>>> @@ -1284,7 +1284,7 @@ void __clear_page_tag_ref(struct page *page)
> >>>>    /* Should be called only if mem_alloc_profiling_enabled() */
> >>>>    static noinline
> >>>>    void __pgalloc_tag_add(struct page *page, struct task_struct *tas=
k,
> >>>> -                      unsigned int nr)
> >>>> +                      unsigned int nr, gfp_t gfp_flags)
> >>>>    {
> >>>>           union pgtag_ref_handle handle;
> >>>>           union codetag_ref ref;
> >>>> @@ -1294,21 +1294,24 @@ void __pgalloc_tag_add(struct page *page, st=
ruct task_struct *task,
> >>>>                   update_page_tag_ref(handle, &ref);
> >>>>                   put_page_tag_ref(handle);
> >>>>           } else {
> >>>> -               /*
> >>>> -                * page_ext is not available yet, record the pfn so =
we can
> >>>> -                * clear the tag ref later when page_ext is initiali=
zed.
> >>>> -                */
> >>>> -               alloc_tag_add_early_pfn(page_to_pfn(page));
> >>>> +
> >>>>                   if (task->alloc_tag)
> >>>>                           alloc_tag_set_inaccurate(task->alloc_tag);
> >>>> +
> >>>> +               /*
> >>>> +                * page_ext is not available yet, record the pfn so =
the
> >>>> +                * tag ref can be cleared later when page_ext is ini=
tialized.
> >>>> +                */
> >>>> +               if (should_record_early_pfn(gfp_flags))
> >>>> +                       alloc_tag_add_early_pfn(page_to_pfn(page), g=
fp_flags);
> >>> Any reason for changing the order of alloc_tag_add_early_pfn() and
> >>> alloc_tag_set_inaccurate()? I liked the previous version where we
> >>> explain why this is done at the very beginning of the block. You coul=
d
> >>> also call should_record_early_pfn() from inside
> >>> alloc_tag_add_early_pfn(), which would keep both
> >>> should_record_early_pfn() and __GFP_NO_CODETAG definitions local to
> >>> alloc_tag.c.
> >>>
> >> will fix in the next version.
> >>
> >> Thanks
> >>
> >> Best regards.
> >>
> >> Hao
> >>
> >>>>           }
> >>>>    }
> >>>>
> >>>>    static inline void pgalloc_tag_add(struct page *page, struct task=
_struct *task,
> >>>> -                                  unsigned int nr)
> >>>> +                                  unsigned int nr, gfp_t gfp_flags)
> >>>>    {
> >>>>           if (mem_alloc_profiling_enabled())
> >>>> -               __pgalloc_tag_add(page, task, nr);
> >>>> +               __pgalloc_tag_add(page, task, nr, gfp_flags);
> >>>>    }
> >>>>
> >>>>    /* Should be called only if mem_alloc_profiling_enabled() */
> >>>> @@ -1341,7 +1344,7 @@ static inline void pgalloc_tag_sub_pages(struc=
t alloc_tag *tag, unsigned int nr)
> >>>>    #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>>>
> >>>>    static inline void pgalloc_tag_add(struct page *page, struct task=
_struct *task,
> >>>> -                                  unsigned int nr) {}
> >>>> +                                  unsigned int nr, gfp_t gfp_flags)=
 {}
> >>>>    static inline void pgalloc_tag_sub(struct page *page, unsigned in=
t nr) {}
> >>>>    static inline void pgalloc_tag_sub_pages(struct alloc_tag *tag, u=
nsigned int nr) {}
> >>>>
> >>>> @@ -1896,7 +1899,7 @@ inline void post_alloc_hook(struct page *page,=
 unsigned int order,
> >>>>
> >>>>           set_page_owner(page, order, gfp_flags);
> >>>>           page_table_check_alloc(page, order);
> >>>> -       pgalloc_tag_add(page, current, 1 << order);
> >>>> +       pgalloc_tag_add(page, current, 1 << order, gfp_flags);
> >>>>    }
> >>>>
> >>>>    static void prep_new_page(struct page *page, unsigned int order, =
gfp_t gfp_flags,
> >>>> --
> >>>> 2.25.1
> >>>>

