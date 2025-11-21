Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BF4ACFA76B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 10:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA4F86B009B; Fri, 21 Nov 2025 05:09:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55216B009D; Fri, 21 Nov 2025 05:09:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49C86B009E; Fri, 21 Nov 2025 05:09:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C8726B009B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 05:09:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58DF613B349
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:08 +0000 (UTC)
X-FDA: 84134191176.21.207AC52
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 963DBA0010
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 10:09:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="jQr2/jIU";
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763719746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=wmVZ0hdQUiSeZOA6YtXICmmnsV2U7EroOaGH7l29sDw=;
	b=qlSBOjG5vND2qZIXqMEOBP1JlbJ1qSXmMso7SGzr7xahQT1w4Hz1pko3EOJn6SbRulo9og
	t9FVrk7nxvvB4I7oj/rGUhyz1PqEC32WPqTcBorSMwaQFrMpwvcqV/jyNZERQxhYZqp2Qs
	zfcXksWxxwMbgagi5Y/ZadrraQYBGV0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b="jQr2/jIU";
	spf=pass (imf25.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763719746; a=rsa-sha256;
	cv=none;
	b=rotrb3UkU5HgTekz75eq/WRBb1Ae/xzxTXyoQzbZlUt5b9+crQBpzAEBvLV9RFJT3Pg4Jr
	rzDQl/VKrK+OfdIGpq+6klL48uqwwJK9POSnwXHNa+J0GFtjPq+QB8ALd6gudH1yxjfPlw
	pwMDzu73FyF8UfP7VxjpJE5kA06KWm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B36B3440BC;
	Fri, 21 Nov 2025 10:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E6FC116C6;
	Fri, 21 Nov 2025 10:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763719745;
	bh=bLGLnubWua8dLgOuu2mSI/JmZC4fo/Mt3EtCz8fvpQM=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=jQr2/jIUiqoipzq92Pq218vpTHip49e/fJYVTutf/bNVtDjQSRtJwsAJ/wTCjj+/f
	 Khp4Vv8yIvC+aC7v66DbhomM15yOZM+qOSpE5qakUASqgUcJOg0YSn1Pnh6vmx4jzZ
	 PWQrfP6m3h//rTdsN3KnF12W0coEd/GiwF1jm+3U=
Subject: Patch "mm: workingset: move the stats flush into workingset_test_recent()" has been added to the 6.6-stable tree
To: akpm@linux-foundation.org,cerasuolodomenico@gmail.com,chrisl@kernel.org,corbet@lwn.net,ddstreet@ieee.org,greg@kroah.com,gregkh@linuxfoundation.org,gthelen@google.com,hannes@cmpxchg.org,ivan@cloudflare.com,lance.yang@linux.dev,leon.huangfu@shopee.com,linux-mm@kvack.org,lizefan.x@bytedance.com,longman@redhat.com,mhocko@kernel.org,mkoutny@suse.com,muchun.song@linux.dev,nphamcs@gmail.com,roman.gushchin@linux.dev,sashal@kernel.org,shakeelb@google.com,shy828301@gmail.com,sjenning@redhat.com,tj@kernel.org,vishal.moola@gmail.com,vitaly.wool@konsulko.com,weixugc@google.com,yosryahmed@google.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Fri, 21 Nov 2025 11:08:44 +0100
In-Reply-To: <20251103075135.20254-7-leon.huangfu@shopee.com>
Message-ID: <2025112144-panda-niece-ed1c@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 
X-Rspamd-Queue-Id: 963DBA0010
X-Stat-Signature: ajrhjjec49sfh5nrbjjqo7i73e5nodcb
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763719746-317159
X-HE-Meta: U2FsdGVkX1+MdW6RLTG0D5GxuuwHabJ2iztOb3HZcIN44cdzt+zku9ddciE7fKDJygAIDkH9q9Iv6RYmnTzcBCOnNYRAZba9yF50gyaq6Aw+3G+cEpisqjwH9VGbBVjGgB+Kw3eQ/nxJD+Z60F4rPWQA951wIaa40pSRmAeRwbbLurvpKDRd3m6sRQpJ08wvP1hCjmlHJ2WW9Fl+GctIFckghhQkx4Y1JyIUvIDQTbknO15suO1F60IBv26pTgO55sifJ0KUbDDLoM/FcXo0ADtp4IvM9eYC1PqBDTcEoj8XmDvxjk0dpbXbUZ5wn6Yzzhu0jqp/cmkQefgvGp8A9RJOM6GtmAGf10Hy+O8BWKYS6JAkhlb5s8sIxXp7CEj03jL0IB+4RfbKthOpHKvMK6YUmvPwX3wJ/fM+38VKQuOzBGDTHNv12FT1q13Uy1o8mEJJADjpq4t9ZDlozOGtv26V173c1bS/BQyK4c8Z5JvsMgPjmndSz0L/AZJHlb/pKwK6e98C4yXjSlPLEwsm23tKNhbdJhZE7h2WgMyY9X3saKza5DubuD/fJb24BPUJhXw/SiXEaCYKhRZ/vGmbIcqRf6Hw0QDkPLsbzdo5BRzYtGhbUXab3lrLJ4WK1++9WJoC1rEK0Kj1+WhDY5Q2v3j7+LjGvdPe6mHrZU0g4zK8zAirNuzmN7SXVzGS31oNttEzon/aGmWScf5iRKZohx97vHw8i2wbavYzycnjkIJGiLEjI3tqv5wNoibRQW3dH4mDyBcG87Z77YApNtmtIUpUQUu0Ac9dE8in/OnQ5keAvw5mrNd1zoutwQt6Jzw4/qW1Ne4kJ5QXRfmnFchIjSQmJYBZ/Rjb9wXCV1Imvs57Lvu2AOpbegwLzQKk/jXFx9JisYJMLlzatSXz34sbpkcuCUiVlrJUdkcjHi7DAoSy3F38CKIHtUMhOYeuOOo1yITuhbIafoXW8iXchGY
 zlkjd9Yq
 ZcYxaqSasdeS2VIU1jFbUtBDYMP/PJ5wPUH+/ekIuWgq2UBqS86UeR9lrvsPft5+re5MrKGr6mjLnvvF5wxUl3JNDZnQxr4AB3a+kzxykHz955Onp545k9cBMmiyVs10B1w0ACLJcnS6fupwJ6ho9agaEDOp6FNuXnhwGFx5hcPP5p9OLPc4BdCwTQMqQw1JgRD6jmIfWJOP6sFHJP9/HtXVUI5fCE35wGWmMCxY6LMnuR07phPRqXG+wy+3/0+MZcs4ZLO4RVayF+ZsNVMcRc8ME66t/SJosf/l5SeV1I4zfb5+AQcUFezVQ0AUws3Ip/4RfMZsBNvgyOFFxNG4GToHIqM/M2Jq8HpFRXS9J9mSxNhkm/OlvaNp/ZxG8+pwEjdDw2Nb0GRVmC+h5vqnfHlNRYQia6mXIB0YbDxa9baCCRleArjcOykDyLb7mudO0dMZzrzBcTethv7UuCEU0OixHCIhH+/ID1rZFWPsYIrg3QwO7ard2qBecLGT1oxwwqz3KPNZn8/NG51ZMu1OKGTw+wazvcF7GgXsCgC4VnsdBDMVNZDJ3WRqRyIvJKAnv5yLB/AmAfK8hCX2rlWefF+PytYwgAViH/oIPA+eUWVMRsLCdW1kSUqo29rnCVbfSIySUuaE1TwPO7ZabJtjdIowC2OIb/P+/sJcrn3OVbizTJ6RSHq7k2+HUTV4J0r4XUSPDz/hBd1Ijt19JbV8WzYpiYeJko3j9+YA5i60xjwGPK3KW+AgT6vSknToQE/+svcoo0m7uJnazO/jZHx+W9qxe6bl5kIdmsxZHMLvVEQvxcmPXsP+Gx4dfgQRgrcMBHYaaWcH+UXwwfbq2hwV5Z5mblABsVe6mz3bhQNcrOwHjQ24jsIcIcfzqc0EJOGHbnHkgN2ky2wmvZ59zytB6nHCHYOc1q/PCSWCfD5aAeZC6+GQfxccuuPStk+Hb5teZENs3/HNDquiSToFeI5rUvgsaj4lG
 /27d3hBJ
 PYQ7mrlvZiUIZvazwaLW0eG+wSBR5p5evJ3SBQWDm1+LT5C7JxRwIUUFKMhTxVLqt7ItXUiE+wDvbOKKCUM1Wx6El9HO5pHCWcWicrd4U6eI/QuisoCdA+Oz2LrfZ+uf7NQWTyUtVfCYkGcKd/JJGvS/OdZV80Bw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: workingset: move the stats flush into workingset_test_recent()

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From leon.huangfu@shopee.com Mon Nov  3 08:53:37 2025
From: Leon Huang Fu <leon.huangfu@shopee.com>
Date: Mon,  3 Nov 2025 15:51:34 +0800
Subject: mm: workingset: move the stats flush into workingset_test_recent()
To: stable@vger.kernel.org, greg@kroah.com
Cc: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, vitaly.wool@konsulko.com, lance.yang@linux.dev, leon.huangfu@shopee.com, shy828301@gmail.com, yosryahmed@google.com, sashal@kernel.org, vishal.moola@gmail.com, cerasuolodomenico@gmail.com, nphamcs@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Greg Thelen <gthelen@google.com>, Ivan Babrou <ivan@cloudflare.com>, Michal Koutny <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, Wei Xu <weixugc@google.com>
Message-ID: <20251103075135.20254-7-leon.huangfu@shopee.com>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit b006847222623ac3cda8589d15379eac86a2bcb7 ]

