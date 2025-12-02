Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92780CFD2F6
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 13:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE326B000D; Tue,  2 Dec 2025 08:47:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE166B0010; Tue,  2 Dec 2025 08:47:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB706B0012; Tue,  2 Dec 2025 08:47:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD0AB6B000D
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 08:47:06 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04B6C140173
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:47:05 +0000 (UTC)
X-FDA: 84174657252.30.6BD1677
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6C4DD40003
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 13:47:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 31-0uaQkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=31-0uaQkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764683224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=GFFITXgcbn3BF5XGL3IGOv0vn/QQzSLXJ0ctS9VxMf4=;
	b=rhGWlP/ycCBdA4QIjBzionM8T954U0t7LI1eo3fwyRZfElG7UGvugq85IC01Hv2CjCYK8j
	nQKxYGdR+l619iVMTkb/pmkMfrqq86X687xemSUcyf3MRBMJXNBE+mJ6ZbJvILWIb7adC1
	8S2+soaJipavzqoYYM1YYwqd8We4AKA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 31-0uaQkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=31-0uaQkbAL4w23oeppivettmh.ksskpiywivgsrxirx.gsq@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764683224; a=rsa-sha256;
	cv=none;
	b=bsItRHHySKQ9DBbKOuVOntKpOjI6tEhAXyQuT9TddFNt5SXn9URV3+zqwwKjn72fasVFZt
	9788Qak7l4RlKye9wGIoeic7nkrQurFcgUl+lxtxhsWVpPv5rU0dGYnjuPtCgO6R2jGnDI
	Z2Rq56bnVTVgjtd+MyvSERQQpkVPen0=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-45033344baeso8264468b6e.1
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 05:47:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764683223; x=1765288023;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFFITXgcbn3BF5XGL3IGOv0vn/QQzSLXJ0ctS9VxMf4=;
        b=letcqx58iyqOi/oWEsb+vB078enT8c//h2iUuQYkP2JaOhzPr9wvO5p8gl9i4D4XxI
         UFh3e1UMvs9M1pyInmAKEgaPRBDAXDAoTBwqbzmwZGdxBAH3/Sg/1WhzJLgJvwbnyG7N
         lJPA5SXDXi0V2gAtttHYdN1S57JjAKNSb7u6WL8NgWtn+yvjdvaEhco3t1HVyuE/tr+o
         JVboqHJh66F9hjxSbMOMGafCz3QsPTFjOP8n8wKrwJNUOdObglTpjnQB//5QH3JtZSG/
         Xaa8aHnF8kYgPC/4FYvdELGtFFJXp8zURIHNgfaq6Mk/Z73FMmY71pL4D9afOIBkrHwr
         Ezhg==
X-Forwarded-Encrypted: i=1; AJvYcCVLI0XnoKwQPrG5MQevNzqYId5RBgcylwe+sXnXgHuMj3JE1AZ7R6XtJcbM77fJYwP2ZEoTOGmHIw==@kvack.org
X-Gm-Message-State: AOJu0YwBXJmeoCHx+tvMPUsam65s6VFgU+ZfopTrf7o6yIxH0lZmlj69
	4DpFO0kZFk+rNhPQL8mQGH1KImUbmq3aJUbaz/h22jmIxhKGIBhZHKnL3ra7bEvuu9xJ8TKoo+6
	SEf8x+k3RjAJ9wNt8b4p1/pO4HjIYdp6Dk/Wxln41kBVvgrgncpSuiCEAhj8=
X-Google-Smtp-Source: AGHT+IH7K/LOkJUjlG3rKR7P/dRxolDR4iQGe2TKbFAebnEenAr/rpGcGAnpJoEc4BiGxFc8dUSs0azB+1dptAF2mz5PbyKwGhNN
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6787:b0:450:d558:76f5 with SMTP id
 5614622812f47-4511290cecemr19418847b6e.13.1764683223510; Tue, 02 Dec 2025
 05:47:03 -0800 (PST)
