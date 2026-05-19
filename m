Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE0CCD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 17:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A2746B0005; Tue, 19 May 2026 13:54:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 351ED6B0088; Tue, 19 May 2026 13:54:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2678D6B008A; Tue, 19 May 2026 13:54:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 10E9E6B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:54:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9579140872
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:54:27 +0000 (UTC)
X-FDA: 84784918974.01.E62EA4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 149821A0004
	for <linux-mm@kvack.org>; Tue, 19 May 2026 17:54:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="A+jtP/uZ";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779213266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QJCXqK5e+jsYIY/mYZEl0IgKsm5dSPKux60ClvItxM=;
	b=jWfsvqDxH6JovZHun477OU2D3cyTVq4DNgC+UV/d0wR6pimAjzQoDgCZUa3Zj72ZM66i1j
	x2RPolZf3vvwWSsSj50zHnZ8as079tDDT/SatMrtCgzzDup00+eXJ0DSmiLHDd6xjoodWi
	BD2aSD5Hd4hlo4XMddKeIgSv2ptoJlo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="A+jtP/uZ";
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779213266; a=rsa-sha256;
	cv=none;
	b=r+TSQ1f1S3+AiYciuSEP9Y0cf/gRQzwqB0PwWpT6m+oaWQwpOM5r820IYzQM8fc4LiQNB4
	mrjaSs2uIEN/Tni4TE0pSf//EVi4rAtEeNCh/SdOWUcr1FLkWs/+iUjZG3eRhUyY/AjboN
	x5pBkpCsLN+5LtUSxPXfrQPA+I+RyeI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 86A3960232;
	Tue, 19 May 2026 17:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBFAAC2BCB3;
	Tue, 19 May 2026 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779213265;
	bh=ZCOEIIWzp1vuHm3T+v8hOOHOOiwrxqzK4hHsnCJoRII=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=A+jtP/uZ7+GWXcdqXPmeQfkeY65k9jdEg4qw6fiESoUf+Z7ufAVIAx83tATETBZLj
	 zqfh4BHdNwFpZOJ1GGTQmoUYZ9zcvmYHU+XZiPvRkpnU7cAFu00gxJZ+218WB2PoY0
	 WKZWMt4TKVoSYXYbd1ZhUINtohfK1jQy0oCb+gtk=
Date: Tue, 19 May 2026 10:54:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 liushixin2@huawei.com, david@kernel.org, osalvador@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Kaitao Cheng
 <chengkaitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_isolation: Avoid hugepage scan step underflow
Message-Id: <20260519105424.e422131a0ffb49e19ed1aebe@linux-foundation.org>
In-Reply-To: <20260519121646.40833-1-kaitao.cheng@linux.dev>
References: <20260519121646.40833-1-kaitao.cheng@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 149821A0004
X-Stat-Signature: tmu3zkrzs69djkpiacddr34p3hiak517
X-HE-Tag: 1779213265-587533
X-HE-Meta: U2FsdGVkX1/8zWW1mucwPwFg1CWSN6tYSF7sS4aeMERBEgJbR/+TQ/3kKet3UTcCIP8JNNASjeKoMo3S0n5s1XRftCUmZzPb6FYGRoaKsA/SiZIlPXiYZxF2AuX24v+JlK1l7pptE4kWios3bZ0g46RDsUoJCUUi9pZa3cZM6jhZ4+SOqI3YZ01QcwDnumK/kF5KS+7Y3rvFRxNRKZx2AQSe9Rp/IuR8vXJeF1sJjxKgmjaTBhbprJj5Zng1x8Ph+u2X+LZLJhkkww3pFdUYg6NhZQfxoqf0dDiHVKC+rVYzshWuZDoohodxMgwbKDTxvN9Cpv4QZm2jUKPLb5qphKkJ6E87TUFBhfZihWc4EtBDsPYSRr/3LI1Orvi1Ff++zhPdwtPiRrhYtoNPOScSyaCkPTRonKKpchMJn6QAeiGL6VSOrDNbTE3StLQTZsIAdNcn9T+xa2YoxOvmzZ2BBE3JuCTDQYAtaVY/TNYbp1gPHixkEKEp2vQfLCa+osdqJPnnH7sOp+pmuqG4i8sXJf8rtlogRBouoogdcWtvHsxfGiZeAkmIJcHr3GZzgso/tLqSBK4JkrRsuCGL8UJR+uxuk4ftnBPuY2ybK+93N5tFSBP8pRGa0uoAMui/avBzV19r3mPjpFUj8uQU/r5pAy8M9I3YqI5PtIYuSNOzVqsK7Ak/7684vdCTPMone7l3fOORxaembCzIfg+ViFTbm6EZ+ys/T+oPq3395n3mcjUfMulQzW9LjcqZXxMour1oKEx2LFzVc4BkFucSYVa/UTAdGSK3TtVdZpStqv0l1SAIIfJ78p+UEqoA6pFkTG6S0PRuCg+k30TqOc+KeqL/38dp4BdeYYuajIlzi0LlS3NVARLqqZ3VcCYNH2xYOO9Fv39Qad9qN7ekxB6CpahgnTnotQCGgDcHebsayNGKCfmvsUV87UW4TR4xOdZZ4pnRok/A8/sJBUm9p9r4bQs
 7+vCGNXc
 J+wKV+S+KCwFW4J+MkgyfFXTlghZjJKGje77SvhGpnpbUyloBmdMCsmsmyLBmewhX3M/y3pmVekw2FXQiH8eXPjeyx0cn4txstu3UVZw+nicoxoYWMmvZ+wHWNGjMBbqUUATAz1sI6e3kikfMRroSwvzSB+WoQpWdGimotlUtIGoTDKhsNZm8SBxZXe9Ls9AZs/MJviraO5rE7JZwhmdSe3U9pCHEunQNYqryWaLYry9Ak3tgmEJSPsZPWGKTiGhfGHDoHMnAEu8jogbG5A8IjxzUgMaVdM3d23E8kMvmCKZAocw7SmByGCIXbpLgzpA+bQqKP/nJIYLaamtyKOOO45FTQVXDYfQQmafN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 19 May 2026 20:16:46 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:

> page_is_unmovable() checks HugeTLB pages without holding hugetlb_lock and
> without pinning the folio. This is intentional for the pageblock scanning
> paths, but it means the HugeTLB folio can be freed concurrently after
> PageHuge() or folio_test_hugetlb() succeeds.

Thanks.  What are the userspace-visible runtime effects of this?

> The existing code avoids folio_hstate() and uses size_to_hstate() because
> the HugeTLB flag may already have been cleared. However, if
> size_to_hstate() returns NULL, the code still falls through and computes
> the scan step from folio_nr_pages(). If the folio has been freed and the
> head/large state has been cleared, folio_nr_pages() can return 1. When the
> current page is a tail page, subtracting folio_page_idx() from 1 can
> underflow and make the scanner skip too far.
> 
> Treat a NULL hstate as unmovable so the scanner does not try to skip over
> an unstable HugeTLB folio. Once a valid hstate is found, derive the number
> of pages from the hstate instead of reading the folio size again. Also
> validate the page index before computing the step to avoid underflow if the
> page/folio relationship changed concurrently.

This code sounds rather sketchy, and it sounds like it will remain
sketchy after the patch.  And AI review says "hey, this code is
sketchy":
https://sashiko.dev/#/patchset/20260519121646.40833-1-kaitao.cheng@linux.dev

> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")

We might want to cc:stable on this, depends on the answer to my above
question.


