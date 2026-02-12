Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B1DDEE36B2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 18:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC84F6B0089; Thu, 12 Feb 2026 13:08:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAA056B008A; Thu, 12 Feb 2026 13:08:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAEDF6B008C; Thu, 12 Feb 2026 13:08:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 981BA6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 13:08:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46D8C861C1
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:08:35 +0000 (UTC)
X-FDA: 84436589790.08.2AD83A5
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 82268120014
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:08:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3IBeOaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3IBeOaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770919713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Yvycq04pVPWUL32pOjxUaG+/MLmhhHqjiM5kRuuTJYM=;
	b=gAp2/sAHMCfitQWavOjhU1utFqBtsaLritn6x2OKBapWblmxsxnEtrbxRp+YT3n/a2Ludc
	SE4J1ykqucHlFAAXGlSprJT8XfXUW2H8FJlkhAB1sGnT59faDxGLUqqvIoP89PK1yLkvDF
	W5ObftgSjvvyEi97Kk1NQYnOkQeRAY8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf29.hostedemail.com: domain of 3IBeOaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3IBeOaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770919713; a=rsa-sha256;
	cv=none;
	b=pvxua9f1FTUZBObjumnHooowHJY6bPrYFDvVzmB/HLMXo2cy090r34NBPu3bVWVyHlAfgf
	RG2+gT2I+FowI1iNq3DopKGrGQSGvHA52cG2oC7HX6OHvpIANM99glLoObn/s2Y4nERLfL
	hMyXoFw+v/Tn+VJmkrEwsAb5BZsLQPs=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-675f8fd5347so1037592eaf.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:08:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770919712; x=1771524512;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yvycq04pVPWUL32pOjxUaG+/MLmhhHqjiM5kRuuTJYM=;
        b=YCLZkQHGkiH2gvkxtEqZcHu4P/GBGF+T4U3/h//3a+tFuGBpEyDB+yGS8s9GFOB9QV
         hUxouZXvtn/p0lJD7qKjVN3S880anaaGoLLGzo2YY7fd0ylu4pI9q0nvOPwGIeaIhSfc
         nwMUUeREyoYiASg2kEt+7gG2u8Z9SmqxITfs1TMzslRcfa+fOIi+pUgKNciUfgcIAuaz
         kfRSMdjqup3ttI9OZgWm8eL4Nw7XucTBc9zoXaoyZms84GNSg/yQTMsU5Is21AFgW1dT
         dxYoPuJtQRI/LVYpkG539yLboI42N9tMdXuCn+f//wS0wkLu/CKeCjpkUo+HkqaIFLku
         7wPQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6G4xIAb5bC5m5AtKgEpvBro45pIc/KATL38agU0XZzRXBVaJ9NAYyeOpRs6Qc7EevzUOCfxrQNw==@kvack.org
X-Gm-Message-State: AOJu0YxgELmyTam9kA8RkBj8oHVS+0Y6Nu5gE3l8BxLm3PhW8ruRn39F
	7qw9scNOmvcF97zpt4dwuPwreUk+gg9ImUsjKNn8VR0GOsQQdcgQQPj+Meb6l/cP3+aUvQZ9u0y
	Wd3Qu4nJMsJ+Hx8ajbZuVUNbn4lSXnoJScFpLlAgvwkG7KIlSSmKXtXV3M+M=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198d:b0:65d:3c7:b57 with SMTP id
 006d021491bc7-676ee27c2f4mr142899eaf.34.1770919712604; Thu, 12 Feb 2026
 10:08:32 -0800 (PST)
Date: Thu, 12 Feb 2026 10:08:32 -0800
In-Reply-To: <20260212045109.255391-1-inwardvessel@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698e1720.a70a0220.2c38d7.009c.GAE@google.com>
Subject: [syzbot ci] Re: improve per-node allocation and reclaim visibility
From: syzbot ci <syzbot+ciaf452181ab05b97e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, axelrasmussen@google.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org, 
	eperezma@redhat.com, gourry@gourry.net, hannes@cmpxchg.org, 
	inwardvessel@gmail.com, jasowang@redhat.com, joshua.hahnjy@gmail.com, 
	kernel-team@meta.com, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, mst@redhat.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, shakeel.butt@linux.dev, 
	surenb@google.com, vbabka@suse.cz, virtualization@lists.linux.dev, 
	weixugc@google.com, xuanzhuo@linux.alibaba.com, ying.huang@linux.alibaba.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: 5it4izdwxkiajk9jbsqxx3161d9g9prf
