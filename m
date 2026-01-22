Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 153CFD6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 20:15:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EDC56B034B; Thu, 22 Jan 2026 15:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C5196B034C; Thu, 22 Jan 2026 15:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D0CD6B034D; Thu, 22 Jan 2026 15:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AF916B034B
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:15:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C52E5D4714
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:15:34 +0000 (UTC)
X-FDA: 84360704988.28.B516542
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id C0151A0016
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:15:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOiPnaFT;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769112932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XILBP281+8VrtpYosDEw7u/sNJAjO21IYZ4LAU+0xJA=;
	b=BagUke4sd7dN/HuLj4nxORHbIJoObl5GNiqLcxMOIHXEsD6M2HhLRxeiL81yRErrbFg38l
	R0zxtpQSOD0i2pTvg7J91lYBfjiqzoeB8RfsL+52/wghFnZSmbR+cIl/qLkoBYzoRH9KY3
	JGg1D7mdEhYigFLl8JlyNQF+rMBiS38=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OOiPnaFT;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769112932; a=rsa-sha256;
	cv=pass;
	b=bXH3RrcOeXOTGIbwgGVWETooZ/VyKW1nIgC1CZW0pC8xBkeoE44Idvj7PSjdlXaCATqBEt
	ntqz96hIbtFNLlbpcn7+oiFoAxiOl8ST7nU8NM42tfgMfse23gPSRk24/1/aOOYSxRdhh4
	CHIyPnk1iUOVK4Kp1+40z/iya6qZHtY=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5014acad6f2so88251cf.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:15:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769112932; cv=none;
        d=google.com; s=arc-20240605;
        b=PEiF08nd+rVWvJCyzyU3R1IsJSDKQke8VRpKki5TDe8SCRwq8Du3m+BWEzkn3Wygyi
         +STTiGxhp55Hk6oDX7+5qgQZ4HRV9tfRgDLoJLVTq1tfYnjmAxIq5O6sOvM/xiOZwauc
         oFSsrFRPB0T7FPn4eICmJaF/yXitOadvY2I7b9/IDinBV8InJq1087SnIHEi22U64vs8
         goE2hbDCyNwEXj2Ad+pFMu5DvbDPIjVoyvru8c6MZwu1EXRQ648A+sNavHLifQ7u3Wvc
         34m/ThZRr0BIAltGcp6oro2CAhPjupBHVNYy184/E2bQhhUo+cIHpQUmaYg2Yzhb7Ntn
         YhXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XILBP281+8VrtpYosDEw7u/sNJAjO21IYZ4LAU+0xJA=;
        fh=3/IJLHec0R0tyH36Y49qGDkDs3AWBno32hS6UjST2a4=;
        b=RpIYffbTnlQOYR8yI7caFNbq+VJviNr8hUF+B7O6K6HUaRf4e9TBzUJIod5y9+0lrh
         23BWFXaxWhZOLYu9xEzFLfLhCZKkkR6r7KZG99JO9cYZH/ud5x4reI4oncYDsSxEJrYJ
         iY4112zTvoviCKkqMzNodFruC34eZ22Xm5vjFRyBXGcuz99Zwe9fFCHVKI3FHx6SJqd1
         A75aYsGaZ4HsnoegxiZhk2BWEauBt2JYiHihnnRFUjbz+LOlXi2yHqkpsgsFIyyqplM3
         E25QRJtUAVIkj8un8sQY35WBDMBfrqByZ2aibDfpM5QI3WP8l4+HMl2+qmmVessM6wo+
         a8LQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769112932; x=1769717732; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XILBP281+8VrtpYosDEw7u/sNJAjO21IYZ4LAU+0xJA=;
        b=OOiPnaFTRVgiHgtb3QQIErg1hwb58emL3blzZWMbHWXKBT6v4ge72uq4H78TScnyJg
         t4h7Z001gmy2K9VBibdpdoSM0Jz7SD/wJb1hvkdiWvxOcTTPLRnY8iCL+i4zcZ7E5ene
         NMChgD4jBElVG+loCUcGxkGt20OZCgIU7QTp6JktKU3lRXEt1klLSbpG5s3pcVyaEbMh
         nEuOEl3mo9lMAxyQYIwuMc5NEItNdEQojbLEC8FYT4LxtNFR9gleIF5bk4ItjTpCU5lX
         A+b3QAOflKFoPHG96c2CO7yhNBXhTE/tvNyazS1tESRUAcpRVHYBsU3gmQBVBqVCg8Ob
         na8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769112932; x=1769717732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XILBP281+8VrtpYosDEw7u/sNJAjO21IYZ4LAU+0xJA=;
        b=oqpfDv4vsSkVGri+p2rxj9lndCfY/AL+E5mDzs46OzW1BRGht3KK2FWocqHr2anYzZ
         lNKExPM5UcYECqaR5xTht8Zx/Fepny615OTdHFQaTDy/MqOJD75cUGinSyOMYw7bbF9N
         ncJ6aCeDMdpIZB+BNHbWs1o5RyFPNrLEI3jsRIRDxPno/zf7b3av3ataG0xNjO+9K8b9
         UuZgjPfvX98mjjHSkNjdDPDlwdUOwUmELBDVTpw39RBFv/sEpfaW7PnFwhXooQx9pOAU
         PxdpgI3ALiTCf+mbWM+oj91TnAHowgb4NU1NWgYW3MBZtWbYTkhWwzEdaB+kO1ig1kod
         eMAw==
