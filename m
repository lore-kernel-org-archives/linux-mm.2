Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0746ED7BB1
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 10:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613CB6B0092; Tue, 14 Apr 2026 06:40:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB066B0093; Tue, 14 Apr 2026 06:40:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 500BB6B0095; Tue, 14 Apr 2026 06:40:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 44CA66B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 06:40:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 13A6B1404F5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:40:35 +0000 (UTC)
X-FDA: 84656817630.07.32A6AFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5B21140011
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:40:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seAK4Xwk;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776163233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSVNJt6KFdXNdXdsxo8eTCRixnf4cEay2dS2e1CzLB4=;
	b=nRCyWQbvUx8H96j836JZ6tfNAMtUvEB3MO9Kdfl8pf1of9Msq8kOeEJuJXpSh8CBzOtlxN
	XtdiCZoumEfizLxI0GHfUMjStfj+BjfKsSeOVWGVttqhgxueLL4m2jJN/0Qw5RD4PQOAXs
	OLS1Vw2gd1gdpoMm0xpeI5cgexf83O8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=seAK4Xwk;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776163233; a=rsa-sha256;
	cv=none;
	b=bUbwWxG8OFVc5LCoPgk9+g7mvpGdOh+MI03yleJMJWpQ24U93cs8Yy/EN8adK9i0CU7vsS
	VfRHlJs31S3ZVJKHa54DPBzrT2nkjKaSU5+bnPI1DTctPiWL3K08biT7T9Rw67L+mC5xor
	7iIeAuEnmLKrEq2s0AB8xsVYlS3vNJY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC25A6012B;
	Tue, 14 Apr 2026 10:40:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67BE6C2BCB5;
	Tue, 14 Apr 2026 10:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776163232;
	bh=1A3OVVqVgKxNYzk0Y9ubnCiqCKbONv2qMUdyjMlJpdA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=seAK4XwkqGwhd9CT0GkHtPXQqqJqDPbYjpYhuHG6y8x1byekuJHpgPRi7hVq1KoYy
	 eQC6b9qeUXUTFLJijkyTocXAZKKN7K+U9JU8FI3iPntBUcPI84Sfx+L1E6SbGdiyq/
	 OuVtFPoIfkiop7bgZ+dxcjoh35KCAr/3PkQ6YyS0TdzVV3PPcek+POQL6WMXopaYAc
	 TLtdxHz6RgBtKB0zaE0D1qJCc3pLLqy9wnm+ovh/SMk22lbEbtpOUgTjXU764V6CUs
	 HMigvu6M4AUceyIXVArzdYI/O3sGEqa49fnJzgt/e+yZKoBxZffIMT2YNlF+aeFwEl
	 KCY5DJQhLEUow==
Message-ID: <77d4d591-5e70-4ba9-bd0f-9674c2a74d6d@kernel.org>
Date: Tue, 14 Apr 2026 12:40:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 v2 04/12] mm: remove READ_ONLY_THP_FOR_FS Kconfig
 option
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-5-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260413192030.3275825-5-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B21140011
X-Stat-Signature: a3x77rtbh6tnbutuyohdu9ik9sjrk4ni
X-Rspamd-Server: rspam06
X-HE-Tag: 1776163233-332596
X-HE-Meta: U2FsdGVkX188xAQbed74Yvy5WeWk5oVjTCgGDjxmZHNbmIDpZrRh7WSY1q0VYGkOa2kOVXu4KVudaQp4HDEavUNSclx7Z1tKTnGnQa7fmppmyQDzS3VPy11glPF0LWHmeh2sR6n3tZuhE+vkEdwK5uw48wPREXOGF7tjCdws4f+rG8BAsJjrf879IBTUgy6ZzjmF00s9STNKvh6exzJZv7pzIRpgl2e920RmShzWU7Q6PPdJyFu+Xh9ILMHMftsRuV8FTSNLn+gmDToUpmpwJqmqyiKMQ9joucXKE11is2Q9MlKjPhRGzarEhpbnZtp4CWNlq/Km/jMn6cVVvt+zIAXPEGs6immphSFAxMzBjT+/F0flKCheeQh31ENs1QhYSpeatGYKAyvLq1GzMdRmykKqQqTFJ/G2ri320NuCvFMIQ/Oc+5B/JpENIfdlQO7Mr7WCj1HVEyxq0eZBrcmW15uTlw0Lc5nCxGK7Cem72zzSlFc5pdrLgV9119k+hrQmE9ZCqhXZdprZmp7+v7adoML0zCztNfGa957AjVea3ivwlB+3ClvYb9NPgX0xGRj5ww1tFtu6uZmVm9OsfhfeUHqYNof6ShazyYXqsRZBDiet998htYNunNEKhpT7sxQ/XP/chv9omgWDn5/ZT+gbqGeqaP7zrZ2llUGOexks12sWLf3gObEIKDo/2mZDcjZvY7pc5x+YkHPv4P8fjgQsXF73i5b3V1ksZ+YQQYVXepezSuEA4vflk93a7vzpfyF4j2JtRDslEbgHG0iPtJd14kSfegYvDaUe3DGSmjcT4v6WRVVjRCwnocFSpcuVsq0+X76VO7uFZ2rsvDx4+RedX+KI4zaMPXjqn4E4+Aa0lrBYKh1NgtaQjvjwu3+mYrqtuB2y1NWwSxfsSTmAFhOxSQ2f7WGwgJDbaIFSQVSZnms6XtKJIQ0Lm/F+OVzPOJAKZlpWu5KPCDmU59IMH6o
 P4iBOqU3
 DWnKfOzmDKY26cWmESAMokZkffUZWYv91xStGJVImMyKhWBlj0UdrAkepu1VTA8saYIENz6rZ9eySLaVwlyfW+33Q8dxY9AFb2fWU0J3SYJSPDnW4QPaysSrj9wZLR2KHllQvw8zCY+vgjoINTvAhIneKZxctRTodqjY6w78iG1XImDc0L2N9Y/fH5hny4UCwjcTSAccg3ESDyRfDvA4yvxxN+K0WwPRgqNwaJuC06XKrF5PBRK9xO35zpYYz8uIcwVHMJ/toeMAkW8LRV+Pr49I+dfQGXJ23I7PYV2yEAYpmo1Mb+scf0MdjYRSVk9IlGuSA8fB695ImU5UNKkK09YcPvoDuJIWWtMn6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 21:20, Zi Yan wrote:
> After removing READ_ONLY_THP_FOR_FS check in file_thp_enabled(),
> khugepaged and MADV_COLLAPSE can run on FSes with PMD THP pagecache
> support even without READ_ONLY_THP_FOR_FS enabled. Remove the Kconfig first
> so that no one can use READ_ONLY_THP_FOR_FS as upcoming commits remove
> mapping->nr_thps, which its safe guard mechanism relies on.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

