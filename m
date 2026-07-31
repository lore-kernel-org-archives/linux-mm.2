Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AD2C55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 601AD6B0092; Fri, 31 Jul 2026 05:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1B86B0093; Fri, 31 Jul 2026 05:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479C46B0095; Fri, 31 Jul 2026 05:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B32A6B0092
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:20:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7714EA15FA
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:20:48 +0000 (UTC)
X-FDA: 85048526976.03.8D3C83F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id BA6CFC000D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:20:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k8sP/PXi";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785489646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUZ9SN0N2C05U6WQonOb03P00ptR6/rTlFGHNCrawFE=;
	b=F8aA1JdMzaKgCSYm0Zgr33sLuq7pr+Mx6raveDGMmGsNnfVH28pH7boN5PPlNryF8PNtZl
	NaBeMzriwUxif1bf3/4TblgTIiEbbhQ+MO8xz1CktJXmixLTZa0m31IpOLd+dV7BoZss9z
	KULr222uICNURpxZSa9czTV+Px3okmc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785489646;
	b=i26cakhVdr6U7CTc1C3xkwLhembHzG85IPJwt+0CpC9JgpXmqPPlzXC/0GadXsSz/7k8v9
	LSfnebXG86tlEVHMLTMJunnuVwIz804l4d+aYnLecp5Eq3XW2JwAKcO1Z/vLpr0fX8KkqR
	vqnVg4FAfBnIVEXhBJHG1upWA6ttOoM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="k8sP/PXi";
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F6BD6004E;
	Fri, 31 Jul 2026 09:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A321F000E9;
	Fri, 31 Jul 2026 09:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785489645;
	bh=AUZ9SN0N2C05U6WQonOb03P00ptR6/rTlFGHNCrawFE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k8sP/PXiGrwySS5F70zb2FFJVkowjAapZVdfJ+XsvgQNrWwmuI01dxYN0SZXI1Xpj
	 zCverqWB4eJuQ4aYeK71fSB2klB6AWfHyfnFxchDDaLsMhmxFPfkllKd+vVTsi653E
	 bA7DMvP+eDZ3wEJLTcMhROHrQlZHRr5k4bLwai3gd7csJjxitduzAla4h1GXpQ6uK3
	 Q8UW5M5xqsNdeI3OjJlOTxDEcn0s0MPfGcJtLrz2GjToi5UVr917wMWE7bFamNckoO
	 z1KlVAOpm16qWyuzNFWgs/x2SNEbAxbcbxJmVRZkrsCKmdFAth3yz2zW6LTeoIPs36
	 jkTcAqesRId9g==
Message-ID: <fa82bba2-8a34-44b6-a3af-a942d8ec2b45@kernel.org>
Date: Fri, 31 Jul 2026 11:20:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/khugepaged: replace mutex_lock/mutex_unlock usage
 with guard macro
