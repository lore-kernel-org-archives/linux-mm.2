Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11693CA5FFC
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 14:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04A896B0088; Mon,  5 Oct 2026 10:59:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022436B008C; Mon,  5 Oct 2026 10:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C4D6B0095; Mon,  5 Oct 2026 10:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C864A6B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 10:59:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 550001402AF
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:59:24 +0000 (UTC)
X-FDA: 85288881048.11.C3B7BC2
Received: from mta0.migadu.com (out-26.mta0.migadu.com [91.218.175.26])
	by imf25.hostedemail.com (Postfix) with ESMTP id B96B9A000E
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 14:59:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruRk7KT4;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791212362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfEYpLLuHbCfQx1hpDtYvxD3m/YgtJD6akNnysgMhKs=;
	b=c+JwDwVtgGKD+IS2A/y6irF0qg0aRzg+BJ9qRiGQrzoKgF4p+ZF69WF9OZAdgXb1HeYm1p
	e0zj5cpF80yxNL12sIs6d0CZJDdTZzKffM86U7ntx7MM8PQ6JCvAss2ao6WVbd+UjyVifn
	5pqChy1hifCYMyqWgvurR3Ij9ZKk30Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791212362;
	b=VVcIm+dkOpGX08lqZ9ZKBIi6yRvmLdkJsXE76h9PP1G4RPRIyCIz6FUYwFs7pKqgB9dFj+
	3N8RRKH0qfNp5AesQ1rMSKXOm9UnmzYKrontg9lUaohT5UgtpYAWwecF/w5JgZxwj4a+oA
	0OVmIVrLDhLJ9Af+rIgcgTqxImYi8Yo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruRk7KT4;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.26 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sjluPKWYfXjAFZOlS3RybtthbiIfsFMylOb79mxumII=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791212359; v=1; x=1791817159;
 b=ruRk7KT4pIDmtw6fbZANRAvch3wLg1hbVa9q9xWmPdW2SzNeHXjMp2phkaUHb/9zqmXJT34B
 Joqw0yaKZQE4bflto+lQ5Zzi3rpJIxjYG95SXG8S3F02R7bUdI/HMDPnZMghEEPEHA6kRAcIkEc
 +NHIP4wngeI1T5GMvDHdwTTc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 93dd8002214013a1;
	Mon, 05 Oct 2026 14:59:08 +0000
X-Mizu-Trace-ID: 93dd8002214013a1
X-Migadu-Flow: FLOW_OUT
Message-ID: <0a0f7ae5-5fa0-430c-8074-9217f594a563@linux.dev>
Date: Mon, 5 Oct 2026 22:58:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] x86/mm: fix incomplete page-table invalidation with
 TCE
Content-Language: en-US
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>,
 Pedro Falcato <pfalcato@suse.de>, dave.hansen@linux.intel.com,
 luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com,
 x86@kernel.org, hpa@zytor.com, riel@surriel.com,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, nadav.amit@gmail.com,
 thomas.lendacky@amd.com, kernel-team@meta.com, linux-mm@kvack.org,
 akpm@linux-foundation.org, brendan.jackman@linux.dev, jannh@google.com,
 mhklinux@outlook.com, Manali.Shukla@amd.com, mingo@kernel.org,
 stable@vger.kernel.org, toshi.kani@hpe.com, david@kernel.org,
 mikhail.v.gavrilov@gmail.com
References: <20261005052302.43042-1-lance.yang@linux.dev>
 <asM7b8ECO34-jiwi@pedro-suse.tail5790ac.ts.net>
 <60d5db86-8002-4d87-b8d3-c161d674122b@linux.dev>
 <ab077b6a-160f-41a2-a167-813f0560e30d@citrix.com>
 <38541ec6-d796-4f35-a700-75ab097b6df5@linux.dev>
 <7ad90e94-d04d-453a-ba22-9640a5024d8c@citrix.com>
 <6801221a-6307-407a-85fc-46906f95d22e@linux.dev>
 <20261005142216.GAasOymJHYnmn6wD5m@fat_crate.local>
 <de41b083-6368-429e-9928-90aa5440f750@linux.dev>
 <20261005145315.GCasO523MWyIIx2ngl@fat_crate.local>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261005145315.GCasO523MWyIIx2ngl@fat_crate.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B96B9A000E
