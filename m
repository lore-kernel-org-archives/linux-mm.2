Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 846E9FF885D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D296B008A; Tue, 28 Apr 2026 04:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75476B008C; Tue, 28 Apr 2026 04:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB2426B0092; Tue, 28 Apr 2026 04:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC8A06B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:01:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D6761603EA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:01:28 +0000 (UTC)
X-FDA: 84707219856.05.6FDA09D
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB7F0160005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:01:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=towCCtqY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777363286;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lkBWCIF6L2QJunHCW3EUgTULJD3KtI4tQtMkohEHoII=;
	b=7lXIi6PtIZGW7rmuMBEl5kthFm1C+slW01vxErnqEnQ2rU4TOexhm/VTXE5t+Qgn6wgCQh
	izI3ktmCzQGcU5lSaoYtWD9BYUOQnbAmgL7Mao+NdWlqO6rbMXgnQpG2L4KPsVG5P2mjNe
	D7bQW94plTqnSKz3ey+P93dEjHALAcE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777363286; a=rsa-sha256;
	cv=none;
	b=OwJx/X914EbXEq0adBL3EBQsmb0ILdjN7WKVYNliOljTL2524NSe9YL6tES0s3CLS3kwew
	sJ+eWqhlfC8ESQ1WQnb2TuICtfON1KNigRGxrffqCTIt3k3xchZ9fqwQ7jIh16qTNF7GG3
	SmZSfGqCy7VgZ2Gc+uYS2tUZIOJPdkg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=towCCtqY;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777363280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lkBWCIF6L2QJunHCW3EUgTULJD3KtI4tQtMkohEHoII=;
	b=towCCtqYHuH6SNf4wfD7z23/nzpdjmjMkhA+LOK3mvK5i14nRHYwwKdjoAXJmFu3Ikxny7
	9XKIHQtGHAdspXL7OL0t3g6DIXtIEVfkue756CiEyJ02yAm7OYrCA/7kLwdbG2dPTEI+7R
	0kbUt6V3TwirFrtH8q3S+I5CqSUF3MU=
From: Lance Yang <lance.yang@linux.dev>
To: shivankg@amd.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v3] mm/migrate: rename PAGE_ migration flags to FOLIO_
Date: Tue, 28 Apr 2026 16:01:00 +0800
Message-Id: <20260428080100.79894-1-lance.yang@linux.dev>
In-Reply-To: <20260324190706.964555-4-shivankg@amd.com>
References: <20260324190706.964555-4-shivankg@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BB7F0160005
X-Stat-Signature: skew6qe8dg6iczj83wczihopjk5dzge1
X-Rspam-User: 
X-HE-Tag: 1777363286-317488
X-HE-Meta: U2FsdGVkX1/UaDMPL7a288Oj/9Q8eZ1kPIJo8dNL+y/wIzm1DHG98mlgxRgomgrGeEBx2Qz4AuN1OfUX2ZIsjyQa6OCblyriybqF61pusnM3//A1zvgHrK4RXbQjPzP9aGbljio4UkwVCTmqSkpw48okO1e5zro5TS69VTCzz1l0q5rVaB1KIlNQpZw1bqvu9/jiEpCvXJ28YnwhcegL1b5upz+6OU04s9BchNZAaZHBwuEIm+Wlos6pi9Z0Jsoito+RdYy4zglp0seUJBuP8V/tbANX+4OMXq0cBL/GUO4MCSzl5TktuC4kOVLZnJUsKQBBmvoMow1XaaKzEhwUDqr+LVNiraK6Sprxib+qduq333Wrk7BOSZ4msVMEt2vggBBATEkMr4SW/grrXaPLqTMEYlwP3HmAPXieWiC6yoCHN+NEeQCv/7X7boMHnWXnxnFO2rd9ZOjqjszxYukRDadps3kaDydzIxdoKBroxNuC1AJlytFIK3cq0QI16vENghyB8GJ0Aolq474RQt9Gdwhm7gPbnmoNUcrKmwQkxE3UfjAgeOVwgKhyNEDjGivrGTt3viNyxWlH+aNcoHMMdCziNPJO4+1BidP98mWSYXnyFJmqd05bJi4rdhyUzcCTiSpKrxPVSdPYsJIovpsb4I+yNj4KMA0HD/qxYWNt47QAcNxp59yn7R2USTestrO66ZgUTWA3LLOUheTBhe17dTUfVPtACem477YbafNKdoKgYkRsQdjN+YJhlnMFZ5KQiRdH1Oa3dnRpT4P+ejJ40DqN4l4S+MMlciptO0LWvFr/avEKalGrKZPexgKgBQVSjt4zslQonyfh8ECQDxUl9w0+SH8PaB/RxIx+AfJvqEV2A0ccLm7ZdrgGz6c7oliUxyQGXSVFbqvr2MM3QJchqNDlcz94iQrkClYskzxQdBpXU1s17NoqbMiTCYiiv6jtHczt60NsJX/4B4BIbIT
 0Gd5REUk
 yJhwm8/pz47+kcvxeAnn7Lm63KuANzOyoo8G3YcBG6Gp4HpFeYxHA4ECL2R50FvNwgqoJyCeeKeu6It8QlbVGlTSCjaS6ExW77oYsqxpPkA7Ew4348JrqfUxAEqhgHJ9SatP8JxnqesZexSoxnXFEufg0HaiRB+ZIwVBtLarvWo1n8metXCfcHaCEyjkVKK4x8a9oQlqJ4yW8spXmuJtTABh6DV0YfkI/AJT/pwe5fZWt+bMhHOfF4S/BKXBziIEPGOIy5KO+bIwsKWlxyp8jJd4KMJTGd8QE6BIxJQi1mEeczoc/54ykvb9cIflvNTXC3ADzKYQ9Fdb7+OzHq+vJFGMu6dTMvu+MAJkmS+6xYQ7oCPUCSnGDU72sBUqiZ4VnAWCGbzIHo3onw6ntN2ZjHG+Rrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Mar 24, 2026 at 07:07:09PM +0000, Shivank Garg wrote:
>These flags only track folio-specific state during migration and are
>not used for movable_ops pages. Rename the enum values and the
>old_page_state variable to match.
>
>No functional change.
>
>Suggested-by: David Hildenbrand <david@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Shivank Garg <shivankg@amd.com>
>---

Thanks, LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

