Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D1D606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=PPC2IDa5
Received: by kanga.kvack.org (Postfix)
	id AF9336B05B4; Tue, 27 Oct 2026 00:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9076B05B6; Tue, 27 Oct 2026 00:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9748F6B05B4; Tue, 27 Oct 2026 00:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 760E46B05B4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:22:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F52312095D
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:21 +0000 (UTC)
X-FDA: 85367109282.17.DDCA2CA
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 483331A0006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:22:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PPC2IDa5;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793074939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YK5LaBMFpVaVrqLIEsL57jG1VfZYq1+Fawu+FzQQ2vo=;
	b=4Zb8rzj1kAX2Hr35MpO91nt3O3leK0BlKdBTrNslcZBmVL+JQlhpeXxsQ8M/4Py9hwNGx7
	Z00ll15YaeXWBgkyrBlgbYdZtzduBYCO2Bf0na2Xqhpzlfc5kZm3CbblWMI9PecB4jsYbm
	ODO77Vu+ipkvRQ05UbxNf9xvagXQFX0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=PPC2IDa5;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.46 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793074939;
	b=lFpPNGa54e5M8/KSCaJdixnFRWk8eH/4UoX4SwZvdvXqPbkJL3z6Wsve03/iHrhhIkXtyG
	9TOFMxTCVYynZmZsxWWwThjT+Z/+FAiL62VlAdeRZWTk6uCeEY3FhRTc/8q9tggfJSBs6G
	2OY80f6XRFVytyd6Svjqoa6Qt+t6MKI=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-917a707f37eso37627026d6.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793074938; x=1793679738; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YK5LaBMFpVaVrqLIEsL57jG1VfZYq1+Fawu+FzQQ2vo=;
        b=PPC2IDa5temrPtYkRE4fGU+vT6mJl5jTe+IhzsWEfX/4fFsd92M+DrdpofL1Zx3Ysm
         L1ofDn0G153Uu1WfTmD7ovrucbzvFzuzr7LSSDHphcHveCCpTYVybSJfCWr1bx7dqcLY
         cq/0jc/N/r7jI7PBoGzfA7x4/ftwYtd924L3YrYCIV+SQBSa2aeb9Hhx7j6wOyXKaoD8
         qQ5yhVhbbcibrgXpv2Wl1ZJpSnoUvivz67KBQOb6GDreNhc5lhZyvqj8/tkhImT0hJAk
         POggkvMm+3v3Ty74KtVH2j27KO9Na13Sqf5TokS94cDP+vXsCnDD4FfaMsuJhUxkmjhZ
         uv+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793074938; x=1793679738;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=YK5LaBMFpVaVrqLIEsL57jG1VfZYq1+Fawu+FzQQ2vo=;
        b=eHXDrtFRtAw4mt31wC4W1YB44kD0ZnZXdaqWOR47Pcv3A0uV1zRonD/9cC3mKQnDAk
         /hDcdko22ZhB4TPOLkN+CoHwmUNORQ8VQZK9MJA2CjDshd2QmQt+PozS6O87iXCsntg6
         mNK9efr46VfS3TnQN7CKzOM84BTqIcnpPCbbK+y2ezk7djvzzNI8J91kBEDQFq/kdtMM
         Q0UilJHBPaCbsIjTn4Zh0GcGKeSqJojmDseik6tdInS+M8fSYOLvaacp+uvjN91haZG5
         KCoe1dKoUlprmxJSXJ7oAByKw2m5ZY02foeaRD01DL48QuxqD8Kf6VGR2b072oJS+Mj0
         Cvsg==
X-Gm-Message-State: AFq9FYLTOFlKW55hGJnpfVpAy7m5VP8Xh6kKxioEqFXeM/uNdyH0xuUF
	zy9Wt5qw9XVgqFEl0JVz2iTK1pvrWG3zliShjBxXJPO3RbO/nOCUwvnwE+1xsAokTMHbCWKJT7l
	bGsZgvek=
X-Gm-Gg: AYBFou1KWkMH9tyJRA/RnFmwh7Dz2XV69HQ3IFY2EKuiyuT2RB0ZW39cTN6eJXO1qOs
	nKPjoQPA9advuaml61lb6t9eDyRxhfyChnxlKy6ESSMomOA0MNZEFmGWYx/Nr7cvWVV0Ne5XlWV
	JBPxHXQY/4jjX4RVTnznrube/7rcmMQTv9HCEpI5mWFh3S9yeLqWICOfW21z8akMZgzPTUfbXGi
	tqLqXOgPinWuwz/2N+pHYukiSzi1f3inqSCvSRkOa9nQBV5oapJvy9A/HEPVhLXiFgZ3uA9xgwM
	XmQjN1JGwnoYGifD+eMn9jeFvukAOkUAsNzNTkE0QsDnWoFnhkTc2XeUhX3jno5K7LFOOKa+5SU
	0Ei8jrEVxpgkokYi/Vi5bDoWGq66YW1HzZus5/UsJ34sNFhQ06GW13iVF5E4SxjW/S7p57aCdjD
	L4+EsMU07rKkh6o8WgdJH71m1XpPzFROq3Ahh2OIis/JUVzJcZouTICIcvJt5VeriWhdJspzEcz
	ljGLiOgPnmLpNEsZvgFRQAOcXt65nZ48YOfUbe1UkFtF2M82p2Qu+HExTdLWe4az1f+XFbb6zhV
	1PFBevgWx7foSY+MszkmenXwB22uQSN8JsPC+8J32g==
