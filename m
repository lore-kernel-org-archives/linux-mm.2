Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9260606A32E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 21:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A6qyhCG/
Received: by kanga.kvack.org (Postfix)
	id C768D6B05B0; Fri,  6 Nov 2026 16:35:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27416B05B1; Fri,  6 Nov 2026 16:35:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B15F66B05B2; Fri,  6 Nov 2026 16:35:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80FB76B05B0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:35:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6DEC6120211
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:35:55 +0000 (UTC)
X-FDA: 85406001870.19.FF8A1D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 93A9C40002
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:35:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A6qyhCG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794000953;
	b=EAm8gWoOilHA5w0FGXIvpkqTNkKqZOKTc5QwZAnZsJDqOQu6HoJMTe0+c0/JpFRW8kNTSb
	e8Iln3HLRuF8+ZF4QmHqVtBM3eLpvolf8oXz5JCp1H2nLzbdAD80k6MYZXeTO8slL0nJoS
	oFI+tvppDqV/ZAXumgalkoQV/kel+6o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794000953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rYnfjTO0OAhweeK3inKlz/446I3/Ji3WoB081VDE/44=;
	b=mXaafgylDh1lpTq8hwQjOpIXmOf1qYOeEQH7TQusWE6px5Zm2URmqzAHv+LMTNoXg/h3Rj
	K1np7VqoTgra8ahkCRilnckzZNwlMtrB6azu4b9gsflKScZb9f2+yX/ACKHmShFP/Tp8FM
	4ocVM7anpOO+FTNnUtwDqS9+TwudhX0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="A6qyhCG/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B3AF42ADD;
	Fri,  6 Nov 2026 21:35:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E431F008A1;
	Fri,  6 Nov 2026 21:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794000952;
	bh=rYnfjTO0OAhweeK3inKlz/446I3/Ji3WoB081VDE/44=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A6qyhCG/KdWOvj4q+ZK6f4kV4R64uRTBY99kC8F0KbOatyXOMJn9X8u9S476rQVNx
	 ZShC1akFpy8S3TTfqiebrOKNDPwA4wyC5OlvWrDqlRMGDLUMtGyON+bEJ3u8/n4TBO
	 GI/AXXiOrczOU2yGktF8ay427kx4vkShfnfgqdbVSQM/wC4u6Dsjvh/cXaTbw4vj17
	 bzcaxgLlHwqhEOa/lWalVy5VvknAGGaoasgJIVyTJo/0LuPxLfWumC50YHOpWCtzeO
	 ZpcoM4yLWrmI9Wr3K9LGNmaWzELxPH4mHsmq1SrC7E3NM354GfbpHQsSeWG9QeFlEp
	 rHYgP+pmxB0zw==
Message-ID: <8fdcef66-3130-4c90-aecb-050ae624f42c@kernel.org>
Date: Fri, 6 Nov 2026 22:32:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
To: Sasha Levin <sashal@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261105171801.2189772-1-sashal@kernel.org>
 <179397467526.9397.17872200045070830000.b4-ty@b4>
 <20261106185218.1766376-1-sashal@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106185218.1766376-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 93A9C40002
X-Stat-Signature: f16qfnibgp8fjfec4nqqbxxypxbpcmy8
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794000953-602900
X-HE-Meta: U2FsdGVkX19CXn1bq8CQCJ0kfmjy66gGnB/SH3rSHzRmv56iOqvcO+JWpMxlXJAn/xg8DkGpFdaQXRp909fDjila0eQjPs0cN8A0ROOS7V/Irnoxc+oVGjlx86LqkHYLfL1Zpez1rU7B1+sTUeAkFpXFZe7R3wCfSKeRuzI7D7dgBkHAEpvSIGuTJeIlvaYXbjWum/6NbNiwQ+HE+f3EcKD0LToTmrt00kXrAtWinuUs7nYXshnWCNkUEsMl31QC+P56RAvbjm3wr/oy1LXZy8UktNoFar2tLYUSYFWj6BJqqzGST7+/L4FRLqNb+dzy9n2CEgkSFx+q/Z1M8uJJNhYiU1vfkzMXiN3N25u67xbjU1NTapMMUb7hpT0dLjdcJWSUL8mXQQh7megO66iAnAWpneiXnTsi4EGPphr9CRkYeODlHbyP4EeR92oaRRRMIn7jh+Nxm4B0WHu2mkz6Be3XPN0tywJyeIuoq1Fh5wodwshLR5vxgN5VulBplZ/jtrYNHPlZN8nCyjSHZqwYmUFg1vChdUsFNb2AeJii8Rgkt/4K6y/kn2K4AwEJT4/YfbpZdZcbyL/SKWDo0ZFuuldiP614RoXY3EbZZqh0VQDdWDsYBPfKDwWdmZcmtH4vjPnK4TwSVO6PjSwRneFYFLYJAJ6AdEK6BysVKCCWg2a9qRVyQKaXzIGoQuT6SrCQddAfyzvi0vQ+tpCmt/Crs51BaDLJa+kk7UVo6LHB9v8gspV0NOAHrOSZqYtxI025nVC6lLTXtfqd7orjqZqTzRyQP4AKwHt4jltMMYmJWN6DLaY4qPFf8h2TfHMKpGyNOx9PmU1Y3Ri5YOrzSLE16he3awK9Jh7jIOpl+lzhKQhJ829bhpi9i+KoB6+adWzmquoY1vKTZlLiMXXcLTqcIbF5wpJ6tXUOlLh14dfnOI7+QdqPomMdVilsmlRNC/FHWudPufCZBNaAKbaXkNr
 3jLvo142
 Vs2Mlx3pxWWEuHpsltDcxOsf1h8ZRrBVF/K+eILdhnG5JUkbkBUp0XWZXrCwvX6/QycDtsLaR3QG5g7PPOZYerEVR6+RKHjY+ZO4wcEXvAiR4pvpzsgPXvCvzl2NbqAJkbso824jFsJQAeG8KKmdbWUL0FQmyhxudO6MW9Sz6XJIG0zUvqXCH+bILnPwXzrYUAlLgrWI88h07AIBsknvVIA8AoZBxQ6rVnnjxcnuteJkVrQL4JvzgM43yN15XJnCDMBJCLojbhjB2V4Vqi9nudwN3u3/6xVCBdqfkLFleIGSTvMGfxPNMdFhJ+NwvlRev4QsAbXbTGyTNNWVgvPdPmHoeqKtpCfrCNadB0lS3W6d225iH43OwMl0BQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 19:52, Sasha Levin wrote:
> On Fri, 06 Nov 2026 15:17:55 +0100, David Hildenbrand wrote:
>> [1/1] selftests/mm: add CONFIG_DEBUG_FS to the config fragment
>>      https://git.kernel.org/mm/core/c/31ea5515
> 
> Thanks! It looks like this one landed on both thp-7.5.misc and
> core-7.5.misc:
> 
>   31ea5515bf59 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
>   194b63198811 ("selftests/mm: add CONFIG_DEBUG_FS to the config fragment")
> 
> Was the thp-7.5.misc one meant to be the split_huge_page_test skip patch?
> 
>   https://lore.kernel.org/all/20261105030242.1241448-1-sashal@kernel.org/

Fixes.

b4 shazam gets confused when patches are sent in reply to patches.

Which is why we shouldn't do it ;)

-- 
Cheers,

David

