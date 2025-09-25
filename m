Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCD0CCAC5B5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 21:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4C138E0007; Thu, 25 Sep 2025 17:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD188E0001; Thu, 25 Sep 2025 17:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13058E0007; Thu, 25 Sep 2025 17:06:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1DAA8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 17:06:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3BFFC11A423
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:06:52 +0000 (UTC)
X-FDA: 83929007064.26.A463405
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6C6204000B
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 21:06:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 36a7VaAkbAOoeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=36a7VaAkbAOoeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758834410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Fv79g2E8KXfLwQqD7s385jEpGi1SwHV1FhuuxiinpRM=;
	b=Adez3f+c1dv9DCYYaxSbEZ5wKTWcDXHoUgWQxZ/i0lF+hX2mjaamQz4Ql6LAO9kJ6mtMZe
	vNJ8ArdlyXRXNxI+LxFGMaI8iPGQJK4/KPTaTj1xqRhIfJt3HdrqFkPzitylUPqLwc6+Cl
	baE5vgkxphKMhXRRPe1xpRN05nvNtBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758834410; a=rsa-sha256;
	cv=none;
	b=bW1GjGbyru2zYvbHKCJEeRwvByUo4LVLDk9Tw3DZr4in3nskewBpBiUYWEWthSW73jFyKY
	uIgUt5Qv0vxVe4DVxvIWDfPW5U4CcvMDF/N7QgFkAweEgwg285AY3BSFn+cruDjcXy2ATs
	R3eio0odWq9RRYTvM68kk7pDEiEKd0o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 36a7VaAkbAOoeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.69 as permitted sender) smtp.mailfrom=36a7VaAkbAOoeklWMXXQdMbbUP.SaaSXQgeQdOaZfQZf.OaY@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8935bf0133bso329790939f.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758834409; x=1759439209;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv79g2E8KXfLwQqD7s385jEpGi1SwHV1FhuuxiinpRM=;
        b=fUGT3k0X/2rhEc9NEsot1LUgj7bBXXK8O4xo2mbkoYEaFUt4oyUc+7EHFwkfkfiTgq
         iEfH4FeVf9FhitGE1jHXVrQU05Yvvzz7j9CjJJGGsyOvMV5K/NGvme1dUoLmZtQzcc7r
         MLPWPm+/M8O6PK+FR17OyMC/hJvObEw3VxHhxUpqnldE0ze0+ZWhBL7SMBS1oEzDKPq1
         qclcykArmCNQU0KuZvC/gZchmfxDy8BYKa2URZo4WYmwku4U3Ien3ibaiP0vMYmkFrPa
         gkmHDk8DZFuajFA0mwJK+FAnMsw3bFKhSTUkP0Xqpjx3VaoeCkRUO5riq159vClhCgNt
         yBiA==
X-Forwarded-Encrypted: i=1; AJvYcCVr5Oz7OMYRLImiYWWtmXTRDRNcupGzjkv2UcaTm1nP+aFwXFAKUse3RAP07hHGAk34czfp4pvBKQ==@kvack.org
X-Gm-Message-State: AOJu0YytkruTA4JcyWtEO7WcrfV0fODGZd2V7DVxSRNhs5MlqfJLAlkc
	jOGdE4yaXuX4R4qpMSeKEML3PsZ78QnlKeN7FosDSlSR/lPfbYQ5+L5hwGc8TXYYOkzgpf08ABh
	ChenoH+tbWVYlELvvGFt6rjNtyNzh5oeEbE0c1gBSB6YmqjVXyMoaaYNJB2Y=
X-Google-Smtp-Source: AGHT+IGsLaZS8VknIRu4I+IiUzCwFepVIIzy5B7otWpAosET5cs+1XLXxbyE2jMygx6/b0ue2EYBuZxmGwSFoxb+FmYjNP+dFm+b
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180a:b0:425:7534:ab09 with SMTP id
 e9e14a558f8ab-425955bcf37mr68696405ab.7.1758834409418; Thu, 25 Sep 2025
 14:06:49 -0700 (PDT)
