Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEFDCD6CFA7
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 21:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B376B035E; Thu, 22 Jan 2026 16:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 106236B0360; Thu, 22 Jan 2026 16:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004BE6B0361; Thu, 22 Jan 2026 16:41:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD1A76B035E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 16:41:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86D11147ED7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:41:55 +0000 (UTC)
X-FDA: 84360922590.20.76561CE
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8DFEE100003
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 21:41:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IgKgRKN/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769118112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0z36lq24n0t7CcQnsonx07kAaEuIJ+bjVsuvlPAw7g=;
	b=qsvyLOQlsXqWyXuaoPAav2rg4yGY2opJ3mCMM5sd5kplWIqxvbHz+1EoWJ/Nv1Gn2/zy9Z
	Hcu44oJZly7RZ+NDX+KXKPSRV0JQTubj640G5DxPAT27gR096F/kjdeUKaDYU01cArQu98
	iD9BZQU/PTcxWjqaHnUiOpHz7DTpmBg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769118112; a=rsa-sha256;
	cv=pass;
	b=WTi4I8oBBwPukquREOhG36Ou82Hw4Riyps4epNYHUhuxlWCfcYElBjSj/6+vG3R0N9sHeF
	cZvoYOcQAzpMHqTzrgmtcleUpWRdiKa0uZ+DMebljoFgWUGLF0bhqJsLodj8Qf6emOX1lb
	0w9kGmEeRI+ABBfUWS9Kya8czJfB/x0=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IgKgRKN/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf14.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5014b5d8551so175751cf.0
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:41:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769118112; cv=none;
        d=google.com; s=arc-20240605;
        b=bJpqfGoM5rAnOjbw9E2J+Q78l8iDZnkYWidenkmFUiNw0OgNkNnmi0uWLw6lpAXGxL
         i83HUCzygb1VS68YrA7eL3ZFzUiS1AWVbIjQBkBHpYVpnR7taFspqlCtBPnb+V6Rfoya
         ybqN8bEok2ueM95osuoDMboG4oPABAnN3XHQ1DB4+SDjfumwVPEKeG6aHzRcsn+8JLxF
         b+rneaRZEzUKZ4Dq8N9SIto5hsr1TKAWIZ2KGfUoOZTY959SHd/J4H4fyGHtcB5GzU24
         OGQnUoy0JhdJr5xhMikBxGwyaxs4KNGTXniCTG6ty9aNoIeAlryKlXzO2oKA/sohaNFz
         8vnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b0z36lq24n0t7CcQnsonx07kAaEuIJ+bjVsuvlPAw7g=;
        fh=ggOb132Ty+XYQp0i59udEKUXyXyXmye80y3FYCEj8oU=;
        b=aFgyEg0xIF1jy4e5K9JVmJ+7L4INQQE9ORqyphP0HxTwMS02fp66jGo4p9vV5Tmbog
         TGDACNm5AybHqGcDoIJQTxle5eBH8YNluY5IE7QGQpt/yWlyFNmn8OBUtg2HFA0T+NSy
         sxvMel+nvdr/QMCR+0zOyPMsFPWFe8TiI9rre/VRnBNoITjgFR7ULAplRsWg7g2+6Su4
         jxhd3/tgv7vUAFhuFEhStpfOG0+6TR1jUSGVZDPpZo72k3TpcIiLZX2zLPh+1F0wycnG
         PPAqUUTDFhnQV+naYKa3vvjkUqQ+eIvblFSDMxq5y+SKTYOaDmVC+EZK6C0gaX6726v+
         3C8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769118112; x=1769722912; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b0z36lq24n0t7CcQnsonx07kAaEuIJ+bjVsuvlPAw7g=;
        b=IgKgRKN/3016syziZF0xcRbthVgp+a1Nb9yPxLpHtSBO8zG+70kSJ1sAXCw27oWClt
         VgRmHe1qRndeGGEm4X4GyrHuqJ2D+16B8hPXRfGMq0PsUC0JlPOeuwY/rg4vUXTkAqz1
         qGyElkv+tq5VSp5IIMnGA325FubjOnnZBkwKaAQ66tGstD1KF74uSIrB9LfKcu5xAm0R
         RhVTguBXyBV6X8kbNfn8zoKQUVXGjGwPNA/7f3Trm997EGWWfmapaR7YqmpJZ4ABq+gH
         pjhwNxEWcn+NUPyKX1fgVrixMtBG6uxOYVhaal2v3bOlQ/QPIPuEMpcwwsMtiefDw9Wh
         dOfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769118112; x=1769722912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=b0z36lq24n0t7CcQnsonx07kAaEuIJ+bjVsuvlPAw7g=;
        b=ES4slkD5UTY/THupFGDu40qpY2OFOF9uRhaXha+fQuKd3LLvIotW0OvamRccstGAre
         28iknWvgFkofux11AC2WkjrDnLYjDRKvrlXJPI5ek4lwfd84npdgs1TBMQnMuHgS78Y+
         9CKQPipTdmcU2FkRbNcFgwqZuoqIDGaEH0iPM0C4uGnnGstXGiPwQpELUMh5SdAZZqh7
         wrXwbMSD1r74/dL0jJgglpDe1c1nfPj5REtbcyqrna77J+qz0L6IpTDov15X9B011XyQ
         tGLxn7W//vNGt0ItLU4Vg5Ppow+59Mvl0uHCZ+Ykrp/y0rWFrPaYUoWitSiOwY7N0WNP
         KkiA==
