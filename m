Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB45CC61DDE
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 01:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739F16B0088; Sat, 29 Aug 2026 21:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAE66B008A; Sat, 29 Aug 2026 21:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 600D66B008C; Sat, 29 Aug 2026 21:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 31C8F6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:09:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 800C4160211
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:09:02 +0000 (UTC)
X-FDA: 85156151724.14.29A97BB
Received: from mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 601B41C0004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:09:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GeOwfDfy;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788052140;
	b=YkM5oIETFhRsfxuZljMOJv1iDGcnMxwTGl99MZS9AJQ1NmQCEjuSegP/8Yo1lXSmiKA16/
	FS0TlThwcy/GIG8KIW3sapgisT3O5zy8RHvl6ww9BN4zBwj2uKme6F6tNBPoJXOziWesqY
	r0Dm4dCjv9A1iXOlgKofznFsIDWAaf4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GeOwfDfy;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788052140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MemJbyD1rNuhRtJidyufZey4/RKnPBw7+b75T/wrLR8=;
	b=s6pt1CLPDl5ZMQ2Y0KRpW00LEkqA9PVrpdrndSIm7UTrrY2+HwbsrP3jw2iWXteWIL7TgU
	SyIvLpy1DE3L5PuYP8Z3KQOJ11ATUXuXhbcRkcHT99LCK2ozY9nVuM17eSJRAwoplQ/RHn
	eRGBOH3TrXp4Axu1xoTC5qef5vGlcPw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DZzcjJc9sLyv3Y9LU9lZskwia54d44A48WITPmc1pDE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788052139; v=1; x=1788656939;
 b=GeOwfDfy2MrS8fMyfogCrRSgyRyaiENzf2yxtgQ8WDhmKHHFhfCDB5BfwBLDKQYrrtbRFe+8
 DhslNlByOsXD32mnyEt8m0jYRT8vcK319d2tuAAIxuhXOVC0ivakIsu1As6A1ipzHFFV7D2aVvK
 fNlCpiheVjkXFC2sej4cfkHw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 38fa7b8430628112;
	Sun, 30 Aug 2026 01:08:48 +0000
X-Mizu-Trace-ID: 38fa7b8430628112
X-Migadu-Flow: FLOW_OUT
Date: Sat, 29 Aug 2026 18:08:47 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, hughd@google.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <apOAF5CPFWUUH9du@linux.dev>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
 <apNjw0HRyr1Oj7q4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apNjw0HRyr1Oj7q4@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 601B41C0004
X-Stat-Signature: j1ex63g6pswmi8cwipa1bhpw5j5cbxzk
X-HE-Tag: 1788052140-250312
X-HE-Meta: U2FsdGVkX18n9+nBHfkK2R8IASdrIbsUxiyASGt/1OfYHUwLYe+3XTmZpndyP/X+pTHo2VILsg65kCwd+hVNP0GdFpmDrplW5pQjvxtocenvaCFpBclyni7TDJXACmeIkFHPnZKEj6ozzI5LkDwdhnTthJjFUoGApvRzgWzlyKt62OE1zcQcTF7gR8IYQvd/FfWtaOsyoHJAoJsj0k+liZZLeAOAYvTUh5VcQQiJAUaq70ZUfSDiXxsldvLEiFNGKaI112lrkvLDcwplTPE1AIDcHwDaIFs1XNl+lmJBZbz0LitdHzlBPb76tBEaDbm0+gcxe1/HP4Foqd0+87DFTt4k3kM472W2+Su/OL3GI/Gq6emKMEVGC74m9XNR48VrGJq7mJRAaK8XXo1wuYEymABHIijApHu+z4MizXnLohX5m4PZGK40q54Bfthhcu2uHJDGyAxbNl2oeqecHUDA3M17QnQPRdh0JiykpH/Wzgsz4xdJiryuhbosjXbVpwPWRYwGwn5JEZTyIr+zTYMV0YuRc1V27GR9cmEvQYNEbUsG+UC7+XNOndQlwlShjDc+J0Qb+MbjX1cgfMTm3BO8Xwa41zPWQ3zApkoU5OAUla3u4HSsasqTBtArIHdU1YqEAIJMznDukN1weWFia+LIO37BX4TQemo3wtnzYQoky1aH+l3IE2S141IncnzI+2o+FCgtCYxz7xIzn8BQ3GJHxtUKOAOHeEvMQiLKvoM0JvrYTryQZFF/+lFHak36Z9d4w2lzRFQyK33n7NzVs9sVbs9BIdlUw4oN0m8UIt/ILCY+2eepYJ6fw/SUTHLpAz52KNuRtMGa1XnGjfGSoBZykNDoGzhEHuMg9cDcgZ4ZqA9H4oXwxmLQ5NlPk8RWCZgT2cWj9cbIQKiklO24h1dgLLNkvXO1Cn1syGItJ9n/6WudjtxQzI16H4iFoZ/K/kTX6GxHBd3u8b0rsoE44Td
 EeM+5EpV
 lmrXtc+p5NI2gQFEFMDSzDZQ7jo4DBnMRhmqOrIJYDjR2v0JwqvMZvCtz0QgASOfscklglQ7Ex5qJ6AqBWQlg9msgrx5GN4qrUMrbNe54BIYe2p3s2sH8W3HXFkXI2FyGjRGv9CUBnV3f0nZltURCYzIB9s+UqPQjUmvC51FpNsZVfmMYOx0e3hQH5i0YNbu2EJD4q9MLg9wbmdup8bCQK5YX91saDOWdmUNH9ffZkMt/QBBvu9aYIp1TNVVqUN6cLnFjuYeVrlPb8DayAxhNSqMIxu8F9rftlgMP63FxsHv50yE9GdacjVhmqKZ7hZYufzL3SvLS1W425dyevV7uIu2vqaA/ZqtQ6aVYgtpTqGegXEmRHVrh/WxxbUASRDCVRM0JpFEIrprXDjrjCxrxwL/Nx1QomzbZhj9cvw0L5ezZI3K4ipjur+59un96Nn5WTC6fVDZLOshVU6jLGBh8AaOIRocxUbzEXtShSfyzilk8mlcQKq8K0Soq+aQJhEqc8CAaIPZHtauNmFNAmputk3Y5iSeVXY8d6iHpO+IZdbb64iDuarzPt3R2k8BLOJS1mFhHXa+k8z+Es4Mw0lH5sjNxqdN1UHHYAmw4VCU8onTdlB3/DKuOgU13O4WEVomHvnhA2RwAyMV6k6C7kbGUPB4zrH9fFh4poorRmwJ4VkMNBtCuXjmbAM7gu2lHFKhbN5ifLBiFqgSGWoNy67vTqQMzblO21IijeQ0TNY0HP6UFMbLTULMsHN4APg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+hugh

