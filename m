Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04AAC982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 08:25:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C528E6B0092; Thu, 17 Sep 2026 04:25:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF0E6B0093; Thu, 17 Sep 2026 04:25:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7FA6B0096; Thu, 17 Sep 2026 04:25:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 809616B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:25:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFCDB1A0245
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:25:04 +0000 (UTC)
X-FDA: 85222568928.14.3F5898D
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3EDE740007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 08:25:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 33qOragkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=33qOragkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789633503;
	b=W+VVHotGl403FdhZw3fnhxs04e6N/F2HFz3Zp6dwQ3guuuyqe/a12G2WACMBHBmhG6JbG2
	l/RNle4QuUFftpdaQOGvJIuN4O324ur292SR8aR+rDaBtrFogZ1rlhRoFbMCldgHP6gi3I
	oFjws+pWGsiPjN1QVu5aPKcJoAyVS0A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of 33qOragkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=33qOragkbADEflmXNYYReNccVQ.TbbTYRhfRePbagRag.PbZ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789633503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=uBkL6ZMYYdQOBhaz18ohIP2qWIBpLXjs4rOb70E61hY=;
	b=PHrkVWUI3JLCFukrFvQCQ0eLlNwyqEVrFc9E97I+46D4D1oHzKEz9nrmS3Q0vu5xDAILg0
	71OlERDK+ZP68okeBKBKNJvQYp83DbxvydWZs3otC/WBAcOEM/9XLglxB1vO5KOSSc5Cfw
	DgcHTkE0BW1Ic5Z9/KtVFvHcofalWXo=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a49f09233dso540415b6e.2
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 01:25:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789633502; x=1790238302;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uBkL6ZMYYdQOBhaz18ohIP2qWIBpLXjs4rOb70E61hY=;
        b=ZqYLAocaFSzSQ8gJACNVd9e3fMtTAc/upbKw14EmbPzIANguVjEd3641+myLI3CeJ2
         jXNzwj5QNVFvMRtklw7PdY7rvy9mKrYJwliilFp0teo8FQz+vFdNyIXDseU/BJCXg600
         oq3eF8jl4LLIO0jlUhQNYmlVpUmwTLjsJo6TT7+3n6yQun4vdLbDIgtNZW8GSwuoOg5C
         7eqbsmRHlcE7KKwbw57/PPi4HfdkVLWYRFVexfcYeon/logJagYH+gksIXeJXYCeRt0I
         G+nk0gMBXmR/NGLqen/c+LoLzqews30lkxRiUeKxJSk7JIvbhHBnbU9woDg9WwexKbjY
         SpBA==
X-Forwarded-Encrypted: i=1; AKwUvBwrEq4j/XPWIAW3xlLtpDhBCzILxV/Jq9E4I9aJyoZBq28UoqgkBk4bzJHsGqWHrtienjHQuorM7g==@kvack.org
X-Gm-Message-State: AFuF++kWAuZUlX8YNUMnd42owtIl/z/4X0GaY8qDbj+bYMxhiqo1Sh+4
	6eW1ddB+VzB7WyHtX4toxhWOo8FIZYwcARarF1tU946qjePoI50yAoUD63aX3LN3mEzwoUtii1T
	R/uDw3YlPIUwBskVNPVYgAU8x5HEhy4sZV+OelgFUXbVX19TbyfDdBwKYLrY=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1692:b0:4c5:92fb:218d with SMTP id
 5614622812f47-4ca4be66e9dmr5399582b6e.22.1789633502228; Thu, 17 Sep 2026
 01:25:02 -0700 (PDT)
Date: Thu, 17 Sep 2026 01:25:02 -0700
In-Reply-To: <aqubuvR_2XCNav28@gremlin>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aaba3de.87c06881.1db2b3.0013.GAE@google.com>
Subject: Re: [syzbot] [kvm?] BUG: sleeping function called from invalid
 context in kvm_mmu_notifier_invalidate_range_start
From: syzbot <syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, bigeasy@linutronix.de, dwmw2@infradead.org, 
	dwmw@amazon.co.uk, kvm@vger.kernel.org, liam.howlett@oracle.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, ljs@kernel.org, lkp@intel.com, 
	llvm@lists.linux.dev, lorenzo.stoakes@oracle.com, me@brighamcampbell.com, 
	mhocko@suse.com, nogikh@google.com, oe-kbuild-all@lists.linux.dev, 
	pbonzini@redhat.com, rientjes@google.com, rppt@kernel.org, seanjc@google.com, 
	shaikhkamal2012@gmail.com, shakeel.butt@linux.dev, skhan@linuxfoundation.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EDE740007
