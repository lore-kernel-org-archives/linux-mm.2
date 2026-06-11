Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD9FCD98CF
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EF9A6B009D; Thu, 11 Jun 2026 13:14:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECE9E6B00AB; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978016B00A3; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 614B76B00A1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26A161A079E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:29 +0000 (UTC)
X-FDA: 84868280658.01.5DBC786
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96014C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:27 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="d/uEMlJb";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XQVmtnuRTUVgN+XDKa4kk4jqSyJyiqHHhlvxjk0X6XI=;
	b=flurYR0r7SFmcWmwiUA+HpvPj23vspV8KE4/S9okEFa6XgR9OfoxVnY0u0q4bStpdw19HK
	CKzRB2KIdTZ7PJihcYLVAbFOsY46yHvz4doPDGu9uVdfNQ12G5HvOgU6L/KtbT7+Bw5Alv
	wOIBaLlB4sJ8BF+SjlAN66V72+9wXAA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="d/uEMlJb";
	spf=none (imf28.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=LqEpUQ5rV+qt5F8jUGXSun0ceYTIuiSU34GpOmj+vleaueh0P250qQZBAlQGhPimPk/y0P
	pXKAXYDjvx7XAWAkoXAHADxkH0mNSF7gGPYzgQpz5Y8cY4sZ9rCR0qolmVva8WGN590LaA
	aVL9PhfxdFNsmla18VOV6b4Hp25DGeU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=XQVmtnuRTUVgN+XDKa4kk4jqSyJyiqHHhlvxjk0X6XI=; b=d/uEMlJbnMdJgfnC3PlifVjhK5
	VJUot0+Pla00KEjJhDpVMjVYB64HpRgaMuirhW+RfFMZGL4SWbM23fR0sdUZIARnhBGeZ3/sur/qJ
	LxXIMPOSVCip2gs/i4vwjb2+GF1PriuVmCpZvtLthP+mp4bVi1wHHXFAs8V+1P1r5SeER5lQckn+s
	1OloyPrcqtip13qFCycNqzG+g3hk6bWwfjkBW9O/sNFtXrSgfw/3MHZHcsKZekZrzKuC4p5kc0SIr
	lo3sdmr9YDfsSNwaO0fORNjBmQEwPfew3I47lKLYhCe1u7fk3DKyjUWaQT1QWBUl/Wcqzr4lU8SZ3
	3oDLmRWw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz4-000000070n1-1uTu;
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
Subject: [PATCH v2 6/9] make bh_cachep statically allocated
Date: Thu, 11 Jun 2026 18:14:21 +0100
Message-ID: <20260611171425.1671254-7-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171309.GN2636677@ZenIV>
 <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 96014C000C
X-Stat-Signature: s4dq76rcw7hbysg6ndpo83mfjqj9kzdg
X-Rspam-User: 
X-HE-Tag: 1781198067-311033
X-HE-Meta: U2FsdGVkX1/et9MUeI5AfrFfBtrQg3b9FOcwI4BUvhZxHlVlHVoVazQJ/sm2xb3fwnuS+xPxSjNwBzs1I1yz4XxOmV950/sGxdBoUfXOLpmPMAYp9hf8m5tzNdveNRK/arAUwmMiA9y8RgIWvkA9lUSg7Wc7Ct7VrypiCk1rNiaGaU1SdLpGu2vIdj5oUaRf0lyc9NA5V0cDb3sVZRBZDWkiVD3ym2qqh4tmtk4l+DLSLSCcpw2qGpfu/TzoIEl12RBa8ezwnQ3BhMIRMQpRH0l2nwtACt88zuPyDHTjLbgDP1V0DVOVHAyFmqX8EXVQtlEQ1BKB80HguauRJvg8ujCz61MIJKj+rXoLBbtzgW3ua0ral/wmzrswFLP0GIk+QOs1FCfvsMvt2xD2I09FwgJkjR/naLyXHv+g8CFXjA3CisIpVMQjSBvo7s7ZgBvQE3CmpbOFLdJnccwowr1FkDtOhQHMYBmGRw8YHzv79VLZ4B/lGrDa+0bSZQHULjPiomGgIiv54al0A604eFhsDcSKahvFHVygcZJJFXdmEqR1i/4A0kZQO0Nvly4iGzHP0U2O2uDWKifyOAmIyi3B2L8LWo72JO+gOYI59PgFMhaJ+bKYo0b8atWjpXuLnvaAL/Mzz0lewpk+l187BU8s7NzMfF96NNBUaPdQu79Vuwuf8tfoAFmSRqKjQNrOoPLCo5VwC9wMY4npSvmkQ5c0hbs+8tXSqQgEHVZu3N4U1Ky4KqukEP/q8Ehg3ruuxMu0Kg5mLW6wm/62mHM/PY8Dl27eno6nR0jQr414/SZNlk3i/fcpaeOcPnEiuhvi4v7/NEjWzORMF1k5V/f5o4zDklyHQkg+i1SEIfPJadFJxlxrmTX3SCQFC8DcIzvuDS6J3VFKl9zUFpFBvDWjwnZTB9jDqVTQakpJmOtkjndizgSn0H/uKEYyPPEveZLNimOfvgPnlB+/0ZBz0tFOmql
 ylVaMRJT
 SUSKxc8arLPO0jIP6slmoynVQONtvIWWAtHBXweFJM5xPnv89rcouTZNn+IdLNXnaTZescYpzmCQvb3HaY4h9LwAzX1nOvSALdbXyP25LkIyHruWR9iVYtj1AK0aOvAmgRlbdONzgGsR7yZOC22Ug/ukFNmTF37JcYWycgXd9CdOaG8P9dePlOY7x0JeTBYVlYLROLldC9mtAp5xmnsUzyiMh7Kb+O0FJybdgS5bqLtEHzvwMojIn/V6eOQSeV7bYySzYtZYf0mMnGGy5W/Vzyt6X8iH5Hk89YVk4OEgeEN3QECazov849PElPA2Km4i1QvuanUzbRfmeRQOv0RIgu1RR8ltgtBYS++WRmAmBCS+E7Z4d9/h5JYhT8C0k2bDlnZA3iWW1/kJh6GkCcLSOME+CpKi92dCdq7UwcPm4sY+D20bvOV/MWTwMgAUVJJDLKVWgXUKU0Mu/qMkI0sGBSPFT0AUcl3b3yAYllIPWJC68m4ASCcN4lT28nA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/buffer.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b0b3792b1496..e834f7091f51 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -51,6 +51,7 @@
 #include <linux/fscrypt.h>
 #include <linux/fsverity.h>
 #include <linux/sched/isolation.h>
+#include <linux/slab-static.h>
 
 #include "internal.h"
 
@@ -2906,7 +2907,8 @@ EXPORT_SYMBOL(try_to_free_buffers);
 /*
  * Buffer-head allocation
  */
-static struct kmem_cache *bh_cachep __ro_after_init;
+static struct kmem_cache_opaque bh_cache;
+#define bh_cachep to_kmem_cache(&bh_cache)
 
 /*
  * Once the number of bh's in the machine exceeds this level, we start
@@ -3065,7 +3067,7 @@ void __init buffer_init(void)
 	unsigned long nrpages;
 	int ret;
 
-	bh_cachep = KMEM_CACHE(buffer_head,
+	KMEM_CACHE_SETUP(bh_cachep, buffer_head,
 				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
-- 
2.47.3


