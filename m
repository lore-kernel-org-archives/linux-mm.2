Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC3F1CA6007
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 08:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19DCA6B0134; Mon, 19 Jan 2026 03:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121296B0135; Mon, 19 Jan 2026 03:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020226B0136; Mon, 19 Jan 2026 03:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E294B6B0134
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:18:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9FBAA1AEF12
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:18:27 +0000 (UTC)
X-FDA: 84348011454.15.3733A82
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D0F5140006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 08:18:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 30ehtaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=30ehtaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768810706; a=rsa-sha256;
	cv=none;
	b=SP7/+u0sLn23se5X9RG481MfMyFlWqDD7TiIf6yRYmUmhlTsuuXhnTBAHcBArYleU31oD8
	wvHm8C8NBNs/OIHHoS62q4WW9WV7s/LWOd9wqKRCjhq4SijqbWUN8w0NGrCxp8jxj9KK0B
	MdoyB1gMs1fIicRxhd64sjDI06vSJn0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of 30ehtaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.71 as permitted sender) smtp.mailfrom=30ehtaQkbAKweklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768810706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=NhnL8MEP/pRB0FCsQpW7MYNVHkKIhPy+pDAgLhSbeq8=;
	b=oPZbXIVzk411+b0u/5JTVfPmPFVN6L+XGpq02k4KGOsdD5EzwYX9uo6yAISJcXemThgik9
	G4hKZ3+dX4nl5ykFiVmsJBLHRICwhAF+eQ0r1f5ZA3MwHh3hjmBDET7Z6Zn1EEhBbrACYH
	GjtBCqYBXn1kiw4QJamXRXO6REEKF7w=
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-65f453d9603so10707124eaf.3
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 00:18:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768810705; x=1769415505;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NhnL8MEP/pRB0FCsQpW7MYNVHkKIhPy+pDAgLhSbeq8=;
        b=A581DYBW2mhvZMFZ23b7YVYyaRRv9T0hNjse3cHqJdg25miA9pb9YCGwCppFiHTaAZ
         OFshupIzACoQfGoHtgnLuu8THiIHf7lzib1gfixCvwi13X4cq1ARQTeluH6Lj3f56ZeP
         dHWL+OW4ssWD/9psxVChETICc8VtfkfYDxKLolfpHQ/uQG5GtraLYXvYZTdHJSo2R2fd
         lCP5rjBk7kdYLbcQTDFurNREzbFb+mL7HMySj4QpgobXSB9aQPSTpPOXzjqlmKvhJs6R
         8bby/21gcgmjlbko66GQ9B3FA3Vtkv/fb/1P9ebwuN/6nOEELIG4g4Ug5UwJ4Bcc2oHc
         D4EQ==
X-Forwarded-Encrypted: i=1; AJvYcCXhqSvv/7XEYulKfocYCnDMcooSvn+EYWNrqabboEBJL7tGoVDY6gfTcKxy5oP37bjXIdULdf9VvQ==@kvack.org
X-Gm-Message-State: AOJu0Yw5pHkoZNpv0g7RQiMtVKi6aT6gac66u0nNXv0t0RmGgdLvUj2x
	W6fRYLdDyRc9Wc9XhEhNnhUZG7qQg/ujaSHFXJrb6Tdrjzgnxv1IqBnHbkL+jq/4WHnXmQqZz4V
	A5fa+Ob+P/Z8u4/vpKy0AMkZ6s3ScmuqpTM+Ey7UQ9XCD1CDgw8iQK1tnVTA=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4def:b0:65b:2a82:d700 with SMTP id
 006d021491bc7-661179b64e5mr4665102eaf.44.1768810705169; Mon, 19 Jan 2026
 00:18:25 -0800 (PST)
