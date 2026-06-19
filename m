Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF28DCD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 22:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BFEE6B0005; Fri, 19 Jun 2026 18:42:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 971CF6B008A; Fri, 19 Jun 2026 18:42:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 838916B008C; Fri, 19 Jun 2026 18:42:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5EB6B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:42:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99E921C503E
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:42:29 +0000 (UTC)
X-FDA: 84898137618.17.EEC8D15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F2435120007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 22:42:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/9mIQBV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781908948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iEPjuS56y9/6ULrSzJIMlwCS/iaIgzQsHGFX0c4iqaA=;
	b=lH+kV1p+NQ5dBg9ZZQnBFMcSJgFf4a3VOnfnkPnox+smVWnZR/1uvJxCtcrUAvBeGNhfBO
	qY/9IfAqRQ50cTx/wzlVlGtoX0qw21N7x8PO6RhOyaHuatChOrOOebu6Bmk7ZaQ/gaaORm
	eSg8yFzl4Sh1LvGgz+A2kYndk3wz3hc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781908948;
	b=CyIlug4zYFKzy20GlcgcXrMucju6jSWPsRzroTSeP7lhYnlUhg85WZSGgtX3Qa03AqJ3+y
	yaauR4ra53gjkcCJ1luvxZWygiPxcYJeL1i9pIAj6tsRBfkVNw4PcH8iQKfi7nZBZNjhAS
	zQKT7EkhIPZeVuaq1wqIi0VYiffXMAM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="O/9mIQBV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 49915600AE;
	Fri, 19 Jun 2026 22:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C961F000E9;
	Fri, 19 Jun 2026 22:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781908947;
	bh=iEPjuS56y9/6ULrSzJIMlwCS/iaIgzQsHGFX0c4iqaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/9mIQBVlfkEpaaANOpQqnGO5o+dSuFub4DPs+hSI/YJVqE91aiCjJzd/5rA4AaB3
	 DytMv0UHYcPNeiSandIR2Knqnwx7I13J22NxSbRhoLq90jZGmxjh6LlbDPHO69Jrn9
	 OOmO9k9tKiaDgCbkSphrKSJH1vmK0EK6s2P/FlmyOm1owy4uLFz6IGIL9RdihihJTP
	 Kp/V8KC5YOyZzyNZFAkg8JU7LVy0T8ciqvkag/zdioOFnw9pf7dCTNuupC5PbQVsVS
	 8cYTS0qLWCnAxsmDw+eR8jcfAQNQ5TO0RoIe8WKUqtpKS4cbWt1hHOUpL/4BQD2cH8
	 o5D8hgrcPgtVQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: ryncsn@gmail.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	qi.zheng@linux.dev,
	ryan.roberts@arm.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhaonanzhe@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
