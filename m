Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58832CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:26:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BE936B02BD; Mon,  1 Jun 2026 04:26:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F3B6B02BF; Mon,  1 Jun 2026 04:26:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 685B56B02C0; Mon,  1 Jun 2026 04:26:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 599C56B02BD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:26:20 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D812F402FD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:26:19 +0000 (UTC)
X-FDA: 84830661678.03.EEBD2B4
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1D4E620002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:26:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+PulnvL;
	spf=pass (imf31.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302378; a=rsa-sha256;
	cv=none;
	b=4LLHY9XSS+4xkzyMjp9hUdinpY6BWxztJ5FRp4BvXsneTce1YqwoEsiz5mCu5PigtlYD1S
	G/DuEMmWXeqjjmC89AQvwLSB4k76dIOaeazxPNyITD1wO3KzcFXJvw1OIl0U71+4ra0G8t
	VKD7PEWn+l2CU0PqrKhi71SNzrHuqwg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=O+PulnvL;
	spf=pass (imf31.hostedemail.com: domain of jianhuizzzzz@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=jianhuizzzzz@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gMscR4W75exckednokoUCQabBPtmF32JAczc6W4udsk=;
	b=OCQXWkW3cKOiLfQsl/U+784Eh9opHjK5Gje6VuaGihv8CT/MQL6NCBMqM9GdIQteMaQuUq
	7adJzI2LO2YSqYtTH8jRfcQMDazZrVdIE/wyLf0xcVnALE9EfUDC09IzG3o8rDR/ZZwr3E
	ONncJzm7u0Gi6RxMs77e5Tj7Yt4qIu4=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-842288702fbso578813b3a.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 01:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780302377; x=1780907177; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gMscR4W75exckednokoUCQabBPtmF32JAczc6W4udsk=;
        b=O+PulnvLrGCWwLL2LvRU85udeIay2ZDMnU+d7OtLAYCH1daShozxjfeGJ5yMVGM0Ay
         hQIWUOEQwryQhFzglOVexXmgKxi6IEReHhoDvnikIYrDY4dOp4XTy9uFLhgMm9Lccbmy
         vzeRENhckELGUpptm7Cwg6Nsu3RJ2ijz/ZXvZcPQrFA3WLtbSJwb3MpVyJt8lHcRAlFs
         3WLtaINd4co4B6F7bcnhI79fHKk/Agb0CYwLtzOHlKOep/g7B4TvNomHZNBmg1EPRsTd
         zWIgv4PRdVpWagN0F+tw0cRP9em6cJKMH2Q5BGWpCSUxarx9mWdRnBp9AXVhqs3Hkq0u
         uuMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780302377; x=1780907177;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gMscR4W75exckednokoUCQabBPtmF32JAczc6W4udsk=;
        b=bWRGNvyLB+XSe5Qo5mZfxVnqrF6Y71PgniPkt8lhY6QOs4p6hGvssdEyR+VzfKu2Pa
         uyVnt21+uXF7QuumkueFpTX2yOGvxyb7ajJABR19q8LqX6vxbFwxLswva5PuqTe/YGba
         N/VcZyp0082uXXey+r0aBwGN+Zjt9/vJE1s4MifpeiYmE6E2jOgWOnWuul31D2MY6YoF
         w3NFbynBGV+jyggwqGZW+EJqGMpbMn7XGQ05/oVNdazS5+i27Ni3HhdAtwDRcb3mdz9Z
         I+Jn8imYkT/+s4oIGTgpXVjhLdQUD85CK2DDWsIhlDIjPMT21ECGcRlqSeZ3mxruj6qE
         I/iw==
X-Forwarded-Encrypted: i=1; AFNElJ+i5ILJI+ZguqzONaUHPYBweDlW83gk+31vGpgHwOGIPG+velfwl6T/U3fJ9RJqOg31CjWQsP6RZg==@kvack.org
X-Gm-Message-State: AOJu0YwpktpbO3ISy0V3bosyGHpjq6Po6cR7kc8uJaW0Sc/jd5KP5btF
	lOqxhiPtONZT1YfMu6ss+o9woqYfZc8x/vakBVOoVgsHHkt0eLDn74Wd
X-Gm-Gg: Acq92OGIwoCEu20P1jk2C74xsVTbVEnNzkqYvRsA7ME0Zz/70Ao216InQbO5aEonXNs
	kReVLIaaqssRUp8veNU4io/QKnqR2NwzCq+j9Ki1zw3AioKYZVDSaVcl6bmc95aML0LXBYALVG6
	C6xCc3eoZhCYiid+HrjBrWL27yy+Al7MLyipXxDIXD/OyWyeUqEirp4lOIp34vxxNGjne91NhFe
	ob6iQaArS2aReZuf/EXixpNWr2Nbj0iMQLN14EqFIzGSFCMUD/MdadyZFukneblHZgY0JKgRFIc
	La2/l60bhjEG+8C3JTlJWY8Ce82hLiriw5xPF+yOjBWnpAkVbSpCcmWIpuZhjOTER10uXVvmfKj
	lmZQMSCvR01Ko/LoMdDmnEVBl7oWPlJNpc8NTuVp+GUcZfDXqYN804R8ZhCUJgEnE2E9QPAvdoR
	/idqrjqKKy8954Sx6m/07h4jvZ0RG6poFwduxYKKfjPpYkZIuLJSsShWNjJA==
X-Received: by 2002:a05:6a00:2987:b0:82f:4191:da10 with SMTP id d2e1a72fcca58-84225385e77mr8973517b3a.6.1780302376382;
        Mon, 01 Jun 2026 01:26:16 -0700 (PDT)
Received: from zjh-os.zhaoxin.com ([104.249.174.136])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84214d018fcsm9030049b3a.60.2026.06.01.01.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 01:26:16 -0700 (PDT)
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	linux-mm@kvack.org
Cc: peterx@redhat.com,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com,
	Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: [PATCH] mm/userfaultfd: clear uffd-wp PTE state when re-registering without WP
Date: Mon,  1 Jun 2026 16:26:09 +0800
Message-ID: <20260601082609.170076-1-jianhuizzzzz@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D4E620002
X-Rspamd-Server: rspam03
X-Stat-Signature: 7budtwcwwbbdwezttd4wu5rykhxe5ui7
X-HE-Tag: 1780302377-574562
X-HE-Meta: U2FsdGVkX188wlqF9IclAyjrc1IduDUvWZ9dHuqYK0sJ1elyb6vgE4NVWUH1OaYrmXkXuk0Z2u7zFc8w/RMLdgTnDLt1lLLFJNXbCFO5D6CrhZt3765RxWPnlUl8ckBLR8SzhJAfb6QsnFyOkmjdhiWvvIingE6KeaeWXjUOXAhq0WSwzCsNSLXaVHzQ1UC41u0w3VSTU52z3hxsVK5bOPRXakaIX5A6v4XlzcHj4abalHGGRoHq/ea/N2UYJstSWaro3XSjlQyXPnjKXzgr6ywLEdOFoun8DRBRZVO7qwGkwN6eQHBJR7Fjq4/drhx5qQcJ9s7GR9QdqH/apeDGFrCxzw5cCNbM57Efjloskys4WkJZBXq7No1fsoRl1esFKoLs4+Fyp+Fz7jxDM4JhYVGBgQ2SVJRPjnfgupColRyIkeA96e0q4gMV3RmfOC4gcTQK89BJ1OghbU8iAEj7DfPsI5N8rTlvZWo+dTSsYAFU5H4JlkQ+X7Ne2kcPG+pJ4cRVtwrX7DKQ2UAbR6DNH/qQUtIBenmuqJ3WRiBZ9HdRd2KPjWsRVDpQrqz0f5FZ27s/pdzD4IvbtEx1DOMp8KHAa1RLgA5Gzwe+bgTGeUtKKz0NadvySnk92ZrqF5NbqnWpTXkup5wFjLJUlPnJNR0ovQXZwhUAmmPBAbwaL5CuH3EMNbTvKP8/vZA13/DwfGtLheYYhaPSyiK1Pmqq15xwgMsFZPcM0fHCJ4V3JJln8W6GgGRAVhhRQXAgNEVEcdkRHCBjkoFLc7X+2JGhdnyAWyNDcPVCZcGLN52mB55j+Bx6RuJk/kdnGkbWhrdLdCaJKz5rHj8Gqb0ENq7xlSiCB5z+qpMwnTeoSfB1BQJjslS9n5cIGZ2ntgKvd/2cyzLfCLEpZKBYxQTl7d9KuHAxeZtP/my0cGE5xvPUwFrHfiCVNWt+CxFyH8/QmaWh7d79BZUMTyT+Vy91bG+
 U3JMwI/L
 18v6oxlaBwFZIY7kMGbrxMKUYjYxb5pJkcTmPGgdY+PhebmxuvCosq+2tyvCqk0OIbJ/amFM/9JRQ4RG0rZXEatvbs+HkLyq7gupqICbDVsMD1waXY1FRTZa6UkGncQB2dQsaq1imb5KHaNljvb3tL1+Qe7lQVamHB//Dniiu4q9pIGqUe6QCPCPGNIinCczqk7B3FZE1dapPNSxJZ/GyCT1+gIRk6txFwsJfcvGwQ7oW3jj///nG8ziTEpCD9fJIZXSqwUrrCUjxuKJ2RKjU5+mGjQLlZB4Da9BqhqsDq9ErQq0Y6xmqnS64EhQTnTnvraE17ToHFAzh2TjdW0iReW7KXYtqlJsWu/JUgUBjkCnV9K3MJ8QJHnV0Ao9AQw7pIZnf/oBfpxJVwN2A1DqI5ZJsgUffhGd9OtAWAEICL66i/nMAUT/h7C5gLLHmlUIyE721NyEBX5Fs8VOJ0mOzWipjlteu/5YBh3HzXUqMLHasTBJacQO+bKr3x7zjhY3EwuiaUxyN5NAY8WEWR3vp9flcSdVxu+t8MXedUUHUHD9q0W5s1mw1WqKkl2Rhmhm49SSDdXZFWd0WiY3UyKs6QLafl6Ajr4h3sFB0PGX3P7u94Un2adx05vBCLzf5Vl/MSZnGN6ura8zT+5kGJrHNCT4UMEarTFSqMiu24wqE889FwOOO1zPYYdW8Z48QsrKo5bVPwsBHwK1uG/N1PQNNQ6pTOGCAmp3b7xsffk1IopZc6sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_REGISTER can be issued on a range that is already registered in
the same userfaultfd context, replacing the VMA's userfaultfd tracking
mode.  For example, a range can be registered with
UFFDIO_REGISTER_MODE_WP and later re-registered with
UFFDIO_REGISTER_MODE_MISSING.

When the second registration removes VM_UFFD_WP, the VMA flags are
updated but existing uffd-wp state in page-table entries is left behind.
That stale state can survive in swap PTEs.  On swapin, do_swap_page()
restores _PAGE_UFFD_WP from the swap PTE and can then install a writable
PTE, triggering page_table_check:

  pte_uffd_wp(pte) && pte_write(pte)

Handle removal of WP mode through UFFDIO_REGISTER the same way as
UFFDIO_UNREGISTER: resolve the per-PTE uffd-wp state before dropping
VM_UFFD_WP from the VMA.

Also make the same-context fast path require an exact UFFD mode match.
The old subset check treats MISSING|WP -> MISSING as a no-op, even though
WP mode is being removed.

Fixes: f45ec5ff16a7 ("userfaultfd: wp: support swap and page migration")
Reported-by: syzbot+18d274a59b87cf80e86d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=18d274a59b87cf80e86d
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
---
 mm/userfaultfd.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 180bad42fc79..dc0b3eba768b 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2153,13 +2153,21 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		 * userfaultfd and with the right tracking mode too.
 		 */
 		if (vma->vm_userfaultfd_ctx.ctx == ctx &&
-		    vma_test_all_mask(vma, vma_flags))
+		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
 			goto skip;
 
 		if (vma->vm_start > start)
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
 
+		/*
+		 * Re-registering into the same userfaultfd can remove WP mode.
+		 * Clear any per-PTE uffd-wp state before dropping VM_UFFD_WP,
+		 * matching the UFFDIO_UNREGISTER cleanup semantics.
+		 */
+		if (userfaultfd_wp(vma) && !(vm_flags & VM_UFFD_WP))
+			uffd_wp_range(vma, start, vma_end - start, false);
+
 		new_vma_flags = vma->flags;
 		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
 		vma_flags_set_mask(&new_vma_flags, vma_flags);

base-commit: e43ffb69e0438cddd72aaa30898b4dc446f664f8
-- 
2.43.0


