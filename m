Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E186DE9273A
	for <linux-mm@archiver.kernel.org>; Mon, 29 Dec 2025 15:40:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F1D6B0088; Mon, 29 Dec 2025 10:40:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BC946B0089; Mon, 29 Dec 2025 10:40:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C8DE6B008A; Mon, 29 Dec 2025 10:40:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC0F6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 10:40:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9CDB252501
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:40:34 +0000 (UTC)
X-FDA: 84272920788.28.012F134
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 818591C0016
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 15:40:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767022833; a=rsa-sha256;
	cv=none;
	b=rjnBgMls0pBrQfj/QXUzyXY7MmOa1q3Ln8qe6QZS3G5f4+WJpNjV3iAs/SKjO5LzfTkG/N
	Ui5mUKHnerv1n6vx/k27TsOxe3l+P6afNte3sfsTcNnS7VsUfdxg466OZcIiV1xDsdkhW1
	GA66r1Brih/M6gVUdPjCmw4v5jCKwhQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767022833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qP90zDFo9BKMdlo9pIMMMfB8HDUBQY7Slkz0vaQwzqY=;
	b=wB9UIANflyk8HdVryXVjnJf7o7fMwXgQNPTh61Lzk+TZA2FmXzwAvN9nvckFdn0EU/s8j3
	nNkW1pn7V2BXk2dB2cPvhxH37iLBjCsodd5pRb/3eBsA3G6dtZL4eMdsaCGy0Rnw8WqbV/
	AigKp/CbF88wBTNducOrslrur0plgBE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A886339;
	Mon, 29 Dec 2025 07:40:24 -0800 (PST)
Received: from [10.57.45.222] (unknown [10.57.45.222])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3DBE13F5A1;
	Mon, 29 Dec 2025 07:40:29 -0800 (PST)
Message-ID: <9c97ac9c-b0df-42e7-84fc-7e0d986c7324@arm.com>
Date: Mon, 29 Dec 2025 16:40:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
To: Mark Brown <broonie@kernel.org>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Yunsheng Lin <linyunsheng@huawei.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
 <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
 <682f64d0-353c-47bb-808b-eacc2d4d6c00@sirena.org.uk>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <682f64d0-353c-47bb-808b-eacc2d4d6c00@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 818591C0016
X-Stat-Signature: 1sfpyx8r5g4kkwj6359feu4y3hwertxs
X-HE-Tag: 1767022832-519880
X-HE-Meta: U2FsdGVkX194suf59pJE0sabfCCZ8WZN1UG9KTQOp1vWU8EjpOmr/E36nqz7S+jjW3gdT9Um7kkN8o8A1FzoezBTc0TLIAkgYs5tRNjsE14PGB66G9fXMilLZaAiE0agzzEEvfOBvcXytdeRzdeiBIG5pMm4t72uDWF5kJa4jUl3SboggrAHJjb7f2xPBK8yQ0ipGILGcIcGOXscnOehClFDcxRze2uB5XvKybUTBBTELf9pr9CywOrLcEQQaDhBkFRKvVDqLHlr3cIL55aTFaGTajy7zsNuseEYeXYsdizM/URh4FFWrCcC/Go69JTWxAFC3sd2lTNbyELWgDR+eMFxabrPHSVxrk72ajkmvPhAagb9xCeocOwf/Yfpp0+OU4GDy5SoOTGJVWa+XLvNnStskUMUEydZ7VeZWQJhjG/MJo8hHEq1HTDmBJ89zwTFrE7KMteRMci7oGSNRoO40tK/OFHNT/NVgDwKIxmp/sn3x84pFcvjA/G07olXi9do7x/9ekStFcoa5ysEQACFfOnc4bqCm3owA65Q7N16XEiRzt1urU8rWsv22388SkNu7xlz09IrmJRIwo8Q5vHWmTUMW+CKDcE6h1VDZ+MOMtq0KlQUFG+B3x6bYZTs+fgk7mg4zZPl3B1I4hoSIcGbFVNDx/VNAOx2Pn+DHQL+/8jIkX5V/rBqY6Py3BTJPyGTy5gsZx5RJHFXMVIVpoip3pAUaYJ6m3pkL6p8FdIcaHm8uRN3qU9StLGnTCYNgbbMtEpsqiWLCKceRmwXFE+RD9tyQRPabyFmsIEUKNognIswiY1/kBM//l48LK4yefK6bxUivktSWlYTMCAaANqg1+ntqJC+AA7BJ98QfrYW8/6p6c8AZqyypsEuWnXrX+bmu8zpgNFU3hW6bLy2JdKgtaPBAvYtA7GLf5i6gJOvH9Sr3nYSjMz/ZIqYvZyknvGnXF4oKX3w1QIzgPadjFw
 bY74kdgw
 QDyP8X7EQFl7YnpOS28VYw27v3TZT2TE+oe6cxidowcyea4qkUaabmqeHH8zUb4Ou+TOOA7IrZeYwuOwSwRnftmcwKgrYmDht4vK57WKLAMiRRdeKDKfoh+O391j/Djs5qowWPq9ix4n5GTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/12/2025 15:25, Mark Brown wrote:
> On Thu, Dec 18, 2025 at 02:24:10PM +0100, Kevin Brodsky wrote:
>> On 17/12/2025 11:04, Mark Brown wrote:
>>> More generally building selftests with random older kernel versions
>>> isn't really something that's expected to be robust:
>> I suppose that Documentation/dev-tools/kselftest.rst talks about
>> *running* against older kernels, not *building* against them. That said,
> Yeah, running is fairly normal but huge swathes of the selftests won't
> build without current kernel headers and it's not an especially useful
> use of time to support that.
>
>> we are dealing with an out-of-tree kernel module here, so the two are
>> essentially the same... Yunsheng suggested an updated check that I think
>> is reasonable, maybe it is a reasonable compromise?
> Well, there's also the selection of KDIR which for some reason defaults
> to the installed kernel so we get:

Overall the kselftests tend to assume that we're building on the same
machine we'll run them, so at least that feels consistent. The same
default is used for most other out-of-tree kselftests modules
(livepatch, net/bench).

>   $ make -C tools/testing/selftests LLVM=1 ARCH=arm64 TARGETS=mm
>
>   Warning: missing page_frag_cache.h, please use a newer kernel. page_frag test will be skipped.

But yes if cross-compiling the default makes no sense and KDIR has to be
set explicitly.

> Your changelog says it'll work for an in tree build but I can't figure
> out how to do that (using the top level Makefile to recurse doesn't seem
> to DTRT either).  Having looked at this more I think the problem here is
> that the selection of KDIR is wrong, not the check.

I use KBUILD_OUTPUT=out and KDIR needs to be absolute, so:
KDIR=$PWD/out. I suppose for an in-tree build KDIR=$PWD would do the
right thing. But yes it's all very wonky.

Maybe the documentation should be updated to recommend setting KDIR
explicitly? Or maybe it could default to KDIR=$PWD or $(abspath
$(KBUILD_OUTPUT)) when cross-compiling?

- Kevin

