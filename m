Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4C2FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6C56B008C; Mon, 27 Apr 2026 06:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67BE6B0092; Mon, 27 Apr 2026 06:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7E366B0093; Mon, 27 Apr 2026 06:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B700C6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:22:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68C26C0249
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:22:56 +0000 (UTC)
X-FDA: 84703947552.23.11A84BF
Received: from out203-205-221-245.mail.qq.com (out203-205-221-245.mail.qq.com [203.205.221.245])
	by imf06.hostedemail.com (Postfix) with ESMTP id B44D1180011
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:22:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w9JexJFQ;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777285374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoxJLcqVNjU6TsY+bAss1gfZHTlNWB2CFO4nNazgUic=;
	b=hiQkanIV9COCDc8Au4LnNU/CF58ZNbhQITKg7JHUIctqjgUS17sEdBVRsrVm/ly0Dzd47j
	MtRxcARxuZlb8Xqcwy+VpEHmFGvUQgH7yTBFSc/o0OHuaX3mU2hNwNXQaRKxUW60/PanSd
	S93nCyOb/wLLXLEK8K2RmGgFqhJ8zmI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=w9JexJFQ;
	spf=pass (imf06.hostedemail.com: domain of fujunjie1@qq.com designates 203.205.221.245 as permitted sender) smtp.mailfrom=fujunjie1@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777285374; a=rsa-sha256;
	cv=none;
	b=f893g2qsyKc5OTUyyNps6u1OgIcL5lfP5LZvEHVOnjuV1JGlH7BCka7ZXMgqy1yQLiroRR
	3c/zBOgH6OAOq44XAkeOBfqR56RmvZwhx+H+CCevXj3YP8gsgKhVf+UpYGCCLTXdszF4TH
	k/H2FPzgmHOVahtdpm9ERdLtWgHdTyk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777285369; bh=aoxJLcqVNjU6TsY+bAss1gfZHTlNWB2CFO4nNazgUic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9JexJFQXXiYqd6RXM1ttSlVzK9p127ucYQfeJO9xlGaMTWTf8l9ab9qcRI3Mwj2m
	 15Y9+gJteEjqMRd18+2mTIEqcA3qVRGqCBnzCdV0mxGYV4MsmJSKHAdQEpu8sNEUik
	 mxDM2c7jgtnS2Epwd+/cx6vTL/YV9bxwX/kfl0Cc=
Received: from node68.. ([166.111.236.25])
	by newxmesmtplogicsvrsza63-0.qq.com (NewEsmtp) with SMTP
	id 5AC362AB; Mon, 27 Apr 2026 18:22:44 +0800
