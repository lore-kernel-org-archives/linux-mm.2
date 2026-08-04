Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BD30C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 13:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21F626B00DF; Tue,  4 Aug 2026 09:49:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AB226B00E0; Tue,  4 Aug 2026 09:49:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7B96B00E1; Tue,  4 Aug 2026 09:49:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D37946B00DF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 09:49:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 81681A033B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:32:16 +0000 (UTC)
X-FDA: 85063675872.01.B8E4E2C
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf08.hostedemail.com (Postfix) with ESMTP id A600F16000F
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 13:32:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785850334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfp49mXOUAV2D5cia35IYBA8en/xMwOnDJNMHIIQ7s8=;
	b=gXFDBTlKm36VD1XhUtOFH9m+jKzNYNGKOCBDQoIuaDWOutN+cKkZnJvkRGqhEc1PwQi0v7
	AP0A5dh5WqMVYMyPNs+J0rDPBpp2mDrDTwHvfRsEwmsKsv3lWguXmywT85vm9spnYkjgX3
	hYiT81/iZscgdJ37PZIbuGH87vifikE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785850334;
	b=yLMNvVzOdFTYelPjdIIh0FLoTQpvHx1ZMuG9SadKsPIZJeICfzJHae5n4ngHyLSiIZyCjV
	KzAiLiL4GJepMpFDjdloajdHMEtT3hI8T9ClT6izNDxgV6IYZ9E6jH01GeSGcbqZyjvvB6
	2srFBv8yF+Xogcui0Nhft0ZIGK7MRzo=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E2ABD6732A; Tue,  4 Aug 2026 15:32:08 +0200 (CEST)
Date: Tue, 4 Aug 2026 15:32:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Tao Cui <cui.tao@linux.dev>
Cc: Yu Kuai <yukuai@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>,
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	virtualization@lists.linux.dev, gfs2@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of
 blkg
Message-ID: <20260804133208.GB8078@lst.de>
References: <20260804065313.2092022-1-yukuai@kernel.org> <20260804065313.2092022-3-yukuai@kernel.org> <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a677f581-344b-4d99-846d-a00801e26033@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A600F16000F
X-Stat-Signature: ap5dfyhqjgqx9kmjd6bi4gye5odre7cd
X-HE-Tag: 1785850334-441468
X-HE-Meta: U2FsdGVkX1+1JmZIWwm1sM3YTeQxkiINo6P2ShS7aboBiT72/4HKWgZr/Eu5RKGcGsgyNPAtKJFiL8lYeF0nHsH4E+BmUKzLh4GjwM+T0sc3E9t+vzsSbCKLoNr0PR6QUa+K7D6KzG1BHZeRcy6GPT3/twMmBjXZBNsl1c1A3kJ5RC+5FkwkducWdDjYMxYfZRmVSdCq01xNg8alw/TF62vU9gNwEs5mAN5/O1HOxH0yLjsRtM8NxO8t3zvii6MfQBjs0+Jw24UXksg5vWFAN4XZmbf55qEitkjOBzVhCzVOkOyq76LdLBG9BPKr9WMrdupMFRvL9TsYK2p44NvRFxWHivTA2xnlKjsLlYanCoQfFsF0zIpgZWZAm/e0vf7okZs9GbozmzvE6EGRf3hC3bs6a+pjNCGOTQpAnA1m9DLoXpSRp1+PRRKDV+NUeSNCS/5yRaw+Nq4CariwO6uXt1ZcFg7qQBEGzgefyaaUXj9YcFagtzFp1JgbyCLPwt1CgDYrlr4rInLKD2+SRLbqLFvHoRHX5l1EBmi1mGvOpQLjtpBFK01P0HtErImIp4Ruzewoy5bmum72crQ+d/WG1GxqTi77Hbx/fADtvgWjQUrULNju0yVFEJdsWFyD5zksPk1EOby+bCtYiRDDepiZ4kaFOVvBdPFHfJeWQ0NUcVvb2yb32ernR6zsp09XItbx+hUfjUgI7Cr4uxLn3h/Alp2DgVZ4+4s4JAmirP8dgZF5ra/GigEOOy+MjEy0RJ+jTqNevAbW/LXxthpWWzGN6DUxHi4KWxA1tkyvE06uow3SWG7peJGWlIcCN9F23nD8AbAi8Px4tatYXcb2c3HSPkT8VDTYsBBK8+KK17KN/O9UGYh8Hw3q+efXyNDGn/0V/zkJuA6W2e2VjIyrBtkxTz/7U8Re8KG7ZkrgFwuuaNT6bjKy8LqWwl1byI4/QLlI+ZZUvdp7DBNSG6kysuF
 k5jr82Bp
 bceR7SXlFHqmEsaSvJUvshwvJOsQB91v+9tWLSfzMg48g8pUUhSOzFsP7Inp/0ew38wAtXUfTkMe8VRDJojJvp2eHj+XQ9KyDFYWPwRHRmFxWvsm18yjSwf9jBTBUcTP+VmxUky4HCZBvAeYYyBShgtvD86Z9CfL3B/JL2iLIX5kdEAvqOw8pLqLEIsUWpM42O0jQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 05:19:24PM +0800, Tao Cui wrote:
> While reading 2/3, one spot in bio_pinned_blkg() made me wonder, so I
> gave it a try — and the WARN_ON_ONCE triggers every time for me.
> 
> I may well be missing something, but my worry is that the bio's ref on
> the blkg keeps the object alive, not its entry in the radix tree.
> blkg_destroy() runs throtl_pd_offline (which only schedules an async
> flush) before radix_tree_delete(), so the queued bio ends up dispatched
> (blk_throtl_dispatch_work_fn -> blk_cgroup_bio_start ->
> bio_pinned_blkg) after the blkg is already gone from the tree, and
> blkg_lookup() returns NULL.
> 
> I applied the series and wrote a small reproducer:
> 
>   - null_blk, cgroup v2, a child cgroup with io.max rbps=4096;
>   - a read issued in the child cgroup gets throttled and queued, pinning
>     the blkg;
>   - migrate the reader out and rmdir the cgroup; the queued bio is then
>     flushed after the blkg has left the tree.

Can you add this to blktests?

> Maybe keeping the pinned blkg pointer in the bio would sidestep this, so
> the lookup can't miss?

That would grow the bio, which we try hard to avoid.  I think the way to
avoid this is to have active/passive refcounts on the blkg, where an
active one keeps it in the radix tree, but a 0 passive one would prevent
the caller from getting a new reference to it.  The users who rely on the
pin for the I/O completion path would then just keep the active reference
and use a pure lookup without getting a new passive reference in the
completion path.  This would remove the need for BIO_BLKG_REF which
feels a bit kludgy and eats up precious bio flag space.


