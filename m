Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC90D6CFA7
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:03:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1FD6B0367; Thu, 22 Jan 2026 17:03:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A016B0368; Thu, 22 Jan 2026 17:03:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A5F06B0369; Thu, 22 Jan 2026 17:03:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 764696B0367
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:03:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED73013D87F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:03:07 +0000 (UTC)
X-FDA: 84360976014.03.91E96C7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0131E120010
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:03:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z1kJWS64;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769119386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TUFswC7WALgWvhHt/vri/diAlr1YiuidCkTY+195eFs=;
	b=vj+QuH5+mdFkbje5CeUJ5lnoZRwsk002e4LmDA//mPOLAHBCFUt/XSjCgot7BpnK2tq8vF
	wTV8uILPqwgfXGLDAzfizPBDEn5pSdy9xrm7Otbd0d85m2vzWOc5jAUaedvR2C60ykVksT
	JW4wiVbOm/CVApjSSggfulcv9zkjE4I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769119386; a=rsa-sha256;
	cv=pass;
	b=Z0D8OWafqxmlSb9uF5luv6Wc3C4/+lygaXq2dcM95FnvlBS451sgPQVq3OtF03+mopKkX1
	xsN951Tx0H3eWygxU4n6ifG1MNe/MPv+bW0uigASBfeqB4BZlasaL3mhnyECgjOK6HiQju
	+D5uEKJoT77Ipba6q1C12RHLhg1rCrA=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=z1kJWS64;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-50299648ae9so69651cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:03:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769119385; cv=none;
        d=google.com; s=arc-20240605;
        b=lQjZKWTJVdNShSHPrRVaaEdCffK79hHYQDXmWeSeGAjABVPA3lKEt8VWKLQwNEQEpb
         ze57h7BPSHShWCbSIkIsR1A/ZOQkfVS3uTOwCWXMokXtozkjpxYwaMagdc9gYJI/Gtz1
         uT2GzOOCFzdF5jTnVVWhhBgD9GYof+iuVi2waHh39NRaetXWrwyae74cP31Zsrlc2AOv
         SJmgcRnIqwse9deqIBwwUpSRjjMFfZgXBEfDaU6HY74xKbcRVNxGf/97AolslnFY3HQ7
         0+Voxb4rVhpIkruzgNCKc+Osq3SGKiyeUMj3UGeVmiFxrOjErzxLYsyJOGiIP2slXE2K
         2cNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TUFswC7WALgWvhHt/vri/diAlr1YiuidCkTY+195eFs=;
        fh=Xk3NishxZcLEAQuD5FxvZErIU5/qUZME4s4dCL1wagU=;
        b=hlb36bo3p63bp1eE9xnkKWVk6ycujLUkC7U9uvh9ZNCbGrsFFIYJEpWwmkccsEXyMY
         qnmZeqdRnUthOVaZ84mPn/N5jkex0GnjPYSS9px8c/rbn8inXVg9zmsVQ7I7PoS9wCbP
         ONWxhikeUIxqEpJckv2kVoQw683w7KanN3cfzUNu9vhNK0B9zxwKeYhSNEyuc7PVo37X
         NUWQ/boPX4UUG/vIpgHsCACCfRL6O5LPq0jQlciQeFt8BpsTkg2SX6ibitOR18FaHyRR
         9nCUXa2nrvvSy8OmoU/M9beaeUWSTCyhVUyUMMSfD2/boEClxGfbPhb/29pOTFQxqqgs
         K9kQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769119385; x=1769724185; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TUFswC7WALgWvhHt/vri/diAlr1YiuidCkTY+195eFs=;
        b=z1kJWS64oRp66p0nhD+bDLYD0DnDKepBJ8XtaNAQpDR91Bct/1OF30eAE6/BCbNQgb
         hhtTRt3dVsVp1ouRJ+PRMrbkI/ExM4s6k5YwXJDrttpVfueB7T1qDWD5U96OqUwmGo90
         3rrGzYU+euKq04JTDkrc0Y+TvRwtAW+fTIiA/pPuaspBjbsjGQ6qsEUq3GN/bk7P+kZf
         ZexvQX7lamXhEeBz8QNqw4I/lVHmDdwSpcOdlRitzEYn486R547YPahcMbQ2qnUmnLAd
         8vzj3Uy0B8rKT0rdyy7VHT1z2VMbT0ZUj6XyvkYdwY7jH/Cp72gSrKxD8x62BDmos5oK
         ZUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769119385; x=1769724185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TUFswC7WALgWvhHt/vri/diAlr1YiuidCkTY+195eFs=;
        b=RyN0iSWJXKmoX08NTgRXa8oI7/V8J+UyXJhR7V6JqsZwGUlUSEprA+9vaG4FuzqVVD
         gtqmalyDlV0+m4rqSeNt3dXOIe4VXzxZyExhZSxyVmserONZ+VycqMMS+njtPCfQeU7b
         jihg7y6OetEyqIZRdUUm6Fpve40iLKfcmG1Je4LMnAwTeXC4aSuc0MqpYfvwSMXkKfaz
         9fQIqWFI3shHDvEfD8qA2A5TCKH0cbidpgSPSJARob2YtUjlAWruiQyAJ1sA2d+RO8za
         Xu/Y+JA3obJDu2ZF0E2B33AgJeNuZKRSlEb0/9abMGz0ZesrRYcFJUJSG/yTjGAsLCtE
         lWIA==
