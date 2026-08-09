Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F004C5AC67
	for <linux-mm@archiver.kernel.org>; Sun,  9 Aug 2026 02:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9336B00F0; Sat,  8 Aug 2026 22:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9646B00F1; Sat,  8 Aug 2026 22:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBF256B00F2; Sat,  8 Aug 2026 22:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8706D6B00F0
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 22:06:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E57D21A0491
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:06:44 +0000 (UTC)
X-FDA: 85080092328.04.B3C8B14
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3F0601C000C
	for <linux-mm@kvack.org>; Sun,  9 Aug 2026 02:06:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GuyfJ1lP;
	spf=pass (imf18.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786241203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JUi5CZ/mm/6LIkM/Ynog72l5rYYaKtcE2jJwcesfnKA=;
	b=Jfsnn1ApGh/e+7oXFrxgmTeVxxUonTAOpj4fPsYNkMnRHbLBje0/z4u90gKslf29Kg9rp2
	WaIg3R3+C+P89ui0hfO8wpAav6RtcILSrsR7eOfyYBAuk8ETgM+nVDfXf3zHtRaIt9wuec
	p8JejERBuhKxeDoXE+k3hxesQ58PLqo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786241203;
	b=paGeXBsC27k7EjREgXxv+U2sA0Qe9Hbwf+c3UAXUhNXdIujsCaYKzkog3HVScnA0EjUOBL
	pHYl9CVRE6cyRUyIF8IvSrDsBG3qF4lHx+UfpnbEhzlQ5yyCJw8Awl9uFGMZQhfjsTtEPN
	71F73/mbrgXY5YXzJRBXH3LfSXaSxRI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GuyfJ1lP;
	spf=pass (imf18.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-383cb94f742so752431a91.3
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 19:06:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786241202; x=1786846002; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JUi5CZ/mm/6LIkM/Ynog72l5rYYaKtcE2jJwcesfnKA=;
        b=GuyfJ1lP/8o7FItVHuWNLZJckMuNd7CRQeajWzGciZZxdK/A3Eo8s7nflZPuHkRZX6
         Gu2nt/BnR0rK+k0ZL37u4jCZakT3/Np9sm2RZHCeQAZZKoKDSaWpPrWQoicuZCCOmA/X
         OFIHLYUjz176W3BSk2V+MwzCA9Xs6lwTDFqfTm44kI4K8K1KNCkf9tA1i2E236ulGSCP
         25KzxiRBEk7fFRlzhXTXDaL27j50dq+J+z3SpP5a8MtNGEmaTbrNGriveaVmF1c5Oj/w
         tHo/Pb/E3Pl/k5+sWQsOImp5QJSmXK9SmkZauzS5Qc3C2adqkFN+RqudiBGVYhAqL0Hd
         ZPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786241202; x=1786846002;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JUi5CZ/mm/6LIkM/Ynog72l5rYYaKtcE2jJwcesfnKA=;
        b=SrsobVrlj5FxSEqim/Ksk6U9DSmUT/sk05zZonEm6ciWSWU8Nno10VeWlSss+daIQf
         bJd2y7g3dGcaxAEuU2KeJTnd1+9rBttXrfEl0RbumHLbSPoxx/eRLuM4tduRpui5NXda
         crjAJQfT4nbhJKsJcHnuIkimQR6ZMPiHsfIKu7Nzxq4Kp/lmCX3D90xHs2aIoRR+0f6f
         rnzUCLojfjGaYkmpwl5RFgFHwTXMRU+zOIfAEQxcr2b6ilurSOCn39GcAfXwZBWR9FG5
         G2Qmr0G95DGg4On0XwR/16tXCxXo6ZGQT1Dp6NtQ1bkd4gcK1wkIrZARiGtWR06sKFbE
         PruQ==
X-Forwarded-Encrypted: i=1; AHgh+RrsKVCCmljnXZA/6jjjsIKO3rMyYE+dDX1/tGUtsuspWCYfN+xX0ftjA+bssClHDaBehVpspqoeaw==@kvack.org
X-Gm-Message-State: AOJu0YyAP4cDkKW9yWrY8VC5fV1WJujddTS2pWs6FsHvPbfL2kRwKR8p
	ECnIYj7EH3kjybJJUxXZaH9H0Go1x+gwWfm12jn+LNZ8bMiDA2h0aZlE
X-Gm-Gg: AR+sD13x+amzwFfAu9pCAQ98iSa2o2FylQh0S+dUvs63voO/xdrxj2QdJS/D7HXoAb8
	3HZdGu9TV7BC73vmy5e+FXtW0L+c8PKDo1CZjNl3/O3Mk/VZKpNH9xRywGIo5iIIFEE388P2cTM
	J8hJXYVZ617wUBi7AdTLHfCETLKybxdvRAOKEo4rrcTdbAiUgVzo8de1eULaleclJL6QHqUc5K4
	JQNu18MR503UJBmgAQ+0GgnJSDruHYgtNsIXxcsa6RBPRdXl+mO6v8ItO6M/Yvy/3GsNtjWqgd2
	D5XyCZTHyNqmN0YGuDx3DsV6txzaCYSh+mJ0NxpM9ldSjxK76v10Dl/NcDrn7GZxJpy8sVjLZOM
	LbnONwcsI8ppuJABrDCUCiN0hJhAABQy8FnrXuIP99IipPhklte81zrnQFg7fe5YKTrjfRYhvcj
	SV36ibL2+pk5oA1SABiBOjZH+qz+oQJGqpN25OunbW8ifSO+q28vJ6Bmd4rJibfnKn4snIBgUQQ
	JkLcfK+q3EblLlB3KY=
X-Received: by 2002:a17:90a:d010:b0:38d:eaec:4396 with SMTP id 98e67ed59e1d1-3903c58bdd2mr33450215a91.11.1786241202015;
        Sat, 08 Aug 2026 19:06:42 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39085dc396dsm10023664a91.3.2026.08.08.19.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 19:06:41 -0700 (PDT)
Date: Sun, 9 Aug 2026 11:06:38 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: viro@zeniv.linux.org.uk, brauner@kernel.org, tglx@kernel.org,
	ebiederm@xmission.com
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] posix-cpu-timers: Dequeue per-thread timers before
 exchange_tids()
Message-ID: <anfgrsPlUdwBhdrp@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3F0601C000C
X-Stat-Signature: 5u4i7kgxeag355zy4qudm1uko6ey57t4
X-Rspam-User: 
X-HE-Tag: 1786241203-782486
X-HE-Meta: U2FsdGVkX19na9o8UdTKdBCvIJNIoe+xkIAbns/hElgOEK5CVKisLCXkI00nR980awZAjjh19cCPkuhUIYS1qPFm8QknT8tys8FBYKaM0X/oOwJ6XFvsA0d8NX9fRtXHTsgIK0FNZM+vMxDtAtCBkDOAwz3DbaR6eHAMheaJl0xunHARuT5Sfc/gkHaY951aZEYZqYiMc5BWk2KNu5SHFuEuq8QPCjmk/EJ7HeNvdMxpLnKpMW8JMY7JrJeI8uggoUR+X1uBi21YZLz1tg7J3WozqY+kltNzYGEiF39KeYM0SoCOXNhwAaGiuML08dydXYLVJkqFsAZpUSjsdS0+vatI6xeGFZqtjX2R7Tj8H/mIQp/GnRcnwQ4qVDzhyVfXDAPJOsZAkBgkw/IWTV1T8ChatmAQWPweBnzzXbpOPsP95WIxIV9Mh4NK1CvlXpvHLEZsSTnpKEstzTy0Iry0Fngth0gqUBGgIh/IVSX2Vlc/xExiotrq/EtSJ+LttY6LkDMciGEzht/GljgB25UXzbhmjJolUvNiKD7eUfHeqaxNm3I++ifxGNpIBavrCXWFYsYhqMhPPfhdDqwxm6MM9WkbiuB6viRG876YqB6XCg/7R8RIjfNvRC48S7goraQywHqSWLzrII4n9Uhp/m35WxLxn8herp7mt+GilWOH/jjRmWrEkkqQnCijMDPfu9CFKc8pYS+HexM+GCZb3f/uvz5eK+DNEuL3z2F8ExMRtDXYlaAcj3zskAWWVFC0TllHffC/vglnGU1XHIiqQ97g7a7l27Keeu9dI94NMomjLJn7uJ5U9tiDtbYppWof5S5TbwhxqKS+qSyZRKbIL3VxtxnMaXXXiwvsM9WYoRU2UPh6x6pTT7NlOZ4vJpLXWnpj686SEVSIwV6XO+X1AuANc11Sh94M5IwaU94q0WOJ3Askor1+GGzflRgX8J9BvIxQoLT5ndxo81TxGsSHJaH
 B5B3gWJw
 iSsiOhAbidsKnathE3oRWy3nB4RwJV8arfw2n36tDvtL+VmYoqyN6hXegbROot7lgeMnnvFAUJ3QdEcaDSk/Ex8NsaKVzPFQce9FkRMeSKfhEty2XK50JwanipKBBvrBhawnoKf/HtN1f1/R5Mh33XErzHIVzpPWJaYCyXmFWoDAgatpVvERJX9O1oABKAGyYSKi0VABfbrqEPNjf1TTHcHCVbxe7/Jz8d4P0tjoMzEKIeteZoEJWxrRrP6BmYvqFG4hJ40fX73qU9oOWXWhnLo/wkSR+RTWOwyWvuizY3BNGCHoP6cYVddLR7748jgFOREByoM6ROOXce5E5L8mrG3Ukayb70TxKwRNeN9W/7icIwmHxV1uHXOiScDEaQ7t8xIShTDPwv1uUJA/DPQMLz7P9sg0cXqmP0dnFV5ctjNQW3AjTSSpRlR/KwZn+W8Fs7Vw3Z0HESjb1O0GAiTv579/joKdXOfgAXmW9fwOoOBKfUA9Xk+Lbw8Aa4jz76wi9rJVTyNck7yhb+QIdmBV8x+YNDFIPWBrJf7e6PHs5sp+QMzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A per-thread CPU timer holds a reference to the PID of the thread it is
attached to and, while it is armed, its node is queued in that thread's
posix_cputimers. The task is looked up by that PID.

When a non-leader thread exec()s, de_thread() changes which task owns
that PID:

  de_thread(tsk)
    exchange_tids(tsk, leader);		// tsk's PID now belongs to leader
    ...
    release_task(leader)
      __exit_signal(leader)
        posix_cpu_timers_exit(leader);	// cleans leader's queue, not tsk's
        __unhash_process(leader)	// that PID has no task anymore

pid_task(timer->it.cpu.pid, PIDTYPE_PID) then returns NULL, but the node
is still queued on tsk, which is alive. timer_lock_sighand() takes a
failed lookup to mean that the node is already dequeued, so it has
nothing to undo.

begin_new_exec() calls posix_cpu_timers_exit(me) right after
exec_task_namespaces() and that removes the leftover node, so the state
normally stays invisible. But bprm->point_of_no_return is set before
de_thread(), so if unshare_files(), set_mm_exe_file(), exec_mmap() or
exec_task_namespaces() fails, the task dies before it gets there.
exit_itimers() then frees the k_itimer while its node is still queued,
and reaping tsk later erases that freed node from the rbtree.

Dequeue the per-thread CPU timers of tsk before the PID changes hands, so
that a failed lookup again implies a dequeued node. Process-wide timers
are looked up with PIDTYPE_TGID and transfer_pid() moves that link to
tsk, so they are left alone.

Fixes: 55e8c8eb2c7b ("posix-cpu-timers: Store a reference to a pid not a task")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 fs/exec.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index c7b8f2d6366c44..f80f70e1c26de4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1000,6 +1000,18 @@ static int de_thread(struct task_struct *tsk)
 		 * the former thread group leader:
 		 */
 
+#ifdef CONFIG_POSIX_TIMERS
+		/*
+		 * exchange_tids() hands this thread's PID to the old leader,
+		 * which is reaped right after. The PID lookup in
+		 * timer_lock_sighand() then fails while the per thread CPU
+		 * timers are still queued here, so dequeue them first.
+		 */
+		spin_lock(lock);
+		posix_cpu_timers_exit(tsk);
+		spin_unlock(lock);
+#endif
+
 		/* Become a process group leader with the old leader's pid.
 		 * The old leader becomes a thread of the this thread group.
 		 */
-- 
2.43.0


