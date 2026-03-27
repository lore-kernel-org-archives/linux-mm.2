Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44C6B10BA445
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:34:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7106B00CD; Fri, 27 Mar 2026 04:34:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE3A6B00CE; Fri, 27 Mar 2026 04:34:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E4096B00D0; Fri, 27 Mar 2026 04:34:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4A4086B00CD
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:34:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E08591A1014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:34:02 +0000 (UTC)
X-FDA: 84591180324.16.150B4AA
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1EE4420009
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:33:56 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=G7p00Q18;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774600437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pWW1Ogs/ZdOFg15O/X78oW0BF6OEjLh6WF/GCRVR2Fw=;
	b=3id99kxC5JqrXcVL244mHxkb3y8HUm+hRyfAmLqiVqofQ/DgI6F2SepGTGz+Yz9rVuuCOq
	9+mLQi2M2BV5u2812lcf0rypdeW+Ls/iCkBanqFudOOq0kcHwl2vLsZ2kZPfU0FEX8lz4Z
	F+i5pgGKo0aRBMyy44tJdHqWtHtMDHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774600437; a=rsa-sha256;
	cv=none;
	b=J/f4Elp6n5iKmMHRk++Si7XheeKWJWYii87AUAqpY+y8A3liMmNfKVcbboFnWUGGTnch+v
	rVCf9A4Wv63+r884C+Uo8f9BxPisuYn+EcAwiWozt2ELRF8K23OdIA7dtSzBNHczX+SmeY
	NCIBQLhUniAJFNoPV1wTT1BzyZotQ2g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=G7p00Q18;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf13.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20260327083354euoutp02f03a8e38ac09c18735253cfd49aff1d9~gpbFs7omH3150431504euoutp02X
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:33:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20260327083354euoutp02f03a8e38ac09c18735253cfd49aff1d9~gpbFs7omH3150431504euoutp02X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774600434;
	bh=pWW1Ogs/ZdOFg15O/X78oW0BF6OEjLh6WF/GCRVR2Fw=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=G7p00Q18xvenjeqyltH6mDGbmCjnbLmz2xt4xjc/0A15A2MNdYsE6qRtkqkjdJgEE
	 gWLsqVg5bPrhnWqa+Hz2FaO3aXds6+sd5qyVYDllRfVqvjnvDbjdP5yqsbpaHYcsUZ
	 6jzaUAxPti8cVzpoBKsCBq/O+Zm/0wll3crPN9rM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260327083354eucas1p2e649b550ecb5424fabb9ad899e26277a~gpbFbCkiN0771907719eucas1p2w;
	Fri, 27 Mar 2026 08:33:54 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260327083352eusmtip241284ad9eaeb3b7cf68e4df2189c2fd0~gpbD2FF0k0181601816eusmtip2K;
	Fri, 27 Mar 2026 08:33:52 +0000 (GMT)
Message-ID: <2cffa109-5b88-488f-9dfb-8709164dd9f8@samsung.com>
Date: Fri, 27 Mar 2026 09:33:51 +0100
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v3 0/8] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard
	<benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Robin Murphy
	<robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
	Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Albert
	Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260320-cryptic-industrious-otter-5b696a@houat>
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260327083354eucas1p2e649b550ecb5424fabb9ad899e26277a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555
X-EPHeader: CA
X-CMS-RootMailID: 20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555
References: <CGME20260303101320eucas1p2eb4fea499364ef20825d0d73585a2555@eucas1p2.samsung.com>
	<20260303-dma-buf-heaps-as-modules-v3-0-24344812c707@kernel.org>
	<c60a3f30-6fc3-41ab-835a-2fdd887e18fd@samsung.com>
	<20260320-cryptic-industrious-otter-5b696a@houat>
