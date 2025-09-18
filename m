Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 533D0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A8A8E00EE; Thu, 18 Sep 2025 07:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73B1D8E0093; Thu, 18 Sep 2025 07:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629868E00EE; Thu, 18 Sep 2025 07:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4A97F8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:04:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F24091D9BA5
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:04:40 +0000 (UTC)
X-FDA: 83902087920.30.544158A
Received: from relay.hostedemail.com (unirelay10 [10.200.18.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id ED81410000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:04:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758193478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTiwsv6wmG7rGTDBicxC7G7Ssu8qjovk7kpWxAu2Q3Q=;
	b=FTASRtjCwsVAxDgbvKDExbcfIYkyPK9EJbB06pP46C4Qhf4RQzSoF9LpzNuBzPlU02eWTm
	oo5hugFXqN6+JEdDsKWDkdcC6PwvTcHCg3bVeeRVatP52QoLjhGJrrvyVoRibPzaKh4wN8
	FSO7MqGWGgXdmv826R75ycflqtud/tM=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1758193478; a=rsa-sha256;
	cv=pass;
	b=okYpZpEsrWBKgXIXQM8oM7bcGumA64UrHsksxXGPURPy9ARIEDbMC02wmxRMOM/1q9kHaJ
	h85a9Xg07AyZSO5z1lB7So+6Ya5O7rJEzX8GLlj//Xg8s9+ZOk9pBZb9Ylp5oORl3z3N6n
	5o5VPt89MiHeqkjInQJ9y4qBmrTuvK0=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 806B4C0142
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:04:38 +0000 (UTC)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B0F955D16
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:04:38 +0000 (UTC)
X-FDA: 83902087836.15.0AAA8C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8F869140008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:04:36 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758193476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rTiwsv6wmG7rGTDBicxC7G7Ssu8qjovk7kpWxAu2Q3Q=;
	b=iWGgs3IS+Kp0bthq2stDoHOgwvGA02AtJpS7X6sVbSt0PYi5a6iYiYz9apLY7Ij22zDM/E
	31+5QpqwTvK3SmCSQ98ofzznbT2SGRuaYFBiUkNWabHZEo5sMaq4FWZWDUS2cFqZJyc+Vm
	t+9dT4BovypxPHLSNC9RmqVZXeVnxc0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758193476; a=rsa-sha256;
	cv=none;
	b=TGPTn0DrNXwtdU8eoOVu/276OQwWSzRRgYnaeRtiaFEAztPwavINh0zYYXVBGSNwe1XoXo
	yyWWCZsQV0P96BfgInjEGVxvHdonh7tu9UveJwkhy3hrPZVHhccFwal/xHweGX3nosPJCm
	+ORNeW+NNOYUqZTRrRmXyznw2NHshFs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nQM8OClx;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78E0B4417B;
	Thu, 18 Sep 2025 11:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F35C4CEE7;
	Thu, 18 Sep 2025 11:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758193475;
	bh=NojJZ78hZ55rnnC8I9+5CwqPB0jcr195D5wT3H9zTxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nQM8OClx5HgL5ZvYw9JdwnDSMBMqgop7DN5U1oBDH5u7NKxtvBIRZrHZpC+mii0VM
	 A/WZhFzpYbLjlUdWUz0QgklN1gUYyyKtJJASgRdpa3UzIDbMdRvFpsmopVfchHdbBt
	 Dxp7GO0SprZwOYRJYkiy7eNVYWs4EYt7Y3Mu2LDKcf1MXYmdPZZXKTWannvjeIarQV
	 /OqDRIzFlRBTEK7bSqw62VusRiNY5MASWXVeHcJWbPs+jqBMVuSt51gOluj5arU3zw
	 meNAbq1dRLWQ2kM9d5yXEXYJFe8kEWBQe8wpNRwE7pPjMEQ8+RvQgZZOfwWDd1yxDI
	 owCfxJVMadMPA==
Date: Thu, 18 Sep 2025 14:04:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/4] kho: replace kho_preserve_phys() with
 kho_preserve_pages()
Message-ID: <aMvnO2FH-cYzNPGl@kernel.org>
References: <20250917174033.3810435-1-rppt@kernel.org>
 <20250917174033.3810435-3-rppt@kernel.org>
 <mafs05xdggifr.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs05xdggifr.fsf@kernel.org>
X-HE-Meta: U2FsdGVkX1+4mw5pt6QfSsA/XhvZwJHh6T1uF3yzUCNfB1dIb3wkz6MGJCmz5wy0EgRu2ELOhYQIcHziHa/VnkHW79cxHUwU19CCEHUrjVqp0dR1VClrF+cIwrgXvyTtNYkKI8KVE/yD5VQ/Mga+RpvQXubBj2v3Rt4xoDGkpwq6GrICx7H7NKcqWZslt+a/QgEDX/s2t583jf3J+W1Qkafn8nqCYHk+e1fCeL9STz9e9fhrTxBU/+L2HfEkoLTMSH/WXfy8LhEevvlGZ8yhETs1e8teaBMWbpbqiqqJHvU0OtPAk2s3Ra8yjnhX1ADIDSFOFm+hLvnC7BKDMdLZU7cp8jGCY5n4HUF+UakgH1Kk6Z8wQQ8lS1Y5RN7ZVpzNKD6YM0pJzqsAQUFbgWo7XzJKyaFxdPC1cq2i9fQMpemX+gwtEGjEFKN3ghr4XWvx/xgQxOx/4UVzQgbHOcYwkxa3HY9xEG2kOlfT4im/22HidH9Zgc1J6Qhu1o9iCwaY+xe/hbwVTPMUjq1BpHlDb+mzXtY5QBJC0QL6UaQdOpTzBqvUzJ9vMWfw24S+8cqgzzpIOKlP21Gmk8grFYRRt4o66k4HgRBuXfrucJ4xTKL0dx7qgT+FfWO/I2uHkW1fgHuWW/IiJRegy5tK7Yf6ddSYXvLxdSIU8VO3nUqd2ZTBTT2BLpBEAT+UdR9uQtPD82vGLqGp3/myewknWa4dpi93rRmw9GaHqTw9rm6OajfRYJte674NEAmYK6dfY7KZ6/TqH7Tp751TR7EF+kbZs+15RLeJpbR/YLWafFrYT8cjymT+U6F9Y8U5AQumC4FHyYpP34nfqJXbL7qCYYebFP90Me+eUQ6CdJGiKbo4ACXAFnkVOq3wCxqt0j6D4xrykOPwU6HhQvdv2/peqyQAMaItbUq+2gqa/SOGFfV/B8THlnctK9zdaqDRMqaaD2Q+Ht/F4bWDrteGP1S49zP
 7tvEnms8
 RpqEOTXzc2W5QVRiPhrE4EfvBBbZOXFbwQRpfEHqXFeHN5srHO8yXp2iTA6moJQBIU5Wv8upcf+Nxyyb66Aj09Gsguue5ZiXjCJ+Hq10QnlEDRQXAl0oKRB12sCvlNguKNnSES7c3i/+glqaDxAr2VUU5dzWQnujovW23n7HdW5tQ2P7n3mXliwcJnHLQRCnMx0u2PmbwopeqlnBpO56XtcrQb3y4c2DG5yt5s9hFOEvTuLPZtiqpbjNBuBkPAEZEcKSOq8VQE2+SonapF1F5Lv3+bzg0IjZp3Nd8pRITDqqriSI6o1TYbBZwqsehBCauMxWB
X-HE-Tag-Orig: 1758193476-790354
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED81410000C
X-Stat-Signature: p9zgs8dkt9gs596uzrw8z8h81pnu3prw
X-HE-Tag: 1758193478-995302
X-HE-Meta: U2FsdGVkX187s9IH6JLHdnL4OSmt34TFD0rDUZpeSjeW/HQfJA6rNoDhRI2Vie2NHwOrS0txxi2e7TTqTRk2RmiVzrppcKRu3Pj9vTgpVxwyRP6+XW/gHjkDHlSl56YFC6OxdDRWBqMkdYyxMFyMn4ESsB5+YVA4b/4Q6lh6CYB5ugIFQ5PGwTKKpqTsHFD02QbZ0TO84E4x0zRTWH6k2XGskm5v/RL+sUawds07F3KkLbc8MBBo1qS/HFpebm0qIgEGDKU1B/Nqb+U/sjMmfx3l0eW82lTnkW0E659nqQEuBDiu9gp9d1M1EuoDhm0rpKoTII2TVmDPQpgocyae8vBt+/R3WnB/JxTBfU8jZlFGuIexpYoWSvqWc7tVoBlTQCukqSTxt3I6Af2WgPBpyWv6DKKm+3RhSdoFhYEfK5wYciNKUk/rmEcC/MTQJYBepr6UQHPFhGwvcdIGV+14aS+QOGMwYYjNLiEo2VpAaNhpEl3efEyUMHHmrHvqoTOqfklklC63n+8LClH2dZNEnAdoJjaxPGeIJu3XyVyamc9VR/SI2Sr1oyGpuR5uCX9XkQ7W/lVsth846vG34xDz6enHfKOX/uyenEQtuaeHNF0hEh0HG4A+EReAUtFB5A7iZstxQ1l1kdBxoWq+kLIDEIEOp8l3//Pq7Imsh7YSMafYn9/wenOFCK2N+qDFFh5FRsUdI9kj6w0KAcM/cHpyIzI0jCbzO/bfxdk8zrd7cyFuiL1J1KItRXIuluJHVkohQuosLfakJf1e1Esou2CJnBGyJ91ycm9a3GD2M7gugZFqmW2PS/Art4inVvtZyFWjkQvyjWAf9MBHqpfyy/7JohqsJNuZRUO2adL4HaJsX7k6SopmbjsCi82it//2umBF6iBV2kb25odFsEN6I4qZk7NRXPu0xgaXOWRnufycqZDUwJxpwr9HMP7T9oGfsgDtkBScxamcZ0UIfjL+5va
 N4ioasm9
 q52ZTC2w47Y0WR1MOAOin5a3GXVZUjIEXz05/ApDmxF712tY/xpG2PeW+qXR6bMVZBaz6o225aU3QMmfy+2ZfJoNtOUIAXLeJ3ZUWFk2OqiNEVPerRXYHX2GuqUFbDXl3jmo6dRYEJheWEhI3tJVFTZhZvKfrQlo+39u+WKUQZ2MVfr6WFY23MPHD9wuPZ+1HzH985oDeeK9tHTYaNruput0hQSqeOzjJnj01vIa2LvKMepSEuQPL82SLhXTi8rl5ej47WZLjuTIKpQo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Pratyush,

On Thu, Sep 18, 2025 at 12:32:08PM +0200, Pratyush Yadav wrote:
> Hi Mike,
> 
> On Wed, Sep 17 2025, Mike Rapoport wrote:
> 
> >  /**
> > - * kho_preserve_phys - preserve a physically contiguous range across kexec.
> > - * @phys: physical address of the range.
> > - * @size: size of the range.
> > + * kho_preserve_pages - preserve contiguous pages across kexec
> > + * @page: first page in the list.
> > + * @nr_pages: number of pages.
> >   *
> > - * Instructs KHO to preserve the memory range from @phys to @phys + @size
> > - * across kexec.
> > + * Preserve a contiguous list of order 0 pages. Must be restored using
> > + * kho_restore_page() on each order 0 page.
> 
> This is not true. The pages are preserved with the maximum order
> possible.
> 
> 	while (pfn < end_pfn) {
> 		const unsigned int order =
> 			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
> 
> 		err = __kho_preserve_order(track, pfn, order);
> 		[...]
> 
> So four 0-order pages will be preserved as one 2-order page. Restoring
> them as four 0-order pages is wrong. And my proposed patch for checking
> the magic [0] will uncover this exact bug.
> 
> I think you should either change the logic to always preserve at order
> 0, or maybe add a kho_restore_pages() that replicates the same order
> calculation.

Heh, it seems I shot myself in the foot when I suggested to move the sanity
checks to kho_restore_page() :-D

We surely don't want to preserve contiguous chunks of order-0 pages as
order 0, so kho_restore_pages() it is.
 
> [0] https://lore.kernel.org/lkml/20250917125725.665-2-pratyush@kernel.org/
> 
> > diff --git a/mm/memblock.c b/mm/memblock.c
> > index 117d963e677c..6ec3eaa4e8d1 100644
> > --- a/mm/memblock.c
> > +++ b/mm/memblock.c
> > @@ -2516,8 +2516,10 @@ static int reserve_mem_kho_finalize(struct kho_serialization *ser)
> >  
> >  	for (i = 0; i < reserved_mem_count; i++) {
> >  		struct reserve_mem_table *map = &reserved_mem_table[i];
> > +		struct page *page = phys_to_page(map->start);
> > +		unsigned int nr_pages = map->size >> PAGE_SHIFT;
> >  
> > -		err |= kho_preserve_phys(map->start, map->size);
> > +		err |= kho_preserve_pages(page, nr_pages);
> 
> Unrelated to this patch, but since there is no
> kho_restore_{phys,pages}(), won't the reserve_mem memory end up with
> uninitialized struct pages, since preserved pages are
> memblock_reserved_mark_noinit()?

True, this is something we need to fix.
 
> That would also be a case for kho_restore_pages() I suppose?

Yes, just need to find the right place to stick it.
We cannot call kho_restore_pages() in reserve_mem_kho_revive() because at
that point there's still no memory map.

-- 
Sincerely yours,
Mike.


