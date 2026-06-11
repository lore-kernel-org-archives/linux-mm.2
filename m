Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 987C1CD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 18:13:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C421D6B0005; Thu, 11 Jun 2026 14:13:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19B36B0088; Thu, 11 Jun 2026 14:13:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56C96B008C; Thu, 11 Jun 2026 14:13:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A54146B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:13:54 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E44B1C38B2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:13:54 +0000 (UTC)
X-FDA: 84868430388.10.6332CC5
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8A51C120005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 18:13:52 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YtBujQXv;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781201632;
	b=7E068zmLtKG+sInxJkTLIKRy1ls26lOZNlhoreqliE49GZqQ2yfc60L7PCIrLO0nMbHaPh
	dTVqOJNw5krJFPOx4O69xdSfahmpvT3rS/AD1Z7O92O1+pQm/W/8BTsWpq3LMJg9vdQke+
	ddH3o/EaDNrcjOyHIQcpKaCkumjLLYA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YtBujQXv;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781201632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+NORQ2IRJIRisTTgzwSC0LkRdLJJYwziNqvDlRjm08=;
	b=JmXjpHkq4wiavDr7YndxVIt2OCGWKEbX57uAtGwUIkHZ/NDp+V10OAUKtmqT07ZhCNAo1x
	ZAvpZ28521UFfaHPL7sZ9O3olQz8oAFIJN0tUByGS8JQVa4pkCATxqxYGp+Yk2G0JKSHAX
	sEA7tE7TyqhZa8C8K2XrupTRGk449WA=
Date: Thu, 11 Jun 2026 11:12:46 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781201631;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I+NORQ2IRJIRisTTgzwSC0LkRdLJJYwziNqvDlRjm08=;
	b=YtBujQXvREAfYj88Bkz7J0KTKXdpb6DCTXgnZmaYWRSdEnNHuF1XQmRjKXVrhTo4NJ/uLN
	52wXFWxEtZVVxD620XfeUWfRsBHum4RlikaxCX44LJ3zGkzklN0lxPmhD+PBN56CAxplxO
	rD3KRB0AR1mtZpIiKAIZ11HNLcCcG2s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, jp.kobryn@linux.dev, usama.arif@linux.dev
Subject: Re: [RFC PATCH 2/3] mm: drop stale folio_ref_count()==1 check in
 do_swap_page reuse logic
Message-ID: <air6hhJihxGPsRIe@linux.dev>
References: <20260611105124.98668-1-baohua@kernel.org>
 <20260611105124.98668-3-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611105124.98668-3-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8A51C120005
X-Stat-Signature: hsh7ugznadttnzbi84fxymrjurwz3hwh
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781201632-863902
X-HE-Meta: U2FsdGVkX18vnJrIoycgvIoCgLNtVTSvQIYD1re52DIqMEuJJcXTPoHxhDpPbSSOhR7LLz1gsME6ONx+sP4B9oFe4ZM8yDUvA3UgZ4n1WG7fNZ8UXR6gXgaCm6N43vJphFs1T7eFKi8+Bi3E7psMq5eqQ5vPuFcm4aRk8yxHLq/3eo7FoJyvcsWKA3EtVbQBL7KbGEfqh0c2OcbbxXCi5A9aYkWzDWCg6Pbt++obYHTWW5j/M/fUPmC1vrQKgEk3aH1I1nqO1ZoajRwKGFImmD3Ky5nE09qsAmRUQdtDegdNEKLRp95LFwpZJOHmKvQq9dGAioYVttrhS9FJT+ikOL13PhzUqokXzmXLPI1HfC949KaC3fHhsCo01TKP4GIigNFvHjDN4ujVkOIrk9Huhr3by5FNLEsOVIXrZOUjmRkDGF6Rnt0ho8+3QJVckBfXZ9ptFcpebD8n8RL9X9cZ1PD0SFYxxaFn2ROpOBLMGGTLQDws29whwhzse63jHct5xaG7kzJlYafCcSPQaWQY7mw2Lu/Mk2FCtNbb9t2UvhC8KnxjfE4UD71b/JkME9vJ5whq7f3Q3yt3R4dsTvflP+IteNwNYN7rGg3Qiak+kvYNPC/RJuzFelHzz7KGejPwpGLQ4q10lRZmKGHzjIozn39zH9WhaKQbXA9/1w3xmeYqSejA9u4vfxO4N9onIg9ivb51q6epvIMn3IQTkKRzT7A+3qOkkwwf6nMJzhTIlNIQu3guPAbIkm8/DTe4M7eB/5jdvU4t+Xkoheit+5DbszyM5rasRLhhdeP0+jmV7pVXJuJc1MYGcV/39HLIk1oU67Tb+Mr0UTHJwWFsUesZShxyLo0U0JSd1Bhl3+kOtQJiDiJ2HXN5xWbr73hzzZI47FRkRmUWnE/gf+XMxaNS1MdhPN+0pVP91c73g+n2OBaNJrZTTX3sR/Zr9fUMCjTAx2O/idIDMl+CS0yvJYA
 inCHJVYQ
 Ou/5b4k/FSoc7IbGZARYYm3913kEGFasYiVsjC5zC1WtRvEb0IFcbh9l8REbyY6oDYK97Pqmz9kVKyf4j955T82zG8O7ePFOaFK5urYJ6ivMdP/EHJELOzU9cgmOH1JEHhW+v2Nbc3EheKQzPXolnNg3u6W5zls+n0LuhJtzVbSIcaaldyJWjW4p6HxdRGrQ1Mr+QO/ym/aiE9/8eMPum0IrTjWUY2R9Y/mRtQRgrWqXK5/m3Qm/URj3b6+D9a9sf+9ONprQTKLHsbGaDdFJd0NpQxDUzTqS746rAon41EMyYAgI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 06:51:23PM +0800, Barry Song (Xiaomi) wrote:
> The "we just allocated them without exposing them to the swapcache"
> case no longer exists, as Kairui has routed synchronous I/O through
> the swapcache as well in his series "unify swapin use swap cache and
> cleanup flags"[1]. As a result, folio_ref_count() should never be 1
> in this path, since at least two references are held (base ref plus
> swapcache). Remove the folio_ref_count()==1 check and update the
> comment accordingly.
> 
> [1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

