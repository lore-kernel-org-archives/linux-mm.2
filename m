Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36441CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DD3C8E0013; Wed, 10 Sep 2025 16:46:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78E5C8E000D; Wed, 10 Sep 2025 16:46:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB688E0013; Wed, 10 Sep 2025 16:46:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56AF78E000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:46:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 028F658336
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:46:18 +0000 (UTC)
X-FDA: 83874523278.11.B451A08
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 29DD940005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:46:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YWYtNtJ2;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757537177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zdPfGCbmStLnf7OkwFRjoXPyuHAb7oGF5r4POmSHGhY=;
	b=ka64v30UvekiP+I51jW7Q5kEGHhrCrwUv4aKGmZ5NUOHMq9NIxQUTsrrLyLPnIUOVz0S25
	SekbqrX+0shEaNMvV3SGQO6bsp/qaDmY5KWOS1lzvBRawts6HMXW9ijWUuPJnsLQ3yhRt2
	P76P+c8LQ6HdLrm5DTCNgfl653BLlNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757537177; a=rsa-sha256;
	cv=none;
	b=gIBBzdtfpmhhgN4FqPvABxeqPQgaV4Hj88tp4cMdv09auQc3DCWjji3k4mVPG7TYY1VoPx
	EEzb7hhlXgJD8Xme03DEUZYtne2Xtw9LjOCY48nOrGwMJbYAa7us++zHCNIMU4T96NJNbS
	0WeNiKik+c5R5BmELjKCrW6qpNgv+i0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YWYtNtJ2;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8126c6c3564so4584485a.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757537176; x=1758141976; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zdPfGCbmStLnf7OkwFRjoXPyuHAb7oGF5r4POmSHGhY=;
        b=YWYtNtJ24K+wpfhl3baKF11sm8LleYrM7/Zjzju4T/cxB4Oa2InFHwl6vBGtkbFfgG
         7S1g9gS0NSd8VlGs9oBvbxsdXEbMwUZlIXgp50J/tp1pXuMBiO0C5AMCWlNc5qH0kNce
         AN435Jq0s1c8HqtAOhKjOua6NGimZFJi2LDqcbCsILDF6uiQcEnBmDfeHCV73w+M6aAy
         aeWdiJej2m6PkFfvcLC5NxrPzJ9R9XeftvvhyQTORjzVWZ7u0ihvuusgSZX5I/0uq/8Z
         DIineSXC3hH4qhqsGcL1MptNTeqm9O5yxxvX8wbIvrm5Ih/aXS56C/J9bwnJcOs+1mHG
         70dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757537176; x=1758141976;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zdPfGCbmStLnf7OkwFRjoXPyuHAb7oGF5r4POmSHGhY=;
        b=c9VMg6DnMLfC9rxBsH7foy3SR6pe2tl1+QUBw6sxYjbWGuhWXnuIO7JhN45DlPFeUp
         H7bLC98V7qL81iohmeLeawVpE6BtW01psyM9Ks8Y0KdUnqFniQ7VFQmkgqm8SzNn+lFO
         9H3WaP5xJGJEovefs3a91zGQs2Io6f9eFichxTcIEjRVCTt/+pqfMvJqdHnRmZZRHfGJ
         +ZJFxADzGkKLMsClqJk6249e2X2kw7xvbGWCohtg7QzjYbHF78SSQaZgZ0WituEdpXtZ
         r0gdBwJsjmOuaeIy5UTEyRp4c9HPs7kkD2Y98RGBitHZvdYAGSSHsxOKFl6Ukbkqu9gw
         aQUQ==
X-Forwarded-Encrypted: i=1; AJvYcCWYTUeWkDFQp0WjEnwNB+wlKEPlw1Xq7bsOnkHD5DXIKA/3z5McUxlJEW8uVhX9DvfBmullYltzxw==@kvack.org
X-Gm-Message-State: AOJu0YzczuBuC2ehZ73s8JYB2t2hh2u4zT3PUQAZj/VguRyPv3LcpRn6
	f6cVjZ5zwVeIvWbi/adhreijwe6W4HIDnfuNp9Ifmy0Ol/qufMh4hyt46iiE0A==
X-Gm-Gg: ASbGncsv7giQP7SrO/oWnexvY43ZSN7doU9yMHKfB/m/c8xZJFQmjvvrCbEKrTdrP2T
	JfJyTLEqLNpoOgrc/t8wmSZInELATeeGwourf3/Uh9QXLYBJIxHBBzMhH6L8ATbjLsbF2hl8RRC
	zver0eXta+nkjJDG4LHdn3e82/kLrEGWxpJrfMHXbjGkPpU3t86OeMELB/Ty2N2hMNAm66TIaeI
	PdztU7eoc1vK+5+GXKN4Nc19e/gcxcru5Z8a5tbfozPcUV/jzFcABqNg6w14kBP326D9xpQZnuR
	csRpaxZEs3DmPfJcYvhgP+oWOcaUXNUouRI3hHfG0BmAXIj9ZQ0G0ExzjWz0O8jUQPtYpRgs0mj
	2ap69dWBEZ/+aXhl85fQ=
