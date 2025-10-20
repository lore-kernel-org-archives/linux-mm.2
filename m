Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C058FCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:04:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134A08E000D; Mon, 20 Oct 2025 05:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D598E0002; Mon, 20 Oct 2025 05:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022A58E000D; Mon, 20 Oct 2025 05:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E48D38E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:04:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD39647F9C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:04:34 +0000 (UTC)
X-FDA: 84017906868.20.174FC22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0777840010
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:04:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GWo09CeV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760951073; a=rsa-sha256;
	cv=none;
	b=yuajfR+BhlPN6tig2dViBQe8X9PVI62Tl69yod2DYfTiKe8nnbe4yj7eDiozooVqnAxIOl
	LKENPVU0ZeUvSN+dwP+cWLx584KowJ5vh/nilEUL7hzfI2kBYCaIsLNtO5s2olO9CB5a98
	zKweN6By19OzVroH8dSRCAiL7Vm3T/0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GWo09CeV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of jirislaby@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jirislaby@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760951073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XTvbnXOk14CbKjskQxA/Q3URlStfW8hqOtCZ/y38Y7s=;
	b=KaTG4bDRj576121YQMjx0iTdMGY/BQa+WwJROUcJMXDBz397dKxqng9SA+5hMYHnPxRw4m
	CUk1BqDxl/eqWqOshk5qia8wI/D4qKEbDHJKH1m0FNunjgpPAneuICgDhBaDOyHw9uP6Zr
	kaTL/RtC/utKph3kTyoY9owbJm/FYvI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 326EC61D00;
	Mon, 20 Oct 2025 09:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7D5C4CEF9;
	Mon, 20 Oct 2025 09:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760951071;
	bh=v9GT6PE9JY8Vk9PiOUI4qsv1jNRpwj9vJTWmipP4+Zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GWo09CeVvNFcr/IN5PmrIQWXelYI2hdtKgCIvUjhArFP24/XvD49qtsMza0gr7g7I
	 3eP3LplHxzL1IBd3ymVMsYVK4jewPrPeqAMsAnmc4CCLPH8t3QhrMUVQ3bpIKP4d5b
	 oBUwq2cTXZOVObHowcT/x9RGm4Xy8ao5xWRErqfLNsac09OHHlFe/SQqEES4q0ksGh
	 QfxoltiK6klClE9Ge77mY8wS25p3tqWLwWELqjlC8KI0FMqPE16KyVyAP9poLqfeD5
	 eWjlJ9BZQQNJOmYbqgNssbwftQ/X79nqJ851WVEgnevTkLfimw8OxpvhKX+KEk3nr5
	 DRoNyZt2BURFw==
Message-ID: <700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org>
Date: Mon, 20 Oct 2025 11:04:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Al Viro <viro@ZenIV.linux.org.uk>
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org> <aPT0zNMZqt89cIXH@kernel.org>
 <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <3301af1f-c24a-4e43-ad59-402e244d5552@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0777840010
X-Stat-Signature: hx5nh6b3xdyh6a6ojxqwjtsei97arwsr
X-HE-Tag: 1760951072-62256
X-HE-Meta: U2FsdGVkX19W0ZFsVk62ql6OsIrUXOV2JhaIPPpAyz2wPtO/eIGDfwmJfAfMR5FwKLiKGuXEx2wQhuTA5dtBgN3ISYzzBL+wv72Tz3STGvaW+6z/PunXMmFZoLuDtLY07ZhAPQ9LL0kP06LyVHtYb9rKsOdoLNk+pxZ1IaexL2QU5uJdL7IkQVuNfWq/h3698/4qtyF3F32sC107JVEtthN1R3t3uTqt+h0NKTFcSSjrZFbqGlBAyCja+o5aLG25GlmvbbTVriFvgwGrXVeA/LntLVj3f8KsukxxwASzZ24G4dNA1+juMlkS62rJ7cCZkI/KV31owXXSG8W1S9ESIMYvQeauR7FQ8qwnIgxMkYKOlQJSFxryvnK8ayQXWN/vIBbWYgwkxJQ86HBIsl5xOUaKFvSrUE8NXHkqSjMYeaTD0lKxTDZjDjgLPKJWXU1/HfOBUT3URf61lnyEPBe8qVUorkMfM8ciZA+SbVn3PSndd2sFwnChAUER5Pudk4S3PElX6fNMyVYCeGFaBKeA0F6J8bRNeUU9vsNFMLPUkgNLCHNxBvIEG4jhpIbS7BQW6pgl8WNcMZSETO/RrBuANRhze/+OaJ/eCDwHSZb8yYXAB4OGUF5uQWlIYJCBsW9kQMeLn/+pHJZIYrEFTenCBt8pXcpnaeU77zAVIhs87BwM/eEust6godTH7c1bIfxNS+MJTCx33M+z9JsZgjjMspEQfgfdVqzhXDKi48/HzrcLZrKP8lOhcqgxFEN8At4vuLb2jjIiX2BMVPb2TRZnZikJiEKTMtndn7QqidQJXzPQtkFcZRz4RMsIubJQxOPxNHoSOHkfh7BQSeb4gWOaehCTSaGLPagDNj+7E+KhdkHFHKVcDeh3LUbiaKpOys1ySkhKMQnBGUU2yzYHhBxI7bggm1ImQC7XjjfJvmRc6sMkfDLO8/F+M9LSHjxEbm4mKEhVP9DyTSNNy+jRgPo
 ToF7bE4Q
 2NECx1teoX3dNhU35xN5DPhaguSUQZ++aLfqBkkHldbBSnZq1b3lrxyDx5qPAWNMdjKA0pGPNbqtc1DIhd34hRUP226xlKHdyRwv8aXLXnAjhYFD8mq4ZQYIMljJvUuCsC36bJmMcAnrmJ8NfmOifZt5mO+3jUwTrkFZO8npa76j0bnIJjo07CX45GQiSP0N+LfUW1u/lZuDzptv3joFb/G60Jrx63hoFC4JAXh3iFzu4Ch5xszUg2HglB0eo2Uk0HfldOFd+8thzyxnLror20nMkHC+d68v3kh0dCzx94P6bT+GHLWZCpOe8Rw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20. 10. 25, 10:54, Vlastimil Babka wrote:
>>> Most of them shouldn't be using get_free_pages() at all, they should be
>>> using kmalloc().
> 
> Changing to kmalloc() would have to be careful, what if the callers rely on
> doing e.g. get_page() later. It would however be useful to dintinguish "I
> want a page-sized buffer" (note that it's guaranteed to be aligned by
> kmalloc() these days, which it wasn't in 2015) from "I really want a page".
> But many of the latter cases maybe want a struct page then and are using
> alloc_pages()?

FTR, tty appears NOT to need any of the specialties, so k*alloc() 
conversion looks sensible to me... OK, I can re-revisit that and do the 
work, but give me some time :). (Which means 1/3 from this series won't 
be needed.)

thanks,
-- 
js
suse labs

