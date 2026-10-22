Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6275C606A334
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=s6YrCpXG
Received: by kanga.kvack.org (Postfix)
	id 70E8C6B02DF; Thu, 22 Oct 2026 11:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5456B02E1; Thu, 22 Oct 2026 11:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAAA6B02E3; Thu, 22 Oct 2026 11:04:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44FFE6B02DF
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:04:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3A0A9140163
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:04:31 +0000 (UTC)
X-FDA: 85350583542.23.5A4462C
Received: from mail-dy2-f5.google.com (mail-dy2-f5.google.com [74.125.229.5])
	by imf22.hostedemail.com (Postfix) with ESMTP id 89D85C0009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:04:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s6YrCpXG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792681469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zKV5mVym2fjfNhUm4DLdJcnKPJbD3s5y+KWCBn/6kOQ=;
	b=gNhhO1gg6RuFFE3dcoTyKLl6nLZVwIGVqB4fcvYrPmCILWSzY7hvKtP+tGwz8AwuwkTcfT
	hfbDeW4qQKKFRUK1nBhYoPvayQVRzS/ZuztBmmnkB7fnPhJlxNDRZh4rgK0tc8vZv1oG2p
	NC1mkMIdcr592HJkzkDYRdvEjEbarwU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=s6YrCpXG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf22.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.229.5 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792681469;
	b=SwWb0q56UBa7LQjVpfzO2gOKpKjcAOB4suyhFqHcbAn3f40RXBLIRCn+EhRBUJ4UC2zr0i
	m2C976wqN8GTwGMCgu/gmcZMmm08zia29Zk1qVofjh1CmaS6Xq/F/7RltcblCZZVGZKDCv
	dxAc9Xz454jVrr9rMd7mcgkeJ9Mfp9c=
Received: by mail-dy2-f5.google.com with SMTP id 5a478bee46e88-35dc2af1f2fso853208eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:04:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792681468; x=1793286268; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:date:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zKV5mVym2fjfNhUm4DLdJcnKPJbD3s5y+KWCBn/6kOQ=;
        b=s6YrCpXG6CxV0gdIfKtB5c/GMXtn6aSfZBnpZa8KHbCYJs4DuPHYdnmX06mCYG/PTM
         kRevsGK4RS2nT+QnMW61yRZUro56s0h5nJ7REM5qKqa67q7+OHeGRdEppa04487AURgk
         ElQknbZgP6VV7yTPcMQbcDyqJgv0qFriLjQBAp4Q0DZjAfi5CmWQXI6Bf5uHbAZ0r+iS
         otzuI/fEI2uWhMHYwnIQA85jixhwmC+4C4AeVbTPGHIPfj/Ther9ckIjvZwZ8fXFtTxV
         VQcOCidTFchiv3V8g2hNzCTl6HWA6fRr2JO3iRAvhsayCIUfJJ8cgH4REpXiJHio5ntw
         mAAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792681468; x=1793286268;
        h=content-transfer-encoding:content-type:mime-version:subject
         :message-id:date:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=zKV5mVym2fjfNhUm4DLdJcnKPJbD3s5y+KWCBn/6kOQ=;
        b=2NkGPM0GrRGnYJK7GuWngs2rzS2f865xnh39zod++cXFkZYtZG9GISADpy5ZRLvDc+
         9Ddbp/YxdtiTlSYKVrnDJcO8rHne6dEbWy3cDUXE3P4wRSnaIywLLTyfAWRKjjDx+BYP
         y4oJaO5ygcUXx/8z3x5YpZrfQG0MMzxXgc7s8Evd/sI4+a4b0qQ4QFGpWn+r1cd+tOc5
         V3Sroj42O8poetFOoV9uCx1pZEqeIuhW0dBLqcUciaulueJ8csr3s4q2oAKvD/l6NA9n
         cn4g+w+KYtL40CVaKtNo9QFdi3MgEFFuIgSAR4DhT8gJTluFmr74bv4SiN98UGrXVps6
         5iwA==
