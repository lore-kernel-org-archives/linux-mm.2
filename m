Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DABBC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7664F6B00C8; Mon,  3 Aug 2026 09:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73E416B00C9; Mon,  3 Aug 2026 09:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B486B00CA; Mon,  3 Aug 2026 09:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3D16B00C8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:34:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76DAE1606A7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:39 +0000 (UTC)
X-FDA: 85059675078.19.AA475FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AEC21180002
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:04:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMmVCiB5;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hp7zTybQm+mhJAOmq6bcq40GTnQfmEk+v4OwIE/uVhQ=;
	b=gkWuccz9zIQnQL6Y3thxtCmjuRAezMonjXyBLqFDP1RDgYC3bU5z0vIWcKo5jKj4hjtcdE
	zxPkAQhk02nTqxnMseFZmMJ8YxERjMLSB1kljOIC0ah1G9aD5Q1BJ2LCeMqAjlNU+EW+7S
	alaomuOV3jmyS42us7+CfgJmULBIA5o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755077;
	b=i9WnwE4RK6YxTxTBMJg3n1ZDYbqxL90jR/BdJD4JI7U1KfpuU00kGba7PxgkuLk+ZC6vWq
	MklfwenMNmdkU1xuNkR/298CNDf0ipJMqumfRuub1Z/qxWX59zpPyOGWSWlLJ9Kic5+5r6
	bapeKEhUutDlGy9mJslhm9fwZ3XuZAI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMmVCiB5;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BE0ED406DE;
	Mon,  3 Aug 2026 11:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9924C1F000E9;
	Mon,  3 Aug 2026 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755076;
	bh=hp7zTybQm+mhJAOmq6bcq40GTnQfmEk+v4OwIE/uVhQ=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=PMmVCiB5ZCcTFUg9590+cZFq0NC623ucq0Yv3SR5aFPDWWOoWLQK1SQ5auxZcBrsE
	 iI/cYCUI6qWJoBbo9we88l2JCOmGLNsveFXqQVwDAKA0uEE/OkyoUOzLA1F2jZhyIU
	 fENuy/PG0sfJvOdzQ/RVrc96m9MPLUh0uVIva682LQsMcrWo6nJQpjKh1ZgYIPuVpr
	 QXKb5gCr0Dkj/qvRuRtejUbJJHG6IdtBsyj6WfuBgmekGLigeCr6+B/1jD/nLFP4TE
	 gUFVwTqsiYCha8/1n97UtkllzZt7WUYhF9kmM1O4/o7ARat6qVawKabzlGaZxAYnwy
	 5gwXhHkV1jaUA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/16] selftests/mm: improve khugepaged coverage
From: Mike Rapoport <rppt@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
In-Reply-To: <20260802195254.1937477-1-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506321.1561566.145327646496245621.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: t5nw61k7q7nps89xufjnaysx5zhpztyf
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEC21180002
X-HE-Tag: 1785755077-964239
X-HE-Meta: U2FsdGVkX1+MLZtZ4jRyLWN+44juqalGaO55no4Ky+SbIuNHW6BSZSS3auxJCVVAYsJiiZ47k2DO6umE32NcfiwzJJ4aTqaoYVq3vcFGIKDMyArVrjlrBNBm7v2eQY1U2AbupB336YabwTsA3ObZR/DiRJ4MNpf/xDB04sxZrLiE1AiFPPQRecsK9j1+MOfBz/6uyPXftorkfiYDejcr63+NtUBx2NjiWa33jJan1NhWd4faQSCmr115kkHbdFi1MvBQYVbmSv8ZJTZb5FMAp3RVKlx5KA7oDSF0io6LcrKl5vtFD+sdlrjUazw9t963Fjne1lNO1DbSJJLlqMT9LkgHuHF19OKgTo/T4bEHLyawjBgKndObrX1dOcVkbGbRI1mKgEjPi9ImcNDkructHkBcQCVwo84t9YYDBgsUwGDlAv1ev2A0Z4T6uFFxR2tfDDe00EzeJddQSYLJIA5nYdQy6FbXMajBVg/DJk6MAvN9OpBHJU76EEy/7p6xWroGCqFRkCOH1kW5KdqVuvSL3RtwjmC3TfDvKGFrhUwGqQa61z7PNXJb+HPnmk/s2hv4gNmC9HKfUT9fdpbga41r8gi0Onlur8Ajac6ZawDIDZYALB82KjLUwWqwVy5zwORBvvO3kVEYTHh4VP9talX8m1FyhR9sA9WUY264pW+yfxkC42QaEMwLcNzzxHTj/QLqTh23X9uSjdRjxEXW9CK+cNSwYwIAn+KEWu5b3GSS9P6l5VNL6QEfTXcDwEHCX7PZcJpGy1nQw2JjYTM83vKGXZQKUbS0ujUhWENSS0jFkWdYCMCF9s0DvcjlirRkvTfAkzxrXQPKmLnasIlpUyeVKDfwdTkCYfuBRI8uhXoVmAjvttsR4Z2foh76nmhPLX/6o4W33J5lcbhFoX+82ohuDNvFbkfWZgvNMiH7IsVz8Kiet+M9EwkKG7w+omb6MlHT2R4wNpYPm9TOAPaVpNv
 jQKpx05D
 qSzToSiN5sldQ/9qHeI73RnHMVfR3dXoLPgD0ayJXeMQFfXprFfdGo0dSCbfioRTlSGKU06M5dfuS1hgGmu4O8t7AjA5G+13FPA2hcHiu0vwbX9WfFQmvxL3q8aXZM3c+xkuzJxpY6vWqPZ+jfCS79gxt5DfkIzLKhXRwHtGMYO6tAocleL1XkF3A2JBesJ56lv4rmY6f2vI7N7755HjL+CCPzAUcKqhSfRZNGtS2P/tT28T7bUCI48Bg7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> mTHP collapse went in for 7.2 with no functional selftest coverage. Every
