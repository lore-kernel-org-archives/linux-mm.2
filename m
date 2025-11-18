Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B43CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C153C8E0013; Tue, 18 Nov 2025 01:09:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC6528E0005; Tue, 18 Nov 2025 01:09:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D3E8E0013; Tue, 18 Nov 2025 01:09:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 926D68E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:09:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4425258A8F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:21 +0000 (UTC)
X-FDA: 84122700522.11.1754543
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4D4CA1C0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:09:19 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PmS6NJ0z;
	spf=pass (imf18.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763446159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gcmEJIrS0DouZMUTfmDd5zsPzlde0IgiL5pnbLNqEQ4=;
	b=0S68xPWNX3uPV427IlfD6E0qH59JE9Jpk+Mt95LgyLUdan2q3f0DkBGohRd/pAxzr5q/XX
	GyDJlbK1Emf1tM0McpHR8pQM/rxuNuTYaUS4ODK28SYbyGOBFuM7IMuuROo93U6q8AUqgA
	zLecmDuQx4v4AS901UMj/nXfOWI5vOo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PmS6NJ0z;
	spf=pass (imf18.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763446159; a=rsa-sha256;
	cv=none;
	b=TXwfYYjg33DSdJfc6U5XW3Vv50tUSHn3+BPn9F+fssiCoptEEA/T4mkJJjSFa+2WoriNXH
	qC7V7enMwAUNqf7EFhvoqBuvyM6A6YCt4ggbmE2VZ6M/Tp9OeXppQor2eMOvkb6Nl21Dz1
	8464J6ybzGGbJWpcDgXuFrbL5tul7Nc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29516a36affso60149725ad.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763446158; x=1764050958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gcmEJIrS0DouZMUTfmDd5zsPzlde0IgiL5pnbLNqEQ4=;
        b=PmS6NJ0z9DtP6rdqTl1aH4TLDr/9k42odmVvU1x/xT4BnqLNQJIOgZdVgMzswoL4HR
         e3BSDxM7//upJyCXrv+hfc7g4gG7iSZGSTZiFlW4YBqRwd1VBQsPVwNG1ZvTZZmE/MRE
         pVVexAsLu8f1a5fB5JEFdkRUwN3TWryu2DRRV0GUBdcunUHJgrJfWVJZGGQlLrr6QtGF
         fvlUU3n/yweoZvg0kGNpj7YSAN8ZQGXKMpIKmoK3n53XymO5wuyJsNjncKlcRAhMH1H9
         cE2lh8uSkfGKZhN3YN6xd51wulDFuCTmP0Bhvg59iOOCjZ5hFih8IkPCZroLKtAxoM5Y
         4FLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763446158; x=1764050958;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gcmEJIrS0DouZMUTfmDd5zsPzlde0IgiL5pnbLNqEQ4=;
        b=NisajQADjSV+3xJNi+a//9Z71LKWRQEWtn7SgJQ7BR9vXPpCsnxZJLvU+odWtiBqYi
         sVNl5fZjP+N2SknCsJrbAxBg3Yk4GFwdDAopF/q9mRWClWE5KZmr5gkLQhkxyhu3G6iE
         aTN89ZdHAV2vUThwsXBi1C5vHl2nnBQFcGswZe92klgz27Zkh635KMWZ2vOdaodF6q4j
         ayC0blXSyrKQvmOlWM5UdxUKWVekFEXvX+0qfBZsTKHQGLQkITMx+sLDMSxsTIXO2KlF
         Zwhj1aCihQReM8k1rXftUX2LK8je3AmpffWnS/ik4vXO3fG7vitXDK85Y1K+sbwSqjEn
         goeg==
X-Forwarded-Encrypted: i=1; AJvYcCV5IPJJTfpP2056W4OsHKD8KHJi/9T5GsUnQErbF4m2C4JQ/lue6+VI1oXbaLyXJTWb+i9dqoBZcw==@kvack.org
X-Gm-Message-State: AOJu0YzAO/w8Ie6JfluDmwl6H8l2OLMwbcya7q5akWsNCKvA6ygZ7iWB
	u8JCtxaPNqVeypU2j9C0KpyOcFxm33QiJEopcgTfHvW982c6pQ7ohS2m
X-Gm-Gg: ASbGncu0AjKv6TJZNJOjdG8ly4XuHzx31le0jVxbJLepbcK+ZZK0NyYliJZPMjG4nJs
	r1rCsl8FYII+OwjAcwDlKTl+eBs95NtQu8qKlp8hflh+q+g49WYrmIBFJadW7ZIFI+wCBt/is85
	O73M/ZbOOUzJkHuObESjUHH3kwg4Qp5G71SvT2K9npC8atZL5q8MyYNEuDc+x/vE3xFxxDHN65N
	wFv0HhswfMmGfieA7GKloW8dsoprPeQElBsRRcc+HKTqGTBOFBlqJlLERRH3eJ+kKA4RNkLovji
	OjMt9hBHbUNmFTcc2yx6e49oAgyF3oRL9j6+CCOzaX/JTy5CCivsoAHXxpn5NWpy6b4N0fDYqVi
	PtXWT3BwIGbQ5Z3ZmWHlFrmsxB5qbSUG/roLhyUkXfyUu4BAtoCLlObmIzfXJ//vA6RxPcNqLwy
	iB6g4BCRxO3E2GVsA=
X-Google-Smtp-Source: AGHT+IGEWwsjiAcmca16Y6xANvQT8KsqU26hleqFZ2KO9J48Rtj3f79xMl6fSPxxx2q6/FaAUrOpmQ==
X-Received: by 2002:a17:903:3bcb:b0:295:1277:7920 with SMTP id d9443c01a7336-2986a72c34emr189998565ad.28.1763446158114;
        Mon, 17 Nov 2025 22:09:18 -0800 (PST)
Received: from chandna.localdomain ([106.222.230.39])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2986e5ef32asm124461135ad.39.2025.11.17.22.09.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 22:09:17 -0800 (PST)
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Sahil Chandna <chandna.sahil@gmail.com>
Subject: [PATCH 2/3] mm/vmscan: use %pe to print PTR_ERR() values
Date: Tue, 18 Nov 2025 11:38:50 +0530
Message-ID: <94ba6ef88d97eb1a5e20eeab9f913be8fdc46fd5.1763227530.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1763227530.git.chandna.sahil@gmail.com>
References: <cover.1763227530.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D4CA1C0005
X-Stat-Signature: jzabnmrr8e4corpqmw5yb4ttf4oogktm
X-Rspam-User: 
X-HE-Tag: 1763446159-367215
X-HE-Meta: U2FsdGVkX19yvlFZv18379ej6MCc6bSQbzJB5vC9VOLrzRj/WJncII1fCdUlUXXlfGKeto4nVIOmiv58f5fVuXxgplM47rt+t2SzoF2G9DBzrcq1ePvuoTX/J4C/Lq0XGi5cyhVt76CTn4cdNa2d2H7ZXQMj7fGm14FzcawXLSdlOZQJwq8pI+/5HjNUhTmOIP+Du3xepITzo4Fh0LSgeJnVauc3t/rEKWKDrD5N08ef1+4wsKaNRQU2QBs1OQdpEhuG0zUz7mcHm4vMZe9YU6BNdYU83/iSgkNHAN0soz8X/qKpxzAT71Dz9Tn8Uh9J7Y1EGgU5lgWM6lK7V1DYihw3VfD5RwcVbbu0iBQDujsQbHHVT4EdUOMMaJQI3Z1BEzV82HhfN/nz8z2/DFe3cMHvLhP6LLVXFNiK0TpO3RJd8peUbxPP+N3E0IoN0BlydKU/QufC8JFCvAF2cLBwnfR7UVeRWb4qDzYoGeJj+MylE9crpu4dvCeCEFiCWmph0pG8WiqeqNCBKkTE6k9gySa/V82MHF5Tu3JRSYISUUZ4vxlqhaSPRK/H8lPI9GJbehzexgGJTuJglqQfzj0k2qllsM2B8pEDgWuofcsETEvRR+LFSnbNQ+0irS4quVu7acfHd03gI+JRMPiqg1c8ATnv27TL5pj8MG0t38XoTHGjuBxgtMSwlDAln5rAw9h+sYUPGNhssuDXkeB7tfR3OiIGAyjwvYOVWNGcxIhylr5/CIQu4m4T8KiBf1OVp7z/2fsaO/7DGLwWwFbLjH2wnQ+Tjsgn5YofiANKRVKJ3Wo4CVeF3A2DUKLjoYGtuziCPOtk30KG6Hj5uLvMt+jN3IslMJ3MzpruIoK8lFtC+Q9jMAtQJohGbA6OL0wHQZIUlTwErvPkwQohh96cGV+h++DtvZKzgmmeIIXbO+fxGXnTlZWnD1+CXn2b+WGQgw5EpQYbbUyUdywOWS82rOa
 dFoBiqmw
 dtI/Ss/ROrWFQRXlrUNW6W1JhJ/T368IWcTdKWF14jR7NyPeX1bPVI32xNXNvA16RegGSflgnZy4+etAX01C/Kim/KYiP4kW6UM4+LSQ3cAJqufWNDsKRtkmCjApFWJaJofZ9l7DbXprA/ipJaAm435mV3z591+T4Ai2f6N7UmYPHorQbnBgYtdsvIemkUJ29gLr2Jvd+dWR9bKlvyzd82Kt55v8EQTzOmKP69xx294Rk4Vexdl1Hd3D/eXxnpkuQx4AWkKzYzz19ilBorQ4Tm4sX0OeHJIHxgI7RDdfVMrKE8/o5GkWOcpnTO9ajGUqSS1R369tUeCsNBWlSuGJ+I9ZYRBwb5F2chAh6LIrBASP95m1+O802Y16rQveXVWkaLYfwABLe94rYEYbMjQ+gytuYbLDP2TVg1hfehdO7qFSmwSPZwoVuR1WmO/kAkeX3puNLHZJsR9u1U5Wv29pL+gHSo+3lzBuO/XbT6se/o/wQgN3BfVCVNu6QgOdieC43/7Ll0cpq1zuyeA1Wt9nmiWqGgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the %pe printk format specifier to report error pointers directly
instead of printing PTR_ERR() as a long value. This improves clarity,
produces more readable error messages.

This instance was flagged by the Coccinelle script
(misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.

Found by: make coccicheck MODE=report M=mm/
No functional change intended

Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b2fc8b626d3d..7d5b41696cc3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -7500,8 +7500,8 @@ void __meminit kswapd_run(int nid)
 		pgdat->kswapd = kthread_create_on_node(kswapd, pgdat, nid, "kswapd%d", nid);
 		if (IS_ERR(pgdat->kswapd)) {
 			/* failure at boot is fatal */
-			pr_err("Failed to start kswapd on node %d,ret=%ld\n",
-				   nid, PTR_ERR(pgdat->kswapd));
+			pr_err("Failed to start kswapd on node %d,ret=%pe\n",
+				   nid, pgdat->kswapd);
 			BUG_ON(system_state < SYSTEM_RUNNING);
 			pgdat->kswapd = NULL;
 		} else {
-- 
2.50.1


