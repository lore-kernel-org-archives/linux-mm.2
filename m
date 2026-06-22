Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDF35CD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 17:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35DCF6B008A; Mon, 22 Jun 2026 13:01:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F636B0092; Mon, 22 Jun 2026 13:01:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 225D36B0093; Mon, 22 Jun 2026 13:01:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D76726B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 13:01:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D696440229
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:01:17 +0000 (UTC)
X-FDA: 84908164194.11.D1A8B98
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	by imf12.hostedemail.com (Postfix) with ESMTP id 030C14000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 17:01:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3Wmo5agkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3Wmo5agkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782147676;
	b=VBeaO9LtEpoAwhEKM3BNq31Larhz2kiStDKSTxv95EIZmG0OWdgOicrtLUHIyKmtjZ/Hnw
	10enzG1Y+tXQlicKtxB31/pB/7xVEpBlJKBK4ocVlfdy78wtnONetygn42rDQInjj3efFM
	cZR/Hd1ccgZR3sd/qaFxRovlubT3ucQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of 3Wmo5agkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.69 as permitted sender) smtp.mailfrom=3Wmo5agkbAG0djkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782147676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=cH6/V58LvPbwIPyJoxFid5UDIq9SWXBxGFouXXPBLwE=;
	b=YzrhF8TVeAEgqNot6ivrxIRskIufUSpGlVIrrsvwKndTOi7RtKtDizQeVo9bA8UD5y/0xn
	vsrfhjKjQTSA/Smea98PjSFd3qT1bTBx3BK+ZQiDqJHIlXFo3AMfACOYKBYVrVYTFbWuFy
	JjlhQHk23XoGj8Dyr/MATvTcpXIJpu8=
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7e93ef70926so4079992a34.3
        for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:01:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782147675; x=1782752475;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cH6/V58LvPbwIPyJoxFid5UDIq9SWXBxGFouXXPBLwE=;
        b=TaoHCFZISMx0A2YamK9meDyKj7SFrxfLfZVawbe8rydMy4EkE9wBIlfPFx2QSvKbLP
         2wBYZDqaC+1c4GY8Lo97MSsJu5KePI6Y86Z0BY8KUi+hqUHzRe3/OlqUnMojKhgXTQCq
         gXTf6kgphhjU88fbyCiQ4rYgh98ezXhrbiSsiZuIHpG5EOUaXr0wIYPOICwo2MXn6Br5
         1CmlS/2u08rBCG1Pf/mh7j1wSVLWvDs2UPzKs+Ct8Zb5tM8gmmTMZ14TFKV11xgby+8y
         VhD6jSjSXDHfV4d3kEvKJ/Z/iuGeIavAd5GtoNuY2mpm5gtf72eBqmz1yegKawUQuxIe
         OQXQ==
X-Forwarded-Encrypted: i=1; AFNElJ9f9jkU1IZgwe+shPNRLgtdIo+BnMX6rwTuExaYEdTAuvUuafwOzu7UNTEm4+vq1fqlMiDLG9lBrA==@kvack.org
X-Gm-Message-State: AOJu0YyUtUHRpfvUWAYUBWgw89LOahKPTuczIKdXslllQ8wLKhtKnSAP
	dTN9Xi1r67+HipBsy4kARZjBT04WAIfPcZCQZxM1QLnfvCGN/NiV/1lPW0iTBSCpVRi7y1DAGIo
	YCmGDHThcFTQ8JTpvhmMhlac0oMdYUc+pcMPpucUUC1xu17zjCG1nf+HEwUQ=
MIME-Version: 1.0
X-Received: by 2002:a05:6830:718d:b0:7d7:ea9f:c0f9 with SMTP id
 46e09a7af769-7e92d37a1efmr12028083a34.0.1782147674625; Mon, 22 Jun 2026
 10:01:14 -0700 (PDT)
Date: Mon, 22 Jun 2026 10:01:14 -0700
In-Reply-To: <20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a396a5a.ac26f6c2.9a9c4.0000.GAE@google.com>
Subject: [syzbot ci] Re: mm: page_ext: add count limit to page_ext_iter_next
 to prevent invalid PFN access
