Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7823EC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241AE6B00DA; Tue, 30 Jun 2026 00:38:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218D96B00DB; Tue, 30 Jun 2026 00:38:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BAC96B00DC; Tue, 30 Jun 2026 00:38:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C822E6B00DA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:38:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A26C167BE0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:38:49 +0000 (UTC)
X-FDA: 84935323578.20.31DC103
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6390E180006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:38:47 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yj1lUWVk;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782794327;
	b=n5wmIGbX4QMrfqdYzXocu6YnYtYkjw0uGVL75t+L6OS2Mb/xphqjf3l3XtLGVZ5EgFCRBr
	1JdB/doe7AE2hQFnLd/TAJwUfY0Ol7R7pf29ys8Bt3LNgjv4Ck76su3dNmTXjiNuXnOp9r
	RE8mdRLP4ZE1hL7/gYuMTRe+Zijpn0o=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782794327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hf8fcysN6jlhj3x22vZZGKCuBikMYUf3CE6Z9jnUVq4=;
	b=j4akjMxD10R4tuL9LKwC58lgDfuD/pmgrqymlogZRk8Q7hsUGg3A8QigNCF4agPeyZ3E2u
	Q2ww+v6lPU79L1RwCMiwpyb20DlBLxxj0mXNm2eF//2SeHwTACX5UbLomqom9DkYFgjqJB
	DnUnnbHmx6iRaSUucIQBtiH+/Ybp4hA=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Yj1lUWVk;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c10ed63c0so91501cf.1
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:38:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782794326; cv=none;
        d=google.com; s=arc-20260327;
        b=BA4ru9xWiwR8jyymPCDcPy1oQ6vwzf1IVqeSdoDimnDGU2gfUsXUYO9vv5pdF3X7LL
         GN82i/XCU6nUFpEFCYrkz/h4ZuIq8HysKpBQx526uXWVpcMgkw/7TgdlX1DMYGnRaGVv
         5olGjRC6FsfrFeIi4mNBJuBi1lsIJOoPCC3EDU8v6z1nzoX5IIDATAN3jEgwcCvzXtGs
         laJ4vVPZr/YHxe/jPnc6TY6zyS5aX3tFq2M5BwJW94Ab0zSCjs6PP4RiyckQ1+scNwwH
         HYPTKGXo11QTLQfleyvS+MiJ1Cy+yjC+wOSdsolnIj/YXrAKV2MDM2kI94Mg1kBMkhis
         zz5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hf8fcysN6jlhj3x22vZZGKCuBikMYUf3CE6Z9jnUVq4=;
        fh=Hwjum2I50deMgRotApjkDfb9RnzlD3gxKKLde55bnMU=;
        b=FegU1r8UO/12Nsp06iAXxzBACFaQsEPAQKGoD320m7CAG204FGGCzaM2edYclJYbl9
         4ZGMvaj3o/fI3yWEl983cEBrin/tE079r09ZgFEndy/1Uf2BnvaCRqHAo7z4/uLjM19B
         HKV246C7+KCnQFIEB6uA1twBCtFSuKHj5Hi0miSLNfetBCYGOQIMuaTnqvmJc4m66NX8
         NbWvvokgMzgbBPRo64JZxhro/Rbcxd98g56apYwGx6rEVw0P4W/VQ6eRLTqzBfRU1rbC
         LzdJ4IBs2bIPiC9Hl7z068ck2QFKcpA4vRJlABnMwWZ3xmwnpMPPM9zl+5/4ITknoETd
         HXaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782794326; x=1783399126; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hf8fcysN6jlhj3x22vZZGKCuBikMYUf3CE6Z9jnUVq4=;
        b=Yj1lUWVkXJQ0KKb+AAXQBFUiLzkRGJbAO/h8Y3wWtzFjBscUQOzDERgMiBa4yVyvcy
         iM3JwN77TRWoPvEpHrS0NN8dIc+mp6FpyH0+hrqOZiuoICZPdwbsWk6g6AftPgopf0cJ
         RJyT8eUF5Ul1hUkWGaWUW45G0LU0eTEllDFZaDaCtSoFAWo+2alzmBb7/1EWOKAXx0Rv
         nM6zK0qpvU11AByArzXePm23eCvRkkrrebtsILhY50nrkiu9AIteigfTtQWNWuTcbrgm
         5fbnp5E064V/EbM2U4ZQc/2wNN9tRHC45zr8mjEBDiS6l/YnDwoB6nLWQZRcxeWTHw0u
         ASPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782794326; x=1783399126;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hf8fcysN6jlhj3x22vZZGKCuBikMYUf3CE6Z9jnUVq4=;
        b=iPHQy0AqJibkjids3RRycIXRoiUHp9EekTG0DpiTDMy2Wijvzpd6/UKq9WeeTRHmMi
         bBl6hx6EalPM+mEKQ5EZhQpBppSCBlVyGSKSr+qqiqW5DEuYZ9p5g5bCLmylzL3sRr1H
         uDojg7V8GNx9zUCsODEgErp0j5+0Vs5EWD+oE1+uUx3tIXa3b0BLej5fYR1eRi/j/nk5
         W4oorXS/SCoaq8tE8Oo4dOWS1SI6euco5xltP81fNkbEhxZ92tthqOTZNO7brVYNELji
         7KxXT4IFswFWI8R/6nll0Uusssk/+VArgG6GhRHCQUqdKvqeCg9rx67CoCQ7tbFDGvyC
         3j3w==
