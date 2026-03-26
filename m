Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 434B910AB82C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D63F6B00A0; Thu, 26 Mar 2026 18:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD576B00A2; Thu, 26 Mar 2026 18:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DBC16B00A0; Thu, 26 Mar 2026 18:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 29DD16B00A0
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC72213C33C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:51 +0000 (UTC)
X-FDA: 84589645182.30.67C1FDB
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 314181C000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUblpefQ;
	spf=pass (imf20.hostedemail.com: domain of 3MLLFaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3MLLFaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cUblpefQ;
	spf=pass (imf20.hostedemail.com: domain of 3MLLFaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3MLLFaQsKCAEbdlfsmfzuohhpphmf.dpnmjovy-nnlwbdl.psh@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563890; a=rsa-sha256;
	cv=none;
	b=oswGIZtNULA5K4NnflmcVrRIO6JZnXijf48ceDjgNTk+vRle4QORdWGj7/XOSHCEjb3NRI
	GJBoP/92MweMKle+mArOukOYnOxtJxkL5TPGf9y1VvJSt+sViMseigp0d1HR1abR5JbG+v
	/Hd/akRcGn54jRR1mtJRtwCnfpJ8LA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nVWPwC6pxhgIAnF5094KQEX5dCEhr5KYAaDw4qPFZtk=;
	b=OG5HXSGY4StGp5eAFIP/Fq7vW0FWqfFVt+fIU7VCGFehnnSIZ6gfPtjKXtJb0k0xHOyqUp
	5RnYH/CV2r/IQe+uBgDDk9pX4OXuAeVLI5CMI8KI2NqWa8Dbt6lufJn9nGBP5kcSQGxECy
	yXpISOA7QtzK8Ua0n8BNnmQZHN3ORLE=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c7381a95fffso986534a12.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563889; x=1775168689; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nVWPwC6pxhgIAnF5094KQEX5dCEhr5KYAaDw4qPFZtk=;
        b=cUblpefQtkW80aeXWNg59oBNVpbwR5oHgx/YvKdtCbMvm3J3iVECkvUftnmzGhxBKx
         /Sp5haT07nzTCyXi/tndu304UzPrLeMBtWJ+V2lMiwoiJRI+Nd58xATtZqmpkf0VEHBo
         3FGsijIS4imIlC1V+Uu/5KWfbJLIg8ivecEth5OJfLCwXiDzb+EdVtJh0guZWLj0s3K/
         UGGGxJ6b9qRsiYxvV/5+UNDBTJBHtuaGgj3Kw3LgP6rBam7L3yUFwvoCuGk01cCEFtPy
         V4Fs6B1t3ZldjmG6gNPbgSQmzu/Q+xYxHfYOScVldEn0K2ZzMq55ZNuVciZtLUCKH5me
         1nJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563889; x=1775168689;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nVWPwC6pxhgIAnF5094KQEX5dCEhr5KYAaDw4qPFZtk=;
        b=LqiwVXfPtY9wmlWOQzEElNbX3u58CrBT+bKpgohg+CzB45CVsabE8zapwxywRS80XM
         XE3rlSDW3fPORp9JiY0hxsV7Yu/VF+0hSFIQCsR8mye6Mt0d6OjOTECT/7583udA6KRN
         15glC3vvzMhLlhJQ/7BT0gDUuTC4dAVxIe+o5uXvv4RBrePwI559Xvbq24gs78jLemQu
         uhRt9JIH6LyirdKvAvTlG3NOehlBx6dSaip48ksVE2Vl2ZG3XEI8LP0h7weyeaZ1Zz3d
         zdEiGkWq4k12TmCR6FihlqkRQuFtfk5NBDtC4Taeqn2byOJi18SKR+wTSACAFA5PrK9K
         KeLw==
X-Forwarded-Encrypted: i=1; AJvYcCU9uNlAdRU2jMiSAKfZYYhMrPkzo7LyA/x8Lku2vAOVYFC+SoHjuOj7NfJHZdxYr+4RSI85d0dseA==@kvack.org
X-Gm-Message-State: AOJu0Yx2ABAerocnhdkt/wk8F5Ht3WnZyX7l8qQGK6ilGOOrJQfqsTZx
	ZFU93V2P3aEeHtywiUWDWEymtpN3VAZP86ZcJlFxgautUBgVyV7s4S5300Z7kFURVbIWUuRLuMh
	a+gGYr06r23p5fyZn9dPU/SUJQA==
X-Received: from pfjg13.prod.google.com ([2002:a05:6a00:b8d:b0:829:884e:b688])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2d0c:b0:81f:5ec1:8bcd with SMTP id d2e1a72fcca58-82c95ea94dcmr142656b3a.20.1774563888635;
 Thu, 26 Mar 2026 15:24:48 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:21 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3818;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9AbnVGj52dYRY1Gu1IOMz+RQizSjYS4bjrECQdvobIg=; b=kc7IoC0mcSRd+pSE2vC9D3Uk9DcdVSJweK7d8NasersOpLBpqrsExouK2O75W2pgSl/5dLP7W
 +yGN4wGXJetCGmCWXjtwUwUvZiTUK4/T8FKHTTkq4UHanZPTfIU0TqT
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-12-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 12/44] KVM: guest_memfd: Introduce default handlers for
 content modes
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 314181C000C
X-Stat-Signature: k6spx19joa698g6c6x5bji5bwuunjkzj
X-Rspam-User: 
X-HE-Tag: 1774563889-757097
X-HE-Meta: U2FsdGVkX19B54811GaIq/gps480SQHL0dc7hfYSo6nXhR3JlQ4TEm0gmtyfuDHtb8s+CDkuA6uT8oG5VVCly8R5XMGw2wqY1zskYoyzSaQrHkl9BX58koOi9pnXdgC5/W4y7YwRD82U6zBXMLSQCSBn43QDswgnyyT1QnRmNrUrr4lBtv9JxyB7ZqFpSjZ9z9DXC13QVtekfOYWdJHaTT+e8U91Q/HUax6OYW0FDK9LSRSU9QIMZpxF8VwS0VB3MT0n6rzQ0n3F/019PIMhA9NuDK6+O1InigkAelKV/QP/u1SDyxzPeXLk6q1Yd0q/GfdX63TqgyI+baq/6GmT9lCTiVI6ZoLjhGj3AAGi7CQ1qswS13IT8rPRyNes+NhSVs2aLzVr3rBUoZpbphgaQM4cp5UtSDhhFVmTJE2xEILRsXniukx5GNDLexNEbeVOFa5nsCzCBuQR25/MmQDiJqJcexkKne5IPgt9O1U3Ys7/uTSKker8GJ8gTvtYMPYby4z/sq1RfkdpqFxHGEA39LHBAU66KOM/ijShMJWZbuEb8NKxU88Z4fHM8+fj6e+vgxJfbivxiNIXxL3awep766LoLAnhQaETzU6N4f/l6Lr2fqG7t1zZi71YETboXZoAwgOLrJwOo6H07sc+K2fGAMChJWD3/3HTd4wZkXrn9l6Nhx1hr5K/1DdJZZr4wi7tNjkDOl7XMa/W37fo1L1JP68pkUsu6p0095Ql7FZpHUrlyb1IypXjciXou9RrARTNITP7wFWDcbgApdktaMc/dNRl1jEEe2txTSHPzQGOSeyIQ0bMNKQG45Qci20BXLuwDxtvkXxZDWLhRecnjAlovZsvVfnGec6R4dmbJ8zFN+qiqa3R6esSoACv3UAYKSxn4mDNc18AiscRSdd0+de1EqkL7yd+syxlizfQo39rJQg+Dx46y2NvzQJ5/9frtDywVx6mKDxJYMnBF4ipGqo
 bfNoa7e7
 +ePoKOdUeU63LVy/INs2GjhKpJf3rHQbA6Wx1G//5VRoHgmO6aAEUMsFaAAKlzoaxa5vm5TfQbrTrT/DeiehM13+hPoMRnemtchB2XrQ4PZpvoTwl/MWu2Ngj7qeVveqWcK4QSNdRnVDFK5xmbrsnf6cK+khXoSjtfFfUDbN6sHNu2bfzye5QNY+w3Sz6jwlg4HN/EPpYJnMdnzDqMjGOZrD8weM/0aeInRTcPTAaqJXxFyiCNQXmUX/7HQ/DBonvWokWdfLsWOBiSMffZwVCO/7XxcZm74oEkljbKLQXfy8Oa19AYm3dI1dJMEVeOTSWIvQmqByJe9Rjus9YgNfUXs1dhaRgr4euMtVveV2tNO0jsHxaV+hX6iqC6IGAjLMrGqPexIxjjpB1GLcufmPQ3RSPgG6OLt/K+kgK5k2vdhQlonRPZG12MKHgHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, when setting memory attributes, KVM provides no guarantees about
the memory contents.

Introduce default handlers for applying memory content modes, which
different architectures should override.

These handlers will be used later to apply memory content modes during set
memory attributes requests.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/kvm_host.h | 12 +++++++++
 virt/kvm/guest_memfd.c   | 67 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 79 insertions(+)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1ea14c66fc82e..4ba3c4b303f4a 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -740,6 +740,18 @@ static inline u64 kvm_gmem_get_supported_flags(struct kvm *kvm)
 
 	return flags;
 }
