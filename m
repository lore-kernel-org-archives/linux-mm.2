Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E734C44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389A56B0093; Tue, 14 Jul 2026 18:21:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3620B6B0095; Tue, 14 Jul 2026 18:21:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 250856B0096; Tue, 14 Jul 2026 18:21:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 011F26B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:21:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9800140555
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:40 +0000 (UTC)
X-FDA: 84988805160.26.1A8210C
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id B3D9A1C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:21:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGmpVrkF;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067698;
	b=ptrteBmdB6HLi5XdA0rBmiK4RDMDR3HniQolfn1V9Xam/uoa8wrwH4bIFYQvg2pHbslNzT
	hsvk9zxWnYkgskH4wtUUMnmeyMma8WFyQYnV8Sv9gu+Ua4A9cAdl6RU7bjyYwmKhhsulgX
	sNaQXVy9EId5adlQKFHFN4Txf02vsMs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KGmpVrkF;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s/XP8nJGTiSx4jpNVu3XVkKeZD1kh7QswKhz9rXqGp8=;
	b=IeuJocPIDQWyGA4mps4MwNbMPbVhupXF87o/VvEV/mXG9XpcWlVd2uvWP7F3y+ZdiXaikW
	Su+3fboQXvfDQ1wSS/gUr23lN/mS9HaEiyCiojeTNf0Q7xBKOTo17KphfsudkHOTlgl+pL
	tDA8WfoPzZY0VAWMF4uMk2zNykXTBvM=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8486672f03cso4416355b3a.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784067697; x=1784672497; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=s/XP8nJGTiSx4jpNVu3XVkKeZD1kh7QswKhz9rXqGp8=;
        b=KGmpVrkFFdOpDn8NcJp3oWyuXLOuJqY5oPO80z1xaqXWkz2aUF0Toot0PkOBuSLiGQ
         oJMOHczs3Grn7YqajmJyDJ+bBIMYn81ugZKXoW1UxnAwyQvJHgGxPwmx6zT4aAUYkNnl
         mP/Gana0NkEi1ezjSIXsLZYUpbRlVSwBd3FeKlFUfg4bgvMn8su2S6M2NvIz16lZAEz9
         ZqxcCd9zPpFLkGaeiR63I6jaF6gPLPV1ao/8VC9l/ncZiVSWl4z5I2YvNGzljU+gAml4
         QM9zRJ4YYFzukJwLDZeMxWyrnf3UWoek2Lc61Io7g0QWwiv9gp9lWlbyZFduNVJ2IJIQ
         yKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784067697; x=1784672497;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s/XP8nJGTiSx4jpNVu3XVkKeZD1kh7QswKhz9rXqGp8=;
        b=YKG6Dx0xWv0J+FkGUtpueSk9AFEC0lLUOCShEBjAZ3VUZLfxoNHWwamncjqaN6UG5j
         bipMr9FScxbgmTe3dBPZW5pD+sF5ymwfEl1HYuqLDiRTUf6FzUALj86QGrvhxAQt/wbB
         2BS50WDWA0QHlazZz+AEpUfxpj3+l9BJcBUZuYJw4rEnPyT6JFfnk0xoFezUJGmcCMtD
         RE/nWAQwliLENRyCA50Y1+kt8BWY8RQ6XP4Y9MSsPva97ZKywxpVilCRuNUcjREEY8JH
         vaM76mBRWqKeeeQPGjCfOcPhX/s2ZeYSTKvRkFnYym0usCZGrdZ65nVGyGINdmReGATI
         nS2A==
X-Forwarded-Encrypted: i=1; AHgh+Rp9wq8uv/k/qsB67NERIy3LIm6LzVolpFPrCj9wMwTIu28ERl4rgBD97Pi3LALocT4gK4QzQzn8Zw==@kvack.org
X-Gm-Message-State: AOJu0YwkCxI3A1KPqJrn8Tsms5KeupMP79Y5IGdZxJ1blwQ2m54r8yPW
	ez2mXRVuTQIwRitBjvWW6+0nAvgJRRKQinPSQB2DFYDgLqsOwpaQQ1J1
