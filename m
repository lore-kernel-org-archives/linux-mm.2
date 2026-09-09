Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AFFC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:58:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C74F16B0092; Wed,  9 Sep 2026 13:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C276B6B0093; Wed,  9 Sep 2026 13:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC98A6B0098; Wed,  9 Sep 2026 13:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 818006B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:58:38 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B5241C1C04
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:58:38 +0000 (UTC)
X-FDA: 85194983916.01.2F556B6
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3AF95180003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:58:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="UA/fBW2q";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788976716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtyfnipbLRML4sk/n+Uiphvnw4FabEDfuHO2cvdrWcQ=;
	b=hJbBDV0PRWI/vEzhzPMGKbqt4vJCzywRTPoOh9ASv8lB0erkKVxxU/Z4DGPeIANXehNel6
	2eGowd2Ah/HE5HXLTXyj36haHoR4Dtdv1YwyWSZOzGOqZ6y34ndguAmpk65iDt9XKQvTWq
	z0Cjo5D6g7sniWHt/p4ZzURiIw3MyaY=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="UA/fBW2q";
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 74.125.230.204 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788976716;
	b=5ioY1dkcyEpqz6GsqMiSqnUj200gDiKIBWDUHOfPGr5qDD11M3zT5gQUPQhVX/qrs7I8zO
	FW83h+9hZRQg2711FVTF3cL75dqMv9gCVqRJtUqR/rzZXp8Wuh5ivuhMEgSDAElHLw1rdk
	4oIWjM13U8Ex7vjVkJxGvUO20aklDY8=
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-5307425f44bso322411cf.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 10:58:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788976715; cv=none;
        d=google.com; s=arc-20260327;
        b=Kxm/oJdpeBUQTyMumlCZ+MJD5PcqLgmNVv2zR2MnrCQaLMJex3Na/yDLGRO4zQIoBa
         3yroQQXllKcTyNsxE1zoWPy9GWPkjIuV/7gvcFgm/SnNSlI7CjhDueRLAjUkYINfHS/Z
         aAkb9WK3FlXrlwbw+SGIRTEKc0q+NuI/pdmn4/HO1O2JRQ3j+kAr1YjdE1Liy4HLbD3L
         cdj/nAuB2BFNN8Oxws+OIsw4ZGRFoDWpTQvH3crRxclXBG47KKzCmQ+UNDTRvQ1uzXoX
         N+sggJbTRcUrQTEmh8V1xbzczDqNn3IC+nvFqlX3ZYUkHAVxHqr9Wm9SzY3ZJozjcsOF
         ddLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VtyfnipbLRML4sk/n+Uiphvnw4FabEDfuHO2cvdrWcQ=;
        fh=PaX7GiJBeJnA413KU42lkjjM+ws/WubrH58AOo/rIYY=;
        b=QEpEUjCX5W0dN/V/OyisfZv6MFCuSp7wkL2TIKEeSXMOPrlHqfblNXnkbAGVVFZFnA
         0WPUCJyXzsC0OwTb8cyAkLWisebnzM8ivqgARHEP/hIjFNoF81vjS7OCOrVfnQ8xS54e
         22EciRMgrYzxOzgz5y+mYmMR0H8wVqQyjBkaoMej8tmnKXwbYURz1don9M8gJ82bLIIu
         uM4NeHSXUecyJ+u23kExQraMi0rMcyVuafNK91tKM8rbnAOFAma5O1qU/d5HH/yPlMh4
         93U0UiGKk3UOFgs/xbO5ocDHmHPe39Br+UTs1UQKAKXgfcZVydFaweMQaG5NxU8qkXBU
         hJ0w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788976715; x=1789581515; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VtyfnipbLRML4sk/n+Uiphvnw4FabEDfuHO2cvdrWcQ=;
        b=UA/fBW2qvyYntYcKT+8pFKvVPDZVulLI9LWy2VVgj4nbl2eaUcukb1MDXjt0L2Z41T
         YxO49gW4el88NeyyJJKscT+auy6f5Qdh3kwLxOtcm3Nm0rE4dJubLilc5R67S/r32NPZ
         voD0dgm0Ma/OoH95LHy46QBwleH//ZAeykQJjNLh8C/qWQ1KkILVAqLPORxe3y9yVob6
         7McdLx4KXjeSUNlERWDosp3b5vmKuZCuBF9DLuOjyjnGCzk90t0syeVr/XkcTGirtIbz
         rvTSRTyImfPWQY6oCyBR/1/bsVdQNvV+rtW9f89VQfTiZkkPUT262VASiEkRkb4wssvi
         WfIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788976715; x=1789581515;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VtyfnipbLRML4sk/n+Uiphvnw4FabEDfuHO2cvdrWcQ=;
        b=GwmhC1JrSQz9PZA0olSricpKgYiNd24aLG/0JYNeglabqe6TKjuI2jnRAP86OmOtYN
         h9/5Q3sjJsa5nDrVIAWidG9xolkKLhd6Do9+ohy5aO7jnkerCQkBHRbRhLKGiCYUeHQv
         CYGmhfQvTJGCqg4SO93kEX7EffVZyXQOAzy5//WsSMpMziDjEdxMa6gY4COmcHpOUIJi
         9L/LIuq6y74N9tWepssLt+T4B/GzZf3aKW0seLtlngweFxg0Yu0GIUS04lcwNSBJWbQv
         AGD3Se7tHQbkK7fnp7855Nykh5Dqw3gG9cj1izEyQOg+ZUYF9nMluDccNO/aRdY5l7fq
         sEvg==
