Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB315D3EE9D
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504F46B02B5; Thu, 22 Jan 2026 12:28:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DC896B02BA; Thu, 22 Jan 2026 12:28:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B3966B02CC; Thu, 22 Jan 2026 12:28:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 27AED6B02B5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:28:20 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3EFAD2D74
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:28:19 +0000 (UTC)
X-FDA: 84360283518.02.8160F84
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id DFA1AC000B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:28:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4BSb0iit;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769102897; a=rsa-sha256;
	cv=pass;
	b=Sn1hbJJqaRPc5v6ilBzIjWKeWAmGT3xGeTFpLwFep9Re2c/jrtprStZKEcIg6vVPtTf86T
	p3QFZ1HnTp//4mn68UxgDmLORGEm0uzxcfa80hoXimxTT9INhdWu/X3c9FNYzrbjn4oa2a
	7c47gypUFgRvPx38GWecWg+fOCEGACA=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=4BSb0iit;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769102897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKR+9mNOqKRizGQmFeK0caxIbjw2qX9Nz0/t9kP4530=;
	b=BGWLQCy3hhM4le2ggxgwR8p5bzw1gLg+u+gxNwCT+AZehGFBnV8BexQpgFmE8JzhoHGzlP
	jlEV4LVpYxMVSSTxJQX1dBco0p1Z3gsP33doMog7+fi5SL/tj56XhYQ20caAvKMDi/itto
	uQi4KHW5VBT3bIG2VFc62cucBX2h2vM=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-50299648ae9so436391cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:28:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769102897; cv=none;
        d=google.com; s=arc-20240605;
        b=OXIoZDPs50e8Zmk1WcebX9hkn3y6DbSoqJhCI4k0qrUK9RisTd8inLzH+ei8snM5OO
         OncGIcj6fh35AnJoHSaYy6HdHTp1yV5G0EWdA/FmKa1ne52kb5oidGNdEe+wrOs4GgUN
         rVTjCQY+967zLG2wEmSdmEmaXeuCSg1CJVazcZc1lauoyJuQH4mHjNG6pSC6t9vQdnAD
         GLibdROd/C09uvdsYHpwoTtcI/g+lplMcMwNfQ+kX6ssuas8aOn4U8Ak4G7O/XE16rMI
         3WrsXIxkhizyC2cy0xtWau6j02uQwLcPTWRHKOOSpxOsrN1V0iOE/RFYQLLWKvbc7ikP
         1zkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vKR+9mNOqKRizGQmFeK0caxIbjw2qX9Nz0/t9kP4530=;
        fh=gT5+h0ed/6+GAZy3Tzx8SgiDlMA1KoGorpGHOY2/+2Q=;
        b=ZChYD+K7C1dnx/URpOXotfU+B4gzhsTQYLhXrU2lRi2iSGg7LacxX6Lzmn3VK1YXHy
         lg1w6gfYzHuz+mxW4kcVCVq5bWKbezKMLEtT/n2e7fjj4dEXEisCa5F5RuMcHYlncvYK
         2jxoJVkt5EOXNaNoTkJs+yJet4j2MzYCRHvWTfgtfx9eodn4c8Q51HKWN1biG9ATHk9l
         cbJa9P4tiPELqvf1otfEcaTV+xEgrTveMjLS9IR26xy2pn4K5g7BDjMOXB92yczsJcMb
         IRkK5Fko1iZ/RrsXZ3NB2Zb5CTh0rfNjBq2LMl74Am4nK0V3VCRY9Zk59Njnkhy8sJTF
         27Jw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769102897; x=1769707697; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKR+9mNOqKRizGQmFeK0caxIbjw2qX9Nz0/t9kP4530=;
        b=4BSb0iitfOllijpg1x1AWEyYJd/re4mB/mgS5wa9VFHCK60Fe5eoX7l2mAP4ueS0hq
         a3F/5UWu9k5pMi1l/r2pNlEPQAaPMjVz8uzpGEtxRe0mj5vpUr/twEqOpgZMTuehIGFO
         SDuhjCD0qnJUSBzXZxKJKsbsdcvyG7zKI7G1i/wfG6X04A1Rfl80iLaOqCgqvnAerT2r
         fb2u5tmbCZ9U6k/rmXeYXMXfd0qfYTncIhYA13fKWPd+ZdYXCC7mUhhGGjeikhV2MgCA
         GwPMHdxfZUyezEwWJqfCeirsbx2j57eULRZ8qS22VCiLUlNbgMb/OQ9+bvkLq7x5VjGE
         uHXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769102897; x=1769707697;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vKR+9mNOqKRizGQmFeK0caxIbjw2qX9Nz0/t9kP4530=;
        b=hlyua3Vm8BLq1pw0LcL0x883SVregVPzjkUmY9RJk6SlhqQoPP4qIsx5cRHnNlH/D5
         HxZzIh6Zhvl6OulNQtaUiJn3MPkwgeN4aEJbSShHsc79eCmL7OC24PcvEV2uxCqoMPL5
         1MzPU9A0pX0b4FcY2crvU5zVYDIi3u8RhzlHpfEhvrWvfRAD/YWU+RgWdeIj1N4RHFR7
         yni7/sl4GsyabPdVOInPSVWZwBN//DdKaBckcHxHR2VVHYJi5hgI9npo21ufejVv/TFS
         TBAIzLui3HCvrno5vzev2OcBAsvGlmsWDj7GEvEPPLhNvWx+K9mqz9+RtSnrDGRZOPuR
         74WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVDtROfvGM8yfSwlplztEt4j8+1DsqUtnxNoSJwwawUtDmeP9lvvLCXjW+FJbzaI0hd+adHGn5fXw==@kvack.org
