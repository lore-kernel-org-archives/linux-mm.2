Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07221CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2D26B0092; Wed, 14 Oct 2026 13:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08A5D6B0095; Wed, 14 Oct 2026 13:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBB5D6B0096; Wed, 14 Oct 2026 13:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B88566B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:18:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51C0AA83AE
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:18:17 +0000 (UTC)
X-FDA: 85321890234.20.45C5EB7
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5934240005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:18:15 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lHXhXUQe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791998295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dIx1C4EloGYzW+nfRM67Y+aOezqQQiy8pPph6WWQ/g=;
	b=dESWXh5JXhWtQYceCoOU8tAeN0myBxTaU5xGQdG0NwMwNVTLGLWTs/XBdYrasqqgj7xwgw
	8gZE8XGc4EyeiGpIG+dY4lyPfQWVbvDyFSEBMASW3HsuG5aYsgvHnnAIIk09RIZUq6dBA0
	vNUvH+3omUVT53gNK0Zw0+ysQAjwbKg=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lHXhXUQe;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791998295;
	b=lRXjBzAHEkDcaHQ3tJ/gXr0OAIlJP8rygvEEVCVVROLVCbbwyWtNgkpL+djAsAzHtMC5D7
	gtmqAE+ysuiOKV4l/tqwBD4PAFTA5TEEpNT3XSjdy+8VSH6rinPl46lq4h2GYGnt/6kFWt
	taX5OTSr2pV2W2S115AYKiYVFROizaM=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2e8d6fcbba0so230895ad.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:18:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791998294; cv=none;
        d=google.com; s=arc-20260327;
        b=G6easfCvbQzsmhuxfA8PCyGHG21TGWt8eMa5yT6UB+X64rJ+ZVDOUvxWvnhpVp1GZ+
         fgUS059lm6jfgJhxi+vj2/3+qZosgmNLWy5c48PAYnOGn7O20sjTyOWSxyMI40CF2+Wl
         pKIuDbpIxkycIT6672hnydF+P0z2S+hanqISTg3oecHcZOtka4f00clWaVqtHbcfaBpU
         5frudIBtwMUECr+Pt+Li4pNPo6nWuEwLQIz07iLVyaMFoLB3uFw9EOIR1s/UcjdEpeLt
         B7ZziLIRpwhTGw+RxExGdsdeGfZV8f3iV8BQ3JY5FnaPRRXOWhltRBo4JTNhC0bgOKxj
         zBIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6dIx1C4EloGYzW+nfRM67Y+aOezqQQiy8pPph6WWQ/g=;
        fh=DOX22516wV3tpnCzQ+vJBjaA2DAIVB/62DlaPDtnCBw=;
        b=IgySID4CkVIUlFtVN9sF9AcK9/jdVIUEbKck14YUOVrcgcWFiD8lTXoHQgqD4aGqRi
         iPDi+hcnvyYSLMukNAvFJ1LVCeCXRWMHL/6gIA+zyxiBLKGMvKG/C7joJaDgFu5o+v8A
         3vHf0N6+tsr3F0Ls6iYCxrJhvhNMDpEWKTgvp4zIERYmHQ5Lsa19I5DFt5IlRy7bh7xl
         oS0MNEZHBadpnLfHhlVGGUHF6VHFF+Hw5ldHEUeahHv/NyPF9QzOpoLI4O9zJERToQVy
         iGqLCPw1xQ7U177G8cQ5lEuKdQrSbA1eicTzJ/hNyVUb+8BO2ZeytZgazdV1ONha2dML
         vspQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791998294; x=1792603094; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6dIx1C4EloGYzW+nfRM67Y+aOezqQQiy8pPph6WWQ/g=;
        b=lHXhXUQe/oVjJk7J/7z/pGeoM4llyBr0cTyyg41YLgEXg+DEZ+opGgxh/R3AWjnzvB
         VzVJ19iChZX0VTb6PXGkOpAxiT8DKpGd/2ho6CIfcLkxTL2pIq09D5GPwowDAm8j+EJm
         idThu4GuaEExTZgCqn8LVpshkVYQBub+ZPjLKzs9KSWwpnOkEbjjqz8OJ2LDjuK2jVyf
         vypFp0YD2AAggdqNcC424WqhMDVB1xa8VH0rKVRymro3/XlXe4m1GCTMCCuDbAoX62Qb
         0Z6iD7gMRHk9WWsrgE316ccaW6Mf1TKLsgk/K8FRB6U2uhNkT6gRUxOiOqR/J1xEinGY
         74qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791998294; x=1792603094;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6dIx1C4EloGYzW+nfRM67Y+aOezqQQiy8pPph6WWQ/g=;
        b=pDBfPcERatWzF/EvxYtM7xs2Z+uvAwTqrldsugCDPEoPyqU4g3hyZ0ylVouA0R1NKM
         gjomt3PutiJ0z9I8Hc3qmMWZwIeD/IAALb6ejuNgEcFPMWQPxrK6HJkuIiPA99yOJF03
         QcC53vdAiSGRA8IdmJtNH00Y+Mqv2P66w7eI+39uTn/ED/aG702KuhUrCYiRQ6q9k7ac
         Td7KFqZqhJU8z+RQDoM9EVQTTzhkqmL7yjhFWmOYdcZL5Ee1oxtDyKwltrygdI0n1/67
         M7ydNaADQnblfl6SfYliP3EMhp8h5EC8LhplrbudzA5x2AB8CEI/gkYEqAkuVwOYbGoZ
         nagg==
