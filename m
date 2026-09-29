Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B772ECA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:36:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86026B009D; Tue, 29 Sep 2026 04:36:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5CA76B009F; Tue, 29 Sep 2026 04:36:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99A7D6B00A0; Tue, 29 Sep 2026 04:36:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 771BC6B009D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:36:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 09E3C14043E
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:36:55 +0000 (UTC)
X-FDA: 85266144390.27.0ECF7B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68E5340006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:36:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtaQjHCo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rs1CkTi+9r9PKxnWBlU9VchKWdbkwnHkDzwKExg5G04=;
	b=GCB4glPQcF/1rPpf/KxDhIOE61lC28V7Bf9Yppx3a+YTb7SEgod+4UbYJ3IdXlr+xRbZeQ
	vXi71K6wFvNkBeAFkKm4YR8B3Gg1bUeLWCt7j1Fj9nAnvLybM8DwP8I6k+71RumrE+Wir4
	Dghutfp1PLZUy/KxgR+FjJlMy/8iaDc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dtaQjHCo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671013;
	b=06HmSl05m36i/8JNYT81evWTkR2/jxNw+PUreZANAatHjRrdTFAUTq4r2nIkV9/+AnP9am
	sh96M5pDMNo9ty7nw4BSqnsB1b0srKkkOIJLrqhnvYQqvnbQGVm2Rg/MKWttCsOJs/Ymzm
	jY84iSDDfp3MjPyzKIw8OmpZC/P5L1I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E05D40162;
	Tue, 29 Sep 2026 08:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 157F11F000FF;
	Tue, 29 Sep 2026 08:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671012;
	bh=Rs1CkTi+9r9PKxnWBlU9VchKWdbkwnHkDzwKExg5G04=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dtaQjHCoL6wBCn3MwhzhQH0mBfkWaEv+gB3h/hMz8cLIo5a/sS9dmEGaW6dVX3vtf
	 D3KntZXSQ5UXPp9KoW/6dhulUn1hkeEekIITvia14D7NYUWPojxwHixV7cd+dAKfjT
	 1mcJqJG8N2mvNFN3VZc8U8IZkpL3e4oLxreL4Xlhws5tB1oGrzbGv98KMAWiYzFo2l
	 /TocQ0CXgEfBi4/rPYp8roSSYHRd9V/BzHuKOp0CJ6wfGbelpPlq+WqOf9QD/ywKIs
	 jqocYNSTAx1f+W+KqvdF+15rJX6M4P/swKM8sb4JIiqiqL6z7g3oAE7ArS/7Zq8NcI
	 seoj9aWR+ESVg==
