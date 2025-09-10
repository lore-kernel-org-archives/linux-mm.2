Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FB9ECA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 15:52:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDA708E000D; Wed, 10 Sep 2025 11:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB07F8E0005; Wed, 10 Sep 2025 11:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5F18E000D; Wed, 10 Sep 2025 11:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B9B648E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 11:52:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 61EB9160139
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:52:10 +0000 (UTC)
X-FDA: 83873782020.23.760B52D
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf28.hostedemail.com (Postfix) with ESMTP id 53A64C0015
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 15:52:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=MQ1jVJwO;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=biG+FHOs;
	dmarc=pass (policy=none) header.from=yadavpratyush.com;
	spf=pass (imf28.hostedemail.com: domain of me@yadavpratyush.com designates 103.168.172.144 as permitted sender) smtp.mailfrom=me@yadavpratyush.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757519528; a=rsa-sha256;
	cv=none;
	b=2dVdc2ABEfDlY0FhnAAusqVBvUmA8c5fVMeDF5w95py84dsq7Kz+MX9lf498WyBPKQP321
	ugK2kGyOLVcwIQNZl4GpOZjJ+PcX1woKRBfETjfIfiBPZO117y5ySt/41kHiQ28obKmuyU
	c4Nx28tLNnsQ/+zKm2UYaty7JIaiKA4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=yadavpratyush.com header.s=fm2 header.b=MQ1jVJwO;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=biG+FHOs;
	dmarc=pass (policy=none) header.from=yadavpratyush.com;
	spf=pass (imf28.hostedemail.com: domain of me@yadavpratyush.com designates 103.168.172.144 as permitted sender) smtp.mailfrom=me@yadavpratyush.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757519528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TisYwmvR90ER1jazweHvbvoeDDNC29k3gBI9kEQjEok=;
	b=Kqk5axdmLoAVdROfYvdjTIMZbH5jV77DfgxgYEZKkFxRQjz8/qxxSC9lAzYfMude0jov4J
	QAu6yUsGJXmkasS2MVJC6bTxecEA0HD9SkFBAJS6ZysoRtoID8lWi3BzDFExTwjqjNfG0z
	qj6fQwucjBpU1xPJ+miGLCk1HivTaCQ=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.phl.internal (Postfix) with ESMTP id 71AE6EC0456;
	Wed, 10 Sep 2025 11:52:07 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Wed, 10 Sep 2025 11:52:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	yadavpratyush.com; h=cc:cc:content-type:content-type:date:date
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1757519527;
	 x=1757605927; bh=TisYwmvR90ER1jazweHvbvoeDDNC29k3gBI9kEQjEok=; b=
	MQ1jVJwOLKEK4TRtKuCZUWuuAQageX7JSvcKV/AAQjDLP1FOkBUGIxQeArtXOyvw
	RiCJOOQLE8dwH2yBZAmJUOZUH2cS8m0H8hQ0tq8RmBLEJ98dlLW+VO5WzwfTEiEp
	ZcHcL0j4TRgHRbzBPMVoXIN/TgUBSUkl0EwJIqNRU7bOY8hHPzRUQp5tomfYSYM4
	aaRy1m76V6CftjP7Er2hbHpueVeKDrzxiDB6gIEceqSRYYK3MlhkOMyHKszxkfLi
	RUbQ8ocKfpbnjZs4bPUh+x0Cqc6aVNmdHryM8Awp3jeJeLtIUlbZWLsONvCvHPyW
	mZCD/zorvOHIoYCH40mnnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1757519527; x=1757605927; bh=TisYwmvR90ER1jazweHvbvoeDDNC29k3gBI
	9kEQjEok=; b=biG+FHOsup8r5uP8IEey1OrJpI5629ob7gPzDpQqOAtxnhL3Zr0
	lAYHLmLmOnkk/ZFWAy4flV1Zywb3xJ/C9lu8b58qrFjRd1jGE0FnuxDKv1eLqzEC
	LdNQpk67UX6aieSLbuXzA1Vg/QFxHGWYD0Ncs9fWOg5ffSWPr+e2foIt7hOvmQzy
	iLlzxsge5Wr1zuVQhZZPD8cgQf80LhnC8Hn+wf2wU+wIA3OsFlc8DTwywa9Wv8MO
	sEfliZTWg+RaFEbiBvoEfwFRHJ48CPhT4kQMt6cZzi73U66cwxwe/KmU+RdG2VXD
	ivj6MGO/UgwX/gij06eXHRG+djGwjM9eu7A==
