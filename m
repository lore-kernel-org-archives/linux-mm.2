Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C67D3EE84
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 16:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DA2C6B02AA; Thu, 22 Jan 2026 11:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2B36B02AC; Thu, 22 Jan 2026 11:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE68B6B02AD; Thu, 22 Jan 2026 11:38:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF95E6B02AA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:38:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8564056A64
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:38:05 +0000 (UTC)
X-FDA: 84360156930.04.F9126A2
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 71C71180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:38:03 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hsVtozb5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769099883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+XJNVYw8jPN2hJXKO6Gd31AsDaPUTQQW1O2H2Pw33g=;
	b=Istw3+yRXaRpQSWjgtGJ6IL+CTBkVZa9zbUSwcps0OmJW/nw0DiZccT/oSN4ySQUhdZUYc
	5ESXd3zZhgzDIyYpnUoWtXxu2V+J0P+V/Sm50h+a2SExHFqss4IRxLM3sK5nMg2tRSJbIO
	0coRIc3tC5Jlm+I4m+b4W3JM5grm7h4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769099883; a=rsa-sha256;
	cv=pass;
	b=jUOQrugXU2gzOyzuEgnGt1xszDuZqqp6HfVjV+0zLDF3oPcdAY65ijRBC+ehufuclLADDQ
	YlR5xtOfboKzq6RyPy+mkJUfbUonJ/M3ER581/CTLqdTU+u1GUoqSGemayB+sgEgOGzY09
	t0FzCsDyhA2cZ4qVwtArshmWWJUOTbg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hsVtozb5;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5014acad6f2so472311cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:38:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769099882; cv=none;
        d=google.com; s=arc-20240605;
        b=IFOXhG6CWERc544v+s1HcBtz8erS+Siv2HxUdiHOCQU4iOBEtRCEkdi3inELCtYNN4
         CysEZ/7EGUlAMUENLkyv5Wmpg02t4fbxcA7bGmz4/qgGseXIiNGwPBXAIZU8OP8Vu+GH
         juiQgZJb4HCwfejkzQaerJ5nf1xmJ370bTEW38zBk6cPHZ/tZ2A/H9dHVYlNOdypIS+J
         O9vkASwQb75XSwBFersIOJUx2VCaqA5KvkHcIfxZWdye2Cq8nAcYYaW7RuJjljEDjmkn
         qx1phLH53j6MRHiQ7tFOuIqcNYEe/lNxenXlDjphDUaC+QIgHIL4xpll0ZfLeJkpeTGv
         IrlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=C+XJNVYw8jPN2hJXKO6Gd31AsDaPUTQQW1O2H2Pw33g=;
        fh=lAScB6Y6qhC2QqUHSAoWRVpRCLx4ZPqJ9ekQSBQ4c+Q=;
        b=dzaEQROxJNoKWwLUL0rPW7XuWLWAlZCkARa3McQag8JNoqZnHhULMRPzKWgKV/Cm06
         wpDTeQW4KmcnhxmaASuYavchF1jA9aRsay6a8srMpgmJP/+k235ZqVxOwrEz7vQNfkRC
         psGXaQnkgW1gS8PLBbG/PvmCmdPN+5QZsd2Pdue2X55f4Zlw5LIqbWjT+CHLWiLX8wxq
         h/VOQMexqz3WDK8n6yBs6xX6P7Gbyar7ADv7RM0uC0c3/ekCM6MRsaIcNFYlq0NmWZlA
         BZ+WyFUzbhLD2u9SSRyM1Kc20O+oySsBywq0ZZDIA+QPPZAAdP72Aln1KKGXuAjM6vE7
         PI/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769099882; x=1769704682; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C+XJNVYw8jPN2hJXKO6Gd31AsDaPUTQQW1O2H2Pw33g=;
        b=hsVtozb5mTDdlmV4Eq92dU+HZ2rHS3ItqjeijUBfMyBoFMZFAvE/Co/ZSwjR6fdDcl
         tlp7cR2X7w5Gnow2suwDZ4ykuUnyMP7FaXE+z28gLHsbnRJytwGnOqBCRSmVVeMeJxFi
         UxKC9kH6Z2ieILLUbGg0QDnpLEd71h53kN8v/oosNBy6xFPJ8/3eQCVmuxw7VHyu23h5
         9ss8OoIk7XNbwJCaIbAwretGEQAjxZ/QHMxkg0E5LdfwdBZR1yr6N7zSOQID45NhcxS7
         UsAGqbfaUpk1P/KJPbbO4LNjHEBZxQHJZB8qsQvJ3q5I5pgRKailT7I7EJGVvRneexwb
         Ajqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099882; x=1769704682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=C+XJNVYw8jPN2hJXKO6Gd31AsDaPUTQQW1O2H2Pw33g=;
        b=uyiKGSVKVS6n+nL4p3IKNbiMHSLd6YUO3cJYLr4TboUXBAdOkrdRd8J3IpPiRVXd8a
         q24EDzqf0M+Gmu61zuK9CHQaWtpvqu2GPDQO4VQRThepFnfBgqbXAqf61wkHMevRTk/o
         E3J05DQIxtMFq6EMw5CEqyH7Yyorqsgf034NGlIYvvs1dL85grI1RvX9IorxkZ4sAlwd
         rEzLyOJhJe86yn/N99iTgDdbBZsGbzm3OqrDadH70GIbAbvu2Ms6wuajgyjdjG4wSkpb
         2hA+zXl2ypqiESNFgNWGJWhHMafBufojYp6x9h34rusJoRM5yJzqWKTFnR8yvCp/iCHb
         b9ag==
