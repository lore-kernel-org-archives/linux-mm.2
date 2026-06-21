Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2E7BCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:00:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EFF96B008A; Sun, 21 Jun 2026 11:00:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59FFA6B008C; Sun, 21 Jun 2026 11:00:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B66F6B0092; Sun, 21 Jun 2026 11:00:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 287246B008A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:00:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9B942C1F23
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:00:03 +0000 (UTC)
X-FDA: 84904229886.20.C349EB5
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf01.hostedemail.com (Postfix) with ESMTP id BFAE94000C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:00:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exubFrqm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782054001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TN95Bu6N+KAHBZ06IBI49Qv8E+i2wcH9wcpOPRWJ3tM=;
	b=AzvWmF+J6+ptVsDWS5UjM+fFOOChYhyoi7EEOnCxtj9QqLPFKco0dz2zn/Jit/uVCJQXFN
	RFEDY9U+vM4/j6JEVTicoLRbxLUnSWNJg9rU41GtcSWIWt29euIMB6DxepT1mbPChtZXuJ
	dFGuvgdgTr8gB7xLD0eCqQO4qYE3Enw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=exubFrqm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782054001;
	b=11X5DslqlQz+Vaul11ErCKGxP7sjoxpi42AU9LtDeasc9/NHYXbfGBxCRRnj0KTaz3LMJl
	aJZrVdqZt3dNtLhgs+rd7uQKhIk/LBbaBVtzfyLb4nJ+pc7zqerhGV47SNCzu1LuYd5B+Z
	8LkyQUlaw1+C7F8fi1JLIuCzUua9qwo=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-36d8b644473so2625588a91.3
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 08:00:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782054000; x=1782658800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TN95Bu6N+KAHBZ06IBI49Qv8E+i2wcH9wcpOPRWJ3tM=;
        b=exubFrqmL55pF0tktRg1AvQWg9r3bRNxe/pxMPOa6r505192Dv/sbiDFzxeqzVeRgj
         uHqiCBF5+1CmY0MA5nCceREbtLhKhXBGzGW+wi8WRuvVLStdxoJgvu17F4nVSi1gvF6m
         OHGEVeRbCd4J1JMcrcxjhRM+wxQRlP0dwUOYtZFComnvCjswXHEBCXzNXEqm1OUj+aFG
         jnDZNj5dFIWAtYYLD9gffzgZMWCRQ5iqAK+N5Dk3KokDHtsKSY1OM3ZWi34v6TJNSxyK
         Kr7dtIq7E9xRCyxczvo4sWDXuAaeiTCprTcYIb/WiMShxw8aiiwSjB+ETzC6tg7Fd37K
         X8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782054000; x=1782658800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TN95Bu6N+KAHBZ06IBI49Qv8E+i2wcH9wcpOPRWJ3tM=;
        b=F1J6gvLS5ZjjloJJlzVTt529SUMNbjyuIccgHQILzglcksnB0/Q1ExAghPHKJxu5+y
         iy0ZI/zN3n1VukZJRSErBG9xHFwm5y1ev+tCrAmKsfqJ2DQpUXy763CzLJ997RYMDkeH
         gzwzBBrM33x/cmGDl/teagxSbw8A0cxLnedydPmtnc/PkvKk/yeMLp41v94v2/+AKlyk
         BD9g0DKOP7AHFkIZVWzuqD5+u7iqYPHL6H9jgNhsXEPGuTozyZMJ5Vz1F6rAN37vIMMc
         MJvMbV25wznyuyWVvAsEbB38V91a3nA8oYQBGk/vkJ5CsAJw9pKuj9ClSsB588nyNSKh
         eTLg==
X-Forwarded-Encrypted: i=1; AHgh+RrUGlYCw1Aq9/rpBhOjyGpaRTA18wx9xZHE1KT10njYThTFSADCwUD1NJhsOoCLIxssIowIQcUUog==@kvack.org
X-Gm-Message-State: AOJu0YxJb3jYMMHKmcLrg75WhFve/0L2hjnobL2kt64E3fwbfvh+vKiR
	sw8YSIdY1Dvev8i7l24JXsJOUL4418E+7e3sj5AS1W9XWc8QGhjWdocU
X-Gm-Gg: AfdE7cmZnzYMzSHqQOOzhEoRPUbTaSQN4QFMA1rUzvXRH9Uh9hCzJH2DKRxyfR5mIp7
	/jZS38iywyFYF9VwMAMK/AZlrZBTEtPC+h8xKjX6HjnY+8wUYtzOZKeQvnwj/itWXRh1jiAdnF8
	4rgmD4tyUYp4fTqFyLlQv4XRyAcTUYlxx8TOGa+tCeuTpVxg4z7EjcnWAAX16c959J3+ZVRFct8
	wkYsMaxuOUPBSGgg2flp7HPJjMo4OoG0Z2E6DIdmEz9xG9dEZ0CmX+O5vL/c1T8s4Dcid+anGs6
	159HaPihCDxE4KsURP32K+5VzF2sqLwRNl50yfgB3q8+STCcevhYcWaoDL6/DWLSrLVQuam92cI
	r3d/CpzXA6KSv6afZ6Vb7bJVUAh613+VsS/w8moY/i2ZejnAupJFkW4XFzllMH4W67nF8tN1r2/
	oFE2BlUGQ=
