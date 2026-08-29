Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71A6AC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 21:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0B5F6B0088; Sat, 29 Aug 2026 17:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBC206B008A; Sat, 29 Aug 2026 17:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD2866B008C; Sat, 29 Aug 2026 17:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC5A6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:58:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01509A285D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:58:42 +0000 (UTC)
X-FDA: 85155672126.30.E1C260E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A2FA40004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:58:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f2h2yJOG;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788040721;
	b=CibWAqBoQ+Qb06xqywPJ6dyfeAKgb1uy9EYq8Fn4FuLGsLNazcoPemo3l89nLUGTdRiz6/
	wD0H8fF702rn8qhGMmL3P7tTcwKBu87gN34WpQV49vwQPhpAE4Ot+fMZCJo33MrH/8JVnv
	qu43GliJcQ1MTaOt0jcaNI+uhNYe6H8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=f2h2yJOG;
	spf=pass (imf04.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788040721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdp2KYYF/8DbOvF5byyXuFVlInYv4CiLt0saQi9aJsQ=;
	b=dOS7p6tH2Wa9zUxr4fmbe8q5bB4AClrIu/wAV14tPxo6/Bmcxl201G2urwR/NSbDodgcWv
	gLwcwve/ecf7xJYMlqly+d2oGXcnHBzNkurWzRbngBIjR2dHjLmvSLzoiHDkngZLECvm9k
	4+sPNietQkEpnKzRaupEAbMsAzsQ9o4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D459143A2A;
	Sat, 29 Aug 2026 21:58:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 405321F000E9;
	Sat, 29 Aug 2026 21:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788040719;
	bh=pdp2KYYF/8DbOvF5byyXuFVlInYv4CiLt0saQi9aJsQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=f2h2yJOGpiZ7jQWOsex1MBBGzJDL2xe4GDMoiuttXJpgCWkVoS9zQq2EmHbs5TauG
	 DTTp0Jd6w5/lSnMX/1ECf7h1m1rL98R6Co8g5recVRUDuTclbhBlFj0jRL2zkJknFw
	 CYjzl9QlkJNzQLNUaJkI/JVrDPdgQW5bEhjAehNg=
Date: Sat, 29 Aug 2026 14:58:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com>
Cc: dvyukov@google.com, elver@google.com, glider@google.com,
 jannh@google.com, kasan-dev@googlegroups.com, liam.howlett@oracle.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, netdev@vger.kernel.org, pfalcato@suse.de,
 syzkaller-bugs@googlegroups.com, vbabka@suse.cz, Junjie Cao
 <junjie.cao@intel.com>
Subject: Re: [syzbot] [mm?] INFO: rcu detected stall in __mmap_complete
Message-Id: <20260829145838.19351db0a28b30b7ccc1b295@linux-foundation.org>
In-Reply-To: <6a934778.4d659fcc.734b4.002f.GAE@google.com>
References: <695aefde.050a0220.1c9965.001c.GAE@google.com>
	<6a934778.4d659fcc.734b4.002f.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A2FA40004
X-Stat-Signature: yhc1dognqp1xc8h8y8utz49ic1bon6se
X-Rspam-User: 
X-HE-Tag: 1788040720-676844
X-HE-Meta: U2FsdGVkX18VBpqPPOVoBY1SktUPFgQN2bP0feKzmdj5G5sXiceqrYnp+RlvJqUYRpWN/Go92I4ib7RXBBtrjIe4Z0M+YfWfjLFiURKrSu5+ni8ecsPAO4t4KnnNItEqW2r6SlvMzYNDTRyH0gbcbQtUqjzPOpulf+vrZvb5bY4hoP5nVy0FZReJM0X67NVJUzwMf0YWz1hb9j2AoqwGRc8J8+iIdDtX9FRPhNqzYiUqsO3FBwwun+aYh6sGBRReENwLYSEiEyoW4cjj7BHgIY/UCq0/0H6nqSEdb6QNRlComxyrRdWpZhYqqs+eMT2CXve2Cj2Ks4deLSgcaEOWArsZPgO/GB/U+R0LbLplIUhJ1oQC2OQGniHXt4BYRT5H0Xfl9BJpGDI5Y3qV/q5/FT2RQj073FuvnjExICfhdFszblelJz8Na9C8di5BzFbITQONx7WyN8OsJTGOwOsm1Z4qRFPe3tYic5eiPSbDxqv0iTyW4Def6pQ3ygd3GYRmBMVAhRLH38qdlGfmhzwC/Yve+FcB5l5bVMweSOymGHbwvuU1VDimOqebtvYt+cVrA+1t2LoENwVU/9chVyv2eZdBRpKSUNjrAuOI6nRHrOh+VrhkUx+QiwY0NbOvxrARv2uXs62e39GQJRvczc36B2vZUY2U7U8GDrIiuAobRF/8UaHLXWu1IRK45GvQnAfZTfHEUwd3AcwquhZNRCL/fLK7Xbh866Rqnr4JRVTXWarkwrr/8XkYohDZcOoEGEdfpC8Rd5a1ta+XP61pr3m5DIF8eeFCvXVNMNsBj1rCZ+8eObGOnknKDEbCiwghmMmOA5rIdiM8bSlUUnGOaEMr5DkA5do4XIemN0cb0P/Z0wBDeAUuOrhgFAVQhNb63hFbGwYE19Jpr5SujwKdufJpKP+WCOWxvH/eiWEQCYp7WJ/qcTcfya1b3gi59qZXUpI5pgbGydwFTIGWkFuys5a
 9yjU39GF
 6QZITJNLVsYy3ctEv70UZEedFlPihvvEiNR3Iffy0IOnNzqWadn2ZI4i+c0lzMabHul35AccIAYppHiqistUG+fSzvPZwgoaZ0/4LPq2d/CclNdeCgJcOO+C49mPNEq7OW6ev/twDh2E/vgQKFqB9nrmjDm64JkTsIYYw/nVbMaz8U5hEH6yhGmsfo4OSzqZCX3/ybx36sCwcA9oiaTphKWjPO5VgUi2pJjFjRuzQXQBIhDQWCVYEmBTNhbdMBEZz34PTqVcStI6HgLoiYbKsV8EeHUFbXFoORTDXrwFp9D33CObbZLVRprUSdYZ8KQXRWwFiPZx20WA98I/TAcOEWs3MFSvxRbYW68AvAkpDWG01uY6gpcmI05FgsSW64FO2JeU5VXaL5PZH9l6mhFgiz6ctqKLLXRYQ8fVwbyuieOxU0nxVx6ntq1je6NQU2ERRnbX/x8x3mpTA1dDYGoO8U95PJH4+SfU5pnegHe14RHkxkdG416IZORBRR6N7K2bedlgA3CWs8Zv/Q0KrYha0+BxJbY6w4aVghy2PWwfI5leIWvbztF61EGqNQQKn77Bx7rdoQAgRiUwBEnNEIot7JQhqW98jaKlGxPRLPKjiO9KsJM9uI+fiqqFEuf+NfMxBTKl1rU/v9nRpO8BT4qLRZ42gzTvEZu6FGbiudJrtqXTy+0g0ry7xA256kZwuGB4MKdI+3Bij/M8lHDPjC9b69bm1op/AVzfztCw2nBmpYYECEpBQYT5iWieV9pHSHmfe7IMuttMw0olI4zC1i2yK1JDE6wK/KHArUqG7eMO4cTljvz4vThPPo21+gj2u76TVYedOki7qh8dcE+Iz5f2mbJYj6yQ88KTquBHj9YDpGWEOYBU6hPIkse4O62yIKNbkYF1QfdIhnmZAOpqG/1aZ+9fq7aylJbcsn0Q+e9LTnUkiR9b0vkm4nrAa4jlueszs1AN5S1znt3JNsFA/PcJpS/zMFtcw
 77462V79
 jcWvHNUfvtzf+6fB2YJh7r+EK8ydDvvGO8m6Er1/bPiHge9o4+9aRr2YiVVvAdtPvKP8YYsJJZ3ov/SZB3AoGl2LTEXCKUwVzE7P0eEsBWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 13:56:24 -0700 syzbot <syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com> wrote:

> syzbot has found a reproducer for the following iss
> 
> HEAD commit:    1b78070aaef6 Merge tag 'net-7.3-rc1' of git://git.kernel.o..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=154d7d49580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=5e4e3a0e188a497e
> dashboard link: https://syzkaller.appspot.com/bug?extid=e4aa91d7f20c34417d4e
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=134d7d49580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1177ae25580000
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/18856a03a9a3/disk-1b78070a.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/cc2bc68d7ef4/vmlinux-1b78070a.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/05a5e00f8f91/bzImage-1b78070a.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+e4aa91d7f20c34417d4e@syzkaller.appspotmail.com

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git main

From: Junjie Cao <junjie.cao@intel.com>
Subject: net/sched: taprio: catch up in bounded time when the schedule falls behind
Date: Thu, 20 Aug 2026 14:27:13 +0800

advance_sched() advances exactly one entry per hrtimer expiry.  When the
operational schedule falls behind - the timer was delayed, the CPU was
starved, or the reference clock stepped forward - every elapsed entry is
replayed back to back from hrtimer context with current_entry_lock held,
and each replay rearms the timer with an expiry in the past.  Once the
backlog is large enough the CPU never leaves timer processing and RCU
stalls follow.  syzbot triggers this with schedules whose intervals are
shorter than the cost of servicing one expiry, so the backlog only ever
grows.

Skip complete cycles arithmetically and walk at most one cycle of entries
to land on the entry covering the current time.  Gate close times and
budgets are still only computed for the entry landed on.  An admin
schedule crossed by the jump is picked up by the existing
should_change_schedules() check on the recomputed end time.  The walk is
capped at twice the entry count as a safeguard against degenerate
intervals; leftover backlog is then handled by the next expiry as today.

Link: https://lore.kernel.org/20260820062715.278124-2-junjie.cao@intel.com
Fixes: 5a781ccbd19e ("tc: Add support for configuring the taprio scheduler")
Signed-off-by: Junjie Cao <junjie.cao@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/sched/sch_taprio.c |   56 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

--- a/net/sched/sch_taprio.c~net-sched-taprio-catch-up-in-bounded-time-when-the-schedule-falls-behind
+++ a/net/sched/sch_taprio.c
@@ -916,6 +916,51 @@ static bool should_change_schedules(cons
 	return false;
 }
 
+/* The operational schedule fell behind, e.g. because the timer was delayed
+ * or the reference clock stepped forward. Advancing one entry per timer
+ * expiry would replay the whole backlog from hrtimer context, so skip
+ * complete cycles arithmetically and walk the remaining entries to land on
+ * the entry covering the current time.
+ */
+static void taprio_catch_up(struct sched_gate_list *oper,
+			    struct sched_entry **next, ktime_t *next_start,
+			    ktime_t *end_time, ktime_t now)
+{
+	int budget = 2 * oper->num_entries + 1;
+	struct sched_entry *entry = *next;
+	ktime_t start = *next_start;
+	ktime_t end = *end_time;
+	s64 behind = ktime_sub(now, end);
+
+	if (oper->cycle_time > 0 && behind >= oper->cycle_time) {
+		s64 jump = div64_s64(behind, oper->cycle_time) * oper->cycle_time;
+
+		start = ktime_add_ns(start, jump);
+		end = ktime_add_ns(end, jump);
+		oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time, jump);
+	}
+
+	while (ktime_before(end, now) && --budget) {
+		if (list_is_last(&entry->list, &oper->entries) ||
+		    ktime_compare(end, oper->cycle_end_time) == 0) {
+			entry = list_first_entry(&oper->entries,
+						 struct sched_entry, list);
+			oper->cycle_end_time = ktime_add_ns(oper->cycle_end_time,
+							    oper->cycle_time);
+		} else {
+			entry = list_next_entry(entry, list);
+		}
+
+		start = end;
+		end = ktime_add_ns(end, entry->interval);
+		end = min_t(ktime_t, end, oper->cycle_end_time);
+	}
+
+	*next = entry;
+	*next_start = start;
+	*end_time = end;
+}
+
 static enum hrtimer_restart advance_sched(struct hrtimer *timer)
 {
 	struct taprio_sched *q = container_of(timer, struct taprio_sched,
@@ -925,7 +970,7 @@ static enum hrtimer_restart advance_sche
 	int num_tc = netdev_get_num_tc(dev);
 	struct sched_entry *entry, *next;
 	struct Qdisc *sch = q->root;
-	ktime_t end_time;
+	ktime_t end_time, next_start, now;
 	int tc;
 
 	spin_lock(&q->current_entry_lock);
@@ -961,14 +1006,19 @@ static enum hrtimer_restart advance_sche
 		next = list_next_entry(entry, list);
 	}
 
-	end_time = ktime_add_ns(entry->end_time, next->interval);
+	next_start = entry->end_time;
+	end_time = ktime_add_ns(next_start, next->interval);
 	end_time = min_t(ktime_t, end_time, oper->cycle_end_time);
 
+	now = hrtimer_cb_get_time(timer);
+	if (unlikely(ktime_before(end_time, now)))
+		taprio_catch_up(oper, &next, &next_start, &end_time, now);
+
 	for (tc = 0; tc < num_tc; tc++) {
 		if (next->gate_duration[tc] == oper->cycle_time)
 			next->gate_close_time[tc] = KTIME_MAX;
 		else
-			next->gate_close_time[tc] = ktime_add_ns(entry->end_time,
+			next->gate_close_time[tc] = ktime_add_ns(next_start,
 								 next->gate_duration[tc]);
 	}
 
_


