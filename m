Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A10DC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 08:16:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421246B0088; Mon, 20 Jul 2026 04:16:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1116B0092; Mon, 20 Jul 2026 04:16:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0936B0093; Mon, 20 Jul 2026 04:16:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E9EE26B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 04:16:22 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 60BFD1406BF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:16:22 +0000 (UTC)
X-FDA: 85008447804.29.D9BAF85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8BD2320007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:16:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tmu2ds2P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784535380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zAAiznWAE34Wx4w+Hs+s7p3pGYO+pyU7VbYpIEPy5ro=;
	b=FfdRNKYQmp4RLG53m8I5rJLSUU30JNkEiwCmoX93pnAi2NwlIULjISQ29AEGUBCJLUcI80
	KPwMdgQAyW4yaF3xHdu/lQUK2ql9oApMdI0FsXZDwxnZVrDRLytoazzxV6wqoWGK+JnXXs
	f/2qH7/nV3Ojhu/qBRY6P0YijPiLpuo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Tmu2ds2P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784535380;
	b=r9akC4I10GDjzeMNnsBvOdW6e89KGLkl1Gndh3xp5Dr+jYpXWrwqjHjTnNkJSsKwTqXJRr
	Y55FvOyItrCMsrCaHWdrQBA0U1s7Yyz3y0l8Crpni0v/ilSqhH/3vcaRRyzgkZGSYcZCR4
	Bpd/uDU2MXEynmHXQR2ezUglm64txXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7781437FE;
	Mon, 20 Jul 2026 08:16:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C641F000E9;
	Mon, 20 Jul 2026 08:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784535379;
	bh=zAAiznWAE34Wx4w+Hs+s7p3pGYO+pyU7VbYpIEPy5ro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Tmu2ds2PcLIqfDtJgNJq3itmcvTcEDkSaCXfgzQytix2JZMJK6a1rSgksiQxKBStb
	 fCyAzyU4/P75dhHm+rULbScI7mj/+l8XrIxsX8ylcuyoRlisuJicDN5iIwIaJFKPRX
	 VJm6wOO7cfNh+NQzyYb9eIHIPMj08OfGQxFgit7WKtsTAl9/UCWy1bkvWRW1EwioWh
	 2DmCfRTQd1mVGWL36zwsm+XQt83AzLupzTwd8aj8qbrsOlMdQsW9NaRJ6t3+ZFmA/z
	 OLejJ+YAVQWeVOqCcGsalx+8O7tXj0fYZi8mVyEvENipMCFqtgqdNrdB9AILGiMTO7
	 zWyF5luLRYQYw==
Message-ID: <6adafb9c-b966-473b-90ba-3432b5574039@kernel.org>
Date: Mon, 20 Jul 2026 09:16:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715120813.3609949-2-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8BD2320007
X-Stat-Signature: 8atmuecjh5s3eixuxyk44ri3yfx39uum
X-HE-Tag: 1784535380-76096
X-HE-Meta: U2FsdGVkX1/zS8gP4DjYIvxM4lS4kcM6GIrD3gIoukxVyTvMIQLW6d65dwnWwIvgd5J9XDVMSw3YUwK2f3j8bgms1oXACn3nUYIMDqWLbxtPvIvAElW8t26WuLxbvF9vwbfGhHpeNqZjOm+6s8w0ELw7ox/mT7sV++GIN8c43USGnnXcdaWd6qCKIirkZqoJwDeajJj0FZpvH92zsxL3Ovk7r6qGX1yyHLcYPzMFfaqymZfqT3PGHMEBU+Q1nGfYpTXwneVne009RgpUN9i78Q5tXmTE67lGQUzERYg8e//ZFpaKDoZi/9Ynt9zTRUs2wVEh5EBogHyYkn3SSFW0kX3caxFIyFkKS30y6lHPbjUdBhWWeo2e1GCgvDaY4OBqKh79xfyORrsLESI09gQ2C0skJWVlfCa/31XWyVjozRlnmZ2wlaqJrfiN1KjswAuSW4CrMZAEvvDc/rMVY1varsW3/JDfGhGy2/R3NWqO6lN0e8zk9q+LnC5JqGL28K/Sk7rFTojIFXRXQ0W7DJU12k81plCuBytnpytdDJbSXP2sH0UqXXPWLk5AE5R8SpuI7KZ6UTaUHZDYojy3KkzASais1A1B0sv3swBxVlUHK6ELgxSsFtWi6qY4pEwB82ReJ4zpu2d13ElxJLq16Ve0b8ESZMeBbLXhEce7v8k6A9FH72ANBIoCuTa7fY3ZY8+zSjDRKmiPEBJYRM1nb9Z6G3Ac1IkZuxQbCXi/8qRhDC6w0PjwiLZR2y7Hhjch8vwB7gjzu1k9BThKaq9nWgwGYeWlElFagQzT8+a/DGPXEVeox3gfP0onHxllZ4Vv5YaN0AZHoHt6SAI78QSpad2yHZRtKNdUL18b3nvk+dkPrf7yDOLacJxnY7riNbuZ4LprAx920RXkTIgM7BrO/OpHDfNV1N3Ro8dCQm7NQzDhSExEa6CNu2Fn7/zVvrfFIymPfp6kQ5KLsCcgxoDjtQ0
 v3nCBj4f
 TME1eF1F31cUmEiyT/sFo6bUuqSCg+vy1PV2JFhcq2zLLaT3MdiPRhRbSH1zdPxTbEYB/p6s36+nWZ2bqaKrd7XskisyepRGUlzD0Q/EZeHfPsZx2Ai7/GSG281n3/MnJBfEA6EKpL8GnXllk+Tb1BrHR0f8id616bjuPoSIMpCLloTMmCk25HrqbjSVLIncqyeDnuoFFS8MYmlAwlTN+2a5bx6yaL4iIbaBbYwpLKuaStYy1miu7I3rVq69EWj8lu7r1JdLNhMOS1otXwIbqfeh1izOOzSfscAuguyyIjrtdE/CcUxdnEbb/hWaWXFSTFqvrD+IXzjvA6KJ/u8C6fG6JAK1down0YnzVYMqyGtmEOih5Ec9dgqz4FAsY0CNjqAZAzPcVA3vNH9V8TNXOR4Kx4Q2CJ8ILcvah/JCNJgoWeiEwRFgF2yI9htmA4v0ULvBMw7TiIEPhjMJfiH8DEFL2i3IYIr9YcdikVozxuN5U07kp6A9jA5aqJOerfm8eRZ9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 13:08, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can handle CONT_PTE_SIZE groups together.
> 
> These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
> mm code, not new HugeTLB hstate sizes.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++

Huh, why are we touching hugetlbpage.c, which is HUGETLB-only material:

$ cat arch/arm64/mm/Makefile  | grep hugetlbpage
obj-$(CONFIG_HUGETLB_PAGE)      += hugetlbpage.o

Something is off here, if vmalloc ends up reusing some of these helpers, they
should probably get moved out here into common arm64 code.

-- 
Cheers,

David