X-Forwarded-Encrypted: i=1; AFNElJ9cHg8wpGMiH8kIRmKeVnxruL7W4xg9KSSWh27PgR+dcFWKzllzda77+V67YI1u0V+wZ7veoaLz7g==@kvack.org
X-Gm-Message-State: AOJu0YzrZe6g8JDOxFac+b+sqD6oEQVqF/Sb6JudQLBLDx3E5t9uhFuT
	rulR/Dfqr1P7QFt0uGuk2Whs1e4FL4KECDdCPwfPxKNPytRMitA6I5EYtUPgFWXhxIwb09nYdJz
	wCM/wirxmoRIYiXwwI78OtsIlF4gRttiZVK5R5FZy
X-Gm-Gg: AfdE7ckrIJr4ORDWHAkA+zuTkkV6cNcpfAEXxIP5cbjZeLLAYY7w0hjuBiN6RmGzwcI
	ebSvhO3pgeSlvaNB1eDQJBFB2gyh2fFbLRkmkcdlt4VoMosCk7N6WX8Lsq2FOR6zP5RorTZSSDs
	ysjwjSK2m55mZdx6tJerK76De1AR7CXDt2Nar/VrUOiKolTbQClCNPc98Ujxce+3jlveBDJj+Sf
	FXoM7RQpRVP2aJTbOk4MbckZe8ft2LQJP/O4OutPc2RHDBE1yq9RUauov4fTm75Cpg4PuY=
X-Received: by 2002:a05:622a:30a:b0:51c:523:9540 with SMTP id
 d75a77b69052e-51c13d3e9dcmr3772971cf.18.1782794325690; Mon, 29 Jun 2026
 21:38:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260625230029.703750-1-shakeel.butt@linux.dev>
 <62453403-954c-4cf1-8924-6d38184b0810@kernel.org> <aj6re83IC84lkFL0@linux.dev>
 <09267187-6c85-438f-8791-4cce8d07892a@kernel.org> <akCJRTnmA2um3CIy@linux.dev>
 <akCSftF6mrsKsz1V@linux.dev> <e6ca6ac6-92c8-4db6-a82b-cbb92ceaa4ea@kernel.org>
 <68122038-e8e0-47ed-82f8-cb6a23e4658e@kernel.org> <CAJuCfpFanDcpqq5B7eNZbw2HnWOXD-xzcnrdbz-e2gnSM2EYHA@mail.gmail.com>
 <eac2ed38-432a-4d95-8968-2663540d73d7@kernel.org> <CAJuCfpF78_5CjLsbJLte+B4MzfaSiAmyeH57VLhgLtj8AXD2NA@mail.gmail.com>
 <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
