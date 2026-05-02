Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97F7FCD3427
	for <linux-mm@archiver.kernel.org>; Sat,  2 May 2026 17:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C341F6B0005; Sat,  2 May 2026 13:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE40F6B008A; Sat,  2 May 2026 13:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2926B008C; Sat,  2 May 2026 13:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBC96B0005
	for <linux-mm@kvack.org>; Sat,  2 May 2026 13:31:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 320861A052D
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:31:30 +0000 (UTC)
X-FDA: 84723171540.14.54EF47A
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECA4A180003
	for <linux-mm@kvack.org>; Sat,  2 May 2026 17:31:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EoHGzuJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of mohamedaymanworkspace@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=mohamedaymanworkspace@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777743088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQM8xMMQir7Az8E/XShDWfAfWxWocMMC62B1U4cdVXg=;
	b=J+pxvgFZ4K6bSMKKKaYZ3imUCBq+uFeC9Mkwmw9Cypi6iiCwtev8WGDNxnZNEtz9HXpJB9
	h7BEPqilod+ulZTyGxY1Uj9ctp00xb99720mac9jIZhMKYH6LpByLjEY8N7/ZrAismY7x8
	PA2Ur6VxMMafv9OS52rcSbAR8ekOLjc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777743088; a=rsa-sha256;
	cv=pass;
	b=XsqX+nK7D5O59VIOANXx4NJiaEMYJkri14xsE8BXi+HPSAZK2zM95+8dFOJyleG5ClGXR7
	5bmQ1w+/8Ld4Tf4gg0t/OeS5IUbJ9sodPVLDWJLgsZd3er6HMjxUAea2EeLUu1kU1z5OVe
	Mc5noMz103YFl/Ds2JP1KEI+FXqxKnk=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EoHGzuJL;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf24.hostedemail.com: domain of mohamedaymanworkspace@gmail.com designates 209.85.210.49 as permitted sender) smtp.mailfrom=mohamedaymanworkspace@gmail.com
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7de44ed7a11so2432977a34.1
        for <linux-mm@kvack.org>; Sat, 02 May 2026 10:31:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777743087; cv=none;
        d=google.com; s=arc-20240605;
        b=Uzm7+Ul6g02+ByfPjI8fZh/Jch+mx77UIMc1f/Ltpdmkwt25L8WHIYn7PKyS9iuGSd
         4u6jzvWcC1KX4G+PdYkkALSofa8rz2ru3V4yTPc1vlRqC18zOomsBg47RiWvfKd6Vjd6
         +5rC83f3xHLfJBZh5GEiy94xq+Wut8+XP0HtWubStxP0Y4SuK5X8eC8sVPHeFqVxqQXF
         1fd/MlTF+a8cEzoG2d0GKmYrpWOBnZ8o7Yem/Y/DQTD25Yqoocgpe0ZLdxMpDo/qDXBR
         nd4GjQKDS6OCb1S2Nd941Vf9T/jm5AvrENYTa+4FjZZaSZDAys8CxdxNCigTMHjkn1Bs
         rMkw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WQM8xMMQir7Az8E/XShDWfAfWxWocMMC62B1U4cdVXg=;
        fh=Ck8BPTJrIBQaL5Vx+x3mwq3atXjluVXHYF+Shq5Fao4=;
        b=R8FrE8hV11vsu4WhNrJmKgys5KEUHreM/JAAyI2CBs2tmpFr1xkVM4G+j6eLx0oV5U
         5fZuLibPow2jdTbGElZTejGwqkesrlQkCejXH6013Xp6VruUylx4PH6hJy5sxygLfDjI
         0SI4Zse5FIhf3YU0oL7VDAkf55PsypjpYBCO8w4A6s+8MKDaR8vW7SCplydolzBLYO5O
         qaQX0lBPfg66n12W4o0THWOVE9M3kOXblz6Leppv8wQ7068vhRL7V0fNHbxwOoBpuwBd
         K1NzphS0zJ1K9CQznmfnPfhlWPqHyvY2lxRWFB5oYcHxADsHlbx3ZUsTgIUtrPujrTyi
         RKWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777743087; x=1778347887; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WQM8xMMQir7Az8E/XShDWfAfWxWocMMC62B1U4cdVXg=;
        b=EoHGzuJLp0446vap/+SQE9q7pfA0KXdWngoUz/eZraTB651XOrm4btLLe7p8ZjEEWF
         ALakjan8ALP0ZQwOsGEghioBZMIccLSrm9h9iqyI3T4xZkBZ2UYZK8UGMYzoJwBcrAjr
         jtlYO1vykBCkYjv2+RoJu3lXL5rUoxFOczQqVvmnkhtZyv+FYvWagmTcriH1atd+Aqtn
         cJLTb4ppeHKS1d/WYyiX74/2ZjohejtvXgGyrUp7t8UbLVCRhOY7VUPuZj5Z0UXMZxuz
         DX+Gcn3DVhkbLN8nHUOcJ3SueFOmLBIsR1l8ge06giy2KQYUOV1fYsN55Jq+3lun8qdl
         EPLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777743087; x=1778347887;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQM8xMMQir7Az8E/XShDWfAfWxWocMMC62B1U4cdVXg=;
        b=ge0MpiEXSh8fI8Zkr2m8/lrHowCJ3rmRDxsdITNHyg1Yi/HvELGYOu96Vqm1SZi2jY
         o0otGn1qPX/H4ZfcKgBJtrh8b/WBAIZmlKLAnpQqQTWOqVwsIdNgxn8+AVCbI4guQVZT
         C3FBXqrWb4btNqup1W2iqh2rWW0SVldp79hL1qB0iIUwLPfagQhTN2qLV32qhEx+gBtZ
         2+HGFai6hEZqjeTRdNS5ZF46xUVoA2Ehfgs5F7PTHNUhIRVB7pbYkB/UhQc8TqK3dlfa
         OZRczv84hNaCkW3GlNv3kSrRtNV3DvRkrbDUcP0UJFAmQ4APQlaWJrakHRc8cvNqynDn
         YLjA==