X-Gm-Gg: AfdE7clkyHNiPgjwaz1up2YQ2S/3akY16FrUts2wCpBXgk1s5Kx+fG+DNiQuLZ4BB1X
	YntDnGxHkujDw6YU+pKCwBh8u+PQ+CaYSPt8RLdwuwYc5UCkMk0JyCoeedcQPTMIz4UVIVK0Czy
	qb3UXH0aNAtB/NP0kGnOMrFq2f6hXNM0bJx+tROVs+tEpGZc5NcbT85L/K6fcLBHe2xsxeUomj3
	kofI4i7+1sX6aDa3EXUg/Hn/qvQu8uHxk6UyWyFaAPwTh1MwbA4f2YVdzXBvlZbvdvQISMmHEEw
	jU/HT3uZkndbTE5Vh+CxCPM2SnvfvhjdhjewtCHSwGePd338VCJ2W++fj4hN3U2e+gmVnYh/1aS
	kp6n4XCZeOyp/3zJm7/nA/Qj9q1FTBixLnwiyjqeTeWhbdDwlxEpG9mTEvVUt2+hI3gKAgaSbKd
	Gs/eA/uIQs+mCvnOmKIyTXdkGqiI1ASh2dVo8rjhjtdnng2G67cEVw11SCHxMVKd7Vw6+4AQ==
X-Received: by 2002:a05:6a00:4b13:b0:847:8dec:141f with SMTP id d2e1a72fcca58-84a672ea3bfmr293017b3a.51.1784067697563;
        Tue, 14 Jul 2026 15:21:37 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84a4f238f75sm2119769b3a.9.2026.07.14.15.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 15:21:37 -0700 (PDT)
Subject: [PATCH v2 2/4] fixup! drm/nouveau: use
 hmm_range_fault_unlocked_timeout() for SVM faults
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, jgg@ziepe.ca,
 kees@kernel.org, leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com,
 ljs@kernel.org, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-rdma@vger.kernel.org
