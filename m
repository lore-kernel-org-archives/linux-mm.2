Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A2DC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FFB46B00A4; Tue, 22 Sep 2026 01:58:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D89F6B00A5; Tue, 22 Sep 2026 01:58:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0159F6B00A6; Tue, 22 Sep 2026 01:58:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D08596B00A4
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:58:41 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5AE291603D2
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:58:41 +0000 (UTC)
X-FDA: 85240344042.07.B3F0DA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BF3BC20008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:58:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ShZNu/nC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790056719;
	b=wVeDBLNcZY7Lry+UqTXyxW/Zup/1cdQji6qYdDnbwzc4OlxTBbycjatFOPUAkNWQJFAzRe
	WPLLIov1TUJyxdkuOmNBl2oG1e7gNnm3Iwj6j9DMXzK5upJ4UIlQY/KTKRz3RtAlDAs93N
	trzqHABwGY1zIk4x1ofRGWYWoeNFhe4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ShZNu/nC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790056719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ThtsqR5Wl7QxxCKokbSVj/6isgE9KJQAZrTvGvTnCjA=;
	b=7d7J8+4zh7bwq+aiD0PKnPy8C4/bVVfcseHcmXaCYe60uBPJ8kqHJeR5MuhZgByXSrbSN/
	1u/r8c60wVPOir+ze3buh21wZTfI4N76vhGadc7ZqHlFsAj921h7T3PFmjo0nENLaXiJQp
	4s58++EqwqaK2jznDox76AlNBmvz2VY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3FE7406FE;
	Tue, 22 Sep 2026 05:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E85D1F000FF;
	Tue, 22 Sep 2026 05:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790056718;
	bh=ThtsqR5Wl7QxxCKokbSVj/6isgE9KJQAZrTvGvTnCjA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ShZNu/nCoM9nE2bePF8ETpeKqLEOYSjbX5HcPFir1HgJe+CTqcFYCCijCZX1pdqIf
	 ZTXKxQ5PLfuLaX1yPDaNtKHGGEtuQ7nzfL/h20baRp69Gzyp4AsTlhiLm+oWE1N6WY
	 BQCWqkOGY9oRAhQ0rtE6IsWnHNoun4eKbixPrftWpFZW4rHNXJjZyCve6r706EePoC
	 4B7i9pixgtuZA8dBZd416L+o9WN6at1mCjJP4kMHJyLn2r1VR3+qYQUtBddqWjGmM+
	 n83SKl7RYeZho1oK0IIAFlzJLY7B+ewQN0OvYXiIDHGP9D3JYjgBILDGzQHPt+xZKa
	 hzCdtg71aG+aQ==
Date: Tue, 22 Sep 2026 08:58:32 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Cc: akpm@linux-foundation.org, peterx@redhat.com, surenb@google.com,
	aarcange@redhat.com, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, mhocko@suse.com,
	shuah@kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] userfaultfd: clear the inherited uffd bit in
 move_swap_pte()
