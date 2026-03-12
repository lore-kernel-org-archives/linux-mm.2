Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82101106ACEB
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A966B009F; Thu, 12 Mar 2026 16:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD8B66B00A1; Thu, 12 Mar 2026 16:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80D46B00A2; Thu, 12 Mar 2026 16:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 972396B009F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:28:03 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69B3DC1A73
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:03 +0000 (UTC)
X-FDA: 84538547646.10.2E1E155
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id ADB694000C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:28:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfFsDlKL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773347281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lBMX9SqntPJmL61GL+Aj4h9RqP6XttSNwlANof5PCc=;
	b=rARzH2DX0jXcLKhml7Jcg0/GxXp0bbkW0mgyAEpjl0EabPph2Kd9SkS6dbinmkh1bLrJqg
	PoxJCzBhcfn9bL6S9LVYdgsKOoRZvx6Jf1e8gRjUt/A1txe1717IG8rOiZtOZ522cXPJKG
	Mj8+lKtuvK0GksBooOrqSupB0mSOHx4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LfFsDlKL;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773347281; a=rsa-sha256;
	cv=none;
	b=lcueAwdHHYM1sJqXePcrRWtfQ8m9M/k0hzJwHH6veyyXof3qPIrXIdxM/M33YLWSZVcRqW
	+QmyIgWELZ2rn+sJiokCoEwIl6LpjvnK0qIVog/Qftz1W/ABMy55P09mjuG58Ks3bm92VJ
	gLDbzs1NWP9TzFUS/DLYaTQk8sBgHH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4CBD44422;
	Thu, 12 Mar 2026 20:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1CFC4CEF7;
	Thu, 12 Mar 2026 20:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773347280;
	bh=+y+8TQWjiS/6OrohqiWfuyvPwbhSgEN2DOnPq14pRqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LfFsDlKLNAp/oUkhFt8+RJpJFNYhJzB9jojo7IzLuXDt50MFkYyLL3CyAZ4orGL89
	 khtFo/M99wAIHGfgccHgA4i9BOZL5xKbg+QwXzkPEfJGsVsqudSj1PcBlmszAf6jUb
	 ZdlUOHKcaob0y3vsG/pBzy4NU5HZTOTpdAht1Fp4UVqk0c69cBrynC1//SoepQdeej
	 tzFBQxTBarGSS/viTR8OOOWGPKeCyBr/USYqWgbRQ/5DPHfa1oDWDRhxg/xB4dHxSF
	 p5vuEySpbc07otTTLQ4eERmCocSh+bkDcVL8rWtVelKhT6mEOsZ0bVdv3mUICoipaS
	 atIMiOhViZuxQ==
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
Subject: [PATCH 05/15] fs: afs: correctly drop reference count on mapping failure
Date: Thu, 12 Mar 2026 20:27:20 +0000
Message-ID: <4a5fa45119220b9d99ed72a36308aed01a30d2c1.1773346620.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773346620.git.ljs@kernel.org>
References: <cover.1773346620.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: ADB694000C
X-Stat-Signature: r5pt1h9gh6j8xih9cq9om14f4pro6acd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773347281-151478
X-HE-Meta: U2FsdGVkX19ceZ99lBD5qMenzeInBDTBPWD1vKTvmTD0f6TAQ7/BekyexBaF6QYeaYWA/AasDweQMdHFhag/871RlQNfbpqoAgIq6F1KgLNDRNrAH56jHneKSxdAx/D3fUCiU02pcyw9ywqzGSJYWg/yqW6Qk7DoeyuH2qU1gj1PHN3jrOqEJgbEi0dSwKOVumvG5sCKrZNdMH68B31ycWFAs6EjndI8xybEIcMqt+a6zyxeMSVyYfpPsQR3UvFQSr2tqhTDXVkNJX+4S5UzM64ZQQTjDLxraY/14Nx2yu2N7xSdzPNdnQKfLp8VP0ylVlQGGNiB58Agw66Nx4r4+lGrYjOggdc/8/6BjoX8AdVEp5DB2TdRjJO+pv0ocSKTKpY6K2Gv2y3WMdMyjCCfrk4g+q1TOxtoXdkEkDbZ/w+QxJ26DNGFTVzuGp4MIO8aLPPqXnVAAs8e+/Ig5QsyvPlIYG6LJhmYbk3BSGErLBGTdfF3xblJmMsJp8NZJCK8PfDIfKmFBm35QTjCGlMon+cOGJKtqWL64ypaW9rqzkcDLq/tk3NGkg0x6/e5egNoSNEiWWG+T8BfV22lUxa0HXCqYGPA2CXgiyNmtyUaewAAMKeUdlEt7NITMuCDGhGEzrcnOo+lFu6oEdCrdZdoiTMrEkMJqVvQW55rDDt2fLNriQX8gDAD7vxiH9foxLI5F06e7kEPxfVK0jraDcznRwZ3PO9IdSL9f6tu0zwWEYaaJXz9jMNG6JFU8p7wlqrjfggq1Itpg0/IvYHEqv3Wy5RzqtB1hWj3Xl85AW6sIJIbqfYg1OuQW3Sdi/KwytF5BJYv85J/FQNIdMiEPEBkx20tZhuyOH28XUtF1GSZxlj7ZehTJohXaW8fCO96mXGirR3tf6Tb0jS6Tyi3//bVP/+KuCcug6btE6McRlsU9DXiB6zRdDR7tLFTe5jpfSBJoUiaKNhKsgQeVNf0gJ4
 ZipNK11S
 8pQbmdPnANy8D6Lkp1ifyKbmnMG0uvUbeR347AirjAvaFNHQPDRFOp0HKAfbYpUKjY4y2tfMmya7AlhNXv8kJLwJob5Yq9L2SFbkdwkro2sUw4r8H9Ce1MVsykDEZwwU0yCPSyp28Vo96F+VF8E07exFskzUOAbEskCLQ1MhEqyDLMSYdo8Ewi7Twid8j57DbvNxHMCS3wmWzz/jgpwr7QKBfRaXWXtB0Yq3eGP5rl/TctmpsIYFtyRV8qLqSK7wixBhtimzXtWM+t3U8sx8llRZ2AMDSyrtu2v2b60NJGXrrHpFsp99qMvfVEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 9d5403b1036c ("fs: convert most other generic_file_*mmap() users to
.mmap_prepare()") updated AFS to use the mmap_prepare callback in favour of
the deprecated mmap callback.

However, it did not account for the fact that mmap_prepare can fail to map
due to an out of memory error, and thus should not be incrementing a
reference count on mmap_prepare.

With the newly added vm_ops->mapped callback available, we can simply defer
this operation to that callback which is only invoked once the mapping is
successfully in place (but not yet visible to userspace as the mmap and VMA
write locks are held).

Therefore add afs_mapped() to implement this callback for AFS.

In practice the mapping allocations are 'too small to fail' so this is
something that realistically should never happen in practice (or would do
so in a case where the process is about to die anyway), but we should still
handle this.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 fs/afs/file.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/afs/file.c b/fs/afs/file.c
index f609366fd2ac..69ef86f5e274 100644
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
@@ -500,13 +503,22 @@ static int afs_file_mmap_prepare(struct vm_area_desc *desc)
 	afs_add_open_mmap(vnode);
 
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
 	afs_add_open_mmap(AFS_FS_I(file_inode(vma->vm_file)));
-- 
2.53.0


