Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52312CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 22:56:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C053A9000E0; Wed, 13 Aug 2025 18:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF0A900088; Wed, 13 Aug 2025 18:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC259000E0; Wed, 13 Aug 2025 18:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC3B900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:56:20 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C329591D7
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:56:20 +0000 (UTC)
X-FDA: 83773244520.07.B8C967A
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7167F8000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 22:56:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=17ddbz9y;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755125778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zQoR7PEQJVyEYYG/vPMhWSIovk2mbxMewXYcepnnHGQ=;
	b=ZDmH3Zf7V5jaoH01PoGcyCSemq0EVZdHxH6gTbn8vYRZh4leDDhAueD3UBDL8GyIFCL/oM
	VUhl+pd716FM9Omsm9lXxDeQ9IuCFTmuYk6SA6Cnk4t9boI7TJsoyzmEuExXfONH0QHPhN
	v6Mk5FqMGoTwsDrlz1kOXT+vkflw5/Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=17ddbz9y;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755125778; a=rsa-sha256;
	cv=none;
	b=QRnC6fCwaEteQKeqe3dm6ZzwGf4XzkBsWdM90MDyqeFWZG3gPtO+1MPvRbEOXIIowJbnVO
	y4qgmLc5LJ9LlAqYojMlDbyK4LoZV0mI/B28BMZCqMz9oTQEfl1FOQIxSgYDJYlfCwH0QI
	jO68RSgv1l2ENqONYwLuaFGVLFpIZrQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id AC0FAA57F7B;
	Wed, 13 Aug 2025 22:56:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA8EC4CEEB;
	Wed, 13 Aug 2025 22:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755125777;
	bh=d23EsXtELamPsXVJ4AIY1uWBmbAVOZMh52loO7Lxxis=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=17ddbz9y+pgU9Mv5Ai+T+ED66rlk3aQvwnrd9ondRRsX+nwL5+OUQz5KCMxADNpzo
	 XoEzH0Wxz0Bz4/JQLfK9ZIdazh/gpylEDQI3B77MJVk6Lw6hiUEBwIzOJVWNMD2efA
	 hL2yIjlNuIX4OkAC4ijVpQqkj3tSxzMHJcT1vRVw=
Date: Wed, 13 Aug 2025 15:56:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gu Bowen <gubowen5@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, <stable@vger.kernel.org>,
 <linux-mm@kvack.org>, Waiman Long <llong@redhat.com>, Breno Leitao
 <leitao@debian.org>, John Ogness <john.ogness@linutronix.de>, Lu Jialin
 <lujialin4@huawei.com>
Subject: Re: [PATCH v3] mm: Fix possible deadlock in
 console_trylock_spinning
Message-Id: <20250813155616.d7e5a832ce7cda7764942d10@linux-foundation.org>
In-Reply-To: <20250813085310.2260586-1-gubowen5@huawei.com>
References: <20250813085310.2260586-1-gubowen5@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7167F8000B
X-Stat-Signature: xrx75x9wz3dbs5ofir7no85613hfyh5g
X-Rspam-User: 
X-HE-Tag: 1755125778-474144
X-HE-Meta: U2FsdGVkX1++nWZXm3Hp21i7kTOPhmdPXTlYFAxY+OIJjVYh+agd69O3lQF/fQChZLp84/q8PPE5tH0HUU4HtruXYeA1BLoD3FWkVwJ6Viw3umnhuEeWroYZvXfsW2KLge6cmKNbTm4FQAB7GZ72S18eGThDW2GZyonzZKvZFziBIbCYYyA4ATkHUHbnZaHWE5TW5E6gAovVRpcvW4+RM5Ry2tDlzsZ8WHqToTm0TbBAzIZ7YfGcRR3UyGdtk2Yf3VlgOuVwd9lThGJemyGwfSMHGDO+6im39axjrhjSGevQFCI+1/BdiqPWeNJYdVwalWuONZiP7WGXlrBFvV9SX7GegD4Ifcu+pCJWpcf95Cy9oWTasCEnq7oGyrXBq0OihPQIc6N+Sdi67Dh9SCgaYvM5Q+hgaJ157+n0eBQGO+NNroHLlTm/bjzwCu0rikSeS8PtW++oX/NsijI5w5ciSj31tHbGmHut2g6zBE0qH22PbHTCG+hojnzhQEAz8Z4BftQZkJ1qG3jIpfli69fPTULAthY4citKK8WwgK1UMNuWE9UkLVVKW0FqmBauDgzhhln506dX8AHpDBEIpfRExf1NhSzWWdYTWeBVNEswMpy1hvnifjSolz4dvY4Deiq/ogbNkalOuwCCF/3bLatIzZad5DI6VanWEzrrB2mn/jydM1f9S8CYT5LgwaEUnxBFia2lRtBd3beQaKu24VLJxUEW1+mBA/sLuqOgHnfxK/6BrM0tgx9lex73CpubGidRrPh/6AwCjfyMU4lzS5NFhRrSACV9A2NRXCq81RwhKiELM0oJJ5gLWFsJh/treRDzIbAkpDmtmPjx3LWF/G6j6swQmOVRrZw9PvKUuOGK/FucPCiiiKt6AAFaX33tcIXA2wjzZUJ9C7Pw93d1gsKUtC7lzosgKuYUkSfslCX6Rf9NLAVTAIt/Bsgidgu83QTxoQM6InC5jy83NuTdEhp
 r4l/fOnQ
 Ld2YsVJwgOCwQBIkmgFlve0imEpROZ7CceOqlAP9CrffNyRaPJe/nEujaWf10n8QEzvBrP0Z+SRwUrZUS1WufXaUPeRV2udxEvUDVctc/U8YchZ/atx4HqyakWZza1bUq3aBCpHDXrTqXR5Nh30WcvpgTiHPpCltka+ASPAWwsMoW+xB3y9DUpOfp5DxnsMyAsgVQksVUqQp3LJbeGWfhkrFj23HZjQcbDLkLjyCLGKxczp+sYoLpr4lgB4Yi5Y6+5fBWxdgOaX1kFZPJXihBhUPXh459Pw/WAprdl02dvBsyD5ho7Y89idmHvUv89cOqUHbf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 16:53:10 +0800 Gu Bowen <gubowen5@huawei.com> wrote:

> Our syztester report the lockdep WARNING [1]. kmemleak_scan_thread()
> invokes scan_block() which may invoke a nomal printk() to print warning
> message. This can cause a deadlock in the scenario reported below:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(kmemleak_lock);
>                                lock(&port->lock);
>                                lock(kmemleak_lock);
>   lock(console_owner);
> 
> To solve this problem, switch to printk_safe mode before printing warning
> message, this will redirect all printk()-s to a special per-CPU buffer,
> which will be flushed later from a safe context (irq work), and this
> deadlock problem can be avoided. The proper API to use should be
> printk_deferred_enter()/printk_deferred_exit() if we want to deferred the
> printing [2].
> 
> This patch also fixes other similar case that need to use the printk
> deferring [3].
> 
> ...
>
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c

I'm not sure which kernel version this was against, but kmemleak.c has
changed quite a lot.

Could we please see a patch against a latest kernel version?  Linus
mainline will suit.

Thanks.


