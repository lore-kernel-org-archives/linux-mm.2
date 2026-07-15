Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4355C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEEA6B0093; Wed, 15 Jul 2026 09:29:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A6E76B009F; Wed, 15 Jul 2026 09:29:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796226B00A2; Wed, 15 Jul 2026 09:29:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4888D6B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:29:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC638A0098
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:09:04 +0000 (UTC)
X-FDA: 84990890208.20.BAA92D5
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf20.hostedemail.com (Postfix) with ESMTP id D54FB1C000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:09:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syjIh7pc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784117342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v8qJhOk4bnpu1WPc4oSH+kzjjMIN2seacJoWKksNoa0=;
	b=RLv9phLEE6VdUtjoNZr1TR2NpASqSml4vfGKsp8/H3/I0s5MZBALtUX/6zq5XJRUp9NTMR
	kcK5aq8LYixzjHTIPwBcqEMuTZvzGLVVcaQVmHrntFhzraHskuSeuZLeUvLtTwwtquxZhR
	sO8lPSp+kvWhlPVyvvEdkLY1DTf8Kto=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=syjIh7pc;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784117342;
	b=lfmP8wHYQ3Uh+c+CTbNJidqQF4wJYhRXI1aHD2o08vaF0iKT8YeJ0HD9dqkyGaNcBMy1h+
	uA8ELsEbyQ24xpnmmEkdIrswNjIdBjKM0TA1VnxDmk32ZTmfAsUoscs5Mt5+1HrLJ/fC/+
	k2zq8Fj7rEmhLjVMjshVtD/REAl6/QI=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cab973140bso62233905ad.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 05:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784117342; x=1784722142; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v8qJhOk4bnpu1WPc4oSH+kzjjMIN2seacJoWKksNoa0=;
        b=syjIh7pcpAMBGen1b5t9w6VtE8H5MwmgMcE9M3iYT+PKwGGkUqDteqszmvXAaDXfQO
         KKH7mNW3DephbbNJI0whUw85M+HcaW9HnGYrMv8KJuLwZxLeA+Cxjfluht3isBERDiKx
         YpI9DmawJ+Eylm+M6I48lOY6edTbVSL0qkhBE3b74uu10ayet2+q1Uv8Irp6/pcAjs7l
         TpORoxOu3RpkAuJ41/kYx2g7Xu3k+2bDps9RSDbZ5ZTnbmXhsMa5ze4gtx/PsqD7jpj3
         TcDDq/b8EpmUjiLbkyTIgzc5Z5i35hvrvV+PMOjCGR3RinGLw5kT4wQu5HuK26LvmfzR
         2F5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117342; x=1784722142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v8qJhOk4bnpu1WPc4oSH+kzjjMIN2seacJoWKksNoa0=;
        b=i5Pha/xqcAUnF825mhP5Nsc2Qg4IiL68LZOLkbVJ6PUHffU2QX+zI61c9KN80VEB/0
         RJiHFS2eNwA/Nq1r0iqyNsN7OZ5P8aCIOUSSx95deE4+Bq/KYkc8fBMX+uBBRmxt2kM2
         jSh4ODdsENO+b4n4mk2qz48tMKj/LKG4G0yB2ajWJyq0w/T5yhiOd3KOYgyI7RMgpg6V
         z3s/wbu+ec1dmPbtwdH5Syob75/9bH9kSxfGvWxbRvxhMQ91GrAHGBPlJs/AlmPj28ok
         2zD30OkiVUCgfcQ69aXR521+hgZ70+GUeGXrjOVV59jjJAuWTE9SbT582ifG4S8zyKr/
         kLDg==
X-Forwarded-Encrypted: i=1; AHgh+RqXo7j/H8K4odqydZ3BwMpKQY6WmGr8ug+C+DV2dyDfZWd77BE4DhhksPfPJQhBajw6OPPecmxBzQ==@kvack.org
X-Gm-Message-State: AOJu0YwSawCHgrYIzVpWyxm2ocH49ioc4EIyCw1uCB7mm/nHitnFYM2l
	2EI94VXSqC4XbbbJhAE4p2s+/7u/96uRo5sOvpP1KCCdCJOCc8IXVhW1
X-Gm-Gg: AfdE7cnhkribCsYCKMOIKupcAhgqdTb4qjrFaOkbKeb73TPWJ8Pt7twPeTRXgJm3GPQ
	vRwABP36Upv2TcYYUk7Bikuh90Me2QsUF7ypoeZjOe+TqB0N1ZLnIp3K33z1cqeE9xZQwn/9hCk
	xgpLmCq+QPXC4b59kbjfbRKfslFBLxw8EipbnkFQEOLs1P2vWGC0wCfPPL8J5KgeseJXUrjBJaE
	kO4H18Pi3pfSL3qvqhdOVE4Uux9pQzcArOCMog0rc7OZKIhpTWlgpWOEGep6nA0XkeEkbS026lV
	fMR8iCnCbF5cGvzIo1xb+OYHe3+1rnTZGe3+nc3NnBzfXhJ6GvWL8XcWEkHHr7ZaOB2q2VztgYH
	ECn4znsxHS9wnojVyMbIE+AZZrMPN5LOC7eGvz5/6N1qS3tdcjCg4AK5VvZFfW/1ydMrtPYGK2U
	X+4A2VzP7kIdyCpfgLEOoGjJT3Je5fcf4Ikzw=
X-Received: by 2002:a17:902:e5c3:b0:2c9:e6d7:fbb4 with SMTP id d9443c01a7336-2cf03cf6203mr22618325ad.31.1784117341728;
        Wed, 15 Jul 2026 05:09:01 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf105bc642sm1216325ad.63.2026.07.15.05.08.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 05:09:01 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
