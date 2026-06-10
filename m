Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A7A6CD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 23:04:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B3ED6B0096; Wed, 10 Jun 2026 19:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365A16B0099; Wed, 10 Jun 2026 19:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BB5B6B0096; Wed, 10 Jun 2026 19:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F29026B0096
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 19:04:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BCEBA1C2968
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:23 +0000 (UTC)
X-FDA: 84865533606.28.90805CA
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9E39010000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:04:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DTrizq6c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781132662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=gpyZZZNLSZtHqNbC+Nlr1PHoMfO4w5yV3od/4+bHqEA=;
	b=EPiAo3+WJPV+XGggtMl5mWwc/dRnwzQ//wJkH9MNilF2rgjOpVxPHEbVx2cVdNGpsuMViO
	i8SA0YNSDTYFZL7jUjrvVeZF+l3WiRpusB8WuGlJ6BPMBSXYJuJ/R599UAw6rUoSwhgAnj
	VDrdZRQJQawCrA5mqpBUCqTbbe9MByA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DTrizq6c;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf14.hostedemail.com: domain of dave.hansen@linux.intel.com designates 192.198.163.18 as permitted sender) smtp.mailfrom=dave.hansen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781132662;
	b=rMtFiIf8G0DBgKvPH/9oT229Kt1hAB/CAb20pNh6AT6tvpnVboxL9xtdldQJxQZiLSwDsT
	KtYS6MBpfSIC9Aehi/XyIMBP+/NR/68fi0AS/VKpgG8JEwlTTPdigSUs6KFRUBtoelrcl2
	h+2kEiON/5nZKsLMHO4GOy64WPD0lXg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1781132662; x=1812668662;
  h=subject:to:cc:from:date:references:in-reply-to:
   message-id;
  bh=19BDK6BwhTcrHnLv8z8OKRfT+e/osIT4EuXdhKNAOnI=;
  b=DTrizq6cgA5B4M4YmDgPqKZsAuc7tKjqgrvuOshbDiBJeCYBqYRE3H73
   X9jGQ0tDqoazC+ddGLztrEsTfFFlKAra62qz4VWaJj3MvB5MVTHrQnu3A
   2V5TzHq6j8bOrbaNXJE+/HViQOFnNv56xMkvs8tXFfcH9MZqeSz039hj1
   U00Mf9jNTzN7u3HFFl70fitMutHBush71V0H6W5bmbmUZPbrwuW77hSk7
   19XpoNm6b5csONAomYpq5DVIkAQa2fEDyKbdWD12JloC7XF/asNhRXrp7
   MhxdhtGMn7Q8ubghH6fnt2KdFdlXbJ5H5vaqhm8fDqpwUmNiO0bRuHXlL
   A==;
X-CSE-ConnectionGUID: I+X3XT9CSVyx6wUhEXI4tw==
X-CSE-MsgGUID: qEkxALMnTY2SF2d1Vl2vkA==
X-IronPort-AV: E=McAfee;i="6800,10657,11813"; a="81074131"
X-IronPort-AV: E=Sophos;i="6.24,197,1774335600"; 
   d="scan'208";a="81074131"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jun 2026 16:04:20 -0700
X-CSE-ConnectionGUID: aXawu264TMWGTsm2tch8Qw==
X-CSE-MsgGUID: m2ctBtL5SS6Rmntdy+Cwzg==
X-ExtLoop1: 1
Received: from davehans-spike.ostc.intel.com (HELO localhost.localdomain) ([10.165.164.11])
  by fmviesa003.fm.intel.com with ESMTP; 10 Jun 2026 16:04:19 -0700
