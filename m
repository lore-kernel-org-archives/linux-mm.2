Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1F50606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ftb5hbDR
Received: by kanga.kvack.org (Postfix)
	id D88326B05CE; Mon, 16 Nov 2026 06:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5E0C6B05CF; Mon, 16 Nov 2026 06:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C74636B05D1; Mon, 16 Nov 2026 06:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A00AB6B05CE
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 476D7A08AF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:08 +0000 (UTC)
X-FDA: 85440702816.19.C3B7614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F1EF40005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ftb5hbDR;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=e0NdapISO7PccEe+J1PNsovhyllFhzOUrTJOSP5Geu0=;
	b=MfiYoT1i3mLpanBz/Gej49Zy1MR2iUV+W4SnsKT5bHgJpr9DhmgWMg3yQSkkVtr096pvRd
	JGort86hcTNTyC728GL7jCGjOQYdO53v47OWBpYJhEmA7MHgX3WnTohPSJu5tzu9L6K8WE
	FLVsbMeZsnYa9KgzSp0ReSLfmuq0nh4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827166;
	b=6EabtseUB+FJoOTcCmXhEVMz3ztyfg7C+FuYGFiHboTtW1vrjFz+cvP1kN+d9/uT5gR3W4
	4M1PNhS1MH8+hY0nTNToTZZez1rvpM9k6WFTBJfErO8M/lht0DeUpz73muSdf0+TEJP0nK
	e/ChK+Stw/Pele20XKj1gUQT14neI2U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ftb5hbDR;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B7CF41843;
	Mon, 16 Nov 2026 11:06:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1506A1F000C4;
	Mon, 16 Nov 2026 11:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827165;
	bh=e0NdapISO7PccEe+J1PNsovhyllFhzOUrTJOSP5Geu0=;
	h=From:Subject:Date:To:Cc;
	b=Ftb5hbDRPHfk4mqY+as6cITFuaLQGaWxutA89/20IINyG8AWvhacek97p5schkdpC
	 AyYCKPKL3dzJKwIZjvpzwCDvwctfPx6EDdUfErpK2yneg2+klODDipbjTse0NZAQMF
	 KDfFh7yWIdi4wOGp4Gne0XRg41oYQhFJGYdhf8OxI7T9/jZ4mlgBePeiQFCrMoaNms
	 2lxrbE0M2koxPrbSXipDSd8QPoEpcTLzX03l3nBGYs3qh6mdF/e7kYBCkbShJStWdN
	 f7wfXyOSdMJZFERdfnsQJIkWQxHMv4idAUXl3qYD1xhtNrNtVTGk743z+jh6oSNcXR
	 Zr17+PGdeh04A==
From: Christian Brauner <brauner@kernel.org>
Subject: [PATCH RFC v3 00/44] fs: don't use pseudo filesystem files as
 storage
Date: Mon, 16 Nov 2026 12:04:33 +0100
Message-Id: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/23OQQ6CMBAF0KuYri1pCymtKxMTD+DWuChlgAqhp
 AXUEO4uhY1GlzPz5+VPyIMz4NFhNyEHo/HGtssQ73dIV6otAZt8mREjjFNKJH5YV+PG2g53Hob
 cYiGJSBLKBRQULW+dg8I8V/KKLucTum1LP2R30H3AQixTHnDmVKursApsFNhoY6NwD7nK+N661
 1pwpCu6daHkt8tIMcGJllLIlGuu02MNroUmsq5ce4zsU0j+CGwRpOCxVIwJXmRfwjzPb0rOqWw
 yAQAA
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>, Breno Leitao <leitao@debian.org>, 
 Casey Schaufler <casey@schaufler-ca.com>, Chuck Lever <cel@kernel.org>, 
 Sashiko <sashiko-bot@kernel.org>, Gao Xiang <xiang@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=12804; i=brauner@kernel.org;
 h=from:subject:message-id; bh=GZSpSgaz8UmPZAvkrresyb8T5SRXAMQwIkGeKnPuIsY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ehzH4Hyo+U/eC2+RpLWuBhl3ZV67Rsptc52x/+TZj
 d6/L33Y01HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJrAhXJwCMJGp1xkZvv3acip/dtPH9U2a
 2dPYXzy2dAiZMfHZt4DlhYkdAQukcxj+lzJqzgt7/jnyxBv3QqHff/6e9VG69ef7iY76S//+eHy
 S4wQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F1EF40005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: i991potjb1esjnzikch4kpn6dcouqqtc