X-Gm-Message-State: AOJu0YxQFOwygByXMc1FGkVLLlDZ8CWqGd2i/mMzoKcWJo0gTjCX4slL
	jIja0e5oDjq9gFE+A0ZFjNLdFgrkzgE2OQFaaTOihRCjFxEKkp6l0a2Usj7BAFTqJqEKknSX81B
	kRj/yl0h1tEa+GW98BYTIXCBJVxbubsesN9oQ+QSP
X-Gm-Gg: AZuq6aLTZg2swxszItIjEIrLeCephyVP64uxgoykYcpn7HKU/bnhdC0VRPUHOL+lw0S
	NeGJt2LwzvEwBuY62kFlNCo2WpgF+oxpUKQxV6ZuemsTekMZhBPYqn1xJouuxY+4M//azVLjqt+
	bIk2Lt87BatTFJ7O03J80tmQ4Nmvhzvd26YjzwCg2Cis9r1mALbaK1qvZgt6R+08xf91M5Q32Yh
	uhujDu4kCNjDvkB112lSNePTUWjf9ItzmnDSumzpbSLzuQHmRjUX6uxkKUfGHXdMo0JOLfk69NS
	fYxEwsOMvY3O1Ar/8X3moPEY
X-Received: by 2002:a05:622a:5f05:b0:502:f58b:49bb with SMTP id
 d75a77b69052e-502f58b4cc6mr3220861cf.9.1769102896508; Thu, 22 Jan 2026
 09:28:16 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <a28f56dbe5057385b07498684dfb105918bf3644.1769086312.git.lorenzo.stoakes@oracle.com>
 <7876e97c-9afb-418a-8ef7-5f4f306b7eea@suse.cz>
