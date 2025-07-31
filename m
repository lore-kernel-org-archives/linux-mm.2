Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E924C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 16:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328786B0093; Thu, 31 Jul 2025 12:56:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D90B6B0095; Thu, 31 Jul 2025 12:56:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215906B0096; Thu, 31 Jul 2025 12:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11B966B0093
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:56:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE5ED1149C4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:56:14 +0000 (UTC)
X-FDA: 83725162668.29.6AF1DE9
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf22.hostedemail.com (Postfix) with ESMTP id 01B5FC0007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:56:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e8wslyPj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753980973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=egvUQPZhgkL+Utt/bYnDD5iOFk9y8VzCHpo4xQea//o=;
	b=ZLFyW/uLtvSRuCalrf5vmuGSIsxRFz2V38H71GPBtmPsdJiVzEZj8Z+dhcKA2NKPidvAwv
	7Y749iSp76xMnxZgGdP72MUUu4+z+voROB6cJOxddyJhckmPiyuETOmAmmFvhamO5pgDvI
	4BKiXkqSCMbjSHNywtBmKCiEPcmnOLw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753980973; a=rsa-sha256;
	cv=none;
	b=usix52uL+lMiyH+eBBXttBSVsjnnDZyHWgDqlWDDtrfWy5/ZIMVUjITOLdgzbSgh0Xpa/C
	eRQ98KCPMPtxr766bkiTtw+F8s+Ya9H+Tg+0Nn9jtD53SauceB8eODJlNccD1Gc7x/8qCF
	+Vkq0cYI5/t8jBLdRX1X62KZUL1fJQA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e8wslyPj;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 456C6A55560;
	Thu, 31 Jul 2025 16:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDFEC4CEF6;
	Thu, 31 Jul 2025 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753980971;
	bh=/tV+H3nZX38CRFBkLsRcF7IVCUTCMklz5ImNjph4/d8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8wslyPjITtn6e+QKlXiWVgTTuisc0/Z2NFh6f6YvIIGZQlmd1oXvL+E334I3UZVo
	 dZVbUn7BVG0Ch/yd3RVYKCMIXXlyUq9ZHS6OWRrPimkgLkcxOYKx2mYpuC1LAfXpw8
	 GqK4r+oRlXJuFzb6RpFi8F54hDriuFsNl0hSXNz1Oi7dVo6CmLRvVR94j3sjVyiiqP
	 T1eF1yIwb2t3uUA8VacO4E/0KBvnl1zK7aBtzWCT+Th2p3fc4e9s9z+o21eds13tvB
	 LWKPVfiGHl5YGUqzJFCSqin7Xh3ueCuK3rGEu9RWo9dvimkneRiaS3oEYmd5kKbTVP
	 +c3R3yWFWn1/A==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Takero Funaki <flintglass@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/zswap: store compression failed page as-is
