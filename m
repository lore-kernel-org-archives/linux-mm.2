Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28452C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:33:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4079D6B00BD; Mon,  3 Aug 2026 09:32:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF916B00BE; Mon,  3 Aug 2026 09:32:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF8E6B00BF; Mon,  3 Aug 2026 09:32:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F16C46B00BD
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:32:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EB651A06C3
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:13 +0000 (UTC)
X-FDA: 85059676506.30.F6EE967
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75F43120007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:05:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/CyDoWr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyP/Cdwf4PniO7raZAb+hbrsr712JwUYvH/yZlove1k=;
	b=XnK6QoI0JD43qqKExN3ap2sMdCjSepy8cR0t7OoC06KWgJ8DpzPGn5KgFoOGOqdWnYuIvQ
	nMjyczETZ1M6XNcxSlebkuMZAzDRlX+TzenKm3LQ8fiLL+ZR+nioeBZbYqIcL39w+ZUq/m
	GX0tdtWyvCkelDFfZONLNsKY507Jb3E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/CyDoWr";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755111;
	b=4EkycZezcMC2a6BiM+R5IVLDHP7LpEvCuvK2I2XylAvU/A64EApKjWLXRUCuVBBevv+Qy6
	cBltswz79i0FKK5ozwZE6xsuYfSaRaF/ITJnELTHBKkD1KmHS5u35WqiiUTpAWbMGPZtpT
	UW2G1lsGwoKVR/XDWiGpjZqp7oHYCRw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DD9360A9B;
	Mon,  3 Aug 2026 11:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27561F000E9;
	Mon,  3 Aug 2026 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755110;
	bh=tyP/Cdwf4PniO7raZAb+hbrsr712JwUYvH/yZlove1k=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=h/CyDoWr+dqXY2I6lkcbByCEhr+WWS3aEVMplzESHyFZDSujqYfL+SNEJRaITcaE5
	 X8OAw9vMFYO1XihYjXEdk/Nle+d9vshPp8vi7STfMfohs3cHZlvAUEKm4mK9qz4WzS
	 CVAOWOdLzUXuNRkFxnZ5yyKQ2ypbchzsqGlcTD1oiQao3Je2OE9uVvjpRLrvpEuFrf
	 CCVPqeadOcb8WpsupcFyUgHXVIzw1zt8q+0zVENH+cGiV7fAcmBQEpewoBuowxFJBC
	 MiZwgF4BJYINyF2I/nOPdimB+iQHlzlcAtqd2XdKB4P8OGhj2trcfpohKrXed9GI5X
	 BVPg28rIOiZ6g==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 06/16] selftests/mm: add khugepaged race harness
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
In-Reply-To: <20260802195254.1937477-7-kirill@shutemov.name>
References: <20260802195254.1937477-1-kirill@shutemov.name>
 <20260802195254.1937477-7-kirill@shutemov.name>
Date: Mon, 03 Aug 2026 14:04:23 +0300
Message-Id: <178575506331.1561566.172804163825999862.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 75F43120007
X-Rspam-User: 
X-Stat-Signature: 1psn1itwgydcb41k5c9htrpfcrbm7gft
X-HE-Tag: 1785755111-466731
X-HE-Meta: U2FsdGVkX18kdVRHV6PcnVfHaeTCVyOrjgeIMolehbcZYYjk8SlCkriaO8ZIaG6UVRUjJjh2IvmnUpO3WNTbt0h3snouw8tPIuNPo3z/OPxrswj19r8Fn8WDZwOlKPdN1IFVrd4a2jQmVkq7V7zpzGZiH8ju8XxehxvnmwjBLKvaMRwXGxt415sksKJp7xktZ1hB3t7v37H4SGBIo2CMsTGiDomPwByJRZF4psfSjVmn/c3QpoeehBF6PCI7zwMJ2Eaf7YGd4IPgmjHQlM2hrf311cEwh4s5s5pn7+Yc0QXULXlZx8uyPIjBH5KKdUgiqQMbd6u7Eqik2neZiEKzTuhFjIoP8rmngF3JkkV0ini3+rfWmmhRVXWGAyhX1P/0HL5PbaErw91WObu0JK0YUWICUd+Fv2paGPmTEFjN7i523FYO5sILMMpLL3qxUTSHoznTifh9pmBnBOsC+H5/oAV9vBtoJQBxXQ8tS+bPnkXABhHoKAyh7BlaUcY+auNdjKyb0Vd8Tp36CKAG2bwzpja0Prbc5fwJ4ekyEAZK54b5ZeJ/0FDWyxvrw+nXICvwcgbkMeoNv2yrKo4Twmm6BlWigx9TM1jWc2X9YWov6yRhdcaYwuVUXhsgDXIjpDuQUOThyLgyTad+RoE1SfIJrWTzG9inbIS4Ofy4YddmgD4J79MU0qDO6pfFqYnN2yD0Fn/RvOlb3AREg3Yqm3JOUlSt+VGgo+YoYqwejTW97QzVUXfk60jg1/XoDYp1CVZPQekXBPc6VWz0fSSZA8fm0Ih7eL9d/t1fvn/jkAgpdIJisRr/jo2Thvzix/C3sJ/C9Eb1yHnskjcK83uFLsxGTfC+5BW3vzVzbBdqvYL8gNX0G1J4/sUDukxRVCTzUKh8qnDJ0Qa7OVxunL91NU4jpR8HgLxuh4trNoJshygYfNAmzy+6xzxFSZqRFNQYxTb7+zYA/BZ3mrXAvq3OFuz
 ZeAbKW1R
 ZPaelCjCGD+atSRz5DDcU22FFQ/SnEluFaZr2T+JWJzfrIiG3VoqbGMVdWbFgmKJQ1YHJhoyCUf/Z2xUUtaqeaDFamVJlp4skLz8b0IlvzCTOhQMvIgv5/7p755xpKP4y8awvXuht/Sll1guwBOWHg1KfJqal4GSIT2B7qkhi95UiuYj+FobB5dFAKUfa/UZRqC5LPoGl+0AsV4GNhi44+MhYmKnwnRu3zV2MP0R4wZbd0MU1G8GjNIIThg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Collapse serializes against faults, GUP, fork, mremap and zapping
> through a protocol of locks, TLB flushes and refcount checks; none of
> the khugepaged selftests exercise it under contention.
> 
> Add khugepaged_race: two faulters, MADV_DONTNEED, transient FOLL_PIN
> (gup_test), fork and mremap threads race one of three collapse
> drivers over the same ranges:
> 
>   stepped   khugepaged driven one full pass at a time via
>             khugepaged_full_pass() — deterministic extent per step;
>   free      free-running khugepaged (scan_sleep_millisecs=0) — soak;
>   madvise   MADV_COLLAPSE + MADV_DONTNEED loop — the PMD-order axis.
> 
> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
> index 6f42e35b5227..a8b6b839cb97 100755
> --- a/tools/testing/selftests/mm/run_vmtests.sh
> +++ b/tools/testing/selftests/mm/run_vmtests.sh
> @@ -404,6 +404,13 @@ CATEGORY="cow" run_test ./cow
>  
>  CATEGORY="thp" run_test ./folio_order_check
>  
> +
> +CATEGORY="thp" run_test ./khugepaged_race -d 5 -m stepped
> +
> +CATEGORY="thp" run_test ./khugepaged_race -d 5 -m free
> +
> +CATEGORY="thp" run_test ./khugepaged_race -d 5 -m madvise

Please set the default duration so it will be 5 seconds for each mode
and make ./khugepaged_race run all the modes by default.

-- 
Sincerely yours,
Mike.


