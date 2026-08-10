Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6C2C5B567
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 18:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3A26B008C; Mon, 10 Aug 2026 14:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57BAA6B0092; Mon, 10 Aug 2026 14:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4912D6B0093; Mon, 10 Aug 2026 14:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07DFE6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:54:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7456F1C0AB7
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:54:20 +0000 (UTC)
X-FDA: 85086260280.02.9537FF2
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B10C40004
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 18:54:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tSrLHodn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786388058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BFLIcMV+TsQl8fF5Kcteeza9u+Vqp87MX/t5s46zNlY=;
	b=oLwYvmBAtf2oBHigB0paLJmej2Y7IZJK72DHPSv5jgM5DbtjWXoeiIGeLlCcdUv2aOCRRb
	8dGIrTTicg+xujsDBD6LAC6YAk5NUGwAjPS0Mqcobx7tFtFmvwM5eNYYYdel1qfs3nRzCz
	eMfdAVNFi1cHZN44MgBVlyw7ccwnJ1U=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tSrLHodn;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786388058;
	b=J8UEePokgM3qE81SGe7QZrfbiZrFZlV2j71E2VQPmxsskdsJE7/GQRbbiRX+6q80Zj2220
	T3NhV8QlCQ/ReZaTy64PDTO+W1t4g2diSiPY1X8y5XteNlFoPgXWgkEjf1jJNQ8Jy0VcTK
	tazdIOgN0aTWuWb1djiCVUA+wnC495A=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-51c01c79467so49081cf.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 11:54:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786388058; cv=none;
        d=google.com; s=arc-20260327;
        b=XeMXsUi3OiObHyA6XqwNqMxW8em1QLfv1TdU8sjS+/LSgWUVgQx4yeSCqgVgEOfNOk
         IzECD9ISLZu0KFHUQTprhIK9oYtBhzdHaLrYiAkP21CnZxg9wsJd8i/Z5PpsTgeLZPb5
         YnbZ9as05bwEPyaql+yTZ7Riv1MCPelwSkqoGrGAvWwFp0GQzOBpNqqa17sDS1vktxLY
         /37JURMDu++NM8aP2jnpe32wDQMliXUtPW2hVwIj42ysw+++6ZlFTQYvb0Jjy4Xde68u
         uK4cFAeza5UodEFtxb6jhhJ+iI+xfUbdHtUoDUfiNwpzkYO3BTFfSni33kYrIUzdGwy7
         zSug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BFLIcMV+TsQl8fF5Kcteeza9u+Vqp87MX/t5s46zNlY=;
        fh=LYjxE1YFLm+3abBQjW2q7UmiY90tGB39x3i7o0fmr2M=;
        b=k7JhboPbZA8ae7hONJVeqPYOomywu2sq8eKVeJxtHt6TRegQ4HEcmp3nYk1JyflQ2M
         nxDtPDMQqykXOI7hpvc6luyKC6KyF1Djb18405AhdUV4ybbjklJwFyScHMZ5rm8HFoel
         UR4Bb638gXIRiBdimYh0V+BL0ziWhBJDixCpgSkl6MT0YvfZOIO/rEQXjp6mWEuWK3mL
         8Z6UCOA8W/zYYB/tawbQISGVmqwbyyzt1t/xLuBXYyxJ2yyKY/PnLfFw06r0JVow0+EW
         HjIA300Ir0W2j1aQyVUScWqrdtBiSpIwmkpjKGsnM89g2XpEsUuzmm+bGNIsBUood0qd
         SLVg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786388058; x=1786992858; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BFLIcMV+TsQl8fF5Kcteeza9u+Vqp87MX/t5s46zNlY=;
        b=tSrLHodnrxh3tLBDX2SOhou5GIzzFJx9Kwv5cnECE2DWQNkax1c8GPuk1/c8oqHUxp
         swUPlFBS2AUMPjADXS5AKCg7tMQy/CpO/fmWY7tiEesDHWLPd+3FH6/wBjmaSxLyOKY/
         YBzD1OKlPR81oLwxwGFmeqWvgar7r5IEjn+hsjijxpRHokUAEcRPlfYtrfWyXXGCkJoY
         kLbMWv/AMCS7ZuVpxBqRKvPfEhadlRl1gbm+jhLou2QF1BIwX79i49BJ1nNbnqsk60lj
         vCvZ/VNR6iEcoufcrxuNM8bgX4T0anpdNt0Czj/EhG2NBBZlKmaERiJSFVN+fIdWbVsz
         VdnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786388058; x=1786992858;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BFLIcMV+TsQl8fF5Kcteeza9u+Vqp87MX/t5s46zNlY=;
        b=jb6PsUuT7mv+YhFxn3MLXaEReDROWpulSvuKfXQh8pcAFg3d0ZRADyKmd8dlGuID/C
         NifEMGkaObFgqEVk9E+JXvKQEUEgv0m2fHWfxJ8Te5kln1Upz3WAeAMuhqujC/14HhWO
         cKsHC3kLrTwk433UGD4Ym9GRMq+NOoTYmPsmgE5IY7aDvpX83InJw75MpmjPNfGjVAqh
         cNqPOd0hIGUmi6Qks/W1OjLnldSKPZkElCv/8SteR5Ocr95VaA1NeIUrF+/zOZIy3Q9h
         YUtv9q4a0VmgwwcitL2w/sV/z4eEJYeJsZ3pJn1ePVoc+A7789jCNrR+173azEeViRAE
         gEzg==
