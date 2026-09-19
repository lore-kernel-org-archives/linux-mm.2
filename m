Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 270A2C982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 10:07:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC9596B008A; Sat, 19 Sep 2026 06:07:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A796B008C; Sat, 19 Sep 2026 06:07:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69736B0092; Sat, 19 Sep 2026 06:07:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 73B5B6B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 06:07:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 16A361A020B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:07:01 +0000 (UTC)
X-FDA: 85230083442.05.E993A62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 36178140006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 10:06:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGBtwUNg;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789812419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmYQfGFlr0gkUuVaDtz5C4O++lg0LHkym0LC5utx1xQ=;
	b=A7Bdbyhz0RZa02lG85uhoTHe3zzc7jGuWKDpqSPWDW2SFF46iFx5BOsQ9F2MDSM4w2k7MM
	CINqDt7AkiW0y5+b56ctjFaP3DDhLubQMTqmx9cr57Tc1KyoPVraDX4/Fq5X44WY8tGzI2
	DolpwNNApQ/LMwoquHgi7RbpigoYtoA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789812419;
	b=GCMioX9k2d+eqhNpuW8E+jSgIvJNJ1GO60mtlHwAuzCmZ5/t3KmeAFlm6mgXdXHMYFBSnU
	S9IUam3ZvbTLvOce36fHbVE8C4XZYuMGxGJAgNeO7WgbhBAuo1xBx3MGJMvhvGlm9w2XWk
	Hmu8aoVmKRyZhw5Mkoou2INQmY63bVY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGBtwUNg;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59CE543CD1;
	Sat, 19 Sep 2026 10:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882FC1F000FF;
	Sat, 19 Sep 2026 10:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789812418;
	bh=wmYQfGFlr0gkUuVaDtz5C4O++lg0LHkym0LC5utx1xQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NGBtwUNgww8qarfWiEsbE16y4T3wnfzKTb/Jg3NsXGsCGZdUq2UeOCROEeZm4TGCs
	 w8jNxAkkeLbGhzYLdJw7f472pbJZhRYMQc4TVOQY75Bh8AWaQCKdcCcr5N1r05AX+L
	 s4pzxBvCF2ehQIio3S3bNklJbxLLX50gPwtw+lplUGFPA4dxhHs8wNi4HO6tUei8eO
	 1tmeiOOoZrvja1PaEbOWQio3lWAg2kd4W+bbiQJ18WqcFA450+V6EhtINSWqj2ySuX
	 ZQpUggufkJ5HkEfBCdRRL1SXy8AVZYS1Gg7D8svXg7yArAQu1b8GGap3ld8k5aT+mL
	 eL4ROWHtjqSEQ==
Message-ID: <d939eacc-8019-4954-b1f5-71d601db96a6@kernel.org>
Date: Sat, 19 Sep 2026 12:06:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] MAINTAINERS: make Gregory a co-maintainer of MEMORY
 MANAGEMENT - NUMA PLACEMENT
To: Gregory Price <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Rakie Kim <rakie.kim@sk.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-3-9a94cac6d135@kernel.org>
 <aq1pO6KRR2CMov8D@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq1pO6KRR2CMov8D@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9aer1ii4coy7zbbqfknobbfs5btxx4rz
X-Rspam-User: 
X-Rspamd-Queue-Id: 36178140006
X-Rspamd-Server: rspam03
X-HE-Tag: 1789812419-853330
X-HE-Meta: U2FsdGVkX19VFBA56bdlyDemIQ69uAd3FDzzHC1jUPjMt037RBMys/fIdclxlngKZtk6DMgKHSAG/Gh1hw528qHLiQHeWxKIgMRm8zur5RaIAShGlJ0fssUbHXc4fpdKvHom/R7Qb59WG39WKFFG5hFuibqDnxkbFbNAweJSklB4lHNWf6DBHqkL7NKRfX4f88zKfnvvwOOyuIA+1eok/NOtOCBIT82nRwmelZHAw5huslZFwM37nCTeHRBerystjGNipho/xdY/9wdFVXrATUMZm2Oc8BCX6KKbFeklB2A4W08Uodl1rF6gkhg5aMVoBiduB+2Ws5JNMtxL2To5FMfHc/9sgA7uHO9oEnivBAPrQB426fD/B/vbcR02RetTe5ipO4jmUYbfMc2nBzZcZwmbauqpEsvW+Y9LtcofsCBkOSLx9HwLtLPl4nOkovrQh4jEc07OQIjozw0JFnEecd/QdtjyOrJ9b+/Gw9bm8PQ25s8fnQHKnMcJq4mXteuOXdfS0AwTazqs9VIKv1ZPmkvWeLYnrFu3+Vub6QkDDeuiXFTioXZebiDxzG/p1dZkAzewrjflNv+e0/EMjdxa5U0Zu7YdxUZ7h+MMj2IZSWx5KiNIz7RsHVabARGI+HWCdG6lC4iOfmvY4Rq2nIolUsfL2kv2tn9c7xt8I6VINKHIUkEcpsAMoDZ9VJ5EitikTi8rpFocHnAr/TPm/o5Bb6gDVXQ7jCXitFn0QwYufGLf1GjEPr2OLbP/GvjTsQzeCoFPPxoS47QDorIeHaQZBVDmpoiDEAfewBlCPyqT88dd17viV6lRcspXMvCqihGGIOuzuXNpKkdUuXU6XyVCcExd8qDkFfWqtMjBw8uXK/74J7yYyjmQojHcvl5+L75qovQonuXs6d+M5DWo3QDWP9IUxm2iTQKqRQi6OTBmwyESxVentWDaAAH/puDUNVA20tyoWBPMbJCpv37kKcA
 SydA6S6k
 vpFXXjWlyE8cy6UzpkQ9b/4F0XpL5n7b64TgOJ3MVn5w8/WUHiaAEaTVkchoCdEoIGlNd7TfzhHV/S5tIosYfDXpQ+rmSI+o1N3p4mjWaxk6IFZpMx3EoaQsT3lrt69N2pB8fxtXk/jx9W14DLbvM0NVlX4IcfZoCDgJ2H3GXptvjffv0hNeJlsF8ewH+hqjZHWY/f3yjUreRqpUNnkE3+G177vwjoCVToLvELE53HKDVkAR4YYDj2oubrqKh7hJxoBaboNluewNIYWf/GFZOHVEGSjHduAddEIo5TcgnoNfa1RXxlXlOx04l9ssCqMkOAGElbJZXlyxdEewsytpMhf2pOq+rnQM9tzlP6LsDU5ffOhCxmH3tfSEqtILmzLoazj2n9JIwlSkJYOGA01+YwjuLeEX4rEahkEJW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 18:41, Gregory Price wrote:
> On Fri, Sep 18, 2026 at 06:34:26PM +0200, David Hildenbrand (Arm) wrote:
>> Gregory is extremely familiar with NUMA placement handling and volunteer
>> to help co-maintain the numa placement bits. So add him as a
>> co-maintainer.
>>
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Acked-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> going to take me a second to get used to that.

Don't be scared it only hurts a little ( ... initially ;) )

-- 
Cheers,

David

