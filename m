Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 355AFCD4F52
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4FF6B00B4; Mon, 18 May 2026 21:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E526B6B00B5; Mon, 18 May 2026 21:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55416B00B6; Mon, 18 May 2026 21:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE1D46B00B4
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:28:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DD3F120125
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:06 +0000 (UTC)
X-FDA: 84782433372.17.ADE62D0
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4B523C0006
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:28:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WpwJL+JY;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYIFZtEOROXKEaAPsW/zk5dSrEVUPynUxnKhGIAxI0A=;
	b=cxqDuckZUsSUyozHesMROZk5XneBVW2POVcGdfXJYOE3YHHRfvUz9lKFe8zBS4ER76GGKk
	iaFI/bJVRNjrRIVktLWR1boaayVkeF5uqFgf/ha0x55UTXN+5LBbSBEOWK7KXSrDuWkIKt
	3CJNhLgpvApvF4Usc1S4o+pmOAaOMzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154084; a=rsa-sha256;
	cv=none;
	b=rxCTjSLM4qfrT03Ab4F3OBKuKqoQx5PE4XMiM4Bezmsn1YMAxE1eDKO54t8XoSpxPzLWk2
	8o389TUIGlrDKf8VGnevh6e8VPJLnrDCqkiHjwC2mcjzldyeJabJlqf0i3AJ/AxmYcwT6v
	pTGpKSOem1wYejgPirz6a4qJvPbvj3Y=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WpwJL+JY;
	spf=pass (imf22.hostedemail.com: domain of leobras.c@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=leobras.c@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-441209fb77eso1699843f8f.1
        for <linux-mm@kvack.org>; Mon, 18 May 2026 18:28:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779154083; x=1779758883; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NYIFZtEOROXKEaAPsW/zk5dSrEVUPynUxnKhGIAxI0A=;
        b=WpwJL+JY3s4cfKww9LDnuZoXm5XZCQXFYMWuP7JqOZ5nXOm2CbUhVsR1JfhLXaeRD3
         fnx0GJ1pjGCMcDpGCKFuE8O44LbqNa0ENwdtSzVO41iHUNy1O9ubW7ekkT+IQr4xvDE2
         jAm0g+i7aU4iMnh7G95XYD4T76FxWwAGbZjlWVsqVe6Qw6HI9YHr+2+gQiTT9ZTxnRQQ
         rwIFHX3iSjwCQ6UqrE2JU5E8+etNQh48u051RabjiXWXagrEj9q28U7YrHnKW3fkXTvr
         ap33M4fxrLeNFHavLADss95XnCgcltZmWQ/RDt139SisrWg34/D0/q2E54KvaGuLQqJ4
         bnQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779154083; x=1779758883;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NYIFZtEOROXKEaAPsW/zk5dSrEVUPynUxnKhGIAxI0A=;
        b=ssrYbNwctR7SJuD6PTfb/u7+/yNnB3blepO620SH28K3TX5BSzqLo/9mHR8HB1DYLj
         52XABwq2JO1kJZi5zvxQcHCUqRjDfkeSUNR2wZ/ApFEo0oewUzZS7lS1UQ9onHyHuCep
         BSxlkUKUZuN2RwWFsltmMdpOL1xhgZm3yoRx0OLzGatgSmldnDDyacQOdJ6uSHP3YFj9
         LFC0FE9b6YcXo58YYk9YeiPJsTM/v9Sd5eAtsR7qqX3MEr/3ReqUfB8mzuQvmWL1eoBg
         cymfWqjO+zvi9bnSbkuDB/10wwmW1xeqX40+ForxQJkYWKKMQYJRXpilB0LzlQiNIfPX
         7cpg==
X-Forwarded-Encrypted: i=1; AFNElJ9CJZG/26l8tuPn7W8/f5wUbn/f2mWWTLwd/kltU0dxz/7+cL5+Krempir7uknnGk1Em1U08wtu7g==@kvack.org
X-Gm-Message-State: AOJu0YxtUIntZaqvTrHKJl7WkENNmduMMTCL9wyDXQ/wpuDnV/NDOdy7
	ao1Bm8txaO1lVLaYoUV/ZnWa6Imxq+d0r8/ySNkFcGQMwWaLJSsuBnQt
X-Gm-Gg: Acq92OEUASLQ7bh8s8JDVEXctdx/1KN3fea5HpOWV2kkI95Lz12R5KhGQ5tOeecuKUr
	yFZroE/+gbgpdmm8ByYOb9yO80OPw2XaCClC1vvVFpDRa/96hT9T8+Agp45vb2E5O0rzno4mDeB
	Fm6VGNgykHCW9E8nFfMIhx7rNwpA00BqDIPHu4ou4lLlMLwD8nYn/5nTo0Fmah77AdVOfmmFbaw
	6l20BbrpaZeH0bn1Su7mCEK2G7MYOP7R6ahdphJRcjT49gswdOACpLbj7vp+wvlxz4lVWKB4X6J
	ssiXlpBNQjd2mTFZ20/0MZIzTEsZCQDxuzRDKXIczsOOpqcb4dHrfxSVejFA5NtdUUZU01yldzM
	yOmSBL6fownNHvJdzI9Zf7glxUpIoLpjv3C3Scmw+q87Hk4Ix50bgcBZPnf/yHd9QlkL2MiaTxN
	FJLuQCVCNzgcxDaCI9sE197g1hZ2IEiw==
X-Received: by 2002:a05:6000:1a89:b0:452:bc74:b129 with SMTP id ffacd0b85a97d-45e5b886090mr27913668f8f.16.1779154082589;
        Mon, 18 May 2026 18:28:02 -0700 (PDT)
Received: from WindFlash.powerhub ([2a0a:ef40:f83:8501:800:cd4:5e2:9556])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ed2f738sm40548683f8f.16.2026.05.18.18.28.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 May 2026 18:28:02 -0700 (PDT)
From: Leonardo Bras <leobras.c@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Leonardo Bras <leobras.c@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Randy Dunlap <rdunlap@infradead.org>,
	Feng Tang <feng.tang@linux.alibaba.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Kees Cook <kees@kernel.org>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Li RongQing <lirongqing@baidu.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nsc@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Gary Guo <gary@garyguo.net>,
	Christian Brauner <brauner@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Coiby Xu <coxu@redhat.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v4 3/4] swap: apply new pw_queue_on() interface
