Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF7BAD6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30CA86B02EF; Thu, 22 Jan 2026 13:08:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E4346B02F0; Thu, 22 Jan 2026 13:08:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F9896B02F1; Thu, 22 Jan 2026 13:08:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E74C6B02EF
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:08:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB54A1A04CE
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:08:01 +0000 (UTC)
X-FDA: 84360383562.25.70A42B6
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id B04F81C0011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:07:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rRXJFpKy;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769105279; a=rsa-sha256;
	cv=pass;
	b=phJXUxEizskQCgEwSX4vxUTnBcmG1yMBYb41QHaBaIZdMEMzAx55LVc7yDhBBggfcy2cZ9
	hwJzmVMjGrCH3lI4RXZopn3wSemgFT1N7QlKFCrpZ/MU2VgsymQokPMvtHlTnFikapA2C6
	+xCh6ML0YMMzW+naEmcjw2rh7nr2qps=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rRXJFpKy;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OjdUwnpsHtoIlxN53mjKwTtHv8VX23Qu//ARq0k4aO4=;
	b=AbPPyCM9WFZy6/NEU0WdJPWQOxriTLiE7wqVist2qwhXQWHeYZCE6wULc2Vc/R+rl1JeeJ
	IirJXlC+aPltQ97mcI7GOWWTouJa+pBwUWiqFFiv6tmMR7LiHW1VHoguJUqYeI9drHpaab
	pH3Ly4sAx0KYB9ByLLU3/UuB19hv6tk=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-5014b5d8551so24191cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:07:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769105279; cv=none;
        d=google.com; s=arc-20240605;
        b=grTrwBzTL7aZ3Csemla3lAvFN7o/XHa+/mtSbg3MFx8a0vL1Zn5DrkJsj2ECMt1XnA
         wu0Rd5OzpFFlutLDFiJ17KF8DRqSA8D5j3lT1UGQlKsIekSmhL3amSybmdjdcGI+bz3k
         mnfkdURpRSljSVzCDmCru4e5FAHzO7CBr93qTr9DojQxp3Q6Yx96gE/OoeuiamBeE8Xv
         Ems33sc4z1VSXTbt6hoqKYC4p61VZpr0iiiKqEWSfdtAy/xQTytyzdKsqmdKudCZnz+l
         lEGW9BKKG5jsA2nn3PmrpsK8VnSh0gRk/0pV/1Yc+zGyrqHAWo2WVvE3lQr5n3GmC2Cf
         9N/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OjdUwnpsHtoIlxN53mjKwTtHv8VX23Qu//ARq0k4aO4=;
        fh=vMp0pUolAlnlhUdekP0xXpZnvsWBH25g3RiKIp9eY9E=;
        b=iB9vUmjlz1IIk4FVgFOlthry+QgIuLP4cNQM5UNuUA7lyeG/Ve4ng2EcyKP3gbTGnx
         NNVBe4IuUkcKtcl05btMqcsZsb1ZU0yaOEvM1xoKVQ142kXNgGcdVrSD8VCVm792VmWf
         H6O5FRcnWrF3Se9UCYVdFWdGFHq+ARqg0NAjSIf/ceVzeXtiqb0GQT0yyltz89GxJJAn
         mk6mKAqngjjPP/kXmShDPhdXN77CR621Cc+j1uOGbT7JPaHVxPZEYlmXEyagV3S+lcVs
         uUS7njmonJrJim6XLhXbnhOPdqUDm7y6lnO6fQmYJlEuoF7Xla7hF+KdiWJFr4tSe6ky
         TSBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769105279; x=1769710079; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjdUwnpsHtoIlxN53mjKwTtHv8VX23Qu//ARq0k4aO4=;
        b=rRXJFpKyEUqw6GDQSm3FzraiQIFHOSOO9b0HskESoF43JJZpJl9zkJs1MSfcJuoS6c
         qip33vUbQ74iLKztq9Q6RJdqZqgyz6C04HyEhJHCQfe83naCFDO+p2Jf4hvI2aQBDxfz
         ctreRTvmfpYe3UsvgLLL23gGtJUQwE0d8bJfih8HWna0vGRr/9QVteUQnYBVw61uRvTk
         An3+dyQkhXBnsbvgQy4ShgF/VMMoGTdPVvdTYN29FhhHe45NtOpsfIb1qZlH/A0FgLfr
         D1AzElYGcX0ohaQ5BDfOyY5pvRm56317MQnxVn/70nCq+g5uRqT/m7omgwGrQAFUBTIP
         c+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769105279; x=1769710079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OjdUwnpsHtoIlxN53mjKwTtHv8VX23Qu//ARq0k4aO4=;
        b=L12DKuWq/GDpj7rqZsoBz6I2xVzO5Qm/6Ns71/WMNFc1DLSLH81lSaH1NfFBLMSiXJ
         tR6axXHm3+T70behxmm3BCdQES8QiNan99yZN+kDdlwHtEYUZspDKAjeQhG6C21oR70h
         6FuBO61NI1N2Tt3UjVjpMQ6ZZpD6fx864as5iA/gftqc6gEncQKjcsw04GZKui9aiR2s
         CcM76vcSCUf/Py0u7kJCnG98CgEnCnnLAcOGpESPAqq1ApRnzpVYTS6DO/1kIPtw31W6
         E+RXidk1U7qc1iNTPPhLEy1wlh6zkL+G0hLcNHgMxVcNoMKRx6eZH3FtHXF2HgU7LeBF
         OJDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUL6cvZyXRd5K4tP8vjw0pQucFuFINHvAj6+Pe9+Pg2jzyCMYuy+BFJuHSSKcMcU99drAF1rEqVA==@kvack.org
