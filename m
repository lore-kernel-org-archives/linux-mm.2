Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA77103E189
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 14:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3686B0205; Wed, 18 Mar 2026 10:07:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D63FF6B0206; Wed, 18 Mar 2026 10:07:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A096B0207; Wed, 18 Mar 2026 10:07:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B63496B0205
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:07:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1A8B95AF16
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:07:32 +0000 (UTC)
X-FDA: 84559361544.12.AF80C83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 48D1018000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:07:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cElEuW4+;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773842850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVHDZBr9hRtukhJKZKkZ5lH+CodUuhgR2zQoP0qbSqE=;
	b=hJAv4gUPCd3e4xE54GqCskKgWfisHUyXh3XGonztUSnY3vBbF0ODpxdujtuU2RhZPZOHtU
	jR3VkqNwCLG6TQ1SO0wVbVj1DiIEqsV69o6gLTp1sF1YeNMrOFhullvayM6x8mIYNRvkXK
	PN2tETrJiQhJQx0gf1f+wMti/bjWz7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773842850; a=rsa-sha256;
	cv=none;
	b=k+Oeqy00ATPPd/nCMU6+9B6VU3ZiHty/F6j3tlqCusbyJq8LRSiODIAAk/TzuTlyVRhIqN
	b7u9V+gCuxQq+HhKjed39Gy9JgWYT6E3M00jWrOjcaAssOJZMgHwzOkZJs9vRYgwAODRMC
	HyZpDAbyDmXeRvMzoSaaG0JWBOAkqn4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cElEuW4+;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 275A040666;
	Wed, 18 Mar 2026 14:07:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F52BC19421;
	Wed, 18 Mar 2026 14:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773842849;
	bh=xVHDZBr9hRtukhJKZKkZ5lH+CodUuhgR2zQoP0qbSqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cElEuW4+7dWuaxLa6Layls2/T9Q21hZCwYzYQ27lJ0YjRECmtbrVksBvHzDT43Gwd
	 XbYervVZhjNtmK7Rsbry2j8LQSPx5iLc49eeyp4d23yXx8r9z5Yq5DmtNzkT9t8a6w
	 ECOrnpuVYZW6faoUuypDUzdjZKo39P/xJV+Gf9RkbzpV8mDR0bG5EHKAIX6XJaSQ8d
	 ZT/pQFIpNxODSEG8tbZWtzS7kCDG++N0AbvYGaiwkEyjH+1Xvsj54VFqu7jnlc6iH8
	 MIL9NIP5ZunVNMLdR/LDwoI1j/epe3UUt5Tf8al7F7tvtnt6Opnxjj7tim7hvKfSj2
	 Rx4roRERrJvdg==
Date: Wed, 18 Mar 2026 14:07:23 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "Boone, Max" <mboone@akamai.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm/pagewalk: fix race between concurrent split and
 refault
Message-ID: <5765d71e-70e4-401a-9b6e-e20ec42b2de3@lucifer.local>
References: <20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3@akamai.com>
 <7ded426a-0cb5-437b-9634-8d806b704db6@lucifer.local>
 <719CB417-F511-402A-91E3-8A696ABCE0D5@akamai.com>
 <E9058409-F4D6-4146-9366-17E87FAC9812@akamai.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E9058409-F4D6-4146-9366-17E87FAC9812@akamai.com>
