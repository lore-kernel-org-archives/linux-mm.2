Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC27AC88E42
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 05:15:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3C16B0088; Mon, 26 Jan 2026 00:15:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D81156B0089; Mon, 26 Jan 2026 00:15:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C63F26B008A; Mon, 26 Jan 2026 00:15:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B47856B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:15:18 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4CF7A1B0766
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:15:18 +0000 (UTC)
X-FDA: 84372951516.09.BC24C09
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5B4881C000F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 05:15:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BS893kqk;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769404516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQgKsOGGJe8JvFHFZNpCVI2nLJuIsUEI238/G0I8xU4=;
	b=wou+zgAGW4R/lRZWPzNqSypDakJK2rKnblICz4g5zkKLuGCl46PACeBzMRoG4YdMOPtpQg
	Re4jYEw+rbdeU6gQQvgGAJ8Plkmv4P01Ld6RuG8XGRXIbMM2kyPCbM8VcSqbkvlu+vhm8c
	Pft9XiYK4BjHX7cW9xkwbXyv5n6m/lk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BS893kqk;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769404516; a=rsa-sha256;
	cv=pass;
	b=jvBpHIBi6RujKjLjgDO+ueKkhLrlOk0LT5OVqiMBopjwBzI6aCK7E+02mER5rBwNjZ7xoL
	qiooP/w+htM4Y61QMA6CRiP/YbLp0Gda+JNoLjWYtctArpMzd1fdkzQmLLTVGLGzkQEBHP
	9sQXQXlfmOOk7uFGO0Sje9FuYJRYi10=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-501511aa012so810861cf.0
        for <linux-mm@kvack.org>; Sun, 25 Jan 2026 21:15:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769404515; cv=none;
        d=google.com; s=arc-20240605;
        b=kgjg/wZRNmYlJfDnndZ+zIjyRWtXeZIK6IUDDzsGyg6kAUGv6w84ER1g/IWJa+N/oL
         itM5ksS+5Pg3Gu/oVqpkQVh4Ae3T36Bsz9pYV5ZU23ke1a69QfiG2DeYaTyUAKPeRtMS
         q3hYMf9stUO32nDfK2fvRiSe1ISrE3cceaLjrlY5P7LTjAQ4uY6llEW8O2PcGtDJcbWa
         rbgGou8/mUgNTP4CKrQoLNP6FBxLpKNyj9RQh9G8k2skXg0FefOUEctGDVAiUKdD9ERD
         UoO+UvZPzYz53HnF5tT+RE6mz9QdKow3djadIZ6gGOF43DaRDGGDymJT0NANUOJoyJIJ
         Q1mA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mQgKsOGGJe8JvFHFZNpCVI2nLJuIsUEI238/G0I8xU4=;
        fh=oSMFqcHPnRzj7KoQ+JMfoouV3VzvY4Ckcc0Q/rmcoH4=;
        b=lYQBONx3OQ4Sk7pUU/KQ3WgN6uJ3B3RBFxRMTk632oLSiU8Z6/RD3gfdcSv27w9R67
         MTIBXtt4s3YjrcG8ghURCPxPwEVqV/lSsv/FsxxzyG3nGXSrSgNdW39MpZAn/PDinuT2
         YDzdw6+m4s21jbQlz/VhPjOIiHB47pZa7SI/+GUNBiu04h74mKVphPNJXzf2ASI8IfOT
         aIfNKWlirWW3HdetjvZyC2qn1q43nQWk1wqekpWHUqmA/UvkfSOXmtQFR0R5s7pzun4B
         4hmXbxLio/EeGCdbjwdytpTN/iFYxW/pGkCFPnsbMtJs1X3deHm9G7/AzXoJyRfpU81w
         PMkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769404515; x=1770009315; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mQgKsOGGJe8JvFHFZNpCVI2nLJuIsUEI238/G0I8xU4=;
        b=BS893kqkSP3wS14fbChMLnW6DaT2o81S8y9bAG5aaSNI6ggzWto1V2BIXZD2xufAJ1
         ix2ukwZG/zndRCG/oAfamUSDyxRgChmDuon6WOH7yVpn8VhIjsoFe2OW55Y/vUGMD3zw
         yogEB5fy5H5Z80mg8EdxW6cOeLpblT2aSoMgTurrK0mirlhxwwn2nGV+Z5sSn//htnHD
         GDE3zshpHDMtePm06pzEI22+BNbVawN6xTf3wRpoxj9lXFgRuk9P4lnsn/bDPB+iI9gD
         Q8HaVZ+3ZiFSJSvXFXEDL7koLtNedjZd83sOIx9up3IzD64w4cXbUvBMuRDf7lCdsYI6
         MXog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769404515; x=1770009315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mQgKsOGGJe8JvFHFZNpCVI2nLJuIsUEI238/G0I8xU4=;
        b=ZCm5eG2J4ylfAdyK5KKO0AXZR7GULW2ORzF7PrY6+jURN6pRcCF4HiK60YiRUdMhKZ
         4ZW+28dsddr0XdBEJdACIyBiLMcpYP3rtZareVscRhU6Cxc/F3YLrn7HicMwZLzv49HH
         JAEoBagI/67ZU59mZAjrgdpJ6ZEBn/kjxzFY2Ktwb7NDWmLeheTh7hSE2TuxB03hH0WS
         1aTPVi5lchfXSbATOR3NkGmdRJj/Ag4hx41YzRecBaRJimhju9FedDvD6uLy5EzBy/b6
         F3NLGAoKdN3LVD1DrwS/aBDnNfDZnNXZY5RkwDMRkQCoVPxgIi4SiYCqhWMDWyZ+N753
         wRFg==