X-Rspam-User: 
X-Rspamd-Queue-Id: 82268120014
X-HE-Tag: 1770919713-787990
X-HE-Meta: U2FsdGVkX1/QZ52s1mQFriKMCr9l/6N4YzEgaOK3vnM0C3Td7308ukFneZrl2q3FlKXQ42NoyygRf1mhihI8Ej1le6dPJhf9qJuzFAB9990igYd2cTzbU4vASHRp4wESJz4zf9YjL5Lee33rBJhYNfHpSjkENst5wT3zlQA2r40hd3QmpFRcjJMmFWPOV9vtdsWicGE1ztYSS4VMS2mAb+um60f5a8ztb9+TWBz+rAjgSvqd08rL9UdcrQdXRfHov08JUGoHnNdCbQRcKFSs9IF9D3KPRYNmqBETvx6eNPzWCtnucAE5CAjecfqPtoAbs1PLKSBL+m2Uml0yGusUXLuSBv5vI2xIWYY2ad97megapmSqduNBzXtXjfR+S3PoAd1svn6OapYAR6aNLJ3KRumFjZfdfNdFadtZJF3JB3pSEAUkN3AU3OguFoY2Z69W4UsvYe1694t/EQvPiaZGx946mG5LAl1kJ7Zwn7FF6xgBTuyLP63e3yTI+HAbBqCdyxbtg2U3FnaSIDD+XUSwyVf0bFukYLY8j78N8EucpTTIo8/72zcIRdJvrdWujZgBYsJClpIBx0JaiGskjiZxx6db5MO8QQ+ZAiBEPgvKXtDW9U/FfmsrFwwuad0JqQwgc6LkkH146QGTV/7ruBWnQR/Qb2GeDWbDtkI0eSqPWWf69lP1ZDrUP9OiSkt34VtsYIkyG5Y6yvcpRMQnctVWwaO8cVRBp7x8a5hMDx7QcWRivgdi0mvdd5udNwwpfDG/wyTZuzyffYfwKNjm2kA70MDNoTd42oe/T551fcfVNpZwKP8tRwdGkn+xN/g7/4sI2fACazf9sZiQo4yjIgftdD9UmuU2LX3S4PXBwN8V/IOhA606yALvga82ru1jMS1WOVy7NLHTloIsEe8SP8xDI5ufL6qveAEXz0gjWWEHPfMCytzPNyDxCMXT/trkPXA4MeMCeI47qcGwBOK0kRa
 /dSyolc2
 U6Bfw0WSAw6s480IvYvHEwkzSZb+yFnAKuNTTeLTSLwciYmZ+qF7x3Yt3uG1+tioNTdbWjJeztyWPcaoiMrlLPpXo8f+daiECtN3GWraUeZ4mYVYKCE3tkLWcrTh3XUqqKqA8Bx0oG/LHM2Qw7ABaJ8CFUcVkNsMhHJnhTnWFMIrW138u6JbCo3axjQ8fOLRj06XtyYmNEbMl2rKgcHy+kUemgnxir3i5ozewIJv3N8JGreUTpUD8V4rLIs/9RJtmYlzCuNixFbMJZQYBkom+u2k26iI1ZgQ9vJubORhdVJGx1S52b+j4EUliYVy0d2iTw8cy4r+upz+E3LHYinZavMWiZh0P5/Vu2rQsEXgBQWQT4i7XaCljFSZSKAd8viQZF8raCsh/Xj7uBScoFWXHjNMAhPghfkRbpigWP3ZCbtZDbnju70N3DpI5YWGTSvSYlXTti2UltivUs72YkYTJQ20UnPJ2ljSz9GhQwu90+Z98Dw26WdzLBcjns40AdqS7HAdXVRjSCV3DkjfwZa7Jv47La9az5dmktiNKbqsY1/uJ7UgfVCaGG/99MDwK6w7Q6yTCil7GCVHChs+IKCWEwcx7Tr6f/KtPsoc7Ju9LV3z422QVYYNxs4Gu8xnCkIZamH+CKeGKWMjaHTW2+fEroksr40CyQRJk2ievczXZ1tW0fWucAjD/HePRaAre5wOZ2seH4yhvH8b1UGxMOXEyrA+LovZ74WemJmmYq+C7NyTXmZsn0QkSzPf5djuUY3vl5vWUT8LbudbQFSe0qu0UwxlDmbv9M/N4SOiC/yVPyyYPLEzOsEeK2abq0YR3p2xiFRrPdZH31IC4QsCN+gk8rAWA6cxuTJSTgTsmCa/pBBio9x7BoCujuJ05HNnL2TueFe5D/8kt8MjSqkou3ePWIgNcV7A8+XztiK2xwLHHLqzNpV1xxPd/UqeBtz4W4MG1Pz+wNjDVvbCFzdKSOahawzrG5jPt
 HNSlwKf9
 Ztb0G9Ijdmmwrz06dA/7RhUuZvmb6YvDSTWpZkqehORzYkcLwapzjUiT1UZz7HApf86Qg6PlK5ZQXk4FZaAHQd44uE/Emwpd8jdI91G1pYE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] improve per-node allocation and reclaim visibility
