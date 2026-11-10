Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A8D606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iJREp1Nw
Received: by kanga.kvack.org (Postfix)
	id E07F56B05B0; Tue, 10 Nov 2026 04:16:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7896B05B2; Tue, 10 Nov 2026 04:16:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E886B05B3; Tue, 10 Nov 2026 04:16:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 932E56B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:00 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EF0E1A0117
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:00 +0000 (UTC)
X-FDA: 85418652480.08.DD312BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4EA6F140004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:15:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJREp1Nw;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PuZuHEnsND00fHRoxO3q8GjJUd6kGJ0dXTi/U306um4=;
	b=4K2bXgYD+rKoMuixcT12fO/I2JNqsahJh1zk4r/efXamaGT4B+svkhAn+sOMglSLs1SR2L
	e9L8xd2FiNHuDqbV1AAtQyGTk3Z2X02DmAYOrydX6jB4wmTuq8BFRLIOvwhmI2Q+QMV/xp
	iwbltu6BKPfbIw/4X1Oi9EVEYBltUw4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302158;
	b=u4KFanGRlWyiOXO8+U6vnfeE60xU1y9YYIeHwb0b5K2s3j91gHmiIlxzqiL/+tN9pMabG5
	Q9LZixAM4X4JW0wwPvFO2+xxK0rwc+291h0BYbqp7lCf1f5W0PJA6hD1bnunKiov8/+p+W
	Y8+3Ak51SEVnjjIsglWsWj8IRyhDYTw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iJREp1Nw;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B15EE602A8;
	Tue, 10 Nov 2026 09:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CCE11F008A1;
	Tue, 10 Nov 2026 09:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302157;
	bh=PuZuHEnsND00fHRoxO3q8GjJUd6kGJ0dXTi/U306um4=;
	h=From:Subject:Date:To:Cc;
	b=iJREp1NwHp3BdNh6YhirQMz3aLkdMJad9SaoqicwlHouUofyAaOyHUxlQAMyZlF7r
	 dxoDogK7Z/SmQMPjvGb107aIw98Hug2c7nyD4DMV9g1SOQKjCPLz3oKAbIbpZoqTaD
	 pZrbqTndD5C37PARA3QH+ymdbAjgpqhVM8lgzWc8vdrxfAWdPiJr4Zuz7epLK6TvTH
	 K8+0uuv2p91CoV2BZDxur21nCPhrfDd3bYEfgv9CR8OaiC0kdRmQmvH415KgWFHkQX
	 DEVbxCY/pgx0ga6OIRh+WS9KothVO+G1SwN3cmU1cAxe1h0Acn2ceEg6DAhgL9k4pG
	 roZHSfl8QE69g==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC 00/41] fs: don't use pseudo filesystem files as storage
Date: Tue, 10 Nov 2026 10:14:16 +0100
Message-Id: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQ6CMBAF0KuQWTtNSwgpbk08AFvjoi2DVE3bd
 ERNCHeXyvL/+fMWYMqeGI7VApnenn0MW1CHCtxkwo3QD1uGWtatUrLDT8wPfMaYMDHNQ0TdSd0
 0qtU0KtjeUqbRf//kBfrzCa57ybO9k3sVrMysYUKbTXBTqQorCit2VpQ7rOsPZFHYQaEAAAA=