Date: Mon, 18 May 2026 22:27:49 -0300
Message-ID: <20260519012754.240804-4-leobras.c@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260519012754.240804-1-leobras.c@gmail.com>
References: <20260519012754.240804-1-leobras.c@gmail.com>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=18514; i=leobras.c@gmail.com; h=from:subject; bh=4BVHLvuBFvyjuj3EzPBbAtH6I8IO+E5EmUGwpgvpZIw=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLK494Tn32I2yTyYcNf+2gxpTttQn28Xuy5dClV5u+9Kg fdhrvXZHaUsDGJcDLJiiiyyj+av4vk+JePIlR8LYOawMoEMYeDiFICJzEhn+Ke/3XQKX/6NHQ1r lqyp+db4e7lR2Jpv0/472m5+VGmyNiSMkWGj5y7lVyWfTuptXGOse/JHiYrpFp3fMo/XW66d/fT Qvi3sAA==
X-Developer-Key: i=leobras.c@gmail.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4B523C0006
X-Rspam-User: 
X-Stat-Signature: uyqhbpzinoicexyjs91nxzoym7b1j8cq
X-HE-Tag: 1779154084-466643
X-HE-Meta: U2FsdGVkX1+LNHJ+GUPqYChwqAW0Zg9ji3uq/u0h8Ek/dtUI0y515kyhZ0k+rKl2XIJHSpASGNW98M3Wxun8QXBO71OxHiZJygmkBuDLPpJYeVQhuFlkZ1sOHEOLQt3KKlywW8fv6VrBeKsinQ/uB2al4IFRWZ1UniHi/Npx/N96F81njmuXwZqgnecTxfKEyofq30MZXsJV5iO79q7xVfHOWecPF9HcvfssopQPoiN2MmvqCfozEoHwzR5N9sRWQhOxERf6Em8yzV7Nw3v4W58zftyZCNVKHVuJdOd8CPxNBGmSL3/ArTIwrLN/8eTNLt+vkvY/FsZtDowCMcS4j2A99q3MGUqLKd78XsI4hjKrK41x+/3/v6nnopxObHdUmVxNSVKGD2UBqWOrqCrmsDj0tH2fsVAuaqaxqBEhSgnt3Af370Ecm1GQqGDhnTNTGgyo0AZFAfv6XgetCpqyaUM4R+kYatwiC+pI9BF1iZjC0RJejQTl/w0m7+U27DP3iP9//yze7c3BXqMS7ktlphWF8IMFujpksyQVpTtcO8c7UmIuUetPwkRB+7Q4BdulHNOEtsAaw52++UGAC7EfcAcEs6lKOL97QxROyfWyC8sXvo6OwDU4N79MVSM21pO3hQc7Y4HSqZrqr5n7WfDzyHyJdGdqZPiQf22xGmy+i/8oqN2nWf+nhFOr1pyFDVbthVMzSCnMhne3XVWJzCBBXP71/MNnSKNtzsBGHWNf28uboDs3xMnk7jdeqivkHcQgtw7Njpk6JUEXkP8P+d7uXBHbaYy4PHGOsPvfqfntpjIrKBbocjB4JEkDzH4unomh0Gu/5xO09j/DedaMIEb8cUz2qLfaMtm2zFRiuCIDQ0hLhj1KXRT94/WmLUR5s+ftZ0V43zF9vFgyFU3r9pKdCXXixFbRVFliFINJKflEJYiArEebV2nVDwRr7zUO5tPGwfm+4MK59w5x0gKbfCL
 O+oexebf
 /B0JDxLPCD19ZTDzX9vdbAWu2NPii+mHlYXYrwy79GgSW6M17xVyKsGPK9ScAKA2g1pJc6Fn8XMScGJTYpsSahzS9jBuAzHkx6NSAO+u5xA92mwjewsaMkLQiNHd/fc1iFMIcAT52AuBz38DHIoeX91blmSwM3LNjwWz1kbNY6l5NoKC9jOF70Iqy5Pc+OnUWssFOUtguzhqjCLCNjECugaOG/wzhFCQ9j5ws9tT4WW6MwTc565LST+qPidrYwR8+SmgonsSnqWE6wBTiGmjE4Hq3pebScwfdlcgPZGR8OxaaQyjbNbmBoTIJ5zwlDEg2muOapcR1RJve/j8cOUjkAy3dJg1RxL/WBmug9Zu/A/Yhffbosj/IV2RRLarmQxr+MQo3Cy0ubzUMQHGLv8CTtz8nG+MaFDUcmIcwYm1Or0YbJKE/NC4hyKkTTO4FfYa/KUvI1oUaURHYZtuslqiLo3nNrodzA3e8txOaYrOI0loDItqoBwR3oBo00e6DLEZ/mnKY/45s39+piuYIkiL2mi51JHIA40P4Nc2IjEP7O3CaPhIXcSQ5F5QGZJJA2cuCi7iY/s0wo5K7n/BdvBokamJ1JvrEgi2NRCHZ2tFby+7tzYEg9oHzv3VI6MesyAq5qVwi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make use of the new pw_{un,}lock*() and pw_queue_on() interface to improve
