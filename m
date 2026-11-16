Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5923F608379A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0jLVzlU
Received: by kanga.kvack.org (Postfix)
	id 7EA7D6B0611; Mon, 16 Nov 2026 06:11:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773A16B0612; Mon, 16 Nov 2026 06:11:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 614D26B0613; Mon, 16 Nov 2026 06:11:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 420BB6B0611
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D978BA08B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:03 +0000 (UTC)
X-FDA: 85440715206.12.23495EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CBCD1A0002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:01 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0jLVzlU;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+1Ha5ASlzziEtpwFumlx1jHdeafb0Uk6ledTOHN/+BQ=;
	b=Wg32I2m6OsDsuYVYPgLJhOwlt6zMYQjddZXTszruUtt9GUTYT733BLXoOcCX6m2oUy+wND
	TRh+L7EGBxX+e42ejQ20yQkDLWeCgEjiiPDxIgZeBtB4OdAHW1m0/0iFY+Zjpz4B0LzShz
	KCvVwLlhhTtkVBfun9MgB7cOBTRln2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827462;
	b=07GQOLYX/+UkeirwLk98ZM4L4+6F9KACjIVgaKfQiMA28TdjHwiQAMGsBS8nhwj7QnlEOU
	gY8cdTz3SYcGkfu11rfBoSeKPDiagvwrXT/JcG073WGgfmFANozM1DvYKNpACMlnSVht4R
	UifOHhQUUn6d8+q2Dn5e4O87xOi/5pI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0jLVzlU;
	spf=pass (imf19.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FCBB462F8;
	Mon, 16 Nov 2026 11:11:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B256B1F000C4;
	Mon, 16 Nov 2026 11:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827461;
	bh=+1Ha5ASlzziEtpwFumlx1jHdeafb0Uk6ledTOHN/+BQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N0jLVzlUI4/sjWNYOt0rXQTtyrgdKf5Y0kTKuip2dZyDj+4g/Ze7OYrLUiUsPPEye
	 CjUN4xKWTGOixjV4KcD/jZgCYY6N/+4Z8JHcT7hLcQcrx8q02xe7tYXpY71+xQEHQi
	 DyFRbLRY7DB9BBOX6LHXYX8dkO5Z1aVdfUmhEIvTLaHSBWeb+l8zD8roBzYXX4rqBT
	 yE74qV89FpLs5TJU9EwHKj4pCX4TE4X3Kq2ekdC7rThFYLz4eNiPgoOfUI1au18Vyn
	 pkNLVmlzaNlj37i5uxQXej7cjjXciz8n3fqCszEa5y6nV+Axoq1qL8ATP7YBXt6Xvi
	 rOa1KxM4tYdvg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:13 +0100
Subject: [PATCH RFC v3 40/44] fuse: refuse files on pseudo filesystems as
 passthrough backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-40-8cbbea1cf34f@kernel.org>
References: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
In-Reply-To: <20261116-work-loop-pseudo-v3-0-8cbbea1cf34f@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, Christoph Hellwig <hch@lst.de>, 
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, 
 target-devel@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-mm@kvack.org, bpf@vger.kernel.org, 
 linux-security-module@vger.kernel.org, selinux@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-nfs@vger.kernel.org, 
 netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
 linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, 
 ocfs2-devel@lists.linux.dev, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
 Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, 
 linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=3093; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Qkr0BYXyDd+I7xUdfK34CTesF8mQyxzVRm4u7QW4pjc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etz7YYleq5CAw4X4sGW+b2Uz1jbJrH8r5vBSK3KaB
 H95VsCxjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgImcncTI8K+t9HbCCqNJecsr
 BR3atl39NOkGq5CQkcDVYiVj2Y+rnRkZWv6WG+e4sr/I3r2+LPNhivaEm6fb0rycv4m/V7qxpnQ
 JFwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ns1fykgiy51q5ntmdt645p9bgkh78wwk
X-Rspamd-Queue-Id: 0CBCD1A0002
X-Rspam-User: 
X-HE-Tag: 1794827461-362363
X-HE-Meta: U2FsdGVkX1/E+2HIZol6vOcbu+9YQ34djhfiAdz/8yyeQ2aNpjQBzde9m9vDl7mL5kVGVrPVWiTNWjOKAVctfVfUg6bWGXMbn5D5cufesLE0rV6FddUeLzfsntM6eRqBf/ZblzcbGfQPqLM9EgaAR6OLci1GLextrT4cOuTUHrBSSBvLmUnbuViJPaM2+7p9p3Wax7CgTpbKX+xOQrcyJQSKy5wmBQ3yVNa4xrFjbtFNJuBIpf1RHZGAtuNxcYSLD+DpDi4Nrh7pRmCJ3NM4L9U+6TIyp9xOiE1yHlzrVFHzmfnBG9FUBRfZa5udKYnbGUD2DDspcfv+7BhFySjmWBFwLmfrqGLhGXrDZOwqnPCtAudMwHGExlhcFopH30IgrBFjoWbjmF0bDXJVWOm9tSf6UcN4XU3Ao3Fe0zz768eIYDWNq+D9efX1Xtn7jM67W3kbLuaSMJ+CPHsUaCWyGL439qZA4Pl476+Ccl5aoofdAfoymSAmkXv64r7EQBqNlxpbZhC7gTl9C01uCpIauZNtKhCwTaJEfrSdPOzjhTXYJHqgHyOymK0hd/Am4MQVOUpXWH2RW1irkwQDjXfG7vGWHNB6pcWM4z59L7Hjc/ETA3z66D9bT6QdpkQ0PG6gbQhkimPEK9Z6H17Xu2Cou2CWLsojYfHgoZ79Fc+6nTkLStJoXTij57sl0b/U3U+dYrKFw2YdbPQhpNJq40X7I01QS13FFco4XDqSatwIqYO+V76jujKjmO5m0R4uIrM+wpchExhykjfvkzLSSsnxx+8rB7drXfmd4YP3W601crDYnMV85keOJsNcJQup0lXOD+HxGPhfHe8DhBwpVjRMuAzhrM5i2eWPpPFZ8lRuEditk+m1LyW+EwbxD3ilpgsmPMbME2dya8uX72RFeeksj/vOLkPNNq0ayI85gyfHw7MLTFlPQXknpenbnyDFiZMrf0hwVb4W9V6Jtw3nHfe
 YKE9UTge
 atcrbd8n2QOGbW9R35ZxGNSi7EFqmU9bWFVh8g5D4hwBrWhapqXPkqn3nyyN1JCf5awKg9AJBO6ksZ48Pc712fCFuoGLYooG/vaQXH5YHVCZvOM+8kir98YSYuvTvfmSDT+mTIlHol8skQqShDEmETl8aW6qhusieFhy9CYEj1/gJqdON/TDcIn5PliBRZ+GfIYWq6qODwGNTdxhjnIvouEdPT4ukB/EiO9wSkY2K18X2tvrUVTPxIlfLO0yrk2gN0wxi5g8lgheyxBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The fuse server can register any regular file as a backing file. procfs
and binfmt_misc files are already refused by the stacking depth check as
both set s_stack_depth to FILESYSTEM_MAX_STACK_DEPTH. sysfs and the
other pseudo filesystems aren't. Reads and writes of the fuse file would
then be done on the pseudo file with the fuse server's credentials.
Refuse files on pseudo filesystems just like loop does.

Note that the backing file is only registered here and opened again for
every fuse file that uses it. Only its path is used and O_PATH file
descriptors are allowed since commit efad7153bf93 ("fuse: allow O_PATH
fd for FUSE_DEV_IOC_BACKING_OPEN"). So pass FMODE_PATH to
file_check_backing() to keep them working.

The file that reads and writes are actually done on is opened in
fuse_passthrough_open() with the flags of the fuse file. So check that
file as well and pass the mode the fuse file was opened with. It has
the same path as the registered file so files on pseudo filesystems are
already refused. But this also makes sure that the backing file
implements ->read_iter() if the fuse file is opened for reading and
->write_iter() if it is opened for writing. Like the other failures to
set up passthrough this fails the open with EIO.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo91QjJHH9T_Yw@mail.gmail.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/fuse/backing.c     | 4 ++++
 fs/fuse/passthrough.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/fs/fuse/backing.c b/fs/fuse/backing.c
index 8c21a8a74efb9..7527f3ecb90dc 100644
--- a/fs/fuse/backing.c
+++ b/fs/fuse/backing.c
@@ -147,6 +147,10 @@ static int fuse_backing_open_file(struct fuse_conn *fc, struct fuse_backing *fb,
 		if (inode->i_sb->s_stack_depth >= fc->max_stack_depth)
 			return -ELOOP;
 
+		err = file_check_backing(file, FMODE_PATH, 0);
+		if (err)
+			return err;
+
 		fb->type = FUSE_BACKING_PATH;
 		fb->path = file->f_path;
 		path_get(&fb->path);
diff --git a/fs/fuse/passthrough.c b/fs/fuse/passthrough.c
index 0ed964c479d96..fc8979ac96a21 100644
--- a/fs/fuse/passthrough.c
+++ b/fs/fuse/passthrough.c
@@ -183,6 +183,7 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 {
 	struct fuse_file *ff = file->private_data;
 	struct file *backing_file;
+	int err;
 
 	if (fb->type == FUSE_BACKING_EXTMAP) {
 		if (fuse_backing_is_dax(fb) != !!IS_DAX(file_inode(file)))
@@ -201,6 +202,12 @@ int fuse_passthrough_open(struct file *file, struct fuse_backing *fb)
 	if (IS_ERR(backing_file))
 		return fuse_EIO("failed to open backing file (%ld)", PTR_ERR(backing_file));
 
+	err = file_check_backing(backing_file, file->f_mode & (FMODE_READ | FMODE_WRITE), 0);
+	if (err) {
+		fput(backing_file);
+		return fuse_EIO("invalid backing file (%d)", err);
+	}
+
 	ff->passthrough = backing_file;
 	ff->cred = get_cred(fb->cred);
 

-- 
2.53.0