X-Forwarded-Encrypted: i=1; AJvYcCW0cqCJKx2bmFmIFaHSI5lXedIShJgNki9UQ8Zd9FvtFOz6AaSE94vnja2YV+dA+JRHq416eGOFwA==@kvack.org
X-Gm-Message-State: AOJu0YyZbvsS9OKkHZtp+EC+ROWE4s8ztfyyrxRo3xOIrrKh4u9FqC3N
	SQiNqcViuikM+j3RetT8lRiGZsH+xBNM7OxmripbUSA5uRwxCqoAJdhh3LBYQ6sIRg/m7yvIQlD
	Yju338TcYh62OPtJqIGt8PdThx7CjKEeYqnf2iH1O
X-Gm-Gg: AZuq6aI+EtGyIf+W9sVYvVHzxKvm+eMEabbUNP2SaKTvMqvQqjSrxO2SQp5xksxEZyd
	r4EVJsj2vj/C+U68JovOkw8Xss/P2/yvAfjV8QcMRrBB+Rrlsd9Tg6ttFUTibMY3rLaOsH/zEPt
	TrFWzZYpBrrFG0B9B+V38QS8VkWO4FSu1ezSWh5BWS3/E+GgemdMkmpVpgev9QOu44BQFLR4P4n
	t4IKBo0N919F+N6KI1/iBsaM+MtH3dWQ2S4iCg/hU0xTe0kzUINmen6XOT9XjHa24w7aKCWxp14
	1n5iAZqfJoFpL09gd5Sr2zae
X-Received: by 2002:ac8:5f4c:0:b0:4b7:9a9e:833f with SMTP id
 d75a77b69052e-502f8dd1f29mr828171cf.7.1769118111204; Thu, 22 Jan 2026
 13:41:51 -0800 (PST)
