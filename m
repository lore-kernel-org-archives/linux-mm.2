Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9949BC98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:33:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B1D46B0088; Fri, 25 Sep 2026 08:33:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 665AC6B008A; Fri, 25 Sep 2026 08:33:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A1256B008C; Fri, 25 Sep 2026 08:33:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAD46B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:33:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C22FA805F0
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:33:40 +0000 (UTC)
X-FDA: 85252225800.10.63AFFD8
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf18.hostedemail.com (Postfix) with ESMTP id 15E821C0008
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:33:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3Imq2agkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3Imq2agkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790339619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=3tGsQcEo2L+rh2VXZGGUz0I7c7yOYimMqn0H8hByYtU=;
	b=IYROxONHc1EILORf6PVnGyX7K32+nerSGNz35qyMcb79Pn8AJPzydArlTW66A21j7He4f1
	vKdde5fADKAoKzgupibAUTIx4dlTUx56IgQqtwhNuvBczAGVOGyhFE3dMIWKeu2ao8ylmM
	h07XcQk4UUUZJa/9WZ/4tl5gnmx3Sno=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf18.hostedemail.com: domain of 3Imq2agkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3Imq2agkbAC0bhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790339619;
	b=zpHCekM8FkF6SWolmsnPfPCGxlS7bHDmtFo05IQp3PfuInH4RXkH7/HTR1unb9QbLLZ0ey
	BudG9x97xPLvgVTIY0GRyyNZWIOY7y18vpNOlYH+8BrTYFrJnkme4ARVKUKykEvUgsSjYs
	PF/icDhx6CDT8kpDBuLVoVL7rGUN/rg=
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ab260600easo2811868b6e.1
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339618; x=1790944418;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3tGsQcEo2L+rh2VXZGGUz0I7c7yOYimMqn0H8hByYtU=;
        b=TpYpmpgzI4qEBKUgnZS6x95HPRVlrpajthaLAybHRstHrDHZ0yM3v0uEEUPaLnKGRO
         imbUkDwkKK7JujEaaRBgRKhq5YRoEeLAKSjjdvogz+PHRoMQmnUdJIYFEMgtNBAaxiFM
         XCGL5iQNolwlqmuaYqHQdrrNu2KaqJ3jBGIYvoow1neOG7u/ucLRwpG4r7xJdJTMdsnu
         7MNnLvdNevGZOQmhXeZ9A+zsozN0CVt59HVkflYU2Y6Ixot8WanjOME28svEzQfWcTMb
         O1MJrXnM/3S9PQ97GNxNNAMepcPeP0qeuIPgt7LuMiypQC9b0h2Qt+G1HVRjKLuLewXt
         Oxzg==
X-Forwarded-Encrypted: i=1; AKwUvBymlQ+v0M6rMeeBiYopZfDnaIXfzG7RPafztabc5RgxBzu4kQ3Kvko4Jd+UwrZgr+1mwGQgPnEN+A==@kvack.org
X-Gm-Message-State: AFuF++np2irC1bNHYbKuIESuzCiPA/o/HbG/QUTZykODTKhzdQLqVUFD
	7qn2Dg1RB5886Zf9Qqr+33LjgBN7NZ5+5iQMO+hz9hFalLZTNykwQewMYCIMByNsqmtyjnj/Q9X
	ARFFQNLNwsg8nbNyNS/ifhgrlWI/NbV2JfDMqf9jXExPqe9R+d14ycNEGhsI=
MIME-Version: 1.0
X-Received: by 2002:a05:6809:3cb:10b0:4dd:f8bb:e1bd with SMTP id
 5614622812f47-4ddf9083167mr694918b6e.13.1790339618117; Fri, 25 Sep 2026
 05:33:38 -0700 (PDT)
