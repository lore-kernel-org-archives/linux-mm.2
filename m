Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9716BC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386906B0107; Mon, 11 Aug 2025 04:01:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E106B0109; Mon, 11 Aug 2025 04:01:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29B446B010A; Mon, 11 Aug 2025 04:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D36E6B0107
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:01:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9307681A56
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:01:41 +0000 (UTC)
X-FDA: 83763732402.16.C15335A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E467580015
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:01:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuLOyZdP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754899300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5PQb25cpOW7WCB2d7y+6PNNPZ1b8F8FJ+wLKlQTPBE=;
	b=VCLpsEdWyV/sDtGZPYM546ut3b4Fbd0KIZg63REeczIapURuFP6MCR4ZVWXMECncAJbVVl
	oDmvy61SfqUfnPLLwXgWrsvZ+0Jg759mZ+QjZuvC/ALNu5KxWFP+9CsmH7U1gULLtyCeFi
	ARNtlBCnF6IQXZkHEUnRLiupsxEkXsM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754899300; a=rsa-sha256;
	cv=none;
	b=rsiqY/7/XnqitOo9ZlmOuiO/7t/3ZA3EPDskFPAodotQOHBZON0CpsYgaw7/SZU/lw6hhK
	2NpKP/8CY0aiRQ/t9ay5yKRdXKlsG6XOdh3/ca91WvQYDRHQ7rJMjPBPPQO06B6b/AS1D8
	vuJVXaL0WORQZgNhec07TC3kebMBhEo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HuLOyZdP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4879461413;
	Mon, 11 Aug 2025 08:01:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD7F1C4CEED;
	Mon, 11 Aug 2025 08:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754899298;
	bh=cRDAcnSTfM6+4j9YMSLVpxr+sl6lD4Ia4qXp2Y2QPMQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HuLOyZdPb/GhGEiVasAWpmi4l5P9GYfX7kda8eRZI31q1A74LlBC6abw3g2Smzg4w
	 tJV3+jWPQpR9x4GMKNyjwc5wvSqW3n5gt0VN1NlnKmXYrjOWOq/wEnw/R6S45ub8tf
	 ry0ogOZMx9770+6joHrAlRZpeHMdd/ps6RdLAtLQ9n9bIp17ZiTMcaffO+e7xYR6qh
	 q1Js5hYKEYAaeCL8pUOFg0jldGTiH5w7YZZbDKUrZN3BzFKkSf5YsLyIvfj/vipGng
	 ET7htCJmsCkQRhU8eNwdcpjYRBNguO28rP707Qn2JGsZClRpn/7bPJd2TI+ppwMYtI
	 sW3RjzGV0PFFw==
Date: Mon, 11 Aug 2025 11:01:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: pratyush.brahma@oss.qualcomm.com
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: [PATCH v2] mm/numa_memblks: Use pr_debug instead of
 printk(KERN_DEBUG)
