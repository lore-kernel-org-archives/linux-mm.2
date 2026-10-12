Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CCB6CA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 12:57:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700E76B008C; Mon, 12 Oct 2026 08:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8116B0092; Mon, 12 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 616AE6B0095; Mon, 12 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9086B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 08:57:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BFB4740D62
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:57:10 +0000 (UTC)
X-FDA: 85313974620.27.C3EF530
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3195240003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 12:57:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJFALB2J;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791809829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cniybAFPuYmkywYYtlFXNwkUQYMBMbCpGkul4BT0ctk=;
	b=WdtwAGBe286XSMYCgc+tiQZ0mrsd19pIZWXlbyil7dmsxqMnF8cHmsVv6CZQ1OpRd/Konz
	ewhef7KT7nQcaapkJo6e4FMy0pOunbuIJLZLBJLoBJ5RCyuoltUQSd+E+LzdSRlrN84Q+y
	i4FfJQnZn7MFDsJS8Lzhy12sczatX8M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jJFALB2J;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791809829;
	b=xIK5bcG05kO7AcBM6V29+LDE/jI64BkfTE75HMzu4MxL+XS8xjNUjzOLUsqXXSWM7F5fDV
	Q+ytyzvzGR9FvXKEMLDOuvgcKiAub5zyxm+GmAPU4DsRBj4lq7zmj/iHmuiOkspbzVxw0k
	bPFxK2QzDG/WrlkV3rU1BeAdGolxvZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F30FA60D7A;
	Mon, 12 Oct 2026 12:57:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28D7D1F0089B;
	Mon, 12 Oct 2026 12:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791809827;
	bh=cniybAFPuYmkywYYtlFXNwkUQYMBMbCpGkul4BT0ctk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jJFALB2JergrfKltKzSDa4LndCsJ4Ai2YPpCcn2cRk+4Jv/zcP0vM5K7s8F3bxlzs
	 BG7j65wRaEqUbyBlnt9u6v1yfXxWy76eKajJttqPPNp5x0Jlfqxu+jUF4aoGm89i/4
	 tlxsiSbXgjE3dQ+JcvHtHMbFqvf7mAIg9hTlaxk1kmk7EoIs/+cJQeEXakAakKYYQV
	 3YDOiIcS5l8F7hRsmoADhnzUk6WjmbnUz4k2vorqyLpB/MT+6YQm/b4GYDJ7uSylAe
	 KFJfcn70bOLzakvPy8Zup3p8RpB6qiD73dpgyz8U2Q5u6vV0MaxrgNr9dxgvxYTumg
	 vuOiMiu8xjmkw==
Date: Mon, 12 Oct 2026 13:57:02 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: albin_yang@163.com, akpm@linux-foundation.org, liam@infradead.org, 
	vbabka@kernel.org, jannh@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, albinwyang@tencent.com
Subject: Re: [PATCH] mm/madvise: add cond_resched() in THP branch of
 madvise_cold_or_pageout_pte_range()
Message-ID: <aszYQpnRikFRuSYN@gremlin>
References: <20261010024042.4070048-1-albin_yang@163.com>
 <bd78c58a-f266-40bd-9290-90f77b8e4225@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd78c58a-f266-40bd-9290-90f77b8e4225@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3195240003