X-Received: by 2002:a05:620a:4549:b0:93e:f4f4:346 with SMTP id af79cd13be357-940ef8ef6e5mr1336003385a.39.1793074938389;
        Mon, 26 Oct 2026 21:22:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47bd01cdsm91139676d6.7.2026.10.26.21.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 21:22:17 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	osalvador@suse.de,
	muchun.song@linux.dev,
	iamjoonsoo.kim@lge.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH 2/6] mm/page_owner: hold off memory offline while a page is read
Date: Tue, 27 Oct 2026 00:22:00 -0400
Message-ID: <20261027042204.3741307-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261027042204.3741307-1-gourry@gourry.net>
References: <20261027042204.3741307-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 483331A0006
X-Stat-Signature: 76tshsoi948kb79m3q9u4rn4rbpgcm56
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793074939-221147
X-HE-Meta: U2FsdGVkX1867mGFfmU1xkoGumcZmhiV2iXKPIob14UNDscfm4W/rfc3dzHPu9/2Mgt/aliaHqj8FDHJPVyxLL+Md4kb6nQdjyCN9eueU9vKuD2kid12T0P1JtSbWU1/b8qrOPhoE0EckEKH6raPfVOyZpeaV1nlIu1a7UO4Sfv8jU8d50iTyiMN9mFhz21SkB3W9xtZun8ttx2dGY27goYraAZnPF6nVp4VVhPzvZc9MKu7Te18Rotv1auTNJKH2OsbzTJ3oOXXpXztB4wEVj2xsHZ4YjC/AKl5Qj+tA8DcAp071fD+IOufIDNzBIouGm69n7M9gWE9wqFzAmukrGVA3XnKuxVSAF0b7UW3Hgoz9zkNbiOPEZyQJt/GRQ1CejWawGvQleodJ3iY24O84s0sEn532uWMXCmnx8OTTw+AAM+BNYQ0cu9N3zicSQhA/6vhA7wkCiPot/t7KDDpcT8UYbyql9ICKV8vKempBoyCmY9aQiuPKrG/4nKqMuyNvIE9ff0cwdq3vejA9f7Dpqs5N5LWiwxICKjIVzKT9PZA0UY9FxVLBimlQPcSHS46on3mb068rladV28f5/Y79gs+CQ9UWdTF7ssSlunRvKtUgfLn1xLw1ZbeN9QtsTeJ6Vbap2Olyn3+Z+600K3DvAwu0Ur1XXxYo90CHw0WCD09iv4fsyPkRtm+2mSrHSCYl93CaBYyAOEMjo2JmHqPP5AFtlRlA9MBsUVkjI+DRJSWhpFIqua+t1S9s9RRNdiXoy8hIhTiC3or08mTOfNAndngx590GgmHNx+WLaNNEm8BGb8t64lPYkOJqd7VVeGXhGNMULUu2pPHc9UJGK8CVqoJgQsUrC05LOPjMcH4AL6wspLnDU31Gfam/bpb3X9peIMbrfd9qxlgUDlHd6dZXAripvs3YERePu4XL2X36uU/qM0A6wq56qo0fBcDys1Pgww9R7DcV+y7goAYuF4
 x9eLZioe
 D9TpXnocWmZaDExYy08np+wItEA9jqLzYZpSuv/O/VcoddUV83njn2uQgdjdUaqPWP6ESUt7VkFXqYKCcS3Q4qIRgz/9oRCW4FurjaqpRQFUJe71RqwJaVkNcjyE4MwaOGGwL4S4AQHbOBXXu3aPxHKMtlbKz5AKV//yddGntGH/iQdg5moB4KgaQQUh3uYYbnCsUGCpTmDS04RZocQAR0ZIryZFQfsdKhz34+GZAKfP3JI3TOtEEaJ3V+zaC4Wxdi4VU3bjckhYjfMsK3WsxkSlJTkTKsvXElAX53/8Kfuy0WmUiSwDBpGrundNsYxTKY3C0k2FEOX54v4mva51IwWYQiY9NBLTjjSEWKXn+TaaYEFxICxmaNo97UxvJdR7QSYR7fkc8Gda9EWaN59NiNXR4KWYNX+5YXY7Y7K0yG6NhAfKvhqrOtMikFR0vK5ZMpjVR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reading /sys/kernel/debug/page_owner while memory is removed can oops.