performance & latency.

For functions that may be scheduled in a different cpu, replace
local_{un,}lock*() by pw_{un,}lock*(), and replace schedule_work_on() by
pw_queue_on(). The same happens for flush_work() and pw_flush().

The change requires allocation of pw_structs instead of a work_structs,
and changing parameters of a few functions to include the cpu parameter.

This should bring no relevant performance impact on non-PWLOCKS kernels:
For functions that may be scheduled in a different cpu, the local_*lock's
this_cpu_ptr() becomes a per_cpu_ptr(smp_processor_id()).

Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 mm/internal.h   |  4 ++-
 mm/mlock.c      | 51 ++++++++++++++++++++++++++----------
 mm/page_alloc.c |  2 +-
 mm/swap.c       | 69 ++++++++++++++++++++++++++-----------------------
 4 files changed, 79 insertions(+), 47 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 5a2ddcf68e0b..1ec9a11c373b 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1209,24 +1209,26 @@ static inline void munlock_vma_folio(struct folio *folio,
 	 * cause folio not fully mapped to VMA.
 	 *
 	 * But it's not easy to confirm that's the situation. So we
 	 * always munlock the folio and page reclaim will correct it
 	 * if it's wrong.
 	 */
 	if (unlikely(vma->vm_flags & VM_LOCKED))
 		munlock_folio(folio);
 }
 