From: syzbot ci <syzbot+ci8a7f89fd8f70a458@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, hannes@cmpxchg.org, 
	jackmanb@google.com, kernel@oss.qualcomm.com, ketan.kishore@oss.qualcomm.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	ljs@kernel.org, luizcap@redhat.com, mhocko@suse.com, rppt@kernel.org, 
	stable@vger.kernel.org, surenb@google.com, vbabka@kernel.org, 
	willy@infradead.org, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 030C14000A
X-Stat-Signature: cg11oop97f5mqgydkeeboidz3mkdr71n
X-Rspam-User: 
X-HE-Tag: 1782147675-133827
X-HE-Meta: U2FsdGVkX19lqFropKfCODVxWkU5aJ0/ngl1kkwjNqDKL1pusL0iYtIgeEvkft3gMwn5XtEfkA5pP7ziAP9hY01tfpVY2g/wxA05qhYr/3Amt9A3O48iNstKEgNOyVnbA96dAmGQGlQMeaHKuqOzsEe303cjoewblcsdKfZyfgMw50mngrBttyLLdmSlmTo0mbKYROl1D5Y//NV/WhM20Gme1fB4MfpiHQ8PO2x7LPImxGC60zLdLOBH0dqF20LofyMgwqeDRM/cp3Ms72nrqgk2SVrH5zYpD+hhah6ta+gSWvCXwrG4tZ6NqHDQLnOfrk/rj3a79bKiNFKlfhQpubLtaUZg0nH2EkI6Niy/D21Xab/jCCFMWl6agnzmEKIGrg9nassAZ9NRckDh0UrPNDx099e5Wy1ieok3GE8fHC+Bk5VDjG3o84UfT7Trr9mHbuO8yr+4l4N1dHPj/bq6/xcM5lc51OIQR1BL0Fzb7Wm4gWVdzqxNOLT1YNhml6y//hcdGCSaFfQgH5xGUyZbwJWaumpk1k0y8HHDPlA8wfDC1Qq3wi2LDFw7HAndQlGm0ePEH+mUyiqTVYenwmn5CvU7HMyIicd+BuOKZI0LhcCkWPGG35kkpJA58G5sljvEZY2rhtU59PYnHD53+DkGg8yImhowcXcQa8sZws6hlxI17ElRYHHzKUT26bRMNE1Q48U4pA1mKvpiFFisZ9VMnOExSrJbsO5/tVZOmZHfHFxFuGgi1kpObrhQJFRVtDD6QSJ58inP+h/sl9Su0KcerVWHCaFdrqnl35Yoj8Clw8SkScjjqGf6QVUdYlwF0QTg0s7XtG87PbL5n3GUt3pjbkWDDthjEkEesjgzYA+Wh/TQmU6mdQ1tCRZycuqJNRAxTGwubej3ouU83Vp6f42emIGMXcchZiXdOeF6eiPAMnJtNIPBXr2co56r+nDTegkwn6Z2Zk2YB16KpiErA96
 9jgA6dQ7
 aorMko0EpDBMbaJHK4TQC1dnhbM2IHyhYdpgNEFiamOD+NnegVueDmLOecQBmyeoFw01wxsGN2nql7kB1wwh+1v/T1NzosRVRoN6QafQoOqah2gCK6v+3tSFTGd+cE2wNGZzaNnrw/vKQPET397ss0/ZX6/Fktt47AKfroY6N9wEociVHslBSOIikDTFFzx5btu+RaiEex/lxsRcSTt30cWunkDklNmssP7lEopB5nrXbaSEwaOlcuTckc3BWhIB45LUTebPPBuRvJxzhXBmqh9kmU51uSrui2RuNvgzNnyid6xvR4Jt3JkZPxSMEKN4crdgauSiT+TbzQyNqDOC84+q0hfxhus72qgGCChy2OVdAitCVmRk4BdtXKK8KBDbXGFxsE7RG0LZ6uun3jxMw1M8vIhUsauBBZyVXExfFcVX3GDoeQibOMSAh028UvbESsOUjZtW7Hq5ix4WPNV642DUbikTlDgiRBTlgPkzlzLyLMjBWEr8C4VAIA5YfLepbjAPUz2zch6H0A1zyyXz00r9GggA7mDrSL2ERrRk2eo3Hc3dH/IzBh64wy1hj2yErjJIm9eE3enfaWuYITr6tW+/GQi76ezRY6vWBzhUCjwGKKWBRHIsJJlrCUd4RT13fG3CDefW2Ch2te94di7wcuIXGju75QDMg/meGV67SZ1FgGJ739olTmm87OmWjlEvpnULXCANadcaoLfuGlXPO1idFaTzXDj4Bqfco75Zt016cMCf9mo+M3f3W/Y0QA3TQhX6QHoa2Zx1Vwqt1D8HTOHwJgI6/Z9/tdekMUf2x2/qLoEjcPnBMQ5Ax3IPBBD07sbJS0SE5hAfi0MxOnXb9JZgHMQjEpa9Vb0eNKpbBVJNZc2NVVvF5VCkuBvLoAVUAILNgYbOQdtN1Mcoz9Gv57b+ZSgVpZXVFbhimiCTs/oGnCTzQw/ka2ROzrm0uQ9TO63TJnUQ4yLgsDeU61pyZyRRohXZ5
 FySpo4qW
 XHow/Z7EBqrfVd8q/G0f9rtyKLKRTVFDvMNHsoHe5YpPRt8aaytixaXrMAIBY7iNVOof4Obo1YTZcizLMW0aq0FgE+Mo4GHFBXHak1dTfKLkLJiIeNi9tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v2] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access
