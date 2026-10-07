Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4239CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 20:19:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB99F6B0088; Wed,  7 Oct 2026 16:19:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B2B6B008C; Wed,  7 Oct 2026 16:19:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D80C66B0092; Wed,  7 Oct 2026 16:19:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 760D66B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:19:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48F2080319
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:19:01 +0000 (UTC)
X-FDA: 85296944082.09.299CBA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7EFE020008
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 20:18:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hkA1pUQ9;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791404339;
	b=t9aJpVzVab6l/xi8tjp7VTXDX3HscMSHU60JleVNFBQlkFEc/SSdjMnpYghDRSEpasQUli
	vzdtfZ0jU0LsrC8xMNwLN5kZYhA47kpSuTJtNLvCksEjAAiThGIkA/YeDoE+TYFd9pFqVe
	groZlRTs10Q/MD90GP4NqZ78NNahTcg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hkA1pUQ9;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791404339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d41kn530ujQXx0WENCPEp/GR3x+3qSK853uJA2lQe2o=;
	b=tTldQ6clZS8QEimgJR0K02ZvV2NPWRdguXJsYlsekZBLe+aIuXxNhPkXdU7loTvTHNjIhz
	iShNQJBSqW7rIetwcrri3houfertzCtHuiX8iuw8VwgAlyGMG/+dfiAXELkv2ytnEz9qZN
	w3SIxnTNfm2uF4VLwCTdcZDcyjKaDC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF4B860A9B;
	Wed,  7 Oct 2026 20:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DE561F000FF;
	Wed,  7 Oct 2026 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791404338;
	bh=d41kn530ujQXx0WENCPEp/GR3x+3qSK853uJA2lQe2o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hkA1pUQ9hmXJ5YjSWckXbDjIG7G4wQNaBiVAqevr/9CFrRaNQ8rTINww986xmW99d
	 wV3tZAhsdcIbKshZRPlm2SwVQmLqV3TNIAivlP0MFA23WL3MSnaM8CQ0UnoRLmxXnx
	 7wkwV9mCJS/9Kuxz+yASeRuOuu+SrQUuMP1Zximo=
Date: Wed, 7 Oct 2026 13:18:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Serapheim Dimitropoulos <serapheimd@gmail.com>
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 fujunjie <fujunjie1@qq.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Serapheim
 Dimitropoulos <sdimitropoulos@coreweave.com>
Subject: Re: [PATCH] mm/fadvise: skip remote LRU drains for ineligible
 folios
