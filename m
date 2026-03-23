Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D040EC01CC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F366B009B; Mon, 23 Mar 2026 07:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 236556B009D; Mon, 23 Mar 2026 07:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1738B6B009E; Mon, 23 Mar 2026 07:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 056286B009B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:12:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92962C34D8
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:12:43 +0000 (UTC)
X-FDA: 84577065006.18.C6F0B7C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id A5BC540016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:12:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="YOljAU/Z"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774264361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZFeIWrGHjRim8Xv7+YHIDchaEbhGi1ADAz48lTo4krk=;
	b=EGQP9olXHLCSbse9A7Q63tZeekRFolTJGNjcL4qOojqPo19afNQQLjoMKQtthDeC6jve3o
	oXpZoZjcH5kQv4VdKElLWPRVPgwWMl9RhoEc9eVw3h+9S4p0Qb85USzfnMCg99fsyn9ei0
	SGaeEgPFvW/bq7CuEzuCZ0XpDoMf+tw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774264361; a=rsa-sha256;
	cv=none;
	b=XGRhDVy/5Ucj3+PtsTFx0k6owC3tLFbQ2jhHxQXF6EaayUoS/pnTKW3Crt2rAE7zlQU7Af
	jlAL6MHgdQzFdpwWX88/w2KnwdiIs2hlZVdN/q95MxsNlumoI4JbjiFQKX6w/BbyiQZ5Z/
	eQM5n/1qvFfmWTdUDbBTbSX4dzYKBkY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="YOljAU/Z";
	spf=none (imf07.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=ZFeIWrGHjRim8Xv7+YHIDchaEbhGi1ADAz48lTo4krk=; b=YOljAU/ZElMmKiNRgIrKyAPmmw
	R5twgqXYjYtfkQPRJyiAwlOynY1scOFP0tFCRAhIIB2erGUffmOitwbW3m/9Wr2VcDvFDYq8+SkS0
	f2zwCl6Kf/R1bUnznWchb9AE5Vppx7lVsfrXY2ABJRZmsFXabgddgZeTyOYYzIsILmRGbWby1noHb
	fqEUYMDSxto8EZydP2ty1FJyuDYYNPmCWSknVoCr/E8SNKZm8gBA/WsGstZrz372Umy0PzJ5UTnQH
	XsDf1BlU0xRFl23Qrm2WCso7gBNiJq71HOd705G7jnE/GI5kRjzr6CiiqwgjC+0vVkiNVXGQMm/Kb
	wTyLJqNA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4dCv-007UQb-An; Mon, 23 Mar 2026 11:12:28 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 23 Mar 2026 04:12:13 -0700
Subject: [PATCH] mm: kmemleak: add CONFIG_DEBUG_KMEMLEAK_VERBOSE build
 option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-kmemleak_report-v1-1-ba2cdd9c11b9@debian.org>
X-B4-Tracking: v=1; b=H4sIAA0gwWkC/yXMywrCMBAF0F8Z7rqBNAHR/IqIxHjVsfbBpIpQ+
 u+iLs/mLKg0ZUWSBcaXVh0HJGkbQbnl4UqnZyRB8GHjY4iu69k/mLujcRptdnmXWx9JX7YFjWA
 yXvT9G/eHv+vzdGeZvw3W9QOanUyUcwAAAA==
X-Change-ID: 20260323-kmemleak_report-a9a103ee0c8c
To: Andrew Morton <akpm@linux-foundation.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2614; i=leitao@debian.org;
 h=from:subject:message-id; bh=YVhCrOyKP8U5J2m4qj3vibyEe1/805eqdpLycoz/rnY=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpwSAXjawQejJ6O0nK22xYUeX44mgycAeLBIErH
 iNh53nhH6CJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacEgFwAKCRA1o5Of/Hh3
 bVoKEACXFteiy0LDw6XQIHJIVKZv62Rw8SWbJRcuIgms0vpyfrdd8unXMxJg95zu/dVeYuqHeSU
 1kzsiDBubWZP5FVjY78icJYKljIFvYAN8iTSxtm0p7Bo3bJNZFzNT3LuuFxn0Mz2VZZuyd2rRwK
 3REu3XCpJ9nwBJJbGOcJJULbSOBWLCoGwU30jwLdkAhUMB9yjWzM2HeOLMBYX/QAPfImDqUlhnD
 TBeYDe3v0tfIwD90cVsFK5XMX5a3fpmEs+XtUlTnei/wq5C6YFniupgVSIPaK1qXkveAWJydqhC
 aONRXZQDirkpVTiGgJINCd4wGGJZowPFGYfrFa2Tz8DIT6FNgMK2xcKkPQcDSsoXczffddQysQj
 GQ/iZTKH5sWJvz/hDLsqRaIUPKCdGoYzu89wWIDNrNXw7tVDU7vVcvOPt4XYbWjScUY8KwcfPYP
 ocAGxIIQg3MO5ZAU8CyOVANa1wEgqRDtUuoLns2o8W/8qBjmkKgWhWouZ7KRBQ4fFBEOT+bJM/Q
 dZiMrH/zyp53Aqqogq1lFlt8fpeBs2N877EBU4xk1ox9AsuQG8cI8m3B3f7Eg2X1Hmrhz9dfIka
 l3TZqMxbm7JtZxHOFufSN9U8ZVs4uagZ4OpA4Jr6wwvHCg3kTFtOjbJgOnYaT4KTPsJT8h7lSj3
 czqqTsVr9ZRyKvQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: cs1setst8arjbqq9aqbieomxbofofgd5
X-Rspam-User: 
X-Rspamd-Queue-Id: A5BC540016
X-Rspamd-Server: rspam12
X-HE-Tag: 1774264361-509806
X-HE-Meta: U2FsdGVkX1+sb36ZodMRSHYa23baePWub8un4Kl0ykMAob3LEH3BmDV9+RUk59NekYP+HTbkuOoj4RTh8vi0m7mxbeA9JUZSWEovjG17QIzSAC3nYG2TzM7VZYg4Lxlf9TqSz5byT1pUfqLkO8j8Fd+xHwLqOJycgfEuCVDGUM+/OB4un4jrsZdKGNSMDuC0h1d/hHn5fGmuh2Sih/9qyQZ7xVVFf9HUXxbIJbVmsVyn60UuttPPwO1aZunfZkEBwVn3yjMkHkDVTMp3OMoI6nz9mKHYdJOAEh/akgKqkpLGlr9Rg7+mAfnJT5AKWAl8D5iQdLTleHYlmxoXgGFCWD/PxOddp8wmQYlf30DgmFzNp5zPdvXGieaj+sd5rX5cwhOh1mSGWJY4GklGz+KTwEh3AQvocereWGAe3fJ3ofWLoEb11flYn64lqs3ODEBCeznZjskVv2lZLZuS2wQuMxTzUTejLZu8hhSdV9j6RgaT8qVhW3ZynGNMbKhbgTBHqEpyDtAG/bxNpZfMBhqxLjl0LXcwwaana8ofz5Bw03TJBw64+7W/t9YcVc1ZkPiboXheADtPwOhwKu8cRG1n2d/FFoXyqZGUdeQdgp7FNVCeXjJTOjwroScFnUdB/Gj8O4SIq+QJZ/T1VjEu0s7ezz/FluKtQOHTgfJqiIEYNofCwqoiymH7ANhxBjauIAdReLaZNUSTOwCgdYrGUAT5f7uL9h37b5q8TSSB76zwGzda6OEaPUkoo4Av4MwfWwSPQcIfxsn6b6Wc+El4OcRh6/j8dytFYHCTdEJz5xJHGi5hSHPEwtMQ6+LxVBbr9JEUqv4poocE/Zog2wjpcMLogdv09FOMQaBjI5E7GnUTIppYf9PdoYUcue/5mk7qE0RJ4kOQBrkaQrBpjZYU8Nc5aKL4VlJCLHctwF2NrUKGvWJh3eUTq4BlksfuDXO8b2jWgdRgY/uWXXKTC4IU2SY
 JFOn4CkS
 G7W2q+VlrnLVPrRfn0kDHZE9GIe4wJ9soz3LYc2ItSjB6vquLwylTr5SKYfQTg+hVINbg6tfgX0l6P71ULybx7U6YE7LrRUQoI3j9Tu9FT+tAi7REB5VIAJ2GmCli9pedJmy/qaI9hJNoRAsDqOGOIy6tNAsDVnsPcJNC55CvCceVwc8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a Kconfig option to default kmemleak verbose mode on at build time.
This option depends on DEBUG_KMEMLEAK_AUTO_SCAN since verbose reporting
is only meaningful when the automatic scanning thread is running.

When enabled, kmemleak prints full details (backtrace, hex dump, address)
of unreferenced objects to dmesg as they are detected during scanning,
removing the need to manually read /sys/kernel/debug/kmemleak.

Making this a compile-time option rather than a boot parameter allows
debug kernel flavors to enable verbose kmemleak reporting by default
without requiring changes to boot arguments. A machine can simply swap
to a debug kernel and benefit from kmemleak reporting automatically.

By surfacing leak reports directly in dmesg, they are automatically
forwarded through any kernel logging infrastructure and can be easily
captured by log aggregation tooling, making it practical to monitor
memory leaks across large fleets.

The verbose setting can still be toggled at runtime via
/sys/module/kmemleak/parameters/verbose.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/Kconfig.debug | 11 +++++++++++
 mm/kmemleak.c    |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig.debug b/mm/Kconfig.debug
index 7638d75b27db8..91b3e027b7535 100644
--- a/mm/Kconfig.debug
+++ b/mm/Kconfig.debug
@@ -297,6 +297,17 @@ config DEBUG_KMEMLEAK_AUTO_SCAN
 
 	  If unsure, say Y.
 
+config DEBUG_KMEMLEAK_VERBOSE
+	bool "Default kmemleak to verbose mode"
+	depends on DEBUG_KMEMLEAK_AUTO_SCAN
+	help
+	  Say Y here to have kmemleak print unreferenced object details
+	  (backtrace, hex dump, address) to dmesg when new memory leaks are
+	  detected during automatic scanning. This can also be toggled at
+	  runtime via /sys/module/kmemleak/parameters/verbose.
+
+	  If unsure, say N.
+
 config PER_VMA_LOCK_STATS
 	bool "Statistics for per-vma locks"
 	depends on PER_VMA_LOCK
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index fa8201e232221..2eff0d6b622b6 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -241,7 +241,7 @@ static int kmemleak_skip_disable;
 /* If there are leaks that can be reported */
 static bool kmemleak_found_leaks;
 
-static bool kmemleak_verbose;
+static bool kmemleak_verbose = IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE);
 module_param_named(verbose, kmemleak_verbose, bool, 0600);
 
 static void kmemleak_disable(void);

---
base-commit: 785f0eb2f85decbe7c1ef9ae922931f0194ffc2e
change-id: 20260323-kmemleak_report-a9a103ee0c8c

Best regards,
--  
Breno Leitao <leitao@debian.org>


