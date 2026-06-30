Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78CEC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 05:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EA636B00A9; Tue, 30 Jun 2026 01:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89BAF6B00AB; Tue, 30 Jun 2026 01:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7655A6B00AC; Tue, 30 Jun 2026 01:29:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 395546B00A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:38 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A522D120389
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:29:37 +0000 (UTC)
X-FDA: 84935451594.24.BC7C76C
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id AE523160006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:29:35 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JCROKD3B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782797375;
	b=QhiFMvAtwtPyNw4oAMwN9KI5jrNmRWULCIR2HER0QXeqD8jpi1Mzuvtmuxev/t7M5CQR1i
	x0J4+v7OAgi9Q+1FOoP0AgIpekxer5c+KCBMVAbFdiHM+Fj4L2++eWzvSCMzlvQ+UDuVPE
	1UXScLjiqR2n5JfoFvJVCj9DfcykN2E=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782797375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FNI4NAwNRuSgqN9buhLIXIY8CRF6phmZ/8VtHeyasCU=;
	b=qgVscmW28SyEX5ZMHBWyKn18r8+h/QAHs2klypW+USnSlrkqXu9X9NCtWhhmzgm0K6O35U
	99Eanq1vblKpRG50K//tGzT5sbwcYw0N/whMZgWaiBmgMr9KS0cyCbeRoIXB/AWnQgQ+MD
	K/PttPKCzzB6he91YjV0UJa2jDvJKUQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=JCROKD3B;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so153671cf.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:29:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782797375; cv=none;
        d=google.com; s=arc-20260327;
        b=pp8GuTLvPPLENhRr7c29wWKKsNT3RoGfmkIF6t/ikM8LKCLvmz9Z4BMgeiNO542S+f
         yKdy+tNx/d4yOF5VEBwmMvzYW7NJfgEAeArivjl7VRD+3QWqHgaLnmu8jVW/8xwQy/s0
         b9WCn9p+9yIHj6KEMHKzNlnmC7Xb1OtfTu6C7qHR/zP0eRvrQ61ZW16SWOO2dTq4pPXj
         P/VoHoRbEEOUABLo7229V7Wdw/82id0fGsNFffEjV/mq/mwse3zYYsBige5VUxvtYfD0
         BoQayZ7h2Nj4q+zliH6tbDf2wj8p2TVyi7lrOaRBX8yI/HR4U+S4PW29ThaJjN4RFU7g
         5cGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=FNI4NAwNRuSgqN9buhLIXIY8CRF6phmZ/8VtHeyasCU=;
        fh=H0jJ8grLxic1dJ1J/kjgvfw5UjK2FfvQWJGUCEbEA94=;
        b=T8EWh4BtCmlR8Cb73ycVqSubnP3UWuNjMKCC01GayMCtB50X4TsI2KBz6cHE+aYR4O
         LS/BvixJQSNMQJnQ63fe63dCVevXJ7uWeGHfrY0RoOJ5F8U6/3uLnlI0tNhMPJitSWBP
         G0B0lVZnI+VWlML5hPvw3hFKhy50elbd8DY+LJH1JAZ3djOIU7sSAZ6tlCCfJUNaRu3C
         xjyOOIRC8jZZBSwUqAOeENPIKIelLtQfdavFwjRjOoGyFoaFfvnJKv7Ks3Ck8RP0Mc74
         r6SIHTqTOBlD3hmmJWBu6OITbl6nJsr/Bb7f3ZNBLh++u18rYdE9dwokr4HE8Lkd80N9
         OXrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782797375; x=1783402175; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FNI4NAwNRuSgqN9buhLIXIY8CRF6phmZ/8VtHeyasCU=;
        b=JCROKD3Bu1kZqwMbtkTOZ/dVSKyz/Pwzk6H+cabV2Xak/w9EAHZ4mHmfyQr2Q0Vhb2
         YtjstBiL5P3SZOE+CD9XktWV+BBh+9j1E1fDvs+W+b7xv30uom8ZebueVJrvUlvW/pHF
         hFdZNGvhkm3ZcRkzS/Jt9Jz+GqXoZEdIy7Uc3jMf83HabWST79zYRrXy9pffTMWbtMxu
         LkPLZNSR9WukbGnzm4I6JiFioy2DyUEml9+IhyWFFN8IXp3yAm8tOdYWqIdGI73VWUuc
         Rl3U5v4gYZpMxZRWIkejKH1YkjVlO7uwLUUaCyTpT2SBgToOmwO9A8e2DBVqHB9D9Mno
         HfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782797375; x=1783402175;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FNI4NAwNRuSgqN9buhLIXIY8CRF6phmZ/8VtHeyasCU=;
        b=VoLfNI3ZrH1hHjhi53QN6b+EZ7dJpDkL9UPSb5kPx60A7nv8ubPfiE2WPeaydLiHWa
         eabmuTY/0rf69x9XGJjq7ZJ+yVPuxBnDeDM5njT+DHcp4AW4d7cvxNrcWlZ+IO/HeSPX
         zJsGgWnKQAa/ODKyx8+BAy/+lIZJz1jxUf9Qk2s7OZ90jPF3B5YN+CvI16L84xyTqohS
         Yl0NE9663Tu7lAT31GgAJOQt2G3sDl6oVkk2n7hg6ch6ODOqW/IubK/0S5RPbmMKhKBE
         da6lL6LMSHApTQj/qZtakr3hNyNc8Xvxd74bxlKsverEHDyIEHf1tRx3JGylGnMicXL1
         gKYQ==
