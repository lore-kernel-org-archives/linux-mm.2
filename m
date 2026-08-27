Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 851ADC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 23:31:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9096B0096; Thu, 27 Aug 2026 19:31:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C0546B0098; Thu, 27 Aug 2026 19:31:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888CB6B0099; Thu, 27 Aug 2026 19:31:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6068B6B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 19:31:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C4D9C022A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:27 +0000 (UTC)
X-FDA: 85148648214.11.7ABA891
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C21180006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:31:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PVbfmSlW;
	spf=pass (imf02.hostedemail.com: domain of 3zMiQaggKCPsvwhyhqvgjrrjoh.frpolqx0-ppnydfn.ruj@flex--stevensd.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3zMiQaggKCPsvwhyhqvgjrrjoh.frpolqx0-ppnydfn.ruj@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787873485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LOrBCjVl+Gsil1QM8OKlKDVjeh9PhasgM5tVDAHOOrA=;
	b=MXng+EMt3t3uu93KKMia03f5gdfwyYlJE9Xsmwz8vTcrLtVpcPgaUPvkKsUZA9XXKUVj7U
	JVImHVOC57uufRILOTPGldhzkncFwo5Tj4WeDK6iUG9i8NRwrkrZHThHHeKq/c+g0//soL
	+BBnjdsCdk+euet4RaHADKW7RR5BRrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787873485;
	b=ccSdu54PqxB8kkEGZPPj5Splt0r3/Ag8bZCz/EYUkagsHSi5F1Wm7+kC2gpVV9+JagoAUm
	nafu1l3ADPPNdNlify8yR+rLXcBin3ypIE8yCtdn54RvoBkSAkZDRrhbAEEOZD8zRF/ieP
	AjWtw5dI2A+7l3Q7UAh8nyhT69Y+ahA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PVbfmSlW;
	spf=pass (imf02.hostedemail.com: domain of 3zMiQaggKCPsvwhyhqvgjrrjoh.frpolqx0-ppnydfn.ruj@flex--stevensd.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3zMiQaggKCPsvwhyhqvgjrrjoh.frpolqx0-ppnydfn.ruj@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39512608fb1so1060086a91.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787873484; x=1788478284; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LOrBCjVl+Gsil1QM8OKlKDVjeh9PhasgM5tVDAHOOrA=;
        b=PVbfmSlWJ19axGuQ8Qfl1USxulFAVwojN7hE8R9J95UnZcuzlrKC51vBLMcFRiCIt6
         lJtHCz/vfzbA0zlwPTAR3QKhB98w0lMGCclnw/ae63gE7pq8/079C2Hkn/prUJAg7cT1
         yWjtXcQMrs8/I23Ry843LHnWP1BMhl+5ThReme7eA7ZxSC1EdjYRCKS+jXKKP1MeCXWw
         f2rejtzI0f8OtlYTMRcUv2APEoYj7ftcJThNSELPYU+eJGbhhq8WBUXhVe3LSe99EeUT
         x8FhCD3MOkZkFSTtLt54WWBNBVY7qy5x+boKQtQ0SqvQelJMSuRLD6iVNonpKGvme+9B
         1DoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787873484; x=1788478284;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LOrBCjVl+Gsil1QM8OKlKDVjeh9PhasgM5tVDAHOOrA=;
        b=ewYBZxmsCsVhlHSd59KFdCvvhJiaHQvO65kec4tjirbWhg2QOnQ4Eiox55rSg30B1D
         1HIHsP+fr5xXgXsoy+dACN8JzJ/M2No3rbPuNIePWSPIjeXv3a1vn0s4ONrrFLQ/JW7q
         IC1CMXBt0Z7tF4b9AZq4wpHApntd18ZUSLqOrF7hc/Yr+rrH3kRYNBO6Wvg3dnYc0DUC
         ubpSuMjb/oNX6HJN1g1wuzMWkk/79meEKC8huub8pu8Je+HbXjQAQLDPmLTqrKc3s7p0
         JJ1dTmyZcxgOZQ4K0KZB9yA3zrdmAPQVdFNehkwlMRrAPm5TQiA6YaL6o5YKb6KPLQQX
         jSRQ==
X-Forwarded-Encrypted: i=1; AHgh+RqlkoSKjIJE1VpQuY9PZDUccqvTCcJU7jX/um7uPJ18HlfQDG+PDH8eUlgeqpIkfjcClbJBED7CRg==@kvack.org
X-Gm-Message-State: AFuF++m1cPqyYjIKIfwV8n6uAsuWDYVy8hZCikJbe+4U7SuRyyn/5C4l
	roEwEV9DQawfweULKsHvKZpsOYy638y0VA9alVvpztELvifWIF0+zqo58l9/XZaW0yJpVFm8GAk
	hyTPgl9sib4psHQ==
X-Received: from dlbqi2.prod.google.com ([2002:a05:7022:ebc2:b0:13f:bdf3:f58])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:4cc2:b0:396:d27b:89b9 with SMTP id 98e67ed59e1d1-396d27bb20emr3178120a91.10.1787873484126;
 Thu, 27 Aug 2026 16:31:24 -0700 (PDT)
Date: Thu, 27 Aug 2026 16:29:42 -0700
In-Reply-To: <20260827232948.2520558-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260827232948.2520558-1-stevensd@google.com>
X-Mailer: git-send-email 2.55.0.897.gb25b4bd76c-goog
Message-ID: <20260827232948.2520558-5-stevensd@google.com>
Subject: [RFC 04/10] mm: vmalloc: support creating aligned vm areas
From: David Stevens <stevensd@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Uladzislau Rezki <urezki@gmail.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, suleiman@google.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
	David Stevens <stevensd@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9C21180006
X-Stat-Signature: dz7co63u74qw6z879w69x46hcgs77c1s
X-HE-Tag: 1787873485-396720
X-HE-Meta: U2FsdGVkX19dOjl4bkApCZTTLJ6GB+rFt/989mF3gS6uVTQMefWbEQ+Q1ipb9ZvijkP79TL51Oln2KeJyzXM2HA6gWy3n1ralKQBWJTxSUlrIJSXaiXGL/C3QlkAeNujpf+uxD4xEXH8rQTKlGZV/vyY2hDnGOCDLwasaP/OtyGB6fY109HO3x+2hsPJQaHSVRt8vzHhP6Jyia9KQnyClei7PeFzMM7tiHuW8dEJ8tKs5nU2EJvZYI6tNNjI5yjEQhbx4TL18zaukI0oqEb2ndauQlbf/zamx7FLkcFGpMWD9JvtiTinNLRzYUgxxdUZW2nm0OIT9zoo6EHjpOhxLsh7pa6vezaMGyJHA5T73rNklBjKGTi2akuShI+OfE/l74lTPBmUv1sjgW8qBE5tDt5e3w5e0zg1vbS3Qfp7kZ5aaQAQcEy2cWv4x6ElMIo06Jm0/UWoN0Q6YcX8fm4LIT7wtwwlCr+dGsMISl4UJeQTE5IIpd8I90BzZXXItTxrfnw5fltUaNCoPByqX63lVmo40D1UMZ5+dnxSf0VnOO/33Dx9mFAvhUQkqDY2OcalOvbsI7I/+XIodB1vRHQdA9ZFQqV6eK+Q3QYPXrqv4ErMo/ocPV/7iOEtQuahXnafc5G0Xs7mzpbB1L6uH70aArZR696djrK1HTGiO3FBo2AR9SjAKTb3W5a0vJvx0cMDOsW4mwKsKwxH7ZYArhkcniXG+wXLzPJEy5QKovPto6O1ha937NjcjoGCMFIrYB1yQiIhq5gsQbPprv1hOU9AmSKQFXzWYEfV49abkr5JZa6QrXCqKpnp0FWE4309Zy0s5LrYaIizgTD9y4bp+JDiJ3bJWpsDsNQFDOUr93KqpLwtFCAlRRESW0ZME6bDXl3CdSA44BYKZgg1/USkiRtdUia40kqNsXiN9EeTX0rKJN6rTMrNj7yjfbJDsr2UFhYQhaCZG1h8SH2xXhdvm3f
 uR3Yql9x
 3Uvw/EC9UCToh+dvvom5dIzlEA/Kw6Ct9dImJFCuo+C4b8cDuVJzr8UvurDouSZjmRlhCq2WgQSZJb1eNI6i8dPiWI3eRJ4ElcpH1gjXaO3JayDrJTQzcEMeoMZ4/KFUTE0zLH2/3pF0ZqTFj24LtN0IUz7OK1wjWNg0Kfdzb+rwpOmpJXWecFzZzg7+GSsuDFpg+cKdDKt/36taI3AHGzRiyemt7+wNYqNo6hbbYDbREHyrKB2s7XDpk/g8WExQerJVn0erUcWzYP2GN0fTJUIj2WqkjNcJsZjfF7sMlkI2aXIa+Z6oZ/pY/CvmaYSEuV+UJNQH26rzg8JzmLLkHz4rKIFZ079FMEwpCKjeUp5gjAYYLEDoJI4Mym5cBT4z16ioVyqTZVQ0cxO41Bf9XtluHWzzcq0uKMQcXlsJXxeEYgfgWhBMBzlvpPGrh9BPa7zlXA6oGrVnwdlsw8tiigyx52X9/l+Z1/5ITld7EdvMgT1zbDIwCXZlncXLRMzof8FLVMNhhIOUFVjRaC3e26VMursoZEyUp6uCyPOY8ar9vfVXxrFFWN9/XJ7tKOfaDtDsBQxYe76tjHHoDu8bAR7HDa44tn07tyGx4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose a get_vm_area_node() function that supports passing an alignment
when allocating a vm area.

Signed-off-by: David Stevens <stevensd@google.com>
---
 include/linux/vmalloc.h |  2 ++
 mm/vmalloc.c            | 24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index d87dc7f77f4e..5ed9c5b25026 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -246,6 +246,8 @@ static inline size_t get_vm_area_size(const struct vm_struct *area)
 extern struct vm_struct *get_vm_area(unsigned long size, unsigned long flags);
 extern struct vm_struct *get_vm_area_caller(unsigned long size,
 					unsigned long flags, const void *caller);
+extern struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+					  unsigned long flags, int node);
 extern struct vm_struct *__get_vm_area_caller(unsigned long size,
 					unsigned long flags,
 					unsigned long start, unsigned long end,
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index d39897300f29..059cd0748514 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3280,7 +3280,7 @@ struct vm_struct *__get_vm_area_caller(unsigned long size, unsigned long flags,
  * @flags:	 %VM_IOREMAP for I/O mappings or VM_ALLOC
  *
  * Search an area of @size in the kernel virtual mapping area,
- * and reserved it for out purposes.  Returns the area descriptor
+ * and reserved it for our purposes.  Returns the area descriptor
  * on success or %NULL on failure.
  *
  * Return: the area descriptor on success or %NULL on failure.
@@ -3301,6 +3301,28 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }
 
+/**
+ * get_vm_area_node - reserve a contiguous kernel virtual area
+ * @size:	 size of the area
+ * @align:	 alignment of the area
+ * @flags:	 %VM_IOREMAP for I/O mappings or VM_ALLOC
+ * @node:	 node from which to allocate data structures
+ *
+ * Search an area of @size in the kernel virtual mapping area,
+ * and reserve it for our purposes.  Returns the area descriptor
+ * on success or %NULL on failure.
+ *
+ * Return: the area descriptor on success or %NULL on failure.
+ */
+struct vm_struct *get_vm_area_node(unsigned long size, unsigned long align,
+				   unsigned long flags, int node)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  node, GFP_KERNEL,
+				  __builtin_return_address(0));
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
-- 
2.55.0.897.gb25b4bd76c-goog


