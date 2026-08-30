Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D290C61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 760D66B0098; Sun, 30 Aug 2026 00:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 739336B0099; Sun, 30 Aug 2026 00:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6268F6B009B; Sun, 30 Aug 2026 00:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 400D56B0098
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:19:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ACF4140258
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:22 +0000 (UTC)
X-FDA: 85156631364.07.5EAC287
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3CFE51C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:19:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl4JOhdj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788063561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9PhFISLskt0G9jrpDuqAu5vcSeLsmZLZhXWQ4ku/eI=;
	b=78Cl/ehVBa6jMGA76tzlhN9XWb/u4pQ2eKBmBOe4kuuNLm+69/PkoXN+ZE5BawBb4d+EMR
	6/pBoL0aFF4Zf5S2JhwSgaEIMZQrbA/P7/PradWtC2poWQnSlGntv6qRLQzv7dfooV+App
	48FMTotQvJNA2U3AeJdLUAamPP5GMj0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dl4JOhdj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788063561;
	b=WW1c1v57a2LnuMv/G1hPRP6EwDWHBoJyzsoA0gZaiMF6e47vEhQJvYEDZqulXgxp7Jv+io
	7BpQKXNiHDxGBMjqlrfmx5sB/VpBpVmnqEBWt2uhLI2NDAEOp6L/pZ6TMP9UMX3vS1vr/b
	DYrpOgDgSGpd7Iy+ixPszWnmEUpbksE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=E9PhFISLskt0G9jrpDuqAu5vcSeLsmZLZhXWQ4ku/eI=; b=dl4JOhdjy5Ky53MMIMMBSBjxka
	GMyBrCs+KW2T06hsemYTZsbViVEsYqH6IaNoiFeMIOs23zFgdkh5S85D4oEtrKsHkfOgxzhps21Kh
	6NpoQaSvy8g3bfy7JVTIHe7QClXeT/eCwfxNkZomI5FDA1vK8kOFGCVOXEqBcAIU07qbwq64YXybZ
	ZYvDvIoj6CbhKrL2AetEuVzCnYNaBocvwGaeqPf/lQS+EcUHCgTIgf/W9rTKkkPkc/ba67HcDVp4Q
	9CgcYBOQTK5Du77A8ZYIfso3emJlI1o86I2tmoE58/7/o6UdqqDwrPtwAXs6hbhhEd6NkD7c8n0Yi
	CDA201oA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0X0Z-000000000i7-30zs;
	Sun, 30 Aug 2026 04:19:03 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Christian Brauner <christian@brauner.io>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>,
	"Theodore Tso" <tytso@mit.edu>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	linux-erofs@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org,
	ntfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 9/9] filemap: Remove FGP_NOFS
