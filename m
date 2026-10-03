Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9A0BCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 10:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45526B008C; Sat,  3 Oct 2026 06:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCF9E6B0092; Sat,  3 Oct 2026 06:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B96F66B0093; Sat,  3 Oct 2026 06:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 908926B008C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 06:30:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1428D1C3CE1
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:42 +0000 (UTC)
X-FDA: 85280946324.29.2A3F97F
Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 43699140005
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:30:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b4LNFqrq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791023440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4OIv8n/HT65OVykH/XmjfYmij9l4kWjigrp7qJ7DUYA=;
	b=57vYjyLM1VA7Hv744uMamv38ltzCaWxbpoxs+8qLP69vtofNuQ9RZm9pPri2TNVxazsO3/
	X7mpyusStaf9cENlgQBIPjx3u4aCco82I5EjgiHAuRE7kHoAMvjK++btAFxGP4SZo2RPoe
	zA+p8m6kNzvt+ehVHm3kCZlEapGL10Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b4LNFqrq;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of donggeunyoo.kernel@gmail.com designates 74.125.227.171 as permitted sender) smtp.mailfrom=donggeunyoo.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791023440;
	b=2gvQ5W0EPuw9Hhl0a3QeXkDydpABzY0gAoloknutygr0Hssaqq7ecBTxe+5Wg6fZitwcwD
	eMPq5A5lfo1z8PpNbT3EpynFuzq+v6aD7fMg+1t8aRDs+uhynwRSxZ1CDWPtNbT6PKEpqC
	yGxSpuxznlyPKUsqexEJHfFSNtNULOo=
Received: by mail-pj2-f43.google.com with SMTP id 98e67ed59e1d1-396ccb1a98fso201409a91.1
        for <linux-mm@kvack.org>; Sat, 03 Oct 2026 03:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791023439; x=1791628239; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4OIv8n/HT65OVykH/XmjfYmij9l4kWjigrp7qJ7DUYA=;
        b=b4LNFqrqg9O1ymEkGlZCkIah7oIAhY2Ob7hWk/Kl/ouVWZ6QmGHFR6SoXazuVGhptB
         QR1j9AW7OyHJw0DBiCgQdD9xBVwcTxBPc4qfM2N0Lso6ge+KT6cHnWA2ZqLiFZ9dYMjX
         yLzcY7a87hVd8WsRQ1rKR9BdTAso4DW5TKzpJlrlO2g0ePEBI1MwivIekHYNlJNAwIZl
         pf6Kpc6LHFHo0jEz+lEzT9/yzUzwdsN1xaROW0RcKK8PwAmoULXu8KfdHByvJIIXRvjQ
         dozvPXEeQF1GuKqj00l0VMsgZpZ/vUlVW9Z0WITiJvW9enyD+QRex5YLYs8s8/iFYK1W
         0bOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791023439; x=1791628239;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4OIv8n/HT65OVykH/XmjfYmij9l4kWjigrp7qJ7DUYA=;
        b=i+wxSHCSRpVIjCN60R1ikeIDyXl9NhioTArL09IJITM9MkO+XjzzDI8hyeMvpIEIAI
         RuFKEP3w0XB1mz4WQ/y/yBELbkkkvGMbVHuwkeHf2BHF4NqzsHZGAJkKluabZ+vE1pu1
         hwQacXnML7DooGgEuePi0/yAflcAeqFB0oKPjKf7DROlF9p/U/PUOB3LR1nWCt4AVwuh
         8F3k2SppYsAk/apqjfn9J0lXc/76cn+ikgrki/570Eby5I+sRM3staTtPyTJNnoSYs3g
         2m+E1NV/3OOqKSPjIIhI2VWBiziDC3CW07QwRj9N39Tv4IIt2JYOJX9ddtAYqSxcnV9X
         uyBw==
X-Forwarded-Encrypted: i=1; AKwUvBwAH6EQ+sEKOCWy/xiWfPd7EeaKZu+PQiMCPHctwR3TqxFAJ9z6tES0ilnz8V7oYVBirFio6uBhkA==@kvack.org
X-Gm-Message-State: AFq9FYKk708VapBoNZYhKJEaows5MufEOUs/H1uS1vgxgHnQy6PI7AKz
	syctGsLlp6PwaPMAU8K0GUpsvi0J2OxWj7lqqtTu8J50MckMZd87/mQ=