In-Reply-To: <7876e97c-9afb-418a-8ef7-5f4f306b7eea@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 09:28:05 -0800
X-Gm-Features: AZwV_Qj5mha76ke8ifuGRZO6bD7iXP8oHrXlIUbFTB1-LzCBB2mAqlQ9bOo7PfQ
Message-ID: <CAJuCfpEyxqSfiK0M4VfKmZnp2OGYm-Le882aFNhPSef1fSCT0w@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 02/10] mm/vma: document possible vma->vm_refcnt
 values and reference comment
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
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
X-Rspamd-Queue-Id: DFA1AC000B
X-Stat-Signature: xpe7m9fketxgi5okuk841t3ce8rr99gu
X-HE-Tag: 1769102897-324562
X-HE-Meta: U2FsdGVkX1/EYv22zgk3Zhq6yWKJKKXcfVbpvXKG/kSFGa1HJsCyGCYFKi6K8uAiWJwORX6pErMbfdT85/wDhyjvKpAPi8aQ4xMjlYwL9FJLDBgQuO+AZeBJOFnrPBNRFeFXzHHXPLfTQmQmhqa+ZUnPzvtsunZjI2VNpqS+WCPAUfNQwBbfjioQdO2zhZDfpR4RS9lCfJ2kRh90nzLI+sOSUbYmvW1IHNR/WucnhoK/xO9Y5/dM7io8cte4ASlc3eGb7QjB2oF+z8k5IJC2IwNy/IRzkEOb60Jxeg1b8ORbpNRGySblhdWrCVru1gh/qvchIktiOKa1ILhqitDKYY9n6BWt3nT4p2nTsGYB2ZSfERVcqRR/Ss9ZnXSJp4EXzvR5vWnn1HukKPqP0SmarHtQoskkBxq2xv3eRWEBvPRnK/lBO/Fn013XmG+V9IxLz/T7aIh2ZySfCvnljULnoZ9HySkRTzKy/ilsmTcAKFwYZuDUE/5jJGTV+UqRSLKXSB5tLEB30/RVpja9c3CCbltIaNMNSgl0ZsMy9HRl9n8N69VI6S6boALIpALkUo1VH5CJqucr5ibLCup7Ar+Sxh86RhjEJBiXkbOuFJcBJbQrEesyQsp1oCxaahMAFGZr/vPe8HMlMJJRA7x8QxUm5QPuiYexjunQov47SPoyALKhCh7jn3FrJ+lUpX6j4TAgjarqfa1Rol5YLO7Sun/BhiMfOVWI4cCxDWJT5XGkQJA9YRQ2iAFszMOZUKNG0A/3Vz5oXpFvq5RUL7q4Bkc1no5Q63HZKe0iDFUuBOyMQC+ISD5Bi7pCRrXvZtu56D8gEfOITBgHtR4ev502jhqY+/8hG+qKAnMbznkxpzh9LWwzbjbMyknvyE7mcH0UGyycw/LMXnBCUTLhJG4ysv56f7XlRHSQeMlF6UmIAW8gwo1QV065Dc+zu/sGt3p2l78rFQnOu4rxB3WFGM7CNhx
 HoGItHba
 ZHVBhSQKJ1DvVahJpIpYnpmWyyigbLB0ezOXjqEtlIJoRuDvyI9DrIM9TxrRGW+x8fhplIRB5QxmLpPQ67UGF5GWSvqBMmA/NEyjdDbDRdTmuxEOpEZAN9j8uiwvaWBIbesw2O+ACcZbRUxmbUuCLo2POOaHWyGKakTWEYOqjvqKBZHATgzVYlQ5OKd9WfgZ0C8L7DhW0qmBobLhzFwUWvWIWsLu42RVBwRxeBmejXFD7pk6QNDp1J1woYO7uxnT3fyhpkbVnxP+HNQ93v6PqbzDNYw9WpJ4jDs6Q1Bgyx1LfGRUnfEk+nisR+7kLuTQIgbeXWhjG+tzR1Sl3njTtH6zdeeNdyBaSA5vJQRGXHdvVZY3m5D5pVh2rqJ1wASIjjVo7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 8:48=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> On 1/22/26 14:01, Lorenzo Stoakes wrote:
> > The possible vma->vm_refcnt values are confusing and vague, explain in
> > detail what these can be in a comment describing the vma->vm_refcnt fie=
ld
> > and reference this comment in various places that read/write this field=
.
> >
> > No functional change intended.
> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>
> Thanks, very useful. Forgive my nitpicks :) It's because it's tricky so b=
est
> try to be as precise as possible, I believe.

Another thanks from me.

