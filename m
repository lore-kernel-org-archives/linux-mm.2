Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 236C0606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TCrFySW0
Received: by kanga.kvack.org (Postfix)
	id B1EBF6B05BB; Sun, 22 Nov 2026 13:45:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAEEC6B05BC; Sun, 22 Nov 2026 13:45:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BED96B05BD; Sun, 22 Nov 2026 13:45:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A1AE6B05BB
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6A42806FD
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:09 +0000 (UTC)
X-FDA: 85463632338.08.D434E71
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1753214000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TCrFySW0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3MjgDawoKCA8y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3MjgDawoKCA8y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373108;
	b=Y/3pMHSekuNgCemeJBQnpL5fWm/LsjXh8jTYaEgEtXZ8iiqC8U5nOUKrA8Pxw4L4g2wJCN
	y8bGmrgslGRjNw3JDdQLSuDQB3tQgZzCrv7F5bY0iTaA9ulJdOHqFOygbAWnQ153H0M/FB
	EZQMYxCgmhSxv7wKrA0vrz8RWsEsUSY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WsuwGey7RkQSop+XnrYKl3vcLnUZxAuob7/LeOfTYsI=;
	b=zr9Ym+rvXYn4+6S6SVfnWnbuv+MLoyXga+Ec4IoA8Jri7mbevJ3jPWaGfC5d5SPds31hfG
	4Q8a4Mk1EO6//m3pFSHvGXbTB82Bu6QWXOai6G1p+P03AxX0K1aSWjfiYzN09iRnH6BF5A
	xHOzSd25QcKX44Km8vsoMn1pLMUrVsg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TCrFySW0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3MjgDawoKCA8y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3MjgDawoKCA8y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cde9044a96aso104332a12.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373107; x=1795977907; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WsuwGey7RkQSop+XnrYKl3vcLnUZxAuob7/LeOfTYsI=;
        b=TCrFySW06riTZyqLvrE2bo42aUyCVSCtzO0UR/bXCQClM+TAf79Ba1PEa0IxksCRZi
         Mgwoh7AhHG5/Zu0zNffCejYoatdAe6Q1ZKGBzT0/stASdL57ac6RARZJabitiPIXxLY8
         uVQhsHczuKh4dMBP3x+dEjZvvtRmKAeUBHjlP+CcBn5YHmyduFboUQJ3z+nryycFdyyn
         6a+677JAKBvOyA6KL6s8w1zA9Dke5FG4dhiPVTnUqhHNkwQiwS6E3rWjNbyY27SrPEd2
         0FmrifIi6Js16w+iuNiaLDvOCPmV1tVoH9IkdR0tck+ObgDHVaX8d4iuKQYxQt1SR+wM
         iPTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373107; x=1795977907;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WsuwGey7RkQSop+XnrYKl3vcLnUZxAuob7/LeOfTYsI=;
        b=QuiIXiS5G/XFGDaidfYtAeaW8yg4F/reP7tJdjQsnsxrWsR8vF+7YDUbPQ7hSlF+z/
         SBzNPRZxNsmR0qLc4KycdU9xr8vVqBpZny/HDzbg44NQmSq9CIoA255ln4zRj0gUa1ED
         sx+Bg8PpYSuUgCNvfT/zj0lZfB15oMrBk+X1U2CrbQ3ioz36HEn5zl5qtzsTFV9DYuCW
         MZ0corUBm9GrPOdGyeE0fTSHyXKIn0Yze+RZTQjy3aox88RT2vDevU82fKW4Gqt0nQbl
         gwTGzQK3FBtEP2I91kfIE+MOq6HsHHOCBAhoIxYVcsDpPPpZrOdBTmFu+EbLdACoiW8T
         BArg==
X-Forwarded-Encrypted: i=1; AL+hErHbM6F0sHvvCynD/M1M1VXatXiJtEkzyi18f/q/y89MP0RApX6x6DZWJDKCcafKF7J95uW7JurSkg==@kvack.org
X-Gm-Message-State: APuU4Z8XSkiGbRSLc1I8PeREMvwJLWiTu5ojW5UyCEYbwp1ca4P9gQz6
	8NWum7L+xtQyhX683CKNf/CQCseMjPSAauTj+Z17EW9cvi2JSSwgCNvVD4lwW9jq70seJg7fq3w
	rdQqeiUkM1dKQz2SsQgLFkw==
