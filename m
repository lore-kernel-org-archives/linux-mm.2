Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43AD66070317
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aicfXnWV
Received: by kanga.kvack.org (Postfix)
	id 295B26B05BA; Wed,  4 Nov 2026 14:44:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2476C6B05BE; Wed,  4 Nov 2026 14:44:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15C9F6B05D2; Wed,  4 Nov 2026 14:44:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9B5E6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:44:13 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B473116084F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:12 +0000 (UTC)
X-FDA: 85398462744.29.6D7D546
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D1B2D40005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:44:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aicfXnWV;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793821451;
	b=s01psZwmvYpwqTVaCPxuok7v/73WORTGWNPCv+sykYL5GpGSRXKl2SEdCP873GNx2yxZhm
	jzrdEMQaJuNhOBzU0bKrjSPuzKqSzjyb4h9vKYw4ccN8qL4lsg44+l7STWcatQtPU3jfEd
	S1xHvLlrshLUTw/uQde6g8YsRA+5EB0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aicfXnWV;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793821451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z72TnyR4FqZWuZXLi7RAB/58/idtKzOn4i9EyTHtGiw=;
	b=3c5zqq9UzhqhGLbG5QJ532qqOwGwq6xHvcq2ekSq6lz/4hOJl9LEElUgH+yLXsZ/3sSDV7
	4SSLq9EwfCE7RNN17NyoEzWuhox/LP26xM2e2/K9aCA1+tllQJB5vb/zrnoMMx8TP1rUiz
	h7FNpdLbvZQKNFHAxEV53PjzlvPo5BM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1024940584;
	Wed,  4 Nov 2026 19:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF0511F00919;
	Wed,  4 Nov 2026 19:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793821449;
	bh=Z72TnyR4FqZWuZXLi7RAB/58/idtKzOn4i9EyTHtGiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aicfXnWVc+2sorHSEArN9gD6s+r89vzM3QCItz87jq7xenbwZcKkxAyhEzMN4zilO
	 XEmAW5nDi6Qpy1HAR+3dogNdprQDzauusCx/5cNW0SrbZVyC5GFUF34a5Ax3Ufz9Ir
	 pPUXceddaTjvbGaHwgGMseQ+qlmEYJQbjS+TTvruu0qlgjbpKch86CrjWevskZ10dt
	 CPwtCbH1BlXfDfr1nCeM9GXk83OUHSgxmRLaA86TuRr7s0NevUTTC4SfMspApoUqNj
	 2Bq8k9a+tUVTivUfQqiyVO9j0Bzx/5RNz+dYk3t96b4Fnb5fexWFIEeXgiYZ4/X6vz
	 2jCoIj12+zkWQ==
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
Subject: [PATCH RESEND v2 07/26] md: let procfs own the wait queue of /proc/mdstat
Date: Wed,  4 Nov 2026 20:43:55 +0100
Message-ID: <20261104-work-procfs-drivers-v2-7-245e54e87116@kernel.org>
In-Reply-To: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
References: <20261104-work-procfs-drivers-v2-0-245e54e87116@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3404; i=brauner@kernel.org; h=from:subject:message-id; bh=Nn5OVy8ZnyI1nSFUur3mK5MV0AP1ijE3ArueCKeFRT8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97qpelclm2eRivDzv95ei9M8+3HNPnr9QzG/qmrjCP rmm56dyRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwEQCXzP8L+Ry03raKlfQfVPu 0IPvj5U0WoW+KZ9MOfz5Lev7yvuRzAx/BR75d/79PlNgAlP5pc8HHJqssrPnl5s3P0u6bivP2cv FBgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f593zcu7agegy7u1dhkko3d6c1npurn3
X-Rspamd-Queue-Id: D1B2D40005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793821450-188106
X-HE-Meta: U2FsdGVkX19qfS3/bC5JimJOsHFNcWsnBvGoIaVzuoYgKYk63BUhbFMjbohnU0K1HMPFwM3cFOw9vFuIlDIZnWFNVTpO4wopacuHkMVw/gnx1Od2w33rav/fWdg8jddDsKumNAVbTQFRIzrRTqE1h7PpFPvWY1WOnPyZFs511+2ML+htxnwh4W56gJ5uV03ZviaN7O6IrYd15MGf/WryyhxMbsztDdPSaJ3u/i3xSh9LfJgJ2rvtJbcvtI5KmaQUU215DHL/MOIERqap0AjIM74qaPAA5t1DZZNTOGpajVarcryZDuMoovxVFqKhaZQQn3VS9KNf7aCPdGVZNtgfsWs+0xBsmkPaWOeqVK3dsCa61wL7mo0VCO5csJw1uZTZGAZbrPb5Dj40fad35v82yY3q8+ZXIW/U8bl1+uBhWnx8KAWjXwaqbO2BjmDAxliMncsrXQtOvQUBTDKaj+rvDAliewxIJDvoof8/LK+b21byQQgh2SoLpOs/PmVRKNg3IXVhwq9X4KwLcIuSh/mtVAxMoMIwIsOTyAKDuPzKcdacK9jnlFgq6MC9nL9t9Op/3lTaqzxAiy0djqSHJh64SSDkl+USny3W7BT2BfQw+5Osm/SFyWNNrDvhW8WvZcpBQGWt4+T+X/dTemwXbxwvSz8Uy9k5EsLIad2dEUrIzbWb8gya4hmNDm7UnASS0R1OeWhDAmXmi+WgtR0CxfK5Lp2M7APk3HZ2korb+WQeYaoGQ82VreI6dfjnikzMfWQnL9kowGupAzYlzji37gM9RwlyBkOHIYMNBL9L+qL/q5OttspH8z3blWDjhoPZyv7hhR/oijNGHxR8q3iVvC6CbchzEHDlchXMUAuduK3wQMI2tZ/Mz0yRyQywu5DUNgue471689loEqwhBYIG8ojUbKLhGaObu3efrzj1pX2J6mmJ3SQhFOdJ4ECXhemEeoxKAxSuSAYU9Ty9sPr3MHp
 uq39lMSb
 zRNz0LI18tK1pMzNrJegvexkk6TZuwVwbony1gbkOBbGFSP3x4WzzWQlWaCyamMwJY9D15MCAl5i8EruVcoZysqtz1sbsQFiK9CX+m6y/1KZNOTnH4QGA2TIbHIZ6erEELmz5Iu/25Z4u4I0VytCE6CM9Kjncv+nlLoF/3PDaFNqaLM/LB5lp3AmskCD0aopOFT/XPNxTPCtz0S76VGnDI7c0b2fz5CGp+Ie3ooMfhG2Bo7enhi0sLMSZnTqSN1cnr2Iq2IHFDOqrHEAaUJqwLor4s6Y1KRCWmYVO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mdstat_poll() sleeps the poller on md_event_waiters and md_exit() has