X-Rspamd-Queue-Id: 1EE4420009
X-Stat-Signature: qmmbrre1z6p5964o4i3u3kxtw1fgq4nj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774600436-266288
X-HE-Meta: U2FsdGVkX1+7M3YG5ZeLEcX4Y6WBYBAnVxgPauvx5C7cAPBoWLr+qNosCXkrxUxmDqU0eraveMWzmbH453r/8o59PgT06DO37sqFdnEzYo4EtJskSG9q14LqYFWTD8RUZeGPHrgus7dhPV96WEUE+mp9ueLHPiL9poBZRYvmqKfXvkR2WO86uw1ZFQ67g8SIFnDhoycWksxKXp5mf+wl5n8/S2ieD3gux+0bMcYDhP+zD7RUSJHe961fLVcmhMreXSG0TyBvzkKOHkMavTf/Rwk69XnP5WP+PvCMHrAIS0IxL47CQgVxgC+wJ+42t7ej1wroHqILQZnq39Sdh7s9Os3S2FwkhmRDBWJknYTFqtgDbzbvw00ba/0+k1EPP9trcpltn4975p/iQIEOzVK/hSkZvQFedJLPeMSTiWFXo+Z5vwUw8sjcAznVhM2Dlf5wH8/PVSQXaZfSEAj92f9svXhkU38Nx7bw5np2zCnmVwq+1oNCMw6vgHvjUg0nxsh7QasSbpFAWBe8BQwnL/OTF1EELQoGCIwkVtsua9R0T36ZPhQbmX98UdAfF2telX0JnDL/9lYDKx/Keg9bggrV4+OvsZPDEdXOhTpsfBxRNfNcKBQGiQysCxiIXgY2VoppkFivH5W9+458RboC+XmL9/8aHRyP2k9mOs5ciMmm4JlvTUaR9gILMS5UzTvD+WgfoUqpJZco/sLfW9Y1tLvlJxPtRzHUmh4MXdWCPGoD3qrYDmyeeI79tvaVvSflvhXLlu7Wfc4xlH3HAI3nC/c99iSlYGqw7dIU6BxE5FDAAJrzEEOcpPruzV3cV4dxBhxoEPhOUs+Xemz63UVNaOijn2plvZX/cPGMYDCJGyJWeBnarT1i+0JtiqGVUmm1ygHvQt/hvbkR8cHnY/eEZ8RlaCT9elxSUegvFe1l7TmJZ8UPS480nZP6JsDV2RA/wH5vxUlILRkr2VZiA2DsBXe
 bh40Es1i
 MfuOhaiHptKIn80ZZoEz33d+cToO6CKMmgnYBltt0MVSsUVYG/j46a9pY+10sob5r1LyX8Hwc2X2RJGId613jLfLpG1fIea3/X2DJbdqXkw+/nGsKyKNqzETW/l2DvKzHF2QY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20.03.2026 14:09, Maxime Ripard wrote:
> On Fri, Mar 20, 2026 at 01:24:18PM +0100, Marek Szyprowski wrote:
>> On 03.03.2026 11:13, Maxime Ripard wrote:
>>> The recent introduction of heaps in the optee driver [1] made possible
>>> the creation of heaps as modules.
>>>
>>> It's generally a good idea if possible, including for the already
>>> existing system and CMA heaps.
>>>
>>> The system one is pretty trivial, the CMA one is a bit more involved,
>>> especially since we have a call from kernel/dma/contiguous.c to the CMA
>>> heap code. This was solved by turning the logic around and making the
>>> CMA heap call into the contiguous DMA code.
>>>
>>> Let me know what you think,
>>> Maxime
>>>
>>> 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/
>>>
>>> Signed-off-by: Maxime Ripard <mripard@kernel.org>
>> I'm okay with the kernel/dma/contiguous.c changes. I only wonder how to
>> properly merge them. There are other pending changes to
>> kernel/dma/contiguous.c file [1] and if they finally get reviewed, I
>> would like to merge both via dma-mapping-for-next tree. Then I can
>> provide a stable branch for merging the remaining dma-buf pathes. Is it
>> okay for You?
> That sounds reasonable to me

I've applied patches 1-5 to my dma-mapping-for-next branch and resolved 
conflicts in the mentioned kernel/dma/contiguous.c file.

Here is a stable branch to apply remaining dma-buf heaps patches:

https://web.git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git/log/?h=dma-contig-for-7.1-modules-prep

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


