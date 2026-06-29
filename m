Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB465C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBDA56B00B8; Mon, 29 Jun 2026 08:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94836B00B9; Mon, 29 Jun 2026 08:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACAD6B00BA; Mon, 29 Jun 2026 08:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 836D56B00B8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:50:58 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11AF7903FE
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:50:58 +0000 (UTC)
X-FDA: 84932934996.06.3A88913
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2EF794000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:50:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=Js7hPGLW;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782737456;
	b=zHEKq96mpbJ1MjcoQNzDYLDuovoRT7RwP4wQ6HkitVb5EBZOWZWnyWts+CazRdEBupvGkr
	ONam1qTp5kpAAh0vfZ/IrGEeb4OHBRvbYMbW07LovCaDUFi6cY2CyN463zvlRsmVLIsMjb
	PWheK/hIj7vfKUHEeERoax3PU+gSQOA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782737456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRdbBuAywd2/yTywAa2lmTsqxPePV+KffkY5n9Y48hM=;
	b=SrohpyxNYsenmcv6ntAuTl5W31FU6qf4rkvTeuyutiwBw3/i+jLWAN4vVe2KO8MXUTmD4/
	L1p9AsWl4h9bOZEItC4Gci4yP7nvRPShozNant4l+zm7osXt9j9tTIX4Uw/nrpSVW655cj
	jpbDXTXgcD/3e5pI0hYjDnpkVuKw4Ew=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2026062701 header.b=Js7hPGLW;
	spf=pass (imf11.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from [IPV6:2601:646:8081:7da1:4462:691a:e05c:b745] ([IPv6:2601:646:8081:7da1:4462:691a:e05c:b745])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 65TCoD8T244601
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NO);
	Mon, 29 Jun 2026 05:50:14 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 65TCoD8T244601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2026062701; t=1782737416;
	bh=fRdbBuAywd2/yTywAa2lmTsqxPePV+KffkY5n9Y48hM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Js7hPGLWS5LTsb/3bMqBHhoVGIEj0VMpjxMvYFT2YIS6f3nHXeLALfVUDkd+j1wkV
	 nWUug3QAfVgal8LCz0dJ+sOdkzS+uELoC3ObibQVmQU7Joi0u/rYGI9WpA1dIX8YcH
	 Q1Jn+GhyBywHcndGzVYJ+QZ6Zum7Q8wLdpRTMu/8V9g8voVNG41Q8Bjqf/WBLWDW2B
	 h2dbJ1kQ29c77xr5O7maE+enOLuuXL+5UXjMD/MaTsmmkcK25Gpk9a9sQw9lrss5ss
	 26PFDqL2qXOJRWI+K9ckx1oVcM3YMb4bPv63pNLC6YD30f9ItKquGx5Fmmc/vCeRII
	 C1hgFlSlEGFZQ==
Message-ID: <3c4094d8-ae5e-4ffd-b28a-0c10db50296c@zytor.com>
Date: Mon, 29 Jun 2026 05:50:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Matthew Wilcox <willy@infradead.org>
Cc: Xiang Mei <xmei5@asu.edu>, Pedro Falcato <pfalcato@suse.de>,
        Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>,
        Tiffany Bao <tbao@asu.edu>, Ruoyu Wang <fishw@asu.edu>,
        Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>,
        Yan Shoshitaishvili <yans@asu.edu>
References: <20260626173444.2252041-1-xmei5@asu.edu>
 <aj7UNceukU9zYeGH@pedro-suse.lan>
 <CAPpSM+RVFDOYJFT2iwgNYdjbwqF-MmrbYizpLYksd1SLb5bT9g@mail.gmail.com>
 <499a4e15-34a4-421b-946a-c855199fdbf9@zytor.com>
 <akH34ycu5-q2Yc_D@casper.infradead.org>
