Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6895CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 13:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 557B18E0019; Wed, 20 Aug 2025 09:19:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52F7C8E0003; Wed, 20 Aug 2025 09:19:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CB08E0019; Wed, 20 Aug 2025 09:19:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 367BD8E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:19:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D5AA0B9D39
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:19:31 +0000 (UTC)
X-FDA: 83797192542.18.9DC5253
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf04.hostedemail.com (Postfix) with ESMTP id E24CE40004
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:19:29 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MxDKVRCi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755695970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Rf1gRvfsQcsfD3pWbw3tEq8WPxbn5ncB2F5gE38IRc=;
	b=ln8dlF+zfEEatKmNxp0P2PJS8/9bNes8nLKlxLj1iHR9L2YiPAlh5M1P/fmkHcmFCoui//
	aNg8wweBjPCNT0OhzQ5aOY0/FIuWreDXcTBVeEQQ19LY5Kq9w1yM4nWJ+zXKTSiw7ADqG6
	J5syKiuiB5HGBEn1qGn+SUBuCBNxt/E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755695970; a=rsa-sha256;
	cv=none;
	b=t3y1Icc/tc1uehXjLVbIZH9AB/fX7KBtjujsOaL9dJFUFpHCBi4ebvc7JaUSY93DlwE6+P
	2gI4Ts/+D6CrOqo3fizFuNgDryLAs6m41NxxO0VIZXPk7TNe0yOEBJoE5yET/ftuf2e2ff
	4h/h/ffb4VvRJE+QLRlabHI4GqoCklk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MxDKVRCi;
	spf=none (imf04.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=/Rf1gRvfsQcsfD3pWbw3tEq8WPxbn5ncB2F5gE38IRc=; b=MxDKVRCiAxCdKxMNwjP7qRKHEu
	Tjs+AegVgBtZ3NoDzVBCPmIdeNfzc65MHMoiz7gNjJHVktqIm/JezxB/RFkKwc+PQBV8Ni90ia+t0
	NkvOdBJx7WOeUsJLk3pTyyM+CWKyzkQ9uNhb7rZq1DeT7XbSTrOw0w6D1Xdh0QYeA2DPrXyW4J0Se
	zHjFOHzPAny6IsoT2wUP/sX/tKGvYr+o7STD7b3cylwyn8q8QdFxAmb4El2WMnXfYZX2jS8d9JnJa
	h01FBXB7akxZE/hu676Kp9Xi6QQRkBKrQCijkHXaAin8JWKRsH8/NNKYQKKChJ1EY9IF/Kb5mI2kD
	k8637daQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoiiq-00000006rUZ-453Y;
	Wed, 20 Aug 2025 13:19:25 +0000
Date: Wed, 20 Aug 2025 14:19:24 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org,
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, kernel-team@fb.com, wqu@suse.com,
	mhocko@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
	hannes@cmpxchg.org
Subject: Re: [PATCH v3 2/4] mm: add vmstat for cgroup uncharged pages
Message-ID: <aKXLXJw7m-TSkZOI@casper.infradead.org>
References: <cover.1755562487.git.boris@bur.io>
 <04b3a5c9944d79072d752c85dac1294ca9bee183.1755562487.git.boris@bur.io>
 <aKPmiWAwDPNdNBUA@casper.infradead.org>
 <tw5qydmgv35v63lhqgl7zbjmgwxm2cujqdjq3deicdz2k26ymh@mnxhz43e6jwl>
 <aKUM49I-4D24MmwZ@casper.infradead.org>
 <i4hg4g75ywbera643uhtshkj6xrriqi4mi5dg3oga5os3tp6m5@u2dcv2snbiqs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <i4hg4g75ywbera643uhtshkj6xrriqi4mi5dg3oga5os3tp6m5@u2dcv2snbiqs>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E24CE40004
X-Stat-Signature: jks5srq3x7ybuh8xnume9z5i8oz9kds5
X-Rspam-User: 
X-HE-Tag: 1755695969-453273
X-HE-Meta: U2FsdGVkX1+W2efDvlxnlw/h5dX/vKFI/6U0HyMH07ugM+/Mdcj8xHIMN9wEHoaQ32zAFivTkgOT4Bg0ZwkF08pFGy5HaI6X9145e3imiYzf0dO/wusXQbbDTUkpJLllh/MCQZIaCEF3DAw44iBQDdvWRRg9upAPG5sVxrUAVLbSoDM0lfLNauVksOl32fTBnwzWxUSvGDfXUjqIICCLLC3uqUJwWlrVr0TsI9UG7CS8mb8YvOcqd+8VVT90SCLJGgRhBahA0jHXF8WMlOHFy+v4lAIdmKZHoabQAHKaltLA5jDCv1d/OMSPacwfrbXlM1IFv9Zudc5JOdL8kBVgRw/kY/LqN97dsgrMMWIcI+QCVgVv+6Ej8UMwoPnYv77fMxVrklD7IkLoY51uKdqj/oSXbqwxUVgxfMHl7GansNxY8wcEg8iPFge8PC39IKcKa5b4EBnr+mBN1s9FUPCvqV6ZRBTY5C5SYvFwmziVeV8ydxw6sN4gZPeO1ulhPafGQUgw0rNlsUUvewOpPpAu6GFEex6PLcL8OV56+qIF2KX6OKgH2WDuOelJ1uHzhY/Lyms3Jg0ivU5cteZ1pdO2K1PN2o6OC4Vs9LjIHlR3pn3JONefWK7aDB+os3OWMFJNCD4YRespAeLkEtLamlg4yRSKM6VyKCXiWAk/FWq0xGfm6phwTFDZSpL+t45BqN0nriGIjyNI+UDVjlUGG+z8VMbpW3htT9JZxv+8sDrXlqOLA+3gmQndmbYKzjoGnnvRgl2Q4eWX7v2d5riWVBHzRxK3rXjeVvYMfVriD9M3zRBQLQWV2RCy4wsgDSzStpbeqTrioeGLvHX0FIj0mnMgpGyck8ptB5jwwNj/Q1ERtgpvRcMOvnNauZ9w5ooCi7fnFtBjT9Z9g/kBCSbJoK71+5ynibHhi1ctTJL7uu/MH6nNmjWje0YcmnJEBoCwNcEpxzoEFcXu83jO1dNPVC+
 7/IwU4H5
 EcA6ei+oA66PiBMWdgvyDEj2spRBj6c43acU2LHoxtyFk+8bc6PkdBzRjwWB6ymJlTQ5UZW1wdq0/QQ45FEqmzXXLRL81hOMx1FjffZInwJJ3tBLnpslwPlHhGVaVqBhwFuc+0CXzQ7LT2MNRkxbZUoB6mD9F2Z3BNT58mlToMx/b7aw9oaIm+N9TSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 06:25:36PM -0700, Shakeel Butt wrote:
> On Wed, Aug 20, 2025 at 12:46:43AM +0100, Matthew Wilcox wrote:
> > OK, but couldn't we make that argument for anything else?  Like slab,
> > say.  Why's "file" memory different?
> 
> Good point and I think it does apply to other memory types too. I would
> call "file" memory to be more important as it is one of the largest
> consumer of DRAM on, at least, Meta infra. Slab needs a bit more thought.
> At the system level (i.e. /proc/meminfo), we account at the page (or
> slab) level while for memcg, we account per-object (plus obj_cgroup
> pointer).

That was supposed to be a reductio ad absurdum, not an invitation to
add more counters.

Look, if this is information you really need, I think you should come
up with a better way of collecting it than by adding new counters and
new complexity to everything involved in GFP_ACCOUNT activities.

The unaccounted address_spaces are a very tiny percentage of file
memory, at least as far as this patch set goes.  I don't think this
patch is justifiable on its face.

