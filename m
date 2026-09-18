Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ACC0C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A1D6B0093; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C9A46B0098; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F3016B0093; Fri, 18 Sep 2026 06:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F18716B0095
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7FBBEC05C1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:21 +0000 (UTC)
X-FDA: 85226447922.15.CFC931E
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2103B140008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:18 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M3xDCzOS;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Eq1XJNYhRFTE/SJtlUDPWTtcQMeeDeygEezx5WcQDg=;
	b=wUfaTrGKa6KJCjy9QriW5SKM6n5xwrE3tIftXFcA6w+mYksSv4B4DLLsp4YSrmySTbXIgh
	+uHKFAs3J+h0qDZPDEuaBVoqa/JFk7wtkt7vIYtlcgDvHhVkwOda3pywzi7zc3PRBip+Bn
	s46t/be7n4UnXQIl4BryKngPZpFkeZo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725859;
	b=ukkYNnsxYCXp+GY/WfoXFRVWAdygg6wmSvO4CnZFlW10wNBNqWsCzooi+RQjcSApqymFez
	Iw87YVfEWNyGwK/VxXlVeQ8DcNUmdQTCI3MJFRV5kNC/0fUrnRAhPGlexs77v83snUFHoY
	c1L+ao+IxLUUnBwi+B5KLUvAUze7HQ8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=M3xDCzOS;
	spf=pass (imf09.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=2Eq1XJNYhRFTE/SJtlUDPWTtcQMeeDeygEezx5WcQDg=;
	b=M3xDCzOSH1ex1aIXQYlZy5bUMNl8IOExQZttwkBTy/1chlRHO/kzqULiUCzyJpa1xmha57Pt9
	6lPA8D6mDEfjpfxI7U4GV7kTxHty4Tg4b4+dOqX5QVt6cyuL1vky1HDVwNZXgBujl8bGaIfFt0t
	WgzQI/6r2eltMXLNXd6LJ7c=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hmSbD4MBGzpStW;
	Fri, 18 Sep 2026 17:52:24 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id B2E5B40537;
	Fri, 18 Sep 2026 18:04:13 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:12 +0800
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
Subject: [PATCH v5 03/17] kexec: Extract kexec_free_segment_cma() from kimage_free_cma()
Date: Fri, 18 Sep 2026 18:04:28 +0800
Message-ID: <20260918100442.3841135-4-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Stat-Signature: cxush58xpypkjd3jnjw77t6egafxwk49
X-Rspam-User: 
X-Rspamd-Queue-Id: 2103B140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1789725858-411743
X-HE-Meta: U2FsdGVkX1/Fra+gVhS2lLHLDLxvPrMVRRdUpmloR/ancxKO8uTjBrkTu/zRw7oJWaefPmeeF9NqkRhMb+EUb7S8WYwmbvEaJncSnpJGBc3SmdIb0M30TxvUKHFnrRvrrLvs4lq+j8yFvBzWLDFw88SRt+T+GnceE4lO8OM3GEkX5xR4DBXDfXwDBERC/b3vbg1ChhB+l2FJ9AGp6rxyl2C49XqRlF4389HO767c4dnYd6vomEds9YSfexqX9+8CFxz/7AzldSL30TR2m5XciZ/qw4P/bUg0MQhVaOzm6pL8q1u2HvMfrFdcisS5JZYnahKjOTPYuPe62k4nb8ZwEF4ZmvdZZal/YkayftekTj8Y/nIZk3eq+fqtunOe/qgWfuBdNNiJudqwcnSmy9HAXQ+WuUwoloPYoCw2K9Q2KlhkQB1jkJaTY433oWrVII+oM+OwJ9RLFhvS5dAV4OKldSxrsP3WcM5unk88LmBNj8ILrM7ebXpnLQ1QopcxgAQRFngDc0zj5G0OM9hGESb7lMNUzIvob7c4pi8Qzq2u7MXA2jqAURHOoHkLZBXn+qklpID8Ozb1XZ9E7BtMYPoFgxi+AUB2nVj45oNrIEeWyRzguGKjlN8w7iSXo9R2rs5ob+c6Ur4xTCKgAVkFu2L8TIEjsqZSIZLbiJp5LJsnyZc5bn9uZvAMtu1iE1aNBqF6chkVebcMpc7igbRtMbNhXcAs2E8eXFRLEVsuVbgj0jNB58HXsFOXroHGoYlFjhwBrB7V8XJcQrvy9NHmy4Ia/5QStzlyqzEmoYpyWPrsrnQvPDLpa9iluopjTXq2Uk8okAMs5Xr0B7zEBKjfbMAr3A3LsF6bEFUyNiR1B2ZWw7p7fjThURr8AK/6duaZT2hyoo0HvdhzXGk9jQgBQysPahnmwrSMEMvnG2lPaPh/bQHGcOLByI+p5dWylkr0qxavoan9HNnlmUThAq2N4Ho
 4tY9lGyv
 K4EL9VsfxDXZPY3CiBtoBjnB9KYiU9/tTSuqgtr7mM4LnNgowdwaZNypZDu+/fEP+OQIx0uPJlfTXDcjOeczogPMnl2c7CjGQSrPGBN9jdnRyY0h9TVIB4dE9O5pCmn/BxNXMaAMsCR4cbbCam49gpm7oTDLzUXL/Wz+hW3LKMPEi4+FgA7B8iYh471nC/KrBZnmTOE7rW4PX+Xie3roQaDv8s6M53rDqt9YVYnl8elcAPPtvr3GOaBYRvQ4YkKZQH0G4cXQc5JRSqtOkVLRuLgrb79eVU8iMotXTIXOl3dmTG0G/GMLjU5UT4Y909S/8C7h+ZDWIsCqX7bAgGG5w50rpnW6U2D8anDmjwpcU7niQzSwY1EjMMoGyh1llSRS/16d3MYim4PADYrKvZkz68IKvFwMskuD/rDXoHU3/tkMcG0uUGIJK97Cqco6l6+0Zx/3TUhePmnYFsLTT1F+Gej+H/uPltnn8ac2Oe6mVOe74ofoJxeoX2lN6Wo9jtvBKPOOIGA+M/l/jLvoPOSTGLAYpAq0Jp3fl1WE09ivEBKYh0OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kimage_free_cma() relies on image->nr_segments to iterate over segments.
When an architecture loader (e.g., arm64) truncates nr_segments on a
mid-way failure, CMA pages allocated beyond the new boundary become
unreachable, causing silent memory leaks.

Extract the per-segment freeing logic into the exported helper
kexec_free_segment_cma(), so that architecture loaders can release
individual segments before nr_segments is truncated. Refactor
kimage_free_cma() to loop over the new helper, preserving existing
behavior.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 include/linux/kexec.h |  2 ++
 kernel/kexec_core.c   | 27 +++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index 6b1df80524bf..72258d813301 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -533,6 +533,7 @@ extern bool kexec_file_dbg_print;
 
 extern void *kimage_map_segment(struct kimage *image, int idx);
 extern void kimage_unmap_segment(void *buffer);
+void kexec_free_segment_cma(struct kimage *image, unsigned long idx);
 #else /* !CONFIG_KEXEC_CORE */
 struct pt_regs;
 struct task_struct;
@@ -544,6 +545,7 @@ static inline int kexec_crash_loaded(void) { return 0; }
 static inline void *kimage_map_segment(struct kimage *image, int idx)
 { return NULL; }
 static inline void kimage_unmap_segment(void *buffer) { }
+static inline void kexec_free_segment_cma(struct kimage *image, unsigned long idx) { }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 5493591a9e4b..31c8228318a7 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -554,23 +554,26 @@ static void kimage_free_entry(kimage_entry_t entry)
 	kimage_free_pages(page);
 }
 
