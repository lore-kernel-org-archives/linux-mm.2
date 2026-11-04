Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D34860760B7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NLwOQCg8
Received: by kanga.kvack.org (Postfix)
	id 81F0C6B05B0; Wed,  4 Nov 2026 14:49:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7336B05C7; Wed,  4 Nov 2026 14:49:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CBB6B05DD; Wed,  4 Nov 2026 14:49:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB576B05B0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:49:54 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1AAB14066D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:49:53 +0000 (UTC)
X-FDA: 85398477066.22.FB2C898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 170F5180009
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:49:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLwOQCg8;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6cDreIf7GRylbu30URLPBSOYJ7SnntN/Y0sQlapJ/Vw=;
	b=woBdaot6OnWymPmvghb1u6pc3FFS2rcn0qsECDGzkBcnt8JPjU6PGmd5Nmsigk8aN8zR+Y
	GwOlEXJxwR1J3tJASpq4bgzv4Q+v9boPc6QMnege/A4rzkk6FQXFNwN+wOrHQJZiEx8LKi
	EvRDcp1/DqSWjkM56tfNkE8J/c2fTa0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821792;
	b=8qWjh8mniBxAJNGCIY1/Xl1RfUDtvt9loFjFRzT1dU/R9X6IxQYPuLBRg3eeJ1p5QymjE1
	K/wppP0cQIsvFMAtvjCD6CNcRK4Cq3tjeUGce8UspBH1BQHsx1lC78dILkg4P1HcTnCbyx
	Il6SAd+922QeyTAWevL4v5DqsHuGfr4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NLwOQCg8;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 85C3860F01;
	Wed,  4 Nov 2026 19:49:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1290E1F000C1;
	Wed,  4 Nov 2026 19:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821791;
	bh=6cDreIf7GRylbu30URLPBSOYJ7SnntN/Y0sQlapJ/Vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLwOQCg8xlhxuouxAQjf77CEIMV1QJeDgr8dXmJ21SbM+dz8MCVFMJYVqEScjWwA5
	 CpjZaJJcwHTdm9BO1Do5RjrbhBmV0v5m+CEEO3/iDq/XaLtua2HLrnzgvWwAQlh9dA
	 KOPWwkgHIombmJp00fZ3PSVd64BO13dQcs3h/wnkvYYQSsMxQA6EBcujHKNKMkFiFe
	 /iFFE0v0Z5fMe/ZwWgf9IqoRrH9Yj3TYsnLJK36EpCqDbkDClgrvbNNI8a7tWd8v69
	 O97tPJ/lnx5iYAu1yyRr0JPkAEL07++dqL9bksjFSqrjjRMtXUjL9RZ7ngllWnrvi/
	 USjSGkwg41ISw==
From: Christian Brauner <brauner@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Jann Horn <jannh@google.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Chris Mason <mason@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neil@brown.name>,
	Eric Dumazet <edumazet@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Jonathan Corbet <corbet@lwn.net>,
	Christoph Hellwig <hch@lst.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Joel Granados <joel.granados@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jan Kara <jack@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	netdev@vger.kernel.org,
	ntfs3@lists.linux.dev,
	platform-driver-x86@vger.kernel.org,
	coreteam@netfilter.org,
	kexec@lists.infradead.org,
	linux-pci@vger.kernel.org,
	linux-sound@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	ibm-acpi-devel@lists.sourceforge.net,
	jfs-discussion@lists.sourceforge.net,
	linux-alpha@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	linux-hwmon@vger.kernel.org,
	linux-mm@kvack.org,
	linux-sh@vger.kernel.org,
	linux-usb@vger.kernel.org,
	samba-technical@lists.samba.org,
	sparclinux@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-doc@vger.kernel.org,
	linux-serial@vger.kernel.org,
	linux-atm-general@lists.sourceforge.net,
	Takashi Iwai <tiwai@suse.de>,
	linux-input@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH RESEND v2 00/30] proc: convert the fs, kernel and mm entries (Part 5/7)
