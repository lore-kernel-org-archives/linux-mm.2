Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E17CD6E7C
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 21:19:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 464196B008A; Fri,  5 Jun 2026 17:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C63E6B008C; Fri,  5 Jun 2026 17:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B5566B0092; Fri,  5 Jun 2026 17:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE956B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:19:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4152A030A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:19 +0000 (UTC)
X-FDA: 84847124838.09.A2F82CB
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf29.hostedemail.com (Postfix) with ESMTP id D4F28120009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 21:19:17 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KWaebF46;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780694357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8jLd2zqvW28XOaQQClXDDIz8D3hNjBgUh/nqgs8cgE=;
	b=c1ZLQrQa2xAie7/UbLa82xfiqEgjEeG0ZHKzwFS6+/F4WygY5V2gGzclTiiEHAgjNuFwEC
	WFp/fgoNB1LFXixwhtApGdJ6hr1zmQ4QPS0xfwhPq1LiRLMt5BzRYKa+jQWQXcmuvOxAhk
	NS6w3xEX6618p07LqrKfXmUW3AgerCQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780694357;
	b=zWFWagWcfrzYnpYHpMgfBxhgGSwX0oHAZqg1qwhnHRJf5ocrJHT1XNXaIl/ubqUoFl/ruP
	zWYB4YtlsIR86ao2ybCg51ZTN5pq4uHPFEYsYMbRn6xW+XkxEM5UbQrC6gaofQRn7uzGve
	UVBFoZq50KbjxYBOxzyJntLc3rjiuNw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=KWaebF46;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ccf887de87so27328656d6.0
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 14:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694357; x=1781299157; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f8jLd2zqvW28XOaQQClXDDIz8D3hNjBgUh/nqgs8cgE=;
        b=KWaebF46ORB7cfUr8fp/Bw/VB9E0gVYv8M1yCtNrBgY6aZjfpm4EZcyjgK1stK+DEP
         +NLO45lJTz77B5r7QRs5SnnlRw3KC00UvwoGOzAl2sXJ38jbaeUPofz8Ho07qHN0A+Rf
         8uVxXyudWxgmj/cLWwH10iXaCExSJwCVAWO6Jq2mzTzoDNyzcZSDXr+EWkZwRzXxVHyl
         h7ECWNhekczV2MbqioZBIKVbtkXEOgdC4zJy51fsEzwGvUTlMcDk+Y4OLbgCtIza7QKV
         vRw+cS3VVLuI3UxyIZfG6JsstHCBEIm9fcoShbQgUpQghr5587nKgjaX9Tqsh8ETaDH2
         Zang==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694357; x=1781299157;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=f8jLd2zqvW28XOaQQClXDDIz8D3hNjBgUh/nqgs8cgE=;
        b=k/OwB12YrZA/41p1A6jE0sw5w3eXFQjc67u7gyC/ItzdCY5BZP1U8nJ201dQTbKrGo
         5r6mqXk90A+VWOAORKG53ZECAY39w92z/H5JxfdxP9k2jdSK686IkMVWYx9/bHCsQe8D
         zhO7NU9ZCGnWxJX8oPpOf5jAx6sZ5fBkSUB7G4wFlL5BxHbixZ2REV+dUAM+rP31icFU
         v277bx0fuTUhbws7GX66g0eUlkLxTuWWYMnSxcnqURyNR4BN1Q+I1Pv0wumdfYicGJMD
         MSATJ/vw5ISVkSt3A3HixXJE4hoOFViYt36stnM7JRsHU5UnQDgmVb/lyPbj7rfyYbPC
         MoPg==
X-Gm-Message-State: AOJu0Yy3U3QV8rA/vJD2lZ5zDEIbSgUrL5MPMtwwkr8scdmHc1zRtniV
	4dEX6Vjce/pgLDRGUAwoEQc6OeHMIc9FbF0Fo7n0ZBkvN3rJIpZ195UQ6bXvLAFfoaeBg7Px1q1
	iV9OM60LTWg==
X-Gm-Gg: Acq92OHALx8FMGzZAg9Nsx9529ZJulEwLAn+6nJ9mLeB2OVNpSjSXJ5EgRc9IM6Bit0
	Kxf9/AhfkEUz/CufZp+xycWPMiXoK1DkW4broIcYCW0ZSgwTqsuI6rR900aMrTrT0sy3SJS7KyH
	SEpmCiwtLlKab4OSP6AeSJe3v/VqZsG+wlX8eUR7Cvcd34YqC9LJS4jJ0f82rMinPEGssVBNapJ
	nKx3xMuAP8SVcXr+WCB3JlekzepwkUelmTP+ZWYLBjEjbKsF7DER6OmjXiohgFP1ie7kbO15fCn
	IuDZjZmaKIFpmCzSEEXs4y5O210DLj3d0XS1MkwGv8DiWopIxiVUd5dpAY0DbWWcGqesLY5RoQe
	ytin1iQUvFxR3hWcR1D1qg76UpT0kDQIHfwfnbDxIVNw+8X1j6gDrzP42YkrS+1//DynRHNvL6p
	blYaVB2mhTNKjV31X9ZwCATuAEi+n9msEKVmBrRfvsW8xRLwRJDPBvf6+8n8/T8mzm4Wk8tVGYg
	KDPbCXpruevkLBDZoZGU7E=
