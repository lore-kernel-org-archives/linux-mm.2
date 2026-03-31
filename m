Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA477109B494
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11D5B6B008C; Tue, 31 Mar 2026 11:43:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CEE36B0095; Tue, 31 Mar 2026 11:43:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8006B0096; Tue, 31 Mar 2026 11:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D875D6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:43:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 696AAB7C20
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:43:39 +0000 (UTC)
X-FDA: 84606778158.15.4C2F6D1
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4D2B1A0005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:43:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WLhu1f9x;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774971817; a=rsa-sha256;
	cv=pass;
	b=ZPLLMUcNqIFyduUWvqnQ9DfforDF1gU5OR40XK54iVfoBxmv29pq29fljE97v9V1VvHN6Q
	ne1MA+QBbosbKnQ+go6e9rWA2DTfnZSfAQsKiRtchqAaaOxCeJ+DLeyqT+6CKu4ynCRoqK
	oKYr+51aVzZ1PWF/McyW5WhtfHDnXFY=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=WLhu1f9x;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf15.hostedemail.com: domain of surenb@google.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774971817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=19HitNbsfLUnWLRSqhfCO2KvXn4aeuKUlwucY4LX+VA=;
	b=Na+DyTn5ov6yBz+mbIfeuoFZ7jToF1x/lMMadWOeX9PQnBc+yO1139lC9H5ASa1YlwsEgM
	qv3vyVl2INiuBYtmHhvQ+sRSkNHkPy6X4BbhUQcbIC7suQID+yJPE/ZvKCKiHxMY25eCoO
	aOO3vI/zNItz+vwU3LN6KAu2Q7YfTU8=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66b0dc690bcso11675a12.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:43:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774971816; cv=none;
        d=google.com; s=arc-20240605;
        b=SaJNkhUgSD1RHkjLtWyr1y1vDtr9ui6r9Jg7zT6iPnFmoQRzJQkYaodpaGdh4CreWU
         R8CaDULuvrDR5o3WCD9qrdit3DLdFFKMhlNWqQ36LPF0fSSquVvFdHjX9EibRSuB1LSh
         HfjzKj0Vo/FJ8klHAXPy82yw4KEFywXj3Re09TX8xPVbE3oid9KUy4puOO+6btGXmex5
         jN/1EdzQjrqb6bH5exo9YlCKgjJcYcA2RrIRdBrLlOdD5VlsqePkPyeugEwz/dMHu35h
         yJGfQuLXesWtgeZmAQTfze3pV8/4hwPEHxdOkL9K1Pd4yP8ASgOgbsYWIyWFEuSwZEFH
         /QlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=19HitNbsfLUnWLRSqhfCO2KvXn4aeuKUlwucY4LX+VA=;
        fh=mpURBCHq5LqX+NJ5dF1xjzBprIwvRXrQbC8s4bNe11Q=;
        b=er/SSdmQzMcg0x7JUGO0Zj2RRdT3Y69M0OI3qma0DvKg/A0eLHSxFz2ia1CpjjtbXR
         XGCSEjhfq/rbxIG+sOOr6PZ2GdJsfgrNfXZrw03gzgg6yr2KJPkhzpePfm99Map1+1I0
         qPnPWfddJbO3GAALbaQtNdwXYoa8KrOwn1SBVtzn7LJ/k7QKxs6AH50KPEQFcrR9sNdg
         d3mvL//tvqWoe3VXFOPQLNMBng3hO7DaSMdRU+nyMJWtKNAMjpuJiYqvpHDxECV5ZTO2
         kTrgNkHrXmjE0p5HAvZ8BKvTPIFx/azc9EpvKgyWYYKIrU8or2wmm9Rp8EHL5E6ZjAtd
         iR5w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774971816; x=1775576616; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19HitNbsfLUnWLRSqhfCO2KvXn4aeuKUlwucY4LX+VA=;
        b=WLhu1f9xUML7H0dXJtrrY1ptRdGKoyW1fjdACVjr+xXa3I4ZXTvvC3it9I2JhFdMj4
         sfMPxyHll5DWLwTflCVtKm5FLLQdjAIJniKUuNXuFXomjUPTZWqJmBguu0hm8OsEV624
         UXuBqjP7KUbrbGctWi+rOuNYS5ykOltP+NopqRywxns0bM5o1A0HzIXP33Kvquc0iPbB
         hLmzDi7gubVMvXMBR+WQSLFy0JR9U79dGD5e+okRzeZ697TyUldXOcZvmheDuZYvqXxu
         HwQl/JEpHoGFQeBehtpwgafe62+siktHxPDfMRKGKJ9Q1MqcR9kU9EFR0m0e8bj5a222
         H4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774971816; x=1775576616;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=19HitNbsfLUnWLRSqhfCO2KvXn4aeuKUlwucY4LX+VA=;
        b=eGzo9DG0DMGjnIXVThFSDsNMP+TIl3jVFNjIRydrz4UraGrYNeBS7S2HM4ydGQKIui
         gpDYnYODVdOLmEQAEfJD7HX9+AamgLndP7LPffTkkz5xk7ikn6K8pIG4BnWJjJiRXwwH
         wXYfrB+RuTxMWp+tUucWL3iAJWzshUer9Gn8Ib08hqega+ra/edQ8fEqwY0rseP2RKJ+
         wE3Md8gCKoPNmg5UZtawUEu4fbx2I9PaO3v2S/FqKBhcDcOqLDOkBi/RG7+PN3bbOM5V
         QbjrytYeRX+4vq+cDPpv7hdvPk7bTBo/266JegXT6PPgfGjE52+zp69A22nVM1jxjZG1
         4gtw==
