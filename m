Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A7DCCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 13:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FE428E0006; Tue, 11 Nov 2025 08:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785568E0002; Tue, 11 Nov 2025 08:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600828E0006; Tue, 11 Nov 2025 08:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 302918E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:53:15 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F109B16059B
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:14 +0000 (UTC)
X-FDA: 84098467908.07.A3322D5
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4D1CBC000A
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:53:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vfmHbSQo;
	spf=none (imf28.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762869193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oJ3MIZLrxHKL3HXjB9g5ZhKNNJWUlT+3FdxZLvo6TYU=;
	b=SChr8+13lo2gUUZDW/q14n7mxVL+optYU5t14emKD1UfLZOSeFn1XZTIfH84V9dKw2qRUU
	gR1oo6ZyaR2+3HH39eJ5ZgHvZ9q+wGeY0WzIPXjSD9HS6+SbPLT1JA6AaPUqmP9Wmd9iPy
	bN2wmnFnvKExcmxhPAon6gWv0h9SHo8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=vfmHbSQo;
	spf=none (imf28.hostedemail.com: domain of BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+d2227ed7c5ccf651b4a3+8115+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=fail reason="No valid SPF, DKIM not aligned (relaxed)" header.from=lst.de (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762869193; a=rsa-sha256;
	cv=none;
	b=ZvZJcCMBg8hfvMNWDmxs43vEEqdW+wlTW9Ha87A8qh5k4yAsFykLSvku+ptAifNVHkSfMf
	myz8GG38X+Gg163EBZhXKc8XjdzviSOJZquij95BiHEd6iCbL5rpxpmsmiwQ0WhR3Q+9dk
	RCaoTkOQfw5L4Z9jnrB5sHuJhBKD5xI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oJ3MIZLrxHKL3HXjB9g5ZhKNNJWUlT+3FdxZLvo6TYU=; b=vfmHbSQoKbk/eHEQps3YF+WiP5
	PhmLX7JIBBxB6ei3KUT/QQJE6o3WL7OqfHPAsnzJqb/Fk0K9MAsjUevroY/pdxq9CpdL8ZDMCiPS5
	phsTWN6C0u1We8I80KKJOWu30SwhSDZ4hMf4Dj+YvHeTl707vhGh2sU44aBLPKHietRYx1drr5Gzg
	x+RN3bDDI5Om4oh6zYjT20uZWWkgEdBm62bULDw7pMkc2zjFRQR2CVnj1Zoe9rQH4eYG7eqXm61F8
	XeArfYKWEg9wQNlvET3Y5NElk/GlO7g00tlfCX6gakmyvcaDEVEBKpZmrJfRq0lwqBe61lAZCf+ia
	VBe747fw==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIoo2-00000007GYa-1FVy;
	Tue, 11 Nov 2025 13:53:10 +0000
From: Christoph Hellwig <hch@lst.de>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Eric Biggers <ebiggers@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] fault-inject: make enum fault_flags available unconditionally
Date: Tue, 11 Nov 2025 14:52:29 +0100
Message-ID: <20251111135300.752962-2-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111135300.752962-1-hch@lst.de>
References: <20251111135300.752962-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4D1CBC000A
X-Stat-Signature: fi3r68njkrr7xs5aea8dacqhn3cyxa8b
X-Rspam-User: 
X-HE-Tag: 1762869193-159704
X-HE-Meta: U2FsdGVkX19uxppAABQRHybiiXu/2mcvBDkoDLbszimBsAM8/8SA/Awy4TbjGIPje7PqZlkKUaO/eeD3XaL9h+tpLdwLm1JctnpNfsEOgxoewUogBTPHOcwyMdGgt1OYl4m4q/kvCLML8dHFTJc5ANX3VU06FyA17vpT92zcOYfO8TQ/X8o6qZb9Xqn5ovcrygK1C3oOk3Nxggfu2d4vA4z+A0Y3XnTcUzOmj0kKS5ZYmN6TMGCdTWI0PfmrTW26LOWVC+nVxW+ETbwvEVJFOMgx/VAffb4bCL4X3wou/LddXYLt3KhtRKzkmlVdsbgAClfGSn5iQf3RYMDBGaoCwk8CQnpZLLbsVGTCOCjsom95EyMX6QOxCWnGSrqgjKBoyg05ectL9DGNOalMiJtmTaQ+elIrwQFhQ2Bi6aYn73RKwE2lwU8Qs84EX9IuaoQEbUOFhSWH/cbWhD0xxKvHqkVfaZAr6+x/ZySTVjCs1yw8gnfWlLgBgg6DAjbVZrqK1os0ZU8rW/6t8HB5EjaCLXxxzQHgxcyR8C31sajKs9mFc9GEcMaNVIF4xfjY2u4w/TXBALxhBCkRZZCBtUi5ZGuTafBveUa9FFNIoRE5PX9+FBVKh1jfBXnTdtSTrFPvEDuqYg+sB14thhwmL/qQ2VDT+7URk1TYhGLZd/1yHKVgCLnWCwONYCduv1lTEtGN/hy4UpZ8w/rGEfPu59M961ZeKVf/6vLVXj90p8/mosizFFl1NQFMC25aiQdA3FQu+4uSsxGAtlEP2OXaPvOXi0+Fhc2w9+H/iUPU6m+vXMDqGVuhCP/lRH9UW2GuDvATaLFR5MNjVDI7La39pAVMhjj+9vkKlDGgP7s734J71nopQbsu6fgFLEbZSu2Id+lGgxdHYavYzaw8/leQ2KWJz5bbI9cBwMC3w0hUF7tToJEKWdZumHD2lSBpi9b1WXC9ySsPgfSoPTDQpKGy2O0
 d2MxpPE4
 0O4f7fJFWuqw+uzvQ2tjLKOaIfqAHtJMH6s+5TDi4NFdGVv1Ci4fuRSsIo9gSKD3SjRJ5/l27jbzWMwvGvbMMatSOyVPn6Go/Xv7q0XqPOWqSXZUjIqbczxuLVJhcX9NadukDTwLKq2uJ7YVSO9xUkZLrXuL+0B5+BNUOAdRsgwzOTiJrn/cPvNVs/KK5ROmTd8mBadujmSBCnr1ZmXsgmXb/QsketdgNHSxPRv3vRwCSABFUgJo1DvsJPxQKTB8xEdF38bFbW912b81KJtcgeIHYtIubn8XWEs9CzbYp2lUutRNubJLIfQNd9OGXrDg4xpBwZy4Rjb6yQNDrYsiqB2UTr3IpN26Z5CX+uMV3W+rg9kD4PCZIA1kzg3UGPe9ROHQRXYQjiciZ/Nb89GJKsjH2ndTOwpK0H+7mBTbyWWJwePdNKA7r91Ed+vdI8YYivMO54Gr7Klgr11hnbXfdy5Tf7d4xQ9la4yxvFyNZOVkURm/JBdcx6Wt1wR+L0aNbDEgFXC+7DKRX1gIJe/BgrEy6BCgZAVupvI55QrNbdTb28PovrEZu0TNxuajGTNtIAOitgl/0v5eOuvmz9cnoxLRHikWWdchGJM+N/rKzb2Qs1LI1vHwUWHdQEH9F9cDUcXxm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will allow using should_fail_ex from code without having to
make it conditional on CONFIG_FAULT_INJECTION.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/fault-inject.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/fault-inject.h b/include/linux/fault-inject.h
index 8c829d28dcf3..58fd14c82270 100644
--- a/include/linux/fault-inject.h
+++ b/include/linux/fault-inject.h
@@ -8,6 +8,10 @@
 struct dentry;
 struct kmem_cache;
 
+enum fault_flags {
+	FAULT_NOWARN =	1 << 0,
+};
+
 #ifdef CONFIG_FAULT_INJECTION
 
 #include <linux/atomic.h>
@@ -36,10 +40,6 @@ struct fault_attr {
 	struct dentry *dname;
 };
 
-enum fault_flags {
-	FAULT_NOWARN =	1 << 0,
-};
-
 #define FAULT_ATTR_INITIALIZER {					\
 		.interval = 1,						\
 		.times = ATOMIC_INIT(1),				\
-- 
2.47.3


