Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B3D1CCA464
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708A36B00A1; Fri, 16 Oct 2026 02:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E0EA6B00A2; Fri, 16 Oct 2026 02:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0466B00A3; Fri, 16 Oct 2026 02:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 335CB6B00A1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:17:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 33795C02E1
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:48 +0000 (UTC)
X-FDA: 85327483416.09.F0770D5
Received: from mail-pz2-f8.google.com (mail-pz2-f8.google.com [74.125.228.8])
	by imf05.hostedemail.com (Postfix) with ESMTP id 70D3E100006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:17:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZWmr/xWX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792131466;
	b=fb/xvqdAiIwYkA59NMWE/wv+UyNq+L/v/Jp/9SBhc6K+O5vfbJX4HppxugMVTjI2iFXo7z
	Lawvrzkdp1hSQFTRGnPsSzLGaFD2ReYqJUKWpTSr6TLAvuO2VjN1SiLwX/RHyQHUh6G388
	oqotM3YAhaG52Z+TJpaqd36oszlEKI8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZWmr/xWX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.8 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792131466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
	b=GiDu2sP0+jq61SDQtQKELXdQM3VkJyUaNnF5a4vw271an5De0lp/NdAlXSwI9zETEwPxRC
	arT+7cNqPb8zjAtfWM0FzUthVNunUz2mfDnzzrCU0C4xX14q/5NOpLy7EEJNNuRUiq6Y9Z
	GhdqfyQ7rPuY68Ap+4qETj88RnFP8+4=
Received: by mail-pz2-f8.google.com with SMTP id 41be03b00d2f7-cd5cd8e8104so622814a12.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:17:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792131465; x=1792736265; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=ZWmr/xWX8tradaj0nVpV8ajWIkmdQpDTTzjKBv/pAIAXTgYo0v3G7gcV8zOaMbPKFO
         Yb9N/+DLz8bEiY5kh/V76B7TFJtqHQOrfvQzf7R7JWAwKeIwC58SgkFGSrO+WGtVpn+P
         JCLhb5ZAD8MpnRZ75hQKdSxJ7c93JcoOxDISsnk2kuOk1WCbesJAIXIEtzjfws1ie6qc
         S8Sq/HQw4jTPDvv7+EDIu6aWlSB3BgZZI/32DtjSSB4FMjRXO74rvZLUg7W2m1yWnE6I
         zVabhPMmKF/DS98nLiguedvBXC/Ciwv9VhbbP811mL6N8i7VPXT59ggPYq1g1seYJAOK
         LZhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792131465; x=1792736265;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oKmXp2d3TpfvxuGqVqHnwKm3WEcWPeyk8O3QNAPgerw=;
        b=rfMcwOT5PP44gwenSbeFU09ISu/C3ny3ZvQ97dgo1Yiut8QQLCShvP7j/g06NA7sAh
         mvxtWs16SKJFQqLB2X2hoV6oEw26dyhZu+E5VjaEOqTEf6ZEOqXdngMDqtCB3gnyhSsH
         Z0AWByg5y4TyAoHBt/JHQnkh0oD66oUHX/gNORg01r7vg8CD2t/vKbzWRbGssHMzjf2Q
         O/cf2EPuVNBbQoL7+GWaXWimetzzzMk4HgighLyjMZ3VtdjXw9j3fwe2dq7N/PCQmdO4
         8DSlQRyaSJveaVYf5mQGBs3ASwfrDDx1q6hgQ0IbLlW3iUB4t3NXYDmdd7Uw6XPL2ZeO
         Ec+Q==
X-Forwarded-Encrypted: i=1; AKwUvByYgT341tVeTDkP0sfK2w6SrKNmaf/8mBpoBjYUqtzesvz69fXq2ftcSyrmsiA7lkkxOeBCuPoCIA==@kvack.org
X-Gm-Message-State: AFq9FYJfhoMVrLmU2zeR0IXPYYz2YJtDhfq/dX/YhSM5u4Do2YHNof4j
	FyrTLFFrPXbo00+6gr4wP+7QBgiYk6JwLXTlkC0+mEEBCFL6N12vETEr
X-Gm-Gg: AYBFou0M5tQhNIaohAvXBxQwEuE0u4QCcWYSOVu8iGig6rVO0UlXQudGhcXhlazoex2
	67wFZJL0RKyIMs6QvWZxrsyQjny3hGFAji4N1w74IJZWKhJfFbQKuTM5WWzQmoZ44VeP3hbWcq4
	ra3SoZ0vjx4+J/2Evmrn3XplXv0S55c1A+nwHnFpTo7agvV9wZ5hILtuX13SJ3PoCU64sdvlB+D
	0qoPDKEynnlQSGGScL9YZT8CoLdcuA2p3iAZ2xCmQorrwM//RQEx76N+ljbod1BQES2Vl66Kwva
	sLlkc+SpvB0irs5GRfb0YGSinE32awgcxzpBc15AQJPlycRzZNVeR60C5kgp8Var+qRLd33o1mV
	1OZiKZoFOKkNOj4uBmA5g+iiPyYmIb7b86S4ICs9Rfv6yU+7xWu10nsEZ7OSm7m4jtN3SOXeAcY
	DPiUFZHlngAajDdrQ9rKqYvOCNITLjLGj5GpIa/ZoOoM9DM7CfQCMq32vCZYxzx6lRjKcyxDmeS
	hyCcWbwdZVCkgmeZVAIhA==