X-Gm-Message-State: AOJu0Yw4XiFcj1NtQMgH4T3iYG6SfsnOAiDTu4uHISGEc01xIdifMvud
	NWVt0UpoluY0A2nUgru3CjP8RtZlWeXpdj4Fo0XahwOVIPcYk+wvhShH+W18WoqB1xeLsfkobws
	qUAnQMdBxUeJ/+cenGoE3IAmo1trwPOgEv5GFRSoK
X-Gm-Gg: AZuq6aKfDDVG+l6ZXpRKduApCooCRR9wVHiqMzTAPd4BdrJNLLWcOy2WbiyZJDZRqXN
	2oBzCH5SlduH0NpbuFup0aHuqCFzD2k5oZkk5mk7t3KO1sQg5s8GU/2U/oMGu46MdAZLZuelTqO
	5Mdqe+yqyF3zGWIDcKqqBDS8YURUYQgmcircmxZ2H/IGJD3yKzeZOEVPVZ+GEI/gONR40YVKCoX
	ek5neMWUwyp7YYUeO4or7atXwLsCUS0sKm5x4k1dTmJWKzJUMDs7QimRa5V2oGcZnILbSk6R16Z
	m7xwIu/LSh5mt67oKBz54HfQ
X-Received: by 2002:ac8:7f11:0:b0:4ff:cb25:998b with SMTP id
 d75a77b69052e-502f808dfb6mr111741cf.12.1769105278126; Thu, 22 Jan 2026
 10:07:58 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769085814.git.lorenzo.stoakes@oracle.com> <c51d6396d78532d85a542da07ba783bc838b852f.1769085814.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <c51d6396d78532d85a542da07ba783bc838b852f.1769085814.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 10:07:47 -0800
