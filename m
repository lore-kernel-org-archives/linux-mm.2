Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55487C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 13:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06BEA6B0088; Sat, 29 Aug 2026 09:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01C326B008A; Sat, 29 Aug 2026 09:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4E2B6B008C; Sat, 29 Aug 2026 09:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCDFD6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 09:54:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9335812012A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:54:15 +0000 (UTC)
X-FDA: 85154451270.14.F32E2DC
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9B04B140003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:54:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IvYJavQ9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788011653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eOJDD5tWPDHOsVb80QoaWRjR16NkDSsX//qgGD2tc1A=;
	b=KIVa9NPbInAQ6vFrwNZPuZKUv/lJ5DjURBwoVu5Ra/rpMI/jvOthp4R5cO81Zs/Fie56/1
	TQon6EjqWTV4bEnN6lXnJHYr7X9+Q9sDmyAdZZokUc0b/0ep612SQAcP6rTo686db/ldOy
	V+BsqYp/HEwObDOx/zSKHw3aZrNSboc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IvYJavQ9;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788011653;
	b=zhOzZV5gmW6dNLgA3+6jMbvcXdljuouBxDAmsLsUi0/XI7Te7SHyV468fqiRhQttj+qErL
	svfZyl3pfUJVPY3tyc2ImJoao6MIQzNnGXOfc1yLUVXsKGqorbd5o4/g18zKlaz9HtB4FM
	a9N91bYSo7ZrCwI3mB+6eYF1IR5l/gk=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-482e2fdf5abso872272f8f.2
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 06:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788011652; cv=none;
        d=google.com; s=arc-20260327;
        b=Ofc0LN4MgQ1qmO5hbVY+qmv7/5qiPgjrBxgQd8fPmi72UWYQWUP/xRrdoTxPPQydL+
         TxEShpUfslDGZTNdrAHIR8BSsA1gSD8vlq0oC9zjWjjvpPSdrhvzzZOdj72I3rVINRmk
         wZ31VmEB3QFEBhjTjAd0pKapqCufWL5IORSSfZW41rjSvdKehDgC+QeDw16HDkN7V8Ps
         LuZNmhRVx0+wkrKNGCyYqVBlP5y5GaDCqt93GEqOtQKSsUR/zA4TiZSnns0irlfIFPmt
         tlesPSFxJQZUEdRGX4LSN+9haTzqxcu0UHH7U0CeRN+RyfLHOf40ZlZaveniYFZmdrEV
         BISg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eOJDD5tWPDHOsVb80QoaWRjR16NkDSsX//qgGD2tc1A=;
        fh=yA235Kb57ztpFoLGaNQ63vcOmbSK0Iq2Iun2bwYI3MM=;
        b=hBvcnThtav5Hr+fZgfxcxCO+S2ozpisuaR1ZXjNGJhwaZkJYKsBy8fMuvhBFVAWRCH
         c8wx71IhyY7B1pvFfMOCaAerex83tkng0cCo4YAaVRjSaf+BCnl+zMmf2KNUMUdy53MG
         yZJvd45GwoI9ozUKu6YHnis0XHENtVc/hxtS44ouRgGeJIyeSIShUVOAcSgdyS8sX4gu
         a0drDFhAZuS/++cEOpuT+VCnWOlom5CRJhEodNdaKxNlExWK+600V9M1f2KQ2xh7grbn
         bGog7Xj+p9sRZgOP/HMYfmGbK29k0PdLqaDkXSgAy5K8yLzwpcNluc/PKXm4tCpf4nye
         gilQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788011652; x=1788616452; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eOJDD5tWPDHOsVb80QoaWRjR16NkDSsX//qgGD2tc1A=;
        b=IvYJavQ9QPEDyzsHFzjwZVj3IPCSh9707gcScQI4BuOJqGqFnaT22VYlNRKEhPmIBz
         +Phhl2LllauHNIiNTs0bR82TkxIv+TGu7K+9lMt5UU7R3Td+5+fdYtcTHcK4JPreOfkQ
         HaV/awkG0PjeRRaG8Gc3qWJC+kTkuujNcRBvuRqGb5h8vd/RM1AiUVazSzg67LnbraMq
         rFTZthRVP2VQG5TWMkzO6IhLhjX5FuY1j+UJo9610ll+DBfouFzumiLc2nwIkq4iB6pU
         wjkWmVGXVeoYQOdDbDflGVaGtZ1ediW1yaYdNf5n8y9Iikm7hn2UFTH/bLwFtmQA2EbE
         WoHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788011652; x=1788616452;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eOJDD5tWPDHOsVb80QoaWRjR16NkDSsX//qgGD2tc1A=;
        b=Gkep4MEoyG4/wydmFo+MbBdYM5lp1q5HqD5c02qOWzmq13haPtzv21m5GwhRpBq0mP
         pBshL6VMUrHxpdicfOuHCUxBvgtfQB8mtVMVNcHgLSfo+RA4x1SA+cCvABZeHUayViNk
         icWpEdwNEoVKNCJxw2xc6ZiqaSmhGF6/TlW+/SHmN6Tk/xoYsMaSuNHybP9wEIlHTsGn
         IfXMIKc8eVZRr66Bty8xgBIV+6uivdYZrO4X7xVpodSc1hUMCMDK+HoSmHa1yys/lBPz
         a9D2zMCc0uYYp4zIgyQo6Y35uDqWxgDfdRF8hQMv4ET0RJak1HMpBoFp+eBkg+NYtMs0
         iKCQ==
