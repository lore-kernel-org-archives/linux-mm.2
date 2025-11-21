Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4408CFA76A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159ED6B008C; Fri, 21 Nov 2025 05:08:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 131846B0092; Fri, 21 Nov 2025 05:08:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047526B0095; Fri, 21 Nov 2025 05:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E55B06B008C
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:08:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 78477C04EE
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:56 +0000 (UTC)
X-FDA: 84134190672.01.E2F35C1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DDDCC1A0004
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=naN1QqHO;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719734; a=rsa-sha256;
	cv=none;
	b=DdedWnK+ELQr+wQIK8/PXfBHimUzmHByDITCn6dGpu40k47BIUtJ6cjfahNWnkySZfPOAG
	h/aRYo814ObIckhhyPq3ihdT5VLGZjkrJY1zf6Vlkcmmm9EkoVztU6Mbhll8Vk3ogg8FhV
	1Ld22U0jSxG2QdunTdWiDG6xVbnuAKc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=naN1QqHO;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf19.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=72ur9heQS2VahQ03F/6if6cBBxItg8Y4yvJpLtod8+g=;
	b=YJuBjycXVDiGWf1cUepYkBUnEZ55xxwwfeYsHdEgRPmKvW0+0bCjXA6vmKvj1aAdlGBqR6
	rYG/ETkp0kUKooUHgEVl7sk6u8qSerBSG2EOgRyhJfcOS9DTbfnrt0P//rvO3fC9WhUQOC
	kA60fakngalhTuKRPUDxbU/Zn4LEoKw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A05F6023B;
	Fri, 21 Nov 2025 10:08:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78118C113D0;
	Fri, 21 Nov 2025 10:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719734;
	bh=/4O75XRDp8O7RwbGHBVBhEBYFVjqE85gKdf6q0IBJeo=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=naN1QqHOOflHQuOh9cPl6PCOWkXuHJLOEvKmgPuhneK3EZ4WDz30g1l3gHSFb7CFE
	 uxIaD1oBEAHJYGRv+0JBLrANmxdYGvKFAVm8z/n1CPpgW8ujvss22VKdjgtVk91QoF
	 3D78JpPQK5SGvU+R4ltn118FN+8jgji5tQnEWwkY=
