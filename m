Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61B7FCCD1A2
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 750E78E0008; Mon, 20 Oct 2025 20:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7010B8E0002; Mon, 20 Oct 2025 20:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A18A8E0008; Mon, 20 Oct 2025 20:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4396D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:09:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D36A0C0310
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:09:02 +0000 (UTC)
X-FDA: 84020186124.01.244362A
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id 13AB58000F
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:09:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fRFQdOoU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761005341; a=rsa-sha256;
	cv=none;
	b=YXE6NhURKE0K2JSh6qJqgvoeyg2g4I6gmvOtRBu/5qi8zfqXak3byLZDgdVAaevMGQBNpn
	2ENefTdyKMrsuN3ZJi3Kh/vFX30KCw9QCpn0L+qn18DPdBgMS4ymjK70gCGXqN68LmeSuI
	i0JgfFTcDECW6CThL0ta39DO6GemTPY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fRFQdOoU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761005341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+GEFK7rnEt3wQnfXqm/bMcNjTmF7K5naCxuLWf6Icw=;
	b=Nj+g55dTTTIfVcxBhTIdpyudD4MtgO/ujq5zTAVHfBv8DPzH8+vmrHvobZHLEfDriJJDzj
	PCjK/ydhUt+5UIATt3QNgJ4qHM1PLNxxdSpSK4CUPO+fsC0yLgEoCsWGGE4f02T+4acuMe
	+XqOQqBQxSbNfv4W5tnJFjUhDm1Jmwg=
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-54aa789f9b5so3558332e0c.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761005340; x=1761610140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=k+GEFK7rnEt3wQnfXqm/bMcNjTmF7K5naCxuLWf6Icw=;
        b=fRFQdOoURsunVftNQl8GUih29Mb1fGKB2A8YlOLohABB23UveUdddqUvmC4UnOaPJT
         TjKBfRT2EqxrnmUmKPH6dAusNLxf+KzvUnfcb3J274SG4pRBnhACqKZCewOSGCKmfqht
         yRMnttdS4oPkjxtKOBMFBch+VxIePlmzzTY5yPRcbrCKs7C8/Q+ChXL1t4qSwvJPIqm/
         +UcAMnQPTh+zPb2y6+Q6AuvxYh8eQVZx5SjD9rG0VhbmUtGubAZcgeySXM4VCF1TYLQH
         6uvmOr1SF/yM6qy5ZvNK1F5OkXKQ+g0RdyD/DL5Qnsq8nK/CiNH8ecbqerc5kuLV9dKI
         XoUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005340; x=1761610140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k+GEFK7rnEt3wQnfXqm/bMcNjTmF7K5naCxuLWf6Icw=;
        b=wcjPpE2U3rGRPQoa8vl82SqLftR+/TVT/+Ev/uaTRSQxnC6Fw36GmhGPDDk1eFqlkZ
         oEQV2/wodZVx+xwhvzAb4iruvk199J9To3D9JmqiGbd8Tjm9JnAClbtmi0WFO01abGyg
         9SVGO3+fGV+ZSxBDtaJNJvqntUA0CMDOFHhjDTfJbyod8KOLUgFd+88UrG9PPnhx9mME
         UOsTTghhh0fMNpw8eoDVLjbNhdyUfm2kxFwaPV1nZ4dbOOr2cxT9SRtVb7RMeg/C4iO2
         4EZumTEekngmaHtjjAIY8a+hORP8A/GFXRa49QjH1CKUzZXIJpFq8gpaG3nn/rPkX0De
         4hPw==
X-Forwarded-Encrypted: i=1; AJvYcCW6hYqSR0KLC8b2BMVrPz3fXWjfsOgOjFfu97HEZ/Jppb7+7BJmmE9+lqVHnQ1G4rQyHravKSKD1Q==@kvack.org
X-Gm-Message-State: AOJu0Yx1axd0epVJmiB2r3FnhGvGWf6Zeeu7x8dLJfQqobYRyTaVOjMZ
	Ooi3e3GDr9h/7XGPuCKWNM+60t9PkqiuPnpAmdUbw4Vy93y+tA+CoYnx6LESAvVz17w=
