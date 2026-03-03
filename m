Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BB4EC0489
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 10:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27E476B00B5; Tue,  3 Mar 2026 05:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229166B00B6; Tue,  3 Mar 2026 05:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118CB6B00B8; Tue,  3 Mar 2026 05:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00A336B00B5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 05:04:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB92D1603F5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:04:23 +0000 (UTC)
X-FDA: 84504316806.11.6F22E15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 06E9B140006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 10:04:21 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DXbN4s/A";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772532262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XNPw/Qks4ufq3oTYZTZJttNg/tSnUZu2wg04c6XNpc=;
	b=B2CnJKBaFCC+ekF6V62CderDV5LaePS6fxmVtB2sh4hHphxnYsJGAmJ+VJm0MY2pk3kQsG
	sx4M3Y6aF16fRslMhqsPEHhnUFSkuKXTBWNLzpc2KDrs2S/c3xd/B/FzgCU5ia8JwIVOaB
	pD/P2+NVr4pziw5lV2V/3DXZYHyukH4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="DXbN4s/A";
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772532262; a=rsa-sha256;
	cv=none;
	b=2MvnCW49XYjRypC79Xw6AEk3DXt1uF9l0cP2OEQPYOszKXZrZSBUiUW3nqR96K/O63104+
	ydcFlzgLZzS/r+rbEvzvaCqvJ2vMrr+w/3cwbm6WSgJefYWd1O+LSb2KIFUq15FS3ZM3Iz
	7Yhq0Jb8pPm95MLOReHGZNtQGTzZMBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD36A4424D;
	Tue,  3 Mar 2026 10:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48089C2BCB2;
	Tue,  3 Mar 2026 10:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772532260;
	bh=LybxXzhrFhgaGAXY4fuW1jh4p0ek/7wtaX3PsXxtmhM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=DXbN4s/A/bmKVh59PKyRzmKRa4GL5DqbyVMCByOsv5ya+SBVMcVBFf7iJYdu/rqTR
	 WHZlwIbsdc1LEQ8ajTd0xOZdLIWyAkcvSoQk2M3Jb8TQQi0Y46LTv6oxHhNnoX5k5k
	 jCTSX0GcBNVA2/6V8yLYN8vlczzHbm5vN3k3fYnh9mMHi2oIw1Hz5DFl+u0dXPxXkw
	 fKVitj6D6sK+1XIrrKNbYqyy6qLfpmfjJggcziQM6O4fw5+cHPGDBV7qySv7wDL8UX
	 jV/FOGsHzt+q+hoGubqdK/3m7iXm78GHbBvGIZ4zx5nBOzOp80I/vInVVyBDrbnPPA
	 HXrkAGxyTbfIw==
Message-ID: <1c6a148b-ca52-497c-9b7e-07a0aed186b3@kernel.org>
Date: Tue, 3 Mar 2026 11:04:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm/page_reporting: add
 PAGE_REPORTING_ORDER_UNSPECIFIED
To: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>, mst@redhat.com
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 linux-mm@kvack.org
References: <20260303093341.2927482-1-yuvraj.sakshith@oss.qualcomm.com>
 <20260303093341.2927482-2-yuvraj.sakshith@oss.qualcomm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260303093341.2927482-2-yuvraj.sakshith@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e5pia5bonue8bcbsx6u5cwwf3ebcmokj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 06E9B140006
