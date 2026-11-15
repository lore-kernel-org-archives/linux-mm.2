Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9152E606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EGnhrybj
Received: by kanga.kvack.org (Postfix)
	id 821E36B05B0; Sun, 15 Nov 2026 17:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8B16B05B1; Sun, 15 Nov 2026 17:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F626B05B2; Sun, 15 Nov 2026 17:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2F06B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:00:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 234B1C0868
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:17 +0000 (UTC)
X-FDA: 85438722474.15.C29311A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6717018000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:00:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGnhrybj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1v6Y6a+QlyoXYhdz9QlUP5uoo0sVtE5XqN3Zaa8y00=;
	b=o7zFugksQul3RakfIm7RULyLg6yg5Sy6KHRvJ+KPUDNYGBCuRShNLeCrnvrJpISKt3F2U4
	FffW7eJjw4zP2n2+chsOX1dDbsgoIBgjD7sxCrc593bFXwx4XTCLyvYQh7fEt8vRZg92Dk
	oELTHuwMBz+yuoqiCcIfoD/WKOk2ioM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780015;
	b=pLPTASK/Y8b6K8NNlz1SUWpnCCSU06FpUrtwOwYluGmdeINyC3viTBlpFradBXTvpf9oOO
	0c8x7wHokez/g/4OoeHQl/GU3zdGbsOWXW3rCEuk8BVs5BiNcFqaoouwAKtCeVt+zHoA5I
	KSiScg/0F4KwN9kbYHr9nY3AST0RhoU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EGnhrybj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95B5340E90;
	Sun, 15 Nov 2026 22:00:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B77041F000C4;
	Sun, 15 Nov 2026 22:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794780014;
	bh=N1v6Y6a+QlyoXYhdz9QlUP5uoo0sVtE5XqN3Zaa8y00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGnhrybjez6dCIq7PmwFVVj3f+1GoC3tonXUCARBmjviEtBYHWwsm3F15CE/wQarN
	 lD0lOI7+Ki86tXCAYbv/3hWw5XkSu8o3ECm1/sWSO24wVBGS+d5R0BAw5lf2zAXJiP
	 rmem+mUkYBUYjX3KNdxxF2gSZibgzYlJYNgTjYTVv5nUxuyKZ/ZdR8/qR6QI6yu4Ii
	 Dw/PlyNwEbBIEt9VfhprU59omOT0OBWRTr9lCGlq46fPRLEi2H4TJz94lxi3+dSUV1
	 1kMavqdF+m+RPuv/rlLXmuAKv//RRMEZskkS2hHtmK9Es5ekTwynIvblhdSB7oRhpB
	 JVVuCupWVPTRg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: ryncsn@gmail.com
Cc: akpm@linux-foundation.org,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-mm@kvack.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	sashiko-bot@kernel.org,
	sashiko-reviews@lists.linux.dev,
	shakeel.butt@linux.dev,
	sidchintamaneni@gmail.com,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn
Subject: Re: [PATCH v9 11/16] mm/mglru: Run aging when one type is drained
Date: Mon, 16 Nov 2026 06:00:07 +0800
Message-Id: <20261115220007.89063-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <CAMgjq7DiH1SJCR0DMwf=16cxXO2PZcjSuD41sO7_2hOcXuPUQQ@mail.gmail.com>
References: <CAMgjq7DiH1SJCR0DMwf=16cxXO2PZcjSuD41sO7_2hOcXuPUQQ@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9cd1dj6kmewtf7txomggotkkdyoafez5
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6717018000A
X-HE-Tag: 1794780015-593671
X-HE-Meta: U2FsdGVkX18sgkk4bQQVwSOi1ShLFhX55jlW/GPsKGWmmG0WHSxOSXCfWdOQSHAE+lDki74F/3Szt1NmKEJp5tAH1umiQTGlCw+TogPqXiND6NyZqJ5MFyMqw52RXOpPCSX1EeLv4kj3f5c4bf/h9yUg7wTXxrhlIh/ZCrr7weW8MSNlvhpCDj7O3609aX5swj95YjkfeSdIUSx46xP70uWlX9TBvfm8O/qNhe7P2XiLRzai+FZkepYX0G2fye895a/mkLsueNPSORnZMJrz6di8oQUmHqfJ39XUhjoSx6a7proOJEcdWZ5MwmjhJUPlW2TvBg7HZrIv7+TPzuqwekRrZsadr6Ww3mkKqZh9Wn9WOxNEu+2EIF26OgjNL3KJhRX7Uj4RZrdgvaLJyyO6gtrppx91V4ec8+e38P1XB+w6t1HiiE6LeMCyIpE6ns+732Wo9WpYd1ZnChZSBoARy0tbqYjy5WSNHHJlMWHITZZcijax9jiuUF8xR76fRdH0XMkJGDWhz1EA6PsIxc9EqHsVr+EFGHclsv8/pTARdhaPZSzorOe5zve/r8vwKmeR9udMqit0IyQ5Mwf9VXGeaYuRxcv1D+cAXtl2iL9HsQyKr/XDAtEhorUY4boKjiQfUeFpQCzy1LOA7Cuua1NdFVpfQRUpQ6gzYua3F8fyLkMSSjNucnkygjsLkZn1D5JdLedv97Wpu0dg41aawVb+Tc2EPJPpeblELTVy+WPuYb8nGdGra6B5Akizrv3VJIEOD4qkz8igCCB5h9X5Ge7xDjPlTEJ03xrVQOKjqS7jdr+hExStxDqdzpwTaXUWbr7zGJgRqdBwiS06/bM7f7SP/dXIqtOhvYktHDpmYqereiODvySKdqoy6agn4ODknfZ8z834EbRDNfkRCLXYAyYOnmH+GEqRm8iCxabIktN98Lol/Uy2Grie29+PbjyxbONnDulJXBJGI1mYBUdcg23
 3OUulnAx
 UVXcwHy6rqdMmNQNKBsSLp6vhiX6xi7m2MV1qZlcjG2Z2+o3bHG7edaCVjNClPIFHYCMiirDbb2Nbhc4Y+4IqOATx2cMUOMHaO88jptLH43OnYwZBVa//Wl/8mMPQ9qJDoROJE/URyMpiAIMy8eilhtNEvRFA7CK6lYjb0jjn6xlrK9ApBKS9f10t24o8+2bMVnKJlcOnLPZ6D2rzPJtM6bDfj4kEZ6O1gV1KnWr2zc4rt2PUrplbbPaLrv09nFC0HD/7kE5h+PGOLzfC51ffe+8yJyDVH7N8D7sv2nCj8Xzz5IFIEOofZWPB8qHksUxoC/IWdNUcOfTtl3ja1uivVIy4dBzQ2XfEJZivbCQcJKs3fxuzQo68E9EnPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Nov 16, 2026 at 2:07 AM Kairui Song <ryncsn@gmail.com> wrote:
>
> On Sun, Nov 15, 2026 at 5:44 AM Barry Song (Xiaomi) <baohua@kernel.org> wrote:
> >
> > On Sun, Nov 15, 2026 at 4:50 AM <sashiko-bot@kernel.org> wrote:
> > >
> > > Thank you for your contribution! Sashiko AI review found 2 potential
> > > issues to consider:
> > > - [Medium] mm/mglru: scan_folios() scans seq below min_seq at
> > >   DEF_PRIORITY
> >
> > I guess reparenting could be a corner case where it's difficult to
> > properly preserve the cold/hot ordering.
>
> I think we don't need to care about hotness for reparenting, MGLRU's
> reparent just forcefully squashes the old gen into the parent's gen,
> and most likely in the wrong window order, the hotness info is already
> severely skewed; there's no way to cover that until we run the aging.
> In fact I think we should patch reparent instead, maybe later,
> squashing everything into the oldest generation seems a more
> reasonable solution for reparenting?

Right. The current reparenting behavior is already quite odd,
given that generation numbers wrap around. A larger generation
number doesn't necessarily mean a younger or older generation,
so the ordering can already be completely disrupted.

static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec *parent_lruvec,
                                     int zone, int type)
{
        child_lrugen = &child_lruvec->lrugen;
        parent_lrugen = &parent_lruvec->lrugen;

        for (gen = 0; gen < MAX_NR_GENS; gen++) {
                long nr_pages = child_lrugen->nr_pages[gen][type][zone];
                int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
                int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;

                /* Assuming that child pages are colder than parent pages */
                list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
                                      &parent_lrugen->folios[gen][type][zone]);
                ... 
        }   
}

I think it makes perfect sense to simplify the code by moving
all child folios to the parent's min_seq, especially since
there's already a comment saying:

"Assuming that child pages are colder than parent pages"

And I think the current active/inactive counting is absolutely
wrong for reparenting:

static inline bool lru_gen_is_active(const struct lruvec *lruvec, int gen)
{
        unsigned long max_seq = lruvec->lrugen.max_seq;

        VM_WARN_ON_ONCE(gen >= MAX_NR_GENS);

        /* see the comment on MIN_NR_GENS */
        return gen == lru_gen_from_seq(max_seq) || gen == lru_gen_from_seq(max_seq - 1); 
}

Considering that the parent memcg has only two generations,
some child folios may end up in lru_gen_from_seq(max_seq + 1),
which is also lru_gen_from_seq(min_seq - 2), while others may
end up in lru_gen_from_seq(max_seq + 2), which is also
lru_gen_from_seq(min_seq - 1), due to the wraparound.

In that case, wouldn't max_seq and max_seq - 1 effectively
represent "inactive", while lru_gen_from_seq(max_seq + 1)
and lru_gen_from_seq(max_seq + 2) represent "active"?

This makes your idea of moving all child folios to the
parent memcg's oldest generation even more compelling!

I drafted the following code based on your idea. It's unrelated
to this series and would be a separate change:
(also I found another bug, __update_lru_size() is only called
while parent/child active status is different -  this will
make both parent/child lru statistics wrong, so i dropped
it)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index a5b8244d4768..582bce575cec 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4620,28 +4620,27 @@ static void __lru_gen_reparent_memcg(struct lruvec *child_lruvec, struct lruvec
 {
        struct lru_gen_folio *child_lrugen, *parent_lrugen;
        enum lru_list lru = type * LRU_INACTIVE_FILE;
-       int gen;
+       int gen, parent_gen;
 
        child_lrugen = &child_lruvec->lrugen;
        parent_lrugen = &parent_lruvec->lrugen;
+       parent_gen = lru_gen_from_seq(READ_ONCE(parent_lrugen->min_seq[type]));
+       int parent_lru_active = lru_gen_is_active(parent_lruvec, parent_gen) ? LRU_ACTIVE : 0;
 
        for (gen = 0; gen < MAX_NR_GENS; gen++) {
                long nr_pages = child_lrugen->nr_pages[gen][type][zone];
                int child_lru_active = lru_gen_is_active(child_lruvec, gen) ? LRU_ACTIVE : 0;
-               int parent_lru_active = lru_gen_is_active(parent_lruvec, gen) ? LRU_ACTIVE : 0;
 
                /* Assuming that child pages are colder than parent pages */
                list_splice_tail_init(&child_lrugen->folios[gen][type][zone],
-                                     &parent_lrugen->folios[gen][type][zone]);
+                                     &parent_lrugen->folios[parent_gen][type][zone]);
 
                WRITE_ONCE(child_lrugen->nr_pages[gen][type][zone], 0);
                WRITE_ONCE(parent_lrugen->nr_pages[gen][type][zone],
-                          parent_lrugen->nr_pages[gen][type][zone] + nr_pages);
+                          parent_lrugen->nr_pages[parent_gen][type][zone] + nr_pages);
 
-               if (lru_gen_is_active(child_lruvec, gen) != lru_gen_is_active(parent_lruvec, gen)) {
-                       __update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
-                       __update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
-               }
+               __update_lru_size(child_lruvec, lru + child_lru_active, zone, -nr_pages);
+               __update_lru_size(parent_lruvec, lru + parent_lru_active, zone, nr_pages);
        }
 }


>
> And if the child's old generation was squashed into an out-of-window
> generation, these out-of-window cold folios will get evicted much
> later than the hot folios. In that case we even somehow "fixed" that
> by this patch :P, as long there is no leak, I think it's hard to
> define what is the right behavior.

Yes, agreed.

Another thing we could do is add the change I mentioned in my
reply to Sashiko [1], which Andrew has already picked up.

@@ -4788,6 +4788,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
  seq = lrugen->max_seq;

  seq = lruvec_populated_min_seq(lruvec, type, sc->reclaim_idx + 1, seq);
+ if (seq < lrugen->min_seq[type])
+            return 0;
+

This would avoid iterating over each zone's list just to check
whether it is empty. That's the case most of the time, except
for corner cases involving reparenting.

[1] https://lore.kernel.org/linux-mm/20261114214438.70148-1-baohua@kernel.org/

Thanks
Barry



