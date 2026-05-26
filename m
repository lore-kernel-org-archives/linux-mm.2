Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B16ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DD26B00CF; Tue, 26 May 2026 09:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F276B00D2; Tue, 26 May 2026 09:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 944C76B00D3; Tue, 26 May 2026 09:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3E16B00CF
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:55:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D52C1C02A6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:55:18 +0000 (UTC)
X-FDA: 84809717916.11.AF1BC00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57C1D16000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:55:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=An1vJ5FK;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779803716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TOZga64l4+qEI0ExolVv1Na0jB0MzxUaNAe9iBNorjE=;
	b=TyNIZ/Ki8XW64pVIjbGvj5oneMEyI0Y7a9NQ7ooBdCTe/3ay1yeUOejPwzLjCWQ4NOZpmt
	gDChuHQManOkam4wlT6L13wR8GGF+7M4Vfprr++KhezDu3WgrQrp/Bans32F3D9wQne9Qo
	qQVTb6xbCs17ZPxsIgb8umnSqUIx/yM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=An1vJ5FK;
	spf=pass (imf08.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779803716; a=rsa-sha256;
	cv=none;
	b=GKCoQfbMtM82a990x1Ai2uNtScnOdxrvtcRAe+bui0eU5GqFcyVv4Fpffefe5aASkSWNgG
	TaBFMXz0EE2eTqsqYVhDKQMwdtaB3XkJhBPyu3bvETJ/ZKNLsDlPbx1yqxyuNGxt5pXkW0
	WX61jNYLG/lE27+zKpD7Xl4RGaOSo2Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 66F814447B;
	Tue, 26 May 2026 13:55:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2265A1F000E9;
	Tue, 26 May 2026 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779803715;
	bh=TOZga64l4+qEI0ExolVv1Na0jB0MzxUaNAe9iBNorjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=An1vJ5FKeLsmfAD5GsMF3Z1DGYPftLx702IeF3mDxSfjO7o+ThuhicLgk51gET/2n
	 m0hgHMmcjFUh27X2n/yhXO8JK7CyvjnGNDgPGwbKNf2qz3kushFkfmZJp+h+DJ8x3H
	 i4lgzUz3fg1vJ26Icd1Naiz9sxry0wHmRx03wVDcqLdpsteWuSms45vFlbQoVR7SAU
	 v6Yw4NzeDxNXkxlwqp4JmQbARFmbFq++EHRnlRSt0twEgbTHQ2995HNlWauY1PS6/m
	 YCyv0BY5QXI7f+Ete1wlB2R4FJF+SzdYJHIVjefIiOopVzgmKHZ/SWURG093Jguiog
	 MoJqPSkx+uHsA==
Message-ID: <16b36b01-7da2-4ec4-aefa-f06216ec218a@kernel.org>
Date: Tue, 26 May 2026 15:55:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
To: Michal Hocko <mhocko@suse.com>, Waiman Long <longman@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
References: <20260520204628.933654-1-longman@redhat.com>
 <ahQLVgj8zV4xQRh9@tiehlicka>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <ahQLVgj8zV4xQRh9@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57C1D16000F
X-Stat-Signature: hmzf98kw8pdjquxt3c8r5neqw1qqpet8
X-HE-Tag: 1779803716-102944
X-HE-Meta: U2FsdGVkX189M6WWQbmKhZ1WreBMyr5J3p2nYPh4pwo3srkmcv51E/cEmp6nsSEL5xpKoMFmyZiShRYqv0b/fesUXskCkiXoiZ+sZdrQQz+SQCB3r5zOciUe7npyqBvaVClJHmr5jvG9jlGWpYrptuKxDk1/7QmMgVo+Ca3/a1ToO6SrGHPlZSr1snEOa4hZYShLdHE0URtmOHytQC252Va2aqJbe7vymaX/qJ9nWDJoEY4WAXQf0SBs6EYiIGak+4qMNaTqK+G1TSg/0HS2ouqfdBxBQ+PJLKFBWYHIVpYdP5UVfWxk6bnEIdVALT8QV7xWXIYrZSLbB1ZfoMn8wxZPIGam48bLrIoU3pbkAzrf5AQrHDiaDtyCK9/TxDHX6I2G5GGqEzH1XSEpBiasuJPih+pILK4oZEBZI+fuy7YMjOVnPOiyfT650meXRFUGWIyyJWF3e+fi4t1kwHx4L/Ze13xlkGbjV0MtvWXGd4E739C5T31VhuSWBKwbHIvbitdNqi7wUencXnD13O/7rlpM4wNrMCgkaz16d9knzl02ox3XVthko7umre1eiPXqahsyYt6uWTqgsfxPn53bJ8TUKyS0GcNz2605sIwWmZePIf2I0HrDRldzTJf/Ui7m6IFf16a7l9rbThoBOMCUKk+CzN6K7EBvDfUyxT0ZCFFUfdp7q2/W1pkeSWmZcs4KxmdRaTxs9DTbVLYIcsFMgHe8t5h7YQlIJ4zVNBkphc5u6SeNV6faOHWzPBxmLybevbxmT+igCyb9laDcFvqAjma/K+PB2vlWx80pWcqupJEALwAnUJA0zfIE9nFP2p2Xsg/JN9DSTfhXv8Pc9aekJrXzYJn2SG9aMaFRwgJBCerQOiu5hS1jyKMUqbEHfdY2ST+ZAk0wNAsNqtDsae9FAHBYRThBZXrbgtKsXtvcf+0TjzxApwPdOJYcQ2Iv/rCmTOC3c34Lhk8lsbxmm58
 v+q/TqBN
 cz2LsjSZF/tABYa2RWb3HyMlKq9iF+H2Or3V1/uemSNsmBPCs+Cbj5RIDmJKnV5joYsCW3amEgWPRC5b+zBT07BE/I+zcfwJtqAWh/ysHoH0eKff74EGazOYmCTcITOrg6BZg1/1VGTXWE9psdNplBCaQCVQdQ8Qz13qlVpdkTErKLc20B8Jb1xfYpWf68BvTa0siXvv0XyiJzvtrOktgDMyVmeoz1BcreBquwvPVb7hUT6uhIki4fy3lx4JgW08lud40fkFsW1ez5Z01MoQRq+Qo3iVn0pBBV3s6UIwQwykjZF4FBzlPFrs0Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/25/26 10:41 AM, Michal Hocko wrote:
> On Wed 20-05-26 16:46:27, Waiman Long wrote:
>> The GFP_ATOMIC flag is to be used in atomic context where user cannot
>> sleep and need the allocation to succeed. However, it does not support
>> contexts where preemption or interrupt is disabled under PREEMPT_RT
>> like raw_spin_lock_irqsave() or plain preempt_disable().
>>
>> With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
>> kernel, it is possible to allocate memory under such contexts by using
>> spin_trylock to acquire the spinlock in the memory allocation path. This
>> does increase the chance that the allocation can fail due to the presence
>> of concurrent memory allocation requests. So its users must be able to
>> handle such memory allocation failure gracefully.
>>
>> The ALLOC_TRYLOCK flag will only be enabled if none of the
>> ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
>>
>> Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
>> atomic contexts.  This new flag will fall back to GFP_ATOMIC in
>> non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
>> where preemption and interrupt are not disabled in PREEMPT_RT kernel
>> like spin_lock_irqsave().
> 
> Before we go this way we need to really be clear we do want to support
> raw_spinlock (aka RT) contexts. This is a big commitment because it
> dictates internal allocator locking that would have potentially a much
> bigger impact long term. I would go this way only after/when we conclude
> there is absolutely no other way and we need to have allocator in those
> critical sections. Now you have a single place which complains ATM

We already have alloc_pages_nolock() which uses ALLOC_TRYLOCK internally
for these limited contexts. So the support and commitment exist. This
just exposes it via a new gfp flag alias. But if there's a single user
and it's already disputed, we don't have to expose it that way indeed.

> without much of an explanation why this cannot be really handled in
> other way. Have you even considered any options to pull the allocation
> from within the raw spin lock section?




