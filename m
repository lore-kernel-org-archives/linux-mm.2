Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559B6FB5EAA
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 03:26:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90EC06B03CF; Wed, 18 Mar 2026 23:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898416B03D0; Wed, 18 Mar 2026 23:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786DD6B03D1; Wed, 18 Mar 2026 23:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 630986B03CF
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:26:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E9FE1B7468
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:26:27 +0000 (UTC)
X-FDA: 84561374814.29.FCCFA0B
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf16.hostedemail.com (Postfix) with ESMTP id BB60E180002
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 03:26:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="boIQgSe/";
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773890785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X3hFeGLplj5gcJNH+nPtLsdbfdCmp+ODkITTDP1nWX8=;
	b=STvOt8EAOr4kAYfJF/iT58wXusN9HMqEiS10QyvvsJggjTorO1bhGLjMFk5bOIL1qxrcJB
	8s1vlURvUWdPZ3Mnu7htHreD1PG3QO84pVy6Wer2HdkFt3NYkxpvjD9/+40WZDynOEqfu2
	NhtdTMG47QF4z8uKmSjy7ZZG7HzTAOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773890785; a=rsa-sha256;
	cv=none;
	b=RQQwmucfThovpM3xDpID9JcSU45Qb59YmuLL46Wb/NJhtMRWJGl7qGSF+AGKS7hMWs1yd4
	E64/OXJ8P7w4kw6uJ8Qs09+/zNhK3l7yvBUo8PZ2B4vDy/Cm8Es4UP2OOmRJ2+iKkf4Rir
	Bif+BzHP/BeSGFMZmGStsSNT+zTWepE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="boIQgSe/";
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <4b2182c1-7984-4d05-ba9c-67046ed01b4b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773890781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X3hFeGLplj5gcJNH+nPtLsdbfdCmp+ODkITTDP1nWX8=;
	b=boIQgSe/hrj3e8DqA/zupaiLd9heEa5O8FFfH8iFtSSVrRUAmBlnINl5UvX78cLMKw6caQ
	Y+25V8khtUFQCv8QebsuSoxEzdgEM29ZOIAk16kRpx0ZqWNjlbONkQeVGczFDQUpHmWlIV
	EEg86mBt0Zl4oOVszQuYslzQpAeMlRs=
Date: Thu, 19 Mar 2026 11:26:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/8] mm/huge: avoid big else branch in zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <cover.1773865827.git.ljs@kernel.org>
 <10be43ead023e9f65333bcaf4064d9d197111405.1773865827.git.ljs@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <10be43ead023e9f65333bcaf4064d9d197111405.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: aw1r9a7muf6jmczfsthm37drrq7ehhgr
X-Rspamd-Queue-Id: BB60E180002
X-Rspamd-Server: rspam03
X-HE-Tag: 1773890783-501839
X-HE-Meta: U2FsdGVkX1909/Zmluf2HruHcejwLT1mT3yL7zNJX1isFnVRrp0TL2GW5GCXzBsf7mCwqU88HxuGt/6bw6WroFMUMWaeVdI7L3dcOcVqczdNqKEGokhahZZflWqpgOTvG9QuspjbtlllYvXCQlbmXnqckDLjw+PIYEP4M8iot20zE0YaE1LgBE7rqpWqBe3fLxOCj3mvmVM1M+/N85O+smvxhTEyDXVrjEYpISqLhuAgdESHfA/WbD+IlfZJCWi2g31HV4T/lg6F4BjrryJRf3vgE23SKrEUj7OG+iGQzdJ3TNJaTA2m+ouThKLkKA4bUZAATUxU37yF7xJBUW8Z2cpRgx1EuKE916EeDdHV9S4k6++Pttl7F1wi+xq9LlgiLPOV71Q9pSvN7qmg3HXZzXPrNGRDfmj9BDg8SUjqBnf0gJwh7qwKbdarIuVijh1oHNT192rWjIzM3Dcl5FHmcuRHdlBNYqqf5Ldgn7uz19+6rBYpw182RKoObSNYmp6DkhWesZtaKke9VDcihCWjnMDhvBz/gt0vZ3ZUrd02A2vGdDmHKPa7vzj7VYYoa6BCEHz0kba24Eg21HnYmZqm4syfzlJ5gk2tadIZqpmtffqrsndzwPzRsznZ8rGoiCbcBC2uS2TTP4oo8LVTDDSh6pL+VkqflwUr5S+r5t0rXt/8KFC8vfQdFmDVCwy6PQ1Cni+6JdDLVOx/I3Ge9SThsEsbpqI70mQaZQGxkFmxFdO/x5Tr33VBeCeXh3t7ILeo/FdSKAFUcsKV8CdZVXAao/o/cLF1AnV3iQWFoV8V4SoWTBWUKhrKf8Z9iDgC1YaindxlzhVtq8c8hgxJPKEgSTHkXUHCzr4JRxkH4WBVW8uiqrC7bigv2LYntfou5YPOBc7qXwBIB15971mTWza8VEqR9e0DJxV3CKNLBMDGMhtSzixOUz615TpdZOwbzLafGjdlIsdRD1MCoX0MQD9
 6H4F6zLi
 KY25Aq6vGBkTWeCYwbrDp5ciVDKFcR6SQm9NVmbyHdpjnl9CBJkBEskWxvQycipwpmJRnE6PE/0MoalhF/5eC9AvGewOHoiZBL61mMPmsQlRg9VEw4kmgz8iN15TDq2ORjrNZmpIPqoigZ6sicalYhbO4o/Caap1vC/CWcutpvRQzCDh7c+riD/Z7VaWdE0FTOQRDNHJIP1bwrZLzm/tGI0kVeXxTpOPM25yGKYFsoGQ4spVw80ZznWEv4V10mtc+dxXCAHBEYwN7QUeIshmyoYtHWvH12TqX2p+QxKVj5jdNulH2Wx75+5REaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 4:39 AM, Lorenzo Stoakes (Oracle) wrote:
> We don't need to have an extra level of indentation, we can simply exit
> early in the first two branches.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   mm/huge_memory.c | 87 +++++++++++++++++++++++++-----------------------
>   1 file changed, 45 insertions(+), 42 deletions(-)
> 

The code here isn't too complex, otherwise we can introduce the
function like do_zap_pte_range().

Acked-by: Qi Zheng <zhengqi.arch@bytedance.com>