X-Forwarded-Encrypted: i=1; AKwUvBypEy7HoVZkm7OnfeqXhc58ntwmw8UUAaNKtp5XovznX4K9s/QaQ3yZKRAQU+02ZonvGi10XWb5Bw==@kvack.org
X-Gm-Message-State: AFq9FYJQmwLWoeNkomtGol7cXVoyaP4NSpxgOGpNpjM94uPjlXRildN6
	G5oITLu2o1QwH6VegvgzrRoPBtBCPprw+LU4CSwrPi2/61wflE3jmw7en/Dx1kDwyYFuW/jktVo
	l3asL9/lbGB4AuL2+b70u+uxjxXOtGB704rTESZpa
X-Gm-Gg: AYBFou2Il+TH0HE3RCRTaEFNsBudcqcrNhTLiaRy1yFvQVo3NoTHkSGUECX1S4t+iG+
	y1gyqXFcFm5W8x6pV6YFYSMtUXDU8HAnppZSkHRn0NeZtkbbHz4xDDV1NN9/DPSCHJtFcDLigNF
	puhQXbegFAAjojz+BMqx6nhVJCTyR/E4CZlNHKTwn/UuHeOMZ0qzViLY6OfaBhcSJvmApqFnmdc
	1tNawXpjos/UEf9sjSj/Zfcg4xZg8ERMsuhEfzoVhxnqrF7jN8KSFRar1xnfF67IypLEN7hLnDC
	R27AToDkoB1CnraNC3HkulooB8b9TVWmz3//3IUks2WaGHvcS7k/HraK2pOHjjDz+rKlEZBtv1V
	Ki91qCU3wXg==
X-Received: by 2002:a17:903:1a45:b0:2c7:f0cc:dafa with SMTP id
 d9443c01a7336-2e93db18c22mr3905245ad.5.1791998293306; Wed, 14 Oct 2026
 10:18:13 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
 <1f77364a04d0ae20cf07efaca779756f92ec39f6.1791410886.git.abhishekbapat@google.com>
 <ed833aa7-90fa-4c44-a423-c5b689ede379@linux.dev>
