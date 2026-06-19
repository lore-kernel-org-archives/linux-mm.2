Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A062CD98F0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45AB46B00B1; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4333B6B00B4; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320AD6B00B5; Thu, 18 Jun 2026 20:32:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC6336B00B1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:32:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BCD9A1202EC
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:56 +0000 (UTC)
X-FDA: 84894784632.01.5329364
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id A88B0100007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:31:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fd3QXQO3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781829114;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ze8cs1bYi0JwVqJimaih4adYEdCSzoeydgDysN9S/eA=;
	b=MQ1hdnOBzHXrQY7qy9rKZ8iP1X9Zmebyid/hrFdkOiwQL4PbhdFCBR/KE7v0HLaMAeaKBD
	R6yOpdMimjd6cSyf7ZO/06Qzc4vvh7IMOY8g2cOFi3rDTKK3JwiKhP8qkn6FMy7WuJm+ZU
	mLYkmBrYl8rFY4TMMQmfSC5+uYuvx34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781829114;
	b=S//wL6Vw1aC2b70YuCEZbhA9xtI13ZxbgLI2vwMXA3GgDdJNJ8s2GFkwRkcAcIbIuYmGw7
	1sYkTIzBdswp1q6OdpIXPzf9qXdLKdTiamAqL0W2sFnUPsXauwz3ddgIV3UUGIIEMDTeo6
	WPTByg+8jWj6qnoCX+s8YYxa9L0iMH8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fd3QXQO3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C63DE4065B;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A8D8C4AF1C;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1781829108;
	bh=NuW8Yph2xxSUg+BxjzkwpGfcorlKR26w4MsHwkJqK4A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=fd3QXQO3t7yCmzAzEcKMWitUdh/fdw/mslbuUmjI5yXCdAHOzCvya77nZEpcfvZ8k
	 kUxO65PdWslQyBeLBMWPyRvEBwhxyIYxpz/GiRIc76SpzoRFI9CDeaVUhM0MjacFvY
	 ayuWxnOwDYdkQeN7I3h0+lLTFctxIJzf7gOXsCrW5RQEGGKUb5p5lRGUPRe7NFvGEC
	 AGoVwlWSmr8q8NCKaBVjugLHCYv684ky/Iyh44nMEaKdlqPyM01Tz+ktetn49vqlw+
	 fbWUrvQ+ppS7jjvWnEVWnsWflkDZJMRFOrID65jVI0mUVVoEwebReaS16NnKzhHWE2
	 k5y36p6Dc6GPA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E351CD98FC;
	Fri, 19 Jun 2026 00:31:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 18 Jun 2026 17:31:55 -0700
Subject: [PATCH v8 18/46] KVM: guest_memfd: Handle lru_add fbatch refcounts
 during conversion safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260618-gmem-inplace-conversion-v8-18-9d2959357853@google.com>
References: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
In-Reply-To: <20260618-gmem-inplace-conversion-v8-0-9d2959357853@google.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>, 
 Baoquan He <baoquan.he@linux.dev>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1781829104; l=3092;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=/O+oiH2JXm7A6g3+sauBBielmQgPvvVOEru8T+k3ktE=;
 b=lPbIyUOgWSuySRYSO0/c0omWv+bzADKlEWA9gmzmv96f4S30la/SRUoDkGlcCtD9VQdWpWUNh
 CS4q5+4AXTEAevp5x4mMAFNIn59TOdGkn3wVrNpYfvD9sy2/BHoKY/x
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: A88B0100007
X-Stat-Signature: 951or1mskfusky1iphyxhy4y1kjhu9bx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781829114-441693
X-HE-Meta: U2FsdGVkX19Lc0ryWr47ADiMIkXJ8Rx+rS0XKwkLrEFXWbA3ZXrhbDSRaR+C/xIx8S8AN5bnV0ud+5CyDSJdltqKY6nwXeU24b/XnQmGauMYFw1wB6j6ECtPqVYf/2QHWZMKL+xXznnshRpRLfLnke0eUlqRWMO2v469aRHxNNmPr40ZpD4Kjenxd7MIcUxts4YSj0/JY4HDyjY6VmVDNagVBcSvyujZHNzUYbm08Sr/7YHPfX/X/5Cl1Ev2MUDhKlqX9UTTgjdXl4l7T+5UNJabHc+1tIF3ft/VvhqHz5fHROWBF4F63rws6gbHgO9N2U47mUxDDDds/MT0G3Pru38uk7uQfej+qKapAAs10RTScXkhzDy2Fp6Y4dCEhk4T3KhtOXX8j/TFXw66i2IBHkd3GCIVzbsykLscWKXwmWw4zC1S+o9AC10bzJy65xAm+q4gWicDi7Ktc2J4iTwsejD04aMxUyY+6zdD63T34JO2szDHTkmQS78mDdvccg7kDsizDHjnYTNGiLz8DvSweD0a7oeuLQ7ErcMmcYXI53vRtuaBMx53yec8+6ab4pDrMqJKOGqHyOeEQhTf+cf3tZw7AdKeSZHzBjEC13kEeu39+aRLrYnWUPUfsGuz8EpysdeSx5sATmJ3KYkFLvkxVBOlLJgAkftMVbR+wcJ1scZsgzgtvHTw3IfbIJm1K2iAIfC8DUX6wFKCL+j0PadTtqxoNPJTAZ9v3TH7IfQ3qfflfzoDb+jLHzgcQEhODvYe/u4eM/rwzcTXwy9E4i4skzOgmp883bqy9NmR5ZF1RTUIwpLuOOAquuePo7iYm9jhQMXeOZHW8zxvyFBk5KVwp6jGPLFxFrvSwBRD8+5J9yt65eDw5BPe5KN1r5HEX9O+UoI47PV9QEmeMTdTMiZw86gX4qPzDJZYQIJyv+tvo/0wLB4FsNYZrJZUA86FCrAcDv7IV7cYvBVvEqHDov4
 TLIFhX59
 xMB7Ws8RnXb2vHTh57EeFyGWSEUufQrzMQkaZ1WPsd71rEYqjQ/42RHhq2/YRZUBL4TCW1AFQh72KjpHRindCsUguqJHk+LTlf1AmQDjJ4Drfn4Xb8SfdiasCFuNcPw4Bb5AprovPy89gMTtwJV/0WLEMwl8VtUXL3VtXy7uypVC7OS2XVOmJRdTs8qeo3bmRuYGs9ceWZR1RE0hMD1nilgfxx5cUmkgVkRDVs+X8aVIsPxO1xmfu7PlOyn8FX5n+uyS4BCMco86Cv8tnkQ0aaioz8pCgHS74AtFuY+uVuaeuK6ekm575cbQkhlatRadkCfp+FRuuyZjgPWmQzwMCatZapCbjFgyWbgjCJiER4bvLsq+WcCNKJAQWoCz+qmphO1SdZWBeAwG50oHZ8u+x8gfSC/gsBel5IB2JZrXT+0oRYDz7oQgRW8i50yeplElYc/YelAZtYj5GhmCXu7TKOBUsQnVt+NcXmg9vVvaEjapePzAP84zA23l+ZA==
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
index cec8fa26ece17..d163559da0235 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -597,6 +598,7 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
+	bool lru_drained = false;
 	bool safe = true;
 	pgoff_t next;
 	int i;
@@ -606,12 +608,20 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
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
2.55.0.rc0.738.g0c8ab3ebcc-goog