X-HE-Tag: 1772532261-466098
X-HE-Meta: U2FsdGVkX19cHP/aSbl/laIoctxaT94t3jWPlSI9mphgHAi8SoKkqIwNfsmx0TCGir1dmT/ivE/g/4/Q/pkFuWfwbT6hrG7jZ/dOw2RWbkmvqsgrKrvPWyl3FjJwucrOfcilJDT6UWJKTzBK+QTETHpvn4ZMtKNkLYfWYKMUIJej1tNcEo/NFNaGWnoxcMcYNcIdYWOnxW0mdt6jOZuFQ7aEex1pjD2T5vrMhpzqqZYIxXZ+IGe2i0yM9uW/ITd0wsxinK8XKF32UnhU6Z9Isxe2qvTN07Be6SRn/u7WwbCAxwleRxZJtmE9RlxSyjBq2vIZYAVj2JVAhJmeZRJo8rq7RlB2YnuhRUdqBtBcNfK24Bw7w2ui/G34S++kiixxY2RlcuMYBIxNZ5Hc+pSyisIskb4F4Zf8xdrYCaxmV1plfBeMEJ0gxGuRZsZP1OVF6HVkKOTYZcBLHeYLvAh+5ung4jAbvckFZqYuQlSfNyETPxCBSoMyOOIEJ8PICHvsBN3P42RNw3MQFIVL+A2ekRqBymPaA26atH7cNZxmKMriHIDqA6DwoiBLmJFJaN2LSzwA4vOUpTJ5Z7xzUoehoje9SNnKtBlyzLe/L7wv2XwWVnZLp1I1Vctyl9u4gQbMWz9QYRirqFW/4H7WC1EKM5vcMimG3JCfYh38dZQ6Qsb3d85P4roBpRKX1qJcBGjsxmyvpT5J2NCfJzzbRJTfb02WauCPrDGm1D0q7rfnQhiLW/vgtG3O0VveHGjp55gRPWnPNY93QT2v7rzhnbi4iwu+YyolcTHI13c+XRjdI2spxw+31VRRE0kUU2T26YtKdYIff1CCH33Jfdw70L71tAJ5vd3LpdAR8wJPd84FdtEllwI5fiK2W5lgw2+GL7+WTZF2qfpczqXU4WZlPQx6YOGV8fSzOMWhHm7MhgerS3gF9pLU8QLdu+tlp0pM4Tg7jEKzDznHgdbUdScCn9P
 bjLr9c0W
 HL08kKql3PxRtRj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/3/26 10:33, Yuvraj Sakshith wrote:
> Drivers can pass order of pages to be reported while
> registering itself. Today, this is a magic number, 0.
> 
> Label this with PAGE_REPORTING_ORDER_UNSPECIFIED and
> check for it when the driver is being registered.
> 
> This macro will be used in relevant drivers next.
> 
> Signed-off-by: Yuvraj Sakshith <yuvraj.sakshith@oss.qualcomm.com>
> ---
>  include/linux/page_reporting.h | 1 +
>  mm/page_reporting.c            | 5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/page_reporting.h b/include/linux/page_reporting.h
> index fe648dfa3..d1886c657 100644
> --- a/include/linux/page_reporting.h
> +++ b/include/linux/page_reporting.h
> @@ -7,6 +7,7 @@
>  
>  /* This value should always be a power of 2, see page_reporting_cycle() */
>  #define PAGE_REPORTING_CAPACITY		32
> +#define PAGE_REPORTING_ORDER_UNSPECIFIED	0
>  
>  struct page_reporting_dev_info {
>  	/* function that alters pages to make them "reported" */
> diff --git a/mm/page_reporting.c b/mm/page_reporting.c
> index e4c428e61..40a756b60 100644
> --- a/mm/page_reporting.c
> +++ b/mm/page_reporting.c
> @@ -369,8 +369,9 @@ int page_reporting_register(struct page_reporting_dev_info *prdev)
>  	 * pageblock_order.
>  	 */
>  
> -	if (page_reporting_order == -1) {
> -		if (prdev->order > 0 && prdev->order <= MAX_PAGE_ORDER)
> +	if (page_reporting_order == PAGE_REPORTING_ORDER_UNSPECIFIED) {

This change must also go to #5.

> +		if (prdev->order != PAGE_REPORTING_ORDER_UNSPECIFIED &&
> +			prdev->order <= MAX_PAGE_ORDER)
>  			page_reporting_order = prdev->order;
>  		else
>  			page_reporting_order = pageblock_order;


-- 
Cheers,

David

