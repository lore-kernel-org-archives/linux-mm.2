Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3515CCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 03:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 521778E000A; Wed,  3 Sep 2025 23:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB5E8E0001; Wed,  3 Sep 2025 23:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A568E000A; Wed,  3 Sep 2025 23:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24AF88E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:36:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 861BC1409B4
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:36:06 +0000 (UTC)
X-FDA: 83850154332.06.3133675
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf05.hostedemail.com (Postfix) with ESMTP id D032C10000F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 03:36:04 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3Iwm5aAkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Iwm5aAkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756956964; a=rsa-sha256;
	cv=none;
	b=p7+a+p4cbapRhNSCSfMPD8oyCihGo513mi0SnHXoYM+GI0Z8Svg0lXQVuOwiHPjH95sWE/
	13n1kSe8YE/mG4XdvgWwaA5bONzNWO+EBKlHvKXWvkOkEP8l4upMB2y9SOvtQuc5irr5GL
	ypCJsT1xnW3/yAnM/byw0XlgqQTcYAE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3Iwm5aAkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3Iwm5aAkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756956964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=3kJIQbdDjMaKIwu8/RgGFYQ3IVbCoHpKFlYMG3WTfzE=;
	b=5tHWjtw36DgH85lf1ttVKjUG4p6/ST5DCMsU+AM8gjOrsxR+LwzCZ+qzXLokloV0sp44gT
	hiPrhYAQeOoftIw9Bj/Es+qmKpxkOM134kt7qk7FMhjjxfdl5eF5pmwEl4k4mTJ+4f6yDu
	JuL3qlUSqAakhRfeVyKDUB+uub/uGQ0=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3f12be6bc4aso6766465ab.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 20:36:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756956964; x=1757561764;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3kJIQbdDjMaKIwu8/RgGFYQ3IVbCoHpKFlYMG3WTfzE=;
        b=UJ+GCTXY3WVsreOieZ8dWb3ufiDGP3o8KjovdInEgUw9evHcvtsUnvlFpUq0gYlolJ
         W4ilwVvXEtyUhxVHxaERXMjX56QvHmcqSf1XQnzXa+1voqW+7yJjJJ/UnR2Yn7kjdDhH
         acJ32BF80h4bq+wC1rvacuBE+MfMlUUKbjtJv7bNth6+aDNSJMVrPpfcabLtZwi2EGpc
         sjfo2jDpc2Rho5iWsytVtfhzQiH1TXzPL2VtHSfQqnQ7OhV1DAg/9B+xNGXUDwk4IBwy
         66MgOysoyCh/k1ZkhdUOGl6buUCnVYW9F6lauFSzkAqAefmnh6lptFKVEI4BCDpKFaCO
         9giQ==
X-Forwarded-Encrypted: i=1; AJvYcCVn6msHGBG2gB2qp7Ku6OHdo3VLjgMps4J2wFYu3Q5vqhUqf+z8cfLbeKbkeSR+OP+g97g3j9A2eA==@kvack.org
X-Gm-Message-State: AOJu0YwUbhKg79wRu4GJnNUD7/uprUMLnYWaN8qHlfH8lMEgLwOSpHEc
	EdDje1r3aIZvIiOUcmxZckJhcr7x0BHw+406Jw4FYuATYDvRoTGEE+yoiIJVShemqAnW4QENLy0
	idZYz84Qic5D+jzQQHIFQsf8qYtKp7eRY/W9XZwNLYJtD5P5+0KUh3ZUmR+0=
X-Google-Smtp-Source: AGHT+IENXRrLPWSGUnbbTdfTn+b/gxfZBl4CNs9GbenLvGkYX09pwt1Lb4WmWZmlu0cLEj2iQB+7N7oCHFhDvtU1eW4rQU/TouYe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4903:b0:3f6:5621:fbde with SMTP id
 e9e14a558f8ab-3f65621fe5fmr164563825ab.6.1756956963928; Wed, 03 Sep 2025
 20:36:03 -0700 (PDT)
Date: Wed, 03 Sep 2025 20:36:03 -0700
In-Reply-To: <000000000000939d0a0621818f1e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b90923.050a0220.3db4df.020e.GAE@google.com>
Subject: Re: [syzbot] [mm?] INFO: task hung in hugetlb_fault
From: syzbot <syzbot+7bb5e48f6ead66c72906@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, dvyukov@google.com, 
	elver@google.com, glider@google.com, kasan-dev@googlegroups.com, 
	keescook@chromium.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mcgrof@kernel.org, mhiramat@kernel.org, mhocko@suse.com, 
	mike.kravetz@oracle.com, muchun.song@linux.dev, osalvador@suse.de, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org, 
	vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D032C10000F
