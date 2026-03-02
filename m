Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7BEEA4E10
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 14:57:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD3266B0088; Mon,  2 Mar 2026 09:57:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA0956B0092; Mon,  2 Mar 2026 09:57:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8CB26B0093; Mon,  2 Mar 2026 09:57:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 982976B0088
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:57:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 619EC139064
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:57:09 +0000 (UTC)
X-FDA: 84501425778.08.6CC71D0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id AB8E34000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:57:06 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ikqD6uAl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772463427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=51FG2UnZd5khg0RiqyUJE+vDT2282n/46yWgskAeolw=;
	b=kRhjSmYqIWrk8RmaCK67fm0IneLjtz+fX/lfZSnJnGvd3MMDX91BQkfJmtLFG1wGVojCan
	oGsunKbtvi+IGcoLYwwNHj4OJRJtuSnOvvzsKGOxp6ESxP9og6VSyOJRrc8mcOG5Hv6Je5
	3P/G2PK5Ajq59DquUxrlJhN/ThA4Dp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ikqD6uAl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf01.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772463427; a=rsa-sha256;
	cv=none;
	b=U1GZ8YqqNb5OolG65hQdutto3j+xm135BF47N7zdosSKwxzJblYrsPlETcZiLdYoegBjKQ
	e0hkkNuj+naS0cA8o5W5K/OwzSwSxCJtUr4D/B/12yWs+YnC3/Q9DncOIFH9aEGpPmT9nl
	CF4JY2VNtWj0CQ1Z4qY05gx0pPR2gFM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=51FG2UnZd5khg0RiqyUJE+vDT2282n/46yWgskAeolw=; b=ikqD6uAloCgZUSOvOS1RgqjF4j
	0XIj9O9goT/8xRogpP2thUUsSIS6z6JWEPcQH9XZaVqqzGvygD4VsIpoHCr1qyKzC26ftB59EfJj4
	ZGmXp93LBinORiESM14NyWGh/7+QsJnxk+EgUkkCTpW8LcSlBacpm/5Tz9r8d3yMTeKHR7p/EvZPa
	LnsXDLD9suCcGnHP3/FwMEA8mhNGTTsBheT81VAn3/XPP0Sabalo7OY2Zq9wiCkH5hfCZ0iaMIIAN
	booolOQAPvKEaMjwKIc5sHw7R58mGIjeizpynkcC6PUcaiHg89lm4LO7xxSozE8eKTfj2NL0VoMs2
	DvbBhhPQ==;