X-Google-Original-From: Wen Jiang <jiangwen6@xiaomi.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	Wen Jiang <jiangwen6@xiaomi.com>,
	Xueyuan Chen <xueyuan.chen21@gmail.com>,
	Leo Yan <leo.yan@arm.com>
Subject: [PATCH v7 7/7] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Wed, 15 Jul 2026 20:08:13 +0800
Message-Id: <20260715120813.3609949-8-jiangwen6@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7nhk18y3yiofnbm1x6eau7gk9srczqy8
X-Rspamd-Queue-Id: D54FB1C000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784117342-62471
X-HE-Meta: U2FsdGVkX18RRKiZdABdWSG5l3eeA5WHCFAFbtPnD9F9aq24xyEbHKA9HQwDvr0QFy41Sq7Cjq/fE6HoOgVLRe57sSu7WTlGPDLAVDT9a2XejBw9JJDsTKImZ/UKxqIcKE83TwXsDHDsi0B18Bu0c2mHU1MqmmJcVb3xI8q2mQgVRfXLOEvik5SxIfR3juUe61alRv6q1WJxhA89BuBQfTd8iXXlLOxwxVOupuWgWbcf5Au0Tp4bSyQ4C2bKhxAWknT/Ug0lC6SVtudv3LZU4sbYdUANv5AN7PtdnFtnIqfVD1JayZgnrwJD7hK7t84O76oBZ/G5XufiA/sU7QeNUdpRLxGXDeY44xxA8F46TpDOSQjsMPB57x5O/EQSBhEOUkvWLl4DJBl4UDEd7wp6xWeQblaAyL29jHE09ZWKDJmHzboaKdePBsxJmZvlaYI1Nikip4fxVqBTPyZEAWfV8sa2fp95llksOeDHKartidKpcHx6/1E9sNzxVIH1XQB7gtFIucpjBzRRlLWbAh/aNzcPucU1b3i3OpeKGwyryivIEsHeAo1aix/IeYqKflVxDGqPV6aswYi6AuEOHbp7PmcGxBsN30Ldy1RUKuCZQAlv5fNYgLXcL0qOsIxi7cfjg46Hb+cwvVV0laMyVPsX/EGAp+Zs9qFxz0u7DyNLpkAfIl5lw1u7R18lEFjYEGgzJec3oPK5CbsAlKMfaw3AoxY4m2A2N+ajbv66m4Gvle2ceZOgt8Fz0aaakTTs9hSDbJbbm4TTpVCg4px2+utevdg8grXjkAcLIPdlY9ZTWvfgpopBUeKsxVFH9KTEj0cqx6PeTiM1tHj7n0AKK3IInaNguObQ0YCYRKZrfYnt2QoynCCSLrlDsfak7urC1qYrYTOayPX1Rwz33eFfj0RpufmdlWZ/eVb8gSkjqNsanJIqGEP0VLscl9gVMQAyYUysLL+4rcp0wOtW+MdNDDV
 D265EEX8
 73NKBeMeFrUdE7rmlioerwkVtXa3rHrxwUwbQnBJJBUqU11xq4rfLw7+NYjHLUijfz9orFDsZznP7RB1sqVjycpV//Vh5q8XhE7O9Tiz/99tcbxH+tEWlGHFkP05g4L0y16Zn4ePHbsr1NXcr3NsA1z+emi2RmAce+9hPluwLRuBMmfoAxgdZPGif+U41FO1ehfCvRZKj6HqPJkn9CmhftT8NkZ1vUfeK4Bcf5jpw5yVs8E6Fz7Bl8hycm45xzMan71jS0b1PG3fRgJNIgJMgF3duztOgl3LL8FxVqN7WUuxFSOz9nItBXG67ZMwHxPIScq72NSILYxAJzLziox7yN+8Y/hq5ltaQqv1wMljYr1HKgWkcsW2ZOtXUuryKaVbr00u6BS6T6PwfhbLvX5VDovtiJZXFwO2gGCiI1wbp0iBzYOanyGVCzSDsnWIJdO5tqVk90Otcf7vnOangL28IM2LGpIhvcHoQ+I7Avd6cZ0c5tF0ij5wa80NlVbmlo5d9aA42McLIEVazwntwSW+/u1YIDHYbCUDMiiJVAt4hkCbMmBwtgfVQCKkJbTd0Nj6hlmuY2wppTiLQLZSR6WudPfuO+J38e8U42GwY
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
PTE entries. We do not expect any significant overhead for
this.

Add __get_vm_area_node_aligned_caller() as a wrapper over
__get_vm_area_node() to simplify repeated calls with fixed
arguments.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
Tested-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 mm/vmalloc.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 92f9cd5e9def5..7a3aa9e5c885a 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3320,6 +3320,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
 				  NUMA_NO_NODE, GFP_KERNEL, caller);
 }

+static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
+		unsigned long align, unsigned long flags, const void *caller)
+{
+	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
+				  VMALLOC_START, VMALLOC_END,
+				  NUMA_NO_NODE, GFP_KERNEL, caller);
+}
+
 /**
  * find_vm_area - find a continuous kernel virtual area
  * @addr:	  base address
@@ -3635,6 +3643,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
 	return err;
 }

+static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
+		unsigned long flags, pgprot_t prot, const void *caller)
+{
+	struct vm_struct *vm_area;
+	unsigned int shift;
+
+	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE) {
+		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	shift = arch_vmap_pte_supported_shift(size);
+	if (shift > PAGE_SHIFT) {
+		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
+				flags, caller);
+		if (vm_area)
+			return vm_area;
+	}
+
+	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
+}
+
 /**
  * vmap - map an array of pages into virtually contiguous space
  * @pages: array of page pointers
@@ -3673,7 +3705,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;

 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;

--
2.34.1


