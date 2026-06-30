Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C8F0C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D351D6B00AC; Tue, 30 Jun 2026 17:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5326B00AD; Tue, 30 Jun 2026 17:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5EB66B00AE; Tue, 30 Jun 2026 17:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6326B00AC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:18:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D808120138
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:58 +0000 (UTC)
X-FDA: 84937843956.07.CC5D4AD
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5C5CF4000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:18:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ftSKaMGn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782854336;
	b=WN7Km0s4LLR1AiBvNt94yiO4ORMoZIhWUWAmfnEkMzWlKqWqPnP33hBW5iWkUKfwchXwl3
	flPCNW6ZNqmRaHc73ssLWYCt/jd7DxYXOTuzQw9AdJYYAx1PbXlVyN7XfsXxECP4+D/TMR
	j3/9/BFWVMIBCqA9biBp6ENNzRvmTEU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782854336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0XGoZmURbYPyoE28BDme2QX7BFop+44e7z5jxOHqkV4=;
	b=eNYqMdS8tI8UTamrCoZoctPfgYTW/w9PUdcTQMnaUinGxpVRn/Qd68YA05pYBBCngN1tSA
	iu9fjTXtEh8g+RA8S/uN6BCAj90poNtSeq9JgUIS/cBlsRsLA8+Bc+uCLPZlgGIM597cs0
	vS5x41fn+yb0GGOgzoW4J9CINTeeZWM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ftSKaMGn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.182 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-92e6391b114so137291285a.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854335; x=1783459135; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0XGoZmURbYPyoE28BDme2QX7BFop+44e7z5jxOHqkV4=;
        b=ftSKaMGnw0EPoDIf+jdCJCMLU09Jh5KpHJCjqUSh8ly0QKBcukGpyMqa6jbTdqrY1O
         qIKRwoQoArkjn48knGBifFxr5LEzPA/e7FFhHDXIdQhBMZXLkOlpKfV6dRv3BLL9q3RY
         /KpbU0pvPFy3XNSAmMYeQAztIXirqGNyquIx3Og/R/qDkcBEHGoVEM8yNpxGZPzZue5d
         363DKEp71FndSGGOMfBNk2WkaLlH8gin3VPKI6EOp52tMZojPzqBDD+jxwIy2l42bLs7
         bE1Px6oQFyLcKh7JKUNgaQBd3mUb6AN/BPqe7lg0mMHjEDUYLyQqEC0v3V+ywnMMOo+N
         DmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854335; x=1783459135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0XGoZmURbYPyoE28BDme2QX7BFop+44e7z5jxOHqkV4=;
        b=HBalonQHUdmVG2DpkOrDMBNBS6flOTAK3iBFOCrUaDyIoEw3y73ZGjqYOsgfrLiVxd
         A4qS2VOtMNhqN+PK3wiSe6sU/ItEWBZ4W2ivJRhbvth8h6BGGmfhaYGIyNotj3nKGuHz
         AhXIz/CsbILP7EUfWrXUcBg2F9Mg8c0HCkm/5XABvOtS8qNGYUfVKygj6jvi33wLuUWM
         HY+vjudk2y0iXLLKRqbXpEfrrz4dSsKoEwuAMybiK/Ne8dxd3NM5xQXY/jk+VBlqxRdz
         UGsx8oL1EawUJLMsvEIV1EGRAcWgQp4PaJlSCsaSwvwFAPGzjRRdKbPiD//w8MxUBV2x
         8fkw==
X-Gm-Message-State: AOJu0YzMdXGjDUUUiXZWO1lJRfGcT3ZQ2+O/wF4SBnjfEvFp3EDT0rf3
	Dufzmnz5MNGa/7KgOKgflyO5We6doCwPo+fFbG3GFTvs7yK2upvYwKimWOQnB87V2MaQ/zGReaQ
	eeQdA
X-Gm-Gg: AfdE7ck+yvazJ05UjFc6pSPgTZOY6Jnyz+t7L6Sh1QWSthv5tT2Oc3dITzhX7UNjakj
	ucFiqtwcLZXvDh60rnCz6khH6JRxBKg+2lZnTLdghuXrYDMHHpnjbQCoK+geZAGlkBDqQX4it2P
	Q0JHzfy4/dPR6mvZy1bgD5CGGzXj+/yGKslEhVc3WF5V2YJdLmXX3iRWZLgzFiMOw9YN6/yG8Je
	9oFori2Duz7zVMZ+wU2xCggiY7jlxxlbDszjl1kbqgLOji/sz7NTDTa7D4CpQg0z793unW2JyKl
	u4XCRSuRVPgQ9yIRlymTb1n8V/MR66ye5pTeqpc9ExZwrVzFTfB8r0rI3RxQIE3PltcJzfpCu46
	x/5de3YT4YAa7YzoS7IRV1JT3h7IAbdbEzp1bkZ/uQaVw9jURmNHBrcJEIgzwG9X1lwghZW407N
	ACg024qlu9m3rorozmOQGjrDOkqWafDJSOujNd8FQco2r2Mqfd5sMdqmKZLhxipmNEqnyDI+m1B
	Q==
