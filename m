Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAB46CA5FAB
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 04:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E3AF6B008A; Wed, 30 Sep 2026 00:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993B56B008C; Wed, 30 Sep 2026 00:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A9CD6B0092; Wed, 30 Sep 2026 00:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 665B46B008A
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 00:24:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DBFC81A06B1
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:24:29 +0000 (UTC)
X-FDA: 85269137058.23.E58BA63
Received: from mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id CAC1E180003
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 04:24:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TgUVzpOq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790742268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1OKfOOyF6BwRdf3CIc0O5VCRioxKKHcn1/LjJVvnXI=;
	b=ZuqGn+0IJBDTLr/Krp/dqb8JpHHj2s1J3jyYHdtRwplAedeNTG58uzXILzIugvsL6fbC08
	rm006RJMgL9+7v1bMBAi7PXC4eIVBLTBelc3GKyQ8/r7PtxlZM/f3PNDHBZJfMDZtNxtgg
	TKvRhYLNlz95ILSJrQwyjsidnw2IA+Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TgUVzpOq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790742268;
	b=IL52uhHtMEHcSxiafgcoY4Wwnk6a6R4QOKYOTqaxW2iDN/y8IB/x4sMTNpKO6/jgsaVF+G
	fy1JSC8v9Da2EF82iKIynXee6lfP6nVSozpVttsoElSmNKxvfCyBVdz+e/k9+lEXJ1nfAn
	vlk8SWfdIGp/LIiNVb6U1061Z2LQoxc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=G1OKfOOyF6BwRdf3CIc0O5VCRioxKKHcn1/LjJVvnXI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790742264; v=1; x=1791347064;
 b=TgUVzpOqjnPJe9H5dexIn0XHK87NboL/nfI1SdxOEH45hzuGWQlNx+zLhs5bNmYtGvz2tdR6
 syfl+MjRqXj0Wrq0Wj2eGjU2o754/Stbh5K2acwjZd2iOuFO8P9OWvu5C1VWF6G+TcGU0QEAxKt
 sMflHXCkxccGYa2R3123wk0Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e9b7e58d84d31462;
	Wed, 30 Sep 2026 04:24:24 +0000
X-Mizu-Trace-ID: e9b7e58d84d31462
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: maddy@linux.ibm.com,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3 1/6] mm/sparse-vmemmap: drop VMEMMAP_POPULATE_DAX
Date: Wed, 30 Sep 2026 12:24:14 +0800
Message-ID: <20260930042414.97599-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20260929053231.66085-2-songmuchun@bytedance.com>
References: <20260929053231.66085-2-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ennggsqeto9xrbfk4qwbbj8e56owoa56
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAC1E180003
X-HE-Tag: 1790742267-134061
X-HE-Meta: U2FsdGVkX19OVtwh8uEtuQX+X69KYR2eJNvBlbbjlGtLUVu4DKVo9hL1T89Hv0Vu/PICwAmzoBnTKIjV18uzX7BpUCLO5ez4GlutbdIeNXJG8za9Wx4Xs+CP50ltqupnS/C1byUGENglEQ0yKsZEWBpuINPQ+ijLakpaQq8VBNrfpvCzzKqMikrGUTpKla9ulrkNr0enZsUDmrq+ZLDe6URsI/kwOBfls5S90EXljRyvjUz0sZPOQifxlYBuoe3k4k1x9noG+4NEYabsKngComBxGwwMm3VdJTDz10EMfnYKKaeQbIFBJjAbutlOVpxSaW5BsL/fpOMXQZGe68qAR88cnjIki+lqq4BVAi2MYRn1BBwwhHpRhmG13pk+dtGBJW3m7p3k6GH+1UgEYZTS+UC6yQwWU56gfp0xTTLmIvLiuHGimsAfQP2lSXKgF3x8ucy68gYw3VhzfmnS4gAltSEgZDSr6vGmq6izVJtkjG0f3O8wwr6pGNwAX7v6CSMY/WuE/49b3FK3x9fl8jC/5RPRC2pFc/8zES11rIo17msMtCFwmvx56jN+L5wVy7xXymFyLTFAVIiZbTZY57md1eWfO0N+oHIC6FEl8wWg4lydSvACyaLhn+pKSF8O3LIRbZLJho0pdL3IOrHXLAaVtMsZA70eR2KbF5K684Gk8W00apA7UxX981s/zSB+7p+y7NHbGwpZAcwmTZmWhqVeaXjmCGwzDTqhSIIqVHGlgqchcVYa97fz9TGVh4w3JGJ07IQ4C0rpL+3Eh/gIP/6zEslfvSDmfPOgZG6UEn7XWFTvJwjHT5bZgnAsljm9MrTPTRMe6zi90SrdJQFXrzcfFurXUTAkyowiC1ip62bp1BbTyybchphBp76BpnWoudcvDm8b3BoNhlkTvFA4PTNwXCyUDSpZjwEiFBVPs5x3Hbm6u2h0U7tZQVFBVithzuOSaMSyekMqrLfNKpEzey9
 8T9hElLP
 cDnyxk8Bt+e6Nsq+nd50a3Nluy8CxjpX21Gs+KYzesTP+oH3XUKst6oGlXkHAVwk8OVmiYa/alpI4UVI2CzYzmCQZsyD4ApLeRltJ3frw8msR0lyB0+EHQNUcaxsJWOf9L1n5NwFOzzLFTYMAn2a+CH36RtAb2InjvMCbIVVoxawZxULCGYDmIi8i/e2vcf5ggs+iuqiCtsTKV5gb87EHLME51DqD/qMOFY5LRkzYDaKLDA0hVml4sXpdeaL7caf/3+gpkIa1HqU7iIiB+PfLohJkyPpBIc0BffPtCvTK0eh1kGSnA9kkpcO57avthpW5c5GSbYCJ2YbvTB+6D7R5CQL4quGWNg+f3+xtOAsTJ2wLgT5eGtBfpNEC7SO8Wvx67RrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Sep 29, 2026 at 01:32:26PM +0800, Muchun Song wrote:
>VMEMMAP_POPULATE_DAX currently distinguishes DAX vmemmap population in
>two places: it keeps allocations on the normal path and takes a reference
>when a backing page is supplied for reuse.
>
>After Device DAX switched to the common per-zone shared tail page, both
>conditions can be determined locally. DAX supplies ptpfn for every shared
>tail mapping and requests an allocation only for compound head mappings,
>whose PFNs are not optimizable. Therefore, vmemmap_optimizable_pfn() alone
>selects the correct allocation path.
>
>When ptpfn is supplied, the caller is reusing an existing backing page.
>Once the slab allocator is available, take a reference for each reused
>mapping to balance the release performed by vmemmap_free(). Although the
>buddy allocator is available before slab, no vmemmap population occurs in
>that interval. Earlier mappings are backed by memblock/reserved memory and
>do not need page reference accounting.
>
>Remove VMEMMAP_POPULATE_DAX and the flags argument from the vmemmap
>population helpers.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Acked-by: Qi Zheng <qi.zheng@linux.dev>
>---

LGTM! Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

