Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2957C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:53:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A7476B00A2; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130776B00A3; Mon,  7 Sep 2026 08:53:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEBC16B00A4; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C494E6B00A2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:53:38 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54E981A014A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:38 +0000 (UTC)
X-FDA: 85186957716.11.9B67471
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8FC3C40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788785616;
	b=1q60Rayhkna36DLqTDzPiJcOxhk3Utepo3M1V5i3Q5A2/Uq3d4SVOIdWXgRrk5rVf9QhSl
	mprczi9Zs8HthwvReshan3OtslYzBK7b8eVG/7k03ok6khHhA2AjvIt+bEGxH2E3JpZGO7
	ycGxFSe2v2qiMu4RbFzntzFw/7o0aCk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788785616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=qLRR3dfpgyHh8iTn33ZMcHOCUecpjco8QKbN65/9IwQKJPyiFxtj9UupkqWzdDTgyzPQ/+
	mGjBUsW0nzAvml64dNZs1HBuQVDQj/3dfGyXMod0ZIp18jPeFzTahgmagOZvfFU0kpvSDV
	TYfUTiTp+wGgu10d4x5KvmqhjhaNaTw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=CtxVcq19s4/+nlwp4cUNXfDx1nZiyIWFU4uWCub+//6KtP7pZWS9arcnPlF2LC/ogoKXyeVeP
	TCuE1W141iovkLTXAPEBXvujBx6CaVYA0od9WENgqjGwUbcGu+QPm1w6sqo05U8KePvOSjI314O
	40wUQWbWiVj05nmSEjphxXc=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4hdmtc4lD1zcb0T;
	Mon,  7 Sep 2026 20:42:32 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id BA18140579;
	Mon,  7 Sep 2026 20:53:27 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 7 Sep
 2026 20:53:25 +0800
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
Subject: [PATCH v4 03/12] arm64: kexec_file: Fix CMA page leaks in segment placement retry loops
Date: Mon, 7 Sep 2026 20:53:55 +0800
Message-ID: <20260907125404.922123-4-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FC3C40003
X-Stat-Signature: de4cng7894figpumhce77motuqfw5qwf
X-HE-Tag: 1788785615-378219
X-HE-Meta: U2FsdGVkX1/CSjxAI3OXDqJwzMcV5t8Wd1YBgi6lY9tTRnhhAYbOgBS46ycKUcbnRFeEspFJhgRINuvfVDOKARjeXfWkMMNpdFnGLTfjTOqHuu1VlcDeG+ph1oAlV2AFj//qpNTjvdnyWWAHMTFE9aEh+eaGiXV3BTxx0CYADJ03J+lOTm4BZdcjJt9Ts6nWJwJGrNkpmJ7I81AT4VfZaF8XsK6lmFR6aciUwMOFb8QCgmLxoS4NdYdE/IoTkw/1+J4X+vJS2MtmRinVLJ5eJ2bxtQ0obEISQg+A/C/qNit1WAQQOrFYWhRaz5rzPEqHT0oULzDp/56EcmxfkHKP+J8bCd0dxHdcoer9Vj/7Qha+vP4TqWMy1zEKbbobbc9C4GKXSj6tuGNymp0Md5ZbX/0YaMcpCYBpvui6qwm7Hlta/HvBTD2kcrnvi5uMtBrEbn9Rgwg5oZ0rVAE8SdU7J0M96MxJAWbIkGZ4tdO1MhdzRMcDlnz/bHsjIdCTh6RhQfssbRkY2VB63nax0yEe3vWsdDDXk4a8SS60la+l+MMJBPeuq6rKcywv2Kdcs3Ovu2GX6TA4ZfhTg1FL6l/lBJBMdsY1cY9EZV3S2xJyiO8wkLF/8aNOAkrdCx2Ca5Uim2To1ahCnnKMO9PavyLWMKdIOKHxzzSYtQtEmHbfbGieJlLF1WbRjUrzK/pL/7s4bbyYMzQkoNlicxWXGzt5uEVeLeEmL4OUWiMc5fpvrRTwolSJZu2zIedEIJYILjLtY9+LnTY7ZjxZTk5u/R1QexLlPAtec+1rD8xNz1c+Yi+PaBjJ9tS1C5sEm/hgmygBKVNN/F+JT7zskkfpIpM3PLueOKrsY701BTkbJmstW9uSzUgTYdriLPDwGc8MyW1TB3j4WGW46RyrNoMdfWikWcZml7jqoFQc+UQGavlthlVslMlsBt/upCVl1khU6PB84jDLW8SQW+ZG9cCmcAs
 mQk7r9WH
 ziPJqIbp6cpK45jqllNEH76tuW0nqg7S4C5ZO6sl0JurN0h1vWUtJC9Me7Xzdcslh49TrN1lnA1frcX4JqON6PB5oUIMFNPxzXYzrkLwmdl4LXsgHudMq6QWRZ5o2MAhnRhUd3GwakT3O4CWBeb7czHZTHtLYN+0TcbQeMopzBQUJ5hfsSoEDDDfaEXQ5zCqhGoC1Fd6vkAZdsg7cCno7Co/Rd30v/vKETLYCi7Qoq8S1vfb9BtNsZOPwN1+8oJ+qKor3H+KQzb94hJUqzmdeY3r/FCx7JYq7hVeesTYFl06wAQT89VGm20zfNmLoj/z0ye6UcCm4h6V64692zXHtulAQuXXeR0XSEmrP1EkVaTQ1lxZ0C+uBXkCphoAuzD2MCz3V4vEBeTFlhS0CVet0T0kuS6dltsURSjEjaETMiM4NH7uPFcvJknTMMV3F6Hyk0GqkOaBWLaQyLK3JbZwwhwShkL+twTEY55C/BTbbYknM4E3W4hlH2J2KrgjOZYfy0zFcU5hGhW12oCRMOt8Akzt3zw==
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

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 07d24902977e4 ("kexec: enable CMA based contiguous allocation")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/arm64/kernel/kexec_image.c        | 1 +
 arch/arm64/kernel/machine_kexec_file.c | 5 ++++-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/kexec_image.c b/arch/arm64/kernel/kexec_image.c
index b70f4df15a1a..ffcb7f9075e6 100644
--- a/arch/arm64/kernel/kexec_image.c
+++ b/arch/arm64/kernel/kexec_image.c
@@ -107,6 +107,7 @@ static void *image_load(struct kimage *image,
 		 * We couldn't find space for the other segments; erase the
 		 * kernel segment and try the next available hole.
 		 */
+		kexec_free_segment_cma(image, kernel_segment_number);
 		image->nr_segments -= 1;
 		kbuf.buf_min = kernel_segment->mem + kernel_segment->memsz;
 		kbuf.mem = KEXEC_BUF_MEM_UNKNOWN;
diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 854d872dfd0f..e48f29167b38 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -179,7 +179,10 @@ int load_other_segments(struct kimage *image,
 	return 0;
 
 out_err:
-	image->nr_segments = orig_segments;
+	while (image->nr_segments > orig_segments) {
+		kexec_free_segment_cma(image, image->nr_segments - 1);
+		image->nr_segments--;
+	}
 	kvfree(dtb);
 	return ret;
 }
-- 
2.34.1


