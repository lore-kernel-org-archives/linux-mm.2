Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90A83C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB139000C2; Wed, 13 Aug 2025 14:20:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2642B900088; Wed, 13 Aug 2025 14:20:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1058B9000C2; Wed, 13 Aug 2025 14:20:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E8F4B900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:20:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF33C137A6F
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:20:31 +0000 (UTC)
X-FDA: 83772549462.20.424CB1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 19DA91C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:20:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwTLAG2S;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755109230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YD3/BXKljWNt9N6exY1koiuvxH7+0k+Nd36GtXU2ptA=;
	b=HNGKOBXZKWNq+6AdKpmCO3Gr2XZikJLt+3TgKUanI/MrrjSFOlCXYLwKpzhOGyanL4pKrW
	8+NPV1TuQOsQw1SfWjW9vzdqogFzMgzqvpoQyOvyND1hhJMqyeb448jwispGYrJLrvLACJ
	eUuLKsDib4kPU1HuU8u61n5pLJi4Fi8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dwTLAG2S;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755109230; a=rsa-sha256;
	cv=none;
	b=5AeVoqijyBbT3+2PRXsFWPVxA5DS2O3OePJrML9T11M0MOc8HawASiZN0MNI5/NjUiaOsA
	QxRNb9/7d/4o80JQ317l4bXTVETL/HB2KiT++yRlyrOO+a5zHDVHM/MQxtWpTAaHsiPdLi
	AKsGrYQU9H20aPbpERrMmvbC74XOidU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 41EBF601EF;
	Wed, 13 Aug 2025 18:20:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD0F0C4CEEB;
	Wed, 13 Aug 2025 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755109229;
	bh=jAZuPkluBbsvtCyN+PQZmxpu2+/htnF0npHMspg4Buc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwTLAG2SIuLDl2e+cBFdym5QlBAFqshTHHN/BO5aLd3/q/7g1FI78wLI2XnRn0z8L
	 7+jdriKWXmlfGJj/lSFSkMFPZBSwzlaH4dfGyJqVgB01aqNY4MbgA0iSqShovq8pTg
	 Zu5MtoMZLYgLQ1r+cXR7u18s3hYkk1a8BereVz2rjAfdItwc7XGftpj/CL5wOrhaXb
	 Fp3W8424k6o+2wC1auYRE32LXhzZXHtRSMbYyPOTJIgnauAMNPTRYSFDl1UVF9x5qA
	 Cn6F2S/cTrE57yxs/Ev3PAHc9SG1x6wJNylUIul6ufsrVS82b0otfbh0pAZE4IXFFs
	 2d2oGPc3lOfzw==
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
Date: Wed, 13 Aug 2025 11:20:24 -0700
Message-Id: <20250813182024.7250-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 19DA91C0002
X-Rspam-User: 
X-Stat-Signature: ip1cseyjky8nggf5cffnpgkrbuz5x3pb
X-Rspamd-Server: rspam09
X-HE-Tag: 1755109229-683119
X-HE-Meta: U2FsdGVkX1+BtrvjCgkznMbIuA1k6ZSMPQQHGteXyt3uHFUv+AVL60R4ZBLCr3NFztP28s0fWmbFk0eusqV9nWzp81xD/5vJrGc9D8B65iWOntkRbr7pdM3ub8jhAyPsR0n7wN34iPdv3IcURokS6oBEYPN9zvvgK/lmhSD61WehGONe07EQ6eco93PGpogGZ+hh3awEicmeDtAvTYbBWD0dIB4P8zbPC8orGae4h1OoUXrl1qBg2jzL7wk5wPTuuFPmfRmZSQon6npkenC2KNq6jJmjFUA7FhZB6u5kYWO8t7sPLcHG+aMKceCKJni93g/s2orhcm0YRwRX62miSR3G2y+aCJoWaSxW/8lRAFFoFRSNmHtAx61tDfgOZJvE5NVNgMJGqRz8dCpHLB1VpDQ6uB2a1vlbLzQGRZY4JXXJAXvCjA1NlhrX5/cimOqcyO72VLvcw0O+qb8dTKgmxk81PrYhomQYG/OWubZRr1DTgC7+2zcgUkcsSt5JAZNa/A0vZDGMN4Sd9LYxqyxKanUXiuKprfSQ1SsZ+Zh4NupimJ72n49FkVkiBuAph/rlOtaD8M8eZdKdZuUCjVQTe48RQkRTMTlesZh8rzVMbVjksACq0GkDXOPajPsGdd9Oyi87fzSyJFt44vM4iApuB2HB7WhrxQLTUsw4uBnyVdOyvg/ie6FQ4TtIKzoh5LD+6u23A0xxz0CVfJidW70qfnc7A7cUtQDJBgD6gl7b5sb63EtO9tn6QjpUF+Mq+rUIC0/WDuIInIsChjugBfh2V7GplBhmpKJM/Xfd1i9HW0dc4N3VhT/4F2HlVAJgYMX6A7H6T74hPyGzMPiku9wlAnP0CRl7BxNdzFNrP/LUKtyykyXYkSxe85Uk+5FvsTKMI1a912/25Oj1GcNNqqWJzL2FH5SSgck3JhibWzeVZcwQ38EHcekOWHthIac6OPe4THN3CTxABfs5S6HzZ6v
 3obzSij3
 4wSWR/xE3Lb2i76NW3bbDWed2Jvs6az+vwGCok9pxKshao8XKxT05nWs74VB6s+FsSXRyEkEqStY1PD4HcQaOZmZCRud935oIHrL3vgXPLwgXZR34alyCqkUl6HJz+d1tJDkJpA95zImUJEn7ZGhTq5c0+1w5a96pWuXD7auEvLzJBt6bwOSv5//DHnn9OSlsSK+mIImRig8ZaL83qu5gVxPmMSmX5aOhRFQxJmjsM7LB7LjYr3qyD1HsjtqJGrWx2hQw33N+/x4WPs4ITqLcdDPZUDwwgvU8DqstO6gpLdyZTzFfG2GRSTSFjh+LxRqvaG8vMnqxLcGtXsLD/TXmmLkBaw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Chris,

