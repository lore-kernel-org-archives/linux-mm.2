Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A628CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 15:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 097B26B008C; Thu,  8 Oct 2026 11:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049226B0092; Thu,  8 Oct 2026 11:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2C46B0093; Thu,  8 Oct 2026 11:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB4136B008C
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 11:10:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5AD5AA02EC
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:10:25 +0000 (UTC)
X-FDA: 85299795210.20.3D6FEE4
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf15.hostedemail.com (Postfix) with ESMTP id B1141A000E
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:10:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oS54NXGn;
	spf=pass (imf15.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791472223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/CEeLfN16W336hJkOodyM4bPanb1U8QuIH15EGrUS4=;
	b=nYuCKSsvC6daeJNjcGdAEB8PgneUiM6I2NA8fvRgTceYXCHf53T+N9ubZIlVcWPZ8cZJ1N
	Pe+bCJSAf0k9x2unIZp2jJehX6Ft1paw2tT1XinKyO8RFcI8eF5tP/Jg/4acn9rwUTp/tZ
	RVFs+s9xDr+ZoX5Im7/7zxbPaNeg9Sk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791472223;
	b=iXqzl9dyy+h3ZXJb+JJ0mE6Bty8i1nZmBM7z2r1CrT6Ed6dXkCSw/aUj4db7SGeMYDgQi2
	IMgI9mGV5S1dFtr+5+m2W0+GQApSqtr5w3fg9nCrzw0q1FZfoqikrusPAMD29XdlqxAGET
	4RE4ibroWsDcopBN64wanROguaFU12s=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=oS54NXGn;
	spf=pass (imf15.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261008151020euoutp0220b133fd63f9b3bbdc21c169ebbde20a~cln4huxOw0356403564euoutp02R
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 15:10:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261008151020euoutp0220b133fd63f9b3bbdc21c169ebbde20a~cln4huxOw0356403564euoutp02R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791472220;
	bh=p/CEeLfN16W336hJkOodyM4bPanb1U8QuIH15EGrUS4=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=oS54NXGnWESg8OmQ/iUNSPpUcdmD5JSqstt22ooyjfcQZ6rgLbtMNDxWsDsHW4cRL
	 ef7K/aHXJfROSsQ3wIhpsDNoLGTErxaTT7hzjtbGJFWAroxWeYh/ybkiMApF2lpYu4
	 oeROedwov5Apmqc4S/mHJQLCPTBDtxRXgwajMLsM=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20261008151019eucas1p26347f907cbb12ee37552797103387753~cln4RSRBW3092530925eucas1p21;
	Thu,  8 Oct 2026 15:10:19 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261008151019eusmtip2cf77e50b80cb40ed87be766138851542~cln3sJP_H2632026320eusmtip20;
	Thu,  8 Oct 2026 15:10:19 +0000 (GMT)
Message-ID: <c1f42a7d-708c-4a6c-9925-9bb9806be958@samsung.com>
Date: Thu, 8 Oct 2026 17:10:18 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 2/2] of: reserved_mem: allocate and map the reserved_mem
 array early
To: Rob Herring <robh@kernel.org>
Cc: linux-mm@kvack.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mike Rapoport <rppt@kernel.org>, Saravana
	Kannan <saravanak@kernel.org>, Oreoluwa Babatunde
	<quic_obabatun@quicinc.com>, Wandun <chenwandun1@gmail.com>, Andrew Morton
	<akpm@linux-foundation.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <20261008140515.GB183998-robh@kernel.org>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261008151019eucas1p26347f907cbb12ee37552797103387753
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea
X-EPHeader: CA
X-CMS-RootMailID: 20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea
References: <20261008094125.3197971-1-m.szyprowski@samsung.com>
	<CGME20261008094130eucas1p1120c66c914aa2b93fa3d7e6e494e7eea@eucas1p1.samsung.com>
	<20261008094125.3197971-3-m.szyprowski@samsung.com>
	<20261008140515.GB183998-robh@kernel.org>
X-Rspamd-Queue-Id: B1141A000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: booxerw8tnywpsq6c7t5rm8q9rdsdopf
X-HE-Tag: 1791472222-66288
X-HE-Meta: U2FsdGVkX182SjRAPYw3T/DgozQiv8qjE/LnT85yhrS18UfXL4V4mIkMNJ5s1EsaLygANiQ6Agb1j+Ks8VxFsL01dURsMK5DW/IPF91/R9EWp6q2bVnrQSIB4joOhwvqSiTyHPFXQ0Qjgsz678xss5PSxvZd/lo6x3fX03ZeO2dyAR5wwbYRUNcpNmNmP/k+65eJ9Ox9s21WqDLe8NmYQwQ/U53zM8XBPhMnt2OZBDcbpGJDjsRIRSh7PBp95125wspx27xwUcilW2RsGyrdK7MwdFjo7TiauriRokb8PlQg2M12MGD0savHmTg0ssAhoB4MkFZnhJzQ9VsBBk32sHffpuWb0u5ydSMEpnvvcXE2zTAGuZ9q4xUpb4+bNP63ZLR98l0pt8JIcjrVhEeKcTrJEByI3ZjPrFz8HzzkHKSStkmfYq7Az0n7eQaiOWV3smnEMPE5YxwHmZk0D+3y17xACwESqDd06b28C2WYuHifkgIuThjUzdMPtpXovduoQt0NJkGx7tZbuQfBaZ158ulisWHSrR3LYyCAr55ODwCkkgMpYvvcFSMSNtY2x33CWVKrrMnf5CP5rsMueTlBRoDuUlJ5RUBDAatPGNgvEufgegzSLjUMefnGT46ZU3QhaZyRaZtV8Rc9E+vbCZR1Lrm1Tzy1U7c9MTjTrU0/1d1TpYpBnnRtdNg7Q5ZKCTa2NXQ1uW8X6HL/ay8rSFsInslWuxdgFgtcUAhNqOFrbERWV56ZQUqdWzZkFH/cNSR1yTpoeC0TkTx6bxGlCYF/P2m6AXo/no5PkUv97ieTmK4FAGQt2r/SqXUfMEYeh7HE3e6CdpYxbxNxyblzkzWYwFdUuIabzJ7JMEqxqDt2k9wUeRNt18WOeb/GkGiLpyqZtwj2pULIIlcOwERRbK+qtCzMQpUz/E1sG0dMe8Fk3xYa06idokLLwY97Mxk6GkpWSUSdxf3QnRk4RRDbPqW
 v+qqMtsl
 gAOzYXkXuphkxt1qKQDBdmaFFWPDFFygOrzCe+Sb1E/MqvC2YsAYmyfDsl7s5bI9FvQp4c0LlwwdvGiYL+CAVBsFugmB2L1vcnewyzWXukhIAMQB936PSQ1Hw4GsDVRFFCyUYTDtrVxZY7tRIDVVF6cajNjtuhdT2GX/SwjVLSrWdOTo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.2026 16:05, Rob Herring wrote:
> On Thu, Oct 08, 2026 at 11:41:23AM +0200, Marek Szyprowski wrote:
>> Get rid of the static, limited-size reserved_mem array and replace it
>> with array allocated by memblock_alloc_raw() and accessed through a
>> temporary early_memremap() mapping. Such mapping is needed for some
>> architectures (like ARM64), where linear map is not yet available during
>> early boot scan. Having a single, writeable array with all reserved
>> regions removes the need to perform two step initialization introduced
>> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>> memory regions are processed"), so all regions can be processed
>> directly during the early scan again.
>>
>> Suggested-by: Mike Rapoport <rppt@kernel.org>
>> Link: https://lore.kernel.org/all/asc6brs_g0ky0wOM@kernel.org/
>> Assisted-By: Claude Opus 5.5 <noreply@anthropic.com>
> Assisted-by: LLM
>
> is the new way...
>
>> Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
>> ---
>>  drivers/of/fdt.c             |   3 -
>>  drivers/of/of_private.h      |   2 -
>>  drivers/of/of_reserved_mem.c | 251 ++++++++++++++---------------------
>>  3 files changed, 96 insertions(+), 160 deletions(-)
>>
>> diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
>> index ecc923102622..a58efdcbac7f 100644
>> --- a/drivers/of/fdt.c
>> +++ b/drivers/of/fdt.c
>> @@ -1283,9 +1283,6 @@ void __init unflatten_device_tree(void)
>>  {
>>  	void *fdt = initial_boot_params;
>>  
>> -	/* Save the statically-placed regions in the reserved_mem array */
>> -	fdt_scan_reserved_mem_late();
>> -
>>  	/* Populate an empty root node when bootloader doesn't provide one */
>>  	if (!fdt) {
>>  		fdt = (void *) __dtb_empty_root_begin;
>> diff --git a/drivers/of/of_private.h b/drivers/of/of_private.h
>> index 0ae16da066e2..895f868b4cfa 100644
>> --- a/drivers/of/of_private.h
>> +++ b/drivers/of/of_private.h
>> @@ -9,7 +9,6 @@
>>   */
>>  
>>  #define FDT_ALIGN_SIZE 8
>> -#define MAX_RESERVED_REGIONS    64
>>  
>>  /**
>>   * struct alias_prop - Alias property in 'aliases' node
>> @@ -186,7 +185,6 @@ static inline struct device_node *__of_get_dma_parent(const struct device_node *
>>  #endif
>>  
>>  int fdt_scan_reserved_mem(void);
>> -void __init fdt_scan_reserved_mem_late(void);
>>  
>>  bool of_fdt_device_is_available(const void *blob, unsigned long node);
>>  
>> diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
>> index 300fb236ab59..6a5e53243bb7 100644
>> --- a/drivers/of/of_reserved_mem.c
>> +++ b/drivers/of/of_reserved_mem.c
>> @@ -24,12 +24,14 @@
>>  #include <linux/slab.h>
>>  #include <linux/memblock.h>
>>  #include <linux/kmemleak.h>
>> +#ifdef CONFIG_GENERIC_EARLY_IOREMAP
>> +#include <asm/early_ioremap.h>
>> +#endif
> These ifdefs are the only thing I don't like. early_ioremap.h is always 
> in asm-generic, so do we need the ifdef here? Or does the arch have to 
> do something to pick it up? I don't remember.

Those ifdefs seems to be some hallucinations I missed to fix. I will send v2 in a few
minutes.

> ...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


