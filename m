Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E4D4C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 09:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC9A96B009D; Thu, 17 Sep 2026 05:50:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E79E46B009E; Thu, 17 Sep 2026 05:50:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42AE6B009F; Thu, 17 Sep 2026 05:50:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7DF86B009D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:50:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E177A14029E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:50:00 +0000 (UTC)
X-FDA: 85222782960.29.335FEB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1A29080003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:49:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddAunACc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789638599;
	b=O7a8QqNTDMm8seaUuuQcwu6V+MOgvgRD0YSkEUAo6EIX352+4Vrk/+gJMk2NJIcEv4xVfI
	3qQwDNvjVFSQuHtmO+yeYO6K9d18E1hxzHLsSdRgjN2CTsKG2GvcrrjrekeUfXVfLcCX5Z
	Y7zrKfoT+pHsV+Lr1EckPl1kQ1qDKxI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ddAunACc;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789638599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vSU+xrAEcsvkHu26lr1G4pEJ8rlPYCT7TOEWzjoc1DQ=;
	b=IkLOOxKJTJlNyHsxv2tHTAkyauTyEipBLVD/7/cye5xkjcdgwe1oZTaN8Uu72FRpKWtzAP
	+rwJlwqGT9V2fVAdUVvLfItJGmCKXSrA59o8njOxGe84NVtei3q7eBpR06LhjN9Le2lWOA
	qYfO4HXh3k4MdEYp7QpYI8MZzeXTYus=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EFAE416DA;
	Thu, 17 Sep 2026 09:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C411F000FF;
	Thu, 17 Sep 2026 09:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789638598;
	bh=vSU+xrAEcsvkHu26lr1G4pEJ8rlPYCT7TOEWzjoc1DQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ddAunACcGySEBxWygGGBQBOZW5Kc9y9fwixAr9AgU4hqTclBfnONuRYqSKoyfYk0m
	 3pZboHgJIlAY4irh8yRMsCcdYPYen+IGMChqimfTE1u5zGBOGIejfZBJSR+gnChYGm
	 6iCXlEWzDGX2UACyLmMePk1m61Vs9ABpZMBL6MvxFje0oUPHy4InNf+E7BBdXrkRzy
	 ONQZ4tWJO/zZsl/JEIAxSFQKoNEAM7JiD0oKrwMNCQAVzr0rqyjLY0mNY23TLcWqS+
	 P7+WShn0xdG+PeZKjmbKiKqydX/1jLD58t+SOBYr5srCMSoBLfLV9gDXpWzLCZDtuR
	 dFKk13Yg8SgtA==
Message-ID: <7eb8f4c0-6e14-4f91-a3b9-77e82f76ed00@kernel.org>
Date: Thu, 17 Sep 2026 11:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/mempolicy: stop copying the nodemask in the
 interleave paths
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, urezki@gmail.com,
 chenwandun@huawei.com
References: <20260829015943.1258774-1-gourry@gourry.net>
 <20260829015943.1258774-3-gourry@gourry.net>
 <d7f162eb-4214-456c-9d1b-a8623da61b45@kernel.org>
 <aqq_yv-cQvzuxr5D@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqq_yv-cQvzuxr5D@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1A29080003
