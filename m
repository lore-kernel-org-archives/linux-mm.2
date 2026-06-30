Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38ECEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:52:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E786B00BC; Tue, 30 Jun 2026 10:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274F46B00BD; Tue, 30 Jun 2026 10:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C2F6B00BE; Tue, 30 Jun 2026 10:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E221B6B00BC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C7FF1C6F61
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:52:40 +0000 (UTC)
X-FDA: 84936870480.10.E43246C
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 829F21C0003
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:52:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJli1j5C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782831158;
	b=7zomQEhRPR4upA85L9Qm0hBFCSUsfTZDwHDEA05vOd3MBgQtgE2ra6HiotehI4TE+H0Yiq
	ZYUqQNIgSv5ehOhfY/d7nzskIXFUd8MogxCjyAFlQF75IiEWfaZa+h5qs6K4dKyyqJSPQx
	vHq8qXjU00rPrNdKomLpyIXSrjL7Rqc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5kq4RPFCBIrll8bbCbYGZskyVSRHJ0ULqia+GuNYYM=;
	b=35WfLz6xd6IcdtDIz9u5C1xm8BqbXsUpErEYF3xRuEUNVnvBwH6HLGa/wsjO8KooLIIA/P
	Z5XTZDAehJA7YchIco8S7FqVQQHSSvmFL8Aj8xuJRh4UIkx35s9I6PF/g9BzQb3251yysb
	+Re85UBikevt7htcyy1CchMn3L6vIh0=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VJli1j5C;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c10e86e52so247911cf.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:52:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782831158; cv=none;
        d=google.com; s=arc-20260327;
        b=c3b9tYWPmdNXDa1ph4uqwVUm72dWGwXPBU+jKjQsSb1EL8nWQr0GYkWMHF+T7vg8nG
         3Tu7/62H9RBb3LV3LUSwLtf4dstzeXm//A/Ss30Ys74eRQUYJpuVQ7DB5jrVFY9p2xGd
         dgKCs3G1GiJxAlOXYyqrFYKTOEJIHWEEa5vcPkPZR8nYSy43OHbjCbmTA7hOMIGmp3ox
         mt0LujkROwbhDu7O6qcoblLykVyGeoc8WIp6aVU3Es69L1b7Fkg0yqEbxOYiKFWNCDr8
         DaTHJtIQdyNo3NHC2cPcW/C9huE54B9ueTYOQ8uK6VJHlnsOrUM84+EuRR2fGdvhmB2+
         YuSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=w5kq4RPFCBIrll8bbCbYGZskyVSRHJ0ULqia+GuNYYM=;
        fh=4TFGYM8w174qXHm/n4p0unQxsVRJDnU/GiEMSfrZ6Mg=;
        b=Zjp/sUvdExz6BNz9RCkjcst++c1pi7nViAv3m4zXX0pOT5cAXn0qVMOr+Qnzp819n0
         WLkuI3v79IajlptH0/t8vdiEtABF8fcQojqaQH790afQLH7SvuZJTX7oJldZF2AY+Ssu
         xFVK4w2x+iSA3KX9pavNXR2fgP2izzrDj8+fSIsmXSwek/s4eImiN1d7iF6avp+FJvj1
         K+wizXAYVC4MaLzs9luxnV4/mdYBTDGoNTN1+pB0aygmvO8sTxGr9sxNiqGR8UC8wU/d
         cLYeZXABPz9dns7iTyrD/qybro1YqLBjUjz4pMEpDGojIvt08vHxMP4um551G6YOdAJ7
         1uFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782831158; x=1783435958; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w5kq4RPFCBIrll8bbCbYGZskyVSRHJ0ULqia+GuNYYM=;
        b=VJli1j5CRxztI+RK9OK9LDjeAIg3u/PevlGvZYDBTrIzcogkcpEzW8YSM9DpveX1I5
         kfDaCSTEw1zmUIsl+GgbC0wtYrubvzaCoXci5u+usvv8vb8RZUVRD1ohPB2Ycl7qHetx
         KxAOm3z0PQy6Z8xjBtkPrNLu7z+HPS5tsR6WOrtJZt91sZ2ugfLANqulM3CY2ZwNFCdv
         pl5khh0ZDHnr92EouYuxkFLGH/v/IvzhZYOenCkts6ljHzxDwXdeEHZSUayUcUOMBuiR
         mARKbgOOlfSv0ouQFaOPqQeuLTVIszOeVECdONsbFbjfayA0DnUSWzvxC45JwqsO0trz
         /9yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831158; x=1783435958;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w5kq4RPFCBIrll8bbCbYGZskyVSRHJ0ULqia+GuNYYM=;
        b=hMphH3mH6NaUFBJ+uKYIAVnWWJdlSl2CBIYxmH/6Jg+doYppkZsPFWW//BYBJ3iDRD
         WfqI43ag2h4t1CG7zlhrRn3RJGSz1GgkVY20Otb7K7qUPQZ0t9+6/kkw9fm+HsCZDV+C
         sRsKuMTgbpG4btVeE3ZdLJTHJg8HxXWJwVkczFigVLWr7Gks9tVXlX40eWZVUgwvQfBg
         TbvCw2U8ERSGwHeUG6+s0UeuVdutQEM/C2nG+JmAP8cZI05/57z3QaL5nuqxZ5qvIuo0
         PXTh9WlsVYEAfUDVI9Mt46EzpCXS7SJTwsOa5fgoz+XEWPtdkZmuXupCWCHRszoWDL4R
         3bzQ==
