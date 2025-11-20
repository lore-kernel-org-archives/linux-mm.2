Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41647CF64AB
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:38:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A11876B0027; Thu, 20 Nov 2025 04:38:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1F96B00BB; Thu, 20 Nov 2025 04:38:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8426B00BC; Thu, 20 Nov 2025 04:38:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC7E6B0027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:38:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2F9C4C0792
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:38:04 +0000 (UTC)
X-FDA: 84130484088.14.35167A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6989A100004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:38:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMjkakUH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763631482; a=rsa-sha256;
	cv=none;
	b=AnzqBH9ufEnwXA6wPknZKpqc2ArS1+gVC4gMuCS4tylz76CnpHEvJTv6Z93W3yC1GMIEF+
	EHmfQqF/8q6uud/de4jl0nLQNmEqan0oipEUx3Du7TrxFMFJOKvsYi9ij80DEZRq429QjE
	VpPk+/m2VakX3+Ebswos0awZRZvkE/o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SMjkakUH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763631482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D32m1Y6qK+HlHQtKM2BWdhDoV7TVRFEbcjOflfLxDO8=;
	b=w+EfKZiMRgUC2Rf16BGGptIHVbM2yx5DiCq9hg5nwGsioFm1a3Mvzu3Iy/XgHTOvWq7BP7
	PRWBG/6qNcaS/7QuzRItYhfJbqXv1OOQN79QzJ+KIJJ0VIcqsLf+AYjlS4O5cDEc01Cnu+
	Y/ih4H9lkqNE1eSx+ufCbkPGMtULrGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6158940A62;
	Thu, 20 Nov 2025 09:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5960C116D0;
	Thu, 20 Nov 2025 09:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763631481;
	bh=zKiYw+XBXS9PtcgHarEfgMCTcUZOHXMGkouq0MOYdT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SMjkakUH+b8+6PMAYnTLY8lDCmLp50jbcE4zGqHhjRrkZ6WfZjsq5LNxpMqRK2/gO
	 YySAauK12v8bJa7pmoqDi8SBx4VeAVRQGatfGKK/j3FrWiLAyrUwi1X93y4dQGfPxL
	 q1RCYxGAFCuvCT3vvW26wzP8pRwlu+uB3sbeab3hNHiuSCg3REQPBoh7TRDln4Qr4P
	 OXb/XbQXk+ZLgENPcT4MDZRBzBgUhnAJNqP7JUxRqLMh6/WL+fDObvyLAFEup9ynBy
	 +wCe+thwRScKMlc852OJIbp74rkF3hWNdHhNqBHUEnhqEBDy0tvotYUhwHGrYb1RLj
	 08n0OqKtn2cDA==
Message-ID: <bec37700-8176-45b1-91b3-fb47420679ab@kernel.org>
Date: Thu, 20 Nov 2025 10:37:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/memory-failure: handle min_order_for_split()
 error code properly
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-4-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251120035953.1115736-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6989A100004
X-Stat-Signature: 6o5bcz6aorwufesaojm5k77bmqm713ob
X-HE-Tag: 1763631482-353942
X-HE-Meta: U2FsdGVkX197VfBGF6rHhoOJLgyePQcPtdJzLqxz96qe/81kz2pzAnYVEi4scLuDR0I3FnhRaQkqQJxkpgtm6UGCvyAUhpzasF++vqfI3s1Of1yRguYjzX00qSiY8nfXeNxIJZLVl8+klBMYXePvXCqDzT5p/vNpRKAZ3zgd4g95xS9qN9TCrNgfFjIw9zoWC1Ar5pls2vw6jBDK6LQou4WWuXHVfpuhoQ6f7bUNfUdZiKuFj3XF4HvIvwr6TZoduuHQFPVa/5quIJUzdIyaF7hXdejlKtFFHQkPvucrEqRgqx0UQ3FOdmIA5txbbrQzzXwKdoXe+AOEeXnXwWjaq8Oidxa+XMNEwNl+CrdAo79f3eKdCfZGVs39Z1dkQnt/nKEAXvUzrKFK6JRVaJZtYt2HU5s5N7QrQCSWRpFCApe83d/n6r6CxMr3MFyLqk5r/OKpUtZSq5q4bMgTx/gZJx5iKN2ebQ8kxIq21BFzR4WN3cRYlVoix27BeupPyCm23zvANL36OfK6iBgkk0Qu3zKKVepxgtS8mCbF+u8jYuuqO//e1BWyKLZg1+DJVy/4r195eOWdir9/elmLLAN0HTUpo0WS0S0IneiovSPk8MtBPDSCCb/MOYMGHKa9idVvh2spvniJKhv6QG/4gXCjDCstVpb+iWlMghtxMRmawC7gnRSxiBLtjBezfI+Vm1YpQAidhDkpGzqklK7XHy5HQFuZxUY54cW24M23TaH95kV7gozJgm15j89Kgqt9EpRA+ioEXlHroooVID46mRXaoNID5zRC49JdyUqvKryT/o/7lLVQhdWfEUjPnPVa2yzFWw+BPQgmOUaajSmk8WOg/lTIbFFAwGCTBohP24ZL4LdK3B++byAlRVo46NldZUP3BuQOFVYuSbGRFL5yB2uwpHoTs9Pb8GW/aIXrPzuXTG8TdcKBoihc1JYmVmSvcEUoGXKyDzeD8E330l+g5t3
 fwDIb/o9
 0JedyRcFCwpRGCIGo6cNd+Ku/FpKVjKKsOkkGLPX5ybQvqKd2ZbkiF73MWzLhAk+sbSrx2/tTaCiVgrnHwBttJP1dr+zG2kCY5+C6osSIuONiq8Q84X9CU6JsFmP89XqlzBtfi2RBl+KUZMPBar7/t6UAdwpNV85QBtxF4aa4ccDnjxq0BnRJWjGszj8AjCMA2x8yS9FzVC+Vm7R04ocMQwG9RnvK6RRMThQ8AEpw4Z2inGQOe1uskU6b/6UKTZXLdliIsRHMUq/67BwmzIKXmLhfk8KQ0tEtvHVjstHfDVro/CF6JCwI9REKpg7FNER2uVUCkkMmJCRp1RWnyiNhfEV1/0qzuqWq9eWmyQfVM9lrREaPVUQHuDvIonF7GMMTheIP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 04:59, Zi Yan wrote:
> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
> split_huge_page*() target order silently"), memory_failure() does not
> handle it and pass -EBUSY to try_to_split_thp_page() directly.
> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as

I'm wondering whether we should change min_order_for_split() to something like:


diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7c69572b6c3f5..34eb6fec9a059 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4210,16 +4210,19 @@ int folio_split(struct folio *folio, unsigned int new_order,
                              SPLIT_TYPE_NON_UNIFORM);
  }
  
-int min_order_for_split(struct folio *folio)
+unsigned int min_order_for_split(struct folio *folio)
  {
         if (folio_test_anon(folio))
                 return 0;
  
+       /*
+        * If the folio got truncated, we don't know the previous mapping and
+        * consequently the old min order. But it doesn't matter, as any split
+        * attempt will immediately fail with -EBUSY as the folio cannot get
+        * split until freed.
+        */
         if (!folio->mapping) {
-               if (folio_test_pmd_mappable(folio))
-                       count_vm_event(THP_SPLIT_PAGE_FAILED);
-               return -EBUSY;
-       }
+               return 0;
  
         return mapping_min_folio_order(folio->mapping);
  }

-- 
Cheers

David