read_page_owner() checks a pfn with pfn_valid(), and print_page_owner()
can sleep in kmalloc() before it reads the struct page:

  CPU 1 (read page_owner)             CPU 2 (remove the memory block)
  pfn_valid(pfn)
  page = pfn_to_page(pfn)
  page_ext_get()
  page_ext_put()
  print_page_owner()
    kmalloc()
                                      offline_pages()
                                        remove_pfn_range_from_zone()
                                      arch_remove_memory()
                                        frees the vmemmap
    get_pageblock_migratetype(page)

  BUG: unable to handle page fault for address: ffd4000006000000
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  Oops: Oops: 0000 [#1] SMP KASAN
  RIP: 0010:__get_pfnblock_flags_mask+0x3e/0x2b0
  Call Trace:
   <TASK>
   get_pfnblock_migratetype+0xf/0x20
   read_page_owner+0x629/0xf00
   full_proxy_read+0x102/0x190
   vfs_read+0x153/0xcd0
   ksys_read+0xe4/0x1b0
   do_syscall_64+0xbd/0x630
   entry_SYSCALL_64_after_hwframe+0x4b/0x53

Offline alone faults the same way on DEBUG_VM kernels.  The page_ext is
safe; offline_page_ext() frees it after an RCU grace period.

Check the pfn with pfn_to_online_page() inside a pfn_walk read section,
which offline waits for, and move kmalloc() and copy_to_user() out of
it, since offline waits with the hotplug locks held.  A full read of
page_owner in a 5G guest takes 1.36 s before and 1.34 s after.

With a kprobe sleeping the reader on a DIMM pfn across an offline or a
removal, base faults in 3 of 3 runs of each and this patch in none.

Fixes: 48c96a368579 ("mm/page_owner: keep track of page owners")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_owner.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d7657..d2c0b831fcd3b 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -13,6 +13,7 @@
 #include <linux/memcontrol.h>
 #include <linux/sched/clock.h>
 
+#include "internal.h"
 #include "page_alloc.h"
 
 /*
@@ -600,20 +601,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 #endif
 
 static ssize_t
-print_page_owner(char __user *buf, size_t count, unsigned long pfn,
+print_page_owner(char *kbuf, size_t count, unsigned long pfn,
 		struct page *page, struct page_owner *page_owner,
 		depot_stack_handle_t handle,
 		struct page_owner_filter_state *state)
 {
 	int ret, pageblock_mt, page_mt;
-	char *kbuf;
 	enum page_owner_print_mode print_mode;
 
-	count = min_t(size_t, count, PAGE_SIZE);
-	kbuf = kmalloc(count, GFP_KERNEL);
-	if (!kbuf)
-		return -ENOMEM;
-
 	print_mode = state->print_mode;
 
 	ret = scnprintf(kbuf, count,
@@ -637,14 +632,14 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 	if (print_mode != PAGE_OWNER_PRINT_HANDLE) {
 		ret += stack_depot_snprint(handle, kbuf + ret, count - ret, 0);
 		if (ret >= count)
-			goto err;
+			return -ENOMEM;
 	}
 
 	if (print_mode != PAGE_OWNER_PRINT_STACK) {
 		ret += scnprintf(kbuf + ret, count - ret, "handle: %u\n",
 				 handle);
 		if (ret >= count)
-			goto err;
+			return -ENOMEM;
 	}
 
 	if (page_owner->last_migrate_reason != MR_NEVER) {
@@ -657,17 +652,9 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
 
 	ret += snprintf(kbuf + ret, count - ret, "\n");
 	if (ret >= count)
-		goto err;
-
-	if (copy_to_user(buf, kbuf, ret))
-		ret = -EFAULT;
+		return -ENOMEM;
 
-	kfree(kbuf);
 	return ret;
-
-err:
-	kfree(kbuf);
-	return -ENOMEM;
 }
 
 void __dump_page_owner(const struct page *page)
@@ -734,10 +721,17 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	struct page_owner *page_owner;
 	depot_stack_handle_t handle;
 	struct page_owner_filter_state *state = file->private_data;
+	ssize_t ret = 0;
+	char *kbuf;
 
 	if (!static_branch_unlikely(&page_owner_inited))
 		return -EINVAL;
 
+	count = min_t(size_t, count, PAGE_SIZE);
+	kbuf = kmalloc(count, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
 	page = NULL;
 	if (*ppos == 0)
 		pfn = min_low_pfn;
@@ -766,7 +760,12 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 			continue;
 		}
 
-		page = pfn_to_page(pfn);
+		/* Offline waits for us before it poisons the memmap */
+		guard(pfn_walk)();
+		page = pfn_to_online_page(pfn);
+		if (!page)
+			continue;
+
 		if (skip_buddy_pages(&pfn, page))
 			continue;
 
@@ -825,14 +824,18 @@ read_page_owner(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 
 		page_owner_tmp = *page_owner;
 		page_ext_put(page_ext);
-		return print_page_owner(buf, count, pfn, page,
+		ret = print_page_owner(kbuf, count, pfn, page,
 				&page_owner_tmp, handle, state);
+		break;
 ext_put_continue:
 		page_ext_put(page_ext);
 		cond_resched();
 	}
 
-	return 0;
+	if (ret > 0 && copy_to_user(buf, kbuf, ret))
+		ret = -EFAULT;
+	kfree(kbuf);
+	return ret;
 }
 
 static loff_t lseek_page_owner(struct file *file, loff_t offset, int orig)
-- 
2.53.0-Meta


