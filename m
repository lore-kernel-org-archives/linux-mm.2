Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8A3CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 11:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 417D68E000A; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF9B8E0002; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CDA8E000A; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1EAE28E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 07:55:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C26DE863DD
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:14 +0000 (UTC)
X-FDA: 83873184948.01.78F5FD4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4F8441C0003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:55:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TJ6w35qT
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757505313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QcwxEZxe6uNDAQXL7KVfe1Gedp8vtUAtD/LkWp3BPzk=;
	b=UQgQv9GBSbE1OoSwGuvEftja77EfO0bXlBAa/+aiGeBSDaMhgoV/ejpxZUSKPVxdnUbilA
	Z7sFRn7Et2/PC5vXX0uhEKDcfDq/P5AUR2LI5Kw6AYnF/t6lPwBl91o5Risdwt791C2D6q
	5yRQZ7di77rSIIj1Us+VS36G27rQ3Bw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757505313; a=rsa-sha256;
	cv=none;
	b=Jhmh1kMRn0yAiXIlFm03y2W0y0gAkNA+d82zGSUv3N6hdEXNlVELjHQc0EU23y4Z+6hhTz
	dWBUiv8kOm8uQDq/SSzZixy42lxERPcDwNJIpoKOZ9Mb9YQR4J/a7g9aluZszopqH9bLP8
	EOCfoJ3vcFLqQqraHfAHsPI/RegGW9E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=TJ6w35qT;
	spf=none (imf21.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=QcwxEZxe6uNDAQXL7KVfe1Gedp8vtUAtD/LkWp3BPzk=; b=TJ6w35qTkXVl6NDKXoDOfN/H2S
	XTwTwcY8h2C0HRg5hdOhYrKoHHchs8+570f/Sd2/3o6OamxICq3/ngixKliZKBuhfRlVDo3sp5z16
	D4dmzc2ITLl3gxl/ho3KI5WytXN6+WdqaiAS8vhT0nh9CzXLCZh6j/1zmV3X6PxR4xpf1cPcF656W
	FBJhEjuUxrDc8NqZfkDvxncBG1ZC5VHG7A1z9etSQ5tVTllWFoQt9emlAJPlpkvnWxSSyo7YI6FdQ
	7LAo5vqDiNV2G1hHBff+gLFiuaR33e+SGkXrc9XoZhxGeiKsuhJQodyBZMgahkRrb7Xbc4YXxC2hk
	TnO7qWSQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uwJPq-00000008MFo-45AI;
	Wed, 10 Sep 2025 11:55:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2 22/22] mm: Remove redundant test in validate_page_before_insert()
Date: Wed, 10 Sep 2025 12:55:04 +0100
Message-ID: <20250910115507.1991829-23-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910115507.1991829-1-willy@infradead.org>
References: <20250910115507.1991829-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F8441C0003
X-Stat-Signature: bcojibxx891y885p1a8n7kp54k1e3swk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757505313-217535
X-HE-Meta: U2FsdGVkX19jo5uSNHbVuizTTJsxZjfaLH9AoyIXe1/lYhJcJBjCBdKb/xlk/oTec4YnbD+IDtJsqBQZLcWz0O7rVoJ7XF5726hWaxZed9QzE9hCLp7OCNNl38VQKMiRPnaQN4z+mA6g1x7SQvBgMWvBbcar5fXMEO7OsNFjTYEgaGVZfeGuG3xwiYKIaPbjmRugWF/aTRGiSXtC64i2ICOrCTE11+OpaEKuKsqRfDIPJCqSiMSWmzw4JtCuhS/+wcoLVMydFIeazlIL+LmY4I6udy/nCUVPWSRlE4kMAwsgSeuY8gt1gcnxhDYWaRUarZ4vTnUkt+tfIWI7Wa3AX6MgGYsm2EqYf6X2pPhaY4+zCnSRmMP0+QkZmSpcM/FQ/WFsEHICSIfKsHDmmBtrYUypFuuF7ieP3H7Yt1nTLbNI2pBve9BBUXRpu3jt929/v0n19vAsEGwLJDsPvS3HuHtyKLoD65+arn/gUGnKKGAp0OduQ/INFC1OLCQK1Azr7FyVo9JylMaGZiPf17zEcrbRar8gdLR6dRE+Cl1Csr+VEBHO8gWkV2s26iLO/TujSuNyCvCHOt1q5CaFDM/qCKx9Daiy+Pc7CWzcuD9/MAY75b/ecW4JPsUaKUsw6Ta+gG9XR9FLn7d2SodGyG7+klpGhJAvrrYRvWxRvfXQcjzHA8g21OskBC3fH7ITpxG18iIXyTQcJ4+nhTJzOotAwkaPo8e2OsRi9kpjSLsWkSJmoQc2vX8VItVcpllV/gy8tclBN3DyxjjuFJK4XbABBgDEhPPG6Rg11sgfyh3zwMYuOyrTOGe2Z4Y7E2wTChZMsQp81crZ1tNACl/XlL7TvOhwlr5T6EwXG6jmVZig59dLMaL8xtrFFB4VxgULG9jpdH0zTRFIWQ6o/tYWChdC+SR3zcr0ZmKcrOp2sRO34aorruevnGqEiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_has_type() call would have included slab since commit
46df8e73a4a3 and now we don't even get that far because slab
pages have a zero refcount since commit 9aec2fb0fd5e.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: David Hildenbrand <david@redhat.com>
---
 mm/memory.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d9de6c056179..cc9ba448a7dc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2266,8 +2266,7 @@ static int validate_page_before_insert(struct vm_area_struct *vma,
 			return -EINVAL;
 		return 0;
 	}
-	if (folio_test_anon(folio) || folio_test_slab(folio) ||
-	    page_has_type(page))
+	if (folio_test_anon(folio) || page_has_type(page))
 		return -EINVAL;
 	flush_dcache_folio(folio);
 	return 0;
-- 
2.47.2