X-Received: by 2002:ad4:560e:0:b0:8cc:f88e:2703 with SMTP id 6a1803df08f44-8cee5fe4e30mr72255516d6.12.1780694356950;
        Fri, 05 Jun 2026 14:19:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:16 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 1/9] mm/memory: add memory_block_aligned_range() helper
Date: Fri,  5 Jun 2026 22:19:03 +0100
Message-ID: <20260605211911.2160954-2-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D4F28120009
X-Stat-Signature: csuq813bfoyh8oqf5gmqd3576x8e4nxb
X-HE-Tag: 1780694357-113454
X-HE-Meta: U2FsdGVkX18OZViQ5UOaR+4uGVUbiV7y6SK5/f0NmkcxDDbi6shM4SoTGomLoQ0rvXOyuRnJ2stApaWNpNnO+SNEuaMK7ysynZ8G146f+oifpeiEzqpyqM28Jn3Iu49Np/u6QF60voMJSXBC6qzNu1PCq87cym7WkqKS3ii3EooiDPFSvPQR6jrCUN5ujaf4JVFlEVlQB25KwBe7WE5lIqcmffj/oyscSw64ZwizWeBzFDXUSqEjzIMkxW7xfG5CVjcn414PHsHJrSwSXgc0s4tO6kU9lIOVmIYNqCoI9iNKedbu3RvhGfIqzhkkRQBsJbAXV4bqGD8ITD1qMOrqozBQqMqaZahZ00+sLZgzl1sH9UZYAmsO8lY3pxc2gXBbTYxO3RUpxfRBimelcVhhMsXUutt00aP1L2VRE6exn7Dygherm2x3Ou9K5RoRQM8iEaMKo86LybvdFSvH3uHhuw8wGbJACDbQbV9/0mvjDrtCA7DO8FdP8xurka1vQBKvkrv4sk1UD89zPaWyabkwIR2Hv3GFiyiJt9/t8DiBxKUtavsg+YZ2WO2CbI5l1ijnap2Kh/ylL9vfErGw8dCDDH0q3/ZaYNOij8icrmUZURXXrK1+DmUm5OGmfTYk6bpvEbx2Rcj38A2uphpq0uH8JEj8EdTTEsfVaQVGhXdvI6Wnyveqz2D9u7/HwZsnDiQGsjkCAxAbvTzKYTIoaDBYY7piQuV7ZqdGvqHeAtfnqzcBkD/ll8E3yCdhtfaTI7Fc9JTcnXnH4d0BsACLjup06m/aQM0jCoPW7x7DvyouF/tTOHQLBBgEmfqys6KGE4raviAm+5QOeZJeuj7A0laxFkh/dUjZnODlqVOw+WW1/kmdGCmYaHsqmpeUvuxjq0rorp9LPWjesceSQ27MbFg4HbdjqN03tqWKc5qF0ovUOil26an9CEC2d6+L5TBTs1oT4Wqo1+Pbk3Z7xRPcwGh
 GzbjbD4i
 paOt03I7QwrmZREMJCVlvK2hXdMJdgYt+bHIh1/Wwp6eorgJJ16L+rnW+GpuIl76JOuDTL+JftPFfWe2+HPtAVBXH5O0E13yjH98bbCnl6pE/VQDRmlwBL9q9xm3DnCzPLcAMTOOGV0fCXVgffAeQ5ixjKB4EC4+hZey3R+JpbkZICp2c+VWXOHMUgCOjlYVkmHxMeAyFtQeUSK12PoPvB0rYzIoXQuSNCtImLPTRGe849h6kT+VbZDjbyVvYJ0gGPOCY3rBer2xx7kzPxSbbEuz82HhQ//udpDEGqIpLqD20J6dhZxGZzeSKXAGVBXv04YDvnOy7NEa2KW91fqrXKvO4RVS7POO02VQq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_aligned_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4d..592171ec10f4 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -33,9 +33,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_aligned_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 463dc02f6cff..9f5ef0309f77 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,27 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_aligned_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_aligned_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.54.0


