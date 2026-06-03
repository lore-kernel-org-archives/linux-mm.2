Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68DE5CD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:11:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0BC46B008A; Wed,  3 Jun 2026 06:11:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C95206B008C; Wed,  3 Jun 2026 06:11:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B842B6B0092; Wed,  3 Jun 2026 06:11:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8EBF6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:11:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5A3D21C1304
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:11:19 +0000 (UTC)
X-FDA: 84838183878.05.72F5202
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id 99BBB80003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:11:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fIZnn70M;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780481477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6CrNVQ8IBF7mJpxU4e+u8veQd433I9uH8sSfHrF0nKU=;
	b=0ba33iM1oZ63jrcn1O2jYUInC4Ooy5hBHFX6UgqZZ8ntMRTbTt03z5RkroLavBIHv2bKY+
	75bXro1xtApKA7+IxLvF4ZX7cW5rPGax9O53ODVMz2M793v3GWum7ImrTctEuxxcNyI6lZ
	v6uOGufqKm3c4XORnXwpNUWNMcKmAUU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fIZnn70M;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780481477;
	b=QhallofHIiNY7ypZIRk1lJnkibEDj8fFk8jpUVcbCkV2y21prjQRaas6Ip+HAGINvk01kG
	McN4TMATStYKsxEEY2YHfKs2ZW1cNKsTjGJK1orXJj/8UE3BkiyNVrYYr41GASEBLIYPs/
	iDkk85+wF7ulsYkc3O7KdxVWYDdqkqI=
Message-ID: <68ca2764-ca7c-482e-8e78-8c112ce01f99@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780481475;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6CrNVQ8IBF7mJpxU4e+u8veQd433I9uH8sSfHrF0nKU=;
	b=fIZnn70MFJFtSsMFPkgs+Fv+g0kizUEPLIjo6aWTQWcbFMleyzoP3NGdSMWey53IBZJ6BL
	933IzFB1daK0zrKn/VrPYJibB0+74lHr9frtFkWnTfZbJqaEqpC41aiBvU0RwwgMbIEoS8
	8agagZWYtGlgr4/yw+KkGXIRbqGZmkY=
Date: Wed, 3 Jun 2026 11:10:45 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v6 2/2] mm: use mapping_max_folio_order() for
 force_thp_readahead order
To: Pedro Falcato <pfalcato@suse.de>, Jan Kara <jack@suse.cz>
Cc: willy@infradead.org, Andrew Morton <akpm@linux-foundation.org>,
 david@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org, r@hev.cc,
 Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
 catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
 kevin.brodsky@arm.com, lance.yang@linux.dev,
 "Liam R. Howlett" <liam@infradead.org>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
 npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@pedro-suse.lan,
 ziy@nvidia.com, hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
 kernel-team@meta.com
References: <20260528165635.2068012-1-usama.arif@linux.dev>
 <20260528165635.2068012-3-usama.arif@linux.dev>
 <ahlh2vdHEGo6ZSot@pedro-suse.lan>
 <cc9a1cf7-7b96-439a-b0be-ecdcf27b5da5@linux.dev>
 <ahmSolHvUChl-3vM@pedro-suse.lan>
 <185f1caf-b33d-4467-beb5-51bd8520ac78@linux.dev>
 <u52xvwk2fjjk2izdb4wvuqq2zhc5neb4q6usimcxejluuyngxw@d64sc6rvojyp>
 <ah8Qcxuugn5tTilK@pedro-suse>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ah8Qcxuugn5tTilK@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 99BBB80003
