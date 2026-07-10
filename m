Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2745CC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:51:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F032F6B0093; Fri, 10 Jul 2026 08:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2E46B0095; Fri, 10 Jul 2026 08:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA3426B0098; Fri, 10 Jul 2026 08:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B59496B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:51:55 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A6851695A8
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:51:55 +0000 (UTC)
X-FDA: 84972854190.14.2494573
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 75D2A1C0002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:51:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHlv+QvM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaMzaexiFIv5g4v2t+25ouPoSogbN+EZFjvcofhoUWs=;
	b=p5+vHV8lwhidMyFHvEbAYha7WW2TgVJmyGl+LMjYwOwjTHK8hFi7czyeutR1nLAc+pSo5E
	giXb1fkyOMBIcbV8X7T/sReaInl6Vlkxey4XZS/oENTDw5NS6WotpYQYgjLjehyc9s2BVU
	ypcCx7pUxLIUDVUq5jLKSTVmo35YjIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HHlv+QvM;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687913;
	b=ygP8EkE8YHs+BXV0FrXeudF7ByKlG00hacNBUDzbnlsGwioHk/Jtt+8Ew01GwPvYufXdTk
	l56Df6Vqvzg+hzw1GmWQxInfPleyKO4fXmEMPrPhJQ2brImK6JE3SNLJ9QqtUmjGV46Qi1
	v4mU3/AiSq+1gKLoFVWPCPGis5Aonio=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5E6A40F51;
	Fri, 10 Jul 2026 12:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6488D1F000E9;
	Fri, 10 Jul 2026 12:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783687912;
	bh=oaMzaexiFIv5g4v2t+25ouPoSogbN+EZFjvcofhoUWs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HHlv+QvMWh9O5/PuGdrPqfosBq3s0VwP+PfR5ZoZBFdnaN0wjcq5uWeSZ/T7YRf8+
	 N6+PNVsUNC9lPu3eChx3cj6Q1GhMaUo+AZWy+ZuemeXgwNeIDCdd0RqK12Zdcs61oq
	 luh/ZInTXGaeGYv0BNyHK+hWEAIl84oPZmgXqdxXHsT4k5gFJ6ZszPQfW+jAiFNXwL
	 yCR1ncxotTKyP8TAsfbYHofhZqO6HSnYh4TZBOfx1w6JG6mRiFI+vjxj4UkjmlL8YT
	 2pOCpAkuTSOFJE1IATAxf6jl+//WTgH8vva4kkaaw/xMVP1v/H+NEFVbzboQpZtGzx
	 Iu4tV74s0+RIA==
Message-ID: <73007de1-6372-4cf9-8373-323e48eec0fe@kernel.org>
Date: Fri, 10 Jul 2026 14:51:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/5] mm/page_alloc: make sure tail_page->private is
 zero at page free time
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260709-keep-subpage-private-zero-at-free-v3-0-7e4fe155f5b9@nvidia.com>
 <20260709-keep-subpage-private-zero-at-free-v3-4-7e4fe155f5b9@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709-keep-subpage-private-zero-at-free-v3-4-7e4fe155f5b9@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bdy3otcbn7nakzskbgog3jjhwdpaoj8h
X-Rspamd-Queue-Id: 75D2A1C0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783687913-198592
X-HE-Meta: U2FsdGVkX18M+0wXhDM/rmzYdzhvDYTHtjk9dwJ7R8vh1OgigzaDpZFHASOhrDTYKkCgGkNEqotfG3YHtHPx4UuJghYgx0Cwcxgz21v91O1wYC5vfoSPkOjlRxznECz9o6khpsE1i/0RbuVbs4TV3RqyGg6VNr4jw005IFr8BaYAOnlGWQCt/FU5pRsLcho+HDVq6rGncgtrLIiD6ouisFAwHzzAXlTYJ7+uHWqj7N2DO6u2dRJD9+May0xBN71F9GiULKtkQOH4Vt65VutMe10Yre0S72mg4LW807nfV3aAX4D8WE+sSw/CIJWc4G9d1rmj03uzZiGfoX5lyMYFYiB/5lJZbG+XqlvoDZ88QqSBoOmgNvjuRVQPUWv6SvxIe1rVJzxI0rCWlKfNKlZbWUqGbmWpzMjlVPfAYkIa6pV9wtFFlHHQTF2EgypDcyd9F7LvoNrpiAWtv6ZqDB16KN8kmXsCmn7tVXtfbrRD6D7RD/9DQOFrolS/s+B2rS1KRmmimC7i3TPwITIrgw+P0aC/LKPs2CvOReC3nhE1/QYGv9hgQ7uWkecleU0fbXIMgda6QIO/Nz8hpWsUs5rZHydRTZvZZqwPA8zyOjd3gavv3qqt7rbUDenB4z70+yeSbfDgk68AyzC/mASPynvGHGS5tPlRoY8FkoGrTkyNMEUxKhM78XLglJ5gRDVcXMRQWgnlkT+XQ3Bs8zKIKaBrmnPAU6DdomanelK3TPstjJLfbtqiRU7fNd045EXlGU8VOs9/d8nLqiuLYjhL/hQQMuHmO+xU8FIyBK+Vci5WMAHWQtR3rhKMdvmyMxCjpLd3RVU+JUPk6u2SEg83o5U1gNZKMYHaH6/+Fsv/d55+YrbQwbr63il5+KcT5qwFEMz1LjdlSnydb8GpyJ5RRODEpvMSJH7o5KZBtctsgqa0LoIP13qbHzXQyzY8rYLEIhuD6iIpmEgEnkEi19SX/4g
 5foJRl10
 o38oAtPe30xXKdkd4D34DfNZ280VXp0eNto7XfTt7wG9kcOtHSTgR7Pjfj+U1UpIYh9T5uI2OIv1m+4b/Tm92iMSHz89U6LXk3CkdmLDD1hPXReuopeH/ko6wxf7NUgdnMm2UfTc+0W5IOlgnLjpgKFpEj974zNaGmFnXDYkLGXBbYVL5mefoBlmeb6mSLPJ2CmWsTqwxWJYBuuVMhYH0vglU3jNFqCXAuR/jS7xCI2XQ0jV6/eymrKcTtVEs83gwRAERqrNkqw66EFUSJdc/seU6sEjpOO4gRWuzsonSaFOSnFjZyN6tlZZ0bb74Z3zTcQgqg6zh/ITHHGFDrS0SfqQvpac/KUIvdbBp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 20:06, Zi Yan wrote:
> Any code using tail_page->private of a folio, a compound page or a
> high-order page is supposed to reset it after use, otherwise ->private data
> can leak to new page user and cause unexpected issues. Add a bad_page()
> check at page free path for it.
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

