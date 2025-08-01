Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDEECC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 15:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FF708E0002; Fri,  1 Aug 2025 11:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B1F08E0001; Fri,  1 Aug 2025 11:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377EC8E0002; Fri,  1 Aug 2025 11:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26CDF8E0001
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 11:31:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C7D751A0216
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:31:00 +0000 (UTC)
X-FDA: 83728576680.24.43031EF
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id E4C4940017
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:30:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SlaAwZeZ;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754062258; a=rsa-sha256;
	cv=none;
	b=tXcRmnpsjgOAVfax6bbltKpXtStS47XmwGlyATdovlCL1yepRlG93qjN3aTbAcpEBDRsi2
	jSyUfw4N+/ZXtckMe0Sm0xuelCHInCw6AEY/lLv8TNbir10VwFv18lrONEHkvceG9BaJYG
	8bcv6gQQhv9rSTymtKWfNbeGkptNcrs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SlaAwZeZ;
	spf=pass (imf12.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754062258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWjkM6aVGbDaelGi0ZenR2loBam6dBRshOdGKAXlyS8=;
	b=x20+rJ7CA4tLz4yHXLocUYFjEc8cPs1080VvUsxaETsMJYW3WF158rcP7zWv86dkHfLFN2
	U1yK5JLwORh4RNL8p50VM6Qc3tgO0rR6Ge//EL8lP5vwaqMsnXVQkAMRGOeEgTgS6rT3UY
	IPjJwyYg27BSd+DYNXqC3JcNxKg8JbQ=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ab3ad4c61fso480321cf.0
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 08:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754062258; x=1754667058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWjkM6aVGbDaelGi0ZenR2loBam6dBRshOdGKAXlyS8=;
        b=SlaAwZeZIYFqDm7AONzacdR/I+C8uMagjg/xarPa/YU73+/MT7A98cN7Q20sZDiPjI
         MoPTnqTm/sgb1KoTz3rXG1Ioqpg+kMmxX21al5NdHnoOhptffoRwsSOJCcWLzxMu+g/Y
         UJStsQoMb0tR4ZeXuLXXWvNMjkgYRLnW87Pnqh3nhP3kX8pEjXdf7zElgr9ndvCfg0Hv
         hKd50w+dtvH3yqr2kD0k5ELZmNuQgzbKVHg8d6LwjcQ8dvkAdPl7BwXTIcElPb85dwwk
         JslFFAq41FoTiaxDugnKhe88QlMW9k+/2pdKQtPIro7b+/7gd8d2FXHA0iSLiK73nu94
         yrqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754062258; x=1754667058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWjkM6aVGbDaelGi0ZenR2loBam6dBRshOdGKAXlyS8=;
        b=otIOli1rl3pMvzuiSSaWU0XDRWjxduCZ+fu1TQ1AjNz319UNQkxKksPXK3VPv864nU
         LkYGf1VrVR/G6PZ8DSSQzAimsAhe0szgsPlP5Pgc37gIPxFuJihSxqlBHsqObsY+HpTg
         xmVBauKUPJMcRtRvQOhX5P9KEjGau1cHryOtgCrZSNxmN+rOT+W8xC6OlEQ7kL0zphMW
         m1aBhrdayqxcsiygdOznNXEl6SvwoRE8vT0EEAx0mwH5ZRQvJcvzUUTaeiRjvFJXZaqx
         SV6LAp1fVS2XCwh2pwUoD1Js1mQQ4BnmqBPZIUskuTpTiRqzcmZR9L6SLouO8M6Be8k0
         dmsg==
X-Forwarded-Encrypted: i=1; AJvYcCVC6BG89ggY/bHFufhmxG2VEck7rxdOSx+zgTNeCXqUlt4QNmJY2tUlJDhoqg4cTzMWmzW61uVzeQ==@kvack.org
X-Gm-Message-State: AOJu0Yy6PS1s7YfT5SKzXDiOSf7eIQ6PD5gePo2br/IH6/hdjlSqYHrz
	6HIhWdRrBDJKsZFBw/hrunatlKnQTu4XkpFRlwJL9ysbB8/mQ/IIpZ2eZKfup51dcr24CxZ73dj
	AOkzYnCwVPHjnrC2tZuUPNcVqI9zzkwZVD6JQpSFc
X-Gm-Gg: ASbGnctbCeDheNF2XMOxOCVIOv45pbOvGBHV3TNjplJYmLqqCp4bq+GsmV9IRtgJ+mM
	nrlqIHNeCm4QM/zBPB8P2n13YqutlZIubFTukLgIuZrMBUnAB+89+UaFex/TAzygyoffs9PUfsb
	da5KnDjfWaMYcNSTkUaBg/lWY1hMHsKcuj7wqUQ+dWqEI3FJhgsrQn3/lqfZvBFqcFmkW2V9XZo
	6jeCzccMx9bDZFYj6yn+Uzs+RoXeMGxDqxqxA==
X-Google-Smtp-Source: AGHT+IFP6oWJuEB+t8FqlHu4nrpKTJN8ggoRVw1wyBCG9QSsTFoeUzkMrBL9SWqFRe5Hi7JIvL+AIijCHTWQWxdq+8E=
X-Received: by 2002:a05:622a:93:b0:4a9:e34a:58a1 with SMTP id
 d75a77b69052e-4af0088e8c4mr4626841cf.21.1754062257422; Fri, 01 Aug 2025
 08:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250731151919.212829-1-surenb@google.com> <20250731151919.212829-2-surenb@google.com>
 <a58759b9-2847-4ffc-914b-c96336385c81@suse.cz>
In-Reply-To: <a58759b9-2847-4ffc-914b-c96336385c81@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 08:30:45 -0700
X-Gm-Features: Ac12FXydoPHt9DYmIUpoqeSH4RwHYO1K7tIS4LC4But0n7b4ZrC_qkGPggvaHZo
Message-ID: <CAJuCfpHsdU5e7+f29ezDXus5-W7jT580YCY0LpErTfKJjeo8zQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mm: change vma_start_read() to drop RCU lock on failure
To: Vlastimil Babka <vbabka@suse.cz>
Cc: akpm@linux-foundation.org, jannh@google.com, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E4C4940017
X-Stat-Signature: kwnkfp1a7k9cgzkwmku8jo4fs5one4be
X-HE-Tag: 1754062258-763550
X-HE-Meta: U2FsdGVkX18w068+6Z24DNoFvJzlohqICUj560uvBkzchHrBFfkfY34eIlfTfCNV9q35KCDQin0mPjVPKosB8Zsp2INUwS0aGGK2rYPpSWBndyaDA2vgyYllC23xytXhal3tXvVWi639gOBXqIAamhyp/V4alFEAl0BYfC08QZDA+6Se7SkMXZKC1c5oP8DurRxMbVuqhEqGfSLHMwfjI//hkFnYGxnU0i+XA7G1rqiW3gGKglBVZgk3XRcoDc14+ogFJiSSjQN7ihfbPNkRQgjMSo268vtSU5Kmmk+bT1RSspPLm4VtwfL02BtS2rJxga6rS1z+qZ3FKCvZDMBFnY2QZwSNha44+chTNXHqe4h+y7I/kdVlDLD4zb9DCmSyV1iAvBXp1JXDXzSsEnlTqqPIYtLUOE7fN4SgUfbax2jI3PlBBteywv6Q/R4Luhc9ekKKL7A3MYBx4C0JjWFwcJwIZgTI5Dz9Po4viqy5CP/IqD/Xn+v/xHcq2L1tjAJm5GIEJIf1qNqCzQQVaS9UhKeWFAhAedSvfj19ZIGajqgJoWvSHAHTImQlkqdvcv64N4hSvij9ds8GJ+1JcniSnvZe14o2HZ7jM14Kh9/fbIM8xYmF1n7eWqL+X1k4xawJFcEBI3YxqSC7MtChZxE1mZPkbsXlyOG5gct6/TEFSw174Q7Y7wwk8prqfxeEAptD63JdErsdwbbKyoWr+dbe+HCaxpWwqDF9VYgdeDA2ZdYwndQu/7VWlhcv8gKGgCv+UpleGl1WcF3CWiPCQ0UzvT9DeFcxrXPlctX1mJT57QHCDlrSxaoCjEStBluF8u2s0nQRvji8mDQT3sNFlauETwR9k5Dhlxb9OElulo3Nt2noKz4ZHFD5u7BxsBQiLlXJH5vIH7hbYkcSnDpCFuuQvQqvbmPfT8djw89X9/AqbzyAPH66WexwfmPQXikX6eqfLOOlruuL3cBIwYzq9wd
 N55u+5wF
 3ljL8i8k8w+Ll9DgoP0rn3u9veId8absLLoFKYrAoytme81SDBa7KV5sjIDGwlRQu6UHxCl3yM7I5YAd7J+N5cPVHqE0dj2T9fTL1hMJDGGiHmLNhjJAvbu4RWE+wlVnZw0xf0uMsM7gdgHe3fC0UxZCIQnYrAzssf8G62zxTqOW3NKIywUFf+8uJPhnzLKr65YWklAiK/wmHthpfjcmxXs9u/w3U4yhe1pLPQ+e+8I6EHOm0II+DT5yXP8sACqa8l3DWsjPFhhdzvYTkMOZNWP1+WFtCwvzPg9U44Xe1yW0mt3AxEAcbX3+J9qu4cft+HWDq5TQK/vPvy4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 2:09=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 7/31/25 17:19, Suren Baghdasaryan wrote:
> > vma_start_read() can drop and reacquire RCU lock in certain failure
> > cases. It's not apparent that the RCU session started by the caller of
> > this function might be interrupted when vma_start_read() fails to lock
> > the vma. This might become a source of subtle bugs and to prevent that
> > we change the locking rules for vma_start_read() to drop RCU read lock
> > upon failure. This way it's more obvious that RCU-protected objects are
> > unsafe after vma locking fails.
> >
> > Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>
> IIRC you considered it yourself, I just convinced you to try :)
>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> I thought we didn't need the drop rcu lock for -EAGAIN, but that would ju=
st
> made it more complex for little gain, so this looks good to me.

