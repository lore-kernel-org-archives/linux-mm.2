Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580B4CD5BBF
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 00:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90F426B00AB; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E78A6B00AC; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6C06B00AE; Fri, 22 May 2026 20:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F04B6B00AB
	for <linux-mm@kvack.org>; Fri, 22 May 2026 20:18:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1D56B1208A8
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:12 +0000 (UTC)
X-FDA: 84796772424.05.4555070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2A546100006
	for <linux-mm@kvack.org>; Sat, 23 May 2026 00:18:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PfFbEs1y;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779495490;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Adi9dFEznj9YOckHNucUqAIX2ZdQrQcAEp90scnjJoA=;
	b=fsrMaER8/IeR0BsTMp0P927WRvbEq7/cu24lf3T+I0RnQXTDsjcC3fRgQa14SNeYMF7YbM
	ub3j0P/EFUWWF8oqsj8P3ij7NKG0EY2tQi8Lk4auCk/cHfWxRHLbe3aONP6C8A2ufdIRcv
	2qXfjIjk2PknbKGMqlIT5H1BNmjAfrM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PfFbEs1y;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779495490; a=rsa-sha256;
	cv=none;
	b=Os/rYz+MxWAsmKctpGLQUW0VMGZXAWyP4h5OJNlRHz5c7smX24t7ykx4eCs9DyPUS8jea/
	FBhYhs9bOds/JTOwrZdfVImDRPmXSDcam2jnQjlLwdv+LA2DNur0Q3GjHQKXMTQlV9dd3W
	14zt2TrjT+ctucQjLU+jSrcNKliVDBw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D154E446A6;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68CB8C4AF09;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779495484;
	bh=Ee24RERkIyDzl0vzILtBeKV58hcDgMuGNqnGxQRM5Ig=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=PfFbEs1yssWU880jN70AQTUFJfd0VM33Sh4aFg4IMbkBWNoIqbeUbftMo7eMB+gHn
	 /wc6bnfz7Kvay9axRIQDFAK+NMgl+otZI+bSO8Mwit9yHTyaSDr2FJ6pIy+Aehjw60
	 G3Wde4WTV0RB70VoAMKpPlh90t2ut3vKzkGWmCS3KM1Xq55oEb4/2CUWA8sXOXp566
	 3OO64GT8wyhVSxu9hGNukom3v2bNaZPg43gvWu0TK+59pq/CaOp77W4jrxvxzppZJS
	 1PFtuERNTrq8qnEzJAocBzaSZUXQBikVcoBbxZC4WoAx7w+5F2EOBiNZU6S6s5g/MG
	 ZDNst5NmqnPUA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BB9FCD5BB0;
	Sat, 23 May 2026 00:18:04 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 22 May 2026 17:17:56 -0700
Subject: [PATCH v7 14/42] KVM: guest_memfd: Handle lru_add fbatch refcounts
 during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260522-gmem-inplace-conversion-v7-14-2f0fae496530@google.com>