X-Gm-Gg: ASbGnctZnrkxROlFs315vW+rjhoMbgqOUnXro8TadYNCvHGI1p+2FJKkSW7ELBgm+SZ
	rsXtAKoLWbff02Pz3XWqQOFJWomkECQ6EUT/5l1M6VLjZPvBit8XOdKnE6RylkvJ6fh63hNFTlP
	M9UNfpoZKWa0+vQN2peYAmz8ME40k+edlkv8T2DM/XnX60nHcyjWZnUr2E4MSIH3gHqlORSZbTK
	o0K5PutLmDUk0K+fOFEcQ/yZvINkSnf2xIC2LIzmkkurdGdlDxoSNxEKkUdXjjVQOYwZzDl4O4S
	V2kH+AEQOwF5lWsO6ySRWLpnZLP3D6iMOpreKo+BRO2WeKzTNFVMkFO3rPjYKnjqYBRsdlB5kgB
	EG4GSqZScz5LcOXZHjZ0t9RUO/QRkP+8AJxw1gpJ7FAo7jqmfpdM54VhBh6/M4QSUy4ZFQHXtgZ
	JUWwaNnctve7VwvLHdh9Ni8rN4uBfEeKkcobTdYtruUY7M/NmaH1OliMNn4rHNRiszZaF3LPtMm
	HpRctLWDbn/C+OvGlVXZbYJdEb3duU/07FQEpPADkE=
X-Google-Smtp-Source: AGHT+IEiKbkHyTIPqxuiQK/s9jE4arlePP4EQ1uFjj4rccnMC3Ytmd/xdu5/e3ZeVXOoj3cegKmXtQ==
X-Received: by 2002:a05:6122:2222:b0:54a:9cff:6fe7 with SMTP id 71dfb90a1353d-5564ee53244mr5078357e0c.4.1761005340123;
        Mon, 20 Oct 2025 17:09:00 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55661f6e351sm2822882e0c.4.2025.10.20.17.08.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 17:08:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v3 2/3] liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
Date: Mon, 20 Oct 2025 20:08:51 -0400
Message-ID: <20251021000852.2924827-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
In-Reply-To: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jotzua4ky1xhecxhgeddnud645zexse3
X-Rspamd-Queue-Id: 13AB58000F
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761005340-131767
X-HE-Meta: U2FsdGVkX1+yOI27mqKLrCI8Ez4TXTz0MQEl+ZN6RWBA74pZOx4pCbrmiiSRYsuAMXJI0HwzN3O8vKAKYrTbL+i5wfnr9bCHl/cfI9fcXyXvxHXIfiCqIeD7ZlQho+15sqPLIGlpmfqsXYWstbfA06UPn4ti8N1cM1VhqGzAiptrL1Gz+60nL6hP6V0OiSI7omzcDy/ihV78+SVO52WcW5okOE7nwZjS3Lyyc8RBcbduCzLL5Bxr3H/XVpp3TFZ+zwuRh6ege05sdFuGG+oQoVlqdVdDCom1fZA8UTcDpJ0pDuZkKBwsfqOuuKjESu3M23Fct9hyp+fzSpCRc3pScQxN4A55MFXThsJKliw1+B3WZ+KCRi0h9uoKxxhL0jss5Yk2NZRXKwxdXH0YFfVaxZpjRR8eoc3A+AUhqQP3eYrm/90THj2jVHPE8lcspdYqxGNzeMHP8buv2PbH2jsb4MObhYBy/vV9nFkV002iLppOE2k77rsFT5k0VJfpp8n7KVSxYiC11YaffDXhrCQNB9QsTw3egmg+ksC37Ts0GcfJ3VUNxlwo8Vy49ftG127TxsAv8HaRv8CpnWJ6l9CaPmwOn4wsL/MhZereZ0dVUMAYnr7gNbxtQER32JJCBxHNCd1jyCefBrXbczNCmj4Nt0YvKv/JYXYaNFtRRVXw7yf6a5/2JGZ0oHw161bsQ16kRfgOx1c0DsaFk1Lz8J/ltlglqpQ947cp3/9Kcz0eb2r3sUW2FYQ10BcLHyC5tq3Iinh2sTX3GGy0+vDmn5u0roIDPf07h1TbqdeXY6wgFSl2V+KmG6jQzcEy40w10qv+yPrkyr7pOU7EU0CUC/zKA8IOjvr/Dvw9a0BCCAPRlaYU0MwBsoD23TgwVWlC6eTKxTeI993p7SX5eG3RpyZ23hD3dwmcUnl8of2MCGF0qiDq5Pu7GISVtMYsTq1UviCWRZQxrgnZSJZFVbK0mMI
 mSNsxsZ0
 tJMdHpLzarVv7xFHzbW3SmLnfPkGV6lM01Oy5sz5YdXsE+KHWfhUaByv08yUBuzDlzVVDCWyykfo9YTFkY/Xljf8CknUPy9gbyodPZetRUg1ATzymbceZ+gRONoG/E9haLGzR6IgSP5wmb4jhUxlcjwbfGJIwb2/5+/GBXmKLG9GSOSO2GOVZWnxTXoZgBPyGa5judHgpyN+lBjehyWW9PyvS+8BvqvZPWoMoFhuvzC+J8zqADUomXFbMV1xmxYFlor7JVbxOah9BvMUYEHwg6RTmFzq+JsTSLx/oICD+bW0b5a5tEP8+VgxU5mPROmKpWqMDmWe8nousoa6j/FsRpgzXIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO memory preservation metadata is preserved in 512 byte chunks which
