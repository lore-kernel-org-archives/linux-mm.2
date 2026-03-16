Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B0FF53D9E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 21:13:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27EE96B0386; Mon, 16 Mar 2026 17:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20B7A6B0388; Mon, 16 Mar 2026 17:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F7A46B0389; Mon, 16 Mar 2026 17:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1DDE6B0386
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 17:13:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCE771B82B3
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:53 +0000 (UTC)
X-FDA: 84553178346.23.BF3D2A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 579D21C0011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 21:13:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G/nMXj/G";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773695632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RUoNlaXozMyY0U3M+FKFJmHTmuxzRwEY0rpev7KwJ64=;
	b=JhYFxnmzM0GkDSAHJAJwBchVLvDydgo5dnje/ekNp5MoxD/sOmkustZwJQHDroUGkXVaFt
	9+C0bxH+0dC9yhiMc893wZ/2zgZrzrAh1wvql/NyOgb5jb//IXnsK3Cj0Z7CS1PRoMd/PO
	WZ7HAelT0rRGLZHcERQWehe8slYp3Fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773695632; a=rsa-sha256;
	cv=none;
	b=weBzHGB03bq8m1BjE7UAC7khFUIMX6JHg/JsnRLhDGf8FIVIx5md5ZRJGKjSkGoLiebHMK
	n1ExiHrGrWfOyNgLLD88UpSzrpI538NDgShXr6JUWtj1jGh0JEMMAzbRYasFV2WS2rjmZH
	Drp8h9cjiyCG3fY6L50d7VMdugo/Skw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="G/nMXj/G";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D174A61337;
	Mon, 16 Mar 2026 21:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE085C19421;
	Mon, 16 Mar 2026 21:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773695631;
	bh=6S44qhIRjmjl+gxtSz073d0fvCuPGMw2Nzi6g3n7GIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/nMXj/Gt/rgZs51K4/q3MDaE+1rYepOBe9N35lU0C2jzQBG8tTMYbazchVMYIMrK
	 SH7mg8XpmttG0GxwWU8BM7a0GUW3UGMBHY1NW0EnFW44iOQdJHVsTPnVZ3FoIAIBxx
	 bQDZGVyvVsDs/9OIustgkwgYS2kKqpZnsw2fFPNSxnI9hHJ2uyO4J+A+ZOn3MpRsp7
	 UoLgV+kPKpfkcJFy7hB4YEPJlYUm3QUlmbrfI7JF3TQbwG1WarvqyYy7wBcDFjfHmW
	 yXyR9kTsNP+yM1b0kOfshvK1ytmwp+wOxUyN7ESJXV/1+Gc/FTTQqfKokMguPcdSMp
	 9f+mZjVQTJvFQ==
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
Subject: [PATCH v2 05/16] fs: afs: correctly drop reference count on mapping failure
Date: Mon, 16 Mar 2026 21:12:01 +0000
Message-ID: <7adcb09e6817fadf9572a96893e95eacfe6fc4cc.1773695307.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773695307.git.ljs@kernel.org>
References: <cover.1773695307.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1zd134fazatgsdo3qxh5br7q3afr5s35
X-Rspam-User: 
X-Rspamd-Queue-Id: 579D21C0011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773695632-208101
X-HE-Meta: U2FsdGVkX1+UWqUeKXUWUwx4PLZHYvaKMWDS6SWqUetYhR1ud2yr8cWxovlAD3yq0GWJHlH10GwIMfEE/6GeQclWPYf83b4xSYmQ7CBtitn1wkpLbbYI5AXsbjgkAru/wkhHZo870W0G6uo7sR8RBU9Sn75k0oci8+TRNX2H34LhBsMTVdrQjQGbOWXFZKn3NbqRHFTQ6ODvBxCn+mulWxfKbFkcPYfNcORExdrqJZAnJrWJVy/0oEvfGvGtOCNbt1n+SvjPUo/BYek768pvyOKAoqcon14XVSLrKReL3hrPKesbJcXD1Sk6LZhI1ZkXuGIFgcuya2AXRfgxy/SpA1fye+um2yk6G4+pLMh9lUCe2IPc3V0BTd+8dFsgEXqj8Ds+IVPFsJE2euWQCE7JZc8EvaLejo92wnjrrcmbKM0lQLg0XTJZXkRSHs/MrYYucgrZnIPur22BhYrhI3sT3CEEfZwpvGA3Vq6Y3Ubaf/3Tp/NOdmp1f8QlymQn/v+O5CLpoQw93OhQnuHiv1eX+5hox1rC/4zY155L0R6mkOY9K0sMixuVzPF/np91WwZMjLSt2LjKW6l/ucfGM2y9xSM9LWpOxMBF2BF8/t5uVs8dGxcthqT1AZ2Qf4JoBR4idJpU0IPz04AGrSRA7D0I2Tb9iQNB7llVn6WrKa6mib1vrtzCQ2IJMl+xDzet7XD/tZcFKRy6XW3W6ZmlNMrV68+cOKWw7XgoWeoNDkv5HheAun0vu+NMwGZzUk9XIU+aYwmJSWfIWN2bjOVpIRr1IeayutDU1kAHkEGwVjkkKqLnhUFQFBw6ZF+EjhDiQoj8qrMgrJT6tr7dRCxy82dGxoWLPJ4xDZ6OSsj3h/qZ1U0HjLL3fYvuBlt4X3FJRh0OGJsKbX5vqCRJs/EahIVHg1Y291MEwKYtuglIeVpKB82ORq8QUqGw8DC3SDk8Xe6N+QO1PY96YnqjtkrxcF/
 UZuGK7t0
 QzCK5iKbIDTBkWus15CnOI6GQLq3bNHMNkvgh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare is called
pre-merge, and may then be merged, nor that mmap_prepare can fail to map
due to an out of memory error.

Both of those are cases in which we should not be incrementing a reference
count.

With the newly added vm_ops->mapped callback available, we can simply defer
this operation to that callback which is only invoked once the mapping is
successfully in place (but not yet visible to userspace as the mmap and VMA
write locks are held).

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


