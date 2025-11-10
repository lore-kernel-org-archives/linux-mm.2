Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22E9CCCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 05:14:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAA08E0008; Mon, 10 Nov 2025 00:14:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791678E0002; Mon, 10 Nov 2025 00:14:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CEB98E0008; Mon, 10 Nov 2025 00:14:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC928E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 00:14:52 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0D7A14C814
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:14:52 +0000 (UTC)
X-FDA: 84093532824.30.0B94F30
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 52BADC000A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:14:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762751690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=nCIIbUmCkll5kK4hfoqHENGIwveb/KYptctyAPm2WyQ=;
	b=VcFJEcDDqC7Yq5bRfWkrjeiVn3lWm4q+Vo0EcikJITV3hHqGWAWgpW/OaqxUQ2Qu2Vwg4M
	sOk5RV36AfJuX8VE6nQpWOSHic0UNyhwh3ZLwKX3glQPNYUTDujQOx6fDlJY7nnItX80tf
	1w7V979PEgBPpF4UaufWoXZM9E3J3uY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762751690; a=rsa-sha256;
	cv=none;
	b=e7yXsRFinjK1csfxBgQt7n0Tho4SC2tC1bJg+TKqA3GTCpojaWJeYsbGYE9DNy9a2tVf89
	Ut1N9F/uwvJ15lPUJ/sWIUd/qwVlfWxcNceQBvX2KSDxPvWsyfymh57H8Tc2EGyaeAcjD8
	YbjL4Rq9L/xiWUgKGW5VgwAiVp3wwxQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=ioworker0@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none)
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3434700be69so3494289a91.1
        for <linux-mm@kvack.org>; Sun, 09 Nov 2025 21:14:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762751689; x=1763356489;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCIIbUmCkll5kK4hfoqHENGIwveb/KYptctyAPm2WyQ=;
        b=ZM3fhf2OHjpi5qbD5mmlblVUs9aNRw9SnWxtPpRgt+l797FUHgZ3gGv1uwT14HAPRR
         pFEc3SqPjsthr7yap0ULBBR/Ey7hmY5EMlNBTAj/EKmiqhRIqDUSx1sD32wPmGj+N0Mg
         snP4A3DSRyXT3awzHagsq7ZMlTzZVNDf26I8VvE1HQ0Jp4qDkPhO2lriWKKLfJX2wCoY
         u70Iu82Iv1JVWyFjNeNkYXY0b3/iLQK5YnovNGLda/fR+hm7zbTlJMu1A84AIyG7ksO2
         Z7ECGjmzuhXERrSOpur4LyP+vfrnSC7qpr+BALmfw+YLPeO4YO1OGdOc5cLViuQvoF7F
         XYVA==
X-Forwarded-Encrypted: i=1; AJvYcCUn7EmkV09aAhvGIK+Sihi6iSgXjANhsHRMrN2UqKMUgq3mojLJBhS9oRyo3K0oNW6gpHbopGyQtQ==@kvack.org
X-Gm-Message-State: AOJu0YyJphNB2D41kLqWUmP5ovEtMsKHMVHq/HQ4WWqm6l/RUIptSRQL
	RvRQJpXrxKK8kOtSRWFBbdiOToEXHKc+lm3rtII49P2QC/oz5FwW2WXD
X-Gm-Gg: ASbGncud3jU3W8lAA8EiQnOYGf4kM7LNPJL3PQsfgckv43pqzOO0bOC6cXXcDZXhNJQ
	w4ukoLlbbLcK3qmAWOQ7xC0mpKYjxLMhpuw2miaOkNy1QQwKYnOKqSLV7M18volGGEipk83qnr8
	5jOAsoEDzNSoWerWDnq7opvG/b+aVtcaWswCXblQbuilmUwNtiBdoTRoeJ36OAqUXZK7MXTZHBM
	Y5hp2z1+Wa2rxqbDt6HWLM1t0haBVLbG161cK6+fCkFXPi/a6AgnR89FD7u6Fx0Ub7EvxJol62X
	CaiBOZY20onrSa7rMo0gAqx4kuSUbxrRcKXJ8lFHzpWJOWLZNpp6r8p4TYwbAvcy1DhRZJcIv+m
	4J9hucqk4b1gr976zmURDzf0PXp7KZeJSyZcRTHpHWNpFwDOQ1O1fNR0mw8BW8Df5GDAolv6Epd
	o6S0cZ410=
X-Google-Smtp-Source: AGHT+IG5OdmbBwJXRmUUCVVuWc4/Mx82Y2ZMrKWq8DF2KYtATXtarldtXNJxCgWZCKf8AgNQKtWNOA==
X-Received: by 2002:a17:90b:270a:b0:340:ff89:8b62 with SMTP id 98e67ed59e1d1-3436cbb4076mr8393863a91.21.1762751689221;
        Sun, 09 Nov 2025 21:14:49 -0800 (PST)
Received: from EBJ9932692.tcent.cn ([2403:2c80:17::10:4006])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-341a699c011sm16182816a91.14.2025.11.09.21.14.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 09 Nov 2025 21:14:48 -0800 (PST)
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com,
	david@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	syzkaller-bugs@googlegroups.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 1/1] mm/hugetlb: fix possible deadlock in __hugetlb_zap_begin