X-ME-Sender: <xms:pp7BaKOFqY52w3lZOybWzINO3ENFBHOBl4cBomOTthhrWe4PrdUqzQ>
    <xme:pp7BaHfg7LePI0HEfWmF70EegQxkrN3FIH16nDhz1Qs3U6sgN8W0Qp7GkMEZZEBcj
    yWK80xxSLGCsqAdFlU>
X-ME-Received: <xmr:pp7BaMy7WN_9-GXpOn0pRXi8Q9lVHX5GEN0I4gRAYoByjs7OssS_3SPKgmZPxv2wyT4IYbQ_d0nVYjLqZuQ-oN4ZEFZM_2LMeoJyu6JvhNyhs7e0IjPCTdEhtDBDylClO-gMWbLx>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvfeejtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufgjfhffkfgfgggtsehttdertddtredtnecuhfhrohhmpefrrhgrthihuhhs
    hhcujggruggrvhcuoehmvgeshigruggrvhhprhgrthihuhhshhdrtghomheqnecuggftrf
    grthhtvghrnhepleejgfdufeffuefhiefghfdugeegieejudelgedthfeuudffheeugfel
    hfevvdelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epmhgvseihrggurghvphhrrghthihushhhrdgtohhmpdhnsggprhgtphhtthhopedugedp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrd
    horhhgpdhrtghpthhtohepkhgvgigvtgeslhhishhtshdrihhnfhhrrgguvggrugdrohhr
    ghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehjrghsohhnmhhiuhesghhoohhglhgvrdgtohhmpdhrtghpthht
    oheptghhrhhishhlsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehjghhgsehnvhhiug
    hirgdrtghomhdprhgtphhtthhopehprghshhgrrdhtrghtrghshhhinhesshholhgvvghn
    rdgtohhmpdhrtghpthhtohepsghhvgesrhgvughhrghtrdgtohhmpdhrtghpthhtoheprg
    hkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrgh
X-ME-Proxy: <xmx:pp7BaE3RDLytsa2QtWwRt9RRI1nVOsBEmidFKrSV6h3zaLVCSt-7Iw>
    <xmx:pp7BaLfLXI8An1b0AqP9N5_8fMLlNdqhMGYiu_I6fX6GdOZu6vb0Cw>
    <xmx:pp7BaBW4-CrB3M9I16AqpIjPSXOniBsClKfdNAAulDJcszXWj21hbA>
    <xmx:pp7BaL9T2jEtjmUP7XxYzydsA-Me-77SLflDvRcsv8WP84tmxnRDrw>
    <xmx:p57BaIxU2zpoDgcYwn06gdAIZWSihVls11YMgzeC1z3eF4bswK9AsSHl>
Feedback-ID: i93f149c1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 10 Sep 2025 11:52:05 -0400 (EDT)
From: Pratyush Yadav <me@yadavpratyush.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Changyuan Lyu <changyuanl@google.com>,
  Andrew Morton <akpm@linux-foundation.org>,  Baoquan He <bhe@redhat.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Chris Li <chrisl@kernel.org>,  Jason Miu
 <jasonmiu@google.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH] kho: make sure folio being restored is actually from KHO
In-Reply-To: <aMGc-ExhkqwAyY_C@casper.infradead.org>
References: <20250910153443.95049-1-pratyush@kernel.org>
	<aMGc-ExhkqwAyY_C@casper.infradead.org>
