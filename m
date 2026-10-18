Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B203FCCF2C7
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 02:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742AA6B0088; Sat, 17 Oct 2026 22:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719FD6B008C; Sat, 17 Oct 2026 22:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 656746B0092; Sat, 17 Oct 2026 22:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 373976B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:46:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 33F141A03DC
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:46:11 +0000 (UTC)
X-FDA: 85334207742.21.EE7BECA
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf15.hostedemail.com (Postfix) with ESMTP id 91839A0008
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:46:09 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792291569;
	b=gSfz6/A/p2sGy/p7AeX6o/V1kutloECX6Cn/KgcXozcPheTmxdrDfrgx6wOlrQm1HVA2d2
	0BLE7sqowMYplj8bftABnT9zyN/xUvevJZdnH/7pTAWcKIFuDdRTPc5IPhk7KONWW+y8wW
	nu2aTiRM8GVm0/8xIT+zAsuqktXdT9w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792291569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Q85bPn8ynG+ajc+JvwspCPwJu454JKRtvF7HFrWNUHs=;
	b=ra8+n24kHuU02LR9rFy3boORZSt95/oqf9fm7Spy16cJkEs/RumTNdPbsZCPpy8yanWQjL
	jg3oYWeUdu0JAEsyOeQ97J/B+FxM/MHHqsEyImB0o9CqHcD1hWdSDBhmo20CMRndrPin9r
	gDt124+bW7ZD/hvrYcWbivocGrUq7zc=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xIGuD-004PQI-7m;
	Sat, 17 Oct 2026 22:45:49 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Jan Kara <jack@suse.cz>,
	Chuck Lever <cel@kernel.org>,
	Yongjian Sun <sunyongjian1@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	NeilBrown <neil@brown.name>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] libfs: end the readdir walk when no entry is left at or below ctx->pos
Date: Sat, 17 Oct 2026 22:45:48 -0400
Message-ID: <20261018024549.798968-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 91839A0008
X-Stat-Signature: 8b8d67br3gidb6taig4gpd1kie363hje
X-HE-Tag: 1792291569-140508
X-HE-Meta: U2FsdGVkX181xwnKXL4RcH+aRgHg/Wt7S2KPNGiZGqafBfZe/N+P2zZx8UQQKOZPv+ririjoyfFwZ7BSlXp2ikLmXyyXsmQoZ1Z0W7gaz1+jEq6JNNbHyn3QnpxodWj+Z9QAB/3B9EaCEZGfZ0GXwdm1lC5EtQJsq+g1TNfJD2NmO6/Oext8P9r+9MXhdA4sqfOdd7o0j8DcA9v4YNa+v2raJwENKiaBh7nh7tKuf6J7nSxANnNK/0ZMhmrmhNxkpHqwwwN+zDje7UA46711Ii7WzhV3QxHcfN+8J9rq+alAoy7p1qYf5ZA3mCzFF6FJUh15+n8RertBVfvReZe/ITC0iKLb+UIJExMIjQSXjeV2CYgvkqr2X5VO2k+SSx6nz7sQnFUw3u1glTFa+iV5mammF2cpTCKJI9XB2riEUqTum0i29bMaf5elFQKgO1B2XckzYersR9AXmUAby1ldRLDhPn5/Vaaje69ZPj6hh7KpvYjkvzMPWNea4GuEiaB1JiwjX/LNrwf5FdSRkzGCTRDc1qrVfgJkqpf79CCajO12n7E8T+jNqddiaZ2wCnPpGlVQVP7O1bcZNhhCGeU0j2KVn0hdHH/mv62eWnDegWULw3YRV+l+ZCzsDtsi+kbjJSOJQKuqwDjLsHolKNpTbktaJwjh3ZAbiaNxzMR5m/Cf9NZGKOtXgIrmug3MP+gclUObIkSafIzsm6tAe/K7nlskk1PhUK4oET+j8QKCuvmWadKvFuB6hDwHkSMLMcLV14QAaN89PfOdAPYFIPjPPQ+41vyCVZaLN0dq+hTZlw9YszQF8QHv8pl4s5G5q6WnoaD5bPFC3pWNN0of6y9Zcz2h7JcGquGMtndEL33PoFD3w1weocTXaL7aj0WH7F7lKKe/4/CLB1T4yA5uAd8SXz0Z+1iBO2uqUmfUkF4VagmxsnmLYyw3zHp1Xf0y02LYTo5VaQfRWDNMRoabfYN
 U9PjSCy4
 Em5saG+OjspFobENdF8aQzU+X3ndtH8hT7HObXXOjEFyogXJnIdZj2EWh6mreAbbpG4k1A+jabV7iDiZg183/V0V/ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On tmpfs, a getdents64() call that continues a directory listing
