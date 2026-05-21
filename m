Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC962CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:33:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB8876B0099; Thu, 21 May 2026 19:33:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F7A6B009B; Thu, 21 May 2026 19:33:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCCE06B009D; Thu, 21 May 2026 19:33:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD1076B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:33:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79BB51207A2
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:33:12 +0000 (UTC)
X-FDA: 84793030224.11.5B7C992
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D66D0100005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:33:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B5hOJ1El;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AivDyEnvpyPmjIUTAgHTmNXJVE2IywT0hdhO6rhqLEk=;
	b=A3dNihG8L1IPN6YeXckBmjzo864uBUG5Q30OQWMjlx84q6pIntDoEtffCvqu7hMpPQttWl
	jTDcWWbD9sb41+nGZ9J5IPtoxKUzj8Angnnrk789TeqpJ6aiWHFDszX/Xccyw+jxi6JFzF
	jKGXV8Cjd0b1Oq8Xlom1ODn10QUJNsI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=B5hOJ1El;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406390; a=rsa-sha256;
	cv=none;
	b=LLwg9r3JKyr9Fit6NMCHYLMmCfwFnb3KqeYOSr+BA21MJWOcWO3wQU+SGPbCYm1Jfmzckw
	qO7On5fkg3xYi4f6XJPehF+xsggPUt3d9CpVpvyKJqFvn7N4UxOLHPLUEvdsq3xHyj+Veb
	wMjJTJznBRptsg+8jRiemeEIzvGtvcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 510E160138;
	Thu, 21 May 2026 23:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738DB1F000E9;
	Thu, 21 May 2026 23:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779406390;
	bh=AivDyEnvpyPmjIUTAgHTmNXJVE2IywT0hdhO6rhqLEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=B5hOJ1ElllrFrloQ/p0k7RDgdXQc1ysB0bGPCNT9A7VTOG8AvvaU2KUKcZ1blYarq
	 4KnL0AIvmVxxhgHg9boc5OBOlAz8JjPaGwh4C90y1ab1EnEwd+5W/ekV0Cu/NiuLMh
	 3UQ8B7bK/3I4KDPEjTx0H4U1zc6pyHYVFUXC1d/Y=
Date: Thu, 21 May 2026 16:33:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stanislav Kinsburskii <skinsburskii@gmail.com>
Cc: Liam.Howlett@oracle.com, david@kernel.org, jgg@ziepe.ca, corbet@lwn.net,
 leon@kernel.org, ljs@kernel.org, mhocko@suse.com, rppt@kernel.org,
 shuah@kernel.org, skhan@linuxfoundation.org, surenb@google.com,
 vbabka@kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] mm/hmm: Add mmap lock-drop support for
 userfaultfd-backed mappings
