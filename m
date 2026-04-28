Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF20EFF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3922E6B00DB; Tue, 28 Apr 2026 19:30:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 368B66B00DE; Tue, 28 Apr 2026 19:30:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F5B6B00DF; Tue, 28 Apr 2026 19:30:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 177EA6B00DB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:30:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1598A0926
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:27 +0000 (UTC)
X-FDA: 84709548294.09.1636CF0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D2DA4140004
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSugz+H3;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418726;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZa4vCmRdMiUoA3bu4ixURqa+6UWxvsTyeFmbvJuvYQ=;
	b=FbnWMhCJ5f90NAqBDfP2B2a7jjteFEKRQvGRN1srUIs958XVamZDs/h8SJOhduIMwayC6t
	m/AuJV4dgbvXCyNRvl8MfkV/ICTWTcXEqR1uVer7Zu+TFnLeFBCFKrPIfImU0duyjxSLrT
	VU410jQ4hW0hVXvRXvMjw5Hm93u2wOE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tSugz+H3;
	spf=pass (imf23.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418726; a=rsa-sha256;
	cv=none;
	b=QWnrNrdMMzgHGKfILLtnYi77vjFqIkr5rH1SfzGShz7f33JD0k4M49Y0zhltGtoB6anrfY
	b0X+56feULLl/3Mku48b0CmJxEOZpw9OkCCm6lDcxW6/BlDpFy+RmMeuLQDzHsX5/7KJuF
	zbbZvxcEibUE/4vI/yxvblKnK2QPF7g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B39D64445D;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 60803C2BCB7;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418718;
	bh=HhJ8C2ULYSnKpU02/tGXtPPTADB2EfVQtqS/uHVIzYg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=tSugz+H3r/bI8vLM/FsW49w2uoH13PWHVcTzFRtrZgLmztYlbaddalMvd/GPTH+OA
	 iybcJYb2OEuzlGIC6yNJfTEkpiT83ARkUZ2JPgi2lXgvwhA8MqYV3aQ8sUW1X83nPU
	 C5w0QpKbTOd/Fs6e787e59kCqffkVfninVVTqOK+iY3ZxBzCmQ1Tr93k/WviiOttt6
	 ta4n3L6M7bOsywGHXUMUzRNqlaLjeH7/a/Yx5K5BtO4VQp2asnw4k5AnF80Iul28GE
	 xW/Z9ZjMM9oUrbE4k3Y89z0drmZzmP/JwrfdMCuUFnHGJa73yQmhc2IMaiV2HlM7PO
	 U7mb5V9fIagpQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FFC5FF8875;
	Tue, 28 Apr 2026 23:25:18 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:10 -0700
Subject: [PATCH RFC v5 15/53] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-15-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=2931;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bFm4QUlwLsCLqMqV3YPlW4ZQKVQMPLtcpdDZUrpsyS4=;
 b=jnKXP7vtqQUPCENWxWAGbQ0dyHE7F1LL90NmrM8GuZj1v4CE7P3RePJ10i1Bn0oSZ+kBtpsLM
 59D3dWe3a+IA5MdRKM63mYMm4SKWGoeTvHRJZSGf2oiZZKLmvyKMBTn
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2DA4140004
X-Stat-Signature: 4z4x7z85me455t4hce1jmoh6u9ybinye
X-HE-Tag: 1777418725-27638
X-HE-Meta: U2FsdGVkX18EKZUm+/vX0PACZ/zVPntuPyh2dJgo1hsnodxj5ssqKza3TvAj00Z6GTuZUmENJIgorr3yYnQVAGmes5DrR1y1gfwQl3mVfJG0wcwV6DEmt8t+rzYTGDWmQSbxIzb0SUZVaZACBZfv0XvW2FShr8jTpkEW9IIwFIcXQFE1QZVNSrhea6+sz8k4P1oGWmnnYuelbO0nPW2Uy09juO/C0t6hvf+6ujLtGpUn/AivBCx1Vm4/usUfjY676uOym4d5HDDoUK2Nl7KHAPCx5QTZdg7LEYen9fjFF6SK4uyYoVXWSntYBDTxx031sB0wSzvl3QEuTAQaBbOZKzU2BAsuuDPglK482MoKMY5mrGNtB/a8YzxSXtIN/lpNfjK6ctymOuNwXPISh/i3ZM4Cm+2j6I7zzTs5S4j6nJu6/3ApMb77N854qABfx4qlYHw0ms9PIMYwU2X20/X2ozx/W/q9x+fTNotju3XTAYffRHyJJ6sNpPJVrm2yPxaRjhF5GsIQFI+9VqJfpiXjB1tYeRCrND7a1JM0EPYM/hrUdYtjCk3JagHREDe1xKqClKThyfOgqCO8rZymuiGxnaq27ZajcIC4RK4lXLXijCyDzekzHL5t9cm/SEK3HMlC5dW+3vgQeomnGutX+8dYlv2Aav1FzKcAHVC7i8PT6RBJib1UwnDkXu3dB7tb3POr9nWjE/VhKE0GCcf6aO5a0JBxSHw4Vmv823lO3B43ZQnn+CSzG1GqVKqsJcG3Hl4j4T4DkEO2mK1sEH6aWCDc8VPr7sg7s4YtLYFhJFQKK0k0tm8HQ8NZCWR8kVdFzWZsZSBRPCI4i6dpFNyMXpukfQ3z/HJt+x6pBgEQYOlGpZbJtswEe6thLqa9ioehXGa8ECLiI99SHU24ErqBhPUZ3PdEZvsQepYZNNdlRAokH30jehlF7td94cZlRq/Z2CXs7gPEmpF4v+Ae21OTdoP
 d6wGEP4e
 3YGa1CSc9gZxQ8HBsI+Ca4jnYvrcwibjvs+UUj2nSujoQD/7DsytY/kC/gvp5fPvJBkEMTQ3Z2g9ZY21zxFv1DRTZcSSQFQYDwCMju/wwi5mAdmjSXRkVNsjiJ/QFZZw4IZVhJESbbnnO6HfL7psqkCF5Hh2cCVw/ShHbYKMJUdmiEj9/hna+Uvz5v+oo8Rx9f9iy8o8Kg5j29UGtSI9DidcS65qhkDxSA6rG9tYrSwGxZ1vKZ6tcGmgqP20TKIFD7TZOtz5IjafuOJ6M930oHiYIfphriUEwbHHsGMIwejLk3Ahut/t+s3HmmoArePSUJAIFIHO0wUAW2viUVRiO0DNHgbdL5wAmmmGwrvU+6KXQXwvQ+2JsATITvbZ/yyoWeDqwbHvCk7Xkmv7BxY/pMZzhizj7/UyvFa99AGAG2elgG5u1QGl3CT+2CINon6excGmsBZ0YJ5rbPb+irIM07rgebrxVVqeDtFs79JaiJjKgVvieXo3MkilVyw==
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
index d8bdb51c50cf0..18dec87dd4baa 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -608,18 +609,27 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
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
2.54.0.545.g6539524ca2-goog



