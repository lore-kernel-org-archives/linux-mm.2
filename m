Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFAB8D277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:19:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AFA96B0088; Fri,  9 Jan 2026 23:19:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05D306B008C; Fri,  9 Jan 2026 23:19:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E316B0092; Fri,  9 Jan 2026 23:19:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7EF36B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:19:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A48516011D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:19:40 +0000 (UTC)
X-FDA: 84314750520.18.5D81F60
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E036C0006
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:19:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CtBErUQT;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018778; a=rsa-sha256;
	cv=none;
	b=IY7V7nA0xXdTUI2l76DDMSdubmIz8miavtD/7y0mwJRg7lS6vuLQLi/6kMNWZRWyEFrIox
	gps6whEqrBGk+rwDZur07xy2ziCLjuYaoLG9dN+yKpnlRZQTxzdRhcpKMIdDNAPeCkVIc+
	8jeLd/3t24YlkrS2IYGdaskrtT2KrMU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=CtBErUQT;
	spf=none (imf22.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018778;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FrXzQAEQRN298A9NQXfa3gY+X4zzBUHVMqaG/R1D29c=;
	b=q8nILDB2vKzNgIZ3xO42WIJf70pduJmTaseMJtGB183XudtVGMBPXnB4Ysv5O5nZco8F/l
	iEf5TmboE++pxL5JP8Vy4DgLBkFU5ZP/Ohr5QJU46yLJvjaZPHAo36t3T4WFKiyr/bnrPO
	OV2v0CtjmTOC42GPlAdaap1SAVWysCA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FrXzQAEQRN298A9NQXfa3gY+X4zzBUHVMqaG/R1D29c=; b=CtBErUQTAXH/3cLPj67RwvcyhW
	ryWQnyPYSRafAowodNlS0AvWy733kBuE9+h7IhJiHjAQ9iU/yzwCBuEe8F9jJckk+7N3MRq5J+Cnc
	6IwEOdL3DsgX8jug7rORJZdd8zNsU4/hbYM8jU8H3QZKyBgAiYLrC9TVmW8ZVYszNLtwTgdYBxV0b
	nVsa1mbnwlBePuWqPJGK4vsLG5AP55DHst4o9End3tQgKWjANgtlkKkqy4fHB9DRjGYfXl5WXsOb+
	tJnj58l3hruE99YoqpFDJxbiiAcPgVIcDL78yinTJkivfey8BoG2BHhvIRtgq7o9XpLtFHn3xyIgt
	J6F7Pp9g==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085b2-38Zo;
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
Subject: [RFC PATCH 13/15] turn fs_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:15 +0000
Message-ID: <20260110040217.1927971-14-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2E036C0006
X-Stat-Signature: 41eg31q81nco8ookzoie543afsp9ajoi
X-Rspam-User: 
X-HE-Tag: 1768018777-731447
X-HE-Meta: U2FsdGVkX19+nLW8VTX5Ggh4XQVgvF/a6oWJxvQOJ4yNSK05cVtxBWbjaCrx67XpsXwinWgCu3oaW9Ea6y+2bdj5Hx1P5oyOGjluJvNzfi6xqyYTIiljjCeGI7nloxx7qfVbfzqefYjYQCJrLJi/Bb6Rlw3HHAancZx2mpwPfFM6xLUvDB7TnYkRNVoxPNF3u+x8c813zbK4sN7TCFP6/NeFOjOuFKMU3C+y4/UZNoOvUsdDe7KtIDK/V41ZCASyWTY2seMeaHUe+lJwOU6MZmUR6gW1DlI+F1tRyCrOkDns5AnzOGAj+4nSLOLJ1CY/u0/J7fnV7gEnjY5+fig7QM1ss9DB6Xmo4Nh9yXKRg1LTelR5tthcKWuBnHnn/Q4L+rqkaHv3I3r7QNyVLh7ptAnAVf94YNEfBFehiJus0pIWyB70tNB3c17TqJequk4Y2C7X+n5racSrf14MPJQWCglXX6bRmeeTETDluE5SzUBAmCnyW9MFUYsR5VKHaBilqr+n47fSaZwKbnZVunvdreMydW5x3Ar6dcIocgsuLDteBSeup0ZHyrYQsiHBmgyfAY0UCG0riZx90xpkiXYWP7EtLSQ3yPzbFAs9+nXyrh6P4WXD4UbvQAMxIkx3sFJZK1lUfFEdx/PPPbtbXrPVXfQ10ADmJs0yWkm0suIkkEEYJxtyeDmUqEmzLtq3KNv4/z3g9br5p9NxC7d6V7B1sPsMcaVKLqYA4lWPdeiM0j7uRQL6Y3c3uZgBDOucYRtNEDPGkWAH2MIclmmNq8in81nnzsGMM6TZYSo/Xg2R+3y+vDAuOo+DvU0ubPSBoOPnKVGJrKHee1nYalzmZXK1xKhakh8S08T3/nyiFDtb0EZj+1cO/poUMzUSJFxOOAwSdD8aF+fHPdxvHrTbSECRcWFPHyX6NjhF1IcNZHT+fv6c8G8Jyh7oePxQnVXXahTOsw6Pb/Xf+TjRxF5Ha5/
 FjfFFQuH
 +MNicit/BwYdaijD0vQb02puf6NItZh6wvsgV3K7ACwt49wTRsUeGR7ROpWic568qYS+DyKyOWMEiPrE8OAYPV2ry5NXpgN7Ed4OwqhvB3X0IdQ7Vmqmn7NA5tZaFULB/ztU3batXm6xMCMqDMb2dnryYbNIMoCYQ3u4gE6vK5LD5goIdxlFE1cHjhjAz+k2xSOA/cFu/9DdX/xZQRmpydcwRsvcZMyOP7oK4BrAOYr2IyiUkgGwMlShyvlcU0GsKlxhMAATKxiZLpl/bcFGUsQ0sO61QpJ4KB5VX3n7OWae2QyaK++CZmdhpy5bxIU3czzslzfOWRW9+jYxJvwaomujPNooE2ylPYMo+77gqOPmDyhGX6CNEwTD5M39+FDvE0u8xQ6DKqTNAXfyw6qMmgUK2v2OoF4qZtXALGHT5ZV9IvzUBSV/zZgKYb+YRQef/rqCALkrah3lQSJmGeov/2UsSIodIgvjQL0ENCQERAFkipZrtTIevJmCcRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fs_struct.h | 3 ++-
 kernel/fork.c             | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fs_struct.h b/include/linux/fs_struct.h
index 0070764b790a..e8c9fac5b7b7 100644
--- a/include/linux/fs_struct.h
+++ b/include/linux/fs_struct.h
@@ -15,7 +15,8 @@ struct fs_struct {
 	struct path root, pwd;
 } __randomize_layout;
 
-extern struct kmem_cache *fs_cachep;
+extern struct kmem_cache_opaque fs_struct_cache;
+#define fs_cachep to_kmem_cache(&fs_struct_cache)
 
 extern void exit_fs(struct task_struct *);
 extern void set_fs_root(struct fs_struct *, const struct path *);
diff --git a/kernel/fork.c b/kernel/fork.c
index 8f0dfefd82f0..7262abd0d2a4 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -476,7 +476,7 @@ struct kmem_cache_opaque sighand_cache;
 struct kmem_cache_opaque files_cache;
 
 /* SLAB cache for fs_struct structures (tsk->fs) */
-struct kmem_cache *fs_cachep;
+struct kmem_cache_opaque fs_struct_cache;
 
 /* SLAB cache for mm_struct structures (tsk->mm) */
 static struct kmem_cache_opaque mm_cache;
@@ -3035,7 +3035,7 @@ void __init proc_caches_init(void)
 			sizeof(struct files_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	fs_cachep = kmem_cache_create("fs_cache",
+	kmem_cache_setup(fs_cachep, "fs_cache",
 			sizeof(struct fs_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-- 
2.47.3


