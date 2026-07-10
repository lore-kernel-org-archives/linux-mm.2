Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251B9C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 23:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4B486B00AC; Fri, 10 Jul 2026 19:04:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21F56B00AD; Fri, 10 Jul 2026 19:04:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61EA6B00B1; Fri, 10 Jul 2026 19:04:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84E7F6B00AC
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 19:04:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A9E01405D1
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:04:22 +0000 (UTC)
X-FDA: 84974397564.01.92B184F
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf28.hostedemail.com (Postfix) with ESMTP id 585A3C000C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 23:04:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3c3pRagkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3c3pRagkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783724660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=PILKuP1baRMrI40srAIIZX6vgxgjZMMRu2N2qYBgI64=;
	b=zqZxLePES0Ym4OmoAMVURDi+3rHfB+EJi4DoMammdM4xjzVPHdgmAtoUBzrfAQophFXdaR
	OGSGDG08JRXKtIgHwz+G4YSvC9a7/tR6lLaXNkPCysPifZO7YV4WcWwOzF4GYGAK0Yi0do
	j6QXeueHAU7nvzVm4+AYqAC5Rnxjdpc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3c3pRagkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3c3pRagkbAAg067sittmzixxql.owwotm20mzkwv1mv1.kwu@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783724660;
	b=S9Q60psgYMWTB7WLk4SwAziWHUHhMsB6QvCiqD9fsS/MVWkghAxsDnaCiWM4eMUunK63S7
	rFpYtB42Sd3obLdbZ1hW+TfAvXWWTgRhGRM1EZNoMK1xZjuaRT14rW1mYisVoutJOaS64G
	FhOd76zbkH8OEzwFvszX2krhSHV4F/8=
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7eb64224fd2so2134662a34.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 16:04:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783724659; x=1784329459;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=PILKuP1baRMrI40srAIIZX6vgxgjZMMRu2N2qYBgI64=;
        b=sYmLAoWJiqfETGOfaimcaH0V5/CZIj9JQrxgaF1o4yNVjh582zaQIV/42HdrkCcsOE
         pZqgrXd+cLW7HQpKU7VoGYuuFkP9bvFGagZ+LU+jQxmkAoXijynk8JV71dHZliVf+6DB
         9vlHorkQrG1/F8w5xRZ9Q+aqA59uVa4Wy4GMMMFmeJzNIzetEj44VP8Ptt4F3KAL/U0M
         bXLMsfpLlNZvUh950WFS8G8kuDAoOgOsDvxeY038RGDE49FOvplnlXxxXAr+yRCGXyi9
         MWBm1zcIHkntKcivYMx5rT2RBqLIOrvcjrWuW/Gli2T2yHkklQlrYor96pPwEAz6tzsM
         DdgQ==
X-Forwarded-Encrypted: i=1; AFNElJ+QB1c4p22T5vcScGN16i96ncxzk/RACQ4URJyDKyU7gzjKmtZsRegoxFQF4PKsNsJO9gwtlyJI0Q==@kvack.org
X-Gm-Message-State: AOJu0YzK4Qr5rPN9S8QDDd9mKnDuMr9o2uqTszx0/HSrqVxoNhh5r3mr
	OiEYW2RWptp1QOD3g+BHXKWcY9scRPHvaTK7EuIb029dEVdF7z4ejqWUFDSp9/pvZw/z7Asqq1u
	SjFvCNFzn9CMxRl2CeQMgvn4TnYc8jNFJeEXA1sgk4rykoxOSderM/11mxkI=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c3f2:b0:4a3:58a6:8a2f with SMTP id
 5614622812f47-4a42af2782cmr764717b6e.33.1783724659442; Fri, 10 Jul 2026
 16:04:19 -0700 (PDT)
Date: Fri, 10 Jul 2026 16:04:19 -0700
In-Reply-To: <20260709184740.1286561-1-willy@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a517a73.278cdcd2.e885.0009.GAE@google.com>
Subject: [syzbot ci] Re: Use generic_file_read_iter() in hugetlbfs
From: syzbot ci <syzbot+ci26aa0fb7896cb4c6@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, christian@brauner.io, david@kernel.org, 
	jack@suse.cz, jane.chu@oracle.com, linmiaohe@huawei.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	nao.horiguchi@gmail.com, osalvador@suse.de, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: pfnyc7xkmgiuuhxuhxcgw115a4psgymt
