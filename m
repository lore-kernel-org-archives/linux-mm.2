Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32DEACD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 17:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 979936B00AC; Sat, 23 May 2026 13:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950086B00AE; Sat, 23 May 2026 13:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88DD06B00AF; Sat, 23 May 2026 13:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77D9D6B00AC
	for <linux-mm@kvack.org>; Sat, 23 May 2026 13:56:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EACA140B66
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:12 +0000 (UTC)
X-FDA: 84799438584.10.EB446F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 939D114000A
	for <linux-mm@kvack.org>; Sat, 23 May 2026 17:56:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vemu1kcE;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779558970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jKo+LttHIUD1A+iCHOd4XzHNPdNF0nPTlnjXQ41S2wE=;
	b=DYEL0XHzIYoAfzUim0vgwkRDVmKcKEcBQ5a6ZUD6bzrK2iNAX8h00BDC6oe7+EL+spCPop
	fZycCVPRrGHdN0vOaVcKYgPMvci7o4RCMx+H8EmOIpdCT7YnfJlBcDLK54CkvigEJZw3xH
	crArkagp9aJxln7xrLwnzqo+m/WxKSQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vemu1kcE;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779558970; a=rsa-sha256;
	cv=none;
	b=wYjSehKeuCEsdZyL38Yadc57AJt+MH0NDdaigVRXuP0ipIKre449ueZsPFmB2As2zrE7oP
	N3opdwbRLxadN1sO+0BUJ6Tp3Wqa6DoIU+aa88KhvSL33GosQLFcrQfP52xgkp/Joe577j
	smz2n2q4ujtU3UcUS6eoqMvPsRIFJKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CD64043B7C;
	Sat, 23 May 2026 17:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60BA1F000E9;
	Sat, 23 May 2026 17:56:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779558969;
	bh=jKo+LttHIUD1A+iCHOd4XzHNPdNF0nPTlnjXQ41S2wE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Vemu1kcEUmxAiAsIh4TQkBUpCC3eZFLAlCkzcG0Ph2QDZmgnFcsh7HLo7bRLypN8a
	 4O7sRSwfz2Si3bQK2prGFIm51brNn7HbhUaf390IGY4RTpOK9E8GLQB8JKv3yIPy0B
	 3OdF2356XNi2W9iVTCP19aIpZ2waAUBqPL7ZzV+8B2EMdYa3X/q7R3kTltzAJrZtQ4
	 tRoFYGSZ+KINhrDUrwdsnLgD0fHos/wX1o4WYbKLoqZlRnjjBayViPqjymIH+D+ySn
	 8Bt6vC1T0wx8wpclGTNSjEIacKIfZ77fy2GThGy2IPX0jx4CLFYSPKZfbwpZORl5W9
	 3GQkT9VAlRXUA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sat, 23 May 2026 20:54:24 +0300
Subject: [PATCH 12/17] fuse: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260523-b4-fs-v1-12-275e36a83f0e@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 939D114000A
X-Rspam-User: 
X-Stat-Signature: f4dukjuqkuyp4p494srrgm38hrqk6mbf
X-HE-Tag: 1779558970-488345
X-HE-Meta: U2FsdGVkX19s0Vi9/izvVnowdwIHZ+GL+KJjtV9EH8nkiHpS95Im6eCjdYXAbUGREb2dNak2Z22XYFp/qfUljWIoNvh+9zgsVofAvsEqksMaRjMdrHpXIiac2Cx/xhLURuRjKWHOX0Qaeduw0dsA+Tax+ve/kby3Uey5fmxeABYy8ooDhRN3Xs6JjJRtxJadjqtnM95UNbDIengmxwjCROB+fRCJspSsPvxEtwli7WqSABmilz8o4M3RRa6oRIqbXaECk9FngMkR9UYwQSktFG/dSBX2+hcMT8YQHcZjsWTkE8S6skYn4ci7qMo1+hZAHqQqXvu+Ml9Mh5j4ztPyXtw6VrYuiva8p9PNhwvxyY/5m9MUx2vaH/wOYZJUuk9M1ufHtKsSb6wUuG9xkSK1CRwSzOOs9leKNW1X6Tmeab/vGOn+rkDMky2NeF9/3wzavvcJoMKhzQMnWRmCKBKgRWwzT/ELhhOuQCheTpGUs6N0rT8f5mf2kgzUbVEGb4mhPWT7KaFQM4sBzjXwW4cCmA1PaMqQtTaN4ld+O1J+JXF1XBS0Vja0+gPijQ/OdAe1Pt3Qrsr+vckfAw9aqXHZGdVHqUkNmxS93/R7q3uNILS2xioWa6sFxnZnTj+ILI+MhDO02yWv9SB9pIDPd3aWrdOAgq1wlpII7dSHy49ah5ksAMwmuuIPnjdoXjQuZ1h16C7CcYYwQrIMh/llXlky32vbKzoO9k8DmuluAqqwweEg/Axz1Rx3X3fB7sO5Nyy+M9YRaymKZxLGPtPPxBXYk7vVY2nfWkymslX//yeNapn6F9Qryh+UCytqIN+KRxqXpFDqTc3whhLG0QyTUpM5VTFC0GO1QXpGGAbFXPBM7IYlaC7H8LL7/w6cN66qzLBNzVIoMhsBkkRVl0hopyDkdG5wC3lgR5wQdPwEW62yqn9CuUeD4sCTNP305m9Wely5n5fzEoNHyr1DoNHia4j
 J/445/os
 +hirmOc4cCJbJp/dnWKFjsqULgmBcKez37FxpPfgYZulK5J++ZSKHpZsrlz8V5rRK9NFigmlD6rLaKhMjxiEj3ijSkNHCygpxzSc4pC3hUK6QHMe9aZHNNa8B3/WxP709G0G+Zx44MG9lE5W3qgJxSJReiyvtwrqjN904fXYdO+qD1WXNd54mAzU7sIAxQOR5wusQNOZ6oPxUzyGvd5gpFPPV2Cq4KxGqhZ1e2FqM5PnpNjH7jRI6WKOYkMlSQL6ufj2weQUbvDe5OBTc4zlyEdD7Gau7g0KuhlSBVquDjkqv0yPIwbWID/tasv/5l6aiVS8BmNi9tg1LTgrY1/j7dyge1lKpFia8lp064fydAB/HBPU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fuse_do_ioctl allocates memory for struct iov array using
__get_free_page().

kmalloc() is a better API for such use and it also provides better
scalability and more debugging possibilities.

Replace use of __get_free_page() with kmalloc().

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 fs/fuse/ioctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index fdc175e93f74..3614ea603913 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -10,6 +10,7 @@
 #include <linux/fileattr.h>
 #include <linux/fsverity.h>
 
+#include <linux/slab.h>
 #define FUSE_VERITY_ENABLE_ARG_MAX_PAGES 256
 
 static ssize_t fuse_send_ioctl(struct fuse_mount *fm, struct fuse_args *args,
@@ -252,7 +253,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 
 	err = -ENOMEM;
 	ap.folios = fuse_folios_alloc(fm->fc->max_pages, GFP_KERNEL, &ap.descs);
-	iov_page = (struct iovec *) __get_free_page(GFP_KERNEL);
+	iov_page = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!ap.folios || !iov_page)
 		goto out;
 
@@ -400,7 +401,7 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
 	}
 	err = 0;
  out:
-	free_page((unsigned long) iov_page);
+	kfree(iov_page);
 	while (ap.num_folios)
 		folio_put(ap.folios[--ap.num_folios]);
 	kfree(ap.folios);

-- 
2.53.0


