Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED3DC606A32A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 02:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UZmWhM8b
Received: by kanga.kvack.org (Postfix)
	id 20D306B05B4; Wed, 28 Oct 2026 22:42:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC3E6B05B5; Wed, 28 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D36B6B05B6; Wed, 28 Oct 2026 22:42:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DA3C96B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:42:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 58D54A7931
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:42:55 +0000 (UTC)
X-FDA: 85374116310.06.9D5823A
Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B889C0002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 02:42:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UZmWhM8b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joasantonio108@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=joasantonio108@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793241773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=li6JwHU0iWRxuOXLh3ZiIpZVFgZFIl6/9VTBe15UUWc=;
	b=6KX0R/+E5/3Cy9UovfGn03tf7Ewf6PGsdsnVNgIlSwrFS8JgKBWS/z87bxTX0Jisx1KGLS
	+Cml2dle3kXLnpvq1OqlzuaeIHJUG/QHjdjDsAtRlyYszZfdF770ZoB82SIhLzpjE9H+I8
	4QHIHpksgSM0o8trwaIjlI3tYn1G1s8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=UZmWhM8b;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of joasantonio108@gmail.com designates 209.85.221.175 as permitted sender) smtp.mailfrom=joasantonio108@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793241773;
	b=OsXk3bv2kPHCnPz92EzhrfqlCPRskPyljWuOwsLIchYS5PNdHniB6lbHBdpNrXI+IENBlh
	ikT83frhQ2y4FyYt9QAxUB6zJVW4GYArVz5TsEH4hSDS68BcTYch19gdh6YZFpvmNbOzmU
	phsZzM3kXRhm4z7ELpfwxDGIqoRKVWo=
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5eac01ff101so594883e0c.2
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 19:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793241773; x=1793846573; darn=kvack.org;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=li6JwHU0iWRxuOXLh3ZiIpZVFgZFIl6/9VTBe15UUWc=;
        b=UZmWhM8bVG/1IwGVqfXBAqfVFbhyt58U3ACvpCNRfaOJwDMGKYBUcCG98V/o80LqHh
         Ke6hMtcb/kmEIa4vPrsgKpwgXbq4p5ptG1yauM9sVq6b1K3hSdfe6JxhwCCcNRcRW52v
         TUK07aAuracdJnyov0QaTWdotsaC8+R0GuovfIApaVexaFmmN1E99NRlPIx4YG2Z/ftq
         Rq0BG8PvH4GI6AtHm6OT8iZaboHEPOE5Kno696mK0i78UAq3dVugkdoLn8UVtl5nlbRj
         DuZFpaoLM3uVe27b4mhzMMDtb+QyeMpfABsCYTs0Lvz238XzX3bUCbt3A+mInygcgSW0
         2Ogg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793241773; x=1793846573;
        h=mime-version:content-transfer-encoding:content-type:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=li6JwHU0iWRxuOXLh3ZiIpZVFgZFIl6/9VTBe15UUWc=;
        b=QDI1QJWBEtdU5JsZr8KQEbefuY83T7QUwaQHk1m0nn1LFUrsibGtXFJ8yFPzKf1iC8
         vx/VBFCgJVHTpUoKqzVB9jWsugy5iok0cxHW1XWDJKj54YpGmE2IUkdU9ZOaClktsQz3
         xgPK0imlaOZdqWJWl3VtZa3eUE0Bw4vw2MD6TvzAmopRHjUjHeqGK9oOPj6UdSVjGSZW
         Zryq8MO290Pnpx9IHik85aPa+K0N+AgKghv4/PWKdoevrod80KdHxG8+X8EYhu73jsSF
         ZCvm9mHCyxS6NXlgD3ydwKq9SSaw+OGurLJ7jqLNM/bl8zg6tyJh8uleQfgz6CAkNw37
         LBWw==
X-Forwarded-Encrypted: i=1; AKwUvBy24FRjrN71juNLRMZYLY3ZjOtb/ljBjN08RJfc3dydsIbY5SWIh2YPVyqvS1ViObX2SO7nbzSlFA==@kvack.org
X-Gm-Message-State: AFq9FYKi8rUX7k/MuFlUrPV2ImuxVkvbXwkxaF3dnk/ozptW02+AyTEx
	jjUrHtiLFEwSgZ/wdrmeCS3xMS6K8WKQtJEOUNm9vpRg7tHg+eOzUXsX
