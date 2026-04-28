Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B55EFFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53726B008A; Mon, 27 Apr 2026 21:57:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C04D06B008C; Mon, 27 Apr 2026 21:57:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF3786B0092; Mon, 27 Apr 2026 21:57:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 999EE6B008A
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:57:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 33C3C896D4
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:57:33 +0000 (UTC)
X-FDA: 84706302786.11.9B71897
Received: from out203-205-221-153.mail.qq.com (out203-205-221-153.mail.qq.com [203.205.221.153])
	by imf06.hostedemail.com (Postfix) with ESMTP id BC12718000F
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:57:30 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=lMI77BP8;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.153 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777341451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=73mUVB0SU1+y2tdFcAaGVu6KuNfJfyDpo9D8I7WdLQA=;
	b=TI9WU0RdVfSnl1y6HpQYz+pAjD1qonQZ2fiDiqOnrDfIcJ1TsQzxPmCF/6yODyFKWj8j2K
	d9PpV9NRGHX1t3bpCn6RmqVrTNFXkqaqBHhT4n7RSNnCraRHC5RgQCixADxsbO/BVzPC8w
	zNuyJB/H2ohpU0G8MnqXWDMQ+jQhRuI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=lMI77BP8;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.153 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777341451; a=rsa-sha256;
	cv=none;
	b=LUU21Fe+av4LxS88+3PT1eeA3Z8ypnDIOu0XlubHPWi8oak9V+U/cmYe8fqGck0bT7PDS7
	3T/KmcmOXnlTXjr/Wgf7CCKg5r3zOuoSqL44eZDOnRidwZU2/ft4n/o7SXnn95godziONn
	QrRNUssAWNCZSYpcW9YA6uZhvA4Hivg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777341446; bh=73mUVB0SU1+y2tdFcAaGVu6KuNfJfyDpo9D8I7WdLQA=;
	h=From:To:Cc:Subject:Date;
	b=lMI77BP8cwH48F+SgHOs3WTTSzuhBNHFcXhQAvNDbSH1EH7CoWXVLMGz4OCKdwsHZ
	 xoenKNMUNumObkheDO2cEixOR+f2Ts/Bs93EbV3SodWIfYdnLZJ9oXrSWtb6zYttDA
	 Kpu4td+zvGDfJE+fYsBfMb06yxIWayYuDLZOJWIg=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id E5690EDA; Tue, 28 Apr 2026 09:57:22 +0800
X-QQ-mid: xmsmtpt1777341442tcrjydyx6
Message-ID: <tencent_AA501E9A238337BD167E5C2ACF948A1AF308@qq.com>
X-QQ-XMAILINFO: NnYhxYSyuBnL4+7omke2R7OZlKh08Uyt8A9dZq32a3ObS0LilS+sUOt1LczsON
	 8qrI+J7UEV3CrsQxN8AwVwGeQRsrJX394YCDA5H5Xj0DqwOuQ2j+B0iyMEp9vSoaTigXZvAIvh1f
	 uBwL7PZw5C0gELWVXCUwqrxYZq8gfy0bTYgM6Sd5KdDcH1ZY7L/t1DeY1YispKrFupAyvED9MMgo
	 6y716L6WniRi052xDEbsrQLv/krlEAZhxhTT68m0Cj1gdQP9ezbO4OvPXc1pbDoO/Xd76QSHeEei
	 HfGIOGiqK3G6r9sZWLuPUme+fYG+aGToZHGqF4PC4BvhtL/rMj7SW9+TBAkUEKH+3xxqPEYaVQCT
	 pwTqdO1jeXbFVTba/0VKAxc68JTRQHOZR8q+FuIvdyxwKOZrwoWjc5V8n+ZkTVNAUrrQ9ptU6kiz
	 5paslM9tTVOzWqv5DcF1IqSjV2cLIXqXXnH8sdnmR4wUXe2BVjIGb8NYQCRqL1xFhDPFBN+QREf1
	 OmJ56qT2m3cTyY8r1AxNERUEs4y+5PLDrWFRHcnKwv5MuCMo/XUl/+P82wHWCyk5TJ4v1whUV8iK
	 vOjjNKY1wArQGbsCxR1LGbF1qstBvB6EjKqNjttU+xgkrxg5+U4l90ylrP0PHhVhASsZxKS4Iert
	 g2jso76V28FaEWZ/aILsvzi1qEQFT9suq9aUZysMNEhN1vIZuzeSPdceXjsIFweYuRJUtn65J9tL
	 CNAwtY/C8ZbsN1hmlqtQsx7R9quppvPRFdnLj6P1GOW7cQZrWATIBjVapm8L7zENDXD7GdOvsn/C
	 8JOdrEb0F0OWMWBykaqGtVERvlvZRgMKwmP1eL3hBNEOxisnfgH/+HHpInsFSJnHfldmDxM6vXGB
	 6hSciyk+h+L45se6bczXfDjpuY7Ryky1Xl1ZMyRNq35BOtHySjeP3221SyECm3Nm5k90RiIxQJnJ
	 9TKBk7V85D42TDs+qzGzTsVWGPpItpVdaC1ufVpOQFDighPtI4N0Hfyqx/CCJUxK1MPT6/e4e00w
	 PzB+q5VYqtQOkMFobRfBI5RwJyX9ZMKcAwCx5T9uMzsIKq+rbj