X-Forwarded-Encrypted: i=1; AJvYcCVDqpqzJsXYhHN9liBRw2r+HdwiC7+2heTfpU2Y6i0vNZAjutSE2g/pffZjpJ4Lbd912Q7Sex2oJg==@kvack.org
X-Gm-Message-State: AOJu0Yy98+5WHPUT3gU2F1Hs6BfOqNEvyuGrn7ovs2fSduigscj8RLU7
	VaimMumhJJcY+a9YACRQJb03l/rYVi/gun/vNA7nPlFSu6K3QlM+opRTeupUiiAh/ByLoD6hkjO
	c1bQa1y9sN4WMO6AbUujf5wSuU6JGfxwUrigCIBlA
X-Gm-Gg: AZuq6aIOUGBWAvxP4hOOuy2pqdKNv6JGU4wB/+7QwuoBO+T5426DwHImMRpIOWdtLSs
	lrfKOlsoG8OPBZxBjHbPjA5qdO3HAfpvMnu0pWi+1BIjF6dr5K2dRpLwLMtAMZQiQ4w+NS99yeL
	iSqm4AWRXoyYUr0/3TdrAbBt8jI/HQNRUHXorcDjFxfO9wL3HgEGCkDMWc94NT3FuU1md049apx
	cGnxV+HqIgZGulEEB0QzX3cmZrQw2NVIbheaW7+yq8to36E1iImTHoVjcuDztI9XG02AKNh20Mh
	FIPNLwxAAnTx0edQiqImdXbZgSsatpvQDOk=
X-Received: by 2002:a05:622a:994:b0:4ff:bf96:db86 with SMTP id
 d75a77b69052e-502ebd89420mr15849671cf.16.1769099882208; Thu, 22 Jan 2026
 08:38:02 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <f637c1a5c9ea237aab598bd8885df48e21497635.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 08:37:51 -0800
