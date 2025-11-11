Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29CCDCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 06:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 461C28E0026; Tue, 11 Nov 2025 01:55:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858B78E0028; Tue, 11 Nov 2025 01:55:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05D3B8E0021; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AACED8E0021
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:55:34 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7385214043B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:34 +0000 (UTC)
X-FDA: 84097415388.06.0AF2551
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id 073381A0005
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 06:55:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pRTnXVSg;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762844133;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=;
	b=oafuqnVt6HJP4JS73UcJP8RaW8ev53q4pb5+f2kW+MLZqibLJrjggUzo1Uo3TfwF9D8s7P
	1YExmb9AKAvHktIP0934/AQmxihAT6chgcHz2OgT+Vk/j3D3zDulFBty19Rhxa30/0avAY
	Yc65TIFh4fnY4qarNtBsRErRiw71nfI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762844133; a=rsa-sha256;
	cv=none;
	b=3ija12nI5XdWEe8bLAfSI+tgic4urR8Yx+G3rncUMuYz3BAGjYai+j+zQSi/qOEKoJyhSu
	3GLbmE6GZumY+iUvMTfMUGrL+I9moWi4rllx57PJupU303UZuFA+tWNQ0h+4prIrDKNijU
	rdurgbHDusbM/t2I3A6M1tG4JQattqQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=pRTnXVSg;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf19.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=wF5oceMSXViySxysMkUNPeCJ07Zgu8R8pwpIbBxZfJs=; b=pRTnXVSgUjFI8ImpwcWRs2NMh9
	PFUB/rFfJMse8H1zKY/AzzCdA2oV8bZDris1DAFKFZqtO3YHL4tRpSYLEYxnh8E9jlpw2sGe9HC1T
	tLsOi/41iwWjSplOT1bV6lFUVLYPqtr2QXrPbX5pBOLL+qv/IRTp0oZmfLRSBmaC93y4gH31y0wjO
	FZeqysA7uYYi6Nw2xD3brd7wX8oQhacLslti2lTkswwKq3GVQNeumXjHnvqiUHP6rSYbvdjo7CmJu
	WmA/vNvp44re4mPKX0YQqMZGPWh+E6TUY33USiEi56cRQZg76TMvhpYfwtVaAkb6VxamSf2qnX6xe
	jciupEjQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHo-0000000Bx8B-2Ydn;
	Tue, 11 Nov 2025 06:55:28 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 39/50] convert gadgetfs
Date: Tue, 11 Nov 2025 06:55:08 +0000
Message-ID: <20251111065520.2847791-40-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
References: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xr5s7bbnauchtax1skktc3ux6g96syu5
X-Rspam-User: 
X-Rspamd-Queue-Id: 073381A0005
X-Rspamd-Server: rspam10
X-HE-Tag: 1762844132-800983
X-HE-Meta: U2FsdGVkX19Nk9VXcxZphCwNN5batjB8/O94izPhhxkW7de5uh0m93RJC6rddOiomE4f4zXDzHxhQYc59TWz4daLwzMxiMCh+T/h3L5Ef8tLTUOcFZ1FTTlt8Zh7lHApDW5XgQSR+Nk46OsioxWpVazynapfPINvrF9Wtws98UyWbZcBMGoKFcuOq8wrZEE09TlwwVpML04mRrRSzjeYcuQyKwTX/PFqd3vJBwI9VfEjTOmnmC5Att90vRlf2SgVm99M2m5DP2+Ro9YoYr1x27zOZpMU8lnV8dc7C053p5LRBPv8l/ZsNF50sgfH6Lcokcbi88pNa9FRUe9SHDpbzTsLZ2iwQPvthLwm2QG21hcmO4NN0Souq8amitVWdfp8lZ3E3X9DZXLs5wDoo9sRXx/u766CDggaM6JD/0R/ySdrZbcVgkNvSdltrGxkuJ7JNaMb/AxcQeg0R+CmUPyuiqkoymjvTi75C05PKMTSeaf2gQ8/Cgx7uWyQPMXacDISE3ayDLWCuCA8HfLsXJLUvvka17cENMqJMeaJXVYpxoeKY8ggd9GZGdOroJN5sB6vxXrQ0D+f9XgV6Yx33TxgnsMlniN+sYui1Enoix/ibNNG7VVS0m0uiIPD9zRm37nwjPTvCD4V3Mg0XnY8zxrUpZmDVUGM4axway6dMibDVaDMpdw/Q7BW55V7ZuGX6FsCQL7vxCh+HoY5KGOpx5elmXW1iFaWQKsg5iJYfteSN00cj2lHnCTP1/Pa8cYYS+p3otuRkOnt6xdcJbzVztwy5+EwmDLzyWU05rSq1+AakGWEDDJy4p3oVyxzbP1GnFYyaX1rnKooWOdGC6HpGscUMWkNqsV3h+lOm4LJdVfBdyzx28Qmu7F1VW4iKRtTpDig8WhHFToWvqWP/fFrGitliWfOLA9qVtPER/1VqLLteLX4Rsfgy7kzF5BuD/7xNTonCKQEHe5doeEnLOdM8vR
 grd04k+m
 w+BVqbsqaARH6egUsHZHDsqrS9AZLkE7O/w/T3M4e7323Pkj79UlZ96w/EH/EYxmbcCsPBmoEkKaehpMk6/608+dkHge2F0K9aZ3O0twB//KzI/A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

same as functionfs

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/usb/gadget/legacy/inode.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index bcc25f13483f..62566a8e7451 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1989,17 +1989,20 @@ static int gadgetfs_create_file (struct super_block *sb, char const *name,
 	struct dentry	*dentry;
 	struct inode	*inode;
 
-	dentry = d_alloc_name(sb->s_root, name);
-	if (!dentry)
-		return -ENOMEM;
-
 	inode = gadgetfs_make_inode (sb, data, fops,
 			S_IFREG | (default_perm & S_IRWXUGO));
-	if (!inode) {
-		dput(dentry);
+	if (!inode)
 		return -ENOMEM;
+
+	dentry = simple_start_creating(sb->s_root, name);
+	if (IS_ERR(dentry)) {
+		iput(inode);
+		return PTR_ERR(dentry);
 	}
-	d_add (dentry, inode);
+
+	d_make_persistent(dentry, inode);
+
+	simple_done_creating(dentry);
 	return 0;
 }
 
@@ -2096,7 +2099,7 @@ static void
 gadgetfs_kill_sb (struct super_block *sb)
 {
 	mutex_lock(&sb_mutex);
-	kill_litter_super (sb);
+	kill_anon_super (sb);
 	if (the_device) {
 		put_dev (the_device);
 		the_device = NULL;
-- 
2.47.3