X-Forwarded-Encrypted: i=1; AKwUvByC86F9jCgJJSbrDc/HkYQ9FnYkyueRffwV1qO1odIry3UarcddfPG6IavvoSUvQOb5z6jP5vmVyA==@kvack.org
X-Gm-Message-State: AFuF++ngw+zx3OKGkrPFGsnjOwfvrPGjvSkfq7wCiJ6AvZhe040hw6p0
	4odQ4bM6jGHsq1RaSZvEkyhYZ5SDpl5nuPXJ5qYN8oJ+vCpGGF7pw0bEYKTlE0swKPmuaLUhtmR
	p2GnhwEbA0KHOjGd7VFJSyj8CKarDEOLjbngpu3r/
X-Gm-Gg: AYBFou2L1J5oClWtZurOCZu2OTlIltphO0GgGhUJ3tKV5mQRG1+C3wv17rMROUEjv+l
	N0Ll84gOEhIcMeKFHRoLbnUyexdeNRXllddX0itHCLpsoYXa/e5QKvEqJA87SbiTAYL32jSH9Ak
	ctdUgb4fOz4ymVFnxqUuwki+O5FI0IBDL/LUeMX8BO6+c2IvFNPaz83im2hmOhyh0zt7bU6RVHU
	OSjTjpWRZVTWGPden7JBnwYaJqiA3SGAkYHajg5v+M02Xc2H2hpA9b37yu15Q59+CHh3UMwmSLF
	oAXnnBs+sf+MEUHmxObt32ERdnXhHwdS9do9pJPc1i3bW6/y5dy2HjHv+g==
X-Received: by 2002:ac8:5902:0:b0:52f:6e06:89ac with SMTP id
 d75a77b69052e-530a5f960b4mr16181111cf.13.1788976714583; Wed, 09 Sep 2026
 10:58:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260907063918.3432401-1-surenb@google.com> <20260907063918.3432401-5-surenb@google.com>
 <19e428e5-d8bc-4abb-b052-e23442464cba@kernel.org>
In-Reply-To: <19e428e5-d8bc-4abb-b052-e23442464cba@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 9 Sep 2026 10:58:23 -0700
X-Gm-Features: AcwNN1WVxGfkg-5L9FLh7hjIInMIQxAx4dVdpUE-xaU-wRib3CwQ8jMs5cxEvbE
Message-ID: <CAJuCfpF-xeED3zVL9YyCwrTUxcYXw4s6gVcCYY8p7rx_09mgLg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org, 
	vbabka@kernel.org, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3AF95180003
