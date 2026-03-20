Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7A21099B4B
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB2BC6B012C; Fri, 20 Mar 2026 18:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8A9B6B012F; Fri, 20 Mar 2026 18:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC6FD6B0130; Fri, 20 Mar 2026 18:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BED056B012C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82C041B7A7E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:34 +0000 (UTC)
X-FDA: 84567911988.05.7DBA79E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id C6028A0013
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:40:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMfCOaMY;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774046432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rM66s3u7wmcwPYPe7utZHYhtdJOBtDyMhAQiY4qvZlQ=;
	b=JnQdrI7XYomJXaUJAKLsIn4YDe99EPM0HwhJt3+WE812+aFn5/7kYSPQTLpapnOZ1Jb48U
	ilE5kWWYG3Ni87mx6vnyYB8zH9ns/KtrGzwMPQ09PEthCE/qbnESD3L08+KhQQnbBMt1rK
	+LL/V5yf3vJJsP/jFyxWJVgiuJbb+fU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774046432; a=rsa-sha256;
	cv=none;
	b=MCfeEUjWwzJKNeW7rnNfgIpZUscUhxKNzfrzs2Rtii2/TuqW1+As3VqlANHrLfgsI0Pe0B
	xPeaabiZYRWRqVh2YRRJRuj1ULqVeyBuThzdef+qh0cuyArQyCfjseOc8nQR+ABnGXfh9d
	aIBs2FIohaOZ3wkUAF4erbwZHb1yz94=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uMfCOaMY;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F23C14346A;
	Fri, 20 Mar 2026 22:40:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40593C4CEF7;
	Fri, 20 Mar 2026 22:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774046431;
	bh=Luge2LcM06n2SwdrkjrO2DwOaqu0iDXh4dllLKz3Bdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMfCOaMYXg1BaHfL5Xiiept3qlEDKI46B8rP4kN9UP55h4jDK25wfAnhFC/1We7RY
	 7pIBQMIzfZ+JcW+sp89HeSHcKoOkzKuqlM1Z6GbtMVDXz5gOjPBu1/u9dwGi0UWGQs
	 kcO5dDATOI1JVWz+A8kCz+3+XJL4Jtf+25Wbtj6TLZWHktMhmLKQPru+RQD/wL4PtB
	 1m2QSDQb/5aZqO7bJUnb9j78yorYoZ1ZZg8/H3TcJJT2t9nAIv6h8wU1i4LQndST9V
	 1WqCNRiMmXHTyTvP+j0shuaa/6nqBB1U9fQs7YoseEpTBNqk29Oqnvdclpa/lcWlXf
	 qbyyCSL6nSnwQ==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v4 09/21] fs: afs: revert mmap_prepare() change
