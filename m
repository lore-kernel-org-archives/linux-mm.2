Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 642C4606D28A
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GlyL6zOy
Received: by kanga.kvack.org (Postfix)
	id 6A7886B05F0; Sat, 14 Nov 2026 08:09:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F016B05F1; Sat, 14 Nov 2026 08:09:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56E5D6B05F2; Sat, 14 Nov 2026 08:09:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2F86E6B05F0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:51 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90729C03F8
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:50 +0000 (UTC)
X-FDA: 85433756940.03.60EB449
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id BB42B140010
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlyL6zOy;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661788;
	b=wxSI8Qa2+61/YbJrxHVM2VspQ8RX1CV2rkL+YMsN60x9hUGzJBqTG0fQ5OUD8UQzBw/UCS
	BtummITOzHLtXVXZ9hH29yaGY0SSl8ukrM9pcA5hpmKtuvbnimTXSPkC8mNSvnk5QZ+QVI
	w6Zb0yJs/yttCbX6TcXzofgKuZD3TN8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GlyL6zOy;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TzlH4lJ7ZSZIblRm06H21pfwXJAWDZmkD7RxeUrwAwo=;
	b=jXNLb8hm7IXTA5U8vXMnxIXFqu2fDNLiwPIGiLTPJCn5ReJ1RfbgVXGkqEsbbcPeXX3uos
	kNS2h+B81MEqSME5ydEuOjHvZvhDsvPFabghknvKt3WJOp6I/0VzgpXGt3ENqStbADgWCT
	7lxssIav1CjYHUTl1Yn6qkJ6+ocvUtM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A060465D8;
	Sat, 14 Nov 2026 13:09:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF37C1F000C5;
	Sat, 14 Nov 2026 13:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661788;
	bh=TzlH4lJ7ZSZIblRm06H21pfwXJAWDZmkD7RxeUrwAwo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GlyL6zOy3U34aQUy3eHEQO1vIyJXeAiTdOGtABLlkjbMnvKHjyhKDScl3Hk7rbn/i
	 bUN/hnUMxKho/1WWAiF8JiculAXTejCCuJ3FonfhnSNp937ufCy4qoRmfbGVvZHsH7
	 9rlf5d2C3SdZVqBTg4J8yIIUsxC5D98LB2FsGhf59wAx6+iIV/zNQO/IKTaGaMPHTI
	 VX46CiB8pXPS+hXzwpsFz2BDETD3xysRH8Rj/RJaz/eTFDnVWydJvu5JEiwzj8rnWQ
	 EWDXUNsiasluJEgOXK7yZCzr+ogHhW+EDBwb4kKVBL61Tujac2yGBy06BywSGLd7Mo
	 Pny//KWEyQopg==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:17 +0100
Subject: [PATCH RFC v2 36/42] nvmet: refuse files on pseudo filesystems as
 namespace backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-36-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1428; i=brauner@kernel.org;
 h=from:subject:message-id; bh=T+p95LnTvG69fzj91gxDjYpoYRzamfjNk16RgT8U7v8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOn/sX7W5ofcrzdtZCmXtdsrsyZy06+ylnkxnetWq
 G9bLL97VkcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBElN4x/E+qPMN83LkkV8+9
 6emz+TtUM58mNc28vP//+pR517bGGTYz/NOw1Z5h9eBm2/zf+wUFPT6nLXtx+IKQe7yGYPaa6P/
 27ZwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BB42B140010
