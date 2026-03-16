Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CDDDEFCBBB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D44B6B0149; Mon, 16 Mar 2026 03:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557A96B014B; Mon, 16 Mar 2026 03:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4390B6B014C; Mon, 16 Mar 2026 03:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31A346B0149
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:00:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1CABC36F4
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:00:51 +0000 (UTC)
X-FDA: 84551028702.19.CB5664D
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf09.hostedemail.com (Postfix) with ESMTP id 428FD140017
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:00:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8OO8gRL;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773644450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lj6uVSzjPpo1QsVQpIX9Z8xIGy6J1Sb3UZgbPXec1Go=;
	b=sfVGtkbN6HTjAjiI6L2XJLIKfWl87S8xVAVze1nHb+4N1Z/VDupUuayzDBaHE9eZOETOJz
	JqXH2WeuGMyqix6TQLPNGKdgbl96aXbKcmOyXP5uYnnDJwVyE24XZPU2Khetc4qoYlqTEv
	HUxWmcIkJJOmDPDhdDUmhC4qXOBwFbs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773644450; a=rsa-sha256;
	cv=none;
	b=ufXB89FSr48SFcLW2NqFs6BJVDrKRvB4hare07KEIlDP25T+DqIAiI5dFz3bqa87HnrCoa
	58K0tFK8/7nUTqoGTXk3EDCd4gY8ZsSVieOaPY2ATtMlzM47WAWY4wwLl0nMOl5BmGrn14
	RP0OfhE9gPql8lz8OCTxS4RjVIC//ec=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T8OO8gRL;
	spf=pass (imf09.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2aecefc7503so17157695ad.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:00:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773644449; x=1774249249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lj6uVSzjPpo1QsVQpIX9Z8xIGy6J1Sb3UZgbPXec1Go=;
        b=T8OO8gRLB/4MWRBlxFZs4+2Xoq8dsVtt1CDUf+HXAvwySAWZxaL11nJyEk0198cbYc
         0xWNRUcg0T7coWk5ny2aZWT3UQ+qBxvescnBut6uBa3Nv/B7Rt/ILpyUFvklJDq6JIk8
         FC6mTcChTsNxF9AqPvV9Knum4KriwbcXflIKOtgDQYY20mvIdMTP50mDZ8wXSXaqX/Ok
         QNvo4andOQlBdd35AEtr9cK3ax87LBbJVoBxUpDflumZMueu9NrhoZWGykya3h2LQXOU
         gkpNoc52QB29CqXM3VI+P6cCS2kyHNX2Y6xFIx9pbFgi6xFzwRMVB83072ev/IEgZjqY
         QnuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773644449; x=1774249249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lj6uVSzjPpo1QsVQpIX9Z8xIGy6J1Sb3UZgbPXec1Go=;
        b=q0BiYcUzaQ8oBPUvFfAKg0ehVgJlK9G8X4JIqS0fBfjkjfafWoBe/E6CSXNjS/5d/r
         l9Gx4+LszVsakDoOgzWqlaPvBzpxx1rb4eKak+MyON77x0x+Jj3rXDPUtDbxzr31NJPC
         laGjOH5PjQU6Ii2EbJHaxb9oMq+bbyTf6q455PSXb5oCdewaOJQQudobwZuvPMXfY+iS
         BzW62A6kYbGZJrSLuhLJgbXZPA/1Qzkli7mQ6oXLNYNXteR4j39J8BB0mYyigfMFQuWW
         AEy0E9UtDiDe5ZnTbLwOYqkr57jKcm381TcHkqtEsTdOVW22WFPDhblh+f5wwzT6TNpo
         H/NA==
X-Gm-Message-State: AOJu0YzYsmYFNnG8A99RNsXdDwAs8nGVacvlfzvcGlRJXGpUMQLlB8TR
	GdlGjfPEiwnfLwuSkxXp8YnNfWo9yWeZfhxXBmrl+U1vWvmhmf1O7KvPo3sdnA==
X-Gm-Gg: ATEYQzwrgB7MDrT+iOSfgGSzVv42Ywxoi5Cnwihj5KfLrWiGZbZWQEfrV3cckPOSmC/
	9xWSb0LDA+M8u1cLZFFoqXmdjgTG/kRus0hGleq+2m5D2+M+OUdDgS5ps9ZmS6yXRQEy5dLvDZ/
	Nn4OuutNZrMwrhUFLs8VCnWTkOqQuw8UBNtGoHum96UTMrQv89Udmy/0F3Dpz7CMqWLpdxTRqdA
	ZYby7Ndi6e4mdcz1gK62krg4MoZqCXQQQ2Iq1/bWkEVCCtOlXkXTvW8PIQTl82cKh1H4qi33W0m
	ZCFfvs8HMnFML81dKav3gFsEahHGFbnTcKfMrIeXJRwpmyGQSs9okH4xlIYfkZPWqenwbILidAD
	CYkwtRgHGi+o2vj4nRapUmw5ByOZcJeEd0OIOJOAk3RHIvsHWNJKyU4Wi1BFVnhS0F9pZox0mDN
	/KgTSX7kcacI11d3vkXB24PNKoCok66Uivks+ZfM4srUSBMu6e7GIRx5mUj0oPvaSnbdYF89BRM
	U3ihg==
X-Received: by 2002:a17:903:1ce:b0:2b0:5cb4:d894 with SMTP id d9443c01a7336-2b05cb4d961mr11761005ad.13.1773644448830;
        Mon, 16 Mar 2026 00:00:48 -0700 (PDT)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:5861:3d76:a555:a45])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aece83ded9sm96884865ad.81.2026.03.16.00.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2026 00:00:47 -0700 (PDT)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com,
	Deepanshu Kartikey <Kartikey406@gmail.com>