X-Forwarded-Encrypted: i=1; AFNElJ8HHSwKRLVHn74V+umCWGQYHKIPZr8dMFuZE8rOhbQmwQa0oldijjSpcZsygHumPbUJAsUfCaLcow==@kvack.org
X-Gm-Message-State: AOJu0YwKWAAoRP7GBen8uYYW/WcV3G221z8ovGIrnFqOrNrTaY6IxIa2
	SA8WER0XnDJQDwNdWd0rretfwYBPlDjhWBSvfk5diuMQQ3yRc7+qGeClG4elcjkoPlcgaBZs9+5
	FrvCea5R7TVgnnlR8LN9qErmN9ki5UZQ=
X-Gm-Gg: AeBDievBQPkmJ2suupak1CZx/D/PZr+ITF8OLhC+1cL7ulpgxoy5iB+8VWcP2b0xn30
	lEOGx6Gb79IP9vW9JECGiMsN5TWH55avRmzjXDALbS4QL6cUu3QhXx6b7cqA1CexhGxGW15FqjA
	DCJjwmyY7vmPk2cs2QWXRrVTc04ExsSpG9L13HF/QkT9uQiGQ7Pu9ZiCQKWLqRtoWW1iv96xMLD
	39OWuaxUBhTHQ233lE8aPRqg73LF+czbGoo/qSHsp/+OCx2aHKoXk3qX/GwiTMl77B9LZevXCFI
	h8NtljGHEatHHeY0zSD/j64jk7ZmAT8G+Ybr6AijGk6bTp2EZzCN
X-Received: by 2002:a05:6820:169f:b0:696:27e2:83ee with SMTP id
 006d021491bc7-696979ad2b8mr1792171eaf.3.1777743086707; Sat, 02 May 2026
 10:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260502155730.430232-1-mohamedaymanworkspace@gmail.com> <20260502102436.79d5e53038169f38e4075137@linux-foundation.org>
