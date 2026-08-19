Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62B8C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 12:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DA56B0093; Wed, 19 Aug 2026 08:50:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F011E6B0098; Wed, 19 Aug 2026 08:50:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEEED6B009B; Wed, 19 Aug 2026 08:50:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A89576B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:50:34 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4037AA0580
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:50:34 +0000 (UTC)
X-FDA: 85118002788.14.72C9BFB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 017A7180002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:50:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVoVn3pQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787143832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KudDx4GWA6m0kymTqV9B5+pPC4d5wMXWeaLZi91N90=;
	b=k0+bL0SESWNrLgGhXIKBgUq9nvZqtprBr3aRymjn2o+82GFpyx44zgcxc58SldM+skBPMx
	cg1jFfmihfj6TPr9A2IR3xGqQ8LlM3XWUeloTZPbgDGZlg4cF40Qm9ua+HE6JZDSoproaf
	EKW1i0bIe/aoTujLJ/5OvbBgV/tBqm4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WVoVn3pQ;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf16.hostedemail.com: domain of oleg@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=oleg@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787143832;
	b=3xeROIGFjLzZMY7qzPqoL6npRqSfSOO2zwExTrQz/b4ehkljxcMU73Z69+eDXYB6U7kxNc
	f59nmmeUuardQvAfcqGWguKMnsMciQb4h39KacT540tJVTin2X8WJSXvy64LUVSSarNVXs
	uvKh6djBd2JaqTx1qEjNEuo0o8dc9Vg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787143831;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KudDx4GWA6m0kymTqV9B5+pPC4d5wMXWeaLZi91N90=;
	b=WVoVn3pQZT4ckT9uj8kHO+a00+NS4ANKdXhr0BPgcRXqep8ettJ/A8MFIlvTwXq0ozBzrq
	su0J9bz1fRLy4IU+ooJfSlPCcudteInHCU2bJN8oP9pTOK8bXR5a98f4GW9au9HrwTTdFJ
	+wm/yvRcMTD5pzBDmnNuy/c51qo4n6o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-331-INSEtobNO6C9huKBqR73aQ-1; Wed,
 19 Aug 2026 08:50:25 -0400
X-MC-Unique: INSEtobNO6C9huKBqR73aQ-1
X-Mimecast-MFC-AGG-ID: INSEtobNO6C9huKBqR73aQ_1787143824
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D55061955DBE;
	Wed, 19 Aug 2026 12:50:22 +0000 (UTC)
Received: from fedora (unknown [10.44.33.127])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id A33BE180034F;
	Wed, 19 Aug 2026 12:50:17 +0000 (UTC)
Received: by fedora (nbSMTP-1.00) for uid 1000
	oleg@redhat.com; Wed, 19 Aug 2026 14:50:22 +0200 (CEST)
Date: Wed, 19 Aug 2026 14:50:16 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org,
	bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] Stop TIF_NOTIFY_SIGNAL from interrupting work that
 can't be restarted
