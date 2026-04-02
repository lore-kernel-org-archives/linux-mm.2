Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EA3D39436
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C49416B0092; Thu,  2 Apr 2026 10:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF9CA6B0093; Thu,  2 Apr 2026 10:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9346B0095; Thu,  2 Apr 2026 10:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93E136B0092
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:40:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5A5465A822
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:40:57 +0000 (UTC)
X-FDA: 84613877754.15.56F49E6
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id 789EF120010
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:40:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of yskelg@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=yskelg@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775140855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=ImV4Phho1CCTlk2/HembznT8Vxp6HlqSPKT0fvsRtIs=;
	b=0Rc9y3ws8P2cDFVJh9QzfNH21W4LCoN43nos8BASiCgDTZdOpG0qQWtt6Kd8JeXHie+ZKE
	kJS2jk0k6rHU4rJcK4rWbs1ucg7NU+bHOJZBRkph4TYSqslxuPlp5b+pZgnDF6X2bbnEC3
	+/PVDu/ho8PAbSnxfxm1Pwp67UnROew=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775140855; a=rsa-sha256;
	cv=none;
	b=ViYVVrbzLeRMT8Y3OdhtDYWCzlZ4QUAEbh3HxR5k27cXrFvYNafzLTKubl7qkbN/W4McNZ
	vbs7ulumplZTxRi6HvtUdlhlRJxLWfszcVV34E00l10lZBvhBEmdsOrcgg1fp/4p0qzuaD
	9GE3S5IR2nBbz9FvktvX+jV+NLksiZM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of yskelg@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=yskelg@gmail.com;
	dmarc=none
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2ab1c8fdc40so666905ad.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 07:40:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775140854; x=1775745654;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ImV4Phho1CCTlk2/HembznT8Vxp6HlqSPKT0fvsRtIs=;
        b=mp9maDkGTiLpPbY643NiAqpzSbHFtkF6bgM0umOB9EloTdGIKhQMAzBDFnHhuTm4sX
         pt4DPkN9vjshYV6+ApvAzGqILJjUodwNDWFfPkJkk4JoyX6XRZgF8kCBhrafzBOZbET9
         pq6lGk084/rKEMHpnHjoon9F5/3HURZrGEGG9c8iQgGOWOiSbVGNH+NfXbpecowIlZ4R
         oTmrKIdmDRW8K7bQ6yJslfEg5i/8BfhAhu2qRyFtd0d0F2D0fHkyu9z3gaBWqbX/T/rN
         8t297xBBnyoeRa6un32W6II2PY+hmE+I4g4AbpzJe+0qudl99+V8ZQ3cxqlDSw9l4ELa
         KnKw==
X-Forwarded-Encrypted: i=1; AJvYcCVLS3EFssfRGBAvbRDOiduiQtqibHyJnvxGOS4cD3mFRSCa6JGhxabn4KE51UIQx914DWpnhia8JA==@kvack.org
X-Gm-Message-State: AOJu0Yxr9kYL8KMfC7dw/9stD9jIoxsGul0tqESinp8YgnRU/LHHKPQK
	qi0BkvGdNJ3+NfSNTdDTBIB7gL4cJVk63ERm0+Vn34xYPpiI4JiMHY5f
X-Gm-Gg: AeBDietnl1rpQFRNTxYIpv7IsqKndDoKM5zKQeoauPpVEQMyCbn9zHj+WTULeyY6+fq
	wUhklx1nLLNsMo3sIpCWsks83SHhOD6+PIMJC3wFhRuNttDJyJq4EbDOqP47fzUbLzUUFpCpcIY
	7UWJ6NYNAq5hpE88OekvEiJ2sy44/57dZQ88q4nt5sLe6mdLgMZ7HvYy/Ggkdu3CYbhjeYK8N7s
	ZsOR3nJssWT5rTMElMHPCme/37sWb5MmKNOjQSPEGs2TKXTIzz+NP5TIGRiUgnrFdkbkDOXL1QP
	jzSh8oVnPrFWoW6XgglQp9MAaRNysQPnUOyc3W6oUqGWAJCKV9IlmIs0SUQN9A15vs2GyBbNPqs
	NxlxFxahH/6o0GmOJYuoNr9qmPDuGOqnaSfMFsDuIRmzcWQqCZt/ItLLFdpaDun5C/lBsY/ukTw
	NvghVjU3ckA5nDJXM5qHm6HIQRlEFZoZOEAILOa0Ej0nsq3cXMLzTS7Tg5CTpo1AzehBxmgYN9n
	A2HDRodEwO2FYiJ
X-Received: by 2002:a17:903:2f50:b0:2b2:42c0:de33 with SMTP id d9443c01a7336-2b269c6edb1mr52876245ad.4.1775140853987;
        Thu, 02 Apr 2026 07:40:53 -0700 (PDT)
Received: from localhost.localdomain ([119.206.52.3])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b27478d329sm31171055ad.34.2026.04.02.07.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 07:40:53 -0700 (PDT)
From: Yunseong Kim <ysk@kzalloc.com>
To: Kees Cook <kees@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Waiman Long <longman@redhat.com>,
	Shuah Khan <shuah@kernel.org>,
	"Tzung-Bi Shih" <tzungbi@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	max.byungchul.park@gmail.com,
	"kernel_team@skhynix.com" <kernel_team@skhynix.com>,
	kernel-team@lge.com,
	Yunseong Kim <ysk@kzalloc.com>,
	Byungchul Park <byungchul@sk.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH] lkdtm: Add folio_lock deadlock scenarios
