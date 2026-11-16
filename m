Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5908E6071B16
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Tsq4iuTK
Received: by kanga.kvack.org (Postfix)
	id 7EB2D6B00EF; Mon, 16 Nov 2026 06:10:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79B506B05B0; Mon, 16 Nov 2026 06:10:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689E96B0611; Mon, 16 Nov 2026 06:10:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 440F96B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:10:59 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD5BBA05E6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:58 +0000 (UTC)
X-FDA: 85440714996.07.A7B9CBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D1A3720005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:10:54 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tsq4iuTK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BY87H/RnXilQq13XAhtvlglG6136WbkekRPXJvo2I3U=;
	b=55naS+m2pZxDLTIrmSfqwHaa8QhoUHCbZwT9jnlc47+jwtCGFdOUc7JL4orTD4YplRPywJ
	hDVoQlslvaRue2yHCzTL77/BViiCrJOEb8v/jbTfQgxbk6z2KNvdb7JpV9Xv9sR5VbAj7o
	HeXS446gHUkxiRBc06f/wLnDmFMhLmk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827454;
	b=ASd2dAPHzYgT9LJRZ/9yNlsPsd0PvBGaISTqq1t8ji2i5+Y4m/Qv6zVVLIU7HEsdY0PfwB
	K0sP5kWDdmzaMGGZvWRDMbQDGj02L7tjP29NOmCIrRI8ooi4QJ1EnUepxP3sshoJrbnv7l
	BqVo/0owYICDjKj0bWPp4ek7tdhy76U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tsq4iuTK;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 82A4762972;
	Mon, 16 Nov 2026 11:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 416851F000C5;
	Mon, 16 Nov 2026 11:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827454;
	bh=BY87H/RnXilQq13XAhtvlglG6136WbkekRPXJvo2I3U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Tsq4iuTKRhulkomOLwfJCGY7RSUTospv3OqWJbcYQQFjEoKupjSCxw6Yy3rPq4pB9
	 +LrXvKA4rBly7ufMqZGGURI/PkATv40fMYkjtpqcL/tNHRyeTByFbJTZmujbH0d7/Q
	 HXCq2zQGevHC5tGi3GM/YXAFadxr211gKZs+efK2OMgZEBHzheaSEy+WXOjCe8RO5r
	 TJ2bRHJjwjB/ITjzevhBLxBTbfuTMUOIvIjO5xZFZMBmnzadWnSvOl1+uUswfItRJz
	 cvn+ZB4G6vMTJzmJfSaWRJJZDIQQXhCz05Bm/gc8LbBO51UdG9XgtkJRygpVExqJdR
	 0R8YByohYWTAQ==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:12 +0100
Subject: [PATCH RFC v3 39/44] target: fileio: refuse files on pseudo
 filesystems as backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-39-8cbbea1cf34f@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Sashiko <sashiko-bot@kernel.org>, Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=2223; i=brauner@kernel.org;
 h=from:subject:message-id; bh=11gfWGw/ZwPDfVFtqD+CkdePFs+glK5xVNQbp3ek2T8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etzj8cs54I/rlC7xuCARluu5a1aodKvyswTvkD6zv
 1dfVPVMRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETirBj+e2jMajfMFJqpekRG
 aqlo40Pe5TUVy7c/+DD7XlLpsaZOLoa/knzXPN++Mv3K99Ndbp9ymKjRnUWue9I2sb1mqWq5pLu
 bHQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D1A3720005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: c4bmnc99b5nobfrzhm3bxo7xfba8or5f
