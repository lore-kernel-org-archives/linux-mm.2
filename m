Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB733CFD365
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 22:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 448546B0023; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF576B0028; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21AC36B0024; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 044F96B000C
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:54:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 243AD1405EF
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:54:13 +0000 (UTC)
X-FDA: 84147005586.20.66030CB
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf12.hostedemail.com (Postfix) with ESMTP id 544A940002
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 22:54:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SFBUxJhx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764024851; a=rsa-sha256;
	cv=none;
	b=VVSkvQOBMnSjOurN5OptsHUvNHsvEEgFIyvOlRcf+3n8iw7C3BKh6xQXt5KjAIuaJhXfGE
	EkuEOAIrKEMS0NMxG2dsANIcQVqf2I2YwZ/vzJ3S4GMACYJnQtMpccgj/xtKqlR/womHZ5
	F7xHh8NVs5CVJNfXxjRNqli3podFvvE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SFBUxJhx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764024851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OkPGFrQcQy83MwqnxJzEu9f7EPjZBBQnl/KZG5BmF+o=;
	b=WV8l0slX2x/2CZ5l9/xmK07f1H49OlG+AHsMiX/5OaSf27AjCfqMzf0/87iJJ/09rpVRVb
	5K+f2axcWdD+/5KR9Khi7tFCfSq9pqJ7bmKpjJKzlMXCT1cgK7ytlyxzGmMi/1JYwJaHpp
	iU+7aP0pxXvM6DQp9WYRurbHTTSXuqI=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-640d43060d2so4211540d50.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764024850; x=1764629650; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OkPGFrQcQy83MwqnxJzEu9f7EPjZBBQnl/KZG5BmF+o=;
        b=SFBUxJhxaqYLz8BpA/Ek415UMLLnzqji/qWU4xPBLqyLQHbIgCzNKMU8JQH2cmu6TH
         pNpSCiQyxelAKTeHf08cmctT19GQwdu3CKvPLqnrkVusnDYFEDmJB7EpJMP0YIugRAPm
         fQNHmLaEmVVQtJLA8WZe6WfcvvhRZPcZeXiICzwpAnYaqhP2G5HIURPR3XNYd9DPYF4y
         G330mM/OhLBR98PQNBx60X+SHPIARIcPKl0lyvh9cdQVl0K1UJQBe2vvDm5vFN6DN7wP
         qIk2HQoggH9E0rsCZqJWxlkY2H7Ljdj7Dk5oys40lIhuNmC04ivYZAka88UpgFDvLay7
         ntVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764024850; x=1764629650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OkPGFrQcQy83MwqnxJzEu9f7EPjZBBQnl/KZG5BmF+o=;
        b=UZO8fHk+3kaPlBPYd9pBB4sqiJLCnvKD4+3ayYLi80x0wvvDegyL5j5z7IOOcoqDg+
         n3CvgJUweBrb0UyaTEI9UPUSMUjL/bde/iQboFSBBz+1W1yC/E9bD65/knrU0ltozV1u
         XtAe7HkCl1DVuRN02K7D5qxw7XzZjKYOyTzcod1NDX2qQo/EE9LIn85zCwDqIz3BuB26
         4wPYaVEOVp7VyCP9NZ4j/LB2LfqVLJdR8Fhmn8Zg/4K0bNY4vhRoOnGKqtZ1aQJw3t/B
         /mnP8gLzBOdqYi/sKjd2a++9CNJKUvlhjKrh35TMfDNq48/1xzbPYv/KzyI6mmK1XQaR
         M3gA==
X-Forwarded-Encrypted: i=1; AJvYcCW+9zkJZ6wonIZ1e3QqP3WisAoMhnD6t7xngfQzE+8udsheC6jEOgKaNMIEtSCdM454pt5sb5ywzg==@kvack.org
X-Gm-Message-State: AOJu0Yy49obw8q/8Y1q7z72HN141GpKcbSy5giGfLNKfAwQYKLPUHCH3
	MquQCLKFTtFSImAoF88e/Og80SJ2ZG+tmYfZQaiSjWHQiCbmU9d1YdFz
