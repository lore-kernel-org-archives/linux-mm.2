Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65E7C60A261D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JRILRqwd
Received: by kanga.kvack.org (Postfix)
	id 842B26B06C2; Fri, 13 Nov 2026 07:00:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F36C6B06C8; Fri, 13 Nov 2026 07:00:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72D8B6B06C2; Fri, 13 Nov 2026 07:00:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DABEF6B06C2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:00:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 655321A02C0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:26 +0000 (UTC)
X-FDA: 85429953252.27.826A53E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A37E020009
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:00:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRILRqwd;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794571224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fcUPAY7Omn+SLVKKp6rIXL2FdbTX+CoaPRplNDl/Les=;
	b=OR3kBS/lYBCeLZZbwuL88yhk1vfV1eT8vZDy9QEPffk5QDgbhnx7w+GSdwJ1eLq0eFALgY
	6xhmLAsVwqdfjCOTRINw4NiKCUYSLvBoxmMgqNjlE8py84UE+MWtoODreRUUYfm3kAr5SW
	CxW5kDgf+PBg4XZ+gH99WBhfeGndsJg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794571224;
	b=ZfFniwd11fhrmM4LffePFeQeIp0okBxFP2/2eHyoLe30ZDM0y1/1if2NA6R7vQdLls/R/A
	gKiEfq4jhCnMLVODWGwx5JwXlkTP/f10FJqQSEdHfzk6Hb46W0Xfn/xmG4UnLRx/kFMGiD
	3Jz2MLIZxbAwk8K7vH4PtJjPLJ5Fg7o=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JRILRqwd;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEDD1421F3;
	Fri, 13 Nov 2026 12:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85E811F000C5;
	Fri, 13 Nov 2026 12:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794571223;
	bh=fcUPAY7Omn+SLVKKp6rIXL2FdbTX+CoaPRplNDl/Les=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JRILRqwd4JRgYzxUqWzJjNJlZe50YGlY+OaXv6HHQUZ/YRL+egTShAGjpX/70665+
	 Nd9K1WH0rqdzRgv8HsOuog0O0NolbJ+thxfmrdZowu+oxZTtS5QzEQcOIUdVNmx8f0
	 UJQ4eQhxK+Fnl9k+68gHrlzlyKY1NN8Vyj/sEz9ODGaM5Rdxwnurz9lGIsrgOf3Lcj
	 SmgyiukO64uSDlM/RD3oySDk+ptebhvq18FN4TuIt6DchF+K+FbLsqScLqwKzVdZ8s
	 LrgCTVlLMbHT9Vv3dBRYuIx42nvdS3v4ICzRtq/RueTY/XtvzirWDph/Fv2B53Vl4Y
	 Cbno+lrB2kv9g==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 13 Nov 2026 12:58:59 +0100