MIME-Version: 1.0
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com> <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
In-Reply-To: <4f95671feac6b6d4cea3c53426c875f3fd8a8855.1769086312.git.lorenzo.stoakes@oracle.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 22 Jan 2026 13:41:39 -0800
X-Gm-Features: AZwV_QiUCaGM32Wq1UYdnioBziJ8H0aqaz5os6V0HI-LhNnVIc8UrlMk0F6amZ4
Message-ID: <CAJuCfpEULwMTxAzxUdzfpHe2=+umXL6HFMvydkqW=tP8mB2ewg@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 07/10] mm/vma: introduce helper struct + thread
 through exclusive lock fns
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
X-Rspamd-Queue-Id: 8DFEE100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 5xyh1b9s1u3hb84iyrgjgyepnpedo74g
X-HE-Tag: 1769118112-715492
X-HE-Meta: U2FsdGVkX1/bDWXemAkyRk8MMLgKDcvDhVTit2VcOLXZHld+Jg5I3N2wFOUU/vAE5jiYY2fV0KBYxAV8Yd9cahm5x+UpPz2BGVYQYftpVPfGLmzmJUxSKlNZwW/xdxknnshyOgF6jhMIm5afFxGaSod1zW9ODyiW4wOAX/MXYCIL+/ieQSdCBAqG+ZXaakekj7QxhNoIcV6CeSFFnJeb1R1wAsFk+FXaXxjKCirQDZGNhyTdY2USfTQGYdSY2E7LzgUcwxKSpPmFB7XI2MUNaQdb08TnfEQsk4ckeyQxY3zVf8yPDi0TH+bXSCMf5EzdQP9T3HEAfzH8F9aaxNwphVGz5MqnxjMu2W4Dkvjizc6Kt0rJ6z1WZWJAiMbiMJUpGPojp+OK4m9MY1MC853BzHZYfzmav818tl66+GgOXWIESwTUFrVDvxgHKG9g0WDGXfbODu8Vzb6Zf8ZlxnQstNM4ObAHOyQidg7UhD9OxwFRnUCLELe8exkNmCcuZVxtcKsburGMo6GPq7YKdRkCy2sW+GHMePs/VN1j3kF4YyAeoj/DqwQgc4spNh1zhH3h1xOQxvDKqHWdz5f+4YXaHghIzo6096owQTGjFrjbh/U7tLsqtXyUHpa3pEIFks/QVgnuZDK2YuM0IHENHi5HYZdtMSxhZOKfjKu1o52U6TaClo7smzeVWmHH+3qv/0htZFJKBc9FF21xasL7vPOXhkuArDyTphbeL74bovMcZKX6ysAx0zC1DN1adgO8O0mGb6Tn4KsGqNL2VfY30DSXkF3DdaJM9JW2AX8nspr6ljXn5keJm5MHX9pisKFiOZIPE2Z7aJst+OpelPHjOV0El0kP67XoIqfCXyrQOUjKf5PYzmWtf6zsloWSkB0g59InKGqIAQzIMrmzEPStzsghHAUrEMgVtT5rYpCwiatWas+Xi91WHAY9YYR+Qp8Zr68wAoJwr/a/kPxIc+aVslC
 HCJgiA6c
 BWglMdk5hMCtDd7kdjrWd7d0FM9UigWuF8huw1B93LlUVitiLVhdmKFh3ExVdfXQsOmuj5xW8iChWhW6szq2mi5Lq428hShmMN9YIhwxZLPNm62kx2I4+e/y2fivXZfXsmWNMOP17WxdR/nd+1hax7fHLX12BY6doQjepydDMINfEstjZVE3Y+7/6990dNAkcA3fpzIUABIhc0rIKvjdV2zRxc1zNmk5DGChAzocIq4/cBNIRtN+C2j3IwiS3VzBUZD9i5mxOX2nUlKVxPADelHrv3YdZ20Csedte2tfDoGhKGEugL2UHz/IuqP/iTHsVtDS9QdIjGWyi2Z4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 5:03=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> It is confusing to have __vma_enter_exclusive_locked() return 0, 1 or an
