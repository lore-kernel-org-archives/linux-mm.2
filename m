Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A15ECD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C049B6B00B8; Thu, 18 Jun 2026 04:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDC346B00BA; Thu, 18 Jun 2026 04:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACA416B00BB; Thu, 18 Jun 2026 04:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 851666B00B8
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:48:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D8651C46DB
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:48:08 +0000 (UTC)
X-FDA: 84892406256.05.1209872
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2F0CD140003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:48:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I+DM9X+t;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781772486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9Am4qJqS/MfI7jTQw49PX1QkIeiHV3cGmQD98EHd9U=;
	b=T3wQJixjvIm8UNfWUfVOuvOAqJeairBniTWJGPCqD6/uzP8Wqbucc22j7POLYXZjLeKbTb
	LrsQj8//aao2nFzvUPgTnigJfB5I1fniWRXV9qwbIWvL3pPxMXBS0CzQOo3rX/c8GPhUQu
	2xQQ/0hArRLbWfqnePxTfH7ooorsHyo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=I+DM9X+t;
	spf=pass (imf09.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781772486;
	b=2uQCXjUyqBZPsqXoE5LJ1qRSU0l6zrb7NZZHp3QXkaJ4DOTKuZe8pt502/Tnav542yXoVp
	R5QwFcuIxfqsdy33fK+Tj0f64wHBIhcMI0+bHowVvm7G7md7QDdyO5ukrBCnG2jDPlJtAo
	2sVMfMfxS7S+scGxc4KKOc4rJ32SJ2k=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-36bcbd7821fso221920a91.2
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 01:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781772485; x=1782377285; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9Am4qJqS/MfI7jTQw49PX1QkIeiHV3cGmQD98EHd9U=;
        b=I+DM9X+t4cVlc542278kt1e3hWiy36+9eMexjnjDRuPJG2/CQT25d4rrwOt9s8r1E4
         lqArNFZBi+qf0vxttCOTWSdCx5Mq4IsiJO1qA3Ij5mY1BArsMAk8wSgsH+JZ7l+9j+up
         0qUuG21mJQ2XomsOyxlqowotcOPxCTbVYN69tSpjo1g+4jhzS4kzExOXck4md9FQjY68
         ZC93+T8Q7EiuBmkJ1IzHQovzfNz7P6T8FfPSJUXi++K+DX3ovgblW/hnVARM16Cdo9EM
         UYDyusaZS5Y7ts2AFn5AFDiPZIOg6j3H+PllVOGBKZFJy08dnF5Jynf7KXy+ALf3+QSm
         eFiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781772485; x=1782377285;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O9Am4qJqS/MfI7jTQw49PX1QkIeiHV3cGmQD98EHd9U=;
        b=EChEZZmJKeS8yY/jVnvyy7ZSPW5SoJoXldGKfJYkPVlxnyRx8/XJV/Srd3yq2IIqqW
         Vlgbkz9Jy3ioDzXhPKXPDZUZY4ytZ8gjRgQl/UepFyIw05K/uEGThc/G010nZq+hKoDp
         SOkScIM9uhXdvmIFvNMNJjxpvetOZXe8+AaAqOv/dsqmOzdxXH9IjGVdqKSSduA/YV+i
         7m+xgq9UaHANRndlYgEvyMcXVGt6hijcBIzSUpTCBzV2Fobwz0zzeghtlA7Rpio/Hvi6
         VewrDqz242k6nDXE4mxR8LF9amW/9R3ITwsBcjdwxav7hPpDuxLQB8cPxXQ5ZF/CJ2vt
         s4fg==
X-Gm-Message-State: AOJu0Yz7ohh7kKqFTAlhzvRkHVVKkhsythEDmhoLp1IJ/bo205VxogW+
	Mrd+bMvSMWJ9oisD/IjJJO96KpZGKPemvjWQJwA+4tJChLH6Tl1pkwPfmqBqbA==
X-Gm-Gg: AfdE7cnum4lOizMbcTCmXmkQQV5b4fo8beCevNQ/Jdbit9wnoCwTZJ6mMsR1EmUosOR
	U/nVHlMZ3R6+kC7NG0OiyRmts8/Wgmh2VFrHxaTkp+ccd4uGpBLEOoi7yyVBiu9bEQWPOtx8Fs9
	ZxmeQC61RQDUerARcPA/5tt/HEUK+KK8Lkp7zwPjcZQpwPfJjEot9OUqzHJw3aylsTZt740cGcN
	dr84zA0VPIAkf8nQcTKmjG1goReb3haKqoJYTfTflZUP7hEht2J7FL7anHNdJsfXHyawc8z3p4V
	pPJZgtiecOzFKWL+00Su2M5KXCsiuwHPaauMOvtJN4RVdfChaqqE/BPLcc232WZ2D15Up6qlZNu
	ieth7XC7nVyaUmq7yBSlMH5L8PJ7rfPaAEBwm3aXaB3YkZVM7WhtEgJY2C0DoMN9r+o3zAn5ya4
	gEow2UbWjusARRiXz7Wb61ynDIhT6/TVkeuUs=
X-Received: by 2002:a17:90b:2fd0:b0:366:3517:1aa2 with SMTP id 98e67ed59e1d1-37c9be73275mr6808218a91.0.1781772485070;
        Thu, 18 Jun 2026 01:48:05 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521d8e7bsm8628856a91.5.2026.06.18.01.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 01:48:04 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: baohua@kernel.org,
	Xueyuan.chen21@gmail.com,
	dev.jain@arm.com,
	rppt@kernel.org,
	david@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: [PATCH v4 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Thu, 18 Jun 2026 16:47:26 +0800
Message-Id: <20260618084726.1070022-7-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2F0CD140003
X-Stat-Signature: yq58u4i4hh4a6nzqa5fhwfbmhqomcu38
X-Rspam-User: 
X-HE-Tag: 1781772485-705176
X-HE-Meta: U2FsdGVkX1+VXqP35utYqKNybPSronkvLjNDfy5eiueqVtWkbM3CYGiq4N5JugrmzZCV09yZqSJydC4RvbC9KpVV5Z/wm+5gZs1FYRhvpfjIi46lYrAE1qTxE5NZctcjKEi3sLxetiQp5rxR2soU7tOCr40/8FoUB0FFiSaPLW9tZBATmWxU1Ki4eIAOO1qskNDlhBv0HAGxB7puCi/y6rAXoHn+L62fxMKrUkUXJhN9B0LuNryNw4P7BSOPWq3CtziPcuGLgvEUw7iWUJ4M4gIydu5CZaR7uIsYTayn9/F4Mz7oRd22ffw9WtwRjTzQuU6gvMiAjW7ZOvgrlH6fNUUEhIBnh4mbJO2gB8jWtn2VLylwxxWcRt+jmjtKEg8vBbz18T7VVC8ycG3zfluFkJqmaXW+dFzlSBMaIcIH5hA0G+zCjUeAmyPTBfZAHRfxsX5HVosrCh8drjZEOE+zpY0i7rO1XzdyZBx+DEvTQRNwE3xtwX3oRWL/RfZka1K7ZwmuBsS9xHfWsLQfxSb3AMK9pnVUXqQ+GaOlpTlfWU08oj+t0yFYAFZCZfLRpkBYjkHAuEBxtYyLX5kPHaCFhxQZzt6tLG0HVPNvNr5rsSlT2tEopjHNz2hOsPGjZ3DnINNlSTrMW2y/PNBBI4ZfiJaGQdGD6lfDYosbkQLOM64tM/RLQm0N3R8sb7U7pLGO17cZjL5EtYxRj0zWtnnNDs7qH41sEjoQOX5PQApeDku6ctIF28R9d+4NTumb7wm+VgWTVT4QhoJZ1subWpCsU5O99DxbN/WXFRoNVWkDD2YbzkqqelOiEuyT5vb2OKpSn7iDvMQ+n1yjmMuFIkiaiYYCxkT6FBGgTqSo9o1nKi9EzMpKivhkseC7iFw2E8Ohute9I86xps7QjdzLLmTSFp/CKvdtbH9lYl9lFlpYf2JGCb/Tw9r5dyHsV/rhPmSXDMtFPmorgxxSjFrvgo6
 wYgPImhY
 kP7p53F09Aqb3MDpjssnRc86Q/naQN+tqVqs7r7QcGOXlR5L12SonBEs+vi6/fa0OTcDO1H4aU1MBj4WqqCfBFkJJZUEqfhWymcnPvrIRAp+heg4jGbzlXn8owxpTXG31fRTIdG3Iwy2bOOdsH7fkQz2sO6TBfnYI8n77dMXdrZ+Qn0GdnmMv4uiHxA2fzqTDfIfmCjXotwmRjzZBeW+N7Pzg2a6m+im3J77YTSVArGoYjfSmoZ93cNT3ly1KT/yNMlvpa8RHqZ0iFeyxG/85euAA1JHyPJFFzanOhS0CVCvMGWfZLJwWm74B9u2yfqO1kjUtMw6KPMODvhOpqqSO+rIfs3wWQAX/dH9pMTel81MnKfHL63FyFLz0k7KZLTL94ELTnTqCH/Vx58IPVekJgQEpkYPsi4zKxms0GUH3MMgpTgh1Mekw43PtA1RYaW5qkRDhZ3sy5JVpPTaQ3WwiXlDa1JilHL9bu58koE5L4x5DAxV/4fs87AzQ9wNuVOSC4kHRUrmT/kuyQhRRAjQGAGIWcqEYNON3RnGc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Barry Song (Xiaomi)" <baohua@kernel.org>

Try to align the vmap virtual address to PMD_SHIFT or a
larger PTE mapping size hinted by the architecture, so
contiguous pages can be batch-mapped when setting PMD or
PTE entries.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fffb885cb2158..bc9fa93e2bdc6 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3628,6 +3628,41 @@ static int vmap_batched(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+			VMALLOC_START, VMALLOC_END,
+			NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	/* Try PMD alignment for large sizes */
+	if (size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Try CONT_PTE alignment */
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Fall back to page alignment */
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3666,7 +3701,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


