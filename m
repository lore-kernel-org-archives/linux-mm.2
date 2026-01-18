Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28C5C98315
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 20:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFF056B00AD; Sun, 18 Jan 2026 15:53:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAC3D6B00D2; Sun, 18 Jan 2026 15:53:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5056B00D3; Sun, 18 Jan 2026 15:53:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CB1C06B00AD
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:53:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5B9248C0F7
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:53:15 +0000 (UTC)
X-FDA: 84346284750.03.D8C5478
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 86F5F20006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:53:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wAwy4dum;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768769593; a=rsa-sha256;
	cv=none;
	b=qTHrcrU7H8N4q2CPd3/iZAqihU3H0L/xSuWz78y2/1VRjYGo2+XrIcpCyu9KE/iG3i5Kyl
	h+dmYxUp8y5I88SYA3ttjDe9Rxtj4WkSRsEijnP8Kdm11zkuCSmQk089Dp5YGAq5VjNDJ7
	N3NgbQjliWGSi+QlWQNVocmOBBNS4MM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=wAwy4dum;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768769593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sx3aFJkziETw8stWouNQefvAV73ohh3TUIZ2jQJe7Os=;
	b=QSjZ3QF74V837ceWVIIGoNehhxt/NUYhG3SYtpFfbHso84Ts9/06Y7jDXkAPJyWZXidkzM
	II3lwMgxuKzuupsAdlGDUIHhjRqKgyxZGIzzsw06yTWtIrR62eZpE9xdqo/C8K/24HzNM+
	7djazynQPwgwYaYTCprq3k1O8+/0R54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F68A40223;
	Sun, 18 Jan 2026 20:53:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5E4C116D0;
	Sun, 18 Jan 2026 20:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768769592;
	bh=fK9ac9RPhRZgFPiQNcPRY83rlzyBRy0paqxUcXHrxlY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=wAwy4dumj3QkHo2j4/DFpsskq0L2LT+YaKl/VWlDSldxxke7hgauSAAaCEQdxQ/rM
	 35l6yp40Je1qZG1ZgTWzwr0eHET0Wp4AjTK9It/U+kfCFKjZTw/tDbw++Y2TB/bEuQ
	 p4KTqMMB/Rkp7GfG3dmQt7Tca4Ph5/U6dNUvAAqY=
Date: Sun, 18 Jan 2026 12:53:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Deepanshu Kartikey <kartikey406@gmail.com>
Cc: syzbot <syzbot+079a3b213add54dd18a7@syzkaller.appspotmail.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 syzkaller-bugs@googlegroups.com, Johannes Weiner <hannes@cmpxchg.org>,
 Muchun Song <muchun.song@linux.dev>, Minchan Kim <minchan@kernel.org>
Subject: Re: [syzbot] [cgroups?] [mm?] WARNING in memcg1_swapout
Message-Id: <20260118125311.e1894f598e2a8ef626f47f25@linux-foundation.org>
In-Reply-To: <CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
References: <696b56b1.050a0220.3390f1.0007.GAE@google.com>
	<20260117165722.6dc25d72fd58254cb89e711b@linux-foundation.org>
	<CADhLXY6ACKeyLrjARTTdfWyrvUdLbtD-wXiQvsvhsbGjwmUqDA@mail.gmail.com>
	<CADhLXY7FJqRLjX7X2yJfa0=iDbUAMwhS35cOEExW+qBJWAnt+A@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 86F5F20006
