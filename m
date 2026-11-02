Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5057A606F21B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 14:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z7jSW8oc
Received: by kanga.kvack.org (Postfix)
	id 71DB96B05DD; Mon,  2 Nov 2026 09:28:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4FB6B05DE; Mon,  2 Nov 2026 09:28:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60AD36B05DF; Mon,  2 Nov 2026 09:28:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7556B05DD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 09:28:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4CF11A00FB
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:02 +0000 (UTC)
X-FDA: 85390408404.25.00D024D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2351F40004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:28:00 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7jSW8oc;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793629681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9e4ZuKPIpi8QBo4p8aCvRLGQ76YDcFSkXYxDQ/HDJc=;
	b=X28FW97FNEdXSL0TBiRRrkYdb/m2Jhy89IbIpkmVp1bQ077B7MgYNevmMI3BK5LkgsWXl0
	ll/oSuCj0CGr2BgfOxI74LMuf5o472FuSP2GxuE9k4rwd5qzSfdAOp4w2vfX+ZT9VKQVHm
	2Uuq16dRQudW1K5i+sR/MaXrvck6cd8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793629681;
	b=sLr61SH6ium9oFCbnSsCeRwisbibt5mkSecAqXv0rHzRynzU5yz8jQiiGmlH2E4ueuwSWS
	rhyl8goAMgGqJn/X1bTgGPypbW7i4pb0fg43kjDrsYMWknN1o2jT5kyEG2cvL6ZG2fzmi6
	lgMGM4B97MQE8oljijOAsZ2EEY05SSM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z7jSW8oc;
	spf=pass (imf11.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B10A960092;
	Mon,  2 Nov 2026 14:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F24E1F00A17;
	Mon,  2 Nov 2026 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793629680;
	bh=x9e4ZuKPIpi8QBo4p8aCvRLGQ76YDcFSkXYxDQ/HDJc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z7jSW8ocw2GTtsdhy2iLSOSMpWez+vmr7UbhcqFGOJPgV+mfUirasVaGqGjfy1MhC
	 JfdOwZP+NjPjF3axJA25tkHe3FYpmshpGP7JUFL5ycSp9F9xDVUWPTXynOAX7lLDQy
	 lyX77813HhkSilKPJJiaixyUHa1YuUBkrL4nIlzerhARC42GiEhDGVDidxwBdM5Fve
	 2202Lg+45oaSoehyVe/VfbRF4DlEvQXBh0kjqh2jlMLvpzzjhh601Kw2fcyec2y7B8
	 HZR3WDITUZsok4mxLcicXIz+3n6P9tENE705RyDiGEHAZB1hWIT1RX87e64+KLQO9v
	 YjlZGmkXrHfmA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 15:21:42 +0100
Subject: [PATCH RFC 27/38] sunrpc: make queue_wait a global wait queue
 again
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-bugfixes-v1-27-59422ed3e465@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4395; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WxVX5Tk7+VjiQ4HOwMZ1/ws7cMwoYvJOjs/gK5FWGI4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9mJPzJJWxrePPaosrlWIRfIIVuzheh1b9qPU0WbiTl
 93hvZ9ERykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwER+1zIyzD56TIlf772HuYFp
 7KHNoXN7XHoLLr75vvzNt5Pt06bJHWL4X7PzL9/h4ru8Jg+dc9RunmidE/k+d//0KxOeSjdxP5o
 awQYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2351F40004
X-Stat-Signature: xon5z15hr4ofmqc7htw4jhxx1k1m3i51
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793629680-658988
X-HE-Meta: U2FsdGVkX1+Cs78/SjZ40yqXCDBL58cENQZl+wqWeBRLuHG9KHubHpPdHsDc8TFAztILvsdF0S/1Uny9yqGt9vKUSwaIf7xdd8PW2ySyFQRw4vDFCwU3bc4/ueJXocutpqYO5J+Pr4DdWoaOdEwX+9UPmhtzpIrIU8FkXc17zX/Ap+Ov37QUDuzbWm/fMSAtdc+0blliVdu8oB4GKhTP0OQX51Fe6JJ+w9dOojdj0sem1FYZV8jTzHIEX3VGAOmTF8LRSjWgBNy5kuCfOspXPikfzfK0VxHbz+zqy2hpMeKGPvjPvjt/RBeyMRSreO9tltOeWYP1oXT3gejXg/VHcguWsXi+zIR1QbiQByT+hpiijF3rHDnuMJNVngXmPnsH6r+dyYd53EKUbiNBiChM9emH4RcCeZyASdzA1611ErDpKFRrI66v3hHQZkazpXS2IDQnTJmdgjVTU8tm9QNz6j13FwkSoDjEi8gKHDYP54JCXOpfvwmFc4irZn7SUYwTfOanc5mt92nJ5maZv4f0N98WAj5Ob2B1IJxRdGEORnjFPFl2DB40r9uEfXffa8WePzy0GgG3igdOHRCPY8ynaoD2k/Rs36u55LCzKWYnXTqCs+TSaPXe1TyiOsxvuHnmgHNUH1goSZhsrrwIn6V1XglfUM97BGTl/eQl7mnzQSB7v+4RXwrkti4nTsdNwh+QSMl5NjRWmmplACUvZHhsCdq6VtrRN7IJM09Xb8NCdJwSH+zTAr9xBQ62PQoSGQB6bkyWEuknJu9zgbIwXdZWqsnDWZ4bxoMnB3RQQ7B/abjM5nbI774xPAAksHz63CzD9VAJxD56ksFG6d6ZGOmMuP73OwYE25gTbxiaLBrL04W7YzbuKi+phnJdzHsFMHdBp1UbRdZMfZOxUQ5t5yomU9z+A+QT1/MbrxOUegZtOlpHH9qBhrjzKbB7lBto+1a8t5wB3SjGfvfyKlTJu9V
 MXr6QETA
 Ib8lW6vRW5GgWo72RRW1c3yt0Yd2NTEeB/XvOVqS7i6VMRSYuRJ19/P77TgYx7bh1qNSlEygrPbVHUE9qXvcXtbOI3OrjxGddNpygR0xj20S9DhC3OrFbqE4rYo31xk+VZ6Qa4/X0ED/zSlFSDSSwA5J+0HhNzcjadpTE1O7+eP7tYQPgDyltdSICEisVPeek8jnWlQ08GLZY90w+/6vznmi2ScEDo4tnx4fpX+ueWKA7Zbz+VlIArAC/kQUb6cz5z559dWXNy1DkgqkIa1WoGD4ALTLLhF4ixjan65bl3i97iGFM7sk/EVenZYOntSXbz+khSXyQDeYtbIw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 552d0e17ea04 ("sunrpc: convert queue_wait from global to
per-cache-detail waitqueue") poll() and epoll queue their waiters for a
channel file on the queue_wait head in struct cache_detail. But the
cache_detail can be freed while its channel file is still open and
waited on.

The procfs channel files of a network namespace are removed when the
namespace goes away. Removing a procfs file waits for the callers that
are in one of its methods right now and then calls ->release on every
file that is still open (cf. close_pdeo()). The waiters that poll() and
epoll left on the head stay queued until their file is really closed.
So:

  sunrpc_exit_net()
  -> ip_map_cache_destroy()
     -> cache_unregister_net()
        -> remove_cache_proc_entries()
           -> proc_remove()      // ->release, the waiters stay queued
     -> cache_destroy_net()      // kfree(cd)

and when poll() returns remove_wait_queue() writes to the freed
cache_detail:

  BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x4b/0xa0
  Read of size 1 at addr ff110001131bb570 by task sunrpc-poll-uaf/242
  Call Trace:
   remove_wait_queue+0x22/0x1c0
   poll_freewait+0xc2/0x230
   do_sys_poll+0x9ba/0xd50
   __x64_sys_poll+0x165/0x470
  Freed by task 12:
   kfree+0x267/0x620
   sunrpc_exit_net+0x34/0x80
   ops_undo_list+0x271/0x8d0
   cleanup_net+0x3f3/0x860

Closing an epoll instance that watches the file gets there through
ep_unregister_pollwait() instead.

The channel files of a network namespace belong to the root of its
user namespace and cache_open() doesn't check for a capability. So an
unprivileged user can open the channel file of a namespace of its own
from the outside, poll it and let the namespace die.

Go back to a single static wait queue that never goes away. A wakeup
for one cache wakes the waiters of all caches again but cache_poll()
reports per cache_detail so that's just a spurious wakeup. procfs
should really own the wait queue of its files like kernfs does but
that's nothing for stable.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 552d0e17ea04 ("sunrpc: convert queue_wait from global to per-cache-detail waitqueue")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 include/linux/sunrpc/cache.h |  1 -
 net/sunrpc/cache.c           | 12 +++++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/include/linux/sunrpc/cache.h b/include/linux/sunrpc/cache.h
index 2735c332ddb7..bf4fc543e1e5 100644
--- a/include/linux/sunrpc/cache.h
+++ b/include/linux/sunrpc/cache.h
@@ -119,7 +119,6 @@ struct cache_detail {
 	struct list_head	requests;
 	struct list_head	readers;
 	spinlock_t		queue_lock;
-	wait_queue_head_t	queue_wait;
 	u64			next_seqno;
 
 	atomic_t		writers;		/* how many time is /channel open */
diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 1bc04109d213..1ceaea7e01b9 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -404,7 +404,6 @@ void sunrpc_init_cache_detail(struct cache_detail *cd)
 	INIT_LIST_HEAD(&cd->requests);
 	INIT_LIST_HEAD(&cd->readers);
 	spin_lock_init(&cd->queue_lock);
-	init_waitqueue_head(&cd->queue_wait);
 	cd->next_seqno = 1;
 	spin_lock(&cache_list_lock);
 	cd->nextcheck = 0;
@@ -965,13 +964,20 @@ static ssize_t cache_write(struct file *filp, const char __user *buf,
 	return ret;
 }
 
+/*
+ * Not in struct cache_detail: poll and epoll waiters stay queued until
+ * their file is closed, but a channel file in procfs can stay open after
+ * the cache_detail of its dying network namespace has been freed.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(queue_wait);
+
 static __poll_t cache_poll(struct file *filp, poll_table *wait,
 			       struct cache_detail *cd)
 {
 	__poll_t mask;
 	struct cache_reader *rp = filp->private_data;
 
-	poll_wait(filp, &cd->queue_wait, wait);
+	poll_wait(filp, &queue_wait, wait);
 
 	/* alway allow write */
 	mask = EPOLLOUT | EPOLLWRNORM;
@@ -1236,7 +1242,7 @@ static int cache_do_upcall(struct cache_detail *detail, struct cache_head *h)
 	spin_unlock(&detail->queue_lock);
 	if (ret != -EAGAIN && detail->cache_notify)
 		detail->cache_notify(detail, h);
-	wake_up(&detail->queue_wait);
+	wake_up(&queue_wait);
 	if (ret == -EAGAIN) {
 		kfree(buf);
 		kfree(crq);

-- 
2.53.0


