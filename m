Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E612CC982EA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 07:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D159F6B0093; Wed, 23 Sep 2026 03:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC646B0096; Wed, 23 Sep 2026 03:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4DD6B009D; Wed, 23 Sep 2026 03:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 967336B0093
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 03:18:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2A466A0732
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:18:43 +0000 (UTC)
X-FDA: 85244174526.07.26B486C
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf27.hostedemail.com (Postfix) with ESMTP id 094ED40002
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 07:18:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FHSXsCJQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790147921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=56ekNPuyPueKv57BH4XNBicCWTvtMrrrTQ9jojGni+U=;
	b=qEjSPLC1ZScuEtTt7FPiQRGog1qre1rVk7GICU5fZ1C0a3I6ZqdGoQfKTIPLMUj+rWAyGD
	c4cbU17NgOVfqCgZOshDI8/yGqIZ5NBkgy3ay9xY8zPWCDTBb4nkvXEOxN9xwql1O07JaD
	gX73nKRwefIaZHZwgOBjevx6tnDTwpU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FHSXsCJQ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790147921;
	b=G/U0gjIIdJMwABBngbEHRGWF7L67BmBipynnYUFxDtQeJaY+Tu4A8IU/dib1lDO31omotV
	jbVbvqYmYyWc0hnCWp4G9OiH6RJR6K3FatxoxN79Ve6wj0p2YGqBWfbscGSZlGsNDPnfMw
	Y4oN6q57cYpbQZ8Y54uPqYNcvrcnZZA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ftIfSiBGVQtCnPrtNG2sYlwb3kX4tGScpi67ufltGms=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790147919; v=1; x=1790752719;
 b=FHSXsCJQcp2gatF8FVoRNlCOC3RUxKusFciABMnOKMktthHKbq2b2ZOwx6kOrSPpjx7os3yI
 /95+roTwVxLT2tjaAarjwQKWhn3YLdPJjaciTqRQgVH3GfSdXApZMeQ2B5NE3PfXb01CQo8kzCM
 iInnn1P+PNiR0Pz5fazcaZ9g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a804e1edd13ff3f4;
	Wed, 23 Sep 2026 07:18:38 +0000
X-Mizu-Trace-ID: a804e1edd13ff3f4
X-Migadu-Flow: FLOW_OUT
Message-ID: <8769d7a8-9442-4dbb-9828-01447e4320d1@linux.dev>
Date: Wed, 23 Sep 2026 15:17:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] mm: enable MMU_GATHER_RCU_TABLE_FREE for MMU
 riscv
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, kas@kernel.org, guoren@kernel.org, bcain@kernel.org,
 geert@linux-m68k.org, dinguyen@kernel.org,
 schuster.simon@siemens-energy.com, jonas@southpole.se,
 stefan.kristiansson@saunalahti.fi, shorne@gmail.com, dalias@libc.org,
 glaubitz@physik.fu-berlin.de, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, linux@armlinux.org.uk,
 vgupta@kernel.org, monstr@monstr.eu, chris@zankel.net, jcmvbkbc@gmail.com,
 will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, davem@davemloft.net, andreas@gaisler.com,
 richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com,
 catalin.marinas@arm.com, mark.rutland@arm.com, chenhuacai@kernel.org,
 kernel@xen0n.name, tsbogend@alpha.franken.de,
 James.Bottomley@hansenpartnership.com, deller@gmx.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, chleroy@kernel.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
 johannes@sipsolutions.net, tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
 ysato@users.sourceforge.jp, shakeel.butt@linux.dev, corbet@lwn.net,
 rdunlap@infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org,
 linux-m68k@lists.linux-m68k.org, linux-openrisc@vger.kernel.org,
 linux-sh@vger.kernel.org, linux-riscv@lists.infradead.org,
 linux-arm-kernel@lists.infradead.org, linux-snps-arc@lists.infradead.org,
 linux-arch@vger.kernel.org, sparclinux@vger.kernel.org,
 linux-alpha@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, hughd@google.com, qi.zheng@linux.dev,
 linux-doc@vger.kernel.org
References: <20260922-rcu-pagetable-freeing-v4-3-fe1ad1f1e303@kernel.org>
 <20260923061551.84398-1-lance.yang@linux.dev> <arN6JBJixHUjX2CJ@gremlin>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <arN6JBJixHUjX2CJ@gremlin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 094ED40002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: fiuwd48r7bwhh847wnwkosow5fwerdph
