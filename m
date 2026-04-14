Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4FEAF9D0D2
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9DE6B0088; Tue, 14 Apr 2026 10:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA8A06B008A; Tue, 14 Apr 2026 10:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B97E26B0092; Tue, 14 Apr 2026 10:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A80BB6B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:14:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D6AD48BF87
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:13:59 +0000 (UTC)
X-FDA: 84657355398.27.126FD89
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id F4003180007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:13:57 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnAIY2aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176038; a=rsa-sha256;
	cv=none;
	b=LVTnietf6IZHeUA2ZQgnPXXZYRjgEf3ZmaxDitWjOHciigoGvpFPRFvRNu4Pul8+UeYgo/
	D4TCxALsqSReyc/eUFndCnL7fHkomOI7bnF3vrjXcbkQw2BQW/8593EnSRpwEaXrDCeYxN
	DBx+tAhe6O9AzIXujxgA2trkdD4/3r0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lnAIY2aA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YvKLQdGF1hNgVUyBQbdy4v4/PC1QoXHGam0o2m/0ceA=;
	b=teakXo+nmjmmarcRY9ash6Nwtww4mzicgGoH1ofKFZ68NPtqsGatTHYlNPPerI9OeNCFWL
	ktMSpb3cAzXltXctbWczNX4qiPG+YcdeMIjC2tHmgX2zoxyDwKwugVg49B2W04VQK2qPgw
	NJtxtmO36cillaMg6Vg3r6yYA269SLg=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35691a231a7so3591379a91.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776176037; x=1776780837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YvKLQdGF1hNgVUyBQbdy4v4/PC1QoXHGam0o2m/0ceA=;
        b=lnAIY2aAhYztVV7JPPVZ4xVg4QHsIL4Z3h6p/e64gmSH2iNqgVaX/HXM4DPihC9iyh
         nSP5+0cxdKmLTWuGZysosk1rUAmtApCfjCUxG9jVREePwywmZwbSZdhchl9LYyFkxCJO
         fWJT3JtbRzdvtZwUJB7Ls9CVJrwC/juk01PlUnCslMRyLNGWq608P8aSN4nHYxcLA+fd
         fjMpDYeSuag2xOZ0ZiEBsnO9rhUS85+9UNqSpTICjgnO8u4Td51UBzm2yOgMQtlOh90F
         lyvmZqzNIEttNtkgfPTQgpX9F6gkW/2inHz+/sFTqUMyLdjHDhz1uD7Md0jyUiMdV+zN
         Pnpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776176037; x=1776780837;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YvKLQdGF1hNgVUyBQbdy4v4/PC1QoXHGam0o2m/0ceA=;
        b=b1MPO/eRz0QXe4m51SpsjzBRdrDIG58JjX2IOefkSpjllQPXxtbFO0SuYgOXs7AXPb
         cm/xxDzOdjzXet2PsT0TZv5nWqQnglWI+h7ifrY2GTK70KnEz/e9UdydGtvaev8tcJpd
         gZcLBzhP/8LPXNLHVBohpKuxleC/qOOlWCMwnHVU+j7gBafih9xzYld4+ruSZd1w4ckM
         n3LnElSVMRxT/gUAYSHrLVq9vqmMPcjnJ8iDIx5UEyXtksS7yGkSsiendWjMo5zJN3Np
         HWR9taob0nDs9gZfsnH847RtyiPSQEAG64xGa1rT9XfcRuX7BwiMbQmFx3Ax15A1+cuY
         E93g==
X-Forwarded-Encrypted: i=1; AFNElJ9gApQHyUMMPmRGRXgRWuOEnuRbxpQd/nzFYlJ3MYyyRegJbSo8ebYdqkrmZCXCyOT7gfHuwDCPsA==@kvack.org
X-Gm-Message-State: AOJu0Ywn/u3fpaqMVlpXUKvOIGHOtWNs0PIHZKSAL/fZMFGPIFvAs7Oj
	Fmyha8NH2wc/PymeswYHmcXUEyCNLekSXgF6t5Qt7nx44Gp4m1pu0apo
X-Gm-Gg: AeBDietdYY6fggtPKd+qmG95zQ795Fed7YxSuffn9cIPGFNQrDvpYram/LJ2lXmyYOJ
	TeoTCTs6nMkUmOlAZ9R0OMmAMlxsXfUJVovYgpA6aPZd65ygL358LOtnZZTr7gGrkyuXaoH4XNt
	xIpRG7Q3OP61z0UKehZjG0YPjtFYpR6BFe028uG+nUqIA2Em5WP7xP5xGWPd+iorlBfsoMvEWen
	ZgEm4DdYDOVt15cu/3V80uvdIMQeGnfClwD+lx8Se0wYvKaOAePnaRBskn8DK7munUqhWu1VpMw
	1X2Z6ZjxYvWQQbgjxjTUmUJNBzIH/+U7vofnNbaG1qfeUAF7y3VXDPDWsi+Kc9qdcKKpd4BlulK
	b9/olJNWXwJc6KlazmuZ+diwSED8rV09M7GOoqNdjzjuzRk80Tf+P4AS4dGTDPZ5kB4OFYEyssL
	CjB1I9gD0DiiK35C0i7o4lsLzGwoBeYrgAB5lsU8UAZulO
X-Received: by 2002:a17:90a:d610:b0:35a:24f3:2c8e with SMTP id 98e67ed59e1d1-35e4276eb1cmr16742780a91.9.1776176036806;
        Tue, 14 Apr 2026 07:13:56 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35fc6e8b09fsm2250063a91.4.2026.04.14.07.13.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 07:13:56 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: David Hildenbrand <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>
