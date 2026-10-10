Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91674CA9EBB
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 03:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C496B008A; Fri,  9 Oct 2026 23:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8636C6B008C; Fri,  9 Oct 2026 23:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779E16B009E; Fri,  9 Oct 2026 23:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 599836B008A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 23:00:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54A701206E2
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:00:51 +0000 (UTC)
X-FDA: 85305214302.16.5B54725
Received: from outboundhk.mxmail.xiaomi.com (outboundhk.mxmail.xiaomi.com [118.143.206.90])
	by imf18.hostedemail.com (Postfix) with ESMTP id 571CF1C0007
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 03:00:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of liyifan21@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=liyifan21@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791601249;
	b=VPPbfNApOVnvQrFs37TUNzlQn9Zt+LCNWxX0jIhTGPWBbubKIFK4ie34S1ONHd8D3vSX6J
	aQNUV+xNHzAdkuoIXnQAsE/Q17uN5sZDG8foRhDtHGRH5gH53f5mDt5NCNFbsDmfp+Jinh
	rRLFszCplFEDx+IrABY6bOk1dkKCdH0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of liyifan21@xiaomi.com designates 118.143.206.90 as permitted sender) smtp.mailfrom=liyifan21@xiaomi.com;
	dmarc=pass (policy=quarantine) header.from=xiaomi.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791601249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BImwAha5DCIAY6hyiEeQJuW6kCcRx7fiHQQK2KsLK/E=;
	b=Z3Shtbx9F5NG26UxCsZtokMCTdZ2z1XNRB1G1ntbbbWpSlNw5Yi7+GGAssFIK7qx8Day5W
	gac4lLIlMfQdyWG8V2Z5j5MLMR7y8OkqnJ6g6PpoVpjEB55eCusHEWoF+EtFwhb84KCSnm
	6Hahw5VRVCo/qbSPv7wkIFxRJbeqIN8=
X-CSE-ConnectionGUID: w+RxoyOnS+uT4AFwvlQEJw==
X-CSE-MsgGUID: rogxv7D+S7q6K7N6t81i4Q==
X-IronPort-AV: E=Sophos;i="6.27,149,1786982400"; 
   d="scan'208";a="165154808"
From: Yifan Li <liyifan21@xiaomi.com>
To: <akpm@linux-foundation.org>, <david@kernel.org>
CC: <linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Yifan Li <liyifan21@xiaomi.com>
Subject: [RFC PATCH 1/1] mm: page_frag: account page_frag pages in vmstat and meminfo
Date: Sat, 10 Oct 2026 10:59:40 +0800
Message-ID: <20261010025941.1253-2-liyifan21@xiaomi.com>
X-Mailer: git-send-email 2.46.0.windows.1
In-Reply-To: <20261010025941.1253-1-liyifan21@xiaomi.com>
References: <20261010025941.1253-1-liyifan21@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.237.8.164]
X-ClientProxiedBy: BJ-MBX02.mioffice.cn (10.237.8.122) To YZ-MBX01.mioffice.cn
 (10.237.88.121)
