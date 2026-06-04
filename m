Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 903B9CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 02:38:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3EA46B008A; Wed,  3 Jun 2026 22:38:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15D86B008C; Wed,  3 Jun 2026 22:38:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2BF96B0092; Wed,  3 Jun 2026 22:38:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C34186B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:38:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6FEA3A059D
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:46 +0000 (UTC)
X-FDA: 84840672252.20.F17DB9E
Received: from mail-pj1-f66.google.com (mail-pj1-f66.google.com [209.85.216.66])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6311140012
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 02:38:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhpbDGb5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780540719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Jg2muu/RqGJ6FJ6mWO/tENjNo0VfGXgaATf3xERkFo=;
	b=pnM+nb4z09R4flSyzJr4HKqiiZHwl+Jv73t+HsR3/QaI0ZX11aKvMQ5Q/sZ4bnXtCE/o6j
	sj4PXiIekOsnrGyzJo2nKtyJFVmpzD5flJaIUyrXUFR2fz1wdZwc9gkYg3QLOme4FUt4z8
	Hw5gSIRhyzIWsZdgvgb/Yb9LgH9h4Z0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KhpbDGb5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.216.66 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780540719;
	b=AUGdiUctB45INoKAdKO80nOk/5kkh2k39XHu1Btp+AzQXwFrAqqk0oJ7cwc3RU9mIVBcgZ
	wS6O23ywaJGGodqiNFB4bx4hfl4v+aUVvku1/iHmzDHKYVEgBZgp/dfZBm9hC1/jX6ITDf
	6+2/EVeDbQnqCx/DA7l/AFlPg+pfUT4=
Received: by mail-pj1-f66.google.com with SMTP id 98e67ed59e1d1-36d9794d82aso93647a91.0
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 19:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780540718; x=1781145518; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Jg2muu/RqGJ6FJ6mWO/tENjNo0VfGXgaATf3xERkFo=;
        b=KhpbDGb5jyZwkGKQkuXB75OSSLoNWPgLd7G9qDUIvo2yLkGSlJe4fXLW0wLnxbTV4+
         WmhjkcvibZ8IeLkfdwK6Nf73Zk2RRaOFlzN8c4cewRqS6Xv9qmQpIZbk8W6OlhBEEYiQ
         mmI1sLvl3x7J6W897FgcCOPn54eXate1aM442mUcbdfAlWfbDGqNeIGVaLSZv2T5ki5N
         JDgZp8lOnNxdKQHtcQEv6HgBYI6nVr+Ap6HkiVz5ha8CXzrvTY3O2tX0Z65u/EnxYbZY
         HTUJS3w5uGMH+HzbmU/9RkbhsWrmQh0xDZLMvST9JF8NQYVzn9srjKSg5Xr169EY8vwX
         xOMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780540718; x=1781145518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2Jg2muu/RqGJ6FJ6mWO/tENjNo0VfGXgaATf3xERkFo=;
        b=al3jjFdJhNEbjSRiAt6N/mZRqz5LMaCAZfkcLVelXL3udliw7Vp6fov69fEeZ8gMkN
         Q/kiExNgvVXIEDypLiQQBD2Xy7FCf8xR9SFQ6a/8IgZBGPS9Am34LPrDmMyn+J6hYKGY
         f8YO49L+EkeTmec/VeHC1MDHXMTy6f4qnoBoDaMGQiF0QljBk05/fblRly0gD9y09Jdz
         y5O2IuPbRzUqE03YkgPYM4RvZVXhVhPaM/gvWcwuDrgEjvwoGsEbeV0MLrwOrGSMhmkM
         Tyo0ddPcTJ8XR0lg2Nq4unZ//8bMoqHTPPpHrMjIAuOyKBFy7ZYncJkyqsi82ATwQvFZ
         xJfg==
