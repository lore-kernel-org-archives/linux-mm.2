Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5DD109B47B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06FFC6B0096; Tue, 31 Mar 2026 11:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047646B0098; Tue, 31 Mar 2026 11:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FDC6B0099; Tue, 31 Mar 2026 11:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D68776B0096
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:06:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 999521602BA
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:06:20 +0000 (UTC)
X-FDA: 84606684120.25.8D3ADCD
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6FBA8C001A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:06:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pEhDOuv+;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BPhLUWPeq7nYkrn0qmrS6IUP8HvQfT6M1S21IWIT2p4=;
	b=vHe35LhZFVPzJP+4yrQeHdBEgZxWR3kstpjej2sE+/elXU8kbKWokiR/DpNauTOsbK0A1i
	JLxbQynDB3+wf09nDYf/iDNAomL0WkQX+1NlkhYPN7jUCKuLKJ9YKP1fqtOPW2Qqd6/odZ
	p/PaWWSjSc97S6l6e7u+pX571EBvAeg=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pEhDOuv+;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774969578; a=rsa-sha256;
	cv=pass;
	b=ZdTd5BVbzzLM749w/OqqXvx9gTIgax1PA/CSGy6AmHzTlYUCNERQSLc2KwYyNfrVQKGXwX
	XXSBn6Xe7zNVTjFoVpf6glu6iGiRXRf8/Q5anlgK+2yKApXMmMCZ8CFVDc2f+MDeTn+lR1
	IRIEQm92VN2d6WHvZXE2Uq5YjK7v29s=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-509062d829dso563241cf.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:06:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774969577; cv=none;
        d=google.com; s=arc-20240605;
        b=jcF+t0qkCjgs6+p1geE/AFWy0aCoQrKmbLudKNdb4Iz+Purm2VyjpROtBNsqFU6rEs
         qzLO+eVvE+jnsFABi3gH+bK6ls8sEUXiQ4VFr1qPL+vPth6o5hBWb3+A27gPeKqwaF0Q
         2ApnDtl7wJp8/F8C0QH+9Yl7UXM9/6T4uSYpdiqFiucTMdZqD055v5V6nQOdZZUjc5Oz
         azA9o6+hGpGcQ4tyZu4qURSUlY9cOnhvvZ6Yethqum6l3e+pB5nOSp5Bq+aKExc9BIAi
         e4vQXdkWNXKoJzYMxGMR9ilMO2NILqy0k+C58GgrEwgYOXvHKU12DVMlJRe2PxM4ftH+
         7d7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BPhLUWPeq7nYkrn0qmrS6IUP8HvQfT6M1S21IWIT2p4=;
        fh=ttMzoUhU8HwpWcaOA611LIjE9cuYsNQdUTUi0lm7srE=;
        b=ECJntPcrxC9DFHMK5VbuQHu66gcCcLoMcHWNt/6LcqWFHs03ke37iOUcun4k0mE/Yq
         3pU3TV5T9cp4iQjsbNs1QPWWXgRaKt3pl+uA8T3NbX1zf69iwq2I1s1m3DDEAIXBgq7G
         Uxp+PIijimdXUSGkSqoUDbGmP5l17HFP+1p95lZGn8alQ0WLvGdvgr4WMQRCmyOy41+g
         OEREGkjZbJV1lCEJEygxOOPR+oIXXjwd+jQeQdPIqWrA6sFa0BqbatqHNFraRdLicrfC
         QD1hQrwDxUvAN1WAcBss6sIKjum1OLETt06EKUWe6ClsJ8HqLTWcHyrAVE5Mp8a2zqzy
         1ubA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774969577; x=1775574377; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BPhLUWPeq7nYkrn0qmrS6IUP8HvQfT6M1S21IWIT2p4=;
        b=pEhDOuv+HIe05EKg1Ao4a39CF9ZzhLsKLZsmMc0QUBq40o6cd6BJayDqGc1YpLC142
         efZVshZBzzJ4R9jzbruhDxvMlwdaAciW9lINb9XIHTNQTRUwrs4Yi2gtyK+UhbPc8sDL
         JaSONsxltuJYd+dqKfUUsOWddKvvsP3pAlPSFK0lJSY39h0QXnb/+s/upF/xwvcG+qdU
         zXTPiJ3dCnBo9GnA266MDAyCr/l+WxE1RBTkcmZrXdOv8HFrKfwbTd7cAG07oaI2KWVE
         NISjNVaQZAwYY5+pa4KHad+qduma/sW0dBj1ZRCHT0GWaMs6knyZ5+7gB5zorcHKaah8
         V2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774969577; x=1775574377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BPhLUWPeq7nYkrn0qmrS6IUP8HvQfT6M1S21IWIT2p4=;
        b=fd6MHaGxZODWqbq9hyGwDIGgC/ihf4ekLPi6Rp+BNwmFn70w1G3DxKPplYAO3MPT4g
         OnxGvCtUmaVf6Ik2L3Fod52W1KFCOLOWtE8w1ry3J9BXHcPejj1ei0H5T+cKzMxhzJcg
         jQUL1PdpgB9u0oVgcuhcHL1o8OiFq8n31peRjRTRm4ZBsVzTP4w0edyqgr8jI1fLUGUZ
         YZKS18WadiaM6BoEAAmigC258zO7pXKtmXYuj+71EQOVzSxczSzoC93mscDXIVWmTk1y
         ijyaHEHs9LCIApVziheczVYUwtTaU7sZiZscO67uIWzdkZyIhb1zfrIu+flHL2+cjopO
         RmCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFDfr4WqAwK863rs7oasgWvvnbyaBRstnKImFCk7ctFC/cdRrVMh420xsuwH5jO5XYllD/7ToiBw==@kvack.org
