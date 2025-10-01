Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E0FCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 15:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718188E000E; Wed,  1 Oct 2025 11:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C8858E0002; Wed,  1 Oct 2025 11:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605688E000E; Wed,  1 Oct 2025 11:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBB78E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 11:00:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C525BC014C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:00:40 +0000 (UTC)
X-FDA: 83949857040.24.8796421
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9BA00140017
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 15:00:37 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759330838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KhdUuAohPnIyC9AoLv+w0q18kwPNVcONyMEj3fjme4U=;
	b=akHa0RoIU0l4f3CnlAjdYro0IX54dUJXmrivSsPH7sRxF4ius6Pvqcq/KDads98qlz9jLG
	BlwiiCDXGfVfHPcHhkIiiiln/+mDYY5/4sNvn2L8uH6JrMGKFeIQGojJZmddhUoEH+lncV
	4XOASVvCxhaOpUb40EdXCMreYKuNjDI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759330838; a=rsa-sha256;
	cv=none;
	b=2SvBtMcVQFRqYg6ufr8vsqd1f07ePncbkjabCsGVkZTijPTC0nYNquyGcTxxRCHJypkPPT
	U2xbLB8YvGhcpVmFFHSn6jfwJ5mAPBrha2LV7IFwwyzpin5bhQC/J74zLlsuuOsri+ssAy
	fednGmcLXqKoSr6Ffv5gsKuKST7AcPw=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4ccJ5G4dFvz5BNRd;
	Wed, 01 Oct 2025 23:00:34 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 591F0NDx015186;
	Wed, 1 Oct 2025 23:00:23 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 1 Oct 2025 23:00:27 +0800 (CST)
Date: Wed, 1 Oct 2025 23:00:27 +0800 (CST)
X-Zmail-TransId: 2af968dd420b417-08211
X-Mailer: Zmail v1.0
Message-ID: <20251001230027125gluddf7-yGz-nXN3gvN6z@zte.com.cn>
In-Reply-To: <202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn>
References: 202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@redhat.com>
Cc: <chengming.zhou@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <tujinjiang@huawei.com>, <shr@devkernel.io>, <xu.xin16@zte.com.cn>,
        <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgMi8yXSBtbS9rc206IGZpeCBleGVjL2ZvcmsgaW5oZXJpdGFuY2Ugc3VwcG9ydCBmb3IgcHJjdGw=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 591F0NDx015186
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Wed, 01 Oct 2025 23:00:34 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68DD4212.000/4ccJ5G4dFvz5BNRd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BA00140017
X-Stat-Signature: e86zkaxnnf4zpuc8ad9qr4rdonoegs5s
X-HE-Tag: 1759330837-838095
X-HE-Meta: U2FsdGVkX19S5KTSYYlysyVj9MC97aIsGz+ObCW5CnFjjWy1MaPC0ljMTlb/KL7HyHyViLnvqsXNwGLbGsY1LCt2NhUPNKm+jN1A7+k0eNDMjwSjeplcOj2zXHquN5PYlCStmYjwkZJ1sjQeenos/bXhHvVHofw9tqE1/8EZr3VW/87eOKOd27yyCrkrhGb3Lop+ksAJ5XKxfXMPv9Xb+ttDHSJYIrr6iwHguryCQ2opmjSj9x7Rs1Tn5lxCI3K+BwaEQVx05+gFfs2zPWFQKwmuJCmfQnM6zShVG7tReNKBhubQv0GEENyKPZ8X8OLrY2EgDnXGZBgk7Krlc/rnZsmdWgQyu9h2JT59D+JRXq9u/EHajfxB1KO/guxgczIjqlqoMEJ+uMUf5ABSVjiyxeuxusQCcPi7TdWLMgXPxuJIHm57NptCylejJ6EWthZEGnlfoomjfCsL32vO65ibd5XTmbBbb6Q3fTRRJe/XURexMugxTd+2G9uhommD4P2qm9EfFN3HjCTny07tClzAJy7W+c3PYhK8yZCxSpxgsyCH2vcjBdvTvUqpA2K3RpSpsb0274viWSpFuC+0IPrrugzUOAuodlL/0DchvOIVDb24jE7FH/bdv/Uz5Tpb827lpqwAxg0advbgaBslJbr9SDfYhvxeTWvU9H5UHpbyf8Blp0+tFSTu4ctO+/qyUuy8tTgI6PORQguMyVdewCc26+l90Pszxu9u7btOBp8UMGvvImiUnRG1bRPspN1wsUdYDv9KRT/1ELncnano4gWulxEOIWO9HHQ3jMH9vX1v4Lyi1WOrbA5o2KwZ3p2Ft7MmsyAabmwLzQaJLQLdGstbvn3SHk6sQw4YBllsQDrbkuEYBxllbcb1uRZg41LPBApTO4xJX11ybkeDwt2e6oBNGL445UpmuqjmWk40YXnhg+9X7fxrqkK/jRLjMxcBN8hXhDQrLj/IzQwqqyS9d/L
 XTRvJreY
 AuV2fziwSg/cHTFseyy8RVRAtgmJfWV/mv+7qHghWBpjgy9KMIA2mcYXzDGbPJ/PD6jNhyVxU6rcQwL+vBnbFYbBpH0Vx4ZGmzuDLCFTCQOzKMSdKP5pUy54W67C+YN2k21QEYnnxRkoI+kr8XPGR2JLbcsMm4JMQqoQ7hievfpLhagFbJE3E1Ttk5mNTPHIewTRe+auKBDVmC2XjPhn4DTaBaozxeQIr+DTGI3kheYBboB94SNdIQ03lcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Background
