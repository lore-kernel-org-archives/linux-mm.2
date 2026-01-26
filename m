Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB6FC88E47
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 05:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52B5B6B0088; Mon, 26 Jan 2026 00:36:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9B26B0089; Mon, 26 Jan 2026 00:36:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB916B008A; Mon, 26 Jan 2026 00:36:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8A66B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:36:34 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8939E8C256
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:36:33 +0000 (UTC)
X-FDA: 84373005066.17.1C877DC
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8DD44180004
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:36:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CsS+IWYK;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769405791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6xZq7LrfvfhhMsxNvjZUWzjYExAB/8BW1cOYBT9G50=;
	b=2F5vXXHmCoNn2bhWVAnrHFFSDeMiodML5oV2DfENQPsmsBLRC3GrcoKfRCdjU759hYXyVz
	7lMQFJx9+zs6BKlRhynAtGBdK3+aBFWbCEKeTXnlvx8/OPmykK4UxjyOO8/t9YuJymUesT
	UB9TGHnAGYuhtOAFPpkC/vsmNhH3koU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CsS+IWYK;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769405791; a=rsa-sha256;
	cv=pass;
	b=EF/WHlJiTVt9spghE8oGV4/gle53UkrBFlKRMG80Yxop3coraFyQILvAMjzYXb81l/YJSi
	y9RQDtQ+6kQ6U5Z2PUJsOtJGiVNmMdSxaRpWJsWoJ8t+x/CUp9LQBF1YXbwplwlqIurt5z
	ajGmZpSHjbb37c7jVT8U+WwcIxr58wQ=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50299648ae9so697991cf.1
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:36:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769405791; cv=none;
        d=google.com; s=arc-20240605;
        b=hOa7F8YhYy5HjbbHqKwN7kIp4UFMakNoQPpkuiDjO2Nov7G2Iu6nk7MBisG6108mxk
         MPeKNm1zw1bdIciYEDsFY/vR9RAhdvhTO7H05XKmG9Nc5sIpzT/s0mwosD5eap8eEfdR
         wcyVDdAjriiJQAB52GIJCpd2uswV1DVZUWUWt57M8JZt4oenOZala7iUM/e39rbHIJCh
         oL91PlUKChBW534TIkLriXbJDzvLFRk2YFaacYLxZs2r8WlFpr/BaelEkeaDmJTSyABN
         enFavtaWi6k/xHc6pVbk6P27s4iYfp65gFYiueoOEiYiYUoibl5oiN3Mn9IiXUsn5kcN
         5Saw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I6xZq7LrfvfhhMsxNvjZUWzjYExAB/8BW1cOYBT9G50=;
        fh=XseuT6AF2ppF/CKmHP1SzL61dBausUTuUQgu4Hc8Hrs=;
        b=g37SqxHEI0wwjTg5m0kexrYsYyKh+D/OR3uyU0VDAJKBJC8XDrmnjuU7bFC4B8psoJ
         TdrhNfNaSxMrm3I9fjEZRs/OB9Cb3+EufwghCUUmczg+9YXkZCOhH5reHtf3D/YNrgOZ
         4R3WZ/2ZbPHB2A1p06UqrzhQPelR/TBJBFioj84Pg0O5M5BH5ZG8W/u00HC6BYLNjFz5
         k9/8jdkbJClT3wDEnXAsLVzcLufuLxW2wGDL0+kBk8vIVCm8lX2aD/68zsy7/+qaxnD8
         TkB0KKY7JQDW2CFwhBAi4kfhzYYMBy+v2CNcOwnq2PprlXZ/7xc6LYNEx1Z2xtASZ2eg
         7FBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769405790; x=1770010590; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6xZq7LrfvfhhMsxNvjZUWzjYExAB/8BW1cOYBT9G50=;
        b=CsS+IWYKH8OS++AFk3u8qSBeQIslmWJ+Z+G7Uvtc5SBiEQXhgytJ+60k5WK5LTz1Gi
         TJvnVhuQCsXPgzXmPYyf78wJLeaMi7ajMrQq+gDAbW2LNxIn7xCmrr2ik9jiZ8yuV6X9
         dq/KG2wzmN76P+zbFWJY+AjUnC5SDoHCwwJhRW/fzTozYkL+ThRYfMyhpO1z/l+5ssub
         TpM16LE6+UMu/cnhOx01BDBY5/VX+ijDamH0fPwVNJqlUYsLqgEUX0pQJYjoux36b92D
         waNgENjgI4TCbUrqjhGr8r96VXrC7FqvR44pDsRYYZTBJ+q7KIe5fU0q8pqkA9zaGYio
         np5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769405790; x=1770010590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I6xZq7LrfvfhhMsxNvjZUWzjYExAB/8BW1cOYBT9G50=;
        b=YLjEoePikT69ijJGd1sBL6eV59s6ShCDcnZ6kLKEsmbvCSd4YJ+P+hlI5uwWBPeZ9e
         W3w4GG5wdOOhUN6mADAvIXfQWwQf93duOYn6QZ6XalHj0Q7VF7NZo3NyewT4Srr9Uk+8
         8Uk7lhItT0ND2fE6ojmU8sZuhLsJMjORMQ1zAByH6jsl5TN0dbBHv99nav5UUGAvDWz0
         LTWJ+pAihqiz0B63o9DZVvYp8JqjU4rHgBzU0W8iIm2kvY0Zx1eO6M8+VPLDXMqxvB8K
         PP4oAnSM7l5TY7bFQfn4lkUtCiBNILhE0/hxq67YLIgN+YW0HKueFdK1wcfZU51cMjrr
         Y1kQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4Ih2i+GWKQ7bT1EvcR7HME4oCuNRGQJnTro8Sxl6fuKQ2/TgWzqQ+zVYAfP+FY2mDLUtbCvlV8w==@kvack.org
