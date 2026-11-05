Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5422F606A335
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 03:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WzFcuzy7
Received: by kanga.kvack.org (Postfix)
	id 395016B05B4; Wed,  4 Nov 2026 22:08:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 345B56B05B5; Wed,  4 Nov 2026 22:08:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C356B05B6; Wed,  4 Nov 2026 22:08:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F01C56B05B4
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 22:08:49 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 64D07160912
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:08:49 +0000 (UTC)
X-FDA: 85399583178.01.FB0F3F0
Received: from mail-dl1-f71.google.com (mail-dl1-f71.google.com [74.125.82.71])
	by imf27.hostedemail.com (Postfix) with ESMTP id BA0FC40009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:08:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WzFcuzy7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3PfPragUKCDIkOYSZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wakel.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3PfPragUKCDIkOYSZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wakel.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793848127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dk+WGnu7U2he9A5n6a73SfgBiibQ/uVJWoRKp23Ly48=;
	b=6RxcVTs8xOlPLX2jhU+8wOlJy3cAwD024uF9E2N2wqp5L8T9FNyfil9QBCS/YsH2AIzWA1
	pwTPLQ3tBoOhPokQVBFLhr2Nb6TgCGx1n/5/M5/G4FUUxPBMyPdTMYUfEvHX1aeYaves1f
	a71AWB+qPGWCE3yOcMSyyYBbe3R/Zrg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793848127;
	b=2XTXD0iAiXP+sg/AToYsYRytA3Kb5CJxtO1+AIUljdOKxAUskBFDc+2e5V2BUoBnUrGNZe
	NC/tW3WJrOBHTT/GDoFNXoimwFn05rB3Vk99npjsAoMVChJCGR+cCu7Wf/HiJnoMJJptq8
	DL+XxODgWo9pwH5PR986qetplFytBmA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=WzFcuzy7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3PfPragUKCDIkOYSZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wakel.bounces.google.com designates 74.125.82.71 as permitted sender) smtp.mailfrom=3PfPragUKCDIkOYSZUccUZS.QcaZWbil-aaYjOQY.cfU@flex--wakel.bounces.google.com
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-147be78cd56so2600225c88.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 19:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793848126; x=1794452926; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dk+WGnu7U2he9A5n6a73SfgBiibQ/uVJWoRKp23Ly48=;
        b=WzFcuzy7EgU4GrnfdJ1sljKo5O4LigsSXULWIy+afHZiDSwwrIkWiYDD1SzGdEMcC6
         GmwFmO4mWrekuVkKMCyMTK6Zu9bOIPMvbJZCQpgzq8LT8NmbRaj4grHaFhxpy7aUl6pC
         EVEz1BiwUwtT8GYkcU2nwNSOokWoOr69eVfizxxIBTM5FpQum073mnXHLHZpuQng+/at
         GguPxyhvNfI7DtTJaWuNf9z7BeuN4bFVg18PZ+w4of6xG6ZMMHF9jS8ORsEiUJ5IqrE5
         EPnqGShHd/ZzsKpW8cmlVYhWzyKZnQSaRH9jko+YUV7E/41UNO2731egyHkua5dza/EN
         7Sxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793848126; x=1794452926;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dk+WGnu7U2he9A5n6a73SfgBiibQ/uVJWoRKp23Ly48=;
        b=kfl2q+M/9kyUNp3xk2ZkmE12zCsqd8MOavNAXy40JTwqVjaj3+3bFZNx3uJvJsKddl
         +KKGExpnXqlpib82DjFJwBGAi2nbZYHYm+mX3XxJVZCjlXpp/tHDbOtndgwg84iPylMJ
         T+k2i4WvDStvxtLxC+K+UWAFh04qbssbJ4ICn1AQv/UrfcLcCxIOXXZ8hhzCB0oDK4Pm
         ZLoiZMYFdmJQx26HYNn4MsENWQ1okqALod0INEamnIVtTbwIa+ePA6cmHSYf6QV7GJ+O
         LuCyyWv8jbZYlvZCcXvvar2AHCj3xJDn5+nQLgd+ZOMNWpC1VL81An39nGKt4gQwfg9X
         LCag==
X-Forwarded-Encrypted: i=1; AKwUvBxqMKuCHosA4jdE2vukod+VtIQz5oGlHGlSddSnmxB1AWHpycLUtOu3pWkCGOO/wwRZ1chiIKPKpQ==@kvack.org
X-Gm-Message-State: APuU4Z9TTQNKqjqxhrjtqNZX7cQI6m9jCTGu1mzuXoLjcWTW+hr3uJm6
	sBu0MTT0SvI6XqRWd6XvNCuxk8i9vvT8EBOuN2zfUGxjqYvdG046OM3nkO0G0XcUziuqOh2ZKB9
	E6g==