+int __init mlock_init(void);
 void mlock_new_folio(struct folio *folio);
 bool need_mlock_drain(int cpu);
 void mlock_drain_local(void);
-void mlock_drain_remote(int cpu);
+void mlock_drain_cpu(int cpu);
+void mlock_drain_offline(int cpu);
 
 extern pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma);
 
 /**
  * vma_address - Find the virtual address a page range is mapped at
  * @vma: The vma which maps this object.
  * @pgoff: The page offset within its object.
  * @nr_pages: The number of pages to consider.
  *
  * If any page in this range is mapped by this VMA, return the first address
diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..5d25bbbb09e9 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -18,31 +18,30 @@
 #include <linux/mempolicy.h>
 #include <linux/syscalls.h>
 #include <linux/sched.h>
 #include <linux/export.h>
 #include <linux/rmap.h>
 #include <linux/mmzone.h>
 #include <linux/hugetlb.h>
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/secretmem.h>
+#include <linux/pwlocks.h>
 
 #include "internal.h"
 
 struct mlock_fbatch {
-	local_lock_t lock;
+	pw_lock_t lock;
 	struct folio_batch fbatch;
 };
 
-static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-};
+static DEFINE_PER_CPU(struct mlock_fbatch, mlock_fbatch);
 
 bool can_do_mlock(void)
 {
 	if (rlimit(RLIMIT_MEMLOCK) != 0)
 		return true;
 	if (capable(CAP_IPC_LOCK))
 		return true;
 	return false;
 }
 EXPORT_SYMBOL(can_do_mlock);
@@ -202,32 +201,43 @@ static void mlock_folio_batch(struct folio_batch *fbatch)
 			lruvec = __mlock_new_folio(folio, lruvec);
 		else
 			lruvec = __munlock_folio(folio, lruvec);
 	}
 
 	if (lruvec)
 		lruvec_unlock_irq(lruvec);
 	folios_put(fbatch);
 }
 
+void mlock_drain_cpu(int cpu)
+{
+	struct folio_batch *fbatch;
+
+	pw_lock(&mlock_fbatch.lock, cpu);
+	fbatch = per_cpu_ptr(&mlock_fbatch.fbatch, cpu);
+	if (folio_batch_count(fbatch))
+		mlock_folio_batch(fbatch);
+	pw_unlock(&mlock_fbatch.lock, cpu);
+}
+
 void mlock_drain_local(void)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	pw_lock_local(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	if (folio_batch_count(fbatch))
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	pw_unlock_local(&mlock_fbatch.lock);
 }
 
-void mlock_drain_remote(int cpu)
+void mlock_drain_offline(int cpu)
 {
 	struct folio_batch *fbatch;
 
 	WARN_ON_ONCE(cpu_online(cpu));
 	fbatch = &per_cpu(mlock_fbatch.fbatch, cpu);
 	if (folio_batch_count(fbatch))
 		mlock_folio_batch(fbatch);
 }
 
 bool need_mlock_drain(int cpu)
@@ -236,79 +246,79 @@ bool need_mlock_drain(int cpu)
 }
 
 /**
  * mlock_folio - mlock a folio already on (or temporarily off) LRU
  * @folio: folio to be mlocked.
  */
 void mlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	pw_lock_local(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 
 	if (!folio_test_set_mlocked(folio)) {
 		int nr_pages = folio_nr_pages(folio);
 
 		zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
 		__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 	}
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_lru(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	pw_unlock_local(&mlock_fbatch.lock);
 }
 
 /**
  * mlock_new_folio - mlock a newly allocated folio not yet on LRU
  * @folio: folio to be mlocked, either normal or a THP head.
  */
 void mlock_new_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 	int nr_pages = folio_nr_pages(folio);
 
-	local_lock(&mlock_fbatch.lock);
+	pw_lock_local(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	folio_set_mlocked(folio);
 
 	zone_stat_mod_folio(folio, NR_MLOCK, nr_pages);
 	__count_vm_events(UNEVICTABLE_PGMLOCKED, nr_pages);
 
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, mlock_new(folio)) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	pw_unlock_local(&mlock_fbatch.lock);
 }
 
 /**
  * munlock_folio - munlock a folio
  * @folio: folio to be munlocked, either normal or a THP head.
  */
 void munlock_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 