In-Reply-To: <ed833aa7-90fa-4c44-a423-c5b689ede379@linux.dev>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Wed, 14 Oct 2026 10:18:01 -0700
X-Gm-Features: AclHuK9_ZJEant9YLtPvLQQpoEuAfQFaZJ_s2_U_90RFLmNDNJrE-gyvYTX6yYk
Message-ID: <CAL41Mv6Kp9qLtPum36WaMpOtrmTG3LZoEXyD=s78DH+9ruKO7g@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] alloc_tag: Introduce IOCTLs to toggle allocation tracepoints
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5934240005
X-Rspam-User: 
X-Stat-Signature: bj78pwa7a4pbdy5x9st8xmwu4yeexr61
X-HE-Tag: 1791998295-338871
X-HE-Meta: U2FsdGVkX19akiEkGC638pKps4x7lwLFwLPN/XwxEAlT0APCm1K9C92ViE9hw8KkIO4rzKl3G+wuR4AkvAGqISIklnYV73YrBjpKC4EBK9o+umtm8vtji6IPfFOmF6jacQG9r+Yj+8JZ//CMp5xqum8KwgP9V7fp4u0ipBuvzL1kQm5wrfiPxOr71WRcrzst3Zg+oO/zdxErgiI4m4mnWSMtXk3DlztK1sFzDKs6M6Zxg9ZlVLdjkQpwKeKURrxQ6D1QWwm6x3wp1DRDTxZNQQH2Fyf/fkAnFbSo7mUKN6BslLnIs+I/OS3h0mjQIa+rnStphY3Stk1KLf07wc2okJjyG1cVMv3aS/UKxil4XKXgjUxweqTl5CFKK70LDIKo3lZPfkGtqFy93HFVBuRhe4hFep3Mz71iV1Hljkbx4ngW1w76mlDuqJg25Dnyg977Ju2cOatt5rHsGS9Ug9QlDKa2R7qa5ygrt8HuouHfJBU+gSPVyB9VRbYv8SiRpTHUO6VFHb5t2KUW7k3lFAFzOg3Ipngq69n4tTdzH/OVpx0F9vGyZ2l/+vE5gH0vk2+qWMYycVAWE8kaP32j1fnLIEwDIc434U6/Gzm4YOKEbE5ICrSBU3s6bvOMI0BMs8XNGDFGqgWEUUIlMP87xECaVTywFy28D6LoXAkoc1QnEut09HMeZPVclcmOn2/4WV2YkRXbZvCLeT1fT0KDTEv7BdZkE32219cKdH5/CaMi1cRJTqOPRQxEx3TcX9dvViS5xD0OU1mh3MCiflr0i98bJPnpne5pSeI5YjhCFLFmTGfOyD43ioMerINqsngFjOvHjHcCr2607j+KawPLFhTIPIHO3UTO+TTNMoIL8HlQN4dT05xM13mcGFU7wENGV9DhMWzkzTZUoK6RcJO11f3J6kTUgVNq70/HEytLWCVZriq/4rn6hA57jmJ+CfqcodXC+LCE8KkEhOw7C0U/2Pm
 u5xtCwIh
 WBtI8rJfLfddUZc28dOt2nq5+P7qpeN/YEZleAD7I49jN9glEVJmY0/AEDCn1KrGB17KlXVT87j2ftEVKitcg1+J1qLIO66m1ahbXqg3i4z8LHxkEHRjG5t+x64ZZXz6i3OTIP9YX5cT3GG7vFatNCTVSaQbIdRzQ6IfkOuaSHc3LOt9hGB59bGPUwcoUgiJObaH5+Jg4cz+oCRLVwA7xFypo/+SDmVTo9oSBLtyWNKbXQWMce4J/PF/dn2yQT1n01c63UwjmYdI164agTxKraP3ipTPDsNT5E4VPeSMPxrTCYFaNTaL4R64DBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 12:41=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Abhishek
>
>
> On 2026/10/8 06:40, Abhishek Bapat wrote:
> > Introduce a new IOCTL (`ALLOCINFO_IOC_TOGGLE_TRACE`) to selectively
> > toggle tracing on allocation call sites. Userspace tools can use the
> > existing filtering mechanism to specify the set of tags to toggle
> > tracing for.
> >
> > To facilitate low overhead execution for non-targeted call sites, add a
> > new `CODETAG_FLAG_TRACE_ON` flag to `struct codetag` to track per-site
> > activation. Protect these conditional branch evaluations using the glob=
al
> > `alloc_tag_trace_key` static branch and an inline static key check
> > pattern in the allocator hooks (`alloc_tag_add`, `alloc_tag_sub`, etc).
> > This ensures that the trace events are entirely skipped when no
> > allocation call sites are being actively traced, leaving only a NOP on
> > the allocation fast path.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > ---
> >  Documentation/mm/allocation-profiling.rst |  20 ++++
> >  include/linux/alloc_tag.h                 |  47 +++++---
> >  include/linux/codetag.h                   |   5 +-
> >  include/uapi/linux/alloc_tag.h            |  13 +++
> >  mm/alloc_tag.c                            | 128 ++++++++++++++++++++--
> >  5 files changed, 187 insertions(+), 26 deletions(-)
> >
> > diff --git a/Documentation/mm/allocation-profiling.rst b/Documentation/=
mm/allocation-profiling.rst
> > index b241450394df..63b668466342 100644
> > --- a/Documentation/mm/allocation-profiling.rst
> > +++ b/Documentation/mm/allocation-profiling.rst
> > @@ -149,6 +149,26 @@ expose the full call stack and the lifetime of ind=
ividual allocations:
> >  - slab and percpu: the address of the object's `codetag_ref`
> >  - page allocator: the `struct page` pointer of the head page
> >
> > +Events are only emitted for tags that have tracing turned on and while=
 profiling
