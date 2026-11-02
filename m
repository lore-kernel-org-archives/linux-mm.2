Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C46960A5616
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:37:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Xv854kNM
Received: by kanga.kvack.org (Postfix)
	id 94E386B063F; Mon,  2 Nov 2026 10:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7B06B0640; Mon,  2 Nov 2026 10:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C9D96B0641; Mon,  2 Nov 2026 10:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B78C6B063F
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:36:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E5470120137
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:36:58 +0000 (UTC)
X-FDA: 85390582116.22.BD86474
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2779F14000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:36:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xv854kNM;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9tzR156ub0Ko3Mv53tQ+R8L9hVWUPj+OCS3UYlYhFM=;
	b=bDTl21YBjWxWG2z9J70LqjYgxu/pJMV+GxiUmMidbAykDkShpRivO93iWHcqaWEw44VcwR
	FcRDn2I16/9DcWtkqjn+YMjJPCYHlQrr2uN4TFFUUJTtOARh5WyaaUcGOhxRyQ9Q2j77Gd
	R6IINrv2EqurIQL0+IDtpMyDeX4LJFo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xv854kNM;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633817;
	b=BSK/FDhoVnzW9YiyWaHmPbeMgsOIKgsIfXSVEclui2b7WqCqy14nmto6oAKJ4XNQ+6yozh
	VHRgB/YTYFSgq6haQ4Vq4VzjNoh+wFDzCQmIEVjh3AIanD/hexJOOWXkqq1x4mhorpEYin
	KODQAJjJSYM/lF1Puf+McFNXCutDskQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE75C605D0;
	Mon,  2 Nov 2026 15:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531081F00A18;
	Mon,  2 Nov 2026 15:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793633816;
	bh=S9tzR156ub0Ko3Mv53tQ+R8L9hVWUPj+OCS3UYlYhFM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Xv854kNMsGwo7y+d1KGrPoCvj8xhJsXdx+NPbr36bs+rW5xwmzoPtt2iRcwjhbEKU
	 XfGn3WHT/EUTweyMuOntYcuRNkJ8rTxnpo6+2PE2yMcenfdCzl5eIgjm5/Mh5ebn7G
	 fkhyKa0rXacAXgJ+DCsssER449+cBLCHyxVdSSLX+Dc8MDSqMopDEivA7yuiSDKGIt
	 S+zxOV5qOgzsYi0jxj417k6xxIdELaXugUKSSeWJd0Mj/Dej88U0tMQwopSyTcFdVs
	 +LuR+neBjXGs3pWPltnJUq6afbVpYXhNMgZlQFhveRD+FSFnPEgw7sZPZlNM5HmN/s
	 Kl3S3hqMGw5FQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 02 Nov 2026 16:15:56 +0100
Subject: [PATCH RFC 3/5] proc: only let permanent entries read straight
 into userspace
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-work-procfs-cleanup-v1-3-c40014bc12f5@kernel.org>
References: <20261102-work-procfs-cleanup-v1-0-c40014bc12f5@kernel.org>
In-Reply-To: <20261102-work-procfs-cleanup-v1-0-c40014bc12f5@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3948; i=brauner@kernel.org;
 h=from:subject:message-id; bh=HAEx+xWoU7bRVFGL7mPvEVPlpuc3m3z2NxJgiNg4Kyk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS9WJlZf/pOH6N9WMJzv9uNpixmJcz8Ug/Ejvz11/239
 6GG0aykjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIncamf4X3St2856z96lFedd
 LXNe81VttXmn+CW5oKrcbePRNO7QUwz/LLla1BTNtBU3uscdWNC45ueiHItPagqx/Q8zd6094Fv
 ADgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2779F14000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: obgapb78yizzcj5js1uzrtyqykzigy8h
X-HE-Tag: 1793633817-876584
X-HE-Meta: U2FsdGVkX19BBDkr3uFaZlmhkghab4tH1hUYKtQgrhCDCRLLPB+oQXMQ51rACSuYOi62rYR2b788AziBo+usirN0BN05bnQXAmr5QViGhMSGgwdUs1KySloa1mqyu7a+ezflRlhBZpVAh2KZvMamHHUIfe/Ijm3egkD0yAyvIciW5BKCZFWhKkmFEjQ4Fe5k4r01O+xXeuIKq9CFzsPEBdDXnoe7KaZ6FqPsKs30aFmWmA/IQmiuUcKURC/bswWhEwI01S8gC+pSzWvXOuNQFjNw3lig9WDHym7Fni1E/cSIY4wqJYlyZ3Ca67sTH9w686Rs4PSM9O0H/pm2HsAXW3UqfFPcEwkm3bowGiBhZYw+KtvdHYlinOkh6kqTL9/7uq4XKlD3nsi/zHTHVZyJgN4OW6BxbglpP+//c86CDj8PtlM8/IQQgqcOzEMTwDM6LV77YxjgTTbt5dIzkKf4NMwS3iaBo5Mdh51ekxA2F5axR/AQ55FcSKnVuHi5gkKDDV5dQ1tqgKPPIOcNMowrSpzvIdywOdz6dsrd7VSokE/YXNF8+m0MrJBegqHagstd8VqNWDkeTQqHhHRsVVAJ4ZvSqvL7RpZRQvdHlOEJoNqxEQOzXNjroPUiEnS+dXU64/X/Lp8NrkJej0ivwrKvEqqm2DHcW4VVXsoS81RByWlQsSWhsrBEoAHLiPfp0itjiY9qoxIYI7zhKLr/ny2OLRiK0qVB0AjRrHUE+BK0SdgI3AgYbtbRYrI0qy1Z1hnjIFje6hJpu15li82R9FGHV4l5BlHU3G5QA4upSkm4jUBOdIBE+mVuCWO8wbk5cRtc2aw1xmX1rkA8eVKZt0VGCZl+ybyT3ueLcOBGnHuYzicy071FaoD/TpCs+0fJq5MSHBYp5VM75Bk/Lwz5IoQYiGseIHORXNeVmUI29KuMQzKIMcD42gFffQo3xuXaLcPYBlARsMktwptc6t0Unix
 58q+gyc6
 zc2ZHxr2q0RcrBdfNFtKxcgtjZ+qZX8py7AkiALxWuKmeXd+3v98r12rLcscOSPs5XJKcTU41Qpy+rjLWU1orcyBVVWl3E1BlG+dDe7dPeIUN9oTlm/EN3NjJ61FEe/XaNQAv7x3Ey5xJuQGzIebp4v4xyaHzGjqnlibqj2wIKFZVLDEfOageO96GoOv0XGd9JJDepTvabGmbV+eUY5TWrYymuPkPrfi2gIryc+V5YDvBTsHdzUG3jMcTAci/CzLUAsGncBF5xv5P/3z6UMMoGRbnjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every entry that can be removed implements ->proc_read_buf() now and