X-Stat-Signature: hpdt7e3frngxks9rfiox4i4cmf6diycs
X-Rspam-User: 
X-HE-Tag: 1780481477-888145
X-HE-Meta: U2FsdGVkX18fCcXNjfsunK4Euvu1WzdQW2SkJh+iMXNKtLMfuUKmqqQUlVGSI7XN9/gYpYzhQY3UZlo78SdWPCh356mWfweo4pAESx7I1SxwWLI3gBCx07uYvl9tJE91UOBs49ekFfAWMnGA0xU2DiHyOWpJ81+LfEA8nV4dRpeL1z6b9eQ1Nm1wkqfJ6UDxbxpilQJZQls+TlUo9DR9zQZIarY8h4jkonLchTFaF4BrEdQhPNVgZBCVZWDKRaaJJlagt6IlggagWS5gGlffjBAz/GOChGTjrb4HnRxAdX8FeMM86dWWHSfWkzlis+KZnuT6w5vZWknBoVKuO63+AoAuyxMkQTirXB6m7TtNl7sOyLIi3kiWsUJ6UR2jnaMm7A84hx5XUpPfJqrn6B6cT80u2/6Q7zW4snudrQa335IGjWU//dK2lCMJJc9UuLkiu7SWw6uoN6x1JMluroJuJ8s9dLilGkW+EZCX88ipzjJC+XzbmbyRfmXC/PATs0ByN4cxUtPAt/vBYtI1Ah3JtoHxEEv9HnE3/K/KlIsb3hiiSiUGsypTur7SeQWmHTEnNy7G9HHPASQSLvJFySd+k5kyC9KLoVG4ZWCP3GIPmXPDnT9hlBlEZzeplGOkuKj6ddBdi1GEg7d/fEsgz1IQS9/hzvwZHAO/l5Yp6IGWPms3BCxIhDel4Ue3e2eLCmksgTF9M1h+daxhfi2xGjdPV9ilq3oLTyM+nEjKO3GpDkSRDlaD/Bk3Xfo9XlXywosxsKhCQWniD0dSpFIcPmgv5GCgxtMxFf/ngZ3WPtXRF3IPCEwL91bb1F50/GXrhtMXnrMCh39dgXeissMf9oADXtfSf6qBZjIj1J0MWPtbPjct97VLPnDAW3NB9lwDY8iXWRtZyg4xRW0soyAKFdE3gxqeNN0+osy9ZATKtc8S4JSoNz8afXVj242DBTffTj4gmM6zFJ+mzpWJXv5g7Dc
 As/ld9e+
 EyxChcd2Fk/6cTEjicQRPFfldbNqnRYtDwkdQ7oqi4xhN3bRF4yr8A7O87uV7Iy95FarUhoarNzbFDy0zGuywXCdsSxJuoSJMS5ulf/UFpQFGRvcnNHJ7FM028KigoRXXkZb82ekVfpNU503d6xUpV1T4BmAgrGzcfXbFRpfGfKmjn+4IlDCQB/b49iNmMJhRpIqqN/hB9oJX5Q825fDMfNDSWJjZb6Bj7F8vmbOBHcCQOgioOLV44ZyswIC3sSoCvZlnLEZVfKrNC3TJtzllTg56d1k0g6oJIIz5/nAHY49+6PB8GbGkWByyRgEaoT4b1LE1VGtNiVQR7Gc63sJMk6jETlX0TQrsFTB0WDFfDtaRS2CvkSiDnqb48Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/06/2026 18:35, Pedro Falcato wrote:
> On Sat, May 30, 2026 at 05:16:29PM +0200, Jan Kara wrote:
>> On Fri 29-05-26 15:11:54, Usama Arif wrote:
>>> On 29/05/2026 14:40, Pedro Falcato wrote:
>>>> On Fri, May 29, 2026 at 01:19:03PM +0100, Usama Arif wrote:
>>>>>
>>>>> which means mapping_max_folio_order(mapping) <= MAX_PAGECACHE_ORDER <= HPAGE_PMD_ORDER is always
>>>>> true, and you dont need the min3(..) in your diff.
>>>>>
>>>>> Now the question is if then why not just do:
>>>>>
>>>>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
>>>>> 		if (mapping_large_folio_support(mapping)) {
>>>>> 			force_thp_readahead = true;
>>>>> 			thp_order = min_t(unsigned int,
>>>>> 					  mapping_max_folio_order(mapping),
>>>>> 					  get_order(SZ_2M));
>>>>> 		}
>>>>> 	}
>>>>>
>>>>>
>>>>> This is because this will regress the 16K ARM case where we already got 32M
>>>>> folios. Someone might upgrade the kernel and start getting 2M folios now.
>>>>
>>>> So maybe limit to 32MB? It's still arbitrary but at least you get simpler
>>>> logic. If the architecture does not support 32MiB folios, it will clamp
>>>> the maximum folio order to HPAGE_PMD_ORDER, and you get the same result.
>>>>
>>>> Does this sound correct?
>>>>
>>>
>>> Yes, so if we replace it with SZ_32M, it sounds correct. I just think
>>> the 32M size is too large. But as you pointed out, even 2M can be too large...
>>
>> So AFAIU the practical discussion is about two options:
>>
>> 1) limiting at 2MB with a slighly more complicated logic to keep mapping at
>> PMD order for 16k pagesize on ARM but use 2MB pages for 64k pagesize on ARM
>>
>> or
>>
>> 2) limit at 32MB with simple logic which results in larger (32MB) folios
>> with 16k and 64k pagesize on ARM and thus larger memory overhead.
>>
>> I'd like to maybe offer option 3): limit at 2MB with simple logic. This
>> will reduce folio size on 16k pagesize ARM compared to 1) but do we really
>> care? I.e., is there big enough practical performance impact with conpte
>> and other tricks ARM is playing?
>>
> 
> arm64 16K contpte tops out at 256KB TLB entries. It's quite a lot smaller than
> a PMD entry. Also, something that was discussed at LSFMM was its effectiveness.
> Apparently, most of the gains seem to sit on actually having a larger page size
> (perhaps Dev/Ryan can comment; sadly the slides were not posted anywhere on
> the ML, so I don't have numbers).
> 
> To me, the question is quite clear: do we trust users that say "please give me
> hugepages" enough to unconditionally give them hugepages? I would assume the
> answer lies somewhere between "yes" and "no", but 32MB I would say is not
> particularly excessive. 512MB is... much worse.
> 

I think the other question also is, if the userspace asks for hugepages, is it asking
for the biggest possible one? I think the answer is yes on 4K base page size when
largest is 2M, but maybe not the case for 16K and 64K. 

/sys/kernel/mm/transparent_hugepage/hugepages-* is supposed to be used
for anon only, but maybe in the future we could use that to determine the size
of THP to give to the user for file over here? For e.g. over here we could have
used it to determine what the biggest size is that has madvise (or always) set
and used it over here. Its probably a much bigger discussion.



