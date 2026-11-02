Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F91606C557
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HiivqBNd
Received: by kanga.kvack.org (Postfix)
	id 9F0386B0613; Mon,  2 Nov 2026 10:19:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C63A6B0614; Mon,  2 Nov 2026 10:19:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DDAF6B0615; Mon,  2 Nov 2026 10:19:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4736B0613
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:19:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D664FC0130
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:19:29 +0000 (UTC)
X-FDA: 85390538058.19.1F0ABAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id E364C1A000D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:19:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiivqBNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793632768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Oc8DmgxGioqkR/9qk3a4pltP7ArAEGeuKF7qww97tvM=;
	b=YKWLlcXzBKd5HZPLXdG4p6acwxrDveXUQUhEd6Qct1JH+AEPLACXtajuP5xSfI9KsPY/IU
	V9aHcY1KlaARjdD3f15w9fpYtpO51hi19VT/mMKrHAS4tQAIDcnYZ1it6+qSRiMDUP03ap
	xBVnZTGC4n5TzadSOAxOZYSJ9yPyLO8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HiivqBNd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793632768;
	b=iyLKMtni53bSSrBYHfX1i1MbQlYjQ5W5PT4rnII/XsHWP3W4KhENKeG5v1XeQ1RteioDGU
	on/bYKm4XFl32y42FWn9AG+iWny8PgUmvIfAGdXzpY+2WrTJ+T3+T/Uye7bzQZMs/Z0i6j
	dALuT1rwmUBcfU2PTDgd4/SSvXRe2rI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B6DA40700;
	Mon,  2 Nov 2026 15:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54621F00A16;
	Mon,  2 Nov 2026 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793632767;
	bh=Oc8DmgxGioqkR/9qk3a4pltP7ArAEGeuKF7qww97tvM=;
	h=From:Subject:Date:In-Reply-To:References:To:Cc;
	b=HiivqBNdbktMB3jIR2AZpFD8s6Tn7iHfe8kJ0WslNzaoAQW5kc7o0gRDBArnpxDsS
	 CtfL51KKLRBSwt+j3D7V1//ejI98V61eo5T0NlexRsUi5c8pC1GbUMNrvk4YIwh8E5
	 2lhDypmE88DBG1tieFL1FjjkiAc9DS68lntunq5HpGVUJiZJWOvuGdSub19BrAbLty
	 mrA/DenKQtkX+TIPLm37CWzKJ4S67BQQ5VCO1dvBtJzcV1DDF470qP/7oLpQMpdRK1
	 T/4sZq0Faz7QcfBjhDQAlwLqisGwJC3D3nAo8pdpGdJQsFprczR6CHYKoPi6OQI8eX
	 km5AalwrjwlXw==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 00/27] proc: convert the fs, kernel and mm entries
Date: Mon, 02 Nov 2026 16:07:10 +0100
Message-Id: <20261102-work-procfs-fs-v1-0-d09a996317b3@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22OwU7DMAyGX6XymUxNmnVpr0g8AFe0Q+LYLKA1w
 +kK0rR3J2XTTki+/L/sz98FCkmiAmNzAaEllZSnGvRTA3jw0zupFGsG05pe61ar7yyf6iQZuag
 6VvPAEa0bMEA9Oglx+vkDvsHryzPsb2U5hw/CeUWta8EXUkH8hIe1WqGbG3QTJS0k5Q4T+jpXq
 flOfDiNzb9GmIWUY2+9ZasN8rjoxz/Mx2Oax6bfBu+4s4TO9YQ7Ewy2uxjRIXfR6S12xvVDhP3
 1+gsC/z1/IQEAAA==
X-Change-ID: 20261101-work-procfs-fs-41f9fdc489cb
In-Reply-To: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
References: <20261102-defizit-jobaussicht-kurios-7016c6e67442@brauner>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
 Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
 Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
 Greg Kroah-Hartman <gregkh@suse.de>, 
 Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
 Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
 linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
 linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
 linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
 coreteam@netfilter.org, kexec@lists.infradead.org, 
 linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
 netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
 linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
 linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
 linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
 sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
 linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
 linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
 linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
 linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
 linux-debuggers@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Chuck Lever <cel@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8569; i=brauner@kernel.org;
 h=from:subject:message-id; bh=6lMrJQN91rnuCiXg2l4F0Y5JeubSe/EgzAgxv51kRnM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WG7I7/625f3h7Cqd5DNl2xf/OvlHY0/nxX2OC1eoq
 c38/udvX0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBECo0Z/goyKdd8SMi1Y43f
 /3aj6Iub5itcN6opMgkcrnwpe3DK1hMM//Q+yfyds/PFlb03GAyP//g85/4Pr0O5e65Xx839JOd
 xK5QZAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: E364C1A000D
