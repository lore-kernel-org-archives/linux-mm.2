Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1DB8CFA76A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:08:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5456B007B; Fri, 21 Nov 2025 05:08:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CCB76B008C; Fri, 21 Nov 2025 05:08:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10A4E6B0092; Fri, 21 Nov 2025 05:08:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE18B6B007B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:08:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C0FB14054B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:48 +0000 (UTC)
X-FDA: 84134190336.26.5970AD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id F3AF918000B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:08:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="dJgAU7/N";
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=S55agL/PF08PBnon1JoZ3SuzkjdA1aIpmCxMytuSad4=;
	b=Yztvu2N2Yl8GeO6+VeCP4Tw7MqmnRilyJuNbHOb15BIBoBU98OgYUxwU++HmeW6U8KdgjI
	5s9wSicLGZLZ6Sd9jd+KGyjNmU+yiDpjVjwshTjAt5zolhR4vabaiRMCUthFKBkJcYyAoK
	6XC970P6Ju4jbLCJRBSt3xFrxAfuN9I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="dJgAU7/N";
	spf=pass (imf06.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719727; a=rsa-sha256;
	cv=none;
	b=2iIHys9Y1sIFmDcJiO8gXxlEV5d3Vs7LzsUD8KVFebuu31MeqcHmeXBl62EQIBVnFqpW6c
	k0xGRsWOXsejS4i9HHgvBxpeBAry1BrE32rdW8Vvr9hZmfojATTsJFRiKAdj3qOqgl/XxE
	393it/WCsyETXfSeua1k7QxX95IeOBQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4121C6022F;
	Fri, 21 Nov 2025 10:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FCCC4CEF1;
	Fri, 21 Nov 2025 10:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719726;
	bh=nb7u8oNvlb25iFamGjmqpr8vMAS3TPcFctTv5hhlGHs=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=dJgAU7/N9totIUrmY1B5BGcmKEPM1YjCaOthFjxTwwxmWB40W2im4ZO74yjFnWHqV
	 n/pym4jJkRJ+iqI/dUU73wp9Od49eZlNNEn7opEyQyOZEG4aMqm15dT8215K2ZncaS
	 eCcKDrmGe8+sxkJiWknzDG2SNVFyy8rudVjsjB4E=
Subject: Patch "mm: memcg: add per-memcg zswap writeback stat" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,bagasdotme@gmail.com,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,hannes@cmpxchg.org,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,mhocko@kernel.org,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shuah@kernel.org,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:43 +0100
In-Reply-To: <20251103075135.20254-3-leon.huangfu@shopee.com>
Message-ID: <2025112143-abruptly-plasma-2411@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3AF918000B
X-Stat-Signature: 5gy1pw1cebsawdndmwtzhs3r1wor5iqj
X-Rspam-User: 
X-HE-Tag: 1763719726-689139
X-HE-Meta: U2FsdGVkX1+8kGLPtuiO/6vIZPkL4JqGhTZQwXZ9vmK7p1LCDgFMv3HGCP2o7QMeDt5voBnBl1qE3OcnU05hPL9GpCB7it5SXM5HuydtcQtYxrLDAEp0llsajIcYitJ24cAxdIiD7lMqoSAH9fT4iD+nCRLqSdkPHUNsDpZUmFu72fk41O99gtiMPgF4VTqvQ8Z8zcuSWWyezQPlnzFnOmCQw25cbGwoV7B0X7khp8IhnjhF9BXsnRhVUroxjFv2E4YJTx3+b6pkAH8RJQLuuJxSBrcnRSQHmNbhO/++1rjoqMOkXL0jxyu4mmrROj/It4Y+l9P/CQBaXzVr94+HLhMn4snitEEx1+n+K5X1I99Tf8BBzPPZqeTV7BtG1hkWgszgsNdlqESh/5G/lLnVa3polsGhkWoYA8p37xrJKfK8lbjhsKzXoaKrwN2fYeuk7d7GbINyget9g4IdjT1NTDone1X8n3pCruQvD+zeWOGkk5EoFx+W9hNlI+MjgcAAWPcdwoIjaT33cD+sqrjPU72NN0D6ojmXsSIio0YLDJ/8Qz1Zi5qdgRIpvgrHOPIM98PRucuUBnak/u0Yn8w6x6CEHV3lYN3qO7NWnqcfxXRezlCgRbWBx2GxUgyhcht4uWlLmqzN5+KnHpLhJ6JEOJrXnsaFbfNXoyvHHuulWQgPflyOBpqE+DRIVEZH1BWq6rnPInv5eSBpDrJ6ryyNwtG3zm+3sRB3EV+y+0Per2Ql82zohJvUmNglfcAh5PDkbPVySMa6PLIAZ2qQW0aS1BW3qevQ07Q4KIcJtmqTkLUU3L8QkF9jnVy8ZfgDV9lGZilLgU8LFmCMx8nzf1sMTxoGDZhDxoWAVLpzHPg6v3+De4he72PsyGmvZlw/vm3JDUmDjeezQkNEdm1zpNLMFeZKu8Ix7iIbl7EfB3FvjipjL0kLm1jASrMew2Gc+LUPGlBkkA0ExxfYX+S2s+n
 xgW8IX8v
 fdnzlxlJFB8ixR0Gl6iKA5xvhpR3uazPzvWmsfQT91saUY1fsaLpUtoJZjvvMnc7X/ZUKl7ISNZHbZVuqzC0+lNVqvQcOWilz6Kr2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: memcg: add per-memcg zswap writeback stat

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-memcg-add-per-memcg-zswap-writeback-stat.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:08 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:30 +0800
Subject: mm: memcg: add per-memcg zswap writeback stat
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Bagas Sanjaya <bagasdotme@gmail.com>, Chris Li <chrisl@kernel.org>, Shuah Khan <shuah@kernel.org>
Message-ID: <20251103075135.20254-3-leon.huangfu@shopee.com>

From: Domenico Cerasuolo <cerasuolodomenico@gmail.com>

[ Upstream commit 7108cc3f765cafd48a6a35f8add140beaecfa75b ]

Since zswap now writes back pages from memcg-specific LRUs, we now need a
new stat to show writebacks count for each memcg.

[nphamcs@gmail.com: rename ZSWP_WB to ZSWPWB]
  Link: https://lkml.kernel.org/r/20231205193307.2432803-1-nphamcs@gmail.com
Link: https://lkml.kernel.org/r/20231130194023.4102148-5-nphamcs@gmail.com
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Signed-off-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Signed-off-by: Nhat Pham <nphamcs@gmail.com>
Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/vm_event_item.h |    1 +
 mm/memcontrol.c               |    1 +
 mm/vmstat.c                   |    1 +
 mm/zswap.c                    |    4 ++++
 4 files changed, 7 insertions(+)

--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -145,6 +145,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PS
 #ifdef CONFIG_ZSWAP
 		ZSWPIN,
 		ZSWPOUT,
+		ZSWPWB,
 #endif
 #ifdef CONFIG_X86
 		DIRECT_MAP_LEVEL2_SPLIT,
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -700,6 +700,7 @@ static const unsigned int memcg_vm_event
 #if defined(CONFIG_MEMCG_KMEM) && defined(CONFIG_ZSWAP)
 	ZSWPIN,
 	ZSWPOUT,
+	ZSWPWB,
 #endif
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 	THP_FAULT_ALLOC,
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1397,6 +1397,7 @@ const char * const vmstat_text[] = {
 #ifdef CONFIG_ZSWAP
 	"zswpin",
 	"zswpout",
+	"zswpwb",
 #endif
 #ifdef CONFIG_X86
 	"direct_map_level2_splits",
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -674,6 +674,10 @@ static int zswap_reclaim_entry(struct zs
 		goto put_unlock;
 	}
 
+	if (entry->objcg)
+		count_objcg_event(entry->objcg, ZSWPWB);
+
+	count_vm_event(ZSWPWB);
 	/*
 	 * Writeback started successfully, the page now belongs to the
 	 * swapcache. Drop the entry from zswap - unless invalidate already


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