Subject: [PATCH] mm/userfaultfd: re-validate vma in mfill_atomic() loop under CONFIG_PER_VMA_LOCK
Date: Mon, 16 Mar 2026 12:30:39 +0530
Message-ID: <20260316070039.549506-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 428FD140017
X-Stat-Signature: a8551qm8py857gkxx7x7dtx964jux1tx
X-HE-Tag: 1773644450-432902
X-HE-Meta: U2FsdGVkX1/TTgWrg+04SEhkBjzZCyWav1M2YSlKLQisJsw+b61AYfmc6in9sqEvTeRKTm6YB9m+iHn99K5SLlsnAVGfd6GPuAaDDUyulJQiUQNahdS5rLXU5moRzSYtOG+gP9WqkSWvk+Hvj34kMrHAslUIrbXaJQ1jtG8QE665Pmw6RKQsQ1yg4snibxxPTf1Nj21hKCYMGyjHZ2XmItDB2ajXX6f3liJAzIWq2vtUx5t/QUEbB+9hlRUuM+JGxWsQsJr/EJ4QtxGPZ8T/NQcJClJYtYfyufIfDyYarsakwzk1+BGVHY/EJYmYfZd+PBUUz8FDjg4qWo5jFxiM0QMNqVfOkBn7zRU2LdLWksxuHP8MwoLSUpt5QBM4nMhe4AGnLcNMVlmfHanX8yHR6fCMCGU5cUKJMJ5+E7HVPAIDwSkyrPw6G8nDOIrL2rarAMSl3VLyMbpoYKG28HdX+f7Ki3UiyVElfxETmRBag3rERbCOPyVc7Hx0cTkm6Ggl1E77DCcucQ2k6yl8cuEjIEh5In3H0LN5EHG8wnTxzMrQPy4OHtS2/YSDKnJ3rkFObTA5szQ0SJGAaCkaoPvFVXfhiDHkHFVhOExHmF3ZUgVAMxBE+/2kql4zlll+lUhda1CKoBOa2wGwgfocLwdhw7bRGBqDN2y8IG+46Qm8HkV+R5Wh2H+mXarvVlONOi0r0BrPXGP7ZbabO/PNZ620UcPiBwMO//z1D9go/GMHn5wgMIONfys1nOkwIny54wpeXkZSelhBNjmbqw/Q7LkxKDlBEgElxmnl4NjmjciNDM8vfQgxR66oyyzDAmJxMFkoK8e51NlQ0smovKMCYCiSRuL+tRh03MjHrnrwmK369vGqzWiNkQxqubdCy6OUWluOV5kagu7A+DZt2zb3WDqL2ZEUs7RtN+pVqMVc3Mn9HePNC+S7XRi9/3iFcoCDtD/Cyj8g95oKPN8wGpELRXg
 /3/c1HLH
 xP2Oc5bPn8elxe2aEdX5ApIUVgpuTrWYiWLUV5aY6C8F6dos5pb6NNZUk8ktzW2EgUuHCcl09D4PcjF5cl6aK49gWIX03Dp8r/rlytAMjWkottgXawr+7twfLvdZBjAcRmmLBgbGbyHHrnHEpsZpinfGaUbw8XiybGHBlpj/nX367OAII2F6xkoRT9EMSJHXJVVBe6l48sPkcD/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Under CONFIG_PER_VMA_LOCK, mfill_atomic() holds only a per-VMA read
