Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16314CC6B2D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:32:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17A146B008C; Wed, 14 Oct 2026 17:32:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B4D6B0092; Wed, 14 Oct 2026 17:32:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01A9D6B0095; Wed, 14 Oct 2026 17:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE1746B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:32:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B4F90C04F8
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:32:08 +0000 (UTC)
X-FDA: 85322529936.24.D82D7E6
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id D598C16000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:32:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qHH4nvbQ;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792013526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tO5UQmTvouQg/ctKnDF1pYsfXafOcfme5DKNKK31tzc=;
	b=qmWxF0EgtTT/f6Mrplc/kiVuKulCh5/t8aZP7C/U9zDHDVsNDbi+YZDZcM12vZ4IoJiuU4
	dLy6+xckBtHch+AoOr3fyt2PltNMXLwaFE1UkeMS+6rsiDIyIB9uLdy/Uycr04jOcu2LOq
	4HGukfhXElDci3UXBRrn/9oQM2re694=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=qHH4nvbQ;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792013526;
	b=FKjgELYdgA3j5wEZUHqIgeeYW5oAQ86QgTBHOTpLa4RVTzuwIGNdDzOX1s/YyHreGvHlJ9
	aThW63WzQlubGez/kLFPx5k6F4rECydFK7KeOGIlGoYtEtoKkOGw18evEyw1hUTow3zQgG
	+1INE9W3BiPefYZ8vYq0On+kzCwXYj0=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-917a4b69a79so55276006d6.1
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:32:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792013526; x=1792618326; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tO5UQmTvouQg/ctKnDF1pYsfXafOcfme5DKNKK31tzc=;
        b=qHH4nvbQRIsBg3S6kowYIyyzXOZl7GBq58sZvjeuKrZxarRpSTUj4ONvuummpw+jP8
         tbebpl5U15BxhDkINo87Nt4lHbLdVVZxoeR5KUlrJgozw3qpMAwSCEorYG3GywM5hqE3
         38PowypiHZh3oUAyRN7xGBPvMI8G2zPqkpuPTEludCC8caBUBTNpzB6RvF7b61HigxLo
         A/7+mbFPnigPq1PVTiQutiDLiDO5k2akdZBNpv2ola2wCnhWUjRbEennzAAERy15QIkB
         AX7rYc9yUYeIEh5CHQeOhyzSIDuxpoBZYHKk55DYweSXgzRfJaadWCfTF6wK5GfcAWlY
         1VsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792013526; x=1792618326;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tO5UQmTvouQg/ctKnDF1pYsfXafOcfme5DKNKK31tzc=;
        b=iOlBW5zwYETS44DCJWiwkelrpIxgfoC6Jm9OJkarbO6onrn9emaHkMhZyWz/AyCLtB
         yAQ2RjDmgsbFS24dyQjTm0vrvblTFahgafjZOxeFfkCBvF3w4IH/BdnZmA855CXisc6E
         Ykgjp869bR5S5pSYBjbK8WUPHkUTBgXebyPBrRFGjCxmlb5eoCgsQ5p4PPeqLVnc3KTi
         CYH7V2apM/tNINVgyiMa1QmRizU8a6BWKfCwxGtwpzUvf6lTUHzRLLLt5geR037wYQYl
         ETF7ppbRqkaNvrgT/2Vi6Ag3aqJ4iUIr0SxLLNwJsaUbLKk8g9gX+Lp4PH529URVwgWW
         JkbA==
X-Forwarded-Encrypted: i=1; AKwUvByaphQnJpZhlpZ0+xZrc+vcUYZV8HLFpoC9Cgkr2NPSOoqQWAHG2JfgIBPQZ066JI80CROHjhS7Xg==@kvack.org
X-Gm-Message-State: AFq9FYLiIVZsdCEB9QYxrPrdpkkkx38cw0F5g5EJOTe1X+MTsP7YGKqP
	U9eUrJFuRLdlDC7liBQwkGXQHSqaF7yvS5rQd9Zy8etupad5SvRvZINHXxPXcvvGbMg=
X-Gm-Gg: AYBFou1a3A0UZVA9Wzp6SVOQkhLm+9d/lcLm1Bck+3uBnWHhpF6eZJiGi7KvGqrIx9L
	k3VsSoHzolGzgNUEQFDU8iAImXk94uvzvXVYVYMXOWjFeCDqvljriliWB/NBYaOA4bEGxfJPrKT
	vCn1OlDfyo/TcUIB++habmke8XdLkOB/CPzKcpZr0xWsAm9uhzD4H2WGL6gURc07NbiW2xY8uFA
	vxIaqBKVePR8QexoCNO7FFJqnUeMiruEW1udGBf7Zwr8sbaTxjcfFKgbbEuLxuTJ5JtTlpAy+XO
	hcx/psumMTVOw0CKNMIGstnUJOuhToMGGLhJ4E99LEBCjUUlNsFa3HbitT+eU7NZXEOrwMlJ7y6
	3Q5xKQFvvXJPoXzwu7YAADtKEc++u9QUVXLO/BLpiuPP0uBa1knBYE9L0T/PBsiCzvQ7igaxu4g
	8hmCMOm7iZQBITzPzw6s9v89Btuu8lIkKJxvc0rVKnEHQtOXkR12kv7WxmWo/afmObWm3R1dJWw
	ycU39IetArRf0mTAE+lJP/iblLXDo76ckRs8ibs42Q3scUBEWNLEH657+cn
