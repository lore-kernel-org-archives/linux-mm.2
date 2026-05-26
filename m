Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6364FCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:21:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA8E6B00DE; Tue, 26 May 2026 09:21:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91F86B00DF; Tue, 26 May 2026 09:21:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCFCE6B00E1; Tue, 26 May 2026 09:21:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8DC96B00DE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:21:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 59C8C1C173B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:21:22 +0000 (UTC)
X-FDA: 84809632404.10.517B7EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A7C7810000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:21:20 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MV9uG7Xu;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779801680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eyoo9PJhlCAMZ6SaWhOaMZ7mhDEU+ecMvXc4liCE598=;
	b=ieddx0yLr6lPdKtwga3eJ/8Eu0VNVQnE4vyugdQBMCNImAVQ+FDKC80JTCdjvXjIhpaJhL
	eOrAr1teVj42n8i08RPoD4wIsuujF15ljAwLTXje9RyJTFonMfnYbiX5uk+5LUmBVpI1ud
	lI+QecaW4hIevP7BQGjBR3TajeQ5Eik=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MV9uG7Xu;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779801680; a=rsa-sha256;
	cv=none;
	b=sBvl7RutxhSNMSqxvqvSNbt6h8K/m5/9pPIGc0MwLWkTNLPJ7cgwvsPTDn927VCT+In1E7
	TGvTGtm9XTsG1TSfAfRlhbgKc9ureSQnjLhsp/8OwxPRmpNElPOJ+7mOasjeEj/oj6veas
	gjDlVmyPpn5WTad2WzPidCTQjQxdgzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B1AC60227;
	Tue, 26 May 2026 13:21:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60E91F00A3A;
	Tue, 26 May 2026 13:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779801679;
	bh=eyoo9PJhlCAMZ6SaWhOaMZ7mhDEU+ecMvXc4liCE598=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MV9uG7XuByY2iOTf/oPmQB6QbRFj3rw1VoYO7qfYb23HqtcxSj9BtlTHoZrFuLL6A
	 2C67nGTFIz4mEF8iJGCFwpYCPXHzt+nxzKUrddPlLw6UbzuvqtqM6G9Xnnl11hhRxF
	 psHW5ah7vsX2G2arAHCNp22quyievCzooAst0AQin3J8OJkTDosckG7VczUskrMXny
	 kMpaEdXN85zNTJgjLn2/9GAv6P/RrhAPgMQYjT5cdWbjo4Kksq9ZZw2SZccivOqsko
	 JGPaS2z+ht9tSup/Mcl5c4IFK7dRT6gt1w0o02rVTADukOWmXkqqYj5OsIB6Dk4uH5
	 K6UT3H/wtfX1A==
Message-ID: <c94768ba-b217-400d-938c-19d929ad2e73@kernel.org>
Date: Tue, 26 May 2026 15:21:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix defrag_mode for non-reclaimable
 allocations
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260520122228.201550-1-d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <20260520122228.201550-1-d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A7C7810000A
X-Stat-Signature: 5ydu6nnm4qp6xnzpncgfb7cnw45okgzc
X-HE-Tag: 1779801680-157299
X-HE-Meta: U2FsdGVkX1/K4moa81VXwfRNQaMPbRquXcnmMj7aWKoj96h/TXAVQoPaE16Ygx9ik0b94hjBBC18qLq9nwh2UezQ54A2HKJCEhwm+vaC8wZmjRssOmG4g7dXL2bMEhAMU66mz1ZwV9Wt7BuwDkahQAhqZLor8sOF73h8t/QeMEVOyYT0hVtq1btuZ66yjhFDCWUbcexPUSBw9JRdIyKIYX72vjNUK47j0DK5tIKg4PycNxIqEds3q+Iu7o+pdUXE+k3HGc+U1+gNosPykrmQMAwO65RoqEUo0YgEagx/1xqWPRahUoQ7zl+ZL5xVNrVNBWLGvHFQwLV9VIX7L8ptSKLg2N7w4Y0jrTJ0KRGqOyL+A0r+YGX0m/XpsZZ+yiZnIyXjMiVnLn0+yy3oZsuDQ3PNumIiqdDk91vJQA9/32eVlYbF0P21RC2cs4//PaE4ukXhDJUvuYuG7mf6PXD4C6vmK9fJvsSwWNTIfrLoFa3HdKLU3JZkbeMPFMgYBLylmY0kNjNGpCHCBbpu+THtYcT60YPT09SY0kq1hultuq8Q8nuT6oyUfyqH9GWFnOBhc3YX3kivYtZm0CvRJi9j+yVMwM4TlDHGKICN9jpENpsRDqO4zVztgVTbzoKmc5y/XxwwjOQPmp22cQZHPM+rNErnJLrB4h8vlq+kLcEI1pkeXFAwWDdByKxOxxXpUgoDw/iBs0jCmfo+alANN27hp7GxdKixTX3JSVhy96zLAndangzqxrXH32GulrhRs7BVdxHf+cZuTsMadu+y6d5+3+oPUdW0k9lxtp8wYG+bjakd9QjYtonPyydxRSHXlkve24XJavSBE2S4Gl+rnym4gp7wuPV0P4T5JaeehLhEterz5uVrOqtGaBct2SBGL+H6Jad+et106AqWdrkZACndLBohEvnQReZr1URTgz7dQhD3zVvoMpeodSKDpPfYTAwlNJkXuCtidZfpGzcLqZE
 LcbY3I7M
 nmLWjQmCRs+unhRpCLq3nLDcx7t6N2lYDr0mzIherYkVama0obNIx1FieoVT6WKr6Gi31SjbVShsL5solpNeiYJ6u2/fOM8R5pjiqlT48ttgku3BS/U3z1G3bIgt0Ols66Izb6e1xFa9o3NUwQ7vS+tRP9JU4uxMwkF64YIM/f4248/lELe4UP5aCZX7odq9KonPuFkKpGg190tNGanaYE9aVIi7HuHWpAdAyyOm6+rHDR+gDi8JSwMjY9IfGgXlEAi4im8Oyhtt0iadHyCLgpq655VMMgQ2to2VBwGHOg1jYOOh6wtvOftflffluM5v4gJUSvTavfx5gWXAspz3Oj7S/GYDSCRsAfknzHaCYjP+1icJmgHOgnHyfoZ78YMFcH2BHClVW86qyRDM/Ty7X56Lru01JNlx7voBDNi/f605Fixv7GFFpitLUIupf6ghnt3U7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 2:22 PM, Dmitry Ilvokhin wrote:
> When defrag_mode is enabled, ALLOC_NOFRAGMENT is enforced to prevent
> migratetype fallbacks and keep pageblocks clean. The allocator relies on
> reclaim and compaction to free pages of the correct type before allowing
> fallback as a last resort.
> 
> However, non-reclaimable allocations such as GFP_ATOMIC cannot invoke
> direct reclaim or compaction. With defrag_mode=1, these allocations hit
> the !can_direct_reclaim bailout in __alloc_pages_slowpath() with
> ALLOC_NOFRAGMENT still set, and fail without ever attempting a fallback.
> 
> This causes a large number of SLUB allocation failures for
> skbuff_head_cache under network-heavy workloads, despite free memory
> being available in other migratetype freelists.
> 
> Clear ALLOC_NOFRAGMENT and retry for allocations that request kswapd
> reclaim but cannot do direct reclaim themselves (GFP_ATOMIC).  Purely
> speculative allocations like GFP_TRANSHUGE_LIGHT that don't set
> __GFP_KSWAPD_RECLAIM are left to fail, since they have reasonable
> fallbacks and should not cause fragmentation.
> 
> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


