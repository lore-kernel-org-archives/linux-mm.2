Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66C32606A31E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eTuX88hk
Received: by kanga.kvack.org (Postfix)
	id 79FD96B05CD; Fri, 27 Nov 2026 04:08:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7771F6B05CE; Fri, 27 Nov 2026 04:08:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68D9C6B05CF; Fri, 27 Nov 2026 04:08:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EC4B6B05CD
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:08:49 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C80E31A0209
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:48 +0000 (UTC)
X-FDA: 85480323936.30.0668BFC
Received: from mail-pj2-f9.google.com (mail-pj2-f9.google.com [74.125.227.137])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFF62A000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eTuX88hk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770527;
	b=aw6BFX0m8hU24TgxMc710Ua+uDARlLR/YVCVOiAb3gW/Su2DUbdLdfVgQZMj3mSfLpKLiJ
	LU4PKO5J7Sgi9nWJFA8erCguEH5J/HZV6L11mDlb2tjdRFqG8RvKRI5m+ngCuKZSyt2MqV
	8CChhAp5jvBgT7l+1/BhY8X4KJZuWHM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVjCV5oykzsIMcgSWFAsGQFYmzyPz2B20ED1sYdHTJ8=;
	b=YUKHIoP54gZPWqMba12XvKxOdRTOpiM3zRtb06W5OChJtjKnc6yaqvWZD2+RMjcKI1Fuj6
	gfbqyR2dKOCjdwx83aDlTxJjIZpP535YYKbU2yHf1JAxZhgorGmD/s6o1BDQY/FrI26SBg
	jh1tCXY9bZrKupNyztmTwLXQALT56YI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=eTuX88hk;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.137 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f9.google.com with SMTP id d9443c01a7336-2f06c2c371aso21136565ad.1
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770526; x=1796375326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PVjCV5oykzsIMcgSWFAsGQFYmzyPz2B20ED1sYdHTJ8=;
        b=eTuX88hkr+hQucp7/PxXz4/2mueaOckjBUJAmCp8XMgshLRxMZj0lFfanIRMYLkeWT
         hwEK4Bm5i2kb1+GSJPCQZz5psQADcPQ+vz95wtzcg2ZnNGFvIBfmrlqoS+ayBP4qpSJn
         VufJuXcCIq6vyv03a5hscRr1dKeJW+gluprZEWdttbOdRD5c85QVb+yD8qRyD+636Fwx
         UdTRopsAlyZB9uBUuCr1Fd7SrIbi3LcixYLwwTVT4E2gX3Pu/w2v3HqPfJBRA63jB3mr
         OXHGEEMgtZKhvQL9GQ4Fs8v/Hip0BAAT3z6cuGw4NeacRXprgXAhNtSrGaSJ7gT1AJk0
         FpBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770526; x=1796375326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PVjCV5oykzsIMcgSWFAsGQFYmzyPz2B20ED1sYdHTJ8=;
        b=edR5SUvFZdhMgII8yhsmCk51ZSPiPd/efir2eOPrEZboiu83LbDTQY/nX6/t6g0TCe
         qrFH2hA2YwqeKpj7CBNTixlFNcA2wmiDZXzFoCh3TcM6GhCDS0CA9wqVtXSyMXN7Bu3y
         yhApT3iXD0ZYqWXCiJ4Ul+j6hStB49iY2bRAWeI/D74LqEIgYNKkfJvdd8wDbeWdy82u
         6W86mFm1hsTKEMLI+X9SgllgoY7JO/4wuwByLAdmnszm9EV3kyUh/zpKNUuALu9SKcys
         PRRYfT8PcyS57rNUurI2cd+dWwUVMNEJAN2+lKuvO4BMPY7YE0GQHLASNYkxosEgU24Q
         pWkg==
X-Forwarded-Encrypted: i=1; AL+hErGZI9xkqWRfBdvKLOLMXpK+E81fAqF0YVtViTbIzA0rTzC/AEJ6ZQoP5YYe5tVrij4lGBkRBFlwow==@kvack.org
X-Gm-Message-State: APuU4Z/n93JVpnAAgFzRKhBntGp19His4NHfPazIWdAjU6NbIeJUSc9W
	hMBaI5GReLAnOG3dC9YPeMU9KXibWbCUYhHdQvMm2tcJlkpwCrlEgewH