X-Change-ID: 20261109-work-loop-pseudo-890844168ef1
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=10223; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WAx5V1LxGhR1UvA5SWC4CADg+JxO9oBzu81M/1sMo5Y=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejD52Vp9Rt+JU9PPyLRYcDzr9thcK9op63nkT0XG0
 9tVb6tZO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiG8XI8J1572stqcqPZ3dm
 znK65z3nlUlHTqE/T8hKpkDxSwpWsgz/FKwaX6+8IPBNt3Ftpf31vw35c90UOxbdS3Dp+3xJ6N0
 RDgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: kyr9ok3fzyoemm3htf3aywctffkzs4ri
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4EA6F140004
X-Rspam-User: 
X-HE-Tag: 1794302158-809895
X-HE-Meta: U2FsdGVkX1/Bj3RmV7lnLCXesjjrRccM/l7eTChvOY3LMW7p06iSNarwAh2fWr3pn82OEEdT17bv9GU6QjXQkFsUq1yQtmVvNPDpMZKZRWs2/PNckpKdaS+tbBOWWEaj+edjG8DCudODBKENHWofPfDh2IbH+HgXT0sM/FQvUQw8nnJj9TaXUqdCLUJYMK9bRR+e+S6j20NNBLr6a/S/5sPPYX4Ym2LjQ+9CwG2qUKtoYQdinI0gGBAYy8aEo+GU8GQY7Gl6e97FZ+9ypzXjNu2X9uoVy/lwUFiqf/KJ1R/bBiDXKc5hSmylR0niKFnVubv1pJE9tLETsZav6tKPDaydQeuqx1xcUo4G7+ZXi3hOkQ0Hisu0Taabe1kxaMY/cI33ZLbXBTIf0RIoJSkQ45G4At1tBVp2eO42MOjc4iBGlCNFAIp4DCkcDAChJZlMnM8Ib/Btt5dkT6UX8K1vkqI5TNebfLQIqknGQOaLkyAUpuaF95Lq6m3xfNZdyHQ6j/7P9d80tq4ySkiM1tEgHvY1NieTB0TvZbt+NW9X1JXMY9ajvINCEaI2zk96K++Zb5yF/6gcL/KHzpZ5uL0oMamva7CF1D33A6cgfTS9RWQJkL08ng3OwLlp9qBXKtyLyhTwnKY8By/fYukROudRybhnWuOQZIf+QrMXIJZZfkT/KtHR5Z0u31dfT90LUsSeMsmMetkO/HcUsbcDschLNsoB2Ku+plx9LV68buCBgrq6OkAIGI7DmNrxtigJr8WerxHsdUMftfCdZh6dN/6lH+E1NeSXE7/6kYEPVjrBysibBvfZiFBpJcKt8QZdEdeVjT1O/KdBtQO0EPGOuK449uva6F4JEhFJLfZLBipjarB9Yt2iZld1h5sAmVk7Ccn7neH0Rrz3uEU2iLfbECgVQFU4kbQLyaZbWBcyyH49sWmgBcaAs/6PnTpM1ldzAynmI8J/4PKLRNc0K2ygbRL
 f/VbRe57
 nsuD1EXE1GysR+FZLw/OqUEacQLyAHyi+qmWL6zy2b/gnDqPisEZXAZa1tX9uNXRr/1203uaO1GBWZ7R25RSQgsBHMXR7V3f7CrDlWp2FL65gAMSPgxRq5u3JdAQ0mJxxLNu8ieynfG0jpbZzbIaC9hKlwSLLE+tcUtxGp6m8m/MD3nrtcTUeAxDhzilfZrAkUdxmRPQdCRL4zeBPVbKexe93JiIP2E+5Lr5Y3L4B6noB7z0VaMS2FtYioA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Loop happily takes any regular file with ->read_iter() as a backing
file and any file that also has ->write_iter() as a writable one. A few
examples:

* /proc/kcore attaches read-only as a loop device the size of the
  kernel's virtual address space (64 PiB with 5-level paging)
* sysfs attributes attach read-write as 4096 byte loop devices
* using /sys/kernel/mm/transparent_hugepage/enabled for the loop device
  and writing a block to the loop device changes the THP setting

It's not just silly. It's abusable (is that a word?). Loop calls
->read_iter() and ->write_iter() of the backing file directly from its
kworker which runs with kernel credentials.

But pseudo files enforce part of their access rules at read and write
against the caller. So dozens of sysfs ->show() and ->store() methods
call capable().

But setting up a loop device requires no capabilities. It only requires
access to the device nodes. So whoever has a loop device skips all of
the capable() checks.

A couple of fun examples:

On v7.4-rc1 uid 0 without any capabilities can't kill a process of uid
1000 and can't poison its memory either:

    $ grep CapEff /proc/self/status
    CapEff: 0000000000000000
    $ kill -9 327
    bash: kill: (327) - Operation not permitted
    $ echo 0x220689000 > /sys/devices/system/memory/hard_offline_page
    bash: echo: write error: Operation not permitted

But put hard_offline_page behind a loop device, write a block
containing 0x220689000 to the loop device and the loop worker happily
does it:

    Memory failure: 0x220689: recovery action for dirty LRU page: Recovered
    MCE: Killing victim:327 due to hardware memory corruption fault at 7f468e972000