==========
The commit d7597f59d1d33 ("mm: add new api to enable ksm per process") introduce
MMF_VM_MERGE_ANY for mm->flags, and allow user to set it by prctl() so that the
process's VMAs are forcely scanned by ksmd. Sequently, the commit 3c6f33b7273a
("mm/ksm: support fork/exec for prctl") support inheritsingMMF_VM_MERGE_ANY flag
when a task calls execve(). Lastly, The commit 3a9e567ca45fb
("mm/ksm: fix ksm exec support for prctl") fixed the issue that ksmd doesn't scan
the mm_struct with MMF_VM_MERGE_ANY by adding the mm_slot to ksm_mm_head
in __bprm_mm_init().

Problem
=======
In some extreme scenarios, however, this inheritance of MMF_VM_MERGE_ANY during
exec/fork can fail. For example, when the scanning frequency of ksmd is tuned
extremely high, a process carrying MMF_VM_MERGE_ANY may still fail to pass it to
the newly exec'd process. This happens because ksm_execve() is executed too early
in the do_execve flow (prematurely adding the new mm_struct to the ksm_mm_slot list).

As a result, before do_execve completes, ksmd may have already performed a scan and
found that this new mm_struct has no VM_MERGEABLE VMAs, thus clearing its
MMF_VM_MERGE_ANY flag. Consequently, when the new program executes, the flag
MMF_VM_MERGE_ANY inheritance fails!

Reproduce
========
Prepare ksm-utils in the prerequisite PATCH, and simply do as follows

echo 1 > /sys/kernel/mm/ksm/run;
echo 2000 > /sys/kernel/mm/ksm/pages_to_scan;
echo 0 > /sys/kernel/mm/ksm/sleep_millisecs;
ksm-set -s on [NEW_PROGRAM_BIN] &
ksm-get -a -e

you can see like this:
Pid         Comm                Merging_pages  Ksm_zero_pages    Ksm_profit     Ksm_mergeable     Ksm_merge_any
206         NEW_PROGRAM_BIN     7680           0                 30965760       yes               no

Note:
If the first time don't reproduce the issue, pkill NEW_PROGRAM_BIN and try run it
again. Usually, we can reproduce it in 5 times.

Root reason
===========
The commit d7597f59d1d33 ("mm: add new api to enable ksm per process") clear the
flag MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs.

Solution
========
Remove the action of clearing MMF_VM_MERGE_ANY when ksmd found no VM_MERGEABLE VMAs.
because perhaps their mm_struct has just been added to ksm_mm_slot list, and its
process has not yet officially started running or has not yet performed mmap/brk to
allocate anonymous VMAS.

Fixes: 3c6f33b7273a ("mm/ksm: support fork/exec for prctl")
Fixes: d7597f59d1d3 ("mm: add new api to enable ksm per process")
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
Cc: stable@vger.kernel.org
Cc: Stefan Roesch <shr@devkernel.io>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Wang Yaxin <wang.yaxin@zte.com.cn>
---
 mm/ksm.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 04019a15b25d..17c7ed7df700 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2617,8 +2617,14 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		spin_unlock(&ksm_mmlist_lock);

 		mm_slot_free(mm_slot_cache, mm_slot);
+		/*
+		 * Only clear MMF_VM_MERGEABLE. We must not clear
+		 * MMF_VM_MERGE_ANY, because for those MMF_VM_MERGE_ANY process,
+		 * perhaps their mm_struct has just been added to ksm_mm_slot
+		 * list, and its process has not yet officially started running
+		 * or has not yet performed mmap/brk to allocate anonymous VMAS.
+		 */
 		mm_flags_clear(MMF_VM_MERGEABLE, mm);
-		mm_flags_clear(MMF_VM_MERGE_ANY, mm);
 		mmap_read_unlock(mm);
 		mmdrop(mm);
 	} else {
-- 
2.25.