Message-Id: <20261007131857.15fd27af78322d14c4075db6@linux-foundation.org>
In-Reply-To: <20261006-fadvise-lru-drain-v1-1-1e8fcf785057@coreweave.com>
References: <20261006-fadvise-lru-drain-v1-1-1e8fcf785057@coreweave.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7EFE020008
X-Rspam-User: 
X-Stat-Signature: a4ad8ioyptuehwosrxdeb39x3zeuaj3f
X-HE-Tag: 1791404339-906545
X-HE-Meta: U2FsdGVkX1+XOoc04WII2779KRCZtjrhAQIj2x5bZQ7HHGcHZolYFod0EOTwrTc2xYdX8CPArPpVhvnNdbIUkvegXB2uET69rbR3oVJhCWiaWrAiWqrZ69BslQeIzWEy8F3dD4Pct/0D/Q4wwZqmuMsZSE3zACvWIFI/POH79ULZ4dxancwLUD3ZghVdgfZPlN84W3aFqeX8sdGqHqGMrKCep4lOufA231dRC6nCrYWn7B5fsvCwHi8+RZl4oi+TNr/FsnyDxi3PtlHhMSYhHQ8O7hzx9nkuHz5EQoTfeGN4zi7Ly2CwiE3tc5x9ZT/jruDJnwzZD24xfiqQjv9QidDe1cTUCKZHwNCvblD5GMX76lDWQJ3Ici/W1rUwvRB0/jTRkF1jZw9reyftPt16j4drdUcY067IVbZv4TXOhZIrfQbxtJuf/B5iQacpb+iw8wIPIA6s2p5NO/f/PNbYLbavws963t3D6sI/ybSSD87PKs2H/umkfEspDysdtxxeGUHOqlcRRVyYGlJ6DvoeE66O0k+EzKy2M/eJ2FBa9Urtl4MAuNE9B9DDXlRyiLKOs/xZpWfmuVQKt4J1V/veyXJlYPw48VCMgViGJE3xrXrQmsQkdsW7oloJfcx/Y+j38XBT9LvrK1oMyurMM3xjyTdw8ZySRepe+aFgI90z0cXC+8sWTBuXoRwBRpzpGHPXnbDQnph9JDPDsqsWSxhb30LGv3BUF7qLrULieNmXvcOWSqjPyasHs0s1Jx/k6CPEoJDjEbTYO7htquD8B3U0BibR6Q4B2j1ORipPMLkLp4g0hYF1a9hn/AwJQNIvX2U3hOr08AGZfi8uyyGmmTudV4ZIb0s94Zttc+AX1mg0X+n7Vqh2V/sJnGdgK7rayp8iGoxzKAa96mXNvnSbkLvv7eHw2jP7gAzRxa18JjEwldFPXLRCfhlFkC2jlZv8vTctxir5fJm9ZUKrS0bBJYb
 oOaAMjke
 61qbgdOg0lSgeNHcd5udfZJwqX/VDGjExR5a30y8KNsyeIsCwI9i/VUWSwUbkYsznZ8bGpxmTq4dDM4w7maiijw2g5PR8oHAirVqKllqi8KAEXzThWHA0ayF49T2QrvkipuUGaydoxo3zO8mad6nFglZstLpDvr9OqWSuG+tb3LNPsyclNIZXtJaj1JN/E4p4xjQ+EqZvTLBj47A9e7gQ1Y0th5q20oyIlPBN8o1kxjsFFvJr06LrM9H+0sJ+rJQ2cqH46gzZaDS8btiSYhg1ZTXQgHUPqSKvvsZaqWyZX6Qaq7rnl9BZzogGX2Y9PfHGQcjh4Cfx798L/Jc/aPwpIxOu9ybNw9I+ozGRzZsf9yhjRewOeNmqzsHsFzQz1npRBtwe1v5pWokw4/fKSZIISv79g83iwQiYQ+0Lkg4o8Q1d5WwYvUCY7n5TKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 06 Oct 2026 00:27:19 +0200 Serapheim Dimitropoulos <serapheimd@gmail.com> wrote:

> From: Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>
> 
> POSIX_FADV_DONTNEED retries invalidation after a global LRU drain whenever
> mapping_try_invalidate() reports a failed eviction. This includes failures
> for mapped, dirty or writeback folios, which dropping LRU batch references
> cannot make evictable while those conditions persist.
> 
> Filter those failures in mapping_try_invalidate(), while the folio is still
> locked and before deactivation can enqueue another batch reference. Leave
> mapping_evict_folio() and its eviction safety checks unchanged.
> 
> Use a boolean retry flag instead of a failure count: generic_fadvise() only
> needs to decide whether to drain and retry once. This remains a heuristic,
> not a test for remote LRU references. Preserve the retry for other failures
> on clean, unmapped folios, including failures from filemap_release_folio()
> and remove_mapping(), rather than limiting it to the early refcount check.
> 
> This follows the problem identified in fujunjie's earlier proposal, with
> the filtering kept in mapping_try_invalidate() and a conservative fallback
> for other eviction failures.

It's not particularly clear from the above, but this appears to be a
performance optimization.  No increase in POSIX_FADV_DONTNEED's success
rate is expected?

> Link: https://lkml.rescloud.iu.edu/2605.0/07547.html
> Link: https://lkml.iu.edu/2605.1/03284.html
> Link: https://lkml.iu.edu/2605.1/03732.html
> Signed-off-by: Serapheim Dimitropoulos <sdimitropoulos@coreweave.com>
> ---
> Tested baseline and patched kernels in QEMU on ext4, XFS and OverlayFS.
> For clean mapped files on each filesystem, 32 POSIX_FADV_DONTNEED calls
> produced 32 lru_add_drain_all() calls before the patch and none afterwards.
> A separate dirty, unmapped test using ext4 data=journal showed the same
> reduction.

The whole point of the patch is a performance optimization, so it lives
or dies by measurements.  This vital info shouldn't be below the ---
throwaway line!

Also, fujunjie's original had timing measurements, which are nice to
see.

Anyway, I totally believe that this makes things faster so there's no
need to do much work on this.  Just saying.

We're in lockdown mode for this -rc cycle so please await review and
plan to respin/resend after next -rc1, thanks.


