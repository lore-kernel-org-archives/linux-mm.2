Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64FF9606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N4pVjiXq
Received: by kanga.kvack.org (Postfix)
	id 864A46B05B3; Thu,  5 Nov 2026 04:33:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83F2D6B05B4; Thu,  5 Nov 2026 04:33:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77B306B05BF; Thu,  5 Nov 2026 04:33:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 593336B05B3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:33:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D29BFC08EC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:33:43 +0000 (UTC)
X-FDA: 85400553126.28.931A4BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F78BA0002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:33:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4pVjiXq;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B9M1jKc5WShsgBoTJ+bYEs7oHPuVcQGJEiYWo3gvijw=;
	b=Wl36UwdfH82rIP2AOKYPmOjchoLme6yNFjNh7IoXH72uhTKTMZJORQm3DNHByWMdo7yxIx
	mjuLFRl/4dxzNpc4u4pyeqmBVZnivBjsB+81oYN1s1KxqcQqHzaAtVGCdRxPziZRsrZgQb
	SInquRoEx2lDiU85tQgljkPJcJA2Gb8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871222;
	b=nEiHcRARIMCMkT92TpvffljUO0uvyrOtchUx2rgY2Wlku1L6nlHZrenBjhTzuGHfAK9S8K
	VZDGqR74nxhyiGhoHpsgM7iUKikdE/6RAHf8gM/bVcxQ/iTL+i2vvrkHZMPN57qOuBDJcd
	YnM/ePKRZJQRmfC3jj5BOR1BjO9Xb34=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4pVjiXq;
	spf=pass (imf15.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 63FE44345E;
	Thu,  5 Nov 2026 09:33:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18C11F00A15;
	Thu,  5 Nov 2026 09:33:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793871221;
	bh=B9M1jKc5WShsgBoTJ+bYEs7oHPuVcQGJEiYWo3gvijw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N4pVjiXqQWR+5SFY4TKFoYUfEMsE72yuHNwRK2I41rxQuY/4LbRXQ3ko3EI+vkg/P
	 c3t9TL6FMacOdgZ88Dqk9Pyo0kDgU5qbDRTydfg5vlzJiQf5yyt2y8OZZlFEBUct4l
	 AVq2YNScTMavI2su3aDV36L9wqRNxRMU9H3gKoQmpG6KwCttP2eoIChKmjnjCV7GAV
	 65LAONyGbAzgTALhT7n0xP/HOw7uhtxt6qpgiN48V4OdRIbiT5YgpKrns28GOCTs8b
	 fRlP5n3H184cK07tK8cIDlPnF9xH88lkpuPz/LxIJ5sNSsHe6G1prAvEeM2nBx6j4e
	 jMMOqP+++KBCA==
Date: Thu, 5 Nov 2026 10:33:35 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
Message-ID: <auxNbw83G5v3nvI_@localhost.localdomain>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
 <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <818fb0b4bbb234e4a2bd0552d61634f1a8431616.1793850539.git.zhengqi.arch@bytedance.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3F78BA0002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qnu37cbwsf934kw75bcmkqjbick9eu6r
X-Rspam-User: 
X-HE-Tag: 1793871222-621741
X-HE-Meta: U2FsdGVkX1+hiw9YsvJN/kdBIEUuPNQq0jldCW6l/gEV0GgO8XvkSQElawffiaJkbh0MCpGoiXxGPV9fsynoCNwBrzXHi3RLdz7Cd2+e2G0KXGchZ8JPERa9Zpv4v+OVslGSz9caV8ZWIRomRAaLsOHVkyjIMVdsJV3Qi6XYO0jZ26GT/MErXvP2eOC5tnZHCcDh4V4p3lchET763neUMXSBnPGs8PpU4/XViGcY9pJGzQI6Npe9PhEQc+Z9CE8oNh2+BISKV+ERwLLX3ekWhCzdcTF/vCc6YSORycFmcTWdhZOnfV5hY5x986ACFF9NyNB6Oq+bZ+7E7Etmpr2iM+uKR5QSb3K0RikkmQSbU2Qn3h0r750saE7R5AEMRSz2i424GQedZE/aNmw3ivqUx7HvwIyVbMHQSRKkW0wi7EonJIQULR6E5NUhOkcSlx0GtJY5PJQ3rElW5q69yNUCAA54d18UQAb6JSeGPuTtGilovhaBs67bg1mWyiyE7s4IHjCbd4tqU44yuCWV7P4XVZTK5uUCsAg4vpV04/SoZxac5b+C9FCvJ5tKULSKaNCA1OB/5Wq2qE+hEcYeRm0ugc4krDw5IxvukAEjAI3586Qu6cICX7o7yxv/JPYS2EtQuYXiQluXA+LPZUjvACZVU8tJZg5pW3n3Nqjyqn62cY7Yhf7iNbNAA/TzJ3+WU8NIlPdKW4LlN5+b0YSkgMUVSv7wYtJCkrDnhv3hb34NlhvBXB+vCfC6akI45t8X+YXsAqp3lSjrdbXD2RufHa2OzmOrzibqOfmDmzxT+bkUORE6AT7xJ9CpOODRhxFt4KETxRg14iiMi4LZTeqNe3/u0nqbTHNoFwaC3nzk1N3Zk7kaWjul2v6pfgGEbMJxU1TJrsi+a82luFqZ0sjmXm93kxObVMw41wM2rrD1CRH/QwVYxqSfzVqotg4lCnr6XAC3fUwZC08mI4a2n2aLz1c
 ija0aTKw
 D6TWyGi2vcWKsVlEiHZY8Z0RA7Um+wOJw0rGzHY83QlRRkqikM73Biez9SojR57YWdXvVyQ0R8PmzngPrfeX9mFTz3jr2I1VUguq/ghcDhGpMeJgAKMEG/mGrUPRopyJ9wb/LvOsK7cM1Bx+0IHO72oVknfN9mvktD+YtkPjH40/5IDRDQmDO/HpqNP6cvIcB4FPKTLywZ6lJOwXYHLcL9+mtZuy+fKyLhxv5oqIUVvV5lEzpoqXpATpKHbKKF86e3R7l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 12:07:44PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> unpinnable, causing unnecessary migration or pinning failures.
> 
> These folios already own their CMA bitmap ranges, and memory blocks
> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
> 
> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
> Cc: stable@vger.kernel.org
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

With the rewording suggested by Munchun:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

