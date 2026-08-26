Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B3CC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F020D6B00E9; Wed, 26 Aug 2026 05:25:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B806B00EA; Wed, 26 Aug 2026 05:25:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D798F6B00EB; Wed, 26 Aug 2026 05:25:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B72076B00E9
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0ABB71A02FE
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:24 +0000 (UTC)
X-FDA: 85142887368.24.775C2FB
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9C75D180004
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736322;
	b=8Q8P4O/vz3L2EZW+Foo9R2zCG3Q3PBPE6dr0r9fayIoC3dMzYXXwUo6Ao67gwgS0LhLGuI
	CQ06l5trFXYD3SqYts8LKufweNoptVdA4t/jf6kwGTzOCyWlCeSKl3FdaRz01AoqLJreow
	n9yfoQAEjC3XxRIcKqINl1hQZh8O1AM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=0c46Q1a+RIrI86a0QdBFwW2a2xwHD0bOfb7hIC+ehuKJZspoHx8fP51T4kSX5e+bqji5t+
	LL0xvfTL+1B8hb57SFE72zI4XGjXTJPVOTWRbjw6pdi2urui0zQxCTk3hztTRoK6xBHG3+
	m6GFpIbgLkjrnCt1JyiyrLq4G5vH5TE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cXqqzSbx;
	spf=pass (imf06.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=RK4VHRefALxjC8rB7K7w3VAwG6W6KlTC58IWMIYwUgI=;
	b=cXqqzSbxz3lvEuOS9efT6kFVnZWykzECj9tiFIF8xUH5zySw0l0wtrrPJavS5/6c0ugtHU44w
	TQx608nHzqqoqjifoGQQm3bSkj4dVZdXvljaZRoir8tVoNs8JWQj9Dkf8ZWXUzNH3gtlFlTVTbj
	f2PJ9QOpTcwTuI1J8MwWSoI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hVJrj5Vvrz12LDt;
	Wed, 26 Aug 2026 17:15:01 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id D4F9D4056D;
	Wed, 26 Aug 2026 17:25:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:16 +0800
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
Subject: [PATCH v3 04/17] arm64: kexec_file: Fix elf_headers memory leak in retry loop
Date: Wed, 26 Aug 2026 17:25:28 +0800
Message-ID: <20260826092541.3905933-5-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9C75D180004
X-Stat-Signature: cp5djj7ba8ug5d67xxdu44i45p3gtkro
X-HE-Tag: 1787736321-459643
X-HE-Meta: U2FsdGVkX1+slYbzrHPS+DedjIPwIuKKJzPw4/+yKkoI28yqr76DHMopoIyV248aTi+zKoP7jZL5I9Ou2aDTAefwlMTJEP8FLe2YG9MHeVLGSAkVubdfFqpw3SJPVeLe/N7auTZfTEtpntp2nNf/N1akGt9/cjSguZ9+C7eEOFEBiRjS4nK8CDc02qif4l/mm3VYvmkQ2Xow1HlFZmLQFhh/eyhfyzjFZ01mBd2VB66tnKP2qfGss1wJgXKShkHmPVjOrk61+bvt3TYOEOLQ5PUL1DLgDbhBjyKtKirYWXBHefrAAw0NzuBkZwf73EK5m5jzJLjJzZyNllEEIc5zQnYpBR/hqoRWnYMFp2mx4Kjljv/WewUi8qK6pKbXNHiz6Sm/5lZ8ZrWHBkH9B9LGrQqjqsOnv/xbDClEPGLKseApIGdMsbYlKmcstVOiUvBGXQyk70O6us8rOp57pabNa4hsGOZB88R/ba4vJCQNptogYhN3wj1AphllHaMaF5H5OrDo95VengvXbuluKsDVtdorXo8AxhIWPEFcu7G6AYz8c7lcrB7N0UVYJoAl5TT2ibYbhdJIQVuBkWJJKWnCc5BrKl+Phje/Ku9V39UbtkxxVqIu6SbCvM/WKaLVnIqV+Nf8Mpr+CR5RjZKwQbDGvGNEZ6PWEB9yngNZMzzhmEWyHOhNbMU9p7esi5XLGilnDv8MiopfdLvaLsLt5J/MNylmxzhlsLHU5L2RiY+IewJ8v2mNyd/srcJshj7ZKUspaMcsdNOYhUV4EsLhvByKVrXLXPhszz8cgQ0grdr/whZIY7PpA587Ag1hrJYb8C2fZc3T+rSJvbGwmDSB+BPD1xssygECHzdYcAa7+b/eTtAcvlkyXlGjuMc1GwCVql3i735jRekEv6gWxWhEs43sr6uFoSKuu43M1/0RgJpyM9i4FACyxdgEv3qwASNtGCz+ujTWIJQ7IxzVxH+GQdW
 6jcmOLVV
 zPK52HHVWmGn+8KRToCYbXlHheoX4uB6/OlKhcm3BvQdp7XpH9BsAxIv/lIKwg9zCeKhDHM0DVBpvll4PQxN50qATvZI/4P8K7rwzhYFuh63fzg4V3q1O9oqCK7Z9IrGBOkl+jp6U8KYDqnQfACpaMNmAv1yNGY5aBfMPqjv4ypMkLyGCnw/H3brQCumJvHlWl8ollJSdEwMO3F5gUzGaNAaUXOGA9HpElSnrqJQMS9DxtoJAUUl2870fKYUqs+14wUnOE9Y6WDX8M9f5qkT08N/1Xr8bOCamQqMu5vA4+GiWu5oAlWmEtYUyLG7NmOQ9i/4do87DXV34odBBiElFHpgeVse5lyftYroQ1Rf0MHMTRQQmbErEcAX8Hzg6Pho/ltTcECQCF5IBjiu2Yl9DFfzez6O6p2PlDMxGNuZLVtgl8DYvxfZRsx0PSspWqceWPoknV99RLoWCSzwANjUX2xe/WPsSfhEMt8YqXfFm5IM8aKNI/46tk4xqzcqWaS2/bxdnnz76a5CdtPsfXSwkg6rMHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If load_other_segments() fails after image->elf_headers is assigned,
the memory lifecycle is safely managed by the global kimage object
and will be freed in arch_kimage_file_post_load_cleanup().

However, during a retry loop in image_load(), a subsequent iteration
will allocate a new buffer and overwrite image->elf_headers. This
permanently leaks the stale memory from the previous iteration before
the global cleanup can track it.

Fix this by explicitly freeing the stale `image->elf_headers` buffer
before assigning the newly allocated headers.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Huth <thuth@redhat.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 108aa503657e ("arm64: kexec_file: try more regions if loading segments fails")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/machine_kexec_file.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index e48f29167b38..2f750e5f4fcc 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -112,6 +112,10 @@ int load_other_segments(struct kimage *image,
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