X-Gm-Gg: AYBFou2Q8+MNIA2hXJZm5Gea17Ioq2h+D6S9RmLqtof+Dvgyv1RxsIp76EhUag+KnOr
	+FLy7+sS/kJ9lMUPG4GQcBoAnHg7yA20+uqR/tFE9/EXqPahDE0XzsWQ3vrY8j3JZiIt833R7bt
	2lyPj+Hv6K/phkndYgOGDUt/FKf1mu5zcQiJGkKVHhKqsJHKQAl6J+NPl/Uw35jX6PSLgmszj7J
	AcfZfg61jOXiZ3wRtDvaRzkBRQn2p1WRFYB+hDhloFMqSOrJ752p8Oc0PD4GKff2mpILvzzUWB9
	WkkYl0Sbr1XGwvi+8v2GgIGjFvRNeWdNVvSTpOmNczJq9ukXVvlb/J/hHlE3LBh0gVgiWdYYAzU
	e5q/Lpt1IdwJ896kOIL70OFro9XwrmMCpcTkBYvmOmrJR9KIrGAZvfVlSi3iRdFNeofkI7m10uR
	U9PFMYyN644CL1GpLMAHGzUHLKVOnbF5iOoF1gYY7t2F4kTNkBY1R5OMxPiaVSDApIAi02cDjeC
	M9dPvk1scdhZMgLBGHXN4l/jw==
X-Received: by 2002:a17:90a:fc47:b0:39e:6a80:b795 with SMTP id 98e67ed59e1d1-3a6cec9b170mr4991753a91.37.1791023438924;
        Sat, 03 Oct 2026 03:30:38 -0700 (PDT)
