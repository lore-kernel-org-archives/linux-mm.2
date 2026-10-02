Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74EDECA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 18:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 486266B008C; Fri,  2 Oct 2026 14:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D2B6B0095; Fri,  2 Oct 2026 14:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326446B0096; Fri,  2 Oct 2026 14:53:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15FF76B008C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:53:17 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9191016080D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:53:16 +0000 (UTC)
X-FDA: 85278583992.27.9B49EA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id DED5D18000D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 18:53:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGzUzC6f;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790967194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zheeU3EuzyWIQHVUugGMtNSaN9Adh+jr5Zkc1USMfk=;
	b=22CEYZh+oSvOwEZZBS0R2CN26+peKb63aceeVI/jbmJrFDYXPzs109IoaAHmyt1HcUwH2+
	KKpQCm9tbnZ5vPXsK+vyxNx74Bl2v6S2ChvbgiO/pqClWVQnQCBgrDhPLsqPGR84tuixYG
	5dGYtT7CjilPBdKuustXt4/oqs+LsCc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HGzUzC6f;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790967194;
	b=alGXGYiyx0/2nMVQ85NHSI2xOf2fjMUeETzvSw/0R/HV+3YZUDo3FCo08pE/tFV+GiHOP4
	HvfDz87eRyHPOFxyWt0jdr1tGeiU9NK7RK7MffY+eSVlr6BV0Gb5BFdr4Rx26CLSNDFeg/
	OrWP6j9Cjim5ch8UhY8LpehLsCKVjBk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7581D60AAF;
	Fri,  2 Oct 2026 18:53:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F061F000FF;
	Fri,  2 Oct 2026 18:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790967194;
	bh=3zheeU3EuzyWIQHVUugGMtNSaN9Adh+jr5Zkc1USMfk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HGzUzC6f4aroci2M61+q5sGquB80q1nj1gcRlPhIu3eax9X+7c56OCAu+6wYNlABB
	 7faeIbFwpTgogflebupr6NZIIoQ6Ed5xcHLe9KnguCADZngZw5didjCfxOfHhGTkwc
	 A/tCJvLgMnxirehIyE8R713SJyX7TDlQi+ORzqyzmI/GaidGiPI0Vj6KVBlgp74uzO
	 nRW0ZurqANeYHJFHSzfUUtiFbOZgWLRQhAePeMTghm9LA+XjKQwfwkMSvvbJk66cvg
	 IeH7HBQfVbJk+a+ZYDld9E6T7GdnygpLZGGjC86A57vELVeTEYw8hqrJ9zNuFiVW8+
	 ejLoBmkUWQlXg==
Message-ID: <580fbfd5-2db7-4c46-9335-003ac99d1db9@kernel.org>
Date: Fri, 2 Oct 2026 20:53:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/migrate: walk runs of consecutive pages in
 do_pages_stat_array()
To: Qiliang Yuan <odys.yuan@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261002-bug-mm-move-pages-stat-batch-v2-0-f73b5d20519f@gmail.com>
 <20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002-bug-mm-move-pages-stat-batch-v2-1-f73b5d20519f@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DED5D18000D
