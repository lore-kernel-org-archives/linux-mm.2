Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B2AF1094480
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 15:04:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C0CC6B00C6; Sat, 21 Mar 2026 11:04:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742AA6B00C8; Sat, 21 Mar 2026 11:04:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5229C6B00C9; Sat, 21 Mar 2026 11:04:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3C9456B00C6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 11:04:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CACB31405F6
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:15 +0000 (UTC)
X-FDA: 84570390870.20.66C6E0D
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0C2B41C0016
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 15:04:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ffDkq56V;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774105454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EZlQlpoI2kyeTHm+ataFfQwGqNyciJ5dRDvCF4GFSVw=;
	b=UVz6A41vp6ouwiFuPyROZwxuqg9tg7L1rQMuQy7yASjkj3kRsnBzIm5mZ3/vaXbvr0zNTZ
	35CAsUfSarTowGCdiNGr7Nf9TQ5TVgWcO37PNHwZ4n86Ntve+M+/z8uW4FS3ick1P4gSlw
	kCPhZ5imK736rv67Tj/SIkVceHbtz6E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ffDkq56V;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774105454; a=rsa-sha256;
	cv=none;
	b=FmUOoA+eFc9pUASVNC4m1pP2idEkHKr3TnFgs9iyPg87zYBHzXHAVQMgtKnVGi2Vinjsak
	0Pvi1V0JO4i4P973bFENz7LNpC0FPFrB9Q7hu8wmUeKEgvXt9RxXPA3Gv0sqoFLBGwQyzh
	ZdHAa+iIEVdUDoBsIZgJ7HOMx68nPFE=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c70b5594f4so333671385a.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 08:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105452; x=1774710252; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZlQlpoI2kyeTHm+ataFfQwGqNyciJ5dRDvCF4GFSVw=;
        b=ffDkq56VCz3f245GltaF6cXZZXRhZ5dXBPmqK1f4ZwHf0MUM9lwRRtoWWr/UwfgKdZ
         lZk4D+aDnIFSk6k+UIIcbeCNrTeIPn/dWqF8kFVOlrzLAahZG1w0awrPdPGa5Z0WC+VV
         hwswjRMFUNlxUoEyfPfQcR5err+p2LJqAy5eWHvg3EiB/CozdSvv20brlU4OoL+MB5Tr
         f2thnBoUGOBUKymxMyIRRF1Xd/sak53tYHeYUeYz0SKo2iQHXGIRY1mshZV0fwQxsw3B
         rCTeBbIGVcXVF3ZsYW357JZDn+hsdpud5VXApMKGoftq+tV6qWB8SLPKhdj0zSGOH1li
         dgxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105452; x=1774710252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EZlQlpoI2kyeTHm+ataFfQwGqNyciJ5dRDvCF4GFSVw=;
        b=FRjNmP4rzRDH2MQeE/b7NUzY7jDCTxDur4csmh0H9Nf4TL5iSUMFMDfMU/mKXWF0Q/
         eBcVohex2rjjEdcwSxSa/I6etP+JVcNDgZO8rNFVYE1Zy4kGhbiCUqNgwDKj/kcJV/o5
         toBB5HfL+Kq298W1jSmFO4WbheUWv4JivzomFvMs0hCIl3gGYLWs1KTc7iLTAfOTQX/E
         P4lpcwTTI8LXmU+B6nZ7QWw13KeSR6zNF2fxggZk7bVfQB8WGGSM2N/1t7Ff9wm9dTeF
         L4UY7vUFHOrW2qemPF82OUDzMLY9t7GSh2YJkTWl5WYrLX1NY3WGLsSDwsWBxLESr629
         LHeA==
X-Gm-Message-State: AOJu0Yw305pVWbNisw49PAlXXIs7kV0TmFo+lEY7P+fInTzJTmub/WuF
	VF+r2WvarAMtWcrK49DnkaEVCPUg+tjsCtlaB/qNIIS56V0/LTjCP4i8JTeNpZvbQ81UycgqMeT
	Wh0Qw
X-Gm-Gg: ATEYQzx7Wxv/xYqSztQ6CbqLasVPvOvgndWZpkm2ZahiK54Ss+jrb47oyRnL1Aab4q7
	QOe3edRo4WE6vEsTLh51obJUftqbog7P6oZdhfaZ4oeRsg2rnpkaTzKsO0x7gBwOfFxN9qU2Ebc
	bQb9hzkVfywy3X77m2rkgSD9WBWMMIxnG2240kXoCiTLJfEJRXTLy96DsZJBYwQCXl0pgMuL83K
	QxCP5sWh+j99RL9Yqra1+3tFVfVhIwZsC2aiUpkj69AZJ7Al6W4RtBB0XHpwOFoHedEds/0eDTu
	5jhDLugKJYHvKndOWw//XSOyswchhVv9rcwW35EPmKXr8bGHuYVGWeSxFPngQTvOgHi390VEIfC
	IEA5TasL/AXtzy2/S50DYyQVFKu+/bOFP5LjylElnI1D9B5uLbiBU06RG6doA/w3QliVwb9FVtv
	6Rj4mTcebCH21UAxPjsrYf81aH3ZcGKTgkCv+ZCVqqC9MzXMu0FvfdQD3smcRgu8AwIs+AMSK/G
	JVTXySn1Syxg6cf5Nyb5LAAVA==
