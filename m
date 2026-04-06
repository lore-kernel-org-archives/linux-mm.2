Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BEA6EF4ED4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 12:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807FB6B008A; Mon,  6 Apr 2026 08:57:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76AB96B008C; Mon,  6 Apr 2026 08:57:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B7D6B0092; Mon,  6 Apr 2026 08:57:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C3336B008A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 08:57:01 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF41F5896C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:57:00 +0000 (UTC)
X-FDA: 84628131000.23.5625B9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 41E16A000B
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 12:56:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxTdZpNP;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775480219; a=rsa-sha256;
	cv=none;
	b=FsLn0hSRgsUKhjwSM0BAr55Cx6SKNldFk2dC8GyY69GQPJCDqy2fpB9nBlLx4IPiAn8JbQ
	V2mf46BdU9Mk/1e57au4am6kUsrnT3Sve7Ksacus7XCX4feg1E+hNmvdp89EmXkbapENn0
	XE5gEGbgpai0cnBmLfYzsi5C5FzOFvI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775480219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gqPBpHI/Dqnmm0q5zZtq8gfBWK8tRIWRdnPie5+/64=;
	b=KJM1k34tMfj06CUEAjMZeew2+c7D3POQMitCVzirtgjSG/u0vs8xoT7ZSG1eHCVxp77rmP
	RLRWzEknGYgffj/RUWTmVrLSjy+mxZZJ4kpRiGtvx7y2XwOvblwf5qaP0FU3GzfMQPrXZR
	KtG3B1joVhz9qDahmgPZKzCmXzpI5ac=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZxTdZpNP;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92E9E600AC;
	Mon,  6 Apr 2026 12:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A43DC4CEF7;
	Mon,  6 Apr 2026 12:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775480218;
	bh=/gqPBpHI/Dqnmm0q5zZtq8gfBWK8tRIWRdnPie5+/64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZxTdZpNPlT24ktQ1DHuXs5pVEHWUtdLUhqp575cj5MBhhXOQT29+UPraloNK36Sm8
	 qWBbI5pTGRuKtx8qK7UdSRFNHz2mBeoiy4oSqAsEs/luTI8pp8Gk+GVMpca1GMU9TC
	 t7DXEm18qQEN/RpF0RQ3SOgT9cb2Kss8jmeuuPQ+/oVlBwfcYJs6BB/d39KLD5xrxu
	 0lMIKwxBCu/8jPJHKFMim3AqQKJ2EAzgX/G2lJD2mOfuW+ltD4fbsXKRjgZun+ZqTm
	 TUiYq/hxI9nYho8cYDtjdgn36W6z+QjdYBj18umTGufERACT2zTJW5zZuAhA8ppqlV
	 PO8JKvoFaL+wg==
Date: Mon, 6 Apr 2026 13:56:49 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>
Cc: intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>, 
	Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, 
	dri-devel@lists.freedesktop.org, stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <adOtS_q1MuFOawGM@lucifer>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
 <adOqU0UDzpxvQuwA@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adOqU0UDzpxvQuwA@lucifer>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41E16A000B
X-Stat-Signature: r9gorkga3d6k5smgkeegd17jtrhbj8bi
X-HE-Tag: 1775480219-338132
X-HE-Meta: U2FsdGVkX1/ScYGx0yUsjrMpwHB11dcyXCMHkoNwTZdCmibv09KxaeQLRc2DkvEwyQLcUrqFj5F/qZgX7MwoUYaIbtNO9R3zHXcho2/F/0ybbpTTTmG/t+cWAORJbCQ+1MObmi+KtmItVUdoqKIb5uT7KfKpVHFQpRKhrjXbq65q2F3wYyhYU8nelw8jZj+gNayb4FNBH19dOMA+Oz2z7n2QzlcD3Xnw7ZBN1dhiGQx5ZblfuD4quLrY9MtXxqmdDrVl5t0BjyEvwnWZk3SR7QpMRjBTqjWJa1OeHBbOySloroQ4sO08zmxUnZN5/8vZqFpdAIuWzL1cwMQd/t/8Qs9dTr4WSQZZwcgOAHkZjDCJFZ6fPrWEyn7oRhn9wc6PyZuYXv0RU3zpvBrdE/eC1jBY6obJvrP2ZFk/Q7FOBOqpIqSwrEo40bsfc5F97kzK9kp3ja/KauvRRUdCMiB4ph8DZ6ANFPYQ4FGctpzdWCVaasnBWFW1HtTimAen8An2EnQIpSzZMA/3E3VfCv3UEuTIRWsbyv4MmqRrXh16EdNS39mE35PRx+AlOkOae1fmXJGgVgEVh3/ShFxPWzb8dCXQcjiw8IsR/HOKS9gue9Olag5XLBXVZNHzNGw4yJcfAczaGVaY2GkSuyHcULTrZTzNYfc01Km/I2/4pz7aAM6AfDZ+OsOSjLwVSBasG6Qy/dX47evTxm9AUEeG520cTKh/ipTmEM1hMa5wpnJcLQiFvt5hlUBTQDhSoSkBwAd0GsE9phF8lZVATpvOfyp6V1nndfmVzHFqT34SoMD9pjDM70qUW0neQ0uLZsc39fGkz138Qvh7tv9eLM2Mnd7XI39vB5G+XC/Ca5uZIUuJxrJM2z2cvZXBp8crlhQLl9psBBN8yKzdFHBdqTZ8aVfL6q1N6qM+Xq32d5COQ/aKA6IbP66lmyxrtzmYh/e+sYkSUwytBnx4KHyPWjcMnME
 fMTN3Im6
 enxky6Y/9wbbA5kWCzC03Lm+T0A4Ozt1nvXH/p2uCYemnxvGk+Kg4La0cc0U4KLw4BAZibD2kXGmuoGIofM2+52k61U2FzXT5ruxK0awC9oplPhBsKhh/PBSKnpnGCArfpnEtIOYLFpzLFRDi7veW7If4MOX1T2/seTKsjtBvDdSRmrR3EgP+mAhS/5jc7QvxlKsyOKXdnCoZbB67SosGlA8LbqwC5zbEdpsHmh0FGJZjHJ8cnUKiDYADQlE5aaOS/h7hAxhGVzW3LUXptfP1zFJdasGZveyLGLIaqffHSaG3Kl+3zRcOrXMTxQfPMy8Ok5i7SpHZ6r/YrMsPbTZ+VtNQVGHtH1jdVKZtauA7TAcz05AleYB1ngFzhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 01:54:13PM +0100, Lorenzo Stoakes (Oracle) wrote:
> I see John gave a tag (and he's great so that gives me confidence here),
> but we should really follow the procedure on this properly.

Oh and just noticed Alastair also :) so that adds further confidence, so this is
really a point about cc/M signoff requirement going forwards.

Thanks, Lorenzo

