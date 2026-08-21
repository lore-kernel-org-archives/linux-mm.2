Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1089C5DF89
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 14:03:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAA06B009B; Fri, 21 Aug 2026 10:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781C66B009D; Fri, 21 Aug 2026 10:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF2C6B009F; Fri, 21 Aug 2026 10:03:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5836B009B
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 10:03:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D3E3C40128
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:03:33 +0000 (UTC)
X-FDA: 85125444306.09.C896727
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 45811100010
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:03:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v4t1fRjU;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787321012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F32vh1cW82UZDB5HN9KvxKsrYdAwaYCJf4XRNKjoE0k=;
	b=l/A67bOq2QFQuF0+fXZROLSDEbnO8zuKz4cjEI2LTOr/vHL2y39bR46jTFdKcVkFOvJNpl
	m98FsAW2lZDW69oELtqWwk8QcYplLX6/rA5W9Dtw/1TB+VAtXYAvApd5HhqmJBKcw/0Pdw
	cO7eVN+0RqQDrLr8MCBz8rjIkams3WI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=v4t1fRjU;
	dmarc=pass (policy=none) header.from=debian.org;
	spf=pass (imf14.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787321012;
	b=QZW8U8p6bfbAkhebHIMAOrzuqpwO9G1NJdHbbbpy5uozAwt9YQO9N0OvRhXHYHvT7ggnB7
	DlzWj1b+wohU5fizYREb5wmHpzOH6NAFyZf2/mN1+HZXB3LrLLSGY8zlRY2AUgyCxzfun0
	WTXGF7vjhpIqRfVuEio5m6gsyuwZfDs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F32vh1cW82UZDB5HN9KvxKsrYdAwaYCJf4XRNKjoE0k=; b=v4t1fRjU+hHjijXSBFO1sRJvkK
	oNEaUfynGiwy3mvwySfb6wmBhB535/V1dlFfhVZQH8XmuvHnIUL5t+RcaPLZEoL5wMwqO0PLjpsq8
	O64R4Wy6JTsXXT1plbPyI9oHzfxLd0TJ16c6SQ1cNDojZa69mcnQSzY5G9RKDGp8ndWWVDOFo+s2z
	PiQseMLGdmzrhXrgmU1Ft01i7UR08O/6c5NOyNklVfbEQsBDKyx3Ganv8AHFbOLZvD3LdUrp8QjCM
	cU6q9MJot6cWTCwGZHATXDkxh7/TrZxB+8Z4g0LP2TQKQdCCr5NCiH6p6QjMPvMurGwGnExILcNXJ
	v2j39dYg==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wxPpv-00BOEL-2E;
	Fri, 21 Aug 2026 14:03:12 +0000
Date: Fri, 21 Aug 2026 07:03:06 -0700
From: Breno Leitao <leitao@debian.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, 
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rmikey@meta.com, riel@surriel.com, kexec@lists.infradead.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] efi: respect the poisoned pages coming from
 previous kernel