procfs copies what is read to userspace after unpinning the entry.
->proc_read() and ->proc_read_iter() are left for the entries that are
never removed, kcore, kmsg, kpagecount, kpageflags, kpagecgroup and
profile. procfs never pins those, so nothing can wait for them.

Say so in struct proc_ops and refuse to register an entry that can be
removed and has one of them. The read paths then don't need to pin the
entry anymore.

PROC_ENTRY_PERMANENT is 0 in modules, so a module can't register an
entry with one of them anymore.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/proc/generic.c       |  4 ++++
 fs/proc/inode.c         | 27 ++++++++-------------------
 include/linux/proc_fs.h |  6 ++++++
 3 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 413382efefc7..7c8def4ed9fc 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -443,6 +443,10 @@ static int pde_set_flags(struct proc_dir_entry *pde)
 
 	if (proc_ops->proc_flags & PROC_ENTRY_PERMANENT)
 		pde->flags |= PROC_ENTRY_PERMANENT;
+	/* These copy to userspace and only an entry that can't go away may. */
+	if (WARN_ON_ONCE((proc_ops->proc_read || proc_ops->proc_read_iter) &&
+			 !pde_is_permanent(pde)))
+		return -EINVAL;
 	if (proc_ops->proc_seq_ops) {
 		pde->seq_ops = proc_ops->proc_seq_ops;
 		pde->state_size = proc_ops->proc_state_size;
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 971f2aecc006..a7f8818b0b74 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -460,35 +460,24 @@ static ssize_t pde_read_buf(struct proc_dir_entry *pde, struct kiocb *iocb,
 static ssize_t proc_reg_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(iocb->ki_filp));
-	ssize_t ret;
 
 	if (pde_has_proc_read_buf(pde))
 		return pde_read_buf(pde, iocb, iter);
-	if (!pde_pin(pde))
-		return -EIO;
-	ret = pde->proc_ops->proc_read_iter(iocb, iter);
-	pde_unpin(pde);
-	return ret;
-}
-
-static ssize_t pde_read(struct proc_dir_entry *pde, struct file *file, char __user *buf, size_t count, loff_t *ppos)
-{
-	const auto read = pde->proc_ops->proc_read;
-	if (read)
-		return read(file, buf, count, ppos);
-	return -EIO;
+	/* only permanent entries have one, see pde_set_flags() */
+	return pde->proc_ops->proc_read_iter(iocb, iter);
 }
 
 static ssize_t proc_reg_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 {
 	struct proc_dir_entry *pde = PDE(file_inode(file));
-	ssize_t rv;
 
-	if (!pde_pin(pde))
+	/*
+	 * Only permanent entries have one, see pde_set_flags(). Anything else
+	 * might be gone along with its ->proc_ops.
+	 */
+	if (!pde_is_permanent(pde) || !pde->proc_ops->proc_read)
 		return -EIO;
-	rv = pde_read(pde, file, buf, count, ppos);
-	pde_unpin(pde);
-	return rv;
+	return pde->proc_ops->proc_read(file, buf, count, ppos);
 }
 
 /*
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 64242a9aa117..17516b064922 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -17,6 +17,8 @@ struct seq_operations;
 enum {
 	/*
 	 * All /proc entries using this ->proc_ops instance are never removed.
+	 * procfs calls into them without pinning them, so they may copy to
+	 * userspace themselves through ->proc_read() or ->proc_read_iter().
 	 *
 	 * If in doubt, ignore this flag.
 	 */
@@ -72,6 +74,10 @@ struct proc_ioctl_arg {
 struct proc_ops {
 	unsigned int proc_flags;
 	int	(*proc_open)(struct inode *, struct file *);
+	/*
+	 * These two are only for PROC_ENTRY_PERMANENT entries. Everything else
+	 * uses ->proc_read_buf().
+	 */
 	ssize_t	(*proc_read)(struct file *, char __user *, size_t, loff_t *);
 	ssize_t (*proc_read_iter)(struct kiocb *, struct iov_iter *);
 	/*

-- 
2.53.0


