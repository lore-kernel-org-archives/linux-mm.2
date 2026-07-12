Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59054C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 15:45:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C25C96B0088; Sun, 12 Jul 2026 11:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFE226B008A; Sun, 12 Jul 2026 11:45:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13386B008C; Sun, 12 Jul 2026 11:45:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78E256B0088
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 11:45:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 94582929FB
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:19 +0000 (UTC)
X-FDA: 84980548758.20.227C4A3
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id CDA8940002
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 15:45:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mVL6qktk;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783871117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57EncVwQTApdVwF+AHEoxJEEP6dVsKbM0q+e+B9wKPc=;
	b=kEwYhBusJKkDZA1Gj3uRU10JNEx29F2UzBc4wO1mlyO/g0dQSWSwPp5CL+DoGXuJXCIhuc
	lGAzwLW/pGrVcrtCRDRbgXQuaZ54jUhS1QZoByfi9BoFpmofuaWDLGd/l6M8ykRp46Kv+x
	6WN/DJvVTySh5e0ZCnp/afcaGo3h8oM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mVL6qktk;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783871117;
	b=xD75z2D7G3FsnkWMB3WLsAvB3cTDK1+CqglAnqUvg1+8Zv7tu8gB6OhkGPWjrfO7jAnmmi
	lILvCwv7BZPPwiEbyg5JUQu6O4/LdEScGTyI7qIhp99PnYbLz4PD2krB5iRUUSei8mh8eb
	esh65ND+aGY8MAShz0c/uMseW4jgDCc=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e67555e24so131160685a.3
        for <linux-mm@kvack.org>; Sun, 12 Jul 2026 08:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871117; x=1784475917; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=57EncVwQTApdVwF+AHEoxJEEP6dVsKbM0q+e+B9wKPc=;
        b=mVL6qktkcSyIXmg5C8D3kM4+3eJuzmG2IpIb3qjXU+/5ZUeIHSWmaWbx8/z2ruGk7Q
         Ss4miwn6na1Kfqz6r31NLmqBu94X/Du0HmZ3KZN7ncnGvi+ZVIlw0rYjblmoxfCbYR7l
         0casSmYMKNbRFU2dHZtLXaKTxtfbUGl9jgkQZOBt9N4b3rgUmabtE95cXUuUV/omVeGI
         gj+K86qmmKWOS73JXRwVHeyXWvWxSNqfD5FHj3U1gJ4Pg8Q5w0KdWTVN7ouJn1K25FXd
         bFhrPut5Ub88z/nVtmx5t/Qx6Su67y+Wv2qDXVs53o4Xhqc2nHQu6QUNhtpR2MkFE0xK
         8JUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871117; x=1784475917;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=57EncVwQTApdVwF+AHEoxJEEP6dVsKbM0q+e+B9wKPc=;
        b=AOEI9uE4zLMu++RlJCpByxVeqzCfeTNK40irQI+29K8To93M6QwoTYoKNqTVx/o3/9
         OEkbv+AC3Uvt8N2/ncIijDB2EJM9cxsxya8yVI/dhKPn5oxXC8AtmHmLXzoWYGQLlTPd
         bZhvqTeJciWR651PHltye/Fj0jEq9v+WbaD5ZEgrTpH8hhh9prMBONP6oLcRaGxjHeNE
         5yptA0xgrGNUoxZWMZW4Su1mRtsMNjJeH/F6EnxtZRrz8zWTsElfHkF2cG3/X8kumVkA
         BA3vqRodGpfnVM0/2heRuK+KIBF6HQdFHNrLwZaCeMBUpMhSadiGKcZJ+ve1CdY4aSiN
         S5mg==
X-Gm-Message-State: AOJu0Yzv6t/+eJI5WvC42kolOhzbwqAp4WXjUVSwO5ARcNgfzXzM3cz9
	K5GL5odgKwp0t5WwwxukK+54Fbr/3Jnlg7Ykdg3/OoubZrz7RcP7elWdNQ/ayxQWAQhkzrgJpJo
	myEl3
X-Gm-Gg: AfdE7cmGY+ihN1frga6dt31T2NVOuhey2fI3G5JXhqynd4QgU+oX9rhlsfvm/qRmniO
	mLakaIW+G7/4G1/78bO31LSyVHj7qF9dlMkk5IXr2BUY9nScLJTfAqHOgtLYbJJYxvZibbhEoSt
	IKH9QdKI8q6MyqbUiiTjn/7aAgWpRJTr4NV0yEDSnElpVY4REBh2QEO3FrwfNubKZwKUFR1RAbc
	sZDAqcKlTjxoAEBa+Eu+FybmdpLAfdrubTXtaVQ7iCV1eVnrzhzIQz+fpew9uD/3n57YaLFlAON
	My1l9rJd/wkItSLkXMaTA47AUgg3FWkOx6jFOPODwP1EnXvEMTU48lDCuCcTl00C8mHIh5on8rn
	r1PQX+jXdzBFT8Mml8/r1w14s1prCjZZtBaIci57UykmVCIi+7m8ihU6Wxr6iKZX0S2ctmXV0CM
	sblvn0l/3I6pvwZ2PoMz67rVtvmO7nnELVLrvmjqqK7fr1aHp/SWHnE9eHM4kexyCg9Wmbq1Sxf
	g==
