Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9A4C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 02:29:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF2D6B0099; Tue, 22 Sep 2026 22:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C7606B009B; Tue, 22 Sep 2026 22:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DCC26B009D; Tue, 22 Sep 2026 22:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57B796B0099
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:29:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DDE3B140682
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:13 +0000 (UTC)
X-FDA: 85243444986.06.5684C36
Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4FB0C40006
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vz2vN8vm;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf07.hostedemail.com: domain of zhenghui.hao@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790130552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=c2/UpacLji4hUGx/IMN7tFqHhex9cxgusaR9P8+O/3I=;
	b=C0bUj/4j9CFja/vaxEaeQRliPDCCMJ6uY3H1XEAZdqpjQcCmOFpyGmEklYE7y0h2eMfBEI
	13G8qXU1l7M3X4QP7txRoXuIMBT4JK68F2RztPOw1llx2Tk6tGjgndQe0lcEYyIrSKMEam
	632j2CEW8PnXr1OJvWK2jC4hz76kuFg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=vz2vN8vm;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf07.hostedemail.com: domain of zhenghui.hao@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=zhenghui.hao@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790130552;
	b=W17ez2ENvxpYH/yEGZh+eBfMr2KfKBYy9SKrmK7n1yYVuxjOCFPomCNuAkfnZo+unGV5Ww
	S8zre/+2Yzo/awJ44aLo2cZnPmZz0yCsy8ncEmY5UrVDCezdFa/abqyG8+P2L7xnr+Mxmf
	/by8JYsngzjknX/mYHkvFTm8NUl8pt0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1790130546; bh=c2/UpacLji4hUGx/IMN7tFqHhex9cxgusaR9P8+O/3I=;
	h=From:To:Cc:Subject:Date;
	b=vz2vN8vm0Tw+loz/KZ5PjYSA6gRneWt5g0MKzmoPCv1OX6p9zR0YWVbza4TQA5BdY
	 zuj1AxxMIIlHnYji3+oHL3l12Ur7ysf3QfLrFXCpkbmjkpaVx/2rKlw5P+xYXtP0aF
	 bRk2b4S+XdD4frJWQtDWUV2dj4O6sgpXpdGhhUi8=
