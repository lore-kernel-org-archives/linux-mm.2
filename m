Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B215D66BA2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 20:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5EA06B00BA; Wed, 17 Dec 2025 15:26:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C856B00BB; Wed, 17 Dec 2025 15:26:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35426B00BC; Wed, 17 Dec 2025 15:26:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF3FB6B00BA
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 15:26:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 748DEC0E03
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:26:07 +0000 (UTC)
X-FDA: 84230094774.11.0D84B38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 930F21A0015
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:26:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FFsQ98uf;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766003165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OWshfhBf9QtVVRlGGNjM8ybZ4tox7+QQSrDLA+RwPS4=;
	b=ePYbdG2oIE8nwxqGrUfy6/3g9kXGQzcJ5WgrKSVleu/SxPE40xqDzLjsgsWy1eu1VniNJu
	igLXnmhy2SAO59+GYaZJ74EgeGhMiD14aTkxJNFxLSjovYpkQLFNmRID+0yZsZ97yZkwKj
	V7id7smcyidr5xixlpfEgrLB9XyL398=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FFsQ98uf;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766003165; a=rsa-sha256;
	cv=none;
	b=ZNdfjmTn8HKQChWN0IGxzVFMR353ObO28PDUTyvX18GeEIIYpbsGaZOEbKJdkEQwpjWvZL
	7EEmnuBZa69MZkj4EPDN4LthkE6JNzbzq04DqW46Vyz5P3k9dPFg8BaZzO/V+o6tgZTrBP
	288As5LjgEWN+G836ATDGBE7GP6/RA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CB2B43B28;
	Wed, 17 Dec 2025 20:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC700C4CEF5;
	Wed, 17 Dec 2025 20:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766003164;
	bh=rLg0yhV7MJSzVux466aPk9fqyfJTf+LBnKTPih370/4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FFsQ98ufdK7XNH0VXAxYnS/2/McRZ4h0wDDdDWPO0pa72TSYx/+57Rs+e9egFoifM
	 TCKK91K6OxyTUH/S9dIcv3wrrqEAW3j5/sTYFj1uJ5IeHiz59QscPjsZdlNK4ArSSd
	 Moe/4mchfcIFTGOtDtdZTZF+43yxyvz7FO3ALTSE=
Date: Wed, 17 Dec 2025 12:26:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ankur Arora <ankur.a.arora@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org,
 david@kernel.org, bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
 mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org, peterz@infradead.org,
 tglx@linutronix.de, willy@infradead.org, raghavendra.kt@amd.com,
 chleroy@kernel.org, ioworker0@gmail.com, boris.ostrovsky@oracle.com,
 konrad.wilk@oracle.com
Subject: Re: [PATCH v10 7/8] mm, folio_zero_user: support clearing page
 ranges
Message-Id: <20251217122602.ecf88868aa473ff1d4905a7d@linux-foundation.org>
In-Reply-To: <87345851kg.fsf@oracle.com>
References: <20251215204922.475324-1-ankur.a.arora@oracle.com>
	<20251215204922.475324-8-ankur.a.arora@oracle.com>
	<20251215184413.19589400a74c2aadb42a2eca@linux-foundation.org>
	<874ipqexai.fsf@oracle.com>
	<20251216071250.e49ecf7490acf7f377dbfdc0@linux-foundation.org>
	<87fr994hot.fsf@oracle.com>
	<20251217105426.5f03b5e8abd2e50faee9f49f@linux-foundation.org>
	<87345851kg.fsf@oracle.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rhmxgdoboo5cczkim597hiynun8cdkqh
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 930F21A0015
X-HE-Tag: 1766003165-941178
X-HE-Meta: U2FsdGVkX1+liDvX2GkY7FBIPTjlGuNlE2JEta13THJw1lDMjV2RDn4lMEwLHKzgy6lI+a9ec/XTZE1EQ15sbN1zJ4mYt+iaFK3yOUM/JlHv9Cl5HB/2jzKQEN2uKcYT10EfVkfp6KrUjo8F08N4btICeXLnl+nOHCaJ9CInQj1yL4bqY3qf1ZRZrzlglGqj0boAxl3HWdXfcg7+UWlGgVOkgd/Nyaz8Ywb5bOcKIPopVjvUMCWgXeeLcdKbsM1wDCSp08pZsMpxsEQlOsLIip51h1NlFMl5YOwYF8ovL+hoIlyaJaQQSQOQD0GLXWwQZR27sd3XLFzpZdDnCbg1IRbFewQcoRfWUpPSDagc9acD229zYFv9AA5710PnwB5DBjW2mjWGJwjumIH3bRIl5EJXnnLvLWZcGrKFnW3XM6pTOkV9AmZVgLDz/FvAPZk2vcw41/eCvAzdg8znrW53BiKq3NQC4dbIvW4LnyNrFD8RaZSpG80P7wOHb7hOg9sXWZskJdDMw/KjkAOheD1p8LR0uGtO2BcVQCwQDG9lM2Zg45YhICC66uAM9iQAMolt67W5IuZDX2KWOQdTI3LK8rC8KCSGqJ2EL9G2ZGF5py1pHAb4BVostklNXSGRr3zQkn/X2ifnJzOQuliVfFGGgqNJHSIy5bzoYMtr82gcJFl6P7VbevpnrWTcHDFuxXrPzeEEnJiqWmi/itoTqTFNkqcdR8ZOqPIROTIqf6SlIJkbRni/hs/+LCVsDB2+OhVHKCQjYylrNdQLM2KuyElkPjVy7z0wnpuIbtRuFosv5a2w3Q0jNoEP6h60bJn/OnQAP23AgyqtGEWJh49ySmzovLCOtwV/Hogm1Z9T3K9t1/LTXRAN1dYr4sWVwc8fSQ2K3O55YuwcHujEould4ht9soPntsZbB4SgOT8emxwz8HvsbbIrVzvF9Ez4iKFxJ9rKMODa3jB3mNeHBUmpJRM
 kO309eeI
 D2NHs1wQgw3twZhkVV3x38rwZhT90Cjp+laZ8Aq3sodhyUu8/Y58LdUsdpOT9u7Ps6y/0ha1D8tVJbqZgaHLXyutnR5WIzEG6j98/rUVYvIzYI7BDafgKVCZiseOpeZ5mQ8lTuT8DKPB3gJ6h3kPR6XUeUFUHefEIy513yxIF9utXWJrpTnm7v18FD2pGWCGsQbb/k1GvXtuRpvpuWdjl/FczyAoVx+XzCdrPA5PMeX/xcOgWgH9GSaFow4h1o12n8QhCPI5arHBXhv6WHQiqXJiAhwZOcyBgP1D1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 17 Dec 2025 11:51:43 -0800 Ankur Arora <ankur.a.arora@oracle.com> wrote:

> > If so, what's the timing on that?  It would be nice to do it in the
> > current -rc cycle for testing reasons and so the changelogs can be
> > updated to reflect the altered performance numbers.
> 
> I can send out an updated version of this patch later today. I think the
> only real change is updating the constant and perf stats motivating
> the chunk size value of 32MB.

Yep.  A tiny change wouldn't normally require a full resend, but fairly
widespread changelog updates would best be handled with a v11, please.

> Anything else you also think needs doing for this?

Nope.  Just lots of review, as always ;)

What's the story with architectures other that x86, btw?