X-Gm-Message-State: AOJu0Yx01sPJ+pV4w7a/lLdoCZ5uGG2H459q1H4ikJFwcL697WY6wIYP
	UQUi4G7bt9/CjH1MCIovGtRQzw3tLJdYr6clKFVsL6yteExz+22RnKMTbY9n8Ba1VWj+dq3UfMv
	7L7y8/zDvw4ayGAGQN0wGCGlYM5QwIlfDTK+k1PjN
X-Gm-Gg: ATEYQzwOqypz//tHKaFMeBpXnJ9/UX/e0JCy/8mKxbIwH8/2XB3hKT5aMk8KpQGByTo
	1PMDYWoe07cbu+7su9noFqb6ZEHf2cdCknwE4oYcqQn+4JdPb6X3PvaNgESUT+3yJoIZvlY2lsF
	2FJ/jx6shwjI38njCSVidyYhfI+XSW4d4mm9fQ/KhGwVSwJmctf8/1KtXzx9rTSTZCzmv2dL3K5
	AGN3WVf6ptL+5rDZFRZLc7pSxx8OfJqsIuFddW2qgPNC8hcED5dSoBj/9mM/lH/jzT9yOdwkYje
	dfuvSBT521+T6sbJIueF2bZZ+puN8/K0qXvXOQ==
X-Received: by 2002:ac8:7f50:0:b0:509:cd7:aa18 with SMTP id
 d75a77b69052e-50d2d5df51cmr17993481cf.10.1774969575456; Tue, 31 Mar 2026
 08:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327161226.17e680fec33117d67dc8b5f9@linux-foundation.org>
 <f128b795-5577-40f9-8dae-936be4253642@lucifer.local>
