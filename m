Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65BC606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 13:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mgmnpsdm
Received: by kanga.kvack.org (Postfix)
	id EE1116B05B2; Sun, 22 Nov 2026 08:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E91DA6B05B3; Sun, 22 Nov 2026 08:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84106B05B4; Sun, 22 Nov 2026 08:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A451C6B05B2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 08:09:26 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4CB3A7E2B
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:09:25 +0000 (UTC)
X-FDA: 85462786290.27.45811B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 00CF0C0007
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:09:23 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mgmnpsdm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795352964;
	b=ua9y+s3Tr+hxw0g9m4wnYsake96xLQvStQlcT8dkhk/dOKmTgZ5esJxc7LE6pdSBiZOgN+
	ugB0svJm8FhRhSgProCs9yK5EkTRLJ1Ut68w+v+KLLGTDOC0p9i6xNkv/Qih4/d8D5E/lt
	izLXCdhcZ7bW69XxRI0pZZXkLz7qodk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795352964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sZ1PDNEi5E6ogIgtuYs0TfJyc0Jc2h1FjIxlhYKU2LE=;
	b=xVwYd/dSDNgeZjqW7r61StYOiMrM053ao7Hk6jcxR09j7a5y/mkqMGV+/vSX1fcBxwlJTf
	E/fOIUYk6RKXnnYQGJpVNS93LeuprJkgQ7HqJmN9I4Cj434xLpyYnIq+QnSIcfX/zKChcT
	TuB0Dsd8yg5BbnEaoEEXj5GeOTA21Ww=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Mgmnpsdm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB10840B5C;
	Sun, 22 Nov 2026 13:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA2BA1F000C6;
	Sun, 22 Nov 2026 13:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795352962;
	bh=sZ1PDNEi5E6ogIgtuYs0TfJyc0Jc2h1FjIxlhYKU2LE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MgmnpsdmpI8dKngcWDxf/i1/dekLkMZ2De7V0Wp7NwOxb/sVkZ4OePmkHiIELKEpa
	 cPWS0rtaesk1AabINYYcc3VIlO51S2kqO54ck4doH7CSVnMIpuHqfD+ZhOXSyTLcqx
	 Dq9/tVrWNsDJ3Gmgc/f2MHEZwusB+3StI9cV7w8DzC2j7Af6p8bmrq+qrCe15LlHXs
	 AQu3EG1WdODB6xNa2+hS5GtW7fM3B1YPLPEjGWhB+CKUXmhIq66pqZXFnZ/kvsk9r9
	 aYN8A/RQV9FtwKYp4ncaePyxAcmO5nsoUoaPlQIwvN2y6VWpQVTIGAiJWXDpvWW+xX
	 2lZIBaHD+02gA==
Message-ID: <aa3821a5-6459-4845-8255-00a26bf243d3@kernel.org>
Date: Sun, 22 Nov 2026 14:09:15 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net 4/4] net: skbuff: limit folio refcount when splicing
 from sockets
To: netdev-bot+sashiko@kernel.org
Cc: davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 pabeni@redhat.com, horms@kernel.org, akpm@linux-foundation.org,
 kas@kernel.org, songliubraving@fb.com, hannes@cmpxchg.org, riel@surriel.com,
 willy@infradead.org, ncardwell@google.com, kuniyu@google.com,
 pfalcato@suse.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
References: <20261118-skb_refcount_overflow-v1-4-5551b4954c3f@kernel.org>
 <179533918041.3135.8460911693239501161@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179533918041.3135.8460911693239501161@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 00CF0C0007
