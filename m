Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF58FF887E
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 18:20:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37F8E6B0096; Wed, 29 Apr 2026 14:20:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32F2A6B0099; Wed, 29 Apr 2026 14:20:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F4E6B0096; Wed, 29 Apr 2026 14:20:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 092CA6B0096
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 14:20:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C2AC1C18F0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:09 +0000 (UTC)
X-FDA: 84712407738.14.2497C63
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf04.hostedemail.com (Postfix) with ESMTP id B073E40014
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:20:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YY35+aAW;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777486807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=DgyToDdGufnhk+nx4VlfwzSbCFd0Nu3YSR4+1kgnh+8=;
	b=ryUSakjskdZSsvP9O8ZSQcDHoopueh5sk1zWRLokES4WWnx5gWYjdXCrN7ERAIJ0RJZGde
	a5CnMJ2R15s4hRJTe+UYLyLZ7b69T4yI2yZGrOo2NuKL0PYF/eGKku2otrxkRp2YPgWMo9
	uCIp3wlkCE2kOkUmMEZH8+5E8l6PYzM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=YY35+aAW;
	spf=pass (imf04.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.8 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777486807; a=rsa-sha256;
	cv=none;
	b=2LPUmZnKYlGMFK0cFgn1yrLrKkojYDWUibFluA0TD9gjS1T4DrKt18rk2+RdwW01Zt1Sca
	m6n/b9n6HXrYPfajagnGSqCtB9YljusYhiybzODmnzG+EeC39YVUiABty8zKmp21imDGFK
	Z07Svs2fZlhMhet4pebXy9VgfOIGoZI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777486808; x=1809022808;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=+GTbivOW+M0MfDpe1qWwwf3hHWabdB0SE6jBLZ6CPSM=;
  b=YY35+aAWhYzNbEYDry5UXZcBGk2too6hdiBYg6FKTIH5kbw+HCKvAJ8P
   76iqRyaYgKoLzQ8jnKH65asbW2p+Rz0ICi1y1vWOlFp2U+WX9VQsHaRzh
   NWXrfPdS48XVYWjLLsJDJp7Sdmvz1bcC7u3YxD0xgdELoPGPe0ccW35E8
   ZlPLCEACP4D7C0sM3WMlKhjcNgoxyjUuboNY8u4qFiukoOsiJvo0mG40S
   WhXvWk9iGerFKuEoMxzU0Ex1lj4AOskVs2i/UXAv7oivCjJbQAV/WJceK
   vQHVzUc1VBQdnvUAi41eijfUtIqmNX4McXO37nR/1d2vKkrWVhK7Op0SZ
   A==;
X-CSE-ConnectionGUID: azon1W6FRRKAJBB3DnP/Mg==
X-CSE-MsgGUID: zPK00Q78S969aXNwAeTQyQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="95990136"
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="95990136"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Apr 2026 11:20:06 -0700
X-CSE-ConnectionGUID: /QEVPuNTTE6LY2Xy0HqMUw==
X-CSE-MsgGUID: /5JWNQ8AQzSyc14sr4YyRg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,206,1770624000"; 
   d="scan'208";a="239336441"
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa005.fm.intel.com with ESMTP; 29 Apr 2026 11:20:03 -0700
Subject: [PATCH 5/6] tcp: Remove mmap_lock fallback path
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 29 Apr 2026 11:20:02 -0700
References: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
In-Reply-To: <20260429181954.F50224AE@davehans-spike.ostc.intel.com>
Message-Id: <20260429182002.BB61C7BC@davehans-spike.ostc.intel.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B073E40014
X-Rspam-User: 
X-Stat-Signature: aygs5m9arsraucmerdyfmioxf7334yfr
X-HE-Tag: 1777486807-423587
X-HE-Meta: U2FsdGVkX1/PRzgBbfCO9pCPGrl/A+ylhPa4kdxLJz9E+AWcCut/DA6eAJRkPHZA0edMrGWC5GUrh5s6s53LeqhyoUq0bXKs81SLB8Wh3QisUc+lSRrXRZqpcLIPtc7gKLCMDjGHpRHrP3RmfgfjxHU9j8mLXWSg1556voiKPTpLTcfUNz2I3KrR9D7063acaHTu7SC7ZqiCuMf977jXKsKjzIMOw1U8DOZs3wlEV/oGD79z1VOK59pRf/xd/Du/M0Er1efNnsqz+3vCMQ7HRp8DLrKVcvAruV/Ad5hkPVT0iu2H6n8ZDW3MVX8QuWykuTxYpaNVZwG9RFuwFRvkbxO6uutwJhR9RogLGSnBOnHXL+m3bSin7TDra7OJtcucJORo+gZlM4FzkCEutJE2qjll7+FHE0TuQbIYhxu/1Xmq9kUcG+hfLpGK3PVxTT3UbjaRrm/aDoUluBgzTgCwj+ScONH2der+PVofY1oA2Go4hMULan/pSKZH2jRDXTtS8eTPXgHz/KmHmfu+lYmET0vaV9FagnZ53C1GY0hr6AsrWf2zwgfPd+tZ+Qry1rSHdaXBz99sM9YiipldYjud1Zivz9wjHFFmhmDVEh+F7nsw0YErx4NoLeQUTDVbRHf7NOcJfYJW7VvHunoRtlUQxjWH8HIXyz9za7xtGIHyNZbFv+WfaK0ih/PbD3CW6i8lxjUm7Ku1z0gQAD7Kw6Asuo5xoaGCAJgLlzWjs2wsPIAlD3aV5CN+6gp7WmTKm9w59bO9uCdUjfa02KwL+ZM8Uo4VIZ/vs9te8+Z1IQ9sd6/5c8hmigSas2SWWOtJ39/uTl8t89TyBsVS42ezkI09W1qynvQezyGzhMwOsRTU2T2rQuHFn2TCss8Dg+/UIrQ4P9b7+H5PC4Nj+urCpK2hmoj7KubI7hiq0BPqkXvG9qDOwxWYYcE8srTMgCaJbf09WkNCtbdxxcmqobLOMbG
 xGaR+dOY
 N/ETz3M8wwIqraPOOlVoMT2xltVPegp4Ny2rrrfxtP8WnVrQuso1QuO4R4YSPWHpsnRvzoXnMcr1+jmYCPnEn6bShdUaob88FHTeHWd5ovW2dFaxTsBPPPKybNEOGZPSV/HmXzNaiahmbjI8UkJm7c4OhsTKjxPfL2ZZt4Z0thXxHGuHWZhESakWK2rCjVHGtLcYeyjgqdirc6QhznKBqtDDXdP5vjcLh+W18h4oVCX2/7WEtHVSBDhEHCkN1AS4Ouh1IU62LvRUEHDISfLJGKspona8dG6/4xutaREqL7ftARBrE6E2SmzNGM69ExLMwv+ehpuCUQrQlQJAndNrd42XWE5xlj3mvc0uhkk+4uNsCrxyDh8nwqL7PIbTr8zEbwakisKdx7n3t5eQ4TPr54RZRptzj129dCzGe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitates a fallback to mmap_lock. The new
lock_vma_under_rcu_wait() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

This really is a nice cleanup. It removes the need to pass the lock
state back and forth to find_tcp_vma().

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
---

 b/net/ipv4/tcp.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN net/ipv4/tcp.c~ipv4-tcp-vma-waiter net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~ipv4-tcp-vma-waiter	2026-04-29 11:18:51.870676498 -0700
+++ b/net/ipv4/tcp.c	2026-04-29 11:18:51.874676652 -0700
@@ -2171,27 +2171,18 @@ static void tcp_zc_finalize_rx_tstamp(st
 }
 
 static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
-					   unsigned long address,
-					   bool *mmap_locked)
+					   unsigned long address)
 {
-	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
+	struct vm_area_struct *vma = lock_vma_under_rcu_wait(mm, address);
 
-	if (vma) {
-		if (vma->vm_ops != &tcp_vm_ops) {
-			vma_end_read(vma);
-			return NULL;
-		}
-		*mmap_locked = false;
-		return vma;
-	}
+	if (!vma)
+		return NULL;
 
-	mmap_read_lock(mm);
-	vma = vma_lookup(mm, address);
-	if (!vma || vma->vm_ops != &tcp_vm_ops) {
-		mmap_read_unlock(mm);
+	if (vma->vm_ops != &tcp_vm_ops) {
+		vma_end_read(vma);
 		return NULL;
 	}
-	*mmap_locked = true;
+
 	return vma;
 }
 
@@ -2212,7 +2203,6 @@ static int tcp_zerocopy_receive(struct s
 	u32 seq = tp->copied_seq;
 	u32 total_bytes_to_map;
 	int inq = tcp_inq(sk);
-	bool mmap_locked;
 	int ret;
 
 	zc->copybuf_len = 0;
@@ -2237,7 +2227,7 @@ static int tcp_zerocopy_receive(struct s
 		return 0;
 	}
 
-	vma = find_tcp_vma(current->mm, address, &mmap_locked);
+	vma = find_tcp_vma(current->mm, address);
 	if (!vma)
 		return -EINVAL;
 
@@ -2319,10 +2309,7 @@ static int tcp_zerocopy_receive(struct s
 						   zc, total_bytes_to_map);
 	}
 out:
-	if (mmap_locked)
-		mmap_read_unlock(current->mm);
-	else
-		vma_end_read(vma);
+	vma_end_read(vma);
 	/* Try to copy straggler data. */
 	if (!ret)
 		copylen = tcp_zc_handle_leftover(zc, sk, skb, &seq, copybuf_len, tss);
_