X-Stat-Signature: 8pghyfgsa1qzk5qrmsotccjejathpuji
X-Rspamd-Queue-Id: 571CF1C0007
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791601247-747060
X-HE-Meta: U2FsdGVkX1+x10jXd6q+t8yHTX4xptR5DZfAKYRAKMEO5HsL5GgEvfgt9N0ztqMJYeC7GHTaiqJ/yZxBzejGdwqFWyVRQ7tQhqMFOv9vJQr9OAVDPpm4VQN7/TTNUMl8dOgZdO+zQOq9lgTN58tD0QESLzT16t9C+Web3galtwvdsI7lug45Zb9Powz7rQdHtG1sBhCEdpxvwbCBuIiSoJAFSirYUqt3JbEXSaU+T/5zJrAPe18XxlUmp9XiiTSMX8vnXjkzYIWOOK7xqefI1adXfERunv+/xRAIM1yX72wVYfIwytUfONoirjcW/Ps6YDEpEoch+Qo9Ic1G1zyk9RgPBH2Hdlk/6C5TI0j34ia4msDdigmEHFdDOQH9vmQrAlsQkcVXGvk03bxiCK2sx6hZmdKq/AA1zwCPHGuCk3cBHqgNeSWgMPQdMwfrsEpHnXsJB/VUs+kt4hnktixA1SnplxIwgWkE2U6A+hayrzoAG32TP/AjgwMPr/owT5KmS08IXcmFifVprX6yPrWiG2TYp3vlRe2HeLPmRALHTVga8aLw4QhTeUpOGII+Siqxd733O0Fe3v3WwIo0YaIbzmQz40saF+m4Z/Bz15jc+oRfmIX2ZwrL0EUdtm4Yl+wmuFzISJSvrXJQUqqww6yN9xdcmDxJx8m3KmVZ6A3UVNEHj8V5CZD+ZSIAmPo6kfelfsqVAqpoKIx37xYu+8S3MgXEyQYl+/8n1dKx7IgL3/iK9Cc9D7odKnVgULtNkmi0eTyTsd9HrCmoZau/HHRLTsmvS4QHoQEuLruNgIIZCpXNFYkMvD3/RULg4cXGIIh8knQA4CxOak8i940oTrIqXstXvRlVlwF3VFZtBne9zcEnbe22TuEn60IxIMkBgL9IbMYVzlAospootgaE2r0/pt2uW7/0tguFZiusgNdSo9S1f61E/zLpJ4w74rblGRu/5oqpPLR73b+V0xhaH6y
 2iBzngnt
 7pJZsQRB/g+U5PEOjeokjpdJ7dppyekpvnjwthxmzjzmKWoWX0q5K0cTLAN/yEgKAvWJsez+1j+dHyNDqP0FrBMzvae85dPYc1jyvWE9CcSzfrS3CMNNpDcRZUjeSe33+cANkwBnajSf8voNDcqivEGlE0m02DwpYgvxQ4Mkj6ZA0G7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The page_frag allocator backs sk_buff->head and the frags portion of
skb_shared_info for the network stack and NIC drivers, but pages
obtained from it are not accounted by any memory statistics counter.
Unlike slab (NR_SLAB_*) or page_pool, page_frag pages are invisible
to tools that derive "LostRAM =3D MemTotal - (sum of accounted memory)",
which inflates LostRAM and makes memory diagnosis misleading.

Pages enter the cache through a single entry point,
__page_frag_cache_refill(), so account them there.  Decrement when the
cache page is freed via __page_frag_cache_drain() and page_frag_free().

Expose the counter, in pages, as "nr_page_frag" in /proc/vmstat and
"PageFrag" in /proc/meminfo so that page_frag memory is classified
instead of being counted as LostRAM.

Known limitation: a cache page handed over to an skb frags array is
released via put_page() (kfree_skb -> __skb_frag_unref ->
put_netmem -> put_page), bypassing page_frag_free(), so the counter
can over-count under network load.  Covering that open release path
requires marking the page and accounting at the common free path;
that will be posted separately for discussion.

Verified on an arm64 Android device with 4K pages: at boot, PageFrag
in /proc/meminfo reports 14432 kB, consistent with nr_page_frag
(3608 pages) in /proc/vmstat.

Signed-off-by: Yifan Li <liyifan21@xiaomi.com>
---
 fs/proc/meminfo.c      |  1 +
 include/linux/mmzone.h |  1 +
 mm/page_frag_cache.c   | 14 ++++++++++++--
 mm/vmstat.c            |  1 +
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index b2813ff13..73241c3a3 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -108,6 +108,7 @@ static int meminfo_proc_show(struct seq_file *m, void *=
v)
        show_val_kb(m, "Slab:           ", sreclaimable + sunreclaim);
        show_val_kb(m, "SReclaimable:   ", sreclaimable);
        show_val_kb(m, "SUnreclaim:     ", sunreclaim);
+       show_val_kb(m, "PageFrag:       ", global_node_page_state(NR_PAGE_F=
RAG));
        seq_printf(m, "KernelStack:    %8lu kB\n",
                   global_node_page_state(NR_KERNEL_STACK_KB));
 #ifdef CONFIG_SHADOW_CALL_STACK
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 94f9c3ff5..636f6ecb7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -333,6 +333,7 @@ enum node_stat_item {
        NR_KERNEL_FILE_PAGES,
        NR_GPU_ACTIVE,  /* Pages assigned to GPU objects */
        NR_GPU_RECLAIM, /* Pages in shrinkable GPU pools */
+       NR_PAGE_FRAG,
        NR_VM_NODE_STAT_ITEMS
 };

diff --git a/mm/page_frag_cache.c b/mm/page_frag_cache.c
index e63efe78b..4f768093c 100644
--- a/mm/page_frag_cache.c
+++ b/mm/page_frag_cache.c
@@ -18,6 +18,7 @@
 #include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/page_frag_cache.h>
