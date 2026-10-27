Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85ECD606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:10:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88C606B0915; Tue, 27 Oct 2026 19:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D016B0916; Tue, 27 Oct 2026 19:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7081A6B0917; Tue, 27 Oct 2026 19:10:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 353A76B0915
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:10:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1E1CC0B69
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:10:24 +0000 (UTC)
X-FDA: 85369951968.12.40A8E85
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf01.hostedemail.com (Postfix) with ESMTP id 075C940005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:10:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3Xi_hagkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3Xi_hagkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793142623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=odh1FEY3gfv9Oaa4XSlvByT1MReTjq4xb466aItSTqw=;
	b=Xuaiqu+6vXvKzXeFf6bU2xwPJEtOcugFa8jiS+C0iHn3XWKOTlAXAf1gzn1+jc2bgnuyyD
	h5tCwkkmfGwK3E5mC+u0gVs23aOQdNinKdYfDGeYpTMh5Uudv//xF1K+ls7Jx7iQzYKHsA
	3hFbuFrYd6Vzy4oEAMzne4XygCVgzKw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf01.hostedemail.com: domain of 3Xi_hagkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3Xi_hagkbAJ8RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793142623;
	b=T8w+OPq2rErHFIDyUH2H1RH3Ha2HKqy6c2hJLo/87aLLGg52yyHoCVCoHn3y36T3JGI0tO
	GQtlst/43mtH8C3Niu4FAd0CiG11/N+9V54t95DsRi8BVbo8CnGIJHTt+/+pW0JP2yzxin
	Kw2XdY4sP82J6nXnKo5Xu+08p82qAWA=
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4f2040e10d8so406298b6e.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793142622; x=1793747422;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=odh1FEY3gfv9Oaa4XSlvByT1MReTjq4xb466aItSTqw=;
        b=yyj0MRIucP9/GsTuQl6DbUEaR/mPM3mugrU/sE5pKYrxGfUZk++5IjCNXo5dxsYYVo
         OQyixL9C2+cAgyYV0QwAibtjde02en75D4UGsgnZsSAddEB7CtHzHntqGrjYrt2A4zja
         BJvlQj8tpPhl8tpqzFrTgjclHMcnlhT95gq7fBjKHzgcBVcfpF/sdk0klWp2zFz7GoRW
         gc29HVYszcONb599jYv//jk1Rm1kA1lOFVrX9uVwTEo9VM9ztWUXiQrw/oQf+6PB/6Wh
         9TUVZJTMM24uE1bCBpSRetkxBtR8qZu/6L4FAcWCvOzH+erHRkYXdYbQtYmRClZQb0ft
         XUiA==
X-Forwarded-Encrypted: i=1; AKwUvBxv2n+6V35p/E9gGfppllDKrHGcNOWHhHdg84O1PRVneyITjC/8aCEkK2TdupQtwVoYJ3icv+n8Kw==@kvack.org
X-Gm-Message-State: AFq9FYKFYBe4roi2A3oHFThSqBiQhcn2aa4YKz95hfaCbSoJmsgmXsef
	qUrCzoBUNS3QrUEJhzPn6ckcuExoPO57AUphl3GUuRQCw9HsJG1kfumj4VDJDPl1a3cy4b9F8GL
	0dRU+wWSAh26USMb0YbiNXuTQlB72czeiXm6pbsqGNn0H/DdJECrn2I/IKKQ=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f12:b0:4b3:7b31:8df0 with SMTP id
 5614622812f47-56382c83592mr462249b6e.10.1793142622081; Tue, 27 Oct 2026
 16:10:22 -0700 (PDT)
Date: Tue, 27 Oct 2026 16:10:22 -0700
In-Reply-To: <20261027113813.1332096-1-trintaeoitogc@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae12f5e.985912ea.1e5798.00c8.GAE@google.com>
Subject: [syzbot ci] Re: mm: clear pmd in pmdp_invalidate()
From: syzbot ci <syzbot+ci4a2df3f964e29c5c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@suse.com, rppt@kernel.org, surenb@google.com, trintaeoitogc@gmail.com, 
	vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 075C940005