Date: Mon, 10 Nov 2025 13:14:21 +0800
Message-ID: <20251110051421.29436-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 52BADC000A
X-Stat-Signature: 7fdwk8xmxgz8a8tjcrmaqc4tjor97z8i
X-HE-Tag: 1762751690-633852
X-HE-Meta: U2FsdGVkX197vpa+JMkdRicumFmNgjq1U5gWwfK1zx92NDf18nuEbT0BT/c2gIr6Q7Ncp22AACQ/ELlAugUM0a2D55NSQoPjPberdn8Oq/OTfP6xNwPqBxXu3G3QKSGuwkM+yojwzJIZo5BPcPA5f2TdVomUFdm/NaCAp8/cP5AmLAX5C/TkGpEYpTJp12u50bxhDEakYX9fsjPK7C4rRFMAeifyyfsLuPZGLlwU+ZeR0IRqYNBz9PE/R/+5sy6M3wnU7+sJPE7cI1VeIDfcWogiFoSe6RZ4wiL4ce/feDZCei8MolPje20/bBgbMJRXOtl6FbWrapt6Re99GVDUnfPjoZhkYyTRtZJw6/TOPpyn66DDlUo86iaquLZ1MdkSUjbrxvyIUyHSPGiVZuY/oEwK/GbEtlGPvhX5XU8XWVCrF9dGzwxN4UUaR7HNKF4pwmN4YfvbcSi/2/3p3HIzdVGrLcVqy6CI2/fWHm60ZIduoR3IylAe6YQYhhMpxYxX2EtLkXYcED9lGr47DO7rpSLiUjeYi7skSQl5efB/6Y1DNo1O8bVD9BVWX/wX5GNqcNvM4n5thlJnkot1ashaFZ7skqWnzt1bAO5CLNGGa6oi+eqb32T1IAJBfkAd9wxLlTQ5O3ZR24mjDRvrSwW2Jq+7LPcSPbHsYq/5It0f0dBTImqjoXEeUlMWc4uHQCORtOyN4uymaj4s/ZOWuBcIhW+3Z/Y/tVNG/HKT1H5k7oAC4KzBRxPY77vcnMGGZVwk6LmfmtduBUY9HeRiQdHPAEFoYJ9CszKsPfZ8iE6ZPazxZjV/gzmCG5gq1oTuPtURZaUPnSIy8uxF9Vht+W4v32Mr6OSjjg0GnD6L8KklAkebAVDe2LqHhyMghR5GAkg+y4moWIPOw/FsXXIIWegDidgDm0rBAFQ1mK5SFf7+JylKKXMo28AQh1tk9Tdx2U3qA1MeeA5CiiYOBO2V/mk
 FF14tut8
 Sg0J+yARD1cZ72vibvYU8eUidDm/Pkdj2Gjs3LNJ+E6gDPELuryV5T89IBNlY9KKeEJM4cwz3OyyPk++c/sFJXrntwwA4lN87R77MGbQaLVVeAnQwcPvfNcj+VOKyO97MG+TkHjKeD4CTfUSuzrwh/87P3Io1fhvDS1q0mPAUKcOG1+lvdOhR/MeEDGXNa/MCRxm08fWgRl4swcMTOdcjJ9/fMuZlWsHqdBiCdp+eXuUHPHPBgmcn8pFqEMvD4ZYkMtD5SzlozGpcDv/MFBhk9lh9NKrS7jvVc/F0z//acw0vyIcPTEy3Dzj56nHLjgfyN0swoIOWLA7Jt56n08Ir2SsQ3+S4nP1RPz+e+H2tVzVZ5ofre5A9EzJN+l0AQXtg2PKg7bD5gAniSV8ncwGWILXwi5c2Dwicbnj3R5xQFvZm/M5SBbChVBfMFKwspdKnyR44qE1vOPAxSc7zkDlsol8t2CYieJKGfWxwQN9YDQPS+SCLoynlluPPUwRaSnllMVrWFQ7mSi4EdQAAS9Zs/GAjViN/qrHYw0wHmmW14zFeaDroVds94rij5wIl6G75CHVggidnUnBdo0IoNBumffbH9uGXHTWh5SRQW7foOFCzFhf6TZr5ypGPdYsue4saD4z8WUshvWPwHOjntSMIQVoGYMugp3xexA/Z5iqG4M8CsCMSYmVCf2hXpmhtTM5nJ6tNCu9JMayQoR8ttu5EM1RkAUyGmN7HiJQboYXNvuf92cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The hugetlb VMA unmap path contains a potential deadlock, as reported
by syzbot. In __hugetlb_zap_begin(), vma_lock is acquired before
i_mmap_lock. This lock ordering conflicts with the page fault path in
hugetlb_fault(), which acquires i_mmap_lock first, establishing the
correct dependency as i_mmap_lock -> vma_lock.

Chain exists of:
  &hugetlbfs_i_mmap_rwsem_key
    --> &hugetlb_fault_mutex_table[i]
      --> &vma_lock->rw_sema

Possible unsafe locking scenario:

CPU0                                 CPU1
----                                 ----
lock(&vma_lock->rw_sema);
                                     lock(&hugetlb_fault_mutex_table[i]);
                                     lock(&vma_lock->rw_sema);
lock(&hugetlbfs_i_mmap_rwsem_key);

Resolve the deadlock by reordering the locks in __hugetlb_zap_begin() to
follow the established i_mmap_lock -> vma_lock order.

Reported-by: syzbot+3f5f9a0d292454409ca6@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/69113a97.a70a0220.22f260.00ca.GAE@google.com/
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 mm/hugetlb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b1f47b87ae65..2719995af18e 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5327,9 +5327,9 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma,
 		return;
 
 	adjust_range_if_pmd_sharing_possible(vma, start, end);
-	hugetlb_vma_lock_write(vma);
 	if (vma->vm_file)
 		i_mmap_lock_write(vma->vm_file->f_mapping);
+	hugetlb_vma_lock_write(vma);
 }
 
 void __hugetlb_zap_end(struct vm_area_struct *vma,
-- 
2.49.0