X-Forwarded-Encrypted: i=1; AJvYcCUDtk2qaZx/Aqz6WKOkfxYcYJg9yJb97ulpK5tjTEy44vLs1XN81CWEdQ2WOfGRV6gOACqStjLO3Q==@kvack.org
X-Gm-Message-State: AOJu0YwJlxR024lXOrNJlloVqxIK2/MU/o7XBHcE627pXBd3qKaPU1Wh
	rs2BhvtFztUFwtv9rGQyjKOnm4DDJDUApS/k8u/L3rVJSdsoobk/QFN0xW/nE9FEaaXqizt4yeM
	yKTGnFwQf3pBHc+dWtqTD/tFeeSbhHu+eU+cSGGAx
X-Gm-Gg: AZuq6aK/iyTJvHSxLvqo2hjgLktl8xWZC2Kgcf7oHBy/f9NYiwQ/MyG8zYBoQolYhUD
	0f7doVaW+Mh0IX8P4MAsHnKtXw7qbyux5GnvZDza5LDoIqJxrpsGzwI3k0pJ+JC9+KKnxjEz3Kk
	bHfHZRtI4oh3wSZGsq484850EMdezPe27E6lCSipIIh2THJuUiYv1VSGtZxOnqMna6bN9LQWRBu
	D0av7P3f6V7sUklgQ7RyNAGuT80o33AS6k7XiJ0zdyL5qb7t0WLejAYYyd25WztxkTLWtp6n359
	5JUkqJ95AaVU9SaQn4KKemxl
X-Received: by 2002:a05:622a:14:b0:4f1:9c6e:cf1c with SMTP id
 d75a77b69052e-502f8126e6fmr2006421cf.17.1769112931268; Thu, 22 Jan 2026
 12:15:31 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <f1981963e3c9421b6ffef19f15d87953895cd0b5.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 12:15:20 -0800
