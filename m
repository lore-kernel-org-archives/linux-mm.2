Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FDC6CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:55:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D166B00A6; Sat, 23 May 2026 13:55:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7543C6B00A8; Sat, 23 May 2026 13:55:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6911A6B00A9; Sat, 23 May 2026 13:55:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 559AD6B00A6
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:55:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E43541A0BD8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:49 +0000 (UTC)
X-FDA: 84799437618.08.C63B120
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F02840011
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:55:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7D2ybPr;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yB2akKGsW8OhhHQjSAQNazF7z15KfNFtO0Wg450/3lA=;
	b=tzqZYTnHagsaWD0TSyZZfmlBVspd2yKGvOMxWxCRU2qpPRW2w2iFXxORWkcPt3kUFi9Xls
	ta+f/nDKyZ7YL/VgXQ8/+uu5nEtTNVr21wG818vs+FWMPKM2drPxpufdVVUeBjftwy0UIP
	h7Cb4+fL/35kvn14jFOD+v2sZHhV/KM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558948; a=rsa-sha256;
	cv=none;
	b=iy6i/u+/uX3qWMYPAmZ2K65DB5bUPT3a6Q4+5lM/fm2FrzECUcCnedmUyuWFZ/1wOFkv4T
	8IZ/bd5MgKQVrtc2MXpFMQpVWDq2BFljvYsu1s2j1jPxGCj07Q2LaYV8BZJIMZRdTPZr+f
	vBfF8gm1y0LjiWcBz5lSIoNP12cMgIA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d7D2ybPr;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 609C941A8F;
	Sat, 23 May 2026 17:55:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484671F00A3A;
	Sat, 23 May 2026 17:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558947;
	bh=yB2akKGsW8OhhHQjSAQNazF7z15KfNFtO0Wg450/3lA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d7D2ybPrqTXa2BX5BRBj5trjjELM1QO8HUQHB8PickiWyy8mZxEWuS5gG1w+Cl7Uy
	 HER8CMshtp3q8ixb+8UkyigX5UBOVBE98jLaoBkGBKPIXVaYANzk4YXHUfoe4OXN79
	 xW4fhVINDce6E3jAU4Xai5n3r4y5DApu+mnEG3zTAoIGygmccs2LZ+VI8QEuVDFj4e
	 nKsQlBUUtxGPAWg0DTy8gIDU8KAdfCFJKYgwGZYp3XtoDiua/XRmxDlb5rj39iDzW+
	 z1cf9/nRffFe1GKNVVbTa+W8bsuFDG4DWE1yHIDqMFcE2P+9dvdhMLon7+iYFqAkRL
	 npBGpF3iBQjyg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:21 +0300
Subject: [PATCH 09/17] jfs: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-9-275e36a83f0e@kernel.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
In-Reply-To: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
To: Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>, 
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, 
 Viacheslav Dubeyko <slava@dubeyko.com>, 
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>, 
 Miklos Szeredi <miklos@szeredi.hu>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, 
 Kees Cook <kees@kernel.org>, 
 "Tigran A. Aivazian" <aivazian.tigran@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org, 
 linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
 linux-ext4@vger.kernel.org, linux-mm@kvack.org, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F02840011
