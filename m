Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A830F60A2620
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=acdAWRI/
Received: by kanga.kvack.org (Postfix)
	id AACA76B05B7; Tue, 10 Nov 2026 04:16:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D0E6B05B8; Tue, 10 Nov 2026 04:16:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925306B05B9; Tue, 10 Nov 2026 04:16:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68A626B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:16:21 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E4630804CD
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:20 +0000 (UTC)
X-FDA: 85418653320.25.0D7B849
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2802320002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="acdAWRI/";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gz0dTGlDVhd9jZuYoUkGX2lhrZ2264KU/6i6/t2s/qo=;
	b=J9iG1RUfjvPeNt4KXu1YvLDDwr79zW4BZ59SG9I80MgzTE1gXSpFmyWf+FzZp7JZHAiC7U
	sP6ESrCUVoYeGkGUsAHzzIRVbPPrX5bH2C3lpmxSpVVhvKQmhyoG1ScyMHGHFKLjmrAfbN
	vB/NaAVHns28LMH+EknsNu0f8719gTc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302179;
	b=b3NLxTauEU/vfUdutIK/olVCsgrSaA78YrI419j79MpCT+p6PChZynCvM5J/8/oQIII6cN
	z5UApU3yYw+J9FouKwptm9cdT12tLi72dq3lmytYY2fe4TzNTNTZPXwqAPHVKAScuz6bMO
	NnHPZ/TchmPBcdiIpPHdrJSpyOX15t4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="acdAWRI/";
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 733C845A20;
	Tue, 10 Nov 2026 09:16:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C141F008A1;
	Tue, 10 Nov 2026 09:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302178;
	bh=Gz0dTGlDVhd9jZuYoUkGX2lhrZ2264KU/6i6/t2s/qo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=acdAWRI/NWQPeclSOSX1wx7aC0LKlluyS9cBSHJE3wkVd14QHiIc1fpuayPl5zd9i
	 5PlhWZ8zSjOW5F7hXCq+D2EWuxi2Yrz1KJQlfH1Ws82ExeUkKbKfMFv5OMJs6qDQtI
	 ivCs99Ag2xwlyttYhxW0mBoIpqSeDBKB/Xe0M7/566QfleEO1qmr3PSFpcBtLu8M6e
	 5uWOAFdagIG3gFGLfEvUEG0K5TUu2qe/wFq2GlzIwzmGbP9NF8Xz91S/ezjMWkYxIR
	 Zb5P2oATbJq5OI9cQHCzsF+MUW36ITw3fxTIvJMhFJgrnQP7+jVDlJirwJqu0ZS1tv
	 BoiZzSLVXO0sA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:19 +0100
Subject: [PATCH RFC 03/41] target: fileio: check that the backing file
 supports ->{read,write}_iter
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-3-4c998976c6c7@kernel.org>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
In-Reply-To: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1375; i=brauner@kernel.org;
 h=from:subject:message-id; bh=g97QydFuuV3EqmGP6aEJJCN8xS9I93EqcEv7IXzLvEc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9ejDdONKlhY2V6c704xvOGr9csfDBT5O8DNkZzTyrW
 b98EX/9taOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAi/p2MDOcnH/48I1xZ3H7D
 LsGX5rOm8IRo3DUzvJispdniOMP59DKGP3xBbsX6KZxq27yLJyS8Ft2xaLrf8V2fbigcXhGYuPX
 dSW4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam06
X-Stat-Signature: hgt8thkc9gq6fu5z488eqg4cg3c9ptfn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2802320002
X-Rspam-User: 
X-HE-Tag: 1794302178-587814
X-HE-Meta: U2FsdGVkX19oWpNkFJ42/9rzRTtOj5Fpzux2951sWgcg/05B0q7SyBHO67SNwXDpD+zGnyxMC30eA73wCjEa+kH5ABDCfOjvd1p30j8thsxIRga2og0bRjxLLs50LXHjRWaVx8QFuCq/2j4zjF22MueYVYSCMQYAuRzjCy0tD723ydqF597IVS2EUll8/TllMYQcjApg8CgOI8PRPXsqOdEm1nvdtacK4HhDx73jzdp0mTtp/YyqDnnHi7TJE2+BekeFLCkTTHzzavgR7gb19pn0oaSzsjZ3+4QfNOh/YK3+b+ZpywvZRSXMxr7P3oGpCgOXUGd+TDFrF4OSZSlBrXUJ+7X9j/AruXEcD6O6mBO6kvLCrIH9moMJK4iBAtvtpBGx2wjyAyPzIcxhwzTWteUkXZcbGZpV89TxF26xmA4cH3vTwj90odSFQv8ks5nBFFyuxQGvtddFswe6GfcBoRBoDU7XFy4sQLCc/04/HYjD+SV3G599yYyVm+L9Z2xZ1WD1/tudVIJ3uCTqX4vkgw7DAXcN/zT7dai/vOHeJF8eX3+HuQrSn0H8g+faCzVJzIe7//P5zozrhx/r1rXCGIzQHj20Xcc2RWvvKTnmioorlkzur36muupFuP6Zsea2xtjteRcdeMxspYMSShE/ZP/9hpufeEY/AlxgMXd8tdbzm4JK3JIGocuukelcebCC2SGlUUB3AVt2dmwl/HWz09jxkEzkCjPHWFAUcylav0f+FKiWgfJygzfNjR1j/0HlPyUZUKPKYmEih56DYzImGutao6tm18KEcYG9OXiQ7RrcRzXa09lNbLI3p2oySLnIdCHehBXMsJsP9LpAcSCRPAY4KurWl0G+97beE0lU/RtKNkszimkJ2ghT46CZ/fh4mqVjWozpEvmQEmPq0xzPQ80o+J6MIa7F126TARMvv1iszj2PiQJbwKmESIJzxGKcBvgzIofgVTSRMb7bcGB
 NR+iQ0qi
 nozDefbAEQrkwecMvwyiIphidey7nM10xEg2TRIRAKhkqCXJnfIHt6d2KYQjzDQ7Lt4yThAw5gV7amumNomMnq1LpU9/991ptn9FT22ZqqhL9+JaIzQ4SKO8W6E8O4fk7iBaM1AJ3Lkt5UbUuQT3RfJqz+Kt9XnOirS0Fa2+syRrhvhsxSofGjl+J1kSFgoOPY6DugvuZPL3SzTtpaBnbZHMKuTzdpKJxvZlM4b4+jrD79Dg0RXLm7zCT2W8YdcL4oJEHl3nrxeLO/wsxQ/BWG/bW9YHIGYvQwRpPaK9M1//GDOc=
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
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/target/target_core_file.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index ab9824a4852f..a5391e57e9aa 100644
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


