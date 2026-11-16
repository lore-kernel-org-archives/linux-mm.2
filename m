Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 826A1606AB6A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=a0UaCeV2
Received: by kanga.kvack.org (Postfix)
	id 9BB6E6B05B1; Mon, 16 Nov 2026 06:08:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944D76B05FA; Mon, 16 Nov 2026 06:08:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8337C6B05FB; Mon, 16 Nov 2026 06:08:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA826B05B1
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:08:53 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF41AA05E6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:52 +0000 (UTC)
X-FDA: 85440709704.19.64B79A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3886C4000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:08:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0UaCeV2;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827331;
	b=LfAJ/6Us/HvO5bLvEA3wuTRcoewg2m+Xcnr9neHbt6gZeni3Yf1iGGKjlmbk2AXfxyFU5h
	56FpmNObiMGyr0vPz3SX6u0irezpSnnx8znqGmSYotw1lFTvUD+q0LvK1+yg+wm4Ul0jjP
	O9LgzgEWU/o2P+6RDD/pnh3Y4+B+Co4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a0UaCeV2;
	spf=pass (imf12.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgbqG9Caw/hRTAbhKcrEqjiiAiXfjhN0P7+uUEzG5mo=;
	b=FKdC0ipL8rOrGUfDidrNyXd6L/1EUw4drTY0PjyXZjLBDKfQieDE8DZyEfsO/HcRjEGlEo
	5YOgp25hyixnknx+tbs5CsdaxzOlXng3j1Yv0wYLj36vxRRRZsFU23YEguQ1Bq/o0yjib9
	F+YBgufuQXGn6WpShw/lgcsD0huF0V0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 824CA408B9;
	Mon, 16 Nov 2026 11:08:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 768641F000C5;
	Mon, 16 Nov 2026 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827330;
	bh=KgbqG9Caw/hRTAbhKcrEqjiiAiXfjhN0P7+uUEzG5mo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a0UaCeV2WV+QFgrwTGF9+hKqhdNQa9dgGmQSp/rRjo/bQXyy72SriaLw6dWnEcymV
	 8DP21DNooZ/yHbfrIGqsgMkSLRPQyEkzc0OzcnwWFeuA4kk3ur891oAbusm+Y5TqgI
	 A9UKuEQLGl22KaXB9J3QM0jgvZ6QZyEhJ1LX5mgmJK+zWSZanNlhUpMAk94F0KldS3
	 ZAEOkyjJa37fqTHwFK10oUMUYuBTYBoT8ldVJlKKulVTVEcQ6KH6VUczbJeY4+jyMO
	 SGxWgT7t/Kx8U0Zx7i/0tMnR4OehS/kQiPQrAND2KNfoR/OUuKG2pj8/dQzNF6kliw
	 coFLuVxRgzfuA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:55 +0100
Subject: [PATCH RFC v3 22/44] sunrpc: use fc_init_pseudo() for rpc_pipefs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-22-8cbbea1cf34f@kernel.org>
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
 Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1040; i=brauner@kernel.org;
 h=from:subject:message-id; bh=MpmJ+CmuhOGqFr/rEz4RCZnO8Dm+lCmdYI7UNn+2hFA=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9elwRn1592q8/9Ebu9EUG4e+0Z+x4JNaS4GRWxbRWa
 I/o/GkXO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACZy8hfDbzaJKycFfq3aMa+A
 /w/npnojOb4g9kWmP5bcj73ysOj+316GPxwVXDnXi12WCXs1r75bJrnrxYX8JK+ld+pbrvadl9F
 W5wMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3886C4000B
X-Stat-Signature: pbapnkcsq7jmtwrpja4oc8bosp7j4kck
X-Rspam-User: 
X-HE-Tag: 1794827331-250785
X-HE-Meta: U2FsdGVkX189Sp9SG5xisFSh6bd+YVxnx0R9a7yGr+IWycjRWH6P4XReYGu5mBzdlmxWAkE0JM6AkZX+5WVfaze7bXGyI8sU8EYCWT0S9uzXSk2Mp7oImXOM0uRYZgjD+vt/MqKqxakh2Vd+TRzz9vZfigxOVu+CXClQLOGl4fCPQ6dSlQ3TG9O2Sst5kOkOwyEDCbw/s3MX+01D3cxBFtb4i2jwdYy0hKn3eMg/KZgUEmIJx7fYcxdK/tsCTs1ZgoAPV0S6oojrwE17OFGswAKV1dfwftAQyg7M/9NWFMgJByUq+bPtXLeqV4sogPpIuQRnbWxgZoWYLNuzTKiMBkLZQe9RlBwvqzs4ugIWPYJLbRD57cm80qqa3vXC180frSnlSiMCKBnw4wTEhAYiJqCYzB5bUrOK/j6gliVe57uAwXZkxaoXL8HiUOpFg9MDjUiib+cPOra+0smcrjpKkI4htsxwTk78jQXL/87OBnb49fL9yIpv83Uf2w7aEgIds/kSDxRlBRczKGip+QxV6/umsykW/cFHqZ7hUyxx8WA3asNXTq8Lfzij9dP4Es0C4WL/5H7/QN5XrwloB+g0/aJZv2PpWQFPgTGYh5kDyLICjHnAjp9vktb1zhvbrCLgWM5aG8yGcOJ1t5G2dz3HXn6jK1u/AYdSOh04FadOoBX6ckBjn8Ujue+DE3mSvu+wEsHqGb0SzcvfJvX1WZP2EsaeSy4lMIBHOY02d4FHXaCZEWKV6AHwAnM3lkkWS8F55wE+jmthCJF71/uUOXwnm+s1kVbp2t6YW2FLcfYtcX4UQKDJ2lpnhTc6alY7c0M6FBVIhfja6KGXBk0bMb+t81UidHsA2FLRAGmSaAOoRqYzvhWA/SGSMYYWWLeKIXFrNHB7LNy+DYLoql1nNg5oBZeD7SnXBld5PWbvlsZqHywyMDYE63s9BEC1tKEwRCfHs32X+UeLqc9Bc0iE4jD
 K9ZpGl7h
 NXPf/7+0G2qNvZAZMygFfR8CODFB5s9+mpNNcB/Bj5Y3WpUmrPEuighGyaQhRPCZ+TEm3EB6qNBXPBVbOeU5I0xE/MaSlTzPO3QsPfBm3bPJG9INiWIFFApd+GSL4ZJa09dihhVDMI0kGGoE7GbrlMt8qtU3YruO7cy/COOA0K8NdIn54+GmdVkpWy0Knil7Gi/CleQ0j6n3vyeNp//RMrub4HTNMlKatuytPUHe5BPHxU1wW15PtsSzcObcNcE3I3pTz0JnvrgoWwKFzG7h+B2ONP9jpFYg9/doLNUMH7NqhcxeqjNSQZk0KSvWgw/V23btp8oTHPyv0SU7DU9MnOkMSLEIOuqTEO+G2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize rpc_pipefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. rpc_pipefs never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 net/sunrpc/rpc_pipe.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sunrpc/rpc_pipe.c b/net/sunrpc/rpc_pipe.c
index 9d349cfbc4831..37277a6d24156 100644
--- a/net/sunrpc/rpc_pipe.c
+++ b/net/sunrpc/rpc_pipe.c
@@ -15,6 +15,7 @@
 #include <linux/pagemap.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/fsnotify.h>
 #include <linux/kernel.h>
@@ -1181,6 +1182,7 @@ static int rpc_init_fs_context(struct fs_context *fc)
 {
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(fc->net_ns->user_ns);
+	fc_init_pseudo(fc);
 	fc->ops = &rpc_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