The workingset code flushes the stats in workingset_refault() to get
accurate stats of the eviction memcg.  In preparation for more scoped
flushed and passing the eviction memcg to the flush call, move the call to
workingset_test_recent() where we have a pointer to the eviction memcg.

The flush call is sleepable, and cannot be made in an rcu read section.
Hence, minimize the rcu read section by also moving it into
workingset_test_recent().  Furthermore, instead of holding the rcu read
lock throughout workingset_test_recent(), only hold it briefly to get a
ref on the eviction memcg.  This allows us to make the flush call after we
get the eviction memcg.

As for workingset_refault(), nothing else there appears to be protected by
rcu.  The memcg of the faulted folio (which is not necessarily the same as
the eviction memcg) is protected by the folio lock, which is held from all
callsites.  Add a VM_BUG_ON() to make sure this doesn't change from under
us.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/workingset.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -425,8 +425,16 @@ bool workingset_test_recent(void *shadow
 	struct pglist_data *pgdat;
 	unsigned long eviction;
 
-	if (lru_gen_enabled())
-		return lru_gen_test_recent(shadow, file, &eviction_lruvec, &eviction, workingset);
+	rcu_read_lock();
+
+	if (lru_gen_enabled()) {
+		bool recent = lru_gen_test_recent(shadow, file,
+				&eviction_lruvec, &eviction, workingset);
+
+		rcu_read_unlock();
+		return recent;
+	}
+
 
 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
@@ -448,8 +456,16 @@ bool workingset_test_recent(void *shadow
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_id(memcgid);
-	if (!mem_cgroup_disabled() && !eviction_memcg)
+	if (!mem_cgroup_disabled() &&
+	    (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))) {
+		rcu_read_unlock();
 		return false;
+	}
+
+	rcu_read_unlock();
+
+	/* Flush stats (and potentially sleep) outside the RCU read section */
+	mem_cgroup_flush_stats_ratelimited();
 
 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -493,6 +509,7 @@ bool workingset_test_recent(void *shadow
 		}
 	}
 
