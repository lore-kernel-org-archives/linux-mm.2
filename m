Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29963CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 11:06:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700F58E000A; Thu,  6 Nov 2025 06:06:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1388E0002; Thu,  6 Nov 2025 06:06:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A0948E000A; Thu,  6 Nov 2025 06:06:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 453478E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 06:06:06 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE6F016068A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:06:05 +0000 (UTC)
X-FDA: 84079902690.22.09C9E53
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0F6C5100003
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:06:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3G4EMaQkbAJ4QWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3G4EMaQkbAJ4QWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762427164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=7YLmpBcJQQJc3uvBPyux9aBsbuqfkQpqtFUsIwakHSk=;
	b=cyX1heVFwpy5VKBJIUUkbKWW1CJIal8bIg/sKcbjauRDtZ0NTZDdDz9Usy5BbQe7HN56/M
	ipLtt7XxM1p4TDGMscXTcmN6ZAnwZrlgYnQb8dF7T1NXgKmbVXcYKcb6Pc1arbfX/cw5dd
	L+SyOZ1iF77MVRJ9neILzrcWjN/MUc8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of 3G4EMaQkbAJ4QWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.200 as permitted sender) smtp.mailfrom=3G4EMaQkbAJ4QWXI8JJCP8NNGB.EMMEJCSQCPAMLRCLR.AMK@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762427164; a=rsa-sha256;
	cv=none;
	b=vcbASRManwRYmM2F5kiomF6Rb6iLciGDR9ARTudGEFkutueqYIh5ZQq7HfXBygNGtLpKSR
	kzb27pMTIh/V0rsMLOPd3IAabtqLrBVO0P5OzNy/9BBEcyWh+E8p2LDPolwo3o7lg6DBJV
	DPEvFjuugEf8KO3Scld+7evJ1DyIhVM=
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-43322c01a48so2052865ab.0
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 03:06:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762427163; x=1763031963;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7YLmpBcJQQJc3uvBPyux9aBsbuqfkQpqtFUsIwakHSk=;
        b=d2MG2hChewfjnGtrrR8Emx6k7d8DxRnHHgkLoW756pwSl/E8T++Ewz3V5zM7tK9PYj
         RYFSEGi7F9bxujyc7uosgJkBV2Y00Ysn10+u4OIVMEWyOBE0paBn1Vqvpo34d1sJDNE2
         g8Tvbds+X3eLL5DvIcvteUWSHuT28uRRWbVF4JCDR1h4zIlLKR0tbs+CF679+fENg83t
         osxzGhFIatKvZu91x43oZF6ubyIJEWRr2cPJB4e9tl7L+nbkH3k0cWpqQVW50myNfPHp
         EkwNnTA3sZg/smsYx9IE0HI1lotcjGYPEgORY/hc9ftJusEZN9s2P0fcJRRKXJamcbZ5
         Nhzg==
X-Forwarded-Encrypted: i=1; AJvYcCWDWnFyFPhGe7KqKwQQVrtZAV2S2+M03LE8BzPP3Pl8UGRCr+fJkqUAUm+MOlOR9DaOcSBmtFbovw==@kvack.org
X-Gm-Message-State: AOJu0YzKVzYrO3EPb2wxr1FxfaZ/Sw4jbTHCvBoQa4DSzw1sHKY3r6ug
	BERN5r8OENWuI7jhD1yvZ4e3PzsymXcS0WocY6BuI1RvoXuV3ZqbjaKWSQr8NjP3inbPLdKxXHh
	WtOdJBDaGye76CpVPwHIA/4BzhIUtD5Fb+Lm2OVUM1O6t7fE7SL7irUX2hNI=
X-Google-Smtp-Source: AGHT+IE/u/KUDmfVhtAT+bF/JPkOxMXgQqhGjaEF35rveLN7I4NxGZIDTM47S3PtW6CsTFA7cmt9IEyen43RF5wsFZCo3/mO09du
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1567:b0:433:2400:2eef with SMTP id
 e9e14a558f8ab-4334ee78384mr39296765ab.13.1762427163097; Thu, 06 Nov 2025
 03:06:03 -0800 (PST)
Date: Thu, 06 Nov 2025 03:06:03 -0800
In-Reply-To: <6774bf44.050a0220.25abdd.098a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690c811b.050a0220.3d0d33.014d.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: slab-use-after-free Read in filemap_map_pages
From: syzbot <syzbot+14d047423f40dc1dac89@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, chandan.babu@oracle.com, david@redhat.com, 
	hdanton@sina.com, jgg@ziepe.ca, jhubbard@nvidia.com, kas@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-xfs@vger.kernel.org, peterx@redhat.com, 
	syzkaller-bugs@googlegroups.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0F6C5100003
