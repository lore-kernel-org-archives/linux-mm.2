Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3341E6076706
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S9KQjE5w
Received: by kanga.kvack.org (Postfix)
	id 544F86B05CF; Mon,  2 Nov 2026 09:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51C776B05D0; Mon,  2 Nov 2026 09:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4593B6B05D1; Mon,  2 Nov 2026 09:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 261856B05CF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:26:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B1C84160124
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:02 +0000 (UTC)
X-FDA: 85390403364.25.E001DF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F0FA04000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:26:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9KQjE5w;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qYcECRdDX1PrLgMJOdiUzXJ2kaKILzuHrLaM8GQSRjg=;
	b=7LDHz2iAI8hGDUV9omcANmVmkJqPCMgpdHJzNJfcJkbTU3DlwaIH8qmmR2Bhs1fhTmeoua
	SQP0ClfiCh3TD3ToNpEOe3YpBbMyZKI2TRG4dkNdYLXisaFTSk43XVD+vGwDeOrTUbdpZD
	1XXRJpUFyxqY2wzMDAbK8rlM0jonJ3k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629561;
	b=foor7yPRriqY7caFHTh01xw5XzEkTH49JjJI2W7CCm9cXQWQcdjTmnq5NZTtDhdkMJ5+k2
	uzr+TGj1Da22EPeP5GVgsOSqVb2vhpTii3i3i9tQbgCRBE8BSpu7s+3kNI7YzpH4gvdRlt
	Doic+3yhi9g2FaeL2FICLKqk2B8LCLQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S9KQjE5w;
	spf=pass (imf27.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FFF160236;
	Mon,  2 Nov 2026 14:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139161F00A17;
	Mon,  2 Nov 2026 14:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629560;
	bh=qYcECRdDX1PrLgMJOdiUzXJ2kaKILzuHrLaM8GQSRjg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S9KQjE5wRZaW8pMK48TuAEmOLD748GqwlgZgKrfSco97/731a7MDcvtdowW3T/B3m
	 NvPqfIKQwOF2sxhuKNeKw2glbD9GcUTLKErI1N8MeSY2feI0MfU6hQ0PDqhrSxlAax
	 ysx6+msJ3hHzjq6HRREY3YeW3DHo+bXrboL45uA1tUVTth9lHX0m7ISaar/jKS0zMf
	 IYZHmi5qTiRrg7GVbV4rddIoHh/fUlFGqHzxDtnW0GBToUrP55eD+22JF1NKxgOElA
	 EhFTmchNaS1rz8TR2eJwc5sdtCFgjqMQFTOhS+e8PSQ5scuItmZ72v036nNEZPi/4u
	 grk/S5BPt88Hg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:33 +0100
Subject: [PATCH RFC 18/38] proc: don't WARN about a name that is already
 registered
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-18-59422ed3e465@kernel.org>
References: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
In-Reply-To: <20261102-work-procfs-bugfixes-v1-0-59422ed3e465@kernel.org>
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
 Chuck Lever <cel@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=brauner@kernel.org;
 h=from:subject:message-id; bh=aKtCMuJhN5pC0AyNIxMzKE8+AJEG5eL6v+vagw86wsU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJMtrTidr2u/hEYo58Xov6ysMy+tyPQIcGfZ/8nw1
 F7R28+edZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyE3YeR4YrY7evvwlZMuvjO
 T2W501ZR+/rFjmErd1jlrvaS/Heoz5nhn/Z+UxH3og0pqhNqZy+2Y5tgn39oqvmlQwLG8Uf9Zic
 oMgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0FA04000B
X-Stat-Signature: mcem57beaw3d8ambttfar5us7ijr9ycw
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629560-127062
X-HE-Meta: U2FsdGVkX19HMShlJFRBmF6YjMP4dwkMzyHjU/YrqneZ5VMtWIb2dZ7DM3qYPIrD1xi3t07WyJ4cuwFV7Fdj//o4xE16MVfqv3gXy7OfqRtlNq1PCkw3BQBe7e0XSstgIJ0Xl1eFJjLk4EPWVg9oaLl1OJY2OchFsWZp9cUpd3h2LGZQ/hvJzcvETeRWt+wedFgZTpFlgjUMwT62/Rt2c+O0VFgg8pv6Y57tAUJ3FP3jUsy933TGySd5i5d/I/rv3dgt86va+Dep/NUo8e0PR3FS5FZTvHQ7K/YVJin6Qtib8O2e2vLIdFTCa6l4ze14wGxlwoxDLbt9s23D8V55h3+RwktEGZ/BIr+UUSjH5+PM09S4B28IJW/+wbKwnZklyD3IOGhM98DOa+FBJjNWtCYUwH9t1BrQPE3ogcsDEWs4Je1NgrC+fiGD4fWfycPT1BvItPtfJzzQOu+/UG9QyCHnABXpz9AvViD3s9avezd/x+38jZSk4FzM9JeQ2CoviLXBrcyx1VM3Mh3YmAri4EFce5gtNjeP04EUT8BTHUYBWU4FlkUU37oVLAp3/tzcN6HLwB7JvzK8X1RVGBaV6RZflLjU07ZIgZS+2FH/wAElhtnQ42vz3aefTQeQC+AoapUvQDsTLx5ioAQPzN9DGgtGVY5hFclbvM0O1WNTzDZfJku7seWa0fB1ky9GAzdOUTT4GpbEIYoL/bXiWtT+xcMMSFSaMFmQWzy6co/PPt82JLczOmZnyBTbJfjoG/DpZFOVBUyjeuy0S+tAsI7qd5ynGeW2mF8Eeat2Urqdy2bhbFEFouDWc14TiO4gGvtiPER0kCoB8AzNBO14fsjfw9pgumZp5csmB5Z5h+9rwoDhYK0drDB2/3OOL9vIrfIqOZhCeSaJApN8+l+iwtpkBTm8/g4EdHQkMkHPDxzVu7Wl+Ac/HjBXaD6Jroqz3EHBfbhJIuIoWPsxDbuRZFc
 4W3mPnan
 hnVl4II490eFnjUZKTbMa7LssZwbWvx5a4zEckR/+EmEkhKcnN9vJKVzZXSAaRX/muqp80t2K9kZ3Lkw1kknoF5ZqAzYhHmnLwwH6n9voLZse52dTsJEcKDWjXDUA6PKdbknHbJPGzk6+DtnfmyAZ2CZphcez2+1w6aDLsKAqzZ+utdoVlfDTgd2HvsaL4xRf615PiQDxWb7P0fauyzOW9iB0aBV2v482HvBIPPFesSOwLA6bGyaT8end8/XUcxVFD16wL4ZTDBxsSCGZPMkn383pYdV/1GlH9Ae90LbYjUjFhoA3DQPd1gzo/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

proc_register() WARNs when the directory already has an entry of the
same name and fails the registration. Callers that pick their names
themselves should never get there but some take names from userspace.
pktgen creates a file for each device a writer of "add_device" adds,
named after the device. A device can have any name, including "pgctrl"
or "kpktgend_0", the names of pktgen's own files:

  ip link set lo name pgctrl
  ip link set pgctrl up
  echo "add_device pgctrl" > /proc/net/pktgen/kpktgend_0

  proc_dir_entry 'pktgen/pgctrl' already registered
  WARNING: fs/proc/generic.c:404 at proc_register+0x555/0x8b0, CPU#0: bash/241
  Call Trace:
   proc_create_data+0x9f/0xf0
   pktgen_thread_write+0xd9b/0x1780
   proc_reg_write+0x1c2/0x3c0
   vfs_write+0x1cd/0xfa0

The files of a network namespace belong to the root of its user
namespace and none of this requires a capability. So once pktgen is
loaded an unprivileged user can taint the kernel, or crash it with
panic_on_warn, from namespaces of its own. pktgen itself copes with
the failed registration just fine.

So go back to what proc_register() did before commit 6c2f91e077f1
("proc: use WARN() rather than printk+backtrace") and what
sysfs_warn_dup() does for sysfs: report the name with pr_warn() and
dump the stack. While at it, do that after dropping proc_subdir_lock
instead of printing a backtrace while holding the lock that every
lookup and readdir in procfs needs.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 6c2f91e077f1 ("proc: use WARN() rather than printk+backtrace")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index c560c96a64eb..ef804cd3ec45 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -401,9 +401,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
 	write_lock(&proc_subdir_lock);
 	dp->parent = dir;
 	if (pde_subdir_insert(dir, dp) == false) {
-		WARN(1, "proc_dir_entry '%s/%s' already registered\n",
-		     dir->name, dp->name);
 		write_unlock(&proc_subdir_lock);
+		pr_warn("proc_dir_entry '%s/%s' already registered\n",
+			dir->name, dp->name);
+		dump_stack();
 		goto out_free_inum;
 	}
 	write_unlock(&proc_subdir_lock);

-- 
2.53.0