X-Received: from pjbfs12.prod.google.com ([2002:a17:90a:f28c:b0:3b1:81f8:3b10])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:3c06:b0:3b3:c9d1:9b65 with SMTP id 98e67ed59e1d1-3b41c94d32emr8737375a91.51.1795373106544;
 Sun, 22 Nov 2026 10:45:06 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:41 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-8-jthoughton@google.com>
Subject: [PATCH v3 07/19] hugetlb_vmemmap: Allow architectures to make HVO
 enablement boot-time only
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8t9co3f8ottnf8iotarjtq1met3yb5sm
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1753214000D
X-HE-Tag: 1795373107-505461
X-HE-Meta: U2FsdGVkX1/nKjD388L0VM32FNaFgRW1t2Of6EYXO/lKIpUKlL4zG6SNAR+FBwBVCTZw0Ko4cJ80uP9dREukF+J/odzgWhwpHHZKh1AI3iBNoC8JlNgwIcXLTXsu7uzwfVbHxzcP9BoGZYUCl/RYPfOO6j8B8f6AT8oOOYd46+h7Y/aTiFGh0EOb3nPxyOFGh0mCwdK4vaeQeY8eBQ+g4xhfPEr5xpGcQXpVNaZtgbO+BZu7133gAjD0+/BmYN7cSPCQRI/q6IW05VTr9uk3ub0LAEhltxgdSWhaUldFg0gLVSmsIIFRc0THT8lw1qErf0dwI5uSkfkTmg4AAhrt1Nm/mskOI5c/KCnIVZAmhxgR3hLYHwEnJv5Edx9Pw32Eu+1M7vP5X/L+5jq6ZQ3YarHtIIf0zYmwGCglmBibKyUb87fI6fmM4n/KceAWlHxF9hHFjnb5TrZ9GX15PNw8EVPF3qqG0pqFF8tc5Y+Er5zaimCIYkZWCzTVFyfmajuZNZ6rDVhQloQ9clTr5SUyCSeX1QgyGBafaxrdD3tXmu9G3Qt2L8EfxhPpwm0yUy8JjxVmeuRLnEdhLLUsycaqaZtJ22lRlrD9KsG7Fw26td5j48AHTGfoje+qzNQd90pLtX/0Xedp2+PG6F4z84W5kP1MjR3AnoqftP5QEK3Hkrt+q3BPUHysllkNL/RMtwo9hZiKZowVymZ1r/QqYTs/T/zSI/Ohf16kL86b71kwhP8fjckOgJ/dyRJ5icsTJbx5B2C5JOU0Hb+HMUBanDgmJJc39l9GhiIiuKtWC3I+ubHWa+GiC6Q/QEFgIXpZ0TxgHWdmxYluuIeFo15w3oZCz4Tp06ITgpxPscfanwa3Zbe5e5TJt+u1Ujj4OMo3eC/5vYJ8V2XCxnWc/2y8xpeRe6GEHZzpAeIg+vSEhaCg70NX4kGzBIvJUItqWHlBOkvy9VB3Oslq3f+YrbjSLjC
 xDSG4xxK
 AwSM2ylN8tw6l4irDZWfe3Bg6t1luFgS8r5e+q6gM9NuST3ef+/bKFwAgtN8kWI9O5SJpobS6xaz6rewcgFMdcQFOA1Ln2mCWj1bblh1YTyACUmOOYJBp8XtS/VjlglTqL8ogVnv/CCd+VARdfqxPsPQyIm54ggEZVqrIBHBhgycJCqjHqLFxyGh3uM+mAdf7U+LQdtxtowepvPUp5JtH1lzy7S+4kJw15zv5ZIETLNlxMrJQRGna33asO1mKleh7ZzzJf4A41OqDm9U6/qwiESj6EaHbOqy42C0AkZLSPr3wpD/48k2aa8Vdu3xFWiqMarrDpSgYiU7bW/BgdcV01pEiI4AtBG81crs11b66GMGGBt2DK5qEtjT6BOLV/X3e61KVCPPR9XZvoc4lAauwdVLoeiKmslwEcLqvLj1TSJbM5wL1QDcni8YbRmwGHNUJsAH1LcxNChfUmVcWfooZtLrePOS9hd6QY2oMOuE58Cx+gqSnd+kqBx4oxN+W5bvNWxZPb4/A9CQ+GCJI3/tWb80gRBtqS2B2VX+f8ByDQi/BCdgF9YVN+RFP88/Kw1bMSetjt79OgW5acVPKEzJxW7RvVmDezzh2A1r+du0/RLB9dx++axshf0grukrlJoKswFnuVexQt27S/4O0mm/eB2IIUVsQI+1gx3nS8XNk5sPSV4IgfjB3K7Fs1TeFiKKLR2BJ9OLiJRuO/wb+mG4ELLrdT0GG2OVGAvKHlMhQ9nqUeClLE1GNU5e5gXY6xcWmG5ms2ko0N7Ku5n3/C/zmwBKzTCBBaV42ta1K8bqaGWjQt4Qt+ur1Entw9NLbCQ4WdD+F9s/Q670Wt1+2oax6V5zcHlEFQ3/sf5Wi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Architectures may need to configure the system at boot depending on
