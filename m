Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8781C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 870766B00AC; Mon,  3 Aug 2026 09:49:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8478D6B00AD; Mon,  3 Aug 2026 09:49:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7843D6B00AE; Mon,  3 Aug 2026 09:49:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D32E6B00AC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:49:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6CEBC160650
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:14 +0000 (UTC)
X-FDA: 85059361548.26.E02CAD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B127720007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:00:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvg1q1jf;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785747612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qJpnVbUUg/HZmVbgibR8k9snYJVUV/2ctFtNVgzFuMo=;
	b=gZ9UX6s2dppKYxburBD8xVX8Ys5pI5ajcoVWI+plzsQPlJw/w9zHvEL65CjCF7pIeYwrvE
	zJxm/ryc+yqDfVcwO/B3XSm6CUPNaZXzakkWC8YkhvoOQE0gcK152kftbRS0M5XWTdqP7R
	Ee5NGHj/h7xs+oN/TIAdUTsBHQvhgcM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785747612;
	b=apz4mDjGH/evigGDYCLL2GQMl8D+RAdxbtOuZYZ3o23vYzJTwGBpTs4eSCioQuHmiYe4Md
	+xUuqZJvWu4NR0BPRfm44b4Hg03XMOj3fHLOT8XrDxUJEp08TUVt9bfB6BkvVzDXi3UsOP
	OUOK5Ua0gCZKZurc+YPMqIkUMPMTecw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kvg1q1jf;
	spf=pass (imf31.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABDCA43E81;
	Mon,  3 Aug 2026 09:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ADB91F000E9;
	Mon,  3 Aug 2026 09:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785747611;
	bh=qJpnVbUUg/HZmVbgibR8k9snYJVUV/2ctFtNVgzFuMo=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kvg1q1jfM5K1ykaqOcBsNsGb5IZ8pT5YtJYWG0o9gc7/o43KMc9uLqYDjdrlCIcXh
	 Vw5sckFmqKYTLhzaKYto4/ay7QwV+2zNbp6ry9KiHO86I5tJSekgSgLWlXDPoVB/AX
	 t0Pz1Lvh6H2SzFhYY+wqWmfMkxTn0jdxmgRHcXWk3LdTYYxJBmXqynUnHBe/EoUDIP
	 b2icn1Poh8bGwpDQUTHh26UqAyWBpgwXQL5yCe+CdH/Q1JdVzjIyCtmwJc5+3xmZtW
	 nCUNkCzFdpk21pIMjyRD4dM9dVwX3JIvBjb0SPebBpqTX4GQU5i8YMcWV1DhzHHxli
	 98HizTFCd8ekg==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 0/6] selftests/mm: separate GUP microbenchmarking
 from functional testing
From: Mike Rapoport <rppt@kernel.org>
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260730140825.238130-1-sarthak.sharma@arm.com>
References: <20260730140825.238130-1-sarthak.sharma@arm.com>
Date: Mon, 03 Aug 2026 12:00:01 +0300
Message-Id: <178574760161.1561566.2419225666600419775.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: qxr35r6krq11tdwsofuur8uy37kj85cg
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B127720007
X-HE-Tag: 1785747612-809621
X-HE-Meta: U2FsdGVkX18bwt4hVFP7RkjYmVuIWzPlFw8/1xSO4O2NGsiUSQrcENeL0OFZUQzH1U3AdkNZ3tZAr97BvD/eTBoh7wjITpINWJ7XeK2ux0PNCFv8D6vZmr4+5J6k4e/plntq0VK1t49JSJk/fMgVvArSISMIbkYwU/+x6b/6t58g6vJMC6IbbcBI0SyXT5qo7KurjCAzVrr0hj4znNVgQTv5TMW7LFGyii6q1iakI8TBJ/exhPa0Y+bYknOSoVkWNQ264bmgNI33pRSGq54NSRLbbfTY/2XDKSq0neJ+j3bZKzUQcB31Umg6OYM2Wo+25vX9Kf9yD3//yJDk1AgXinFjIaAaVJB+vrI4h2reVR7nKIXeBZTfvbmfzInDp3/SMCZTH0/7a8FrQZG9+C9OTBfPLZDsDI1b6Fji12pTAjm4cz1X17VI3FPyfDIoWK6PACsfYvyiLlE4LsEQbrX+kLSIoKZnzciCif2Kir4i1IVO6I4ugbqSMbwZ6ZmAaH0D9U8UEp/qZ3A2pXw4pN/oAtPtBeHziJBMWCukTEd/ttlEwyuvAy0xPwUipfYk+4/+BmPIfD6GzsEVN2cpq7cWvf1iZ28MPRWSfqWugk4avNdrUxqz4FvO8fNmQqBTOS3yckXhWXwdlJovIlQ01dBtLggIEdb7tZjgnxR9jdVjamSKsSlYYpjuTSsAvClDUPYwa7CSzbmGJmzpEQpuT5hcIwgOv3hmX/ojDqeS0ZaGJUZJK/WR1nlTuRT+ScN/dWFMwf1SXdyMdiHDWB+pEDZIV1e032Nla5HqgWZw/o2mauuufzRtByI6HyFVPcjiFpUwZ2pfOB62iTyWM47nVI3sih6mJ9pf5B/iHDo0kn18Xr+e/Wqe71jPfxHuVX3ihmmdfSXCnZ6ksYWvtFd/uexBnVoNPSd4ahtg/TrEamIu5h3zm8xiNdaqLmHPgfRCz9hL6X7/Z+Vg+XVwenn2/iu
 +GFSZ0st
 mpCKbznDqnVgJR/LwGaKrF1skjJQomm1ENltECQNgIxDJLQv1N6fbVwtEs+SZJR2m3JFWR1rDeUnhDKB2jVQjtchTV6xsYEy4AALmaIJCkOzqCN6+quE6YKxG0g1qTPwrfBwrcYp664Ro5HUrnA5rsFP7MiDb2Q7a0xtMMZItlCrYSuflJEFDzsAvjNedrnnvaHR8Llkj4c2d4bYI4FI2xdOvSGkfeo0Ydc+Hr2OvcL96pTM4wzNOFw7L2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> gup_test.c currently serves two separate purposes: benchmarking
> (GUP_FAST_BENCHMARK, PIN_FAST_BENCHMARK and PIN_LONGTERM_BENCHMARK) and
> functional testing (GUP_BASIC_TEST, PIN_BASIC_TEST and
> DUMP_USER_PAGES_TEST). Keeping both in one program makes the functional
> tests harder to run and report individually, while run_vmtests.sh has to
> invoke the program repeatedly with different options.
> 
> Separate these roles into tools/mm/gup_bench for benchmarking and
> tools/testing/selftests/mm/gup for functional testing. Move the shared
> file and hugepage helpers to tools/lib/mm/ so both programs can use them
> without duplicating the implementation.

This sets seems to regress hugetlb tests: 

https://github.com/linux-mm/linux-mm/actions/runs/30553882784/job/90909219578

-- 
Sincerely yours,
Mike.


