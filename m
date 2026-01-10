Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 686A7D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84AD6B0099; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A81026B0089; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA356B00A3; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65E626B0089
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 34F241AB79C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.16.EB47E52
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 66A65C000B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UCQfyOdz;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCWdpDl4N4sktQZ+Ts9iZqQsXsj7d3665CaBWGAPwDA=;
	b=ZutdTTYsW4WIoDkhIl4r0jTTRrfgQ7EmF7MmRhTbZGPv+0Pxiar0Doms9DgUgeWU7wqnjZ
	NqHm1jwcu/5Zw/GAiLIMpaXY8PzywJyF8u0Zx8Vua/FIIzSV3lq+jOu/2+lsNZkX76S6IE
	KZMAB4OIzWfmLhz+roKLNG2kMiL6bwg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UCQfyOdz;
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=3QOwqiJ6gBXPCpNjMxzxWfxi+h+lFQ30TkVkjFP9bSlTsy3yko8qbnKn0md68YHBZQbX3Q
	yICn8K8xBNNbz/lttN/eRalLpzpkLJ1pugXZ7r4opSzy5PS0xdPCcFaq84z06fi1DP7Hvo
	IJijlk3uSCw3kUHSIth5fAWc5Kpc6js=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QCWdpDl4N4sktQZ+Ts9iZqQsXsj7d3665CaBWGAPwDA=; b=UCQfyOdzDZjFMBc1nym2fqKTz5
	hEis14KZ+aFKVUiJ55w1Cjubl5boGYR+H5HZkYXoBp7+H7nn0gsaIrIRZuuItBCfabpEFtRGS9NCS
	ImpKNwREPXgDlx4eUtYTNsxxQPZgnDet1kk77OBiNPZkxlZakSP+5VRmE6oX3Ymnd1wrcf5d4wyRP
	dJprEz1xZYAvWD4W3XCZ7t/2QBEutEByZGtcso5I1zhbQg1+vZnJ3glOMXCTpmZ5Gy7DAzYj58Mb7
	WeAv16ORuWZtjaZDHIBVFSaMqScRQJaM3cCP02UwkfY1xAuAmST5nTeyS60QfTLoKZuQR7UwH7iDE
	d5ileZTw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085bK-3zxy;
	Sat, 10 Jan 2026 04:02:19 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 15/15] turn ufs_inode_cache static-duration
