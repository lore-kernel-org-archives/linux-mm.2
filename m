Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 996C9606A330
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=S6WXGb+q;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=LNPA9bF6
Received: by kanga.kvack.org (Postfix)
	id A68876B05B9; Wed, 18 Nov 2026 04:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41016B05BB; Wed, 18 Nov 2026 04:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955DA6B05BC; Wed, 18 Nov 2026 04:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CF746B05B9
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:48:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5ED501606A5
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:37 +0000 (UTC)
X-FDA: 85447765074.16.1CC5E64
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1EEB040006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:48:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=S6WXGb+q;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L NPA9bF";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794995315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3tTzRsiHEws2zlKl6166Pd8xjKFQ47hlRmRKJ7QcwM=;
	b=0kTlRnuLBibMEAfkOAj8NVbiVn9rwRuBTX3z+utbMKf1KDrKsrEOij7mY73REtppJv3vII
	pn/3nCjA+/UVUD+txjQC1bM3hDH4HJLcbPOvGRq2i0dL/9J3MhC8PKaxRQ8iUi1tSSzy6b
	K51nKI8512kcTWD7AtGRbEB5EhXOSHA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794995315;
	b=h6KjiRS398w4LbYIqEutCUKP5NvS+JanAE6PVlL+3ch+X1K1XvXC/MuZQD41CD18XTwant
	0dZo3y7yIN5av+eAGh+3UUzHEsKzd1mS1xhQxbM6Gc2RH5OO2a/kBcB/xqyCKgUSMjwoVR
	ABi0ZUb2t476pAMyNLdiXE1c8Yjbigo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=S6WXGb+q;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="L NPA9bF";
	spf=pass (imf27.hostedemail.com: domain of arnd@arndb.de designates 103.168.172.149 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.phl.internal (Postfix) with ESMTP id 5E2C6EC060D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:48:34 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 04:48:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794995307;
	 x=1795081707; bh=P3tTzRsiHEws2zlKl6166Pd8xjKFQ47hlRmRKJ7QcwM=; b=
	S6WXGb+qbJjbxUTgKfFh0DTFPnWUpI9EQ+MRJzPPcNmAqRlbnpsva0qN9N+2q6I1
	dqzevcSRtCaEb476kPBOUue9URUESewonWa5r/65b9m6O0O/iv/BZrRKjKQUeHA/
	R0vKqxC0BjTzE2EcIwHO2i8nUu30LC+S6gSryejfz9wJGukJHShsIrVIjafQeh17
	xGED/AUQMmUDCk3D0TohSBicE93927kxRBa/0fS6FaGQ1EvXnywxD14LLt2cE2EX
	mXYNWp+bD5K+mGUKjoaSG+HGj4xLX+oscKmxbLTGAqv0y5tZqZCK+CKMNf25QVT0
	0qLQ0hV8FK7mrYvbtP24eg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794995307; x=
	1795081707; bh=P3tTzRsiHEws2zlKl6166Pd8xjKFQ47hlRmRKJ7QcwM=; b=L
	NPA9bF6KLr5hK9v17V9Y0UTrumaVYezQw1gruXqHLxW/7cpDBatGe6yZZJeWSkpa
	/ZT6gM9NeMeUV1SEeqNmZoirxtlYxbKV4OHWwNhpXYogfJ0JKjnMhVdFmANzrYZN
	jqsRWuVSvzKHJksYX8cmZ78jNtB9QvMs1jT0Vou7k4UMr82LJyo3C30YlAjJFFq4
	cpHXw0SqSdG1A+tqCuVPCxTv4zU54hXH8x6xvarwD7lPnHZDJ4Wu3H4s4MYOV9Sw
	nwLwbtNZSHypozMZwRCIqsD2DJq6X2s3n5MS2a7Oq7NPHktYMSUyK3jJ46FJCPEy
	zKS8r9x30BI4ZpaHHe5Dw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794995307; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:ICcJp8qGSuMnqMwxDVs4/cDwdcFuNIqAOQZpW2jbPAhng5z
	SD59J+YOqk9M6PJ0rLHXsx8NNEeSMZ1OIsUAMk3pppvfErFnp6PXK+0oZYhEQxD1
	fwDaUnzhHTnqOWloRvfWht19moDoU44LdDVSu7xsv8T4TpfM3WIXn4R/S2TtvMz0
	E/AsoypbyxvUzEl87E+Mgpw4/Pie/KZVpqUAJlQXgIK8cPPN22RCC44x4vq5rB4G
	xznEebuam9c8h+E2QDxsUVEDONJAyprPImLR5jpB0xkAYR03adhIEMwiVvp5lD3E
	6iujAlVxC2FJLgRpjjPCUgREgUcud7h4Jxfk4hg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:o1ZNBUMdgmZRFjQGvJCT8X1PeIOdnxDpY9ythOT5Mkc=:NdQqLdoVcsTAskrYI1FJtDTJy8FiZWNAwAbqq3w3to8=;
X-ME-Sender: <xms:YHT9alvCuN3JL_9c-toAGogtzwhCInTBjFViYNiov90YhiWcf_dniw>
    <xme:YHT9apRWu1eRnRfg6iuE3qiVLkmbB9qpJ27NADGLhq_X75viSN23swABlSi_N5uv_
    c3pWbFy7tZdQ7YRi6PBU_4H2Lf7Fw8GwcUIqAPbc6UUDg825fqpMj0>
X-ME-Proxy-Cause: dmFkZTEQnUw3sFO/J+KDZ5wTMqryjhyx7/y6yNzE9VcfWSQ2np6l+Yf+6Au26OrFy23XHD
    q+kC97X6kGXgA6vqSPGPEfQDWQ2vMTbJNlSqeMjc5kYk5NUK55hZXYfIPeSXR7fybsijJe
    3ldwVajPYU1lVvXUgbx6LqumEjlYZOyUCH31hVtg8wyJp1X0BNA9d9duqEwIcVZnRO+cZV
    0ze2wT7H5qksb2DY7cWBKvYNWqBrrQ3erPktQrTZu8vhtaVVjGR8q1vZOY9xYbpve8xolF
    /VpnRWtZLTOj+r2SFWPfJzqFFS017/XR4aLoUuUnQh/4PQDJnR8Ny6JeIi3Rj+OWCUAVSw
    USzYGuaD6wWc19GQqM8uBzzUQ5Pwq77McE8zw1Nr+eaYDOPtWyb784NtLyXUE75SRx97m0
    2RbY+WTXnYbF2NMhmoM0MNWQg+VIV0nIoboZks2dOKBJXBk8/cNqQyzaA9+E6PvHnkVaOS
    IGPa5nEB7GEfiGo21WrViSNW/W/YwQYiHx89/y8OpZu/NMDTDZaoQA1dTNNm19jSrHUOWH
    6lGvsHFhw1TzUqVwV2QQU/aPuC0HLnIiLZ3tFwirVJmVT3dEQXzsgcMMixR2yvAOGFr33h
    dxh/y9EfxAXGYv+0A2zSYuSc4/3H5eip4VmlfKT+PxCpj/aDLIoS/WDR2/xg
X-ME-Proxy: <xmx:ZXT9amc-jikSr7ODgA86wfQA4FAc6om2UhHVQYMYvOZKLhasITEamw>
    <xmx:ZXT9atphb6k7Rvu90VtwmzepKlAPL4YNd8LJtn4a0UTqVMOlK3Mjxg>
    <xmx:ZXT9andBn5XjFKBp8p0GZ-sO31k5S8dYKkEkflv5Yj4RzU_srqvOww>
    <xmx:ZXT9allimL9RLpsxW_AkORfJTK-jeUc1qIB4wVunFIbgAtoJXOXzIg>
    <xmx:a3T9aqUluMyKPmnty1ayKQTOHrsEPnZ6BdR6xTbyt9RixJCoIigugnse>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 43D7232A009C; Wed, 18 Nov 2026 04:48:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: A70rKOtn2eLk
Date: Wed, 18 Nov 2026 10:47:55 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: sashiko-reviews@lists.linux.dev, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andreas Larsson" <andreas@gaisler.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, "Ingo Molnar" <mingo@redhat.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>, "Linus Walleij" <linusw@kernel.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Lucas Stach" <l.stach@pengutronix.de>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Michael Ellerman" <mpe@ellerman.id.au>, "Michal Simek" <monstr@monstr.eu>,
 "Mike Rapoport" <rppt@kernel.org>, "Nicholas Piggin" <npiggin@gmail.com>,
 "Nishanth Menon" <nm@ti.com>, "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>,
 "Thomas Gleixner" <tglx@linutronix.de>, x86@kernel.org
Message-Id: <c8f80ac0-83ba-4d59-9930-ef497312e2b7@app.fastmail.com>
In-Reply-To: <sashiko-outbox-218796@kernel.org>
References: <20261116124832.662455-1-arnd@kernel.org>
 <20261116124832.662455-2-arnd@kernel.org> <sashiko-outbox-218796@kernel.org>
Subject: Re: [PATCH v3 01/10] ARM: remove support for highmem on VIVT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1EEB040006
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: q46p8njbnricand5mq5dyebbwsy73onq
X-HE-Tag: 1794995314-841610
X-HE-Meta: U2FsdGVkX1/7BtmkwPEoa7KAs1HfdbAZoVpOjhDZr5U09UafKaQEO1b4py1rhNj4+TPprCl3U+qzULIKIE++hEAF0GDjTx5tSJCzJs4wfsMzGuiU6EJ+h3SvS+f1CuKNaq6U099hZK1tmZuTfai15ASV3Qmph3PGyyC30g9PhIzxcViA61NfxaUs1r0UjPA8EA+3mT/gzHcrvUdF7Vu2/Y7Z5nh9ws1MESmx9papxY8jxHhFIuLrjzkfPsUxVH82JOiVr9dAIIgXr2GXZoQGxNm0h8xOpOBAgPPr698phc3kCwmT1mQiZIZB3G/A927JlwnVv+B3ybn14nrYD6VqYnWYmexVsyM9ADZsGKMc7cdgv9PVHAC0Mesc0xKaNL6hENanFlpCb3bPiAoyRR2d2ymzQwIDkVYspK2XObJHe5TpvcksmdPVNEO4CimTgL0dNgS9FGQFx8cuQS7Zz9hIHML0Iwav3Ke5HvZuNwYEGZII8Ncz0PZKqgT90eYuB5blkBNHE39FFW3UqkkZh2OOIlTXWKJnMXLnfMmrSIGZ4RsMDK6LEPNeREt/vQb50wWBCI1n1/aY8Z1DA3jotHMFeWLf0ZCcFlJuEl7x9Jdc8fIHwRNWg3TvJ3izWC5fQNGtAIKk0nfPFwUxcB2njGSdmYv+1q/SPzQ5a+TNwW3a1PapLY42etBd9Qlw58i9Tct+8ncsmI9fgo0MnRCAhBP6A8tCDTwthlFyU+SMLB4HKtf5t3guTbqjJWZwXtja4dscfa+cq8f9q3ZahGQtpxtTKl34OrO5Vbgotl5E4GOJKiYENOu5FUQyT97y9ifvXUWtKHZ2y7au1xBNmQYA7QjOg8Ua2vv487jaPOJrShE67Pee6IdaOLzvxb/Vt6lrEraXOabqSgEyjeRkNRm9hiqQSGSRtMxxFz1DH6rdFbF4u3tI53ZPRoiGSZwUgUOmdZ9oyeDO6NGzxRv8gmQFC23
 OEqkXnQK
 ZqHGlr32XjLMJD1BXQfbUlYyblAe0Gv0HKGfaafPZbqTWKxTfqj1ARM0vmn/E7UPk2Hpawr6MgSFHdmcBDX0ThHicBx66D52UQqQu0KiZTLmx6WGNJTtWzPvBKK/vqDVAkVN7DwGT1JdvmMdA6Iv4U0H5T8eWntuPjODhGsGK+72GaRXvEbr4zobxnEI5VdqdVV238yvCptropAsKNbNhXN5tKSJDBqd2naATilb9Tl7lSFnN0U8QEkccrqdSEGHrYlEU3fzfehIg9n+Emf16mhsQTW88s8PoekNhovSI0A89dGlkK405jjIGx8NLbxzgwx8v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026, at 13:49, sashiko-bot@kernel.org wrote:

>> @@ -178,14 +143,12 @@ static void xsc3_l2_flush_range(unsigned long start, unsigned long end)
>>  
>>  	start &= ~(CACHE_LINE_SIZE - 1);
>>  	while (start < end) {
>> -		vaddr = l2_map_va(start, vaddr);
>> +		vaddr = __phys_to_virt(start);
>>  		xsc3_l2_clean_mva(vaddr);
>>  		xsc3_l2_inv_mva(vaddr);
>>  		start += CACHE_LINE_SIZE;
>>  	}
>>  
>> -	l2_unmap_va(vaddr);
>> -
>>  	dsb();
>>  }
>
> [Severity: Low]
> This isn't a bug, but both xsc3_l2_clean_range() and xsc3_l2_flush_range()
> still initialize vaddr = -1 with the comment "to force the first mapping"
> right above these loops.  With l2_map_va() and l2_unmap_va() gone, those
> initializations are dead and could be dropped just like in
> xsc3_l2_inv_range().