X-Forwarded-Encrypted: i=1; AJvYcCWMqJYxEv9yrHMK1YeZIXEv7PjGx3j+sfz3xs0lcyZyMozEL8NJZRphqXr/9RGKiHt4RnPFowScJw==@kvack.org
X-Gm-Message-State: AOJu0Yw8MQTToYFORjPv1Ce5ycWerg33P0uHkS/ITkFN/A+482qBkWQh
	1sjA6mVRLGkTdJdjyZ8bXlIcEOJzvDB16K5zN69KZ1yh0NohfDJlnkD15s6Bwu4FFVR71llsxtp
	Iy8TBiMqNBKGcTkUnEPEKHCvQ6UN/+c2CyRrDUwup
X-Gm-Gg: ATEYQzxHC3ryFjLoMiyJVDeJyr423cO91MFwspulSWMOR2nRF7y4dzm7ZOS18Xo7pR+
	THhP3bl+NmIlMAAVzD3zSjulZ7aT0T6+MwU6oy/lsQLUla6I6j0JrEpk0U/G6Rn9SRC5XzgE1Rn
	m69IwYtbnPHUudei4XJ3CJL98E20oxzuMLwqjlDRxvGgRdTfQHrRcj1cvxaBl3Ozy0HkHR3X0Sk
	Ng1KfMNoUkc/wsaO3DCSEnJKG6jNyaf2K0MedtGFDbCnnyeN9ZQLxvanTUKVHrX8oUX6remvgz2
	nU2Ru4luKrBgOiqU6BYyrWys1VRSlP+fL10wGg==
X-Received: by 2002:aa7:d889:0:b0:65a:1240:b8c4 with SMTP id
 4fb4d7f45d1cf-66d95ac7d37mr3182a12.3.1774971815079; Tue, 31 Mar 2026 08:43:35
 -0700 (PDT)
MIME-Version: 1.0
References: <20260327205457.604224-1-surenb@google.com> <20260327205457.604224-6-surenb@google.com>
 <4e1c47a9-77a2-4f29-8de5-37f9958f5885@lucifer.local>