X-Stat-Signature: q3wpdjiuns5zb4zggu1ihsmodeiiau1n
X-Rspamd-Server: rspam06
X-HE-Tag: 1779558948-775921
X-HE-Meta: U2FsdGVkX1/2PgrTf5nj4mov5RgEnHyyrncNnNehNnKk1l8ICAmR8inABW0ir08/g2EUSu27v4pbrDeud0bCA9r0PyQDqaEYqbkvtkqwxqpxudceuRA2AdlF4j0zQM5C8MzvZxWmwiwxodjZe/QDfUqJfRMC/R7SaXBTET1rxG7FWDMq7e7aM7awkAaIScCkN4Gjxz/9NNm8VJVEP+0sSa/gVfZcOqc8cam/9swefivXvXGkrAsdrsajSZgWapu1iCwmly1DONOPHknURlsIXrtUdYtk8rfxPQBILMbWFNBHoIgnfBF2chbVNfXnJf8n5WXhQwxG9UKdT1NF9+ImtEhH/Iq93ORCNIbQX4lL6f8IzW46OcllMjZb4sTvsVokmamg90txRoO65c5cX9xggAOEvY45WB0yCfAA4MuaomAvLTYO9rg2qzSXpS43BW4M94pbQIpEsNtZTYicIpMqUUqL0XXicmqp3GLvcXG0MpmKusG7YmwDvrOEg4FA08w0kM52ZYE2EPWSXvbPLCamYH/OWjgiiLG51nb4piZ88dfA7PsfjadnyNLYtqOMLXu/leI1EcOxOVHvw8e8F1ewfq8Zl4qzu36MxkmSIQKSyo7jWjFINNmePwPQya1UZVihdtDHbbswsfdiuJqaOB+1rdMKv0WwASwUsbr3ck/CwkSPtpWduCIXii+zIDp+5JpJuTlX+LQmDk1RtfONSccsyhlKwnkkL2KfIRCFkcm4PECgHyou+wpNuNpk4tmaET/B9Ft1uTADaFmnKhnvUqZo17xUnTTFrvLjTpuKDU/eQNuVIkYjwGf/jZZISLTjqLiwAtl+be5NVq/NQecSWQegjcdG0Qi09AYwquHg+iO5hDZFWyUJCaPvibV7Azkf4P1ZNtULevP8O5xqaZKZywABpVcZ9t0l5LlJrntTsdOSPwVLDhiuyqltXAFRNEmvMo+LfOdEBal43HhVuga1bng
 n/okGq4r
 fwi+RqWzvbD+c12hgZl+1/Xe0z/hp7haFJj4bhRnLnZ5Wh4L54k3Dt0F5LFZrEGdqV4BN6/CJ+OJH6wxQtmRDyHt50HzeScfcvadKLDp1Y4zdfisxEiEEgfM+r956jerUfzUaOXoi0itK2UPUHyqn0BqO/4r2335SMGaMl107iMWOedtzIyghp62+mCCKscq3A1xXlq78gF0O2+rufN9MV0kLDnUOx4JN6+glywXzN9VKl9kFrOWMAbS2EfkKQnmhkRjU8kzhf2Dmc5Q5salN9NfdNpG59dSvMmmnt9BoNL9VWoQe308DWwNuHmzjncqnIFY2inmusnfE02fHXHNmCpQQuP29eV7YtgGD4vEWZ06Q5EiBZSQvvluP3UV0ZLQthGA7TqndL2ERtL4tLvmGfEMWgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

jfs_readdir() allocates dirent_buf with __get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/jfs/jfs_dtree.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index ac0f79fafaca..8ce6e4458cc2 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -2729,7 +2729,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 	struct ldtentry *d;
 	struct dtslot *t;
 	int d_namleft, len, outlen;
-	unsigned long dirent_buf;
+	void *dirent_buf;
 	char *name_ptr;
 	u32 dir_index;
 	int do_index = 0;
@@ -2884,7 +2884,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		}
 	}
 
-	dirent_buf = __get_free_page(GFP_KERNEL);
+	dirent_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (dirent_buf == 0) {
 		DT_PUTPAGE(mp);
 		jfs_warn("jfs_readdir: __get_free_page failed!");
@@ -2893,7 +2893,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 	}
 
 	while (1) {
-		jfs_dirent = (struct jfs_dirent *) dirent_buf;
+		jfs_dirent = dirent_buf;
 		jfs_dirents = 0;
 		overflow = fix_page = 0;
 
@@ -2903,7 +2903,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 			if (stbl[i] < 0) {
 				jfs_err("JFS: Invalid stbl[%d] = %d for inode %ld, block = %lld",
 					i, stbl[i], (long)ip->i_ino, (long long)bn);
-				free_page(dirent_buf);
+				kfree(dirent_buf);
 				DT_PUTPAGE(mp);
 				return -EIO;
 			}
@@ -2911,7 +2911,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 			d = (struct ldtentry *) & p->slot[stbl[i]];
 
 			if (((long) jfs_dirent + d->namlen + 1) >
-			    (dirent_buf + PAGE_SIZE)) {
+			    ((long)dirent_buf + PAGE_SIZE)) {
 				/* DBCS codepages could overrun dirent_buf */
 				index = i;
 				overflow = 1;
@@ -3014,7 +3014,7 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 		/* unpin previous leaf page */
 		DT_PUTPAGE(mp);
 
-		jfs_dirent = (struct jfs_dirent *) dirent_buf;
+		jfs_dirent = dirent_buf;
 		while (jfs_dirents--) {
 			ctx->pos = jfs_dirent->position;
 			if (!dir_emit(ctx, jfs_dirent->name,
@@ -3037,13 +3037,13 @@ int jfs_readdir(struct file *file, struct dir_context *ctx)
 
 		DT_GETPAGE(ip, bn, mp, PSIZE, p, rc);
 		if (rc) {
-			free_page(dirent_buf);
+			kfree(dirent_buf);
 			return rc;
 		}
 	}
 
       out:
-	free_page(dirent_buf);
+	kfree(dirent_buf);
 
 	return rc;
 }

-- 
2.53.0