> khugepaged collapse case is PMD-shaped, down to the detection: it reads
> smaps AnonHugePages, which cannot see anything below the PMD order.
> 
> I am also reworking khugepaged's collapse mechanism, and that wants a suite
> worth trusting before the mechanism changes underneath it. Nothing here
> depends on the rework -- everything passes on an unmodified kernel and
> documents what khugepaged already does.

My overall feeling is that changelogs need more human touch to be
parseable.

>  - vm_util grows folio-order helpers: is_backed_by_folio() moves out of
>    split_huge_page_test.c, and a range-level form asks whether every
>    order-aligned window of a range is backed by one folio of exactly that
>    order, mapped head to tail.
> 
>  - folio_order_check validates those helpers against the kernel for every
>    anon THP order it supports, before any collapse test trusts them.
> 
>  - khugepaged_full_pass() drives exactly one scan pass through the sysfs
>    wake path, so a barrier completes on the daemon's own cadence instead of
>    needing a short scan_sleep_millisecs.
> 
>  - khugepaged -o <order> runs order-parameterized anon collapse cases: a
>    full table, only the populated window, default max_ptes_none and
>    max_ptes_none=0, and collapse upward from smaller large folios. Any
>    order up to the PMD order, where the same cases baseline the PMD path.
> 
>  - khugepaged_race races two faulters, MADV_DONTNEED, transient FOLL_PIN,
>    fork and mremap against one of three collapse drivers: khugepaged a pass
>    at a time, khugepaged free-running, or a MADV_COLLAPSE loop. Every
>    racing page must read as its pattern or as zero. -z collapses
>    hole-bearing windows; -p adds pageout and compaction, the only threads
>    that elevate a source folio's refcount from the reclaim side. DEBUG_VM,
>    page_table_check, KASAN and lockdep are the other half of the oracle.
> 
>  - A shared-source write race pins the CoW isolation contract: a co-sharer
>    writing throughout a collapse must not see the collapsing side's pages.
> 
>  - Four tests fail on the environment rather than on the kernel: the
>    collapse wait is a fixed three seconds whatever a huge page costs to
>    build, collapse_compound_extreme wants a 512M page from the fault path,
>    the shmem cases want a PMD-order page cache folio the page cache caps
>    below, and the swap cases fail instead of skipping without swap. Scale
>    the wait (a 2M PMD is unchanged) and skip the other three. This is why
>    the suite now runs on arm64 with 64K pages.
> 
> Tested on mm-new (1dbd7c34bb92):
> 
>   x86-64 4K    105 pass, 3 skip, 0 fail
>   arm64 64K     87 pass, 7 skip, 0 fail
> 
> The skips are structural: sub-PMD cases decline at the PMD order and the
> mixed-source case at the smallest order, and on 64K pages
> collapse_compound_extreme and the shmem cases skip for the reasons above.
> 
> Kiryl Shutsemau (Meta) (16):
>   selftests/mm: move is_backed_by_folio() into vm_util
>   selftests/mm: add folio-order check for VA ranges
>   selftests/mm: add folio-order detection self-check
>   selftests/mm: add order-parameterized khugepaged collapse cases
>   selftests/mm: add khugepaged completion barrier helper
>   selftests/mm: add khugepaged race harness
>   selftests/mm: cover a shared-source collapse write race
>   selftests/mm: skip collapse_compound_extreme where the PMD is too
>     large
>   selftests/mm: skip khugepaged swap tests when no swap is configured
>   selftests/mm: verify synchronous khugepaged driving is attributable
>   selftests/mm: race-harness variant for permissive hole occupancy
>   selftests/mm: add memory-pressure threads to the khugepaged race
>     harness
>   selftests/mm: parameterize the mixed-source collapse case by source
>     order
>   selftests/mm: zap whole PTE tables in the khugepaged race harness
>   selftests/mm: scale khugepaged's collapse wait with the PMD size
>   selftests/mm: skip khugepaged shmem cases without a PMD page cache
>     folio

I'd put the commits that update the existing tests at the top of the
series and than add the new tests and infrastrucure.

-- 
Sincerely yours,
Mike.


