Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C9D0C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 10:54:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0CAE6B0088; Thu,  9 Jul 2026 06:54:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE4FF6B008A; Thu,  9 Jul 2026 06:54:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB106B008C; Thu,  9 Jul 2026 06:54:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB3966B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 06:54:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 62AAD1A045A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:54:44 +0000 (UTC)
X-FDA: 84968930088.24.F24C3EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB52D80009
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:54:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djg6eWwF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783594482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5IFQMzrskUD7Q0K8lx1GZRyHsORgTiSpQss7AS85z8Y=;
	b=57dY4ITfCFm2luTITERUsNn0iuqt9t0bq/HBpQF+9R4qXyUvB48tmEZDrDgOfrpdVTWEyG
	7X/zeYixRejD1K+pkD9U2vRt9PVJu/opSEbNeO3gQrp8HDtSSG5PyN84ztYipzu4hk1EI4
	O4Srf5exXnEsqb0IUkIBlCoeljo1MG0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=djg6eWwF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783594482;
	b=lgoBpObWAQpSKSI4XQqZuHKCVolMxereHad6KYBU4bYWTbdeBc86+JWRR4fAGMuO8tx8mO
	A5CousJeGW3W/QDKuFEqapnwa3+Dr3YytILtFN0leiocapDmBYbu0Ru9laUjlFi9HLckcq
	5l3SLDyAt5TAypT7peCOjw1LmIDQkyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ECE6600C3;
	Thu,  9 Jul 2026 10:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EE41F000E9;
	Thu,  9 Jul 2026 10:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783594482;
	bh=5IFQMzrskUD7Q0K8lx1GZRyHsORgTiSpQss7AS85z8Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=djg6eWwFC+6+N4DPJiLg8s9Is4gODHSnj3M5xQ1v0i1w+hmeZNK7PwkhWrhIjWf2/
	 CH0pQWNcuemtfyMtkDGcXlblhUbv+mjc67+sAI2oYAXbGbneZb98akSoZWp4z7MbAA
	 MYCJParZCDiX5lgd1V2qmQibMC1LM3lVUBOl2pq+NKbT1WI11q/Zi4JkVaBsLLiBHz
	 p6OdgEEPn/Pwqs7Kqos0FerkgrbibOSK7z0fC+xurQI2IZJZV4ECmDO+tiK3gFMCeg
	 5YslZiOiXJxROUWILWcI/6ykfLhwIb7A7zzUuDHWxVPRT4iC9mwmMlK1cQY+TJN9jD
	 VpGM7SKbTbfyg==
Date: Thu, 9 Jul 2026 13:54:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org, muchun.song@linux.dev
Subject: Re: [PATCH 08/17] mm/sparse: mark memory sections present earlier
Message-ID: <ak996_21b-jxYLGV@kernel.org>
References: <20260702093821.2740183-1-songmuchun@bytedance.com>
 <20260702093821.2740183-9-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702093821.2740183-9-songmuchun@bytedance.com>
X-Rspamd-Queue-Id: CB52D80009
X-Stat-Signature: 9zkqkzkz8tyc6yh9ag1sgbfpna36qbi7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783594482-24797
X-HE-Meta: U2FsdGVkX1/3XiNo6Wkr1mIXjFF2Zj9uFxruP7pUZSFUFqrd9ok5tv7Z3wYluxSiPIhKhNSFNEZWLA/+B4qzqMCUxcE7FSjLnhAQu/g0vghq0Yhwlfmz9FtjOZu43mBDH7O0HVLeqRfSrOtdXfvN5mBtC+z46Vu/6BnEfSsyOUTOsFWEreBuDV8vz7iRFuZ8WMsG6c3e/+BR/N0yUKWuqf8VrZY5CANVZlW2R5VXnKJem+JlLq7FUrILjuV4A47rnVhlVBW9uGq+BtHWCAn8E5nhlaGNCfDx8nB93mzQ5yWyJ3yuBncUhqe0LQTFY4EGAZ0vmk/YIfpm808YRvCNl1kEHWkgtqicY5SC6E11Ne+g3qjhW/AaYDWXAA5xuZgQ8jpiG3JzhS1HTSmbLo4WnCk7wIAVBgiYLwy94G3X/9EH/MN/0x0k+MrJurJ94ZjzhDQV49Qf7LBIy8ru1F58i86OceoGNliTIPpWeQnUzB+thJk4YtIyFTGH6BWriH59Psfe38vzUr0uavWLrxGv+TO72eCIUqFhd9NYo0OOfAi1VuLoblnNKCgLrxmUBq9TyC+mJtKt11kley6Shm4nX5W9+eLEyDbPFQ9q6DGYPJsdECUAP8igClCUHsPbDv/tCbvvd0oKlNl8Yqpqh81el14dGBaXioi02ylQDFto1PGn6JfUvdzG+k9eMJt2H9hRgZjcvUvcRCo8e5VYyzzuaERCcG7fqu3T+r/vzANT1SDq8NJf8fA4jbg8k+7AbL2O83FQ9DQlnDPQr2qGcTfWBa7DBfp0nTX6Erpw8A7yO0o8RUtVe6N4yCv2PocjZsDDTirDY31qQbDilHevjc4lTM8XusBFu4U+FDrVgYlq4fzIGYigfc7AFimnt8u9AGmX7wD1oceS5+ihbkKWdZqB1BLLYCSCDJlCYRJL1lBy3rOWxHLxDP2pnCx8/FF2BsnMftnwG8l7AXrdiZz8K8+
 fd+SvlnJ
 3KR9xkBaeUVU4jQmePe3396DEG+P/wgvffHralx2G84OZM3MfmcMy5rmjWiv60lvkb1C54pCj24d79lnfcY+t8ftuGWP2UQhxK4EsYR8Kkvd17IYKu9dWCYD8vXDSXyJPsn1YMrwCoOrEBjtlugosV4bP/X1IJqgftfGthiSI5cgUEKplgEzNWXXOtqMF+lSbX2WqcU9qGEd3oYkVSld7iAAih2KmsY6K/NGs1HLKh4f//YPWFJdH/S+sRTRIH3zOVb0qy+jqD7B2DLC9nNc07SubQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 05:38:12PM +0800, Muchun Song wrote:
> Upcoming HugeTLB bootmem changes need sparsemem section metadata before
> the HugeTLB bootmem allocation path runs. The memblock ranges are marked
> present from sparse_init(), which is called too late for that setup.

It's not only that memblock regions are marked present, but it actually
initializes mem_section's for the present memory ...
 
> Move the code that marks memblock ranges present into
> mm_core_init_early(), before free_area_init() and the HugeTLB bootmem
> setup. Rename the helper to sparse_memblock_present() to make the new

... so let's name this function to reflect that.

How about sparse_sections_init()?

> caller describe the sparsemem-specific initialization step.
> 
> This is a preparatory change.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/internal.h | 2 ++
>  mm/mm_init.c  | 1 +
>  mm/sparse.c   | 4 +---
>  3 files changed, 4 insertions(+), 3 deletions(-)

-- 
Sincerely yours,
Mike.

