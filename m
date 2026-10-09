Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F3FCCA601E
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:31:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4756B0088; Fri,  9 Oct 2026 12:31:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E757E6B0095; Fri,  9 Oct 2026 12:31:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8B6D6B0096; Fri,  9 Oct 2026 12:31:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B83D86B0088
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:31:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48D0816048F
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:31:53 +0000 (UTC)
X-FDA: 85303629306.05.080527C
Received: from mta0.migadu.com (out-213.mta0.migadu.com [91.218.175.213])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18E4D180010
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:31:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kgNZs633;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791563511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IfeJW+fUV2wA4rN3L9f6Jz2wDnlgji7J3ihwp2zpG94=;
	b=OnRC3RaL6ReApZHHHItx0KIGSFtmDcO3v9H493Acf0AR/xneIPVJOUL8zwKKgMrw/z0PtO
	UECVWw3txTyTqi8mvkGvVw2Cxqh6VB/UBEsdcZ7AmAFRQRaczkFogIW9bUd1u2KUsL+1At
	Y7r+LUD+g3+RMCqpW1Pt9QrzTC9fVCM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kgNZs633;
	spf=pass (imf24.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.213 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791563511;
	b=Zeli2vS1QJj7wi5dPJb/IAJodUdiEX+AJX3Eoo6Q9penIKx6yBmtPANEucXksNmp3IztB2
	5RW8FPwxRa89XY5AmdRX6PfpO7eiw/r3nsWked51CTcxsl2JoH94JPKpthq/co6736VdVH
	ORET6DAaZOiCgkTIFjs2aXPmCc3dbrQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=d+8iFVNMD1VUbVl7hJhhwaUpwC1HzdCY/+ROH2IsebA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791563509; v=1; x=1792168309;
 b=kgNZs633RQ5yk31aFhuie2lrSsMkOEa1DDGqeVyGJiUN3eZbhJ7QjOMbHaxGSa8e5YV3GM5Z
 EPKepY64ZExRugegAoSOSVB452JclB2D/SM3fV4/q6U9aj5rdXNNG2ikfu5KBGFdsfjfrsd8WJn
 DBe8qYfp86Ybw2TjrQkQi5ig=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 1332819e0d967689;
	Fri, 09 Oct 2026 16:31:48 +0000
X-Mizu-Trace-ID: 1332819e0d967689
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
Subject: [PATCH v2 0/2] mm: zswap: reduce request contention on loads
Date: Fri,  9 Oct 2026 09:30:29 -0700
Message-ID: <20261009163146.83112-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 18E4D180010
X-Rspam-User: 
X-Stat-Signature: dapyfwfdwkmoard7dm9rhz91piqkh5n3
X-HE-Tag: 1791563510-698499
X-HE-Meta: U2FsdGVkX19akYfsEk9+yyFqa7fgxBuVPuhv+d4u8vkPKhKxRm1PCv3AEJ+lPKa1NfWvN2hnyDRDPYUi/OgKx80Gz+nRntVp899vfaqEF9lzZaLEDlnYDGFtFAyHUQQkpMS6765v74N/JwTZgA3gW3yddfa+p3bLQdXm0HMzl2yZ2j3Y8O/epPitF3x/0xAUeuMjXmarr4GEUeW2XyDjzRPVmm5/OoLpy2P2PuCHKhZqrb1RRT5Rpufa1QJxp3cIiCBt+FkwjGPfzZbmFt6svzP306lhvlKIpSUySgxFbU9F8qc259olQIMS91MlO6ZeIJ3nl6I9+2eNGV7umOx44ywDoP4gwPxZ74P0ITW8qiCrXChY1Il+15f2ZgPS4ob11usWCwQlW0Fxm9TXS5fBurPUASgXONVRfuTOWdKc80gsaGYkNgL0ZOT4xjOw4VssCNpew8rwIdPW6uFRUdaBPqCfwckAKhGu6Suf/8itQxRDg2j1SWacYBCb7lAFcQzSkb4HeUtfDDalg597/Z7q87JXuQ5lpHGrPEF4k32tg9iBYyRfa+fJZvG4mxYhBiZr3uylDoTN3HTR74biEJVcCxI/ShNq2RM6js+cyHUzjW/QUbADsFXFtMGMJ8a72cZVQXpma03fR2k3jIV7v1SGzhz6PV4IRtW8ZFdX2Z+/lc1YIuYpy6izxNTMSVIwjooErZ7irpNVvLS1xnTlFRmbWxxCczziQ8erQUFRcQq2+qEP52nwc0mGjFNKDz2RBYge58HLZdeowkC+zwtqbwAgWz6I13sfWPKi5F9SYV5eNkPRFeZ7KYGzipqSLm9dfT66Eg44s6BdPWdSuTwhgGskN3p4Ktlo7nnDovWZvTsu9/tWjDLFKR2qaNcVr7C5N7QVJ76ekzCNBR7uwsMDgRh4IED7vdguDWxoTKsbNgTpTUjaB6lHUm+DshNOYHTopjOD7zXG/sQwHHyr5BF4G1q
 5s0Tiz5+
 2hklkATwtsedgmaYLqtolrdO7Rr6v4mZpyQ6/8yyWBkscB8mEL+/wqcV4R3ZJw8oNAHukKt5GmAcGDlu3eHzeyu107/7nTVevderPeyqTLM6BqLY7ACAGvF3bSqXUSpZtGgxOZWm3lL4OHpYuwGvVs6tYjFdUmZ82s39fHIvCx8vqLAmisUlr/zFzPGhkOtcfreOpoV+7EG3N6rB0lsCXpGOw+6jKO3Y6B5//YX0VFlHNolLmiXi1Xio3aVejFy8UUM9Wf9QukaUgw02Eod/0lzN1gg==
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
wait for each other. Patch 2 decompresses with an on-stack request when
the algorithm is synchronous and needs no request context, which covers
all in-tree software compressors, so those loads take no zswap lock.
Asynchronous algorithms keep the per-CPU request and mutex. For software
compressors the series allocates the same number of requests as before;
each per-CPU context grows by 72 bytes, and the load path is about 270
bytes deeper on x86-64.

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
3-18 per run to at most one with 8 vCPUs. The benchmark and test programs
were written with the help of an LLM.

[1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/

v1 -> v2:
- Group the compression request and output buffer in zswap_comp_ctx,
  documenting that the compression mutex protects the buffer (Yosry).
- Move the existing synchronous and request context size checks into
  the Crypto API helper acomp_can_use_stack_req() (Yosry).
- Share callback setup through zswap_set_acomp_req_callback() and explain
  the two decompression paths (Yosry).
- Clarify in patch 1's commit message that codecs and drivers synchronize
  shared transform state internally (Yosry).
- Add Nhat Pham's Acked-by on patch 2.
 
Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 include/crypto/acompress.h |  13 +++
 mm/zswap.c                 | 161 ++++++++++++++++++++++++-------------
 2 files changed, 119 insertions(+), 55 deletions(-)

-- 
2.53.0-Meta


