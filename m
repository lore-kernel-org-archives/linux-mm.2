Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E2C6E65298
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 00:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6E96B009E; Sun,  1 Feb 2026 19:55:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22706B009F; Sun,  1 Feb 2026 19:55:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A047D6B00A0; Sun,  1 Feb 2026 19:55:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 885F96B009E
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 19:55:44 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 56E4C140A14
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:44 +0000 (UTC)
X-FDA: 84397699008.15.E9554F4
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83A8CC0004
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 00:55:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHq7bpbV;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769993742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hKd/LbJPp/JDVOH5LR7j10+P7y3WmWdSNYy5oCtrFjw=;
	b=w4TsQcKwUUGV+tLDB6IGOzHTc6GXamLP4jmFLJz30kUWIG6/SLtVeAgKWC3n1zOVrBJ/ZT
	qgYQysUFxMjEh8nLNP4zzpHs78z2iCOs2DtHMvgnjam6trCNEjx8QlA3nc8LTYmp6ytX4O
	vgzQUtIPgFjmRyUbm375t3JaTCc5XjM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OHq7bpbV;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769993742; a=rsa-sha256;
	cv=none;
	b=oLvD4Y4/wT+mennHzdrxg1hfToOc5iCfRA5bPJwV9IcouABVnrAWJFogFqYCplAnMlGwbE
	Cu+pJhrA+TXt/xv9SNhYY2IF1UwvuTwxegsRh/yhDBqga49vhAqEzORvBhDbw/6iE3ZQhV
	vnnTNqMVncD2G6UxzwXHaNSdW8U6y9s=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6630b08ad60so1738438eaf.2
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 16:55:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769993741; x=1770598541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKd/LbJPp/JDVOH5LR7j10+P7y3WmWdSNYy5oCtrFjw=;
        b=OHq7bpbVwNg4cO5jqYGghyDg17Bpyv6RNEc7KqIc+8mN27snYh/TwrQBiu8oktFdBx
         6BrML7RWjl8DtTXV8na4XTY47FLq2ZarM77pmeRkCQq9sU6Z3uht7xb2xYSMvOJNMNel
         Fp0wcXpATRdW2xmKO8/0LeQweb4VYDIZuxnw4XeIRQgcMDJOTS93RKKJsnaUATpkn8WL
         kHU7E+qATkVr7uFIVgZFpoBq+Ruo2qKnom/srNk5rlA3u3yozQ/fwJMvPv0cUJUGP4Q8
         OzrpckEAmZsgQWARjG3TJBQ48EsDH2zhZCV0cQKSxtkRqNkJaKlLJ+bM0TPIj38cyZ6z
         T/hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769993741; x=1770598541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hKd/LbJPp/JDVOH5LR7j10+P7y3WmWdSNYy5oCtrFjw=;
        b=hEnA1HfmuicZvqkV83i/POviL+axddDvoGDX3a4P8oa88uCtoBFLvlYV9vmAOrHjWB
         PPv7MDUtj49jw3p7CScbMR0b8NSFcFA+qtmlqG1eytpbjMOFhwoRqZcsjSZFDqvuJKq8
         sKRyaiDciHrt8EldH6cqR2VEpc+LN3PaBnoW7R7KZ1FZKgSngx8uRyHhY22IE05W3BWA
         loAZevAUbey8Hpw2q9rYVCp+ZCigCxCt6itWlUkRSgoRuG3z37vxHXmGuZgpuxapceX1
         tKVP3Lo5/1y7wMJOnq/KW8xU2iOlbcLCUN1vlx5UyNoSWwJtkVKhiezVgC2c3rwMdD0K
         J1dg==
X-Forwarded-Encrypted: i=1; AJvYcCWm/Ed55mBk7sx9TDhu8A0pwXwEBP8iykaOguoe9RCSDHCZ5xGoZQTkE/G8jK3LAOavAd2aCaDy+A==@kvack.org
X-Gm-Message-State: AOJu0YxiZKKQl6iqQAWkFNmhIkr21zoLsvyxdzCSYkwxPWHIa54e0J4F
	DZzv6YXwWqSVhN6BIz+VHcnVZKpei9w/Hvm18ZkWiSSxfWfkevV7l+hs
