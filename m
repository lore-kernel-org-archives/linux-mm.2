Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFCDFCA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0275C8E0013; Mon, 18 Aug 2025 13:54:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F41338E000A; Mon, 18 Aug 2025 13:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FD38E0013; Mon, 18 Aug 2025 13:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CF4468E000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:54:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76B48140976
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:54:06 +0000 (UTC)
X-FDA: 83790626892.08.A0546F9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5968440003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:54:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WT/OlNLq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755539644; a=rsa-sha256;
	cv=none;
	b=nAoLUwX+6Le3Y4kKbg2M7HFdIGI86QuWiowJs1ldLLkIs5xmr4dq5asXSk6vINE3wstOMn
	OSB/PmNJYcX6bU6597ARK/y8dmw1atyLeNt7YKSB2+vr687TzG40wgfW62UODovrFP//+0
	feg8yUWKEtwj8mBbWZt7OVzcXMAKzVg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="WT/OlNLq";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of dhildenb@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=dhildenb@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755539644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=89YYgFY/atKO7NXyA1yiC1oohqeWnpMbKEyE+yEL/fg=;
	b=5E6K0Xk6Mx2B1qAl/2sBEHsQBqMI9h+BDAODq1hVCeWT0RBCp2h9/Al7zKHoxS0iLc2Y4c
	0e9s2woItGFOIgj+NgXwF6MgULqyaQCo1VU2YehybCajMwjsayq3N9bu9/iE7tO0VKcGAw
	kC2fYipmSY+I/XgTacnbt0C2oogX+MY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755539643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=89YYgFY/atKO7NXyA1yiC1oohqeWnpMbKEyE+yEL/fg=;
	b=WT/OlNLq7u77WRvkUwITbRgJbEz0KkszeVAXVLFJ53NxE4ykJxxJj2H+XkpoxPek1oiL2e
	5Gs4qjHX3iwxptB8D1rNe9kTkmeiOVSvGfWIyKIB3GN3LOOMbtUF61yQzM3p7aI5GEj/jM
	AHQH7pyXgBNyN/hISJDNLUjXfizME+A=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-64-DViqDiMhNQWNrD0_XjX6YA-1; Mon, 18 Aug 2025 13:54:02 -0400
X-MC-Unique: DViqDiMhNQWNrD0_XjX6YA-1
X-Mimecast-MFC-AGG-ID: DViqDiMhNQWNrD0_XjX6YA_1755539641
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15fd6b45so20509305e9.1
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 10:54:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755539641; x=1756144441;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=89YYgFY/atKO7NXyA1yiC1oohqeWnpMbKEyE+yEL/fg=;
        b=q3Pnfcsp5ypqTvX0TsdjKJltaGmstMlpe+B6EcQKlerQSiMW98Reu+yhaVuAeBU4Qh
         0q/QQKL08MG8AZqyEdjgxMbt4m6xSQr9IGWEikmU+1daPs5FQWvVcGlXYW6366SRD+nV
         1r4srEyGubNIU3/XDipFbrpnF4gt9whgw0UoLgbkBa+psP3unrSri5HLKQBtcNrxR0f8
         B9rEo2C7JDXKV/oN71xIG3Xdep3OpMQppJVw6XAjeklTjOrNE8FYMsxhUO2m86ggY9ge
         wVwWi8qOUoERRI40wNa//LhBK9qMYHMvZ76wix0H22VKkJ+5m9KEXkgfpccMRTLEfaZC
         jceg==
X-Gm-Message-State: AOJu0YzVrMugFQizILGhHG+g1BI33tU6C9jDxX4gjORsHCzeuDP6BXtp
	BwM6Y+iTEg0bivBJIWvOO0LLXUgnaWwGsrk3lXZ3DcDOzr5AFzUGA7ZxQP9z6i6EMNUnj3G43mR
	Ri2mOlgqDCISiQqFpjCFh55jvp8mDp4E/K0W3aXE9DrGKuRpgU53x
