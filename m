Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDA90C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 21:34:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3826B008C; Mon, 31 Aug 2026 17:34:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2D986B0092; Mon, 31 Aug 2026 17:34:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF5866B0095; Mon, 31 Aug 2026 17:34:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85BF16B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 17:34:26 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D884140261
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:34:24 +0000 (UTC)
X-FDA: 85162868448.07.A66530C
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9ADA21C0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 21:34:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=MMrdVUqr;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788212062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tiLQdS9VqOVY2M+173eU2VxYzYbYQ00f8q6FKkHANzU=;
	b=cALkFksrhe8B29l5QVL9dW/Lkw/h0xH6YaE6FfPs3B8HfibtTWOBGY4yBkCEEyb9yDrZjN
	bmhS2PTWYRuyEKODqjuUdd54pTz/BhwM+n4XtrC5ObSFWny+PZrhNPmzxoh4DlwJe9gnTK
	E/0AakN+k7Ls1neTEhQDd+mvwNoAwtw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788212062;
	b=HMowvEYDUQLWfRx7X4fIrfqpBwmMxP8Kk8egvKUdL5NDxxSz5VOR2Po0cLFm//1OHnOw2G
	xoqlnc1qE72aspZfd3pBt0G9QI2J381gZjuKjoKScdkQ7QO880WyvGnPDgcb5X1B8YFLN4
	J8gX/fP2A7JlY69fhfAntP547qpMgvY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=lwn.net header.s=20201203 header.b=MMrdVUqr;
	spf=pass (imf20.hostedemail.com: domain of corbet@lwn.net designates 45.79.88.28 as permitted sender) smtp.mailfrom=corbet@lwn.net;
	dmarc=pass (policy=none) header.from=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net E2CF8408DB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1788212060; bh=tiLQdS9VqOVY2M+173eU2VxYzYbYQ00f8q6FKkHANzU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=MMrdVUqrZlPWTO3lMIJF6yDsyfP4fy3aExJyS4RPKowLTKwyUXCy+jkiZRQml70vj
	 ZT6UgfKxuWWZV2jhIACuSAafjsqCYqRIuoaLttYCJncgBdi2UWrvw8fPOj0ndL5Vj2
	 B9Hak/pWhn7we9oxVc9PfUWPEdwMVPKLmHzrnJ68Jja5byWqKX50fqaclc9xwDx8gB
	 stY/xAXa6umDeoexXdnmcVMB6EVGbGEWYEaiVeE7bogpsC5TUM9bgeuqtrWUpj7tQp
	 CHu7pfJvgeaQPE3/at+mso8wqlx8D6EqO0suJ4gdWEvDYn1mRoDjH/H1DdZ70cPRBf
	 zfau6hqecKTcw==
