Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFCEE9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:20:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A88D6B0088; Wed, 18 Feb 2026 08:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756056B0089; Wed, 18 Feb 2026 08:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67F646B008A; Wed, 18 Feb 2026 08:20:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53A4E6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:20:31 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0452884B1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:20:30 +0000 (UTC)
X-FDA: 84457636620.04.DFED219
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3DF83A0009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:20:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3nLyVaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3nLyVaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771420829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=YEKNNq6oUV+SSV/aFKVbooaESmUp/Dv23JqrzIIP1kI=;
	b=UgXSq1FFLuElvWelP6I71rRJ1XNgob1HO3o45a7Ut8gZZF8idlVsZ+C5FkY9BIu/MUoeIy
	ujXHrKbkNCe61a4DHQVygaDp10TymaEVXZIs5nQ9GjcwdZYQE5Y+Fks5OYjLcEJsfzLjYd
	60mjx3agIbTOjo60DhKT3CzHskbjf/k=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of 3nLyVaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3nLyVaQkbAL8x34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771420829; a=rsa-sha256;
	cv=none;
	b=Y01TwVcgAD8mLNGG6Xk90WjcTMYdemJ8Zan0CkfNJdtDj3403W/u+vAp0q+iXIxhY64C6V
	pvtqCMTnBkD8LdrOWasEV6iflHpUkrUSeT+Z0NyJ0Ad6e8pa7OTFdvjMEVCW9LsX/vDPiU
	fVjPlXT8/SrDphwCaK4tiy9nq86g3Ww=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-463a314b114so42472123b6e.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 05:20:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771420828; x=1772025628;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YEKNNq6oUV+SSV/aFKVbooaESmUp/Dv23JqrzIIP1kI=;
        b=hwbX/BGrFvydoGlUVyioLOLhEZ0TPyI1UG3OtRw6DKeYZzltOuJ8fIpcjso8cotSYx
         zjlzIgv8eoC2Fz/I1o9ZYfi6ZsOgywpRdH19elt/d9aenX12etAPj82FGQD/Js+cBqDh
         hXcN4gu9G5f+L18k8xatWZi5P54MPxiJRlC+FMWPGiuNwFIMbKtK++JxHLuzslQyYjCp
         KFo1OPe/OzVECt5pyFAJVqRU0qt0GPFjl8x20zRfJyM7VrbioT1JG9On8SExUDH+uZgU
         lIZvqCQNlQ0jii8VaWxQIJOb6KJY8FdsmyQ8Y9f2h+ykh5VGeZftDFBoqSpQr39p/3eD
         ZvOA==
X-Forwarded-Encrypted: i=1; AJvYcCVsBO2Ul7rpCBLMQ4YsVN71S9tlHDdjFeZrYp7KPjO64/0OBmxd738NiDf76W9WB7167y7wba5BYg==@kvack.org
X-Gm-Message-State: AOJu0YyH1v+pwkpU9hKNPbJejgDgtPntDxfky0YofSt3SkZNLnCgRE+V
	PDYhIFNzreBrN38whjHjc4RvNZppAk5YtMyRC4HvLx7WyN4+JoTTxhru0tBK0peY65UQCUvfvnU
	kjDISKlAeE4AC8xRFUc8LUxYvelvdecTJ27O5tX3HT4SWn1JhbUrM8hR1CmA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b05:b0:679:a4cc:e04f with SMTP id
 006d021491bc7-679a742d3a7mr953647eaf.51.1771420828171; Wed, 18 Feb 2026
 05:20:28 -0800 (PST)
