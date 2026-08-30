Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FCCC61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 00:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B8FE6B0088; Sat, 29 Aug 2026 20:18:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26AD96B008A; Sat, 29 Aug 2026 20:18:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 181676B008C; Sat, 29 Aug 2026 20:18:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E63396B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:18:23 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5CA361401EC
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:18:23 +0000 (UTC)
X-FDA: 85156024086.05.6DC391C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F02940002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:18:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RRRZVrhU;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788049101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLwaRMYQSdlC9dDrcYF6uhIrk96lZ4AnEwSNRsJJ7Jk=;
	b=VKJ9pvmtz/pFqmS2AvPGkr/wluIYIMAMVQwJisXgwIy+vuCq8BScDX11+XExvzOK23jGSo
	Ut7iuFBIRMzBP4tWERiV5h78jjRHeZxPoDtR6LE48z/x5s55NOrhKhC0ECAvLw8x6+CIjW
	3+am3XiJpq9MfDaUsMfzw3EU/yZwHBU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788049101;
	b=zibMfG0CwXN2+lAyFNXnzLEAfrfWhJN7KeYCXQVdcOQ0cigAXAEGGJIBqM7Hiqn+MgiJJo
	3LXOVwQIUNNdWUwMhLjWs/yHvK3KUuqmGRHMboCjcStwY2l7TiIbbbQ7rBWnXIX8fO5XA8
	vSjw8h49SxE6Y0sRVxDYBT6Ljhx/YUQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RRRZVrhU;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D7BB6600AE;
	Sun, 30 Aug 2026 00:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B56351F000E9;
	Sun, 30 Aug 2026 00:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788049100;
	bh=rLwaRMYQSdlC9dDrcYF6uhIrk96lZ4AnEwSNRsJJ7Jk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RRRZVrhUsMA1mrxJwrnY8deTAOsAhEgmZGzHX+tXScdO1bRIGsHwN7fDXs08zlApd
	 DpQiip2DP81dFltY/sey8H1holAPNm78Zd1a+kuZ6I1yEeTXDITuoxuy6wZv9njlDu
	 f6SZl0KBRhksKXL0kgUxkApA0hPEe5oPSYgC/EDo=
Date: Sat, 29 Aug 2026 17:18:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: gourry@gourry.net, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, david@kernel.org, ljs@kernel.org, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 balbirs@nvidia.com
Subject: Re: [PATCH v2 0/3] mm: reject zone device folios in more folio
 walkers
Message-Id: <20260829171819.e1e8910e7e9a8a46b87c870f@linux-foundation.org>
In-Reply-To: <20260818043143.22297-1-lance.yang@linux.dev>
References: <20260817220810.1175596-1-gourry@gourry.net>
	<20260818043143.22297-1-lance.yang@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9F02940002
