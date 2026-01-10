Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17C51D277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AB3A6B00A4; Fri,  9 Jan 2026 23:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C3096B00A3; Fri,  9 Jan 2026 23:01:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E582E6B00A5; Fri,  9 Jan 2026 23:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CA32F6B00A4
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A222857D1C
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:06 +0000 (UTC)
X-FDA: 84314703732.18.86BD2D5
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf18.hostedemail.com (Postfix) with ESMTP id 01C5C1C0009
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HIWKl4Pf;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017665; a=rsa-sha256;
	cv=none;
	b=b8VtBjdra0YPyz8bZuNlgxaloIJOQv6/dA3g+B27j9/QB3LcgBDTGwfFs7NirhetsLt61U
	b0ZjeNKzXXRz2JcjT1O6vv/JVx2Q7X8kL8hQenSRuwdoBMRyS5tP7jHl5H+GsuW/VsdXnY
	Cyh+4SWtYATmghOvPerv3bQarWSwyl0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=HIWKl4Pf;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf18.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpWF0f2SP02fz5D0RQUbdZlrc1oKAOcosJWDE+NgvuA=;
	b=tzohscFHR0wOOTVIFDpj82Ya2Dwmmtb8cxhykbRRUNp/RGpbColMvDyTOjnv87mcVh5b/2
	msANtKtAWOuhD866hHDx85rw4CKTdgNXcWnZr1GBikhIc4Xe+lKJ+2k/1R3FO637cKHgx4
	gEE660J+dJ26wdNI9yQVJrrv44MiuwA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=QpWF0f2SP02fz5D0RQUbdZlrc1oKAOcosJWDE+NgvuA=; b=HIWKl4PfjCkBCTB/oOEIVkqj+Z
	5YZATPeRZsWeb5vCSUWK70sBsvb74NkrcRaT0oNRKQE4hJQ5UBuYKTklpm3XIvq1nU3MB8Jz+gMND
	tC+3u4TJG4qPy/Osswy1K8O5OgMZKWvJa4TeC58hXAly6rJvcF6Vzyd8wcETf7aibPEz9N3gcfixj
	2n9si2f/S8XjgWiMe/3QCRqzvSlg7n84lcXieqIx51vwa1zc3yb3/uS/tvoHF0nzLqCDcLB51T9Wr
	U6/+JW5R9eXd0o6pSLUjxrxzEpnR06tjBb8qthBJ+kLFOPV9RQIe06B2i9RWSmbeyC9JsHc+pZGV0
	RwJtMCUw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085aC-2Hni;
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
Subject: [RFC PATCH 11/15] turn mm_cachep static-duration
Date: Sat, 10 Jan 2026 04:02:13 +0000
Message-ID: <20260110040217.1927971-12-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 01C5C1C0009
X-Stat-Signature: iwm1m5qwysye8sfc6eohiqw996a1uuxd
X-Rspam-User: 
X-HE-Tag: 1768017664-941306
X-HE-Meta: U2FsdGVkX1/VbjXpQRRKW/l7K6p5te7dkcgNlSdXkU2WwNQZgNK01yRF+RrNbb3VPVM/Kx6FzUSLvgdVHwmn8Y3iW0B84TQt8xfVUgcXcc1XVyvljJgu2Xjwt0oj4x8PXEFcNVpdg8L5lSMkd2dfcPOMCGz6+lNXIUfjW0grYc/vMuJyXPY2meRE+2OwdvKYUAeR1xlCJ3fk7RwCDtlcNG2qmRHfs+8ybx3r28syNqwIk1Ok1YA51F8aHZwWwfxxdlMU7mx3QtvPumZBVJifrL2nRrxwfU3tDbQRhgqCP8xoLn7/vJuTiSnf+tqNPc1BOfApgFwwM6JNinaHoRLxUGGzCImZgYR5AsevJ7QrK/Z7ROnOGpmYOG+n+CHrbcItqIpqu8KJ4eW7Z+MossV/zQMUJvAQHt6xFRkx8L4WMdIbu2UfRfPg760hRLVb32EueVzA5C0rjlun40LE3CpEF2c31DCMpAAVn7O4q9XoD9Bl2hSCCl4d6Rr/azg4OhR6zghGV76/3QkbwoEBHaWXMYkfU8AdCiZju+C5EgSsiHoxKW+MqymicY0qbl/GvK2yLLVW00z7YP46i1HntHXqz8yOE0ExsWqZ07pXndvSOeFzghdUEsvOWIS91japEj6wMAMiKpQyTkl/9oqGtGttmNQ6JjVW4jvCNdKg/AshsFrZB6J0G5BZehR1BiVPHck9dt+e+A3jr/BOsyX/9tmLUwypg01Pqzlo8xrH/XWHS+GoR+kXe1NeFNL17Kd0wXLzvu1hXEb9e52GRu0IRoef6oqOPcE1UnpForKHPBNGSHrsDLPG4WD41TxlnoUQ+loDXfz8J9/2WuyuXjn7rCxMgYKjtCWHNh45DZglj98mLN90yDgyK3OEKkFy6NF0ElQr8BJCTO1PaeE0f/JDKLQ4C3qa8mVyG+2DvnBbG882PPKZWvaD23lUb/xXaWM2fzgV83NF1lsiwJDzxxHcI+n
 37tu5InW
 8HKHW6Zqz+0QEPSjJlh1pnjWy4lcO03kBlENav6Xp/2rVIJpj3UnFU9nALXY0Xp2JcsWjovFE7CMJE9NV444gZKy/w+AkRnJrGF4JVixhdlUGOF0h9R5GE/KnrZ2tM1YpLXtg9ryV7ImLRISEvEIxYiCqKRDs4VefLPpvhOxrqKq6FYGEeV7iKNGHgBABalRd7MTajEGRE1Eu1jLg7xqBfzJCap6vdVRd+ZH4wJ+zMri7F533Otm8ck2xHIDb3AikepWw4YEgW2sCZJ442TK7fBg3xhnm5ijfUDYdJ6bhk5+wGXdUpgGdgDQpAoe9DCw7jrizs4kB2tv1DvjtmDLxRTY8Z/QLi2eGTFCCCKhUiW+VbRz7uG62U7MqdNXaHT4tJV55XscJwrvIXYQVtPIlTt1l4BBQhex9oSrbugAlLQdh6EsNVJNR8PZYW7qzQg3UjFzDRvIcew3hauYVRuUqpiDtD+t17d/M86yqC24phVyCdAATyga60SY1eMNjFdzz1c/XfdpUCO4I/SA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/fork.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index d5b7e4d51596..f83ca2f5826f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -478,7 +478,8 @@ struct kmem_cache_opaque files_cache;
 struct kmem_cache *fs_cachep;
 
 /* SLAB cache for mm_struct structures (tsk->mm) */
-static struct kmem_cache *mm_cachep;
+static struct kmem_cache_opaque mm_cache;
+#define mm_cachep to_kmem_cache(&mm_cache)
 
 static void account_kernel_stack(struct task_struct *tsk, int account)
 {
@@ -3011,7 +3012,7 @@ void __init mm_cache_init(void)
 	 */
 	mm_size = sizeof(struct mm_struct) + cpumask_size() + mm_cid_size();
 
-	mm_cachep = kmem_cache_create_usercopy("mm_struct",
+	kmem_cache_setup_usercopy(mm_cachep, "mm_struct",
 			mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			offsetof(struct mm_struct, saved_auxv),
-- 
2.47.3


