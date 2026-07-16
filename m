Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B23E3C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA03C6B00B0; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77B66B00B4; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F176B00B5; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 601ED6B00B0
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C51DB1601E7
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:33:50 +0000 (UTC)
X-FDA: 84994883820.23.544C35E
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf03.hostedemail.com (Postfix) with ESMTP id E0D9620010
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:33:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=QQNQb9T4;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784212429;
	b=53aZbSatf9gt+5hZX1LyJUKt8A0hdnwh9aVjf/kqweJ3d6ZpKFR0fwNDy+7pZUYtj7jXoB
	sJnGmQg9gx3QPl/uqffXK6+eTPwaNplbIfIMa6Y/H2tdw96jMrqq/dhRsYfQ+pcKpJbW2+
	6A8ySC0el4jCTYVIl89kBvpx43fiq/Q=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=QQNQb9T4;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf03.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784212429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u8MPSkeEXoEUBttnnhXtqn7icL18NVEhqR4kh84n23M=;
	b=HLi3Vp0kyXBfucVaouhFUFsNC0VhIv6A7AKMZYuYxqu4eHvq1dBPpCAxYID+snB7kBjYc1
	eWzMI4qSWOoqsi9Zt3IiG5RfVfvLLFTPC4GNanMOe6207dH9oCr3HiAaIQJ3DKWPRu4rZj
	1fkCb/CQvzlLTFcUl22UxO8vIda1zpE=
ARC-Seal: i=1; a=rsa-sha256; t=1784212356; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=nonvSaIyCSTzbD9P3g5e1pzJYnJYHF8DJ0MfQLtZOfsLzYLfKeUKLqdaYAGqKyKQCIj+eZP3k2jMi/So92N8phqovTBI+z4z9xqlhMl+yP1MatS6eoc0j6bl3r0Bc/Tjt7Rf4UQZUTRhFP7w0BMTLA9OI/gv9BJh6qwQuZBhTVc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1784212356; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=u8MPSkeEXoEUBttnnhXtqn7icL18NVEhqR4kh84n23M=; 
	b=lQ4ol/fovBU1oPUkcYPEN6VJlz5o0ubYZEwslFVcPvux/9AZzgfW68+gc2NZ5NlWBj3WKdykuhuNrSz3vQ4WPJibfQ3wOZbvC3LjLtRnBPfKYTvx68RS6A6Khcenx8wmnJaBOOq/DxM0VZ64nV8RQuZCSfnwaoPFcI9Bwj4hOm4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1784212356;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=u8MPSkeEXoEUBttnnhXtqn7icL18NVEhqR4kh84n23M=;
	b=QQNQb9T47bra1c/5bj2A9ONcpperFj01d9a8pitGmBE0QFlPgiLmwBBI3+pw8Nw9
	tJ5qeRwA2nOA5wvT+nxm5hJa7R1OZdPkgQTsJUkgYdgqHVLW3d14RmFtGyg64OSlOHH
	QRvUwsmOiMZ87zD89hU7Tqb458YXmMBE73k5IHak=
Received: by mx.zohomail.com with SMTPS id 1784212353185462.13311224881875;
	Thu, 16 Jul 2026 07:32:33 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Gabriel Krisman Bertazi <krisman@kernel.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	John Ericson <mail@johnericson.me>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <shuah@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>,
	Eric Paris <eparis@redhat.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org,
	audit@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH 02/24] libfs: allow custom validation of stashed inode data
