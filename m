Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4FAC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3200D6B0088; Wed, 26 Aug 2026 06:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D02F6B008A; Wed, 26 Aug 2026 06:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C23D6B008C; Wed, 26 Aug 2026 06:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E77E56B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:09:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30D0CC02EB
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:09:40 +0000 (UTC)
X-FDA: 85142998920.27.C420BC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5149680003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:09:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dgWjg/0p";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787738978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hvGeuL2AdxY3HOtlp2N3o5FYKt1GwAyxJ9jNdIRnF7I=;
	b=VhJ0Htp48WTGCqadBPcGUFngH3ROM9eALfbwXLBjvxu2cQbNm4BINxyl51o+PtLdjwU1Nt
	Y1kS1iTkL2T0iW3yL9+rtoOWIOxjh5kX2JtNX+k7GjK1fUYSSTs4T/BudTF4Rl95JneQkD
	EwBqdF+yBKO41zDcPr5CxrmidfzVlZ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787738978;
	b=jjSO8HAhjSUAHrU7gzM3W2golNQTP1pxQ5G1jOWmnC3ley+umWLKziNN0o6tpuAiD0i1gp
	dm0tYxKDShavfKmiHUldpN/EQL40x6ozP5BDNXgK0Ki57EBmiiksOEzvJjFh5UgeCZunEi
	73wji+tVD2mQBzENN/APxWQkxvexN2M=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dgWjg/0p";
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6086E600C4;
	Wed, 26 Aug 2026 10:09:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A08EA1F000E9;
	Wed, 26 Aug 2026 10:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787738977;
	bh=hvGeuL2AdxY3HOtlp2N3o5FYKt1GwAyxJ9jNdIRnF7I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dgWjg/0ptmEWNJXUn9+xHM4N7Caxh8OkQJjBM5M2NsqI/B7IGoouVWEYlvJQxTj50
	 PXg0WYgW9P8hZELE3j/YLaJAJD4Jz8g7pzOdDBKx3ZahhpHfxoxjq7LOGd1rZ5quLb
	 1HXKQ/MsFM4xUFVuO5OfSveSdtCDzgNJKghMRVTVBOzLo6LcmL29KUUqC3ExOGFHqj
	 fPAicVuax6Lp9iLlxf0RjLTbiE4HmuNujOen+jLifWozqJ2HSnL4iC36Rmj5+L+ilP
	 lhV7TNj0KILZnA1buNsuPJsprz/jV23pg+xOBnyAhzMoPbkshqky1IY120I2D3BWAd
	 UddE1aiTx1YSg==
Message-ID: <6293dc55-e69f-498c-8290-b85202db605e@kernel.org>
Date: Wed, 26 Aug 2026 12:09:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5149680003
X-Stat-Signature: skksamj3y6po4rynf4cfrhahqmumrn3f
X-HE-Tag: 1787738978-438414
X-HE-Meta: U2FsdGVkX18muHfJndK9KN2MPO9t88Vm0QqJwWMJnn9wuWfxoI5jWZqrNMOz5SG6n05KU4KeGfeuLeRJLgWgpnfoEFKqlew9/2X1+Pz76AVqEJ0RmpCRfCBwW9T9p1NCHAYKRf7twCz04WMQeX4oady2MDuJ9LfhBJ5q1Y+X1Rj10Z8C9gVcMHLG6T3EeUnr+AFWMvc8ON912YBtpTab3OzgxdYhn8OsushIq1kdPhjkYXt4EZRIbcETI9Te9oPRksN3MB0UWCjhyxxDE4hk9L1OXza2MoGBVHQpOy7nJiZiP/mjRdicZScJ51ssueTTyoQ7u0GXO2mBYOV87FckKT8HioCeBlg5h82csh4dcJqNxj1oAEukTtHEKljQX0kkIO2oXbj3lhu2E4haUpQuEyMkWVxQQKtLzWbykU7QZPW/LRLzXR4dLiDCga7MEkY29aTo9v49RyVv0gWLsnNoHT5YuJdpRZadAunYZAAQI3TOJcaHqwm/k312pM5tLaCFd7J2j+Mp8wmJk7PD+z/zU+le0SbcGt5NOKMRKl+4u4lbP/5n7apa6uaS3ZLw3SSeRsSzyfCSCBv9d59Xo1DiScDstkX3lO4vjNLC1m6A57AVZd4wnJqPgaiZ87/I4NdymOzTInN0q6zpL9CY98e+eMZltu37V4ZFETEYB/dFgEvKnPBtgxZin5gJH8bol70miJ/cB8CfibybXJmPieENCnk79GFkyBYdo+z3SyacvulMxsh6fy3IhdRv8F5ERsC6Pt1eMC31+2f9snVNTBYG0tpZkU2q6LR3UJLmQ0g96oaVcEdwIeaSTOCEDW7kIBER6Lo2BPd4aTzMKB1bMaChX/2MM2zNO+oBNhOyPNgV/Cg7i5H9etEhnSDfTaTUHgC1ZLQszUS8hO89xsEbF1lT78Lo/t4Tx5Rn9qHQ9PA18D9Jpg+45tlZjDAArve2BkbWPC/WeiS6KmfoX/kANXl
 IeULjd+H
 DFVvXPtupQUzc5XjUGO661TOOpZUO1GNE5mCcJwJat904396e6hGwt+lxIF6kOApHa273paykaLE3jItWcVNOR6Q8lGpD3kJi8IzSDutLEnVMRP4OMeiNyIsTUzI+c1Y+8G70P5TMuX4WG/RanjWx+XJ/OSaradBU8JYkYMszAgsHfq/0m5dCT5DO0fGa3a9YAKkZebEVv8smVZxvNTf/RdVMCyb8Sdg/wswV3fkhIsBjc2jO4JtbS3YoB/9XKcrtnlwP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 11:56, Lorenzo Stoakes (ARM) wrote:
> Unfortunately my workload is such that I simply no longer have the time to
> give THP the focus that it deserves.

THP is, unfortunately, one of the busiest MM components, and also the ones where
we have to deal with significant legacy code, many suboptimal past design
decisions ... and plenty of ideas for improvements that require constant
pushback to not make the situation even worse. The time spent on discussions
alone is massive.

Fortunately we have a growing list of reviewers.

It's mostly thankless work, really; but I'd like to express my sincere gratitude
for all the work you put into co-maintaing THP over (/me checks MAINTAINERS)
more than 1 year!
> 
> So, at least temporarily, step down from the role.
> 

I'm sorry but I can't let you go entirely ;) I'll make sure to CC you on patches
that need your feedback!

Thanks again, Lorenzo!

-- 
Cheers,

David