Received: from 2001-1c00-8d85-5700-266e-96ff-fe07-7dcc.cable.dynamic.v6.ziggo.nl ([2001:1c00:8d85:5700:266e:96ff:fe07:7dcc] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vx4hZ-00000009dtZ-23cs;
	Mon, 02 Mar 2026 14:56:53 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 06C34300B40; Mon, 02 Mar 2026 15:56:53 +0100 (CET)
Date: Mon, 2 Mar 2026 15:56:52 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, dave.hansen@intel.com,
	dave.hansen@linux.intel.com, ypodemsk@redhat.com, hughd@google.com,
	will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
	tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
	hpa@zytor.com, arnd@arndb.de, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, shy828301@gmail.com,
	riel@surriel.com, jannh@google.com, jgross@suse.com,
	seanjc@google.com, pbonzini@redhat.com, boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev, kvm@vger.kernel.org,
	linux-arch@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, ioworker0@gmail.com
Subject: Re: [PATCH v5 2/2] x86/tlb: skip redundant sync IPIs for native TLB
 flush
Message-ID: <20260302145652.GH1395266@noisy.programming.kicks-ass.net>
References: <20260302063048.9479-1-lance.yang@linux.dev>
 <20260302063048.9479-3-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302063048.9479-3-lance.yang@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AB8E34000D
X-Stat-Signature: 6wkpfkwaxryhc9indoezqc3z386wd9m7
X-Rspam-User: 
X-HE-Tag: 1772463426-296735
X-HE-Meta: U2FsdGVkX1/o8FltGo18Lu3XyKoXa7S/Jy7AgReTeAcv/S80uojWzMfYVA/2/Z4a8OixKP0j3QSsIVkqRS2InaZP9Sjql6qSZQbLOS2BvQsQD6VBm6WSs71JX0+XczFeYNFN62w4kJvKiA1mr7E5FNy6Q2PhcfMh0er3IYJVUiAyZlkSiW1BWT/ehTsYJZ8UFtaeIgJVmf+w2ri80OzlPFG0Nobrtq/XJfK1ujMI1qBTL4IcqTNGzYFFBs5zMAixTRtVuHYQgyNBhZ5M00pm5UKPew4c+5U6S3miLH9Trg+o7PCCVV74yMPckBdmnxAfuiSgKm13r9q4A9nrtdaYV1pk6ifOBf93f958uNIjpCO26OYa+rKUmFNauZx9pDRjN0N6R9V+Ervlg7qhYUm6EkVXS6wh2/OboF+mu636Ikh2/QzBFzNJ7Un6cQYqWiLuy/my7rlPRRuu7rE1yDCZUwcLHyI36q7cXgFNEC8Oke07iCWfBFtsSob/T4sxtHrQUUR7mgqHDuLRB7V+bzvBT/4rsGQVmYi9NStuzedoYDjzdeRX0vddvuonxdKDYBrb7CYXAZfFWtfQn06SfzeZuTzHuAcdKb7QrcOt+Y3HZYuIM0rMO9L4Gc3hG4dckvKuwC+3tHoqbMj42/ajqnoQMcuFHXcNqBkiQ3bpN1fm886A+2H9NKOq1XZU5ezdzC10xszhmf3w01ddnOta+1X4D7f9/9SPlDzm9MRATwNSEBtpoEoDQi6/L90umLhhwhtHBiDxeBiqpRdhNVw0ksEXOFuXKnkXtCGKkGVJZoOTckLQEQ+SJlQekRPYEtmaBpNsU2hNoF+SD5jDMOucC5bKMmF6ZhI5nLiqzlmrqxyAyyijwBGjIUmmhQxw76l6gunuWDlssgJ90PnMSGvZ3EvSpuNyK1jvO4IyC3KKkILsp9xvkGzSX0x70u3d6kxkCvCUk0iIRkCYGM1xULGGTPo
 2M/0htXp
 8Evv0A+Eqo6d06JF/XHh84/wEnh6TlFZ2BCqpCfF+3sRyDpPXz3+bktUDhNJPuAVhD3xyPj9sNlgDssaFVHUlHNAmWq0AoYHRx6ceZQxzoxNN3UUoxaNXwy7UbINT23FbLgtZOt7UQAtPGyuIEzirQ7vIMwyt4jsLoXTBqJrn/vnAFUpXAmUE6PJCzGLweUo6xqSnsQwmZX4yQXJv7ey0k6fNf0IV1qK9N/7yA8gnh2MXmQU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:30:36PM +0800, Lance Yang wrote:


> @@ -221,3 +222,18 @@ NOKPROBE_SYMBOL(native_load_idt);
>  
>  EXPORT_SYMBOL(pv_ops);
>  EXPORT_SYMBOL_GPL(pv_info);
> +
> +void __init native_pv_tlb_init(void)
> +{
> +	/*
> +	 * If PV backend already set the property, respect it.
> +	 * Otherwise, check if native TLB flush sends real IPIs to all target
> +	 * CPUs (i.e., not using INVLPGB broadcast invalidation).
> +	 */
> +	if (pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast)
> +		return;
> +
> +	if (pv_ops.mmu.flush_tlb_multi == native_flush_tlb_multi &&
> +	    !cpu_feature_enabled(X86_FEATURE_INVLPGB))
> +		pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast = true;
> +}

How about making this a static_branch instead?

> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 866ea78ba156..87ef7147eac8 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -5,10 +5,23 @@
>  #define tlb_flush tlb_flush
>  static inline void tlb_flush(struct mmu_gather *tlb);
>  
> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
> +
>  #include <asm-generic/tlb.h>
>  #include <linux/kernel.h>
>  #include <vdso/bits.h>
>  #include <vdso/page.h>
> +#include <asm/paravirt.h>
> +
> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
> +{
> +#ifdef CONFIG_PARAVIRT
> +	return pv_ops.mmu.flush_tlb_multi_implies_ipi_broadcast;
> +#else
> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
> +#endif
> +}

Then this turns into:

static inline bool tlb_table_flush_implies_ipi_broadcast(void)
{
	return static_branch_likely(&tlb_ipi_broadcast_key);
}