X-Rspam-User: 
X-HE-Tag: 1794827166-324790
X-HE-Meta: U2FsdGVkX1/n7uSzs0qfQqKBTHzF00KVKHZo3/MbwEAmWEZ9ayJW7gv2Ky+3u2AiKEfeWaqYbq59jxzfJ16gVPek7rMfsa6oTlpaWywY7Q4kTA5x2uo9dbe6pjpJnrH/rwl99AkuvxT82CiSMzneaM0PHmvBztVh8kdG52M25qt2JgcufuDG4goigWx8Mqy1xn1CBPpnupn8iKATkKQsU30vcInvJv45CtoFZFlKyZGKJSgN1P1a7MC63P8SMMGEC6dFF3H13wnZLtPfaCxue6GtPdYisieExi3spOICowFuitr3lJftmawNzgi4vAsOPnVq9VXpgB8Xk0wfPtDIpYCftIdBHhyn9AvB+gUawGWoOzmYhJyRlD13itcJqVcDIPOyrTe9DztwjUJ9M/DkqfUR0cY+ju7oJHXOBuOkdonZsQYAl51DlTlEdll20QFDPjbnXPK73iwcUjJuV6rgjx082jsLq3MF0Il7aHm0oa/43VK4ujVgLg3FMKlKMLLqFD6CB44a8jmD5GrVOcIQLKQ42KsuAVEQ2x0w6JIaYh04mnBb917wQGBOTjsntay7d/M5UFzr9tIHoNitb8XpWNgnrOqHhhZxodqNeHZfcpt4Hk54ypfTgveNJrRB6BWMKEaiGSE49ACp9xMytXYf7Mq9GB1uajjT2eZXnah7caW9u7On37w3k22mX/PgW2oHlwcMuPdPPiLFQov0ebNCAuNWYiK+SpLxJE53OvXI0maaIT3Ee3qpTvHpBp8sbp8qmYRj4q9SvedUhArdibA4j0DRNMqxn9OJhf0nnZjgR/iCpFUSmRLBXh8YDAzYcOgfvvQuh+J9+C/6LRoI0llpwBVkQOaeJ9CZxnq0GjJDcjEOINz56N5vrfoNjbNWAYWrvTyqwH1QM26JaxKtp5nmfhqwTXXFGZ/LVw5vs6SIimjD8gmB+B2Z6giubp3ZBAJJHNPgjV8xZKRVMDyzZYN
 TOO174Wk
 E7Ydp5MUW1DOtjp90d3DUUoJ4WWtQ1BDCG6gMAtVZAEndN9MLvgJBsuc1tGiKzSmPUiYAlWzLaqmbZVAVE44SRPzT6vrPKCiUB0FKkh7Ef8VE4N71FIA20Ir1zr3orFP+aWJAyFYW5U6GEell2zCq78a3KRVMVRoRnEq+bY+wxQVfJdSPunyIEvvPI1abVhfY6oQcbTt8roil6hgAtgGvfGzDGNB0JMmNfD2u7m8JLWhTuqq4fG4lQlDTytBeF247NXtvkH3/duAAc0EjbqOZhvmC4suVCvlb/XkYlKhoQ3qpzP644ubs2aZxj1d6zBNOUVFO/cfPnPxj4RE=
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
silly and not abusable. Same for acct(2) which happily writes its
records to cgroup2 or binfmt_misc files.

Fwiw, device mapper doesn't need anything. It only takes block devices.
md's deprecated bitmap file is fine as well. It maps the file with
bmap() which no pseudo filesystem implements.

So this series adds SB_I_PSEUDO to state that the regular files of a
filesystem are kernel interfaces and not storage and makes all eight
refuse such files.

I didn't want to sprinkle SB_I_PSEUDO over all pseudo filesystems one by
one. Instead there's now a common initialization point for all of them
via fc_init_pseudo().

init_pseudo() uses it for the internal pseudo filesystems and all
mountable pseudo filesystems call it from their ->init_fs_context().

kernfs does it once in kernfs_get_tree(). It raises SB_I_PSEUDO,
SB_I_NOEXEC and SB_I_NODEV. Pseudo filesystems never hold executables
and generally never hold device nodes. Some of them raised SB_I_NOEXEC
and SB_I_NODEV already, most didn't.

I went through every single one of them. None of them needs to execute
anything. The files that can be mmap()ed map data and the tracing ring
buffer refuses VM_EXEC anyway.

SB_I_NODEV is cleared again by devpts, binderfs, selinuxfs and
securityfs. The first two did that already. selinuxfs needs it because
Android init opens /sys/fs/selinux/null by path as /dev/null doesn't
exist yet at that point. securityfs needs it for AppArmor's .null device
node. On exec AppArmor puts it in place of file descriptors the new
profile isn't allowed to use and those can be reopened via
/proc/<pid>/fd/<nr>. Note that systemd mounts most of these filesystems
with noexec and nodev already.

file_check_backing() looks at d_real_data_inode(). overlayfs happily
stacks on top of sysfs, cgroup2, debugfs, tracefs, configfs and
securityfs and reads of such overlayfs files are served by the pseudo
file. Only procfs and binfmt_misc are refused as they set s_stack_depth
to FILESYSTEM_MAX_STACK_DEPTH and efivarfs as it has its own ->d_hash()
and ->d_compare().

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
Changes in v3:
- Rebase onto vfs-7.5.lookup which has "fs: let d_real() fail" v2:
  https://patch.msgid.link/20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org
- file_check_backing(): use d_real_data_inode() and fail with its error.
  For an O_PATH file on overlayfs the data might not have been looked up
  yet and when that lookup failed ovl_d_real() warned and the check
  passed. (Chris, sashiko, bpf-ci)
