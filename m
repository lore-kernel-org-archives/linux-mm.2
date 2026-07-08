Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D821C44503
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:37:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292C96B0088; Wed,  8 Jul 2026 13:36:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21C0C6B008A; Wed,  8 Jul 2026 13:36:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E4EA6B008C; Wed,  8 Jul 2026 13:36:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D696E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:36:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 501858CC8E
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:36:58 +0000 (UTC)
X-FDA: 84966314916.24.A707C33
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A2D53120006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:36:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gohq4OmT;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783532216;
	b=DsE1RXI7bWu8aJN8545qzpHME1WoY1lniGfMiu0Tdipb5uIRmWBmMuKj/DgJlNXZcLK9DV
	x5ow4ufcwB26McWqskAmqRyZBtRm1L+MEFb+GXVuiQsvA+Gl2+QuaI5/l4bySXHuirO6Rk
	qndI8r9j8pJb4ylkYyFoF9DIzFmRcW4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gohq4OmT;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783532216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5fSGtkNEGdJxANrrlZw1luedfmF/LGhVw9H890AiSnE=;
	b=kh1clj/lCJskU/zYEbRyAn/9X3xdXQ4qCBaBXZ0tc3oI3n0RZAcMmui6JMXcn0GQ1Aj4rl
	bjdwqiAIvjOIJqhMsdqwbiG9FPKKyFQ4YISp03Gvc3sl1NWJy//NSM7PYewdFZvQHk8xUR
	od2VfQ2aT4YdCjqzy5CjvZqdQaSILIk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C517043E0C;
	Wed,  8 Jul 2026 17:36:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19EDD1F000E9;
	Wed,  8 Jul 2026 17:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783532215;
	bh=5fSGtkNEGdJxANrrlZw1luedfmF/LGhVw9H890AiSnE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=Gohq4OmT54oQiAuRoLb3+AblPONF5BBrRakh7lEgmSJpw7I2O2cLzUsk1lM78uViP
	 r6t6AAns0U/YDRxnaXlZ3nD1aLEo8mNSLBW01efYwPVLbv9+1LdHOLEWXY5f3c2BRh
	 YRL8BnFIk0/4ULGjgz0nRJsZm186Zx3sk0gFWLEJtOE2RdHUFGgQ7KKFtUYltyp/Zu
	 WqLwKT/a2IGKwhB25jKKzmx34d/38fB4oIewM1/EOdumMklrLSrUYAr2RDpwRBPnGi
	 E6jYb0IRAPMvUVfL28Bn3y3y+dbWX3Hbr6Ka+Ws7YdJs+PAGnrTdcB8lS5qctfYo/2
	 4mpAZ+C9oXvEQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf
 <graf@amazon.com>,  Samiullah Khawaja <skhawaja@google.com>,  David
 Matlack <dmatlack@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kho: Support preserving unsplit high-order pages
In-Reply-To: <ak6CxVty3O5Ib7q4@google.com> (Pranjal Shrivastava's message of
	"Wed, 8 Jul 2026 17:03:01 +0000")
References: <20260703020832.1731864-1-praan@google.com>
	<2vxz7bn5mv0n.fsf@kernel.org> <ak6CxVty3O5Ib7q4@google.com>
