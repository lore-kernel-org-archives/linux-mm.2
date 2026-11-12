Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 914E2606A89A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZlMHficu
Received: by kanga.kvack.org (Postfix)
	id 9A2036B05B8; Thu, 12 Nov 2026 05:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979846B05B9; Thu, 12 Nov 2026 05:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88F5B6B05BA; Thu, 12 Nov 2026 05:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 551656B05B8
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:39:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D422E12053D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:14 +0000 (UTC)
X-FDA: 85426119828.12.453A69B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 309974000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:39:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlMHficu;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794479953;
	b=2HPo0KF56OJhP6fnslgOMo914eeZ37jWOrV0Oj3xeYB3FT2RLVLJtJRsxoIqa+VYtw5OUL
	jt0SZr2jTtknedg/2hAnCceJCrKiVMv/A5jJR26cKYULL9aVseLnuDgymIg68+N3vmFvGw
	g9KU+nmxuHmELKXxDbXpZxhVQzXbPy0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZlMHficu;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794479953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQGWp2+wbRGJ+dC6yywFPAL6siNGmTYONc9+D5I1sYo=;
	b=uc75LqDqhlX5IYQOYuxD7KYkmJzkVBd/Z7bBY3eZQ/lCbSBbQmDxPH0CV/43q5v9Wx2c1e
	cjRYpeTAIYyIGyyMn8aFkc0ODpXKII2SPFX6mtDp87dPwKaY9MvO+lE+Brljeb6kPm8XXA
	k9UNtBOM6XcmHUwebsovJwlO/Ss8yuk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 08F3742BA4;
	Thu, 12 Nov 2026 10:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D0E1F00A06;
	Thu, 12 Nov 2026 10:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794479951;
	bh=pQGWp2+wbRGJ+dC6yywFPAL6siNGmTYONc9+D5I1sYo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZlMHficuQjiF6MUrwFLyug43w6wSJLMXFXJ6483iQndymcjhhAAViAWQJbFhd4X/J
	 YAKZ4oVQkU4wzxZPKyo7Lh/L4k2hTlTn832X4g4pWzN1lbU0Q38BiDwIkPKyI1hSGT
	 3/GSdegMs9Pq+ao7m2WJjdCYNpwqOScJdnsGW44R9XeVQOT26uSeMVcv2tHvIFNLRi
	 7YXkh557+OZEOrvSZ5smwJXhKQOXvSVZChfyATRm2gOA4EpRr8SMb+FLoxjSUo32y4
	 4fWuopt3h3Ak5sPo6P/CwDjq/0AFdcLtt8VoojhKDgHjrJJZTmjg2Tw1TWWfzwvQUO
	 ry/DzWvp4wEGA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 12 Nov 2026 12:38:54 +0200
Subject: [PATCH v3 2/5] kho: walk bootmem areas in address order
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261112-kho-bootmem-sizing-v3-2-f0c8d00295d5@kernel.org>
References: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
In-Reply-To: <20261112-kho-bootmem-sizing-v3-0-f0c8d00295d5@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Chen Pei <cp0613@linux.alibaba.com>, George Guo <guodongtai@kylinos.cn>, 
 Kexin Liu <liukexin@kylinos.cn>, Randy Dunlap <rdunlap@infradead.org>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Mukesh Pilaniya <mpilaniy@redhat.com>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: swx73ofwetmbpdf73fioq4pfi6ty7zyu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 309974000A
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794479953-907250
X-HE-Meta: U2FsdGVkX19reEKPOmIzAuBPD5cYhUzmj2N7eJc8L6FozVxZJX020wapTVckA9zLBXs0D9eugWGssrGYQhX3e0zBygcMTs2dKg3WximEYbUA5qHbfqo05fEExIY7HU6rm+GFoApNQF1SZZX6JaPXgmxiy0Z+wDaTRXr1/50qrMYssavz7iATE++aEYgkg1aVoVfEIvOZpQ/fKd4LKtn98P2bzfDffxNCzLTwRf1aumKBz6f0m7NkECpb+Bg1ig5JTdO0p0F9ncoJocg6fx2oTU28rUMiYwhoPm3p8520YO/6KM8WU89PcjNhta2EQnEv0clRvWohfl7cduOHkioVBQIxa3pwHqwORjq83Hsj6XVLxvXArVuMoXIy2vZ3e95xQGxG5Lzo0CsQn1yqFoYt314MXtXtXGus8OxPqZku88+VEQ4BxUoOFyU8LjHMCHAKdmJFsTJHWh/G7bNSs1xwGekgmOPTix/HmQ85PX5Ud+XsxnJqND/PdPLBrlqFtpAoJ5JuGpQcY804jB2jilBKIINPITj5096ovWUWSd5GaLv0BYhBHcN7UT2mZc1U5WUGWTc/d7eHbAlHr2/s8MaH1/qksEHcZl+/1CVxlzV+hI2NVznCFkrg2V2ZOXKMKBRqFegBRRWKBiSdgkjzstvMXckgZaLFYZaz0/WlvtjgnmwRl/lD9Cptv6Z10eKCjhUuO1lkXQCTEVRwsrBojTXzlfg9pKVas+7SBEjubIi2NyoFbpGJ6aAokkEJLOZCFjsG76+cPox/ejBKxb63rPYx0DakzZl559Y3b+4wkpqgMBdtfYOV7cQnyo6PG0AFbyDluviG7EV3joARSk+LAIyVdT23Tq9zaz+bvQbJm9YaNzjJVtHa5eVhm6yM47q1NfnQEu9uqZq333ffUW1GQkQ8TW6qeVLO5ovc9MQ84zRrMiz/WNg04qZEcuOetsJGOEirmBFRxqmcaFi3HjpgvxQ
 KvIKywSP
 zGmDlRgjF+WEcPDtUXtglyh+SLmkYEY3wyKE/4AWKiY64zb4vm9Wxj7PppTqxMIx4YDkPuNNDZ4vU25yxdTucWwK49E5y9XU8ySxtJ/lQNvPwcQyqINlkg8KpC1iPZcf0mn5v/YWkS6ztS6SQGv8E4xqlSNI3PZrBK8zYtE/lt+VAgSJ50I6mUPBeuTzZE6WuFVo3M8GYHNdceIp6u5iTQZwqTqw4Up25u+RBr72sDwodDI4xR8JbH0c9YgMs98jI4ky+9hreEOBRp0OpEtcCZ8rcpSeo1oPrT7fM9q0jRRiuRmdWSJvkBA2ZQ3PlUmXEcSIpYAzS8nbSk+qBgLsrgiYBfwZ8r3xYssUD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