X-Stat-Signature: bnth6h14ssbonocmtaaiwix3z95yh1se
X-Rspam-User: 
X-HE-Tag: 1790967194-400553
X-HE-Meta: U2FsdGVkX199ulIc7LXB1AGsRkf2ZTupmJmwhjqVZqrKfoSETU/KWRdnmbxL+zbJLTs8ROzW/i9zqzTP8qp6millcvFTmYKquZzgdvteUvxh4ZjfDZibx1yrOLfGfLLm9zUlEi7XkwIoKIleL/LLPAO7sSyQgLRsU23xN3J3qHx8W2ksMvDR6H4enSpYJXTvaP3+0c9pZmusJb15Pra7FXbpLIDZfu1SuDsZb5RpfrxKyaD0/hmkcKPvQvBZ+QnoPDKztfeXepOhjSg6ODo/gMWPvq1VRa3hEklTMa0zQE9BnSHIUkp5UZ6biTrAhmgVhlSIJ2wLuM1yDR2vt9JBwDIetNI8Rmw/uuNl/gfT/OY7K6o++ap0m8YWmW7On7NiJCVB4MqtOeCua2RaRQd6LEsd2DJY6EYi7VZCXiPWM2lKm7O1Baom0G89f3q0NsDIj8GXOnQsqZqUEDDhy752mpGA5eO3XtZ+4aq4UIwzXNcVCtTm0VOoQDAUnQfDJU6X7vsySMet2QeHhLW1MQlwZ0mdm2RPO82QvtFKya2qSGYPvtj6CbHYGHwK8AoooUfMEfutGGORVKjb9zbfAOJLcyGalqyBWAW9d7LIOT753UKsRJGE6hfSEz0ADOsJa06CVUwyYvYjzVIkXB0WwM4Z5i42anc6uuoKZ7qk7n8gNtAH1TNHj1QkJRzuPcHui9MrQ5/24AQuNdGw/nTCKh7amrMpbjlYGCCvt3RgnF0GXGP8hyGva6Z8/w3gmO+iuOPxr3qPvX07XiMjoHpa1VheGHGo8+oX06INfeZ93IP7NmXASmOX0Fuq/5VViebvAlcy/k3j5FaCCJB8UTyBqwNNDUlxSAB3GD48Mb9m5A3X8Ny4K6jbErN0hsyC//Y2sJ1wLUMq2PEkZlZ7w2F6JNmNZKXC/b1nAmmVwaNxN3Vk/WjUJ2hZ27JzXFmCrNyT8rIGQsA3NaqOhspC7HboOMO
 /CyuH0Bk
 sxqVBBD9Ws0lf3Bl7K8Qh4LOepMenKlfHabQmXe4Ir3KQ2VN7sg1luQ35R/lUYYPsqw41cSHotdwITJVFdy6U7hXPmz+/Kn523/WCnwM+YB5KCvNZDK6uhW672ufOULznx1k+ruBJ88Y53I4BksnRZqZhcNe3RQ2cao8RGHc8vBbX7m2gkWDuE22xvs7Jp+ILiaEczzHPib/1ra2DDl4eBuvfFMI4iVnk9CdmRcN428VXk1s9DJreOvq53r+cyzVQC9MTwEPj7mOwn294Pk09aEyJD2O8mBoADSZ2fhbeODT/k1o2B69x8Q0O8Jv79pdNwPyiptSfuuLGm2LG9Jx84R4sb4+uLkoFfQcNv+tUMGcN+jV49tbIRjDkOs9VGGCBCEIYQaVVs+QVpIQVHPWcgJAfhewLT/5X8FeWGZFflURwEGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 03:25, Qiliang Yuan wrote:
> move_pages() with a NULL node list reports the node of each page. RDMA
> and KV-cache transfer engines use it to find where large registered
> buffers live, querying every 4K page of buffers that span hundreds of
> gigabytes.
> 
> do_pages_stat_array() looks up the VMA and walks the page tables from
> the top for every address, taking and dropping the PTE lock each time.
> That costs about 105 ns per page, so a 16 GiB buffer takes 486 ms.
> 
> Callers almost always pass consecutive addresses. Group them into runs
> and walk each run with walk_page_range(), which looks up each VMA and
> PTE table once and answers every page under it while holding the lock.
> Report pages as folio_walk_start() with FW_ZEROPAGE found them: the node
> of a normal folio, -EFAULT for the zero page or an address outside any
> VMA, and -ENOENT otherwise. Handle PUD and hugetlb leaves in their own
> callbacks so that the walk never splits them.
> 
> On 7.3-rc5 in a 16-vCPU VM, querying every page of a populated 4 GiB
> buffer:
> 
>                 before    after
>   4K pages      105 ns    31.9 ns
>   THP           90 ns     23.1 ns
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
> ---
>  mm/migrate.c | 188 ++++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 162 insertions(+), 26 deletions(-)

That's a lot of churn ... which is really a shame, because all we want to walk
is folio ranges.

Oscar was working on a better page table walker API (but I was too busy to
provide review so far :( ), which sounds strategically like the better long-term
solution.

Is there particular need to optimize this in the ns range for 4 KiB of memory
immediately?

-- 
Cheers,

David

