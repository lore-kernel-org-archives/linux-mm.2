Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D997C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFEE26B009E; Sun, 30 Aug 2026 01:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0166B009F; Sun, 30 Aug 2026 01:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EC7A6B00A0; Sun, 30 Aug 2026 01:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 740E76B009E
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:15:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E4711C16F6
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:15:25 +0000 (UTC)
X-FDA: 85156772610.10.B330D17
Received: from mta1.migadu.com (out-28.mta1.migadu.com [95.215.58.28])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF749160002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:15:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cd2tm3y1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0D1AWf4KzbXcCA4PdDmSuSOslQXY6/j0QDBlsJSzOjQ=;
	b=M/wYka3Gm/d7oNzLQCCmjtc/yC4VPgpFxN7PZrbTTWLsNGM5AWi6UHjXZbdDDZ5B1yzlaD
	iouKXFLfcFqeVn5XpAvZV2cEgJ+YudfheaZuY/sZGp3pAVqwMcoll3NkSCy5KIagEmIrcL
	sMOIk4ZVrEb5aPEsRq/FIFwAj7q2KuA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066923;
	b=rNY1rFMlmD2EOGUYz6ttaELrOlpvVbapy0xpI5EF7GwjOxK1KS3MOyOK6cPLY+VOo4H3Wo
	MdBLc6Y3ZHTfPdTVwmC9P2he8btxJuLH7z5H1yqcUZs3LyyUE/TuuBQRF1k1uHkyiInLlW
	rb/3q2e69qWdsD+R+t0gPFVOHVIM054=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cd2tm3y1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.28 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=HiW3d3TplfCxceccjWG6SJ1prOMobAwhNnC0vLXjVus=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788066921; v=1; x=1788671721;
 b=Cd2tm3y1EINfQQ5kESgQ13jGNKOcb1G4Eu6EFx1AIXhugCig36Cjjwl9I4gpLn3JBgAThXWr
 uxjHoVzJlgixBrtJKzQ4Xb0jK3Eu4mdL74N34k8Bbiz//xkgWbX+6E6CJv+MI781BtoUUVMYjW7
 Uww7aIKwbhjFqx55Qxk/UKkM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 13f0276adf91ee9f;
	Sun, 30 Aug 2026 05:15:11 +0000
X-Mizu-Trace-ID: 13f0276adf91ee9f
X-Migadu-Flow: FLOW_OUT
Date: Sat, 29 Aug 2026 22:15:05 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hugh Dickins <hughd@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	syzbot <syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in __mod_zone_page_state
Message-ID: <apO7GDwIgyhdn3t7@linux.dev>
References: <6a931c5a.08e933ee.dbf97.0093.GAE@google.com>
 <apNjw0HRyr1Oj7q4@linux.dev>
 <apOAF5CPFWUUH9du@linux.dev>
 <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2288e73-5001-2104-1e7a-2b383e7edd61@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF749160002
