Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FD76CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C07EC6B008A; Fri,  1 May 2026 05:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF9B6B008C; Fri,  1 May 2026 05:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACF6B6B0092; Fri,  1 May 2026 05:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 991B06B008A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 566AB402F2
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:33 +0000 (UTC)
X-FDA: 84718378626.25.3EA2529
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DA9140007
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cCr17hkS;
	spf=pass (imf12.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D3bCYUylpNTAuWyS15iXLK7eGG+AcPbkT8lStAYKXTI=;
	b=533RtbufhOa4dcRMzQRTxsLS+Nh2Jg+CEJlhnZCsSh9z5/cK2TpOkpfXqOpQaMmf+aLWHU
	TwibxVxdSPv8xpjw0G1eL0QvuTONrrbT4Bzw8u4QYq3s/iqT388uZhNbykZbcwtZOgmFo4
	7yYw11vVESo6pE1ZIdEgAad3Sc3VUHY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cCr17hkS;
	spf=pass (imf12.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628971; a=rsa-sha256;
	cv=none;
	b=2+Qn7huLIprt6O9sGycfQi2XGUVkxkNLZ9vb0f8BUjokv4ERj7OU3Ekzr9MksE57VMAL+b
	cW+eomOO6wZh/r3ZhBeJXhTo3vOLOdiPjyzew1biEdlLB7Zzs2GsjysJCJscLk/L1u1fr+
	XuibQ/42x08ObXZxO1gVKeQdx8W7dIo=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-82f8893bff3so881438b3a.2
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628970; x=1778233770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D3bCYUylpNTAuWyS15iXLK7eGG+AcPbkT8lStAYKXTI=;
        b=cCr17hkS13uJnhTfmCumJGm6EzT/hu7YOJ7pcOZbbGfvfQN/+xZhlI5aQT1KoKWTiz
         BbHizNRzma7Mz0zvlFcqrlYLkxLnH9r27+0vEu3oeRDZNLRYd/GRA4fb0RYkWiiaIT/I
         pJcHLA5+fTPYmgKjkV7l8v1FhPSXjO4cqTh1nCid+F/7PA2Ql0SlVUDf2CEuEqCqtd/c
         NYbVQaXhS+N5d2P80iB8juSgXju36M7Sz3RudJOARjE3XPcaowIfG6ruah5PrKZpGLDX
         wbEt93CGuMF1xpxyOohRq8NBR3xk6VbC8+bdMfqVANfH0TlkNEOEbI4IrZWLUbBbmjyg
         guMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628970; x=1778233770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D3bCYUylpNTAuWyS15iXLK7eGG+AcPbkT8lStAYKXTI=;
        b=nFQc0yGvJQx2GBUefs7NxvwyKOCZQwaMM1NTRZf5tCsQLUp3SeCkDFaQ6tl9nCHyWi
         tqv7N0pWibdYYGhXQiA8oqwFPpc4bTpxWhEqBa25pUUOfhWtj+2EnVVEgwU/HXBh56rC
         MkFiKHouXCTGh48wSTERZ/SylJ6voebaTzgGW7nIUoRbso3qmVkvu+k6PvmVp4hTTwD0
         8KQiVf2QI/klIKdt38sPYccRCfSLm/vaDIND7258G7KLqpCehNNTvjms2Ms+ceLk5Jp4
         XqaNxL6eJn38ESBdETsWdra23AlKhNqTCX7XfRDFtx9o6zWTF42RBOu2U8wj/Ce5Z8n3
         FqDA==
X-Forwarded-Encrypted: i=1; AFNElJ8uv8+G5LO+InG5KT0fuwGB0TrX4UjDLaYHYe4IZP1p/jApnQb/DBBzFui7SojrrwQzCQEJQja4CA==@kvack.org
X-Gm-Message-State: AOJu0YxZwEVlrtAhQ8dh9+yMvOG9c2SLEw/6Ejl8oZmS4feNRaUvC3VW
	Jv2KXydHcpPEY5LVQ+k/Mj2mCJlnU5r12K1CJPUgkh+im0/Vi/SsD88Z
X-Gm-Gg: AeBDiet9nZJX8TXgIgdftA195qHDE2bdFQ76csDQKTSOfRWyNU0jXmNN7aycoB3VXYK
	JtcPNcYub4lne3ImN1QlFY6BK/XTYzEpzX2TWd1SD/2/3kNyusbfHm051NXbTUnIOX0z3gkBwk1
	9XWkvUWQGF1c46Y20L3hGVf5Rib7j/wMyYg8x2IrGW+z37zjLX8/9ex0NOMXejPUNSKbF37eZCu
	vqyCVEPagarWtpstgj/mNQWk+umikfd+UW2pl4eBIxhNrpO/jV+XGPHOkxrKV89GEPxoAseI4zi
	Wkb1xk4hQfBiOISqFTnqp8WO5/1B5PrWSRFQkmnLXNDmZ5/BtbXwUyz6W+QPvCz/1Ub7AD6+0XG
	s249p0W+iP+Sb2px/mmZYDTqejMUO45vAHJ0WKojMoVS1pSed3ydzu1Pze2zHGT9ilnX+RQ6RBR
	/gxZtIcv6065dRmdxSyNhO8giSBVpCn6m9mzYUug==
X-Received: by 2002:aa7:8886:0:b0:82f:9985:d4a1 with SMTP id d2e1a72fcca58-8351a58db50mr2518784b3a.24.1777628970155;
        Fri, 01 May 2026 02:49:30 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:29 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RFC 1/5] kexec: handover: add helper to check preserved page ranges
Date: Fri,  1 May 2026 17:46:33 +0800
Message-ID: <20260501094637.38650-2-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpg41nnkskdgi9xcb315mphirt5btbgk
X-Rspamd-Queue-Id: 6DA9140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777628971-123624
X-HE-Meta: U2FsdGVkX198WIRWE0gwumeB5jsxSJrZdyjCdjtjS3JhjdVCyR3NbzKattEWiznPdRPQPz1H7P1WFO39W7smTKjg7KROioMKWpeq6ed6UFDnG/taYOZupQZ4ZzhJy8UZXQKpCwmX9p5thc832s1G+IQV//106InNn5JeVtNlKYzEldrlIOvmSOuXwmEYclarOilFKMQ+CPxbMclY2D6y5aAs3qicgvR3NkCofb92vSMzYdL+HlCX0w0eUZAmLedMerPUcu3nL2BjlxUvFPY9PVWvP6cqxzXwRmkRhF93FKNWhuATAdV1x56pylcvdvq5tm6uVrEk8dIUiz/HOkyVAcFCPhpWR4DTqYBjXKpR02pnLJtb6kEMmXzaGAcco9eZex/kFfjlXSaT9W6TCpU2l03aLvWS0+erpZ4rGm6dVjA9aBRO1LqwcQZQsHEvde0o6pgqgdHfaYzxMii6sRfMImZeyLNIdIbQcGHUaWBbko8KEcKCKKQzoYrtDtwYhC8KYT3R03qAD+TrbOUg8bFZmBHBcEbUYqNVmndHL6XVEPuxkJ/UX7r5i+MShR7gSx0zl/83ZeMqoXOCg10SOdqULoCI3VpkiRp0w5i1RJlna4d6JSIaE1TLaKGkRMB5865vyuCQd1LvF5cMv2Q32v8N9CFpRlsjq27t5BZ6fPZ9AkQkuQXn9wPc+CuxuGBc8R916tXHBw23QJ2K/7TBuYKZ1uRdUSAmxiBKzDSVCUDht8cq77NyIdPzIQ/n/zxw5y0ijkNYU5lxsuRowdEeoOq164AdiIkaxRStQwacOwML8PP9sGbKEhxy8HEcXmYR8H4ZqiMnNv5i+jzp4bMIC79gIauxdXnK1NlCy2rws7oPQhqLfUbV2hVeEIhGXkfx4bO3hv4FYkgSOg4fHEK9r7RDlcALldF/d8Szk8rjq2DAOt5fezx3YSiOqeAVsjRyANRo8PXXDWA3e54DH15l0Fa
 /nEK6NrH
 5zhYV/Qovj4GDu2azTUC44y8mJbp1sQy83xy57bMMflM6FUwAr5rOz1HESwY4ASfWu+T2SliZFP317HO5nBizWTlLPzvnfPaA+vWjir2/M0ceuJcIPJrlCKEllXNsMEK2HMejU+Qcawh/77jhcuW7dtPMQsm0CcWOxBMfP/4k53Wxcf+u7HfAOaBKFvXok9T9quobP+yLTGQpXffXXf1tRDG6a3jf8k9XaQwaSWornj05gPSCZTXfIxaST+sbT1hi3qL7geTctbSiMbOcuj7ty4CiLL4eWlVmS8PuzhsstY3HN0BRgb4nhSzBSDHmqG0Wd/tinoXEjMh2w+gt7ZNkkyEw7sWoGBp7OwBXmfTBwGQBs0xKlNFLr0Vr4Q914MSnunB89dH6BHCpje3HsML6j/dwBel6JvDlsc7OBpDwEYx42CFLPNhyoqqWM+MUVU7YbRBOYG3mORcyz5c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 include/linux/kexec_handover.h     |  6 +++++
 kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..fb09943ab232 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -19,6 +19,7 @@ struct page;
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
+bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
@@ -51,6 +52,11 @@ static inline bool is_kho_boot(void)
 	return false;
 }
 
