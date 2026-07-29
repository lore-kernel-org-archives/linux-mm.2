Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13839C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 566F26B0093; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53D0F6B009E; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20C556B00A0; Tue, 28 Jul 2026 20:35:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E078B6B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:35:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 815F21A05A4
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:12 +0000 (UTC)
X-FDA: 85039944864.17.C6BA29C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id A083A100007
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:35:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ol292dno;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785285310;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rpVOYMvIYVRqGvwMTwPaUnyuTTM0mfyxiPJtZmSaRGE=;
	b=GNuWQBH91ugdOfTXozNkEvZf+Wzre/SXf27/ghf7KlY+bX23+uFgTOyTUn2DBLD2vwfIul
	q4oD1rLurlNnSwQRSO/Z4S2PNCJSCaO92US1dlITGxn5RaTTcCeHibZHdS9f89df1ypwMB
	t7YekzqVIwHQ/JgR+bz1dfyWo9Ka9gw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ol292dno;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785285310;
	b=jbWiRnZP7oIeMBM4fWVTXPoIq89sRCjE5z3zAweTED3hHgMFMDN0MRso3+PO8giab9kMX0
	EOfws0CvQfyQo3JFC5e5tTizsAqoeaS8sbfBioXFnnooGigjKJPy3Jaxb7M9BLyK0UgC+8
	OJnvHaPYoEedk9rx9uugmWyg6BIRvYQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9A49860DBF;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F84CC4AF0F;
	Wed, 29 Jul 2026 00:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1785285309;
	bh=y9s8lGEG7811uVLgjbEHjBppzW1/vDu3LGD/tpzmX0c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ol292dnoGjvwiuG6ZBKhP1JoEp7flx3SnTt9QThs7Oab8vfYH+oB/tIkzB5Z3jusr
	 YoUETk6buG13nHngxL2vYZ546byUno/xHbpxCUHQ/IqTr4X9fe3vrrjLmMuOU7sGS8
	 XGMpXjZL6+/XO4kjILtfUL9cMy8uO1pNC8kbxaxiTPVQE00TxrJxFwWnbY+FPBZLxu
	 xFWZCsP31Ncvy92MNWSr4MnvqJhUKtKEXJoYCZk2OKgYnD1CmJdWScDbUaccQWfU7X
	 T2+Fnwdcds++F7ubbIBj+ClZJ7ECDsHpTbVqljyxec5Y3ZrEy0Z4bI3stcWVQKwnek
	 B65Cyw5n0xgqA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E893CC54F52;
	Wed, 29 Jul 2026 00:35:08 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Jul 2026 17:35:14 -0700
