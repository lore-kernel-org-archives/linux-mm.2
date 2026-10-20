Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DA38606A32F
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 09:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=k/L5jPXy
Received: by kanga.kvack.org (Postfix)
	id 899AD6B045D; Tue, 20 Oct 2026 05:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872626B045E; Tue, 20 Oct 2026 05:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AEF96B045F; Tue, 20 Oct 2026 05:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5AC106B045D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 05:17:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CB886C08A6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:17:03 +0000 (UTC)
X-FDA: 85342450326.30.8B2ACD4
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	by imf05.hostedemail.com (Postfix) with ESMTP id 781DE100007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 09:17:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="k/L5jPXy";
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792487822;
	b=xZUPfAyZF+Lq7RS9MIyoAbY7HF4Rcm4wLg467FpmyvAgRh6vG8IwyHu6GHyAYpFMoPRxYl
	/6sbJduqTqYxoHiGhxVdCZfWZ9bO9NALU/Tt2NvgoBYV1T1qfqhS5bXZghvlz4hPXK3jT0
	zNSB9itG99BxC5FyLZn3DAuit3MslGE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="k/L5jPXy";
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792487822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2OJQneVXzHsU6jtIwV8VLa8IKZc3t0bX3hcGv+HLpME=;
	b=Zvqxv/lsX3RlLnuFaLwdqDvnBEtOHvQ2+R+TCWPhPkRjKlhjgOlcdkk6NMUosrB1m9NcwI
	CspLiEDJ+3G5DsUJBAqd2CyXIQgFTgo21hYNdMj/k0I6MmmJpsksFXfkSdqdn0jt0QG7l2
	9tlIy0R5AZa2kiWyTQE46LYLjAl6Vu0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dYX2kPoxWrbNwBfYkNtIIo7jKtdrSVqmblUTcmMldi4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792487819; v=1; x=1793092619;
 b=k/L5jPXyGgLlI67mkLu6pAyH8ojK/x/WvfhH1WZOXWJr2T3fwfFO7ntq5zkDa6OWtMumudT/
 Mavu0+1xq/+D0ChWfoyRElhhqlkTarmYeGzKF7gqb0eFm/t8DP2qkLzx4i3NMXPsqSm82vt2GnL
 FMl1uL/OZMGj4kT9ko2WQkZI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 70351ff65c024f16;
	Tue, 20 Oct 2026 09:16:59 +0000
