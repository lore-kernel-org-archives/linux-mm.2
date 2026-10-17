Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91B22CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:09:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F1036B0095; Sat, 17 Oct 2026 12:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8DA6B0096; Sat, 17 Oct 2026 12:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7062E6B0098; Sat, 17 Oct 2026 12:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4130C6B0095
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:09:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 408D01C212F
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:27 +0000 (UTC)
X-FDA: 85332603174.16.6592782
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	by imf24.hostedemail.com (Postfix) with ESMTP id 285C0180007
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTwW0qmX;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253365;
	b=zxi4gnCt96BPQRXkfA+DL07z0W5+P8P6Zrtsn7IoRLiqLYVhX27/X8HwNne1YLBE2L2QVE
	fOq1ZfjiusvOEBwVPA3Qrg4JiWUEGaP7yzQ0O+huTfWfID507WNn9kN8pxzTn24jdn+jdJ
	rvukQEtoiVXlwUa3i+e5rNUOBsFHN4c=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eTwW0qmX;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vkaj562NpMl3HLdrMJ3CfAdX1yCpfgJfKFICSQwJl5o=;
	b=SF+fucLWclPLaVa6YlWGPDJLt6F7gqnAz6zZQeVGSseZvkJCl/K0adXuQCPjvrRPGd0/Hy
	09XqcjW1zWzPkNso/3FFZyRjxMMvkyYtWzamCNOmCSYv+eohlHKvRsSObaOeITFDY+gItQ
	vEmbZNveygimSPsoieTRWS5gX27dDY4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tRoG5e1MENYg6Ps2FlKSUvpkvnx30P8P9QmDLQ5bMmM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253363; v=1; x=1792858163;
 b=eTwW0qmXqXIlLjvKrhAlSaW5F/4uL3kYe6lsfx+beS6Dv0t036K4mIKMhDt6Pd3HaNLyNbHC
 JqEI8TIxM9ZyBO2xZ1s3k8BEh6AubANh8CmCuFwS9iVyGRZui0g02PaL24tWOc7Uo0ohjiu2ixF
 rYKp1lXfpCLRvVIx+qf8mzEw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2ea8ad80f2639301;
	Sat, 17 Oct 2026 16:09:23 +0000
X-Mizu-Trace-ID: 2ea8ad80f2639301
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 0/3] mm: zswap: reduce request contention on loads
Date: Sat, 17 Oct 2026 09:08:52 -0700
Message-ID: <20261017160918.2738626-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 285C0180007
X-Stat-Signature: hyu39qcd1ath4sgisjoqo9jr7hznj8y8
X-Rspam-User: 
X-HE-Tag: 1792253364-950579
X-HE-Meta: U2FsdGVkX1/NG+nHimkmDUvr2Zxj5ePz6DSv+feAmAh4huLhgCnM75saDvjp/TkB9jcB+qqWuh/nD0CrCCY4GOZs1UBC1Vn6HBgjEvQrGbh0A3GSb5+3Ekl8akMngm++kI9cYMFUfVR3/NXCSnelY0Jb3qC41WEVgnSdB2MHja0VR526r1WMCtnppjvE+QUZP7nltX6jSe8+Yb0R//Bw4ZnjVkcaIPGL+qdkwENcMWQLjdedZUP2eNowHDH8xAJ+DakzQ6GDvc8w+Qf19NhxfNhp49HgPPz+94/aKguNq+IkdlUC+bSYFqU6ACJtGwXt4KXx4+BEImVMPeLZou6M3ud8+jOtZahokYtmEfKoi/zVN01lmKjYaXm89LG8nrKRDq+9Hjs8Y3eOaH4ipz3TpivjS2op6cifVdkGcs9SyxNSiftTIdW/S0t3gFfgo4YkwnWT/jhtAE4Xtw2y8m+WjZKbH/fsui+Ek0r6DU9jXTVhfEtTJ/TV4RzDfB85RCXddjCyCSvyyqMWKtQGwLDJr0vwuETLAmsIpDCrQnzy6lj3yeCDfojcDClUP793NypmHv+L6zQkhmgoDo2O7z/47TqOEPzrHUsAftUhoTL1WLol6YP6pTIj6u1ezzeJILNeaqFODb8n4FyvZIiSaYXAMD0I/dz464SPx5lTsEAJJaOkTGYeB7quJtGwjxuki3elyc3DXfqoaVPgcoB6L412R5HpZgTfwQPk/rNdYvfkJ9k36uAueSkLzGE603aJCKlJ9a8wlEtw5PXsXYHA4ErrVgyg51cKDkHdHs+R/H0TAbTPW8VbifUCG3NuKllRWNG5+V1YyQFkFymlv0z/Tl2oxtBEQZtlyaXCNDTexsDVVqUOZOhe8A0hWhdwUWW6vI144ettm49RykAzwzQu5EKICoZJSbKGuKKWfzDD64qN1QWR2yHltAvUBNlWe5wu23p1QH2uPLve+wHNtHppzcF
 j/OQuLIg
 puwAWYSYr3xvhSNNYjvfeRTdrneqlSuyrtQX9MxiXKt+0HoFGqF9L5qkYaIiopIQfAQwDDV14FnDo5KuR3kVYW4zmnrXR3uD3k1OgLHCdqzs3UjaEcOus4LaZbEMlxa0+Jio5kTPOHvgaUYQkMOukdAYm9M+A4wzYB7ceJZC10OdmdfXLyrYa/t6VSFU/yfIznVtS7o3LcNW03oUrkd13VeqUzo9GQx9p1up5rAViYahKk/nEHMh5JDaa/8mc/QLTJBdlEW5xMhJtzgpMLnYaSJCV/Fw41FZqEnejQAmWVB3nQOtN1W2MMCOl5pCapJY3idNH5iH4Mwivn2ErqXgurM4j2tlM6CMnz/VZYIqCsZM0wRI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stores and loads share a per-CPU acomp request and mutex. A low-priority
