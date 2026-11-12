Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0379D606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 12:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=G92ewwS6
Received: by kanga.kvack.org (Postfix)
	id 070446B05E2; Thu, 12 Nov 2026 07:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047D86B05E3; Thu, 12 Nov 2026 07:38:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9F826B05E4; Thu, 12 Nov 2026 07:38:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C12F26B05E2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:38:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B3AB14059B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:38:27 +0000 (UTC)
X-FDA: 85426420254.03.B91D269
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6D07E1C0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 12:38:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G92ewwS6;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794487105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwGHYWqkzjPKzDNH4i/tvvgZ4hxVWyzdRGgiuO5uYi0=;
	b=n4BaW71YvC9uGu69VLImmdIrB10NCiAp9AHuUDcgke0bzN/XGjyWLHxprWXESMGyFNrOSb
	GuGPWN6K7ErevE5x95FK4Wjq+CNPk9MeAKty0Q6Zn0Rczbi2srNxGf52fp30/nHp9DsgBH
	YZQYYpeGdhQPueO2XifIsVsGuNBqq0g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794487105;
	b=iSa24Iu15rr5lgQuHSKIOTcdYNSNYVh0+gbX3h5kjdCv/vtsdn/N46DyEcv+Cs3/wTuSah
	ezDROrV4/sUx0KR6C+zzC266XTie9oXWrtP30GFG8DtMjsIEkkWu64C8VerWKiPo4IrPTs
	/mRdVWRGHBkNxN66yBg2xiZrdWPtWdk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G92ewwS6;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 354211477;
	Thu, 12 Nov 2026 04:38:21 -0800 (PST)
Received: from [10.57.59.183] (unknown [10.57.59.183])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F0E6E3F673;
	Thu, 12 Nov 2026 04:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794487104; bh=GXDArifiTXzGS/TEyKUeQy694OV8tzZyyHhxUDTufKU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G92ewwS69xI/sQnwPuFxDuaGeeicD5gWXRAQcqnYkeOnE+1AhuhQD+T9u+2gEnSvA
	 8Tz0b5fy8Nanp500jVMIfPIBqybgWOu28wUx9eUNS6BsJB8hlKLfKfowurrVqb8yg0
	 gegWtANRaNOjC5bAe0P7rnTdXxQKCb9wTnu50CiQ=
Message-ID: <7b92f7c8-1543-447e-8ef3-aba608141699@arm.com>
Date: Thu, 12 Nov 2026 13:38:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 07/22] arm64: Initialize POR_EL1 register on
 cpu_resume()
To: Yeoreum Yun <yeoreum.yun@arm.com>, Mark Brown <broonie@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Ard Biesheuvel <ardb+git@google.com>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-7-aa6c4d9603bc@arm.com>
 <be361be8-c5ad-4ff7-a6db-7b0815bfe1d0@sirena.org.uk>
 <avNH_AdvK9AqvfF7@e129823.arm.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <avNH_AdvK9AqvfF7@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: ii545nfdzkd41mjcw99ep1ir7xfyaf3f