Date: Tue, 02 Dec 2025 05:47:03 -0800
In-Reply-To: <20251202132545.GA86223@macsyma.lan>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692eedd7.a70a0220.2ea503.00c5.GAE@google.com>
Subject: Re: [syzbot] [ext4?] WARNING in __folio_mark_dirty (3)
From: syzbot <syzbot+b0a0670332b6b3230a0a@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com, tytso@mit.edu, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C4DD40003
X-Rspamd-Server: rspam11
X-Stat-Signature: mhx93d8sg493d1w4dxgygei4afg8s58r
X-HE-Tag: 1764683224-788671
X-HE-Meta: U2FsdGVkX18nh3SoPknhq//Trg13av/hgGvfnyi0yWrP9QdIvzFoV0uBEDNom6UXSf7ryPorHQ55U/0fSs456f1/cr5RuQdZbvaXcOtYXor3HDjUSl8CLVa4jCydsXaF8gPf0N0fYhH8QAXhWVootHEFdQJy56EeMmqMhZsQ0D95kKXEzGcprKYzRkVJhpdIWUpqTBmlkbv4Y9qQbzsYQBng0WEVISQSRFieoyRt5tPpj/zN3QWq9PDUdkxdtK6qtAtImMtsEV7Q4OH8vtFxTijmsNzUxCxh9oJjHAQTauuc7VhQs7GPmQx33DLcYv7S0Vkr/9v/SHYaHVzEgitDcNndk1f/JB0P1gPywdNyLAzFEjiNtr5HPgvhm4zwVxdqy3m8pasRWvZ6p5VnkYnQB/rIaXj6xJhp/4boX+ECKAhYTZHMlhCwMs1V2uywN0E+tqgwnTrTcyukunOsbM28QDDanK/T390wXpAkqgO043wOkVRlX40GCOxAThKZDCNIXo4Hf5bsYWQAs8qj+d5Q0TAAPPggrQ7Dey/Oq86FhDveLyMdKI6P26mc9a+xJTWXcOvaVTqMfYIV0PXhgNsDkmDVdLsIwwfvZFnNJFeWuvCn6xmafN9txOXJKHwy+2Bc6VwcSITq4Y7ThdG20p5ac6asqfs9fw5eqL1zGPR6ZlZYdvQx6vb3NMFXREmpSqH1r4UzPtfc3vnTjMrVTKURfT4uV09ZlowVHoEheLMe51In8iuwoeDopCnEocDwfTGeaYECbiOQPkE6OVcWbK7xfoDjbbROo/L4+ADnl/1ljYhsFbHKBRixzhHqxB5m5DpTAjxY5qa4kj2wKE93eN06M7ns5MQzCbOunexlq20QTg9A6Aj3JTohPO3Ltww+g92lTsxJVDFUjIQ0+EsKY1oee34xTzPEpLcGC9Fwx0TbrcuXW0mnkeCFgSYFStBCQ+9wNBuBkGXbn4Z9dE3lO0o
 H2avMZ7g
 GtDk6czY2sO0fZN7DKszbDPxo+clQW8Q1vfZbf5lSe/ho5zdITgdTUl3bRn/Bq7svHTImrfkA62rDV6Vgg2pBTpQf0JBT92eSRY94bcrezm5hQZOe/4JwyHRXFNviZNpf5Fj+IWMtOoy0VdN28rcKegRLUocUVDMB28hMyGbmKaqrnKKycMrjSSRJy+8jlEv1r9hUf3Td47Sppxn3dDia67aL+Na1Bhqwm2gpm6rOAbNd/Ld+IKxCJBkOPEXkxigsf220UusDRDMnQWLT9NJOR91r1cbJiF/B+lN40rBdH6zDAYawSpUeFSlUR67upYmnEn+ECu0nmvSIEDzIdZf+KvQ51uDoWVzjFDosTqUdTH4yGzWl8uOlFqhkzg0XGgxY2FW2U/EVjnXowJNsTNOL0wUATqrTuKRW9BfzXr/OVyS1G5nyPS1tbMitCdQZ3Zoxvex2Ig4LGL7Kg7FNNU4eUOHyHYszjtujkGa1PXXXau5dmy06o8SVK4DOpsj1ZPEyFb98BAWJW3zJLNKkr7sv6MZykStjJkXW2TF8eYI9aLL+pGc2IrWRJy8AwvLLcG1VumTvqaLyoO1zlYWEPLPUL64YTafYXzDtFqC0aGZCShp88wZ4QEpa0pH6XLnh3A055B0VqvzyeWqTQbAH65Fs1x7hg3zZwkGRAKNrlh/QQTQJmllgjeOuAOkYS4iydH5J7gB5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