Subject: Patch "mm: memcg: add THP swap out info for anonymous reclaim" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,akpm@linux-foundation.orgL,cerasuolodomenico@gmail.com,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,hannes@cmpxchg.org,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,mhocko@kernel.org,mhocko@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,songmuchun@bytedance.com,tj@kernel.org,vernhao@tencent.com,vishal.moola@gmail.com,vitaly.wool@konsulko.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:43 +0100
In-Reply-To: <20251103075135.20254-2-leon.huangfu@shopee.com>
Message-ID: <2025112143-pull-ravioli-93d5@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: DDDCC1A0004
X-Rspamd-Server: rspam07
X-Stat-Signature: 9hdyf9151rcaqsof8ci6iwwn4o9y4mc6
X-Rspam-User: 
X-HE-Tag: 1763719734-745087
X-HE-Meta: U2FsdGVkX19S+4mUQD/urK+z6EdKaCoNpHmMC7Kp5sTAo6VfASDf5clDs9rszKdXgnpEcQJ0I6KcFnZkCry3fgzoXS5IrLDYzo78a3JFA9/F64nKT3WIIw7fxxbRAgrBAeiSxBBv+wtIJ5y+a1jaigExvueTnC+zeN/2W/ndb8mQaxE34mwewKb2f2QsOCblBfcsj1+jNFwl/ndDpvbGGd82d4uml1toCTdDdTsp7TMsSEYcuo1KlmQ+GcBLnBkqmfGOp81893Xslj/2uJ+0RDW7ODIevDbqkiWtJErb/Xtgyv5QtdI9+VDB/kIp8asBPuJYtzurNZRDnUM2Q7Ussjb1cZbL8lCtx5iohbYrj2S1WR0c3XnzGgziy6HRNf9OvmOqTMhfv2A+GeiwsujthFIldpKiDDbbhqRiuiDp5+D6/gqxq1bOUX5XGr8Cm/ZEikp7vqxpJCHikoBs1E/3MxjPAgV6bMwSDWaQ5v2P0D9OoUWWhnQCZGGOcIfwCEA0KqFShm6rDWmB5zUtatCLZFXENVXUG2SbnDC44gxASlMARNrY4xZA1HhIde6CvucrAwb5Qi3t2FpRUvyBp0LqvZFElN14mC5KJqrzqIZNyjsH4dk+sMzUI13rlGctG/GEa1XnHbMmE3qKysywqEwqlOQVEX2On/34X6/ScGfOcUZD3Gjk3S/W6bv7HaGpDgv6FQgi8MiCLIWyyo77k7273CbgHJMSVEeocg3qQrmtNqdUdeid3Nwh3Xi3P1h4fqfRcg0c1ff3XMq7QzIAWOdpM0UWP0VpQfhXoeWHXMFi1XntCq9yoG7JQa7aZVyGWN3x2FW7Wo4cAo6/KSFr4509VvXjX8tV1sD+C++659sWFZZxH/Mg9qLTJwmEDq7ofONY4l7+3MI4Q0/1FhcalX1+PW/T/mmOSRl4jkailjD5uIObkPJ8IRTNKX8qMPR0471sKL3h4KITPMsjBjhISmt
 Ktn9GM+d
 TuSuiHnkpIY5X8jadjkSHMWlVRFfiWWPaVXMsNvHVRZaIF8COOGV23VOFtJs/Uv3YOvNPcIp4aWm7VbYmtqvW+FkgKnw4DjLjNN4BE4nL7OOFU7OfBimxoWrTeNCr8Ed2PY5gQUUR7VS184OjX3My7ILsjV5rPXqxeaiug8knTqBS+CJMgcea8NfX1Fn5Dbtd4ouXPL0sQkJlhtGC52F894YyxJvJsH/rOb+syBo8t+xIwqFWTw5xDOM+mQTbKR/ZjQfB4iQk4p0r0dbyCmBOa1xsrN4hnuVMbpttMThZJSJ4WGT7S7Mhh4DgG7ywIyp+vAIKtQg56F9iXKKWRGpJP4oL1sUY4Q/B8jXGC8r4ZaDG6WEKBzkd4okABrnd1Ohvtzzyj9/WrCdCPJB1jttDovbbjED4uI9GxXAL5FvZPEl0SUDSBTjbqg47ueLjty1SJDa62q6ReV7ld5FM+UfcLnAn0I+pXF90XeSAXmmDNhfefHEKVL+rKgw+bZtt9R9PqcsiqwtXuZaVlTxWGUYgqWmG6jq3le9WT6Y2xpnLrRoq2GiXvsdLwQf0OjdrPHecS+CK2Njy81zHYrOrKX1EB2Wec9Kia2tbzfoIGUhTV/KWr9T7lSoRsNgl6hwicoUcpnHDuat57lvbz4sMB3rA3MgT5iIbJLJgbbXGpBFecKgI4vOeS/go23hGowHFyLOWf5vcfaFAa/zjveM1aaniRD2H+AuBOxKimKRGI/AQiZ5zDcbGdmr+dATFr8SsiXiMiF4tM6DQLwqpSs2cCApeWrEo12u4t4bcVg7/uJpPCVnDWTAui0liqGDZ0MY7koa10z82PSLDXJsWYnWCmfyjBaE1HRgQCtzk552+ZOp8Bwk6gpMoepETtXOKGUC9l30i/k2ZzucK7lQ/M/0tyt+LcZdf5BD6SaSUIM287JzcKvGXws+4RStwTdee/RLBwydCOTn2aMY4uVS4SB97emuIyCX12FOF
 NNY7Z2Qq
 bfK2GjZb24WUQOs2twgRaOqW+PivBEAAN5ApokNBU1hBzaRl7YNJSz2UP5a9AF5Bjtj38/ObHYugwyH006BqfOl+QvN9xv+hW845BTCzmi0eh/Y2RGiJGZS74iR7u6OJE5GaeNMNNWQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: add THP swap out info for anonymous reclaim

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:02 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:29 +0800
Subject: mm: memcg: add THP swap out info for anonymous reclaim
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Xin Hao <vernhao@tencent.com>, Michal Hocko <mhocko@suse.com>, Muchun Song <songmuchun@bytedance.com>
Message-ID: <20251103075135.20254-2-leon.huangfu@shopee.com>

