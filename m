Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487ABC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A9E86B00CF; Mon, 21 Sep 2026 09:46:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E5F86B00EF; Mon, 21 Sep 2026 09:46:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6111C6B00F0; Mon, 21 Sep 2026 09:46:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 31ECF6B00CF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:46:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8DEF140171
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:09 +0000 (UTC)
X-FDA: 85237893258.11.D5E3756
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E911014000D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:46:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqY+nvrE;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAGZ6PU49QMZkoSdNCCgv05Mtfg8cEoYV92BD8cI+30=;
	b=wO3v/MYEd/hdF3VlMJTjOgP8ChhFpC2vvBbdLek75HDX40Gn1C39Ah1Y7r5KGnWUHmxmV6
	uMvGjMkqDcLoich3t1qnKUtwA2alJF66x+07bzqnYu9lSkEt8gkOq9htfK/vZdHAqycWRC
	BRXpOm98SAeGbmDrCd+mG/mywjUGsHE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998368;
	b=Zkxf9qVu4tKbqPuWr4hK9vyVNMHD6ql+DyJTWAqrc/CfWp8f4tT/mRHbtZ62xRzs8xNm7r
	aQ4+5SH2tAQL5QGd+Tfyh4Uz2SHBRjyxlJqkZdavEY82aS78f4FeJNk4dMppsMyYJw/Fus
	WIxOVAfVnDpHbUrX4MXGnhgoEqO6SOs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fqY+nvrE;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 449D7418D1;
	Mon, 21 Sep 2026 13:46:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352091F00898;
	Mon, 21 Sep 2026 13:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998367;
	bh=iAGZ6PU49QMZkoSdNCCgv05Mtfg8cEoYV92BD8cI+30=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fqY+nvrEB5A3kmuky5pBIBfQfBbIM9TbNDC9pClgfbUCBHbJqnshrb3SA7ZZGGKIu
	 L1Z4vbKkEzc35WOaTsdzqk9BBB6M8OJiPPMGm1Xg3p25+9cGjFX+XP/nQLCcy883/1
	 QZW3s3xH5pslUlITzgj03Hr1P4SHHiAAg7dDERsQRqLr95e+ZFE7P2QjPu/qV0SOCK
	 yyD7ytnHBk/XHkz7Sj071IDmYXoOJjmIhNIq6gflzyPN3fbD6FnCNZjXkfbhZ+fZjE
	 ldgVI2nOFjsTD8n8qikO5NlyHJvVl5/dEmMXmV5X6+4rTn0V/EzzR1ZiPkR61jpbjL
	 9yZ31tmAsfY0A==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:06 +0200
Subject: [PATCH v3 17/17] fs: close files from the highest descriptor down
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-17-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=5081; i=brauner@kernel.org;
 h=from:subject:message-id; bh=lj99++MiJpzbFK4wClDD2ih1T3hXCm3XRQc2cRY0Hok=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLnL9vDs5WVFOWaNX43Yha5uOhD6gfGj//blH3We8
 yZGMz/b3FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRskUMPxmL+GKPTJ+SXnZp
 Pr/e5u283jvfb/t17MmH+QseXTF+nrKbkWGjsdXzOS4nbx733u0w9ZHLVGWfJw/3MYYlrHub8n/
 i+RxeAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: xwna76rjnatcdjy5xb5e53kw1js3att9
X-Rspam-User: 
X-Rspamd-Queue-Id: E911014000D
X-Rspamd-Server: rspam03
X-HE-Tag: 1789998367-793337
X-HE-Meta: U2FsdGVkX19/T5FyBCtLlAlYfBdCrxCfZk11gdNvjVJYOxAg/E0RSKaK+Oydn6MPszXI2oFXq+C+/iuwopM03abd+PLZJlq2RCTFmdkdyCQvgI9ftC0dee1d5Xy+7hAY0H0gUTTXl2L6kF+Y4yRXDxiINwgsKFG0TRdGjq7iRuTQR2q8I2X/wSekewovxIp3EDeoCXdNJUSBkzMx5XrBE97rFRqscsIWdnDZZc/lLuX6u5N0V9upqF9gDSH0mO67UmunLH0ch10RHyCiitA9N2Q5Bplo+n7UQHZ71IvcCkYMlWqesslKCZHVht+UByX7WOVqrA0LOB6EWIrIzjVDFdKeILIhAq6PtfZAJR/C7cbTYKnyglnz3CNsi98T0y9fnlzjJhwskolxWLxeeR5OR8id4dmfKRsr29lwcnK44bFZ/lNaGQtnfYjpLZHFDWyAHtqNLv3w8DFv7ZviyfTNJnOKDiPndiOWeKqMn6Lp2fghmrkYPQzfnOcMMmL7GrGnjAf3upGHKKbgM88ZnAEJ2lP+4Mc9HsyHZhvpm18t1H1ZZJyZUzGNApvIrrmg7+lbYozb9VX2seLHBgoYlsvH10sulYQCZoeX0FtwyYwAcvxyiVQ9Niu3lKxWLaufqMB246kaoKNOPtn/eTAxlSzYixQ37psdUR/wG+ShCWDcld0ADQdtpFL0NV/VvVM17SdoV3JUHfribzy55DdKMq5GOZBPLknggxReo8ftbFWJ0VNMIhhEA7sK8vlYR6a2M769yr+V2zFW5Uugb9xTAICmLTM3oUooRnvJgElFNQ4N3hymhw7uJ83/kFqWTt4JoXuzSHCU14D3nnh9Cz7AoEIXaKP1/A7WU85gBUdAe2CqjFH8d7/jFIpzHsUkOAoz2fRVGYdmhhWU7mPJKIJb2eA+Z15EBH8xrsDJiSdJr7X4D/0/J9dfYAXYnSy6ZjVVfvqZ2tiM+bn2z3YfmcSQ/3I
 bMGKEfCx
 cMsMF0190m7I7TcoUGhs0zpCEApNNo8t8yo3785i5VvZ/dmp3HOjRDlZOp6qS6mHVNiCeA+GCpj34gG5o7eONLOhV1MFt0ExRBI7wtBCiHQYXYYcyl1rdwJ/rurykrtG1lILpGNyqQhTw00Ei1X8T0uHV834zWMD02I6MrIlaprxTvuej4+4o/dKGj6CS7UzP3si3glVKwAeCbuHnTdn+pK+DRzG8Qe5I9PLmojjAqeT8Jujm0ocae7oTIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