X-Forwarded-Encrypted: i=1; AJvYcCWLNTNM7Y1RbiglRff7Ut1bbZsPNVUgap8SCcrO9swIwyU4OtPdQZ1KoJYLKdxtcihOix+cclXGVg==@kvack.org
X-Gm-Message-State: AOJu0YzevPMwGZuRmVx2GB4Q943XVmuTvoEqKXM6hB0Uv0AZpZIUooPI
	gZ+GJ4tlaJlGze8+mr/1MlVaEl0uzZTC7j27j+bh1lbvkMCLttr2msrbHDIYvmXWRbdbmCe9rjE
	4slzSh9YSiAw5CvHoDsRCwlMXlkj4atqdJj9qbFIw
X-Gm-Gg: AZuq6aLNBU6O5psMKav3Cw/QUgxl0gcz79j2epaMIgzheKoiogZHrIw23+cukRcaVC0
	DFXLYMhecfIzNy6PxlBMc7mC0uuO4okdMv/A5kGGd7SSKD2LAxN50ohaBUNsMC2WwNKsEUFatAC
	AJqF4aA5quwkAR/9Tk0pQ6oPrdxumEz0ryBHot0idgl6jxGaNc3mSFSabPU1c+FBGlKQFBz46Rf
	RW0LJx7PW76tET9xpGH8XgzrQ7n1A0eWl9cbtRI9z5iQuwuCUYpM9G6Va7vP51vJWlyIVK07CCa
	RuIL
X-Received: by 2002:a05:622a:1:b0:4ed:ff79:e678 with SMTP id
 d75a77b69052e-5031460c5bbmr7246891cf.18.1769404514989; Sun, 25 Jan 2026
 21:15:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769198904.git.lorenzo.stoakes@oracle.com> <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <d462e7678c6cc7461f94e5b26c776547d80a67e8.1769198904.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 25 Jan 2026 21:15:04 -0800
