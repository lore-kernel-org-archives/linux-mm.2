Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EDAFD3CCA5
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28396B0088; Wed, 14 Jan 2026 22:18:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFFAF6B0089; Wed, 14 Jan 2026 22:18:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B056B008A; Wed, 14 Jan 2026 22:18:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FAEA6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:18:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3FB1588C52
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:18:24 +0000 (UTC)
X-FDA: 84332740128.07.EDDD39E
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf01.hostedemail.com (Postfix) with ESMTP id 675FC4000B
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:18:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LWbtqDmM;
	spf=pass (imf01.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768447102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ftYr0Vux/TRKiah+jH/Pg17vHKfQ65hz71Fr3PI0YMo=;
	b=whBu4JvbBsUd1vtEFh2t0Vapwe9JKAljVuvFH2sYpqtp1OZqJAm588OHrn6Xdv48oHrcYl
	rtspyDIqBjwlYw89Wzl9fnk1YEVAn068Xoy6xK0nwY6+3eVNIup9Sq7Jh4msTZnMktcXL5
	V4myWobgONTppwZ6uG8Wi8EHSCFvGJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768447102; a=rsa-sha256;
	cv=none;
	b=8CA+PCPXHwQG9DwlJY06C840X7c9wUjMz1wpkEHaTgzBcZnGRCpZHshkP8V3PA0P/wntcF
	DqZhrJ4xeuxc5rcnH3Zzp7evnpjyyrLXc478gAweZWB2MlO7dz+ddk9f/06ROhFzmi+jaD
	O4n+762xQxnz7MmpthG/rF6Qpb7u/jE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=LWbtqDmM;
	spf=pass (imf01.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=ft
	Yr0Vux/TRKiah+jH/Pg17vHKfQ65hz71Fr3PI0YMo=; b=LWbtqDmMcfS5RpDZUT
	WiwVFY/JrqB3o+Jpc8Ww3TkBPk2gVYXFN+nYcme2HbyOg3/InI5L7TmRkzAK54VC
	btzO3QUMc7+ndiG7BmXQ0Wl8ecA7hytDWJlbEi12A/qB5zz8kISkUDWD1zoGqKPP
	8rxWFKt0yzp4n3tPrg1k/cXjI=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wCHOLvbW2hpqcCoGQ--.22184S2;
	Thu, 15 Jan 2026 11:15:40 +0800 (CST)
From: ranxiaokai627@163.com
To: surenb@google.com,
	kent.overstreet@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2] alloc_tag: fix rw permission issue when handling boot parameter
Date: Thu, 15 Jan 2026 03:15:36 +0000
Message-ID: <20260115031536.164254-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHOLvbW2hpqcCoGQ--.22184S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tw1ktrW3CF15ur15GryUKFg_yoW8trWUpF
	Z5Wr15Krs5JFyxCF93Aa4Ikryftan7tw43trZFgFW2vwnxKrWDJr1rtrWxtF12qFZrCF4r
	X3WY9rWkWw45J3JanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zMeHg9UUUUU=
X-Originating-IP: [117.176.243.29]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7RyCzmloW9yDPAAA3E
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 675FC4000B
X-Rspam-User: 
X-Stat-Signature: jcu631bp88anpn398echcdi8cjcerctc
X-HE-Tag: 1768447101-548319
X-HE-Meta: U2FsdGVkX19rYN7W8EKaeyCPAK+LUFQldlaGf2/VRML49lHoU92PmZgh33lBP9M0E//kt42CsYDtUjjumtFU/927+pV1h6MsLy1p7fY2GkXJDZOilwFRHy7vVjaCeeVfrvmozRhYfcImR3Q/EGVG7jnp4hfpsicORzA8yCVXtvpJGLacbnDX62U+V8Tl1NzNEwUKW+IcW8qDElhPqBG+cLNYuMb1K0MHWLUDilLEKwFHSlhJOdH12cy0dzpXTyjSjSuQCkCjOL3HSZiYk/up+M5aJ8+5tRKPtOQGU9NCbT1+pdXJSpoqFDHk7+g/WU38HmOrpZr7PPPPFPDtqdcPtMfZqAV7yPXtK2vCJc6pjUGa2Fue35WErqdvuq3vrHPPoioD6xdKJ4t4DcysQ3SFeHkHNM5LnGneNl3ZVAy9Gkn9BkeW/cI5HWY6+39m1vWQ1EE7b4cfyyTnHQj/yyO/FlaZGevbTk1dRKaLU85DGHggxYmcZOyeWjwlDgR/uVEc5GwaiLY7UVlRJsSZNFV54eDBCRfU6S/L2nBc9b7b+UOLQ6DsUgxtJUnh0iKNEWLeE3fUI5BYmA5pb6c4DPKNTF1z+Wkb2wd4OT9+0VJaOoZ/MgHpIA7vkBsksNrZF49yQ2Sqhx8JRzNWb1isbvhtlnzt1q4pzYIlDPpypFFLzbnjo0yUZoHEFsHfooKCXcUurs292oDUL4ub/T0+FtKqSSy72rCa1afmF9IZqjznukKmUK/K/8dBQNk/44l3RieZJopJtRULc6is7sG5JU4hQkX3fYVEIdrK9uxg2iLAdWvefBw4w40E4S3GIUh3ADeStladHzxNy+ZcFR92szYCfHFnnVEfrMJFkxHLrlYdZo2AnYv+sNjtrqbzp2luqHFeEaeq8YebmnhHBQuHaJUaKGnJ1bdj2aDT17pOyx8/5ryGy7wgcUYEt7qA5XnZfOdj5LrUpfIcoyd3Y6AKH//
 g/U2LPiO
 okBt4GFdX/a8mBFgBcBbKM3ot2a+j/VUkhw1so0mRvBVjgMF9SVxxLNXPNHRA92SZmGavoB105jz+ESjespyCnOeA5Di6E+rjLasYQpHeibOROhIX08rHAPDRP+RBafqmRUzM96NzSff8/+ZHPitmTPzh5CcEhkbcZ0/lJ+SW5bjeu3q6GZLpPJ9BbB81lzG1whG76ahai2maSHfv86LImVoj9UFqmVA+qrXsJvuCqahW0QSOYbpjDLfWwZh+tE9TZd3jLWJMY0xoG4sqGWTMgLn7hpHEU0X4QOArr75G/fpIPdJ8hed1ApnSTel4R47YsmKMQlrdgQxK/Brt8s2JqNJvJr9EZl6Q8VA5z+cq043HxPLNAmbgx6/gvzThdI4JlyaIMN/ZvcEJQwOOIESCHoBycfl54GtEpLTAtlCuMUecWHvwFB7Tk7jXwgj+ZW/77nZcYk9Yj0WGgF4R8gALidyuzQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Boot parameters prefixed with "sysctl." are processed
during the final stage of system initialization via kernel_init()->
do_sysctl_args(). When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled,
the sysctl.vm.mem_profiling entry is not writable and will cause
a warning.

Before run_init_process(), system initialization executes in kernel
thread context. Use current->mm to distinguish sysctl writes during
do_sysctl_args() from user-space triggered ones.

And when the proc_handler is from do_sysctl_args(), always return success
because the same value was already set by setup_early_mem_profiling()
and this eliminates a permission denied warning.

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Acked-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 lib/alloc_tag.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 846a5b5b44a4..00ae4673a271 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -776,8 +776,22 @@ EXPORT_SYMBOL(page_alloc_tagging_ops);
 static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
 				      void *buffer, size_t *lenp, loff_t *ppos)
 {
-	if (!mem_profiling_support && write)
-		return -EINVAL;
+	if (write) {
+		/*
+		 * Call from do_sysctl_args() which is a no-op since the same
+		 * value was already set by setup_early_mem_profiling.
+		 * Return success to avoid warnings from do_sysctl_args().
+		 */
+		if (!current->mm)
+			return 0;
+
+#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
+		/* User can't toggle profiling while debugging */
+		return -EACCES;
+#endif
+		if (!mem_profiling_support)
+			return -EINVAL;
+	}
 
 	return proc_do_static_key(table, write, buffer, lenp, ppos);
 }
@@ -787,11 +801,7 @@ static const struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
 		.data		= &mem_alloc_profiling_key,
-#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
-		.mode		= 0444,
-#else
 		.mode		= 0644,
-#endif
 		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
-- 
2.25.1



