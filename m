Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3DDAEB4901
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:12:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1816B0005; Thu, 12 Feb 2026 06:12:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B2ED6B0089; Thu, 12 Feb 2026 06:12:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF216B008A; Thu, 12 Feb 2026 06:12:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8B36B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:09 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A5EB81607DE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:08 +0000 (UTC)
X-FDA: 84435540336.24.CD3C4D9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf16.hostedemail.com (Postfix) with ESMTP id D4B2E180010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="dDM0Zc/J";
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770894727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgM6lCDjzNogkk3QpfIH7skqXJaQ5cQhN9X8oPB+HkM=;
	b=VUKOxS06oWRCA+IalNAL6TB6HZ3jJZT8UVgoh4PnrcVKE6NmSDXB/0ExWDdmpTmCd6lWGD
	wDZLaww9qzsw+kg+6/VqTAISsvB7Fs5Qxn9VIPN0jnxXbWTcVhYIuAwpolr2y98PJM9jwa
	YCH3TmRpyHyXLoxgzQyUyChh1Y2Hgj8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="dDM0Zc/J";
	spf=pass (imf16.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770894727; a=rsa-sha256;
	cv=none;
	b=pV1QdsyaR7VN66zmam7QTt4WO1RLGtgvRpnGgxYCKKeaI2Lt7LIAV21D8TCLaq8EL9ivZ9
	SYXnSqNTNKjmg/WU540NAl5zOtl9LqQB3x1RzMqpLYLXxw+RWvi0T61Yj+uVBbjAT1ynXi
	w4iT+LNaumi2i03I5CAOvp8mqlclxj0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Gg
	M6lCDjzNogkk3QpfIH7skqXJaQ5cQhN9X8oPB+HkM=; b=dDM0Zc/JV5DqMGaARJ
	s4AMvreH8VlIclJkp0F0PTUdrrtyYuBa1ZerR5Kz5I9LjgzlHnFP5yGB2zqC1lpv
	QiKhLD4HjYd1fL41jcYcJJIgaDB0juEu4k+NOelOCCb+S1mzqmHn00MTZ3T70b17
	yJaRui2oIcOx+ue+4STSWHhDk=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCHZLl0tY1ptkijLg--.48890S3;
	Thu, 12 Feb 2026 19:11:51 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v3 1/2] kho: fix missing early_memunmap() call in kho_populate()
Date: Thu, 12 Feb 2026 11:11:45 +0000
Message-ID: <20260212111146.210086-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260212111146.210086-1-ranxiaokai627@163.com>
References: <20260212111146.210086-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHZLl0tY1ptkijLg--.48890S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxZry8Gw4rWry8KF1rGr13CFg_yoW5Wr4fpF
	ySg3s3Cw48tayYq3y7Ja10g345trZ5t3W3tayUCryfJrnFvFnxA3yxt3Wvyr42qr9aqw1U
	KF40vayrWw1UAFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0z_NtxJUUUUU=