Message-ID: <aohIF6MmjiQpbz5j@gmail.com>
References: <20260821-hwpoison-kho-v2-0-5743791e48e6@debian.org>
 <20260821-hwpoison-kho-v2-6-5743791e48e6@debian.org>
 <aog_uH5fTsJzXjjx@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aog_uH5fTsJzXjjx@thinkstation>
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 45811100010
X-Rspamd-Server: rspam07
X-Stat-Signature: rxygsahsbcti8ofdi3o5thk78e73z8sr
X-HE-Tag: 1787321012-499261
X-HE-Meta: U2FsdGVkX19NtX7mvZ3hilQmfFfu3JSawlWFwP+TnssNvIqIKPOSM6bdiiYsiAX2xrGXp29UmEX+/TXMI2ErX+QnZWbWq+hGb7HiZTcYEWw1ODFDB8QJhl/ZJ9RAw2ZF3oLegfCdl2XvZ4Nh041MBo4pRIeJT8XnIDImbK0/KpUGRzmIHThJdeRazXOHGbeq76HUHwmVj1QPTCEe8SB4kdR9dcoRNtGe9Rl9yZwgv774XPtWVwJeaT6fssLhVa9rd2dKDlogzE7M5TyiWIj3LGXufo0MFyVUHCMydPVENYv0hG561Sm9BVjUlCJaBiyetX4nShoxQbl85fGzEV0R5xuJwdfUVCCBMu0/6zPKsmHtlzn28Md8yUSR66/H0f0l60kQ+6F0SS0fnRVNCvOHg9ZCRunsJdBIkrpop0do39rgbdAFL4uFlkfEgYjpBaWlZfuMQVLTjjKyAfp6+zJhPSe4BbTEpwevwiICFrtGWxfOqfB7DfsF073kdg22ETBS0IzQx+yfnVOzswdKsSibE1frldeqWgFBWNiapN0opuwIVbsZgTpxIlEker1WZ4sQlWd/m/bM0oWONcCzTcWpxQxHt4E461vUm3W7Nk20vndFiWybwHAb6XjEjr6m7Gfd5BiBXCNQC9860e/NWbkZ2IDtAQcmcnk2JMGnpXYpGRX3imokznoukKgcTTh7I1vvt1yAe72ZjrvAE4gAURF9bQ8TJOTsmBcq3pjo5YRyS/l/Dcxcgkxz4XnCU2+IHtABPTS/OGS3sO/xpkoKs792T4UmdJ4whBhGy+V14kKJsYJAZf1nixoCKLeWVOaSdTLdPjxvHL1OUgDxJG+cMn2XOaWf5iFzW9pAX7aS7mWgeHvDAnnkDCgIddbGbyMfH/PNzXpi50AY7i4gjBuXLcAnudoSGRar0e8R2f5SjEkacDDLDygnt7uTbFFojVsDbGPj/lI5gCND/L/Lx35leHQ
 5yQ/FxgY
 s9BtKvm7tEdvo7GbxvgPr8/3hRBoDWa34oz1FDCHHzmCadX4rizdeAzF0WcZmkS6ZPJ37/et4Y4vzXZFnUHSRDxRsWVKX/fg0n/3Nq/mIbiAFxsZfD70YBrOcAOzsIZ+I+9auObhYIntbeXjKHz6N6INw03D+s6x2pGR92Gvogt5WUKyYU2N6Q5JAPVoNlQEnesYvq7pqCDHQoZFqlRWvbUqkI+dEn2QVi3DlNAi6yTC2POU4B7dwf5tHuJKAe91KQKXHOvitYIj+0VCA0O7U8ixRiKWoznn1jmwIIk4mCrrf5aAiFNu3SWps212hclJ9VEkKIi6lv7MAXQUseznlgNfdvsc3bzW6aCcjyXfhmTnRCAvLsTN705PMBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 01:13:55PM +0100, Kiryl Shutsemau wrote:
> On Fri, Aug 21, 2026 at 03:06:06AM -0700, Breno Leitao wrote:
> > +	/* Reserve the table itself so it survives a further kexec. */
> > +	memblock_reserve(PAGE_ALIGN_DOWN(ppm),
> > +			 PAGE_ALIGN(ppm + sizeof(*pm) + bitmap_size) -
> > +			 PAGE_ALIGN_DOWN(ppm));
> 
> Hm. I don't think it is enough.
> 
> On x86, kernel doesn't keep memblock around after boot (see
> CONFIG_ARCH_KEEP_MEMBLOCK). Reserving in memblock exclude the memory
> from page allocator. But kexec can place the image there.

You mean the third kexec?

1) Kernel A hits an ECC error and marks page X poisoned.
2) Kernel A kexecs into kernel B, which won't use that page since
   it's in EFI_POISONED_PAGE and memblock-reserved.
3) Kernel B kexecs into kernel C, which doesn't respect
   EFI_POISONED_PAGE.

Is this the scenario you mean?

If so, the config table, once installed, persists forever, right?

So kernel C will see the poisoned pages, but could still step into
one during the kexec itself?

> For !CONFIG_ARCH_KEEP_MEMBLOCK, kexec uses walk_system_ram_res() that
> looks into iomem_resource. And memblock does nothing to exclude the
> memory from iomem_resource.

Maybe we need something similar to "efi: mm/memory-failure: keep
hardware-poisoned pages out of the next kexec"[1], but checking
EFI_POISONED_PAGE instead?

Link: https://lore.kernel.org/all/20260812-kexec_posioned-v6-0-e477887086f0@debian.org/ [1]

Thanks for the review,
--breno

