Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27B67C5DF7D
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C7F46B0174; Tue, 18 Aug 2026 06:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A54A6B0178; Tue, 18 Aug 2026 06:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B5646B0179; Tue, 18 Aug 2026 06:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D2B466B0174
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:29:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B13881A0C05
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:49 +0000 (UTC)
X-FDA: 85114019298.30.6EA2BCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0609D1C0004
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:29:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NuFqqhx/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787048988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YGBu95KxEYL60/6Z19Vi2hF5fBbivoB9n1qwKiIoQCA=;
	b=cG0pYEjv71PyXEAQ0oaBzycED1oyTSRqyOKCezlBVOPqZgb1K3GXup3c9vJ7xEDEFTQzuV
	qo5ACrIo+b2RTVehwPXjHz/eAdDn/JwNEhHnfB2dZeBRYWaSGto3orQKnGTrrDqBXN0L3i
	q7FqnxdbJQOW8h84SZTDPEGRp8bt6JM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="NuFqqhx/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787048988;
	b=hge2iCo860nY1yohyeso3n6mYmE9Xpaf/tarrzyY22TaAbVtweB/F3VSlg1InYvJMiU8pj
	S3WsqKPAtCIaGfC67arbDI5enoHhuoGUPZO8MPoQ0/yk5RXV2f/xlsCrwJawyMrEEARh9m
	J4kzVhPmSbnSBbOPVP/kfLkeqAtLi9M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 81375601E0;
	Tue, 18 Aug 2026 10:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D781A1F000E9;
	Tue, 18 Aug 2026 10:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787048987;
	bh=YGBu95KxEYL60/6Z19Vi2hF5fBbivoB9n1qwKiIoQCA=;
	h=From:Subject:Date:To:Cc;
	b=NuFqqhx/OBpG4enp+eYRdbfn7ghsLQThetOxvPIFUTslDtl7sQEqYSRncFJjSNLME
	 tHvpuXUaGEtJTshEQmEvEVrUELhr+x1sNnlmdx1UCiFIaPIE+IrKfWyl3o7MTFzBMb
	 Jar4dMZ3WjHgaLLQO6WO7Ja9zmMVR1kt1OEmVkuHHF5RR0Q86DvDqiAmw6LwjmBi5B
	 h4E2Lg6wzH9kFsEDnzkC1wRwo6KnPdQ5vLIlZJlxGBOkPwXICi7jrmFueLVOhV4ej2
	 QQwJd8okOEDS3uRsMKSgpN1UCfDt4PEl3FJpD/+bKiHjbddgIHnq89OPvGv1ccmzxr
	 Gtq34sog6jPVg==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH 0/4] Stop TIF_NOTIFY_SIGNAL from interrupting work that
 can't be restarted
Date: Tue, 18 Aug 2026 12:29:35 +0200
Message-Id: <20260818-work-tif_notify_signal-v1-0-1ee1fcc5b3ff@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yWM2w6CMBBEf4XssyWlJAX9FWNICwusl5bsImoI/
 27Rl0nOZOasIMiEAqdsBcaFhGJIUBwyaEcXBlTUJQajjdV1UalX5JuaqW9CTPlphIbg7so6r2v
 dlaU9lpDOE2NP75/4fPmzPP0V23m37QvvBJVnF9pxrx5OZuR8qXID2/YF7EDK4pgAAAA=
X-Change-ID: 20260817-work-tif_notify_signal-6ab080d33693
To: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>
Cc: Peter Zijlstra <peterz@infradead.org>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Steve French <sfrench@samba.org>, linux-fsdevel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-cifs@vger.kernel.org, linux-mm@kvack.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=5657; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IkGa6xqKFM5x7wT1EwhGFPFaIGs9Gn9uxpjtq8no2A0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1mEi8d51zdc+hz9ordprwXjomqr104t+pot8OP7qwa
 HWzg5HqqY5SFgYxLgZZMUUWh3aTcLnlPBWbjTI1YOawMoEMYeDiFICJ7LnL8E9PxWHzicts8foZ
 F3/cvrzC4o1tSNqiCqX8JUa+ibeY15gyMryZ/v76KZGtC5tuGcUzKUoETNkWlnfx4bqnp2UcDnN
 OZuEDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 8t68pjabn5tqcmi98dp3hmnsza1uz9p8
