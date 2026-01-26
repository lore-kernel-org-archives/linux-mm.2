Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FEAFC88E4A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 05:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69916B0089; Mon, 26 Jan 2026 00:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE99C6B008A; Mon, 26 Jan 2026 00:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5E56B008C; Mon, 26 Jan 2026 00:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AEF506B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:47:53 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54308BA9BF
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:47:53 +0000 (UTC)
X-FDA: 84373033626.12.FB99176
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5CF8D8000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:47:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RWNmiVYA;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769406471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ono5wEe1osDw2iE22hQcZURKz2YR0r2QKp0J45Nys8Y=;
	b=iHTfn/A1vrPWikns7Jhzo6jO9AKZ0TPQiqjxNPYqWTdNtBs0PUApYeDIIhlwRLziP7vQdT
	I5v10Dtcgv0aMa+IEGfjjwXaWLTEDHw143XYw18vgJhjmSXce3EQ9/mxMq/9SGXk2PkhRT
	njLLnDgGBPWWQG/Nm+HYeFZ4Jb6RoyY=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RWNmiVYA;
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769406471; a=rsa-sha256;
	cv=pass;
	b=kIdQrl4jrWbv9ZyvEekoCFBGU28x+NoCFJWosYSprHho80ElRw5fHrOo/INst6s7NTn8PL
	gNkSPjT5LAVjdddqhLklJdYEywliEUuhkH56+wkKSf0OTOLSybSHo/ey3t6rpsLoSi/mw4
	1tyVopXjRK3Iwl2YBGWGGNdJjP6ljhc=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-501511aa012so823551cf.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:47:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769406470; cv=none;
        d=google.com; s=arc-20240605;
        b=Y9CeL5TrIXeDrC5NCH0YhioR2hq3M+wWeWBnk5NqCOxPkOIF+ndeftMVYW9F2zWQa7
         VTFMrQJgZ5duR1jz8W9ZTzsFlO1mVk3im/0bg8XBAcsrByE8hOBvA+hR6BzJXDGy6N3O
         4Y2gnEhi/6xUORK9mx5gbDP2uTrwxHM3tPRL5LDbbIYhp0dYmtZ0WMsSp00gste2nrmB
         Nf1zU8sqZqEss9Pr2GJqh2xVQtnSCWhR4dTbB0qyJWp/F+AM/ycEbSTkqex90KCmq89+
         ZzHFC4pAPbtX1YfFb6D3TWBGHFjRvllvb4weFXFnDdohvFjQ2DSAkv7Kd5D4+fQwrScC
         FyHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ono5wEe1osDw2iE22hQcZURKz2YR0r2QKp0J45Nys8Y=;
        fh=FXK8Xz1e29aZSFojguJn4wn+U0ONpqt4IWtMjFhnQi4=;
        b=ijPYIEe9c9+HmriVfHTtJy52fRLvP5uIHvCvTcuV5VapwDhABK9DwrS+ueICiKzLWY
         bLGt0hoFkIyudybjhs7HNBALZv/5ztoLF8pk0U1JDi65YYzfRCrxiGM5OkA+Fvm3AbMO
         4EUZlQOVHa0GbGkhF5g+nsmxPu2ZpDBYGOq4fxWCxOfbZv39sUWaJ8KBva2qWWsFW1JS
         xzz7XOCYgF//wxNqvnShaQtzOvo7SvSyp2NawYFOJBh70t4lvYcyfQcjf9P44/ZJlpDi
         1AUbZGlOu+kSuc6CAEchys+vfqGJLdRxoQS6i/TcqsNKIBqs1nipNRFPQU1jewh+Ypqo
         X2TQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769406470; x=1770011270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ono5wEe1osDw2iE22hQcZURKz2YR0r2QKp0J45Nys8Y=;
        b=RWNmiVYAR2nMmq8d/Frbbsy7zqWYNYO7tejqytjTKcKuBMIlS0MYmBg3zTm92DrLvH
         3yNnempup7lCcDP8jJVMo8j9VHpMkGAgWhQl/QseGBBQNNR+JAmcvuivIee1QF3uzhD2
         OjDpHe3yEYOw4sLqAUSm9F5L2JVVdEppWNZselWTWK6XviMs6KL+VFMLZ+up89japqYj
         0DmP4PioDdyo/+qr1iZbknibvgRxDvCG7FrDoCrO11MxhpZ+S9zEcryBE2Qq04dXMXNG
         vgGiuLlxcjMcXTKXPtgtD5fPgZxrkFxgOiyMPSgTmjP4SHc3qTC078KqUV3IirYgsLIN
         fwMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769406470; x=1770011270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ono5wEe1osDw2iE22hQcZURKz2YR0r2QKp0J45Nys8Y=;
        b=CI5P39ghCIQ9B+WzIgTto0oCAUPseZuJnS+qwX7b6owspMeNvDKQmCPucZf50VVhrH
         f/rjiXkxiyTSeHKPHhUA51eKoJwRntfqHzQdc5SBJHey0+RXNiJxA5IPuZm7cukRXGCQ
         fZVKoBbpjRFZgpuJWESQeytd+T2EF/8Il2d84fomeHq6HFfaAFBQnKlqj4J5R+2KXk5Q
         0E8tTZNnUFZjeZ8vUzIPnXeU/Cmi19fFEZO3jzfxuiHrcY8o2NrA1CUT365v4tUp9830
         EW85q5u0qL+qzuiwz0A8MII/KFtgjJp9Vg6rGWFs8DIxLJjwivk6UqDyemkMf6NkWoPa
         3q1A==
