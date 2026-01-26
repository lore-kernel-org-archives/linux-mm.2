Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB8F6D19510
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 19:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF096B0088; Mon, 26 Jan 2026 14:21:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB61C6B0089; Mon, 26 Jan 2026 14:21:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1B26B008A; Mon, 26 Jan 2026 14:21:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C8E216B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 14:21:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F3D9C2AA8
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:21:43 +0000 (UTC)
X-FDA: 84375084486.10.D5926FA
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6ACEB14000E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:21:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YK5HZXnQ;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769455301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gYW3g8zubsKps0K33/sRTflluIAFrC4jqoC29wkQbGs=;
	b=Uzyb8dOYr9lmyuIblqq6C6u1QpC9jG8yFyRe8k3Kb58tJjptqSG3A+8wvrFkn6SfKjNicJ
	4oOuK0hnuMfeJxlQAPphmS3bJPSS+gqP0v+Zft0mC8dSWupyGPpAttWPK93q/DO7dEUyCv
	9EHNkTeEFUQoutHvVMjlpSW44PwSVes=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YK5HZXnQ;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769455301; a=rsa-sha256;
	cv=pass;
	b=1Em1FfffXddIy2jEA2WKn7tftyCoP6g6OWfA5QXQoRzMg1molB0AUIzxjDfZS7D0flYUem
	YoiUTrDLMvda5GkEN8n8ign2peD8nHe/2oGJ+3gwtvcuuyV4DS/o7ejAODJM/0y0XdEc9f
	KesXSfyo+CvMRsnDOUK71eY57dAIvgs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-5014b5d8551so71801cf.0
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:21:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769455300; cv=none;
        d=google.com; s=arc-20240605;
        b=VAicSd2RXXsmVV8el6J/sieW1YF8RQuLzob204T+uFNSLMwQld8FB0Q0Eqb15DFjN2
         k68p0AcMM3HcOU3PGGxIoNTq2Ty0/ADXCTy2yDsziu9K34YjDPYnzdfBDGK7dJt9El1s
         5BBzS78myYUL/Zr36GZ8mDZwnc1UpGdyo21uroJrdbnRmuCvF5KiH0i1Ai9Yr1MAeBUz
         Le7iwHOFtqvpAbuP/DfwAUE1mCpimBy6tc8eWOCUeOeWbKDzZcukqFIPXlzPedCOObO0
         HhA5sXJ78pbKv+N/cMw0Fdn0H+Ky5Dllj5f6BskiHYO3sBXSeB5fv6ejJeZML9GRVnOd
         NJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gYW3g8zubsKps0K33/sRTflluIAFrC4jqoC29wkQbGs=;
        fh=XEYtnlCIC2AAejFhFwnLSO5bvTf9C3dEOqRcaSRCcVw=;
        b=G0lgFlhxsLn713+AoDPZVDKyxj86uSHAtwKZzqkAWuNYtam9x/61DbmD5bJP7fWgxQ
         DtMext6sa1+MGRlVSZ/J4glGGiEIB2Zk7wECw30rbj9Th8cTzZEPOJ7f41yYeVWbU+Kp
         rZfQen0JHVdsp37GUpgrAxcV0VlPPKzxZYiJ3yiR/fR8vm8ooLytRontxvLgXg2uTZUo
         EIc8b/XM3WQw737qh+UTKL6sL40rlkmYnEwRm4au+SQ5emnzF9lXPjmPzTO/87kILPYd
         idW07YHwbB+cRVnF3rcjvq755kzYN8M/CHIujAbHB008pNUYlAxt87nhmSDUSNl2eOXm
         hDMQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769455300; x=1770060100; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYW3g8zubsKps0K33/sRTflluIAFrC4jqoC29wkQbGs=;
        b=YK5HZXnQEnTpkYk/xZP3L8a4bTsTw9wAUHjq2foMZ7GaXGRzkqd374xd+xdCPgpzL7
         jfuFnkEKIMGyLMlBE2OuXnHIRUiniY6PGsjRvM8zIaIgC5kxVVILHWtfVEuTAE1T0aUv
         gPSt5WqQ8onTBw7Bzif6PubI0hGqdCiJL1MTKOxn9Xv7SlHMvXzt8ScUGsjNThAxzpmU
         xIJRsZIqeUvuWBiPeiXw6yzeRVYx+bp48MC6Q7KUycf1z1f51pn7Ex3k9pNkdvgyf/gR
         z3zbvEAGCorCzsnrZ8Yko4K/npJXtmfrLyypcGfwnv4ZYlGpQIxx9O0oby7zIweIulxI
         /otw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769455300; x=1770060100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gYW3g8zubsKps0K33/sRTflluIAFrC4jqoC29wkQbGs=;
        b=bh3l8u6iN9jjpm5y+Yk/5TbUqq3B+t5xB/ZrtgXULWjF5MALXkPAQy5IPIq7EwPmjt
         kxc2mHHXkme9Hgmg6HN6aUtj+avwQPrT66md51WRNAm/COFboZBrHRpk0ayvExuuS+Ip
         3cab8DxiFRs+y1aziGVwArctINJcxUxqQE2OLwNU7tIqMOpq3ut2tUb541TculoiM1nH
         Z9sqmr0EYT1BnT4eCoW5Y/y0yl6rnwU1ONFL0lCE2eRsq7fPUsJhF/imDJXozp/1M1FM
         bdIMQrsjkWBtVx6bnpO0Fx6SYpiwza3jujbfjpeX95c/DMbWczfOGPTm94wiysIQyWnn
         iCDg==