Date: Tue, 14 Jul 2026 15:21:35 -0700
Message-ID: <178406769581.1106335.2090301352195900623.stgit@skinsburskii>
In-Reply-To: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
References: <178406760622.1106335.2379450382728057793.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B3D9A1C0003
X-Stat-Signature: wporkq3i5uf1xdjsf3n1fcrnoffdt6bu
X-HE-Tag: 1784067698-983124
X-HE-Meta: U2FsdGVkX19BPLzvP6CfiyIoRl22jRGOvEUqtHB96AbXhdI+U8fmFKmSsq6kNRtoDAcIOb8s33Tunn+MpmqDvtsuQOXfNNcW3YvibdG1FB5oyFiFnIIQ7jmcz2l5/oyMF1Cm0eu/U9jD5opMwmsQ+Q9RlGY+gEDeLBb7obsPOt4mvFRY0TIuxwu1miFqKpiKLg1HmTTD+wK0T8yVqvGKIt+GK7+Nbzk2I+pHGfkdGOBV4JgONhl64UPNLKs7ACbmLceEwrTlXB0smvlDH7Mhb62AowS9TxzsodVO94+lKsAiycXzXxoUmBa69NVb0jHjPyMc2JjiaIoEyhUQ6s3ktB+D/6mE0yi8Nk7UOKZmeu7qkOZRQ+ax/H+Jg3ZVlQKXOcfYyyk1XVeQFXqeju+YEMWW1Za00SRHaLP7FhEPeMgoPVgHwaQ/RnMJF0aRrcajywUaxy+bde8hgkq8vLl6Dlm99WzryJx19cdkVf6S1MU/eNvWTLOpyYJfhfK/cpnW3F1so5YIX8qme3ZtUMkXQwvTVZYWturk45QhMLHvUEyDId8NdP+DK7yUK1ITjvJTUCjJ3TzWCU84pycfvIYaNaA3KGfvEkeXguP4nFNncbUMhLyUOHb97H9rg+13zjKrymkuF+DMwerJvmqSPbXLe9FVoxtyfGt211f/2zOxN0ci0493iiORAnKMpQrB5okltgV6Cratr0kTxOPWh0pRvcWOgEupICDXtD97qR62P81OBsqKWsEn6/DOA5vqwtOQ6cDdJ2kifk0k6U+XtTd6Wgdtpt3gkMP9vlDVAgh0cUP2N8vvKlhPSipwLIgWv5GRtrRwnryAxFPLzt6zrOCvgiyo/bLdMId/JgfKK7SNcbDk/rQOVjrHMB9+MHke9K9FNOJbIOwSJZV+9Ds6c7NSZGv7bNino4SKQuy0YlbAvflNdsKJsu0yAMyE4IJgcyAsh7rSnENzjDg4ydpADUE
 BJrb2Tjp
 CTNV0NYIa7ufqUyefTKNnI/LVenxruqqrHd54FbKfroq+lSyAiahkzcmSbf0CgoQ4rJDdwW2QT9cm75BwnfSmKG5ezHDNRgkZA+rmN5sg7pgzmzT+WKl1aJXbI4b4vAFir1OsOnCAhoAg4B5V13HBNpqpdiV+oO+KbdFx8gTVjj8T04ag/XaltYHUJ+muzV+X6kXgTKsrIjtblqaIIfYgawH1fKcMqQH5NdheM5V8eCsWp9aEaTNFHv+5Avg7Nq0gTiREwC3sgS8vGBOyo/W4x7zsiPmub/1VV5ssJ1pI6WhC5QyEFYPl+oDO5pWIldGN0ooofQvYf2pnZLTt/gLRHiyBrLG+v5/7sRDY/6bu+rxLSmWTThdPD228jq1Ed/0hbZ08qLNHqt+6YI7acxqsNd4StqBrQg+BUINjLf3ZZlGpEaDHklQ4rdrkBmFQXE4SaL5S1yxxJ4jNkPyj50tDB5qNRwhp/X4YZKYhV5Tkzi9knzGCSC0WlYCP6sjdmLVV5I53Et1xb0xBfOcUGR626BJeBWmjI/HE3R4Zdix9438+3phGPCMMvjXPmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nouveau_range_fault() now uses hmm_range_fault_unlocked_timeout() for
the HMM fault path. Pass the remaining SVM fault timeout into HMM as a
positive relative timeout instead of open-coding the HMM retry loop in
nouveau.

Keep the outer absolute timeout around nouveau's
mmu_interval_read_retry() loop. HMM's timeout only bounds retries while
HMM is walking and faulting the range. Once HMM returns successfully, a
continuous stream of mmu-notifier invalidations can still make
mmu_interval_read_retry() restart the operation. This path runs from the
GPU fault worker, so fatal signals for the faulting userspace task cannot
be relied on to break that outer loop.

Use time_after_eq() before the HMM call so the remaining timeout passed
to HMM is always positive. This preserves the old timeout behavior at the
expiry boundary and avoids passing 0, which means retry indefinitely, to
hmm_range_fault_unlocked_timeout().

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 drivers/gpu/drm/nouveau/nouveau_svm.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouveau/nouveau_svm.c
index 4cfb6eb7c771..58735446d783 100644
--- a/drivers/gpu/drm/nouveau/nouveau_svm.c
+++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
@@ -678,14 +678,20 @@ static int nouveau_range_fault(struct nouveau_svmm *svmm,
 	range.end = notifier->notifier.interval_tree.last + 1;
 
 	while (true) {
-		if (time_after(jiffies, timeout)) {
+		long remaining = timeout - jiffies;
+
+		/*
+		 * The HMM timeout only bounds retries while HMM is walking and
+		 * faulting the range. This fault is handled by a kernel worker,
+		 * so fatal signals from the faulting process cannot stop an
+		 * endless stream of invalidations here.
+		 */
+		if (time_after_eq(jiffies, timeout)) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		ret = hmm_range_fault_unlocked_timeout(&range,
-						       max(timeout - jiffies,
-							   1L));
+		ret = hmm_range_fault_unlocked_timeout(&range, remaining);
 		if (ret)
 			goto out;
 