X-Gm-Message-State: AOJu0YyLF/7x1bgbAvUUhiuY8l8RxFRSCUJ9/nJCGgUtiCfE1RQ+bEMY
	psjdVxaA7ONuj8Fu7zlabtePAX9G3K+HCdca1egMfVP7MeudWMIRISORR2MxZX2Fgpbqjw==
X-Gm-Gg: Acq92OG0c8AZyI3EPud0PlKFyM4pk99iLirGhkbMxAOTZCNYQ8hWLyy0im0LCOFhxKb
	s++VImcOgf68PEq8vG/Jp+mIRyPi2/Wd/jiR2rYv+7wFRE3ua3bZdE3w/0ejg0J+S2EMWCWwZhc
	YTv6BGgXtsLMmfQicocTlBQ5TdiFBC54khc9z9Zml/6blq7f3wMpvE9latnRGbYXD38moErcm+5
	86z2YR7Kq+8AzspnETAbUlZtvyJ8fI5KiuGfSInTz2TwhaUggl6ysqmmL2Sf2eb6uH25ejjVYba
	MoPB955+95rjA4MtNaa74OZL9TT5vTOAGqred06q2YCsrKPqa4mlS7X/07wQm0kD3PR9O29l/WZ
	55n5am36H7aGhhyrjxl2UxFkQexEtGSPxRRJx9x7cGzglCBbUtKcSXbpANoWDqIjtSoK+nyQUZU
	dMJu4fg5XOcxOJ0crDJKZiKeeWYIFjKQ8s0U4ySpIfmVn31O2DgccDiZyVYA==
X-Received: by 2002:a17:90a:c2c5:b0:368:9da3:c496 with SMTP id 98e67ed59e1d1-36e335db4fbmr6149440a91.24.1780540718488;
        Wed, 03 Jun 2026 19:38:38 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f6dba8573sm1253072a91.14.2026.06.03.19.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 19:38:38 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	Alexander.Krabler@kuka.com
