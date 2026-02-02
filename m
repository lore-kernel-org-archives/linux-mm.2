Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F5CE7314A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 09:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B71D6B0089; Mon,  2 Feb 2026 04:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68F166B008C; Mon,  2 Feb 2026 04:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592836B0092; Mon,  2 Feb 2026 04:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4812B6B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:09:45 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F059F140B32
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:09:44 +0000 (UTC)
X-FDA: 84398943888.15.68398BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3F6F5180009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 09:09:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h2Jlry/o";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770023383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y34vlxSNSXkMqi3b2+JMXqTHLOgE0Q9zF32I92J1OJY=;
	b=FAWtyEw06ZGrXixLSCtfSoV6a9JtW0bHITm5FfECAFdtODE+9PtWezlvWt6PA5Gt9wa7la
	sQYWFgw9I1Yqz0vOzP3EZQnxg2ZEB/OfQ5Wssk1G0FYJj4nGKSK7nPXX0yLWoKl0YulZBu
	XcmXOk+vJQoKHzNzNwHlsCeiQb4bKC4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="h2Jlry/o";
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770023383; a=rsa-sha256;
	cv=none;
	b=1ie5mYYbIIvGMYiYhpvp/AfL/4XU6fg5WiithlxtzEfAwrUDofX+WeeDg4T9Cdga9hAneC
	SA1hod40EU1/4U+y66x5KoQyW2aFd/dsXRd11XEgT1RGTAA3WSOxybujiex0GmZM7T3YHl
	UzfBzgco3cSjvtoHPgtoalmkk4HA1xo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84B9360008;
	Mon,  2 Feb 2026 09:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B39C116D0;
	Mon,  2 Feb 2026 09:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770023382;
	bh=tzRWv83z8SL/77gP46NHWBt2YcXJqWX7YiNGdoNtyAU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h2Jlry/ohP8dzQOZoHxsJtmBk0XdTeScDtlbSXxXpInJ5t90c+siTOJcF74sg66cn
	 2+bvOFA8THcQzmzmmqFzIoJOHTjWQzadFrmNjUrZcDFZgnoarAkxaF8zAhV/t6RdjL
	 lYdsnwCHuSrXhmpsHvEsvbkZzbEywLaHP7oGCC2zv3mgCbX7b2XNYkH0OKXrzAFusj
	 RuZDsksdZAEqKoX4hYVePddWRENNczyyA5+fYtDfX2xmnJf4Q4Zt0i06GMB4HPT82G
	 p910uUpPYs7dSd0IgHwa/Aj+KzCrO25w1CwEnTL0t3ctOcWNzvnzROj2M9bCxpfMfm
	 eY/VDWSUskusQ==
Message-ID: <32968e10-a29e-4b9f-b68c-529ffd8c6132@kernel.org>
Date: Mon, 2 Feb 2026 10:09:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm: Convert vmemmap_p?d_populate() to static
 functions
To: chengkaitao <pilgrimtao@gmail.com>, davem@davemloft.net,
 andreas@gaisler.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
Cc: kevin.brodsky@arm.com, dave.hansen@linux.intel.com, ziy@nvidia.com,
 chengkaitao@kylinos.cn, willy@infradead.org, zhengqi.arch@bytedance.com,
 sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260201063532.44807-1-pilgrimtao@gmail.com>
 <20260201063532.44807-3-pilgrimtao@gmail.com>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260201063532.44807-3-pilgrimtao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: rht6fqgqdrd9qb98mg3m9jaq6ceiemjt
X-Rspamd-Queue-Id: 3F6F5180009
X-Rspam-User: 
X-HE-Tag: 1770023382-543702
X-HE-Meta: U2FsdGVkX1/TgTswA5EXyQDudauCmwdsKBFhPQmOM3eGv7B1Tjb9kXwRvVlZtyEQ8C4cyWzUsUoIFtGe5WJ2D0nJGKWWcegaJjXSG7VWPT34tZIWByNEaKgnRAUbMdVcde9ydutzukvF+iev+9/42nFbHqe8Gw9UOXnpkrIA4CQMa8a2f6PLqhaLZrNNulPALbafph21vzBHrfiXqPgK6eGdKICrOTPc9tLFEplsNNek40baauejIXIfuJtAbD23Da1JXAMhwTNv/Pps15aUiBcm/JsG9zLm6K0F9zc+RLdVXFk4dQPgRnrQi7U1QO+YnsxaHsyoZASCzQKgjH+AhxdODUGV6ZyguXmta8MfNBVHv7lqhcKaj81OjH7TdirjhYi9OZ0tHYmnilNlYcvKkYSOfT1AuMCsoQXVXjzz2LYT84HDYZOlqpOgf0Ehxqs64IvzXi+rpm5WpmBWPMKeoddiSSLijD+RLCuAcCn2c4O+t3w8HVa6nupNxS6kq2uA154tJJVcJf+yqrMYNdYsJeLGe2h6OPhjgzvb3DcgWds5bm4NHVRq9ZhD2nDVMrzU+D726ZWdqzLapcg7GGpmXacBKV1scZ/cajhIjgCEus2sGdbpokuxxOQpbG8N4k2PnBWFU+66EgI0TZfIxL3JhWljKgcjNGa3MCa5JgNI1aLUAKIJm7X2YkEdiBmxq6oIOCdS4oi2BJWclgFrpVr6Q5iTgliYpgX1Wo0CN/nKV3V4How8fdz7/jrylm9SimIRv0kjFPzO6ueSvbeCFqtsz/TlZJ1bR7+PRaj7mwuQILuJ3WT7XkI9r+YLU2/V09Ti9BSWsmRwexQkxoZ9p32q6BzUH/9C7knlBK8uIJ/b5AhSi9o5c7toU4P/s8SFUUVQtXU+gmL8289iebcF5B8WQhSVSN2+zDGyxtDoom7TJp1MLsc/zr6v3eOyD+quv23WRVyNkGH0yV/xze4soAu
 orx714bJ
 KjTLfexYpSsCQfmK9SegTCYp/QVruv6oRdRT7qdhA5OHz8hs7iaZsb0ppoxtLA5hQ7gxOsL9IlsAdSgg032eqzvZF2xFGEc0XzsoQYxgN0E5Uu8h2YkiIM8LYB05ofiFUzQQIL/KuRbVHGtxPv8xfvjMj2uM0PgTd7FxkY+XZpyVnbQd/6Fs1fKZngWkFdxqTLAwUkOeLkUQnZkwSAn9Kwbr87lzJFkowfL+hdMI5+WNfMzjONKeHm5aOsyIlbv0Pckc+o7C+7BpGIXTuWOi9zdo5X1WPwh83VDJa9LUFtoegTPRyVzS5nZyQoIegh117J1d/JlaoFng55M/GSCd61RzBsMlNMlTowhICJn6DYnuPrdV9U8lILYTakA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/1/26 07:35, chengkaitao wrote:
> From: Chengkaitao <chengkaitao@kylinos.cn>
> 
> Since the vmemmap_p?d_populate functions are unused outside the mm
> subsystem, we can remove their external declarations and convert
> them to static functions.
> 
> Signed-off-by: Chengkaitao <chengkaitao@kylinos.cn>
> ---

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers

David

