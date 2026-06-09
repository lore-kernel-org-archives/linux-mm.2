Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7647CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:13:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C3616B008A; Tue,  9 Jun 2026 13:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A456B008C; Tue,  9 Jun 2026 13:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B07B6B0092; Tue,  9 Jun 2026 13:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF68A6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:13:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A6EDA06C2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:13:18 +0000 (UTC)
X-FDA: 84861020076.17.847309E
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7A9FC40014
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:13:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPjvJ1B3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781025196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NodRxI3YJX6R0sNnZQ3DKxsEFXXpQE4gpXdGBbhjZc=;
	b=heWEz8kFc+Jd1DPYA/aRh/psso+JXm9mGWpFwTaRzugQvLNk/mrP37Y48EqpiM2CVK/AAU
	Tgdm0yEdDyXG8PHRKaRKgMsSHa8lFKUPYY1njPSc0bVq+PnzJSOAir/xPD9xCWi9z38Pha
	0q2WxeaD59jhzJ/AIPR7/7onckI1uDg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TPjvJ1B3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781025196;
	b=VsN9IUJWrEyQwXOteSqCPTbRLJCP/7piJ79MwLGjIPwsm6uc8uBdP9ZUu4J/Yd3gylh/J6
	Fmlq/6UeEzpskn2jKLtZ1+Pfe+iqL3QuiC/Z/5pmXZQossVMsyD+UzwfdwTedo9AtRokrB
	gat/ex2kNdDu1kExmb/JpM182g75N0s=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5177d1ff061so2429101cf.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781025195; cv=none;
        d=google.com; s=arc-20240605;
        b=C7cKDM9mOFZEJHAIHIJlJQHIPsfTzO9tp4+8rGhRqY3BwR3nQEPVPir4Ps0PxEh1dJ
         WdN8aP5bYNvWoyG3UkjbRy/sZQWFnqLIPrT2suQKI4iL/hopjtBAc8nh68HiO2A8QTVq
         1JqiqX45g4Y+KcZV3qQR0EPFzlxMZnUlyYJbA/pMGfc9nfnSM4sAueJQrMYjEruq2MYA
         7a7uK3EF9MsZuRLSlY3p3SVPTZdj1he0yXJ2wC9KmfnP1FZ9+JPN6cK3MTKbTm9JDmWK
         1ADoLdZQ6I/IoJcwmO8Typ+inU45yHUyPs6TOgllrfezi/bSgEiAC9uaBXGMbSj0hTUb
         aNDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+NodRxI3YJX6R0sNnZQ3DKxsEFXXpQE4gpXdGBbhjZc=;
        fh=0axuiK9SWiRSwUXGaWJsa5RQrlum5Zw4osmhcdHGzxc=;
        b=Z3BhCshKvCCmQW8kkEyGnUKEc6gcGKKmuOCkPJxxvhZbrT7HW1TsKUeUu0arZ4YYO3
         xNt1O/qcd+eexlSyjEMjJmFgcOS6BupYuZHz5XADX+Pf4ubpfDnE4EAcv8+3CZV420XT
         zZFsEMg1MzY4iX9ghgu8mmtAtjY/6kcLOj3LQIGWv3444PM2wLuj/pP4EJVxBdX201Xi
         N+zgRB+0xNOxOZzQoJC6JW1hFP3GKwQzvk12NEcWPBoCAtE+nGdXb3wuqgRIEmeCP6jC
         0F0VR7t/pn7SCnCchs37QvGHY0EThqyjTwx5LEqqxZqTYIDte7O+D/SlmWfvqwJBxZ7w
         mtBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781025195; x=1781629995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+NodRxI3YJX6R0sNnZQ3DKxsEFXXpQE4gpXdGBbhjZc=;
        b=TPjvJ1B3rudiDuvBL6kEFY2lYC++Y3fy8WUJZfqaRm5MdFbOAfo58pPR6pjqNu04Sx
         Hb9XbO7DsiNXUIlt91w9NiPHKskG6to9xpL32zP3vUvVLsjDa0iWHehI7gtdmaDWqr1z
         cDznXQ9OLpMVSL3n089xLim7oipUHLaa9R+VLDGkv3+k6h1MaDPHfCtdoMT2aUcdVolM
         2xntqLMN0HfXXHwCdb8Ngi81LGUYIWbfAcvDdKQPpxS26rjqWbULXoOPYZp0HIxGl5rN
         S5UA52ueUx2g6MlWPd6gGYk2R7MZ113+DJEQDxMu4JgpZntLWIbUDK1ydwjR0HqeLcyp
         J/2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781025195; x=1781629995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+NodRxI3YJX6R0sNnZQ3DKxsEFXXpQE4gpXdGBbhjZc=;
        b=BdKU5LQd0JGbJs1yMORDqSPn3dXtpu560AiGOebShso4LkV6hpvmU0H/tK0zvlp2ZK
         kpI8ERy/Pfl/leRcNyddiUvk3qLs9LSLsNeinBULGL47GaRCb4ayaFNEAZLT7OKHzQT+
         M482WJaQlOCvC6UIzvA71NHULoQZ05xSytWyaNw4u+DRIA4oKFxSvv7XC55efNa7TRLq
         W3pdLxRkhLNDShcBn2mBck57xkwoGgl7klmInkDgSIDwBZYYltrZHlmLUXbbvhgxSsLr
         ognSSm+lovZZn2W13dVlVe0BpG9FPGKyuVYXBRFIKUPPNV74PVYyNQUw/GBpgB+/+HHE
         jBDw==
