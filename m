Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B88FEC44500
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:43:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207486B00CA; Mon,  6 Jul 2026 07:43:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEF26B00CB; Mon,  6 Jul 2026 07:43:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11BAD6B00CC; Mon,  6 Jul 2026 07:43:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E63086B00CA
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:43:55 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 788181C3372
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:55 +0000 (UTC)
X-FDA: 84958167630.26.67E36F7
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD8B1180004
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:43:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aRnDJ/nu";
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783338233;
	b=2dDSnCNSjX/j6L7WxljKHMKvwxq6nKL+Q454UtAPhn8R4dnG5XwocOeYv0wcxI687ew/5W
	Q+/tUo+LCILw+uqq/Bnu4m98PkV1iRobXkAmzYH5EcqsrWNm4b+dp6tPu/XT3xXW05ZhT3
	lOHNn4NLiMGjI6PmEAlw0s9vjwSlB7I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aRnDJ/nu";
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783338233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C4ZNEnL6OYdPCfOs5+ioxoDmDMzrZDFFy17TJT3abMk=;
	b=5m63ItWxBgHpt5yh+9EhlDAioyUd2Hr/r2/MbRhjWPcGSczOOXmDRa1gAj09cbeRP5MG7n
	ab6rTrWTJz5bcOAZEWLgOlsQ97avtUWIubQAE/TCuwGou8YTjZichERqatJTokyrnbSlGH
	w7stAlkGZV5JY2aeq7opQq8YbGZLAAU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783338232;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C4ZNEnL6OYdPCfOs5+ioxoDmDMzrZDFFy17TJT3abMk=;
	b=aRnDJ/nuhMQruzyD3kZIlrDMGXS2XdqeylEjARK74qrOuyd/iBxcWc7YidXpOeI2h6Xr5h
	HERU5T4gpqmWSRIN6r2KHd/jXj018GP+MG9Jb7X+TKQNbtqAok07XG2VAO5dW2YJpFSjcz
	dPeA2+azqBgYkGU26FwPTq9umAQx76I=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 4/6] mm/huge_memory: move softleaf_to_folio() inside migration branch
Date: Mon,  6 Jul 2026 04:42:06 -0700
Message-ID: <20260706114320.1643046-5-usama.arif@linux.dev>
In-Reply-To: <20260706114320.1643046-1-usama.arif@linux.dev>
References: <20260706114320.1643046-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD8B1180004
X-Stat-Signature: bg9xxc3u75r8d7kgj4qty7otpmwzpqgm
X-HE-Tag: 1783338233-821503
X-HE-Meta: U2FsdGVkX1879GRss1EBXdsLxgHWUlNNqnC7KFE5HDrXmA31sMSW/jcQfQplSdpnCrbk89+PsipZYz1tFU/p48NkImwkFDbtAPRQBmUXBc3wyXgS1pi6+9eq+7v4MYutVOFMNgcyeeKM80QUusda8+IRAqnX1hnDTyuZdD0HyDButvtTaQEm462tjkwo0UICkzBtCMz6WsdgCveU3TZkWU4WYxrfdwESD7qwx44sfjWSzTZNbJiD4Vv7dXSatTuHfOJa95Ut52PmqdJMsBFSmLOwTbVxKWxL5oDjxtwBEiofXcF7hc3d+D5pDxgfwYApQvla54aVSjBvDfMh5VAG69WogD0N5CIFjOzsKuaDei9SCNCOwtUrXNZ0sDee5j/IyShC8VQsH2KWhHLzwDRbPt0gV5h4lFzRyiR7JT2AkbuxJtwmglonJbbGM54QYsVENe966MDW8gwTyy5aYut0EbLXWiv9KQuJ1OCzt4BONI/72nVmmCQvM1AJeGu+Nt6CxVeWj0YxDVNQGHssHeKdHKMbn6B2tKVanrA/lsifiyDNTM6NAR4NqKjTFU9U6JS33XPnTTwK0zS4WBltmWwDrzPJijDn3ksAwTtRuLfK4jDkE7czeCPSnYeAJnSeVumFdixeuJcuzPo3vyUKe1qWy9vbjuCLK+hDM5MeL99jyD568eDF+DLJdlaQEH3/kPzHIRubKwq1z5rEnk2JVD8cxM4cJV+AI4bGEMCTCX0HJ4c95rln9yV+JsK/awlSdZxCRSmU/5HlD4xAX4p/Ek9PVc6oZCya9vR4XBQqQ+ton1ZWtGruKV3NDZ4CbzSXoXZJxzMk+7g8B9+KOJpoUI4koJ6E9u3xsyH0u3sKoLxTAtsyJBEWshyY0UKPQG0GqA4MQkDIkzpuWs7fKk2fxU/Q+DrQY+LSAuPfCToY8xHhUZu93YuM4C66UlYTYZ3nOFsv2mUkbM+wRvuy9MXD+uI
 tVxP3gNN
 RsbSaip22FXbevk9lgMQfCGbYPAz6HnMeE4V86Nh0OcDI7EZMIyFjY4n1Ro4c/zLLuVHGccVsJ7KFyq67m/F9w52M2z/2EzTjCWtlkPEc9KvoIKwMByqYlgCDD3pRb/g9BcnfT1Ad6wupEdY8PX+zgy6KN7REi8VvOkBx4cjNf4AB9slyOP+EmY+Ms1JXvjeGJSwC2fUUTvsj1g9RZ4J/y5s6/nHFz77ux5XkqzGLIxNd2YXayPMs++9mz8kDiBwKqOwBFghBDzMZfjtU8mZC92L1ViHC5pfRaGTnckfWMB+PEtqSgPDTnaSFgKxv2lZfNqkX8kga4SPLKv3kytsQsuoEGmxlC3kGFsGKPey3XWnha7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

change_non_present_huge_pmd() calls softleaf_to_folio() unconditionally
at the top of the function.  softleaf_to_folio() extracts a PFN from
the entry and converts it to a folio pointer, which is only meaningful
for migration and device_private entries that encode a real PFN.

A swap entry encodes a swap offset instead, so softleaf_to_folio()
would produce a bogus pointer and crash on mprotect() when a PMD swap
entry is present.

Move the call into the migration_write branch where the folio is
actually used, so the function is safe for any non-present PMD type.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b6f8c83c1000..6ada1e862983 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2557,11 +2557,12 @@ static void change_non_present_huge_pmd(struct mm_struct *mm,
 		bool uffd_wp_resolve)
 {
 	softleaf_t entry = softleaf_from_pmd(*pmd);
-	const struct folio *folio = softleaf_to_folio(entry);
 	pmd_t newpmd;
 
 	VM_WARN_ON(!pmd_is_valid_softleaf(*pmd));
 	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
 		/*
 		 * A protection check is difficult so
 		 * just be safe and disable write
-- 
2.53.0-Meta