X-Rspamd-Server: rspam06
X-Stat-Signature: g9u1sqeofjc5ck4i5r6jtj8kfz57sr8p
X-Rspam-User: 
X-HE-Tag: 1768769593-324532
X-HE-Meta: U2FsdGVkX18tcC0u3hrsl5KFbQ+wpYo08fhRVLS49BLnjrEyqDfSmD3oXtgPYyEHdybMAMQUR9JJd9/rKmF4ilFtd+6r8vLYiHsgT9VThjLwjXc6ohOkvTbMI1KYIzBujTRnTtgNuflbOzV2KUCAh9QtqZtBovlndM4SVZbwJZByhmZMXUcXRPQXOGrAiX9XEo5ecCEit/vY0AqvpsSMgJNBxZRo0uI2OHOpggQ7T7Exst2glmeTORq8YgSZGQKWDKfNgZ+CiOQsm0kEQianw9O6y9YpWqbXZOuYFd8B1TY1yCdRsqViCvP/OvCtaFlDUtyqq0p15HJOrUXnGgXeEc57OnHF+nP/46WArQPE3TtJUuWf+AlaQAEB01X6dpHSEjEjrLCdDJiFxoWHRYnjwVHNw0OslyrBZkZszudVbFG2hgu0x3T5iT4krhW2g4B1i4A58VfwDYCAxYuYB83MhzZkhUQCxbP2+J8+kQlvTAPecrX9G/1QbJaIHBOh4OroVVTuqPdMqkN4jUqSRaQ0g99BIeQMvuWf8c0Q9U+aOwVH0sLF1DQQx782HHBNoMsW36B91Hp+vwHwNDFeYUSTlDWjnVu5jWrL2TNCAsnsgyXhHDz9FpwF+5piRuTIPLZCel6CpJIar7E9NSl9uNLqrCnTuyNyRF6/cOhcXfJiLzTlHfWYlzd4tYCTabN/nETJjZ49p7UPFAX1WoY8Xw6Yp2sht63M/9WMySkJ5Q39qCNNx2+L9m4m8nsRwnR8ab00ojRQR7pRBtSuaxfRzPLGJHpyv2qLozgfZ8glMn/OsVKFMMwLipadXDc5Tu/LTh/a/ttV+LXl6USP4EkcdoLbo/kuJHBbbxslSxNCmJaQlO5E641orVfG9OUlZaOGTn78fNY0PkJ31Ynkv2tgykQdXFDwbA5XOSsSP64QUBTYOavuAxDJGruRkC+4rAunRAfr3LsTTfDldXCJduw3+3s
 sN/GLMIs
 PU9rzSaF8soQ+4POsPRdpf63diymJPaVulbGf8+Znwhr1GKtJFN5SnSswkw+3UCkuAXCJhStNsm2y9yRVcUXchidkMuJ1gj5HUGvZx5qY1X0FWOKyB4NsJF/ZoBMSyVNX7U7BvK1zC+vM4CTD1hjC01QTUU+2E3/1dGn8iluS4YngVL08p7aGDwflc89iZvjs/7AeR7YAdVQx31fbOuJMNwL7ZuQiccAM4cJQ8MqLV9ytUfYoU08Dr+aMv6tT5xUjmx5hqEiiQibeneV4fQBEfYkRktsO0L6vsvNWmg+/6pQ3IywZ1owftWf4YHx+yfccLch66ZiYyp1mWoT2Z28eDYXJAtIneFoDEP8CsirQmMadUmgJdS/LGd7/EMr9fTJA0//bBgaIuZV1U0OFc6eZuZ07k6twkHeCu3WMvRpOSf95gKWQ9ubsL54C0YAp3GHmrQiBNSGa6MZP39gydoJBHlbQNSmmCrdbw3bG48RR4mfD62UxY49jJ8VaB4jlsELb6AkLOa67p9jxt7cMqF2bAmHLGw5gsW4r6fKIMwBuirdU03hP32Lydjg+Nz054djiS8Z4qq2N86UhQVxCn+F9ZlUnj/DV4D1oaXAspDYy4FaZlPlgJnn2yp2HiCyMH5zlByEXN61STbxo5jvUOnX1DUS4ZfQP5LjiEywJ1yg9nA5r6Fp6wXYZkHpt+L/iAvdUAG4esBxzXBwHFlc/aF/B35xRhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 18 Jan 2026 12:31:43 +0530 Deepanshu Kartikey <kartikey406@gmail.com> wrote:

> > >
> > > That's
> > >
> > >         VM_WARN_ON_ONCE(oldid != 0);
> > >
> > > which was added by Deepanshu's "mm/swap_cgroup: fix kernel BUG in
> > > swap_cgroup_record".
> > >
> > > This patch has Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT"),
> > > which is six years old.  For some reason it has no cc:stable.
> > >
> > > Deepanshu's patch has no reviews.
> > >
> > > So can I please do the memcg maintainer summoning dance here?  We have a
> > > repeatable BUG happening in mainline Linux.
> > >
> >
> > Hi Andrew,
> >
> > I checked the git blame output for commit 0f853ca2a798:
> >
> > Line 763: memcg1_swapout(folio, swap);
> > Line 764: __swap_cache_del_folio(ci, folio, swap, shadow);
> >                     (d7a7b2f91f36b - Kairui Song, 2026-01-13 02:33:36 +0800)
> >
> > Kairui's reordering patch appears to have been merged on Jan 13.