-	local_lock(&mlock_fbatch.lock);
+	pw_lock_local(&mlock_fbatch.lock);
 	fbatch = this_cpu_ptr(&mlock_fbatch.fbatch);
 	/*
 	 * folio_test_clear_mlocked(folio) must be left to __munlock_folio(),
 	 * which will check whether the folio is multiply mlocked.
 	 */
 	folio_get(folio);
 	if (!folio_batch_add(fbatch, folio) ||
 	    !folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		mlock_folio_batch(fbatch);
-	local_unlock(&mlock_fbatch.lock);
+	pw_unlock_local(&mlock_fbatch.lock);
 }
 
 static inline unsigned int folio_mlock_step(struct folio *folio,
 		pte_t *pte, unsigned long addr, unsigned long end)
 {
 	unsigned int count = (end - addr) >> PAGE_SHIFT;
 	pte_t ptent = ptep_get(pte);
 
 	if (!folio_test_large(folio))
 		return 1;
@@ -822,10 +832,25 @@ int user_shm_lock(size_t size, struct ucounts *ucounts)
 	return allowed;
 }
 
 void user_shm_unlock(size_t size, struct ucounts *ucounts)
 {
 	spin_lock(&shmlock_user_lock);
 	dec_rlimit_ucounts(ucounts, UCOUNT_RLIMIT_MEMLOCK, (size + PAGE_SIZE - 1) >> PAGE_SHIFT);
 	spin_unlock(&shmlock_user_lock);
 	put_ucounts(ucounts);
 }