X-Gm-Message-State: AOJu0Yx32gT6UsfU5JD1YSllIb5PD8z/X6WNHNvQ1LkvTehFEYm0apjG
	h++GT4GdR7xfsPv5GsLHzgKC7cMSH5a6cY0QOphCL5QSYZRr5G9Q+4looCsHjvSl0B9htzqu6Ov
	aWxzCAnGa/4SdNoWcvhLyDJ2YK9w/n8hnJpEm/m9i
X-Gm-Gg: AZuq6aJB5iuxhNYvInkbfn+0/c3IpB0EpVY/VNRbes1H0IWRQUEq541Gkr8rI8igFqN
	juOuJw3gDuau5H4obTZbjSr0hZyLfFQ1YXz8Wg2YORfqDMDqQtvGBHCvpLIUiRb1JoUSc7NmnLa
	B7zOG/63KkUaxITH62wSE2dEG3aQAdMlZgOTmM/caF+UIfSHp2qXwGm5xUczodpZkmhlvFoGNmW
	PLH2DxQBjtrNnuP+OFd3rTUofYYn5rIQEGy1NrVK5SPhZu2x2iJatyjGLQZE1+Axj3BlByIOmg3
	OqDz
X-Received: by 2002:ac8:5f93:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-5031428fc37mr7858901cf.7.1769405790260; Sun, 25 Jan 2026
 21:36:30 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com> <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <32053580bff460eb1092ef780b526cefeb748bad.1769198904.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 25 Jan 2026 21:36:19 -0800