X-Forwarded-Encrypted: i=1; AFNElJ898w94A5l+8dpBiA2ZlSX8sEMVECN34xKAukRhh06ibRwEzl+Y+ndijzQxdt6YG0WvxkqM3nU1lA==@kvack.org
X-Gm-Message-State: AOJu0YzzKy+qXaW7ixJVyHlyzpvc9KrUm254izn/UFQ/z3lKh8Xg3lFL
	7ucA1je0l8jRwZEzbnK8QITOgAMfp/bUDAwSaJdLm99PUDV6C9YFW/msrKFrU6Ys5qerNREcE4j
	lncSgKvzkWcH/W3q1nkj3OXyZLp+jT3qcMX0uEb+e
X-Gm-Gg: Acq92OFruDp2gPAbwp0+7LDnYs0wgFS5iypSv1YjFfrlrGkglEygN3oZ1YTNe6rySpK
	pG4gK9C+eNg2yFwfmUmPSq+lsyoRRDu5cLB4Af37BtS3Ohkw4Xq3bvD/NGQBgZi5ta8zz/l8ias
	LSqUngQHaRQuMlTn9LD4/N/B0Yig05IpF4kMyG0gxp/9x3IhQ4BN7KHk7crBIWW/5TKT82BPWFF
	iGCb4hP5rzOQ/9ic65dWdwoyYMeDhB7Tq8je+uaSJsVK/LJ5mm9z/1t6WMXu9w1O/hDOElaLyTz
	WS4hQqFnCq6uCpsrH17cdpGPOodqaBzb5ALZsLbVRPOEzHBAF1anZEUE5hU=
X-Received: by 2002:a05:622a:eda:b0:517:6dc0:698d with SMTP id
 d75a77b69052e-51797f67f73mr37747371cf.0.1781025194743; Tue, 09 Jun 2026
 10:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260606015729.1837935-1-surenb@google.com> <aifEZEisSFABmYiW@lucifer>
In-Reply-To: <aifEZEisSFABmYiW@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Jun 2026 10:13:03 -0700
X-Gm-Features: AVVi8Cc11jTgQ-bPSJkt8toevaR0OaWZcsAO6_AhL8y9iGLJOxbwkljrmIEXYfU
Message-ID: <CAJuCfpEvAPPm1RSOpXvtsYUi9hr3j0ST098k2RF8pUp7J7RY5Q@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs/proc/task_mmu: change lock_vma_range() to return
 error code
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	david@redhat.com, willy@infradead.org, jannh@google.com, paulmck@kernel.org, 
	pfalcato@suse.de, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hwxh3jyz6yzwdsn6qcc88sugn5grb3id
