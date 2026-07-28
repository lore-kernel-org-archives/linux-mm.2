Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26867C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:37:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE3506B0096; Tue, 28 Jul 2026 09:37:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D94336B0098; Tue, 28 Jul 2026 09:37:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0DD6B0099; Tue, 28 Jul 2026 09:37:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9FCBC6B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:37:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 33CA0A0882
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:37:25 +0000 (UTC)
X-FDA: 85038287250.13.C52FBE1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 80DAA140008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:37:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zgig0qhU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785245843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KB/07Tb0FpiBzqRpvRWCeOJ77m9l+yyrAJxlJVmVIDw=;
	b=mOHQV33BNs3g3mcz7CAvVyj5n286QrVT2zWFVBqjxHC778gLLZWJkDDdX55TBSdCaaapZr
	sFx4C8BpJCwjZILtQ03vwvzclKsJvAYd1O6/KiedP6hWOR4wY4morQoezZmKp7hs2UL0oS
	tFTpoIMXt9LtyS4O46fbQ+Lra+fvz5E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785245843;
	b=28EDFR/KifdQX20J/qrZSkD1kGFqyYEW1wP6vPAt/PyxaSZE5rLL48Fmz6BuYUB3v1plPA
	Ji8DoLy/dYJGvNXMA4PDgfC0ATV7deQM62X4D0/DNGE+aCpjLpXVPkWGBZm0SoUVKfAoiT
	BKawHK4A5AKD/RVHHocNwoQ2uJB18pI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zgig0qhU;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 890074044D;
	Tue, 28 Jul 2026 13:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1405C1F000E9;
	Tue, 28 Jul 2026 13:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785245842;
	bh=KB/07Tb0FpiBzqRpvRWCeOJ77m9l+yyrAJxlJVmVIDw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zgig0qhUsUbAneqzMvmFr3n5e9cqebP2jQ5ufi0nFxACxgtgrEUfy4yLO2qb0mKzW
	 wAuMNIf0MPt42ieC9lzv80fPlfvESUFCROqoIKB4MJRHKOe9X9leYiBdJo33RzHH7M
	 rrJJYaM5PFinHPuqYwJKJ/0vfqvgxweo+Xj/tk/6NttUiwq9ys1aPczbET/fKVz/pk
	 DGlZkmr3s9kCJH6R0b4/twzdC1TibY+bXnnxZTIYnSMP+MxM//1g/wZ1+7mYGPVF+Y
	 tJ6RMFwzNU274KWcliBrbYZRCgSVN5GRIICRXaEvryC9mvlt8smf6uAZDul+7qUbNp
	 3Zo1EMhKLscuw==
Date: Tue, 28 Jul 2026 14:36:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Yang Shi <shy828301@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero
 mappings truly anonymous
Message-ID: <amiud-At9fd6AzTz@lucifer>
References: <20260720-b4-scalable-cow-virt-pgoff-v2-0-2d549757a76f@kernel.org>
 <20260720-b4-scalable-cow-virt-pgoff-v2-13-2d549757a76f@kernel.org>
 <CAHbLzkrCjALeXSuO7dgho9=W-VZQxD-CXNS8iOva=oCCi1XV1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHbLzkrCjALeXSuO7dgho9=W-VZQxD-CXNS8iOva=oCCi1XV1A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80DAA140008
