Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B03D3606D785
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mmCSykMY
Received: by kanga.kvack.org (Postfix)
	id 2B2356B05D6; Mon, 16 Nov 2026 06:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 214806B05D7; Mon, 16 Nov 2026 06:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12AE66B05D8; Mon, 16 Nov 2026 06:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E164C6B05D6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:06:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 685DDC094D
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:38 +0000 (UTC)
X-FDA: 85440704076.20.DBF2068
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id DCE6C180018
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:06:28 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827189;
	b=pP8DkDHnMEovjJXvQpjKDFEkrjticWhxaxl/EaIsAohg9cLaUsdILZyS9yv3Llg9YvfzZ6
	tF2P5dIhA/gf+I5mvugzHcgdcbS4a2FmerRd3VsQsBHc8B71EXRqF23zjTTtx9oFB3DDji
	Q0TdHXWKvccybtjj1nK6/DnP7Johkcg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+osxLoh40BKAExDHaAgHTnjFjsOBXyAUQavRmbvZdM=;
	b=BgWl2oqc0dhgpl3C8+EmXYX99hG7nvhHNK965hCD8a9PMisTPQ+mdSADly32QB+RqHOm++
	ert/5VGuhwYK3HCCKn+qfbvsi/1QvwdudS+ONNq3Rn3FxPnZ1O0ZofXWGsxyvWMZTEMqAr
	KKuZAExcPsSoBgdHmIDC9CV7y0ZSMnM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mmCSykMY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 28F4643DD9;
	Mon, 16 Nov 2026 11:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3410E1F000C6;
	Mon, 16 Nov 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827188;
	bh=V+osxLoh40BKAExDHaAgHTnjFjsOBXyAUQavRmbvZdM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mmCSykMYbLbUMgfAzsTRriPXLKntVd5F4h0335Zci+KFp7/M6E26jCvFFmFm6/FOh
	 ZimtlOfuTCf0AKdMb7DArxCbNTGAd0e0/CO69vZW620lEXfAn1pqfCoje10jxhSc1J
	 cSFCUZF5FEkl71fXKb5wgdAjz1AWCWq6VhUkPeo06V02hbI/WxzaCyHgNvxkzI3sLo
	 2GdAQUK0Zyr6xa2Qe+qIUwF/i/vhwqVU6IgGnQbVzU/wiykqChN6i8GKS5TT8NvnN7
	 zLrxUiks7eYGPstb/dmbg814Xp6NJSPByht4od2BBPOlpnQ+JR68HmJS8oj1md4KvV
	 tKiRrZHSvNGsg==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:36 +0100
Subject: [PATCH RFC v3 03/44] target: fileio: check that the backing file
 supports ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-3-8cbbea1cf34f@kernel.org>
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
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1508; i=brauner@kernel.org;
 h=from:subject:message-id; bh=tSA3soIyhcve68q21MuFcaunaKBcO2eetu56IE80bMc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epzEXGTe+sJUZYufjwnje3Vtz4w3241//XLYb7Dlz
 clNJz9d7ShlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIxk9Ght6dlz/J/z+mfrBJ
 vHbFY9ZvJotOF860Pjt95QXHWeof7qkzMlxf+8bzxp25H/hkNDaErSk2OqtYfjKAI+ps4N2d1nc
 PbGMBAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-HE-Tag: 1794827188-416699
X-HE-Meta: U2FsdGVkX18TtWzivIVlgWdhEhcVPrzNlD4rkVH/kJQ6Ax5ny1JD65sdCM61xD9OX1A793KLEGxU2Z8+n29mBhggJz399d3kdoS7CuOy3ZuDLGpSwCrY8V3raPPwyu910eQrW5G4JbCG3hAYn0kD5pPwvVewWrQXwAye5YJoY5LxrAbsk8MJohGPZZNXsMpb7ZzEZt0JVH/dznL6qnQP4WxYJUjknrTSZHpd1Vy6sO7jgZXGdpJ8HUne9etxPz+Z43Zyyt2YjXjxdefTmsclQAk+pi2E78F/rVpaC0M9H/1t9HKYvuvnrEmxCy1qvNzNAGQbUFc0nOUZhDtkYNKoWcu+ZpXU9DLrcVX64GG6HsRrtZHBe0AmMht0JWP7zg2XemI3zPDu1mA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

With fd_async_io=1 the fileio backend calls ->read_iter() and
->write_iter() of the backing file directly. The synchronous path goes
through vfs_iter_read() and vfs_iter_write() which check for them but
the aio path doesn't. So a backing file without them calls a NULL
pointer on its first I/O.

Refuse such files when configuring the device. On the synchronous path
every read or write that needed the missing method failed with EINVAL
anyway.

Fixes: 769031c92c8b ("scsi: target: target/file: Add support of direct and async I/O")
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ab9824a4852f1..a5391e57e9aa5 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -144,6 +144,14 @@ static int fd_configure_device(struct se_device *dev)
 		goto fail;
 	}
 	fd_dev->fd_file = file;
+
+	if (!file->f_op->read_iter || !file->f_op->write_iter) {
+		pr_err("FILEIO: %s lacks ->read_iter or ->write_iter\n",
+		       fd_dev->fd_dev_name);
+		ret = -EINVAL;
+		goto fail;
+	}
+
 	/*
 	 * If using a block backend with this struct file, we extract
 	 * fd_dev->fd_[block,dev]_size from struct block_device.

-- 
2.53.0