X-Forwarded-Encrypted: i=1; AFNElJ8rXe5eQ5Ksp0f6RxzqW1RyVnSebee+E20StspsOmoBcOleKJFVPpK2MzIDmkN3gT5gQ3bQ0Nh1iw==@kvack.org
X-Gm-Message-State: AOJu0YzcLL4FOsYnFf+rU1hbArPSkY0SK4fQzhGOugFOrDVBjLWpPMcJ
	+L2Lcj98UX/QyF7Qp4dF2LcByozGKidviAx7biFwyGulP1TP/HZ/8LXpNBUQzAfw1939UOKXZWZ
	Fq/qBmFXs9pOWLA/+VY/PcKJs5zWV/DvvpQnOLHdNsQSZeb2ziT+6QOR8
X-Gm-Gg: AfdE7cnPTQJfbmmFrkfzzh4+1SzJi1/ITDLA5U0C7m4a5yqfMsClfScqvT2ia8VjZUQ
	+Xff1h3thht1GsSu+m9KAm+nCzZUsNQByr56Vj+7efbYWEgd6nRqs0F84ympdvwPnDWYlbcpP8F
	/Vv0JL4kjA3WEA01RfvFXEgR/Ooe+ZIahFRZx1mYLrnhESS8BPWWpNynyG5FoyqXC/p6BF10BLw
	piLkhy0Ms+1+uGpP5TftsVw3wuQFZhLs0cGTPjNWeHkEJKg0Dbb5ZNQVcjyRiomCs3HaIs=
X-Received: by 2002:a05:622a:2512:b0:51c:523:953d with SMTP id
 d75a77b69052e-51c1c34ddd6mr2730261cf.14.1782831156977; Tue, 30 Jun 2026
 07:52:36 -0700 (PDT)
MIME-Version: 1.0
References: <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org> <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com>
 <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org> <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
 <c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org> <5ebd3c4a-5c06-43b4-ab0a-7a8f0396c84c@kernel.org>
 <akPSjsbjl-UAcdI8@linux.dev>
In-Reply-To: <akPSjsbjl-UAcdI8@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 30 Jun 2026 07:52:25 -0700
X-Gm-Features: AVVi8Ce2kA4iG-if-KuHgAtNO-J03ArDmsRNVX-d8ODXPsF-OrrNINYalsjMfE4
Message-ID: <CAJuCfpE4BwDpt08iXtdh_nqRR5TGzGTdHzGZWYayC7t6V1O49w@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry@kernel.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 829F21C0003
X-Rspam-User: 
X-Stat-Signature: 6n76cxfre3fsqfwpusd1spidu7x3qsbq
X-HE-Tag: 1782831158-462135
X-HE-Meta: U2FsdGVkX187N/XJ8Us2nevAOzIfBRtGxj+iQDBfS4a65lxcJsbCDA4ShU0Y+skXE0JMONCMYx8VKb0dxxhvTJ4mgdgpAa66jq3zrm5ORb0CGYqG0wn81FT3aDZfSF3x5WO0XWSeXDw5ROpNR1/C7+6vPNqGxticnZpW8Jm8FX7NyGmlK+uLz2bhf8xdPDtdKJfmSF/lTciNDJIiH1j0J/5pTtykJFSOrYb0MStForsJ+YsIvKnMOEzl0CvHMnWw9pOcV3p6gLXFTEXonWVPXyhc9B33uoyv9xLSS7y8LSMV6z725+OClPNjyFbtRFqKxkV66/27PfnNjwcl1nX99VhTYmapzDydfIjmeJohP/lFzDgpTxL2exXqboMpWBKXbHTz2SISaPDDM0Ls2WeV5WGEz4S6/NDBl9dgHAMGsaq/9FzOERc8FS2JQM11eHAEQ9elb9j55/zIsypJvR6nDn8GAQXbb/OyMQZq1p/Okxr+fDgnr87FJEagIGc8WCe49jIyIF0YSF7xSC5yN+WeVzd/RvNW/VDZE60w9y0vlmoJHiR5lSuYnvZXiiFhH2LS8QP62hKSRlCt79phmyT8D3NSvKwxCn1wBQ7tVpeImrqvSw1nqs4aAIMEu9kuUtNQ+e2Ha9BDG7GgJE2VW0WD/HsV9cj4fETilH5XRP3vFvkmTMijipSwKxXh9EgDkFQiKc88Bl8rhEUBnyBiQbPjKBb0B6ISgCESa+mvr82z/4zmFYgfnjcbRAwlrjjRQUlXW6Z468J58L9gl3oZ5uC6RWwqmf+m9Tdv78rBmMWLH+06C+fpaWjXmz/XfJ0Uz4IU6m7P/N7s9jYnbTOsYhFnLite76zyR78l/IsLxh7TaK59BoY5gCkTnFryQkhRyH1hMYKs7XgKvYzBqXUsIUsR9nd72YQNSzGKw1FqCf+bHNqZ23um3eBuPncn34nuxmuqWUuGZvCh/Gv1FpuJZFy
 kHSgLfVy
 zQIK/QkFd6RxsuXiODZDqhfWz7Lq4iHFDP86fI+RtaIqmzWoKtiVIFFmB5XkwD0seKoFiXGur93lPNBsiEtV2xRBqCsq04DDPf4A5K7sGxUn4K7TwttLPx6OHcl/kYbmC8q4hrFT7o8GI6ipZ9kgxF3ZDmGPmqhNlbXjRMyB2uiDi8jc/UgKiSRFz40airKdE4qbrJGCnQXE4MeGW5xBhFyqiZa10GnLhjSLsOhgZFv6OxUAobHEtHgSKVeQWAdMcJrF/c1WJzMdB7sbtZGFvnsVa8S5tk0YmCPgao81lByCGfwV3JZa+ysJRb9KmemPp5xzIyOfnl54M1ng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 7:36=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jun 30, 2026 at 04:03:30PM +0900, Harry Yoo wrote:
> >
> >
> > On 6/30/26 3:12 PM, Vlastimil Babka (SUSE) wrote:
> > > On 6/30/26 07:29, Suren Baghdasaryan wrote:
> > >> On Mon, Jun 29, 2026 at 9:42=E2=80=AFPM Harry Yoo <harry@kernel.org>=
 wrote:
> > >>>
> > >>>
> > >>>
> > >>> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
> > >>>> On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <surenb=
@google.com> wrote:
> > >>>>>
> > >>>
> > >>> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYP=
E or
> > >>> SLAB_BUCKETS approach.
> > >>>
> > >>>>> Yes, it's worth backporting, so we can merge Shakeel's change as =
is
> > >>>
> > >>> Right.
> > >>>
> > >>>>> and then once Vlastimil's patch is merged we can implement the ne=
w
> > >>>
> > >>> Vlastimil's patch has already landed mainline, by the way :)
> > >>
> > >> Nice! I suggest posting Shakeel's patch CC'ing stable for backports
> > >> and then following up with the fix using KMALLOC_TYPE. Vlastimil,
> > >> WDYT?
> > >
> > > Sounded like a plan, but then I realized I misunderstood the amount o=
f the
> > > wastage. E.g. on my system kmalloc-8k with 4 objects per slab would h=
ave
> > > obj_ext size of 64, but now it's 16k? That's ridiculous.
> >
> > Right.
>
> Yeah I should have given more thought on wastage.

Ugh! I didn't realize the wastage was that high.

>
> >
> > ...which is why I was assuming either the KMALLOC_TYPE or SLAB_BUCKETS
> > approach would be backported as a follow-up. Err, should have
> > communicated clearly, apologies.
>
> Harry, do you want to take a stab at prototyping these? If these look sim=
ple
> enough, we can request backports of this.

I'll also give it some thought to see if there is maybe a different
way to fix this that would be easy to backport.

>
> >
> > > I think it will> even self-amplify to some extent? kmalloc-8 would
> > have 512 objects per slab,
> > > so its obj_ext is 8k. It will not recursively create an obj_ext for t=
he> obj_ext, but other 8k allocation in the same kmalloc-8k slab could then
> > > trigger it, right?
> >
> > True, assuming that by 'self-amplifying' you meant this patch creates
> > more kmalloc-8k objects, and also now kmalloc-8k wastes memory memory.
> >
>
> I am not sure I understand what self-amplifying means here. Shouldn't 8k
> allocations served by the same kmalloc-8k slab will share the obj_exts ar=
ray?
>
> > > We could say it's for a debugging feature, but also it's running in
> > > production fleets (and Android?), so probably not that easy to dismis=
s.
> >
> > I think a key factor is when it's enabled in production.
> >
> > kconfigs says Android selects MEM_ALLOC_PROFILING, but not
> > MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT.
> >
> > I assumed that turning it on by default in the entire fleet
> > would be bit hard to justify... (please correct me,
> > if it's not the case)
>
> Actually we have memory profiling enabled by default across Meta fleet. S=
o, the
> issue is very real. At the moment, we are seeing this issue on a specific
> type of machine and we have disabled memory profiling for those machines.
>
> Internally we did discuss to simply disable memory allocation profiling f=
or
> kmalloc-normal caches but to me that was a big hammer and thus suggested =
the
> current approach.
>

