Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71D10C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CB896B0098; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3551D6B0099; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21CB96B009B; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF06C6B0098
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:24 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68ECB80638
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:24 +0000 (UTC)
X-FDA: 85226448048.26.C9F24C1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3220720004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725862;
	b=rMIkXEl4f7IEK2seZT129e+HAQvwB7eAgTAv5ZqV7gaCRHMmDnT2M91wB/LKRkA63chw+K
	HFet396OXmF6QLtHKyPEe5zQFinyTUB/ryQzzsWmSCnx+TVe7vNog2Rkd7S5XLIdALnlqf
	NnL2Dg0rVu91luiKcFWahj3hF6Y70N0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=xq1YbTvD;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf31.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=HyGMEzfPgbSoalhNkTsf8ihtMD2hbkdN4cWSL8C7Ye8SQfnFpLw4+VAo9P7sC2inwoJeK/
	9U3ylpon1r83mOEt8F83PvfkO582aHFEYuQPN8nvlyz2FTWKOQUSqN603uV+Rx1pUzzn2w
	tpWccYuGPXsLOGPjRLV6n7X8v4wDTkM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=C/N27OffVwB9HknmerMZN+vGpNQOngX4+yhYYxhlpgs=;
	b=xq1YbTvD3XNNnXqFEYm+rNDxG6EdsqcQH0HTMN1s5TayGIm1XkNSyQvmkbCWJmLw2RC3Hg9MW
	03OTT0taTlXRmwul+dn+StNpv/it+wBQ3leQZDkbShT3eaE7XAglReIYtuKqLTKOKW4s7jvAaSh
	i66n7enwbsFGUXQhFmGkLKQ=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hmScB0ybcznTVd;
	Fri, 18 Sep 2026 17:53:14 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 0BD9C4057C;
	Fri, 18 Sep 2026 18:04:18 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:16 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 06/17] LoongArch: kexec_file: Fix CMA page leaks in segment placement retry loops
Date: Fri, 18 Sep 2026 18:04:31 +0800
Message-ID: <20260918100442.3841135-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3220720004
X-Stat-Signature: axanoz9hqobd9z9uu4fwmm641ekekyss
X-HE-Tag: 1789725862-873206
X-HE-Meta: U2FsdGVkX18kda5UyI5J2GqDpS5fiMopcMZmpbeh0Ul+uRSubeA4e5ELSKRHqqSBJVji1WkPBeMhpNp8NkhFTTMAEMBtdstanEoCBcT9zfhjgnt4bHekPoXzfw1/iKvHL//8nWWQ3H96o4/6qeoVbNhQc71Yiw9g2SSTUFHevLL+sutobpYtneK1fRgKkHioLIlvonw6saprpjkLVhMyUgsRnA0FIY1LK9mQ97IJaiDe+wxvVEK4wO8TfoOaiTEgcB3pwoYPSrTjkExGeDsyjATGllb90exLMAbumY3VV4hIPoS0f61YnPB3oFCXxbss8JAUehgQp/jf8wyQj7BQeywY+TrRf0+HSeXspB+vO4gLQ/E0lzf7Pq6rZp6r3gt1x3ULSt1gkeXD9OoA7H+41S9+3wcNmmMw+Blwwyy3kzbsMlLuOjYP7G5scrh6kdrwYK/EqlupAuyQadasEdOnWg3Noip0UBA/uKW+vaMBJMvzMPYivX17Eg6llE5OHIts+UQsUwTX79Vz5yZDKArMKz9iuCvCsVQ79MYD53M5sjOqhmahRtLAUHa7XvOlXrOhJACQhv8D3jR7gnSXLCkhXFGmPbAWeNpjFZ1flYq3LNnFv9145HvfGD9X+zka2aaZ6BWuZvuPNNnACsFO572iUxTpfjMfpVbfSYtEhkKvz9+rl+ZY8ZEcjG5VUyDRhMFoq/Rcl09jnD3B9VlMSsmvj1O4OOTcpc70HuambSfNnpBddQy1/L3N0L0NS1FNSXM+zjxlI/Xjx55wbfEDJWEJFZdXuF9M1tkG2/V/twOPLMVh5rE/VerlqKJtbnPARHyVNPXDnFXv5FSUcLunDg5D8jCnrGNmcDkegW0W0okqCgDWWnUBMNEsUzFPJIR/wlWQIuPVMXLiY8Qi8JiGnBp1xxqTajPb8gYcWJIquSGmXqJhFqdqqUD0lJBRUe9xmWcW00COrPX1l9Bz3077i5u
 jMWDTUcL
 wM4upzk6x3swIr060gPpypFOY49VVlDuFJvq+eI4+bhKRqb3Jt/9CeqiQyWQwwJgugUJdhruocpKrWoOlLsbNBO1ltVoZK1nf8ayxf3m7Y/LoVQxPpq8ISwSO+uJuwRZ8Sl5dGt46g8DXJCKTcgCciMggvIVkbpc8p2OxSzSO51gz4drkytQZfzTOnW58BbNgp/KFQMJaT5e3Ci/QXt1u17SSfk8WOYTuD2g3uFBdRfk3nZj6FCfCCjptOn1jgi4XnbD1dSCSq8RaYQ7FYRuukVv3GgVTJTvEH+JAKc0uDl0m6rmDaUyO0ptErE903t1N7xfEJ3zBZmGmU4jetLrib/BTACN9+RQP1MhU/iV5LT6fWVT1K4cwPgQ4HXYbKwdbUvGSgPVHR89Bt0bAvHkzVF9olZFVExlM07BOfJc6FuGusvA8RU0Esl9g6J6jI87rzouaEfpX0Abu5GpSr0KvUKgq140sez104K+MccMhGyusIN467JymUldOIiOyFg2y27H+/CrTn9bSjT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During kexec image placement retry loops, any midway failure causes