ok, fixed.

>> diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
>> index fb2eb0ed7bb87..917a546af0b90 100644
>> --- a/arch/arm/mm/dma-mapping.c
>> +++ b/arch/arm/mm/dma-mapping.c
>> @@ -647,18 +647,10 @@ static void dma_cache_maint_page(phys_addr_t phys, size_t size,
>>  			if (len + offset > PAGE_SIZE)
>>  				len = PAGE_SIZE - offset;
>>  
>> -			if (cache_is_vipt_nonaliasing()) {
>> -				vaddr = kmap_atomic_pfn(pfn);
>> +			vaddr = kmap_atomic(phys_to_page(phys));
>> +			if (vaddr) {
>>  				op(vaddr + offset, len, dir);
>>  				kunmap_atomic(vaddr);
>> -			} else {
>> -				struct page *page = phys_to_page(phys);
>> -
>> -				vaddr = kmap_high_get(page);
>> -				if (vaddr) {
>> -					op(vaddr + offset, len, dir);
>> -					kunmap_high(page);
>> -				}
>>  			}
>>  		} else {
>>  			phys += offset;
>
> [Severity: Low]
> Should this keep the kmap_atomic_pfn(pfn) call and drop the if (vaddr)
> check?
>
> 52c9aa1adc30 ("ARM: dma-mapping: Reduce struct page exposure in
> arch_sync_dma*()") converted this path to kmap_atomic_pfn(pfn) so that
> only the kmap_high_get() branch still needed phys_to_page(phys).  Using
> kmap_atomic(phys_to_page(phys)) reintroduces a struct page round-trip, and
> kmap_atomic_pfn() never returns NULL.

done.

    Arnd