X-Stat-Signature: nzs5gkurb1t1pr4i7hty5g3y1nyudwyi
X-Rspam-User: 
X-HE-Tag: 1762427163-1113
X-HE-Meta: U2FsdGVkX18MEtuJUO/oueT650WzdlZkNoqp1hb40cl+/l8fvAeKJZj+J5pcj/mxw1QhkTak4Ozpob9hIU2G83rOeYJLQSqACLbmvxlT4C4wBaAA61BQ5i5n58VdkhfkpkiyC1WM0cATmcyvLjb2TfFNPl0Odhz/5M3wQsh1O6Y83XsJj0SSxiJBaLggXcfLiZXLOS9vLCjSIoLMZvpMJOg4za2DK3m0oWdBxKtj9aFdV7LGSHm+kC2RckGmk18wJuDKqQIvcehbV1WmSG4ovofthlXhgrjX88ETIYJUg2x5ulicM71KBGyUFZOXx6z8BWfpRm8godTO9lIM1c1ATjKXlPkT4fnBnAz9xyZUlL5/NuWzYwE/mmLXgnxSp0xHiEruTZCAGIo9F8XEwsFDrJSQbc+u99qR0KW6TZnJZJGxAcImwZvzt4IuGN+gIoaeys3uNqWvY7tyCk87Fc7kQiQu5vQXYmhC1ctqaMJ8eNjTqa0DMO+kXzvMV9C+vstMg/cEZcsmgO+4YrMdgLGOMyf0kdzZyq/Xj6LyWZbgEHCWcmoM6RQqUNtTrpKZoXLaVxIm0bAw2W217NkUMYFZo8BKhEWxe91QDlWGsodfJCO8pHLBD9BxSS947kgsr7KcC7ByPEcF5KJeIFuTx71n5ws0nOpERiTqGnJ0HxUBqPCXVdhBG+3sBPHLODTTKTKumIfZ6pkDJ7Moaq0n3NAwhGyCdVlTjq1ZWU/XQblKZbcRwI08nH4hrRjMbLIlARsbSeYpO4QFjsF9G6Mlvylqj+23TtefPQ4Zz0kSbTgAlt4YGP9NDH15Xz3jy7S+Y1V72Dv0vkexJmTy7rM7/pZdJY4Avjf8t0p572o3mr+0zXLc3EG3t45OQ/hzEWyYl/4UE/YdBLNneTHyVTkKP8P1Z4xsXGg/eZGGfW+QyfspoKAcN8SGYtu2OIlJvY49NvuxOuZhJeWpOr21RbhKxrj
 FMkW4KIw
 TOBrDyzcYBZYjMq+pPXFclt5X1pFLYm406g5OorNdXcQYfu4x+zdJg2jjRZSP77LeOsO+e4+qMaa51RZZ+9uG1dQ0tBPFiW04crpKckm3iUF0JpHRPDFW83f3a9KR8ie/+rHsEiTenopZ3uy6I4txAft1pErwiwJj9qplTRX7pHz6cB1N35syOqc9sT3tFbQQ3+RGUsmMTrNM35e1Jf9ZUyS78Qr4F8SUEk5lRMlAsMtBvrAfhr1MTdP8VnesVnuZmZKReJM1ZNwseE5HJqceiVSuk8GK0jQ29p7A3Ec/JR9BMe98B94b7GbXqdAbrMNYnamV8WYjHqr4EHqm4I+7Ch2/E4U/7xMON2Mo9RvDSfjxrUTQ+MGsE932uxEjUfCgItLfziz8wQ/Oe9Q3vAdspsTT135h9I4UV+6DzZLRAv8SjUcEmrZPX9c88+Xlwe/9LSfIMW6ltaPuQ6WcH+JhWjGispo+Q96z2800H+M1ujtlE3lgjUiCJdnXxdnz2h8jqnWm5FkxIkimWfZZB+YdR4xtWGhLyzQ+F41QyTBZnNI/SX5ntOte+hOaheczztjV3OKJFb1zvkSZsNZYUbR9qzHevdoi2pyZtXFZgqLBaS9OqH6x1Jyc2DuvJpqkkF1RVjA9Tnm4rPGaGJHCXEGYGt4CBhYMe2ESalRMOXuoXr1wyYxDlNpkj74D2uyMLEsANTzoVX7djYBJJPTTW4AQ7HY2ZnaOHGAJ5wzdEevBXNPFoWuvgEx8/Du8Eo5eXoM1V7r4FAgLj1NE2OhCsh1lUXqGAAFhwXLoAc8zWrsPL0Ac8fOV/w/EogeeOfilTcy0F3/c5XwsOYNZIgnSzIH0ccm6eOeOCjO55+GBN4I9McRKbaOItp2JAjLjgNMKfCBR9ITIc7YpAQKZoS5dO94Joowc+YhB2fxanlRu72B37G15X8i1aRLmF16JfL2BAqTEq6xzR9uqrwH+djXTYDGNSuPp8WaM
 eU+PcT6u
 vuWJ/cKR1GnXgK4vg88M5VBTuXb+ut/jU6Gnm6KstabL+OnzEWv3pH3eGj9vT3uGRVfasZ55XOclYqFYai5tFxUyWZvMbPApc7oqFKS4ZVurbuO++HusJp/Eg9ozNnY+gNASd1mXz8YN88AnEKhJT0Zrhp6rBAeJSPoD2dFgqXE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot suspects this issue was fixed by commit:

commit 357b92761d942432c90aeeb965f9eb0c94466921
Author: Kiryl Shutsemau <kas@kernel.org>
Date:   Tue Sep 23 11:07:10 2025 +0000

    mm/filemap: map entire large folio faultaround

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12658532580000
start commit:   b19a97d57c15 Merge tag 'pull-fixes' of git://git.kernel.or..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=292f3bc9f654adeb
dashboard link: https://syzkaller.appspot.com/bug?extid=14d047423f40dc1dac89
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12399442580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: mm/filemap: map entire large folio faultaround

For information about bisection process see: https://goo.gl/tpsmEJ#bisection

