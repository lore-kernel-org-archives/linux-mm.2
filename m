Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ADB3C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 10:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09D206B0005; Sat, 11 Jul 2026 06:24:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 026BB6B0088; Sat, 11 Jul 2026 06:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E309F6B008A; Sat, 11 Jul 2026 06:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB45E6B0005
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 06:24:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 484BC14069C
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:24:07 +0000 (UTC)
X-FDA: 84976110534.05.9650799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A2FEFA000F
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 10:24:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFQ3gLCG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783765445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0oDfAhKxe2iIPvXBwZ8w8OqX8bhaAtUgCdeCLElZr0U=;
	b=ZgD0jc+7rNpwYjLQGxE7PiTeM9JD71Z+X41Z9O8koyffTTGmGjvQIJNvNX+J5Sbxa15RQq
	DOHNgkbIs/BtJWxstiiiBa248C/Cgjqi9PFMYVa/Z86SDD59DBLjNurIVVr8j1QIuR4hnf
	lkkM8JTrTtpOKrtkE3qG2zRoYt9BiN4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFQ3gLCG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783765445;
	b=Vwkk9PhawOI2JSZmo45ZAEB6Z4Y90spiaza4qiU72YSl6JhScNS+41XzihTHvSSDJomSz5
	veKKwQhvjc1uJUo+ZaKseSrxsLUoSqRQs51cf3Lzybi6N/I2Ou9hXJGn9a1UhI65iRN32J
	YCIFBwYia6Nn6yNj83Ut3LmZqFJ0xns=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EAA440103;
	Sat, 11 Jul 2026 10:24:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4901F000E9;
	Sat, 11 Jul 2026 10:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783765444;
	bh=0oDfAhKxe2iIPvXBwZ8w8OqX8bhaAtUgCdeCLElZr0U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AFQ3gLCG2F8EzmcbnFgC7gXQ7+rlVe/CyFvWTelU67y/+n/6aQbX1XOkmykw9tUPE
	 /P6+6BOidbH5gVI5CZO/bLXo4usru/OohXH8TOztGB9Udw8iDDo+Xllxib24tFY0ai
	 KphhFdvjtDOeXDxc5dCTXugSF0bSqxKlqRtyJn1svzNNlgc55jvSdlVUsVFTVlXTiT
	 uNdRAFdU9OOiUI5/b7/bNe7XjHBaQ/QR5BW6pvhYuYZWXWIPke/bHWwwzbzW8WS442
	 r8u5zEzFk3ZH/Chl213qDo0W4krI6Ew6mEcQuxNV+fma+WognwtqI8K7B7RyyHR9Vj
	 Dq8zG9EMFIhhw==
Date: Sat, 11 Jul 2026 13:23:54 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Toshi Kani <toshi.kani@hpe.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, David Carlier <devnexen@gmail.com>,
	Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org,
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH 1/2] mm/vmalloc: acquire init_mm read lock on huge vmap
 promotion
Message-ID: <alIZugA2b2gnPOrp@kernel.org>
References: <20260710-series-vmap-race-fix-v1-0-5b3794c113fe@kernel.org>
 <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-series-vmap-race-fix-v1-1-5b3794c113fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A2FEFA000F
