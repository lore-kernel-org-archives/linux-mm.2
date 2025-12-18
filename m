Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B570D6ACDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 853706B0089; Thu, 18 Dec 2025 05:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800C06B008A; Thu, 18 Dec 2025 05:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A6B6B008C; Thu, 18 Dec 2025 05:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60D7C6B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:06:29 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C71DB8BE4A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:06:28 +0000 (UTC)
X-FDA: 84232162056.24.2AA302C
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf13.hostedemail.com (Postfix) with ESMTP id 259AA20011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:06:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 3ItJDaQkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3ItJDaQkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766052387; a=rsa-sha256;
	cv=none;
	b=0vbounn9iGaUyGPGZWk1I68DzHXDCbnDMvDKNTuTggN+KOI0GM1SFgjhmqYEDc0xURPDUv
	pOA3R3qPPGfjzCE6isKk4t5b36ZTXgPuj7WCH2fTqngrQXJXyu5TFF2ubkYI5r42uKUMUz
	1SmZaQuNlwPr8X7d/2KniaN7uJU/cPY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf13.hostedemail.com: domain of 3ItJDaQkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3ItJDaQkbACcVbcNDOOHUDSSLG.JRRJOHXVHUFRQWHQW.FRP@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766052387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Cy2RyAtz8NnDuEjqIHQaJe45eLsHcfBvNIJ/fSWNq3M=;
	b=toDhw589HYjc0UPvAOnqgBW+ENRxSfS4Rg+z9RKGgOjWXRTTsz9N9gJZdeJAwDmJMfWiPy
	KOuU7L4uiPBOc7pqIGxnNDa0pMCZRWfuZDfDfnfGFjnyLUfxcY8Q2hPgbxmsWYy1kskK6a
	HNTS5Fm8S7L+5JWgo6P8VtHhPHLfRxI=
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-3f99d3f06f6so285256fac.2
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:06:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766052386; x=1766657186;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cy2RyAtz8NnDuEjqIHQaJe45eLsHcfBvNIJ/fSWNq3M=;
        b=mh1PleigBkxutHfWsg7J6kLs1sQkAda4kuVXZv1+JT9kxiw7Z636lF5iyJqjbI4ZoI
         TFfyrL2bcbz5gKXesJxrXeBasCNwnTaWiRYP+Z1APP2D0BLEmStiM0e6dnzN7ybBNOE9
         ohhuWy/17VQQpgWlKdbPBxWBv+LWyJbcw61BnRSI7pumq/HMGdAsFtODdl+39yLcP2r1
         mQFcZq04NrbSRzgdEorJLYsLGTZw1ONEIr1r5pfpg54AGFgFHAagvfrz6GbdcTMdwKiX
         nyAQNGHuiIQX8nqMFDrp5WDHELqwvxoXATgKUhOq19B7NFFaXdGK9ix3C4pemkH4QMTj
         p6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpdO4ZA06bmrbQWD7GHjfgQ4zCb5uSJQeeY4qxjGSnTpAGNom9AQ+tDvuwSNB/MmAlCTwA7hkByA==@kvack.org
X-Gm-Message-State: AOJu0YzrKZiFUKT5aWFntWJ3CjIS4QYrQxufA6i0yaMNyhQIyyQWULk2
	gAQnQBn842CE6uvoXuQU/AxrZtTcDsR/ZK42Fhs9/qT0iM0nUO8rwD8DZuNf9ow63La0my3de4J
	FEQd3qfKBrA3xBMik7NZtOkPYr+Fc1l19PLDY1OusQ+ikoHLWaSjTHwU6Rro=
X-Google-Smtp-Source: AGHT+IFWWhrX5wf03kFFQJH/96G2H1STFpPuEAiB34CMEYDE7fj4psHLkKzKXp38C/1WP0bOZqJaIro4eqlBOwup0OvyEPpCE5bO
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6488:b0:65d:757:3a02 with SMTP id
 006d021491bc7-65d07574611mr121460eaf.60.1766052386241; Thu, 18 Dec 2025
 02:06:26 -0800 (PST)
