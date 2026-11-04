Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3359606E815
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:23:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P31HtERM
Received: by kanga.kvack.org (Postfix)
	id 1D33A6B05B2; Wed,  4 Nov 2026 14:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AAA66B05B7; Wed,  4 Nov 2026 14:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09A676B05BA; Wed,  4 Nov 2026 14:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC4FD6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:23:51 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67AB98084D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:51 +0000 (UTC)
X-FDA: 85398411462.04.0CE72B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A17B680005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:23:49 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P31HtERM;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793820229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bxrLiMapbfHc1EZ+4ADuNXD+VcOTR1takrrVPNDTeA0=;
	b=nRsvk4VzpTEJtqsP27s5EHjVvJkd/y2sv/FS3dlNbzBbt0ReC5XNCUzQrrvF+HOVuChOtQ
	WBiNaWdIOMrdTnQmIWseKPj0xpRYwz6oHfFqE+V8nsFz4Kas5RSUHs+6AyyDOchVYOQv+m
	yScwXdU1UNrAW8KQnvRCfmemlsLMz38=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P31HtERM;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793820229;
	b=kGisLLgf/Xs2aXCTCDVtkbWnV8LhmohV4Jc6qV35D99aBZnHEaU17BnhhhKKbaEsTYZNkq
	YvshJ61v/nN12Ja05h0u1EljMFIzwJN5BBwn/FjdVZzmCsCDXzMxOu9aP5fx8Mek8k11eq
	lNya2vprNcokh43/PzXq1JjoFUOd51Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 477EF60AAB;
	Wed,  4 Nov 2026 19:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06D31F000C1;
	Wed,  4 Nov 2026 19:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793820229;
	bh=bxrLiMapbfHc1EZ+4ADuNXD+VcOTR1takrrVPNDTeA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P31HtERMFSNol745g3BnGZcUyftsO75M5cryrOhg6uEEbTLO6qd91z1whz/V2YoHZ
	 ZlzF0+NzxGOlzGJPmN3xtmGCNUFfLbt3joPtIH3f++AsuKwEwzdZWf6PdSPxU7A5yK
	 hFlsOXtLhO48r6ueNfnwp0RlYnnSBnRpoiWgq0lskwVIqMMuSuxexcIO+FClliWYpS
	 hoTGOlDLQflfOhdnS0Q3JIK9G3p3uFTRqKXWRJMZ3R4KfowrbaGqQRi07M1QXljwV7
	 th41CQpzl4loprGAQ2TnAnPwUAVWszzRtKlAOT9RVmKV+lhjT8YsGn0BrHVgoiFo6f
	 9SqeE0/BUHJiw==
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
	Chuck Lever <cel@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH RESEND v2 31/51] proc: don't WARN about a name that is already registered
Date: Wed,  4 Nov 2026 20:23:34 +0100
Message-ID: <20261104-work-procfs-bugfixes-v2-31-021c84d852e0@kernel.org>
In-Reply-To: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
References: <20261104-work-procfs-bugfixes-v2-0-021c84d852e0@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2415; i=brauner@kernel.org; h=from:subject:message-id; bh=zKPnydEa7A3MJSKUBbljFnXGgiSfil9PV1OK0LsDT40=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9bvz0UbupS+ReqKmx550QBcPIx+fCyiSlZmydoTxvS U2b4Fm+jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIlcZGT4n20a3HVie8QyAeOH +n67d9j9VH0TdtVtZvPnw4Ent+xues3wh797msrH+LVBAu8/HVj4xtelPai56DjDmvc933d/ZL7 3hAsA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qqhekekush47drzwdmyjzznzzwfzz974
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: A17B680005
X-HE-Tag: 1793820229-661019
X-HE-Meta: U2FsdGVkX195ovwuCBQdXrdmFd2JwokoJZc4EyDREtfJ8LM5GHofsp9cFK2EmgvAidIrJo6E1ferSaV9fZRvLE9NI1JSFrtwci1Ym2gP+w7moZyy/HLuLX7euePz/7debPc1wFVRF3q2QHJxBjEBXgI6lGWTqSKFsLYbogEdxsmIjSbdLaX6IxWyq6Hu8I9wz50Dnhjz4WuZdvp2eF39dNCD5+h8kTDFHMPc9a3xuw8RqiWU0r2xtUebj2mtQLr1Um42/f8ua5QQvrmy/McCX2MHBR5Y83UM1IKx7o6aq/AAWcnGinLoFdB1MLOTKxi4l1uWP8StgbIXVRg3PjzL1PcoPi2UXz1MkAt53O2lxvd0nhiMJ9uoLulVfuwx3v5Aqbr71ju27fgEnBx0aBP49DcW0Y5pcA3GcxmWGKXpYgmMiTED4QEkXHmh67ayCgJ24OERsHfbhmvD/5YSPnU/UPkEjwkPfPr3FKZW11/fidFxt2kZU8pVq/FnZrGZ1AfUIQOX/qtO1jzmvCT9fwVsnGKenb9oBOmyiAxOewVJS0QmmwkXwNLwUWlIcUkj7xOunuQaDdLsC0DsoKm8dwW/aFwFPHhEytmYGRSgGBcSR/D9/mpSCOfZpzzvdk8C6HcO5KTWpsRhYX1yV4PkBwJ5qjrYXgKwlj6WuULlfCVT+pRPuDXBuei/MmHDpn+ctD8B5BmSUTnvtagBBQqlpCSI+/1aCRusWvVdpDxgo+zNZXpN809fVsVrZiN5JtUh25I0Y3wfBqqRNGpEQMFy6SwY4SBisM9Izcvz4RWvDtfgFt5TCGgUTQl+fxCXjJlVCqqwR/fPRlnNUEg3aTfk2EJYLGrAw0PhQKRUicQWJN0nZbfPhkwEcWotjHQ3MztkgiZ/ev2GoSNJ4Q4weoQACVyaMCOEIER5xkDXhirN0jyLiKKy/yB2+37IHs9sDYBA56xvPv1KKO9yIhynMf6dwVL
 IoB/4HVH
 phlIw7nxvh/f8qZu8vX9f75snnDzgAtNdx0y2YBDpknPelASKkeyrO8C/QbB9S9q9fKugILiZJM7H2JYJ3bCjnlNZ79UIS/1OyG6gwcOjYxkdtt/3bI6THRJS61SjqiknbRmtDv+TRbVuYptlyZiF+Y0G22RX6ofosuTQzhVt54dks7UULwyCwQK8Aiex0mM8H3Tmhx4ubsO1PPbCg2+4SiYJhMaYmhLodzrYO/FBqUlQbaXLSdjQOJrwGT19q2YBHBkdJhbJdHlqrbyPSgp48OmpEw7E7r3dnGD+EM2PUsS3fJxRgQUYH5fzgAS8FeeVquUWwDTEsMhQ9y4qRiM93tgpETdHIqtEmFyt4qhyotKuk2iUyesMsjbxYSdnZdAdwFrWGgiJXrNT5AHhU5KR1oGU4gLKp3CxCfY2vxZsr/dGuH3jWbbe6GW/Tg==
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
index 6ac9c4c13897..9e59796349e1 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -402,9 +402,10 @@ struct proc_dir_entry *proc_register(struct proc_dir_entry *dir,
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