requires their allocation from slab allocator. Slabs are not safe to be
used with KHO because of kfence, and because partial slabs may lead
leaks to the next kernel. Change the size to be PAGE_SIZE.

The kfence specifically may cause memory corruption, where it randomly
provides slab objects that can be within the scratch area. The reason
for that is that kfence allocates its objects prior to KHO scratch is
marked as CMA region.

While this change could potentially increase metadata overhead on
systems with sparsely preserved memory, this is being mitigated by
ongoing work to reduce sparseness during preservation via 1G guest
pages. Furthermore, this change aligns with future work on a stateless
KHO, which will also use page-sized bitmaps for its radix tree metadata.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/kexec_handover.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 7b460806ef4f..e5b91761fbfe 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -69,10 +69,10 @@ early_param("kho", kho_parse_enable);
  * Keep track of memory that is to be preserved across KHO.
  *
  * The serializing side uses two levels of xarrays to manage chunks of per-order
- * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
- * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
- * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
- * 512K of bitmap memory will be needed for order 0.
+ * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
+ * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
+ * allocations each bitmap will cover 128M of address space. Thus, for 16G of
+ * memory at most 512K of bitmap memory will be needed for order 0.
  *
  * This approach is fully incremental, as the serialization progresses folios
  * can continue be aggregated to the tracker. The final step, immediately prior
@@ -80,12 +80,14 @@ early_param("kho", kho_parse_enable);
  * successor kernel to parse.
  */
 
-#define PRESERVE_BITS (512 * 8)
+#define PRESERVE_BITS (PAGE_SIZE * 8)
 
 struct kho_mem_phys_bits {
 	DECLARE_BITMAP(preserve, PRESERVE_BITS);
 };
 
+static_assert(sizeof(struct kho_mem_phys_bits) == PAGE_SIZE);
+
 struct kho_mem_phys {
 	/*
 	 * Points to kho_mem_phys_bits, a sparse bitmap array. Each bit is sized
@@ -133,19 +135,19 @@ static struct kho_out kho_out = {
 	.finalized = false,
 };
 
-static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
+static void *xa_load_or_alloc(struct xarray *xa, unsigned long index)
 {
 	void *res = xa_load(xa, index);
 
 	if (res)
 		return res;
 
-	void *elm __free(kfree) = kzalloc(sz, GFP_KERNEL);
+	void *elm __free(kfree) = kzalloc(PAGE_SIZE, GFP_KERNEL);
 
 	if (!elm)
 		return ERR_PTR(-ENOMEM);
 
-	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz)))
+	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), PAGE_SIZE)))
 		return ERR_PTR(-EINVAL);
 
 	res = xa_cmpxchg(xa, index, NULL, elm, GFP_KERNEL);
@@ -218,8 +220,7 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
 		}
 	}
 
-	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS,
-				sizeof(*bits));
+	bits = xa_load_or_alloc(&physxa->phys_bits, pfn_high / PRESERVE_BITS);
 	if (IS_ERR(bits))
 		return PTR_ERR(bits);
 
-- 
2.51.0.869.ge66316f041-goog