X-Rspamd-Queue-Id: 6D07E1C0007
X-Rspam-User: 
X-HE-Tag: 1794487105-801613
X-HE-Meta: U2FsdGVkX1/89mQgk5kaGFwceM6G/OtW0bgQviUfeWkYgdie3YWwl3wXoAkkBzN5B9k5iP3F03Fod8T1xuNAi8fmt1PkxbckaIIVC2Mors2FwSn/OcsrHxRxtsPwOvuPnw2YxCNbolT8RptGIm7RDYovn94YkXbT28StWqJCJThzuL7Wxiq5MZq3R1Mrea4hTy3DEX+B2bHvIOtnf4k8/amHUqHTm7IPglnJN+vC+hLL4CUTpytUYFgYKfOKKd+UNKFhZfSmtVRAIgipd0W0V2HzD3p0ixwj/yO4juD2nXxuPFZ0QD4MaHXwjhljW/wurhsuz0Hpxt1It6I2sLzQg4lTM8o+swRchE/WOJsI4kvNQEujRDoHC3fm+IiOXoiPpasMySGRFpH4mhhIEvCLRHP9c5QGOih6mQWEwpt6Hpgvt8tYwlJ25CjQU+Oz8wDOlFntlCOipJR6sETzquFNNKkWtgtts5mVgPObeJQb3UXN3hhr6YMVCaI4zqqX3Ge4en1n4Iw9BKcVM6K6w21irP3OcHurfw7b/GWHrfDGMsemj5usimC4OzMi3FEdSOldD/xbGjVERZDn3x0rKeGZaYfrcDNGEN5Bk+Yfd5q7fk+5xoGp9x3YpEVmjoqh4VNHkuqYwX0QfongJcXMaooJpbbQnFuu4ndnqIQMAznQE+L9nHrn1wh48e4SQnvS4HPTM+v7OWWAHAnb9S6kEy25vmpHtGrqwoqWcZOKbJipgZclhnKnyfJaw+NCzMSYYHPitEbczyvxbF7rIUC7+3OQ0GwAgH/cYNft4M5LMKtuo7cM2U5TlC+vAkSJxsUlDrvtLbM6GFP00XniOn9HBG1bVSYv9NXzo8nc+4Se6l5zXLDKfzD80bW8ARscp1v7VYQJHn453FJw8OZ8c7Xvdk41SxcRdpdwsB4vHZ0IIwjCbH3W00Vk5WI6hNwTiu5k7Oep6Zzgthom0qdIbgbUY9T
 uuhhmcs9
 GTnpSyE3J+lXcUTKJCBvE2T7WuVdxUh4pt0UUrsb3tr3lCntPFuJfl+1lcHDqOr3DTFKqlkCvLwUPoEdSsZaXkf0FuOsSh7VX0eAPOZEMiz+UBb2ybPvs/S7yFOgXQsxPOYhCjWSjfV7d8Z8GLNa3Dc+rUjuXvlmCD652Xa+v8GhWQ+dmmUMn+E6QRxTBkX+44ikZ/SVaAmZp2Eowb1jzk2r2Gn0vanr9Rk8WSKwihfuI8zil93B0ZdHGyK2l+zHypAylBrJOOn2itjghkHdEN7J4LvPg8/oVMFttPG3nD7W9TOl8Ug9Odw3IL33/OP5KAyr1QlC8coC6dGVpfw4gG5UeWMSTU1LyqCcK9tf8kwtkUB+a4s+sd7EnxQNoBZxSa3x54I9cw88b5Sv/WsPcWpit/FbFuI9OstE3858+J94SszHnQR2quufcRwgYIoUkLMRm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:36, Yeoreum Yun wrote:
> On Tue, Nov 10, 2026 at 03:53:30PM +0000, Mark Brown wrote:
>> On Mon, Nov 09, 2026 at 03:58:32PM +0000, Kevin Brodsky wrote:
>>> From: Yeoreum Yun <yeoreum.yun@arm.com>
>>>
>>> The POR_EL1 register is reset to an unknown value after cpu_suspend().
>>> Since POR_EL1 always holds POR_EL1_INIT when entering cpu_suspend(),
>>> initialize POR_EL1 with POR_EL1_INIT before cpu_do_resume().
>>>> +#ifdef CONFIG_ARM64_POE
>>> +alternative_if_not ARM64_HAS_S1POE
>>> +	b	.Lskip_por_set
>>> +alternative_else_nop_endif
>>> +	mov_q	x2, POR_EL1_INIT
>>> +	msr_s	SYS_POR_EL1, x2
>>> +	/* isb can be skipped since cpu_do_resume() will do it. */
>>> +.Lskip_por_set:
>>> +#endif /* CONFIG_ARM64_POE */
>> cpu_do_resume() will update TCR2_EL1 to enable POE again, a sufficiently
>> unhelpful implementation could potentially decide to do that before this
>> POR_EL1 value takes effect AFAICT given that there's no barriers.
> Thanks. seems required to isb() after initialising SYS_POR_EL1.

Agreed (as Sashiko reported as well). Presumably that means we also need
an ISB after writing to POR_EL1 in cpu_enable_poe(), as that's basically
the same situation.

- Kevin