Message-ID: <aoWmiL2Ea6YalTiy@redhat.com>
References: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: ilLd1vRw7BvDx6GBchAKpQDiT_Ey57EnOj4q2RJdlro_1787143824
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wec9fsoaufxy87hcwjc4wh1uoqnpw8xf
X-Rspamd-Queue-Id: 017A7180002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787143831-448806
X-HE-Meta: U2FsdGVkX19CqTRW/V078UPvzwouB5N1QUvl8/lJh9G0jnQHi14vi1hTJymu2s05wiiF8bTDtq88pP0Ohv7C22tCKBM7XebYv7wIGIfQgzzaN9TdGLPzpI35cl7yCzitg3mFK9RA4VN7SYkHjg+obpGTXFdXw42Pd4+IY6HSFCGet0beGhGPBqLVAUbuL7wxb0QJ1ySjaAH7ko9Huh3BL7A7/PDOqj4bLcbOPziR5lhbgEv5BxNL5E3aEHCKoWCR6KPxdNc6nEcR0GkPaaxdw5iEpHFpC1ZeLVglr9Gv4KaaefL5zKVt0dytV9TOyNVrUZjuW7HrUA1p8+vnxyHYV/sCvUrH5EgS3fidcFNaAW7s0p4k2wOI8n1eVziVV8z40lBf7sPk012n358QsI/OrAb1jYqGw/7+MBF8g0hjM3m0g/OgyV41vRi0PvljGE8UeKl2DjXjzmcjlE1ldqPzNZlAVmJ4Iq6EacmAGPwUgjqjEr2lfr4XoMepmjSCW1aWIjKJa308mL3FJajuDlowO4UWnxwWYSukJ1BcUOX+SGMizgIzuirlli9nA2MV6O62Oif0zovjUpV2zlTx/DpRVbTX3dsiUiGeiPxOFoLH5p+q9aeLtpswLCj4fL4krFU2D5vDN7lwFRl9a1xFASbcwBMOba5G+dqdaZacgeCOSA1BbxvEcA3vYPD0C0yezCA9SsNP967BquTf8D/aZ0mABmUI+Q//G2e0PS9DcV68GVlqnDqDhmH7XAwRqyQ+qpKXSaQU9K8cs/QxwtrGWOuTbqdcr/0NaFiWgoEVdi6WGpRa9Pue5cWgTS20SKglOdArdXV0isJx6xtwW2ChdzHTL1jaqmXg1W/aBtGs0SnpD9uHBiW3jRDuWpxuoeQeMezSMA3FsK3057THy5dWXNJVgQloKUCV25g2mSdxRSWMphmiCOWykWy5XYYiSbZeXkJpIxSp3IXR4Ppik4xgEHE
 lfSwWRrx
 pqxHvO26JkvCDaTC3jv1RBpotxYSbqe0u+Xa3Y40/sur2qM6wvzPICw3qf89yXe+9P7eIfH0ibfkdh6UleZiSiL4Z8JVlGHX2SThJW4qVsUQtu28tutRWvCuQpddk/thhV1Tj1aSxdx8Uzl4LxqMAsPdDHYmuqHg/YEH6JnTyw9OWHjKP+JnxhBpN/5+iVxMcFlVqJi6N6kpOPVIJRhosCSCEQv42Dub1iOOWloSsyC9XAYPqun99my8L00m31yNYtu4W8WvRdnGT+CwEg9y/tnsPRQ0DzEonhcR8e+rY0voV75wd/IyTAlirchHDc44OoqHfFqjBh16D7KOV6ltf2TUxmhqaNDwfA+MpKgrVigY4To/PgIqiTu6UhWI7tRRiHVfQxMYelMUJup67k9nsK/L4cxqpAfDDAzI6NXugDL/SdVMjeCN3QW2EU7UF8Fu3JrVU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Christian,

I am still travelling without my work laptop, can't read the code.
I'll try to take a look on Friday.

IIRC, zap_pid_ns() can use the new helper too...

Oleg.