https://lore.kernel.org/all/20260212045109.255391-1-inwardvessel@gmail.com
* [PATCH 1/2] mm/mempolicy: track page allocations per mempolicy
* [PATCH 2/2] mm: move pgscan and pgsteal to node stats

and found the following issue:
WARNING in __mod_node_page_state

Full report is available here:
https://ci.syzbot.org/series/4ec12ede-3298-43a3-ab6b-79d47759672e

***

WARNING in __mod_node_page_state

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      72a46cdd4ef13690beb8c5a2f6a2023fd7ef2eb4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0f678e4c-a4ba-4f17-8ed7-8ae99e56a463/config

------------[ cut here ]------------
IS_ENABLED(CONFIG_PREEMPT_COUNT) && __lockdep_enabled && (preempt_count() == 0 && this_cpu_read(hardirqs_enabled))
WARNING: mm/vmstat.c:396 at __mod_node_page_state+0x126/0x170, CPU#0: kthreadd/2
Modules linked in:
CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__mod_node_page_state+0x126/0x170
Code: 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc 48 89 df 4c 89 e6 44 89 fa e8 68 00 00 00 31 db eb cc 90 0f 0b 90 e9 3e ff ff ff 90 <0f> 0b 90 eb 80 48 c7 c7 e0 c6 64 8e 4c 89 f6 e8 66 3c d3 02 e9 28
RSP: 0000:ffffc900000773d0 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000000
RDX: 0000000000000001 RSI: 000000000000003d RDI: ffff88815fffb380
RBP: dffffc0000000000 R08: ffffffff8fef2977 R09: 1ffffffff1fde52e
R10: dffffc0000000000 R11: fffffbfff1fde52f R12: ffff88815fffb380
R13: ffffffff92f50f00 R14: 000000000000003d R15: 000000000000003d
FS:  0000000000000000(0000) GS:ffff88818e0f0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e346000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x407/0x740
 alloc_pages_noprof+0xa8/0x190
 get_free_pages_noprof+0xf/0x80
 __kasan_populate_vmalloc+0x38/0x1d0
 alloc_vmap_area+0xd21/0x1460
 __get_vm_area_node+0x1f8/0x300
 __vmalloc_node_range_noprof+0x372/0x1730
 __vmalloc_node_noprof+0xc2/0x100
 dup_task_struct+0x228/0x9a0
 copy_process+0x508/0x3980
 kernel_clone+0x248/0x870
 kernel_thread+0x13f/0x1b0
 kthreadd+0x4f9/0x6f0
 ret_from_fork+0x51b/0xa40
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