X-Received: from dlar7.prod.google.com ([2002:a05:701b:21c7:b0:195:8b4e:20b7])
 (user=wakel job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:208a:b0:1b0:4272:4282
 with SMTP id a92af1059eb24-1b042725256mr18017569c88.17.1793848125583; Wed, 04
 Nov 2026 19:08:45 -0800 (PST)
Date: Thu,  5 Nov 2026 03:08:43 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261105030843.3319056-1-wakel@google.com>
Subject: [PATCH] selftests/memfd: Rename local union semun to avoid bionic clash
From: Wake Liu <wakel@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Aristeu Rozanski <aris@redhat.com>, Shuah Khan <shuah@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Carlos Llamas <cmllamas@google.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wake Liu <wakel@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5ggf5gz7rqepefepni15jgey6hute6r4
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BA0FC40009
X-HE-Tag: 1793848127-684087
X-HE-Meta: U2FsdGVkX194O8fCo+uX63fSbppgf4HK1LZnGBSDM+Gy7lxgJpGUNDCOo88PkrMNz4bhfj1qgymPSA9xIUMtyfS+OAzoQAXoxrdtO5L5REZajG7zSFg4qocWDw1kADTwqNeLEMcW1mWOKxjeqhjvAAfkQsfiDIrqcS7sq62LEVsYYzogaSbnW6nXZGA1Szu6OIw8+F+UgKfBDxHcNCWz9cF0G5KJg8hv+bdSSJ/9mQDbaTYDeXxFS9TWJysJXNuVC0xGJBU5OF/hUf3qT2L1eclUPwjq3DpxeuLEIuUqWasCY+0+8lbMSpxv61ME1wqBrqDe7jV59umdmzcwOLR1/seTLrkpZAJGxfjIMH+B46Tmbr7LzBU9xJiVvVA6nqc2XDlfUPpPnEyolubSW6wZ6ZFch6zDTX8NeR4SOSzMwoIaOlq0GDoZZLvt1EYPO95n2BTJQ68QyiaI6O1WbXVr3piRaD0AdwgWnu/nzcSclN5A+rqIyrpdPcK7xAEP+SGANN6thQNy4RWUYW5bm4F2HjvlIInbku2p9H84sORNTKPCPuo9qiRerNEO2iM4vuLb3p/4dbCmX+dnCQI3SZBjvFzPC80ZBs5Y6sm7mdBn08TKf0S463IcDcsSkWVoRtGxLx+MwcyFWUIDPu2yQ1r7rPcFpYVYtujNRXD+F7Vylj3Xbigb698Y+kGoD4pisbTiLku2Vgp2p6S2HKM+T2sUq/BRyRuFZZ/rUskD533OKgFjKPgfOc1/SfRnAko4S3rrhTCID1kL6UTm1421AMiTZL6hpb5qvu/HjBslb5gwCuR6wD4zr5dXt8fpX09P7zczMd47GWklLAlhZ3Ry9oSayhohTpIa+9x2cIc2csi5CjmF9TlDL+kK2sOZHQagylMDQav8Jf+Osw7QquCuSGl9Z6GfqANAYpAa7UX2OHmf6TVY8lFCbaQM9t5Lj9zvVa/Y0mUWdIyplR662Tgv89v
 c+qVoURm
 9cZsLP7uNeHkCk313P+R+7z6hfkivvMOp/KvwbV3c8Ob3Mu1zhshZmI6cq7fVtSz6txCgZI50+PyWgvKrDJWqH3PKbnIp6gJuUV0VeQ1wR65H/rm2XkjV05pwcKsZSqoRScCiQhHJ7BcaMqut4BHUlhfFTUrHKx6FnH4KghIfx0I51zslLHj1UdV87Rz64DrZHjTq+WfMChEtYalWKBL6glE77qXF3KI2gqtpHvQuZ5NKbO2drJ+7BypVN9hVa/UVGxqw8FeDnSeP/0VzU3+sizPWT14EAtz/JZP9EXLGUrTNzEFKYcXP0W6YYLLrSaEMJ1u3uziYeFSXCF7C3sXOgPIgUqbaE5WPXN8ryxR2REoN8xX49kusnaMzkWzRmetEqdiYUQmLOYRWSeaeJGaZIsE+SHRtRjvp4bGYfzPpL2V4pc9+5G9z5ZBWa8KetEn3LMQhIXxOTL2Z/BEijd1uSpNd+KLv14nApHjgmsiWumrvfVeoIcRQJwH7kFA9l0vlFZQJaINLI58krlznKivxxZ3n5Bbg81FHWEl3SAOMVmaSj1ZjbWI9cgX8LsibmGiEOvmy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit b24335521de9 ("selftests/memfd: use IPC semaphore instead of
SIGSTOP/SIGCONT") added a local definition of union semun, since glibc
and musl expect the caller to define it before calling semctl().
Bionic, however, already defines union semun in <sys/sem.h>, so
memfd_test no longer builds against it:

  memfd_test.c:45:7: error: redefinition of 'semun'

Rename the local union to memfd_semun. Its layout is unchanged, so it
can still be passed as the variadic semctl() argument with any C
library.

Fixes: b24335521de9 ("selftests/memfd: use IPC semaphore instead of SIGSTOP/SIGCONT")
Signed-off-by: Wake Liu <wakel@google.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index cdab3a837624..188cb7c32db1 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -42,7 +42,13 @@
 		    F_SEAL_EXEC)
 
 #define MFD_NOEXEC_SEAL	0x0008U
-union semun {
+
+/*
+ * glibc and musl leave union semun for the caller to define, but bionic
+ * already provides it in <sys/sem.h>. Use a private name so the test
+ * builds against all of them.
+ */
+union memfd_semun {
 	int val;
 	struct semid_ds *buf;
 	unsigned short int *array;
@@ -1387,7 +1393,7 @@ static void test_sysctl_sysctl2_failset(void)
 static int sysctl_nested_child(void *arg)
 {
 	int pid, sem;
-	union semun semun;
+	union memfd_semun semun;
 	struct sembuf sembuf;
 
 	printf("%s nested sysctl 0\n", memfd_str);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.56.0.398.g882cbad275-goog


