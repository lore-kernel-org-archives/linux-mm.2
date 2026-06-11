Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD24FCD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C11286B0093; Thu, 11 Jun 2026 02:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2106B0095; Thu, 11 Jun 2026 02:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8256B0096; Thu, 11 Jun 2026 02:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 99C0A6B0093
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:49:38 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CF03C1DA4
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:49:38 +0000 (UTC)
X-FDA: 84866706036.26.16D9BE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7BCB440006
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:49:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z6SKi/fi";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781160576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lC8ycInTVWa80ivQlmiFJsfkdHS3LZShZCSRnJHPAlA=;
	b=eyeW7d0HlsgDGi04ZjeY4cvmSSA3u2jC39SC1LcBahPwDh+wZ0907apCTuNpMQJJTQNRck
	O//+Kv6Jdo7Itfu24vpYljiujCP34Z3E2sqBElxZpU+26gzae3fsQq71kR8faQz4IvdwsT
	DDxTY6ZgMtyEmrGQkDvYKQUtWMpc5RA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Z6SKi/fi";
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781160576;
	b=UVfAAAQkFpGrfesWc0Q2ZcDRAiKStZ7KakoV8QCs9h5WMuvq41pmoaVZEbncqDl0EoW5TK
	8NFg7gHwHm+u7tqxcskA/HUBlP0HW5eNNOrwTMQf6qEBhRm5yTBE6htC5L55eAJToAq/WH
	r7mqugYRSHjMGI7mRAhVw8j9k2NgEUY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DA789600AA;
	Thu, 11 Jun 2026 06:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA841F00893;
	Thu, 11 Jun 2026 06:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781160575;
	bh=lC8ycInTVWa80ivQlmiFJsfkdHS3LZShZCSRnJHPAlA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Z6SKi/fiaA2C2wYajoTbWuUo44PjNAOAJTiPHw824PI9E6pXkIHtOqCt7sirQQmdh
	 6n2RHUP8v0VHzxMFhjmcUXxCXeLWeg3HED/QenMFuJBVdQUZEmSXodSDhbXbjJxaA9
	 Oz3cxcXVtSYJD5EIR1nsweD9YH1JlSEorvZD0QiXHnUcKyDTiTrvx7r9P8CL1n/d9z
	 MSWLmlCyFlV1zXBx07Rf1aI652Yke4Gu3EhZ78CfM9cotPK/qjynEoF2P+k3bULQTF
	 7gqOsaS30CxIboAq+j7qM8/f+sqKLryS1gk8iaSLLOGohIllpuC+sVZo/9nvdTSKEj
	 xOhsMuJp8cUQA==
Date: Thu, 11 Jun 2026 09:49:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: dave.hansen@intel.com, xueyuan.chen21@gmail.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	x86@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, luto@kernel.org, peterz@infradead.org,
	hpa@zytor.com, david@kernel.org, ljs@kernel.org, liam@infradead.org,
	vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	yang@os.amperecomputing.com, jannh@google.com
Subject: Re: [RFC PATCH v2 1/3] mm/huge_memory: make persistent huge zero
 folio read-only
Message-ID: <aipacpSZrO1DKooO@kernel.org>
References: <930d9121-9176-4a7b-a2d7-8224f94000d3@intel.com>
 <20260610032022.23361-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260610032022.23361-1-lance.yang@linux.dev>
