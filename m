Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B676F9D0FE
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 02:23:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E766B0093; Tue, 14 Apr 2026 22:23:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817126B0095; Tue, 14 Apr 2026 22:23:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72C0B6B0096; Tue, 14 Apr 2026 22:23:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63E196B0093
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 22:23:55 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04CA38B37C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:23:54 +0000 (UTC)
X-FDA: 84659194830.07.36EEECA
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54B70180002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 02:23:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C9jXmm00;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776219833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=AS7olroNFEXattkGrKD+rS7tU+zP8C4dXdnIq/RdScM=;
	b=0/xKt5RRuYlVHJsuj6nTdmg3qnvAKp0UQkXqBUQcANib8FSDvSqehcPkHyQPGcVwKseR44
	kpXCAnGIlNOYNSsPaS6BBMvne8umKtXhqWRrcb8K/1ICxmMQgvTkUdOH8F56+/YfxiBPeq
	mxz7RliesxfCKWYmwhQQtKB9LwVQDTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776219833; a=rsa-sha256;
	cv=none;
	b=AD0A1HNK5iuJi82Gk/mHlZP1dl2PBUdlV3EHcdiIgfwGLY2RW7TeQMy3mdEwBQ8Dx+XwRh
	oX0KH/q1YLRLanwUkLzOupncl7H8gZKa8/Iw1qbWUj1sDe7vb65fqiMuTCvwUNmiqdJfSj
	zBKv/k3IlenRxv2rY8fiuQkGHy3br/I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=C9jXmm00;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82f37c09352so2054602b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 19:23:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776219831; x=1776824631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AS7olroNFEXattkGrKD+rS7tU+zP8C4dXdnIq/RdScM=;
        b=C9jXmm00U9NNyk4D8CLHF2HclT8E4+FpK/TGBVIPV+hhDA7orhmfwXjSf8vd65oVfO
         PJ66GC65lHgjc6JFDQZ+ccpaL8LjdFFyWes+RESL6k+EO+ibOGLn1ZmK2LMiBEhQUljE
         sinyjVmChwqrr0vv3TBLlu/5SKG5DcGxtP+9le2x8wIlbfX+SCdQMTMRnL64w48H1JcS
         woxK5jZOcxL3YyxtVviXd9zUS9PX/Xp1+pBLY7ovShhsQN8c2/wo2MmzdyCRuvb/tnR+
         y06VhYg+jcyD/oZ9XbrKKJcb82Gi/LVV90InOIv097CUoalCrW5Ln9KWPkFwlg0Hrm0T
         fT3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776219831; x=1776824631;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS7olroNFEXattkGrKD+rS7tU+zP8C4dXdnIq/RdScM=;
        b=hVsWXwmc/TrMx3ncOz1YIo6ZwlgJC1M0PdvOh3zo8AHp1/sapSbqTFQ+DWQHhhdxNq
         Nca6q/qrjDN+dcuj9PRI/u46O1krnqDGLGWLdaH+LmpyqtTX9UuFB1zOzPooZPpFuxsG
         LgdbL3bGrUyVyt26IiPXkipSy9H4SEjpvEz8lGUVWI4Tt9oWNNSKSfTnPx2++gMskC2g
         UY9tyWmwWd6zQS+9/iKfROgVyP1sqRQ4MD9OwuKg7qOMbsC1L/9xJ2ETBdE81Qqc9hC5
         NRdMFGAoB7c1b9RG50eNhzyfRor50R4gPrFB6p5Qm5OUMw4uSdDyLCJ9451BpEgpsbbv
         NQqg==
X-Forwarded-Encrypted: i=1; AFNElJ+nhXMwSYTUPsrq9iF6Y0qKpuYhjnuqyyHcw187PPbZv8cmcfZf649cCcOBpmbuHzCXa3ATC+qUDw==@kvack.org
X-Gm-Message-State: AOJu0Yy0zaH9axQGUSFnNbsBeZwOS6yycTdCU3shr65+ZlViCsfmhOo3
	7KOXihouggqlm4AH+0C4wLvc1JFql7ZlboF6ajRe0P/ZuKSwPNjqXZREAhPOo6Gn3Ns=
X-Gm-Gg: AeBDieuCW0U3yvLQMvdNnxGmRqh5NG8C/CU1SAM0QhoX7XS6M1SFg6Qwr05mBhRE318
	MIbRmMHVvMlpCr+wSXcoBSuOp+uNR28cB2Mmri2YFAZxSYnoFe066ZnYrnzeVGgy/+6Ie81/6J5
	nqHwIebUGLPnw1A/azQ2OsOPrtCbxezhWfv9sYa/bZ4+XGT/WvmVx3eP5w5LmISMqpn8G2Z2hk/
	QYIOV0AVejevLwG/B65yMQlRRDJmIEFvYvgZyogD95y6w/uUvfvp937Q0uJTVUjyE5HZFDBDv2i
	TK7du8CnVHJq696uZ9LxVMusmkRAdsTrHBAtaDSsgDPNSz491+lwY3Uiu8EVri5gl1awfd7qTW7
	umdH6rljmqEeuLmOMlTyMFDeLELEQqIFYLWA1dbZn2gL4GXIkqlfx2cgYYEYFnM47knp/oH+1xn
	bC2RY7w+RKxw+8o/B4Fg==
