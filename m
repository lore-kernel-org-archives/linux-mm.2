Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D439CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 20:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CB0E8E0108; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906068E0106; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75B9B8E0108; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7CB8E0106
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:44:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DB2ED13C55F
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:48 +0000 (UTC)
X-FDA: 84034186656.27.59EB10A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5C1B2140007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 20:44:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OBzQpCZD
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761338687; a=rsa-sha256;
	cv=none;
	b=6K8oXM1ZyLuwh03HgqQPqesOqQ6stkIHqquPwXyIkOWHkbb7gqVnjdxhU9PRRu0ObUJw7r
	RxIXYdAHf9ngHZnX/MXZp+1QMOr08c009OG8X0CXPjws9xeu4Y1YjnAIxxxhOqIenh1SPg
	l03JzhWMjmi612YIBxkLGEjyZniPA0s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=OBzQpCZD;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761338687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pXwuwRQWDm3ZbfiLHCfMm+40W75gfikyKQVfEDojhqY=;
	b=QuoVnqTuFFufXsHW7ChixyYQKJVj4zw/j4dcWNf3Bl0pfQSK61kkOi2ZwC8tgJyIGhzl1O
	ZtyBm62fFLCXBwijEG07wfYNQXEjJptnc4N/O5L56j8SP3gNWaA3y3h1RY7SmJxlxvSozQ
	bdKHTTn1mffIghRdy4VNypozi8WY2As=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=pXwuwRQWDm3ZbfiLHCfMm+40W75gfikyKQVfEDojhqY=; b=OBzQpCZDsDvFzNn7xwCTgof62x
	/zeWmJkszqEqojiGraTciJAeMFub544BS0RZO29kzQZzYF1o8QB8P8R21KghxmOssAcTu4HWzGgjr
	pVsd7FScKBJqJ19cIHVQsNPgYyMzMwu3ZQn/OjoNvUH6HUxEu8ExmpuKuQNm58qe38nw9MympfJ0L
	qD1wOYMI8T6jzLwbj0w3ZDqIJueP6UrMNJfqd6/mfTllj4NY2vVoMjVRDyqdjVgc0qR+J+qpAg0s5
	kA6RL6UpKo8yIDSNgiTHaC+knwqtimuOHMX5NlQ3bTHsXVTLsYwo0DLUpdnU1+cm/VQDC9DFgoDcj
	tj5i5lwA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vCOeO-0000000AKTM-1HxW;
	Fri, 24 Oct 2025 20:44:40 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org
Subject: [PATCH v3 11/17] slab: Remove dead code from free_large_kmalloc()
Date: Fri, 24 Oct 2025 21:44:26 +0100
Message-ID: <20251024204434.2461319-12-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251024204434.2461319-1-willy@infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p1aahmsm1e8qfegq3rjz3tdzzp6suwy4
X-Rspamd-Queue-Id: 5C1B2140007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761338687-205416
X-HE-Meta: U2FsdGVkX1+9eohBVOeEqx3gxT/O8zrDAg6PUklHPoeQJTtfjKm1kchnJb18cm84ZbCGiFsZQZzRcpFXKruNL5Rmszqjj+AlQzn+nioj/0jN1jQa4wu9bRspn9fMiT/M/+EpwVhwTnNA5qrVFH9VOd8qE2fQECMgK4SlfptI7E4d3cPWbJQeDH2y/Q8nPnWqvnCV9ryYrhcYLm9aI7uPfhjRb2DqMzZTha9iTCvMxaY1Ej6AP4AniZU6zI4HzhXBtUI2CDH6BT054Y2CUy9BDTELqqL0UHFc3KNXfxt0PdI5UvjJNxErwQQbwulXhbwHn6yiAimJO4Tt/aeEJxB/QRm7jYuWE0w4KZ+qrDxi+J5OW8g+wroMRjmZhQ+Cz/BwFGb/OglVux4ZUwW7nrwOe7VqeJM08wv96/GJwUV/laymVSQRZ4J1VCcCIux8UIkV8m69MhPvEra3c4BBcXLTcJr5SdCdDePqCTpszrSC+qfEqqAzpUG2GkegkyIbxHGB3IqN2KEWtnA4vFNStEDJQCsOVzQIseQfkT13q/4mR6Kz104ICVSWJAb7f6EJFSJpsKflkZuWDr7f6aZ7LV9483nnHrP1RuGIKlKk/vL+Kz/I0tm8gZuAJWem1YRjd8wlWUaBFOCmzDyMPWoaCudPWTi+MoLJCwyqpeg/Ajve54Z1o/Gj+V2LTgrvf+z18wrryD/wiMitOoCNV58fRwokchKEJgglf80JM+mt78uCTYRnEQMm6ppykHmmjWdtn8kFUS2vIS26MlnbyaKFEcruqVUgfbUs9jVR2i0FtpwkkmtRTPty4kQF0dtntklq5bra527cfi7jILrfF+J1p/nXllkNdqn6EDhLUdbay9E5ZNdupHHd4Tk9EMjupRevQoxX510QxvQhWjqBkCZO+0tCAtsgDpJC/qXoklsO8FXJp/h9pWXYUf+ftQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All three callers of free_large_kmalloc() check PageLargeKmalloc
first so this warning is now unnecessary.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Christoph Lameter (Ampere) <cl@gentwo.org>
---
 mm/slub.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index e72016ff0236..e37f584352f2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6738,11 +6738,6 @@ static void free_large_kmalloc(struct page *page, void *object)
 {
 	unsigned int order = compound_order(page);
 
-	if (WARN_ON_ONCE(!PageLargeKmalloc(page))) {
-		dump_page(page, "Not a kmalloc allocation");
-		return;
-	}
-
 	if (WARN_ON_ONCE(order == 0))
 		pr_warn_once("object pointer: 0x%p\n", object);
 
-- 
2.47.2