X-Stat-Signature: b56xwf853w7xu7q97ow7zcxwj8fg7nxq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793142622-456154
X-HE-Meta: U2FsdGVkX180ouL3G9qxXLvyfFbWyXknQI+dLuY3ga3Qv0w73awlpwJTSPiDl3TcXr+J+/b9kOrI4egMarpsZttW9QAChwqjcrL+vR4+OXHSelIqcjNQeztbgMOmOdYKelqWs2D0x5DIAKUrcdEz1nWQROsC7aRNJoSs7eWZyKJPYeK1T/VR/LqQOPOgydz0kLjNFLI10WrWNzkFkaoMzFeoshVSyrpDZNlCtfnSOui+5JAbNFB+LY903KsDvQ6vnHDWJOyX7DKo0pdn2br+cBCWqXKVx/h4trGCrdjvamfh73sGl6kYWtLSv+WmlajmvKXhEJfWaLI934kR5PrbkhP+3TZR0kNO2c+ueR+1JeEMkd4SSXfRARvg857s3eKBdzZPOKe944eP6xEsW0yrEKxBSByZlNA9jVElMd4AsGQx3ZkD88Y8JbE/PTpxpQW0rvftq+lZoSQaw4TtkHdRu4ZD7BG77dtBpQTsQQdBESTHx0DTZYxwYP7ossTYNKLjcFnTWoDfHinTRxt5Uf7rW/samILzbCXBv5cXAgtTAj/qdi0ApUDwg8ydv3nQWohx6cVIgX30+8zM47LY0FnULeTcXJRvWcSo+++qC984TEI/jQZrF153nZ7l3xyAKNLY1LOvDtWkv2GdNt3vRmNz94ForqNjjEt8G2/M3AksycHmBUOtCSNWobCYTYcaTnvSa5nlWAfbDLqYLQe57JWnHYzcQgec/ulal64n+kfO8Q3Oe3wLhx1aQRsM6rJIL84w2QiBl47jQOvH03VY2NE3F84wxkQAIaTOd68oSVbyi6/vhw7Gx0j0cWtxwVnesYKjeC6heCh5vozq6oko6gKJmyyCn+GkyaLz38krbZwnemvVJ7tLHk17YFkaNEAtR6JPObWIUKak9jATVqmD7OQwDkIVW7F8Pucyvw/G8jxEDkdwirx3zV5OfxmHo7Riscatuh5DoowNcI/b7np/XXQ
 JxPTL7x2
 tl2X4tKp2+I3On2Kefy8XknA/oeqMmc+a2rak9llKTB8SJyHuapogDQ/DWc58qdtO+fNgQhyF9uakrccc2T/ZCIYH8LLZfvKd4pI3DGBE+9zgkOy7+9vYyr7D4nbXEdiPBE94nZ1i9cKpF+CssLuk2tZJ62vzNyz1qRJ9GqGy5tjzQInBZVL9Qdn7xEscSqe80BafPFBppT++TjqWblKFttONZR9Rj7LfopUCNc/XBOGx5lxlD2mptrImmIYxz1WcdKwm1qQ5dYnaFI8S9eMOApXbn3PK/tjsDNfgPs2Jg6uYO/I0RSuCes3o/bONrz6kgHYsJemHjJVN0MVH0rDvMM+cm9wG84VHG/GksGFJABkacuNdj3OgbsG+JeR71VQjqaFw/R1oS0LSDIq7CvLZES3LBI2kucJtft/rgoxlzDP4qqDUwS8F+OR5RPSodIP39E6pq3twzS2IANLSo64oQRWCJu3IZWM5VqimgO3zs6ysaqVHJuUO5C5FTqXYsa6Z3KKQYawz0UlCojP3B02W+kuZC2cxa9Pt2eQPpChUhwaZq8TPwqsz8BgL8QayUcwr5w/T0pVXt1EosjTa1morLN8xpw6lL9rzj3KIVKKBlvYN0T3OO78eON3ojwy8R4XlK8xyw9shnoKC7VnP6ASfe7lAGO3phr+JpfkSnkak/8oLW5BCtd/z6OCrP4E9qeb50pmCfs0xYNvtti/TW253oYFT6dpiTyJV6tQmDbm4FUrxLb3u86o9oeDr+mio3eXNob0Z1BX9ulrXs5PSJHDvdaFqsz5WZJssz/3vP7Gvnmyjxp+t80lBKquLvmzRmzCPQh7oyQK6pQlDI/zqM4efPwSOpgLSrHVdFULtqFfICO1yVi5vyvlYdd0p+6EbP567hEVjf38B3FeeZzcpn7wmsPPY+HE/d6bBVpMGseGsaHyzhvCy/CuDei6h5OxVUYOZC3uFIL3TQWNrmucNsZn4uHRKNjUZ
 61x2BK9x
 UxSIgMVCPdo5CuqcdQcoUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot ci has tested the following series

[v1] mm: clear pmd in pmdp_invalidate()
https://lore.kernel.org/all/20261027113813.1332096-1-trintaeoitogc@gmail.com
* [PATCH] mm: clear pmd in pmdp_invalidate()

and found the following issue:
kernel BUG in page_table_check_clear

Full report is available here:
https://ci.syzbot.org/series/ea6c690b-0dbf-4e3e-8367-2b5092d2878d

***

kernel BUG in page_table_check_clear

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      01146870c415f6ff70a469fb7ceb962a3f2c8c52
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/b4be77d2-e026-48a2-b906-ba8967ba2d37/config
syz repro: https://ci.syzbot.org/findings/8fa94c36-acda-4fe5-a760-1dea60977f77/syz_repro

------------[ cut here ]------------
kernel BUG at mm/page_table_check.c:83!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5817 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 37 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_table_check_pmd_clear include/linux/page_table_check.h:64 [inline]
 pmdp_invalidate+0x2fc/0x310 mm/pgtable-generic.c:206
 __split_huge_pmd_locked mm/huge_memory.c:3323 [inline]
 split_huge_pmd_locked+0x100a/0x2e50 mm/huge_memory.c:3476
 __split_huge_pmd+0x202/0x2e0 mm/huge_memory.c:3490
 zap_pmd_range mm/memory.c:2136 [inline]
 zap_pud_range mm/memory.c:2179 [inline]
 zap_p4d_range mm/memory.c:2200 [inline]
 __zap_vma_range+0xb85/0x4f80 mm/memory.c:2240
 zap_vma_range_batched+0x3e0/0x5b0 mm/memory.c:2351
 madvise_dontneed_single_vma mm/madvise.c:868 [inline]
 madvise_dontneed_free mm/madvise.c:959 [inline]
 madvise_vma_behavior+0x252b/0x41d0 mm/madvise.c:1370
 madvise_walk_vmas+0x924/0xb00 mm/madvise.c:1687
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1916
 do_madvise+0x327/0x3a0 mm/madvise.c:2014
 __do_sys_madvise mm/madvise.c:2023 [inline]
 __se_sys_madvise mm/madvise.c:2021 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2021
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b10f9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8b11ee3028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f8b11225fa0 RCX: 00007f8b10f9f559
RDX: 0000000000000004 RSI: 0000000000003000 RDI: 000020000015e000
RBP: 00007f8b11036b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8b11226038 R14: 00007f8b11225fa0 R15: 00007fff02a6aba8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 37 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