Date: Wed,  4 Nov 2026 20:49:36 +0100
Message-ID: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
References: <20261104-work-procfs-v2-0-b45cd5789ac5@brauner>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Change-ID: 20261101-work-procfs-fs-41f9fdc489cb
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=12030; i=brauner@kernel.org; h=from:subject:message-id; bh=EC5jlFUpGnI8lIO3hGLQgcKPP/NzLYP5KDghoTtHo1Q=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97tH6Eb83TKbGtOTSjAXXMpqnnLd7n3nv+3wjp0DTr aqJHAEGHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMRCGL4p3fpub+o9bsDHF1h tjIxG9OYlPiNS/5F10Uf3xN6y6NxBsM/jaUWm372/OoRLHq0MFHU68HE/AOmQces568It/7z5qY +BwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 89if7j5radqg4bnnbg3jooy5zefrwt1c
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 170F5180009
X-Rspam-User: 
X-HE-Tag: 1793821791-388125
X-HE-Meta: U2FsdGVkX18Shu0A2rdY8yWHgGnMMeiHQPcmgs5Nvcj4rVn6gb2cWBOc5FV6nzJdCo9M2VLA4ckFztmJsLgcKBGjiaTg1VL/4znscSVgjxc3hN/o6grw9pxA3g3IVZbGO8o1d73UNAHIp0oJ6p4V7wOALicAsoKfwYQ9HW+pBgPYStpR/SfV/j+JnOVS5AmOPSMyIO5o4wqffcmqxSuPM/P9eMC60IxOQ5OJaLNdQ6bbOxrfv54IfZUgfHYqKd5x0ClLMcOTJSfmPWVhkdPEM4BI9ulTqfwQcDiycM+dxAomjgIA9nCjg2fuaNXl9xIfBkCBiehRBOETwl+PISSjy3tHAp6hjEtU7vvHS1vizlaEbY/79yCOWLfJmumIPW2q3r/BOg26IZBFIUj+wkxobn1ei2bWlItIp5TLfglVHKTwU/biduIgCQBT0MPrgWvJCFqmpcpV/ihi4VN76a+FGnbtU4jh8G0+rCUuEDYtNtJC/8939PPXnfYjX16YsGPG1yZtj2oT1oCH8kOaZFGYmZc8Q+l17lGPgDGLVcFwoIwhMidncHi7bQ3yK8tsjH32Dg3ClmuTnngltT2niJtOiap8uNZLnSILuw01iWPhGezPYAP4VqneGG9EuzFXnDNVNjHXvqY34VDIZmSuzocj0ST5/1P0LfDxKJxi5Qp1+//bgCBXfk/PFpxAKsomduQS5c7KHEWnZdM2zCK4tTYiTGDWTdDbrEkdxIWTfKta7YRNFoTmH7l0WDg/4PPSbbaLnVOmc6fK4Sa9ZExcuA6ZRsKf73tdeeLxCvMu5vOuMVZHKsKk1vhe8hrmT9Y+vHT4JYA1kKPWi6kYfJYhblODrdw17RqqVepRxBFfr8gkaCnl6VaEJzy5Sci9TmeZGMkWx0qZ7ICn18CxqCbQIg6zSE75KN5c4kDfOk7RcGZrTAKoVKOEwzOhDy1q8OnUQ9f2owEoRC6DGRpA4Vl7WtV
 S1YkyYSf
 R+ax21U1C1JDFCx2b06FfpAxBN5tAQqtSIw8x17xpbjpvXGuEoKSY1oM6oqx+FogDAqV3KcQbGyZ2a4Mo43tQvS2JAKLsE9zp6pBjfDuOcO1FFV6kfWVYvG7evifxYC5BdW2cYeUav5jDmvIJyNJoKdICxyLkqUJOXQWSGtt9wbd74VBi8XKT4hD9eio7MlVZX7JaT2YDmiceas1vQutJp86HDqCxSD7bILdUf4WQGOd7Dm/gGFBEvv7CvWzRftE11jCv8G/UMbuVPs8KxP514Ey03qDYTlWTqaCdihv8xlE4q5ZR3/8GBxlQ0THOzrPcrmAbJ7nkOTGSB9QtEBskKUJ0/xOqfcuJlBsNdg8jvRckDm91ybphqs1eew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Part 5/7 of "proc: move procfs to what kernfs does", on top of part 2
and independent of parts 3, 4 and 6:

  https://patch.msgid.link/20261104-work-procfs-v2-0-b45cd5789ac5@brauner

This converts the proc entries of jbd2, jfs, lockd, nfsd, ntfs3 and
cifs, the irq affinity files, latencytop, lockdep, /proc/profile,
/proc/pressure, kallsyms, /proc/modules, dynamic_debug, sysvipc,
allocinfo, /proc/swaps and /proc/config.gz to what "proc: let procfs own
the data path" set up. Afterwards the entries' code only runs with the
entry pinned and never touches userspace memory. One patch per subsystem
and method.