That hard_offline_page is a write-only file doesn't stop loop from
using it as a writable backing file either.

Other fun examples:

(1) soft-block radios via /sys/class/rfkill/rfkill*/soft
    (CAP_NET_ADMIN)

(2) change the reboot mode via /sys/kernel/reboot/mode (CAP_SYS_BOOT)

(3) reconfigure md arrays via /sys/block/md*/md/. md_attr_store()
    requires CAP_SYS_ADMIN for every md attribute.

(4) reconfigure scsi disks via /sys/class/scsi_disk/*/allow_restart and
    friends (CAP_SYS_ADMIN)

(5) read dmi-sysfs attributes (CAP_SYS_ADMIN)

And an unprivileged container that was handed a loop device can change
gro_flush_timeout of its own network devices. That usually requires
CAP_NET_ADMIN in the initial user namespace (via sysfs and via netlink).

I've reproduced that all on v7.4-rc1.

Aaaand zloop, the nvme target's file backend, the scsi target's fileio
backend, fuse passthrough and the usb mass storage gadget have the same
problem. erofs takes pseudo files as images for file-backed mounts as
well. It reads them with the mounter's credentials though so that's just
silly and not abusable.

Fwiw, device mapper doesn't need anything. It only takes block devices.
md's deprecated bitmap file is fine as well. It maps the file with
bmap() which no pseudo filesystem implements.

So this series adds SB_I_PSEUDO to state that the regular files of a
filesystem are kernel interfaces and not storage and makes all seven
refuse such files.

I didn't want to sprinkle SB_I_PSEUDO over all pseudo filesystems one by
one. Instead there's now a common initialization point for all of them
via fc_init_pseudo().

init_pseudo() uses it for the internal pseudo filesystems and all
mountable pseudo filesystems call it from their ->init_fs_context().

kernfs does it once in kernfs_get_tree(). It raises SB_I_PSEUDO,
SB_I_NOEXEC and SB_I_NODEV. Pseudo filesystems never hold executables or
device nodes. Some of them raised SB_I_NOEXEC and SB_I_NODEV already,
most didn't.

I went through every single one of them. None of them needs to execute
anything. The files that can be mmap()ed map data and the tracing ring
buffer refuses VM_EXEC anyway.

SB_I_NODEV is cleared again by devpts, binderfs and selinuxfs. The first
two did that already. selinuxfs needs it because Android init opens
/sys/fs/selinux/null by path as /dev/null doesn't exist yet at that
point. Note that systemd mounts most of these filesystems with noexec
and nodev already.

file_is_pseudo() looks at d_real_inode(). overlayfs happily stacks on
top of sysfs, cgroup2, debugfs, tracefs, configfs and securityfs and
reads of such overlayfs files are served by the pseudo file. Only procfs
and binfmt_misc are refused as they set s_stack_depth to
FILESYSTEM_MAX_STACK_DEPTH.

Whether all pseudo filesystems should refuse stacking is a separate
discussion. overlayfs reads the lower file with the mounter's
credentials so a root-mounted overlayfs on top of a sysfs directory
hands capability gated reads to every reader. With SB_I_PSEUDO overlayfs
could easily refuse them.

The first three patches are independent fixes. Loop never checked
whether its backing file is open for reading. It relied on
vfs_iter_read() refusing such files. Direct I/O never went through
vfs_iter_read() and since v6.15 buffered I/O doesn't either. So whoever
has a loop device can read files they could only open for writing. And
the nvme target's file backend and the scsi target's fileio backend call
->read_iter() and ->write_iter() without checking that they exist.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
Christian Brauner (41):
      loop: refuse backing files that aren't open for reading
      nvmet: check that the file backend supports ->{read,write}_iter
      target: fileio: check that the backing file supports ->{read,write}_iter
      fs: add SB_I_PSEUDO
      kernfs: use fc_init_pseudo()
      proc: use fc_init_pseudo()
      binfmt_misc: use fc_init_pseudo()
      mqueue: use fc_init_pseudo()
      bpf: use fc_init_pseudo() for bpffs
      nullfs: use fc_init_pseudo()
      failfs: use fc_init_pseudo()
      rust_binderfs: use fc_init_pseudo()
      devpts: use fc_init_pseudo()
      debugfs: use fc_init_pseudo()
      tracefs: use fc_init_pseudo()
      configfs: use fc_init_pseudo()
      securityfs: use fc_init_pseudo()
      selinux: use fc_init_pseudo() for selinuxfs
      smack: use fc_init_pseudo() for smackfs
      apparmor: use fc_init_pseudo() for apparmorfs
      nfsd: use fc_init_pseudo()
      sunrpc: use fc_init_pseudo() for rpc_pipefs
      fuse: use fc_init_pseudo() for fusectl
      efivarfs: use fc_init_pseudo()
      pstore: use fc_init_pseudo()
      xenfs: use fc_init_pseudo()
      openpromfs: use fc_init_pseudo()
      ocfs2: use fc_init_pseudo() for dlmfs
      s390/hypfs: use fc_init_pseudo()
      powerpc/spufs: use fc_init_pseudo()
      usb: gadget: f_fs: use fc_init_pseudo()
      usb: gadget: gadgetfs: use fc_init_pseudo()
      fs: add file_is_pseudo()
      loop: refuse files on pseudo filesystems as backing files
      zloop: refuse zone files on pseudo filesystems
      nvmet: refuse files on pseudo filesystems as namespace backing files
      target: fileio: refuse files on pseudo filesystems as backing files
      fuse: refuse files on pseudo filesystems as passthrough backing files
      usb: gadget: f_mass_storage: refuse files on pseudo filesystems
      erofs: refuse files on pseudo filesystems as backing files
      selftests/filesystems: add backing file tests for pseudo files

 arch/powerpc/platforms/cell/spufs/inode.c          |   2 +
 arch/s390/hypfs/inode.c                            |   2 +
 drivers/android/binder/rust_binderfs.c             |   3 +-
 drivers/block/loop.c                               |   6 +
 drivers/block/zloop.c                              |   5 +
 drivers/nvme/target/io-cmd-file.c                  |  10 +
 drivers/target/target_core_file.c                  |  15 ++
 drivers/usb/gadget/function/f_fs.c                 |   2 +
 drivers/usb/gadget/function/storage_common.c       |   5 +
 drivers/usb/gadget/legacy/inode.c                  |   2 +
 drivers/xen/xenfs/super.c                          |   2 +
 fs/binfmt_misc.c                                   |   5 +-
 fs/configfs/mount.c                                |   2 +
 fs/debugfs/inode.c                                 |   2 +
 fs/devpts/inode.c                                  |   2 +
 fs/efivarfs/super.c                                |   2 +
 fs/erofs/super.c                                   |   6 +-
 fs/failfs.c                                        |   3 +-
 fs/fuse/backing.c                                  |   3 +
 fs/fuse/control.c                                  |   2 +
 fs/kernfs/mount.c                                  |   4 +-
 fs/libfs.c                                         |   2 +-
 fs/nfsd/nfsctl.c                                   |   2 +
 fs/nullfs.c                                        |   3 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |   2 +
 fs/openpromfs/inode.c                              |   2 +
 fs/proc/root.c                                     |   4 +-
 fs/pstore/inode.c                                  |   2 +
 fs/tracefs/inode.c                                 |   2 +
 include/linux/fs.h                                 |  12 +
 include/linux/fs/super_types.h                     |   1 +
 include/linux/pseudo_fs.h                          |  11 +
 ipc/mqueue.c                                       |   3 +-
 kernel/bpf/inode.c                                 |   4 +-
 net/sunrpc/rpc_pipe.c                              |   2 +
 security/apparmor/apparmorfs.c                     |   2 +
 security/inode.c                                   |   2 +
 security/selinux/selinuxfs.c                       |   5 +
 security/smack/smackfs.c                           |   2 +
 tools/testing/selftests/filesystems/.gitignore     |   1 +
 tools/testing/selftests/filesystems/Makefile       |   2 +-
 tools/testing/selftests/filesystems/config         |   9 +
 .../selftests/filesystems/pseudo_backing_test.c    | 274 +++++++++++++++++++++
 43 files changed, 419 insertions(+), 15 deletions(-)
---
base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
change-id: 20261109-work-loop-pseudo-890844168ef1