X-Forwarded-Encrypted: i=1; AKwUvBy4T+wgzeEuOgFUcwgm7xn9pUObul+JouWcbwclOhRieC92hOXAiLT3RQUL6it8fEjTQKVyTdvmAw==@kvack.org
X-Gm-Message-State: AFq9FYLbv1bVwJX41x8oYjZvFIk63BNzeFrEHI88NKOwzYS10WU++NDo
	n5rovfQZWOISQyq5AQfIyQaJfl80czaOJEdJ66ED6a2M/0p22mg5/BwW
X-Gm-Gg: AYBFou3+YP7h2+iWfnDghVr/0N4f93bbhOLUmeHjtmcf8rLwSN+MVR00ICTEyGnoq57
	hDh/o022V4+TaaMWQ1PAeyDYDy1uMAOIDKxOrWe0HB2ro11UIRXh2sDkmWu41/2FeXTWhojM654
	Cpdk6Weob7etdupbKRpsCMApfF+OtcyHRZcxkLYCiz6UwPYTGzhBTeeB1hCEtLctr/C2q3Y6jr+
	tMKY2P+7Ha01ldVkYEUeCLZJYeqgAFkPfZ/cJSGFRlo2ZH9wFZU9wvgbCesjND615CwjB4Cx1nZ
	MJUU7pPd3oevH/YSniTtfXAuqzRNLzF23Exo3U8MsYFejI0jXIEHDXMg+ddp9MpcrzgawD7gn/q
	BKfPPacXdWRTflML7c1BdrPPRj83R8D0XF9pFM7jdOgfe5q6t0b8PF88dEwGSorjoNK26Dgi+Xo
	d8fGUyNBvH+JazzJEcO2Lbh63CmK/cuTW3GHFo+9HXU3OgnURQID4a2lwEVJcEhmmySmyoWzZQ5
	wuP1NKREvK/f18/ObzkDpJdDHEYVbSj49T1JOSNs2v8RBfSMsuqk+sijfgQVRzELxRCwarhkCSf
	nCkXXw8UuFGQ8ryjE80Nl+Fd4HkNTyVsC8dcIlmmh2Lkpnv/HdoE3w==
X-Received: by 2002:a05:701b:2313:b0:148:722b:7cbc with SMTP id a92af1059eb24-190a55c1a5bmr6422063c88.14.1792681467862;
        Thu, 22 Oct 2026 08:04:27 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a180ca2sm13886422c88.6.2026.10.22.08.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:04:27 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shubhang Kaushik (Ampere) <sh@gentwo.org>, damon@lists.linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Thu, 22 Oct 2026 22:26:08 +0800
Message-ID:
 <179267916870.2.5637290691657871645.damon-pmd-align-draft@gmail.com>
Subject:
 [PATCH] mm/damon: align MMU notifier range when clearing PMD young bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 89D85C0009