X-Forwarded-Encrypted: i=1; AHgh+Rol8vSsls5uruiFRMdbC9kudHqGOz9csr38ws1Y2mlM7R8eQuvaiZJYiNNj7oLG4KuuGMLcBfqLHQ==@kvack.org
X-Gm-Message-State: AOJu0YwHt252T917QZxyQUWISBe+/IzhIwc2/7n/tTNhNfMBwoNGld0W
	JKyeIeQ5x2Kz+B6mUnY/s/dAewT58Dxc63nhUUfaV3EFHScm35zRgh5WT+67HAhMI/ueAhwv1Ed
	fk7ozkaxBuPueCKy/B/g/jBgqJFj1aJs3HDGiw7oC9qCzSHDXeim3aKsJel8=
X-Gm-Gg: AR+sD13nLobpWch2ts1rnQxPJdWHfuzcnaXoNbfZBbQkv8LXVoMypu4feogH/waA0s9
	pwVoVK6w7QqjuEjufjI3fqAmU3CnyopWnlPGyfrgiA3il7OQ/OyWLeJ3r2sol+6T2F92wJcSxhN
	Fn8rzAKrI0wj7XLWzq0Va4oZicr++c+CGWD5rx1JNZJUCeUz/Odq46ljIuf4uTo6mFgn0IzHG6U
	X4w/AMlhHXieWulQuqC2yZQMOkiFSkgE+Xb48dm9GtW3ryvD9dCb1N1DqJWxztAilMh5AuIUyJZ
	5zQWKmoc+aM0eYE55jw2BZvqC+YVNDeEgx4DD9g87jI=
X-Received: by 2002:a05:622a:9d3:10b0:517:64f6:3365 with SMTP id
 d75a77b69052e-52d51130743mr2428451cf.4.1786388056958; Mon, 10 Aug 2026
 11:54:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com> <20260806200548.3124802-3-surenb@google.com>
 <anoZL76y3WGXMArB@google.com>
In-Reply-To: <anoZL76y3WGXMArB@google.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 10 Aug 2026 11:54:04 -0700
X-Gm-Features: AUfX_mzCGUT1LBwKi19AfwqzrR1sfNDLiDeo-oSbRDVrC4hKEjbi43WPU9iVR8M
Message-ID: <CAJuCfpFCK5ycO6s+dD35YtU6zgNdivfe6P3cVnd2VxPYfGXHDQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/5] binder: Make shrinker rely solely on per-VMA lock
To: Carlos Llamas <cmllamas@google.com>
Cc: akpm@linux-foundation.org, dave.hansen@linux.intel.com, 
	Liam.Howlett@oracle.com, ljs@kernel.org, david@kernel.org, 
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org, 
	jannh@google.com, aliceryhl@google.com, arve@android.com, 
	christian@brauner.io, tkjos@android.com, dsahern@kernel.org, 
	davem@davemloft.net, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B10C40004