On 08/18, Christian Brauner wrote:
>
> Ok, so I was looking into things and as usual got
> side-tracked so here we are. Oleg, save me please.
> 
> IF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
> return to userspace and run task work and then go back to sleep. This
> mechanism works well but breaks coredumps. dump_interrupted() only
> allows fatal signals to interrupt a coredump and the whole regular write
> path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
> well.
> 
> The core is that you can have quite deep callchains that end up calling
> signal_pending() in both the pipe and the socket codepaths so it's like
> we can just pass a flag through somehow.
> 
> For coredumps its very annoying because it means io_uring is - depending
> on how much outstanding work you have - incompatible with generating
> non-truncated coredumps. A process with too many file backed mappings
> and io_uring requests in flight ends up losing most of the coredump.
> 
> While zap_threads() has cleared TIF_SIGPENDING for a long time, just
> clearing TIF_NOTIFY_SIGNAL isn't going to work because the next
> completion will just set it again.
> 
> The fun part also is that io_uring isn't actually the only case:
> 
> (1) io_uring
> 
> (2) klp_send_signals()
> 
> (3) bpf_task_work_schedule_signal()
> 
> (4) landlock's tsync
> 
> And technically, kthread_stop() and the printk kunit test set the bit
> raw. So no simple way of just fixing this in one subsystem.
> 
> So, a fix for this issue has the following constraints:
> 
> (i) The places where a write is aborted are deep callchains that we
>     can't reasonably parameterize. For example, anon_pipe_write(),
>     unix_stream_sendmsg(), unix_stream_read_generic(),
>     sk_stream_wait_memory(), or a bare wait_event_interruptible() in
>     wait_for_dump_helpers(). All of them are shared with regular
>     syscalls that must stay interruptible.
> 
>     IOW, the state has to be per-task and ambient.
> 
>     An LLM would call this "load bearing"...
> 
> (ii) There are multiple ways TIF_NOTIFY_SIGNAL can get raised and they
>      can get set from irq context against any task. As said above we
>      have at least io_uring paths (poll task_work, msg_ring, tctx exit,
>      io-wq via __set_notify_signal()), bpf_task_work_schedule_signal(),
>      klp_send_signals(), landlock tsync, plus kthread_stop() and the
>      printk kunit stuff that set the bit raw.
> 
>      So fixing this up in the individual subsystems is doomed to fail or
>      require constant audits in case some new variant shows up.
> 
> (iii) The coredump task is exiting and can't restart the work.
> 
> So here's some stuff that was considered but I think it not really
> feasible:
> 
> (a) Check for task_is_coredumping(). That will end up forcing
>     task_work_add() users to know about coredumps. This seems like a
>     layering violation.
> 
>     I have a patch for this as well but it's ugly. It races with the
>     dump staarting unless the bit setter takes a lock in the io_uring
>     completion. I know someone that will disagree with this approach. ;)
> 
> (b) Oleg's old suggestion iirc. Just clear the bit at coredump entry.
>     That doesn't work because io_uring poll completions just raise it
>     again from irq context. So you also need synchronization with the
>     setter of which there are quite a few.
> 
> (c) Let the setting task defer setting the bit if the task is flagged
>     and then raise it again at exit.
> 
> (d) Take TIF_NOTIFY_SIGNAL out of singal_pending() and make it opt-in at
>     specific points. That breaks io_uring quite badly and forces a
>     tree-wide audit.
> 
> So the amount of patches for this issue over the years is impressive. So
> let me add one to the pile for the lolz.
> 
> Add PF_NO_NOTIFY_SIGNAL and helpers to raise/restore it. This is the
> same approach as memalloc_nofs_save(). signal_pending() will not report
> a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
> PF_NO_NOTIFY_SIGNAL critical section. Obviously you can't
> fork()/clone3() in such a section.
> 
> Fix coredumps and smb. Fwiw, I think there's a few other potential users
> of the helpers that are left out of this series.
> 
> |         |    notify_signal_pipe     |   notify_signal_socket    |
> |---------|---------------------------|---------------------------|
> | fix     | ok                        | ok                        |
> |---------|---------------------------|---------------------------|
> | unfixed | 357324 of ≥ 5111808 bytes | 467336 of ≥ 5111808 bytes |
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> Christian Brauner (4):
>       signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
>       coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
>       selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
>       smb: prevent TIF_NOTIFY_SIGNAL from interrupting
> 
>  fs/coredump.c                                      |   4 +
>  fs/smb/client/transport.c                          |  13 +-
>  include/linux/sched.h                              |   2 +-
>  include/linux/sched/signal.h                       |  21 +-
>  tools/testing/selftests/coredump/Makefile          |   7 +-
>  .../selftests/coredump/coredump_notify_signal.h    |  29 ++
>  .../coredump/coredump_notify_signal_helper.c       |  46 +++
>  .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
>  tools/testing/selftests/coredump/coredump_test.h   |   1 +
>  .../selftests/coredump/coredump_test_helpers.c     | 318 +++++++++++++++++++++
>  10 files changed, 674 insertions(+), 12 deletions(-)
> ---
> base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
> change-id: 20260817-work-tif_notify_signal-6ab080d33693
> 


