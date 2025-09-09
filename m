Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18AF2CA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 16:28:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7292B6B0007; Tue,  9 Sep 2025 12:28:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7013B6B000C; Tue,  9 Sep 2025 12:28:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EFB28E0001; Tue,  9 Sep 2025 12:28:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8756B0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 12:28:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE9F65A606
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:28:10 +0000 (UTC)
X-FDA: 83870243940.19.366775F
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf01.hostedemail.com (Postfix) with ESMTP id E9D0E40010
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:28:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pyOowhvO;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757435289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9R024uDMeRukjQhwtWzFLUPKWOeALqxj2j0IhsvQc40=;
	b=MQVhZHAx+7RJaCWwyGkkX+g3DhXRX3yeRWRMekMIdPyDBCfgPi/TrzRY6lVwjC1BKapuiw
	2nbsjkU5XtSwVGyJ8zYZtdhyk0mfKHpmMA4kVv6inrNCn8aNSX0cRHI2OKGKELxh5CCpnH
	e74TNNm9FqWXhyAmQOGIf0HtMI2usWY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pyOowhvO;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757435289; a=rsa-sha256;
	cv=none;
	b=CyTHSwcyhBPWgwOh5UENOQHybBjPL6nhlJ1LTvWZPtYN9wdkVsQdaJeJsf64cJD0S6wjoN
	0nYpQtrFQrddTCtU6LHo1DxIPnMS1J1E/fWepuTOt6t6BT1EhECXk+NQTSNKxIlscUinXm
	PEiI9+YphiDpfgwNkUs/Y2adQK6YEvc=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-61d14448c22so29922a12.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 09:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757435287; x=1758040087; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9R024uDMeRukjQhwtWzFLUPKWOeALqxj2j0IhsvQc40=;
        b=pyOowhvO02+Mnw5SJih79Angw6hdGoDT0hFj9h97MunvPhjGnQtKE+Poc8g7GDiMQT
         cWlOvJwDxV/kvPBprSw/di3ZmLiv3aNt+RmxUEM++Bcrqk0Tt9fA70a9XH3ioCjNmF4m
         Z5FjNv56hlWAHJ2RW/exfUe3H5bC+FBWTt3jZpzv2nJK9Q0vLtBOUw/fRqotsk2PviHG
         apOnuE7SOjHQ2USJyJrvnM2hsh11YgP9xs/8LQ4Dw9318YtRJ59xH9E6Sqnoj8+cb3Ia
         7AO3/IYEgHw1Cm0y1iPGNNOGzc0+fpzDy1QY/nCnHABiaIgmxDjJMEs/vkDf9ACUrDU8
         gvsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757435287; x=1758040087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9R024uDMeRukjQhwtWzFLUPKWOeALqxj2j0IhsvQc40=;
        b=VpQDsAYU1Gq/MQc8Ktk3K/DPdQ7QY+4Bya3AkQd4Al0KWv564xxvfqnvdYUhrrIxaM
         nQQqV3XJ1zzFalb0LEkvGND4OeyGkX7Z8I6JedF7vE3aEswEw50BQA1h/dc9KM8NRjfO
         T7dT8nEPxUD8P9Ih1nOp4oTiJqagepaPNJi3nhGrjROGg6zsxF0Zr6y8/rLg9+F6orar
         mDKas1BB0DkN/PxlGpSBzIL2f9+t8umSjq8lw2VWHZj95KLF5KEKF60MaaVrMG0r4IE8
         L0uozWzY0Larb/q17rIrDaIeKuvmiphGvAln5XVNH0g6FEuMDdZtkZti3RRbtY687GcO
         /YmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtHP13S08H+rDkSGwzxrXNCB7WYsx5n6NfpaHHk6XHMdxK6B7NT7W8NrxBwi6xXZYGt8cJk626QA==@kvack.org
X-Gm-Message-State: AOJu0YyK71L9Uwkt1fp+htg9wSZu+GknBhTskDalIFmvyRvb+O0tb2p5
	NSQCWx4yNIDjuWQKHG3Xzr7LmifeO/v+EYvGpxYKmB9Ocvm8c3EhIrH+U7YC4rnC4npEb+0Z8qO
	a45PgT5BTsPnY5WFLy/HJU6HA+wyRs/b5lrwM1ZLc
