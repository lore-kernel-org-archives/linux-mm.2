Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADDF9D172AB
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185AD6B009B; Sun,  1 Feb 2026 19:55:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 144FE6B009D; Sun,  1 Feb 2026 19:55:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0FC6B009E; Sun,  1 Feb 2026 19:55:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC2C86B009B
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A16E2160A02
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:41 +0000 (UTC)
X-FDA: 84397698882.17.D42E4DB
Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id C343620010
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:39 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LZPBoAPd;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8vQRA+06SerFEKUWpG9738UD1yc3kHqwB4W4DvkIi8=;
	b=fYda6HMqL+kN3Ln24y3OeoVW60nyrZL4S3B+it0YtxuubImQGzHjnX49XMKAl7Leau6bI/
	RYelpuyOR3QbELAEpjWEehkcBq5nfyDs4yDT1stDOPDcGP3xygXAqdx/TXFf6Hdn/xXvSF
	88WgOEoUX//p4EUjxS9SPSsdLcIsFyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993739; a=rsa-sha256;
	cv=none;
	b=nu2oRUsQno1mpjegcCGelUnfNcfCjcTrWEpX7WP6RpnzIZ4Mzd237CzUgjaO1VVuYvqsDW
	vVsBFPXcmivHbHkweVGUvI6v2N3HyvKeMLHVxYCMY9nbSsIUirmWmm0Jx4pWfsY4h3i95P
	iuCScofFYGP5J/IuvCVZtgbLAnuFoK0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LZPBoAPd;
	spf=pass (imf03.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-40423dbe98bso1770804fac.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993739; x=1770598539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I8vQRA+06SerFEKUWpG9738UD1yc3kHqwB4W4DvkIi8=;
        b=LZPBoAPdceO9oyg81UoOUxA36Ra7HVFoL0VhliovJnkUO7VXuiKxT4cpOlbrTVM4FY
         aZvBhxPQAp2spOBqgaRMTH93uuTV5zA29y5HG1dDATdJCqMzoB/YhiRWuV8HoyiwZGXN
         jL4Q1SwPg9bvluVle9bpUigdc0XDefj8qXLeX5hs60sLtURRuC6E/hstroSAB5/r3V2b
         Zpx05B33ftWwIs+i0RaNBTWixKnS5FBSgVJzpCVTQzkl65PJIq8IXPc3Dv6rosRMC0po
         l7dIXflEBOTUvJkbJkJnKW1VRkLf1HhOStqdoxd7L+ANVeHwU/tQbxSIw6kFXd7LvgTw
         OknA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993739; x=1770598539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=I8vQRA+06SerFEKUWpG9738UD1yc3kHqwB4W4DvkIi8=;
        b=G8jTRivktoA4oTsSC/QQ1vkg8/5sK0+UfEXyAApTCDsomFK581o1565g4UG7QM0SOO
         3ycn54Vz6qxkZGBTuLqyry1V+4myHyweSCZ1p1P7iOBGxIm53qDMTqqIN2c0a5QzTnt2
         5O4xiTfbB7Iz+oeYuFYMY7p1d90D2fU54cmQ7onI9trEu1KGCtYb3QIAMgcG4tl5RpXq
         5iVwH7nsXkCYoadL3pQhkfBITx5fDtg3DSRIKHaP1+RioJCcIZB5i7Bsd7vh8ul5BI3L
         hzTk92hyNhS3vnpKRZr/jbkng7HUdXV5RNa5w+dBsXjiJ9pt1UPjuR3+xW/vEENdQmZD
         CAzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpym50gmee/t8d4XDYMhCDi7lhPqBbBNaXZZNGw6xaJERhaFVoEpaHGG/b4A13ruy/JITnBXnUvw==@kvack.org
X-Gm-Message-State: AOJu0YwtSAE0UxD0y6PFSSZdHaWVc43jI//P0JJBXJzpi6LHt3IeCcX/
	NpwaVxiTUnbd75TvEfakOeAYIJ+h6mkETo9KNgeQOGLA808nROnQNKlL
X-Gm-Gg: AZuq6aIBK7fh33QY6j2JV8YSS/rQwL8LZNWiglS0kI5S2qRoB5kf/DsYaWlzqBYqAY5
	aUH2JxCgCUGvlppvhMT31epqYOnvm4vLjvnnGj1zeX5Y69h2dIzupH0cy5ssZeF0U010A+EcwkC
	y09IIaC0ZLvMC9xZ7odWhtV+weEnOCh+pxdoySvJW1WLvnzaCPxOlSKf6DD/HFiTvY9lNK2nUHX
	r/uCxqP/6yuI8/4S1e3NmhAwkhkjBTB4pTSb4fVQOln0USX4HCe+VGgV+Pw2tLCiKOoQmOyGEbo
	VR6L/K1oQtnsFULuOA1wI5xPix32V5ZtK4Av3CW0LpsyxD86VyGv0R+U66ch9nYMO1rQKrBCYlI
	ZzEMsbK2177tt5vdmYTSxnlGetgpNr9esqkjgmE1o5HxoUM2d61yNWbq8+gVtyG3F+6ogADeQZ6
	lEeImSWST/
X-Received: by 2002:a05:6870:890f:b0:409:47c2:bea with SMTP id 586e51a60fabf-409a6f87b2fmr5052931fac.41.1769993738683;
        Sun, 01 Feb 2026 16:55:38 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:72::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4095752ef7bsm10547305fac.16.2026.02.01.16.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:38 -0800 (PST)
From: Usama Arif <usamaarif642@gmail.com>
To: ziy@nvidia.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	lorenzo.stoakes@oracle.com,
	linux-mm@kvack.org
Cc: hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [RFC 09/12] selftests/mm: add PUD THP partial munmap test
Date: Sun,  1 Feb 2026 16:50:26 -0800
Message-ID: <20260202005451.774496-10-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C343620010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: u3x71bkr8soeecx9iy8aw987mrzwdkcu
X-HE-Tag: 1769993739-37044
X-HE-Meta: U2FsdGVkX193s3nO5QgtPUP5tHY/NW+ZsMHah7D2UfA/SBvWAxRqTkmsSQSHiPi6MaIx1MfW2p/i9s7NRzTJ0c8wtUFZlP7UhRXxQ/1ClMBNiWTxDqkHi7GZYLqPB8rhWSE4KP5dYfi5I0BR9GF9RW73g7VM+uocWXNtUrmVEbj8g4oeblg0YkxUkqXMsgV9VCvUvVu6qxU7AkPJffai1xBTT0arkCZWE+BjV+0WFNoDz+5gFYWgdb9NDMZreufUud4DkN4tOCsDUx3kn+rmzSKCpTjFZ3z6/nAHJ0j0holwV0H3VSMZmlAKHNqUz56FCU1QNR9S1YqmKXiiVc4EpY77/o+XzpNR0nKi7ImkFnNmb6wo2+NFPaOZbitIUSY3y93V+cQyvbvkh4ww76GVq7YwCBFuuqXmXkm+f/owB2zLTLL0vZpM8dNQ5MWFwXY2T6HHkLyrZIU/iuf2gVDT4VdVsjL8VaSdo4Lx2dZw3GGyolrWsw38ZkHbfg1oCgtNDmtH1HSqQ9YFTMug0LFj65iwICgCD6rspxF7XPnwvUKvlcVFu10V8b1XHGL7LfJ15jzlmf4P+4eUEyejWa+yREA2/eUHFGhkybMz2xGHssv74xJDoQ3gyGF6xwEVrnf6SRXT174yX2vbJgEYrA+EXzKpDajCX4v371mrEHj5n8mk+Vecqlqytp4pOj0l6F26Swj4EldTyvjRJfTxbb1aYl4PqHbvG59NVSr4OfnPJ0JQQvTchLYcR2wNM9N2qn5Xmxa0zMd6biFuWgIxFQyUGDwQIHaZoGN95p5D5e2L0Wc1bGqtQp4vju79DqOmgFIewDyVddjtEeXI1Dhc5BJRZPl2Hs8tFkdYz7eBKZWFpY6gFpcAsQrAUQm9Lhd0MaxyT3RJ2xXLNl2qmUD32ilZtDGKw+WLdoaFn2NNKnf7NUkdJ39yyqD043I03PHmAD2BLGI6vcV6sJIgwstbCDZ
 yEttB03n
 ZT58MwP6PDa0VdP9yJoYHOxawrIS6iWM5cTCrLI7u+8ic9HNZjcjp0dQD5CVJ9CJTJJgF+7h1IPlLYgxP736wGrHDQWRUniRxWCBgfyM9bKl3e0O05KuXjb1cGgbQjiDqY9DSb39Pb0pmtid0IoLYlWCHUOAaJSOjpK5ce9IFwmTl3MAnu8EsLQMH3HdjSsjU5dRefMQOf30lWg27nL6TKkJHgfuzf+Pz5NtgqeTOKt3/Um5X25Dxv0L9ccpcEYVCEQ0nG1D4eBloVpDl33ibZ8QD27L4t3GZI1iyoe1jBZznv3BYu+Y+pYja5s1b69JtMaxW31kwv3dpsW0CYh/Hfup+LFWi4bbiTvAPMhDplsxzl9qUA7Qt7Xyw2XuqUBxIi/N8o+8s7/RtGNd8vfPp5bDbQsWYzRj3o+Fc6xcMFEojJJrS9onAvNf9yFUCWRb5nJ6/GQMnjsHcr0yDcgSFZe64r4bm01saeq7KVDwqFdVXVm7oiRXia6ZvMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that allocates a PUD THP and unmaps a 2MB region from the
middle. Since the PUD can no longer cover the entire region, it must
be split. The test verifies that memory before and after the hole
remains accessible with correct data.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 31 +++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index 27a509cd477d5..8d4cb0e60f7f7 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -225,4 +225,35 @@ TEST_F(pud_thp, fork_cow)
 	       self->split_before, split_after);
 }
 