X-Gm-Gg: AYBFou2jGQVfsG/nbpDDN3FE3P+cDCYknjl0au0JD6p6b5CPEYhiGA8qjiy2MkbDa/s
	8GxI+Y5A0aZlQH3POlNyYiLb0dB7YQ8UAhnxhuDrz3UO9iDX5PEhF4VfbN0OjgbXXcNLJoF0OiP
	VUcBw2DuPTked6R3D1uxcvcxe7fY4nLEi/WHwlR/YGjJ612/ZSj7l6a5JBBQwPu9ZBc5mVWbLAM
	+MoBFY6dCJ+y45C71QKsnT01Tx/l1bLzcPm3fUc4yPTgj20VHosoVx3HM43X5GKIbUDCk9DYK59
	9+jQqwpfwbu1yrtyBC/YeXJ1wrS80A5Gf3XHta8toABktgiFy9XoiiXw4azQsNE8MpnwqUkfyJr
	sgRIQZ4bh3lj9sYrhQTNbLTBBpSIsU3sI5+9PiIbMn/ODMZRWZtyyOYPG69Rl5LFe51UkxomhRy
	zYaksZzFKXRIBPY5182wEoNz/wado1QcyF5PJjqoeeCGkfP735i7zaIck3v0JVk/MhR8KAUJRDE
	U4oKOl76wSRJHELMJIJPkAt8xX4gXxoSXqUpzn9TF9mWoGorCviME6/qfH38o+m3ZDSeUbpNIJ1
	+QztpWQJuq0XUEB/8g0nMqzKf6GXXtTLXWg2E1guP7H3Q4E5a8QH6KmJmu79YhLa5xywA3x3/nO
	SXje1Q7WOd/wsnZ+k8XHbNyzzlvH2
X-Received: by 2002:a05:6122:e20c:b0:5ea:9218:eac1 with SMTP id 71dfb90a1353d-5ec4cccdb04mr1920518e0c.20.1793241772644;
        Wed, 28 Oct 2026 19:42:52 -0700 (PDT)
Received: from macbook-pro-de-joas.local ([2804:7f0:b101:c5e8:7d75:cb37:7054:6d4b])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec57fa451csm1790680e0c.13.2026.10.28.19.42.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 19:42:50 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hongbo Li <lihongbo22@huawei.com>,
 syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hugetlbfs: emit hugetlbfs_free_inode from ->destroy_inode()
Date: Wed, 28 Oct 2026 23:42:45 -0300
Message-ID: <179324176522.32673.7602596908234555806@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspamd-Queue-Id: 9B889C0002
X-Stat-Signature: kknyhfzigsztyxj7tbuztq1pb9cp55t7
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793241773-807896
X-HE-Meta: U2FsdGVkX1/K2LwRRZkWhcq/363flJ5XztYADe5K1N5O/w9DhqP3MuAtzViAI+ugKZoRA8ZrLeBHYZnbwBnitdpr/0qF3bsI/vvgwEyBAa2VomRinJKY3gJKR34A+zdlYx8M52CRwblHrvVtuburlrgYTfrgDPf2g/lnHtK76zaCOyX5eYL1NZM6j3kw4H1kssTt0yGjoZ3HZXSHc/65S4h6ZSlUBv+lfpTV/6yQVFtxOHQ6jOZXGbMatPEuDWfjDqPjQl2SJX0B4r9rLQEGX/B7ZrLO97dJO4HgTORV95KwQbyb1mzhrQQ3OmAmosAnZxPfryzxIzlI6teKvjmwzfUXX1yNyJbzNNFrtoYSzZHj7g5ByG3wsolnj8Vk2b7JhCYwTS85XW1Ff/yMpxt/0McCliZiNRSCGxmA8JYNZ6oILRG/JyB72cGEUTJNv+fRnzGVKb6Vqm5aFVaJeStxwveB/pTWL5lzhCg/bx1KXcbszdpWjt0CJQDbyWmU7KPieU5vvCrNV3i5PnLBZyqvKdDGH57lUK+N6uCUX+YrDNXtFXvng1WUL00cRwLHbyUKVRa5LiK8SYFjwIx1qncaC1A8pYQsHKMUTvQuYIB4poU+MriUASym5ZoJ6KkP+b09HRQ5jBqU6FAWcA3/WBjzeUca5R/xnEx+hJ+jdkOn6VcImTf3urQlqlBXwBX9vOZJ56wPkjYd/d3qaaeeYmUjisZzT0FcAPIR3YaCYpPSz2nU/8NEDDIOu1hZqkwk/9269AUB8JarvC5HH4v77ohC/XmkmJN/b+2MkJozNsw7B8Mh+RhWAv20wpBfJRYa/O6/GKMpPc07lt5O/cHe+OHsE4ARapr9v2Oa5bPVyISREY1TWGodIRZSFKl1AMsu5/u5Tb4q9JoDXYfYqK/GxI5y6a4C8OziW1IkCgYFmBAzoGFKZgwNJyXxXaNG1KPCCGEXzI8jOr1ibsqq9mlwUbd
 6v2OSLVy
 usUPl4Qp7bwj1DcTcbot026IKVCHBsvfT/AJaqXRVp/hKSYM8u5ePFMKAe1lpXJOxQeaJvSVwmyhyfCOWIrF0RgJNeIAfy+Bnmf6/tofnuCjbbaau/tT09o1Y21os4QXuiRfzFu5fIKDesYX1e+7aic4yCVqbcspqasN5PFE5FHSKlnAgtwbfZr1V0Sg+El0nnsiqVl4zhzk3TfQseMZc5AciL/SYtk+C48dujq22BJPt2oUBxSHj1aKZP4bHshqYpbHWYV8N08s73CLmWTW6PnCQ0Wb0lMKQlgCNGolBbfpC/hQz5FQt36s5R7AMGydka+3b/1J892tnuaWwZ91uzl3KxqmUjj2+ltgxC7/+toTTT6q7lntHrHSkCTSjY+r3kXu2N2WPUc1IBYeV/9rcXqMYKGhjjpsuSl3TK1Br31lP6SBqUF6t0nIHnUN9fy+pSG703NqheXJojauartG2+SXr6HSRCpxwEIp74zI5I/M45vWPrMrenmZwBPMxgacPutF/AQrnWMaR08+dZOD5npIOsKK32+uO3victFnbKAx6s0xIHjttWYkqDxCs1X7ke3y+Gzvq4tsulI0fPELz9dPIBfBQCW/0xOkZT/AhQ8CB2AQELC2fwEKxUJUS8Uk+hwbMNovJqdroXpT7vzcWAPlqW9gaZYThUPRsHkW+MvY7oBDBTlNdLQa+GUS7fL0/iRZLNJPVqvDixPYvUvbPJ/Cd61OJTfFp0EeuM1Ird0CGRDJOF6iaqTviMxto2ZLQ5YKll7vNM2pQZhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlbfs_free_inode() calls trace_hugetlbfs_free_inode(), and the