X-Gm-Features: AZwV_Qhs031yzAMqkkSs6ffvEgGLQj1umPZtZRvVLUqCQB2zIzZXYgKDQ0fU6N8
Message-ID: <CAJuCfpEHDVe6==dzb+U5E2Tx_50rH7t1opes8gnzZDP1sKjKhQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/10] mm/vma: document possible vma->vm_refcnt values
 and reference comment
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
X-Stat-Signature: rxcjq7ormyzhzqwyx7x1royn9eu3yo6j
X-Rspamd-Queue-Id: 5B4881C000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769404516-129653
X-HE-Meta: U2FsdGVkX195UTg2lvMqU8rnMGiy8A3WRHtYnzksPeGHQHQDTDBnx+TLcwynYqqUBasjH/wW1G7B7c6KAu/+6eX9kCpJVNw+Y+Swxn57Jh0AkzmtpjKfpv5r+XeA4EhF7omebN4HcIyGsi4HUmBICKo8yc4Sf9pfe1sZA7LV8Q4mMuXofETeZGLbyN6yWR+sSFSUVTb+dUmXpLdDF8xZ2IZY7tLpizYvQn9P6HoN2tNlci4seN2Xvlx2GOP54U98wk8gsP3NcmepPHOUOvzxLM1wEsy7WjW05q57pYEmq/5NTYC6kOjO8YsPGW9Jl9NIsC45JpoUs6hhbwiKUemp9zAGOtGhK9qUbbxVqJnnnj7RTYkvdfEWGtU4j936K9j2K6CXu0UQElrU4nkb1/X9yEXOPUjZj14j/aG5br6OG9cdLqQIdDqD0V1qwv9SrvWYRpqfMOnbGgB+zqymcFTRoA4nYeUDUxzfUAUgSbRHY7lOsKBt8LoTCZol4aVgr8qVvGZjlmHr+IDF/eGzCoiFC7cS6vHFGdLSDITjH9760HZ4Ch3v8t1h5IExfQ+um33mimuY3NuKSLzrXuH+wH6JM+y21lVGpyCBMaE7jfNEOMeJR+8ZN/d+oaFdrcpCPrK3J+WTpaiwO62VrfxozgXLYySwUMEf76DwQhEOPMWkDmdgN5v/u9QtIyDy/E8v8yazruDBBn84jhQMOCYftJFJfdvRV8pZQsKwwpyirlNmC/sqGC4COBaWDRfdvfdy4yzAEP7RI1Yi5vVr+Hl9HQYdxqKnSbdE9mFX3TFNPG3EHG7FcsKI6Dnt0kzxk8buFxuxIoNZH8471gkRAmnnUJmigwgj7DA/24+Za5S4jgerkkNROa13iFx9E3h4xm49Q2VMjUJPj3cpNRA9nnT1BVtV3MLm5RIgbSXkXm69jazSd865m7ZqM643bKMKO5oT4gtnTDy78LsdZZgfwlo6NPI
 5TFFscSL
 gwyzdRUrtREK/ZIOFXTemlPR2BE26a+G8m9to0haXW3I2Nn75niUTUi0ufG3UnRe8swj9FU7vIrgMXD6k/OvLkvj3HKCbLXj3Ro6Ae01U9mgfnLADcChkPDuARPxVKJzC+GZ19pBcz9gBKF/9lFauJ9fItX8SNoRxbGnFIc6UKhHSQKUA0V5yZu1ytDuSj6nyCQaZCgA7XaA8R01lIQiWZK5cSAPw/+kcky2D1DXhq42g+8Ns7J+GNrP42UUN9RfnLmHzkrt5762Fy8LUpHxCqFeMxs+f/vZKPb+KZIsdzhzYGt5w2Wy3/Ku/6tJ85sJJFs3RQhNpymNPfMg7o+nIPMOI7BGPUvbk3tvh0VAVFlU6mnc5I7bMj5Fgsi0FDhpO/v/KO7vVPMcdRFsrwA30RSJSgA==
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
> The possible vma->vm_refcnt values are confusing and vague, explain in
> detail what these can be in a comment describing the vma->vm_refcnt field
> and reference this comment in various places that read/write this field.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

One nit, otherwise LGTM:

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/mm_types.h  | 42 +++++++++++++++++++++++++++++++++++++--
>  include/linux/mmap_lock.h |  7 +++++++
>  mm/mmap_lock.c            |  6 ++++++
>  3 files changed, 53 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index bdbf17c4f26b..12281a1128c9 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -758,7 +758,8 @@ static inline struct anon_vma_name *anon_vma_name_all=
oc(const char *name)
>   * set the VM_REFCNT_EXCLUDE_READERS_FLAG in vma->vm_refcnt to indiciate=
 to
>   * vma_start_read() that the reference count should be left alone.
>   *
> - * Once the operation is complete, this value is subtracted from vma->vm=
_refcnt.
> + * See the comment describing vm_refcnt in vm_area_struct for details as=
 to
