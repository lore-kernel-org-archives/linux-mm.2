Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949FCCA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:23:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED73C6B0093; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E88256B0095; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D28966B0096; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A201D6B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:23:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 289E980349
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:37 +0000 (UTC)
X-FDA: 85302852474.24.4F0A6C1
Received: from mail-m1602365213.xmail.ntesmail.com (mail-m1602365213.xmail.ntesmail.com [160.236.52.13])
	by imf09.hostedemail.com (Postfix) with ESMTP id A36C5140007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:23:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.13 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Si3grxPoGVoQJI7R9N0/2ZDcP6qzFpwM05I5tYqEw/s=;
	b=rEFpL7jDqSVr0qdVebaBb1WqiJyhZ/3lJltn8ZHmyfUALCDDENQOE3eWgTTclUYLD91vWL
	Udgvbuf6Se1ClsfpQk0Yi8PwKBi2gJGVpytooiAIHwlBDOw9mf5mDUEf2J+J+1OZ52hjry
	X0EVfMA/4qpYAKEGhJLG2mU0YBSDaZc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of zhen.ni@easystack.cn designates 160.236.52.13 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545015;
	b=Dh1hYDx6mKU4qCNsHc5V7IXjT0Zna63RaWaSeFnTEMJQg6RliTwZ1SiceAnHV2xN4K7e8u
	5f2SQCHHhTDPV4DAus0aantixhVg2bQWjJ3RldW7hGmUaCSD1FQww3ruv9xu5SuGNj3BBn
	C+yNgw7Zplnv63ZLhXEYVmd2N2ioVLU=
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 1fe2901a2;
	Fri, 9 Oct 2026 19:23:29 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	shuah@kernel.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 4/6] mm/page_owner: add bpf_page_owner_get_nid() kfunc
Date: Fri,  9 Oct 2026 19:23:06 +0800
Message-Id: <20261009112308.240769-5-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20261009112308.240769-1-zhen.ni@easystack.cn>
References: <20261009112308.240769-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1206765f80229kunmd33b3e054cb287
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCTxkdVk5KS09OSkpKTBpCGlYVFA
	kWGhdVGRETFhoSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0
	lPT09IVUpLS1VKQktLWQY+
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A36C5140007
X-Rspam-User: 
X-Stat-Signature: 9zt7qdx6ypxfaebx56unu7z6iiub8hc8
X-HE-Tag: 1791545014-170651
X-HE-Meta: U2FsdGVkX1+lPQLovmARq77DFd4denhCS6bq5oNMOB7YeEiHe1PqqHurBFx0gwj/rc99eN/Z7ehVtTVEqc1+0TCPNg2xtvRNGoVtuvi2tOQ7VTu0u31J/1GWSdpATaO20fNch/KjqUDFVgFKgCKsoLhSVmHUAtIqk9OtOeZowhZubZWbmDSnvvfWqm1SBBfw/FKt2TdJtaBxkymH9t2jKg4oY2AHCMJgL1LFn4qk1CYrDkyJysp3GrgZacxHavSew2w60GpijWsEAJFAnW8ZrwQeLO3t+BgA581gx7nkXckyl4uR6MfHPNiHdUNJ+BZhySshoO9MiIE452PAFHNRf5LSoKj+Yq41OjPuiTTeZJNRb2WGxADL+jStbnn8R2xC29ruSlVCuHhc3uhnqncTNXwEKaS8B24+bwKUpS0HgD2T/wklpV5z73ZZ0YARVx6nX4Q/u+c1m+yUr+biZzCx+qaKwj1BHLoKSddtu5IPib1pXj2Dg0qXMwq/HDz8dp4b6BsYKJnFTP+fGPFWOz+r2rVJ2l829HG3SY8E2R1dvQkNjC9GGunELpT2Uuu8hZ9aoX5e741bp4uLxkM31JsdU++fuM76yPA9lk0C0NrbonAkAxtCHpBZaEJf3rYlcyxpRPsYb6hSDAsiZwjgHTC6B7GsYZmzhR7J1TneGnJkQ1Vui+utdIZ/nijDIv1JDIix/oy8nHR0bhuB1AREtmBLaJFOXJCzP7vXg4VW/zY57qNnmb1jtbCg98PmNBVMgifxCURD608B0AxHijFCPFTEvdeVdIqDGhNISnIdyN0QbbVX2TVBufa+Xt245R2YJNiTD6UFSP78Y2h9Yioz5z+3EWwhwf8tq4Zy1JsW+46eD0TJTEbT80QAuxEskhCGBcjbDWEQIXnbySj5bYe8/H3PlOtkJtb6cZTfhA3ja/mUePFO3kqiv3aMsbdxJOrny4CdO0Wb1ewlguXbEFfUm1+
 9LlBCNF2
 LM7HzenqqfHYHWa5Brmkr9xTRFVrD7AvTONx9HkLUQLYmQ5QeBGwrqsQ6wSd8NaSWJH6oPTZtnTCmxo5RNpwYHbVZefrpI5uebJpOa/I9ZRqRnQ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the NUMA node lookup from read_page_owner() into a shared