Date: Thu, 18 Dec 2025 02:06:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6943d222.a70a0220.207337.00db.GAE@google.com>
Subject: [syzbot] Monthly mm report (Dec 2025)
From: syzbot <syzbot+list7c6c707e12734777d229@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 259AA20011
X-Rspamd-Server: rspam04
X-Stat-Signature: 1hqkzc7bd3w9ng1qzpjui3z7ydycro8m
X-HE-Tag: 1766052386-850958
X-HE-Meta: U2FsdGVkX1+uuFLz0wd2/OGBdGydg5ks9y6v8xqEOjxb8VGN3nj0poo7szFpcUP9/zybo7vLgqTDtsHYqcefl0i0KIWBC/Wa2jyijlSD0W+1jOT9pov4SMeZk3u7T8yoOzALNqZGpbQemiaL1ExCxKf9xmdStxcHDRmN5/0Md3POAdGfNF7DY2bT2A5h+1BhHDHRZzm9Jc7J0aIg+Iu+qsEhkmWxnj88QojrswZ7L21O75/cin/tiQKHkSRPvSTc8jUKniUr0hXAUswE6GWg5q2fXy4qjVSSOdjMHpwf631Ecmm6pasrhQ7QvFpN28Eju+oMj/yHag5pcCc9iclMmvTjoc0IT0w0/yJnGhaH9XE2js42kmPcIWoOBxDxHrBIJ8fg+sZDcGha0FiweHWaodtil4waZDZzBQWUogBl9w1XUoRNNvc257WgvcgSb5sC0R47s4fKQtBnFzVxBmRrffeIZMl8gqd0lzslnMXe/3IYY7ZP327+6AIaVk6HX+rZAkKQMLwyYyn8dvpZ7IdNkAJ695RTJvHOY1mj2jMl2KeWgNTgLYhZoaIiVudPOtY1U6zfPg31ZzyAubBOCc+2ZNiqaZk8GrKtemZBc9TmrKJs0sCFYke2Kqar8TYTHKV6qJfP5UrpTVGpQOl+CKLP/OUfWEu4rlpQUD6g6rk3Pr01NsASf4onwsF96gJCNmo/kSYeAwFbwk57jc+QWHNyq0z4SLpc2vVS6pijh2bLqPmLJ/GXBeaPBV4SfvhImGgrjbIpXbtVTvk0AX/+hLZt/K08LelGmRDwnahxDKywFj6QEnH5N0HKjmAUnxtGNgYo9DL+9n0wvEHqZekO1Qf18+AEIMUUPiNoEdL/TilXw+B3/kniKfI44Ratma9CHmNOFzwB0OTVRaUaJpUwLuI4l5iwaMH2ugzROxuFpazPm2uK8B6RrI+/4tLfSu0L6Y1CNDVOn6TiUBY5HEisAiF
 r5BNEozm
 CJIDYNZoQYgAQ+xZCykBb6YBtgFdVQmz+nVH//9Vt27kbisX3ZdhQgIttYzCELJRwhKdUvCn8BvIr2Zkd1ZgZ/AbwbtdI4RejqM8v/i8rCqpPkUhPSbniOCHPQf6m4+DljaR4oJHQ++PFQdIvg7t+ZNEAfO2TADaKPVYFnuZqBVng82BY2c1gk4/sMConiXDLR/ZBdjrtc/TW+KwoGeJUVxXOZIacgq9HNIXQAtJM1s+V0BAPJf3H/XBIk1Cfr3rHXW677infOd1oCSsVOMUI6cyyeyguKWCBEMz1ZICF1GMbYlNkRgyRywABUFCZL0YxOC4AWXHwej+rOHSkbLc+VX3QAaXzaN5RK3sCVM5Ogl1TkIYbQL6DLNXtp8k2R1ua7n76P9pzvuTiE+bTAbmtx/ci9XP8TNPMf3uyKVYvKNXlKimrN1yM0tzSPbI6UO6OKa8JxTJxvCRZcZ8U6uwSWixrEZ5up/aG5NdoqRDb7x0FqiiHAcK8ey2cYjbbVRHILS376zqXWr1fVV8PdCkw5oFM3xgJ7oO6J5Hnex5nQmV8VcaWdS7GBOIhtDWlCKkpse7b7dIxIYZf1f+EM7kFTQZF6ARuGx3SFmfPTdrbg/pMwJhivwNTrHSfGGDcykx0ZsGguUSWrA2Rp8Yg80LipO9xq41kY3EL/ZIVxonOuRUzyIYXyQukJ8jzOSReAmAaEi6UMaEekI/EfkSOfvdGy6C7PGBHQZyH9Tcrs9+7T1bUmOD65VCTvgMyIv7QWq3hFx11MjlZuzSjRc306IlaBuFo25s0tW/3C5m6QdGOYGcsfPRRe5aCOr2YkkGl7bGMqozFRSTbNqu2r4GlQg632ENT+OgdLQMT9u5bBYnJkBHfvc8DtNBg9Sgrpq+STFFNbccPZtzB+ItZ8bQ/lImj9H9KqV7/9x9ZUJkFdCnU25qezuhxe+f8xqiOn0hjlng0k/xb
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

During the period, 7 new issues were detected and 0 were fixed.
In total, 118 issues are still open and 354 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  10935   Yes   WARNING in path_noexec (2)
                   https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
<2>  7436    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<3>  4691    Yes   INFO: rcu detected stall in worker_thread (9)
                   https://syzkaller.appspot.com/bug?extid=225bfad78b079744fd5e
<4>  3650    Yes   INFO: task hung in page_cache_ra_unbounded (2)
                   https://syzkaller.appspot.com/bug?extid=265e1cae90f8fa08f14d
<5>  2970    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<6>  828     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<7>  656     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<8>  622     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<9>  498     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<10> 495     Yes   INFO: rcu detected stall in sys_openat (3)
                   https://syzkaller.appspot.com/bug?extid=23d96fb466ad56cbb5e5

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