X-Rspam-User: 
X-Stat-Signature: zt8iib33ku5ajapn8wc41p6f8eu3hoix
X-HE-Tag: 1791212360-867174
X-HE-Meta: U2FsdGVkX18LLPOxBTlymcrU28yS+SF0VnYjpSM/APADPP34tIGXO3q73oE0ckWMESCvmgWgVGlL1GmJ7zDD7fHRJ74ZGPGeLyjIMZ78gW483OA3zPgUG3Zk+z40kBdXwzDdiBrvk4dquspOcgtBiBDEFhwGxYg2EkMEYBkUTtuB7OOaLQhNbJoDKfoZxv503qSEpqc02tUg1Kji4N+1d2hXpZ/JH5Loiga2VwiDPEOPdGcKnUizCPESDHp8jz1wdrskxhgkB50nutcn+V0pKxaqd4AJF/IpZYTARassjsVKip8jJUfg4ddw0WfbUqv+9LV37145B/wh4zzfiZyFA3lPVrFyBC8H326QsGmNzYQpr+E+ePDVIVvuO+S+fAUds/nkGs3/ryc0cEKXx5r71zKJQG7pkSrBP6Jo32tWfc7VpcyZNQPVxOsE/uk2b4Ry2CE4/coliyVUCDezpEFAmhnFpkbKB4fh/14KcI1ieDKSslzOPsJTaB09SMQo/BUsxrjVSyrbMck12ngzVBz9BMZL00vM0Idx2bkeOnARek59zTyd5XkiURmIfuf5fItaEfaQBVZJjy4dxF8mwVe2TRRbHlSaQaZcu5B7dl9honPB3X0j4H6XQni8TRM+cGU11xwsaoAZvTBg1oFexZulIUWCgFv/KA4AjGlRfiVmUjMH+Dn/b045EalOPerMr1rCnJqKeXZazZxeZsWZq0kxaOHD0qd1TtrN5POooPEVHDic6yAW5bEZghSI2SHEuvpwWtmaBTa+i0JMapnayW0Xyy8+iqWdola3ejRSWMZYBou9Sh0ENYobCZa50SDZ6dsPgqaH7yOWBjoWYaVZSJs0lwvbC60v0trW0wKBEkes5oqadXKiC663IzvDSBZumLPIbXCBWDWw/bNoVJCP0xUJywK/QiORzMCf+2fOvU0cC28RVEYWCdXky8ZvaQyVKlo/O6T7I13mQIZoxUUPM1g
 2Sv/RQqt
 2+cl0V4Qm3JU7M5mjvxvtmtNo5fa21Y/OH7NeBVwRsWqB2L0rSd9ia3hVB9c5QXBBHZV13Jnd0fzGvoAq6p0yRekOeN3ey0ZgsijIf5mXhKlToPGhLqgJYMrr3E5wCBLuJyfyC4B5hGw4znF5+HKn3cs1WLFDuBV0wY1x+rjulFe6u8oVDCr1fsVQlIGIF+8ByXjGldGeQD/ovHhdpbmeifj1UHzKDOHQyKVTvuD8BNFXYdKU8yjj0AY+7aE0AWkSES3T6swt7UhQu4dnOOfUtesE9+6TmGXgUY3D67MsjSV6ErlHNIo5OzuKc1lDyal7ZqdVQqnNDdkLZu5s+Vh2r41EHAl8T70+21cqX2gwjLhpuoj2x7DWXWB4HAL4rkArV9Yn8X7ppq3hEU46ul3p5IMa/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/5 22:53, Borislav Petkov wrote:
> On Mon, Oct 05, 2026 at 10:36:26PM +0800, Lance Yang wrote:
>> I don't have an AMD machine to test this on. I spotted something
>> that looked wrong in the code and sent it out to see what others
>> think.
> 
> You send a normal mail - not a patch.
>   
>> Maybe I'm reading the manual wrong, but is raising a concern
>> based on the code and the manual really just "a wild hunch"?
> 
> If it is formulated like a patch which is supposed to be even urgent, then
> you're reading our process wrong.
> 
> https://docs.kernel.org/process/development-process.html
> 
> And since you have not tested it to actually fix anything, then this patch is
> nothing but a wild hunch.
> 
> And to answer your question, no, it is not needed. Definitely not the TCE
> angle.
> 
> Now, the speculative thing is another story but that whole story you're
> referring to needs a lot more debugging.
> 
> But we do not apply patches on a wild hunch, without any definitive data that
> they fix an issue and, if very much possible, with a clear explanation why
> they fix it.

OK, let's drop the patch.