Date: Mon, 19 Jan 2026 00:18:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <696de8d1.050a0220.3390f1.003e.GAE@google.com>
Subject: [syzbot] Monthly mm report (Jan 2026)
From: syzbot <syzbot+list6611482a904f20264dd5@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0D0F5140006
X-Rspamd-Server: rspam06
X-Stat-Signature: yhsy5hjkd9jrrh4d9w1abesmu7onudi3
X-Rspam-User: 
X-HE-Tag: 1768810705-81936
X-HE-Meta: U2FsdGVkX1+L26EBjUaY63ZxpbAlb/CA8rdlTXVUp5ZNKpD/3sd/S8y0CJATvtxCHGsvza5hKH0XKH6S4JIhOa8pr1uufa+b55Yox1770rXq/FZUeIhCY3N39IRZ9BP74l+CyK8P/2OK0Ztj9V6+HAY13pPqWqkNCzs3UKV5H4IT2FpQNWZOWocx1C8ub89GBYwbKIwsZKKWnqdfa8pNdeNpz29rZViT4RoxdYGBtCwJapNyD3+yPfGeVGA9kYuDrru1MsdgX5+vAyN1AezvWUljyuQvNdnefmZ43GxP6YNPjxqcUJxNv1GcDam4S97FnGM+8reBVhnltwW7M0dO6YdNaTN8UmcUxJm9D+bWup4Oxtqr1Ps2AXl4N6oin74/umyfXr6JHAVLBEW238NDZfnghZctmDd2f5n3JCJbhLJTAtIxGfZlIL5C29H6K1abrN8kbbCAL52lga0+3d+nRFupQDuJrMxiTtq6tpg2xrJ3qbpvbWC74vcOCwcJTt51k+WhVowQyAPBG1NaHAJfk8579TRtxs3bTBSmsEZR4N7jWFnefG+qOq4cwch6LLFjjTvtnQ5Pm8Kv0++7ef2vzrNzmT4r/BEIRcThl8DyOXhC+EURUl97VQvJk8W0LRu7/0GkDTI2B+RWxU1sWEhqGfExU4pvLmUYWBuVb1KGv96H1dUJQxNXHXlyrok6VGcUB0EXuRjGxTWWZMruVyKubC1RSUscfouFpRGVg/53aq1lIK+DSFMlAoxrhW1hKqh988WTdfjotS4H5y1wJBryBS/VX7SStgawCkdOuxknr4zXVK2Tz9Omko18cF9830dsuoUZukLC0gnk6ANhnEGDx6t4RkNGO7s6vb6C4NlVMJK2izQugQ3ovzVyo1M2fOaOrZ9t4+cEKXJ5h2JliOz4qmTvErrJEioN1bYp5voyMozclFnt2MaKG16nK88unwdLPqoNympvcvjyVL1Zhxp
 6tbSjG/T
 OArPCnieituAWXcnMpiTMBijTCVX2wkVbZFzsMcMF/jdjvINaNivTOkg6Bl0NBErwYi+JVfGQ0a6weoe4zbkNt1WDc+//ze8nEbmYsJAPQZZEHS3G0pcxnCFwN0AU9IdayAW82GbMRmgMbyY9dqitBAmBXi5uc19Klotok6rfLDC0oxkKN1J/jSrEB3h+bYrYwZv4LUtXX6VOzEgT+yPThNwNI6fmZ/ncee7iQ44A2w6XMTj8tErlTzc9yh6MsbgNAg117eZ67McTqbqdu5C9gvRlKdKhkhiDAr0uXkGiEW5QKCM6+3SMlm+hX0icikYf3gfsFMN8HghxatbZPIVOthqelyZioH8NJbuiLEGpz3dLqNjBzYQLOMvZ/2azKRTsp7vgYamkNH5IQyEgDd062rS8dNlE5zLiIK6sxxiGHkdOvEpkAL4jQi4mR6zcAUN5nUI2XTOIoAC2pzcKY7DKjBEi9wFsjTvcEk/gNf8QGMylLc/WdUa7/6VaIwl2JXmF2Hfklg60s5PWAp4OMO/9I6KeSMuD97sDe3WtEOY2Nkr/M+7c7I+PA5wpM2X9wCIWUqmOzCSydssSJJxpz+2c3ooi8ejuP4GCTas5t7kZUESEW90oeU+tFsTJvo6w99QMRQykWr8C/iMwO+3oEwcoEjO+jCbAo3kfcPeUegrtf1mTjODoy+0xuQy01fiA92dDsrrmVPGEU9thKzTERmGKpyP35n7kbqWic0aX6+sOXuyiSfqkaClJEPPWEXZuysJZXAgev06gW/Nzi+ckzixpPkZai3v42Sgz8WtHdZW9FJ/eDLcDgbDZVQby36N7oWo/Tn1h4t/48+0YxKL3Qe+wH/JADHQUQPeg13TI2p9is82LmRqeNKVlfxzeiY4ogzNQyDdCbsRYGcgJSdxZpKBxdlLr2iPy8l7q/8mqG48n1n3TrnHt6fhGwimYX5Ra5Qm9/qfz
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

During the period, 4 new issues were detected and 0 were fixed.
In total, 117 issues are still open and 355 have already been fixed.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  13965   Yes   WARNING in path_noexec (2)
                   https://syzkaller.appspot.com/bug?extid=a9391462075ffb9f77c6
<2>  7446    Yes   WARNING in ext4_dirty_folio
                   https://syzkaller.appspot.com/bug?extid=ecab51a4a5b9f26eeaa1
<3>  3650    Yes   INFO: task hung in page_cache_ra_unbounded (2)
                   https://syzkaller.appspot.com/bug?extid=265e1cae90f8fa08f14d
<4>  3012    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<5>  2188    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<6>  1539    Yes   kernel BUG in __filemap_add_folio
                   https://syzkaller.appspot.com/bug?extid=4d3cc33ef7a77041efa6
<7>  864     No    KCSAN: data-race in __filemap_remove_folio / folio_mapping (2)
                   https://syzkaller.appspot.com/bug?extid=606f94dfeaaa45124c90
<8>  673     Yes   INFO: task hung in _vm_unmap_aliases (3)
                   https://syzkaller.appspot.com/bug?extid=fe8f8efd070d727de971
<9>  646     Yes   INFO: rcu detected stall in addrconf_rs_timer (6)
                   https://syzkaller.appspot.com/bug?extid=fecf8bd19c1f78edb255
<10> 526     Yes   INFO: rcu detected stall in sys_openat (3)
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

