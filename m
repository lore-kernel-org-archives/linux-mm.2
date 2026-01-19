Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2D8D29C39
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9486B0252; Mon, 19 Jan 2026 10:49:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D6AA6B0253; Mon, 19 Jan 2026 10:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3126B0256; Mon, 19 Jan 2026 10:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0D46B0252
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:49:05 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DDC9BD18AC
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:49:04 +0000 (UTC)
X-FDA: 84349147008.19.97B2507
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf10.hostedemail.com (Postfix) with ESMTP id 19320C0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:49:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=HW0W0lCk;
	spf=pass (imf10.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768837743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twVnDFuYyyL62tlgz7hxR0JHVh/4/iN9IwNYk8sCIsM=;
	b=ijwEj/pZF6/um/ou+/tEj8xwfncowID2rHn4W/TdoAG30Fsa3GiAchjxZDDGFp5TB24P9d
	orksGzMI0NIJGPQSfZOjsA9jnOOW8qsUgWPDWOJIFoKYywe+hvJkujKZO21wkmZ9Us7MyI
	bD2G9RGJqejiYuQTCFk129CW4K4v3+4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=HW0W0lCk;
	spf=pass (imf10.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768837743; a=rsa-sha256;
	cv=none;
	b=gerr6qO1gWV2xpjVRa4iqm3iDUXcxVrXgJfPh9MpfUSknFeZjmmMJJlaPBTARHsMg63FP0
	585AlQvXrFtBD9HbPI9YJK/uBe2o8mgqc2/jSkt1aPCCq4fVjxr62U8CdZCSRtxOQCx/w+
	h3Rv6E3/ienAM2AKrLHEyz35gHHTeSI=
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id EA7845FE9B;
	Mon, 19 Jan 2026 16:49:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768837741;
	bh=BL3meZqsZ6zyWrqmX2gWLKX25saoedB0Z4kpaDwfnzo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HW0W0lCkK4CaHA4Z0Y6y0pe30gQQ2PlASyvv3YVMM07Fb1uDmQybHHE/TxTEwaxFd
	 KejVucrd2Hg38/eDkNJxoiBSxWEgpH78R3wmtduIrTwWV8n5q9Rh1afo2ZJhCmXf3j
	 W8Ixey6KgB6GqCdXjZY4eWayYOTd5PY8DkFdNsyK9Hc37dJz1FFEhimJm0klWU6OeT
	 sr4iT5Vnhl6kMPgXxY1aDhCAncqtEb0rbRNheZ06p5ZXKyFEaqCVP9CEDQuAVdRSlJ
	 asaZCz/xHBE/ktb7q2dHNRLThdHrW34nX/CPQzzXQgLgCQkjzsqjP+nI6QEuX5S9Dv
	 67jjjGxBIe0DA==
Date: Mon, 19 Jan 2026 16:48:59 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com, 
	rdunlap@infradead.org
Subject: Re: [PATCH 1/2] mm/page_ext: Add page_ext_get_phys()
Message-ID: <qu5oksvcaytolppeeale6rwf4bzvckvfdg3iw77kowrg4fn24a@p4hmieukkttu>
References: <20260119142246.3821052-1-smostafa@google.com>
 <20260119142246.3821052-2-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119142246.3821052-2-smostafa@google.com>
X-Rspamd-Queue-Id: 19320C0003
X-Stat-Signature: c8ieqn8rn6h14am5xkefupgomz5114hh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768837742-503605
X-HE-Meta: U2FsdGVkX18hOqb2JXT+GlunowlThV3CYrMkM4Eu2x33Mb+ZQ4CyBuW2cfqncppOpx7vV15lDRMF+5HzUW2tinbmIbVx3Y7k8uJkHZ18NvVb43fiNou75femP8AQ7UDci/vK+ZkPgYtgnwGg7q5D+uPsjIWsQ7pxpLQnzXQk/tFTNKGPar6eDkAhbxdNqS4wsXZQjWkqp8MW4cLxC2fZ719TrI/WcsxX5QqqV4vy7gbAHTYdplCEX5DjSQF6YkE+KA06n1RhHOa6GYTooeCmYjLDbl6NZ/VAQoEBp6kPpoXjtPvct5uYG+A+Tnpqoler9x3JgCXc8hXDAFYWV8AYZ4azRWwJ7qW8YvKk4FtFPuDjPFJWjLDv48a0gu3oWuemneV5NI7GspyzXpiR3TMLTZHuzKwOmXfDNs0dqWiutsS1xeKnlAfP8Uszu2W/dBeMgvvuo03SyVoTo8OGOmsOBXE1CEx9X6MiYcN2C8Zsad1FjkY6CBJSfD+hLdRKtnP60bCuUT/j0BBKcxdSUUPKD6Ff0r72hBfGLa4Ed3BzsMAxBYvzo1zuJdj3xGctR+zaaTSpTjR+GeqhcficooXVBHh7QtHbBk9zEDEINVsm27y8HhpjSMcavF0yeCZMrX5g0Fngvr1bQYsgMNyeAt9nVedO+/1zcm3m8SQgFbhVtnQBeNUMA8SmUUofbnk2b0V9hBL7HdRPsp3uxXfDONgXi4nH/xqQF7aSD4D9dpeW54eaiPlcwJq81dU+RFmP0tVWiXFtcTkjY6GH8tMnTq1fFRnFYym3MVtYnrQYXRuGVAHdix8TR04N8Wh3KCOHjmll16Pxe6YvQRi8jRrj/cJ/VqxhQjDU8trW+DoRMpvQmFLWiSHD9UvNDWFgca5fFMpy3OzXFqgbJ6Hk8VwziVGIFRx8VR4qzPUSF53mpO9rIJwbbXSZlrxSenWmgfpBF+o7ochLJ5FbDOTpiESq89W
 Fv6R8WCf
 WVPhu6ur8/GZa1Nj2fCJXIZlD/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 02:22:45PM +0000, Mostafa Saleh wrote:
> +static inline struct page_ext *page_ext_get_phys(phys_addr_t phys)

The name is misleading as it indicates that the function returns a physical
address. Maybe name it page_ext_from_phys()?

> +{
> +	return NULL;
> +}
> +
>  static inline void page_ext_put(struct page_ext *page_ext)
>  {
>  }
> diff --git a/mm/page_ext.c b/mm/page_ext.c
> index 297e4cd8ce90..5fe65a0ac4f3 100644
> --- a/mm/page_ext.c
> +++ b/mm/page_ext.c
> @@ -538,6 +538,29 @@ struct page_ext *page_ext_get(const struct page *page)
>  	return page_ext;
>  }
>  
> +/**
> + * page_ext_get_phys() - Get the page_ext structure for a physical address.
> + * @phys: The physical address to query.
> + *
> + * This function safely gets the `struct page_ext` associated with a given
> + * physical address. It performs validation to ensure the address corresponds
> + * to a valid, online struct page before attempting to access it.
> + * It should return NULL for (MMIO, ZONE_DEVICE, holes, offline memory)

It should?

-Joerg