X-Stat-Signature: aggpk3934dneram36119uwx8i8sxpxdp
X-HE-Tag: 1786388058-591097
X-HE-Meta: U2FsdGVkX18oqwY98v5pQoLktfkp+kfbUOgouLRVwvmbJt4F6xL+hV65djgjG+ZObKaZW3KubnyUE96U3atJ0J930ajNUUmLfNhXTYlxuRhj+lu6yo+JSnfRv9i+YXgX054fbO4cDGFQbLPSA4H3SpRKa+olBWZEws0La75ZwavUwDXpDZOP3k/lP+K7GFio7CH8NI+QnXnHeeSkv9knhgdEQ5rNtmAcl6ki+ZcTP3LfjfIrJ0KOtIoQJQU2QCvzc4uP8d9XQhxXLP9WT3CHO8+eYjMDWypjzFmADAkr0EqIfvf9PUT9inphBTtHrbH1wKn/Hp+0nWfmXMV4/QkSqKp4k5n7Q+xtZq2K23aqdTggL0S80o3aADoFa23UNis/Jnn6FCtdRvMSMflIzI7lCqUKA8yhp/EFtRZ4TB6XuwTjLJlVFaLPvJwVZBm5PLR/ViIoYq9uQUHjfIwmxj5W4Rza3FkVu5waRamCFAnDRz1WglvGZtlAUIH4kWSlz6zEQpLqiBrBgvuEGKuKiH7wI6xWbQVEu9U1u2yKHEg40QW0FBLgIy/grc22ExROJScmgUMIUdtrRwFFMHMEDmoW73IRJC13yu2weJg7kMbk0lxrNjGCWHlTtvE66ce+gv2tOfXDg1CvMOr/FTWLmoIdOR3rapO7C8EKZvnuq1xPuwkI5qKXl4hVA7ro+7RUNRk4+K1uGNWs1fhVcgSghaI09EPgP0hviT9eQmbWhh0THmHDXpFGjaMIdDuSOynF38Moc9ITFtr+17ZXs8EiBWMT0zsVVrOoT670yqeBEcD3ZQyC9F9f9C634AHhUmCpQ8ANMRPJ2d4xnkTpeLFj4sCNrwlcX/JCwv4uSY2Do6Dcg7h4eGddbeHGe/ZLOpSych2Mh0bGGQP+fs+nzBv5AfRMg1kbDr3RGxFARfsKKu2MUCzxwg3RBh4wdfyYNtckqIcBmn5yMTxa26DCAS02hSU
 5C2h+zvK
 QvQ+DvDWBUTKw7aN6WEElZKdI45gY4yQOT0c+60+sZ91GxgMW2uSyYMduBvPbDlnjbnvXnvuFB2qLEU+8IOVPX5bqi+e6iJphfcWllFdmiuDKezs3HYqWztCxeW/FCX2VO9QKh0CNz9CZMpFkyIWqk74EdSu1CVjc6YWL0x9OlR94H1etvN0GSyxJRI0CVvQGxQHA1I+XTpWI4/qYaLioLt5PIEl6pTcELnehdyomwL0sgUgY9qvUveVQzvsPOdYJzWbROW9QLqy+1tmNE/DnQRBDHodIAU8PAN4Q8kZKBBRSAjvzOUvzPyBrZyE47V2I16P1KORPqQPljkv0Oi2smNsXWAyFeP4hPTDYJX41pcg5ZNvJEUlUdyvi6piiEqMGE9plaEzUkt04ugcuaJQj9KhhDldn6lCfOByg5KHJAUtSXr+IrIAFCIZpbegMoVZujf64bJ8DGTNXb9gPrwzuNQhAXjAaaJOdPMladwqYVy02093HeUGVpGLRzdcc7HQUj2NApXIA2qjcxhSCeSB0E4n0nn/TtdmZmRdUElbSh4OG309MlwGYjYVh5T4dlQ+xY03dp72MwaoI5f88+NS54zrTto3RqoWBmZ+Ruqnw5OhYnGAZiZwPrhMVAD/mxDF+kcAIpQ9CTqj5NKmuVLAYDdY47wh+AjOJOmY1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 11:32=E2=80=AFAM Carlos Llamas <cmllamas@google.com=