+
+int __init mlock_init(void)
+{
+	unsigned int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct mlock_fbatch *fbatch = &per_cpu(mlock_fbatch, cpu);
+
+		pw_lock_init(&fbatch->lock);
+	}
+
+	return 0;
+}
+
+module_init(mlock_init);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 227d58dc3de6..fa768f07f88a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6217,21 +6217,21 @@ void free_reserved_page(struct page *page)
 	__free_page(page);
 	adjust_managed_page_count(page, 1);
 }
 EXPORT_SYMBOL(free_reserved_page);
 
 static int page_alloc_cpu_dead(unsigned int cpu)
 {
 	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
-	mlock_drain_remote(cpu);
+	mlock_drain_offline(cpu);
 	drain_pages(cpu);
 
 	/*
 	 * Spill the event counters of the dead processor
 	 * into the current processors event counters.
 	 * This artificially elevates the count of the current
 	 * processor.
 	 */
 	vm_events_fold_cpu(cpu);
 
diff --git a/mm/swap.c b/mm/swap.c
index ed9b3d371547..42f51bf4bb71 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -28,54 +28,51 @@
 #include <linux/memremap.h>
 #include <linux/percpu.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
 #include <linux/backing-dev.h>
 #include <linux/memcontrol.h>
 #include <linux/gfp.h>
 #include <linux/uio.h>
 #include <linux/hugetlb.h>
 #include <linux/page_idle.h>
-#include <linux/local_lock.h>
+#include <linux/pwlocks.h>
 #include <linux/buffer_head.h>
 
 #include "internal.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/pagemap.h>
 
 /* How many pages do we try to swap or page in/out together? As a power of 2 */
 int page_cluster;
 static const int page_cluster_max = 31;
 
 struct cpu_fbatches {
 	/*
 	 * The following folio batches are grouped together because they are protected
 	 * by disabling preemption (and interrupts remain enabled).
 	 */
-	local_lock_t lock;
+	pw_lock_t lock;
 	struct folio_batch lru_add;
 	struct folio_batch lru_deactivate_file;
 	struct folio_batch lru_deactivate;
 	struct folio_batch lru_lazyfree;
 #ifdef CONFIG_SMP
 	struct folio_batch lru_activate;
 #endif
 	/* Protecting the following batches which require disabling interrupts */
-	local_lock_t lock_irq;
+	pw_lock_t lock_irq;
 	struct folio_batch lru_move_tail;
 };
 
-static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches) = {
-	.lock = INIT_LOCAL_LOCK(lock),
-	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
-};
+static DEFINE_PER_CPU(struct cpu_fbatches, cpu_fbatches);
 
 static void __page_cache_release(struct folio *folio, struct lruvec **lruvecp,
 		unsigned long *flagsp)
 {
 	if (folio_test_lru(folio)) {
 		folio_lruvec_relock_irqsave(folio, lruvecp, flagsp);
 		lruvec_del_folio(*lruvecp, folio);
 		__folio_clear_lru_flags(folio);
 	}
 }
@@ -180,32 +177,32 @@ static void folio_batch_move_lru(struct folio_batch *fbatch, move_fn_t move_fn)
 }
 
 static void __folio_batch_add_and_move(struct folio_batch __percpu *fbatch,
 		struct folio *folio, move_fn_t move_fn, bool disable_irq)
 {
 	unsigned long flags;
 
 	folio_get(folio);
 
 	if (disable_irq)
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		pw_lock_local_irqsave(&cpu_fbatches.lock_irq, flags);
 	else
-		local_lock(&cpu_fbatches.lock);
+		pw_lock_local(&cpu_fbatches.lock);
 
 	if (!folio_batch_add(this_cpu_ptr(fbatch), folio) ||
 			!folio_may_be_lru_cached(folio) || lru_cache_disabled())
 		folio_batch_move_lru(this_cpu_ptr(fbatch), move_fn);
 
 	if (disable_irq)
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		pw_unlock_local_irqrestore(&cpu_fbatches.lock_irq, flags);
 	else
-		local_unlock(&cpu_fbatches.lock);
+		pw_unlock_local(&cpu_fbatches.lock);
 }
 
 #define folio_batch_add_and_move(folio, op)		\
 	__folio_batch_add_and_move(			\
 		&cpu_fbatches.op,			\
 		folio,					\
 		op,					\
 		offsetof(struct cpu_fbatches, op) >=	\
 		offsetof(struct cpu_fbatches, lock_irq)	\
 	)
