Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5624FC88E75
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:59:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634BB6B00A1; Mon, 14 Sep 2026 09:59:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E3E56B00A2; Mon, 14 Sep 2026 09:59:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACE26B00A3; Mon, 14 Sep 2026 09:59:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD3E6B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:59:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C124E16015E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:59:53 +0000 (UTC)
X-FDA: 85212526266.28.02FE57A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2109CC0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:59:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iINFG8IO;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789394392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+PYFX9H0MkQu60EdSBrCrp/9ixn5ThWGWT8A6TrJ9xo=;
	b=jfB+RKD6yoqbJPjkEO2BW25Qgz+sqGw6QHXVDPjjfHQf2LmGpkzJpXXvgSAvTKuTLTaiCK
	NQ+0XP6AD6/RLiZmynNAorhHEZ1XIpLwpaSSPeExdK5+kHvB9toqp8XpH9DM1zwA6e0bcf
	JArkE6nLIPceIcaWG3+GnzFjd/vDUcs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iINFG8IO;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789394392;
	b=vwLaqUp0XNQs5Wblz450Eqi1k04C4xZNMLz9BAfmans/qFojOEChgtzH+YhFSEzGtd7MB7
	lTs88IsdhnrBVWMc2q86bML5UGmVRVshuxiUNG9KvxCvJR0lC/0Ody+inhVbE8OFA25VTy
	hOH+WJ1BsJcOL5TzqsYKNIKsssogaLE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9EDC060142;
	Mon, 14 Sep 2026 13:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6BF1F000FF;
	Mon, 14 Sep 2026 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789394391;
	bh=+PYFX9H0MkQu60EdSBrCrp/9ixn5ThWGWT8A6TrJ9xo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=iINFG8IO7eWQH45Ih7otbKXDMJjCXcVkCZvZV6h4eBWHQHgx01x1kZ+JMQpUnfiNh
	 4D0aEp97w9opqviUKNwUy1EM2vxCihp7GCPu3/PL+7UYOYqmeu0d+869TS/ZbTsGh4
	 MZ0Z7xGt88jPPzPbFhanR//dWwDsbm6W3YYOqUXjyrTlNg5pUBS1nPIAuggWpss7jl
	 0oeanG2cEJuUlwnrwSsKPrIyElxLDLw9x1L00eDBYqcxsNmANUFibFj1+w5WdGtdOS
	 PfKXiAjk0QVVHX+yPUZr1MN8crf4UgwUSZOiZ+f7QsAC9XKapGC3F95qBHFVQytpm8
	 25UUd1jMG0pFg==
Message-ID: <5bc1eb42-2901-48ad-89a0-0cc4e8859bad@kernel.org>
Date: Mon, 14 Sep 2026 15:59:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] kselftest: mm: rename read_pmd_pagesize() to
 pmd_psize()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260914-fix_hpage_macro-v3-0-c9a305a01d39@arm.com>
 <20260914-fix_hpage_macro-v3-1-c9a305a01d39@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260914-fix_hpage_macro-v3-1-c9a305a01d39@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: m7nrc6smjeq1jep67fpo4nke5rbbma18
X-Rspamd-Queue-Id: 2109CC0006
X-Rspamd-Server: rspam07
X-HE-Tag: 1789394392-984518
X-HE-Meta: U2FsdGVkX18mfdOvy3t04hQNGf9osPeYxZmtE/QLORb7ldWpPQChDKsF6zLI1mpaVsXehdTcN1FFWPf74pPXLg507+zqBCFTv8cDtxdJrXJnskOn8FqcDp909/DKoN6jFTIuWLR3yTlIuSoxDoD1WMni7yOUtMhGSeuAE//ql5WNuG0o/x0hv1t2v1dbc1gjnmtvzLFuDve1Ca1AviGmxKD2stcE0y95J1xjKRbymsBHY9YKO1EXFFef/xS87yVjE02eW68Lj0fQ35M6QTQ0CfstRv6QfqQBJ5aIah44eQGVv6zXFbmxQaGOdC5MiVfQOH6QaZ2hyHP7TVWC23Otcldg8wC9MfJz9U0iq8plUp1fY4LvlxW8rXGj22Jokz1nRf5sbrkQ6Pth++ggF1LNYhev53r0nfkLmTvXTI6pXntPMPzTfElO9j1HJcNnf9le5DKx4Kl2ghNqerW2CIn8YKvBqcqtVnKX3MrB9ekoAKdFriXw92oAaSZvGcO4inUujISRnpLngT6GqwpfH7SAw5cy310OAkqs11ZU6VOawAKK+IYep22J2o9B1SfeQOgh397wigjpPMryeB6CrQD9bRlXUJYPyFRKuRLJKXpnJ6Qr1m7vchBv2+3eiqzF+hLp74pSxwBmVY+eKTOi8NI2zZFE4Fbb7vk7A8i/1YWTCFt3vdcUI+Bn+ucThwzS/aj7G8NopWcIAyteG5jIXw4Ci8l2wdV6gxUUHzJ3rnEWd67v410E9Orj2k1ZWRft9uW1hLBNhfpWb7hPpDM6D1HYCK4kgEgzwMUqaCS45jKsHL74j68Bg1VzIzI3DQiK8J++L1rvPNzOOPz2/VJR40EHKqJ6PaNp15vk7NGAq3x0qVo8iuxCJWDEOx7Yzn9AlOaEBgmdnM1lnnqoUYr6Ua4lFpmk1YLyvzp0dPyhqK4u6H0Byyic/Ga+x5JVW9bXr4DrPlij1w1W2fdzbG6HEAF
 1AvRgExu
 AGdJEH27qtIgjmzf66XisFJNuuXI5uMK0lhG6MUpHuS9enr+d4CW0z61mTfarOgTqlVQspSml6dlrL53wb+bY3S5NQxzv+a0GMfJE/y3uKAA5VUOQKfc+wA6K4/Qhl9qxecaNQs2UVR4Qf3jIveyNv/Jx1NSTavZPgATW6bLhajFZu/C97qde6gKdAMrsRKUrWbvKXik9AJ0tpTjhlFfz7oQDBzxSc6zNeWNyqDdIxNyJFPpwGhIS5slOJN6dC5xe5t4MyX0JEaZ7cVhtq7TGWJfO7rgjGtQZAORbR+Hj/2vcF1YRC/QTwBgrp1yPz2wQpR5klcjV6+0MaFF79nA+Vfl3dpRHWVvwA2Emf2jv9iYUm2855Tk3qT1k9S4PCF31EmyEfjDWeZroJq8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/14/26 09:30, Yeoreum Yun wrote:
> For consistency with psize(), rename read_pmd_pagesize() to
> pmd_psize(). There is no functional change.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