close_files(), __range_close() and close_cloexec_files() walk the
descriptor table from the lowest descriptor up. They used to call
filp_close(), which left the final __fput() to task work. task work is a
LIFO list, so the releases ran after the walk had finished and in the
opposite direction, highest descriptor first.

This dumb ordering is relevant for a bunch of broken but long-standing
cases. It matters whenever the ->flush() or ->release() of one file
waits for something that only the release of another file of the same
table provides. Then one of the two orders deadlocks and the other one
doesn't:

    exit, fd 3 is one end of a pipe    peer
    -------------------------------    ----
                                       splice(socket -> pipe)
                                         pipe_lock()
                                         waits for data or EOF
    close_files()
      fd 3: pipe_release()
        mutex_lock(&pipe->mutex)         held by the peer
      fd 5: the socket, not reached      would be the peer's EOF

Programs create the thing that guards or wakes another thing first.
Hence, it gets the lower descriptor which is the layout that breaks:

(1) a tap device released before the AF_LLC socket that holds a
    reference to it
(2) an unlinked fsdax file evicted before the pipe that holds its
    vmspliced pages
(3) an overlayfs directory whose release queues up behind an unlink that
    waits for a splice into the same directory

The exiting task is unkillable in all of them. All of that crap can
obviously also become a bug if you reorder the file descriptors.

Continue walking all three tables from the highest descriptor down. That
restores the order the deferred puts had. ->flush() moves with the
release. So it now runs highest descriptor first as well.

None of this fixes the underlying defects. For every one of these pairs
the mirrored layout deadlocked before and deadlocks
again now:

(1') splice() holding pipe->mutex across unbounded socket and tty I/O
(2') AF_LLC keeping a netdev reference without a NETDEV_UNREGISTER handler
(3') uninterruptible wait in dax_break_layout_final()
(4') ovl_splice_write() sleeping under the inode lock

It all predates the synchronous close and each should really get fixed.

Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/file.c | 55 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 76e328edf630..7f8d0afd8807 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -497,24 +497,21 @@ static struct fdtable *close_files(struct files_struct *files)
 	 * files structure.
 	 */
 	struct fdtable *fdt = rcu_dereference_raw(files->fdt);
-	unsigned int i, j = 0;
+	unsigned int j = fdt->max_fds / BITS_PER_LONG;
+
+	/* Highest fd first, the order the deferred puts ran in. */
+	while (j--) {
+		unsigned long set = fdt->open_fds[j];
 
-	for (;;) {
-		unsigned long set;
-		i = j * BITS_PER_LONG;
-		if (i >= fdt->max_fds)
-			break;
-		set = fdt->open_fds[j++];
 		while (set) {
-			if (set & 1) {
-				struct file *file = fdt->fd[i];
-				if (file) {
-					filp_close_sync(file, files);
-					cond_resched();
-				}
+			unsigned int bit = __fls(set);
+			struct file *file = fdt->fd[j * BITS_PER_LONG + bit];
+
+			set ^= 1UL << bit;
+			if (file) {
+				filp_close_sync(file, files);
+				cond_resched();
 			}
-			i++;
-			set >>= 1;
 		}
 	}
 
@@ -801,10 +798,14 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
 	n = last_fd(fdt);
 	max_fd = min(max_fd, n);
 
-	for (fd = find_next_bit(fdt->open_fds, max_fd + 1, fd);
-	     fd <= max_fd;
-	     fd = find_next_bit(fdt->open_fds, max_fd + 1, fd + 1)) {
-		file = file_close_fd_locked(files, fd);
+	/* Highest fd first, see close_files(). */
+	for (n = max_fd + 1; n > fd; ) {
+		unsigned int cur = find_last_bit(fdt->open_fds, n);
+
+		if (cur >= n || cur < fd)
+			break;
+		n = cur;
+		file = file_close_fd_locked(files, cur);
 		if (file) {
 			spin_unlock(&files->file_lock);
 			filp_close_sync(file, files);
@@ -908,20 +909,22 @@ void close_cloexec_files(struct files_struct *files)
 
 	/* exec unshares first */
 	spin_lock(&files->file_lock);
-	for (i = 0; ; i++) {
+	fdt = files_fdtable(files);
+	/* Highest fd first, see close_files(). */
+	for (i = fdt->max_fds / BITS_PER_LONG; i--; ) {
 		unsigned long set;
-		unsigned fd = i * BITS_PER_LONG;
+
 		fdt = files_fdtable(files);
-		if (fd >= fdt->max_fds)
-			break;
 		set = fdt->close_on_exec[i];
 		if (!set)
 			continue;
 		fdt->close_on_exec[i] = 0;
-		for ( ; set ; fd++, set >>= 1) {
+		while (set) {
+			unsigned int bit = __fls(set);
+			unsigned fd = i * BITS_PER_LONG + bit;
 			struct file *file;
-			if (!(set & 1))
-				continue;
+
+			set ^= 1UL << bit;
 			file = fdt->fd[fd];
 			if (!file)
 				continue;

-- 
2.53.0


