Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E062E609C074
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 19:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e2uxiHux
Received: by kanga.kvack.org (Postfix)
	id DD0FE6B05E3; Wed,  4 Nov 2026 14:56:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82116B05E4; Wed,  4 Nov 2026 14:56:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C499E6B05E5; Wed,  4 Nov 2026 14:56:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92D9C6B05E3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 14:56:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 26547A07FC
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:50 +0000 (UTC)
X-FDA: 85398494580.08.D472351
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53EB5100002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 19:56:48 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2uxiHux;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793822208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9vYsQ2z6p4kEQ26Jb8WOubzMzQn6P43ATzZz2gRYd8s=;
	b=I1xr3Q/6GrBQsA8Y0P1eoYsoYEA7xpN3NAevr98/BzGugi90zy4wqDdoz55iTo5gNELQUt
	VSJLLjLvOmkkPaClNYMzfaNEUH8fXYrpMJbUBjyhqm+hsda+H0lYrON3bkeIlSumqBN67R
	Gt5Bil2S3dRNPGu4lsvHL0NtTJwWodY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e2uxiHux;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793822208;
	b=STX+bEMHjXGxCUbjX/jw9VBSL4qH5+o5fJzl66KxtC6QfOMbfiCwEwsi0IU5/cUKalwUO2
	q/6gFa//nUOUM8hDnXZ7rY5gaWr7OjFd7s9dLY4ab3G7qP03lCk2Zx+OICb54J8OHuqAtS
	9VsyfdbV3+xDN564Q42I42g9cku1XG4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 844B84010A;
	Wed,  4 Nov 2026 19:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8051F000C1;
	Wed,  4 Nov 2026 19:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793822207;
	bh=9vYsQ2z6p4kEQ26Jb8WOubzMzQn6P43ATzZz2gRYd8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e2uxiHuxfEJdhmjLozO9LVNrgHWWCvyZHjL6HCg7amaM22yI9yG0olu1uJ96j73/Z
	 xTQNcQbMhTyIG8P3vbMDLmuT2phtFdMJBnVFMbLXmKKNtZbqq02BRamAUB44uazdL3
	 urCr5eyZbIruy/giy8yhCYSK2FnSUIzF0uuLJu8guQkWA1W37endcFSgwzxgmXgdpv
	 WgWqivOuiipmtpXNrqJUTWyUBgi0SwINwwt/Cqe2dz7mNJDn9EIm/pVofRmhuImUVo
	 H8QqbrQNf9HFXNZ1hUfz4Fw5j+PPHT9mjrfkR6KYflVEzz/AoZKdc8Eb+kMcDaWwM1
	 H1CvOEcsSWIHA==
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
Subject: [PATCH RESEND v2 28/30] mm/swapfile: let procfs own the wait queue of /proc/swaps
Date: Wed,  4 Nov 2026 20:56:33 +0100
Message-ID: <20261104-work-procfs-fs-v2-28-319e0f9a8aae@kernel.org>
In-Reply-To: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
References: <20261104-work-procfs-fs-v2-0-319e0f9a8aae@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2019; i=brauner@kernel.org; h=from:subject:message-id; bh=VLC7S5nkyALdZiiw9586D7569GKKbKISIa7jUul9ZSQ=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS97vEV3KXoYc6wwNTta5J2SbyikafkWx/po6m7FWtOr PLmcCroKGVhEONikBVTZHFoNwmXW85TsdkoUwNmDisTyBAGLk4BmMhMA4Z/KivFpjxV2sx0std/ mh+/+VeZnyvk60UXbOG53vWE+fLyG4wMk7fu+rgnv6JzYR1H2t24xj6e5tmlRd9mX90acdHdM9y RDwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8m7tft911d8yfoga9gm1pq7rw71wqx8e
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 53EB5100002
X-HE-Tag: 1793822208-554200
X-HE-Meta: U2FsdGVkX1/HzVtcW28AJz15oNfhc/gJ0GlL1MQadGCz1C9ZDTdTiFK7LIewxo2moTzFRDXKdJs5aNrqfd6PI1mGKnx1zO3cjq0IUgU9ApzIcBs6iCm6qXrQ7kiv+amvmDy9KjsFJdUaQPS5K6abNakjix1V4NogJOYkp/ZZNTGWAm3lQDvQYlMSXGnMBIrVfWcRkzEjA+VQv9/Sgu3f+ddky35fMvFpv9zbLfI5oHTod6B5J/rafePvzKFVMiWXuJSvUYvjq+wtGnO4IGwz4R/5hA07HdBcA+yP7EVEvoombm10xlvYYBCuwEfMQo7atGG69MmhWuvcrbvSh0lYGZE8oxiID0ZzufQMTd7hBdZ3jqRac3h7E5Gt7cuQVR5C7r9q8LNT8YC7DMH6jU0VwZ2/WlfaF2M61iU23BE+Di0TD8nz5k3MLSU7X3uORHDMSAHQxN0ma/VB+isM8VXkvs19kBiiHdwQdJjYN0BvRPhyPyoZV3SPb4n055jbmf4qc79w3dz67raUwF6PhrS+AxxwbyYl6gyeuPPxxkNljgex+0LCeTLumUIwxmgq1oR49BFdEWz9FvxLnHjhqdRWkOsZ/4UaiwgRkSqDekWdlNn4OkiXnw9QOSCoPBijc4JPpseLO9Otz6TCENs7TnAY/N1GzWxIzlPX2qOP5+UOzRlab3fUccjRCfdW3ulJykWL+NcJxjmOspcOmBdHiyPhHXw1QQqjUNepoHGt+KZRBeHrDxmrpRsArKHGk6lnfTLY1ApgAGOnW9r2orlbv81qUXARjKVrfvZUyZQyXAbMQByX2QPFo3Tpyg4TZpWARNKO7oftFsY/XqepEZsBOGWoEPvHDjxwC7gPQpJ14xoRitvD7W8BBxPdWDJNtNWux1dT0w3Xf6Wh0xjDbswukQl4XNkssw4wAAHL4JPeetmD6k8QTc/R+bbdvKYs+jQKv5mr49b4Ni6dn+UEFFq3XWA
 XUoSi5GW
 KkJHHFiZUzTz/4azVDnsK3k35bqcyYgisjHHiv0git/0JI3pVe9qE+zDT1mb9Fj+3X5IAGuPiHeYzFh468ygm0XUbNuXIjgh/gB6tRGh2T3fRzLDvakWtvIZ5puXSWswwSf/jNixofKdQHbKSFZ1g6eFDMF+DN0o0INBlLOcEsmXoPU8/gnr+BvHeJGDFuaq42QVqVrcL4RmDyLBcxpjc6medqIoq1C1tmfOohG4ZkLX/i/7zNsylZwp/1EGtJphedXO4Ra7RYYDfYKZqn2e3IKWzUP7OREbOxZV+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