References: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
In-Reply-To: <20260522-gmem-inplace-conversion-v7-0-2f0fae496530@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779495480; l=3088;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0LMPy4NHzTbpl6CPAwUp88B1CDWtHCwpSiKTN2CghWQ=;
 b=h2IYzkmC6TxHtPms5D6JdZQsYrbYWfVuH6EnGoYU/RwodiSTGrUfWBs3CxXvSXTxdPm6IOpDG
 IUYORy0cK1fB33xeji3IF4zLgiIOl+AhuuZv2UtXfZIwUb/cZPS67+B
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A546100006
X-Stat-Signature: joc5u6ekprpzhof5gx7bi18hpu5o7d19
X-HE-Tag: 1779495490-97335
X-HE-Meta: U2FsdGVkX18HBE35p6nbzwJ928aKiyeP8T9cJBADGEY/8PGv1CuNhONJCavEx8SckeREANMdC4EIuSUez/vE5WV4eSKgVEjefLv5KkeaV0Roym1faVQE6l3h3ECjvea+MOVIa7ZbiqI9kaytDvT0GIY5D0tutNVkScqoDjgVAdbn8sCoKZL+SEn5GBp1UcS8drajOYxcJGLYtXv0h0fMotPUAqnXLp/4nDp9AoC3a2we94cuvQ7FuVX8xCjsosC/4an4vLECF/hx+3J8jgfI0rbWXL635ICHZueZxqTExSLucgZ7R/RJ3bOlix2rfuxL2ceF/dBdvC09DhoGUx7+rr/rc2gFQsHRlvBdLvQK6ZjLAU+DslyvPA9i4mcbnzOiksPzhZ1JvmcZ7HhHGXrLMzG+6qV5EznY/nDiGI/N+rHERroA3FTMRX2laf+/W7Nr0bo9dD9+ZQYgxhiiL+VuL77zq5JGh28AkOXFbB8Jgwa/LPwIH+cFOUq/djK2bOZ+j3CONzfgzI37uK/JQr4WXod9GE8UeIUYf/ll7ggCMVvDIAxPpoc96mtq4KFERd2cxsY4nlqmYxkj9inMRlf+6RcQjX8XWKwAfBrAcyxngXrvpeDI2vkKGYplPnes8Hi8cq/4iZyENAqltCBYk4JZflwZtSObqktAjwGmjgqYhNwMiL2+aijbAUqoj/gSPKPc7jUqw3LEQzP5TksUdVSasCtf5/9chbneQKNfDqxXGCCNARzFR7AekU3qlBqMddVq/QprmPP3ThWxgL/8q2tANBYyfS1AITWpXLev6grIAypI2TH0rTZwHsZkcABiIK4uRbAETofdc6oGMH1oBT95AzUug6w1SWbwGzN7j2yrLqU3zhEHC/Ei4+uIQa11OHP8b377/wapjaBKF2uR3cDdAtzZ12c9/1/3xCr2yDBKMQwJngTmnhoyALNqtYdCe2jjxcFF5qEV37p5H1Y4Cb1
 qRT2yfGY
 qwMnylKUWx55TI1amUvBnEnII6XuLJhbPq19TFdItIP5Za26mslEIIKY3vMUemZvavnEU3EC9w9O4Qpsr/2cvqLyjoYxOyAHIGSO8GfA7bzCXf2W7aKauA2yVyY3Sg9qx/wCunas4sC5JFaIlyVNoJef99TN+7/FRe4Iin1daVOJgRy7m4x4MnRHpIJO8skfKbajW9AK2uhVN0TJoQSZ5T4G6qj+9MoMItDf0RWgQ1goW2dWAEhakL3FMmyZb1T4PH6AxuDB0DAllJTK1sCwhT9BrkoA/9k2nTTTH++aosOM125KxoHKdqjVslNHcGghStpWATM+t/yMKCulX9uCdTEyN3iBpAzLL1MgdZ3N6GnXyrlNsFL6ZPqnGyeYuetGktBcnR8p5a3SvOmSeRCv6n2YGxbGCR82pQ7GzAghBi9LUdPYQ57cn8+7FEjliwD878mnAZFvBi/rvsUKE4sznbwoz3pPH2VTk/2Go3Wg9m21TwoKVyykpQaeccw==
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

Reviewed-by: Fuad Tabba <tabba@google.com>
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
index 4e1028843953d..352cb8b837468 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -596,6 +597,7 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
+	bool lru_drained = false;
 	bool safe = true;
 	pgoff_t next;
 	int i;
@@ -605,12 +607,20 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	next = start;
 	while (safe && filemap_get_folios(mapping, &next, last, &fbatch)) {
 
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
 				*err_index = max(start, folio->index);
 				break;
 			}

-- 
2.54.0.794.g4f17f83d09-goog