X-Forwarded-Encrypted: i=1; AJvYcCVfjlfRuhWC2hDRkvkD/AS1PN9iD16xMMJFW58lfw4JGkl0q4X/tiyeXT2FF8AgQHLviuy9tQdYVA==@kvack.org
X-Gm-Message-State: AOJu0Yw9D4DhoSzwCaDYVZ2dnQqEBjDAJKeZ5/OGATaZeGGfbztgN2HU
	OSsWIK8pR9tFf7Vj+1Dhy8nJXFPKe0GyhoO5O490Wrj38NH00300lFlCLOZcMH3QhnHyriR5et4
	y7DkYbLUrLRU6wXtYDXO4bXaYtBT0bUtd8kBjXWXOvoEn5zRRUbdEmqIeZww=
X-Gm-Gg: AZuq6aJL7ODFR6jJuYodw78geD7yr+nPHj8ZPVoV0vtrne9jQcg6g/r7kh6NZQZdTm/
	mOANuZypCPxv3AL9kvr0mfK22rQAscmTf5KKPvoj0g1CJRJA95dP8U1hP447s62ZnS2vCsliLJT
	d6uqjPi3kAiZBDmaxtkSqCtU7SUynxTQ0JQGtk1I/0G1HHJHySkUTmS8/wXMu9Gy/T655svkVx3
	yb1d7JP69Ps0cyQokMIvlmb9VKM/pVaBwUWAOU2L/1OnR0J32WR+VTE0mGfUguBBgMfT39LFbmA
	PfXN
X-Received: by 2002:ac8:57cd:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-5031430a8b7mr7932911cf.8.1769406469898; Sun, 25 Jan 2026
 21:47:49 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com> <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <33273be9389712347d69987c408ca7436f0c1b22.1769198904.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 25 Jan 2026 21:47:38 -0800