Date: Thu, 31 Jul 2025 09:56:08 -0700
Message-Id: <20250731165608.15347-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAKEwX=Mv_NC27HWe=MneiewHTSZ-0icJqE2PSikTW-o30n9R-A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01B5FC0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: shb7oi8fjfwra3w7pyrcu43n75q7gihp
X-HE-Tag: 1753980972-676778
X-HE-Meta: U2FsdGVkX1/JjgeQyYMINIFkKQBPNVnh3u/n3VRaTi5jbZ4VojLN03ZtmjlF/MRHtB2cEGMtJiElXghqeUFv7KhqbpAOK2Thi1W5AVWAiaGB8qAK1NFvErEnC5mIcUy/B5Ua0Negu3TDIxIYn+cmlwFIh023brNWkNXICa1SbzpZMVOsfK3nzE5yme2afr5O+74j8qF4UMur4Pvh9U6EsqDQR65X8AROSB6mL10XLIK7ILd/Kr7HvQyiQOx4VpJlF8s4McxkWVis7F/nVlutefx/nv5NqoudxCn17Nen92CqUKYEqd71MtcZeL0rmolSyE3ZgWTBEkE/CqmfYyod4Uwh/rfIEppFZ8z/bj1lfX2FpwahfM1+QZVEt/TfoQNeMq7sgCe+690+7XSMR7vghhKfgbh5iuVTTloChcCpGcTObw93URBZ8pskFLWAheTIjE3KsoQLZ/x1GLyB5RtV3DOSrU7Rs2bcyyiLM4vjd6ROtT5h0LcJp7Q+4PLNvHYmSSDo9MJS8D8KYCNwHSSJBM1otdAyYprSFLQxQzn3SBgLhdQJE0kfThcQPYvO01/BOh15ZkTTd6tE/QZuituZQ3erqJ2Q1euvx8ED8sFSROqytpJ38Bv0WzNXe41kRvYbB2tgcdbpwM99OGb5kI9cFPeanpaMNnnKsr3oP8wTf2e9TKij7j0/nyAQyKLkflHF6v8aHanhSt7mgBbPYtUB1RNXDVDQtoWULUw8nJ++nqPsAXHfQ5ox6S8vI9AVnt9qipOogKw9TWivdk7R5dPsXR2RJTE84U7zfpWozzlWSp9DGCeVdubUKMFwtpn+8mIGJo17E8vvVk7pRcT+n4oSmljVAqL0YWCsGW5lhh92O8JLluNSVFKEO/z6rRkpjsXzcbX+A6I8U0PKZGsQPsRHu/fYoXhcvyd5YYF8u55ne6xfMQyiJORf1frW7tKLlxiSjGDGi98QBkqJFDVDtyW
 /iRrUt19
 FhuHZGOX0vaX3xnK6YzXHQvJAqkG670oIYGlGH842duGYS/0QbSL7oitUq485msVz5S0il6Bgrhsa9mJS7BcdH5cKKbpOn53OxYBXY7PqgHY7+HF/GXxpjvIh2Ixr/As0HNl4u3zpK6q8LSCDKpMj1Th58j0Z+GhWKFSpzPS69BhWq6uVdO3eOVD5MS3PXFfGZ12/dUMeKoMGSJEzlC5W6Fi0Gp+IWyryBAA42/L60sQzUwJdjcK8nkYTzx1+pK1quwmWiPPaBgkHxptadPu8I5oTX/EdLZVA2QwT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 17:48:09 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> On Wed, Jul 30, 2025 at 4:41 PM SeongJae Park <sj@kernel.org> wrote:
> 
> Now, taking a look at the conceptual side of the patch:
> 
> >
> > When zswap writeback is enabled and it fails compressing a given page,
> > zswap lets the page be swapped out to the backing swap device.  This
> > behavior breaks the zswap's writeback LRU order, and hence users can
> > experience unexpected latency spikes.
> >
> > Keep the LRU order by storing the original content in zswap as-is.  The
> > original content is saved in a dynamically allocated page size buffer,
> > and the pointer to the buffer is kept in zswap_entry, on the space for
> > zswap_entry->pool.  Whether the space is used for the original content
> > or zpool is identified by 'zswap_entry->length == PAGE_SIZE'.
> >
> > This avoids increasing per zswap entry metadata overhead.  But as the
> > number of incompressible pages increases, zswap metadata overhead is
> > proportionally increased.  The overhead should not be problematic in
> > usual cases, since the zswap metadata for single zswap entry is much
> > smaller than PAGE_SIZE, and in common zswap use cases there should be
> > sufficient amount of compressible pages.  Also it can be mitigated by
> > the zswap writeback.
> >
> > When the memory pressure comes from memcg's memory.high and zswap
> > writeback is set to be triggered for that, however, the penalty_jiffies
> > sleep could degrade the performance.  Add a parameter, namely
> > 'save_incompressible_pages', to turn the feature on/off as users want.
> > It is turned off by default.
> >
> > When the writeback is just disabled, the additional overhead could be
> > problematic.  For the case, keep the behavior that just returns the
> > failure and let swap_writeout() puts the page back to the active LRU
> > list in the case.  It is known to be suboptimal when the incompressible
> > pages are cold, since the incompressible pages will continuously be
> > tried to be zswapped out, and burn CPU cycles for compression attempts
> > that will anyway fails.  But that's out of the scope of this patch.
> 
> As a follow up, we can reuse the "swapped out" page (and its struct
> page) to store in the zswap pool (and LRU).

