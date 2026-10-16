Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23036CCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 17:17:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C5796B0088; Fri, 16 Oct 2026 13:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0774A6B008A; Fri, 16 Oct 2026 13:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA6A16B008C; Fri, 16 Oct 2026 13:17:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C08E66B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:17:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D24A160595
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:17:27 +0000 (UTC)
X-FDA: 85329145734.18.1FA6CFB
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1EB4C0004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:17:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O2NiKFap;
	spf=pass (imf28.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792171045;
	b=4jyvTMEVv//5EPAoig3n6NitrRkiOP9/DKon8vEJaWSQzdoYL36dgimxXvOERz4CXifuSS
	ZdXXeY86GaKshQ6POlZ/uiAoHrlG8CAUIArwC4qvau6tiyzf8ORuEeimt9+uRhAuqpn8km
	Gc1JnGSTpTgpWewa7JDS4L8OFVEIGD0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O2NiKFap;
	spf=pass (imf28.hostedemail.com: domain of ngocthang2710.1999@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=ngocthang2710.1999@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792171045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5Gmw5gaxDOzBmPpJ0CCQs51QbryjVy3dY9vuKu88q2A=;
	b=5rBmb8rL/xkw3ft08NNYrYwHi9bbkMNMijKc7X2yzfm3c7Lgk6wgYl/EFwof9B9uLXFDcW
	Owu7Z2uFbHTwkJHuySWnjsdWHbWbewxuR+Jly4SceKKZay1M1X56s73zhAVg65qG+7ZTAK
	cXezc7wumubZGM+3W07ak7JrAljSkMU=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cc502d509c0so116766a12.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792171044; x=1792775844; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=5Gmw5gaxDOzBmPpJ0CCQs51QbryjVy3dY9vuKu88q2A=;
        b=O2NiKFapwTAzFQWYOmtBR1aiOrqxDWkHiro4k19gIEShgx276xSgtCczkh6gcUsiJE
         sZZOL3I776O8yo26r1Iz+MhXm5uRR2+7Z6+sgXaMKz6n59Mco7JiBxkwt2hihTIC6Gtk
         CsNTHr8LvDt0GbUjlMSl4iEANYFaeRKA0OPY65GpKejCkQAc1HuYWWe40NVvmeZ+R/+k
         SnF8Xs+QLEkIDL+0+yJciwt82TOPX+ZD+1ywKC1fOtbqwI8FxI9dZ8JVap2ufKxGNU13
         42Suww7jQ3/0wX4N8MW7PjpuL+H8wzv4P5dCl2aiahlYVcbC+mX8JeY2wACoaG+Upf0m
         q7sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792171044; x=1792775844;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5Gmw5gaxDOzBmPpJ0CCQs51QbryjVy3dY9vuKu88q2A=;
        b=scrbrvNKTZ97oqKZr42kyu2KN9C1rZqB+Uc0i7BczTp6UEk6v1aKGFemOgmRCygDSK
         GyMOPohlz7V12XAntABgZL2OwD5gfdXELDgtILsOuXoYDh5VIORYD5c16H5ZCW58+rs9
         raMmM/31ovDxeiPXOgkQswp+ytcWYyELB8kEXKFYk8VQX/La2cLlRHYPIxsDq43RxXft
         cGdqhkhhsbdOJMImu+Am9rfCeMR4/OMRDd92ASpxb6Xu4SBT6xhArYkkTWtI3ZuMH4Xm
         xN4bbSHpBDePUH3zyBMWlR8bU11vq9LIKyVHTecYw3K2j7FjuNtIMWRTbbBAe1TesCqV
         KWdg==
X-Forwarded-Encrypted: i=1; AKwUvBwMmdgRwUIqv+HFWh+aSgLeeCHNpqkYtkibKgApQAUI0UG/GCkVcJj298dG+APgwIg4kcS/OR2KNw==@kvack.org
X-Gm-Message-State: AFq9FYIjgv4/Z9i2GnxPQ1E0YMgzYZUgOE2f4mvoNECCpZCo1Ani7Avh
	aEI2XtZ8SQ30/WYCpgdRiFxAqOCnYoafEUcbBPbBity7lH4xICJe4Kq5
X-Gm-Gg: AYBFou2mjN5fBPLrWW1eORXg6e1xqWK/saXVMIqVcW4zypeNgSe59zrz6VnuOKd7RqE
	6da7SwmC+EMTsc0Am6vxpu154tb9ZZ0LoITk9p0qAS7A/HWAwBDYd38QrK8+nvWO5PH6LIt51af
	Kn/sqG6+7jN5dvyWYQR0ivpZj8xjUPmy8Rot+XjpASPDZEp6WD5x5YGxenplGcJsJw0hs569IOb
	uSDKAkKEwi89IwHHLaRvo9kGmY+i4QHYF2puADQR55n3kDenq4uUrQI1pfSXBEXG/sXSKzjAUzT
	GVJPAatYa5iA8qpid/cpw4DFBcXNZuOihxW9Bbx1DIgk9a+DqDIG8VjUWP5ZWebqj63HdoVhoqu
	3OnmI+qJ5EsfyW3ihM5Fw6QkuRJo2FdKH8CRcGj5TNAv3Db17cKJP6QRq6L8xEVABOBHoeeRYoJ
	XBMRK7IvMTmn6cvJtfVhOWn3Hv4O/N4EyTdA0xnXpWC/9ttqZFBiW8XmesRI+jArP2XdiBOldM
X-Received: by 2002:a17:902:ea12:b0:2e5:78b1:33fc with SMTP id d9443c01a7336-2e9a705023emr5958185ad.53.1792171044290;
        Fri, 16 Oct 2026 10:17:24 -0700 (PDT)
Received: from thangnn-ASUS.. ([2a09:bac5:d45a:16dc::247:b8])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e5d51b5sm13396075ad.8.2026.10.16.10.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 10:17:23 -0700 (PDT)
From: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org
Cc: jack@suse.cz,
	willy@infradead.org,
	hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+399510418a0b0cf1fc29@syzkaller.appspotmail.com
Subject: [PATCH] fs: annotate lockless file position updates in sendfile
Date: Sat, 17 Oct 2026 00:17:18 +0700
Message-ID: <20261016171718.243099-1-ngocthang2710.1999@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1EB4C0004
X-Stat-Signature: b1m8hsn41jcfkr4qkw1fg37u6j7dtnd3
X-Rspam-User: 
X-HE-Tag: 1792171045-454642
X-HE-Meta: U2FsdGVkX190IW26nmKxQAgUC+dQ2FzwUaNrT8vujztRZmnUGMMvFXK2vZ+xz8sbLGJcKsHt+J7UqoA7sBZ+f1zaQTRBcI8XHQqiYaVNr71kHoI2iY2SgkatTiwOnLXJ62NbtZL3Hhtl9AZqKIVhuDtE3xtOpnS8Km7n3/zMlIbJ6wxKEgb+I9fuQ0nWyDMObc6jUroOCXzx3EH5dL/zKbVhFyiN5cFqdbT3IlDoZ2rJYToEXvCWyAZXI6KgoIbCqBoW6vCN/AcICF+HqY3nOMKvih+DoydLGZlThuRt7SxJlJei0kIqO38iffTBH4s4m73rahp2PJZwtcwMhgPatwTzBFYQjUZAE7kM57EM4qFR8NN3sQxzxoU5lAd+scRcoGIDXJ0Vy2crs3A2csoL4JFkuS1OUL3k9L4aBd3mX8sZCO+SlOdqSqiWtxhBed3GyuFfuPy4jIN4W0Olcl9cjDwKfBsqzCwaUs7S2BAjpxx8ZT8SsnAzgfLjo+/25VCkMKPCGqu2Bu8Q9J5f2x1i0zX4zxFN0idxxbEKeQFfq9X0G5okanuyFkTfT2OvcmknTxmEBpwKou78d2njCxQYbbImMvx6bEkL8azcteXDXeYcyuoy16EPUJ+bxlA4E9aoN3cqW67c5uPDeAPcjv3+5rv64Gl9a2c5N9AbSF5UE1Qy8f8+oJsR1lvvph2XQuhbVxpH/oQhvCcOO8SP1XS70tmnRJZYZgvWmj4TEftT5HjibXllfBJystWUs3jiJ4fn4X4cNqZGoP1EUNtGZgHNnnJjyMF1oi/fmJM4Eh8RRu+0cadJXxVVk6WbuJ1i5CFnrOU/mKZYso1umPk2DyQzsBVArUqzyg4QNya+Ut37n3jbvbv2gPzvUAXbwkwDirKVDXq/bSNTsh5uqYk7lDGEYpz1pcWd4bJ0hK6f7HQRLxwvmjNE3zUXOnDcy0FqeJFMYvvQBoqGk6wU1sm9y8c
 74FAVwjL
 9/bBVCGGXghcRuy5UN72ymWNxAMXUelFiDfsKuUwNAOxBnWvx1C8ikDpmXH0vm7+LbmssU368u/VMLJbHoMtlqZ+9b5w+O1hhidcQA4sV28gI0Q35LcLkHMDuM+PTgahFjanb7mS8yzQjo0tnZpFT/VuGUkaZ+ZErNNZlxJO5BHkLkcTu5+tUKHNBTe2wjYC86ehXZOWyEDRgpbCUgVcNXdfryV8zbn0aIPkbXXUlenIcHWMzcoepj/hj9d7cikS0nHZ/O7i75DVpxwB++sYl7aDkf4f/+gNBPVM6sV9rUsicUopSacVTmuHZ3zm1dDKwpAJd1nwLHqTph0Wzypfe/ZaHIkrYFiyYReSjWu3l1W9O6xLJT96ahvRScwlHAmaWAfWNdx26whng4ncMiA3syqFSjieX89sPxa+TxZeukVfAxaegcT0eE1yBQHMt6COBCMXhPxFpsu/IE+1yKfyvqRSwrHbiObL3uz466O7q5tnHXAjGsdQx0JGMYHFIix81FXumrTPb0bxff9md3zPAvv08zfUXs1+07d61xs6BGbPnE9TvuvYF7UOMYVbedsTk2XOvuz1FWwMi6sOz3wP1gR7+wbzXVTLkfmS/y8t36VB27gRrdVLwwLkYHakE9x4W0OGE179taC4/Oa+3/v2mbggevW32PZZnnuyByJfo7Ug03uU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sendfile(2) does not take f_pos_lock, so with a NULL offset it reads
and writes file->f_pos of both files locklessly. Two tasks sharing a
file, or one running lseek(2), race on it. The splice read paths
likewise update in->f_ra.prev_pos, a readahead hint, without
serialization. KCSAN reports all of these:

  BUG: KCSAN: data-race in do_sendfile / do_sendfile
  BUG: KCSAN: data-race in do_sendfile / generic_file_llseek_size
  BUG: KCSAN: data-race in shmem_file_splice_read / shmem_file_splice_read

The races are benign. The worst outcome of concurrent sendfile() on a
shared file position is an unpredictable offset, which is already the
case for any caller that shares an fd without synchronizing. prev_pos
only steers readahead.

Mark the accesses with data_race(). Locking f_pos in sendfile would
change behavior for no gain.

Reported-by: syzbot+399510418a0b0cf1fc29@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=399510418a0b0cf1fc29
Signed-off-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
---
Reproduced in QEMU with the syzbot C repro on a KCSAN build of
cfec639c844f: 42 and 43 reports over two boots, covering all three
pairs above. With this patch there are none for those pairs over four
boots. The remaining reports are lseek/lseek between the repro's own
threads (a different pair) and an unrelated ps2 race.

I used data_race() rather than taking f_pos_lock, which would change
sendfile behavior. Happy to respin if you prefer locking.

No Fixes tag: the race predates the history I can bisect.
 fs/read_write.c | 11 +++++++----
 mm/filemap.c    |  3 ++-
 mm/shmem.c      |  3 ++-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e8c14e2760b2..ca2916472e7d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1319,7 +1319,8 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!(fd_file(in)->f_mode & FMODE_READ))
 		return -EBADF;
 	if (!ppos) {
-		pos = fd_file(in)->f_pos;
+		/* f_pos is not locked here; racing updates are benign */
+		pos = data_race(fd_file(in)->f_pos);
 	} else {
 		pos = *ppos;
 		if (!(fd_file(in)->f_mode & FMODE_PREAD))
@@ -1341,7 +1342,8 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		return -EBADF;
 	in_inode = file_inode(fd_file(in));
 	out_inode = file_inode(fd_file(out));
-	out_pos = fd_file(out)->f_pos;
+	/* see above */
+	out_pos = data_race(fd_file(out)->f_pos);
 
 	if (!max)
 		max = min(in_inode->i_sb->s_maxbytes, out_inode->i_sb->s_maxbytes);
@@ -1382,11 +1384,12 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 		add_wchar(current, retval);
 		fsnotify_access(fd_file(in));
 		fsnotify_modify(fd_file(out));
-		fd_file(out)->f_pos = out_pos;
+		/* see above */
+		data_race(fd_file(out)->f_pos = out_pos);
 		if (ppos)
 			*ppos = pos;
 		else
-			fd_file(in)->f_pos = pos;
+			data_race(fd_file(in)->f_pos = pos); /* see above */
 	}
 
 	inc_syscr(current);
diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..d5a4a5ead4e2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3146,7 +3146,8 @@ ssize_t filemap_splice_read(struct file *in, loff_t *ppos,
 			len -= n;
 			total_spliced += n;
 			*ppos += n;
-			in->f_ra.prev_pos = *ppos;
+			/* readahead hint, racy updates are benign */
+			data_race(in->f_ra.prev_pos = *ppos);
 			if (pipe_is_full(pipe))
 				goto out;
 		}
diff --git a/mm/shmem.c b/mm/shmem.c
index 897fa2b61346..56fa2bc520ed 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3586,7 +3586,8 @@ static ssize_t shmem_file_splice_read(struct file *in, loff_t *ppos,
 		len -= n;
 		total_spliced += n;
 		*ppos += n;
-		in->f_ra.prev_pos = *ppos;
+		/* readahead hint, racy updates are benign */
+		data_race(in->f_ra.prev_pos = *ppos);
 		if (pipe_is_full(pipe))
 			break;
 
-- 
2.43.0


