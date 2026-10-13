Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42AD8CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476266B00B1; Tue, 13 Oct 2026 11:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427256B00B2; Tue, 13 Oct 2026 11:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364156B00B3; Tue, 13 Oct 2026 11:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12F6A6B00B1
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:10:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 76E2DA8BC7
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:52 +0000 (UTC)
X-FDA: 85317940344.14.8B1B4F6
Received: from mta0.migadu.com (out-4.mta0.migadu.com [91.218.175.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id 53B1940018
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QCCyV0iq;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PjVSKdsxB4L+8ydsqzwc6ypXEne3oD+71fK35KsWRII=;
	b=r2CmfWn16vN4Fh3V3VwXZlwQr0hh+bwLZTcTR/ngzFgmFey/I9WqucmEGJ3OKssguL/ghu
	luNhiOhLBNZj/J14xWS/DLlMEcnpu564IJUUlPu8DU4KFdquihOgYTRY7fCHE7gEn2yHTn
	d9LlYKqzcByxbx3dGLK6ArdIL8pP56g=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QCCyV0iq;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.4 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904250;
	b=yXKrM8DSatA24pQoiz+6TiCmqlKuyPRLrqqT/W1SrZYCjyEDVLUYY8F/y8QLL5QPunchxv
	i9Hr87diSgqDCjnfeN5KB8sZbKsxrJ8QbDRYlxwKTmewO2WuPfAu5rpwVoNo1hlHYxCqv5
	eVC442SdY8nodx/Nv6P0p2tQOr9EiEg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=59kDzY29XnAdYqJ9ZYSMDsg2Gwxh5pjxWMzFEpzvbLk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904247; v=1; x=1792509047;
 b=QCCyV0iqjmi4My/X/+Sz2pTaTQpwt51VWkvRgluBISgV0wJx64OleKafV4vLknkz/wFFpAEy
 nEMKm70b9nHEwejvRLfS/+njJEbNBdQ61hOZ5npKWeSVMsAfXkkzkt/hOFmdo8YgFMz192gf9iN
 CRVFIzFGmT1r9icu2wp/4rvM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a4de6271a8b1d2c8;
	Tue, 13 Oct 2026 15:10:13 +0000
X-Mizu-Trace-ID: a4de6271a8b1d2c8
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
Subject: [PATCH v3 0/3] mm: zswap: reduce request contention on loads
Date: Tue, 13 Oct 2026 08:09:34 -0700
Message-ID: <20261013151007.2093943-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 53B1940018
X-Rspam-User: 
X-Stat-Signature: iq9ymba6xpwzfjxabbe7gjq5tnc6zyq1
X-HE-Tag: 1791904250-132797
X-HE-Meta: U2FsdGVkX19pv2VUzA/BLf5dqwMd23n6etHEgSRqKnBLJkfk6lAte2jJm5C64RKizvY5ONhvs38DXCyu0MvpOVDHilB1wAaBhbkNJzdFNMTESoHorjjM1oOtTMGYmjQnxD1lwTsUPO989VmYJ1ati6jjD6IEpMIF8ttli1Hxvd5sBbokoeD6p7b2iNB2shnEfZ1GTJTid/Xa5pDz8jVB2H8Wm/FvDfZd9DIVSh7Xc7yWbQIlKWl5WR++Ahml6hHatJDEq4t6v6S/wXg0RGbwMuXBcHVbn9vu75916C+UlI22jSIGb6cmWTiHIfweqRTHX77n9pBBiWcp2Lxwjm8U+kikjlZM3kvqLid3/ZguK6Gn+3Fa7tDsg/TJojPtM/6aSNiKBnKRzMtQ4fIhQCvvQxEzTOk6POC+a9YxRRI8HG13UN/j8pCQ8EVcE69Y2Wocj6Szl/hlenYGBy6ffymWj/J8Sq4+8ZknBxbUTeDaK1BV4F2jOoZn3PxB+8vFE4OASeikUVE0HB99tUs7/n281F+BsWOk/x8gPJ6egQsmMJxvWkCgPvqYCJqk+ObzcGz4pCPxblZ0n9zN8kppqcj6BlbP3i34ThYOEGg8zpkQlRsnXDggOF/S0WwJeelPQ2UOsLyXGso+H8kAC4Vpu2D6GgNN3hlYL3McbVwdHjmagfRG1UA+76jb6J57cxBj8fCq84qTuzLsXyioqua3sXjfbTyZHQfH1nbi30eIPhOj/PV6mZ62o5/0os8MXG7hyTw4Nf5teY+QimQpzNrdMTStlRQBK9GlMupQrA9iTBUyaDLr4h2V3IfIMHfVtpQ0u6Th4PIzaw8Z24xy5bM5LLztSWNCyt6eXJS/Vg/4QU2dfecMUI15kyG0mssjEvkGJjSWynWvI21WEMT4ZxR6ODzQ3J/CYpA/nJGdeZU4AfYnwgvyQWDBYlJQ/E4orT9R3GTXYlbcEkUcUV9TurQbsfh
 EoVrP9Mn
 BT3h12nqErmCfChQyhoWPuliK4uWqc7Fcm7YbWIxSBticqN2TrQfVQhKTTJPBbFscJ0xZnpXl8fQgfboUnO47CgEszrZ5lGLsCQAFC/XBk60yZXWbyK6Hp4W2Mp3HExkNzdvbPIk0j/Ph/X9ZEQkrfIVtswy4yFdby/p1Yqjk3q0DjPbiVKutCS3v+Lg1NQPoZCYTk9JGRvq0j7auSFL4AHRTVObo9647/e57Ny+KzM7KS7cwNRfOsW0tEshYZAaSXnDYWRW92ex7jrgyDiK32PcXqA==
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
request and mutex. For software compressors the series allocates the
same number of requests as before; each per-CPU context grows by 72
bytes, and the load path is about 270 bytes deeper on x86-64.

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
- Share callback setup through zswap_set_acomp_req_callback() and explain
  the two decompression paths (Yosry).
- Clarify in patch 1's commit message that codecs and drivers synchronize
  shared transform state internally (Yosry).
- Add Nhat Pham's Acked-by on patch 2.
- Add Nhat Pham's Acked-by to the first zswap patch.

Herbert Xu (1):
  crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE

Usama Arif (2):
  mm: zswap: use separate compression and decompression requests
  mm: zswap: use stack requests for synchronous decompression

 crypto/acompress.c |  18 ++---
 mm/zswap.c         | 161 +++++++++++++++++++++++++++++----------------
 2 files changed, 115 insertions(+), 64 deletions(-)

-- 
2.53.0-Meta