X-Forwarded-Encrypted: i=1; AFNElJ+l0O+DfpCsdCBdx2ARbJd2Tu/AtD60bkR3UrkawHW0Uj1a5npzhyWc9QTSYVC/wGUan+M4BWg1cQ==@kvack.org
X-Gm-Message-State: AOJu0YyHt0rArOM6CiwpscK8wxS9cD+mvRED7voX3XZ2TRPEgb1ratj7
	CZQesXESNUlpECBCEtaOwqyzPzkT08QXDFoURxkA1z7XggSRSort4XVXr576zY54wFDUvbUiviT
	eFq1XLId0R1LkXYgzTNblEpMeSsNEzdCH1simv8Ob
X-Gm-Gg: AfdE7cm6SlDBnT4tc9xRdzVVtOSXr0KaQF8/cKiWbVn0QsQrTCpu2Cri9tLz4GScYbK
	4xa92TVpS8EkcuUdBtEWbQ++J1GHBJRrSNLGOvbFvauEwd8P8lXJ+39BK23snmqKaIei/S3q5R8
	3ArWiG39rLdsrrtjlTNDQCrEpzg/8XN/SzsrfqeBACRASCy5kN+5olHhvFM+xW2ISr80QD8DBN7
	0+Dw1EOzL4JqANXiEYsqON6VfuWek0yGEOUbfKhyoBEMQu6n+vfJS0G+cc4YMvmt0U0lQ8aNDim
	ORoiHA==
X-Received: by 2002:ac8:7d03:0:b0:510:f9b:fb5f with SMTP id
 d75a77b69052e-51c13d3e713mr4388981cf.16.1782797373904; Mon, 29 Jun 2026
 22:29:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org> <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org> <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev> <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org> <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org> <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
 <CAJuCfpFX_sMrcTad-QGJsCV=fNyMWF=Bi6XmoHRqEAzMbWNfdg@mail.gmail.com> <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
In-Reply-To: <39a79576-dcae-4b66-9478-c81dfe676699@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Jun 2026 22:29:21 -0700
X-Gm-Features: AVVi8CetOCg_XxAfz3GJgwgctHQp-s4rSyJaCFS6q8j-DWpMOtE011CRJNNZ-8A
Message-ID: <CAJuCfpGRC7NPxcODUsb3YS5nV=qG+-SbSYj1Fwm-QPqgKSVWAA@mail.gmail.com>
Subject: Re: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger
 kmalloc cache
To: Harry Yoo <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Usama Arif <usama.arif@linux.dev>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Danielle Costantino <dcostantino@meta.com>, 
	Kees Cook <kees@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AE523160006