X-Forwarded-Encrypted: i=1; AJvYcCXUz5x1f+A2SkWFxlRjTSxLQJZOXdBzBiBv/zl7KzF98DhGh0RwYHBkatASH0/dFcasGY2ATLe1/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2JArjX5Ecu8Wxvi+iY4PL1bURlqRIAmtEddnY/Y/80mryxXrV
	IQ8yDo2ohu5mz82cP6gOuOswRJ9KCUOJKzSD1+jRVhiyy/svxBaGIwfviMTv3pKvkbnitgDRjCc
	u6PN6qvVv7bcUtKyGnp9USfNX8L6fr2AycTzdFKpd
X-Gm-Gg: AZuq6aL6vub6URzPCteLKFlr+RLKHAgMoKAEwwD6sEmUnVJKaUTKTMdXS0LWzC2KoVg
	A1UT3XnG1x/DPtLZVyL39oh8814l/VDc+21vcrFs3sNAG7OSLqL7PN3gddB9bC8qyICuvvkiuIx
	LXzR2/4VllWUq/Lot0sIvT3yuw/1VIH5rjPym6QaGAAB9OAzKSL55EhbX4d9Epi69EMYsR3F5Hk
	Y9mBN2ge960RZV3FlNHeVfBnPY+262VsFrZvki0mwfkmGZeKEwjapltVKKdq3oXmwv3ug==
X-Received: by 2002:ac8:574b:0:b0:4ed:a65c:88d0 with SMTP id
 d75a77b69052e-5031428f27emr2159301cf.6.1769455299991; Mon, 26 Jan 2026
 11:21:39 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com>
 <ef6c415c2d2c03f529dca124ccaed66bc2f60edc.1769198904.git.lorenzo.stoakes@oracle.com>
 <47eafa10-6d13-4324-830a-2e7cf4e67f2b@suse.cz> <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
In-Reply-To: <6444753e-1df7-4732-912a-0ea441f76cb1@lucifer.local>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 26 Jan 2026 11:21:29 -0800
X-Gm-Features: AZwV_QgPNzfNfXGAlKz4oU77bmBtnXD6k2LfcRE7XAUitpkpeYH7g04K8qEwn1M
Message-ID: <CAJuCfpEBHsuGJFAGyXdASpaV_FY0_RBShKZM3QA_9z7ZvAtu6g@mail.gmail.com>
Subject: Re: [PATCH v4 08/10] mm/vma: improve and document __is_vma_write_locked()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
	Waiman Long <longman@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 9sf87utwfemask1mc65f7kgiathnrzos
