Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92C34CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:12:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24796B009E; Tue, 18 Nov 2025 20:12:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4E56B00A0; Tue, 18 Nov 2025 20:12:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C6A6B00A1; Tue, 18 Nov 2025 20:12:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 849E76B009E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:12:11 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14A8CC0247
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:12:11 +0000 (UTC)
X-FDA: 84125580462.09.CC1A15E
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9D5D4C000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:12:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763514729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=bhMtPRMDmTEKRd92YEOO6Y+XmIEDiYMkbOau+fNpNNo=;
	b=F9qd6TlmZfvhq0MxiUQn/Z2NgxQ+9SLsPpF65vke61ecc1uAnvc4LuczkhJu/TVewsrGPX
	BTmovaExmAuULC/wJ6QkkNHSsrZGaQ0HuUMxcX4pEjNyYK2G/0EGTt61xKsiL7jD4QReNj
	/zohmTCQ/gDNm5OMQWXR5rP6ULfGTeo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763514729; a=rsa-sha256;
	cv=none;
	b=eUd6Ifbf1RRQ0IzD50OLw72ql690zZQUg9G+r5aoFr4+PjD3OMYFzL2R/njh1AatG43Nbj
	vYIWYHObOjRlX44AETLbS8048BVrLulTTIzF84PLnjg8dgVWIdIyafwc34LS2TFhN+0yii
	DNL8o9sW2IJDHqsEfIZaGumu09UORag=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
X-AuditID: a67dfc5b-c2dff70000001609-1c-691d195f68c3
From: Byungchul Park <byungchul@sk.com>
To: kuba@kernel.org,
	netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel_team@skhynix.com,
	harry.yoo@oracle.com,
	hawk@kernel.org,
	andrew+netdev@lunn.ch,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	willy@infradead.org,
	toke@redhat.com,
	asml.silence@gmail.com,
	alexanderduyck@fb.com,
	kernel-team@meta.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	mohsin.bashr@gmail.com,
	almasrymina@google.com,
	jdamato@fastly.com
Subject: [RFC net-next] eth: fbnic: use ring->page_pool instead of page->pp in fbnic_clean_twq1()
Date: Wed, 19 Nov 2025 10:11:46 +0900
Message-Id: <20251119011146.27493-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGLMWRmVeSWpSXmKPExsXC9ZZnoW68pGymwf4fahb7mpYxW6z+UWGx
	/MEOVos5q7YxWsw538Ji8XX9L2aLp8cesVvcX/aMxWJP+3ZmixWT/rJb7Lu4hs3iwrY+Vovt
	DQ/YLS7vmsNmcW/Nf1aLk7NWslh8PHGC0eLYAjGLb6ffMFpcOvyIxWJ2Yx+jxe8fQGWzj95j
	dxD32LLyJpPH5Vt72DwmNr9j99g56y67x4JNpR6bV2h5bFrVyeax6dMkoPCOz0we5y5WePQ2
	v2Pz+Pj0FovH+31X2TzOLDjC7vF5k1wAfxSXTUpqTmZZapG+XQJXxowV55gKNnNWbJn6j62B
	8TN7FyMnh4SAicT8T2eZYezZS8+wgthsAuoSN278BIuLCOhKHOicDGRzcTALdLBI/HhzEKxZ
	WCBRYsuMf2BFLAKqEoc/N7KB2LwCphIfJ/dBDZWXWL3hAFizhEA/u8TXj3tYIBKSEgdX3GCZ
	wMi9gJFhFaNQZl5ZbmJmjoleRmVeZoVecn7uJkZgbCyr/RO9g/HTheBDjAIcjEo8vB38splC
	rIllxZW5hxglOJiVRHhVHWUyhXhTEiurUovy44tKc1KLDzFKc7AoifMafStPERJITyxJzU5N
	LUgtgskycXBKNTDGm+xfuGnhL9eoyWYit07o3yt70dxkdMxy0dODnRd5pPf9c5d199atKJl7
	dc6d0oaMFRe3qyb6fXa1WuIiPtFwTUX9fl6n5QsvLD3GPq2lQZp9w0fL/40ep07fXSRi8k5+
	pgqvFU+JgfPENIUcQYULR7K6Nq7bpRh7viJZ7HSNgBGzqf+aHbFKLMUZiYZazEXFiQCWGiPn
	iQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsXC5WfdrBsvKZtpMH2RsMW+pmXMFqt/VFgs
	f7CD1WLOqm2MFnPOt7BYfF3/i9ni6bFH7Bb3lz1jsdjTvp3ZYsWkv+wW+y6uYbM4PPckq8WF
	bX2sFtsbHrBbXN41h83i3pr/rBYnZ61ksfh44gSjxbEFYhbfTr9htLh0+BGLxezGPkaL3z+A
	ymYfvcfuIOGxZeVNJo/Lt/aweUxsfsfusXPWXXaPBZtKPTav0PLYtKqTzWPTp0lA4R2fmTzO
	Xazw6G1+x+bx8ektFo/3+66yeSx+8YHJ48yCI+wenzfJBQhEcdmkpOZklqUW6dslcGXMWHGO
	qWAzZ8WWqf/YGhg/s3cxcnJICJhIzF56hhXEZhNQl7hx4ycziC0ioCtxoHMykM3FwSzQwSLx
	481BsAZhgUSJLTP+gRWxCKhKHP7cyAZi8wqYSnyc3McMMVReYvWGA8wTGDkWMDKsYhTJzCvL
	TczMMdUrzs6ozMus0EvOz93ECAz0ZbV/Ju5g/HLZ/RCjAAejEg/vjwkymUKsiWXFlbmHGCU4
	mJVEeFUdgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5vcJTE4QE0hNLUrNTUwtSi2CyTBycUg2M
	GYt2JXJmzPU+Uu/3ec/vmQ+nTppud+NvxN77myYFTPSbnloopSZ/gun+U33R7XVnQnxVr30K
	lzA2WuoTzyBoOC2nt1mEverBruXap8/tv++ZXCXz2u4vd43PziKjtsfKU+acuJVWsl7m/8sb
	pwoyT1zSSzc3Ly6r95Bvb9TVMPnf8r5ZRN1BiaU4I9FQi7moOBEAOo3XlXACAAA=
