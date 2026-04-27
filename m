Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 982F9FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 07:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBFE6B0005; Mon, 27 Apr 2026 03:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C2F6B0088; Mon, 27 Apr 2026 03:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B1D26B008A; Mon, 27 Apr 2026 03:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB486B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:24:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C5A01B91A5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:24:39 +0000 (UTC)
X-FDA: 84703498278.15.7BED4B6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2D51D120005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:24:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqtLQT0D;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777274677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FYLkegxwphet4SRas0qyIUVtFR79TYwjGwBKxPSGZw=;
	b=T43+XUv+tlSSYHAXer8YbmdDWXkHQiTiM7qQjxWNu6CJZlI3V0d1G6zBnjeb2Z8vbLk05a
	aoLke89/IqqZ19qEu44jsUNBZ3o3kEcFrkdJpAqq5XanZu2nrHumW9YTi3y8mK7OxGbjKW
	rxBi8jhnqKROPCqersHx37nQnp82lVk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bqtLQT0D;
	spf=pass (imf29.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777274677; a=rsa-sha256;
	cv=none;
	b=RflAOjhIM6J2h3l6AJm5las5pqLcEauPAJ1dbiFYkLnei4f6Z5xeUac4sYmQY7I9jUgfTL
	ZxpzbAKRuDjrqHo/b9FusWRfxElLep8llm2V6g9S4soIUHJJrXM7RPe23UWt8iV9riWcyi
	5a9fHNo9n/U6iMd86r4gzmGKEDh2AIs=
Message-ID: <3591c663-a4a9-4c22-97cf-b58b2e7d8a41@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777274674;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9FYLkegxwphet4SRas0qyIUVtFR79TYwjGwBKxPSGZw=;
	b=bqtLQT0D5/ZpzgmKaiQ+8vqeYCsK9hLF9yzBn9KkiOlI+qU0A1lxs3Le7/sE6PqyJgvmc6
	HUwTIrK19SkB3dbx2zZ2+ebgLrjsZ8m0Ow45GRpPm4vPLvtr1JlDfxXWcb2Dv4UB+xpC3M
	RD9Z4r+CxOw0+FbtvqmHou9vEerPV7M=
Date: Mon, 27 Apr 2026 15:24:10 +0800
MIME-Version: 1.0
Subject: Re: [syzbot] [mm?] WARNING: bad unlock balance in do_wp_page
To: Andrew Morton <akpm@linux-foundation.org>
Cc: shakeel.butt@linux.dev,
 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com>,
 Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, surenb@google.com, syzkaller-bugs@googlegroups.com,
 vbabka@kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <69edca15.170a0220.38e3f1.0000.GAE@google.com>
 <20260426034938.db29d74982a8eb8463f8cf3a@linux-foundation.org>
 <e7187a21-7114-4f42-bf8b-90d6e6b54fa2@linux.dev>
 <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260426105532.43768b24a42744f1b52fdff2@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D51D120005
X-Stat-Signature: o5ox7eqfyi483cwm4makazp1hmrf5xfy
X-HE-Tag: 1777274676-199193
X-HE-Meta: U2FsdGVkX18EmaGSKrRlkbJqJUVS/CEBWCzwGXRHnmVqTlP0wgykdEwY7YHb75nVDM6EaRCGXOsu3EL8ERCJySSSghPK29zFZtEJa8K0kccFXwJqiygKV0Q6kEJQhT6PDu3NE+VT1goLlVjDO2v76e/0y8pNru/vy9HUU/iecd4CqbVUtCznUYT0hk1tvOPvb6tgJ5bzQD4QD1mSShXT1Nc2WBaHWaBgoXCeznDAtRBn8cHOa3A55diVNyZ5b696ZxLy8AMkV1t55tPsNYqBepYkNVI0MqTREulne1N8KRg2TTSOPmLreloKK3ffmxlHn68uDzcqrQLPucr6CLiwoXFz+5NctR+31MFvDEt44thr9WI1gL25cLm8antmQn5eaB1Enz07joXd/qK0IxsLde3acnag6hpVNIZwr8S9HGc+EyiFNnp76yOx+oN9nntDSGYW1yrmjJcrWPfe8UjP5ejgMNyi1MewcRfPCemYBHY2hhN8xZrr+HjxMao4te9c3aiXxhZELTSf0/XGiy56RshGuIbFTrDubbXWepU4pdDVOFK7Ase9JEVvp510zZGgoDbLC7lxNUsP3qsc6w3L2B5B1Dap+0/JiSIQltsuHHlJPsMjUxWI4b0kqOzkW41Kfb3hDMeMyhAgwqnF4WoEW56EX8dJNgXfolqbL3Mp9YO6FfZQ9DiyVVCNPG5RqoSqnHooLuf8HeO/GZjRmwABZqZO7IhDKJuLJ5XxottnqvO05uHZSEazc2zegRX6qaOmMC9k09LvQAG23OI6greZXxDddvXBRAF/e7JSZ7hRejmcCPiBLKR6zmJeAseR4DPCmwUjN7hY67oWK9CD/1JS4Iw2J3UqHtQay/dhPOlCZMYn6R4+sxAxVYJpSFpXpxQOkW2/3tGM9iN/4tTYX6k+ML3rK6llk8BL0xMtCX+FWqeXW3c16M9rSfeUxPc3LmxTPaviZfAmJtpSt8hsiAU
 /raCWH0s
 HZKdWjp3i0NwQ/DCkcopVnVsZ4dQ/4+36RzuwWc6g/r6Jx8cLhIYBUCey8MedOSedez4UeeQXCYwU8o9OO4z5JNQKPsVNMpgmYHJzvt/aGiPF2FcCyR1kuhGEjRiNRhg+5TU3TEq1n0RxBIiHHiNunP73rjBasOwPJ+1VKckmbJeTsjTWJyFzdyHkkLgNhbKj+Ds+deW7zVtxGDE0AZdAtmgFy2WTmarBxc3AUMBcVEbN0IYoLd1NBVa2lsn9CyiVT0XL73O0LUMlClXsU1ftC55Jy/PnwlFbBsE7fslT3XL64CIlP5Kp8si6ysRJ2ZGsDzRApGSPVNoOQuCJbXI5CKluEKkmJRob4Bk1zAapC+5WT/Srw5OxnVwqtwym8eNTeYq8au9V/czhi2JkJpYe3B43HBLWtW+JHBw5gN2Oi7kClOskLIn2aq+EECuW6PNSCzrP2W9GeJVOuCsJAEvU7Vky73SIhznzhmVoJn8u70V8UNmCj2bIzpDT6jwqTUxLXKn7oxEhcTzk4nxrW81/BqJCZNDqZC5gy1LX0iDGJ1TeiTzJ1Tf5Oqo3iWMGgP+ukyc+YOMbJxao3DHfdVYkOjp3kAQtwkiG1QPHCHhgqtOqCuWpZH73OykvBW7MQlXPNxg0bv8RLQt2JrykYgrDrioRpNz3r99ZQWRAp07JMIxrGxSeglbq0kAzbZlwd3zBoZiX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/27/26 1:55 AM, Andrew Morton wrote:
> On Sun, 26 Apr 2026 23:57:42 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> 
>> Hi Andrew,
>>
>> On 4/26/26 6:49 PM, Andrew Morton wrote:
>>> On Sun, 26 Apr 2026 01:17:25 -0700 syzbot <syzbot+7d60b33a8a546263da7c@syzkaller.appspotmail.com> wrote:
>>>
>>>> Hello,
>>>>
>>>> syzbot found the following issue on:
>>>>
>>>> HEAD commit:    6596a02b2078 Merge tag 'drm-next-2026-04-22' of https://gi..
>>>> git tree:       upstream
>>>> console output: https://syzkaller.appspot.com/x/log.txt?x=12483702580000
>>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=24c8da4692f901cb
>>>> dashboard link: https://syzkaller.appspot.com/bug?extid=7d60b33a8a546263da7c
>>>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>>>> userspace arch: i386
>>>>
>>>> Unfortunately, I don't have any reproducer for this issue yet.
>>>
>>> argh, that dreaded sentence.
>>>
>>> Thanks.
>>>
>>> Something's definitely amiss.  This is at least the fifth report of
>>> rcu_read_lock() imbalance post-7.0.  Others:
>>>
>>> https://lore.kernel.org/69eab803.a00a0220.17a17.004a.GAE@google.com
>>> https://lore.kernel.org/69eab803.a00a0220.17a17.004b.GAE@google.com
>>> https://lore.kernel.org/69eafb0e.a00a0220.9259.0031.GAE@google.com
>>> https://lore.kernel.org/69ebcbe2.a00a0220.7773.0005.GAE@google.com
>>
>> All the kernel configs mentioned above include 'CONFIG_MEMCG_V1=y'.
>>
>> Theoretically, a rebind_subsystems() can lead a rcu unbalance, see my
>> previous discussion with Shakeel for details:
>>
>> https://lore.kernel.org/all/358c60e1-fa91-40a1-9e00-84c93340c04e@linux.dev/
> 
> Right, that looks similar.
> 
> The rcu locking under lruvec_stat_mod_folio() is very simple, and that
> return in get_non_dying_memcg_end() does look super suspicious.  Why
> does it omit the unlock?
> 
> otoh, in
> https://lore.kernel.org/all/69eafb0e.a00a0220.9259.0031.GAE@google.com/
> we're trying to release an rcu_read_lock() which isn't presently held.
> But if cgroup_subsys_on_dfl() were to become false between the
> get_non_dying_memcg_start/end pair, that's what would happen.
> 
> So yup, I agree, concurrent rebind_subsystems() activity could cause
> all of this.  The reports are pretty common - is there some debugging
> patch we can temporarily add to confirm this theory?  And/or is it
> possible to cook up a selftest which will trigger this?

I've been trying to reproduce this locally, but unfortunately I haven't
succeeded yet.

> 
>> However, in a production environment, this is practically impossible.
> 
> Can you expand on this?
> 
> sysbot isn't a production environment ;)

Rebinding only works when the hierarchy is completely empty. This is
generally not the case in a production environment (e.g. when systemd
is used).

BTW, it seems rebinding is about to be deprecated:

cgroup1_reconfigure
--> pr_warn("option changes via remount are deprecated (pid=%d comm=%s)\n",
			task_tgid_nr(current), current->comm);

Also, it appears the current memcg subsystem assumes that
cgroup_subsys_on_dfl(memory_cgrp_subsys) cannot be changed at runtime.
(Please correct me if I missed anything.)

If we can get a reproducer, we can try the following fix, or simply drop
rebinding altogether?

 From 6ae41b91339625dd7bf0f819f775f26e78171a73 Mon Sep 17 00:00:00 2001
From: Qi Zheng <zhengqi.arch@bytedance.com>
Date: Mon, 27 Apr 2026 11:20:21 +0800
Subject: [PATCH] mm: memcontrol: fix rcu unbalance in
  get_non_dying_memcg_end()

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
  mm/memcontrol.c | 30 ++++++++++++++++++++----------
  1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3d98ab41f1f1..46ff40faf295a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -805,10 +805,15 @@ static long memcg_state_val_in_pages(int idx, long 
val)
   * Used in mod_memcg_state() and mod_memcg_lruvec_state() to avoid 
race with
   * reparenting of non-hierarchical state_locals.
   */
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
mem_cgroup *memcg,
+							   bool *locked)
  {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys)) {
+		*locked = false;
  		return memcg;
+	}
+
+	*locked = true;

  	rcu_read_lock();