Subject: [PATCH] mm/migrate_device: Cleanup up PMD Checks and warnings
Date: Tue, 14 Apr 2026 19:43:38 +0530
Message-ID: <20260414141344.29949-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: F4003180007
X-Stat-Signature: hppwpgdb1fpmie1ypyuihkfg1wi4ydd4
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776176037-286892
X-HE-Meta: U2FsdGVkX1+hm8EgMuW8ObO/Xljzwg3p9/S6ASQa/XdJ4ILdPDAF1Lg3R2W335Yj22fA6V32e7tcuXRtzQvsrtuHH3WXTYd+oYPDZ6kbfB+V66NfE9GgzKlSIbC/IVk2W5TEnnzme2+TstKtjGqZfSBzwxj+JBe5MvrDJXIs0sVaUD7jVI67sMmVgxe3B8Tz8+HIRPH+ULoQcVQV6ovYSMiJCirchCtMSQBMxM+exHklktfXt3KL5f+CnboK5o0cZGTP9ShLVg4wa4onaK4a6cEcTZ2Gkmo1WwP8HxayTpsMV7ubbpUjZboHSMuhwo8q5CFJo3DAVZxUgP0CCMydZVd1uGWgaqz/v+wHVFjxPoX2VyBCMVcKiCXwQZjz17ozz/Rmb/6rjNp9bQhHK8iZLXlnMd+5A4S2jigtsxruQ2VaEbBJWDp9u3fGRgPlQSqsWPzuCqNZNviKl8AROfAcBj9YtWf3OQ8XvCWoj9vfuLK7osEalOn77ZSD0cxdoohdt5avp+j9Fb1mjA6yyT/wK/ebg6eddogWis1eRqE9ORdH62sCsoVchPc2TQqUjzhLKGaCJr1S3CO6UFiv2nEepdy5twoybewo+lA7YFC2mVw1bgZ7YT3zS0Tir7UZL3aTJMWcbv/hs2Lp/7MVOW+YRwbEvIe0KTHkuxHRyh1IKD1Gnyco2HoJxZaid9M4RYQBNwzw8pdu9OokaicxNyzjMVg7paO6prFo049Uu9C2A+MGoJaKew/xuIGPwzkbqdxM0nrrUV9vxFhCcasEDQf1wjfzA89SsM6fRooKniY7SmZi8VHX5gRFLRvFvzT9vupaKwkam0ODBlrn4rp1lefoVSZNntD4edBu3Vz1Dm55HlLporJclFRi2i9L1wjEeKSWyQN7RHwQtw0+GXpf3iymJui7zP2RiRrGXYWKzDJnwvia5sOqTsmz6eeGCfJ63MAIpQ098Y+HtFqCrNFtwRh
 YMqD2qOq
 5vNeKaut1LJv8iNbwYeztML11KCsf3H18Bh/BoUJ9b/ctphV+UTUFH+KF9bA8HtnI5nhorV7C/r1hqSxFUkS2E2zvk7KG+iq1RnJj+pV7ca3VPVLaE1+ZpH5rbQ6uZH3wyu7pDXyI2EUrF4WecuFOUJr8xDMd6HlfGn5+6rpzfonkI0tgNtPRsf+aV1zHZ+4U+Cb8Jam3RMMcUaofj7cY/9HbYRtPCZ1n+mbZkBBPJL87Q0KmFjn59D5cKtc91dW+Ovlluk0/IsZhnBSEoq3m76RmFBJ72Bwr755mj0Mbzy3ozysY6Ml18mjfSVu2cNDBhOlIcWX7UnrTW5P0OYVACRHXyrGEJhRz06WWBheGXwtmYoBN7SZR66mUQMvtGj7f2Dn/30aC6it09j1kaXBV1HEClp0fCRfJ7/StikYFVYaJllAL9Eim5k8vu8Gx4NFIu5U152+UVQGDNpAFjcASLanaMhH931GNHWAHKMF1R4GAMSSBdJGp0BR+oJCLp8himsqAuGkG7IlkQiDTtpcIQgTFUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove the odd VM_WARN_ON_FOLIO(!folio, folio) usage and replace it
with a simpler VM_WARN_ON_ONCE(!folio) check.

Drop the redundant VM_WARN_ON_ONCE(!pmd_none(*pmdp) &&
!is_huge_zero_pmd(*pmdp)).

Refactor the PMD checks to use pmd_present(), making the control flow
clearer and avoiding duplicate condition checks.

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---
 mm/migrate_device.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8079676c8f1f..fe1c1999aa2d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -807,8 +807,7 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	bool flush = false;
 	unsigned long i;
 
-	VM_WARN_ON_FOLIO(!folio, folio);
-	VM_WARN_ON_ONCE(!pmd_none(*pmdp) && !is_huge_zero_pmd(*pmdp));
+	VM_WARN_ON_ONCE(!folio);
 
 	if (!thp_vma_suitable_order(vma, addr, HPAGE_PMD_ORDER))
 		return -EINVAL;
@@ -865,12 +864,13 @@ static int migrate_vma_insert_huge_pmd_page(struct migrate_vma *migrate,
 	if (userfaultfd_missing(vma))
 		goto unlock_abort;
 
-	if (!pmd_none(*pmdp)) {
+	if (pmd_present(*pmdp)) {
 		if (!is_huge_zero_pmd(*pmdp))
 			goto unlock_abort;
 		flush = true;
-	} else if (!pmd_none(*pmdp))
+	} else if (!pmd_none(*pmdp)) {
 		goto unlock_abort;
+	}
 
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, HPAGE_PMD_NR);
 	folio_add_new_anon_rmap(folio, vma, addr, RMAP_EXCLUSIVE);
-- 
2.43.0


