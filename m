Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 139CACD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 16:56:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 257B16B0005; Thu, 28 May 2026 12:56:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EF26B008A; Thu, 28 May 2026 12:56:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 145766B008C; Thu, 28 May 2026 12:56:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 063606B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 12:56:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4D3B1C075A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:56:50 +0000 (UTC)
X-FDA: 84817432980.27.1D6EBC0
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id BA93B1C0009
	for <linux-mm@kvack.org>; Thu, 28 May 2026 16:56:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7Z8PWaX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779987409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dlemPSM8cSUroxllpFZm7gDDts2mYGGMK9+8gF6D+hE=;
	b=ju2bUk8mrKR+LhbkljOwLtFySOuiW8Fd0V9cXImnKPacx6YB3ci1lBFArhMgXZtjiMQ/Z3
	TMD5kupBFrx0p8EZUYY9RGmzxQH8FS1JcRm7PdXmkJMjO0SCkiM5XSb03AR7AqTDDn/hRx
	yPFsNFDgfKwsttpQGbvtsQ/pSI9dPyI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U7Z8PWaX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779987409; a=rsa-sha256;
	cv=none;
	b=TQ3h+HHk0HEvR+8lAeQMel++Oyrkj/SNfji3ZaBmxo5ssmNG7vawpagy7ARALRznR2o7/M
	gnDKd/Fbdw5KJuYkxjgnyVYxsDcEc4dPh8qsjPZIipRZv9v4X6VeZKk2I0YTMrpbSdn/o/
	tN6+sxarP+HtqIRDQf2S32U4BI5Yl00=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779987406;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dlemPSM8cSUroxllpFZm7gDDts2mYGGMK9+8gF6D+hE=;
	b=U7Z8PWaXd1LiVL34NeRBv++9TxQ5+BvQJaqmv3qHs4qdcZ4SAYffV8Jj9zelpzfvPRTCS+
	nNLI9BC1UB6RQgWglYhvQhLHeiOnYqEKPhqehjIG/e2abaaIVg2QC61UHaDyKbUMtkXTCX
	4V2AfSHeFbkx5ICVntSD+v4mGoe7sDI=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz,
	Andrew Donnellan <andrew+kernel@donnellan.id.au>, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev,
	Liam R.Howlett <liam@infradead.org>,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, ljs@kernel.org, mhocko@suse.com,
	npache@redhat.com, pasha.tatashin@soleen.com, rmclure@linux.ibm.com,
	rppt@kernel.org, surenb@google.com, vbabka@kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v6 0/2] mm: improve large folio readahead for exec memory
Date: Thu, 28 May 2026 09:55:18 -0700
Message-ID: <20260528165635.2068012-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA93B1C0009
X-Stat-Signature: ubasere8wxsa7416cidhyj6zoipoq1ec
X-Rspam-User: 
X-HE-Tag: 1779987408-477800
X-HE-Meta: U2FsdGVkX19NEJfzY9Rp4PBskxyY092AB/LJ4ySynly5DWRGc9xncaDcuIepn5GWkXimc6uct4zc6xANIIV+PifIdahc6TX09P3GIhrMdfZetN5N5FSar4GADHHD52dFyvQqdsT7cYgpAGNTOh7XS491L+asjN7vJhGUwVfxrTWwuJRdgN2AZOKruAyXDKY4vLhsMvxspc58TmFjYhQX4nOi2+oevA92U3Lgp4A1O8iPcDE/9i/yGe7HiJEj0N8BYbLTnrinwkx+wrwv03CvHgSZlKBnX2AZ6WjK4YrjfoxzWXydXftrBvcEoQ/rtHtI7TYuCdRfmf84Om5mL/0s/ksRamh3Ucn5Ca6lEvFTKeMcDwWBh2N9oUpTv6Ud4/lDTi2hQ5GRLFoPdo9jyq9+YwTLFJpwc1O/xjSORlZAwyx7EA2rwjSw34jYxpDqHiXmIytMSXs3GZ/WBV/JrM5WS93h5sIRmuABPtn3H2AKZT6RLE45rellT/JwiofsPLT3vQJPWtKnoBkx7iRjC4N0R37fubM+Di360Y2U2SKjOyBLNKSo54V50Fsi2UROAWz5zq/cLD8mgmNpk3BSzjo9IWU6eMH5r/YxZfcedFhnqIIFbuG4w9Ag8hhW5hgYF/apccgWwZancKCvU04ZsQQl2osOFgqIbK5HA/A/v8rPxxlfaMY4aqpmMSXnaUN1kn0FCRf36QSb6PWOWXTpUOR82IYMDKXJ08qa6K7YGSmCMWLtB0RafmdoyRKAoJyg3w7PzkklYwK6C4gWuq+Mk3OytzOJkIdHWR1H4LFtM/NUS/FZVZiVMtB2ITEME3Z3ZnDD1rImmuwOuv5WEbQXbKQ2hn10WsK4Nal97TiWGPEwVsWRUK4mvJFEw4UNFWEAjXBydMUxaOFKCE/Dsv0hBf606QMNCXDk8vJvjjiBHHL7eJOS4XI3QLD+qWAwvgNl3sv77XTtuWJHdTyql+d9IHs
 FZjDjQRC
 pdQSUIDVZZMLD++gO/cQYdh2J/mBR2iHn6aOGm8YkJ6LJ16ZbPhxYhqgqjBBzJEo6yFBXuucf1CK7U5tFFu25tXf9tbf5uD7WTaeVG66x45YfZTxjboUbrMfBFpAbR+xiITXSPDUEh4m3I0FTRzYNLs286P9MmjbQhYxXaZfiyEdCiqQCmHWlbVSkkCitHRyREjP4bKiB8wENHrAkNLbbiLkRHSbEvjIZ8NBuURj+lc0jwWmMHVe0Qq9V70c7QpPdjK6HpKcTcVpUyIbgX9yS+zeFmfSQV5etmF6vhbzQC/3L1O+FzeElJSCF418EFYTwGH3KWxut/dCuf8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two checks in do_sync_mmap_readahead() limit large-folio readahead:

  1. The mmap_miss heuristic is meant to throttle wasteful speculative
     readahead. It is currently also applied to the VM_EXEC readahead
     path, which is targeted rather than speculative. Once mmap_miss exceeds
     MMAP_LOTSAMISS, exec readahead - including the large-folio
     order requested by exec_folio_order() - is disabled. On
     configurations where the mmap_miss decrement paths are not
     active (see patch 1) the counter only grows, so exec readahead
     is permanently disabled after the first 100 faults.

  2. The force_thp_readahead path is gated only on
     HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER and always drives the
     readahead at HPAGE_PMD_ORDER. Configurations where
     HPAGE_PMD_ORDER exceeds MAX_PAGECACHE_ORDER never reach this
     path, even when the mapping itself supports usefully large
     folios well below the cap.