X-Received: by 2002:a05:6a00:cc3:b0:81e:1b77:9e61 with SMTP id d2e1a72fcca58-82f0d379ba8mr16521188b3a.25.1776219830661;
        Tue, 14 Apr 2026 19:23:50 -0700 (PDT)
Received: from n232-176-004.byted.org ([240e:83:200::347])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f69ef0b34sm102517b3a.31.2026.04.14.19.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 19:23:50 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Muchun Song <muchun.song@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org
Subject: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
Date: Wed, 15 Apr 2026 10:23:26 +0800
Message-Id: <20260415022326.53218-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: bx1uxsba9nufpgcmw7b587bctxccezan
X-Rspamd-Queue-Id: 54B70180002
X-Rspam-User: 
X-HE-Tag: 1776219832-546334
X-HE-Meta: U2FsdGVkX1/KoUeppMrDQhIT/v4HRAMap7wHA7YykvZMU3VINlHt35/rdtOX5SY3J9MyjD6gYZvM3LoHC0tZnw5rvON8jMnE4dwOIcp782VwM4AgE/pLoBafn7iQq4oZ1V2W8931Ev8uFmXCm1Mle1dwFzXbpEyOma7AWFVm1FLBTeon8kuNWHFA8W5wCe/nHTxtNKQrpuVtOAOjaUJ5iv0HCkWluwjOcFcpj7y4YqAvs21M1CVNP+fNplTxwsYalAXlfLdtuxt5o/Qs8ZlZqurbanA/BPNqVBALi+QG8L3HhcTQetdobSmI53+JEGjD9dnkf9gmhu8CbZRTf7cpY3KlG2NP9/zZHrPjaJJLTXb0KK6Q1kiJLRqxygLXSLGFX3TMTIZhtOoWynH9g/AOdB4T7rGCjpT4m0yavSJYKwlcVdIij444OiBegg/kz5JzUhKuO3d/EXIxsH0k0+fJe0drgOVPz7qUCHrxKWorVgsv5hG7xZH4RUDWnBnLBGMwwhhvB3TEaHWtQ5eKlqYflYierZ2fvN/YrlNI5j3ehRQC89OBChMx8/sEdI4oPA9mRg8fvelhha/8t7VHyhBwV1VM8M4+FL+2i0jrv7rV9sYrEnWiNsn0r8g58MgiwuDv0v07o1CyzreUEVC2moulaN6+yprES1E38OB4on9FRBF5oDasSp5exztYfkEGyEUAkqjhwLZTwODREgeZE+wSEgwJzdZwaqq0iybLy4tIMo+SFpqK9+RcfqmWjbA4Iq7zvqIYBfQznfDnGLDMpv9cPTyMiYboly+Tl9US5ZK+d6Zf195IMYqrLPpUOQIKoIPU25CZcakcjOENtOzLfMUoO/3eO7SbsfLSQJueP+ZaNEVtxbUYGppRsH04Ddmd+lUvx2O2Yfsd47Lb4N0TLSQKcQfkUibj+673kC7GVxrlictSSb4H5Rln3cjZnXLZlMX9v4KCxS0CWR2DXJ6jcRv
 rwfDkxuf
 SYusrHS0yV2v6SJfP/QMFDab+KGkvdsbi2H06ae7RBksSKFbr0vpvTS5FHsn5Z49+yBExvVqjsDSog8jf8XzpCVi6BLd95IiqwX+apTRliMBfCS1O/V7ZWccQhLlalQi1gUcWebK/4LtkCA8Q0b1TovcftJVrk3cjWs4FuWhySXMggg4iaE0Jt+vCEvkOCe1Fl9x2ByiSLyjZLMlfm1o6A7JAWfyrGuephUUa2ut/7hjova5ZhHnZYbiisq8+a6tNZwJe6lSfk4t/0lRRbY/9xik3nCwst14GN00rLiycPLjNIugxMG9ZBRbtvi8nMvcJBLh9tuDhzQ35TCk/gPWzkHD3Ghbsl68s1f+hPraGf+3TB9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory is hot-removed, section_deactivate() can tear down
mem_section->usage while concurrent pfn walkers still inspect the
subsection map via pfn_section_valid() or pfn_section_first_valid().

After commit 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing
memory_section->usage") converted the teardown to an RCU-based
scheme, the code still relies on SECTION_HAS_MEM_MAP becoming visible
to readers before ms->usage is cleared and queued for freeing.

That ordering is not guaranteed. section_deactivate() can clear
ms->usage and queue kfree_rcu() before another CPU observes the
SECTION_HAS_MEM_MAP clear. A concurrent pfn walker can therefore see
valid_section() return true, enter its sched-RCU read-side critical
section after kfree_rcu() has already been queued, and then dereference
a stale ms->usage pointer.

