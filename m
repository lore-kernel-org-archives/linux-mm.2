Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECA29607501F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DuW47WKH
Received: by kanga.kvack.org (Postfix)
	id 189D76B05DB; Tue, 10 Nov 2026 04:18:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160DE6B05DC; Tue, 10 Nov 2026 04:18:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 077A66B05DD; Tue, 10 Nov 2026 04:18:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB17A6B05DB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:18:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7AF1A1C212A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:44 +0000 (UTC)
X-FDA: 85418659368.15.F475EF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id C6AF81C0009
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:18:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuW47WKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302322;
	b=bs5R3ZvWk1e/5XPYIXFn1OkXiFFwjFrDzlqi61UnT5gVKyCI174UNGSLxXiuLu5WDItPia
	h4wkGXro+7hvafKZBll4iQVW5QhuaFUhAQPwxfM3/o0mY4cbzXeqB88Hfd3wzXGpm+mUhh
	zLAwy8sh9LOyGqWkv5CYOL3JFEksKE0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uO5ZhnwfrBSeMm3rjJlHHLu0PoUagP/7+NgvInBYUDY=;
	b=nOHE6uN4gyfEnr5RLPM3B2StRVIPqVrTPZGmqjLWnQQei5/b9fIQyDulfL1pdH8HVW5Z9/
	JSGjWZBfPsnqa6Yao3UWISQGYUgEyS3UBLBmAr90OQ9nN09OSFdtcm0W5jX8UjR4C+yHlU
	JEpLIjEgEMty+2uuH90Fu4a5wzYhQ30=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DuW47WKH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3D354135B;
	Tue, 10 Nov 2026 09:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751691F008A5;
	Tue, 10 Nov 2026 09:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302321;
	bh=uO5ZhnwfrBSeMm3rjJlHHLu0PoUagP/7+NgvInBYUDY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DuW47WKH0NVzTMh/ahwIWKCilxMxR/d9WzG6ER2dp1mTlW6J1MydE1ZvojfSEZmpM
	 uq0lOj+04qYr2LzZD3LTyEm/+Q92gXEaWwvE/iC7G1ulkggahwu88Ns7v4dd7rnO1G
	 naiygZWzOW8Ejr8jN4j4xWgI+lP7+fWJ/2fBG3q7EDC++MqGUBA1hoyiSEnV+fZYuw
	 hy1tvAOwTNHmlUDoF9ANy8eJuZMUnkycIQm0mbN+PVarFn8O73zcdijbpCI2OxpOxD
	 vHWGX2o5WnjZZ/WfXN04GoN3Kndnr2IYwMYmuMbejP3d/XSHugkw6zesVSwCCkxyfH
	 te+Gj4JjZD/Gw==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:40 +0100
Subject: [PATCH RFC 24/41] efivarfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-24-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=brauner@kernel.org;
 h=from:subject:message-id; bh=RLuH3jkZQnaQmTSPi6KhFuQtT0Hgw2AWtcSWTkbVq0M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9erDe5Gh9x1THa+rmx4Rlvmxo+ui4+yFfq7/v4xonh
 odTCnlVO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYiNoPhv8tvZb6ttrc2vz+u
 s+BZwas9Hb/lZN55FfU3872JMM9paGFkmF2qMIfj7/yA36ELzpv87npr17nsS9Y0JvUP+ZZnWlY
 l8gIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: C6AF81C0009
X-Rspamd-Server: rspam12
X-Stat-Signature: b9gmx7jsui8iyspdrmq31gk8a77emq4a
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302322-657028
X-HE-Meta: U2FsdGVkX18xaUrbQXrrJuJdKCmSJkQd8DxRGh2NTHPtP0hflJRYvdQeV1/dI6yEFhBFA+bsNV9qZwTfVvs6hzJGjXiggnRvWczQN+Hg6th2faTzt1+pp+YNB6r3S2hKirO5MyVC51XBETa8PH9PLnDB9sn21q672rAfBUmKvswELXe27hORoCH/iiq+tUzLXFR1Yvuglyv4rK7r8u0TEO5z/npG4tJ3bVrhMX5fXaq6C/FNcHjH91holQxJ0Ri17fGf1fuN27lTtU7o/zJLD9AX44pekjoXRPqIwh2wHfyrvf/1ZaQ+UmRNWhsM+3XtrY0iJfAsAo5pqFAqF4vOUELRQVfXDQeX7SGdT2en2gxlpKbhVFoWmpFZN+QBH0XzhD1Yzs7SjFpUgZfHyYmGAh3o0iUDrE/2MzA2LAAqoPkBUaq61Y3obWhS/cU9c7wTz9HLn/aGcoFnW8YlUIS4xKgnUY5drCSa+UYGb/utGdyGiujIi8pOB2QX4Ex5aGsekU3huCbL47Be+Qd//rYQZHS44r8XCq3vxhKi6X3XXiGdvvkcN/E21qSpHoysp1I6V6W004UcG3qw59Q3WTstuAnCpYht3JagqM8IcFQLg+Wk/GPHCXm7K8gFwR6d1sY/Mh1JIs1InnFEnVDRxCgl9uoWyn3pz+Kum7mCJ1VQY3fuCrks3ubDb/p7s0y2/hpuHVh3v/eukfT2kCtpq1mUdWfr6YT8OFLfRlzWgWWFVz9rFZ9EXtgfbrQeRFu+qvzPNZbzoj0ZG+zpGW+6DWVJXa4GzhEk1hNjYAKCbOQJXhLAVpwqv2JanXTxmcr9lP4CbrZbI4F5lyQnp3qF8deObH4c2TR/ohPGNA2hsTKhZbyL05VKCZZLJh7Cw/+dPr1/cXapW2ZWVouXTwR5nPWhng0v8xA3Z9Xfo8bn8GYjyVDwvi58zelydJsnsO6QIURplC45v3ZPxb92OEwCNrf
 tXUzmHAw
 nTSHwgAeluX5rAZaeaByNkK/TUtpurm9lkuMG52MerdfxZ4Z25ssrMQUDURF865b8wvvEtF21LxK0v0SnWF/vwenDH0mTSVpZnvx0H5OeElW5YqwWV5+XPnkqpyy6ldqWlXOqdesSPf49XBL/lW0W12qg1KvXQUfPR63cW7YpXZFbZTJ6LAMFRKAvV8sk6VGb4qhAOPOM6e6eqQgZIzz3aysg5EHOQ+SDipSojNp87uKezDIJHJzUk2HDbA+kHvXQum23LV7svNUBco4znhRh4qX5jyk/4uGG0PMJLm66KSKlry0fS4wBOdS8JpSUyuIv8vd6UtFlj76LqOxAyr8vQoHND8ly7rhJZ+1ckNdUsWDYn9ZWYB2nB/xeUPDjSvBdJavLZ26nIvJyESXi74L3+mgH5gy3nuPWp/KbiV2dBQKsUaAdLvI8lZ7OI/fviD/+vP/J2Nm5+rStbuCp8hvuY/pro7bj/cBa6gPE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize efivarfs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. efivarfs never holds executables or
device nodes.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/efivarfs/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 12746ced6dc6..e598d42c5f42 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -8,6 +8,7 @@
 #include <linux/efi.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/module.h>
 #include <linux/pagemap.h>
@@ -554,6 +555,7 @@ static int efivarfs_init_fs_context(struct fs_context *fc)
 	}
 
 	fc->s_fs_info = sfi;
+	fc_init_pseudo(fc);
 	fc->ops = &efivarfs_context_ops;
 
 	return 0;

-- 
2.53.0


