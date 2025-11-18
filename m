Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C820CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E334A8E003E; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8730B8E003B; Tue, 18 Nov 2025 00:16:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCA968E0038; Tue, 18 Nov 2025 00:16:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 67A478E0039
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1432A589D8
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:16 +0000 (UTC)
X-FDA: 84122566752.19.89EAC94
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6A91D1C0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=foJK7sLd;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=;
	b=QKHwzMwO/TaKBRGjRgVI0tKpt15+bwldnr9XEyizb6usVufJspNG4urjzRyQ3PKaJ6iwyj
	CTURQd9VUw6RYTesyXaFy+o53DzlYS030tiRu2nC6jH73nX7VfOLiIvdUIuZQxH3aAAY2M
	4S/WhMsH/DaKyvr3sdGBVRfXinKj8bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=3RrQQEECX692ylvb8rvvWVJ4jXN6hF1oQgjyqXwwTTUiYoivYxskrHPl9vP+gSEpMYl24G
	F+IefLAgYwKaQdTmXeZkaX2mmIM5unDD36WbaphS9EiUmoFkFvG4DhHSeSSP2LW2TFQhx1
	ACGMTtVV6O2MyM6AMUBuY237ARQpxkw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=foJK7sLd;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NeGicC5Z67ZOycdylyHVP58sPv/wzz9kpKbtM8vrBao=; b=foJK7sLdTQuza99mB2bmXypFjg
	misbqZX+4TBMEHJPS/CtDVLH2McNOV5pxbQLZgbbfKRKtXjjwnk2f01dTbYNr9VJA67kQswAXuh51
	v7BUg/u2sW2x15WikQA8wQUoxPjQvUSRM40WHr5yWeQrqH6TIN7Q0CfbUthRf/ZPJEgYcaLwIqney
	EiFj+aQFrcYDib7axbtElcqJ5Z2Zc3O6A2uzMZLefKpMbX2VuLIAZAam2xbQLYKSpMfh0jj6whvUK
	xLyQ6i2VSFIlc42oPP0Ujsax5Y00fFs/iuT46xZx6+SyspurjtX6r0yUUM8mE4LPm/R5jlmNfWkCw
	C8m4O0vQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4U-0000000GERB-3NMQ;
	Tue, 18 Nov 2025 05:16:06 +0000
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
	bpf@vger.kernel.org,
	clm@meta.com