X-Gm-Gg: ASbGncstiKifTRf6YKn305NqdXQjt15nSQmVWDp4QuI6l0+DKveiNhG0oJay/ra+OTs
	IkGGP4djuHVNmIOZBRI35h5ud7BsxfLVuwhDIcyUUJzYk8cuFix3nK8+9iwOP5UnVfLCAx0Yro8
	F5AVsCgAS12ShqALcykxAY5Q+3S9AsdEJWFcBRDgEWcZD77YkDC5nMmwyFgtERBFSjtgxgWi+NO
	RET7f50LXXox5+39P0SkHIPcJsbshXFukEiwL03IfWQFka6SkuX9GlDF69n9d6/9Q==
X-Google-Smtp-Source: AGHT+IH1Uhhf5BBfeDF4zGZtlC1s5NP0l7OWMVfHhYq8xDWfI1CfOUPWiiaKNAZGIlKbmXINaHykxfFIYVTCl7rGdqk=
X-Received: by 2002:aa7:c507:0:b0:61c:d709:ce04 with SMTP id
 4fb4d7f45d1cf-623d9478b3fmr319884a12.7.1757435287275; Tue, 09 Sep 2025
 09:28:07 -0700 (PDT)
MIME-Version: 1.0
References: <20250909090659.26400-1-zhongjinji@honor.com> <20250909090659.26400-2-zhongjinji@honor.com>
 <aL_wLqsy7nzP_bRF@tiehlicka>
In-Reply-To: <aL_wLqsy7nzP_bRF@tiehlicka>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 9 Sep 2025 09:27:54 -0700
X-Gm-Features: AS18NWDWAZ00qKFjmQMW4k7CpwsD03ZtkPqLFv7mxnsJUQMHeeHkz3WbdPRJr34
Message-ID: <CAJuCfpFCARoMJ8eniYdZ3hSaM_E3GvfRBV1VD1OohOfJpP87Hg@mail.gmail.com>
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for
 thawing OOM victims
To: Michal Hocko <mhocko@suse.com>
Cc: zhongjinji <zhongjinji@honor.com>, rientjes@google.com, shakeel.butt@linux.dev, 
	akpm@linux-foundation.org, tglx@linutronix.de, liam.howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, lenb@kernel.org, rafael@kernel.org, 
	pavel@kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, liulu.liu@honor.com, feng.han@honor.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E9D0E40010
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i597gc1rjaxw4tpj6kewbz4icict1u8t
X-HE-Tag: 1757435288-448055
X-HE-Meta: U2FsdGVkX18ZaxwGxIDG6bylSmEA9/AE4GiCX1E3nbV5UXE3wZdjxm8Eq2TG/1hqXHB4a2P+W60MPJcnUctSsY0XVVe4umlD3ODZAS2i1YcJM5auVHi9RKAvaQm1yMKtRWHvibazxohnr4fbDTwei51GSDtmXQLnFftI3Suga8kQsXkAHnxBQ8LDdDSinEyNqnNr/MkDrrd4uxHz6Novtrc0oUBkvgw55pvJVrfzVAbef8andluQoNa/z8gJK68bgKg5tm6rQfeAI6SF0ffmG011lFfEjyvnknYkyN+oPzD1b6bDdExro3xdmA0ZIszn906AMjrxMH5MqkivSk0nw4R4MbuHq65LPkd+80ulfokatuyJQbHMtxh153f3ZFyCBS2TbNYsYwI2OxnSfDY2LGbDy+rM7k3R6vDMttrgXqYkhekDesFvWwoOcf7peWm0yXaAYW4uOECzIdtO0dkBFwlIsZB/KxXoZLlkzQQfHyaJi/Q18cMMi1Z+p4cc69Xl+YT2OasDMblYpBpI+ZenfLelskHMKlF+jPaqdh+pYYRRQ5AcRitLiiwADSnfG2czT9DpYQcC/BoBzYVflO13CTnnp42a13siWcLBpu4Xd07T3agVMzWeB6/5DMPjY1ZpEzEsQgNywprjGiKWLHiKuTbArKmY9sSPu0VZqh+LW8Kw8esO6gxJD7mWIb6MCAh99WOiATMEK/MSSr8LhS7WWEeiE3CpgCc68u+1O/srB3ebY9pbVm4g02lC5SSw5TtEAKj9umcXQDR94lCVb8jV3WYSUqjwR4b+2NHrWv6Q4ihO+IhZ52MZx3jPnsqtiWpYxYPgXcChncaTpePmGCB9zzfsfrt89BvxGoCLyqhenZC3DUg/6qqTjLfZfS04uRHqJLICMjqdlEL28DIGYC0Z2wEQRNuodIHUCM31tjnv8WwpVwUKfN6dUV8SUCngcK1k76GbYVOoU9H80z/CUi+
 txqCevIC
 LIsJfHL4WqoEmj6piAQIXowglZTiqP9TOmeziU4rsCGd+Asn42wfQrzqG6YJfxK6gVk4M1HvCImCSBfDMIhJzyWWytLTmBT/aHU8nDVudYbIdS6VUQmCloYAqN0+RzC7uDJ8BV552CxHRbboBO7Wg1s1y3MsF4kCs1oOfQQCMFsssJ4KyoUghG16tnTsZGozOHm++GZN84gp2s+TgpnxJAtxieHEJaLvbxQjehyXJdQcvDmwO/7Xfp24Lxn4kGjn1oyr9xGAjo4TJ8qcW2u7R/CbRsxMzDuD0pM+XUH8tifvhkLCTKuQ3fWgtlmLKwq7rTrIYufQ7YTOruk/DA99KPvMgVwgCfxsw1mWWMVtNSHPdoSQCZ7H2QDjNz0p6Y1YY/ZhLGtls5oVHZqs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 2:15=E2=80=AFAM Michal Hocko <mhocko@suse.com> wrote=