X-CFilter-Loop: Reflected
X-Stat-Signature: czwfarapa95ohdiobe5j56dn3m73ot69
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D5D4C000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1763514727-148749
X-HE-Meta: U2FsdGVkX1+mvl9JNFA5/OjArlwuWH5cM1a/ABe09NbKeAdUjM8i7IrXut1m90j9JxtBwMKJskitq+YnwjK4XoBF22fN8cjpEsZk3OuvVJUheZruN82LXmk1Bl1+P4ZyPLZX+NU55r8SAqVPTlkA4ZEPFvOnWk6N8wRBrEOo0GN89glxQ07OAR6KLPyDqkJuW52c1S51H9G0Qotw7jLSLmZtq32fT04mrtxF4kz2dGmWNsM8cfujE076QODz7s486yUMS5f3UChAauta4VXgscwRPF5FQZ/6dgxeA8mLzb06MTl3wRZQKbGLBhUDHwRwQJHB8aI2tGL+zUYwW/RJjevmwWd9VK4oj7Uhy4n+uq3WGMpFZz9e3+7PraQftxfPbtt2r75J2Hvbs10yu/BhtYQ1f+ZmEfKa5I46NVhM3ZyfFT3RTWxagS2VfLisA7l9BNQRTVM5LkFhoimoDGkSWPK8eBOYS5CMGbNuFmAmrU/ZbdxJLLxYrJMyGK+/F+KFFESnD1WWljAbAzdT4XTmj6/fYGfVV6jh7m+WQgHp370qJrgIh8uIMgSgLPnB2RA+d1snRr6aFMpljmjc1UrPW0QAAeS15K6TYBaeeLxIX7Ph75DZxaH56d2r+u9kW4cPHfWkX8K4TFLMoVZs27xDgIbY5clLegEKtjpaKubTRJV/iAHT2+gyBdzGnNFL/p3fVhD7hIZToc7wnOzzeRo6jPomuH2DgTjfLLmh9EW29QjsBvnaZItCorW8X7gpEAIRrbLNdSLQBidwCfFVQKeehOGL22t704ElL7/vWIqPoVTgeZBYRYyjujIO1Nquez0KgXhZRKwCJe1+p9nFdNKgjjrSSMmxWqJxOC48W3LmxjBFqUKL5sf8AmPo/lh0FBBysKH/Pb1uKYoMVu+lKb7AUbolKWK6OqPWgT/IsJsvEHXG/u9PTl98dtXemEkvvYlj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With the planned removal of @pp from struct page, we should access the
page pool pointer through other means.  Use @page_pool in struct
fbnic_ring instead.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
I should admit I'm not used to the following code.  So I'd like to ask
how to alter page->pp to avoid accessing @pp through struct page
directly.  Does the following change work?  Or can you suggest other
ways to achieve it?

	Byungchul
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index b1e8ce89870f..95f158ba6fa2 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -653,7 +653,7 @@ static void fbnic_clean_twq1(struct fbnic_napi_vector *nv, bool pp_allow_direct,
 				 FBNIC_TWD_TYPE_AL;
 		total_bytes += FIELD_GET(FBNIC_TWD_LEN_MASK, twd);
 
-		page_pool_put_page(page->pp, page, -1, pp_allow_direct);
+		page_pool_put_page(ring->page_pool, page, -1, pp_allow_direct);
 next_desc:
 		head++;
 		head &= ring->size_mask;
-- 
2.17.1