X-Gm-Gg: ASbGncuVftsj3o+r8yYcetZj6jKxCwl1g0fFxRgT1XjfYZwwdrRbyhtavHKWZgg0+KJ
	IEPBIN+B/mtf3m7JDcPgToqcpdwX4OypzXBoxMvWS9UmcfIXUiibWB6kqnDe6zUMgK4I/3VMEnl
	Yztlj53tViOrmMhn53Fr/wqN3S3ZMnnbGheSwG96/xPr7d+nJrGAOWC3qBYlyByw9WyfqtKKNcG
	CcsIIsADmUy26Iy50iKkdhk7W7qTRuh7R2RCn+LMTrje0713/ziWk3wlbYKhKAByZ/OWWJW495c
	znWwfn3Ls90pcWu2Vg8BiskJmdcsHQwvkI+aLVFWohE/GLp1wXA7cnhwIFLpQrDpKBo+ds5Xiia
	FRbNx9KXKCkCzdFlR5uZ4lSYjooH0AqZ/Qc4PDSZDuAMV5QeP+eau/3ek/cwOoZZnXWb+9z55ew
	uKdnIYEJPm5TqT8drPIRR36Q==
X-Google-Smtp-Source: AGHT+IHQu+hk6/+e2su2tG4hNtS2lfQylKwKpETUyCBrjxURSXX4V7f1ntb4sZE/boplQjM8SDZYOw==
X-Received: by 2002:a05:690e:168d:b0:63f:b5d8:9da9 with SMTP id 956f58d0204a3-64302a2f963mr9451894d50.12.1764024850286;
        Mon, 24 Nov 2025 14:54:10 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:53::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a799278a3sm49039097b3.27.2025.11.24.14.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 14:54:09 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 2/2] mm/mm_init: decouple page checking and init_on_{alloc, free}
