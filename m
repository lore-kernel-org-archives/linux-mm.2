Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F0DFCF649C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 01:11:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC7566B0092; Wed, 19 Nov 2025 20:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77B36B0095; Wed, 19 Nov 2025 20:11:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66C86B0096; Wed, 19 Nov 2025 20:11:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C0D236B0092
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 20:11:39 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AAC61A0705
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:11:37 +0000 (UTC)
X-FDA: 84129207834.18.6B3D83C
Received: from invmail4.hynix.com (exvmail4.hynix.com [166.125.252.92])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4A67940013
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:11:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763601095; a=rsa-sha256;
	cv=none;
	b=8H0LR5KPjYa4u4dx0/d/6+tuhhU91f+E3TpsY/NjulhUf1su7hny7u5JxGssBylHHqepnO
	q+n/dcuI5c5DSD6jmHmVdavuaZsevXI9Kn70rjDu+e228OD0548SyIveYhjWT4ee76rJ+k
	Oim+QicDIzumQmuSOCcqmRa7JlGyvY4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763601095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=qPKqnv35DG4U6a/ztoQ9qpFSmco5mZwTTBFElxax3xQ=;
	b=aSvYylsHfek5GPdkjdEfUP1hs9poB5KGE851j3bnjSHoadPE8Hoe6EgyHsxCt9pg9AsVgM
	XmeFt0yQC0NbKvt2/Xd8aPMNypC4FVcbdLP8VL5pW52rS2EOq7T+pN2At0ACW43raxXfVr
	GzL1zoaoeQgvCaSIqw2x4/qn/tLOBaA=
X-AuditID: a67dfc5b-c2dff70000001609-09-691e6ac0bb8f
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
	almasrymina@google.com
Subject: [PATCH net-next] eth: fbnic: access @pp through netmem_desc instead of page
Date: Thu, 20 Nov 2025 10:11:18 +0900
Message-Id: <20251120011118.73253-1-byungchul@sk.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsXC9ZZnoe7BLLlMg+/HuS32NS1jtlj9o8Ji
	+YMdrBZzVm1jtJhzvoXF4uv6X8wWT489Yre4v+wZi8We9u3MFvsurmGzuLCtj9Vie8MDdovL
	u+awWdxb85/V4uSslSwWH0+cYLQ4tkDM4tvpN4wWlw4/YrGY3djHaPH7B1DZ7KP32B3EPLas
	vMnkMbH5HbvHzll32T0WbCr12LxCy2PTqk42j02fJgGFd3xm8jh3scKjt/kdm8fHp7dYPN7v
	u8rmcWbBEXaPz5vkAviiuGxSUnMyy1KL9O0SuDLu9WxjK3jNUbHqSwtrA+Me9i5GTg4JAROJ
	vg/tzF2MHGD2nquKIGE2AXWJGzd+MoPYIgK6Egc6JwPZXBzMAp+YJSYvus4EkhAWCJH4v3oD
	mM0ioCrRsPEHC4jNK2Aq8fL8LlaI+fISqzccAGuWEGhnl1i+5Q5UQlLi4IobLBMYuRcwMqxi
	FMrMK8tNzMwx0cuozMus0EvOz93ECIyCZbV/oncwfroQfIhRgINRiYc34phsphBrYllxZe4h
	RgkOZiURXlVHmUwh3pTEyqrUovz4otKc1OJDjNIcLErivEbfylOEBNITS1KzU1MLUotgskwc
	nFINjN6h16cvWWSzsTIiT1u/nJtRbsV2GS7V67dip3zc/it7T2zRm4O7rdf2fpcTvW4q86Cj
	rH+HiP/MGqadX1U4oo4Ya/hWOLleWxyo57/rh1X36nYZj4LQwgsp+y//szCVOB6cMLsyxiZc
	1Dful23rUja9lnmlyh3RL+4e2R399X5FwbKOlvIfSizFGYmGWsxFxYkAVscVQX4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAAwFlApr9CAMS0gMaCGludGVybmFsIgYKBApOO4MtwGoeaTCcrzA4voKmAzir
	+Hg4p+C4BTicqrYBOJzPhAQ49a/6AzjlxuIHON+m5gQ4vIe3Azi+0awGOMOdyQU40LaOBTi3
	gOAHONO6nAY43qz/BTjJmqkEOPHIyAE4xqAWOPbL7AE40sPiBDibgY4BOPv4nAY4m8XeB0AX
	SLSp2QJIkYPuB0i5mt0HSKCydUizqCpIsqqJBkiy8pIHSLm48wJIztF4SI2D7gZI8eXaBEjv
	vtUGSKPo8AJIzKDEB0jzsh5QD1oKPGRlbGl2ZXIvPmAKaN6MtgZw6wh4qvSEBYABvAeKAQgI
	GBA0GLzVIYoBCQgGECcY2Nj5A4oBCQgUEC0YwImTA4oBCggDEPIDGJOi1wKKAQkIExBUGP+r
	sAKKAQkIBBAlGICx+ASKAQkIDRA1GOnPugWKAQkIGBAfGKuwwAOQAQigAQCqARRpbnZtYWls
	NS5za2h5bml4LmNvbbIBBgoEpn38kbgB9NNHwgEQCAEiDA1Yxh1pEgVhdnN5bcIBGAgDIhQN
	JUEcaRINZGF5emVyb19ydWxlc8IBGwgEIhcNSldlYBIQZ2F0ZWtlZXBlcl9ydWxlc8IBAggJ
	GoABoJHbR2sVUCzxuoDwxyMmkqBXF4al3Xu+/KeWDFycuLHThKC1KVAB4UhuTInEILi7Yc9F
	LSPhohFt3YrI6sYdAyb4t6hro/hiVt9dUMepBuE0D0Iykco+5aIwqZWeTTBz+t7PiBCCGmPc
	hiTD6LBvqu4JFXow8q8jzbRTUA5WRDgiBHNoYTEqA3JzYZmxZ6JlAgAA
