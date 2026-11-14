Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73F9606C578
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B5R+VehV
Received: by kanga.kvack.org (Postfix)
	id 088B36B05C0; Sat, 14 Nov 2026 08:06:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 038516B05C1; Sat, 14 Nov 2026 08:06:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E69B36B05C2; Sat, 14 Nov 2026 08:06:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C8D9E6B05C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:06:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68E38A03D1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:56 +0000 (UTC)
X-FDA: 85433749632.26.768035C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A05FD80003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:06:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5R+VehV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8y8pXf9gqPkO0k+nFwDQgqQWegc2AhC+X3hgAZH1228=;
	b=4Fi9lnsyFPcP7n2JdOxS04Qi1w6YCPca5CdS/DE27tSmLXx1cZiVJvFIQ1XIawh8Wav9i2
	l10mFTFWG9Xm2muTPZSuo2N44fur0P+5LbIhXK+J9YNpEMGFN36Tm1CGKV4tpZ2/Q+MdEw
	BqBMpP9lyI+EQJpv4sjvmAwmX3nglfA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B5R+VehV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661614;
	b=Af1Ol13MXmd+FD9BxDugu8DOTC5whjO//iIjUB3/FUq5ioHTjCWadOvc9p/e0Mbm/rLgvj
	kC2UrqScscN/u85O3NMACmGjNttpTvDU+KtJ1bxkhvKmVGl62APo+Ia8FznpkbWMT2EiIZ
	DyUga3y0zHY40Crni/3pc6wmMlgMmHk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DE6162735;
	Sat, 14 Nov 2026 13:06:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBF41F000C7;
	Sat, 14 Nov 2026 13:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661613;
	bh=8y8pXf9gqPkO0k+nFwDQgqQWegc2AhC+X3hgAZH1228=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=B5R+VehVMngHGkPJ+s+XCxCJk9zQ0LC7k6UXqHAShVZfpeoRqUg78BQ7bxRu8GlAD
	 WdMibaUsC9iUvWMP2hws/2BFYatPqexWuE9PFUYpNXfs17z8TPKaMR3KI1gjZl5Mnl
	 /Fz1BNMtpr6tKnVS4YUWMtua7imiZs/WVybR/slxP2/6c4NeMSaFbFW03UveloX83w
	 bloyxEP1CwgxzJhggCCH4avN2sqVGjEop/4+8+fo3dQ2Ct6Hy3Yk+axQFpEPcREsb7
	 6eE/CUZP2j/EJwm8/wqLSZliWiYmarFcEeb16/e8YxAeIXf5mDMA8PrhWHUlpyGftP
	 eNEzfbz2E2NXQ==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:52 +0100
Subject: [PATCH RFC v2 11/42] failfs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-11-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=964; i=brauner@kernel.org;
 h=from:subject:message-id; bh=+YmkYomMv7q82ZkVNjPSlbDFCXb6mSuwmV5/K0rj7TE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iClyMcjWu162797F+6nGyX7T79pU2b1sj5/HbyXVV
 j91tmRBRykLgxgXg6yYIotDu0m43HKeis1GmRowc1iZQIYwcHEKwETUFjL8j3kb8ePr+3DTG01h
 yyxksq+/uSp6i+9pjNCSuwde8WmXKDD8T53u92/NqW5mF7kOZ/1135j/K0wrXL5609X2JzskVe+
 FcwIA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A05FD80003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s44kf41bpfchq6794hsswajnatm3tg94
X-HE-Tag: 1794661614-10817
X-HE-Meta: U2FsdGVkX1+6wZl/Y0gOeo62EsBcfbGn2QnU+dG+BwR/z7fkXRSbMI/ojJv5mVxkkY3GXBWngnugIhlx6O51ubuKbRQTlq0G78M67XPUF4xvTnE8U/rHmRmC1+KngdPleaBZkBUYKxhaX+cIWXgjyyN8jDxojQTm6NYG+qEp1PKEHHlalQVG5rSzZn3+WreuKcv8moJbwaRzaowBPchozsqnooAFZkFbiw/E2JGCiZ1uNmBPJHVSxLjwzot8zn7llIGTn7IqIxah28EdnT+Us6CoYMLDI7fhME+DF0fIW8i2b45mLkLbE5Wl1YLd6jxTgvtzd8MCtOrE+yvFfdMDYYuOyJZHSeoakSYmddy1esnj0wQKFbZEA0Y3y5TOzkmTFLVy/RebLlyYMIvS8FZKCDieLk2c1wbBA1NFOM+AMh89P126DznAT4Kiah7sOAr4I4wmH1+LqLVeT+aZjOqJ36Y1jRm6dJymO8kW1Ci0cS6CAdgUPq28ApScVepOIByzV6vHeV31FOPBtfv745jFlW+/RFaDAYieGUMT4NjRbzigfgUavgR/gv5byA8bH2MnU6Ncz7jeGFyk6RS0pb8HgPWys7BWjd8aNx2rCfoSpYELVsYJ9s3BpyEg8jwjCVoiRIJJfrVs20ArVxJMxiM8bqiGePXEptRi+Mqnn/A5iXz5HxBgc3dJY6PHTRl6fJPb8MLvLOAl+E7f7B5xuUV0+7T9ZmM2OL4oYpaXll2PVahWgDwxElzK7XKYxFOWsCu7z7U91bJIA7nU6BRYZUdryMtPQoLERa3lWxTY3tFjEPeoe0kz1G8Mdk+7uH+hyFp4XVji5/1Z5Lwz3wZYa8FrdklaQfVWj1KbSuOScweZQ/R+NNN4ABS0fIlUKTfReEdwZhthLTcSGMbx4ZTYT39OT3iDzVsBP7I1cx8xiL+4IguNbtE5LM314jUxxr1KEFZz8DkvGCeiawILTMByMez
 MBlirdpK
 emxAeiyWI4n9kf5ekoSdBcygEUmdE6c4i2hQwfBU273i+dBhl9Ot4OHhfsz49iQ7c6iWDc6R7W7sppSCUzafEVP3kyk1v7PhgmIKCMYE4FQigRXjT450Hx2FstNTk0/EfNl+/q3oD1q/WOel7f/enXY+wS0mlteCzikfVWxQOrGt4fwR88TrImPZ/+MCYlBPWLcF4V1NFJiHnPEZW2hOlZgY+a2VHU7liXfiQVvjevIkzIiYRmzmymuM7Pqklnh8cdMDLbWqpL8GYU0Qjve2VQklRfd1tLFZPL/3d1VTXJzyaa3mBTyoMLDnXUCMTlRF/cizjPrlwrs4x78hii3hZBVi+q0XAbW/FMn8m6KNjuLKa7eGY8rd+ztIUrmdKpjbC/kFF24j65D5hr3pEGTZJrQ4+AVXDt+rJ/krQwhczuZTdI4WryPDkjsplS9Ze7RSyPQ0y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize failfs as a pseudo filesystem instead of raising
SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.

Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/failfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/failfs.c b/fs/failfs.c
index 437cdc981c2de..f03334f361c0e 100644
--- a/fs/failfs.c
+++ b/fs/failfs.c
@@ -3,6 +3,7 @@
 #include <linux/fs.h>
 #include <linux/fs/super_types.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_struct.h>
 #include <linux/magic.h>
 #include <linux/mount.h>
@@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
 	fc->ops		= &failfs_context_ops;
 	fc->global	= true;
 	fc->sb_flags	|= SB_NOUSER;
-	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
+	fc_init_pseudo(fc);
 	return 0;
 }
 

-- 
2.53.0


