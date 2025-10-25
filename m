Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 337A3CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 16:43:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92F378E0153; Sat, 25 Oct 2025 12:43:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 906F88E0150; Sat, 25 Oct 2025 12:43:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CA28E0153; Sat, 25 Oct 2025 12:43:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBB48E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 12:43:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19295AFCF4
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:43:05 +0000 (UTC)
X-FDA: 84037206330.08.4CA4FAB
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3AF36160008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:43:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3Fv78aAkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Fv78aAkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761410583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=QXMpskhSaFH/uBSbU35Otfq6GuSaMBgqf17YrN3BtBw=;
	b=7iPnsx1uKywbTAJeoez1lpxtd+cslSir26VduEyrD1/UXupO32oRyeutXciHM40h9P1QGE
	DWUYaKQaRTyWPKWSsGAWSoMDI5x+xGPO8uROjoUk3ZiEZlQVTCu9qkQd5RwscoVVLNxNY8
	/hW86+HFqePKSBYNoXBOon8UwlO7XpM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of 3Fv78aAkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Fv78aAkbAFUFLM7x881ExCC50.3BB381HF1EzBAG1AG.zB9@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761410583; a=rsa-sha256;
	cv=none;
	b=i2VO0P8XezebRcENm6RcR63dzl4XWxiN9ZW05DcjVN/Zu1s7L6wZeWQtRyyGjjdyPbT72d
	x5uoJJDsgFvXz79pZhA+Ycvwz0RXvBAIjvmzNkzUIy67xZuijhouN2WwhF1Vyx7a4AkwR+
	gJ12/o1oxooFIEeeexsyzUO0wfO5g4E=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430e1a4a129so41512985ab.1
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:43:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761410582; x=1762015382;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXMpskhSaFH/uBSbU35Otfq6GuSaMBgqf17YrN3BtBw=;
        b=Jb5DaEr6ChOhn8i+LncZYiK4xiPT/cspCjDLBOeC6eHMxmD8jzMM52rmZLu63SHU7G
         ZqMe7+ZHA71FR54xp+bMIooQFKy1LnMGJml+NUXwO/bobCMz8h2BivIDhbc9BB1ILfpi
         FYGN5gSAH/ASMYlEiVwko0vpCT1wR/NLXBvsKgT6ZiX6fs/FZOJnu4DXuzWIvTC2oa62
         ulmh+9XOAdNNFmwawnwmvIFqIDjvHK95qLkNIdvHwQURIYEqxhTW0Xs5U9VhXVQ7X+j9
         wy/G9n/CbIuNcprJGqnOZhOCEA2NmzFIwG74MXcjbVgx7ie+y7TR4WeqzZGuPn2r6M/8
         fk5A==
X-Forwarded-Encrypted: i=1; AJvYcCUewM0q1jx2+5bnWn8QYlwDJ7ELy0JyAwPhMGCP8vq9Mc5oRH18vAb9X4OVFrMnDZ2swrt5+gbsYw==@kvack.org
X-Gm-Message-State: AOJu0Yz+EEGCRqid2gJzuxtgOXREzQNVFKcJ+h152QiD0pkPlva0CrtI
	PAq4KJYcbqYMAcq6u7cKarQjqN+aq/1Hc9cAZGGfaM+NJkUDqPUKv5R75k5jvtA9TXAXfNKeSvd
	5X9mD1D7sEl8z/P8XUOBPhwO7Q2p+cGOPulTXVnNBPOU5a+pYo86k53lPQf8=
X-Google-Smtp-Source: AGHT+IEwu10woP+ou+FESnPo8XQtxARDMQxoVyJIbuOf4etKwABBGADZHwCBGVR7OpfXWyla77lkmFsq9fvbI9dCv93qYDTsPSUc
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ca:b0:431:d83a:9c7 with SMTP id
 e9e14a558f8ab-431ebed4198mr81811815ab.24.1761410582420; Sat, 25 Oct 2025
 09:43:02 -0700 (PDT)