X-Gm-Features: AZwV_QjulxiVd5nvn-p3ujVEBBr76cKQScvmhG9dtzEX3D3VZga5MHrIgn1oKxk
Message-ID: <CAJuCfpF-tVr==bCf-PXJFKPn99yRjfONeDnDtPvTkGUfyuvtcw@mail.gmail.com>
Subject: Re: [PATCH v3 3/8] mm/vma: rename is_vma_write_only(), separate out
 shared refcount put
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B04F81C0011
X-Stat-Signature: bmiw1gkyjrf56ecua5qn161upjobayge
X-HE-Tag: 1769105279-887789
X-HE-Meta: U2FsdGVkX18uQevwlXu2+7wgHynSMjUbGt/lSmohnv9a+8ni5Jk0mTpT9B+s6VnxG/GLWoS/2V7F5Z+SuKI7FT9OAZ3qP5GBZ7HWJhcnBIULrnxGYq5QVCWuIa5rz1mzmkbXM4+knffbH1QlMx5BjJQbKhlmYT1XV03QRflvxVR1xoMwF7Lq0f1PeONhBTA66NBZpbb7J8zlpMKiTgo4HGOlas7rT/+4W/ZrnYJTkh0BSDJimpDM7m2XbCTe8cKyjS0ZsO0X+LegvMBhKs1PFP9huPg8zTZUafi5T50um9JLYNFDmfIfvfrUQTre2moPizUR724cwP+JylxIg40fw3y+zQtyeuzmBpNeNliOrDnprxdLGp+W8RJvZhrHB5hK0/kQXwTxKIvoXRQhi42J0TMBXgTEa7x+4bDLaS6xDUFV/Mpgb60a+a1ZLHdwfkqXDYkUnEK6FUqzK7KYO0dJnolx8JwLHAl7j2W9YnKmROIgK1u9Z0uGtEvBf9CqqbFW7SiqrCR/cnwPEgQW2x8Xv8B4/T6wmnP17ojPqgP7ZMOrMu8sgMplRt22EkHsDvws8vYIfYVEwMyAwavlyPRbGPRMIut9wtwfoIoW7YerusPh1YUaef2mb8geSGBPSP+/gAnpzO2vvsVaXRS+WLlGeU04x+uegr0qKSPs8hLw0sn5ePOjGoyzeSZiBb0tBNjVhLcCvZUJVi6dtiYeGQa02fMEo5Ac8diQn8Iob4TcQV0Ls6vfY2Z0AHbfW21uAd9GbHiNPKuQ4jXVyyHkdR4J3VO2CSu7ru+3R21540tpAcgow/WWR3z3ZK8z1ezz1XO0RuF34zCFyygKoApumdp7nZ0qwkcLM2VEbVstpLzwm6t62bd/lyoF1d/E6etKY8p00piwHnnXjN4IUgWF4zRzt4sDnjicYPFc1HmXc9FYwMooGyRiA2p1LgLWOAcUcBqnaOwQj0LwetvFDmon7+s
 NWqX5s+q
 DdVTr1V2EE77HSEjE//ZrKYEaVCK2NMKtSR2KkylsPTEXsnVWb0dli0pPoPXa4j5qnoRwDeqD2pvbgLMlyAx050Tyl4ciIdX7u3aAii+vZNHbUtMsWWZ3vOBZFuoM+hZmUC0zdIJp8lfP+1m6Hd2QGR+qedtMmNjZWufVz1j1NolztI8G/w210BeIycqjQnwmvCgxJ614P5Egg+kyWvZe2jAuD9Y/tSF4d5rRF8HI+mhNfynNuatTCJw5f54loqmGkdG6Uqg+eDITKlW4jxtIBviK8Hi/vIUCbc2+bS6tk/6RQUZiDc9NTG0C//YXRpIsekFIuFDutG3UVzwunCMk+bgMZcp6V2ZaFvSSEDGG0l8rECSC/zqIeTrg7AE6aVh7oKb8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 4:50=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The is_vma_writer_only() function is misnamed - this isn't determining if
> there is only a write lock, as it checks for the presence of the
> VM_REFCNT_EXCLUDE_READERS_FLAG.
>
> Really, it is checking to see whether readers are excluded, with a
> possibility of a false positive in the case of a detachment (there we
> expect the vma->vm_refcnt to eventually be set to
> VM_REFCNT_EXCLUDE_READERS_FLAG, whereas for an attached VMA we expect it =
to
> eventually be set to VM_REFCNT_EXCLUDE_READERS_FLAG + 1).
>
> Rename the function accordingly.
>
> Relatedly, we use a finnicky __refcount_dec_and_test() primitive directly
> in vma_refcount_put(), using the old value to determine what the referenc=
e
> count ought to be after the operation is complete (ignoring racing
> reference count adjustments).

IIUC, __refcount_dec_and_test() can decrement the refcount by only 1
and the old value returned (oldcnt) will be the exact value that it
was before this decrement. Therefore oldcnt - 1 must reflect the
refcount value after the decrement. It's possible the refcount gets
manipulated after this operation but that does not make this operation
wrong. I don't quite understand why you think that's racy or finnicky.