To: Jakov Novak <jakovnovak30@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "\\ Liam R . Howlett \\" <liam@infradead.org>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260730204724.16912-1-jakovnovak30@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260730204724.16912-1-jakovnovak30@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BA6CFC000D
X-Stat-Signature: prqzofkyzjnqo4cge4xe3u8i7xkxgtjr
X-Rspam-User: 
X-HE-Tag: 1785489646-507690
X-HE-Meta: U2FsdGVkX1/mX3ZbMAos5X8Y6s7gSznW6Z7/Z5axDN4MgmgHyrpMxynknZNqLybsmk6mTTMPz1ykvdS0kaPWVWXAhh+4HU8VXUiIPBn/WibUZcU4t++KAPk9xB7hC99W/Mnv1BMagpPk8s1ieRsM1aoSd/jYwu+lvHDlZ3f9/Q3B5upChOei6vng0v9Aw2XDi9IirWv+VRpbP9A3NyHilthvK6JDP83EriC7N58Is5H6JewZp+ld2Derh3xoo7ItNzVSWWZkte9uPDyF5Bm+JtNffxJcSM/b7YiGvfNdCo84fLgHi+//D0v5Zoflkc8ivK0lAUg66MwFOcYqmE6zw71kfN4n8cJ90VkOGj6DgQPb7YqyhM9OJwy+Q6kYnMgaN2R0YK3FJPBxdueOI6RiOS5Xh4JuAS9nVFFjQDIFWmOeHHb+SF/XeZeeqevAErZRZayVSBO9j+dwQ73AUDNLWOzcrfWtQFcejqP9oo2YMHJMmtLC1UP8IdO5wjcUmpIdWOjvJmQBB2tfAx3WX1dqE+Ehnk5CYpgT5XN9S3izgmRpUvKljRqZvB5flRfd2xe60pu21W5e1VnDptlSrZSrfr3SRj9KQrTlLLqY0Mt18cM0zYcvvYUoRKjdeOxT4CyS+k8zlmBh+Xn5mBSp1dfAakDlvCkPT7GMO/01A0o0zA6hXma2USLyjHz4+cdlVHUw7PD7SPUek7qXYUrMgKIn0Ooj+bBaF1RRbv9Ma2y+7diaV1TPyVISSDUHmGcwvZtr5CJZDo1+Yu/uCbLIeS1XEm4sz8SIGhdHTpNe4GySSYZsx4KNDwziPiMPvJGST0Z77zPoIdBn/riDEIJoIlvbBML9o/RKvQtq4B9ypKtLELhL9tzOsjzxvsHNjC+e12RSv4zHKnqQI2+cYGXMF2g4KZfwMardKRo+yf49u34ubypRxhISk6x+VkllRBLxo3v91905/VqWnwhTAzMH/oE
 QQpNdBic
 By8iffRi/zShKgTtfZMI86aZRAqcKzYVbpL41mr9bf+HpWUVcdyXaJ0p0lFeTKxyWwUc/32QzLcUMhynQEaXxlTXL6FWJisc9m40ibjVsxfrFVZf6SiWzQQrIc0mpOzt9pafIxZwSl14jIplLInhr3S80KeIHIpuvvcQdJk6tlFxdBBwQFbVTCAbtLxhBMxMK0z6KMrElIbuhE6bp4LzrtOy7I3udZEHfMQdjgcaIyldzcUS/oZIOmhBq61aclM7zzJyK8SIGKR26LlM0/sfpAtHfi6tPNtTEXfXdhNAmMBmtHSA8HLSRpOUTLFkgVnz41+aK18wMh00YhFxTOeieNWjGomsH+92v97yOceXZlZ5oiGlXiVgk6s05DuDklISiTlp+fkvCvG9PX2gaRYI8mhroX9J3IQ5kwYCZVpQlEpujOAaXHvZQrHQmjya0eC5UefHxThKtgfbRx0QobtXqcWRKIHJr4FSbiQ3EhEqVdaFeFFVmZZrO+W5O0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 22:47, Jakov Novak wrote:
> Currently, khugepaged locks the khugepaged_mutex in two functions:
> start_stop_khugepaged and khugepaged_min_free_kbytes_update. Remove
> mutex_lock/mutex_unlock usage in these functions and replace it with the
> guard macro. This makes the code more readable (removing a goto statement)
> and makes it harder to introduce bugs in the future.
> No functional changes introduced.
> 
> Signed-off-by: Jakov Novak <jakovnovak30@gmail.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> ---
> v2:
>   - Added #include <linux/cleanup.h> to the includes at the top of the file
>   - Moved err declaration to the scope where it's used in
>     start_stop_khugepaged
>   - Made default case return 0 instead of err in start_stop_khugepaged
> v3:
>   - Moved new thread creation logic inside if (!khugepaged_thread) block
>     in start_stop_khugepaged
>   - Removed suboptimal err variable
> 
>  mm/khugepaged.c | 31 +++++++++++++++----------------
>  1 file changed, 15 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 617bca76db49..97f61a050f7c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -23,6 +23,7 @@
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
>  #include <linux/backing-dev.h>
> +#include <linux/cleanup.h>
>  
>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -3111,18 +3112,19 @@ void set_recommended_min_free_kbytes(void)
>  
>  int start_stop_khugepaged(void)
>  {
> -	int err = 0;
> -
> -	mutex_lock(&khugepaged_mutex);
> +	guard(mutex)(&khugepaged_mutex);
>  	if (hugepage_enabled()) {
> -		if (!khugepaged_thread)
> -			khugepaged_thread = kthread_run(khugepaged, NULL,
> -							"khugepaged");
> -		if (IS_ERR(khugepaged_thread)) {
> -			pr_err("khugepaged: kthread_run(khugepaged) failed\n");
> -			err = PTR_ERR(khugepaged_thread);
> -			khugepaged_thread = NULL;
> -			goto fail;
> +		if (!khugepaged_thread) {
> +			struct task_struct *new_thread = kthread_run(khugepaged,
> +								     NULL,
> +								     "khugepaged");


Nit: we can exceed 80c to increase readability.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

