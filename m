Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33DF606A31F
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 07:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=WDftzrk6
Received: by kanga.kvack.org (Postfix)
	id D2BAD6B05FF; Tue, 27 Oct 2026 03:40:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB55A6B0601; Tue, 27 Oct 2026 03:40:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB9A6B0602; Tue, 27 Oct 2026 03:40:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 950426B05FF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 03:40:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A3451209A5
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:40:43 +0000 (UTC)
X-FDA: 85367609166.19.489D80A
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57260160006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:40:39 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WDftzrk6;
	spf=pass (imf08.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793086841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0dSKP4mzbhr4ZbEkscIx3I5WqNRn/Q7p4AbTndmod+Y=;
	b=WgWB8ZrfAktcyvO8IYISuA0OA6njI6ivdMXPRvBXQzqXyEXsnKZ3wfFQ4GzIEhWmw5E013
	VCmGwzTRLviY+spD25Ld209LFP/fh+UbG1zSFo6TO4l9XXzBZ4q2EmmI2JOenJbDt0V9YN
	tQlWZKROVMPKEycrc2+Mqbe1g+Vujc8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793086841;
	b=BvqyajD9cVbgUk5gXSDZA5aPlcv7bu7PypfisscTkhwHaZfQ3PuxGcFNub1yffhu2If3h4
	M0xufs5BVGsFop8YUPJpfckBFYBM4v8UIFS3+1nG+BhKAtWl3kN2wUnpnQYmNLz4XPaRzi
	WSqOzT9afhyghSPCOb82crVsYx2GDK8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=WDftzrk6;
	spf=pass (imf08.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793086836; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=0dSKP4mzbhr4ZbEkscIx3I5WqNRn/Q7p4AbTndmod+Y=;
	b=WDftzrk6XbX2nIDtzxZrYBA3wp+0TXfBBJVbJiDXjnVaUIfvB8WISUu4IyuXBe6c10R1LpbcsAaaW5Yqd5RTaHUlwMZ2StriPXdAjYLSgpmTAtNySd800Fr0KKYlslpBsy4tsW0GQSfdoTbu48XXvKtXrAoP0yMnFCX6RPyKfwc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XDd6LIt_1793086828;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XDd6LIt_1793086828 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 27 Oct 2026 15:40:34 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pratyush@kernel.org
Cc: graf@amazon.com,
	kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pasha.tatashin@soleen.com,
	rppt@kernel.org
Subject: Re: [PATCH] kho: Skip zero-sized bootmem areas
Date: Tue, 27 Oct 2026 15:40:25 +0800
Message-ID: <20261027074028.13042-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <2vxzld7kpmmi.fsf@kernel.org>
References: <20261026131851.9942-1-cp0613@linux.alibaba.com> <2vxzld7kpmmi.fsf@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57260160006
X-Stat-Signature: t9nrepmo4mtf4sfxkho4cjncacw3pxcw
X-Rspam-User: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793086839-428506
X-HE-Meta: U2FsdGVkX1+N7Al81knx9pxyJz+VBpFU5+o0krH3gwv7HZYmAef6HTvQ69ithG32jjXoKf4aoMBitChezb+LB6eTrm9I8DMqFpEboMNyTuc8Czm98YAx3WhJ9tYEy/6UlIiwmKwgaPYpJTIAUS66wag/bJ9AnyA5UpBpUryDqlH+XXRqSdC2DEFDbRX0Rbfto13LVYKaU0ggWihrucVF/3+DM8Sf5VZQuJT48MVL6ani0k/qWy2mNQ/HBJ3i8ONCL72fgLslQM8ElVdAvWnVkdOoSWwh/InnB7YLXrwLzZ/nol4JqFERe4+bslp+97h2oJq/yBGsjg9EkNEgrunY99sAn3dOqstCIsgEvj/cj7LxEdHB1dwR3H11A9mCj6QnZD3uYxNWL1AHQfySgW7/o5q4WYGFMr0cDXWm3Aa+3gpszacatRwtijuCcZfYimwolfpQzepRv8LlBb0FrON4evMjYn4L59UwqGVTp5yMvazsdP56DN2aGsQgFGqyUIHJXtPJIKTI8fZzrDPJnVBSFAizhq9SdowfwVHXWRb0zWMhN9mw4fsrkff9eOgjkyaFeDq/0sCBbVO6wPmrgZTnkpHXohCsA3RutqrZXmBdycBbevjdeFM8oULA6CA7pCQ/rIOj6lK5VE4BbKGMrDl0IRKRYTAEo2R/4b7ef72b7NI3bBQhnPfPp5EJ4OuqWL3oD+VqwHOHew4W++WXZ4HpsTYy2vN3iU95EnrD/hhp7U74UXHZ3fZGkIreHkT9SBU9FRAZbS8Vx8CYqMh7D6lME35T38Uf/u0OmREQvGk4DGDU+blLiMbH1fKCp22fHzpRTPtHqY1B0x/90iF0q6oPAXQ7bYcfPVrYuosMYgIiwQiChf+U7LGqeA4iwNH84SBGQLKn6R0R8vYuT4W1qfI7RBEi9OBmwKO2VUXKKBRg2lXgo1al2Z2mXqJgQaNVMLvcTIFi5L8Sf833VH4AnvC
 Y08TVTUJ
 AZhIc+UUroe4uq2wQE5GZcpBJ1RpI1FwfG86CCXbNngZfEgamrZjSkSkDkXr6+FOAXVIljTvsEplFjAf/KDHp0JClojSelbM6nnjur9MKWwt6ruoXY2jPk9d91ecuQQ5f1ZNb/xvgtXtgdok9L8qjEKnGHnvEYBKl6H4t6rvrjCzguiJxCl72ZGY6gRA6YXbntO7sY7Za+I7Mo/ds2+W2gZZ29p6rhzOrEbBNiZZa/19UklLPxJj7ki5UfBJmXU6tNtQTZisXTY4bA7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Do you see zero sized lowmem or global scratch in practice? If yes,
> how? What's your setup?

Yes. Enabling KHO for riscv64 gave me three cases. They differ in which
size ends up 0 and in what it costs, and all three are measured:

  #  condition                     size    cost
  1  all memory below the limit    global  empty area kept
  2  no memory below the limit     lowmem  KHO off
  3  kho_bootmem= with explicit 0  either  empty area kept

Case 1, measured with a temporary pr_info(), not part of the patch.
riscv64 defconfig plus KEXEC_HANDOVER, cmdline "kho=on", four RAM sizes:

  mem   reserved_low   reserved_any   lowmem       global
  1G    0x32d3ea5      0x32d3ea5      0x6800000    0x0
  2G    0x4557164      0x4557165      0x8c00000    0x400000
  4G    0x4000000      0xa7116e5      0x8000000    0xd000000
  8G    0x4000000      0xed121e5      0x8000000    0x15c00000

riscv does not define ARCH_LOW_ADDRESS_LIMIT, so it uses the 0xffffffff
default and every reservation is below it; the two queries then agree
and the global size is a number scaled minus itself. The 1 GiB case is
exactly 0, and from 2 GiB up a single byte of difference between the two
queries is enough to leave the 4 MiB minimum after rounding up. The 0 is
recorded, not just computed - /sys/kernel/debug/kho/out/ on an
unpatched 1 GiB configuration reads

  bootmem_phys:  0xb6400000  0xbcc00000  0xa2c00000
  bootmem_len:   0x6800000   0x0         0x13800000

with the middle pair gone after the patch.

Case 2 is the one that actually costs something. On a riscv64 platform
whose memory all starts above the 0xffffffff default limit, unpatched
and with memblock=debug:

  memblock_phys_alloc_range: 0 bytes align=0x400000 from=0x0
                             max_addr=0x00000000ffffffff
  KHO: Failed to reserve lowmem bootmem
  KHO: Failed to reserve bootmem, disabling kexec handover

The size is 0 because nothing is reserved below a limit that has no
memory under it, and the range below the limit is empty as well, so the
allocation returns 0 and kho_enable is cleared. KHO ends up off on a
machine that needed no lowmem area at all, and /sys/kernel/debug/kho is
not there. With the skip the same machine comes up with two areas and no
error:

  bootmem_phys:  0x1000f3400000  0x1000ca000000
  bootmem_len:   0xdc00000       0x29400000

Case 3 is a cheap way to reproduce the recording of an empty area on any
architecture: the parser rejects the explicit sizes only when their sum
is 0, so "kho_bootmem=0,128M,128M" is accepted and the zero reaches the
allocator. On an unpatched kernel it gives

  bootmem_phys:  0xbcc00000  0xb4c00000  0xacc00000
  bootmem_len:   0x0         0x8000000   0x8000000

and with the patch it stops at the two real areas.

> Note that I already fixed this for per-node areas since those do end
> up with no allocations with movable_node set [0].

That one covers the per-node loop only; lowmem and global are still
unconditional in linux-next today, which is what cases 1, 2 and 3 above
are about. Is there anything I have not considered here? Please point
it out and I will follow up accordingly.

Best regards,
Chen