On Wed, 13 Aug 2025 10:07:18 -0700 Chris Li <chrisl@kernel.org> wrote:

> Hi SeongJae,
> 
> Thanks for doing that. I am working on something related to this as
> well. Please consider CC me on your next version.

Thank you for chiming in, I will do so.

> 
> On Tue, Aug 12, 2025 at 10:00 AM SeongJae Park <sj@kernel.org> wrote:
> >
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
> > is identified by 'zswap_entry->length = PAGE_SIZE'.
> >
> > Because the uncompressed data is saved in zpool, same to the compressed
> > ones, this introduces no change in terms of memory management including
> > movability and migratability of involved pages.
> 
> If you store uncompressed data in the zpool, zpool has metadata
> overhead, e.g. allocating the entry->handle for uncompressed pages.
> If the page is not compressed, another idea is just skip the zpool,
> store it as a page in the zswap entry as page. We can make a union of
> entry->handle and entry->incompressble_page. If entry->length =
> PAGE_SIZE, use entry->incompressable_page as a page.

My RFC v1[1] was using a kind of such approach.  I changed it to use zpool
starting from RFC v2, following the suggestions from Nhat, Johannes and Joshua.
It was suggested to use zpool to reuse its support of migration, highmem
handling, and stats.  And I agree their suggestions.  David also raised a
question on RFC v2, about the movability behavior changes[2].

I agree we will get more metadata overhead.  Nonetheless, I argue it is not a
big problem and can be mitigated in writeback-enabled environments.  Hence this
feature is disabled on writeback-disabled case.  Next paragraph on the original
cover letter explains my points about this.

> 
> The pros is that, on the page fault, there is no need to allocate a
> new page. You can just move the uncompressed_page into the swap_cache.
> You save one memcpy on the page fault as well. That will make the
> incompressible page fault behave very similar to the minor page fault.

