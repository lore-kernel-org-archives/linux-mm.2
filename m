Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5C8CC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 21:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54CA36B007B; Fri,  1 Aug 2025 17:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FDD46B0089; Fri,  1 Aug 2025 17:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EC656B008A; Fri,  1 Aug 2025 17:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 288516B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 17:56:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91E3357A86
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:56:30 +0000 (UTC)
X-FDA: 83729548140.11.C7B2CA7
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf02.hostedemail.com (Postfix) with ESMTP id EAF8580002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 21:56:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=euBIlkv0;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754085389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lehJ7WvB8+fbyIuHAvieJNcmlOiT3BvlOrCe8CI4lnw=;
	b=rk3mYwstqw8mBQTlciGa4wBQgkdd224SmaVtaNYDsr2WUtRYQR96mXqLOHc7qMSB8JpgLo
	t6puT6EchksLn5LvXqYSsGkI4QSj20E7jrBcFdZ6oUj0j1SsqI63IzDmz4FLjufv6nbRjo
	u1iAwrM8N0rzfS1IplCVZORjf6I1ihE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=euBIlkv0;
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754085389; a=rsa-sha256;
	cv=none;
	b=Dy8QJwTC/eY8Lpmw8rC6kaGb02jvohWonug5XZqK3dfET/NN1dseO0buezKeQIh0H9foT3
	39EoXriNWWk1HPJ61KZtHxs9IH6zJh57xV1k+4U/F5i85uVIU29JHX4zGpYLdxKELAMabc
	Kr3ZZm2ElNpsjPvBl6Ng6Il+T3c0tcA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id D6D065C59D3;
	Fri,  1 Aug 2025 21:56:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411E7C4CEE7;
	Fri,  1 Aug 2025 21:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754085387;
	bh=7hEZjfVHsVFrCWk4VRJ0IR8tJXn2+S/PfLITW43SYfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=euBIlkv0O+49/YsuKNYZBMRVQ5nW8mZou3U+SHI2LFeLzs74k9Pu4KIMN0Fn/Vd1f
	 tkHnrJ756TQEXEAoos4csrWq8spYPKhskireuQAG3WPALynJNk3lX7GhYeeGQtR+gv
	 kfLQTweVz/J32yG0AqFIno461ivEeh6awd5VoKzgkB37/55e24576Ptq7y+as1ZdHB
	 LGT/OIBMbhMs0HRfbp+yzRKCnIr71XPEnkYPgnMkuoseCkkFTU1vwTHYWcEZsFRv92
	 sgXBr1hB+Kjou+IhLu5KMsxHH+19CnAme/c+7Vw8JFkOJRBM3sjcoJMaGcqcnUwzes
	 ZqOVvM9kzm49g==
Date: Fri, 1 Aug 2025 17:56:25 -0400
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, surenb@google.com, aarcange@redhat.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/userfaultfd: fix kmap_local LIFO ordering for
 CONFIG_HIGHPTE
Message-ID: <aI04CQZZzgCDO2A5@lappy>
References: <20250731144431.773923-1-sashal@kernel.org>
 <20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250801141101.9f3555a172609cb64fde7f71@linux-foundation.org>