Thank you for adding this.  I will include this into the changelog of the next
version of this patch.

> 
> >
> > Tests
> > -----
> >
> > I tested this patch using a simple self-written microbenchmark that is
> > available at GitHub[1].  You can reproduce the test I did by executing
> > run_tests.sh of the repo on your system.  Note that the repo's
> > documentation is not good as of this writing, so you may need to read
> > and use the code.
> >
> > The basic test scenario is simple.  Run a test program making artificial
> > accesses to memory having artificial content under memory.high-set
> > memory limit and measure how many accesses were made in given time.
> >
> > The test program repeatedly and randomly access three anonymous memory
> > regions.  The regions are all 500 MiB size, and accessed in same
> > probability.  Two of those are filled up with a simple content that can
> > easily be compressed, while the remaining one is filled up with a
> > content that read from /dev/urandom, which is easy to fail at
> > compressing.  The program runs for two minutes and prints out the number
> > of accesses made every five seconds.
> >
> > The test script runs the program under below seven configurations.
> >
> > - 0: memory.high is set to 2 GiB, zswap is disabled.
> > - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> > - 1-2: Same to 1-1, but zswap is enabled.
> > - 1-3: Same to 1-2, but save_incompressible_pages is turned on.
> > - 2-1: memory.high is set to 1200 MiB, zswap is disabled.
> > - 2-2: Same to 2-1, but zswap is enabled.
> > - 2-3: Same to 2-2, but save_incompressible_pages is turned on.
> >
> > Configuration '0' is for showing the original memory performance.
> > Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
> > zswap, and this patch under a level of memory pressure (~10% of working
> > set).
> >
> > Configurations 2-1, 2-2 and 2-3 are similar to 1-1, 1-2 and 1-3 but to
> > show those under a severe level of memory pressure (~20% of the working
> > set).
> >
> > Because the per-5 seconds performance is not very reliable, I measured
> > the average of that for the last one minute period of the test program
> > run.  I also measured a few vmstat counters including zswpin, zswpout,
> > zswpwb, pswpin and pswpout during the test runs.
> >
> > The measurement results are as below.  To save space, I show performance
> > numbers that are normalized to that of the configuration '0' (no memory
> > pressure), only.  The averaged accesses per 5 seconds of configuration
> > '0' was 34612740.66.
> >
> >     config            0       1-1     1-2      1-3      2-1     2-2      2-3
> >     perf_normalized   1.0000  0.0060  0.0230   0.0310   0.0030  0.0116   0.0003
> >     perf_stdev_ratio  0.06    0.04    0.11     0.14     0.03    0.05     0.26
> >     zswpin            0       0       1701702  6982188  0       2479848  815742
> >     zswpout           0       0       1725260  7048517  0       2535744  931420
> >     zswpwb            0       0       0        0        0       0        0
> >     pswpin            0       468612  481270   0        476434  535772   0
> >     pswpout           0       574634  689625   0        612683  591881   0
> >
> > 'perf_normalized' is the performance metric, normalized to that of
> > configuration '0' (no pressure).  'perf_stdev_ratio' is the standard
> > deviation of the averaged data points, as a ratio to the averaged metric
> > value.  For example, configuration '0' performance was showing 6% stdev.
> > Configurations 1-2 and 1-3 were having about 11% and 14% stdev.  So the
> > measurement is not very stable.  Please keep this in your mind when
> > reading these results.  It shows some rough patterns, though.
> >
> > Under about 10% of working set memory pressure, the performance was
> > dropped to about 0.6% of no-pressure one, when the normal swap is used
> > (1-1).  Actually ~10% working set pressure is not a mild one, at least
> > on this test setup.
> >
> > By turning zswap on (1-2), the performance was improved about 4x,
> > resulting in about 2.3% of no-pressure one.  Because of the
> > incompressible pages in the third memory region, a significant amount of
> > (non-zswap) swap I/O operations were made, though.
> >
> > By enabling the incompressible pages handling feature that is introduced
> > by this patch (1-3), about 34% performance improvement was made,
> > resulting in about 3.1% of no-pressure one.  As expected, compression
> > failed pages were handled by zswap, and hence no (non-zswap) swap I/O
> > was made in this configuration.
> >
> > Under about 20% of working set memory pressure, which could be extreme,
> > the performance drops down to 0.3% of no-pressure one when only the
> > normal swap is used (2-1).  Enabling zswap significantly improves it, up
> > to 1.16%, though again showing a significant number of (non-zswap) swap
> > I/O due to incompressible pages.
> >
> > Enabling the incompressible pages handling feature of this patch (2-3)
> > reduced non-zswap swap I/O as expected, but the performance became
> > worse, 0.03% of no-pressure one.  It turned out this is because of
> > memory.high-imposed penalty_jiffies sleep.  By commenting out the
> > penalty_jiffies sleep code of mem_cgroup_handle_over_high(), the
> > performance became higher than 2-2.
> 
> Yeah this is pretty extreme. I suppose you can construct scenarios
> where disk swapping delays are still better than memory.high
> violations throttling.
> 
> That said, I suppose under very hard memory pressure like this, users
> must make a choice anyway:
> 
> 1. If they're OK with disk swapping, consider enabling zswap shrinker
> :) That'll evict a bunch of compressed objects from zswap to disk swap
> to avoid memory limit violations.