X-Stat-Signature: 3c1ekixajt3za48hycokshbwuzc5uunh
X-Rspam-User: 
X-HE-Tag: 1794661788-531956
X-HE-Meta: U2FsdGVkX1/eBhYZ/Qr1w8VC9TAsDOdhz7ofJzmE2BxTXIGJUV8hyNxzaLGkakOKoBJxMaNPFaJVqdSa6Dq5snHVU37b4BPcAYRa7AZcy8Dz7H5JiY8hPeubNxyt5af0tVwTxdaXFXJxE6PtJR+Jf0782EdMdubIFaRRupELPs6b46Le2wyiQnj0m1vbcRpmd41yhubx9qL3orFMB+djNSpFhYckRxTQi/ZYPJsK0Tx6PBQIEq7oydp4L3/rkF/EqxDZR/4gaaDAcSC590l1PN/92LVZEUP8RGoCZLHVUCPq2900D0O2G+OMzc2H2Z5r7FeTvcctj508STwiVHzfQvGD1hB6LK6VFkR2uaBx+/xRufXsDYZM9E/K3h6oFWlK5E0/BHXdo4YYwoub0NVlo4WNDkWp96d/En6ZO+RS/xmrq1OLn+hQNY8KCQt0vv2rqYXNCF25MLDWfLXTF8L2MxC7U0Ur+LmahcW3BkkKI3S8Ip55eeUS0l5zkxd+B+Ay4OQzKYtam/clTFAYACJsW5ZgUYIpoLUb2AEXABHKKk8PTksxZl7yHcROJ1VgBFSQwwcJD7X1S+oq91/5kzR6mCvUSdqc+4zAeJSQt0NrUCTgngMlXE5CAzmBJUCV2Db6RhCo8vu1iHrCo1EpVx3a4BMy4F8OaBbiKPMkGI++WPLc76kz6FB0tyl0ZamJ2WHJmHxvS8FK3RZk9MThe0fb6L7hrzrOKvx9DDaiZ+EeWlvSFmz0hO6cDOce9J6fVzgMhQBaBRJvN4diO8AJaVDZhd5h7r0Qi0TCzpWh30d3pyu7NGUxBMvX5TDLXmuF/gXHJPQZatySTUZWsmFAgyezaGU1HUBoFq5cYgE642dvlyjqex0s3r8dUfR3RzVuk7NlzGrVDGVzNHoHISw/xwZTRNY3FJxsx3ioDoD+oSRQiHK1aYNjbtYLTloxfW6cYgpzd/X7dqa5lU7C1I8pGNn
 SVzJ6mSk
 DhEw/lYVo05mR2GBYxjbu7GHNqizK00PLp6GagdzBuSRkDi5E2V6owdBaKGE6k1hrnGjG8L7rgU6b9ZbfAPhkyjYxDIzUyqIbS8lSWcTQXYXIGwdx0/4JTUuDzC6GlXIRg0tKej6sGcrHkIiiL6IBfgtd82U8xkpcRJ51BWDnTi5fds6cJhnEZekG0MMiOJXfFsRlRO8ufIcDyHEYgN1ihbwuwDqH0FNFScBBWFqr9viYP2OAfrYRmsKRQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The file backend takes any file that can be opened for reading and
writing. With buffered_io=1 that includes files on procfs or sysfs which
then get read and written by a kernel worker on behalf of the host.
Refuse files on pseudo filesystems just like loop does by switching to
file_check_backing().

Note that the helper only accepts regular files and block devices. A
block device ends up in the file backend when buffered_io is set. But
so far the file backend also took anything else with ->read_iter() and
->write_iter() such as character devices and FIFOs. The size of the
namespace is the size of the inode which is zero for all of them. So
such a namespace was unusable anyway. Refuse them.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/nvme/target/io-cmd-file.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/io-cmd-file.c b/drivers/nvme/target/io-cmd-file.c
index dfa8aa46188c8..2249ad3bb46d8 100644
--- a/drivers/nvme/target/io-cmd-file.c
+++ b/drivers/nvme/target/io-cmd-file.c
@@ -47,10 +47,9 @@ int nvmet_file_ns_enable(struct nvmet_ns *ns)
 		return ret;
 	}
 
-	if (!ns->file->f_op->read_iter || !ns->file->f_op->write_iter) {
-		ret = -EINVAL;
+	ret = file_check_backing(ns->file, FMODE_READ | FMODE_WRITE, S_IFBLK);
+	if (ret)
 		goto err;
-	}
 
 	nvmet_file_ns_revalidate(ns);
 

-- 
2.53.0