Subject: [RFC PATCH 1/3] mm/compaction: skip isolate mlocked folios when compact_unevictable_allowed=0
Date: Thu,  4 Jun 2026 10:38:10 +0800
Message-ID: <20260604023812.3700316-2-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260604023812.3700316-1-chenwandun1@gmail.com>
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A6311140012
X-Rspam-User: 
X-Stat-Signature: ay9hrssdxhshx9hwkfhb3uk1f67ahdpb
X-Rspamd-Server: rspam09
X-HE-Tag: 1780540719-354763
X-HE-Meta: U2FsdGVkX1/DpKndq9pOr72mwX20ErOhyQjKKwIfOARmUMhSEnMp0VLurwNKo+PiJPgCb9M2rXxrgdMdF1bwNEKK/EFspf2rna/MdUSr/P6n93eVrXhCOHLePvn0sjwwAyK3BreAKt6wSGOz447nFxRxNMBza/6Vz55Ux8WPRIQeSZXaBpmTYGImtZ7u22uh9YShuhZu6HauS5FRhuQkNrJL9VfEvYDWRTQwqZsrBRZ2i6CRFxBem50+AP0MGOd44rW8yKK6z4bpR/mJxkStsDgOc51iFI5rU6eSqm07hjmbyZWiXSCGm2Ji2g4GAZrboALUSP0qUfTGxyvU4KdJHb7QoBSqBjPXoDkko+EL64T7xS1BD0EYwj80XW6fR8xszJxwqwxPQ7+gHaJUUy/06zyHUTxh9Z7pKn92oMnmDRnSOw206OKe7QlzqDy6MvBZ/X5i7ErVl9uZS9Z/VGfzyOq05qufX0MGWlV7RPuHO38SeyNDQk9d6QhJL6Nb+Qh1g+pUkKdTGUt4GaZ2TpPjIuAxENpXOvqUceQ0FXgk9+059oJ2r2TNMVkW7PSEt/O4D0L97Jmu1BtQv5KvV8OLi+qkDfQ5MmeYM08DR0uMaz8LV5dIsSV4Y1ossMSbbf+eih07GKwNuEb3aQXyfZpIHUgmudqG+13Q/G60IHxWULmZuN4JskGMgk3odA/BEvmP7t9bLYAWdbNCIs2H2fpTdbLLzuCsOzvTeawPAYFu0ZF3Nq7a4GaCUFKLAb9QCWZxoFHjGjB/W0ADjx6DjVSEfvgtKpWq7rzOdVKhRVpJZoV3FvlpDFyVJBG3St4vCEZzbp8UpOUawivONVuzZKhZBYuymlaAXhNzoS7/gpTT+NAYsVNix9RaxHzgNg99rJsDF1I93xE05wbOG9WpzC5pBKBTc8GeSe6P3kce7ZmCuVwNMfB5NzJoczB2we2enmEjaCtDXkaQY5PtDRRXQ15
 3zKwbHYb
 VA04m1EhY9rqRv0h/tzEExfLvIDEcWB42nxs3lbXjOzSJzhDx7JhDfikMEwNzbXml8Lhr86D3cPUxLemPKv0YZ0WPFrrjt9pmfR4W9lY5Kv94GSmPfpNDREhQ6GeYeHsW2vyrgw77AF1eLh7PxhSYdYNrgXcpWUuBWQTIhcIryd5jKeGpb1XT1tiWxrmzrSLq0qIMnjE4xlnNJZXVwbLeLeZtqLr7q9k/v37krizmG21nxBLTVHR/jj0/k5TIQC76pGOlnJvMXzGk4JFOz+lxmO+5ku78l1xsa1y+NQ+zo9S60YT2BixEJwsLTxolTICyu0rRZss47/NZCXo6rnC9qNwf3oEJh5VuhpChaWRKrkJv5+HMMzE4FDm1A9+4gAh70AZD82R0/ctBmzG1Q4lKi6bFbLHO5OZaWb/rzQITMGRPw2VFrWB5DT6I6danhd6ANtzwgZLDAEAhpe/Q0unGJzW+zaSMgx7FoTsuAtMsSkpj0j6cvmtZadWxTTWsIXnS1d2AYaUftVRU/Z6fQS9FaWax3xJIBpx1XYknSBmW2BPkJo879RqOnrgGxMTHfpqUaTkPLEKhSpOOWfauyhfrvVpCYwY/Pg/3nFHo4IZ/HvKzpYZeYQR2fJFm5bV3ykJBbnTiaKu5S7lYALrwK5ggm+0ycOnlb27yYHkPws6CAmIwWesMxS2R4cf/4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

compact_unevictable_allowed is default 0 under PREEMPT_RT,
isolate_migratepages_block() skips folios with PG_unevictable set.
However, mlock_folio() sets PG_mlocked immediately but defers
PG_unevictable to mlock_folio_batch(), result in a folio with
PG_mlocked=1 but PG_unevictable=0. Compaction will isolate such a
folio.

Fix by checking folio_test_mlocked() together with the existing
folio_test_unevictable() check.

A similar issue has been reported by Alexander Krabler on a 6.12-rt
aarch64 system. Vlastimil suggested to check the mlocked flag [1].

Reported-by: Alexander Krabler <Alexander.Krabler@kuka.com>
Closes: https://lore.kernel.org/all/DU0PR01MB10385345F7153F334100981888259A@DU0PR01MB10385.eurprd01.prod.exchangelabs.com/
Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/all/33275585-f2db-4779-89f0-3ae24b455a67@suse.cz/ [1]
---
 mm/compaction.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index b776f35ad020..7e07b792bcb5 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -1116,7 +1116,8 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
 		is_unevictable = folio_test_unevictable(folio);
 
 		/* Compaction might skip unevictable pages but CMA takes them */
-		if (!(mode & ISOLATE_UNEVICTABLE) && is_unevictable)
+		if (!(mode & ISOLATE_UNEVICTABLE) &&
+		    (is_unevictable || folio_test_mlocked(folio)))
 			goto isolate_fail_put;
 
 		/*
-- 
2.43.0


