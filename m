Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0482C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 06:29:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 826096B00A4; Wed, 23 Sep 2026 02:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AF0F6B00A6; Wed, 23 Sep 2026 02:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64DA66B00A4; Wed, 23 Sep 2026 02:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 36F256B00A4
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 02:29:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AD2A8A0717
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:29 +0000 (UTC)
X-FDA: 85244050458.17.F523258
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id D455140005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:29:27 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g3ZGbDG6;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790144967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLJDwfik8v5sXhgfZiByNmP7K0w0uZHSBWxfXEf9m1M=;
	b=bJzUywbp+D/B/jk9nCNakq/wkbvNErUh+XgjSLG2YwbDQ6+vCiQggu6/bP+JDBo9GPlZon
	/iIp/ZOcGJm+M/JEisxL3sRk1Vfh+6gEX4HfkoLTKYVpehqI7DYOrR10x58IB8hQQPgkGG
	FimD7aBLsPKkdNozJ4VQnj2v5hnZRBg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g3ZGbDG6;
	spf=pass (imf27.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790144967;
	b=UzWpx2J45CZ221FbdDT3nd3/IjKCwAq6t1VAxzkXS8KQuZMpUhumG7AJ0NT0NNwhpmPTeS
	+oRg/BRSl8mlEa4cgLnDWYNtit336ePHnHEr3baT0E6hz391HTQuTpN1LNYK7ByFhLzw23
	iP09AxkfoxDbn8ll+f/otnmcKNfNLHY=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2caced6038eso4079055ad.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 23:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790144967; x=1790749767; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BLJDwfik8v5sXhgfZiByNmP7K0w0uZHSBWxfXEf9m1M=;
        b=g3ZGbDG62R6BCduB7mHtF53uH3M4q3lBWMmbOBdQI0UQMovRdayir5B7FOYtbcgR01
         0SuHBkV56HSYnnjx3CqBRfR6TWiR6co/drEUVXCDL6nhC+l4EOgPa5hzH0jPq5xYM29Q
         9gLrslF8ddTROn7nAPtcmyMm3hKjTBG4h6OG7bgi/jaZbly1mh1QHrHqtjGX52sC1vdI
         s3WV1ToVB5Z66pf4ry5vbpJ+gxsMwB7jFiO0/wBUEz4MbQ97zgmGAeE6RvbgANT4PG/l
         YXdItlvgQFa6YmIAosGoIc7emW3lXzBj93U8o9L3RZ2IptJ5IsybZ/Y0Pfk7CVlHuyrR
         nL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790144967; x=1790749767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=BLJDwfik8v5sXhgfZiByNmP7K0w0uZHSBWxfXEf9m1M=;
        b=PJSM9axDvtx0PBb/c3qTaEqY7Qs/I+Rmv7w+pNeiWwpRc4HWGbEEqs23wbxyH/z9jB
         RFSQMcjNiGkdDwLhPL4Zd8Km88oAxNK6f6+csgMvJxA8b6DZl3t+FIavV3QItenYMR8P
         grvc+LeBMt7f/x2BKt85lROSnfVsQ3Q4yQgL1wrnKLzt2tFitIb+Uzy2Ujtfk042sbqh
         k8eqRexH6zhnbNLk1gzB62r4PBzdshxS0qtImE+sed9+008R/GlxZ7FsZv9PW7G6U7k9
         QfkyAopKS6f5hzztuEThUgxHauy8ApoMpoivM2tvrGnl+XzoXpj7giq/DGDxdzRzvITv
         PiGA==
X-Forwarded-Encrypted: i=1; AKwUvBz1m1KRXzSC+jJAjxbKMWalspu/Z5UYghnKeEBfo7d/IaJLhej07sk2su3OQfTHS/f8PY9PpQ4CRg==@kvack.org
X-Gm-Message-State: AFuF++kSwfEaGLDhgmNGgB125IBoEqWmvEPa60CwuDTrVJzxOxYA+xAQ
	dGJHNC72xHi3iVD7jAFf1OSsGDlfqznahGNGbzBvymivga6azXwe0kRr
X-Gm-Gg: AYBFou2EMbUvYgIokvFo44miwFXX3zL9ytH3ellAGzIOR0ND9B8c0p4fxx02abt3ojr
	9ohHApMF19yP7asIIxTea1ZBCthWbS35XYtTiWT1o+wdQWedqWJcGl60HYE3+sJ87WV9l6I6Hib
	tJyQoJCUsaIj5N0XqC/oouXn2E9MofjsV/X26DN2fBRgHeJGJFmndvMJoOKWZg3dwkYtHoc2h3U
	9tHsi0y//JDqiCJ3Zc/zEmxmW4HWSeEEKVsknzDKp+W/F/Rw/5mxtIeakXBFVk5zYPxE8BObE+e
	I9yCAvd/QAeGsm1uoEdsnkgiWsZ9AdyerbgIlQnyOmjgGuULX5o7z/GzG3kld10p8LST8oKtuLW
	ZtSXUVHZi+kHd9f/sWm15W36CxEEqqc9ENJAvp8hYmDTKvUb3ZXLp6Z9zT1EPAJbZ7m2HOq14BO
	1kzsvP2uJJhuZDaEKfiIEhOmA3nEY4zv2yH0l0Ke7ymnMymP+Ogfeu9CZB4Rv7A3ljgFeUVcqrL
	NHYfYZs7L703AjA75jxOg==
X-Received: by 2002:a17:903:3c2c:b0:2d7:1cbd:9ceb with SMTP id d9443c01a7336-2df60aee398mr25552315ad.12.1790144966712;
        Tue, 22 Sep 2026 23:29:26 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a516bfdsm5620465ad.5.2026.09.22.23.29.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 23:29:26 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v9 08/10] mm/vmalloc: extract vm_shift() to consolidate mapping shift selection