>
> Wrap this into a __vma_refcount_put() function, which we can then utilise
> in vma_mark_detached() and thus keep the refcount primitive usage
> abstracted.
>
> Also adjust comments, removing duplicative comments covered elsewhere and
> adding more to aid understanding.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mmap_lock.h | 62 +++++++++++++++++++++++++++++++--------
>  mm/mmap_lock.c            | 18 +++++-------
>  2 files changed, 57 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index a764439d0276..0b3614aadbb4 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -122,15 +122,27 @@ static inline void vma_lock_init(struct vm_area_str=
uct *vma, bool reset_refcnt)
>         vma->vm_lock_seq =3D UINT_MAX;
>  }
>
> -static inline bool is_vma_writer_only(int refcnt)
> +/**
> + * are_readers_excluded() - Determine whether @refcnt describes a VMA wh=
ich has
> + * excluded all VMA read locks.
> + * @refcnt: The VMA reference count obtained from vm_area_struct->vm_ref=
cnt.
> + *
> + * We may be raced by other readers temporarily incrementing the referen=
ce
> + * count, though the race window is very small, this might cause spuriou=
s
> + * wakeups.
> + *
> + * In the case of a detached VMA, we may incorrectly indicate that reade=
rs are
> + * excluded when one remains, because in that scenario we target a refco=
unt of
> + * VM_REFCNT_EXCLUDE_READERS_FLAG, rather than the attached target of
> + * VM_REFCNT_EXCLUDE_READERS_FLAG + 1.
> + *
> + * However, the race window for that is very small so it is unlikely.
> + *
> + * Returns: true if readers are excluded, false otherwise.
> + */
> +static inline bool are_readers_excluded(int refcnt)
>  {
>         /*
> -        * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READ=
ERS_FLAG
> -        * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1=
) if it is
> -        * attached. Waiting on a detached vma happens only in
> -        * vma_mark_detached() and is a rare case, therefore most of the =
time
> -        * there will be no unnecessary wakeup.
> -        *
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> @@ -138,18 +150,42 @@ static inline bool is_vma_writer_only(int refcnt)
>                 refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
>  }
>
> +static inline bool __vma_refcount_put(struct vm_area_struct *vma, int *r=
efcnt)
> +{
> +       int oldcnt;
> +       bool detached;
> +
> +       detached =3D __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
> +       if (refcnt)
> +               *refcnt =3D oldcnt - 1;
> +       return detached;

IIUC there is always a connection between detached and *refcnt
resulting value. If detached=3D=3Dtrue then the resulting *refcnt has to
be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
new count:

static inline int __vma_refcount_put(struct vm_area_struct *vma)
{
       int oldcnt;

       __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
       return oldcnt - 1;
}

And later:

newcnt =3D __vma_refcount_put(&vma->vm_refcnt);
detached =3D newcnt =3D=3D 0;

> +}
> +
> +/**
> + * vma_refcount_put() - Drop reference count in VMA vm_refcnt field due =
to a
> + * read-lock being dropped.
> + * @vma: The VMA whose reference count we wish to decrement.
> + *
> + * If we were the last reader, wake up threads waiting to obtain an excl=
usive
> + * lock.
> + */
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
>  {
> -       /* Use a copy of vm_mm in case vma is freed after we drop vm_refc=
nt */
> +       /* Use a copy of vm_mm in case vma is freed after we drop vm_refc=
nt. */
>         struct mm_struct *mm =3D vma->vm_mm;
> -       int oldcnt;
> +       int refcnt;
> +       bool detached;
>
>         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -       if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
>
> -               if (is_vma_writer_only(oldcnt - 1))
> -                       rcuwait_wake_up(&mm->vma_writer_wait);
> -       }
> +       detached =3D __vma_refcount_put(vma, &refcnt);
> +       /*
> +        * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> +        * their reference count, so wake it up if we were the last reade=
r
> +        * blocking it from being acquired.
> +        */
> +       if (!detached && are_readers_excluded(refcnt))
> +               rcuwait_wake_up(&mm->vma_writer_wait);
>  }
>
>  /*
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 75dc098aea14..ebacb57e5f16 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -130,25 +130,23 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
>
>  void vma_mark_detached(struct vm_area_struct *vma)
>  {
> +       bool detached;
> +
>         vma_assert_write_locked(vma);
>         vma_assert_attached(vma);
>
>         /*
> -        * We are the only writer, so no need to use vma_refcount_put().
> -        * The condition below is unlikely because the vma has been alrea=
dy
> -        * write-locked and readers can increment vm_refcnt only temporar=
ily

I think the above part of the comment is still important and should be
kept intact.

> -        * before they check vm_lock_seq, realize the vma is locked and d=
rop
> -        * back the vm_refcnt. That is a narrow window for observing a ra=
ised
> -        * vm_refcnt.
> -        *
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> -       if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> +       detached =3D __vma_refcount_put(vma, NULL);
> +       if (unlikely(!detached)) {
>                 /* Wait until vma is detached with no readers. */
>                 if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
> -                       bool detached;
> -
> +                       /*
> +                        * Once this is complete, no readers can incremen=
t the
> +                        * reference count, and the VMA is marked detache=
d.
> +                        */
>                         __vma_exit_locked(vma, &detached);
>                         WARN_ON_ONCE(!detached);
>                 }
> --
> 2.52.0
>

