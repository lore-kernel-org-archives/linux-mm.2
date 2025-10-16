Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CD0CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 21:10:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8718E0029; Thu, 16 Oct 2025 17:10:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078BE8E0002; Thu, 16 Oct 2025 17:10:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0738E0029; Thu, 16 Oct 2025 17:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D83C18E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:10:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4A5213AD9C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:10:54 +0000 (UTC)
X-FDA: 84005222028.27.62C4C51
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2AE991C000C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:10:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tMIsdnEG;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760649053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y4jFRnAOr0dg4XHLgf1Bmfn1kqWTnjJWnkTccVUl28U=;
	b=t7e0KSZDFxpV5U3ne28j4IUcyzBtv+OUKhysfXgVY216ewqGja6FvjuwJeADR0rJi5A5pQ
	SZBZVTOh/nvpE1jzNbWtErBg+vwUBdyBzpDuyTv68+c3csuaXFqm5txNa1B/Q2NLGkwV6z
	MNNMLwn/X+JSaBreCPh8aUK4dBx65BQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tMIsdnEG;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760649053; a=rsa-sha256;
	cv=none;
	b=HLrrWBRBxIod84yr/FGOGtkJujB8NaAz/gOARQpAbbUZY4Ju3eACnaKXcMPgmXNv5Z4If2
	oOYN/1MpfTFn7oge1chm1rS1V5CmUW0RxNdmUmAFq826y0xIFsh6G0Ki4ro4tWOFmNY2Po
	olD5L0mI5WsZDSz3YJYnpups1Pxe2co=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5DA00601A3;
	Thu, 16 Oct 2025 21:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CB2C4CEF9;
	Thu, 16 Oct 2025 21:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760649052;
	bh=udbT2Uw9/9LSBWgicmhF40FOD8d0WVUT4E1G6lBM7D8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tMIsdnEGRjraIxkLmDAKIaWmx+XjAhRBRaST6evWWblC4vMC0GWML50Vu7nv0BUAe
	 U9OfHdAjpPOxm+sI/F59U7Ri4Z11dPBS8P0KCfIDu1AqULQQ8iuyJCDym0s0kHY3Qw
	 DZukSIZQ/RIEDjWUxnrlBS5TCp/At1ZtLaoJeefw=
Date: Thu, 16 Oct 2025 14:10:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand
 <david@redhat.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
 <lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
 <sidhartha.kumar@oracle.com>
Subject: Re: [PATCH v3 1/3] mm: mprotect: always skip dma pinned folio in
 prot_numa_skip()
Message-Id: <20251016141051.27e9ce8b47aa242724ae97a4@linux-foundation.org>
In-Reply-To: <0d26ce96-2c59-47bd-a034-d7810ce6aa5f@huawei.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
	<20251015123516.2703660-2-wangkefeng.wang@huawei.com>
	<47f69b78-8141-42a6-b04a-f67ba0b90ee9@lucifer.local>
	<0d26ce96-2c59-47bd-a034-d7810ce6aa5f@huawei.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AE991C000C
X-Stat-Signature: mpjcsmraqb7iemxtnu9e7sah4hwqqfnc
X-Rspam-User: 
X-HE-Tag: 1760649053-809410
X-HE-Meta: U2FsdGVkX19JxciR/QaJUBQywGn62wqAI0kNi81eUlVgKRE2WdNezHD3vqT8M5VkDlSMRgqt/Z87OsFzu4/zxfioyCbtHjVUL8TMmbIeg7Wv4hpbq1n2cd5Ab/nxybxwwpUx8fA2VKyGge94+ef8iTteA0JBk6ADZ3GRPC93V/w0Xh96hRaPQBAl14FQCxJZ2e0NgN4cUvyLacw0Q4Cg4Qwc9vwD8W5OuiMpKq3S2YmgjyQOVOQZj5jVoFnBVW5ofm4Cny+Eq9nBMw88R8iwTwuXgAQFnQrW+GLSHVZcKBqBKbnwyWoGDGHrIZaNhhv26NfC+PXDF2uRmjIgL1CQLHwHGGQgohF73AUtzefnDoMo9w3v3EVlZDYCCn5jHf1Mq3SXYVZni0uIl5X6kQd/FhdPZ/X1Wq63UDkpGxmKr7zo0jc98ZXqQFWvKVcBoxFaalfg2+D2B7nc1JwV72dCxIKe3Ks/ZHrE43jjRMTyrwefS69oUIUWAYYCjreEwelVGR3w0n0fqjP6TylgNFRJ1SX3nCcrhcMbVnUHoPZgTIjHrWl8VSP/J6vU3s3JYh6tXgJR9cD06cl7LGr6sOWKaA4ObXq/Fvlvw/XpLXXVCods+A3l/mqe29lAUBNlVFvEnVu+xh8ghLLmBl/+VRJqKpUQmCFXDjrh1cuPhRH2iQPmJy66e6VDr1B/jan2S0arPpkcsDwPvlDnOqo7swGls8AVNY3cSL4/la3t0dNk9LXVjromin7UT33Qc5SAj7UYIODCRdbsdjlSh5FIujLcDu+mleijkiuZb+L1wefXP+c6yA3/4+YEs0TEoNrpzS7Uk/cHPJ9i9BYH/xzSe30V6GKfwSpn92bx/zLaZd0OBF0wk6LtgHfQ89vxG97bqdcKbPPkfAhwlZq9fJ2U47EqfV92bROPz25z2nDNDDh5q5OUF6XRVhF1vUPMk7rwnZPtZBOHWOUUICSP3Gr7ZyT
 +En59OV3
 uZSfvtB3cyUZAtKVu6e63HscjJMT0z0hM7jOzjnNuqwxoAAMwYiykqdoaEQo+knbmOSgmyhEBwvTSKFC2JQykXyayUDNto7S95tLAiFpnqatQglaXZCpgRXGpoAMEiJnSroRe5tgDd121w7UPNWP3f7zcNs9dAOBLF8Vi67R1Y+n/mOfjOyw6Mmc8vd17P5rWNXeERP71vHZErxZD7XA2PdzHZruppWASmG5P5YJPq3o6iHw+ZzVyq46+pTDsdLhnguBQYLV8TrgYdheq4JuJeidlvFKEGNBTPB+LHxX30bWtNxT2QiMMPXYwfFXudHx8vHgURV+2akn97iIKgJkHQLw2hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Oct 2025 09:00:34 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> On 2025/10/15 23:32, Lorenzo Stoakes wrote:
> > On Wed, Oct 15, 2025 at 08:35:14PM +0800, Kefeng Wang wrote:
> >> If the folio(even not CoW folio) is dma pinned, it can't be
> >> migrated, so always skip pinned folio to avoid a waste of cycles
> >> when folios migration.
> > 
> > NIT: 'when folios migration' -> 'when folios are migrated'.
> > 
> > Maybe worth saying 'due to elevated reference count?'
> > 
> 
> Hope Andrew could help to update the changelog.
> 

I changed it to this:

: If the folio (even not CoW folio) is dma pinned, it can't be migrated
: due to the elevated reference count.  So always skip a pinned folio to
: avoid wasting cycles when folios are migrated.