Date: Sat, 25 Oct 2025 09:43:02 -0700
In-Reply-To: <hmzw6ng2gv6ctvgjhpttxuodpxriz63kpcnu7keywc2aioiw3v@x5xcenq5whr7>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fcfe16.a70a0220.12011.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in raw_ioctl
From: syzbot <syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	krishnagopi487@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AF36160008
X-Rspamd-Server: rspam03
X-Stat-Signature: ryipc1ww8fu5gx91qj75uups3nk5a18t
X-HE-Tag: 1761410583-713536
X-HE-Meta: U2FsdGVkX1+H1F2Vix8jxXiak4zocT2fXu4HExafcrI6vlfb/T/MxpXM2lMAw4iKEy0Yu6D/Uwzt4lHHJHsUaKUNVX1+8p3vzM11M2rmRe20FMfmia/gEwLm8zQSZ22MImTn4YhiW72mAVWV64ash7+TrzboW2AbGumjCmy62diN1fEo5UpKNzd0rUb57rYYmmC6yb0LxnTwE9W+wfFXSp+in1kSvCs0s8+nxq3ZeVDJo6YIaSIJa51ZSk7pnzpU1VrAMFPnlDL+genDVWnc0ybGnPOiGZGbcoknbmVwmOgnTY8WcByXNuvU+RookDhqRnQykejw3XwrOpX1N46ivAyHfdoF5E7KUAFzrJUHiXS1c+2Dy4wIYl6LDzlZrbDUe54nXOWBSxZ8KJveIVRYQ5dsNZUQXv51/0YiJeMGeF0XHb5YonGO9qJ/QBLy7B5ZpJHKUQybTsDUpWAATuv6jTVzVl5XU2B5244cg0g2eQnyQms3dFGtaYqO3r24caXMyVNUnyWN1L4xFVnde6tQkXpExGxSAfcD4lxpJZiY/mOXMPPqpNBXgQ0xVN2qCUkfvmYdGvNfImEa54uE9qbU5ZfiLZ/6pwGdexsJKDQZh9/lgzUutoDFkQe8q7FE2fOJQrYJTL+u3EQp4TqRAJL8IRvHsizWEtLYQ2xpm7uuxlaPmll1Xif6FLVx8JK1sGnWqSCbWY3m0zRjDLOAIPJ0maVJY7S1UkMn19iTAFmCnVrzML+4rNe/XFx95iCEkkeuiGS3V7AUFvHB6j4zXLQkXKgx2ad+1sflGzdJxQwLP2fycLkMiP4rRKPUbs7uEzKBBbXZRcn7i78CgCyMQaD/CVmpnbVRQP7LOKo9D/QzWMLLxXNuOa5vThc1bA3WsXSrTF22A3zMU8bDD/Hus76dnqkL24UnV6RD+PMJQdEZH/jOhU9BP1DCmUdPeXJU52TpTNmJJ5upCT9a0O+driB
 4W8DGJHx
 Xtwc+PWg/qgggA1b1yyNLmHsCwsGMFgwHh2jBH5parAw8Oo5Cj5fyBvG1ApVlsLakAkAYMglRTdG6Kpzisv1zN0LpHaKcoThYC3d0S5/f20GJex7MwZywsMa36kzwKKRoD7toQjmpdEwagkIcJBZT8b/g/GWRDeuDqQWlM4tCpmhLND8SPA2BcuZ98PE0iKcyvL9iF1Xf4UltQR9wlxRsYoJY2OJMHpTHir5WKfoo7OYLlUTJOyUyP7kyp7/1GuSBqWDlo7lZSMX/Uv37N7IuzYpPLAKxBzheL88y77b8lmVKQGrowaynFJwEGTqSHWArCtVMH8qpuYAaXMTsEdVesRSJxBDMTETV/L4h2VcvJDff7FZajNfwEVmonC/Azw3FVeuBAo8oBbWCCgg2pQ+ZzS++CTC11b0cbpCdUPZOxKHIZ05kL7jxNkJDGue1RDMP6+FDAhBrxlmZdEnz258DWMugjcRzJzwb+yUrzOE7z+hqS07ABfevLMXCegnWe/OGdvqgtL0zpk3hSEhmMliOmzMaj9uaflIdK5YAV7WiAI+aj63LW6kxCkrxXaIVtDcCIiBbLBplt9ik3CUEMNikH912sNJ36BvSvtUHmyNyzChItIiQ1hROGFVGWLbsjWV7Ypsmtc5LA/7TQnJKTCTBLic3SAtIqCKztdUzLCHPoCjD9ClgEC99lTunRVGf9ogHwP0x9Sb2Ort/C4KUsoZk1sqYu0qOrjEKKY4j3YxZq2i5heU3eNff3EOhEZvItxh4wBnMgoKydRAte9ldDrlCy/jcEB4y+MOtnt4u/Q4TdGacef5iNAIaEEFRw+JwOibHiggPLbNAbRiHF3jDyUrS+r2Lkj+4va9G8N1pHpb94S8M+wjMTX97Plb6p6Bmj3iZLdv8nkRfFxIpr/gFjI/3AX03eUrqRfhwJ+99uEp/qdr3EO3XjzHgFyoOuMIHXROH4UYQshhPcOI5d2uxBMIiVfOVKcvh
 gDaMAIhP
 PGCpJYKEzoPoa2PhRM/23o200fYcJmAfxnUMP5mOPwugS4N2RqTLpz9nVWbI9MLcpSHa71x5xujKqepW/1CYDdPPVTgfvoQ5jajuDfuLpYhd83SRy7Rhv6dhIMi0+rwHkkKYn1QMXqY4JN0FyRrQB9b6JOubMtT8UlqhSWWoI5yzFGbD69TG8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com
Tested-by: syzbot+d8fd35fa6177afa8c92b@syzkaller.appspotmail.com

Tested on:

commit:         72fb0170 Add linux-next specific files for 20251024
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17d91d42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e812d103f45aa955
dashboard link: https://syzkaller.appspot.com/bug?extid=d8fd35fa6177afa8c92b
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
patch:          https://syzkaller.appspot.com/x/patch.diff?x=10214be2580000

Note: testing is done by a robot and is best-effort only.

