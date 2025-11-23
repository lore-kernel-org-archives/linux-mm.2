Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A39E6CFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 18:32:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFE46B0007; Sun, 23 Nov 2025 13:32:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060496B0012; Sun, 23 Nov 2025 13:32:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7CA6B0024; Sun, 23 Nov 2025 13:32:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D5D3D6B0007
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 13:32:58 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 72DE11A0111
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:32:58 +0000 (UTC)
X-FDA: 84142718436.17.0213B00
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 74F54A0003
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 18:32:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKWSbmkP;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763922776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=36l7iu5Eghp8LjDFDIIU/eYWC2BgI9ey1UwqfIFE8Gg=;
	b=JLux9mWgTgm9RGxgUR9QOMtVnItutyFKK4NO5h7PRGQoozwJbLgNO6TO8r8hkmw2cuNqVL
	NBNwyOfBTnHbEjdItfTqrp+kdWcgxW7C1fuPHpECjAuNnfQP+2cGcK8Y6fX30fGs2R3s61
	kfMN3ItiU9diHiHg3y4V3PEYZcAMAN0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MKWSbmkP;
	spf=pass (imf25.hostedemail.com: domain of oleg@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=oleg@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763922776; a=rsa-sha256;
	cv=none;
	b=nC0qi4dRaXO5jayposYZiQxmoPUcQKdmWFCuMfvDl3NozcJPsT2GgqOwDVg4ng4LmjOk44
	0eWmsllLVzxZkPgj5WyGVRLKe73/l8k88wfeSgj2fZY/k44OR/0Yv9QPFAGonxDF3vtBKd
	Syufpyum3HPkSG/E19b1gIAo0dDnr4A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763922775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=36l7iu5Eghp8LjDFDIIU/eYWC2BgI9ey1UwqfIFE8Gg=;
	b=MKWSbmkPKgJqgjPDCjbTTZpnfsLQsApcV2gnG7K2pAJcl6t36xaPwn2C0ZTxrsu1+fIVmr
	ygo/xvKjU/VKXjVa7gzRqcfX/UfmX10he1dvcR6HJ6m6p8nFmohPwxWV8xRZ1Tp5ZtKQbN
	iKGLdDv3pLRYxZt2m0Vf3IGsD8wQK38=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-478-ZAFeV0m9P-uQ-1se1ue-Gg-1; Sun,
 23 Nov 2025 13:32:50 -0500
X-MC-Unique: ZAFeV0m9P-uQ-1se1ue-Gg-1
X-Mimecast-MFC-AGG-ID: ZAFeV0m9P-uQ-1se1ue-Gg_1763922765
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA33419560B5;
	Sun, 23 Nov 2025 18:32:42 +0000 (UTC)
Received: from fedora (unknown [10.44.32.8])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id CB9B4180057F;
	Sun, 23 Nov 2025 18:32:22 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Sun, 23 Nov 2025 19:32:42 +0100 (CET)
Date: Sun, 23 Nov 2025 19:32:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>, Kees Cook <kees@kernel.org>,
	Andy Lutomirski <luto@amacapital.net>,
	Will Drewry <wad@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>, Serge Hallyn <serge@hallyn.com>,
	James Morris <jamorris@linux.microsoft.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yafang Shao <laoar.shao@gmail.com>, Helge Deller <deller@gmx.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Adrian Reber <areber@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
	Alexei Starovoitov <ast@kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	tiozhang <tiozhang@didiglobal.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Paulo Alcantara (SUSE)" <pc@manguebit.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	YueHaibing <yuehaibing@huawei.com>,
	Paul Moore <paul@paul-moore.com>, Aleksa Sarai <cyphar@cyphar.com>,
	Stefan Roesch <shr@devkernel.io>, Chao Yu <chao@kernel.org>,
	xu xin <xu.xin16@zte.com.cn>, Jeff Layton <jlayton@kernel.org>,
	Jan Kara <jack@suse.cz>, David Hildenbrand <david@redhat.com>,
	Dave Chinner <dchinner@redhat.com>, Shuah Khan <shuah@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	David Windsor <dwindsor@gmail.com>,
	Mateusz Guzik <mjguzik@gmail.com>, Ard Biesheuvel <ardb@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Hans Liljestrand <ishkamiel@gmail.com>,
	Penglei Jiang <superman.xpt@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	Ingo Molnar <mingo@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v17] exec: Fix dead-lock in de_thread with ptrace_attach