+static inline bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages)
+{
+	return false;
+}
+
 static inline int kho_preserve_folio(struct folio *folio)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 94762de1fe5f..fe9f11190705 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
@@ -429,6 +430,40 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	return page;
 }
 
+/**
+ * kho_is_preserved - Verify that a physical page range belongs to KHO.
+ * @phys: physical address of the first page in the range.
+ * @nr_pages: number of pages that the caller expects to access.
+ *
+ * Use this before phys_to_virt() when a physical address comes from restored
+ * metadata. It checks that @phys starts a KHO-preserved allocation large
+ * enough to cover @nr_pages.
+ *
+ * This only checks the KHO marker. It does not restore, free, or take
+ * ownership of the pages.
+ *
+ * Return: true if @phys starts a preserved KHO allocation large enough to cover
+ * @nr_pages, false otherwise.
+ */
+bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages)
+{
+	struct page *page;
+	union kho_page_info info;
+
+	if (!nr_pages || !IS_ALIGNED(phys, PAGE_SIZE))
+		return false;
+
+	page = pfn_to_online_page(PHYS_PFN(phys));
+	if (!page)
+		return false;
+
+	info.page_private = page->private;
+	if (info.magic != KHO_PAGE_MAGIC || info.order >= BITS_PER_LONG)
+		return false;
+
+	return nr_pages <= BIT(info.order);
+}
+
 /**
  * kho_restore_folio - recreates the folio from the preserved memory.
  * @phys: physical address of the folio.
-- 
2.53.0


