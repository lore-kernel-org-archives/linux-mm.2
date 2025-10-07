Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0C85CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 22:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B058E000E; Tue,  7 Oct 2025 18:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3141C8E0005; Tue,  7 Oct 2025 18:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5348E000E; Tue,  7 Oct 2025 18:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 031F18E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 18:53:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AA6F0140305
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:53:00 +0000 (UTC)
X-FDA: 83972820120.17.E42F762
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFD48140002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 22:52:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXCJDcLG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759877579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+zGrEhn9yIbxrx8akVC6Rjuew94sMfqEV9qMdvVonCg=;
	b=vYfqqoOD9/Ar+rZGzX4dM0NMwzzGu7swr999mPUr/N/njvL0s5Gem2JWNuNVrANSt5EwBl
	06T4UDuEEPIk6rHRMJa+53Z4oYjRwRKy8J/qa/JA35N/4xP//dXFiRbFlIOgI7tqSafugx
	T6anJCPGTqJClni79T3QsyYi5/h/Lqw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759877579; a=rsa-sha256;
	cv=none;
	b=axkGazWazmjetJvcg1vHv1mkl9uGXXZRMvQ6wgUoz6sf7eSoR4f/vBFOOgB3FnNHCsyP/Y
	KAwQMBUcnd94f841BF9DWoKXkWINMfBIQH5ccmZifEsHDKUQc+4Oy7vmKIpcLyv6fMEVJZ
	YkMxJkbhsXeE7PY1P67jnDSuMa+9xVA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lXCJDcLG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759877576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+zGrEhn9yIbxrx8akVC6Rjuew94sMfqEV9qMdvVonCg=;
	b=lXCJDcLGRCwwkU7jnZ6bJv2a3MjwgazcrxC0yJDKX0uEgsGEiDtW8vVSPksXSB0lOUih7r
	wYcsqQKVxqBhyasR8cNmnFe5KxrJnjYHEonk2ybtQeg1pM1/fxvhkoV16ih1XjUDmeKkRV
	xPToa6kJLGuv9CFDOcW6yEQpU37guAg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>,  Dev Jain
 <dev.jain@arm.com>,  linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: readahead: make thp readahead conditional to
 mmap_miss logic
In-Reply-To: <20251007153424.1b46a4018e17d5dafd7fb126@linux-foundation.org>
	(Andrew Morton's message of "Tue, 7 Oct 2025 15:34:24 -0700")
References: <20251006175106.377411-1-roman.gushchin@linux.dev>
	<20251007153424.1b46a4018e17d5dafd7fb126@linux-foundation.org>
Date: Tue, 07 Oct 2025 15:52:49 -0700
Message-ID: <87play1fzy.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 416rgpdum3azuyntu36shp9mfzumiqi8
X-Rspam-User: 
X-Rspamd-Queue-Id: CFD48140002
X-HE-Tag: 1759877578-213528
X-HE-Meta: U2FsdGVkX18VCDq4t5j8VPnQmiq/fJNuRUXwzI1OlhcN5L8EZixrPfLQ2G67mkeipI3KQr1hVrdOw9IIWTfve5vZgw61RE2qp0TCgbEycmob2IIF0IFKiZPtw8Z2qZmsecmxk39BQUVrE5b1hBGXvl4mPmuEhJQstpNgGAhuarZpBQ5PtwTL+5kBuv2Gjgok13poBLZ63wCz3r1rgHamHTJOaEuokGw95RpH4ujq2zVGjD4VxjL1eV4X57JtgY2TF4ixTZD9Dtzd/dU+fhKfG5WDgiXzUYZXYoRj2lzh2F0Krmy1qDaTZyDiyGD4r3JtQt2lPW0QQbhmwECPIw1mrXrTXDEFv5nZBYuP6Ae3Zz6SntUiGr5Z+SJx5HkFFCOTOHIshBYD6ZC1YFCyJdN1VyXqcrAJpMTqMLqgRo1SuvLNhOVLPg3TdFVI092FiHo7LQME1ZkJz+mi6PGEIgst2PhUkuf0Ff2jrQYM+cbMbFVbczez0pGugcTff6k6847govePpR3mV5La7DFBpLo7sSJnx5iXn0GcjjQWMr6j0aByJDcvlAd3hUkvnuSZcYhWlXDPoSaoY98onCITrYzOPMalz2M1cpay8zVEDnq9MnzjtYsG/Lv78yhnsFVFejnDckbj1SLD3AnUgDf44iuKjdPIGVHxYpDbNwXohpX+UsygBxL0sJxGoihPi21pdN/QTDMQ2khrEsz6fsUVnTV6NRvH5d8g736/u9yCC8kFzpnshzdqgTFYaPrNRe1IE3SAz2IgR7NyE2LeHx4iwNDF7ZHSZFwn4vp96Co27VDtdUmxmRFz6eOORXU3E6xe6/uxV6bp9idEzElDtqeFq5/ukkxlCSppSyqBqi2oF5cixpwoHbSHdW+QT1xlp5EECdfgwYMa/6aWhJDGhzJ8QUM6oUdWPHoEDhoqlvMIqcSwMp++7s8NsKFj6vC7KNe66Xvbn8OfEAamdmhScRHq0PX
 0Yf5Z6nW
 oT9D95ZVofo3DMIpHZ3weBsydMVWtMkuNSMRb+yH4YmNTo2xdkZO80ydsZCULKZpcbIiD6ZT8RP8Weq95lzhZ9NJaCa5ect7vfk7selS67K9Smq0B1hu+c8mOQ97sXBSWl4VTIxqGvAxOIZlamkxqZ49rkNMs3Ss6xPY6Xzmwik0L8zKkwxlhA2HlY9hKfuO0gE0IbVqyOsuOZWobC4RLqbT5/tiXcMuX/PdPJ8KupmCUWP8aNY9XMSVZYA1rFT70bKrziKaEv5GvtdHYb/k7YAQ1PFFlL6YYe1Qaf/oxJsL6yAbQ/+NWmXUwMwj9wXRo1IWg3alw6P1kOJDofS75M9q4xnjIxGr8cPCCTCssR0rlZCdUBkLYWxtn9hV9nxf/hI4J
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Mon,  6 Oct 2025 10:51:06 -0700 Roman Gushchin <roman.gushchin@linux.dev> wrote:
>
>> Commit 4687fdbb805a ("mm/filemap: Support VM_HUGEPAGE for file mappings")
>> introduced a special handling for VM_HUGEPAGE mappings: even if the
>> readahead is disabled, 1 or 2 HPAGE_PMD_ORDER pages are
>> allocated.
>
> Three years ago.
>
>> This change causes a significant regression
>
> So no backport suggested?  I guess reasonable given how long 4687fdbb805a has
> been in tree.

Yes, this was my thinking. Also you need a very specific setup to reveal
this regression.

>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: Dev Jain <dev.jain@arm.com>
>
> But I'll slap the Fixes: in there, it might help someone.

I'd do exactly what you suggested: Fixes + no stable backport.

But I guess it still might end up in the LTS tree thanks to
the automation picking up all fixes. Should be ok too.

Thanks!

