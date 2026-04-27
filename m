Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEF1CFF8869
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 16:58:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A0836B0088; Mon, 27 Apr 2026 12:58:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 002276B0092; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0C246B0093; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C889C6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 12:58:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D7A9C02BE
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:58:01 +0000 (UTC)
X-FDA: 84704943162.22.22876FF
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	by imf17.hostedemail.com (Postfix) with ESMTP id AD44C40013
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:57:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r2XYOrTG;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777309079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kERBmO7DDys9vM4deWpg4OLJy4cGxCI6vaV3V0iZwtI=;
	b=h9b9XXlVhlLxIzi43whfGlw79G9PUBb8teGtfqrMM7J3i+txaE+zht57tKYgatXQMD5Otf
	mvauudA4G0rwcjRfcovTK4kYnwhMwOlz2SjbxLh5PVrobRstH+DE3DpuRd4btq1sJI+/Hd
	z+DCzQ134QO9otvcOtXvGsc0zx3i6Yo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777309079; a=rsa-sha256;
	cv=none;
	b=T5ORnKLBh4mif0Tn50UEnw5tMqVSsMi8OX2Svi4HFGWvfNifkITWhYQfyQMXypQCeKogGs
	DVSU9bA51c6xnR1WvrJx3vG8W9grwAdMH4+TxQSwnyqVA+pbBREBR2wiGeYbMMsD2CcoCV
	KClGFidUu6+aThCywsUfj6jfxRUdo5Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=r2XYOrTG;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of fujunjie1@qq.com designates 162.62.58.216 as permitted sender) smtp.mailfrom=fujunjie1@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777309074; bh=kERBmO7DDys9vM4deWpg4OLJy4cGxCI6vaV3V0iZwtI=;
	h=From:To:Cc:Subject:Date;
	b=r2XYOrTGnv+MLXXKGqH8O1PLYP6cLF3SdRUSaM2M9ow8xMEziVLcMZevrsk+MgIcA
	 HN+9AvmV/fw9EzmrMFGuv3It6ogM2MOwkPYKcfh6Ih40N2NldfboTmoR9BUOYYFKD1
	 KRWFI7xH/R04JrZZifbqKSVYx9TgbQx0kkPNIJdA=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E73AA4C8; Tue, 28 Apr 2026 00:57:51 +0800