X-Mizu-Trace-ID: 70351ff65c024f16
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: qi.zheng@linux.dev
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH 5/5] mm: hugetlb: enable CMA allocation for PMD-sized pages
Date: Tue, 20 Oct 2026 17:16:53 +0800
Message-ID: <20261020091653.14959-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
References: <df6eee954b62f41d65c4d087d17a7a7cf60da791.1792136742.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 781DE100007
X-Stat-Signature: qki17fmck719zthks6b5bejyz84fbfao
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792487821-907425
X-HE-Meta: U2FsdGVkX1+RGrgqrK6JTdLviGHcU0FADdV0Ap8ZaPOYUqbFCksYLPNqyQDFyYqXdfCeuEJhdqFx8gVqvjlJjAu3dqoN98BBbe4jEXg0EW2mzx5e0J9CU4nqXtQyUxITBVwyuFy2KqWHFEQKquQX0x1Ekfzp1iisJNbuCcz8KtLM6lW+1DWM/QbgmcIzoYgSE1rYe/I1lD6ydhZTYgJMGBXF9Wi6FzT5aoJAJj7Hibj7DwGEAtxuS7IlXTsbrEeIXvhnNVfqoEExluSCunIrDJ656cX1bQ6NI6vQ6fW3tX/ZLAzsSaHBxQlZLNpWtmSo9XhC1T0HFLKpjEzh628DPIrdx4eG1tFHMypwJ2n0/W7ox+LfWs9BD3wQm/xPqXnjEu6GO8WC7OShNl+86iTEtk0zCmGdw/D9rO94/VCCwtPsvzWx/DEViKcAjgxLErBmeTT3Tc2QLcaYTNXHYtnmnMjgd0UsCOuDr0NELv2f8Lsus13rL0p0rde+3VPxsm2qi5eEShqIK6dtKYAEGacYzNeQv5JtKyrZsR0O7ukVeR3tdUdalCNRml/jxyR7E7jlu9pvE66/c8nDotw7tVlqQxwgQQNEGTLSPaCelzKxFGI046SAlQvsocEVMlp0GJhvCfh7baOCb3nY3QOsNJfKNDPJafl9lucxB6PG7YGBHhOkYFlzS/nLDlcDAxzRshoXn0hPDzFcOml+85EsVxES389wglE8TfTcRVdpfRRuALba4uGH5uDxdCFUTmIe+QcYpw56eS1ZAFG9EYWD+CwUy1J4Te8iOWIS9qnOVCG5875f3p2iiPH8KIbnu0XC4cm6ym7Ud4GIeE8xxVZ/Csyj6wkWoBgphr4RGN34SxJe4cPGoxZnTTzyoST6gTBFoymufRFNESyPVk8RFZ1tJqIebyDeJCwsa/KgykHXzNpNo5Cj3A38tgfC/w9apCiYmqkfMuCZXR7xKAQbiY3WsIo
 WhTFG5Nv
 Uv1LaAsy6dEMgkWkQi5BpPWxzdWnb4ssRv2rjcC1Xlyac64l32m1kDx5sL1Icilc/7asNE8HdktD+s+LSRDw1plGZX0+u/F5ad97aTg8eO5ejw/5bdwhfUpsEn1rAGY+0QfhpToUUfq/kIh/lvkfAZb1m/f/Pz4zH7GC4wpiwIk2aqBVBUMyG+TUWiAF5ISffFbz/YunsQQo25RKn5D3ZWiQxNlwa9cISbYUYg91ZRPx6n48RNuwmWztYXbs+C3YdqvR5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Oct 16, 2026 at 06:07:36PM +0800, Qi Zheng wrote:
>From: Qi Zheng <zhengqi.arch@bytedance.com>
[...]
>diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>index 218fbaee6f7e5..8c00fd9d0658d 100644
>--- a/mm/hugetlb.c
>+++ b/mm/hugetlb.c
>@@ -1362,18 +1362,8 @@ static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
> static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
> 		int nid, nodemask_t *nodemask)
> {
>-	struct folio *folio;
>-
>-	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nodemask);
>-	if (folio)
>-		return folio;
>-
>-	if (hugetlb_cma_exclusive_alloc(order))
>-		return NULL;
>-
>-	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
>-							  nid, nodemask);
>-	return folio;
>+	return (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
>+							 nid, nodemask);
> }
> #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
> static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask, int nid,
>@@ -1849,11 +1839,18 @@ static struct folio *only_alloc_fresh_hugetlb_folio(struct hstate *h,
> 	if (nid == NUMA_NO_NODE)
> 		nid = numa_mem_id();
> 
>-	if (order_is_gigantic(order))
>-		folio = alloc_gigantic_frozen_folio(order, gfp_mask, nid, nmask);
>-	else
>-		folio = alloc_buddy_frozen_folio(order, gfp_mask, nid, nmask,
>-						 node_alloc_noretry);
>+	folio = hugetlb_cma_alloc_frozen_folio(order, gfp_mask, nid, nmask);
>+	if (!folio) {

Emm ... what about PF_MEMALLOC_PIN here?

If a FOLL_LONGTERM migration out of CMA needs a fresh hugetlb folio,
this can allocate another CMA folio as the target.

With HVO disabled, the old folio is freed back to CMA and can be picked
again again again.

I guess we'd keep migrating between CMA folios without ever completing
the pin ... even if pinnable buddy memory is available, no?

[...]

Cheers, Lance