X-Gm-Gg: AZuq6aKqxGetufHohEv8jwzq1/OujsyE41chMve910yWMh38ncX/Iqm3CxaWBjnF0Cw
	nklHB2Wl7AmMIBIo5gQ96Gth34FCWlxiHpTqLF7yHVA0ghA1vUW56yWtAubox++H+HfBniCC8wo
	0z3kIihPw+tQfK3M+naq5uX2N+jkxC80hoG6NmliTGZ+WTi5CDuYgMFzwd4zUULj2wDUc/tF35r
	5jXcc9ewMeE7YW1w8UgTwGBIUO7ChZBF1cFgxsNNipld5Izyn/uSYGKIfJ0mXeEtOalhHFr03aU
	gTq0dfuNW/isx4rGqdwi3YfW8qULkzkY4bINhegQOS8G7O0gsBdBXdHV7ihnjcpNJsUbMFKf7Yy
	OEJT6bjfCpGmw1N+wVGsProra5k00YUIiDJBXWj4U7k7hi6AMcdFyuwIYlSK0vo9vTTTyMcOYbL
	GF8o6dKooTLAvfUjN3gic=
X-Received: by 2002:a05:6820:2909:b0:662:f997:8448 with SMTP id 006d021491bc7-6630f37792emr6869006eaf.58.1769993741508;
        Sun, 01 Feb 2026 16:55:41 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:71::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-662f996216asm9000764eaf.6.2026.02.01.16.55.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Feb 2026 16:55:40 -0800 (PST)
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
Subject: [RFC 11/12] selftests/mm: add PUD THP reclaim test
Date: Sun,  1 Feb 2026 16:50:28 -0800
Message-ID: <20260202005451.774496-12-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260202005451.774496-1-usamaarif642@gmail.com>
References: <20260202005451.774496-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83A8CC0004
X-Stat-Signature: 3de43dqy4h5atww9pf3dcu8xn78tz3sc
X-Rspam-User: 
X-HE-Tag: 1769993742-903519
X-HE-Meta: U2FsdGVkX1/5oxWDNYOAHIQng5T9kNnojfF8HsFAso/KG21GPrGRcDb5LaWuiaS2uuBwrK5MV1mNu2azBd7Nsiizq6RiwljAiz9KdPzxOCmJATNwsBPxX7guE6f/H9VAdLvgSEnkVNnEaYpQwMa/myOSKqBeHqEUQepEl5E0u09uyeyxBMophrT2ymvvaq7RfT8elK0W6YDqjbW53Dhh/hxxwh4QYG7AsfclWX3uRlJv5AP+ti7+5Q1uU3sPb7YsEfqYx/fYJp8YmElWI0ahQ4LaVgewtGiELRhI9+UurVzo7h70TMzsTbR4Xy/c1JHAZigBPtfGaminUjuxIUVK1u3KUZMid88v1Fs/p7E6ZtFRWNrI7WJFg693Yb1S9WI/GxJe+h4lz6Cz4aJ+ogn6Dgxmh73DQYTekDhn3WFLuahQb/onivW/69jtI1xP0Uv1nbzTLxeXEnEOMhAb1kFMP7SUSDgX6zRzLqy8ghYfAVpjsq0pMhZiBxM5QhlIyAxN5lorvZqMm+kSaDo3V2pU70KcHgSlK62Ds8zo9GCANuByGweGXfrRgJD2MpWk+pl8yEzxl45iUldYz5SnMZ48IQFnyPEmSun5I4iFy0DB0NQH+9sxP2TS2vvZdBwdip3vWZIw9/OvOJXFYmfRd0zzRzJHUbozYakLEVYiy9+Juiuz/LB81fbVynIQX6f+vMPD7Dfury8Hi9L0/h89XD8QaWNEVntPIjktiZol5b7XYMVizH8cjd5w5dDYmm+yZGo0qSXza/2yZGslvP30el92WSRJdZ4/iHVn5hbPuM98kTVRU+8uAjoJKBpntJkVlb9qfIffhkUNlL/oQgABwFviwZWatUnaYmJ9fLDkjD9ALYVkSLifBYfPryi3eAcSFcwicVy/XCl8Us9J+1kazweCPfKTHT969vqgCiKzyqWJRNGBEYET6CDuT3oYymxKhzR+4N/NYT1F5Nt5ybI/9fr
 DFYLSAZm
 iWzY8qXFmgAsERcUlYzXKpBq02lKRxStdpp/f7C8HfJtsV7WP41Rmts4t0iYMuRZXQuf/1rnnPX09GFauL8hQwv9LK/Ym+Nnk8umfZp/sX/o60OMCwFDjtu8fDV46LD4uVdNGrpyzVg/5GHb1a2KZaB6DOXbSHdHZsEhJoOLk7w7igm/dU9CYQgq9fVc8skAYSktInfecEUPKZDNC8bHYLyjb+J47lvxm8tk/OXyQvTHdGCJFExLNqnxS9xmgopq0/iSffWaj791cgC3WrvSwictg+G2LIwEQ2dwhQsR+XQyu3jHwzcmAj6HJCHFqDpFvXNz/rcyTgj12+vcuw9WAQ4q5RSWKHavjt6TU7mEFxROIUGU2sgkAE8WW2peqybuINoNSoihZaceBmcwbgbr7T6BMiDnmUx6kYclb1sKBooO81DXpS5UHair7fpalOihx6SVDdQ7+snPuusIiHjbkd+k8FOngsn1WH9ROZrzKD+NQjPq8ou3NFclZU867yDjXi6ZXS1eWd43laHjDHEumsktbrLHMyBr6JQp1hFZ/TG+hG3Qcc64gJDpdf8QU7J3fAN9FTFHyTPAEmDH4sKuZ8qNLTeIi6hjdPq5gb/nf4jQQpm4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that uses MADV_PAGEOUT to advise the kernel to page out
