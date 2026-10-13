Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78744CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF7386B00A4; Tue, 13 Oct 2026 11:46:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE686B00A7; Tue, 13 Oct 2026 11:46:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B896B00A9; Tue, 13 Oct 2026 11:46:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 953B06B00A4
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:46:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CD34A0CFF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:12 +0000 (UTC)
X-FDA: 85318029384.08.8B9F7C6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 73EAA20008
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:46:10 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5wV86lu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791906370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6C8dHlnwEDJ1zncuSe4AUCuf3AUeAAimis8NggtjWM=;
	b=isExhhSCfmO/hIAFsyCQAm0GwmjnpAUpag9a2JLlWSntvSsiP8k5SrKTLNXlDlhcKNOnt+
	VnqQwrtzQ9dRMlMDCCJ2it1BKGIqoJVXhjc3B0d3+a4ZkDzBQpbs8FBhmEdtKzq3qu1LDw
	tBaSe0ejU6D+b1zQNZoz8R+Q5Cc/3AY=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a5wV86lu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791906370;
	b=Hu7bA74owCstFmRF4qXMA/UU7hAyPcVCRJJXkTO3pkvY5rH3fdp2XPfq8vFI0OBnjgsjU8
	gG8sO87SCsS0TeYy53Y9nEeuASrLPskmb955xqe6mhBmfg0hAf26MRRP4Oc2BDwVRC+VSh
	d8SfCucZwsx6LsnXtegf3YbKyoMfQf4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0569660A52;
	Tue, 13 Oct 2026 15:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7F11F000FF;
	Tue, 13 Oct 2026 15:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791906369;
	bh=Y6C8dHlnwEDJ1zncuSe4AUCuf3AUeAAimis8NggtjWM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=a5wV86luUnEXxEJ/WMPsiL4f1xgooPCOJl4BDaSlHryWyUztKNBzJivXW9tcPW7we
	 v22pP39rPRG3uauFSeFa9QiRrF04IMaMTrAu/b9OQASK/KUSQhWixr1UT5XtUYO/rv
	 NI/WLSuBdnupTa29PNK0U3Is2YebXuHTAbhciWlKnqkj0puT6OlchlD/3WRqY0h5kK
	 alyzZNkls5y2Kavi+qQ3VvVpwiJ8WJZWs46qgzPqTY+ZBpEbwMv/ea1exBvN6qzq3j
	 XA3GzztdOp3pYUZkN0IxsxxXzA7zzToyOL4HeLMRYLubID8oCVP2wup6+8HED6cK5o
	 +ywd085qTXbbQ==
Date: Tue, 13 Oct 2026 18:45:57 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Sarthak Sharma <sarthak.sharma@arm.com>
Subject: Re: [PATCH v6 2/3] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT
 macro
Message-ID: <as5SNXFrfBB-kYbE@kernel.org>
References: <20261013-fix_hpage_macro-v6-0-2c52d0484de3@arm.com>
 <20261013-fix_hpage_macro-v6-2-2c52d0484de3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013-fix_hpage_macro-v6-2-2c52d0484de3@arm.com>
