Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3091BC55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 15:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBDD6B0107; Tue,  4 Aug 2026 11:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46CDD6B010D; Tue,  4 Aug 2026 11:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383536B0112; Tue,  4 Aug 2026 11:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02E106B0107
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:33:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CF911A01CE
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:33:11 +0000 (UTC)
X-FDA: 85063980582.13.E2AF636
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CA11C10001A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:33:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3oNVVsx;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785857589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+B2tyHlxtOIYFFAEVjuBTTR4kj9wHrzaGATG1AU1+pI=;
	b=NlTf1STI6zZz/usqfqMJkVtitRlAZypBoyWODPkb2rFMvzXNns5UpOFVFYX3gNPj+857ih
	dJ0LuTADHFfRPP1j3drad2DL/DgKQ6rKphKBQS3o2WZTT04VXROYM2A7cJdKS6VBiSXRkI
	zPUD/G10NzmzBxF+OHaxpU61fJsub2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785857589;
	b=N0iImJ5XOaeYLw2W1nWvCj2d+SvWChmHFVeB9xE6bfe+KscxKCDlft9whR1Sdyj1TJ6fNS
	EtLyP0BaQ3IEeQUOZYWrxr7oPAw7/FyP0aTn+1W7KUBwzfK+f1M/CDvssANsQ3YM3YA2l+
	hzAkvsTDx7xL4geqIGxc56HI0sP3Rcc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3oNVVsx;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EC5EE43AC2;
	Tue,  4 Aug 2026 15:33:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A651F000E9;
	Tue,  4 Aug 2026 15:33:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785857588;
	bh=+B2tyHlxtOIYFFAEVjuBTTR4kj9wHrzaGATG1AU1+pI=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=R3oNVVsxuCEWsgVHp9L06whtvAu65m31eI7YTUDVmBGTciHjhmbGlv6QUnaWentP6
	 iKLvzeiIIVg5Ghu1QbNkxlP7j4IS8pCBYrP2hqN5M3VwDO3VNlOGkYXUJZbP/QqIUY
	 jDQEIQqJorCqz2ZmxeN9MyAQ4406Pc51zTU7Sf3uVL3FNPQ6V/gAqkzY9x567zrxhM
	 bfstcUfhbLbTZldGnVZ+Xe+REaXQCRTAtHrfQNoDSivsMH8GjVZgEpiFVsUhWgRs6D
	 Kj6Ww6zTa/zxFhnYHtMLGQpKCTNtF/CX24S8/PBlYm3B3hGjvCYaLeiw9n/12iBL7O
	 avzTCd2u4JoOQ==
Message-ID: <2a4423d6-7934-46b2-97da-a20c372b0d17@kernel.org>
Date: Tue, 4 Aug 2026 17:33:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/3] mm/vmstat, mm/memcontrol: add _monotonic vmstat
 readers
Content-Language: en-US
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
 youngjun.park@lge.com, hannes@cmpxchg.org, roman.gushchin@linux.dev,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, rientjes@google.com, kernel-team@meta.com
References: <20260727162550.2032-1-usama.arif@linux.dev>
 <20260727162550.2032-2-usama.arif@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260727162550.2032-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: n4wweqahk5zabokwnw711mftd341qgeu
