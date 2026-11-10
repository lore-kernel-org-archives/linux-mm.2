Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D86460A262F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=S1V/IePN
Received: by kanga.kvack.org (Postfix)
	id 537BB6B05B3; Tue, 10 Nov 2026 00:53:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510646B05BA; Tue, 10 Nov 2026 00:53:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44E906B05CB; Tue, 10 Nov 2026 00:53:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2449B6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:53:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20547C0888
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:53:48 +0000 (UTC)
X-FDA: 85418142936.16.233A833
Received: from mta1.migadu.com (out-71.mta1.migadu.com [95.215.58.71])
	by imf31.hostedemail.com (Postfix) with ESMTP id ED87820003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:53:45 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S1V/IePN";
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k32ubl/2xC1TeEOsdmE9A8eWKaYVe5Y3iSeyYGqQUI4=;
	b=mKW+ku7UIzrExXpFChRJ4fif20mLqFhskCuC8eK2oV3FjCa+P+uvWHo0+Dti8DLKLUM8eD
	HhVUsiUMdckKy9/AdY2mPO+1EvePGw8KjWzpvxmrjQZFeUYUDrOi1XYjpff+/bjMZ4tHXR
	htMwRaYxOCnvzwV9GDqztjgq5SLwcX0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="S1V/IePN";
	spf=pass (imf31.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.71 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290026;
	b=LTgcY0DTReXugA7ACmEnm1Lcyg5+cQ4PUDd5YojEQwZkppAYzXerstBWuX2rB5e7t65Wk6
	eqxPeSEprl2MoDj7L7eC9JTkWoxnhYaYH4qtyPZAwE3NRreNJMEELYlVX+nemqGM8r78YT
	/BGYG8zlgj1+u+EUIxPQzkiFx7YLPaA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BlLqDq7pyCB3sE0VGnqVJVFi/gqZ51qn4nqEl6OMc/0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794290024; v=1; x=1794894824;
 b=S1V/IePN1X5+T+uljQBuDiSdzhPuCSFbcZpgYVfAnKLrWahijIothg+iFCmxjzD+5wacEO79
 vmJGgnCMdUtaEIed1ZYV2pRYCPkJ3jVtV+8rC9LB4aJCqNxYZyZFFiRvboTNWiEV95R+acJH4hv
 +syn1wkZ42cYhIbE4Ei85RQ0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3098e5835bb483a7;
	Tue, 10 Nov 2026 05:53:43 +0000
X-Mizu-Trace-ID: 3098e5835bb483a7
X-Migadu-Flow: FLOW_OUT
Message-ID: <b7d79e8a-55f1-4a6e-b9f0-1fee3598f1f4@linux.dev>
Date: Tue, 10 Nov 2026 13:53:33 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN
 LRU) update
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Lance Yang <lance.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
 <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261109-maintainers_mglru-v1-1-c25e6de60bcc@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: g86g8uyjihk6kfdbyduwxday5zfwwii5
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: ED87820003
X-HE-Tag: 1794290025-846047
X-HE-Meta: U2FsdGVkX1/Yv+lZBIvbTe5oOq6WLm3KJz9W2DfDMZaMLkq216ojtRfm8dHoohKkCsmOSITdDa5sGjwIaSq/tAxJf9t1E6E9GZACXTDrSN5hlz4Pncm9I1A3QjpEsmL/LS2amVlloQ4DQbPBBkjjF5MDULFtwrHkQCY+U/R7bgztCSM3rzXwU97CeXiaXFTsyja4hj9lQz2shyWLv9lEAt3CxoYnXXw7kLY81Hfzwwwg/zwtYMxkOXclEb60Lf2cG6P9qJ5ZM18HDxZFjtAgQyCBp33kzPs5QTod5NETL6vfXmAzTn/L5CRdtQEwaE+TZUFu5WBjOiOu5wwb2OjyLjthfBn+/G7fnfRwaoQ0boW1fFRUNs5LrepTTSUt++yPdDINRl1XizFf3wTJdLxTDla/3m921xCCcgiYdECy+2ums0OY6plGQORUgJjvh80SzjfLZkqcYO8J8s2hAD+LB9zTwdWf8o4m7CsJA6+f8Qnb3/QBC/Gz7mAlf7nBcHM27VLY06VlVH6Ap1rJF03Eqlth1lP/8JsjkoI+DJGhXGgGu4cuwx6QNFztx2xNncYeC211DcaKVmRlf/67WOZysB+CaE2iXzHL9XlOn3TegeeRBMRGmwA824fuCpJXkct16fp7RSW9TFXTuEVUmCykUGB3pT51eCervDYLj3nc7LagDWC3e8Pjr4l9/ke93jg8Zl67oLe802YenEHef/zVoO8UJFAIzGVkfpLHHaInj7L6HqjTuYmC9fULLaqmjula65tjk83Y1mRxZ1ELUQcQXY0SdyaHAbV1+aOz3rAKkLr3YsaDlkvsn0SgZosE6etC2tlQwMNfqvf140CgqsyGfQ1hygCXZ83t6kN1VfTR+R2094cTaZA+8YqTZrlchtVnMXhAzLDjLJw9R4MROMLbLsO+GiyvQQlEd9WvvgrToE+tRetA9nkeCVwXTPLat/P47PvLVeccE/K16JM1nY/
 pBaniP+w
 jTE622UCxRN1X9g/D30LXC4F0wqrRz6SVnG6z4Tt4kYAhpEFoUPTK5MHnHISL7mw/pwI/7JAet6EHJ/itSKMgC1cKlWX8NMiTTLsevgdfqMfCi4O0f+NREpayFl2BYGolophQaeW0Jsg9pFwH8iZB8byucbbVTtso70gSL2o03Wg9oI7l5PGoULHzKdT4PBsFbePmzWBbAFaS3aUnr8QD3AD/ordQgT2sVgSflubtJzhf2OTq+tShKPw2vohQsxLt54j+WqqWKx2h2Ugf0GVL1bSeXUjbh7bafgtOThjSH4Rr1B9f6J2HlFhrNIW4FOdNnFaQmGLT79/tS6+G9p2DC6QjEDhX1bK90ttwxgsf8g4opIfzJLX7va3bYOmmtwixviXaoGfFVEbTMaAFks+GZRlLKg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/10/2026 2:31 AM, David Hildenbrand (Arm) wrote:
> MGLRU is currently the only MM component without a dedicated component
> maintainer. Fortunately, Kairui and Barry have been actively
> contributing to MGLRU and have volunteered to take on more responsibility
> by officially taking care of it.
> 
> Given that Kairui is already an established MM component maintainer in
> a related MM component (SWAP), add him as an MGLRU maintainer right away.
> 
> For Barry, the idea is to transition him towards a component maintainer
> role over the coming months, starting by moving him to the top of the
> reviewer list.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>   MAINTAINERS | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 222b7fc2c3aa..e7ac319a570c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17635,10 +17635,10 @@ K:	(?i:vmemmap)
>   
>   MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>   M:	Andrew Morton <akpm@linux-foundation.org>
> -R:	Kairui Song <kasong@tencent.com>
> +M:	Kairui Song <kasong@tencent.com>
> +R:	Barry Song <baohua@kernel.org>
>   R:	Qi Zheng <qi.zheng@linux.dev>
>   R:	Shakeel Butt <shakeel.butt@linux.dev>
> -R:	Barry Song <baohua@kernel.org>
>   R:	Axel Rasmussen <axelrasmussen@google.com>
>   R:	Yuanchu Xie <yuanchu@google.com>
>   R:	Wei Xu <weixugc@google.com>
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


