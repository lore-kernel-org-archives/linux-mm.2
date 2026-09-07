Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89E56C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37CD86B00AB; Mon,  7 Sep 2026 08:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32CBC6B00AC; Mon,  7 Sep 2026 08:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A74A6B00AD; Mon,  7 Sep 2026 08:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D1F5A6B00AB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FE5C16014C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:45 +0000 (UTC)
X-FDA: 85186958010.07.89BDE3D
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf12.hostedemail.com (Postfix) with ESMTP id 276EC40004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=NUZjDGQ0sJVWPHpdRhDUwY5gxIx8R+NA/fv33LP3Z0p0VAxb9Z/u4Q7gSR6lLF3rOUfcv2
	auDdjSRTN2wGiLKHmn52oBELh7RuPNsr8RhsEmBpy09HhMt/wuOmBcVs1ayXFSu/Im+Hx1
	BqanO6SvJ7fvxQV6Ogm/6biPfBsRQAs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785623;
	b=wv0ZvlYvRa/TqUdLAHC3IuDDgTSNoAONdYPgTfARmhykYgfpTNTWosapFhgCaEjDD9UaPN
	5D7dUoKvxPADQCuNx/mlyXRngb0jwUlEE9QHlZKp9osWbDZTor8VJ2RvZu5ojTrMv0LAF9
	A9ngMH9rPX9yQEctj95c6dRZbGJMwJw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PHmoGMGZ;
	spf=pass (imf12.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9eBN1xy3LsTspM2cXc9iihQZgxEMtvQyI2J8OiqZLKg=;
	b=PHmoGMGZCpSK83cFfL1l+GZjf/pY9I+6IoZqg3WJ4VLG4xW6NHlRLdZlpXZs7q+S1hU6FgzSG
	rPNsboboV+FxPnNuPRJvY6Ww7D51z6C62ISbmu/FflpvRh5Xiy1KVbEeTFJW1U4tML5IiSjG8eN
	PcED3zgeHCZOJt4Rn7qsZuQ=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtq32vfzKm9T;
	Mon,  7 Sep 2026 20:42:43 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 44F294056C;
	Mon,  7 Sep 2026 20:53:40 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:38 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <akpm@linux-foundation.org>,
	<baoquan.he@linux.dev>, <rppt@kernel.org>, <pasha.tatashin@soleen.com>,
	<pratyush@kernel.org>, <ruirui.yang@linux.dev>, <kees@kernel.org>,
	<ruanjinjie@huawei.com>, <thuth@redhat.com>, <jic23@kernel.org>,
	<tan.shaopeng@jp.fujitsu.com>, <zengheng4@huawei.com>, <james.morse@arm.com>,
	<ardb@kernel.org>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <hbathini@linux.ibm.com>, <adityag@linux.ibm.com>,
	<djbw@kernel.org>, <seanjc@google.com>, <liaoyuanhong@vivo.com>,
	<vishal.l.verma@intel.com>, <fuqiang.wang@easystack.cn>, <makb@juniper.net>,
	<piliu@redhat.com>, <ebiggers@kernel.org>, <jbouron@amazon.com>,
	<mclapinski@google.com>, <me@linux.beauty>, <graf@amazon.com>,
	<bgwin@google.com>, <takahiro.akashi@linaro.org>, <palmer@rivosinc.com>,
	<x86@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <loongarch@lists.linux.dev>,
	<linuxppc-dev@lists.ozlabs.org>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v4 11/12] arm64: kexec_file: Simplify load_other_segments()