Date: Thu,  2 Apr 2026 23:39:48 +0900
Message-Id: <20260402143947.162844-1-ysk@kzalloc.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 789EF120010
X-Stat-Signature: dm1si4hc8epu7pjixh7tsp3za33ckrif
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775140855-293162
X-HE-Meta: U2FsdGVkX19wafKB14LXzO6bIUmm07hswIdfbLOCyIOczOU04/b6Km+FDbC74jpO/S3XwiMK0A9BfwuRuGX+hVJQSBtJ8y4bHC3iidHMBKFKthivxNW8HiyTW8hADE2PiSyEQ5/CD4vahtvJvluRIhryi2P0/8LAQNPIz7QveFYmypsgC04cRLPmRPzxmKE4jW02HbwHgW5cDF9e60noWJR4En0DYxyyA+iIEyymiAWRhjUqU0mu2KGUWY6oRC7E3g77FRtrSZY8eBpGZDZq6RMlWqfJps3kDnMgujDMfjAPAx2RZ3AYGdxzSXqTBqqVoJuMFw9JkGuLR7eXR5va3loflKWKtb3WyIJVhny+sebyt58HdDiRNC4J5bv0t+hOM8dV7ASlc10lJ5HVsYteI1suRqbNR2yQUQ+SDC48VHf7esSNTzliH+H6u5HMvF5Mfabp4XGiAThsomKvEzIp2AtYoNBtNldjycoP87TOiRmjcy+t2jxWIrehuqDFvLBtFtAEwi0RShMF2yKEXQidgphZjllwKrc402QA528EjeuAkRFLxzKbjwNkikXQ0QTu5ndoan9B6maYaj1tusqUpJNy0h1dQzbQ6MCJXHhUdNIlEBexq0ST0mn3oCMVBnCJBG/hgfrMDLhPlkgC7XyyXygVU8BXXx/iKz8fHsgmTW7F8O93n5n4BYeLOdXHNjIemLfAHmbymmqDX4an9jFoRvXTLs6F2owEpzrLTyTeWZEEeju4O5/z8NAWY9un43wPy6ikMh3qIDGyELWCscV7hfgPuHpEGwkfl0dAMu187ftfjsBgvNp1Ekdea23nkrKaowJPRYmm43Ty3klcordfd+AQpFPlqR05CFd9N2YA9YKt+7Rd8Ac1sHIsFNEC4o4QXxjHf/Sffm9gtQ2e7HRj+E1uiECNpC7eg/ikAegQKTmB9h7RHCizt+NCBQCT+KeHsTKbf8bsvOrim3daKx0
 TsGNkXeU
 im8O6RN5gxl+TmVt23yk76BQftgziz3IFKlSZrhzgf1vVoWP7kWGSm/gvDMPcDfYp4v9k58FMhJaZZex56yN7n1y11TlXSGL84Pyev26GJqnUTJwRMurAcy+Q8aVVmxVIqAndDLfrHINqWH91EDvN4WOng+SiknUQBwDJIdJP7B1v7ZprqfHdYqOAYKCNDBD2iewno3kSOdiSOBfqFsJE8U6LRuhi/OJs6rmuD7sJ9p+EtUcUvWI2E2dJbpqV7DxPYLXZXOshpG8j+HnShylqRXGvkf7WfGWX7fWw7i7Psusf3W8RY53c73p1jm7YZGETqVT5NbJiNX0NDclUdS6MXb04jIxA1ctwoJKiicrfA81BpqQ8EO38FTvTsz77MIA9W8UipE1zrz31LTDBc8sKnI64umfk+H5udQXoXJFoSEO+cLA5uYVzqVIC5p0q0FJZI2lMghmZZwvUI1cIG8Nv9/z2P2DVaiaO2tqXWeVMS9xfFue9ceNpbUveGRGTmM8udpSOzrkFru93mIvUhqpcnbuUADGGJwrTqghyi7Ipzu4YazRoFTdm7q4bZSKD+KJuidoKRH0g/o16DAorIAiW7I+4j6vWpJDmA8/kxwtxp/KutXIu1GRibof5x3b5KBwDk9t/a1rXUUNLEd+2g/9Bs5ufNvK/p0z1d+tz/kxLocJopuFL2zaWdxjqvq05o2NYZzNzs5hN9poM68LMbJ4JhiY4zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduces four new crash types to LKDTM to reproduce deadlock patterns
involving folio_lock(), which operates on a wait-on-bit mechanism:

 1. FOLIO_LOCK_AA:
   Triggers a self-deadlock (AA) by attempting to acquire the same folio
   lock twice in the same execution context.

 2. FOLIO_LOCK_ABBA:
   Triggers a classic ABBA deadlock between two threads trying to folio
   lock two different folios in reverse order.

 3. FOLIO_MUTEX_LOCK_ABBA:
   Reproduces an ABBA deadlock involving a folio_lock() and a mutex.

 4. FOLIO_DEFERRED_EVENT_ABBA:
   Creates a deferred deadlock where a thread holding a folio_lock() waits
   on a wait queue. By deferring its lock acquisition to a workqueue,
   the waker forms a circular dependency that blocks both the waiter and
   the kworker.