Subject: [PATCH v2 5/5] tcp: Remove mmap_lock fallback path
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Alice Ryhl <aliceryhl@google.com>, Andrew Morton <akpm@linux-foundation.org>, Arve Hjønnevåg <arve@android.com>, Carlos Llamas <cmllamas@google.com>, Christian Brauner <christian@brauner.io>, David Ahern <dsahern@kernel.org>, "David S. Miller" <davem@davemloft.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>, netdev@vger.kernel.org, Shakeel Butt <shakeel.butt@linux.dev>, Suren Baghdasaryan <surenb@google.com>, Todd Kjos <tkjos@android.com>, Vlastimil Babka <vbabka@kernel.org>
From: Dave Hansen <dave.hansen@linux.intel.com>
Date: Wed, 10 Jun 2026 16:04:19 -0700
References: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
In-Reply-To: <20260610230409.A44D29FA@davehans-spike.ostc.intel.com>
Message-Id: <20260610230419.F746395F@davehans-spike.ostc.intel.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9E39010000A
X-Stat-Signature: 4x7emxmaiw559fnqtfg9wcznj3pzde8w
X-HE-Tag: 1781132661-951044
X-HE-Meta: U2FsdGVkX1+q5Bbh+c5No+j4Z3jG7FtwrKLrNHdns520wv6rWC6seT8MU/jleoQ15LvxAlU7OlT7Cf0Jt1OEHF54j6K9Q00SiZkS3TmQWUopv5GUsn/qUDb6gSHK2YbT2BP0TBvoSOGFskEyWoqs7zmWiGdtEHKcnRo36YDdZYpd7xQ3pC+eW2qS6aBGnrLnQCqfhmIVHZrm8vK+ON/8Pu3pLxTTiB0AiVG9+cIlbUd8i86nB/6tcE3X2snFL5lRud2pq3kk4ktMb2EPTEHUAV8cKGWrX2D9NJds5ZltH+1jftGVGYhL6ZoLyGbKbV7Gpq5feiJFZB+XkQEvN2JL2skXN24CEWQfUKIECNpI1gEq+KvmAMp28Ppf1YI60Ldj87+Fpu0Kao8UCRINyhUTNc5JDWpO3JOytxnBP6XcBIv5ohdoNA1Nowhv5704VmypUh6UZqRc/2boQWRjbiWu4F7uliMV9YNSiTaOR+j5jk939zFEqmzFPIJVpXpjQmaUadClRFZSyI5/kEsleW26UTYstvzpP6KoiC6Wc6MoZoAEnRzuRGqudEqCmUZPDpz+v4VaFZEc5DxlJ6zViUDfgiOIXXOcRdRAhfnhBwjTI3tEfTos6fTgOZFvmDarB7M0qBGX7EOe5XCAbVfTJGwXU47imF83YXWf8whQm4CznWUF+SHtMcBaNg7TRdWdCGZxSikXyFEB/t0IjNdW42bmcLwD697kSqPS2bu8WdsTlN0L9TJLUgYIeg0JoOjwFVnbRqLOpu2SUIkK4fz1zN+IPa2ikG5tpWvyhnjrx80VlZchcrY26sPHsoEUwKg2WHke1SH1NCLrVLzNmUu53vcLIHrgRZCPUqqshvtKq7QQYlH4L0MyZ5k1etW7a337BM83d4jqnnxegv1jXrh4AD38BN5pNAoy3sPYHuvCrmHxqwMBlNXqV8fku9STweMt2GWo0PhrZTbEgNcsuZpjV6P
 8z9sSc23
 D2s4rM/sh08O0l/1uNZT/HtKToi7/E/uH5poc37OV1qUbBRWSy5KMb1fjKHRUfo2lJujKOaZDdSHj8PWB8BIjKmFe/QN6nB9UnTd/eGNytIvWJRQ+k+lQMLfDcbWBmMmN57hNjM/CkYgIxPjTCiPg1o25bKmkglCZjTFmhV4HEOh0D9UhVGMyaTmVvWaZqr148b41pB3GL9faptVTVgO3IZ1gOb1lQ9gHVSFEekPgvPyykhey6olGyBet1U693UkqsfiCO4JfTkUDblkzI954dnldxLUSiCneIu3/w1VtjTbiaVd8wUiXKZQFyrruoLB/uKidZkS9wjEsX3RY1EBEVkSnG1LSXSNAU6Jk+3IobD7ESkRzsmT69XmMOlsMZaCY86vv4q2DaYvd5oaiVnbXhNToZ5TyKL2XPStMPXCnRyjqA/GoQENELJ3aZEO5apLpsln2/xWD/AmDegNUHCOO/lJkd/VbTE0MFrfH463642cSnd0efJRBhG9XucOEPQFNcQLxYiby6kaXUWzq89Iy4CpLTBTik3gEvsvwO/gkiN3v2O6JlTP/CAJLlOg1Ilrr4pKnT9zHRh7AzqndQ2l2Us7TdMvvc7hmkG1CdFu2FL9jH/xgLOFIxS1Vsy0oXkNP8xErGV2a1DHAKhYbR/lGViy+wkBv4KUaPPTP7XIOd7JWjwnm17erCXFuuyaY9KOK/JkQzYF1OKc22JM=
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
Acked-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
---

 b/net/ipv4/tcp.c |   31 +++++++++----------------------
 1 file changed, 9 insertions(+), 22 deletions(-)

diff -puN net/ipv4/tcp.c~ipv4-tcp-vma-waiter net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~ipv4-tcp-vma-waiter	2026-06-10 15:57:56.972472379 -0700
+++ b/net/ipv4/tcp.c	2026-06-10 15:57:56.976472521 -0700
@@ -2171,27 +2171,18 @@ static void tcp_zc_finalize_rx_tstamp(st
 }
 
 static struct vm_area_struct *find_tcp_vma(struct mm_struct *mm,
-					   unsigned long address,
-					   bool *mmap_locked)
+					   unsigned long address)
 {
-	struct vm_area_struct *vma = lock_vma_under_rcu(mm, address);
+	struct vm_area_struct *vma = vma_start_read_unlocked(mm, address);
 
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