And pfn_to_online_page() can call pfn_section_valid() without its
own sched-RCU read-side critical section, which has similar problem.

The race looks like this:

  compact_zone()                    memunmap_pages
  ==============                    ==============
                                    __remove_pages()->
                                      sparse_remove_section()->
                                        section_deactivate():
                                          a) [ Clear SECTION_HAS_MEM_MAP
                                               is reordered to b) ]
                                          kfree_rcu(ms->usage)
      __pageblock_pfn_to_page
         ......
          pfn_valid():
            rcu_read_lock_sched()
            valid_section() // return true
            pfn_section_valid()
              [Access ms->usage which is UAF]
                                          WRITE_ONCE(ms->usage, NULL)
            rcu_read_unlock_sched()       b) Clear SECTION_HAS_MEM_MAP

Fix this by using rcu_replace_pointer() when clearing ms->usage in
section_deactivate(), then it does not rely on the order of clearing
of SECTION_HAS_MEM_MAP.

Fixes: 5ec8e8ea8b77 ("mm/sparsemem: fix race in accessing memory_section->usage")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
This patch is focused on the ms->usage lifetime race only.

One open question is the interaction between pfn_to_online_page() and
vmemmap teardown during memory hot-remove.

Could pfn_to_online_page() still hand out a stale struct page here?

The new sched-RCU critical section ends before pfn_to_page(pfn), but
section_deactivate() can still tear the vmemmap down immediately afterwards:

mm/sparse-vmemmap.c:section_deactivate()
    ms->section_mem_map &= ~SECTION_HAS_MEM_MAP;
    usage = rcu_replace_pointer(ms->usage, NULL, true);
    kfree_rcu(usage, rcu);
    depopulate_section_memmap(...);

That looks like a reader can observe valid = true, drop sched-RCU, race with
section_deactivate(), and then execute pfn_to_page(pfn) after the backing
vmemmap was depopulated.

Callers such as mm/compaction.c:__reset_isolation_pfn(),
mm/page_idle.c:page_idle_get_folio(), and fs/proc/kcore.c:read_kcore_iter()
dereference the returned page immediately, and they do not appear to hold
get_online_mems() across the pfn_to_online_page() call.

I am not fully sure whether that reasoning is correct, or whether current
callers are expected to rely on additional hotplug serialization instead.
Comments on whether this is a real issue, and how the vmemmap lifetime is
expected to be handled here, would be very helpful.
---
 include/linux/mmzone.h | 6 +++---
 mm/memory_hotplug.c    | 6 +++++-
 mm/sparse-vmemmap.c    | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 238bf2d35a54..0e850924cbeb 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2014,7 +2014,7 @@ struct mem_section {
 	 */
 	unsigned long section_mem_map;
 
-	struct mem_section_usage *usage;
+	struct mem_section_usage __rcu *usage;
 #ifdef CONFIG_PAGE_EXTENSION
 	/*
 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
@@ -2178,14 +2178,14 @@ static inline int subsection_map_index(unsigned long pfn)
 static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 {
 	int idx = subsection_map_index(pfn);
-	struct mem_section_usage *usage = READ_ONCE(ms->usage);
+	struct mem_section_usage *usage = rcu_dereference_sched(ms->usage);
 
 	return usage ? test_bit(idx, usage->subsection_map) : 0;
 }
 
 static inline bool pfn_section_first_valid(struct mem_section *ms, unsigned long *pfn)
 {
-	struct mem_section_usage *usage = READ_ONCE(ms->usage);
+	struct mem_section_usage *usage = rcu_dereference_sched(ms->usage);
 	int idx = subsection_map_index(*pfn);
 	unsigned long bit;
 
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0c1d3df3a296..335835abe74c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -340,6 +340,7 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	unsigned long nr = pfn_to_section_nr(pfn);
 	struct dev_pagemap *pgmap;
 	struct mem_section *ms;
+	bool valid;
 
 	if (nr >= NR_MEM_SECTIONS)
 		return NULL;
@@ -355,7 +356,10 @@ struct page *pfn_to_online_page(unsigned long pfn)
 	if (IS_ENABLED(CONFIG_HAVE_ARCH_PFN_VALID) && !pfn_valid(pfn))
 		return NULL;
 
-	if (!pfn_section_valid(ms, pfn))
+	rcu_read_lock_sched();
+	valid = pfn_section_valid(ms, pfn);
+	rcu_read_unlock_sched();
+	if (!valid)
 		return NULL;
 
 	if (!online_device_section(ms))
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 717ac953bba2..05f68dcec0f8 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -601,8 +601,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 		 * was allocated during boot.
 		 */
 		if (!PageReserved(virt_to_page(ms->usage))) {
-			kfree_rcu(ms->usage, rcu);
-			WRITE_ONCE(ms->usage, NULL);
+			struct mem_section_usage *usage;
+
+			usage = rcu_replace_pointer(ms->usage, NULL, true);
+			kfree_rcu(usage, rcu);
 		}
 		memmap = pfn_to_page(SECTION_ALIGN_DOWN(pfn));
 	}
-- 
2.20.1