X-Forwarded-Encrypted: i=1; AHgh+RqfowTmNnrNfjiGPrpNQECw+bJOV9hPDUgOrVcPpC1i8dDxRz5AwhkQo8kxZmhJ4H0n7RxcaU3jMw==@kvack.org
X-Gm-Message-State: AFuF++lqfLl2K6WLGC7BJePsU4wwYNi/yKgFvyQEl7zn8VVO7KLbOvBm
	FUNqDkgAp4DFPbvgmNjq6EPSDxwuX9KLs/1s6F+v/bw/60E5dLPzeKIn/dh8kF5wws50V6vh3qh
	ClG5VYQQLpmLIFNjME1iJxo/AEFINFB4=
X-Gm-Gg: AR+sD10fZSwr6zT5zoJJxpZtBGBtzWjzopjHFGVnZBUaZDb/B0cpszeHUn/4NdQ0jcv
	Ar8+Fj23rQ08Bd2qwX0/4OoIsWa5HbaExkMl9PYXgKjk7vs4JSx701+k5MdOOo/b5nydSX62Yei
	Ppbp7XSnpsBm/qkVpDcrfG0Q2Gp6R98llLwNDSYSuw/W31bB6kaVtWBwmidKd/J426q6jLK4RKJ
	AXdeO/SW1/UUUbFj/gNFi8zS6W8FX+0/nO+b3efvu0nvna1T74U3t5RYAjDWyz/JV1I1yZ/bWJA
	Iolno2QwFwvyi9SwwdCmek/0ptzhkxwp2LFWIYg5YKqxnQ==
X-Received: by 2002:a05:600c:c08a:b0:49b:9657:e32e with SMTP id
 5b1f17b1804b1-49b9657e6e7mr157154755e9.8.1788011651185; Sat, 29 Aug 2026
 06:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260828094823.594279-1-kunwu.chan@linux.dev> <apFa2eTBzBP0RPeb@gremlin>
