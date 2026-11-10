Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09867606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QgtuWbdw
Received: by kanga.kvack.org (Postfix)
	id A054C6B05C4; Tue, 10 Nov 2026 00:02:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E796B05C6; Tue, 10 Nov 2026 00:02:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 808A16B05C7; Tue, 10 Nov 2026 00:02:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7096B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:02:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F7D4A08CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:22 +0000 (UTC)
X-FDA: 85418013324.16.A8E013B
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com [209.85.218.69])
	by imf20.hostedemail.com (Postfix) with ESMTP id E9F931C0004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:02:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QgtuWbdw;
	spf=pass (imf20.hostedemail.com: domain of 3W6XyagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3W6XyagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794286941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
	b=YHrJQOGkSAfOFEltEEc1n39xeEpTdsjiqs8c6uvkZDJNbM6p9SFdltIpcJeFn3PFRiuda1
	hGEiGEVhGzkKGKmcUkuHSuhIgEuEC3aR7XcijWa/xI7CbFCnMiD5yWYGJENVIk0MGdkaPU
	LF2Un+ZmIiJcUKHILrnSez11YOawiJ8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794286941;
	b=yN/42ovkMzrRcWVhrfY6mEpAALuabl9V5su+VZHOdfXqkTWkUDTQYaGwiXQrtiRdC2mk5M
	64Lk0chtZawgq0wIHFDmrc6RwuS5ghSc8XVQnQpPd+CEtNTuK1JFtaXZg4CDj5Kk9cc6dh
	1KxieZEJJfpIeQUE81RRV/clGMo5Q6w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QgtuWbdw;
	spf=pass (imf20.hostedemail.com: domain of 3W6XyagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com designates 209.85.218.69 as permitted sender) smtp.mailfrom=3W6XyagkKCM4DuBE7Cu1E08805y.w86527EH-664Fuw4.8B0@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c4048584447so134549866b.1
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 21:02:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794286940; x=1794891740; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
        b=QgtuWbdwYf+ss69jysGyKfffma91La66y2CfnU3YJZ3mXvVINMJOOk0sB/J7fJGPHH
         mFn5+rJRpT6bgHodfNud8LBDCJuIM4g+4wZWrzPcIbDcPV6qkZUNkdt3ey2g+B3T6YpW
         tvuC9Ltca0Zf4/lea9DZaFHtiuS4z6ZAfoncoFeJF29WDAPKtjfppVaJZ9uX0SX6EVLw
         LhDUjntn8ktzbClAUCAgevhq06OsXl1otPD+4xol7gIuqzqqXUwJ6QagPD6SR+y0j1v9
         YCVSPXn36RRBfj5vKl/cF+jEPP7x/3CJfIZ49+BBD69Gr+JFsGChhcnIHzig7FJO05/8
         mvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794286940; x=1794891740;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hqbeun0C1/XgWjYnTEG1QqOg75mMAInimMPRhrMj/I8=;
        b=E+cz4OQHjnqMn72Ne5tVb8w2nuWMSAFQX597iCPp4lTKMlWvZGcHgumitAjhV0RrkT
         Z2E5AejC0z8vOPOpnIjAde/sjW+lLDQchAmkXQ4X8aPMazXqCAytBjZWoVC/dw8aG8G0
         naLqoRlVQh+6MOgPp7COlVRuzytnY7eFkytHDAHslzt6zBoXWJ0R7Y6OtorD7wuHSBhP
         61Qscf6TQNIsTl+LaDOS9JXSxR2zBua/uxvKOc/rTGGjU9pXq3PoRELe18rN7oGbzOcA
         09+O0lSTjJir+gT8TeUlovTKDIjCPQfnVlZyS004sBsSwQ6VA2nOy5Nnfu/cU7m8Sfgx
         dWYQ==
X-Forwarded-Encrypted: i=1; AL+hErESc7Q5knTQUwg5YWcrfq7ECQZlToJw6Xv9KBCPpylKK1OJG1wXwBE+rVXBmpClq1+IReLoCsPApw==@kvack.org
X-Gm-Message-State: APuU4Z8Yu+QN49U4r4Egz5eaNgBCPkRoRAtb7wnfJ+a2q7Qj5V8np6p4
	B3jh+utCjYTkQYm9gaX9T8lgknOnqfZMhb6PPbFofqANob6hnPDUK3YIxSxf2y1wzehhNuH65nn
	SeBOPsQPTpN/+6/FsVw==
X-Received: from ejqs13.prod.google.com ([2002:a17:906:454d:b0:c3f:2fd1:c5c])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:6d0d:b0:c41:e0c0:e6b7 with SMTP id a640c23a62f3a-c504951cddfmr104842866b.12.1794286939400;
 Mon, 09 Nov 2026 21:02:19 -0800 (PST)
Date: Tue, 10 Nov 2026 05:01:56 +0000
In-Reply-To: <20261110050202.529473-1-tarunsahu@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261110050202.529473-1-tarunsahu@google.com>
X-Mailer: git-send-email 2.56.0.506.g506a7eabc5-goog
Message-ID: <20261110050202.529473-14-tarunsahu@google.com>
Subject: [PATCH v4 13/19] liveupdate: Add feature header to struct luo_flb_header_ser
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, robin.murphy@arm.com, 
	maz@kernel.org, will@kernel.org, David Matlack <dmatlack@google.com>, 
	Alexander Graf <graf@amazon.com>, seanjc@google.com, jgg@nvidia.com, loganodell@google.com, 
	arnd@arndb.de, dwmw2@infradead.org, baolu.lu@linux.intel.com, 
	Bjorn Helgaas <bhelgaas@google.com>, oupton@kernel.org, alex@shazbot.org, 
	gle.com@google.com, pbonzini@redhat.com, 
	Andrew Morton <akpm@linux-foundation.org>, kevin.tian@intel.com, joro@8bytes.org
Cc: kvmarm@lists.linux.dev, linux-pci@vger.kernel.org, 
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	skhawaja@google.com, sagis@google.com, linux-arch@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: gabxqptepcgiejx5sijgpcupjyrtbo5i
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E9F931C0004
X-Rspam-User: 
X-HE-Tag: 1794286940-996765
X-HE-Meta: U2FsdGVkX19uRlsukT6TZ1LjLjuBgAt09N+DRHh+KnjhjKllTdZoVgtLaIAohCYr1tRmDnjomaSF9ok/4qQoEcZ1PMczzrvNvy74OF7soJa1wg1FfFGdPg2i99So3Pky59yQwiKQ/PTYaagewHjmgdXwjm25i46UTaztm63V/7ZqQtTr/CvI3274kgT5LKGOpJG8VeHPj3IPeNsrIRdn0QnpP8SlikRHSjTrIYShyMXxY7ZTdMadpkl2Ug1DbVqUWCItgkiVB6CtdZECQXfXfFdx2YhryNXAYchluPnYzcXkfPhkOHO/R3nqWz4zZrs9gMFGpO7QsFtQUINvEez6C+o+cLCaTd9Ama7IeUJXUOcFFiUGcaWuVFuixbhg36o23NWIWQrBcRRzvpXn3GJwwyxyF1US4muPtwl3rqbnfXtcyQDu2gmbZUZbwOOus7w0gJpBPNV1hiNqiQBkyXXiq5QQSDX4kKERUjZc9Jsbm47z3i5Lmt69aJadI+TPbMmNDKANPWtzo3xxbvwMdsMBxj2/wfGAa9mFzbiTc+nO5BggnR4MA5N/5kfT4tZRCkOyCqxlnEUTqR+9p5Wbj4rht+Q1NVKXBr8OajhfMYdarEQ51qcwjUq1VpTXbYqe5Sb7sGlqEz7g9HvctUDpbGu0eQ9FYikTvCh2AhwRwxj187tDfqYJzF+gk6hE1AxS3yye7TDkQFN57FLwj8dO1RNaG0l+vtJN15vxmC6Ou6rRjDqPfa0e7wa/CC5Ij2L/RcsM97fE8vNJSPnLUFh1UGEfE0vc3Uyb8Th87BiNP0x1laGVdruyCPAFojRP25autEjyLQVVVwh5we52rg8mumHVgK49oGf9fy3QHZ1RvOIauoUM3ILqhhxc9/qazkcBOa9BqENcU2o+YY2bvLub7qhLvlYnS5QU7E7vntt4ToTiSUl24cnJS6xC38/8Q2AFHf6YJxmcNqpMJLAAt5tKsl8
 XKv6vHbH
 hMG7eYS64sOLG/GuIdldCPH9zKR+NVlSj3y3qiyI4loamoLtjv4+f2C7LjBRsRX6owZPL/HR6LUUGcCdTojYci8Bf7D11QOpSdfZyhAmZKEHCShJ7/rNaeH/WCQq0s8UqsCkyxMGisaJoI0XnWYqZO8LPHuJIMMNdgGNL1GVZmo7CXrprAn/SfZPfA53oS9Fo9Ho6M/75iTQkujezalTKA6sWLdTfVGKHPBqFCZofg7dSDe1/yVm60yb6TLEXp2QDfecu0LQkLQ1kB7w7N7Ow/mn5F5YtwIyUiktxrGU+rRW0yKRbnOi/61eweogjv5AjbVPL4W6pQxN2e/Eiu3/mVnkFwPgB6zgCMJeGG5RydkmvlVXoipaESQ/2g/YR5Oal7mUKV4EJnswepictxWcvT247AiACQUjuksXiTyn4jdYhKjGyW6F5NhVrtrUCQwNVb5UcNhFM0F5G0tXdDFO9MNdjlk++c65yCvWrplBVY4nrhsGp4qpZ1+KjYNkpyQ3Ecn6uiAafz2+nArxiAhBmgTvcoblPMY/vIrRS99iM3Ob0z5OlBuc+KNk8riiek/XBCqsNjpxI3TmGj65b1vh0mLM0QcHFp5HLkmA6t6QN3OCmqsjqF7tsVBOd7bA51LPu3FI8bRGfMXRu1Fy0m95oEfht8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Precede struct luo_flb_header_ser with struct kho_ser_hdr via
DECLARE_KHO_SER so future File-Lifecycle-Bound (FLB) header features can
append fields to struct luo_flb_header_ser without breaking compatibility
between adjacent kernels.

Initialize the header in luo_flb_setup_outgoing() and place the outgoing
entry array immediately after kho_ser_size(luo_flb_header_ser). On the
incoming path in luo_flb_setup_incoming(), validate the feature header
with kho_ser_validate() and locate the incoming entry array at
fhdr->size so entries remain properly aligned even if the source kernel
serialized a different header layout.

Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 include/linux/kho/abi/luo.h      |  6 ++----
 kernel/liveupdate/luo_core.c     |  4 +---
 kernel/liveupdate/luo_flb.c      | 36 +++++++++++++++++++++-----------
 kernel/liveupdate/luo_internal.h |  2 +-
 4 files changed, 28 insertions(+), 20 deletions(-)

diff --git a/include/linux/kho/abi/luo.h b/include/linux/kho/abi/luo.h
index 38b4658183a2..4913707ba0d3 100644
--- a/include/linux/kho/abi/luo.h
+++ b/include/linux/kho/abi/luo.h
@@ -157,16 +157,14 @@ DECLARE_KHO_SER(luo_session_ser, 72, 0, 0);
  * This structure is located at the physical address specified by the
  * flbs_pa in luo_ser.
  *
- * If this structure is modified, `LUO_ABI_COMPATIBLE` must be updated.
+ * Preceded by &struct kho_ser_hdr.
  */
 struct luo_flb_header_ser {
 	u64 pgcnt;
 	u64 count;
 };
 
-static_assert(sizeof(struct luo_flb_header_ser) == 16);
-static_assert(!IS_ENABLED(CONFIG_64BIT) ||
-	      __alignof__(struct luo_flb_header_ser) == 8);
+DECLARE_KHO_SER(luo_flb_header_ser, 16, 0, 0);
 
 /**
  * struct luo_flb_ser - Represents the serialized state of a single FLB object.
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index d0f72f27001d..79bb5f64bfac 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -131,9 +131,7 @@ static int __init luo_early_startup(void)
 	if (err)
 		goto out_free_ser;
 
-	luo_flb_setup_incoming(luo_ser->flbs_pa);
-
-	err = 0;
+	err = luo_flb_setup_incoming(luo_ser->flbs_pa);
 
 out_free_ser:
 	kho_restore_free(fhdr);
diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index cd715a7c1d99..a8dcdb8456fd 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -53,7 +53,7 @@
 
 #define LUO_FLB_PGCNT		1ul
 #define LUO_FLB_MAX		(((LUO_FLB_PGCNT << PAGE_SHIFT) -	\
-		sizeof(struct luo_flb_header_ser)) / sizeof(struct luo_flb_ser))
+		kho_ser_size(luo_flb_header_ser)) / sizeof(struct luo_flb_ser))
 
 struct luo_flb_header {
 	struct luo_flb_header_ser *header_ser;
@@ -559,33 +559,45 @@ int liveupdate_flb_get_outgoing(struct liveupdate_flb *flb, void **objp)
 
 int __init luo_flb_setup_outgoing(u64 *flbs_pa)
 {
+	DECLARE_KHO_SER_HDR(luo_flb_header_ser, *fhdr);
 	struct luo_flb_header_ser *header_ser;
 
-	header_ser = kho_alloc_preserve(LUO_FLB_PGCNT << PAGE_SHIFT);
-	if (IS_ERR(header_ser))
-		return PTR_ERR(header_ser);
+	fhdr = kho_alloc_preserve(LUO_FLB_PGCNT << PAGE_SHIFT);
+	if (IS_ERR(fhdr))
+		return PTR_ERR(fhdr);
 
-	*flbs_pa = virt_to_phys(header_ser);
+	kho_ser_init(fhdr, luo_flb_header_ser);
+	header_ser = kho_ser_payload(fhdr, luo_flb_header_ser);
+
+	*flbs_pa = virt_to_phys(fhdr);
 
 	header_ser->pgcnt = LUO_FLB_PGCNT;
 	luo_flb_global.outgoing.header_ser = header_ser;
-	luo_flb_global.outgoing.ser = (void *)(header_ser + 1);
+	luo_flb_global.outgoing.ser = (void *)fhdr + kho_ser_size(luo_flb_header_ser);
 	luo_flb_global.outgoing.active = true;
 
 	return 0;
 }
 
-void __init luo_flb_setup_incoming(u64 flbs_pa)
+int __init luo_flb_setup_incoming(u64 flbs_pa)
 {
-	struct luo_flb_header_ser *header_ser;
+	DECLARE_KHO_SER_HDR(luo_flb_header_ser, *fhdr);
+	int err;
 
 	if (!flbs_pa)
-		return;
+		return 0;
 
-	header_ser = phys_to_virt(flbs_pa);
-	luo_flb_global.incoming.header_ser = header_ser;
-	luo_flb_global.incoming.ser = (void *)(header_ser + 1);
+	fhdr = phys_to_virt(flbs_pa);
+	err = kho_ser_validate(fhdr, luo_flb_header_ser);
+	if (err)
+		return err;
+
+	luo_flb_global.incoming.header_ser =
+		kho_ser_payload(fhdr, luo_flb_header_ser);
+	luo_flb_global.incoming.ser = (void *)fhdr + fhdr->size;
 	luo_flb_global.incoming.active = true;
+
+	return 0;
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index e22a8cf39d91..df8306d73768 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -121,7 +121,7 @@ void luo_flb_file_unpreserve(struct liveupdate_file_handler *fh);
 void luo_flb_file_finish(struct liveupdate_file_handler *fh);
 void luo_flb_unregister_all(struct liveupdate_file_handler *fh);
 int __init luo_flb_setup_outgoing(u64 *flbs_pa);
-void __init luo_flb_setup_incoming(u64 flbs_pa);
+int __init luo_flb_setup_incoming(u64 flbs_pa);
 void luo_flb_serialize(void);
 
 #ifdef CONFIG_LIVEUPDATE_TEST
-- 
2.56.0.506.g506a7eabc5-goog