Received: from ydg-Zenbook-14-UM3406GA ([211.230.25.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a709a4e80bsm2121961a91.4.2026.10.03.03.30.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2026 03:30:38 -0700 (PDT)
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org
Cc: peterx@redhat.com,
	surenb@google.com,
	aarcange@redhat.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	mhocko@suse.com,
	shuah@kernel.org,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	donggeunyoo.kernel@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH v4 1/2] userfaultfd: clear the inherited uffd bit in move_swap_pte()
Date: Sat,  3 Oct 2026 19:30:29 +0900
Message-ID: <20261003103030.63380-2-donggeunyoo.kernel@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
References: <20261003103030.63380-1-donggeunyoo.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kjha1aq39pwb78e7wdfbcqgi6au6jene
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43699140005
X-HE-Tag: 1791023440-586604
X-HE-Meta: U2FsdGVkX19h6UkRIAnFPCBSbHVfYYnq7J0dUTughdAW2XETf3udrbA8o5Y5eioq/grzwQcOEOldd8o+jJaSlVhc9sTHZYiquqANl8WmHPDZB0sh83mNHemTJznHGlLaxB2nXL68QCwsQ3bUFPTQZdjboJb4lCVmPmM2QD7UaR0LSOU/fjCn/HblMbb5HIUHCsFZM78xXCctCy2tdxMafyT4btSps3A8DRYYGymNNWSI+PTlhhokG40vK2293RO2H+kb+DVMs/5Kq5TY/fSZQzepHAP7uRm93rg+Fu9h3etLgqwUdypVdjBPOeX3nNtmFQA/hZGymYgX5hW/rKWEFr8Awv65xcntzqS2bELlfERwSGNALWZsg70AR0cxSIP3Ky4JmJI0ObkfLo0ivy+VhgF3BN/nggVJZG5X8u+rsG6RHnbEDzBDWpKzJ2BwA56PviL94TINF/CH845t5w9T1xUDSPzGPf7hgcgfHt8nWmvMErzdYUvitYF7QNEsMOg2KRR/uEAq6cpiGWXukkLBh6VfzaWtmY9tCoMbjiu+W6R0XujovTBPiA6bSXq3BiHg/irxhwZUt8mnIBPh6YeeDrotfGZ0heX9YEemnj2Ag+oG+akhRdX5QeCDnwNjfoB8agWADpAwM+up030r2NE+/hqJNs0/aFcCAbJCsGYrUtS0D5LAUd46e/J2jTzKsmBanjGgRbaaEvFC0moTTIU3+Fsups1hR61PDRaN/UMMkB/7uI+YXihHVuR/7p3WW95NhBlY/6WkaYaNRVNuJjpJVgN3EnuPfaK/CeLEqUzlu1EhSJ0i66JunlEBvk7fVFKXNoJlXwTrSBN0CGMkjrlyXw9Pz8eU/3N834lJQEgjA90wChhlXlRv53iCcQtikBiCg06x32qi68X3cOQP0mhFp4qTiXr8JgzK3K2FnIhL8pnHsxof7Rnx5uK3rAl7MvkwCMDviGm5WzvNBr6owkk
 wvGUYeJ5
 adjhZFamGOKvHyHhDEvMVdRnVxviWs/JeQrKKjIWSKENXDHVJQYFq44W5WOc0FVWD2nh0h5vaF3BW9tdNOvdVssC4SuXRO0NDL5JLXpFzqgUxZfktD6T3vf/0dg2PA1UGiqBb/FmM01qsEam7kerzE2EXumINqSanWRK/wHwz9OYpz58IMkz29tx66uNm795Fc4FMK5LNjemYsHSbhvhJbcQGmhBFYKURhX2LAyLtfUId9STxzxNnb2VDrVCvPA5V7TEOVIMftpKEkbtt1SHqG7GK+uUrEKLxYCYob9jlGhoY9IkKan1yd6To5DcuV/uc4qjj/57VY3v/xmyDnpr+ZKaa+1xXNpQNJkxq8QGrpf5OEz3OyGjXovhUXSTk5SZy29+LkAwsmcU5Hp08HSvnTW5rh1FPuI78SUJ6gjqdu+nTdFsDGlC0X+C1blxNSEmrveMukoo1mdltHWM8To3S3c5twXqnmO1DI//VeOnbw3jNncPDCICtqWiQ5bOd/ppETnNwUSgZfTJpV6koS0q5Weuc8FDGcUtCia28MuqOtyAIbP8CGCR8lGYOhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

UFFDIO_MOVE on a swapped-out page installs the source PTE at the
destination unchanged, so a uffd bit set on a write-protected or
RWP-protected source lands in a destination VMA that was never
registered for either.  Nothing clears it there, and userspace sees:

 - /proc/<pid>/pagemap reports the page as uffd-tracked (bit 57), both
   while it is swapped out and after it is faulted back in.
 - MADV_COLLAPSE fails with EINVAL on a range containing it, because the
   collapse scan bails on a swap entry with the uffd bit set.
 - With CONFIG_PAGE_TABLE_CHECK, faulting the page in warns.
   do_swap_page() carries the bit into the present PTE and, since the
   destination isn't WP-registered, also makes it writable:

   WARNING: mm/page_table_check.c:202 at __page_table_check_ptes_set+0x185/0x1e0
   Call Trace:
    set_ptes+0x67/0xc0
    do_swap_page+0x990/0xfe0
    __handle_mm_fault+0x7d0/0xeb0
    handle_mm_fault+0x9c/0x250
    do_user_addr_fault+0x207/0x650
    exc_page_fault+0x65/0x150
    asm_exc_page_fault+0x26/0x30

Reaching it takes UFFDIO_MOVE out of a WP- or RWP-protected area into
one that isn't, on a page that is swapped out at the time.  It hasn't
been seen in practice.

A resident page doesn't carry the bit, because move_present_ptes() builds
the destination PTE from dst_vma->vm_page_prot.  Clear it on the moved
swap entry as well, then re-arm it if the destination is RWP-registered.

The WP case has been there since v6.8, where UFFDIO_MOVE was added.

Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Cc: <stable@vger.kernel.org>
Assisted-by: LLM
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/userfaultfd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 74f04c323c50f..f39f109f17989 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1449,6 +1449,7 @@ static int move_swap_pte(struct mm_struct *mm, struct vm_area_struct *dst_vma,
 	orig_src_pte = ptep_get_and_clear(mm, src_addr, src_pte);
 	if (pgtable_supports_soft_dirty())
 		orig_src_pte = pte_swp_mksoft_dirty(orig_src_pte);
+	orig_src_pte = pte_swp_clear_uffd(orig_src_pte);
 	/* Re-arm RWP on the moved swap entry if dst_vma is RWP-registered. */
 	if (userfaultfd_rwp(dst_vma))
 		orig_src_pte = pte_swp_mkuffd(orig_src_pte);
-- 
2.53.0