Date: Wed, 08 Jul 2026 19:36:52 +0200
Message-ID: <2vxztsq9l6x7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A2D53120006
X-Stat-Signature: t63ps1xgzn3b1dz1jkzbmcfixykwx87q
X-HE-Tag: 1783532216-428835
X-HE-Meta: U2FsdGVkX1+7odpbQC81Da1SyZu2rdtH22Hz2WsZCgl4OrA3qU5YTYQdMvlN+FmlQX5sikoom7bybM2UF5TqztlvIab7q+8sx2sapBm2XUESy6qXiy3deKoH972BMtkdZ3vltw6cuu3rC3CIb9H9iOLH01ZD3ZPM1Xg5/zwk4Vxa+vF0FV3MDgFBDziXTCJL8rmRmHxN3lwyzxTu1Th8jjaprM5AcswWcEiZ8F7V70DHdYbLSVJBNkjDROB7lDV/NQe71p1JfbWWc7xPGAThO9ooAyq8gcr49lwST07J/e860ZjeIBiwdLJGx8K+O1jWgYZ1mkKCPoq/+G6UqTZKeKtfrQ9QqlL6ft2fS+WteO5nFz4h+zQF80cLpyklu6vB424yQVPF2z8IdKdWvFbzFg9eAes6NtxpmIDsg5rMztaviWZxouMhAdax5glbmwN/27EfzAHnA6N5W6jaGHTHdR36vEFpuR5wTXUr4xsMhSUo57IQ/OvzfryirOj1eF/4+JelmpSchLHsvwUN4PuCsuGoSuTGun7mqnR2AmJx+ZCJZbFp0UGZhxHbvIwHHptcf28RqVgTMNib7NpqhqknPc4q924TVNJp5eyqsipQG0SPw+16ChAZ106j0zq/cLednfbAoKOAg8jCNMQjgwtCes8pphRtkvxta6Un8Pm8paAQjOX2MQyQYM4gBV4ycerLe8IrF61QaGiTj03v7hAdKPq7J0aPEqcZZe5sJJYqGHdl+tHg6FVsfwYe4fq4zpuaKgZa6Te7nMN1Lv2tXT+zgLGwZPkMsNeY6N+TLaf7otbmJmrxo+BVz6c9w/E1ZfDwwUXWTXEe8IAsHiF95LyxftyN1fDt/TUFMkqpw8ASocOZ0wPsLnf8I3hi3jEEMytiqd8jyJTyXeoBpW27wNKYQvvC7y19Ye9A7fjpU/njKrpzDJsqYvsz/ZPOCvi/nQ7NrSOJ3RfuSF+dh8b3K0k
 RGkd4E4H
 nk6M7rX/Z3CpYbO9ni3Fre3ZpV6Q1Hbg8zD2+Ce4Ra9jmStpEEbM1hJs6fD1XTMH3dYAD3dd6JcH4Msjmf40ekPEieFo7mOQZ85w6az73rNn9hae68LJQeLTfYQgK7GLkNUmmjF5gk+MRcmC9PfYOEkvYwabBNSEJt/c2byUzU/Ye7oIJM/fbULsMMD84Iif7iBP/aNpVyEq5snq1bRhKQOh6mg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08 2026, Pranjal Shrivastava wrote:

> On Wed, Jul 08, 2026 at 04:11:04PM +0200, Pratyush Yadav wrote:
>> On Fri, Jul 03 2026, Pranjal Shrivastava wrote:
>> 
>> > This series is required for the ongoing effort to preserve DMA allocations
>> > across KHO [1]. It addresses a fundamental mismatch between the current KHO
>> > restoration logic and adds support for high-order buddy allocations.
>> >
>> > The Problem
>> > ===========
>> > The current KHO restore implementation treats all multi-page blocks as 
>> > split pages during restoration, i.e. kho_restore_pages() initializes 
>> > every 4KB page with a refcount of 1.
>> >
>> > However, many kernel subsystems, most notably the DMA allocator (via
>> > dma_alloc_coherent), frequently return high-order non-compound pages. 
>> > In this unsplit state, only the head page carries a refcount of 1, 
>> > while all tail pages have a reference count of 0.
>> >
>> > Consequently, when these contiguous but unsplit blocks are restored by 
>> > KHO in the new kernel, the forced refcount of 1 on tail pages causes some 
>> > trouble with the buddy allocator. Downstream of the eventual free path
>> > the __free_pages_prepare() [2] ends up calling page_expected_state() [3] 
>> > when is_check_pages_enabled() returns true (only when CONFIG_DEBUG_VM or
>> > debug_pagealloc=on).
>> >
>> > This detects the non-zero refcounts on tail pages [4] and incorrectly
>> > taints the kernel while leaking the pages in question.
[...]
>> >
>> > 4. A new helper, kho_split_preserved_pages(), is provided for subsystems
>> >    that may need to split memory after it has already been preserved.
>> 
>> Umm, that sounds scary... Why do you need to do that? What's the use
>> case? Why is the driver reconfiguring its memory after preservation? I
>> assume these are DMA buffers, so why do they suddenly look different?
>> 
>> And in either case, why does KHO need to do the split? Why can't the
>> driver unpreserve old preservation, then split the pages, and then
>> preserve the new ones?
>
> Ack. I was trying to cover up an edge-case I guess but if we're simply
> moving to an explicit restore API none on this would be needed.

Even with an explicit restore API, I'd say it would be a bad idea to
preserve using one API and restore using another. The driver really
should be unpreserving and represerving. And even that if it really has
to.

-- 
Regards,
Pratyush Yadav