X-Rspam-User: 
X-Stat-Signature: jtug94mn6qkoq3w51b57m1ay7zhtabot
X-HE-Tag: 1791809829-480009
X-HE-Meta: U2FsdGVkX187ou/Uvkpgsz8URYQlMT9YRYXPz0KyD9y9P7C9WchqlqR+O9sZLThMFG2Ak+Z5yaGG3JWkyS/Te7e507+bGRuA8Guqy3fIhrn+RbbTrT8r6qKNjEtze/LrWMT6ttgL891BUeLb3yadwYrh/JnaI6kqz+HvCAn0kUFzoKj036WuRcr4FX1fFiwM1BBNw8a2DzK4adgNKoaJVwdUqVM9HXUuNtS4KGsR4uKDtSuw4hGGRxbKFneVmp6eDC3OnfbwDv6aEBUDBv8htxuIbACiJHBgIAx4l9UeR4fGQ/sewHYHv8F5qeWY+3SfkmzvFtOFfEybVJ3TuM9zE2/EqCraW8gC4ttd2nRdjiUjpyyYgufX32HeYEeFGqrjKmlLkxsAHOLDQknN7YUT4HmkuRhhOC7TnlmYwJ95dSdMHoHUV6cDFsz535/rSo4W2lZOD4xqhMms+jjCucHeH0569Lg6AjZO15vIPxiBsd7x76e1Mi8WV4+/OAIVZkXRWBMtKWQdJlkunSm9/rIjTntUfvy/t7k6z5METg3xCzmGrSe700a9o6PwofUS1B2YNe7k1sc8nLUEO5xy1MjAVBnJv7v2aZV8uOMIfq/qXZksBghVn0EOZfFJ3NnGA5kL8ZWyNk47c6GigVgcnxWYBkxZvfAPTn58ZKmWVqtZDnoiD8ctJTTJL3/K8nEjlWmYuKPLNCu1ptZFXJsQidEXLhSw79d5PetFxjsdbrlzecpvIsnyWMS4ZM8WA1mkR05GfCxOfr7QcHkt9jrIhUJApuv3AHATxK3Fe0BXyPqeNZeP2DVvWemC8IIC1okNwUK9Zo5vFtbpTQopDQnhNF/kJxTwXTYtoTipXVkCd8GZ77i9Apejj8eEmyy+g8HObfJV7OEBQSBeESDEXyWZU6JfuM6pchTI1mg33jd4eB7H6c02LqbeuYbDHdHwuIigAAQWSqAnLfiQEpnRVq3ikC5
 CrU069JU
 ESSXwdvMpyuThqYzQtVsE5VvwrbLm9cPiBgzlzoSdPjPrz7m6OiGwpzJyqkbXqUWEhm443Uf2xm7xbEcnYOn1UYd1Q7R6uJBomtz7xva0Y8AiL7zrrCXzTntFcyOS1oND8Z85Igp620f4LzaDBQdJYCzXUkPZRttUuy6FHiVGg8PpgSoxeBkeRHZtjyeXQq3O1EYqYV+4uAPuCz4xbM1kx1Rm5FNnZmpcLW940V78qbhnYekBggimWsPqiOb4GBOB9fhUJZpBqdYebosFF9SzIsznfucBgEV+IABuf7AEHyQji3hkCYbkm8zYx6XLTmltTCMN7E1hF1Itw87P2xMWxf4i7pbhxAnpNEO/eFlCUY8bGueHxylkZ6xAUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 01:02:59PM +0200, David Hildenbrand (Arm) wrote:
> On 10/10/26 04:40, albin_yang@163.com wrote:
> > From: Wei Yang <albinwyang@tencent.com>
> >
> > During stress testing with stress-ng on a 256-CPU system, a softlockup
> > was observed when madvise(MADV_COLD) was called on a 31GB memory region
> > backed by transparent hugepages. The region contains 15935 THP PMD
> > entries, and the softlockup was triggered after 14485 of them had been
> > processed.
> >
> > The THP branch of madvise_cold_or_pageout_pte_range() has no scheduling
> > point. walk_pmd_range() invokes it once per 2MB PMD entry with no
> > cond_resched() anywhere in the loop. Each iteration calls
> > pmdp_invalidate() which issues a synchronous TLB shootdown (dsb ish)
> > waiting for all CPUs to acknowledge. This operation can be
> > time-consuming under heavy system load, causing the accumulated time
> > across all PMD entries to exceed the softlockup threshold (20s) and
> > panic when softlockup_panic=1. On a CONFIG_PREEMPT_NONE=y kernel, there
> > is no other opportunity to reschedule during this entire traversal.
> >
> > The regular PTE path already has an unconditional cond_resched() at the
> > function tail (introduced by commit 9c276cc65a58 ("mm: introduce
> > MADV_COLD") and commit 1a4e58cce84e ("mm: introduce MADV_PAGEOUT") when
> > MADV_COLD and MADV_PAGEOUT were first introduced) and a conditional one
> > inside the loop (commit b2f557a21bc8 ("mm/madvise: add cond_resched()
> > in madvise_cold_or_pageout_pte_range()")). The THP branch never
> > received equivalent treatment.
>
> That's quite a text to say "Do it just like the PTE case" ;)

Yeah would it be possible to cut down these giant paragraphs please?

Maybe:

	Running stress-ng on a 256-CPU system resulted in softlockups when
	madvise(MADV_COLD) was called over a 31 GiB THP-populated memory
	region with CONFIG_PREEMPT_NONE set.

	This is a result of a missing cond_resched() in the THP PMD path in
	madvise_cold_or_pageout_pte_range(), so fix the issue by doing the
	same thing the PTE path does by adding the missing cond_resched().

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

The logic LGTM though, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

--
Cheers, Lorenzo