X-Received: by 2002:a05:620a:4721:b0:915:79c8:ec92 with SMTP id af79cd13be357-92e627931e6mr816969285a.37.1782854335567;
        Tue, 30 Jun 2026 14:18:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:55 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
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
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 04/10] mm/memory_hotplug: export mhp_get_default_online_type
Date: Tue, 30 Jun 2026 17:18:36 -0400
Message-ID: <20260630211842.2252800-5-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5C5CF4000E
X-Stat-Signature: qgzunmbh3y3mhurr91pkezs9y8ojpn1u
X-HE-Tag: 1782854336-584308
X-HE-Meta: U2FsdGVkX19oDrYV0Qpw4le5mHmrqiG0FuEDR/qnTv2nx3DZdD5RrFpwEEPHsi9zQV0WtyP1hKPmiXNI3M8enQCGLsApW8NQPu/ZZr0LwIIMcEsYL4B3y37C0t6IhQaDTtVshSPula6t9NG96z5o2aaswqiruoLSzQ0WQzCVbHVgq0SVf9uLmnaUH+6dKYZ6q6u6dZhSqqb4Y906A5Y2oepCunBoC7GJ4QFwVrXtAviNWc7+T4P/faGh9j7hGRzncCYQWi8ZB0dZSttvEENwipAU25Kl143RJUmvy9fwKrJrHElpOyX32rU3mjbxfTAVOwONxobzWYZU2otnenfhmmGYZBAa6kqO86/MphATSJoqqRXSGwDcFbiOvlXBgcFZBQM0LJ4xsWizuo26qFuMyEQFak7+j+42ag5VMHOyf3NNcbV7iRziq+vqZ9v56T0HD4U4j49Q7zFwfLViGaGi7JakZBWx17dAltnNqNcGzfzfPUZNLGc3wM0BMimvULC7wErvl9ewEEus2CwVTNkoUjpySh0QhzBbs3C+JkKqqw9DbVf79sD8oAlICu/uc9BNQdoszJC7gLeBAHc2RZFG1f8MP+3Cydo/649rR9PnP1SmQvUANC97V0AOoCsfqMze2Kp8QN0yKFHT9ueQFIi4QNrb6K5j8m+b+oFflFn3NBCOev1+omko2py/IfiUA3KpwNNtv8yecVS+aZrfG7zlTjOfg0TP9bykB6b1S3Ih0DyS6t2lqf7Lkw9PRh8t83+V0RrWhKv/vxfgWDRQP+jn0eFN0+SeRyI00XE3p/0XSLU5m7+WamPOnxCSaIACAoeSKcbHdYvWuOxsWJK0Buir/HUB9rhwoNIqjBFEjTfcav82tISuv7eiVub6D5DAr/2AqfhC8BZpctLT6smM4p1WrGJ6tns9iWw8iGm1vi9jC1Nz3WQ4ALgUg1sGOHU0cvtvGMXKXoAaQa8JjGI/+84
 f6fqH5TP
 YIjWuPyungcaKCLipcMG5SJ0mwiEglOlIVtP9obykwuWGGMCkInszlUrHhBjWRleVBCm60blfJjo3QEyjVJ5CVatvf6CoZTEtaLmBzLstzJORpClClV27GaogKeKr6qoQJc+pzSXAqpQkdd6TWDSay/kqbaCGonmzW+ANmrHYsTRu/r1C12q+M/AmZM3kg2Uqm/TbBUmdoKL796FeOf2qj1kPcJy+omLEFfuPawL9xbZNlkNW4EVhoHsUR9tr1lj8WFcinILWMJCU7u5tVF2JJ0Uw8glW0bubCteF6mQxW02OY0frIAk/YIlkTCLthrqXJYzVGSf/8WjdN6W/dyaU56OuOJBeHRzNNoK2vnv9GTZ1ihPcRhh9YkTHiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 5d4b628c4a1f..4d51fcb93a37 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6833208cc17c..494257054095 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.53.0-Meta


