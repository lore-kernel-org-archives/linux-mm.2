Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 019D8CFD314
	for <linux-mm@archiver.kernel.org>; Sun, 14 Dec 2025 03:29:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602666B0005; Sat, 13 Dec 2025 22:29:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B2596B0007; Sat, 13 Dec 2025 22:29:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8BF6B0008; Sat, 13 Dec 2025 22:29:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 36A7F6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 22:29:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E09D5C09EF
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:29:41 +0000 (UTC)
X-FDA: 84216646962.06.6D86FE3
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf21.hostedemail.com (Postfix) with ESMTP id 469A71C0004
	for <linux-mm@kvack.org>; Sun, 14 Dec 2025 03:29:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=e9JlrV7O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765682980; a=rsa-sha256;
	cv=none;
	b=ptmrvTyT7rM+wnRwgZE5PN8WMZ5EPVxKapSBrARCHLXi55XaE8/nccaAPVNjHC0M62JZ17
	vR7eD27ET9+yocWxLjQqTYwl2wx8oxh40i5xKTivMLW9Z7XC8u2K6EHtWkv5SYnYr0pMxT
	NRF8kDSlsNNKn1L0sZ7/1cWwJVYHqIQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=e9JlrV7O;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf21.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765682980;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nE0cZnkh09VtJ5FOhMNWibUYyxBs+jVfTjb1515cegE=;
	b=iPRgkBFCl39564AqwO1t0kkWkoucIh9KWdTMpylslpijY3QeNxKNnkaB6of30Ebb+U69iA
	E7O8A4a+3h9fa2YyxdN2R/HxQtxc0SkuhIMZdFARuWOqaWQhN9ZdbyXAZwror3aogzEAJX
	vneyadhB3C+ZYJn2/g1PPdJH74cdTNA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nE0cZnkh09VtJ5FOhMNWibUYyxBs+jVfTjb1515cegE=; b=e9JlrV7OFkArFVQ7jktGJCTBdK
	HDNFyg1yNd6rDN47QJuD92x88JUfhqmwtRz2hEXmH28T9kwED/2zdz4pDEaPy5BHBp54uX2hDiou6
	N+b/+YrfpTKrXEkxGaOQ0d4dwutVuF4UfWC476aPYmEhZ1lc+80+GJheEHI/YvPVpE7HvN4DRmilK
	9lAzxrBOABTsarCtxvhjqvnRiig8q2R0TthUWoV5QL6giyTPQLualAwDA7q7HDfL75dy9ypix4I4L
	5iNuUil1e70OPMCiJjQhlZQBc+otV/H8qqwEhW4YD3DlsGXj16vKM7YsM37VftWlRnlUzW1MVpICn
	gDxGu2YA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vUcoF-00000001xok-1DQ5;
	Sun, 14 Dec 2025 03:30:11 +0000
Date: Sun, 14 Dec 2025 03:30:11 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 1/2] shmem_whiteout(): fix regression from tree-in-dcache
 series
Message-ID: <20251214033011.GA460900@ZenIV>
References: <47e9d03c-7a50-2c7d-247d-36f95a5329ed@google.com>
 <20251212050225.GD1712166@ZenIV>
 <20251212053452.GE1712166@ZenIV>
 <8ab63110-38b2-2188-91c5-909addfc9b23@google.com>
 <20251212063026.GF1712166@ZenIV>
 <2a102c6d-82d9-2751-cd31-c836b5c739b7@google.com>
 <bed18e79-ab2b-2a8f-0c32-77e6d27e2a05@google.com>
 <20251213072241.GH1712166@ZenIV>
 <20251214032734.GL1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251214032734.GL1712166@ZenIV>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 469A71C0004