@@ -356,21 +353,21 @@ void folio_activate(struct folio *folio)
 	lruvec_unlock_irq(lruvec);
 	folio_set_lru(folio);
 }
 #endif
 
 static void __lru_cache_activate_folio(struct folio *folio)
 {
 	struct folio_batch *fbatch;
 	int i;
 
-	local_lock(&cpu_fbatches.lock);
+	pw_lock_local(&cpu_fbatches.lock);
 	fbatch = this_cpu_ptr(&cpu_fbatches.lru_add);
 
 	/*
 	 * Search backwards on the optimistic assumption that the folio being
 	 * activated has just been added to this batch. Note that only
 	 * the local batch is examined as a !LRU folio could be in the
 	 * process of being released, reclaimed, migrated or on a remote
 	 * batch that is currently being drained. Furthermore, marking
 	 * a remote batch's folio active potentially hits a race where
 	 * a folio is marked active just after it is added to the inactive
@@ -378,21 +375,21 @@ static void __lru_cache_activate_folio(struct folio *folio)
 	 */
 	for (i = folio_batch_count(fbatch) - 1; i >= 0; i--) {
 		struct folio *batch_folio = fbatch->folios[i];
 
 		if (batch_folio == folio) {
 			folio_set_active(folio);
 			break;
 		}
 	}
 
-	local_unlock(&cpu_fbatches.lock);
+	pw_unlock_local(&cpu_fbatches.lock);
 }
 
 #ifdef CONFIG_LRU_GEN
 
 static void lru_gen_inc_refs(struct folio *folio)
 {
 	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
 
 	if (folio_test_unevictable(folio))
 		return;
@@ -652,23 +649,23 @@ void lru_add_drain_cpu(int cpu)
 
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_add);
 
 	fbatch = &fbatches->lru_move_tail;
 	/* Disabling interrupts below acts as a compiler barrier. */
 	if (data_race(folio_batch_count(fbatch))) {
 		unsigned long flags;
 
 		/* No harm done if a racing interrupt already did this */
-		local_lock_irqsave(&cpu_fbatches.lock_irq, flags);
+		pw_lock_irqsave(&cpu_fbatches.lock_irq, flags, cpu);
 		folio_batch_move_lru(fbatch, lru_move_tail);
-		local_unlock_irqrestore(&cpu_fbatches.lock_irq, flags);
+		pw_unlock_irqrestore(&cpu_fbatches.lock_irq, flags, cpu);
 	}
 
 	fbatch = &fbatches->lru_deactivate_file;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate_file);
 
 	fbatch = &fbatches->lru_deactivate;
 	if (folio_batch_count(fbatch))
 		folio_batch_move_lru(fbatch, lru_deactivate);
 