X-Received: by 2002:a05:620a:454b:b0:8cd:8ce4:c0ad with SMTP id af79cd13be357-8cfb9e4b1b4mr1481729385a.22.1774105452426;
        Sat, 21 Mar 2026 08:04:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:11 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/8] mm/memory: add memory_block_align_range() helper
Date: Sat, 21 Mar 2026 11:03:58 -0400
Message-ID: <20260321150404.3288786-3-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C2B41C0016
X-Stat-Signature: 19q8rsfwqnpnw3bx141a1igfdgz4y7rk
X-Rspam-User: 
X-HE-Tag: 1774105453-178298
X-HE-Meta: U2FsdGVkX18LzN0/KSJc0RBLa4F27WfMwaibY/LiX9JzwPD8Dy5+9wPUMLRJ26B01FI2z+gAlqVN8Ib4wxvlOsM4aGyIKFrPPehwT7YmUuZRZuJ7xwssCqs3ppEAPBTyhLxDYVb+GjBZWnYibYrCAeHF2EXL5j76TDUPthqpjQ83rn0wPPS+pwaRM1afdLI+5PaILKfLlHSUfFfJlMv85CRMNb7Yl1Q55XE/+L5pioVe1U4GiBAcMe5DLAe4o0gPbkFx0sOw6Di/fZzQqMG2S2znGUTtfoeTjw7cXjv5f0sl+fAfLG8WLFCD55F+7mx85ERUrKupdtx9i73x/iisKcu/xwuFARhqynnTUhPsRjWADCWMHPljJRtWFSISxZU046u37nDlWmBn+V3eUrshGF0U0FBWCcffxJub26g7oZmTgX3P79wovEYVxBgmV83TZ1KGdMOvfbNWXD2EYNtVyNfxTHkyMQMHE/veMdBsembjHUhGQtTJ9wag54Ds1DpABbfX7enRRB8auhn8xs6n+r6kb2MfIwkDpyvE+YrgPRxiGc2dlBY2KpYxecxM0O138Ypxp7nbeWdJLUH+a5Blytic1/YY3+nMQCPl0aHXQKlGpV48ukUhiyfQPF98AjwjS3h/xUQysjXM/ri1nj541175iDy8U9IjpqGswna1kmxBcIBglqiZMDohARzXR0Nrn4w7C1Wns70MaQaK0VFngT6ln7o9vKD6+JzHIS7lpBXmPPG5NWMwahNPaRiYb+QvnxhPVETXY8KM77dd3snRgsWgVjllJdhvF0++mFv4yelXfvOnMWzP/vOuy5bVgCX59kx9h/ZpYo/acHCF25pm+pKuAeTFDfTzRsRZbiQs6BXFPyy2yzZcGlmWpGF6g9WITWj2juxTT0SGAR+WR7NZF3ElFAMnNd+YGcp/tO05+E8XFAne+OpmzMOBPjrBZSS26qTdgkK+YSFQTwN/RVa
 YuB3geVI
 FJBpLoi2dcV2la4Wkr3GdbPdJn2P495frKGEQ90VbE4g72/0XDwZqAuXjT+i+ZU5GrUeICA5/9+XzMW9gpE0XBN+0leRonhgvGQGCiPanoic64fCA0I3ZMkYbA8+ENm3FYAM1FIrk0Quf69GVMinqcsxX1qZ1SkUS85cVFgDes+CrJa3jVjF0vEGAMOZlStmmb5gRPPOAZOb/oYN7nTiALk35YjwgAxibud2F43c4zlZ5nhhVwuDbWNiaq415PWclnP5eCrTvGVScvVdD+FGj2MBdkmdyHdG7IreoAhm3CO1Zdr/W5XDKJbbkQWhz4Het/MUyT+nDddrKEgEWJ0a39nIGW6eKVAB/pPYZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_align_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index eb693a581961..798f389df992 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -26,9 +26,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_align_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 5bb5599c6b2b..17cdf6ba3823 100644
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
+ * memory_block_align_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_align_range(const struct range *range)
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
2.53.0


