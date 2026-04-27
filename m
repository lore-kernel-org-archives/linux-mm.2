Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0022FF885E
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4196B008A; Mon, 27 Apr 2026 06:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354FB6B008C; Mon, 27 Apr 2026 06:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B086B0092; Mon, 27 Apr 2026 06:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 162106B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:22:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AEE6EC0310
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:22:53 +0000 (UTC)
X-FDA: 84703947426.14.1677EFE
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf09.hostedemail.com (Postfix) with ESMTP id 550F114000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:22:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=byyI+l3T;
	spf=pass (imf09.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777285372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8XjNhBqboQlWA2suiTcgXcRgUWxwvfEb6HIhOTzQk8E=;
	b=MNGTya24+G5eQ0xqEjO17aWoTv1nE5gAZQjNF+6wdb0AXO0fBJTf5254DeCSdux9VO5Dsl
	iZPOxOBOLGl8gsl9tibnyfpfK+a5ycSM7IqHn2S5SWx5st17ND98/DGpP4EM0ReO+Mv8lq
	mlAh1oqyVSHIR7LBz2zwTSd5IIeM2HU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=byyI+l3T;
	spf=pass (imf09.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777285372; a=rsa-sha256;
	cv=none;
	b=kRu1Mk2191LiZUXhofp4uTPHTBjsdVEPTz1Z5+UwyVb+cpvLQyxchBq6CxXryD3bFEjkdB
	7aKhntCG4TPize1SklJH0xxxwGL7fPmaSCftLnCNvdFYNLkRdXrCaQaUGVZE8iAmZYNYom
	hRE7UtbT7sxuv6uNn6LcEmztB0Sde6k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777285367; bh=8XjNhBqboQlWA2suiTcgXcRgUWxwvfEb6HIhOTzQk8E=;
	h=From:To:Cc:Subject:Date;
	b=byyI+l3TABiGW2A+WHY2809JgzQE8JXjs2mkY/FZogBBlKI74FyEbbMEpJvDbWAlo
	 spkX5C2utC2MSY9/WwZrQ0tQmK0CMcivdijGLM4oMZZ+9/wLoYPBa1GHDnciIh2xsa
	 z0T7KZg50+PBaAXYNTuJjGfbcVSJK9pAtisJlR68=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 5AC362AB; Mon, 27 Apr 2026 18:22:44 +0800
X-QQ-mid: xmsmtpt1777285364tc7ejmjs1
Message-ID: <tencent_8D8D38DE345934735D3FCF289ECD6379940A@qq.com>
X-QQ-XMAILINFO: OQjltBcbYeafGXxklMH76yrpAEjte7amObSCrhyXYbZvJun4Z66Aet3vvmbuQY
	 BCDkE99jY5DlknH5dx8UzkhDPalKf7AiS55WbtJdKYQpRRTcu7cTY8RFU7WNKUCxam/zIlDlzwco
	 sGPXLVnNeDjc0UNqJgpHDVhLAV0mqS/GkG8mB9iGaLjDvhQtvz8/3JEhX2PD+gU7tKISDW39yKgx
	 QLnK/r/C9PQZuGl5AcrUz5t/zO0XsYf4YHSx3arG2uFAgYtLm0G39yJDxLxYVETUnURAFbDfM9fX
	 NniY2tszeH3/HH7rvJEWKG/EWPf36iDnexOLYE3O2Zy8rjMR5o06TJBAmZ8BjY1lUcC/zrswrKpF
	 E3Rksii73+xRV2cF4Sw8vp9q38xcEGxLOZY/JhrviXcvYiE5CHHwb77LfqkcbSHgz6fs5xnKk/Bp
	 TKvLKGM29CeQCRqvYRM7hel8T8/yfXjPkR2W3gwBiuu/zLCpAb9wdonFs4RoN49ZaMMMV4s/cxKb
	 +oIqt8rIJ/zREzsUuIFBRM52PVLnWE/WTpXl6QHz+z6aP1GYfjZvgN2aiZ4wuHoWi1f5IwG15M8h
	 kgBPWR72jQ78monMHxs38vaEaUWsNma9EVtSEC9gonK71FsjiRWJujrARNQgSsber29kxRBcjun6
	 g9WSo4nOOGfr60JC//tTIzxCtY+4faahwig3iiIGa7V8BS4zED3q/t/Z2e1qLVtQqXMBONukJ9DF
	 auWZOvZEbg91jxgy+q+25gh+ZLzP9gBXj+WgCNVWBIbfU7z0WYthv9gEFh9IzOG2TdA9HkRAWiXZ
	 fYhnDKZ8a5CBT9lQrOeTjj7bFNvY+RLfsqqkBcgynReYjXu3M2Ro7dztyKlEOa0msV5CY/B81Zqf
	 xlg/9CcqQWTNbRRCCxqOjg2F41KV96b5UkIvtuly81mxD6V1fCmc8VYGkL0uUCd57iSyk3PvWEp9
	 +CYBQSy8uLfcMmsb07lN1JMwJAUpiQgvWMmEWy7PK3xTf4twYln5mi4Mp7J5gtlIPFfWCGh73TWF
	 7rGORCNk2qKMEcjLHEYJfEppWtbvCjYf6pLq/oeg==
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>,
	fujunjie <fujunjie1@qq.com>
Subject: [RFC PATCH 0/1] mm/filemap: tighten mmap_miss hit accounting
Date: Mon, 27 Apr 2026 10:22:42 +0000
X-OQ-MSGID: <20260427102243.3519326-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 68s7j88ex3sdoq1u4fdupswzjcrbxj54
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 550F114000F
X-Rspam-User: 
X-HE-Tag: 1777285370-19463
X-HE-Meta: U2FsdGVkX18/lWSuVF8qdM6HeVCZR2VRi2+akJf1FvvpjKJxsbXxvz6oGBzwNIJjHBo3xoTWVufhsemur321WB9at8HD/DkIOpGHLwUvinHZehh33Gudl3UJGnlw3uOLyjnHAuI4H2ygY+8ln3XUdj28Vv16MgP9GrhLyHhu7C9BGpFleaDh/cQGbdwG1QTLXsP4LtOGYPcj3QihNSXnbzzxjVrItbt2kVWimILGAcqD6JKm9MXXnZlyaC3zDnU8P3ZtNQ7PMwyRBzSVzqv09oqQjpkuQpTLX8uQg3ZlAYKi/inxpUhn/7VTcF7HtqBVk4dlEVhuzA9xvPpOtqDRFIEcbSlq4ASqqE3Xzzst26K+uWbS03MFbPJ8IW+dOkEnm0PkwU+CelmqyYK1EeqMZji0DSU7k5TGV09xLNqpEdPdQKKXP7aj6TVUbh00UKWBE0l0Zrxjh+0JqamDTu0w54TWX8nfBMxZhJd43Cu1H596rYilmQ9XbrvOueJYQlbYLAH2Qk+q40DJ58toIkNFxIn6guffic6qi3SgbsMr9kfFKqx6HIAo8O+q4Fv3x2LMfnnwgdg+LwSnNRmjYCIgM+W0o80DR6FalknuIA1oLYYRXfb0YrNz021A/d3at6UyXn1cv9uPli/T+DUwHUY9CauF6logUDAI3zKHD1cFX4OKWIHgHswz7hj0a7r1GP5QUqbS3h5Quq/z6f07YFPkOlvMvpVAgwLIYrny9vdkWZdD2oM9EAeNa7YJFMAMa7aOCob3jewM2dWsH9NoI9SpoCPYPumPL/Ox2t1EGKXyYQ+5e89c8DlvwUqnecMoIV9Q3NjvhNK0lc4AEAV8IX/6AmPQu0R7xaRERfsSUlW5TaVnLnNYJlXSM+80+W8i3fmaEkpsvP0J5yPE01tp4aQtge+uIcTaFz/Z76tYo4IoS04svjJgmCnEF4Dj1+FNlT5AOt4oIvOtfRIuuKODRxf
 dYh2aCNX
 Xvdo7WzvRg0MNf8JZtNgZ+yvQ+xRSbvmD9T6ldNHPtQwnGMrdmRuC71AealbS29GAtUA/GzV9wsdbNonYuHzcQIeF0KfjTNeqbMxIxE2Mj5qIifcQ7umcceQKOeHiFuCVqu1VXiRUbIhWoXjXs3+3b//9gwYGCLEA66GMY15eCITTD+u0swkV/a24CK9jrYAAc0jQYKdfU1hjvcjgxO4RlfAxeRgecIR+2Z0HjPACB+at+6LudAdwuhpuqN74oNc5Drms7MG+9LDrB+QQvF4T0sKYb/PUo7vz4xNH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This RFC explores a narrow mmap readahead accounting issue in
filemap_map_pages().

Today, mmap_miss is increased when synchronous mmap readahead is needed,
and decreased when filemap_map_pages() maps folios that are already in
the page cache.  The decrease side can over-credit hits in two cases:

  - fault-around installs nearby PTEs even though the fault only proves
    that the faulting address was accessed;
  - after synchronous mmap readahead returns VM_FAULT_RETRY, the retry
    can find the folio brought in by the same miss and immediately
    cancel that miss.

This first RFC keeps the scope intentionally conservative:

  - only credit a hit when filemap_map_pages() maps the actual faulting
    address;
  - do not credit FAULT_FLAG_TRIED retries as mmap hits;
  - keep the existing workingset-folio behavior unchanged;
  - do not change async mmap readahead hit accounting.

Current evidence supports that the change helps sparse random mmap
access and sparse strides that do not geometrically overlap with the
read-around window.  The main data set is a local KVM/data-disk
microbenchmark using mmap_miss_probe, with an 8 GiB guest, 2 vCPUs,
8192 KiB read_ahead_kb, cold page cache before each run, and medians
from 3 runs.

mmap_miss_probe is a small userspace benchmark used only for these
measurements.  It mmap()s a prepared file with MADV_NORMAL and then
touches one byte at selected base-page offsets; the access order is
random, sequential, or a fixed page stride.  The harness drops caches
before each run and samples /proc/vmstat around that access loop.

Here "pressure" means file-cache capacity pressure from a 20 GiB file in
an 8 GiB guest.  It is not an extra memhog workload.  The fit-in-memory
case uses a 4 GiB file in the same 8 GiB guest.

Each case used a fresh temporary qcow2 data disk, seen by the guest as
/dev/vda, formatted as ext4 and mounted at /mnt/mmap-matrix.

Each result is "pgpgin GiB / elapsed seconds".  "pgpgin GiB" is the
delta of the guest /proc/vmstat pgpgin counter, converted from KiB to
GiB; I use it as an approximate block input counter, not as resident
memory or exact application IO.  "Elapsed seconds" is the wall-clock
runtime of the whole mmap_miss_probe access pass, not per-access
latency.

For the 20 GiB pressure case with 1% of pages accessed:

        workload       before                after
        random         223.377 GiB/101.293s  1.010 GiB/4.790s
        stride1021     204.214 GiB/97.557s   204.208 GiB/108.086s
        stride2053     409.584 GiB/193.700s  0.970 GiB/3.685s
        stride4099     406.452 GiB/134.241s  0.975 GiB/3.499s
        sequential       0.212 GiB/0.050s    0.212 GiB/0.057s

For the 4 GiB fit-in-memory case in the same 8 GiB guest:

        workload       before              after
        random         3.987 GiB/1.960s    0.980 GiB/1.221s
        stride1021     4.002 GiB/1.838s    4.002 GiB/1.851s
        stride2053     3.991 GiB/1.835s    0.811 GiB/0.985s
        stride4099     4.001 GiB/1.836s    0.819 GiB/1.037s
        sequential     0.056 GiB/0.013s    0.056 GiB/0.018s

The same 8 GiB pressure setup also has an ablation.  P1 is only the
faulting-address hit accounting change.  P2-only is only the
FAULT_FLAG_TRIED retry filter.  P1+P2 is this RFC.  A representative
subset of that ablation is:

        workload    variant   result
        random      baseline  223.377 GiB/101.293s
        random      P1        223.268 GiB/98.481s
        random      P2-only   223.257 GiB/100.091s
        random      P1+P2     1.010 GiB/4.790s
        stride2053  baseline  409.584 GiB/193.700s
        stride2053  P1        409.584 GiB/197.645s
        stride2053  P2-only   15.722 GiB/5.485s
        stride2053  P1+P2     0.970 GiB/3.685s
        sequential  baseline  0.212 GiB/0.050s
        sequential  P1        0.212 GiB/0.046s
        sequential  P2-only   0.212 GiB/0.050s
        sequential  P1+P2     0.212 GiB/0.057s

This supports keeping the RFC scoped to the two accounting changes:
P1 alone was effectively baseline, while P2-only helped large sparse
strides under pressure but left random access at baseline-level IO.
I also tried variants that changed async mmap readahead and workingset
handling; in this data set they tracked P1+P2 closely, so I left them
out of this RFC.

Current evidence does not establish that this solves every sparse
pattern.  The stride1021 rows above are intentionally included: the
20 GiB run still reads about 204 GiB.

In the table, strideN means that the benchmark advances by N base pages
between mmap loads.  Thus stride1021 is 1021 * 4 KiB = 4084 KiB.  With
8192 KiB read_ahead_kb, file->f_ra.ra_pages is 2048 base pages, and
synchronous mmap read-around uses a 2048-page window centered around the
fault, i.e. roughly [index - 1024, index + 1023].  A stride1021 access
therefore lands inside the previous read-around window.  About every
other access can be a real faulting-address page-cache hit, and the
other half can each read about 8 MiB.  For about 52k accesses in the
20 GiB/1% run, half of them times 8 MiB is about 205 GiB, which matches
the observed 204 GiB.

Feedback on the accounting boundary and on suitable test coverage would
be useful.

I will be travelling next week, so I may be slow to reply.

Best regards.

fujunjie

fujunjie (1):
  mm/filemap: tighten mmap_miss hit accounting

 mm/filemap.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)


base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


