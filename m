Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13774106FD63
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:47:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F0DF6B0098; Thu, 12 Mar 2026 20:47:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D15F6B0099; Thu, 12 Mar 2026 20:47:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B30F6B00A7; Thu, 12 Mar 2026 20:47:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 476C36B0098
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:47:34 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 14E298BD3C
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:34 +0000 (UTC)
X-FDA: 84539201628.03.8407BB7
Received: from flow-b5-smtp.messagingengine.com (flow-b5-smtp.messagingengine.com [202.12.124.140])
	by imf15.hostedemail.com (Postfix) with ESMTP id 16DB5A000A
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:47:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HmxnQzsE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OlXvAtNG;
	spf=pass (imf15.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773362852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xGOrm2m9mt9eD9zeGh+FgoHjVnxN1Npoe+4KJW4hbgM=;
	b=g90sMG/uXzx2UzVtSsI8Hji3DtVTJZrK4ZWGAdK/fkKQvHH/hn9QSyFCb2gpcZij8Iv7kg
	GfOk20dNgtnTYy+QEvKsitw3YdaG3PgXTU44lfuVLclL43AuPyqS2L2Y7jwMFoYGrGpQXT
	Lvm1Do9a4sPhWWI4Yf9PrexhLXIR+zw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773362852; a=rsa-sha256;
	cv=none;
	b=t7WOLg75NUQIvAYik9aw4LoF9S5VhTtjncNSeS9yC8ZtzimpTBAMvJQ2bkG5a8FwdU+3GU
	AKyyP/GjiajSWjbiL+V6mCQkIda1xef2rYRxd1R7sQXKZ89Dq5B78TDhVk8g9/S4JmWqnJ
	nSyn3TT2eakoUhMGKS3S7t3QyKeOzQo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=ownmail.net header.s=fm1 header.b=HmxnQzsE;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=OlXvAtNG;
	spf=pass (imf15.hostedemail.com: domain of neilb@ownmail.net designates 202.12.124.140 as permitted sender) smtp.mailfrom=neilb@ownmail.net;
	dmarc=pass (policy=none) header.from=ownmail.net
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 2E9171301B70;
	Thu, 12 Mar 2026 20:47:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Thu, 12 Mar 2026 20:47:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to; s=fm1; t=1773362850;
	 x=1773370050; bh=xGOrm2m9mt9eD9zeGh+FgoHjVnxN1Npoe+4KJW4hbgM=; b=
	HmxnQzsEnZP/3l1ULThI1EtrBcCNolH2f3MeN7w4c7RJaHXm+vKCYNwg9f3DJff1
	He4j2oJck+izrAriM0w1WckxI1d50V6JuDB7luBVfoFucpQwFSyRdFlrMACyav88
	z3F62CiYUIe4w38nrZqPSz/x+Uca/8LPpSTqUVrbC2vf+MdaV+bpTyFrg05XUAtB
	B3M7AUCtRd1OANkg0nNQSSStmbmlAdin/TrJ/Y1X0zb8u3+Svl2yvFwiJGX2S+lf
	Yy8oXSi9SqkCgzJiCJL/7BIDxye786uTWcG1xdHO/ONL3+Cme4YJHQkRJmw4TH6e
	0pqhq1WLr0M0qhxdeh3x9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1773362850; x=1773370050; bh=x
	GOrm2m9mt9eD9zeGh+FgoHjVnxN1Npoe+4KJW4hbgM=; b=OlXvAtNGHI5ULo/6q
	P/Vj6urZdgs1H9LmeFtWV92pQiyGGsFsQLzw2hqtOML7WuKq6gzXZmMNfTa/b4aH
	MvZmVk13SFwaVAzxGcqjAzAFz5AEJjlQaa261ykzd4mSt7ZkX/lX8B/uYUiaeyEP
	z6UO2DmP5pMfz7Jp/O81kXT+Y3S2m7AH0ogPR58xpqGpBpKCeeIdF7cHIPa3hoav
	MXBVERHJZmLvfmcOJ+U4kOuXPqmtq103L804YDCQoS21cXOg8POrnxQA8jH3Ju5z
	g57pDN5L/F62MOFgw62EHoRcXWNPOfLKHcdo0MDyH6W7fyzS1k0rTYgkJiYfEtQa
	1uMfQ==
X-ME-Sender: <xms:oV6zaboT-8MhlvM6Xz475HB1hg9zMLtSOgTqPR4LXlyPmi2A-yYENA>
    <xme:oV6zaZU8txd4XB7OgYvS_4IurhNMF6pE-B7Ip4wQ8Cjia3fu29M4HmhqqryPfwqpY
    awSk1H5tgruQnRHG6Ispz2CDUFNr8kBgkKLrYS3NqFbBukO0g>
X-ME-Received: <xmr:oV6zaTS3IL8EXj6uvTxrGHWZMDecySB0TBa-eiGz9EKMlHJSAGr-lqcwLLZlUbuXn1S6-6sfFom87H5hl0ccaRyrNVjLrabYKBHrPprD68FZ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvkeekvdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhhrggfgsedtkeertdertddtnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    epveevkeffudeuvefhieeghffgudektdelkeejiedtjedugfeukedvkeffvdefvddunecu
    vehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepnhgvihhlsg
    esohifnhhmrghilhdrnhgvthdpnhgspghrtghpthhtohephedupdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpd
    hrtghpthhtoheplhhinhhugidqgihfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqthhrrggtvgdqkhgvrhhnvghlsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqnhhfshesvhhgvghrrdhkvghrnhgvlh
    drohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgv
    lhdrohhrghdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlsehvghgvrhdrkhgvrh
    hnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvgigthegsehvghgvrhdrkhgvrhhn
    vghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqvghfihesvhhgvghrrdhkvghrnhgvlh
    drohhrgh
X-ME-Proxy: <xmx:oV6zacWY73xxMFOQDOXLtIbs5LR2ejohsnXf5jbS1BTrOfSzgG3SXg>
    <xmx:oV6zaQYnGcXiD-IEvcua5KtoNksLYQSzx1iaFo7C64VL8updGP4uCg>
    <xmx:oV6zaS-Jfz98K5xpk5Rrx3AwPZe-wK78qyWo8PeAg-8QdUpaAOJiEA>
    <xmx:oV6zaX776T6u4_e_FxlnZGE2g7fK8_GaMUQScUWS_oHZYqMFyRyrqA>
    <xmx:ol6zaT3J8BxyEi7B82ISNITOYfoZ0-enmJ3d10BRhSoJHvRNpAleM6dD>
Feedback-ID: i9d664b8f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 Mar 2026 20:47:16 -0400 (EDT)
From: NeilBrown <neilb@ownmail.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>,	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,	Carlos Maiolino <cem@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,	Amir Goldstein <amir73il@gmail.com>,
	Jan Harkes <jaharkes@cs.cmu.edu>,	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,	Steve French <sfrench@samba.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>,	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,	Tyler Hicks <code@tyhicks.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,	Jeremy Kerr <jk@ozlabs.org>,
	Ard Biesheuvel <ardb@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	coda@cs.cmu.edu,
	linux-mm@kvack.org,
	linux-afs@lists.infradead.org,
	linux-cifs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org,
	ecryptfs@vger.kernel.org,
	gfs2@lists.linux.dev,
	linux-um@lists.infradead.org,
	linux-efi@vger.kernel.org
Subject: [PATCH 22/53] afs: use d_alloc_nonblock in afs_sillyrename()
Date: Fri, 13 Mar 2026 08:12:09 +1100
Message-ID: <20260312214330.3885211-23-neilb@ownmail.net>
X-Mailer: git-send-email 2.50.0.107.gf914562f5916.dirty
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
Reply-To: NeilBrown <neil@brown.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uhfxq1cqrp36xctaaom3f1fksh1hdczo
X-Rspam-User: 
X-Rspamd-Queue-Id: 16DB5A000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773362851-450741
X-HE-Meta: U2FsdGVkX19Ml7AuMrptPktppAPVDNNTkMb/8IQ9KFbhuhLhhpax/lrFxCq4A9+JPTIHJIrPrL4LrlXkKDuJjQu9Cp1MKn3sh4A19zCbQHg0SFISOSadkGsPeZRsqq60ukexYbxToP+prUzd0J8C+F05sFKSbl210MOcz74xtLUY3xcbTKPxcsqR0yhKkXaepAx6VZmuUhUbMG3XriCKxUCAgvAlRKeKoaphhjukoBAwFY9yeq/UF0NNuCGg9UqxtxCi3tlYDqI/fybiJgj7AL182eADZVnHdRBgy+Ry/Rp7Xo9RW/N/KzhgEp2XY2X87VKjIOdXt3lo0ykoLWDIV2dsSAANbAPlt+p01I4smVbdVOGklYx+NfAHjarlWfucNK1hjF685PgPlU5ZfHBwdx2x01YvaCzpjL/M0iK2z/WsGWXxufABSY+BJC5WYV/WV/SSXzlOpg3HwAdSIv21qNshrebyc/ZVSIPkxiyV9gkDe8zaFEz3BG6+Hoi4Qr+yekvHD0Ytqw0jx4fjqcnvMg1DR8HKwnsJtyFn9xHj1Xf1jp8Pa9M2YEBW0o0rDMoEmhR2Zfv3Z/axeojHVe1JWvtuV0PpGKnfDXTVY0QbvGz3aGZg+PYRBPiK5DUZYfSnUi8TbP5/pCug1M/QtQans6HId3RpBSOuC1E6ado3GRA9W/UVBaPdiyo8ANiMNz2qI/ergEkIZOr7c5xkf2CPvG1ExDji2QVk25Hd9gVRdR9/zd4hTbqd1biZojM5wUf6AzoQqAv/xcdesv+RRPjy6xOuja+tfrc8CdaGUP0kk94mzYD+qk7CNdWKywISn/TJtTj7s81DdP2EN78KPeQeYaw7b0qP/ZWEKpzZqU7k4bUncldpYT030uzCKW8CN1EulMbqhEUwOCUucgd9fjkM3Z9/94lJeGWTwN6jGNV4OnHEah5s139ha4AoMZN/erWv0TLCkDDmHhzBl8JtsHI
 4N8UVsjQ
 IbauEC3RvBiJc7cjSVfZ+0eipXXaw1WYAbudK1JcKk2btUJ4jrpMy+U0CGj+lK6iGRhJ3ZuZGNa69SipiJK2D3uKgcQR4XVPRuvEXe/5b//0V1WE3OnIQ9r1ibDLu9cVIKp9+/WVbHtC1T30OgX13fE18exq2nn3AOgbXoIAU6QP5XJRvsGiGAd9yZXFxN8be+ZaKyax8+T4FXW/FRFP3p6xBREykrXQn2e/hjgk/EbP5iISbZUxNq5CaoGQ1pfn33MkO2s9rU+4MFPdK3sYpOAIsECUVwntGlVreL3yWtIJ0Jaq/UiRsg37T6Yv+10kkgWMzC1YMWsgs3ahrF8TePDjAu3u+sptGxDuTfs2LSXkZu7MFXba7rWmgV9QlXr3+Qdg7q8xAz1Kbv9FACh3hHBeX9um1mMCq9NvF32W736jZINYfVpMjtAqiaA9f1vpcLqimPr1ns9J6cRhNLZbcDLFNWh1FFne2EJ7WHf4ow/E6w/m61327u3CwjH5dCXxeIseUcoTunylFgjtOuvlm/qDl1xjVDe1S5nC8aDV5FNUqD5a0THuSU5BnC5XYxwG3ksSQLFZfLsHLDkv8ICb2+uenKyqfPx+fAaKXMZQp29ySsXJaMDl6enkfy0wwHFKF/XtPapW1QxZbmmH3T+cc/DLvT54xl8ymz/MEGGHzZAMLksqgdc3ua1BYmGBXy0cR44JHmnD3jknn9vk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: NeilBrown <neil@brown.name>

Rather than performing a normal lookup (which will be awkward with future
locking changes) use d_alloc_noblock() to find a dentry for an
unused name, and use an open-coded lookup_slow() to see if it is free on
the server.

Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/afs/dir_silly.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/afs/dir_silly.c b/fs/afs/dir_silly.c
index 982bb6ec15f0..699143b21cdd 100644
--- a/fs/afs/dir_silly.c
+++ b/fs/afs/dir_silly.c
@@ -112,7 +112,9 @@ int afs_sillyrename(struct afs_vnode *dvnode, struct afs_vnode *vnode,
 		    struct dentry *dentry, struct key *key)
 {
 	static unsigned int sillycounter;
-	struct dentry *sdentry = NULL;
+	struct dentry *sdentry = NULL, *old;
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct qstr qsilly;
 	unsigned char silly[16];
 	int ret = -EBUSY;
 
@@ -122,23 +124,38 @@ int afs_sillyrename(struct afs_vnode *dvnode, struct afs_vnode *vnode,
 	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
 		return -EBUSY;
 
-	sdentry = NULL;
-	do {
-		dput(sdentry);
-		sillycounter++;
-
-		/* Create a silly name.  Note that the ".__afs" prefix is
-		 * understood by the salvager and must not be changed.
-		 */
-		scnprintf(silly, sizeof(silly), ".__afs%04X", sillycounter);
-		sdentry = lookup_noperm(&QSTR(silly), dentry->d_parent);
+newname:
+	sillycounter++;
 
-		/* N.B. Better to return EBUSY here ... it could be dangerous
-		 * to delete the file while it's in use.
-		 */
-		if (IS_ERR(sdentry))
-			goto out;
-	} while (!d_is_negative(sdentry));
+	/* Create a silly name.  Note that the ".__afs" prefix is
+	 * understood by the salvager and must not be changed.
+	 */
+	scnprintf(silly, sizeof(silly), ".__afs%04X", sillycounter);
+	qsilly = QSTR(silly);
+	sdentry = try_lookup_noperm(&qsilly, dentry->d_parent);
+	if (!sdentry)
+		sdentry = d_alloc_noblock(dentry->d_parent, &qsilly);
+	if (sdentry == ERR_PTR(-EWOULDBLOCK))
+		/* try another name */
+		goto newname;
+	/* N.B. Better to return EBUSY here ... it could be dangerous
+	 * to delete the file while it's in use.
+	 */
+	if (IS_ERR(sdentry))
+		goto out;
+	if (d_is_positive(sdentry)) {
+		dput(sdentry);
+		goto newname;
+	}
+	/* This name isn't known locally - check on server */
+	old = dir->i_op->lookup(dir, sdentry, 0);
+	d_lookup_done(sdentry);
+	if (old || d_is_positive(sdentry)) {
+		if (!IS_ERR(old))
+			dput(old);
+		dput(sdentry);
+		goto newname;
+	}
 
 	ihold(&vnode->netfs.inode);
 
-- 
2.50.0.107.gf914562f5916.dirty


