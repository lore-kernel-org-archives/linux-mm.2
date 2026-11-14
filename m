Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25441606C545
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hprGHgCq
Received: by kanga.kvack.org (Postfix)
	id 349F66B05D9; Sat, 14 Nov 2026 08:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBF46B05DA; Sat, 14 Nov 2026 08:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211066B05DB; Sat, 14 Nov 2026 08:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB2C86B05D9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:08:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F9361603CD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:36 +0000 (UTC)
X-FDA: 85433753832.29.113A4F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4BA7780008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:08:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hprGHgCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Afo8ed/GIRxi34eV1UuvuxN8L56duYS4vlWsPBP1fM0=;
	b=BPu2wbbc/1SMf6jC3bkEskWbSZn3CIvKNeVjdQ68yUBU5xZkyL1wV3BPe/3wmnawR3nPuo
	X0oIjHtEYaj1VEJFpoFsfO137ohioNb5/BDwmSOcVdUiOjcK+Ttru7DUh4krlHo84L17dP
	p5kZciELjxpKryDitS4T/sRg4z2F9Gc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hprGHgCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661714;
	b=IBjzAMGXAX82dKzQAfsI/qhWhlbLv8ltdK9w4u/PVPsFx+qUtej697PQk/rdEFYyeJKHHy
	FtuDaEHHwlgJtZi7vdSvpAZQAhKl44kfpdSPs4wHOHFfORLyms/xCmFPd+aGBSTMm1c6Uj
	Mc4sjhn7/ZjSErz78E8++GvW3jQT5HQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4890441144;
	Sat, 14 Nov 2026 13:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A411F000C5;
	Sat, 14 Nov 2026 13:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661713;
	bh=Afo8ed/GIRxi34eV1UuvuxN8L56duYS4vlWsPBP1fM0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hprGHgCqljNfHaaRT8wbU+b4CvrLYNHbt2kQUNxd98TIwvCS2ehJO8vBQg6IjA/4E
	 QlB02LLCNgV15vU1lPLmWWEwlLoHBLk24m/bQPCp+Xt2+5fcmhBnJkLr6kL6tImYJl
	 SZ5FGLvBWuN4qnzeJZ1uLhmeUGELgSZ8JHePmJcS8Z1HLYwEkmf3Gob9WB7bFvIcdE
	 //xR/RRXp75B0I1ifA+qvkckh7ZeIvssKgKnFVvHN/TV1+Tdlu+VrMbzl2SBXWGzb4
	 0iiVdJi6+Q0l8uSEtN9rtD9y6ItKjTJePfdM28scvMR66rgWPwX2mkMg+R7tSuzj9r
	 yx06t2VwHiXRQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:02:06 +0100
Subject: [PATCH RFC v2 25/42] pstore: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-25-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=940; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ohaN/4o3T0nG31Sa4LtDWeOCgaFP7NFffTjYcKqsHS8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iGl65sDr4L+lP+1LwMR9DJK+pUFszdFFZl9j357yX
 dgmd+5/RykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETYjjH8Mym/V8LV8ePeaeFT
 x7u9pzw6+Fw+X1xVcs/rnm9zFByPHmP477vQ0tL7dpTko/erzdrX7rRZPvXiz6+/Z64TjvOpv/5
 wLRcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4BA7780008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4atp3ofjwxh4s9fkfymon59p9zc3yj1m
X-HE-Tag: 1794661714-797448
X-HE-Meta: U2FsdGVkX1/1bYwkfPly/0RWntZJ495th7pOLMPnmEW+/8K7+ABr7ZwJWPgtcqyS01/+MztmvD1qYXIEQWPcEaE7x8jlQHlDRo4YjEFK2O3Z5wXkVLeQlG6glpjgtUjgVRsjCAPnaUCXFoiOIaXngcG5A9b2yoBnP4fX7A6CcEBeatHGsFQ+9hH4EFv4VlJxeBshdVQQzAZL8C22B+MefGilyuw0PwWkiGs5lP/lHxJk7TyOnGM4TldQ4gYuPx6sY2PNuP1v+7S24vjI9Ca8UuvIums87uplaPJCiMjHE7eXZUykLY8VuR/vvzI0Iq4LyRjcKRDIdQCaz/bqPTzUGJrj0w2/dBrHi2kjdkJ7PK++lTDTHewVU2CFpxepdM2EjsUDclsytgNcljVSHbcg6ib0MCPnvQ0qiB/8Y6jn2CnitvBdwARVbQRz+iw+0IotLsKt/Y7ylH5Te+1eHXtuy0zsI3LFAwZ9nXKA/C/oC1NdpsjdC53PufRMDIH+tq66DuPs7/mkJSHZgVBWFe3LqpM89n8Jh5qKEsKd+a1cYsAexai5AqdhJyRQFvdMzb4kB35lVANGeyQlb53OtcqMKxbYVHXlFCnJnkp9v5iR6w2z3qSp1CqGOUqnhlgcVpn942e45JAQx0dwf4aYb3+jtFdVffruCpTgo9fy4cVWKFHQcWCzh5uCWwwVG8Fhg0hL7uD4w9Hhvi/S57QKlEoYEuLX6RPLkSv/Ab5GC/hr10mItyWhw4+bFe/LwADKfbWPserKyySAC8gS6NVQtPVcUllJZfOEI6KIx0nW8FfTX6MlU8IIpbzhGzFnp4spy3inmaJXIWD1c/0bYa5Kkd2OTOYxu8RDPXzb92PPgk1XltNlZKhRwE0CTBNyh+UVBnlbs4ZjUXX+fiGr0vXIGj/GPSe+YhkLBj1f3r4K4IhA9UremgcGVcvSvG9sPXhvAT2iOBSd7CW5KL2utzzK5r1
 YRChMaL9
 IJFrP0ebFRTYUvfixN9TudCeUOHpRfqx6YUpm0E2NLG7H2z0EN6rOa4NMdqpAtHIMGgdaoiqEGEl7DHWOgHu4QoKhfQWKIfP+TA1JoJ1jz3jnBCk36dECYeZCr4KqrqYduSUbiMyvVg7AGqWIl7DbYYHC5f578Ekd5ZRdQpwduzccu/BAiAFav93jQcjEqNFvdsMy5bfUrt5OPcbzGCYyDts7uCfVwKV9pgRyYytSMjDXCBhOOjkZ8DGHQkR7sRZgzbm4OpahS6YEpZ2KS5tvdS5jTRa/WGxGi96eVzSuaGP9qOEPkAlyuX6l5Bt+kXs7ln8PBM6qZq+FbGQnmQvh5xaNi3E1NQJO2fQ3MV464UsI8fwed8433Zby47aNOnGcq8jFZGdTejBYJO0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize pstore as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. pstore never holds executables or
device nodes.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/pstore/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index cf499ba727026..4658561cf90b7 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -18,6 +18,7 @@
 #include <linux/ramfs.h>
 #include <linux/fs_parser.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/sched.h>
 #include <linux/magic.h>
 #include <linux/pstore.h>
@@ -491,6 +492,7 @@ static int pstore_init_fs_context(struct fs_context *fc)
 	ctx->kmsg_bytes = kmsg_bytes;
 
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &pstore_context_ops;
 
 	return 0;

-- 
2.53.0