X-Gm-Features: AZwV_QgbHT43t7haH8iPqdCJ4GlQ7FA-MKST17eTIePy2kXbjFdUganqOrfH_IE
Message-ID: <CAJuCfpGK63E-EtX4V7+Mgf9-KdBfvb27kzyZH6pYoYuzUQPnxQ@mail.gmail.com>
Subject: Re: [PATCH v4 06/10] mm/vma: clean up __vma_enter/exit_locked()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: wmcmkhf3uiujf71tcgm5c5adjp1tztrt
X-Rspamd-Queue-Id: 5CF8D8000A
X-Rspam-User: 
X-HE-Tag: 1769406471-308306
X-HE-Meta: U2FsdGVkX19Mqs0sKNSvreuIzCL3szcnbLq/2hdmkHQBq01K/dHDolhmIRo7/FgQCV8VT3pckYvt1/dWsR8Z03EDPyIqcUF210l+c6JJkhgXHm/jyvAH9ZMNRRmERW18xERSvd28OASArBA1JcYAo5XjvwChHBF05DHF9S0aLUh8Tzqcvuu5O9Nd4HjWuHqmtPIZuAEDAd4Z2xsRbvjMfGwauCPCNlKt4gCU3QQZV2C9GmV6+W1hcgx9cQF9AcB/4d+QQ5S4nzd130IKyYa9eo9aKX55FCiMk/ALVOP6DHDB9aulbGhZjJZF3bUW8si/YakTBuHHvmcvDturuTthaf0Tba2kn+8ZMmm2HoUPDQthqcufopcR6rAl6Uwe/5RkfzZBrinqbtf3CidKPNgTGlmJSKFCnUkipX96F5mV2vpUdYJpUQdAUML+9DgsgDOhHSAo8GXfRAtgwfG2IAOqtyn/a3eUlLZuvev9rkfQyj41zvWXbVVy0TBhu/mdzp1i0UV4d7nqrLlU/mf3iRIAHgZagUfhEgJjdZhnhUEkBSDyKywQ+wxZbeEt6a6Il23Pm1e30Ykqwpj+zX8Wuavno6H+4USJ3Hn+k7uhulZ31cYtbBdbcFAE/sRDF93Tv4P29wLJjHtbkoyKWnmdz/9Q8CUINpi2SeG7+ztExTdhNoplcUN9fLTdBXWM8vECY+VGXYGVVLFtT4Tz3AGd9g1ez3hdOomwI+PGFFyP8jBafPIN82629GrH89Gttk8A/MrxKs/KuYkHX4avgWmZ/ijEufwT2tOb4/1DAQDc/6hk4zgcoiMOdOwJTntrw1a3sPcCbqAw64hjouBc4iOt+O/kJbqZ5H5XxNzmf8L6HVm6qE8TGFsp8ILxJ2DC5AckqIpPZYyuQEO+gwsDRdFfJz0ikEUidz5EtT3pG4QkuHBx3W2+Ha0XI+cV0s90i4byTLktglhz46mf+9lmnVn5otA
 cpAShMMM
 8Af+NHe8oK+f1LUStdKevCBucuoul6b4CUONM7neeXuzlu8ArrU3Yzrd096fj6k4blNaJrsoeeifMEGxXJrKOhgviVKZZE2cKVTROqAhbbyx1ysRkn5cd8lxQ/zR0s/nbH1pvoo/7ETRSQG1amARWiFyQITjAhPOmD+AmwKqTUQfnLJUG485rrgOYFNzSzfDJ0fq6CCWwwG7niTMgD9EbosNggoCxKdvkk3U1CQHa98xf1oQYeERvRLKdDjK/86NQyD8IEmfp68UW+4Q38a9BpugCcjoPGITzWbXI5YfTidrI0zG4Qo+Pm94CcYT6T9aYhtBcoJN5IdoFsqix9S4PzN4xu91GZpb5uFV+52o83BgMDmDijDcxtwHK2eZCY56S9edKRox9XO0dtahbNZNSXNtipQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 12:12=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> These functions are very confusing indeed. 'Entering' a lock could be
> interpreted as acquiring it, but this is not what these functions are
> interacting with.
>
> Equally they don't indicate at all what kind of lock we are 'entering' or
> 'exiting'. Finally they are misleading as we invoke these functions when =
we
> already hold a write lock to detach a VMA.
>
> These functions are explicitly simply 'entering' and 'exiting' a state in
> which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> as being write-locked, or mark the VMA detached.
>
> Rename the functions accordingly, and also update
> __vma_end_exclude_readers() to return detached state with a __must_check
> directive, as it is simply clumsy to pass an output pointer here to
> detached state and inconsistent vs. __vma_start_exclude_readers().
>
> Finally, remove the unnecessary 'inline' directives.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h |  4 +--
>  mm/mmap_lock.c            | 58 +++++++++++++++++++++++++++------------
>  2 files changed, 42 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 1887ca55ead7..d6df6aad3e24 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -211,8 +211,8 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
>         newcnt =3D __vma_refcount_put_return(vma);
>
>         /*
> -        * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> -        * their reference count, so wake it up if we were the last reade=
r
> +        * __vma_start_exclude_readers() may be sleeping waiting for read=
ers to
> +        * drop their reference count, so wake it up if we were the last =
reader
>          * blocking it from being acquired.
>          *
>          * We may be raced by other readers temporarily incrementing the
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 1fabda07c922..72f15f606093 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,19 +46,44 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
>
> -static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
> +/*
> + * Now that all readers have been evicted, mark the VMA as being out of =
the
> + * 'exclude readers' state.
> + *
> + * Returns true if the VMA is now detached, otherwise false.
> + */
> +static bool __must_check __vma_end_exclude_readers(struct vm_area_struct=
 *vma)
