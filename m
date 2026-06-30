Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 408A7C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 13:40:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9716B00A7; Tue, 30 Jun 2026 09:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA0DF6B00BD; Tue, 30 Jun 2026 09:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91906B00BF; Tue, 30 Jun 2026 09:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEA0B6B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:40:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 38175A04E5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:40:03 +0000 (UTC)
X-FDA: 84936687486.14.A5CF42C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5BFDA180002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 13:40:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9jJnG7W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782826801;
	b=RVU8uyQrDe9PaajAcsz+s/BHFBaftVCoQs4p2Tp5LMpYWUP/OPEZXqx4K9SyzUIDl1DlmJ
	PrhRjkHnoc79GOGUFte610rJeIvRauBxT6QMF9fmm8sONfV6Z/+QUl7b7dCvkDX86hgAjL
	EC/YTpqQ3ZMZ/UcPuNxCWddANbUms/U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782826801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0phyMnWezcU9MmzmfXfHgx0JGNa4GUrTZOFULyjll9k=;
	b=Q40+5laoSqZ4dLkrM7UzHhKteM+BJpWA1k83Oam0qkuO2+S+I2khx5YejQY8A82uv1l/OY
	fEo22X7TafQfb566wd7bR64mz7GDRhbPg2NAMj8fnj05qL6pfjZDTNn5HGJhjW89Mbb1yb
	9UYIN+2a+Blu46BDsvS4tZwuvX5eegQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b9jJnG7W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8840E40532;
	Tue, 30 Jun 2026 13:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F257D1F000E9;
	Tue, 30 Jun 2026 13:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782826800;
	bh=0phyMnWezcU9MmzmfXfHgx0JGNa4GUrTZOFULyjll9k=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b9jJnG7WMRwu79rfljohbeuTGvO5gBcBCsIiYnzlmdPCmXjjz2TEpcbb9LC8DEprh
	 7t57CU12zwfUBmE52Jqfkt6UsU476jgnsQp0pA77CBplLbXyo67Dlmc30rVO47Eum+
	 RZjO7q6+vZMfPQo2VkXN/RUofdktKXDemTkXBN1R0UcrfYJar49LqetmmXJJJS0IKf
	 HkeTTDbrcB9Z7/vwy3wq4DZU/66l9+A+nea6HMeng2pt612w6s81Px9MCb18K4+Gc9
	 NTSI7jn9wDTK6MsHBmHFGj9OM/9Mx0sFjRu2dlFBlD0HDkYeYJ+RdBtVDM2cmbeVQX
	 4QD0xtTiHtJSA==
Message-ID: <d44ae8a5-ec70-456b-92a0-ce7ccabf6917@kernel.org>
Date: Tue, 30 Jun 2026 15:39:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: free allocated PFNs if the range does not
 match
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260629-free-pfn-on-alloc-contig-range-error-path-v1-1-496ff9ca22db@nvidia.com>
 <4549ad0e-abb1-4156-95c6-5e3c1319dffe@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4549ad0e-abb1-4156-95c6-5e3c1319dffe@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5BFDA180002
X-Rspam-User: 
X-Stat-Signature: rkgdy194pjjyq48gdtkffc4hj8jicfbg
X-HE-Tag: 1782826801-957575
X-HE-Meta: U2FsdGVkX1+vnLz9ZOVeXK09sItUhQc4wcb1Z/w4QGWslrRUxKw2saroyZJPP58qelzE9Ssc6dDnCkS01O8olu31OyoHSlXFgVc7d9T32DT7gbivRlkS5tH3Jcdt0cah5OUGKLLChRE04kasukiPmrSTdarwsDn4557vtq+SzgsKWmFNSAfIcmeFgRoVzJlCleMasRB2QGHPqu1II+Le7KGX5QE827vL9L9xdt85/hLQx7v0XFkeZwHbNV1ecdR4oNYUSolK+bxiI8Jf3M4E3uKIMWvW55LKuII4z3JES5vqHeyUvYOFOJeSd+VqbdjQ5jDm7uIYP8NXt7o6j26X/cJdNOcY38gbGZQgu2ij9IVnqLeRtQq0CrcC5FkxDfxKfhosLKqT1wfb5ORWmt7goTfuO75ZSbL53E7E2Q6kIoi6RSdkfUHcYNxhQehlDnbI1wqc6fnC/Y40tMn2olbF0icP9HvB+UGSCqCp7TQb2SnaheHXZcoM545V/zpMajQp9dBsjNtstL4k42bNCKCygw5OepXvQtK01zwm3frnb7U5UCinwRmpxGixaxYsuzaNPum9MCkIS+R9YwboJuUgkwE29tUph3jmUf+h+J0Hr/3+V96zQTZpYjG4NzC0OXeoeRPsWHVlQEgUG5txYYWSdyfgXyhGAyvcdUt15ZIsKNFhreWmINJ8oaK3NwdvXrmEGZXVVQMm8SJEPDJDgKw+UfJdvpoI7DhcnKvrVOeRoJHrM9MgBO4OPQYvUaitf3/vudI5m/3GhoqBlfT9eI//Y3f/4zhzAHGYBGduvMqfOmkjG//WY8nuPkaqMC8h25l/2DZqBJS6LlT66xLWRL7tMYcW9OWe6HqFcQxLtDx22Ug+2bNn3uD4tbJPcS+Ju9Acmt6k61iHtZk9ZA0CWmVsU5zasHDcnMu2SKniqm70Txs/4pgZFJkaQCOa8iLddSjrvhzX+P8bc3SDTaesbVW
 haQ0h1jJ
 UtwtQ9cXCAAHasRagI0SVdSwZGsEXy34WyxcIBsTwSXASnD0qwl15h2Rsz0vnhq51s0AzU6qdvtGV+iozWPUpmKtQTTNGLSiuGtuXacyZfKEJJ/daMHH+qcGjAPmNzmnH0H05U+2viaJx1KBR/WpMC65qd9iighsB+4gW0FlMl6PGqzmrzPwhOUt93eNck88TSdYHp02/fMwWKRS/ewrO6YeYdNWgAIRCxLZpYUJtJGWSSW+9UgINkGlcpzK7+gt5l4T4A3pddg0v0JoqLCP+O/dO0IJbkPdIbR61IZLOuc2anNVfq84kSnPOE1rMkMG0gumO1PQep+OQfPI/V7gFmq5TEPkxNcx7LE7CMTVEaUZvZhGZebXu+a40EExFW7PVF7Pv0LkLaaiQ1zasQ1bN524JUfCZbRqHZm8I
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 09:44, Vlastimil Babka (SUSE) wrote:
> On 6/30/26 03:35, Zi Yan wrote:
>> When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
>> range does not match the requested one, the code errors out with EINVAL
>> without freeing the allocated PFNs and causes free page leaks. Fix it by
>> calling release_free_list() in the error path.
>>
>> The issue is reported by Sashiko[1].
> 
> So this?
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> 
>> Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
>> Link: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com [1]
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> Cc: stable@vger.kernel.org
> 
> Hm well, it's a path that warns, can only happen due to a development error?
> Not sure we care about stable then. Anyway.
> 

If someone would run into the WARN we would already be in Fixes: territory.

it's a path that should never be executed. If it does, the real issue must be fixed.

So (a) I don't think this is stable material (b) I am skeptical that this is
even a Fixes and (c) I am wondering whether we should touch this *at all*.

:)

-- 
Cheers,

David

