Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47EB5606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A6tSid1x
Received: by kanga.kvack.org (Postfix)
	id 5F2206B05CF; Fri, 27 Nov 2026 04:09:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C98D6B05D0; Fri, 27 Nov 2026 04:09:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DFF96B05D1; Fri, 27 Nov 2026 04:09:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B95A6B05CF
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:09:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5FDD0A7978
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:09:01 +0000 (UTC)
X-FDA: 85480324482.24.CA6BBAA
Received: from mail-pj2-f3.google.com (mail-pj2-f3.google.com [74.125.227.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id 84B81C000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A6tSid1x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770539;
	b=gNYRNqJqFjdzI6kEMEeZJ2F5HmHzvFxqPneXywzgeYwzoIpuaLj2slax3iz5MHGccGTuj7
	UKRLHTIfpoCbtCqlcEROfIwEsNYxWtNL8K/xOUwlWaew+/pRfwJNWDmh9ZMAppxoOBh51u
	trYZbVJonERtLxWRBErUUfpjj3RRByo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYWYab/i6KswA9jBoR7n0gUVHNmGP1kEM/igKErB1/4=;
	b=SPR+UESoi7nOaHOW+yIxMMMYVTjMEKJ6ORaUeZEuT5QWA/CZ+SjuvOanrgoqtRIZQ7eOof
	Phj/9RY7kOW9tc41hns4SjDvfoS3RPtlFcbrWSlxZXi3P5U3m+Br5PllCzRBtKCrbVLGMq
	Cq+jtggsBNtBGcdML+ZAHKD4onsntcw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A6tSid1x;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.131 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f3.google.com with SMTP id 98e67ed59e1d1-3b509dc9d79so363066a91.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770538; x=1796375338; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dYWYab/i6KswA9jBoR7n0gUVHNmGP1kEM/igKErB1/4=;
        b=A6tSid1xsIHB6DtHHGzAEcpkclrnzdwX7FTRwwFOzKt2ROm1O80Bt86uAuO1yavkRF
         PzjmP+coK+KK7o4wLVEuUWATultiqMzjre0ZJrC4xtG0n5n7jDQHoj8qcNrxuj5a60jW
         vrIKyYm4n3CuiFcurscqouJCENNPGzbnzqXVU3ukuNZ1TbdimmNqDNCTTNC51C1su95o
         WxOX78vjPk0GnwXzxEen4LEDGyUfVGQGBovvmPb+FDF/DOXa7dcGOoURgj/SFmiWsK5C
         dcY5ZXHPyUalIG7+C44y1tNIaCmETN/DWvr94i/cx+EnH7gU6MceoWDO1Y6Pb+zSWsvW
         D8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770538; x=1796375338;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dYWYab/i6KswA9jBoR7n0gUVHNmGP1kEM/igKErB1/4=;
        b=qmRfzqXoHRuKDl5HBLskvnu+AT4rd/K3aXQK0uim6pX1j5seFG59ZMSZjYyrAQ0Hlq
         NvajgfwJ2uZWWvebgKWNXzdCAvtKKq6ECfyRNIgUw7ozfR37XzDGJVn4OIdSi8aFtwDi
         o4QD6t+wDTk6mJZqsJrb6gg3Agzc+MAQUuZmK2PkhXxBBsN/PtkqGAInEz79YitDIck6
         7Uy8wST21XhBbgFsTlRdId/KPahqvbjT3EmotoFcQ6SuckX7SciSvF88jm4AWiKYtoDo
         kzjtAfPEVew4E1x6hXLzNUAgeDmWk62PbpkLX5ywamvwI9+1Hc7PK2tzczEB5IFahsMT
         t/pA==
X-Forwarded-Encrypted: i=1; AL+hErHMFsohO4HRqv+D2pTlNPpRb7vMvz59VnlKQZn0Ht5lh+rc5WKSv53mAGhlop76Cq8APWipxaU1RQ==@kvack.org
X-Gm-Message-State: APuU4Z8lzPZGdZ+C66DK4BYgbwvCsT00fxuSjhRumK6s+aUryluvCwwU
	TOt+1xHIMzmti4Z1+S75GhywegcnfQ6E8tqjekq1s40As5hokGNSfDpj
X-Gm-Gg: AZFdTZd8WxHZPFl36vi8iddrR01qnVEF62/uYgGoYUnsA2pNGk+aaOM5ejxTYey1qiK
	INsmLQoOnJxQgoGBn3rZeR3YsJgRsCb4qp8pQpFre9Irk56ZPHkxuN8puREH1a5oQlf+Datu3g6
	nszZC7HNeubBQYmILwdxkBO7TEF8dQo/1pv00294F0Ha1XFnlpEIr7finCF1Z29ImHAYM3dqw3a
	C/56oV2Aaaae5Z/2Nvk9ZdVp3kQI887pj+1udVf2jn+myqHuQOh9S1d0yOFCWctjt8ZWBDIRXik
	m6NKlrJse16E7Yu9SoLj1+ZLVHbMD2zubqV3A9qwJiQJqYQyDSf/v62LJxiqEjgp25ptZghGJl9
	H8d94xt6zMMMP5QtexipWTpXDpfgTzq7jLVhUovbGVEaEND5UyL1UbDKyXg8BxXZ4ppzAyYQB5q
	qnL1Vh84JuF5TeOI/WJdabCYj125aNn6d1WC1zISra15DHIMIVsQSc9IdM5RpCIZw1dwO6AzAbi
	8XeM1/OBGonuBSmg2cIS8DEXjJrCA35kpYo35Qct54yOLhlgJRB5P7MRjYw6PEUx7pm67h7b1zt
	BlTGuFEI2xlqxzN9W+547Hnas8LZ3rQYZtA+ZXJUW6Q=
X-Received: by 2002:a17:90b:3d92:b0:3b0:91ce:672e with SMTP id 98e67ed59e1d1-3b41c8dc8a3mr20396792a91.17.1795770538277;
        Fri, 27 Nov 2026 01:08:58 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:08:57 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
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
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 6/8] of: reserved_mem: add dumpable flag to opt-in vmcore
Date: Fri, 27 Nov 2026 17:07:21 +0800
Message-ID: <20261127090723.741253-7-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 84B81C000C
X-Stat-Signature: 54gme9w41xnoexp8goryr7cnzfpqj8mq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1795770539-551898
X-HE-Meta: U2FsdGVkX1/1UUaxZGgHNPnWPjI56qDj873bUmmAp/O+OBLnfW5B00W/FXd5M9h0FKuOn/0yXwq0WY8vcRLxhqmpdjy+8gW5KjvSYxbm95DWP5v+X0AG6V533YbYU+f7otbMpXNE8ZG+zCXjFeZ6W5gyERqPV1R4mS7AL1WfEEhd1STACduQhfyzQRFLFyn8utG/S9JiFRxieP/V3+xupI4JdhW1ELa7Rsn7ECUGJs11tRTJgzhqq6SdyGHOd8k7JqiBnn4GQsJHqoXKZ8g/+K0LJSczTkGEoZ86GA5c06e+PUYqR5HNPv8AQKqpk6hxG6CHIJ6r3tCTW62glt01jXUzXr1+jwFABtF757xhe9mv6moCRaDTWpVbLhL1dp1nB4prPVo8c1x5HB+ZwQSNFOKSj+7/M9YJtzSf8WkE/X7m8PfXys4DnO44+fGm8/4BJWSp57pZYgKs9VL9dnefxLfnaPjMKjYnGXnu5APm3IdD8+IqSfy2uAOZSF7t/psAEzT4RVUhM6Arr34r+FzK9jiDOUhB/ioOizZJWWAt12r9USHqy4iTZ5ODKVyYs7eOdaWfnlWLOw9J8knZpfVWFFzYW4SuE+oghABSJeNSbLnALMafZIj+SqSrhhJfcDDKhTcWdZxkRBtjkiuGsKmyZSZ/WN7dabaHrZhxggyleMqhKieoHDVgSM4rcJnHbJhFVlT40VXmoJdNnHahMHlZzHoQZ1l7YivYXSEyjCA2z/+DptttvK+bm9IihRPo3cIVfv5g5a6XKYtEdJGDR6GF25G+XN62rgWqbc0by0GSc2g11tWZpbh74eQdxF4xu6vnykQIAiqrS7UvGNVD0X3dLVCu4j1Zal0NpW+IJ8oogkoQmxgRjwBCtFLdzni68tdGlBIxJtb2l+8t/d5vSiNHYAt1lvm66ZW9GAJMio+V8jvI1X5rg3CwWFF37fAQ3Ahb7clpsPYUxrWUeOn8uMS
 mFMTip4n
 uYQBN/FiyLN2ISrvh2ncTXwi7hDGLMHw58YQXOTWYqPaOD3CBcttmN2zn5TnJ9wcjwuzOcd/QeWnuzpNyqoeg9vn4VkyxEBjo9pZKOzVy9smwyiNYK3c5iUbeecj3k1N2GeabMChyG8feF703QYjJJcOvlnreQGXRBh4YqTyphsrvlAGjre8VmPbKbGB5WfUtEQkhZCubMMY4jX9cN+sl1YD+ZdXBZ8oK62VQ6IejxRYs+RKje3TRGRoVxHuwQkPbo2TDfa4bpmQq3yzlAZQ3J3NF10M5w3BxiNqVGJEQ5f1BoPAXXC88147Zf1cGUxTFcXft5UYLiC2oPGrESM6+SqJMEdq3wHqOzDnu2TjLRsJ8NUZ7MGKaz/1HXLFoUFw34H/E6rkQjp7La0ZKFflUi3EAalAtYedfOaSOAdU1SfowMSV4qOt0DH0ETzM40MJYrJinH+hMc2Y7yAK9C963y2KUwnXY2XCeR8IMuHkyt2ZbnceE0P0hYx6TR3O9MylY8BvQrjDOLTHHvNCxQmQw5hANdEMfDkBIekiiF5rBvLmxGQEIjew7egIBkS2gtQa1eKspam15uF7yVilUUxDDRStnLYO28hYKcIFXvinrKxgiktrLdJxozfnSLDnzU/fTEX5bxgbpodCF7ZYYwoTke7Y57z0Yop1LZAivkb7eKPfs86yvD3mBlUM/krcSiqlmjk1LF+6m9aG0SuJT7/SlBQS5Xu2kY1vVnVb7Kb74olFxsQynE+anRIP6qoyrMk07dyB2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Add a 'dumpable' flag to struct reserved_mem to decide whether a
reserved area should be included in the kdump vmcore. Non-dumpable
regions are later marked MEMBLOCK_NODUMP; the filtering itself happens
in memblock, keeping the arch kdump code independent of the DT API.

Most reserved regions are owned by devices and do not contain data
useful for kernel crash analysis, so dumpable default to false.
Reusable CMA regions are different: their pages are handed back to the
buddy allocator and may contain key data for crash analysis, so set
dumpable to true in rmem_cma_setup().

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Acked-by: Marek Szyprowski <m.szyprowski@samsung.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 include/linux/of_reserved_mem.h | 1 +
 kernel/dma/contiguous.c         | 1 +
 2 files changed, 2 insertions(+)

diff --git a/include/linux/of_reserved_mem.h b/include/linux/of_reserved_mem.h
index 7a940d1815b6..caac366bcb66 100644
--- a/include/linux/of_reserved_mem.h
+++ b/include/linux/of_reserved_mem.h
@@ -15,6 +15,7 @@ struct reserved_mem {
 	phys_addr_t			base;
 	phys_addr_t			size;
 	void				*priv;
+	bool				dumpable;
 };
 
 struct reserved_mem_ops {
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 865d7cd2f0e1..ff92dfb09649 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -555,6 +555,7 @@ static int __init rmem_cma_setup(unsigned long node, struct reserved_mem *rmem)
 		dma_contiguous_default_area = cma;
 
 	rmem->priv = cma;
+	rmem->dumpable = true;
 
 	pr_info("Reserved memory: created CMA memory pool at %pa, size %ld MiB\n",
 		&rmem->base, (unsigned long)rmem->size / SZ_1M);
-- 
2.43.0


