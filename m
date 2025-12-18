Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A80EDD6ACF5
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 13:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A77C6B0088; Thu, 18 Dec 2025 08:24:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B9A6B0089; Thu, 18 Dec 2025 08:24:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 036B76B008A; Thu, 18 Dec 2025 08:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E3EAC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:24:18 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6801CC011A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:24:18 +0000 (UTC)
X-FDA: 84232660596.28.6042010
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B1F2F40004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 13:24:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766064256; a=rsa-sha256;
	cv=none;
	b=3ArsEyf1hWxAgO2DL3055Uz3OE/M7gm+6fQf0gipchKrI0BHW/llNELQ+Sy8bGoW6RJPTE
	HmVru9Dp9hupzs/eeCc8cpkZ0V+q2udY393MVVlhGkzHYRywgU2AQbCy5/LZiKr4udq88z
	JrC6O1HKz/Wl+wpdwL2od1MorbysFXs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766064256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DlCDfZgm5JsmTafpliNDNHYQsLVdY8Jj7Nu3gUmzK2M=;
	b=tBV/zuTKeYwGF29XDtG8A+Qdlr6I42g5ZBtAF3MkUrFNTC9EDuJUypWd4EHHkD6UhDc0Gd
	SOy09Ykj8FIfcjCAnZ8WtEGPIkVY+u9ozPmibz8lNErNSlyncvZI8Komm6Xg2Y5hF/IqQw
	KSJ/P3vrmpx7nUyu+oQMhH14Jb9kMsY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98AE0FEC;
	Thu, 18 Dec 2025 05:24:08 -0800 (PST)
Received: from [10.57.45.71] (unknown [10.57.45.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B5F13F73F;
	Thu, 18 Dec 2025 05:24:13 -0800 (PST)
Message-ID: <e971e44e-5539-4fc4-8128-0ce9c3d10a38@arm.com>
Date: Thu, 18 Dec 2025 14:24:10 +0100
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <5f866c1a-c8cd-4dc6-b312-9017cef89920@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B1F2F40004
X-Stat-Signature: ga3ac4rhd9rymhjxwb9d5xabhx3nfgrx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766064256-892185
X-HE-Meta: U2FsdGVkX19WepMruN0kIdanrCc6Y9yrfH2W2r/p2L086C2CZeeti0aaW38RY305JCTrmV/mFxPbNT0Kttbx6v97lgrXDGvdyMozz7uq8wDUsjsCICYdaRtto7st/+j9HdEsXJbQhbbTjjsRMCAc0Zsh68sNrqOPt6/i7YvILaVPzqKRgJi5uNbmUalAvFoDfvgOhpPf+/IVu/kLiPCDkgyy4HvxvrLc0sCGR4VLYdN7CD0FFBHUbsMlcRCreqa1fzB+mZB5m3Kq7eE9CBKUO3eCn7+wP1Rd6zK1mBUBr/UG+NLoCFXLV3LHIq6fzSNtOSadeBO0aDHwKGLjvRPci5fxl4F3EwnGUbs29Wm7QjZysKsyxOCdqMVAw9sWRB5Thw0qRPC2f0RcB2NHlnfyugJtfwBE5rm0k8x5xJoQD2OE8F9+tVrD3zVPuTHdOwg9o+PDZP6m33GDFUiUikNyIeTmDXqItPsjZx21b9A5Sm3WJ+8exL2rU67GdDNLzdPP6JFwq6rEDbQlKprTiOL99YpvUjGCqEKVqmo9IlIKawIJsi3U1oCdIs6ogysmIzGcu9Ige0OeRmPqTg0ZSYDjP316ay7iv8dwlPFmbc4YRzSoA1POfxLolbvvibs2RhIobneGi38LUN61356leA5EUGJEtIXYYlZ9FKyu0XYhYJZXjMjHT7UIZslwJeROYwD7TiqN608MlqFHcHToqEZPMjHUaOZS4JejKDcZw6yXfF6JhwzTOXvE/481/t+Yl1rnIJ47cZD7O9M+m0HcxxZrMrT9ZRbd0x5alaG4/kKcVZg7vgSZ6YYtfAGgcR2DT7zEu5RkhEjiTiBBjwZNvU21iINWanqMt+3TfWNbws8KPeODovEpqfpUlAptolvPJnMtwDmKHpUW5QV01KLMMqeVG259n7zSj0JCLmi+huWMzp7N6u8PL7nhQekNweMiRstydoftM9p+G3PqPsa/vkL
 gal5IiKH
 fIEoOKfxrvD/pCdY2vR4TXwp9/jwkku/8wVtJL4mpo1dkc6fDPgiRSvggxv2N7fwM+uogky3sdi24YjS569pnl5l+CVn0Bb0HmNRBeWAG4ztvmI+TAGbEvOqEyxZIT7NeUw5uV6F1EHhgoPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 11:04, Mark Brown wrote:
> On Tue, Dec 16, 2025 at 02:26:30PM +0000, Kevin Brodsky wrote:
>> Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
>> is not compiled") introduced a check to avoid attempting to build
>> the page_frag module if <linux/page_frag_cache.h> is missing.
>>
>> Unfortunately this check only works if KDIR points to
>> /lib/modules/... or an in-tree kernel build. It always fails if KDIR
>> points to an out-of-tree build (i.e. when the kernel was built with
>> O=$KDIR make) because only generated headers are present under
>> $KDIR/include/ in that case.
>>
>> <linux/page_frag_cache.h> was added more than a year ago (v6.13) so
>> we can probably live without that check.
> More generally building selftests with random older kernel versions
> isn't really something that's expected to be robust:

I suppose that Documentation/dev-tools/kselftest.rst talks about
*running* against older kernels, not *building* against them. That said,
we are dealing with an out-of-tree kernel module here, so the two are
essentially the same... Yunsheng suggested an updated check that I think
is reasonable, maybe it is a reasonable compromise?

- Kevin