the loader to truncate `image->nr_segments` back to its initial state
to purge the failed segments.

However, this truncation introduces a memory leak. The CMA pages
allocated via kexec_add_buffer() during the failed attempt are tracked
in the `image->segment_cma` array. Because the subsequent cleanup paths
only iterate up to the truncated `nr_segments` boundary, these allocated
CMA pages outside the new boundary are permanently leaked.

Fix this by explicitly releasing the associated CMA buffers in
the failure paths before `image->nr_segments` is reduced.

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
 arch/loongarch/kernel/kexec_efi.c          | 1 +
 arch/loongarch/kernel/machine_kexec_file.c | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/loongarch/kernel/kexec_efi.c b/arch/loongarch/kernel/kexec_efi.c
index 5ee78ebb1546..15fd797ff3de 100644
--- a/arch/loongarch/kernel/kexec_efi.c
+++ b/arch/loongarch/kernel/kexec_efi.c
@@ -86,6 +86,7 @@ static void *efi_kexec_load(struct kimage *image,
 		 * We couldn't find space for the other segments; erase the
 		 * kernel segment and try the next available hole.
 		 */
+		kexec_free_segment_cma(image, kernel_segment_number);
 		image->nr_segments -= 1;
 		kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
diff --git a/arch/loongarch/kernel/machine_kexec_file.c b/arch/loongarch/kernel/machine_kexec_file.c
index 5412aa9f3568..62a5be102065 100644
--- a/arch/loongarch/kernel/machine_kexec_file.c
+++ b/arch/loongarch/kernel/machine_kexec_file.c
@@ -217,7 +217,11 @@ int load_other_segments(struct kimage *image,
 	return 0;
 
 out_err:
-	image->nr_segments = orig_segments;
+	while (image->nr_segments > orig_segments) {
+		kexec_free_segment_cma(image, image->nr_segments - 1);
+		image->nr_segments--;
+	}
+
 	kfree(modified_cmdline);
 	return ret;
 }
-- 
2.34.1