X-Stat-Signature: fj1jxrbax3a4f7qmgjfrqd653tyofd9r
X-HE-Tag: 1785245843-422074
X-HE-Meta: U2FsdGVkX1+rnb3WdiwvblYK/0b0TShjzKoRxiqQfagxhQrTNQJmsdm/33ZKqM/WxCTTUEfCoWDyGPjmWfwF7wmmPKdz6rHSpdiBaz9+eOS+WRk7FDZmmdjgu8ACTIbHLB+r7upwcvfWodNzsvA0sfEVlJ47e55MZvunuwPPVJimNUk1eW40wnLpVPgjiBdWQGQe1a09PJnfEg9PoUac7sW+KIWXLThLnuxpvO0fm2WaF2fsKPvVfEUoRAV51RE57nU17lcWYVwfJ5jDAp0rNHp/F45o0ce+kQsgB4tsr73asn/wTKRCRvtlk5EsIoJ39bQp+aGV4NWfDhAIGpCSZg1qiU59sUgop6WVKqEO0R8iZn3PGzwEXiYRMp8fWmtoLDfnJVBoYsd3edCfvK5g/p/r5tBlxXjBtYgN2SEnsFwLfJrsJYP2owJjXX7bBhjqnM0uNGeFdj+2eRY2Kc0QepAky0T/Ktd+fqVep0kPW3TeMmS2+euMrwm83jxDLH60nwbxXcmBhm0bhalDObnU9pxAMHodo2D6Sm7GvZL1FDJQDNKFKdl7tHW6RTJRCxLDr0J4+TVjduKlCitPr21peSWGua2qpGoHvoCnSkSX8vjp3cr2e4RMDpiaA4jZ4LnNqQpPUGA8QGNpGIZRVgJDHP26ruZ68oqkjD3VH56OE1hHdQ7XEWIufdpa4S6698B/4pwzPCMWDTTqOgToduVf63iAI0ntOPwAAkavy0h/bRN9hizCjdu2RYRAK+AC4Yca+cab46pgXucGZ7mMLMT9ZFXNQmVxcPgLW61ru91u/mE/on8xdwfPIzQGlWgSkojRnYbekiKe6ukMsIxL27yrLfKatLfPRzIkp3n8IkLy7+rVwbVMzpDZ8kOFfzOnB2tFqTPdiEy0g1RaLHkK5xvsAPDnE+jmm4omFXKYkqAJYWwHMMlNXPrLOgYfHImwEiU5RYCEiCJsCNXNsQkGAs4
 KLkRxCy0
 1Q4004ZYUIqwZPZ3gXGq3Gg2r2Wv4jvwF8vgKOmmaXpTMHEn+n7V7H5PVfATuEnuc5ccVxroIyE7Zml5bGoeoZwezCyVtpIb8L64RtfjzMKx7bI6BeZ67hG9e535FyGx3JmPDJrj9oZmdKlJJ+tdRaXEsnVMkRwgmYCxchg0ZGYWwJSSs14QRsZW8MJRSY4DDbHZL3xKRIGzFbCE+tgzkdeNWwrECQKNuIAIKAGNwSXS19HIPM3kwVQnhdn5KvqzpkJ7lu9jKL0uBYuqQeq6c0zUR7klyaKj6ydvQgWofPyCpyF8N5Gs6a7Sxv9a+JVPP1LeHbXURqO5VJ2/FHX1x58G07ufiCGZCFom633y99eJ6l8xQ2kFEbLMG/5jaTvkxufeKB0+jm9qq3d7hw1bUCn4P4hJbBfdabtTxo254qCW9g9c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:26:32PM -0700, Yang Shi wrote:
> On Mon, Jul 20, 2026 at 8:30 AM Lorenzo Stoakes (ARM) <ljs@kernel.org> wrote:
> >
> > When mapping /dev/zero with MAP_PRIVATE, one ends up with strange VMAs
> > originating from Linux's distant past.
> >
> > These have vma->vm_file set but NULL vma->vm_ops, meaning they satisfy
> > vma_is_anonymous() but otherwise resemble a file-backed VMA.
> >
> > The introduction of virtual page offsets and their subsequent use as
> > indexes for MAP_PRIVATE-file-backed mappings mean the rmap does the right
> > thing with these but we are left with inconsistencies.
> >
> > The vma_start_pgoff(vma) == vma_start_virt_pgoff(vma) invariant is true for
> > all other anonymous VMAs, but not these.
> >
> > These VMAs are also observable as files in /proc/<pid>/[s]maps but
> > otherwise behave like anonymous mappings.
> >
> > Therefore let's make these VMAs actually anonymous at mapping time which
> > will activate the anonymous code path for mappings.
> >
> > This means we no longer have to account for this discrepancy anywhere and
> > no longer have to think about these at all.
>
> I'm glad to see this is solved finally. But /proc/<pid>/smaps will not
> show /dev/zero anymore. It is user visible. I recalled you were
> concerned about it before.
> https://lore.kernel.org/linux-mm/c98f68c1-4bfd-4410-9b65-1eb5a1efe271@lucifer.local/

Well I mean they'll show but just as anon ranges so only disappear in that sense
which I think is what you mean of course!

But yeah I guess over time I've become less concerned about this side of it and
a lot more about the patent absurdity of this situation as-is :)

(Cringing at my facehugger analogy we all learn and develop on here don't we :)

>
> Anyway I don't think it is a big deal. It should be harmless. I would
> be surprised any real life workload would care whether the anonymous
> mapping is backed by /dev/zero or not in 2026.

Yeah exactly.

I was kinda hinting at this in the commit message with:

	The impact of this change should be low as likely very few are relying upon
	this in any case, and in using them are asking for anonymous memory, so no
	longer seeing these as file mappings in smaps should have no meaningful
	impact.

But perhaps I can be a little more explicit on respin!

>
> Thanks,
> Yang

Cheers, Lorenzo