Both issues are most visible on arm64 with a 64K base page size,
where HPAGE_PMD_ORDER is 13 (512MB) -- above MAX_PAGECACHE_ORDER
(11) -- and where fault_around_pages collapses to 1 disabling
should_fault_around() (one of the two mmap_miss decrement sites).
However the fixes are architecture-agnostic: patch 1 reflects the
nature of VM_EXEC readahead regardless of base page size, and
patch 2 generalises the gate so any mapping advertising a usefully
large maximum folio order can benefit.

I created a benchmark that mmaps a large executable file madvises it
as huge and calls RET-stub functions at PAGE_SIZE offsets across it.
"Cold" measures fault + readahead cost. "Random" first faults in all
pages with a sequential sweep (not measured), then measures time for
calling random offsets, isolating iTLB miss cost for scattered execution.

The benchmark results on Neoverse V2 (Grace), arm64 with 64K base pages,
512MB executable file on ext4, averaged over 3 runs:

  Phase      | Baseline     | Patched      | Improvement
  -----------|--------------|--------------|------------------
  Cold fault | 83.4 ms      | 41.3 ms      | 50% faster
  Random     | 76.0 ms      | 58.3 ms      | 23% faster

The patches are on top of mm-unstable from 28 May
(8a74e22643189e0ae339afc91110ddb4cab1941b) which include patch [1]
that make mmap_miss accounting symmetric for VM_SEQ_READ which was pointed
out by sashiko in the previous revision.

[1] https://lore.kernel.org/all/20260525145751.2671248-1-usama.arif@linux.dev/ 

Kiryl and Jan, I have kept your Reviewed-by tags from the previous revision
for patch 1 as the concept is still the same, please let me know if that
is not ok.

v5 -> v6: https://lore.kernel.org/all/20260522162422.3856502-1-usama.arif@linux.dev/
- Based on top of patch [1] (sashiko)
- Changes to commit message to make it more accurate for patch 1 and skip
  mmap_miss decrement as well. (sashiko)
- Keep old behaviour if large folio mappings is not enabled (sashiko).
- sashiko pointed to a TOCTOU data race that was pre-existing. My patch
  could make it worse. Dont make it worse by introducing thp_order local
  variable.

v3 -> v5: https://lore.kernel.org/all/20260402181326.3107102-1-usama.arif@linux.dev/
- (Looks like I messed up the versioning here and went directly form
  v3 to v5.)
- Drop patches for elf thp unmapped area alignment and deal with them
  separately. These patches will just bring folios smaller than PMD
  at the same level as PMD. The 2 patches now should be much easier
  to merge.
- Tackle size of THP for exec pages at the same point as PMD instead
  of tackling using exec_folio_order() (Ryan during LSFMM, Thanks!)

v2 -> v3: https://lore.kernel.org/all/20260320140315.979307-1-usama.arif@linux.dev/
- Take into account READ_ONLY_THP_FOR_FS for elf alignment by aligning
  to HPAGE_PMD_SIZE limited to 2M (Rui)
- Reviewed-by tags for patch 1 from Kiryl and Jan
- Remove preferred_exec_order() (Jan)
- Change ra->order to HPAGE_PMD_ORDER if vma_pages(vma) >= HPAGE_PMD_NR
  otherwise use exec_folio_order() with gfp &= ~__GFP_RECLAIM for
  do_sync_mmap_readahead().
- Change exec_folio_order() to return 2M (cont-pte size) for 64K base
  page size for arm64.
- remove bprm->file NULL check (Matthew)
- Change filp to file (Matthew)
- Improve checking of p_vaddr and p_vaddr (Rui and Matthew)

v1 -> v2: https://lore.kernel.org/all/20260310145406.3073394-1-usama.arif@linux.dev/
- disable mmap_miss logic for VM_EXEC (Jan Kara)
- Align in elf only when segment VA and file offset are already aligned (Rui)
- preferred_exec_order() for VM_EXEC sync mmap_readahead which takes into
  account zone high watermarks (as an approximation of memory pressure)
  (David, or atleast my approach to what David suggested in [1] :))
- Extend max alignment to mapping_max_folio_size() instead of
  exec_folio_order()
 
Usama Arif (2):
  mm: bypass mmap_miss heuristic for VM_EXEC readahead
  mm: use mapping_max_folio_order() for force_thp_readahead order

 mm/filemap.c | 41 ++++++++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 15 deletions(-)

-- 
2.52.0