X-QQ-XMRINFO: MPJ6Tf5t3I/ylTmHUqvI8+Wpn+Gzalws3A==
From: fujunjie <fujunjie1@qq.com>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Haoran Zhu <zhr1502@sjtu.edu.cn>
Subject: [PATCH v3 0/2] mm/filemap: tighten mmap_miss hit accounting
Date: Tue, 28 Apr 2026 01:57:22 +0000
X-OQ-MSGID: <20260428015722.2592705-1-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC12718000F
X-Stat-Signature: u6ei9t77f33c1ex7uy7o1iedkmwb4inx
X-HE-Tag: 1777341450-990243
X-HE-Meta: U2FsdGVkX190kozuuqYjXd4nMd14Lk/uc57EtQ/xWWlcLAG+7RM11j3+A+HQrH0ZQjMaykaOr7ZCmvNGMDP7afGzZocYHv7JSxShc6A8zIrpRZY0K2p1UryeVhd0zcpdeCDceNFn4ADKXu2UBnj/Axk4Fsl2VyAzVToSdgbmM8dMQbTlmkiE+Szr/taPG3C7wv9H99JHGL41tKuNM40Qx8QKuXBmZAJtnUy31oMBu7f4YiKqzCP9N8rjXG1d5IuGwjYIBEczzfDDGmF/dDt/sREmwmfM0Y5cqxWjgYUin2VA6zFNst/aLzOrohP4ZpVpTtH11wTWPZ4WRsboP8gDLlQE5NXEJ92gWccFWD6ZEn0+6koFFrF57uplvS0B43RB/fMg4yJyNwOMPrpTqAxtAZj4cUzqWKcfI4yxocUaXW+vAyBbl6qJ5iivPtG27PPxqq28HQr4E4QLdFRLMmoR6yvJ9BoyX9QcFDJw4nl5htsp00IM/QvP7xbhqY7dJYLkngNtM1heQIpUwqR+HAeMdDzcxxzoh3MtThxW7iYp67MfoSRqARSIhawbnpzgNDJxQwL6uSHYoQXzDLaGhTODZuKAgCpykaBfMtBV4Jq8nSa4i+Ofb/S9xAJe0vQPhi6RencOfiKBscjdFmjjfnHKRXXK4KSrCZIDPzon+ueAKlZc+Jzo8HnS0J8Scd9dZCNcjnIsSaA101FwdDEHHXLPdQ9E6QBroPaazWK3NciQmm8AfMny7zhlb3qXzxPMsNFhBIuogVsW1DLhKqaMdsUFgNLJUgt35uuRWr8P3hjAc+wosgB/WtU/zy1mrQj352k9sf4bYWXV1Sv3leZhPM1DOnw+COq8iO0cfjIN/wqWMug0m0ZzlheiYjYNyIHNKYZaZ7Jjp6Dgf1axTB7l7oJidIEkfqBX94rEg9ThspGRiebktRl9BGBSRn7zjrRdpaCBG9DhY5/H/njbdPALPHe
 AzXdLqRd
 o6xSF2Rzl7e1H6K8iFUpBvFuT71CU0iLtXNW1apgHn8L/oZHU7amg5rc75LTmbMNMzHYhPELzVTKXGtH/h8lb20RMX1E7MxjQBnsi1dJSNIz+Xpmucl/tHQxvWbHbYFRXIgQ1NtXSD1B+bk8qneVlR126HwMJScXmdad2GRvZi7YZpInovqzCiZ3OSCoMeyK022vI3eBoYX9SmgHpFimTMynmYdymtdRz5ZubsJl5W+FimP80NWLtVq2d2NdgBTpj7fXssGhVV7OjxEuxux4Owbw7t7fwt4N6vFa3QBY+85XhX+vVWmosKZeJ1/Doq5dZcnuiJUgVlzZe4qk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is v3 of the mmap_miss hit-accounting change.  v1 was sent as an
RFC.  The accounting logic is unchanged from v2, but patch 1 now keeps
the workingset mmap_miss comment near the new accounting block as
Matthew requested.

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

        workload       larger-than-memory case    fit-in-memory case
                       20 GiB file, 1% access    4 GiB file, 1% access
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
v3:
- move the workingset mmap_miss comment to the new accounting block in
  filemap_map_pages().
- no new performance run; v3 only moves a comment and does not change
  executable code from v2.

v2: https://lore.kernel.org/r/tencent_4EDE373816615C46CFD48A6EF3B61E232308@qq.com
v1: https://lore.kernel.org/r/tencent_3F158B17AE85E73945C5F97D8F8A918F9B07@qq.com

v2 changes:
- split the original patch into two patches;
- move mmap_miss updating back into filemap_map_pages();
- drop the mmap_miss argument from filemap_map_order0_folio() and
  filemap_map_folio_range();

fujunjie (2):
  mm/filemap: count only the faulting address as a mmap hit
  mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits

 mm/filemap.c | 63 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)


base-commit: 1b55f8358e35a67bf3969339ea7b86988af92f66
-- 
2.34.1


