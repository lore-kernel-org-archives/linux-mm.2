Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 565C8606A323
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 19:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZjhVBDf7
Received: by kanga.kvack.org (Postfix)
	id 42D586B05B2; Thu, 26 Nov 2026 14:08:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDF56B05B3; Thu, 26 Nov 2026 14:08:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A5806B05B4; Thu, 26 Nov 2026 14:08:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B016A6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:08:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BDB0140561
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:08:56 +0000 (UTC)
X-FDA: 85478207472.16.BD4A03A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 73433C0008
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 19:08:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZjhVBDf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795720134;
	b=cEEIrjtEDZ0BZTXqTqvTkp/H0FTYVgV1KED4R28awrOOOLsPMtJbsGDs6vBM1rVwOhnStW
	69XiSYbti2raqNlS2+J3c98yl9LPS8PDanKa4akCZQVqhqYra6bI/hgvriC01mVZmGxRGT
	vL0D3MZFFEFYye4YU5OyrY6qV6hZoes=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795720134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gzDN1QG2r+ew53MNcYjRJsztIJ6bXJi3dv7JbJUryts=;
	b=b+us3WC1ILs54t7GjEfUhfYxS3LE+7zAOX5HOm1c+9PolkK1UdtW4j1YAlS1nz7wVrAe6T
	OToos2e63eRbpJDpaSGMIYhL3iZn5oeSKAPwiv+XWf8qj5JsjVDjy8l6fnQx42wxE8Y53T
	J2i+YG+Y07yL2V9DmBgZhtGHMC+C+sQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZjhVBDf7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A4FF43D9A;
	Thu, 26 Nov 2026 19:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DF91F000C0;
	Thu, 26 Nov 2026 19:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795720132;
	bh=gzDN1QG2r+ew53MNcYjRJsztIJ6bXJi3dv7JbJUryts=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZjhVBDf7i01xUwHDBDd6t5Dd9jfrgoOKt66dR9QNrrc7L0T0YpubcyqvMK0wbN/ia
	 N5atc2f24UBtRU0S+Od103hhN6aomFIo4lUV8NH7otae9s9CkrP1XNak7SusKsyuNi
	 JkL+MoY04YXrIsQU1zFKVFP9T3f4PE1zgUKcKB7/NL84/k+6u74vQKvJZyupKIEt0o
	 AZfV4KXHHyeCjiK2GYQNrImZuCoSUW/eVZRcsXIQFlsap0dkg8rCu7Ve55neanZp3M
	 VUneTvy83IDOxnbJ490HE8Lefc1MHbwcbYRzOzVKlpqtjxIzuSYB9j8bRAoC5SerdJ
	 hF+qL17Mb0c0Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Mike Rapoport
 <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <baoquan.he@linux.dev>,  Jonathan Corbet
 <corbet@lwn.net>,  Shuah Khan <skhan@linuxfoundation.org>,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  linux-doc@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  kernel-team@meta.com
Subject: Re: [PATCH 2/9] kho: Make bootmem reservations visible to fleet
 monitoring
In-Reply-To: <20261113003059.056dd036a6546756@chrisdown.name> (Chris Down's
	message of "Fri, 13 Nov 2026 00:30:59 -0800")
References: <cover.1794383544.git.chris@chrisdown.name>
	<c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
	<179443886218.2329176.10742245280418377061.b4-review@b4>
	<20261113003059.056dd036a6546756@chrisdown.name>
