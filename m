Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11559CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 05:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E3C56B0029; Thu, 27 Nov 2025 00:11:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB586B002A; Thu, 27 Nov 2025 00:11:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F83E6B002B; Thu, 27 Nov 2025 00:11:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8146B0029
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 00:11:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED56916099C
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:11:53 +0000 (UTC)
X-FDA: 84155214906.14.4BF61B7
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6113080003
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 05:11:51 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLVi4oda;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764220311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lH7KcWGBcyMFUXjXeQ0ZgXTh7zF56Hw8Qv1tMObDrw8=;
	b=ewiK+olBAtCvrjQjs8XWMMAvlHAyUpg/Ap2isVjdy7+liPKhH98JPf8N/oScAFmEw2bcGV
	/5fTyC4gndNJ9p2WWvk3KU1Q2m6Up93kl3gy1FCTa/G8D9JBpf21fp9z5332VmUaclb9v2
	aP4CYk4jzgJLs4MM5SF/av+GLGlEVp8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MLVi4oda;
	spf=pass (imf30.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764220311; a=rsa-sha256;
	cv=none;
	b=ETdOSJcdQJMiS1hvdhYBTeJRvapazwmBPG9Vj3Xct+byP1v9XAwNg5bgLSD8bzbntH6DWT
	gW433oPBijSeOn7ogIlb5FBW/s4qYAYP9e02qWgJgaN6QmwA37ikMkU453BIIya2u2Ia3D
	Q/FRfMkjfbvTMm12YBRKtGBvRwafB14=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-29586626fbeso6300975ad.0
        for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:11:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764220310; x=1764825110; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lH7KcWGBcyMFUXjXeQ0ZgXTh7zF56Hw8Qv1tMObDrw8=;
        b=MLVi4oda10rQkRy+ZdqlJV+MWC5o4sipBra2iwJTom/RoO2Yc2nD3f81PUyyO307QR
         /jh5bvjMi9TIlmDcw8ea/jBmP3X5Huncqw4xHoRNKVaL6a7CjTFE/2UCFDI2zj9hXiXO
         JC6jgL5romjxj46pc+EWHOz9QlVj64+IwQ7Fza1qk4nKN0DXFVv+WpJfC0RPKWqIzBpt
         p7ldIUNpJRceQf2+Rwm+ju7CjE7lfDmC7yc1FGJubM1RXX2o/kexTCvjrAuOM1DFqU0a
         AAU08zD1mM6GAGHk5wj0VM4Qhm1GWqFrRo+E+TfodiYgkoxGMiujKTJPTd9X01aeVboc
         MeAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764220310; x=1764825110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lH7KcWGBcyMFUXjXeQ0ZgXTh7zF56Hw8Qv1tMObDrw8=;
        b=RIkLNZnEWALdu/HbWcKtC4kQQR0fAFRdyO6tLIl4SQlfPhawS7SEBF2hnskjcl/098
         1d30JRpBbKyKJztFisgHs3etznQp9MNyqZd+G0JiD0QgeNpVUPGP1Soovs2Poh02dX0l
         cDqXPpGVQF6JPq7CjjmKxgafqZ5+RfGwN+PUJDli2GlLv/lPUYj0K8DU4uHCf+9obF1z
         QMTilBFeETaNhz5hkEzppfWm4dloQC05nOFjs2ugx5tLmcwmC7yZj29QjE/duW1vfayH
         iC5pTX2ZfoqX7OLJNEHpfdg3ULWb8Wumg2jjj4Tk40GwuLb7PvHDkk0ntFm/NogLHxOF
         9spQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIXuLnH0kjAHBUIwLVfIV9ZVvZ3dKNGqExfVJ/Br4uSejAvw1FTZV96lYm2gn5Q1AQDppE438XBA==@kvack.org
X-Gm-Message-State: AOJu0Ywp9Ub54BrQCWZlOeoJMFQgUnrWy2iexX0AKun+0xrVy4Va6E86
	nbkXfzhsZWJTb1QzqJ/1kybn6xAc6GeCsVTjwmrHGZdmuy3FpgHZdqeF
X-Gm-Gg: ASbGncurvoatObihLBmOeK+tdKGCRbr4kVQvM+G1e4kKGiASZH6tPwcVHVQrQvwPU7+
	KSooeAh6DpaiVsRTtQRcZvn/oqlFMon3/Nu2xButHYRvBhBx+LJKSUSL9+ieMNGrhOyHHuFidtj
	F+2lAgWqwR8Z/69Uh6QNkRCN9JSIrRoSTRZSap+ivM9vUrtHjUO7WvJE1vaYQX+rjhLPINLJl/Z
	nPe7F1pjWcKjAI2VSZ6yWR9JkJHo6agzl5bOQlTN9dHupY8afQkLr9PET6yj7z5ICoc8OcmVZMK
	DbG6ziIwHlcVIVDtTLpGygGA4IN4oM4hu3zjzKvKIL6AiRwKTHlC656Ipr22aL210UEhbXj+hvO
	OwGoaGywAzd4tI4aMFl3+BQxDpLTp4RjA9nwC34Y1R+PFhHdCoViSQQtUBxjgHMaDgwneQnAU/X
	c0vBPOHqfWpjUL0rrDGT2Y71Gbeg==
X-Google-Smtp-Source: AGHT+IHNWlOwlS+0w4rINsUXZGLEAulPrevlqrPihA9vZwY8xNaNEfoM4zs7C5Q7zgzN5GDxf7Kgmg==
X-Received: by 2002:a17:903:f8b:b0:295:6d30:e26f with SMTP id d9443c01a7336-29b6becfe11mr233126345ad.22.1764220310214;
        Wed, 26 Nov 2025 21:11:50 -0800 (PST)
Received: from chandna.localdomain ([106.222.232.43])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce442744sm3590715ad.23.2025.11.26.21.11.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Nov 2025 21:11:49 -0800 (PST)
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
Cc: david@kernel.org,
	Sahil Chandna <chandna.sahil@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	David Laight <david.laight.linux@gmail.com>
Subject: [PATCH v3 1/3] mm: pagewalk: simplify hugepage boundary calculation using min()
Date: Thu, 27 Nov 2025 10:41:28 +0530
Message-ID: <1e01c12f7666ade41f5f34ada24ad3de1087454f.1764177933.git.chandna.sahil@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1764177933.git.chandna.sahil@gmail.com>
References: <cover.1764177933.git.chandna.sahil@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dhcmqbtk7ko93gahkupdiis6u6fopp3x
X-Rspam-User: 
X-Rspamd-Queue-Id: 6113080003
X-Rspamd-Server: rspam09
X-HE-Tag: 1764220311-119637
X-HE-Meta: U2FsdGVkX19T7RG6Er0dsAG5ZilNJcP00U86xymQ/bpD/XmJYK4fzwdkVv8oI5/aUpfOOfVP8LUdFELJ3PD1aaH7+OqriSUu1NH7eG1bthTZ4PL3buBOQr4FNG++dnFQnia8+i8dLd3R9K5S8ZDL7Em0EQbtTQHqdBAfNv03HxI3C8qmu7HY2Kk8NuW6/EuDl2cwUMV8km4bA5HYqW7oTN1tgCM6hI9qEbXvEeRa29BXkkDc9JVFiZWgLnKeZX02+3pZs8XMrSb35MsOxh664+2g2jTyyW6joOfv+Q3FL9a6jeuC+CV/SJpvADXQaJ1R+KoCsKeAUQI9E/4Rh7LHJm0zi3+XUY6V1TKj4HLVCfh+WPBRihjiPS/bsKuBjHwYqL9XygEM33tSYEgajIsQzFD6jNgcUomakDN5Wm6KXD5bW5y0l2olN54yTb2+9s8suu5c6Dxq4f2YAbyHd3eV1Dubaw7c2B9y+DuUHMxwLXB5+KdnjaumQHk0EH1ViV7UDPjREQWiLuPQeHXnh3bE6wFBUgqwQ/x7h6j1RLAvvyxlWdlmKDV+kplj4AvzinG4/ceIoqVDQpeeUoRy61daJrl19v+hKL+44N5MSzVZj34pkQbgOhuQYkZsgXMxDEO6IqqsCa3kO6fHeW+MkJOGGVjMpWBJCZqNMaCeBQkLYa/oXO8FR87cBbsyBTX60Rba4LeSrQ9zh2fv7xJ/0SOg7dVnxAHMc5NWcSy1Tq0xftrsDeu/eMkIZ5PbI25ppm9BYJ15PTlaEskXe3hVElUEVYLcShLAmwYleD+pPdqrjHtHEbUg5k0fMai73IWu9n0qVHZA/sk0lNOjXgebJ+sD1USn0HRM3GnuqKuY23MYm2VKA8SXtNdTT14e0urkYpndSG6dY2tT73fR1o/5CpScVUlLpE+XrZ5HZuDZ8RV0ELR+6CRwY307iv5YCSHhFOjnxvtX53PyuskaunIuAr+
 W3kW88Lg
 kPpBNqk61mSyQHnFH3hn/wWdegf8yXQHKP6df2S1t9tZS8/ZuAXAEe1tX4NQCiRUbgZFZKIZPzgDz4cp+QqyPtNenCUvQSqjkuPXtssX4oJqXdU02be8uxCcbO4BMZV2qwjJWaiPgiAICWYqdVr2ouIGxePjd6ns4DMm17llLz6G24ixlgZvuOJWaP14frryQ0vYwn55udmAiqYshOeNGQ+EqaSOQX4CVbVgRJ9odfaWwDfl9MWDQpeZqyE7ctZ8F9xr6sgfii9AZjvZIINeQeBDdKVzD5AIBzd6zyu3vNdjdG+HGnMYmG2JlY+iA62kHZgXulVcKKZXg0xtgHn/a02/JRI27U3NBTFKxW+xAtsd3O4RPKfjQB8F/cNTqdVskbFX/C5LcZAp3EQOFvJwwhum5s+qwR3lN07gkWCNdbmpFOeATGL/OEHBpHF5904BkK0gmHF0aZe+zyR6zuVzgAiEMdGAX8IC+iOfm5iBBlCeAMcHpyCL4dIClPvCWi/tSsOBsIbF6MzQ6jMFrgQQxUChnkZ5r0NDbwv8Bd8ru34EVSwXyo7WLO1qDo7jP6ybjHzEQwHXxbmN/XZkmkY24dk5no22IJ7I41Mx8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the min() macro to compute the minimum value instead of an explicit 
ternary expression. This improves readability and matches common kernel 
style. Also change the return hugepage boundary expression for better
clarity.

This was flagged by Coccinelle
(misc/minmax.cocci) as an opportunity to use min().

Found by: make coccicheck MODE=report M=mm/
No functional change intended.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Suggested-by: David Laight <david.laight.linux@gmail.com>
Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
---
changes since v2:
- change the return expression for readability and clarity. 
changes since v1:
- Updated boundary calculation of huge page range for better clarity.
- No Functional changes intended.
link to v1: https://lore.kernel.org/all/ff24b3c573b766b187b55a38497fbad0a319b9f8.1763227530.git.chandna.sahil@gmail.com/
link to v2: https://lore.kernel.org/all/f802959f58865371ba1b10081bced98e3784c5e4.1763796152.git.chandna.sahil@gmail.com/
---
 mm/pagewalk.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/pagewalk.c b/mm/pagewalk.c
index 9f91cf85a5be..9fd59d517f37 100644
--- a/mm/pagewalk.c
+++ b/mm/pagewalk.c
@@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
 static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
 				       unsigned long end)
 {
-	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
-	return boundary < end ? boundary : end;
+	return min(ALIGN(addr, huge_page_size(h)), end);
 }
 
 static int walk_hugetlb_range(unsigned long addr, unsigned long end,
-- 
2.50.1