X-Stat-Signature: ofy7zdedjme6b5oem11rksc95niab3yb
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756956964-732298
X-HE-Meta: U2FsdGVkX19eA8/cE8W+lBAmm+ZWezedrW/JgBrkBVWC4AMsTiMS//dyfH+Jx64nLfKzy9IfedLQ/nMKFXXT/kIJRrX0wNEh7FbwkHa4/vpTy7zPT2xNGhih/oD1M8i7VnCm6FeqysPqMIdKXys2GJz8AskDvSzdP89TsU6HTTQ27LO3ZTsAKfb1k77uJWQiQdwOWhLIp6B/BYAhgCyV+nATkBdf9+PTzKtWaZnoff4wK+otRxCLALX2qc34for2qHGX2j4Uc9JdzwqC/14fkeu18ikWhBqy7Sx1Z1L5GXHKo616EWq9poH87xYlNZd3uzmTKt+UzE0e/yaBIsPPbV4O+WbxSmsabOp88Avjc0op07wQB3G1+ali8oBAWEeG92LF58X3hoav2HN895RuJm1YVw2UF1KtzM1gSuE5MJKCzMh1lX86VB/9n1yN4wbgZMZ+rVDNRj16euxzjGLLFWzpTJpZWX+nvYagM3g7Oxv5x9YFHPNzZDNl+d2awLI9zDauCbUgX64JJd63mQSarF68fbv5bZRaCnLeIiUYMOrnDgVOHSqM++Bd9EnDVVqjJBrPzY4t8NezHHuSqADIFMmxEeV/AZLp01eH+wxWH5B6zRb9WBR+umh6+VaBg8pC0g7z3raSlFpsWDfSFx3THR7faIurQcP7omnXc5SWp4WjG8CKniQTj03b3XH4zy9v6BCbj5sAAV0gbkDgt+zjkDfMLZZsnG3lhpY6Oazs7dXtcaV8GIf1iZ/Tl2T5xgRkRowH0QXI9wtpBDcm10FdC1onIaD8LcUvWFXrwrxjTz6vW44jAuKxomzDnQS+DhgIZs13me3lxC5i4LrctPxzDc18xNgFyGmn5z86Qw/YSR2mFCt3sp1RqFCfvGLQIu8yOIf+nJgpC+gFfwm8ZSh47PBL+uwNmRrZC60liNtp9oqvw6Er3obF6d2ndcZwosoO458iVaeZ5HC7biNJNu1
 e7yX9mQV
 0XD/m3zq5hnGxm69yNXznB+1yw8kOhdBQYvw4cLc/kx29ZODuxHc7G+FxOSJTVPYPqIRIr93DGPPmyDdd3odBhoqMy3fk/PYwZvorG+JGkQ4qn5XihEhIyMrnfP+69aCWaUeRZQvX8RoEzexcB23G2Dx3oNSUJ7ZAKakX0WklMt1A0aY4ZlTXcn91bGWSRtduCW3zXUeya/0WPLgfYoQKVAg7qjAIceqXBW5aazHazLCN/iIZm4DM8L6t3znWXi9ncJsLmPAYvB1PAAvqrXuXShQ0OxOw1G3TQh0H2WhXJ+IGxhUWMdwDDYTeuZ7dLNMYKgthMDYZajsrzcHx6+IhCsyN6Kk6Bkbw84IiQ58mZ2mNhiFaJcBF3CVXMBrQpR285xH21498BILV7Vq40waOZkEXujQRYflTlasajzEeIt2y57c4kq0z8QOvS69s93KV/oUEQj/izLGFdwxaV8RwZEccXTTukxPz5SXErsHHtn1+i/ddvj0K7gvE1bR8qRPQ7zdSqOEfq4ZDsxoirix+jjFkPQciJcXvlqX+KpHriTxj/qkFrctGHEN3BK49bb2Mv1rcJfazIFRpQAFLfxmib+dYSkldoLy6gBGXel+H7fcmPBR3vl5Ufn7EC7nRaxnd+NTTB8EcK2Hi9rK5s142Svrcq5jQLk1DyYTa87C643BTDr2jJZROdsHxk4f3U19Wmarymb/zQq9Gzk4ddrLNRnNKMNjbromGQrJLPrvvrfOLo3wG3Dd+onnjpaNU9Tm7fzFGghBdd3RJcWWXXs82KkkWkwyYcbtWwo4xdI/BJMj7Z5zTKZ6Fds5eOW1qVhtYZgRQ35VM7vrDddNfvSCz6msdba7YapxsLeEIoq4+6QY0k+rTBaZQV8iNE6Vi0B1VL6OLJvXrNlreR+PWSTbBeeenWdJu73JYQN2NqIeIc4r0TYVpzdlrUR8Lfn/4j4uV1Mp0xl/fAbQwyGltgrhrE/hjzhjT
 bmA7TByK
 CVZzWdolppxeavU3kgP84V1CASrB0lNlDNlCuJnlax+0jihDozYJW/FYEia23L38TT/ip8LoPYZ++M05eMXlhw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit 2ae1ab9934c785b855583e3eabd208d6f3ac91e1
Author: Oscar Salvador <osalvador@suse.de>
Date:   Mon Jun 30 14:42:08 2025 +0000

    mm,hugetlb: change mechanism to detect a COW on private mapping

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1289ea42580000
start commit:   87d6aab2389e Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=fb6ea01107fa96bd
dashboard link: https://syzkaller.appspot.com/bug?extid=7bb5e48f6ead66c72906
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17dd6327980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d24f9f980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm,hugetlb: change mechanism to detect a COW on private mapping

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

