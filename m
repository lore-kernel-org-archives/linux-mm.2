Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F70D606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 00:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=dl7ITDEd
Received: by kanga.kvack.org (Postfix)
	id 80F9D6B05B1; Mon, 26 Oct 2026 20:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E6136B05B2; Mon, 26 Oct 2026 20:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8986B05B5; Mon, 26 Oct 2026 20:57:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4326B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 20:57:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC3FC808CA
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:57:09 +0000 (UTC)
X-FDA: 85366592178.01.7D7C2B5
Received: from mta1.migadu.com (out-247.mta1.migadu.com [95.215.58.247])
	by imf24.hostedemail.com (Postfix) with ESMTP id A628B180003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:57:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dl7ITDEd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793062628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsJH9SASUNWFflHahFZZJn4h1VTJyinMN4QMIMxAPS4=;
	b=X+v2QIjeclfIOPGwKKBG3rprlq8WM83hG+kWO8dXpNKEXn3nMA0zN80MHSOONLamROmoTj
	nJ0dRcwPU9N5dTQWBjkiX6bbXnygSxKh3ZSeE05X5q8lRww6AopafPg428DhP+rF8695ox
	hU73fP01HKPa6BypZDoD/ESVkk0vHRg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dl7ITDEd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.247 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793062628;
	b=vbCaEyTglLbGhGWcRNh1MelJF1UcEeKRfLoXTEuOLPKwtk2rfZa2Zmtu/s9MAAfTcId2v9
	orsOb/lJXiKdgwok05P0pcyPa32QKnQnE4vrm7feq4lvytstlK6P7hKtVkoFXfk9AyYtEY
	2tEy+MhTfuEGmV7+0xQ29iK1H2RTXX8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=UnoGUuIms3PHdCzo7ZbWAA1oZjGiGwzK/IuTXEdmG6U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793062626; v=1; x=1793667426;
 b=dl7ITDEdSjFeaQWHmp8RV1B42iesi/IaItGkhIT4yLCiWshkUQrIvWU3g8Uj0lzVwv5z34CK
 SgcgKZSVtuYo1Mr2fOVFjw8QwhJa8BXmrp2fnXv2aEYMwX4TcL5vzGy4yMmm/Rutze+ZgR9hYUI
 cC1zXRCNyle1Qi1jFNNNzQ84=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 12bbfc182f6c0f69;
	Tue, 27 Oct 2026 00:57:06 +0000
