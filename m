Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E06CCF9EB
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 02:25:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADB8A8E01B5; Wed, 29 Oct 2025 22:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8B9B8E01B2; Wed, 29 Oct 2025 22:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97A5B8E01B5; Wed, 29 Oct 2025 22:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81D1B8E01B2
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:25:31 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 16F7D5BBDF
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:25:31 +0000 (UTC)
X-FDA: 84053189262.03.74D420C
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E2C74000F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 02:25:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDT5Wp6y;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761791129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3UyupsXh7QI3IpXLiJnSS9fzReGG9d97Eh4CpeWxH5k=;
	b=2gJ6Y921V8mCM7Dl6G2JN5gn0MWQJ6SNTVc1MBtVo19iwMb8JCmUy5lkGRHRnF4++Vbyb5
	3sAVi39cA0urQ08yBnXjMd9DQp+S0AzvDpLhxzblH62BVGXMadqeVNC0dhGbYakx2XJPA/
	O+LAQVdUaLZRj+e7wQDvjMh0Jo2+doU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WDT5Wp6y;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761791129; a=rsa-sha256;
	cv=none;
	b=BflyH4ws/7uB6lugq6mDlfxTe9Odo63IgS8L9fPyqoxDbjCiS4VgTaSZS4HhR4X+TPokFX
	P3qp+QswEY7NIPZS0ZFUqM3pkzP8hZwHTwFNln9F6puwASYJd+Lg97hKNM2tSM1uIcdodP
	CnmBtNBODqhEHQB/EWNVNRnQjLl2co0=
Message-ID: <4ff09b34-fc18-4dcd-91e7-2e199d88e133@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761791126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3UyupsXh7QI3IpXLiJnSS9fzReGG9d97Eh4CpeWxH5k=;
	b=WDT5Wp6y6jrOwkHrqHxb3NYddT6JMZE1rFl8MwLNhXWLePJcpelDdcmraCl1b6kADLrvP/
	OmlCpTqqpTCiBugvw/8TnfH+ES4arI53JBx61JoEc7krBaxUolqIQxv49AWoGarxL2yDu8
	qmci9hK83UaaotYBL78770tMoTbBpGg=
Date: Thu, 30 Oct 2025 10:25:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 1/3] mm/huge_memory: add split_huge_page_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: kernel@pankajraghav.com, akpm@linux-foundation.org, mcgrof@kernel.org,
 nao.horiguchi@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 jane.chu@oracle.com, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, "Matthew Wilcox (Oracle)"
 <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>,
 Yang Shi <shy828301@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linmiaohe@huawei.com, linux-mm@kvack.org,
 david@redhat.com
References: <20251030014020.475659-1-ziy@nvidia.com>
 <20251030014020.475659-2-ziy@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251030014020.475659-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E2C74000F
X-Stat-Signature: fwjj7sc1snht983bjdjjx377who4zbge
X-Rspam-User: 
X-HE-Tag: 1761791129-820982
X-HE-Meta: U2FsdGVkX19WZf3JlHUnN+0+ypcnxUXQsVnJwbRYhZFYWeb4Y898N0JlOShXX+TM8rsoO8BJMHGqDtNHuwuff5BCwzOE8A44qk+LzpC3AkG07baQcMJZn5UZqFPgR/A1ZIDC6YjXCVjwaOMUwkahX4As3ZD18oLD88cdIiJKHZfisBxivg1OY29bsnK9g1ipR2mgDF2WHCJlqEZ4dycfS1MIqeghBetUjjjNfksQ6oWM6nBy0NVG4iXO5wlDVlmIfcrkVxNN3y5nM1nNUYOGQIrV+XDRwGEbfATSqwiX9Czm/QdgVyPs7p8Qb3wiXun5ao8Cz6XD3LDUNOnDWGuwkdXBjZv+NWuBwCTXseE4m7uSv8BU4a5jbGnMdw3qgqIbgww70B5ntuJbhcFVjCrbgG1Gg6nTNbKOOWR/wLnV8D7NLlgqTtOXzJJae6Gq7VdWNa5v4njem/0vIl7VmBGKaw8b/q4bH1OS2/h+9itlEP2Qso+yocotSd4H7vpDRPfxZiT714RZ2esUtq/vvQLqWardtpnNfz1CyR920WUxJcx6X9Cq8SJWBkOFXM4Cu/JZ8j9gd102W6FUS5vO2dUu1aMj/lSpBj4jfvGm4WGB/PSk1yuWTCSV7xmBzhpm5AAtpMo9YckZ8cYbh/36zKxAUCfGCgvzmTW+Wh9RmdVTcY4aoJfyxLhGbKyyrWch78i98VSHMJxmAdJzl+VbcRRZRegWl5r8Bpoy/zQKSnFI/DKIsxUfG8CWJBU1q4T9hz7ew+0WO/ojBTXOnpUg/sm+H9ktqWKAGpe7PBzi884l3AUbUXJ09EXuvpRYUGGcPUw3V0zEVmOmAZOqIvE1Fj4a2rZCkCb1ZMnZjTZ6U59EamhFQ+RMrSfauVWBwpa3uYdlS84tcKclZAWC9EDnM5j4bi47d/seCFGtKDNjucd7YKI56mJuJ1a9zJRQKIfJ3A+9OGwS/+EiaJck+6EKyuI
 0UdoP4UL
 U8kwuE19S02TGHY0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/30 09:40, Zi Yan wrote:
> When caller does not supply a list to split_huge_page_to_list_to_order(),
> use split_huge_page_to_order() instead.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

