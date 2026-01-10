Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C3FD277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0E596B009F; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8D9F6B009D; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96D3E6B009D; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F1F96B00A0
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4625B1DDE99
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.01.BF08739
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 56E9A160003
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fZ4Ftxdd;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=CSzEhDkg/rqX83YRDZVoTSLCO/+EqmrhKvGMY8tceWwknut9noXKYGUmcxcNgnSOYlUqcp
	+TWyv5ijKsoV7wOmmLz0BJ2gFiL17UIVBQinXN0Sol4uMrXF9cWJUgj+z9J8cO4OQjyV9Q
	FYX6oCz6c5IVR4E7rLarXVZKtdYIdC4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=fZ4Ftxdd;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CTpW02raswBuv7j7RpZQuDcsunwQZN7ImQgsqrvpB7w=;
	b=14AChn+AFLQ2J1i7SnRmR09mIoeXrAum5f65ihTw9DghjEUCCHDzaGYWWsw1O7LPqrTKsU
	wQRTgUesVdxpWutFu3DGUTC7bYDH+6WZsjFxyVkepMAzR+WLCR3ucpRHrDOxH+QsLIppdr
	CqERHATm6zM4q+fesYFvLg6oPlJ5IAI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CTpW02raswBuv7j7RpZQuDcsunwQZN7ImQgsqrvpB7w=; b=fZ4FtxddXrGcwLpzr5s/FIqFbB
	tMxLMY7PP8xJ+h3pkLDGWDJvBfoOPykJWICv5M7n6CLyrscU/1vvKkICS5fMdQLksiYTpks+lAT/j
	yaf2Nck2v1MEaSrOQ51NyY9XDb4xxQCLA4120symgE1+/jEwVxScShqAC9f52Ssn/Yv35gz0uT5aM
	M2ial3P8740gYYBH5gtpEAtVq+7kXYjvo+u2th+jqNf5tw4iZBYAspR/JZzscHqYDZD8wYhS4d7T1
	TbgyA/Y7GhBQsaDBIzXriLR41PDddd4ajz3E3AFYlJQiaiDAbjN8IqxW+ZvLCB0UcR/sHIicmC8d8
	Ustmky9w==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085Zv-10L5;
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
Subject: [RFC PATCH 08/15] turn files_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:10 +0000
Message-ID: <20260110040217.1927971-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: shdguujykzc3cjprm7mxmrtjq1i9b7dk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 56E9A160003
X-HE-Tag: 1768017660-30058
X-HE-Meta: U2FsdGVkX18GTcJqIQmcWj9gQexmsFf5kPQvT80lceS/DLdNwUgR0Tno98x9nJgfoaXDPyX7FaIRwJAb4k3NWJYxPYepjZMvs13WKSZkpjRX6rIbn0GbVpHnoLFPEOyn2R8ek+4d0EQNgeh8jkLlEkLu0EeZIALkqJLFbP1/t4XZ3qgw0vs+ScYOeQFxzxaBiKcPisMTBQc5xbZ/xMj4HyoddATvp1e3453IXG1AMMjzOZb5Q5Ma0uziaCJ+Aac0Ixywe7UW5hfZtot7KQuqBGFCqajvSOZUEOGqZdUM+pERBA/C8AW9/OcBBqveJu8xy0rY807JIGVHAKQO3DiFOxlA01+JwAqiF5RhHRm2R6abl8mbjzpqrK+5iGIW1AK7IQUtSS9Sngjm69NiFkZJCMpZAzx4Y1giO4v9wkETPFJazs+UHfhauVSjvW50KYBMsBff0shfjHMVv84pvDYhtMPUJCCTn0Eb9OClpKtSaOshZx6YzXLUQR/2D63/9lYafnueSqVcRpWm7gHOSa1/9q90qHmScx6Vn3H0c9fXs3ahPGLXiJLaM18N3XObX3gg6onvpp4HVuAbAxdBAYYx8/FjyPvqd70GDzzmxsPpJULnfeK9iMIl0HiODXj/6J8z79eDaeDQpE0iexGHhjFTDsVkUpDpCMfG0XStrMuqvWTAqZ4PNsIhGiUHxA23Yb2p0LAU8Otv3G/ajolZmpvLmZsh9hChAhZyO+NNRDUcKgmtNm9qNApgIxtYf2vCFjroLe8OfHP2+mwbtV9sT+Gf+z5jllTscbBaobKxDSAN7k4pO0AKfHJvVic1JXRCcxKIAXsyr0xTJT/GoIev1oAgs/2x2jK4aaeIORZIu9nVVgsuabcRHhxZ1MJjfip1orcRIHM9mLUftDjND136x63mebMECMIm9MtbkN0YwSQUjK0CjmkCk1XFXdeeD4cRQxdwW3OUgvZp5YnNYh+OCkY
 whrm+WdB
 RUFWKEyt3+BN2snLVQhlr/ITGb4yaO8T0HQ2ZtAYZ5j/TjMmIo/M7Szd6ATU/qfVsm4lXdz4j3DhlNe8gGAYyvZ8JelDvaDi4CBH+qKQee6gA1OA8eEj61W2w/d0n5bSWOPKnj0DXpzzL3o+K+kDS+wwoBZxbISZol8q1z2vVeUOWuol6z9LdVx80j8BjmJDivQ3RZ64SidGo2+jlqJ4xrV5gnarE9HdAKrrCVrQlAxYcSfUIkW3e4aFMkPRJiTRQV7r06JqUXgtbv3dJXa5Li1lqecjka3VCDr+ouP4wuX7+yWRCra5Aa0GJ4hFSIH77Y3kQ7gCXkolKnZ2n2DHRGXnJj2RilWnYoeKwFq13Uja6lEPqJE+tdONbsdoz2HiGrCaKhCb8Vrlg4mQPWpZjoyQP5WRmwOlwrEui1nS8+dn1cAhVat9Vl71aVvoTXJ6LUg+px2UoYOuxa8dgR6WACbHsGvSMonFeJLhD7GTqEBNXWbQ8rIfOnsMmig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/fdtable.h | 3 ++-
 kernel/fork.c           | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index c45306a9f007..f2d553f99c58 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -113,6 +113,7 @@ int iterate_fd(struct files_struct *, unsigned,
 extern int close_fd(unsigned int fd);
 extern struct file *file_close_fd(unsigned int fd);
 
-extern struct kmem_cache *files_cachep;
+extern struct kmem_cache_opaque files_cache;
+#define files_cachep to_kmem_cache(&files_cache)
 
 #endif /* __LINUX_FDTABLE_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 23ed80d0d6d0..8c4d9a81ef42 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -472,7 +472,7 @@ static struct kmem_cache_opaque signal_cache;
 struct kmem_cache *sighand_cachep;
 
 /* SLAB cache for files_struct structures (tsk->files) */
-struct kmem_cache *files_cachep;
+struct kmem_cache_opaque files_cache;
 
 /* SLAB cache for fs_struct structures (tsk->fs) */
 struct kmem_cache *fs_cachep;
@@ -3029,7 +3029,7 @@ void __init proc_caches_init(void)
 			sizeof(struct signal_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-	files_cachep = kmem_cache_create("files_cache",
+	kmem_cache_setup(files_cachep, "files_cache",
 			sizeof(struct files_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-- 
2.47.3