X-Gm-Gg: ASbGncvENZ1nWx6hWFcE7Oj8SqD9jp7SPPfxa1vZKYlf30Vo1IccNHdA52oK6ram+wL
	lPpYV3FBhgierwRurvau+TL7uygelGsdRxkqIFNAelxhPYi8w2rITpH+BfeK44wa8BAdwgdkBHM
	2fZLlzAGOktxyl5hGc+eFgHmlamLlvI32szw1BlvHBSALaZM4LBaY57WKNeG2H25QX4reoD/ID4
	eYTaSKn9VcRtS4SQfYDKt+vrIuq8LnkWP/3o0KiHWPK9gPQR1EgMtHf1ncW76Hk7YMO6lQFc32M
	odpG4sZ5msqifoHyApuMGMJxUI76etpk7+DUJqaH0lgrMe78fs2vZxYiD5JopCf0pJBHPHJwfbS
	XUbrOF96tfz8w3KAedslRqQ==
X-Received: by 2002:a05:6000:1448:b0:3b7:8342:dc58 with SMTP id ffacd0b85a97d-3c089a308e2mr135476f8f.16.1755539640861;
        Mon, 18 Aug 2025 10:54:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEZFhZbPqR5i6NEhC4IJI8iYAbzcC+PQVoWnhvOMkVOWh9OMDuG2EqkAM9pwaYapKx+zoqh+w==
X-Received: by 2002:a05:6000:1448:b0:3b7:8342:dc58 with SMTP id ffacd0b85a97d-3c089a308e2mr135463f8f.16.1755539640439;
        Mon, 18 Aug 2025 10:54:00 -0700 (PDT)
Received: from localhost (p200300d82f22060053c7df437dc3ae39.dip0.t-ipconnect.de. [2003:d8:2f22:600:53c7:df43:7dc3:ae39])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c077789106sm386191f8f.51.2025.08.18.10.53.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 10:53:59 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@redhat.com>,
	syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com,
	stable@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry.yoo@oracle.com>
