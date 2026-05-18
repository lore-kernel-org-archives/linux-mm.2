Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B39CD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 21:21:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650656B0005; Mon, 18 May 2026 17:21:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601676B0088; Mon, 18 May 2026 17:21:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8B76B008C; Mon, 18 May 2026 17:21:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35E996B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 17:21:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB0FAA0970
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:21:30 +0000 (UTC)
X-FDA: 84781811940.27.0396B02
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id D7DDA4000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:21:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gqoO73Ba;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779139289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsFks/IQaK5zPrUgVquMlDUWIMq4vDiBKG2waN9CznQ=;
	b=ajgRDMa68kkJcMCrdZUQU9aJpg/Xk2958YSPdIYjow7X20TxJE7JWb6suguEWJCdDqIA4B
	+PFlr0peH8SykRZX9VDU0511pqbizHPZPTuK+0hpkmZhZb8RO95vwwBFk1IMpSav1tCmAX
	PotbKOHTqkD7YMPmtna0B9UAre7u1+c=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gqoO73Ba;
	spf=pass (imf07.hostedemail.com: domain of shy828301@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=shy828301@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779139289; a=rsa-sha256;
	cv=pass;
	b=sDhMRBH4fb975imxio8UpRhCDInPI4O5mRF0/lne3jYthOKRyac0poJTxUq8sv/ZkM7RPm
	fwlplXtwmRPqbwKfnzXEggTsbrP+mqyBo/fKWfa2BjIz+kGgAXfF/Qgr+JFOJZPXtjIPFW
	asnqkh+N4rlg31/DdjPOZ5oyfAnpbmc=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-67c1e0229acso4636983a12.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 14:21:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779139287; cv=none;
        d=google.com; s=arc-20240605;
        b=Fx0LQVrzw+bQQByFgJ4iFgnL7PSP+7lIYuduXOkrUiOICZoLZR6jL2AGSw7NbV6DTi
         n3H+DwNURMEf0qzIwLEGoFAAvsbCMtruuZ0NGG2aopOpSPF+nYBIHPpmkrAH20CRDXYz
         +XBt2gj0WuC5Ul4zjhv2JVPWnX+V7YsOv+k4T02Z9uUsVe+kVXjSP4dhuFXl3+1Um1J6
         htqsxnq+j9nZCcrO1rF5mXZ8cFqo0Xvfv9BxxLm6oygyYtquuWNBtQUZDndrCTBsCCkC
         b/CnV0Sa7vvep+g7eHUR8WMBZ2ZgwflIW4TsR+4LkeboXVqsPYfLq1JuKdG0m8zyYYj5
         p9Mw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EsFks/IQaK5zPrUgVquMlDUWIMq4vDiBKG2waN9CznQ=;
        fh=a0rWIdfS1aOlL9rEQ9TpqoMAImnMiQg9YdjH4CtTnoc=;
        b=F3khzIbmfMWfkIT/jis7oJwlgGEnl+9EMKaW6la7H6n0WeD6DkyWkv7NoEF1qva7dC
         InQUnWGA0g0J4/nNR9O//YVrhq3SruE6O4VvbY8t6PSUDUFMmkw6DSRGg3G53Vn4EwrY
         JzEcT6LUzBuqlZQRaAE9Ktx+hOQ5yeCFsVC3F5+58yoCkrQg4oRmCIWVBatG7KtgjyYt
         9OFH2qD+2ORg6X7uoO6HHy1Gkaw1tBzS9J1Ttr/RkpdMEZ7QIm+bdKfWGt2hu5Mf9UC/
         slrAgG/Ah8UvGJrsAwbyzkSqlc3x88Cmzraxz9AjA7onDAxzMflGOVqgW4gfU58AVADQ
         2vsw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779139287; x=1779744087; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EsFks/IQaK5zPrUgVquMlDUWIMq4vDiBKG2waN9CznQ=;
        b=gqoO73Ba3UkcKQDQrcszo6DsxQy6UGC+Dw9fQUu+XULpa3zbtXDu5HY3MSvF2JXAMY
         d1XcrXb1eGwSr9VXNuk04ZoE/a6kfd8Fpk/q4DMVa28qH37l9LAtMOTeqUPiC3TaWS1E
         kugX6AvIIJ7jiNSr9JZXzRSpzkE78MulnL3DTmZE5agsveQW4JZU6zN3dtXWw7/9TRtq
         dE8WzqNQQiztpRRDUM2rNY9OgnBmk76iG1jk0QGrkZ5af/zMNVmF+Z4UFB9e5zU2Pf2D
         xE1FuF1o96XaR6HvjiemGtBfgQm+Mb/vG25kSYI2PJtaMD7QJMC5YswT9qYB/1215mV/
         6Hrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779139287; x=1779744087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EsFks/IQaK5zPrUgVquMlDUWIMq4vDiBKG2waN9CznQ=;
        b=kum/kiMCIaPV1yOXRqr7P8ShIGMjRzXHb8e5i/CgXzfcklNfGlukubPmKoJaYepWA8
         eQzelVtfQbMlAi6BBDLooVUMkjVirCqe+9SkZAUuCa5lT5vozlyvJn24X3g5uLzwJa4Q
         u0GYCw9PuF9Vuhd5z1nPDdx6c3K3k7qbwZCy1Az5i2FHdZB+73/k2t16mrLog0wnlac0
         8FmzQW3dxoa3B/RwcdIQCff88AkCq65KIXFkCprnnjZ99tGTgNSqGDiUL3M8iSzAIRKp
         4XZzwnUS0JnVyZ6G5o52rGwoQNJqpxTwYSNm7KITiNNfqlSIQk+QopVlHXtUtRnvMwz0
         IXiQ==
X-Forwarded-Encrypted: i=1; AFNElJ8SqBSOT1N/3fV9Ybs9C7NKdVDw54/AIXNbUH5aTWvJ/3UJFh2Qa5vzyzkm6cBzNM0xoqGKug6vyw==@kvack.org
X-Gm-Message-State: AOJu0Yy5RjkhSHYI+qrXSB8QdGC3Ae8Mk70dP80RTWNPDf81xTzC8RoF
	RM/YPAEdSwoghp/sxCikp5qan0pgcHTS/iKiLiGI8QeNWVPSi14m99pw3VbR9aNwgFB8cazysDx
	tHAk2rYsSyvFN58yGCN8KdYyv0behjlE=
X-Gm-Gg: Acq92OH/HWaTv+7TyzJaFmbvk+N+ylLnwvbAbY8lRtIYkOVA9h+61px1j8Pa11S8cWM
	TnawwejbAKDp+CGy8N0TDg91XUg/pHSD2/1tvuWA/YkFvpQGxU2eOAVhS0/R8Q8z3hCfZxoI50s
	XztGmKStGq2pIUhCGplswVDECBTE3Rn1qzhWi7NAkDcA7jE95BGImkjWqf8wZK2ZQTsdo1EkUBW
	c6Q30AmmjhsXwfXrKCIth++w7WXclzAq2nEnFjwk85As4JvE078YpvW+weHw9T3bJdHwZl/JBR7
	NTkdTKs=
X-Received: by 2002:aa7:d315:0:b0:683:6705:6e09 with SMTP id
 4fb4d7f45d1cf-683bd38d823mr5757913a12.13.1779139286945; Mon, 18 May 2026
 14:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260430040427.4672-1-baohua@kernel.org> <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org> <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org> <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
From: Yang Shi <shy828301@gmail.com>
Date: Mon, 18 May 2026 14:21:14 -0700
X-Gm-Features: AVHnY4JdohddXKx4c8RBQ6M1uUtTSitdJHlU74cl49fvebK4jjJ2w6iuf3X83y8
Message-ID: <CAHbLzkrOSoh-jmR=uaNvx73n_wn+vExoKY0UzH5zGcfdAiDbNg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, surenb@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com, jack@suse.cz, 
	pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn, 
	lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, 
	nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	Nanzhe Zhao <nzzhao@126.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D7DDA4000A
X-Rspamd-Server: rspam06
X-Stat-Signature: g93i5nkjghdjnqiyghj5xea9knbf5yt9
X-HE-Tag: 1779139288-775378
X-HE-Meta: U2FsdGVkX1/uTj7iE+m1y5ZpIQnzouuKp9AgmlYUwe9lGMMmMHYtz8cYOoKB3/C3y7UxcgoQlH/5MglA2DLLYr78Hz1KU5IDwRWK0qfxLLDFVU5r7k5TMc4w4KeQ6lv2nwodfUhrqcra+SEjbNPj9JbBlYM8OfDk/TEOcA3Q+DDGJjfmpzjJD6UpzEJtJyeCtBdLfJoq8Qt+VIprSPB1KRC3o6sryD6mJ4w/MnehiqB69I9tWn0vlPN/6cLF/OBthXE66VgrXc5JFHgkVYLD0UAqMV6VMprrqiSFtxkkbL8iFnsOmNE8qAMX8CggPiY0Q5OvOG6unUgF/bZgoIMHxowSuZwPAOh40lzRTy0jjo34cPCyPeg8UW8iJCAnisLTmU0fq7NFV+uqQ1vbzkgfLor/x+bWuyiU1HT0dPB45+LSt84v/J5XxYxBD9T5uj9s6ADLdRvKIcDPoIubn47CSyr6SWzlXawAjH2oDEvVezfr+cLfnlfUsrtWcbAFXVq4LH6s1ypNDZPumAhwy+LwNrL/z0LrJooqItg2Hp+CgQbNfg9AVZsjzT8ctpTaWgFPdCKDsn3dg0/fJwsARLKF2ghWL01zVb4dHkwJ2cRdPSthLtMuS7Bw7V55s7mw3J1KX4U84ZzW1pTtP2PVp6KI3rIXQyssgtymA2tS6vxNW4k8ldfl8/W6LBf0H13m6atpFY1Pjc23J1B8eq/VfxNiuoWGBiRHXXu0Ofhp1TYLpVoI/moB0n5hP1CYI3aaj3Gt0rT36vVXEf/TwOLcjuZ+8wi/eSNbacFPpFTB6xkNXld463s5JwApaGa1r1IyG2WwtWi6vSRBaj7oiMwEfNRH4Vfru/no++GMhfXUeTvIMwJk3PhsdOzqpXPMOc2bbUi3sDm8jf/YzFQeExXA4wBlE2+5gezjDUeFSyDDbr4+d9QUB7m3mQopl8rYmpqu/nf6PAUjTy5vBzUjZylMEZG
 07QlNX2W
 14nf9gK8kQMrn0eB/7cE+k9Gy/1NAzyZy7Eb7r09YwaspwFbjXYmqS2uvzOdw9NU9p03pSrtKl1dgkSKNLp1ODGv+j/l5LFv41s+i1BLos7IEhIvxVbZZ8EbKX08bhLy7pV90SEgKOhteMSoxYV6ILPGs+b8OS0EfliiXdBlziqAiEB730QtjPGLrYESW1MT53p9E21zCNwellEvOW3ZC7b2oiBMj1Oau/bekbLlKRF+rA+oQVjeAsbSK/8M1KGz6qF4+Odr0J1VwB2Yktm+MBzuUvhVJOUld9zHcVA9nt2PHYOvmE9vZD1RE2HyS6AudU4nUrfwHBP3na0Xv4CAOFM6q5PtWKi4yo+RL+SQxtHrKyPwYQt6AV8IhjXPks13pZsnulZJJTlxVXDgGjMcqyjlV4CzZulRV5wsigAO502hEy75+SqS13oZITeQfsNCzLbZTWwKg+rniyXCOFx7STf3+GsJlUKWUltzNTu9nTm4JOUx5bm0egT78d82pLD0Ikg1orE2QzAbDnKebHn/EUl7V/wFf1YqrXLhqUix3rT/HDFzz72HBZ+AOde+ek5PAouLLE2+Y+9RXI+Yf6ZFHVYHzuvWxhzBR2ZJM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 17, 2026 at 1:45=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Sat, May 2, 2026 at 1:58=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
> >
> > On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
> > > On Fri, May 1, 2026 at 10:57=E2=80=AFPM Matthew Wilcox <willy@infrade=
ad.org> wrote:
> > > >
> > > > On Fri, May 01, 2026 at 06:49:58AM +0800, Barry Song wrote:
> > > > > 1. There is no deterministic latency for I/O completion. It depen=
ds on
> > > > > both the hardware and the software stack (bio/request queues and =
the
> > > > > block scheduler). Sometimes the latency is short; at other times =
it can
> > > > > be quite long. In such cases, a high-priority thread performing o=
perations
> > > > > such as mprotect, unmap, prctl_set_vma, or madvise may be forced =
to wait
> > > > > for an unpredictable amount of time.
> > > >
> > > > But does that actually happen?  I find it hard to believe that thre=
ad A
> > > > unmaps a VMA while thread B is in the middle of taking a page fault=
 in
> > > > that same VMA.  mprotect() and madvise() are more likely to happen,=
 but
> > > > it still seems really unlikely to me.
> > >
> > > It doesn=E2=80=99t have to involve unmapping or applying mprotect to
> > > the entire VMA=E2=80=94just a portion of it is sufficient.
> >
> > Yes, but that still fails to answer "does this actually happen".  How m=
uch
> > performance is all this complexity in the page fault handler buying us?
> > If you don't answer this question, I'm just going to go in and rip it
> > all out.
> >
>
> Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> waiting for answers),
>
> As promised during LSF/MM/BPF, we conducted thorough
> testing on Android phones to determine whether performing
> I/O in `filemap_fault()` can block `vma_start_write()`.
> I wanted to give a quick update on this question.
>
> Nanzhe at Xiaomi created tracing scripts and ran various
> applications on Android devices with I/O performed under
> the VMA lock in `filemap_fault()`. We found that:
>
> 1. There are very few cases where unmap() is blocked by
>    page faults. I assume this is due to buggy user code
>    or poor synchronization between reads and unmap().
> So I assume it is not a problem.
>
> 2. We observed many cases where `vma_start_write()`
>    is blocked by page-fault I/O in some applications.
>    The blocking occurs in the `dup_mmap()` path during
>    fork().
>
> With Suren's commit fb49c455323ff ("fork: lock VMAs of
> the parent process when forking"), we now always hold
> `vma_write_lock()` for each VMA. Note that the
> `mmap_lock` write lock is also held, which could lead to
> chained waiting if page-fault I/O is performed without
> releasing the VMA lock.
>
> My gut feeling is that Suren's commit may be overshooting,
> so my rough idea is that we might want to do something like
> the following (we haven't tested it yet and it might be
> wrong):
>
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2311ae7c2ff4..5ddaf297f31a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> *mm, struct mm_struct *oldmm)
>         for_each_vma(vmi, mpnt) {
>                 struct file *file;
>
> -               retval =3D vma_start_write_killable(mpnt);
> +               /*
> +                * For anonymous or writable private VMAs, prevent
> +                * concurrent CoW faults.
> +                */
> +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
> +                                       (mpnt->vm_flags & VM_WRITE)))
> +                       retval =3D vma_start_write_killable(mpnt);
>                 if (retval < 0)
>                         goto loop_out;
>                 if (mpnt->vm_flags & VM_DONTCOPY) {

Maybe a little bit off topic. This is an interesting idea. It seems
possible we don't have to take vma write lock unconditionally. IIUC
the write lock is mainly used to serialize against page fault and
madvise, right? I got a crazy idea off the top of my head. We may be
able to just take vma write lock iff vma->anon_vma is not NULL.

First of all, write mmap_lock is held, so the vma can't go or be
changed under us.

Secondly, if vma->anon_vma is NULL, it basically means either no page
fault happened or no cow happened, so there is no page table to copy,
this is also what copy_page_range() does currently. So we can shrink
the critical section to:

if (vma->anon_vma) {
    vma_start_write_killable(src_vma);
    anon_vma_fork(dst_vma, src_vma);
    copy_page_range(dst_vma, src_vma);
}

But page fault can happen before write mmap_lock is taken, when we
check vma->anon_vma, it is possible it has not been set up yet. But it
seems to be equivalent to page fault after fork and won't break the
semantic.

Anyway, just a crazy idea, I may miss some corner cases.

Thanks,
Yang

}

>
> Based on the above, we may want to re-check whether fork()
> can be blocked by page faults. At the same time, if Suren,
> you, or anyone else has any comments, please feel free to
> share them.
>
> Best Regards
> Barry
>

