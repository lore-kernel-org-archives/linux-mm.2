Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7937EC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0C96B00A1; Fri, 18 Sep 2026 06:04:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 551946B00A2; Fri, 18 Sep 2026 06:04:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F2FF6B00A3; Fri, 18 Sep 2026 06:04:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8E96B00A1
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 935E6C05C9
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:33 +0000 (UTC)
X-FDA: 85226448426.11.4A5179B
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3357C18000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="wVs/Hs9G";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="wVs/Hs9G";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf24.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725871;
	b=g6gXQXz4iYy18YQrJtPDAtBrqxNHNuXhbMKy63zidXTWLldWJSQky9JUIBYyU6o7uCsjDk
	BmBgdOX+djLJKs2LWP0f9MuNBuDCSeuIpB9OeUEV1bjihMjW4pt3P1u7PZFqSMiDg1Z/5M
	/Two0PpTS5wwwOqTK3PEBOiHggMd1Gs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl9dOVAVG56ScS9MwUOL4momh5UtqrFy6pN1ShFcuZM=;
	b=yKnLpdzS9bPDeVtHqoJRs8jbtz3X5DxQoRlpirOfXVl7vgdvRzC68oJkHmAT2RJKFNLc/j
	pKRkUMmcg4jJrkyvJwYeYh6OiMkM0MMO2E5ehbypNjOpIohf+ejcD5tG6VKjjSZkj9Qrlh
	BQeyxLD2KrB22ZA/4ngV1K4xCafmKOQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=gl9dOVAVG56ScS9MwUOL4momh5UtqrFy6pN1ShFcuZM=;
	b=wVs/Hs9Gq6VG/cWAMpWvzJmy/oIAMsdmFRrHLaMN8dhT/208NNm+Jy57C8JdLMxP37J0PUlpB
	GvTnqbaNF3Y1buLGfFQc0tAbMgmC9XUKdLppSMLKPgLCRodGAQm9QZNfIEVZADGVfpSUfrMTgAo
	355Yjh2Bx4bZrE0WgEv0YQ0=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4hmScL1T4gzmVWY;
	Fri, 18 Sep 2026 17:53:22 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 492124048B;
	Fri, 18 Sep 2026 18:04:22 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:20 +0800
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
Subject: [PATCH v5 09/17] x86/crash: Fix massive out-of-bounds write on 32-bit Highmem
Date: Fri, 18 Sep 2026 18:04:34 +0800
Message-ID: <20260918100442.3841135-10-ruanjinjie@huawei.com>
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
X-Rspamd-Queue-Id: 3357C18000A
X-Stat-Signature: bih16zofx3xm6tn86mmta8zno637zw8d
X-Rspamd-Server: rspam01
X-HE-Tag: 1789725871-872287
X-HE-Meta: U2FsdGVkX1/RAnQ0bdMLY++Sf5sDjmCT8D9WYbeZxG0Db3ocP1ZKtKkAB2iY8aaRU7M0al5anM8Wxaubfb4DP+Pa6QX3auPJ4sWuOnEFTXODcUkuMWFYQM/2kceH69lQADDQnsw7EGTUmKbjuX2dr9Lf0e1n4J1/okolSGfbWdXB2ZEnXDBMsVzG/OtWtz/+KCrphNW4r3ORl7R8m3jjxyXIPojKsNpOGmaKTcpjaX+XAKsFr18oKkG3ITRXLfkPhmIPTRONfPfpEsTW5hAeN+3RDPvrD2JMULtZZ5tK7UEI1+gU4yD+1268FFgXeNlkHctOIXXqU5X7Q/BjZnqRikdylF0WPPgwOHecV1px8gUruPMZXtLClS2kAum/abysSlv6Lbp7lu1SB5onTKo3bF7tGl7gT6myrct4OsD37p0fY/H/aKs0aNJHN4zayXop9p6Mkytlg7a1VZk5L1bgwoTHrh3fkFAHm1NTUNJrj8CBp/JFDofKO5dAZc/7USKUaFp5MwF2syKPpVCipoBoV2EsG1gFEgt1zyfIKpLBzmA1Ha+4PScpIEO0GoGsNCVcjmZvvSnlqHY2GSaTCKOaHgovnQFYiWOpc7nXbcqoXkKiX4/8RWtua00Ub4oGDDl7aXMZYfpmSWCYS3pO0nHDUwJtAKjdayg2fjKLgXv4Te0D3XnlgHcwf63DFVUYTIqJNICYqSdRNx2ZlcMIQFjisYZPrBRdn+AY0UTWPXBqHZhZy8j7/KP+bdVwD7rBGC/PrMx5FPXtukoVqD5XLEIQnRJNdf9k1egpdP7BaHISkb63yND1HW5GthGVU2fcbAt9hBbBb90+WsmKkMoY5jG2pEPVX3HvKB/zfknum1DoBPewprO9MJvVFtgVfkzAmYEcF3dSQm0+3QaIWI12DPceXyZiCGtcWbPC24zShyNmRgD/fKIJRniAPl1E4ucZrAUc+k1D5yx2Ck1diScvnp1
 R5E3oT5B
 gE/DPSqSB6ut62P3OesHms/Pwp7GBLDO7XG2j2269NqHglx7LSNEbk+9/KilUM8kgpAc9zt9WQ7lOPgygv5jpzCXNgfth6Sq735Vep/gS8/xdrHYCTmDjxVg+jhYSTaZjivA6EsoPmFAqdS1jtSKU/clZvGmyU5QJZ5/OHOQsu0my8zdRX/TtZc9TD0/jlbgcSvTSSnsmlcf75A95lOhy4ji3eQwQTKOL5/H4aEzxIYGwmwLiC8YuUbmy/OrSGS0ylX0fSiIiyYl1xNsZTKsDotL4GgHd996txbWC2wRCpbhBiyZSWDTG58GpLItIrt5Jpr/Ht3CUIMEplouHESEC2aU1seJzPhTjybenFWlYDgsCnCxsn750o2Sxnbn3h5uofItex1CEDFTAhav/u1otDCYopG+lR1bmCdyVQg0DKgC15oOQ0OhAgOOulVXzQrKkumBwuiXpZCe0rGz755b1muwL+YPo+GpoSHjEGSTR+je6o69P4z8gd4HNQ2343dKyPVrSquEYHtSHm9UvQ/zilY1ScwNUF+tbfRnE6ffAD2yTWZisee8anJXnIuoqUL0d+0Ut8pPeDZ8b9ZFf6lnCOAvXa9GZiGaP8xyN69MNooMCgKOQIurzhniA0UB+PADgC0vpmPCzhzPsNH1jia4xs3sB//S5oWa9f8smX7oTxofXlfg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 32-bit x86 systems with HIGHMEM, kmap_local_page() only maps a single