X-Stat-Signature: pwrnyo656afp4fcocwn6b3o4nymweae9
X-HE-Tag: 1788049101-148539
X-HE-Meta: U2FsdGVkX1/ZWcwBErenygyo7peO577KCnZgXr6s93vQje2eAgK0C3pxqixOGHhZYw5Wdr7nWI11TAUp2FaU/c0X6/8L/FkImaThlhOaV+H+I0jqNG+VWFryhcb6aT29IkXMuvdB4SYxxTJ2QG97bxkaheTpyo9M/6NRujbi25lhp0O/lJvqBbYOPft1jOJIo4YE49ZEpacRoJK76R6aXUd4BnRkwR+YaT0HpdvnbdMVuNUd6p31ofJ2d/QlHXZKxJd3dir36tr5IBXxuKn8zMZnC1FUGu1aU8CyGnZQ0YLwk5g5jaZF8I/U0EAyHlDteMd/G7LiULeoflgqHgftXrI5zNC+0jWrBZewwJgZphd6HeV5IKfR9Z/Xvpn0T+4/4iqpIji97UmggbC1YEmxBX8keTs0Ak9eOMX8NRLSe9oEzmoo8H1gK7RZ5fEqL88iwUt/5hED4CGDjZnKtDC9O9+M4zqTtLrgeIs9Ti5it52w6e1xRYU8Ld4Q96oIusHPa7QTpSW1oKR1pzhmVVa2FDyvXBDiKerGWcdP/TxJz4URKYGqorwdzvbPrGB0Ahp997yJ97io7yRvspPv5MuxHkCzdfQgEK6C0yZO/OpWTwFrwedowKeoYKPLGoRBGGbUnvKKqQ4Te7wfEFriLJk+sXiitks59ZNXOuqHZ0Si+LlBUx3aJem9cZdQ/uZdqIpbDKQLdQgBqHAFDsyca0/+htGgEyZzUiCMcM1EcDa0X9r9oyIconQMXSdmvrfEZM5HY66Z4wHLo9DpFKeLinoztAEBRbrzUg+f1Pqo8CxndNRigscLglO5YkJNLwN0sWKg+lYzHe67LZkNVbODEpZMz4cy7C5cGBsbBzDg/i7ijzZfLoyMcIyzzgexQDY87zsD4mZ+jc7XRdske1lkfrh++LZcJcOYpb33hwXgZmJnvSfhQnJU2fyCA+8Nmm1FhmgZlIWwx+YtnOW81ThHNfn
 rPuz206E
 JmlxxYNBfq6A2mHCvG521F1aAOdMUmTS70zAoRvhTUDvk+qtIL0T1m7QyEMNZcu1nA/ZVDX3XPY9TXApdMEN+i3gEU9mYgvfQwWzkGUpzRrKagESnG+XMM/yst9pZjxv6mDQ5696FeYw9iiHgLLr/djQThGnc8WDJBm3wVopqIaBUY3lWoBs6clJJRJYzNM7xFDZZoMIPpEE3oaXBk8nzd6yYqnTSCNch9d5fUenFz8owvKhYbS1PZBYb9mpUXfFbKOeEvk8/Rzv8Pd/bqpbQKjxfvZOhZcnMrmscsK+bA5FPKCm2GWXzurBmNvwnYm3KL+wtVQ5gcwOGDubDHLwsPwgUVlj9wmOTdQP3aIsLd01wNUpxwHlrFceipkGHBqrv3HnUjAOEviGgWBsZYykU6Z/aVyVxxF8gn2RAWL8SHS+yU3xcvneNx9ah9EK26YRhkRsd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 12:31:43 +0800 Lance Yang <lance.yang@linux.dev> wrote:

> 
> On Mon, Aug 17, 2026 at 06:08:07PM -0400, Gregory Price wrote:
> >Several LRU-oriented mm walkers resolve the folio backing a PMD entry
> >(or a physical pfn) and then reclaim, age, migrate, or lazyfree it
> >without ever checking for ZONE_DEVICE memory.
> >
> >This series adds missing folio_is_zone_device() rejections, matching
> >the checks that comparable walkers already perform.
> >
> >- mm/huge_memory, mm/madvise: the !pmd_present branch above these sites
> >  only filters device-private entries (which are non-present).
> >
> >  A present zone device PMD (e.g. device-coherent) would still reach the
> >  folio and be lazyfreed / aged / paged out. Add an explicit check.
> >
> >- mm/mempolicy: queue_folios_pmd() can see a present zone device PMD
> >  (e.g. device-coherent) and queue it for migration.
> >
> >No crash reproducer - this is a correctness/hardening cleanup found by
> >inspection. All checks are placed after the folio is resolved and before
> >it is acted upon, on paths that already hold the relevant page-table lock,
> >so no locking or refcount changes are involved.
> 
> Cool!
> 
> Gave the whole series a spin on x86_64 QEMU with a PMD-mapped
> device-coherent THP. Without these patches, partial MADV_FREE and
> MADV_COLD reliably hit a kernel panic in remove_migration_pte(), while
> mbind(MPOL_MF_MOVE | MPOL_MF_STRICT) returned -EIO.
> 
> With v2, all three worked fine, PMD mapping stayed intact, and data
> checked out :)
> 
> Note that both kernels used the same small change to the in-kernel HMM
> test driver, allowing its coherent device memory to be allocated as 2 MB
> folios so the PMD-mapped test case could be exercised.
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks Lance, you're so diligent.

I'm wondering what to do here.  Gregory told us

: No crash reproducer - this is a correctness/hardening cleanup found by
: inspection. All checks are placed after the folio is resolved and before
: it is acted upon, on paths that already hold the relevant page-table lock,
: so no locking or refcount changes are involved.

And you had to tweak the hmm-test driver to reproduce the bug(s).

So when do we push this series out to -stable?  As a hair-on-fire
hotfix, or as a leisurely next-merge-window thing?


And Sashiko was clearly having a bad day, able to find only nine
pre-existing things to shout about:
	https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry@gourry.net


