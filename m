Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6F8CDB466
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 08:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B3B36B0088; Thu, 25 Jun 2026 04:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7914B6B008A; Thu, 25 Jun 2026 04:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2D86B0092; Thu, 25 Jun 2026 04:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0836B0088
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 04:50:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5E521C5DD7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:50:55 +0000 (UTC)
X-FDA: 84917814870.23.3904A68
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 275C518000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 08:50:51 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=k6dtMMJ4;
	spf=pass (imf24.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782377453;
	b=LPhVYakQEMtOFz7/LTk1jfPcdyh7NuY6DCLBM1jCYhXlA603srK8xtSAKm1RqvKyGvBRd+
	Pqqe5aY2AcD/6e3Lt0nFERCswy5o+2REKjWaqj9P50ZjGq2L++FPVHh9rkckPdPye8y4TG
	GYEAFckYrlFbD1OWPhZDPtumMDxnncw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782377453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dwl9BXYyih4rkHzUa6Zl9OdrIWhLlRb0XmAM4mKHrgk=;
	b=V1x84l8p51PtwPzzUFGKkW8k7C+UpJbqoWYLTVlEK9eNLn9HXX26aaXJiLLR9UhWkmwEQI
	k1FnVWOed04UJwk3XcseY8Qtf2fJ9gwVGOtJpZYEvBr/nEkdoKBeaHykotbdoszY6zU2PH
	IN8QzTFKxuvKpUQ43faRvI6S/Ss4yFg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=k6dtMMJ4;
	spf=pass (imf24.hostedemail.com: domain of jackzxcui1989@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=jackzxcui1989@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=dw
	l9BXYyih4rkHzUa6Zl9OdrIWhLlRb0XmAM4mKHrgk=; b=k6dtMMJ4LK2GLoXivM
	TjYxLQ5b1e46NMyHE28KqJqU45H+z6U70sBcxzOM01mejqoQxZLgX/H95UbQrBag
	+0Jfs2ByY0IURORbJCILBincxULrNqhYkkXVCNFwsZCvKZOc5FCxSUYd7V2J+y/v
	gd91mMEsiJEWRd6ugZsmWh3nY=
Received: from zhaoxin-MS-7E12.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnLwzK6zxqNeJOEQ--.60795S2;
	Thu, 25 Jun 2026 16:50:19 +0800 (CST)
From: Xin Zhao <jackzxcui1989@163.com>
To: brauner@kernel.org
Cc: alex.aring@gmail.com,
	allen.lkml@gmail.com,
	arnd@arndb.de,
	chuck.lever@oracle.com,
	david@kernel.org,
	ebiederm@xmission.com,
	j.granados@samsung.com,
	jack@suse.cz,
	jackzxcui1989@163.com,
	jlayton@kernel.org,
	keescook@chromium.org,
	linux-arch@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mcgrof@kernel.org,
	mjguzik@gmail.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	viro@zeniv.linux.org.uk
Subject: Re: [PATCH v4] coredump: Add /proc/<pid>/coredump_pre_exit for pre-exit before dumping
Date: Thu, 25 Jun 2026 16:50:18 +0800
Message-Id: <20260625085018.989584-1-jackzxcui1989@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
References: <20260625-wappnen-drohbrief-wermutstropfen-c53538f01547@brauner>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnLwzK6zxqNeJOEQ--.60795S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxKw1DGry7Kw1rZFy3CrW3KFg_yoW7Wr1xpF
	WrKa9akr1kGr1Utas7tw18XF10krWfAFW5urn8Ww42v3Z8Cw1fZr1fKFWY93yDArna9w4j
	qr18ta4UCr1qvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pR7PEsUUUUU=
X-Originating-IP: [124.77.128.91]
X-CM-SenderInfo: pmdfy650fxxiqzyzqiywtou0bp/xtbC6AzX4Wo868yfCQAA31
X-Rspam-User: 
X-Stat-Signature: 6dgu7pfmu6ja4p6rtn6yk4hscyddqehs
X-Rspamd-Queue-Id: 275C518000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1782377451-776154
X-HE-Meta: U2FsdGVkX19jRmqmt2KOOdCLg4T2/Qn+QGepb8AB2cdEAHqLP03H7/D9EnSSUug3vFji1qCaWpDMZis3CTrL8vTv95S3UKOVybYk0ihTcTbAZaKMJNhRmeReoIcR+76VeknYJg/hFcWuP9SGWCubwlOC3pyB+U47dlqH6y8KfGEEJ9F1PJvDLzdLLBReD0G00rEsQaYtnzgxVi3ZuifcId0eIQk/SY5Hvvbi26OQ4ZrqVEfM0b2SNyQGjLpLO2AvMer98sndC0kCXXqakeVhO1tjcm/TJeTGY92H2JAASqvgC1Zhk+MXdSZ2nod5tSaTDWIxMGsJwIuQW9qajKLE/4RRABtqhUdOPpyAp5XLIZpRX3wVNg1w/LBayejRKo6y5UpHpqaK29QpKjCkrjZ7yqN8ekX+Qc8EY7kFx168BYlGOD4gvyUKpD8OOiiXpsIhIOolyJe497e9bY/cnUCpSnI5XAD8e3fUVkIRq0ToFYTe8Qm/8fCsD7w3T6mE56M/KiBYAfCbbW8a4KNFJ/dVU/QcEankIjv/nrDXZFtW9XiHDmBsjHbnBLivtKQMWatl++Hb4Fi8KnAN7mJGJ3NZuDFZXoV9ziM1hlOYUV2+6dAb3cXZT4voQ6qw4OMgkS679jxam1PHId2cghyEx7f+e4oma2erKGz0Z6r/0Vhn7lFARoertiKGy/75TDDsuNCmhVLdfFdPwrcvTUIxtrWecmnFHzxKWb7Ag/Opaq/lYEubRoaXU1i5PK2GRLrCHW2+cP9zgfS54uOZjer3xniOm5rGSUlijKlpYW6sBVcC90IzarhO0Tb+zR+nmKoMJlxCnBJXOPIqQS3wfANdL5f7lvNakENHrTBLuYfKnG9wTLcw1nKOOA8j1sv8HiV01jftrC2ZvW8yB+H3QwYJuuj7uiLTOeTgc68m3VDFS44MDO3bZBDGMUlH+G6jTPChbtQVvjvHopH2RhFCjRyJXw6
 vTyblvqF
 k0TnNV42N7wZhgjvD1hQUXLUgn/1Vr9gb64ruumMmzJbkTXo5Kv4hm1wRWlKPqureUCc3Z5w8aIXpBvOmyIlkFhNm5sgBbBhJn3LPidJEGXYQpw4WzTYvfSE/sYfMiu3p8sI4+JM2VBgSi/Us9tfLSa0qc+Q22maIeruQLt4H4sD1jI5aBS+GYRrINXISznMpdyE7wKg7YrNRgJtciVaqTm9v35pEnDRNylo4pcokRJ5s2JzgBKYFqQrhhm4tTYS0aM3d5iLJlKfk9A4lmtUeyKbzRiJQoWBTesJexgwY8eJZY/h4JKPPtbzBR7QjmY0igWBXKWJrHk0Lk9cKHgmIJzbrAW69hY7pffY/ZNazNh2/oqNqegdA5lxeARRD0ntVIeUBqwWiuzQPUqCwkjKv2s0uKcsFK8yv1Xe7c//uQcWKfOL2Rtf2ZY8QMaYt99IN02eemcGHwfHfyye7bxssy1ykH0zTaTvWYB4rgtpPVMV6bb37hLtpIuWb+rfCScVMaFDDUBVTWmPbBwAx4iiZRFo2ABw7kjAw8SeUOxUh5+2fvaFkG+EvKQxXbXYFFx3q/owuQyI/QGyiVvWOI93zsg9ZNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 09:28:08 +0200 Christian Brauner <brauner@kernel.org> wrote:

> > +	coredump_pre_exit=
> > +			[KNL] Change the default value for
> > +			/proc/<pid>/coredump_pre_exit.
> > +			See also Documentation/filesystems/proc.rst.
> 
> Nah, we're not doing a separate file for this. That makes no sense
> whatsoever. I've already explained this in the first mail. There are
> effectively three modes:
> 
> (1) dump to a file
> (2) spawn super-privileged usermode helper process connect coredumping
>     process and said helper via pipe
> (3) coredumping process connects to AF_UNIX socket
> 
> Parameterize (1) and (2) via a command line arguments. I strongly
> suspect you're using some AI tooling so it should be able to figure out
> how this was done in the past.
> 
> (3) can be extended by just introducing a new flag value for struct
>     coredump_req. That is also illustrated by previous work.
> 
> We're not spreading procfs files. It's terrible api design especially
> for security sensitive changes.

The coredump socket approach is easier to implement because it allows for
interaction between the server and client, enabling the customization of
protocols. However, for the coredump file method, I can only think of
defining "r" and "R" through core_pattern to release flock and file-backed
shared data in advance. I'm unsure if this is feasible, as it changes the
original definition of core_pattern.

Regarding the coredump pipe, there is also a lack of a mechanism for the
pipe program to notify the coredump process, so it might still require
adding "r" and "R" at the end of core_pattern to indicate this, allowing
the coredump process to handle the early release on its own. I'm not sure
if my understanding is correct.

Even if the coredump pipe program obtains the file pointer from the process
that generated the coredump, it cannot reduce the reference count of the
file (which I understand is a very bad attempt). Since it cannot decrease
the reference count of the file, the early release must still be performed
by the task that generated the coredump. Given this situation, it seems
that we indeed need to use core_pattern for marking. I've thought for a
long time about more suitable solutions, but I haven't come up with any.


> > +#ifndef O_TMPCLOS
> > +#define O_TMPCLOS	0x80000000	/* tag need close, temporarily used */
> > +#endif
> 
> Sorry, not going to happen. This doesn't not justify the addition of a
> new uapi value at all.

OK, if I use it at last, I will not put it in user header file.

> > +
> > +__setup("coredump_pre_exit=", coredump_pre_exit_setup);
> 
> This makes no sense. I think you really need to sit down and think about
> a design for this that doesn't introduce state machinery for boot, mm,
> and the VFS in one shot to solve a fringe problem...

I'll get rid of the attempt to add a new boot-up argument for this feature.

> [Severity: High]
> Does modifying the VMA maple tree via do_munmap() during the for_each_vma()
> iteration invalidate the outer iterator? The loop traverses the maple tree
> using the iterator vmi. However, do_munmap() creates its own internal
> VMA_ITERATOR and removes the VMA from the tree. Because the outer vmi
> iterator is not updated to reflect these structural changes, its cached
> state becomes stale, which can lead to a use-after-free when vma_next()
> is subsequently called.
> 
> via: https://sashiko.dev/#/message/20260624145552.70143-1-jackzxcui1989@163.com

When executing this traversal logic, we have already acquired a lock, and
the process has been frozen. The traversal logic goes from start to finish.
Are you sure that this approach could still have issues?

> [Severity: High]
> Is it safe to iterate the file descriptor table without holding
> rcu_read_lock()? Because coredump_pre_exit() is called before zap_threads()
> kills other threads, concurrent threads can still trigger expand_files(),
> which replaces the fdt and frees the old one after an RCU grace period.

Since the process has already been frozen, shouldn't we not need to consider
such concurrency issues?

> [Severity: Medium]
> Similar to the issue in exit_mmap_mapped_shared(), this non-atomic update
> of file->f_flags risks losing concurrent fcntl() updates since it doesn't
> hold file->f_lock.
> 
> Also, if a file has duplicated file descriptors (e.g., via dup()), will
> clearing O_TMPCLOS here prematurely skip the closure of the remaining
> descriptors? When encountering the duplicated descriptor later, the flag
> will already be cleared, leaving the shared file actively referenced.

> [Severity: Medium]
> Similar to the issue in exit_mmap_mapped_shared(), this non-atomic update
> of file->f_flags risks losing concurrent fcntl() updates since it doesn't
> hold file->f_lock.
> 
> Also, if a file has duplicated file descriptors (e.g., via dup()), will
> clearing O_TMPCLOS here prematurely skip the closure of the remaining
> descriptors? When encountering the duplicated descriptor later, the flag
> will already be cleared, leaving the shared file actively referenced.

Currently, this flag will only be used by the logic we added, so I believe
there won't be any issues.

Thanks
Xin Zhao