4KB page. However, the elfcorehdr segment can span several pages (up to
hundreds of kilobytes).

The original code blindly copies 'elfsz' bytes at once via
memcpy_flushcache(), overwriting adjacent fixmap entries or critical
virtual addresses.

Fix this by copying the new elfcorehdr page by page.

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Baoquan He <baoquan.he@linux.dev>
Cc: Chao Gao <chao.gao@intel.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Eric DeVolder <eric.devolder@oracle.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: stable@vger.kernel.org
Fixes: ea53ad9cf73b ("x86/crash: add x86 crash hotplug support")
Link: https://sashiko.dev/#/patchset/20260907125404.922123-1-ruanjinjie%40huawei.com
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 arch/x86/kernel/crash.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e681ec9cf1dc..3c9f4fbbe7ff 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -447,9 +447,10 @@ unsigned int arch_crash_get_elfcorehdr_size(void)
  */
 void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 {
-	void *elfbuf = NULL, *old_elfcorehdr;
 	unsigned long mem, memsz;
 	unsigned long elfsz = 0;
+	void *elfbuf = NULL;
+	unsigned long done;
 
 	/*
 	 * As crash_prepare_elf64_headers() has already described all
@@ -484,21 +485,20 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 
 	/*
 	 * Copy new elfcorehdr over the old elfcorehdr at destination.
-	 */
-	old_elfcorehdr = kmap_local_page(pfn_to_page(mem >> PAGE_SHIFT));
-	if (!old_elfcorehdr) {
-		pr_err("mapping elfcorehdr segment failed\n");
-		goto out;
-	}
-
-	/*
-	 * Temporarily invalidate the crash image while the
-	 * elfcorehdr is updated.
+	 * The segment is physically contiguous but can span several pages.
+	 * On 32-bit Highmem architectures, kmap_local_page() maps only a
+	 * single page at a time, so copy page by page.
 	 */
 	xchg(&kexec_crash_image, NULL);
-	memcpy_flushcache(old_elfcorehdr, elfbuf, elfsz);
+	for (done = 0; done < elfsz; ) {
+		size_t chunk = min_t(size_t, PAGE_SIZE, elfsz - done);
+		void *dst = kmap_local_page(pfn_to_page((mem + done) >> PAGE_SHIFT));
+
+		memcpy_flushcache(dst, elfbuf + done, chunk);
+		kunmap_local(dst);
+		done += chunk;
+	}
 	xchg(&kexec_crash_image, image);
-	kunmap_local(old_elfcorehdr);
 	pr_debug("updated elfcorehdr\n");
 
 out:
-- 
2.34.1


