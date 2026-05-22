Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EF43CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 05:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8BF16B00A0; Fri, 22 May 2026 01:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C638B6B00A1; Fri, 22 May 2026 01:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B79906B00A2; Fri, 22 May 2026 01:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A851F6B00A0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:32:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54FDDA0718
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:24 +0000 (UTC)
X-FDA: 84793935408.02.BF3F752
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7DA0E160009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 05:32:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVzi99+9;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779427942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZQMTpgiyndvYCOhmYu3e/1AOf7TgYGQa7r62/XlPc6Q=;
	b=bnBjEgE+pqLxxW9Ec29+QW4ORfYjVT4vLKVbkq3tqicnFnkNpMZQEyoOMNL8MEdfkxLx8c
	5XNGtP/JgEP8Qmbh/LrZa9msJVg0O+sOhYV/Au7dBoIIVy0VHBYm1mjkhwmCk2VxE9iL2r
	8vRlIUUvghFTy0fizIydbiD5lP5MU0k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779427942; a=rsa-sha256;
	cv=none;
	b=wJkPEdCvY8yCGGbgcK3HEn5heJC5h7v1lBi/56b0b9xP0me3UH51ujKmsp9cURryLki9PS
	GK43C33aK+isk37QA/CV3FGYxJLeE11ohkZxWb6P4sKx/0KPgfDJ6ciuOHga/o4XSQ91S1
	xdrCTjMRs2uFKoAyX6SdMVz5FoIm+gY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rVzi99+9;
	spf=pass (imf08.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-367c26471f5so4388734a91.1
        for <linux-mm@kvack.org>; Thu, 21 May 2026 22:32:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779427941; x=1780032741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQMTpgiyndvYCOhmYu3e/1AOf7TgYGQa7r62/XlPc6Q=;
        b=rVzi99+9vdhk5Le5Wv3FqNmb1jAsZzN2y1FSGHinoygqwIVxzABX/nAx32SyPJ02ht
         NXeY8qTCA8abuimkUKwO6YVqe96qZom7uFqi3MqfHRa4mZIYDAmqTFIUdteZQ5cMt7Fz
         5phH0zg67Ye6jjCPZBRKUWfg/ajMH9rcjewKHD0yS9VohOyKzsfahTvrNAUlh1+D7Ni/
         ZucPobGaWQXSMk5/2/g77tyZrnGp6xMVBULJG5jvk41ISozVKqoNfFWOGqzNc+kGnoRf
         nYbUjFGEvPcAIRek0IUAoepRNlxi4To+hkvCPiX4zeGZvp1w3ogk2KHax4RrP1iexWuf
         UntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779427941; x=1780032741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZQMTpgiyndvYCOhmYu3e/1AOf7TgYGQa7r62/XlPc6Q=;
        b=Hvo6aTM40A1chrMEcqHNy8VBT382ToHLwbKZBCzE578PQSeVmpeBsQD0ZIQ6aUY8h1
         7dtNVbcpdoyv5CpS3OQsginii46ay/IAY/mykVVqpDjWB8ZYh+BRtSGDZXDNkD1DGXVV
         I8w8Z63U3y8/mg42b6WGJlHI05avjorQ12RjEybHfl0KYddvuRVauuZA/WeHoG0ykphf
         6VfOEdW7RaFsYnjEBr9liMEQFmFt5eQFNEw+nEzKb2Ak0KC3ntm9zoaty3DEbR86MBrJ
         47YK8zfGRlHEJL+gOWuz8avwWq+IzXA+1ntpAf82TqilLYfsjbUBCDcuf2Xm+YjobIAD
         N9cg==
X-Gm-Message-State: AOJu0YyZ6sZuhYSbGoet3gP28MTkzADOcBLjgq/VhVYoNpR3Ze0rg36B
	ciA84cUzEojGgeOkd5RRFId8VA7r3rjKTa5lutJ2YutQZo4P9fJYUCTeL/6IOwlh
X-Gm-Gg: Acq92OETn+qFjTY8552Sbrzh+9sRwSeyUJYA/L26b18Ezi5fWTNZvD50Bzby+9eaBxN
	4nIhgc44AEZnFJb5b3Etu2kDqSBuR7m3gOYQOyHcGN1PK75RP9CAdtx/eK/p8pHKhCFaTENGtc0
	cNm/4szTxlTTGiP2g0QAI/JsALU+ObIyoOVAWD1clGksgejy00HPGW34ooR1kptMq7O0cVwb5TB
	3MB04ilwwpxMznjZsfulR0OVWPdkEhXPBaXvHjNk1jL69SY/+yYYS32nchhJAJsEDC3k4MMZ2nF
	Z45+D2r4VF8rKf/tFu8DnGcInaGzvu9knToFnLTRQgkxZO9Fv/rEpzV4G8AUlGMvI21GBsyYSap
	9kD3c6iuvjHbx09CnfXStxGY6TPcRLa2XORFrZM1ZVadCJmyV0BWw6DafHIJu+wijd2HkhMoE4n
	16yggC9zHq5OLvCzazOCHUfdggCqCo9mmSU2IwCXUJHQILqNj3ZVB9Irc3Mhjl5w==
X-Received: by 2002:a17:902:cec7:b0:2b2:ccfb:8387 with SMTP id d9443c01a7336-2beb0613c3bmr23217405ad.28.1779427941298;
        Thu, 21 May 2026 22:32:21 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2beb56d68adsm4782665ad.32.2026.05.21.22.32.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 22:32:20 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
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
	jiangwen6@xiaomi.com
Subject: [PATCH v3 6/6] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Fri, 22 May 2026 13:31:46 +0800
Message-Id: <20260522053146.83209-7-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7DA0E160009
X-Stat-Signature: q38n7m88j36u4krwrdw9aekqjpcfqmzb
X-Rspamd-Server: rspam06
X-HE-Tag: 1779427942-62014
X-HE-Meta: U2FsdGVkX1+wAP4jpHUtjcXI0zslJmYrr+8OQi1lvrR6cgUZsVw6yOUHv6nUwV/YaNKPI4Nwg6pq0T9cr4oxPn8cLZXZ9+uQyVSzH9YOPrV/DgzRv+XvkF6Zc2A82U7zG8ckGk6hsBoj56tRue+LDu+Sw/s8gefAVkYEHNWpNn5a++ga3M38OxNCG9QmaHVWTcKkzE98+/cqkzDTR86Y76W2ljQJsMynm1RDkoHNqXcvWAJVScCI46SRbygu2MICFpRdJFajRfwYH6nDQLbtPDaJmODj/Gyq24fhrVCk6mpBjY9l57lgFczYopgbEilDtXrolDY1CAUjGrSgCTnHbg/3hI+g98Yeq6XkdN4DGkFxSmHxG0ypS/JD3uMINqsm1cbJSpyIrMRG0jMTJLrCxyaWivwQ5MVSNPV0zBjW5BQ+8gystcLCYJOA3mczjj+FwoUrkg3P/qBWuyrirecji36J8xVf1sYh1wlOKCE8YecdymRMy61uq+spXODV7IjQUKXg5MUacnENFfahzaHVlnTwKztNV82wCAC6m+TC8JNQtzPoHKks0LHmOvDJMdrBRKASRJPgTemwZXC8ifXgcp20ZAyhKgK3VGoyGkPVrSfo627/RIZnnBJGzVnTABcyVZtq042jNqJ0t9vCjkEv/uggcbDEHUuiMPW9nzAxK/rGPdcAjSrISCFFprVKFzDqvmFdcxyRT2g2+/Aq2C02JWfCDhtUvrEGMSOxhYyjogIZ1KsLVf5qBrkr7IrpddMQTrhcsKBUyrG1qAAm+EWyRQsJ+7KDX7kMzupeB1CoawQsT3XmBVdrb/cj4lv+O0n/B/8aiinaxlgFW3dtIz5vNHiro/pi3feRu4d88H38zgfHBGPms83VkV8/mbIxVEvaE35VYcVyw7ttIuTrKaPY/3u6aI6QKSiMadUxe4KOheFTAiPnqWhC3yB1yZRm6jXpcGrP/rx1ByBoK0E4Tc2
 Fxjj+vUw
 32HuFDuXQKLQhfJPg4/sUkKJ1dDyULmDI8WWUytqna5wUi/OR1H7JRdgJRNnOR490yjUq6u4dfkjWkbFsGilJmIuHnQhvaYpoyretx9RGf7EaB7J4dtoJrmLrDQ/o9nsbLI3m0c1Qj/o+UIPB8N2lU17VpS72b38TMb+HBccGin6OZyWYktj6xFghx6li6RCal8smiPn1iF0XmQGeIwMnNYrA12I4wBhgVk4m2/oxZo9kgvJEQEEcKqC4oDCDdU5xBAPVrR619IeJ6eKK+AWFeh36qRejVcm1RF/BYzyiO+q8x6k3beWFa42F74AieIj+wVXZYrBm4nREL7ISB/zPOqaIDPQ14eX5/l26UrGSDljuBZ5oHGHT/SWWsVKRkO5k+BtONKJ42ePyzUwIqrJsXz7iWwUR8aUhv8Sr673xKXIcPM0rD9y3pGD+58b2yXkZd3AuMADvHdO6aQb9L9unQefFU+OPLlTsm7gXoTLH34BKZq2hhjeO84zzjrzB1uJuhrmnIJfllSZSVisw/D8dqLLuZooQb7nPZ03i
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

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
---
 mm/vmalloc.c | 33 ++++++++++++++++++++++++++++++++-
 1 file changed, 32 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 50642246f4d40..040d400928aab 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3620,6 +3620,37 @@ static int vmap_batched(unsigned long addr, unsigned long end,
 	return err;
 }
 
+static struct vm_struct *get_aligned_vm_area(unsigned long size,
+		unsigned long flags, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	/* Try PMD alignment for large sizes */
+	if (size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node(size, PMD_SIZE, PAGE_SHIFT, flags,
+				VMALLOC_START, VMALLOC_END,
+				NUMA_NO_NODE, GFP_KERNEL, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Try CONT_PTE alignment */
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node(size, 1UL << shift, PAGE_SHIFT, flags,
+				VMALLOC_START, VMALLOC_END,
+				NUMA_NO_NODE, GFP_KERNEL, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	/* Fall back to page alignment */
+	return __get_vm_area_node(size, PAGE_SIZE, PAGE_SHIFT, flags,
+			VMALLOC_START, VMALLOC_END,
+			NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3658,7 +3689,7 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = get_aligned_vm_area(size, flags, __builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


