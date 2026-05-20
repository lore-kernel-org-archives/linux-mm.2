Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03338CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 14:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BAA16B009B; Wed, 20 May 2026 10:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545226B009E; Wed, 20 May 2026 10:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483D96B009B; Wed, 20 May 2026 10:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 390476B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:12:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFC5E160A34
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:12:13 +0000 (UTC)
X-FDA: 84787987746.21.B855AB1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D0C4180011
	for <linux-mm@kvack.org>; Wed, 20 May 2026 14:12:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7fZr7Tu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779286332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BwtuGhKRqhUfLo4ezfAwb95AAgH5cTZ0Hpq1p4rSZE=;
	b=b2+bf8F3rA0VnAkhhIgugQSNELBmFxfKphUXv20DUq6hQYjWBMhyI0SWRxdA2mg8vp594P
	2yInd4WkYQY4e6a3s8Qiq0V9+OxnvaTK4rbQNs8/m8JKthVBSvt+76TYksKAsVWeWr6g1/
	RnkvFzpyRdvR8h3NCcw/R5POTQo9EiA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779286332; a=rsa-sha256;
	cv=none;
	b=eAlRM/vVo9NPTxlZgBW8XvCcxchWkZDOioBKh2Kh5dKvguDA/V82Q82W7MU2wQ+xzqPfML
	QQs27ikfLSW5jEdXLcL1OwfTVXGtZ+yscXkhXENKaH/bcB9MMzzA5+ysOYmtuR/nWeuF/g
	59wlFAxGVHWOEHFzd+bfQQqbnMVhX54=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7fZr7Tu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C9F456012B;
	Wed, 20 May 2026 14:12:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602D01F000E9;
	Wed, 20 May 2026 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779286331;
	bh=4BwtuGhKRqhUfLo4ezfAwb95AAgH5cTZ0Hpq1p4rSZE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W7fZr7TuFaqW247q3d7K7U3D3tFz6x5sVp3HxBOnmQ/AoV7C8sOrDRHB035EqFsru
	 ShutoDC4USUxyChCjMw6zf0G1mKbUWnn77Hr96bal31Q9uUQXx0zC+W4OGfixe3JMX
	 4y2MXKHI/qthLTTIbu36n2VnQ7/ZXweY70lmOmLigxw1gI2hfNW//yAjt8kMuVoe4q
	 Xrmu+/IZ1ybmSqZST7lqjgLCIrMca+hdSXvhYCt86kLP+Y+cGNKZ3Ehz+MZhmHavHH
	 6qNpOdc5BbLElbCMXXhT1JcFP/J4c1f75TkmFLwbBCpQSFepK3LE9kZJOmgXxQVEU6
	 vEzuPgS2GaxyA==
Date: Wed, 20 May 2026 17:12:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Carlier <devnexen@gmail.com>,
	Heechan Kang <gganji11@naver.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] userfaultfd: snapshot VMA state across
 UFFDIO_COPY retry
Message-ID: <ag3BNLU1b6p9u_6K@kernel.org>
References: <20260519052516.3315196-1-rppt@kernel.org>
 <a4e9fac5-e674-4528-9815-d588a35fedec@kernel.org>
 <ag2uzVgx2Xl7zi58@kernel.org>
 <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0412898-913e-4a28-b264-36438231d0ec@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D0C4180011