Date: Sat, 20 Jun 2026 06:42:21 +0800
Message-Id: <20260619224221.85678-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAMgjq7Bmi2XYxPc4tVO8KTWSuj8jpt-c-JueqYRK1kLC_nmBqA@mail.gmail.com>
References: <CAMgjq7Bmi2XYxPc4tVO8KTWSuj8jpt-c-JueqYRK1kLC_nmBqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F2435120007
X-Stat-Signature: ci1uwjn8ociuogj7jnem1ysixjpdncsb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781908947-150042
X-HE-Meta: U2FsdGVkX1/UGQJ1c7cNOQC8sZXTkrGsqz+BxfVkqmkEwi2cl2mo02H7AuHm2MKYhY851hW2bSDfprq4aMrrIKg0gj+72w2Ih54hcAiH1ZLcrpy4FL1W0dIU/eG07FHGzFLnw/9T4A1hng+8JPcjzCB+EA16kDb0LoLSVu8ck0vrEOpElw4pz1DrnapOSmR/b5Za+bP6XdQ+I+7xs8QDJWX3I40jUra8cIAXQlsrCEp7kYAbDqe7TxzsNsGo384zvvKrGF8EcK+0bYpzjfAYizkgF7fiGRDiw4zRTPYFopd0AYlaJLfgHRM28ghur6ZSGsw7ZXre0ne2iXMO4vOzhYjOBr2zJIMXCog+BRRa6ROlblTvUbtW3KW0b9VuAapWEs6UGg+3t/1p9J0TcRP74wuWi2m6MA5dg7V5hwwZ2prMY/A9HKm/1Ze+huDtXfIfgPv821d9FsUmGDaISJJagdKT5q9Umjv6gXHanUgNhjlltqFTxQI5oU27vvnkGS656INjp4EwZxIPMAjPFR8yd8em2QHN4gzoil/DSsMhX4bN+3qsql0F3ngw+4RSDs+BpIkVpp7CDW0fJ5AFVgBp05hrtIJUVqxXBW4XfMDpHGYd06Bm8JzkL7bCze+MXfNLgyAsLCENjXF44B388mSl+TVTK4c41/HzDK5rVyMDibomQ5gY7dewvoRlFKkM2Z1NSW8/ALvn9b7zw81T2pP4l7X+z7XepkCoLnxhIFzIXDWPdCwRrtQWTdVm8JCQDv/SJULCRNgiccn5fP5oxUnAP/9jffLkGf1M4kni3gruQbbfq3pPF+oG0D3fZixYSuJghGCdUNhwSkbIeC4CfUdJuR4QpltliQOrYtfVPYU6pKwzFSUxNzrqIp/L/AI11Jo+3YQ3fs15VklZfAAWe7kWtNSDuWOIjb/kZwz8cmM229DeS137maH+et0D/FPxsEw0veJSmPBT2LV/2mQ1alO
 tDlrbL9r
 xtMYs8DGu/Xb4BqGX87qh/DGANupgFq8IYSSltwlHZdgGtDfqiaGeECQadx1EegrZ5xMHs/yJD68i1oF0VLXD3/sVM1sJX/H22alOGwiG0no/iT3LmQEDO5HaPKpc/EyonennKJOLzfqpWmXfE6Jy5bxxgzIKg+Naw+l6+vNL6WwCVA980z5M9MtVzMJA4N+9M/rPQm2VWAUYyjxQTNgW34Bp2xGGlahkgV7L8KkXrnyIn4aXwiuOzlf/Vk69k3PNEUpaSPEeWxKgvcn5kuYAUjTLBmkHGh4gg0w0xKI2Xvhu5jIZREoVZdloY1/vPxlvN8v3iLoxE44DhSSUX/Cdkn3XrZRHfyv1g3jlhQ2gNRSYmQE4ndiCN6p88tm1VqaNhmrWroQc6VIMc+uqRE96krDWpXDQToeOvAu1DhNutkRcO8k2ufUjoBicOgb0Po2AVqNiTVlKtyFv/2AtdZRMKp7f6RIx3rT+4qxJpVpF9a6eLAyFRFDxqXxvUr8V2Iv5nwX7ARaiQFrRBvGDVZK9V4YiYkvaZyIuyE1o4GqDb6wfars=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jun 20, 2026 at 3:18 AM Kairui Song <ryncsn@gmail.com> wrote:
>
> On Fri, Jun 19, 2026 at 6:17 AM Barry Song (Xiaomi) <baohua@kernel.org> wrote:
> >
> > When swap is disabled or exhausted, swap slot allocation
> > may fail during swapout, causing large folios to be split
> > into small folios. The splitting is reasonable when we
> > truly fail to obtain contiguous swap slots, but it is
> > pointless in the no-space case.
> >
> > A simple way to reproduce this is to invoke MADV_PAGEOUT on
> > a system with mTHP enabled but without swap configured.
> >
> >  #define SIZE (16 * 1024 * 1024)
> >  int main(void)
> >  {
> >          char *buf = mmap(NULL, SIZE, PROT_READ | PROT_WRITE,
> >                     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> >          memset(buf, 1, SIZE);
> >          madvise(buf, SIZE, MADV_PAGEOUT);
> >          munmap(buf, SIZE);
> >          return 0;
> >  }
> >
> > With 16KB mTHP enabled, we observe:
> > ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> > 1024
> >
> > This patch checks swap space before splitting. If there is
> > no available space, it skips splitting. After the patch, we
> > observe:
> > ~ # cat /sys/kernel/mm/transparent_hugepage/hugepages-16kB/stats/split
> > 0
> >
> > Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: Zi Yan <ziy@nvidia.com>
> > Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Cc: Liam R. Howlett <liam@infradead.org>
> > Cc: Nico Pache <npache@redhat.com>
> > Cc: Ryan Roberts <ryan.roberts@arm.com>
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Lance Yang <lance.yang@linux.dev>
> > Cc: Kairui Song <kasong@tencent.com>
> > Cc: Qi Zheng <qi.zheng@linux.dev>
> > Cc: Shakeel Butt <shakeel.butt@linux.dev>
> > Cc: Axel Rasmussen <axelrasmussen@google.com>
> > Cc: Yuanchu Xie <yuanchu@google.com>
> > Cc: Wei Xu <weixugc@google.com>
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > ---
> >  mm/vmscan.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 299b5d9e8836..33f84a5fe7ee 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -339,8 +339,7 @@ static bool can_demote(int nid, struct scan_control *sc,
> >         return !nodes_empty(allowed_mask);
> >  }
> >
> > -static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> > -                                         int nid,
> > +static inline bool __can_reclaim_anon_pages(struct mem_cgroup *memcg,
> >                                           struct scan_control *sc)
> >  {
> >         if (memcg == NULL) {
> > @@ -356,6 +355,16 @@ static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> >                         return true;
> >         }
> >
> > +       return false;
> > +}
> > +
> > +static inline bool can_reclaim_anon_pages(struct mem_cgroup *memcg,
> > +                                         int nid,
> > +                                         struct scan_control *sc)
> > +{
> > +       if (__can_reclaim_anon_pages(memcg, sc))
> > +               return true;
> > +
> >         /*
> >          * The page can not be swapped.
> >          *
> > @@ -1280,6 +1289,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
> >
> >                                 if (!folio_test_large(folio))
> >                                         goto activate_locked_split;
> > +                               if (!__can_reclaim_anon_pages(memcg, sc))
> > +                                       goto activate_locked_split;
> >                                 /* Fallback to swap normal pages */
> >                                 if (split_folio_to_list(folio, folio_list))
> >                                         goto activate_locked;
>
> Hello Barry,
>
> Thanks for raising this issue. I saw a similar issue report in the
> mail list before and was thinking that, perhaps another approach is to

Hi Kairui,

Could you please post the link to your report? I'd like to add
your Reported-by and Closes tags as well.


> let folio_alloc_swap return a more detailed error code, for example:
>
> - 1. the mem_cgroup_try_charge_swap in it failed
> - 2. allocation failed but nr_swap_pages > folio size
> - 3. allocation failed because all devices are full or unusable
> (roughly nr_swap_pages < folio size)
>

folio_alloc_swap() returns error codes such as -EAGAIN,
-EINVAL, and -ENOMEM. For cases 1, 2, and 3, I assume it
would return -ENOMEM?

I assume you mean that we might want folio_alloc_swap() to
return an enum instead?

another approach is that I can return -EAGAIN for those cases
we want to retry swapping-out after splitting folios:

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 78b49b0658ad..62e2c506ccae 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1755,6 +1755,9 @@ int folio_alloc_swap(struct folio *folio)
 			VM_WARN_ON_ONCE(1);
 			return -EINVAL;
 		}
+
+		if (get_nr_swap_pages() < (1 << order))
+			return -ENOMEM;
 	}
 
 again:
