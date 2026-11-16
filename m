Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 601206073B36
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U7641dzb
Received: by kanga.kvack.org (Postfix)
	id 85FFA6B0616; Mon, 16 Nov 2026 06:11:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810FD6B0617; Mon, 16 Nov 2026 06:11:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FFC36B0618; Mon, 16 Nov 2026 06:11:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5166B0616
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:11:19 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E1873A0888
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:18 +0000 (UTC)
X-FDA: 85440715836.01.7688EA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 20213140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:11:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7641dzb;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaBmWD0H2e/byZAd7Xmvk9z8GUGshWVsh+H9VIaIL8k=;
	b=k2Vo6CAq5ZNKWtFHXpyYGwh0lUqprXlZxbdaTtABkiAEaTU2gRVbYhcGgD6Of5/jy+EDaU
	HZGJ/msmFlUCwaFucWk0egYqNUaWgrmUg4PpOKU/pkok7ByS6MRjhzpae0/uRfxEM5Xaxz
	BLjCK+IcHz0g/UaQ46fPxkqI2aeho/g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7641dzb;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827477;
	b=eDfxhkBmdr+nbfC4VgLy7H1ZNIzHCyba9VWM5phCN19gn7dpESysyRdtLLK+3NHi21cxPC
	awGF6uFzArmCMl/Od+WgASa/CNJF9XaX88+BsLOGygJL37kQuj6cjuvgfAV/rzdrVYw1sH
	NJ/IMpN6IvLerwjFy85H3lZeHHYMTfA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 53E4842DAA;
	Mon, 16 Nov 2026 11:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CD541F000CC;
	Mon, 16 Nov 2026 11:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827476;
	bh=YaBmWD0H2e/byZAd7Xmvk9z8GUGshWVsh+H9VIaIL8k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=U7641dzbHi68FgoVcp+Qc4aB66pQAxq0SE1VggFUvf3UptU6PSOSPxEuUVckdRFis
	 gBdbXWAgknUxf2WOR6QRrK3mJ7qo4sKt2MVBW1KDfKbm9AEAp5P0WwCNwKFdlGvNSy
	 V+LVCf2Qz9d+7FNEGVOUuPu12FvHNYURFOX6j7vwsicSvTt2onQWRzpOR7NkfIWHRv
	 54vr7WI+NATWXTFWM2Ht/34FIxDP08XFbN+qBvortmw0+AQaDGektha4t5P60B/Z7W
	 Rlh6fXap3z/icrBIH9mQxI7rbDe6cWHLoTt0lp7fefcljhZ916IZ4wrFIl7C8tMdpx
	 jCqLwaSdQUg0Q==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 12:05:15 +0100
