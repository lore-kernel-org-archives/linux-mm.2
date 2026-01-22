Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05CA6D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 19:32:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65AD06B033A; Thu, 22 Jan 2026 14:32:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6389C6B033C; Thu, 22 Jan 2026 14:32:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531F36B033D; Thu, 22 Jan 2026 14:32:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 413176B033A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 14:32:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E3CD1A0B25
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:32 +0000 (UTC)
X-FDA: 84360596544.27.F9686CC
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A75FA0012
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 19:32:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A3Ctz1BZ;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769110350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tRanO/ZefSIxQgem+Qjkepyy0HOsMvODV9+whWgkLjs=;
	b=nddLf7ALCJeCe5dOW/cxs2jzA18yAiOQVzLPpOGmCWSooZodBE9g7N5kHJqKdtXRe7zEnT
	ea8LkSNCFShCR+7M98SCbtVNYcncwh+fesxzrO4hSvu/ehulBvsYZ8VKS/nssOodPJ6NPa
	gO9gKfEdPiC9CnKY8opI6eSwSf3cnT4=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=A3Ctz1BZ;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769110350; a=rsa-sha256;
	cv=pass;
	b=jEpjL9/RVXeUaFN+2FSXOHcF1PdT8BWHlCRBUFIUQpggEUBmICJSt7xP2jQnyaheoCVaou
	uvoRKE3E4zbVz47iu31RtHA3K0hr5HxN3C9NUQPoO5rjP1rQtzUVLtPXdqtCRQE0OD3A7/
	utDg4AgmGun2z6fRsxDG7U1GycrVkfI=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5014acad6f2so60531cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 11:32:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769110349; cv=none;
        d=google.com; s=arc-20240605;
        b=FkwN6799g5Btheqg2/JXd4k36lh55lq+GOOJO+3CrO0MYs/HblIbYXqP+/wJ4Eo539
         evyiUqBu9Lorcr5vb9HPcz1a7IIYUHwq0jql8fdYz2pGt8HD902j62ZpnbC0yR0Kr01x
         uxeoTbbQKVa2n2pV+Gav37M4p5vQfraVD7uOVJe9HVPdl+PWCqD3gDSQ+TgBwllg+CDb
         HxVgc0mN7D0t/zTWWkn1nLd58Wmp9CzD1QTITDpo1eLGGN6cmNxjo7MDyyXz8y0D83Vf
         axeVXXyyjzFD4vnGePVsGKRtFU68VozNdJJqJOobtqa+RVdmPj4XK1ACR+cAEZpcSQDW
         OXfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tRanO/ZefSIxQgem+Qjkepyy0HOsMvODV9+whWgkLjs=;
        fh=y2uaHlgIGcAVwmIN8eOD4IqXqoZ4sZb2DOASz7zyUVs=;
        b=jWQ8l8oQoEwqeJv95WWT1U5/zHu2ZvPKyUf6okgfeUsiuQZdfJPNSIKgV0EKi4MZCW
         PvonK4YCQbRK76Ou3M8uqd5NQ7Fyh5Uejb0ObBJUnzRcnTu3m8QNAhR62idkZlW9in5/
         pbOMlzs7du4SrGWlIC07dtHXsGEa0lfPFvIcBvsUgeVOSJrCfjsrTn6UOlArcJiLyjmS
         FtBz+Yp13jTPb5Cbu2dOYmpPYbGmx7fZeZAgLK2Kw3sBxcY9Cqya/8r1U8C9kcCavcRg
         xfkEtJ7MdIW3PIxO7wDgKtVXVp7tKo2l/36iiUsz1WjiCCsvWRv4DG4QONDtb1SAAskW
         yZvw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769110349; x=1769715149; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tRanO/ZefSIxQgem+Qjkepyy0HOsMvODV9+whWgkLjs=;
        b=A3Ctz1BZneFkoGouTkkGSi0pB1LZGAK12ruizL1drnsQK4sdEpZnbNlRBoCor1UCyx
         ICYbCz8YpZ3bZXEtu60SLt0qG6OoWg3DYTXYl9zXpPpiVe0jLFPQV8tzpr4CemMbK10N
         fBzz3eLerKBx1Nan6xlkWHb4ktxmK+/MeN5dESrgUIyiWOZtMgOb3IBO8Reoxpx0Q8Cr
         2cJnn1HQmd+S8e8wAuN47fshe+xiPxpucGrljVQ4c/lLFtwLobHp88hRWpSt9QG6iMSW
         bRmfvyTmOPKIRuv92XMEg4RojupWJje3/E3eOcIf169qLr+zaEtN5oXtM2jMrP/nw6BK
         YOsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769110349; x=1769715149;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tRanO/ZefSIxQgem+Qjkepyy0HOsMvODV9+whWgkLjs=;
        b=iWl16zjesf0lLbN0zOW4PVnSv+8el2toWYlI0V8NufJ4tE4pXUhN0cs6I1AB5DF2eZ
         Hj9gydj+OxV6PndRY7019I9bLaVOEw82p8jyd9OZ6CVrM3qtEKFBpuJMsQnS0XGCKPcH
         /RBk+mwK6Qn9EmS1Ss4vxEzmpTvLWJ7LDu3izYnMCXGeYO2bE3/Y8Hp8hV8FKMFcDflZ
         i3wDkpB+76TOhf5LsH5gW80DPEunsTDeCdzGOqMMs4YGZPlepeOqFr0ICQRUfM1lGj15
         Zz1fiAttF6fFbpRzEuz3hBuThptY4MW7nbjdzIBakAxmy/AyE9+iB1DZ5B8ZRbiSXi+u
         h+2g==