These tests allow developers to validate the kernel's behavior
(e.g., hung task detection, DEPT[1][2][3] report) under wait/event-based
deadlock conditions.

 [1] https://lwn.net/Articles/1036222/
 [2] https://youtu.be/pfWxBuMzxks?si=mW699Yz6dp38diiM
 [3] https://lore.kernel.org/lkml/20251205071855.72743-1-byungchul@sk.com/

Below are the call traces from hungtaskd (for 1. FOLIO_LOCK_AA and
4. FOLIO_DEFERRED_EVENT_ABBA) and DEPT (for 2. FOLIO_LOCK_ABBA and
3. FOLIO_MUTEX_LOCK_ABBA):

 # echo FOLIO_LOCK_AA > /sys/kernel/debug/provoke-crash/DIRECT
 [   26.841460] lkdtm: Performing direct entry FOLIO_LOCK_AA
 [   61.151664] INFO: task bash:915 blocked for more than 30 seconds.
 [   61.152107]       Not tainted 6.19.0-virtme #20
 [   61.152482] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [   61.152843] task:bash            state:D stack:12536 pid:915   tgid:915   ppid:909    task_flags:0x400100 flags:0x00080000
 [   61.153440] Call Trace:
 [   61.153585]  <TASK>
 [   61.153732]  ? __schedule+0x5e9/0x11b0
 [   61.153941]  __schedule+0x61c/0x11b0
 [   61.154157]  schedule+0x3a/0x130
 [   61.154447]  io_schedule+0x46/0x70
 [   61.154649]  folio_wait_bit_common+0x1ab/0x440
 [   61.154918]  ? __pfx_wake_page_function+0x10/0x10
 [   61.155167]  lkdtm_FOLIO_LOCK_AA+0x10c/0x1b0
 [   61.155562]  lkdtm_do_action+0x18/0x30
 [   61.155754]  direct_entry+0x8d/0xe0
 [   61.155955]  full_proxy_write+0x69/0xa0
 [   61.156157]  vfs_write+0xea/0x600
 [   61.156448]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   61.156706]  ? find_held_lock+0x2b/0x80
 [   61.156902]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   61.157141]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   61.157469]  ? from_pool+0x7d/0x190
 [   61.157664]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   61.157900]  ? dept_enter+0x68/0xa0
 [   61.158098]  ksys_write+0x76/0xf0
 [   61.158396]  do_syscall_64+0xc2/0xf80
 [   61.158599]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
 [   61.158851] RIP: 0033:0x7fe2e7d58340
 [   61.159063] RSP: 002b:00007ffc370df3a8 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 [   61.159526] RAX: ffffffffffffffda RBX: 000000000000000e RCX: 00007fe2e7d58340
 [   61.159863] RDX: 000000000000000e RSI: 0000559c6fb13ed0 RDI: 0000000000000001
 [   61.160353] RBP: 0000559c6fb13ed0 R08: 0000000000000007 R09: 0000000000000073
 [   61.160695] R10: 0000000000001000 R11: 0000000000000202 R12: 000000000000000e
 [   61.161032] R13: 00007fe2e7e34760 R14: 000000000000000e R15: 00007fe2e7e2f9e0
 [   61.161490]  </TASK>
 [   61.161639]
 [   61.161639] Showing all locks held in the system:
 [   61.161942] 1 lock held by khungtaskd/116:
 [   61.162142]  #0: ffffffffa2380620 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [   61.162884] 1 lock held by bash/915:
 [   61.163422]  #0: ffff89af81beb570 (sb_writers#8){.+.+}-{0:0}, at: ksys_write+0x76/0xf0
 [   61.164077]
 [   61.164367] =============================================

 # echo FOLIO_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [  182.473798] lkdtm: Performing direct entry FOLIO_LOCK_ABBA
 [  182.475397] ===================================================
 [  182.475637] DEPT: Circular dependency has been detected.
 [  182.475774] 6.19.0-virtme #20 Not tainted
 [  182.475885] ---------------------------------------------------
 [  182.476054] summary
 [  182.476112] ---------------------------------------------------
 [  182.476259] *** AA DEADLOCK ***
 [  182.476259]
 [  182.476379] context A
 [  182.476463]    [S] (unknown)(pg_locked_map:0)
 [  182.476604]    [W] dept_page_wait_on_bit(pg_locked_map:0)
 [  182.476744]    [E] dept_page_clear_bit(pg_locked_map:0)
 [  182.476884]
 [  182.476943] [S]: start of the event context
 [  182.477055] [W]: the wait blocked
 [  182.477158] [E]: the event not reachable
 [  182.477268] ---------------------------------------------------
 [  182.477415] context A's detail
 [  182.477504] ---------------------------------------------------
 [  182.477652] context A
 [  182.477711]    [S] (unknown)(pg_locked_map:0)
 [  182.477852]    [W] dept_page_wait_on_bit(pg_locked_map:0)
 [  182.477992]    [E] dept_page_clear_bit(pg_locked_map:0)
 [  182.478132]
 [  182.478190] [S] (unknown)(pg_locked_map:0):
 [  182.478300] (N/A)
 [  182.478359]
 [  182.478418] [W] dept_page_wait_on_bit(pg_locked_map:0):
 [  182.478558] [<ffffffff8cf9a5ae>] kthread+0xfe/0x200
 [  182.478698] stacktrace:
 [  182.478757]       kthread+0xfe/0x200
 [  182.478867]       ret_from_fork+0x29d/0x2e0
 [  182.478977]       ret_from_fork_asm+0x1a/0x30
 [  182.479118]
 [  182.479177] [E] dept_page_clear_bit(pg_locked_map:0):
 [  182.479316] [<ffffffff8d989fe3>] lkdtm_folio_ab_kthread+0xb3/0x1a0
 [  182.479485] stacktrace:
 [  182.479545]       lkdtm_folio_ab_kthread+0xb3/0x1a0
 [  182.479685]       kthread+0xfe/0x200
 [  182.479796]       ret_from_fork+0x29d/0x2e0
 [  182.479906]       ret_from_fork_asm+0x1a/0x30
 [  182.480045] ---------------------------------------------------
 [  182.480192] information that might be helpful
 [  182.480310] ---------------------------------------------------
 [  182.480458] CPU: 2 UID: 0 PID: 915 Comm: lkdtm_folio_a Not tainted 6.19.0-virtme #20 PREEMPT(voluntary)
 [  182.480464] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
 [  182.480466] Call Trace:
 [  182.480469]  <TASK>
 [  182.480473]  dump_stack_lvl+0x69/0xa0
 [  182.480481]  cb_check_dl+0x6be/0x760
 [  182.480492]  ? srso_alias_return_thunk+0x5/0xfbef5
 [  182.480497]  ? lock_acquire+0x26b/0x2b0
 [  182.480507]  bfs+0x138/0x1c0
 [  182.480511]  ? srso_alias_return_thunk+0x5/0xfbef5
 [  182.480522]  add_dep+0xd6/0x1c0
 [  182.480527]  ? srso_alias_return_thunk+0x5/0xfbef5
 [  182.480531]  ? __pfx_bfs_init_check_dl+0x10/0x10
 [  182.480535]  ? __pfx_bfs_extend_dep+0x10/0x10
 [  182.480539]  ? __pfx_bfs_dequeue_dep+0x10/0x10
 [  182.480543]  ? __pfx_cb_check_dl+0x10/0x10
 [  182.480551]  __dept_event+0x489/0x520
 [  182.480558]  ? srso_alias_return_thunk+0x5/0xfbef5
 [  182.480564]  ? lkdtm_folio_ab_kthread+0xb3/0x1a0
 [  182.480570]  dept_event+0x99/0xc0
 [  182.480581]  folio_unlock+0x3c/0x60
 [  182.480587]  lkdtm_folio_ab_kthread+0xb3/0x1a0
 [  182.480594]  ? __pfx_lkdtm_folio_ab_kthread+0x10/0x10
 [  182.480598]  kthread+0xfe/0x200
 [  182.480605]  ? __pfx_kthread+0x10/0x10
 [  182.480613]  ret_from_fork+0x29d/0x2e0
 [  182.480616]  ? __pfx_kthread+0x10/0x10
 [  182.480622]  ret_from_fork_asm+0x1a/0x30
 [  182.480644]  </TASK>

 # echo FOLIO_MUTEX_LOCK_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [   25.744189] lkdtm: Performing direct entry FOLIO_MUTEX_LOCK_ABBA
 [   25.750265] ===================================================
 [   25.750826] DEPT: Circular dependency has been detected.
 [   25.750911] 6.19.0-virtme #20 Not tainted
 [   25.750995] ---------------------------------------------------
 [   25.751098] summary
 [   25.751149] ---------------------------------------------------
 [   25.751252] *** DEADLOCK ***
 [   25.751252]
 [   25.751338] context A
 [   25.751389]    [S] lock(mutex_b:0)
 [   25.751458]    [W] dept_page_wait_on_bit(pg_lcked_map:0)
 [[   25.751652]  ?  [E] unlock(mutex_b:0)
 2[   25.751781]
 0[   25.751861] context B
 0[   25.751937]    [S] (unknown)(pg_locked_map:0)4
 h[   25.752088]    [W] lock(mutex_b:0)
 [   25.752175]    [E] dept_page_clear_bit(pg_locked_map:0)
 [   25.752265]
 [   25.752315] [S]: start of the event context
 [   25.752382] [W]: the wait blocked
 [   25.752452] [E]: the event not reachable
 [   25.752520] ---------------------------------------------------
 [   25.752621] context A's detairl
 [   25.752726] -o--------------------------------o------------------
 t[   25.752894] context A
 @[   25.752960]    [S] lock(mutexv_b:0)
 i[   25.753074]    [W] dept_page_rwait_on_bit(pg_locked_map:0)
 t[   25.753210]    [E] unlock(mutmex_b:0)
 e[   25.753324]
 -[   25.753394] [S] lock(mutex_b:n0):
 g[   25.753513] [:<ffffffffb1989d90>] lkdtm_mutex_/folio_kthread+0x40/0xe0
 [   25.753705] stacktrace:
 [   25.753757]  h     lkdtm_mutex_folio_kthread+0x40/0xe0
 o[   25.753890]  m     kthread+0xfee/0x200
 /[   25.754049]       ret_from_fokrk+0x29d/0x2e0
 i[   25.754175]  m     ret_from_fo/rk_asm+0x1a/0x30s
 a[   25.754390]
 [   25.754496] [gW] dept_page_waiit_on_bit(pg_lockned_map:0):
 g[   25.754678] [<ffffffffb0f9a5ae>] kthread+0xfe/0x200
 [   25.754796] s#tacktrace:
  [   25.754874]       kthread+0xfe/0x200
 [   25.754981]       ret_from_fork+0x29d/0x2e0
 [   25.755039]       ret_from_fork_asm+0x1a/0x30
 [   25.755130]
 [   25.755185] [E] unlock(mutex_b:0):
 [   25.755254] (N/A)
 [   25.755304] ---------------------------------------------------
 [   25.755406] context B's detail
 [   25.755473] ---------------------------------------------------
 [   25.755576] context B
 [   25.755625]    [S] (unknown)(pg_locked_map:0)
 [   25.755724]    [W] lock(mutex_b:0)
 [   25.755791]    [E] dept_page_clear_bit(pg_locked_map:0)
 [   25.755893]
 [   25.755955] [S] (unknown)(pg_locked_map:0):
 [   25.756039] (N/A)
 [   25.756102]
 [   25.756164] [W] lock(mutex_b:0):
 [   25.756248] [<ffffffffb1989e68>] lkdtm_folio_mutex_kthread+0x28/0xe0
 [   25.756376] stacktrace:
 [   25.756438]       lkdtm_folio_mutex_kthread+0x28/0xe0
 [   25.756545]       kthread+0xfe/0x200
 [   25.756629]       ret_from_fork+0x29d/0x2e0
 [   25.756726]       ret_from_fork_asm+0x1a/0x30
 [   25.756853]
 [   25.756918] [E] dept_page_clear_bit(pg_locked_map:0):
 [   25.757081] [<ffffffffb1989e80>] lkdtm_folio_mutex_kthread+0x40/0xe0
 [   25.757241] stacktrace:
 [   25.757315]       lkdtm_folio_mutex_kthread+0x40/0xe0
 [   25.757449]       kthread+0xfe/0x200
 [   25.757555]       ret_from_fork+0x29d/0x2e0
 [   25.757672]       ret_from_fork_asm+0x1a/0x30
 [   25.757816] ---------------------------------------------------
 [   25.758014] information that might be helpful
 [   25.758180] ---------------------------------------------------
 [   25.758370] CPU: 15 UID: 0 PID: 922 Comm: lkdtm_mutex_fol Not tainted 6.19.0-virtme #20 PREEMPT(voluntary)
 [   25.758381] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
 [   25.758386] Call Trace:
 [   25.758391]  <TASK>
 [   25.758403]  dump_stack_lvl+0x69/0xa0
 [   25.758424]  cb_check_dl+0x6be/0x760
 [   25.758454]  bfs+0x17d/0x1c0
 [   25.758459]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   25.758471]  add_dep+0xd6/0x1c0
 [   25.758477]  ? lkdtm_mutex_folio_kthread+0x40/0xe0
 [   25.758482]  ? __pfx_bfs_init_check_dl+0x10/0x10
 [   25.758488]  ? __pfx_bfs_extend_dep+0x10/0x10
 [   25.758492]  ? __pfx_bfs_dequeue_dep+0x10/0x10
 [   25.758496]  ? __pfx_cb_check_dl+0x10/0x10
 [   25.758505]  __dept_wait+0x274/0x6a0
 [   25.758514]  ? kthread+0xfe/0x200
 [   25.758520]  ? __mutex_lock+0xae3/0x1230
 [   25.758532]  ? srso_alias_return_thunk+0x5/0xfbef5
 [   25.758536]  ? dept_enter+0x68/0xa0
 [   25.758545]  ? kthread+0xfe/0x200
 [   25.758551]  dept_wait+0xa7/0xc0
 [   25.758562]  ? __pfx_lkdtm_mutex_folio_kthread+0x10/0x10
 [   25.758567]  lkdtm_mutex_folio_kthread+0x9d/0xe0
 [   25.758573]  kthread+0xfe/0x200
 [   25.758579]  ? __pfx_kthread+0x10/0x10
 [   25.758587]  ret_from_fork+0x29d/0x2e0
 [   25.758591]  ? __pfx_kthread+0x10/0x10
 [   25.758597]  ret_from_fork_asm+0x1a/0x30
 [   25.758619]  </TASK>

 # echo FOLIO_DEFERRED_EVENT_ABBA > /sys/kernel/debug/provoke-crash/DIRECT
 [  100.907960] lkdtm: Performing direct entry FOLIO_DEFERRED_EVENT_ABBA
 [  100.908476] lkdtm: [Waiter Thread] Securing the folio_lock...
 [  100.908662] lkdtm: [Waiter Thread] Lock secured. Sleeping on wait queue.
 [  100.908691] lkdtm: [Trigger] Calling wake_up() to initiate deferred deadlock.
 [  100.908928] lkdtm: [Waker Context] Atomic callback triggered. Deferring work...
 [  100.909265] lkdtm: [Worker Context] Attempting to acquire folio_lock...
 [  151.210039] INFO: task kworker/14:1:124 blocked for more than 30 seconds.
 [  151.210422]       Not tainted 6.19.0-virtme #23
 [  151.210559] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [  151.210695] task:kworker/14:1    state:D stack:14344 pid:124   tgid:124   ppid:2      task_flags:0x4208060 flags:0x00080000
 [  151.210880] Workqueue: events deferred_deadlocking
 [  151.210979] Call Trace:
 [  151.211029]  <TASK>
 [  151.211088]  __schedule+0x5e7/0x1170
 [  151.211182]  schedule+0x3a/0x130
 [  151.211256]  io_schedule+0x46/0x70
 [  151.211324]  folio_wait_bit_common+0x125/0x2d0
 [  151.211423]  ? __pfx_wake_page_function+0x10/0x10
 [  151.211563]  deferred_deadlocking+0x68/0x70
 [  151.211664]  process_one_work+0x205/0x690
 [  151.211782]  ? lock_is_held_type+0x9e/0x110
 [  151.211900]  worker_thread+0x188/0x330
 [  151.211994]  ? __pfx_worker_thread+0x10/0x10
 [  151.212111]  kthread+0xfe/0x200
 [  151.212199]  ? __pfx_kthread+0x10/0x10
 [  151.212295]  ret_from_fork+0x2b2/0x2e0
 [  151.212385]  ? __pfx_kthread+0x10/0x10
 [  151.212473]  ret_from_fork_asm+0x1a/0x30
 [  151.212599]  </TASK>
 [  151.212676] INFO: task lkdtm_waiter:916 blocked for more than 30 seconds.
 [  151.212844]       Not tainted 6.19.0-virtme #23
 [  151.212955] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
 [  151.213105] task:lkdtm_waiter    state:D stack:14936 pid:916   tgid:916   ppid:2      task_flags:0x208040 flags:0x00080000
 [  151.213309] Call Trace:
 [  151.213372]  <TASK>
 [  151.213444]  __schedule+0x5e7/0x1170
 [  151.213550]  ? __pfx_lkdtm_waiter_thread+0x10/0x10
 [  151.213666]  schedule+0x3a/0x130
 [  151.213776]  lkdtm_waiter_thread+0xab/0x120
 [  151.213869]  ? __pfx_wake_for_deferred_work+0x10/0x10
 [  151.213986]  kthread+0xfe/0x200
 [  151.214077]  ? __pfx_kthread+0x10/0x10
 [  151.214173]  ret_from_fork+0x2b2/0x2e0
 [  151.214260]  ? __pfx_kthread+0x10/0x10
 [  151.214347]  ret_from_fork_asm+0x1a/0x30
 [  151.214472]  </TASK>
 [  151.214588]
 [  151.214588] Showing all locks held in the system:
 [  151.214766] 1 lock held by khungtaskd/116:
 [  151.214878]  #0: ffffffffb676d760 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x36/0x1c0
 [  151.215078] 2 locks held by kworker/14:1/124:
 [  151.215191]  #0: ffff8ee181098948 ((wq_completion)events){+.+.}-{0:0}, at: process_one_work+0x55c/0x690
 [  151.215386]  #1: ffffd401404a3e40 ((work_completion)(&deadlock_work)){+.+.}-{0:0}, at: process_one_work+0x1c4/0x690
 [  151.215619]
 [  151.215677] =============================================