In-Reply-To: <62969830-4b1f-483d-8fa9-9ce487568570@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 29 Jun 2026 21:38:33 -0700
X-Gm-Features: AVVi8Ce0cM4WdLexTNLWBMwH_6OvAm3pJMsszBi1qMMJztja4oIjh081ZfsM25c
Message-ID: <CAJuCfpH8ZjBMaOmso=9gZNz=DK2ja5yMS+04OjTGHh5Uc7r0GQ@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6390E180006
X-Rspam-User: 
X-Stat-Signature: id3s44nhn8g4mp4e5gtwuhos1k9pu4aq
X-HE-Tag: 1782794327-157971
X-HE-Meta: U2FsdGVkX188f4Xw7RKDs5k31t8tbO6+UOOscX8N3swPCgELFVh4s8xi1zja04z1alVUi8usUXyGVqbDARvD6kzAuPrcbf2ZZPSTUmwfunwQWRp5lqybUCEms1SOW1JrZJAQ2Q6iOIKxGd2Wl3PePxah/YPv9nJNgI6C4AoNwJDg61oPy89lwpDVK1+pSxHHYrVK7DjEuGYVWQKHWLsa4+s+ofruIub/EQprddFxCQ3hAIYvjbKMTBpr3E5v9s5plF2Xe2b9kln1QNjsA1VnDCLvkUQSI4PZ+9tygq8DUJyBllc/rvRsV5K8i5FIY7/BdNO5SiYETLJhwGasFkstAurcMT0dX+2Dm7cvYKHqOAcqZ0QW16Z363e/oZJlcQPl+OSJdEYIpJVKLqhnYedN/RIdn9CUyY8AEdc6TpuL3ycpJCbAkiszP4p+Od+s8AlE2UDzk2ANfOjGk0eOeHXG3NlrwMmNOt+4CUy2AhFyHUB+EPsQZM/Acijld9v0vIYmWifH9Hqsdkbu0Hv1YWIBwXAOXFI/HVbgGw6JBVz+WE9G6XT3xoD4KUBErIUPDx5ZZ9dTdUkPe8RlDLS+E2dOeL+udGjdarfSXvbvK6mP8AK6aGG83CzRQKBiAd4ofO1zAjh3qTaqYBoiK5KzCQP90kqN70q//qNl4EEqwGmVZn9TKjP4R6GHLyhkzEf7Z6AGrsedYXLZ46NXdfet82OSwVMkyVjCpv5jk6hzJaRTnNGM9ZJJHl5/JVCTNc2y5uQL5Oh5C5HukVULXWQO2h5hFdCB18ghaFePea6vLicyM6xDO4V9o6U9c1l51BGW9bIGagGmzejamoS3BM759rsPBt6GZYmP60bi/LLIwPMlCE6s5ldZjrLeLahCAxHVYwufJNuew1fro9MYHNSNlFyXBwtwfyzsa1MuOctYMhvzUhKRi1U8BN0a/j71tNQcY0OkLD4TTrfTfnjke3lwUxL
 yuco6TBS
 n1C79nGRI99py+up64DKlMSDyWMasxLFZqCUBZ93u3+3XEAFoYXDre3+okm4BgbOWUDPAM1YKPorVKZfysp795XbDZMLWMPBLe2Sp1QVAKRxQKw/fxf5OCa1/58BqYZilpRpnC874qL1R2mIKBil84IupIl8IwCyPQ+IOZnyC9tboMhz5xC0wylQF53+x1wMOhxALJgEMK3/D49ElumR/ZkLlP1MBW3nLGoeGAzODTJVZDZTflRIs55Ew4ZZ/J41BEOxTT9FHf/8cc1Fwz++yZoGQGKk2ua1YFE8KWzKEQVRHh4YPGhy+ZkSwag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 7:31=E2=80=AFPM Harry Yoo <harry@kernel.org> wrote:
