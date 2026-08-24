Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F98C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 16:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659126B009D; Mon, 24 Aug 2026 12:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2026B009F; Mon, 24 Aug 2026 12:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 438076B00A0; Mon, 24 Aug 2026 12:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 161326B009D
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:32:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BB3E1C0A7F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:32:29 +0000 (UTC)
X-FDA: 85136706018.20.418A005
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9C6344000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:32:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Yt9ReXi+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787589147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2GLkaWfUPmegFPxXgQ548ekGVdoYEwro087l+1Nqkk=;
	b=d3aANLwHRoz1SSUQv5twDsF0FyIVvyLGAx+F81PW/84uGDMFBRBj2ElXELw8oDsNiELeCJ
	N4Aa4eNyp/f/j3NbiMTDv6h+F81QsMGRVbAn3r7hopZMK8aG3iArSOiNAke8lIkV3r81zm
	CzOhN4SU5zZVueZKLf2xZIN2S4UeluU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Yt9ReXi+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf12.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787589147;
	b=WKwKGt6svS8aKjOcG2xmOvZFRqWo3or2wrnXpmqaLsKDF2UGVZ5N9ojEOCFJwaFGlXVsq3
	RWEkAWSBVDPrZjB13sayQ7tHaj6fMARA4CRcXjr4liTYS99VAjXaUOODNIetMGw9QK0b2Y
	hkIztV39kK7kflDe2/wdmv2OzbgUJIY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=I2GLkaWfUPmegFPxXgQ548ekGVdoYEwro087l+1Nqkk=; b=Yt9ReXi+RwRKSrIuVc5G1aF8NA
	vxFI6hsHltULBCQGJyDBSC87k9JtrZdFoEmkvUmPTUzO1V8mKVcrmXtfywm4bjFgtST9uSAQXepi1
	AuS9BL4dFPsGsT66YpOAkBUtFjGK+P3/KcpcDalk47dP7MWT0aBMffcnV5SwrjNOGTxz6JhPGhVeG
	CH6aNQnkfVOIdRPEKKzohvuuJ47N1jYVhlDIMyfRsku+/RvhQQK8jtMpXCvOTbqCd5PeMFL2omUa2
	/8EbtaxR0f/+9KmBdrIJ2znLwN209PMdmDQritDVRJvHEjcbzsrueEBRak3fJRuuW2z/NjMOPfhJf
	GaHc+kYQ==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wyXau-0000000H3Ff-148G;
	Mon, 24 Aug 2026 16:32:20 +0000
Message-ID: <e6125911-c6af-4f19-914c-5ab2f621256d@infradead.org>
Date: Mon, 24 Aug 2026 09:32:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] net: Divert socket allocations to SWIOTLB for
 nocopy TX
To: Luigi Rizzo <lrizzo@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Willem de Bruijn <willemb@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, "David S . Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Luigi Rizzo <rizzo.unipi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dragos Tatulea <dtatulea@nvidia.com>, "Rafael J . Wysocki"
 <rafael@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, netdev@vger.kernel.org,
 linux-mm@kvack.org, iommu@lists.linux.dev, driver-core@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20260615234220.3946885-1-lrizzo@google.com>
 <20260824152932.1583506-1-lrizzo@google.com>
 <20260824152932.1583506-5-lrizzo@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260824152932.1583506-5-lrizzo@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qh413a1gfxqfxb4s4o9hy6pi5p538d8f
X-Rspamd-Queue-Id: 9C6344000C
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787589146-499485
X-HE-Meta: U2FsdGVkX1+n74rcT9TCBcqgCmxuq8mRJ307iBrXMvs6fnbixZH7w8Qc1+tIsyI+EyqKPTSU3vujgjGmDCyIwN0EO/CF2yTmBIaOalXMXXAMQ8FJgCFKoWR+n4dOvbYJxtt975KZV5Z2XHiYfUPZu7/2tCZSmV0Cc3LIgvgEb8//L06kHK6ai9i0TLHdnb2vZ1ndyhN/IKDvYh+0OGi4v5I55FlgDBl6js7N3CmP1ejpyZ+fW8JZI5r7vTmkC/HmUXtcNOEL2W9gsek04XdllOh1Jr/Mp0QK3PMv6a1QmH3gKmt+DJa1JB8IP1RnTkS+y+a1lwDxRS8wdykcvx+eYTIAiveA4HZvI/t28To/gdifUBkKAl6EKbeLhPfz/uEqrGdsOKysrvht8/NaWWsYNu0qnLqL0STB5fAwbUmrEPSBitXdygz72STqxaSYDEqEgyXkvqATpF20haejNgl6otkAYJGsV/tpJUdvI1olEbZEK94ALZ/7f98F2//a2zZI8RiOtde70HcuRKfySstQd8GdcYuT8aM3M9ypfj6SL/6t+X9gvUoc+IT0rbH/IV3BEXpN3RUelS0ugQLjBT2YnQqm09aPlOEXHOGgrJ5jiu+kPIp1nHm8Br4rEpCpDiZKQPGynrncvIZY0yiHPsP5MGINQrB0ixTo2jllCwqDuo5SCD/2Z8wqh5rhX5pxIGo4hQOZn8QXP5UewI4mK55IbTuqVqB7tSIXyGuypFdzJ/x4ClcjDuZvh+jWFhnEXGvLlivOy6JNK1ECxNXfNec0lLgLHrlBj6jlKTfKI7dZiMS8rge4VlbCoMuVSkTEXSjyF8HwJTOaYgumCqXKP3kAXAp+ttExYm5ADGiCOL2tNmy4oCuZrn+hNzc1vx8S8HLhX2wbvNN5J26iLudUlRz5y0iFCvcEBffFMoGvrgWOxvXTVZtBYdUXZsd/ZON45LA+Vy3dtAr9ozGX3ndihZD
 K4iyNEO7
 omX8ALBcBPWgYIIf6WyTYTmzq4rcsjAvT/gp2xW7qkCm/O6Sb3UHzGTdcQfkdx8cq+5MA/iODzmb31rGAzFea0iQ/5CMJbPh9y6KFWDYDBQFga7qIJgtYZl84shjhp1xQ9JElIOfqI8hR0dtdCcKPcBLuq52EZZ/pfJ9lBfBxa0NjVG23ZQCWyB+jClkadDJyJNLP6+OzfyUuQ3FWQZkMY7iIvysJsx31OxGxApaz7WzlLM5p0IXxiEYhrQ/r1TFWVcXw7sljAQgi/ilk/VMUqKHvfhXn3Li/Ik6yumUtp3X/yMU081z1meEJyaJtf/LLZrYLUgaFPB+pH3LEVls2KPAiC+n0ZMPIDIYSYF+sF7OjZiM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/24/26 8:29 AM, Luigi Rizzo wrote:
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index d4a07a7c570e1..7b818a796ff96 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -63,6 +63,11 @@
>   */
>  #define IO_TLB_MIN_SLABS ((1<<20) >> IO_TLB_SHIFT)
>  
> +/* enable nocopy tx swiotlb and set the percentage of buffers allowed for it. */
> +unsigned int nocopy_tx_percent;
> +module_param(nocopy_tx_percent, uint, 0644);
> +MODULE_PARM_DESC(nocopy_tx_percent, "percentage of swiotlb buffer allowed for nocopy tx");

Please add this module param to the existing swiotlb param documentation
in Documentation/admin-guide/kernel-parameters.txt.

-- 
~Randy


