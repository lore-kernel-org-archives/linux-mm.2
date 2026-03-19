Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84432109190E
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEFCF6B0563; Thu, 19 Mar 2026 14:24:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79E26B0564; Thu, 19 Mar 2026 14:24:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D684F6B0565; Thu, 19 Mar 2026 14:24:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C577F6B0563
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C807C2125
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:02 +0000 (UTC)
X-FDA: 84563636724.14.C6D062C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id C5AB2C000C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XfkvEK96;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewUCTptMkhM79tg7s4jx12lG9mruub5v05W2stuwF0o=;
	b=k3TfaHghyiToBll4pNDql/FRKaqfaW29Y3v5wWAxxD8Ap/tbcSuaY474+L5qRfQYxat6m+
	Xg633LeEN+nc88U4vrD5biUVQZ2oKaq5iw3ponarn6zq2EEEXVAkvdAAnARM37I8z7LykL
	VpTgnCzE1aU6YmsHYZOKzu9XZpd28do=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XfkvEK96;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944640; a=rsa-sha256;
	cv=none;
	b=SeugDPoJ4HQmosbV+Y8RhXpTgORewbG84ptBvV74IGju3Pw3Jfiegt+3LBa+RRwWXdw9c8
	Ew817VTzadMh7O+zMaZYJwYJUT8+yNHeKkcj91iyej9pFNXmtJKZ2SzKWKnoeRVpYUmlyn
	0cnfXhLuvOhX9ocbLqS80IsunYqkdAk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F08860054;
	Thu, 19 Mar 2026 18:24:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E07C4AF09;
	Thu, 19 Mar 2026 18:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944639;
	bh=ZWci3OW9VkLh/eXElbKeeShjLLG6DMTcVzbVwRV3zUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XfkvEK96b6Af4h5c8vDa351f81XnSdEUl65wq3/mdexAoWP0OTpTO3mnbC05f/mOb
	 Q215EAtSHNi3ArTGlTpuGy6BJhUWZutWN79xL8/2LCNq+pLuSaQiq0t5p9Rd5o6yGH
	 EOx50xVVBOaYU35V592QzrEO6sIIk7VrjMpFCuXsd537mX7kj663+ndfiNvvZqvYN4
	 DyE8yP1UaX5NHf6iPNMpW755JJ/G9FcXxH10a+f6uh3o6zH0VRrGEO9F3i7NHkkQV/
	 +VINWR5+umEyFKFtQ6QYSzZYOCXCerlITCrLCaW0G/bugSp8UBLnbFGU6uYPiIdf+C
	 2ckLWTUsM/kgw==
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
Subject: [PATCH v3 05/16] fs: afs: correctly drop reference count on mapping failure
Date: Thu, 19 Mar 2026 18:23:29 +0000
Message-ID: <018cd0d8b2dae44de6d3952527e754e52ef02da8.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C5AB2C000C
X-Stat-Signature: t8a833z7cznaa5nb8s6bees1e7xjyi6j
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773944640-526289
X-HE-Meta: U2FsdGVkX1+xa+GyZT9VDEu2zYvd3nbn0HPeWIrJOCkGuTOvafStRUxmK0UHYG3hT4rMV5FMFydOD2vtPv9TWFUvc39bNIE2AdAaoX4JG/iYy6ClZlqVjbuM2UHi7WqVknPVVHdEcICqkeTfv4uduwB+XqTjwUaIpGkZyvCVzEa7XcW9oOsmnaJ7l2SXvPY1d6GwgasxUE/V0buk2lBdixjREKpAwptI8PCBa+je7B/jA6NWp1SRR8jCQvM5HCytrSUl2eKQ0NChD3Eogts7vl99z7KvheHfG+oE38qRQu4XPldDmExYFUHJlJHNlh60vzfhCJfo+hMcpB0t0bQg1WeArBz3DeE7/vEQefib3wBIrnSI6YOigZi1C6WBJCn8Jho5QRx4wZon2Etvr7MqLV6EVdnY0DRkXbDvB3nzEISgUJWm2LELiFyCR/cpY3fKylULINn0FxBJVTWxe6Ylp+vA2qsGnsXXGpaRva23IfSjXaxTvnloDPqs38b/bOd0f2mcKg9HVr8dk1HtL+V0CdzecfPYcGWtW+CjMlYRgIU3IU32ozu/OS2lm8ctAW3aG/lJkXHax5E+Z2COYBPBdMD3n8ILJBuRr03Q1E7YKBfkcN4ZcWmDHnSR6ig8Q9vnswA1AybIg3EP0EChf4be0UNOb0vtDs3lffvCUX1o2e/3H1udwCKsvwHMjp3AkvsuDuPMI9zflWBL1Eq+5LuQqhAroFSATKvAkjid1P5bdoaL2lb1SYjo0mRH/L6cJfLWjYvUE77bIWPhIZx0YVIpOU9oGC6viKYVr+OV0xMiL9RVACnS35brxQ1c2VKYNa/IZ7Rpj3iYlXoYktcnEpIs7tDxjJbq6g18LRNW8RaZfj4m2Rmj/r1k4gVEmfRDFbbQOJ1mQm5l9GPonW+BPuIWcblT1VT9kuQDZOa8TS59gJ/BqV4xIEANJvB4GPrIn6LsO/3H6ALP5RHmp9t2qEp
 sUTlukmG
 fbxLdXRo8oSPm53bEXSt8NJMXIbQ87TIkTBZbTNC0tOgTLa6PyFaJGdFvgLwtVjxnnXtrM+SFLj8G0H5ymPw/xzTaBKp5yiEnRBCpsaeDLbzlsA6yfIsL0OX/PiHavaplPL2cpM/NMTCB3y2yln/2U1A3hhezlZXp1HgHRSqo6ZNtczM7cMD9FKu++mQHMbshzavbhhfDCQusEDupql2yvemonMWN44Hi1YYxqtWbYnAQL2IHPU5QpM5m6Obv6EPIhnolTj1oH+Ba89j2pJIY2/ara1L3qkhqRlr8YPeDTevBqtjcPAAGgyShpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour
of the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare is called
pre-merge, and may then be merged, nor that mmap_prepare can fail to map
due to an out of memory error.

Both of those are cases in which we should not be incrementing a reference
count.

With the newly added vm_ops->mapped callback available, we can simply
defer this operation to that callback which is only invoked once the
mapping is successfully in place (but not yet visible to userspace as the
mmap and VMA write locks are held).

Therefore add afs_mapped() to implement this callback for AFS, and remove
the code doing so in afs_mmap_prepare().

Also update afs_vm_open(), afs_vm_close() and afs_vm_map_pages() to be
consistent in how the vnode is accessed.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/afs/file.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index f609366fd2ac..85696ac984cc 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -28,6 +28,8 @@ static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
 static void afs_vm_open(struct vm_area_struct *area);
 static void afs_vm_close(struct vm_area_struct *area);
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data);
 
 const struct file_operations afs_file_operations = {
 	.open		= afs_open,
@@ -61,6 +63,7 @@ const struct address_space_operations afs_file_aops = {
 };
 
 static const struct vm_operations_struct afs_vm_ops = {
+	.mapped		= afs_mapped,
 	.open		= afs_vm_open,
 	.close		= afs_vm_close,
 	.fault		= filemap_fault,
@@ -494,32 +497,45 @@ static void afs_drop_open_mmap(struct afs_vnode *vnode)
  */
 static int afs_file_mmap_prepare(struct vm_area_desc *desc)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(desc->file));
 	int ret;
 
-	afs_add_open_mmap(vnode);
-
 	ret = generic_file_mmap_prepare(desc);
-	if (ret == 0)
-		desc->vm_ops = &afs_vm_ops;
-	else
-		afs_drop_open_mmap(vnode);
+	if (ret)
+		return ret;
+
+	desc->vm_ops = &afs_vm_ops;
 	return ret;
 }
 
+static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
+		      const struct file *file, void **vm_private_data)
+{
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
+	return 0;
+}
+
 static void afs_vm_open(struct vm_area_struct *vma)
 {
-	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_add_open_mmap(vnode);
 }
 
 static void afs_vm_close(struct vm_area_struct *vma)
 {
-	afs_drop_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
+	struct file *file = vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
+
+	afs_drop_open_mmap(vnode);
 }
 
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff)
 {
-	struct afs_vnode *vnode = AFS_FS_I(file_inode(vmf->vma->vm_file));
+	struct file *file = vmf->vma->vm_file;
+	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 
 	if (afs_check_validity(vnode))
 		return filemap_map_pages(vmf, start_pgoff, end_pgoff);
-- 
2.53.0