X-Rspamd-Queue-Id: 7A9FC40014
X-HE-Tag: 1781025196-830298
X-HE-Meta: U2FsdGVkX1/RCIfqzTRs+QLP+JqNjg6AT6MhG/zCS5HXQa0B2NPy3oFORXRxjhp/8IIZD8EY5IZ356cgPg1LbdMub8f7Tol22pwswFT3jM1ViPG/v0MWhyrlhOnNXQ1Y2JTRnJcREo1L2h0X9YCl4gVFAI99edtovmUlKwdPupDQo2tvSCMQlhk6W5iXb1CIiBnqpQzasG0kFVQtjw8LZ0aa13jIcy6TMztWWOo7TyR4kuVa+pOiXyxaeDwLYTH8eWfuDFKqJI308pZ83IUTNMnup5Qv4neGtaPMi8wtXLpDukiwoma1m+tXMg7CqXUwEatf2O4ocX9LgYpAHGvBoc82S/tIweVyyy0Gdo7ryoFi+G/9gHTgPw96l9zOGW1iCjXyolXbSdPIOmjQHNUi3FQj4Pa0KfgHT0nyNlvLoAsqAnhOqkqou51XTgHy5T3g4bD8qt8JmghxHrtviBMeclBoq8Wbej0s8xa5MJ7wqIaK2dTRZOfTWUx+7pVlCiuqThT8y/oiqFJO7Jx98Zp8jr8UPYA6rw5CbpI07FX3HSuVmg3PMsZ9Rx2HsMW0Elbf2qd+sXYcLZ9CXXpLv16T89Sup4yCrekSWOhtn8D2k/T2jnna0h9ZrvyYylMkIDNlI+MVY9RjWsqqtOoFm/f5A8KneWR7jsd7k9YBCd+HzbELnP9ff+LRt5Ibno3KBP7Rf8AFY4RWCLt0hmprNDVTq33qAOicCtyGgIKM0K6i4Rk0AIPt2EZQF2l2mKw+R4wzQw7DKT1TQDhYEtEYawC5y7xN7eDjTZxbmKs297ZZsPTa7I/35Cyr/EQX1FvBykZTwLQyYcWj0hu5lbs5jWJnIFqcGNp9MyZuORPho9ema3g/ULDE0pH6ilz/canLh2l9CmIzFTHyWepXgK4+qRpMGMG2He11KM//JpAS7OlEz7IpBFfSJfDH+OGW2IMsjeH4lUFf+v8/Fw0VDuiGIwq
 qsapeuCo
 GZR/EnFKta3fWb9WQFa7Ryh42ojkE77mwkpg2n1DQQFtFQ2JOHhZwtBtDqwoW5W/Wsjms8hCjeSs7IVV2+IsPb1q0ZGvad7wTJBk5bsh8l+mWoE6xo1bBLQzJraZp/0PfVCK/D3Z7twJQgfM0fKIajDcTJOlO2xqnAbmpg1Tj0xxLiiEl8xONDrQ8X+zlSWqHuvMPdgSNqLDPGcxVwKFXW86Y3hISrVAxpjxDYPYl00wO2kWBTRC8HchZjdImK5oBcJV7loLjLtOOsdyKo2f08PTvnv23Qji9NsET25S5pZ0IVJmXKU+8cu5nUl6b2YBpuALE3epSHzezXMnrjf3b2Hqg5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 1:28=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> wro=
te:
>
> On Fri, Jun 05, 2026 at 06:57:28PM -0700, Suren Baghdasaryan wrote:
> > To correctly propagate error code from lock_vma_range(), change it to
> > return the error code instead of the boolean. This simplifies error
> > propagation code.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Logic LGTM, couple nits below, but:
>
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thanks!

>
> > ---
> >  fs/proc/task_mmu.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >
> > diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> > index d32408f7cd5e..023422fcee12 100644
> > --- a/fs/proc/task_mmu.c
> > +++ b/fs/proc/task_mmu.c
> > @@ -162,13 +162,13 @@ static void unlock_ctx_vma(struct proc_maps_locki=
ng_ctx *lock_ctx)
> >       }
> >  }
> >
> > -static inline bool lock_vma_range(struct seq_file *m,
> > -                               struct proc_maps_locking_ctx *lock_ctx)
> > +static inline int lock_vma_range(struct seq_file *m,
>
> Could drop the unnecessary inline here while we're here.

Will do.

>
> > +                              struct proc_maps_locking_ctx *lock_ctx)
> >  {
> >       rcu_read_lock();
> >       reset_lock_ctx(lock_ctx);
> >
> > -     return true;
> > +     return 0;
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > @@ -245,10 +245,10 @@ static inline void unlock_ctx_mm(struct proc_maps=
_locking_ctx *lock_ctx)
> >       mmap_read_unlock(lock_ctx->mm);
> >  }
> >
> > -static inline bool lock_vma_range(struct seq_file *m,
> > +static inline int lock_vma_range(struct seq_file *m,
>
> Same comment as above.
>
> >                                 struct proc_maps_locking_ctx *lock_ctx)
> >  {
> > -     return lock_ctx_mm(lock_ctx) =3D=3D 0;
> > +     return lock_ctx_mm(lock_ctx);
> >  }
> >
> >  static inline void unlock_vma_range(struct proc_maps_locking_ctx *lock=
_ctx)
> > @@ -311,6 +311,7 @@ static void *m_start(struct seq_file *m, loff_t *pp=
os)
> >       struct proc_maps_locking_ctx *lock_ctx;
> >       loff_t last_addr =3D *ppos;
> >       struct mm_struct *mm;
> > +     int err;
> >
> >       /* See m_next(). Zero at the start or after lseek. */
> >       if (last_addr =3D=3D SENTINEL_VMA_END)
> > @@ -328,11 +329,12 @@ static void *m_start(struct seq_file *m, loff_t *=
ppos)
> >               return NULL;
> >       }
> >
> > -     if (!lock_vma_range(m, lock_ctx)) {
> > +     err =3D lock_vma_range(m, lock_ctx);
> > +     if (err) {
> >               mmput(mm);
> >               put_task_struct(priv->task);
> >               priv->task =3D NULL;
> > -             return ERR_PTR(-EINTR);
> > +             return ERR_PTR(err);
> >       }
> >
> >       /*
> >
> > base-commit: e178a530a81621a29efbca49b3b78202a18236e4
> > --
> > 2.54.0.1032.g2f8565e1d1-goog
> >