Date: Wed, 23 Sep 2026 14:28:30 +0800
Message-Id: <20260923062832.479455-9-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260923062832.479455-1-jiangwen6@xiaomi.com>
References: <20260923062832.479455-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D455140005
X-Stat-Signature: 76oqzhe5s93kqbhwamjfscprcx6r54bq
X-HE-Tag: 1790144967-746351
X-HE-Meta: U2FsdGVkX18v4SKvLCCMmfsyOqjO6xxFdaBOIO5OFtO4Q1zPc0roCGCzqrToqVEItQhEeEd/D/yD2h5F7V//yQvcxh0xHRynetCK+Q6AO3iqvvhw+gEqkwIg29DXFIUCoCV7l6GCICORI3xp/SyPSwe5OIqwGXIkwUgi5e0WtGmB0Mcck8UFqHQ0U4Zqf3tRW21lM4w/uw0d14KiHKEmppYu9pK7+ZgeSpeWAb56sbTIKBkMokfwKprinslLpk35XPFlv6lxmdS6C7+ql2BqhPho/zDJvWhj5hB/Pt9vVV0brLmnT8TbAxlpE2XXD0jeLnkubCZVaXre0pjxq5jFWHCVcsmH3bKxos736vTrq4mta3tBNjh1xHPA1vjyxgVz9055iqkCqHJefBMNotuHhoNpIeOmStpxxsIUpeC0/0iWAiePxBJvdKnyxj+cOi/MU+tZD9FEzJMCLu0PP1PzOPRs6gUkHFnowsWQcpRC1HDxMwVvtDfx3RhTycj3lX9n4WJNtZ/+l1AMPT13Z86e+3NnVaG0P8y9btgsv0Gyli2aoisgNNoRHHtEGZhM510gjxhCxjG23Wf5OzZZ4D7ovBRv419pb8OUb7TwU0nWfI1Mhfgim0gyZYUhFIvo06H118qgs2/sbopqyY2p8ZNuOfHCsGIKGSFvRNLYVJ7DqkhPvh3+VoJB29KM60BotRKDIqImLfSkuMjRsf1aqhUlWN7s+7nR3Uud5/XKKULUIohTZ4U7AKznuc4zg33eMhvO0/S3T2088O3LXTgn7MeiEE1OEdYoJmfecKp2+IWn8JKpuC8pWXWGOmU+bT3HxtU2OE7Nlw8SF/nDyJsma7i9/nDTqVxu0J56B/xF/Mpcxyi/iiNKCGzLu1nUwPSd82iMa9q+5ZZMSNTUjx7/QQlylw9CxFBb9ed7S/a11OnbeH4t1uaOGT4rgaKZ3iXY29H45Ly40qWnWkWc3C0dNxN
 igA5N19Z
 O/bDQt5zWkRhVI1hE1BXAb34slKwDarD5WD2M5fXRrPdVtHOIyrVZYpz3brA/KbxKBGSxX0GqAmilSm2APJ5mOvjwc7IJIe6aFvryTcYpBOntKgGoKmvC8bFTiPmvaPgVVpd6pnTYX3UC5XzURW4cIdpLAezqE3rPv8Vx367mPDXIogEEJU8Z6Cq92W2TVX+vBzDKYjkV9fETae/a4tlY4tFX+wQNXMjpcs0e6Gx2yLHLNUJESCg4FhmKZJvtnT0LEb9fce3O55/IXQ7wg9mI8hvSq7uLnHn7ZlaVplna5xUgF8tw5m1IIiohGKU+Cbak5mOJNd6BalOdcEP/LvCrcHujReHnKiIY7KNjYqHvmBHqrA97aIUOAjipTuYiDqM2ZK1NJTgx+59rkJnkD3DaYsvrfTII9AbowLY4UBOwcOsgm0IbBNEQcsRgpDWD0pl7qpaiMFFoQxHWvfJZEibc067zkjv5cUU8kdb7LyqM4UDaPVt0Z5KEbj7e0extpdeN70uu3GNPT3bHJV2s6GwdWyEuJ9tBDgvz383sZr4j3HhNYvHF2zmF5ZeUM0ADPacog5hcLOgeDKrIEiw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the vmalloc mapping shift selection from
__vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
vmap batching path.

No functional change.

Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
---
 mm/vmalloc.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 6e0dec73107a7..a43965016eb4d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3568,6 +3568,14 @@ void vunmap(const void *addr)
 }
 EXPORT_SYMBOL(vunmap);
 
+static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
+{
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
+		return PMD_SHIFT;
+
+	return arch_vmap_pte_supported_shift(size);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -4079,11 +4087,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 		 * supporting them.
 		 */
 
-		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
-			shift = PMD_SHIFT;
-		else
-			shift = arch_vmap_pte_supported_shift(size);
-
+		shift = vm_shift(prot, size);
 		align = max(original_align, 1UL << shift);
 	}
 
-- 
2.34.1


