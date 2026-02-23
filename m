Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F8DFE98DEE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 07:05:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C3E06B008C; Mon, 23 Feb 2026 02:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7617B6B0092; Mon, 23 Feb 2026 02:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC236B0093; Mon, 23 Feb 2026 02:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A6F16B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 02:04:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE06F1B67CE
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:57 +0000 (UTC)
X-FDA: 84474834234.26.16C0D23
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3DF2E180008
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 07:04:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bIHzhTPf;
	spf=pass (imf16.hostedemail.com: domain of 3FvybaQsKCNExz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FvybaQsKCNExz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771830296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw3wTOQIfqz4K2I03v4IFEHinUKdB/xRwD0FbZ6/43I=;
	b=X6NOQ1p8EnSt1o5pvTUgMC0/Po3sbnpXOOevq/l3EAbOrU6atbcdgpVEipdZrdxYtB32HF
	XG9NU+Ql1iRaoCukNLl4Pv/7UYVO7okw+1RaRFh3Rnlr4WHQCeUJ5No0CVve/y0G3qUol7
	gNXqYTO3q23U4LFbI83za7Uz6ASUkAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771830296; a=rsa-sha256;
	cv=none;
	b=jDKiBo3BBaLe7E8PaE/CeC9lWO3FuecoUnYV+Y1XBMe5khFllwNm3T7i7/ijW8cRcuW1bb
	84mV3HtKUw0kmeLfIjODzAewcPzZMTlOyjr6Sj7PVqUhQyjmcTwtCyFY0WuIqIyiOQK/bj
	X/2TCVZwMLl4AZ3+yxt3qarRmKnc49k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bIHzhTPf;
	spf=pass (imf16.hostedemail.com: domain of 3FvybaQsKCNExz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3FvybaQsKCNExz71E81LGA33BB381.zB985AHK-997Ixz7.BE3@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3562bdba6f7so28769930a91.2
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 23:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771830295; x=1772435095; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pw3wTOQIfqz4K2I03v4IFEHinUKdB/xRwD0FbZ6/43I=;
        b=bIHzhTPfsS17KjYsQJbqnWcMXYntcDgJ9eR4N8/tHz26BY/mmpCxvlmLdKtvFigiGc
         kS8Rpd3Vx5AAWlpXZRtFdIScWo3JfM4AzDJO+UiqiEHLe5FpiGnJfjpQoiaEfjCYS0xR
         vGFrGusUkZ8r0liqUTPZKBBPfstucHPHFIZmf3N6KW3+9Vx4wQnxDzfncRgYvx/NZZei
         O2S52/ZYkxrvXlPhlvbBRWawEGac7DmY548KRnqmqZwW9jWXYByLg4co25fcLm27mOtk
         1FQZg0PiUzBQaAnYW9M0nJJPcAJdaAQTJ5ZyMPZNPjjEmmIkTHLqA9Tb/PjEHIAhkeuu
         byjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771830295; x=1772435095;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pw3wTOQIfqz4K2I03v4IFEHinUKdB/xRwD0FbZ6/43I=;
        b=BiJp1lkiVigu95RK565o5po+e7wbH19DlPvrL06ZFmMxtWUIkuqI1oDUaKaTMX4gQn
         843X0+isc+PWIIqDwW1ztvokhTfz0Sb25+A9rnon+kkBo/ykACyIqs+QNfU9+2kzZmSR
         ULrpQy7hC0ZCjjez1crcIQZWeg0CdoknoybnSTIKndKPvZVBQBPBwOyyOXiLyHGMorO+
         CndwL/o7nBBD4iODORFK75wpTZF7ox+8GeL6I2o3kKIshASncOrL8DSoFxMwnlYIg7hO
         vLG+NSjqfh7UKs1hpYZuQlmD/qRTB2d/vl9AGgH56aKknh0G5UHJIn+bjdhJZ6xF/XiE
         mxtg==
X-Gm-Message-State: AOJu0Yx0vvO+TD4ZZXT1Eo2JeQODw/YY67cH7ZDYIm9R8CRkzoxYLajR
	eHiDaVhpin2tuWzqdaut66WLfSC09f2iRtUU9YbOS651txY9lSEWyOTx+7q6WeQbSFF7le/Gft+
	h7jN/9AC7q38U7N3aiEOlPJLjU4hWxPcdXsYQy3FP+gYU+Zr5SsgLwwDfKs4julBUx2dWmYfmOx
	SXmvp7KDBVPgpXn+1R/RdJClK1+CRfPfUYY/9u4HwiT3dnyb+hSfDKYfyhcw==
X-Received: from pjbjs23.prod.google.com ([2002:a17:90b:1497:b0:34a:c430:bd91])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2550:b0:340:776d:f4ca with SMTP id 98e67ed59e1d1-358ae8d5d3amr5969350a91.26.1771830294754;
 Sun, 22 Feb 2026 23:04:54 -0800 (PST)
Date: Mon, 23 Feb 2026 07:04:36 +0000
In-Reply-To: <cover.1771826352.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1771826352.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <14fcfc2a032b85c7de09e9dd39668c8061742661.1771826352.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 03/10] mm: truncate: Expose preparation steps for truncate_inode_pages_final()
From: Ackerley Tng <ackerleytng@google.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, pbonzini@redhat.com, shuah@kernel.org, 
	ackerleytng@google.com, seanjc@google.com, shivankg@amd.com, 
	rick.p.edgecombe@intel.com, yan.y.zhao@intel.com, rientjes@google.com, 
	fvdl@google.com, jthoughton@google.com, vannapurve@google.com, 
	pratyush@kernel.org, pasha.tatashin@soleen.com, kalyazin@amazon.com, 
	tabba@google.com, michael.roth@amd.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: xctkgmehcmg7ioeicxphufucgukicojw
X-Rspamd-Queue-Id: 3DF2E180008
X-Rspam-User: 
X-HE-Tag: 1771830296-150232
X-HE-Meta: U2FsdGVkX1/0pRzuPlDJpHwpgj3GbnEX3X4QI3Sb3JUDaM5ZYmvZ6yAsFdQLF3yf8/VojWU1JGEiU9Gsk0UxvN1RStl0/rA2CWDTbfrI2dCoyEJc0rCbJnnJe8k6bQFtscfuUlKV7vvHCgzxaQyY7HsdrXcZvz2RarVBEB5fh1Yc6w5dkuvKgpmNifFJItFj5ll7MUwry80zriAE1I15yPJjkCIFH/95uyxMEL0n7nfXmasIzj18cDUONqpV5SG1bYEhGmxOW9HPyqll0Mmwbiwafl3j0RiDHQWQtMlnPixMe4awo8h265FapUBxIOqwoWXo5kbghpuaMPA4HaWYZKrn2k0jUXkgTinkxTU+0VfKJ+IicqFPu8H2MVqg1hNxU8UA5RfudMMTRE+i0JARcUR3A7CQPWadl6FJKkH9dt80rbWQErby3PGkQtn5vtOPM6f+sHGZMql0rCab5weFoEWpwnCrXmZIESVay9jOCXxEPNk1JkhyBvPDn2yyiMKLhjRPP9YXYFkFH35jXAyS3+1BBipKDLkSywR798wA1be3LcgQyNY8UIaCMOZmfYC3wIo6CVvwFpTTK/V+cynZXE8XF963nXvtlwrUEZgGwdaHixaYf3Sxn2SeZ1g/towH4rbyHo9E4T8Pf5g10g5dT/9EoVy1l2Zc7+HQocLShHWevxz0Z2oGQPYOv0lBx/rSQWAsppJQgi3unohPAH40qd16J5wMF0catFGYe2rGI8W+nrPg8i3AzuKJafjCR5VWTHnoGMVqQFcgwBwgHMKHPqqTHQ7SEPbqiXAZAWOXqn45jy+BNtYuJoD3Zy5ZGR+mD3r/JyLCpjqoc/J6l2neNk+qkesaAUfVPDZ8En73hmldLWAPCEzqkuuJOlDITcuzNzsSyUhuTD4jHTeEHycgT/WsotlyC+4fhKAy2RJZotZZjuDByjzPLm7ogidWYjA4zG7P9nIMENnvL4/An+Y
 6qDbYTGM
 2ws2cjCRTORTyHKN9O3YaMoV0a/sqRUnLXdURPIxc6QsyoKRP1P1RPkNNnZRqrpC36jjc5cJwy5c8WXABAmxL1ZV9pDw3Hk7iKg9/+4D9xQHNNTV3GuLm4FwfwgchdICckaKTvOqSwb/XonjzKk49aXrm1blM3RFxs/4KiVGNxjnC0e+iMnGqDxzff1mRPWP91Fd1CtXSHoeaiMPRmuCXwujDAXvvsuySoqDffsZ5gwq5D6zzlgQIhTvFE4TfOK0+a1l+A5nfJMgck6akqJrdvqlFlkF/H8Z8l49qqIUAHYAU4zytZBxQUZD7A27em8s01MGEvNzBrDnPylIQByzq9mVPzJgd552MUoMah3l2qFiERIfFIcFqryRKJRSOJBz4Mzdc7jHOkYLRdNZqP87rmcHP641y2P+1/huA0lBSUlhJMvM/3kk2R4b19V3FxJlMfswvicM+UmyQIFpoBVT92s7MsLczeJROzAIJKO6mD4zm4QYEKXNcfJB6tUZqcsfMC5u/lYs3S+eltd59UZU7thGWcN0m0hBQzG1Gm7Nut/qOZ2Ua4zjM0xyChEpSDMmbdSLZW3VvTGoemBEeTpFLToAy5E0eSNNSPgsgFCkMecWfKMw/e1KRWJ59mOwYnuuLkgjKVanLX48RkMDHYwAMWpJqSK4OE0ldsoEN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Expose preparation steps for truncate_inode_pages_final() to allow
preparation steps to be shared by filesystems that want to implement
truncation differently.

This preparation function will be used by guest_memfd in a later patch.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 include/linux/mm.h |  1 +
 mm/truncate.c      | 21 +++++++++++++++++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f0d5be9dc7368..7f04f1eaab15a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3732,6 +3732,7 @@ extern unsigned long vm_unmapped_area(struct vm_unmapped_area_info *info);
 void truncate_inode_pages(struct address_space *mapping, loff_t lstart);
 void truncate_inode_pages_range(struct address_space *mapping, loff_t lstart,
 		uoff_t lend);
+void truncate_inode_pages_final_prepare(struct address_space *mapping);
 void truncate_inode_pages_final(struct address_space *mapping);
 
 /* generic vm_area_ops exported for stackable file systems */
diff --git a/mm/truncate.c b/mm/truncate.c
index 12467c1bd711e..0e85d5451adbe 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -487,7 +487,9 @@ void truncate_inode_pages(struct address_space *mapping, loff_t lstart)
 EXPORT_SYMBOL(truncate_inode_pages);
 
 /**
- * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * truncate_inode_pages_final_prepare - Prepare the mapping for final
+ * truncation but not actually truncate the inode pages. This could be
+ * used by filesystems which want to add custom truncation of folios.
  * @mapping: mapping to truncate
  *
  * Called under (and serialized by) inode->i_rwsem.
@@ -495,7 +497,7 @@ EXPORT_SYMBOL(truncate_inode_pages);
  * Filesystems have to use this in the .evict_inode path to inform the
  * VM that this is the final truncate and the inode is going away.
  */
-void truncate_inode_pages_final(struct address_space *mapping)
+void truncate_inode_pages_final_prepare(struct address_space *mapping)
 {
 	/*
 	 * Page reclaim can not participate in regular inode lifetime
@@ -516,6 +518,21 @@ void truncate_inode_pages_final(struct address_space *mapping)
 		xa_lock_irq(&mapping->i_pages);
 		xa_unlock_irq(&mapping->i_pages);
 	}
+}
+EXPORT_SYMBOL(truncate_inode_pages_final_prepare);
+
+/**
+ * truncate_inode_pages_final - truncate *all* pages before inode dies
+ * @mapping: mapping to truncate
+ *
+ * Called under (and serialized by) inode->i_rwsem.
+ *
+ * Filesystems have to use this in the .evict_inode path to inform the
+ * VM that this is the final truncate and the inode is going away.
+ */
+void truncate_inode_pages_final(struct address_space *mapping)
+{
+	truncate_inode_pages_final_prepare(mapping);
 
 	truncate_inode_pages(mapping, 0);
 }
-- 
2.53.0.345.g96ddfc5eaa-goog