> wrote:
>
> On Thu, Aug 06, 2026 at 01:05:45PM -0700, Suren Baghdasaryan wrote:
> > From: Dave Hansen <dave.hansen@linux.intel.com>
> >
> > tl;dr: lock_vma_under_rcu() is already a trylock. No need to do both
> > it and mmap_read_trylock().
> >
> > Long Version:
> >
> > =3D=3D Background =3D=3D
> >
> > Historically, binder used an mmap_read_trylock() in its shrinker code.
> > This ensures that reclaim is not blocked on an mmap_lock. Commit
> > 95bc2d4a9020 ("binder: use per-vma lock in page reclaiming") added
> > support for the per-VMA lock, but left mmap_read_trylock() as a
> > fallback.
> >
> > This was presumably because the per-VMA locking can fail for several
> > reasons and most (all?) lock_vma_under_rcu() callers have a fallback
> > to mmap_read_trylock().
> >
> > =3D=3D Problem =3D=3D
> >
> > The fallback is not worth the complexity here. lock_vma_under_rcu() is
> > essentially already a non-blocking trylock. The main reason it fails
> > is also the reason mmap_read_trylock() fails: something is holding
> > mmap_write_lock().
> >
> > The only remedy for a collision with mmap_write_lock() is to wait,
> > which this code can not do. So the "fallback" after
> > lock_vma_under_rcu() failure is not really a fallback: it is really
> > likely to just be retrying in vain. That retry in an of itself isn't
> > horrible. But it adds complexity.
> >
> > =3D=3D Solution =3D=3D
> >
> > Now that per-VMA locks are universally available, lock_vma_under_rcu()
> > will not persistently fail. Rely on it alone and simplify the code.
> > The removal of the fallback does not affect NOMMU case because binder
> > driver depends on CONFIG_MMU.
> >
> > Full disclosure: I originally tried to do this with
> > lock_vma_under_rcu_wait(), but it did not fit well with the mmap_lock
> > trylock semantics. Claude caught this in a review and suggested the
> > approach in this path. It seemed sane to me. So, Suggesed-by: Claude,
> > I guess.
> >
> > Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: linux-mm@kvack.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
> > Cc: Todd Kjos <tkjos@android.com>
> > Cc: Christian Brauner <christian@brauner.io>
> > Cc: Carlos Llamas <cmllamas@google.com>
> > Cc: Alice Ryhl <aliceryhl@google.com>
> > Cc: "David S. Miller" <davem@davemloft.net>
> > Cc: David Ahern <dsahern@kernel.org>
> > Cc: netdev@vger.kernel.org
> > ---
> >  drivers/android/binder_alloc.c | 45 ++++++++++++++++------------------
> >  1 file changed, 21 insertions(+), 24 deletions(-)
> >
> > diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_al=
loc.c
> > index e4488ad86a65..c13a588c37de 100644
> > --- a/drivers/android/binder_alloc.c
> > +++ b/drivers/android/binder_alloc.c
> > @@ -1142,7 +1142,6 @@ enum lru_status binder_alloc_free_page(struct lis=
t_head *item,
> >       struct vm_area_struct *vma;
> >       struct page *page_to_free;
> >       unsigned long page_addr;
> > -     int mm_locked =3D 0;
> >       size_t index;
> >
> >       if (!mmget_not_zero(mm))
> > @@ -1151,27 +1150,25 @@ enum lru_status binder_alloc_free_page(struct l=
ist_head *item,
> >       index =3D mdata->page_index;
> >       page_addr =3D alloc->vm_start + index * PAGE_SIZE;
> >
> > -     /* attempt per-vma lock first */
> > +     /*
> > +      * Attempt per-vma lock. This is essentially a
> > +      * "trylock". It can fail even if the VMA exists
> > +      * for 'page_addr'.
> > +      */
>
> Do we need to explain how lock_vma_under_rcu() works here?
>
> >       vma =3D lock_vma_under_rcu(mm, page_addr);
> >       if (!vma) {
> > -             /* fall back to mmap_lock */
> > -             if (!mmap_read_trylock(mm))
> > -                     goto err_mmap_read_lock_failed;
> > -             mm_locked =3D 1;
> > -             vma =3D vma_lookup(mm, page_addr);
> > +             /*
> > +              * If the vma exists, we can't continue because we cannot
> > +              * remove the page from the vma. However, if the vma was
> > +              * unmapped, it's okay to continue.
> > +              */
> > +             if (binder_alloc_is_mapped(alloc))
> > +                     goto err_vma_lock_failed;
>
> The comments seem redundant, the label is enough. This works:
>
>         vma =3D lock_vma_under_rcu(mm, page_addr);
>         if (!vma && binder_alloc_is_mapped(alloc))
>                 goto err_vma_lock_failed;

Yeah, for the binder maintainers what's happening here is probably
obvious, but when Alice explained the logic to me, this comment really
clarified what's going on, so I added it here. If you insist on
removing it, I'll do that of course.

>
>
> >       }
> >
> >       if (!mutex_trylock(&alloc->mutex))
> >               goto err_get_alloc_mutex_failed;
> >
> > -     /*
> > -      * Since a binder_alloc can only be mapped once, we ensure
> > -      * the vma corresponds to this mapping by checking whether
> > -      * the binder_alloc is still mapped.
> > -      */
> > -     if (vma && !binder_alloc_is_mapped(alloc))
> > -             goto err_invalid_vma;
> > -
>
> This introduces an "extra" change. We'll now release pages without a
> valid vma (e.g. after munmap()). Before, these pages were expected to be
> released via close() in binder_alloc_deferred_release() later.
>
> I don't see anything wrong with it. However, it does seem out of the
> scope of this patch which just drops the mmap_read_lock() calls. Or at
> least I don't see how this part is necessary.

This check came from this discussion:
https://lore.kernel.org/all/anGrFIYiPhjxWSkD@google.com/
It's added for consistency when handling cases where the original
Binder VMA is gone.

>
> >       trace_binder_unmap_kernel_start(alloc, index);
> >
> >       page_to_free =3D alloc->pages[index];
> > @@ -1182,7 +1179,12 @@ enum lru_status binder_alloc_free_page(struct li=
st_head *item,
> >       list_lru_isolate(lru, item);
> >       spin_unlock(&lru->lock);
> >
> > -     if (vma) {
> > +     /*
> > +      * Since a binder_alloc can only be mapped once, we ensure
> > +      * the vma corresponds to this mapping by checking whether
> > +      * the binder_alloc is still mapped.
> > +      */
> > +     if (vma && binder_alloc_is_mapped(alloc)) {
> >               trace_binder_unmap_user_start(alloc, index);
> >
> >               zap_vma_range(vma, page_addr, PAGE_SIZE);
> > @@ -1191,23 +1193,18 @@ enum lru_status binder_alloc_free_page(struct l=
ist_head *item,
> >       }
> >
> >       mutex_unlock(&alloc->mutex);
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > +     if (vma)
> >               vma_end_read(vma);
> >       mmput_async(mm);
> >       binder_free_page(page_to_free);
> >
> >       return LRU_REMOVED_RETRY;
> >
> > -err_invalid_vma:
> >       mutex_unlock(&alloc->mutex);
>
> This mutex_unlock() is now dead-code.

Ack. Will remove.

>
> >  err_get_alloc_mutex_failed:
> > -     if (mm_locked)
> > -             mmap_read_unlock(mm);
> > -     else
> > +     if (vma)
> >               vma_end_read(vma);
> > -err_mmap_read_lock_failed:
> > +err_vma_lock_failed:
> >       mmput_async(mm);
> >  err_mmget:
> >       return LRU_SKIP;
> > --
> > 2.55.0.654.g21b8a5bc05-goog
> >