In-Reply-To: <f128b795-5577-40f9-8dae-936be4253642@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 08:06:04 -0700
X-Gm-Features: AQROBzCkq9zWX_INOKKq7FRhsytABhuHOSOXWR8lJTFtOb6OteMYhMzewaRwAII
Message-ID: <CAJuCfpHmUop-UzxM9QN7OiAnXUzj461+9ErgtXrtve_bR0_NjA@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] Use killable vma write locking in most places
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, david@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, vbabka@suse.cz, jannh@google.com, rppt@kernel.org, 
	mhocko@suse.com, pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com, 
	npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org, 
	borntraeger@linux.ibm.com, frankja@linux.ibm.com, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6FBA8C001A
X-Stat-Signature: heu11p36bxqwmd7c8itxp4fg5rem6fd9
X-Rspam-User: 
X-HE-Tag: 1774969578-683669
X-HE-Meta: U2FsdGVkX18DZ8KSEkrmHCI4xBpODLN6IjuHEtmohg0kZLdJs/fddp0MjUPomc5i8DO+PBSxgQdyABpAGlgkvdhW3pgr1Ba1DI+jfqaB+qJ/2iV/xUtxQsDwACMQdBFPjZZHEVQzMa4Ht8PjMO/4phw9JZry+58q2OHumPJiWtQHNPiyRuKguUhj8H2QCRz2OyF6NO4E9wtf5Yqaos6zxeWRFuGvrzbHVbo/Ha7VQeHm2FFT8OfqRUWnb2Nk1irOdltaDv2pQbqV8ES0eJxNshn7MgSUkw/8VPUMMVJ/5qnvrm4d9OMtOQgyHOlVFaSGb83FmT4a4yc13J9HOLuvVpPDsTWyplGUi4qmLPJ1P8zRf0Z+1vVzawXUx5uzOa99Wcj4VXlbLyKdIFvCO4W4j4Z7vMwiJPu4h1YnzQjTE3GrkUKhAQzCHI5axTbMbHY4FoAzZEdjAJbNeMtehRcReMkUe6wwuRrKEy+J+XGXiORwpSWTYtzsSTkHBObtInZ6y1MsIU2oHcGeAHIIzf/q/uMyKQ6eDC7NJ3EkmfRH9crTM/KrwNoD65P8OK2lLdxCL4+yDBpOdWB/nBd8+hKiX3SP6K/K4OMXN8B3efGYwSAH2QLEx9kYbKCatZLalQnRH17t1nrvsC6rGb8F9dWPuHDgkets3Mu6+HCjALZimokmjabiNMKawEUvE2RI3/cO+piYv1Ya3h6H98FowM4aZM2oE/IKZXvFU2oPp/M1IwvzdM392POVxPUoVpqk3jVmzNeXindjbf/RDz+wWbRJDM1Xj/eM1Fq0gD2bLHz+JDtW2K8zdWIiCtIT7zMncBF0u4cGhxDQ8U14E4MqQqdmyccWDQh+qlzdmqYpV9Y3ut7V5TQzFbt0zv3OaJ2ZileB3hJIb75F8CM/M5RJqtoXzgYIQDon+0fauSxo1fKXupAaWhY4f1Cgjmu+ebmO9bwU95G6oajAThUq8AK0n0T
 Lv2jvcuJ
 3GpcjSgT5nN6TzzDahcpcmh0BGmPRhXyx12F/h1hvgr+OpaerMEgXsIQFZZrInTfn0Vqn/W28ru2rKpDl97r1QXvXbNkbLgo13AyY+2/WUyRZ8vLciPIAk8nOUk5JuWmEaS61xoQBPZOg6+ZIbTZvyiqRFz+dn8FeYiSozg68J+X7lDXMO6t/pWmn3mtDWGsFt8lxn2mM3B8WV6wOTHw8CrDqs1ZquAbyen7d2zc7VrXPoX0Ad+RVWCniDONavgplbgXRzlA2fsTkHIcBaYsM02yHSl9kiGOi2Cw5y9fYQwRicVWoOedf7AjvGurqVZOh2PKRKDiqSbOtZNCqIacCBAKzshv6NEDYZPrRsBK1zWSiTQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 2:51=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 27, 2026 at 04:12:26PM -0700, Andrew Morton wrote:
> > On Fri, 27 Mar 2026 13:54:51 -0700 Suren Baghdasaryan <surenb@google.co=
m> wrote:
> >
> > > Now that we have vma_start_write_killable() we can replace most of th=
e
> > > vma_start_write() calls with it, improving reaction time to the kill
> > > signal.
> > >
> > > There are several places which are left untouched by this patchset:
> > >
> > > 1. free_pgtables() because function should free page tables even if a
> > > fatal signal is pending.
> > >
> > > 2. userfaultd code, where some paths calling vma_start_write() can
> > > handle EINTR and some can't without a deeper code refactoring.
> > >
> > > 3. mpol_rebind_mm() which is used by cpusset controller for migration=
s
> > > and operates on a remote mm. Incomplete operations here would result
> > > in an inconsistent cgroup state.
> > >
> > > 4. vm_flags_{set|mod|clear} require refactoring that involves moving
> > > vma_start_write() out of these functions and replacing it with
> > > vma_assert_write_locked(), then callers of these functions should
> > > lock the vma themselves using vma_start_write_killable() whenever
> > > possible.
> >
> > Updated, thanks.
>
> Andrew - sorry I think we need to yank this and defer to next cycle,
> there's too many functional changes here.
>
> (There was not really any way for me to predict this would happen ahead o=
f
> time, unfortunately.)

Ok, no objections from me. I'll post v6 removing the part Lorenzo
objects to and you can pick it up whenever you deem appropriate.

>
> >
> > > Changes since v5 [1]:
> > > - Added Reviewed-by for unchanged patches, per Lorenzo Stoakes
> > >
> > > Patch#2:
> > > - Fixed locked_vm counter if mlock_vma_pages_range() fails in
> > > mlock_fixup(), per Sashiko
> > > - Avoid VMA re-locking in madvise_update_vma(), mprotect_fixup() and
> > > mseal_apply() when vma_modify_XXX creates a new VMA as it will alread=
y be
> > > locked. This prevents the possibility of incomplete operation if sign=
al
> > > happens after a successful vma_modify_XXX modified the vma tree,
> > > per Sashiko
>
> Prevents the possibility of an incomplete operation? But
> vma_write_lock_killable() checks to see if you're _already_ write locked
> and would make the operation a no-op? So how is this even a delta?
>
> It's a brave new world, arguing with sashiko via a submitter... :)

Yeah, this is not really a problem but I thought I would change it up
to make it apparent that the extra vma_write_lock_killable() is not
even called.