@@ -1769,11 +1772,13 @@ int folio_alloc_swap(struct folio *folio)
 	}
 
 	/* Need to call this even if allocation failed, for MEMCG_SWAP_FAIL. */
-	if (unlikely(mem_cgroup_try_charge_swap(folio)))
+	if (unlikely(mem_cgroup_try_charge_swap(folio))) {
 		swap_cache_del_folio(folio);
+		return -ENOMEM;
+	}
 
 	if (unlikely(!folio_test_swapcache(folio)))
-		return -ENOMEM;
+		return -EAGAIN;
 
 	return 0;
 }
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 299b5d9e8836..4c4cbd72c013 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1257,6 +1257,8 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		 */
 		if (folio_test_anon(folio) && folio_test_swapbacked(folio) &&
 				!folio_test_swapcache(folio)) {
+			int ret;
+
 			if (!(sc->gfp_mask & __GFP_IO))
 				goto keep_locked;
 			if (folio_maybe_dma_pinned(folio))
@@ -1275,25 +1277,24 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 				    split_folio_to_list(folio, folio_list))
 					goto activate_locked;
 			}
-			if (folio_alloc_swap(folio)) {
-				int __maybe_unused order = folio_order(folio);
+			ret = folio_alloc_swap(folio);
+			if (!folio_test_large(folio) || ret != -EAGAIN)
+				goto activate_locked_split;
 
-				if (!folio_test_large(folio))
-					goto activate_locked_split;
-				/* Fallback to swap normal pages */
-				if (split_folio_to_list(folio, folio_list))
-					goto activate_locked;
+			/* Fallback to swap normal pages */
+			if (split_folio_to_list(folio, folio_list))
+				goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-				if (nr_pages >= HPAGE_PMD_NR) {
-					count_memcg_folio_events(folio,
+			if (nr_pages >= HPAGE_PMD_NR) {
+				count_memcg_folio_events(folio,
 						THP_SWPOUT_FALLBACK, 1);
-					count_vm_event(THP_SWPOUT_FALLBACK);
-				}
-#endif
-				count_mthp_stat(order, MTHP_STAT_SWPOUT_FALLBACK);
-				if (folio_alloc_swap(folio))
-					goto activate_locked_split;
+				count_vm_event(THP_SWPOUT_FALLBACK);
 			}
+#endif
+			count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT_FALLBACK);
+			if (folio_alloc_swap(folio))
+				goto activate_locked_split;
+
 			/*
 			 * Normally the folio will be dirtied in unmap because
 			 * its pte should be dirty. A special case is MADV_FREE

> Only case 2 requires splitting. __can_reclaim_anon_pages also checks
> demote which is not related to swap.

I actually extracted __can_reclaim_anon_pages(), which only
checks swap, whereas can_reclaim_anon_pages() checks both
swap and demotion. :-)

Best Regards
Barry

