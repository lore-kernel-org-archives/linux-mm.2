Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5845EC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECD736B009B; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDCA66B0099; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE09C6B009D; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9FB6B0099
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1E9841405DC
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:25 +0000 (UTC)
X-FDA: 85226448090.15.7A2314E
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf23.hostedemail.com (Postfix) with ESMTP id CCD25140007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:22 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725863;
	b=ZeWfJ7YGkPMeZsWKVQDa3ohiQ1wXlya9OUnOyDNCXbe4c4SB7P6IONj6mY6oHA/m1+8yks
	XZHkfFk+Qpdr5LnigTD832mo6Aep3xMX4Pe410yCcFdp+nMvVkxSqeM6uZabA7NXCBXuOC
	ss7sVB0p4ThZT8OG/LL1Ji/EHTVNQYs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=fjbswZMNj6e/+p1JVIuHK0ap2SzUq81mRxebjS//ej0FVTTQiC0LGAdgGuUwKgwUd4ac1m
	5lwgzQ2gqfg5JBvvbO79xHfP0OxzUU56BZGihZgW/FaHcPuRVMWE7yZfngoFFRihagNc7h
	7b/WN0OT9fKDAODOvIm7u6uRcS7Q6YU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=WJsU5ZLPqqnObamEl+eDb1OQLn8fzTm2lS+jqZvsjkBOcZoPNvOCq137VskBlGKfkXIRHLxz0
	r3TIwLJgnYKX+hhXcyhYsMrcfZw4l3uKg5x5sTenzOpFogQlp8Dx4ywI3SARgUR1LDQ5r9Wjz1F
	GJzxQD5oYk6LTh2w3OIGcw8=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmScC6HkLzKm9b;
	Fri, 18 Sep 2026 17:53:15 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 7569B4057C;
	Fri, 18 Sep 2026 18:04:19 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:17 +0800
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
Subject: [PATCH v5 07/17] LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
Date: Fri, 18 Sep 2026 18:04:32 +0800
Message-ID: <20260918100442.3841135-8-ruanjinjie@huawei.com>
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
X-Rspamd-Queue-Id: CCD25140007
X-Stat-Signature: a98ocagphtcb5ktjn43afje97d5rb1k1
X-HE-Tag: 1789725862-840957
X-HE-Meta: U2FsdGVkX1+fXQ3Hb8fWKs1aSkbzmujluOc/BahjA2ytQ2jvHvc6q/YyzT6rpVl5+iqUZav46X9Qpl8O9XLU9IwUiVlqA2bi6XMRnl2eNrJrgTYMZUErmA+LhHW2BYgY+0xu7mTLgRLoBks0AJovtNrVk3Qi+DJxD1cgPQM1qYp+Q0h3r9wa5IxxSHq3Y0Hs8bguyvSoc1U3HxX/VA52qM8JeurRbVy2bf7jK5AMlI8Inwpl6AqZvjBrH07VPltS/UoVWVXfp2O6I5jmcQgZKAN4tchB1gJWdumm5K3f3Ua55jahZIi9V3KVhVQmBEa5cuWH7ggNrbeYWgT9PxTyCl53mcTjQkZxgu2ycsfK2LKPtW0XK8UnkwkHRihzGEm3KtWoa+OhVzyyeo2yuFDI4y9k9+2UYh8UiR38mVEEoiz/TYh2F4+wYChLdO0SH+RU32CzD/yZ+yjqG1Qq+7uN4Tz9l9bWoJ1hDuuBlYImbTJpdTADeekvifkSBb//a/IRZx2ViI7Mgg3GbYIqoBlgtQf3alK1nOuG9a12rAMdF9Hz+JgiP5H+L84EfmiHbf9xzvMq3SxKDbCQXDa+9WlLKJ4dhZzr/HnJja0QB02XT93uWjz1oQKwkTuQIPnNsKbL4pBVyb/LA2KlHk+vjfaxKh/vA8ji1iDCC3/8A+Rbry9/ciJBXKIt2vf3PFCL1IRAr38Jup6qXFBWwY0hYtrl7bt60poBcRJb4xnoAYo5IthQurgGebJiEj3MRDlKbuvUiqEAiKO+In9hx5DywYycYtRFfxopHYXU8SjlOA1gyjo8kp+R9YP9g19ldUtpUkbpD5PkxZJcmDJ5G7dA5SBriDKW5LeCIAVE4RgIRq1+1cR/D7u0npG3jLIuLFd6U/7NobO1FDaHFXXSkZW8pxejvHlnGnB+EYwavjTjSTLPR6Y4Q8efHTsl0Q+hifK2qrBm4PBQDBMeoAyAOEXM9su
 JjkRpQ+1
 f7P9NJuHaczZuRrAmaNM37kXhM38a3tQOjalkAU/HF4Ek8e2Y9p/nDT8geOel/bVU35imD9BTy/wyLlEsxQbY9aldL79SxqJKvrMWfrbTf0wKy0QX0NoglbRmSSxG4IvWCTQaZSFpb7mjkbUc8MnsOvNcxx6MowbdDCCW+ERvskmV2+VruL4sQctGtCoV64HW3y8o+uWrY4SntN2BlWuKlc7drrDvXn8yTQExm2xEF12p620Fh1n3oHgORdYWjaLqoXXSQZ1sSEfsa5DDiazjTVxIxpvv6u6T8j8Jl3eanwIpc9Bmx6GSUfkK3CzuIXuseDDD02S2KCe5whiU9zQlKeq/ewjvl32lA/n1vVewceXATRW2MZDAb9f+OURRzTeZQFAV7vpkb/OWx3JPrO2xCQXktv5DOr3MUntnm8jE2p87qzjQ7ehmPMv6IW131Nt00ygBYpFrrZLw8raj2wuvUvkrqt4htTDSja+sHtmImbdI8qc6eGTO/AHUeW56tUbKBlVDzRD93C32/+A=
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