From: Xin Hao <vernhao@tencent.com>

[ Upstream commit 811244a501b967b00fecb1ae906d5dc6329c91e0 ]

At present, we support per-memcg reclaim strategy, however we do not know
the number of transparent huge pages being reclaimed, as we know the
transparent huge pages need to be splited before reclaim them, and they
will bring some performance bottleneck effect.  for example, when two
memcg (A & B) are doing reclaim for anonymous pages at same time, and 'A'
memcg is reclaiming a large number of transparent huge pages, we can
better analyze that the performance bottleneck will be caused by 'A'
memcg.  therefore, in order to better analyze such problems, there add THP
swap out info for per-memcg.

[akpm@linux-foundation.orgL fix swap_writepage_fs(), per Johannes]
  Link: https://lkml.kernel.org/r/20230913213343.GB48476@cmpxchg.org
Link: https://lkml.kernel.org/r/20230913164938.16918-1-vernhao@tencent.com
Signed-off-by: Xin Hao <vernhao@tencent.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/admin-guide/cgroup-v2.rst |    9 +++++++++
 mm/memcontrol.c                         |    2 ++
 mm/page_io.c                            |    8 ++++----
 mm/vmscan.c                             |    1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1532,6 +1532,15 @@ PAGE_SIZE multiple when read back.
 		collapsing an existing range of pages. This counter is not
 		present when CONFIG_TRANSPARENT_HUGEPAGE is not set.
 
+	  thp_swpout (npn)
+		Number of transparent hugepages which are swapout in one piece
+		without splitting.
+
+	  thp_swpout_fallback (npn)
+		Number of transparent hugepages which were split before swapout.
+		Usually because failed to allocate some continuous swap space
+		for the huge page.
+
   memory.numa_stat
 	A read-only nested-keyed file which exists on non-root cgroups.
 
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -704,6 +704,8 @@ static const unsigned int memcg_vm_event
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
 	THP_COLLAPSE_ALLOC,
+	THP_SWPOUT,
+	THP_SWPOUT_FALLBACK,
 #endif
 };
 
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -208,8 +208,10 @@ int swap_writepage(struct page *page, st
 static inline void count_swpout_vm_event(struct folio *folio)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (unlikely(folio_test_pmd_mappable(folio)))
+	if (unlikely(folio_test_pmd_mappable(folio))) {
+		count_memcg_folio_events(folio, THP_SWPOUT, 1);
 		count_vm_event(THP_SWPOUT);
+	}
 #endif
 	count_vm_events(PSWPOUT, folio_nr_pages(folio));
 }
@@ -278,9 +280,6 @@ static void sio_write_complete(struct ki
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else {
-		for (p = 0; p < sio->pages; p++)
-			count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
 	}
 
 	for (p = 0; p < sio->pages; p++)
@@ -296,6 +295,7 @@ static void swap_writepage_fs(struct pag
 	struct file *swap_file = sis->swap_file;
 	loff_t pos = page_file_offset(page);
 
+	count_swpout_vm_event(page_folio(page));
 	set_page_writeback(page);
 	unlock_page(page);
 	if (wbc->swap_plug)
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1922,6 +1922,7 @@ retry:
 								folio_list))
 						goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
+					count_memcg_folio_events(folio, THP_SWPOUT_FALLBACK, 1);
 					count_vm_event(THP_SWPOUT_FALLBACK);
 #endif
 					if (!add_to_swap(folio))


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