I agree.  And while I'm arguing I believe this is ok when writeback is enabled,
my test is not exploring the case since it is not enabling zswap shrinker or
set max_pool_percent.  And hence the test results show zero zswpwb always.  I
will extend the test setup to explore this case.

> 
> 2. If they're not OK with disk swapping, then throttling/OOMs is
> unavoidable. In fact, we're speeding up the OOM process, which is
> arguably desirable? This is precisely the pathological behavior that
> some of our workloads are observing in production - they spin the
> wheel for a really long time trying (and failing) to reclaim
> incompressible anonymous memory, hogging the CPUs.

I agree.  When memory.max is appropriately set, I think the system will work in
the desirable way.

> 
> >
> > 20% of working set memory pressure is pretty extreme, but anyway the
> > incompressible pages handling feature could make it worse in certain
> > setups.  Hence this version of the patch adds the parameter for turning
> > the feature on/off as needed, and makes it disabled by default.
> >
> > Related Works
> > -------------
> >
> > This is not an entirely new attempt.  There were a couple of similar
> > approaches in the past.  Nhat Pham tried a very same approach[2] in
> > October 2023.  Takero Funaki also tried a very similar approach[3] in
> > April 2024.
> >
> > The two approaches didn't get merged mainly due to the metadata overhead
> > concern.  I described why I think that shouldn't be a problem for this
> > change, which is automatically disabled when writeback is disabled, at
> > the beginning of this changelog.
> >
> > This patch is not particularly different from those, and actually built
> > upon those.  I wrote this from scratch again, though.  I have no good
> > idea about how I can give credits to the authors of the previously made
> > nearly-same attempts, and I should be responsible to maintain this
> > change if this is upstreamed, so taking the authorship for now.  Please
> > let me know if you know a better way to give them their deserved
> > credits.
> 
> I'd take Suggested-by if you feel bad ;)
> 
> But, otherwise, no need to add me as author! Unless you copy the OG
> patch in future versions lol.

Nice idea, thank you for suggesting Suggested-by: :)

I'll add Suggested-by: tags for you and Takero in the next version.


Thanks,
SJ

[...]