X-Stat-Signature: h6wsnu6nxu7d31sqdn3j6axuwo3ttsmx
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792681469-278106
X-HE-Meta: U2FsdGVkX19/7ueAvosazEyjiV0a3RmDSXw5JWNS/LpX97a5v0zKzgmSiyrOhdf2HKVubMx7CTjGCE2TB0AjMrjQ1jjPmKX1TbPzwgZY3kPHfoXho28fp+OkXSZc6m3H5CdpmDtVinsi8QiU+laETjtNj42nnbg/cgiGlsKhj4D+SIdJVTQBMwl7c0qwgFJIQ/YMZQEMU7ppv4rzQKmn9oeaHaBV0o/LXtaE8wFokIjFbZ/yTWpksHparKNgFJDjSr0QPJHBwj7SEzZYtAem3x+gfhbCyDsGOwxIkeXJnCvnGAeqm2Jk3nDKTWb7iv8TXl2+meQbUoZtT36e1iUu2HXJ5CcRFJb13K+n0YC5RS+6NgiomsRMasYs3dOhNadU9INX44GgcMfj7QZrtQLdlAjkZMQPWCoGPSf3EbjiTWBf476a6LwuYlolgp+DhAIGibKT+H5awDeEeGlXwlwrzkoR6OGC9GJmMeB5AQJCHCeR+YKkP7XsR40rov59boOG0XhUkFnOtng37sCojRNibfoVjcOwvw+zv3iDYPWJ0IQDzM8svA9FtvhpEF/PwzMFti5QGUt2pHe0LSjCNEEkTUjxpKpa724sJMHM4PrsOi+NbRrqBc/zEJGNc4TT1+hA+sSU6R2C9oXc4QGTeI91KGaHp2vva1qfQV8au08VGD+o+vBwYW/jZaN8aMkmEfR8CpPd+WlFr0T2VHzNdJGJRPcaszp8NF4hmZQgDSG1A8CGrHiFjNKIQEjtXfFmTdD4Jy7JXPKZPMZnvqMvgUHUTRsYZ3NqiYKQYOn8S1wSQhhnnKuXY+Gv9sU9M7Iiew3nI8MRUDzYqjVgPc9zMvrvWZgiJaMFuxBuvTAFBf60HyEjC7lmMnV+NnwH9AD3/RrS7GpqeMKqaKvvpJ4C4zBCAvvh4rSAItmQ2P4GXJUIHySotiLlQYAB/ySy/I4CjrQm227f2WkyRExXQxA8uBs
 ICh7smNS
 eRqRw89h5ghoD9oijN6Hfk1G/lLNLf+1OTx9LAQVVBBEZyAjvAVOlcT6vzztnDOhlEcLObeLCcG70JOFRThcnXKKe5ek/WHHd0iHpitYX9SX5Mlv0jj+ykPig3dxn1FtYJ7FOknUxjF8ANpyEAov8335gOgEJrXleGKfwPeV8MQLVsaFbeKU10UypQxJXcWgoLaTPuF4tRxNwVZBsU8PXbqNBj1DkK69H8uJlm/dmwUB5Ow5C0ZlFvlZnpEHPNsXJ9tMLvnedhPKjElgFaVd126Ur+Vw1fFrkSuv6ZjCz2VF6Npqs9nT27SmVAdLQUaiXLzowbLnIpXcjI5iA5qEDt9jmRgdzBi2utYLBS+/uXU1hf8GQKgu8V6Spf/plSQ9dT+4KFe7t2pxz7WQc53ZuTYAFrT99LQZHqXTx3UQnTyVOxPmy0oNtNcFCwai/z3DgND6Vv5nwALCm8u4gk16pcdw74keOjIFhT2xexMIdfji5EaepfWATgTZnmb3zJXbNDBN+6bda2l4bbT7KRz1LDO7Yz4VFyqWN2rJ6+OSNKtNb5wt4f570MIZd/pRJdoOtiGZJZ5olWh3BLVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_pmdp_mkold() clears the young bit of a PMD but notifies
[addr, addr + HPAGE_PMD_SIZE), where addr can be an unaligned sampling
address. This can miss part of the sampled huge page and age secondary
mappings in the next one.

Align addr to HPAGE_PMD_MASK so both operations cover the same huge page.

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Link: https://lore.kernel.org/r/20261021-damon-align-pte-young-notifier-v1-1-d0365ac45b66@gentwo.org/
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tested both aligned and unaligned addresses on 2 MiB THPs in an x86-64 KVM
guest with a recording MMU notifier; all ranges matched the sampled PMD.
DAMON KUnit: 37 passed; selftests: 13 passed, 2 skipped.


 mm/damon/ops-common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 8fc61d0..3b7519b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -83,6 +83,8 @@ void damon_pmdp_mkold(pmd_t *pmd, struct vm_area_struct *vma, unsigned long addr
 	bool young = false;
 	unsigned long pfn;
 
+	addr &= HPAGE_PMD_MASK;
+
 	if (likely(pmd_present(pmdval)))
 		pfn = pmd_pfn(pmdval);
 	else
-- 
2.56.0

