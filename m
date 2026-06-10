Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88066CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:52:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66666B00D1; Tue,  9 Jun 2026 21:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17886B00D3; Tue,  9 Jun 2026 21:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B53F66B00D4; Tue,  9 Jun 2026 21:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDFA6B00D1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:52:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 444641407C0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:52:21 +0000 (UTC)
X-FDA: 84862328082.29.0B26AB9
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf21.hostedemail.com (Postfix) with ESMTP id 63AC31C000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:52:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nY1Rvv7u;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781056339;
	b=8mWh6O2N9cYSLcYHJ3I1c2WeXzbSZx5+wiMTBbFxrtLco/GhXSXlynbREXj7Zmd7fOBdCi
	jmpFowT8u8HtcdcH/RWTm0LBQv1j0pEwfgwpdZ69OtjKPlm8CF2cteBsi0nPla0VDjlnLc
	Gft8FeDsi4JmeU6w4C2abTk7Sn0krt4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nY1Rvv7u;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781056339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6oscucqZTI8tSihrRZeF2fgG5t8dL22gX+gkmV9L8W4=;
	b=gWMlnToIRMesUiZ8V6nwWvFSvTRE2QwitLdG1IEDRvzYy0esx3cF46UYgtpkzyKXhZ21oN
	tBGq4C/8fJwUgRyyRurR8lXKnLQlQ5sLX/SwrofKBDlU/fO0gxui4zmIZoHh7VzWURb3AZ
	5UgnZt3kyazTwnPdI7EOZIDZ5xC/yEY=
Message-ID: <82057285-60b5-495d-a8f7-c05635155138@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781056337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6oscucqZTI8tSihrRZeF2fgG5t8dL22gX+gkmV9L8W4=;
	b=nY1Rvv7uawJYgbbdUyiyZq9VfwnkTI3SugGnKRmXoIJzTVcizL3U8XZdmIOYRRKFBMysnc
	cAWdVah2fFmlLhYO0nlTTME7rRatZoleac/jBspH/obwuNEibBznGKklVxhho1e9qNAuI1
	lS3aG1ZxLLeDUa24/iwZ1YSDJ+K7Hgg=
Date: Wed, 10 Jun 2026 09:52:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, ljs@kernel.org,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
 <b2d0cb7a-15fb-4b29-b86b-795d5b904a9d@kernel.org>
 <71507be5-8430-4a3d-af80-6777a421565e@linux.dev>
 <20260609115610.9a62a2dbb814bb9d5a19ac2e@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260609115610.9a62a2dbb814bb9d5a19ac2e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 63AC31C000F
X-Rspam-User: 
X-Stat-Signature: xssnzbq7gbq4e77csgtcgei849j5b57g
X-HE-Tag: 1781056339-421664
X-HE-Meta: U2FsdGVkX18V474kfEXwmy9JkF61NfOI32NqAd0dxOYJqEL3KOfWR79Qqjop4AhdyTUWbkecy4Jdj9oY7WgjxUeFc72JWnS3TW4boDdITrMxLhnE/eoHIG3L6lPb54sSQbdx8PVw+aiqnacGxJy4I5zRyPBy6H9T7hT8JX8h+Tt24Zq7jb8N2Hp9F/8Y8euGHnv04Ej7Q8UYDikct4jfGYDgI/mgSQryO6KmEEmlPXu71y+tMpJH7t1U3u1r5YtUHDM/xWz4a08yMFZpDGGYF070Cz3kySpWZFjedGSgvZrMOBnMTKTDDxhr/l6sXDp4JGi7XNX44Tm5RMWo/iDQGt0Rrba5Qz/mlO4fBsb9avOdh2ufrzbR1nOuA87o7DsaHM8gSyKDqjGZs53hgLU/9lkdsaEs//Z2AW85ZO0QMQdm2MtMOdD2hTZhLob9aOzUA53yuN5PQOdO+Lmkdj9H296FlrNsSOpA3GZOVv+OX+dzV8NLd9cwAG8AfEitApL8laA0X//WAzScQgRMNDUNWeP69cEn0I0fIyLii8KY4V93e8jLjJhYgQeNByeEa2/r5WfJ5IUyJrcv0gOUnjC5NoVw/zklPPJSP8bV7Svx7uuQtANPGYeWJWwrA26NTrMQhQROOf45hPBthvs0KtgQcm25mOEVacIE72hJklJYR1TiYngCzLr04huZZe8FpYtV2LEpOIlFtAaH3c+8OUUSsxycw8Pmq6QITyT6wWhws7896ZbExU1zIJWyA9NLfaUxFCZh+sp21drPsgPuZhMwkx7R697/pvAUDfLMLzVpGrr1OFa8fa3ZjlbtXfCQiJbt50GnuQv0uiipc9zm/9Cj9RBuDVp2LmeT6OkIcl64B+qFtJKuDRZt8k6iyibOMbEXirRUXbhMpeHyhetC0jUBJ4PKC3wqyY8LJ7L+mV0fnZZ4MEa8sFOs4y8Tr4wwSxgfo/i1fKKM8qwWM76r+FT
 RaVDY8N4
 /aktO9enSRcJX4o2wp848N1ZKCDtoIKVb+ylJa2Ctf8EdSsI2VHtVA6dlhNZHXj0F3ivLxh2678/ADtgTUuZMvkONxfjXiWgHK89DTVGAxGN3IfNnhMrsxb2qfixjyt20b/CfYCa20bfJyZFklArunqm+3Sww8IztBQoLw7eVCZdN0HTh50w4nC3P8CctHvy4RpOOl6lzKmH40528jy+m8bwP0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/10 02:56, Andrew Morton wrote:
> On Tue, 9 Jun 2026 21:56:13 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
>>>> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
>>>
>>> Right, probably we just want to add the Fixes: tag once Andrew moves the series
>>> to mm-stable?
>>
>> Yep, hopefully Andrew can add the Fixes: tag when applying this, once
>> the series lands in mm-stable.
> 
> No probs.

Thanks!

>> Should be soon, I guess :P
> 
> I move the second batch into mm-stable after Linus has merged the first
> batch, usually.

Okay, got it :)

