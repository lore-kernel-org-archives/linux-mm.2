Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A723BC43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 971DA6B00BE; Tue, 30 Jun 2026 11:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922A16B00BF; Tue, 30 Jun 2026 11:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB666B00C3; Tue, 30 Jun 2026 11:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0F56B00BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:05:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D3E5A1C35E2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:01 +0000 (UTC)
X-FDA: 84936901602.12.6E3EC8F
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D6E0140008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DJJJvDjA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831900;
	b=cb70cvIpInPjV63ZTbBLIZOJ5frL4QZ6xMbeiccfY/e8zFOOuUgBO5ibppYAjDax8rhubw
	ZM+NPmKf3M5Ds5ZSby/42LR5m0eU4Nixt88q3fmiL6q5pvpkRq9MpObWhXA4/+SmA9fEBp
	EZQjjVDEDNJtLwNc3YE9TNacCXEXfTo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
	b=xeONwrO7WxVOFuUJGyrb6AqvVok+gtStgpmlyPXLUrml2m1UMrT4wfXiZrnlnye5QvtLSS
	4s8WbUYLwXR70LDZehaaAQFSkJAVLfAIJq2wvaPvKZ+0OFuWIavlwg4L9bxacW3F+vhXk+
	XAE813QjnkApKJfEW9qvkIHz9AxU71o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DJJJvDjA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c9d87b1f9eso17335285ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831899; x=1783436699; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
        b=DJJJvDjAzh3Ihom1iV6IHKcntI2N9IWrqkavlnrroyvc4W3zspXUjK7L475phpnloW
         LULa3z7OZV33FKGrJfFYG3XhQlxGR0WB/D0GP+mwNxuiXOfncTmk/QX1lgK0M7FvA6fc
         i3eJTS6Z21n0iNWuRW2MpfgxGeHT57tHcyeOm5EzOc6j8OufD476L7z6ZZ2X3v8fTmi/
         235p6qC5AGoQdu+GB9GphaE7Tw5SM+G5Y+bfK6DsOLrusUOgcpBHrA0XCfLWCs4OO2lJ
         ULF1UYLyv2wxSseiFFvteInPAF3+Qa5NrvE+SIwwPPnGA7cvoCcARVGN3zjQFQPI1fxt
         +uSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831899; x=1783436699;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PPX10qsMY++ER8afXSJu3F27jyGSgCeFMlyZg3pCc1s=;
        b=OFVmf7wc73gJ/RkM28RO9sjDmREDtVXegaZB41jVTAcPlbvaXuyKb1cvQT3otqYacP
         HLf3b/KxlQm4Eo8bJR4g/EVT9B4cpat2/MH7ZnPyzWVwfhQ2VXFA3iRKE1H+oHmgWO7e
         Sh6yMOi9wka3of2mdF86STMdq453WXjTH+6VG+Xw6uKMDWu7Lu4VclJGAHMNOir1sCay
         a900wN6GHibZx0nfTDwhfjGy/scLgYRuWrYr9OrCx0hqVY/XW8CQ5/rNXmo9bJQ6MROD
         n/dp2VqkVORD/IizQhPZ8eqjMr/T6QJXq7q+PaeHUNCS5rMjQZBLk0NDjiPyo5plRGu2
         ZMDA==
X-Gm-Message-State: AOJu0YysMYNmKYBl9niWEpoFMo9LvxYsLHdS/oOxLRtfc4nhbyjfAtlf
	zFN0w7eUcOtVaV+1EHkzyBRttaEqSg6wCJMwdLyIAztt/Ln6xLXkeKdt
X-Gm-Gg: AfdE7ckp9WwD3Vr0oFX88BePouItBs9qxOA9P1KsmYrgoWW7Dj4Ltwk21QBhW8R5HXC
	nT3AN8IdrO11zBIbWpzcWjW9kbpqsmu4qbhnlZKRZhVz+r4valo6bitfJtWjO2VAG4WXsY2VR9S
	4aG2oEuksSSwJkvdnM2gwrverjCXcOHCBUv5SLtW4qHeTh2TZSF3HlzQPe1vlmRB6Yqeif+IqHe
	h/I+YArLpWkl7iRp2KjGtM4XTaBWwLhH2ASy03f3tKnx58mNJGhpC47HULVlEKi1dsMTqYSDfP6
	RLrmkUHo+9wGJfhVjqPa6B4zxqmuCVx96aSkpHykP3BR1ThC/kuUM2oIj8nJZEEk8Qbr6j1MXJp
	h3G4yd4GrfcGLV2t01yVrflih56BpTN+OasDWrETVnEdVr7CcWD7xGkzW42EqkXI35uqVCy4IgQ
	7PLUeZLHk=
X-Received: by 2002:a17:903:b4e:b0:2ca:5d24:720b with SMTP id d9443c01a7336-2ca5d247390mr6710495ad.39.1782831898986;
        Tue, 30 Jun 2026 08:04:58 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:58 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	Nicholas Piggin <npiggin@gmail.com>
