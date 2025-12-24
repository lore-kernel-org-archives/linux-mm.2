Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEF9AE74915
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE7266B0005; Wed, 24 Dec 2025 07:22:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9E4E6B0088; Wed, 24 Dec 2025 07:22:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB416B008A; Wed, 24 Dec 2025 07:22:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCEC66B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:22:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5EBEE12C59
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:22:16 +0000 (UTC)
X-FDA: 84254277072.06.2002739
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id A079E14000E
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:22:12 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdYSltIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766578934; a=rsa-sha256;
	cv=none;
	b=WNM7lywRnJONf3bLqlgARqyuLvuiRXA1yxwcWhb2D9vR3RvoTSZp/ohRCV2zDbwodTs9GO
	4DGt143VdKHC7gp8GuKpudsX8+OTD/3jQUu5QaYZcR0Lh30IVEc/Dffx30Lui44xPETtj6
	P4lABuFAUNmVCyXRqvG3nuk+hhaznhQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fdYSltIl;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766578934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HimEiFvEpjNM/KP9ZP7eDvgtRaba89QYB7YmI/yJS4=;
	b=7lwuMjfOZ1WJcu3y6oHMlhLxfra0Kn7+Sx9zvM2kPVgZwijWeNILxRCCbpBWt/FWZziwq5
	5WDb0KftVqAMjww4LatJcAQark8MAzeaevwm9/yHnZ+iFO3DNPNes7tmovNKnJYKEhIFd1
	BDkH/h0Wi9X7WG749EXzaXa6CI0x5is=
Message-ID: <913d3349-9ae8-4fbf-9de0-b627cad12c24@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766578928;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4HimEiFvEpjNM/KP9ZP7eDvgtRaba89QYB7YmI/yJS4=;
	b=fdYSltIl8I9+SQyNxStBxRO/Wra07Y2shBxkql1hJnCZQRpVSpzcGhxEXlcIDhWxJjhKjM
	a/mv/0Jq3kvFBpD9Hn6pEc6QJgTAP0cgEM9FOV2Gg7AJx5k+Hd3onkqxhOA6ZHnQNLGcA/
	8uwlyQlVLWlAutiMW4MbQUlqCI8Vo3M=
Date: Wed, 24 Dec 2025 20:21:55 +0800
MIME-Version: 1.0
Subject: Re: [PATCH V2 3/5] mm/khugepaged: change collapse_pte_mapped_thp() to
 return void
Content-Language: en-US
To: Shivank Garg <shivankg@amd.com>
Cc: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-10-shivankg@amd.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251224111351.41042-10-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A079E14000E
X-Rspamd-Server: rspam03
X-Stat-Signature: jaqd6mawxknfona9pcic8n779ygkfuwj
X-Rspam-User: 
X-HE-Tag: 1766578932-21984
X-HE-Meta: U2FsdGVkX1+fcXQ8yQm/1o3tW2L+6zYPEMhkJMmt8MPgNU5Gm608c5wdY5Rnj5NJHyo2RStB9bMvzXXgqDjCzpWpbudL/GQLVLZbhcu6n35hb61CJShvPgijVGv9Umewlz9GxE9vniCA6zRNtZCFh8tPniItfa/y4QY80RAs02RKh5lmzxt4A1gjLlj+9uVSPNaqOkHteFFovK6i1SiWQJlKIcr30TUTFGnXUtsO39BVVwDVELKX+4oHrUYcqzw/dYDBiAZC8blKKcCctI+SJgK/br87qjNdBs9nJbT15LZL1m58lqGCXhRl4jhjiT/do4TryfWvOpvthKzawlQ8Mg2A025MVUfT7RANTVnX+4qji0DU7EazcC+gQeX6ciYCJxNdR4vmhnQruEhoMqawDDGj68ijPhBGLRS5/qe9reR4CkeU/ddc4BV2LNg+w3v9r2/vjVf1NL6nGsKbDwGvCtkxOcKIxOK/pQv/q1ioGwduPo5NQmx8nRqS8k/Iu6NC0HfBUerdsfch8tXcFUchHg9Jr3YBW1fq0gJYoC6arAm5/afGNAAVxDeAL+lVU7uZ5qpnqYyVnIskfO8OboXoi1LIL5MqvAlPC7eKVKm47KWeeaHH9e2Xh6u2tF3FyctzjN8KnB+u7UU2aU/lBn57NE5lU1CSdX4KIyNKq0lM8WH6tI8m6aN5SLoIly36MHKHcCIY7zklMayeMMcQfaegeF9V80lwM/xta+b910KaVLEjAT2wfxbKrcNy8sp3l22aCFhbYqF95XUvXVgecFhuHgKxxof6lsEJJOBoBXGXQUpGl7ifCfKCjtG3kTJO8eoDJ8fz341MFLaiS7DkiEHDd/5ruINd8a+SX+yDp9YCyfxVX7VpCBqDPYx3NZX8LoE3OVaKN7LmBCiCgSLthFkCbzxdw3rzXxk4Bua40EwDBtyZdVbU9+RetgeLfT7WzId8/62UeRjCnXvYdwepop6
 slYN4iqN
 RQ6b4EUUIW5BFS18gsh+2zGOXt65tOHjkJfyXth6leSSktf9upWgsle67ARTtCeqPJqOcB//XYJGy0yGmdBL+63GpVmeiFZEa7Hqnwv8rapbjVG4EmMHfDNMWeqYLthKkiIkuIWzCypTh7xjGWxvPnd6KWOoJ2JdDtACckgKkgyYHGQQqlSBMMjdmxNxd5mxOe3Ecwx11iB2rdi94XUor7+r21vVUsiZ1+Fsyusgme6XFnXg2rNlaokkwcbHrEVTc5MXzcJwCXZIb8WBHOKnh4OI6CpYOSdlTtIoVCRTaN6RaLaAbC3rhKdKJzvIyHkREBXVfOavWDhf+x0gazRSUk4Ocag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/24 19:13, Shivank Garg wrote:
> The only external caller of collapse_pte_mapped_thp() is uprobe, which
> ignores the return value. Change the external API to return void to
> simplify the interface.
> 
> Introduce try_collapse_pte_mapped_thp() for internal use that preserves
> the return value. This prepares for future patch that will convert
> the return type to use enum scan_result.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---

Looks good overall, thanks!

Acked-by: Lance Yang <lance.yang@linux.dev>

