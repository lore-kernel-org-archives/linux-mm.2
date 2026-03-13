Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D2C0106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46DA76B0092; Thu, 12 Mar 2026 20:52:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 400B36B0095; Thu, 12 Mar 2026 20:52:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3442D6B0096; Thu, 12 Mar 2026 20:52:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26D066B0092
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:52:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA91A1C7A6
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:52:45 +0000 (UTC)
X-FDA: 84539214690.10.96908CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1CDCCA0005
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:52:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DuWzI4UB;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773363164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gpo544VSz8AH3A0GlQUSZeN0Uk7CdKl/tuX25v0N7VQ=;
	b=LGQNURvTM+stSlF6KZ5B/LSwOMZcHejgAKMEusDmslm8s1DfpuMM8TIyi1NTdbIN4MNXOy
	ZnsI7xSSNm4SG2IEj18qVSDrg/foboR4sWBkYOrpfeN3SprZYBxQ8i9S7t9t+XRPkA81Rw
	H63ZZ6nLLfVDzq1V6Bi705lViQ7RXBE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DuWzI4UB;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773363164; a=rsa-sha256;
	cv=none;
	b=Fs4kQYKQtmNMHivctc797exssLi449vCkPGNS82N2Mv4hNext2gHtMTnPn8IY2IWPXFZTq
	0uGW3oZpB+c8COMQqQp+OOayOBuLZMiwlqGqEPB42Lu+KgEMA/ZcsO01ylHlDQ9xVEFyIn
	P2BN7OxpFyogK8qOBWqe452yf60rgnE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B596A40581;
	Fri, 13 Mar 2026 00:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1141BC4CEF7;
	Fri, 13 Mar 2026 00:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773363162;
	bh=u09tJ6oA8uKQCXuVDskUj3OnLNBy14TubsLkRd25lYM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=DuWzI4UBSebrvs52L3URsESaYwY6E249CplCTg89RqcP6gHXSWzexwipGvO1ZK7jM
	 j6xn07MpLCY+SpLhFy/kWbOtD7gA3myI9x8NbYqkCJS7LZ0LFf4o10uBCm3fjUKDON
	 cPGcAx3lkMHOAFiEkX2455t7Y26J5F51hDQUBlSM=
Date: Thu, 12 Mar 2026 17:52:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Usama Arif <usama.arif@linux.dev>, npache@redhat.com, david@kernel.org,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 richard.weiyang@gmail.com
Subject: Re: [PATCH v3] mm: migrate: requeue destination folio on deferred
 split queue
Message-Id: <20260312175241.01b876f3b325264f43312d79@linux-foundation.org>
In-Reply-To: <20260313001630.80081-1-sj@kernel.org>
References: <20260312104723.1351321-1-usama.arif@linux.dev>
	<20260313001630.80081-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1CDCCA0005
X-Stat-Signature: gj63ka8i913atc3ykoyyikn13nzces41
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773363163-8669
X-HE-Meta: U2FsdGVkX1/6hSiH2dHRbqnAqax8iIJ34Nw772BA2/s3e49aa3xvCssjoYm+Wn3xhDqvzB2XXjZgHQ+YKZQQNIkwkpJ1TLOWtKH4MrtQ8QpHGJmeCD9Js+Z+ITBI8dhtHw6E72CoccQtXh2Lc6jJ3fb+wASWP+ho3wJ6lOc0G5056/gK4WAe5U3cWapcz5S08qn6wJ8Jpq6Dw+AWehLnhKvVlIvT0faUe6FgW92kbXKxuWQBzyMQbn5vE/EmYtJsY94ZWC9uIpoftVDQlEuzRJyfxpbFuC5cXwXXj49fD/Z4K/uJS1nMMUzu9eUsPtgBEqFqegoabXXugO1ap8a7WDy4OPbM3NCvKS3Ov/XscYKbuyHFw5aI6TwhburTnwzdiTlycVuKC3121uvLlsfnCkqZwIwkjJJWf4ffTgwag91IGlP88Ry/RzTqEn2WnUQcNxSjZJl+b40FDOkaVIQkswSvs8s/zG/Kdw8YZ51Z4YDI2f2YZwBkMnjuSfBrl02huJKe2nPRpngC8ZbR9aiQok/D1Ejm5yiVkbDQ5QAyGKiS6nhpm51mHoY0rYtAAvVsgt12lN952THPxygxRdRwpiAcecjarT3PyclMFGXVC8JyTfNNzXfDl6bjEi8qiwgEeXOPQHjGe4yGlvao/tQSeBYKImGz2G2I/e+t0BYoS67dOIU1D5jArnAG4wn3+f78TjOa4xPHHwLhGubTYi7O6ZPtpr3R3hLFK4/WU1Jbp+KOp/Ze5Poju9XENFMLqscVy+NxejSQsRGSoN4wc/1LHD8ionoN74ONB4VejVIJ7IjGOOvHypGE1CajQkqPZc+B0VL5QvCEm3mpPJQNzmxhsV3bOiLpYGBQit8p7V8AZesL53ZLid5RrqxvlGdSpe+K/nH5CMNYcfNQs7g2MjWVBQtNck2znN23EFwan0BSdH1Szu5KyOkT8hrUqVoOAWpP+4zEVuLwbhGzwHxbigR
 GYP67AS2
 hFJdnAHpy1urK0ZRSE+XDZTssyJg+FLPTrnx++Sc/C0/UpA4QQ3qlzjhBibWujMp9ql/1e8ewm1F7ldkVkBtkuUP/WQ4vWGAMo41mkca+mF+SU+S12EE12LWYb/leOuN7ajuiJEp06daw8ENaaRKesQ/fKexntxvdxuVR+DgeGnEUdcvC+SQ5flqa8xxFhClP8HMIRnlbFULtzyp2tjeSlQuw2HsA795HM8oBFEfwjosuzfXftNHepyoFsVjbcKLzI4Oc5IL4BLPgj2Ke9XX6OIreeN0qwcruu+vTYgt8f3Rxd+9zgClBdrqtYJHEvqzOmlmuIOUoN3mzCR8u7tO39Yad0+O+pAX56Ik7atXuri3DZ1bdoT/t//BuCiO1211mjMQi9IS80GKdQROB7qbW0XHCag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Mar 2026 17:16:30 -0700 SeongJae Park <sj@kernel.org> wrote:

> > By the time migrate_folio_move() runs, partially mapped folios without a
> > pin have already been split by migrate_pages_batch().  So only two cases
> > remain on the deferred list at this point:
> >   1. Partially mapped folios with a pin (split failed).
> >   2. Fully mapped but potentially underused folios.
> > The recorded partially_mapped state is forwarded to deferred_split_folio()
> > so that the destination folio is correctly re-queued in both cases.
> > 
> > Reported-by: Johannes Weiner <hannes@cmpxchg.org>
> > Fixes: dafff3f4c850 ("mm: split underused THPs")
> 
> Seems the commit is merged in 6.12.  And I assume the user impact on
> THP-shrinker enabled systems is visible.  If so, should we Cc stable@ ?

I think the user impact should be visible to backport, but the
changelog is elusive on details?


