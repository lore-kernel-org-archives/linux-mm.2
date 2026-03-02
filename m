Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3674DE9B37D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:34:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EEBC6B0092; Mon,  2 Mar 2026 08:34:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898676B0093; Mon,  2 Mar 2026 08:34:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 771906B0095; Mon,  2 Mar 2026 08:34:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6AD666B0092
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:34:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1315DC02B7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:34:49 +0000 (UTC)
X-FDA: 84501218298.13.67D062D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3DE9B1C0010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:34:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cJzFxhlE;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772458487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ny78k2NJq34CpDWboS16uyq2R3/xJSjQAKBSWnCwwh4=;
	b=1uc2hkAboPHXkkt85ezzceOSt2bW/9UsEoq7uIC30MqKK2uaizSJTUIv+OApbo2GmdlxqC
	0d0zSoeRlAk9soLH1vOtnYbalEBGOR3CLNtYx/mH0kN9j8HtCQUzmN8NOzU/IedQBZd5vT
	oVnOTBcc4cMYRLvGaMpQjYDlZZiHpes=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cJzFxhlE;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772458487; a=rsa-sha256;
	cv=none;
	b=SqfK+KQ2Xc3KZKR7zLb6hOG+NLB7qg1WV5+4wthaoE8uujSHZKIFJI1roG5FAbutFgM7Cx
	ticLtf/F85qyefA52Wtka3CymR8XGho8zB+e+8MA5LUhhjtT7h5vVzAa/I7X2QqZEvzJfV
	ItjI1DwkiRPDwryEBmD85Rwir4dIzoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F5AC43FC9;
	Mon,  2 Mar 2026 13:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85061C19423;
	Mon,  2 Mar 2026 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772458486;
	bh=7f9Gcp4+1LkfzXFPCa7PcQqPFKqy4PcM0mCYaMby60g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cJzFxhlE4FbWzbo5g/MSsO88667jBeaaySLaLoBd1bxFWGi77nyUK3rvGNE5eZ6FS
	 OvQoFyJcHhWifxV97kZV86n/hrxIAwuPOywLDum7x+i2buY4ipn0S/kYasF0ykquWo
	 MqP4Pt7NdGDVxT7awVmTEDXGPnTxD3fJ92vd2DIk/1t0qCZniFUQYMFmzuYvTb2xB1
	 uk5T6zUHG6+PXx6wYCCtaXWGxbqfIdwEcbqt2MsLYkNE63m6ccC2X3Y58rxrEegEUA
	 z5mqdciGCt7Ldwv/T7JBKY/c2pYkt1omagB+CrCX3Nr6XSO0kWDu0k976LiWpBDgVJ
	 6gmvj29jmeaKg==
Message-ID: <303e86f9-f86c-4dc9-bfc8-d32c8eeb91b3@kernel.org>
Date: Mon, 2 Mar 2026 14:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/5] mm: introduce zone lock wrappers
Content-Language: en-US
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Oscar Salvador <osalvador@suse.de>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
 "linux-cxl@vger.kernel.orgkernel-team"@meta.com
References: <cover.1772206930.git.d@ilvokhin.com>
 <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <849dee9c47df1e6fba97c9933af0d5a08b8e15d3.1772206930.git.d@ilvokhin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DE9B1C0010