>
> > ---
> >  include/linux/mm_types.h  | 39 +++++++++++++++++++++++++++++++++++++--
> >  include/linux/mmap_lock.h |  7 +++++++
> >  mm/mmap_lock.c            |  6 ++++++
> >  3 files changed, 50 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index 94de392ed3c5..e5ee66f84d9a 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_a=
lloc(const char *name)
> >   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indicia=
te to
> >   * vma_start_read() that the reference count should be left alone.
> >   *
> > - * Once the operation is complete, this value is subtracted from vma->=
vm_refcnt.
> > + * See the comment describing vm_refcnt in vm_area_struct for details =
as to
> > + * which values the VMA reference count can be.
> >   */
> >  #define VM_REFCNT_EXCLUDE_READERS_BIT        (30)
> >  #define VM_REFCNT_EXCLUDE_READERS_FLAG       (1U << VM_REFCNT_EXCLUDE_=
READERS_BIT)
> > @@ -989,7 +990,41 @@ struct vm_area_struct {
> >       struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
> >  #endif
> >  #ifdef CONFIG_PER_VMA_LOCK
> > -     /* Unstable RCU readers are allowed to read this. */
> > +     /*
> > +      * Used to keep track of the number of references taken by VMA re=
ad or
> > +      * write locks. May have the VM_REFCNT_EXCLUDE_READERS_FLAG set
>
> I wonder about the "or write locks" part. The process of acquiring it use=
s
> VM_REFCNT_EXCLUDE_READERS_FLAG but then the writer doesn't hold a 1
> refcount? (the sentence could be read it way IMHO) It's vma being attache=
d
> that does, AFAIK?

Yes, since there can be only one write-locker it only has to set
VM_REFCNT_EXCLUDE_READERS_FLAG bit to announce its presence, without
incrementing the refcount.

>
> > +      * indicating that a thread has entered __vma_enter_locked() and =
is
> > +      * waiting on any outstanding read locks to exit.
> > +      *
> > +      * This value can be equal to:
> > +      *
> > +      * 0 - Detached.
>
> Is it worth saying that readers can't increment the refcount?

Yes, you mention that for VM_REFCNT_EXCLUDE_READERS_FLAG value. The
same IMPORTANT notice applies here.

>
> > +      * 1 - Unlocked or write-locked.
>
> "Attached and either unlocked or write-locked." ?

Agree. That's more specific.
Should we also mention here that unlocked vs write-locked distinction
is determined using the vm_lock_seq member?

>
> (see how "write-locked" isn't reflected, I argued above)
>
> > +      *
> > +      * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikel=
y)
> > +      * write-locked with other threads having temporarily incremented=
 the
> > +      * reference count prior to determining it is write-locked and
> > +      * decrementing it again.
>
> Ack.
>
> > +      * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> > +      * __vma_exit_locked() completion which will decrement the refere=
nce
> > +      * count to zero. IMPORTANT - at this stage no further readers ca=
n
> > +      * increment the reference count. It can only be reduced.
> > +      *
> > +      * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - Either an attached VMA pe=
nding
> > +      * __vma_exit_locked() completion which will decrement the refere=
nce
> > +      * count to one, OR a detached VMA waiting on a single spurious r=
eader
> > +      * to decrement reference count. IMPORTANT - as above, no further
> > +      * readers can increment the reference count.
> > +      *
> > +      * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - VMA is waiting on reade=
rs,
>
> "VMA is waiting" sounds weird? a thread might be, but VMA itself?
> (similarly in the previous paragraph)

Maybe "VMA in the process of being write-locked or detached, which got
blocked due to the spurious readers that temporarily raised the
refcount"?

>
> > +      * whether it is attempting to acquire a write lock or attempting=
 to
> > +      * detach. IMPORTANT - as above, no ruther readers can increment =
the
> > +      * reference count.
> > +      *
> > +      * NOTE: Unstable RCU readers are allowed to read this.
> > +      */
> >       refcount_t vm_refcnt ____cacheline_aligned_in_smp;
> >  #ifdef CONFIG_DEBUG_LOCK_ALLOC
> >       struct lockdep_map vmlock_dep_map;
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 5acbd4ba1b52..a764439d0276 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
> >        * attached. Waiting on a detached vma happens only in
> >        * vma_mark_detached() and is a rare case, therefore most of the =
time
> >        * there will be no unnecessary wakeup.
> > +      *
> > +      * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> > +      * details of possible refcnt values.
> >        */
> >       return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
> >               refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
> > @@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_are=
a_struct *vma)
> >  {
> >       unsigned int mm_lock_seq;
> >
> > +     /*
> > +      * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> > +      * details of possible refcnt values.
> > +      */
> >       VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <=3D 1 &&
> >                     !__is_vma_write_locked(vma, &mm_lock_seq), vma);
> >  }
> > diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> > index 1d23b48552e9..75dc098aea14 100644
> > --- a/mm/mmap_lock.c
> > +++ b/mm/mmap_lock.c
> > @@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_s=
truct *vma,
> >       /*
> >        * If vma is detached then only vma_mark_attached() can raise the
> >        * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attac=
hed().
> > +      *
> > +      * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> > +      * details of possible refcnt values.
> >        */
> >       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
> >               return 0;
> > @@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
> >        * before they check vm_lock_seq, realize the vma is locked and d=
rop
> >        * back the vm_refcnt. That is a narrow window for observing a ra=
ised
> >        * vm_refcnt.
> > +      *
> > +      * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> > +      * details of possible refcnt values.
> >        */
> >       if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> >               /* Wait until vma is detached with no readers. */
> > --
> > 2.52.0
>