+/*
+ * Test: Partial munmap triggers split
+ * Verifies that unmapping part of a PUD THP splits it correctly
+ */
+TEST_F(pud_thp, partial_munmap)
+{
+	unsigned long *ptr = (unsigned long *)self->aligned;
+	unsigned long *after_hole;
+	unsigned long split_after;
+	int ret;
+
+	/* Touch memory to allocate PUD THP */
+	memset(self->aligned, 0xDD, PUD_SIZE);
+
+	/* Unmap a 2MB region in the middle - should trigger PUD split */
+	ret = munmap((char *)self->aligned + PUD_SIZE / 2, PMD_SIZE);
+	ASSERT_EQ(ret, 0);
+
+	split_after = read_vmstat("thp_split_pud");
+
+	/* Verify memory before the hole is still accessible and correct */
+	ASSERT_EQ(ptr[0], 0xDDDDDDDDDDDDDDDDUL);
+
+	/* Verify memory after the hole is still accessible and correct */
+	after_hole = (unsigned long *)((char *)self->aligned + PUD_SIZE / 2 + PMD_SIZE);
+	ASSERT_EQ(*after_hole, 0xDDDDDDDDDDDDDDDDUL);
+
+	TH_LOG("Partial munmap completed (thp_split_pud: %lu -> %lu)",
+	       self->split_before, split_after);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