> > +is enabled. When no tag is traced, the hooks are behind a static branc=
h.
> > +
> > +Enabling Tracing
> > +----------------
> > +
> > +Tracing is toggled on and off per tag with the `ALLOCINFO_IOC_TOGGLE_T=
RACE`
> > +ioctl on `/proc/allocinfo`. It takes the same filter as used by
> > +`ALLOCINFO_IOC_GET_AT`; an empty mask selects all tags. Size limits in=
 the
> > +filter are checked once, against the tag's size at the time of the cal=
l. Tags
> > +already in the requested state are skipped and a -ENOENT is returned i=
f no
> > +tag matched.
> > +
> > +Tracing is turned off for a module's tags when the module is unloaded.
> > +
> > +Memory allocated before a tag was enabled has no alloc event but will =
still
> > +produce a free event. Likewise, memory alive when tag is disabled will=
 not
> > +produce a free event. Tools should expect unmatched frees after enabli=
ng and
> > +missing frees after disabling.
> > +
> >  Correlating the events
> >  ----------------------
> >
> > diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> > index 49825177d8c8..94697b28053a 100644
> > --- a/include/linux/alloc_tag.h
> > +++ b/include/linux/alloc_tag.h
> > @@ -136,9 +136,36 @@ static inline bool mem_alloc_profiling_enabled(voi=
d)
> >                                  &mem_alloc_profiling_key);
> >  }
> >
> > -static inline bool alloc_tag_trace_enabled(void)
> > +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> >  {
> > -     return static_branch_unlikely(&alloc_tag_trace_key);
> > +     atomic_or(CODETAG_FLAG_INACCURATE, &tag->ct.flags);
> > +}
> > +
> > +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > +{
> > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_INACCURATE);
> > +}
> > +
> > +static inline void alloc_tag_set_traced(struct alloc_tag *tag)
> > +{
> > +     atomic_or(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > +}
> > +
> > +static inline void alloc_tag_clear_traced(struct alloc_tag *tag)
> > +{
> > +     atomic_andnot(CODETAG_FLAG_TRACE_ON, &tag->ct.flags);
> > +}
> > +
> > +static inline bool alloc_tag_is_traced(const struct alloc_tag *tag)
> > +{
> > +     return !!(atomic_read(&tag->ct.flags) & CODETAG_FLAG_TRACE_ON);
> > +}
> > +
> > +static inline bool alloc_tag_trace_enabled(const struct alloc_tag *tag=
)
> > +{
> > +     if (static_branch_unlikely(&alloc_tag_trace_key))
> > +             return tag && alloc_tag_is_traced(tag);
> > +     return false;
> >  }
> >
> >  void alloc_tag_trace_mem_alloc(const void *ptr, struct alloc_tag *tag,
> > @@ -151,7 +178,7 @@ void __alloc_tag_trace_hit(struct alloc_tag *tag);
> >
> >  static __always_inline void alloc_tag_trace_hit(struct alloc_tag *tag)
> >  {
> > -     if (alloc_tag_trace_enabled())
> > +     if (alloc_tag_trace_enabled(tag))
> >               __alloc_tag_trace_hit(tag);
> >  }
> >
> > @@ -225,7 +252,7 @@ static inline void alloc_tag_add(union codetag_ref =
*ref, struct alloc_tag *tag,
> >       if (likely(alloc_tag_ref_set(ref, tag))) {
> >               this_cpu_add(tag->counters->bytes, bytes);
> >
> > -             if (alloc_tag_trace_enabled())
> > +             if (alloc_tag_trace_enabled(tag))
> >                       /* Trace successful allocs with their unique ptr =
*/
> >                       alloc_tag_trace_mem_alloc(ptr, tag, bytes);
> >       }
> > @@ -249,23 +276,13 @@ static inline void alloc_tag_sub(union codetag_re=
f *ref, size_t bytes, const voi
> >       this_cpu_sub(tag->counters->bytes, bytes);
> >       this_cpu_dec(tag->counters->calls);
> >
> > -     if (alloc_tag_trace_enabled())
> > +     if (alloc_tag_trace_enabled(tag))
> >               /* Trace frees with their unique ptr */
> >               alloc_tag_trace_mem_free(ptr, tag, bytes);
> >
> >       ref->ct =3D NULL;
> >  }
> >
> > -static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> > -{
> > -     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> > -}
> > -
> > -static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> > -{
> > -     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> > -}
> > -
> >  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> >
> >  #else /* CONFIG_MEM_ALLOC_PROFILING */
> > diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> > index a25a085c2df1..f728295d50c0 100644
> > --- a/include/linux/codetag.h
> > +++ b/include/linux/codetag.h
> > @@ -18,6 +18,7 @@ struct module;
> >
> >  /* codetag flags */
> >  #define CODETAG_FLAG_INACCURATE      (1 << 0)
> > +#define CODETAG_FLAG_TRACE_ON        (1 << 1)
> >
> >  /*
> >   * An instance of this structure is created in a special ELF section a=
t every
> > @@ -25,7 +26,7 @@ struct module;
> >   * an array of these.
> >   */
> >  struct codetag {
> > -     unsigned int flags;
> > +     atomic_t flags;
> >       unsigned int lineno;
> >       const char *modname;
> >       const char *function;
> > @@ -71,7 +72,7 @@ struct codetag_iterator {
> >       .function       =3D __func__,                     \
> >       .filename       =3D __FILE__,                     \
> >       .lineno         =3D __LINE__,                     \
> > -     .flags          =3D 0,                            \
> > +     .flags          =3D ATOMIC_INIT(0),               \
> >  }
> >
> >  void codetag_lock_module_list(struct codetag_type *cttype);
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index 7d4618bea043..dafcba2f7e2c 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -85,9 +85,20 @@ struct allocinfo_get_at {
> >       struct allocinfo_tag_data data;
> >  };
> >
> > +struct allocinfo_toggle_traces {
> > +     /* inputs */
> > +     /*
> > +      * Tags matching the filter are toggled; an empty mask selects al=
l tags.
> > +      * Size criteria are checked once, against the tag's size at call=
 time.
> > +      */
> > +     struct allocinfo_filter filter;
> > +     __u64 enable;
> > +};
> > +
> >  #define _ALLOCINFO_IOC_CONTENT_ID    0
> >  #define _ALLOCINFO_IOC_GET_AT                1
> >  #define _ALLOCINFO_IOC_GET_NEXT              2
> > +#define _ALLOCINFO_IOC_TOGGLE_TRACE  3
> >
> >  #define ALLOCINFO_IOC_BASE           0xA6
> >  #define ALLOCINFO_IOC_CONTENT_ID     _IOR(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_CONTENT_ID,     \
> > @@ -96,5 +107,7 @@ struct allocinfo_get_at {
> >                                             struct allocinfo_get_at)
> >  #define ALLOCINFO_IOC_GET_NEXT               _IOR(ALLOCINFO_IOC_BASE, =
_ALLOCINFO_IOC_GET_NEXT,       \
> >                                            struct allocinfo_tag_data)
> > +#define ALLOCINFO_IOC_TOGGLE_TRACE   _IOW(ALLOCINFO_IOC_BASE, _ALLOCIN=
FO_IOC_TOGGLE_TRACE,   \
> > +                                         struct allocinfo_toggle_trace=
s)
> >
> >  #endif /* _UAPI_ALLOC_TAG_H */
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index ca2412a67312..262f00f2bba9 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -60,6 +60,15 @@ DEFINE_STATIC_KEY_FALSE(mem_profiling_compressed);
> >  DEFINE_STATIC_KEY_FALSE(alloc_tag_trace_key);
> >  EXPORT_SYMBOL(alloc_tag_trace_key);
> >
> > +static atomic_t alloc_tag_trace_cnt =3D ATOMIC_INIT(0);
> > +
> > +/*
> > + * As `codetag_lock_module_list` is a read lock, we need an additional=
 mutex
> > + * to protect against the race conditions involved in the alloc tag tr=
ace
> > + * toggle path.
> > + */
> > +static DEFINE_MUTEX(alloc_tag_trace_mutex);
> > +
> >  struct alloc_tag_kernel_section kernel_tags =3D { NULL, 0 };
> >  unsigned long alloc_tag_ref_mask;
> >  int alloc_tag_ref_offs;
> > @@ -296,7 +305,7 @@ static bool matches_filter(struct codetag *ct, stru=
ct allocinfo_filter *filter,
> >               return false;
> >
> >       if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
> > -             inaccurate =3D !!(ct->flags & CODETAG_FLAG_INACCURATE);
> > +             inaccurate =3D alloc_tag_is_inaccurate(ct_to_alloc_tag(ct=
));
> >               if (inaccurate !=3D !!(filter->inaccurate))
> >                       return false;
> >       }
> > @@ -317,6 +326,23 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter,
> >       return true;
> >  }
> >
> > +/*
> > + * Checks that a user supplied filter only uses known fields and that =
its size
> > + * range, if any, is not inverted.
> > + */
> > +static bool allocinfo_filter_valid(const struct allocinfo_filter *filt=
er)
> > +{
> > +     if (filter->mask & ~ALLOCINFO_FILTER_MASKS)
> > +             return false;
> > +
> > +     if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > +         (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > +         filter->min_size > filter->max_size)
> > +             return false;
> > +
> > +     return true;
> > +}
> > +
> >  /*
> >   * Seeks the ioctl iterator to the specified 0-indexed tag position, r=
eads its
> >   * profiling data and returns it to userspace.
> > @@ -333,12 +359,7 @@ static int allocinfo_ioctl_get_at(struct seq_file =
*m, void __user *arg)
> >       if (copy_from_user(&params, arg, sizeof(params)))
> >               return -EFAULT;
> >
> > -     if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > -             return -EINVAL;
> > -
> > -     if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
> > -         (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
> > -         params.filter.min_size > params.filter.max_size)
> > +     if (!allocinfo_filter_valid(&params.filter))
> >               return -EINVAL;
> >
> >       priv =3D m->private;
> > @@ -443,6 +464,75 @@ static int allocinfo_ioctl_get_next(struct seq_fil=
e *m, void __user *arg)
> >       return ret;
> >  }
> >
> > +static void alloc_tag_trace_toggle(struct alloc_tag *tag, bool enable)
> > +{
> > +     if (enable) {
> > +             if (alloc_tag_is_traced(tag))
> > +                     return;
> > +
> > +             alloc_tag_set_traced(tag);
> > +             if (atomic_fetch_inc(&alloc_tag_trace_cnt) =3D=3D 0)
> > +                     static_branch_enable(&alloc_tag_trace_key);
> > +     } else {
> > +             if (!alloc_tag_is_traced(tag))
> > +                     return;
> > +
> > +             alloc_tag_clear_traced(tag);
> > +             if (atomic_dec_and_test(&alloc_tag_trace_cnt))
> > +                     static_branch_disable(&alloc_tag_trace_key);
> > +     }
> > +}
> > +
> > +/*
> > + * Toggles tracing on every allocation tag that matches the user suppl=
ied
> > + * filter. An empty filter mask selects all tags, same as for
> > + * ALLOCINFO_IOC_GET_AT. Tags already in the requested state are not a=
n error.
> > + */
> > +static int allocinfo_ioctl_toggle_trace(struct seq_file *m, void __use=
r *arg)
> > +{
> > +     struct allocinfo_toggle_traces params;
> > +     struct codetag_iterator iter;
> > +     struct codetag *ct;
> > +     struct alloc_tag_counters counters;
> > +     bool fetched_counters;
> > +     int matches =3D 0, ret;
> > +
> > +     if (!capable(CAP_SYS_ADMIN))
> > +             return -EPERM;
> > +
> > +     if (copy_from_user(&params, arg, sizeof(params)))
> > +             return -EFAULT;
> > +
> > +     if (!allocinfo_filter_valid(&params.filter))
> > +             return -EINVAL;
> > +
> > +     codetag_lock_module_list(alloc_tag_cttype);
> > +
> > +     iter =3D codetag_get_ct_iter(alloc_tag_cttype);
> > +
> > +     /* Toggle tracing on all codetags that match */
> > +     while ((ct =3D codetag_next_ct(&iter))) {
> > +             fetched_counters =3D false;
> > +             if (matches_filter(ct, &params.filter, &counters, &fetche=
d_counters)) {
> > +                     matches++;
> > +
> > +                     mutex_lock(&alloc_tag_trace_mutex);
>
> Could we grab and drop alloc_tag_trace_mutex outside the loop?

Well, that is possible. But I did it this way to minimize the critical sect=
ion.

Since this mutex is specific to the trace ioctl, I'm comfortable doing
what you recommended too. It would just mean that one thread would be
blocked until another thread fully finishes its loop, which is not too
bad. I'll let Suren comment on this as well.
>
>
> > +                     alloc_tag_trace_toggle(ct_to_alloc_tag(ct), !!par=
ams.enable);
> > +                     mutex_unlock(&alloc_tag_trace_mutex);
> > +             }
> > +     }
> > +
> > +     if (matches =3D=3D 0)
> > +             /* Nothing matched the filter */
> > +             ret =3D -ENOENT;
> > +     else
> > +             ret =3D 0;
> > +
> > +     codetag_unlock_module_list(alloc_tag_cttype);
> > +
> > +     return ret;
> > +}
> > +
> >  /*
> >   * Entry point ioctl function for /proc/allocinfo routing requests to =
fetch the
> >   * layout content ID, seek to a specific tag, or read sequential tags.
> > @@ -463,6 +553,9 @@ static long allocinfo_ioctl(struct file *file, unsi=
gned int cmd,
> >       case ALLOCINFO_IOC_GET_NEXT:
> >               ret =3D allocinfo_ioctl_get_next(file->private_data, arg)=
;
> >               break;
> > +     case ALLOCINFO_IOC_TOGGLE_TRACE:
> > +             ret =3D allocinfo_ioctl_toggle_trace(file->private_data, =
arg);
> > +             break;
> >       default:
> >               ret =3D -ENOIOCTLCMD;
> >               break;
> > @@ -492,8 +585,6 @@ static const struct proc_ops allocinfo_proc_ops =3D=
 {
> >
> >  void __alloc_tag_trace_hit(struct alloc_tag *tag)
> >  {
> > -     if (unlikely(!tag))
> > -             return;
> >       trace_alloc_tag_hit(tag);
> >  }
> >  EXPORT_SYMBOL(__alloc_tag_trace_hit);
> > @@ -1031,6 +1122,24 @@ static int load_module(struct module *mod, struc=
t codetag *start, struct codetag
> >       return 0;
> >  }
> >
> > +static void unload_module(struct module *mod, struct codetag *start, s=
truct codetag *stop)
> > +{
> > +     struct alloc_tag *start_tag =3D ct_to_alloc_tag(start);
> > +     struct alloc_tag *stop_tag =3D ct_to_alloc_tag(stop);
> > +     struct alloc_tag *tag;
> > +
> > +     /*
> > +      * Turn tracing off for the tags of the module being unloaded. Wi=
thout
> > +      * this, `alloc_tag_trace_cnt` would never reach zero and tracing=
 would
> > +      * stay enabled forever.
> > +      *
> > +      * `alloc_tag_trace_mutex` is not needed here as this code path i=
s
> > +      * protected by a `down_write(&cttype->mod_lock)`.
> > +      */
> > +     for (tag =3D start_tag; tag < stop_tag; tag++)
> > +             alloc_tag_trace_toggle(tag, false);
> > +}
> > +
> >  static void replace_module(struct module *mod, struct module *new_mod)
> >  {
> >       MA_STATE(mas, &mod_area_mt, 0, module_tags.size);
> > @@ -1357,6 +1466,7 @@ static int __init alloc_tag_init(void)
> >               .alloc_section_mem      =3D reserve_module_tags,
> >               .free_section_mem       =3D release_module_tags,
> >               .module_load            =3D load_module,
> > +             .module_unload          =3D unload_module,
> >               .module_replaced        =3D replace_module,
> >  #endif
> >       };