X-Stat-Signature: a9owo456hrsmcc6w3pip319a3xice1mu
X-HE-Tag: 1783765445-613013
X-HE-Meta: U2FsdGVkX196tpYdKURPlqiGRY38KTL6Oz1yOtkchtwhvtZy3rpKSy4yqo/ae4eMFhVcBadBwPxbzMTS/DxylHLlkZ+ae9dJEOSgBBoV9s0/a93GCHO/2zSRuTWd8tbry+xvZN6c6fcLTeNJnuBeQsPu27X0GzlLlXq7cYgiD+2iLh60qgs/GFCMGWXrVz9BeuhXJunvJ0MI0sm0+abEkKQF3ocaGVt0Dq+AChJ6ON0S46de+9JLvxNm7I4t2WfmGQQdd6gmzuJ3N0vhEcvOVjDDM33OeynEX0H0vbiU1mIjXvN6vL0KVQVxsVrNZ6lsINpDceWzP5l8hPUng0ZB8srKeq7EY76nK94q5bahOw86q2pCsaZLUGKBu6Z185zjSdSKxe3M6wmnHzirI4rBjWkW3n/0yWIqH4yeP4NKId45e1XFNcwF2xwhEXRle4W4eKw4VQIs2c1uu1W+9FLgqzyhf85gT+5kX6D53QEqYUr08j+fD2/zZYF2wBS8B8f80bnAcgAkv3VtBu7ydBxZBnyQ9ZC313/7JSXeptEkj+ghjLE6OFBq8+xeZjrhpcyMjl7bwt0GFwK1zXFDD9KhUKaOqqlFZBXTcpTTHOBy7VNcFZ894mI9btNtmQzGwHlsmcS0HlWTL9xkGrxG6p2VVfRyvbwBJLZOUyCOl8hvjSo8X9HqpBE5NR6tOx2RC3jqav9J5sMySTG8Gt0nNSgLHMax4mBeIOdHwNQ57L37pNHa7nHBx4GKZ8c+OxsBoArlwsrLSKM2tPRNhYEhGKALFheik+dCaOrzlJYaHbPooKoLh6Nj+UCOloE2LfXBVNxARzFdX8kBbuUbEZt3fhAwqw2pQvaPR1t3Wl5hB79BKWMMuDpK4vY9OxUa+hxCp5S1B8nmTV7LHK6akFPA/4pr6BrFybBCj+cCoMjq1wqo6vNZhItifq2C2CLbP/5jJ2aF21mSINAxPCm3w/rrDYo
 eUPXYCoU
 IN964A6oHim1FqjSki3YNKlHvEvM5ePpLtmhzc92YyzrJvk+GqyhpuV4V1Gd6PPpsjJZDgKpccTk2pwwst8xeWee07HRdleNBJDYg5X0MWDcdb6dbgxmBbj6m3cnM50kpNdiv9VzmDoKOV7E95I1A2hbZXCyHyJDMGOXBpgB+u1ha6xBrJBBjgFFDKFKaYvcvvc9UpK9C+zPRnvcpER8QdMPGsRwEnqfTuIWQr4oUVFTbd3VP0+7P/gCIuru4oF2l5WIZzambvDwSgNg7211aLW4vfbJWm10iFPFW2dsAZYJoYpzA+oWrViPmOnBWlpYs/qDVre7QhG6KKavwbtaYDIAE2y090a4Nr/RP6XFnB2vc0jx5+zIo6jiHiJh3bw7DPoA6WQM16LTxmD5V6xhVbUulyKGrr7iMbMcy0PSwG+Kmq9aAEPn4qmz7/lOtyleWa0NnWZMLgRhPIUZpQHFqQy1NnueM8+YQ4z0OkBxCrAEsLyYVa0+QOdxUdgyMlwLfDk/e++asaw75CchgjRzlIB5luEISfPZyTmBARPZcrG0OtqHStRf0KSgT9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 11:49:18AM +0100, Lorenzo Stoakes wrote:
> Currently there is a nasty race between ptdump and vmap when attempting to
> map a huge P4D, PMD or PUD entry.
>
> This patch resolves the issue by simply having
> vmap_try_huge_[p4d,pud,pmd]() hold the mmap read lock on init_mm while
> invoking [p4d,pud,pmd]_free_[pud,pmd,pte]_page() and
> [p4d,pud,pmd]_set_huge().
> 
> Fixes: b6bdb7517c3d ("mm/vmalloc: add interfaces to free unmapped page table")
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> Link: https://lore.kernel.org/linux-mm/20260706203128.162335-1-devnexen@gmail.com/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmap_lock.h |  1 +
>  mm/pagewalk.c             | 22 +++++++++++----------
>  mm/vmalloc.c              | 50 ++++++++++++++++++++++++++++++++++++++---------
>  3 files changed, 54 insertions(+), 19 deletions(-)

-- 
Sincerely yours,
Mike.