In-Reply-To: <apFa2eTBzBP0RPeb@gremlin>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Sat, 29 Aug 2026 21:53:59 +0800
X-Gm-Features: AcwNN1XmZSbM2-97nIs-gSLFNho3Z-KBB8yuqP6_zOcjt3RwXj_so8lSUfJ91HA
Message-ID: <CAN_Opa9BxKiSY5Xui1q7_9LFLCodRps+dQQG2-2kx+5+OP0j=g@mail.gmail.com>
Subject: Re: [PATCH] mm/mremap: fix locked_vm accounting for MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1xtbqjrg3bk8d3i51kr365wysiz7uuxt
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9B04B140003
X-Rspam-User: 
X-HE-Tag: 1788011653-250569
X-HE-Meta: U2FsdGVkX19R8Cagn8e6BPpiCIgk6m4YQggdEVxESYHu9kIrGpdYvm5yy8AiaJUV/8RTGodjFiN0foglF0g7PWIC9quQGTqRQ++Xe3coC7dEbcengUH2sM/UpHo1u2AMw8fP+SOlaij66ZICWBuKc3OR6M0mVtVy6kwfOW1TbExYXMwa4M5Va3kh2TwZnruCfZsxgaFi6gwLxbWDLbCAD1vo2Qfhv6QUCRAT0aFGd0ruuxJ+S7cuLnYRrhjvJ8BGmKp/fJL8+tH6DR6l7MoZdUitUAhoHXNqZTSiDac7xSebKrNPeV6p9XdgCgINchOCjSVxGUB5kgyN2l9YxE8jBN5zft/s00a5TBi2KPqFhKjSBxVnqEhSdH39bqPFDnvHB3c2KrTvF/GH6v+SGrUlwAHsHVt125yI0y8z3OKin5DkGtXL+eHyaFO2yIPco9Wnk9llgDVhFU1GDHgLJqgZMM+kZVS6K8l79kvVoRDVea9sp8V+tFjQ2wEJxRSd8mNDaC3UcewOXGKVFnabYMW0MQty8Un6lENZ31hCHqrv2gyHSGZy2epPgSy3ex0bJz2OVoIxNSe1y/rpuo1oC6jaY5Be57Jx1ZLQBjXpyvaD7/f+nsHuqtAQ3iZxdFAiWL82XywZG4QwlViDMbrjVLEvMMDqi7nI0iGOeI3YmDgbl/RHxxAxAYYfdXVCC+OzbNjZpXcXRYtibGgnmAcINbKKYlzTYiSibb4KWuT+2hWl0FiFOXpQ5oYHI8+C3PptWqJf9JrQ2v0LUt+C9WCN8ZJwniYdDkwK7vFjz0EGskSptGuwWvKRGCw4RspRiC+ToNuOjANm3UAJuze2dyf2GLAYVIb9vIdHHWjfqAItcmrTnH0MRxsRq+B/4TtBR7nuiZLPvemPSgRu0Kg5tYTYnxvrfjaTqe4ltuDg1gl+RrjfVDQfzA10EIv/x8GgHyAs92Anj9CSwZKktfy0n7GC0hR
 4BmnIqGz
 rbqz4JDdjPp4/2VmiM4EbEySTAK+n7I3S5qQVBrFZ8Su7QLq2J2Ewt7pHeh/vsM10iT3Wr1REMW9r2obRnMjhTEMbXBziBX77o//16Qw6BG28nFz8T5vupzruhtkEb5GrbGoC0v6bx716gzTGuojk3MCJ+j4PkXVrpJdPMAZgXpnURcHcO/n3hQ0HAZRBYq0pLDiveRwU4Ry3de2gnRXm2nb3SE2raWDypGBk1tLQfzQ4bAyjb7dbvz/XpA+wq9P7CQQ/yxsWk7uD/AVoYiKWsAT/aKBOSXjTpWgu7FZMsxjt6zNCXmT/m7WlFNqfCJeM/dW5X94c5LzBKzMlGwzvyZTkZJy2SKFCkzqFrJbCf4S6kKuJLboKr6oDtSKyqAYMsNl9Xk4Ypp3BvtQU4HQ1L883Sws2xYwTx0CpFwh/n+22FqRCwyvD7MdJRbFs+qmZ2eutMRWtY9vgJZRK9M1qAr+aFdfH4uweLUyyzibpdbuk9u95k4bdIah2yw1B/rWSrbWPKWChx7mxfO4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:16=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> On Fri, Aug 28, 2026 at 05:48:22PM +0800, Kunwu Chan wrote:
> > From: Kunwu Chan <kunwu.chan@gmail.com>
> >
> > When mremap() is called with MREMAP_DONTUNMAP on a locked VMA,
> > vrm_stat_account() increments mm->locked_vm for the new VMA while the
> > source VMA is still marked VM_LOCKED.
> >
> > For a normal mremap(), the source VMA is subsequently unmapped and the
> > munmap path decrements mm->locked_vm, balancing this accounting.
> >
> > With MREMAP_DONTUNMAP, the source VMA is left in place and
> > dontunmap_complete() clears VMA_LOCKED_MASK.  When the source VMA is
> > subsequently unmapped, VMA_LOCKED_BIT is already clear, so the munmap
> > path does not undo the increment from vrm_stat_account().  This leaves
> > mm->locked_vm over-accounted.
> >
> > Undo the locked_vm increment in dontunmap_complete() before clearing
> > VMA_LOCKED_MASK.  MREMAP_DONTUNMAP requires old_len =3D=3D new_len, and
> > only VMA_LOCKED_BIT is checked to match the accounting performed by
> > vrm_stat_account().
>

Hi Lorenzo,
Thanks for the detailed reply and your fix patch.

> Hmm I don't love this approach.
>

I agree that explicitly undoing the accounting in dontunmap_complete() is n=
ot
the cleanest way to fix this. And your patch is a much cleaner solution: mo=
ve
vrm_stat_account after the if statement for MREMAP_DONTUNMAP to
keep the behavior unchanged.

