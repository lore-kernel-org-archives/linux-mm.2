Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33892C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:54:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EDC6B00A9; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF826B00AA; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC786B00AB; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7406B6B00A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1AAF6160145
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:44 +0000 (UTC)
X-FDA: 85186957968.21.B23E9DC
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf27.hostedemail.com (Postfix) with ESMTP id 325C34000E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=QaGkdxChbvwYQ5ud9dtzzHnbnWrxB8vObSdXtUUk601wSkaElmhnUrla715KRgMHTn/WNb
	pD+YtdM6TYHBNAlICUr+toaeYNxFBEBgABrGb7ivZHHuM/HYzaqNEHmx2XGQviqhljIv/Y
	aq06e3yijOZqO831K8ruoNi8hNmmz8I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=WJsU5ZLP;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785622;
	b=1/zgJwav6ShlpYySVCFG9R6OTt6aoSRcoebbZeLVOWeGmGVyLDRwSxcxfqbg6I4KaqwK+t
	pAsoNq5AU6JpA6BKKgn969dMKiUZs5DXscxeDdGQc1ZnVpjH+SF8BFSi/ikyho1PDzErQD
	laXVI5z0508G0HvXk1TyRYWFTMy16+I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=up4/oktyfAdON3km3wdZWwjp1/r+vQu8s3QiiQB06UU=;
	b=WJsU5ZLPqqnObamEl+eDb1OQLn8fzTm2lS+jqZvsjkBOcZoPNvOCq137VskBlGKfkXIRHLxz0
	r3TIwLJgnYKX+hhXcyhYsMrcfZw4l3uKg5x5sTenzOpFogQlp8Dx4ywI3SARgUR1LDQ5r9Wjz1F
	GJzxQD5oYk6LTh2w3OIGcw8=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtM1GBsz12LG0;
	Mon,  7 Sep 2026 20:42:19 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 78E5A203B8;
	Mon,  7 Sep 2026 20:53:32 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:30 +0800
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
Subject: [PATCH v4 06/12] LoongArch: kexec_file: Fix elf_headers memory leak in retry loop
Date: Mon, 7 Sep 2026 20:53:58 +0800
Message-ID: <20260907125404.922123-7-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260907125404.922123-1-ruanjinjie@huawei.com>
References: <20260907125404.922123-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5si13hmccs4gomkdo49r9rq53i7sj1fs
X-Rspamd-Queue-Id: 325C34000E
X-HE-Tag: 1788785621-403895
X-HE-Meta: U2FsdGVkX1+A7srmHzWa6+kFLRCn0Ar7anpErFIfEuuFkTxHw9iGcHIEBx3uMQ+N8GwjJYY9HP8Fg4FFAWX8NWJSn88LCNxTnL5kbEJxBqh84h+hrenhg+ehLU2FsdNLVEiw/PzNH/TFqZmTo/4y0Qk/JEfPnIr3lfDEDz7ycJSnNy3pxMwWPp5TpnfSQsESNyCxZ9FntZDd4j8/h4/wPLR+LBd+VHWrU6lb3O2wa995NnaDt6DyiLFIpouOD9F1PH5ZRXxR8P+0O5M/xWI2iLMvDsYzkC3SDD8h5TyBn03psvnkHt/AvJmv4MWwPG7raldBXsUkn9n6q/v+GFGgkZ37dy5ZpBfRbHxR+4+cElfOPx2cyplc1rbK5j6BYYBm2w+prvAFu0/uH0ejNXmnjDqY/PB/oar/lpXrcm66rGcU/B6qVvngmTzit6Xu/YOm4LmmPlxMq0/RNo1BkH6mnzrfit8NAb0+kw4ijtEq9CPVTq9yIKh+toocPiZU/B4CarA5NTIX5cpEO4Lc55vbazasRJhLf3StLOH1t+bDsgiLOV9cKCcNWA2eh40doAonbfwI0K0/OUVg3vlX61srSGjIaLUNev+nBeRdR0IUJ21iQRgU0ZQTveEztkAm+9bZ8ULOujNUhd0AGl+Pks2sVidMILKk6QvtF1qWKMpoQihw2544+L6Cw28Nb/mQ3jYWvkIYYh5ixgDTiA2wr7ddT9+wfD82zBl9o40aiFhD7/Wj4rdZa6QheEILD3lt9Q/saoHKTbdWbDgTm/qh5D1Z9oFyGyG1jIp8q1gzqjx+mMh8dDaqvTrHWX10+cdg0LnDcTzvZjBlDPrOTmFPo0h5UZJEaewwEhfS1bYT5D7SW5O5VJCJlFUAIO9NgTvoGbI09Ge6HqARxRqC2DVX2eJR+13Ikv4oPyd9iTYjCWR10Qf/VkjytWVQJc2Xpk1jvTb+k1qBX2r63NwtJAFqjDh
 itanP6pL
 zsl2ubNYItabVEaRswHIwOHWrtuS5SMhmIk19PtYLiPXqrAQ/agkVi5uwYU8qOinxGGg6VgBJSNHFnoCLb2bOdDDORTlA8wPi8gMhrx1z0hvOSluBTY8Enk1GFk+242nmmWdX28qyi3r4EJ5NvZIsei7+0sgmcvEkSlsWUiZr1Mvio1q1cOX8LxItWaVdlL8osKxE4oJY3Y8484gozOyvO2/83HXfw3ji+uXE6qF3zm08T/OkvxfFN+Spf9RUDezM+5eLiwIRTQgSkdSSjh1nUhoTmraCiX1/1CF+B2mhRoO/89QL/1PG+ENNoAZiTUBuMukeNdavXN2GU4LmwhIxgOMSHetiD0wWUMew6qDCtYPg8lKwU9IONG4yDyB16TWoKQMlE+UIcAIRKpT0jhlarRnJ9jIkUQbXdpqMcVpGFryMpiEB2ONRHaZ+6yebe+8VI/YW
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


