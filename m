Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D2021098784
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1952C6B0099; Fri, 20 Mar 2026 09:42:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AF16B009B; Fri, 20 Mar 2026 09:42:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E648E6B009D; Fri, 20 Mar 2026 09:42:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC7696B0089
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:42:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 959ED139576
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:42:01 +0000 (UTC)
X-FDA: 84566554842.10.501A773
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5887E40009
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:41:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YccPxXf25dnqKinvrDqnbIY3Fr6LY1z1DOqHtMRq13M=;
	b=IyBgGywGds2DFW5+6ZaHTdOq1M/jVD/d78d43IJHOLgX/IfYWR6+Uzr9BZjKc+Di2+pt7v
	hWAhZfcvtOUCWSxHTK34t5hhKcOlVzdUtKiMIV0hb+FIj3y4MlOq4/lLEwXP3YOpMvkM/w
	fRQreHhnSIDEz21HHkeLdC0e3MK0l84=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014119; a=rsa-sha256;
	cv=none;
	b=YuM4Sfss36meSSirSR8O8psJ1eCJoIEYSsw62VuQTQFUt50GBesTs6098uKsEVu6CHVV82
	L5XPecnsHqUpJVMMEjrGMuw9BtsT1GEyZY6Bb5cxcfjveKcSfu2TGIxOQHORmVyVxiKst0
	vbeZ2u3rWN6buxVFd3e+pbkZA3OuGcY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 0E2B54D279;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 014044281D;
	Fri, 20 Mar 2026 13:41:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dZVTAJlOvWlcCQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 20 Mar 2026 13:41:45 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 9337AA0B4F; Fri, 20 Mar 2026 14:41:44 +0100 (CET)
From: Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Cc: <linux-block@vger.kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	<linux-ext4@vger.kernel.org>,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-aio@kvack.org,
	Benjamin LaHaise <bcrl@kvack.org>,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 08/41] udf: Switch to generic_buffers_fsync()
Date: Fri, 20 Mar 2026 14:41:03 +0100
Message-ID: <20260320134100.20731-49-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260320131728.6449-1-jack@suse.cz>
References: <20260320131728.6449-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1173; i=jack@suse.cz; h=from:subject; bh=sQnfAAliYSp6hPEKRpw+XvFpoGUUmiuU80fuBNLrow8=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpvU5zss1fVh17XzrzLExYByxBIN76SuLhi3EVy qdBUx84BCuJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCab1OcwAKCRCcnaoHP2RA 2ZmlB/4pwEMzrAOODbjtj7HaY5ff7Veyc1fItqr9eNLjpXqz8vZ/ZstgKFGe7nYTYJtIj/I0jaC B7Gv00KYk9uFMihnUz+r/7FZ+R08vO77QoMacpILWEHZeNur88oTvgDn9paD6UTGVF5V4AM6qeI m/Wc8HYIoljOmAFSvswZK7uSvwO44o8VSvMeffz3YHGY+rSpuCsp3vCVBALEeSwjD0jZLlqy08m d8lfCw1TLSZIB77LiT3NY5EURQtY8pNEJIxcuMJYfXB5mR5yHtKKpmqoVb+5Rox/RZbxw/03Jwf m5SlWOC/EJqg+kl1DaPipN0EsijO/WFuX+NlM0a+91BBLDHC
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: m7n4a9pqyx5ke1wdzkzyp8bfrqdsretu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5887E40009
X-HE-Tag: 1774014119-449662
X-HE-Meta: U2FsdGVkX1/AsyMesJcCFqntHjX3a6dSup3azcqscy0xLZwO0r5oEgiG+n+u7eZWJWAxLnycgxLM/eJCxynoMPv9jG5hJVWsLgrHywxC8yLa86U1H8pbPoyraThxxBPFI2fxTEjgLu34ALEnOqX0P7wAgDeVpgE3cM2yrstIcCDUIE8T4TLTshyn+Fivck2aFLy49ovegCc3bY4rLI7hoQMcE3t23ta6uXW5UG/3PNCiV08YxbhDMr1gosFQwPSQLTsKCZxTfQTKPmHyH+WiVMlFkMsm9cjufWMaxVG9/i7WwnURrpvUXw1ChSMj8TpprlffpiRllaUN9qem194ZeP/FiWtmLQ1nqweVxQDN1ky/6kdkMlwmdzeUo2/g0mn/skQsZzUgjwZK2s7WMLK24X+799RgjQMbd6uIVy9KvlNVlXrCtOMbDLNOfTe+lBMEF7zey4VbyRfMIup2LJ0WkdguCe3rGF1ouYKfrjf9ttyV/9FbJS6INASZFLhtEg1eesvpQO4wG5QYNEZSh5JJnuN0ARsaOZswxGLbJKVueTPQLx4IP3Xk/EEI20nzvsl0fbR8OEMKy9Tdt4/+Iy3kqeDYoCNHpuQV4ThwMvG6zcEm6G2cnqy7JcBCuUOZMOg8gTuzgIs0pq/Bv75hxak8NtYkQs66kLyBIIu4Zhuc5o/BceJ6OJ5FeDpqy+mMXMoi2HvxGiDAB7RvfBfndDHILXQMnUP2eW8pD+vdLRV7aVJuSnHT15gsNYHvv2MLq11KpvENqQCmj63z120FG8u80AXz5nDZZ0qXuyZk0eLMsphL98bWLHlHLzMuavEbrehzU6twpLfC10WAW/NboK6YQy6Q3Q2xqvcgXEY0racnJyrwg5PaHvlCjqYnoYCCNtZVhtAnJUOXmqt5wTdinALXLAyQdYQPG0+f/b/Si6kCiS1pR2yTTJErir3GEyjTfPe7Jx0tpJo7Faxt8J16owg
 MZZ1nFWy
 Fv3eoY8WPa2cMvo3UMH6434WoEgoYxP1eRMmMbN5aASzVqICsQKuLan+iRcixygjmUNsluXZhuzfV9uJx5bZP6J6LORKxFwd+OM7wJMUwYXLQ2yZzUELfO13At09duks/ZLIvmhrg5fB0O9jrxZ7ZvYi73HBXGVT+SjAQxhCW0ALuepX3Z7ozxjNmCXPEHfIfpO3s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UDF uses metadata bh list attached to inode. Switch it to
generic_buffers_fsync() instead of generic_file_fsync().

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/dir.c  | 2 +-
 fs/udf/file.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/udf/dir.c b/fs/udf/dir.c
index 5bf75638f352..a1705aedac46 100644
--- a/fs/udf/dir.c
+++ b/fs/udf/dir.c
@@ -157,6 +157,6 @@ const struct file_operations udf_dir_operations = {
 	.read			= generic_read_dir,
 	.iterate_shared		= udf_readdir,
 	.unlocked_ioctl		= udf_ioctl,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.setlease		= generic_setlease,
 };
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 32ae7cfd72c5..627b07320d06 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -205,7 +205,7 @@ const struct file_operations udf_file_operations = {
 	.mmap			= udf_file_mmap,
 	.write_iter		= udf_file_write_iter,
 	.release		= udf_release_file,
-	.fsync			= generic_file_fsync,
+	.fsync			= generic_buffers_fsync,
 	.splice_read		= filemap_splice_read,
 	.splice_write		= iter_file_splice_write,
 	.llseek			= generic_file_llseek,
-- 
2.51.0


