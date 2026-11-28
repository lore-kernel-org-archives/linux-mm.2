Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1EDD606A684
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=p+mCeez2
Received: by kanga.kvack.org (Postfix)
	id 7E6BB6B05B5; Sat, 28 Nov 2026 01:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 749156B05B6; Sat, 28 Nov 2026 01:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 610906B05B7; Sat, 28 Nov 2026 01:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3F226B05B5
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 426AF405AA
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:07 +0000 (UTC)
X-FDA: 85483608294.11.3D0E073
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 88521C0007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:05 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p+mCeez2;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848725;
	b=kslL/SkmpRTbVsFjkogVrgsgBQ+TA5tftoPBrNSTSvqwIgWgAbczuPpnp6TXjvVC/smFrv
	d5Uhxe+VVIfkoGiTGBZa56imhFscpR6EugNnz+vdKY3P6y9s/Plzegxu5dJw3JJ5ADzIWu
	pDA4AkbWVe4XezIIUYUkX8vihnIF7XU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=4H5+2at7U97vbo0B4oNz6NNXKlVhoaRktcVOF+YJOgE=;
	b=fut/sNOcjeIMp01PvTGuGGF0zDZj1msC9vrbWfin/ykSY8av2Ui2bV+ku7X8Kq4d+u4Mdq
	uSFEmH1ebAkJOkdUbkeViCcAnqNE7NE2wDnSR0mxj0hha6rrFDqIozFlr09lRg5TkK0HGL
	IDpvWqwZMRfAkMGddYkfMyzkIFnPBcQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=p+mCeez2;
	spf=pass (imf10.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBA7945180;
	Sat, 28 Nov 2026 06:52:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32E61F000C1;
	Sat, 28 Nov 2026 06:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848724;
	bh=4H5+2at7U97vbo0B4oNz6NNXKlVhoaRktcVOF+YJOgE=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=p+mCeez26ZGBiKzmsMPqJ3ZZUJBZyZ0cwmLchvWA5N7LtY8TRbbN3v0CxvA/z3JHN
	 Y5MjTEkw65LPeU7ENBlj0SNCB47bgQ1zFypVsbNEVeckpayX6Kr046DN//Iq2GlgvL
	 bB1iW+NQMt7rdSXktBoO2wmwyPOvZDRCStIENy8M=
Date: Fri, 27 Nov 2026 22:52:04 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Amir Goldstein <amir73il@gmail.com>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.4@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 4/9] selftest/mm/memory-failure: keep page-cache files linked until cleanup
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88521C0007
X-Stat-Signature: nzuxkqpp68881x9ghdf7awrt8wjp598h
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848725-579069
X-HE-Meta: U2FsdGVkX18z18ha0+JClyDltXxCCOcwuIo5CFnRXOW0Uhl/mBztFJSb2zhBxQhAGTSEFtRhawpff1uQj3NiTVqQKI/CSTbr9gmBGXEQIlNtbudYJbjXYPGqF2okL7icLDgNCTHlUrylsktqQ5IM0CxryjGngxSis6jCpckARtXvBZ/s3zMk3WBHIzOLFORCZlTLwW4Vc4zV0fYHsJuPO8PkDzenVKx/kHey6E0tc5MYxdcvabLBqIi1CDMUpOUImuFWA3pWCkVj39sskDyv5yAFhaCizSMJfuj975cNT1jckUmgDzlZxbPY4Uus8e0GUlYgiTB0CyTuOZ5lqsTbdNPJ5VvdK87Th7/wIRN5OeF31RR41w+JXpirqs9PP8wge6d9s+gp/8WvucC8FNyIerpFaBMV3rsEzr+mkSNR2wkHAHhq5+4IB2pB9yGsSn/dPyrIZ0BFzab21PqE6whVS600m6IHsbpWVbjfTgUK7VXcOlpa1WEW/1iNWPjVqMLYgOXt/9ETmxz3Nhq5YBeF8KCNv8+lACbt74I/QOpLmJzWgbAtUcDcRNPDJrUPyvD6kyDcuiz5KMcP9I5VajFw7srhBQsXd6L8Y0c7ghMeLfOluqkLrrMIPzBoGRvW0Pr05MJnvmZ4hcWeIdVzvTAzFT2QsC8rsXRbiPxsTnDhwsnIyqAT5bU06UubOJ1kJKh5TMhgBw3WKzWK4XHu0h0VQumtTqKGl6mnPV3N5lKDlW1fCd5XUTkXkvys5NS/Q5xlWDE+RxBmXzt8Uam7w83RXOf38Pug9bnmN5fPQruLTipvWNVM7Ax8M5hsGmm83Uu4TpfQRIHD59zF0OzHB1y5ERopKRq0PFgzESxDwQ2ZmxcMzSi+KrObNxvFAZQ3Sanws0kw9CeM1OStbbHYfnpeVgRy3UAkqQSmprCOjqPCM6BeEF6rxTJg+blo0fBLL4phXznb52NtUudStJnLXBL
 Tpyx/B2u
 bx6ATrvW6rqpvyt4Xsac+DeoJZ3SdSko7g8Jrwn8aFg5iwr52Wpg+8U2iK5filPmqvA7VWxnOGd7/0/DeiCrTAMJuxFtV5b4GPBz9arvJ9nsiuRbzK5uW2epO0sEWbQFF12dHfcGLin9vUaCmAFz0ObYg7VAo5CyAiqeRUKsIWexWXp4aSeLMSr+rHBS40e2Bo3r8yD2q74fUCJ66YSrpreGskkZ0VNF/z3YVedR4CZ4+CFhT0431Rvx+H1zMGrUKg3y16cbP9rmg4SfmVIZD+DcxxhG8E6ATiQxCm1ynNioRPXevmF3HIJxQJMmln694T3CIt5yXUcy1Yr9sWkv3x0oC8KKojzDuUSbiK1MCO9WJ6DlkcZHc2ngXBw6Pxrmll/6jXa3gvYvNukeiQ2dKK3kmL5Ra67YsQj67o9cidQlsGEU0TgbvW6BlrLjvb6kIlQeRoce5fw9FV6nfNTxBfUTdy2t55PB9mNQSiPrlckG64m9fHJidvSiHhAKYdzErjqMxAm7CvlOYJSyFyoyIJEqGQAwQ0YiPjsnA4qJecydgtPezRVST/DFLg1ymBNVCaPRutnS4HVOc0eGrP6f6TbbG6E5ugTQqza/JHCQdzvNAcP7l+8V1DWbccwW9ZjwwDaAFCqNIuFErkHQ1aCgIQOnRdFOWppjl4npze0b/RiKww49fSosXNKX/ctZTnFaVlVvEPVg6IDwBg8bTxQNEQJ5GlnEj3JQbkR5IT6kBF+n9ZSZYYX0jZhTIvUQN4ko6MH2RyuTebfx4LPlWh2LvC61Hz0Ov7CMyez1oL+EX1Qx/NQ5hx5LeooMa5mDLpJ+G+0+bewrgTeQIOju1ktkJklZh/Lucl7ar0C6GgJZGiYTwpqG/PrX7CHnFQJXLDKPZ5OuBgYvZgJqg5eql7naRM5UtIw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftest/mm/memory-failure: keep page-cache files linked until cleanup