Date: Thu, 26 Nov 2026 19:08:48 +0000
Message-ID: <2vxz4id3wgu7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 73433C0008
X-Stat-Signature: o8bwpmbu5gc4zrz588aas6e6ky387cdo
X-Rspam-User:
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795720134-85958
X-HE-Meta: U2FsdGVkX1/VSivF9jHKcYApChuOdd92kseNP5w1d49+1FGt7AphyrX044TuQK2FL9xo4f2e/7zApw9aFA9dMzyQiZ+NDSDbYN0NObZNZzRcp+uNJse7IFb1SAf6tkzGQYMf1dC3yX0YzRRoKIMezL9KditFSSSZfhLW0pvHakh6E8DmJ69oYWho2N22IYPV+IcGdBfF46r0WVQrdqM4FggDtBz/9W8nxfCoCS6kDwwAVbLzGFpgkQWwwXZOjDwWxG6BlCqXCDZjzduzRyS9ru9uglpT1OxryQYtyeqIQu1KOVOxO86pRL3mnMTJjJl0FD5yagE0gY+pye2b8STWk889QdALKHLBLrHcXp6iI1ZGfrMUoe93NhJ/CHkC+/GJKnhGaiPWjIGn4OyGo4ErW/qQOzAVwxOFbW1UY0b3z0raUDMq5ns/RcROnGu1HOMuQxUtZQLRY1bA+TH5NMGpO3jPDAakycKG9pcZls4gnNn1/pDkgFDHa0sUklpBnKkowGv2tSTzUqac09ycN91YeVyW7NXp0M8PPEFZ56yUiMbiSvbU0B2nPKOrczbJMDLqFMVrZTpuauQuDNyabhXX1iPcHhTy13hHIZrlIzdo3Yqho7K8sNSNIfzpV1jPMUC6caDRimgMjvscw8/z3mWTxv9esTiL/6zwX/5TObRlBvajZXNDfOlR4m5fpgr9203RodZZfdOpWS54ETpdFRHstrZj/nwLASFOAP+S/v6ZIHeSsmDjPHbMWvJ8MTdwOU2c7BULIrop7LDzPePJasnLPcgYaMgmWqTMqPIS3VJax0Vizl/szAHYXzT7oxPMbUHhJkzKrccXotMVu4HxaQIuX2EuJiCeDqyl9JJQQ/nY1vL76n7uDqU7qCuTJ2V2jX6hD5t4n0NKfyq124xy485F9J/bKveeXwnpDOtlRF0tBKjU612EzZmdTlH7r8H/QTJhnfdRPE1qKCPSmi4CnGm
 PXdRAoi9
 yBJNre9bA/U9H32S0nYbZ/vccsRlshq6UcWEYGCFJnrntrlTy1pyxuQHDsdzkVFkrCQAztv2IOoOB0a9f4EPqMz5tdsnBve1Uw8xw9TRakYm2/yjiLJQGr/ysv2C/vTSVQGzfctHhLy6FM0sLadcXaVe5HQwvv4N4wX80K7hCU/6pPA9IHg7sVFWi13ZzOByW0bjRhOc5xFcW3O/kdiC6PJ/J0C/XjJtRQ5hBSedjky9RsVsVuzQpABWgbRw+gS9IE8jKvQ3piqdQOI1qggg3z0LgrG697F1gfuUbSocja3dySXnE38yzM1YNX03I5KTWUwVEL29KCgWK/mfpecYskRUGATIaA+5QqAEFoePINsh7K/u6qQvJZIu5aYy81Zn/zPhCSfEpR65Wll5x8ItbLC9URS64QPfzhc+2eBJFM1MD5hC/Xt2YBSKBbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13 2026, Chris Down wrote:
> Pasha Tatashin writes:
[...]
>>> Today the collector would have to sum kho/out/bootmem_len in debugfs,
>>> which isn't a userspace ABI. In /proc/meminfo, free bootmem contributes
>>> to CmaFree, but the reservation doesn't contribute to CmaTotal. The cma
>>
>>Is this a different bug?
>
> I think so, yes. Bootmem pageblocks are MIGRATE_CMA, so their free pages are
> counted in NR_FREE_CMA_PAGES, but totalcma_pages only counts the areas that
> mm/cma.c knows about.
>
> zone->cma_pages is a separate problem. It only gets bootmem added by
> init_cma_reserved_pageblock() in kho_init(), and on a KHO boot we return before
> we get there.
>
> I can send patches for those separately if you agree that bootmem should be
> counted in both. It wouldn't give us the bootmem size though, because CmaTotal
> would still include any other CMA areas.

I have a internal bug assigned to me to fix this. It would be great if
you could fix it for me. I'd owe you a beer ;-)

On cold boot it is pretty easy. Call cma_init_reserved_mem() on each
bootmem region.

On a KHO boot it gets tricky. Not all of bootmem is CMA, since some of
it is given out to early boot allocators like memmap. So we need to
count the pageblocks that we mark as MIGRATE_CMA during MM init. And
then update totalcma_pages directly, which already sounds kinda iffy.

Plugging the accounting directly into kho_bootmem_migratetype() might
work, but I don't like giving it a side effect. Maybe we do it directly
in pageblock_migratetype_init_range() and __init_deferred_page()?

None of it is super elegant and I never got around to figuring out
something good.

>
>>I have some concerns about exposing this as a stable API. What if we get
>>rid of bootmem or make it resizable? We only recently renamed it from
>>scratch to bootmem, and we have been exploring for way to optimize it.
>>
>>I would keep this exposed under /sys/kernel/debug/kho/bootmem_size for
>>now, and not worry about it being stable.
>
> That's fair. I'll move it to /sys/kernel/debug/kho/bootmem_size in v2, and we
> can look at sysfs again once bootmem has settled down.

Is it really that hard for your collector to sum up the areas. I don't
mind this change since it is in debugfs and very simple, but I'm curious
if you really need it.

[...]

-- 
Regards,
Pratyush Yadav