Yes, we technically don't but this way it's simpler to explain (drop
RCU on any failure).

>
> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>
> Nit:
>
> > @@ -223,11 +227,13 @@ struct vm_area_struct *lock_vma_under_rcu(struct =
mm_struct *mm,
> >       MA_STATE(mas, &mm->mm_mt, address, address);
> >       struct vm_area_struct *vma;
> >
> > -     rcu_read_lock();
> >  retry:
> > +     rcu_read_lock();
> >       vma =3D mas_walk(&mas);
> > -     if (!vma)
> > +     if (!vma) {
> > +             rcu_read_unlock();
> >               goto inval;
> > +     }
> >
> >       vma =3D vma_start_read(mm, vma);
> >       if (IS_ERR_OR_NULL(vma)) {
> > @@ -241,6 +247,9 @@ struct vm_area_struct *lock_vma_under_rcu(struct mm=
_struct *mm,
> >               /* Failed to lock the VMA */
> >               goto inval;
> >       }
> > +
> > +     rcu_read_unlock();
>
> Would it make sense to put this under the comment below?
>
> > +
> >       /*
> >        * At this point, we have a stable reference to a VMA: The VMA is
> >        * locked and we know it hasn't already been isolated.
>
> Give it continues like this:
>
>          * From here on, we can access the VMA without worrying about whi=
ch
>
>          * fields are accessible for RCU readers.

Yep, will change.
Thanks!

>
> > @@ -249,16 +258,14 @@ struct vm_area_struct *lock_vma_under_rcu(struct =
mm_struct *mm,
> >        */
> >
> >       /* Check if the vma we locked is the right one. */
> > -     if (unlikely(address < vma->vm_start || address >=3D vma->vm_end)=
)
> > -             goto inval_end_read;
> > +     if (unlikely(address < vma->vm_start || address >=3D vma->vm_end)=
) {
> > +             vma_end_read(vma);
> > +             goto inval;
> > +     }
> >
> > -     rcu_read_unlock();
> >       return vma;
> >
> > -inval_end_read:
> > -     vma_end_read(vma);
> >  inval:
> > -     rcu_read_unlock();
> >       count_vm_vma_lock_event(VMA_LOCK_ABORT);
> >       return NULL;
> >  }