Received: from XJSH01426.meizu.com ([61.169.203.203])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 7441BCFD; Wed, 23 Sep 2026 10:29:04 +0800
X-QQ-mid: xmsmtpt1790130544t34ssj30y
Message-ID: <tencent_AA61551D1F50E61F46C8542F5C8874512C05@qq.com>
X-QQ-XMAILINFO: OUHdjnmRxhl6BrhFTxZKSInajEwOTmtmJoO2V5moqyaxr8nL4Mf/Oyq1lHw+eA
	 pr/MHUc9WZpFzxT7r3vdWoVGksgTLf1bfd8dvUbeyY+veYXedXRGHFYlEVrw0zM6QSTjL3k2Ghmz
	 kYEXoRVQV68W+Cq8fandcWFZnlJLev53nKFcTavqQY/tsd707MmdcAxkd5IepEwI8LHJ0RXP5vyY
	 HXl/7wEoK6v+sit6crTStbXGUFpt8ZhhdNJNVYksgkrRVqArhiBLZNhRWQRgbyZhMYMmUFmI/Jp7
	 7E6OqmajEcLawJM2DOlLr/7QQOldvPVBGAimcBmnOMjLwTYAP+I8L+pEDrsyh39u4lMNaKgNaf1b
	 VlEoWLAgenHMFLfaG9r5a9XlE6Q5ibWUULVPbvdRtXcUInuY/+1NfEEBkPqFbsrgT0LqzUS+9bcM
	 3sKCNpVBtswt5AAooBSIs+fXNOZpWN0EA2LqBiOp9xdhZ5sXZmX77uUVw2gCPDdEWhRhGy4sOAMG
	 CZOd5SjAadGkoIglI6ECanXGkDIWd0HMUzRFTutgaOCrELwWMhNMe96ZCIsIL8TuJT2PsdcgdAFf
	 GzrrLwkcLeHQeu1YKTc5V94hPQ17sJb+tXPkjfhvU3ILc+LIiZaZ/hW/mgVdlNVs9YtUJpS0LvRm
	 cXwHD7s2J7vb7Rt9+vYPX3UGtxN5domOhBGJ+jYuTzMqhJAQ/hH3eg0IeSKIs9TGQTcrpPkfgbgy
	 hM/0epZ0du/0sEdy/6Isgvr9sI70+PFqtQjGISYaned20O69r4HlVDQlh1VEwOotWFivlAGqDwLn
	 w+afkpMDNuHC5qMXl3IEFrN2HTi737Ufq5LDuK7CK8+VRb7toEmcqGeDxIoNGUB7uNIUdFaNnBVf
	 nWYMprVUmZcZFK2vPcp16hI27SAMt963w2sX2yIaOG6YekEsOzhY/FRaQHRUxJc1Fe8LX68vfkue
	 UU9vigAVk9Wsz/O9mp/rgL5rGmCtpAhD3mJlmQvVvWtgyT9mc8OIC35TAD3K/VpEvOaJyDIbc42A
	 rcygEDXJZB5SIH7pJFtc9D+6aPKc7YThLTOirIiD11Id8y4qYiXtYCzQWJePVQSv64Xe5iOTCfJE
	 XBptFeu6ZJLlFo/vogTY7jntjk88RNGg6D3/h7I2q7oem0F50JZ68dVHgG7Q==
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: Zhenghui Hao <zhenghui.hao@qq.com>
To: linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Zhenghui Hao <zhenghui.hao@qq.com>
Subject: [PATCH] hugetlbfs: fix stale comment in hugetlbfs_file_mmap()
Date: Wed, 23 Sep 2026 10:28:58 +0800
X-OQ-MSGID: <20260923022858.263689-1-zhenghui.hao@qq.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4FB0C40006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 75yh1imn6pwhc7zkr61ihfoqb4y5hox9
X-HE-Tag: 1790130550-835649
X-HE-Meta: U2FsdGVkX18g37XlEqbD8XXFl/P1doR1wR7bGcaYkkXhzzBTEd2C9E21HCcHDHHeh5mkroXtFQH9j8tRrk0fYrGHwk4ngcHkGuRPDR6wRDAbRo4QajynkNp4K/7ttmQJPREB304OsXbNfzk7KEXd9I2VYFSDAt6ZeMxQqQcsXydgEKK11VhVU8N7+0RZVVJqVcwRXmOyNZGUIwIf3syK1UGVhyU1XOZrVSZ3/hrbaE+bVTa0vnWv8mIU1HXq8V6hnO4X00B4ZtlTfYanAOoeXecizzKLlG+e2vT7i5/W1r3+TaiQU8bFktB87YD6fdbcysK1PenI7UMD8oGyRdgd9waEabiJsHAtjhyHYJZ2hVzJSRIP0o9pmjecNpRltWHam7s7euYwK1dspm0DH9yg4cwFtLECaWY/uHz+2c5uzRCoPlIw43RTj/3vaOfkXij7TKwrjeyUNE0H4mOtmn6tUFAsAzpS1FC3Z7vFQi/3rcLFZ0DX1gymx0sMplrueW5q8IhaTodwleHQeOUiP4+1RY+n738AqIfSOHpsqYzykcOsvb7Sw/PRBT/N3okpAAIJgtodXRukSVoWMHSgm+1i2afxTeyZh6FMwhPiFbIoGMFnftAjfw9LDB8EUEYQvvRmAPs8+Qzyrg+dvpSELbSAxvDjkatgmJYLro4DF6WORXclYatFjsk/LKwA8kNizKu65j5tToHBAGaRMtf+/EJjMvkpYjIOO4NzytHrwNQ94tT4X1UmJK9Zqo5Rvisq82gni3kaQncD3J4+mBdAqcbPjxeuY4rg6MHqD2S92vwZ6wrVwNAsw+vz8wQD0DLgd3StMe6KMx2Pn8IUJaMaALo4LCNNH3fWotkbCaXqIYh5XNcAyXfx9XtNktIR4sV2NK9/WbWlfNFkF6bNk13+0lxr0Yux5xxF7G+C0Ts4ZLxiIdsQM+L6fETvI6/XXI92h3SMdnDy2e449fBXb+LFNm8
 2StyKoKV
 q0/8xtv+0MnIxAPNIMKmoSZ4btqjfW9/vRzAtXUA/gd7irUVqrkfePJDeslt1ph77Rnh31uO1FJMG+2Od81EoIh3y5XbYFz5UDXYeLJKeDpZ9SU0+DKHQixDlOUo8okNPSHZ9UvdVAtNqc4Gbd+xU/jZswZ1XaCh/az5jlDKQFQS685Ms+zChRdqkxC0to+TqYR6ti1gxix3D35gzi5nH6qUmKzhPqCwqtsjEM8rdPokA+Lh/U7WcMs0Wykv3ksHFd4CCTFId7mUXxsDwQsYxhj7gX55+wWE0y9+0cjOcE0Xy0nq7hAXthwOcTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment above the VMA flag setup in hugetlbfs_file_mmap() says the VMA
address alignment has already been checked by prepare_hugepage_range().
That function no longer exists: it was removed by commit eff41389d824
("mm/hugetlb: remove prepare_hugepage_range()"), and the check now lives in
hugetlb_get_unmapped_area().

The comment also mentions ia64, which was removed from the tree by commit
cf8e8658100d ("arch: Remove Itanium (IA-64) architecture").

Point the comment at the current function and drop the ia64 reference.  The
rest of the comment, which tells future edits to add any error return only
after VM_HUGETLB has been set, is still accurate and is left untouched.

No functional change.

Signed-off-by: Zhenghui Hao <zhenghui.hao@qq.com>
---
 fs/hugetlbfs/inode.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a8470ea2..e2aaf1b56e7f 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -106,11 +106,10 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 
 	/*
 	 * vma address alignment (but not the pgoff alignment) has
-	 * already been checked by prepare_hugepage_range.  If you add
-	 * any error returns here, do so after setting VM_HUGETLB, so
-	 * is_vm_hugetlb_page tests below unmap_region go the right
-	 * way when do_mmap unwinds (may be important on powerpc
-	 * and ia64).
+	 * already been checked by hugetlb_get_unmapped_area().  If you
+	 * add any error returns here, do so after setting VM_HUGETLB,
+	 * so is_vm_hugetlb_page tests below unmap_region go the right
+	 * way when do_mmap unwinds (may be important on powerpc).
 	 */
 	vma_set_flags(vma, VMA_HUGETLB_BIT, VMA_DONTEXPAND_BIT);
 	vma->vm_ops = &hugetlb_vm_ops;

base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0


