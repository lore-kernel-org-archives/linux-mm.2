Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B14ECA0FF0
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78D536B0022; Fri, 29 Aug 2025 15:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 764296B002A; Fri, 29 Aug 2025 15:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A10A6B002F; Fri, 29 Aug 2025 15:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 56CAD6B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:21:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F37FC119C5D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:21:29 +0000 (UTC)
X-FDA: 83830763898.27.DE81843
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 737FB40009
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:21:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWGvXyn2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756495288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0rVe+nb881PUhqloZye8Uep4HQ4xSz9CzqjAUYybCXk=;
	b=gAbmkW4Q7GwBtJDbjGzGkFPIwZu1JSjMqU8EEARP+9MhN2NaQ7P336GVNtWvOjcW+X0vlp
	YU1d/2mY2C+5HsC9ty4+iL48/cvmt+GtHLM3nynM+84R4i7hMU8eG9sjIdgAGXxBBT8xnl
	ak1nVXYfHvjOy63WY2A6WQI/+Yv8PU0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWGvXyn2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756495288; a=rsa-sha256;
	cv=none;
	b=UJs2knApfpP3hv47AgABM/Cj4KVaszwu4tSenycUik5AnfhlaxzkgNtugoMzeX0skQ3QYt
	GdD62v+e4EmzO3RKftn+erncAPl9dO+as4o3MXTkMsNArlP46aH+hMimTn6OOf01vZVMly
	O+HHV5ta7XAGLFnORgTwEy8R4UDSe/I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D45EE60142;
	Fri, 29 Aug 2025 19:21:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64092C4CEF0;
	Fri, 29 Aug 2025 19:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495287;
	bh=s47kshSfOVHQ7cWr1Wl/7yxIDOYk0q8zBDwU1L/LLJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWGvXyn2lQ21FaQyCCpph7nGYE1/iGaiEuzZxjs+pV4IhayT265ZXGPbdLPbibKyp
	 APTss9dPn/Mnht3iEBuxlQ2DAEMEUkT6aCCDoxYozyCqUOaXj2LBefBjNXr1MWxSwh
	 qs34a4IP+3ewmW/FC1Sv+pwjAsdxyrNG4pHe9sAe4SPxqfrUyxsZ04wnbWUG17PCht
	 yeqmutZRcsnveRHdaeGGobUN3RhY9qF99g+F5IxiybOkTbO92OOTIkw9lBqcmXnEjd
	 VxYY3w4J7YSZrmjylugEZ/EhEaUx8WskD0zTLZCLFCcrXQWqNwPsSHRfyeFyrtflzR
	 k5tyU/t5HORmw==
From: SeongJae Park <sj@kernel.org>
To: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] tools/mm/slabinfo.c: fix access to null terminator in string
Date: Fri, 29 Aug 2025 12:21:25 -0700
Message-Id: <20250829192125.60930-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250829084738.1349383-1-kaushlendra.kumar@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 737FB40009
X-Stat-Signature: fihm9t5jqwn1r9eu66ndauyst8hgfok6
X-Rspam-User: 
X-HE-Tag: 1756495288-79882
X-HE-Meta: U2FsdGVkX19nuhwAkVIgNaGVszZC6YEb73QjLw4C09eB9l+8JZcmO7tbZM0IEQVSMtcs6K3OedRxFN5gtjevA79HI4BboAW3D+hp501Pk8KGffz0wJsnNTN/2F5cgy1T2uP8VLq3u8jVvbjrur0eabuDUQg0yDvUuqHa5OYXrgvxMQCEosu78YGNoQGMRM/HqHTZIiiWBb6RZZIZrdtU/ch5Be2nd05aBxuFGs5scQ2LetVcYfXnivkfe6XPX9om3Igr63nOIwE0/bX4QOiOVwII3Gcu/s9VbJ6WdaAJU6JS0UJm0LB6FRu5UE1dIpHDdRJA4EXWqC1jLTuaD/oUYkaikCbkVZSvdxL/2O7qy3XYjDnWu/TO3ORle7xkSfYWlf2bChyf8bZ3P4FVMEyHio1eLl5BkdN+55ieRvU9koUcVLAHApWs9w2YYLJU1Q9vybfY9lajcOvlqjKDZBGmUqgbpPsg5Te44F0CAYgrtxqrca6NlbyHzx8UpasTAxnkQ8UClIu/wOq2Ysf2z1yMQAqj3GqzSR90wXPIjjGE2Y3xZ1BU5SZ5sH6DqwZxYsLx9ejWTJL3q9rs5TO12O1j8sAP4t0/mWCTWNf8l0n2BNPgpBBjsl77E5QLyDCKunBhgQynrvcdszVvu5iEyxRrT9OMf01Hu1WlX1NTvT+TKeoauHtyvzBDNhSJEaubM/8yBz0iij/xa13zKGARqVJteH2JHd+H3TaKqT8Bu2dF/I2I6MBK0WHYMtfogKSZXeAqKRr9rhdZaaM0zEaETegeWHxcMmjFs7F5AWgeu+YmbYtAcip2/uAI7v+TX50yjzxNnabGD4njcSKHiijLOlM/JNy6b4lRDJhT4FbIije9O6YxySdOuZEFaZJCZzHyW3lqsNylbIewpb9zOIaUS7Wa8PR3AAndXCkHzUvZQrYHNioJWDRyFcYD3dTbBAnZFkxuKNffv5oYCn4MQovumHi
 /heJovIh
 p5EGP9RG05TEZzjqPIwcTcd4aKIWziFH2SIbzssqpfBy7lty8+N1AXSfgT/esLoTPLVEIZwvUpH5cGETr2b+330hJhLkWoGqs1jpzNG6pdS4ezvPTxIg7O3cZPltijVCidSbQCKCU16kQivpl9KIsuF3hycodYdOEoZ/QS5YUuVlSVjhnU6Trmn8R9SO0McdSL897A+8Zz8rFiX7zh+L+jbZ94b2+zekWxlGpk8QJ6c32xuw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kaushlendra,

On Fri, 29 Aug 2025 14:17:38 +0530 Kaushlendra Kumar <kaushlendra.kumar@intel.com> wrote:

> The current code incorrectly accesses buffer[strlen(buffer)],
> which points to the null terminator ('\0') at the end of the
> string. This is technically out-of-bounds access since valid
> string content ends at index strlen(buffer)-1.
> 
> Fix by:
> 1. Storing strlen() result to avoid redundant calls
> 2. Adding bounds check (len > 0) to handle empty strings
> 3. Using buffer[len-1] to correctly access the last character
> before the null terminator
> 
> Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
> ---
>  tools/mm/slabinfo.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 1433eff99feb..ac0cc6c1c87e 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -165,8 +165,10 @@ static unsigned long read_obj(const char *name)
>  		if (!fgets(buffer, sizeof(buffer), f))
>  			buffer[0] = 0;
>  		fclose(f);
> -		if (buffer[strlen(buffer)] == '\n')
> -			buffer[strlen(buffer)] = 0;
> +		size_t len = strlen(buffer);

I'd prefer not mixing declarations with statements.

> +
> +		if (len > 0 && buffer[len - 1] == '\n')
> +			buffer[len - 1] = 0;
>  	}
>  	return strlen(buffer);
>  }
> -- 
> 2.34.1


Thanks,
SJ