Subject: [PATCH v3 6/8] powerpc64/kasan: Remove unreachable invalid range check in kasan_init_phys_region()
Date: Wed,  1 Jul 2026 00:04:11 +0900
Message-ID: <20260630150413.1718632-7-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D6E0140008
X-Rspam-User: 
X-Stat-Signature: i5twzdnjdi5os9tf5xbnjoi8ku88nit6
X-HE-Tag: 1782831899-880134
X-HE-Meta: U2FsdGVkX18E3Iecpg9wq16dizuGkWshl0djt/9HpgKKw7igvDSHOqtsaFGrLnHUDobdxwEoHSwlBb206mB5iZCtXz3mnGRjvheFO+vLT3+cN7EChJFuVH0zcKlZ844Zie/y0Xt01U/QInXkr4wQJ/urvG4jIZPA0LsO3HBlDucV6QWKWxbHjFIkae3hkZZhz/Z8xnhHiHroT6By7iogljXiDO1af7FOfSXmr00D+B6tvvqTMMa2+U2iW1W1vPPqz/+NTsfxKrJdUeT7gBsDLZ5qxoT/CpCEfurS9P7Y0Y2OFGO7I0LhgaTlQ8o0Zjjlyr7xKoE43TUuqYiVYT9rsvJtYiWfxDFNQosLlH37+M5/Iq6b+Lzk5H5CvSlWhjrFOJdIRjao+Uj77qa1SRkSoTWymRlH7j7xruVKqRYtg0Pfww/48raS6XDLF3mJKZ1fMqp96UdyO5gveS9MkhKZ/YKM163+PHNum9Pb05vYH4ADyl6Oqk+SRBAFeTBHq6vkpSqwp7QyKxZ0WyaWL74RootORZRjJHqrpogRE3H2M0mUzxEt7emqbAFugtRsaERFt1BKDqRUa7fop4g9qoHdy8wc00P/735gjHL2J5xJQ5R0WemMF/jSFpr8K/4U6M1XITu4U2D3W8aclxTZV9fXQO0lyJYLZN0Q+wSEQH2Nu47soCZVHCiHSh/kcqmhr9umZ58Yyjqsy3VMjywaGf5ye47gG/AwoCuXgOURa7cOt9ZsT9xsanOnyCUc5UmtaL+3SoP5hbrGoJkD0Sv1pfxu0gF+UOE4nZdq+eEmaNxjBlXo3Z5QhE93hJUFY6J75adg2jCBwE5oDD8uDwI7by9xlzrVHovDUDXJYHoNvVMfoOZqt+Fik+3qVQEPjrzOJijH5VIv0ual8obXL+kGuwXZy+O/l9EN+A3+mkVDgiYEmZic9OGHb7YG4HzcKCWkDvXiKokBX7dNf6Sd09TdKA7
 ZoBfUVWF
 0G3Ep2UD3jJ6jZ9o/VGWD1KTtRz95z+dGstzWKa2KWBFazxFqQub3hCVrK+kcYgKi+HyNVHzNM2eI1S7mTXIhNgpa6yt/ECdMi33NYZpbiYQffjrVpgI1uguqcopsI5S0x/YXTU8R6g71R9Xe6TsRCBKjPQW8kgIh3UsUo8Wxlz1IAYwrBBmBctzUPq0sGqJNpReHJfGBh2P007EXNB+lZ2QhgBMy8v4bIVN5dZ6Xj9OrDWtqFHyXoLVDa52tM2HrDS70uNBcy3mVWPe3i0P4FSw4tLrgANsi0NILbspSK54bRpjumbwtJSEeB8G+ne4MTjhQCDUwDwZ/FqrZxcWsduYFAP+u+2tyNXQrMmWk21CtIZkPpuInMbFPNwwbuQHP3MI182C0VKaOWHJgsialvDbBogMxwvXzV5JgMVb1lP7Ai6nEU82gaWF58gqx5TBpEiBd8tdKfAbW7b8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_init() maps each memblock region with for_each_mem_range() and passes
it to kasan_init_phys_region(), which does nothing when start >= end.
for_each_mem_range() never returns an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 arch/powerpc/mm/kasan/init_book3e_64.c | 3 ---
 arch/powerpc/mm/kasan/init_book3s_64.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/kasan/init_book3e_64.c
index 0d3a73d6d4b0..0ed372fb8b09 100644
--- a/arch/powerpc/mm/kasan/init_book3e_64.c
+++ b/arch/powerpc/mm/kasan/init_book3e_64.c
@@ -68,9 +68,6 @@ static void __init kasan_init_phys_region(void *start, void *end)
 	unsigned long k_start, k_end, k_cur;
 	void *va;
 
-	if (start >= end)
-		return;
-
 	k_start = ALIGN_DOWN((unsigned long)kasan_mem_to_shadow(start), PAGE_SIZE);
 	k_end = ALIGN((unsigned long)kasan_mem_to_shadow(end), PAGE_SIZE);
 
diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/kasan/init_book3s_64.c
index dcafa641804c..ccfbfb894637 100644
--- a/arch/powerpc/mm/kasan/init_book3s_64.c
+++ b/arch/powerpc/mm/kasan/init_book3s_64.c
@@ -24,9 +24,6 @@ static void __init kasan_init_phys_region(void *start, void *end)
 	unsigned long k_start, k_end, k_cur;
 	void *va;
 
-	if (start >= end)
-		return;
-
 	k_start = ALIGN_DOWN((unsigned long)kasan_mem_to_shadow(start), PAGE_SIZE);
 	k_end = ALIGN((unsigned long)kasan_mem_to_shadow(end), PAGE_SIZE);
 
-- 
2.43.0


