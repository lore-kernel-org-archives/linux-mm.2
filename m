Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 017B5E87852
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:02:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4512B6B00BB; Tue,  3 Feb 2026 13:02:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43C176B00BC; Tue,  3 Feb 2026 13:02:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 351EC6B00BD; Tue,  3 Feb 2026 13:02:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1CB1C6B00BB
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:02:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9C0B1404D5
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:02:07 +0000 (UTC)
X-FDA: 84403914294.02.EC3BE76
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com [209.85.128.65])
	by imf09.hostedemail.com (Postfix) with ESMTP id D61B214000E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:02:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhspMFym;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of titouan.ameline@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=titouan.ameline@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770141725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YXc3W5SqIxCE88AxHg63lKvEoA8CGK5fuYGcFDH8spM=;
	b=G1UU5z3J+yuz05pt256C0jjdg2WE1+A7Zn6pL0LX9ZWNAJDVS7Jaw9MEl3IKhUYf7J6BJC
	iiPR9aRCKTiFCSUltZGALEaI6J+TXsC4qxcpGZ9JGO4gWzQnLINnwmwf8zXjIV5qHKPyCI
	9GLTLxPiUGZXY7sQ2+ZF3Xtby2XQuL8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770141725; a=rsa-sha256;
	cv=none;
	b=DV4T/ObKM/GM1bXfL31csv4BfVwbk+x72oAsOqoMX3k2GiVRN1Za/i/s6ciJi/5xqPPW94
	HK7JYDi+jYqYZEjWTCOiM3K52CRv1yEp7bJ1gRJ68weKUTiM506cQkv3awi1joljRFp9qH
	JD1g0n6Ezq/LW8/f0WPpQmMHgL+jeZk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hhspMFym;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of titouan.ameline@gmail.com designates 209.85.128.65 as permitted sender) smtp.mailfrom=titouan.ameline@gmail.com
Received: by mail-wm1-f65.google.com with SMTP id 5b1f17b1804b1-47ee76e8656so79561735e9.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 10:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770141724; x=1770746524; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YXc3W5SqIxCE88AxHg63lKvEoA8CGK5fuYGcFDH8spM=;
        b=hhspMFyml9EpeRA6BznONVCJcYfQ23PYivZT4j2Wm1QFIX4iVvPA1evc1CRvrULgos
         uFgE9p9ZoqTSUGDRtuD6q8eDFIYdVVN/QDndJz4ybfZ3NaJKlb07KutGGlLoAwu2Qys5
         dwNbga+eusG/z95EuaQjJ/Tf6TmJFwu1UxcA/gZYzQrU1NDeupA0uvPHkKnc20BFA/wj
         KJchS0Gjp4zsK+dNTLGVflgLTx4rc5r9NLiRRfnd4dBGyOGA5IVq3xwc1Cr7ise0RAH/
         GsYjIiz+T4iFH9+8iadDkp1RP35Q2pKQU4RiiFcK0f2LfGnRPohKtZWWyjM9INxdPO6U
         DJYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770141724; x=1770746524;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YXc3W5SqIxCE88AxHg63lKvEoA8CGK5fuYGcFDH8spM=;
        b=SWtjyOpb36dopZirOaISYB0w4GZKAfEtCNK2CxvKm39ew2ATXhIWmqmnObwU/LmmO2
         tqXy6Q8NFdDghomhZgQj+rg/emGVrrQn6h4IQtTuAjJpprWVulbDHN7Hahx4Q5fvRtAR
         SeLhcI5dyM6Z0tOaWpS9l2rivYqryL5X2gDru69kHq4sMw0GeVtzx3PDHThnZeNzJFxY
         rKTF+ECEwC4N6Kpu/4ScZGC7Af3VVT55JMT4DXR0/OMDkcdUsRwK7kEqvGCxjuUqQ4tY
         6gIdnU0qV51gWEFl4TVn55R1befw9yyUsP9Hi0eRJISFo6XutjIVtGjGMd3Ra0jA4AdQ
         eyhQ==