X-Rspamd-Queue-Id: 0609D1C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787048987-439854
X-HE-Meta: U2FsdGVkX19z7Th3BhfjZ9wbifp+2lc4tWQWksJoGfpnTr10H2s0mkEGeIkJJMp4NHNh7YZwZrK24wiFkDhDx5xQk7sk1WlShiOBsbJOItP1W81YWZ2C8ycfvRDoo7Nm7a0B5sdO+1+2SVoMgosZ+NXt9h70nrvdV0q+JvFT7xeXSHXa5mCfXYE81wTHFYAJDN3+RuT353BgSP+KsND46e0lnyzWSrj+nZsokQzC0mf6Ahtl/pncrcMZByWWRM62MwYF0zokNC7BC74Z3rV0UiesXWkwhuWEAWudpXvz33SWeMH217w6DKHGPUR6nvzKc24cLtFeAbmfwlhY3ktY0qE7Du8uySB+ywSx55cnh7ISJ+wFndq3gk7GBFe7u0MS3uBLCYm4B8datGMpej+gTG7237c2LWAHITt8aiKLGd50G7QOMXcungfmrWymr68WXmaCN4yaDl9760eIZSKhPbUoDcgJxWSDbDt7Rc2uOg6QgbyjbZIWv8nh3A3lpOBvkyp6bNvxcsTfj7aWVudeSelR8C+RUxVboI6x1ymbxbEmQKBAYjzcNIFEyFbBhlBdZebqUWJzZm2kFHD86qAsy14kaDiT7SalfwXBEnI/n9gQXyGYrD/2EuVlRFBAF2YbxxrPVV/oSbt4NnL5p6MLC031q7du23cGgtvQcjgAiTPRbby9Pq+8JdGFskjlAhso0qCCXxb8cMxO5DIjXmaJiyGNCzBARvXUECtoUbsyc0DNwzkDBOHrd1Q0W0BQtf6ca9wt33n+VlfLmSQu9fivB2yXxR05PGLzo3AVHoaPMLIV7GDmqjW2MEljkdDW305CsYmnXPTMH8CMhTTCdl99SG4C064g5fQI6yh79c+DmgT44mIAyrTuysKtMG0ZgT5RETuT9/DAvjIsgdiw2jtDEuG3k1xb/8/irJSU/t4Q4TXJ29+PiG3RRmHysPcTTYO1kpGv2yhOP1rEKYh/qDo
 wUW7p5yf
 ct93Tf5PRp0JKZxo1cGMyFMiBBaxwLMLrbK6+u6YKYFDgUsH9NcdHAF7Mt8sYEypkZqScYWrgOdX9/GwdMbePNNrR1Z2+CU6WSpgAXA2oMgGxtkOeTfDfLV8DUpFAIwEX//DyTd9UE85qMdbCGADO/o8ifnfAaQVJhhnrxkSfjPziWZcuO9ctuxWNFp3zq+M+n5o74MilSze+1ol7QFuLus7djTuLZ7Pe6hVrJ4p5IuNZLOkfap0xoQ8e0DDhmxFipXLH9U9jE3XyjYzAihSU0pe1CGisAVyBMAXPuq8FKzHCvBIZgIokBxB4GsMhXe3LkLNR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ok, so I was looking into things and as usual got
side-tracked so here we are. Oleg, save me please.

IF_NOTIFY_SIGNAL is used to kick a task in uninterruptible sleep to
return to userspace and run task work and then go back to sleep. This
mechanism works well but breaks coredumps. dump_interrupted() only
allows fatal signals to interrupt a coredump and the whole regular write
path going to actual filesystems is impervious to TIF_NOTIFY_SIGNAL as
well.

The core is that you can have quite deep callchains that end up calling
signal_pending() in both the pipe and the socket codepaths so it's like
we can just pass a flag through somehow.

For coredumps its very annoying because it means io_uring is - depending
on how much outstanding work you have - incompatible with generating
non-truncated coredumps. A process with too many file backed mappings
and io_uring requests in flight ends up losing most of the coredump.

While zap_threads() has cleared TIF_SIGPENDING for a long time, just
clearing TIF_NOTIFY_SIGNAL isn't going to work because the next
completion will just set it again.