+	mem_cgroup_put(eviction_memcg);
 	return refault_distance <= workingset_size;
 }
 
@@ -519,19 +536,16 @@ void workingset_refault(struct folio *fo
 		return;
 	}
 
-	/* Flush stats (and potentially sleep) before holding RCU read lock */
-	mem_cgroup_flush_stats_ratelimited();
-
-	rcu_read_lock();
-
 	/*
 	 * The activation decision for this folio is made at the level
 	 * where the eviction occurred, as that is where the LRU order
 	 * during folio reclaim is being determined.
 	 *
 	 * However, the cgroup that will own the folio is the one that
-	 * is actually experiencing the refault event.
+	 * is actually experiencing the refault event. Make sure the folio is
+	 * locked to guarantee folio_memcg() stability throughout.
 	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
 	pgdat = folio_pgdat(folio);
@@ -540,7 +554,7 @@ void workingset_refault(struct folio *fo
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset))
-		goto out;
+		return;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -556,8 +570,6 @@ void workingset_refault(struct folio *fo
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
-out:
-	rcu_read_unlock();
 }
 
 /**


Patches currently in stable-queue which might be from leon.huangfu@shopee.com are

queue-6.6/mm-memcg-make-stats-flushing-threshold-per-memcg.patch
queue-6.6/mm-memcg-change-flush_next_time-to-flush_last_time.patch
queue-6.6/mm-memcg-restore-subtree-stats-flushing.patch
queue-6.6/mm-workingset-move-the-stats-flush-into-workingset_test_recent.patch
queue-6.6/mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim.patch
queue-6.6/mm-memcg-add-per-memcg-zswap-writeback-stat.patch
queue-6.6/mm-memcg-move-vmstats-structs-definition-above-flushing-code.patch