X-Gm-Message-State: AOJu0YwXonDjJksZPjR1Af6ZZhi5q3KsRp7rMXhbJq/uQyuRtnjV9n2m
	fEUKnejxTNtZuDB9QfqJfPyDPx+piZFJsPmbtcDTUeEawDhwcDfY5zoW
X-Gm-Gg: AZuq6aL2uFXbRlwkd2EBFyNGAtFd1YdXDw6TAQiXKbXZPAw+W0y+SKlx2E8NyNfR54o
	9ldo8ZyQVuG4yAta17hMJoXN5YWIX/oJnIoDWWHloAgjCuPQy5VBEBHcb9UvlrMma2e2pTblFPu
	wo2S4hPhTxKl4fx4YQ/5wjvtmcgQhNxamS8RrwZNdhTD0vlkiGIX8O37BvlmPvq6wyt8iFBcM5F
	CckzCPBLDIucXt77F+gU32VfoD9oSsN1xzAa0JkSYxIjekm2tt3bkWcnmYHZ4tuJRAJNdUPN2Pl
	pId+OxtY74xS0u6puBl2GO+HFLi5S7xbXTO8IVBb5wuuZfGrfjR3riv3C7QexC+OO8dJuWIEeUV
	6G0ukb1Y/4VwKEtHDQsv110g9sJ3Vhrdr806QTrkrj+9yCBH7/for3Rvk/Bw2N3J9gaucCEf1JP
	Lh0VRPdIIPPKGSS8GEM0PhBlFTCRbq+nXYvRyPmX/tGo5HXg==
X-Received: by 2002:a05:600c:4fd0:b0:482:f564:d60f with SMTP id 5b1f17b1804b1-4830e93049fmr7040775e9.15.1770141723941;
        Tue, 03 Feb 2026 10:02:03 -0800 (PST)