X-QQ-mid: xmsmtpt1777285366tpspfn6ak
Message-ID: <tencent_3F158B17AE85E73945C5F97D8F8A918F9B07@qq.com>
X-QQ-XMAILINFO: MDbayGdXPuoetEbV4RYs2SZLJQmVfx8PY6yub6ed+idrQkmcDP4FBdYcmzsLMc
	 NCq3vqbQ906HVQ1T8yI4ZdW25dvJzx8fKrgcCLEPENvf68TDun9CvHRRPNlb6mAsaAhAyahN21bF
	 WwVQARB+3n+oatD8/w+e5ch64PiHUyfY8d5FVrSMiROPAnAsbzg7hpkAczNg1O0EsHXHfcmxPoCP
	 p5Ts71LNRV+paE7GAtVNHzZKvCAemS0858QIQXsn6fTPHMEglHt3eUz6HGeOCDowPuIDnwi0S14Q
	 ASBtNOBLu93riHvjQw6c6gNubTesHc/p3euKP/3mGxhC2L/6zW6v4BHVwHNc1UbtAVGKY1MLpxNE
	 gHGlmQUUwR/PQd2MvrO8R+6J30z/65jDC3gdeUTxT0RxgF7XclkE4+iiRia8svjSeiLzl6uL2YD3
	 I13Sbgr9JHyBVwb7C5qcRWPrcyomxKqC8NZnRRFrl/DIEDHEQSIZ+AypqPdQ5gt4Ymu4GbcNBeja
	 /5BAaosEqLKiso1MIDxlJ5s+Y6h5XAbc6qTl+g7DtvNTM8kwy6IgDC1+qWdeB4zoVOQiJd94Ofy5
	 xJQqbPc3sAxkORE5fgabiMk+7Gb3uDc4QQgJnupvr0wT/FcE+rE5DsaGz44U84pieE34VUWO187X
	 n/Jog4QQEKAzWFl0KiRUMd6YTsu2LYCMEfLkw3p36slWM6yo9ux/WIwNikmVSz3KSXFpESntsSfz
	 tGGhM/JanKpDBMRFu4qilWc1pwa10aM0pQ83o/8pMB8MhQPtVLTMSS/gNNzYkgFMJkOR55misKk8
	 2O6d6pnk/VqmKgv/cSUDOaFHBnDv749LZZze4VoTFtkYDJHXnyRtuVXvyFL7Vp40a7+qwPPA/Efr
	 gf/1YgzyfWdfReZ5BHYamwhJQOu3fJWGE/b/E5GaWtB5qEInifdlpU/nSF+LQ8Qfjy0bfSWVMgX+
	 a3e+Z3+5eBUqdZzV3NMXfWAb+GGJsE+aoZ7xY0oeUsE29dUnVETE4Rg1ZEvTOBBiKv0cmr/R8Qph
	 DxS3WVnagP4MPI3sdcbI56lB3mmfZ1wLXCkGk7pQ==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
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
Subject: [RFC PATCH 1/1] mm/filemap: tighten mmap_miss hit accounting
Date: Mon, 27 Apr 2026 10:22:43 +0000
X-OQ-MSGID: <20260427102243.3519326-2-fujunjie1@qq.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260427102243.3519326-1-fujunjie1@qq.com>
References: <20260427102243.3519326-1-fujunjie1@qq.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B44D1180011
X-Stat-Signature: wsczz6fqnt177y6knbgmpkqfk4n9wq91
X-HE-Tag: 1777285373-891759
X-HE-Meta: U2FsdGVkX1/36j4S3igrPbH/RQbXQ8CWCDnt76H74PhFrF+RyaIyso4xejQngAYMWizm9cuIgwy7WTYbmO+H583hSQK62ub6rc0H0b0e7YxobuAqQLy1oQFMGnVuDKO4CjTpFR0s+NylYuIDn40/pGa3Rd/aHdsIEl7UoZZfX19HPP5DmAGreJW9J+Exm/XRjvpHoJF1IJSL1yTsSPGLbym7RQWUcoCVCpYbYTLzwtXuI+PH7bGuF0bXFe0MhVvaSDc9z7ijEATfytf9KYx+dB9hFJAvACiTuv8at2QM8R+LspN+PRTy3D3mQm29sMHM2jDQivwp5ZWiLNOJw33X/J4uXdRY3mYmx3Cy5Z089qyoMYE0RZBueWybQYnTcy1tn5waY6uxIYzheSMpgLA0xWJMkltSp8YMR9T9HtkZsIA0WJfbVWXVpLkGEY2neaaovHy/s93wJHaWkz3qp6L8bKH9puHF3hzzbLMc9GT7Ukv3ddLPhM4ioZmFntrzTCeXSuuzT5CLgQNh5CHuriG/bNUaj5VFXYrPLrPCJWXcntpjbxYmemO/eKrdb19ZLzSBqmUJNk7EpIoTuLHHuhKAKdBY7mOT07ay/ysWBasDSDNNOnWlAuTX+nvDF6833twfv9tmmfeumJQlvd3Ek8pA4x9D7i3JV+CQUy72xgw3458erBwdEs+3LiITLZtg/mFmSvrKlXTnZzHljKA1J8tO/Es+9EWi2R4JgT9txOZAxV4rGBmu9mjxpwmO7iuD1GFOOnnc74meiCBZ58ApNG+KG3BvqibAsXtdvqhSWu3AjiewARS50SXUfsu5OlJJDVoPv1BDzkoYltItWvNh5WQWK4EsN4DQK7SnLYeMxMie62EGJZYAqbKXte+JSoOmIkl4FAVw2Yb1jtd6V7THoyhDp2furKT14jJI8Dg0fYnJVjEK7rmhHssu5aRChTeYoNbldnGvA+NA2krXeQJBz9i
 R99OPIco
 pm+Jo8sfvNV3Wn0lWpGmQnV5lqjIzJ3aHyewrZnMd33LweBTuULtwKXfDLuvs3fGBiLb3lbPT8wbpiUUeQcg0Pqu9+mu0TB6O3xn6+yIVqO4j8tY+asimxWHJX24w0EcLisNqx4bh8oy2fxRe3dTZgBUjR4NP7zu+pntuDB/uGpSoeRa9JCVoP7299dK2QQ9drnSJTDxNeBFVw/wntk2SU6gra0xSbuvaoLhkKUSKLojSwmmYiVnfixTrQwHZI8aoiYmCQpioaBQv+azfSNXoKck6iBWHq3PVANv06SPZ5Nz3gb0FQxvH3Ffaqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