kexec_add_buffer() users may depend on the order in which memory holes are
searched. For instance, arm64 places the kernel bottom-up and then
requires the DTB to be above the kernel.

kho_walk_bootmem() walks the bootmem areas in the order they were
reserved, so if the kernel lands in a small area at the top of the memory
there is no room left for the DTB and kexec fails. For example, on an
arm64 VM with 2G of RAM and kho_bootmem=8M,64M,64M, the lowmem area is
reserved first at the top of the memory, the kernel image takes most of
it and kexec fails with

  kexec_file(Image): Could not find any suitable kernel location!

Sort the bootmem areas by address and walk them in ascending order, or in
descending order for top-down searches, like kexec_walk_resources() does.

Fixes: 3bdecc3c93f9 ("kexec: add KHO support to kexec file loads")
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mukesh Pilaniya <mpilaniy@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 57 ++++++++++++++++++++++++++++++--------
 1 file changed, 46 insertions(+), 11 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index b30ba686cb301..df4a972a860da 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -26,6 +26,7 @@
 #include <linux/list.h>
 #include <linux/memblock.h>
 #include <linux/page-isolation.h>
+#include <linux/sort.h>
 #include <linux/unaligned.h>
 #include <linux/vmalloc.h>
 
@@ -826,6 +827,14 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
 	return false;
 }
 
+static int __init kho_bootmem_cmp(const void *_a, const void *_b)
+{
+	const struct kho_bootmem *a = _a;
+	const struct kho_bootmem *b = _b;
+
+	return cmp_int(a->addr, b->addr);
+}
+
 /**
  * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
  *
@@ -910,6 +919,9 @@ static void __init kho_reserve_bootmem(void)
 	 */
 	kho_bootmem_cnt = i;
 
+	sort(kho_bootmem, kho_bootmem_cnt, sizeof(*kho_bootmem),
+	     kho_bootmem_cmp, NULL);
+
 	return;
 
 err_free_bootmem_areas:
@@ -2087,20 +2099,40 @@ int kho_fill_kimage(struct kimage *image)
 	return 0;
 }
 
-static int kho_walk_bootmem(struct kexec_buf *kbuf,
-			    int (*func)(struct resource *, void *))
+static int kho_bootmem_walk_one(struct kexec_buf *kbuf,
+				const struct kho_bootmem *area,
+				int (*func)(struct resource *, void *))
+{
+	struct resource res = {
+		.start = area->addr,
+		.end = area->addr + area->size - 1,
+	};
+
+	/* Try to fit the kbuf into our KHO bootmem region */
+	return func(&res, kbuf);
+}
+
+static int kho_bootmem_walk_top_down(struct kexec_buf *kbuf,
+				     int (*func)(struct resource *, void *))
 {
 	int ret = 0;
-	int i;
 
-	for (i = 0; i < kho_bootmem_cnt; i++) {
-		struct resource res = {
-			.start = kho_bootmem[i].addr,
-			.end = kho_bootmem[i].addr + kho_bootmem[i].size - 1,
-		};
+	for (int i = kho_bootmem_cnt - 1; i >= 0; i--) {
+		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
 
-		/* Try to fit the kimage into our KHO bootmem region */
-		ret = func(&res, kbuf);
+static int kho_bootmem_walk_bottom_up(struct kexec_buf *kbuf,
+				      int (*func)(struct resource *, void *))
+{
+	int ret = 0;
+
+	for (int i = 0; i < kho_bootmem_cnt; i++) {
+		ret = kho_bootmem_walk_one(kbuf, &kho_bootmem[i], func);
 		if (ret)
 			break;
 	}
@@ -2116,7 +2148,10 @@ int kho_locate_mem_hole(struct kexec_buf *kbuf,
 	if (!kho_enable || kbuf->image->type == KEXEC_TYPE_CRASH)
 		return 1;
 
-	ret = kho_walk_bootmem(kbuf, func);
+	if (kbuf->top_down)
+		ret = kho_bootmem_walk_top_down(kbuf, func);
+	else
+		ret = kho_bootmem_walk_bottom_up(kbuf, func);
 
 	return ret == 1 ? 0 : -EADDRNOTAVAIL;
 }

-- 
2.53.0