X-Rspam-User: 
X-HE-Tag: 1794827454-366395
X-HE-Meta: U2FsdGVkX1/TVTs7qopEqPdqk1bC/oT4e/c6czumg85Uno4OAGC7vWgB+pShxRH6kR//R9Jj8H7AFOgh0ZEgOJ/WCQQPXL1S5lZCB9BhzeGhy3xSxMVcUwmpxls60Ymxs1S65kXvYBC6Zv9YxIoT9/YP0n4Vk5c3C9VuEnvnBH5LV5HnwwS0Fjag5yRAE4gt0gIeYlMouXJnhLUXiZwKkn6Me+2pXJI2YOex7ZnwTzRSsMwqYFxERv3k8GfoTE6MwnF+VpTC3TZK1GJpmKDerplfhAKqIPod2IcNvnH7oHnFK63smcxfV33Y/7jPPua9HokQg1zwCdg1clla1XqK9gYj+RrMPZBGMfMj1C5n85MrJ0Wj/Nag7eb+ZY96FfDPwrxbNanDcGeGszdmUQ9xbIJhTPeJwlgmTHs/+ej98hjSweHCBUds6+m0Qg5e4q6OWU63OuRIMSoJA0qN7BQ5pSlc6t31aWYSa2N1cqQH+oEsjnUrUi/ZComN9qn/IckkcILHxijWf+5UDaHpa/qZVtTh5CitPJk9j8VZ8+6iLFOTy3DdXeZ23yqQGqplsyhEK8WZjIuunFAQRM0ZBsGRmXVB1GE1/0M64uB743VOeXcKfCVF2tl52SFqXdQBjCNE2mBkq5LKRtrIesgo9rYi/8VNnT4VT68BHg7DfkL7ZHtRYwRPRc/GsEWhidS5F2iPMizQRmW3tNy/Z9IxgpGiQnCbfRf2Au/ttDlcysqgFb5uMYVQdrKb542gte/dqZ5QLRm/+hBEUH06VPjLxct/bYLUU/4YQYqiSfijF6nMpCNQjbQxujNWBWSTJILwiYJ+lOyEoy5q1VigvboejMwsTWBkMLWmsK9QCIotj9EoGJVvZ/aTguf4raxP/O6wx/L9cu4YDzo3SUmE2isXUXE7UUmzRSwNqADmKEziG8iJoQz5L4acMtvqFjafvG46oqEVf4cU05WnE/Fba20DgT4
 VMqz9kGL
 JzvXhiGdmYLfNi/24NqlUBG60bZ5m+B+hwRmFgK25Awwo/LrL+vHUFZ1KYR6SJ6INjI7iY0KX1TMaUE6DDl5EtvEHGXNP93Ph29GN2wpBxnfVafvvq+CzrHvV+AGIJWmubxhePO8p7OJfmx4O6f0dSRSbo2pUP7UlZiTyszzzsK6qeLgaInPP/Mm1bhowyQugVfNbwqjDfsNzINQrsLW8OBRvIbd8y8efhaX1Ih11WCHl7hPCB2HosHTMryHwp5f4Plf91aEofh+JL+nWSnv5nU76IQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

fd_dev_name can name any file including files on procfs or sysfs. The
initiator then gets to read and write kernel interfaces through the LUN
with kernel credentials. Refuse files on pseudo filesystems just like
loop does by switching to file_check_backing().

Do the same for the protection file. With DIF protection enabled the
fileio backend keeps the protection information in a second file. It is
named like the backing file with ".protection" appended and
fd_init_prot() opens it by path. Whatever that path leads to was taken
without any checks.

Note that the helper only accepts regular files and block devices as
backing file and only regular files as protection file. So far the
backing file could be anything with ->read_iter() and ->write_iter()
including character devices and FIFOs.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/sashiko-outbox-206765@kernel.org
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index a5391e57e9aa5..c747cc4a647ff 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -145,8 +145,8 @@ static int fd_configure_device(struct se_device *dev)
 	}
 	fd_dev->fd_file = file;
 
-	if (!file->f_op->read_iter || !file->f_op->write_iter) {
-		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
+	if (file_check_backing(file, FMODE_READ | FMODE_WRITE, S_IFBLK)) {
+		pr_err("FILEIO: %s can't be used as a backing file\n",
 		       fd_dev->fd_dev_name);
 		ret = -EINVAL;
 		goto fail;
@@ -861,6 +861,12 @@ static int fd_init_prot(struct se_device *dev)
 		ret = PTR_ERR(prot_file);
 		return ret;
 	}
+
+	if (file_check_backing(prot_file, FMODE_READ | FMODE_WRITE, 0)) {
+		pr_err("FILEIO: %s can't be used as a protection file\n", buf);
+		filp_close(prot_file, NULL);
+		return -EINVAL;
+	}
 	fd_dev->fd_prot_file = prot_file;
 
 	return 0;

-- 
2.53.0


