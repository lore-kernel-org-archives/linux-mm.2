Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9959CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 07:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6D696B0088; Thu, 15 Oct 2026 03:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1EA96B008A; Thu, 15 Oct 2026 03:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35676B008C; Thu, 15 Oct 2026 03:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CEF6B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:16:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BBD8A86DF
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:16:43 +0000 (UTC)
X-FDA: 85324003086.11.0FD1581
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5ECD9140006
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 07:16:41 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBMKeyWm;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792048601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=euYFuk3tP5sJN9EaHHzoJWao/11EtLBrMeC+h7+T5vs=;
	b=YijmLa6NVd73uBFpbj3JCp7y2dm1q4P4ynIXmL5zdtUIaYety3y4W8N/bDZQvkRaaY9YNu
	wBXqFmb2FHz9J0eVrP8ed4xnNzLeYsxLxN13QRrGZ4J/xCIHt60I5//8t8fQvWgjc5cNxI
	UQRhAzOmvl9dyGSPTYXKl4lzfOFTztk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cBMKeyWm;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792048601;
	b=Lw1Sq58U89PMU4bplNy8Y4ANgHTTaYbTP9l5C0zJ2aqMK1nMD2fe5BUTv3r5wEtoHTd8DH
	aptzxY98IlhZUZ+lEQP7mgc9EuWJ7cV26Kuit7Rd8RpaPJcQDxOnhWngBD56IU3vaVRMRq
	TPrbaJxOvfQqhXFelSnAy0bNSY0E+fI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9C70842A41;
	Thu, 15 Oct 2026 07:16:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB1391F000C5;
	Thu, 15 Oct 2026 07:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792048600;
	bh=euYFuk3tP5sJN9EaHHzoJWao/11EtLBrMeC+h7+T5vs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cBMKeyWmFtWpau6jvr11dMaY3e3aYX4jzKH/+n1L2gFQyuLmSv6pojwA3moF4g11Q
	 6/wFvXQr+iwAzDSzRwAh2NYKTZ9JNvePA1Tnhvsj1vlfH4E4XIlUE/PPSByvLtPJlf
	 WTLf1K+o5joquvDM49alwv7sD3GhwkuTivPCrSO4fcJdqLgcqWYTOrHVh3UR0XlT5l
	 oi+ixDu7leIw91Dp6AV7KkxNWdpOjJr666PokXcD1u9ypGPkX2/kEWwmZZDNF80m91
	 DOfUO13f4gEmcA1FbHmOPzFEyuSvMREv8EM+sRMRm/2zTnSCkk572/wjXZcGv48+ye
	 RtupIktQS4F9w==
Message-ID: <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
Date: Thu, 15 Oct 2026 09:16:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation> <20261014202936.GC371161@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261014202936.GC371161@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5ECD9140006
X-Stat-Signature: notfi5owxuyiciiwk8s5e9889878pqob
X-HE-Tag: 1792048601-617815
X-HE-Meta: U2FsdGVkX19rFS9ZbTPMORYbqp0TtvZaef3GTkPDik7B4j81kItjH+Bs4I+CQZF4ysnFTFqesHDSCtSXtKbgUpTzEEKxCZ/GujkuFb2foO7h2kXvV8eOC3f5L5ojCQ0ipOPWLENy9wUuesLjjS+aDRCuMavwF/snlslA5LF9PooYyBL9XR47bz4d6FJc1l3WdN/VUr4MUWNoH1g470jQJWabFL5mVUiZxnaEwuwYtEVk+kxZEiOUXZUl3tic+KF6EKHdarJVbC+XctdtEfjY5wY1TWaqUetwt6lpsswfBPmP5mmw0z4fx9QjsvKUOxMw5eCMwf0g8RZg/Lch2yFcqibVmbd2ImIiMaZMdy/SGmZTGxQcc1R50BJI6o7gtfMeQfKWhhe0zFHtyt0S7/nCSSMNpW4p4KJ4lTMrJqtCLJga1NXi/OYdfs+sz6B0b30Q0HXjVJ9q9stCxa0JdOOcSS8JZncrEE71AIU2j8wFNyTJGMMaVIFDAC4bvkq/Qt8qVgNFwyWJNmaXgDnj4/2o2MysIKFPiowFfRGxHLXthh+E08YHauvSL52W+aXQhcGUPzR0N8+o+/VbulVOCwXNiBsL41yPxU27CaCiY5vGqIgW1tPo8YBVi0luu5J6ESIUoYPUt8l1boK7I1ZJnPTMtu6bCjzTKx2OD8YXomj4aNuqQArxYY8cEjjon0Bwq6NNUJCGPQiaT5GN6IM954OmeYWdRXGUqLoWTOi15P6Hpon9ICtH+BH5ciBCy1m36LUtAzdF5oZBJ+Ilv5psRod34yNHLoD01gbJIUOrSvsydjt+EF4/47Ls62YBH14mN4NYa5uZw5Qlwp1YnOipSR5WHd44ae/4K3sH5HeJBsCykWN77C6frD/S7Mp/+pcBaU0Qm/YMPbBKm41s7snj9a5hsExBUZ8S5B2a7Dr1uuHCc5gZgzlpTW3OTL7JH44TFxWHhJG8PBmkCkBZwxrSXrc
 z0Jv4Lln
 4xZ4vRsAYvVz81nrNzccqd8u6ziYnXR1tfuRQsPMAz4ZuyjKtJd4IasEOR4LObHT1kpN5chU5pVfXka9egI1fX5fSzixnvQxfIMOdcrjd7EyY6DVm4VCev+2EofW6DOO3lj8DToKZzsQMNXxrvDFPAAvmGJaPEWs6c0B6dkOePoZlnbWn1dw3Q4a52OUCyDZajouJFsf7R5KSkGB/8AJIQHo+pk7Fs7chGaQKwQe34Z3NkGhKGHmmaETdJ8Cf0vOBkkGBPvN8xIs09rZjxf/Sl9kEYYZPULNQH3h/vfE3wezmWrCINBicOlj27WmhFuaFnkAvLsB3ZxKnBt2A/7UtY+Eigs4NEnsbhGadGa504tDHq4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 22:29, Johannes Weiner wrote:
> On Tue, Oct 13, 2026 at 06:37:20PM +0100, Kiryl Shutsemau wrote:
>> @@ -4127,6 +4127,12 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
>>  	return page;
>>  }
>>  
>> +static inline bool order_nofrag_promoted(unsigned int order,
>> +					 const struct alloc_context *ac)
>> +{
>> +	return ac->reclaim_compact_order != order;
>> +}
> 
> order_defrag_promoted?

No strong preference.
> Otherwise looks good to me!
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
> but Meta is using the feature right now.

I thought it was there for a long time but it was only added in 2025 :) At
least the enterprise world is slow to adopt things, AFAICS.

