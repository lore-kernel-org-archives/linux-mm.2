Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F17EF6075C54
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S1xIy3Kr
Received: by kanga.kvack.org (Postfix)
	id 261386B05E7; Sat, 14 Nov 2026 08:09:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 238A66B05E8; Sat, 14 Nov 2026 08:09:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 127406B05E9; Sat, 14 Nov 2026 08:09:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E51AC6B05E7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:09:17 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87170403F9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:17 +0000 (UTC)
X-FDA: 85433755554.29.7959BE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C2BCB4000B
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:09:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1xIy3Kr;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wp6UiJ6JxspVcAI8vmdp5Pu91b6oGaOfKwkx6Df5sII=;
	b=wb2RQbGXhWwLLmRh1tAHT6RawMCxrHcpTjToLo7dLOWekxjf/BcPwtQ25DLgCQd2YMumk4
	VpUjZTiVc8SKbtz+PegiqEgsil2skD6LZjKCdR8yRuK6IRcHePU3DqqACOGBh/U7VNq7fG
	OQ5S4Q4K4HNqmLrzH793PNjjTBc6oPs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1xIy3Kr;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661755;
	b=0USx5uLbraN59ZFA6TDRFEmMj8kOUR6QucM+pTLvnTjpRIsztTa1vtR/QCkKpevXRvP27X
	RP+cE/Rsd+XTAfAN+8Mm5R8xoPU7Z7gWWIAec26gkttt2aqJi7ltO+rvKilMe8P1tZXdte
	s5IjwgbrvZvE7J9/GryOC6Q9hI2M26Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1150A44DE7;
	Sat, 14 Nov 2026 13:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6EAE1F000C6;
	Sat, 14 Nov 2026 13:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661755;
	bh=Wp6UiJ6JxspVcAI8vmdp5Pu91b6oGaOfKwkx6Df5sII=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=S1xIy3KriPdoEMTc9dfCxcd8nJZzA6/xLqEC9Ek691tlamme55qJphgP6kTqiLd8a
	 gyYuU7lALuiqsRc4AVPgbXVJK+NhDA4+7zujFjgM6QpBfN5IckM0YEqdbXktr/nw+h
	 Lnumd0/GdHt+C2cs+wHroPF9ZZbqkOvPvOycnwePXHaTKKv61dbwr0kOr8R12Yy/jy
	 TYX37go2jAbTDcgIHhVHfyn/x159FhwjUbvk3VQiFEIoyIL4VPg8k6GDEkPS6GbBRx
	 Ui3KnXYZa0I+MODr9/kXlFNPNu8LZjXuuuvEb5jTNLwqAqpbCB3xy60OP18fpqthQb
	 IPWYjaZ1+0aPw==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:12 +0100
Subject: [PATCH RFC v2 31/42] usb: gadget: f_fs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-31-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=957; i=brauner@kernel.org;
 h=from:subject:message-id; bh=FyQs9iBDL23rPU6G39Bge4Pz9tDFD7sQ36KmSfY2Fy4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iOks7Sk79l9iocNp1bT+iXKvo16xtz4Sff5U18j3x
 bKqSoVtHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNhm8PwT/HM2d+nJ4VPen1g
 xROh7Qu3d08LePFy7v6VZ58HB2m7M05hZPgQxrBA0Vj22KJ71q0c77YLbm9fvFXYWin18eItfPY
 MCcwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: tyxwe8837dizzzbbobco4a9cebfxxtu3
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C2BCB4000B
X-HE-Tag: 1794661755-975923
X-HE-Meta: U2FsdGVkX1/8SX4FlG0CD0wpGoUxoLGyW8AnXpTF+OcjQyaaYfzVLM7XJf0raHijHYU9JfvRPmBZOHdYIjHJ9L40+ns4dEpFKkpxbf6Z2AgLYGtzd4npZhNPkJAG6xv3iFNcEuiZhybEhgaOeJlg9+CKhtBAgTAORkbLpP4z+QpDdf+6K4xlZfvOu1Nl1ad+5lZ3bW8fphaGSoGEhJ7Em5lSLhqsHELF7y2WlFQbxydG1oHkxUyhASW61dr2k7uIMFCCN6RTuQVi9eqV7WxmVkcmhdv/nWP74Br4Dka72i1YITHXKoaZIynij+qGlpDCGzarbtba+fgwKYLgdhaRj5ihal3yql6oflLJ5vTo5CF2ZEhqXWuOPKFbPYZ2apP4DebTGK8tvXhK9uP09/rHOgr4LWK3PobO3mWQRkRyEKzYoaytAMOJjuEigiMvLLSBNPMWtO+EZXi6r/n4tOAfIYcrvdT+5qxOMDjxfzi67HZ72XOT435B90SaiZotWuw65u9wpTPySWX2AwGI2bNYdoy/CjoP0bXvMNgYpkpjhfG+zPfTFHtxIZ+PcLFheaWOz6Cz4Ek7vaOZ0cmBuyQUbr7hXhciDOHrJ8zQYJ7bWq2meYzIF30zfaZSyjfW9K4D7Xy8Tsx+x6593pu9IhvdCl672zaxCVImjsXrK+z1nvMcPwIzasJypag5KCzTj35EKrlPN8U/TOOIzRRK+Y6rz7YtSxOx37PCet64Qu67UNGYfHvNbxkY73BUxQBcjoVM9DorYFGZCmspU85r17FIHF8P2/DY3cfcv7EhxyYZ9WvI45bI5BZKUmpogPx7t2K42o0Fuu1jTpTpEXQV1oOaLafY3YCLrGksNP4p3DScU5kSWCva6UbeKtAN/ru8coCSJ7YUxH6Duys1P1cJ1tg8n9z44byjz+xgNRvnSqoAztnHEvmeWXsPtMd3yU5btMSQlm/Ikhc6sR7QTvBFzqW
 yw5e7naG
 690dxSmSMiPmIF8Z22fpkM+TkzIyvUKv8XrJQAVtpXFH1tBJfY/y9bI4I/zYtDm1sQ8iK475O+m/YaTom93hzbvgBfAh3EawBsvjf/qSkUsg8PV8LCSvRcLlS3Jz6FRWPH+T5OIlw2YwQKEzlwy/OsTbdJch1MIdzPy1nr17v+/MxWkveT2bM/HA/cbAl6+gPG/TeRb9sbU/VDNsHTztKDnoT8+GiWmV/Q2QE6nDikN/nvxzSbASwScnRhp736w3RlfG1yBMgDCFAs6zI9P/hm24lSA8/j8QC4CqDXZkCWIlS6eblJ0IGVymxlznxEWeInNEP1VuLZZetNUZgF/2FiVQFobhB7wqkBqB7iJqxg8z6bXzj3jDs7QbgvTE9ooAJc+b9n9ctRPOuoOGMhAvAUo1SEorr6A0YgEie26IsIXOGWExRQuMHJVOQoKACDzzF9VGZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize functionfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. functionfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index c64a268e98a43..a6b3788399a56 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -15,6 +15,7 @@
 /* #define VERBOSE_DEBUG */
 
 #include <linux/blkdev.h>
+#include <linux/pseudo_fs.h>
 #include <linux/dma-buf.h>
 #include <linux/dma-fence.h>
 #include <linux/dma-resv.h>
@@ -2166,6 +2167,7 @@ static int ffs_fs_init_fs_context(struct fs_context *fc)
 	ctx->no_disconnect = false;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &ffs_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