X-Stat-Signature: nh6s9ruca94mygi9s3u9wzciwq1z5o7q
X-Rspam-User: 
X-HE-Tag: 1788066922-358973
X-HE-Meta: U2FsdGVkX18eF0Uz+BzZLOLYmp3tW2OQgVBzT2wjn93Gbnj0NexekJKqesezvogACiDgiaIXXIpn6wnr5nAwIr6Qi33h5xR+z8uEUrbRB0ilsFwR4YAdktAEDfZJnTooQY9v1fOgRADRET4xCH5n1JifzvF8tMp+lLhwx5g2nHvD9W/2apxjofJbwyc3Qb3zQpeVhbBU2pb3F50tZ6fBgXRiwipw/ljXKwz3dCn0kHVB7OH/bfh/PMyuHnA/KIi0eJX0P3Ze4F3q0BRm4f7Fn3z2PMinMRwQWokBHK4C4aqHKU2FDoJ5RSdDYRvNZXXxKKR9jG6uJChcjHW6w7HbKBO8tVroN9BrMnagtEOPD5bOZYKl9653HKoKqm1gxWM9/udykxCPFagZ0g2wpwEAc/b2+LCxfxTwPFwzKPxXAu3+/bLEIr9qLq/OuIzhD/DJT1sJsZjn5sS2eJMuSS3VF6SwG4vfkiopvq7R5NIahtXNu0nTcekS9AJgIhvpOJKz5AremiTcGs3CNsHaTDu30GSFLiPXwYqUzOBkz5Kku6QnB8ktjQi/NAeAgRqkhIO6JGRcx/c4YAqzSWpIedc+5ucljesfvUpvYJDPlpM4lZelPhO9uPe/cCrKATlQPdkzBKOakdsh986cf3OlyK9gI1fjAMWFrJffFjbYz94jcz42/G+0HhDC2uyNCb5TZCKoKFRa0hwgVgMPxZDMZQbe94F91pMs/h+l+oHbQLCPbLqAPqxpDFzHtCmDvRbC00imcfoEpp+7vDemmeX+CuMInin/SdRT52AIDlMw+LR8CJIvAZ3MQPV1ijBVP5D8kWoGPum57hhgo0qGh4R6OdvohQNBQIkYCWm1QegPj96wvY6hWkexbvBTj4U9BREUxapwOy64iZ9KWeldenUH0arI/FKH49N+ELGPxf4/GIbV/zmIzuU20DTpanMqgdMnZKvTvu0CkbsBTvc9QEvCFcN
 XbHZIFBi
 vhu70ChCaMwX/p0kLWYaqXeNGdQQzvPz19x0AYPCLtSm0EdHx/UOadh4o3IvVkzqcy2CZPm72x0Qri0bfXt4Y9pcNnSrfXOwi3HUP7hoC2ZbjFVnuC+n5qnd0w1xeVFMPRDXhCtdAA79wFRufCGLxdYEGNLqtpTEGLCoNmbX+csAC0Fy9RWI9TueZU9cLVvJoDJyl7lLuI3WqFogiwaJUv8aiV9rIAso3NFJO+ITnQHFKeGRI/KSfM5sgQFssmkmWICGUvVlF1HkUi1N8I6UYI5hKywV3N3cC4vhR45T4LKmUxpofscAhp1iypTcjmoViqZ57f97GS5qbMMTvUvJsjxqfDzlfKM75qMGIK7SMp1+vhESDzq2PI1TxTj47y0Lg12siFK7NhPz0uSH+Y54OmOx6Tqh+2JpYFmDtMlHEtU4Rc3XbPlGcmu6qF+uKraBzgFwuYMtoznE+8pV+AmTnzJH7QHu9uDb6QmeeP86fKTAg4ir7NvEGYuOi3mx64dXCRrFJQzNdB1duphu5YLsz4gCXhovzm5PZ1Wl7UEsvp4mdIOE9oryZfPAMa450qQDYy8Fssoun+aIj9+1cPMLFgwNRvz3TruE7uSsnpmSs85lHZkJhkUgSZ3zoVp3w64Rvzu7CPH2CoWLtjI5arm/BmvafUcNfL0BcABWphkSiyMo4px18vXjO+x45RGzGNdCwaMKHk+h1zKZcb08wodWNKDUaOVFvETEjnGhqd45GsSlbZmgu5ce1Ny8RAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 08:26:02PM -0700, Hugh Dickins wrote:
> On Sat, 29 Aug 2026, Shakeel Butt wrote:
> 
> > +hugh
> > 
> > On Sat, Aug 29, 2026 at 04:03:35PM -0700, Shakeel Butt wrote:
> > > On Sat, Aug 29, 2026 at 10:52:26AM -0700, syzbot wrote:
> > > > Hello,
> > > > 
> > > > syzbot found the following issue on:
> > > > 
> > > > HEAD commit:    818bebeb63dd drm/xe: Don't hand out the flat CCS storage a..
> > > > git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=10286d79580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=ccca94d2c01b9e78
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=cd2073ee6d958a8d0fcd
> > > > compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13cf7625580000
> > > > 
> > > > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > > > Reported-by: syzbot+cd2073ee6d958a8d0fcd@syzkaller.appspotmail.com
> > > > 
> > > > smpboot: CPU 1 is now offline
> > > > ------------[ cut here ]------------
> > > > IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
> > > > WARNING: mm/vmstat.c:361 at __mod_zone_page_state+0x96/0x190 mm/vmstat.c:361, CPU#2: syz-executor412/6040
> > > > Modules linked in:
> > > > CPU: 2 UID: 0 PID: 6040 Comm: syz-executor412 Not tainted syzkaller #0 PREEMPT(full) 
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> > > > RIP: 0010:__mod_zone_page_state+0x96/0x190 mm/vmstat.c:361
> > > > Code: d0 00 00 00 8b 05 3e 44 ea 0e 85 c0 74 1f 65 8b 05 87 e0 2e 12 65 0b 05 d0 99 2e 12 75 0f 65 8b 05 d3 db 2e 12 85 c0 74 04 90 <0f> 0b 90 48 c7 c7 c0 e7 ff 8b e8 3b b3 6d 09 65 48 0f be 5d 00 48
> > > > RSP: 0018:ffffc9000627f8e0 EFLAGS: 00010202
> > > > RAX: 0000000000000001 RBX: 0000000000000000 RCX: 1ffffffff2287150
> > > > RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88807ffd79b8
> > > > RBP: ffffffff9489f448 R08: 0000000000000001 R09: 0000000000000000
> > > > R10: 0000000000000001 R11: 0000000000000000 R12: ffffffffffffffff
> > > > R13: 0000000000000008 R14: ffff88807ffd7940 R15: ffffffff9489f440
> > > > FS:  00005555785ce400(0000) GS:ffff8880d5da2000(0000) knlGS:0000000000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 00005608d531ffb8 CR3: 000000002cb7c000 CR4: 0000000000352ef0
> > > > Call Trace:
> > > >  <TASK>
> > > >  __zone_stat_mod_folio include/linux/vmstat.h:410 [inline]
> > > >  __munlock_folio mm/mlock.c:144 [inline]
> > > >  mlock_folio_batch+0xf97/0x36e0 mm/mlock.c:204
> > > >  mlock_drain_remote+0xe5/0x140 mm/mlock.c:230
> > > 
> > > So, we are calling stat update functions which requires preemption disabled
> > > (because they access per cpu data) an offlined CPU which is fine but we have
> > > warning that preemption is not disabled.
> > > 
> > > Let see if syzbot comes up with a reproducer. We can just simply take the local
> > > locks like neighboring functions or something else.
> > 
> > After looking deeper and it seems like __munlock_folio is the only one which
> > have a code path where lru lock with irq disabled is not done before call
> > __zone_stat_mod_folio. I think we can easily fix __munlock_folio without
> > acquiring local_locks here.
> > 
> > Something like below. I will run some tests before proposing a formal patch.
> 
> Thanks for looking into this, Shakeel, but I don't think complicating
> __munlock_folio() is at all the right fix. This is peculiar to the use
> by mlock_drain_remote(), isn't it? Which is not taking the usual local_lock
> because the CPU is going offline. I would say, just take the local_lock in
> mlock_drain_remote(), but (I haven't read the history) for all I know,
> there may be PREEMPT_RT reasons why that would be completely wrong.
> 
> Hugh

Thanks Hugh, I will explore the local_lock approach. BTW I simplified the
fix to the following. is this still making things more complicated?

diff --git a/mm/mlock.c b/mm/mlock.c
index efa6716e4dfb..fa30ffed76ab 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -141,11 +141,16 @@ static struct lruvec *__munlock_folio(struct folio *folio, struct lruvec *lruvec
 
 munlock:
 	if (folio_test_clear_mlocked(folio)) {
-		__zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
+		/*
+		 * This runs both with and without the lruvec lock held, and
+		 * mlock_drain_remote() reaches it fully preemptible, so use
+		 * the accessors that serialize themselves.
+		 */
+		zone_stat_mod_folio(folio, NR_MLOCK, -nr_pages);
 		if (isolated || !folio_test_unevictable(folio))
-			__count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
+			count_vm_events(UNEVICTABLE_PGMUNLOCKED, nr_pages);
 		else
-			__count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
+			count_vm_events(UNEVICTABLE_PGSTRANDED, nr_pages);
 	}
 
 	/* folio_evictable() has to be checked *after* clearing Mlocked */
-- 

