Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAA0FCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 06:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69DE6B0254; Wed, 27 Aug 2025 02:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41DB6B0256; Wed, 27 Aug 2025 02:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30086B0257; Wed, 27 Aug 2025 02:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB0CB6B0254
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 02:55:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 41035139961
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:55:28 +0000 (UTC)
X-FDA: 83821626336.15.6D89D5C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id C694280003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:55:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gjVsfJsu;
	spf=pass (imf02.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756277726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H951FPrfN11rsYQI1Tm2pzxN5bs35kRM3UDLsjJhETw=;
	b=sUihQsarPi4Xfx5l9XlEk2bl3rKKd4pySTGZXMgU+dZVC0UPUIY9KtN80mNrHjo7wzHgVn
	01T+OAJGhP09MHeAmrzpKcUPBpxz4iFZfAyQ7i8Lty8fyAY5pIJZNXOSbBH8zBOvWeNyyh
	ffzW2ZLrB7I9STtF4VHV+rZuiJfbA70=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gjVsfJsu;
	spf=pass (imf02.hostedemail.com: domain of gmonaco@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=gmonaco@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756277726; a=rsa-sha256;
	cv=none;
	b=EJw5k0Sc66ExTheJzCJFONSr1206ji6ART9UntiU2Np0eyLEkCtFjycyIHrR55lon+fkH+
	aa1IsA5+O1lzeWQJZhuKb1nKLk3lpETt7WNwle8H7kWu3PAw1LV/LwdTVsAfztON3h4xoG
	UAi9AWvSH95uSQzEyuYNdcyetb7K+Zk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756277725;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=H951FPrfN11rsYQI1Tm2pzxN5bs35kRM3UDLsjJhETw=;
	b=gjVsfJsuFnLvzNT4ilz8fNmCAoIdeNe+KqqSwma8U5DsUSEQ5JZF6w2kHshstG8zB29S0P
	MoUQjLNnG+pxn0WwnFyiYoIM80YqJUvcI7+veXOTSJftY6XLUjt06rwIDAQ2/lPQnAVoQS
	RF0DeKy5ptE9EwF/Tzy19BeYbrE1sR8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-LWElb9TMN8eDHhx_lK9MGg-1; Wed, 27 Aug 2025 02:55:23 -0400
X-MC-Unique: LWElb9TMN8eDHhx_lK9MGg-1
X-Mimecast-MFC-AGG-ID: LWElb9TMN8eDHhx_lK9MGg_1756277722
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e86499748cso168263285a.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 23:55:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756277722; x=1756882522;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pow7M+fTsSOthVOEOnrZkGfP5h5ssWZXQ1Q2jZT3zcA=;
        b=o6DE0GzwgjlaKEro62g1HSoeXzdH1XETUURVfmrlkk/pzU97bhIT2GzD+5fhBqDVH5
         FTmqo+LF9lH+6V39o2hiHLh5jsXXjv6mp+AEjzvq4KgWg922y2+Lu06XV5Xfqipa2vQ3
         LuoXaCl52umOkxkKEwks1LcBkm0o2jA2MRhH0+9BRJs78oFozxtgygsxbATiSNrmdsoZ
         xaJgY/5Mpvc/9wyPGlG7JDPl+nB5GOBOTTR7PHWYic+fmMRI6coPvoR6Xby03E/QVNks
         PtkdJJHCkBgG7fuPHTxIUeFp+LZHrT9wD2Qg9jh9jgOzUdSeEvSr6MR9vwjDUHole0FH
         Z+Tg==
X-Forwarded-Encrypted: i=1; AJvYcCXyNJ7xRGuLOOMvb1JdumDGVbcuTrFxqix1X0AfNlJz89NGPYyThYP0uupXYuIeRUoejoAAAAwKqQ==@kvack.org
X-Gm-Message-State: AOJu0Yzf69fsHpGG3CjfnreUAEXq1pp/V6CKnuK60x1qc6oPwkk+wVAk
	zF81SaBdwARkskNAPpKbxxPWUBVM4/P9Y0UGTkzcBxA6QMXmmqHIbIf+DnYKITcDQQsv3kBHJOF
	Ie43jlgq38GdZb0OEJXP5Mut0jQuoQg/yGfy5ATnzdX1oM31RSu57
X-Gm-Gg: ASbGncsv58kWfAdVIdz8gWwJOasnkoc/wezAM9Z1wjj5Pt286irBGE5Bybv+6xf+ych
	OsyRYYxxWMUfL7B80DQZ4l8WuDZgxQ6Jtn6W8c/14APzjaStSyvaRW5vV3YXpgpJhvEE4jlDt8E
	Cqg5IKFaHr2UJMGoy/kz2UyYFdbXdK9WKctfUSB/RfvGlrjdJFLGg0ilNUYUdSKwoBI6+vW28hW
	I0mj0bADXHMwLsNRBPrAJAnEuI7P0sitLCD+4Myp35jWRMVFo9l6afHgMfFSU2WqUs8LTSXwywT
	ebNW/52N+eKYl1zV3Eoz9NyX1nnwwRYebKmYO9NOvpRUxQe2g9+FNJZ9lrHvmhwmpQ==
X-Received: by 2002:a05:620a:3709:b0:7e6:9753:d959 with SMTP id af79cd13be357-7f58d941f00mr487402785a.4.1756277722478;
        Tue, 26 Aug 2025 23:55:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG5GbWpLPk9G24jIMJyu1vTYwzxENPmSLw0NmnokCV3YFAqEvFp+wBeuJYDQ6A1ndzrQr8JnQ==
X-Received: by 2002:a05:620a:3709:b0:7e6:9753:d959 with SMTP id af79cd13be357-7f58d941f00mr487399985a.4.1756277721755;
        Tue, 26 Aug 2025 23:55:21 -0700 (PDT)
Received: from gmonaco-thinkpadt14gen3.rmtit.csb ([185.107.56.30])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ebed79a712sm815647885a.17.2025.08.26.23.55.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 23:55:21 -0700 (PDT)
Message-ID: <8620f69a3726e2e818305027ef79605decbd4148.camel@redhat.com>
Subject: Re: [PATCH v2 2/4] rseq: Run the mm_cid_compaction from
 rseq_handle_notify_resume()
From: Gabriele Monaco <gmonaco@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
  David Hildenbrand	 <david@redhat.com>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra	 <peterz@infradead.org>, "Paul E. McKenney"
 <paulmck@kernel.org>, 	linux-mm@kvack.org, Thomas Gleixner
 <tglx@linutronix.de>
Date: Wed, 27 Aug 2025 08:55:18 +0200
In-Reply-To: <d5183516-92ea-4a76-9506-2f7e4da0b0ad@efficios.com>
References: <20250716160603.138385-6-gmonaco@redhat.com>
	 <20250716160603.138385-8-gmonaco@redhat.com>
	 <d5183516-92ea-4a76-9506-2f7e4da0b0ad@efficios.com>
Autocrypt: addr=gmonaco@redhat.com; prefer-encrypt=mutual;
 keydata=mDMEZuK5YxYJKwYBBAHaRw8BAQdAmJ3dM9Sz6/Hodu33Qrf8QH2bNeNbOikqYtxWFLVm0
 1a0JEdhYnJpZWxlIE1vbmFjbyA8Z21vbmFjb0ByZWRoYXQuY29tPoiZBBMWCgBBFiEEysoR+AuB3R
 Zwp6j270psSVh4TfIFAmbiuWMCGwMFCQWjmoAFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgk
 Q70psSVh4TfJzZgD/TXjnqCyqaZH/Y2w+YVbvm93WX2eqBqiVZ6VEjTuGNs8A/iPrKbzdWC7AicnK
 xyhmqeUWOzFx5P43S1E1dhsrLWgP
User-Agent: Evolution 3.56.2 (3.56.2-1.fc42)
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LMtTjxKJKoUUP-iSwR9wqb7kdEDEwi0Sm-5LE4mNKUM_1756277722
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C694280003
X-Stat-Signature: zpbcai14g3qrdif68egqsndjsmdndkc4
X-Rspam-User: 
X-HE-Tag: 1756277725-860679
X-HE-Meta: U2FsdGVkX197ZNg7beEB5Bw1hVIpMYtadb/Yu7P54nUgNGkYzEvwQ1lhpJpGmozckm8f6pBHaFlEjPs99FfW8N0vfY0ynpVY18eyKrTPb8uNxNushjo4SKPlRvVtzZLgA2JEy1S5jliat0QO18ZR+jrDnkYmsYyrgAcpzdlsmqGYb1zDL7H23czOrCLVUHn7TAhqgHPjZsqkRO0B3t3bJ/6fL5rZqp5o34EziMdchbdXLzBRQBXEYB7r9NSTjo8/8o/UZKgGIQjuboGL/oq+tjESuvxvISxYsd2wL1yTuFzsbM283+XNtp0XQvlE3AKKgCzBmpoVrTR8VwUGGJgEXoegIPKQFlxELtS3BrghZURY8qSU5oQZ/GhpKOt02rnEHyvbKjOGbQe2VY6zt8hXA5EUhQH+Fcq2ytbHyqgdOro/L3NHfY4CSv3OQdbrnU2dFuOC33CE63zDmDUh1cW43G89U2e9FEgEEPWUB/7BuEVFUcn4MPzkt+38M5bezl8aKmdUR9PhUjkU9GrpN7a2iRjK0SXgZ6hVXudE1hKbFU87EHf5a+pxFFeIRVLw5FZtutzTt2+HGaPYIoFqnNeTIjyIQV0riFw1W4xD6arHn81h5zcISe/H6yMeBGG4F26MfspFuq0g5LlOdwFoH2zFeT6NgBGRmPBaFzCsDLsGwCq+eEhUExNfZo7fQXvGh03ThWiRK8G0x8XDlb6r5tfnujDgLSqUTCzVdrGPWDM3E2SmN4miqrE153Ak1CnMrJ6tPBDle57J173E1QZqIRrtPqRSGYaZhY01vH8wEZ4DccaT25hAw6VxvUC+vhSFqgpD8bgDcfFHIbBuaJuK/0IXryyVVV/0UXXDRLYAwGArdnmKLl3WsGeR7/5UMt12r82Hp1QTdS90ol+B7daTqsW3dqYAV6dZ2TxhPVF8K4lBcB6e/EX1aOiPH5cQ87NCKJeOldc7HKPZLVewOXl2zsm
 JYLswXY3
 /erGwDd2B2oYGxY78eBztX81Mi3yNZau8rx4nQ6QvDtQs0LXglmTqzG48vjNlF7W+znDFjQGFDxR/wwwIhY1DA6/aDRlzX/dvgHRI7B1nq1BBjYf3hbue/byTTEL36nr0ho9cT1yNUU+JKXGCgaVugcQpjGmPcHk7BqFHrYoajh/GtLjRk7RetVFapiI2/E84DDAz4DkZraZSXLUraX0P8cMNtJgQTwZXprEht2LZT3xyca7cK+6ZabJ6X+1koH9+H5vyt9g0htT3p5fGUpt5VUXXeSvhp5A7kvtwGy1Pt9FTkwaDTIrF7Y/v2IbesuINQlCl3wtcwSFbjGJFsZtXjmLX0fkh339md3Vd/McFqVCTVic4eTV6ANF8HrxFuo2YSATCcvVHzPo4eVYa8Wm3phPmyMatx7Oef0HcdblglSSDT9/rtpAGda8e65hQmINJJU+xbq1tY2D4otuWw7cEx/Jz89yF/c8Enfg6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-08-26 at 14:01 -0400, Mathieu Desnoyers wrote:
> On 2025-07-16 12:06, Gabriele Monaco wrote:
> > Currently the mm_cid_compaction is triggered by the scheduler tick
> > and
> > runs in a task_work, behaviour is more unpredictable with periodic
> > tasks
> > with short runtime, which may rarely run during a tick.
> >=20
> > Run the mm_cid_compaction from the rseq_handle_notify_resume()
> > call,
> > which runs from resume_user_mode_work. Since the context is the
> > same
> > where the task_work would run, skip this step and call the
> > compaction
> > function directly.
> > The compaction function still exits prematurely in case the scan is
> > not
> > required, that is when the pseudo-period of 100ms did not elapse.
> >=20
> > Keep a tick handler used for long running tasks that are never
> > preempted
> > (i.e. that never call rseq_handle_notify_resume), which triggers a
> > compaction and mm_cid update only in that case.
>=20
> Your approach looks good, but please note that this will probably
> need to be rebased on top of the rseq rework from Thomas Gleixner.
>=20
> Latest version can be found here:
>=20
> https://lore.kernel.org/lkml/20250823161326.635281786@linutronix.de/
>=20

Mmh that's quite a large one, thanks for sharing!
I'm going to have a look but it might make sense to wait until that's
included, I guess.

Thanks,
Gabriele


> Thanks,
>=20
> Mathieu
>=20
> >=20
> > Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
> > ---
> > =C2=A0 include/linux/mm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2=
 ++
> > =C2=A0 include/linux/mm_types.h | 11 ++++++++
> > =C2=A0 include/linux/sched.h=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> > =C2=A0 kernel/rseq.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0 kernel/sched/core.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 55 +++++++++=
++++++++++++++++----------
> > -----
> > =C2=A0 kernel/sched/sched.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
> > =C2=A0 6 files changed, 53 insertions(+), 21 deletions(-)
> >=20
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index fa538feaa8d95..cc8c1c9ae26c1 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2294,6 +2294,7 @@ void sched_mm_cid_before_execve(struct
> > task_struct *t);
> > =C2=A0 void sched_mm_cid_after_execve(struct task_struct *t);
> > =C2=A0 void sched_mm_cid_fork(struct task_struct *t);
> > =C2=A0 void sched_mm_cid_exit_signals(struct task_struct *t);
> > +void task_mm_cid_work(struct task_struct *t);
> > =C2=A0 static inline int task_mm_cid(struct task_struct *t)
> > =C2=A0 {
> > =C2=A0=C2=A0=09return t->mm_cid;
> > @@ -2303,6 +2304,7 @@ static inline void
> > sched_mm_cid_before_execve(struct task_struct *t) { }
> > =C2=A0 static inline void sched_mm_cid_after_execve(struct task_struct
> > *t) { }
> > =C2=A0 static inline void sched_mm_cid_fork(struct task_struct *t) { }
> > =C2=A0 static inline void sched_mm_cid_exit_signals(struct task_struct
> > *t) { }
> > +static inline void task_mm_cid_work(struct task_struct *t) { }
> > =C2=A0 static inline int task_mm_cid(struct task_struct *t)
> > =C2=A0 {
> > =C2=A0=C2=A0=09/*
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index d6b91e8a66d6d..e6d6e468e64b4 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -1420,6 +1420,13 @@ static inline void
> > mm_set_cpus_allowed(struct mm_struct *mm, const struct cpumas
> > =C2=A0=C2=A0=09WRITE_ONCE(mm->nr_cpus_allowed,
> > cpumask_weight(mm_allowed));
> > =C2=A0=C2=A0=09raw_spin_unlock(&mm->cpus_allowed_lock);
> > =C2=A0 }
> > +
> > +static inline bool mm_cid_needs_scan(struct mm_struct *mm)
> > +{
> > +=09if (!mm)
> > +=09=09return false;
> > +=09return time_after(jiffies, READ_ONCE(mm-
> > >mm_cid_next_scan));
> > +}
> > =C2=A0 #else /* CONFIG_SCHED_MM_CID */
> > =C2=A0 static inline void mm_init_cid(struct mm_struct *mm, struct
> > task_struct *p) { }
> > =C2=A0 static inline int mm_alloc_cid(struct mm_struct *mm, struct
> > task_struct *p) { return 0; }
> > @@ -1430,6 +1437,10 @@ static inline unsigned int mm_cid_size(void)
> > =C2=A0=C2=A0=09return 0;
> > =C2=A0 }
> > =C2=A0 static inline void mm_set_cpus_allowed(struct mm_struct *mm,
> > const struct cpumask *cpumask) { }
> > +static inline bool mm_cid_needs_scan(struct mm_struct *mm)
> > +{
> > +=09return false;
> > +}
> > =C2=A0 #endif /* CONFIG_SCHED_MM_CID */
> > =C2=A0=20
> > =C2=A0 struct mmu_gather;
> > diff --git a/include/linux/sched.h b/include/linux/sched.h
> > index aa9c5be7a6325..a75f61cea2271 100644
> > --- a/include/linux/sched.h
> > +++ b/include/linux/sched.h
> > @@ -1428,7 +1428,7 @@ struct task_struct {
> > =C2=A0=C2=A0=09int=09=09=09=09last_mm_cid;=09/* Most
> > recent cid in mm */
> > =C2=A0=C2=A0=09int=09=09=09=09migrate_from_cpu;
> > =C2=A0=C2=A0=09int=09=09=09=09mm_cid_active;=09/* Whether
> > cid bitmap is active */
> > -=09struct callback_head=09=09cid_work;
> > +=09unsigned long=09=09=09last_cid_reset;=09/*
> > Time of last reset in jiffies */
> > =C2=A0 #endif
> > =C2=A0=20
> > =C2=A0=C2=A0=09struct tlbflush_unmap_batch=09tlb_ubc;
> > diff --git a/kernel/rseq.c b/kernel/rseq.c
> > index b7a1ec327e811..100f81e330dc6 100644
> > --- a/kernel/rseq.c
> > +++ b/kernel/rseq.c
> > @@ -441,6 +441,8 @@ void __rseq_handle_notify_resume(struct ksignal
> > *ksig, struct pt_regs *regs)
> > =C2=A0=C2=A0=09}
> > =C2=A0=C2=A0=09if (unlikely(rseq_update_cpu_node_id(t)))
> > =C2=A0=C2=A0=09=09goto error;
> > +=09/* The mm_cid compaction returns prematurely if scan is
> > not needed. */
> > +=09task_mm_cid_work(t);
> > =C2=A0=C2=A0=09return;
> > =C2=A0=20
> > =C2=A0 error:
> > diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> > index 81c6df746df17..27b856a1cb0a9 100644
> > --- a/kernel/sched/core.c
> > +++ b/kernel/sched/core.c
> > @@ -10589,22 +10589,13 @@ static void
> > sched_mm_cid_remote_clear_weight(struct mm_struct *mm, int cpu,
> > =C2=A0=C2=A0=09sched_mm_cid_remote_clear(mm, pcpu_cid, cpu);
> > =C2=A0 }
> > =C2=A0=20
> > -static void task_mm_cid_work(struct callback_head *work)
> > +void task_mm_cid_work(struct task_struct *t)
> > =C2=A0 {
> > =C2=A0=C2=A0=09unsigned long now =3D jiffies, old_scan, next_scan;
> > -=09struct task_struct *t =3D current;
> > =C2=A0=C2=A0=09struct cpumask *cidmask;
> > -=09struct mm_struct *mm;
> > =C2=A0=C2=A0=09int weight, cpu;
> > +=09struct mm_struct *mm =3D t->mm;
> > =C2=A0=20
> > -=09WARN_ON_ONCE(t !=3D container_of(work, struct task_struct,
> > cid_work));
> > -
> > -=09work->next =3D work;=09/* Prevent double-add */
> > -=09if (t->flags & PF_EXITING)
> > -=09=09return;
> > -=09mm =3D t->mm;
> > -=09if (!mm)
> > -=09=09return;
> > =C2=A0=C2=A0=09old_scan =3D READ_ONCE(mm->mm_cid_next_scan);
> > =C2=A0=C2=A0=09next_scan =3D now + msecs_to_jiffies(MM_CID_SCAN_DELAY);
> > =C2=A0=C2=A0=09if (!old_scan) {
> > @@ -10643,23 +10634,47 @@ void init_sched_mm_cid(struct task_struct
> > *t)
> > =C2=A0=C2=A0=09=09if (mm_users =3D=3D 1)
> > =C2=A0=C2=A0=09=09=09mm->mm_cid_next_scan =3D jiffies +
> > msecs_to_jiffies(MM_CID_SCAN_DELAY);
> > =C2=A0=C2=A0=09}
> > -=09t->cid_work.next =3D &t->cid_work;=09/* Protect against
> > double add */
> > -=09init_task_work(&t->cid_work, task_mm_cid_work);
> > =C2=A0 }
> > =C2=A0=20
> > =C2=A0 void task_tick_mm_cid(struct rq *rq, struct task_struct *curr)
> > =C2=A0 {
> > -=09struct callback_head *work =3D &curr->cid_work;
> > -=09unsigned long now =3D jiffies;
> > +=09u64 rtime =3D curr->se.sum_exec_runtime - curr-
> > >se.prev_sum_exec_runtime;
> > =C2=A0=20
> > +=09/*
> > +=09 * If a task is running unpreempted for a long time, it
> > won't get its
> > +=09 * mm_cid compacted and won't update its mm_cid value
> > after a
> > +=09 * compaction occurs.
> > +=09 * For such a task, this function does two things:
> > +=09 * A) trigger the mm_cid recompaction,
> > +=09 * B) trigger an update of the task's rseq->mm_cid field
> > at some point
> > +=09 * after recompaction, so it can get a mm_cid value closer
> > to 0.
> > +=09 * A change in the mm_cid triggers an rseq_preempt.
> > +=09 *
> > +=09 * B occurs once after the compaction work completes,
> > neither A nor B
> > +=09 * run as long as the compaction work is pending, the task
> > is exiting
> > +=09 * or is not a userspace task.
> > +=09 */
> > =C2=A0=C2=A0=09if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD=
))
> > ||
> > -=09=C2=A0=C2=A0=C2=A0 work->next !=3D work)
> > +=09=C2=A0=C2=A0=C2=A0 test_tsk_thread_flag(curr, TIF_NOTIFY_RESUME))
> > =C2=A0=C2=A0=09=09return;
> > -=09if (time_before(now, READ_ONCE(curr->mm-
> > >mm_cid_next_scan)))
> > +=09if (rtime < RSEQ_UNPREEMPTED_THRESHOLD)
> > =C2=A0=C2=A0=09=09return;
> > -
> > -=09/* No page allocation under rq lock */
> > -=09task_work_add(curr, work, TWA_RESUME);
> > +=09if (mm_cid_needs_scan(curr->mm)) {
> > +=09=09/* Trigger mm_cid recompaction */
> > +=09=09rseq_set_notify_resume(curr);
> > +=09} else if (time_after(jiffies, curr->last_cid_reset +
> > +=09=09=09=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0
> > msecs_to_jiffies(MM_CID_SCAN_DELAY))) {
> > +=09=09/* Update mm_cid field */
> > +=09=09int old_cid =3D curr->mm_cid;
> > +
> > +=09=09if (!curr->mm_cid_active)
> > +=09=09=09return;
> > +=09=09mm_cid_snapshot_time(rq, curr->mm);
> > +=09=09mm_cid_put_lazy(curr);
> > +=09=09curr->last_mm_cid =3D curr->mm_cid =3D mm_cid_get(rq,
> > curr, curr->mm);
> > +=09=09if (old_cid !=3D curr->mm_cid)
> > +=09=09=09rseq_preempt(curr);
> > +=09}
> > =C2=A0 }
> > =C2=A0=20
> > =C2=A0 void sched_mm_cid_exit_signals(struct task_struct *t)
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 475bb5998295e..90a5b58188232 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -3606,6 +3606,7 @@ extern const char *preempt_modes[];
> > =C2=A0=20
> > =C2=A0 #define SCHED_MM_CID_PERIOD_NS=09(100ULL * 1000000)=09/*
> > 100ms */
> > =C2=A0 #define MM_CID_SCAN_DELAY=09100=09=09=09/* 100ms
> > */
> > +#define RSEQ_UNPREEMPTED_THRESHOLD=09SCHED_MM_CID_PERIOD_NS
> > =C2=A0=20
> > =C2=A0 extern raw_spinlock_t cid_lock;
> > =C2=A0 extern int use_cid_lock;
> > @@ -3809,6 +3810,7 @@ static inline int mm_cid_get(struct rq *rq,
> > struct task_struct *t,
> > =C2=A0=C2=A0=09int cid;
> > =C2=A0=20
> > =C2=A0=C2=A0=09lockdep_assert_rq_held(rq);
> > +=09t->last_cid_reset =3D jiffies;
> > =C2=A0=C2=A0=09cpumask =3D mm_cidmask(mm);
> > =C2=A0=C2=A0=09cid =3D __this_cpu_read(pcpu_cid->cid);
> > =C2=A0=C2=A0=09if (mm_cid_is_valid(cid)) {
>=20


