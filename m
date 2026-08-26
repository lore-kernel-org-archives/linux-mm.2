Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09BC6C61DC4
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 09:25:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9FB6B00E8; Wed, 26 Aug 2026 05:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6DE6B00E9; Wed, 26 Aug 2026 05:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786F76B00EA; Wed, 26 Aug 2026 05:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47D7B6B00E8
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 05:25:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EF7DA02D2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:22 +0000 (UTC)
X-FDA: 85142887284.06.E9E6C92
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf20.hostedemail.com (Postfix) with ESMTP id BAFEE1C0002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:25:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787736320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=w8fPAbqX8d/sGsS8SAlyE39sCvv6WPOYVU7yFAy8d9jr+Sv298ecb++xH3dMXg2u6a+Z54
	OKpSgT5s+6wvm4Aj/H/06fKQ/gEx9FddnzJf+k3SJs6wuN8e2/bHdZElbUpDhytuuUhP+p
	qtzJ+tqY1w13Ktgsl5f7x6JDOyq45lg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787736320;
	b=iXH6ZRDiUHNinNNh5wbwSZpdDVINBGVkn2oB7nwhaL2beSenVPjTUuntzS1i3rtywjkX1s
	wJMdth9gPRehSy4WaOHVkOe1+GaqTbYuKhP31jwrjwvEfyufshVpGAKKQrS0cD/Lb08jGL
	XKSnQGR9wOid7dkV1BD+2V5BlC/oonY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	spf=pass (imf20.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=CtxVcq19s4/+nlwp4cUNXfDx1nZiyIWFU4uWCub+//6KtP7pZWS9arcnPlF2LC/ogoKXyeVeP
	TCuE1W141iovkLTXAPEBXvujBx6CaVYA0od9WENgqjGwUbcGu+QPm1w6sqo05U8KePvOSjI314O
	40wUQWbWiVj05nmSEjphxXc=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hVJr63K6dz1K96b;
	Wed, 26 Aug 2026 17:14:30 +0800 (CST)
Received: from dggpemf500011.china.huawei.com (unknown [7.185.36.131])
	by mail.maildlp.com (Postfix) with ESMTPS id 3E84140565;
	Wed, 26 Aug 2026 17:25:16 +0800 (CST)
Received: from huawei.com (10.90.53.73) by dggpemf500011.china.huawei.com
 (7.185.36.131) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 26 Aug
 2026 17:25:13 +0800
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
Subject: [PATCH v3 03/17] arm64: kexec_file: Fix CMA page leaks in segment placement retry loops
Date: Wed, 26 Aug 2026 17:25:27 +0800
Message-ID: <20260826092541.3905933-4-ruanjinjie@huawei.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BAFEE1C0002
X-Stat-Signature: 7fagmbd4p55wsnw5stw1ttiieqzqibcx
X-HE-Tag: 1787736319-479359
X-HE-Meta: U2FsdGVkX1+G7ZtRb6uZLHh5+FI1STLLe/BHkiD9iJQuKwaB8ddMb2iV7L1c0Oo6COotXK4XSf+WjNmB1+oz8JY/qTV8eqPSEbU4raRB+OcI3XsDGMErPxsmzmmvB2QolNQRtRv0xWWx9HnJ11dKLOzdK3NwJase//t+/YaczAIbeY9NzepqXagehiUkUDvjFgtUsWlm9mp8qOS0dn5jUZMGxV992LORMqIh8CwiSXMFfLXGtEmlQUnr6XdJ2HWQ57gpwg6vvLMSyGbtwmB0J+zgb64vabs3J1WcvbKt/ZmVXCJ4Rn4e3D7n1NsJbhjnNVYvsnLMJQDlZaBxowpy4yf7ohHaA06Zw2+FyzEQ4Z6TIojp44FHYsokTZ4TMKplcKYhfB3ieYgGLU+Pg/tmjKMJ090L7XcKNkcT6EXD3hVGVGOBU4y4hVtf7NUXpRCymJCEYxJJVJE9+gX4C0KqwUtQOO7hn6IYjEvTw1NsDTp3x7+qw9aTGG/dcgXZJgwObipRIHVYF2/ah7680R4mTID/tOIuS51jxCyFLTktJpA2R7oo7KulLCRVRZRWs1YvgbxqTZKBcP3XqrD0AvR+Ll6Z9IFgWC+1p4i/9iqWDRnySUAbxJZyv34KzsrH6elG4+okSs1z4cQ7Ma1hzQrElwUG/nO5+JHr3qdC6P6hlY4bssyep+xYFyfFlkBv+1yPWkhkTpmcZdyS8U7Xp8CazEs2JxbdhMszMm8l8NQCOfdq3HMgt36M+52KPq98sVEUuoBI+J1pNkaHb/Kzy9QIYvOaZYlRsgF18RJzFhn68NvruQTyz7cFxqWud+jFEtIJC/eOvELjRbNWilwKxveEyg/mqItKK/a/WHLr9CIHm8mdCfEsASjsIuCXCCTc9CVhVgheV4GPjVTEShQUvjZLe5JTTM2Q60SaTg3zRomnpvLU2YYBWEIWK5W60fi15j6xxGEVctP9CEUaC3d6Ubh
 IDL4d0k/
 rSOZWsmFHDZqJElXwFzBYljeJtskXdSx9OmyNFW1nPVnCWGqh3Elor5Ph/rPw7Bq2Z87R0GdyywHcwQGneY/eAp5jJcIOjRv2D+EVphI0Ja+rMcbRjWEJ2R1wR8LlyL087HjOrvWjPjJTKKNFoD7tqwZY+NzS6/zyQyO+h8VQ6+zad+kTfdm+Ju+YwwAPUfw6RgjVgpqhx9lni4OKG0psqu9OiW0IC40fqZRN8Kh1tmxQFSSD7lN7K6OgAQoDWw4yXMXMJUvy/SxnNyjT1u9xKDYbkV23jc+97+YOIFrmFf2vrLmdg9eC7vulN1r3NJF7JIb+0WIzVQe+7Mb508Lp+0r0x5V1CSgCP3/MZAmyOESzx2Tnx3wxlfAdiS+eZ3YhJ9goiRY/Klaqq2ThuimQheey3SbN6mDRQ0jtszpdA7ylyD44z6FYWhkQGHPQRQz0E4lCjRvXCLhpic+ueCO1FQ6Zu4u6tnlEe5ydxx+tYykxIXvVTjE9MIjLY78jxdBix8jy3Ygg8XEDE6rHUj2oLCndUg==
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