Message-ID: <aJmjXABrInqumY1-@kernel.org>
References: <20250811-numa-dbg-v2-1-7842aa2d4c41@oss.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811-numa-dbg-v2-1-7842aa2d4c41@oss.qualcomm.com>
X-Rspamd-Queue-Id: E467580015
X-Stat-Signature: 88wjhko9srrzthk8mpcorsuzmhizo1ma
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754899299-219905
X-HE-Meta: U2FsdGVkX18jeuM3Cp0kEaXfbcXtz8Jz8YcTvpVLYy8J0N0Q0afy+PYuvLuZa+W4e9I1dPx1/3+YUsDxX2itXPExXkN7ZBT0M+YwE5p2FlpnWt/tC85i4/Vomct3Z96zEK9TZmSso8s3UAYWxpGWBQii73nqlZIflesYEyrrWUhA+GKGYSDiHLnLObAHItym7b1TQtOrO/pC1rUR/BZozdedfOIhMQX2I7Mcbk7ziJxUoQjkuNC8BznXv83PJ+M8IR/u+EUerXXp7sN6rbhzQ7708udT28FxeG+B9CEBs1en3FmVF5IA4rDwmqGYjg1oKZdXGQYPWtKCt/3LiHyhQTZzHOK3VxRPgZQhJpuyd3XnTeZuZ9pl2P8nVJUD8kcee5vzPwMfiWIz6qRAdTF9AVWZGxGlihdPUn6F84wKSRnEaj0Qw2g6VNxaVMtYoDAwG0hYkGimtfqvZRZRnYh6Ncaz9+J3H6zsbi9uiflHjs/z8dBHol5uGATUgDZ6wkwPjoPLSVxABT6VhE+fVnNNIjhhjCDTU3WvOvKZm6RGKhx9/e+Q16cmFX/CLnMiOxhylGkdY7i91toVCbUX4zaFtgUjiHfUOmvMoev0MXG6rcM8KyLox5Kgb0TuI4aOXcMKjaBiATZMryXn/0nEsx74N9uTHKFB75skpvwNbdHmlK1gKvmoGkm9WQ3WsqyKsL83uMBYHpjzoTG/onrIUSp6321USf6pauZKOYxowsmWKoICBjYN7XcUG+G1ycD6TXtpfnoeRwwSJo84fWp2VYhql+DZmr/OHpL5aALbcbR72jAW7A29/Mwknd/96Nl3H8lIAqfUrB9R0ZO++VNRpxBSmbTEjvdU75PW2EsSzucf0wG2z3TBxz6aJV9/EFc5LWZ3R9gG7bay9vy6kfuv6SB/FcTcxqBxR+MIKxcX3mR2POlAE3AfVxm72KPxWQeHkIs/B10tW81GJeA7FC82P38
 87fTJsTT
 uQVhBwyU65htjZbFePCHxODrthh4jTLoE4fnHO4M0gk6JvQHhjbo5KpdsJHvkakBJZxJkFGC2E9WoKhDzwxwypaU+k5wKJPT98qGfzxYwQ61nYCAQAIZcTm37HjZcQnwjWZhWs6PRHGb5zkY927fbKXu6VqnRWq3VjOEOUr0TLp7Ut+09gQnCYRl2CvktGhr9U26IozXerenD13D23OYBesFLcCqFDW80i5bRsfv6tMXMfi2rgNgAK/z4xb8JoJ/rJcBPQTNTpuRSDRz81qa4WaeoIeuPLHJVf4nHrq2gK5gBpmjv6niwYH90Sj2Bxc4J3+7ew1TwH9E2pbSgf0FL91dcHTx7KUtdjf4/0XGxSdza+nS5oqntSYPMSZsUsxRi9KmRXRDhU8vhDrZM5rOTNtQ7pe8H3kvpuMx2XPidmeC/+v4hhEMPWjk+IEjmf9DAM4ARvF9pFFQPRy7cJ42Zq2DJQvzqMBrmbY0I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 12:13:54PM +0530, pratyush.brahma@oss.qualcomm.com wrote:
> From: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 
> Replace the direct usage of printk(KERN_DEBUG ...) with pr_debug(...) to
> align with the consistent `pr_*` API usage within the file.
> 
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> ---
> Changes in v2:
> - Removed printk header as suggested by Joshua.
> - Link to v1: https://lore.kernel.org/r/20250808-numa-dbg-v1-1-2ddd1ec634aa@oss.qualcomm.com
> ---
>  mm/numa_memblks.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
> index 541a99c4071a67e5b0ef66f4136dee268a880003..ed6fcfca057ab4c9a8aa26cd1929551b4ded4a5b 100644
> --- a/mm/numa_memblks.c
> +++ b/mm/numa_memblks.c
> @@ -2,7 +2,6 @@
>  
>  #include <linux/array_size.h>
>  #include <linux/sort.h>
> -#include <linux/printk.h>

Please don't, pr_debug is defined there.

>  #include <linux/memblock.h>
>  #include <linux/numa.h>
>  #include <linux/numa_memblks.h>
> @@ -76,7 +75,7 @@ static int __init numa_alloc_distance(void)
>  		for (j = 0; j < cnt; j++)
>  			numa_distance[i * cnt + j] = i == j ?
>  				LOCAL_DISTANCE : REMOTE_DISTANCE;
> -	printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
> +	pr_debug("NUMA: Initialized distance table, cnt=%d\n", cnt);
>  
>  	return 0;
>  }
> 
> ---
> base-commit: 479058002c32b77acac43e883b92174e22c4be2d
> change-id: 20250808-numa-dbg-62a8b2092c56
> 
> Best regards,
> -- 
> Pratyush Brahma <pratyush.brahma@oss.qualcomm.com>
> 

-- 
Sincerely yours,
Mike.