Subject: [PATCH v1] mm/mremap: fix WARN with uffd that has remap events disabled
Date: Mon, 18 Aug 2025 19:53:58 +0200
Message-ID: <20250818175358.1184757-1-david@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0bKIeZhhwGzq4UWQIDav67cnqd6yoP7iV6JA2mHWQ-M_1755539641
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 5968440003
X-Stat-Signature: u3s45ixrurk99nwsbuife1q1pdkrhgfu
X-HE-Tag: 1755539644-282387
X-HE-Meta: U2FsdGVkX1/yI8MupdU6V7JIKRrVm21VhU73aNZH8QV+HKBbUhj88OtUI+1CRmBnAcN/2wryvxkkBBlYeNy8LF9Gl8pYSM3NT/3Rn79n98pUhE1ji8zl7jaZMl7k8sNEFYWPILUd6NPeWDrSMEC5mMsQivhf0DBjBAiTXn5KlFpKpUYV5I6YWE5gfIIo0gN1s4ZHG4WoYFe5UWmp/0yh6IE+b2qDI7vL9dz9rZonVxfByWBwojD06eOz/tC3MK10h4W7M9ZKIj3bMI4nrNjct/EhiIqSmc12dAoJ7PAPOnPPAYVdk64fZwpAp5t0s+SHmnRHPnFaTbwM7y5vdwCPFJTZ0cpr01zEJMdxihB4YxcWED5iTUefJ7nRNIzFXTLjDUnyKKKZSEfCddnpEj6X3YKnTOixV6GTh9xQdH4ZK9YWPxnxDTFmRU5tax7nXXGpzpLAX1giOpqgxKQMpwvrSgwMXKurUCP3fxEw/WYd4JXrKjth+bIbwrIGjIeDQYy04+y2xjIjt3gSTdUREgp8uZAms6pBE5/6KRKgIaUlw6aI9NvOZ9JN2EJRFMeYcAPdxq6Ocu1vp+OOKCTAQ77ZF48InLD/85nh6OyP69qbfUPx5ANvFFZuY52+92j9bM7xWPJjjQpjSZ7EYV/rz8h83+5f//E/SeyioYI31JmDnPIxxqIsqokiHluf8mcF2OC7di8uDen7F9Ys5wDjTYLsyU6j4v/sIoz7iszzodxztmUAdV84K8IeaB2kR0BgaXCqFTKLLx2ou9HNEvHJel3W+qKRbBWwy/UfKgxampmUYwGqrMgvENDpl6anDbXSBf2vTeqtwhsWqw6FYiiJ0vzmDjXZ6yg+Bg2PyOdDAPgMk480sOVVZ/YWFBkqvPPNH9BZsYxcTBAZZUn3gxp9QlJdxpkOX91cSvHjbS4+/gBvD9hkb2pEFkyZJVNmleHUBKHKAfV9frxl8g2J7D6iawd
 7mavSeKH
 PfUhbHb2A4SH+TK2M3ELnxjB1nClfZQqdrzl+3QnR2f6hOJmyLJOC+vKx28XtpEMZ2veYX3Llb9f4CG9eJGD6srp6tF8ixz4w3LSarTvKtQrPpQXJx31nLHmapC5FGWjK3xvZUJTMNRKLbBz3gP3lbdJSZAc58LAzBepu/jFMO7Dgi2oxLjawfdNy6JQ/0fykTkbujPDJsXWkkLRsQWD0EzHS6G/vwNcD1Y14Et4x7cp/qdH91QfK1XB/X0txQaEqSAU48rqJbta+p7wXarx4ekkfZ9d6AiWoKwQ1+uzW6z6BvVgXK0P58CNA+VXyGGvjVcQOqD2yP3g4iTPAXs4GgTHl6gbAR9mdiJCipS2Wiq1kSlts+WrlCiGALoknd+6wjZ7TuZ4iJO/7v+a4yLWzp5a5BjVK+Euoe0QtbaEQUgC+uIhKRnp25pBqdjvLDzxL1QyYiP66P9ngsoybjiRz4tA4eVy4cGFlkuTKL51ZOGZ22DDOD9VdNGRaVEBaIunBRCLIIwD/bvpBgkIXIStkQV11WbufBccvKHhqH3yPJS+SrHmn7HjZpImalYVajbWqriiD1fjiQYDQBEpIXBIdNQi2tIUIliG+yJwlQ5N6vstV393H/NeHbCpX3B3l6NYUKx+gAt9vHBlu6sKRJcGVCwowbkWZI8lKDSED12ul2mniD93q4CtwkVLsYpkU/sQbtcQRx8i9wK+ytnCa3UWzYK+5z9sfAsHDkRe3s03HaHoX/8ZFj5HyHr4UQGyqXWHPyVjAyVnc9csLrqTb9Ca4fdxIBhPH5OijAbVX5TXnWkVzuPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Registering userfaultd on a VMA that spans at least one PMD and then
mremap()'ing that VMA can trigger a WARN when recovering from a failed
page table move due to a page table allocation error.

The code ends up doing the right thing (recurse, avoiding moving actual
page tables), but triggering that WARN is unpleasant:

WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_normal_pmd mm/mremap.c:357 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_pgt_entry mm/mremap.c:595 [inline]
WARNING: CPU: 2 PID: 6133 at mm/mremap.c:357 move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Modules linked in:
CPU: 2 UID: 0 PID: 6133 Comm: syz.0.19 Not tainted 6.17.0-rc1-syzkaller-00004-g53e760d89498 #0 PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:move_normal_pmd mm/mremap.c:357 [inline]
RIP: 0010:move_pgt_entry mm/mremap.c:595 [inline]
RIP: 0010:move_page_tables+0x3832/0x44a0 mm/mremap.c:852
Code: ...
RSP: 0018:ffffc900037a76d8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000032930007 RCX: ffffffff820c6645
RDX: ffff88802e56a440 RSI: ffffffff820c7201 RDI: 0000000000000007
RBP: ffff888037728fc0 R08: 0000000000000007 R09: 0000000000000000
R10: 0000000032930007 R11: 0000000000000000 R12: 0000000000000000
R13: ffffc900037a79a8 R14: 0000000000000001 R15: dffffc0000000000
FS:  000055556316a500(0000) GS:ffff8880d68bc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30863fff CR3: 0000000050171000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 copy_vma_and_data+0x468/0x790 mm/mremap.c:1215
 move_vma+0x548/0x1780 mm/mremap.c:1282
 mremap_to+0x1b7/0x450 mm/mremap.c:1406
 do_mremap+0xfad/0x1f80 mm/mremap.c:1921
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1977
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0x4c0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d0b8ebe9
Code: ...
RSP: 002b:00007ffe5ea5ee98 EFLAGS: 00000246 ORIG_RAX: 0000000000000019
RAX: ffffffffffffffda RBX: 00007f00d0db5fa0 RCX: 00007f00d0b8ebe9
RDX: 0000000000400000 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007ffe5ea5eef0 R08: 0000200000c00000 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 0000000000000002
R13: 00007f00d0db5fa0 R14: 00007f00d0db5fa0 R15: 0000000000000005
 </TASK>