+
+u64 kvm_arch_gmem_supported_content_modes(struct kvm *kvm);
+int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
+				     pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm, struct inode *inode,
+					  pgoff_t start, pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+					      struct inode *inode,
+					      pgoff_t start, pgoff_t end);
+int kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end);
 #endif
 
 #ifndef kvm_arch_has_readonly_mem
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 20a09d9bbcd2b..e270e54e030f0 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -1,4 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
+#include "asm-generic/errno.h"
+#include "linux/page-flags.h"
 #include <linux/anon_inodes.h>
 #include <linux/backing-dev.h>
 #include <linux/falloc.h>
@@ -669,6 +671,71 @@ static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end)
 static void kvm_gmem_invalidate(struct inode *inode, pgoff_t start, pgoff_t end) {}
 #endif
 
+u64 __weak kvm_arch_gmem_supported_content_modes(struct kvm *kvm)
+{
+	/* Architectures must override with supported modes. */
+	return 0;
+}
+
+int kvm_gmem_apply_content_mode_zero(struct inode *inode, pgoff_t start,
+				     pgoff_t end)
+{
+	struct address_space *mapping = inode->i_mapping;
+	struct folio_batch fbatch;
+	int ret = 0;
+	int i;
+
+	folio_batch_init(&fbatch);
+	while (!ret && filemap_get_folios(mapping, &start, end - 1, &fbatch)) {
+		for (i = 0; !ret && i < folio_batch_count(&fbatch); ++i) {
+			struct folio *folio = fbatch.folios[i];
+
+			folio_lock(folio);
+
+			if (folio_test_hwpoison(folio)) {
+				ret = -EHWPOISON;
+			} else {
+				/*
+				 * Hard-coding zeroed range since
+				 * guest_memfd only supports PAGE_SIZE
+				 * folios and start and end have been
+				 * checked to be PAGE_SIZE aligned.
+				 */
+				folio_zero_segment(folio, 0, PAGE_SIZE);
+			}
+
+			folio_unlock(folio);
+		}
+
+		folio_batch_release(&fbatch);
+		cond_resched();
+	}
+
+	return ret;
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_unspecified(struct kvm *kvm,
+							struct inode *inode,
+							pgoff_t start,
+							pgoff_t end)
+{
+	return 0;
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_zero(struct kvm *kvm,
+						 struct inode *inode,
+						 pgoff_t start, pgoff_t end)
+{
+	return kvm_gmem_apply_content_mode_zero(inode, start, end);
+}
+
+int __weak kvm_arch_gmem_apply_content_mode_preserve(struct kvm *kvm,
+						     struct inode *inode,
+						     pgoff_t start, pgoff_t end)
+{
+	return -EOPNOTSUPP;
+}
+
 static int __kvm_gmem_set_attributes(struct inode *inode, pgoff_t start,
 				     size_t nr_pages, uint64_t attrs,
 				     pgoff_t *err_index)

-- 
2.53.0.1018.g2bb0e51243-goog


