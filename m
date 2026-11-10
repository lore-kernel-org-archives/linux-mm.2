Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5175A607D5A8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 09:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aZVzmHBN
Received: by kanga.kvack.org (Postfix)
	id 7804B6B05F3; Tue, 10 Nov 2026 04:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 757E96B05F4; Tue, 10 Nov 2026 04:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E236B05F5; Tue, 10 Nov 2026 04:20:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49BE86B05F3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 04:20:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA70314035F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:33 +0000 (UTC)
X-FDA: 85418663946.01.26EAB5E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A988180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 09:20:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZVzmHBN;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794302432;
	b=RMUolunNFUfcE1jhga2eAyhKqlVZiCUsVIq3qrRh/1jaR3oWOoV0DFzpimYZNJThINLqO9
	8vVVfaJtwAYvn66gx9bkyZ1oKkAhQI0Z6kDIwegSJLHOL7LFenjLetZHUmOOJrQnw7ZI71
	j+SWJcMcQaLqzNmxfs14O56jQ/yW3xk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aZVzmHBN;
	spf=pass (imf16.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794302432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YJdQfmNRZIjJZmJ7eXlopktH5jFS//yu5Pe53ZYQ028=;
	b=4NnvNoiBJLsc4lPbCpqDp+IdfrNzamH4/yvmQlj8BIqaekXhscyzyjoqyEz+kL+x7CyqMX
	KCtOOWdMDgEJwFRYseTibqXHLAsVXFvWvAEXfw09qTL/Yu5wrazNWWNgUuRt4ZiMWBmaxL
	sXUpoDHN+c/7H4olIu75gB/cjemOAfA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AAEFE63825;
	Tue, 10 Nov 2026 09:20:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AA31F008A6;
	Tue, 10 Nov 2026 09:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794302431;
	bh=YJdQfmNRZIjJZmJ7eXlopktH5jFS//yu5Pe53ZYQ028=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aZVzmHBNuwJ61+F1e2oV+4dv4gNlfmbtkL/jYHqJnnAR8nxpapvLT1jaqObFS3Kt6
	 Ta83UhzRz8CvexZ0ysKoa1MoO3Zu6STABRZGed6dESQ7WUcbM2CZMcu26UAdqYXcUi
	 jGRxcd1PuvngpWsUZ9wdr1xrWLiH+HYWR1UJUrQbfn+O+Yx9/8C2d+1m8jfwdUrWlh
	 x7irI9TSUWj+2x5RTqa6GOQ9Qm8DWqqbMA4ng0XxJzOZmiUTRMHuCfCm4DvyHXloD3
	 13saqaue/D0rL6M4JYSaME0ZwZWtpV6O8u9WPkmcnvoBepeZUJpTLw5Bl66Aroqny1
	 QozwErkn3D9Og==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 10 Nov 2026 10:14:56 +0100
Subject: [PATCH RFC 40/41] erofs: refuse files on pseudo filesystems as
 backing files
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-work-loop-pseudo-v1-40-4c998976c6c7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1370; i=brauner@kernel.org;
 h=from:subject:message-id; bh=NydLncApPlv7Xb4803UYyRsruwye9LOqDMcupA3ko3I=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9enCotFA5svjs32+5V/jKOVd3VfaxP+2o4TjJ9eAot
 9K2J1P4O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbydB0jw66Sm4EFNRm7ox68
 2SVYs2OfsAHnhYkt+fUvbmadaZ28QICR4WLbxMemdRPmu/26Zds+2yJaate+vNkOVz78PC+SI7H
 SjgcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: ramkr9pk5yydywsc4n87aopa1xms51zm
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A988180004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794302431-20387
X-HE-Meta: U2FsdGVkX18JwK2FFMWNgQzZSJd6qnPm/hdZGEVLhY1ciTMAHlSRm2rbBc0QiCy4MWSzqzQRpzlTQkOC+uL5hqbYkkjt7Mhigpr/q5wAfgSVTG1p6Na2+VldygwDaYY7GcFJBO5ZOBf1SOcs6JWYFEbxyCWAzaY7Je9piDplxJgJbihYbtwLfKK1TYCqePnV1fH8obsSrE47vHo3thInGjiQnvlL8WlBquFH/AQF7Zdhg296q8UHZfSfUM+/BaIC4soOQTj5HCXbKFUYAyeSc/z7p9eENbCd0FHkB1fsS2t9c1wirlJ/GlKKThdbNe2/9bUpOKqAeFiTvLO7iA9iaw7PAz/hcX0yVqXO772ssgf59Aq4FNZbh9KGngMIovYEBEFx8M78Rjs7/2SXdryrDSGzf6mMx/bEs5d4znuzSXABSy1Zr0xN3w2J3rmpRZLISRFwEol6LHY7tH4lVhllnWWeLpVgVJ5vwWV4Im92eNGe6jBjv0VJJ+Cx+q7CvUhv9i/Rm6cFTd1chtjnjReA4xmziCCLrdR5e2JC39mOqu3gZfAAWw2o88mlDpK20Tt5vLQL3Kz8yhOG+uty2ueIhkOYUCWOBpWREVWvVP47epuhKy6Dw5M0BEWEiJjtMzCNRZjfNn2CViDbtpFF59dBBrUjoEj9xy8AM+0kWa0LvgF78G0pDg84RCIdBPEuuz9j8iXLXj/cAgZmn/b93KGHJeO9HDCb+IT+WB7Ja6zXTwwnq8IwseV1I7HNI4Ip/x+Vd+zx/Oho4j4CCEnWulKI4YQ6PaLAZQdMESCJDvKK7tK6XhDJcyuRHtbl3/WpG1prW7k0AtBCAjvUcsz8KjxBCD9S4nnxG3CUhq+fmPfkKxT0bTuaF9mhQ9BK9YYJuBZ9WexiCd5uOCiQLFtGzgE8SKDTEAMikrRCpHcdtLJ5kMGHrOnKh9kAwbuCki4jgy/yOXA+DEX4VVT714Tx4uj
 SVWFcCaz
 u29Cf61wwj1yldkK1BspA6EKheQwGafa/VoH+UhOWqR/SI402qQtdXjXx12FoDZbD0sp+++0csbaoBKqE6rPpQpzKaXOtpcrfIEDruyT/4sGmZJAHeQUocOsoZKQkvxN3pfTzZDnY8T913UVQWj7w8NUJEYOX8Njq9Cr1uTyZRss/Kk8EalH8qS1F8YjyeXIq82ybrhZFTv7qFHQQVfuZBBrEWVjhDdTFntHvcS1g2AeA8S3nx2COSNY6Ww==
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

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/erofs/super.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/super.c b/fs/erofs/super.c
index ce05557bd998..980d5fc2b576 100644
--- a/fs/erofs/super.c
+++ b/fs/erofs/super.c
@@ -158,7 +158,8 @@ static int erofs_init_device(struct erofs_buf *buf, struct super_block *sb,
 		if (!erofs_is_fileio_mode(sbi)) {
 			dif->dax_dev = fs_dax_get_by_bdev(file_bdev(file),
 					&dif->dax_part_off, NULL, NULL);
-		} else if (!S_ISREG(file_inode(file)->i_mode)) {
+		} else if (!S_ISREG(file_inode(file)->i_mode) ||
+			   file_is_pseudo(file)) {
 			fput(file);
 			return -EINVAL;
 		}
@@ -835,6 +836,9 @@ static int erofs_file_get_tree(struct fs_context *fc)
 {
 	struct erofs_sb_info *sbi = fc->s_fs_info;
 
+	if (file_is_pseudo(sbi->dif0.file))
+		return invalfc(fc, "source is on a pseudo filesystem");
+
 	if (!test_opt(&sbi->opt, SUPERBLOCK_SHARE))
 		return get_tree_nodev(fc, erofs_fc_fill_super);
 

-- 
2.53.0


