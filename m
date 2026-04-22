Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8597FA1FD7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 16:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D95846B0088; Wed, 22 Apr 2026 12:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46016B008A; Wed, 22 Apr 2026 12:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5B7A6B008C; Wed, 22 Apr 2026 12:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B52E76B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:40:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED46912036B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:40:29 +0000 (UTC)
X-FDA: 84686754978.02.A116177
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 49AB51C000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:40:28 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgWr7Be6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776876028; a=rsa-sha256;
	cv=none;
	b=bBUk3RHmXK4zm5ApHFyh3KpV4xDjck+xMrz4vXS7gF10andX0SmQ1Z6mSM9zb3zidM6M+e
	Bdd1OrdWhAoIi3cfdcgavSpjfKqWODYRC0+pNiL4tOntmHbDS35vgoi+7PppjQp8mnN/7l
	uLiUyoVHLOh9wG8urkU9ELzsYpp3nJk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sgWr7Be6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776876028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uXCZ9liny0ibaRRmg5MRNArL0gN+gBKBflsqo0kXWSg=;
	b=ZsHYDDTHG1G1/2dSNr54N3ePEGRG0np5eIkWi01/mhUzFxf4njirOQqwAEBupXtb02EWwD
	F1V1Xjtbt4y1oCJWmTonvA2YaVVMvfOekMSQyvKEzA1IjLQuE+5Vo0+/uUSVF8WQ1i6CVA
	oFCXYJPTs7ov97+OqFj470Dyvx5pe5M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 331AB61332;
	Wed, 22 Apr 2026 16:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28124C19425;
	Wed, 22 Apr 2026 16:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776876026;
	bh=DD9wR0CVcjkt1o1rnlcqO3CHhefCQ8vj0jVoRmhcPrk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sgWr7Be6YLxsr2RHnnSdgwLMmawN1WI0MHvXxzUcElKlJ4mjBd2EeIIGG/I7RRAoq
	 T3JBuMnGuwZMqTBFciw+yOqhfaz1RNpn/O/PXJWZoM6CpeKVTk108UHCQ99hoFXwjK
	 nrrYs6byef69lX+NDLIDhyIxb4myvhtSTFMjuChlcZ+pDT/WNp/P/94WBzOhZi9V46
	 IHez9Xg2fgEmUVkuSsDD6NpDwhwht+eTobaeLZhIzVcx7fc3/E/vtp6JDsJuhfQ714
	 QSp7sspx0JrvcQTMQmk2k9vOPZ+FGpSZNrNpryPap0hLgasQtb5VSr44dugEYMkssG
	 Ce1u11MbX48aA==