X-Stat-Signature: 4nzqbaigneymhtj3zmf3y7ddhmqe13ic
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793632767-456625
X-HE-Meta: U2FsdGVkX1+N+3I2GhkHXDyNj3IoZO6Z2vcwLJqe5Ze8Qt2r8cIWGtQ3nYMJWhRidGtGcHVVS239RbDCAjlkAY1HyRuHuJ6S+R+9yu9gOetGm3frBn3LjQFngZM1Wx3zEgx1sKlihJjZ/W4Yr/LkRiL4IW55EkcWHXFyBLL40Av1zOYN9pMPKUckHiExtJ5Wjs3MBPUmq48hQun4SQHlhl5PF6lr9ufbcIH7fU7VRbHchAaFqcBtcDG7JOB4OCKCslxLAQHmH0yDgXdLnrPHrYxrlPMSnsr6RlgvGl7smLLcQ1q/PCdU6FPm/zSihnXqCyI8hsKhSoAlkAhfMoJBk8yhTErzq2sJd1MjcBWBJW2t31II/rbdp2jqqkQaPrR3kXlTTs8eF3Mc3dBPx9fsSk4rLuASt5KI/F0lt4rV8GCa9Ko07GJO7yPx44MajTlbNU2vzKeeH3Dr5atkDpEmBb+hxGMkcHhxvNtci0K4dA/Be9UGDwuw8VFSuyaEs+XA5QraZSXHI65/qOo3ql8DBuK5yzvNZvAs71iybqNV6vvTJOohYYemYMEV1t20jQyn80tsT0e9y/TwLLwWC0oasUFUoxB8Vkzf1ipMMRWDyA7IjCr51fxFuJad41dsk/oGRTUqMA7M3Ig55/byRQlBue7lnzkhZxTGxyiP6B7Nwco+x9L+9oG2JaBbv6FOQMH4OBZj1CnLtH+xlH37FEJ/DYsykD83MRh/Tf1B3ujg0Hc507seiLQiWvEiW25N7jU13IWaaT/fPBV0QldEOBokNsf27taVdfu2sQdNwXvptKpgSpJ4dCbKnHUY/zExaz/DucBe49YoYzvipjp5B7Jxt9ImclDJM04Gj4VM1ijoVsE+R12xOikF8QCF6iQ1VKk1g+jN0Y4tYUqM+wSkZTw0ZxcicQP8DGa7EpwJwnw1sXBNCHueuq0+dxE2iWMMwU+I5Efy/ohaf1/V5/C0tLt
 u/uXhsxa
 /bbfnGIBobpMt++4R7FNORIOFOmdAKv5+7Rb249E5ZfF8bz4LpWek/MG5m21HhFkuNa8QyKSPLTTybBBf3tPQBhK079P6dCh0uNkzVi3d6QFzW+RyFT5HSr8b0ti2d8AWtWjR3e2g6DhO3ZYXdGc5TbwltxafwPfMzBvdL4QR4zOlHe89+yOhGEXSnso1yL5ULBu0xg9PTQaQ1FgSKCyQ/nztfRwVVVjaQTdWXIThzN5lPHoa86LYt1KjnEvtGMrZ2fGUFWYbWdFfZNDupRwcR0FwSHYNIseSag1U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This converts the proc entries of jbd2, jfs, lockd, nfsd, ntfs3 and
cifs, the irq affinity files, latencytop, lockdep, /proc/profile,
/proc/pressure, kallsyms, /proc/modules, dynamic_debug, sysvipc,
allocinfo, /proc/swaps and /proc/config.gz to what "proc: let procfs
own the data path" set up: procfs owns the seq_file, copies in writes,
copies out reads and copies ioctl arguments in and out, so the entries'
code only ever runs with the entry pinned and never touches userspace
memory.