@@ -818,20 +823,22 @@ static inline struct mem_cgroup 
*get_non_dying_memcg_start(struct mem_cgroup *me
  	return memcg;
  }

-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
  {
-	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
+	if (!rcu_locked)
  		return;

  	rcu_read_unlock();
  }
  #else
-static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
mem_cgroup *memcg)
+static inline struct mem_cgroup *get_non_dying_memcg_start(struct 
mem_cgroup *memcg,
+							   bool *locked)
  {
+	*locked = false;
  	return memcg;
  }

-static inline void get_non_dying_memcg_end(void)
+static inline void get_non_dying_memcg_end(bool rcu_locked)
  {
  }
  #endif
@@ -865,12 +872,14 @@ static void __mod_memcg_state(struct mem_cgroup 
*memcg,
  void mod_memcg_state(struct mem_cgroup *memcg, enum memcg_stat_item idx,
  		       int val)
  {
+	bool locked;
+
  	if (mem_cgroup_disabled())
  		return;

-	memcg = get_non_dying_memcg_start(memcg);
+	memcg = get_non_dying_memcg_start(memcg, &locked);
  	__mod_memcg_state(memcg, idx, val);
-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(locked);
  }

  #ifdef CONFIG_MEMCG_V1
@@ -933,14 +942,15 @@ static void mod_memcg_lruvec_state(struct lruvec 
*lruvec,
  	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
  	struct mem_cgroup_per_node *pn;
  	struct mem_cgroup *memcg;
+	bool locked;

  	pn = container_of(lruvec, struct mem_cgroup_per_node, lruvec);
-	memcg = get_non_dying_memcg_start(pn->memcg);
+	memcg = get_non_dying_memcg_start(pn->memcg, &locked);
  	pn = memcg->nodeinfo[pgdat->node_id];

  	__mod_memcg_lruvec_state(pn, idx, val);

-	get_non_dying_memcg_end();
+	get_non_dying_memcg_end(locked);
  }

  /**
--
2.20.1

Thanks,
Qi

> 
>> So Shakeel and I chose to wait for a reproducer at the time. :(
>>
>>>
>>> In some cases we released it too often, in other cases we failed to
>>> release it.
>>>
>>> The first one is slightly more useful in that it tells us that the
>>> not-released rcu_read_lock() was taken in folio_lruvec_lock_irqsave().
>>
>> I double-checked some callers of folio_lruvec_lock_irqsave() (such as
>> folios_put_refs()), but didn't find anything suspicious. :(
> 
> Right - it's rare and smells of a race condition.
> 


