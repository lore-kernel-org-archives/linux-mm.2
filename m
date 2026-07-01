Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E0CC43327
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 222406B00A6; Wed,  1 Jul 2026 08:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D3286B00A8; Wed,  1 Jul 2026 08:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C27D6B00A9; Wed,  1 Jul 2026 08:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D83F76B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:25:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55497C1C1B
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:25:23 +0000 (UTC)
X-FDA: 84940128126.12.3FCCADD
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 68C95100003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:25:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jZwgNYtT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782908721;
	b=jspyUK4diVTPPzTcSb4dVU1nwPZTMXQwIeztQRZZe2ifRDmefJOEhOr+bBH9JbCMbT50cf
	825FBcloG5S4d0vEGlp9QK+xn998SkByMe22t1zp7hwhvWS8p7PkAfhYia1cH0/TalDEtT
	U/G1Mv2Ae3UzZbZFcGhif9R0+bhVRBw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782908721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DsG1kXt+85Rxd+2o95H7CaUPzIdnVqDc9AD2+F5fpAQ=;
	b=hmVWV7wzMLKXAtZnMN1wC7T8uBOuMWZyHc3bgoEI5H4Oeg1+YR/8iMAln0bVvlanDdd5vv
	lc6Rl9YVKeIKhFKa0pk/JKdxZXL/er+oVkMsZAUkKXPcCodeRynwcsooPASs0lmGUBieSN
	iVfgCUUayYpcDvRxcvurL8OSdwaPTD4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jZwgNYtT;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782908719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DsG1kXt+85Rxd+2o95H7CaUPzIdnVqDc9AD2+F5fpAQ=;
	b=jZwgNYtTmNQJkEYTsA1vxO0R9oKoj2H2a7HwaUiFFh0U/TuLzmZ9IsEmPsxPpfnUcKaPUv
	0crm5YQcBVbEVlZ+OTPmEJaAymyhUFNn7oyEofRpQfo+hrQkAGjfIMZZK+d7pWblT5Qo2u
	MyJOprIuI7U+CZ/zhtBdYm5aJR0BTpw=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org,
	ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	rppt@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/page_alloc: remove set_page_private() in prep_compound_tail()
Date: Wed,  1 Jul 2026 20:25:06 +0800
Message-Id: <20260701122506.77115-1-lance.yang@linux.dev>
In-Reply-To: <53edcc9b-e89a-440b-9d12-7142a561878e@kernel.org>
References: <53edcc9b-e89a-440b-9d12-7142a561878e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68C95100003
X-Stat-Signature: 9a8jc1mnjt6i6hoe5b3hxwnrue1si3hz
X-HE-Tag: 1782908721-566761
X-HE-Meta: U2FsdGVkX19SewCzkESAiB0rU/9sCIUiBe5xlOmlX6OdPCSqGuVqiXl4hofpobtZSX8WGXNHhyceUUhC43PsptkVw4ogkSnWPbY9dH47ICKHNO3/1yoqhGhCdX2Lhy8DFIBN92XWEuOmxwIZ3RJt3uVqYAwYY4p+8eVgCHgSmbqNqImneVqFdDkFx3VLTyRFPMU8DTY4Hz5qKIb32pgsTEq6jXKeSa9W6DkwGa5UeTnwCESj1kKiRwWN7htNSTJjEoG29HzdXQuM4YjUqNO6KqEJtWL6LI/A95r9V5Th904b5zaZW5jgskvIr1OE8CxstL5pl0GJQXyYh+hYpGkqjPP4/PY30eaU1Uy9dp2ppG6Nj29BpT+tsr9GF+fBBksH+Q0FSe3H/T+v/VdowyL5W+1Bl6qPvARvmPfEfdkTHlcBj5kjl6XOdVdBjNvNfmXIs3AU+vSnpc4w8K2VkeMH7H8968X405oaVmoPtcVv7ZtOLjuK8N1lQckxHGkB/NK46oFrfHOGdq8fWT6pvj7ZU2wYf3Xn3JNrj5CI19ebQHnzwWR8apgys7owyCzLdW5ZuMnGICKwUNpbf23dHZRw+3dnn9Qbw2dMoWjRNMleVQkBWA0JktQ0XILuPRcrAu9g3rK22urQXYtalk/FvkAN/3FMY21yPzlhDGygrPmc+eEZqrb9IS5yllf+wHx6Ds1GxPcbH24d98dTpy6bsso0dmThGCNjxq35iEKzuYqW9U5Vyv9e9u9IU4NWHeF1WV1jtgL5uKBcAgxmKDEgVGxCj9S9ji9IywBX2V9wkoT7Y1P0NIC6hzQMm2Ici75MOgm4/4TGSDvokyyBcdVjLh8RaGs9c8NEHutKltAjc3G/oqQljSPkUn076SmGc+Iw6pP00AZA0QiyWWom5asEKKUJx2HZK3DunPNpmXmxOzFn1zzgpegDlIN0moIWC4JsTQEFNR915tw8+QpDRZSwJAE
 AsKidbmp
 mEyPLBvJZ39ulMkSkRULZFwZ8kYYP5mkLgYkO8S7T8tSjU6ywEESKDPcIRqC0GlDaBPHNDvetc0hlLDO5FrXKEYdoEFDdBiBQJAB/1lXgiR7Xd4ehuzlv2A425FAcBJq3HP2b/hvGpDhAOI+ds0UYf0iqbBgJn5IoQkYMvd1bPMuuTYmIdJfmUPcK4od77wwKjmQbSYk35dKW0I/OMUBS29t/FJK4l+SYnmBLdy5BR6Bq2O5lMbleTcB2eYc+QCycUTLTFjRnvbc6sfqi71qBMN9a2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Jul 01, 2026 at 10:58:21AM +0200, David Hildenbrand (Arm) wrote:
>On 6/29/26 04:56, Zi Yan wrote:
>> With the subpage->private == 0 check added in a prior commit, any allocated
>> compound page should not have nonzero subpage->private. Remove the

With Vlastimil's suggestion on patch #03, we still expect tail pages to
have 0 ->private when freed, but only check it when check_pages_enabled
is enabled :)

>> unnecessary subpage->private initialization code in compound page
>> preparation.
>> 
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>  mm/internal.h | 1 -
>>  1 file changed, 1 deletion(-)
>> 
>> diff --git a/mm/internal.h b/mm/internal.h
>> index 181e79f1d6a2..c96421ce9350 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *tail,
>>  {
>>  	tail->mapping = TAIL_MAPPING;
>>  	set_compound_head(tail, head, order);
>> -	set_page_private(tail, 0);
>
>Do we want another safety check, maybe another VM_WARN_ON_ONCE?

Right! I think such a check might still be useful. Same old footgun :P

Cheers, Lance

