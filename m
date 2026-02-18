Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6169E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 16:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18D16B0089; Wed, 18 Feb 2026 11:39:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA42A6B008A; Wed, 18 Feb 2026 11:39:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949EC6B008C; Wed, 18 Feb 2026 11:39:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA8D6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:39:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31958892C1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:39:48 +0000 (UTC)
X-FDA: 84458138856.09.37E136A
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6D61F1C000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 16:39:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SdaaCpRQ;
	spf=pass (imf18.hostedemail.com: domain of anishm7030@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=anishm7030@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771432786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8IaEyL0dKDQs6FVsnUlq2M4sAODAnf58W8FA0XnDWIs=;
	b=WtoaRj6+ZTrhC1jNhiLMHdeTcqRj+nWWmueiejoXlsIh/JmhIezHUvL1KId8bGsjxpIirR
	lZRwC8ZBwGb/61gbd5c/Kz6B1zQdMDi99OGr3UoyDR8zRpAnHEYrGvFIOYJMZYmC8U5PgQ
	HJZv1Rfw34smjkJtXdsDu3tt2W5qmpI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SdaaCpRQ;
	spf=pass (imf18.hostedemail.com: domain of anishm7030@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=anishm7030@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771432786; a=rsa-sha256;
	cv=none;
	b=UzqvDPuRBpSVxscsbrQOJmnhMPL2TL3cnS9mOtWVnKUBVAKrxsGeuOJcx6amk08+Guu35S
	1dpWO5nTTM/t4GhyDSse4fES7cZ808v5Sgbj2ghoxs6NOJ2u3FajayEC2IpSVm3Uom87fR
	v5tY4w9mXJhDaEudlqAjboGbnxvPNjc=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89549b2f538so5653996d6.2
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:39:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771432785; x=1772037585; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=8IaEyL0dKDQs6FVsnUlq2M4sAODAnf58W8FA0XnDWIs=;
        b=SdaaCpRQV05AfcPxbUDLldzoT8bgOtpXIys8iaFfDKBIDh7zs/UZG23rO4CrcC4Z9G
         66qSmwc1M/rz9pAG6fgqdScvZfd5OmPkZbKi7dbwK5fZ+cpNy5eJq/jbyOByp7mMoROZ
         KT/Jdo+Cr3ALui5NIggVPyHUqcuUDewUpS9HYiiZ7Y1iskeW6y2EUYwFqvo3DVVJf0FJ
         86sjnD1mjvTEOS7jmTxqtzYxzwsgIcqC2dWa5KnVpCbMGyYsRzvcfYZROi+NPv5sTZfN
         MCdGm9AOBqCLBbs2Fgf7bzB1BmA8mvDrLj3aAO5j4CTEIS1swjY4WhTOw2QM9rFryaoW
         w6Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771432785; x=1772037585;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8IaEyL0dKDQs6FVsnUlq2M4sAODAnf58W8FA0XnDWIs=;
        b=mAXU+KrdnUsf1/Y9wmdqQykJQlYUddzkBlKPcqZo1kFJmV858p+PCLBFvPGhfBUmmY
         H13ZllZO9bn5xb7LCkW2/uaEi8TfDu+YS5/JvNNUYrYiw8OCRR1MIMLs0oISLAkaTtKh
         h+AulSerZzLeiMpVtDkIzdIfXhnEZzQgXILECgWpdputD5qBE0VBtXLt7aAjsalxd55t
         ioBLgx1WvFax+R5q0/Ts14N76aHBpbX8YSYNz+q6U3ToEktsWnLVWHWMb5S7QBT9GYxN
         nw4e77e8kZkoXR8Q3qiLNUrdKMhmVlAbaRk+UUUOjUajZzcgHGNsFmAVTUPgOmsYiqyM
         jnxQ==
X-Forwarded-Encrypted: i=1; AJvYcCU/qLp71vpobgeYsQQS33SeIgGdOqQ2/SZU3YuJbsmQCeM9ypIRkCZaRTKqQCsvwPRQHDDXgzsZvg==@kvack.org
X-Gm-Message-State: AOJu0YwOlEpSjPMAhTl4lMyMIxnS8WSdfJi99oRlAQlMgqkC2J4Aj9Gn
	D4tXbrg7wCUZkUP22fxNVYn2RHvjm/Dxi3NAAx/RCn/hcWuoCnc+COf+
X-Gm-Gg: AZuq6aJ2Qn3+hXxlv2jAXSw6pY4KiCdBPc93EOkH0WJH90mr2EE/kkKyDNk60ypHsij
	lDBa5ab2HWG8DqcXE1peGKU0+wQQA8mPZXwKcofVqg4oNAWRZo9jDUs1FjGJBzqVUhM7VYPs+Um
	5HpZBji9K5yLHME+tpytqslfiJbt2rfH3CeFrNEEUZdhtRKpJETEgqjEYxCQLX7rvKZEZA1y2s1
	aLGXGgI4o2FCYw6M+7BgrCqtEJPFyob4xoe4Soxqzt2Nbdg3wyAt6+D1lTTElpRrobd+Cd+jAQQ
	1kbETvw34Hbjs3QUgKcdvvmG3MVGF0yX45ZNlQagZEsXTymnBkRYUxGZUEEUjfN/L0NqcKv9C9u
	HtuOagCbj/XSl5dA/9NIohtbjDDSbGJEOdi4zsZdeik7GY2G2MCZ9pAMndVYxDdzDkJ6FvVWiK7
	7ZeRZWyzFLarHj1+Rj3O9z9Mh6
X-Received: by 2002:a05:6214:4109:b0:896:f50e:b6c4 with SMTP id 6a1803df08f44-897402e07d8mr217890716d6.19.1771432785370;
        Wed, 18 Feb 2026 08:39:45 -0800 (PST)
Received: from ubuntu ([76.38.17.53])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cb39da3dc6sm1769869585a.51.2026.02.18.08.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 08:39:45 -0800 (PST)
From: AnishMulay <anishm7030@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	AnishMulay <anishm7030@gmail.com>
Subject: [PATCH] selftests/mm: skip migration tests if NUMA is unavailable
Date: Wed, 18 Feb 2026 11:39:41 -0500
Message-ID: <20260218163941.13499-1-anishm7030@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6D61F1C000F
X-Stat-Signature: umhtqz9z8rjaf6fupkgrgiq48qywzoes
X-Rspam-User: 
X-HE-Tag: 1771432786-651924
X-HE-Meta: U2FsdGVkX1+bTZzmvpr8kylqnr1rEOY+icHSsTFWNpgNihDqp1OR+7RCcHoTW3x/K1mRAfDfDB+wQSFuI0RAI6C8/3HQBiYklNFF6yQxlLIYU95YK6o8t9id+WJX6cT2LTCb/22zenvv6Dx+VuuDTcCMjCNd6UZQlaHlT6nxjrCsQP8FyojKq7Ox4s3g1MAxG9Fy2VM2erMyPJOKOHiDYvleoByCNt37jYTtePcHXjx+AXTWT4bYz/87O81AC5YLoa4+DU7guCheR5veeBFMS2b6JGiR3nx3zmI68K7ANv2rzBTyeVkAISD+psaiThshUuPBG0l1PrU0ClZpKqE9sG/Paz8v7NOphfFVI4coJBdu45HBp7jHS71TgUgZuc2PWWQ5eJ6JF2guiYO2ldaMOOkt7lpMkejYqivf1EXaSlOmXaN3L2Y8uaj93zJqMlhPrVrrdIctofrWOfsXGaGKu5SVVaFJwF3RJ0GokwSemX1ufc+o8GFABRDYCnEXRO+sTebW3l2x0asjNCa8JovjtoMreqx4hjOpo8oQ+hRe5+RLEbrEUqaOvRZEql+qBtXy1K/PT6spr55Scn7dMgt3D1yzM3wgmdBu16EXr+z0nubNmpN2E+4KHdfHlRtY8nN4TLYQSiQAl6B7noqjjxIKh3BRItW40+LvGOJYWSMCDEPE7W//Dc2qyS1aXCF2W9euIWCizMCgS1xt7cfopZOo3VYxpwaj1Ei7cS7SGvz5YEBgJsMQG99h1wgbyczDs4tlJ6J/ALDozn9dkJfY2VEeulD8UyJQ5brQAQgJ534Vgv3Ez8ysq5E8M8o7TtURC7y6GUXPvaFs0nGFW9Ybsx5BWFzFTHVpO89qHuti67AWHzBozt82Hhyi/VCs3VdqVlElY1ViiEAGi4T5UQ5bmrrerSvi5IB//PDyHKDkbeI2MhcaPpPMAO+stE5ICIWRY8yFMhoQaSZ3nse0pW6M1V1
 pU5ZStz0
 YuQ/NOTWSKs9x9xTk1XPISyergrFPz/fw+rxJL4ipJYu+3lmZ5QCyIG2J0Q8UBOeluN1iIe+yZYFDqVv/Eqsy5JFuldONh9aNVokBY3tVh6ATGFdulDnX3as7mAv15Uv+fCvQ2+m9UhJZTzB1Bfxhn6zAKewsIeA3f2ooqbFbzqZaIZKDbjcnDm2Pq2LZW2FgYbJUsV4Rw044PXVyTEYNQLQvoUSKs9WtVyKXAlfTakxhZY0FVtoRzas9wRcFhejteFlEAnRPsjO5ugwtLqzVL+frT1Bb4y7mE2BW4ojyEYX8l1JZH5/O+QfQr7BxZcTxk6eP/JYuv8DzWTCrqSM4FaGtSurp/6iC/XbXLK+TKUOFt+X/eGjaYrxQIPv1v0NcInl1UIvE4yMxGrWWICSHlRNul8/VvVAxkUUC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the migration test asserts that numa_available() returns 0.
On systems where NUMA is not available (returning -1), such as certain
ARM64 configurations or single-node systems, this assertion fails and
crashes the test.

Update the test to check the return value of numa_available(). If it
is less than 0, skip the test gracefully instead of failing.

This aligns the behavior with other MM selftests (like rmap) that
skip when NUMA support is missing.

Signed-off-by: AnishMulay <anishm7030@gmail.com>
---
 tools/testing/selftests/mm/migration.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index ee24b88c2b248..60e78bbfc0e3e 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -36,7 +36,8 @@ FIXTURE_SETUP(migration)
 {
 	int n;
 
-	ASSERT_EQ(numa_available(), 0);
+	if (numa_available() < 0)
+		SKIP(return, "NUMA not available");
 	self->nthreads = numa_num_task_cpus() - 1;
 	self->n1 = -1;
 	self->n2 = -1;
-- 
2.51.0


