Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46C42E9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:23:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 818AD6B0095; Tue, 24 Feb 2026 06:23:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6526B0096; Tue, 24 Feb 2026 06:23:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FCB96B00A3; Tue, 24 Feb 2026 06:23:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5866A6B0095
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:23:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 20F1558F1F
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:23:01 +0000 (UTC)
X-FDA: 84479113362.28.C730FCF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 459321C0006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:22:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932179; a=rsa-sha256;
	cv=none;
	b=ZZlHcrqAeD4E/KU04gsl4oI/wLiDhha37wbv+Wvq5omYrjDqTSwE5+DqHH1EXbMlTaeKJy
	kXsuvSZ52zAOnh2F6yDrxVu6KpaFoFL9SqfEBXfx0sgvtEVN3Y7HKyJRuxYg9chf9N/rLH
	nim/o665YuDg7HxYHZ6G7N984KoMKT0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uWLnwguFh/2yx9Hsj0UD2t4BCds3VUsYZdpbJu1VQSk=;
	b=jWwmOdS1YOfQziPraPcWbosxnbbc1M30A3LbEZnOsZoXHwB6yefaFMLahp+Z8M/Ribb/la
	3NnbPyuSq3iRxzUQ47nvcFqTgegj5Jks1AuGzgvEou35AjQjrhW+z8++DaAsayxWQqbQFC
	uReAN9j6NwXSuRjYjVxBH+uL8PLegdw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D00B1339;
	Tue, 24 Feb 2026 03:22:51 -0800 (PST)
Received: from [10.1.31.217] (XHFQ2J9959.cambridge.arm.com [10.1.31.217])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C6ECA3F59E;
	Tue, 24 Feb 2026 03:22:55 -0800 (PST)
Message-ID: <6812706f-1ea3-416d-8ba1-da522238e040@arm.com>
Date: Tue, 24 Feb 2026 11:22:54 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 04/16] perf/events: Replace READ_ONCE() with standard
 pgtable accessors
Content-Language: en-GB
To: Peter Zijlstra <peterz@infradead.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-5-anshuman.khandual@arm.com>
 <aZ14lUwuA86aiOH-@J2N7QTR9R3>
 <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260224104134.GW1395266@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 459321C0006
X-Stat-Signature: f6i1bnqzf8d44iup77rpsguqp6f8pmjd
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771932179-859371
X-HE-Meta: U2FsdGVkX185k1CDnWRJClCpq31Ej9N3GvwU3OvlwCuP4qQxZUv0Ji2u+00ea7+XQclfboxuLsrMJroNdMdrtwhs90t35FvAcFsCBsGyUFG7pMs37Ti8TsuDT7atydyAHsYRE+fQ8zT4Wzh7ccYgXuGU281+sSm6GWFkuCMEJ1UusxQ3DIPw0SbZ/sC0bJg4f2/u8lP7q4uiIypcgUbufipDukJjyBKtgWlgMSMGkVUJ58k5CMBqzK5Phnku0A8D7B0QrLJWvz8r24Og7OpDCUWRgNb8ihMPwZ45OPPbmQVnBE97xkv7Jtch01rrKz6oI3axi5yKARnJ6oQ78At8kd0lNmxbR+Ff7D22ohagL7/ZBx8XCFa6DVE4sWpsUHjhOlmBYclr9vpAjAlVqenD6ChxH+F0iLUZgfw/KSIuIImsiZ6F4HUZ/o0OpMnPNY//eoWynIFmdi2q6NGIa6uk2NSrkgVi4HI1tSMdRBx4gJa5qqO06Bf6qMSlZmDnWzEOwLZ8ul5hsTBqpHycBmVa0FuWY4w3Sd10x5xX5Dy77tRl/Mz2xuuMx9EpJ1saI2prc5aaIIIQb00DMUWWpvtrkOLILQbt0aT6H0egqXk2Q6yXXUzT5PPgKPK5FmFYyx1MY6oAp7jVBLti567l6XGbLS0nMm6/sdWZ2Ft5DrXJDDiexuCrDKNPaCa6pc5WPKAOpB9qjX+evtoCBqf0KbvFygooM698/+g8i+S3vZ4RUcqS2OX9x6bCtrhoVOTxu3R4OiOzauyMMwUUCnLFWvUcGTiPoHffZarxFUy9C0f+z77q3a+/czz8cDEu1KAGk1WjHMrSP8GJUTLbUZx9te9j/e2puhGizojDtdhYe1v2znNqTjzzX+53l0aUi41OA7J+r3RknxBg6qNCdNVA9dvDZwytxcYfH8xaO5hDMuJSgaWiDMcnsNa170CnmPaMxWc8v6J2e6I1rBIQsSZGXqM
 BlXvz/bs
 b3NHbW4J5td18LmsaWCkt9PbEiRNHSK85NXE8Y/iMhwVfBzE5xkgPZ6uW34TfkW+mXshpxOIgX89eCibpbxuIzlU7OSka0qJA1JfUg35HLxgFKoWI1orkYCoIgbUIqd0WTXsLa6acIFDLsKsU4IfxIwqzFDfDrFCoQkdBlJ6l/Uny+JTlkbmgmY7oEWefzFziLFxQ8lZzfyijFiuo0kXygVLwfHSTA6nK/Ntegjrm+P5LNll/Jo+ZNvF5DZyjoxuR+/8EpZgc+b39NMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/02/2026 10:41, Peter Zijlstra wrote:
> On Tue, Feb 24, 2026 at 10:08:21AM +0000, Mark Rutland wrote:
>> On Tue, Feb 24, 2026 at 10:41:41AM +0530, Anshuman Khandual wrote:
>>> Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
>>> anyways default into READ_ONCE() in cases where platform do not override.
>>
>> For each of the patches where you make this sort of change, please
>> explain in the commit message *why* it is necessary to do this.
>>
>> IIUC the entire point of this is that in subsequent patches, arm64 will
>> need to use something other than READ_ONCE() for all pXX levels in order
>> to support D128 translation tables.
>>
>> Spelling that out in the commit message makes it much easier for
>> reviewers to see what's going on, and to focus any discussion/questions,
>> e.g. *why* won't READ_ONCE() work?
> 
> That, and only being sent *one* patch, I have no clue what the rest of
> them are doing. Didn't even get 0/n.
> 
> I hate people sending me just one patch; just send the whole series
> already.

Perhaps Anshuman can forward you the rest of the series, but FWIW, the cover
letter is here:
https://lore.kernel.org/all/20260224051153.3150613-1-anshuman.khandual@arm.com/

High level summary is that we are adding support for 128 bit page tables on
arm64. Existing places that use READ_ONCE() to read PTEs now require 128-bit
single copy atomicity guarrantees, which READ_ONCE() doesn't allow (on arm64 at
least) - it fails to compile if used on anything over 64 bit.

load pair/store pair (ldp/stp) are only single copy atomic if FEAT_LSE128 is
supported (which is required if FEAT_D128 - 128 bit pgtables - is suported).
Currently 128 bit pgtables is a compile time decision so we could have chosen to
extend READ_ONCE()/WRITE_ONCE() to allow 128 bit for this configuration. But
it's a general purpose API and we were concerned that other users might
eventually creep in that expect 128 and then fail to compile in the other configs.

But worse, we are considering eventually making D128 a boot time option, at
which point we'd have to make READ_ONCE() always allow 128 bit at compile time
but then it might silently tear at runtime.

So our preference is to standardize on these existing helpers, which we can
override in arm64 to give the 128 bit SCA guarrantee when we need it.

Thanks,
Ryan


