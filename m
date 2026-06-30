Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0FD5C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B442F6B00AB; Tue, 30 Jun 2026 10:47:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1C3A6B00B1; Tue, 30 Jun 2026 10:47:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BA56B00B2; Tue, 30 Jun 2026 10:47:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 78C5F6B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:47:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E457BA0525
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:47:38 +0000 (UTC)
X-FDA: 84936857796.13.78A8B65
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0DE8F120010
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:47:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FmJRX50X;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782830857;
	b=etHVZRl56O6c8Y2Xb2GV430HjyUQSXLlVfqKwgK8O6jnKfPdIbg8IiPZu2xB9SuXDA/a7o
	0MzJozY2F/yNbLsVTKnW7AbzxyLTpv9bc2VulW1GL6gl8UsBipq66H6iP6YUporevb7Up1
	kzZeVIyUf1x278LG6VGBStIFUdBpS3A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782830857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ec4y5CC9osX1Fg3YZN+Ow/rvBlJD1nIcT1j8LM/GIAs=;
	b=OaOS+l4cdGyqDErC68nuwgKSXYeDxJ4hYWS8jIVeU8WTmpOUE5CS5t0UY9D06w8nI32DtU
	OGD02qAK859mqOiGNhIZvbLeSmwEszyQjc7moLcexmaC/E/IELxVaydLmrplpUd5NjQFeD
	j2Tz7h30WXCbuV/vAxjWrdVsECgbjuo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FmJRX50X;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782830854;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ec4y5CC9osX1Fg3YZN+Ow/rvBlJD1nIcT1j8LM/GIAs=;
	b=FmJRX50XWFqK5QpU/Lvd2417iY8koi8gFcrrlCJZ0ywgG9BIYPSxM1kBham4gcZRtHT+3C
	HssL7y8kdeHl0btKk6Tdd1envqSoEJNhkTWliRUtxC/hZY0yn+CRBrH+UO+Tjmy9mlxfPr
	bBh65Em9nvNfgtDhFGZPfLqWE4cVp4w=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: vbabka@kernel.org,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/page_alloc: free allocated PFNs if the range does not match
Date: Tue, 30 Jun 2026 22:47:14 +0800
Message-Id: <20260630144714.66550-1-lance.yang@linux.dev>
In-Reply-To: <d44ae8a5-ec70-456b-92a0-ce7ccabf6917@kernel.org>
References: <d44ae8a5-ec70-456b-92a0-ce7ccabf6917@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 5dkes8ucpn9pw4kho4ttsz58cr5n4h78
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0DE8F120010
X-HE-Tag: 1782830856-998125
X-HE-Meta: U2FsdGVkX18Yy2RVoaBoW35gIUzKzmJ/7JsZqoLJPv5MjpbWpx7C14surPIkuG7xLygAQ9EpasSUzFVSXsU2Lpm6W3B7oHrZWRvuP/ODugGM52pcGjKT0re3xEvz4a9CS6yy2m7vnj0du+HgSnKTWHbTIahRJnzH16YB1YxFunr2jXzwggCowPZE92g08wR6kGRrzQznYlig3ZLS5G4Q41OMOE9d1kiiSsNttZWTg9cOttqZ6TF1og1bJeo9YrV4NQyCMpdF/lohBvBN7MH0vANraSlUC2TDGkwlgICGjDfVmlDU2moP+JzkdqQhyDXinWc47bANGzDDN0KGWdhNsQxPF/FijbkJgcUnifmTJ0TpcDUI4NCM68oK7Z+htOOEpvS7GQ1x5QXzWwCHmioLTtVNx6ozSZJAQNPz0AlE9BZuPI36HDecGpgEvk2U8LdiPWdzPSJvopFwsWy8qc2ESXXHtHGfyaktUB4bWz+m/liHS7Q1xgKBh4HDg9jPiuB7Hq4SvqKNbIGkXasu6Huzr5ZrtrxTlhSCQ5svi6848dVCLq9fHHdt2K+F6cF8C1jMfdrrsN8qKHdpwMmRBu/FexlTaIG1xnSu1UBt+GBIbCVsHbu7OyzBfGnIxsDBcgDBNAPeNY0zr9SfKCpkguj0vFdpJnizVDeTCDNydRtIV2ThgvdMGnAM4sBq1fL2fwNBOk5fmWDl4vt9//dwc1k5Hyk/ixueIuWdWuZOK8w2l3jKSSwxJ06c59ngaCsUsSPotOmtc5D9EE5TktTZ6NQf3TisepWEp/2zdfMZ7Hz/r26jCgapcOnxw19fq2HQ39Dy+SYnFNYtBXdBxJKUElhgYuF4tM/bhWlRjNlxEoyCyfGfr6KK//jGxtCreExvp3Z5FGUZSV8+W3JQ5ma/LrSJJQeqoRKk82jyKGqmrHhso4otmcf4QUz92ThOxhqb0mqqnwxbycoYQxsrJKSd/QN
 SrHPSLsd
 6d9E/nF10AVlmAkwRbz3zzRdk/FzoyFaNbpn5Z/u4ibc+e7+VrQLjMxr7cxvwcQWJL4D4p/vTefYNcNJ9emZWQO/tR1fvyPNmb7pjOVKy/XGVAq/J3HvhXs0zxzupdarGuwQs4BRt2HBlfLxZGjd/HMVLgnZqzzt3pLYCe58Szg2ynVKvkHKbFy8oby2UXmGdC9AOZu0g7SWSOFPVTISZMDwsP6N+F33BFopDkdlhBN5asBXm+I2fva4AE/zpQNxT3AyHEUH6VKXraEZ/ohClZnjLSOu2ntKOvzIueC2yvmsWZgtEppgyzMblHEab9d/YEUvyY4k9HJ4D7V9eqZZYAZRFdYXXf70ZKJm7m1haVCKLzPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 30, 2026 at 03:39:56PM +0200, David Hildenbrand (Arm) wrote:
>On 6/30/26 09:44, Vlastimil Babka (SUSE) wrote:
>> On 6/30/26 03:35, Zi Yan wrote:
>>> When using __GFP_COMP in alloc_contig_frozen_range(), if the allocated
>>> range does not match the requested one, the code errors out with EINVAL
>>> without freeing the allocated PFNs and causes free page leaks. Fix it by
>>> calling release_free_list() in the error path.
>>>
>>> The issue is reported by Sashiko[1].
>> 
>> So this?
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> 
>>> Fixes: e98337d11bbd ("mm/contig_alloc: support __GFP_COMP")
>>> Link: https://sashiko.dev/#/patchset/20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com [1]
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> Cc: stable@vger.kernel.org
>> 
>> Hm well, it's a path that warns, can only happen due to a development error?
>> Not sure we care about stable then. Anyway.
>> 
>
>If someone would run into the WARN we would already be in Fixes: territory.
>
>it's a path that should never be executed. If it does, the real issue must be fixed.
>
>So (a) I don't think this is stable material (b) I am skeptical that this is
>even a Fixes and (c) I am wondering whether we should touch this *at all*.

FWIW, this patch looks fine defensively, but probably not a stable
material unless we know a real caller can hit it :)

Cheers, Lance