Received: from nixos.numericable.fr (38.42.3.89.rev.sfr.net. [89.3.42.38])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4830eb352a4sm5021695e9.11.2026.02.03.10.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 10:02:03 -0800 (PST)
From: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
To: kees@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
Subject: [PATCH] fs/tests: exec: drop duplicate bprm_stack_limits test vectors
Date: Tue,  3 Feb 2026 18:59:50 +0100
Message-ID: <20260203175950.43710-1-titouan.ameline@gmail.com>
X-Mailer: git-send-email 2.44.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D61B214000E
X-Stat-Signature: wacnsng4o53fpzz1inax16jahht358jf
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770141725-861954
X-HE-Meta: U2FsdGVkX1/kU+Ndh2kEu2SoljkUixxMU45S/TsRz6PEQlbrnJd3CG+ndZ47dFPUb+Rf+OPta//7jPs3jFMBoKyBTz4BbOt7bWSi4aC5ieqQ9F/Jix6Dq+ZBnk8Mznz8T2S5/25wtME1JQ7hc+YRbUswOXT8wR5Dtlol5VaCGiVD2by9gHwwZ8MOyj9kaPYRgKJ2kxduVA2gx9IONdafe5vM+rY0YcenxZJ+fwwtPyLSKDm6qD52pwU4C8QXtcHnuk65dItztHLqUgD6It4qGLNOHgLswHnbTmfpX/mte2ffZogcnMlQpGTn/GR9Vihs2I31yS8F/+ndrdG/37tc94OfvoFWg5UpUUbqfXaaV7CHsJMxoNn442DjGNPDC6xgZkIfY+q/ILr9AkRjSsy1J0Snrlxm5FcEfWTfBTkbEWPZBIkRoE7x7HHS4TD0t7MLH6VD4NoVk+pFdMWh9ygFy276TNzDhDREl4HlgFq4UZeb5A8DMu9NTpbf89g88wKBCP3GFhetrCmKl2LPYEPfWrHSNlcnDXa3vh6hjun5KUDD59NzYwbAoXBXFjychFn2qV91IdzcCUvElvhVWiMM8lf7xwfMwPVzBt48jRj3LoLDRfKSWGPQSst4E/l/sq/YRxyupURICkxBnVRTJkTlD77c8Sy9zrEq7guv046HBFLLWI3yYEBJBjrAPK06pFVkSfABhKKMCjiRW4TYQOZx9OGlUZBjQpei9vNQbW4Um3PQdGszSpCqFOT9G7bWq7SMg0+T4uGxcaso5gE2pgJxyRqyJkZMnEXRaU4Xnc3DlTGwPjZtBLq1mrQpkZrr+0/eSJSEn8qrK3jE1TFldIqITb1PnC1YGsT9I30qWKTJOm0N/DbAEgx33L5YPRTQPfQj3Sg30H1BowNFfzxAbEvTeM+P+korBpXhUpmVgpmsd68bEZD+GrkGIBUm15NBvYDrJuQl9w/6GalcshKIzry
 fYDq2F5q
 29irZjClhdlrn5DDMt85hse3RInem0r4wBZpY/YUBb9SPZH2MrqNAxsK1sYm+NvSoFgLxEhb7YKaLeJDjy0SaSptw9ck/cTrT/uGnvzJ8/Lz0xLfs29FFT2SiBY2lMGwL9Mp8k347c/214ylQtqjqB7R/iLkXik66oOCz9QBe27idRUnEitEAOAS7NsYXpy4+nGCzQvA4ufknfX3cs5biQMf2d1T2w1eJZV5rX6fsKF5zVr5iU/3zmQzQGUoehRM8xdju1tBfvrMivIwO3rmbsgcHgBY26eJnQvh7NjA2SLsCtJuY3moPRq7sPGnKxUD2eMVDk7gu3pnZTUqo8xwLH5zx+05ttsfHXdGh2M6clfuFOewBs4Bhoh9MwqJJ/0rS5GCP+JtZcyD/AYxXGo7LL5U3+ZLxeRFmMTgSLUv3c+yetCD7TsvagtrMsOHxTYK4NckoTqht1NAjnCT+83xCu6wjGK6r6TDPg4grE5mKzuOCjVSRsOjEVwRIII5CkhTi4NxNyvTH5gzc2sqB7c/rwWfYH5AlEvjofFQetFrcR5qwT8tjIg74cBXhrZfPvcjxHn1jPvF3ZYWvbXrRpUEC2ySO34sQ5CXaiUj7GQaGMSk1CRgecPgqzOkIRy3zRW6IhzxOgB/va/h52sA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.033930, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove duplicate entries from the bprm_stack_limits KUnit test vector
table. The duplicates do not add coverage and only increase test size.

Signed-off-by: Titouan Ameline de Cadeville <titouan.ameline@gmail.com>
---
 fs/tests/exec_kunit.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/tests/exec_kunit.c b/fs/tests/exec_kunit.c
index 7c77d039680b..f412d1a0f6bb 100644
--- a/fs/tests/exec_kunit.c
+++ b/fs/tests/exec_kunit.c
@@ -87,9 +87,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	    .argc = 0, .envc = ARG_MAX / sizeof(void *) - 1 },
 	  .expected_argmin = ULONG_MAX - sizeof(void *) },
 	/* Raising rlim_stack / 4 to _STK_LIM / 4 * 3 will see more space. */
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * (_STK_LIM / 4 * 3),
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
@@ -103,9 +100,6 @@ static const struct bprm_stack_limits_result bprm_stack_limits_results[] = {
 	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
 	    .argc = 0, .envc = 0 },
 	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
-	{ { .p = ULONG_MAX, .rlim_stack.rlim_cur = 4 * _STK_LIM,
-	    .argc = 0, .envc = 0 },
-	  .expected_argmin = ULONG_MAX - (_STK_LIM / 4 * 3) + sizeof(void *) },
 };
 
 static void exec_test_bprm_stack_limits(struct kunit *test)
-- 
2.44.2


