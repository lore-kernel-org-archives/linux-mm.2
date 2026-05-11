Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CDB8CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D651B6B00B9; Mon, 11 May 2026 07:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C356B00BB; Mon, 11 May 2026 07:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C79D06B00BD; Mon, 11 May 2026 07:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B4CE96B00B9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:58:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CB3312068F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:03 +0000 (UTC)
X-FDA: 84754990446.20.D60DA1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77ABD80011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:58:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyOb0IU7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778500681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LZQJxSREndNeWY0QSKayND5FwKAqjDoolWABKOjg8Z8=;
	b=e8IIp5gh0oKYuH9Go+mAM/Kpe7gvDt5KyAD2b7ak1aISSxI+r1S6ItWhw424oMviWrNY1M
	ggjgK3zu59A/w8JKU7w0zPOBKklMVF2UDGCjErGlgeQBVo1D5V7k6NjZia8Prv+I43HnB5
	b92UhrBFmA6IyYSAxdOUjErGQq6OnrY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778500681; a=rsa-sha256;
	cv=none;
	b=6rUvv2/i6X4peCsLoNHpW8e3y12lZugdGMl2SLJE+8rZsq4i/ORruxVCtTyxPaQ2V/WImt
	2+2tITMYV4tRKG+REbmOfqwpPLaOzSNLt7bhY+SZDegZh2dcrwZ/aLgGgNaO1NlJEJve/x
	8iGyHeOSYe4kYA5TZTAghtAC5hSpvi4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nyOb0IU7;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 76EB243665;
	Mon, 11 May 2026 11:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B31CFC2BCB0;
	Mon, 11 May 2026 11:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778500680;
	bh=8u/DkKbzXWz4HHmWqQJvvG6MveKLzCay21kFajVzBDQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nyOb0IU7gWFYiZYPYVc9Idy05AXZUQqn0+9mA2PrU8CqATbLjZ/IXu4XueHk6D/El
	 uughM/5K8wRXiCWef0BGpGBLq66eSgqPYBRp2HsLSEaKB29nQpg2dFYvKAJoA/4DYu
	 go/hJdBidE248CdbZU6yTwpaj0FbymnsTw7ZPk0iURif9+JsOciWDfiwEevphDryGQ
	 0L+r4olBP21lQua8ciU0/Wbqqf2o78/u7RybbJZOEu2G8cq/2IEmHwBFs63uzEUGRR
	 8BEQzH9R9ktBtBioOaX06+c6+17QhwC6xgvpr68n9FvnJ5PF+lT1N35kaC7DyU5jgG
	 1wDhQKB09BO3A==
Date: Mon, 11 May 2026 14:57:53 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/12] kho: allow destroying KHO radix tree
Message-ID: <agHEQYbDmeOiH5IU@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-8-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-8-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 77ABD80011
X-Stat-Signature: r8ihu4b7783n36cbpnwbrefc96i1uqxs
X-Rspam-User: 
X-HE-Tag: 1778500681-863511
X-HE-Meta: U2FsdGVkX19qU+Rk+1p1VkyzkveHl0FId2fRp9Wi7IoRs7A0baM+Mpy5V9J9FvbCOBEZJnQ4HQNK7xNKdcqHw0AcvCLZ1fpGDPwNIkXI5UGk6CRIai3qS+WFxtwznuLfEzOPfFAP/ffMjzSHQeeUR7K4+Ga5FOSFwCjnPTteR0RnFlrNkCnEyHMTh6LopaIEnIF4Eogt53hE/gYkxpwmCG6R7grGqaY71Xne3gHx72sZOfgd9d3YS+97PHgG03pX1yzL4/W0Z9tg3QAdW3N7jWuCgugRVszkwkoKQu6ntI/GVqwUQT4+Z71jUUezYvmKj5Mx90qhHzudtxN8PCYln5W1+V8BzER3dfVeBjSTPqhK45G4E0XpEKfuz72fciW3ZS5KTBz7w7I9rRmGOOC4XedjDcE/sxKSwum/Ahc+HWPBOIkNJzarzDwEQNNOnZQClmztuX9ZfnzAqvEbWsri8h1TXK+SvvSU5oSZ0IzFyhSbpNTINbdKHUnd50CbGKVSVjXSlcTg036QwD+PfnaAWDZ8rdH782GA4TBeJGNfDiMds42pPoicXGWfFaEH9ZxJbrh1HMMY/l/sfNnu0rhevRrc5cQxBuBXHY+jrbxbltvgFLvb03nQ4U4aEBnXSvrh2AOuIcJ4dHRH5bE46hxlP9GuGUymRdrWGF64MUOp4VXxG94pbQQlqmBmITs0qXz7Bb437orUanp5/ohAnjKSkkUBNE4Zs915Q+3bjzOAitv34QdFEue29zVHlyQaHbGmqEM34aqfvraw8LvC+hKcQ44mGxDsTgVZY+b56keh439yOUV7t2PutlLeijBs5QrYvAXSGHN51z16Xe98vub/NFUwnidmhFe10rzIAHb3MMdCaMjDkV7g4pRRfmD51rHuv08HcYa38FYvQImgjR/C62m5DVTQ+usXBk7zJO46XtH4UG3LU6+XorDIrS545V4j9MxkJlR8+55JVEidSkE
 M4+qsb9M
 vMpPyqZgJTm+rw80zxKK9V+GYrzutMHYnWB6uZaAwOy4S7a16DwbFPB/pFMhNKxa6NlPEKYZ1MaUVfCURqymO/u+zMhxH605Se68a2wyc+jdd9pCvgvAot2fGjTRml5ndpnsHU9ciQfNbIuk05D7xsri9WCaZfm5hQIsn3rWzF26uHMIKmiJxzgRaX2I3t+zkrSvmkNh1vxNsnvp/E8YkfX6BRiRJV3Tl47tpdonX8k9jhXN0L3U7ajYGXlVmQkVJc2HRTXHvPc35T0FQDmhffaAkmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:09PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add kho_radix_destroy_tree() which allows destroying the radix tree and
> freeing all its pages.

A sentence why it Will be useful would be nice.
 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     |  3 +++
>  kernel/liveupdate/kexec_handover.c | 34 ++++++++++++++++++++++++++++++
>  2 files changed, 37 insertions(+)

-- 
Sincerely yours,
Mike.