X-Rspamd-Server: rspam08
X-Stat-Signature: aiyjrwyf7jdtmkcgetdd9s8bygpben56
X-HE-Tag: 1772458487-353519
X-HE-Meta: U2FsdGVkX1+RRX78SemfNzl1/xLsGGNpTll4u4291WOcL/aP4pJgf++MDe2cirwLA0P8IXa0RdUd7Zcc77F//he/rmVIYPvLjlSZSe/Qn27oPUQehX1lLE94WQijFriUnjPtNhOb84PKsn3FsPMVQOoHEneptPZFyvGJqY07GB2eCgUQaaDfUpURZiBteVKz/BmSbopOtPBSNAmDSjdUW3TWKfgYMLzpFI+zk82qu0CAn++cM5hoIqGjMyQstNTQ9UTzyG5yG++IJR6Y7/2wbE43t0qj3eT8gIScIHU4jt2dBXZpQC4NMsoA9dOjOt4D5KVWqG9MtpLPwS3m+gqFrU2ajrr8/h/VsjmnIhYlwYP1DRZa9v+DinCvCqSI0iuu3Cagzf9bHX3HmDdZ9SpPkIbMriRHivomr4aBGp/JDOUYID+yV347o7mV3GCDZkuhoUMONjKpW+NT6rpZ2TzNkVLpWzoQ+Aue4+T0p0dZCVxBX1EyxN4NjklB+o6ImIGEsHIvEuh7T12sMViHAeOfdwEs9801413e6+d6urhQJwe6sNhG3aSom1yQjYgXaAjt4aWkrFh0EXUwhb9zWV8c8Xk+wh9eTrJl29VTn2McsKO27GESKxtZtGZQDOZIdFTF4kTRgmXitke93oHnnQxRERLgyHuzvlWu5VeZizdQRrRMUlPVEtxAehVjnfCoedZfrB0YVbWLETT4IDcD3qHTx4gCDVPO1Pqz3RNAoOfqM4QOKmnsW8Zi3Cz+6J/o9UgCP3p9rADKYV7RU3x8wVK9kQsRhuGFdbzE79OW6SvsIK4cauhuxM9hD6xACBH42azWU+E7lRc79QWUTLf1WsxIR+LrseaNESzEP3Ss8AgxWsiGjGzj4dad7obSvFEZrw57RHKbjzHjXkM+efXNy1iEWUDSTcpEo/OtZyWpd2Cx/X1jmyqvGyCb2+Vp2d9CmwK5nNqvA27LKmycTm0OqNT
 7vFEqUIc
 uaCkOr2vkLypdv2Uw+0unDCcxwIa9nUL2B9QP2hUWZjfF7JR70b1ForrN4z47a2dsIKARqi+9cCiHpoD4tPM7O+Z5IO++ys/movmmR4nloTm50YmYYGMwLx5yhMrkepVBdNvLpLWeBejHWULPtLGMDxD5ZQCQvTLVqkYFpQM2nL0mcyUMMoP5bdz1Aqy0wD719J5ERj7RMfbmtAGww7MwIyP/OxuM6/yoh4XSP/kBHxOn2Ce89e0gelBRaHPEWyyiaeH28ff8qHLAPxW/IDlBpLNW65ode/pxLeA4/uq2tsxJhVMrq4J85P1E0kzMAacsyfrQ9B76qHAvqhIBd6u/JqsEL/f87E+pcgI3iTJ47+PyLwLLShFwLFL/VA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 17:00, Dmitry Ilvokhin wrote:
> Add thin wrappers around zone lock acquire/release operations. This
> prepares the code for future tracepoint instrumentation without
> modifying individual call sites.
> 
> Centralizing zone lock operations behind wrappers allows future
> instrumentation or debugging hooks to be added without touching
> all users.
> 
> No functional change intended. The wrappers are introduced in
> preparation for subsequent patches and are not yet used.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

*checks patch 2 diffstat*

I think we could do it as mm/zone_lock.h even and not pollute include/linux/
Even kernel/power/snapshot.c could include it in a somewhat ugly way.
However we should also later look at moving that particular code somewhere
under mm/ really...

Anyway,

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  MAINTAINERS                 |  1 +
>  include/linux/mmzone_lock.h | 38 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 39 insertions(+)
>  create mode 100644 include/linux/mmzone_lock.h
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 55af015174a5..947298ecb111 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16672,6 +16672,7 @@ F:	include/linux/memory.h
>  F:	include/linux/mm.h
>  F:	include/linux/mm_*.h
>  F:	include/linux/mmzone.h
> +F:	include/linux/mmzone_lock.h
>  F:	include/linux/mmdebug.h
>  F:	include/linux/mmu_notifier.h
>  F:	include/linux/pagewalk.h
> diff --git a/include/linux/mmzone_lock.h b/include/linux/mmzone_lock.h
> new file mode 100644
> index 000000000000..a1cfba8408d6
> --- /dev/null
> +++ b/include/linux/mmzone_lock.h
> @@ -0,0 +1,38 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _LINUX_MMZONE_LOCK_H
> +#define _LINUX_MMZONE_LOCK_H
> +
> +#include <linux/mmzone.h>
> +#include <linux/spinlock.h>
> +
> +static inline void zone_lock_init(struct zone *zone)
> +{
> +	spin_lock_init(&zone->lock);
> +}
> +
> +#define zone_lock_irqsave(zone, flags)				\
> +do {								\
> +	spin_lock_irqsave(&(zone)->lock, flags);		\
> +} while (0)
> +
> +#define zone_trylock_irqsave(zone, flags)			\
> +({								\
> +	spin_trylock_irqsave(&(zone)->lock, flags);		\
> +})
> +
> +static inline void zone_unlock_irqrestore(struct zone *zone, unsigned long flags)
> +{
> +	spin_unlock_irqrestore(&zone->lock, flags);
> +}
> +
> +static inline void zone_lock_irq(struct zone *zone)
> +{
> +	spin_lock_irq(&zone->lock);
> +}
> +
> +static inline void zone_unlock_irq(struct zone *zone)
> +{
> +	spin_unlock_irq(&zone->lock);
> +}
> +
> +#endif /* _LINUX_MMZONE_LOCK_H */