Date: Thu, 25 Sep 2025 14:06:49 -0700
In-Reply-To: <20250925144934.150299-1-kartikey406@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d5aee9.050a0220.25d7ab.008a.GAE@google.com>
Subject: [syzbot ci] Re: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
From: syzbot ci <syzbot+ci74a400bb557985f4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, kartikey406@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6C6204000B
X-Stat-Signature: q7wf4awqgjxqa8p699samm1m4fu6hdpw
X-Rspam-User: 
X-HE-Tag: 1758834410-763135
X-HE-Meta: U2FsdGVkX19l1KI9cyaTnA6ut075Tz8/8UTRKZbtC/5ExCWNxxOLc08LLQ+KTVTSo80DfiY9ez09P14KeK4gly155UL+PgyGz4BowonJH60p33ejChHX0NZhQVMor12nMM0drRGDWmT7w5bEfyYH3fEa01xPF9BZt4NEDpd2dH8FrsOorz10J8KlPvchqcAVtpsHHSfv5xn9Zj+bDpePveN+lIHQJhByvgG3EsYTH4cl+pvs7+2W1TlREwi4O7zgFqLVdsp/R2y+ifYjBvhqVcKKfEGSkxsmrNx1kzwZmW7rlZ9QIbJowEURm6YTZ3JE8QLXdI2PsyOxKAGetx/QslUDfsTq70lnaUtVby+mLjncg0/wk7fE91hJOfLH5ioX8EzZJD0bU1w1jqp43Ooi8qHUgMnoYRwAiGhTbwQN4G3es4IJYD8a2CdD2FQ41DwI8lYYtq+v+JRemv/8uP7kWgxoitr+JHJw11GcRT5zEgZTwfBrOEa5VCOP6zQ+nMJG48TPfZEbRTVpEMRkvecczphJ+hFjh71gESnUeY5IXYB3YL+fgoLI25nnxQS7LaNjv3eo908NBTikI1J+UL6QoqcZ9I8ZaXsg8IKyCTQXPqaaiFiCMJyKkJuZ5j/Pvz7RUm54rmaNl0SL+Hpf5tSV0MwGSmSW+3gisdb4hEOGNOAPJ3Jd8t2Oe+M1nNc17JrXx4qwua50wY2XywWkzV3Jx1GxVyQbP2+j3NT0ON/1iMKQ8Biz4Yu0Q7gXJrtp7T5nRSYmq9+JI+q6fO4N8QDMn0d8SWqeWmIuMi1KgvRnk8ajQkNpXr+VDg3tjQCcgjm1m4GQ6Mz6e4kR3+Jfoobh5WvpoS/6gmLDt97r8Q0er6EsTtfSnVCyFLhQeizPB0fCasUC+IPb1mHbqxJjTUxxw00zC1NAh1VGIK1Kw8BohskcHYNcAGlvELG0xbHjyz1M06eks675BaZS4rhlmym
 QMsKujag
 PsZT6GbRidD9qG15huSsLxwBhHsufHJItbhwh+/00qp7VlHDJ7CCjMHMyj9LqF8witwtp5N0KJ43wiamNsx+zB7FmRzZ/vZk+JFP2PcAnd80WFYqPxeKKIsJmYrOG7CiVWWg31+VX1a+UxvJGs2nQhM5Pi5d5Lq+yCezz3TB50p5JkgHQ7tuxBNq6FVuM1CgP6e2asxKt5wpabXvHNkpkpvkAwMsLAEuFFC45jYyIf0H9P0RvVnC0mJ9Dw9kO2iKRDjNdG9dVEnmQ7Ncr/Yp1vv2zIlXE3RRI2mG1BMDs/eltiMoFNKTzZERa2H/7hsdq5mqGJqNAH3sXZZqCooLJJfyMcySSUu4dy1Xt8btreNC8vl5buwk0l6rXlRD5m2eDvw9cdzcjXFHycm2K3U3P1cBZCxWlg0Ibi1rCh59WO9l4OLDPwCPxlYNd5tClgkYNuKSPq+CWC6VOZojbREr4jkR/oNRfFCgIZAGv0slfzi6fbkoqA+2KCv5wICpagfTTZPnhiJuX7TrTRw3AszSa2ZjcWn2Bl/pfbq+BAiOy/TJouDu5EdVsj32+QoYxi5lMr/jxvyGbHDvTOGDHv41gFe4Z0o/tYmHqnGuPO5/O3Qy/yCBTMR+GtMOCohmoy3hh+lcd4kFdVQlXBLN18V2aTQeHKqcMUP8kBArqrgaTZkq4i4zlB+UC4Fo6uIaLAqpAVubtyKdZq3gbudkbS/3mmPkcPiwGWt/c7XgtRdYhacI2oVtrS/gWxbq6J5BuaSFtWQPTl0rBvm/oSuvWR3hR5bLoyKvTw4ZWe872hxnzef82EL4rQ3fQU3R0Ign2HPfqgE+3QyBfqnbPWUJbgNZdzdSSNpRbDGIHemWacY9hFKoPuzqPtm01WjQY7n0KMpF5K0H3ZtkutnVzGgIpagiEmbQDXlaxcFHYowrfrgDu2IM5JF4X8FAktXOnv7ah3MpEqtHDJOzNz6eopQ3XAjZCx7yQlwSH
 gV5vct5R
 NATWfDWO6YE0svT23eI0oByhU1uXqiTcLz+eANBu8y8HUFecYPUEr6NVZjR0sy4864G3nDHqhk1ywB/94DT1qviMe9cKBJEO24+ilKvzCB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
https://lore.kernel.org/all/20250925144934.150299-1-kartikey406@gmail.com
* [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list

and found the following issue:
WARNING: lock held when returning to user space in hugetlb_vmdelete_list

Full report is available here:
https://ci.syzbot.org/series/7d3a090c-ec8f-4d0c-8f7b-8797e63f1fde

***

WARNING: lock held when returning to user space in hugetlb_vmdelete_list

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/06671e7c-eebd-4d11-9f0d-d9dae5637c0a/config
C repro:   https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/c_repro
syz repro: https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/syz_repro

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5991 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5991:
 #0: ffff88801f7dcce8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_vmdelete_list+0x67/0x230 fs/hugetlbfs/inode.c:490


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