> error (but only when waiting for readers in TASK_KILLABLE state), and
> having the return value be stored in a stack variable called 'locked' is
> further confusion.
>
> More generally, we are doing a lock of rather finnicky things during the
> acquisition of a state in which readers are excluded and moving out of th=
is
> state, including tracking whether we are detached or not or whether an
> error occurred.
>
> We are implementing logic in __vma_enter_exclusive_locked() that
> effectively acts as if 'if one caller calls us do X, if another then do Y=
',
> which is very confusing from a control flow perspective.
>
> Introducing the shared helper object state helps us avoid this, as we can
> now handle the 'an error arose but we're detached' condition correctly in
> both callers - a warning if not detaching, and treating the situation as =
if
> no error arose in the case of a VMA detaching.
>
> This also acts to help document what's going on and allows us to add some
> more logical debug asserts.
>
> Also update vma_mark_detached() to add a guard clause for the likely
> 'already detached' state (given we hold the mmap write lock), and add a
> comment about ephemeral VMA read lock reference count increments to clari=
fy
> why we are entering/exiting an exclusive locked state here.
>
> No functional change intended.
>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
>  mm/mmap_lock.c | 144 +++++++++++++++++++++++++++++++------------------
>  1 file changed, 91 insertions(+), 53 deletions(-)
>
> diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
> index f73221174a8b..75166a43ffa4 100644
> --- a/mm/mmap_lock.c
> +++ b/mm/mmap_lock.c
> @@ -46,20 +46,40 @@ EXPORT_SYMBOL(__mmap_lock_do_trace_released);
>  #ifdef CONFIG_MMU
>  #ifdef CONFIG_PER_VMA_LOCK
>
> +/* State shared across __vma_[enter, exit]_exclusive_locked(). */
> +struct vma_exclude_readers_state {
> +       /* Input parameters. */
> +       struct vm_area_struct *vma;
> +       int state; /* TASK_KILLABLE or TASK_UNINTERRUPTIBLE. */
> +       bool detaching;
> +
Are these:
            /* Output parameters. */
?
> +       bool detached;
> +       bool exclusive; /* Are we exclusively locked? */
> +};
> +
>  /*
>   * Now that all readers have been evicted, mark the VMA as being out of =
the
>   * 'exclude readers' state.
>   *
>   * Returns true if the VMA is now detached, otherwise false.
>   */
> -static bool __must_check __vma_exit_exclusive_locked(struct vm_area_stru=
ct *vma)
> +static void __vma_exit_exclusive_locked(struct vma_exclude_readers_state=
 *ves)
>  {
> -       bool detached;
> +       struct vm_area_struct *vma =3D ves->vma;
> +
> +       VM_WARN_ON_ONCE(ves->detached);
> +       VM_WARN_ON_ONCE(!ves->exclusive);
>
> -       detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS_FLAG=
,
> -                                        &vma->vm_refcnt);
> +       ves->detached =3D refcount_sub_and_test(VM_REFCNT_EXCLUDE_READERS=
_FLAG,
> +                                             &vma->vm_refcnt);
>         __vma_lockdep_release_exclusive(vma);
> -       return detached;
> +}
> +
> +static unsigned int get_target_refcnt(struct vma_exclude_readers_state *=
ves)
> +{
> +       const unsigned int tgt =3D ves->detaching ? 0 : 1;
> +
> +       return tgt | VM_REFCNT_EXCLUDE_READERS_FLAG;
>  }
>
>  /*
> @@ -69,30 +89,31 @@ static bool __must_check __vma_exit_exclusive_locked(=
struct vm_area_struct *vma)
>   * Note that this function pairs with vma_refcount_put() which will wake=
 up this
>   * thread when it detects that the last reader has released its lock.
>   *
> - * The state parameter ought to be set to TASK_UNINTERRUPTIBLE in cases =
where we
> - * wish the thread to sleep uninterruptibly or TASK_KILLABLE if a fatal =
signal
> - * is permitted to kill it.
> + * The ves->state parameter ought to be set to TASK_UNINTERRUPTIBLE in c=
ases
> + * where we wish the thread to sleep uninterruptibly or TASK_KILLABLE if=
 a fatal
> + * signal is permitted to kill it.
>   *
> - * The function will return 0 immediately if the VMA is detached, and 1 =
once the
> - * VMA has evicted all readers, leaving the VMA exclusively locked.
> + * The function sets the ves->locked parameter to true if an exclusive l=
ock was

s/ves->locked/ves->exclusive

> + * acquired, or false if the VMA was detached or an error arose on wait.
>   *
> - * If the function returns 1, the caller is required to invoke
> - * __vma_exit_exclusive_locked() once the exclusive state is no longer r=
equired.
> + * If the function indicates an exclusive lock was acquired via ves->exc=
lusive
> + * (or equivalently, returning 0 with !ves->detached),

I would remove the mention of that equivalence because with this
change, return 0 simply indicates that the operation was successful
and should not be used to infer any additional states. To get specific
state the caller should use proper individual ves fields. Using return
value for anything else defeats the whole purpose of this cleanup.

> the caller is required to
> + * invoke __vma_exit_exclusive_locked() once the exclusive state is no l=
onger
> + * required.
>   *
> - * If state is set to something other than TASK_UNINTERRUPTIBLE, the fun=
ction
> - * may also return -EINTR to indicate a fatal signal was received while =
waiting.
> + * If ves->state is set to something other than TASK_UNINTERRUPTIBLE, th=
e
> + * function may also return -EINTR to indicate a fatal signal was receiv=
ed while
> + * waiting.
>   */
> -static int __vma_enter_exclusive_locked(struct vm_area_struct *vma,
> -               bool detaching, int state)
> +static int __vma_enter_exclusive_locked(struct vma_exclude_readers_state=
 *ves)
