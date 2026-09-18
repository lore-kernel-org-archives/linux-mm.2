Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EA8FC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F4D46B0095; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32EF06B0096; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132D56B0098; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD8656B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B176A061B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:21 +0000 (UTC)
X-FDA: 85226447922.04.DCE73F6
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F6284000D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725859;
	b=xBcgeWyEbRZQdwGFet4FufW6hGQ9vpa0vjejiiPNoFmFeknwOWcxDuMfdj8JFZRZYpPUGw
	9XlqRDSGsmP1p9+aIbUKhfyGZDCZV4alKLMvdNQhKTcg+8ha1nIOhWXaFO8+1Tz0RVwzmk
	8gEKgu279aZLyO3QyWqQVm3Cz5jBarQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=CtxVcq19;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf07.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=YvdWzsBPv4tCzibaOIJe1gJIse2JfyaMdE/Y/isjkcqLRU6e3rscC65ua4ifsqnBqiKEHy
	0fTY/4L17je1Pm+r+xLlMp0E2h06Oq460sb6R3pBgp/+fxSr4S0HWy75Jqx1ir3EuRWsWO
	PmcMrNKSVOu31tlWxlZCfmBHlMvWRz4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=igqtNYMEL8oKIpnu2DrMNvEYzwwJSEovzlP+FnYUOCA=;
	b=CtxVcq19s4/+nlwp4cUNXfDx1nZiyIWFU4uWCub+//6KtP7pZWS9arcnPlF2LC/ogoKXyeVeP
	TCuE1W141iovkLTXAPEBXvujBx6CaVYA0od9WENgqjGwUbcGu+QPm1w6sqo05U8KePvOSjI314O
	40wUQWbWiVj05nmSEjphxXc=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hmSbG0LVJzpStW;
	Fri, 18 Sep 2026 17:52:26 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 26E1A20333;
	Fri, 18 Sep 2026 18:04:15 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:13 +0800
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
Subject: [PATCH v5 04/17] arm64: kexec_file: Fix CMA page leaks in segment placement retry loops
Date: Fri, 18 Sep 2026 18:04:29 +0800
Message-ID: <20260918100442.3841135-5-ruanjinjie@huawei.com>
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
X-Rspamd-Queue-Id: 9F6284000D
X-Stat-Signature: baw9t6mb65adi834mqztry6ax7fh3bhh
X-HE-Tag: 1789725858-731260
X-HE-Meta: U2FsdGVkX19XS0VeWBp8w3lnnzMsLMo7Hl/7qVtgjLJW4/fhoboRN3st94d/7B8SXMf/n6/if8vdxfZXaZWw2wbr5pqTnbnSYQ1uMSZ1yy4eaTFx7BpYiWiHweY30F4tgZPcfX16ut3bP4t2duWBU/RsdeWMU1JXadYcFDumYtdP9+2ujZw38hOpKsOqS+k6CsQszFJ3uB1ZRX2mRei8u0oJuEkc/8IqFdtdMEBjFJHkBWEpmevXXVcUkt09WthkwxDm4KnaLdlePhu6ItPKaW2vMqT9uixkadq0oMoSyO25yxe69qpjnKEowakmvqS9aQHxtb7jEhb1o2WKiGuvso769WtvPucx+srRFRHgpEfSgraEWRImjcPpCdrgY0lYwQOrtYUm+JVKFu8943AhZDV2vac8YHXNM3SYfMMnFTc0MEJ0pbQGd/vMqcZE4kqaYdZQ1USWgY0amrJ3reIJk6t+WOdZHLVIJgtlNDIcLuPF0ReYXW57q6zhcQuhxzb+w4t+LtttC2vE9J41aR0upVbseesugdwn0kuG8qxbl6LyLrnqipspCs86rNX9Lk39XH91ReYcRJ2XgyrPQYi6RHbXv7u5ax0UqMNq8/XfUw/LjRoyNFf0a+tWe+1Cc6RjBgNjF+eskih3iirchE4dfZpZDNQZukEIKmX320PZyeauHVxNjLrUsEbx4cpzdStKtT/ILBaQIB8atRdZKmoRfr2FhoByrtfOptYqVTZZ5lAcosBfJcpf1DkPz1lvST7Adz+8bE8M10v5gWfVpd0W6lpFfxUyJfSSNKyyCfC+HNp09GW9fqvvs8QkXIezVymuhO1uiOGq3lgIUCROtYT9j4iHaob6rN4i8mjrcs+Qn34LzYEJ48hGtT+s40TTR2Q6fFIY1M7q7vldov64gM3DSi9VltleMQMPR2Uam3s8BbKwamWgvsZGnzabYWCDaLBLdZFzUmh4dDOBtPl4JSL
 FkUqwVZC
 BcnOOtExeVLaxmHXf3uM7yfAz7dJ2QxQ3SASYOm/CqXoOGnUxlp/8Wpcv0JNygJogwxZD99PYCtKUYOhWT8asXqHr6+R/a3/v0FCRdwu/OGbLtvTBAlp41AG1+wYs7pF7EAmmf8SANGJOu5HtwaK/m45FRRhk810g87Nigmm3lPy8DfmpyNLeDDJ0U0jFwwThHAk+Tb2uALcbaXKXK76/Mpapa2HVZgDPPlNl6mW+5sUa4Se95WNHo27EVRbfSqrkYgqk8y5temb+iUyQURYQJ91TYb7gQQocKhF2e10QqYWpuLwui3jAYm42xVMBZ5WziyioWo6LAdHvPiEEMwiJxa5EeJXNqWN0aUF+Q8j6h0s7Zldht05SAp3BjGsvJCqt8gifCdFpKFuewMh71IK43f11Hi1GRynXTjkRmSQM8xCrkLRJJeu1gui/eMCcR7yFNLpthOJBHXmw7Rtqyo18raALa2FCiJ9wyxSaMqAHu5dS03uDfboQPw6EJRWiNuwEKpnM0rMrb6q3J61QJDBJPyotv2hyRIKBR21cPOdRZoVUbTMQdkbm/G6CkJR6zEFGMpJ6I+gwNad56++txX4RdB6D48xHWS3DBtlg
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