Message-ID: <aSNTNZxiQ0txISJx@redhat.com>
References: <AS8P193MB12851AC1F862B97FCE9B3F4FE4AAA@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285FF445694F149B70B21D0E46C2@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <AS8P193MB1285937F9831CECAF2A9EEE2E4752@AS8P193MB1285.EURP193.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEEEDE0B9742310DE91E9A7E431A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <GV2PPF74270EBEE9EF78827D73D3D7212F7E432A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <20251105143210.GA25535@redhat.com>
 <20251111-ankreiden-augen-eadcf9bbdfaa@brauner>
 <GV2PPF74270EBEE4FE6E639B899D01D8870E4C9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
 <aRs4zYDhddBQFiXZ@redhat.com>
 <GV2PPF74270EBEE6F59267B0E9F28F536D0E4C9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <GV2PPF74270EBEE6F59267B0E9F28F536D0E4C9A@GV2PPF74270EBEE.EURP195.PROD.OUTLOOK.COM>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74F54A0003
X-Stat-Signature: k5m3g5xeeymi5rswpdi1eyamynuuot9u
X-Rspam-User: 
X-HE-Tag: 1763922776-167040
X-HE-Meta: U2FsdGVkX19N8q6RTSWGohLsdX9+Evwlz8DmQIqpQPqNFA38PbGzha5jrlgrNXWQYo9K3Dbl9Bda1eH6ymQdw9K8Hrd5XPhcUUE0OF13MzTkvgIqUDyC/SKjBZL0EP/EbQCcJeRT6Icigb1OE3fFRNqRCbXMNeMDS+g8x6xQ68B4JhENw7XN4FxWiAb0ghPQJ+0QQJOKpI07Vg6J9eZ+KbEJwgATAa/GidSoSbscfKZ70Q/abK5jz8Den9SAUrS07bwHNcs2BzkmmMYRWQP7je8efy1GwD9wvsrnaJhzaO1p/C08VJXMFRH7dCPcF7qbBTzNi8OORctf9xrM1L8rHsO4FKiZTup8EVCvcclRdIBOo3wR/KFye6VlfnnXgk4aJRHWfCNXrN26VTLIcNPzPpAn7lNRWAZfA5ry6B56ahF68tXASG8FmxeF1R6qzmap5DaV/12NzRoj6QwoN1FHP0WOp2/jVgDn2gnHtt1hVjnvG5n7VuuNCkqVbmjvqD+u8StU1Ugd2DlzwT4I8VRTy/n9w4EIg6+zn3uqIMxYQXvuod9HFuqXK/TxkSZmkNMT0KjxQuf0QAKLYxylNHpKzyqNTPFo/fW47Ja1aAGBjc24DdafyZ/XuLbSattcihME7MR5+h4qXX5o3iM/bQlUtmm/bcaDwKD25hl1PzNKNfI+Uvq9EzeujZVsrqinJFedQdzEg2vFbQt+L58NDqXoDuQPWcY55lCrUByRWpzNlQOeIoHvBwE69Z//MqBr6RhHFVOiDtO99vetcGIzdOe83KObwGu3MRwG/mJYolNuuRafS6fg7rXObUM8du0RO5enSWwXwaTCbR38YApcX5uOin7Yn8TX1jTJhkR9KFrFt+LrqmaXImvUNSMOK5CsGGOu0oIDySGYLcZdLNatKI+FCvwN9GIG301p7NoiN5/bu1RZUJVc3l8wEazoXlYJojlJ3khxyf3QjHNt9FXer1t
 2qRRoWdm
 H59akS4yrFTUy3iDEo4e675F433M+CEE7z85HWjy89VnitlPEbpd/2rvMVSWyVwdhcHSJvIhtAkPH7vYkQ2DsZ2D+19OgLFzZVMQEVlFteVeM4eIW1xC0KVoj9Urol7JQhoRpYMmC2caCcRGrwb0G5DHIDTSl7FIGtHUGF6B1oMyKB5/Yeya1v7/hp8pNcp8+wpO7SvkUbHsYqWHpY7mQZEXu+Tx5F6I9fCkBx75xcocy+lHPnhkWRCnhKmNRy7MmG5BQdmpT99yRinM0x/jCI17TOSOxwdq7RaOW4TKGzwAziuzdXxh4z2ZqE1xj3VK1mdlr798pL1oz9LEoAkAWO43oI5jLjTjMQSZykS2aDffZm/epbVtxK4h1ma28oKfkrJHdVwc0gx/2zAYwI1//gWk8x55vYu+TcLh4zC13WdixWldwRhndm+afrKp/N6wvAShmDMcCRSnH43vgrn2wClj5e6PIIWSpiH1zOw3zArrxl8RxTj1v8DlQDOvZjPq9TQeS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Bernd,

