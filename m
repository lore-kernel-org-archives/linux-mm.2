Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98563FED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C86ED6B0005; Tue, 17 Mar 2026 12:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E846B008A; Tue, 17 Mar 2026 12:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B743F6B008C; Tue, 17 Mar 2026 12:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A82466B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:35:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5395013A4F6
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:35:31 +0000 (UTC)
X-FDA: 84556105662.24.76236F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 737E480003
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:35:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPczWlC1;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773765329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HkIZKxSdH2isIftBVF0AO3ipWXy6AhFi+nEwH9Iy78M=;
	b=cG7rC9Pq0ad7x3awrDWJouceNNUwXz0PsNouS8ZHimWpAFlagRPDUczE8LXFjHj2tQlFVN
	fNPOWZHRwFlKxt86hV1L1bSpvL4G2/pLNFwZk7e0IUMmMS20dhNzXLCILxIw4XYBpJ15N5
	6VJjh3dnVd4xc8g1lFl157JhV12fJVs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SPczWlC1;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773765329; a=rsa-sha256;
	cv=none;
	b=APKmhCg5oCrXhahOiHIcOMj6xkTsMrsSKpiWuy4vPy465OHn/L9mb+gKlGRkMO9uCdxbK9
	bfrjjw5RXehTdlWTMF7u7bIQ0qxCWn6n0nD2bBp2jSKpbhHOuOIeZulfvra7li67/lNlUb
	ki0jd/wV9IDkSHwq8/ddv/6CxMOB+YY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FAF340407;
	Tue, 17 Mar 2026 16:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DEFC4CEF7;
	Tue, 17 Mar 2026 16:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773765328;
	bh=ST8KtsD3ALVMbCZqs/+q7FuajmhnAedaz/VdlEk78aw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SPczWlC1g3QXHKfX7zK2mFHmT5IbND++CLr7/8HN6vHEvw5g3az1/6YvENlniet/W
	 6Y1ruHLKUIhe3+eXDUIJwbu7+wEw5eRz2AAH1c/xn7BnnbyVqqnlGatUXgWBRGe/5n
	 j2v6HLWcMpfx2aDoahT2FgKW/p8SzI+btZQopNUVYNIiihe1I7GRepRZCHHxZt+0rO
	 /otFhoBrHnQ99LI1NxY6seDy7Vx3W7S3YvqazER48ec0Iffm22s3gUQ0cy1djLMZ/Y
	 AsfrGCOXD3xrS4ONGbxT5YZOMPqw6M7IZ9pRp1u80luaP3KSgSmmD9Ff9tlfY1BaAu
	 wENlXKmnmU2rQ==
Message-ID: <bfa8b7d5-364a-4322-ab07-d85038309767@kernel.org>
Date: Tue, 17 Mar 2026 17:35:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] mm: list_lru: introduce caller locking for
 additions and deletions
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Dave Chinner <david@fromorbit.com>, Roman Gushchin
 <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-6-hannes@cmpxchg.org>
 <46d9173e-98cd-4f59-b0f3-e477afd5283b@kernel.org>
 <ablfFy6xnWwZQyUq@cmpxchg.org> <ablmYhfNFIfHqzX5@cmpxchg.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ablmYhfNFIfHqzX5@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 737E480003
X-Stat-Signature: 63bdpmnddim96nm8ewdpschf4metkc4r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773765329-50126
X-HE-Meta: U2FsdGVkX18wVeSdrnteU8MrRdmprQeRxHp9EFBiOxsOXvXhaKlQrfHL6UFEtsmkOX+7ocPJYoL1SY2KyG3vkbuz9LRvamHv5fa4YhRY1hLjXRoVEM3fsM2rHB/PqE8FgdLzvFU6GrOtSedvYYr4Db6gsEjDsw1sxz18T6j5wkNvWd0eaMB2XK/0B+Kv5KBTuO8PsZLwcAlxY5K27u025iu3WPBIjVFHtr3ncAxzoA+8ciiB1KhfHNtofj+39fIIt4jXfd94LhcLeUki+5p8asiUrMbnlWzkZj7zGa3rqXUia5RZhPdWfcP3mfhvXfjkkVPsIjFZ7rGdH/7L87h0vl4wMrnl9ToKTU5lpWhcYDucQA6CxKPzV0JFGIHxv2Xf6QFnMcfmvNJ8Eh+mmD4X0199KQjghZsH0zxWcZ6zXGN/1oYBny1hQ3ISM7tZsIG8HqCH5nKRUOBxrESQZZHvwkAOYPyLSfi73d9BK89ONpQtLKgBJqd8zE/LPqL378ts787SicrLa9U8NYOMkC3K4sm18VYyQ+7rhbBpnginK8dnN3kK/WiEXM/GLYogEDZzAFiRDW2mGYJvLhTLe+t0HU2pbvnSIstLsN8RFRxJtrJdgyjuRckLAHw6IErduHViu0NVvToClD1FfMoAiyt9lR1PhQuVXTMSVe+7omfJ3Cdkmk0wmc1HXUCRKF3mlH4YXsF+hse5he3s3KkijOJJGOMYs+TUC4GAPBJQAdjxtOWsd33gfP4AGwPPi9TD0rQ99gmshyED+Mq5WHwcFzOk64Il94vh6NmjG7dYDFQ1xXIpRCjq239mpugwWphmXAU+8zQoNlMwgI8/MR4vPci1rlQkKc++LEEvzJnKBOIzvF6wfwyUyvZhjPOr+IuDNKmdMUHudjy8kVGKn0PZcfk2acfuaUCe+znQaEK0+OY5rq7Wg4GvbmPs/9TfklLSVwabEQ1RTHbbF2czY8WK0Y6
 Sdu+CyNf
 7bf8A+G+fkE/8XwRXk59Oij7dXQMuC+AWAw1EtbFXWyf6NGG5UOPc4v4wG6XtIunp5C1pCFBVUNsDM4c9WkgFHnQ1jyt13uEnESdUrzkem+PEPKp6GIeqTWCN//HVCDg+ZuFw6is2hlz1uhcyzzLK+14gaM8ndsM2DI43FOjMAvHA9Rw3SbIMTG7SF4loO/wvVaZ5EZ+N82G68X+xZ6UCMMw7DGZStl0YD1z5R8RQ8Oh7fk31KPLYoVaLEO6ki2vKzMoob/v+HcwsiqDxn0eEuL5gJ7lMVvHOMbJSnOImU9DqbnMChUDkkwHiAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 15:34, Johannes Weiner wrote:
> On Tue, Mar 17, 2026 at 10:03:08AM -0400, Johannes Weiner wrote:
>> On Tue, Mar 17, 2026 at 11:00:59AM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> And here it gets really confusing. true false false ... am I reading
>>> binary code?
>>>
>>> I guess the second "false" should actually be "NULL" :)
>>
>> Good catch, I'll fix that.
> 
> That's actually "flags" haha. But it supports your point.

Ohhh, haha. Well, at least nothing to fix then :)

-- 
Cheers,

David