In-Reply-To: <20260502102436.79d5e53038169f38e4075137@linux-foundation.org>
From: MOHAMED AYMAN <mohamedaymanworkspace@gmail.com>
Date: Sat, 2 May 2026 20:31:13 +0300
X-Gm-Features: AVHnY4JF3YONqC3ismWcs77M73GMYYkJdCZIC26d6j6VcqSyWamvuSChNlrQkH0
Message-ID: <CABWZVhp9uT4mK1+iCJbO3Neitjk3hcgvVC=LWLQ+5T64+OER3g@mail.gmail.com>
Subject: Re: [PATCH] futex: Drop CLONE_THREAD requirement for private default
 hash alloc
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	"open list:EXEC & BINFMT API, ELF" <linux-mm@kvack.org>, "open list:SCHEDULER" <linux-kernel@vger.kernel.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Yiming Qian <yimingqian591@gmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/alternative; boundary="0000000000002f65650650d9110b"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ECA4A180003
X-Stat-Signature: wtq43o5frksmkf66u6igapnpd93qbn9a
X-Rspam-User: 
X-HE-Tag: 1777743087-305565
X-HE-Meta: U2FsdGVkX1/YzDqgc5O6t1HAauBdg7K6LkC7W/va/5fP/UOUGdXv19+5ISodEzXAR2zlP14Sab5anWQ7zuRfevd1oI9YPl6jgnNQ5DFgNskFP0MfFJER8gbtKoK4LBZhrI5Gc1mEEHWtqjJzdgPCsWIvcoQBzUka2kc6d5pYOb2VfGg6fZStPQ46A4B8IQoHHOOd+blhjKolqHu8HASNHSrZlzouuBGgmKL0EPZcvpNJ8A21OCSThBwsdmGTd1S5BP0Hsk8NZw3PgqSoKVRxbjWrGpJauEAmkpL602Y64QEnERKFMStvPsPzmpI6u8e0obrh1trvRkA/CcE4ZDdZC6dqJDXyGNg5GScMlHT6fQZmGDWZidH8e/xyt0fY+k0nf8JDNbUkWuOWjszkJi8PgOJLj5vb8mw+ZD+5GuGDRAoLItwznlAkR2kZIlky5n2xpAs2qhqq627SGBJ1eDLxcy6KsKmCmcd3zI39dfF8lRxUSAI0q+4XchR+5jAoQ8RngEtVIGwuPuD73Wpu29qvPoUptKimyr6Lx64fMA76N6QM7q5s3Jla4MudAI1UagbNd1G90u/N36Hczt07kzUvKaoQMiB+h2jlgqA9QLN61lEvpiQDuFubAzBkgtStna/aFCYFVLkFoSuoVtH/7AYM7rjztX7k8ULBRiGtwOhs7JSmoICf0uwpignVmUceGkLAHj3bsyvhZM4xItGyuz+025003tLttfvEhHy7la0DrLMl/6TvLDjkR1etedLniLiEImCEQHGjI8xmhrVoyE5r5vGa/pB42qZrelgOPfETi6+p+MIc5ZV2N46xKKmFL5NN8Pm3Yt78MIhIB2jmG3cegQQ9maqXlmcv85vJXQhGHk5l0sOJ4bgvr/DgmVaBmrpzHCeUNY1zE3qoNpPNL13QN3Dj3uTxJN8nufVH+af9gUUvDYOi6P9QVGWSjOKDosJuCF2LT7vrK8G5oTdOGaO
 Rr7TdY1z
 GcGW+QFg4t0+rvUULMRC+wV0uwmP8qSa3zCryu63DI7YvQvPgGBQdugp/ey8sXuNu/Nz4pPK1DIMFIRiuaoeuHDG7IVZvGvN1vkzcHtoZhxu0HWIsoNiL0B/bXmcOu4zsbp4qdfmWMq84YQpkCi8J9RckeFV3+PxUa4BLManfMW6FvBBT4JM1O3AO/dH+Jl1p/oqaHMKmwVPv/9NmtLtWtZkHm5ZojaCgfVMTLmPqt0kST89fgjaHFzZbEuXOqOwhW+ylW/MSYFhWm7zFydjFrk/87lchlc2ztBpODEz9MaFoEIqd1kep5fcqXHKV9j381/WNM9tb2DaGRH5uH81QyWcZr6Tocx4e9sxNovqyxa04r2x872nHL1ig1Q9bUeHbWZk3De3rq1OWfPfoyTzcpPo7OAok1E6yuq4Y/xyA9jMUEvblrlRjS7Am2tqEEn/TvQOxx2YcKfq7iW+COIUeiogCOEEfHnxs0SjPAgugt+YtrieLzG2gQrjYVuRy58J8BLGY4CmtWYraXkZ69y1xt0zjvXMqPqxufTZJzq0h0TJK78KQRCsJAzTALR8KIgBDKhqKqJ0wNczRy7iK/oefViq4qzjCkHpJkBLUQFW7ilxyC/XgsgBPA5FT52yw4VbQwu/u/p2ihMH+W+Cgq6RHBBALJ3q9PVgKBjtQO28wlGeoWj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000002f65650650d9110b
Content-Type: text/plain; charset="UTF-8"

Hi all,
Please ignore this patch. It was sent in error

Regards,

On Sat, May 2, 2026, 8:24 PM Andrew Morton <akpm@linux-foundation.org>
wrote:

> On Sat,  2 May 2026 18:57:29 +0300 Mohamed Ayman <
> mohamedaymanworkspace@gmail.com> wrote:
>
> > From: Davidlohr Bueso <dave@stgolabs.net>
> >
> > Currently need_futex_hash_allocate_default() depends on strict pthread
> > semantics, abusing CLONE_THREAD.  This breaks the non-concurrency
> > assumptions when doing the mm->futex_ref pcpu allocations, leading to
> > bugs[0] when sharing the mm in other ways; ie:
> >
> >     BUG: KASAN: slab-use-after-free in futex_hash_put
> >
> > ... where the +1 bias can end up on a percpu counter that mm->futex_ref
> > no longer points at.
> >
> > Loosen the check to cover any CLONE_VM clone, except vfork().  Excluding
> > vfork keeps the existing paths untouched (no overhead), and we can't
> > race in the first place: either the parent is suspended and the child
> > runs alone, or mm->futex_ref is already allocated from an earlier
> > CLONE_VM.
> >
> > Link:
> https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOkt9p2wwYQwAbMh=PifC=VsiBM6A@mail.gmail.com/
> [0]
> > Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
> > Reported-by: Yiming Qian <yimingqian591@gmail.com>
> > Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>
> I hate to get all bureaucratic, but....
>
> Given what you've sent and from my reading of the security@ and
> linux-kernel@ lists,
>
> - I can't find a patch from Davidlohr which looks like this one - I
>   can't figure out where you got that from.
>
> - I can't find any code from Linus which would lead to the addition of
>   his Signed-off-by:.  I don't know where you got that from either.
>
> - Let's cc the author of the Fixes target, Sebastian?
>
> I'd like to have this metadata tightened up, please - so a reader of
> this patch can understand who did & said what and when and why.
>
> Thanks.
>
> >  kernel/fork.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> >
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index f1ad69c6dc2d..5f3fdfdb14c7 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1951,9 +1951,11 @@ static void rv_task_fork(struct task_struct *p)
> >
> >  static bool need_futex_hash_allocate_default(u64 clone_flags)
> >  {
> > -     if ((clone_flags & (CLONE_THREAD | CLONE_VM)) != (CLONE_THREAD |
> CLONE_VM))
> > -             return false;
> > -     return true;
> > +     /*
> > +      * Allocate a default futex hash for any sibling that will
> > +      * share the parent's mm, except vfork.
> > +      */
> > +     return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
> >  }
> >
> >  /*
> > @@ -2380,10 +2382,6 @@ __latent_entropy struct task_struct *copy_process(
> >       if (retval)
> >               goto bad_fork_cancel_cgroup;
> >
> > -     /*
> > -      * Allocate a default futex hash for the user process once the
> first
> > -      * thread spawns.
> > -      */
> >       if (need_futex_hash_allocate_default(clone_flags)) {
> >               retval = futex_hash_allocate_default();
> >               if (retval)
> > --
> > 2.34.1
>

--0000000000002f65650650d9110b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto"><div dir=3D"auto">Hi all,</div><div dir=3D"auto">Please i=
gnore this patch. It was sent in error=C2=A0</div><div dir=3D"auto"><br></d=
iv><div dir=3D"auto">Regards,</div></div><br><div class=3D"gmail_quote gmai=
l_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Sat, May 2, 202=
6, 8:24 PM Andrew Morton &lt;<a href=3D"mailto:akpm@linux-foundation.org">a=
kpm@linux-foundation.org</a>&gt; wrote:<br></div><blockquote class=3D"gmail=
_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:=
1ex">On Sat,=C2=A0 2 May 2026 18:57:29 +0300 Mohamed Ayman &lt;<a href=3D"m=
ailto:mohamedaymanworkspace@gmail.com" target=3D"_blank" rel=3D"noreferrer"=
>mohamedaymanworkspace@gmail.com</a>&gt; wrote:<br>
<br>
&gt; From: Davidlohr Bueso &lt;<a href=3D"mailto:dave@stgolabs.net" target=
=3D"_blank" rel=3D"noreferrer">dave@stgolabs.net</a>&gt;<br>
&gt; <br>
&gt; Currently need_futex_hash_allocate_default() depends on strict pthread=
<br>
&gt; semantics, abusing CLONE_THREAD.=C2=A0 This breaks the non-concurrency=
<br>
&gt; assumptions when doing the mm-&gt;futex_ref pcpu allocations, leading =
to<br>
&gt; bugs[0] when sharing the mm in other ways; ie:<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0BUG: KASAN: slab-use-after-free in futex_hash_put<b=
r>
&gt; <br>
&gt; ... where the +1 bias can end up on a percpu counter that mm-&gt;futex=
_ref<br>
&gt; no longer points at.<br>
&gt; <br>
&gt; Loosen the check to cover any CLONE_VM clone, except vfork().=C2=A0 Ex=
cluding<br>
&gt; vfork keeps the existing paths untouched (no overhead), and we can&#39=
;t<br>
&gt; race in the first place: either the parent is suspended and the child<=
br>
&gt; runs alone, or mm-&gt;futex_ref is already allocated from an earlier<b=
r>
&gt; CLONE_VM.<br>
&gt; <br>
&gt; Link: <a href=3D"https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOk=
t9p2wwYQwAbMh=3DPifC=3DVsiBM6A@mail.gmail.com/" rel=3D"noreferrer noreferre=
r" target=3D"_blank">https://lore.kernel.org/all/CAL_bE8LsmCQ-FAtYDuwbJhOkt=
9p2wwYQwAbMh=3DPifC=3DVsiBM6A@mail.gmail.com/</a> [0]<br>
&gt; Fixes: d9b05321e21e (&quot;futex: Move futex_hash_free() back to __mmp=
ut()&quot;)<br>
&gt; Reported-by: Yiming Qian &lt;<a href=3D"mailto:yimingqian591@gmail.com=
" target=3D"_blank" rel=3D"noreferrer">yimingqian591@gmail.com</a>&gt;<br>
&gt; Signed-off-by: Davidlohr Bueso &lt;<a href=3D"mailto:dave@stgolabs.net=
" target=3D"_blank" rel=3D"noreferrer">dave@stgolabs.net</a>&gt;<br>
&gt; Signed-off-by: Linus Torvalds &lt;<a href=3D"mailto:torvalds@linux-fou=
ndation.org" target=3D"_blank" rel=3D"noreferrer">torvalds@linux-foundation=
.org</a>&gt;<br>
<br>
I hate to get all bureaucratic, but....<br>
<br>
Given what you&#39;ve sent and from my reading of the security@ and<br>
linux-kernel@ lists,<br>
<br>
- I can&#39;t find a patch from Davidlohr which looks like this one - I<br>
=C2=A0 can&#39;t figure out where you got that from.<br>
<br>
- I can&#39;t find any code from Linus which would lead to the addition of<=
br>
=C2=A0 his Signed-off-by:.=C2=A0 I don&#39;t know where you got that from e=
ither.<br>
<br>
- Let&#39;s cc the author of the Fixes target, Sebastian?<br>
<br>
I&#39;d like to have this metadata tightened up, please - so a reader of<br=
>
this patch can understand who did &amp; said what and when and why.<br>
<br>
Thanks.<br>
<br>
&gt;=C2=A0 kernel/fork.c | 12 +++++-------<br>
&gt;=C2=A0 1 file changed, 5 insertions(+), 7 deletions(-)<br>
&gt; <br>
&gt; diff --git a/kernel/fork.c b/kernel/fork.c<br>
&gt; index f1ad69c6dc2d..5f3fdfdb14c7 100644<br>
&gt; --- a/kernel/fork.c<br>
&gt; +++ b/kernel/fork.c<br>
&gt; @@ -1951,9 +1951,11 @@ static void rv_task_fork(struct task_struct *p)=
<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 static bool need_futex_hash_allocate_default(u64 clone_flags)<br=
>
&gt;=C2=A0 {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if ((clone_flags &amp; (CLONE_THREAD | CLONE_VM))=
 !=3D (CLONE_THREAD | CLONE_VM))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return false;<br>
&gt; -=C2=A0 =C2=A0 =C2=A0return true;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * Allocate a default futex hash for any sibling =
that will<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 * share the parent&#39;s mm, except vfork.<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 */<br>
&gt; +=C2=A0 =C2=A0 =C2=A0return (clone_flags &amp; (CLONE_VM | CLONE_VFORK=
)) =3D=3D CLONE_VM;<br>
&gt;=C2=A0 }<br>
&gt;=C2=A0 <br>
&gt;=C2=A0 /*<br>
&gt; @@ -2380,10 +2382,6 @@ __latent_entropy struct task_struct *copy_proce=
ss(<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (retval)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto bad_fork_ca=
ncel_cgroup;<br>
&gt;=C2=A0 <br>
&gt; -=C2=A0 =C2=A0 =C2=A0/*<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * Allocate a default futex hash for the user pro=
cess once the first<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 * thread spawns.<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (need_futex_hash_allocate_default(clone_f=
lags)) {<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0retval =3D futex=
_hash_allocate_default();<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (retval)<br>
&gt; -- <br>
&gt; 2.34.1<br>
</blockquote></div>

--0000000000002f65650650d9110b--

