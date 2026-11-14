Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00F43606BA0D
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJFe+GHm
Received: by kanga.kvack.org (Postfix)
	id 2350B6B05BD; Sat, 14 Nov 2026 08:06:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E6126B05BE; Sat, 14 Nov 2026 08:06:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D40F6B05BF; Sat, 14 Nov 2026 08:06:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD69C6B05BD
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 781751203D7
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:35 +0000 (UTC)
X-FDA: 85433748750.16.9FE93C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id AA932140005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJFe+GHm;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661593;
	b=7fbjJveI5Y/hYBhYmPkJEJr4XAg5fCrqXWROIEi1No2M8vp5+QWefBZ7Dg5Yq6KbGQN2yT
	dJAyf3mVxmzvjhMm/7hddRQxtDzlD7/ri5QOmDYxIJKQb8s3Scf1PbfE1YeVqUV3Miuu2H
	oxn9OHOdGeCaucHuSYbxbsxQCBBv9cU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJFe+GHm;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vEUQcwW4egCFJ1K26houNDRkryaQ/QAvUlLdf7LIxfA=;
	b=5QMnS+oMhvf57c25vfteEEN9X+NSaKmz5K4yiYZrZ05sNd5A6SHXJxc9m4N7Iwys02lQxb
	GgLt0jwUtCxyGKz9gnkO2o3vmOu51SyQFOPvZfXNhYXNcoPejZ4VELiARMSw0f1iYwc0fd
	wPbTEQKxOnk1dmYWj62Te8kzTcoJy0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EBD8406EB;
	Sat, 14 Nov 2026 13:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2ED1F000C4;
	Sat, 14 Nov 2026 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661592;
	bh=vEUQcwW4egCFJ1K26houNDRkryaQ/QAvUlLdf7LIxfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DJFe+GHm923QnX6Y5soo7AJQ8SdH4x0drSIbnUS2OWssnfwJSQUV2IZe3ob/XB55y
	 HGpRKJon2FGC5GmKiKtWRgG+aMur8IjXtGeM7NDvCjs8HeoWosaYHGhW7xvQNJxHnj
	 V4RGXfeiw/5d9W+tWBHjJSDYHShB/CzKIkoMMvKbF/QdHP9BEN1PAP6X0fpbq+Dajm
	 CXmweTwa8ua3L0aVTYAucEIcFCy3WE3wxr/DXYLuLhhFs+aHqTQXXM/VppEQlnuEaL
	 lTMHA2EAW1JBgJmg/Y9PCfE+UFz0cUy0VBh0Br+5g/y+MUzPdQgQ7kbV5gr8gtumMk
	 0iV1JBfnD/jCA==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:49 +0100
Subject: [PATCH RFC v2 08/42] mqueue: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-8-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1301; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qF0TT28NFfI9TLhhCqBLUWCBoYJ0XY66UkmFCoZwvwQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iMk78utTVQKnnZ/L9apqi1Ijq5VX3P9v+Dhp6pbtz
 hPnh+z92VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRpqWMDHO2fHNRqMw6vLBd
 svjftwLHIIbl/BEPDSTTuNUk47nebGL4K/l/b+Gahb+vMDEwHLnCfPthSuHM++uyg1evCA3JnNr
 lzgQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 5syj5mmpmfj3rsmt5iirucowq9cxfbd4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AA932140005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661593-450461
X-HE-Meta: U2FsdGVkX1/eNeuP9Bt5mTL9QWsSXlDcbXfJUp2gRlZcPzJ2LaFdLLXTb+dkEbqszq1u0wOjrafkKJmhfGR55iMljMKeAimBvxR3oFIV8teftKEiWLC4ODH9sjxNoY+DXeLz21r3vG3FOgb7RPMA+fBleBbF8im4JJgdQJAszkR3gwm4LtR3wUpfJY7nC8ROnstZt64YrpJ6CFspK4X6QfVUv2fLvTfTXCtQYjhxJ48CZl1xA2JXWWUs4YyF+jNXxj3mj2uwspc6AE8H8EKMR5It7FoHchh7bsEa4EsykW43mhLa+yrKeIwXwtnv2gCU4MaycLZHeLWpAqWsrKirvmDeWhYNSMwdcbW1PheFt1k6dYCok1PsI0XSYS0bU0CmSF9HkptY7Ygzyn1yjpfA6HZT/XSCA9ycctU1naoXIAN/tk5jcfytHwISoAm9vzDeJ63ePNexA+P/46cjn7/lAV9ORxcgge5987szG6Jdn8V7YAU4xmc9typN4mOTPBvSYlcg5TWdY95mKoX+bJRrhDBG2Zn8wkKmYtJxN0AmcRDt34TXTP6TD6jHKwBHnN6iuNci+9WdEI87E1t7pOtxG51jpF70RPPWRUY0/hAbUR0B8gaBGv7sgguCYrveXQ7pOkJbu9hvEqoDR+uDBGIW8OujKN3vzdobpbU8J47X0Os/OknBjqaMpk93/43hSyEgWUHGDxuwcdWCg/OSvTIlyJ0n9LotcVoAt3Zy3D3BvC3MFYI/Scyd2gBqRbDt+jIiha/AX+gRRldmoFY2bfF0kmi9XxIvtTSGanwBwow20Fktjg/cBr0v5qkK5jkli3PlwFuzTrIEwDYo+Oc+VhHWALq83lZP9anOY1jpUS4n1BsJr/0U56/WjAAc4YssCErk/hcKk94lDwJ1W308CXGv9cqMAOoF0W0y3XcnfbTooZZaGiqODGuS74gGc4u8nInndKaEyORnIegdXz8nei8
 4hMH1pph
 DkItz0l1xVO3vOaZbDmHNeFxPnhGtxg+dI4aPN1jpVy8GI114SDHJT+tiEU9Z4BiGNRgtHBOa+ROLlQxFlUpOUwIU2TaasgH6m8id4zwT0O8lgtlGT8d0TRRUj288GBEJlj3YOondEInTlye8egILBmNYXuZX/f7k7XFPiu8p1llOuCOB+aRHOg0OFpO/5FRR5We444+9YCUrhwDUuK2DOKktTRzlL4wWIiV1pkJshCqD2WF/zwfOfEKzhm0JbsyUaWSSAn5W6Ei9n9z1YB03tHx6mmTTC/Sh0OXK8VuJ1czD5KOYAW6j4R78XlxPjzt0za/2p+MzN9P/VgJKWoctIGvI+P3F2eClDub4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize mqueue as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 ipc/mqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 322c3dd98c447..8bbe32d0881f2 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -18,6 +18,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/namei.h>
 #include <linux/sysctl.h>
 #include <linux/poll.h>
@@ -405,7 +406,6 @@ static int mqueue_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct inode *inode;
 	struct ipc_namespace *ns = sb->s_fs_info;
 
-	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
 	sb->s_blocksize = PAGE_SIZE;
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = MQUEUE_MAGIC;
@@ -457,6 +457,7 @@ static int mqueue_init_fs_context(struct fs_context *fc)
 	put_user_ns(fc->user_ns);
 	fc->user_ns = get_user_ns(ctx->ipc_ns->user_ns);
 	fc->fs_private = ctx;
+	fc_init_pseudo(fc);
 	fc->ops = &mqueue_fs_context_ops;
 	return 0;
 }

-- 
2.53.0