Date: Fri, 20 Mar 2026 22:39:35 +0000
Message-ID: <08804c94e39d9102a3a8fbd12385e8aa079ba1d3.1774045440.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774045440.git.ljs@kernel.org>
References: <cover.1774045440.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ddb5dy8hj8g9i73beunpgzb5y4yrc49h
X-Rspam-User: 
X-Rspamd-Queue-Id: C6028A0013
X-Rspamd-Server: rspam12
X-HE-Tag: 1774046432-149107
X-HE-Meta: U2FsdGVkX1828NEUVMcxMxy4eq9mUw8I9SoXtuqbBq+0G0/hs7PKM1VDO6TYBV1vEFE9Kx+hkeWhAczP12tjTe+mF9O6oFw62LRKeri4CZkO1I9gmWTsJ0IGN2cMD8VigSHm4+f9hIR1PqiZDB3AUG+0TdCHvhax1L37N9PD9D6ZSmFia/fztTtHZXrfRmmYV8gzjvQQfp//X5WAg1OT8Tt7Zqheq/O5iE4XkxxQrnLAp+wQgcjgjRd0klACF6k8XJXTViHSwyfkTWA5MiyJgnFGZfwGuJoyf2vomV8Mi2Od/eKlq5bPJSNQKMe9P2pzDzqvpump0XMsz9QmbHiaMggEn7U10vc8wX85OSS2ysPUZtuiMZZSbxhnTtmN8/RXaznqVspAwZyMR4n1But4Tqfo9qufbx531oHj+bV8nQTvhWkC2BwyONBcBJsawnLj8rGAQzxEUZz8R6od6TRS3icN4wo3PKBA7cjyaUA+IvsRzNscPDTE0Mjvg4oPr4F1aY6zaWNkeHe5KmEiGFVScAKbkrwzO9pziHHJ08OBUqsr2Y+a8gSYnmh8ecXs+Won1cFz/+NS2lZn4VTuxwFKJYewu2wIR66auggsSXNaLWNoqJt9WMJcU2IaQumD17NMPhxCvvkqx7+ACkP6QP/Zq8Qu810hhpBnSnH72p09DFJW2Uahf8n3E/siIYbDCwi3M5xnYaPnrVsIx0ZlWthf0eXK5Gkw9eK4DnELXUXkLGAzLzbxLlxOupBW3M4Gb2uIT9YX+E4e+sxT0oPVZgfjO0+2CEhAX29dG1Lum7JMsfdJgapFUI+q2znP0F8RUa7lvsVvPM80lKO+9vnU+NVrgcZaKDKbg6YGBdLkZ+JXWwQ1wYA3Rw9r8T+tcf98zVI2nYIkQfytuy0ttb3L69F4GUDvHp4zAZKbLa9UBGckDZqEvrd0EcHUzLmwcgQT1S+STEE99xLKAl13KopMFM/
 8RPD8ud2
 M8M4l9dcbVX3Agb8oO5c51Pn9cRblzLopL7Xp3aJj2/AqSLsyJLrYlOHmIv09mTTvAQC7c8pdZlE0ZlN4jJabTdAnEtqqUW+gRU6wEqCI18MVlodO82BO7iiJikcP8fQLzyH6BguZSGWpJvax2AHuWG4wSSmzk3D6/rPoPnTT53SbOHhX4fHS5mDPCqO2uavXvcD1SNGVXa4oDRMysc0+UC4jm1n59SCYkAVf3uvlR/sIczYs0bNHoL+TFMVwjXOu5TRyihmytzZ7IBEaYsvbeotDanpfq5nqsSOL4fgOMZiVueLos7tu1twwDq5CctdIp+mF74FIV1CjfqAkyyoNTFkH63W4nzhcqfIq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Partially reverts commit 9d5403b1036c ("fs: convert most other
generic_file_*mmap() users to .mmap_prepare()").

This is because the .mmap invocation establishes a refcount, but
.mmap_prepare is called at a point where a merge or an allocation failure
might happen after the call, which would leak the refcount increment.

Functionality is being added to permit the use of .mmap_prepare in this
case, but in the interim, we need to fix this.

Fixes: 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to .mmap_prepare()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/afs/file.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index f609366fd2ac..74d04af51ff4 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -19,7 +19,7 @@
 #include <trace/events/netfs.h>
 #include "internal.h"
 
-static int afs_file_mmap_prepare(struct vm_area_desc *desc);
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma);
 
 static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
@@ -35,7 +35,7 @@ const struct file_operations afs_file_operations = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= afs_file_read_iter,
 	.write_iter	= netfs_file_write_iter,
-	.mmap_prepare	= afs_file_mmap_prepare,
+	.mmap		= afs_file_mmap,
 	.splice_read	= afs_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fsync		= afs_fsync,
@@ -492,16 +492,16 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
 /*
  * Handle setting up a memory mapping on an AFS file.
  */
-static int afs_file_mmap_prepare(struct vm_area_desc *desc)
+static int afs_file_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(desc->file));
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 	int ret;
 
 	afs_add_open_mmap(vnode);
 
-	ret = generic_file_mmap_prepare(desc);
+	ret = generic_file_mmap(file, vma);
 	if (ret == 0)
-		desc->vm_ops = &afs_vm_ops;
+		vma->vm_ops = &afs_vm_ops;
 	else
 		afs_drop_open_mmap(vnode);
 	return ret;
-- 
2.53.0


