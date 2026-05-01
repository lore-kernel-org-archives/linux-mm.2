Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B37F7CD3424
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 09:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F57A6B008C; Fri,  1 May 2026 05:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A7146B0092; Fri,  1 May 2026 05:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 095386B0093; Fri,  1 May 2026 05:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EE0A36B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 05:49:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7ED63C1D41
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:37 +0000 (UTC)
X-FDA: 84718378794.06.74B9F9F
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id A3A3A18000A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 09:49:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zq1wXtHc;
	spf=pass (imf16.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777628975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQtRFGksInkULS0m8GB/jr8IDzzr0ObA1EgynOw28RQ=;
	b=SNJSc5hrDz0PUoutEeuPYRiXmsVAIP/uWv4f93gn0HJSSYCDdTqbl8aMPW0a2Q1yvt4Fpf
	bZZjrmFAPyMeAn39H/ZWmBccxbtgysxVuVknJBxbK6728ghx4wjr9Ak7jeWrBoDip9h4yK
	3t8fIeclrZqq5RKcTneTyKVsqKrc9Vc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777628975; a=rsa-sha256;
	cv=none;
	b=W15Ld+aDpoVK0JwAjhVdqoQ/LhjHeHaX9aRto6h0iSIjNuk5FDulK0jvoM3yfTbHABNrLs
	pVpysCddBjsYgi5nbgv3dKj/vRr/50ubDSD7b1Ahko//pQDROxS1i9WZjdseML66slurTO
	K503RjaUs9NVs9avZx5ljJxR6KWtOwQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zq1wXtHc;
	spf=pass (imf16.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-82f943870baso830044b3a.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 02:49:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777628974; x=1778233774; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cQtRFGksInkULS0m8GB/jr8IDzzr0ObA1EgynOw28RQ=;
        b=Zq1wXtHcvf2/s3Q8Osx7PPUS3xDZLuTrQ2EmFPX0Tm+NKal1Lnw9K9WT26huGRxAzj
         5kCnfwhsMVo8yVEO3yyckp7QCyONBfaRVusccOVbBiYeO5mcJltwTyILKekFufuxH5k7
         bzr6vcOHrljWGL0GdFdeB6qDMrmjkeYde2VzB8LAHitA0TwOHKe1oIBPUwRvdvC8z2Q3
         hKcgHtfcN1wiB8cgGjtdu4Y5qMxcVHP4R+QavHa5frJbqcVzpDnhXIH1oxn5OlLGCoaa
         bLLjQWI1H0p8HBtQkeenFdXLqReVz2wj4/VjnRwST+u/1L34cJPI/sAqBIjh78P9SUL1
         pC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777628974; x=1778233774;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cQtRFGksInkULS0m8GB/jr8IDzzr0ObA1EgynOw28RQ=;
        b=Z5jpL+hur5QgCqfWYl2jBFkyJPDJFq9D5CVf4daDrzoTAUdCROcmY6ZgkxYiB7sWfh
         upYNie5vO8pYQrI5VO+GJSN4spdhVD6me4l8z1E09XuvWudfRoVEDU6cTWPj9vlF8sem
         9wj/qktDpz+ljsGj94ZTwN2YXvnUuX2fivS95QtjewMceUmZeBDGs0xzmfiECyiErfWm
         uWAex6EGknEitWYB7fatdjxtuhYQjqt7VM3Yfb+fRhBgXBa33fW6Q8BEnEQ89IypVZYv
         X5AhJv/v0zW3PyLu9WcUVGEPFlpbVxGfkLGgT7XjzL71QrYkchyPpHDXdaT1NJThV7Jf
         Kpbg==
X-Forwarded-Encrypted: i=1; AFNElJ8O9E95PB8rspjGufWF1i27VVyfsMgvgNiMpKiu/AGYMrk1KO03zG8+kfk138xf1nzvDD7ARI+OEA==@kvack.org
X-Gm-Message-State: AOJu0YwwkeGvIOYjg+sxeA4iipOOx9t8y281COhlf3ESHYHbFmg6/ZpO
	tv4472PkJNSXNBRp8qP9lRhWbRhhthRI9Wk4Xo07CKRmpOHxeb3sqBlm
X-Gm-Gg: AeBDieuVbWy9Qk3P0p60CyfwnJ05EI0GDCutZr2VpI0AW6K58ApwPjGSd/kkQNcdJuQ
	O5mLZA2Hu5UwnKcYWs30J900r9wH1TrU9M9DZrmkGF7za/dTqm58rujQX1nQ47BQWqPTibxQRRd
	seUPov6OIRYugikctlsIab1S1YYLOggpbcedi8l+wL1WV6Pues0u9DKTNrzfhGLqCQrv5FmHj41
	9GltoXDk9xQqEFymg8LUUZ+iaLYc/bW63klyyLDB4tcYGvXqXxrteLtwHYeZnOuOFBkUVQyxJcF
	NXg0ryUpmz+q78Xkf6s6VwXHfN9YZatq+KoEC2dZKtGIET0xUDxxTT7P+48TfBHYBkFwA30M32A
	A3b+dyAUd6ONoKRKpgCKH2je6tvcupYJu02dmIjXCLmBFtcwlo6uMQsyDompninX098/RXxOKr0
	2yPQrrVGEnkho6hXXqDLrbjh8a9rj6sXcGrUJvRQ==
X-Received: by 2002:a05:6a00:4b54:b0:82f:37e3:ae82 with SMTP id d2e1a72fcca58-8351a63b46emr2481911b3a.44.1777628974533;
        Fri, 01 May 2026 02:49:34 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:eebe:247e:613c:24d7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8351582dd55sm2042729b3a.1.2026.05.01.02.49.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 02:49:34 -0700 (PDT)
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
Subject: [PATCH RFC 2/5] liveupdate: validate restored LUO FDT before use
Date: Fri,  1 May 2026 17:46:34 +0800
Message-ID: <20260501094637.38650-3-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A3A3A18000A
X-Rspam-User: 
X-Stat-Signature: bqie95sn6stayqxnhcjh5fc8cu9r74x9
X-HE-Tag: 1777628975-36751
X-HE-Meta: U2FsdGVkX1+nUwptOUIF6Ik7m5QfGsn3Sjils+5ijQC8gqfKs8fJGWF838n03vFfR8PqBYpe401EgxCYAM/EofAZI8uP773uGLSUHytmmTKDTgRrLA953lgJy7ajcNSvG/g17HdbyjQnbwQolEvyZOxsD7tAs656QWkLOKnSzbVRg2NcICFYvKYD2QXAUjki4kaF9CGifZh/CQi2z+6ZQV481MZ6jDeOqiriiDORoo0t88fwZd2N2wVjdnusBR0/+hreiAlopYE4ZeT8AMyIKt/dSaZ5Kaxu+Vv3tP7Rey06WeLjN8oMo4G9iYradMX6jT1jT5/SO9EsAfiStfQ9+0fK+zLUNf6xuk3J1peV013vrRRuSZQna/aNbNn7tjCgv7Kle92+RYiqGk8eUIyW6HcAA0ypTnWccprYY6TE8nwduoTmzYWB06HQpyXGW/rakQCG2dChmWsdyfejlzzyCQa2FH4GeKoZGTBxbfDj4HuZqHVeBvi4bI+eqjBROMMfQRK4xy+hRtkKrSZ98XLjwsn22fUf5uJ0EMGAD5PlcDtbp+TqB0lT2KAevXUQ1hXsGYilmefOBpdz8NXzKm9TkXt5b8pYSWu7luVILqD/Qbb0yxgC0CxFQIjE1rPLKONQG0nRtnm/4ex4uezJ+r1apRLKHZxSw+gkcxMIlXruDuMabqiJxYnlZ/yAuVqa6q2t8EBHtHgdN6wogdBNl7kudLgjIVyW6QVxqNpyDHagbGsdqlDDsjOPRxaL3XHv08EqHSTiQ1x0WkWC+8oAXRYb6/nJyaxn29QYfLLV0FZmR7TQItaJ13JMaY3x/lHeSOhSRWFTufgLMRgVTBlcii1qsRQYpyW251KcmUe9gcsgiVyTS8N/9kPrUm/mXgBEVSUw9c1rQJcHK0Xj6BuoS+LRDHpfViKMdFUgVsExgGGt7AvvrLE28k/5+OeWNAGNTU8m2YoX96AeQXpymQ9HNMz
 JXThvPCp
 gwEGvw4bAFHoOmYpfAbm+wVnxNYSb4i5QssbVKf5tcPEjWlG+mcHGANlhwrcHneC7AteLte58nL1f96htS7kCeIO784IuNDJBd7C6/I/AbOSgVxSvGokZhGJZdsxhbMLcGeJiq1kiomwPdPzBie+1YPdGAjq/qMx5uM8pk3h5pUjUgLp1gDLYGiW/+6pEWQN8+gQSuYX3V0iIpfUoAuS8kjwCqbQd7i907B06Y1AAX+9YkWA9W9+00j/3BcMgaFGpxcGtZcXPVBxfo7dQMen+cU/q/QVNI3PMiBF6PPTJ0ErgIveH816lWLOLwdS0XlkUs9HFeDgdyqXZb3V34QSvrV62vVocuNhvR2taCNe7xFPmo2McLsECNRVo4SMvt/rU0aRkXbHiEj4V+VUeMCHk49DjvZUsjrrnMERTAXoizmIjHHYO1ue/NFggywvZwLAib5pdJpGT/XpnWjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 kernel/liveupdate/luo_core.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index 803f51c84275..633a16434164 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -82,6 +82,7 @@ early_param("liveupdate", early_liveupdate_param);
 
 static int __init luo_early_startup(void)
 {
+	size_t fdt_size;
 	phys_addr_t fdt_phys;
 	int err, ln_size;
 	const void *ptr;
@@ -94,7 +95,8 @@ static int __init luo_early_startup(void)
 	}
 
 	/* Retrieve LUO subtree, and verify its format. */
-	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys, NULL);
+	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys,
+				   &fdt_size);
 	if (err) {
 		if (err != -ENOENT) {
 			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
@@ -105,6 +107,12 @@ static int __init luo_early_startup(void)
 		return 0;
 	}
 
+	if (!fdt_size || fdt_size > LUO_FDT_SIZE ||
+	    !kho_is_preserved(fdt_phys, DIV_ROUND_UP(fdt_size, PAGE_SIZE))) {
+		pr_err("Invalid LUO FDT from KHO\n");
+		return -EINVAL;
+	}
+
 	luo_global.fdt_in = phys_to_virt(fdt_phys);
 	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
 					LUO_FDT_COMPATIBLE);
-- 
2.53.0