X-HE-Tag: 1790147920-167493
X-HE-Meta: U2FsdGVkX1/AOFJRSxZnpk7AQzNVP9ppuAPzIvO0as5kFKIaQ9NarPASfe/xkbLwdAcb5mZzhpwybZvoeyh8vuBN0FFr7N9dCNWu6KBXvGkq5ST6QTlLf8YcQKvGioN/9GVn/ObDvNZYVW2A13rO0UbchHGDqzRvM33sTWEk6XhbsGEZdLi5WCh/iMaR6NVAF1VWa+2HPJRHcegkE4CvQY5aVdDXNaijIk6JZkfAdNkCJ0J2xiFrS/sBRADVYsacZrH3yyJ9NHKF/8nUnn0Fj9hDqRBheFaYl3waOEEcv2R/OhDeQBBKwMfl2xmB0AVkUt7OvvoE1V72FKbjnZHdSdpAACqn/KLz7h8NjtqqQVnXfmamTgv9GRMb+LEUY+NGJtZgga/AUPkhrNCSzP50ylUGcLeXJSK6Hz7ioqURH7QkTdjobrkenI6dL8Ouaqvasi9hpTq9FelQtJXgMNiyXj9FCbPU52FwgHud77s6rYAo5sA9FNDN1c5znu5ouJ8wLJl/lKSgUWSrG3WiN5KiXPVfTUeS7LqRrspW8FLXUXTagV8vwPBfZPgQobvaSEu0aSRAk+jBwDCP/NqUYPDQH8wQUCEFMVDPHWN1Vfkd/YEXrtwta0tpNuHAUnVAaqyiYzCjS841pSP95zkZwlcZnNiPs4JsKEA6Yl/rofwd/Ah1NQF1jvW7JHMKU2LbzkzHjBwUU4j/qv+vTxUKxyPFZCQdHhv2Pl5jGC9aEDWXlS5ctt2qqXJ3AQjqGQS9XGzSzt4dDhXuPF4REawnAvOqO2pPqc9YyyIl52ukXOaga3Wr6uwJknZLzOmuC555ybmwSqPr7sabwK5SnieJbVwzEyKq3AqwkBNHUh/2hq50XetUDxONpzzSkh5n8wMnIFll1grBHn9J7KpMbSQqMFqJg88WRyM/p0t5GA9buc7wIz37aRm4RTsYPEOL8Zb+tfMUWBKXnkoThsWKAKJ1dhx
 ZVe45EHW
 XdGBewdsdvXMco0zc+26OQBbVdrNlQbrKropOSLLLZTC3RtkYWxp7kxOHpABJXGx8qR4D3xmk/ByhVV3JCvNhoYbTh9Z3t82qAtRXhlaPULhmoHxBHAqh9RunRCP8htTkiz0co57hM1RuA/RGv2ltv28K40rnfmoAPAh/ne/ZEfEx2fnL9IyyljW+WHQgJPQjkGIKrdTsG+0PksfgbcxIBrllb8k+uvN0x2BIYXEWtH5Uv4WafAk/WpLyDF3MzGdtp4431kDjGrwCRxJnh2E/5dVIdcMynOBm5Km77ohxbrjJsnyTqsWo7zg0ATGAcsftM8pOTsM6bWHBsntdwRSpzx1P9EZZ7ZqxDN6fUGcN283G7lK5EvwdrqbxSCP7nncCSvxqfy0weGiAjPv2pUFMaUSixbUq7rxRUXYicv78wXpmBN9ecbEMkRx2GRN34B+qSRvrziZ/R4xrgMA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/23 15:05, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 23, 2026 at 02:15:51PM +0800, Lance Yang wrote:
>>
>> On Tue, Sep 22, 2026 at 04:35:34PM +0100, Lorenzo Stoakes (ARM) wrote:
>>> Currently riscv gates MMU_GATHER_RCU_TABLE_FREE on CONFIG_SMP and
>>> CONFIG_MMU.
>>>
>>> Commit 69be3fb111e7 ("riscv: enable MMU_GATHER_RCU_TABLE_FREE for SMP &&
>>> MMU") enabled CONFIG_MMU_GATHER_RCU_TABLE_FREE for CONFIG_SMP, CONFIG_MMU
>>> riscv builds.
>>>
>>> This is expressly for the safety of GUP-fast walkers (CONFIG_HAVE_GUP_FAST
>>> is enabled if CONFIG_MMU is enabled).
>>>
>>> Naturally a single core system does not encounter issues with software page
>>> table walkers being correctly synchronised across cores, as there is only a
>>> single core.
>>>
>>> However, CONFIG_PREEMPT_RCU is still available on a riscv UP system, so for
>>> a future RCU-only page table walker, this guarantee is required to prevent
>>> concurrent page table teardown.
>>>
>>> All page table freeing is already done via tlb_remove_ptdesc() so the
>>> conditions of CONFIG_MMU_GATHER_RCU_TABLE_FREE are already met.
>>>
>>> This forms part of an overall effort to switch every architecture to this
>>> mode.
>>>
>>> Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
>>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> ---
>>
>> Yeah, for RISC-V, page-table freeing already goes through
>> tlb_remove_ptdesc() :) Tested on QEMU, no issues seen :)
>>
>> Tested-by: Lance Yang <lance.yang@linux.dev>
> 
> Thanks! :)

Cheers!

> A cheeky A-b tag possible too? :P

Sure thing! Here it is :D

Acked-by: Lance Yang <lance.yang@linux.dev>

