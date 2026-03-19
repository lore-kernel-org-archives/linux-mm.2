Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630C21075262
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 06:39:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63CF76B03FD; Thu, 19 Mar 2026 02:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C6146B03FE; Thu, 19 Mar 2026 02:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B4466B03FF; Thu, 19 Mar 2026 02:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 302736B03FD
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 02:39:09 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D079613AB50
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:39:08 +0000 (UTC)
X-FDA: 84561860376.19.C356DCD
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id 296C612000D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 06:39:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eFTU2lLP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773902346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjIE6Af+vdFd9J62SKmwZapE1T6Gs2ZTmxPgKqYGLbU=;
	b=pjpa3/gfg08gE+f7mnHUnLRPcp1ohrh+/eD/uQ3+Z45P8dISzuSG6fZfab+Aq5JUBcAegl
	jgKLhlBJoIOlyP/Gc4sj7ipXf3skFhrIJ/Jfl4Yz0eQHkDzl4csmASyb4nXM9K10L28Pne
	HzANS53dWPFRK/TLBmBKb6DN3Q+lTa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773902346; a=rsa-sha256;
	cv=none;
	b=Rgc78TqSXIULThG0AdYF3fqKEKLYOtnwNdKrvBKrpK1ErCfdVwDyCT6WJomXANmNJ2jaG6
	IQ4//eheRACqVuIkEsCkGvL823ZFeeydy4dDM8IP81sSYIkHyOV9bleHurpIByF78jI2kZ
	iEBGuYo8GJ6HFSmhPeAA9RYWBc3UfQs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eFTU2lLP;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773902341; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cjIE6Af+vdFd9J62SKmwZapE1T6Gs2ZTmxPgKqYGLbU=;
	b=eFTU2lLP9XwQL1KnjUcA4CQioz5ZC7fVZMgoXImGd3+kkGnvVOmW+bJSdb7kjv8GFtWOOegdKWeMMm9w/41o8ZoLs1MJdy0A9EW6tBMwI5e0Q9Icg5pS1Ce/DkEppCpdMfm0LbtmTiIVwpwAFTrymvcy1PR73Qv43kTEhqAd0+w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.HUAuh_1773902339;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.HUAuh_1773902339 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 19 Mar 2026 14:39:00 +0800
Message-ID: <3f14fcb4-e53b-47ff-b1ce-61c52f54c99f@linux.alibaba.com>
Date: Thu, 19 Mar 2026 14:38:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm/huge: avoid big else branch in zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773865827.git.ljs@kernel.org>
 <10be43ead023e9f65333bcaf4064d9d197111405.1773865827.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <10be43ead023e9f65333bcaf4064d9d197111405.1773865827.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 296C612000D
X-Stat-Signature: w6umgskydcwpkokdx9zqc37teeyz9bwj
X-Rspam-User: 
X-HE-Tag: 1773902345-5552
X-HE-Meta: U2FsdGVkX18Z0h+v4LWV6v/uCZUB7VXR9KTb0LgS5QPS9ugcuj+7ARBWOu07xothm8QcQUFn0Bhv1/TD1ch8dCtJlRDcerJmDCYGXvfwCg2V06Cml6gKSzkKuju4hOf4ecrOFl2YDOt4UaUncNJJTJuvydo41+JfNG+JjP48RECeYQsb+vf4ih7BgQ3RpMMEkL+sRiERrZdWvl4CetRAo2bnVCUobKm6SGldrDfkZdHFm51pFvMhM/cRzFA14VaIpZg5CObFBGBK4q+ZSVwGwQ7Y+akgp6xugVdolme388VP38z1FwenVnw/h6811Vmd7WGIgtxcIXnUoaLhpj2m8I5a/j3BgJJL9IGCgDuBD70pAIJfqfxhtR3a/SryiNumx5e7aPqaqbmcme3nJHmvAqAtB09gFGjXyJ6Xz190rlOAwtoyOfJiM2+H3qIqGHE4aVP6+TFlf4bpXrLK4ZVaA2URKH/Z6Fhx9T+2n5y8r4AOLMfBzV4v6WW1zKdTvbJZyHtMdvV/NYPU9gu3T+/HSDvtuuZSjgH9sAlIbUmbdjJKLH2VOBh0ERTDrRocbrjl/2EFv1pgXHYx22iHRUmtVPy6XkKDP/FzKd5l1ru3EbNrvTIRuAp503dzPjmgRPCJsgvLAnkTndgV0CsroqYshwThgJF9KlVnOuvPkne5fS7a3t0mcMakBJSVgeNx19+81IAmfPPAdXIykfh7CfMYvwmPonDzfeRsgaUkl6HDAHRpLoCNgslWKU3NP5FRRJKDWOKP8KfM3Y2qz60B6riCj5wCcLh9d2i5ZIRECS6PPbM+7Z/xu/BMmUnG1Mg37azhkKXpwAVOzhNdd5/7XPZE8mP7GGBHwyzjqBu0/m1ran1LigtivBTvLC1EGwOpfqnS1x0a2o1F9g2crbx6TAGffs5fiwG1rIQMelcsV1Wr7YZUj42Ythc/RCey1W6kcdn/M8dCyo46pGfoGytnkk5
 Puw==
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

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