In-Reply-To: <4e1c47a9-77a2-4f29-8de5-37f9958f5885@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 31 Mar 2026 08:43:21 -0700
X-Gm-Features: AQROBzCrulzM_NYGi8iXSi5txAuufuUANImipjPaeV3dLXg1MucZzatFvm8IhI4
Message-ID: <CAJuCfpGpq+AiSNDEENAWQZvnDmvegu48o0C_SAixDPOWDEBUjw@mail.gmail.com>
Subject: Re: [PATCH v6 5/6] mm: use vma_start_write_killable() in process_vma_walk_lock()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org, 
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
X-Stat-Signature: u9z1qjw3mms5dogj7h4gzmcyba16ukcm
X-Rspamd-Queue-Id: 4D2B1A0005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774971817-299438
X-HE-Meta: U2FsdGVkX18Kip5eXM67Wj0QlIKSI1mVNomvQZE1/dEWzKKX184jE4+q5tj5jq5j/qdk6uTgq8ULhOme597VBsOatceI1Oxzbk3EXwAFj3Rbb9HT2L8I9SYnk58G9Ls0s+HJ4nDnKi+xsb15SpFmP+FhcyfSS/CTM+F6jAbgPK2QHh3VFV9bDO1TRvfX7g6MTn+rUPlbcZmBX9PGSIli78PfOLpt3VlmIumk7Jqo3U+sFFBO5pr7VggPLkkLWt75PaXVPpSR4bgxcwZJuS+50P20pGD8VhAsehKYOaxGwEtYM7CLMcYW6/5K9x2K2TFBPaRQigTuc6MxIwKqmIvB0oharbGTvOrw6ltWpRa16dlktrL2lqXLApEq9KDKVRSyAhsnEhAuHEQ64iGBHFrcExmJ6KRQ8Bq46ooQYWo3xiOI1OBtqWSEoyrH7Siboo21D9EW+KbztB3Qae8jOSlzQ0LI9o4dHrx9o4ubIblPKHZJzUbrCL7QFmunvpfSUuuBxsSyABAcTCeTwlgIUGg9kzDRrUnDLQJxlpOO46WioT2D76NpIVnE6Ed9C4zz5+0hJ93ZJCfcRV1xO/CKLeAltAFcndfvvRnftg2deoMuUcvGhGpQ7sSLDszwHSjeJoCdXq61qQudQPB4SMQ0EiBHaB7MOjLRFcwwtS+Vuc7KgW6ATU/VYdYMevMP2K0xe32dOZOUU4UjOUgjwUR6PZJDcYcXP5a0iyV22hmWab2dH+2RZAB5Xa8K94vFdaFuto0v862vEy4e7yNJgNn1qNfRJyqnCX9A2qzBBa3FAA9LG+v9iLKfhHNRIHx9PUAXHxUN3hQ9xcB/Cyo6kk4VdSllKNOKooEbgnou4DyRE2g9dRi1ZYLddOabMC6PF7q1oLIe0coJk/J1v5LIezSWOpigGC1qyOU+caCLrwl8SPVFKbvbyutkDGDsLS7VIA9/qt+193pFZh1yB7iZyc2YC3Z
 YTZg1tfj
 wTn2JlSEEVQ6GDTUqho5iQPBUX9iNPN/HqfOkk8ftzV25WObT6CdnCBpi7bx0+UsQE/DK2xLY0fKgPdyRZe2IvOokkXBjmw7z7GnlkgpooHTX8Pe3t9M2bQEgbjvcLxVoC9eyCsXxvbox38gn96h/fu+mNGPyit33Ugq1yY0raMKd9p9PrJcefqe1KAGgm0B1zRkBRngoxbJ2N52OmLao2AyDabcnRTF4iq8g/Bhex20e+GHgAUcs2A6240TMasLRIwKyNHFTNiwp3OekJ5xLX20ZXwZUAqVI+lPq4bLpolahRV2Yq6L7fyHljFBvEqkARKnJZzpgUJqvklfDXzEGj5om8er8K0l+OdosrToGup+cfPhuNDeOa8hHmy0SoZPXLfbZofF6XkSaZRzEI5XEWjrQWnIspeljl/PbgBs6IakVktApugi3Pfl9y5bxuJXt0IEDV6wNgjv4iv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:39=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> On Fri, Mar 27, 2026 at 01:54:56PM -0700, Suren Baghdasaryan wrote:
> > Replace vma_start_write() with vma_start_write_killable() when
> > process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> > Adjust its direct and indirect users to check for a possible error
> > and handle it. Ensure users handle EINTR correctly and do not ignore
> > it. When queue_pages_range() fails, check whether it failed due to
> > a fatal signal or some other reason and return appropriate error.
> >
> > Suggested-by: Matthew Wilcox <willy@infradead.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >  fs/proc/task_mmu.c | 12 ++++++------
> >  mm/mempolicy.c     | 10 +++++++++-
> >  mm/pagewalk.c      | 22 +++++++++++++++-------
> >  3 files changed, 30 insertions(+), 14 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index e091931d7ca1..33e5094a7842 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -1774,15 +1774,15 @@ static ssize_t clear_refs_write(struct file *fi=
le, const char __user *buf,
> >       struct vm_area_struct *vma;
> >       enum clear_refs_types type;
> >       int itype;
> > -     int rv;
> > +     int err;
> >
> >       if (count > sizeof(buffer) - 1)
> >               count =3D sizeof(buffer) - 1;
> >       if (copy_from_user(buffer, buf, count))
> >               return -EFAULT;
> > -     rv =3D kstrtoint(strstrip(buffer), 10, &itype);
> > -     if (rv < 0)
> > -             return rv;
> > +     err =3D kstrtoint(strstrip(buffer), 10, &itype);
> > +     if (err)
> > +             return err;
> >       type =3D (enum clear_refs_types)itype;
> >       if (type < CLEAR_REFS_ALL || type >=3D CLEAR_REFS_LAST)
> >               return -EINVAL;
> > @@ -1824,7 +1824,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >                                               0, mm, 0, -1UL);
> >                       mmu_notifier_invalidate_range_start(&range);
> >               }
> > -             walk_page_range(mm, 0, -1, &clear_refs_walk_ops, &cp);
> > +             err =3D walk_page_range(mm, 0, -1, &clear_refs_walk_ops, =
&cp);
> >               if (type =3D=3D CLEAR_REFS_SOFT_DIRTY) {
> >                       mmu_notifier_invalidate_range_end(&range);
> >                       flush_tlb_mm(mm);
> > @@ -1837,7 +1837,7 @@ static ssize_t clear_refs_write(struct file *file=
, const char __user *buf,
> >       }
> >       put_task_struct(task);
> >
> > -     return count;
> > +     return err ? : count;
> >  }
> >
> >  const struct file_operations proc_clear_refs_operations =3D {
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index c38a90487531..51f298cfc33b 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -969,6 +969,7 @@ static const struct mm_walk_ops queue_pages_lock_vm=
a_walk_ops =3D {
> >   *      (a hugetlbfs page or a transparent huge page being counted as =
1).
> >   * -EIO - a misplaced page found, when MPOL_MF_STRICT specified withou=
t MOVEs.
> >   * -EFAULT - a hole in the memory range, when MPOL_MF_DISCONTIG_OK uns=
pecified.
> > + * -EINTR - walk got terminated due to pending fatal signal.
> >   */
> >  static long
> >  queue_pages_range(struct mm_struct *mm, unsigned long start, unsigned =
long end,
> > @@ -1545,7 +1546,14 @@ static long do_mbind(unsigned long start, unsign=
ed long len,
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
>
> Is that really a big deal? Does it really matter if the caller doesn't ge=
t
> -EINTR in this case? This feels like another sashiko nitpick and is addin=
g a
> bunch of additional complexity here.

I think there is a difference in that the userspace caller will never
see EINTR, as Matthew explained in an earlier version, while EFAULT
will be seen and can be handled. I don't see why we wouldn't want to
report the correct error, and the code doing that seems clear and
straight-forward to me. That was in fact your suggested solution for
not checking for EINTR :)

>
> I mean if you 'filter' error messages you might always end up with an err=
or
> that's different than the original...
>
> >               nr_failed =3D 0;
> >       } else {
> >               vma_iter_init(&vmi, mm, start);
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index 3ae2586ff45b..eca7bc711617 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -443,14 +443,13 @@ static inline void process_mm_walk_lock(struct mm=
_struct *mm,
> >               mmap_assert_write_locked(mm);
> >  }
> >
> > -static inline void process_vma_walk_lock(struct vm_area_struct *vma,
> > -                                      enum page_walk_lock walk_lock)
> > +static int process_vma_walk_lock(struct vm_area_struct *vma,
> > +                              enum page_walk_lock walk_lock)
> >  {
> >  #ifdef CONFIG_PER_VMA_LOCK
> >       switch (walk_lock) {
> >       case PGWALK_WRLOCK:
> > -             vma_start_write(vma);
> > -             break;
> > +             return vma_start_write_killable(vma);
> >       case PGWALK_WRLOCK_VERIFY:
> >               vma_assert_write_locked(vma);
> >               break;
> > @@ -462,6 +461,7 @@ static inline void process_vma_walk_lock(struct vm_=
area_struct *vma,
> >               break;
> >       }
> >  #endif
> > +     return 0;
> >  }
> >
> >  /*
> > @@ -505,7 +505,9 @@ int walk_page_range_mm_unsafe(struct mm_struct *mm,=
 unsigned long start,
> >                       if (ops->pte_hole)
> >                               err =3D ops->pte_hole(start, next, -1, &w=
alk);
> >               } else { /* inside vma */
> > -                     process_vma_walk_lock(vma, ops->walk_lock);
> > +                     err =3D process_vma_walk_lock(vma, ops->walk_lock=
);
> > +                     if (err)
> > +                             break;
> >                       walk.vma =3D vma;
> >                       next =3D min(end, vma->vm_end);
> >                       vma =3D find_vma(mm, vma->vm_end);
> > @@ -722,6 +724,7 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (start >=3D end || !walk.mm)
> >               return -EINVAL;
> > @@ -729,7 +732,9 @@ int walk_page_range_vma_unsafe(struct vm_area_struc=
t *vma, unsigned long start,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(start, end, &walk);
> >  }
> >
> > @@ -752,6 +757,7 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               .vma            =3D vma,
> >               .private        =3D private,
> >       };
> > +     int err;
> >
> >       if (!walk.mm)
> >               return -EINVAL;
> > @@ -759,7 +765,9 @@ int walk_page_vma(struct vm_area_struct *vma, const=
 struct mm_walk_ops *ops,
> >               return -EINVAL;
> >
> >       process_mm_walk_lock(walk.mm, ops->walk_lock);
> > -     process_vma_walk_lock(vma, ops->walk_lock);
> > +     err =3D process_vma_walk_lock(vma, ops->walk_lock);
> > +     if (err)
> > +             return err;
> >       return __walk_page_range(vma->vm_start, vma->vm_end, &walk);
> >  }
> >
> > --
> > 2.53.0.1018.g2bb0e51243-goog
> >

