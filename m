Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0195D29C2A
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 14:22:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16426B01AE; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D99926B01B1; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC81C6B01F0; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 949556B01AE
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 09:22:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 668651AD573
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:56 +0000 (UTC)
X-FDA: 84348929952.25.E8AD200
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf08.hostedemail.com (Postfix) with ESMTP id BCAD0160008
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 14:22:53 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmZNUtbE;
	spf=pass (imf08.hostedemail.com: domain of 3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768832573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9nuz806mp9+5PhIDWKxO6w4brkXaM9E/Fe3SahLfIE4=;
	b=Mxpqc9ro7sowd0HV+SBT/csmf3Ca71QOXRn3Ljeb+VNkv1DNvazJiAyTUXJ1Ccj9PkKh5g
	6fxLsfYUKtU6PfOvMMsndz6XGPkT43au3yJD1vKi35ZssrGzXheCPbKZVieUTj34HngTA4
	zslX88IYkiUzw4acvQxc+jBtUXSAS8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768832573; a=rsa-sha256;
	cv=none;
	b=RhE59+PFtlCDE3rm7K5Prt16IQopO5QZ9RmgRZWw96bb3VsVOQdbo4p6xtAWynQdfCZBCU
	KsgZujQXgrigJjHXc4gr6Dh0+ANuiyWLTY23OTe/jp9ApP6WhNwVEXP6BsdwkOM0xA56he
	M79Q9wTuPn1oc5pAAL8u76B0H18UNjM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hmZNUtbE;
	spf=pass (imf08.hostedemail.com: domain of 3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3PD5uaQgKCMM1vx12jojpxxpun.lxvurw36-vvt4jlt.x0p@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b876b03afc5so1039676266b.3
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768832572; x=1769437372; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9nuz806mp9+5PhIDWKxO6w4brkXaM9E/Fe3SahLfIE4=;
        b=hmZNUtbEiQRAOMNYPsBeS2XEJYPheWmLoQdGHmIT2G6z2/8Tt+HVgSP5DgXQII14zO
         DRprHVKfjWKlhT8Ues/K1qFhc1eX5qhRwmdqjproVvPej++DKYD6yuaz0EczXiSbb2BX
         loXpEoj7oiEB+ZlAfIAXyHDMmKk50e6glFaj2feCPyUQFnlqav1rLu/SaPA/oBDyLjc2
         RsP5X99DYeW/zsBccfhPhLzW3uDiRqxXTm8JM5gp8mslNQdWs+lG45Oen7VyAzCvuvoR
         TN61qEzFA0QyWknhGFvjS5iAxv6XymW5xGUvaZ+ZX9sooEZHlg2wTq5AL8Blttgrw33q
         xnTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768832572; x=1769437372;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9nuz806mp9+5PhIDWKxO6w4brkXaM9E/Fe3SahLfIE4=;
        b=OrgwMSSHKq7RYfWTC4hZjIEiuYA6HjRDmW2Ev0AvzbWdsZMgtJjUl9RSIDMA2JmOuD
         tUdbxKIgey2idzVOHQsslqnY14RfhGGu7b9RNSM6pq8fJu4cpyC+Em01zMuld4+JomQ1
         OQwz3bTdGnsknnrgf73Lw5g+FxI61swArWqG9Oqq4o4FWcfG495KKcpmhZcf31efs53v
         FIk2u3MjHhNqo6M/7egfxRkhNET1SpItU+8Kh+TrHTQOgyI6jDqH/AWuiyJd6u7OVp71
         8aYFxAqlqmiFmtVQhdzekjKjaTPK0VFXs+jUsiXTXj83v2wcgQff1KudHP2IDImdVi6U
         eTJg==
X-Gm-Message-State: AOJu0Yxh4xfOv9/5Cb81KNWMIyhKcQO8W+demGyoGKxyLKfpvME/vOa5
	UjvcRtX8HrbtW/nhxCJDt7uBe98eOWVPLUqeazdes5fPE6TduIQEoQuYiYmI4nSWK6CfrEkii9j
	3f1pTYJU64lvo3xF6YO2nreO/UsIcSaNp9S+lhwAyll+QuErL6ngd/tFS329/vOKO8W6It6ltcN
	PhnbhPl/+cmdS2pxZSxl/Xb3B32jxvJj594Sq1LCcrVA==
X-Received: from edrb16.prod.google.com ([2002:aa7:d490:0:b0:650:5e46:20c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7ba5:b0:b87:191f:4f96 with SMTP id a640c23a62f3a-b87932557e2mr1034243266b.61.1768832572024;
 Mon, 19 Jan 2026 06:22:52 -0800 (PST)
Date: Mon, 19 Jan 2026 14:22:45 +0000
In-Reply-To: <20260119142246.3821052-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260119142246.3821052-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260119142246.3821052-2-smostafa@google.com>
Subject: [PATCH 1/2] mm/page_ext: Add page_ext_get_phys()
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BCAD0160008
X-Rspam-User: 
X-Stat-Signature: 8et1bh8owgrspwwjhb7643mctc336ptm
X-HE-Tag: 1768832573-150906
X-HE-Meta: U2FsdGVkX18bdh0slRVMq7u/IOJRZmHEUd60SBIjXxpR2ukh7qrI2dDXXuFMKmmYXMUShMst86pOeSOV+8MX7nnl5dRRUAxElQDk2uoDonl3x6+XqUySySSyXImsNdNOQm7A8gr1A92GA+5/twFMTZwqqSwJNfUDzhNwCT6satevt0KRYZqG9jODxYsYK53DGw6nIaOiz0z4vBdIGJVmRrPM4OamSsfkdF3QqHbUgTbAThahXeldPCCTHz8rHVmseJ16fpuGNY8P4H1Rrjwg2TxJUL3gZecPz41AmO7Cg3YHlqtu2tIYN9TMXrXiyGSfNaGHy4Z5sB3NpqnaS9d/tj+0W7VVcri7cshOLqzFoR3oxgK34qykMIeYCO8lIUmAcXC2augIx+b6SM6BdvUZAZC340SI+ABOJjKyKJn0mitJ7dC/WHlbfjkh9dxBjLUHiac4mi4i0rG2vE7f+Q7SncpBMNTQj7sheaPFizLEwH6pVEB57mK2IIJq50p11YSH/WxkTLaynHRT7T1sbTgffmRcijcX0s6XH4/ajtVNoy2jg6+q1IBEe21eSWUT26mUNorUdnTctuLmVEDCnye3WAdMsYIEvWioZOxClkK/do28AaOIZ/FvaFv2Ay+OM5Z1Kv0IIWOgDkrqXQeVa93PMbwu3K1c8ZTB1ZgjpHnZi3my1YFv2aFQ2KZcd5yY2gmNGoyadvOQZB2svZ4+09WQKFTys1Iwb8LX2Kng9H6d/myNpZRAMdXvYg5olsetVusLJ8bH5XzhdHYFG2kCdUbrkm5+i6GUJzxWPy8hjnzPUciAwXfzBj67McpsYjyZLQIpIQDEY3RPJSsVbrXomXDYJGR1FwFzYiTJjbASNzu+ZjwYTzIbRXYl6J6gkjNkEGWIMkuH83gvSCi/BI770//GBzrrE85XA+K0jiamUQL8///8feAfnEtSxwbSve1Xf61NoEHCN5k3Jz/hku0QjmJ
 Zqp8Gt2l
 wJvHJz2kXjgu/9TuUZ3DSvv/6hO4uSVZyopr67zstPzmaQXnzASqg5CiWgneiFHr+kqqkAYPe69YCnyAIFkjjg5Dp7fql/Eyw+Ng3qthN7KhgqcKnRaEn1zHhfkiLDF2xABaxLwKQIQl9PNvo+OmQ6jr+u+oNCLzPtIrbxi7f+qNIjXm4nHzVCOst+CbmOhx4hAJd4jxOivgOLvdpMJDifvx0GNc0VF/pR6vPCpuOGzwnBj7HTaMm0rpz5Z8JFVeMzoXrdX9aUWrSlz19g1armvRkfvfmTWyT74UQbxqhMYmoyg3uqKRM8D49eHOFtaBeMBsL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the next patches, IOMMU code will add data to page_ext.
The IOMMU code would operate on physical addresses which
can be outside of system RAM.

Add a new function page_ext_get_phys() to abstract the logic of
checking the address and returning the page_ext.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 include/linux/page_ext.h |  6 ++++++
 mm/page_ext.c            | 23 +++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index 76c817162d2f..bd373496e166 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -93,6 +93,7 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
+extern struct page_ext *page_ext_get_phys(phys_addr_t phys);
 extern void page_ext_put(struct page_ext *page_ext);
 extern struct page_ext *page_ext_lookup(unsigned long pfn);
 
@@ -215,6 +216,11 @@ static inline struct page_ext *page_ext_get(const struct page *page)
 	return NULL;
 }
 
+static inline struct page_ext *page_ext_get_phys(phys_addr_t phys)
+{
+	return NULL;
+}
+
 static inline void page_ext_put(struct page_ext *page_ext)
 {
 }
diff --git a/mm/page_ext.c b/mm/page_ext.c
index 297e4cd8ce90..5fe65a0ac4f3 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -538,6 +538,29 @@ struct page_ext *page_ext_get(const struct page *page)
 	return page_ext;
 }
 
+/**
+ * page_ext_get_phys() - Get the page_ext structure for a physical address.
+ * @phys: The physical address to query.
+ *
+ * This function safely gets the `struct page_ext` associated with a given
+ * physical address. It performs validation to ensure the address corresponds
+ * to a valid, online struct page before attempting to access it.
+ * It should return NULL for (MMIO, ZONE_DEVICE, holes, offline memory)
+ *
+ * Return: NULL if no page_ext exists for this physical address.
+ * Context: Any context.  Caller may not sleep until they have called
+ * page_ext_put().
+ */
+struct page_ext *page_ext_get_phys(phys_addr_t phys)
+{
+	struct page *page = pfn_to_online_page(__phys_to_pfn(phys));
+
+	if (!page)
+		return NULL;
+
+	return page_ext_get(page);
+}
+
 /**
  * page_ext_put() - Working with page extended information is done.
  * @page_ext: Page extended information received from page_ext_get().
-- 
2.52.0.457.g6b5491de43-goog