X-Forwarded-Encrypted: i=1; AJvYcCXUPZcMFq8VPDqfFVEn2IZCOLnt0JC4bfcCQUEC9H9y6cg2JBMBsk/OUXxUHFNZHD3bkZ+h1HahQA==@kvack.org
X-Gm-Message-State: AOJu0YwNayrDO1inzOzWip2L0gNUY9xulWdGC7ql0efYnvF+Fi47FbTE
	DCPXVK/xKGIdQGFJV5RzwZt7toahcNYHJE5o5azr79MiUhtlfYfC742Wfx77cmc+NKNl4EWWZLn
	IYx95FCSy/Ql+/fY46an0H7p8TVif96C6Trc9dri2
X-Gm-Gg: AZuq6aLB6kAcEUsvw6qFuP52EbLOiXoVVWT0W0ptS1NDP6d9dHkr9iX67VuN5D/jWtA
	9WY2hcSR0qYnz7ZELAl9jNzTJWDpC2Kv2DaSA9Vf1vWGhB21IRceNh+3LsTtNel1d695RtCLIPE
	gTJoPEOiyRotMHBDdRfu4Clexw2ZBzpTIXFum9xA7m3BzjdiDbKPeZlSnN4DG/BWX8eKWVqEYqO
	PkWsUZ0fINYLD/ogTsEpXmZq6uM3EYOG2LZ+x0u32WotiuJHlOCXEJjLVFieWjK3HSPU1kJNdR1
	y79QLvkM0GRngSUz5l40k3oM
X-Received: by 2002:ac8:7dc6:0:b0:4f3:54eb:f26e with SMTP id
 d75a77b69052e-502f8d571admr1046721cf.1.1769119384657; Thu, 22 Jan 2026
 14:03:04 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <fbaa0ab025c1f345e559df2b1045b223663806ef.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <fbaa0ab025c1f345e559df2b1045b223663806ef.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 14:02:53 -0800
