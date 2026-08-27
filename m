Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EDF9C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 13:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4515F6B0092; Thu, 27 Aug 2026 09:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402166B0096; Thu, 27 Aug 2026 09:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAE56B0099; Thu, 27 Aug 2026 09:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F315E6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:13:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 83E961A0400
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:13:09 +0000 (UTC)
X-FDA: 85147090098.16.DAA7546
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id C48584000D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:13:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q3RH+HA3;
	spf=pass (imf27.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787836387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YyQH4Zg7pq+6kxETlvUNM4xdruhUnmakMDW16/OuM/o=;
	b=BY293fuEM57Pj4hn3se0OYdGUCO1J0EUnp8nVh2EVSaUblh0EGwmMDZuxl27FTcRP0Fq06
	k9nGuagVVB5EomN6oMolWWa1wfjpxS8frJpF65n9iA2ddvrkEM2h0JYg5PN8ZKNKhRnKqU
	p7xr8DZ7AlZEWkdoezHo9Uw60rWUfP4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787836387;
	b=B6DniSBmZEiphzZdwT1Ab+b8kRJH2IslkLA3YGmcDb9fIt67mx+PKAX0sJTBpwSDYfAeqi
	IzzRRLnsbuj8bB18VPIY43ywpjuezv1vAUnF8gFU1paSEviAf371t05AZZoDGFk9AveXy3
	jnEexlTeEKlA57+dJBo6k18aQ/gLLEI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Q3RH+HA3;
	spf=pass (imf27.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-84e84a6c4bfso1031768b3a.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 06:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787836387; x=1788441187; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YyQH4Zg7pq+6kxETlvUNM4xdruhUnmakMDW16/OuM/o=;
        b=Q3RH+HA3KV11f5GFVnhtwCjhAQiTaRpOXQKjTd4ppz3Zzn9zFAN2DJXmVeyD8xwAl5
         7svV372bSGg3hE/tNqHZpJJ/aujmDpouh4LfiXrLJENaX5q+Q4cjLBg/bK+HLWL4h8+M
         CXXmtfyNuqDy13O5709Zyut68DKTAKeuRA4sFqoeFz760PQnKCwGkFGwJcafPPW5Q0lX
         TRM28FZ5mKuwUOUKCmDL3oDA2AgY5dhnLRY7LVUlGUaQwMEEu7466pxkOUNwT5sKNx7W
         nO4wgx1rMW4cAyoqPNmlGjumxFUmJVt7vOyDhucicfLP6fe22PiglwBUAVAEw2Ttx6FQ
         /rSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787836387; x=1788441187;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YyQH4Zg7pq+6kxETlvUNM4xdruhUnmakMDW16/OuM/o=;
        b=E9YB9jTx47c1riu+6YuebZH9BnCl4eQivAvSv+waFURUE4HcpSFzCEUM26bARAeO4K
         DyyNPVq+PZiEnp5qaLd1H2Th/rFjBr4Qr18egvcsZ7UNg4WhtjVjbkMNHpfjVFluC8Lb
         FrF3vYVLYquXZawGWAYP4VkVtRAOSAobO62mE48tVZUKj5rc87WSZwKVUm32+OvCv1cP
         5WN7QOGxupJmYiJwhlJvvqtAxtSq0r47d90nTbWTLuTJGDiEKiaskTVmjmT0ArekAsWE
         PDpJ4dE0vCxrT3cuv5Ix+dpfgi8IUVTJ+86p0ajHXlpWOtgrLce0EhSqQegO36Z0P83y
         tEPQ==
X-Forwarded-Encrypted: i=1; AHgh+RrfFpIDtBhQI5LikAS+A/r6fo+hhJ5DVdQ6zIgJevhn3U3JKCZ0uDdGNN0Qx1KG8jbEV9AoP/rPGA==@kvack.org
X-Gm-Message-State: AFuF++ngh6uxDIOgPIt1+ZK5Z6j5IIjVW5k2HK9mJkb5mJGty3mTLZga
	3oSjbD68BsQcIynjerd7JpNTdsPvIe9cSbYgItL9IY6hTXf98UBGgXre
X-Gm-Gg: AR+sD12uFze9uR+DQDf0as/rw6rbzqrgd+kZUvvK8votGwY2505DWZ5GeRd8mkwkDTo
	tDY4Vu8mkC8P2jBhPLFY42rnn/b+96lHE0TwBMAljryoKTORK//C9M4r/dMzk03s1aR2SZU5lqy
	iQxRW42K8h5qc3rB8cJCt9GiNN40z0Xzs4G6f3wFE2u1h8hpnpwJqUbrATELesH/5lL+oqe3CAo
	6zAy062hBLo6gtRR8SC/GkvgoWcKw5NqCrOKdD+0lTukwqaag5eI/GcDkJbk7njP3QfHPQbGrBT
	OEStV/YXK0vGGYtnxbXYOAGDRoza1qqosd913Rne2WuDUoLczK9fTooEfCMHmcTG+sA++fmKDbz
	5/+xemfkJESIgKkct1G4EYLdaUKd62b3KDhxxbwhVTj1Ps0iGrinZelSKf3J+++nczOj+DinFY2
	sltCs74mZAhmRpa51+U95e8/kdi+0BIVwgRKUNMt+Z2oFupCjJVvQUUMWedpaaN/ZRmHmlyOKnK
	a9WQo+L
X-Received: by 2002:a05:6a00:27a5:b0:84a:65e8:137e with SMTP id d2e1a72fcca58-854c8f0d4admr7999711b3a.17.1787836386527;
        Thu, 27 Aug 2026 06:13:06 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8535acbbb6bsm2096885b3a.24.2026.08.27.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 06:13:05 -0700 (PDT)
Date: Thu, 27 Aug 2026 22:13:01 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Kees Cook <kees@kernel.org>, Christian Brauner <brauner@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>, Ingo Molnar <mingo@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, imv4bel@gmail.com
Subject: Re: [PATCH v2] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <apA33QXNSwDBxeXK@v4bel>
References: <ao7Q8miiuLAPVnWv@v4bel>
 <ao7iQ_wOLghOvTsq@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao7iQ_wOLghOvTsq@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C48584000D
X-Stat-Signature: rm97gzyx8pfjzjxgo6d519r6598yb4ab
X-HE-Tag: 1787836387-617791
X-HE-Meta: U2FsdGVkX1/TCL/+CRN4iqd34ln30IR8R9HeBj/YVmWmZogxCq3qaBs9NHt6Mnv3is76OCx4UtujyrYdXxPcM4sjw58/VdmxaIqDEt/+KjMEvnCCnVrDNfk80lWRiG3WYf/xqmlu1gdFqikJcGD2sskk1hT5MeSwKV3dZw7nXzAA9i25I1Nd95RnUMlRtijcLUJRWZQMI80G2CMlhKMyTk11C/CJmD2yK0WWIM9vnVifcgb6+1+QiFYt33lusyjiKMwiLzKv/2OH2VeHuiDtvMvMH2EFVSQsRdNfma6c5xHsFbI48z0sDu5u9Eki2c0MIswIDNAVZGR/zkUWndIZy1ipPItoZ2pGIoySgAF6pP7bVc43fR+I9/UcylPTyEyU10gSqEO3Jps2NzFrYdDlNA+kqHpwOfC/ibdWUKFu1M3mE52I0uSCmSgYGzKMZWmlQf9bI+bVHKjA2Z4qDcIOjFXOM39WSZb+oxPsxFnlHsYtFmuFSYSD1uUyQvBeZ+337XdUBlgLW8pKkauCSywuER+vKJeYvd8rKUtsIifoSofbk+uqumTowENeC86gOL+QrIheFpdCOZQ9UVfdUwr1+OmK40cZ+QOhgkd9DZwo8E5Xm3fIOYapx4c1hhtnPsOCmEPqIOku4sDCOcGpPYz1l/1SVUCNHHixAlfWbzStFLutPpRWJYa94SMr0Lu/zriXBHKwd8vxi67TQyNrsem18fuQu/mNSm1cn5cnA4a8FrNHAO29WyFRtrR+wuUZ5XeLcrc3oS989kogMebOkhJSirbghQHdVCrmwOeznDoun2wNYj5XGoMQjE/p8yOPyAP/yTdeqR466/DPhRD+kPbTmIs0R3bYuhQtLWiUoa0LrKAR0GmEO+XJ7/GErqDDvASmNAcQZDO/XDGrCvmJbfhXMwfYBnA2GSoO+HAjE7TGuDSpiiLJIc/nP344YXUQsPl0OQWKbuAR/RaHvIeH51P
 Xlyt0t/I
 UeyAY5H2PjzkBUqNPLHMS4LDer6k0PPxbEiKOFwSsUbmFOHZsR7qM5t5JCJnMkwiOlJAw7C4hgpCW+9OlwFTatUBd4K0QVh5YEb8yy9kQvWi9GQZ2cDp3+0xnL5PsYnUsZxX/n3zr6+koQeXXqNRBSI+RXpWPIXwSkUwgZCe5qKvRBNLNfQiuAgAoOqy66lUZ1gtRFwHmS98XJi/pvLBolaPbHNaET4qh/sdqSTaMXdah6/GK8l9cOPUthlYGk2nUQUDbenuCh8cc2R2hLrYBavXUxcXB5Y9f6Q98GGtABfv9k8xxcJTyLGjHDHNHQBqKOphPUoPvK/DEBer5JbbOuIVH4+e0zq+JOkqkSZxWfgu/Kgo+Uk8/P0+rT8dum4iYlCJeiCC8ZH0PGS+noCbW8197ERoWd0FUya7n6WVOtphNSpcUfVlUGcDk57qNUt7Mx5KyoODBB05X8l+y8A+Xq16XZu+w63QpIHRl64NsbzmCvYCKg87YPYoT139uHHX6VpkU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 02:55:31PM +0200, Oleg Nesterov wrote:
> OMG, my head spins ;) I'll try to read your explanation tomorrow.
> Right now I am all confused.
> 
> But let me ask some stupid questions right now, please help me to
> understand the problem.
> 
> On 08/26, Hyunwoo Kim wrote:
> >
> > begin_new_exec() calls posix_cpu_timers_exit(me) right after
> > exec_task_namespaces() and that removes the leftover node, so the state
> > normally stays invisible. But bprm->point_of_no_return is set before
> > de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
> > exec_task_namespaces() fails, the task dies before it gets there.
> 
> Do I understand this correctly? If begin_new_exec() does call
> posix_cpu_timers_exit(me), then everything is fine.

Yes. A failure after it, e.g. unshare_sighand(), is harmless.

> 
> Yes? If yes
> 
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1003,6 +1003,18 @@ static int de_thread(struct task_struct *tsk)
> >  		 * the former thread group leader:
> >  		 */
> >
> > +#ifdef CONFIG_POSIX_TIMERS
> > +		/*
> > +		 * exchange_tids() hands this thread's PID to the old leader,
> > +		 * which is reaped right after. The PID lookup in
> > +		 * timer_lock_sighand() then fails while the per thread CPU
> > +		 * timers are still queued here, so dequeue them first.
> > +		 */
> > +		spin_lock(lock);
> > +		posix_cpu_timers_exit(tsk);
> > +		spin_unlock(lock);
> > +#endif
> 
> ... then why do we need to call posix_cpu_timers_exit(current) before
> exchange_tids() ?

Strictly we don't. posix_cpu_timers_exit() walks tsk->posix_cputimers
directly and never does the PID lookup, so it only has to happen before
exit_itimers()

I put it before exchange_tids() so that the state timer_lock_sighand()
warns about never exists in the first place.

> 
> And what if another process attaches another cpu timer to the execing
> thread right after the code above?

Not for a per-thread timer, pid_for_clock() requires same_thread_group()
and there is no other thread left at that point.

A process wide timer has no such check, but it goes to
signal->posix_cputimers and the TGID lookup stays valid, so it isn't
affected.

> 
> Can we move posix_cpu_timers_exit() or the whole CONFIG_POSIX_TIMERS
> sequence in begin_new_exec() up, right after de_thread() before the
> "if (retval)" check?

posix_cpu_timers_exit(me) there is enough. I haven't tested moving the 
whole block.


Best regards,
Hyunwoo Kim