I agree this can save one memcpy, and that's cool idea!  Nonetheless, this
patch is not making the [z]swap-in overhead worse.  Rather, this patch also
slightly improve it for incompressible pages case by skipping the
decompression.  Also, if we take this way, I think we should also need to make
a good answer to the zswapped-page migrations etc.

So, if we agree on my justification about the metadata overhead, I think this
could be done as a followup work of this patch?

> 
> The cons is that, now zpool does not account for uncompressed pages,
> on the second thought, that can be a con as well, the page is not
> compressed, why should it account as compressed pages?

I agree it might look weird.  But, in my humble opinion, in a perspective of
thinking it as zswap backend storage, and by thinking the definition of
compression in a flexible way, this may be understandable and not cause real
user problems?

> 
> I know Hugh has some idea to store incompressible pages in the swap
> cache as well. Hugh?
> 
> > This change is also not increasing per zswap entry metadata overhead.
> > But as the number of incompressible pages increases, total zswap
> > metadata overhead is proportionally increased.  The overhead should not
> > be problematic in usual cases, since the zswap metadata for single zswap
> > entry is much smaller than PAGE_SIZE, and in common zswap use cases
> > there should be a sufficient amount of compressible pages.  Also it can
> > be mitigated by the zswap writeback.
> >
> > When the writeback is disabled, the additional overhead could be
> > problematic.  For the case, keep the current behavior that just returns
> > the failure and let swap_writeout() put the page back to the active LRU
> > list in the case.
> >
> > Knowing how many compression failures happened will be useful for future
> > investigations.  investigations.  Add a new debugfs file, compress_fail,
> > for the purpose.
> 
> Again, I think we should distinguish the crypto engine fail vs ration failure.

I see you left more detailed good opinions about this below.  I will reply
there.

[...]
> >  mm/zswap.c | 36 ++++++++++++++++++++++++++++++++++--
> >  1 file changed, 34 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 3c0fd8a13718..0fb940d03268 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -60,6 +60,8 @@ static u64 zswap_written_back_pages;
> >  static u64 zswap_reject_reclaim_fail;
> >  /* Store failed due to compression algorithm failure */
> >  static u64 zswap_reject_compress_fail;
> > +/* Compression into a size of <PAGE_SIZE failed */
> > +static u64 zswap_compress_fail;
> >  /* Compressed page was too big for the allocator to (optimally) store */
> >  static u64 zswap_reject_compress_poor;
> >  /* Load or writeback failed due to decompression failure */
> > @@ -976,8 +978,26 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> >          */
> >         comp_ret = crypto_wait_req(crypto_acomp_compress(acomp_ctx->req), &acomp_ctx->wait);
> >         dlen = acomp_ctx->req->dlen;
> > -       if (comp_ret)
> > -               goto unlock;
> > +
> > +       /*
> > +        * If a page cannot be compressed into a size smaller than PAGE_SIZE,
> > +        * save the content as is without a compression, to keep the LRU order
> > +        * of writebacks.  If writeback is disabled, reject the page since it
> > +        * only adds metadata overhead.  swap_writeout() will put the page back
> > +        * to the active LRU list in the case.
> > +        */
> > +       if (comp_ret || dlen >= PAGE_SIZE) {
> > +               zswap_compress_fail++;
> 
> I feel that mixing comp_ret and dlen size if tested here complicates
> the nested if statement and the behavior as well.
> One behavior change is that, if the comp_ret != 0, it means the
> compression crypt engine has some error. e.g. have some bad chip
> always fail the compression. That is a different error case than the
> compression was successful and the compression rate is not good. In
> this case the patch makes the page store in zpool for cryto engine
> failure, which does not help.

I agree the code has rooms to improve, in terms of the readability, and keeping
fine grained observailibty.

> 
> Is there any reason you want to store the page in zpool when the
> compression engine (not the ratio) fails?

The main problem this patch tries to solve is the LRU order corruption.  In any
case, I want to keep the order if possible.

> 
> What do you say about the following alternative, this keeps the
> original behavior if compression engines fail.
> 
>      if (comp_ret) {
>           zswap_compress_egine_fail++;

I agree this counter can be useful.

>           goto unlock;

This will make the page go directly to underlying slower swap device, and hence
cause LRU order inversion.  So unfortuately I have to say this is not the
behavior I want.

I agree engine failure is not frequent, so this behavior might not really make
problem to me.  But, still I don't see a reason to let the page go directly to
swap and make LRU order unexpected.

>      }
> 
>      if (dlen >= PAGE_SIZE) {
>         zswap_compress_fail++;

I define compress failure here as a failure of attempt to compress the given
page's content into a size smaller than PAGE_SIZE.  It is a superset including
both "ratio" failure and "engine" failure.  Hence I think zswap_compress_fail
should be increased even in the upper case.

We can discuss about re-defining and re-naming what each stat means, of course,
if you want.  But I think even if we keep the current definitions and names, we
can still get the ratio failures if we add your nicely suggested
zswap_compress_engine_fail, as
'zswap_compress_fail - zswap_compress_engine_fail', so we might not really need
re-definition and re-naming?

>         if (!mem_cgroup_zswap_writeback_enabled(
>                                       folio_memcg(page_folio(page)))) {
>               comp_ret = -EINVAL;
>               goto unlock;
>         }
>        dlen = PAGE_SIZE;
>        dst = kmap_local_page(page);
>     }
> 
> Overall I feel this alternative is simpler and easier to read.

I agree this code is nice to read.  Nonetheless I have to say the behavior is
somewhat different from what I want.

> I can
> be biased towards my own code :-).
> I think we should treat the compression engine failure separately from
> the compression rate failure. The engine failure is rare and we should
> know about it as a real error. The compression rate failure is normal.