Subject: [PATCH v9 15/41] KVM: guest_memfd: Handle lru_add fbatch refcounts
 during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-gmem-inplace-conversion-v9-15-35f9aec2aed2@google.com>
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
In-Reply-To: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 jmattson@google.com, jthoughton@google.com, michael.roth@amd.com, 
 oupton@kernel.org, pankaj.gupta@amd.com, qperret@google.com, 
 rick.p.edgecombe@intel.com, rientjes@google.com, shivankg@amd.com, 
 steven.price@arm.com, tabba@google.com, willy@infradead.org, 
 wyihan@google.com, yan.y.zhao@intel.com, forkloop@google.com, 
 pratyush@kernel.org, suzuki.poulose@arm.com, aneesh.kumar@kernel.org, 
 liam@infradead.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Vlastimil Babka <vbabka@kernel.org>, Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1785285305; l=2739;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=yzGmlEDFy/cjLSw+iMJeM2ur0Qa630sqxH0mSnKpbLc=;
 b=bHbpb3CAou9uPxE9qLS+0Ete0qwRLtl5oyfQAGGSUyU/rOr+nAFuNfXSrcqFW31J95vZyoagb
 J95vuSBHVIqDOJiMFt4O3/MaVCuQAloHhhFBIU/6XCZMXUwmIiUmtAk
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Queue-Id: A083A100007
X-Rspamd-Server: rspam01
X-Stat-Signature: bc5qp9bnmimwcopnd99s9yn9btanpd7u
X-HE-Tag: 1785285310-467883
X-HE-Meta: U2FsdGVkX1974YiBB6onCSdVJgmbKR7YSWJEL0ZmbGPgg7uCnqHdsGEMzYD8Tf/ZxxFNYsfr+b/epNwP3+Sn7EGlrgtikN6f4YDZ0m0fzkAYCokNVG7z0LxVb1ey4pBxo/L+vL429C3pjVnY52cx1esRtEJFPXQFZ5hGJAPSsLDUID2QjGjrcv+YiCxMgU3bciU28m/FPIkTkkvBCrgM1C/iubedqC1H7+yW3Pt1gxkF/7hEZLnvXvhDoJGnB2T6z2prM5MesOcxtEaCuSgz6DUYwzCiv3Kj1qoCLpSupyezDViQ9JHnzXUdpQrPWiF6DMacYl3w5ulPgaWwhvZTwW7l3mGBLGP77Qsamd0PQ9GSqags8h7fsGp03IRmrlTyqoj/EbldDZ7MUffwDHpAKUBBBa9JyjRnzxFC19s1AmtP1WxCIn+udBRIoJ7bnbMYMOGXoSkYKUNqTfMHy5yRq5ArbhOfi9xFP2uEI45XhFxUB0WmIG7778n/ShEbxHMXsNrwBxOv3v7RzBYUfqskex8zNYzc6biJE/vd988jfeMfEtXW18TSRGyYdYfcskHna4hiBWK7fqof84axTfHqQFHT17YiyiEZij2URQwzbIGqRJD0XX0MYX9FFdvHvtRs7FYtHbMfvMlZiCS7w1IkCKvjhZLzx1auHOpI59M8q2QukfWywLLAoAQGPR0I02JfatXbjsUFoiNkHwupHRd/DG8HzsEXKi/PwVvy77CtQZfiaz6c430Ef8CdoLf3rLbDgGRUAjq3jv2XI3RyLjTgEZaQb+Ifd9dMXDRI/IWL/moWYaQtWDtmSaZ44A7qji6K3sc/GhGDWPlKfrasbWdIuOtL8EC69O9j43HYTOTbiLczc+9+KNKMtPdz2H1vM8tV901Hvgg81ZPeeaU1C5ob5nuBozwwzIC0LgkrwTfqXHqUDFRq/Dt1+CsxbgnZQsJDapsUaP981z3vFv7bVWQ
 S44cAme0
 isDiwm2dQt833/vheTmVSVS8/dKduFNJtr+SwmMXIv9jD07aGrb+yy8lR9fiyzfGwI6XnLalzyvm8/oz20ubSUhLaT+ylFbahst1B9i2FSTX4tnUaLlzvXSQ9PfMXVyOvwsu8JlnNRR3BE1ro292zNBpeIKGkvqK9pHAoQ0bZINCqxb1uKFGEXUe2GHO1SKjxpIYumRuzmSmG7VDIKo39OOmTJJvAnzRqPDKY39rx60lIihoOzdZBBfrZoit+p8EQKsSIBftoq8DiOoYhpa4uDBY47t9MB0cRb5+5vLVS2qMva3jxEvrtz2jpdexyiq82upQZ+t0/BrDVC5+cJIdb5yLx5bAzdJGX/07aILDvJCRcxnP9Wmgyy5kzRL4TFHNqnriQKeqmw699oxRR/uIKazH9XmPCvywTkOrVafMHmGs36CWZPB1Y1DFG08txV51S6tYtkt6zcn7aNITRiqmqnK5ufKmoj8CiGVnrY0cKuR+jn8qg53gIQiFqQp/P9W7dNMQzMB0TXBiuBbk7gnAGNkt3cWhMGAJBwPDt
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
conversion, even if it is otherwise safe.

The conversion process might not be on the same CPU that holds the folio in
its fbatch. Hence, use lru_add_drain_progressive() to progressively drain
lru_add fbatches.

guest_memfd folios are unevictable, so they can only reside in the lru_add
fbatch. If the folio's refcount is still unsafe after draining, then the
conversion is truly unsafe and has to be aborted.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/swap.c              |  2 ++
 virt/kvm/guest_memfd.c | 12 ++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index 0f9465d31fe52..4427d76c88d6d 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 
@@ -964,6 +965,7 @@ bool lru_add_drain_progressive(int *drain_state)
 	}
 	return false;
 }
+EXPORT_SYMBOL_FOR_KVM(lru_add_drain_progressive);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 928fc7f4a01e4..505bb6747620b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -554,6 +555,7 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
+	int drain_state = 0;
 	bool safe = true;
 	pgoff_t next;
 	int i;
@@ -565,9 +567,15 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 
 		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
 			struct folio *folio = fbatch.folios[i];
+			int expected_refcount = folio_nr_pages(folio) +
+						filemap_get_folios_refcount;
 
-			if (folio_ref_count(folio) !=
-			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
+			while (folio_may_be_lru_cached(folio) &&
+			       folio_ref_count(folio) != expected_refcount &&
+			       lru_add_drain_progressive(&drain_state))
+				;
+
+			if (folio_ref_count(folio) != expected_refcount) {
 				safe = false;
 				*err_index = max(start, folio->index);
 				break;

-- 
2.55.0.508.g3f0d502094-goog