>  {
> -       int err;
> -       unsigned int tgt_refcnt =3D VM_REFCNT_EXCLUDE_READERS_FLAG;
> +       struct vm_area_struct *vma =3D ves->vma;
> +       unsigned int tgt_refcnt =3D get_target_refcnt(ves);
> +       int err =3D 0;
>
>         mmap_assert_write_locked(vma->vm_mm);
> -
> -       /* Additional refcnt if the vma is attached. */
> -       if (!detaching)
> -               tgt_refcnt++;
> +       VM_WARN_ON_ONCE(ves->detached);
> +       VM_WARN_ON_ONCE(ves->exclusive);

Aren't these output parameters? If so, why do we stipulate their
initial values instead of setting them appropriately?

>
>         /*
>          * If vma is detached then only vma_mark_attached() can raise the
> @@ -101,37 +122,39 @@ static int __vma_enter_exclusive_locked(struct vm_a=
rea_struct *vma,
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> -       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt))
> +       if (!refcount_add_not_zero(VM_REFCNT_EXCLUDE_READERS_FLAG, &vma->=
vm_refcnt)) {
> +               ves->detached =3D true;
>                 return 0;
> +       }
>
>         __vma_lockdep_acquire_exclusive(vma);
>         err =3D rcuwait_wait_event(&vma->vm_mm->vma_writer_wait,
>                    refcount_read(&vma->vm_refcnt) =3D=3D tgt_refcnt,
> -                  state);
> +                  ves->state);
>         if (err) {
> -               if (__vma_exit_exclusive_locked(vma)) {
> -                       /*
> -                        * The wait failed, but the last reader went away
> -                        * as well. Tell the caller the VMA is detached.
> -                        */
> -                       WARN_ON_ONCE(!detaching);
> -                       err =3D 0;
> -               }
> +               __vma_exit_exclusive_locked(ves);
>                 return err;

Nice! We preserve both error and detached state information.