Date: Sat, 10 Jan 2026 04:02:17 +0000
Message-ID: <20260110040217.1927971-16-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3jwtso58nyrk9w59bgkypqok73phxzsd
X-Rspamd-Queue-Id: 66A65C000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768017660-104934
X-HE-Meta: U2FsdGVkX1+k8RYddtRXVMdDl2EG9k1cZ/HjB9+pq7e4dYjw+Y7v4l30kef3a4dkNCXjzZZO9SSbTqS0rwxPlX3cRa3KrMs21K/LR/sIg/P7tdbVTdMsWo4cluwYho2OMx1WkMgDVShv06W2L2JMfPEp+P3FnFDYYB+L/ZSTLH3d+WAKdlSCjFO0P2NUyYLJXOyhgUBPP3q25c8k00vXZ1ycKFe7bij2ojhSNg57kD9FBr1//mGcKFFCRnzqBjXH0vTN7mHJGbj9EjG5cGe8BVkqDThTElCskeft7cIPm/gDIzL6f9tpCrjHuoUFFVaM4Kvx1TzQC769skdYp2AllIdK1smiREeEXM4bol0SHTdLG0iRFtYhq335dgJgpMsB4UdsZHiB8StGfgq88F9UavYlSxhV3/sj2orZ58WZ1yXK9iZvV4qnFdDS/SJ6MtwS/pvN7ZBpBnDUnbCSGE+kve3QNB+Pxi1bI5cOZObk7YdfwwIP7HCtGbLOUFEPUscO4F/w+HZjq6/+i4+RUU8mjJNraIjYudSvucOQaPnHntzgpB6jnbIo3OJgLC0OoZnSh4j527GzszAUPWKUeAF8eECDENKOjaaJqZSLEjufavHh3RcZa2T7kWcT2LzAo3zXfY6nzgzVi7nUZjYaJWs9xCczVMSkZXhc6O2zMuCdsHmm1mw6Vs2zZpqijMjTXnMRxSCSC+ahkCDyvD9Vx+hscziEcBFBcexzv1s8anE8EJGFQIqq7oa2Z4oZN2EscgsJokvcvIyHMerRltIq8JGLJXUshFeGGZeebTKOslrAr9EU2Qj3j7xoHrW8iE9yVVn8mZncKCUl+QlMDB3gv9MVuJFIDAQTQoiBBwk5zSQa6ifePdnwMFa3mZQYszLab8UIn6eDe//SLJsaZ1+xrOcU+CWiI3l+k06zk2z74vAfA+/A1vCik5pUadgeQClS+z4lqZDWzHcqu2grCExKLFW
 aIykrO5z
 k60wgOLyJ9KHPy8ltds3JBeGYmpbIVIeRymkD1lOu/hl/YHM0P6cmMZL7xHcCwZhBk8QM2ApC9Y6xZxcILV27dsVObQnXDCgx0DslmD+qLA7wC6utR5dRHeA8ktn1kZbTmKsgUfuPG3O1c4KbxDhkczADhMrs/0v4VPx1HhWEoTDVcz0mewM/ZixWtzochzre+mS9YoGzsGenaedx2SBGG3PPgE0sCWTqlFbtoymnMuK845ZTU7RTh4AqlAOsXGmKa0Q5zUXqmh9clW8ynKhGW5zKTF5zreGa+21963z46egE6ep+RhSMd9wUYNSIkJT75EvaHfJuvrcBb275m+cHVucfYjN4bOHHBFLQHtMFVBJE39CpkN8vdc0/yTIO0frJGmpKysyzdzaKJAcVu/danoLRMO6v6Id04Ujf8ieYy5JdLWRNYEwPsBBQIXNF6HCwqbKYgpYDLrK06rOh/F6ObbTS2sylYMMlnpJIQfDmXoqWeKSvASlu+noGY/5Ta7hB7XrHPjX3u0GkY48KXFoFawxMhgvoe9rqN7Ph
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A modular example I used for testing...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/ufs/super.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/ufs/super.c b/fs/ufs/super.c
index 6e4585169f94..440229a5b6c9 100644
--- a/fs/ufs/super.c
+++ b/fs/ufs/super.c
@@ -90,6 +90,7 @@
 #include <linux/log2.h>
 #include <linux/seq_file.h>
 #include <linux/iversion.h>
+#include <linux/slab-static.h>
 
 #include "ufs_fs.h"
 #include "ufs.h"
@@ -1354,7 +1355,8 @@ static int ufs_statfs(struct dentry *dentry, struct kstatfs *buf)
 	return 0;
 }
 
-static struct kmem_cache * ufs_inode_cachep;
+static struct kmem_cache_opaque ufs_inode_cache;
+#define ufs_inode_cachep to_kmem_cache(&ufs_inode_cache)
 
 static struct inode *ufs_alloc_inode(struct super_block *sb)
 {
@@ -1384,16 +1386,13 @@ static void init_once(void *foo)
 
 static int __init init_inodecache(void)
 {
-	ufs_inode_cachep = kmem_cache_create_usercopy("ufs_inode_cache",
+	return kmem_cache_setup_usercopy(ufs_inode_cachep, "ufs_inode_cache",
 				sizeof(struct ufs_inode_info), 0,
 				(SLAB_RECLAIM_ACCOUNT | SLAB_ACCOUNT),
 				offsetof(struct ufs_inode_info, i_u1.i_symlink),
 				sizeof_field(struct ufs_inode_info,
 					i_u1.i_symlink),
 				init_once);
-	if (ufs_inode_cachep == NULL)
-		return -ENOMEM;
-	return 0;
 }
 
 static void destroy_inodecache(void)
-- 
2.47.3