X-QQ-mid: xmsmtpt1777309071t78x7yuar
Message-ID: <tencent_4EDE373816615C46CFD48A6EF3B61E232308@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoeIXuabSxXgNxjCDp5Ll3NT2rbc+sorDduzfyOZXOOMZkXjhXLBA
	 DP6MvIbSOPjtkXuX6wwfhVFiBxY+ObCYjfOIN1+fjFaTNBM2RduRHl7HqdHhWnep864jp4MRCPDu
	 c/NsFwnJSbUMiO1bb+1BHGhGj4J3uWLnQhBuZcYs/Qc6Qiqm5eVdxlEtLu8JazKS8qdhUABj+puR
	 46wK+3UIf/YfPdYzpa7wiFMqvZVF0PTTRm9/6Qn/IgTybnJuJpaKJuw31FQZxy51D2G6Ly3R5vVc
	 vqMBUcA1QCcTmSJKcZaG03wsNaLXE6a8T6HNROrljEiUvNDSJU7T9c2EOzN0S4jlr9LMEwM/KDxN
	 k0S1yvjycLQVIRfL3S4Jn2zK7xSkMLRHYaipw3WAhQotC1TtdXOMcRiSiNrjrLZTFtlUuRVX6Fj9
	 dp+teW/qYM9klGKpv9XvrFAyIvPPTY+u1rwnR0TDbbuXK9UGZeJKiTlCGGRXVX9i5Z8SPRoupR7m
	 4LMl7qZhSy/51RH/cJ5Mo3TQr8CAVhN0VERpexi4bI0yENunh3ZLnOubPe2e6dlu5U8LrklIhttG
	 Bj7huPeBW4lw375CVt5OOhrOeqmnU1lkVtxer6yYyWD1F1a91l1ffzzSTLIZBHV0wyNqGbPZCeIT
	 QJOtcdyHm8tVWCn2UOCALFMKG0vwM7VEr5+Sk6j++ts47UZaQFuRsTgyH+m25d+IiIvMmHbru5tR
	 m4oXZhM/frb7e0lwiRxn41OtDmBfKUlSnBaVxXpntSW7c5oESfMVMKNJnrnklyfjyEfspCcXsnQ8
	 mYyC03y29kYcRb2uSMSHAehTwpM5VdD2m0apHDAfQ2TLDE6lXFThH6GgUHo2aZKj6clwFbsE/PW9
	 VTJecwE6OK+dcHfVCIAX2R8+N2siL+PJlj0Oj0jG9TY17AA9aOWLnBFyvc18cVKegBtDogkinBwH
	 ebnWXgHdr0VPcFk2kUAxfK0CFKDwoA0EvRZqUiVkNwibtUrrAPh9cC5pA3QQQXbWn1fW6JFpN8hI
	 HKBV1gCiUJaOlc0qeRdKHLx0jkgInuH9YeCla1+A==
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: [PATCH v2 0/2] mm/filemap: tighten mmap_miss hit accounting
Date: Mon, 27 Apr 2026 16:57:49 +0000
X-OQ-MSGID: <20260427165751.746502-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AD44C40013
X-Stat-Signature: ow1whmcdjwppyyniyyd1qmazmnwo83bf
X-Rspam-User: 
X-HE-Tag: 1777309078-73089
X-HE-Meta: U2FsdGVkX19BDy8WRNV6az4jJufBveVG7GBXRpXHA2GaQwJ3FRqtEAaMqC5gCJwvpRwsPxxIkYkO+g7kmOWYXQKj4aUwEnBuGURapr3Y9FeNCdYU83AiDvWwonNp1+UK1hmM11RMu1ETaUQKDjSHa+6TR+IT7PWYoHG6j+gxGJLMTHZbgLkuVFolYfXxubhu3CGR18ea9f+spn4W5GnNJfrnBAj5EKmHGh63yAm1leKBP1i8ZiNb3UW1xlN5XnN1NbPgVhalROIVuiQQe9P23WP5sPYK3boRGsJdFiw58DOFWJLXghM8y48h7cuE7vqK1IfyAbyArIqDGpRzFXZCT14ATcpUBW+K0/WHVgUME57KGLVSIoqyJDb7P8HDjThj+LBFfREvYEnpDH8JwLknMLMGaDDKPhbSJzEXlPsCQqvnXdEt/o2RQZKIjKJJNdaswzpb/F3tBbN/aQ8i5jm4skGrz3W+STY5eoU6Eq7jII9L+D+onaL18UmIXrrZypwgQTUbePDsGeWm6VAHTm7twzwfhibyQZs8F9aHy5PJXT4edO/2906HmU7cLuu1Sec8JgEXhDjP8fJYm6EeYFdJGPnODzbGKfGPHuILXcWb5Y7+nMOMyOIM5nUjhYrGK1MHGZMvGa38PaB9EiyT29BkHVkVRlxYqiIBC6YcMKxbWz0n75R3rw7SKioo6SAC7V1Id28dTejWfvt8xmPCuu8yC7mVpdKqcopTG0DHCG/Dxtoer37XlDOP3RDLJVotwJJJOYov5gkiALawpyBLjIvVVH/NqVoVYXLIhsrQQzpsExvXgQOpdaRUahskqqMNS9pqkDhyb9586tnmCmACwHLbwP9OIISWaLOLzUuuZVrpfhSzFQrbWO17yHzKKwZWvMQ228r9jt3HEqKWg+gte7Fy4OWkJ+l+jAj5biUERZD7OYMidzcq+aGvn49ysSdK1fcbXB3UdO+lfs5QKLiuxGo
 JhKkGpFb
 EXwFHBwvirJy9PJmyF3leQZemxsIPJ769xHxxNbXdlrF+0MP+J0L37pX366fzqQ+D0G+Wq5lx6jd/aAWqj6UGet5hjlSsDsq2aZn+EErVGs4vnNkgFRqsbPt0XLjbQ7d8OIYGwgVqueaIqpHPAZQGrRmZsi0e/sxCCoC7DxffTxiYwVEAj6iF0JB3zv/7bE5/WT1xn9rZ4U/v0+DU0TYkUv+19+nlBUBg/kKPIzTHelJMIX/wpFH+T/rlva4qnX4G38wLviiwQg1DQXcw4UNKY4/VgfDH+DpI1a1wUuWB329+Xj9L/1jEtBt9V+/R5Zi6D4THhykfHs3IzmU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is v2 of the mmap_miss hit-accounting change.  v1 was sent as an
RFC.  The accounting logic is unchanged, but the series is now split
following Jan's review:

  - patch 1 limits fault-around hit accounting to the faulting address;
  - patch 2 stops FAULT_FLAG_TRIED retries from decrementing mmap_miss.

Patch 1 also follows Jan's implementation suggestion: the helper
functions no longer propagate a mmap_miss variable, and
filemap_map_pages() updates file->f_ra.mmap_miss based on whether the
helper mapped the actual faulting address.