@@ -732,56 +729,56 @@ void folio_mark_lazyfree(struct folio *folio)
 	if (!folio_test_anon(folio) || !folio_test_swapbacked(folio) ||
 	    !folio_test_lru(folio) ||
 	    folio_test_swapcache(folio) || folio_test_unevictable(folio))
 		return;
 
 	folio_batch_add_and_move(folio, lru_lazyfree);
 }
 
 void lru_add_drain(void)
 {
-	local_lock(&cpu_fbatches.lock);
+	pw_lock_local(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
+	pw_unlock_local(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
 /*
  * It's called from per-cpu workqueue context in SMP case so
  * lru_add_drain_cpu and invalidate_bh_lrus_cpu should run on
  * the same cpu. It shouldn't be a problem in !SMP case since
  * the core is only one and the locks will disable preemption.
  */
-static void lru_add_mm_drain(void)
+static void lru_add_mm_drain(int cpu)
 {
-	local_lock(&cpu_fbatches.lock);
-	lru_add_drain_cpu(smp_processor_id());
-	local_unlock(&cpu_fbatches.lock);
-	mlock_drain_local();
+	pw_lock(&cpu_fbatches.lock, cpu);
+	lru_add_drain_cpu(cpu);
+	pw_unlock(&cpu_fbatches.lock, cpu);
+	mlock_drain_cpu(cpu);
 }
 
 void lru_add_drain_cpu_zone(struct zone *zone)
 {
-	local_lock(&cpu_fbatches.lock);
+	pw_lock_local(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	drain_local_pages(zone);
-	local_unlock(&cpu_fbatches.lock);
+	pw_unlock_local(&cpu_fbatches.lock);
 	mlock_drain_local();
 }
 
 #ifdef CONFIG_SMP
 
-static DEFINE_PER_CPU(struct work_struct, lru_add_drain_work);
+static DEFINE_PER_CPU(struct pw_struct, lru_add_drain_pw);
 
-static void lru_add_drain_per_cpu(struct work_struct *dummy)
+static void lru_add_drain_per_cpu(struct work_struct *w)
 {
-	lru_add_mm_drain();
+	lru_add_mm_drain(pw_get_cpu(w));
 }
 
 static DEFINE_PER_CPU(struct work_struct, bh_add_drain_work);
 
 static void bh_add_drain_per_cpu(struct work_struct *dummy)
 {
 	invalidate_bh_lrus_cpu();
 }
 
 static bool cpu_needs_mm_drain(unsigned int cpu)
@@ -882,38 +879,38 @@ static inline void __lru_add_drain_all(bool force_all_cpus)
 	 * If the paired barrier is done at any later step, e.g. after the
 	 * loop, CPU #x will just exit at (C) and miss flushing out all of its
 	 * added pages.
 	 */
 	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
 	smp_mb();
 
 	cpumask_clear(&has_mm_work);
 	cpumask_clear(&has_bh_work);
 	for_each_online_cpu(cpu) {
-		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
+		struct pw_struct *mm_pw = &per_cpu(lru_add_drain_pw, cpu);
 		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
 
 		if (cpu_needs_mm_drain(cpu)) {
-			INIT_WORK(mm_work, lru_add_drain_per_cpu);
-			queue_work_on(cpu, mm_percpu_wq, mm_work);
+			INIT_PW(mm_pw, lru_add_drain_per_cpu, cpu);
+			pw_queue_on(cpu, mm_percpu_wq, mm_pw);
 			__cpumask_set_cpu(cpu, &has_mm_work);
 		}
 
 		if (cpu_needs_bh_drain(cpu)) {
 			INIT_WORK(bh_work, bh_add_drain_per_cpu);
 			queue_work_on(cpu, mm_percpu_wq, bh_work);
 			__cpumask_set_cpu(cpu, &has_bh_work);
 		}
 	}
 
 	for_each_cpu(cpu, &has_mm_work)
-		flush_work(&per_cpu(lru_add_drain_work, cpu));
+		pw_flush(&per_cpu(lru_add_drain_pw, cpu));
 
 	for_each_cpu(cpu, &has_bh_work)
 		flush_work(&per_cpu(bh_add_drain_work, cpu));
 
 done:
 	mutex_unlock(&lock);
 }
 
 void lru_add_drain_all(void)
 {
@@ -949,21 +946,21 @@ void lru_cache_disable(void)
 	 *
 	 * Since v5.1 kernel, synchronize_rcu() is guaranteed to wait on
 	 * preempt_disable() regions of code. So any CPU which sees
 	 * lru_disable_count = 0 will have exited the critical
 	 * section when synchronize_rcu() returns.
 	 */
 	synchronize_rcu_expedited();
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_mm_drain();
+	lru_add_mm_drain(smp_processor_id());
 	invalidate_bh_lrus_cpu();
 #endif
 }
 
 /**
  * folios_put_refs - Reduce the reference count on a batch of folios.
  * @folios: The folios.
  * @refs: The number of refs to subtract from each folio.
  *
  * Like folio_put(), but for a batch of folios.  This is more efficient
@@ -1156,23 +1153,31 @@ static const struct ctl_table swap_sysctl_table[] = {
 		.extra2		= (void *)&page_cluster_max,
 	}
 };
 
 /*
  * Perform any setup for the swap system
  */
 void __init swap_setup(void)
 {
 	unsigned long megs = PAGES_TO_MB(totalram_pages());
+	unsigned int cpu;
 
 	/* Use a smaller cluster for small-memory machines */
 	if (megs < 16)
 		page_cluster = 2;
 	else
 		page_cluster = 3;
 	/*
 	 * Right now other parts of the system means that we
 	 * _really_ don't want to cluster much more
 	 */
 
 	register_sysctl_init("vm", swap_sysctl_table);
+
+	for_each_possible_cpu(cpu) {
+		struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
+
+		pw_lock_init(&fbatches->lock);
+		pw_lock_init(&fbatches->lock_irq);
+	}
 }
-- 
2.54.0


