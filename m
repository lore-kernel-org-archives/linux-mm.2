Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DE55CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 12:18:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FBD36B0005; Wed, 10 Jun 2026 08:18:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ACFF6B0088; Wed, 10 Jun 2026 08:18:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B556B008A; Wed, 10 Jun 2026 08:18:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B07D6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 08:18:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31AE4165491
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:18:40 +0000 (UTC)
X-FDA: 84863906400.05.3098408
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DC97100010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 12:18:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMOXA8GH;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781093918;
	b=REo6PRzdfdDoJ2pqTR7JUrDiwm0UyXPCI/Hq77hqOqNAEie/+/dBVZ1SvVByOiF673JKvj
	ZtTU7SlfqBoUhgcpgxlZRiWrMqxdEgHT6vSwZxSeVR9LLn33lDYjFdjaSv/6ld7xLjlwyx
	LtOcOAy8vKFp4no9p/+ixOBVmPl7m9M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMOXA8GH;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781093918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/nmKCF3PlHtsp8BoIrnN8jgGS3KEpCp0NRU8EXhq3c=;
	b=jhVRwsnbDSUSrT3YBwX02oVQVYa3V3LUbFMTmdzKawHAMBLMUrot2gywSdHSy0nIRNMrN2
	tuBDpPaP1q4WDOqCmi/twO9N6mFlW1e+Kiwjts0SFNoFJrGoAi8h7fbqdOUig09dmyUO2U
	OcWEe5BHAVvCFJnYRSV2QQ3Rhd5YWJQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2596D43466;
	Wed, 10 Jun 2026 12:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A981F00893;
	Wed, 10 Jun 2026 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781093917;
	bh=A/nmKCF3PlHtsp8BoIrnN8jgGS3KEpCp0NRU8EXhq3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jMOXA8GH07QhcMhyvYrDmhrTiwuzZdFOFsw6UOyGLBIL/AyIsle0E/ksi4Ir8BMtJ
	 0w0lsgWx/FlQlZon7VbUS2DLTEd87ZIeDUuifkhcshfeZi3hzakJMP7A89qkYTMpYu
	 EMpaGOIEj6y469m44xy6EDVh7+0oY0eMY6bDDg8VrOqlos9uZwYGTPKIrtaKkX/+cB
	 Xgo17v8axIMsXMZy498yaCjQJXJiovxlljAIGiRNXKWiF/gFHjDp/K7aYlPE4NSv/K
	 vODFoFcBsYyGX7YfcMs96aNJlDauvjGwyAaR/H6pbrARFZsRx80zE6bNNQ8PQEH/on
	 pYM1Idh4qADTQ==
Message-ID: <05a8071f-d3e7-4a24-985a-41fd5639c8e3@kernel.org>
Date: Wed, 10 Jun 2026 14:18:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup_test: reject wrapped user ranges
To: Samuel Moelius <sam.moelius@trailofbits.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>,
 "open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)" <linux-mm@kvack.org>,
 open list <linux-kernel@vger.kernel.org>