>
>
>
> On 6/29/26 1:28 PM, Suren Baghdasaryan wrote:
> > On Sun, Jun 28, 2026 at 8:57=E2=80=AFPM Harry Yoo <harry@kernel.org> wr=
ote:
> >>> I think adding a new KMALLOC_TYPE would be the cleanest way to fix
> >>> this recursion problem once and for all. This size bumping and the
> >>> special case of SLUB_TINY are quite confusing.
> >>
> >> As mentioned by Vlsatimil, in the long term, using SLAB_BUCKETS
> >> infrastructure would be more straightforward than new KMALLOC_TYPE
> >> because (I think) the kmalloc type is decided purely based on GFP
> >> flags and we need to somehow work around that. SLAB_BUCKETS provides
> >> a nice abstraction to do this.
> >>
> >> Luckily, SLAB_BUCKETS is introduced in v6.11.
> >> Unfortunately, SLAB_BUCKETS is optional.
> >>
> >>> We could define that> new KMALLOC_TYPE only if memory allocation prof=
iling or SLUB_TINY are
> >>> enabled to avoid new caches when not needed. Does not seem too comple=
x
> >>> but maybe I'm missing something? WDYT?
> >>
> >> I think we need some enhancements to achieve that with SLAB_BUCKETS
> >>
> >> 1. Rename SLAB_BUCKETS to SLAB_BUCKETS_HARDENING
> >>     (w/ SLAB_BUCKETS being a transitional config for _HARDENING)
> >>
> >> 2. Make the SLAB_BUCKETS infrastructure unconditional,
> >>     but the decision is made at runtime:
> >>
> >>     1) actually creating a kmem_buckets vs.
> >>     2) falling back to kmalloc.
> >>
> >> 3. kmem_buckets_create() creates kmem_buckets only when
> >>     SLAB_BUCKETS_HARDENING is enabled.
> >>
> >> 4. SLUB decides (not) to create kmem_buckets for internal use
> >>     during the boot process. Use the kmem_buckets for obj_exts
> >>     array allocation.
> >>
> >> Side note: this would unconditionally add the kmem_buckets parameter t=
o
> >> the kmalloc slowpath. Probably it'd be worth introducing a dedicated
> >> entrypoint for kmem_buckets instead.
> >
> > Yeah, this sounds quite complex.
>
> I think it's not that complex, but quite some churn, yeah :)
>
> > Maybe we could use the new> kmalloc_flags() introduced by Vlastimil
>  > in [1] to avoid using GFP
> > flags to indicate that we want to use this new KMALLOC_TYPE? That
> > seems simpler,
>
> That indeed would be smaller changes.
>
> > though it's not backportable because kmalloc_flags() is> brand new.
>
> Right, I didn't seriously consider that option as I was (mistakenly)
> assuming you or Shakeel would want to backport it.
>
> > [1] https://lore.kernel.org/all/20260615-slab_alloc_flags-v3-0-ce1146d1=
40fb@kernel.org/
> >
> >>
> >>> If it is more complex than I imaging then I'm fine with Shakeel's
> >>> approach as a temporary fix.
> >>
> >> Since above requires quite some changes, I'd say let's proeed with
> >> the fix (since it's one line of code change that fixes a bug),
> >> and then see how we can make SLAB_BUCKETS changes as minimal
> >> as possible for backporting?
> >
> > I was thinking Shakeel's approach for backports and
> > kmalloc_flags()+KMALLOC_TYPE going forward.
>
> Oh, I misread it then.
> I was assuming it's critical enough to bother backporting.

Yes, it's worth backporting, so we can merge Shakeel's change as is
and then once Vlastimil's patch is merged we can implement the new
KMALLOC_TYPE as a replacement.

>
> > Just throwing this as an> option. I haven't looked closely into
>  > SLAB_BUCKETS yet, so that might
> > be indeed a better direction.
> --
> Cheers,
> Harry / Hyeonggon
>

