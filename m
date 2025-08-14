Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D174FCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 670989001AD; Thu, 14 Aug 2025 13:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64837900172; Thu, 14 Aug 2025 13:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 584EA9001AD; Thu, 14 Aug 2025 13:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 46627900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:04:32 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0A1051A0781
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:04:32 +0000 (UTC)
X-FDA: 83775986784.18.539A3B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32512A000E
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:04:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g03bXXBi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755191070; a=rsa-sha256;
	cv=none;
	b=oXh9Uu8sKHhkKXccNaUPygRPW4YcilOXjwB4z4Y0gtaH732+47ugRW0uAssKH0CK5/NAFk
	eQ6YikmjDDm0X+3Md3FV3zTN4isaqTMtuRC2PEtA9FabdUuG7e9IjAc30PLKMeNzOiNTZm
	ZYetO1VSzll4nih/kHB7bectUQxzoh4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g03bXXBi;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755191070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hC1fDi8qYFKQSLyDMOc4DNZ1RnMZ4RsubgRBbHv1sqY=;
	b=OO+OBgjkRpKGNOYKYnGCw0kWSsw/H4AilEfzcqGngrO7kycrZewbkRsY0FIKC+iojs/0Lf
	PmqYyT2tLgaaZ+B1tVvz7Q+gfwGWWO5LbFISMLsVKp5w14va8HdvsJWigUfDEJePGVmQ4S
	sW8yAYi1yzorUhNboS37NaHHmFvm7Hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15F3843464;
	Thu, 14 Aug 2025 17:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B21C4CEED;
	Thu, 14 Aug 2025 17:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755191068;
	bh=ehLWibI3luHVPPGBO4K8NQgsDAt/gZl+g1zfAGJiJNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g03bXXBiILvibSwG51TANlNRiafCWjWykDjDfRUHYoztyU7J8yZ8vTOrSSysZlDN5
	 R2IFE9tx0CGUZlM90EbZ2oUx4efrQw6DZUSNdxB5LipOvRVNJRBplPNp6LVr5hn1Jt
	 By2wC3wvysbjuQHrQ37O/kcwFYlxGuTcc9zQzTxPbmAd/ByB2ZE1/46j6uE9XG7DqI
	 z60BpaWc9fBbqrjf8LQ2MXF1xae4vAa4sZO5w5hlKSNh3lT69qo3EFLnuRF30UsFAT
	 QSmtnb6dCurbAKlYkGCIp/JPQRgmn5/C5fbrkkTOZiPIORy/MElTGZri1Lz+VEs2aq
	 l4iuIM54oBs8w==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 14 Aug 2025 10:04:26 -0700
Message-Id: <20250814170426.71159-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250814162350.GH115258@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 32512A000E
X-Stat-Signature: bysb8is49wmjmkp47o3syp5e4ursrjk4
X-Rspam-User: 
X-HE-Tag: 1755191069-343668
X-HE-Meta: U2FsdGVkX18mDkATzMCANLNJrShBcc+gm45uS5Oh2rsUow4BkSIRtYzc3qNDkpg5ogO13wv7upTsrezF9QhltON2awbudnCmJLUoWdVygJ8wZu0DirT2pICplPEdVkkwHXA+5/8IwUStryoRCUoJNjb+bymoT+EILu2z484mjESUPcRqreO6dRomCi75jsS/B2+FrSksAnETo4TAeuMt2bYrR+6pJyJMsg+8GfnxP9LItnX7KBFohhaLLQYEuZ/+3+ksyxHhKs43uXbxuCg+4Ar4FGkf/SAM7+HzyOlOW2tPc6m+ckTM4zRzcihiueZyyFVRkH5uGyLR+uN5lAbR1SoOd8t6v8y7Ays/QbgJ6E17A7mh7Nfl/CsmfhM1ZnE0dt3QqvBYEinpzQTH9+74ilj0idKa0Wr5nPIEwep/pXy0hlj618CgkPBwkOkYTMnT7AieHfn96FkcLEqIib05/W3k45EH4LLBTUFr5zwA3CpanYnH3A6JikPIqlDRaDnYkn4TBqzrH/P9kGzsqQoINmkX6LXiKxGonYpr92XS7NC4Ia4yjCvgbAApUzygqFiwgd8wTFYmXpgBZQZ3GnjE+2Sw9/wHPA2zAQurktPpl9vRT7v5HIoB+NkPO2uoP+CupjGTlJrVb0Itf94ZEtMXpmWl3PM3f/wL0SSRCkaXrqjmh2VCP3S8vc80TuldYaa/g/jxaILqS6aQV+AlNjLxNekYruoEoUlhfm8QMkoYNs/91TQ8eAegxQs78HI8xWIvQ1hc+6T16edY+glZfYmNaPNFpPQUiiBJddsrDX6U/vNnF4vbKOlwajvGS4d/Uh60i+NewUjbJLvV9Kn/qJZp7VqfJPGJX8LRZQjuK+cN7L8RWWLbLTm3OO6/nhTbhmgI0tqyqqfJqG7CvCEYofUVodBbKHauPj3VVWFyCJnFRU2YopVdA5u8wK6XBl9Kx4dVe9hTQd1UZMtUGkcGowJ
 zowpRxqo
 93deA9oBKJbv4eiiqRBZuh5sEVR+kFjo5TgWcs/4Rm5x5iAFO54LxcCFk3UTx5IIz7O8TrcUeM6DaPhaprHcaYLgCwNza+P3wW0Vrmgj+cMbCF1rDb7uFfg+yOI7QsupkuYG2CQKP/6XyQV5g160xJVZ2km3L8tGEhGx2mlgZrNFuahwXvwIQ7eR1lM2kZgaCicSwnfFTUsDuRaeqkSwDxo/MdswHvVyunI+YvYN1/+ixwqGD5Nhg0g6MxzUlBFQWx3+f62tqlC0WgBHujZg+PlT8t49n5SXdgG9jlgOkw0PPIuYl/5yhg1Vo7s3eOiV98GYjzS9IoMbMXIJvgVyrPGNFTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 14 Aug 2025 12:23:50 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> On Tue, Aug 12, 2025 at 10:00:46AM -0700, SeongJae Park wrote:
> > When zswap writeback is enabled and it fails compressing a given page,
> > the page is swapped out to the backing swap device.  This behavior
> > breaks the zswap's writeback LRU order, and hence users can experience
> > unexpected latency spikes.  If the page is compressed without failure,
> > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > decompression overhead for loading the page back on the later access is
> > unnecessary.
> > 
> > Keep the LRU order and optimize unnecessary decompression overheads in
> > those cases, by storing the original content as-is in zpool.  The length
> > field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> > whether it is saved as-is or not (whether decompression is unnecessary)
> > is identified by 'zswap_entry->length == PAGE_SIZE'.
[...]
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
> > regions.  The regions are all 500 MiB size, and accessed in the same
> > probability.  Two of those are filled up with a simple content that can
> > easily be compressed, while the remaining one is filled up with a
> > content that read from /dev/urandom, which is easy to fail at
> > compressing to <PAGE_SIZE size.  The program runs for two minutes and
> > prints out the number of accesses made every five seconds.
> > 
> > The test script runs the program under below seven configurations.
> 
>                                                four?

Nice catch, thank you!  I will fix this in the next version.

> 
> > - 0: memory.high is set to 2 GiB, zswap is disabled.
> > - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> > - 1-2: On 1-1, zswap is enabled without this patch.
> > - 1-3: On 1-2, this patch is applied.
> 
> I'm not sure 0 and 1-1 are super interesting, since we care about
> zswap performance under pressure before and after the patch.

You're right, the main focus should be 1-2 vs 1-3.

I added 0 and 1-1, too, though, just for showing how artificial and micro the
given test setup is.

That is, as I also mentioned on the original mail, this test setup is for
pretty extreme pressure case.  To quote,

        config            0       1-1     1-2      1-3
        perf_normalized   1.0000  0.0057  0.0235   0.0367
    [...]
    Note that ~10% working set pressure is already extreme, at least
    on this test setup.  No one would desire system setups that can degrade
    performance to 0.57% of the best case.

Enabling zswap improves the performance to 2.35% of the ideal setup, and this
patch further improves it to 3.67%.  But still no one would want a setup that
achieves only 3.67% of the ideal performance.  The performance itself is also
a pure memory random access performance, which is again far from those for real
workloads, though.

So, this is a microbenchmarking test that pretty far from the real world.

I will add more description about the intention of the configs in the next
version.  Let me know if you think it is only disturbing reading of the patch
and better to be just dropped.
 
> 
> > For all zswap enabled cases, zswap shrinker is enabled.
> 
> It would, however, be good to test without the shrinker as well, since
> it's currently optional and not enabled by default.

Agreed.  Actually we ran without shrinker for RFC v1[1] of this patch.  The
version also showed performance improvement in the configuration.  Since we
made no big change after the version, I expect no big difference.

Nonetheless, I will run the test with zswap shrinker disabled setup again with
this version, and share the results.  Unless the results is far from my
expectation, I will directly post the next version of this patch with abovely
promised changelog updates.

> 
> The performance with the shrinker looks great, but if it regresses for
> setups without the shrinker we need additional gating.

Agreed.  If I find a regression from the abovely promised rerun of the test, I
will share that as a reply to this thread, and start a discussion for the
possible additional gating.

[1] https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org


Thanks,
SJ

