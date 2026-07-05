Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C84C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 03:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C6886B00A2; Sat,  4 Jul 2026 23:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44DE36B00A4; Sat,  4 Jul 2026 23:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 316A16B00A5; Sat,  4 Jul 2026 23:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D38FE6B00A2
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 23:36:20 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B2D11405DE
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:36:20 +0000 (UTC)
X-FDA: 84953310120.19.7E4CE22
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1DA03180004
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 03:36:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YBUQTjDh;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783222578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yaQSA+c0eA23eljol+15gGGuS4n86bu1Vd0UOzc/IDQ=;
	b=PaJdBAyXHS8CDJHsIjZTlnHdYy4xuwIcWhg0hGXJ3ZY8t8KH2Io1pqGZfW4GaLjgW2IaHX
	FNT+W9ZNDKsurvTZ4TuN9e2s4mz7hanJckpR30ZfZUscNJOjfGrik7uweSvnqeSXmThsJU
	qoyCuYraUmlpotdTwvqPXy0CB/Vt8QU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YBUQTjDh;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783222578;
	b=Bx+0ajHoplothvP70Hd9PmWBDnCharBiXOhcoakc2aOv8+y0N8FtKlaAfmNb5rV3tWaqFg
	lrpVs0LL+DAz/jvmDazA6npjDBdFESSGq8uBAKJjTC5b6mSBuuf90tzgkyFEWryu7iDT7T
	HniOBM8KF/Tb6pZKZ8+SCvLtYK5nZEY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C1625437E7;
	Sun,  5 Jul 2026 03:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67F941F000E9;
	Sun,  5 Jul 2026 03:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783222576;
	bh=yaQSA+c0eA23eljol+15gGGuS4n86bu1Vd0UOzc/IDQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YBUQTjDhhzOUeupzNOcNLQVaV7ok5XNKQiPZmnd7dn1uC12tIQhuww1Dr7hrZyusQ
	 CP3M8KaSQ4YSlvfi3+ONT4YcWNwH3Ptk3q5sVLSOTZIRqvufJH5CiL4SFV3X6UoYF0
	 3qprjiMzvfHQHPQgcEMHSZx8v0qYZCI5acxY6kxY=
Date: Sat, 4 Jul 2026 20:36:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Yijia Wang" <wangyijia.yeah@bytedance.com>
Cc: "Shuah Khan" <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, "Muchun Song"
 <muchun.song@linux.dev>
Subject: Re: [PATCH RESEND v3] selftests: mincore: fix the readahead check
 on large base page sizes
