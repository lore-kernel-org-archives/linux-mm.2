Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6577ECD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 01:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981AB6B00BC; Tue,  9 Jun 2026 21:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 959496B00BD; Tue,  9 Jun 2026 21:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 896006B00BE; Tue,  9 Jun 2026 21:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7CBD66B00BC
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 21:27:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D6DB1C24A2
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:27:09 +0000 (UTC)
X-FDA: 84862264578.30.B8F6717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E3D01C000D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 01:27:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I5mmvD40;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781054827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbufI5UN7haAr2GXCIUXNFjbjTsAYfOBZpq9LnBznZI=;
	b=i9ulmrUcppgoZCh3LjiZE4Jam+jJ9hiTugk1oicyYgo18reOuQUDTpNwY3c8wvPVYPvBqo
	zjQ4derFnKZkhRkrgMv3H+ledAMGrBrRF7VbxMzeaKzKevGB9PP/GZa/JQi/HtNSvvZcOQ
	yLewbyt4Z5Ho0ETuCPhlWiFOywUXLU0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781054827;
	b=sntXZA9G0NzVfxVhoRDKAdoZAEfpRRoA6pBmi1Z5Xo/F+C5pSK2wqJm/ybVcA9e9rDbHdw
	LXNGRmWd/Vp5LHpfiZynUIkpbAkRJ91GRCyv9rNDCvvPZz/qxJjlJ1vaBh0/VcM1UFgFce
	s4rd5liYVzmmraslJfsLrpssE1Q+oiI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=I5mmvD40;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C4BC40E28;
	Wed, 10 Jun 2026 01:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B741F00893;
	Wed, 10 Jun 2026 01:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1781054826;
	bh=CbufI5UN7haAr2GXCIUXNFjbjTsAYfOBZpq9LnBznZI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=I5mmvD40Yv2kgScp4/uhuaxnCLTJ4Sw/z13rBmQ2bslNqzv2/P7iyCgaG8oE+6FZe
	 ClXyZ8aqO+72QW0O8k0+s6bPMzMAXgdjdWu1NWLu3r6uTnjXGNwo6ScG9jBLd1Blcq
	 3XMMVH7mM4lShFrSTt/MHITyxprk9BN675b8weE0=
Date: Tue, 9 Jun 2026 18:27:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samuel Moelius <sam.moelius@trailofbits.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org (open list:MEMORY MANAGEMENT - GUP (GET USER PAGES)),
 linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH] mm/gup_test: reject wrapped user ranges
Message-Id: <20260609182705.7b3a46e7c4661bd55f8561eb@linux-foundation.org>
In-Reply-To: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
References: <20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E3D01C000D
X-Stat-Signature: gwgeow1djnjhi6qwhp3ap78hfsdd9onj
X-HE-Tag: 1781054827-773172
X-HE-Meta: U2FsdGVkX185lzwW02KYUCpCTZ/q9Zr5E4qdMCboz/2Gb7nWa9b2D6JvIp46BmLx90+U54lPSshmvuAH9w/mm172EXsJpTZFnKmt2MO5EyirZt5SEcq6hiOKbjlXoQnpOUQMyYOkPAE7dRc1qBSNgN2eYjGj7HDLsqWfFTtSNVMSWzshACJliwgZYe/hqmQP17FhhrMa1XGu3UwXoD59lHzUf8hM7IgEe2OLt9KvMxwalDWOctce83uc9oZMnR4Ko/qQbEUQC9X3hYQmGMU8tODAYTH+Wu4NvW6wPQ0/L7RCy/IOj8j0TJdQZKIqvyMZytEfcwu5WE6liYvoUMV0kc9h9jGpjkOsuEykz6RfquRz/oYZBzp8IH/yyVrdcvPPWThwUumd2AQ4qX9eKUaziajL4AB4m3ryF4L8eG/sDZxhlFaYWKsRYUlT/LTCxjAh15BAtMxE8xWuwhBAymWKS+rE6vTZGBM7PA9u9szr/xUIaWeLPDM45epJs358CsDzfx3xC/jfirQcK+2HXPr5JrVTWXpVoJQSF5qeiIqbI/IKv/sI6/gS7x9A5BpqbNhqS2jUIo7AuxJp5aHBX9iGkIDhinKaSa5pO1zOv951T46o8rKJGfy2HqBMyUMzaqass+boIPoBTodK1KaliJTZR7FoSrZM/Jp3aO4TBB7UcnWjtD0ItgCKwgJ+lxt83ypffztfSPVudU4W4Zcgerrg4VYfN073nIfNIONVUnr/4KUOqRBa1j/vNJ/F2vbAm47o+h2aAV4cFC7WaXKCnm8FSD4Mdtc/UjyDuwq2XMgnRirwqJepgVjmW7RPXklzebFDTFfBAimsK5DsgykoXGmF3V0bz5+xfnAKrJzfFIpQJeDjHi/tXY0v2nCZkGy6GdjSSQqlvdcJsx75Az4rOLU+7rcfiaaMgn7N9zGZnsXs0YNwl8dwiy8fgEr/gr9J3DJbQr7QGdRkqJm6Eco5Gk9
 PEXk52Qd
 GRLoBrLYF/1wATyO24Mf9+8PN3UKl9bLYd7L2Ia5KqcNEkj8peFgIFCTsT+fC7Ytnne2GlPbuEpf14/u5O3CXyoBPQSmDwWZlUtMMVB047IyEEJGyOT3gJ8R3e503JRpI74gs5I3f5edesT2SO43qqSGtwir913xKB0dFe02TxQHHYvWH3iXjgC40RRjZJdAIMNZmGFDHbHlQOfNxnnphum1CO8X1maFA5QQT9rl5XvBi8cSxgEmefcA54JUVTAigcanh24FvKt4cpCg5KxlQpAfc8VKJzMn3emLO6t0IyjZ+T0ikVeXF8340IYm1AM9bSJnE/lihweY8cKcz+fCmjW1E678hDziBDxpG677HlIvpCIEJrmDGNknRxsYLfJcbbtdyncfWtY4ar4y7N+bW9MTLyUXjQekt5TG/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  9 Jun 2026 00:48:15 +0000 Samuel Moelius <sam.moelius@trailofbits.com> wrote:

> gup_test accepts an address and size from the debugfs ioctl and
> repeatedly compares against addr + size. If that addition wraps, the
> loop can be skipped and the ioctl returns success with size rewritten to
> zero.
> 
> Compute the end address once with overflow checking and use that checked
> end for the loop bounds.
> 

Looks sane, thanks.

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

I wonder why those fields were made __u64 instead of ulong.

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

Sashiko AI review identified a pre-existing possible overflow here on
32-bit machines.

https://sashiko.dev/#/patchset/20260609004814.1240586.6294d614ac80.gup-test-range-end-wrap@trailofbits.com

> -		if (next > gup->addr + gup->size) {
> -			next = gup->addr + gup->size;
> +		if (next > end) {
> +			next = end;
>  			nr = (next - addr) / PAGE_SIZE;
>  		}


