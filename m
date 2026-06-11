Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 577CDCD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCCE06B00A2; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D487C6B00A6; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9028A6B00A5; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50B526B00A0
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06F2912075D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.22.55903A4
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7196D4000F
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UhBkNafF;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s1gNw/K1WJ91+vN2vqA2s83/uYPgBvrrPGXNO3wV5Yg=;
	b=zZshNHZp/3qClP+/xs0stFDissDlXxU3O3eWxRNVu912ev7AYzZNnoVyyr5vut6KwIf/pn
	zawC5Z/6jiotRLPbMg2OLNiCxUzwk3DXTtUGup6qdf6dbXFAyLuxkEwaL2+LsRsqb5BGDa
	lnHHjZ/jI3g3eYg83JxGmiOjsbU46Mo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=UhBkNafF;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=ptcso6z1UAeA0hqFLvfcawRHOoq54Oipi6oNLO6vbBA5/mWeJTy6sV8Ko1Yxs5b583/8Xr
	H5ibIUYlu3zH5K3BIlkIUMibIkz5b68FBpaVPmET1TYFD8/SiC2jL/GhQ0Xm9740HOxrKI
	u/iDQ0s7P3vmFG+tUcMM1j5APLOojNk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s1gNw/K1WJ91+vN2vqA2s83/uYPgBvrrPGXNO3wV5Yg=; b=UhBkNafFMz1IkBc1qFG9mPtybm
	QbH0maKdnXLXjeYkHN2VKG3Dcin8im3z94hjM+YNRUpZfznr1elwinDzKGDGGFjPJJlfdkG6Qcfpe
	3LrYMuXI4CmMijayuBA83jVNurL4ijlqiw1rUKDFo10QyC5a6F4BPSPWxJYm2wS/BXD1vbAUBTuDt
	1UQwZJpSPtmyO6XZyuLSCGuReE5zCV/kCP4K1wDUjwVJAc8VGviL3GyC1nD13GTQN3MJ5w+wbeQna
	2JS9J3DosOH76pVdq4E5KKiiqlhoysLDpXp60TmkZoJTm0ll8VbKXcPLodQiqqyLZSmx2oDnzkjUw
	3XTur6PA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070mt-1c5q;
	Thu, 11 Jun 2026 17:14:26 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/9] make mnt_cache statically allocated
Date: Thu, 11 Jun 2026 18:14:20 +0100
Message-ID: <20260611171425.1671254-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7196D4000F
X-Stat-Signature: tutq1wd5zf5f8axzkxi9bi55q4tfqu4g
X-Rspam-User: 
X-HE-Tag: 1781198067-210099
X-HE-Meta: U2FsdGVkX19Ayy/ldi6dzv2dYqLR0xGRlE5CyPym2ywUHj55Mwf70OkDDy3gVaIu2I/jCdoj8Y3yvSR9yKCP76L9Qy8ql1AIsrMcOBRNOhMtkeGQQS5foTET6ClTZcyeb5fka9X8REqY9K4z0sWW09hV5TS2t/1hddicrAJqm5OHH7Ryx6Jmjgq5RLmgeazH4/LEfNB3RiSKMwHlUUmzay3SDL2vHiwfGe9OeAFwcQDZ5rOWUXeP2FxT7QFwB3stxbvgYgL/L0srMDhDI28BBioUQ/daLeTCOEgv6DcJ/NmV0BPnR3UVjxaXkSB+e75h27+9CQ9/bugHReONIfGjJmrrDS+uUDgHO2q76ErpQACr77SudmWZpY9l8BEodSQ3PFmHYB8ufrjK0dyjapGWGBYws5PwCdCynhwF1xSHwaxdInQucEZ9V2yDAz0gmYGweoSR3G7Ro9GuMUrj3GdN7jRaZG58/AqnuUndP1DlUFbsMybX07edc7JfcAFuUYIfUBCKyFkFH2cJfzImlX4qfBeSNqNzFyAMJy54jYeJtSrANMB6wA5LUe0D4IrwDXZig4WcYe/WXxCqHoLrsPxOy5+jhf9S+1Mcmi7F9d58oAXN8WuOU5iuycd9ICWcjrr5XSmu98YqSVtBCNx4d+Aw6g1O6LvL/9pIvIXVb1idZQ7pBYAKsS5vLwny0ri0se/lpSUFu//iNRY35wR4ZXSp4wM41FZEBBB53Cej/GDDj0/2cPL41YGGJyOGFTPWCK6edO8+X3LaTxAKKsK1O/RkG7d6NM/OQdUvBz6FF2gnZyWI/ej5+UkJ+S9ULqcntKBTb2RRtR8bVL1ap/34ErLoC/KZNRy8DlQ+6h10am6TQPpW5gd2rkszVqBnRb4O5WXuSV2sOPnt7GfwkbURpemr9RZRJ0Ud/M9FOlOmqGy0wHP2p4ARVf7WLVLE6fDmKBt1O6PLRKybbjXNxIoTgDe
 VR+Pu1G/
 fwx5KvVyOWsSvzfMpF+4L36f8c3Hg7sbD4IRjhhoeQlaF43c1vo51kkM5urf57edMWMqRNSpF9P0eceQClDlshQxd9aurgkepxp6kRwGniCW81vLTf2u3a5yZTNFqVrWMVM5st31wdZBIyoYQcdTDqPc9IQfYCZPwq7OYwe3GWp4KCOdRRxM0XbTzJ77x0v74JMyeZJdcyoM8pLsgDRGzZ4UnQT9IMF3drXcUQq8KO8WFs1cEQsdUY6jEcPj/KvGPWJ2pmBvJnwSi/1TmDo8CYD1oVHdcSg5NAT6SEoVJDGJ/FBO/e9pfG6Fgfu9CahHooAn66XJE0vukWzE66f8S99WzPqzAjucGAWrXFB6wqd0gd/zCDwyFFveOAAgCts22gJ/trLNvkTbUENkEZZ+VulY/bKSN8QFe/hg8gs9Qbz7QUDDUofKST4zkEVGRapaDqhl0aJ3WfAsmXGGpB4dGCz2Q7bCYucTIazNJ9/ppMaC7OWhX1leLPTcBJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/namespace.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index fe919abd2f01..e03c3e7e0a36 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -34,6 +34,7 @@
 #include <linux/mnt_idmapping.h>
 #include <linux/pidfs.h>
 #include <linux/nstree.h>
+#include <linux/slab-static.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -79,7 +80,8 @@ static u64 mnt_id_ctr = MNT_UNIQUE_ID_OFFSET;
 
 static struct hlist_head *mount_hashtable __ro_after_init;
 static struct hlist_head *mountpoint_hashtable __ro_after_init;
-static struct kmem_cache *mnt_cache __ro_after_init;
+static struct kmem_cache_opaque __mnt_cache;
+#define mnt_cache to_kmem_cache(&__mnt_cache)
 static DECLARE_RWSEM(namespace_sem);
 static HLIST_HEAD(unmounted);	/* protected by namespace_sem */
 static LIST_HEAD(ex_mountpoints); /* protected by namespace_sem */
@@ -6234,7 +6236,7 @@ void __init mnt_init(void)
 {
 	int err;
 
-	mnt_cache = kmem_cache_create("mnt_cache", sizeof(struct mount),
+	kmem_cache_setup(mnt_cache, "mnt_cache", sizeof(struct mount),
 			0, SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
 
 	mount_hashtable = alloc_large_system_hash("Mount-cache",
-- 
2.47.3


