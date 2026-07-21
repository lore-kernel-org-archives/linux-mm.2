Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9008DC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 121896B00B1; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083C96B00B6; Tue, 21 Jul 2026 05:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F03E96B00B7; Tue, 21 Jul 2026 05:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C50AE6B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:06:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 36D141203C8
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:20 +0000 (UTC)
X-FDA: 85012202520.22.C63DF9A
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf22.hostedemail.com (Postfix) with ESMTP id A3843C0005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:06:13 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	spf=pass (imf22.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784624778;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H/YtpVTc45SBUlQvVDuRBiM6HyChsR7Gyc8Xi6wti+s=;
	b=pz0ir7EyP/6+MJs+AvdAkL2ZOzhcqqm/a/MaHheH5wS+V9zF+sBQoyGKzgiPRsl7BKidVh
	BY9sW/5QIg7w3oLTMULz0GFDE0TehqP7xs6N4VXdHsxchTN8a165ESD7gnFU57ncnYJEZZ
	Hwrr+oVVWwwKjdMlL4X/oCG//R336tM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784624778;
	b=UMh9J7m6WcNFHxZKswVaGoCV3q3X2/cvZih41xV4699mfJDTCE2+vPhzAz+24GIUQ+Kw6W
	rKdtxI6zp5deD9pBbC6/S1x6nUw7riFGJBslRIgXmYiLomsoDvsXbRHw1cKOh842zoSFaL
	0yJrUH6TNqtZLhp1KkDjpzBYLhsGOZc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
Received: from loongson.cn (unknown [113.200.148.30])
	by gateway (Coremail) with SMTP id _____8Axz+uANl9qI5MFAA--.21747S3;
	Tue, 21 Jul 2026 17:06:08 +0800 (CST)
Received: from linux.localdomain (unknown [113.200.148.30])
	by front1 (Coremail) with SMTP id qMiowJBxb8d_Nl9qdssTAA--.39236S3;
	Tue, 21 Jul 2026 17:06:08 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Subject: [PATCH v2 1/2] LoongArch: Expand module virtual address space to 2GB
Date: Tue, 21 Jul 2026 17:06:05 +0800
Message-ID: <20260721090606.8982-2-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260721090606.8982-1-yangtiezhu@loongson.cn>
References: <20260721090606.8982-1-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBxb8d_Nl9qdssTAA--.39236S3
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7tF13Xw18ur4UXw4fJFyUtwc_yoW8Ar4UpF
	sxC3s8tFW8Wr1fCFWvywsrWF1aya97GFWIga15Wry8Cr9xW3WkXFs7t3s8XFykZan7C3WI
	vFyS9w13ZaykA3XCm3ZEXasCq-sJn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUkYb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1l84ACjcxK6I8E87Iv67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv6xkF7I0E14v2
	6r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27w
	Aqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JF0_Jw1lYx0Ex4A2jsIE
	14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU82g43UUUUU==
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A3843C0005
X-Stat-Signature: 4838u5b1ikx9893rppxkrscs5eqki5qn
X-Rspam-User: 
X-HE-Tag: 1784624773-48315
X-HE-Meta: U2FsdGVkX18A6r9tQSmRBy2HtKc8zwOWlIOSgS6Guqoi3KtkG5YW2SgrVBg6oY+ZWeKAcNP+V5uaG8hSFfyxiCHTOcql3MPOs4DqQgcha/2EjEnMGhjQUwWZ+OCXzDRO5faMTi/+7FBfUIiHFHcvnxRr+Z5J+BM0hipovLweoJmqq8pTMz38aaOERyoHDv0ycfWzGFo4p90SVTPrPR/8O1BJta3mACDNPmAeOdQoiPpxPopOLJmL2MqAKIvBykbs8JH4ihGBNURAQWQl5j+fNyLCjyFoFZ3f/MWbXydhrvN3U9n5ZxJohFyfnygB7wmlYTBKAyqTOREP9OgmvtlK4GtlYJlIwN0pwfuskYQ/axLWsDWKw3sjZPJR443ECygYg7DdKWnB/Q47dwx9bsgn1xxHrItCyXGGGQOuwVsEcIZkzW/4qNyJkBJyeZhCxeDiXVNoCtd4y5EYNLrtbgFtyjik6nivvDrLBQZzVvlPKYSXz59bzrSFo8m2oZOeRL1NfOMOPKBNSi6a7IDXfhQhdWmFDQCOLmo4KwHnEuNFSizz8h4y6NQMgutmHQ9hPjtgJ0RQzn7Td+T98fkZETs/Ys8mQi4bu99XVzADKQTJaq9rTGrDgCryJJOmuSQJhWAVtpU8Kgv5FbFxck7cHhyg+HMWsPnMwFAhC4+6CjIiuMQQFecQeyVYEx6V7wFHy80z10w8Am5DGaO2RxdIQKR+8acB+IeSwD4FV6u48Ia7wEriQXGy+TJ9fEB5+L9j/jdiTQ3t5PvFMW40VWuqEG8+ywcxqZzocQ/esUlrI7zE5bvLgS0/TsUQ6njDxe2kIx7z4+PSVmqlIUqz4qKOFeqyvUuoD8H82OXGtd0X5288qenBMtWa/RFxWl+uSHty+IXxreYFpLBs3PBCDReGSnY7rHSz/XChdMgf3mG+vu0laNUCg+nBD+6G0/9FKfmcLZDONij5ki59x+b/SKKoABP
 oujNYFTG
 xogN7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current 256MB module virtual address space is easily exhausted
when loading massive graphics drivers such as amdgpu along with the
large unstripped symbol tables, resulting in allocation failures of
"execmem: unable to allocate memory".

Thus, expand the module virtual address space to 2GB while keeping
the current normal code model '-mcmodel=normal', rather than using
the medium code model '-mcmodel=medium'. This approach avoids the
extra performance overhead and larger binary size of forcing every
function call into a 2-instruction sequence of 'pcaddu18i + jirl'.

Given that individual module code segments rarely exceed 128MB, most
jumps remain fast direct calls by using the bl instruction. For the
long-distance jumps exceeding the 128MB limit, apply_r_larch_b26()
emits PLT entries, while signed_imm_check() guarantees the run-time
safety by rejecting any out-of-bound instruction offsets.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 arch/loongarch/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index 223528c04d73..e5952ecd6a73 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -96,7 +96,7 @@ struct vm_area_struct;
 #ifdef CONFIG_64BIT
 
 #define MODULES_VADDR	(vm_map_base + PCI_IOSIZE + (2 * PAGE_SIZE))
-#define MODULES_END	(MODULES_VADDR + SZ_256M)
+#define MODULES_END	(MODULES_VADDR + SZ_2G)
 
 #ifdef CONFIG_KFENCE
 #define KFENCE_AREA_SIZE	(((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 + 2) * PAGE_SIZE)
-- 
2.42.0


