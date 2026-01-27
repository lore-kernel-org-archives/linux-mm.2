Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4F9D2F004
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 12:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F21246B0093; Tue, 27 Jan 2026 07:16:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4BF6B0095; Tue, 27 Jan 2026 07:16:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEDDB6B0096; Tue, 27 Jan 2026 07:16:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CF5806B0093
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:16:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9EB3ABD536
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:46 +0000 (UTC)
X-FDA: 84377642412.01.FE21A89
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3CF980015
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:16:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIbdx3Kz;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769516205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=0OJUWgBDgEWgaC1vayq0DEll77jrwr5fxqbHBx0PQTPRkcnf2l+ZdRhe5AHFGmzVFau4nI
	DdvNn6eYbFTk6CXBLe3UiWQ0BaVgRncfRv5NBStp3vijtwe4n6rkU2dtX8N0TDJFtN6eI/
	QcVjBdM8ely1NVz++OLGE3tW9TSaKFc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FIbdx3Kz;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769516205; a=rsa-sha256;
	cv=none;
	b=RzwLELd2SRqr8hBwmrutrzV5/SbJqyuLRlSIqKoKfTUXFl6WwHCsvbQq3derzQ/VyV6WcM
	dqREvugCtRPNk+NHTyWxMTeEuxgKltRGsUqFX0zZDFzS5yDeinjBu/KyKSkcgCu404BPd0
	vpSWz7y70ld5AaKrTW16UVRA5ng6RWU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769516203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8PNYJl+4luznSu7Qs41hn6BnOWw9fSYJ1f3qY5qKkjU=;
	b=FIbdx3KzT3ZzuPWcHXh6lZeu0knjRgXOY2FCQKsdr3pHR7oc/n8z24+0bCjEsSNByQL3i0
	6SwoaMgXgtfA9BWg4CrNy8gMxJBXcNgtiljra9XdM5cxUx+WSsUy2hZfxCkH+JPhZqVh5a
	kHtoJcZoWzF8ijbWfD8mCP8Ts6pi/D4=
From: Qi Zheng <qi.zheng@linux.dev>
To: david@kernel.org,
	andreas@gaisler.com,
	richard.weiyang@gmail.com,
	will@kernel.org,
	peterz@infradead.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	dev.jain@arm.com,
	ioworker0@gmail.com,
	linmag7@gmail.com,
	akpm@linux-foundation.org
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-alpha@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linux-um@lists.infradead.org,
	sparclinux@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH v4 5/8] parisc: mm: enable MMU_GATHER_RCU_TABLE_FREE
Date: Tue, 27 Jan 2026 20:12:58 +0800
Message-ID: <b827939046dbc94bc7c585cdbed8522baab75b15.1769515122.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1769515122.git.zhengqi.arch@bytedance.com>
References: <cover.1769515122.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3CF980015
X-Stat-Signature: y1zj184n679m5k3aceyxhpacc7p7fqbb
X-Rspam-User: 
X-HE-Tag: 1769516204-983021
X-HE-Meta: U2FsdGVkX19oIEBFHye6Lydwuuc0jCewCsxbVuYqOrqYomRvIo8EEx+teQif3vuQcUGXfgwb7KLurEBMQjGsmv6cxuMma6+KBSZGaeA3zGX6W+tfZV3s6NAc42mek0q8TuK0jMBTwGG/CC5HB9C6gwtCSQ5Vh424s859wat4VKl42CTWjBsFIcWKjtjWPj1x4XIcuKI5eekLdZUb5jss2wptMSEH0Sew78IRBo+PqoPr1PQF90xwQZuOVkavPkfFjvskiEG4n0aa8ir0KpMU3Q0hmEUtv6/Zomn3lTlv+cmU/6JrCRdLcBtw/e/Q+UJzcMmIPbr2bMymOR/B/+U/y28BlJZ79NlfFZddFTQXtufV99CP8mOeVXGge67Wwdqg0ft0Po4PO4Rcx4/92i2/qUyyB3iCpAUK0uzbpXRRjNgLoQovEIIJV+OAMFioBZPZgieOz4+LSm+Yih3IybtUAcPYpn66wwyuII/d2NPnoSoAoZKy5YrHDZhNAz98F7pq1dPDyvS4C68XIW/LLY6gvzoiGoGvUD2z1+VofLxSw5I5hjkUBwNJJ65NTZyLH2WPZsZE/NayrZvI8fO7PSLTY07ptU/bY+HT56cYUJoY0dbcuiAIns5YurCoeZdqQ+lDeF0QnNBoD9wIr5CdRyxOtzkbXw0tC/zvKEnp2fmWZuL6MeAEZJucoBUPMVl1ReVsd7xvHXWS/fr06coB7RAZAIAw4/Igv+/ZtE0PcdDB+pYjksA79TFG/RjNMDrJPEe2KRBpp870pnSgRApbVNW4OsyVmVc7OEzwGCELbW4xkqiAuWO9KvK+ILPTNzddx2PYlg7tCGZVaBoYlSmRSrMlp9E+1FP9KK360/FKIhKX2Z2/jqAno2PzGS+YXl3i+oNHWaO07fivkwZrPXto6cjvr1Up/L+cbtON18F5PVa7weQpItVBPrBhuoizItGLA2riMs+ZodOGLrpE6X/pZUX
 Puoq8zVa
 9skmJ2WJmP3CEFgrcnINuKG9DkvoywnmsbpWUUUz/rJ8LK4/0wSz8ezzGVf/c+UEM5EwD0NElsTYNserXwV5sIMtYp0F8gEKubKWe9oN9Eu+5xCMmUnutghZbQg9iFxm0umh/rZYm4071RosaWkx/uYGNL3LOZyxHjFIJpzB8gjbo6H98GQNtQSgQcML3HH4jCZhNNHY0/i+WqwaOQUG0BCzg30/raGoB/vUVXDRRu8uU84fiax+3KcySlWqGD2DYVJTb+B8TXOKO06Qpb2Gh9Bf1CwsjsNXzyMxxsYHicEmgGsL4lJxLm3k/SP+4aFgmZKOYFNK5df7CgIT722nNdkyvr8FFxIwTJDzR75fnomZV258=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
empty PTE page table pages (such as 100GB+). To resolve this problem,
first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
PT_RECLAIM feature, which resolves this problem.

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Helge Deller <deller@gmx.de>
---
 arch/parisc/Kconfig           | 1 +
 arch/parisc/include/asm/tlb.h | 4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index 47fd9662d8005..62d5a89d5c7bc 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -79,6 +79,7 @@ config PARISC
 	select GENERIC_CLOCKEVENTS
 	select CPU_NO_EFFICIENT_FFS
 	select THREAD_INFO_IN_TASK
+	select MMU_GATHER_RCU_TABLE_FREE
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
 	select HAVE_ARCH_KGDB
diff --git a/arch/parisc/include/asm/tlb.h b/arch/parisc/include/asm/tlb.h
index 44235f367674d..4501fee0a8fa4 100644
--- a/arch/parisc/include/asm/tlb.h
+++ b/arch/parisc/include/asm/tlb.h
@@ -5,8 +5,8 @@
 #include <asm-generic/tlb.h>
 
 #if CONFIG_PGTABLE_LEVELS == 3
-#define __pmd_free_tlb(tlb, pmd, addr)	pmd_free((tlb)->mm, pmd)
+#define __pmd_free_tlb(tlb, pmd, addr)	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
 #endif
-#define __pte_free_tlb(tlb, pte, addr)	pte_free((tlb)->mm, pte)
+#define __pte_free_tlb(tlb, pte, addr)	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
 
 #endif
-- 
2.20.1


