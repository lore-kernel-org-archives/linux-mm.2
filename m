Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCDD9C87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 06:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EB46B00BF; Mon, 11 Aug 2025 02:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F376B0100; Mon, 11 Aug 2025 02:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D6966B00BF; Mon, 11 Aug 2025 02:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 09C7F6B00B9
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 02:34:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B704B82A4B
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:34:04 +0000 (UTC)
X-FDA: 83763511608.10.BC6F658
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	by imf03.hostedemail.com (Postfix) with ESMTP id 121C420003
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 06:34:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 32o6ZaAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.72 as permitted sender) smtp.mailfrom=32o6ZaAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754894043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lueyKpG3qSnRqyQBRa/f+eyP2haOh7ZzxMzQPgpt8JE=;
	b=yV3Yu9dQyLj2mVTKd90dMvxjyVpL2T39lyHrvM4gebLe6xOBiWN+3UdwbzN8pcixMul1T3
	5uzqKnCZ/raedB6ZJv38F5bVS/nnOkSX1WdSMhXAAUP7yyq4djpbRVKAntvQELKwcAx44l
	tFmV5m4YQ0pfnPbo+DP4LyhVlZMjEMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754894043; a=rsa-sha256;
	cv=none;
	b=q8Q9eEwMe9LmZzV6TqWxyb82HO/MaJ0ZUDnLuMIW0vQsXmatv1xYqVbwZQyV6mvRB81QcR
	o7YUUN9dSu4FL9EVe/9IoPx5xw6kkFkasn93AW/jRhCe8rKXO1JBYplgkFuylqQS1+qouC
	fyohCuZ8yz0FstuJllnd4It6j6h5g9g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 32o6ZaAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.72 as permitted sender) smtp.mailfrom=32o6ZaAkbAKkbhiTJUUNaJYYRM.PXXPUNdbNaLXWcNWc.LXV@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-88170a3df7aso365067039f.0
        for <linux-mm@kvack.org>; Sun, 10 Aug 2025 23:34:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754894042; x=1755498842;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lueyKpG3qSnRqyQBRa/f+eyP2haOh7ZzxMzQPgpt8JE=;
        b=sf844RiSJUufRYiiRiOxU47WEXFOX64csQP7ccnARdeO8+pBpuMLVgDvVineU+ikfQ
         SyLdhaiSJ4SgAuio4jrtM00gtuwSX+tiQywxmsUqMEkhPSVRiuLaK+kE4YA2CsVhOtEP
         hG5vMmFW062uDL553ZrvXRmotLob/ZgKVvJL/5iSiYd78eWfEs4lEylrXrw7to1zWLxP
         a5Dgz8rHwcy2Pq+Hk4GFeuGa9UQDbGNnwYpYb1AfnJ/3R5He5FnFrTAHx5IyCzZDyCFy
         XwLcte8NInWFUi7bi1Dp8qG9WpkOW6ZMGYAbaRNeA3f/nZsh2ufBYno07+chZeKIVr5E
         OnkQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdYtkZQS8VdebBclP6ywsqmHEGC5a6wQTvc6ypB2YDWBR8xdVhUOp5b0ITSV5zl4lJ6vlmKis9gA==@kvack.org
X-Gm-Message-State: AOJu0YzYVWK4ptNqlj87DjMlvM7jl63sbDBmI3FskENCVADSITdiRpxX
	QMIUlvMYwC5/2mxkUZxf7sCVJdAKZJHG7JtGWcU7HO/QWa8K+UaxQhkHl6O2J0+RpgDHYDPLNwn
	oNHdERqv5QRgzfc783a0rrLYgqd4l35hytMHPwECyz+6uIgGSVDGU/BT8V30=
X-Google-Smtp-Source: AGHT+IG3xy8jagJ9vH7W92qmqcjKaaAKPwz3mDsXTxdcBqcE+W9gl4eLh9ctjRc3CmOcEA+jq9wFtYrUeLy/CFCY7oT9Zpvtl5wL
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2d82:b0:883:e4c9:93bc with SMTP id
 ca18e2360f4ac-883f1259016mr1921419739f.9.1754894042175; Sun, 10 Aug 2025
 23:34:02 -0700 (PDT)
