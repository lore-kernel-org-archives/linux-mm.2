Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCADCD37AC
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 20:23:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 248E56B00A2; Thu,  7 May 2026 16:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21DF26B00A4; Thu,  7 May 2026 16:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 097656B00A3; Thu,  7 May 2026 16:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF4EC6B00A1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 16:22:57 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B71D51603FE
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:57 +0000 (UTC)
X-FDA: 84741747594.07.1D59B08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8F13F40004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 20:22:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imD9dFCK;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778185375;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+NU+7aDejl8tRDgMe3i8MPsWXywEfQFsf1lEQzZXeQ=;
	b=wiCR+x8c3CkL1JkFqW/s1gecTtJm1MMmsvbyynRLWeM1EJbz7TRBYJP66bT7EfSERWhEig
	3Gh3fef/XDl7X2YebAZFfIAV8YSqSuo3RfqXGM3dfScnDjsg98k0MFLaqiiLvDT2KqlI4A
	oMQlyQQQK8Zh0Q5TtTtu2mz3FYO0FLY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778185375; a=rsa-sha256;
	cv=none;
	b=eaI7G4DGVFLQrnaeieAFVQIncy60gDt7SOSpdJrNZYIeNif55yM4+pfKM8boHLwQzMPKtA
	wrAWg59ShYFrcoQIBro4LcW7glPqtihbLho49tJAFD1Y6CZm+QLWE1SVVj3dNjTSh8jzyH
	f3Pb+anoIISbPdmkZ7UqPx46eMmDWdc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imD9dFCK;
	spf=pass (imf12.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 159EE44564;
	Thu,  7 May 2026 20:22:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7826C2BCFB;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778185369;
	bh=YIjXxMhCsMiab+p5+fdNvqRJdqFXniOH0P4Ki+yn8Ko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=imD9dFCKj0jueVzRENtSGvsIBMrsR7vWunixwRrXICI2WaDD3s7HHTyf4F6rS73ib
	 uLOOlgI0nkMLZ+vyNZiAuBI8PjseOOyTI5kKxSk9qcDA6PJFrQDdNMKHGd8AeGlT8n
	 IJ/lmohds/NLp4CsRD5aK0j1UnVInmSO2zesybO2T7JLUNbcxwthuQIP/oQuR5H+V0
	 qzQN4u8xmqAcaxZR0mlK5O/Vqpb044c6+nfMuryCHzvpdHCcc1c8K0ZH/AMT5SdSOA
	 hQweztrSkzj3jwImtpIt9Z0mKQZ3j3IMqKAuBPkBcNCsOI0ETFIuQog+LXnkAnipyn
	 rbPcSJ1wgdq2g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB752CD343F;
	Thu,  7 May 2026 20:22:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 07 May 2026 13:22:31 -0700
Subject: [PATCH v6 12/43] KVM: guest_memfd: Call arch invalidate hooks on
 conversion
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-gmem-inplace-conversion-v6-12-91ab5a8b19a4@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778185365; l=2720;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=84iyLX6+LIfUFaSHBjCmDq8DIdOADa//Czwizn51p/0=;
 b=AJQOXT3mB7TF+tmJLeAyEkXf/3izyNdFZJWpsWvgwF/wp0ylxmJQQaWfnFD0Q7Bm/JzZcuJ9i
 xIWlm2plnhaC+HIBf7laVbW/CiDMyK1Lrh85mSlgzBeNIgQH6KcBdHX
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8F13F40004
X-Stat-Signature: 48bd6c1cw3n6iujcjsr85xewmwk8rb5z
X-Rspam-User: 
X-HE-Tag: 1778185375-476316
X-HE-Meta: U2FsdGVkX18LLs4a94ROrDp6jRYyaSwFXl75SvnM6zAURd3d3QmvuXzJF1aRTICklLIYqWewZ+Qz8/jScH9jVbWmvnnAMkUwHgMSrEQ1rxFHMyrR1bD8vRhRb+33k3yxQvGQwt3XDk9rTp2YglLJc5y369fCcFVlvqcnXSBQHDRSs0FHE6tvFKZTaE7A0rykHpX3r0o85lmSlFIaXIck5M6cPeaH2hN3vprmW2mtKdZlmWF9GyND8pEggiI1I2F8duES26vKECuvwo34M/71E4xsbwzRZs0MQJMAzG9zMTgMw2x4ZDLXDGl7GeLgBK2zZOJFUsvCWq+djMvl0rVUV29PG9t90EDkqqu1Wlitm99kYdbwF4d4kCWp9Dghtj+tnD/AnLuJOhFaehn0AFPP6c66Oxe4YPjXtru6a42BUBbEB+CmdKdetgZzsi6JEdve9JBIpugGwXT8cvc6q9MaWA9bFOlIAiBqKdwexcQ7JfvI+sR7oRL9w46R5tM5twnOTFkE6m74dw3ccj5VfCOoE+pjqCaEk2DjZj3G0BCWbtl+3sDl6/O0bTwH/XHqacFNqELy2ZhWMGs0gioD/b2UMDD5kCXrz769LAe4+cJu9ogdGu9ywFY91asC9KmyM8XEM2Qjny1m8RcweLrzWs2mYzJTBjgR3E8lPX8vGHEw1m7r9cxNbtAI2sSKhIr+HGwYuN9DtjnF++uGu/QFoAPbmOe/JsBONboLbsxM0S2v7Mah4y9Qq7GvzthuhibdDUSBxaPW4A17taszzj42VDDkxBy1RNxbHmlOsHy3MiXNHodn3RjQrJO+8C77T1L/YVjN+YJT0VicAYwERaXQAi/Eg6GfFSS/lKuDf6DBFDTczM7bMXrHHrXY3neJg1Zlp5mr1tVlTW+HA/6el0jSYZGuJdat8b9mt8yCPecwZi9RYkgkri1q5FV0XPbAvamMW1Dw2iu3rlghLvIxA0+3vh/
 w2C9BEyb
 tNt9nP9a7k7SwOWxqV/7+rTqygODOay+XU6IS6fXcuuLe5nu8dGKfln/q1BfzAXgeQ8Kj1y4rvCOd91ye6HnOhDmNLJeUeZlKYfCXPrEwPsxiBpUKiojnThIyCWPmT980dO/8q5gaxDLKqFHmr4UiIcYv4L6eRRX4DmOpIS6bllyCOQs8GJHX2H3RcVDosWqT7VOmr+Fv9IMgAQboxcJxvcWOjLruag2axwPiIyyHZhGpF7kmQj2Zb0bRxcqzFFT7uqpv7rhdED1mKCfcfaIckrO9sFO9nFVcRA3RYWYcIEfqdXhqwgIkgf0n7DfVRWF7WFB51fbkaqDN414C09nbzSfDGULmfLJCP3tKcnMK8Cpe9PV588vl3/5GCKxM87M2m+0w7SU3RUCvX+g0VZmMHKHP3Z2GkkUv/ggmVA1IVjbiq44Q/n/nKxD4t5/dJm4Dssi4/z+UapCW7M8B0iWz/QZRqVePSEj7evNcbntzes70jMaROwhgXQ1c0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

When memory in guest_memfd is converted from private to shared, the
platform-specific state associated with the guest-private pages must be
invalidated or cleaned up.

Iterate over the folios in the affected range and call the
kvm_arch_gmem_invalidate() hook for each PFN range. This allows
architectures to perform necessary teardown, such as updating hardware
metadata or encryption states, before the pages are transitioned to the
shared state.

Invoke this helper after indicating to KVM's mmu code that an invalidation
is in progress to stop in-flight page faults from succeeding.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 9d82642a025e9..baf4b88dead1f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -603,6 +603,42 @@ static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
 	return safe;
 }
 
