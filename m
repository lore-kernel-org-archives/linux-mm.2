Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E36F94CDB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:32:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A1196B0088; Wed, 22 Apr 2026 03:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752316B008A; Wed, 22 Apr 2026 03:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6408F6B008C; Wed, 22 Apr 2026 03:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 521956B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:32:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 012BD13C24C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:32:53 +0000 (UTC)
X-FDA: 84685375068.12.55B66EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B9EDA0004
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:32:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWn5Lipx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776843172; a=rsa-sha256;
	cv=none;
	b=qUitN3w9xV8CNkof4HxwFWw2RDfzPmF9TlbJHnxKjJqLUQiuo/m7npffvX4DqmYKC9kh+6
	xbWQtXF6Ymw2o3YqT24inyRwMwXjut3CZ2Uo79DHgf1cFAE2xutxJqKHB0N9Sdj81letFU
	hP4mVptNg/1O71QYfAMDpPadA/hU9E8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UWn5Lipx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776843172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SG3U5Kc9NnIbl1SNYavcCahtb0w4f/92raszKTt9OvQ=;
	b=LuWnpXiAwTLbRJ2JFNioeuq0KWlOp+++CnfOGkwuz5fG+GyEFF6DcS18V+/kcz+iuF4Wy9
	aKS6kbbfCOKHO+280lCPdmBHYeyI09IYHNp0kt9lBs9AvIrBaavnjBtI2tRwQq3NQqmiu8
	M877cJY1BYIwge8vxZxL0tpQdtZRIBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BEF74401A;
	Wed, 22 Apr 2026 07:32:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5DFC19425;
	Wed, 22 Apr 2026 07:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776843171;
	bh=tmYp3b+r6xGGwWY4X9h42ZuE85+tMVe7ly8mid2UHH8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UWn5Lipxf+Sc1LCZpRjv0NROKKlwHt4nvhn6Jbh3rpy+EjEImQpTWKcw4prS4+SfI
	 /ShG9UPAJu6u1N7JAsS7Y3YjJERZ7bT/uFcp+5rA3pGXfO4+rBoiJvSl4OBsHNfINk
	 OSOirgRW4F6GVQYKkNTxwZbhZzG3W8uR+wkBsJ2UR7KeGT34fe4Uncqg8+LTOXXuK0
	 iVzDTXC37AbkRlxsXuXQCRyQMCSSIEeUo74D43jkEY7rR+Q9oOrCvYO9j2ETn+i/gZ
	 Y/i5NoODH8hLdiT6+2JEfX+Q1KV+I28bq3uh676yDdct4zQeyU3wGGmtI+hKX1aU+c
	 Q7UDCrUTZn9lA==
Message-ID: <51c8ef87-761e-4357-a99d-e5d60cf77ca1@kernel.org>
Date: Wed, 22 Apr 2026 09:32:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/page_alloc: fix initialization of tags of the huge
 zero folio with init_on_free
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Brown <broonie@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260421-zerotags-v2-1-05cb1035482e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: 73m337h113ag1daz93n9j96izmju48n3
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B9EDA0004
X-HE-Tag: 1776843171-27219
X-HE-Meta: U2FsdGVkX18n89wVpORNByMqkesNxhOuDxrYrlkVMyhetPGbhUG5HPAto+V1KllZKHtmDLnQlHMoiv8C5kAYVk2wHDypquS/R39tldTc7SVyrZdze5OrIS8B4nNzdB4BCObRyMJJyrO9A0vqBk4w8LtfpxOayq+AwQDnnFEJSftBFpSP8JnLLzgoCvP3fE6KzH2PatOrAU+aKQL1C5/D8bEy/Y+KVbKXKPZXSRJ6KWGX2ueOJhDCnFqfSBFmmXCy10U/NYVZf8HQLBOU+f5Pb/6jFP0AKzs201sN09JUmo226nIZRuLmW+NyyW3juIJfewJ1sj6I4V9jq8OaAIs53PRvp2TrjJokFyrNGYWwRKf3iVP4Mi48SEKouRifsg6hQqgkQ6Y7No/J4jbSyMvUSGMIXb6FtEI6jS87qt3J6QgXON0cRq1+B2raHIBQSeY6FeLo4B186pEmytbXLock6XfNS1ewg9SwWXK9X1aarmiHjPNhGUa3AgQWA08SbJZGItYj9fBWtxexLKy/ER4IrSJVbvagLGBxk5lyfsKyJe1LLyptQcvNHbL4DH5wGlbLIbkfMEm4L6Q9bry6vtqrWK//WFss/jVlxRsNFxP1gj/Xn2rsl5KDjOAIeMV+9f33AKTt2JPIkOWSuI/kZFfGKRj0V7wohxPZu/J4QCxwDkpi8CoRN1FvGriS1njOsQXgop4sSZmH1lLvENoe+tv0wy13QWtI5HufYUaKkLWsE9yf2kaIR5tFA3rI2+dTTxwrbUyQ2VMcjMbXtHAUCpPN2aW7A60+OKKnIs9EISXVvInaAt9I6aWtx1mK/417sJ63sx+wbeqAo1UIZWACfkUSvHmOp0QtwuEPC+53rlh33i44gZzviR3Sj0w70c+7LiGkGc+jKpwFoGGMdlQVa4PZb4yuhSV1eJqbk3wAF4zMi6jY7iE6e81OJNu2mN0CaVVpOvFUlnbRRT1WiFHw+jY
 3SRTJUvF
 NYdj7YfkR+Ddkv2Ydk2jRxxEwjHcvS046J415O7TIZ2x45TFZ/eHllrEewVqMqiuqe033vppi30j5jcMMjlv+2xaztquhLvjYS7IIcljEAeOZa/TjIf2aebSn5VQqaspGrcRrahAATdR4alQ5RAH7SU4SWNkEhyhKxMplujkbdk3pKyEbh+e9lYJvRs1wBuG6vG1vPtUpFbpUo6xUjM5EBolKLTG4bGj4W4ts/5YkWtOEbotQQlL89I2etW+RutbLWNKMNCX+i8X4MFJkdLwE4m6iPY4U0vmm33AVqRtQtTCiqlOeTpTOcohJvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>  }
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 6c75df30a281..d79049291b1a 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -273,11 +273,11 @@ enum {
>   *
>   * %__GFP_ZERO returns a zeroed page on success.
>   *
> - * %__GFP_ZEROTAGS zeroes memory tags at allocation time if the memory itself
> - * is being zeroed (either via __GFP_ZERO or via init_on_alloc, provided that
> - * __GFP_SKIP_ZERO is not set). This flag is intended for optimization: setting
> - * memory tags at the same time as zeroing memory has minimal additional
> - * performance impact.
> + * %__GFP_ZEROTAGS zeroes memory tags at allocation time. Setting memory tags at
> + * the same time as zeroing memory (e.g., with __GPF_ZERO) has minimal

As pointed out by AI review s/__GPF_ZERO/__GFP_ZERO/.

I assume this can be fixed up when applying.

-- 
Cheers,

David

