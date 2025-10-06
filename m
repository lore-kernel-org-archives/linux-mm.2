Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103EFCCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 20:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C8D8E0021; Mon,  6 Oct 2025 16:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62CB28E0002; Mon,  6 Oct 2025 16:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C528E0021; Mon,  6 Oct 2025 16:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3AF908E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 16:03:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D87AC1A06BE
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:11 +0000 (UTC)
X-FDA: 83968763382.23.9D4AA33
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0749EC000A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 20:03:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nc0H1tMr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759780990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/FfTKpzDhNY44hq6VBsPjCO9xlzMvi5CioCxjggBxGo=;
	b=yNVlSE7WFxxz11JmOBMplll6DwCK8BUvBXZQHtw/E1A4Cg3q2+Ei6KXGv7ZM6piixHSlin
	LWXNueRHQWf4tmwJgLgCqRB3WmDzIqb0Q6EVQX0PSkBp50OS9sLx/fJSfD8nh+7T7dBDLP
	c9x1HUrn+rxVgOnAAP8uwtPr/zRS3XE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759780990; a=rsa-sha256;
	cv=none;
	b=01AFbOKOkO4CHUZcBWGQvwDSdnDcDgh4u7MrTYyogWhwVxeck9BDHjICTnHDirlJrdiWNg
	Y+fFHga8KCo0zlS2RShsNbDMs2e+xB5FUsplnGTwSffKk9zY73PKbgdzJ395erx1aobkjl
	DsONKkjNG2wdYPR0cCn57L7cj/0xQjQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nc0H1tMr;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3369dcfef12so5992471a91.2
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 13:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759780988; x=1760385788; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/FfTKpzDhNY44hq6VBsPjCO9xlzMvi5CioCxjggBxGo=;
        b=nc0H1tMrGM5lGttEOlmA9xmYNG41fcB/Zpd1uwYlVzvDI6K7hJxk4aJgE11A5DEYID
         U3ldU6Mo4N2NHZEE/WpLMvR8KY1poGi4xC0fm6V91GP0I9bpUJu19/L6305MloPltZ+f
         inI0m93QL0RjI6qiIDXjTl4kmZBx5TV/QJ+Dhg/ji0WzaXDP196gTWyfNVB/cv5oePyw
         syGJw7JXy4qouQjVTYI7HNLJ1LpUCitw8gnTk5Mr4qIX6fLZ+81AyVNB/aFXfd89vzZ7
         enMJ+EyRAK7uv6+GPeDxUMuMKhlGOcKDThYL/5JZWi7LfPTkt2/z9mxNeyOOqDMc2cKN
         gRug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759780988; x=1760385788;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/FfTKpzDhNY44hq6VBsPjCO9xlzMvi5CioCxjggBxGo=;
        b=psZl4CnoGeXlujo3ztO/vTzeikq9OjKnOnp5nQdIRVa8H0xM0dMassAtKvUuKcEGb7
         Zx1jWWF1YMcbeWUfdXQxmNb7EgWNjpcrEZ8+gHSiOE/At0JUG0dC9c3EnDtf72LRhYII
         Isg3TCZFBwRfjZhePWSQsdW3rNSu8t6jxEDcZvccuug8EkQSSj2v95nrUDmzIwTXwj9w
         Hdlk0Qh+FCCKReeu0cL/CETwrRKi7Wq3Z4DZj9z31anXj75VoUP1R8fmYc3I3NKzXiyN
         qZX4bfiWBGSkYxE1NpuBtMG2EbZ5xTd14HnO/lSOL9dJt8Ig2+7QVZ8E4tIAixTUUZvB
         gIyQ==
X-Gm-Message-State: AOJu0YweShARcyDUoWAcCfGVsUy5Q7/eRlbGzepszcdcf36uI9P9eRiT
	MKS2qNCO+mLfeKIHjCMlM+7Z8lGZuhmU5QFjEH1bpVyc/mnTr5KHHuyOnsSzgQg/
