Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A081CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84016B008A; Tue,  9 Jun 2026 05:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5B0F6B008C; Tue,  9 Jun 2026 05:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70746B0092; Tue,  9 Jun 2026 05:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B680D6B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:02:38 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F1DAA04A7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:02:38 +0000 (UTC)
X-FDA: 84859783596.16.032324B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 36C2114000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:02:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dsLDsInS;
	spf=none (imf09.hostedemail.com: domain of BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780995756;
	b=YGka68CLysUxxzt2Pe4zwwzT1IRltbKC0B7KGoHuHerr0stUnHirfvHYTM6vDvxbSST1Dl
	gs3e29OrprGj0y5DcHhUzfJ8nTOY1VLi8m9KnGCoHvPn8H/6FM/vlko85XStjcze4+2a2I
	/8BuCNxqTgIRe18Sqqf2kRydVjbo02w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=dsLDsInS;
	spf=none (imf09.hostedemail.com: domain of BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+083e98ba33f2cf22ed17+8325+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780995756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GC+JFhsCFvp9I/Y1vIdUPY4ekT1XSIP7QJ8l6HwbvF0=;
	b=fIr0HL3/4wx+AycOXZjn2QGBw4c3SXHmH8hpIUc7Ar0oJgyL9+M3YUKd1cXNawmUYXvKJ5
	rIhSRmFZa4mLJ8gPXG7mQRKgK3vDD0/p/9KC0nn5yDp/pe/x8oK4yzYHPIGEr8ZRSZhAEq
	Mum7vG6Dixy7x9urQf+CgDX1eN/y+2A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GC+JFhsCFvp9I/Y1vIdUPY4ekT1XSIP7QJ8l6HwbvF0=; b=dsLDsInS9LgdI49BKcSHqGKzP5
	RUD0cSBudcKScGPIp4griuRcI+vx7ZBC90UCwVLQINp3UPJJeW3UVDvaHup0rAZ+vmozbwhoTt5eN
	WGruOqfXRt4d+GwJYOn7UHj3aoFbnNsz0+bVvqs3HvEEcz/m8IVzAVW+cBuydAP8G7ZGTTawReOtK
	8r+Aoi2Z08gpZM0iRcgKPXA+6mqjRLQKDQLy7hMZSd5akZv2iE6oI1OuAbqAL7w9Za4bdShYVsQx9
	6oRE+UHYhEMD3+o1Q4Y/gU8cpSOA0xusbruF7C2Eksu4GILWR9wG4UuJqcSC7zdyVuhLMoRAXP+fv
	OG3ge6qw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWsLw-000000058d3-11W1;
	Tue, 09 Jun 2026 09:02:32 +0000
Date: Tue, 9 Jun 2026 02:02:32 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Andy Whitcroft <apw@shadowen.org>,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: increasing PAGE_ALLOC_COSTLY_ORDER, was Re: [LSF/MM/BPF TOPIC]
 Memory fragmentation with large block sizes
Message-ID: <aifWqFpSkcMU31UO@infradead.org>
References: <f22caf98-1375-493a-a275-0500ffac3e81@suse.de>
 <aifAm1rRKF75HVeM@infradead.org>
 <1225376d-dc29-44a1-add6-0cb14926a538@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225376d-dc29-44a1-add6-0cb14926a538@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 36C2114000A
X-Rspam-User: 
X-Stat-Signature: xgeo6t36o53fznx3gtky4sp4irbki6kp
X-HE-Tag: 1780995756-277440
X-HE-Meta: U2FsdGVkX19NM8gm7A4Il1LNiuNgEiv1kNUl97GSZndojutYp9qr1/JySHS9ZrwoziseCl6Mnp8mSpmqxhxTsF2ZQu82dqJENUUu7Is0k5O6vdLBw6omYRB0QXMdApbNTtpimTKaEX850xNh8QfOn4PI8oY+X4uSQWu/vODcZrAQ4rCF8Wf7gj2NKxSFW+rSFHPS9pqe/nElejN1RD/JfHacZEhPtikWXSVCfd/4+fyBksyoWBX6KQ8JddJ20iO20nzSHlkzojOFHJQ9TKo+DnrcvjZYrIivxzosiiuPRlx1mMYfOhIowKmjsInwIZr24CzlhSW471Hu/ETVFR2+2W4dS5jXrX7tvcskrpTqkmgDa3RXVUIPl7EUhZxIXf1XZvqMNNnOgZ5mNg15Vl1qoLcVg/Jhcacdbasj0YFDGpYEFFjBa2LpRmnqheWCHAhW+ZEffddWNwDuWYXmNtMtPYXbAKa7NgQqb0c2eIn4WB/577ZFI5MuXAVzDDUxGBaqY9qyJ+mexhAQfhFUrFGOVXowwQKhrO11Hsg8Jfb7AHv0aBc8gxAI8ZDcNlJjuNh6jQrXhaxR4R1JvDxd7ySNyYzyzN3tw+TnOQuPBFRQe1IFEcMpUOLph6lJYIeBtkzlq2UbAPbpLhZq6FIcWWnhqQCO5oDG2sisfHFMxmCCSobKR7/zPin0qayW/xLEYfo9oAgFyWtEYTj9sMw1FoylImuUIdZZ4GImKKZVcbcpfoFX8RnHT+HM6WjEpFwGBoRNgwDOblJ7wFL8qKlC/2CwcpnJJBJHxQHcfkWXA2semCNsWsS9kDypmp7yA+EZvqqCSuXyDrOJhLBsF9VT7CH5NRZF41IAa0fcINdX3Vadb+scGzelGhKazE2BsL7HrvreyKLIJQT1kO6wVILE0gt6u3bNDxNePcdsH7S6AKCqKbYVX+ZrNfIVfFvHxsMmE3T3ltS2l8NFWtDDErThWS5
 7dAMrjQv
 sj2UQBN3NKQfGrxMgwpU77TkcBwvLMlm6fHscbu1yVauwgvRjOj/6qXMSauE5mV0oSHgo8V4dWX03ghrYfQ4lJGzb9dSsR/zEz/+0ymbHT5O6e7d68edHtPzZ6kGYMBkiwg7L2pfAbrSiLHl2jsKQcq2yVum7ICoMnhbZv9A93GgK8HB51MyTFpmd3rf9Y/WuufYSHjSC4KN5fOha1tb7JkuQyt88DBNLs6lPBPqivVLo6qPFMKD1zvMTq9qhLjJhDPOl0G3LNlxstbed6dUN9ePBbN+RU1oOLNp0U2fq2fbgm5zQUGIqFvmzAqBYtsXoqVoiI3E+sEzMynB48xTxrLTR7HUgyHn3WQLzmjUjdwU+427xs5n4HXXxjF7qVmNMjSeDTJkWsU7fWuEmsCPiNA28gC+bxb1S4kU8E8iqJtGlHus3zEfx3brfD8pDxAB0zKrT+Uqxq1LWEY/HV6jyoMnWXa2EUdrVhGq1ZJxWj4DOdjcHzy2xlqWdiCFE8QBcdPIfkFrANjP9NQ495ryypxb2e9nTlyqbJ60zziL0bo8r507HGAP09lFH7+o4qYWJYF48NnTNcOItZJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 10:39:14AM +0200, Hannes Reinecke wrote:
> With 32k block sizes the picture changed completely; the 'bump'
> vanished, and there was only pronounces spike with 0-order pages
> (about four times the size of the spike with 4k block sizes).
> 
> This led me to assume that compaction broke down at 32k block sizes;
> this assumption was confirmed by Vlastimil Babka who pointed out that
> there is a maximum order to which page compaction is attempted:
> 
> include/linux/mmzone.h:
> /*
>  * PAGE_ALLOC_COSTLY_ORDER is the order at which allocations are deemed
>  * costly to service.  That is between allocation orders which should
>  * coalesce naturally under reasonable reclaim pressure and those which
>  * will not.
>  */
> #define PAGE_ALLOC_COSTLY_ORDER 3
> 
> and it's main usage is 'order > PAGE_ALLOC_COSTLY_ORDER'.
> Which ties in directly with what we're seeing.

Yes, we've also seen similar issue with memory allocation beyond
PAGE_ALLOC_COSTLY_ORDER.  Right now the maximum block size supported
for XFS is 64k, and there's various workloads for which we'd like to
make use of that.  Increasing PAGE_ALLOC_COSTLY_ORDER to cover 64k
allocations would be extremely helpful to make it perform well.

How has PAGE_ALLOC_COSTLY_ORDER been chosen?  And what would it take
to increase it?

> It will probably make sense to align the maximum block size which we
> currently support (ie 64k) with this value to ensure that compaction
> works with larger block sizes. Or maybe even the other way round;
> tie the maximum block size which we support to PAGE_ALLOC_COSTLY_ORDER.
> But that would mean to restrict the blocksize to 16k, whereas xfs
> works happily with 32k. So we might want to raise PAGE_ALLOC_COSTLY_ORDER.

block sizes larger than PAGE_ALLOC_COSTLY_ORDER work, but it doesn't
perform great.  So I don't think a hard limit would be good.

> Question is, though, how could we measure the impact?
> This particular value has been in since 2007 (commit 5ad333eb66ff1 'lumpy
> reclaim V4'), and it might well be that the original
> reasoning doesn't apply anymore.

I've not even seen much of a reasoning for picking the value in that
commit.  Or did I miss something?