X-Originating-IP: [218.203.227.87]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRdIlGmNtXeS8QAA3L
X-Rspamd-Server: rspam12
X-Stat-Signature: qutwnsn9d5wbrard3qzybtnewpqmjq15
X-Rspamd-Queue-Id: D4B2E180010
X-Rspam-User: 
X-HE-Tag: 1770894725-569028
X-HE-Meta: U2FsdGVkX1/WueXkioLmX+3OGZuuWghIQweGxKYr5cCKACGnZ9NZXZyTJ/el24otgm/Y9/MJcQ8MJ9c7r3xDDGwlszRBRWpCLKPHhkFtIRxN0+7+TmK0g4S8zVDd0yJD5FV66quUH/ed3IiIpa+u4jVftYLoKLTNlhP0AVo9dWOt7ZV9/7ngawmN9Cl2V6M7E08IdgXp2GsKvSUArvENQQBp6tYoepU4cGhvKRVaS+7KRmCj/p/FwwsPLxCGlb9CakztdEO/i7PeaDhiZ/d3OQnWUqeYNSfOvCBbxiziRPgw9AVJNmivprrT8gvlBPHnVyscx266a+41xQ18f4lJ4ILdremolwFYz7LiUEWJE2rOgon2CHHDWEBBbu1E7rB1JzpuamKfngxDQJA8x4dBvajCL/nqjRTP2NgAHyO+uuBGZZfBJ1VPcgPZTo+yHv6Jvhhosq/Z3Yck3p+e8OXn6fciCF89LSqtuYjTKdSKFAUvTDjeWqp0odBW8nuL6kyYb2gP3BDjQCXjdZts1CUYaJLfsCsmg4vTJ8ISVkNY7O7PuwHf2MHQ8J3SGnngLGvhmVOEAG7MXObIEUmNR8jTfGuQxrnp3mYPtEMbwQcNXxkUHTfxjx3GCSKxQyd8b1lKCjpek4xnD4661D+5zTFYsT0dM9+nAP7jCxMWmK4iervnagCCOS25jl3ozpP47RbdgiCzOiWqiYoxHbZcrELAZ4t4wv/xnwN4BZhPgxBk20s8+EtqXV1NLGLYf8TtD7o2nmAJUDr8gEOyL2kfGgdDGgUSrl+XucOL9Idh9k9q2T+o1XQU1CfdT3foltwfS4HtnwQFupPNhj0WGXLHW7dIWksDTjQKyNaGSueB8u8vU9ocYZUm4phW/Wyf0im3NRWMwXwl1FBVQS2gpsYLwIygSj9x4/hiw88sqvBCzy57EHQUdiHI/OyTn1qvBwizJhqymFNv9hMeMcRNbnvsBvp
 b85w71ET
 xXB86rKjskMZ8qLDnTS5DaqFL3yf8RNLnHJS4omVKI5Wp/s8S1KAN1nYlPAJcY+S67nA5KmyCVmmCBLD6IBaJ3pDu4kDP/ns3YhBaCpPwN+wV6qSUOORTJjWEY5iU8t8oggaJh76WBSWe3DcIzLcN0eT4gVbP50/ciqwKTlKTxrFyuilWefsshjaPl8GhkojWm6emQtk/1voB1iabnAZblftkEIHoVv3BF5iLH6F/PAOo01G+qjX0nIJzw+goqbwyDgUuUlGieH22GFECuyKO3jtkJX7i4HtRBbyCEleH8hq0grGbtdxykm1OfdjOAqiKX1LCWztzlQ1OhUARZZ4/9KJyqBT6shwS3GEJqFLnKNyJS9EVBC12JfklS+90eEV8U9OI32uiieoRwc4pZyiqN4avgh65biYFYwqKA4piB+FS2i5z4e10taYNi7Ws+u7gQ4/mMx0bHsW2KhgHJhalpUwKPmv7p6TEXfYunV5kqpXP9qIM82pmzJKdICNO8n8IV06ZKJORWkss8nQJxrZyAeWwRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

kho_populate() returns without calling early_memunmap() on success
path, this will cause early ioremap virtual address space leak.

Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 kernel/liveupdate/kexec_handover.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fb3a7b67676e..af82d8862dd7 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1463,36 +1463,37 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
+	bool populated = false;
 	int err;
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
-		goto err_report;
+		goto report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
 			fdt_phys, err);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
 	if (err) {
 		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
 			fdt_phys, KHO_FDT_COMPATIBLE, err);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 
 	mem_map_phys = kho_get_mem_map_phys(fdt);
 	if (!mem_map_phys)
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
 			scratch_phys, scratch_len);
-		goto err_unmap_fdt;
+		goto unmap_fdt;
 	}
 
 	/*
@@ -1509,7 +1510,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		if (WARN_ON(err)) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
-			goto err_unmap_scratch;
+			goto unmap_scratch;
 		}
 		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
 	}
@@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
 
-	return;
+	populated = true;
+	pr_info("found kexec handover data.\n");
 
-err_unmap_scratch:
+unmap_scratch:
 	early_memunmap(scratch, scratch_len);
-err_unmap_fdt:
+unmap_fdt:
 	early_memunmap(fdt, fdt_len);
-err_report:
-	pr_warn("disabling KHO revival\n");
+report:
+	if (!populated)
+		pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
-- 
2.25.1