X-Received: by 2002:a05:620a:a00b:b0:92f:199:b035 with SMTP id af79cd13be357-92f0199d1d7mr265410885a.3.1783871116930;
        Sun, 12 Jul 2026 08:45:16 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:16 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net
Subject: [PATCH v7 01/10] mm/memory: add memory_block_aligned_range() helper
Date: Sun, 12 Jul 2026 11:44:55 -0400
Message-ID: <20260712154505.3564379-2-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CDA8940002
X-Stat-Signature: 7d7c6qq99zc5qthxokyb8rfu5jmfcsmk
X-HE-Tag: 1783871117-527795
X-HE-Meta: U2FsdGVkX1/Pj1K3gBaPkjPHu9DT9OPWMl2amJW4S3WqV0JXiD4PmLg/3GO15l1gBGfE/fQMyGtxpJWGEeSBNUd/W8pr1/tqV+SLIwuvguyyyx4QGQkUHgWplpWYZhHIpVUv/4siJMLsZliZMYRdQbAV2HO2tOgv+dyrszxrkpgt1BqlVGOl/HfGYpV46ng2Pc2HXktaXO0wPRYyZ8Hp4/crdoOFfN3RaBGmm9l4jeGG5XmpAd08jxqgqVGrJ8dnBnCViHdmd5F3S8C41yBCVZJTeiIvjZeMwutua8OntRE9K09drOVkMuuhw5LE40ZBWhMWZ+xlYMc4SLZMH+phito5Gch24yyajv0rqiE5cjjijkGXjj34xnxSN2n6Jo3TOGNBIEP7zTFgBVvZpHsuBtQDShlqWKMvtA2vJmfSzn3ixzGO0NGX01/O8bGVAY9tsPhd3juTmqR6lCjv+OYT47UQgloIxmJvU0kRmQh2apSx300q6ddtfvEQRKQvS0UvXva2z4fmVJvacsrauBibODZw3OuJDWCjIN5vfVFBGHBgzQP3jDvNnuPE/Me/pARNqs+zqvErJEXAITT10TsQJHTDj1GAek65OKLwC2eTQeUcVtPaqziu6YfwlSZ0M+av6pGRkxKUuZAODufOdNF4bQeOdtBHqAXIoUaMyP5MwS/uS8Dc6OcDvbb7gzhu+HeXkgv8hbE+4fyBFGaTxzVGvuevZ34MrnsGVkQdGaJQ9hNsiTpIVxj08V5TZxYhYn2ecZx85ihwctAX2j5dAo1D7dfB81heEHtnEOUI3M+q/X3suqTLi6EfL+86OaYY2mlhZz1ulCCRzNooPEn1vdk1+Fls3ZuRMoB/zCOMT46mbjPIElbo8u22g3dVX5RdwEjPMtOsLP2qawQaiv+l6ZW0DMbKeMYEF1mKNVFu2DgsuK9ml+Z/ps4WCC1j4WbR42HK5oPTTRaZUiP2Nbe4/96
 SDh2WuDz
 szODYi4R4tnyNb1Yw4+cWJ5IsVlfSIfQnC6onsJO1vJ8+hbbdpjlfJxvy76sP/eI7rRR1sRd3ep5TmA7ev25r1h/8yjtlJjlEDC7Eu6Oc+2aU/Lv9O2L6CvoHhHH5PXq17W0kJzjyawgfqm2yKhjwa1M2H8RCtKpKwHKl1H45LTAdNL67m9gnt409owXw8X+H++ILeKSS+oKYREqJu+DdzN4l2OD5roszm42r9+cD7g5deI1ilZVBohL3Y2ETJoTR0LfbK+0uMSI0m5nL+R3JJmyCwY5q3yerQYFUtTLRRD5UrNXH8Cg/oeMaAHVdbggm7SVnZtDJGCx/7R1dU068GB9BB7ZPqNdV1qhZsfc4LQLUAVdif/XjsI2Papwb4pl4//mmG7j8qEC8mxo=
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
boundaries.  Guard against end underflow when the range falls below the
first memory block boundary, returning an empty range instead.

Update dax/kmem to use this helper.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a18e2b968e4da..592171ec10f49 100644
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
index 463dc02f6cff0..1783299073e47 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,32 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
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
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes());
+	/* No whole block fits (e.g. range below the first boundary): empty. */
+	if (aligned.end <= aligned.start)
+		aligned.start = aligned.end;
+	else
+		aligned.end -= 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.53.0-Meta