X-CFilter-Loop: Reflected
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A67940013
X-Stat-Signature: 4tx78nthqug1swwyj6tmcrtxbjwzampk
X-HE-Tag: 1763601092-942430
X-HE-Meta: U2FsdGVkX1/J8RRyKzI7oTHUYNN8zB0NyEJg8djVQ0GhXPFy079UEESwP2AFD1cBDEUhCA+RSdir1h7o6POlJvSYB8+QwPxaxlzfCJEijOYUSOW+n67CnRLRsM4SqjiFfqD6DoDpwTOg4bq6v+rnzsvqL02M1SUMMTeqqAIwBT5ammZqa5Yk29OSBcdYeaGZdGeacNKMR9335N+dxGrosaEKz3Pc7EuGdBeCwgyIjy+gylCrAYjbFQPwQc8PtYvmnOBu6dLEAkpgz2C9KjY+w/6EMW1QtdQRdpwxTWgBb6glXF/nHrGjy7+xQnRcvpY27NYgkAocBbdOI1KpZO8P6b6fDX+vdK4SHtXinh+B97/9S2l5atYU2nIBxbmmHtJ5L5FlGfaOQRe7czCtDKl4F9W8NfILWJSQVfKQTVgVx/Nfb9gIP5UbyY6zQdVN9yEL4RHX75WwwAXUhpipIYp1CbAcAtOlAoyMz5M4TUtAXVzjaYBVx5NmzCMcdFQ6xPZQvSihgT07bzJRCzdUmzhhDdvdk/HNO7c7pM43iZ3JRhdiFpvEZOvJdZA+fNBke60jB341h22ilNIm+3JEMHCNYRn94z/6ANlmNv7YgQbTgffYvqJc2uwOQDGIBqjqlgZw+0+wQ57eiNOg3mfvTcRhXsYhsF9fYhiB4vQXH+c+LVNDmiHDUgVos/k2hQ+3L10NIcXsDwTOvfoGJaKkL3bBRx6tFS/YEaWYnrTQcGS2cbx2hulbdCrcQwjaSsAodQ5UA569iTlEpLgmW7m9uzW5z9o2akHPRob9+pTGMT6xU9R3Zz5xHPqRAz5ImzZFiojkoZ9H9eBkVG29D02tDfj8EPZaxmwnFGh+U2k2QhD2esAKlSyimzfw1+DQYltO4E4Bgeqjym+u9yq7Gl+aMJoO711+wjiQC4OVlyt37j8Vj/6pur7iepM1aHyeemhTu+hRgTlh7Ituidj0GB0/8zM
 auwD4vwp
 KSRLr7zQbVpKPPVH7N/3C0/AiMrko00Wns7lrqFGD6znyxXA29sdHzRcaWAzq67ae7zmuV4laX88BL8VkGQI7+SsRag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To eliminate the use of struct page in page pool, the page pool users
should use netmem descriptor and APIs instead.

Make fbnic access @pp through netmem_desc instead of page.

Signed-off-by: Byungchul Park <byungchul@sk.com>
---
Changes from rfc:
	1. Use pp_page_to_nmdesc(page)->pp instead a wrong approach,
	   ring->page_pool. (feedbacked by Jakub)
---
 drivers/net/ethernet/meta/fbnic/fbnic_txrx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
index c2d7b67fec28..56744e3a14ec 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_txrx.c
@@ -653,7 +653,8 @@ static void fbnic_clean_twq1(struct fbnic_napi_vector *nv, bool pp_allow_direct,
 				 FBNIC_TWD_TYPE_AL;
 		total_bytes += FIELD_GET(FBNIC_TWD_LEN_MASK, twd);
 
-		page_pool_put_page(page->pp, page, -1, pp_allow_direct);
+		page_pool_put_page(pp_page_to_nmdesc(page)->pp, page, -1,
+				   pp_allow_direct);
 next_desc:
 		head++;
 		head &= ring->size_mask;
-- 
2.17.1