Message-Id: <20260521163309.c5cc5d3f6cf16bac212cf90b@linux-foundation.org>
In-Reply-To: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
References: <177928604779.589431.14703161356676674288.stgit@skinsburskii>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D66D0100005
X-Stat-Signature: ddsgp4jq8t4568t8rr5crqtcsid33p7k
X-HE-Tag: 1779406390-801692
X-HE-Meta: U2FsdGVkX1/h+BFLfGY7FpqM5nq9uL3XF2dAfeRa62FoeEnpa2Xav02g1kzgd/LdeDb8lRnT8PeFcLz0D7k7dMStXSVEWCj1hjFt1jVvClZojbzW49QFX2VqSc9H6zw0ILem6Kjo50JMKrBOX0qFCenBJPfuACP0MHF1xRcbepJ4YBX7TZJFOw3NWaqoB6RMUGc0K3te3gqqBihjPwry/ltTh/fS3Yi4LtZMe9dzdjbHvXJ2CdTxZsQYcMYe0RokSEoe0eHYMSQZeXF4B9zchOXYR86vwOAKRiuT5fEZQjzE0/yOun+YYwIj8Om/wxCXn2fGc1PZx/uZy0TF0ipP63hD8a5JvkLewqLht9NbYYMHS874cifv51x1beURtc0K4XkWFSU1wH1Lz9jL00DeSydZF4EIly3mhKaknaBteXbIHSjLl74IblHlTYV8kVnsd4igYQz02HFht5BL4+pfYhfi3U6LL0hVeBBRV8D70tW5AVjuiiHTEmNGfHu37zL+jWu+1tjtJYMNka3i7SYIZZ2DJ++tTvC7JdpnKLH/P6X1Wmv09mGuhwcTCK7Pz3hom0fq+edS2XVJVfXoopkJ9swRsVuvZAAlPWbzJGjQmgoyWfJslIye0ZbyJ3JODmU0vzZN0QpSOjvnaDRIKHN2bd1XsNNnzguDG8LCTmXNJsiHnyulS/yO73OD7r03WFlrdI+wxXG61iwxjkmL5K4qZmvkn7FNkm07xSDGy/Yjvx+BhjZIyl+us0036VPHT8A9CN95AbfPFubm3ACmaNXAcwCAD72AP/x2UUnYJ+G5vjen7x/py93iaacCtWJTtIxPvFWX0ll+EpDJsblrUwwfh6veouy7LnZOy/ZNQRj03Y99HKveiEgSUTvjOZc9Rt5X5f0zMKcI0+MG2ODc8TxT+KgkTbpsIKTvQjqNe1LaoSzfnB3FUCvuKSt9xSY20lOoGUksuGjfcgL06ey75vX
 UmdeQ2MU
 /0HC9yP+8uXMYJ3Slsxtq8ns8av2u30ZNuJ5wqx2N+5hNb4a1Hz2Kk/BHQknZeCX3H8p3tn7wQQbS8jAmgU9jqQ9uA+J+Mtxi7SrPpX7F+OjzoDROheyd7h4NQxCMGCzhfbkUlqRpp8uECEAmYFD82L8125wKTzIHt5UBBw5Wz8lkfKfyIhqpHph9qENO2ow3wgcXrAnCUtS1sNc7xiGVChlRj5UtAlS02r4g/1Fk4E2QwZGqcnuwWyUuaz65WDRCyX3/7hV90q3Ebq1J3nSUHHQj/ZBIKa4hj5HffW4D9edSkXws0PRzNOtL/CWZpGIAllelFmnz7KJ72VW9gBH89KX2zU2PMP6F9OOXDHuAU3/kgYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 07:09:19 -0700 Stanislav Kinsburskii <skinsburskii@gmail.com> wrote:

> This series extends the HMM framework to support userfaultfd-backed memory
> by allowing the mmap read lock to be dropped during hmm_range_fault().
> 
> Some page fault handlers — most notably userfaultfd — require the mmap lock
> to be released so that userspace can resolve the fault. The current HMM
> interface never sets FAULT_FLAG_ALLOW_RETRY, making it impossible to fault
> in pages from userfaultfd-registered regions.
> 
> This series follows the established int *locked pattern from
> get_user_pages_remote() in mm/gup.c. A new entry point,
> hmm_range_fault_unlockable(), accepts an int *locked parameter. When the
> mmap lock is dropped during fault resolution (VM_FAULT_RETRY or
> VM_FAULT_COMPLETED), the function returns 0 with *locked = 0, signalling
> the caller to restart its walk. The existing hmm_range_fault() is
> refactored into a thin wrapper that passes NULL, preserving current
> behavior for all existing callers.
> 
> Faulting hugetlb pages on the unlockable path is not supported because
> walk_hugetlb_range() unconditionally holds and releases
> hugetlb_vma_lock_read across the callback; if the mmap lock is dropped
> inside the callback, the VMA may be freed before the walk framework's
> unlock. Hugetlb pages already present in page tables are handled normally.
> Possible approaches to lift this limitation are documented in
> Documentation/mm/hmm.rst.

Thanks.  AI review identified one possible issue, possibly a duplicate
from the v2 series?

	https://sashiko.dev/#/patchset/177928604779.589431.14703161356676674288.stgit@skinsburskii

I'll take no action at this stage, shall await reviewer input.  Please
poke me in a week or so if nothing has happened.

Which is quite possible - things seem rather hectic at this time and
we're almost at -rc5!