lock across its page-by-page copy loop. A concurrent UFFDIO_UNREGISTER
can acquire mmap_write_lock() and split the VMA mid-loop via
__split_vma(), which calls vma_start_write() via __vma_enter_locked().

The split happens in the race window between CHECK 1 and vm_refcnt++
in vma_start_read(). During this window vm_refcnt equals the base
attached value, so vma_start_write() sees no readers and proceeds
immediately without waiting, shrinking vma->vm_end in place.

Both seqnum checks in vma_start_read() miss this because after
mmap_write_unlock(), mm_lock_seq is incremented past vm_lock_seq
making them unequal, so a split VMA is returned to mfill_atomic().

On the next iteration, mfill_atomic_install_pte() calls
folio_add_new_anon_rmap() with state.dst_addr >= vma->vm_end,
triggering its sanity check:

  address < vma->vm_start || address + (nr << 12) > vma->vm_end
  WARNING: mm/rmap.c:1682 folio_add_new_anon_rmap+0x5fe/0x14b0

Fix this by checking on each loop iteration whether state.dst_addr
has fallen outside state.vma. If so, release the stale vma, update
dst_start and len to reflect the current position, and re-lookup the
vma via mfill_get_vma().

Reported-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e24a2e34fad0efbac047"
Tested-by: syzbot+e24a2e34fad0efbac047@syzkaller.appspotmail.com
Signed-off-by: Deepanshu Kartikey <Kartikey406@gmail.com>
---
 mm/userfaultfd.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 9ffc80d0a51b..ab73c2106c38 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -910,6 +910,22 @@ static __always_inline ssize_t mfill_atomic(struct userfaultfd_ctx *ctx,
 
 	while (state.src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(state.dst_addr >= dst_start + len);
+	       /*
+		* Under CONFIG_PER_VMA_LOCK, a concurrent UFFDIO_UNREGISTER can
+		* split state.vma while we hold only the per-VMA read lock. The
+		* split shrinks vma->vm_end in place, causing dst_addr to fall
+		* outside the VMA bounds. Re-validate dst_addr on each iteration
+		* and re-lookup the vma if it has been split.
+		*/
+		if (state.dst_addr < state.vma->vm_start ||
+		    state.dst_addr >= state.vma->vm_end) {
+			mfill_put_vma(&state);
+			state.dst_start = state.dst_addr;
+			state.len = dst_start + len - state.dst_addr;
+			err = mfill_get_vma(&state);
+			if (err)
+				break;
+		}
 
 		err = mfill_get_pmd(&state);
 		if (err)
-- 
2.43.0