> + * which values the VMA reference count can be.
>   */
>  #define VM_REFCNT_EXCLUDE_READERS_BIT  (30)
>  #define VM_REFCNT_EXCLUDE_READERS_FLAG (1U << VM_REFCNT_EXCLUDE_READERS_=
BIT)
> @@ -989,7 +990,44 @@ struct vm_area_struct {
>         struct vma_numab_state *numab_state;    /* NUMA Balancing state *=
/
>  #endif
>  #ifdef CONFIG_PER_VMA_LOCK
> -       /* Unstable RCU readers are allowed to read this. */
> +       /*
> +        * Used to keep track of firstly, whether the VMA is attached, se=
condly,
> +        * if attached, how many read locks are taken, and thirdly, if th=
e
> +        * VM_REFCNT_EXCLUDE_READERS_FLAG is set, whether any read locks =
held
> +        * are currently in the process of being excluded.
> +        *
> +        * This value can be equal to:
> +        *
> +        * 0 - Detached. IMPORTANT: when the refcnt is zero, readers cann=
ot
> +        * increment it.
> +        *
> +        * 1 - Attached and either unlocked or write-locked. Write locks =
are
> +        * identified via __is_vma_write_locked() which checks for equali=
ty of
> +        * vma->vm_lock_seq and mm->mm_lock_seq.
> +        *
> +        * >1, < VM_REFCNT_EXCLUDE_READERS_FLAG - Read-locked or (unlikel=
y)
> +        * write-locked with other threads having temporarily incremented=
 the
> +        * reference count prior to determining it is write-locked and
> +        * decrementing it again.
> +        *
> +        * VM_REFCNT_EXCLUDE_READERS_FLAG - Detached, pending
> +        * __vma_exit_locked() completion which will decrement the refere=
nce
> +        * count to zero. IMPORTANT - at this stage no further readers ca=
n
> +        * increment the reference count. It can only be reduced.
> +        *
> +        * VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either write-=
locking
> +        * an attached VMA and has yet to invoke __vma_exit_locked(), OR =
a
> +        * thread is detaching a VMA and is waiting on a single spurious =
reader
> +        * in order to decrement the reference count. IMPORTANT - as abov=
e, no
> +        * further readers can increment the reference count.
> +        *
> +        * > VM_REFCNT_EXCLUDE_READERS_FLAG + 1 - A thread is either
> +        * write-locking or detaching a VMA is waiting on readers to
> +        * exit. IMPORTANT - as above, no ruther readers can increment th=
e

s/ruther/further

> +        * reference count.
> +        *
> +        * NOTE: Unstable RCU readers are allowed to read this.
> +        */
>         refcount_t vm_refcnt ____cacheline_aligned_in_smp;
>  #ifdef CONFIG_DEBUG_LOCK_ALLOC
>         struct lockdep_map vmlock_dep_map;
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index 5acbd4ba1b52..a764439d0276 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -130,6 +130,9 @@ static inline bool is_vma_writer_only(int refcnt)
>          * attached. Waiting on a detached vma happens only in
>          * vma_mark_detached() and is a rare case, therefore most of the =
time
>          * there will be no unnecessary wakeup.
> +        *
> +        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> +        * details of possible refcnt values.
>          */
>         return (refcnt & VM_REFCNT_EXCLUDE_READERS_FLAG) &&
>                 refcnt <=3D VM_REFCNT_EXCLUDE_READERS_FLAG + 1;
> @@ -249,6 +252,10 @@ static inline void vma_assert_locked(struct vm_area_=
struct *vma)
>  {
>         unsigned int mm_lock_seq;
>
> +       /*
> +        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> +        * details of possible refcnt values.
> +        */
>         VM_BUG_ON_VMA(refcount_read(&vma->vm_refcnt) <=3D 1 &&
>                       !__is_vma_write_locked(vma, &mm_lock_seq), vma);
>  }
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 1d23b48552e9..75dc098aea14 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -65,6 +65,9 @@ static inline int __vma_enter_locked(struct vm_area_str=
uct *vma,
>         /*
>          * If vma is detached then only vma_mark_attached() can raise the
>          * vm_refcnt. mmap_write_lock prevents racing with vma_mark_attac=
hed().
> +        *
> +        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> +        * details of possible refcnt values.
>          */
>         if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
>                 return 0;
> @@ -137,6 +140,9 @@ void vma_mark_detached(struct vm_area_struct *vma)
>          * before they check vm_lock_seq, realize the vma is locked and d=
rop
>          * back the vm_refcnt. That is a narrow window for observing a ra=
ised
>          * vm_refcnt.
> +        *
> +        * See the comment describing the vm_area_struct->vm_refcnt field=
 for
> +        * details of possible refcnt values.
>          */
>         if (unlikely(!refcount_dec_and_test(&vma->vm_refcnt))) {
>                 /* Wait until vma is detached with no readers. */
> --
> 2.52.0
>