+#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
+{
+	struct folio_batch fbatch;
+	pgoff_t next = start;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (filemap_get_folios(inode->i_mapping, &next, end - 1, &fbatch)) {
+		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+			pgoff_t start_index, end_index;
+			kvm_pfn_t start_pfn, end_pfn;
+
+			start_index = max(start, folio->index);
+			end_index = min(end, folio_next_index(folio));
+			/*
+			 * end_index is either in folio or points to
+			 * the first page of the next folio. Hence,
+			 * all pages in range [start_index, end_index)
+			 * are contiguous.
+			 */
+			start_pfn = folio_file_pfn(folio, start_index);
+			end_pfn = start_pfn + end_index - start_index;
+
+			kvm_arch_gmem_invalidate(start_pfn, end_pfn);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+}
+#else
+static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
+#endif
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)
@@ -643,7 +679,12 @@ static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 	 */
 
 	kvm_gmem_invalidate_begin(inode, start, end);
+
+	if (!to_private)
+		kvm_gmem_invalidate(inode, start, end);
+
 	mas_store_prealloc(&mas, xa_mk_value(attrs));
+
 	kvm_gmem_invalidate_end(inode, start, end);
 out:
 	filemap_invalidate_unlock(mapping);

-- 
2.54.0.563.g4f69b47b94-goog



