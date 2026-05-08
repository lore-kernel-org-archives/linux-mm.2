Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73365CD3447
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 12:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4B66B0152; Fri,  8 May 2026 08:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D746A6B0154; Fri,  8 May 2026 08:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C635F6B0155; Fri,  8 May 2026 08:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B55956B0152
	for <linux-mm@kvack.org>; Fri,  8 May 2026 08:06:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3CC6A1C07E6
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:06:19 +0000 (UTC)
X-FDA: 84744124878.29.1B1ADF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 46E09100004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 12:06:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBLSxfAU;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778241977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xnk+V7QssBiF+qQFhiJ6Tt94gTmAFlECsOvJkRyRI9I=;
	b=fBu/JzZmFH2WsUxlJAAYxwfi4WkZRZ/PxZ52IrIz1t2eDbCMsERpk7ifGynMm2N1HzaWaV
	TKtIBAPf566tmFQWx6d5IiyQD1Um7T0GTujIi2A0LA3kjyJdjM+v3/DPz47cYShubbpv4Z
	+7FBwHUZC+noL4ZHYL7xtQgKmHMLhNM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kBLSxfAU;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778241977; a=rsa-sha256;
	cv=none;
	b=tcfCG5Qgwlz/zJ/oisBKkSfb75HRgsn3qsWCwqLD83fQesUyGQGRyKDksSc/XLH86fDfZU
	JoXLpI6FsQOVqlepxL8mcU0bahMgaY1BHFGQpnvlL2G9kdWjTDj0d5S3lS4ZSJoE9vQYQP
	Tqd9oUKL3pmMxxuiOCRP/yIrToOtVL0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16BFF4442F;
	Fri,  8 May 2026 12:06:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E33C2BCB8;
	Fri,  8 May 2026 12:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778241976;
	bh=MR4bij5BjEnDk9LrKzig7CrCbig2NohASn13eEOT+lg=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=kBLSxfAU1kS/0AtX8wqwCfxoY5F+x5fc9wQ0BALrSlew8+78rhbFUu3HiNmlNMPWN
	 acHIbB4M3SailIR2wHEYTyBHVTrPogo6QsSLd0tnMvvtUygZXR/nT2oE6BKt58ECnL
	 6g8eauuXi3CpmNAPK/y8tLhiSsPLMwzmrGIk+z7mYS++qhtItSGdTHIlr1gDXeXMC9
	 h79xDOLt6Wv1q95Rs0O3+GBBUbaFP/EvpOPSBy/bLubDnvLLK1+0TiDDHsG6EPkmqB
	 CYJhwA0RSI7x49iH7zQmqd/3BB1l8elosRqkH/C2AAiZ6M4WiTnd47s6dCdoi1w3u+
	 0GFbeTd8vFJ4g==
Message-ID: <f76750e9-765d-4988-9d8f-af11711b34e8@kernel.org>
Date: Fri, 8 May 2026 14:06:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [LSF/MM/BPF TOPIC] Towards removing CONFIG_PAGE_MAPCOUNT
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org
References: <c3bb0140-942d-49d2-bdc3-210b55435356@kernel.org>
 <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <fe6afcc3-7539-4650-863b-04d971e89cfb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 46E09100004