X-Forwarded-Encrypted: i=1; AJvYcCWs94PQ6ODSNhdWMc5XPZdywfTdnX6QoM/EqzIQupsoGkUGKhqYG0NfUr4bnaoms6tt+8/L+wIlPQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5BrvcE7loEcvJ4nkNSbZEh4YhljbpuCX7MlFbJF0IqXdVLqxc
	Qys1+VSQPV0XFnydNKDSH8Qxk+XIoAlYn2lVbZjfOvzcYenr+LGmaM/4ELLpE5IYAyavnjg81gB
	1zWArCXVT1T8UGMjA/I9vqd0ysG77cUmK7oKYFTdM
X-Gm-Gg: AZuq6aI/uw6251h8cqORT9Tf5NxTRLe2d7zsQgf+KvwXwqYJ6ntpHouUxd3E76VHH+J
	DuTQZNpKGqQCplbVvfT17eiF4AdNCMjNhG05v0ajhIDJUEzYP7tnoisKRTNaYIcy33pXBWFnnPO
	Areo0pmQTrUUJUHeMJivpvI0Vw3SS6BXkn+O5f9mqsHciO6KlvRCe/WI1uHBGnHI+38pj8HWQMW
	HjkqLdayD8YGFoDGTZGI2jqnloaaQaIddK6H+FM6BQm5C1IKxatiH+B3sNrAKT+DpdnJsO6cCsy
	Yyqu1gFXb56EHpaMC1Y/YLQu
X-Received: by 2002:a05:622a:a64e:b0:4ff:cb72:7c03 with SMTP id
 d75a77b69052e-502f80e7bc2mr1115751cf.3.1769110348822; Thu, 22 Jan 2026
 11:32:28 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <4703b7320796908b9a0827c3d42d74d11b703714.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 11:32:17 -0800