X-Gm-Features: AZwV_QiN0QWWeFWiJptYH_T4KdRYx16ZLo4mjaKA-kzllU5XbwC19rarlh3QeBo
Message-ID: <CAJuCfpH1u6N7FXi=2Gn+WWDW5M5reupQVkKebGqRcbr84oj3HA@mail.gmail.com>
Subject: Re: [PATCH v4 03/10] mm/vma: rename is_vma_write_only(), separate out
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8DD44180004
X-Stat-Signature: besu6kq8uzecedtzrp4ukcm4884ngzfo
X-Rspam-User: 
X-HE-Tag: 1769405791-855913
X-HE-Meta: U2FsdGVkX18pH5PCG0DxCYinSHF11xGCy9ErC+tKWEc9J3fNRQsT/KYBgaTYbfp8HenTuJaLcdBHIcSf7A7MtKsF3Co/XCKhf/H1KKKG6g2uUvTc1wBCAoQelMmyiKehhGdV4s7pFxkqxIfbL0XzK96EU9g9/alavf5nctlHhRI5vRCmpLwR7+oeGmvzVqlp3AwHA1o3vR9/KHNBQk2N3g4IcLaw2MsUdUHcn7AIgBKO9Zd/NY4o1YxqsTSbaHEfRu+lIcEoGZj4yaNSsxa3zg/7ZTT3UtGQqshXi4kxTSOiswHHzouDgw2ndpuYfrA1b1CHC+bq/jwn+B/i2nPgFGJx60gpCEnY5ERLf/mZhxyBSliJU2fw8MSa/1pGltuBkz/PgW2on5r5iL0/qYdkreKwVi1eHxl6ejarcalFqM2PKqrAzuWmIagxHdgl4LABu0nzIWvpwTTyf21dQzd5aiTIYZf0pAKyaiNHDPXDqqFSKK7wESYL44xX8NyLto+9zhxMNEwpiUrmijkk4/6J6YTb3ekGShjwxeENdXyt/6M4b6+M1iK5P2/WOsGy/QRRN0c+icZsAIw945ffMVOscuqecv1ZRR7ZHXZV9lYm1n0DKHJZUDCL9kVhirLcb4pjwFiyubENsWHE9YhRFmRCgSyJBotaY01pXvjQCMjb+LQfA5JJMpCSOE8E8LbGuXD68P3bb9yLUgZQa8nEtGOlq3vLSQoGmzZvtNyDsB31cz67uGsYO/mFAKEFtMZsRprpL9JKdNoWLTCFovkpI5rQs8P7cO03+JUQZr3bf4nl9/Ny75k6cPKr28lSeqPems5d4J+/nNEMqwdyjEQEUkJKS910XfIGgzn2920D0G4hYccSZql/TtSFCJz7HXkB0oi0oalimsR0o8OBzoTpHHlTH28WzcU/IUWOjmXmMQBibUR7cWF0X48qAumagwYWPoJ6wsDbcaz1YgqVZqrsfTh
 mYFDElVB
 ChhOFP/uFXR5S6RIavVNkTp7J9/HAbim+OZ3tF4NhI+pUge7e908u+ardlZav8AhNoXLA0EfE9t8fNIT4flW10CayZMYPn7zC2zTBsx+Qhbab2d6T0x2VMAjODG8vPWaiJ634Nkt0uokfK40Q0Tt4hHlDxy9yzRy9OgiOwUDRObZzDhzevyZj5vk/bGl548Pjqc0/kTkXFKl9Db4BJCtNQiFDYmmjW/9mp74O3M5jOIPNqBPKvm+OMIIrABegIlsfxI6IYcoKPOJQAZ3w5LODChj7Mgkw1PhVayxSlWghoXIfqVIyFosGxOm9YwB77R/wuebIMJvjItaf81/dPe2sxopa3H/HgI1+ULfkS9wGGFAaiUIN4mewlETNqc9NYBFHqe1bJOTQEIou7NS2J/8GX+3GGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 12:12=E2=80=AFPM Lorenzo Stoakes
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
> Relatedly, we use a __refcount_dec_and_test() primitive directly in
> vma_refcount_put(), using the old value to determine what the reference
> count ought to be after the operation is complete (ignoring racing
> reference count adjustments).
>
> Wrap this into a __vma_refcount_put_return() function, which we can then
> utilise in vma_mark_detached() and thus keep the refcount primitive usage
> abstracted.
>
> This function, as the name implies, returns the value after the reference
> count has been updated.
>
> This reduces duplication in the two invocations of this function.
>
> Also adjust comments, removing duplicative comments covered elsewhere and
> adding more to aid understanding.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mmap_lock.h | 66 +++++++++++++++++++++++++++++++--------
>  mm/mmap_lock.c            | 17 +++++-----
>  2 files changed, 63 insertions(+), 20 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index a764439d0276..294fb282052d 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -122,15 +122,22 @@ static inline void vma_lock_init(struct vm_area_str=
uct *vma, bool reset_refcnt)
>         vma->vm_lock_seq =3D UINT_MAX;
>  }
>
> -static inline bool is_vma_writer_only(int refcnt)
> +/*
> + * This function determines whether the input VMA reference count descri=
bes a
> + * VMA which has excluded all VMA read locks.
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
> +static inline bool __vma_are_readers_excluded(int refcnt)
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
> @@ -138,18 +145,51 @@ static inline bool is_vma_writer_only(int refcnt)
>                 refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
>  }
>
> +/*
> + * Actually decrement the VMA reference count.
> + *
> + * The function returns the reference count as it was immediately after =
the
> + * decrement took place. If it returns zero, the VMA is now detached.
> + */
> +static inline __must_check unsigned int
> +__vma_refcount_put_return(struct vm_area_struct *vma)
> +{
> +       int oldcnt;
> +
> +       if (__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt))
> +               return 0;
> +
> +       return oldcnt - 1;
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
> +       int newcnt;
>
>         rwsem_release(&vma->vmlock_dep_map, _RET_IP_);
> -       if (!__refcount_dec_and_test(&vma->vm_refcnt, &oldcnt)) {
>
> -               if (is_vma_writer_only(oldcnt - 1))
> -                       rcuwait_wake_up(&mm->vma_writer_wait);
> -       }
> +       newcnt =3D __vma_refcount_put_return(vma);
> +       /*
> +        * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> +        * their reference count, so wake it up if we were the last reade=
r
> +        * blocking it from being acquired.
> +        *
> +        * We may be raced by other readers temporarily incrementing the
> +        * reference count, though the race window is very small, this mi=
ght
> +        * cause spurious wakeups.
> +        */
> +       if (newcnt && __vma_are_readers_excluded(newcnt))
> +               rcuwait_wake_up(&mm->vma_writer_wait);
>  }
>
>  /*
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 75dc098aea14..6be1bbcde09e 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -134,21 +134,24 @@ void vma_mark_detached(struct vm_area_struct *vma)
>         vma_assert_attached(vma);
>
>         /*
> -        * We are the only writer, so no need to use vma_refcount_put().
> -        * The condition below is unlikely because the vma has been alrea=
dy
> -        * write-locked and readers can increment vm_refcnt only temporar=
ily
> -        * before they check vm_lock_seq, realize the vma is locked and d=
rop
> -        * back the vm_refcnt. That is a narrow window for observing a ra=
ised
> -        * vm_refcnt.
> +        * This condition - that the VMA is still attached (refcnt > 0) -=
 is
> +        * unlikely, because the vma has been already write-locked and re=
aders
> +        * can increment vm_refcnt only temporarily before they check
> +        * vm_lock_seq, realize the vma is locked and drop back the
> +        * vm_refcnt. That is a narrow window for observing a raised vm_r=
efcnt.
>          *
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> -       if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
> +       if (unlikely(__vma_refcount_put_return(vma))) {
>                 /* Wait until vma is detached with no readers. */
>                 if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
>                         bool detached;
>
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