Eek, there are many patches, it helps to identify them carefully.

I think you're referring to
https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-use-swap-cache-as-the-swap-in-synchronize-layer-fix.patch

> > The syzbot report is also from Jan 13, likely from earlier in the
> > day before the reordering patch was merged.
> >
> > So this report is from before the fix. The warning should not appear
> > in linux-next builds after Jan 13.
> >
> > Thanks,
> >
> > Deepanshu
> 
> Hi Andrew,
> 
> I tested with the latest linux-next in sysbot. It is working fine

Great, thanks.  But we still don't have review for this one.

For some reason I don't have cc:stable on this - could people
make a recommendation?



From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/swap_cgroup: fix kernel BUG in swap_cgroup_record
Date: Sat, 10 Jan 2026 12:16:13 +0530

When using MADV_PAGEOUT, pages can remain in swapcache with their swap
entries assigned.  If MADV_PAGEOUT is called again on these pages, they
reuse the same swap entries, causing memcg1_swapout() to call
swap_cgroup_record() with an already-recorded entry.

The existing code assumes swap entries are always being recorded for the
first time (oldid == 0), triggering VM_BUG_ON when it encounters an
already-recorded entry:

  ------------[ cut here ]------------
  kernel BUG at mm/swap_cgroup.c:78!
  Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
  CPU: 0 UID: 0 PID: 6176 Comm: syz.0.30 Not tainted
  RIP: 0010:swap_cgroup_record+0x19c/0x1c0 mm/swap_cgroup.c:78
  Call Trace:
   memcg1_swapout+0x2fa/0x830 mm/memcontrol-v1.c:623
   __remove_mapping+0xac5/0xe30 mm/vmscan.c:773
   shrink_folio_list+0x2786/0x4f40 mm/vmscan.c:1528
   reclaim_folio_list+0xeb/0x4e0 mm/vmscan.c:2208
   reclaim_pages+0x454/0x520 mm/vmscan.c:2245
   madvise_cold_or_pageout_pte_range+0x19a0/0x1ce0 mm/madvise.c:563
   ...
   do_madvise+0x1bc/0x270 mm/madvise.c:2030
   __do_sys_madvise mm/madvise.c:2039

This bug occurs because pages in swapcache can be targeted by MADV_PAGEOUT
multiple times without being swapped in between.  Each time, the same swap
entry is reused, but swap_cgroup_record() expects to only record new,
unused entries.

Fix this by checking if the swap entry already has the correct cgroup ID
recorded before attempting to record it.  Use the existing
lookup_swap_cgroup_id() to read the current cgroup ID, and return early
from memcg1_swapout() if the entry is already correctly recorded.  Only
call swap_cgroup_record() when the entry needs to be set or updated.

This approach avoids unnecessary atomic operations, reference count
manipulations, and statistics updates when the entry is already correct.

Link: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Link: https://lkml.kernel.org/r/20260110064613.606532-1-kartikey406@gmail.com
Fixes: 1a4e58cce84e ("mm: introduce MADV_PAGEOUT")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d97580a8cceb9b03c13e
Tested-by: syzbot+d97580a8cceb9b03c13e@syzkaller.appspotmail.com
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol-v1.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/memcontrol-v1.c~mm-swap_cgroup-fix-kernel-bug-in-swap_cgroup_record
+++ a/mm/memcontrol-v1.c
@@ -592,6 +592,7 @@ void memcg1_swapout(struct folio *folio,
 {
 	struct mem_cgroup *memcg, *swap_memcg;
 	unsigned int nr_entries;
+	unsigned short oldid;
 
 	VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -609,6 +610,16 @@ void memcg1_swapout(struct folio *folio,
 		return;
 
 	/*
+	 * Check if this swap entry is already recorded. This can happen
+	 * when MADV_PAGEOUT is called multiple times on pages that remain
+	 * in swapcache, reusing the same swap entries.
+	 */
+	oldid = lookup_swap_cgroup_id(entry);
+	if (oldid == mem_cgroup_id(memcg))
+		return;
+	VM_WARN_ON_ONCE(oldid != 0);
+
+	/*
 	 * In case the memcg owning these pages has been offlined and doesn't
 	 * have an ID allocated to it anymore, charge the closest online
 	 * ancestor for the swap instead and transfer the memory+swap charge.
_