>  {
> -       *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
> -                                         &vma->vm_refcnt);
> +       bool detached;
> +
> +       detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG=
,
> +                                        &vma->vm_refcnt);
>         __vma_lockdep_release_exclusive(vma);
> +       return detached;
>  }
>
>  /*
> - * __vma_enter_locked() returns 0 immediately if the vma is not
> - * attached, otherwise it waits for any current readers to finish and
> - * returns 1.  Returns -EINTR if a signal is received while waiting.
> + * Mark the VMA as being in a state of excluding readers, check to see i=
f any
> + * VMA read locks are indeed held, and if so wait for them to be release=
d.
> + *
> + * Note that this function pairs with vma_refcount_put() which will wake=
 up this
> + * thread when it detects that the last reader has released its lock.
> + *
> + * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases =
where we
> + * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal =
signal
> + * is permitted to kill it.
> + *
> + * The function will return 0 immediately if the VMA is detached, or wai=
t for
> + * readers and return 1 once they have all exited, leaving the VMA exclu=
sively
> + * locked.
> + *
> + * If the function returns 1, the caller is required to invoke
> + * __vma_end_exclude_readers() once the exclusive state is no longer req=
uired.
> + *
> + * If state is set to something other than TASK_UNINTERRUPTIBLE, the fun=
ction
> + * may also return -EINTR to indicate a fatal signal was received while =
waiting.
>   */
> -static inline int __vma_enter_locked(struct vm_area_struct *vma,
> +static int __vma_start_exclude_readers(struct vm_area_struct *vma,
>                 bool detaching, int state)
>  {
>         int err;
> @@ -85,13 +110,10 @@ static inline int __vma_enter_locked(struct vm_area_=
struct *vma,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
>         if (err) {
> -               bool detached;
> -
> -               __vma_exit_locked(vma, &detached);
> -               if (detached) {
> +               if (__vma_end_exclude_readers(vma)) {
>                         /*
>                          * The wait failed, but the last reader went away
> -                        * as well.  Tell the caller the VMA is detached.
> +                        * as well. Tell the caller the VMA is detached.
>                          */
>                         WARN_ON_ONCE(!detaching);
>                         err =3D 0;
> @@ -108,7 +130,7 @@ int __vma_start_write(struct vm_area_struct *vma, uns=
igned int mm_lock_seq,
>  {
>         int locked;
>
> -       locked =3D __vma_enter_locked(vma, false, state);
> +       locked =3D __vma_start_exclude_readers(vma, false, state);
>         if (locked < 0)
>                 return locked;
>
> @@ -121,10 +143,10 @@ int __vma_start_write(struct vm_area_struct *vma, u=
nsigned int mm_lock_seq,
>         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
>
>         if (locked) {
> -               bool detached;
> +               bool detached =3D __vma_end_exclude_readers(vma);
>
> -               __vma_exit_locked(vma, &detached);
> -               WARN_ON_ONCE(detached); /* vma should remain attached */
> +               /* The VMA should remain attached. */
> +               WARN_ON_ONCE(detached);
>         }
>
>         return 0;
> @@ -148,14 +170,14 @@ void vma_mark_detached(struct vm_area_struct *vma)
>          */
>         if (unlikely(__vma_refcount_put_return(vma))) {
>                 /* Wait until vma is detached with no readers. */
> -               if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
> +               if (__vma_start_exclude_readers(vma, true, TASK_UNINTERRU=
PTIBLE)) {
>                         bool detached;
>
>                         /*
>                          * Once this is complete, no readers can incremen=
t the
>                          * reference count, and the VMA is marked detache=
d.
>                          */
> -                       __vma_exit_locked(vma, &detached);
> +                       detached =3D __vma_end_exclude_readers(vma);
>                         WARN_ON_ONCE(!detached);
>                 }
>         }
> --
> 2.52.0
>