X-Gm-Features: AZwV_Qi1sC3YuQM_mL6DhJMjvyalsazWO_0hCWyLwAGLVG52aYT7kPHUYQhat78
Message-ID: <CAJuCfpH-07KqsgLsFoBXjObMakVxb+w8w_UmZi9TTxCEzmaA0g@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 01/10] mm/vma: rename VMA_LOCK_OFFSET to VM_REFCNT_EXCLUDE_READERS_FLAG
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
X-Rspamd-Queue-Id: 71C71180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 8at4166oya6gmudu5mpbzfkw83guj5bk
X-HE-Tag: 1769099883-686120
X-HE-Meta: U2FsdGVkX18TKe4XxvwS2F1gP3GoeElLdiCck6We5SAaSx34oPnOOxla6/k91uKVNNgHuMEQjdOmEP7jK9NA2p89CTfJQnaecqnOLUEqFeLnAE0j7hQNBjOot4ia39pH6KaslEUhx3ROeJ2IGpb5v2RYJJZfDgvu1vOvLIbNUQoHRo/7dClih2tuTC28V0jhrmqH6+Y8OJOyJNzVFnVFNfevhTNPudpCgs/ADHpnEM35tCYNm3LHs4CkLONp+E75mPlVmNkB4OS3X6kavLbhdtL5OKwTC2p+r8M3a12BItPUkY4CCVx+qkPPGPG3y+cHVZatYvr8Mg8FZw95VdrMlZoMX9UDrW+2wt6Jcx4DlkO5Dha2KpFHOZclL3uxfeRUeIhmspqkktcwe/m9j+mOGSgb8iEt/5bxoOGKm+Lgb5+ZCtp25XwdWjoyC8KYtaQt/o1gefHsWk1FJSZc6C/Wh46tWVZEppNb/jnyOrOCaSXRpkfHAn6Xx2aMTXU1P3qFyuu9HyWR4Yi7sSuEpHzTSkyNT/XRjeqR0hEw2TVpUlvk3nY+xs8u8GBWzEiVqO12rAfa+qn1bJlLntIQkTQJO9fTdnpLMJMCOV+uoU4PJziajFJdmuiBmUSA2+rS3bCctEipl2dDM4eo7P47oZhlRL1tqR8ORs6cDshcsGiafHIokpHeGcgLQq4RK5LM2pM/TUSvolQ5Szn09WxA5l2OA8X6o9HVDupW+idwR+S295gpI0/qBAGPh3DahmwB2DQTvNZAogZgKIB0Zxzvk8C9lXGOvfXoK+lPlJFBmKn23HlVVG5nK9M7oiuVxGDWUy9oKPK5sK+uiZKAB8F/1v8s02z5+ksHc0WbdoqKCy/6iZNE7OokCmuyr3nSDtzczs5AT+nSyKhzAdMk6VeIDXjFtfxQFEEAmqzKSVnDUAKA2ug7kdnO6eOCekhxSZmL/D3+ZzwWq84BSB8Mok7mIkt
 //Fryf2/
 OobRzf6qcoNIvMHMz9+A/vOCXurxFUkEn95w2yOIYfCmm4hN7qVdt3N8fSOGDOaUPaqW2t8knRldkCKtJCW1c4WJrgE/1LKYMGL27ii82p0PDvqzlOUg2ixBCphIP/uI7v/pwhCKDhWCjraIFCVkQmziz15irr05Fkk0ezwE7Q42fEMBsH1Y6pvjwvr8DiNT6GyaooSqTSNyu7sezj9fPux1GXkRjnIOGCjN11PIvztFtrp3pgJwDS3dP/mPYR5jmB2kwmo2HCeOZoI4CQf7aFlgbweTSwNQGjSf32O3SCCXXWLdCyVRSyRbed7Uyry14qtQ4AsacyUAhynHdJyhChFSgrVoVxxhCkNoffzFaWelAOlF5L20JhcrlRNhLdvlALSDwcMKk81HcaBPFaDDyvoETT3iDVjZvLqnZ57pldvtzdxBVygkH8khpBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 5:02=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> The VMA_LOCK_OFFSET value encodes a flag which vma->vm_refcnt is set to i=