Subject: [PATCH RFC v3 42/44] erofs: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-loop-pseudo-v3-42-8cbbea1cf34f@kernel.org>
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
 Gao Xiang <xiang@kernel.org>, Alexander Mikhalitsyn <alex@amutable.com>, 
 Chris Down <chris@chrisdown.name>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1701; i=brauner@kernel.org;
 h=from:subject:message-id; bh=zgPAmU25yXmDAhDS6CiCz+zo4qFZ1Bc8aFsU5Ev1fq4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9etw/L55Nunlnx5t7vJ/X/+JYMbt61QHto2pZr1jCR
 HcvcfmU2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARwyhGhgu3NIKv371gIt3e
 8vqomtbEY4GBy5Y4t/xe8OHknsJosW2MDH/6VfjO+i712/2j3JGf97jpsQb1eOXvkkXpJpPWOPU
 9YAEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: cyawrht7hi1xrsh5tc8mddm613bcs5kr
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 20213140005
X-HE-Tag: 1794827476-950123
X-HE-Meta: U2FsdGVkX18LBBE73PsyPvXqjb+kYkIx/o7NzcxeNtfqtbkZpf1nRqHvYZEZbRyE6YBr2gDzz4Xo3LGEVsA5mS3JxDMQza2rVS951yrnO0zh6e8RZOtpeDiZJFmcbVU2EyI9n4GkAGi5vCrAQ9TEZ5a1TXQI7SuG1UEEy5/AvxopiY4A2VYPgl/fvxporNtUuhcj8HaD1U1forLMnTvOrpomoDyqFnLZWeRMZ0g1i6GqIdnjx4uHA633V/oyXy8uGoNVk2E4MFJ/mBjcm0c+fPSBIUWjSgRBqD/ptcVcHjtb5FTvYheZJ41QAinI3dUz9sJpn9hxDPAP7LXV1INRPhc9TVtLvFem20/AqoUnDLWF4/POND9Sp+KRMnHnVbvsF7X4Nu5CtRXo+J1nFPf92vsdyRg8MJSLXdEgF5A9VDyDGb/HX211I6YICaIGzyDs63TT0yh5TDeoSH3Mo2mBkSljQJE3uynWDEZuZvCuK8DsQj+KaRC7iSibhaSyDKr/3BaaJOVopfgApE+jiNgv8d8OusSs8iK1QES0G2xIAwxzOfosb9zBlqQKvUoR6fYOc4ajc3IWUjBnAwuZ/HBOmi+Aa0wJErwLJpThv2NB62Leswzn7Q5WL7b3fpXME0UfUO8FH2/IAoAh9MmFTm2fNP+dfZ/av57L+/29dlRneUVxWZ07B0AqVnKvZ0eSG6wSaWl4J+2EWfWskVizS/2ZoQor3gTnF1IFwPNW0NyQooKyiSAC9P5RInClvH4ri+JJhTMaAiHy1lBLkSSffryq60jwBXBW4vhVjbCOD7+fkyuRtPcm+A+lJFeQd9ceGJ7/191y4Qajet5LqriLCFLSMceaFzUbq+BFCNK/mdyMlkdXepz9SR+7a75yQapce7aPYYnHroH8LRV/fJVaSatUKb+bte3uUC67Sn9n+Yng8yUviSGxVZLe+/igXTsGvy7DsS95XV67mCbkPMwB8jK
 MII84Bwx
 nOjDfkow+cR7+QFiKrB6UgwOHjtMolYfepca4EIAi7YmaG4XZDn/CaejYArHqM+OTlOUxiaB0wPjOozj6MqmVMDjf8f6ZxAcXZ4W2QDXAhscs5Je70S83yQ3gOTOhWkk5Ri1+yj8XKgLAlwllSt5cOrrk7ZVgGo6mAXofDItR4cMJJmFUSFofDAOcF5v6BvGx0t69WTrqaCBv4jWuYIgt/9y1m4/HL6t+8dkvQTy5gXcy8z8ju55XcHQQ8QOnfcYI2l8wYOPg5/G8E7RZ8v8aKGsr+mgbG4IDL2J4Dq9y6qsaP9LyOJ3zhaWPHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

File-backed mounts take any regular file as the image and the same goes
for the extra devices of such a mount. erofs reads them with the
credentials of the mounter so this doesn't hand out anything the mounter
couldn't read anyway. But files on pseudo filesystems aren't images.
Refuse them just like loop does.

file_check_backing() also checks that the file is open for reading. So
a source file descriptor that erofs can't read from fails the mount
right away instead of on the first read.

Reviewed-by: Gao Xiang <xiang@kernel.org>
Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/super.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd9983..517a289b9395c 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,7 +158,7 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
-		} else if (!S_ISREG(file_inode(file)->i_mode)) {
+		} else if (file_check_backing(file, FMODE_READ, 0)) {
 			fput(file);
 			return -EINVAL;
 		}
@@ -835,6 +835,9 @@ static int erofs_file_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
 
+	if (file_check_backing(sbi->dif0.file, FMODE_READ, 0))
+		return invalfc(fc, "source can't be used as a backing file");
+
 	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 

-- 
2.53.0


