Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86B5C5B56A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 17:20:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBB846B007B; Mon, 10 Aug 2026 13:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C9F6B008A; Mon, 10 Aug 2026 13:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D82486B008C; Mon, 10 Aug 2026 13:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B652B6B007B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:20:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 47F29A1B1C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:20:40 +0000 (UTC)
X-FDA: 85086024240.06.0C26BB6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1F6B514000C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 17:20:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yHDWZ4xX;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786382438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWx0toGzjy2ZbdJGqHeiMNuTjd9QpxmERukNiIPTFMA=;
	b=heigAKeyVZAzWcyYdtZDtfjUQCtquNEHlFj+WGLCK/dzDqHjqirxDuTwedkYKG4y8/2mDV
	q5veV8u3XfdJd1YTbSk/cm9t1Gx7E6Isfv2WVvuLlBUHwRT3wZIL2Re1qnqbYBxKDnPXBq
	UJIUwokPeSZYvzzx6+HXJuxTgW55xEI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=yHDWZ4xX;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786382438;
	b=alr7BFT6Hv+GyJm18p+0eya6fie485kPEp33lmr4vhoap8QUy8XbNByYnQKjuUWp/n/9+U
	dDQa48PbfOhSd/EaqS4hR5+3ev9fscKpx0s+Fk7Z8ra+R97agHKdaLBUW98NRkZnkv/+qR
	mbA+5OzqHzvTVPxzx9oa471v5oUuPS0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77B7743313;
	Mon, 10 Aug 2026 17:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCAC1F000E9;
	Mon, 10 Aug 2026 17:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786382436;
	bh=fWx0toGzjy2ZbdJGqHeiMNuTjd9QpxmERukNiIPTFMA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=yHDWZ4xXBKoArGvbqzbMAA/tNo0o9COtH41cg8cn6woKudtLFzs/P+97G9pzHxCQ7
	 B2WM790UiMC9K5I/iXFP83/r0QS3unyXVPY/+gV1pQv2mvRD+2Y1ReTawhoG/hMpOF
	 +4a7T6zYWszbe4BK5D2PgAWcVEmP/PwXTwYN3Uho=
Date: Mon, 10 Aug 2026 10:20:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins
 <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu
 <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed
 <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/3] mm, swap: don't spin or flood the console on a bad
 swap entry
Message-Id: <20260810102034.547699380bbe7aeb232344a9@linux-foundation.org>
In-Reply-To: <20260810-swap-v1-0-375ef0767206@debian.org>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: fa35jo1raozfoncr5pzx448cgxhj8quq
X-Rspamd-Queue-Id: 1F6B514000C
X-HE-Tag: 1786382437-912555
X-HE-Meta: U2FsdGVkX19r5zCy4ZEezzO6KXWWN99dwB5iojc1t2R0OCI44vvt1nLfD1NJLrMi7Fm5bU2z4UDn1759hjYQmQ4v8vsGFHXaMMrxNoOeBdpvOMCDOkJNoF/Z+Uztj2JiFVgFLE0l73P9MVDbJCybwvwYXns84OLemeOJwKAtKsHaDnIgApcR6ENCGXjgLZsRsQmd/q6UZP31ZCXMU0pHg0f6ltBkg+Q8sHrs95VHdhQNDtbqrZkhHgUpaFJGlFj2eTOnbjL3StW3KS7B/4ieWnB+llagNv04vYMzxrLaTLH+WCxXGhchZofilCr5vdQldbGjNIev/LB0bnlYAryuDoeT9oZCwx0zP7amYoDO83/Vjp9JKTKWHZHLLh6mPpEwAhK1fJ7amX3m951gpi5qWap8UHGZx3kX68eFCJjQ/bzePsHAO+4rUb8V72im7to0lO70IidIKHJ+kpVOV+qKVKbwecZZbjheV1iNb37ArvcwKRmNF/YGthFV5PcVHXavBGQi64MxKiIajIKfGhFWFr0iJZCMRQdlmtKa8vJ9c6f0zEXrycvrdv0IhyEpMD1DZK8SuFT23BYgFIYMhRJEm6YKf0OjN3R5eRrARnn2KpUBnky8bp9ElLSGb6jZk2QSZKvNLuUCPIVX4VhVWbzqgGHVSJ/Jakv9MXGWSP9TNsWkSOF+SBBV59KZgC0NXlgfKlJeoNbdq5rU/qp3biL1zO30XMqbaZK+YzYtWtFJGBXVqbYZS21Pf+N4pb66ri/4VCH8gJ+61OKzZeoUPM3dS/Mp3XPKt64+sGJWCDZovOy8cyW4MRo1uB4S2l2SHgA1uUAmolcK9SHjDn+/nBPphz+oE1x195IIWUjbAmUJ2TSy+6iGkCHiDyYocbTYCHoWNQd6FZwbGzSRkanKKYRSeK2Omzp341VfzCk5an1RU+N4Ekbbu4vEs785/UWFys52HIUJQ3InxjzHkEJkjsC
 tO8C8wjJ
 z+36be1xnyqzaRoL5j6sxdTQW26VbhWZCFBFdZwl2gwITZDb9fnLJXWFVnqJ/yRA4nTnH11gxjnXK0nIzZBiogvrSFQiuGH5zUmd6tZ4oueEhC4ItQARLYGkM5N0MLeshinmxZeDFVeFLEiWKargS48nL0bhkuzqj3exABH2lmJuULbFjq535JHBt+k6RghrwNPC13KcX3Om+rvy0kCdkismEKZf7d4+5/4kAyBeQxZ7+3UJ5PWzydDglvEf48x3EKroFG9y7XI0pTrzxZA5KUOI7MP2+S9btUes2mEwiDT4GpAzkwAjkABkcg2aEOXtrvj2H2EZuRrVJCOP3vfOFjA67Fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 09:26:48 -0700 Breno Leitao <leitao@debian.org> wrote:

> I've seen some machines at Meta flete that show the following type of
> problem:
> 
> 1) It gets some weird warning:
> 
>   BUG: Bad page map in process khugepaged  pte:f000eef300000017 pmd:00000067
>   addr:00007f57c0a01000 vm_flags:20200073 anon_vma:ffff88829af7c340 mapping:0000000000000000 index:7f57c0a01
> 
> The corruption is most likely the collapse/PT_RECLAIM race fixed by
> commit 366a4532d96f ("mm: fix the race between collapse and PT_RECLAIM
> under per-vma lock"). But this series is not about tha.
> 
> 2) Then it floods all the monitoring of the fleet, sending the same
>    message in the loop, crashing the our fleet kernel monitoring
>    subsystem (which is the part that I am interested in protecting)
> 
>   get_swap_device: Bad swap offset entry 3ffffffc043c5
> 
> For instance, in a host today it logged 6M in a few hours, and it is still
> going forever. Two things go wrong.
> 
> 1) get_swap_device() prints unconditionally, unlike print_bad_pte() next
>    door which suppresses itself with is_bad_page_map_ratelimited().
> 
> 1) do_swap_page() returns 0 when get_swap_device() fails, so the
>    fault is retried, reads the same entry and faults again.
>    Nothing in the round trip changes the PTE.
> 
> Trying to fix it in a naive way:

Thanks.  Sashiko said a bunch of things, all pre-existing.
	https://sashiko.dev/#/patchset/20260810-swap-v1-0-375ef0767206@debian.org

You might wat to address the first one as it's on-topic for this
patchset.  Ther are some swap things.  The remainder are for the poor
uffd maintainers to scratch at, if inclined.