to wake it in a loop until nobody is left on the queue, because the
queue goes away with the module. procfs owns the queue poll() uses
now, it outlives the module, and a poll of the removed entry reports
EPOLLERR | EPOLLPRI, so md_new_event() wakes the pollers through
proc_poll_notify() and the loop and md_unloading go.

md_exit() removes /proc/mdstat last now. A sysfs store on an inactive
array doesn't hold the module, so it can still reach md_new_event()
while md_exit() runs, until destroy_workqueue() has waited for the last
array to go, and a wake-up through a removed entry is a use after free.
The static queue didn't mind that, the entry does.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/md/md.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 64abf1743e41..7560dcf0f5c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -351,12 +351,12 @@ static bool check_new_feature = true;
  *  start array, stop array, error, add device, remove device,
  *  start build, activate spare
  */
-static DECLARE_WAIT_QUEUE_HEAD(md_event_waiters);
+static struct proc_dir_entry *mdstat_entry;
 static atomic_t md_event_count;
 void md_new_event(void)
 {
 	atomic_inc(&md_event_count);
-	wake_up(&md_event_waiters);
+	proc_poll_notify(mdstat_entry);
 }
 EXPORT_SYMBOL_GPL(md_new_event);
 
@@ -9176,16 +9176,11 @@ static int md_seq_open(struct inode *inode, struct file *file)
 	return 0;
 }
 
-static int md_unloading;
 static __poll_t mdstat_poll(struct file *filp, poll_table *wait)
 {
 	struct seq_file *seq = filp->private_data;
 	__poll_t mask;
 
-	if (md_unloading)
-		return EPOLLIN|EPOLLRDNORM|EPOLLERR|EPOLLPRI;
-	poll_wait(filp, &md_event_waiters, wait);
-
 	/* always allow read */
 	mask = EPOLLIN | EPOLLRDNORM;
 
@@ -10765,7 +10760,7 @@ static void md_geninit(void)
 {
 	pr_debug("md: sizeof(mdp_super_t) = %d\n", (int)sizeof(mdp_super_t));
 
-	proc_create("mdstat", S_IRUGO, NULL, &mdstat_proc_ops);
+	mdstat_entry = proc_create("mdstat", S_IRUGO, NULL, &mdstat_proc_ops);
 }
 
 static int __init md_init(void)
@@ -11074,25 +11069,12 @@ void md_autostart_arrays(int part)
 static __exit void md_exit(void)
 {
 	struct mddev *mddev;
-	int delay = 1;
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
 	unregister_reboot_notifier(&md_notifier);
 	unregister_sysctl_table(raid_table_header);
 
-	/* We cannot unload the modules while some process is
-	 * waiting for us in select() or poll() - wake them up
-	 */
-	md_unloading = 1;
-	while (waitqueue_active(&md_event_waiters)) {
-		/* not safe to leave yet */
-		wake_up(&md_event_waiters);
-		msleep(delay);
-		delay += delay;
-	}
-	remove_proc_entry("mdstat", NULL);
-
 	spin_lock(&all_mddevs_lock);
 	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
 		if (!mddev_get(mddev))
@@ -11112,6 +11094,11 @@ static __exit void md_exit(void)
 	spin_unlock(&all_mddevs_lock);
 
 	destroy_workqueue(md_misc_wq);
+	/*
+	 * Only now can nothing reach md_new_event() anymore, which wakes the
+	 * pollers of /proc/mdstat through its entry.
+	 */
+	remove_proc_entry("mdstat", NULL);
 	md_bitmap_exit();
 }
 

-- 
2.53.0