X-Gm-Features: AZwV_QgoVz99OaZODU1LJm3Q2LqzAZioiBIEcwIIEUVcYXUXyt7rkbO5PzhYImU
Message-ID: <CAJuCfpFFW_tcHPMtryoVcSKigEGZxfn3Bz=8BUtrJj8kgEWDJA@mail.gmail.com>
Subject: Re: [PATCH v3 06/10] mm/vma: clean up __vma_enter/exit_locked()
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
X-Stat-Signature: 5nt3bejyaxpe193oakztkny99wzdi58h
X-Rspamd-Queue-Id: C0151A0016
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769112932-388201
X-HE-Meta: U2FsdGVkX1/CXqVwhsFcTN3EQcbwAzJ77DlkRrq4g8o3MswvwAwsxlFxt6ZODEfKZA41XtstZbQxYRXE0JomBAfGNCMTTGsXnsSqbvI1fhw+x3b4MMze+MWzEMF5Lec8LyLNAXuphexEK3l0/k3GRfIg8qXgHV8DgfpB6KncbS5srk6g1Z9TElBuQY+ZY7G/1nAGPJuQG45+5AcT5FiMsk4vLJ5N/wMj3F3OSp5J1xg12YQ3fg8dZTVmSxb02ef83Oy4O34cbN48xkuKTOtcRMYLj/jBEwfwwg0HXc9ffF7dNDnRb5S1V8Nz3VOt2unUM2nWhgyFtXZdVsaoxtF/+1knsxbBfOPwYPUAAWwjZdXeBte11k6n4zFhhJM4DVZUwAdNWNVFjlOxqaS4CWHA1Q2z+AtPWueL6om0PjtCpVa4RdQnXjywfAaf+PwgW90eRN2hWXTdg1Iu8WwCSBPMvAS3JcbjO5qWBrQDkIKbJUClJ/vlYlfpiN+jQSk8F7msVzFKIzhB1NnsgO+/LSolc2tFQ1eBPHr/00wYUbyYf5sGn1a7TKMZAGUSqdPtgydpFJOmla1/ytVthMsaXal3/8/s0goFE13gZG6dDVgJsqbfjjBu2Hgm5Y41rS162THy7s6CTpsxe4EIi9UVSzqkwcJbP4BpSM0AR1lA6gfQsF0XIMq5ar7zJWpZmM6T909kMppt3ckYEqHlZZ0k+5kCxEjefe02bPLsWSoIE8Dk+tDXct8S9hyGFXhsPZi/rgzSD3EZgi+Rh0y9Mm8dyr+ZMD1poCGhwKRRwrwmg3Q/PjKE2G9Aa40DlxZPzfjglTQciEfX+C04eLufILDmUhD1/TlNgOIH5pwXrt3g28VfPY5F6otw3xQfEmujM0h1fohVSPtFN2nhOOmIx2id0WAMIzG5ipZqJhWkWPASqXy26s/jqZOGVOz+Z4yn9lk8beC1Ept0nnfFFl2ruzIWK4i
 QvZaYqvp
 YPANcVly56NyIeaCL+opeGX1AHe28K43p/mVfGtN119iP0X2GuPmFdGmIcNw7zi5wLZQMPnWwzPh9+eUZKnAP4H/O10gWVoqEtIYuMWK43VVPRuSfwI6l1/N0ITjwKR67QpOSF/jRoNmGk7ZCHrTXyuJGXBeCKfW23eSe0gPrpsLQldMqpFz+wBmIb6uI09cr5Y7P3giadNfPKvoTpwI9HDtk1r+PXH+Y8R9qJasJ9Idh1LfS5uI7awE4qAIrjk0KN7+812ROCYzIUIcE/+VJZ2fX3K4KYZnK351bcJVYJeP5uqFWIEd3GmJ1L8vpTG83fAQhiZkvNjHUvkgy4PdGr7vnuNulovWl4nXA4HB5JNbUsf25XJCKfTiO2Tfy0hkuMCww
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
> These functions are very confusing indeed. 'Entering' a lock could be
> interpreted as acquiring it, but this is not what these functions are
> interacting with.
>
> Equally they don't indicate at all what kind of lock we are 'entering' or
> 'exiting'. Finally they are misleading as we invoke these functions when =
we
> already hold a write lock to detach a VMA.
>
> These functions are explicitly simply 'entering' and 'exiting' a state in
> which we hold the EXCLUSIVE lock in order that we can either mark the VMA
> as being write-locked, or mark the VMA detached.
>
> Rename the functions accordingly, and also update
> __vma_exit_exclusive_locked() to return detached state with a __must_chec=
k
> directive, as it is simply clumsy to pass an output pointer here to
> detached state and inconsistent vs. __vma_enter_exclusive_locked().
>
> Finally, remove the unnecessary 'inline' directives.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  include/linux/mmap_lock.h |  4 +--
>  mm/mmap_lock.c            | 60 +++++++++++++++++++++++++--------------
>  2 files changed, 41 insertions(+), 23 deletions(-)
>
> diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> index da63b1be6ec0..873bc5f3c97c 100644
> --- a/include/linux/mmap_lock.h
> +++ b/include/linux/mmap_lock.h
> @@ -209,8 +209,8 @@ static inline void vma_refcount_put(struct vm_area_st=
ruct *vma)
>         __vma_lockdep_release_read(vma);
>         detached =3D __vma_refcount_put(vma, &refcnt);
>         /*
> -        * __vma_enter_locked() may be sleeping waiting for readers to dr=
op
> -        * their reference count, so wake it up if we were the last reade=
r
> +        * __vma_enter_exclusive_locked() may be sleeping waiting for rea=
ders to
> +        * drop their reference count, so wake it up if we were the last =
reader
>          * blocking it from being acquired.
>          */
>         if (!detached && are_readers_excluded(refcnt))
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index 7a0361cff6db..f73221174a8b 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,19 +46,43 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
>
> -static inline void __vma_exit_locked(struct vm_area_struct *vma, bool *d=
etached)
> +/*
> + * Now that all readers have been evicted, mark the VMA as being out of =
the
> + * 'exclude readers' state.
> + *
> + * Returns true if the VMA is now detached, otherwise false.
> + */
> +static bool __must_check __vma_exit_exclusive_locked(struct vm_area_stru=
ct *vma)
>  {
> -       *detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLA=
G,
> -                                         &vma->vm_refcnt);
> +       bool detached;
> +
> +       detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG=
,
> +                                        &vma->vm_refcnt);
>         __vma_lockdep_release_exclusive(vma);
> +       return detached;
>  }
>
>  /*
> - * __vma_enter_locked() returns 0 immediately if the vma is not
> - * attached, otherwise it waits for any current readers to finish and
> - * returns 1.  Returns -EINTR if a signal is received while waiting.
> + * Mark the VMA as being in a state of excluding readers, check to see i=
f any
> + * VMA read locks are indeed held, and if so wait for them to be release=
d.
> + *
> + * Note that this function pairs with vma_refcount_put() which will wake=
 up this
> + * thread when it detects that the last reader has released its lock.
> + *
> + * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases =
where we
> + * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal =
signal
> + * is permitted to kill it.
> + *
> + * The function will return 0 immediately if the VMA is detached, and 1 =
once the
> + * VMA has evicted all readers, leaving the VMA exclusively locked.

The wording here is a bit misleading. We do not evict the readers,
just wait for them to complete and exit.

> + *
> + * If the function returns 1, the caller is required to invoke
> + * __vma_exit_exclusive_locked() once the exclusive state is no longer r=
equired.
> + *
> + * If state is set to something other than TASK_UNINTERRUPTIBLE, the fun=
ction
> + * may also return -EINTR to indicate a fatal signal was received while =
waiting.
>   */
> -static inline int __vma_enter_locked(struct vm_area_struct *vma,
> +static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
>                 bool detaching, int state)
>  {
>         int err;
> @@ -85,13 +109,10 @@ static inline int __vma_enter_locked(struct vm_area_=
struct *vma,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
>                    state);
>         if (err) {
> -               bool detached;
> -
> -               __vma_exit_locked(vma, &detached);
> -               if (detached) {
> +               if (__vma_exit_exclusive_locked(vma)) {
>                         /*
>                          * The wait failed, but the last reader went away
> -                        * as well.  Tell the caller the VMA is detached.
> +                        * as well. Tell the caller the VMA is detached.
>                          */
>                         WARN_ON_ONCE(!detaching);
>                         err =3D 0;
> @@ -108,7 +129,7 @@ int __vma_start_write(struct vm_area_struct *vma, uns=
igned int mm_lock_seq,
>  {
>         int locked;
>
> -       locked =3D __vma_enter_locked(vma, false, state);
> +       locked =3D __vma_enter_exclusive_locked(vma, false, state);
>         if (locked < 0)
>                 return locked;
>
> @@ -120,12 +141,9 @@ int __vma_start_write(struct vm_area_struct *vma, un=
signed int mm_lock_seq,
>          */
>         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
>
> -       if (locked) {
> -               bool detached;
> -
> -               __vma_exit_locked(vma, &detached);
> -               WARN_ON_ONCE(detached); /* vma should remain attached */
> -       }
> +       /* vma should remain attached. */
> +       if (locked)
> +               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));

I'm wary of calling functions from WARN_ON_ONCE() statements. If
someone decides to replace WARN_ON_ONCE() with VM_WARN_ON_ONCE(), the
call will disappear when CONFIG_DEBUG_VM=3Dn. Maybe I'm being paranoid
but it's because I have been bitten by that before...

>
>         return 0;
>  }
> @@ -145,12 +163,12 @@ void vma_mark_detached(struct vm_area_struct *vma)
>         detached =3D __vma_refcount_put(vma, NULL);
>         if (unlikely(!detached)) {
>                 /* Wait until vma is detached with no readers. */
> -               if (__vma_enter_locked(vma, true, TASK_UNINTERRUPTIBLE)) =
{
> +               if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERR=
UPTIBLE)) {
>                         /*
>                          * Once this is complete, no readers can incremen=
t the
>                          * reference count, and the VMA is marked detache=
d.
>                          */
> -                       __vma_exit_locked(vma, &detached);
> +                       detached =3D __vma_exit_exclusive_locked(vma);
>                         WARN_ON_ONCE(!detached);
>                 }
>         }
> --
> 2.52.0
>