X-Stat-Signature: iqgoyb4wg9g4nhqi77sm9i57354kdowt
X-HE-Tag: 1782797375-744522
X-HE-Meta: U2FsdGVkX1/gMA66il2JAP3YzfErmVX8bg1uXITwfR2mlTzRAe5YrLJR+LxVjeIUAq7Kjcmwzw3GQ69tUwsO1mjmveeLnEAAU0gi4TrcAGWkcYthd8xhM/9koZtvMJfjTr9PBjLO0X8ZPxZYHBCKKn3nsM9AVOTvumeX478UyA0D7PDpDGbeP5CL7+vEXoQ5hPJzvUwoqq9QbAmAe4BAyrSaOJphTPEUTxgMi5YmSNbRilY2NC8RgG+bbwN8BLSM1iPKcjSXnAEzI1iTsaonbLvKPPng/wsDM5A7btEwqJn4LCWGiqUxmB2dtFuJsHUL3zRrJAgiiWjZo1NjoCvtV6NOdZ/FO9ZKBtgCFetTI3HMRDkKBo1fiS0PLCBuD9p6V5f2sBxSqeTsmBZOnbmLDqw+hKy5TgVTjlNnYjcYr9KdO38pw/ewbBfH90Zg0+SLhNxPh2jOsMl2HByAzAyboOHOh5muso3wmNE6shqI6arA5gjY5/XVXRi7Bw502NtRhS1ta0r1AJfqhOzG7pHix6hZLr6a7Nt1RLJVzMXhVzda6GDgjJ5kgL3sx4W/Ef5IQcd+O/9RkxOL48z0lzrigqKg6O9wnZOtdCUwHWzKA+ijcGvvNboLOeucPrOYLF7ceGjfftxK2mW3zwS4Rt+DCgnM0DZ51Xz214bl+gmL4QUuU85fpc7POpJwXqB430+faLIhy5V/8Pg5d7Z6wzkdc1l+ftaFrceHV996ybFQ5nYm3U0SimYWfOAVz0XxjhwdW125YQLWZZ6SjYtSYZpxgoNY2kmevmvYgpkYzVmjF3FOKAJEHcFkc6YAG00p979vTVtDrL3uGIkv6n34uqFB3NTRvFDqtxy3WWWNrnQ3EFXflebW1ul7jooWgbS4SlQ1tM3pD6SkNo06LyyLUBLAwr7KUpZptJ6iH1f9xdnusyOJdEEMf9Nzxo6fVnNlxhPMj2shIU8U43/MNTWk9Mm
 If2lduH7
 YWuH3OWO6+HpsPudPqIfCNTz5DIYLTK9SyX8roKSyfJhjWrpwbX/MNawKXuoM/1jqhDN0PoURZWq5eo/8OgCqBCcsuCwKpb5HkLBJl4Vuk4nFwMS2zENOBt6ROypO71fRUN52UepYCrGVGAoaxMCSKn7mkMV8N8UcD/O29JuFDIbBETMgoPF84IS+FV6G96KNeZhp2YhcwM2aFec1eTfK/gLahbM2yZiKLzt0rC55GpUH1DEgNgBrlg2979Gt57LuNVlslg2MkpNpx4RktYgYmTYNUpFOHdhqx5PfumppNGnn8acTsU1VLVQa6a9Fcg//X6SrPI7x9x72ZLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 9:42=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/30/26 1:39 PM, Suren Baghdasaryan wrote:
> > On Mon, Jun 29, 2026 at 9:38=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> >>
> >> On Mon, Jun 29, 2026 at 7:31=E2=80=AFPM Harry Yoo <harry@kernel.org> w=
rote:
> >>>
> >>>
> >>>
> >>> On 6/29/26 1:28 PM, Suren Baghdasaryan wrote:
> >>>> On Sun, Jun 28, 2026 at 8:57=E2=80=AFPM Harry Yoo <harry@kernel.org>=
 wrote:
> >>>>>> I think adding a new KMALLOC_TYPE would be the cleanest way to fix
> >>>>>> this recursion problem once and for all. This size bumping and the
> >>>>>> special case of SLUB_TINY are quite confusing.
> >>>>>
> >>>>> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
> >>>>> infrastructure would be more straightforward than new KMALLOC_TYPE
> >>>>> because (I think) the kmalloc type is decided purely based on GFP
> >>>>> flags and we need to somehow work around that. SLAB_BUCKETS provide=
s
> >>>>> a nice abstraction to do this.
> >>>>>
> >>>>> Luckily, SLAB_BUCKETS is introduced in v6.11.
> >>>>> Unfortunately, SLAB_BUCKETS is optional.
> >>>>>
> >>>>>> We could define that> new KMALLOC_TYPE only if memory allocation p=
rofiling or SLUB_TINY are
> >>>>>> enabled to avoid new caches when not needed. Does not seem too com=
plex
> >>>>>> but maybe I'm missing something? WDYT?
> >>>>>
> >>>>> I think we need some enhancements to achieve that with SLAB_BUCKETS
> >>>>>
> >>>>> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
> >>>>>     (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
> >>>>>
> >>>>> 2. Make the SLAB_BUCKETS infrastructure unconditional,
> >>>>>     but the decision is made at runtime:
> >>>>>
> >>>>>     1) actually creating a kmem_buckets vs.
> >>>>>     2) falling back to kmalloc.
> >>>>>
> >>>>> 3. kmem_buckets_create() creates kmem_buckets only when
> >>>>>     SLAB_BUCKETS_HARDENING is enabled.
> >>>>>
> >>>>> 4. SLUB decides (not) to create kmem_buckets for internal use
> >>>>>     during the boot process. Use the kmem_buckets for obj_exts
> >>>>>     array allocation.
> >>>>>
> >>>>> Side note: this would unconditionally add the kmem_buckets paramete=
r to
> >>>>> the kmalloc slowpath. Probably it'd be worth introducing a dedicate=
d
> >>>>> entrypoint for kmem_buckets instead.
> >>>>
> >>>> Yeah, this sounds quite complex.
> >>>
> >>> I think it's not that complex, but quite some churn, yeah :)
> >>>
> >>>> Maybe we could use the new> kmalloc_flags() introduced by Vlastimil
> >>>  > in [1] to avoid using GFP
> >>>> flags to indicate that we want to use this new KMALLOC_TYPE? That
> >>>> seems simpler,
> >>>
> >>> That indeed would be smaller changes.
> >>>
> >>>> though it's not backportable because kmalloc_flags() is> brand new.
> >>>
> >>> Right, I didn't seriously consider that option as I was (mistakenly)
> >>> assuming you or Shakeel would want to backport it.
> >>>
> >>>> [1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce114=
6d140fb@kernel.org/
> >>>>
> >>>>>
> >>>>>> If it is more complex than I imaging then I'm fine with Shakeel's
> >>>>>> approach as a temporary fix.
> >>>>>
> >>>>> Since above requires quite some changes, I'd say let's proeed with
> >>>>> the fix (since it's one line of code change that fixes a bug),
> >>>>> and then see how we can make SLAB_BUCKETS changes as minimal
> >>>>> as possible for backporting?
> >>>>
> >>>> I was thinking Shakeel's approach for backports and
> >>>> kmalloc_flags()+KMALLOC_TYPE going forward.
> >>>
> >>> Oh, I misread it then.
> >>> I was assuming it's critical enough to bother backporting.
>
> Ah, here I meant backporting either the kmalloc_flags()+KMALLOC_TYPE or
> SLAB_BUCKETS approach.
>
> >> Yes, it's worth backporting, so we can merge Shakeel's change as is
>
> Right.
>
> >> and then once Vlastimil's patch is merged we can implement the new
>
> Vlastimil's patch has already landed mainline, by the way :)

Nice! I suggest posting Shakeel's patch CC'ing stable for backports
and then following up with the fix using KMALLOC_TYPE. Vlastimil,
WDYT?

>
> >> KMALLOC_TYPE as a replacement.
> >
> > And Shakeel's patch is easily backportable.
>
> Yes, of course!
>
> --
> Cheers,
> Harry / Hyeonggon
>