X-Stat-Signature: ucr55yw17jrm4bp5ph5y9bkia3hjir6w
X-Rspam-User: 
X-Rspamd-Queue-Id: 48D1018000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1773842850-457194
X-HE-Meta: U2FsdGVkX1/N4g5s3eorn/bjujF/mm5y4CKvWpmO9gagz+0EIWgqMNqCYihtpxH2HvNsYV2UwhvJQt5TLl866+RuvhFdR7fNCM3qI60RAbJtnhv/eBUr1u8UGpxCV0rj/X19Nq6ZbXHLO7utAuRCIPXsdC9eo8obSmn2nFnb0l7Dl80sN38qe97nxK7o68hDxgvJZGtDBXHFjZ3VBA3ynNi5omn35+FUMTY4iZRZ1xpNpDoPoLukFezh4Y1BgWuI4rJpSebANlvtWtMVkd2x80vyny1D0dF7/zGqIsHQ/BGTIs8XnfdmsJGo7MLQY18WnpYR56V0KvSSaqELPKP2Hpv6JPvhAJE42bnK+aI8B/wzqNWy6GkZTLfXiWV1uKNYfpPiFtepAS+yC0NbVEQrUGtZhN9LgQIMjVvTDjhZAuYukWXydPlUFLITNILVdiXEkqavX2J5wXmjPmhJsQA7Sf+Lec66I0UdKwFXoFh+nPv4np5vV6hIMsmOnFV30FQq5d82xpf4mFEOKv1ct1kJ9ST+qn7+2qROxJesMUeZAjIBzwiBXFKrwOdGXZv0yAwUF8wOYBwV135woZkQGREDd3F1gD8gcsIBezuTGrMCBI8vZ8nrLyhiB5I0yFDR8JVB6PhHOC1qkailJTi7L2o9j4L0BNCcC6Wea4G8mYHlSJRTp8XWGFu9kRhDiKORyqrG8I7jNzVCKg1JUhvVICXxGx/e42MhLH959a8B2NllhgRUcQeoyBwxs8r4ZATNNICu7nOpjzp5I8ZY3LDCifRheYkEfNb9rtiN/GazXpoWB3TES6Tyjp20CNiX4Xn9z/kOAJ7Z3ZHH7Kqv1Pnz4B4fP0oQesBraipjWryQqZ9sfwLd38vIflerXbg/EMiEf36G924u1Xfqkr3rvU8/kx1mZnWqtYtG5iGpD0BZ8AvtXcZdM2HEDAlFlmpY3z43wh1E/WvbdVp+UlGOSp0HuL/
 KXVNh5ao
 1Lhi48+/jO157DI9MyEZXZl3JKd6B2s2hju1ZSbgP8m5RoxITbzKgTT6wIjqwuo7vZcaLqWOITY6W4Y2PluGoYW6KQYrO9PwHvQEuf6CeLni0ewjjraqVRay5rPj+bmF5O0brzZg3RWH9pDtc3JXVFHdGuxHDRpd1LQBop3rtN7VnajWqvdreQHom7G1ZxxTml8kZlrP7/Z/gpxtrxFoWyL+G/ouckoz1WaC7ZjuaONXbWOzAQ0jP6hnM2gBi+DLJ/504Ntwlyx4demSIQsRqiQWI72u+bTvcrqw6VYs+e1KqQ4vZlFqZTrGQljnPQyXAlZcbnuYpaFhVBz41SIvHL8P0+2GljjO5si02fBtE39x2jEtzL8zTR8FnGz7FyvE41MIr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:27:33PM +0000, Boone, Max wrote:
>
>
> > On Mar 18, 2026, at 2:08 PM, Max Boone <mboone@akamai.com> wrote:
> >>
> >> Yikes, really? :) This is from 2017, I'm a little surprised we didn't hit
> >> this bug until now.
> >>
> >> Has something changed more recently that made it more likely to hit? Or is
> >> it one of those 'needed people to have more RAM first' or bigger PCI BAR's?
>
> Forgot to mention, but yeah, we’re seeing this on Blackwell cards which have very
> large BARs, so probably seeing it first because of that. But the window was already
> pretty small, it’s not a very logical thing to poll numa_maps or smaps walks while the
> firmware of a VM is remapping the BARs of a GPU. With regards to that specific case
> there’s a proxmox thread and mail from the same person presumably [1, 2] that mentions
> the same bug.

No question we should take this fix, the page walk code is the right place to
check for this as we are not safe assuming the PUD entry can't change.

>
> [1] https://forum.proxmox.com/threads/walk_pgd_range-crash-pve9-1-on-6-18.179895/
> [2] https://lore.kernel.org/all/5948f3a6-8f30-4c45-9b86-2af9a6b37405@kernel.org/

Cheers, Lorenzo