> >
> > Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
>
> Are you certain that my rework patch was what introduced it?
>

Yes. I compared the MREMAP_DONTUNMAP path before and after
b714ccb02a76 and traced the ordering of the relevant operations.

Before the rework, the DONTUNMAP path cleared VMA_LOCKED_BIT before
vrm_stat_account() was called [1], so the new VMA was not counted towards
mm->locked_vm.
[1] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/mre=
map.c?id=3Dd5c8aec0542e2d79b64de9089b88fabdebe05c1e#n1016

After b714ccb02a76, move_vma() calls vrm_stat_account() first [2], while th=
e
source VMA is still VM_LOCKED, incrementing mm->locked_vm. The
DONTUNMAP path then calls dontunmap_complete(), which clears
VMA_LOCKED_MASK but leaves the source VMA in place. Thus, when the source
VMA is later unmapped, the corresponding decrement is skipped.
[2] https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/tree/mm/mre=
map.c?id=3Db714ccb02a76e170f3e6475749ed0812ee25f777#n1161

This before/after ordering difference is what led me to identify
b714ccb02a76 as the regression commit.

> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
>
> In general while the patch doesn't seem super AI-y I do see a sudden upsw=
ing in
> patches from you in 2026 so I do have to ask whether LLMs were used? If s=
o
> please follow https://docs.kernel.org/process/coding-assistants.html
>
> (I hate having to say these things but hey, it's 2026, so.)
>

Regarding the increase in my mm patches, I have been focusing more
on mm since this year, and had already been doing quite a bit of mm-related
work with some friends before that. Like [3] [4].
[3]  https://lore.kernel.org/linux-mm/20260430040427.4672-2-baohua@kernel.o=
rg/
[4] https://lore.kernel.org/all/20260422021842.78495-1-baohua@kernel.org/

I was also away from community activity for a period due to wedding leave
and later leave to accompany my wife for the birth of our child. During tha=
t
time, I continued working on some of the mm/DAMON work I had planned but ha=
d
not yet finished. After returning, I had several pieces ready to send
upstream, which is why a number of patches appeared within a relatively
short period. Many thanks as well to my wife for her support and efforts.

Thanks for the reminder. I'll follow the kernel's coding-assistant
disclosure requirements
for any LLM-assisted work.

> I'm kind of inclined to do a fix myself a different way here.
>
> Given it's going to be a backported patch and you're relatively new to mm=
, I
> feel like this is the safer route, sorry about that.
>
> Happy to add a Reported-by/Closes for this however.

Thanks for the fix and for adding the Reported-by and Closes tags. I'll
keep learning and working on mm, and hopefully grow out of the newbie
stage soon.

>
> > ---
> >  mm/mremap.c | 10 ++++++++--
> >  1 file changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c
> > index e8df5cdb0ac..37ea5ee1986 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -1334,6 +1334,14 @@ static void dontunmap_complete(struct vma_remap_=
struct *vrm,
> >       unsigned long old_start =3D vrm->vma->vm_start;
> >       unsigned long old_end =3D vrm->vma->vm_end;
> >
> > +     /*
> > +      * vrm_stat_account() accounted the new VMA while the source VMA
> > +      * was still locked.  Since DONTUNMAP leaves the source VMA in
> > +      * place after clearing VMA_LOCKED_MASK, undo that accounting her=
e.
> > +      */
> > +     if (vma_test(vrm->vma, VMA_LOCKED_BIT))
> > +             vrm->vma->vm_mm->locked_vm -=3D vrm->old_len >> PAGE_SHIF=
T;
> > +
>
> I don't love this as an approach in general.
>
> As above, I think I will address this slightly differently.
>

I saw your patch =E2=80=94 it's a very elegant solution and, I think, the b=
est way
to fix this. I was a bit too eager to fix the symptom and didn't think
deeply enough about fixing it at the source.

The fix looks clean to me from the code review. I'll test it as well.

Thanks again!
KunWu

> >       /* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> >       vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> >
> > @@ -1343,8 +1351,6 @@ static void dontunmap_complete(struct vma_remap_s=
truct *vrm,
> >        */
> >       if (new_vma !=3D vrm->vma && start =3D=3D old_start && end =3D=3D=
 old_end)
> >               unlink_anon_vmas(vrm->vma);
> > -
> > -     /* Because we won't unmap we don't need to touch locked_vm. */
> >  }
> >
> >  static unsigned long move_vma(struct vma_remap_struct *vrm)
> > --
> > 2.43.0
> >
>
> --
> Cheers, Lorenzo