>         }
> -       __vma_lockdep_stat_mark_acquired(vma);
>
> -       return 1;
> +       __vma_lockdep_stat_mark_acquired(vma);
> +       ves->exclusive =3D true;
> +       return 0;
>  }
>
>  int __vma_start_write(struct vm_area_struct *vma, unsigned int mm_lock_s=
eq,
>                 int state)
>  {
> -       int locked;
> +       int err;
> +       struct vma_exclude_readers_state ves =3D {
> +               .vma =3D vma,
> +               .state =3D state,
> +       };
>
> -       locked =3D __vma_enter_exclusive_locked(vma, false, state);
> -       if (locked < 0)
> -               return locked;
> +       err =3D __vma_enter_exclusive_locked(&ves);
> +       if (err) {
> +               WARN_ON_ONCE(ves.detached);

I believe the above WARN_ON_ONCE() should stay inside of
__vma_enter_exclusive_locked(). Its correctness depends on the
implementation details of __vma_enter_exclusive_locked(). More
specifically, it is only correct because
__vma_enter_exclusive_locked() returns 0 if the VMA is detached, even
if there was a pending SIGKILL.

> +               return err;
> +       }
>
>         /*
>          * We should use WRITE_ONCE() here because we can have concurrent=
 reads
> @@ -141,9 +164,11 @@ int __vma_start_write(struct vm_area_struct *vma, un=
signed int mm_lock_seq,
>          */
>         WRITE_ONCE(vma->vm_lock_seq, mm_lock_seq);
>
> -       /* vma should remain attached. */
> -       if (locked)
> -               WARN_ON_ONCE(__vma_exit_exclusive_locked(vma));
> +       if (!ves.detached) {

Strictly speaking the above check should be checking ves->exclusive
instead of !ves.detached. What you have is technically correct but
it's again related to that comment:

"If the function indicates an exclusive lock was acquired via
ves->exclusive (or equivalently, returning 0 with !ves->detached), the
caller is required to invoke __vma_exit_exclusive_locked() once the
exclusive state is no longer required."

So, here you are using returning 0 with !ves->detached as an
indication that the VMA was successfully locked. I think it's less
confusing if we use the field dedicated for that purpose.

> +               __vma_exit_exclusive_locked(&ves);
> +               /* VMA should remain attached. */
> +               WARN_ON_ONCE(ves.detached);
> +       }
>
>         return 0;
>  }
> @@ -151,7 +176,12 @@ EXPORT_SYMBOL_GPL(__vma_start_write);
>
>  void vma_mark_detached(struct vm_area_struct *vma)
>  {
> -       bool detached;
> +       struct vma_exclude_readers_state ves =3D {
> +               .vma =3D vma,
> +               .state =3D TASK_UNINTERRUPTIBLE,
> +               .detaching =3D true,
> +       };
> +       int err;
>
>         vma_assert_write_locked(vma);
>         vma_assert_attached(vma);
> @@ -160,18 +190,26 @@ void vma_mark_detached(struct vm_area_struct *vma)
>          * See the comment describing the vm_area_struct->vm_refcnt field=
 for
>          * details of possible refcnt values.
>          */
> -       detached =3D __vma_refcount_put(vma, NULL);
> -       if (unlikely(!detached)) {
> -               /* Wait until vma is detached with no readers. */
> -               if (__vma_enter_exclusive_locked(vma, true, TASK_UNINTERR=
UPTIBLE)) {
> -                       /*
> -                        * Once this is complete, no readers can incremen=
t the
> -                        * reference count, and the VMA is marked detache=
d.
> -                        */
> -                       detached =3D __vma_exit_exclusive_locked(vma);
> -                       WARN_ON_ONCE(!detached);
> -               }
> +       if (likely(__vma_refcount_put(vma, NULL)))
> +               return;
> +
> +       /*
> +        * Wait until the VMA is detached with no readers. Since we hold =
the VMA
> +        * write lock, the only read locks that might be present are thos=
e from
> +        * threads trying to acquire the read lock and incrementing the
> +        * reference count before realising the write lock is held and
> +        * decrementing it.
> +        */
> +       err =3D __vma_enter_exclusive_locked(&ves);
> +       if (!err && !ves.detached) {

Same here, we should be checking ves->exclusive to decide if
__vma_exit_exclusive_locked() should be called or not.

> +               /*
> +                * Once this is complete, no readers can increment the
> +                * reference count, and the VMA is marked detached.
> +                */
> +               __vma_exit_exclusive_locked(&ves);
>         }
> +       /* If an error arose but we were detached anyway, we don't care. =
*/
> +       WARN_ON_ONCE(!ves.detached);
>  }
>
>  /*
> --
> 2.52.0