file->f_ra.mmap_miss is used to stop mmap readahead after repeated
misses.  filemap_fault() increases it when synchronous mmap readahead is
needed, while filemap_map_pages() reduces it when fault-around finds
folios already present in the page cache.

The hit side of that accounting is too generous in two cases.

First, fault-around can install PTEs for multiple pages around the
faulting address.  The fault only proves that the faulting address was
accessed, not that the nearby PTEs will be used by the workload.
Crediting all of those nearby PTEs as mmap hits can make sparse random
access look like successful mmap readahead and keep mmap readahead
enabled for longer than intended.

Second, a fault that misses in the page cache can start synchronous mmap
readahead, drop the mmap_lock, and return VM_FAULT_RETRY.  The retry may
then find the folio that this same fault pulled into the page cache.  If
filemap_map_pages() credits that retry as a hit, the same miss can
immediately cancel its own mmap_miss increase.

Only credit one mmap hit when filemap_map_pages() actually maps the
faulting address.  Also skip the credit on FAULT_FLAG_TRIED retries.
Keep the existing workingset behavior: recently refaulted folios still
do not reduce mmap_miss.

Current evidence comes from a local KVM/data-disk microbenchmark using
mmap_miss_probe.  In an 8 GiB guest with 2 vCPUs, a 20 GiB file,
8192 KiB read_ahead_kb, cold page cache before each run, and 1% of the
file accessed, the median of 3 runs changed as follows.  This is file
cache capacity pressure from the file being larger than guest memory; no
separate memory hog was used.

mmap_miss_probe is a small userspace benchmark used only for these
measurements.  It mmap()s a prepared file with MADV_NORMAL and then
touches one byte at selected base-page offsets; the access order is
random, sequential, or a fixed page stride.  The harness drops caches
before each run and samples /proc/vmstat around that access loop.

Each case used a fresh temporary qcow2 data disk, seen by the guest as
/dev/vda, formatted as ext4 and mounted at /mnt/mmap-matrix.

Each before/after entry is "pgpgin GiB / elapsed seconds".  "pgpgin GiB"
is the delta of the guest /proc/vmstat pgpgin counter, converted from
KiB to GiB; I use it as an approximate block input counter, not as
resident memory or exact application IO.  "Elapsed seconds" is the
wall-clock runtime of the whole mmap_miss_probe access pass, not
per-access latency.

        workload       before              after
        random         223.377 GiB/101.293s 1.010 GiB/4.790s
        stride1021     204.214 GiB/97.557s 204.208 GiB/108.086s
        stride2053     409.584 GiB/193.700s 0.970 GiB/3.685s
        stride4099     406.452 GiB/134.241s 0.975 GiB/3.499s
        sequential       0.212 GiB/0.050s   0.212 GiB/0.057s

The same 8 GiB guest with a 4 GiB file, so the file fits in memory,
showed the same direction for sparse random access without file-cache
reclaim pressure:

        workload       before             after
        random         3.987 GiB/1.960s   0.980 GiB/1.221s
        stride1021     4.002 GiB/1.838s   4.002 GiB/1.851s
        stride2053     3.991 GiB/1.835s   0.811 GiB/0.985s
        stride4099     4.001 GiB/1.836s   0.819 GiB/1.037s
        sequential     0.056 GiB/0.013s   0.056 GiB/0.018s

