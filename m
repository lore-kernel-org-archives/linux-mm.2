Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 880EDCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5D46B0092; Thu, 18 Jun 2026 08:38:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3565F6B0099; Thu, 18 Jun 2026 08:38:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 244616B009B; Thu, 18 Jun 2026 08:38:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F03A46B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:38:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 63AD6C27D4
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:38:58 +0000 (UTC)
X-FDA: 84892987956.01.79B6C16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 94D0780012
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:38:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXZvhX1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781786336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v5OV2563283YHAEvpvJhlyU83u7DJ+i27wFCKx2WtMc=;
	b=X1D0F+Lx4u21T2Sv+/FKReBTvxVOP7uiWSGRH4jaKoO7Ynl+brzGmYZD5pHbeKW9KU2y2T
	2lz7KBGCZDsV9b5haUh+L1+a0951cWXDN/cCtcIwLRGMOdekqasp03nW8MOwIohyADHOSa
	PRqJTB7A68/1XnQAcq5fAeggas8R2lQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PXZvhX1w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781786336;
	b=1o08YNqYzEbtqFXCfjzmRmetK5rYtmNnNUrK47Z4I5z6FBfyXWmJTq9r6flRakS4mGMuda
	FcYHNOapK8Xq8ef3prnHwKHv5LJp/naObaCwE4k6jtz6POrjkaC+YKR3Z8/r+mjwTYw9SB
	YGVvEbFG3UQFQ+1JJttlmZDy43x9OmI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 939C443754;
	Thu, 18 Jun 2026 12:38:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C441F000E9;
	Thu, 18 Jun 2026 12:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781786335;
	bh=v5OV2563283YHAEvpvJhlyU83u7DJ+i27wFCKx2WtMc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PXZvhX1w3Q62MTgCQdbJwIzKCTZAbIVyDIh5ZVc9+h/W0uHbN4coaZ2M576QpPmcF
	 ZwODhKRuqrtC+ZCBGrGeDVESVsTq4POkW2uP29xytbdEHRAuV0nBI3sK5OODMfdDAP
	 ZL4ig4pnFtyEGwb5s+F9TvGSggB8e66DD6OcUjt3hMZyHC8uX93cuDdlemV5iKo1Eg
	 ZPS8cOHA0dx3yK2XIo6DK71UVECo1A0NMQZZ7JwFHp1jcnEJErYLsZW1qLS2wF6kQR
	 4fLfr7kHSY+kQu1tVaLJC+GBLnoxrp8dhMOsei1Vw6qvGRSG/n7/8B4Ql4RYzYVP23
	 kG833FD/mPU1Q==
Message-ID: <d4b55716-97c7-4e75-8500-6a1171ad7fc6@kernel.org>
Date: Thu, 18 Jun 2026 14:38:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: JP Kobryn <jp.kobryn@linux.dev>, linux-mm@kvack.org, willy@infradead.org,
 usama.arif@linux.dev, akpm@linux-foundation.org, mhocko@suse.com,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com,
 kasong@tencent.com, qi.zheng@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
 <06122cae-e28b-4ded-a9dd-d380d31c5230@kernel.org>
 <ajK1YsIJmD2ImbAk@linux.dev>
 <1136baf3-3967-4202-9eaa-5fd667c235cf@kernel.org>
 <3149bc84-dd3a-43ba-826e-6364965fdafd@kernel.org>
 <bbcb6db5-6a01-46b7-979f-dadd52a5176f@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bbcb6db5-6a01-46b7-979f-dadd52a5176f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a9xhpkzpg5ypdq3x3acs5cbxpg6etr8b
X-Rspamd-Queue-Id: 94D0780012
X-HE-Tag: 1781786336-785546
X-HE-Meta: U2FsdGVkX1+mPAy3UhUGPw3+Pd2APuCxaKOWSgv1an5Cu3MDgtJXXtCzbWGdOPxlE5/gGhuADoGpCyqIK4rrK/Fgb5Wk134oLHnJv2YRjTJgyYMzGBh2PO5nUnjtyyGhBFQnYp8OnVmBpyrYnuwuVKh7INtIvJguZ3ScUh8LiOVBIdWa4AIOdJNw50Yyv+OcOwlMDp0c2bM2sVnClHHjCP9ij4gDF1RWGHI7kFwFZ0BZicSsngujxMcGDf+ysgB6jrF4yJVp9nf0Gx5etONeRQ6gLQYWZx6BlUZNosk7G+7CJY72K68XmcMeM4t6fU3rDHk7pMj5QjJ4qSWX0Wa1un5/J6baG65f/F3D+qlOBV9Yw3Mi3OOY8W3+rkGbxhAlNVmwM0Wg9zcRbt6+25VeyBzmLXaBDHG3y8PfuwnZRIqaX6guy6uRcSGENJVj+xgjuETTvjsXPo3qGmYrdD+80AuoyYaOVkrhaTGLFdT+4AhD1FFHiECTh6WGFeRLbF9o1zNXjnL7H1VTfqnpjUkYnBY/qLjx9aG3yKkw1chN3rKNFRAA+PGbHhXZOtYX/Df0LpJ+ljGe7pQVD51PYZHZmh2+SiaeRkSltAH6Y1viFFsADMZKsunoxsHswhfu+IvxozsuRSN4KCCmp6tG4pSkGjWiQuN8Kg14uMNitjC0EDp3aNByIvROET+7oaoZ6vI18mah/5oXJcTa+3R+hHkv3py7VTXtT6pd+U0pBrjET1QJbvlrs2fwrwp9+RCWYscehzAPxvqSNwh2BUtvIj1RVafTy8FoA1OMDSKlGXFycsWaF6WagKemPn2dO65JOzSHjW/zpTL7KJRJ6LNFWkn+kuu4L/OgUv8w+cajGIfGuVyck0hjmUerv878LE6vUEy7WvU2aPIaENCDyYiHLZyAMNzd5I0zq+uHXk4Ny3/tAUpVPGC+gZp9x78Stlc1V5oI2DYB7Ot9jeN7P5B/gzE
 IAaE26ep
 f4toDKiPmsktXkg4y/IrPoq2JJyPylidRgTN75Z8X+WowlCy1ZolaPCvDjHYmBh8V7krR7PtHyc2kDF+OjS2/MgDwgzcXPEHDAB9gsZmEiJilzG+jvPLT6aPc1SLXN4lOoSJ6jEtSHg8hL34cxbpBKMYm6RRf6lUd5DoF5HsBY0ggxmaQHD/UdS/pMzNR/4r6xT0LDfLfGCUIWuDyJEu+t+jjqExDy2B5Ppd3wRFAWt9sddbbgM+gx7jT7DGSVumnZViGXII5hLla5fY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 10:30, Vlastimil Babka (SUSE) wrote:
> On 6/18/26 10:21, David Hildenbrand (Arm) wrote:
>> On 6/17/26 20:18, Vlastimil Babka (SUSE) wrote:
>>>
>>> Yeah and I don't recall ever that a change to a mm tracepoint would ever
>>> break someone who'd complain and we'd have to revert it.
>> Really? :)
>>
>> Read the context of the link I posted once more.
> 
> Ah, I see. I've only read the single mail from Steven that referred to the
> old powertop breakage and didn't notice the context.
> 
> But I don't think these worries should stop us from adding easily usable
> tracepoints.

Steve explained a way how apparently scheduler people are handling it without
trace events.

You can always remove/modify tracepoints, but not trace events.

Anyhow, just wanted to mention it, because so far MM didn't rally know about
this implication.

-- 
Cheers,

David