X-Rspamd-Queue-Id: CA11C10001A
X-HE-Tag: 1785857589-39180
X-HE-Meta: U2FsdGVkX1/pG+FerpxtylBI6a+DD60UeSpabBICe5PybdwYW8KFI1XMLyYblz6Z9CFZJ/RSWeleDLvZUF7Sc7QR1t90wq4KomcQO/Pj96f+9G9ybx7O4So/6LuA6dTtxRnyBd4AfhqrqIUXtgN9r0cuCO6KxES3xaJMeRyaLz6CcNIQARP2ODeIeDV+vBa5tbfiV2MkuOYqk3zud5OPWjBm7F36VGQRwaLD9EiO58CFRUgtgxxEY9ZfaW7MfdR9HknwUoio7+rngWWYv9fLSXs5otm1EXwu2QYT+HwnrXYkB6RLmlpJz2IXVSkHlOQ7l59zVgLde4ApiJiW8oBANl+r2SL6POIjyFc2Ysz00xk+DZ/8ODkllIyerQszEjEWg4q3R0o3TFPbk22tvFm6VFyKEre8NeEvmpRazfQY2Tfqp70I/ZocPiinpwbN7SLwprbVpFgwRibOR/m6U/NVnY8iBD+Pp2pJdlRiGZJOVFLI5ESdXWDX8ODXXE1bBMWMTGtzcvpo6Asgjva12BNS7LZgiojC3hW3JETHKg8TsKKCAFyCyZU7g57BL4vsYBs8lYKBq/1BOXMJPGFEdfP5hv4JemZgqKu4zHUNsXGr516tt7Q2usYaDgbbJESEqpEWjtO2ZVMUYfZeNVg63mhkz/MtE9Aiaq6M0FSOgcMmFUbvkqGnFFDJdj0Sx0GBGRBnStnndtaTXATcb3TxzrXJQXzcq2P8axh26tFG0m2rqPOSpAunNWXk1iXr3XNr39oSJOQOybjNvdIMj0FLT6DnDgwWbaS3cn9cVUpTF1JLQorskw4p++PFqU7ZGHjw3AcRt8CGjCRGTQrHlTUyN8J83GVYnOy30YbtXRAw5MFEEAGMsXU69GLlvCQyRiNx7IRjSoiJcYWdjPXfsAsLB1yjAFG6HyhRIYrLiTBQF3D1jV/LPWanxhefeoGDN8ObuNhhXxNcHMFUvpKjQPGDS9V
 f8A0A46W
 BHpQT9fBs+evk0udUyYEKF1VUy0gWRRdHqpOXS5u7t0Tw3bA1w9xDd3D73dy8GQBA1upF4HUC0mMtv6WtLs6dlE1majd6d/wx2Z8EHD1gzJd82uZAJHBm6pBtYNTv8j2sDFTTZlLwBkhfb9L0CKFy9TWlxmCMDnA3AOPj0mIitgBFGKr545S9pFeDOboItTYAPn5cmfS+JhYqyWDPKjH5JieUdvWOraOzcrBLVHv68jPRCFJuihiBPwXqAzhZsJb4u6yaRNCUftvmAP+t4oYPDqjoo70ZfUmhlZffWdtSw26vkvHb/sdDTUN3tmFGArnzo9N5ji3oTREjrxm9WjVzcc5+ve4U70sF8x+kM3IfmaPFBj3Ek3D6OOiSk6qt3HdVVE/opWWMZ24w530=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 18:23, Usama Arif wrote:
> lruvec_page_state(), node_page_state(), and global_node_page_state()
> all clamp negative reads to zero on CONFIG_SMP so that a transient
> per-CPU delta skew presents as zero pages rather than
> as a garbage unsigned value. This is the right behaviour for
> non-monotonic page-count readers.
> 
> It is however incorrect for callers that snapshot a monotonically-
> incremented event counter and compute a delta from two samples.
> Once the underlying signed long wraps past LONG_MAX, the clamped read
> drops to zero while the previously-recorded snapshot still holds the
> pre-wrap value; the unsigned subtraction then underflows into a
> ~2^31 spurious delta for 32-bit architecture and corrupts the
> caller's accumulator.
> 
> Add non-clamping siblings that return the underlying state value
> cast to unsigned long:
> 
>   global_node_page_state_monotonic()
>   node_page_state_monotonic()
>   lruvec_page_state_monotonic()
> 
> With both samples read via the _monotonic variant, unsigned modular
> subtraction stays correct across a signed-long wraparound as long
> as the true growth between two samples fits in unsigned long
> (< 2^32 on 32-bit, < 2^64 on 64-bit); the 32-bit bound is the
> practically-reachable one that motivates this helper.
> 
> The variants are only safe for monotonically-incremented counters.
> Non-monotonic page-count readers must keep using the existing
> clamped helpers so transient negative reads still present as zero.
> 
> This is a prerequisite for a later patch which
> replaces the producer-side anon_cost/file_cost accumulators with a
> read-side accumulator in prepare_scan_control() that samples
> monotonic per-LRU vmstat counters (PGROTATE_*, NR_VMSCAN_WRITE,
> WORKINGSET_RESTORE_*) via lruvec_page_state_monotonic() and folds
> their unsigned modular deltas into lruvec->cost[].count.
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


