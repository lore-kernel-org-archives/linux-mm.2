Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979E6D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6D66B00A2; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C10B6B00A4; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D2586B00A3; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD036B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2AC5C1A2EB
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.20.D9BAC34
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 53BA8A0007
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EWcjovho;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=rqlDQ2YeLX802/U31lh8YymY60pIO9I2jAsGg3Sx+ltHBAlzXhm8onBJ2MytLrtrDbrRsx
	cKjhBsTtWAz3AjgPzJCOHKbUQ+WiQWd0qWkJIIGm12y6m0F6jE61E/oQl4ceIKUxwb+C3A
	cIGc4B/43g1M01Fglh2qbbDxLM1UfPo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=EWcjovho;
	spf=none (imf15.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+neKtrh0OJd7QapgofbeDN3yfzvNs3usU5t8bvxpKQ=;
	b=cN7oMDSv4X512hj1PBzbBHbONzs3OzlxwET/oWR+xtWAfNpYz7ZQKZ392oT2Zg71GVFJSY
	HMe3xGuSHekEfd/BZdnsQGgT7ZP/exhzSv6lVOk4F+YBSnkoS4DEfPurSCO4Rd7NqJ9Gpd
	v4LRVHQJ+KN7HOY6CEa5MCM4Qzs294k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x+neKtrh0OJd7QapgofbeDN3yfzvNs3usU5t8bvxpKQ=; b=EWcjovhosAsZq5017xsM1Oft92
	V/GTFzIUMfeDDs7239l/el5uh/Cs+WzxyiLaXiMlERUrz/B80QmG3x/pUh1w9B2ygcQoS0S2z8cdl
	Ke8FCpzvFyuooLXf7Rnspy1z4Wb7bRF9XKK7a1DZrVKyOy1x44fWvOk+ME3BhrPhfpevGW7svE4PI
	/M53EWbRUU644eS1Sy7xFkXyIVHeTYjLnYw1TGSGytr3GpgqTqryoQWrTFljJvN16EgDBmQKh6s8M
	+E4X4cx0Y2kwNCxutzyCvR8U/pFxAJiPsHWuL3hlt9U7UhhO7/Edd/w+6drozjnuw3lTY9J84Jwbp
	utsmtJyg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085Zy-1Thv;
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
Subject: [RFC PATCH 09/15] make filp and bfilp caches static-duration
Date: Sat, 10 Jan 2026 04:02:11 +0000
Message-ID: <20260110040217.1927971-10-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 53BA8A0007
X-Stat-Signature: 8s4881icrcb4miu6gy3s6behgh84ux6x
X-Rspam-User: 
X-HE-Tag: 1768017660-197807
X-HE-Meta: U2FsdGVkX18UGnHuJv1RqemL5zK8jOn3s8YqjCg7/b0Lws1LCupgF3YRwjxROhiTWe94UoFHVR6KZCXHPjtfLKBDf3bpqvx1NYkefRqw7ofMpjO2c1A3qzHlyrlGDDGKF+193eOxdaRFcds71GI3hISWMlgvwiSajfQ6EB24ZoTfYbpQVtdHbpb7cq5Fu3rAHb77LbtXv1QmEBtExs86tIY2LZnOh0AdkWu9yg7oQfZrlkMfuuMEFhxFIjsdKvUTRN38GsC7K3I+V3M7fPpQijpKCdxAby4sxC91FNty/amaX+/v2/hFFVQIbt2es85yzqPTgraOMlrugBJmxdOdftl5g5dZpiQplOH8K6CNhW49YDUzqysF7IEbkqRfBrhrZG62Ywf64I+aRUr7ZYrPM0EFTJBGzmZ0Qhgb5VWoLjSx3p/+JiLLl7BdO2VXoRXdNlqAgg7Ha4PiE664a4Ll2kTMY8Z27aG0Pd6/XInys0f6eFXWMps9rMq7gqS1aPPCvSPc4R3chMuRGAkgdD+TAcrfSaUNqiBhZFhNAkrdpRj4/HuK0jVJxfD3wVqddi+8ZlqCj+OcAst8PQLL+Z7u4v32CANWXopZU9+8uU7JbB3uI0q+GytxbND59O13SlAiq4YOb6GV3ofTjzJBcJbYWOENzSOxbjah5P6DPpTm8+gKI1skqVlkk0H3R1LX1VyZC2ELRn09MubzLEsu+nd3IrorHAN31rb/f3ovbD7FJKRH46Ms6IrthsmaST09LWRklPDuO4nrY38IoCIPwYvkEX8MbOultGBT6goLvKjY46zvLPSfdEL7wjCSmzzgKXmO5k7KnBy6c5m35iaCBnqGsCyXU+BsN5p28pNVSt0U/D3JdRS6AwqeW1QbQ3aLY8jzus72TreZnQWZw4/S6LRmVbgI5X3MXHCPF5B9o4+bta7WaTt0ErLJdIDmfemdkkmkRh7WsZQGVS8QV1bMSHP
 SNhXxwC/
 wO8TiRkCqlfYB3SmiBnyqd/4n+lnhWIbFB1GesibHI2awolzmk1mDUCKJFLcPtUdbHxrdNd6EXc2LvYSR3kmvH9Cq28m7sxkqsgQ7BQ9IN/6DxK8sf66tdFfubdv3ONqzSXo80C78FWuIptmyuLaPMRsCCmB1BqS1IfdFQw2hGJcT3h+i1yeXZTcNDfXEKzqICB6qHsNsHW2MIO80wGeszrDQ5nj2CklucrTA6JbiuvH0gYvz+cvgejrj2GshBTEZAneNmvEi06Jn7eEg3inC/8domL6adeUxHBpFC7c8gLl+IH05UkmGFFC8ZSqoY5N87Qq2LLY6VVTQCM5agC+AWTtg1ZLyaKbNgUHYoybKsDj46AcFBzKi3E5jYqf00AwOGC0b2CMEUDiIvZMZvgVAJ27FkZGtLVrA7jCvxVTBuqiVAUM2c5PX4iwv+gCHkynQZzVd1iXWXnDlksGQh6sUNaCLmMGyf1XTBF3cR77Pzkn7cHE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As much as I hate it, the name "filp" is a part of userland ABI at this
point - scripts grepping for it in /proc/slabinfo do exist ;-/

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/file_table.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index cd4a3db4659a..18a992b40109 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -27,6 +27,7 @@
 #include <linux/task_work.h>
 #include <linux/swap.h>
 #include <linux/kmemleak.h>
+#include <linux/slab-static.h>
 
 #include <linux/atomic.h>
 
@@ -38,8 +39,10 @@ static struct files_stat_struct files_stat = {
 };
 
 /* SLAB cache for file structures */
-static struct kmem_cache *filp_cachep __ro_after_init;
-static struct kmem_cache *bfilp_cachep __ro_after_init;
+static struct kmem_cache_opaque file_cache;
+static struct kmem_cache_opaque backing_file_cache;
+#define filp_cachep to_kmem_cache(&file_cache)
+#define bfilp_cachep to_kmem_cache(&backing_file_cache)
 
 static struct percpu_counter nr_files __cacheline_aligned_in_smp;
 
@@ -587,19 +590,20 @@ void fput_close(struct file *file)
 
 void __init files_init(void)
 {
-	struct kmem_cache_args args = {
-		.use_freeptr_offset = true,
-		.freeptr_offset = offsetof(struct file, f_freeptr),
-	};
-
-	filp_cachep = kmem_cache_create("filp", sizeof(struct file), &args,
-				SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
+	__KMEM_CACHE_SETUP(filp_cachep, "filp", sizeof(struct file),
+			   SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+			   SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+			   .use_freeptr_offset = true,
+			   .freeptr_offset = offsetof(struct file,
+						      f_freeptr));
+
+	__KMEM_CACHE_SETUP(bfilp_cachep, "bfilp", sizeof(struct backing_file),
+			   SLAB_HWCACHE_ALIGN | SLAB_PANIC |
+			   SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU,
+			   .use_freeptr_offset = true,
+			   .freeptr_offset = offsetof(struct backing_file,
+						      bf_freeptr));
 
-	args.freeptr_offset = offsetof(struct backing_file, bf_freeptr);
-	bfilp_cachep = kmem_cache_create("bfilp", sizeof(struct backing_file),
-				&args, SLAB_HWCACHE_ALIGN | SLAB_PANIC |
-				SLAB_ACCOUNT | SLAB_TYPESAFE_BY_RCU);
 	percpu_counter_init(&nr_files, 0, GFP_KERNEL);
 }
 
-- 
2.47.3


