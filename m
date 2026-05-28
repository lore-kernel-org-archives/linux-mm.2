Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90ED8CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 06:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDDA36B0088; Thu, 28 May 2026 02:11:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B321D6B0092; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F9626B008A; Thu, 28 May 2026 02:11:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDA86B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 02:11:18 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 536CCC105C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:18 +0000 (UTC)
X-FDA: 84815806236.09.3328992
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C1575C0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 06:11:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2HFd18d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779948676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CK6rWCS8LFvFBXjfIvuhhFhQ6PGQWXZdEx0+rj0MOdk=;
	b=JANAEaqUdodiJnBu52PSmWYAN0xLZkme2PLZjUCNiE2JTMbL4wypauccDXnNHNougKhk5y
	emgbbP+u5W7+Lu6KeztPDz0w32KGN8IdAp/lMNGlL8Kut6dopLi8l2DutYi9nyu9jt8Xfy
	jzVPgswnEytmn168xC2DrvnJSQsq48g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2HFd18d;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779948676; a=rsa-sha256;
	cv=none;
	b=HldNkLN18yqb4EWt8oI30tUzP1y7VZ/b2zr7F1Rl/eYCAK9f9JeM5tGlnWB1w4lb+IQNkH
	T+oGkjtKJWJKL12pYIfCkoBliNTv8x/2mKOnVHIdQWSYD7LxzQFZqR1A+9L5IqndjxtLpP
	2BoF58FEg6MFRxWiLMzv7e7jBHP14KQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5B6440AED;
	Thu, 28 May 2026 06:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B53B1F00A3A;
	Thu, 28 May 2026 06:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779948675;
	bh=CK6rWCS8LFvFBXjfIvuhhFhQ6PGQWXZdEx0+rj0MOdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2HFd18domNKumdoIIHBwF8uHemGwchF21D3CA9EBJFnvRfXOa8fkRnaDoyoUWtJl
	 Smker7kFu8138R2Kspd+I5A39u/cMwQufI2DZwBZZ2v61T7Y4dN62+c9NLEG2ssEj7
	 fOqbyV4KLhMe5HlMfeDdyZdwwYOwgcU25lgjv2bSWjVpA4do6l1vaHWP1f6P5+uVnU
	 sSZrvPauOQbxhh/LWk5qrbEA1Vthcpwmq0ZVZCI1o+FAKQoZ6uBkbQkSfWSX+GQzY9
	 PwZ/IB3qDzaYOOzhThQhavaBcVRqccP6zmSs7s/VtjG9uGjnb1MIEoWH1nsRMkLsTt
	 TV5Y2DUrEQnaQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/reclaim: handle ctx allocation failure
Date: Wed, 27 May 2026 23:11:08 -0700
Message-ID: <20260528061110.2172-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260528061110.2172-1-sj@kernel.org>
References: <20260528061110.2172-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1575C0009
X-Stat-Signature: 18ugcxwycxmm4jxh5nfd9rbj8zhhps1e
X-Rspam-User: 
X-HE-Tag: 1779948676-152138
X-HE-Meta: U2FsdGVkX193Kcl9rQHx7lcrM749v6VbVAmqkmDSDREft3B/NwX8qYVacontc1YSpARY7SWmnhUXu21auFnKelfp8g4RfvXd6NhctJbBAcmdzbiihi5sgjVPO0qGSlJNITxEPlf7Y4Ml7K7zFhdkBtZT+rRs/DHsBhjGX1owUD63R8jP6mEeegkP5fN8Qm0odmEUhZ5op071x31j+7TBliaKgHpFcJuZEhGRf1xBeb+zRsiNpElChqoXvWQM0AsHZEsfgoVYNiKrYVyDpdH2NS48IlLy0JGCnophhzOF2HkARfD0J2nuqk2Es3y/+WbNLGLPz5PJ4I5QnhU9CEDDigtCNqWXFBdyEK5ygDvmlkUhRKEkdr2EFUUOSY6/7DFn+P4ose8yCER2ka48aJQhl9jHUBMfb5ImjxmFr28+UWlQ2fHPo30NLs/eq2Hbg8+qi6W+tdKOawHhIvGV1oAK0O8MlffRigVwi0gj47EzvAhxnhuRDUJYGdUzyBZ/Q3/9Baynj3lk2jDBum79nV9+wtkg1qagyEwd2cctUUJvXcjHJ9mcc2H+XSTLmFz4XsqgBoYaCL0kNhOba/cHNzHhh1iKBD4+ei8pLv4GyZnm0vkOZmm/SbKEeBLibv6ei6ViknQo1dCf0XnE+RfYK4bxEmQP6F/lsNb9oe0FsqKwWnxxRS5QCGiZOYsMqQZg7jGPk2IDhBVs7QzTS77NGeYLiyZIJ0yPbf7s7mvcjq23j9omKmEFdpaLFkifxa4vMRBth/JNi7/IXRcIvPBJtOYkcJdhRW6XXpMAWGCS5GjWm76uHk/AsRL4MK2uFdriaj4/N12f59MSU3sFoQhgfrVETNUi77+czA0N5N779s8P4sDxYMPElADSZCy/Tu6WLIFJvM5E1WHhOoySRpD3vXaBa0PdCWTeFlT4ZxofftoEWRIXxdfKDTlwqvhWj0Km/T+nhZKnEoZt44+mOwhfaxf
 4rh6SlWJ
 TnHCbSeJzqF1bxxFeG1yIp1OlsHalna92dcnxIN2x+A9b3gCSPO4Vn0GMzhSaoPknToNqX4hg9vMiR34b3pSMVO3GA/C5iqC1bCpzLXuNoQ/CEVzx5wRNZpb1tPyhS1y1qx0DCOE4xBNVq0DVPsMvDwVdgZr+2ZxXevkN4rOF+drx4nIq4XPQ5+zlOKd/TWxib6ESLNl+AcX6OWhpXUrKgKpzIU3PUl0Xmo29QLPUMpbtt8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM allocates the damon_ctx object for its kdamond in its init
function.  damon_reclaim_enabled_store() wrongly assumes the allocation
will always succeed once tried.  If the damon_ctx allocation was failed,
therefore, code execution reaches to damon_commit_ctx() while 'ctx' is
NULL.  As a result, it dereferences the NULL 'ctx' pointer.  Avoid the
NULL dereference by returning -ENOMEM if 'ctx' is NULL.

Fixes: 3f7a914ab9a5 ("mm/damon/reclaim: use damon_initialized()")
Cc: <stable@vger.kernel.org> # 6.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index ed446d00ef1cf..ce4499cf4b8b0 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -399,6 +399,10 @@ static int damon_reclaim_enabled_store(const char *val,
 	if (!damon_initialized())
 		return 0;
 
+	/* damon_modules_new_paddr_ctx_target() in the init function failed. */
+	if (!ctx)
+		return -ENOMEM;
+
 	return damon_reclaim_turn(enabled);
 }
 
-- 
2.47.3