X-Stat-Signature: 7jdcuaytumgruk1muawyz86noaaoia8j
X-Rspam-User: 
X-HE-Tag: 1779286332-407328
X-HE-Meta: U2FsdGVkX19EgVJ3Q9jORccOjl9T6eRvyKSOn8G8KMRBqv+4zngFG1inU9fto/W/t+r5NGI+6vmB524iBZb24J1sCLNgo7J+zw4GuD+B6+wJpV1g+xN7OCU7wzWfzSrbeX1KaCH35mdWGscA18XkGW4NlM+HD+cEMWVqXem0SRjwZ85/4c/2tWCzwuDXZ3kzg5WKnqTOx97prbWNF+cZ/eneLr0UPbUDzNuGZuFpy91tdqDM/n86KODWZA6qMMWoi3T+orIA+8F3IRCN6JY+k6RUR/88YZOmbs4eHfYklo/7TJjQqzYBhIusJ0Mq7nUoC4Gx4mgSQ9eKpGGWdCBNI+NEyd9V5GmfWkA4FP1YyTDELVfZ6pGRfpXi4qGf0kLkEe5I6li4qKlOoeN7JOsLV/snp74KwGrUjHN3umHy12vnwZG6IjIoJOixfMlXropflD8Xhz+j6JnwEV4DIWNY1wMsETlt3q9eZHYBwtwDBnqipfM3wsNj4RyNY8CbsyuWTACVzKHX5YYdrWUfE2x2EfiiUyDWwM37QJjWmZj3ZR1LqIiAUqbY4sWwV6nN8u+ho4SuRcnBHjrBsrJcKrEpaxjq3Fyq/+Ly/Q9cuHR9gimE7aNna3z5eF2chDYoYe3rY7HmaH1gQzfYtLH1VOuX8eXXuMNTJtapyIlDh0IMx/grMppquS4mfJfyJ2eQJ60eaiYEHRL7Djw/V/trBK+Wygs3m/lsqaorbTI/GmQsYUhCwchIj3uySkyeA9obltngs169BqKeQJXe4bdU3gGprVFmfjeXIU95VhsdmYDJq7rXZenvkxpJNiedNWsHn5gOgTm8oEGzmDCjNdlVMV1oeK71JfsYWvOTRdQQ7FTMLcEprOa3Ss3oNd2FEW6a/5riHuz71CH915DoB+HORxQ+xEv4SSMLZzWYFa2esSEDVP5oyrKzUZnFEhBarLLRl1o9LQ3cpYpi8THLiRTVSG+
 9ZrTa5k2
 bt/j8bqXvSNPAvKdyXkNR6KTYNbp01Q4OIX3J6m/R7AyPrawy0bsfXqcjZ0x5sjsP5OLBDW9K7NDJg8eS3SzwAeaAWzWZ9Gpz4PquTd7f2zGCVYtGfhrVBf3N1w/k2E4CiHiknI/ISZRuoo2Qtec8hyujrRN9MzFBa/3YuODoyV6Cq4qZ4xk+T2FX3bQV3XUDUuqR+mUWN6Dsa0/b0GENwIPlYNnUjXkWDHIV26JKUtpbLzcnSI9b9rma8ERs/x0v7TsPN8t9FpPKFTJT/hswvPRx9aXzAw95rtaEy3Oo05DCMOIYuG343cFlezz/qwnyPmCjRrRmllrqB0Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 03:48:02PM +0200, David Hildenbrand (Arm) wrote:
> On 5/20/26 14:53, Mike Rapoport wrote:
> > On Wed, May 20, 2026 at 01:09:04PM +0200, David Hildenbrand (Arm) wrote:
> >> On 5/19/26 07:25, Mike Rapoport wrote:
> > 
> > Do you mean per-VMA?
> > Per-MM counter would capture unrelated changes, e.g. an masvise() for
> > unrelated range.
> 
> I was thinking about a per-MM thing for simplicity. If there were any changes,
> we'd retry (-EAGAIN).
> 
> IOW, something like &mm->mm_lock_seq, which we have for per-vma locks already.
> 
> Not sure if unrelated changes would really be a problem in practice (another
> thread gabbing the mmap_lock in write mode until we serviced the fault).

Let me reiterate:

A thread doing UFFDIO_COPY releases the VMA in mfill_copy_folio_retry(),
re-gets the VMA and checks if the per-MM counter stayed the same.

If another thread makes any change to VMA while mfill_copy_folio_retry()
waits to re-get the VMA, the counter would be incremented by another
thread. mfill_copy_folio_retry() will see the change after mfill_get_vma()
and will bail out with -EAGAIN.

So if another thread does, e.g. MADV_DONTFORK on completely unrelated VMA,
mfill_copy_folio_retry() will return -EAGAIN and I'm not sure we'll not
break the existing userspace by this.

> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

