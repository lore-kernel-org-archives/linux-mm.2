Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10833606A891
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C7+P4qkl
Received: by kanga.kvack.org (Postfix)
	id 17B3A6B05E2; Mon, 16 Nov 2026 06:07:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1528B6B05E3; Mon, 16 Nov 2026 06:07:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F846B05E4; Mon, 16 Nov 2026 06:07:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8DA06B05E2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:07:15 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74AFC1A0904
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:15 +0000 (UTC)
X-FDA: 85440705630.19.FD1B165
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83242140008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:07:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7+P4qkl;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jRCDiiiipC02o6v9Jxb1vAxzrNeQQVIjxwNCfj8X/R4=;
	b=P95VcQVOa5mzpvIO2/qesu9mOrxe5sEpy8BHW9wjeIcfpeOSWg29LbOYru6oxEfJQw7nN0
	UuT4Ly7t58XF0NRSMMe/wZ4SizYzMh7fAw18r1xF40zFG6MYyRyY9D1o7sjy1Ee2q+cC5E
	QsRmEnKIKj6M/OUXdVqLpU+/O/F320Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827233;
	b=N9B6eRNb9XS/cQL3rJYgSK3D3oIzU9GVPh+SaOUc9e4ky+hR0qyvbKLxjX+8Jxjjqwjf9C
	o8zMM+TIL3roZe3Y/vIExIE/dIjb5aHx0waFrQxEZW4Z4ZEgOOKNr1uflvid5VDJKB4t4W
	2/JtS58wbzexN9woCwiXX6kODDEJ52Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C7+P4qkl;
	spf=pass (imf26.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D61FD462CF;
	Mon, 16 Nov 2026 11:07:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B01F000C6;
	Mon, 16 Nov 2026 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827232;
	bh=jRCDiiiipC02o6v9Jxb1vAxzrNeQQVIjxwNCfj8X/R4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C7+P4qklM2cUtF+D6jKlp4LfRoTf/rU+rRx75wWnpOAGzkO6UhrgQhaB00OBirsz8
	 MACnRyQXR/eVZcJt26EgPAg08QL9RP3fqjgBujz8JgGTsdAq6s9jMDLu5UM1Mt75r+
	 rU31WaAbrxRj4Q6ApcXpA6RdFQWcxEa3jvCp1wjijmBnSknbaFrMtAulRG9Ru5GQZF
	 zR8Eq93DBcHOnp3DGufxmLYRE35gtF+ApgQEwhLP7zupv0zg/x25pZIqY3aeu/K+PA
	 FAWFK2afKgUVLhRHvl9IPfvP5yS5WVqmWxxUWW4EL7jJPW1i1AwQf4WL12FyR6NIWv
	 BlkzcsPlba1iA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:04:42 +0100
Subject: [PATCH RFC v3 09/44] bpf: use fc_init_pseudo() for bpffs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-9-8cbbea1cf34f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1354; i=brauner@kernel.org;
 h=from:subject:message-id; bh=3qR9ut2IuMeJZP39d8v3qoh7r3hSncJsbQL0FQDP6f8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9epypt//Aqrfefw+skXjp+v5VSGefzSdhLhmdSaf2p
 RREVxys7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI23qGf6qa+8+wTP/FfLRk
 17ow1WvfmN8+j+TVqpx9LrukSWfVm2eMDO8aK5/8V8pb+3RdTPOv41Fr5txetXRVRqfdE7V537M
 nGbAAAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 83242140008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: camaqgjexhj159t95g3fqkpnb7pr1gbs
X-Rspam-User: 
X-HE-Tag: 1794827233-948761
X-HE-Meta: U2FsdGVkX1/q+kQRzfb6r+F42L3vDh9/LjVsETAeliJ2j31h/XI9Kz7/i1YrXo+eUn2Wp1cKwFHB4WCvzpnGlRp8d3dlrcXfTIr8uExXNFW0gtOzLQU4auLxKti7oQ1EdSmp2xKYmHgxHffhEQw3uz1H4wDK34KdcV0Nrc0Q7LUaOeLCSoJXEXo3EcHf67lV0EjmT7AfaS+uGiQBYUJltvM6eVKjiDb9G7N3V07hsuoRS6R87wUux0+dgioVTLqVOP28oxdt57N7Em1O9k1At1jCuKbsULN0m343erj9I11SG1Acb8VLdRtZ+dmXNdEu1kksFfD7p3IDE9NHl7n25DwWGcUNaruIVui2kGUwZ9cBpxiHo0Ko9GhiJsq77JH306vfIgROyQLG/Lh9VuCZzppubhZD1ozKKsBTw8Gt3aYu47bD9quWk5sjFXsi7ZksH8C8/y0Gx9tI2mn0ioCoFheBfhXlKsjXfuwWS6f3F8qaIVuYGShfWTVVz6pUdmHqCi+pbWMMQUXDE4B7WLeOT9Y1zliSAnOMhMoP/LqHSb4wIgRUeB8Z+khUWBDjlfLPg81agBFzCFKhckxTM/qMnEwHAsu4dD78ViyA1mu6TWb8k0tHnn6D/PnBV0NUcAkop8ntGY4ubzx/eA39r8sre4yXGJ6/drpAcPJkTFZkrSCFI7cXwINyTPzTvf9AI5EjmM1Vgrk93YgXeW+xXPyU5yTDTqsFE9g4/9j9avowEIOihTk60hR61nWe+FG+BCHFsy1CPibNXch8KwNx+KwoH88QobSJBnAly/b54+cGAscvzK+ebGW+m16KKCh56TclMowZWKQv2iCCgdbnvaA8e0SX4UmiYN9sFlXMemkr2QSSu1cXT8cGuhO0EnqQea8DY67upInpGqV5kjqqdAIxEZ7x2YqB7nCF/XPvz2uMA00BpiYg0XQr+0zcpTeaa2BFKiPuXnl1I6L21pq3Ubn
 VrHWo3Ti
 38zYHx7RQOS1nTGlQmYDrmU8kd5SIsbbrw4NhmMpoL+p5XdQ7KB+6i1lDMFlihgE2CI/eagQOuMzohMsIhN0Wfqd4mQztFrLfEhTOSqjK1LYlR6rLKqmNgpIXSTcmFW0SKKSvoAaNXLVBHxMPKQXBJuB9MrmEq6oljLSf1V+51xYXN3FjzVbB+6a8uWvQiUa+B2bWiKp8VUMkOPphJmV6zZYE/l5iKaFlWs6C8vOK1crU3F8Kicrkf7f5IzzFc0MFDiylK3Vb8WPmG4Y36ZT/z6u4qwvlLoIMrhdaZoT12V43ZlZdaaURjSFtAcj6Bh8hbIVx2mkg4Gzt4z8fukOH43lzdFRGxsBjaBHE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize bpffs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/bpf/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index c6f328e4752e1..57cf3775c0766 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -15,6 +15,7 @@
 #include <linux/namei.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kdev_t.h>
 #include <linux/filter.h>
@@ -1197,8 +1198,6 @@ static int bpf_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_magic = BPF_FS_MAGIC;
 	sb->s_op = &bpf_super_ops;
 	sb->s_xattr = bpf_fs_xattr_handlers;
-	sb->s_iflags |= SB_I_NOEXEC;
-	sb->s_iflags |= SB_I_NODEV;
 	sb->s_time_gran = 1;
 
 	inode = bpf_get_inode(sb, NULL, S_IFDIR | 0777);
@@ -1261,6 +1260,7 @@ static int bpf_init_fs_context(struct fs_context *fc)
 	opts->delegate_attachs = 0;
 
 	fc->s_fs_info = opts;
+	fc_init_pseudo(fc);
 	fc->ops = &bpf_context_ops;
 	return 0;
 }

-- 
2.53.0