Subject: [PATCH v4 15/54] convert bpf
Date: Tue, 18 Nov 2025 05:15:24 +0000
Message-ID: <20251118051604.3868588-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ap34hryhsjeqmazi77s8wg4sm41kgmhc
X-Rspam-User: 
X-Rspamd-Queue-Id: 6A91D1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1763442974-155782
X-HE-Meta: U2FsdGVkX1+tVJbmTd8r7uTipWYJm/uePPvF4iQxnUqKDBUU7qOgiqNCvQtIDu5UwJ13vdYkQoJVJF9d9lqvoLgmkd1aRPxDFaQO9ND0fkG8VAHxfjuAGSSUgpAzxMI5xsTdeZ7zbxoa7zzuBflQ1aKcsbaq+8X4kVnzcgnm67H8yGIq+FKXcIt7DyZlsSoSeRRq/7RhWdx8eqsZDlyhwc3bKv3bkeY49hzsbLSV5tNZlrWQF9uP9id+Pdsrjza3ctPwQlo6KbiYSk7OB6pcLKTLaeRrYLonsvZC3KzVAXq/0+bBuSoDn4gSQJxQ7CpFmyHX8WSagyuawW0qyocCfZLwiQ/ZGkJcvQ6QWt0FLWvigTaX1szJnwZddMAaGMaEOO/Eu18fbPAlgyMHVdQuXD5a6hC5l5qZ+vnBa8oDELTL0OH5/pyZ3TT8ytcn2ETkSqBeTImyChIf8f0Z5+Ds0259XPvYHmlLYrlt0iJ7Zvut8V1/8lvK4gK71DuybkWKoWIxi5oKdvxo4RaO9v+WFSUubWxUUB2vACVit6JM4ptBqpCcYXMtrdp/ncj/4dpCnIed/6EWrwDL3HmQcpid6ZGx9tzJ5qGPxiDaqQjdJkfGyhTlnTEoExkafrv1671HnaIndAbTr3Yk0EdRkZ5JSGiqYNd0tzdzM6lJcPlmsDV4CBzT0y2yJAlJ4porolARJbOATaE2UcVNpWQuIff4UQgAIE/Zvrl9xP/yXqz9/p+lE9rwgV3Y1bfhwON5ZSXiezdm+PP6ts6QFjWIXxzObaakuxXEu60ViSy/MyZBwU/ZH4TZojSPBJonZkGVT3USYj+2tq80Fr7+iXwJeL34xG4ACEAAxgWCOgiTe/JMpVbneLGF1A3wcYOB2qBfPyZrnJavoqokv5Vqq9PDoFlAlCMbjH+81m/3GQRiEWtAqZYTjs0kV8h1OOvu/wiNFikvSfmEU6TKYbgQ9dHhpz0
 Ja8QsBwC
 zst58HnWBB3Bc3alU7oVp79k8NuiodlUo+kHr7tEuWzzLq+d1Y2zxspVuOFHoc5Z4A+82B1N1qNhbNtVbpHsai2jr9jijaXu9vOio5ZmKhIiFlYz2TVAAnsIwOmV2SE0Uuvx9tVkgF5tt9BWaS1JPxzQZWlZ8q67ZM/Hjjsr0ePAtRKh5fUpu3ZQf8crqa4mEak1QDvqfhLWcF3H6RiW1XdeI3Ggzkm8FNYr9ltax6wfQgFhaSadGXjm9CBwBm2Jm0ssJl8D2qv3om+4xV7oV9Lij+cqSuTnjKyaZicGmbB0S7Nwq+0q6mFtm73YrvFBvJoQido3uBeI2HG98TTmRLIEz0CCOA329k8t2kqSQlVX9QFCLgq3xARE9oyQTZCdf+pU2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

object creation goes through the normal VFS paths or approximation
thereof (user_path_create()/done_path_create() in case of bpf_obj_do_pin(),
open-coded simple_{start,done}_creating() in bpf_iter_link_pin_kernel()
at mount time), removals go entirely through the normal VFS paths (and
->unlink() is simple_unlink() there).

Enough to have bpf_dentry_finalize() use d_make_persistent() instead
of dget() and we are done.

Convert bpf_iter_link_pin_kernel() to simple_{start,done}_creating(),
while we are at it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/bpf/inode.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
index 81780bcf8d25..9f866a010dad 100644
--- a/kernel/bpf/inode.c
+++ b/kernel/bpf/inode.c
@@ -144,8 +144,7 @@ static int bpf_inode_type(const struct inode *inode, enum bpf_type *type)
 static void bpf_dentry_finalize(struct dentry *dentry, struct inode *inode,
 				struct inode *dir)
 {
-	d_instantiate(dentry, inode);
-	dget(dentry);
+	d_make_persistent(dentry, inode);
 
 	inode_set_mtime_to_ts(dir, inode_set_ctime_current(dir));
 }
@@ -420,16 +419,12 @@ static int bpf_iter_link_pin_kernel(struct dentry *parent,
 	struct dentry *dentry;
 	int ret;
 
-	inode_lock(parent->d_inode);
-	dentry = lookup_noperm(&QSTR(name), parent);
-	if (IS_ERR(dentry)) {
-		inode_unlock(parent->d_inode);
+	dentry = simple_start_creating(parent, name);
+	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
-	}
 	ret = bpf_mkobj_ops(dentry, mode, link, &bpf_link_iops,
 			    &bpf_iter_fops);
-	dput(dentry);
-	inode_unlock(parent->d_inode);
+	simple_done_creating(dentry);
 	return ret;
 }
 
@@ -1080,7 +1075,7 @@ static void bpf_kill_super(struct super_block *sb)
 {
 	struct bpf_mount_opts *opts = sb->s_fs_info;
 
-	kill_litter_super(sb);
+	kill_anon_super(sb);
 	kfree(opts);
 }
 
-- 
2.47.3