Date: Mon, 24 Nov 2025 14:54:07 -0800
Message-ID: <20251124225408.2243564-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
References: <20251124225408.2243564-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 544A940002
X-Rspamd-Server: rspam07
X-Stat-Signature: kmndxw35ggae9ruso5wkmh19c6ozbh36
X-Rspam-User: 
X-HE-Tag: 1764024851-366669
X-HE-Meta: U2FsdGVkX19vOmKaL3a3w4VKbPsk8rYZCNRtMLI2mqCWua4JZxLQ1c04UKRS++i/1L8Jg8IlBt9fX3pO9zXRxp79f/Bw40zEicJL2U9woM0Vl7W9RuzILdKPuN+8intVnl7gSdh5gGU6yg+JhQ7hWSBH4oVfjyhbuyC6oqWWGnsdQUQSAsxe0tWlMjJ2RNvhhc7r1mPX/ded3fkCpmkbFE1goXSnjEgXlaywmWhnQ23xL1BkeYshZs5EjyFGDrTgWjQVgnWHTtk8ETruJHhSsE+s31H1zFXeQ38T9Qlu4fiyuQFu8lic8s17GjubOdEcdxgmDmJHplMGIJ5r04940SzzcjzVx+GgqbtmRFSup1Oel99HIzjW/ZhAYIzRoQPRmxYbYlmOYI/QNW5nD67tZxrykECMs9cSTOneDQsKfot1bCnYGbGdRj3ViCsGMNT+10iK2a37MHpBqj360heiPCJVxJJi73BcXdD4Mti7zGhUGxYzw5A9dstOdPbeNv2F1ThdLRYYXO4LCZuehqTEc0PVEeUz5HKnHBAkIMTZza7/f+Ty+KMU5SidteOZriGlkIp2hFvMAfv+F56+5kDyJ6e2GVyjg4HR7LRuAOR+rFHg8MTlCz5VgIgU8ceXjqf9Dv6xwz2EHK1GPLmfKLxYWo+6zqBdvMGK2LdwARPluXPL1ozkrvfh1zsAmL7AHUddcqS4XhCIt9duVijM0EqCaSE49GubKHZmFxBWroU/WWGgtMZr+L544VQWdYaJMeKstPh6wbezEhnmuOCZuS0g+WgTsGjKlPFjiFSQpdF9Za5P4BY87NjqzSwkzIKhGJu1wL0DmowmgJro0GDkX8Mt20HisOHEnlW++vap4pOjmqVSH9bC0o7iJVjw0HWVgLE4rMd/nMi2f7pHPWjzI9ztLmLknLVzPvmbQgg72VwFePxTigW8hAvr4+YELoW/Peyp44FUUFGw4C11kTR8bFA
 9rJEWwQ0
 BGa9nt05HHEWPt8046LbZ1u8C9fmAVVXWhfTk2fCarqt2pqE4V6Lrrtf/xeDBOIHKYWzKgvKjYQ6iGbOh/h1k5rHbusIvVazTCAVhIHwO/rJQdoSP4ubyGUXR2iWhC4qrIoFtIRSnhSGWKBI8NjyguoGN/MI8pedvD+BqbRThKw1E5n4jFm4qcAWvbXmOs/TYrd/r7Nf0SlGTe1ucaXNvutej/RyQHRTgmRCttMDHRORM43JXPz0/3VyeKmtwXaQIUWzwROXxOT610il9JOiD5mU3jFvmUkb7g/M6rL14pvoiwF+TbuZbHBc+8EJ00S40cWN8fSg0rtyiJrpm+UT4e3s6WG1l5tL63UeSoe4BkjoNlmELRYbwSa6ojCYnK160zhRNDN4kdKao4F026G5qmSK3XZPI0/c9YruqYX4s0N7+7X96UCi+U8adjtq7pnU1dTiS3s4Zh0kq7iAeE4SVWBARR1xCEOBRdz5tNLqF7ousiHhX1LHp7c90yeoRi83m9olt6PmsiLkD1/W3lE+hSbtXLsD4oKIE7H29
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_on_alloc and init_on_free protect the kernel by initializing
allocated and freed pages to 0 on allocation time / deletion.
Commit 700d2e9a36b93601270c1e15550acde2521386c5 ("mm, page_alloc: reduce
page alloc/free sanity checks") removed page checking from hot pcp
drain and refill paths, and instead coupled it with CONFIG_DEBUG_VM,
debug_pagealloc, page poisoning, and init_on_{alloc, free}.

As the commit suggests, the first three turn the kernel into a debug
kernel, while the last hardens the kernel against leaking sensitive memory.
While enabling page checking is relatively low-cost and tying it
together with page initialization is not unreasonable, it does feel like
a bit of a side-effect, rather than an obvious consequence.

With page checking now pulled out as a boot time parameter that can be
set independently, let's decouple page checking and init_on_alloc and
init_on_free.

As a direct side effect, systems that have init_on_alloc or init_on_free
will no longer have page checking enabled by default; they will either
have to pass the check_pages boot parameter, build the kernel with
CONFIG_DEBUG_VM, or enable debug_pagealloc / page poisoning.

Suggested-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/mm_init.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 01d46efc42b4..59636d2c0178 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2566,19 +2566,15 @@ static void __init mem_debugging_and_hardening_init(void)
 		_init_on_free_enabled_early = false;
 	}
 
-	if (_init_on_alloc_enabled_early) {
-		want_check_pages = true;
+	if (_init_on_alloc_enabled_early)
 		static_branch_enable(&init_on_alloc);
-	} else {
+	else
 		static_branch_disable(&init_on_alloc);
-	}
 
-	if (_init_on_free_enabled_early) {
-		want_check_pages = true;
+	if (_init_on_free_enabled_early)
 		static_branch_enable(&init_on_free);
-	} else {
+	else
 		static_branch_disable(&init_on_free);
-	}
 
 	if (IS_ENABLED(CONFIG_KMSAN) &&
 	    (_init_on_alloc_enabled_early || _init_on_free_enabled_early))
-- 
2.47.3

