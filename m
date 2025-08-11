Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 628DFC87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 00:15:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B208E0008; Sun, 10 Aug 2025 20:15:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BE08E0006; Sun, 10 Aug 2025 20:15:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 788FB8E0008; Sun, 10 Aug 2025 20:15:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 666F98E0006
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 20:15:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B474A8286B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:15:40 +0000 (UTC)
X-FDA: 83762558040.28.C172277
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id A07C240011
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 00:15:37 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j+ge23i9
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754871339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+8mZzSO0k2kTLnKNSayaQjHBFlZoHnAiE4F0939UhM=;
	b=u8OVDkqzySNSedJFHHySdpI9vsSMPdPKwxLe1fUa4XTQ8MnufKpTafN5ObmX72K8U9YA/T
	bNENXI5hs4rqg+GwFLMY6IW4R0UX6kKizLyMFxjQzyo7ioFCwbgEOokn92Rm8Qn76dS3Nt
	YZmXsY3YAV5RS7JNIt+esGykGPSDRK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754871339; a=rsa-sha256;
	cv=none;
	b=Nyw4dcdjISlmutMfP5iWIOXUkSVmzD55U8lIK8vl8pHZh5c6rZj23CyXe93kbX6khMyA9x
	ua7MPLaM8yYeSQO5NoFUAm3Y/8ywU+XVeVCdPc7CC805YtxlgR6LAur7MYpcYUewnasP0W
	bZ7E4jsr4+50MNsHJJT8EM9CM9WpQx8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=j+ge23i9;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Y+8mZzSO0k2kTLnKNSayaQjHBFlZoHnAiE4F0939UhM=; b=j+ge23i9X82gAdxkZ/G800m3II
	xuxx59avI6IJ2yg8YXqnwhb0wMw4WpfyaehDuhG7Jx3/KRZB65L3TytuPRGG0W8fCzpRgYWRcCFZB
	omRYt7YMBtE4bC2uUuz72J2p0lBOhAgynX+cwbuIvplMpKsDxXvVmRUno7UO/zRABle7r3DmSSUMY
	uJ3U1lCj2YHzsW7KB2F3SQhuusxvAa1zqLXJxFi8i5XPQg0bLB5KBxClcFjKM4C8Bx6ka7hCYhJCc
	MdYs0XVYmG6UcJEKf8jUyKwtprrBdUg+Gn9e2HdcpbLAjt/RAXU7ks1wY7zdH5if2CcE3mQFVJVR2
	ehX8IErg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ulGCK-0000000GBdP-0gwH;
	Mon, 11 Aug 2025 00:15:33 +0000
Date: Mon, 11 Aug 2025 01:15:31 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: Use max() to simplify
 hugetlb_vmemmap_optimizable_size()
Message-ID: <aJk2IygsxWKYf17u@casper.infradead.org>
References: <20250810214745.2368-2-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250810214745.2368-2-thorsten.blum@linux.dev>
X-Rspamd-Queue-Id: A07C240011
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: h7ftj81bh97f6pksxp1xa6eifdpzybon
X-HE-Tag: 1754871337-734378
X-HE-Meta: U2FsdGVkX1+OeLiqJFqDtrPoFqqfsOD092zshbP+Dd+liL/lPSnBEL4jDtxzYwYgV29YILiTpLRdCs5UBP6c9spBZ3vEvGYZqMtPvX7tlCf8jMXDLVq8XjWvFaSGEv9MJCXXcf0acAdoS4Cy0W0/sZHQ9YfPWOIOGddyU9aTJ6yHOFbWOjUxSA/b17Gp9ZXvgMQze3PlJY6i+kCdp+RGuqS2CzoINzUVG0buGkdbRAD1FlAseBGg2XqZqC1iGB/gr/tn2fu841XudXtN7Yv4UjrEXouYni6a7OzrDVlWTl3f9ZNdoUsbS9isez2Z5MM02QKC+V8ywnbCQpcbGgJnimWVV8AQPk867ccgHS2X4Cw+uqvHzlOG5tsPmaXc5AJjVB7aIxir4W8WUrEA0H5byw+/WcMG2ZWgCJQyflBm0NInqDJQQg2uJjSW9cBn7pQkoK05q2U77XbkmF6txpvVPiUDNPUsvCrnea9vwGnSlSIHcbnO9gat6WbIL5F8/uLkpPuiA3fJ7qlxonaJW70aTchDpHKg9oS1B33kTTDAlLO2IBeesxGKziupF0K12OgtbFBoAXQSXc0x5d/nhC+Lhx3YzT2t62O9fv5QikjsEA0Wzl2DAConiD5Wk54xBUVG/VoZpwanKCqrPjSPRP1ZAI27I+UDNcN68lC+Dt9S8vDKQ3dF8F0K+qqr9UJWJWeMqSuExBx2ZzWD26q7iQ/T3y6Q2faSST+h+9xa1j/YqCbWrLOZhBAY3K7d0QKXLOK5uOOfmpokkfCMI6AoXqKkS9gPmxHHQ9tntabQsaY6f+YXwVeiQEFgzo2PXM7A+mJ1w5hBhus3YYaQeuKREAXqnPNxtHn4+4lX4Od+tvMKYcg8teaG9tqcEvpZbndvQuLvLOylTPwpW1aS8kNj9bJmXG78JQPr3Z1zYoTdGXq0UVG8ijir/zNz6PUXLlvMvr5m82OTyEGT1CBZpzxuwMN
 oQibhACD
 r2mBKWzYqtBNnrU5j31yJhZ51ESYkhaVsfyKQFdrWrj2CLi1/mcwz5A/FIhm7kYJ03HxJ3lmQZl3f6jzIfm/Gm+MZNc7NDn8OPbhb8qVSu2y5Er5ujOWJsbrurshyx3zqAy6PthCAGs+oCxdWDhXnYxmzygNa2L5tu1193xPpeEVEWLCmmnaMz5UHdGaWgcwJW27LRKW2fSMiyATDSImxCOMlZTAHC2f0F7dA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 10, 2025 at 11:47:45PM +0200, Thorsten Blum wrote:
> Use max() to simplify hugetlb_vmemmap_optimizable_size() and improve its
> readability.

That ... isn't clearer.

>  {
> -	int size = hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE;
> -
>  	if (!is_power_of_2(sizeof(struct page)))
>  		return 0;
> -	return size > 0 ? size : 0;
> +
> +	return max(0, hugetlb_vmemmap_size(h) - HUGETLB_VMEMMAP_RESERVE_SIZE);
>  }