X-Gm-Features: AZwV_QiH7uTftGNaxq_cn6-c5aA0bWdwkSr5uV6ZePFQF00zb8M9zgeuI3MJ7I8
Message-ID: <CAJuCfpG_5Do+Qajtnhbv9uK+BssDh7NpXYGzfbKBJGZgtiKF0A@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 09/10] mm/vma: update vma_assert_locked() to use lockdep
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
X-Rspamd-Queue-Id: 0131E120010
X-Stat-Signature: 6qfi5zmdnmn7qcd84ojbpqn8z3q1zst9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769119385-479927
X-HE-Meta: U2FsdGVkX1+13Mg+y/l778cklrkfv6NUFLzWd2NvIsujVZkVhDz4GkpohbjRlGm+5muhd3W7j0VyuzZ+aNqOZ8FKUL4kuFhiBO+oA6q4UjrLHA8nXcpwkc05vctZ7+LxpsPdbz6a0c08M1QeGfey+3Un0KOzuTGHH4748F/HonaePHeNijIgz698nOZ9wuKZzwtZzMRs1K6gtIN4lcs0kbCeYSk7CexWQ2ITCa7FatTjWiPz9DeAVQytHkISF+uApLNO+hSyJsd6wC7eBQUMKIJ0u71ag7ryLUk1Ct/7/Skv3yL21mog6DurgVTNfUYqGWH7AXZhpzrFSkdJiKg+jj/HnAsICQWDQsVO115ZderenDmwe73zoUwPgjFZOWoA/b2jSDK680oYdysapZVdl/+Il7DrsYQb8sAAgAsHd9HSk6e8e6lyEG6R7q80R9GXmbw+g6vaJtQSstJEUsjwX6+SVx/f58HvQNPUkCgFWpksZ6RPFuFpCzLNVRVtxY1R49ANfwe5ANZx/czCKZH0zewbKkHlTTVDGjHgCVSraYdOPTCioQE18Kv+itfFn5tMwtX+iD4u1hLgKqMpE79+jDqfh9AFVl9fkUUD+jzhzLIxETvlKiHWIz4lXkCJbdqXmON4Xd4Sv6DS26HL4d/dGuDzNyBBmn60D7ZzGWOdrEYYIGzbZASK2a2m4/WLLLnb70bNUnAv0Z6W6rPa8YeJhCgXcDzexe3UoIIEhiyGAXnQPWXZyqN88N22m0spH5aMSjwEC2Od0vSwODAm/oTbua9+F1MibgBeXBOLaJcE76x/MyGGThX2HtiYyyDk/ikHpbxoQVnIk6edKgnQOWjxsRWv8dekXXSutunNwtXZ0jUzNESK/5LeUOTlDiKDEQvu7Nt8zsJivT03WUhpMaat4XmCvTKm6rlnC/eJds2hb3KrpsUckr4koxNocRJgkiIVhAe949xco4mr6XYPSty
 6iGID+Js
 CIdxSLQ3MUs6ptuX3ZSzf0rY7RQgsaDaWkXHxu1MKOf/ol/o/YRSDYsBL0r+nFq9Yol1yI2lJbzwxxL8s0W/bQNaO9xTjUHuEBSElqVJIirDmBRyPClN1bV+FxYC3Ayhwfc2EWR2DT5NBsObkm5N+H8BG9hWiC3ga2NXfKqcDSUW0TucgvxTxb807cFRVdCq+dKC5wKMt8lnYHkS5JMEK0JssTvrFA0MxSpR5maB7CDkzWVfWtZBHCqkzIdx75jzZXR2cEJrNpQFhXAufZkfGkMCofjWsUMmdPTZEROdBkwVrwbFiMlAEEML/rQhewwy3HD0AZMVhzIvmRw4jVYjKYVMARSL8nWiNE7yO/WY16B2JrjddmfZApwwnnpEI+738wrkmkiWqB4z5oZH05F9JS2jfCQ==
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
> We can use lockdep to avoid unnecessary work here, otherwise update the
> code to logically evaluate all pertinent cases and share code with
> vma_assert_write_locked().
>
> Make it clear here that we treat the VMA being detached at this point as =
a
> bug, this was only implicit before.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Looks correct.
Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 42 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 39 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index b00d34b5ad10..92ea07f0da4e 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -319,6 +319,10 @@ int vma_start_write_killable(struct vm_area_struct *=
vma)
>         return __vma_start_write(vma, mm_lock_seq, TASK_KILLABLE);
>  }
>
> +/**
> + * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
> + * @vma: The VMA to assert.
> + */
>  static inline void vma_assert_write_locked(struct vm_area_struct *vma)
>  {
>         unsigned int mm_lock_seq;
> @@ -326,16 +330,48 @@ static inline void vma_assert_write_locked(struct v=
m_area_struct *vma)
>         VM_BUG_ON_VMA(!__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
>
> +/**
> + * vma_assert_locked() - assert that @vma holds either a VMA read or a V=
MA write
> + * lock and is not detached.
> + * @vma: The VMA to assert.
> + */
>  static inline void vma_assert_locked(struct vm_area_struct *vma)
>  {
> -       unsigned int mm_lock_seq;
> +       unsigned int refs;
>
>         /*
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> -       VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <=3D 1 &&
> -                     !__is_vma_write_locked(vma, &mm_lock_seq), vma);
> +
> +       /*
> +        * If read-locked or currently excluding readers, then the VMA is
> +        * locked.
> +        */
> +#ifdef CONFIG_LOCKDEP
> +       if (lock_is_held(&vma->vmlock_dep_map))
> +               return;
> +#endif
> +
> +       refs =3D refcount_read(&vma->vm_refcnt);
> +
> +       /*
> +        * In this case we're either read-locked, write-locked with tempo=
rary
> +        * readers, or in the midst of excluding readers, all of which me=
ans
> +        * we're locked.
> +        */
> +       if (refs > 1)
> +               return;
> +
> +       /* It is a bug for the VMA to be detached here. */
> +       VM_BUG_ON_VMA(!refs, vma);
> +
> +       /*
> +        * OK, the VMA has a reference count of 1 which means it is eithe=
r
> +        * unlocked and attached or write-locked, so assert that it is
> +        * write-locked.
> +        */
> +       vma_assert_write_locked(vma);
>  }
>
>  static inline bool vma_is_attached(struct vm_area_struct *vma)
> --
> 2.52.0