Date: Wed, 18 Feb 2026 05:20:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6995bc9c.050a0220.b01bb.002a.GAE@google.com>
Subject: [syzbot] Monthly mm report (Feb 2026)
From: syzbot <syzbot+listbcf6e213aaf132e27830@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: g3yqcugtmin5t7bbka8u1uc15p77s6a5
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DF83A0009
X-HE-Tag: 1771420829-182483
X-HE-Meta: U2FsdGVkX1/SbUuxHBPCwReXl11GGFIQGAIFXAjjLzW12Uz8xVRW6xesMsXbfFiRg13N8SWGUq6VnNhQPYyiQRme1Ikz281vjDGjZuZafcJwTDVDMORuUaBxZ+TK0n3VJ3meI0inEZ1Bco+Bd7LZRSOd9CNbDD1zubglBcuAEg2DyN9FZ4Rn9w4OyuTzRP94fofUATgUbv0+iEODUHTe+owepHyeAkiRGvDZKTLoOp7JtagaH35IEuK6VQ2/2LImHEwTRz9eZnOY8q7W6f7d8lGiSN5XXiXsxZOv/2JUYEMikKBwZ5XioPxo5wTdfU3C9QGgoW75okIUL0C9awsLl2Z98vzNUAH0YPar2CZPnWi3g+i9RnF3T1/dega/sna8GvSM/H8Ogp7s7VtG6BbzMSFPKBG56ugius/hr99foPBO8OfXXrpR7QC3/TQtKKaFBifwhujLq8+wIRMZER+L4ZrmM+jStO0113YeuxSvMoLrFMh+H1FoEv0GVa0MxjIu7XP+j51RMfUmYQ5ZM7OwX2cyTAlWWR4GHw489rE4D36gcI3en3SbTPqbSwL+5/6D8PIrHiyzUEAX+qyyGWeluMkaF/lC4mSYHvaHf90f8ou8W2Cle1gANptjVd6kBa9SP7rnRD7yLabDVr1rCy5KVahBeet71I17LLsun96vVAk9mMgom+cyVRFG4lVFxd/9ZeZ7fob2sw8A7N446wjEMYwkv99tM+dcEK7kfMeY0EGiaJXiFiV+PHVNIgDZQJZCGVqVBAF8JxBcB+E39A7X7BxiDeD6HpZv4DEohE6A3LgjS4Ozm91xxg/gtNJlEZLMabMBwE/wCCckKPRUKyfittNtnb9klF+GW1b7xaG1ZyQiQEG6AXuPy/QvXIlYcOlHJzkY6+mWXv3U1ioieYx/P/q8XYafwP2Fnnl8rgLayB3gprYVtOp3r9SrPq/ECqtWjtU9gBK0a84WjqxSkm6
 at3qqiUb
 SQ3t4EB0I1IVvetm/gUFtLy7IT+6y3pKT6iN/OFn48iQTVzqw0rzxtoKKUHZUr/kk4XU94Z8q14hwV3DAL1ErwfqdXfh+FU3ssNziMF3piZKWvnBq4DLrNHD91bvPag8zA3JKXohCYHF0y09dz0aQ6r6sVafRI6RLnaRxmvQ9gPdFYsSVCwU6rhpVroFrsM/R+K4eupdroBTTwWvuNVztNvCk/mkWveTGhS0Nl6QShHdK1/LyS3ob6pFY9/Z6SuP75vlTFfkJkIG5Ab84qD3zrpwozNgOi3RXjEPhrpZY+CjwYI9z2rYzhJgPoibYRw4iYKQ1SzKDzjKYigv7q2/fD5iHqvmQt4o+4tAiL0Jw+hjv4i61lhebNbav7LYIZ8ZBHfhgIZ0UoXyMck6zpbWIQHp/oTz2/ZSKj6yp04Z8zrJWwAh4A+RqHR3MOCwL9n5IdGSofCN+B41mJLrVY+QGmWuC+Wlj/oYz19h5WrGvATELJydQKiBrEG2Iiq/NSifMrekMHWsSgA7Hr42g75ovZ3T+1PNOFNY21k4+PunmIwcILS2VrYsQYXXYGYo0lrRRIWZe8Dz/hRIWvqjY9+E98VvHKj8XtYxajiXxamV0iL+vF6qQGVg3h2a+oCX137llVysEK+Lxol78V4XW+S+tapF58++pUdtUyAfZJ4ng6z9qzAC3CjA6Mel4iOz+JNU7Q8h+PYMEeyS3+PJDNpMxMY081IQzWODU3phYk5oY5fwM9pZRSC0f5+QNHF5ziW3+sXKIfr+GwGDj7UGtCnSJhLnqdpSFJf4fw51oqNmvsM6h6kIMJRQE4Br4MfHUVY6WvTUfZPHuoTZHkvBsSlGc9XbSF3yW2jgSMn6nTHWqJPaVt68ersxFLEcYMy686pXy3GA7EGsMTM+Z7CryTkjAkCGkln4e4sHRlL+7BWMFBKMG3CFWOr7LAel4L5BOoat4pwUxxZu5mgt0YJI7yV1HOtKeM4Lj
 MavhUHB9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello mm maintainers/developers,

This is a 31-day syzbot report for the mm subsystem.
All related reports/information can be found at:
https://syzkaller.appspot.com/upstream/s/mm

During the period, 8 new issues were detected and 2 were fixed.
In total, 121 issues are still open and 364 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  17819   Yes   WARNING in path_noexec (2)
                   https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
<2>  11145   Yes   kernel BUG in hpage_collapse_scan_file (2)
                   https://syzkaller.appspot.com/bug?extid=bf6e6a6ca143afea5ca2
<3>  7452    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<4>  3028    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<5>  1654    Yes   kernel BUG in __filemap_add_folio
                   https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
<6>  910     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<7>  684     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<8>  665     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<9>  531     Yes   INFO: rcu detected stall in sys_openat (3)
                   https://syzkaller.appspot.com/bug?extid=23d96fb466ad56cbb5e5
<10> 510     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