X-Stat-Signature: p38wnmpxefbfcgknaa935oqrxpyny5as
X-Rspam-User: 
X-HE-Tag: 1788976716-869388
X-HE-Meta: U2FsdGVkX19bFArKyNZ1M/PNrjrhLqkszSQQJj/GIsTJepLxA9u1T74ONUapeVEWMZm+KS1HX6vc/RP5I7kyGif26GsUYgm8BHyPeKjDsPS8NQrYX+9P/GRQfw9ZZMhPxV8fqBtBS2eXTyi8LGdmGP/VdYqdnXzoQNVGMjo+Q30Vk1sw3qqHTc86dMqKeaZtVYJKf37n2NpehyKCybAL7JBRQSC2sLxJ3F/VexgR7C6GnARerBFGr7eDACb/meWeVPaco7Sc34db3R650Ae2cAWg3Xlyjf5w9NxbOcUf1Uu5/q8gOVB0CwgLoyqAOO2GpX0bDCAHk2MrzIF2WglmCv6+SS56iqYvXz0GU0Drj58JPFuFWWC+S9gQUAqPxX++NhqHrdb0Hq96h1N21scswmfIv+8ZfjppwmVN+iI/zJ/NYiNsaYak8eXuyX2GKTBa53B5i2+M4HQpSTtenTBaCWBADW9q0n7r1sb0Ebnk6qXp6KaTAab0vM931f2lBeL3+6Rkrl6NnCMH5OJicaJoBnMYBjEDbsJDkhp745o6lumLdHTXaFo3pEewh+B8wTUOPMVKk7adP4rMKKB67z6dsO1u19uVCazm0ORYOPoGjshfuwpLpeqXx766Ch75m6lroTJYTQQt0BWPSM8JFZJZizYWHKfIQYDMKMSoTIMa6qjKF36P4qTw5dZyCP21RQtgmF65R0DjHmFymK+SwcxpboVgY3VwVBpNE59GI76HAA9Ddb3CGvhXOQdqlcfs39pO1Jy/Y4nRo9MhGKJpfjX3R+7P3Bcf3UYxgRIwxYYuBjDuTnc0Dr77gCIykwyoKL9cq6KfC2ESoytk8/sT8pCCFUtmDDm20RBRCuG2mEEpuu0k1PPnkgAvC4I8jlcrmfTcsjuNNgLFM26xz4lPC7bavRIpaemHy6ulFDdVgkkOgiwslcl46j+gepeKArpE4L689sgIqHMdRH6phd+yXvL
 lWKQ71G3
 +o0h28Dr5MG7Ycld/LSdb934xNHVpJqMl3QF4htylR+niylMMFYNzuOlrzFNydBsNE/Ldz1zKs7Bl3TrAFabUHCkXGajLkEaVRwNJVEiXoZOBBYqzbH+ZbZJPD9ItnCIOU3sFQ/x/92PLam1ls7yut7Ikt1Fu6e9fU2Rl+T7Eu3Pm4NJDmnt8F8yJ09CfDhKxNeXf1XoKWtl8KahDZKWEMRiv5Tl4/8fDWiBPMBm7iFvnvl6SYiwbHF+H3xjZmoZZOFtqT86ai4qgc4QCLkxJcpJKF7lLpV3vjKcqzC9jVSgWGzm6ELp/KwfDxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 10:23=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
>
> > -     vma_start =3D vma->vm_start;
> > -     do {
> > -             smap_gather_stats(priv, vma, &mss, vma->vm_start);
> > -             last_vma_end =3D vma->vm_end;
> > +     if (!IS_ERR(vma) && vma !=3D get_gate_vma(lock_ctx->mm))
> > +             vma_start =3D vma->vm_start;
> > +
> > +     while (vma) {
> > +             if (IS_ERR(vma)) {
> > +                     ret =3D PTR_ERR(vma);
> > +                     goto out_unlock;
> > +             }
> > +
>
> Can we add a comment whey we break (and not e.g., continue) whenw e hit t=
he gate
> VMA?
>
> (I seriously don't kmow ... should I know? :) )

The way m_next() is implemented, the gate VMA always placed at the end
of the address space, so the next VMA will be NULL and we can break
once we see the gate. But now that I'm looking closer into this code,
reading smaps_rollup file does not invoke m_next(), so we should never
encounter a gate VMA (it's not in the maple tree, so for_each_vma()
should never return it). I think I can remove the special handling for
that case.

Thanks for the question, David! It made me realize we can simplify this fur=
ther.

>
> > +             if (vma =3D=3D get_gate_vma(lock_ctx->mm))
> > +                     break;
> >
> >               /*
> > -              * Release mmap_lock temporarily if someone wants to
> > -              * access it for write request.
> > +              * If after retaking the lock, already reported VMA grew =
or
> > +              * merged with the next one, smap_gather_stats() will gat=
her
> > +              * stats for the remaining portion by starting at last_vm=
a_end.
> >                */
> > -             if (mmap_lock_is_contended(mm)) {
> > -                     vma_iter_invalidate(&vmi);
> > -                     unlock_ctx_mm(&priv->lock_ctx);
> > -                     ret =3D lock_ctx_mm(&priv->lock_ctx);
> > -                     if (ret) {
> > -                             release_task_mempolicy(priv);
> > -                             goto out_put_mm;
> > -                     }
> > +             smap_gather_stats(priv, vma, &mss, last_vma_end);
> > +             last_vma_end =3D vma->vm_end;
>
> I skimmed over the remaining bits, hoping the VMA lock experts will revie=
w in
> detail :)

Thanks! I'll wait another day and if there are no more comments, I
will post the next version.

>
> --
> Cheers,
>
> David
>