References: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4DC97100010
X-Stat-Signature: en4i5q44eg7h69g8nu33wk8rfradms55
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781093918-301175
X-HE-Meta: U2FsdGVkX18ffB4gPckVMLVdsfRexPHGgLSzZ+vExmU4lzoFacx+XASzCfqTuoZgDq0X1MEsp4x/99y7RoB/zSXrKJVce+6kJGdodteAX4smne0d5MxGsdNbxWWbxBdxpa1o4dt/ykflrQ7Hmb6B7lmQsUbdHfUuIFopvi4Mj2LYTuBDFp2I/tuG1aE12KmlQ4ZFETI50jnpG7t1FTYKRIQYEKwnuYyMb0+TVii40EZJPU6Y9hluNEHHHrvfzWcdZggnCIGo/FtiJodzLBAgA61JlEdqr/Gd4i0YIGopQphqcm6ysyrQroBaApOp/58Swpp4MXR1t2JsCInOQdSWJzVlOeXxsW5bWRTlRJA6lLOD0L7v32gHGuj5/zlbQ2rxv2nEEHwL6KYOWkLH+L0922KidbLWy2fOWIZ/espKi9Dx39O4IGo7eVjD4UsWIlP/USJsr5DaO5MOYTsNpcjpcZBW6LInFgHLg8wxyPPWrFLFpIQSe/xpLzYtsBwOJuTFy6MyijrQ0PvxWG9gUa6NzQtvVJY93cPN2pbVU3HA+VOBIX/RVYVtyXr2IKkfp+9pRIcHyGfO+y4DCFJWJdxVGyTUXRI0B7N3n4/hOlBvnIlAU/ELJ0Ntt7BRFWew0SliAWhYGKlSBA7MnwAdN+y1mlvn2wcah92YUIoqyfsxiyGXrvyUZlsRgLK0G8kXeldBzh7vsHDKlajacHKpBzpXBW/oaBOe+t1kvbCq4XF/YcviWT+x3V3POt9i4420stN4ZkDMCin6aAwNzAsgldhjKe0bqsSqu6CmWjVXUqw2jXlUaooLO5Ss+7NOUDSM++AhHvi64x/XnhwCk4do5/1hEd5YdGvCIWEBLDHtW7mpjcBC4vvh7GSefNVWi7VipCXzphjtm+w2mfZFgH27f5+E7VAOQz5mGa60kbvNskRxGDIChRZHJYlPCZ+Mnpd8oWeSwQ+WfqppjDDcMdAA1K6
 CHpG7/cM
 Wx5z95LsoxNNF6fI1ipt2aURk/iCswtUOm7igYNZPRiy5ShpQDLkRnSN6hq6BE58E+vDl+8wuaKfsFWBRl49O04/coUDzh6z0nMXJ2I5NZajttK8vPU2fgxm9UUgrma2Ksq3l1EXvrsZubmW0R/W52SPY2mlXHIygm5JT4+V3cS7aYCmPvQrCWFnE86lZL/eXOJfnhWTJTN+jeGilu+O9dtd+ZwVgj5e4ofxYrxKong9ghjyhj9EYkdOqczzXZ/8oWm7WSDzYOqAnUhHzWnGwTQPMDJNwJUSp952oteRESKFtK8kf1xSqf0llzn4ikBqZD/SYbGB1pS0rzdF44tyQf1T32K8vS/gBdC2GdFNARidt5NcU57meEViHVz1DgE+dt+j8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 02:48, Samuel Moelius wrote:
> gup_test accepts an address and size from the debugfs ioctl and
> repeatedly compares against addr + size. If that addition wraps, the
> loop can be skipped and the ioctl returns success with size rewritten to
> zero.

Yeah, it's only used for testing and (a) not expected to be included in
production kernels or of so (b) only accessible to root.

So we didn't particularly care about making this interface watertight.

> 
> Compute the end address once with overflow checking and use that checked
> end for the loop bounds.
> 
> Assisted-by: Codex:gpt-5.5-cyber-preview
> Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
> ---
>  mm/gup_test.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/gup_test.c b/mm/gup_test.c
> index 9dd48db897b9..eb4c9cda16ed 100644
> --- a/mm/gup_test.c
> +++ b/mm/gup_test.c
> @@ -105,11 +105,15 @@ static int __gup_test_ioctl(unsigned int cmd,
>  	unsigned long i, nr_pages, addr, next;
>  	long nr;
>  	struct page **pages;
> +	unsigned long end;
>  	int ret = 0;
>  	bool needs_mmap_lock =
>  		cmd != GUP_FAST_BENCHMARK && cmd != PIN_FAST_BENCHMARK;
>  
> -	if (gup->size > ULONG_MAX)
> +	if (gup->addr > ULONG_MAX || gup->size > ULONG_MAX)
> +		return -EINVAL;
> +	if (check_add_overflow((unsigned long)gup->addr,
> +			       (unsigned long)gup->size, &end))
>  		return -EINVAL;
>  
>  	nr_pages = gup->size / PAGE_SIZE;
> @@ -125,13 +129,13 @@ static int __gup_test_ioctl(unsigned int cmd,
>  	i = 0;
>  	nr = gup->nr_pages_per_call;
>  	start_time = ktime_get();
> -	for (addr = gup->addr; addr < gup->addr + gup->size; addr = next) {
> +	for (addr = gup->addr; addr < end; addr = next) {
>  		if (nr != gup->nr_pages_per_call)
>  			break;
>  
>  		next = addr + nr * PAGE_SIZE;
> -		if (next > gup->addr + gup->size) {
> -			next = gup->addr + gup->size;
> +		if (next > end) {
> +			next = end;
>  			nr = (next - addr) / PAGE_SIZE;
>  		}
>  

LGTM

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

