Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 686F560A382F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MpJVcMTY
Received: by kanga.kvack.org (Postfix)
	id 875006B05B6; Sat, 14 Nov 2026 08:06:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8257B6B05B7; Sat, 14 Nov 2026 08:06:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED626B05B8; Sat, 14 Nov 2026 08:06:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DAD76B05B6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:02 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 428E31C3B3D
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:00 +0000 (UTC)
X-FDA: 85433747280.11.D63F3A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6885E140006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:05:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpJVcMTY;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r6ZhD6v1VAC9LFMiPIrPjYVjUm9OFEumnB2zMtz0O/0=;
	b=P0HtAmwLL2iK96CYcGEZKbA/QQYtnDDyQ/D1xgugTOQsCDeFsI1CUxIvlqytrezu/AGnZG
	kZxfpAFyNhc9l8UFQXy5YhOuxjcJGjm1caPqdkB1lR3YCscZDCDHYVLAjZAMxmq4gPMUtx
	gOLuFlGp2ArFkvtMxB8SimUvflE02qc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MpJVcMTY;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661558;
	b=xKdJEBCv7RHz1EGA4Oq0rBCgYVO69FG3eqR2WJ5WJy1rJ+sRh7kcCQmrZ+Krol1rVMww1A
	ZZ0b4c/sAJWgBOeHQSjOiPfrf81N5fkRtQrqMv2aF8rfO4msVP8kg0amhdpt5eK/fWReg3
	sZu80mSsxXjqtp+gSggs8ehlqLIOaWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BDA3240B44;
	Sat, 14 Nov 2026 13:05:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E051F000C9;
	Sat, 14 Nov 2026 13:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661557;
	bh=r6ZhD6v1VAC9LFMiPIrPjYVjUm9OFEumnB2zMtz0O/0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MpJVcMTYApPZc7VozOSSmaXGxWwwgxOxiDGjTzhesY26ZSs/xNhwwdDIDL0zR46b0
	 W24cPjHL9Gyz2tmsdI2SZ1yAOIBcFIhBnPjCrQg2xaMcZtEWnbfvhWfVUXxY1N/Y+1
	 x7BIMwdp4kJhjoQq27aXY340AMvCIq9P2DrFIOyfPVCPJ5xs9RWXl9JHBQYKOWuud8
	 wvITPU/pQjvqn+W9V89fmzuCuW4Cwhv2tpUp3HqbUNBmkJwQ0riUqK0zrXSlsQ65ZJ
	 l3Cj8QQbq5mCnD/EO8LJr58gJzqPZx/uTT9g4OZqsMUvqRomSCrCoZjw8Em01eokpW
	 /XnZdvsBfixeQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:44 +0100
Subject: [PATCH RFC v2 03/42] target: fileio: check that the backing file
 supports ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-3-98639a2286fb@kernel.org>
References: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
In-Reply-To: <20261114-work-loop-pseudo-v2-0-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1460; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+p5P27LAsW3o7uyqtxsmCGm9+GYqGVB9cSFLMBczGcU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMncq/F3Gqdfy3ml2pz6Cf16VQLrWpz9Pe6Ltv6/x
 ysXsqqio5SFQYyLQVZMkcWh3SRcbjlPxWajTA2YOaxMIEMYuDgFYCI7fzMyTDnBc2fvPj7dwBbt
 Y32T7r5v36qWePZ+2WHraW+0ZwvH32H4H/HwwN1Nz2oWldU/1cn9XNqxx+bkkusBpYfP2X5oK3x
 8nh0A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7tkrng8k1osctqr3tfhpms857jeademd
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6885E140006
X-HE-Tag: 1794661558-46748
X-HE-Meta: U2FsdGVkX19Wu7O4I5LoumwSpFWg0516d5G2nTWiQHm+M76dm5AQdHyPFN4jTNfaOHrQYrdHt6IdEQ8vi1+MRk5jE3Iesb9PefLlCZTt+eeDOu9ZjQZxGzs+rFlMi0E8qndZw+5/p/b9YzBB7YgifEweTacaZJAkEzyaINAhlswuqicqukEd2DgpS3ltz5KvIARZiqQ0OXdSZ6TLg0vhDB3BUSiYE7j2QvNsaFtfC4BJSSyAl8yxhd99hAGD4xcq42ykOjPMGW7VYQBw38EKDHoVSY7XnKzaD6Xds8H7ozT+beIq3vrKLW8jVUGUTvVeSld0MwNnycnWDnLlFu7qK9mmko0oKCgI4M5zEW1YGjIfCXmD+NL2ludUL0TILY9Xldyscp6+Uwi+flVreMNlAgioCpyPGC0ixCOEEoF2IUDDJNyU5t43Sj5YivzKETW0tFIyE36WbRTy/THIMnvtnTI9aiuoyZ+IeXklt6P0wgpZmCjD3MNtO8QcjXaqVf5BVRrF13LNVTrVLFEleprkfr2S+YgAKP4Q/51QJSvqdGFVUo2iZofuPY1fXxGg81pi1JxeKRlzd6LLPTlB6CdL9Xw7sCHvbdhACVmb9n9hUnH4CjbNy6Oudad8YErWhHtcL4s3BZ2sKFMK46w5Vyf/BlhKB+2XzpQuYNkgg7zChCfjsxoqF1mekQdaG0UwI7j3+0kNSJ3fNuasPQco+0/5y5y/kZHCTkGg7wPM/Dk3vXsV0db0QvCsq8OgOhBuO2NP0dwIZvq0q3ymYvqljDWmIYvkrXQlMk8FwVqg8yXjnCIJ1pmRZTvXrZxXsEC+A429g/NLOVd3lXc8n49OrS3JHFXV3x8Rhe6fI+GX2tdRdtEGUaodOxXwWoQzJbQaozYkE0+uJI7Jngen1opU5739KVwaroovbuHcZWlG1gzIgmhka82Hdi1/6PyjnZnpdg3ADULfA8ul70Se7CAqseJ
 rUG8Dp+I
 d2pK9ug99/MSE+uAzi/Bj3F+2iwHBgIjHvcKQBOjVDKWVvApD+4y91d2YWg1N1iXeiHzXQEVMUgFNQSlbe0cPqhD7qEZA7FIszyLrrZSGtVz1gQ4AXMvq4coAICJrJZqcPzzgV2I4lysbE9Rihlmt5pYNOXtIiRyf7f2tt2cZgc3u7WXZHr2gKTN7KYjJJzvi2bR63jtTxW6e6ckeKDmXx2Mb9yI3theLLkvlFJM/GsYXHJ199gmGWLi5oh3qzUbY5x6MZxy5FSUpTrb2feF4Z38jIqzMq0A0uylHI0RoEtwnoxJv3k+G0OvOFy8DL9ykgUKuWzZLTfwWR/FvGNyflB6mCNxjqhtq8/kbaGqMOkp5Ma7IOuH7vZKFR155L9GNOUIYMeF0wDZOKKuWg/YuF5eyF3551+0kZ5PU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
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