sorry for delay, I am on PTO, didn't read emails this week...

On 11/17, Bernd Edlinger wrote:
>
> On 11/17/25 16:01, Oleg Nesterov wrote:
> > On 11/17, Bernd Edlinger wrote:
> >>
> >> On 11/11/25 10:21, Christian Brauner wrote:
> >>> On Wed, Nov 05, 2025 at 03:32:10PM +0100, Oleg Nesterov wrote:
> >>
> >>>> But this is minor. Why do we need "bool unsafe_execve_in_progress" ?
> >>>> If this patch is correct, de_thread() can drop/reacquire cred_guard_mutex
> >>>> unconditionally.
> >>>>
> >>
> >> I would not like to drop the mutex when no absolutely necessary for performance reasons.
> >
> > OK, I won't insist... But I don't really understand how this can help to
> > improve the performance. If nothing else, this adds another for_other_threads()
> > loop.
> >
>
> If no dead-lock is possible it is better to complete the de_thread without
> releasing the mutex.  For the debugger it is also the better experience,
> no matter when the ptrace_attack happens it will succeed rather quickly either
> before the execve or after the execve.

I still disagree, I still don't understand the "performance reasons", but since I can't
convince you I won't really argue.

> >>>>> +	if (unlikely(unsafe_execve_in_progress)) {
> >>>>> +		spin_unlock_irq(lock);
> >>>>> +		sig->exec_bprm = bprm;
> >>>>> +		mutex_unlock(&sig->cred_guard_mutex);
> >>>>> +		spin_lock_irq(lock);
> >>>>
> >>>> I don't think spin_unlock_irq() + spin_lock_irq() makes any sense...
> >>>>
> >>
> >> Since the spin lock was acquired while holding the mutex, both should be
> >> unlocked in reverse sequence and the spin lock re-acquired after releasing
> >> the mutex.
> >
> > Why?
> >
>
> It is generally more safe when each thread acquires its mutexes in order and
> releases them in reverse order.
> Consider this:
> Thread A:
> holds spin_lock_irq(siglock);
> does mutes_unlock(cred_guard_mutex); with irq disabled.
> task switch happens to Thread B which has irq enabled.
> and is waiting for cred_guard_mutex.
> Thrad B:
> does mutex_lock(cred_guard_mutex);
> but is interrupted this point and the interrupt handler I executes
> now iterrupt handler I wants to take siglock and is blocked,
> because the system one single CPU core.

I don't follow. Do you mean PREEMPT_RT ?

If yes. In this case spin_lock_irq() is rt_spin_lock() which doesn't disable irqs,
it does rt_lock_lock() (takes rt_mutex) + migrate_disable().

I do think that spin/mutex/whatever_unlock() is always safe. In any order, and
regardless of RT.

> > And just in case... Lets look at this code
> >
> > 	+                               rcu_assign_pointer(task->real_cred, bprm->cred);
> > 	+                               task->mm = bprm->mm;
> > 	+                               retval = __ptrace_may_access(task, PTRACE_MODE_ATTACH_REALCREDS);
> > 	+                               rcu_assign_pointer(task->real_cred, old_cred);
> > 	+                               task->mm = old_mm;
> >
> > again.
> >
> > This is mostly theoretical, but what if begin_new_exec() fails after de_thread()
> > and before exec_mmap() and/or commit_creds(bprm->cred) ? In this case the execing
> > thread will report SIGSEGV to debugger which can (say) read old_mm.
> >
> > No?
> >
>
> Yes, and that is the reason why the debugger has to prove the possession of access rights
> to the process before the execve which are necessary in case exeve fails, yes the debugger
> may inspect the result, and as well the debugger's access rights must be also sufficient
> to ptrace the process after execve succeeds, moreover the debugged process shall stop
> right at the first instruction where the new process starts.

Not sure I understand... OK, I see that you sent V18, and in this version ptrace_attach()
calls __ptrace_may_access() twice, so IIUC ptrace_attach() can only succeed if the debugger
has rights to trace the execing thread both before and after exec...

Oleg.


