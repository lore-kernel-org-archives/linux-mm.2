Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7107DCA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91D506B0088; Mon, 28 Sep 2026 13:44:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F5446B008C; Mon, 28 Sep 2026 13:44:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832556B00A7; Mon, 28 Sep 2026 13:44:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6789F6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:44:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 097BCA02B8
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:44:34 +0000 (UTC)
X-FDA: 85263895668.30.D2EF7F4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 74B4940006
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:44:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0+IRFej;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LX4LuZoDt/rc49RibEVXEdvKwPqqL8FWf86//5s3GWg=;
	b=5D75dxFfhhnBkCP+Z0xUVLw6HDMnBu+x2k+065lA0KKvVcIqjpH2d9Sz0wl5e3NbJsW+5V
	uDz7Q5/akQaX3tFq/RVvxQEsedqd0vKA8rCMHjPdJdjZjNokqIsaRlKa7UxWw2Jo4s+zOd
	mRXXRX7bWRa5hEwjZzvM61g9qDmnLI0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0+IRFej;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617472;
	b=X7nQPQFsTEewXkWaiu0t/mTG+88vdoG8qJvA3jeQVLW62tC8FUCbfuIdSwrQaocOj9f6JA
	t6OHbe2XfpyJEEydgD0ifmTou0ODCEMzcUDC4CXmIO0KrZuywSsxe486yKeGnW4hZWnfoW
	Wrt3HiRNYnLcxzz44bm/xPwB6Zx00L0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EDE3C60120;
	Mon, 28 Sep 2026 17:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C333A1F00893;
	Mon, 28 Sep 2026 17:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617471;
	bh=LX4LuZoDt/rc49RibEVXEdvKwPqqL8FWf86//5s3GWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J0+IRFej6Ee9mLg3nwYKPtM9sakauE1HtnsRSt6dDvCyYqnDkrf0hqcU/indoztfw
	 tpJNmwpqO5FB9cm4qdb2dgu3bnQF+S+G+G96yg7zi1/DUvTYDZ1m57tFZbVB+1QvYA
	 Cb1X7yg0HHE5LZjhuUscUwuRv0Haz4rV6767L/dH9YXXgll2E5w/QP70MMnUTWRGyc
	 dMSQLdE1P0GOgBsDICf/XKCm2enP+cKProuH/REprJrXhaFQKZoPVt2SHZsjCJSVqD
	 PSh6kuhrxw5zK44KgzXVq9CVQZInBvJA7PtDR10mzvMnLxgs9NNVAoMrUHh24Fz2BS
	 jNBcYQu7hHPJg==
From: SJ Park <sj@kernel.org>
To: Carlos Llamas <cmllamas@google.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - MISC" <linux-mm@kvack.org>,
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH] selftests/mm: cleanup -Wformat issues in hugetlb-mmap
Date: Mon, 28 Sep 2026 10:44:25 -0700
Message-ID: <20260928174425.19155-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927162419.820609-1-cmllamas@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 74B4940006
X-Stat-Signature: waa5ssmmh7fpunnpwxojs6t66x4t8w6c
X-HE-Tag: 1790617472-630406
X-HE-Meta: U2FsdGVkX19o2XPKRN68Hz1DAIeZGY1Fm7zyuDEvtVK2QaajncKmQY1n7sxdyPg4AFe2YgaorVHauz20q9yCF2cjahbH1Nv9HlOrtL5JDqLlUkqjWqayWKwll3L228mfTDbgzERHOyFgRfxNF6TGMdLZ9Cq4b6YEkWb4ZxAV2FoA0JMV1k88LF9QKHLi0yQ3jkNp3u6tESpML3KjuzSjviC1f6KVtYNR19QbOVDydTjkst0U2JeyYnYsTwUbcE7+/M1AJBTXMYx3s167WzzGjZpjTtRXtfo1qsGl5jyxxKVyQcewstsaSggGM8jKVrbCDQh6CtRZmLNBVTwopiXX1nvMd4NfWtd9rfSovZEwPSNuVMNcn/pD7kEmPDwQdTDbR0QFFMPFbgtsrKluv13T4KOpoA00LLBgROuiFLU4OPFyEi4r1CJ6OdroWHxyAamAytAu0UoLQ8AN3NJt4uxHEJZat4qmftYuqqVlpqhTGowoGBVXrjC8zViUu3kCsCb6ELaND0TD45slRTnBUAcuwtqvXn/hfDQRlsc5MizXP7aOLTMwduWUGWWcdSLPGkJXuObvxA+aRTAfC75iltaJL3m6fKLBzphW7CkD0z0CGtThWOgm4a9yz5vbJBIdzfX4HAWRN6iP7PCdgpKGm01lxp/DpRIqEekPuvPGNKZdy5NwuX7sKDLp/WX8/bA8ZClcZORIUjaPpjjL8DK71UU3Mj227I+SElmZdFKjgENynT8Vsn0ABuK+Ob1NDzOYxm6RoFsBkyDTasPO5DzoIj2YdoBWiWQ0CAXdcCOMNKFE3YxOIfTp5nvzpqIMpR9wn1O7lyvksp53t5JW6+gBv1sH712K+OIa1D4Z6LrUfZLaHomchHfylH3YNXYmanzRox46mnVdk4pqd1s3CZKWihtBGfLWNGHxji2sQEQDNLOGAmuO/3Ss76ZjM1gBEOJeqSpz2jS0eRW9fPHDM/36ou1
 Aosri6+m
 jED30FtxpOHEPJQNyGm0fDQqciSG+MZvlzlAebbGVaZVRAuGJtAutQyqni3CTu4rv51pEiKK7KZqF9d5jYLJGOYIhCH3mRp2MXLox/MKyCAmUagDvEMpbNw3QExb7nXSO/nAFoiIzYPWA+47u1DvR8jZS627HKOJtoAERb/scQOFhKKDfTptBwcag3mEEH8frVi2D5zQekkr2LqiiYHrE5Xs/+3hiYrVE8rD1ZvNxgIen1aset8LryCb/Dlgm1afsfM/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 27 Sep 2026 16:24:18 +0000 Carlos Llamas <cmllamas@google.com> wrote:

> Commit ae571cd6015c ("selftests/mm: hugetlb-mmap: add setup of HugeTLB
> pages") and commit 9c5a65f374f8 ("selftests/mm: merge map_hugetlb into
> hugepage-mmap") added logs of 'hugepage_size' which has a size_t type.
> However, the incorrect format specifier '%lu' was used which triggers
> -Wformat warnings when building for 32-bit:
> 
>   hugetlb-mmap.c:125:55: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     125 | ksft_print_msg("Default size hugepages (%lu kB)\n", hugepage_size >> 10);
>         |                                         ~~~         ^~~~~~~~~~~~~~~~~~~
>         |                                         %zu
> 
>   hugetlb-mmap.c:134:47: warning: format specifies type 'unsigned long'
>   but the argument has type 'size_t' (aka 'unsigned int') [-Wformat]
>     134 | ksft_exit_skip("Not enough %lu Kb pages\n", hugepage_size >> 10);
>         |                            ~~~              ^~~~~~~~~~~~~~~~~~~
>         |                            %zu
> 
> Fix this by switching to the expected '%zu' format specifier.

Looks good to me.

> 
> Cc: Mike Rapoport <rppt@kernel.org>
> Signed-off-by: Carlos Llamas <cmllamas@google.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