X-Mizu-Trace-ID: 12bbfc182f6c0f69
X-Migadu-Flow: FLOW_OUT
Date: Tue, 27 Oct 2026 08:57:02 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Subject: Re: [PATCH] mm/vmalloc: Bail out if in softirq context
Message-ID: <at_23pZ03p93IVpq@fedora>
References: <20261026102503.30860-1-urezki@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026102503.30860-1-urezki@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A628B180003
X-Stat-Signature: 1nb5kbjrou631qfb9rr8d4hykc6e9gws
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793062627-897314
X-HE-Meta: U2FsdGVkX18n69qwJsRFSL0Ra3X5t0u7moZH6zUBXjfscNCNk7mlPt08GRsRrKMULT3/CJZiD7pDcqGeuw/B302RAQr6af048S3T53nkVDiApGL24K6b+iIe6ZmG8IKSxflE13DGBZ745GeRqhMmGut36nc0rmui0gJHFQjf/X6FKixwWW60n/lvdGnJaBWx2gol5TKEPSXvbHzA741Vob03LsN19IALJh8Z3pxqUNLEGmsb/l8ggU7YwlKjtxunkhtpzYF/qRaof5l7M6G6PbFY3cRIQkMbDNQEmRtZWpf9CCxiZhD/i3JpThuydeYNb2KCj/xPOG3w7qaY1jkTpHPdrWYUD0gSfXQ5e6hgnF9wSc0ClsjNurRtCfZSbKxRw2eMS6oI7ZoTpgXaL1CATxZQdBtt5dJx8+ux/rGoB0IyrEsgmayCwB3A8u/uYeatOv+M5Sz5cRR5ObIgFxkW3sfSWU8qwL5wGsjtFMltczukGrykz1CZOQX6Myyi3zeT6gb9kxOYekiHf4pR6Z8O/gi9IogH1aOXyurUdLTxW6KYCvipjFp4i1OTvCmm9AKm4jIbRWoN5JrPkVFKEs5t8cD5fTmKrJmOLcokQi0JBHflScDCGlsh5MK2ZTkNyouwCC6r4ZHd7Thd8EayetTn7krvtFIv1BLO66sJgQRRh44V4hgGU522J1apBZzvNTuxD8loTnK7/I2e3Q0Cb6LzpCSkg8WABpN1wK/rGPzjOHpBtObEsUOISW3St9/OxhhTr6rGQ0iWI4RsFnb0B9cJDW3rKa9NkGtQy83u/lwKuWkcmzKEmo55Xi2YmOKwTLPfKelFauKUMusF2c52gNKJyBwAW2kjA1fQzg50L3vV3WlSjhx7MkSrlD7sUECyYL3GeCRJSoiJuSt3AgKCVAkxpQq3IkQQw+mOqa++3dgAyg2tqFUYNMaPVsm065QxYBkMte80BMjjL2KmoA6x6AG
 ym9lS2t4
 RtYFkQHhE7f76S5X9a0+PP9HfBzZl/yjXCyapLhOtUroD+PVnUrQoFyPdFIHiOzX3+vUN70K8zC5/3FSMQO3DmHeWf00E/1GLiAgRjMNrNIoGJCLrqnqQ/AkSAmDa03d7Gq4oT9DoLLEimRzP+sPpCe8NQAvC1v5RcBj80O8z2jp5R/2ZXTgq1aTXML0VpL8C/0JKoxcP9Z2rUkCpXlr7RASJeasoqnFf2NYF7UbjEOFr8M+6r01HRw13gea3K1NpKsavg0cFEASlavqaSIm5hkxDR2DwGUzkloHyGChFW9xNPae6KhyAyv4dcA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 at 11:25am, Uladzislau Rezki (Sony) wrote:
> vmalloc() is not allowed to be invoked from the NMI,
> hard-irq and softirq contexts because doing so may
> deadlock on internal locks.
> 
> Commit 04aa71da5f35 ("mm/vmalloc: do not trigger BUG()
> on BH disabled context") replaced the deprecated in_interrupt()
> macro with explicit in_nmi() and in_hardirq() checks, but
> unintentionally dropped the softirq context check.
> 
> Example:
> 
> <snip>
> vzalloc() in a task
>  spin_lock(&vn->busy.lock)
>   <------ Hard irq
>    irq_exit()
>     process softirq on the same CPU
>      vmalloc()
>       spin_lock(&vn->busy.lock)
>        spins forever
> <snip>
> 
> Restore the check by checking the caller's context with
> the in_serving_softirq() helper. Note that, it is still
> allowed to invoke vmalloc() with disabled bottom halves.
> 
> Replace BUG_ON() with WARN_ON_ONCE() for in_nmi() and
> in_hardirq() case.
> 
> Cc: David Hildenbrand (Arm) <david@kernel.org>
> Fixes: 04aa71da5f35 ("mm/vmalloc: do not trigger BUG() on BH disabled context")
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 7521b9b3bfd2..36e6e3be6ba4 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3252,7 +3252,13 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>  	struct vm_struct *area;
>  	unsigned long requested_size = size;
>  
> -	BUG_ON(in_nmi() || in_hardirq());
> +	/* IRQ re-entrancy -> irq_exit() -> process softirq. */
> +	if (in_serving_softirq())
> +		return NULL;
> +
> +	if (WARN_ON_ONCE(in_nmi() || in_hardirq()))
> +		return NULL;
> +

LGTM,
Reviewed-by: Baoquan He <baoquan.he@linux.dev>

>  	size = ALIGN(size, 1ul << shift);
>  	if (unlikely(!size))
>  		return NULL;
> -- 
> 2.47.3
> 