WARNING in __folio_mark_dirty

------------[ cut here ]------------
WARNING: CPU: 1 PID: 6740 at mm/page-writeback.c:2716 __folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
Modules linked in:
CPU: 1 UID: 0 PID: 6740 Comm: syz.0.31 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
RIP: 0010:__folio_mark_dirty+0x1fb/0xe20 mm/page-writeback.c:2716
Code: 3c 38 00 74 08 48 89 df e8 d2 a1 26 00 4c 8b 33 4c 89 f6 48 83 e6 08 31 ff e8 71 ef c4 ff 49 83 e6 08 75 1c e8 06 ea c4 ff 90 <0f> 0b 90 eb 16 e8 fb e9 c4 ff e9 7e 07 00 00 e8 f1 e9 c4 ff eb 05
RSP: 0018:ffffc90003a979d0 EFLAGS: 00010293
RAX: ffffffff81f9d61a RBX: ffffea0001056b40 RCX: ffff888020775a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: fffff9400020ad69 R12: ffff88805b014d00
R13: ffff88805b014cf8 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000555575052500(0000) GS:ffff888126ef6000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000440 CR3: 0000000036d66000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 block_dirty_folio+0x17a/0x1d0 fs/buffer.c:754
 fault_dirty_shared_page+0x103/0x570 mm/memory.c:3518
 wp_page_shared mm/memory.c:3905 [inline]
 do_wp_page+0x263e/0x4930 mm/memory.c:4108
 handle_pte_fault mm/memory.c:6193 [inline]
 __handle_mm_fault mm/memory.c:6318 [inline]
 handle_mm_fault+0x97c/0x3400 mm/memory.c:6487
 do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7f1eba837398
Code: fc 89 37 c3 c5 fa 6f 06 c5 fa 6f 4c 16 f0 c5 fa 7f 07 c5 fa 7f 4c 17 f0 c3 66 0f 1f 84 00 00 00 00 00 48 8b 4c 16 f8 48 8b 36 <48> 89 37 48 89 4c 17 f8 c3 c5 fe 6f 54 16 e0 c5 fe 6f 5c 16 c0 c5
RSP: 002b:00007ffd39d5fc68 EFLAGS: 00010246
RAX: 0000200000000440 RBX: 0000000000000004 RCX: 0030656c69662f2e
RDX: 0000000000000008 RSI: 0030656c69662f2e RDI: 0000200000000440
RBP: 00007f1ebaac7da0 R08: 0000001b2cc20000 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000009 R12: 00007f1ebaac5fac
R13: 00007f1ebaac5fa0 R14: fffffffffffffffe R15: 00007ffd39d5fd80
 </TASK>


Tested on:

commit:         6fb67ac8 ext4: drop the TODO comment in ext4_es_insert..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git dev
console output: https://syzkaller.appspot.com/x/log.txt?x=16156192580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41ad820f608cb833
dashboard link: https://syzkaller.appspot.com/bug?extid=b0a0670332b6b3230a0a
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8

Note: no patches were applied.