whether HVO is enabled. For example, arm64 needs all CPUs to support
hardware updates of the access flag to safely update the vmemmap in
place, and may want to refuse to online CPUs that lack it, but only if
HVO may be used.

Such configuration is only valid if HVO cannot be enabled later at
runtime through the vm.hugetlb_optimize_vmemmap sysctl.

Add CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO for architectures
to select. When selected, the vm.hugetlb_optimize_vmemmap sysctl is
read-only, so HVO can only be enabled or disabled with the
hugetlb_free_vmemmap= kernel command line parameter.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 Documentation/admin-guide/sysctl/vm.rst | 3 +++
 fs/Kconfig                              | 3 ++-
 mm/Kconfig                              | 7 +++++++
 mm/hugetlb_vmemmap.c                    | 3 ++-
 4 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 3cb0138e850c..f29da7a35289 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -699,6 +699,9 @@ pages.  So, those surplus pages are still optimized until they are no longer
 in use.  You would need to wait for those surplus pages to be released before
 there are no optimized pages in the system.
 
+On some architectures, this knob is read-only, and HVO can only be enabled or
+disabled with the hugetlb_free_vmemmap= kernel command line parameter.
+
 
 nr_hugepages_mempolicy
 ======================
diff --git a/fs/Kconfig b/fs/Kconfig
index 70a1d0760d28..0c1a436280f8 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -267,7 +267,8 @@ config HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON
 	help
 	  The HugeTLB Vmemmap Optimization (HVO) defaults to off. Say Y here to
 	  enable HVO by default. It can be disabled via hugetlb_free_vmemmap=off
-	  (boot command line) or hugetlb_optimize_vmemmap (sysctl).
+	  (boot command line) or hugetlb_optimize_vmemmap (sysctl, if the
+	  architecture allows changing it at runtime).
 endif # HUGETLBFS
 
 config HUGETLB_PAGE
diff --git a/mm/Kconfig b/mm/Kconfig
index 18c0beafd4b8..c1c32d2c5cf8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -466,6 +466,13 @@ config ARCH_WANT_OPTIMIZE_DAX_VMEMMAP
 config ARCH_WANT_OPTIMIZE_HUGETLB_VMEMMAP
 	bool
 
+#
+# Select this from the architecture Kconfig if the hugetlb_optimize_vmemmap
+# sysctl must be read-only.
+#
+config ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO
+	bool
+
 config HAVE_MEMBLOCK_PHYS_MAP
 	bool
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index b4d0311bcc4a..142f2975846b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -669,7 +669,8 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
 		.procname	= "hugetlb_optimize_vmemmap",
 		.data		= &vmemmap_optimize_enabled,
 		.maxlen		= sizeof(vmemmap_optimize_enabled),
-		.mode		= 0644,
+		.mode		= IS_ENABLED(CONFIG_ARCH_HUGETLB_VMEMMAP_OPTIMIZATION_SYSCTL_RO) ?
+				  0444 : 0644,
 		.proc_handler	= proc_dobool,
 	},
 };
-- 
2.56.1.809.ga0b61035b5-goog