Date: Thu, 16 Jul 2026 22:31:28 +0800
Message-ID: <32a639e0eed4fce9c68424748e46ec3b8f575b38.1784204592.git.me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1784204592.git.me@linux.beauty>
References: <cover.1784204592.git.me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: E0D9620010
X-Rspam-User: 
X-Stat-Signature: ry5zzziqxkte8tb74mrigny785heoaoo
X-Rspamd-Server: rspam03
X-HE-Tag: 1784212428-145869
X-HE-Meta: U2FsdGVkX1/vrhBNaNeeioeFOdhbISx4S/J+Jjqt2tKwsC2ifjX4zaxwm4aFNnYuj+EQKX/FtDP1GtF2SrNb65HvPqZj+U83L5EktE4IHyEH4ALQ6KZdRiRVlkRnAuonXSYv4ORZdxhIxpuWz+5cGBB5se95JK5cBUQSBIqN6SvU0Bp8sB/NV+vvFiJz5XLe1QLJN3B7Q7iSCmhrPO+poo3cvr33l4OpL2QCgZTXojEHS+92uw6m0IS3b2QwCiQSy0GQXiZrGxTM+Zn744g2S2VrWHs2qvJx3ZZ4LpeCNewSJYaERbngNzuBYo3NJYUEF/GsPWuWHkvbNXxHVHmPWiasyuFU2rCMhMW99IOd4gYiiyFfY9Moy8eAzYSF98G9rrkLXDDvYdH46m801l4+bp84cXlNtNApFdM+7wm16Gn3gQs72pIijvQJZKdo9lBdNX3wekozQ9P0Uh3NtXoV+blGgcS7okfr4w28lqlM5YcrmXcHEGQBTozqpbGJHCzLz+/laV63br8dEO/ElwUCIWRu3eR8uMTPIgn8yDvzeh+0vgBRBo8iOGEARoPg+DLdLraZcPcm+9NpR7rcnjv1WdyzXnr1aau/N8Q6vjfufLp65XXeUOgBpFqsVqe1j7XWUtpWLjBSwFAXh2kOMOvE4YU8bjE4Vw5qfuSSerA0YRKiWrRLAIdni3tTekDEyMZSZDUP4T+aD3CkLir9zH74OKOJJOM18ioeDB7fheI3/gOA8VKn3QsWOMDaVa/Y0Mv+yP8rdz3ssXBwNKDPeSbyZngP4fT911btKV/7gtHeYOHGKqqCCRVMDju6JesEzo9+aVLBm+ejmykZgQ/00aG3YZMVyrkc7YTO6Xv0rLMenbQEdJNE8lE9JTipCa5QvB12VGWNvix4ZrtuldvwvulO4d2/BFXh8fh4Lwc0wv1dZub6WZjVRVephqfFVozrbLBvIBE0/lWa54QTPfQi0bp
 1IsuzEbr
 j8k47VN1hKUrsdDEudSkQP5SNogt809DoD7KAiyY8PaPVur/VBnMfooqqllsGBK/yN+7COPmDJj0Whr1uIh6iTmIFbszA4ZFDSH7LpHDmGugJPlMkK88Mk7nQ9/xxUlo8NcHPpROaZmHzyV0OHeNvAH2qKog9PoaTOQxuhtGWR6oum889z/4mIuay82d6gwS3aQhwduiFlDuXuyUgpyoip0H/Yfdv6vshwfDLGJlTX3ey5EC3GgK3UrrytUurXQ7sLXHdDHK2Rym9JSCHWorX1P5fdqHoWcdrjNbRvQLFnAe2JJ2pW5AupVw8yjMNr2kjwAeyyxHks4A4B45qiBzTRCwyKvX2v2g/0G+eRCKkAqdunJlfLf+m+CaD214L3V37x4ECDpYb9yVhV6PbNKU4XVwrrKO9apAVdmF0spOsKB/0YE3JBjGR5wU37TwFplMySYfH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

path_from_stashed() assumes that inode->i_private is identical to the
caller data used to find or create a dentry. That is too strict for an
inode whose stable identity can later resolve through another object.

Add an optional data_matches() callback to stashed_operations. Existing
users retain the pointer-identity check when no callback is provided.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/internal.h | 1 +
 fs/libfs.c    | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 174f063575558..71cc43e72b33e 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -334,6 +334,7 @@ struct stashed_operations {
 				       struct dentry *dentry);
 	void (*put_data)(void *data);
 	int (*init_inode)(struct inode *inode, void *data);
+	bool (*data_matches)(const struct inode *inode, const void *data);
 };
 int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 		      struct path *path);
diff --git a/fs/libfs.c b/fs/libfs.c
index 5a0d276379d13..68cc1671b4699 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2260,7 +2260,10 @@ int path_from_stashed(struct dentry **stashed, struct vfsmount *mnt, void *data,
 	path->dentry = res;
 	path->mnt = mntget(mnt);
 	VFS_WARN_ON_ONCE(path->dentry->d_fsdata != stashed);
-	VFS_WARN_ON_ONCE(d_inode(path->dentry)->i_private != data);
+	if (sops->data_matches)
+		VFS_WARN_ON_ONCE(!sops->data_matches(d_inode(path->dentry), data));
+	else
+		VFS_WARN_ON_ONCE(d_inode(path->dentry)->i_private != data);
 	return 0;
 }
 
-- 
2.52.0