Date: Tue, 29 Sep 2026 09:36:45 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun <ts930@dgu.ac.kr>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 0/9] selftests/mm: improve mremap_test
Message-ID: <art4dfRkyu5OCwvd@gremlin>
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924050009.19974-1-sarthak.sharma@arm.com>
X-Stat-Signature: yigg741ce7sie1oepz8amsn1su5en4hg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 68E5340006
X-HE-Tag: 1790671013-815380
X-HE-Meta: U2FsdGVkX19Incv73pnLyfGBdnmO5OYBq4qB4d9K/uNTIwTNc3Vin+nVYBuCOXv3LZoG0741yJuUZvD6dqlIjU9xKqGroA3FICVNjswh8ulbq0y5nKMkwlXR2NehW+AvWxCtS+Vpd/Idbdb5NQRwN7O9s92Jce6vL+npIVsBHDEe6lyjNCmyS4O1ryVrxknJ0y4t2Mj6JwojdgAZ+V3/yGaWKiU17Q0XvQ37vNpwPthLcbTmI1r/KNukHo8A0e1I/p7FiSDO4EqmloQzuaZzQ4Ke/MYYi3x6butZyeOngmNCe6lVZhPqagthHaivn9kGSBMXFwOMiWTrqYRQo4iGzajSMCmXeq7B0iTqgoh7cHWyHKuRWBJqvhi6OE0VxDHrvrmy8b+swsTbHliZRqjxPdnE9/oBPmV/YJXjnTbhiE7jPNx1VNW/5E5Wedxfeo7v9TE6SyRGJZk5OQCb+X63rv0SkliUtQQCgRdWfokrVe3wj4EmN9W43GdjGV0nrTjTQMx6K3IYMYdj/ltSntjg4+hMYWoOcEslcqK++FymAoVllSvC1IxOWQDXb4t4Y4uVDcwPRTKHeCyHBKQDrFOqqcPHcQBT6mnEbpj8LbJrK+hmiG94mO4KVYsYpaKpiaV+JJg0/doFPzsgcxrZygX/kXdbmSGMhQjLtzOg7wT5aNGxUwlmB3aedvpIaHWNZeY+KVZE1Spnxkc/byX5savHzT9flwssvyJTFnl2Uh6W1/7KicOcGbiHzrbq0mOpnKcW/U2DsAF5ZP4mD0XDjaJT3XAvSrmMuzpbqR49cP64pUoLJ5Kiq9PhM8ba7otlruqY8Yf6ng5NBKiUICld2jK45wJyH7eFfQ6PHMzujtGSdDymGE2+5zSf+TrtjHB1OyM1qcRw6PPEYaGFxmkSD0piLy5QX5nk74KsI8TAWc3vjmE6yVJDfmQkJa+W5JnwgaA4krldlJPBdJbqkDfnoAY
 dF/ADYue
 2B1VjoVw7sHSSEqL9FoRkuJ06wH3c6wyR9a6awzwfPqHnE1+XpaBJ5Cyl8jbm8lJnz4aZ3BVm52crTEhyNiWakw7Bz/dvaMd8WOAd5WZvhreLlhpvnANpn1NPHrpmItasAUgD0ZO/7L4VUkIMUiTRNz5UthS3TgEC9YLjzeJzFB8zSXSuS62xjVZeLkcbichZlZGk+0nnWXFWF+LzOBHWwXGUqnnOyJNb1kOJOMP+0Cxj6bmLrC7dUokpyjXsCjXd54IS471R70D67XtEk4HCA+SkH7DjLL09sjQYIy5NVWSvf0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 10:30:00AM +0530, Sarthak Sharma wrote:
> This series fixes several correctness issues in mremap_test and
> simplifies and strengthens its data validation.
>
> Patch 1 converts the mremap_test to use kselftest helpers, removes
> manual tracking of failed tests and corrects some spelling errors.
>
> Patches 2 to 5 fix userfaultfd skipping, unexpected mremap success
> handling, multi-VMA data validation and failure reporting when data
> corruption is detected.
>
> Patch 6 removes the randomization and uses a simple pattern based approach.
>
> Patch 7 removes perf tests and timing infrastructure.
>
> Patch 8 removes validation threshold and always validates complete mappings.
>
> Patch 9 strengthens the multi VMA validation by also checking the
> mapping state of holes after remapping.

Even if I don't get a chance to look through this, just want to say thanks for
taking a look at this! The mremap tests have always been hairy, when I added
extra tests there I didn't love what I saw so it's great to see it get some
attention! :)

>
> ---
> Sarthak Sharma (9):
>   selftests/mm: mremap_test: use kselftest helpers
>   selftests/mm: mremap_test: skip test when userfaultfd is unavailable
>   selftests/mm: mremap_test: fail unexpected mremap successes
>   selftests/mm: mremap_test: correct multiple VMA range size
>   selftests/mm: mremap_test: fail on data corruption
>   selftests/mm: mremap_test: replace random data with deterministic
>     pattern
>   selftests/mm: mremap_test: remove perf tests and timing
>   selftests/mm: mremap_test: remove validation threshold
>   selftests/mm: mremap_test: strengthen multi VMA validation
>
>  tools/testing/selftests/mm/mremap_test.c | 600 +++++++++--------------
>  1 file changed, 220 insertions(+), 380 deletions(-)
>
> --
> 2.53.0
>

--
Cheers, Lorenzo