page_owner_get_nid() helper, and expose it to BPF programs as
bpf_page_owner_get_nid().

The nid bitfield layout is build-time configuration, so BPF programs
cannot accurately derive it from page->flags.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 kernel/bpf/helpers.c |  1 +
 mm/page_owner.c      | 26 +++++++++++++++-----------
 mm/page_owner.h      |  1 +
 mm/page_owner_iter.c |  5 +++++
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 23a2d2d71f4d..3e8afd19a1f4 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -4951,6 +4951,7 @@ BTF_ID_FLAGS(func, bpf_iter_page_owner_new, KF_ITER_NEW | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_page_owner_next, KF_ITER_NEXT | KF_RET_NULL | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_iter_page_owner_destroy, KF_ITER_DESTROY | KF_SLEEPABLE)
 BTF_ID_FLAGS(func, bpf_page_owner_stack_snprint, KF_SLEEPABLE)
+BTF_ID_FLAGS(func, bpf_page_owner_get_nid, KF_SLEEPABLE)
 #endif
 BTF_ID_FLAGS(func, __bpf_trap)
 BTF_ID_FLAGS(func, bpf_strcmp, KF_PERFMON);
diff --git a/mm/page_owner.c b/mm/page_owner.c
index eb420803a434..43a722678acc 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -711,6 +711,19 @@ void __dump_page_owner(const struct page *page)
 	page_ext_put(page_ext);
 }
 
+/*
+ * NUMA node of @page, bypassing PF_POISONED_CHECK() in page_to_nid() to
+ * avoid VM_BUG_ON on poisoned pages; -1 for poisoned pages.
+ */
+int page_owner_get_nid(struct page *page)
+{
+	memdesc_flags_t page_flags = READ_ONCE(page->flags);
+
+	if (page_flags.f == PAGE_POISON_PATTERN)
+		return -1;
+	return memdesc_nid(&page_flags);
+}
+
 /*
  * Advance @scan to the next page eligible for page_owner output.
  * On a hit, fill scan->pfn/page/po_snap and return true; the caller
@@ -810,18 +823,9 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	/* Find an allocated page */
 	while (page_owner_next_eligible(&scan)) {
 		if (state->nid_filter_enabled) {
-			int nid;
-			memdesc_flags_t page_flags =
-				READ_ONCE(scan.page->flags);
+			int nid = page_owner_get_nid(scan.page);
 
-			/*
-			 * Bypass PF_POISONED_CHECK() in page_to_nid() to avoid
-			 * VM_BUG_ON when accessing poisoned pages.
-			 */
-			if (page_flags.f == PAGE_POISON_PATTERN)
-				goto skip_continue;
-			nid = memdesc_nid(&page_flags);
-			if (!node_isset(nid, state->nid_filter))
+			if (nid < 0 || !node_isset(nid, state->nid_filter))
 				goto skip_continue;
 		}
 
diff --git a/mm/page_owner.h b/mm/page_owner.h
index fda83be69275..c57859d18dc3 100644
--- a/mm/page_owner.h
+++ b/mm/page_owner.h
@@ -39,6 +39,7 @@ struct page_owner_scan {
 };
 
 bool page_owner_next_eligible(struct page_owner_scan *scan);
+int page_owner_get_nid(struct page *page);
 
 /*
  * mm/page_owner_iter.c
diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
index 80693d417407..907517a29144 100644
--- a/mm/page_owner_iter.c
+++ b/mm/page_owner_iter.c
@@ -165,4 +165,9 @@ __bpf_kfunc int bpf_page_owner_stack_snprint(depot_stack_handle_t handle,
 	return stack_depot_snprint(handle, buf, buf_size, 0);
 }
 
+__bpf_kfunc int bpf_page_owner_get_nid(struct page_owner_scan *scan)
+{
+	return page_owner_get_nid(scan->page);
+}
+
 __bpf_kfunc_end_defs();
-- 
2.20.1


