Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67109606A881
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XT6Tzz65
Received: by kanga.kvack.org (Postfix)
	id 8ED966B05C6; Sat, 14 Nov 2026 08:07:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89E626B05C7; Sat, 14 Nov 2026 08:07:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78CE76B05C8; Sat, 14 Nov 2026 08:07:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5BE6F6B05C6
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:07:25 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1AC41203CC
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:24 +0000 (UTC)
X-FDA: 85433750808.27.806CD03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2B552A000A
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:07:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT6Tzz65;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794661643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fL5qL7JYOP9BGMrgZwawKOkNR34gS09nbbxdAESC5AY=;
	b=jgQLCqdqHADZ5L0ox7lyiBqQ9xNwPuHth5JLBKwAd0uvDs5c3EG2UZAsdafde552WGzIdP
	Nfa6qJkG2v/81XYWijziMcYB7VbCvBnK1x3f+BcBZR5EQWJVlJJvnyu317vKU2nPu3hjU1
	U0TSV0LfZt6XVBZzPpFbfY51RpGkutk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794661643;
	b=LyVqaYbZ19u/Vj6B7LdqG8R7KMLK2DbeeyJRX4dhaF7SPtdLOadi5q8mnRONk+e3ExZpbu
	EITUQdpq1wDXGe9DCI30PmUVl0QT5znUsYODabkkKc79UbvG31nIrmHbU1eqk3Q3gBHvmN
	zzKSjTHlrhwmB+f+ntnFznOvEBSXr5Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XT6Tzz65;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 734B645DC8;
	Sat, 14 Nov 2026 13:07:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32C21F000C4;
	Sat, 14 Nov 2026 13:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794661642;
	bh=fL5qL7JYOP9BGMrgZwawKOkNR34gS09nbbxdAESC5AY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XT6Tzz65LCASVZ47tnM9EdK03t2mFYcw5Wfu4oufgcBgXnbaOuckTDE94B5ZXV+Va
	 EU1Hf7/L5yVuBKj4y88q1JGFQui+kFHrJJu7lnns7s22U3Gs5ZcvsCcJTG0I2EyW3Q
	 KDKAn8ifYEBsZ2B7CrL21bmgUbpdyqHWaiX9WluNWeXrhcyYELynQmFzM5mWkYnC0K
	 zpVL3Gebr3O9VCG64/CDLTlwkC6MFMkAzn4mz3EOe5xNvAgcqW17IAQzQdSPmuWMkG
	 /v0whbvR9pbXyF9a4Ry1WJns8QKC3IBONTMY+4RwPAvzY7FdiKnzRHvhdFNFhLYf64
	 ce7gMdf7ac8/Q==
From: Christian Brauner <brauner@kernel.org>
Date: Sat, 14 Nov 2026 14:01:56 +0100
Subject: [PATCH RFC v2 15/42] tracefs: use fc_init_pseudo()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261114-work-loop-pseudo-v2-15-98639a2286fb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1109; i=brauner@kernel.org;
 h=from:subject:message-id; bh=OLdUHvbro/9NsaPkdx9SBi3MWAKl0be+fpwCoTKnM0g=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9iCk/X7VxtazYZu/77yKX3Lh0lO+Fb1pg5oS3DhfiF
 sop1B6L7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIniMjwzQz1Rr/RW/fHJCR
 aP8X8LL8wFk5r+qdurqGgnf6i89UfGNkmML0ZNu1mkT3zPW72uZLPX/ovVd5gtESM71HojlJH6K
 WsQMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: my4qxgir5hzw4j8rud7z9ukascdxywzh