the PUD THP memory. This exercises the reclaim path which must split
the PUD THP before reclaiming the individual pages.

Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/pud_thp_test.c | 33 +++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/mm/pud_thp_test.c b/tools/testing/selftests/mm/pud_thp_test.c
index b59eb470adbba..961fdc489d8a2 100644
--- a/tools/testing/selftests/mm/pud_thp_test.c
+++ b/tools/testing/selftests/mm/pud_thp_test.c
@@ -28,6 +28,10 @@
 
 #define TEST_REGION_SIZE	(2 * PUD_SIZE)	/* 2GB to ensure PUD alignment */
 
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT	21
+#endif
+
 /* Get PUD-aligned address within a region */
 static inline void *pud_align(void *addr)
 {
@@ -282,4 +286,33 @@ TEST_F(pud_thp, mprotect_split)
 	       self->split_before, split_after);
 }
 
+/*
+ * Test: Reclaim via MADV_PAGEOUT
+ * Verifies that reclaim path correctly handles PUD THPs
+ */
+TEST_F(pud_thp, reclaim_pageout)
+{
+	volatile unsigned char *p;
+	unsigned long split_after;
+	int ret;
+
+	/* Touch memory to allocate PUD THP */
+	memset(self->aligned, 0xAA, PUD_SIZE);
+
+	/* Try to reclaim the pages */
+	ret = madvise(self->aligned, PUD_SIZE, MADV_PAGEOUT);
+	if (ret < 0 && errno == EINVAL)
+		SKIP(return, "MADV_PAGEOUT not supported");
+	ASSERT_EQ(ret, 0);
+
+	split_after = read_vmstat("thp_split_pud");
+
+	/* Touch memory again to verify it's still accessible */
+	p = (unsigned char *)self->aligned;
+	(void)*p;  /* Read to bring pages back if swapped */
+
+	TH_LOG("Reclaim completed (thp_split_pud: %lu -> %lu)",
+	       self->split_before, split_after);
+}
+
 TEST_HARNESS_MAIN
-- 
2.47.3


