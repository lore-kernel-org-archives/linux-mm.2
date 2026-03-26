Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E592D106F311
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 09:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A5B6B0093; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5415D6B0099; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B9956B009E; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07F5B6B0093
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 05:55:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CAD911A0C6B
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:06 +0000 (UTC)
X-FDA: 84587755812.14.1BD6FEF
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6C8D120003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 09:55:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c+cMJMvp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQomBLxF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Py17vQlN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fLaUT1KZ;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774518904; a=rsa-sha256;
	cv=none;
	b=d08sV0E+418RuJ72/rOu2+qeBEicr5rhv42obCb9j6b8cSiONB91sv2ynh6E0wHLjjuJ2w
	rZBqHw+kAIhoapgmmHr1NtJj94ZK32zjPcM4q298UEYAhxTb6Pm1RYzauY2ZGsKEVLAs2L
	OlGxfDpvOQafDVUQwAqDWyTnk1s9zso=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=c+cMJMvp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=GQomBLxF;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Py17vQlN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=fLaUT1KZ;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774518904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=XZQtYFWCf0Ab9HgpVbXy8aXsnBadMYk9cBpjgvcSGVe0+HOP9fyG/dqKPpkRvJ2QtVz71s
	Mnu4BEO1hLa+anaIkCZl9NRcbXhpDKVKehaw1LVfPGEnGHnvuVkvBldGkAkvn/lu50K9JN
	VHpstO7I9ZEgYIgEoXGQ2kfHECL3TmM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D27985BD84;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518897; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=c+cMJMvpGByx1iW2hTahLGiSpkQoYs/4VsfCVYIlR3E718dvQ60Fb7RH53QrWA7mafTF5Y
	4vvrF6pEy+TfU0/28w3aWWvMT5HUbSRRYPtQOs5nMj/lQbiCUHo6rTQyOzdLjRexbu4EFz
	vLUKeM1RpGRoURUNyC2S7vumo6CX2xs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518897;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=GQomBLxFRAxnMGsteK32nYlnQTBloEMFHxvKoyLwC9mONnkuhxC/d/Z8O+ItYwiht2FaZq
	oBp/QpwLp1dX3mBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774518896; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=Py17vQlNcFSaitp4h/Viay7TLFzPFdqhV8gt+t9mYQEAFe0nSL/FtKNh7HPD+2tRT0tv37
	MsxTorNBoyBWHPwCd6OAgcK5AkFYzogVTlMma0SfoS40Tr5ZgDmHAaF7OIBdNBQMggt7Hr
	qbNzuoTcSIfAC3GdSA67/hFU03Gz4q0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774518896;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7JZGRSCzVw+dnMxvlEGqz/JeWA6SU2+LFt85FuvrPTw=;
	b=fLaUT1KZ+dx3F2JfHukhWOsbs2wbqHrxqV+s1Pw+kQ1dbX3Pz8Yg3WG+/Em08dho8oVDBf
	bmg2l13Su20g0jCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C50C14A0A9;
	Thu, 26 Mar 2026 09:54:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SJOXL3ACxWmmYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 26 Mar 2026 09:54:56 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8A3EFA0B5F; Thu, 26 Mar 2026 10:54:48 +0100 (CET)
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
	Jan Kara <jack@suse.cz>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev
Subject: [PATCH 04/42] ocfs2: Drop pointless sync_mapping_buffers() calls
Date: Thu, 26 Mar 2026 10:53:58 +0100
Message-ID: <20260326095354.16340-46-jack@suse.cz>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260326082428.31660-1-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1308; i=jack@suse.cz; h=from:subject; bh=ud/28G3xYrWf6hhDA8l9j5Yn2n0f8oX/rNwQdYapQHM=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBpxQI1Rii9H+t97Y2LO0i9U30mEMXFAbwMkKJma eYyaJh30hyJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCacUCNQAKCRCcnaoHP2RA 2Q2lB/40rrtNeH5a/OcwRV5GW7AHRKWOY7F5o1rK8q6l6iwgWTciefwamUkaZrSfxF8E0qbwuC+ zNfVIBOCy/tDvLbvqovNOMG3MQFx5iEVAL4J2bfEVpf3OB7pQZ667VRSh+EyKUITNlWFJNVQHgW ewKd3AAUqyLVHicVrJ5wXhvjTjzmu26LANTr0iBn9Fs2fuqntosK0mdBUYGM8T3jxDAJg+RJ2nJ J3O9sYBqkgE47rVWNc6yrNTkuFWiwjs3LOseeKZmnKfepWvPTxELcZSUGs4KgnyJqCPke6W3CBw mxLE8hEFHjOoiQ/zXsZb7RCr1PHYXK+kxDR8Xzl+gwpa5Dry
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Stat-Signature: 6hc9p9uww8zjuxm9izy8unn51yxu7igd
X-Rspamd-Queue-Id: 6C8D120003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774518904-53584
X-HE-Meta: U2FsdGVkX1/Rh9GKq7ar5oxeRgCQxtQBIPyYKoqTXvioZYR+BGg+Z8ad530bri7HTxOTiJlwKDjgCne6dro5sELexrNRNlXbk5X6GKAR98nMLqnqvhgJX6jcVF3OYeTwoc4l5Z4Qo5PY/KuM/yu4hfZwo/SRpKNFZJ8dqHmEp2HbSf08AlRYmS9NJykq/h4nBqHQ82acBmM/E3+b6kfhKMK2mTkssP31AChMTQV3H87C+O4U3rMXnGdcKEnfAIAVjN46YOxsI4ki9rp5SYL4UtkxWDo8rEaxgPub4O4b7bXeduFsj49HQ894L9EGzFNd7lPDOrIrhOnl/iS/l/tit0aRU4S2GVCw1bIjIe90RfVst/6LbaGYifcqqgG5V5P25PIOS+NgQc6uO2uWrHa4xhMBVqWOWDaOlZXgA8wl5Af0OSJpgtRfQBGbcLjolF+XdJ8qjnshJJZxcjLBqSm1ua+scRbVU5tSMGFTto6ATUYTmh74KOXJ+MhLMkscRqaunmW3Wcs8FR+kJsWtpAKvzfh8vR8HainRoUheGtk9kJ7yFekMONn0aDRAni4O6PYhmYFfhu8Ra5deyWuiv0584D7o1FJftmUm5BkH3r0c6Hks6/7A+R+xld5O4+wxc/1DdHNJCk8vP9TrufgoUB1FswwGZrY3etoweEJmxhVUkW0SugdgjmJQiC5BGWgQ6JsmOhtgpUQ/bccr6ICa2jR/NvIkoTH2tww7wmgo5ksm2kIfjsScrFachaLX8AVcV6ZZXDHLR7V5Tsv0Nr5OihUX9z5AVTx0GE7gVWRw+879Ec83HkeB83oLhoh6G4moXCIrzwr3144fzIasFEH1oMUaEmy0p/fmMJRIcgkmbh+osjL9644iaKuQ0vAPKQIaC9g7/HDL4SqTXtC1lbPElK1KnkXR8ZvaRgjZvCGD0UN4j6Wt08IxCt9WDUpvFEejbtXb8y9DsVr2xCmvijzsuRS
 n8CbZ0gX
 KtJAz5T0yprLfKhgxuPP+rLuO2JDb2AGvq8fpJ+5y4NpHMG/vwOwdUw85/Ikf9ttPxL38x9GTSlGMMcvU2A2PGjZzrCOEPtwDuvGfGNWd9RI+Vj4bvoUMhogvwpjomrGOINO3qzcTBjmJGm6EiDcCvFqpX4+58mCNkolR3OOKRKTFv8ovSEqZ4R2H1t069N1dQnX1/Y6zRgA9+c0ZMUvOUPJStRxAGriA8DvfebCf+d/yfpE2cYJ0xEOL8sNvMwELXfdjnH4BUdVUMmCtBuoM9lFErGnyOimZdNwNK6fiX6jgzAz0AmdoXAvJy9GlTfLbbh30r4536nyK8BokD4hLhCIKmds3FxMiHGmQDYCtzrVPr4RDo8RUjnpND9T40IM8Z+d5Go5EDCaizLsIOZYU2l+njjFksIroLfI133LoLYt6+Y8ooo3Ru3qeGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
buffers list is always empty. Drop the pointless sync_mapping_buffers()
calls.

CC: Joel Becker <jlbec@evilplan.org>
CC: Joseph Qi <joseph.qi@linux.alibaba.com>
CC: ocfs2-devel@lists.linux.dev
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ocfs2/dlmglue.c | 1 -
 fs/ocfs2/namei.c   | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index bd2ddb7d841d..7283bb2c5a31 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
 		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
 	}
-	sync_mapping_buffers(mapping);
 	if (blocking == DLM_LOCK_EX) {
 		truncate_inode_pages(mapping, 0);
 	} else {
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 268b79339a51..1277666c77cd 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
 	if (rename_lock)
 		ocfs2_rename_unlock(osb);
 
-	if (new_inode)
-		sync_mapping_buffers(old_inode->i_mapping);
-
 	iput(new_inode);
 
 	ocfs2_free_dir_lookup_result(&target_lookup_res);
-- 
2.51.0