X-Gm-Gg: AZFdTZc0hKGGLnCmPC04h8UfebiK4webM6vcoYCFaDC/EUsPr3hhtcH6LHIBPSKD927
	KxRw6q83XMUvJxLjeHcNris0Jm24CIkOOWuxuGM8J4SpC5fYYQu5SRijEZORMSxsFhP3Y8sKNnL
	C0g2h5vlyVjPIcsxIS/ktOzQ0GXS1wC/ZwDzEuEmiZZNhHXjRt3zJ29sACO/qkGVOvS1k87BFBa
	egNsBU+UKVargRwt7D/igoOIafiI8hiYVKGrSVutddA7kKxkGr8zLoutluKif3zd/48rWNXVHK8
	PSzJ7BpKr/ROhyWbX7iDJMuzAB6tFH9spKM4BTHJ7jBh/rRQ45zFEFQ/oAqy8If9Fr8WUfj93eJ
	tASsGG+XVPJcQq/2MEaPhYLSEsYtNKbu7QZtGxuwyySGdM/FMsXOrh3Nm7begbyZ5Q6f+W2ZO03
	rSOYJ7h7tOakXj5qAyO/9ein2XQdwWpQkUnNjwAf2r2hwd/NS9eULfP+6oyPqtOVTQtqR06hAj4
	Rfos1+l49XWtfcc4SfZVLbOiJLYl80lSIv92AlHbkNlBPudFZSpNOSIAqrwPnDgBdDux9pIrnij
	25TkkqRj0lePPapSGAez+mZzrER94jepIXKG/8bX1g==
X-Received: by 2002:a05:6a21:8982:b0:3e2:4350:1528 with SMTP id adf61e73a8af0-4014a274c36mr23147815637.7.1795770525740;
        Fri, 27 Nov 2026 01:08:45 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:08:45 -0800 (PST)
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
Subject: [PATCH v10 5/8] memblock: introduce MEMBLOCK_NODUMP flag
Date: Fri, 27 Nov 2026 17:07:20 +0800
Message-ID: <20261127090723.741253-6-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EFF62A000E
X-Stat-Signature: n7u974em34c4413s9h7c98979f8qfofa
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795770526-60284
X-HE-Meta: U2FsdGVkX18yLlDs+L6PcnkrM1dZeSR0HzofnTrjh4vPqNxATtdDf5kDRApD4z1HfiuVIdW9FC9hFVNq/r1YPYDIz1XQyR8iVQs/jNbMwpMnjqa/4Rn4qJT6wH5iwt+wcqn6kwhXFlJ2FJFMARpk+2HX7tJ0YsLIHU+ihBm82PvdDAZp6amP0v55EPe5/k3Fm91wTG5r7UJA/3r5LeIgQK98nh8/PPLobkbrpayoCHD5mRnkMyyqaryMA6w/fjuZTQK6mFJ/wqUIhdfH/b/VYz1gVPuQEeQKOKnPYqf+YqNduN2qU7220PpX7p+Vgrr0j8zdmNBbWCOmN4o5XG03ZjFa2FvLj4CQudbwrxKscLK/wP4Ewuyw2HBwPcsSHO60ASipfrxSJMQqOO2nHm4RCpm3oNS7J6rkihPgzDDtDJ8DeNqh5DaKKuZGU+JesOCGlIqLD4yCLU4NNZdfcTgoTY6w17J8cLaXbCN2AvJmjNRNL8WT4G+qVpaAl9XKl1X2FAH2jUjaftthPzWeP5Tm/qlg/9YbZP5DQBFFizPfm5UgDlCvGgc5Mf7TcjWUGSb8iOFHwSk2WdbzK0gA6n3Sh8rgyp6WfbQi20opDNwYBMP8IeO8flgEKJNoG/9LyKYHd1sFtsCyDAiVQ3QOdoV6BrX+amtKxT2J/8BxlY7Pj9kIV/bCsRywNwTuQ6ZF2Buct2jPK4pBNaraX/X2QYY8rHU3yWQgcIeMjVc/8UHEeqTOJbTWUDd4RSSVCN2KDX0oPiFHhxEWG+BT+LB0R+ZKGuVb3WDa1gHrCmi35sZtY8WwsBJ0ehRke1MA1Xs+N3OuC5TkfuuxSE3FAxac93XtwDn3Fm1+Ip7O1B0ZBQDmKTIHBaXCR/2K3pwYSJCPRreCKyrE9+vNUBLxTiD4i2nDTvbqPKc1wEJbazhorakP1Rw/35Mv8Yke38V2PGOBTiKtGb8Fo201AToBxQCLeTQ
 FFpEj5PG
 s4EJrQAf61tDrzFAN4AfuG6o26YfPW4rboYeNTVHhFeNbPsLUou/wXpzeQPcVc8+XX5CTnidN0H2b3NDlOjFHkTai0WeZ1vFpSJa36VjyLpOxuxoRtNCvGcNSGus4Px3EyvP32+WJi2A/ehyszgzjuk0hP2q1kPAtrc+RKto9cCimUEFmZqzk9/+mJgSkHQ8Y9mGZ1XoKP1E5vMfPw13emdqoxrRndaRHL+JTAC6+1wxumD5JSl95pZDwjR+Ccydz5noe7S9p6cLP/HfkmeOSnc9PbU8fIQLXqtw/+wgaS8qKMImbxAeODU8LzYy94yVXptFbKoNgrfNLaGPUXRXvPQ++xrMoYfdx0uddmbMQ5h5vNS4gCG1Uts0yvuWtpggTxmmfbOYeCeKGPv+qDgUJGgbHXvOSWYdisf1wt6L8Svtxr5TrgtAfdhYjt6BN9BIvZvhP/I5xxU14Xnf3CunzfwpEf3qqgXj7n3C1bqyWB6B8bD37Y8mOtdSIczMIBrMuZPSFuQAQjn4JR5RHbvGoYmyZZVU4kYcDNRIz4xlAWdLrikXZB3xXj5tdaTsb7GHypitQ/srjQal7glQ8maOmnpDgXCMDBnt4hOnHrK8i9gDQIC+GvM3PL/lqwjfnte4vqOS5H2wSgH041gwpH34qsB3vYq7LYxKhQtXh0dbdjcfLIX3pUi2JEyx87+zNurJ3pRgbMMoXnrECjUgBIvSfXvt1l5GuOyarEIpigB6IzZOyXMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

