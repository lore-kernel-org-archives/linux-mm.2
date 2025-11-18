Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A7B1CED240
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2208E002F; Tue, 18 Nov 2025 00:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D27E8E0036; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629558E0021; Tue, 18 Nov 2025 00:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 305458E001E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:16:16 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC2851603A7
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:15 +0000 (UTC)
X-FDA: 84122566710.26.BAAB563
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0CA1B80003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:16:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cFv8SfpD;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763442974; a=rsa-sha256;
	cv=none;
	b=4wV6ShOLeuplFZW5hRY7U9oo1ivWbkREUlt0lKQSX8T7uD6t5Mjpnyk6BvlM9SHVuaDWD6
	nkAo+1UAMUvpvjiFKI1RfBO5fV38Y/R/nTgLe26kK+VxRx6Ua3sFCGa+XK7hnHAZK65dFX
	DEnB/R+J9ol+uZ0qzSgPaaofSPmnhOo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=cFv8SfpD;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf02.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763442974;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=;
	b=bj+Le2nbJHdhRIyCeh+8+jicxOujjvEZas0DOhxa7MVs1y1Ozr/w45Uc+R6tj6gPtdFbwt
	KOt2SjyHgofWuE9V8vq26a+4d5VZuNHk4E2+XcyXMY9OPP0ujTc9uK3OO+QYnuzmZJmNds
	M5Jj7vxk4bo3Kyw9Hykycx8sgT4A2m8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3maaNWdAFQG6lKGkg4q4mAf3fnGzZVX1VVI0dDX3CYE=; b=cFv8SfpD4XhexPHCWH7/OaafAx
	zoyhLBt2gZ6Bo0exSZh/EUEd34RcxVWLSD7Ta/Iy1vivHDdk94UUme2dABOwuDIMDn8cYDrXVqgaH
	uVbNZBm4ZOairE9ghYr7dZqkJrX1l7sxHzbHrzYBzs8Y1cGdvKHYtTBLzOUya4Wwib7EWJ2/oP/0q
	uUJhsljVSMSwY+deCdkmeZoJzN2eBCKHQyuctBq+A0XuPcZagkssyT7uMiUGxws7ZVIgTTy/hTyp6
	XksFCJZEgumPee6QRATnW84VXYxOcx12OMZffSrYlgKBFeel+lcJq7TmOMdm4m+EEU3l077HnR4iF
	/JI7nb7w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLE4T-0000000GEPy-2GRn;
	Tue, 18 Nov 2025 05:16:05 +0000
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
Subject: [PATCH v4 04/54] new helper: simple_done_creating()
Date: Tue, 18 Nov 2025 05:15:13 +0000
Message-ID: <20251118051604.3868588-5-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0CA1B80003
X-Rspamd-Server: rspam07
X-Stat-Signature: zgw45tzmi5kssa1r9o6m4tk4ap3pynjn
X-Rspam-User: 
X-HE-Tag: 1763442973-415136
X-HE-Meta: U2FsdGVkX1/XN8y3prFTlrertETYwmguSCMKN4JoiN3KOsDRe/gwxex21uhvzsdxtuk9DSYd/rSzAexhYKHc7gj+NCxzjmOY/Mzz4e8atHq4g4Jtap2wU4K1XO3Rx6Nx/Xi9OcDrFl1+qJuuWHJr/0wP6S0AsxfyywFj3s/zt6r5HWPtjdvESfd7FFF7iJns8AW1hPB4aLApkgfN0ZnrMujL2zkzFX3Ztd9DN3EMNNrBF0+5XZkYgwms/3Grai8jHN/Yx5giO8DqZsj3xEh3b3+qGN8CKYYlF6GbQ4x9HOWj6VLZw6DJxWeKIJhTEBwOwzjFqklum5SiL97xbRDH2BYHn6XT5Uw5J2p4HiHeY70YcOgYAfdujk51esLGRZCbDR5JsLfDlsi4xc66zG3PGJud7iI4UrxUWlXDNHHA/gkDFMb3vaPV9hriohHb1pSt2QAI50EyGz2uA+i07JKJdHrsrR4I5U7VEOQQOZr7/6KZIkEj3X9YBp5OKIsxSfsCe8XfkhPeRiz/ukCVIogOmu09F28U12FPCGZV8CVB2JGmjVEB6jw/3pttowLPedGW0UDHNS9VSiMq6xoQnBIGPjnxstnh2+c7/C4fxa+/WNiGBIt1qlXRHjtHmVImfU6NB1zsZGQdcYNO/TrT0oslj9Gcwyu7yaWSte0KIwHb2AXMRSvjzuX7ZgRc+g5BiToVdAaesV6dPqpNCk3bqheE5/eu2BX9RgltSsZqDq2IgEBZ2TymwW9LE178WqRQN9YUzwpZoy3zPfiVnU7metj36CC7t4HdH5iJXC/yi9Ql8VfROenxMIHD8nxKVkezQGA7jPvBkqLXc7R+D5v/4NmJaAdIzQcvras/1p7KDuk49B4haNnPRiW6QKRe87Hq4YJdRXEVUFTsqr5irLso/aP+nayRtHHwNoV1X+6aqFZIK2+n3aQHkA/i7SIthuYTAFnGe65bUcxhua2QUepDbS0
 PsG2HZ0O
 RYtQqfYJzVQbyeksgyXfaiyQX+CRAJRbBlDxzU7y4tp2aVnb+cUtCMLu6KAzG/OtU6yWY6M2oYtbWrtPWPNpk5y6YaVQGDNelFnQVoeUfjIM9AAt78IOumHoeTBX32DueKFwfRHNr0LWwijsnw71jj8qu4zB2mDO6RwO3RI6O1C6LanNxnsYiT3MyvSEUZbyuYxu7seQekr+DzpEH5qZQoyzzGxZvyxM6TbQEli3qod8Hph2CRdi8MMUAiE17juYwis1S2SQCsD8l0Ezbtdtt2+QOoUdIdZyH4hCHDMz/T9e9QmDhtxMFJrp9a+gC0W+/U1htTe6abitz1dYiX8s/lgvH7phTw0F5AWD63G9lLpkH/f03HKKRRpBHg8VEf2NjKxhkX21KiD4kk1zIlalghRF9iKlFvQDwqs6gNAM/1/n8ICA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

should be paired with simple_start_creating() - unlocks parent and
drops dentry reference.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/libfs.c         | 8 ++++++++
 include/linux/fs.h | 1 +
 2 files changed, 9 insertions(+)

diff --git a/fs/libfs.c b/fs/libfs.c
index d029aff41f66..a033f35493d0 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -2326,3 +2326,11 @@ struct dentry *simple_start_creating(struct dentry *parent, const char *name)
 	return dentry;
 }
 EXPORT_SYMBOL(simple_start_creating);
+
+/* parent must have been held exclusive since simple_start_creating() */
+void simple_done_creating(struct dentry *child)
+{
+	inode_unlock(child->d_parent->d_inode);
+	dput(child);
+}
+EXPORT_SYMBOL(simple_done_creating);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 28bd4e8d3892..f5037c556f61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3662,6 +3662,7 @@ extern int simple_fill_super(struct super_block *, unsigned long,
 extern int simple_pin_fs(struct file_system_type *, struct vfsmount **mount, int *count);
 extern void simple_release_fs(struct vfsmount **mount, int *count);
 struct dentry *simple_start_creating(struct dentry *, const char *);
+void simple_done_creating(struct dentry *);
 
 extern ssize_t simple_read_from_buffer(void __user *to, size_t count,
 			loff_t *ppos, const void *from, size_t available);
-- 
2.47.3


