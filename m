Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F5ECCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B09A6B0005; Thu, 11 Jun 2026 06:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43A116B0088; Thu, 11 Jun 2026 06:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 301BA6B008C; Thu, 11 Jun 2026 06:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C4B06B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:35:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AAA35405B2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:35:47 +0000 (UTC)
X-FDA: 84867275934.08.EB95830
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08F88120009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:35:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KFy8/n/U";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781174146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcsQscn35Hn+B3P9DzOAGAp7XTk6vMF6bXs5BZWRQI4=;
	b=Fq4+s1atl8s0uJ9ZFWDnsN3hP1uJgm8rgb29CZ7c11fYqVUeh1GjcRofpcJkFJ5nNYlxHD
	3ifXe/5puR6QGwTU6iXcokYbX6tndgIUU56HaeUntwfpT0XJcSYm2hdGIQ5Rf+wUVXQ1+I
	OFVJNFZxRoJ0v0qUrKWQ59ezM1E4Vdw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KFy8/n/U";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781174146;
	b=t/HoM2Kyg81RS33ro/ujH2gAo0YNcjBbak06GDmziXWEW51O9qTn6UJvdNhR8qsXh/Z8lH
	Y9aWCqca1TlPjN64SxqbI7GoS98s1VvfefyAu2pGQSTpEECcV7m9cGWDNlt5qIxQWYbegT
	v8EThLwOQ6hFWCsvAP638bjGPpEWEqM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781174139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JcsQscn35Hn+B3P9DzOAGAp7XTk6vMF6bXs5BZWRQI4=;
	b=KFy8/n/U/fMnO10jGMsAygH4UuAAi21IOhBjFo7Xzu7zVu4XCvEjkoJ8LarfwYpOklSdRa
	kWeT9p74fCYbUZZMIJscQ118mwSlcgHEyJ71iwi/tBAUUtGcxMEmP6dGbNqb+yMd49Y/LP
	6NH3XiQ/KrwvwidiAoww7440ILnsNRI=
From: Lance Yang <lance.yang@linux.dev>
To: rppt@kernel.org
Cc: lance.yang@linux.dev,
	dave.hansen@intel.com,
	xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	x86@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	hpa@zytor.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	yang@os.amperecomputing.com,
	jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero folio read-only
Date: Thu, 11 Jun 2026 18:35:12 +0800
Message-Id: <20260611103512.46955-1-lance.yang@linux.dev>
In-Reply-To: <aipacpSZrO1DKooO@kernel.org>
References: <aipacpSZrO1DKooO@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 08F88120009
X-Stat-Signature: d4k99843xw3xwrf95qd1meunp9xrt4j1
X-HE-Tag: 1781174143-159487
X-HE-Meta: U2FsdGVkX1/usmWkUQ3KzSQSu0piujWI+pUSEmxLVJ0XwgGv2kK4h91NScl2ZcIN89o+9iHD4wZItQB4ThPj2gUK2TXkrrD+z7TAQ66aXfa75FTmkgVkEW/oP/PenL3uk2cnY6QskYOgrI/WGYcjzxtEIphVga6XHUjv8FRpsVvPGOPj8qqFTAPZsxgi8lq1n91EuRRQZ3eXTBy/lALGPcVGtzyd3CXA5+bKUMTbzKT1a5qL55vEVLloMOt//OYIDW3y/F4N1fWiU7kyL1hhpL+jZmyG4V7bRPUdFnSH6A8dtotwySNKAKOaFUOgKJt72q58lq3Mxerkix0Pk4P5KbH0WZ5cHRmRy4EOFxQmttPTY2WfZNFaWNWus5Ye2tI1cZe8vKD4y0GRnDZtrZLXM4VYFRkdQLRsPjEWaJobPNiNMwEL18BvOsXpE9jDnWVE4SqHjP1yv2bSNe0PcFrEf16FU+T1/3/rC06RhZAE8evyq7jBr9U9IUImt9rsw1FBJCS1XSeZMawDAb2HXqEBdFTCicoD9NdPnvOeQR3gesQv/HtTXYvQn56O8YLglkjR/QYa6NOS8LEr7nBN0JsPz7emruzbmwuO0I+bloR00iHSkHy9dxHdpnrsaVS3qpOotqT9SXrzXoBw44lDfTJU9DCAVJYK5xDQPTnnfGhI7qqnfL0V4hNGVpUhN3Phiu5E/PDsg1QA7x9L1HyM1kHWpLm9wq7HM9HReHYduCf6S4dvjt93WL6iRKmDTkasSHqIAzUA+hLI2S3IJysvoDUJkpiHdDbZ2RaTIv8D/jdLpywdx7ZXxGnQCQrFmLuwQxGsUVEJwQRhxxZyP7Fll5mdxepyrg6NA+v5//GNJm47EW/WPZuksx+va9cJ6P13Orvrvf2Ba2YoSEn9e0QBJsgEwyCfIwhaIVjb4y3BloqeErDsc3Dw1afm0StliFnlUFqJ1UUEuE+FpyM2F6Iukbf
 wrfIg+d/
 e3bOWtJLkUBe78FtXqSebK7BCW3lVBPgnTkwp0PML/1gheMvFyPsT/XB+rdg+GOA6QkDL718E58ihFeMsNI1CkwiHQq2M4d61+6CpO5lF4M3iPKvHHtCdYjVBnShKioe4stEe1HoBxRD00cyTGcLpeCONBDwqJq7FO7SNEuuSLdCdwETuRr5hLWt0rlIzBf+y479R1z7qtkeqGhn6FbEeitepOOkw+Dd+ToY9sbMIj4brVcIjoWXivP3pmExiMQTW0p3ng41NChLxf56R+RbKWWmRQPWGVO4kSGHeGMA2y/fNAWIUQ7DM75XZcYeaZwzvwpLpnowLkXwbhUk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 09:49:22AM +0300, Mike Rapoport wrote:
>Hi,

Hi,

>
>On Wed, Jun 10, 2026 at 11:20:22AM +0800, Lance Yang wrote:
>> Hi Dave,
>> 
>> Thanks for taking the time to review.
>> 
>> On Tue, Jun 09, 2026 at 12:33:36PM -0700, Dave Hansen wrote:
>> >On 6/9/26 07:37, Xueyuan Chen wrote:
>> >> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
>> >> +{
>> >> +	return false;
>> >> +}
>> >
>> >This is a rather wonky function. It's going to cause all kinds of fun if
>> >it is used like this:
>> >
>> >	arch_make_pages_readonly(syscall_table, 1);
>> 
>> Ouch, yeah, it is ...
>
>We already have set_direct_map* APIs, why don't you add a new one there?
>set_direct_map_ro() for example.

Good point. I was trying to make this generic, but that's a bit too cute.
This is really a direct-map thing, so adding a set_direct_map_ro() helper
there makes more sense.

> 
>> >It's also kinda weird to have it return a bool, and not check that bool
>> >at the single call site. Some things come to mind:
>> >
>> >1. This function needs commenting. It needs to say what it does, when
>> >   architectures should override it and what their implementations
>> >   should look like. It needs to be clear that this can't be used for
>> >   anything really important. What should architectures do with alias
>> >   mappings? Are they allowed to touch non-direct map aliases? Are they
>> >   required to?
>> 
>> Agreed. Needs a real comment ...
>> 
>> Just meant as a best-effort direct/linear-map permission chang, nothing
>> stronger than that. I should spell out what happens, or does not happen,
>> to non-direct-map aliases, if anything, and make clear callers cannot
>> treat this as a hard guarantee :D
>
>It's not only about highmem, anything that changes the direct map might
>fail to allocate memory when splitting larger mappings.

Yes, exactly.

> 
>> >2. The return type needs to be reconsidered. Is 'bool' even acceptable?
>> >   Should it just be 'void' if callers can't do anything when it fails?
>> 
>> Maybe ignoring it is OK now, but someone may need the return value later?
>> 
>> >3. What should the naming be? "readonly" vs "ro". Should it have a
>> >   "maybe" since it's kinda optional?
>> 
>> Fair point. "make" may be overstating it a bit ...
>> 
>> With a return value, arch_try_make_pages_readonly() sounds about right
>> to me. If we end up with void and pure best-effort semantics, maybe
>> arch_maybe_make_pages_readonly() fits better :)
>
>Realistically, I wouldn't expect 32-bit configs to enable
>PERSISTENT_HUGE_ZERO_FOLIO or even THP, so naming this function to reflect
>32-bit behaviour seems odd going forward.

Cool with that, if no one objects. No need to bake that into the name I
guess. int return plus a comment should be enough, just like
set_direct_map_*() family already does :)

>> >4. Should this new API be folio or page-based in the first place?
>> 
>> For page vs folio, I was mostly following David's RFC v1 suggestion.
>> 
>> Current caller is a folio, sure, but the page-range helper leaves room
>> for non-folio users later. Happy to add a simple folio wrapper if that
>> reads better ;)
>> 
>> >5. Is mm/huge_memory.c the right place to define a generic mm function,
>> >   even a stub?
>> 
>> Ah, you're right! My bad, wrong place for a generic stub. Will move it
>> out for RFC v3.
>
>We have include/linux/set_memory.h for such function declarations and their
>stubs.

Yep, will move it there :)

Thanks, Lance