Received: from localhost (unknown [IPv6:2601:280:4600:814::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id E2CF8408DB;
	Mon, 31 Aug 2026 21:34:19 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas Gleixner
 <tglx@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>, Petr
 Tesarik <petr@tesarici.cz>, Bagas Sanjaya <bagasdotme@gmail.com>, Michael
 Kelley <mhklinux@outlook.com>, "Paul E. McKenney" <paulmck@kernel.org>,
 Boqun Feng <boqun@kernel.org>, Matthew Wilcox <willy@infradead.org>, Zi
 Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/7] docs: core-api: Fix stale function names and a
 broken example
In-Reply-To: <20260822121651.1559-1-kmehltretter@gmail.com>
References: <20260822121651.1559-1-kmehltretter@gmail.com>
Date: Mon, 31 Aug 2026 15:34:17 -0600
Message-ID: <87a4q2gejq.fsf@trenco.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9ADA21C0008
X-Stat-Signature: fa9ymzkzmowk6wsy6tjnca1dtanun73n
X-HE-Tag: 1788212062-113606
X-HE-Meta: U2FsdGVkX1/BSGgRiZE7svzXFKNTiM/hKE/mtGOVPZ5wFKmTMbwNuhlvZxZ2SZomtPXrjZaBX1K4UVitrdvZGdQ8RngZ7N0K/8azv8FUeC7U8TUqTt2AD+j0fRk7hlkcOoqoC5jN5plwgXhEvbLBCzxgm1j8q1wbvC6/ny//qu4gpiB2zaf2dq54eXRKPRA4/SYHupEQY9NAg5ydfLhiXTjvv5nVFUel8smjqxTAbFP072Txql8K5FreaOFIHp46w5ldsDWczD2DMmz1Gs0iHDqSN/E+JEXtQM2SwBSigdKjp8gvwLQoHo8cgak+OD0MSqhroxWgxIJOwdU8NNPTALNVIdAX2Szt8VHvHfdxN+MAnSqY70BEK3pvgm2b0VLPasQXyM9u+E77dNyY/AiCuIEF11qvEVzoAOBpzIhhFbNMTQBk3I6vMzheLzAMiIly9G44WfQ/zYHB8kUdwksT3nZ+vkE+KEe4Z1EfkAyfSDd00qcp3kzMUtGPxHrvgsed3QCjLeaIfKdXRmzyoHaREahN8JRI0jIApZA+kf7NYAdKjkgZ6F0uYWFfTMSrTbeQ3JjHYZS554W6x+96IWiEW1thCYSZ2PTlhIv4e4+4om0xsXcEY4FMU6HuQPqlboVtID4n8tI/Wi8tsGXHmp2nuuTcSMs+lRrgOgehfHJ0oNyzE70biFakcOdvYUQVHXsK7BbjeqxiNItAhhnQQSS2Io+Mfne72M16iorzT+TmK53JTl/IFfAFL5eMXhqXXMnLrriWHxrzN5CklAIy2YU8RMhAPT685SGfIFS/9jHsrYa0sU3OufstJAMUNQBq4BmS4m5MPtP973TMzsfq4k4jMrvKopJyzHOIpG/BKjITEAzbwRpi/w/DS6f4knTHU+eCDtTDw3xTuZ/rT6NaXfuv+aRMcdfsdQTJdqCORsXz2E+0lZzTfpBSOZ7sFFczt7FcTXUI4Y1GPGVVuBpfg9f
 iwXLulsE
 tPadqmDVmfQ7Oyhfa1b3M826N/5XPm1E05jUTx/lnpCt1KBodPjF/AfxxtGJPJ/PCDDRWO0rTIUBCQWw71F79go80Zsgw3UusX3EJIFO/YsgH7Dp1o8xuxLy0HgXpgSHPZspdJZ1SKINmY3iMl7JoAmDO3jRwIdzSGk0rzjpizXQOMYLJ7U1nWS60RmNzXctJhtr1F6G63KbiuxntWXy3TCcpe57HrfPX59cAFqn5PxF7r0KFZB5BL0H2aL9wA3EIvNxdHd4Ybs0CpeGM109MyTFqU6zLezsqesTbDZKdMWCVZL55YA8IyCrSoSPK47QVayf5A7lZebNJIwK2bxDWFhC7III0RWubdP7i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Karl Mehltretter <kmehltretter@gmail.com> writes:

> A review of Documentation/core-api turned up a handful of places where
> the text names a function that does not exist, or an example command
> that cannot work as written.  Each one is a plain typo from the day the
> text was written rather than an API rename: for every patch the wrong
> name was checked against the tree at the time of the Fixes: commit, and
> the correct name exists in current mainline.
>
> The changes are independent of each other and only touch prose and
> examples, so each can be applied on its own.
>
> Karl Mehltretter (7):
>   docs: cpu_hotplug: Fix multi-instance removal calls
>   docs: irq-affinity: Restore grep in example
>   docs: dma-attributes: Fix dma_alloc_attrs() name
>   docs: swiotlb: Fix maximum mapping size helper
>   docs: this_cpu_ops: Fix SRCU helper names
>   docs: xarray: Fix xas_try_split() name
>   docs: debugobjects: Fix debug_object_init() name
>
>  Documentation/core-api/cpu_hotplug.rst | 4 ++--
>  Documentation/core-api/irq/irq-affinity.rst | 2 +-
>  Documentation/core-api/dma-attributes.rst | 2 +-
>  Documentation/core-api/swiotlb.rst | 2 +-
>  Documentation/core-api/this_cpu_ops.rst | 6 +++---
>  Documentation/core-api/xarray.rst | 2 +-
>  Documentation/core-api/debug-objects.rst | 2 +-
>  7 files changed, 10 insertions(+), 10 deletions(-)

I've applied the set, thanks.

jon