Date: Sun, 22 Nov 2026 20:36:33 -0800

The page-cache tests unlink their files immediately after open.  On CIFS
and 9p, fstatfs() on the resulting descriptor fails with ENOENT, so all
four page-cache cases skip without testing the filesystem.  Keeping the
file linked only through fstatfs() is insufficient: 9p also rejects the
ftruncate() after hard poisoning if the file has already been unlinked.

Keep each file linked until the test completes.  Unlink it before close()
so a failed close assertion cannot leave the name for a later case.  Also
remove it on the unsupported-filesystem, NILFS2 and mmap() skip paths.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

 tools/testing/selftests/mm/memory-failure.c |   25 ++++++++++++------
 1 file changed, 18 insertions(+), 7 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-2
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -266,10 +266,8 @@ static int prepare_file(const char *fnam
 	int fd;
 
 	fd = open(fname, O_RDWR | O_CREAT, 0664);
-	if (fd >= 0) {
-		unlink(fname);
+	if (fd >= 0)
 		ftruncate(fd, size);
-	}
 	return fd;
 }
 
@@ -329,20 +327,25 @@ TEST_F(memory_failure, clean_pagecache)
 	char *addr;
 	int ret;
 	int fs_type;
+	const char *fname = "./clean-page-cache-test-file";
 
-	fd = prepare_file("./clean-page-cache-test-file", self->page_size);
+	fd = prepare_file(fname, self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
 	if (!fs_has_backing_store(fs_type)) {
+		unlink(fname);
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED)
+	if (addr == MAP_FAILED) {
+		unlink(fname);
+		close(fd);
 		SKIP(return, "mmap failed, not enough memory.\n");
+	}
 	memset(addr, 0xce, self->page_size);
 	fsync(fd);
 
@@ -362,6 +365,7 @@ TEST_F(memory_failure, clean_pagecache)
 
 	ASSERT_EQ(munmap(addr, self->page_size), 0);
 
+	unlink(fname);
 	ASSERT_EQ(close(fd), 0);
 }
 
@@ -371,12 +375,14 @@ TEST_F(memory_failure, dirty_pagecache)
 	char *addr;
 	int ret;
 	int fs_type;
+	const char *fname = "./dirty-page-cache-test-file";
 
-	fd = prepare_file("./dirty-page-cache-test-file", self->page_size);
+	fd = prepare_file(fname, self->page_size);
 	if (fd < 0)
 		SKIP(return, "failed to open test file.\n");
 	fs_type = get_fs_type(fd);
 	if (!fs_has_backing_store(fs_type)) {
+		unlink(fname);
 		close(fd);
 		SKIP(return, "unsupported filesystem :%x\n", fs_type);
 	}
@@ -385,14 +391,18 @@ TEST_F(memory_failure, dirty_pagecache)
 	 * Remove this skip when its fsync() reports poisoned dirty data.
 	 */
 	if (fs_type == NILFS_SUPER_MAGIC && variant->type == MADV_HARD) {
+		unlink(fname);
 		close(fd);
 		SKIP(return, "nilfs2 fsync() does not report poisoned dirty data\n");
 	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED)
+	if (addr == MAP_FAILED) {
+		unlink(fname);
+		close(fd);
 		SKIP(return, "mmap failed, not enough memory.\n");
+	}
 	memset(addr, 0xce, self->page_size);
 
 	prepare(_metadata, self, addr);
@@ -423,6 +433,7 @@ TEST_F(memory_failure, dirty_pagecache)
 		ASSERT_EQ(ftruncate(fd, 0), 0);
 	}
 
+	unlink(fname);
 	ASSERT_EQ(close(fd), 0);
 }
 
_

