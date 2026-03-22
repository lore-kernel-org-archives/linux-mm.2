Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15906FC72C3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 11:01:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CD936B00A2; Sun, 22 Mar 2026 07:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5266B00A7; Sun, 22 Mar 2026 07:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E2A96B00A8; Sun, 22 Mar 2026 07:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E94D6B00A2
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 07:01:45 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7132CBB3D9
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:01:44 +0000 (UTC)
X-FDA: 84573408528.16.CA49C97
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id DF20E1C0018
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:01:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EiOv9hi4;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774177303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5QXZ3gOGpmPRS9XbfZssC1pswcUOC13rjRsKuFeHYs=;
	b=NE8wniZIFW/FrOh+YzR05stEX40L+Rs2xm6ee040crA0n56PGy5HlDCa/AfHhSnA1swdfb
	kNnt9mvaaUv+g/M1dM8/WJy4BOnkn/MejXRz+eXNCVfCc79Q9gK7/YHGjODB7rbEgkC7h9
	0jx3SFDIHRC9qc9HWwHYhAU7lc3zC1o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EiOv9hi4;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774177303; a=rsa-sha256;
	cv=none;
	b=r9I+bjZ51vGF9u7Bn3rCwFrQQ6O7TzB+kSiPVI8nrBJD1o5DS7jkRQCuC56dWBdG8Xt2NA
	W5tt3Cl+SMTU/RJyLBnPI8zcp/mgaWB4/Ay8oIL6lZP7immgFYodKVfS1zJv7wJj5nFkvM
	ecTEdwlZ/wBUtQZT9E7mddtfm5+R7Sw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F898600AE;
	Sun, 22 Mar 2026 11:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D3AC19424;
	Sun, 22 Mar 2026 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774177302;
	bh=tC01ybyDA573d5o3Uy5N5ehRgFq9mu0hsXd3ZX+WARM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EiOv9hi4CjxJHl05f87A+5TVs7u/sO2FITeu5sj53f+LQoZl+i5IpF4Or7APrW4NS
	 BDbebIaH4c6oQ0dDR6iurDyKo6MwLpPPbsmaPaI+czl0OL8JmYbZjtn2qbWH+p+GBA
	 7ywYP0UPRILvaqhVLWKWFtm68ZsdV0NKRdDDTHKKXx9tWl09AKcX8lLd+hiemrVR6G
	 0mY4faQ4ShH37ezOapTDk8NaCN1hIk9wODkRH4FOtDq0dq/XPt2UYl4yP1p0Zx15so
	 H7RTyBsccQioWHEcs1sQ3n+lQzJ1y8SWBPjuibORjlMGDmeixuHoGZ4oROZdYpLUj9
	 ZVlp80xtcNVFA==
Date: Sun, 22 Mar 2026 13:01:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Hubert Mazur <hmazur@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Stanislaw Kardach <skardach@google.com>,
	Michal Krawczyk <mikrawczyk@google.com>,
	Slawomir Rosek <srosek@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mm/execmem: Make the populate and alloc atomic
Message-ID: <ab_MD2rJYCG2EGZh@kernel.org>
References: <20260320075723.779985-1-hmazur@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260320075723.779985-1-hmazur@google.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF20E1C0018
X-Stat-Signature: 1dcgus7nh44gaqaoz8ussbjbrm5qsgwp
X-Rspam-User: 
X-HE-Tag: 1774177302-54960
X-HE-Meta: U2FsdGVkX1/ZSf/ZRaTYTYTe/UEhXk2PNiNxtvpHYFXiPepG0kKg7iz722zHYLaSdCmdM5pO0V4vvaKCMmU0Yo8/v4J0ULlnrtK7rdiczmbTPBglYunnphs0cEJWb2vBhHjhnhfWcXYysYNC0biM+ErphQ5fpKFLWlJ9ifWrVDjTzMtf6SJzp5M9Y6aQz1ZI7dNJ64ALBA41LALD2dam1Ujbm/BuwROd7BLlMmhraDzUsRCB8zsanI5iGVAD26ZuFDLHnqlsHMe5kqm+wnnskqvWgOt0pgekVa4m+TNvS0owjMswa6yodAA62j2Xi/ulQDypxp7OIcmBiokv0R6XMnoru8InYMMEeTyiOI78o7h8OET8gZ3ek0pMuJ6mqsLE954edRSss1dA7Ozqt8VQazYYhZVEKm5a/cNaRvdFkfR/SulVmCYWPCqgtfwgGaUZRSvbXHRtNb5pcce6T97la2JkvjL1doVKxu8pzcJ6W/vkd1IbPYrfL3aGdE0NqNhJ3VyWsA5W95XHFdhZgBdQODfqIJ1kG6w4bKcGDMpyB4sZsBmytfUQL+SvmDZp4sd3KYm/NEddpl1JOHGQ5+UG8BzJ0WZzbu31cC1fpJ2QbWIA39Jekey7TgVl5QltgVu6umHKt27Qn+kpAdreKr5Q8lpyNsD+LjCDZsCYgWYQivP6T3kdxHgs45fMhDAW94G1IYj8NMIP00F/rQGMipOK7bvzL/bflcqIhcaUVUlnBGHMhkwQRPj6jo3prcLpKnAR9jmPc2kzDZapxAGnHW7mrDqwtcYVMzFYTn4tIeUTBxYvFH0TIGiIHL5aABQrBDDPiK2sNp3Xd01J/OeRHB7sfA0Mc8Twv2wNR2j2oMMIfnEVbSkOIHJSIVlUqecXRjIs24S+U2lXhobJFe+ncHEeShA9dBLrsQTh5IootOpE/qY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 07:57:23AM +0000, Hubert Mazur wrote:
> When a block of memory is requested from the execmem manager it tries
> to find a suitable fragment by traversing the free_areas. In case
> there is no such block, a new memory area is added to the free_areas
> and then allocated to the caller by traversing the free_area tree again.
> 
> The above operations of allocation and tree traversal are not atomic
> hence another request may consume this newly allocated memory block
> which results in the allocation failure for the original request.
> Such occurrence can be spotted on devices running the 6.18 kernel
> during the parallel modules loading.
> 
> To mitigate such resource races execute the cache population and
> allocation operations under one mutex lock.
> 
> Signed-off-by: Hubert Mazur <hmazur@google.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---

-- 
Sincerely yours,
Mike.