:
>
> On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > OOM killer is a mechanism that selects and kills processes when the sys=
tem
> > runs out of memory to reclaim resources and keep the system stable.
> > However, the oom victim cannot terminate on its own when it is frozen,
> > because __thaw_task() only thaws one thread of the victim, while
> > the other threads remain in the frozen state.
> >
> > Since __thaw_task did not fully thaw the OOM victim for self-terminatio=
n,
> > introduce thaw_oom_process() to properly thaw OOM victims.
>
> You will need s@thaw_oom_process@thaw_processes@

Do you suggest renaming thaw_oom_process() into thaw_processes()
(s/thaw_oom_process/thaw_processes)? If so, I don't think that's a
better name considering the function sets TIF_MEMDIE flag. From that
perspective less generic thaw_oom_process() seems appropriate, no?

>
> I would also add the caller in this patch.
>
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
>
> Other than that looks good to me. With the above fixed feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>
>
> > ---
> >  include/linux/freezer.h |  2 ++
> >  kernel/freezer.c        | 19 +++++++++++++++++++
> >  2 files changed, 21 insertions(+)
> >
> > diff --git a/include/linux/freezer.h b/include/linux/freezer.h
> > index b303472255be..19a4b57950cd 100644
> > --- a/include/linux/freezer.h
> > +++ b/include/linux/freezer.h
> > @@ -47,6 +47,7 @@ extern int freeze_processes(void);
> >  extern int freeze_kernel_threads(void);
> >  extern void thaw_processes(void);
> >  extern void thaw_kernel_threads(void);
> > +extern void thaw_oom_process(struct task_struct *p);
> >
> >  static inline bool try_to_freeze(void)
> >  {
> > @@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -EN=
OSYS; }
> >  static inline int freeze_kernel_threads(void) { return -ENOSYS; }
> >  static inline void thaw_processes(void) {}
> >  static inline void thaw_kernel_threads(void) {}
> > +static inline void thaw_oom_process(struct task_struct *p) {}
> >
> >  static inline bool try_to_freeze(void) { return false; }
> >
> > diff --git a/kernel/freezer.c b/kernel/freezer.c
> > index 6a96149aede9..17970e0be8a7 100644
> > --- a/kernel/freezer.c
> > +++ b/kernel/freezer.c
> > @@ -206,6 +206,25 @@ void __thaw_task(struct task_struct *p)
> >               wake_up_state(p, TASK_FROZEN);
> >  }
> >
> > +/*
> > + * thaw_oom_process - thaw the OOM victim process
> > + * @p: process to be thawed
> > + *
> > + * Sets TIF_MEMDIE for all threads in the process group and thaws them=
.
> > + * Threads with TIF_MEMDIE are ignored by the freezer.
> > + */
> > +void thaw_oom_process(struct task_struct *p)
> > +{
> > +     struct task_struct *t;
> > +
> > +     rcu_read_lock();
> > +     for_each_thread(p, t) {
> > +             set_tsk_thread_flag(t, TIF_MEMDIE);
> > +             __thaw_task(t);
> > +     }
> > +     rcu_read_unlock();
> > +}
> > +
> >  /**
> >   * set_freezable - make %current freezable
> >   *
> > --
> > 2.17.1
>
> --
> Michal Hocko
> SUSE Labs