+#include <linux/vmstat.h>
 #include "page_alloc.h"

 static unsigned long encoded_page_create(struct page *page, unsigned int o=
rder,
@@ -67,6 +68,9 @@ static struct page *__page_frag_cache_refill(struct page_=
frag_cache *nc,
        nc->encoded_page =3D page ?
                encoded_page_create(page, order, page_is_pfmemalloc(page)) =
: 0;

+       if (page)
+               mod_node_page_state(page_pgdat(page), NR_PAGE_FRAG,
+                                   1L << order);
        return page;
 }

@@ -85,8 +89,11 @@ void __page_frag_cache_drain(struct page *page, unsigned=
 int count)
 {
        VM_BUG_ON_PAGE(page_ref_count(page) =3D=3D 0, page);

-       if (page_ref_sub_and_test(page, count))
+       if (page_ref_sub_and_test(page, count)) {
+               mod_node_page_state(page_pgdat(page), NR_PAGE_FRAG,
+                                    -(1L << compound_order(page)));
                free_frozen_pages(page, compound_order(page));
+       }
 }
 EXPORT_SYMBOL(__page_frag_cache_drain);

@@ -165,7 +172,10 @@ void page_frag_free(void *addr)
 {
        struct page *page =3D virt_to_head_page(addr);

-       if (unlikely(put_page_testzero(page)))
+       if (unlikely(put_page_testzero(page))) {
+               mod_node_page_state(page_pgdat(page), NR_PAGE_FRAG,
+                                    -(1L << compound_order(page)));
                free_frozen_pages(page, compound_order(page));
+       }
 }
 EXPORT_SYMBOL(page_frag_free);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb5771453..883137cb6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1311,6 +1311,7 @@ const char * const vmstat_text[] =3D {
        [I(NR_KERNEL_FILE_PAGES)]               =3D "nr_kernel_file_pages",
        [I(NR_GPU_ACTIVE)]                      =3D "nr_gpu_active",
        [I(NR_GPU_RECLAIM)]                     =3D "nr_gpu_reclaim",
+       [I(NR_PAGE_FRAG)]                       =3D "nr_page_frag",
 #undef I

        /* system-wide enum vm_stat_item counters */
--
2.46.0.windows.1

#/******=B1=BE=D3=CA=BC=FE=BC=B0=C6=E4=B8=BD=BC=FE=BA=AC=D3=D0=D0=A1=C3=D7=
=B9=AB=CB=BE=B5=C4=B1=A3=C3=DC=D0=C5=CF=A2=A3=AC=BD=F6=CF=DE=D3=DA=B7=A2=CB=
=CD=B8=F8=C9=CF=C3=E6=B5=D8=D6=B7=D6=D0=C1=D0=B3=F6=B5=C4=B8=F6=C8=CB=BB=F2=
=C8=BA=D7=E9=A1=A3=BD=FB=D6=B9=C8=CE=BA=CE=C6=E4=CB=FB=C8=CB=D2=D4=C8=CE=BA=
=CE=D0=CE=CA=BD=CA=B9=D3=C3=A3=A8=B0=FC=C0=A8=B5=AB=B2=BB=CF=DE=D3=DA=C8=AB=
=B2=BF=BB=F2=B2=BF=B7=D6=B5=D8=D0=B9=C2=B6=A1=A2=B8=B4=D6=C6=A1=A2=BB=F2=C9=
=A2=B7=A2=A3=A9=B1=BE=D3=CA=BC=FE=D6=D0=B5=C4=D0=C5=CF=A2=A1=A3=C8=E7=B9=FB=
=C4=FA=B4=ED=CA=D5=C1=CB=B1=BE=D3=CA=BC=FE=A3=AC=C7=EB=C4=FA=C1=A2=BC=B4=B5=
=E7=BB=B0=BB=F2=D3=CA=BC=FE=CD=A8=D6=AA=B7=A2=BC=FE=C8=CB=B2=A2=C9=BE=B3=FD=
=B1=BE=D3=CA=BC=FE=A3=A1 This e-mail and its attachments contain confidenti=
al information from XIAOMI, which is intended only for the person or entity=
 whose address is listed above. Any use of the information contained herein=
 in any way (including, but not limited to, total or partial disclosure, re=
production, or dissemination) by persons other than the intended recipient(=
s) is prohibited. If you receive this e-mail in error, please notify the se=
nder by phone or email immediately and delete it!******/#