X-Rspamd-Queue-Id: 585A3C000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783724660-267666
X-HE-Meta: U2FsdGVkX1+yNScHkTl8KSzzFSuSu4DPLcMii4IVa90/w+zXxwueAyepj5EOgjliORqSKfcTtfBURPYfaFZ3oNQG4gRU3yF2FtL9cIyYkr36kjNlT20CJ+NkWGPq3G5ikLCCybzwHHsr+U3Iv8eJg6Au8bi7pFb05Ub/eHyuFXsGhql93MW4e2kKugVRb9qVyecKijSGwocjGEC+BSVk9MJtxNPGh6OddwSgphkKhozl9NWyD9pAeLVW/cGzl/1NnfEFXATUAXDk8yaeFTRXXeK8XpkpCeT1MQAsEszMfRLN4axFAhy/OW5t1eICL7scOxvY8VjP4FBxcmLZydvE64dbzlAyhZFLTfJTaDB4xxwH8zFKvkJfd4u4KVNjqaMxFF2/z2JpiTmnyJt+LlSDVb25Ag0QfqMwZnTkKSkXacYN/4rX+YGVoQJL13Gh76LN5yjio868JsVYHttWbDyyDLdCpC9L2BMZ4UmFPtxedD0rdnIbdh5UtQM2pb1L+Oj3oqNX9Aw8gVS2OW6JuiUnmd30ZtS3ideIjiqaBcdGuILGYi1p2mZ68lyA/QxcN1nSXlfsHD8KpBCb9/sfTbGcpqhzl5YLI3hfZvqG7qaF0DMkZtAYfWdHCCT2lfPY0MeDaZmcApd9CuQoTJ+j1QYHrsZVHxrRwk1G6Z94MEY5jllWeeH5ADABFf8XAr4mKwTfT0M+SIM6M9mA2QOLFJX57XeUdcgDqlTinZz6c1u6bU4k4yASVtLNgblJYYWEkbqKdluVWdUWZje+EvBl7dw7yKWSTU89RSzca7tOvz8WBZQdA5yFUkGXcf+xjAwUGF0G0iN+001nBdrngZ7rmgg+zTlO7QFmM2ThxwcpTGK3J3QEW28M3+drjEbFku8eWMy6hVGV6Vf7Y4oMHmoQAtCLMTyknWpuvYqUGGj+akfbqFGdRj70jCxgtCoYmRxc8nPKVBw2UnxpFsBGKakSkQI
 0r2x3MFc
 VUTI29TzSxhnx7SwH1ta8FLqORmwCc1mxm9iVvXuUYFTiNTNuRBmgPLpskqUFq7WB42hDzs/mLTA3xqaoxVuOs65bV4UI+xn/ycLSLo8+21YltkAAd1oDiHFgtuM5Cs0ONIz2N7UVdMfL0wx2kkwNUk3UPJQd5wTb4PecHJMTrOY2KKFhdiXjwTlERvXp5SzCL6WNhGFmlzX//2796x2+9swZEUx3vyor6ZWzmTgQ1ZylBN4Njs09W/xYEkY1F7MXwpQaD5BONnzbrIByEYkWpDeeyABRI2HFyRwCBjqr6unqo/B93TwzJwuJsVJ8fFwSmCs9O3Om9yaTG6vNvDVcMAT9r9UJBrJ8cvlPKsO2tnTMWpSOcCLu6Wt4yvzq1vjz4ja3FbNwLqNpaz032ZusSP+r38KpT811h7APSPhPeYrFjgK48cBNauHsY7pioeQf/YLHhrWehHroFjPOBnRnEoGdwMxQvKo+9Gek3yKab/G765dBK7V3Jc1W0b3HsjpfHZgG5OZkqmXv9fWEQjIAM91ZL1QFJRLhlCwE2h0SWSNXwDA3Ro3BONAj99c5xW3mZmiiQTVur+fgQkCnUx6lcHKjp4WEawBTdAEQ06kiwk+TyZ46YWG7aqujSyPPClXNmk/lOZdOEUsfwmcbYlgHrisHEMPUa5tGyGExUs4ZgdUnOk2QTG7H2bLQCJQikOXtGqQ/fDQ3yRjmBBEgabLLAvlzPuPwTVqNXFBhjZjRDjLdmoGjCEFhnqa6MqlBo/EHXvPmqXkh7Az/03NaiKt8RuG38buTybPEKfskKpvz4wlMSVzttzB+eSiEUEWXWAckec3r1xrWU71/Y/B5BJwZsEBwENclr5Pwz0JIMLG1vzkUsK8q4um0+aGRHwMEyZPCscAhxAxk7DwDs0G9M7syIOf6FZQpH5/8k70+ZaIh+gHues0Ffb8TtsXYzqqFXyljejtmZ6BNbxGgsWXFX7cFQP3cP1/X
 RWZ9Mgny
 7x3ogL0SrhbMqBGie+OFnQX0z1J3Woj+LJzS3Tjn+xT7iINUsYZcQMMx4RpY8SxuKN/3BWdiO1FHZ/EvhdDdSK8Nbe+/4hTJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] Use generic_file_read_iter() in hugetlbfs