On Sat, Aug 29, 2026 at 04:03:35PM -0700, Shakeel Butt wrote:
> On Sat, Aug 29, 2026 at 10:52:26AM -0700, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > console output: https://syzkaller.appspot.com/x/log.txt?x=10286d79580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> > dashboard link: https://syzkaller.appspot.com/bug?extid=cd2073ee6d958a8d0fcd
> > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cf7625580000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
> > 
> > smpboot: CPU 1 is now offline
> > ------------[ cut here ]------------
> > IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
> > WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0x96/0x190 mm/vmstat.c:361, CPU#2: syz-executor412/6040
> > Modules linked in:
> > CPU: 2 UID: 0 PID: 6040 Comm: syz-executor412 Not tainted syzkaller #0 PREEMPT(full) 
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > RIP: 0010:__mod_zone_page_state+0x96/0x190 mm/vmstat.c:361
> > Code: d0 00 00 00 8b 05 3e 44 ea 0e 85 c0 74 1f 65 8b 05 87 e0 2e 12 65 0b 05 d0 99 2e 12 75 0f 65 8b 05 d3 db 2e 12 85 c0 74 04 90 <0f> 0b 90 48 c7 c7 c0 e7 ff 8b e8 3b b3 6d 09 65 48 0f be 5d 00 48
> > RSP: 0018:ffffc9000627f8e0 EFLAGS: 00010202
> > RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff2287150
> > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88807ffd79b8
> > RBP: ffffffff9489f448 R08: 0000000000000001 R09: 0000000000000000
> > R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffffffffff
> > R13: 0000000000000008 R14: ffff88807ffd7940 R15: ffffffff9489f440
> > FS:  00005555785ce400(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00005608d531ffb8 CR3: 000000002cb7c000 CR4: 0000000000352ef0
> > Call Trace:
> >  <TASK>
> >  __zone_stat_mod_folio include/linux/vmstat.h:410 [inline]
> >  __munlock_folio mm/mlock.c:144 [inline]
> >  mlock_folio_batch+0xf97/0x36e0 mm/mlock.c:204
> >  mlock_drain_remote+0xe5/0x140 mm/mlock.c:230
> 
> So, we are calling stat update functions which requires preemption disabled
> (because they access per cpu data) an offlined CPU which is fine but we have
> warning that preemption is not disabled.
> 
> Let see if syzbot comes up with a reproducer. We can just simply take the local
> locks like neighboring functions or something else.

After looking deeper and it seems like __munlock_folio is the only one which
have a code path where lru lock with irq disabled is not done before call
__zone_stat_mod_folio. I think we can easily fix __munlock_folio without
acquiring local_locks here.

Something like below. I will run some tests before proposing a formal patch.

diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..9ab8042671f1 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,11 +141,20 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		enum vm_event_item item;
+
 		if (isolated || !folio_test_unevictable(folio))
-			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
+			item = UNEVICTABLE_PGMUNLOCKED;
 		else
-			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
+			item = UNEVICTABLE_PGSTRANDED;
+
+		if (isolated) {
+			__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+			__count_vm_events(item, nr_pages);
+		} else {
+			zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+			count_vm_events(item, nr_pages);
+		}
 	}
 
 	/* folio_evictable() has to be checked *after* clearing Mlocked */