X-Received: by 2002:aa7:88c2:0:b0:886:cae0:fb64 with SMTP id d2e1a72fcca58-897c700e74emr16786375b3a.31.1792131465299;
        Thu, 15 Oct 2026 23:17:45 -0700 (PDT)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f57b334e6sm586375b3a.42.2026.10.15.23.17.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 23:17:44 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [RESEND PATCH v8 8/8] crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF header
Date: Fri, 16 Oct 2026 14:15:49 +0800
Message-ID: <20261016061549.4181390-9-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061549.4181390-1-chenwandun1@gmail.com>
References: <20261016061549.4181390-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bdt55fizumwwg9rgb3xzrndsxfetrrn8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 70D3E100006
X-HE-Tag: 1792131466-108251
X-HE-Meta: U2FsdGVkX1+n7jIj4QaTAU+/NZCQtdYjVFEYbOAnNY6Cdk+C97uf1W8LmhSLCvOPUCvxlWG9h6gKSZnOFjqjX2oMM2sOYmpk7pA7vC58R90xa64umnFSUuQVZU6vnkS2ZSh64tgA9g2jGb7YT3EWCgDhST7dX/ESjukZ07oJWIKWBSB1pX4CDJafKa2wdujxWN140rpISRWqnr+/l1+hwpMgNO3/z7W8m/siGGnV+xjn2ywOPxFxLaBTGPvrQNrhBYYEZkZIOq6KQgACnbeOR59fdeQXdOEHJYNEwyWuaO/+0Kh1Hg5gcplj8q+XvhRbP8h4+yZ4gyCgfrZate9D/uqJ352oM3pYgdl1FcYgy/p6fh+ZWOHckoAQx/PcGAva6ctVuLPcP13mgNKZHv+13gBDxOY4P1cyAoDq5nU1R5HjuMjC4Vdvd8CGY8MZu4roRq8VlvZCRFwqRVEIJzQ3AhjRLTd4nGFFM4aimejdeZe9D0bUGw/wzWPxDcir3Yid5VtlFOl43uC9j5nPv0ByqPaZQN70nBIbFygBSKQ0U8IBiT94HogE/jfy9UQ2ByS2L7JgdKv60Ka0J/cgNstQNOXeNxs/xmqgf+7cHtPi5dTJT4I0hGKuLhJPDstOWJ2hR02B5a1Mtnoy+2o86JOHaZMu+h0h122OYpgw/Hau3ntZnyHF+9cvwbd0N0RmsKT/F3xnqUO4V/uHvCbYunr/+GYou6u4R9VckswPSJNKb7CeRv20pl/wTDu72ZlKQIIBWaUI+0JByIrzkPJpwst0IPCV9+lZd37gDJEiZ3DfFp9kGJHAo/uCJWPbUzk0/iPyptaDKWIl1nOXfIXqiFgufS8b8fVe0nrW0v5MF7DMQRdrh19heFPSQ8Fy9wwFib2T2D+6Aw1XSS2yCKitPsyP8AjDlZY4v6cHWui78Gryg0U+Hv7+CTqV/yE1qIoYOFpFQ4+qOuWlcUT/3ToezW+
 Z8IdaBQO
 KNnKn7nytMNdWr8yVUxzDfi+L8QR33CBKcrcPawpez0dkqX6yub5Wr+qia2Whp+b//U9o6EX9UlbIWiOeyI1sQV+/je3AxfXzudqgMdOlDVt9CV43i6vhmVi0queMRFBCSVbTNp1+SlwUv8rML2mgR9bzmqaQAsiFK2k7ntYXkkOf3pGZhrOWfYeFvyj8NIoh/kCWvlwpP3guo+Ax60aqN+kv1NmRDUP7G6/SInVTBfe8fZ10dmS1pTKG7UCGL5mb+KUNBV7FyzTd7bpWNC6zcvm8CCbNTKWwAP5zGVwvdkkRUuLsgjJTb8pvB63F+e1OHUuu4k289+bacoYem6+lKEiHPBDM++P30iXHe94YuVb/GbLpBVer7+5B1yoCRJkPdb8vFz2zgFbEfBoQij96+Hx+F/EZiV92L3ZgS8mVZJO9gr7Fsm557GbKxBtjMwOt1v0/eBqRtfIIxXfnPUyWuHtvIjwxtgya+3Xjrbqb94eLx6CK2GT719mD4GIyw4y83bDJb00mP5EZO86vc3mus/YDdw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

Reserve regions (for GPU, DSP, ...) carry no data useful for crash
analysis. Exclude MEMBLOCK_NODUMP regions from the vmcore ELF header to
reduce vmcore size and capture time. crash_should_skip_region() now also
returns true for MEMBLOCK_NODUMP.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 kernel/crash_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index e161c8b65e00..0e2ddc933b22 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -283,10 +283,10 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 }
 
 #ifdef CONFIG_ARCH_KEEP_MEMBLOCK
-/* Exclude NOMAP regions from the vmcore. */
+/* Exclude NOMAP and NODUMP regions from the vmcore. */
 static bool crash_should_skip_region(struct memblock_region *reg)
 {
-	return memblock_is_nomap(reg);
+	return memblock_is_nomap(reg) || memblock_is_nodump(reg);
 }
 
 unsigned int __weak arch_get_system_nr_ranges(void)
-- 
2.43.0