Add MEMBLOCK_NODUMP to mark regions that should be excluded from
kdump vmcores.

The flag is meant for reserved memory that carries no data useful for
crash analysis. Reusable reserved regions such as CMA may hold useful
data, so these regions must not be marked MEMBLOCK_NODUMP. Subsequent
patches wire this up for /reserved-memory entries.

Suggested-by: Rob Herring <robh@kernel.org>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/linux/memblock.h |  9 +++++++++
 mm/memblock.c            | 16 ++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 40e6e0aa2f8d..67dbcfda6f49 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,8 @@ extern unsigned long long max_possible_pfn;
  * know is good to use. It is the only memory that allocations may happen from
  * in this phase.
  * @MEMBLOCK_RSRV_HUGETLB: memory is reserved for hugetlb pages
+ * @MEMBLOCK_NODUMP: exclude from kdump vmcore. It carries no data useful
+ * for crash analysis (e.g. firmware carveouts).
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -63,6 +65,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_NOPRSRV	= 0x40,	/* memory with no KHO preservations */
 	MEMBLOCK_RSRV_HUGETLB	= 0x80, /* memory reserved for hugetlb pages */
+	MEMBLOCK_NODUMP		= 0x100,/* exclude from kdump vmcore */
 };
 
 /**
@@ -160,6 +163,7 @@ int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_noprsrv(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size);
+int memblock_mark_nodump(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
 
@@ -305,6 +309,11 @@ static inline bool memblock_is_kho_noprsrv(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_NOPRSRV;
 }
 
+static inline bool memblock_is_nodump(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_NODUMP;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 0f466fcfc719..e3ee7f60ec97 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1221,6 +1221,21 @@ __init int memblock_clear_kho_noprsrv(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_NOPRSRV);
 }
 
+/**
+ * memblock_mark_nodump - Mark a memory region with flag MEMBLOCK_NODUMP.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Mark the region as not to be included in crash dumps.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_nodump(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_NODUMP);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -2864,6 +2879,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_NOPRSRV)] = "KHO_NOPRSRV",
 	[ilog2(MEMBLOCK_RSRV_HUGETLB)] = "RSV_HUGETLB",
+	[ilog2(MEMBLOCK_NODUMP)] = "NODUMP",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.43.0