X-Received: by 2002:a05:620a:1789:b0:937:5ab5:53f7 with SMTP id af79cd13be357-93ebd233be3mr2873421685a.43.1792013525863;
        Wed, 14 Oct 2026 14:32:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b383dasm63183306d6.8.2026.10.14.14.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 14:32:03 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH] fixup! selftests/mm: check MADV_COLD and MADV_PAGEOUT range handling
Date: Wed, 14 Oct 2026 17:31:42 -0400
Message-ID: <20261014213142.2269787-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-4-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net> <20261014175756.2035176-4-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D598C16000C
X-Stat-Signature: j4g9iyashjyk1g9hfjjwqszayxgut8cg
X-HE-Tag: 1792013526-168564
X-HE-Meta: U2FsdGVkX18UkxjMwCmaJGg9wzT/fZnly/nyiWjaBSbdpr1T7n1O1or1IPbujvmHtNMKRWgSayn2OdgYfeWPOc/4oMso6n93pa9ExPjyKzqIrB05IYIKZ7II7EHsf117axNVvJs2Vfr5RMVbgrxxqZkRlSC0rs0++vBHPo/+eIg7bNErPGrx+8uNjWG95lIXMYFHh3O8lbrRQvtkbdWspYjH8JsZ7q8EFM3qL26Ayv2agmeotuYS475keKTFslcYL+NajZ1Fw4HUdR3ew6wSz3CJ7R5203itHIsoTwXqwd4g3hqGOPEJTZjBJcoxnvgfmq++KC0OmgwmHR75sc1FS4vVbahD1sdBlgBDm2UgMrHYk2dWPb/6lNvvk46tvhicxx6mEiq+fD4pQBBFQUzF5xNuvFaoLvxND029hdNTipSf2uZh+hcPnYKmlg5uY5xsK2dOyvhcJOV18YO+BIA+1F4tnHjTOqhQ43e6UN19kmFA+yrO9E4RN6QEcGYrWR1b0ym0LwHXYDBokUE9OTN/681Hk7C2pb4rUD0VnNc5YBFJjrZ1DaudJpkWoH+mlHHPxLlj/a3UfkmJPKTB6gg3/uO8WhYdZZOwIsmxI2iE30D0pJzGjCPli7/XutHGyT4Z5UqiqXkQCFTnT3ck29jhQ7Nhvji9VhQ4aHug5TZwckRZn6gWoUWw+32sbBQh5rj6bCxKDONWfF/Da4HLsyr9eG1A8h8K1qt8eO/pIXPJNRiobCLMgU9ugu/Nh3rRZ2O4JzR5FCU71QTtjZnKxkWSG5Dvc+wce9bkmzdpAf1UWB2XLjoEJ7lIv5vNAyo6dHGtuC/7TK5cm8OU+wpkx+t5FCkHfuoE/yDKQe9bejzE4kjjVMcgskXozFTRonsRUWve1g6NUgaqXqkYZr5EsvjGa1dZv8FzqDJod0V3z+7wJx8O0kQHGPDOZAcb64FMB4i4LTv1s9rY67O5NUdvMYm
 TuGtcCgW
 Xasj1Z/6mbHBJhkbj1H1Hr4HI0IK89DG9HbxxUcXapjpJWs/ozrp7oz+UWwE0h+6V7VttcAmQtkVKOs1mSCNkhLqSTJwKRMVrUI98GX4W3eCt4cUawpyg/QpzFCiJhkEPcCsUaf0Wh10cZ2dCM7UHD77KAXUmD0Vub9nbo2sijzGSgYFr0CfEAUZBS4wUnP2u4ZDGjNK7rz852UnOK2MMH+c9zYF8YdPp0XKj5iqHHZfl7Vda8FRdHh+Vi9o71WAFORSEH45hjs1K45KE6LvuGgjpohQwa2qy/Tbxl+PJLmNnmakT4zonW8QUfcDQN7YTGBAP5uNK1q3nrxQDGXPwDYYyS/cTxkEF1mcCSC7mEbMZwm0kUHNmc4FkmqBipN2Xu1A2tBaQrImsNyA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sashiko fixup for patch 3/8

This is largely an overly aggressive fix for systems with >1024 cpus,
but it's simple enough and can just be squashed.

sched_getcpu() can return a CPU number at or above CPU_SETSIZE on large
systems. CPU_SET() ignores such a number, so the fixed-size mask stays
empty, sched_setaffinity() fails with EINVAL, and every test that pins
itself fails. Size the mask to the CPU number with CPU_ALLOC() instead.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index d59c03ec8191..3f361bcf1039 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -224,12 +224,18 @@ static bool pageout_until_evicted(struct __test_metadata *_metadata,
 static void pin_to_current_cpu(struct __test_metadata *_metadata)
 {
 	int cpu = sched_getcpu();
-	cpu_set_t mask;
+	cpu_set_t *mask;
+	size_t size;
 
 	ASSERT_GE(cpu, 0);
-	CPU_ZERO(&mask);
-	CPU_SET(cpu, &mask);
-	ASSERT_EQ(sched_setaffinity(0, sizeof(mask), &mask), 0);
+	/* CPU numbers can exceed CPU_SETSIZE, so size the mask to fit. */
+	mask = CPU_ALLOC(cpu + 1);
+	ASSERT_NE(mask, NULL);
+	size = CPU_ALLOC_SIZE(cpu + 1);
+	CPU_ZERO_S(size, mask);
+	CPU_SET_S(cpu, size, mask);
+	ASSERT_EQ(sched_setaffinity(0, size, mask), 0);
+	CPU_FREE(mask);
 }
 
 static bool page_is_present(int pagemap_fd, char *addr)
-- 
2.56.0