X-Gm-Features: AZwV_QhkpiCkYsJ1sLl0NtsseibW7fpBYNQRixImQz9vEzoC8AsYXBhTYF4fltA
Message-ID: <CAJuCfpG+H=gRSWuhLL=NHQAQzrbF8Jku2qgRHv1moLPRibk5TA@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 04/10] mm/vma: add+use vma lockdep
 acquire/release defines
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0A75FA0012
X-Stat-Signature: gn9ecgf837pethpe1h646ofik3qydtfa
X-Rspam-User: 
X-HE-Tag: 1769110349-726943
X-HE-Meta: U2FsdGVkX18/PsiCqtjfng+H9Twbnz7JHrRDK0L0Nnlq8L++Y1/WQsYcVfLDQ5N0JUYnigBUkKEz1K1AqBxH/xL8jfG7qjGxbgXSHmPxQiIQ5yrAT2T/XEkdTP1FMmVNtYwJ4U9AegpOIrJg6QzYojxw9/2rckJxJAIh0cXE+HfnpEu7xkaVQLf2C803JleoZrYM3a3RJhRe/n5e1oULNkKMVd2LPfV1U4dHy0cMR8gYuBKFZssjHpOqoZs7M8hizHKFc5lGAddSegyNOcxZ15WIk1BkJCkS4VUQhLBbzK77iNCBSYbzhkK3qPTL8LM7UWd0Qsa5gmEbG6s/zHukkT6RlZIW0K2Rrjo85pmr6Ldpdfwy8UEr7mNpuGD9Ck660BTUIr3pcc2pQbxIvf1zlUiD3ixpp8ByjLtHFgD7QfgNBVQw3N4edEdp15MCrQ5tea8dsvoAzJG+dIp4FRMHUAdtBTvdZ1mbAAuQXjDJjBhFmmFiXD7mG7/oBrE0QP5/Wm0WgU4McfHwifAl82v37Dk0x6lZqmgM39hhJai9qd6syCpzLmh9i1O2K8On49nU9AKCVohpTa9IquogvV6MqeYrKUcz3BXv7geiXjEwUDK4/brrHU6I3zn8FC2uRbxpzFfjgBodJJ7xWdHcUGwa+QFoC6HTm64/QRTjUfke1MWOGtUzHd/acZTY6ZupcCVlQvcQqIhwniZYpcWodfrHL64mrYM2TAmzBorM9tsflduuM+KaWzFkXajP04sElW4Bz4Q9/SnVvZV2dGmOwbSkkGruFn+R+xdk+vb6ofandIWkgBUK/mUzyZr4bXoLDHrf1TSHZb9yXXlJsbyD5VhsIuMgMo3XNWvPnVNY6bX72nMEO8YO34zN9X9lEVTvCgvOtpkPXcPeyRj+R0LDJBKkjDcAjVq4ZAJ5mFoODaz9jMmA0EGp1pAYb+Igiq9yWXWlVZmRO3rvhmxSkaJ3r+2
 d+/6xdJj
 ccLav7XylxSEh09jUnKhWqwit39lHo8vRM8iOUrUKnHfwfoph7MhzZtNm2NloCr5tbk+nkdtKUx4y4lAR/a/JVqXhZnbrURRkWGJ5QX+3GDvvRpS4YQp6JIIswiKFf85XTSMUmgx0zhPKz+Nqi0D6UllEF7/HoSe1lxTsieUMOJWd9JJJeaNjFXbp3oWqZrWwjxsisbmbL8HESLOduJCWaS3S9YcNn7W800Y13wBzQTm2ZEKPH6+xf9R9FaVh6+TQhkBtq8rGcgEPjl/MHGkuZ02nq2nd8PZRDdh3cwZiO9YfZ4VBsQs02bBKD8lUvoDDksU0
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
> The code is littered with inscrutable and duplicative lockdep incantation=
s,
> replace these with defines which explain what is going on and add
> commentary to explain what we're doing.
>
> If lockdep is disabled these become no-ops. We must use defines so _RET_I=
P_
> remains meaningful.
>
> These are self-documenting and aid readability of the code.
>
> Additionally, instead of using the confusing rwsem_*() form for something
> that is emphatically not an rwsem, we instead explicitly use
> lock_[acquired, release]_shared/exclusive() lockdep invocations since we
> are doing something rather custom here and these make more sense to use.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Very nice! Thank you.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 35 ++++++++++++++++++++++++++++++++---
>  mm/mmap_lock.c            | 10 +++++-----
>  2 files changed, 37 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 0b3614aadbb4..da63b1be6ec0 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -78,6 +78,36 @@ static inline void mmap_assert_write_locked(const stru=
ct mm_struct *mm)
>
>  #ifdef CONFIG_PER_VMA_LOCK
>
> +/*
> + * VMA locks do not behave like most ordinary locks found in the kernel,=
 so we
> + * cannot quite have full lockdep tracking in the way we would ideally p=
refer.
> + *
> + * Read locks act as shared locks which exclude an exclusive lock being
> + * taken. We therefore mark these accordingly on read lock acquire/relea=
se.
> + *
> + * Write locks are acquired exclusively per-VMA, but released in a share=
d
> + * fashion, that is upon vma_end_write_all(), we update the mmap's seqco=
unt such
> + * that write lock is de-acquired.
> + *
> + * We therefore cannot track write locks per-VMA, nor do we try. Mitigat=
ing this
> + * is the fact that, of course, we do lockdep-track the mmap lock rwsem.
> + *
> + * We do, however, want to indicate that during either acquisition of a =
VMA
> + * write lock or detachment of a VMA that we require the lock held be ex=
clusive,
> + * so we utilise lockdep to do so.
> + */
> +#define __vma_lockdep_acquire_read(vma) \
> +       lock_acquire_shared(&vma->vmlock_dep_map, 0, 1, NULL, _RET_IP_)
> +#define __vma_lockdep_release_read(vma) \
> +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +#define __vma_lockdep_acquire_exclusive(vma) \
> +       lock_acquire_exclusive(&vma->vmlock_dep_map, 0, 0, NULL, _RET_IP_=
)
> +#define __vma_lockdep_release_exclusive(vma) \
> +       lock_release(&vma->vmlock_dep_map, _RET_IP_)
> +/* Only meaningful if CONFIG_LOCK_STAT is defined. */
> +#define __vma_lockdep_stat_mark_acquired(vma) \
> +       lock_acquired(&vma->vmlock_dep_map, _RET_IP_)
> +
>  static inline void mm_lock_seqcount_init(struct mm_struct *mm)
>  {
>         seqcount_init(&mm->mm_lock_seq);
> @@ -176,8 +206,7 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
>         int refcnt;
>         bool detached;
>
> -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -
> +       __vma_lockdep_release_read(vma);
>         detached =3D __vma_refcount_put(vma, &refcnt);
>         /*
>          * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> @@ -203,7 +232,7 @@ static inline bool vma_start_read_locked_nested(struc=
t vm_area_struct *vma, int
>                                                               VM_REFCNT_L=
IMIT)))
>                 return false;
>
> -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +       __vma_lockdep_acquire_read(vma);
>         return true;
>  }
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index ebacb57e5f16..9563bfb051f4 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -72,7 +72,7 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>         if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
>                 return 0;
>
> -       rwsem_acquire(&vma->vmlock_dep_map, 0, 0, _RET_IP_);
> +       __vma_lockdep_acquire_exclusive(vma);
>         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
> @@ -85,10 +85,10 @@ static inline int __vma_enter_locked(struct vm_area_s=
truct *vma,
>                         WARN_ON_ONCE(!detaching);
>                         err =3D 0;
>                 }
> -               rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +               __vma_lockdep_release_exclusive(vma);
>                 return err;
>         }
> -       lock_acquired(&vma->vmlock_dep_map, _RET_IP_);
> +       __vma_lockdep_stat_mark_acquired(vma);
>
>         return 1;
>  }
> @@ -97,7 +97,7 @@ static inline void __vma_exit_locked(struct vm_area_str=
uct *vma, bool *detached)
>  {
>         *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
>                                           &vma->vm_refcnt);
> -       rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> +       __vma_lockdep_release_exclusive(vma);
>  }
>
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
> @@ -199,7 +199,7 @@ static inline struct vm_area_struct *vma_start_read(s=
truct mm_struct *mm,
>                 goto err;
>         }
>
> -       rwsem_acquire_read(&vma->vmlock_dep_map, 0, 1, _RET_IP_);
> +       __vma_lockdep_acquire_read(vma);
>
>         if (unlikely(vma->vm_mm !=3D mm))
>                 goto err_unstable;
> --
> 2.52.0