Content-Language: en-US, sv-SE
From: "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <akH34ycu5-q2Yc_D@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2EF794000B
X-Stat-Signature: mqmj8q41nyadmffx4j534n48wc54tb3u
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782737454-506397
X-HE-Meta: U2FsdGVkX1/GsQ+WnH6+yIDQJxAGvJZe3afNRqrwQv4fjSM0cYIVGwn6JNAUmS4ed37nNzpr+yJsEwvm/m+utbttbKrYnViwZlT0ccL9Q8i/E/vOHdEMPHrLT9yBzimurTdXwhvw/gjKGqMo6P4jAmHpVTyfwfPjhEiJy4bbLe7u0CsFudqmUQOlVOn6r+KdAucw5hzrA5nuTsp7aXDIv3sDAIxMaij44R7yMZBFEmFZebyZ+cJc4Ih040zKLum1PWvbrDNkWLEyHI3MpQB8Y/kQTuou4YGFfShj8GUJEvygJi4Ph4Iik94KpLyeAzP2mondS/G8SbRrOhq++tlt2NDKDUgD7O3+VIWv45yiNa2Th7IBBw6LCPeh173GZjBAWiZnfBowwHiCzEuh8SY2eGUlezvnyfuijrKE+xtGOQjNlmI2e5HwsibVacoczMuXqhkDjERdrJPuqO8mfdEevyPphy0XXZpmnA6eHgnDFqhmPuNFU4IqoiVntn3DmCtCHBPz8oMtOv89tTQ9C/EOorb/50yMxwdrM851jJb1ytYRTKfHxiSqI2zqYzy1EP9yaSPZKAFckjFbdxpYyz0JFmABB6H5vYLAh/SHscAeaFJxg5fQOGCD/raumlXgIXGfctcSeLGcxkYmCrLr2TZrj/LIPsL+71ctB1Eh2h92rI6MDViNA+SrUvD8Z2i95vHgeIi0cl2x25Z8i5NTmMC75vRx+CTG9wUrok5BghRJ332Oy3T/HWbf5JB99WFbcoBdaBOfBoI1H4pefDA+7gEjyedBA1MuKVGCvUimHdfg1vmQr3A9iuzsvd/1JIBAKBpd2R6FUCjyV/kpaa9IkaKXU0+DyAmLQ6NjMZD9SN4M/Vyx/o2iVr5N3xv7jKSK8bLnJwsF2thhxVUd2ue3O3rnAbGZwMNbv4UJtr9L8u/OjyMWj083yJJur+9Wb28HU/LRDYMnh5r0I2aqNOkMicy
 AeEHG2WF
 cug1wnX/akMbqDT+QU57Squ/Pv/8JBaHGMtqjg73RQh00m1gX2dtxMpPDqVXyYTQHPVJsrHUtBheCf4oVJvvm0KMe1bNibNNrvwjMUAZZloTXo83tmLXjfR2A9utcyP38/yqvsTPeYrzq7cAKbuJ5bQkhJgaHMg8V1fEMYqmf9LV16Z9qrwy8xNTm3XiorqKBO9cIw5kl3ByK2RkSKfU1Bq0dzSXV/6I0BNwRweZUckqhMBz7ztRtJ6x7FLM4+bIjKcpdU7bAViir1M/l749K9DmMl56yKLDBVTDZS9KKZC8HDwMlfvwQJfv8Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-28 21:43, Matthew Wilcox wrote:
> On Sun, Jun 28, 2026 at 07:09:37PM -0700, H. Peter Anvin wrote:
>>
>>> 2) `enter` is not rare since we can take part in the instruction.
>>
>> This sentence doesn't parse.
> 
> They mean that we can jump into the middle of an instruction, and it is
> not rare to see a 'c8' byte in the instruction stream.
>

OK, I see the point now. The main difference is that ENTER doesn't require a
REX prefix, whereas ADD/SUB/LEA do (otherwise it truncates RSP and everything
immediately dies as a result of SMAP violations [you are welcome].)

This means that an offending bit combination is far less common.

	-hpa


