Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E23CD37BE
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:15:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036426B0005; Mon, 11 May 2026 21:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F299A6B0088; Mon, 11 May 2026 21:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F5B6B008A; Mon, 11 May 2026 21:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D65CA6B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:15:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 70DAC1A02EE
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:33 +0000 (UTC)
X-FDA: 84757000146.26.4979771
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id B2DA5C0002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:15:31 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RcWOCmsL;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778548531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW44Wd7ILrG8/lbR6YqVSYLCr0/1NbP+Yw09w8LVxC4=;
	b=evaqOztlX9yq8qxpJxho5QNKucVedaJvSo74108ZHjrxnPHxU1ctagwARs0FVHR1g+kotU
	vnGq2MYrCQqPr10xITzs34o1l7l+pxjkdRck2rq1x31M+o/886DrRbeBoNrnyj3EN3HO43
	Y4GTB4BeP2cXKelQeBxtHb8t0Z13kVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778548531; a=rsa-sha256;
	cv=none;
	b=HJKTFUWbMPS1sp/eGubZnBF9fghqWvYWVtXA4K4j2TYIz2dc/cEFZlVLIzkw5tnt/TVMcY
	cQHSJzecDz18p5xChAQM9AxxNv/E2btsU6OAuB0qD0wuV7uEZKP1qx1DqrTOS/MsI/uVbQ
	1zdyAf7NBeRrrBYwXY3ygV7p8vuE59k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RcWOCmsL;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 02B316001A;
	Tue, 12 May 2026 01:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 562A9C2BCB0;
	Tue, 12 May 2026 01:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778548530;
	bh=HVbILOszcupi7Ik7PLfUO7G0nFiNC1ryLLFURZp+gYg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RcWOCmsLH00BUVroBg1mMxU5PA0Dm+HQFg2RWuS7qR3eKvEq4kGHYhVGB1WXH2yyF
	 uPSRaIROlVqRz9R+e4IF/NvYH1TwwBXGVWPqW6s/6sneOCvifzIOBhpYFaO9yZ3yXC
	 O0tvE4xb2uQmMbb/hXWTIxir6jeinjGtyw2wDSHc=
Date: Mon, 11 May 2026 18:15:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, hughd@google.com, willy@infradead.org,
 ziy@nvidia.com, david@kernel.org, lance.yang@linux.dev,
 wangkefeng.wang@huawei.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert
 "tmpfs: don't enable large folios if not supported"
Message-Id: <20260511181529.a099f05a9d96986d5e88a0ed@linux-foundation.org>
In-Reply-To: <b1302558-e5a0-4963-b9ed-533d35dea802@linux.alibaba.com>
References: <b2c7deee259a94b0d00a7c320d8d24d2c421f761.1776908112.git.baolin.wang@linux.alibaba.com>
	<afnKLEIaUd5A22ls@lucifer>
	<afnKpTo4cwh9LtPU@lucifer>
	<b496c241-006f-41ea-a398-0e0b7c7e8472@linux.alibaba.com>
	<agHFZkeeCx5OEAu-@lucifer>
	<20260511150158.921c0ac72b31a6fa0a125ab8@linux-foundation.org>
	<b1302558-e5a0-4963-b9ed-533d35dea802@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B2DA5C0002
X-Stat-Signature: bi1ifp6b8m7s13bikzo64irx7y35yk3u
X-Rspam-User: 
X-HE-Tag: 1778548531-252202
X-HE-Meta: U2FsdGVkX19EbhCFBdjmg23tuhHu0jYnhjsWNWvig59qdbJZgX8MhkJHDDER2jlzL3koeGTBG9C5KtDtc3CZdYzNs3ntgWtdUcXe2qYYwEhfcKZf7MwpcjAWpBlGk0OYO7RlpIRg7jQzmJQXTarasRRjmDY0VYvYp8VNNPf8ip6NdKq2Rt4LOE0Z89Yl2T15xhDNOrgQPVlZtiTGBjB9/omdC1sqNMlag6N39rKLcEWtia2rDYtHH0iC3AM6LSogKH63D7DanRIg7ZFn/Va4lJHf6NCdGlzFV6uAoixfwru2iggFH5XctDHgiKNsr2pjPNqaASNbXUp+LGGRzoF3RUp3AvOfRcRv128aw87nbuR3bgS5UwsqJF9FGyPfxxvO9EOOauZlsHXosx8UxZxMgBWMMaJVEEyniAS7gscoHA323sgwuISu5dNWcAmYOYENt9bZk0Psvyv3lj28mM8t+7PdDAGVALwHtjnmKyT9y4MFTjVJgRwBop374MEWVPfWDX8m2pPaEND0dvNrYz3zZYdzE9eHDNibPm0RwLgvUt8qKyUzrJlKpxD2ox404P07xWUCRNMJBJWxaDlLCTXDwclYlu6Xa5th0iZ8iTZY+cN+AlFAkFKriabXQ9BfDWPck3RzK1S7PGV7EU9f8vNasibu5A6Co59YE3x0ejAGtsXEKJ2QP3L5bO93Ff14ITAx8ELVA3ATaR+zvf93+5QA8QRhqLwQThHNXSPKAT9sSQ3ZE9TCriD8/beMsQfYqsqBG1VPkaek0d+3q+XbLJbTHjXr4aJqmXJwpCaqfsOc9FAEhcCHHKW3o1OkJUXfoARmJW7xlZuMjg5G/G+OvwKab8ADbMk6TcrrKxkWhMp3K2bPFlR0bcEPFyVQG0akaJ+hhNxDKyvg8rE0bmW6fiJrpEihLLJz9gL5KfXBh3FbUsaqMugq1YTQ+MKP05voH0bn5j32CH6cocXMdw8KIt7
 Aix0/RUN
 m+Bi+oWIQ+re3FenbP1+eHRPwTLpNiGMd7Ygd9w4AgAGs1Sa0awcoBm7HGIFj55ADMa6sk6bx6Oo4R7tz2VBPNfOcGKgHiT3LqtmIaxYN5nNO/OELlO73eC8WgobCCe9O0d0BoJRFCdQCWbLasLdsuH3+pjDpSZsvw0ryiUAHLpWZNUZ9WRtwcxB2iMF/8JgVU2hg1xuUS8kvlYIBdegtPlwYZ7BTgf447HP1sHaMmwerl4W4qJgrjfJI+WEZ8ySs1uJura1tClcKnBGUgZXbLl8s9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 08:55:05 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> > 
> > Please let's not add new metadata without having told others what that
> > metadata means?
> > 
> > "Fixes:" should be sufficient.  I interpret Fixes: as "apply this to any
> > kernel which contains <that>".  Is more needed?
> 
> My concern is that if someone backports this patch to an older kernel 
> version without also backporting commit 665575cff098b, it would cause a 
> performance regression.
> 
> Is there a good way to mark this kind of dependency on another patch? 

Not that I know of.  Has someone sent 665575cff098b to -stable
maintainers and asked them to treat it as Fixes: 5a90c155defa?

> But I've already described this potential dependency in the commit 
> message, so I'm fine with just adding the "Fixes:" tag.

Yeah, I guess the supporting text will help clear confusion.

But you're right - our tooling should be able to express such things.

