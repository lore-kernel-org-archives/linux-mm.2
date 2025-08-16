Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92C11CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 00:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C338E0224; Fri, 15 Aug 2025 20:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AE418E020B; Fri, 15 Aug 2025 20:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDEF18E0224; Fri, 15 Aug 2025 20:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D932B8E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 20:07:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 67DD61A02FF
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:07:07 +0000 (UTC)
X-FDA: 83780680494.19.1F25F52
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf24.hostedemail.com (Postfix) with ESMTP id B13DD180006
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:07:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMf+dC18;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755302825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ep1Cj7OA6YFa8TvcgCF1QF0uDPPolGQq1+dc0W+qing=;
	b=brSFBQGq8cTMSPOzQdkm7mSeOodWI+1/4KNfdt04qQbzNC+0uMiSpIiW7gfrmcQcrh2++X
	a3Ulj3RHOF+CGCYAyy4AvMWK+YYTSsMNUIddiy5J7sQH7ShPolGIibsUDhjDEhOO8Uv00N
	WsAlCxJu3dV0bHqr8UnLSnIMEhFJVN0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMf+dC18;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755302825; a=rsa-sha256;
	cv=none;
	b=6ytgRXqA8jZyl3cNNCt2ducnlGVYfn7qAlzYWd5DWxLS4K9xzTJd7dm41lMBkX+rcfELpx
	ikYznYc+F2mNBPP4kzUY3ZU1nAphkYp0p01eZcWnNkJms1XOy2VLkWUkvt3MGgl4iyPvR0
	Tx8M+HdWJRKuO+CTsqKQNHZSb9buB1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 0CA86A57A35;
	Sat, 16 Aug 2025 00:07:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F7CAC4CEEB;
	Sat, 16 Aug 2025 00:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755302824;
	bh=+7InZKab1A6cmyKNxFZYNSs5pQCLVO7y8nEBO2jsTxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMf+dC18/RoSmZ8NitdCIj8RPm5ygXauWGNGpZi5SE1DL9kU+eogqSTOH/RaSl/HE
	 INzj9L5q8hAWhI5DRKRnu7z4GXo0wwoLfzr3ZH/304b3MgWUUV0SVRiZzx7GC+Rawv
	 Mj6MBhKv63kJ6X0HKIYY5hmalEsqCbVZm4bK4TCutj5tBzKsJfkRsCGgeaFrtt13Q4
	 W9/+Acg2stkd4uRKIBOSMCIm18aC9EFiuY+24JOVdR0io9NXL2c5qHijZafQqjIXqM
	 HHa+ksKjDpeoTdWU8Gn8qTiD6RAz0+B/tN16rvu1ZmYtwOXgc645P4vb6kZVYObBe2
	 OQ3cVddhEQYng==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Fri, 15 Aug 2025 17:07:01 -0700
Message-Id: <20250816000701.90784-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B13DD180006
X-Rspam-User: 
X-Stat-Signature: tehgzx6kfrh6qcg83kqbuhn3sqctgyyr
X-Rspamd-Server: rspam09
X-HE-Tag: 1755302825-355890
X-HE-Meta: U2FsdGVkX19KJpIh5ng3eaTSdBPDY6qPxH0F6NzxWMWU+civBve414J+fIRnTapSR18Uh2K/Yk4jCSvV58udRf1dOEE9xLkYWR69l/MhIVfngTDTPTjcd61Gk/FbIiBHw82hr8+T9/gN0I1eNeGvWVTXfvBlS7k8F+Gqh95bHoiRnPRjNaZk2WNSaq1Vo1fsd7TsPGfuizRcAJQUM4qGDXyFpsK6YvkUn13Ped2WN5+jKN1zp0Onm/HoOdMhAxLmGYfN2WdD+wKYh9CVKXY7S9ZT9pa/DIjL6M/oGGYIV2H4MrWve47FilygtJk1Zo2M7AH/yqcBqPhufjyHZ4amiBdWJUJCwmlaxwM8V6b1BhQpKMtHYGkXcbpQJmTb7cG05mofCa+G0QS8TcuQn6uu6xGoARjQFgaEfZp2ZMWdAYileRFjDBL0HDwIutbB3BuevjM8u/1WE7VLAMzXZBOr6Y1EuPVbyhW04M5IDLc067r0HGyV1D0mMPG6qGNgSwAkHm9minivpAy5NAeD+uSMSrRqLctRDk+D7yDv7254tLfO7cKjnUqZm5sasPPoGWKGxqHocHUwE1oJ8Kh40ZmMnMb8zHYVj91zNBXGHw6tgijGyG7fVx3CvOPH3IelCFJlhwm2rNPrfVax0YV7kPTBg3cEqk/jkbF59fqk3tosiebI7iCEwNySrBU3FMktNJcUvnsc8kIFRKXdbRVUUjIM8NinyMGiu3rBWuoPh/2n+BbWj+3nbuDo6WZVbGDOdFTN9QYpvEvZOTT6Ais95uQ437lLOVyesHGoW2RsC/3ochhoNA04fKeRVHYz+iakVXfQKN2LllJJdhJ2a1DNbqbMB15RNZulhmmFvoURztPlZCCgv2kn1NK90F2BtYTTi9DlrVH7vKzOy++D6WJkDuBwzIGEU4F6xRa/oer9EyfBiAp5mpwSgGchIISyMwccj9vz14YlwLUo2f6KXISIlJj
 RAMt8V1q
 BZACZlwXOdMmF24L4sG5gqDvHr1oZ4nh5JO+HTXOr+NoVg5uLbe1/4WJJpPDoGtx7+iKnAVYAvHusnzIQ7Qz1WlYxVMujjGx0E3yrkOAGyAYNerp6GSUH5bZTG5cMuSX0+ISRn7RuIvY5Mf219dghXuMPEoKTJ9QH7imiNsaw0wYMYyPqAMyPEOL6DC0bXdUAbpYMpV2LsRdG7MrqUg6U4f2NA4XooSaagkEdI3cyROiYXu8tlh4mlMvd1HtEP3nzjhUeXdfGiA4vJOZJyqER1TNfHZ7KtoHWUHfzyytE4IjNT8xkhYtZWR9oSg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 15 Aug 2025 15:28:59 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Wed, Aug 13, 2025 at 11:20 AM SeongJae Park <sj@kernel.org> wrote:
[...]
> We might still wait to evaluate the lost/gain vs store the
> incompressible in swap cache. Google actually has an internal patch to
> store the incompressible pages in swap cache and move them out of the
> LRU to another already existing list. I can clean it up a bit and send
> it to the list for comparison.

This would be really nice!

[...]
> > So, if we agree on my justification about the metadata overhead, I think this
> > could be done as a followup work of this patch?
> 
> Sure. I am most interested in getting the best overall solution. No
> objects to get it now vs later.

Thank you for being flexible, Chris.  I'm also looking forward to keep
collaborating with you on the followup works!

[...]
> > > Is there any reason you want to store the page in zpool when the
> > > compression engine (not the ratio) fails?
> >
> > The main problem this patch tries to solve is the LRU order corruption.  In any
> > case, I want to keep the order if possible.
> 
> In that case, does it mean that in order to keep the LRU, you never
> want to write from zswap to a real back end device?

Not always, but until we have to write back zswapped pages to real back end
deevice, and all zswapped pages of lower LRU-order are already wrote back.

[...]
> > >      if (dlen >= PAGE_SIZE) {
> > >         zswap_compress_fail++;
> >
> > I define compress failure here as a failure of attempt to compress the given
> > page's content into a size smaller than PAGE_SIZE.  It is a superset including
> > both "ratio" failure and "engine" failure.  Hence I think zswap_compress_fail
> > should be increased even in the upper case.
> 
> I slept over it a bit. Now I think we should make this a counter of
> how many uncompressed pages count stored in zswap. Preperbelly as per
> memcg counter.

I agree that could be useful.  I will add the counter in the next version (v4).
But making it for each memcg may be out of the scope of this patch, in my
opinion.  Would you mind doing per-memcg counter implementation as a followup?

> I saw that you implement it as a counter in your V1.

Yes, though it was only for internal usage and therefore not exposed to the
user space.  I will make it again and expose to the user space via debugfs.
Say, stored_uncompressed_pages?

> Does the zsmalloc
> already track this information in the zspool class?

zsmalloc provides such information when CONFIG_ZSMALLOC_STAT is enabled, to my
understanding.

[...]
> I am actually less interested in the absolute failure number which
> keeps increasing, more on how much incompressible zswap is stored.
> That counter + number of engine errors should be perfect.

Sounds good.  So the next version (v4) of this patch will provide two new
debugfs counters, namely compress_engine_fail, and stored_uncompressed_pages.

[...]
> > I agree this code is nice to read.  Nonetheless I have to say the behavior is
> > somewhat different from what I want.
> 
> Even if you keep the current behavior, you can move the invert the
> test condition and then remove the "else + goto" similar to the above.
> That will make your code less and flatter. I will need to think about
> whether we can assign the return value less.

Nice idea.  What about below?

        if (comp_ret) {
                zswap_compress_engine_fail++;
                dlen = PAGE_SIZE;
        }
        if (dlen >= PAGE_SIZE) {
                zswap_compress_fail++;
                if (!mem_cgroup_zswap_writeback_enabled(
                                        folio_memcg(page_folio(page)))) {
                        comp_ret = -EINVAL;
                        goto unlock;
                }
                comp_ret = 0;
                dlen = PAGE_SIZE;
                dst = kmap_local_page(page);
        }

> 
> Another point I would like to make is that you currently make the cut
> off threshold as page size. The ideal threshold might be something
> slightly smaller than page size. The reason is that the zsmalloc has a
> fixed size chuck to store it. If your page is close to full, it will
> store the data in the same class as the full page. You are not gaining
> anything from zsmalloc if the store page compression ratio is 95%.
> That 5% will be in the waste in the zsmalloc class fragment anyway. So
> the trade off is, decompress 95% of a page vs memcpy 100% of a page.
> It is likely memcpy 100% is faster. I don't know the exact ideal cut
> off of threshold. If I had to guess, I would guess below 90%.

Agreed, this could be another nice followup work to do.

> 
> >
> > > I can
> > > be biased towards my own code :-).
> > > I think we should treat the compression engine failure separately from
> > > the compression rate failure. The engine failure is rare and we should
> > > know about it as a real error. The compression rate failure is normal.
> >
> > Again, I agree having the observability would be nice.  I can add a new counter
> > for that, like below attached patch, for example.
> 
> I would love that. Make that per memcg if possible :-)

As mentioned above, I would like to make only a global counter on debugfs for
now, if you don't mind.  Let me know if you mind.


Thanks,
SJ

[...]