Date: Sun, 30 Aug 2026 05:18:56 +0100
Message-ID: <20260830041901.2668-10-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830041901.2668-1-willy@infradead.org>
References: <20260830041901.2668-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 69mzshaqtshfbo4xkmoqcncm63ezeqa3
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3CFE51C0003
X-Rspam-User: 
X-HE-Tag: 1788063561-517897
X-HE-Meta: U2FsdGVkX19DhOz2HEieR4qetuvedSt7KoCiOb6mJ84EIjraEGAQIwTFWuTAiEVnF/de3vR7HJa9OGeSdYHIOSzr3iAmU4LrbAjPL3tc1pvILr20LK0KCUc+qzY/6VS8S30UrukacVWd1PjblmZ0FnXQGaOjZXoa7Wbl15XIAWnGAHxjJAUdzrOlqO4D12irUo5TQkqQeu1YdWH2bpZkIBQLl+nwdRWMiRuosgMwe+tVEMa3ucjFL/ePptQ2R+PhHZ2c5DcZ2epjG74uG9ey5Kc+o1aCUmgle+EyVYAG8HsE1P7Q4zHCC4BDyAHebYzxox+RHNc0hsVYdeJ7KZdKgHV4hXRfjRMDB3eSpbFNUyWlXJfeNwRExQ+Mj8b4apGxy9FdsSUaWNXKu0WKoecBwaxRGInK6N2FR9bR4PS0VIwWXTbrslVXuY62o5KGO8C8qz1V7P8JdJHLgaYA1AxArCuAKnvsExEiQsKA8b/FsaIwBQIR4uww6JTInS+YZac5ygHKMnxgD80GXfgEAKGfNbmI64h9YgegbMv/ZqYtngnj5VA7Xw2hRjKRR1viBIWBVyjiRdNs++53TJuoQ2WreqHPktRA6m4IEfCHWTc4/x4aDJ381TzdyTI9bxH8SoMPG8KVgrnUDqUMLD6QJTPseDEo0D+oXudJyAhVW1qrzrTvy366EbJjlK9b4vJZJZsp7M8M+kkNt+cZOxN6qu0KUuZZiHRwmDGjd37anfB7lilSpodALFC7AityAv5fY9dHhfckGLNCw5TjjylqDAAhXiA5RaqGiFXmsfWv41tk0tCRIV6QCKmQKtnvlSA04e6ZesvsP2W8NHLy55oXsnwQ3qy4PNLiujBiMkZEMshJ9by+C/y7VaJasfOhNZrm8QWhGDNB7fyU2IVDQZQYytgRc0bBnE0UFXsC53woKyJZIJo+aY02ERlCSHSrhix0sHKPQHW9wRlnhTNA3RHIY2E
 XfYOTsmN
 ucASFjjE2NbtmxeQTLsB3uEVGj4/rBb7Vaq6uKgrzR5ye91ahLlJszhZkTeZy7Z09aHvOMc2dSnu4P2B7u0x5HNGcihHFLPJVR/nBZ1sByj9yMxIlll2t+1nIkiDBwfDEtC/1WU8hkS+Bdan03hBs62e/uC1APGex7+X9hMuZo5Zv1xitpPevAXVtxPs/zI/fCB97p+BWZnepODVCIkdyKXwv1vrPce2dTAEAe1J2lYxj+BLAbyj1otB/ba5oSxpejQbOX6ulTtOGdgjwq23ydJEYuQIPfZJfh2KrkEs9r2+P6z4zAttW9Dstcn2Ay7C3Nq9PUwt6C40ET2TNz28MIWO7IDJ0WDS8IOdtm/bhhNQr8wA9gotTJXmojw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are no more users of FGP_NOFS.  Remove it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 10 ++++------
 mm/filemap.c            |  2 --
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 3974b063a049..bff8b7264fb0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -697,7 +697,6 @@ pgoff_t page_cache_prev_miss(struct address_space *mapping,
  *   folio is already in cache.  If the folio was allocated, unlock it
  *   before returning so the caller can do the same dance.
  * * %FGP_WRITE - The folio will be written to by the caller.
- * * %FGP_NOFS - __GFP_FS will get cleared in gfp.
  * * %FGP_NOWAIT - Don't block on the folio lock.
  * * %FGP_STABLE - Wait for the folio to be stable (finished writeback)
  * * %FGP_DONTCACHE - Uncached buffered IO
@@ -710,11 +709,10 @@ typedef unsigned int __bitwise fgf_t;
 #define FGP_LOCK		((__force fgf_t)0x00000002)
 #define FGP_CREAT		((__force fgf_t)0x00000004)
 #define FGP_WRITE		((__force fgf_t)0x00000008)
-#define FGP_NOFS		((__force fgf_t)0x00000010)
-#define FGP_NOWAIT		((__force fgf_t)0x00000020)
-#define FGP_FOR_MMAP		((__force fgf_t)0x00000040)
-#define FGP_STABLE		((__force fgf_t)0x00000080)
-#define FGP_DONTCACHE		((__force fgf_t)0x00000100)
+#define FGP_NOWAIT		((__force fgf_t)0x00000010)
+#define FGP_FOR_MMAP		((__force fgf_t)0x00000020)
+#define FGP_STABLE		((__force fgf_t)0x00000040)
+#define FGP_DONTCACHE		((__force fgf_t)0x00000080)
 #define FGF_GET_ORDER(fgf)	(((__force unsigned)fgf) >> 26)	/* top 6 bits */
 
 #define FGP_WRITEBEGIN		(FGP_LOCK | FGP_WRITE | FGP_CREAT | FGP_STABLE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 6afec636881f..e6580291f218 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1994,8 +1994,6 @@ struct folio *__filemap_get_folio_mpol(struct address_space *mapping,
 
 		if ((fgp_flags & FGP_WRITE) && mapping_can_writeback(mapping))
 			gfp |= __GFP_WRITE;
-		if (fgp_flags & FGP_NOFS)
-			gfp &= ~__GFP_FS;
 		if (fgp_flags & FGP_NOWAIT) {
 			gfp &= ~GFP_KERNEL;
 			gfp |= GFP_NOWAIT;
-- 
2.47.3


