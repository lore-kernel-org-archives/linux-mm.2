Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7885C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 05:30:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD3CE6B00A7; Thu, 17 Sep 2026 01:30:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85146B00A9; Thu, 17 Sep 2026 01:30:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4C726B00AA; Thu, 17 Sep 2026 01:30:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 99BE86B00A7
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:30:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 188E580234
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:54 +0000 (UTC)
X-FDA: 85222130028.28.67214B0
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3887F20009
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 05:30:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nMpOoRee;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789623052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8rYVhg/v6BbsXS7Hdm4I0mlpI54bk8irnJCIlnxFJI=;
	b=NQ62YMpFl6aNpeY6k/aVBd12+qai6YHOMg4sgdBIWu+leudBsjH5+DH1QwzIA69fKWonvI
	iU01EUOw8Ty+Exk8BPIx0WffsJj0Q9udTUAkvTQxrli1+e/Yg5Q9WAY2gPJNpua9IZDiBq
	lnFFWPh7QcI/WmSC4kqL2DMVrEMcrUQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nMpOoRee;
	spf=pass (imf03.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789623052;
	b=S5ZFWlGfBponxW2ePXrJwA9fvI2SweEpHvPVGra330zJWPkzxOMLQCLQfjrtYmtOZMnvWj
	cPebEQ1feShcSO5/dbAACmC1Ji2xEvGdOXDi+RzfXp+g/S2oX9pcU7zDBCPeBqjuGTi7Sy
	qiHG71UYd3kZZkn0PMh59jIRX0uLgPQ=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cea34ef3so388048a12.0
        for <linux-mm@kvack.org>; Wed, 16 Sep 2026 22:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789623051; x=1790227851; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/8rYVhg/v6BbsXS7Hdm4I0mlpI54bk8irnJCIlnxFJI=;
        b=nMpOoReeOFPjyMZLHk0Q+WTgdENOvRQerdSbMgGdh9wKJfFO1KMj9HUWoXSy7zAjFS
         ntb/9AKAMADY4yRdZ+JNWkSMGJ9c00OlAKyvoGaaGxX5HwT/VpnSzPOElaW96dfY1hSM
         et5QUW7WIk+MT06e4jnxDVZKlrnE586G0i/64NWvn4m/Y+59dJpD6Ki03ZbUbrTAT50k
         LORznlshoaCMrE/7ww7PRZUqV7uWR4x29BWfUSxCY1OGvRJf3Tm71D5YK1gFA+hAvSGr
         FNdhoxIl6JMeWCMc8W+LywOgoaMFvt28kDOfJyN7aukFrWyPut7Tt9kg1XLiGM0AtWaP
         B9YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789623051; x=1790227851;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/8rYVhg/v6BbsXS7Hdm4I0mlpI54bk8irnJCIlnxFJI=;
        b=jPVew0JMoY9LMdQQaLCppxHnXLP6MQ/xuWmHomiCc3T+g+hiIMOmYApr0p7r3Y9gSK
         HArJ0o6Yak+TQYJ1C9ntHqKwWgJWgWL34tcNxZAnYUJlVfzupPF8GgyLXNfKZmrUThQb
         7rZ31ibzL/W1e0QoZoqb63eSqTPqUlfqQv6SESaL2RdkVURoCi8QJ8Zql2It9no6PbBJ
         AmOHCdL5cfnPjkn+ZFvGaCZ3qMMSPGFCyWV5afiDHb2AOhywperY8kTE3Qg5wQZ5RCSw
         +BjZlJe+d+fykC/xDMdZNiX7WTFRya7smvBmU9wjutjzY7HPGoB4NgBEVWQ43zcu1Zqa
         VIZw==
X-Forwarded-Encrypted: i=1; AKwUvBxVGn/htkmJUHnSGI9gCqaeh+iA6waAwkUawu81g3gE43IDfm4l/bKXd+AmSnQhiP8tPzLQ7SdNcQ==@kvack.org
X-Gm-Message-State: AFuF++mw1lKu3LKZW52IxoU94xhAt/d3z/naQca6MRX5+f5PHHXUK+F+
	bnfi3s2UZF7UqcsEy96vpwm2UC0nTikrtmsiV6fRwaUPcuc2wXmzPc2u3KZYsg==
X-Gm-Gg: AYBFou0c3/vOoqhGEOjaiRHcIKIHgmiAwN5LJlkEvcNSAgcoUt6LvIgT4Fk+Iha0gTK
	N68eLKV8sGmTe3Z9zNJh38pVnsllqfFGHzGC7gp5GptPA2YvPx/b/VgobE6N7taXviMHU5/k+FJ
	+MQq5osuriEBdD98rkL6O/XMZl34EFe3gmzZnKTrCcEQKEei6qh95yJ6i8DHC67+4RGxr2Oi/gi
	43EjuRYHzyKUxjOEqKF0tGOp0yG5+urEtV8UaBMJC1jNOowGkV4W6Z/NhAcX0Haihn7Pj0pzkBt
	aqTqtPu2rB+Mv8vQHczA/qwBaQ1JqVC75v5n8Uc5SMWQkyxrIcykLuW2yzox8VmKh3jbbrdR96l
	T58V1/eVyyyF3rsfOOG6woDQJhpwq3Ns6JA61lQu0BFnWArBtQbFEBeu6bqpUx77uOtY2+ACTy2
	2yVP8YkBvPQoPLD/pk66e0R5xTrj0UMKyCnskAqG2bSxwYEeSkK9S7Jg3CjP3fm7VZU93QCzBZE
	6uInESQ4F8bvaiJ8SK+fS1y1jSPyClS6AePcS4=
X-Received: by 2002:a17:90b:2b4c:b0:39d:f024:c7ec with SMTP id 98e67ed59e1d1-39e1e484b5emr13289860a91.16.1789623051007;
        Wed, 16 Sep 2026 22:30:51 -0700 (PDT)
Received: from mi-OptiPlex-7060.mioffice.cn ([43.224.245.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e3abada87sm1955836a91.14.2026.09.16.22.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 22:30:50 -0700 (PDT)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: [PATCH v8 10/10] mm/vmalloc: align vm_area so vmap() can batch mappings
Date: Thu, 17 Sep 2026 13:29:33 +0800
Message-Id: <20260917052933.188679-11-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
References: <20260917052933.188679-1-jiangwenxiaomi@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3887F20009
X-Stat-Signature: 8mie6ittbfy1z7joefwy5nsiiza7gyjf
X-Rspam-User: 
X-HE-Tag: 1789623052-264724
X-HE-Meta: U2FsdGVkX1+RcUVq2A9kNDGfNr05YhEysdCdOZAKOXM3tLzx2aUqW4FriOLOgTOUEL3wU+eHDKHHZ6NXjHs0Edkjj4xA8Q/vQHzowj+NvlYskzvogv6LEaZDWxoxQDu183qO6jQNAMCoK9w+BmQv5aMr20B0lT8M9MIfb5/smKhZZOMbilCLSggvmPoxEnkcG4jsFlr9bOHy8uKkDXPvVofhoth+M8Z/DmjIcLp4fypkhECEG83/lsMZGK7SEbcRiBYhrIDOwQjKo+g6M/2jHZoBlROFNFZ3RFWA4Xpkl/ccbWTZ777i/2Gj0RvZtlOyTWqE8O4SLFBcV+74TPRxPqI2tRvlNjqeklQwghTFZQFf4LCpWZcP0A1jPy5Xn32+qXXWTKx2KUOydsPnbZ9SYJUX8nQd/vHK3XWGQqbbIIb67lllExihk298Un6KZQFI5qZL7KUDnnAYhaiuPNkA3xd3ghensLFVkPJw/PPeTRrbm5nMLGTmSx8qBWOWfXnN1dMbizHByBygDABwNjYIeOsjP+bqWj1Hh6svapl74byk39ErHC5UQX4SUMO3wE7D0dKMoC1TwkRbIU/7dT4UCBnFgioahDhaHZixyr4xZPYwnP9MAqHBbmrIbfuxvogsb8Srn9GhUEbisCheW/rOYSN4A2utrsUUk8wVaxTJ9m3AkNcdg9uYwQCdaca0CBqZLcSej3Qa8yXq5YRXI8ImN13tYMb/sF3nAfFTZ/PpB3o5nBd8zhCf8usrACYJE5tjRGHDoh9eLU1UYHUZnckIKacNXZ1xkcZrHyDGmaUvFlvGD/XMuFsveduBdp7ckpShyQETq8FSWS60My7B7s4O6kzwS+xiQSZG30ot0bhPFEsFlUNRKaX93kvfA1HKHf17fBDAw+N5JEUS5llWGPqSkhsl5p9X13Lvjz7hHbCtkI8ftby80GbRo8zHdNDHxBlU0meHeOutWRVD73a+H5G
 aMQoaSgY
 GqAdeMv0eg8GnKBAKpnQdbVb8Vn+vIncsXWUa+FX/S6S33/3DgfXHTjjBhL0jfm0b1tgyWc8O3GUASaPLxz1cexSZp2m7nxybTK7t6x7+xs+2lJfOPXB9G3hZQr8ESZB6YI6wA0OTGTHb+ZPgfWRo/iBegazBLds4MTBZHdaTYe4JTgSmU4FIZP+aECCERUOiKPTxMIslK9geL9L+9J5uZwaNKagfoRsep+uj7qN8MZNxrWMej5wap3mS1BNdKG/oolx8Szkr6JIPvXxPgSG++s2TwgniRLDOF0F82wLtsAMLur67a6lhusQa45KLTEP5+h2rAS/Cp2KlWMbz4W3w9a1upt+5XkOciIQajA1GEDZ2ZhMynn/68jvE3Gie8q+tP6GIx15aVwQr12AwZ8Hclfw2QU1R0MSiIl8qyFFqSQXMgRFbijV8E23/26T/FAVH0uCeJRw5Dy2tohj7qCOKis7K36/cAyQmJXihMYxDwHAyAREiWHX1I3sMC7i/HilMtyWEYvaiFRVpxQs+mzujmdeY2IjexgrXUrcnlsYWPDwHZw9Jk5+6JBQG2GXjrH8n2whRZDz0pwOgPPVY+oHw5iog6JqqALUAOiFLhCj5vUYCsaF1UJx1UTbPRDkcoGIPjHJKSuhipbZnR20=
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
index bce2d2c09f546..84413def1d771 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3306,6 +3306,14 @@ struct vm_struct *get_vm_area_caller(unsigned long size, unsigned long flags,
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
@@ -3619,6 +3627,30 @@ static int vmap_pages_range_batched(unsigned long addr, unsigned long end,
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
@@ -3657,7 +3689,8 @@ void *vmap(struct page **pages, unsigned int count,
 		return NULL;
 
 	size = (unsigned long)count << PAGE_SHIFT;
-	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
+	area = vmap_get_aligned_vm_area(size, flags, prot,
+				__builtin_return_address(0));
 	if (!area)
 		return NULL;
 
-- 
2.34.1


