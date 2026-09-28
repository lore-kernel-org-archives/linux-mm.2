Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB2C1C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:53:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD37E6B0088; Mon, 28 Sep 2026 04:53:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84446B008A; Mon, 28 Sep 2026 04:53:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4F416B0092; Mon, 28 Sep 2026 04:53:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B55C6B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:53:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 20DA880148
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:19 +0000 (UTC)
X-FDA: 85262556918.03.A6A89CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6F85AA0005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:53:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ur5AWO7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790585597;
	b=4WUqvfPl0ZsftuHUCZPDwuLM/ajNL7ZSa36lNKxxsmUVBgXXxYcQqGav9l/SYy8kG1LyaP
	WPTK57/metkM14+cZvlq3RM3cFzZvtP5wC0SsC/Nko7hbq6H9CZoJsnIWdNByb4rE3TRz1
	QdOx6AqYOdtTut+GScoYZ773D3slRAc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ur5AWO7g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790585597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oMRlamwZOS6UGMnR7RRChBxeZocxPHKpOSIJpnFzjdg=;
	b=8QqKdt0086gIgrFnfpy4wz0hxrbsDnlBT15G7axzHFqskYYkTRv6jizr1hYCCMUHl1aZ3l
	xLy1K1L2csblnvLFrOeYukRlkwXOScxO7HUYdcl0ag6nglu9J8H/oW1kFvGM8Wuv74LREj
	jaZIxBSvXFJsD71EAdGDhavCfv4Pmfk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B45B560052;
	Mon, 28 Sep 2026 08:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667411F000FF;
	Mon, 28 Sep 2026 08:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790585596;
	bh=oMRlamwZOS6UGMnR7RRChBxeZocxPHKpOSIJpnFzjdg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Ur5AWO7gR/EbdOkHyt0zSPjUSRWOvbKnLYxi2SIB6aa3Lw07eZbQcaaveO8dbyFIz
	 DxgDdE8bYmMTQ4WUyFOsPLtcPgv8pFsJm0zacnNwDrh28AwA9Wg24MECYdP9hFx6UU
	 GHMKZz50SFXq25g3V+T/EJTW5jrgDAkIXbHevcRV9nsvgJsPc/cenqrQXtcnrEhgRp
	 6ISbEj8RRVQ1c7Nursl4ntsqbuRirELzECvjuVl2L32LrD2kcSOc56KipX1QBUb6QV
	 kSrBHlPE93sJHrOgFH78l4HvnLJfZz4NsP+Ally3Sxvx2ml3kJBBgbEyDc6rB5NqHE
	 5FLJsz2UFKDig==
Message-ID: <cf0d7426-0838-42ea-b8b1-f694546ecc25@kernel.org>
Date: Mon, 28 Sep 2026 10:53:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: uffd-missing-wp: add GC related
 functionality test
To: Martin Cracauer <cracauer@cons.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, peterx@redhat.com,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <arneZ-KkRWUNI0Ho@cons.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arneZ-KkRWUNI0Ho@cons.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 7wz154sdq1dzdgmxmkcdqpb3ka7o9pru
X-Rspam-User: 
X-Rspamd-Queue-Id: 6F85AA0005
X-HE-Tag: 1790585597-585517
X-HE-Meta: U2FsdGVkX18h73OWzaUVpBhIIC7MydwvxGMMPdRDqHHC6POMvQ1AH72KqC9sQxuD+l91kgFkrMVe9yHWFO0Qfxp37Hk2lOI093jg0vaBrmOdCnOdcca6KArCVNnQSQ0yC0RUhhVbepNGP2vsIEvRCrwhu1pX49Jep1rhfzNZPbCiKe2JJ2L8773yJr52qjcNt/gyEE4wFw/OB7AbYTWUo9bpCulXDrgaq9yM6pt4Fn8YyZwknaGqi9r8AX0xxtEiPmXnu6fnUr8NC8UMHMCHJzHNrp8zplSDVFzTuxGh/YoGmY7NJqf6NMuMHIi88kMNEGUsTD1SOMbDDarc7g4XMZs9LqiQ99SpgJg8l36EQCcD7PxDoxBYGcW3qUf49yVYevwvgswIZsBFdYYMmmld0kLugyS0KLzev9vL9Idxfr2uSQqTvh5M3Pb1zILAO+QJPb6vn2mBddlXAJdVHeKKuhxrZadgbbNWK5RaZNjnOVP4LymPCB1mQWGcENlX24RcbOgh8x9q8nnL4mRQFfmxou6Hk42Cl+ZcjFqBWpqI2xy8gnNCopxg+cwXVdkRmCl7fnx99nZpGhF8OHDabBtsJNip4VMJGBKFhmQaSZYKB36zJ2ub/Tby979VNFwzdPSbPRSdBsnX86jQLoesqxSiTJgqVm4gFRSrntP1Fj4c1jqNEo48pM8moV1/6Gzmw6aIuO4F1lK5xuZx2G/3CpchTPT5m2mNN2/7UXS1T3YOr4uOBQneThE9WgnNgZBQqNNaoa397shsifI/h5FA+MkjRWx38tyGwOMaZTRcky9AKXbq39yaPJSBrGJbaqYvoTNONSV+EqzRPBe6cLjz0cWmz9vxFwmX7KFzFiUbPy1nUvldnWuqsN5Pk6Po0ZBUiQYXtGp8EDiHkW312rGQniUDSJYlWS7GKJzQKr1hFF+3jJjXWZ2v1I8hOX3r9a1PlVGYWAClFkA857e8nuJHQOb
 lKfu5rJT
 UL6CMTeFshFnCiS2JbSKPK1l+whqLgdFTktvUc2/UBZ/ltYiXcm/cvJSNpUDBwn+O2UXHPRM51xv5OsmSYkTW7D1PiJIVovW/HDWClXvVffoZynujUMMri2V8dgm2VH87dxfyF+upmW1dB9Zjb3umuXzlYFheDzyM/HjBmFA6Wsfo2u4BmnkeTQOuDOzqWMInL1UIgV/x8qU06Ln5tRF6Ngyn+Lymq1N5im2DVqQpCWi9NBYaKEYqdOUL4cWcFFw4Dtb1gtj/lEWPZaKJ2+WV50Y3BEgz+wAYWEveVbIhX2Baf8KbBRwz7FAJyf+FQtuE2wXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/28/26 05:26, Martin Cracauer wrote:
> Add a test that asserts that functionality needed for generational
> garbage collection works.  Namely to implement a write barrier using
> userfaultfd instead of using segmentation faults.  The planned target
> is the GC in SBCL.
> 
> The real GC will initially fill heap pages by using on-demand loading
> of pages from an image file, either via mmap(2) or using userfaultfd
> to decompress a page read from an image file made from individually
> compressed blocks.  This test doesn't do that so that it needs no disk
> I/O and no decompression library.  Instead, a fault will be filled by
> copying page content from prepared pages in the heap.
> 
> Assisted-by: Anthropic:Opus-5.5
> Signed-off-by: Martin Cracauer <cracauer@cons.org>
> ---
>  tools/testing/selftests/mm/Makefile          |   1 +
>  tools/testing/selftests/mm/uffd-missing-wp.c | 413 +++++++++++++++++++
>  2 files changed, 414 insertions(+)
>  create mode 100644 tools/testing/selftests/mm/uffd-missing-wp.c

Isn't something like that a better fit for LTP?

-- 
Cheers,

David

