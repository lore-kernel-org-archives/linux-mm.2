Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54BD7CAC5A8
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F7F8E0001; Sat, 20 Sep 2025 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09D908E0014; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F75F8E0012; Sat, 20 Sep 2025 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 419F98E0008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:48:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A53342DD0
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:08 +0000 (UTC)
X-FDA: 83908850256.29.0632208
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 661ACC000C
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:48:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nE9xTD2O;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354486;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZQ+/o3tr5dpemhKGUjYS6VsiGOwzb8RklREPcRpDvg=;
	b=tkooKgC4x7fHB/gam1RbTDmxiJ/Mau0s27bz7ySNbjefh7cTlN5B/7YKKLZjsGm8xzkoBQ
	Ub3dcmpRsb6WyR8OH4jCfJO5uPG95zmOzziFXXJvo4iJKMYKVyzWhTQ9zpLfquyxhkhvmx
	usw0jw6iF1XeNe4L2g41qRaTAUGTQY0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=nE9xTD2O;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354486; a=rsa-sha256;
	cv=none;
	b=8irEzuGxiIadcn1d5cqmkuESV0zQx+ooIZeDKLxzNTcODLjZIYch1TCNUStqqiVXaBESSS
	w7GnKpqWcN9mHngrS+zDHLvCrAoJt+cSegswM08/U0IUK0MjtfEEUUtFLsX1pr2e6wWqZl
	PtCLKJ7vGrY2Zl6q4M8OlRyLSBXejdM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cZQ+/o3tr5dpemhKGUjYS6VsiGOwzb8RklREPcRpDvg=; b=nE9xTD2O4CN6wpP4Ngft7mDdEL
	TuZcXGmk/7d3wdqCXaaVxrTXc2OSHAbf15SV7sa5HU6UiK2gZpavjRj9N/aM6/PamsDBqcxAg4fXm
	OL7LPJpsFT9Jl7xe0XrmWdWBiFpFHZhhH/JfesOcQStv2NO2kG0XrRzVAr5lhdazpsjPHAOuItv2C
	S+yo4rTy7pFfdpmUCBoKURVolp6v7OcIvRfTEnu/FPhKU0okt9N0AcAnFJKVTrkky6Vb87jl6b6wj
	aBs7nHDF0M7wtjRq/0toFn10gpnC2nogDPVajqxejcGgVd/KFjsC9q6b5xdmDwzw3ajlyOkSCo2U2
	SQIPPJtw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsKB-0000000ExF6-022R;
	Sat, 20 Sep 2025 07:48:03 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
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
	borntraeger@linux.ibm.com
Subject: [PATCH 19/39] debugfs: remove duplicate checks in callers of start_creating()
Date: Sat, 20 Sep 2025 08:47:38 +0100
Message-ID: <20250920074759.3564072-19-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
References: <20250920074156.GK39973@ZenIV>
 <20250920074759.3564072-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 661ACC000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: wdc68ms1oerej4nrpkswhr98kwcrprga
X-HE-Tag: 1758354486-768707
X-HE-Meta: U2FsdGVkX1+V1uaVw6w1/IOeh1u3LoEOviTGGtohXIS0RYI5xJJ3ufKp7pll2WGZRyiaLOJc+U5gNtpajzfSAZr+JeKq6jBGEX2Bh7AOhCHNasedwffFtAA2dxGbpC8wp43lmV4bV0Gm8Js8e0c02EYyGYceLK7N2yH3XiIrnndpNKuhk/d8Jrv9eER/e5QWl9PvGTjEHG/sKSy7c3t7T7pFx9YEYrQtKEIqxFjCji2RL41tEZLQpOysrXd65YwXBGLsXxtVmclgc2bPASemEQ5LdMrBiDvtOVYwYesY5zmbZE1cM9qiU8UvkkYrl1fEaX8nj2j496kvSnyxOF85Qc9PksG3qh74poTrsvMXAEelekL+oFR+z8YWHWPzi7ix6m1xSuL9omYgQfiqRYqON280w+Kyo17FMuNwQxfUeA2RFdZBrnH189WQEI14n/U0cz384kLcP2Jg9vm+1ky+PoFPCCDWF+iOuaXyF4wcXQWk8uTPjLGpK6An03BzAqwzbPHXptpVNSB+Ai4tVh1MDCSKv+7VQIIIKGMd5f0AP3hrg7F2yp57M8EYujDI6RClmExErAuBQP3q/F08jw7kRXMnjJqLEHnDJyjmZXas1pmjCwkzzFN2tGAk27VLa6BL5T7XkHw/H4psR2W4eZYNV+vb4P3F5VEYL4b8ID+M5Pc4hrqhc7p7LLoVYsCkD5US4nBARkZR4BB2yZWkNLom2/uLCZFvPfmUvk+cjds/Btxkf8L4aZSR3cdiXwIMd3cbbKf1V406LhB+YC9WYqq4D7R88jUJ1BneT7lotWtu4zpyJcKBlzCmnkuPfGdFzLlVp5h91ItX5w30NqdOy7cvoEfsb+q9aKPcJDRncJawxzh/l5gH1ieJsVQvGnxvsyMiC4WeYp91S34On3CVbSK41uFufeT36tZhmHmAbmAS6dXLpRnrGF6x/JNZqYoJ2kZrWB9pacEElncx1HQ63o2
 XdrTQ9J6
 iIW4M5iwNX/DR39VpHj767CZB9XIp1stHUJSr1acC+wCn6FfuNYv3v1Ns3AtngafrBF6x33r7bfKXoYhYZbaxmMQmnvS60Y9JEuTN2VbrQ8M7h06vibJqdigw8i01wr5aOKNaGZj53nD7UPA6x4DTbLatsyWqBl08dGRvzG91p7TTEn/eQnvZaiYY4uof67A6dHBsEvlf+eT+BUJCMtOsJHqsRlBpgB5E4l+n5NOeJw1EpSLDg855u2A+rJ77G2Kjcwy5Bioij3GzXdtMGeG89CLCEBs7xjvvAMryO35IX0dzeUj8+pP/WBHrAcXUEgkDp5CH1hqFXMtNIomxcuO1j5Ayo03nOViVNQIwBTxeFI2ztzszKJ8slYx7lax5QCCBWz+jGFWOiAES20YolZymB/ULqy5BJSOblfhbiLCb0rnLGIwwL/vNuoFDt497XaFgcqI9anMKN5VamjRnB616WvwsWQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

we'd already verified that DEBUGFS_ALLOW_API was there in
start_creating() - it would've failed otherwise

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/debugfs/inode.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/fs/debugfs/inode.c b/fs/debugfs/inode.c
index 1302995d6816..95eb57566d26 100644
--- a/fs/debugfs/inode.c
+++ b/fs/debugfs/inode.c
@@ -432,11 +432,6 @@ static struct dentry *__debugfs_create_file(const char *name, umode_t mode,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create file '%s'\n",
@@ -582,11 +577,6 @@ struct dentry *debugfs_create_dir(const char *name, struct dentry *parent)
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create directory '%s'\n",
@@ -629,11 +619,6 @@ struct dentry *debugfs_create_automount(const char *name,
 	if (IS_ERR(dentry))
 		return dentry;
 
-	if (!(debugfs_allow & DEBUGFS_ALLOW_API)) {
-		failed_creating(dentry);
-		return ERR_PTR(-EPERM);
-	}
-
 	inode = debugfs_get_inode(dentry->d_sb);
 	if (unlikely(!inode)) {
 		pr_err("out of free dentries, can not create automount '%s'\n",
-- 
2.47.3