Again, I agree having the observability would be nice.  I can add a new counter
for that, like below attached patch, for example.

[1] https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org
[2] https://lore.kernel.org/761a2899-6fd9-4bfe-aeaf-23bce0baa0f1@redhat.com


Thanks,
SJ

[...]

==== >8 ====
From 839459619cf2c1a66d0a82361808bab499feefda Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 11:13:24 -0700
Subject: [PATCH] mm/zswap: add crypto engine failures debugfs counter

compress_fail counts failures of general attempts to compress a given
apge into a size smaller than PAGE_SIZE.  It could be happened because
the content of the page is not easy to be compressed, or the crypto
engine error-ed for any reason.  Adda new debugfs file, namely
compress_engine_fail, for coutning the latter case.  Keep the
comress_fail count, since the failures due to the compression ratio
failure can be calculated by subtracting the new counter
(compress_engine_fail) value from that of the existing one
(compress_fail).

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/zswap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index 0fb940d03268..6b2144126fba 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -62,6 +62,8 @@ static u64 zswap_reject_reclaim_fail;
 static u64 zswap_reject_compress_fail;
 /* Compression into a size of <PAGE_SIZE failed */
 static u64 zswap_compress_fail;
+/* Compression failed by the crypto engine */
+static u64 zswap_compress_engine_fail;
 /* Compressed page was too big for the allocator to (optimally) store */
 static u64 zswap_reject_compress_poor;
 /* Load or writeback failed due to decompression failure */
@@ -988,6 +990,8 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 */
 	if (comp_ret || dlen >= PAGE_SIZE) {
 		zswap_compress_fail++;
+		if (comp_ret)
+			zswap_compress_engine_fail++;
 		if (mem_cgroup_zswap_writeback_enabled(
 					folio_memcg(page_folio(page)))) {
 			comp_ret = 0;
@@ -1841,6 +1845,8 @@ static int zswap_debugfs_init(void)
 			   zswap_debugfs_root, &zswap_reject_compress_fail);
 	debugfs_create_u64("compress_fail", 0444,
 			   zswap_debugfs_root, &zswap_compress_fail);
+	debugfs_create_u64("compress_engine_fail", 0444,
+			   zswap_debugfs_root, &zswap_compress_engine_fail);
 	debugfs_create_u64("reject_compress_poor", 0444,
 			   zswap_debugfs_root, &zswap_reject_compress_poor);
 	debugfs_create_u64("decompress_fail", 0444,
-- 
2.39.5