swaps_poll() sleeps the poller on a queue of its own. procfs owns the
queue poll() uses now, so leave the poll_wait() to it and wake its
pollers when a swap area comes or goes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 mm/swapfile.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ee4868ecc3a7..1d063a1cef43 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -111,7 +111,7 @@ static struct kmem_cache *swap_table_cachep;
 /* Protects si->swap_file for /proc/swaps usage */
 static DEFINE_MUTEX(swapon_mutex);
 
-static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
+static struct proc_dir_entry *proc_swaps;
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
 
@@ -3307,7 +3307,7 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 
 	err = 0;
 	atomic_inc(&proc_poll_event);
-	wake_up_interruptible(&proc_poll_wait);
+	proc_poll_notify(proc_swaps);
 
 out_dput:
 	filp_close(victim, NULL);
@@ -3319,8 +3319,6 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
 {
 	struct seq_file *seq = file->private_data;
 
-	poll_wait(file, &proc_poll_wait, wait);
-
 	if (seq->poll_event != atomic_read(&proc_poll_event)) {
 		seq->poll_event = atomic_read(&proc_poll_event);
 		return EPOLLIN | EPOLLRDNORM | EPOLLERR | EPOLLPRI;
@@ -3428,7 +3426,7 @@ static const struct proc_ops swaps_proc_ops = {
 
 static int __init procswaps_init(void)
 {
-	proc_create("swaps", 0, NULL, &swaps_proc_ops);
+	proc_swaps = proc_create("swaps", 0, NULL, &swaps_proc_ops);
 	return 0;
 }
 __initcall(procswaps_init);
@@ -3907,7 +3905,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 
 	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
-	wake_up_interruptible(&proc_poll_wait);
+	proc_poll_notify(proc_swaps);
 
 	error = 0;
 	goto out;

-- 
2.53.0


