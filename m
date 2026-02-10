Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B064EA811C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF98D6B0005; Tue, 10 Feb 2026 08:55:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB5C6B0088; Tue, 10 Feb 2026 08:55:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C07CA6B008C; Tue, 10 Feb 2026 08:55:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B09B36B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:55:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 734121B36C4
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:55:09 +0000 (UTC)
X-FDA: 84428693538.04.6A21DFE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id A1DC4C0002
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:55:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E487ggY+gJtWMvjVQrIXPGUchObSyDSpCtO5/93bakQ=;
	b=W3AHRIfeO1zWDBYXolBGLWU9IGcEwU26EhvQlwD/Sj8z8a4FUVWZeQp9PuCTUWoir9Jgqw
	tTz53bKqmYCDsNPDFNRKfbNZbb013GsJAQO4kobbZdyqM4tYeJ6BA1Kr8XUdYf0IwHYTLd
	URNhrSJUbKiNuI5oabo9Mz49NUjFebE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf28.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731707; a=rsa-sha256;
	cv=none;
	b=Y7De0XRw7FZCgYTc5MMuxn61YFb+G7DInjaqMc5q5sYuKaIP3SE6rQO9dEkfxyGInNNBNf
	+E/9x8alyc2wbQQrzFnq64WVK2Uem2ij7dx9j0u7TmmDaDpZZGRGqlHGUdKOzdsKFhP1EY
	kx4ftrD7yYcym0UM6k5HxJGdfCGBJYI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54228339;
	Tue, 10 Feb 2026 05:55:00 -0800 (PST)
Received: from [10.164.19.61] (unknown [10.164.19.61])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 455553F632;
	Tue, 10 Feb 2026 05:55:01 -0800 (PST)
Message-ID: <a6ca4f14-83f6-4ee3-b8c5-05e2d4c49d32@arm.com>
Date: Tue, 10 Feb 2026 19:24:59 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: map maximum pages possible in finish_fault
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>, akpm@linux-foundation.org,
 david@kernel.org, Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kirill@shutemov.name
References: <20260206135648.38164-1-dev.jain@arm.com>
 <aYYHGisOQFQINXwR@casper.infradead.org>
 <397482e7-3c89-48e5-9e8c-0798ac92cc05@arm.com>
 <0c956b6c-1d75-48f0-b55c-ae9887dce79f@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <0c956b6c-1d75-48f0-b55c-ae9887dce79f@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rpnwfa9eeh8xrmbc3h56c544qurjoekf
X-Rspamd-Queue-Id: A1DC4C0002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770731707-555636
X-HE-Meta: U2FsdGVkX1/U2xLfpPuHTocF7hHORsdSPDPyWot5l5Db01o+EmCE1CXTt3D1mDquqYWEu6uQeOyUB/1qcpVgZG+WPdhgoBb4kp5I2Kpgb2gBMpAEitqpKZef5SuVWnKjBcmzAdrogBVIUL0KineI5QGlnGzSSK/c4MJkbZceqOIz0iXIaOTg2ISlEeSYcpImJx6WQ6USUChzYeHvyPsyOAhkkvDyLcrsTsdchFbph2X4v0qTcpBOITt1Lrd0qNrC384LJD5TlL0OpQzUMw0wZrImAWNJ/Q4eFSAGx2WRwJ25ylV+oiyuGg7+e1eFVGnLRS6Ekpu+TmaVEXaKmDhA6r5eJSJm0M2AlJQfox1D6TDOK7xtwvAldaVNrXzY3+Umaw0/Hm0708t25JFqNJk1QMCw0q9v2hB2aikPzlOa7rn/NkDfDfoKfuwFNVgYzk7JrFnpnc+w+P5dg+unjfr1u/TEQqoSd8hzX+MAH56XjNVW+n8we7rUunnwtj445fpvnTRmYikVygME6nfMLiYhTPx9I5YtPwvGM65YC7We2dmbszDmert4GSK4cZykRILUlQhVyjqXHwR7meS4k7oRB7vKyaQYZqrCVfWSVTUKwmXcrc+byoe6jr6lDkU/+2jyBwpEFn1hc+2LxLEvtormkaaTWa3flrAyzAXdd81bhwRXdQbw5f+1oleesggsMUfhIA3N4/KiGbywymPgvLDOleGqXnGPXZTfKR0exuAGeRPoQF/pfsC7VhnAyfGMnoqRercTC4poVxXjfMZbF20iX8F3YADF/9aLMwKoKQtMJ77yFUdBYRSIwf1qWVSVF7PNobwH6KdDg3cXt6aruplSWcXjrdCztIaM5znL1l5/uLiwt3i+qIj4Qe++zwAzr8NhN2tWmTiOcExmpUUnyj2PQyrW3n5LKKDjok/TYjImZTUG3n8DY74BQU8SmI8YKagdf1R1MdG8eE0sLKUNNv0
 VmYzeKZs
 p5EHqRuuzjr4WQq8t+SPOtMD302itCnTDjWSAm9YU42l7k/tvOobsAYQ7vuO2pQrXA+tHRa9ZqA1IbJ0Cy4b2Y5nfEJBrzDUWdsJFPPSwNnHCQrEKcUoacMfy1TeC8c6C2242SELS52qPsLoOqVk4KL4CNLga5ZgtEqa5PNXOtddTS6GZ4ozBJ+yPKNRu53+km58Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 10/02/26 7:09 pm, Lorenzo Stoakes wrote:
> On Tue, Feb 10, 2026 at 06:58:37PM +0530, Dev Jain wrote:
>> On 06/02/26 8:52 pm, Matthew Wilcox wrote:
>>> On Fri, Feb 06, 2026 at 07:26:48PM +0530, Dev Jain wrote:
>>>> We test the patch with the following userspace program. A shmem VMA of
>>>> 2M is created, and faulted in, with sysfs setting
>>>> hugepages-2048k/shmem_enabled = always, so that the pagecache is populated
>>>> with a 2M folio. Then, a 64K VMA is created, and we fault on each page.
>>>> Then, we do MADV_DONTNEED to zap the pagetable, so that we can fault again
>>>> in the next iteration. We measure the accumulated time taken during
>>>> faulting the VMA.
>>>>
>>>> On arm64,
>>>>
>>>> without patch:
>>>> Total time taken by inner loop: 4701721766 ns
>>>>
>>>> with patch:
>>>> Total time taken by inner loop: 516043507 ns
>>>>
>>>> giving a 9x improvement.
>>> It's nice that you can construct a test-case that shows improvement, but
>>> is there any real workload that benefits from this?
>> I can try to measure this. But, I constructed that testcase to test the
>> code path, not to show a perf boost (although the boost is obvious enough
>> so why not show it). As I say in the description:
>>
>> "Align finish_fault with filemap_map_pages, and map as many pages as
>> possible, without crossing VMA/PMD/file boundaries."
>>
>> The patch should rather be seen as an extension to 19773df031bc
>> ("mm/fault: try to map the entire file folio in finish_fault()").
>> The code which my patch removes, was added when the norm was to still
>> perform per-page fault, the argument being, RSS inflation.
>>
>> Perhaps I can polish the patch description so that it clearly mentions
>> what the objective is.
>>
> Can we make any new respin of this RFC please. I am especially not
> confident given the immediate syzbot etc.

Sure.

>
> If it's a speculative thing without great justification the series should
> be RFC until such time the community decides it's worthwhile.
>
> Thanks, Lorenzo

