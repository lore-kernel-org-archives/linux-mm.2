Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B0CD0D143
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:49:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AA56B009B; Wed,  7 Jan 2026 11:49:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA186B009D; Wed,  7 Jan 2026 11:49:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF936B009E; Wed,  7 Jan 2026 11:49:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D968A6B009B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:49:02 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BBF416048E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:02 +0000 (UTC)
X-FDA: 84305752524.09.A1CB1C4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id D6CB1140007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:49:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804540; a=rsa-sha256;
	cv=none;
	b=IVMqdAXnucvoiM5bEmNG6zoZPmhYAUOMfgNiG2c4+mjumNiLfdSInql48G+tXlbdIA/QKa
	FcdLAVdIWvRfGupoA9kfAJf0WUoA0hQQceeGNqLRfYKbI+Cn4389PZjAIrHfJQzTUSc5h2
	w0vjAloWEipqaBElg9Zu9UM1LraNiJg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=e9VD3ConAV0G3Z9FLavk1xINh5AKMakAoe4FLlOz1ss=;
	b=tz24nedcaUGTHv98ehx6Wvs5uZYrddThxtsq9lFCeafmSLdEjH5xcXzYa6mJDnLdYpvvvs
	mgeoATtMuXWH/KtZZ01WtWImfCJPhGOb6LbutUg+SHpShDvI6s8voRvPazw2Rvr0uKxFV5
	4qhdmCDUHr1GHFVZwMNMRfnsUuhqjus=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98B71168F;
	Wed,  7 Jan 2026 08:48:53 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 19AA43F5A1;
	Wed,  7 Jan 2026 08:48:58 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: [PATCH v2 6/8] selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Wed,  7 Jan 2026 16:48:40 +0000
Message-ID: <20260107164842.3289559-7-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107164842.3289559-1-kevin.brodsky@arm.com>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D6CB1140007
X-Stat-Signature: ujyaf4jnp36939a5kfhump8x9hhsqyqc
X-Rspam-User: 
X-HE-Tag: 1767804540-513551
X-HE-Meta: U2FsdGVkX19/J4lbCmgsHIT7QVuJfSXYrczl8ctbW0iz4Z5Oxc1t8izGj0oPqX/l9ubRzk9p8/PwHS+cXx8xeYLeP8cywhwbrebAW29ZBtNn8OFiv3wN7yY5IfT6e4ALN2JpmV9wCrfhux90yL9pEnkUYHLdWhvC+OBmg3E28ZN9/DW5GBcJ+GhscuHyk8iMP2hpDgaQ5s+ojvYmA52aBkB3u7gVJLEtkag9Fl2qyhdAIgDZzYMwc5FVa6szBbldXVl4IHxxogrcmgbIz8aKxLY0UsgDxXWY0woHaFA3GNC0KFAN+qLT8zeaBAYORL6XNAeGr6NmzqjgsfUwJ+toUS/apbwxIob5X+z+nkqZxw6zIdPCd6f0cBn7vIYo5aY7CZV+ZDSfekoGCgXLr5hNOzcfAmsAcTjfLWOc6L/A4cQq0ApK9SPMI7+WxpoRbIlJd6FytRDxDUl681qu9lfkVXCTyD2vTJrwswoNtdogHnBycFfHha0RO18wwltQhtXEXPIIIJ/bUmy6VQIBmyUZiBOn8ii+10+JWt0LVhEOYpMNeZRrfKfTwnT5o1igVA5fR0OYH0+DHKTv0CdNfLiL3PHcrnQTfGaP85/2hIH11d1M8sWwTJmDHeA7GnYp7PHVZ4xJetN9ZIuKhuI6LpsgwOIMqY6f45ofC1apKYTr/ixgxiwY8Zt4yGoDwEs6+RVGeXWAisEwbtSOote+hjmilEPp/pwy2dpxi99qYHPjOFQ5krAx5IFp/tJ5J+CQaCj1+IqmR/9yK3ecoa1VnxJ2ugpx6XnK31pRcHXrk6JBvqT1zryzl6uJ78VbO6aWEBFrLjdkpMkp9gn6rM45nNlMWH9uFHe0ccJ17AmDtFssDm3AIxNqk2wBDWvWfYwOhkN1Q+22qa0w6RS1Mv3VoWjabmMk7gU0RTz/6y6hoyDmisNAH+Hf3W5fzEahiOU/WI1DC/4Zz4jqRGQSBW90Ou2
 4n7eVGlH
 Df/Zcc0sGIEJnK/TX488YkbHbCv9Lwouc7XIr+hZm/pXAO7oArY4Y+bmly3F9VsecRtr2xwjfUcpiQL4f707x8mujg3UmMXgSnqG4iAJ4tJxuF4PTd1D6G2ypWCpN/e52crucMhOd/GOeGrYOv0OPdcjnZLDtM+LazXVEb7TvWw/Lra/hRSiV1vIgICYej2qBwmfslbs8Bw8MQIQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One of the pagemap_ioctl tests attempts to fault in pages by
memcpy()'ing them to an unused buffer. This probably worked
originally, but since commit 46036188ea1f ("selftests/mm: build with
-O2") the compiler is free to optimise away that unused buffer and
the memcpy() with it. As a result there might not be any resident
page in the mapping and the test may fail.

We don't need to copy all that memory anyway. Just fault in every
page.

Cc: Usama Anjum <Usama.Anjum@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 2cb5441f29c7..80d7c391f8f5 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1056,7 +1056,6 @@ int sanity_tests(void)
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,8 +1166,7 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	force_read_pages_in_range(fmem, sbuf.st_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
-- 
2.51.2