X-Stat-Signature: ppdkdz85r995cisrp3nqqze9knkp1opx
X-Rspam-User: 
X-Rspamd-Queue-Id: 73EAA20008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791906370-648508
X-HE-Meta: U2FsdGVkX19P973QEvdGeQEdZ7+Lv2fVIbLaySLwzKNI77huT/hl68ibgl6BSSBOFvcU6qRcCKbBcVuoryK9zDv0sxQM5Z7vz6K+eViKKZkStVPnO04goJ9ULWrs2ZpvZjOFyI0hFJSQ/Shrlhoehb36lkEz5e8OSbnK1x0k30f2ZYcua4vSdq7/i5ZOyOg+u20wVDYI9+A2eeUYpXA2tC1TOZoc635Hk+uq3S9TEXW0tV75sDf/hVox6p8nT33qLfNqhoQrcbIRjKB2nGviojwG3bz7/5ggRsmTWoXCdGpUC9KI6EXVyyPpHUYMT8Ee71ocOiSzs18iJT37MEhpaepUCkKPwqIcq4RvkVgEdc4M3o95fgP0A8w2txF2Gc3J0KfQGxXdK/Lmke5aoArOMzKUMJEqifV1MhCfHs0RNvYkMTBs3CUQiVB6fhO8Z7BRlAbzBqugQXFSYQSTpkiAw9ZLpiZaYF28//O+xX9cBmOrFA+1NB672wevnGqD5aK+292o4OrW5E6RKw09dW40YIR8t8HyQKVTydKt0rOtpB8+Hrem/Yqh5u5/B+nNJ2njioZK+Du0dIRKW0OK46nljjoGA0WFZmkdOnJilgSKfxPZMquW014wamgsZfIWJyQgYfYZIXKEU1CQsDSc/HiOp8zWydKEFFN5b8fl22DmYNTCbWAm3AJR/0EzZRQuQdWIj0ckAvRq4GU2um6yCI2ASOF4je3BemQxNjS1ORxE4WZJOrLVwd23/GGFyhbYUDV9iqNDkHqfSmxt5psbpKXah8KBR14bI8uYFuNQEfnFt+I9fldiBeW+zsSXiYYLlvGq3kWkaJv6d+sITqceBx0OKodmuoaGR/JqSHYhkrEl8azGuFj/6Ou1izLaif7iGcNLOCHtQR/o5qxN6W8ItpErc8VN1mh6ylarYlw72/h/Du4shT+XlJmnyt8QVPEmI3wbIKOpv753P3dYt3JWebZ
 q6+64Of5
 MOPOWETrKP7Sw37ink2H3BSqaeYzfSs21W8PlYFhHLVm7b0D1TsQYeplgYe7mY6b55WgN10FO1hqy1swcM/1Gd7SHS1ocWxAMrtxp7I6wVc7amTL8COpLUady4Hhl5TPREGNfqrPipq9qNByG3mgjz8U5ZqEZFPbg4zh8YL3XTg6jkzmMVluBVC2kvMpRLVWCcLXBM3CkipLEDo6ReWZrzNkXlLCgV/vwKSLEN0/SZKgKJNZUkQ1uWWWqN4NjpPu3FG2P29HblGkHFNNj2Glnk7sh8Id3zePaxoTXbUc6ANvFh/KnMpcAPlTRylrVZq5gkT4W2RZjDcUeKSZTHNsWVa9BehB38eX78SsczMGwB5d7IrSjDXd9MyyyS5+vvbvKqKec+wIQDSJdzteKSbD9iOMxYABf8odZSAIB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 13, 2026 at 10:46:05AM +0100, Yeoreum Yun wrote:
> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
> When this macro is used in some test, test result would be strange in
> the system where PAGE_SIZE is more then 4KB.
> 
> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
> 
>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>     ...
>   ok 1 Completed
> 
> Remove the HPAGE_SIZE and HPAGE_SHIFT macro and introduce pmd_pshift()
> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
> helper, pmd_psize().
> 
> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
> PMD-sized units, the test may fail with the previous size of 100 MiB,
> which is not a multiple of the PMD size when the base page size is
> 16 KiB or 64 KiB.
> 
> After this patch, output of transhuge-stress:
> 
>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>     ...
>   ok 1 Completed
> 
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/guard-regions.c    | 10 +++++--
>  tools/testing/selftests/mm/ksm_tests.c        | 16 ++++++-----
>  tools/testing/selftests/mm/run_vmtests.sh     |  4 +--
>  tools/testing/selftests/mm/transhuge-stress.c | 25 +++++++++++-------
>  tools/testing/selftests/mm/vm_util.c          | 38 +++++++++++++++++++++++----
>  tools/testing/selftests/mm/vm_util.h          |  9 +++----
>  6 files changed, 71 insertions(+), 31 deletions(-)

-- 
Sincerely yours,
Mike.

