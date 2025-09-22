Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5881FCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 21:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3EA98E0010; Mon, 22 Sep 2025 17:36:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEED28E0001; Mon, 22 Sep 2025 17:36:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04798E0010; Mon, 22 Sep 2025 17:36:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA8C8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:36:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38BDD139D88
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:36:30 +0000 (UTC)
X-FDA: 83918195340.10.B4FDDA4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2085820005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 21:36:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="YCZr8/+X"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758576988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3pT42O3ALLdCjivxUa4nPm2rNjCok+zUCphhUS9RBqQ=;
	b=XRZmMLdVvCXb1WFWcR2XlJRe0qp4kywxz6WrK5LKW9aEnQNX4+2LWHYipdAHpwZqIm68Yi
	n9xvQK/SE/TGTSpJGsX1W4Ul5buvIbmuTXTvvdSrbg1NE+zQgveDZKhLs9boU00ieHODfk
	P7LpOm8ijr51miNEMwUEr2oUMVRf3mE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758576988; a=rsa-sha256;
	cv=none;
	b=ptEvlxFwUZ1Ahtmu4SLYgph2ieZ8jPlgKxYWNY5AtpVCu601RQ+O8tBCUcwCbeQ9cruXPZ
	LNDi3+Xym5RoeBWDgoxbxMwQNeydrMOnuc/3btEj4OKu97R6x5BweuqYiKUs6WIqGY7IW5
	0WDby5x9VIlOnxRnDdGQl7kVwbSb7HM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="YCZr8/+X";
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3pT42O3ALLdCjivxUa4nPm2rNjCok+zUCphhUS9RBqQ=; b=YCZr8/+X7HAem/+HkyusW68aIw
	GThVTee7I05x7xYEZ+8T+9h92OBw0gw2qrO4B7izQTysTBYiO7My9gCoLFM82EcdKPX2LlVHZq66P
	o8X7muui3AprZT4818FRc8VXpDvzPmnG+CGbq8qywbjUYaiL7lz4S7VAB6RVNDDdCBoGq2bUFjLZB
	ywyHkKeE4Uzfu2kMKYSWo2DXAyCLpUMG9jHOqNZM42Hbde8hK47YsBKEtar21GCZVhw++V5DZ7TU8
	n2lDtit5ChDWlhKxVHIe71XLonsKstOHsFTAE2YbmtlZk+PmLT1ZESug+wpMVEnDj3S6v42QvUAdg
	2pCJJS2Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v0oCm-0000000FUDX-1i4C;
	Mon, 22 Sep 2025 21:36:16 +0000
Date: Mon, 22 Sep 2025 22:36:16 +0100
From: Matthew Wilcox <willy@infradead.org>
To: I Viswanath <viswanathiyyappan@gmail.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	linux-kernel-mentees@lists.linux.dev,
	syzbot+94d20db923b9f51be0df@syzkaller.appspotmail.com
Subject: Re: [RFC PATCH] mm/slab: Add size validation in kmalloc_array_*
 functions
Message-ID: <aNHBUJxAs-vomIF3@casper.infradead.org>
References: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250922170357.148588-1-viswanathiyyappan@gmail.com>
X-Stat-Signature: wya51g35hx77jfjtua76eo3g9opf4ywm
X-Rspamd-Queue-Id: 2085820005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758576986-357911
X-HE-Meta: U2FsdGVkX1/pIHLxZofHeu8gHrHhmrTlztoJfwAjWDcboNG5/T4ENiHUB/MxGcXw3WTTyv955ded6l1J7G32OSqfGl3jBJFV8uWtPZJWksKRIDxiTQMTvFkgkD7O9wA0OdqERYPFzL7pPtY3wSDk0nDm8mUfCNc+7+LI6eaMncN1CVrks8aEEY5auLoRjLiJdp5E5AxE7f4LOXgMGPgNxIIRH8J0EszABgc/4x8onwxaI1kjF/s4EqJBpTHDn07iopIdKccRGk+2vVnmVX/b6USH5fPZzYEmQ9NzSpVBnofSR2adsuJbSPw+KV8/zB3e4XlVTJn/B4N6gxGXVStZXgsajRp3jA3Q4TVefbyXaPCbjWKel3BZ1OjF9ImceQ6TGWKfSvOTxtt32FTzdArs/FbeSox37S7/DPnT/TtdT6RTd7lSLeGlQ7qlRmYflOLRx6UpMQwENA5qBu/qrEotszz1UhcPxvL70OcpBU+C4QY0JH14RS2TBry9+CnMU37hnth6rIz+Qf40fUoWKNv7E4xIi31NpAtdD0Jdycy9ILjJKenIj6biBX3kpawU34BgRppuRDZwSYjdU0x+r4noqkiKLJAY0SgGl94JpiCepIQNgFn6NM8O8R1gFFPPka/4ewnox9gyQl9P4s78SRuktzJ2tAukub0SgXT3jhToN6xw+kQ+7AeuKbz3RN18YGW3CqP879yYGiac5JKy9M0dijtE+2XblkRAAH+4UA2Qy42uee64yZ+g4x0u3qPmaf7HSndKKnskx6BAsc0KlIhV1dzv3pNJ5dfZkoDarzErwcEgIfEF0JFVBdLjVS95PwDuS6UX3rVXuC9a0B3ppt09Pdt86hFIhG0IWQOKxzN2v/v/W71QY96b65/dRmjDtScODuMP8SX3m5REXCYQIafRONZ5KdGstQyVJIH7HlkeqbTinjjRfKREj6kHCklGT7/+S/J+fRDQp8ZRK/rYLhP
 /++lNm7+
 k/1llKo2cjd6g8Hf8i1qT2BWM8JlkgY7WWsc5SnF+KNN9a8y9jUdezHF2xw7sg3hV5nE52wFKgDPoG9Z0M0iMfXgfyELMYLILrGacFzRLMDYIfHM6swGNoGOySCHJUkU6Hu7unDtxcv8NbWn/mgorI1JJqnRJs4FcgA+37Jzx3ZRWsW5HVj7+FmFEVrRfEySOJ/7KGZyl29DmdEYPMNFcM90vews+0W9mwLMZZNACkfHI4onOXImRJ0NM7ifNBONc/EyummwlFG1ydTjM058Bcvq43n89EacYXGXADTksHP8f6eGLbL587+H1Zt351/LOpO44
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 10:33:57PM +0530, I Viswanath wrote:
> This occurs when the size argument fits into a u32 but is too large 
> to allocate, i.e., when it's between KMALLOC_MAX_SIZE + 1 
> and UINT_MAX (both limits included)

Is it really a good idea to support 2^28 vclocks?  Surely there's a
limit that makes sense to the PTP driver.

Beyond that, this should probably be using kvmalloc_array rather than
kcalloc_array().