https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcomm.com
* [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid PFN access

and found the following issue:
WARNING in depot_fetch_stack

Full report is available here:
https://ci.syzbot.org/series/092dd7dc-cb78-46b6-8703-6044fff2631d

***

WARNING in depot_fetch_stack

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/18f461a2-7098-44bc-9d42-634b56ba48d9/config

------------[ cut here ]------------
!refcount_read(&stack->count)
WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x91/0xa0, CPU#0: kworker/u9:4/1114
Modules linked in:
CPU: 0 UID: 0 PID: 1114 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events_unbound call_usermodehelper_exec_work
RIP: 0010:depot_fetch_stack+0x91/0xa0
Code: 39 f5 72 d0 48 8d 3d 7e 1b 4d 0b 89 ee 44 89 f2 89 d9 67 48 0f b9 3a 31 c0 5b 41 5e 5d e9 87 67 b8 06 cc 90 0f 0b 90 eb ee 90 <0f> 0b 90 eb e8 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0000:ffffc900079a6ce0 EFLAGS: 00010246
RAX: ffff888168b94000 RBX: 0000000000000ce0 RCX: 0000000000000067
RDX: 0000000000000000 RSI: ffffffff8e215937 RDI: ffffffff8c28ab20
RBP: 0000000000000067 R08: ffff88810495a407 R09: 1ffff1102092b480
R10: dffffc0000000000 R11: ffffed102092b481 R12: 00000000019c0068
R13: 0000000000000001 R14: 000000000000010f R15: ffff88810afb1dc0
FS:  0000000000000000(0000) GS:ffff88818dcb5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __set_page_owner+0x140/0x4c0
 post_alloc_hook+0x1f9/0x250
 get_page_from_freelist+0x21fa/0x2270
 __alloc_frozen_pages_noprof+0x18d/0x380
 alloc_pages_mpol+0x212/0x380
 alloc_pages_noprof+0xac/0x2a0
 get_free_pages_noprof+0xf/0x80
 __kasan_populate_vmalloc+0x38/0x1c0
 alloc_vmap_area+0xd1a/0x1420
 __get_vm_area_node+0x1f2/0x300
 __vmalloc_node_range_noprof+0x358/0x1730
 __vmalloc_node_noprof+0xc2/0x100
 dup_task_struct+0x28e/0x830
 copy_process+0x79d/0x4380
 kernel_clone+0x2d7/0x940
 user_mode_thread+0x110/0x180
 call_usermodehelper_exec_work+0x5c/0x230
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0xa47/0xfb0
 kthread+0x389/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


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