X-Rspamd-Queue-Id: 6ACEB14000E
X-Rspam-User: 
X-HE-Tag: 1769455301-723891
X-HE-Meta: U2FsdGVkX1+QwXJPCYK8ZMQmum+lKg5a8b7+06UvBbQ/Uo+c6Type5L/sSUb3bvrvkPBFTZ7QRon2jDrFW7HT6s33RvnkPGwpANiRXcfJYxmPQl/56uLOa9HV26t9vRxHyhezsNvqlttZlf6HhlnNIMjtXiOUNplKFM74UgwehVNEsTFmKEjunmZV2n4VkbmnMAiwvhGs5cmX1c057JtEgEe/yPsEbjK5mcqXXxCpKCsgJihOSMvM6PtyLcKBlr4oA54apz1LFPm6lghwP8vkSaQwLI4C3hTOHSd4SGYXdwilkkmtpH6c7EZ2o6LPqQ1WsNRhsGCow/goA2ziNXqxVk0bBqHp2nmOVMovUVfqF1tOwD1y1W35XmpO6RTsBbJgEf9AuxE4z2jgxVXZl5OLRYQFGyA0PgJUNBLxoNCheBknMoYX6oN4R4r9GsS2RTz0o3wKVUPer18Jb8zXW6hkWOSBDfITzD+U7saUB0/2ieN7jQNMfsPIDUcJmZpIUKw3n1ZGAWomHUPybPbL/QflyaE9gcrze//1EUp/dg9OQT015zPtYBk+aZSC4RPFGh++yQXHb3+3ikudT8d55paB/KOlTu/ysh0atDroP8EsYj96aT6xwkutG9aqDE4fB2qiA7+r5P1VPX+xBvAiLbWjFBLPYmc0l35bauOqN6hoOj5JfRmDWy3vxJGBPsHzYczcMH/TBJN9xX992GcLvSR0JgqyjB7pyJjSNX1yTCewwMi6zyCqpSiF3ISdD4ItsuL1hE3B8pPOonduXyEMe0jl9ilepqRDdXFF2KEVnjv/Id1d1kI++HEKOrBhGoaPv4CaxXQXC43/1dxePgxdOAR4zhQ/TPKXcovKXk6beSiNzRYzbEAVwgMRQHuH9R3i+DroaI3BuUYz9p65zH3VWEMOQRBoaD9IspXkxq5TxVvLaLPbybMpQAvkskAOHleSdC1BNJOc1sQ/4q65yJHHzF
 M6CTjvV6
 tPBLbScigdmlsD+Iant9i6/1dCy+jHa5pLC0jG03xRNG+2g2gFCrRWgtGTKD1R3v2TzK81HfXNrOntaIeq2illChZHR3pb0MGNWg8XUnL4AznmT+WCnYiBR5El7d7b7tbpeUuqZrwdhXrlS+tE8yP4Uw2vV+X8WTjFUk615etucJBX7BZTkaj53g5PMRfrse4vV1bZA1XgFhXz4/3bwauZvs58ESZV66wMMDPpvklsZYD9BnobSeNWByqIv/K++F/kHoVVzkPhx8hJj104HsC/4VVuP57deJy4k/sy519CkA5GpolQuUeDTWdJKJgF48i6E9YyZ5mUjShUyxeKuuNJ6pgUDeuuc8S5vgv0mmD9IokX76kEmgZyBZJlNpGLTZ3FAb91hENA4lPa6Ne9u+Nnhpg1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 8:29=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Mon, Jan 26, 2026 at 12:30:04PM +0100, Vlastimil Babka wrote:
> > On 1/23/26 21:12, Lorenzo Stoakes wrote:
> > > We don't actually need to return an output parameter providing mm seq=
uence
> > > number, rather we can separate that out into another function -
> > > __vma_raw_mm_seqnum() - and have any callers which need to obtain tha=
t
> > > invoke that instead.
> > >
> > > The access to the raw sequence number requires that we hold the exclu=
sive
> > > mmap lock such that we know we can't race vma_end_write_all(), so mov=
e the
> > > assert to __vma_raw_mm_seqnum() to make this requirement clear.
> > >
> > > Also while we're here, convert all of the VM_BUG_ON_VMA()'s to
> > > VM_WARN_ON_ONCE_VMA()'s in line with the convention that we do not in=
voke
> > > oopses when we can avoid it.
> > >
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >
> > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

Sorry but I have one more comment below.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> Thanks!
>
> >
> > Few nits:
> >
> > > ---
> > >  include/linux/mmap_lock.h | 44 ++++++++++++++++++++++---------------=
--
> > >  1 file changed, 25 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > > index 678f90080fa6..23bde4bd5a85 100644
> > > --- a/include/linux/mmap_lock.h
> > > +++ b/include/linux/mmap_lock.h
> > > @@ -258,17 +258,30 @@ static inline void vma_end_read(struct vm_area_=
struct *vma)
> > >     vma_refcount_put(vma);
> > >  }
> > >
> > > -/* WARNING! Can only be used if mmap_lock is expected to be write-lo=
cked */
> > > -static inline bool __is_vma_write_locked(struct vm_area_struct *vma,=
 unsigned int *mm_lock_seq)
> > > +static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct=
 *vma)

This function returns the mm->mm_lock_seq.sequence attribute of mm, so
no real commection to VMA. IMO it's better to rename it into
__raw_mm_lock_seqnum(const struct mm_struct *mm) and have the callers
pass vma->vm_mm.

> > >  {
> > > +   const struct mm_struct *mm =3D vma->vm_mm;
> > > +
> > > +   /* We must hold an exclusive write lock for this access to be val=
id. */
> > >     mmap_assert_write_locked(vma->vm_mm);

If for some reason you need to keep this function VMA-centric, then in
the above line please s/vma->vm_mm/mm

> > > +   return mm->mm_lock_seq.sequence;
> > > +}
> > >
> > > +/*
> > > + * Determine whether a VMA is write-locked. Must be invoked ONLY if =
the mmap
> > > + * write lock is held.
> > > + *
> > > + * Returns true if write-locked, otherwise false.
> > > + *
> > > + * Note that mm_lock_seq is updated only if the VMA is NOT write-loc=
ked.
> >
> > This line is no longer applicable.
>
> Is there for nostalgia's sake! :P
>
> OK maybe not...
>
> >
> > > + */
> > > +static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
> > > +{
> > >     /*
> > >      * current task is holding mmap_write_lock, both vma->vm_lock_seq=
 and
> > >      * mm->mm_lock_seq can't be concurrently modified.
> > >      */
> > > -   *mm_lock_seq =3D vma->vm_mm->mm_lock_seq.sequence;
> > > -   return (vma->vm_lock_seq =3D=3D *mm_lock_seq);
> > > +   return vma->vm_lock_seq =3D=3D __vma_raw_mm_seqnum(vma);
> > >  }
> > >
> > >  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lo=
ck_seq,
> > > @@ -281,12 +294,10 @@ int __vma_start_write(struct vm_area_struct *vm=
a, unsigned int mm_lock_seq,
> > >   */
> > >  static inline void vma_start_write(struct vm_area_struct *vma)
> > >  {
> > > -   unsigned int mm_lock_seq;
> > > -
> > > -   if (__is_vma_write_locked(vma, &mm_lock_seq))
> > > +   if (__is_vma_write_locked(vma))
> > >             return;
> > >
> > > -   __vma_start_write(vma, mm_lock_seq, TASK_UNINTERRUPTIBLE);
> > > +   __vma_start_write(vma, __vma_raw_mm_seqnum(vma), TASK_UNINTERRUPT=
IBLE);
> >
> > At this point I think __vma_start_write() could just perform
> > __vma_raw_mm_seqnum() itself and we can remove the param.
> > It could possibly make the inline code smaller.
> >
>
> Good idea!
>
> Will send fix-patch for both.
>
> Thanks, Lorenzo

