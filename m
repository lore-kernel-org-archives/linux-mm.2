Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4057CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC42F6B00D5; Tue, 16 Jun 2026 17:06:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75306B00D4; Tue, 16 Jun 2026 17:06:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1F06B00D5; Tue, 16 Jun 2026 17:06:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD2D66B00D3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:06 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B45361A0119
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:03 +0000 (UTC)
X-FDA: 84886108566.04.7CEFA12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1488020007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:09:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwyeCJDZ;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781622542;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0szVMs69Uu2eAbLCAOXCLc5i2YnWrEQ3PmDutKfaOgw=;
	b=ZB+Yd85UcQLb4mqCyGbY8WpWmw82se/IMGYz1aEWGI0MK+ovkQL6fkST4CDF0rRhYCc+L4
	k0GtPzXhQ/2hdi5LGavbtXbLhWq67iAIbmBYhGJdZbIXwpg2RwwPIi6kruPjwfEeHx3ETD
	gx0mku88eUF0SXHWkdYbeb0GYjuFqJE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NwyeCJDZ;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781622542;
	b=fdGBKI3XfW6dETMiYPjsnqtidSAS5kEfJdCpA0MiRoE1G5Nfmq5+88f6L9/W80aN523HGB
	pDovm9f5HoT6eDIzrw/sTqt3GOEKsqHIXdU5dYlEJ7dGtFFM/Hcg+8/gD1Dd9k1jzxRf74
	/gYZx9zHlLna6vo5PZxfnK4kgw4hhxk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2B9441A1B;
	Tue, 16 Jun 2026 15:09:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549761F00A3E;
	Tue, 16 Jun 2026 15:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781622540;
	bh=0szVMs69Uu2eAbLCAOXCLc5i2YnWrEQ3PmDutKfaOgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwyeCJDZzBpee8okpdb2TWe1r4JVbWLJdLqjGxcHtHjVhvyGgwkm6g+7FhSg1YNrh
	 o3VXNGOV6H/r0kPCTl8lKhSkoesda7CUC2JdNfYaLZ3My3pfdkKxkH9ZoB6Wc5KvwT
	 S/qnloRzUcZbcasS/nv/xWEr+zbOzOjCHsOVo1Q0lrAYPC2Th60vVz/g9IsCHcfJRc
	 oAEnTQbbiqbpws2gOkLbeZWZthdB1WRN2oy90AZIobeCdUeZVVYd7Y4J89Ez8oglMZ
	 ZkeP613l/DtcGsYhI4w072La1njLE10y+HElgyg+iUgeCeLaOW+FcDFXccbnV/uyHB
	 sdnoVxYmAJinQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/9] mm/damon/sysfs-schemes: kobject_del() scheme dirs
Date: Tue, 16 Jun 2026 08:08:37 -0700
Message-ID: <20260616150844.88305-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260616150844.88305-1-sj@kernel.org>
References: <20260616150844.88305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1488020007
X-Stat-Signature: g4wopf1i7yf4gsi7c1dxrgikdczjzxdp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781622541-830064
X-HE-Meta: U2FsdGVkX1/6MbnqpSKvzPjP06IjQ5edfdr1k5jlld3E4iOiWpiuEOoFTbZtYK/2Uc7ehD8Tfd5rpmqlj8UkhfBfpJqILUgke6ajt6O0SWTZnNjqfJHZCiOD9FuixSXuVwovqzsMccbZk4ABrLOk9Xcbz1PA0aTm7uPWN901GM/f319V2L9Onc6nWVCzQAuLbqmTjXaFysAv/V/oIZ3IZEfGzGkIYOgtYaeJk2sReuFea/JrhHSa6cFvZlntEsGG3CWtxp/olmznqxou5Fhswz1bXyn7/5SRHG0iDUR7aoQYN6nRALHKG519ALBFiGmdA0WGWUqrmFdyRej9IJXQZHv/CI/v6IvAQtCUrguGbHnsC83LvOZ/YtDXs61msZjZkiLN6wXZeGnIfGwu38jtVW+HPVCKumA5VEUdVTC9z9pi41fTNpdn7bEfaRWXP0VPiIXEaFR3Jg8U1lcrIV8cJv24FbZgvSFO9x+uVq2qTdopLVVCLe4Mbn0LE5XGBUJtCqS7P8cU6cSgfFTaRO3W6GHe798EmTs1L6QXYP1L33bYzAxL7aucNGv1eqde8B3Xb87d4vQ71acWFw/aPG9hLp/Eqzk50sKToXwdhgfB7syCePOLuFlcVwYWZITYNHDXUbm2gZWVMSPPND8+RONkdu64sumq2rhlg0jThN0XN+Ho7GBM/xxW8ykiKlBltb6X98tbx17OPN0Ei0F8BZ13sRVSzwtotUaNgFaHkRkU9J+m0Ep9HYsI6sJDabFJ9eXS3Ofn1BcI4NBWKO6D/O64mi4nZEaNXEuofSRLh3OdVGuLaGES0AE564aBYYd7bkv6S0IW8RZ8uAJgB646OJ6mOAsXbAWDK9260BZgDDYzXKlBCcEfzai6rBEo0tUrWVKSF9V5Dj7agxQi3/CweZCX7o+rq1sHxKlRby4HR84QFEoIj0ku4B+Nh10Kpq7qRLBEhLy4HkFVtzjtyugYvUc
 COqOYuPQ
 AahRnVa3oRQlHyMGEWJB5B3ChMAwaUeTbgFyX9KOrWgTygJaO6MswpZtT75G9K7Zy64ROK9+BNEuANl1RWfUoQVvakl14W0VVNUkuuyZmPRrz8zQj5OVeHaQeDRRdT53mHEYcqCXluBvgnR+IzKcetW6QpjMNgpCqvibtY3ARrRfspdrazVtoJ9ZNRNpiqbNmCaz5PQDuODhs5wuMRajSkkYg4OVjy47bboEqJ+GsUZeMNu2SuHxn3svtZTIpW1QrdgDqIRpUt4OuYWajTX4z/iQK7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On CONFIG_DEBUG_KOBJECT_RELEASE enabled kernel, lack of kobject_del()
could cause directories creation failures due to the name conflicts. Fix
those issues for scheme directories by adding kobject_del() calls.

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f3..37cf6edb54f17 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2686,6 +2686,7 @@ void damon_sysfs_schemes_rm_dirs(struct damon_sysfs_schemes *schemes)
 
 	for (i = 0; i < schemes->nr; i++) {
 		damon_sysfs_scheme_rm_dirs(schemes_arr[i]);
+		kobject_del(&schemes_arr[i]->kobj);
 		kobject_put(&schemes_arr[i]->kobj);
 	}
 	schemes->nr = 0;
-- 
2.47.3