store can be preempted right after the compressor drops its stream
lock, while it still holds the zswap mutex, and a higher-priority load
on that CPU then waits for the store to run again. This follows the work
from Sergey Senozhatsky's zram series which splits it for the same
reason [1].

Patch 1 gives compression and decompression separate requests, waits
and mutexes, so loads no longer wait for stores, though they can still
wait for each other. Patch 2, authored by Herbert Xu, enforces
MAX_SYNC_COMP_REQSIZE when synchronous Crypto ACOMP transforms are
initialized. Patch 3 uses an on-stack request for synchronous
decompression, so those loads take no zswap lock. This covers all
in-tree software compressors. Asynchronous algorithms keep the per-CPU
request and mutex.

On x86-64 without PREEMPT_RT or lock debugging, each pool's per-CPU
context grows from 88 to 160 bytes (+72 bytes). Patch 1 also adds one
heap request per initialized CPU per pool: 176 bytes plus the
algorithm's request context, before alignment and allocator rounding.
Patch 3 drops that extra heap request for synchronous algorithms,
including zstd. The context increase remains for all algorithms, and
asynchronous algorithms retain the extra heap request. The load path is
about 270 bytes deeper on x86-64.

The series does not fix two related cases:
- Stores still serialize on the compression mutex, so a high-priority
  task that reclaims (direct reclaim, MADV_PAGEOUT) can still wait for
  a preempted store.
- On PREEMPT_RT the codec stream locks are preemptible, so a load can
  still wait for a preempted store inside the codec.

The numbers below are the slowest read per run, as a median (min-max)
of 5 runs. Each run is 12 seconds in a zstd VM with lazy preemption,
vm.page-cluster=0 and swap on /dev/ram0. With 1 vCPU, four nice +10
workers page memory out and read it back while a nice 0 task spins. A
nice -19 reader pages out its own buffer and measures how long each
read of it takes. With 8 vCPUs there are 16 workers, 8 spinning tasks
and 8 readers.

              Before series (ms)      With series (ms)
  1 vCPU      22.3 (21.6-22.6)        0.97 (0.72-1.4)
  8 vCPUs     314 (97-2542)           7.0 (5.0-98)

Reads over 10 ms fell from 26-35 per run to none with 1 vCPU, and from
3-18 per run to at most one with 8 vCPUs. The benchmark and test
programs
were written with the help of an LLM.

[1]
https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

v3 -> v4:
- Propagate each zswap_acomp_req_init() error from CPU preparation,
  including asynchronous decompression request allocation (Yosry).
- Add Herbert Xu's Acked-by tag to patch 1 and Yosry Ahmed's to
  patches 1 and 3.
- Document the extra per-CPU memory in patch 1 and the cover letter
  (Yosry).

v2 -> v3:
- Include Herbert Xu's Crypto API patch enforcing MAX_SYNC_COMP_REQSIZE
  when synchronous ACOMP transforms are initialized.
- Use acomp_is_async() in the stack-request patch and remove the
  redundant acomp_can_use_stack_req() helper (Herbert).

v1 -> v2:
- Group the compression request and output buffer in zswap_comp_ctx,
  documenting that the compression mutex protects the buffer (Yosry).
- Move the existing synchronous and request context size checks into
  the Crypto API helper acomp_can_use_stack_req() (Yosry).
- Share callback setup through zswap_set_acomp_req_callback() and
  explain
  the two decompression paths (Yosry).
- Clarify in patch 1's commit message that codecs and drivers
  synchronize
  shared transform state internally (Yosry).
- Add Nhat Pham's Acked-by on patch 2.
- Add Nhat Pham's Acked-by to the first zswap patch.
 
Herbert Xu (1):
  crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE

Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 crypto/acompress.c |  18 ++---
 mm/zswap.c         | 163 ++++++++++++++++++++++++++++++---------------
 2 files changed, 117 insertions(+), 64 deletions(-)

-- 
2.53.0-Meta