The fun part also is that io_uring isn't actually the only case:

(1) io_uring

(2) klp_send_signals()

(3) bpf_task_work_schedule_signal()

(4) landlock's tsync

And technically, kthread_stop() and the printk kunit test set the bit
raw. So no simple way of just fixing this in one subsystem.

So, a fix for this issue has the following constraints:

(i) The places where a write is aborted are deep callchains that we
    can't reasonably parameterize. For example, anon_pipe_write(),
    unix_stream_sendmsg(), unix_stream_read_generic(),
    sk_stream_wait_memory(), or a bare wait_event_interruptible() in
    wait_for_dump_helpers(). All of them are shared with regular
    syscalls that must stay interruptible.

    IOW, the state has to be per-task and ambient.

    An LLM would call this "load bearing"...

(ii) There are multiple ways TIF_NOTIFY_SIGNAL can get raised and they
     can get set from irq context against any task. As said above we
     have at least io_uring paths (poll task_work, msg_ring, tctx exit,
     io-wq via __set_notify_signal()), bpf_task_work_schedule_signal(),
     klp_send_signals(), landlock tsync, plus kthread_stop() and the
     printk kunit stuff that set the bit raw.

     So fixing this up in the individual subsystems is doomed to fail or
     require constant audits in case some new variant shows up.

(iii) The coredump task is exiting and can't restart the work.

So here's some stuff that was considered but I think it not really
feasible:

(a) Check for task_is_coredumping(). That will end up forcing
    task_work_add() users to know about coredumps. This seems like a
    layering violation.

    I have a patch for this as well but it's ugly. It races with the
    dump staarting unless the bit setter takes a lock in the io_uring
    completion. I know someone that will disagree with this approach. ;)

(b) Oleg's old suggestion iirc. Just clear the bit at coredump entry.
    That doesn't work because io_uring poll completions just raise it
    again from irq context. So you also need synchronization with the
    setter of which there are quite a few.

(c) Let the setting task defer setting the bit if the task is flagged
    and then raise it again at exit.

(d) Take TIF_NOTIFY_SIGNAL out of singal_pending() and make it opt-in at
    specific points. That breaks io_uring quite badly and forces a
    tree-wide audit.

So the amount of patches for this issue over the years is impressive. So
let me add one to the pile for the lolz.

Add PF_NO_NOTIFY_SIGNAL and helpers to raise/restore it. This is the
same approach as memalloc_nofs_save(). signal_pending() will not report
a fake pending signal via TIF_NOTIFY_SIGNAL if inside a
PF_NO_NOTIFY_SIGNAL critical section. Obviously you can't
fork()/clone3() in such a section.

Fix coredumps and smb. Fwiw, I think there's a few other potential users
of the helpers that are left out of this series.

|         |    notify_signal_pipe     |   notify_signal_socket    |
|---------|---------------------------|---------------------------|
| fix     | ok                        | ok                        |
|---------|---------------------------|---------------------------|
| unfixed | 357324 of ≥ 5111808 bytes | 467336 of ≥ 5111808 bytes |

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (4):
      signal: allow taks to temporarily block TIF_NOTIFY_SIGNAL
      coredump: prevent TIF_NOTIFY_SIGNAL from interrupting coredumps
      selftests/coredump: test that TIF_NOTIFY_SIGNAL doesn't truncate a coredump
      smb: prevent TIF_NOTIFY_SIGNAL from interrupting

 fs/coredump.c                                      |   4 +
 fs/smb/client/transport.c                          |  13 +-
 include/linux/sched.h                              |   2 +-
 include/linux/sched/signal.h                       |  21 +-
 tools/testing/selftests/coredump/Makefile          |   7 +-
 .../selftests/coredump/coredump_notify_signal.h    |  29 ++
 .../coredump/coredump_notify_signal_helper.c       |  46 +++
 .../coredump/coredump_notify_signal_test.c         | 245 ++++++++++++++++
 tools/testing/selftests/coredump/coredump_test.h   |   1 +
 .../selftests/coredump/coredump_test_helpers.c     | 318 +++++++++++++++++++++
 10 files changed, 674 insertions(+), 12 deletions(-)
---
base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
change-id: 20260817-work-tif_notify_signal-6ab080d33693