X-Stat-Signature: qcmeip5epfnr1gf5niznqhsowrjpgawo
X-HE-Tag: 1765682980-830294
X-HE-Meta: U2FsdGVkX18pGIP5f/mmRcSF9VgD9wWMM0+31K/TbwTsG9uzSj1Zm0Bw4QMmQZfv/0/RVdvJUzBK6ec6wKAA9ngryOLLuV3jUB9WDs594At43ZlnNXDS0clR67ipQX7gQTJzGGK0WE6gmJmcKHxmQcnKPeGz0kBW0zpCCbLlslbINECs4sqtCEnIR/8hrdsz29bKSioMVQ+9jQSRq8enDhLYWwN6p3GApxFFd2+2y9udYZXO7f6aWdD5EFM3U9oc0k9wX0XhURutNMsFRC7idT/TcbNXY6G2V/i7kW1pO2J6mMFpEenC+GVW8YfryXiYFKT8XRYSwY4MdTFBMhVzdHPNl2m+jHGmfqd1hWWA/BE1kFCfw1pKGllTzBiug6fg+vZeoC8tpD5w0L39zuhBcsBHGF5o0oCPBgbl6XOXQyyX22FGld3g+6UKsiKvsaEJPyn61lI/BDtqBDgCibZhPEDgZL4bapwj58sGmsOPR22o6nkBZMdn0hjArolxGF7M/yAYp2BJK8TlH7uj8hU1qGpLX5qvXS2VH565rq7qWUbJQ3VWyclzr681k8eLEs0pNrn55XHvUkuRGmkIWkFol/g34Z8r+colwaKpJ0Txw4ogJmJuOfiifvkyDFvkqC+pYjMPPiNpBbElHwC53q50ZluuSiUhZ9103RI0FrmV60gP6t9FQ4CgLUSaWtpTkQ+vQYUhaM4R0ftqg0tipH3MpZw2orN4jtDIZbL4vAHjlzWAJg+CgA4zcY5jIvdyK0OjVgbMWt9j/ql8mMefmUdUs5JNvqDQC/URVRkWRMVh8xjmXFdP/hkk0LDeSyxw/ePR6NEASfwKLHljCD6SuVQMMyhowX+koPDe1qErQBZTX69L6m4lSfPDDO0gB0soO1rcCqvzq2qgIKmVJGHutST4Bikcofij3AzYeNUuGw5pTILP/kBLBF6XXTb48Y3XvimQ0zhUnLr10mplWl299lR
 J9XeyMXs
 EqQS0ainIGTFtjslwz3XbyXIbM+BBlrVSiAAgssdmMdKdUizUFYTKh2Cho1MVBAO3JbwwvR24UwHWKZKZaeLn83c/IFRiyF71FfbX9VDCcqe+qAAcO9WP3X6wxspYcK5gWGt/cP/at0iNFfvil2HxuKXSPB60Ma199f8ZswEB7Xb/zrpE98y8pJoO8OCZOJkIaHs4GPCvmTAx8oXsfjFqqsbSL0qkH+vQ8RRsLjSLrm+Fa7NmrjiyM/ML7CmanTFpqDLqKWzQK6Z4+qGBMaN+GLCOUGCk2IH9GLLYpNXkIzYG9lvnKe8zQ6aipqe5JrENyDe9QurNMVAyAmIyrEPBuaiOi2hL0DPGZX9f3xs2y8bXp4IKpIz/hRrrWadZ15neHB0s+nfAKcEHkDbsUDjjN6PVmnpsCUT7S+HIlgDMdHXHZxGDEi9FrXFGOFCvWikHmCaBshyKVlvQjBjJDWkWrK93J7aVIpjQBvx8atUxdDN27EAMqu37YSzuOYo2mkteooSLX5NqaMtYLcVraPf3MSwXiOQm/iUxzfneJCiw8mAVwaSFuL6wMmDWWcMvnOl5zGlr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From 3010f06c52aa7da51493df59303ea733a614597b Mon Sep 17 00:00:00 2001
From: Al Viro <viro@zeniv.linux.org.uk>
Date: Sat, 13 Dec 2025 12:36:15 -0500
Subject: [PATCH 1/2] shmem_whiteout(): fix regression from tree-in-dcache
 series

Now that shmem_mknod() hashes the new dentry, d_rehash() in
shmem_whiteout() should be removed.

X-paperbag: brown
Reported-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Tested-by: Hugh Dickins <hughd@google.com>
Fixes: 2313598222f9 ("convert ramfs and tmpfs")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 mm/shmem.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 3f194c9842a8..d3edc809e2e7 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -4019,22 +4019,10 @@ static int shmem_whiteout(struct mnt_idmap *idmap,
 	whiteout = d_alloc(old_dentry->d_parent, &old_dentry->d_name);
 	if (!whiteout)
 		return -ENOMEM;
-
 	error = shmem_mknod(idmap, old_dir, whiteout,
 			    S_IFCHR | WHITEOUT_MODE, WHITEOUT_DEV);
 	dput(whiteout);
-	if (error)
-		return error;
-
-	/*
-	 * Cheat and hash the whiteout while the old dentry is still in
-	 * place, instead of playing games with FS_RENAME_DOES_D_MOVE.
-	 *
-	 * d_lookup() will consistently find one of them at this point,
-	 * not sure which one, but that isn't even important.
-	 */
-	d_rehash(whiteout);
-	return 0;
+	return error;
 }
 
 /*
-- 
2.47.3