X-Stat-Signature: 3f5dkfsnnfzbgry576fg61wdhker9r78
X-HE-Tag: 1789638598-44150
X-HE-Meta: U2FsdGVkX1/u/3NVi7AjqFcbLgClMaTpII0nan1L43x16FqHxY1bxTBnXbttg6+66rHMnd3zQhbkN9wMnv66cbJfWQTWkm4MFvKTwr4xwBz5ZQMiOeBt9gPCxpIRjpXuVfcPg8TWSRTXXuyXPLCbANJkA6pXV7xsnkGmqogdqI893/gXxim3gM0qNnANySMzNToPfwYPn407tMzCo+H02p6+Inhpe1PoNGw+yRNhYV42zNsnHCfuhJyo2/eEeOYvxNFOnnrZaElPU5+nw0UWKlO+KGKKfzaNWeGMWZAOIVpxluortMNXj2aaWnCsSNpo6/3hnUHYFBEbMLfgxGOVNXhw4U2n0nUAtlURJL9MJ12Krs/zNA8bUF1Mh0DtjhTGKDCoKbayCgAJuUDCSP106XFN/r0Lu0eTcNr/s8O9ocmyYgDRC6//brc76yBxMK4kImhDcWDvkb0ws3P8/HE3JAEnvnSDE3kHB1XpfiMOTryPFYkir1sUxisn44df9yENxF8Xv31cyBW4+denSGcREZYfHwd03yq3ZePXo8JQTrmqJwRNkDmfSWi1f3c+OyXSoH2pKsW6Og/H4I7geCtS7mjVa3aAHOx6J/6IYoapw5l6+3LBkj2wBrEr7xj7GVRzwW1aqjrg1vIatxdRD3XhnEhayRwuGu5deLnD9S4TZzNNIvDq9vYwiKAHHxgnFQREpPsspOv4fuT9Ny/w+mY4a+B6YxYU7nlaxXZPMJF/w/dZuoxw71AkOcDomtfUOm8wzK3TLXcNe1HRMgFFOXCSzNh/Uc3NSQfYoQi10sPxCgtiTxkIvEfzGCuLqvgnmET/r2UgkLAVn05FsvXROPT4jit4u6rzXEU6VM7LVoPeKqYC14+TVF9uFWlZSTSlIQXrgqc7xVzmbRb8L/0GgkQwBzf/ZkF9kUM/ViWr/sQZ3ghalJKd+g3QX/S0BmMFhikS/lS9WlUC6XKyexvtI1f
 wP/0oOhr
 Yt7dqYuh7ZnrpzkDViikIgkiuHOLrHLn5GfPvZ/eI6WT2jfwp6nTCUsQWUrSKGZ/NaUw0oXl3FoRBYNjwQjpt8N9bZai/Z53DKbFxJb0xqEoDJyBgU+pR/Plgxjy8G75vDfvBa9aSyl9MWsnrljaODt6StZKAmupm7R3IamY0RoSYCnLROL508dXQNagvb0ooWbwiSd+TmASOrHBGegWew5/Stwot2pbs1yyB3rfzP8ZHpKT3M/qRD/HZBRZAS9rPs/3C23dOeKHi2Q8njXPb47DvCGXVI9+ROdEm/PpqJq4xRZ3aCUffw5FFG0GhGfhnvpgt+s9oK3usS3UsI9Q3Gti5wA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 18:27, Gregory Price wrote:
> On Wed, Sep 16, 2026 at 05:57:22PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/29/26 03:59, Gregory Price wrote:
>>> The interleave node selectors copy pol->nodes onto the stack so the mask
>>> cannot change while they walk it.  nodemask_t is 128 bytes at
>>> MAX_NUMNODES=1024, and two of the three run per folio fault.
>>>
>>> The copy only buys consistency between the node count and the walk.
>>> Drop the consistency and just bounds check the walk instead.
>>
>> I think you should document here that accessing the node bitnmap is safe (is RCU
>> responsible for that? I think yes), but it can get updated concurrently.
>>
> 
> Actually, not quite.
> 
> RCU stabilizes the weights and makes accessing them safe. RCU doesn't
> help us with the node bitmasks themselves (we were using a cpuset cookie
> to stabilize them to take a copy - but we're killin that here).

Ah, my memory comes back. So confusing.

> 
> What makes it safe is that we detect the torn read condition (check for
> an empty nodemask) and otherwise don't care about weight skews in the
> weighted variant.
> 
> I think it's reasonable to add a couple comments to spell out.
> 
> Are you ok if I just spin an additional commit to tack on rather than
> spin a new version just for comments?

A resend is probably easiest when modifying the commit message.

For adding more code comments an inline patch we can squash is also good enough.

(I prefer a resend because that shows the full clean picture, but without actual
code changes I don't care that much)

-- 
Cheers,

David