>
> > > - Removed obsolete comment in madvise_update_vma() and mprotect_fixup=
()
> > >
> > > Patch#4:
> > > - Added clarifying comment for vma_start_write_killable() when lockin=
g a
> > > detached VMA
> > > - Override VMA_MERGE_NOMERGE in vma_expand() to prevent callers from
> > > falling back to a new VMA allocation, per Sashiko
> > > - Added a note in the changelog about temporary workaround of using
> > > ENOMEM to propagate the error in vma_merge_existing_range() and
> > > vma_expand()
> > >
> > > Patch#5:
> > > - Added fatal_signal_pending() check in do_mbind() to detect
> > > queue_pages_range() failures due to a pendig fatal signal, per Sashik=
o
> >
> > Changes since v5:
> >
> >
> >  mm/madvise.c   |   15 ++++++++++-----
> >  mm/mempolicy.c |    9 ++++++++-
> >  mm/mlock.c     |    2 ++
> >  mm/mprotect.c  |   26 ++++++++++++++++----------
> >  mm/mseal.c     |   27 +++++++++++++++++++--------
> >  mm/vma.c       |   20 ++++++++++++++++++--
> >  6 files changed, 73 insertions(+), 26 deletions(-)
> >
> > --- a/mm/madvise.c~b
> > +++ a/mm/madvise.c
> > @@ -172,11 +172,16 @@ static int madvise_update_vma(vm_flags_t
> >       if (IS_ERR(vma))
> >               return PTR_ERR(vma);
> >
> > -     madv_behavior->vma =3D vma;
> > -
> > -     /* vm_flags is protected by the mmap_lock held in write mode. */
> > -     if (vma_start_write_killable(vma))
> > -             return -EINTR;
> > +     /*
> > +      * If a new vma was created during vma_modify_XXX, the resulting
> > +      * vma is already locked. Skip re-locking new vma in this case.
> > +      */
> > +     if (vma =3D=3D madv_behavior->vma) {
> > +             if (vma_start_write_killable(vma))
> > +                     return -EINTR;
> > +     } else {
> > +             madv_behavior->vma =3D vma;
> > +     }
> >
> >       vma->flags =3D new_vma_flags;
> >       if (set_new_anon_name)
> > --- a/mm/mempolicy.c~b
> > +++ a/mm/mempolicy.c
> > @@ -1546,7 +1546,14 @@ static long do_mbind(unsigned long start
> >                       flags | MPOL_MF_INVERT | MPOL_MF_WRLOCK, &pagelis=
t);
> >
> >       if (nr_failed < 0) {
> > -             err =3D nr_failed;
> > +             /*
> > +              * queue_pages_range() might override the original error =
with -EFAULT.
> > +              * Confirm that fatal signals are still treated correctly=
.
> > +              */
> > +             if (fatal_signal_pending(current))
> > +                     err =3D -EINTR;
> > +             else
> > +                     err =3D nr_failed;
> >               nr_failed =3D 0;
> >       } else {
> >               vma_iter_init(&vmi, mm, start);
> > --- a/mm/mlock.c~b
> > +++ a/mm/mlock.c
> > @@ -518,6 +518,8 @@ static int mlock_fixup(struct vma_iterat
> >               vma->flags =3D new_vma_flags;
> >       } else {
> >               ret =3D mlock_vma_pages_range(vma, start, end, &new_vma_f=
lags);
> > +             if (ret)
> > +                     mm->locked_vm -=3D nr_pages;
> >       }
> >  out:
> >       *prev =3D vma;
> > --- a/mm/mprotect.c~b
> > +++ a/mm/mprotect.c
> > @@ -716,6 +716,7 @@ mprotect_fixup(struct vma_iterator *vmi,
> >       const vma_flags_t old_vma_flags =3D READ_ONCE(vma->flags);
> >       vma_flags_t new_vma_flags =3D legacy_to_vma_flags(newflags);
> >       long nrpages =3D (end - start) >> PAGE_SHIFT;
> > +     struct vm_area_struct *new_vma;
> >       unsigned int mm_cp_flags =3D 0;
> >       unsigned long charged =3D 0;
> >       int error;
> > @@ -772,21 +773,26 @@ mprotect_fixup(struct vma_iterator *vmi,
> >               vma_flags_clear(&new_vma_flags, VMA_ACCOUNT_BIT);
> >       }
> >
> > -     vma =3D vma_modify_flags(vmi, *pprev, vma, start, end, &new_vma_f=
lags);
> > -     if (IS_ERR(vma)) {
> > -             error =3D PTR_ERR(vma);
> > +     new_vma =3D vma_modify_flags(vmi, *pprev, vma, start, end,
> > +                                &new_vma_flags);
> > +     if (IS_ERR(new_vma)) {
> > +             error =3D PTR_ERR(new_vma);
> >               goto fail;
> >       }
> >
> > -     *pprev =3D vma;
> > -
> >       /*
> > -      * vm_flags and vm_page_prot are protected by the mmap_lock
> > -      * held in write mode.
> > +      * If a new vma was created during vma_modify_flags, the resultin=
g
> > +      * vma is already locked. Skip re-locking new vma in this case.
> >        */
> > -     error =3D vma_start_write_killable(vma);
> > -     if (error)
> > -             goto fail;
> > +     if (new_vma =3D=3D vma) {
> > +             error =3D vma_start_write_killable(vma);
> > +             if (error)
> > +                     goto fail;
> > +     } else {
> > +             vma =3D new_vma;
> > +     }
> > +
> > +     *pprev =3D vma;
> >
> >       vma_flags_reset_once(vma, &new_vma_flags);
> >       if (vma_wants_manual_pte_write_upgrade(vma))
> > --- a/mm/mseal.c~b
> > +++ a/mm/mseal.c
> > @@ -70,17 +70,28 @@ static int mseal_apply(struct mm_struct
> >
> >               if (!vma_test(vma, VMA_SEALED_BIT)) {
> >                       vma_flags_t vma_flags =3D vma->flags;
> > -                     int err;
> > +                     struct vm_area_struct *new_vma;
> >
> >                       vma_flags_set(&vma_flags, VMA_SEALED_BIT);
> >
> > -                     vma =3D vma_modify_flags(&vmi, prev, vma, curr_st=
art,
> > -                                            curr_end, &vma_flags);
> > -                     if (IS_ERR(vma))
> > -                             return PTR_ERR(vma);
> > -                     err =3D vma_start_write_killable(vma);
> > -                     if (err)
> > -                             return err;
> > +                     new_vma =3D vma_modify_flags(&vmi, prev, vma, cur=
r_start,
> > +                                                curr_end, &vma_flags);
> > +                     if (IS_ERR(new_vma))
> > +                             return PTR_ERR(new_vma);
> > +
> > +                     /*
> > +                      * If a new vma was created during vma_modify_fla=
gs,
> > +                      * the resulting vma is already locked.
> > +                      * Skip re-locking new vma in this case.
> > +                      */
> > +                     if (new_vma =3D=3D vma) {
> > +                             int err =3D vma_start_write_killable(vma)=
;
> > +                             if (err)
> > +                                     return err;
> > +                     } else {
> > +                             vma =3D new_vma;
> > +                     }
> > +
> >                       vma_set_flags(vma, VMA_SEALED_BIT);
> >               }
> >
> > --- a/mm/vma.c~b
> > +++ a/mm/vma.c
> > @@ -531,6 +531,10 @@ __split_vma(struct vma_iterator *vmi, st
> >       err =3D vma_start_write_killable(vma);
> >       if (err)
> >               goto out_free_vma;
> > +     /*
> > +      * Locking a new detached VMA will always succeed but it's just a
> > +      * detail of the current implementation, so handle it all the sam=
e.
> > +      */
> >       err =3D vma_start_write_killable(new);
> >       if (err)
> >               goto out_free_vma;
> > @@ -1197,8 +1201,14 @@ int vma_expand(struct vma_merge_struct *
> >
> >       mmap_assert_write_locked(vmg->mm);
> >       err =3D vma_start_write_killable(target);
> > -     if (err)
> > +     if (err) {
> > +             /*
> > +              * Override VMA_MERGE_NOMERGE to prevent callers from
> > +              * falling back to a new VMA allocation.
> > +              */
> > +             vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> >               return err;
> > +     }
> >
> >       target_sticky =3D vma_flags_and_mask(&target->flags, VMA_STICKY_F=
LAGS);
> >
> > @@ -1231,8 +1241,14 @@ int vma_expand(struct vma_merge_struct *
> >                * is pending.
> >                */
> >               err =3D vma_start_write_killable(next);
> > -             if (err)
> > +             if (err) {
> > +                     /*
> > +                      * Override VMA_MERGE_NOMERGE to prevent callers =
from
> > +                      * falling back to a new VMA allocation.
> > +                      */
> > +                     vmg->state =3D VMA_MERGE_ERROR_NOMEM;
> >                       return err;
> > +             }
> >               err =3D dup_anon_vma(target, next, &anon_dup);
> >               if (err)
> >                       return err;
> > _
> >