mmap_miss is increased when synchronous mmap readahead is needed, and
decreased when filemap_map_pages() maps folios that are already in the
page cache.  The decrease side can over-credit hits in two cases:

  - fault-around installs nearby PTEs even though the fault only proves
    that the faulting address was accessed;
  - after synchronous mmap readahead returns VM_FAULT_RETRY, the retry
    can find the folio brought in by the same miss and immediately
    cancel that miss.

Current evidence comes from a local KVM/data-disk microbenchmark using
mmap_miss_probe, with an 8 GiB guest, 2 vCPUs, 8192 KiB read_ahead_kb,
cold page cache before each run, 1% of the file accessed, and medians of
3 runs.

mmap_miss_probe mmap()s a prepared file with MADV_NORMAL and then
touches one byte at selected base-page offsets.  The access order is
random, sequential, or a fixed page stride.  The harness drops caches
before each run and samples /proc/vmstat around that access loop.

The 20 GiB case below is a larger-than-memory file case in an 8 GiB
guest.  No separate memory hog was used.  The 4 GiB case uses the same
8 GiB guest but keeps the file fit-in-memory.

Each case used a fresh temporary qcow2 data disk, seen by the guest as
/dev/vda, formatted as ext4 and mounted at /mnt/mmap-matrix.

Each result is "pgpgin GiB / elapsed seconds".  "pgpgin GiB" is the
delta of the guest /proc/vmstat pgpgin counter, converted from KiB to
GiB; it is used here as an approximate block input counter, not as
resident memory or exact application IO.  "Elapsed seconds" is the
wall-clock runtime of the whole mmap_miss_probe access pass, not
per-access latency.

For the 20 GiB larger-than-memory case:

        workload       before                after
        random         223.377 GiB/101.293s  1.010 GiB/4.790s
        stride1021     204.214 GiB/97.557s   204.208 GiB/108.086s
        stride2053     409.584 GiB/193.700s  0.970 GiB/3.685s
        stride4099     406.452 GiB/134.241s  0.975 GiB/3.499s
        sequential       0.212 GiB/0.050s    0.212 GiB/0.057s

For the 4 GiB fit-in-memory case:

        workload       before              after
        random         3.987 GiB/1.960s    0.980 GiB/1.221s
        stride1021     4.002 GiB/1.838s    4.002 GiB/1.851s
        stride2053     3.991 GiB/1.835s    0.811 GiB/0.985s
        stride4099     4.001 GiB/1.836s    0.819 GiB/1.037s
        sequential     0.056 GiB/0.013s    0.056 GiB/0.018s

The 20 GiB setup also has an ablation.  P1 is only the faulting-address
hit accounting change.  P2-only is only the FAULT_FLAG_TRIED retry
filter.  P1+P2 is the combined accounting change:

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

After the v2 implementation refactor, only the final P1+P2 shape was
rerun in the same setup.  The numbers stayed in line with the v1 P1+P2
rows above:

        workload       larger-than-memory 20 GiB fit-in-memory 4 GiB
        random           1.010 GiB/4.383s          0.980 GiB/1.088s
        stride1021     204.216 GiB/105.601s        4.001 GiB/1.783s
        stride2053       0.970 GiB/3.760s          0.810 GiB/0.908s
        stride4099       0.975 GiB/3.410s          0.818 GiB/0.870s
        sequential       0.212 GiB/0.060s          0.056 GiB/0.016s

This does not claim to solve every sparse pattern.  The stride1021 rows
are intentionally shown as a boundary: with 8192 KiB read_ahead_kb,
file->f_ra.ra_pages is 2048 base pages, and synchronous mmap
read-around uses a 2048-page window centered around the fault, roughly
[index - 1024, index + 1023].  stride1021 is 1021 * 4 KiB = 4084 KiB,
so the next access lands inside the previous read-around window.  About
every other access can be a real faulting-address page-cache hit, and
the other half can each read about 8 MiB.  For about 52k accesses in the
20 GiB/1% run, half of them times 8 MiB is about 205 GiB, matching the
observed 204 GiB.

---
v1: https://lore.kernel.org/r/tencent_3F158B17AE85E73945C5F97D8F8A918F9B07@qq.com

Changes since v1:
- split the original patch into two patches;
- move mmap_miss updating back into filemap_map_pages();
- drop the mmap_miss argument from filemap_map_order0_folio() and
  filemap_map_folio_range();

fujunjie (2):
  mm/filemap: count only the faulting address as a mmap hit
  mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits

 mm/filemap.c | 56 +++++++++++++++++++++++-----------------------------
 1 file changed, 25 insertions(+), 31 deletions(-)


base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