Subject: [PATCH v3 03/33] ecryptfs: don't leak the inode when a lookup
 can't open the lower file
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261113-work-fs-sb_rdonly-v3-3-0be92bb73709@kernel.org>
References: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
In-Reply-To: <20261113-work-fs-sb_rdonly-v3-0-0be92bb73709@kernel.org>
To: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, ecryptfs@vger.kernel.org, 
 linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-nilfs@vger.kernel.org, exfat@lists.linux.dev, linux-mm@kvack.org, 
 ntfs@lists.linux.dev, ocfs2-devel@lists.linux.dev, 
 linux-btrfs@vger.kernel.org, gfs2@lists.linux.dev, 
 linux-efi@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-xfs@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org, 
 Farhad Alemi <farhad.alemi@berkeley.edu>, Tyler Hicks <code@tyhicks.com>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=1544; i=brauner@kernel.org;
 h=from:subject:message-id; bh=YAwCWT/i/fjx/KfCi+3/MK6nbc2fiyWIJhkFODNNUZ8=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR9+z1HsaTv488H3xpWX/srV7CPeeZrxWrdNBszu55di
 c3reiZN6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZhIrjQjwySrtUH91ksq2b6F
 f2RuXzKXt/pX8WYeq3KBE7xBVrNFCxkZLgr684g+2JrpYdtgKnfy3fWJk3dof9NZl8QWURbxans
 0OwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A37E020009
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4sfojg5zhf741ybsr94jk6dzq4mmcos4
X-Rspam-User: 
X-HE-Tag: 1794571224-444028
X-HE-Meta: U2FsdGVkX182GFktAxQmNqyOXFaN40vjG/7L3fqigrqxKhgR8KzjwyqW6IEYf2f0z0SiLYCdCJS8HSeM2UIfeyc1hmjG7FeMfW9tygrcDfpPIxZ1ZMEmfghTehk++H9l7g7hYXdS7uMRPhXUk6fLGtkx0f4IEZN9uPyG6SiAyPGwj8GfU96U0zIwzaz39B57jFdAvs+dZ+6/aFZl30nrcK+Uguo6wdyb2r9zeK5YAlDqp58li2zEVnwv+mRq4a9t8oQNc1IVoaC9GETASdHkOA1rxfm99Vrwf5NpJSp33h/C8gHUUqylYeWCFPY7pA8fhNHWN8LY1++kaWKUZcWsgMdzPC3sFeWIKirqP7wdOjhQad6GRJILQEEFpGW4+Yg169jxZq+JoL/AhfeZno6pW9d+DVoM5qjk8uCJYI84G8wytjLr3PZXBt6wAtcn5H4Jv8KalrSKxSo8aCvHmO/uE/aWte+ZGejolcqHOASanFzNE4jaZjsLROOVKpO1mde3NScHUIds/d0k7Jkd/Hf/Mn8iUDHJAS8WN8ex255fiWPTJU7Tr/LkKKD3B7YPoCX3aSv4J3NC9e0gYY3ZYh53Y+0Ql+GAeP5xHrDW80ArmHo6oEEzxKDm3PlD1xSvTSwlub7JadYZfr7LUuc2r55tL8i5qTabte+qk43nazEFRpK1TwvcP8YalXbNPaSMMF8N4wxZT/cKVmJbqBMOoeUJIPmmAzWOvx8NluCfYhvmCP94reJn/5ACrGSYq2cMZrnt6/9DaCqyEMlOnaUB5DEyo+qVCyz+5aHkpEkY8cg9S4oTVSV6NhE5S3bMvHdeU0ZSLdH6ncKF7q9TYWX6frxp4AnRzQn2K6gGBCmojZXk5FJmoIPZqFVizRhoSJP+sr8GTicVoRzoztMCts51+EYrKOBqsvSbKb3E7OJiqJRgvDHRa++lDpTHdarTA5z5QEDdoVsdUtJPP4KmImVIgAJ
 OZQiGco/
 C61xq5etYiokPRYd7MXAdeEzRNz2CrV2Q9mTjOurpkRzEdYe0m7/4JjM1v+fO7yPvoLvMJHSkB6uR+iZfp4Xzjn3jZP6HBoH9IF9qCa9C7crwhc7KnLbFJV7uHheEvKqU/jIL15I5jRS4QtRcm+MrKkoa4o4WbER2VIasFb3TcJ8rJHf1tydoa+NlUzX+lv37strx7APs3bJaTcko5TEctduknOR2Xc1A4VCidf3eUPPO3oElieHBqauJYRUK/06jII1TSNbnwMnGWoJ4aCDVoU+AR53ECN2ueNZU2ML8U2ex1Uvs1gDtwVWCv7o7kH18m2j3NFDAANH9E5RO8zqKiM9rdG2tmkgUBOvtgEdLr0H352JjCaDIc0/qYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ecryptfs_lookup_interpose() opens the lower file of a regular file to
read the size from the header. If that fails it marks the inode bad and
returns, but a new inode is still I_NEW and nobody ever unlocks or puts
it. So it leaks together with its lower inode, a concurrent lookup
through another hard link waits for it forever and umount complains
about busy inodes. The lower open fails e.g. with ETXTBSY while the
lower file is executed. A cached inode is marked bad for all its other
users instead.

Use iget_failed() for a new inode and iput() for a cached one.

Fixes: 3b06b3ebf441 ("eCryptfs: Fix new inode race condition")
Cc: stable@vger.kernel.org
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/r/CA+0ovCgYP920GT68hAJK6Trjyv1kGv2dZAuem4LEunycQ=POww@mail.gmail.com
Acked-by: Tyler Hicks <code@tyhicks.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/ecryptfs/inode.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 48e520960d665..3a966348a578a 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -362,7 +362,10 @@ static struct dentry *ecryptfs_lookup_interpose(struct dentry *dentry,
 	if (S_ISREG(inode->i_mode)) {
 		rc = ecryptfs_i_size_read(dentry, inode);
 		if (rc) {
-			make_bad_inode(inode);
+			if (inode_state_read_once(inode) & I_NEW)
+				iget_failed(inode);
+			else
+				iput(inode);
 			return ERR_PTR(rc);
 		}
 	}

-- 
2.53.0