Date: Sun, 10 Aug 2025 23:34:02 -0700
In-Reply-To: <d9b1c0c8-cd60-49fe-84aa-814b0191d3b7@lucifer.local>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68998eda.050a0220.51d73.0099.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in try_to_migrate_one (3)
From: syzbot <syzbot+63859a31071a369082b1@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, syzkaller-bugs@googlegroups.com, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 121C420003
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: hwpskrbaopa9as3faozfyqyu53p4juwf
X-HE-Tag: 1754894042-20066
X-HE-Meta: U2FsdGVkX18tDdJGzj8nz3MuKUkK1NUBKMGd1LgcLjNnWCghQCdpEsW4CbLdPMi3tK5JPjZCqdj3cqlGSECo0EMR/kQ+qsF3Hh9dVg2ZR/YF33Hafs9W53QicOvTpv74uLycg45evb1EwIH6jYe4jfuRWp1nmCiv+1LBzOzjSF7ZzltFImvWLROyxQk4nXs4eNDmhJSGkF6/GNgoWyHa8jCerXpi2ufBiWqbBoMqC+2HgwukA4OdEuI9crZZkds3ZkWICMh9baW2hhC0jY28W4apQqfgUNI3/TKE7CgNm5UQoqTh8yX/nimbhDnABKLJh7Tx9gOa9ExiIDWhYvay12p1JPBvJ4owDTdwgbtxSmygWolNuO8ooj76s2JYxENn8O1HpUwFAX3f5t6d5K/rTq3uAVBs4m70SEad702R5hMFy2+znXDz92Z49HdGD9YtN2lK84+mcUOTMN2SOBB7N5hCkYY0Cfu4/tA4H80/X/w1zdRqqkFEH920LFc9HTfpyfQ9TejCrOwHjExXbH+AkwNaKv7gsn/YikOuTsvcon2oQZllzUITVqYUYqd6HoxYMocz+Fk3fXW4WEjpZiFNkCijwuiKik7Oli6t59H1ooikhFRQkLDnShlXSlkd5dnrjP3Yt2KE/l66hMmrRDixlVPAnmDm0L7P+mpovkOL9/7Xd11cFB3IstbtiHzQmhkrEUY3/bSOdijBfwmT9/e0d62+WMRphk1QV/ahrox/5C8ueplDluHTnMa2eK0/H+A/+EFgRyDzfi0Er5MQZFYueLlLLTfUwaX6Y9AIszuWrwXf0yi26qeqDLpVZc23kOECI9Vb0U+mFwpHjc+1quzETLJadqc6qxVifj2Cs6argEhfu35+CC81fmROP0zAC2gDjfLD7zNfLtFwHegBXXztZ5vPUOUk7lKebRhC8mRNzXhHjZKa4CpJR2bTBD60Bi4cIL5Iw99AtiAxBJLxlVS
 uwcx9GZC
 jRWuql+vHPd9/9WuGJ13HNxSGEsBiacYhlBgHR6t9Omi7DKjJUUKQ9C1V8bxE2kQgX+8N+sVpLWwvgV5bjYh0WPvYLsSsrL7qgCG7WWm2/jv42o4O+2lNtf5zz7zEHZ0pzKqDEivRjw2QUqjLzfSR4+TeVlBDAVLB0IdQLgl2j9Z6HykuULxDnsv2UnjqkbKGZXSiaFi7Jqw0Xdct7a3XjUVCqwPvVMFH0ftte7ClqDbHXa3Cm1bb1BccVv20DFrIdPbW9R9Z+6tKwOPZKClEUcyVAxhkBfRUGTNAQKqYkOv/AoOyz83cqyRn08elz4OXFZ09ghYRpPTKVPVzcPpmskQ+WqAu6TysM0i9fgcLXv2gLeXvkCqht4lFMrk06KFEeuOHEm7kWU9ekTAiLQj7rd/KkAU9OIijYE73tJ0LAqZZ0tEkt2M2rBJ9DFB38DSe4FCT9biRRDXcMJw0e5ALXetSaQaGkD1kINtRb4QNALB7VYbFXgWFOep5KlOiH+MqDHTtX2WtRI4KPqxpy4kvwmbFG9Ku8xtblrrG8OYs4/5fGeJfmLjn2dR2vr3pDGAsViW1BfXV/5FXpd/zvQsj3K+lk7Y8UjxY03DPaQbMN0BOfAnIYw+I7GYyjXDqF6klXbUms3VGHU1+AXDHo7SnQl613qdH+2bB5fss+R814iS6AqXDAQnAMpTFYIx68UMoUj+PsxnjUETeZObG5L1lza3c2BYpbKVHdmy2Dw1o6XAsgnky5VBLh80i8w2ZBDv9Kse0jXTPCcWdvIt0tXoN/oXZ5du0V+ubl7p5QJHG20f4ZMF2XiIK0a8j/yQkVFHHtXVXB95eVXSQ/vodomk7ZAWk6Wj0lzDAN/mtydVeZSSg/Vs9L5WWyVVNJn9bEJSeYgx0E2KUj4lL6R1PSpvmD+VqtW6lGGyvI22BT8RNYL+qecTYob0VKG2maWxE11/RsrHm2l6+VDzx2HQ1v+/TXo08zuvz
 I32VzHlX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+63859a31071a369082b1@syzkaller.appspotmail.com
Tested-by: syzbot+63859a31071a369082b1@syzkaller.appspotmail.com

Tested on:

commit:         f1f00681 mm/userfaultfd: fix kmap_local LIFO ordering ..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-hotfixes-unstable
console output: https://syzkaller.appspot.com/x/log.txt?x=11990af0580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=75e522434dc68cb9
dashboard link: https://syzkaller.appspot.com/bug?extid=63859a31071a369082b1
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

