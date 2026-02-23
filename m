Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B94FFEA4FC7
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 14:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EDF6B0005; Mon, 23 Feb 2026 09:45:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC7F6B0089; Mon, 23 Feb 2026 09:45:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DEE46B008A; Mon, 23 Feb 2026 09:45:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EB4C06B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 09:45:20 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA7091401D9
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:45:20 +0000 (UTC)
X-FDA: 84475994400.17.43B6868
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id BC3C0A000F
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:45:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gvPA+MB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771857919; a=rsa-sha256;
	cv=none;
	b=EL7NL/ZxKkN3feQr1QuJ+4/fQk5IXzYpomWHZ0C2nSXs0Va9TkPuwGiOgvNfR4FTw8kHs5
	vOSBWkBeyFZ0c0ehpKfIw57zulH4zDgGlitIL+3adMrP2yw35tQITy1ha8tNEgvxGWL5aO
	aKST/6f7eDTq69H6I/I4DDR9iSKtXtM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gvPA+MB/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771857919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jrdY52taT3U/NZQPuGXBlMxO3l3XijeN4kwKfbf/UaA=;
	b=3T7SzOuC5I8gY4vRudkg9m3aph/czPL1Qdiz+5Q15MFCYTDZyRpiBn8gsoez7wL+YxtJUB
	ci2phw4b6Jal44TjQr0SvN3oHLPoUaXlsRwfNaOS47rTwyNwzKhESSJ1jcjtuqTC1lS5Te
	eGT9/WGNgDCZhsuPdb2Q6VekIv1lPAg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771857916;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jrdY52taT3U/NZQPuGXBlMxO3l3XijeN4kwKfbf/UaA=;
	b=gvPA+MB/3rPZe3/+/xAdy7rLGGsuixZx+6Lg/SFcdvj7Pne2gcTVBzuqWYk6/eSywKtBCg
	/+sZ+33MMW3OoWIFucMMZgXUSMYkPwnWDirsMg0jvpEzROz4AOTFePeJ+p4rAiMfDKgcVO
	5d9tzkSlI2GvoE75tBd7urtM5+ANWj4=
From: Usama Arif <usama.arif@linux.dev>
To: Zi Yan <ziy@nvidia.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-erofs@lists.ozlabs.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	Jason Xing <kernelxing@tencent.com>,
	Yushan Zhou <katrinzhou@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: Re: [PATCH v1 01/11] relay: zero page->private when freeing pages
Date: Mon, 23 Feb 2026 06:45:06 -0800
Message-ID: <20260223144507.3065618-1-usama.arif@linux.dev>
In-Reply-To: <20260223032641.1859381-2-ziy@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8h7r5eifentatg9oxqugs1fsjjjjyq7j
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BC3C0A000F
X-HE-Tag: 1771857918-58698
X-HE-Meta: U2FsdGVkX19EwnlPZAC7AsJeeEXvBe7KCoIVM+VqOvHpRmUEiqOE7EBXpKJzVQFaGfzn8uM/GNcqy84OZbEnGeLO96xyzaIkwi9lqhzlo72HodgDGYSdDl453RzoiQ8q9WjzSCs7G5yxdiYEU2fAYBXJda3t9WAaw+G3MtMn1Yd8ja3lxPef/zHS8GOnZEYbfqX+OhAqg5z8Mh/Diq7oCTReD9gyrhfY7HtmbPAs+tUwLo8+tBZrGMcswAyoeD+nsgiWIRtWJ7PhYnIYrfjiIGcR3BALAit0TEOMk36IMs+fWy77lStZX45a+5jmkMN6indszf2gA/lnZvFsonjK62R4LXmjwk4N/M/KjevFfoxuS5gQo5+4UXFwT7EbqiZwkbfLvDcLEK2hLIFpRcUgLEZEFcyo+L4giRtfRu3B9m44rBg6ea/U+raH/hqvmXC1BYbdNd5QxRnfNbBo9jWfk64vaR1RYb52pWc4XOuYyDS84Z+Z+0ybFWvndCYnbtPNLEVrxYea3QYzqCcEadTaeXRt1+5bRlpFPTJV2GpYJDS9mloWeZTZ9GVSuTKLss7xE/roauH0HZJo6WJN3nHK7YqHJziqBt+UtAH60LkIHZfqu3ebP4he5dgLLmHsHRH3sguT/8AeYx/m/oQ7f87bVC0xhqx3MFAslxZPG4mdphAodKgoNt5RFTWcsrVNqoqiOMUSEinXFH+lGSAKmFj9ZJ88MP6RA0OYISUpZUofOr10Skbg6YWhA4ZU2Wqs4SC2mZ37VK6b9dkHg0Ast3/PoKeLK34q2trpORHZH7+C7hjyPTDub/SLITOeu6KM+ENjzVQmYIIzeMC3kFm5pNaphRqGal3v7AzRlAUpHTfN3DdJeBIBKs0gSLzEpI4AxE6Gr3GTw03OpGwmHrFzqDZCQEsq+550M8ocLhJq/KHMDjeNKKTrPp+mXMrk3qHrYEXTZwF1Xox88cjcegDec0q
 NEbRQMGG
 B1EreFA2uwjOZdLSNU5Wy72mrk58847bIyNPCYkAakOhoi9fqDBDplULt6UBpOCoOAoSX9Knuxl3++z+rbxyvQfEhGVp0nGPz+eVta1zb7q8aOsP2JfHWyC9GwDuD2PLqppMMZEXeGmOvIHM5Xmu30g/Xus5Fa66AJ3H7E8ADYGsOSksXd2rCdV2wxzP6UOO9Kd58TyQND3H6f7JvIEMFA0qd1sZqAnaRohhL+JuumOirOQ3pzBz2s8Yp8/KYEr78bbao7YMZsXVwkKE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Feb 2026 22:26:31 -0500 Zi Yan <ziy@nvidia.com> wrote:

> This prepares for upcoming page->private checks in page freeing path.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: Jason Xing <kernelxing@tencent.com>
> Cc: Yushan Zhou <katrinzhou@tencent.com>
> Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
> ---
>  kernel/relay.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/relay.c b/kernel/relay.c
> index 5c665b729132..d16f9966817f 100644
> --- a/kernel/relay.c
> +++ b/kernel/relay.c
> @@ -131,8 +131,10 @@ static void *relay_alloc_buf(struct rchan_buf *buf, size_t *size)
>  	return mem;
>  
>  depopulate:
> -	for (j = 0; j < i; j++)
> +	for (j = 0; j < i; j++) {
> +		set_page_private(buf->page_array[i], 0);

Hi Zi,

Should the index into page_array be j and not i over here?

>  		__free_page(buf->page_array[j]);
> +	}
>  	relay_free_page_array(buf->page_array);
>  	return NULL;
>  }
> @@ -196,8 +198,10 @@ static void relay_destroy_buf(struct rchan_buf *buf)
>  
>  	if (likely(buf->start)) {
>  		vunmap(buf->start);
> -		for (i = 0; i < buf->page_count; i++)
> +		for (i = 0; i < buf->page_count; i++) {
> +			set_page_private(buf->page_array[i], 0);
>  			__free_page(buf->page_array[i]);
> +		}
>  		relay_free_page_array(buf->page_array);
>  	}
>  	*per_cpu_ptr(chan->buf, buf->cpu) = NULL;
> -- 
> 2.51.0
> 
> 

