Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 459BEC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 19:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8CD86B0088; Tue,  4 Aug 2026 15:43:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3E066B0092; Tue,  4 Aug 2026 15:43:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54526B0098; Tue,  4 Aug 2026 15:43:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D43E6B0088
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 15:43:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19693A0240
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:43:50 +0000 (UTC)
X-FDA: 85064612220.02.59036BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4B79C120007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:43:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tYyrcYU5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785872628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=InoaC7aRrB/aQ5R5WbCZ9FBzBR+fu6Rt3YL3UZFeJcI=;
	b=jCPIinhLt+HnC5UI2ZE7T3WexkUgsBu24rMklVZfztJlNziKPwFvs/2i2LvaFV5adVh2VB
	Uw7tCO8YNJCjRKw5xA8N/+heNsDgNQ6g0EbD2vVIkOA1MO/aZYoxc99pQPViKM+/jVblBr
	O/Say3xS3Fxvc6TAcj6G/4WVKhWnbH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785872628;
	b=336r8DM3CLQTC/YfDNxKAfPUk6ExuBxAZJjYy4VhSuLSMwxZGtxCbr8N9TeTtpDoqVwKuB
	qZYl0b35itIsudFepGWy4UEcIs80YAXW3Nbqu3r24pY8y38CMNlmUgT5GeUxdBqEw+3UVE
	Z64saZthIVfxu0l/wuhpjMNkWamV8Gs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tYyrcYU5;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6B5E442E29;
	Tue,  4 Aug 2026 19:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2448C1F000E9;
	Tue,  4 Aug 2026 19:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785872627;
	bh=InoaC7aRrB/aQ5R5WbCZ9FBzBR+fu6Rt3YL3UZFeJcI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=tYyrcYU5qjQvwTyu8VyXMz3Lx36L3PQmSZOB/npx+5K4bmADqOcJVdFHiiFI5yK2d
	 Ihen5TEl74Gwi7/vyQBMv9fy9fTB1orsbUk7yxt0MOi+VapoTwnDG/EptsKBZbsLLX
	 06Uk3IhYjkzTAL1M41p8iJhqRAI/ixLfrd0qIuus=
Date: Tue, 4 Aug 2026 12:43:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
Message-Id: <20260804124346.15e4be960ca4ac739f740248@linux-foundation.org>
In-Reply-To: <20260804122038.190270-1-hao.ge@linux.dev>
References: <20260804122038.190270-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: a7hchwz4dynkzsxwqiwdq9zpga6z5wgc
X-Rspamd-Queue-Id: 4B79C120007
X-HE-Tag: 1785872628-47244
X-HE-Meta: U2FsdGVkX1/NFYSRRR8r3DXyYkgaBxgcUuvmluA8jynKMUxBPy8XCM4fie3dkLqBvs9diLwLLrbrs8SB9qyNkV7p0ddcjS9MU1mRazmBxQPfSAMppznUxWpvArXvbxs7vHEWSWoG+kwnhSYxtJyJLqx5VC8zs/okbJQEitHdgH2yMAGJFQN5PTeP7IeNCk5rKBg1BJerM93uXgHirjNtqYNGcyjkEOB0fRvt153Cs16/trMIjTNrXEX8r4T9naVezbSpj9n8+nngduzEdHqYMxR3FyvecDqkxcnjMoxN64BJDe2XRVXllYCtXHb9h8rL/2lKmTdqh/RZfBbIew0qdBoWfu8jhBAfb/Cou26hCHUipKOfasRdR/pOqU6lfobcCm0xOkszzcK4XFbxsOrmjcfsvDT0qcpAgO25ZgmCIgui+ZqHmi27XlCa78nwMVdKtkyyKRIYBe53miPpa7JsawqQ6WIsn6XQjseB97DV1y45Q5oYmvcLXasmSqHB/6sLWFH4LeDyZQqsBzoSPm09HXjlvpxK31b3HGPDlglrjhbIDPKTqi2XFAMGH/y4vNzPKjnjMbDBNLtWmlvHNRWFeOpP2Q0HLKC1X/2u9za0L3TFkm8Eq9fRtLqdXIzn8/KlvZgptiSwXLV0shQXsZpcEsC8mZC2i3n+xaX59rsuaJARIou3SjEixt0j3Wom1Y/x528mBPqX1rK1J1W0T9ELKjpCF1fbkYVq6NGHf6QPwRJU1F5vKFbP/C56VGaZ0lfmh10vl/L7WF5sAAc7C5AXabje9+IODXF8urs/O+gHYdGR8mRdrUBvcJlYlPzFTqmoNGWWCNVt+2T8bWu4hqWyLdixtkKolxxRkYwhYe8Khw2L2mh1AL08VLw8lDK+MBLustobY/iJ2dap9QGcsRW8arAe2soyH/Mje3xdfCd1bk9rOr8YG3bT3Qb5AFm3xhkv0ZT3LPzErKTyXaIVYbD
 7Jg5wjKd
 w3nTUx5unZ5rA84qQbM+6Z7YdF7eBCSXPqm1JF3YYrROvgwJ9kw8/QemAW5IbF5RKsV/KZ24IcNmeESnozSU6q3L31aQar7uvi/O88vekpPCHH4LJW3V6kcX9rQr+nP45N9xLQQ/scvD/0us8YQMJk3F8zi1aLQJL2g0WdPdSQjcAZYaVJIpoOQJ2ReAcJGwHyb3Dw3EJX8/i8lCtZdQWgc1qTRrZsiwiDop+ptlqY96GTjfhEZYtvNiACyS7fhwMbd7aHg5nxfoCNXhiBwBxbCeSxY9L2dE9zG+GWOayqVHDYHMSAz3Wkz6MDkfyIXLopn4hkqV8LOuDbJK46Alp4RMtDKVdopAvpWJ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  4 Aug 2026 20:20:38 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
> 
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
> 
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
> 
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
> 
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
> 
> Remove the mem_alloc_profiling_enabled() guard. Also return an error
> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> the mapped pages would never be reused - shutdown_mem_profiling() sets
> mem_profiling_support to false, so no future module load enters the
> codetag path.

Thanks.  Sashiko pointed at a few things, one pre-existing.
	https://sashiko.dev/#/patchset/20260804122038.190270-1-hao.ge@linux.dev

Is there any sanity in there?