Assisted-by: Gemini:gemini-3.1-pro
Cc: Byungchul Park <byungchul@sk.com>
Cc: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
---
 drivers/misc/lkdtm/Makefile             |   1 +
 drivers/misc/lkdtm/core.c               |   1 +
 drivers/misc/lkdtm/deadlock.c           | 304 ++++++++++++++++++++++++
 drivers/misc/lkdtm/lkdtm.h              |   1 +
 tools/testing/selftests/lkdtm/tests.txt |   4 +
 5 files changed, 311 insertions(+)
 create mode 100644 drivers/misc/lkdtm/deadlock.c

diff --git a/drivers/misc/lkdtm/Makefile b/drivers/misc/lkdtm/Makefile
index 03ebe33185f9..02264813a346 100644
--- a/drivers/misc/lkdtm/Makefile
+++ b/drivers/misc/lkdtm/Makefile
@@ -3,6 +3,7 @@ obj-$(CONFIG_LKDTM)		+= lkdtm.o
 
 lkdtm-$(CONFIG_LKDTM)		+= core.o
 lkdtm-$(CONFIG_LKDTM)		+= bugs.o
+lkdtm-$(CONFIG_LKDTM)		+= deadlock.o
 lkdtm-$(CONFIG_LKDTM)		+= heap.o
 lkdtm-$(CONFIG_LKDTM)		+= perms.o
 lkdtm-$(CONFIG_LKDTM)		+= refcount.o
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index 5732fd59a227..ea6201861bb7 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -89,6 +89,7 @@ static struct crashpoint crashpoints[] = {
 /* List of possible types for crashes that can be triggered. */
 static const struct crashtype_category *crashtype_categories[] = {
 	&bugs_crashtypes,
+	&deadlock_crashtypes,
 	&heap_crashtypes,
 	&perms_crashtypes,
 	&refcount_crashtypes,
diff --git a/drivers/misc/lkdtm/deadlock.c b/drivers/misc/lkdtm/deadlock.c
new file mode 100644
index 000000000000..d859ca096ac9
--- /dev/null
+++ b/drivers/misc/lkdtm/deadlock.c
@@ -0,0 +1,304 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * This is for all the tests related to deadlock.
+ */
+#include "lkdtm.h"
+#include <linux/mm.h>
+#include <linux/kthread.h>
+#include <linux/mutex.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/pagemap.h>
+
+static struct folio *folio_common;
+
+/*
+ * Triggering a simple AA deadlock on a folio, Attempting to acquire the same
+ * folio twice in the same execution context, resulting in a self-deadlock.
+ */
+static void lkdtm_FOLIO_LOCK_AA(void)
+{
+	folio_common = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!folio_common) {
+		pr_err("folio_alloc() failed.\n");
+		return;
+	}
+
+	folio_lock(folio_common);
+	folio_lock(folio_common);
+
+	/* Unreachable */
+	folio_unlock(folio_common);
+
+	folio_put(folio_common);
+}
+
+/*
+ * Attempting the 'AB' order for ABBA deadlock
+ */
+static int lkdtm_folio_ab_kthread(void *folio_b)
+{
+	while (true) {
+		folio_lock(folio_common);
+		folio_lock((struct folio *)folio_b);
+		folio_unlock((struct folio *)folio_b);
+		folio_unlock(folio_common);
+	}
+
+	return 0;
+}
+
+/*
+ * Attempting the 'BA' order for ABBA deadlock
+ */
+static int lkdtm_folio_ba_kthread(void *folio_b)
+{
+	while (true) {
+		folio_lock((struct folio *)folio_b);
+		folio_lock(folio_common);
+		folio_unlock(folio_common);
+		folio_unlock((struct folio *)folio_b);
+	}
+
+	return 0;
+}
+
+/*
+ * Spawning kthreads that attempt to acquire Waiter A and Waiter B in reverse
+ * order. Leading to a state where Thread A holds Waiter A and waits for
+ * Waiter B, while Thread B holds Waiter B and waits for Waiter A.
+ */
+static void lkdtm_FOLIO_LOCK_ABBA(void)
+{
+	struct folio *folio_b;
+	struct task_struct *t0, *t1;
+
+	folio_common = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	folio_b = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	if (!folio_common || !folio_b) {
+		pr_err("folio_alloc() failed.\n");
+		return;
+	}
+
+	t0 = kthread_run(lkdtm_folio_ab_kthread, folio_b, "lkdtm_folio_a");
+	t1 = kthread_run(lkdtm_folio_ba_kthread, folio_b, "lkdtm_folio_b");
+
+	if (IS_ERR(t0) || IS_ERR(t1))
+		pr_err("failed to start kthread.\n");
+
+	folio_put(folio_common);
+	folio_put(folio_b);
+}
+
+DEFINE_MUTEX(mutex_b);
+
+/* Attempting 'folio_lock() A then Mutex B' order */
+static int lkdtm_folio_mutex_kthread(void *)
+{
+	while (true) {
+		folio_lock(folio_common);
+		mutex_lock(&mutex_b);
+		mutex_unlock(&mutex_b);
+		folio_unlock(folio_common);
+	}
+
+	return 0;
+}
+
+/* Attempting 'Mutex B then folio_lock() A' order */
+static int lkdtm_mutex_folio_kthread(void *)
+{
+	while (true) {
+		mutex_lock(&mutex_b);
+		folio_lock(folio_common);
+		folio_unlock(folio_common);
+		mutex_unlock(&mutex_b);
+	}
+
+	return 0;
+}
+
+/* Triggering ABBA deadlock between folio_lock() and mutex. */
+static void lkdtm_FOLIO_MUTEX_LOCK_ABBA(void)
+{
+	struct task_struct *t0, *t1;
+
+	folio_common = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+
+	t0 = kthread_run(lkdtm_folio_mutex_kthread, NULL, "lkdtm_folio_mutex");
+	t1 = kthread_run(lkdtm_mutex_folio_kthread, NULL, "lkdtm_mutex_folio");
+
+	if (IS_ERR(t0) || IS_ERR(t1))
+		pr_err("failed to start kthreads\n");
+
+	folio_put(folio_common);
+}
+
+/*
+ * Deferred AB-BA Deadlock Scenario
+ *
+ * Deferring a lock acquisition from an atomic wake-up callback to a
+ * sleepable workqueue context.
+ *
+ * ----------------------------------------------------------------------
+ * 'lkdtm_waiter' kthread          Waker               kworker thread
+ *  [Sleepable Context]        (LKDTM Trigger)       [Sleepable Context]
+ *           |                       |                      |
+ *    1. folio_lock(folio_common)    |                      |
+ *       [Holds Folio]               |                      |
+ *           |                       |                      |
+ *    [Waits for Wakeup] <---  2. wake_up(&wq_deadlock)     |
+ *           |                       |                      |
+ *           |              3. wake_for_deferred_work()     |
+ *           |                  [Inside wq_deadlock->lock]  |
+ *           |                       |                      |
+ *           |              4. schedule_work() --->         |
+ *           |                       |          5. deferred_deadlocking()
+ *           |                       |                      |
+ *           |                       |          6. folio_lock(folio_common)
+ *           |                       |               [Waits for Folio]
+ *           |                       |                      |
+ * ----------------------------------------------------------------------
+ */
+static DECLARE_WAIT_QUEUE_HEAD(wq_deadlock);
+static DECLARE_COMPLETION(waiter_ready);
+static struct folio *folio_common;
+static struct work_struct deadlock_work;
+
+/**
+ * deferred_deadlocking - The deferred task executed by a kworker thread.
+ * @work: The work structure associated with this task.
+ *
+ * Since this runs in a kworker thread, it is a safe sleepable context.
+ * Attempting to acquire the folio_lock here will not cause an atomic
+ * scheduling violation, but it will create a logical deadlock and a
+ * circular dependency.
+ */
+static void deferred_deadlocking(struct work_struct *work)
+{
+	pr_info("[Worker Context] Attempting to acquire folio_lock...\n");
+
+	/*
+	 * DEADLOCK POINT:
+	 * The kworker blocks here indefinitely because the lkdtm_waiter
+	 * thread holds the PG_locked bit of folio_common.
+	 */
+	folio_lock(folio_common);
+
+	/* Unreachable */
+	folio_unlock(folio_common);
+
+	folio_put(folio_common);
+
+	wake_up_all(&wq_deadlock);
+}
+
+/**
+ * wake_for_deferred_work - Invoking the deferred_waker_work().
+ * @wq_entry: The wait queue entry being woken up.
+ * @mode: Wakeup mode (e.g., TASK_NORMAL).
+ * @sync: Indicates if the wakeup is synchronous.
+ * @key: Event-specific key passed to wake_up().
+ *
+ * Return: Always 0, meaning the waiter is not woken up and
+ * remains in the wait queue.
+ */
+static int wake_for_deferred_work(struct wait_queue_entry *wq_entry,
+				  unsigned int mode, int sync, void *key)
+{
+	pr_emerg(
+		"[Waker Context] Atomic callback triggered. Deferring work...\n");
+
+	schedule_work(&deadlock_work);
+
+	return 0;
+}
+
+/**
+ * lkdtm_waiter_thread - The background thread holding the lock.
+ *
+ * It acquires the folio lock, signals readiness to the trigger process,
+ * and then goes to sleep on the custom wait queue.
+ *
+ * Return: 0 on exit (unreachable in successful deadlock).
+ */
+static int lkdtm_waiter_thread(void *)
+{
+	struct wait_queue_entry custom_wait;
+
+	init_waitqueue_func_entry(&custom_wait, wake_for_deferred_work);
+
+	pr_info("[Waiter Thread] Securing the folio_lock...\n");
+	folio_lock(folio_common);
+
+	complete(&waiter_ready);
+
+	pr_info("[Waiter Thread] Lock secured. Sleeping on wait queue.\n");
+
+	add_wait_queue(&wq_deadlock, &custom_wait);
+
+	/*
+	 * Manual sleep logic. We sleep without a condition because we
+	 * expect the deferred work to eventually wake us up.
+	 */
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	schedule();
+
+	/* Unreachable */
+	__set_current_state(TASK_RUNNING);
+	remove_wait_queue(&wq_deadlock, &custom_wait);
+	folio_unlock(folio_common);
+
+	return 0;
+}
+
+/*
+ * Spawns the waiter thread, and triggers the wait queue wakeup mechanism to
+ * initiate the deferred deadlock.
+ */
+static void lkdtm_FOLIO_DEFERRED_EVENT_ABBA(void)
+{
+	struct task_struct *waiter_task;
+
+	folio_common = folio_alloc(GFP_KERNEL | __GFP_ZERO, 0);
+	if (!folio_common) {
+		pr_err("Failed to allocate folio.\n");
+		return;
+	}
+
+
+	INIT_WORK(&deadlock_work, deferred_deadlocking);
+	reinit_completion(&waiter_ready);
+
+	waiter_task = kthread_run(lkdtm_waiter_thread, NULL, "lkdtm_waiter");
+	if (IS_ERR(waiter_task)) {
+		pr_err("Failed to create waiter thread.\n");
+		folio_put(folio_common);
+		return;
+	}
+
+	wait_for_completion(&waiter_ready);
+
+	pr_info("[Trigger] Calling wake_up() to initiate deferred deadlock.\n");
+
+	/*
+	 * Triggers wake_for_deferred_work() in the current atomic context,
+	 * which in turn schedules deferred_deadlocking().
+	 */
+	wake_up(&wq_deadlock);
+}
+
+static struct crashtype crashtypes[] = {
+	CRASHTYPE(FOLIO_LOCK_AA),
+	CRASHTYPE(FOLIO_LOCK_ABBA),
+	CRASHTYPE(FOLIO_MUTEX_LOCK_ABBA),
+	CRASHTYPE(FOLIO_DEFERRED_EVENT_ABBA),
+};
+
+struct crashtype_category deadlock_crashtypes = {
+	.crashtypes = crashtypes,
+	.len = ARRAY_SIZE(crashtypes),
+};
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index 015e0484026b..95898de29c57 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -77,6 +77,7 @@ struct crashtype_category {
 
 /* Each category's crashtypes list. */
 extern struct crashtype_category bugs_crashtypes;
+extern struct crashtype_category deadlock_crashtypes;
 extern struct crashtype_category heap_crashtypes;
 extern struct crashtype_category perms_crashtypes;
 extern struct crashtype_category refcount_crashtypes;
diff --git a/tools/testing/selftests/lkdtm/tests.txt b/tools/testing/selftests/lkdtm/tests.txt
index e62b85b591be..0cbd22ff01de 100644
--- a/tools/testing/selftests/lkdtm/tests.txt
+++ b/tools/testing/selftests/lkdtm/tests.txt
@@ -87,3 +87,7 @@ FORTIFY_STR_MEMBER detected buffer overflow
 FORTIFY_MEM_OBJECT detected buffer overflow
 FORTIFY_MEM_MEMBER detected field-spanning write
 PPC_SLB_MULTIHIT Recovered
+#FOLIO_LOCK_AA Hangs the system
+#FOLIO_LOCK_ABBA Hangs the system
+#FOLIO_MUTEX_LOCK_ABBA Hangs the system
+#FOLIO_DEFERRED_EVENT_ABBA Hangs the system
-- 
2.39.5


