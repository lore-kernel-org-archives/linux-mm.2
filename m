Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7F78C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 07:58:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBA886B0092; Tue,  8 Sep 2026 03:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92DD6B0098; Tue,  8 Sep 2026 03:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0796B0099; Tue,  8 Sep 2026 03:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 92A456B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 03:58:04 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BDDD1A044A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:58:04 +0000 (UTC)
X-FDA: 85189841688.09.05BBDC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 40E4D120004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:58:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wot4HfEz;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788854282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=muMECbO96Q17a8vw7+GcxCDFTKIrG/mBOtBi3cQA3vw=;
	b=27eQHVNj8ITTG94/NbRUWDBO6AYDRmwdj8aZN8Tg/VWxh2BuJ0OG8NZgBj+O6nwddgZcvq
	TAwuRFd/wuMkPbTLGk8MlNkRmd65d4rVWStuPpusx34obgAS2JZUxokBwRuYbU2KGpTsia
	f5cY6H5bCC8dw3Wh2/7kkETzeD1ej8U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788854282;
	b=B1ju2pANCSkmwNsLlXLgLtDpx7khC/xb32bJP6zY1C2VAoBgXc4NK4XCexUqEnPFvGQ1iH
	3ghg/O5nAyPruGBdbQefzxUnJuz5L2iRXKT3lsReFH2HETP+qzHElONYSxPwBZJp/5lHFL
	LARqMoJykd57C4IVAxDt0Q0BpNS2+Zc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Wot4HfEz;
	spf=pass (imf29.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B40361476;
	Tue,  8 Sep 2026 00:57:57 -0700 (PDT)
Received: from [10.57.7.202] (unknown [10.57.7.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D52773F7B4;
	Tue,  8 Sep 2026 00:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788854281; bh=muMECbO96Q17a8vw7+GcxCDFTKIrG/mBOtBi3cQA3vw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Wot4HfEz7L7Q1yhwW45ocjyTfVDEuEXikMJ5kqcAakvtvEBJPgf7VrrSQ+VR90R66
	 nQTplq4uplypYc4ur9gFPAllc8RxJ18oJh2EbVsjZ0sqmY7En9vasX7BBaIfw72daz
	 tcrAlaVBIZk7x9aCnwAAI39FOlKwEMbyjHI3frww=
Message-ID: <df68a260-c9d0-4f5a-918f-00dd2fb8d6fb@arm.com>
Date: Tue, 8 Sep 2026 09:57:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v9 01/25] mm: Introduce kpkeys
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Ira Weiny <iweiny@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Thomas Gleixner <tglx@kernel.org>
References: <20260818-kpkeys-v9-0-743ad31b2c8f@arm.com>
 <20260818-kpkeys-v9-1-743ad31b2c8f@arm.com>
 <178877845406.3691569.6930315020588094755.b4-review@b4>
 <3f6e7678-0784-4ac1-acb4-b128887803c5@arm.com> <ap-wnHAwfdX_b39o@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <ap-wnHAwfdX_b39o@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: jprnpw9q1xca4suh694hncrj6si3nsyy
X-Rspamd-Queue-Id: 40E4D120004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788854282-522420
X-HE-Meta: U2FsdGVkX19F5mCTxxgineiBTthI5bBjaL/uU2ckp3Sr1QbngqwzujOaIO8Uqn4/ibziRbpjnSSgEspwA29sqEMJg9UVVIc1S/86Y6AGnXPd3bXtRsYluKMALlZBWXeP+in3XAo4R88/aNa/tlK04UmdreoBQxcGG/DZpHHwfjZroBWcpnUseIraZjvwiyyyz7uXbU00MK4VaURh/sDUtae0tT7AEuJWJkASQ9t8Ne9zV3HBY7mCEA25Wh+6jMrFkSzZKzyywFyi9pkz4yzNAwbXRcjq4tAsDdAb5muvRBYn6Od/Z8nrte+XpgtzDCVGE8Rcti7Xmcm2WIT/6QPu+Nq1BoTGKLCdIzOKgS4vBp8ES3Cg2I4gnVTPChTVxvO1SsensE/lFU0fO2C8nc7pe5IeRPtH98dDcaCNxtkypeJ/TZWlVeSvcItTn/tXvadxF8psDFdbbUS815w5THVeYf0/OehZJhOGD1juWK8pobrRseDVmfSXNdrRKwEPSEY4vmALZFzRY6SI6F4dN5w5aYeQqLa58dLRkrnqdjYDUCERkz7mcS154Gybzteoyl1tZIx83YzRGEefxnqJTEUrfZ2cd3Ep+VCGRyxK3u2eY58hgNkWTx4FNkF0wvkY9whETxVvCi9SJyWJP1UH9WZ53KYLJGWKttX0ciMpXxSMYXigECr8pevt3sb1p0Tkg6jPvPdkiDn814lslBFp4OBo0cZT1kKjmq6GPp2p3NBowOiWfIFqQihMDuc14uhN/VvFrZg/hh1+ifcYyacX5qizBG2kh7KafKq5ogb+EslyHFpd381SNYHygOxQUgAeN3OGHbjVcWxGbAdTeFHf9X/L1iAagXwLTLd07KE+S1GQ8gbki8rL2ok7p+UYTcnptAvPFS9db0zww5d0gR/5nxklHHMSn9Q//ziYj6H0m63HmASFUabdP+VbtsNHxTLvrkL47ziYkKdQb5cEnwV7Yx1
 D+tVIAxh
 3vlCVys8Q30rhZAHv9iv9c9/QpP8CaARz3OgfqIrPTq+zHQJwppgnvRWZTPJsSV/LLlTsJBYP6P2ohA4b2s7RCJegD9j5xznlIuSUkgNkk8yolPJVIlYccj7pGx0FhIuKjlQbpx0PkpR2AyE8BfFnD4TVkMMVGlGsjZg133WJypW9EByGyHkZrRJwtvaJ1Ql31gJTlJiwQmJi98Iu+UhzgBD5XWFuEm+LNMkq32tWdHCuCCI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/09/2026 08:52, Mike Rapoport wrote:
> On Mon, Sep 07, 2026 at 05:49:42PM +0200, Kevin Brodsky wrote:
>> On 07/09/2026 12:54, Mike Rapoport wrote:
>>>> +
>>>> +#include <linux/bug.h>
>>>> +#include <linux/cleanup.h>
>>>> +#include <linux/kpkeys_types.h>
>>>> +
>>>> +/**
>>>> + * KPKEYS_GUARD_NOOP() - define a guard type that does nothing
>>> Nit: I'd suggest to drop "define" from all the descriptions, they would
>>> read better without it IMHO.
>> Fair enough, but if we say just "a guard type that does nothing" is it
>> clear that this is a macro defining a type, and not a type itself?
> Then maybe "helper to define", like cleanup.h does?

Sounds good, will do!

- Kevin