Message-ID: <a6f17c2d-147f-4d32-b7e4-181f3e002942@kernel.org>
Date: Wed, 22 Apr 2026 18:40:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: fix regex pattern in CORE MM category
Content-Language: en-US
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>
References: <20260422123726.517220-1-pfalcato@suse.de>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260422123726.517220-1-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Stat-Signature: pct7zoewi45qa4nhzo6c3m8ff5aqwiwk
X-Rspam-User: 
X-Rspamd-Queue-Id: 49AB51C000A
X-HE-Tag: 1776876028-77276
X-HE-Meta: U2FsdGVkX1++/B1/GUMqZaoOWGPX5Pdq1kEXrzSd3E9MCj8hmC7VM9EIDkTdlmlMtSiR1+kDuC/fBoMlowT0UN6G0jEBSZpF5A6aKVlps4mUAggVLQmmsmQNaKHykcPpYSExlMA13TVl3b2spC83sdVZAiab2OtOWdN/Gujh1rmS//A0wQ0RTub16he6en0ydYhw/kA26iAMYM1/MU0hI+k6okbH42ZD0sxMpe1iLdscv67Vv8zyADR/wnzZC9FSKzzCMdV7U38T52lNROwIdZLMBjPtLDF3FOfSsPuvw0z/bdNkdOQ3BIM8gRfGXi8lcZu58NnvogIfq9y3Uim333XPSVCH9B3WpttRXPPVrqSQMi9KhWBceC09dJc44z+HXkVdw8Wqh7dj/1QvpvilAHZbCkPSaHpOTY3clgvtLQvRdV5qe0vbdWAMhkBk7A1JcDawf/yUsPtyBcT3WSKqsokgRS4iaIxjcbMNvWp1GOPgxJibjgvAGTCMfgIT0FZN1UQoDozuLfrfCXOCuAIG09l/x+2+w/NnFMnKcYxYxBZfl4qKZNGwQQRMkt0yszNzhftsq7zqxaefTwY60gUpXqKwiqIYLOMfUSdaxUmqqyIvS0Jq9p99gU0IpfD7ar1qIOIQFHqa20sCu0YP5S3mbSfHQfqNYeTjz2m0/2tk3tmmXXPzq+f+TvxSQcbqrlyXlhqoW9jUUwjN55f6UWuKVNmuNhe1vrjCi0VO1W1QvxO0gjZP8S4P1XP0dgo9BMWENOiZxf0qAFkNT7FCN+yrJRdQUJgxCHR8V3KFto0KZI8y/yPy2bKTvJSedI1/4p3BAT9A7XrJyLExUlWizIS9Zk/a5oC2QHC1oCgH7ZZpfV7MXGQI3FZxxfG9EtwWrDt5eFq2CO9m32EgFn0w0CrEd6K59FqjWlkzFTt8EElS+kZAsQN+5ho90d4Y4tCldbLjMnwlC6r3MXmUjq0IU8l
 /MjH4I9H
 pVFtF5ro9S92jbiiSWGcEJl6xHyP3nbqP+QGzkVACcwnMjVHGUOz5bdGfOt5hl/VwuZ/nn9C1R1Fyj2GCeZyPJsLrKStTykPXztsgp7o7xevt4PIWFe4R8hLqKvjcl0kxYvkDjhd8XmzTynA6MxTjGjcBbBWB2bOHDUmJoO31l03G6pIchvxa+DDequDqrkE/c1SxeVRoYzK5C3WMbHVqeDOSNdem+mleq3FQDMtaTUNZMSOMq3UeJrywRMQZ8ULyKDdkE9gxcSmMEgaPo43gegZgfrSxqxVO2Ov4kbEHIn7EILOu6m6dX8X3nQjsB0sGI9zATNCe1E+fJBxs0fJHhRiaXI2/DXKO/ZBKojDcoTSIYaE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 14:37, Pedro Falcato wrote:
> The pattern "include/linux/page[-_]*" matches every file that starts with
> "page", because it's a regex and not a glob (so it has the meaning of
> include/linux/page + match [-_] 0+ times).
> 
> Fix it up into a more regex-correct expression. Doing so reduces CC's
> drastically in patches that touch pagemap.h (which is maintained as part of
> PAGE CACHE).
> 
> As a side-effect, move linux/pageblock-flags.h explicitly under PAGE
> ALLOCATOR.
> 
> Link: https://lore.kernel.org/linux-mm/20260422005608.342028-1-fmayle@google.com/
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d25342ca8aa1..224c15299acc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16804,7 +16804,7 @@ F:	mm/sparse.c
>  F:	mm/util.c
>  F:	mm/vmpressure.c
>  F:	mm/vmstat.c
> -N:	include/linux/page[-_]*
> +N:	include\/linux\/page[-_][a-zA-Z]*
>  
>  MEMORY MANAGEMENT - EXECMEM
>  M:	Andrew Morton <akpm@linux-foundation.org>
> @@ -16961,6 +16961,7 @@ S:	Maintained
>  F:	include/linux/compaction.h
>  F:	include/linux/gfp.h
>  F:	include/linux/page-isolation.h
> +F:	include/linux/pageblock-flags.h
>  F:	mm/compaction.c
>  F:	mm/debug_page_alloc.c
>  F:	mm/debug_page_ref.c