n
> order to indicate that a VMA is in the process of having VMA read-locks
> excluded in __vma_enter_locked() (that is, first checking if there are an=
y
> VMA read locks held, and if there are, waiting on them to be released).
>
> This happens when a VMA write lock is being established, or a VMA is bein=
g
> marked detached and discovers that the VMA reference count is elevated du=
e
> to read-locks temporarily elevating the reference count only to discover =
a
> VMA write lock is in place.
>
> The naming does not convey any of this, so rename VMA_LOCK_OFFSET to
> VM_REFCNT_EXCLUDE_READERS_FLAG (with a sensible new prefix to differentia=
te
> from the newly introduced VMA_*_BIT flags).
>
> Also rename VMA_REF_LIMIT to VM_REFCNT_LIMIT to make this consistent also=
.
>
> Update comments to reflect this.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks for the cleanup Lorenzo, and sorry for the delay in reviewing
your patches. I finally have some time and will try to finish my
review today.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mm_types.h  | 17 +++++++++++++----
>  include/linux/mmap_lock.h | 14 ++++++++------
>  mm/mmap_lock.c            | 17 ++++++++++-------
>  3 files changed, 31 insertions(+), 17 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 78950eb8926d..94de392ed3c5 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -752,8 +752,17 @@ static inline struct anon_vma_name *anon_vma_name_al=
loc(const char *name)
>  }
>  #endif
>
> -#define VMA_LOCK_OFFSET        0x40000000
> -#define VMA_REF_LIMIT  (VMA_LOCK_OFFSET - 1)
> +/*
> + * WHile __vma_enter_locked() is working to ensure are no read-locks hel=
d on a

s/WHile/While

> + * VMA (either while acquiring a VMA write lock or marking a VMA detache=
d) we
> + * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate=
 to
> + * vma_start_read() that the reference count should be left alone.
> + *
> + * Once the operation is complete, this value is subtracted from vma->vm=
_refcnt.
> + */
> +#define VM_REFCNT_EXCLUDE_READERS_BIT  (30)
> +#define VM_REFCNT_EXCLUDE_READERS_FLAG (1U << VM_REFCNT_EXCLUDE_READERS_=
BIT)
> +#define VM_REFCNT_LIMIT                        (VM_REFCNT_EXCLUDE_READER=
S_FLAG - 1)
>
>  struct vma_numab_state {
>         /*
> @@ -935,10 +944,10 @@ struct vm_area_struct {
>         /*
>          * Can only be written (using WRITE_ONCE()) while holding both:
>          *  - mmap_lock (in write mode)
> -        *  - vm_refcnt bit at VMA_LOCK_OFFSET is set
> +        *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_FLAG is set
>          * Can be read reliably while holding one of:
>          *  - mmap_lock (in read or write mode)
> -        *  - vm_refcnt bit at VMA_LOCK_OFFSET is set or vm_refcnt > 1
> +        *  - vm_refcnt bit at VM_REFCNT_EXCLUDE_READERS_BIT is set or vm=
_refcnt > 1
>          * Can be read unreliably (using READ_ONCE()) for pessimistic bai=
lout
>          * while holding nothing (except RCU to keep the VMA struct alloc=
ated).
>          *
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index b50416fbba20..5acbd4ba1b52 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -125,12 +125,14 @@ static inline void vma_lock_init(struct vm_area_str=
uct *vma, bool reset_refcnt)
>  static inline bool is_vma_writer_only(int refcnt)
>  {
>         /*
> -        * With a writer and no readers, refcnt is VMA_LOCK_OFFSET if the=
 vma
> -        * is detached and (VMA_LOCK_OFFSET + 1) if it is attached. Waiti=
ng on
> -        * a detached vma happens only in vma_mark_detached() and is a ra=
re
> -        * case, therefore most of the time there will be no unnecessary =
wakeup.
> +        * With a writer and no readers, refcnt is VM_REFCNT_EXCLUDE_READ=
ERS_FLAG
> +        * if the vma is detached and (VM_REFCNT_EXCLUDE_READERS_FLAG + 1=
) if it is
> +        * attached. Waiting on a detached vma happens only in
> +        * vma_mark_detached() and is a rare case, therefore most of the =
time
> +        * there will be no unnecessary wakeup.
>          */
> -       return (refcnt & VMA_LOCK_OFFSET) && refcnt <=3D VMA_LOCK_OFFSET =
+ 1;
> +       return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
> +               refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
>  }
>
>  static inline void vma_refcount_put(struct vm_area_struct *vma)
> @@ -159,7 +161,7 @@ static inline bool vma_start_read_locked_nested(struc=
t vm_area_struct *vma, int
>
>         mmap_assert_locked(vma->vm_mm);
>         if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_re=
fcnt, &oldcnt,
> -                                                             VMA_REF_LIM=
IT)))
> +                                                             VM_REFCNT_L=
IMIT)))
>                 return false;
>
>         rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 7421b7ea8001..1d23b48552e9 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -54,7 +54,7 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>                 bool detaching, int state)
>  {
>         int err;
> -       unsigned int tgt_refcnt =3D VMA_LOCK_OFFSET;
> +       unsigned int tgt_refcnt =3D VM_REFCNT_EXCLUDE_READERS_FLAG;
>
>         mmap_assert_write_locked(vma->vm_mm);
>
> @@ -66,7 +66,7 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>          * If vma is detached then only vma_mark_attached() can raise the
>          * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attac=
hed().
>          */
> -       if (!refcount_add_not_zero(VMA_LOCK_OFFSET, &vma->vm_refcnt))
> +       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
>                 return 0;
>
>         rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> @@ -74,7 +74,7 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
>         if (err) {
> -               if (refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_refcn=
t)) {
> +               if (refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG,=
 &vma->vm_refcnt)) {
>                         /*
>                          * The wait failed, but the last reader went away
>                          * as well.  Tell the caller the VMA is detached.
> @@ -92,7 +92,8 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>
>  static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
>  {
> -       *detached =3D refcount_sub_and_test(VMA_LOCK_OFFSET, &vma->vm_ref=
cnt);
> +       *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
> +                                         &vma->vm_refcnt);
>         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
>  }
>
> @@ -180,13 +181,15 @@ static inline struct vm_area_struct *vma_start_read=
(struct mm_struct *mm,
>         }
>
>         /*
> -        * If VMA_LOCK_OFFSET is set, __refcount_inc_not_zero_limited_acq=
uire()
> -        * will fail because VMA_REF_LIMIT is less than VMA_LOCK_OFFSET.
> +        * If VM_REFCNT_EXCLUDE_READERS_FLAG is set,
> +        * __refcount_inc_not_zero_limited_acquire() will fail because
> +        * VM_REFCNT_LIMIT is less than VM_REFCNT_EXCLUDE_READERS_FLAG.
> +        *
>          * Acquire fence is required here to avoid reordering against lat=
er
>          * vm_lock_seq check and checks inside lock_vma_under_rcu().
>          */
>         if (unlikely(!__refcount_inc_not_zero_limited_acquire(&vma->vm_re=
fcnt, &oldcnt,
> -                                                             VMA_REF_LIM=
IT))) {
> +                                                             VM_REFCNT_L=
IMIT))) {
>                 /* return EAGAIN if vma got detached from under us */
>                 vma =3D oldcnt ? NULL : ERR_PTR(-EAGAIN);
>                 goto err;
> --
> 2.52.0