hugetlbfs__inode event class records inode->i_sb->s_dev.  ->free_inode()
runs from an RCU callback (destroy_inode() queues i_callback() with
call_rcu()), and Documentation/filesystems/porting.rst says that this
callback "is *NOT* ordered wrt superblock destruction; as the matter of
fact, the superblock and all associated structures might be already
gone".  put_super() frees the superblock with call_rcu() followed by a
workqueue item (destroy_super_rcu() -> destroy_super_work()).  syzbot
hit this with the event enabled:

  BUG: KASAN: slab-use-after-free in trace_event_raw_event_hugetlbfs__inode+0x45b/0x4c0 include/trace/events/hugetlbfs.h:36
  Read of size 4 at addr ffff888038850010 by task syz-executor952/6134
   hugetlbfs_free_inode+0x15e/0x1f0 fs/hugetlbfs/inode.c:1182
   i_callback+0x46/0x80 fs/inode.c:317
   rcu_do_batch kernel/rcu/tree.c:2650 [inline]
   rcu_core+0x5f0/0x1220 kernel/rcu/tree.c:2919
  Allocated by task 6134:
   alloc_super fs/super.c:326 [inline]
   sget_fc+0x1ba/0x1f60 fs/super.c:874
   hugetlbfs_get_tree+0x1e7/0x2b0 fs/hugetlbfs/inode.c:1431
  Freed by task 855:
   kfree+0x22b/0x6d0 mm/slub.c:6923
   process_one_work+0xac7/0x1b10 kernel/workqueue.c:3495

Emit the event from hugetlbfs_destroy_inode() instead.  destroy_inode()
calls ->destroy_inode() synchronously, before it queues the RCU
callback, while the superblock is still alive; hugetlbfs_destroy_inode()
already dereferences inode->i_sb there.  ->free_inode() is left with
only the kmem_cache_free().

Fixes: 014ad7c42a69 ("hugetlbfs: use tracepoints in hugetlbfs functions.")
Reported-by: syzbot+91e1fc35f51774c479b2@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/6ae27525.5451848c.f7707.0001.GAE@google.com/
Cc: stable@vger.kernel.org
Signed-off-by: Joas Antonio dos Santos <joasantonio108@gmail.com>
Assisted-by: Yaga Agent HackerSec Claude:claude-opus-5-5
---
Tested on net/main 94cea342e891 (arm64, QEMU, generic KASAN, tracing
enabled) with the syzbot C reproducer, which enables
events/hugetlbfs/hugetlbfs_free_inode and races hugetlbfs mounts and
lazy unmounts with open + unlink.  Without this patch KASAN reports the
slab-use-after-free in trace_event_raw_event_hugetlbfs__inode() from
hugetlbfs_free_inode() <- i_callback() during the first 10 second run,
on 3 of 3 boots.  With it, 12 runs over 2 boots are clean, and the trace
buffer still holds the hugetlbfs_free_inode events (about 46k per boot)
with valid dev numbers.  fs/hugetlbfs/inode.o builds cleanly with W=1.

The event now fires when the inode is destroyed instead of when its
memory goes back to the slab cache, one RCU grace period earlier; the
recorded fields are the same.

 fs/hugetlbfs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 6656807..27a3937 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -1179,12 +1179,16 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
 
 static void hugetlbfs_free_inode(struct inode *inode)
 {
-	trace_hugetlbfs_free_inode(inode);
 	kmem_cache_free(hugetlbfs_inode_cachep, HUGETLBFS_I(inode));
 }
 
 static void hugetlbfs_destroy_inode(struct inode *inode)
 {
+	/*
+	 * Not in ->free_inode(): that runs from an RCU callback, when the
+	 * superblock the event reads may already be freed.
+	 */
+	trace_hugetlbfs_free_inode(inode);
 	hugetlbfs_inc_free_inodes(HUGETLBFS_SB(inode->i_sb));
 }
 
-- 
2.39.5