The underlying issue is that we recurse during the original page table
move, but not during the recovery move.

Fix it by checking for both VMAs and performing the check before the
pmd_none() sanity check.

Add a new helper where we perform+document that check for the PMD and
PUD level.

Thanks to Harry for bisecting.

Reported-by: syzbot+4d9a13f0797c46a29e42@syzkaller.appspotmail.com
Closes: https://lkml.kernel.org/r/689bb893.050a0220.7f033.013a.GAE@google.com
Fixes: 0cef0bb836e ("mm: clear uffd-wp PTE/PMD state on mremap()")
Cc: <stable@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---

Once this is queued, I'll send a patch to perform a
userfaultfd_wp() check, to skip any uffd VMAs that don't mess with uffd-wp.

---
 mm/mremap.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 9afa8cd524f5f..87849af6682a7 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -323,6 +323,25 @@ static inline bool arch_supports_page_table_move(void)
 }
 #endif
 
+static inline bool uffd_supports_page_table_move(struct pagetable_move_control *pmc)
+{
+	/*
+	 * If we are moving a VMA that has uffd-wp registered but with
+	 * remap events disabled (new VMA will not be registered with uffd), we
+	 * need to ensure that the uffd-wp state is cleared from all pgtables.
+	 * This means recursing into lower page tables in move_page_tables().
+	 *
+	 * We might get called with VMAs reversed when recovering from a
+	 * failed page table move. In that case, the
+	 * "old"-but-actually-"originally new" VMA during recovery will not have
+	 * a uffd context. Recursing into lower page tables during the original
+	 * move but not during the recovery move will cause trouble, because we
+	 * run into already-existing page tables. So check both VMAs.
+	 */
+	return !vma_has_uffd_without_event_remap(pmc->old) &&
+	       !vma_has_uffd_without_event_remap(pmc->new);
+}
+
 #ifdef CONFIG_HAVE_MOVE_PMD
 static bool move_normal_pmd(struct pagetable_move_control *pmc,
 			pmd_t *old_pmd, pmd_t *new_pmd)
@@ -335,6 +354,8 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
 	/*
 	 * The destination pmd shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -361,15 +382,6 @@ static bool move_normal_pmd(struct pagetable_move_control *pmc,
 	if (WARN_ON_ONCE(!pmd_none(*new_pmd)))
 		return false;
 
-	/* If this pmd belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
@@ -418,6 +430,8 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 
 	if (!arch_supports_page_table_move())
 		return false;
+	if (!uffd_supports_page_table_move(pmc))
+		return false;
 	/*
 	 * The destination pud shouldn't be established, free_pgtables()
 	 * should have released it.
@@ -425,15 +439,6 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 	if (WARN_ON_ONCE(!pud_none(*new_pud)))
 		return false;
 
-	/* If this pud belongs to a uffd vma with remap events disabled, we need
-	 * to ensure that the uffd-wp state is cleared from all pgtables. This
-	 * means recursing into lower page tables in move_page_tables(), and we
-	 * can reuse the existing code if we simply treat the entry as "not
-	 * moved".
-	 */
-	if (vma_has_uffd_without_event_remap(vma))
-		return false;
-
 	/*
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.

base-commit: dfc0f6373094dd88e1eaf76c44f2ff01b65db851
-- 
2.50.1