Date: Wed, 10 Sep 2025 17:52:04 +0200
Message-ID: <mafs08qimjoez.fsf@yadavpratyush.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53A64C0015
X-Stat-Signature: aa3ssekkhiwanoc567ohc7g6suodwepm
X-Rspam-User: 
X-HE-Tag: 1757519528-206898
X-HE-Meta: U2FsdGVkX18+ey8AJajVYhuhEWTaGEI52Wwu7fVHdo53rTeXx0V6tRc5sttYU7AezSB8gfvk0ottIyEJZPxm47dZibccSfPIoYdUYlreBEe6XWJep+qUuCtLaKsC9KtNlLCL0MZgsPlAhMRD3sYA6wkXjQg3qRFNxh/t3ihKWUZpgaOojpRhPjSHkDETjCCYTUHJ1y/sqadM0GqqkzDwVajW1Ot0C4AYdRnEEjQyUfbW/p/fr+T24+4LW7EPfPK3JCq6k20UaaM+Kkyhj2MwBvA0LphZzhox/eVqfOoJPjgEhwRakSao1pWsWXN0yCZXtFt6iniqZAMIXJnzVgqT0+N0hAUagUJXvz11R/Qv420mRtnjrk0v7TVb/8FS51m40TL51MffgFtx4kXyvmooYFrsidYSQcZrmbS51tknR8L4myE4exmzCFD7KGPWNKbcXhVpbDvIpZww5lSvcrNCNB3wedcGbH8ehStsu66ip1p4Rn6U05ZhII5MH8zsdALVo/0FS0yL2VoxizZeIYnWLb6A2h6fNM8wRopf6/iKml2fbSIdqFDIyO8flb7yXXJ374z/PSsF4Q+skFQkZVAhB2QclN/+G40bWTrMP2+53ZAi3AkF6h0FEbW/9Uu2f5w3vA4N8i3Lc59Cium1Mh8XaSUTmECXfKMetSg4l0X8Fgbmh8xS8vUKVC0FGfMg8GXiW/ANm4tR+Zl7OZ0CcRr8MrHNbp30OcAe0oEHAyh3i/8S3fbZGOjMZBXPLBwCxkL6JvewsbCVdom3hwfzor2pmcdJqlnhafP6IIGuBdfK0m+jsqfHqSsYARb2+f+vS63H10o3qzkkZcmBmflDaBa2ZXYluVO4Bx8j4QB1HPCSBZ6olu79eB9zv4xFmV1MXvlyLveLrdXc/HHkXew6wX6AcnUdbfhzln63mjCVmn03kIZEg5PyrKDkcx6dkDT8x6dLhjNRXPcWgg1iV9wf7+I
 xJ0zpe/U
 KP84DUqZGUfBeB+sch93SyLWmSDIigfVKy8spnI3flpmbGMDf+VQAqYmgAGH/c4j2QY9jXcNNHtM36NgSsRSrY947fiFELlUP+cvLTsffyDZcfFtdYGfwPrjHfEQZAKI14MnlwnXbA8hkUZRGMV9DPQ1y2n0BcuRY54XUjteih6yPnn0w6u7CVR9Xk+oDZBLa284bIYtAvl0kyfYEo8AJs+JFoi1HvKHeY0at5t8jmiLp/UJ1LicmSpenN9tvnbbkTHcvoURHlSSczPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10 2025, Matthew Wilcox wrote:

> On Wed, Sep 10, 2025 at 05:34:40PM +0200, Pratyush Yadav wrote:
>> +#define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
>> +
>> +/*
>> + * KHO uses page->private, which is an unsigned long, to store page metadata.
>> + * Use it to store both the magic and the order.
>> + */
>> +union kho_page_info {
>> +	unsigned long page_private;
>> +	struct {
>> +		unsigned int order;
>> +		unsigned int magic;
>> +	};
>
> KHO is only supported on 64-bit?

Yes. Currently only x86_64 and ARM64. It is mainly for hypervisor live
update so there isn't much reason to support it on 32-bit platforms.

>
>> @@ -210,16 +226,16 @@ static void kho_restore_page(struct page *page, unsigned int order)
>>  struct folio *kho_restore_folio(phys_addr_t phys)
>>  {
>>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>> -	unsigned long order;
>> +	union kho_page_info info;
>>  
>>  	if (!page)
>>  		return NULL;
>>  
>> -	order = page->private;
>> -	if (order > MAX_PAGE_ORDER)
>> +	info.page_private = page->private;
>> +	if (info.magic != KHO_PAGE_MAGIC || info.order > MAX_PAGE_ORDER)
>>  		return NULL;
>>  
>> -	kho_restore_page(page, order);
>> +	kho_restore_page(page, info.order);
>>  	return page_folio(page);
>
> This all looks very confused.  Before your patch as well as after it.
> I don't see anything in the current KHO code that requires the
> phys_addr_t to be order-aligned.

Right, good point. I can send that as a follow up patch. But I think
this patch stands on its own without that fix too.

-- 
Regards,
Pratyush Yadav

