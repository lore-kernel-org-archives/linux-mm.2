Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3889606A702
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 14:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C28D6B05B0; Fri, 27 Nov 2026 09:31:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFC6B05B1; Fri, 27 Nov 2026 09:31:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313C86B05B2; Fri, 27 Nov 2026 09:31:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1259D6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:31:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC4C8A7A2C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:24:06 +0000 (UTC)
X-FDA: 85481118492.03.D9727EE
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [217.70.183.193])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1A380180009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:24:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=ghiti.fr;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795789445;
	b=AgtajYUe2xU2Mx0wEV47B/luOhjPxWU0fp9OwjQKhrI/dzXa1245GWwyJ2jc1lkmczm7WT
	uojC4t/J5NOLyctbbj4D+B4Eeh61wCMzpISFDyx0k5QGhMbgvTVeZLzZ+nfn9oUmY0vODX
	t9P+lolXx9PraHP9W7rfpwn28ITiXWg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795789445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=EbhWdjlDqYXGPoxN5kboRvS2+NtSfKGLkriYPAqd7sI=;
	b=CImYCGWE2OMrll4Qyg/NWZgZkw+A95RaUZuG5UQIZSglug9iPgGUbbn7puPuCP0MjHGN+n
	dL5EKPCWTzMLwuc5tglzd8gQR/pYwp8yf8EHNkUv8yrucBUSDIXG0DUc/Yi5GCRyti1Rsc
	0tlpU7HuwR53pudNlyVrn1DHykeR6gg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=ghiti.fr;
	spf=pass (imf16.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.193 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 045223EF55;
	Fri, 27 Nov 2026 14:23:58 +0000 (UTC)
From: Alexandre Ghiti <alex@ghiti.fr>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <baohua@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Baoquan He <baoquan.he@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Youngjun Park <youngjun.park@lge.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Alexandre Ghiti <alex@ghiti.fr>
Subject: [PATCH v2] mm: free the swap slot of a dirty swapin folio
Date: Fri, 27 Nov 2026 15:23:27 +0100
Message-ID: <20261127142357.1112193-1-alex@ghiti.fr>
X-Mailer: git-send-email 2.56.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Score: -100
X-GND-Cause: dmFkZTEp5Qx77guntm23T5dTKYs6zkxQfzo1XvkyZUuFFcykeWCOrH8Kr5kze8R7wZ4fIySIZ7IaYrQqejOU8Q3gMGl/ur5wdNsXrK4obk5i+24FUC/oaWJbOZB0ZvsGKfHSUgTDWvGYRvx6eL62wYTFiSkXjs9RLMOfNgdl3wPI0j1zPyzRK1oFemF0MptHDZQoZqtLbOrBHs28EK8PNzlU1lO8jGwJ4uJ7raKwyryg9CCodI5re44qBd2PJcoAU91yzOtviL7FgpxyVH0sQXjowh+Vi2H6AiEE59NLAaMVoNbloNtcYruRSdUMaR0Bb4OxEYA4PThK2/BhF36PnhYlk1/IdClqEivDoy6xjeL+aGavMlwHHPey4DKmyN/mRht1Moldcl/GUPau2W0dyVroWcFcnA+mdy2A/Q7B4zix2q/lQyLth2OGbpTYZBA875yiBdFcRYva19K6JbryjtEZyRo9jNOEEcPiWJTNXMBNmkh/YHJefFJnwN1Ixwqjb3pi+nHWI+PU4giv5FXRnJdXv8LK2lVVrF4XT/8zw3FGHLPbnfXLkyaqhdSt4baJoSOXyULRoHDKqRE4GKV4e5mB7XTVt3l6K/gLrxgbrHy+Jh4M04PlGMgoeUMyLHMeRQGfuAi5a+7eoshqRfkOJiDywE02GWrheKnNpfLig2Mj22SOrA
X-GND-State: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A380180009
X-Rspam-User:
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 79xxt91xdkksq64aichhnts1f7hgmfiq
X-HE-Tag: 1795789444-47349
X-HE-Meta: U2FsdGVkX19xAXcWh9Aj/xU2DllkPYfXas+WGqnHH5ojHqmc3KwvJSqhVrQzZvFpvJRa4+RhlvxUHOH0G9IVQJLjtJQMpRlGv+tYxY1zWo+Kx2lGXdSADDN3EpthlDPm/Cn9KAc//0SecpA7i6PQOC7kaYg8DZDihG60hterPgqBvV3oGHqiQL5oxUtOm3uOBwLblSXEaXGdrCK7zp/X60QIcrqMRcy4Ru1CKItSd2ySzJRnr8yoU4JOYcCNVlqjEYuid71xL+v1QUPcBtWX0IQI3lpg1HnJrPYptgSRFvDDc4n3nOShYbHBVoXFJXZ0fhbIqh1+VOQcqyFu58q2kf2dYfuyeBUuAtzo1C3M3mBbyjKL9BVPEPEHIUsN25jfR29pGvH2AtLAVSkAvwk+QUyQNOilofiAI3pl/hFxfLRVYnbCOA/B2I/6iTfOSROnOtFE5UKcE1l+qWLhgCC/LEJ6nFFRZgX+YiNeX6OHFCBPDjrPIK3zmtuc8rLKrho1wgfCRzCOb93nXORdSJiOdTkMXjnclA+5zW+jzAYLOe7H1CZTLjNnD2VfXHL+HZv3oI4vfghqIGTjHVgLV7V/gI0nQMZ/71KN7eRiuHje/O647hlVgwUFNqmvx63iAMXRwUtbV48b0ip2+dhVlYRexqEbf1iz+jlyZS0GQGwDz5ungVyY9KlZUhtOvgWesf+KJ6/MXfYRBk7DTftj3CLZTUtop59uHxdsQX0fmojx2Va8jTRjAWfj7NV4HrMpt3jh+pqbI1X1KMC6HOPFqhXqYo5WW9CP87h3ZA7+wu1ZXU8Nvmk9zupiAaN19P/bhcGpoxRYbePuRrx5Xvz8MlB7obK/W7s1fIVWZzBgXY7W3xdFldDcUSMxRFNNSk6ab1crJgmviT1W+2drCfnZ/mzlPUAvambwxo/P1vLF80Xh7rytviD9vDIVGUGS0J7ib8PrX3FHDPkkDH1Hy7SngTg
 BsPzfbtP
 4cKeJoUSnGF/QrGix1ydt87sdYg6LgIFsE0UhU9YJLgfGd/irNTfcYJZKqn/EFMURDbToeklzzPnpEhOM5SH1QuvXftTyjw7iGHx5H2YzfV6hK8JMLaRjN4FYLp2wMAxALqyki6pVKQLmdANuszpbEdJ0P4TpeLY5R2Z28PuJSwMFpjbGzgEaDp8j9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_swap_page() frees the swap cache of an exclusive folio on a write
fault only. But when the folio is already dirty, the copy in its swap
slot is stale: the slot only reserves swap space until the folio is
reclaimed again or its owner exits, and the folio has to be written out
again anyway.

The common case is zswap: zswap_load() drops its compressed copy and
dirties the folio, so every zswap read fault leaves such a folio behind.
Without zswap, it only happens when reclaim bailed out after adding the
folio to the swap cache but before writing it out, or when the swap
write failed.

Such folios add up, and they are expensive to free at exit: on a large
production workload, the exit time doubled when zswap was enabled. A
third of the increase comes from the folios left in the swap cache,
each costing about 3x a resident page to tear down; the rest comes from
freeing the zswap entries.

So free the swap cache of a dirty folio as well: folio_free_swap() only
releases the slot once no other page table references it. The only cost
is a new slot allocation on the folio's next reclaim, which write faults
already pay.

On the production workload, this patch removed that third: the exit time
decreased by about 15%. On a simple microbenchmark, 4 GiB of anonymous
memory in a memcg pushed to swap, read back, then SIGKILLed in a QEMU
guest (mean +- stddev of 9 runs):

                     base            patched
  exit time    989 +- 24 ms       502 +- 28 ms   (-49%)

The cost is paid by folios that keep cycling between zswap and memory:
each reclaim allocates a new slot and adds the folio to the swap cache
again. On a kernel build in a 600 MiB memcg (-j4, defconfig), this is
not measurable (mean +- stddev of 5 runs on bare metal):

                       base            patched
  time (s)        592.4 +- 1.1      592.4 +- 0.9    (+0.0%)
  sys (s)         256.6 +- 1.5      257.5 +- 1.4    (+0.3%)

In the worst case, random reads over 4 GiB of anonymous memory in a
3 GiB memcg, so that about half the reads are zswap read faults and the
task spends all its time in the kernel, throughput drops by 1.1-1.4%
(mean +- stddev of 5 runs on bare metal):

                       base            patched
  reads/s, 1 thread   37310 +- 182     36889 +- 77     (-1.1%)
  reads/s, 8 threads 291937 +- 802    287954 +- 373    (-1.4%)

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
---

Changes in v2:
    - Free the swap cache of a dirty folio even when not exclusive (David)
    - Make the comment and the changelog generic, zswap being the common
      case (David, Nhat)
    
v1: https://lore.kernel.org/all/20261126094318.244973-1-alex@ghiti.fr/

 mm/memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index d477a4f986bc..c83c67cb759b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4711,9 +4711,12 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 		return true;
 
 	/*
-	 * Free the swapcache only if we are the exclusive user and
-	 * this is a write fault.
+	 * Free the swapcache if the folio is already dirty, or if we will dirty it
+	 * immediately afterwards by writing to it.
 	 */
+	if (folio_test_dirty(folio))
+		return true;
+
 	return (fault_flags & FAULT_FLAG_WRITE) && exclusive;
 }
 
-- 
2.53.1-Meta


