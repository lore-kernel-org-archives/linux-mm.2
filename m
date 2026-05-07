Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52626CD37AA
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63E2B6B00A3; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6180D6B00A6; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467B06B00A3; Thu,  7 May 2026 16:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FA056B00A3
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:59 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CE4AAA060B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:58 +0000 (UTC)
X-FDA: 84741747636.18.05EED07
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BAC174000D
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:56 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STjZxzXW;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185376;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PvnZs9wwsx3qlMWNHWmNDoExrmwUpfUNdiyB06mvzOE=;
	b=XDuqz4hm0vhNaLFj+Blu4cni+poxVP3efyuPll4jmCOPHN+6cmbRyS3kA9PN/AGOf8tSD0
	tW1tlK55Hwd6Kh9C1WeY7/8o873UNSXdTmXZLmFJ6i9QtDwSKqxz0Zk+EkbDzfnc2TWO7n
	0Awpi4v1jc8OI1nG3RSLyZt+qybt2mc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185376; a=rsa-sha256;
	cv=none;
	b=AKo4HGgbZ+I/Hs+ZEiNYLf00xP3tGPBxiLZdKkbqfUk7IEb2Ee2ZmI0PQOfTvLMSkyDdmN
	kBy23AANt1mOzA+h4Tl2pfgWN/fma+meIZIEriKHGS/s6D3i15Dozx6wr0wKyateUkd9jr
	R+2hPNoSmTY8lSmeRn772CoQG0TtsaY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=STjZxzXW;
	spf=pass (imf04.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 892314455D;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 64283C2BCC9;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185370;
	bh=r8wKNJEdooOeCA3S5K/H9KWL42If7lBpqyb7Ilu8Mcg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=STjZxzXWMiXs316akMQPJ73coNbhqKrykRU9J4guekVuvcr0dP54cMNTiK0OtkEE3
	 /iaFVnQtBhuHrg/5KwNFb3TVYpexS6SDA+6gnbFTrPtLHGfEpaiVZNSEGhgPS0Erh+
	 pyH1O1nGqaxdbdbvoJOPeAwWwyH8/YZ0ekAXnIsOKuqSs89rhlfMM3sWeBQeO9rUR4
	 /a6nD08ydeQrIjhDVHV5ZkDJERYIUvrQTT0FEQWaPlVdDT+rIYzkiGL6prqyosalq+
	 Ak5PxfUWuKEyZHObLXitS7hsi4aZUYknhWi1dwuGLyoxyBiTseEXrDhBSoBJV+rPQ0
	 WVLkwOsuy1SQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58DC1CD3446;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:34 -0700
Subject: [PATCH v6 15/43] KVM: guest_memfd: Handle lru_add fbatch refcounts
 during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-15-91ab5a8b19a4@google.com>
References: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
In-Reply-To: <20260507-gmem-inplace-conversion-v6-0-91ab5a8b19a4@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, liam@infradead.org, 
 Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2931;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=kyHfZ+B3SRw/wksZt++HyZ6ATcKspWiE/+jD/fdYN2M=;
 b=cQ9Jgy+WZlxi0pRUIUec609+6mHT+aRyKPHoQbOxCO1yz56Ikcjdc0yNsJ4xO9R6QnALQUkk+
 eptbvTh0LNvAFA7T0CkcjDIvvoCNSq159Pt02Gve8eBSIJficONyVwU
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BAC174000D
X-Stat-Signature: goymimkrz8e37txtwqhstubcbxnmb18q
X-Rspam-User: 
X-HE-Tag: 1778185376-661067
X-HE-Meta: U2FsdGVkX1+XCPx9g80XmUy59/9MWHb7mlrnTL0RdBoSnRg0SvoenJAySVsmYLQHc1IUZEf6f0QX+yoJ51boK59nYMpJfRahF2hP6GM1VHEBwxwYLxoYu0qFPpCNF1o6B39CGImgGpKd/3SXu5/9vCmGz2ph6BnST/oWppUvZWcNbStjfpF6y6uTE9mgOAvmiJ5bojabBvzOi6ZkptIbKoFrytLEUkqaJv/rWiFM5szrMhagheALjwrOgmHIMSrQ+b0xmN9MUDtK6Q0dGBC03HaLR7y2c1AZOq2knYvUYwomqA+qBO4DFUEAr4C/KjlUd2GXa3A2cBXfW7XaGuunHRBqId+6pB6hsFPF2WexBNLbCKVfLVj5j17sk9QrjwcncbrGBTWN2iloemSCzIovitpwpZSzwBgvUsI6/w7fKnkoBEh0MX2T4B/a38kfGfNBUfGEazuGAYvKFm7JhcXf4tWuZi78Fq2shgsm0QlkVIs2JlvDMa65TKLdrVXTWDlc1u8cIJzE9glwxTyf8fq8rWKuxmR29PWXJvFRVgpTS6yg5USjOB5eXoNtTkT8RxpUxrn1sI6lH4pq3gAYzzJhvVv1fuehsn398ZAlqlB2YZAnmCXbEk0Tb8QlMiF7tQZs+iZ7yl7+mFok0vuAfOz9jd0nHuDbZrwCaoSl0t4Zo68UxZzNdlIhgUizezU2CKWWvaEptK8CdGCk8jcrECiQI7FY/Gdc4O/7qFMIq/Ix+osB/SNAdq0eD09VnYwxunH2c5YxTzCrZBSgRB4k/XuLe9NxC+7tFm7F33Wl4Rr30WDFMokKNsXRmIKAX24RrP1FoO6hWzHqWOCcyzFC+Z9OzgNyg0AtwOVp0mA3CoxWwcl663bKquMUz50EDjrOVMplGpCX+II6AsiGTOMj33KI0pzS0ygtfk1/Tjnxr+/9LF4MBNuqv6bXrdTTK2ZD8SUu6qCyjoqHqlce2WzmPib
 Lu1jKANu
 Okg7WdgkW5jsGIPQALR3T56/utGa+QY2rZjrivcWkEv62p3MG7Pm20jF6Hr/VoDzL+Y+kwlMNf6++Bya0T1VL2fttNkumVd7EtxdfGpu1BnfuPOESUGjEoBV5dX1GSDv00F0o1uCMtTxxL2YZK3dtRoBSHwX2fZaAkFOBaDpZC8RUyahwqtXwAH2Hu50c5IDolvK9ma+wm8LMh/cXbW0XAgFT8IdgSKs/UN+vU0YjDZYkUJQZVZNBtcvCw3UypBY458HsDsNxYzZ1kbhMAiydUgCFB8pGpc0bxNGxcEvWncflnwl5To+pAHe8fmymWmR+1HKNx8FJ2lGg4r+x4C0Yj04qHlzgVnChaWlXRxsYHV4HZelVfOHkgCFxvugmFOPpRZgAG3evLknT78fGDCS21Tbq5tsJP4qDFyd+VtIfjEIwZTuPI6mjdhIWAzP5a03QMgErO58ZojAndksRdjh6CR3X+JMr5l04oq/zsGfa8Ck7R9621zzk/S5n1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When checking if a guest_memfd folio is safe for conversion, its refcount
is examined. A folio may be present in a per-CPU lru_add fbatch, which
temporarily increases its refcount. This can lead to a false positive,
incorrectly indicating that the folio is in use and preventing the
conversion, even if it is otherwise safe. The conversion process might not
be on the same CPU that holds the folio in its fbatch, making a simple
per-CPU check insufficient.

To address this, drain all CPUs' lru_add fbatches if an unexpectedly high
refcount is encountered during the safety check. This is performed at most
once per conversion request. Draining only if the folio in question may be
lru cached.

guest_memfd folios are unevictable, so they can only reside in the lru_add
fbatch. If the folio's refcount is still unsafe after draining, then the
conversion is truly deemed unsafe.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/swap.c              |  2 ++
 virt/kvm/guest_memfd.c | 18 ++++++++++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 5cc44f0de9877..3134d9d3d7c30 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 
@@ -904,6 +905,7 @@ void lru_add_drain_all(void)
 	lru_add_drain();
 }
 #endif /* CONFIG_SMP */
+EXPORT_SYMBOL_FOR_KVM(lru_add_drain_all);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 034b72b4947fb..050a8c092b1a3 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -596,18 +597,27 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
+	bool lru_drained = false;
 	bool safe = true;
 	int i;
 
 	folio_batch_init(&fbatch);
 	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
 
-		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+		for (i = 0; i < folio_batch_count(&fbatch);) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (folio_ref_count(folio) !=
-			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
-				safe = false;
+			safe = (folio_ref_count(folio) ==
+				folio_nr_pages(folio) +
+				filemap_get_folios_refcount);
+
+			if (safe) {
+				++i;
+			} else if (folio_may_be_lru_cached(folio) &&
+				   !lru_drained) {
+				lru_add_drain_all();
+				lru_drained = true;
+			} else {
 				*err_index = folio->index;
 				break;
 			}

-- 
2.54.0.563.g4f69b47b94-goog