X-Gm-Gg: ASbGncvmzJAa/VaMgzC7y3p0H8Ow9ctaDNeZtol+lgQof7dgmI84KVANngXEu+EywBi
	6W8bWh4wvAhk1d+FQF9dnnM+dljjZ6EVfbGUxHUeP4l8FuYuUx9qnw0Oo69e/yQu/xz5KRB3cHk
	Eo+g2JL7NYfwse7jXQcsN04cmFTsi5o5VLcXIthf9kNBY6KfYWneTJzNLKfL6iyA7KcZStPmVRf
	Hn3fdCpq07/wMAFpEX+KtOJxL+ZWsi8nG7pyLTpwanmsszlFusarlsknsHpIbTDG7G+lvamLAK0
	n/wvEigO3Ys6l8ENnTjhY04X4RzXURPkCwNxiAgXbByKMJ43RNtMdLP11a4qOrKd+vYrt7V6KEd
	Txb26gcHx2jb01+77VMkrEmDeKwf+pMr0HAkE1fOglTYho2s4XnRSgADEryWZqjg=
X-Google-Smtp-Source: AGHT+IGKgvoWh2AlA1gEXZJS741XwWofagS2eT43KDPpL42IYIXONw/GpTUsn2xjQoYVEGK0eUrkbg==
X-Received: by 2002:a17:90b:5807:b0:339:dcc3:82ca with SMTP id 98e67ed59e1d1-339dcc38971mr8109209a91.6.1759780988397;
        Mon, 06 Oct 2025 13:03:08 -0700 (PDT)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339ee0ba20asm163148a91.4.2025.10.06.13.03.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 13:03:07 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 07 Oct 2025 04:02:33 +0800
Subject: [PATCH 1/4] mm, swap: do not perform synchronous discard during
 allocation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251007-swap-clean-after-swap-table-p1-v1-1-74860ef8ba74@tencent.com>
References: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
In-Reply-To: <20251007-swap-clean-after-swap-table-p1-v1-0-74860ef8ba74@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Ying Huang <ying.huang@linux.alibaba.com>, Kairui Song <ryncsn@gmail.com>, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0749EC000A
X-Rspamd-Server: rspam02
X-Stat-Signature: 6fq84e933q1kk6qbjriewu18pzbxa464
X-HE-Tag: 1759780989-872610
X-HE-Meta: U2FsdGVkX1/q4PbuKfkXQXBGfNmmKgAdO+i0fWntldcJdg9h405NZzJ4xEuvJoQm/CIdw0cfNjIvrRWNU2PdP9hXh3gUdHrqzlhJitDHWJHel0SQI+6IqSLqdbf/+yQM/i4wxMunlBNIBwLK3Osy1xrV+nzfpV/fq+O79omAVSje4LJIUdhg30x/9a5DIoGNmhO5Ww3o/Y5xL4Lj9fFJ4il/5me2GhpoPh2BB8fx8dUGCWV5V0EBXiMK3J97bEg15Iys8NXKsev6OrGrAEUVeacxatnjKK8gItYnd/3Fc1xhQfl/YG8ii7sY/DkKHQ0JQ0cEq1+kxM0E/B6vDRpq/DIhZVmDEpnR00z8WR3vXVoVMXYZb8//yoexkdcP1lNKDH8fkeqlFE3YcgPQH0Tg7cU9IVXRAuon03YVlzIYebPrj8ut7YFzSMSZqoO/UM6iqsrSu1fj38i3Li05kMK6bKGUaq0GL9CNOORrBSh5QNn8x9AQBDPd8Tx4wUh/g2Rb5JsYWnVpu0BO0gtUG3k/R5CWa6ECZHG/xN6ySDI/BJ3ZRZ4i4b2F3beekKJIGeah99GD/EWBq7GJRfzIMTJWm0usxv7G/gke5br0xTJA8lP70tVsJL/ijvoXy5BDyqqssFQ6FyZCeitAriVPwV8ChVGyleE2b9amUX39j7Wm3Gj6VgonMC9k8KY1+Pvsugok2PjN7ZC39g+Z8oGA9NjuNtfGG/Cl6JVidtzA7yH4nFM49QH2buJUD3GoMSgHVQUoUA9xs7F0PVS/wPdFtdXM5lPxlqBguHiJp5rUocy1yuoQV7W9NuGxeyo0jqXvccO6TGejmrdzGZ+l0hnWDVsLB2ChrUegkxEOhglVAGPpmDg7bU5Kz9jLd+FCHq9n/iF0Ugh8WPYjJfk1Pdj+Ve6OEPbEcqL8ESbrtaXZUGzGdSI+det9vdlYn5eqXSmd1uUvc7b7mvUGlmYkuhPTxG7
 Zbx38ppa
 X9+mABnzzRaP+pjBLpLwK7rxvXMk0IJZMw0kNqSHgW3/cB6JrLniUu6MLunuUa239RvNzEd/qJE7J8SMz4XVE7kVRdeUnQB4wyEwuGx+fCTvORsoPcrW5vszZFrPpoTgYcMy55pyUfRAlw1iV+r385g4GghUNJE+Cp5+uzLZDBywHYjnWCavMlLN+0sqq57orrZa1RQz2wSa1Q1uiA4RrjjpjqShFw9ulBQmmORvIYYedOVMswtSStwipY2vukQLbznDpK/PO8eFeKjEscGGtf38LHfWOlDefxwaRlcaYqeyIMkttXKnt5rMQ2LBhGGarv37nZ3zXNUpoSFu9TaoMrvgaWd/ZVLX9Vjq/mBPmBYiUrb61Jra4Vb932Jyo752ngBw5EH0wl9Okrhd8hZvEApx0TDrAtXWRZUU/+xcQDdE37uT325FOCUKY7ZPkQyZAOnN8sgH+NDC7B4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Since commit 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation
fast path"), swap allocation is protected by a local lock, which means
we can't do any sleeping calls during allocation.

However, the discard routine is not taken well care of. When the swap
allocator failed to find any usable cluster, it would look at the
pending discard cluster and try to issue some blocking discards. It may
not necessarily sleep, but the cond_resched at the bio layer indicates
this is wrong when combined with a local lock. And the bio GFP flag used
for discard bio is also wrong (not atomic).

It's arguable whether this synchronous discard is helpful at all. In
most cases, the async discard is good enough. And the swap allocator is
doing very differently at organizing the clusters since the recent
change, so it is very rare to see discard clusters piling up.

So far, no issues have been observed or reported with typical SSD setups
under months of high pressure. This issue was found during my code
review. But by hacking the kernel a bit: adding a mdelay(100) in the
async discard path, this issue will be observable with WARNING triggered
by the wrong GFP and cond_resched in the bio layer.

So let's fix this issue in a safe way: remove the synchronous discard in
the swap allocation path. And when order 0 is failing with all cluster
list drained on all swap devices, try to do a discard following the swap
device priority list. If any discards released some cluster, try the
allocation again. This way, we can still avoid OOM due to swap failure
if the hardware is very slow and memory pressure is extremely high.

Cc: <stable@vger.kernel.org>
Fixes: 1b7e90020eb77 ("mm, swap: use percpu cluster as allocation fast path")
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 40 +++++++++++++++++++++++++++++++++-------
 1 file changed, 33 insertions(+), 7 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cb2392ed8e0e..0d1924f6f495 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1101,13 +1101,6 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si, int o
 			goto done;
 	}
 
-	/*
-	 * We don't have free cluster but have some clusters in discarding,
-	 * do discard now and reclaim them.
-	 */
-	if ((si->flags & SWP_PAGE_DISCARD) && swap_do_scheduled_discard(si))
-		goto new_cluster;
-
 	if (order)
 		goto done;
 
@@ -1394,6 +1387,33 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 	return false;
 }
 
+/*
+ * Discard pending clusters in a synchronized way when under high pressure.
+ * Return: true if any cluster is discarded.
+ */
+static bool swap_sync_discard(void)
+{
+	bool ret = false;
+	int nid = numa_node_id();
+	struct swap_info_struct *si, *next;
+
+	spin_lock(&swap_avail_lock);
+	plist_for_each_entry_safe(si, next, &swap_avail_heads[nid], avail_lists[nid]) {
+		spin_unlock(&swap_avail_lock);
+		if (get_swap_device_info(si)) {
+			if (si->flags & SWP_PAGE_DISCARD)
+				ret = swap_do_scheduled_discard(si);
+			put_swap_device(si);
+		}
+		if (ret)
+			break;
+		spin_lock(&swap_avail_lock);
+	}
+	spin_unlock(&swap_avail_lock);
+
+	return ret;
+}
+
 /**
  * folio_alloc_swap - allocate swap space for a folio
  * @folio: folio we want to move to swap
@@ -1432,11 +1452,17 @@ int folio_alloc_swap(struct folio *folio, gfp_t gfp)
 		}
 	}
 
+again:
 	local_lock(&percpu_swap_cluster.lock);
 	if (!swap_alloc_fast(&entry, order))
 		swap_alloc_slow(&entry, order);
 	local_unlock(&percpu_swap_cluster.lock);
 
+	if (unlikely(!order && !entry.val)) {
+		if (swap_sync_discard())
+			goto again;
+	}
+
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
 	if (mem_cgroup_try_charge_swap(folio, entry))
 		goto out_free;

-- 
2.51.0


