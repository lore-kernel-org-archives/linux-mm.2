Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F00A606BA01
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NT+C8ZSk
Received: by kanga.kvack.org (Postfix)
	id 56BB56B05D4; Sat, 14 Nov 2026 08:08:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CF46B05D5; Sat, 14 Nov 2026 08:08:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C246B05D6; Sat, 14 Nov 2026 08:08:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219EB6B05D4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B60D1403F9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:14 +0000 (UTC)
X-FDA: 85433752908.02.9A4CC33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 05033100009
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NT+C8ZSk;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B+REGYiia6M8Fehy1eJYg2qJvRlaeD0xlyLGCXMkuNE=;
	b=KNEcpj0JyUN+ESHe32EIu8sPh+kkYyWN3PVX1ZvURj2RNaN4iuKk7SipEsXMBrqE1ih1ap
	479l8fhj7jYkyNRzgT2N5K0ZVKTRWk8ZmaEaAPTkSJ7OjpcamPLadLKpAyyHSjR5fRELHN
	HMi/Pb1KXNOJkyAdWqNwTe320CEIJPU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NT+C8ZSk;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661693;
	b=kv8UObsPP4mcElfh+uco9gAjKL6o0XzTSKhmJYP24Rn9EPeDoDf/utbZ8pHkCUDY5edP/w
	sLZ18OuborEqWi2GLfyynY7wA0S7JNLElAwvYFtjSYdOUo4vC3AaA/9PEnf//91cvI56zC
	1zbDO9qCbBQWSsTfRctQ7D+Cb+fH4/M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3033B4248F;
	Sat, 14 Nov 2026 13:08:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA771F000C6;
	Sat, 14 Nov 2026 13:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661692;
	bh=B+REGYiia6M8Fehy1eJYg2qJvRlaeD0xlyLGCXMkuNE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NT+C8ZSk21Aekq5VpPMLkN5lXE041tWb53E/PFyXaS8JnOZjtpnhN/IJ5tqRBCBZC
	 KbDWuq3IEQ7OtXMgE2LPkypVXS8WxlXMdHd2O7GYRa0mZLLaBUF9g7tJe1IuR9z/Tu
	 tpgNbPJ7ubYsE+wigZ6X/juKus/SI/ItMQcN8NWKa2MZFuLxGtDjcGrhIpixMheCao
	 YiLG/S/BH17O8QK6M3uLoFs/iFFdot437NsUY+7gBXIKoXeJXJDLpLDXP3MV3ZMPM5
	 FBITgDJULpAf7m6rj/Ojk/eIFB5uKGaQlYZTJdDB6wrEWsHVvT0rUR1LjVlBkf4syv
	 9ViLnD0DFgZ3w==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:03 +0100
Subject: [PATCH RFC v2 22/42] sunrpc: use fc_init_pseudo() for rpc_pipefs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-22-98639a2286fb@kernel.org>
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
 "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexander Mikhalitsyn <alex@amutable.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=992; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+3Y7mk0/f7poY8fBlt8WQG/1XBQtDGWNLTeokeIQsBw=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iKkv9T4fyqbzi23jmztf3H8nMwUrtfHJ3V29bbKqZ
 4Be8ZHXHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABNpnc3wv871ae8ZnnvGH04d
 t2zw0Px9bvK8I1+KT3s+2d58956GViojw/+7R89LrYnhN/wbudL+frVNceDzmi1V3lf5GFd/y2I
 14gcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7n43z57rjtu18rkej5zmg6i5ag5h45cc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05033100009
X-HE-Tag: 1794661692-195276
X-HE-Meta: U2FsdGVkX1+vbakLVwb8e4yeDHU2OG23B4JZ43PIL8GtKKy//Xw2gpe0mwnqrXv6Rq68xQRrb9V1w/k34S5MYFd4o+bsz86kBl58OXFmZKiJ5jxF+sylvUSDJjrSZckW54aFRjHmIRgoi4ReopL/EznLngDJyWDrjnMxibdWVeXvq4uYlspIladJzod/u2VvhlJcpdP5XYwn/4LDperdB9gF21XM2ZU/uQ/i2TJVMsPy2KbS03TfwIMkflhrgX5lcdMWsgIERDwY+Hp6aogrmckGGTz5FMwoCSDoBCC0Oc8cjp4PQfpINaAlRsNT/D9dD2ESRKkE8mBE8H/H5oZy8R2EvDqyoZRtPbBwZR8ymwWnljOMlbz/7nAObpig+uDONvEVTF3TV0Z73MsdCmjWqeXDH+LIF/YqunPABLQTi1yW7lcnMC/tBWL4VpUqQ+npPyV0EOLIWhOZr5OtqTI1q+5ifTDtGT/11oyagXh2aR2CWh5OTFHa1/tg/RIor6sVGk2ZCm2lZj2HXVO1fFxM1MuaSsnuE9ZF0VLobsXoKoLTThBizYjJepa/VJZI0992ThjAXCaoDoOlCXBZ+3jCWAWFolQ1k2MjutwTHlKn5WoSVWwahaFDelaXyPC1ls4+6jgzLTqEIIbH73Lek005s74aCq5+1MsE96t4URVApE/2/MDYPCUY6M0JZD1IjvOWITjqYrbVPwk0RWhCnUlUcpdQvUuRPvAN9/yt9fbC+5WB1eZaAalB9QpKr9ORUQaef05jN8cCijdAX3IXEOxgkT0O1Lg8VYaw/+WTsqECQXEqogt27dyNZjVXx/8ybclPIev60dUUnhR237JdCMJ2v4GTFPTtUIZOaUamQkTT9SUhx/xaj7Ch5qdpMMS27UAPrunPeaWWjbh3K+Tuk5Q8+gO6Ysy8K4v7gnOk6PxG3SfedBN3QEZk+1U8wHLfpYRw7dX4GkzN02gQojybiL4
 Ou6f08iA
 g0oHjA538melazgL2EolU7bT2Dfdf2WWo7DMwF12TVmeBZJPi1tebCD1eqk+eVJsim1v6J4fvrDu0B/lttfUrM8C+ni9ubZ0rWArj5Mn1VUqHrPRTgf3+iT7CyI3/khJ/fqS5kjNC81FwIHhqMmnFgL/d8+yjXPPcil6mxhGPyNcBRZz3ZMDZpf2Rsn+Bb4eZI1KGJMyiT6ixCjNb0Hb975W5JS60LzRfxYEwogok32k/zMByus66g9tqULCdvEVjBT+tHMUjgpHRiAFvKMPESdxhfnQKSHzUaKHnPnkfEbHXTrG7ebps0PmJq7Rz3c+zZp02zAq7/TtUwSARGappHrPcT4+fnXDm1jZ4
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