X-Stat-Signature: hfq96iizkabc366tshjzpxcrd3bqnhyr
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795352963-941891
X-HE-Meta: U2FsdGVkX18dhXpDv6wgGXS9rd7z3Jzlcdb/s63/rAeSA6rvYHI4kepr4R/jBUChBDcsHRqLOSs4X7JGZpI3nb0N5c1O7mb9zC5s/0imQyYei7tnVzWwNk7N1i2xOlj2eVh3jxqdB0HmISQ6CTHVOWsyA4cJUyS9qEFgPyRwKUjZIaC0bxquYy6TUNLgKVR3Atgwxdqp9h/wgdSrYBcH2+Vr4h0h3qF+14hr2Xpui82BaG7YzaaZ+dXw+h2EmejoTtDILRGiL9jZvDmgHaO4ZMMv6ZXnkfNO0gnD0QQWyei9Y9jhFakXwfB9xTvm4RL2p/wbtCX7c7Irilti5Kwh939zr6m2iacKrtFZ8XY+5Bdrn6pnemStumMRJoQWL37nKV7v2ETZq+MZeLftlJce2hYOHYA3OpobF7U9515nnFbNwwO05hH0OxsrdLHVK0Ae3Kn+iovQILlGPqliL5lXiUiqd+VYcr6rttjb6b8MpvkEoQvXHlENKP/DfDGOhARVGaFV7p+uPhjhQtzsXQDxeKRxLcilRxidN9IN2TP1mMw50k4o2Ftzi77K2WOpjJ9zjM6U9XehXyWfmq9L+ht1K0kOhlI9kk5pnSIvo1ldsbsh9oNRyX9FburJAMHLdUKe544TxUFi61xqz7HCSpDrZjwlMYnN0JUXK6quZ8Tfh7ejPe1LiBld6sgDT8GGxWzaPh8GqlD/pot37Hz3uMWx6w/mZPg7ApL68DpWXMXF0poB7V4XCSVMch/b7I5ZL+K9vXNOo/L7KLwHy0icoEKy5hX+ZyD1uSLoV2V+R+A8rxLEah2+ogE01chrvCj+oKnD5RKtgzizqA7JMreXfzrcPajKe8OdR5dc7rOtKqE+Fd4uY7YIm5u/z+XiyZoNZzpiU/hKk4SYjiNeXR2A3zHQWycYGjJ+VVu1hRgZWNR3z5fOVPBBRNL4cq6UfB45qlUfP25Crw2PAO4FaVbupQN
 vDjl2sin
 vxZrnOPKJ5CzpBDzQJw+WMUICxu02DF1U+bx0D8zba34hKFdos1vdA1fgMz2psi97od20QqIAjU8ae04T2NqmpDC+tJAMbXMoyetOIUGVkh+6mBvt/h94nMPOxkpw5oZHuwrbdVDBOrF02/efGMV1uiMo+By7KNwfhaojl27WosFGaY4glywRXtVWVSg+dL6n5WShuITakCckEg6CBQXpXvXxmheM+b3MH5ArOxj13YOXAzVN38FqCyGwUyejUaItbFse08Igx21nnB0uZL+pWd+0uXx0T0RN7bmTp0sI76qka/yXHa2QQ92KciGR6kb/VInkyAHUt8GeNr8BcXRohuMjY82y7Q4v1O/UFfzX/2oCIkuJc841/pG7iRxwuwQoh6YxeRIpDUlqfLZew+0O84V5iCgrBGb7gvSbUueNBl+ekvJxe8u2Y+jlYQrq9nDoIQtBlRWixjs6l5QhutM/2j5NKoqSeVXxhkhC51DwRN+jb+HgmN4hjQuiJqdwnXIh99oAPZP8ki68HzIbPLpgYWTtacvenInTYQ8NrxDC0x3OLbEXUfgSVUrBT1DfLgwvysK3hGvXiWD4URwbQ22NVl/XjqgOcUhdbc46EzZZW9USULMCnr9WDX8riahGdF4VVryeU5SJtWhl7bA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/22/26 10:19, netdev-bot+sashiko@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found more severe
> issue(s) in other patches of this series. This mail is only an FYI, in case
> you want to address the nit picks below when you respin.
> 
> Low priority / nit picks for your consideration:
> 
> - [Low] The new comment above skb_splice_bits()
>   (net/core/skbuff.c:3295-3300) says the function "Returns the number of…
> 
> Pre-existing issues:
> - [Medium] skb_splice_bits() still returns 0, which callers report as
>   EOF, when nothing was spliced because linear_to_page() failed to…
> 
> --
> 
> net: skbuff: limit folio refcount when splicing from sockets
> 
> This patch uses try_get_page() in spd_fill_page() so that splicing from
> sockets into pipes cannot push a folio refcount past its limit. On
> failure it returns -EFAULT, and the error is propagated as an int
> through __splice_segment() and __skb_splice_bits(). skb_splice_bits()
> returns the error when nothing was spliced, so the callers don't report
> EOF.
> 
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index c937d74eed6ac..b73fef7a1b460 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
> 
> [ ... ]
> 
>> @@ -3284,7 +3294,9 @@ static bool __skb_splice_bits(struct sk_buff *skb, struct pipe_inode_info *pipe,
>>  
>>  /*
>>   * Map data from the skb to a pipe. Should handle both the linear part,
>> - * the fragments, and the frag list.
>> + * the fragments, and the frag list. Returns the number of bytes spliced,
>> + * or an error if we could not splice anything because we could not take
>> + * a page reference.
>>   */
> 
> [Severity: Low]
> This isn't a bug, but is this return description complete?
> 
> When spd.nr_pages is non-zero, skb_splice_bits() returns whatever
> splice_to_pipe() returns. splice_to_pipe() in fs/splice.c can fail for
> reasons that have nothing to do with page references:
> 
> 	if (unlikely(!pipe->readers)) {
> 		send_sig(SIGPIPE, current, 0);
> 		ret = -EPIPE;
> 		goto out;
> 	}
> 	...
> 	if (!ret)
> 		ret = -EAGAIN;
> 
> The reverse case also exists. If linear_to_page() fails in
> spd_fill_page(), nothing gets spliced, yet skb_splice_bits() returns 0
> and not an error.
> 
> Could the comment also mention the -EPIPE and -EAGAIN cases that come
> from splice_to_pipe()?

I guess we can just make it simpler by saying

"... or an error if splicing failed."

I assume that could be fixed up when applying.

> 
>>  int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>>  		    struct pipe_inode_info *pipe, unsigned int tlen,
>> @@ -3299,14 +3311,14 @@ int skb_splice_bits(struct sk_buff *skb, struct sock *sk, unsigned int offset,
>>  		.ops = &default_pipe_buf_ops,
>>  		.spd_release = sock_spd_release,
>>  	};
>> -	int ret = 0;
>> +	int ret;
>>  
>> -	__skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>> +	ret = __skb_splice_bits(skb, pipe, &offset, &tlen, &spd, sk);
>>  
>>  	if (spd.nr_pages)
>> -		ret = splice_to_pipe(pipe, &spd);
>> -
>> -	return ret;
>> +		return splice_to_pipe(pipe, &spd);
>> +	/* Returning 0 would make callers report EOF. */
>> +	return ret < 0 ? ret : 0;
> 
> [Severity: Medium]
> This is a pre-existing issue, not one introduced by this patch. Can the
> spurious EOF that this new comment describes still happen when
> linear_to_page() fails?

Sounds like something for net people to investigate.

-- 
Cheers,

David

