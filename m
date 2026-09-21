Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED750C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 07:24:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAA1E6B00D9; Mon, 21 Sep 2026 03:24:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5A5B6B00DB; Mon, 21 Sep 2026 03:24:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48CE6B00DD; Mon, 21 Sep 2026 03:24:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BADC6B00D9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 03:24:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF8A2140379
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:24:57 +0000 (UTC)
X-FDA: 85236932634.27.6BA7856
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf26.hostedemail.com (Postfix) with ESMTP id B1123140002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:24:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hHPpvsdQ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789975496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYfb6ENu9z05LITXdP+abHeFIFgnzSa/Qk0FF2ckOZM=;
	b=2TxV3AS+4Zjgun5d1m8GIOMRLQgn9xQmW6P7PcqZJpu5qv2i8uG7CKQ/ykybbwhVYWgOhb
	BKDj5fyyDO4HjTGFDID8b9wAka/7OlRwqiKHPEuZsJQw0t60dVHfL1zIKtmOyKIEtUZDoG
	8Rl06mPqPujeczXDsJjJSV5+Gm6aooU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789975496;
	b=eNZyadWqTzB3FbmRZqypo6auYnRotR764SR6003MqGRKY4/HMSFSxVtHVglZOd/E8cRqyU
	utRdwdPUraXe+Ej6wovWttqot5cggvORIDulMo/Oi9nYYO+gty6Ibb1qIXt8I5TsPdryNX
	qexAi1VtEdHIs2G1rdxtVTEPU+dbInk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hHPpvsdQ;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Q2h6+eU+5UZjnvGnYVU6mhubmYWept3jKn5v+HruplI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789975494; v=1; x=1790580294;
 b=hHPpvsdQocNJjRA1KZ29kuc0sLubTq5vL4gNpUx4YgMo0qS9tRjKWLTbOrz60iQhfhdrVKAf
 8rsO9+Sr7ZeSTaQ0G2hqhn12P/tqQsfdJexVGEzppWWBeuSX4xGzMKqU0/ZTvfrB3HFwPC/t8t9
 bgUUJLjN0TDjFna1Yp/R9Fzs=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4c701f708d715319;
	Mon, 21 Sep 2026 07:24:54 +0000
X-Mizu-Trace-ID: 4c701f708d715319
X-Migadu-Flow: FLOW_OUT
Message-ID: <c7871a6d-bc51-43c1-a4a7-ed68a8e5aa23@linux.dev>
Date: Mon, 21 Sep 2026 15:24:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/17] f2fs: stop using PG_private
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-kernel@vger.kernel.org, Nico Pache <nico.pache@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Michal Hocko <mhocko@suse.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Barry Song <baohua@kernel.org>, Ying Huang <ying.huang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Gregory Price <gourry@gourry.net>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Alistair Popple <apopple@nvidia.com>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, linux-f2fs-devel@lists.sourceforge.net,
 Kairui Song <kasong@tencent.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Dev Jain <dev.jain@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 David Hildenbrand <david@kernel.org>
References: <20260920-remove-pg_private-v5-0-bb68b6a21869@nvidia.com>
 <20260920-remove-pg_private-v5-6-bb68b6a21869@nvidia.com>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260920-remove-pg_private-v5-6-bb68b6a21869@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B1123140002
X-Stat-Signature: y9usiy1fswx3kh819gqmpw1qc6qf54yc
X-Rspam-User: 
X-HE-Tag: 1789975495-518347
X-HE-Meta: U2FsdGVkX18EbkTMiZB3hCC9387ov7/SdpqWSgX9ubxxOd9NZId0Shltx5UdeC4tJfP9tP38EgcfnnicBi9S+BBYHJkwwViaycF0fNXem1AcXaekSKNWKsjZ4ylQud8mckb1mKduJnvWechbXtKrQV9uQdo0ajx69kzWZyRRaabARArSNONbkXtYrI+S6gcwGmoh0PiXtqMVqD1QWeBZeikij+0zpeCXMEwR7FJDRKYcMGx3f+CUEUk0c9g/j1NUL7H44SIzNXPvyvOUbwK7qGKkJ6kSCGLk/ptyhPNxBcvrCuxEsVytR7MTfXcX5dn4mf1SDTTdRwxjAaO1qzvl567EfusLWBwtkCzzIzKkC1zOtPGhQY5OWGEIRU2gTXyIIhjxKPK0Q0/2OUFpd+PrT5F3QyRBMdlmPCJzu/Y+4CC5fg7Z+0SCKZ03RzlmGjNOZxCdfrh9AVFTvAlYel7scXEmln/DE6k+JgVeeR/0amtz27GmLd/+fISqHgtVgozLq/DFxaGHRK6YD4HKTuoTtWvtD2Wbb/Ov39jaFHErylbFrAFnskeasa24zSMCHJzCzKNRlRABmxXojWUBLBq3O1ZHij9l4qGIZCsnk5DgrT7K9OGf1sEERX2e1+kRhQE8hcBK3Y3X73MXjLys+rQkJvoAh5NozhFQRdoxb07ByxX8wtu3gJfhZIc3vYXg6EbXF+YQs6phoRAFv6Eq27xaNA2x/2df5pgdru2ASYvs5cQgKmOfSfLg8aFhAAFY3dPbzgMaRt+DTCbxbkmtsikd0gTdqHMEyZ42EJ0uGu49keLlasipruzTI0iQJXHrb56MHyy0Qgff6Juj1JBrBCyzigugUWLTPnsLe8CDC2sVtekL1Dmxzp2x5mfZw/L2lUOgNcNtiM2zwzyLMbulQbUsY4W14BKPKaA+EwKyTsJzz3/fyPqPDWvi5n6qVvt+Iuh32mhsLv9T2SvO6Gxe81z
 D6p1xalH
 5jWK5OUMG0q0nsdqRB/zObZWqLfyd8SasYlwkwAkMA41LXAtrPsdXmIPnKN7RD8SpevV12PPtQHh7oq63vLR0Ri+EeAnsun0Er1FghRxPR7CLFma1bI+/eSy/IbZaECJ5AE2vDJcFXS1lXyaUmAaUoN6Nbtg33Jspxij3YlXJKoIfAR1oOtqT8EIYOVY0sIWjDY6pQevCPQcKojQ+2xxWHE4qOxcR2CPPyaq50XOZ9/JlxoMf0vmKEoJVpxmfA0F9DOTkNO5ZgAKuQg+mU4LRY0+QZhqRFLHIiahyLyXfhrYwBnf+rBM/Qt2Idbn3YtmGp6nzB1GOF3qqy8mEYJIw0p7YM8FtCWvhLqvy3PVJ9yIfk1Nv4HYh802Hhd+BIsrzWFhrTOYsdC+kqE4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/21 10:28, Zi Yan wrote:
> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> page->private != NULL is equivalent to checking PG_private. Change
> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> but it can cause confusion when PG_private is removed and
> page->private != NULL is used instead. Change it to initialize
> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> semantics.
> 
> It prepares for a future commit that removes PG_private.
> 
> No functional change intended.
> 
> Assisted-by: LLM
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Acked-by: Chao Yu <chao@kernel.org>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

LGTM. Feel free to add:

Reviewed-by: Lance Yang <lance.yang@linux.dev>