X-Rspamd-Queue-Id: 7BCB440006
X-Stat-Signature: cf53fmzmt3nw1mazqixr6kksf8bsnc61
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781160576-271062
X-HE-Meta: U2FsdGVkX19BKSdFHPnVHOr8Xm3AxlOIKIushlpD41jy2Fh6njKwT2HMw7e8hcP6pKeO7bjGiEuj93v3JnChUtl2qzoG93uUHjVDJdlrNxxFgNMmeuD7hPYHJw0z41rqTk4qGUyMajW9G0BzRC3VmlPrWIdYo7u6mNY/ZxaO0DB2d4EIV5kqal5BS09OvvadmTXCQWTqf+s7gbIQct97Z7AQws9rDHdpBknb++f+zrMZirAJ0QTXAqZjdBZS0TZ/yNvm+HjHtB/Lvrk4cx5mXYNhmJOSgcfIiBYtg3zhcoCa2EZ4Un2zKAE4aqJRSAu8mybNh0nRyJx5a2hWrQAhJrZDiTaSMMObtXTHX094p0/DCAiXFdSh1yl9AWFMltO5VRH5zFBl+UMqkRwoaPiQCLsdTMCYxnpoe6WgO7F+/h5uiP4SKtm27vbV5k51esk3YlXfL+lLcCvgObTPhTJgbfumAiCzwGlH5A4P3zcTn856FghaAW7rgeQ27Cw7OpIhSJ1pdP7hpLsfRSgypYItLlmnUTg8SRhm1rpSALlmkDjFdo+khNjZaYvc62NokXL4s/zI+HpUbkLK5hoNw/vATevrCNHNx2MSjhKZ8vRI5xU991Jszoi2bKCkFf0KUAph7L2oSJZ0cQ/WaWiw5tnYskiB9yuvkmGzeM6OERrxS6ikWSr9rTlj/IzmuqWZAhxu4R+jiuWXIqXc8SyvHfhBNBJjNLBsmY2BdRRa3jtOrtTWSux4CwGcrj2aLmJ5hR23hA7XNiSjnzZaKKjhR31f8OXz3XqedVZwps7AA6bLg5wB5YQj/uT+5wqKbhHQFpfEamfhRYOHqFfWnByWAiGd1gIbV6MK2wa6cjF46ieO2eyg4ZdsmiFLHFra/XvfqDHLYvdXDgEH3aoytqYGEHyzFT79f1URNefxD76/38dm23QXN6EqfBbirO1VMxr8DUm1sTVBRT4N5QIdrV5WglL
 t+Vbp18O
 Cm7NQQZnmTV5Y3hYLOI1RuIMetefccEdl+YZvRv4xGd+DNtLxrBQilYAuzQ4k28K+6V0dMI598Cd/Mnl0awm2LYPOS8jbj5UjwdcQ0yOJiSi0KWUUnZ6saDQ54uSDJosqlrVkzz72ZEcTEhWTWGH48KMEcqDixltsKXjpX/41FxcygAnFoHeUong6TTHJNIT9ldzMGrPSSIO3VNybGZISTug22BXgVWqhE9liFzi4ZEx/MnUBp9N6D6ul6/0BnGEQZGP77x3qAYwgtGW1+lrE2Yvkmji6wIDAcfpnEjO6XdOmCN1dg4CAjMAWx2vxIWpXdVSoEAIO0J72gvk9PSIcaFrQ7QFQf3gd2vitzN9nndTgyF++ldA+DsLHk2Aufbd38u3X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Wed, Jun 10, 2026 at 11:20:22AM +0800, Lance Yang wrote:
> Hi Dave,
> 
> Thanks for taking the time to review.
> 
> On Tue, Jun 09, 2026 at 12:33:36PM -0700, Dave Hansen wrote:
> >On 6/9/26 07:37, Xueyuan Chen wrote:
> >> +bool __weak arch_make_pages_readonly(struct page *page, int nr_pages)
> >> +{
> >> +	return false;
> >> +}
> >
> >This is a rather wonky function. It's going to cause all kinds of fun if
> >it is used like this:
> >
> >	arch_make_pages_readonly(syscall_table, 1);
> 
> Ouch, yeah, it is ...

We already have set_direct_map* APIs, why don't you add a new one there?
set_direct_map_ro() for example.
 
> >It's also kinda weird to have it return a bool, and not check that bool
> >at the single call site. Some things come to mind:
> >
> >1. This function needs commenting. It needs to say what it does, when
> >   architectures should override it and what their implementations
> >   should look like. It needs to be clear that this can't be used for
> >   anything really important. What should architectures do with alias
> >   mappings? Are they allowed to touch non-direct map aliases? Are they
> >   required to?
> 
> Agreed. Needs a real comment ...
> 
> Just meant as a best-effort direct/linear-map permission chang, nothing
> stronger than that. I should spell out what happens, or does not happen,
> to non-direct-map aliases, if anything, and make clear callers cannot
> treat this as a hard guarantee :D

It's not only about highmem, anything that changes the direct map might
fail to allocate memory when splitting larger mappings.
 
> >2. The return type needs to be reconsidered. Is 'bool' even acceptable?
> >   Should it just be 'void' if callers can't do anything when it fails?
> 
> Maybe ignoring it is OK now, but someone may need the return value later?
> 
> >3. What should the naming be? "readonly" vs "ro". Should it have a
> >   "maybe" since it's kinda optional?
> 
> Fair point. "make" may be overstating it a bit ...
> 
> With a return value, arch_try_make_pages_readonly() sounds about right
> to me. If we end up with void and pure best-effort semantics, maybe
> arch_maybe_make_pages_readonly() fits better :)

Realistically, I wouldn't expect 32-bit configs to enable
PERSISTENT_HUGE_ZERO_FOLIO or even THP, so naming this function to reflect
32-bit behaviour seems odd going forward.
 
> >4. Should this new API be folio or page-based in the first place?
> 
> For page vs folio, I was mostly following David's RFC v1 suggestion.
> 
> Current caller is a folio, sure, but the page-range helper leaves room
> for non-folio users later. Happy to add a simple folio wrapper if that
> reads better ;)
> 
> >5. Is mm/huge_memory.c the right place to define a generic mm function,
> >   even a stub?
> 
> Ah, you're right! My bad, wrong place for a generic stub. Will move it
> out for RFC v3.

We have include/linux/set_memory.h for such function declarations and their
stubs.
 
> Thanks, Lance
> 

-- 
Sincerely yours,
Mike.

