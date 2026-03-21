Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15E65109446F
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 18:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797AA6B010B; Sat, 21 Mar 2026 14:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748EA6B010C; Sat, 21 Mar 2026 14:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685A06B010D; Sat, 21 Mar 2026 14:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 56B476B010B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:07:08 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2101A13B2DB
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:07:08 +0000 (UTC)
X-FDA: 84570851736.19.68243B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 70C612000D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 18:07:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GKB45+XE;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774116426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rufM5jb95qhcyDHjRHSR1ql6vBEuN62BC2d3gVFP3cE=;
	b=HQRa83VUy+EG4ElOXFWv7WYh/WLhPbiOVzk7ObvOCL0lTiwHBdSIDASfT4GZArt+xmtkEP
	jD7or1/FrP0PBp3Z9hQFvzilmY5XqoO2OWT7p3ahfiuPXQj16wJ648QmxCztDQf8ED4LY+
	seLo0kxq1+q2esEdz5uv6rBxgCU4HBE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=GKB45+XE;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774116426; a=rsa-sha256;
	cv=none;
	b=c/rLXWA9djx4WjIpJ951pOF1foMwsKSspPuxs0sxTzJUTmSVW02XcO1q0uV23nVQvRDofk
	9PwueO5hVzu/Q0uwbSsGBgFpiXZguemn9B04JDecQ2KJmbNbOj+haHA0mA63tq7cy1Jl+5
	UWvnMtCr7yLh4u7gRVSV/XX7yxoDgCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D0BB0600C4;
	Sat, 21 Mar 2026 18:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207A8C19421;
	Sat, 21 Mar 2026 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774116425;
	bh=09EJ5wSY8jgrn5gLw6ZVvAqf4t1jD5sc2vnIlwoBfDc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=GKB45+XEBIbxr51OwwhYIK0VAEh6X7ah6zTa7cEU7zzcHsThCdGnjTE+7z7y9mavT
	 GmTmNvyU9WFuWZ9zHtqoL/28N0XIQQL6LjdFalyt3KmpSlzVgUEO9I5+Zj0XY6QOhD
	 +iobUx3qaj9jhk38+aZXyTETVT0WLsZ2qofpscU0=
Date: Sat, 21 Mar 2026 11:07:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
 <Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
 <surenb@google.com>, <mhocko@suse.com>, <baohua@kernel.org>,
 <ryan.roberts@arm.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
 <sunnanyong@huawei.com>
Subject: Re: [PATCH v4] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
Message-Id: <20260321110704.82472cb5b8238ce8a5f40bbd@linux-foundation.org>
In-Reply-To: <20260321075214.3305564-1-tujinjiang@huawei.com>
References: <20260321075214.3305564-1-tujinjiang@huawei.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 70C612000D
X-Stat-Signature: doz3o1cga53tt1ek8usti3ys87zjoc1t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774116426-5821
X-HE-Meta: U2FsdGVkX19wEfKyTaYPQfRVI/v50rEa3k2N6bG+vjwfoHIFdUFDIR1rkPLXfb/fhw/ammbtui/rEajgNQazH0zDj9utAjNErw8Uq15uwrD6Pk0s/WrSrIlWZbkkM6Kq011Qxim+nWkK6bvun7+ALtvJZoLs9l4xWaY8UK6Cpb+wZG1+WFkcyFy2uqZBR/6teL7nEiOWGRH0K7cTQk7xRrS3XgDkTzkRA/AXWGiGrjsaAuy4UuI8dh8HpalAlMVmWngaTrorPPMsJ0uKLy9TvzJUuvaMruvIlxLywO8lQf39051XY3kmPRjpyjO0jLeH6daUZXI2GiQTMhNoArxngkNdLN2aaJjtQPjvPP06cFTrdTC+k83ddXAHG3dueoes/vrCqxOBg/oqDv6zeGhtXBOa03kfEPccxuzc8GhCbqaa/fapgKHR034pUjNqPIJUvrspZpMbOPrFMk38oMKRIcVu/xHxcs7WNM1M2cWMdsXXRhxIV8vWmMXDSfxmeccyf0T7UWHWWEuPDKEJ4WUjqhaeEwIn9oI0Zf5S6rNi95xT3SHmjv6oq8qVrlJO6TwcPLz5qRGohciSDQELBKzUqEEhiCRpVGimFvtQs9v+mGEuZrmqD/ELyG91TmZIwkGLI8kS8CfjPdAWJVRltSbGsc22AShABN8/0byCpHbNOkGQqijtsjA5CqNNZOQeWF7hXP77JMykkt2GvEB56FCd7gzCQSk/pGVcEzzhJWEs7HTV/X8vMUbWuOCesm/wKeoo50IssaLAq3b6jV6qr3JPaRzMVRn7DWmqFuW2r2qV3uPk3d+7+Mkv0ZN1w/oHnkFxuWAjW96lUaBj06KvJM5VOaON9sLoe7sbtQLopAqrycBl+0KKHIm4weISJ88y/ThZnXLoU75CHVGEcPbme2c5Ip3q1/yk8BBYISTXECzQSu03cFRrNkrnEmUWba2HRHZtftwRnAJ+Z6UQ/zBsv3C
 /vA7UoBn
 7sdg25X3xD00AdNGwXjehwbUhFn1AD0aUCQk7+xWex6KCibfNv9TSbtLLy7GAvqudGc4FCdCcODUvOERkOoSqPofbKfz02O6zaxFjMi6EHAfczQIu9dMAzEnmHl4L4WbqLu/G3f1kgP2aC2uEdGvhr/Oascf5vuhjWDGKkXfbBgF9BO4w0muAjaX/zvCKWbZ+Gt6ne4bG38r9q9OwUoO8oMpwgVst58u2dSBXEu1NtoVC7EVYjfX39SB9j71252c3TRUZJfpz/CxlA7eCYawk5gdkBS3oq0gVBU8+SkvnUqivTwNnrLXj2TKM8/A256fAeS5quI+TvLSWBBLYRmpTbr4/wSABeuYtbvOars989LQpz77/Z1HQz0/VI8tMP9ckpeuj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 15:52:14 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:

> On arm64 server, we found folio that get from migration entry isn't locked
> in softleaf_to_folio(). This issue triggers when mTHP splitting and
> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
> in softleaf_to_folio(). The race is as follows:
> 
> 	CPU0                                             CPU1
> 
> deferred_split_scan()                              zap_nonpresent_ptes()
>   lock folio
>   split_folio()
>     unmap_folio()
>       change ptes to migration entries
>     __split_folio_to_order()                         softleaf_to_folio()
>       set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>       smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>       prep_compound_page() for tail pages
> 
> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
> are visible before the tail page becomes non-compound. smp_wmb() should
> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
> result, if zap_nonpresent_ptes() accesses migration entry that stores
> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
> page before page->flags.
> 
> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
> in softleaf_to_folio() and softleaf_to_page().

AI review isn't entirely happy:
	https://sashiko.dev/#/patchset/20260321075214.3305564-1-tujinjiang@huawei.com

