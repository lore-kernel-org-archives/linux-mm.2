Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D53BC43458
	for <linux-mm@archiver.kernel.org>; Sun, 28 Jun 2026 18:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1E2E6B0005; Sun, 28 Jun 2026 14:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA80C6B0088; Sun, 28 Jun 2026 14:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C98536B008A; Sun, 28 Jun 2026 14:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BE0B6B0005
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 14:13:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1DD9D1C62B2
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:13:34 +0000 (UTC)
X-FDA: 84930119148.17.7CA0C0E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5294C100004
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 18:13:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Oqd3Y8q4;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782670412;
	b=AUbcc9dSBvd1LVjwI9UMlOC0Ho5IHs1P0uZvstUKjuyEJZlsW45XBtIAsHAB5fBbZ1W49H
	YMVTm/vmCpjFiiCNOHanNfJ77jjfHdVadHaQjGzr3mGeWUsWzTnwVeyhs519Px0nytktUW
	VtWXmLj84xZooDnlxeQpxdlY8ChfYfs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782670412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nG0zSS7NrnTDyRmwSClrih85J+cAN99dOSGVHcRqmTk=;
	b=1UqQt/aM/0VU4oKTFT08MbPQ5CMivq9C3hW4BGYq2FEHewbGOhMvafYIER3F6QrqlyAao/
	dCH5smobB+wioUhS7EsWES1JebKQBSVhHfJ0L3KqeB9rF5i61eNxUpWORx0R0gFdJ47/0U
	Bwk8UAeFIdlyrI/6gynwQSs+y8WTR2w=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Oqd3Y8q4;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35F3E43230;
	Sun, 28 Jun 2026 18:13:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B4E51F000E9;
	Sun, 28 Jun 2026 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782670411;
	bh=nG0zSS7NrnTDyRmwSClrih85J+cAN99dOSGVHcRqmTk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Oqd3Y8q44w53p5dPo+HSiY+O789+71l/eF/6i7QZfQma4KphYiwC0JJKlq1aMcGeM
	 RZYQ6NH17VeitoTeIR37DA64FdYdQBrwCzoZe9FPWnCOo5hnK87os5SneLHh8NwYnp
	 q3sx3xVAWLXtLz3rIqiGIht0I1/0vy7n6ebfiKWo=
Date: Sun, 28 Jun 2026 11:13:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, usama.anjum@arm.com
Subject: Re: [PATCH] selftests/mm: pagemap_ioctl: use the correct page size
 for transact_test()
Message-Id: <20260628111329.9cfcd9c67925869307020aba@linux-foundation.org>
In-Reply-To: <20260628101118.35861-1-zenghui.yu@linux.dev>
References: <20260628101118.35861-1-zenghui.yu@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5294C100004
X-Rspam-User: 
X-Stat-Signature: 9z31stu79y16onbb5cmyz1x14qyrhk9j
X-HE-Tag: 1782670412-741930
X-HE-Meta: U2FsdGVkX18A9kvq6X9C+Y1DoMPlkwCDdXRa7cx9VBJCnxf3BxknS/0i0F6d2di8VWrkexQurnk43edpcgrQn9l5mRYHqXiFXyrE5CABBHDoQa3boZEysbiiyippuo2nwzEdZBLoRzhjfHsF1kt+MchARjkoTomcRXwTEmj8MB85XKON2X4vLw0faKJWeFnyw8rizBHIWrFSRU3eipRnk10krRmSZygSYj76tJUwn2aqVCejHbWdV5BoMEDPF850NU+NMjfTzeVq4/GkwFPF89Sw+txGK9dagFdiWWAB9hsU+vamuLyL6FUb/TFD2TlxnVaupWA7hNCE1DklGiMDl/uMqSEgFUTEFNys7tsMiE/k2h05f/9XxQwNxpFzxCSL8uqReE358LQ8McJ/C3aABSA/672ELlT2KFOl2YOVQmZjDIv1uy5H6Fe9y6egFD0REpFVww0CzSpZIGU3q/6/lCUpS53qOXCnZPWpG/Gwvow+rLQkJtepMW8gFOklPxi2QwpPgqs7pDaiJlnf7rPyZNZR/mcNzl5pN+eTCgc8dgWQSlWOw34nTw2kTn1bfG8G7b9obGpodcY5yqSZhmw3anCipSoaX5dlGCgu1jo1EQGgqU3jgsmGbXm336mW8ODbgcwSpoEgRvD7v+C8hS1GYgo9I1/lEXyuzog6nx4A805+tM5eyWuenOBT101Oygzv7FNNE+1w9iZmsxUpGx6XNNiqfnPNRhlAOnhMzUALHO6Po+6mexNA3S66w7B6uAMMvRaPpi0F2p+ByRgPbOjs3UpB322DJepCnDCFfNyDdIN7cUBh/n8KkF0mxI6sQS8bYLjHkEJsx7xIC5ilVpg3KdXnK+8HVo3E947aZ9e4CsVshTTyoyoNaggh6UDrt22mWeeRE4YXT+kvYWpVgti49nbRe9cGHOCAWWFV++RHbWf2e3MTHMlkkC/wCuM9VLM2fMi7XP/E5v4Hhycelk8
 AsHvDHqd
 XT7439fikZwPPq1IooY7qhxKPjR72qQ/8d+MX4Uzdv5qcyqnp0smrropLQOt6E7H7uRKPs8sCaD29B3abrtlvWydISuXOI4V4OzcuNIBGkG0nvsRNUi6jeapBJMMfXlD5OuF9QLwHpmYqCvR4ePsp13KS2dI3S/kqpAf0rqzcNBMQMXXdGpJVfThVzF/JMwMV6m0AwcGw8C1ONVE8oL5V5DrVdzGnbivauTI6fvE+JiqHs4fVRjyeKzPfX970iLkIgfbdseFalPVZO8+YITg45TSgs8wSw5YVKjWPriIUHOmp9go=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 28 Jun 2026 18:11:18 +0800 Zenghui Yu <zenghui.yu@linux.dev> wrote:

> There are several places in transact_test() where we use the hardcoded
> 0x1000 (4k) as page size, which is not always correct for architectures
> supporting multiple page sizes.

doh.

> Switch to use the correct page size. Otherwise ./ksft_pagemap.sh on a
> 16k-page-size arm64 box fails with
> 
>  $ ./ksft_pagemap.sh
>  [...]
>  # ok 96 mprotect_tests Both pages written after remap and mprotect
>  # ok 97 mprotect_tests Clear and make the pages written
>  # Bail out! ioctl failed
>  # # Planned tests != run tests (117 != 97)
>  # # Totals: pass:97 fail:0 xfail:0 xpass:0 skip:0 error:0
>  # [FAIL]
>  not ok 1 pagemap_ioctl # exit=1
>  # SUMMARY: PASS=0 SKIP=0 FAIL=1
>  1..1

Thanks.  I'll add a cc:stable to this.

>  tools/testing/selftests/mm/pagemap_ioctl.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)

I'd like to see this code initialize page_size and hpage_size before
calling init_uffd(), hugetlb_setup_default(), etc.  That won't fix
anything but it's safer and saner to get these globals set up before
doing other things.