This RFC does not claim to solve every sparse pattern.  In particular,
the stride1021 rows above are intentionally included: the 20 GiB run is
still about 204 GiB of pgpgin.

In the table, strideN means that the benchmark advances by N base pages
between mmap loads.  Thus stride1021 is 1021 * 4 KiB = 4084 KiB.  With
8192 KiB read_ahead_kb, file->f_ra.ra_pages is 2048 base pages, and
synchronous mmap read-around uses a 2048-page window centered around the
fault, i.e. roughly [index - 1024, index + 1023].  A stride1021 access
therefore lands inside the previous read-around window.  About every
other access can be a real faulting-address page-cache hit, and the
other half can each read about 8 MiB.  For about 52k accesses in the
20 GiB/1% run, half of them times 8 MiB is about 205 GiB, which matches
the observed 204 GiB.  This first version keeps the scope intentionally
limited to mmap_miss hit accounting.

Signed-off-by: fujunjie <fujunjie1@qq.com>
---
 mm/filemap.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c1..463cd19c49f09 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3757,6 +3757,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 	unsigned int count = 0;
 	pte_t *old_ptep = vmf->pte;
 	unsigned long addr0;
+	bool fault_mapped = false;
 
 	/*
 	 * Map the large folio fully where possible:
@@ -3780,16 +3781,6 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		if (PageHWPoison(page + count))
 			goto skip;
 
-		/*
-		 * If there are too many folios that are recently evicted
-		 * in a file, they will probably continue to be evicted.
-		 * In such situation, read-ahead is only a waste of IO.
-		 * Don't decrease mmap_miss in this scenario to make sure
-		 * we can stop read-ahead.
-		 */
-		if (!folio_test_workingset(folio))
-			(*mmap_miss)++;
-
 		/*
 		 * NOTE: If there're PTE markers, we'll leave them to be
 		 * handled in the specific fault path, and it'll prohibit the
@@ -3806,8 +3797,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 			*rss += count;
 			folio_ref_add(folio, count - ref_from_caller);
 			ref_from_caller = 0;
-			if (in_range(vmf->address, addr, count * PAGE_SIZE))
+			if (in_range(vmf->address, addr, count * PAGE_SIZE)) {
 				ret = VM_FAULT_NOPAGE;
+				fault_mapped = true;
+			}
 		}
 
 		count++;
@@ -3822,8 +3815,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		*rss += count;
 		folio_ref_add(folio, count - ref_from_caller);
 		ref_from_caller = 0;
-		if (in_range(vmf->address, addr, count * PAGE_SIZE))
+		if (in_range(vmf->address, addr, count * PAGE_SIZE)) {
 			ret = VM_FAULT_NOPAGE;
+			fault_mapped = true;
+		}
 	}
 
 	vmf->pte = old_ptep;
@@ -3831,6 +3826,10 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
 		/* Locked folios cannot get truncated. */
 		folio_ref_dec(folio);
 
+	if (fault_mapped && !(vmf->flags & FAULT_FLAG_TRIED) &&
+	    !folio_test_workingset(folio))
+		(*mmap_miss)++;
+
 	return ret;
 }
 
@@ -3844,10 +3843,6 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	if (PageHWPoison(page))
 		goto out;
 
-	/* See comment of filemap_map_folio_range() */
-	if (!folio_test_workingset(folio))
-		(*mmap_miss)++;
-
 	/*
 	 * NOTE: If there're PTE markers, we'll leave them to be
 	 * handled in the specific fault path, and it'll prohibit
@@ -3856,8 +3851,12 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 	if (!pte_none(ptep_get(vmf->pte)))
 		goto out;
 
-	if (vmf->address == addr)
+	if (vmf->address == addr) {
 		ret = VM_FAULT_NOPAGE;
+		if (!(vmf->flags & FAULT_FLAG_TRIED) &&
+		    !folio_test_workingset(folio))
+			(*mmap_miss)++;
+	}
 
 	set_pte_range(vmf, folio, page, 1, addr);
 	(*rss)++;
-- 
2.34.1


