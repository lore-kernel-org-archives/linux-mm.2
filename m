Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 240F9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286196B009F; Mon, 24 Aug 2026 12:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D5C6B00A0; Mon, 24 Aug 2026 12:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14D886B00A1; Mon, 24 Aug 2026 12:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC0C26B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:51:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7AA1BC01D2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:51:54 +0000 (UTC)
X-FDA: 85136754948.08.782001C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3712380003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:51:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bG+n8mRv;
	spf=pass (imf02.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787590312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pRcrUPOXsyrdeVukIWc4SE+545428m5LfB8zUsy5Ao=;
	b=2QVhcRdhb1ExkYuhf9WngiYMBPWk6imrIUBTyf6y5VjVpki+wGJ0JgnI/iMbnd94vIaXW7
	VrS4s+3lTXwo6aoqZdGYbfaG/29Jpg0whP+ctjAXSNdwolpllmJBK/2pSOyk0if7QU1SSE
	Q03XDwoss0oFRD5zkaE94LxnlbMxLxI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bG+n8mRv;
	spf=pass (imf02.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787590312;
	b=OuMStwvlpVVq/2Oja5AbiCMnD18bsaV425K8L6Y5rcSFyW16Kc3kvVyIys/s8kW1PGRVU1
	RotlFF2JJ+zFRl4Q67zjkxXQo0r961M919Jh8oSwumUlVxLbFQ3cy6ZA8KDrN+s2482Ehl
	Y3aXMnlKLjd/Noe/nos78mjnlIXBP5o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=/pRcrUPOXsyrdeVukIWc4SE+545428m5LfB8zUsy5Ao=; b=bG+n8mRvz3YPeVpOAFdo2e8pEs
	G5B5WFMth9vxiAb8J4pdP2TPxa0bunQlK+XfFvGl2wRkWoAoOcNe+z2J9cpH9wCzBa6RvgMP/3613
	JsL4Gkm6bxP+/zz1mhs+NssNNrrfwVjKnrxpg3ZHtjG6qsfMOMh+PV1Pf/ftzXJQNFN0ivrhTb/ug
	+lTiI1/a5a3HzNUl/SR12F0tVZ4xDLsUo7RWgVT3cUC17ZseFBYFvdhd7F2DmN/AqPr1uG45kbO+9
	rp7ArQwdOb3Jq85FUCrBVqHZ7ZfxNqBb4aH3CreWqPWyEgHvbxc/cn+dysHn5fvTN0y62hAURNCEm
	JGfv3Juw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyXtX-0000000H59U-3tBK;
	Mon, 24 Aug 2026 16:51:36 +0000
Message-ID: <6075472a-9ec5-48b9-bfbd-c3d8ac29d98d@infradead.org>
Date: Mon, 24 Aug 2026 09:51:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] docs: ksm: fix typos in sysfs knob names
To: Jinjiang Tu <tujinjiang@huawei.com>, akpm@linux-foundation.org,
 david@kernel.org, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, corbet@lwn.net,
 skhan@linuxfoundation.org, shr@devkernel.io, linux-mm@kvack.org,
 linux-doc@vger.kernel.org
Cc: wangkefeng.wang@huawei.com, sunnanyong@huawei.com
References: <20260824061010.3343959-1-tujinjiang@huawei.com>
 <20260824061010.3343959-2-tujinjiang@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260824061010.3343959-2-tujinjiang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3712380003
X-Stat-Signature: jqy3h3fjny15upiuq3emge53gh7erzio
X-Rspam-User: 
X-HE-Tag: 1787590312-676589
X-HE-Meta: U2FsdGVkX18/f52mwn/E4kBkiRjB/DGcjAnoC4h7eflJu4kx+d4q4JEx/ybo/1PVmB1KIq2otMxZYGRTi+tLMdKIFRddE0ZYGXofEk5ZZ9muJwAGGV/GzD1OuHKXQ8AlsVoX2Pi1J6Q+hrnL0u5H0djMuS7TQZVLrpn59X8qH1ui5/yV4wCeAmPgqrB2cH/kU6rHrkiFP3xbCv9McSSTTCDK4dAbU+1mRZtooLEcSeElxyjsspbufKAU7fkPkSl8cIddQ6udzqWIvU4gjmY+f2sTVyfmc+PEvp7afV/GDaGmNSh5rt48GAdSNECk+nZpNqnbMMmJn20g743ZW+ZbdhgJdf9o/Mp5dI7FThJr3D4/+AsQ8b4bZF8DJ4WgAyK/5SRaYdhqM8kbthW9Tf2TF8MegMxBsbbwxOBGPUm35w86o/RtTyrVI9SdvGS3+GIviWqjDLeiWznDzEKxLnsPh3PZ5AbXaf407AzNIvbtghP8gRddBEiCU25g26TuBLEkwerdCH0ryy5v0jDKvcCL4BGeRCJtpO21v9BBBhokJHlrNZArn/HCnTHIAGOlseXyYDQXL0Gh4qXzzYYLk4X/9m6wU0IMSt9HEsK7Ld7s1zSPbgXsUWfTjjqZ9MfURAwNjW3KxgNLEGLTTfxKM9a5IkZJK6Xnh/LJpZKf7Rohzix9NeQSDx1AF+uSSPLQX54/dgB3GdEYhFlEmtk2KWCOsKveYvGaS9SXJaHm/ewsHZ797VyNnhayIpPtCH46JgTbTdm8VBq8hLT8yJ/lCmdmUPxquWXueHNtE3/Tdo4iFa8HTfSmUGJwsZzSS5qI27bC7JQIaJtUMRHzlnAIAJCAMIRLis/JyZKMiu1A1hDbW4pvdWQVkWYeWSjOJjVkfDBUomx9kI8q7KcDTJhsb0mOiU7pUwvEcmFCy6QzhkQS2Dm+tNVifxmyin6TD2DLHD/6fvFsH50oFRfKoFhu9d3
 iLKrAuVU
 8dlcjk/h3ESUosIozAf9UhKh/2n/+vX2LQGu1B73zxJdUUHtOjSVHnuZecYOgLdZCov/yi3DrGnijg4W18LudatFzUqU1UsXspC5zK3ZCKVjSr5TQnIRg19cC50ju7HdQae361iVwOBhy/bbUvLHHU91MUZLGPIUuslDskjO5tMdfy1MarcV94fRsiHYr6CGnT5FpHwIPs/pKV0XJ3nGDYknnNCFRZjfu70Xca6p26QIhODrK79r/LMgbAgTVa+6ztnQQIgdUvoYv1Gge/+OjKcG8TGZFtHR7gSJBfkyfjSsXilrcpYc8AqC8AYvubMH3zAvdBmBTNL0Taelqc7XFx/6Bpumra+DHPdTsmHnuyU/1Du+1LNghHVSWJVskqCiWhU6yNg/Bg2JOM8Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/23/26 11:10 PM, Jinjiang Tu wrote:
> The sysfs knob names in mm/ksm.c are "advisor_max_cpu" and
> "advisor_max_pages_to_scan", but the ksm.rst documentation spelled
> both as "adivsor_*", fix the two typos.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>
Thanks.

> ---
>  Documentation/admin-guide/mm/ksm.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..c9f533b10f6f 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -174,7 +174,7 @@ advisor_mode
>          The section about ``advisor`` explains in detail how the scan time
>          advisor works.
>  
> -adivsor_max_cpu
> +advisor_max_cpu
>          specifies the upper limit of the cpu percent usage of the ksmd
>          background thread. The default is 70.
>  
> @@ -186,7 +186,7 @@ advisor_min_pages_to_scan
>          specifies the lower limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 500.
>  
> -adivsor_max_pages_to_scan
> +advisor_max_pages_to_scan
>          specifies the upper limit of the ``pages_to_scan`` parameter of the
>          scan time advisor. The default is 30000.
>  

-- 
~Randy

