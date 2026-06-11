Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D62CCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD46A6B0005; Thu, 11 Jun 2026 14:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DACB46B0088; Thu, 11 Jun 2026 14:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9CA6B008C; Thu, 11 Jun 2026 14:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFE4F6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:21:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 610A214078C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:21:15 +0000 (UTC)
X-FDA: 84868448910.20.43F4799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87E6440014
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:21:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1UGvCfS2;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781202073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UrqiHgzJnUDrN2zaL2aUvEJac25e4kum+eKErx0Wyik=;
	b=Jo9Y5mp/FmJPOHvHAyinkxl9tm01DxwhcTA6XOVDJc/3DQG10IUw21FSW43Wn6H6yztFCY
	+0LTdH2dTcjJxE492++M3yZRwPsahLF/dcdTkgqpMHZsrTw6me0Q1AMm3s7DJWO3ZWk6Af
	IjEV0nm8Wm3sktJflv+ys/MtsML9Nv0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1UGvCfS2;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781202073;
	b=Qc2E4cr7kUdJy2rg/7P/Eu0GoYF6EAuj+iQAfFIYzS9qNXO31SXpRwyh6B2dM9aVlUtVHo
	CQQP9zwZ7dhYw6wYhmkH5lQoicW4nZyfUX4kmf2WzF8SCLJJ1vwcEOYPCZ3R2WRO8jl/ug
	/yS1T/xq/W25NsMZW6SkQnUHC/gYeW8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D73740AB1;
	Thu, 11 Jun 2026 18:21:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5E81F000E9;
	Thu, 11 Jun 2026 18:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781202072;
	bh=UrqiHgzJnUDrN2zaL2aUvEJac25e4kum+eKErx0Wyik=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1UGvCfS2AOcLr6Em9p+5O0QxirlhGeSkV4NBTdn5HVV5yfkGSlq403HJYoBZ/CuJ9
	 79k9hMTfCGV8WJ9gwhpkrp8bNGh3AGqquCOjJWxwhwAGqzLCnRcjxCcnOXezD3kpIO
	 sKOu4HZRzLEtGMMzCjcMl0wFSPLaOAhBGflyA+MQ=
Date: Thu, 11 Jun 2026 11:21:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
 corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, yintirui@huawei.com, ljs@kernel.org
Subject: Re: [PATCH v5 00/14] mm: thp: always enable mTHP support
Message-Id: <20260611112111.18be7ad24bb9ad3c7b3f83a6@linux-foundation.org>
In-Reply-To: <47f9202b-71b1-41e7-8185-426beb9d4a2c@redhat.com>
References: <cover.1780066530.git.luizcap@redhat.com>
	<47f9202b-71b1-41e7-8185-426beb9d4a2c@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 87E6440014
X-Stat-Signature: xqjykm48x1n77g9ir1bayfhhj33etdsh
X-Rspam-User: 
X-HE-Tag: 1781202073-320020
X-HE-Meta: U2FsdGVkX1/lt48fQcTEulQfc68Lwffk934H6uu6Do704et/LJInAV219/0tQQVPRO3oL4a5nxxYpenYBW3jlP9NBMkshUevrE1bQByTHWTlhm1AnRGyAFtVwa7UrneYsWZ3itSbGZ5eLpxV00iv7vOvQumodonQ9RPawK6+BuqTD18sdkmCM1mzCfMwXGDtHWkg2iETq558V7mrcxSFyXXoDj2VWLMHWliBwrp/kSXqhi55avgXZuv9hLBKsEjKg2rdLAlmg3ghIimPS+0MbdklIiqPnLlY9SSU1e1qkq1t99j8+hPSOWEQdNOVaT6n54sduykkoSWjhXifPdegEeNpF2qTZUZnkaMgpEWVCQIZgeM7D7ZlZNX66N+g1/Rob6r0je8ktdmSjx2U13dC22BGSkDLz3BSSIgJgsWKyKmhi2TUnlmtvDOZ8ovHgTN64vOminJQXKOCXuomxizuCUwO88H25XHgRX9o3agqVSNH57OQVcxM1Y4dfjev7M10y3oly8hDICLdi6qXuGMIk75LKB6c2z9aVCU7k419Ek2aTqmVJ8wRaWKh5679YffMRejXaFORHX6Vst2ms9KfehjveATDuany+2289s6zB3+1eyu8HxVAk0B/tEI8ht1nrcFl/rz9VhRb86Oh/qgDyez6n2lN5Q6Y9JZPLJa9ExjXI5yM0OMWfqaaB+KoGxSn2F26rePmXmnAyL4UDn6iz4aHgZToIE/C2JxCsuFRnucMczYsfV+twvOK4ELLLuKbpIF6CqpZfEzUW2tjABo+2YNKZ2BfgWiWkHQQudH744B1fzFZCScL9Ub6lFG4T55jIjhXkAgCROs+wsRrHfiLYmL7qwKwLoS+DFZNWq0QpyTkoXbtDQg/yNqHbtBnaFcoGLCBaX3UwVRFcLpGJ/sDPYD4OXtYFrkYpJ5mp2VKVj7OUA8XEZgjGENT1HR2eSMa1VKSVqdEYyjMwZpbUic
 iDhOf1ov
 hviexV8Bqx57FAHIBcYfAUM8qR3fcFnlFh8DX9yWf778EOIlCY+aevsnTyYg/Xvc6lDujbAb56TxyLkjkVFIQBpwiuTFOhV8hyI3tpApviQ2RBs71vydY25NQXnL7wlcDDs8WfFqGXe14+jon42SE+skuHW5t1mHUzmzZEH/mcf7CAm955fAyynf5igyyjpj6PDNUu2tkrLQ5HnnnW1iWY3ZiDV7nMiiUqhQiOpVeDQfNBXEAlAr+WAGkJe2E+SqKA/J/wco1OHomNeuQglzhyCN6wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Jun 2026 14:00:11 -0400 Luiz Capitulino <luizcap@redhat.com> wrote:

> I wonder if it's time to add this series to mm-unstable so that it gets
> more testing?

We're at -rc7, so it is precisely not the time to add new material to
mm-unstable!

Recall that mm-unstable is included in linux-next, and that for good
reasons, linux-next rules say "only material for the upcoming merge
window".

I *could* add this to mm-new, because that branch isn't included in
linux-next.  But mm-new is just a few-day staging branch for entry to
mm-unstable, so the same concept applies - mm.git just doesn't take
stuff which looks beyond the upcoming Linus merge window.

IOW, please refresh, retest and resend after -rc1!