X-Stat-Signature: z53cr5ry357c84sjc4t87fdsk9mwj4qc
X-HE-Tag: 1778241977-533769
X-HE-Meta: U2FsdGVkX1+r73Ok65wAdYP5gP1dpCUt+f1TFpTdLemlz67mc4akdUpfs4Kkk3CHgBCAc4hhggqyD/B/VIzo2aDTObsJT+SXORHFPbMr2L3tmswMxQddAu9LWDD25gfkZveUw/GOIxTphGXCfurgWCe9RgoifmoduTQB/Z1WvOd54gRBOsX7LdqGyUygqG3A7R2wx2YZwHoGnDMWeI65uLBHl7iP2Js1IqSrqYwoAQXP8BVUMlFyhvJFWg/YPJKFRCjfLpBUGwb52+KjgoP1UEK1l7IFQ0VSigAE0A0LvWNPT6NKpxMwUj6xUtm57euzeinE/kSgs1h7HDPhoJPQwJtYABZ/rzQCoGiw4imva8dyGe/8fnwYpDcwCnXvVGcYEk3bl8PH8EReikCrK32jOqYKsXMCJq5rVktodLHOYT2AkBWMFijNFzq6fAh1QyGmVQy0vfzUh56ivcVRFODUQyyV9sZzkO1z5Ikf7rrCZsg7M1l7yEtMeeMsfxyAWZYMmgc+SthVRsbCRwkBhpfh4MybyOHdLHLiUGFaJhdfVOMwpQGsC3e8WPN8ZKp0p2S8WADnIC6oivPxwpiD+R0xYU/Ais0RhC7QUXXDc74Z4yemXVpt4WBkS587TNsucz6lvbCNNdATIzY120lttnW3yTWR2vbTRn/46MiJVmGdktqPlBwL6Jxa8lu6HKJOOYytQhgtZOeS2rPfG5Dy3fq+w2ZygQd+xnYaXlIyffOhscXajHuIdrMvu2r6DyPJt/EuQ7F0mG60OVR88MzP8btk97oJJTBfg5qEgEfCfoVLMYx1txHCkG7QWDbK0L+ypel9shDqFBTP6RbtyUHxAhMkxYN66YvOavR3Ie4Rwl2pzYRuuI54cxCrVrsQiilR1Zu4iLILOZL4K4ZsuyoopW6XknYxCq+9tGI7EzQ9lgo2x4DimXW4w3tu+enRB5QOw66Wkiz6Tqvnbb/u+t72oKX
 e0DhtkfY
 YKkopKh+lOnMLDgK7wzI98hKjah0YjadgRcECo8/oKe6SsZ4/DlHlD2DqmKHdq/cc6UZVai86YXgW+XWHnq/q2eHFOEcomcUre54CPojrEnZAGsfo9cnB1zexwhQHBiv7GQDIxe3Tb31Hu030/85RkhRYr8iYap2cGSKnSo/pXNIuFNMkM92aQSJ5jnoXMatk0IoNGyaAxOhngcTcYKYQ/YGyz/Y3hoit3SnKzj9Y2WhnDAJv1nWXU5N7aUOaSqSd3dCbYDjAyZkH4vEuJjNB1+9rX7fDutLSfWpNgO/XDg4RpyOaqAVP5F5gcY4f6RrSlVAj4iZATwq6oAvzt4u1tmy15m5Mo9TIKguoRJIZWZT6mhyNCUfviwOhfeNWe+3+WWqHkkKJO9YaV5xMOyBXBSOq6VXkM1/eEkxrmQP/ClhybWeZr5yJtD6oced8u6EcJ0He
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/17/26 22:04, David Hildenbrand (Arm) wrote:
> Hi,
> 
> although I like mapcounts very much, I'd rather prefer to not have mapcount work
> on my todo list.
> 
> We now have CONFIG_NO_PAGE_MAPCOUNT in the kernel that doesn't touch any
> mapcount values of tail pages, which is great. But we still have
> CONFIG_PAGE_MAPCOUNT around, being used as default.
> 
> 
> To make my dream come true, some things I have in mind are still pending. In
> particular, I want to:
> 
> (a) Support mapping of folios > PMD through PMDs.
> 
> (b) Get rid of CONFIG_PAGE_MAPCOUNT to stop messing with
>     page->_mapcount on tail pages and to cleanup the rmap code.
> 
> (c) Better detect partially-mapped anon folios with
>     CONFIG_NO_PAGE_MAPCOUNT.
> 
> + some other small things.
> 
> 
> I discussed some of these challenges at LSF/MM 2024 [1], before we had
> CONFIG_NO_PAGE_MAPCOUNT. No we have it and we can discuss the next steps.
> 
> 
> Sorting out (a) is fairly easy once we removed CONFIG_PAGE_MAPCOUNT: we'll
> primarily have to split folio->_entire_mapcount into folio->_pmd_mapcount and
> folio->_pud_mapcount.
> 
> Sorting out (b) requires switching to CONFIG_NO_PAGE_MAPCOUNT first, which will
> imply some imprecision with large folios to:
> 
> (1) Process memory stats: Pss + Uss accounting like "Pss" and "Shared_"
>     vs "Private_" in /proc/$PID/smaps and /proc/$PID/smaps_rollup
> 
> (2) PM_MMAP_EXCLUSIVE flag in /proc/$PID/pagemap
> 
> (3) System memory stats: "mapped" memory like "AnonPages", "Mapped"
>     and "Shmem" in /proc/meminfo
> 
> And some other smaller things. While I think that all changes here should be
> fine, I want to be a bit careful and have a discussion on how to tackle it
> without realizing in a couple of releases that some use cases still require
> CONFIG_PAGE_MAPCOUNT.
> 
> Sorting out (c) is a harder nut to crack, and I wonder to which degree we care
> and whether I am being too careful. I have some ideas that I want to discuss.
> One idea is to just remove the deferred split lists and let memory reclaim deal
> with that: but that one might be discussed in another session I'll propose
> around the deferred split lists.
> 
> 
> [1] https://lwn.net/Articles/1013649/
> 

Slides at:
https://share.daveh.de/s/bQsDpD7xigJ6wD8/download?path=&files=LSF_MM%2726_Towards_Removing_CONFIG_PAGE_MAPCOUNT.pdf

-- 
Cheers,

David