One patch per subsystem and method, in the order seq_file, write, read,
ioctl. Where a write that is larger than anything the entry parses now
fails with -EINVAL from procfs I've called that out in the commit.
/proc/profile and /proc/pressure/* are never removed and are marked
permanent, procfs calls into them without pinning. readprofile reads
all of /proc/profile in one go, so it keeps reading straight into
userspace. /proc/config.gz asks for PROC_ENTRY_FULL_READS so that
reading all of it at once keeps working.

The selftest unloads configs.ko while a reader of /proc/config.gz
faults in procfs' copy to userspace. On a KASAN and lockdep kernel it
fails without the series and passes with it. Build tested per commit on
x86_64 and with W=1 on the touched objects. The proc and allocinfo
selftests behave the same with and without the series and so do the
entries I could get at in a VM.

This is on top of "proc: let procfs own the data path". The other three
conversion series don't depend on it and it doesn't depend on them.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (27):
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
      profiling: mark /proc/profile permanent
      sched/psi: let procfs own the seq_file of the pressure files
      sched/psi: let procfs copy in trigger writes
      sched/psi: mark the pressure files permanent
      kallsyms: let procfs own the seq_file of /proc/kallsyms
      module: procfs: let procfs own the seq_file of /proc/modules
      dyndbg: let procfs copy in writes to /proc/dynamic_debug/control
      ipc: let procfs own the seq_file of the sysvipc files
      alloc_tag: let procfs own the seq_file of /proc/allocinfo
      alloc_tag: let procfs copy the ioctl arguments of /proc/allocinfo
      mm/swapfile: let procfs own the seq_file of /proc/swaps
      kernel/configs: let procfs copy out reads of /proc/config.gz
      selftests/proc: check that unloading configs doesn't wait for a reader

 fs/jbd2/journal.c                                  |  33 ++---
 fs/jfs/jfs_debug.c                                 |  11 +-
 fs/lockd/procfs.c                                  |  19 +--
 fs/nfsd/nfsctl.c                                   |  41 ++++--
 fs/ntfs3/super.c                                   |  27 ++--
 fs/smb/client/cifs_debug.c                         |  71 ++++------
 fs/smb/client/dfs_cache.c                          |  13 +-
 ipc/util.c                                         |  14 +-
 kernel/configs.c                                   |   7 +-
 kernel/irq/proc.c                                  |  27 ++--
 kernel/kallsyms.c                                  |  12 +-
 kernel/latencytop.c                                |   5 +-
 kernel/locking/lockdep_proc.c                      |  60 ++++----
 kernel/module/procfs.c                             |  19 +--
 kernel/profile.c                                   |  11 +-
 kernel/sched/psi.c                                 |  82 ++++-------
 lib/dynamic_debug.c                                |  34 +++--
 mm/alloc_tag.c                                     |  75 ++++------
 mm/swapfile.c                                      |  13 +-
 tools/testing/selftests/proc/.gitignore            |   1 +
 tools/testing/selftests/proc/Makefile              |   1 +
 tools/testing/selftests/proc/config                |   4 +
 .../proc/proc-remove-slow-config-reader.c          | 157 +++++++++++++++++++++
 23 files changed, 400 insertions(+), 337 deletions(-)
---
base-commit: 65ba8f34ec886ec72b2c07ddc8cf3d815c32869d
change-id: 20261101-work-procfs-fs-41f9fdc489cb
prerequisite-change-id: 20261101-work-procfs-core-8fa4a4f412cf:v1
prerequisite-patch-id: 0474af12959624910718795bf86684383664c685
prerequisite-patch-id: 540aa9ea28adcbc54d8264f66314e29e3b8c9d49
prerequisite-patch-id: 2f7139d1c972c4439dccca610caa5f1288987a3d
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
prerequisite-patch-id: 78f067c343177e52d49ddfe9ee2992e602549869
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
prerequisite-patch-id: 4ed6b3d3d45de49d4967e88ba4e7f03372775f55
prerequisite-patch-id: dbe02fe3f784776fda5e7ae99f077bef0cd4b48d
prerequisite-patch-id: 53edc9a95afff57c4acba40095a8054924261ea2
prerequisite-patch-id: cf9ce0099005fd3bc31a1e15131d48e315ac3bee
prerequisite-patch-id: 16a657a5d0046068dbace29e7ea046ac1441f46f
prerequisite-patch-id: efeb2d6f7df71d5dede2c1d12fe999a28e38aab9
prerequisite-patch-id: e6ffe2a5c3ee5645f56c8366b568fbc9f140848c
prerequisite-patch-id: 117db27dcdef433de7c6be5e95973cac1e373927
prerequisite-patch-id: a0844aa26ffb65ccb362b88ef6c2f4758e15edbf
prerequisite-patch-id: 143fb91bddf33068b6ee11e205818c4c2815e23d
prerequisite-patch-id: 6490e4da1cb2f543683bd164bc9a5a1c943057e7
prerequisite-patch-id: cdefca57d3c552fb6f6b928699edd85f33be25fd
prerequisite-patch-id: 2f0fdb970ddd760d85ff5d2caad0b96348270182
prerequisite-patch-id: f2aa468ff5cbb1cabab3f70e1b8eeee0286cfb4a
prerequisite-patch-id: 037030d95eeb7c49b1e43f638ec954f2cebbcfb1
prerequisite-patch-id: 487141c49e2548310bfb6c2a0964a78f08b285a9
prerequisite-patch-id: c3d3008819fa5629a18142ec9ba6d7024ade7fdb
prerequisite-patch-id: ba15e7c86b60ccc2f0f7ee4c9bc99073068757bc
prerequisite-patch-id: 9423f410b99853693db06c29f12f1c08278b050d
prerequisite-patch-id: 4e7966978e4b11c4d843831f312cdcd5b848f00c
prerequisite-patch-id: 3d24be1897a624d519ef144801f76d152c7528a9
prerequisite-patch-id: 3b4d9fe7b26f6b7b9b3f7725ea333df357107c44
prerequisite-patch-id: 7d9dd345428baeb88c862ef902612f7160dc1d8c