Date: Mon, 7 Sep 2026 20:54:03 +0800
Message-ID: <20260907125404.922123-12-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 276EC40004
X-Stat-Signature: ajxepe98iu1zfu718xtyw8mzc79a9zu4
X-HE-Tag: 1788785623-976219
X-HE-Meta: U2FsdGVkX1+8BemSa1PQ39L+SCYvgmcXJ8BtNCKZ5QRFmMLVumYEQLzU92Dfgn1oWYoAZEgIBbjlA3LNjMKEDLa+xDYwID/fjHhoxZmU1lTmosaG+ESdwgNOuIIWvF58CAPDfZ4Ki9mzyVhhm2BVOJGBTG5YhmzPMMoNxsn5dheOl6QeBoBfcdZQNlLUjyA7Oq/O0JErRwyt3cxrGDkH3rH2mcwB6o7UUEe191B2nfp3ZeLWSe6vNShXjXiZ0JK2ZNZWuTh4ZDqKEy/evDqJWKfpQFlBcXJtx1VZIwiVkLWBbiDD7kqv6UyVHbnUNsAviZNyMY2oNF33EHHrpeu042+6e8TU0IsXPCymwVLvDsAwEW3QpU0FMStFVbRHJKcHkiCSozD65qaDbTWVOUUdNmCpF7w6E/OtCffg3WLdmoV/F4YIO9nLRdqhtq3xnPPNbqmbIxZzMnNqof7AGL02gC8ODXIeuGBbrgrl20111Bra1I++fk0L0NkPNzlXTwpZm8mKOZE+IwrZWCUKW7hTTZ9pbn1OrquuQj+qo/jN9yldQ0DJaO8FViwkAPidvRX+RL7dbEqTys9E8LE5EbLhN/9FqxXJbBbNo3CXDHCUd7tYg73z/zgbzbpPzPiI9TLnQ/FXJgrY5PEPUtGtgKmdSLlhdy4iVHUdOmRhK8ul3Me2AcszNfdvelZt76BZr/6sgjtzz2P+n8j4q2ZK1kUoLMxYhtz8eqqxYWLm3zeTGjzGn0XX/p3CoEhe4x77E4YW938uR/F5cLOgfiuE2QvDxK7xib3WoNdxhW8zCwqucdNthYEqhF8VyoFC2cGnCQ8pxAO/l8PUBA1QErECnEv82/MPH86OXZInNyhiNIqzAeWDwCxi/l8Qba0fIh1Rv2EWkq5l0zf8DUYRqn9weIFzMjd1nFJXxpsYE3dv0qtRwNAeSDqJ994e/UJIt0KMx13/c9Kpjdm5QIF9BJdI/dx
 uQtb9ZFu
 M7PoE93baLd9EAZEdX5JIyEr+2WNZAGVXizjU6HNM3WItjerqKRkN9ZRF05xln/LgG46dfnRdifSgKj2qPYYwjFknBpANtnL0nuOnNUXvvOwOIanNRJ/jDex3i3YfWyOqkh+GWKrcnFfQwFW7PzwY0KcTdBO0P5P72tCG4/n39N3ehvqpHcQNxh1DKr8L6GK8SR0Fik1R+2k4BQAjQo54L0f8FNharVWLlGJBUWCmgQjEM8j6JEcd7ZyamcoBuVMUYFk80U9omXk3rvFoqhe9eL7hY1PZ2nfuyhp3FUNptSJr3fVJHaA7MzZEsUol6Am9AfDU2poCZ/mP6GhmDD1oFj5HQoWR5zMSu28ka4LNWmOP1ww6LX3wJ3ZF6HTnpi4jgNrGFInFPjAJklUj5Gcy7xQ5rXizoFE1aHcCYJEuwQ/SSI0NdpFxU3YyrFdBwvbmqGUhu/mipdWoQ0hH6jgGHkYUuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use `kbuf` fields directly in crash_prepare_headers() to eliminate
the local variables "headers" and "headers_sz"..

Advance the assignment to image->elf_headers before
calling kexec_add_buffer(). If kexec_add_buffer() fails, the explicit
vfree() in the error path can be removed, as the global infrastructure
in arch_kimage_file_post_load_cleanup() will handle the cleanup.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Baoquan He <bhe@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/machine_kexec_file.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 2f750e5f4fcc..3d907f8ee594 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -89,36 +89,30 @@ int load_other_segments(struct kimage *image,
 	kbuf.buf_min = kernel_load_addr + kernel_size;
 
 #ifdef CONFIG_CRASH_DUMP
-	/* load elf core header */
-	void *headers;
-	unsigned long headers_sz;
 	if (image->type == KEXEC_TYPE_CRASH) {
-		ret = crash_prepare_headers(true, &headers, &headers_sz, NULL);
+		ret = crash_prepare_headers(true, &kbuf.buffer, &kbuf.bufsz, NULL);
 		if (ret) {
 			pr_err("Preparing elf core header failed\n");
 			goto out_err;
 		}
 
-		kbuf.buffer = headers;
-		kbuf.bufsz = headers_sz;
+		if (unlikely(image->elf_headers))
+			vfree(image->elf_headers);
+
+		image->elf_headers = kbuf.buffer;
+		image->elf_headers_sz = kbuf.bufsz;
+
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
-		kbuf.memsz = headers_sz;
+		kbuf.memsz = kbuf.bufsz;
 		kbuf.buf_align = SZ_64K; /* largest supported page size */
 		kbuf.buf_max = ULONG_MAX;
 		kbuf.top_down = true;
 
 		ret = kexec_add_buffer(&kbuf);
-		if (ret) {
-			vfree(headers);
+		if (ret)
 			goto out_err;
-		}
-
-		if (unlikely(image->elf_headers))
-			vfree(image->elf_headers);
 
-		image->elf_headers = headers;
 		image->elf_load_addr = kbuf.mem;
-		image->elf_headers_sz = headers_sz;
 
 		kexec_dprintk("Loaded elf core header at 0x%lx bufsz=0x%lx memsz=0x%lx\n",
 			      image->elf_load_addr, kbuf.bufsz, kbuf.memsz);
-- 
2.34.1