- ovl: refuse data-only layers on pseudo filesystems. (Amir)
- fuse: also check the backing file that fuse_passthrough_open() opens
  for io. (Amir)
- securityfs: clear SB_I_NODEV again. AppArmor's .null device node can
  be opened by path and via /proc/<pid>/fd/<nr>. (Chris)
- selftests: add fuse passthrough tests and tests for overlayfs
  data-only layers on pseudo filesystems.
- Collect tags.
- Link to v2: https://patch.msgid.link/20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org

Changes in v2:
- Add file_check_backing() and use it in all consumers. It replaces
  file_is_pseudo() and most of the open-coded file type, open mode and
  method checks.
- nvmet, fileio and zloop refuse everything that isn't a regular file
  or, for nvmet and fileio, a block device.
- fileio: check the protection file as well. (sashiko)
- acct: refuse files on all pseudo filesystems. (Alexander)
- selftests: add nvmet (Bui), fileio, zloop, link, FIFO and character
  device tests.
- Collect tags. They are dropped on the patches that changed.
- Link to v1: https://patch.msgid.link/20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org

---
Christian Brauner (44):
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
      ovl: refuse data-only layers on pseudo filesystems
      selftests/ovl: test data-only layers on pseudo filesystems
      fs: add file_check_backing()
      loop: refuse files on pseudo filesystems as backing files
      zloop: refuse zone files on pseudo filesystems
      nvmet: refuse files on pseudo filesystems as namespace backing files
      target: fileio: refuse files on pseudo filesystems as backing files
      fuse: refuse files on pseudo filesystems as passthrough backing files
      usb: gadget: f_mass_storage: refuse files on pseudo filesystems
      erofs: refuse files on pseudo filesystems as backing files
      acct: refuse files on pseudo filesystems
      selftests/filesystems: add backing file tests for pseudo files

 arch/powerpc/platforms/cell/spufs/inode.c          |   2 +
 arch/s390/hypfs/inode.c                            |   2 +
 drivers/android/binder/rust_binderfs.c             |   3 +-
 drivers/block/loop.c                               |  14 +-
 drivers/block/zloop.c                              |   5 +-
 drivers/nvme/target/io-cmd-file.c                  |   4 +
 drivers/target/target_core_file.c                  |  14 +
 drivers/usb/gadget/function/f_fs.c                 |   2 +
 drivers/usb/gadget/function/storage_common.c       |  11 +-
 drivers/usb/gadget/legacy/inode.c                  |   2 +
 drivers/xen/xenfs/super.c                          |   2 +
 fs/binfmt_misc.c                                   |   5 +-
 fs/configfs/mount.c                                |   2 +
 fs/debugfs/inode.c                                 |   2 +
 fs/devpts/inode.c                                  |   2 +
 fs/efivarfs/super.c                                |   2 +
 fs/erofs/super.c                                   |   5 +-
 fs/failfs.c                                        |   3 +-
 fs/fuse/backing.c                                  |   4 +
 fs/fuse/control.c                                  |   2 +
 fs/fuse/passthrough.c                              |   7 +
 fs/kernfs/mount.c                                  |   4 +-
 fs/libfs.c                                         |   2 +-
 fs/nfsd/nfsctl.c                                   |   2 +
 fs/nullfs.c                                        |   3 +-
 fs/ocfs2/dlmfs/dlmfs.c                             |   2 +
 fs/openpromfs/inode.c                              |   2 +
 fs/overlayfs/super.c                               |   8 +
 fs/proc/root.c                                     |   4 +-
 fs/pstore/inode.c                                  |   2 +
 fs/read_write.c                                    |  53 ++
 fs/tracefs/inode.c                                 |   2 +
 include/linux/fs.h                                 |   2 +
 include/linux/fs/super_types.h                     |   1 +
 include/linux/pseudo_fs.h                          |  12 +
 ipc/mqueue.c                                       |   3 +-
 kernel/acct.c                                      |   6 +-
 kernel/bpf/inode.c                                 |   4 +-
 net/sunrpc/rpc_pipe.c                              |   2 +
 security/apparmor/apparmorfs.c                     |   2 +
 security/inode.c                                   |   4 +
 security/selinux/selinuxfs.c                       |   5 +
 security/smack/smackfs.c                           |   2 +
 tools/testing/selftests/filesystems/.gitignore     |   1 +
 tools/testing/selftests/filesystems/Makefile       |   2 +-
 tools/testing/selftests/filesystems/config         |  16 +
 .../selftests/filesystems/overlayfs/.gitignore     |   1 +
 .../selftests/filesystems/overlayfs/Makefile       |   1 +
 .../filesystems/overlayfs/pseudo_datadir.c         | 131 +++
 .../selftests/filesystems/pseudo_backing_test.c    | 936 +++++++++++++++++++++
 50 files changed, 1271 insertions(+), 39 deletions(-)
---
base-commit: 68cb948e620cf297cee090d6effd04dfef6429de
change-id: 20261109-work-loop-pseudo-890844168ef1


