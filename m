Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F0410F6FA1
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:39:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED5346B008A; Wed,  1 Apr 2026 10:39:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACF96B008C; Wed,  1 Apr 2026 10:39:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE9D56B0092; Wed,  1 Apr 2026 10:39:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC02E6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:39:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C8328C6E8
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:39:43 +0000 (UTC)
X-FDA: 84610245846.14.62B712F
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id E2DD2100008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:39:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MbiMBtFd
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775054382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kz9xdstn7TOu/urPKjmoJJTfAwSQj9gbccp6E1YBcZQ=;
	b=y9lr74uq3/CevVWGntpaOXoeUDaOCgqzRDhhbrRtilmXgM834XDoKbfMKJHhqR9qSxUWwH
	T38zN3y+ZtaaqKlFIJR9i4Yq6rosfhpEQkpphSAMFT107cpiJ7++Ovg/5pVwEvZeNWehvb
	VRGtlTndyVnRrA6gfa0qYAwJJBQdem0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775054382; a=rsa-sha256;
	cv=none;
	b=VaKqZo9N2uzvQuv8FVIOPFIZcCnkUaV/zt7eWj4glc7d+9QxN3hq6wC9Jhx/g/tVI8k8Cr
	VifxpvWhV71VI9MN3XaTaEVtdqE+VwMcL55z9fNcI1E5WHbWBtM7TslFKB+aRxbTcoraPb
	w5ACL52iXbCpAAcmJdjersAWRv8AFq0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=MbiMBtFd;
	dmarc=none;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kz9xdstn7TOu/urPKjmoJJTfAwSQj9gbccp6E1YBcZQ=; b=MbiMBtFd8sy6bcBTxzwXGMGp4y
	SLdX++76Av545JJkZ//03Vg21lujlT85vY6KO5Z855vZfxhnWaDUWgG3vcxDzZRqfo5IeGcS8AKf9
	a6jNEJQggp204zXYKicDBoATturVJ2GrWdb0TN9l3DZazjFu+Ey7VIlC/keQl6VDYVJYodBsft33D
	DXpX8uySUXHLeALPE3lzasNYyOvJ8yf7mpXkrOdRJidWpWTwWtTO3bMbrsIeMgzuqD2L4RdF0g7EY
	TGcweAEORZOYQmydBCJngjoRdTrekqAXHXqgA1DYGdEnrvodj/JkVzNrwzm3prfPZ0ikMvfKiv90S
	q4VD+Srw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1w7wjH-0033XU-0D;
	Wed, 01 Apr 2026 14:39:33 +0000
Date: Wed, 1 Apr 2026 07:39:28 -0700
From: Breno Leitao <leitao@debian.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org, 
	shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Message-ID: <ac0tQb96dK7FKkCQ@gmail.com>
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <ac0q37PYB-2DZhLk@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac0q37PYB-2DZhLk@cmpxchg.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: E2DD2100008
X-Stat-Signature: dii874bti63y9uq4brxi896rjjd5k3wg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775054381-501795
X-HE-Meta: U2FsdGVkX19LchZcE1cUYNNGReuYYmtEUNf1p784RxrqtX711S1r3L1k3SmTI/hcc5SUXcToTyPpbrllxcoa4mkBZpagzXl3exWffKwbMRJ94O/csPU/UtjxMsXcMsZDR73r6u4M6gg3COwrjzfOv6M4rPgIEN7PQZaoGIgxsNgpCNXSCUcn/V2bye+zX9+CTL3EH2CchoOKukQa5yc2uLn5rZiLMsZZORIjIwdS79zcxH0HOAjiR75wzEo8BATYRyFdF0bhPqChbOf9pKR9v+IzvWKo+NyCm1QCPdYKQO/cvpJBn8exT4LclrveCS3e/VO4GSlaf6aDAXfhlODuURqd9jHQzZBE+lQoYiNAOYBxMMWIPm0StUMPNEfyOygcb67RTVaYfY0sVmAHndkWmqSKmmZJD7K7u7COO5vZ4ZdpETU+priLBXQ9xHCv90nKNDBor0ckUdVKU4YxZQ0QOd5vNKR7q5Cmu6SrxLZQnhSvnvMaLzEY3hiAw7+hzGPdb0JXhqpHWDyrGgxxEWx0SvMZZjFn0znv+PekOrfGHK72VpUpm611wWVnhsbTWjnmNZw2v6ZxHeX4quKSpu5rksJRVMDzsb6Qw2FGryQhNmCdKUicVR3fYQW+uecbLR2wCKfLCc7VIFhKCMM5xtlzogPGPT2e8YGMi8i3kefLBepy2NtapD222MbBDj5hOyZHAk07EuosST0fVI6vCec2HcZSsrykcTCLRd3WGCzAyJCuGJEKp0QHgET5iVcgpJQjU682rtvy+DYsH34CYKfed0pEO1GmhIZsv6t4beEmVxWdY86KkToFTG08M7r5HJ2eRNX/rUkOFXHNscO1gC9g9OQQBvqkzAie
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Johannes,

On Wed, Apr 01, 2026 at 10:25:35AM -0400, Johannes Weiner wrote:
> On Wed, Apr 01, 2026 at 06:57:50AM -0700, Breno Leitao wrote:
> > +static unsigned long vmstat_spread_delay(void)
> > +{
> > +	unsigned long interval = sysctl_stat_interval;
> > +	unsigned int nr_cpus = num_online_cpus();
> > +
> > +	if (nr_cpus <= 1)
> > +		return round_jiffies_relative(interval);
> > +
> > +	/*
> > +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
> > +	 * use round_jiffies_relative() here -- it would snap every CPU
> > +	 * back to the same second boundary, defeating the spread.
> > +	 */
> > +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> 
> smp_processor_id() <= nr_cpus, so
> 
> 	return interval + interval*cpu/nr_cpus
> 
> should be equivalent, no?

nr_cpus is the number of online CPUs, while smp_processor_id() is the
CPU id.

If you offline a CPU, then smp_processor_id() might be bigger than
num_online_cpus()

My goal was to linearly shift the timer and avoid creating gaps when
removing certain CPUs.

Thanks for the review,
--breno