X-Received: by 2002:a17:90b:568d:b0:36d:8e6f:8d9e with SMTP id 98e67ed59e1d1-37d160c7d59mr10778840a91.20.1782054000602;
        Sun, 21 Jun 2026 08:00:00 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37d4f225870sm4544896a91.8.2026.06.21.07.59.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jun 2026 08:00:00 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-mm@kvack.org
Subject: [PATCH 5/6] mm: remove unnecessary empty range check in early_calculate_totalpages()
Date: Sun, 21 Jun 2026 23:59:15 +0900
Message-ID: <20260621145919.1453-6-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260621145919.1453-1-ekffu200098@gmail.com>
References: <20260621145919.1453-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BFAE94000C
X-Stat-Signature: yejhsqdfyqwn3moqb67yc6pyquegr3jw
X-Rspam-User: 
X-HE-Tag: 1782054001-367193
X-HE-Meta: U2FsdGVkX1/2h4uYL6goAveGBOxT4ap4e4wOHeM947EuZfZ/4I8Lh2ofENRSL58hfNRgpoe12JnHsa6qzh/+fEp5h0C4cUwg/U1Qev+GuhEX+uNs+fpcWIpAEy0estyOJRCug+dLWuKHuwMeQD/4KwQhLNc6QS1ZjnXret/J6AC5BJArD7fQ2+Wv7RQeI3/Q887NJzHHdwVcsLIb7aVrWab1rAb8C8U4ZiDFIhx+B2Ur+uy4n+pW4Gnefy/uBBa9jrs9LhEh1BbSq57xdT2QbXT/4qQUJXZgXMogsUmsdwqsgscusYQgbah9zPvxFr9+Rj8KXKnaqmIO5XwtXfUAKBUfq51bwfJ06ljXLCB5AKlxN64dAeW6as6rX080u19g/2moKXr6hTu82rKmnjAVgFIq5WySOLzG8PGF5wECOJiyBm7wF+5QAmXphb6eFE1ESaQoVQiQh6NLKXsxggvb8Zjiz9ZuFIEbvGRFprLg4MbAyn3v2hoeD6BSmm53EwtaDLa/SkKac7iSS+8VTxjHTnTBI4WceWlhS9lcA9nFtdo2Y9hYI4XjEmOzK0T6KCzCPeQhthadLRZu+j7SZGJR7iO3bv0Of18sNrynacfSZ8TyY44LgMplZ7gTm7vHDg/WGzM0tRKv4t707h1CDshmjxmkGFYrjqCZmpjaOqS+Hv63YKhGgg90FNpLIYmYb6K4/vng5GWq+mvGt40e8eHVOKlojfStT5nCHd46bjmSpvGCbxKG570r3KIkh0ejV5DRQVWIRd32vh7z1tQiYEyo2zpD6hUFArG6WNGzmgZP4thh0W4WPbLySLUcTW9qQylT1sOkUmLDdFfaBpkUr8wHMqh0A2IwWxaQwjojZ9feyNkr6RebGpnoivgyyqAKm0sejT4mOr4Vg0ZpLOlvKsY4vKjlu+ceSZNcp3mjEjvM+kwYuKIGWrYV7XN07BEH+Hh7tvee7UtpIXP40UiScDu
 B+GVxBqb
 yxYhFEt/XNIsncdJaO3h75LSY87YOfnKeP0EUA4c7yxxqP3APhsoXJceYbq7NwKyPIA/IMyCor62Zb1p4oM/JlktDM99pDRa3Q8+6ir+2Dc3/Z0NNfcxAAZOL+j4G8o1Dm/3rN9UaOR0LZeEFE2+saUIwQONSpfoVAUwSnRkrDTNDtkqr6iWuP9s9ZCVSvdYufXLAeUk+fZyVHzengV66rFEJR12TgKuFdLzEHi2B4UX8GXdN9IjSypDWi4k0oYvkbXPF5zM1WrszBua4YHYeNU//dhMDKZ79ZvQCuvVnsFOLfJBJJZLoif5tPMu/M1kHilkTzKnqBMHMBxY7PSxKP+kkeKrXQfFlXpfkGtim+H0x+Z+alwtuqaeAjNfLH+fDDIUxPm5Eq1GeBUGR/QviYk4DJDpuLvsqC6WNFx47bUbV1ZSgV9ulnN15Buc6gpct72OSt1KD7aMY9Pw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

early_calculate_totalpages() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set_state(nid, N_MEMORY) only when
end_pfn - start_pfn is non-zero. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..17498a13eb99 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -332,8 +332,7 @@ static unsigned long __init early_calculate_totalpages(void)
 		unsigned long pages = end_pfn - start_pfn;
 
 		totalpages += pages;
-		if (pages)
-			node_set_state(nid, N_MEMORY);
+		node_set_state(nid, N_MEMORY);
 	}
 	return totalpages;
 }
-- 
2.43.0