X-Google-Smtp-Source: AGHT+IEyqefIg2aIVeybWhllIAFyMXyMtJhBmm1X475rnhW0Aevfer0/jPOsC0mHTu8niZEnKw8P6Q==
X-Received: by 2002:a05:620a:4624:b0:80e:f187:7fd7 with SMTP id af79cd13be357-81ff74afbe7mr152223085a.36.1757537175991;
        Wed, 10 Sep 2025 13:46:15 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:5::])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-81b5e5c0079sm351700385a.43.2025.09.10.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 13:46:15 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH] selftests/mm: include linux/mman.h for prctl_thp_disable
Date: Wed, 10 Sep 2025 21:46:09 +0100
Message-ID: <20250910204609.1720498-1-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dsu6bummnb1tho9ihs6cbbtm4u5d8ekz
X-Rspamd-Queue-Id: 29DD940005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757537176-247673
X-HE-Meta: U2FsdGVkX195X6BuO2Jx/dOfi7id8zin1cKUbdQUW9nYYeBgl5xdeyhqbY/UfdOOtMUJhH+0IoYYTK6cwtU/ZlASFW6ddkP1PCUnBpwNyF5s4K8Crr5dmYTC3UnMb2nP4x4plcb+orYElZz9NV7j9F5exGhR3XPFy+lwyYyTqHOt4uNPX+FQbhjAWZ1U1lQH32alpDTrxbVioCE/Zk1EaM3Qv0DXmMxnQI45S6m3d6r3iF6zfP6BsyG42fCl3diPQnl1uG1BAHT/P7tQb7TVmakHIh+DBsmLaC4rFgSNhR+r2dX4f3YAYlqVcbz4hBSHMIxIv2m0AcFfv3OmrpYucvyXxVqb6vDaHFQGvE1ovrP3LEkEd3t0A9xS81grhC0cOxfDui0roz8aNo6DMp5WJq3VGSsK/frFjI3u08dDPgq/tVy+MVeLBvl32FGIKhuze20klVDI0MJ2rM7mlPAc9nTNnfD/gFNODFDVjABdabI0Z34Ij57WKwB/n5cskK/NH1TKbymeYtGhX0EysCQRJ6PrSbAoN1q6shRmiiZ5/ggaJxWZu7dNuFivalXj8LR4d4CmnNoxLC3luBLgQ7RbtFn5WiXgZCJetLvuHicSZmLYAdRjc6KC43FaSOlEiM8h7nDfOVsfikH9/ykJd1EhUrVkkumxcpIDdIXDE5h/tPwhY/kJoi4cYpq4e+V68mCAccvasDyjCBt3tKKRTSgWKINkgpc/HxZrFY1BHZ5d8YeYxtTZyR7NeTt8tUgU/B0SNR1RIIc+i5VrGQ+Q3e4gsU2PNdvytDJsIDvNFDEHrqzKW87wr+KsA6ZLLC3FWwlybJmKih8Xtxt5G0yGxRS2VUI9q4zHAkxmHDUadUKeCaeFfXK87MYZYHKqRl9p1eY7qcGAxPbmAtPWdxjOg0p2/G0nDBoty3qY507agYnExt+D2H52cPi04MW6UMJ2IGLLvv3Q+j+tZd5tjXggT3r
 0fTEoceM
 GulROJbTnLo5qtex2TbmP72kpTi7JpybYoBL+o/35RNvECp7l4BqefgHvbjP6eD3CuGFWhe6fxtJfCPR9/eXBDspM7ofe/EpdUzePLF0yNzTUmso+cRrAR5T9bkLU6v4JnrJYghEHrUB8j5DnMUkfdHY9tJD5ldfC8Gcd5V5s11d9RS40KyipaY+mVJ4cpfsMlLKxaBu2EiHfPQ63c6ZtwuKcX8HDMQRb2VLqrBC20SKOs8NVZppYW6VFK29QGwrxbCrfM9yA9jsQWZs5JdMKYkVVsx1SGFmQpHBzDmAsvIsEq9TTF1d5mLMZ7WxivdvSMneSaXzj2QQfonHInLwiElia82JD2WeU4iw/Nh2ZsGFdH7TC475JVqfL/JkwHpqhQJSJI5nULr/qy2B4EnsTsGSr24BCMNNeasqcTAEmB9drMO8IooZoBCxkA6Nb21TP//AfT801UVKEEiKxLok3tju/6n1YYZXrp0uNOoH8oY7lypWOHpzzSTx3DK6DZ6Q2Qg73eJ+YzAXuP0eF5Vu6AzNxiofLq1JFI8RVifpR9BZOaGOAWckc36mKC3Cu7+hqa5bCi5Us9ykNYuw1PwrksUeoELLixNi2uP/ENbskcu/zF82H/YSvk2Lh9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_COLLAPSE is part of linux/mman.h and needs to be included
for this selftest for glibc compatibility. It is also included
in other tests that use MADV_COLLAPSE.

Fixes: d9c7ff4dae62 ("selftests: prctl: introduce tests for disabling THPs completely")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/all/c8249725-e91d-4c51-b9bb-40305e61e20d@sirena.org.uk/
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
---
 tools/testing/selftests/mm/prctl_thp_disable.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/mm/prctl_thp_disable.c b/tools/testing/selftests/mm/prctl_thp_disable.c
index feb711dca3a1d..84b4a4b345af5 100644
--- a/tools/testing/selftests/mm/prctl_thp_disable.c
+++ b/tools/testing/selftests/mm/prctl_thp_disable.c
@@ -9,6 +9,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <sys/mman.h>
+#include <linux/mman.h>
 #include <sys/prctl.h>
 #include <sys/wait.h>
 
-- 
2.47.3