-static void kimage_free_cma(struct kimage *image)
+void kexec_free_segment_cma(struct kimage *image, unsigned long idx)
 {
-	unsigned long i;
+	unsigned long nr_pages = image->segment_cma_pages[idx];
+	struct page *cma = image->segment_cma[idx];
 
-	for (i = 0; i < image->nr_segments; i++) {
-		struct page *cma = image->segment_cma[i];
-		unsigned long nr_pages = image->segment_cma_pages[i];
+	if (!cma)
+		return;
 
-		if (!cma)
-			continue;
+	arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
+	dma_release_from_contiguous(NULL, cma, (int)nr_pages);
+	image->segment_cma[idx] = NULL;
+	image->segment_cma_pages[idx] = 0;
+}
 
-		arch_kexec_pre_free_pages(page_address(cma), (unsigned int)nr_pages);
-		dma_release_from_contiguous(NULL, cma, (int)nr_pages);
-		image->segment_cma[i] = NULL;
-		image->segment_cma_pages[i] = 0;
-	}
+static void kimage_free_cma(struct kimage *image)
+{
+	unsigned long i;
 
+	for (i = 0; i < image->nr_segments; i++)
+		kexec_free_segment_cma(image, i);
 }
 
 void kimage_free(struct kimage *image)
-- 
2.34.1