https://lore.kernel.org/all/20260709184740.1286561-1-willy@infradead.org
* [PATCH v2 01/10] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
* [PATCH v2 02/10] hugetlb: Mark some function arguments as const
* [PATCH v2 03/10] filemap: Remove checks in mapping_set_folio_order_range()
* [PATCH v2 04/10] hugetlb: Set mapping folio order
* [PATCH v2 05/10] memory-failure: Remove raw_hwp_list_head()
* [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
* [PATCH v2 07/10] mm: Handle hugetlb correctly in is_page_hwpoison()
* [PATCH v2 08/10] filemap: Add hwpoison handling to filemap_read()
* [PATCH v2 09/10] filemap: Add support for authoritative mappings
* [PATCH v2 10/10] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

and found the following issue:
BUG: unable to handle kernel NULL pointer dereference in filemap_read_folio

Full report is available here:
https://ci.syzbot.org/series/35ead019-1e81-4d15-8801-8ff11d9c959b

***

BUG: unable to handle kernel NULL pointer dereference in filemap_read_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/fedb89e4-11ba-4995-927f-a51101829a59/config
syz repro: https://ci.syzbot.org/findings/7a0cb565-4340-4daf-8de2-06f5b1d2af93/syz_repro

BUG: kernel NULL pointer dereference, address: 0000000000000000
#PF: supervisor instruction fetch in kernel mode
#PF: error_code(0x0010) - not-present page
PGD 8000000117bc9067 P4D 8000000117bc9067 PUD 0 
Oops: Oops: 0010 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5840 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
 filemap_create_folio mm/filemap.c:2650 [inline]
 filemap_get_pages+0xe9a/0x21e0 mm/filemap.c:2714
 filemap_read+0x428/0x1700 mm/filemap.c:2841
 __kernel_read+0x4ca/0x960 fs/read_write.c:532
 integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
 ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
 ima_calc_file_hash+0x451/0x890 security/integrity/ima/ima_crypto.c:280
 ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
 process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
 ima_file_mmap+0x1b0/0x200 security/integrity/ima/ima_main.c:523
 security_mmap_file+0x773/0xa20 security/security.c:2581
 vm_mmap_pgoff+0x134/0x4e0 mm/util.c:575
 ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:606
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2e38f9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2e39ef4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f2e39215fa0 RCX: 00007f2e38f9ce59
RDX: 0000000000000007 RSI: 0000000000003000 RDI: 0000200000000000
RBP: 00007f2e39032e6f R08: ffffffffffffffff R09: 0000000000000000
R10: 0000000000040033 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2e39216038 R14: 00007f2e39215fa0 R15: 00007ffe3450a298
 </TASK>
Modules linked in:
CR2: 0000000000000000
---[ end trace 0000000000000000 ]---
RIP: 0010:0x0
Code: Unable to access opcode bytes at 0xffffffffffffffd6.
RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