X-Rspamd-Queue-Id: 2B552A000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794661643-641781
X-HE-Meta: U2FsdGVkX19kaSaDY/Z7G8I/KnUzVEof2J09t2USmkw67jbE2y2LfeXAn12ErUdRMVzQg0qJ1mm9o2xDFs0lcbC44M2g60c3bhMTkObzbRgiMRVKCojuZS/wqV3XYQlUWrNMgKiRUAoy5gJ5qVhlsGQSor5kartlxSIFx938SD009jUp3Asz32cZdadGuoXCNpYK/Co0zY3c+Bv//D+iYXczDIXOYAXAkndl9RZkaWdIMLuQBwaqXk1B8wibqkR1z3gQPnfsXs3DdpoY+gkBkjHuvSMxk+1lzSv4NSgM9QxehTeGVsgkNqPWtzCc2w3w+fg0Ma5KvJBwtna/8KxuscWZO+/SIN8YTFZt2OHhKOByMvxjoPuVHdz7w44sv8kRxcysQkz9SuJKE08yDyGCs/JcOyYLitLNDBiU1+bkFzYOORZI4gV3RgbXNKI8y3ZjRaMDXUzxRIp480LtBTFgXh9829+J9lhua7oIEvd4gOvcE1ajdPziwZWP67WkS+8ryJwmVgCJETK41DrFNO6HkruMZxrQip7KOKAkjIQvxJbEXhrpb+mhahufOZDR4o7vgno+3cj3sdhErPFpow4MipGkxeabvzQJB6Uy8F6vCWZHRVnzzIyCbCJIUgTPVpjLbPIpnSwt1TOTVhFMQIKWvSkfht9+wptvqKBLVyZh+f2V2RbK2jTcc5CjweN6dyWmTeZWVwV1TlPnvitSeJe/Vekdp33TN96zaYPmizbAOK9k5yD55XXHBgVVZ3TpQsZcLmJBNG05GPDZENydb2Fzg7xjTLtbNxmasfWr9GaYk3rzFFeJ5NH2uXw6vfAW5xrFy3hS7rHpcJ03EfmS52k97bREiQQ8vPvWZbbDohz0ZYSW691buUOHEYBOy69ggTNBqScTh3IGLqHoLBrOw5ZJtls6/PIf9dF0ortZBVk01yzjV4duiapmGkCT16EIMJM+FP9dNpSC+jYmteakZSJ
 gFs+Pwgn
 2SeIjuZtrBj0RYqY6W2IxVVhnfIBsjkfNDVebcxZbX96VWfJcKZ/Jk+wieqRtZ8aK2kKVw+dcMBxv+hHKNuyhj3g2sx0LGbEEnNpT/bbyLybJTiw5RW9LZ2hcVNteudT7ZJCcEKCuf1mcTF0JncxBfJ+F11fKJrTWrBxrhebp1XVNxaXB4ofIFccAr7sSBzselTsCwzBjyvqmeW5YLA/I1Kog6H4uSBRQn2MrLqLBikCWeiClh66ByiT3EF409W2YyswTQ/Lb+AFX+bvnjtZQqzXQ1/17DwnPsipXN5AxR+AZplIZDrB8zi/kP/kRFC91xl0s5qVlu4UVru9veofY/ha9otkx/zOvd3qY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initialize tracefs as a pseudo filesystem. This raises SB_I_PSEUDO and
also SB_I_NOEXEC and SB_I_NODEV. tracefs never holds executables or
device nodes.

SB_I_NOEXEC also refuses PROT_EXEC mappings. The only tracefs files
that can be mapped are the ring buffers and __rb_map_vma() refuses
VM_EXEC already.

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/tracefs/inode.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/tracefs/inode.c b/fs/tracefs/inode.c
index 5020365ca7048..e04febd868eb4 100644
--- a/fs/tracefs/inode.c
+++ b/fs/tracefs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_context.h>
+#include <linux/pseudo_fs.h>
 #include <linux/fs_parser.h>
 #include <linux/kobject.h>
 #include <linux/namei.h>
@@ -510,6 +511,7 @@ static int tracefs_init_fs_context(struct fs_context *fc)
 	fsi->mode = TRACEFS_DEFAULT_MODE;
 
 	fc->s_fs_info = fsi;
+	fc_init_pseudo(fc);
 	fc->ops = &tracefs_context_ops;
 	return 0;
 }

-- 
2.53.0