X-Stat-Signature: 7dtbnj5qeu8danps389651n7jdb7bg61
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EAF8580002
X-Rspam-User: 
X-HE-Tag: 1754085388-909285
X-HE-Meta: U2FsdGVkX1/r3WovDpBYiiatT3W3jMCTmNeackUV+IeyM/SJ/2kdLx8SylABkgAbvkck1S3OILmryrjfg56nO043428xVEpzHPSlH3Ha/kBP7ePS7dxqF/fRkGHLRFiQUe6ItkU082temMBs4cI0fGxBk4Wh6q5UwXB9JGoGXbHAdGJYM1blkRtx9IHlWmVWQjGaLVJNAD/X2berwJ6P/i/G9hka2DgI7SMez5IzmjoPKZIPZIk8eypq2XZP6nwTeqWjaKsgpDPUGYLvTZ+3FISbzuf9JuK/L1JVI7c7AfpMkFg0aVYFzWk3QBaMPGpO2X1tay9QHVCX1oQ+wo1U2tqVvzDKlUBl4ZhkJniomy7S7mIhY2H1DzMY1cxefTu6LPAw8Z6WESHyfkQZGOehYziVw7BWoG5iOEwNHN6sHEoxl3iuEp5/5feVAw4sCNcdakJcaSxCr85biaYArR36uuBzIgD3QqB5NiMUpqKr5JP4qjRw5UmHkoNV8SB8ktfYuyOVCz7Qvu9RTK3ITGHQ2vvP70/c/pE6o2YNyBvr87mJmqsNz82a4/ruByqkVa4AomUCXq0w0eYeRjdggOvPoBhV+d2Yx2CFWRUG/i09eLMo62ICBT+GfC8oTU+V/zRANDB34CyWvyRBddn2uzXhgm3qqVz6386Nz2Lh45UB0UaLh3LbrveDYHCG+bns67UvC/XADhuzjHYbOnc+zV7B2F63CPS+HuC/L7/fbIlkzCyJI4jO9FHLvGQd1Ce8QGSo/ilxjy1T2xULK6S+SzgcaLUTZ9zRNawhIYDgLOdPmEMGHnmDS3v3O4RGtWRG4Q9ed02kTN1uo2dVKpkSsT6vkOJ9V2dEWwe6yhY9DZWapRvU4DTckgkSZ7BZGAIn0yJOIA4XNJSwESve0U3yoBWYbN+tGoAvYJJGR4GgLouP5Xe6jZtzBLcFjFuHVCY6TuO7EyDLLmKNpE/x5eCPmfu
 ZZkpDguM
 yFUOxcHZC68K9gZlR5RDEfceSlF2ja3arcLXLQJKt1cADz+9tDtjfW9ma2jbXRRlrlh+6MYMtWU/A2F4pHEHVWdVGJf1w4OTtLT8J+HPYhP4zcb3JsMWfwYUfBY5S0xr9cfRju0sxlAW4YuVJXzTGG0KueXxERjubOv/DMok4nO5arJNpqwYdegEHKv84VxeqyAVqVXrIMlK75e/m7XLtZEjiKlQ29i0OeTvdxFptZ2sxIlsL5lw1MWJsmHuxdvoZthk4VlynKht957w6skJZDJ1RuPYB9Lk+0vxNcIVyId5AuDvnaaCf1a18ZMzsZL6MIutpQnz1Cd+/YYLaOFg0n+OP1IyrrgeWXqvyIJr23Jry0rUta8TLF0rI0KZ3UOel1DKUoCdRNKBt7eu1LtuI2E1wbiSDzvD5KEW2spkTLp5X2/Mye2LtlKBhNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 02:11:01PM -0700, Andrew Morton wrote:
>On Thu, 31 Jul 2025 10:44:31 -0400 Sasha Levin <sashal@kernel.org> wrote:
>
>> With CONFIG_HIGHPTE on 32-bit ARM, move_pages_pte() maps PTE pages using
>> kmap_local_page(), which requires unmapping in Last-In-First-Out order.
>>
>> The current code maps dst_pte first, then src_pte, but unmaps them in
>> the same order (dst_pte, src_pte), violating the LIFO requirement.
>> This causes the warning in kunmap_local_indexed():
>>
>>   WARNING: CPU: 0 PID: 604 at mm/highmem.c:622 kunmap_local_indexed+0x178/0x17c
>>   addr \!= __fix_to_virt(FIX_KMAP_BEGIN + idx)
>>
>> Fix this by reversing the unmap order to respect LIFO ordering.
>>
>> This issue follows the same pattern as similar fixes:
>> - commit eca6828403b8 ("crypto: skcipher - fix mismatch between mapping and unmapping order")
>> - commit 8cf57c6df818 ("nilfs2: eliminate staggered calls to kunmap in nilfs_rename")
>>
>> Both of which addressed the same fundamental requirement that kmap_local
>> operations must follow LIFO ordering.
>>
>> Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
>> Co-developed-by: Claude claude-opus-4-20250514
>
>Well this is innovative.  I doubt if Co-developed-by: is appropriate
>for this (where's Claude's Signed-off-by:?)

Claude (or any other AI) can't legally sign off on code :)

>I'd support creating a new changelog tag for this case.

This is in the context of a proposal on workflows@:
https://lore.kernel.org/workflows/20250728105634.GF787@pendragon.ideasonboard.com/T/#t

The Co-developed-by: usage wasn't my proposal, but it looked like the
majority of folks were okay with it.

Input is definitely welcome!

>And really, if AI was recruited in developing a kernel patch, it would
>be helpful if the changelog were to have a paragraph describing just
>how the AI assist was used.  At least, until everyone knows all about
>this?  You probably already have a presentation or a web page, so
>adding a link to that would suffice, thanks.

Kees actually has a good writeup about his experience with AI tooling
here: https://hachyderm.io/@kees/114907228284590439 , my experience is
fairly similar.

Kees logged his prompts as part of the patch he sent in
(https://lore.kernel.org/lkml/20250724080756.work.741-kees@kernel.org/)
which was interesting, but I didn't see much value in doing that beyond
the demo purposes as this is not really reproducible.

-- 
Thanks,
Sasha

