Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA71CC61DC7
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8C3E6B00ED; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3CD16B00EE; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2B8D6B00EF; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0B676B00ED
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12826A2E94
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:31 +0000 (UTC)
X-FDA: 85142887662.17.CDDD2CE
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf31.hostedemail.com (Postfix) with ESMTP id CCCC920002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:27 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736328;
	b=3i9W847zluHsP/pZzPpssN/dzi89J0eWe2TSfAnHYyQDtFhuba2SPIV8Ht9kikgYOhHL2J
	CQChKdPMoZiBFYcgC6yaGD4B1VGkGYt57KHxMpu20pS6ZVmx1DPDB2cNJkU3Cdj1ZKtc0m
	dRseUSt9CYQCKReXJD1dyc9T4wUECVI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=mzAak0iA+Fp/KKp0Gv3WQjn2EMBZgKiuvs+PAnzoboaVu2EIVCtoFQhfiAwkLw8EDIsgZk
	U8EZ1Lvd7CHljq9tRWO7WYFSsCw3NUtAodkXHMkCX4St7VmpA/B7uepCHwijagJpVPIf5N
	xP/Z5T/yx+/wOrvtZnUG9wx64SPx7k8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=WJsU5ZLPqqnObamEl+eDb1OQLn8fzTm2lS+jqZvsjkBOcZoPNvOCq137VskBlGKfkXIRHLxz0
	r3TIwLJgnYKX+hhXcyhYsMrcfZw4l3uKg5x5sTenzOpFogQlp8Dx4ywI3SARgUR1LDQ5r9Wjz1F
	GJzxQD5oYk6LTh2w3OIGcw8=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrC6g9Pz1prNF;
	Wed, 26 Aug 2026 17:14:35 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 6EC4740561;
	Wed, 26 Aug 2026 17:25:23 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:21 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<thuth@redhat.com>, <gshan@redhat.com>, <jic23@kernel.org>,
	<james.morse@arm.com>, <ardb@kernel.org>, <leitao@debian.org>,
	<yeoreum.yun@arm.com>, <sourabhjain@linux.ibm.com>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<ionut.nechita@windriver.com>, <liaoyuanhong@vivo.com>, <seanjc@google.com>,
	<fuqiang.wang@easystack.cn>, <makb@juniper.net>, <piliu@redhat.com>,
	<ebiggers@kernel.org>, <jbouron@amazon.com>, <mclapinski@google.com>,
	<me@linux.beauty>, <graf@amazon.com>, <bgwin@google.com>, <robh@kernel.org>,
	<takahiro.akashi@linaro.org>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<kexec@lists.infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <ruanjinjie@huawei.com>
Subject: [PATCH v3 06/17] LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 26 Aug 2026 17:25:30 +0800
Message-ID: <20260826092541.3905933-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260826092541.3905933-1-ruanjinjie@huawei.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf500011.china.huawei.com (7.185.36.131)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CCCC920002
X-Stat-Signature: sbuznbuey1omajpxmxau785yrxt4d4iq
X-HE-Tag: 1787736327-976151
X-HE-Meta: U2FsdGVkX19wpCza18orEcTWajiN+7SF95E+gCiXWHOPBROkldffKlEPwDvDiDEzspQj2KZKSUa9C+6NIHqMQeLemlSn6U6YzpJhmy4UppVNKkI2fyuW2fZKeMW4knvj0iB6jWi3ywq+qLTS/DER5TitAb/C3Gm3bWjjdq5iRPNvvMvHgg6HlrJZkxRF+WEFcT5M3uKz0E8/sPjau00kDc7d7x1ssn7265Ph17eTapw3H9+xKcu1mqF0uTY3Eq15+eFyDD9STmPD7W5oivRVNSWrdG6ANipyw/ax1AY7/G6QU8Aalcis55JKAMce5Mkd2h3ziqbgKuMb2ivxNCnYWQHJriihwmGR8H8I5eF/O3jFwIGinA7b4qCMv5uHMFsBEAmrqUxQqPb8KxWMszf+WnUWida3FWsCkqRT84SKQu+K3nJ2vfkgJRvIPrFRYtwWiWa/5+12YQQ8tSN612FNbrUkEw7VK9WEOmdkUwkC6P4/vjc7iO2H9Nw4QtNvxpMWmF3CcPIjNYbGQrk70FuMlRu5YE3w3v+4pjNEkJoJqX65yRxLNi5D6M2PtDGAfQj5+IzAwjakxesxpi204+eABnzPO29abTxpOCS8axDe8FbhTtizSHUuGAaDVsXxcv5WPAljusFRYGdeLT0+CEcxREn4JdjyINwQLFEgCNu06k2boqh6qloOYw7v0LpksOuDXwJerTSHkx6Fh9gUweCb4beYNPBVrMsn49gUT81Da9RkNDUh3Ky4G65JmKGNNwu4N73zudi2mMgjRGSOILiR5oDSNGs19XtOJFakQt6o7gNPaH3kVFQa1y64boMCdWF6x43GQeZ3FmkgsmXzRygStcsSbiBNqEMHpRhQFZY2Z1U/uXFoSbT7v7zRNcpDepbCspoHys18HKw4FrIIQk9Bzf8ibzptQCj2RCL+gyRxZXM1KxPiCXo/1L7tsgLEKrv4Zqof6ugip+ECW5b8fvM
 hHUJic+f
 oTIOJs8S6/HAMYUb81pL/53zygWypNocyxLld5eJFIGeBV+7po1reACqmPk2e9Z1RpN15n0LJkkRULAVphs8PHCfMq3/xzR+pX0diSdqpsvJnrqxL/VooT3PB/7Uoe0g74mOyp/h9xt4kYuUJbfm+G+8N48yCeaVPpKS7b5BU8xjMZQQcn64Tdteh5cgDJzlBTDt6xiDh4FYZ6FWMvxvoK21i1FFu9uzTXVYt8qITx4qdoufIWAAT7TIlVdDPv+KZUrdZ+hAsKHM5I/+zSyf2p8rD/RzAz+UT7RnjPMd9c+o4eMDdZfIVL2vn5muU/08CxxzLQPOXkje9WcPe+nW3l3RjeJng0CAS+bPMhsTC7e1ZDHqLK7gwKm1icZFia0sWYDqrHsIiKvuqkDRMx53zUysVn8IArDPR2A9LczwumNDN3TqvW9R9umnIoPuAjPYx+wml
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If load_other_segments() fails after image->elf_headers is assigned,
the memory lifecycle is safely managed by the global kimage object
and will be freed in arch_kimage_file_post_load_cleanup().

However, during a retry loop in efi_kexec_load(), a subsequent iteration
will allocate a new buffer and overwrite image->elf_headers. This
permanently leaks the stale memory from the previous iteration before
the global cleanup can track it.

Fix this by explicitly freeing the stale `image->elf_headers` buffer
before assigning the newly allocated headers.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: Youling Tang <tangyouling@kylinos.cn>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Kees Cook <kees@kernel.org>
Cc: stable@vger.kernel.org
Link: https://sashiko.dev/#/patchset/20260729031235.2840255-1-ruanjinjie%40huawei.com
Fixes: 55d990f0084c ("LoongArch: Add EFI binary support for kexec_file")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/loongarch/kernel/machine_kexec_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 62a5be102065..3beb6977ecc6 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -166,6 +166,10 @@ int load_other_segments(struct kimage *image,
 			vfree(headers);
 			goto out_err;
 		}
+
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
 		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
 		image->elf_headers_sz = headers_sz;
-- 
2.34.1