Message-ID: <arIZCIiecnNWPtx3@kernel.org>
References: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919004630.1159895-1-donggeunyoo.kernel@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BF3BC20008
X-Stat-Signature: bz8tjhi4bbzqnqa9m7mcikdu94zcthok
X-HE-Tag: 1790056719-700420
X-HE-Meta: U2FsdGVkX184w/xbDJ2GcE3AGrv8S4KQjXp2H6Ka5nzjkxTr7wdgQVjCx1DLewjHynR1p/qB7Pnjc8ybGFvxtED2yXfrhwR8unriwR0hagTZ3uS7OEeA052F9sTNDkv6/0FpEUWX60PjcUT5JS5+kb+7G72lvmCvJjsXkeiRF9FyyJGK4O50cBgVeL4oM/EZ4QY3ysqVK/T7OBqsAloOxHT0KBIbDoYuygRe/D5TcUizbL5c2/NlaObx8Oa9vc6gH0Ad2hYxWm4SikRJAvekNMBm90WBeJwDOmJsi2NDXOjKmm6v75oup7pHZkq7NmUS/Lm1AtZzxEh8cswzAQAXEe8Bigs7+x+P5qVIlxoZaLxnhHUL1Vvwax8Wlvgb+cg4ZIJadYxWtXTbPzS091OUha3z6lqRH4dz4B4oxz80AYeDtn+BdPKt6IIDuNL2xKOFYbVgxAF3hlWcFjRoVnbUMKupepy0Jy3XMK689LcqeK860FlSIsMNg1JLjuQPqPa2Hy7UkkeRQKoF6SY6ziR4aT2l6+OPrg5yx7oISLcWOcDTXiUkEuhiYc7+9nOrlNiqjeqEKHSt8W4sPmzVrie2UnmLaqnyt5OpKB3ySInAdnL1onFQiajjdThF+b0FtlW5TQNmKx6lR2qEziUzw5QAwoSL7N4tOpFApJOoPN5whPnDfI2OnvrAL55BdOWJpud3F0GBJZelK5GcI0/l6cMvSQt97BNd4JzFzYSxXpq4bQJ6xHXNmLSaPlvEn4FPq2kIij+EmmT7VY0MOsrQr8YWnMAIfRoHB8iI/xuBix/r6heFbT3I9zpAUn/TuG66/KF5sNxlnpEaBEpBaUSIGJa+zIVa2KEx0NfTD5dCmoOuavRi/CdEMW8PYoi5UajxhCXkWthvJpSNmlLRlnI1N3dVKQ1NH0qeP/dVIXhmSinvWJgv/OVbzCvwItokse9vtgVe/2Hcu+a0fMeJ1vCbPOb
 1di8tsl0
 2mxpWNeVNkAe43P/47AY4uN4mMdf7IH2m0s7bYsjcVTu9RJKuwyh33LXvPKtLpa1AS1UHeJniPINu+6gLy1Pf2ECCR+WmXeImrBAgw704A1+Q7dvZJdGje8g+OWBcOFrUcog4aSjdzHiGrYgoJ7M5MpSJJ1wpXj+GpAXPLKrmHl94Kj8l/U5iRMm+qOk5S28GeGRsCt3AsmaFpdQiEXFEHFrvLjupgPd/G3d1UcgK7oPGCHtvapK91o6FVazuCjjApsQ2F5srfGn6uqeTqn6aYHZjDEdfecw3Wbsi5lGStBYWOte9TDq6UU9AChBFh158NymtOUC6lP1b+5y0ywH8R3peDcU7v9UVim7eJDW6J3W+hUbTX2J2IIt90behWxyXozTuBIGRjzUztmnq7Y6pUZz4qt/A65DssoJwnWsD3A69kS4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sat, Sep 19, 2026 at 09:46:28AM +0900, Donggeun Yoo wrote:
> UFFDIO_MOVE on a swapped-out page installs the source PTE at the
> destination unchanged, so a uffd bit set on the source lands in a
> destination VMA that was never registered for write protection, and
> nothing clears it afterwards.  Patch 1 clears the bit unless the
> destination is RWP-registered, which is what the present-page and
> zeropage move paths already do.  Patch 2 adds the test that catches it.

This and changelogs read like an LLM generated text.
Please add attribution as per

https://docs.kernel.org/process/coding-assistants.html#attribution 

> x86_64 defconfig plus USERFAULTFD, TRANSPARENT_HUGEPAGE, GUP_TEST and a
> swap device, under QEMU, base 17e7b8eacf4c:
> 
>   uffd-unit-tests                    before   after
>   move-swap-wp on anon               not ok   ok
>   the other 114 unit tests           ok       ok
>   uffd-wp-mremap, 38 tests           ok       ok
> 
>   pagemap bit 57 at the destination  before   after
>   swapped page, dst not armed        set      clear
>   swapped page, dst WP-armed         set      clear
>   swapped page, dst RWP-armed        set      set
>   resident page, dst WP-armed        clear    clear
> 
>   MADV_COLLAPSE over 2 MB at dst     EINVAL   0
> 
> Donggeun Yoo (2):
>   userfaultfd: clear the inherited uffd bit in move_swap_pte()
>   selftests/mm: add a test for UFFDIO_MOVE of a write-protected swap
>     entry
> 
>  mm/userfaultfd.c                             |  2 +
>  tools/testing/selftests/mm/uffd-unit-tests.c | 61 ++++++++++++++++++++
>  2 files changed, 63 insertions(+)
> 
> 
> base-commit: 17e7b8eacf4cac800a4fc89a28729df72a2dabda
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