- procfs owns the seq_file of jbd2's info file, /proc/fs/nfs/exports,
  the smbdirect files, /proc/lock_stat, the pressure files,
  /proc/kallsyms, /proc/modules, the sysvipc files, /proc/allocinfo and
  /proc/swaps. Their open and release hooks only do what is left, a
  snapshot, an iterator or a reference, and reading one of them no
  longer holds up its removal.
- procfs copies in the writes of jfs's loglevel, nlm_end_grace, ntfs3's
  label, the cifs files, the irq affinity masks, /proc/latency_stats,
  /proc/lock_stat, /proc/profile, the pressure triggers and
  dynamic_debug's control. Most of them just parse procfs' copy, the
  affinity masks and dynamic_debug ask for a larger write size. Where a
  write larger than anything the entry parses now fails with -EINVAL
  from procfs the commit says so.
- procfs copies out the reads of nlm_end_grace, /proc/profile and
  /proc/config.gz. readprofile reads all of /proc/profile in one go and
  so does whoever reads /proc/config.gz, both ask for
  PROC_ENTRY_FULL_READS so that reading all of them at once keeps
  working.
- procfs copies the ioctl arguments of /proc/allocinfo in and out and
  converts the pointers of 32-bit tasks, so the compat ioctl goes away.
- /proc/profile and /proc/pressure/* are never removed and are marked
  permanent, procfs calls into them without pinning.
- /proc/swaps and the pressure files move their pollers to the wait
  queue procfs owns for the entry. A pressure file has one queue for all
  its triggers then, like the cgroup pressure files have in kernfs, so
  every poller of the file is woken when any trigger on it fires and
  each reports the state of its own trigger. That's a few extra wakeups
  for the daemons that poll these files, I don't think it matters.

The selftest unloads configs.ko while a reader of /proc/config.gz faults
in procfs' copy to userspace. On a KASAN and lockdep kernel it fails
without the series and passes with it. Build tested per commit on x86_64
and with W=1 on the touched objects. The proc and allocinfo selftests
behave the same with and without the series and so do the entries I
could get at in a VM.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Changes in v2:
- psi and swapfile let procfs own the wait queues of the pressure files
  and /proc/swaps, a pressure file has one queue for all its triggers
- /proc/profile reads go through procfs now like everything else, with
  PROC_ENTRY_FULL_READS; v1 left it reading straight into userspace
- Acked-by from Chuck on lockd and nfsd
- the selftest commit applies on the core series alone
- rebased onto v7.4-rc1
- Link to v1: https://patch.msgid.link/20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org

---
Christian Brauner (30):
      jbd2: let procfs own the seq_file of the info file
      jfs: let procfs copy in writes to the loglevel file
      lockd: let procfs copy in writes to nlm_end_grace
      lockd: let procfs copy out reads of nlm_end_grace
      nfsd: factor out setting up the exports seq_file
      nfsd: let procfs own the seq_file of /proc/fs/nfs/exports
      ntfs3: let procfs copy in writes to the label file
      smb: client: let procfs own the seq_file of the smbdirect files
      smb: client: let procfs copy in writes
      genirq/proc: let procfs copy in the affinity masks
      latencytop: let procfs copy in writes to /proc/latency_stats
      locking/lockdep: let procfs own the seq_file of /proc/lock_stat
      locking/lockdep: let procfs copy in writes to /proc/lock_stat
      profiling: let procfs copy in writes to /proc/profile
      profiling: let procfs copy out reads of /proc/profile
      profiling: mark /proc/profile permanent
      sched/psi: let procfs own the seq_file of the pressure files
      sched/psi: let procfs copy in trigger writes
      sched/psi: mark the pressure files permanent
      sched/psi: let procfs own the wait queue of the pressure files
      kallsyms: let procfs own the seq_file of /proc/kallsyms
      module: procfs: let procfs own the seq_file of /proc/modules
      dyndbg: let procfs copy in writes to /proc/dynamic_debug/control
      ipc: let procfs own the seq_file of the sysvipc files
      alloc_tag: let procfs own the seq_file of /proc/allocinfo
      alloc_tag: let procfs copy the ioctl arguments of /proc/allocinfo
      mm/swapfile: let procfs own the seq_file of /proc/swaps
      mm/swapfile: let procfs own the wait queue of /proc/swaps
      kernel/configs: let procfs copy out reads of /proc/config.gz
      selftests/proc: check that unloading configs doesn't wait for a reader

 fs/jbd2/journal.c                                  |  33 ++---
 fs/jfs/jfs_debug.c                                 |  11 +-
 fs/lockd/procfs.c                                  |  19 +--
 fs/nfsd/nfsctl.c                                   |  41 ++++--
 fs/ntfs3/super.c                                   |  27 ++--
 fs/smb/client/cifs_debug.c                         |  71 ++++------
 fs/smb/client/dfs_cache.c                          |  13 +-
 include/linux/psi.h                                |   3 +-
 include/linux/psi_types.h                          |   8 +-
 ipc/util.c                                         |  14 +-
 kernel/cgroup/cgroup.c                             |   2 +-
 kernel/configs.c                                   |   7 +-
 kernel/irq/proc.c                                  |  27 ++--
 kernel/kallsyms.c                                  |  12 +-
 kernel/latencytop.c                                |   5 +-
 kernel/locking/lockdep_proc.c                      |  60 ++++----
 kernel/module/procfs.c                             |  19 +--
 kernel/profile.c                                   |  22 ++-
 kernel/sched/psi.c                                 | 112 ++++++---------
 lib/dynamic_debug.c                                |  34 +++--
 mm/alloc_tag.c                                     |  75 ++++------
 mm/swapfile.c                                      |  23 +--
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   2 +
 .../proc/proc-remove-slow-config-reader.c          | 157 +++++++++++++++++++++
 26 files changed, 430 insertions(+), 369 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261101-work-procfs-fs-41f9fdc489cb
prerequisite-change-id: 20261101-work-procfs-core-8fa4a4f412cf:v2
prerequisite-patch-id: a81e8b894107e48d607f8257d2c9f56e0dd6f400
prerequisite-patch-id: 7edf7ca7ecd32c9e09085e4b65922af10097beaa
prerequisite-patch-id: 81f6893f79b4236637675553298a6f2892b603f3
prerequisite-patch-id: 598c2b1a389f47adcac88ebcf1c9f74e2511fbab
prerequisite-patch-id: 6f5a2172dacc5ff2491fa9832c48ccd0e1ce1eda
prerequisite-patch-id: 8947af6490288e4e2a3b2bf8844a974bedb1d975
prerequisite-patch-id: 8cbe756286fd95967d31b0c46cacfeb05f0a2c6b
prerequisite-patch-id: 3fa159f2b6ccd0ac51a2662e4eec5587ec18de89
prerequisite-patch-id: bfb4e4ffe9631cb58015fefe6bd3698cd53e2244
prerequisite-patch-id: 56ff6667a57a962264c07c0227c61aa2f1f4c22c
prerequisite-patch-id: bc506323e29944ec0c29eae84950c706a8592042
prerequisite-patch-id: 326c0ebb5accf0f40cbee1323fb4c3378f5be154
prerequisite-patch-id: d6eaf7690a54a0dfda7500936a048b769fa265dd
prerequisite-patch-id: 7c7b2535642b4d388e13eab518cbe0f9550eb1e6
prerequisite-patch-id: 0474af12959624910718795bf86684383664c685
prerequisite-patch-id: f6d4191e23c22e2d2cc90cc5d04781f913e98a8e
prerequisite-patch-id: b0031a7c4855b7ec38259c59f30f65101a8fc4b5
prerequisite-patch-id: 0b7f226abf2b9ff41873a1aa55cf97747647d56b
prerequisite-patch-id: f63e345f897619af54813958046617c655fb7daf
prerequisite-patch-id: c0e21e762a2960e3324c5ab04634a7035e515fa6
prerequisite-patch-id: fd59c71eadd8f39c58b3baea93567bc093bc9b0e
prerequisite-patch-id: 5d52cc8a5c73e4c5ba16b8e24f51408c17583bf9
prerequisite-patch-id: 1f9179284e2f3314d4b46ac5e989089a21c7576c
prerequisite-patch-id: 10397bbf696bee16dc71eb79fff6c5e73842bcbc
prerequisite-patch-id: 9b44279dcf08912238d2f6438a3328a778a79a0c
prerequisite-patch-id: 16854b621a3a71dfc365aaf7abaa7f65adfe9f7e
prerequisite-patch-id: ca42eea21fae1fd1cd3518ab057c74b61ffd68fe
prerequisite-patch-id: 23255dc2be76b0479c083dbd4c897bfbb533aed5
prerequisite-patch-id: 82129c687ebf0a41b369893b92f2c038420ab801
prerequisite-patch-id: 56ad57a99a5bda075a9f4e844368974296744934
prerequisite-patch-id: 288b3cbaa11e01a778cc3d7beb6c0549aacf59f2
prerequisite-patch-id: a163b1549608652bfa5bd9ff93efa55b541010c4
prerequisite-patch-id: 43b92dfc1a98fbf0d14597a3e3ae99972844773b
prerequisite-patch-id: 19c12bc6e3fbed35acc1f657196b1a997f48cdfe
prerequisite-patch-id: 5800c3076694bad719954b2ad4d7448c6e013bfd
prerequisite-patch-id: 2a2f63d8843b159594b9eee6ddea028ce76a6270
prerequisite-patch-id: 40a1951d57906c4a1b98a4bd96a814b80339b9c5
prerequisite-patch-id: e2141077e69f20a2b27fab69c8d61d0686682f53
prerequisite-patch-id: c4d6018c26c40dc549d88330d23ce48f872c2b7f
prerequisite-patch-id: 6de8ec17746031bc6d1d9ac262c5be0f905fcd79
prerequisite-patch-id: b87bcb167884605bff1fd0f2ed8a88942d07efd5
prerequisite-patch-id: cfa9a8b4c67e20cfd22d77035bfd21ee96ab3298
prerequisite-patch-id: abf3482ed2399b7b2e1ee72e937af05bb9200667
prerequisite-patch-id: 02c175b2dee565a85b3308ecf2ec8e3c9a029e0f
prerequisite-patch-id: d58c239fba616b366a725de6acba3f88734156d0
prerequisite-patch-id: dbe02fe3f784776fda5e7ae99f077bef0cd4b48d
prerequisite-patch-id: 53edc9a95afff57c4acba40095a8054924261ea2
prerequisite-patch-id: 5348d8957eb7eae7430ca8b101aa84ce77d3aa4f
prerequisite-patch-id: 36c96d781e2dd80b20932667bbe6e7fd14976069
prerequisite-patch-id: efeb2d6f7df71d5dede2c1d12fe999a28e38aab9
prerequisite-patch-id: 17f95c7fdf0bdc7c8aaaf7883bff1dcc19a0f529
prerequisite-patch-id: 117db27dcdef433de7c6be5e95973cac1e373927
prerequisite-patch-id: a0844aa26ffb65ccb362b88ef6c2f4758e15edbf
prerequisite-patch-id: 9c64355dfde62e399f2717d9208c4607834d4650
prerequisite-patch-id: 9644739854ddfe2876f17fda8727fd5119255957
prerequisite-patch-id: c61bba24c035f79a2a32a80ace0924ab58e97f46
prerequisite-patch-id: 143fb91bddf33068b6ee11e205818c4c2815e23d
prerequisite-patch-id: 9ce9be2ff05250f92d945c0084f4bb31d3d0b27d
prerequisite-patch-id: aee0961341523547095a43ae298cb8b551302f10
prerequisite-patch-id: 2f0fdb970ddd760d85ff5d2caad0b96348270182
prerequisite-patch-id: f2aa468ff5cbb1cabab3f70e1b8eeee0286cfb4a
prerequisite-patch-id: 5555895bcbca4d7c9888ecc9e82c0e4d76da8f40
prerequisite-patch-id: 487141c49e2548310bfb6c2a0964a78f08b285a9
prerequisite-patch-id: c3d3008819fa5629a18142ec9ba6d7024ade7fdb
prerequisite-patch-id: ca587c976690ac16e3d759fccab2116fef0508e8
prerequisite-patch-id: 9423f410b99853693db06c29f12f1c08278b050d
prerequisite-patch-id: e269815617a6324615a38916b8886f99d98c641e
prerequisite-patch-id: 3d24be1897a624d519ef144801f76d152c7528a9
prerequisite-patch-id: 1ea3fc8319d9012faaf3a182ac61d5da89aafdb7
prerequisite-patch-id: 7547b4e2c1b3588acf6caf90cc01fe7884fdb6bd
prerequisite-patch-id: 695d325349ebeb89bf0ea24bcf0c4f1c4edacab5
prerequisite-patch-id: e33502a202979aba0d6fdaf196e8471d906992a1
prerequisite-patch-id: 47bfe4f07677ad75fe8d9accc8923a1cbdf3afa6
prerequisite-patch-id: 9fc0739226572203fcb36f2c271be7b27f405ef2


