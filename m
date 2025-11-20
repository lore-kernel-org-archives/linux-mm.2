Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76979CF8540
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 06:07:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C125E6B0011; Thu, 20 Nov 2025 01:07:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA4C6B0022; Thu, 20 Nov 2025 01:07:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4E086B002B; Thu, 20 Nov 2025 01:07:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5F596B0011
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 01:07:32 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6DA3C160742
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:07:32 +0000 (UTC)
X-FDA: 84129953544.30.5EC6585
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F9AA100019
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 06:07:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z4UnWF2l;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763618850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+adqPRtuRy06LhWm23J9UDBt68o9Fdy/99QuV8jd99s=;
	b=wmG77ywcKOwIIr6B5jqVOrGdHVcIjcTonxCt3LtwmBwemlFJMf4JuPL79X6rdPGF5AiO8V
	j8HOhXNNu+6mbWNL98z3VFeHjFbB6kChReik9F+rdSf4ouzADEejfir1uBcTp+pdt+1aNc
	sW+zFylBLMrgWatG0JoRJsQY8hwCGhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763618850; a=rsa-sha256;
	cv=none;
	b=PGaHx8FXgj0bGHcHCm8C/3HQ2n1Qp/SJtAPyaf+uMFAxsTo/gnL5PAev+xeNZGUSBpvAmJ
	smv4qMd405F6GrHSaW/VvbgbVXdr9faCEEiDOFNSHdVPpoETSdTxNvsZoy7lYQFFVZ2M7c
	mvfXlyl7bLxevikDCNjTEksGIDClcvA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Z4UnWF2l;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763618846; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+adqPRtuRy06LhWm23J9UDBt68o9Fdy/99QuV8jd99s=;
	b=Z4UnWF2lOUH91O3vYshkdRBXZVL+Kt5HhMC/YfpLAkckwn57nl7cJPavQkQUh3e/KX++pOqu2TnsUmZxyS5sSVek9LETPLZONTGTr7d0+0NE6lPg5d4xLtZKHdtXXT15DTEkm0MpzagEi0eoG7JBF7AXXhui0NlhZJn0sLnbt8I=
Received: from 30.74.144.115(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WssFsdR_1763618844 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 20 Nov 2025 14:07:25 +0800
Message-ID: <128d64e1-6a7a-419f-928d-c8681ba8f2f3@linux.alibaba.com>
Date: Thu, 20 Nov 2025 14:07:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/huge_memory: fix NULL pointer deference when
 splitting folio
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20251119235302.24773-1-richard.weiyang@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251119235302.24773-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F9AA100019
X-Stat-Signature: 3psjwynips93g1kf7hhk3chj5dwceyzf
X-HE-Tag: 1763618848-564456
X-HE-Meta: U2FsdGVkX1+hyf5ptUjpO4Cmz4qtcNLoy5mKoxVyQunYSIXfGQ3AO0StKYkNQQp/pJerw59nUuCU88uQWjoUn9MSrZdxm4PDo/NijQ9NVOT9a8q2qfOcbUc0EgtNlKBvEQ2JZL63m4EBViN6K/EebpXa1qN2xBAeSyYgDhiMCqYmVkuYpqueLmO3e44+qfZpBQcc66XvolTCcU77srs65mUIV5d0vw3LYSSxQPpHeUcSthvkfM6hhOAgazgHsYpLtBwI1fX6ef/l0KyoxheMsve4zKrTeTJveFeics8uKY4HkxJtB2b3t+DvmAN6DkI3+q0OTlW9cM8InCLMWmgc8FY3MuVcCnNcNS8i1sPCkrS/FrZFiYX0Tf2aR7N7OD3/P68gKW0kkjAevtoMi6kCxOPowoSilh+YHMqqEuuFOfxrZ9AG51mD7y+Odh2iKLyuFwcJAMmSBUA/hx7YxM2hv0xh/6oeH4UEeMhJemqNMLKEYcum7VgpimhlHkLhKJBpfVfMnzjsms6r5uCCOpUjPSKtd9zZP4C9XMbWsWcP6HFAA+pKbpfJcpEtUSE2GdOFwws4zZdjvr5odrf5KfhaKZVlA2cPokvq9ZtbrTGkCiDJwUR/PUKsYVYeHW3SsG2Ii+wODKX2AVy/zmGmOd/KcofuIkH/ECzCyxnBx7f+V9tDK3Kajy92i5OVscmhT3V5GVeRysStcgkqBI5ylNdM1LUup/IZB4CkoAKRyX3CcFtHkCtEgw2GzapxLhBMf26KsnEklwx/mK55f98kFpXkCLAV5a1hReJ1fTRMVSsmY8fZFhidC2ooQlAEjdi/98FNVDxd183X4v4Dkyoa/2chwA1s5ZByhALUyiFtY5+2gtUOXghfB71GvAdWgLZc/zWeAfuyAsKSfxEgfXZYi1G+coF21h9484/x1YeCAZZBMqMQ8uWQI6F45QnxgowBQNqBfacRUiFhku+UpqtAItf
 oG60ZVWJ
 yktAIHAdCAb8kX1GW9HvDKlXGZUaSkvjFJXUEdRpEg7qfNqYIaTwdOm2IU6wJfkL/3aYMec+UYmfddVn11lXZUpeeZG6oNpSfe0f+GMpZ+Wa2AgQcflhaf2/GnpKhREEapehx3/et6NfeSeaer49T/Y5vB1DVTt79Kkgup+79vFHhVcMa+hcxtUB2z8LG+F61GfUsjnmG6Qtrn57FWOidXr6BO5f6lbJP2qpLD0oZ8snIxzGgEQ9FP0THX2+W6h0SEB6ZoK1iS97rxLn7RZwJZjwTA05WwzhljViU0z1FNqYzS0GZmJL6/K1YcjHDNbZSyRmBQpd8vwmM9r1yXKmFAEhRxV9sdLpVD1L+td7Ha2xHGIvkLi0aUNMyhbD+KL0Op3IU2EaJOcLM16lYyoeCtyG3oDP6XjuxYMIm+G/ir4cQqyeNtnY0u7XSXcH7RVPArCpwPXIWYe+j8o+iANv8zo04KJ8wdJJPN/HjGRIImnTF4WysqiaN3yPGp9AZ1Jgd0dYa6payF00KVKWc1FCupl+kel6k5otOWIih
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/11/20 07:53, Wei Yang wrote:
> Commit c010d47f107f ("mm: thp: split huge page to any lower order
> pages") introduced an early check on the folio's order via
> mapping->flags before proceeding with the split work.
> 
> This check introduced a bug: for shmem folios in the swap cache and
> truncated folios, the mapping pointer can be NULL. Accessing
> mapping->flags in this state leads directly to a NULL pointer
> dereference.
> 
> This commit fixes the issue by moving the check for mapping != NULL
> before any attempt to access mapping->flags.
> 
> Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> Cc: <stable@vger.kernel.org>
> 
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

