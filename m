Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7601C109B462
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 12:54:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0476B0092; Tue, 31 Mar 2026 08:54:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6610C6B0095; Tue, 31 Mar 2026 08:54:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 576806B0096; Tue, 31 Mar 2026 08:54:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 453E76B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:54:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE2B61395D8
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:54:50 +0000 (UTC)
X-FDA: 84606352740.21.EE0F626
Received: from mailout1.w1.samsung.com (mailout1.w1.samsung.com [210.118.77.11])
	by imf05.hostedemail.com (Postfix) with ESMTP id 077BA100004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:54:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CWpV19df;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774961688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDPXxR0SE4tZo6SAHEuDV5VawAn9RHxLdc/GV2ahcmY=;
	b=AIGkRHlBwVWIiw5OWUVZnq9S8nJhkd9pFvaYNVbt3uu1YKsw6cRpnvqDprLVgdrboIqtGE
	sEDlnDr6011b7kYIRCwxH5O079ta6qxFal6Hw+VGxbu/9csYRzzCTZpw2/f3QLKjxBcOzp
	zwc8Y5HbM7GcwTGNxi3MVQ4ve3BD5TA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=CWpV19df;
	spf=pass (imf05.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.11 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774961688; a=rsa-sha256;
	cv=none;
	b=XQjNvT+l43wUMs7kmx9IGKWq3mJV0ee6oTu1V4EM1tEXqBYm2iiz7Vd8qIEfAAnNfhmdbT
	FV23zsZhOebpLzD+b2NNczav16ggiTyKEeGkoywxeM7hsBxZbTryPFu1un3R3w3/tmJGz/
	CC1XJSqiCvl8E3+z+haG+5YWQVJKL8M=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20260331125445euoutp016d9c13543de9684b45ade912a6734af7~h7j_7-fRx1994219942euoutp01L
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 12:54:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20260331125445euoutp016d9c13543de9684b45ade912a6734af7~h7j_7-fRx1994219942euoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1774961685;
	bh=UDPXxR0SE4tZo6SAHEuDV5VawAn9RHxLdc/GV2ahcmY=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=CWpV19dfi3aKCVmn65P/Kj4WMSYU8Y008v7a6iPLjcfr/70u3PHFeMS5bxMdiMZpP
	 x/IkU/FWyfkJr5Axx5dbEaTf6T8Qg4Y9YfiHyfr+sfBLQplBnBvNX4Aus8e4NcZB65
	 FW/pNTtgcFQ0o4nh7Ov1X224Nh/y5TEPxJRmUrRA=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20260331125445eucas1p25ed7c9b6e702e473313d0de397658d96~h7j_m4aJp0030700307eucas1p2_;
	Tue, 31 Mar 2026 12:54:45 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260331125442eusmtip20a0364ea267d99390b05fc4b52f918c4~h7j8E31Ay2848828488eusmtip2b;
	Tue, 31 Mar 2026 12:54:42 +0000 (GMT)
Message-ID: <46397de2-eedf-4e09-a83a-3b683d154fe7@samsung.com>
Date: Tue, 31 Mar 2026 14:54:41 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
To: Maxime Ripard <mripard@kernel.org>, Sumit Semwal
	<sumit.semwal@linaro.org>, Benjamin Gaignard
	<benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>,
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, Robin Murphy
	<robin.murphy@arm.com>, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
	Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260331125445eucas1p25ed7c9b6e702e473313d0de397658d96
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8
X-EPHeader: CA
X-CMS-RootMailID: 20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8
References: <CGME20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8@eucas1p1.samsung.com>
	<20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 3dpu79wdttgpapyfqzsidc7foky1xmha
X-Rspamd-Queue-Id: 077BA100004
X-Rspamd-Server: rspam09
X-HE-Tag: 1774961687-117452
X-HE-Meta: U2FsdGVkX1+JcQIuOQN++bbHkyRpZ1p3G5JlZJnb8i2YAaHR/1xqU0kScLl/KWOwvUCYGRmWOilyMuCfqeQAKOfLZTLhYE7iLsDx6Cf6+fWAqs3fdmi8ZYzuiMhkc+U98mR5YN+e1C24BMANS77GoISqNg64TdSVJHpUtEqD+34oEpMmSNjIFljosuXp5i/QXq2MnBE+efaRd5etqaMvpp2GwwroOG/4nKQ2kb7+L/bFEsSf7lx5SkTJoy/bmMnnrCCz3NDZnrjMDmyfdCHevMEYNQPXE2xZqJU6wvcz7vfsT3uz1PRpyIMoyOMoyIPGIcSSR5XQOFvBhgYkXQnWTIQzbp0D1NxZGpJPzqnIn1luGnWMaFqbBhlTUzM3CO9Bl76sjzIZgIV/xO9AqooTrqcXW6pw/ssLSHrYdjegkkFlLOnP1FGGVUAcBjZbBVM4DxysvPoQlmVOZQVy44HnqyarGGlLbNux3tLglMCxPlxFFEW4hffmcBm0IhKiUGwkguy3Cug/DoY0av/uxG6dOC3mc790k2FB0+RZZ1GXSjNApEXS3UezODKc1U8UPrKthfEimoJfMLdjUcj6igiaR6OgfA0A9TLvfr6/0BtBoEyHhjRhNd4kzpE9AsT/hM+6olysh76Oafvj/sHDjPtls2RPSpXDFV42UNeYRIrnLt76xg5oqJ4/hj+hEaa2yO7cXxDfXYduBcvtpH/HCUp/T4pNbgoGC298XVouFVQHugvy2o2MBI9ZCfL0R6i6NP+k83gAakVnBhuPM6EwG4hbRD+jjzNHPfjhPK7MbP3ybsLP8XX26xdCRr6DQKOkvolV36f5yM26ZjoYtABjLv4Q8s61/NOFNnRuTyFOaOID350snU/OdAsJ9Sf0LgJ3nov7krDKA+uaq4/1CATzHQjc/xM01HrlYEZ8nYrEIPmYIwsZek1Hql3otiW51bIfwJJ+YK3C7VWUCjHKkU80nOk
 lR0n58KI
 nSL8I1aUOrU4k+acfNIGSm4ZvJ1Z/oWflHyk2828058/1Y/Z1yycZXnccdeYDu03nZqJZvJyLarf0eScdbb+NgS4ToLRNLWZurBvc3V5tvDXYT90cGSyulRhplRx/pq+FBYIZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.03.2026 12:00, Maxime Ripard wrote:
> The recent introduction of heaps in the optee driver [1] made possible
> the creation of heaps as modules.
>
> It's generally a good idea if possible, including for the already
> existing system and CMA heaps.
>
> The system one is pretty trivial, the CMA one is a bit more involved,
> especially since we have a call from kernel/dma/contiguous.c to the CMA
> heap code. This was solved by turning the logic around and making the
> CMA heap call into the contiguous DMA code.
>
> Let me know what you think,
> Maxime
>
> 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wiklander@linaro.org/
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>


Applied again patches 1-5 to my dma-mapping-for-next branch. I hope this time it

won't cause new problems in linux-next.


Here is a stable branch to apply remaining dma-buf heaps patches:

https://web.git.kernel.org/pub/scm/linux/kernel/git/mszyprowski/linux.git/log/?h=dma-contig-for-7.1-modules-prep-v4


Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