returns the whole directory again if the entry it was due to resume at
has been unlinked and no entry with a lower offset is left.  "ls" or any
other readdir loop then reports every name twice.  It is enough that the
oldest entry in the directory is removed while a listing that has
returned all the other entries has not yet reached the end: create five
files, read them one getdents64() call at a time until only the oldest
is left, unlink it, and the next call returns the four newer names
again instead of 0.  No privilege is needed beyond write access to the
directory.

offset_iterate_dir() walks d_children from the newest entry towards
the oldest and leaves ctx->pos at the offset of the next entry to emit.
On the next call offset_dir_lookup() maps ctx->pos back to an entry
with mas_find_rev(), which returns the entry at ctx->pos or, if that
one is gone, the next older one.  When nothing is left at or below
ctx->pos it returns NULL, and find_positive_dentry(parent, NULL, false)
treats NULL as "start at the first child", so the walk restarts at the
head of the list.

mas_find_rev() came in with commit f70681e9e606 ("libfs: Fix
duplicate directory entry in offset_dir_lookup"); with the forward
mas_find() it replaced, NULL meant that nothing had been emitted yet and
restarting at the head was right.  With the reverse search NULL means
that every remaining entry has already been emitted, so return NULL and
let offset_iterate_dir() report the end of the directory.

Reproduced on x86_64 under QEMU with the program in the notes: before
the change the call after the unlink returns file4..file1 again, after
it returns 0.

Fixes: f70681e9e606 ("libfs: Fix duplicate directory entry in offset_dir_lookup")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Reproducer (root, mounts a tmpfs on /t; any kernel since v6.14):
    
      gcc -O2 -static -o offset_eod offset_eod.c && ./offset_eod
    
      /*
       * List a tmpfs directory one entry per getdents64() call until only the
       * oldest file is left, unlink that file, then call getdents64() again:
       * the directory must be at its end.
       */
      #define _GNU_SOURCE
      #include <fcntl.h>
      #include <stdio.h>
      #include <string.h>
      #include <sys/mount.h>
      #include <sys/stat.h>
      #include <sys/syscall.h>
      #include <unistd.h>
    
      struct d64 {
      	unsigned long long ino;
      	long long off;
      	unsigned short reclen;
      	unsigned char type;
      	char name[];
      };
    
      #define NFILES 5
    
      int main(void)
      {
      	char buf[40], path[64];
      	int fd, i, n, seen = 0, dups = 0;
      	long r;
    
      	mkdir("/t", 0755);
      	if (mount("tmpfs", "/t", "tmpfs", 0, NULL))
      		perror("mount tmpfs");
      	mkdir("/t/d", 0755);
      	for (i = 0; i < NFILES; i++) {
      		snprintf(path, sizeof(path), "/t/d/file%d", i);
      		close(open(path, O_CREAT | O_WRONLY, 0644));
      	}
      	fd = open("/t/d", O_RDONLY | O_DIRECTORY);
      	/* newest first: file4 .. file1, file0 still to come */
      	while (seen < NFILES - 1) {
      		r = syscall(SYS_getdents64, fd, buf, sizeof(buf));
      		if (r <= 0)
      			return 1;
      		for (n = 0; n < r; n += ((struct d64 *)(buf + n))->reclen) {
      			struct d64 *d = (struct d64 *)(buf + n);
    
      			if (d->name[0] != '.')
      				seen++;
      			printf("listed %s\n", d->name);
      		}
      	}
      	unlink("/t/d/file0");
      	printf("unlinked file0\n");
      	while ((r = syscall(SYS_getdents64, fd, buf, sizeof(buf))) > 0) {
      		for (n = 0; n < r; n += ((struct d64 *)(buf + n))->reclen) {
      			printf("listed again %s\n", ((struct d64 *)(buf + n))->name);
      			dups++;
      		}
      	}
      	printf("%s: %d entries after the unlink\n", dups ? "FAIL" : "PASS", dups);
      	return dups != 0;
      }
    
    Before (master 70dd4ee72eb2, x86_64 defconfig, QEMU):
    
      listed .
      listed ..
      listed file4
      listed file3
      listed file2
      listed file1
      unlinked file0
      listed again file4
      listed again file3
      listed again file2
      listed again file1
      FAIL: 4 entries after the unlink
    
    After:
    
      listed .
      listed ..
      listed file4
      listed file3
      listed file2
      listed file1
      unlinked file0
      PASS: 0 entries after the unlink

 fs/libfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 27d7dc16fcb0..6ebffad7c028 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -485,7 +485,9 @@ offset_dir_lookup(struct dentry *parent, loff_t offset)
 	else {
 		rcu_read_lock();
 		child = mas_find_rev(&mas, DIR_OFFSET_MIN);
-		found = find_positive_dentry(parent, child, false);
+		/* nothing at or below @offset: no entry is left to emit */
+		if (child)
+			found = find_positive_dentry(parent, child, false);
 		rcu_read_unlock();
 	}
 	return found;

base-commit: 58161ead29e50d70a317ea26b472e0c7508e69da
-- 
2.53.0