Message-Id: <20260704203616.1ce10365e07c746f1e805cab@linux-foundation.org>
In-Reply-To: <20260703125253.3016281-1-wangyijia.yeah@bytedance.com>
References: <20260703125253.3016281-1-wangyijia.yeah@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1DA03180004
X-Stat-Signature: g7915ppci3s8dmizhrbfu5q3nex1cykh
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783222577-599759
X-HE-Meta: U2FsdGVkX1/bd6fPJQvUdXfIPtmInqM5t3yDLmASewuP13GkVkQt+hOp1mZQzRX9kQUew6vhxZSQbouXOs/uVy+M7xyeHok2WcBab1CUM598gPWQRWZIf1dmMfobz5aj+ZFCPgOutlhpHxVNAJ/0fEG+cpeIj4orMqa9NtS0uxJWzwExz4hV9T0eIrBnKrE5HKX/PklrVWLJeES6xkiR9G6lFPeCAfpxM5FQYUM9IUuX4tQOBxwgd/8ViyqhYSvFFKHmQMA4ruNQx/SDMgVJ3KElhVYl6PNLNQBKhEVnOAfLUhalVuKiFMrVVUMQuF/ePVvMOFg3Z9ek5QvV6lIBR6fPJesQrqcLA9FRxSgVQQbvIBxk/+AASFF8IP2yl/84lM9GQPIw2vGETBCNLwPhe4YdzvBi7HT6vkqmm5VyzLJaDoE4gi62LF3wxtk+tzFdxQQj1hZlTMO7WFbyucFYfPK260L0JlI1PzImvJfBErdTnCZ51CyJAqjeNa/329cSLskC4YHf3g55t2NVY6xcXgWsslir4mJXZNmrRnkg2N9bpMf0cQXYWLwFzcXew5DzOlWNK/OfKNHVKQQ8uXEK4Hicl/RT4VeqxTvHpcd352FcmXLdXTSLadFI2MrRVI+jxsBOWDMcu7lQRDySMOXo9yv5uAyWcSYoxGXlGFnkz9VGyGDuNxbSTxeTD36tyAvf4IAnBc9ErM7w7S4bbuWjOj2AJ5tSkHAzJFwXU3ddfYAjgFZ8nhJecnBscZjwAHUCaQE/vsjiwGG0v37NwVEzz2e9iMLVtlGHiT98RjDuV8iVNISah5cR7jNHWGxCC4CVEG48XgHS2ZtHWKr6kex8O8YthPpC+zfuK4uL0+lAQk2KyQOHIVkccU0yOFMIkQfDZ6cqaPQKuQjrzhao28lHzEdoJOgoH6mMkTYCFsWpAP14ElliWxV4aEBWU3DC8odAio5JJ4Q7xSdmXV5ZAUU
 XcAyASw9
 rGKnqz9LYYJScEtjCD7O1WgZcq4O5+Q7EArBKrWfad+5qfhNR46qJLe6fbNQcFd3PR5TpvugxtspkMCoxTvb1d4jXsTYbU451g29A3d94kLexlH5g7ex6/chy9xLtdxWcgWNX73xANjREVRI3lQLbNd3RSDEIkkZb5S0HAUcMFgdRSmHJFHL+8CtPcdNm9HqaIqWZR4hqqW+wthFpNZxN/NO2z5rwqfliWx9HlOXGuUyhsVYU4j5meldCgYT3iQQujzs81KxpAUoV9El7kPYOq/loMrMAA+Nq8sWqIdfMW6Xbqm9f2sKsFo3zC5M144syhQqrqm3syOkZ+cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Jul 2026 20:52:53 +0800 "Yijia Wang" <wangyijia.yeah@bytedance.com> wrote:

> check_file_mmap faults a page in the middle of a file mapping and
> expects the readahead window to have populated further pages *after*
> it. With a large base page size this is wrong and the test fails
> reliably, e.g. on arm64 with 64K pages:
> 
>   # mincore_selftest.c:260:check_file_mmap:Expected ra_pages (0) > 0 (0)
>   # mincore_selftest.c:261:check_file_mmap:No read-ahead pages found in memory
>   not ok 4 global.check_file_mmap

I'm not sure this is a good thing for us to be self-testing for.  It's
poking pretty deeply inside the internal implementations of
kernel-of-the-moment.

Oh well, I guss if the test suddenly starts reporting errors, it might
be something we want to look into.

> The read-around window is read_ahead_kb / page_size pages wide and is
> centred on the faulting page (mm/filemap.c):
> 
>   ra->start = max(0, pgoff - ra_pages / 2)
> 
> With the default 128K budget that is 32 pages on 4K but only 2 pages on
> 64K, so the window becomes [pgoff-1, pgoff] and the single extra page
> lands *before* the faulted page. The forward-only scan finds nothing.
> This is not a huge-page (THP) effect; it is just a byte-sized readahead
> budget divided by a large page size plus a fault-centred window.
> 
> Count readahead pages on both sides of the faulted page, and skip the
> readahead check up front when there is no usable read-around window:
> either it is narrower than two pages (readahead disabled, or the base
> page size so large that read_ahead_kb covers a single page), or the file
> has no backing block device whose read_ahead_kb can be read (e.g. on
> tmpfs). When the window is wide enough the EXPECT_GT(ra_pages, 0)
> assertion is kept, so a kernel that should read ahead but does not is
> still caught.

Thanks.  AI review might have found a couple of things of interest:
	https://sashiko.dev/#/patchset/20260703125253.3016281-1-wangyijia.yeah@bytedance.com