Date: Fri, 25 Sep 2026 05:33:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab66a22.80e1c6cc.1e8e5f.0031.GAE@google.com>
Subject: [syzbot] Monthly mm report (Sep 2026)
From: syzbot <syzbot+list9522b235663d5a4f6672@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: bajychpperfe575f4khspad86zs93b1i
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15E821C0008
X-HE-Tag: 1790339618-730845
X-HE-Meta: U2FsdGVkX198K0BaEAUY3JKHY9EndOWgaX6hjUkeIgbM0swWsmkWjYTNp8WAfrNOR4HR+WaD7VV8FdGZv1dIdepHaAcnSEfx5Nri3fEq38jUOa3gXuwwa6lH+3N7qCq1jC6U70zemaG5hM0KaMEbfYW9RBjh6G74VhWIB+Rqv8CXqN+G3FzA9g6zR2Fhls0rI6m8ghbSqbSsFW5YsR8O9Uz/yyQzi7EkAO6aoF+cC+ds1PUnYSa1Akuwr4MZObSGhgIiIg2CYQL7hO18drlwKYj+DwCN4zhDslPbaDOVAgdTQQauiVf3sd+D5/jV6GeXg9yQkJ90vndD+sGfrcxgAHA2Ll12XH1MswEVuqM789Kmt0zltNAcgLWTGUGNg5jC2bsK6sHqSH1zUHxo+ijT4wFynEUexjiiyxMMeK99YJMgIiFAtbdCoFHB96AZA06nYHF0A5zeYzDXyoRxBcJdhKdyzHO2M+/ROlZgDszEgYketnKKU4eqALUmq023HYetHOfez1UZ4z3D72yplT3HKcGY6o6Y96PFkP1xEo6KUwi2yjLO4dyg918J5HnMXQ0wWYpi0zlOTM0GooIjpKSIyIX3JsLT4/mrZtysn13WCjV+zw94WqLaUxaiqv0cCohlqxVHyRxxiXM2tIoDLNCCfLmp0Kv6e4CDzjBtW/5NLViGPcwtKLcOdQdb1TKBfqpbHzkyH26wXQHt7RaP5ifhjWDz8NYwaSkTKqG+besJTQYKpCLh5vru8+M1t/xE9pLwYtLVV/ccWD8Qjw6t1i6/WlH/exvdgGe29hf9T1iS5mcCw6sRT6TvKHJv4xYbWNJjh62AbCZ9TukXhof9gfCOks0D8uJstTtGD5oH2VNPwrcbXjF/h/wXx8AiuDYF7s65GuxNLdsaoo02YsiBbbKP1X3UatqZ8ZoQcDkw2J1JjZM7ZHCjcr7vFQ2b4vcqTl++Bpg8NeTzWRl+XakijTu
 j1RMQJMw
 FxUhFU6b4Zi+dQtg5SrDM6doW8qJHseQE/ku4/Txkkjzc7YTgryKARiZwjWzPI0w800DFsAyC0JA4AZC67/Glx9WqO4nHmGR3mBUAufDqKbPvcgc05fZJ+2c7MKyyjcjEwob4NstEzt7sj1lotCMKp2iGBW9Vuqmen4XIR9DVq00Cu76dSFaQW2djiWgejoqmqZXtCedi/lEZ9eWyusDLjIPrg/VjMGvlUm56/p9JCPYJVSesBvuBcsb9t4ZPAH9c9TYDlFLcu4C49v4lNm39Ltq8KLfoFZ3/d+4ZR/yoEX6GCiRyePqG49r455pc6wccTqeVKfmXIC0coQhjwMTBlPlrqA+YCGpqxbG3igxBTxcIcyufXalbp0kreMdtywGYmFZ05+snqoGVsssQ1Hvs/HXyUQIB/uXBBF24OuyOicIYLdR1fJ4TNrINszb3nEH6C2UvMLTOUmA25Agpj3QQcJ4K3OcJTCvv0A/FCj3ve7bNr7CrabwKxl7zOjM9INiq2+fDnTdAoP8bWWeXh0Rn67vOMLLSbTB5S4Mw0saRiA4dk/unjicGP3XSmNQrFO2EDbD3YgEY8TY/2fb6dHVmc1aVqysNtwkwS4bV8Z9y3IgYQLgXUige/0mtkBlhP3z6LXAdivGPrIvfXNnJdwBonjhP1NEvdTRiziImtz10HFnsRUHj+ixz+P2iV6Qv5AkP028WK8LChDGUzWX0BE8nxHlJ7zsW4Z0PDcacQoA7iQqL5OXBsI7fyqaKF2s52b/oSmvNivuP6dnmUBONl0mu7lBsu01GlwV0MTxN2/wE6uQ+cOLJ5Ad+HytC5F9XXSd4+uT8D+493+2dY4Pn3/ck3VBQD+XyXQbLzyQuZJ5mGmbOLJG+aF+fIszKFtsq9WqlUcTz7UcuVgTx+DoHrbpICpnYJaiiUyseMwwEXc76gZXJ6z7TISvV4jeBLg==
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

During the period, 2 new issues were detected and 1 were fixed.
In total, 76 issues are still open and 382 have already been fixed.
There are also 39 low-priority issues.

Some of the still happening issues:

Ref  Crashes Repro Title
<1>  3955    Yes   WARNING in trace_suspend_resume
                   https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
<2>  3805    Yes   possible deadlock in attr_data_get_block (2)
                   https://syzkaller.appspot.com/bug?extid=262a71e9d2faf8747085
<3>  3136    Yes   possible deadlock in filemap_fault
                   https://syzkaller.appspot.com/bug?extid=7736960b837908f3a81d
<4>  638     Yes   INFO: rcu detected stall in sys_newfstatat (4)
                   https://syzkaller.appspot.com/bug?extid=1c02a56102605204445c
<5>  528     Yes   kernel BUG in filemap_unaccount_folio
                   https://syzkaller.appspot.com/bug?extid=17a207d226b8a5fb0fd9
<6>  329     No    kernel BUG in __page_table_check_zero (3)
                   https://syzkaller.appspot.com/bug?extid=2b5fe617654be3d8848b
<7>  308     No    INFO: task hung in migrate_pages_batch (4)
                   https://syzkaller.appspot.com/bug?extid=f523acb98cd782b4872e
<8>  185     Yes   INFO: rcu detected stall in sys_unshare (9)
                   https://syzkaller.appspot.com/bug?extid=872bccd9a68c6ba47718
<9>  166     Yes   WARNING in ext4_mb_load_buddy_gfp
                   https://syzkaller.appspot.com/bug?extid=fd3f70a4509fca8c265d
<10> 115     Yes   INFO: rcu detected stall in sys_setsockopt (4)
                   https://syzkaller.appspot.com/bug?extid=6e61d59e9d2150c8492b

---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

To disable reminders for individual bugs, reply with the following command:
#syz set <Ref> no-reminders

To change bug's subsystems, reply with:
#syz set <Ref> subsystems: new-subsystem

You may send multiple commands in a single email message.

