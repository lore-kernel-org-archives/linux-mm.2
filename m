Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6312CD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 19:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25BFD6B008A; Thu, 28 May 2026 15:37:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20C836B008C; Thu, 28 May 2026 15:37:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14A566B0092; Thu, 28 May 2026 15:37:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 087B56B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 15:37:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C6E311C07DB
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:37:19 +0000 (UTC)
X-FDA: 84817837398.13.8B30F9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C2CC8000D
	for <linux-mm@kvack.org>; Thu, 28 May 2026 19:37:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V5nD2zmj;
	spf=pass (imf02.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779997037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/Y06T/cRIeYfrCeql2lWHIoraymE8skfKnjtZVSJkU=;
	b=TJjSMLgAU52STkXe6X1NvTS/akA9GSKvG6rocCXx2cQ1Q4vJlQFzgqBFtD21sw95/3iQGz
	UbEcNDi7Y24VYS8Z1yMOhj4qDII9Y6LhYyglATeJZhJd9OoH7EVUzd9RZf+H4eNPnT8RzG
	8ufByuYdtaKelSclojeWlvaZztKZJKc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=V5nD2zmj;
	spf=pass (imf02.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779997037; a=rsa-sha256;
	cv=none;
	b=kJJCQZPEkgOKt9BNh8Bhp64dJTEwmwJ0NhRKdzqo+JNAiojhwIyjMX4RBJKxWgGCY7nYNo
	NCrfzFy4XQfdb2fv3qySsUHr3Y7m/DDSA9wm8faUrt7vzZaiC1UxMs760LXJdPqwzZDyU2
	NJwx17EIkF2THooZ3ptJh2+mkUJZzNQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779997037;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/Y06T/cRIeYfrCeql2lWHIoraymE8skfKnjtZVSJkU=;
	b=V5nD2zmj51k3OdQo2+OxNJO9XfOLCpmdKSTvGDCqp6CwFtmqpacxc/Z3mT/HOZ+laMp1uR
	iWzv2t9wGszjb3A41QHClFb5bVkwSRwDDN68KNgJOrdRmG3XIe5gETH/Wz07JgtC+/iWdw
	HRZVazWF5Zeh0Ku3OVS35qKMjIFTgaY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-9RtqLVQAPB-CYuUB4EPXcg-1; Thu,
 28 May 2026 15:37:11 -0400
X-MC-Unique: 9RtqLVQAPB-CYuUB4EPXcg-1
X-Mimecast-MFC-AGG-ID: 9RtqLVQAPB-CYuUB4EPXcg_1779997029
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1790B195609F;
	Thu, 28 May 2026 19:37:08 +0000 (UTC)
Received: from [10.22.65.204] (unknown [10.22.65.204])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D0A071955F22;
	Thu, 28 May 2026 19:37:04 +0000 (UTC)
Message-ID: <305848e7-f987-494c-8244-bcf8eed6fb7d@redhat.com>
Date: Thu, 28 May 2026 15:37:04 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: don't allow empty relative nodemask in
 mpol_relative_nodemask()
To: Yury Norov <ynorov@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Farhad Alemi <farhad.alemi@berkeley.edu>,
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org
References: <20260528190337.878027-1-ynorov@nvidia.com>
From: Waiman Long <longman@redhat.com>
In-Reply-To: <20260528190337.878027-1-ynorov@nvidia.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: J-s3LL2_lanadamu80X-ChdfoxYxo6A6v-tgFWb7CMk_1779997029
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: sywmcpzr3h6xpzryfpjpg7cbecdtixtt
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C2CC8000D
X-HE-Tag: 1779997037-706498
X-HE-Meta: U2FsdGVkX192nb+3ak84ORuQRePi2eiDUEz8j3IDHw3jKVC1ukkGR2pmsLe95AYkGv9RHjWdEHEu4xMSWW7QQEx/kpv7jNvxagYStO0EVYfljYruWZHM0p3V0Kw0rXjjmQDkXGU1Mm5699Mqm7HdPnZ86HDwQfurGcQx4l21rNvJ0h7CpSCEO8Q5V/QgxzZIrBjyumXJoGNEx2F7DWY9W/nc+kZQJjEwwhgf5tTVSJOGds1z+PBJfMnveFkPsm4JdfbD1+crFj8uY7SwEpu6+Ak83JWmZIPTx4o6SqEauOQAgDhVHkNjveUXjjAHs2mNZFiyYcvFHOfCZBVNB3jGK4bYBYUb/NrdCd8VR8ePhj2eXoROaDFGHEPQa20bPiYdXfQr7X7un/Ewk8UC618othhCMEscwq8+YFm5RnsSbpQC0wBoAPm6VPEmACfz8UyqzPSX0dUBQpy/Wj+H95nz2YvtbPgeapM2/7jopWvvtYhUvXRqSGOxbA9IxGQ/4FInxl87I3k1jByKnQPQtnnSIoJPn9yKRlpsZOAx+F077bp1miWXCBYTefOG/R4c7yjrtITd+RkKpfuGvIEsjU20+hgk6CWXru1dwbdpIIksupNaBYr2QibfBvm2qHTf7PLH8RnkXiQ/LKtpFiruF/pzZf38Ycbvn6oXhd8WQsF/+lY6X9IvWZZSVZGaYt8OAd+fEn2nfWYuEftXyvWL/vwLMJfdqWAPnk60ccTrx2MB+4YGjMfsIdgVdGbjlRHvo8EtlQaqvBhWkT5LkVrlNttfiZGWko1YT0HhSYrfhCUAWsgJzFnGt5dIsc35eg0K80ra2hQ7zqu6/J0/NjPz4NyTDeFuN5cE/ZlnuEgTTYVhMQ7ulcnJ6jSTktyzN7Jq26KXyG88Ibobb4slomIM3/0SAWmQmUJasBiNTD/0xyAJUrOOrMPWTwKx/Yqho4inGWSA1KmA0UD23+yuLZHHoAd
 2OQonPom
 8Mu9aLDP0KwLe8phXZ8se07DNdfY39UlWiAdxwG0+zRELjkwqGyNtJA4WJoOJRD7KjLHvAzVhcmor3wNHJP1wPqh1dCK6QN1m6X6h55qfN1lprwfYRBs8D9MPtW4bQr5MAcwa2RReSwQ7Y7ldOwFxRymo6oBAhnffBLiepG3AxxwGOjOInuZTsayct+ianfoeVmYO3xbSTWe6EsU+OB0lqoD4r5e7oYKMQMwqiZd/CCRCiLRpchnkOhwX4WG7tccWlCIjNzpRWxDK7rCrR1GFsnF+SB/kpoHrue1TkZ4GO65wg2jrP00afI9NOOoFQzOUXbW/mQlm8pjsFg6MF8BxPcgcNjHWYbLJ7U69vipVEm4aJE+MLsJ1WkioiMVl8DuwPJ5BCHS4bS+MTdCbEi1bCu7qjnN8+1fpZZKAtZg+JIELUZBoaKD3dMDKdEdZ3bO2hw2n0revE26UXrvwaLYaGv8tWca3a2Ezm4DterBdZnOQKOgH1M4tgpUp5mtw1htJLLLso5Ff3AmAifDN+Rj13ycDI2ClzZyZvCL1gJcwznNeaXqBNRwzmRs4yMMLIvlgx7jF/XnKO6oTH95n7J1VTeQu8LMq0kFNjDBNy/bYgZsjQ7422W7MwOA3jCPeZDEP25Wi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/28/26 3:03 PM, Yury Norov wrote:
> Reassigning nodes relative an empty user-provided nodemask is useless,
> and triggers divide-by-zero in the function.
>
> Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
> Link: https://lore.kernel.org/all/CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com/
> Signed-off-by: Yury Norov <ynorov@nvidia.com>
> ---
>   mm/mempolicy.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 4e4421b22b59..cd961fa1eb33 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -370,8 +370,13 @@ static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>   static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
>   				   const nodemask_t *rel)
>   {
> +	unsigned int w = nodes_weight(*rel);
>   	nodemask_t tmp;
> -	nodes_fold(tmp, *orig, nodes_weight(*rel));
> +
> +	if (w == 0)
> +		return -EINVAL;
> +
> +	nodes_fold(tmp, *orig, w);
>   	nodes_onto(*ret, tmp, *rel);
>   }
>   

mpol_relative_nodemask() is a void function, so this code should fail 
compilation. Right?

Cheers,
Longman