X-Stat-Signature: itbbkamg6fjj61mpsx1pt94ysppg5w13
X-HE-Tag: 1789633503-455656
X-HE-Meta: U2FsdGVkX18KlCakyx5bCaojN8H1cqYoyhL0B0/ElNyD63s3vf5dV3hhPj/RZS/NoYxJnp9NUuI4++LDV0aIbKn6RouKHzhTj14qlDABcTgGDlDDdNzBzH6lv8+WnJku9ho8uWB3oZqa+MZbL66S7oUXpuq6SDVxf+g6TIqKPalde1/x+4IOjgFBKUqerWd8ZOezjnPC8KFmmERic/YKk4lJLzIpViFFcjbLZNg3zPE4Mdr/fWZBXDrqwgBnKzNAcJwdhrYqU5j68NbDu3Qy1guq4RJ84/OYwFSJD7tnixTV2c8HgwNavXHyMzLvwMU5IwaM+bKN2kYtYVxC8e+3gZUc5Woms8mQUkab4U3denEAKvQhNSuxhk3znNjty1664pkG/e2gkPvxXTFf6eGVnkufnrEXa92Q3FcHxx+cueaVyUueKd937giiKDcP5Wbw48aLZkZBU1m9Lq06R/wG/uNgqXQeOFVwCyEAcy1TEpWsi/H3U3HWKG/xGnvwG+5kB0vn/LI+UcuVG4uteZK7N/ruVYuVnIQD+RLaDeFhfiZPfPn8gb1OKr8LR8Giu7hPG3+4s+QzN8XEJbsD3ZPsEi3dFqTLz9UZIWLBBW3yYsol7G1TWkA2otPY6nlcJ7Rl3SO9zNwgyCuAZGwIzy29xfCdAEFn+cy+W27FOYb31dTz2zLF5DDGbrWgbivOxfWvEp9shhrbzShYb++iToOKb4DQJGi4+9nkuqMxuY40Ul5AU9ZO3WGyi4W/PM1AbQ7uK/gVwCs+fMk8Bi3JlU9VPv7CA0cAMGGsFdEfAbJkAn/Mm+Af6e4guNLGum0PoIxfGrbuW6e08ss50I25zrJGqyHnX/FoHFguKSaxWWISPcWreAJ9iwx0T9ODjjVteIC4f+9duGORP4DJaihZe+RYvwnUXNyXoqV1gMyuSYKkiJwPCY6oDvZA3QmQsPRQu54PcglhJPPgr0wc725MkRM
 XgcQsYzp
 ksy0jKx7hC0vB2JavruPKz3yeF3qqs/d3rXgkDI+C3iUYRCLK//sa7e9RCr5uwlSiwjVmqyNRJKbQie3DKPStqSFKFD2YliyVzn0KqDoEoKbsPOjfCvRlWHvCISCc4G0HqYymk3IPTCcGfzDPrm3fGP9RHgV0tgQ7dHngRdrsyNJ/Xu14as5F1qsXOudrM1l66vxqsrmHqVe+Lyxs6/XLgIFjiBeaT3VcWE8OsK6cHMMqfL6dE407WH4+d+L/LMJUaOM3nY5XMZadh6FDk4etettNYVV4YOcoFjOHOnyw7ZGcrY1toY2BzamS4FYdqFzJK5n+o+7m5Tfs7yZjTz9Le8MmGMHH9fC0vRwOgUL2EtvmF+nkEpvbDYRtseDPB8FaFThTUitRnTSDpHrdY6LRYSD2QSeHhluenb+TUnwaAbT/4oL7xz6RLMmFU7Z5xZ/Zdvkx1mx9dUt/FZj4QNnuI2h4SZ27D5b2JQfa9zrw/rTN1nKn9gcnXgd7zI/uqUavQrti2VgujQnQ01axe0GA9xKpRq80uHWqZKgDMdAS3XzXe84+FHl8hFHvZx10EM/NPIsoA5PFro8W+r6Wl3LD6ZG5xvlSxlLMQninbmOx8Yz9up76B6NkfC2iVZFs06796IrNazX5nLirRyems4YwazhfLxR7mXulww7VeG5zDh46Nho0UH4EdU98FGZfJyc1JLVeaPYu6ghbyagsR66eH2rpogDl1i2sFtAyQgiiBo/8ijgfGT/c7fsn9AM0qVNkkwBoXqAuYW0jQSvIEqoYyt+eMV6+tmjXc0rLeDOT5qabxT3BzLPjYXWqssmU7W10DrI09SqANjYabRPX8zllbFplTHHgs3G7rEoU6fUWVgzU+Dyzo/lLIL/6ar8XtTGcVko5bYCbbbzWMDNZ/EJJ/QIRzfF49Tp7h3MlwhkAmCtlZXot6LODh+o6jnUi02iiZUVL/da5gvJ3PYI9yyIucHleobQp
 YgwL9EZR
 xVR9b4Sqmf4Oo2oxbFz/zjlEY4Hj79d4xkzryLEQNYS672dKE1x5fHb8W6FuohB3xaKaT9ilQi4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Tested-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com

Tested on:

commit:         f902e69c sched: Allow sleeping spinlocks on PREEMPT_RT..
git tree:       git://git.infradead.org/users/dwmw2/linux.git seb-nonblock-rt-test
console output: https://syzkaller.appspot.com/x/log.txt?x=17d63bf9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a263b38e64491d5
dashboard link: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.

