Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 419FC1088E5C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 23:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E8C96B0387; Wed, 18 Mar 2026 19:41:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398D96B0388; Wed, 18 Mar 2026 19:41:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288716B0389; Wed, 18 Mar 2026 19:41:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F3E46B0387
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 19:41:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95BD3160118
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:31 +0000 (UTC)
X-FDA: 84560807982.07.E9BB37B
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf20.hostedemail.com (Postfix) with ESMTP id E943C1C0007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 23:41:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SKz7/v2D";
	spf=pass (imf20.hostedemail.com: domain of 3KDi7aQsKCNkNJPM5QK5I85BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--souravpanda.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3KDi7aQsKCNkNJPM5QK5I85BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773877290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=da/no8+opguB6P/AaUZzqXEtIBqgc3BRBZUSTCjb+wg=;
	b=B/Ht2hlZ2DVqMckdvsC9S/a1ZxUWD77seXcZzJypiY0zxBs3qhE826R6yG5DJdktN0ubP6
	JIJzSEaJmu49wDUocqFqJ5IqsXneaA6mrBVyeVFXEaVkfV2SVhQ4opWDUDWd3tO0i4DCiw
	sjh7VmH2/ojLZNaWPRwF0h30rAlO0Vg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SKz7/v2D";
	spf=pass (imf20.hostedemail.com: domain of 3KDi7aQsKCNkNJPM5QK5I85BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--souravpanda.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3KDi7aQsKCNkNJPM5QK5I85BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--souravpanda.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773877290; a=rsa-sha256;
	cv=none;
	b=TcI8VT6DMrVb/1QHrECcZdyQ6381DwuE2IBvhfTBx46o93AMpFcYhSosyPSkd+OAEJolAS
	LbTQYSYsnolG9U+zt6oVDbZdvjfTjuO6OjsT6jxsRwb7ChRJJLKwRpUyImf0ztmfL71X8u
	Jzmq2RthetYkbrGjrkIymDDzSa1+Gnw=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c741c4cebf3so306756a12.2
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:41:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773877289; x=1774482089; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=da/no8+opguB6P/AaUZzqXEtIBqgc3BRBZUSTCjb+wg=;
        b=SKz7/v2DISAaTTGQu7Xxx781kKAbXOb3r85sZ4nefRcj+h84xdB+DsxCTJNnPeDNuV
         LrIqXcr5sa2qavLxTwNlyhq2sHkDZxTWgKg3VY8S6G7bDAWOrovAP6hzgka160oaRHDg
         sf6Wt1TUn1bcQoNhp81o3wuaAwmjLt8EpbNeS4C/JJ+7PSqS6WKWWeqBbbaicWluf2/W
         0LQmFTwX10rTrlklDr8mr4JBIF3gs5WXSDsnYJ+RMWFA+2qScTShPGEGjuJb5lmamLGT
         9uih2LtuPM9/nRpjEKE9dd7HHuAT7vitLYiYXJG+bbpX8Vre8tRLfWjOZqvjwZurqFZ8
         uygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773877289; x=1774482089;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=da/no8+opguB6P/AaUZzqXEtIBqgc3BRBZUSTCjb+wg=;
        b=oCxs4Lh1RUrliO5b1ZnOqMyrsk5HMDxzJ5aGvbNDudwlxFCbMjrYw3vMHij13RbD8a
         MLD+mR4oxpw6xFoN8agvQs3u/GTEg1tFLiiv9fFHaSqHMvPrF0+O3UWaIWZMvdButRV1
         5Dfwl2Ry+8j12UPzdH8hxKnBoF9kVPITfaA6Y5ev2cnd+u3+AXnK4s2FB68p1YIvgE+r
         d/O4gKAXVXVt7cUxJfQmOJEzKAyuOwon7JWtOGYoE7L3ZiAKCU88FaiK+bkqxgzlD8OK
         RgqCwd2mejxVDCsOPk/Zi/B/8XRLPQmcEhs5axEB+eKrF2HDlv6B9cwpwNudwr1H8XUN
         hD4g==
X-Forwarded-Encrypted: i=1; AJvYcCUpDn6aWaBlz4M0kBxVjGA8cGsyb46uxCYv2h1YpMI2T5F4kpH8Lyep+R4P1v+UCDfbjF+H+zMJ8g==@kvack.org
X-Gm-Message-State: AOJu0Yw/SO8oAAFFHaDhcHBtrlcf/1Re4uTn26N2jOe6uqUiBeDF2zTn
	pN8LQVhxRh3iC3NVjGmRo8vNDL4Q/NWbpdUpk7YApeye10lC0x5Dsx/suEo1WOeeR6WNj3TgGr7
	AHOf543ZVr/4gfkd+1MZqo38UeQ==
X-Received: from pfbfd31.prod.google.com ([2002:a05:6a00:2e9f:b0:829:808f:cb8d])
 (user=souravpanda job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:778a:b0:39b:a3d8:d81c with SMTP id adf61e73a8af0-39ba3d8e864mr3052896637.61.1773877288488;
 Wed, 18 Mar 2026 16:41:28 -0700 (PDT)
Date: Wed, 18 Mar 2026 23:41:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260318234126.3216529-1-souravpanda@google.com>
Subject: [LSF/MM/BPF TOPIC][RFC PATCH 0/2] Hugetlb Fungibility for page
 metadata savings and network performance
From: Sourav Panda <souravpanda@google.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Cc: lsf-pc@lists.linux-foundation.org, songmuchun@bytedance.com, 
	osalvador@suse.de, mike.kravetz@oracle.com, mathieu.desnoyers@efficios.com, 
	willy@infradead.org, david@redhat.com, pasha.tatashin@soleen.com, 
	rientjes@google.com, weixugc@google.com, gthelen@google.com, 
	souravpanda@google.com, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E943C1C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: hhbhsuy17mwtqjmz6cskcmj6xqtuphdw
X-Rspam-User: 
X-HE-Tag: 1773877289-72965
X-HE-Meta: U2FsdGVkX19Wf7p5ss/6BYrZ3rsGTwZfyWNK9GBJY2NACNQkQO0Grm2EWm+JAPADk7mTSuSr6fcEAY7hik1pQQJ/eWBseDBNm0WSkbAlpsWdgxXhynDCsvOo76BpOIvw5suVUy9XOG3fgwFc6x4aYpQx5Zy+acoAdrNxdMRXNHsDytLHmX8DSaEZb7LSzhsC6sFgOVP71xcL9uyGP8y6YeyddHkmqk/cwfp6YPkBM2VvmV6UVRNXIckfopeXWXJMMW8F8AP4Y5FiK/I7YaDtMYNaIqPrWNdC4VRonBCF3VmuShuhh9XnMGqvTCpraMCej63yAxKKsEATBMbJwHmrUcNhAJ4A6u9PuCtE4IPZn8HzMlBtycb/uRtj18XXa3k9nPZFRZG91T88k1Or8t7aRgy5k17JboAdfzW3qx6R9nCVmw4cJcuo3nhXigtfWK4ubUArbGZEmz5S89BtBmrNchjiKy7a2T2tyhc+q9PqN0ZF2PuHgQpU1qrRC8H3tJfaXPUFnfp6T1UbazTAZO/VozfFSKEhbWmFF5STXiu3B7vhmLmB4/7Tqd/y+u3qVgwZjCXw14/CwCpclnyQI1fUFA/W0LDbTf4IDLa+dRvvEj23GgkvV6lHl3imDOMgjz7AF9afIEWVpGSIjR8iUwD9zvRmpvm6wZdMx2cu36BBfDUzOX7HlkTH//Kp3Zdb1JH4R1IJOkfLa9UNKnVpjx4kLqzS9BEjToGxGm2XH1FAKU0o0pS0Byk1KZkrm6zf6K9ymc3pGEJXrWTfcWYY+HYBJYmm//3Lh3oDcPquFaw7NOVhfclNHqOr+LQY+yUsmdlKRHRWlawfWOfSNe5gBJk+MZ2SlOktNGVet4azQYXfCZ5bDOo00Idf3C9WpL8ejqMHNK28yKgL0b6Zr1tFs7G+aq/hZnoJ6hA5f75GWH5fcmcAdlJRtskJxFL6JCZfgHlDNf5u0FtwPUN+GRe2o67
 0anu7B3j
 2WsTIs/hT0VQyNXGetVTWi1YCRBNYMDrebKSgbgYRthuByQdM7bZPwh0X3TbAyEtOu34tvjLpa38s3pBcmnICa9ky7mW1osC884YtxMgp7EGNy9BbNX6sxx4ipfJ9r9YNtWh5Kv93LsnPLPrMS5EljRA+sf49asyhxJdPhp3rdwg6Yby34XG0sR5uQCKoJYCQqkyf2V6gOu0avAHydigrgEa3qR1U6V2s1409rI+odaesxcbD1PlaktuwgxEsYnONQAEYkFBx9o28XGn9wRDQWReBAdH5fcbg4lMslTbjY9jf3urqiZjloZyxx3hP4/I0WkgrMCOPoMcghhf1QHjhJnhq4RDErwTHU6zbxpK8fNkAANqw4QngUCd5Fq6pyLNYJVqj9vu5fL14rIG9/+xihFqUg0lry25lpy5Qw9zQs37pszfYW7oWpTa/GcuaYorAwOGTJ11swFDIi+KXrO0cs0nW6Vn/e9TxZ6VTpt/ahPpoDyYVfZqy52LXt8hkg3afb2BVgDsxgcmmDmZOAgGEGC+pIae9Sm4fDu5CZYNIjnQBOSx3dFr0UeTY5kTn8+wD/9MAIIAPCsBq7sYPB0Idl5TiF3OEzHBzurz8c29Y06PEyzpiue2vCooCekEyinQskcF4eKofU51qJDryLeHwkqrHP+CLV3B8jdZ4YV606AgEPkHEVp340ZWO3g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The purpose of this RFC is to supplement our discussion in LSF/MM-26.

This is sent as a proof of concept. It applies on top of v7.0-rc3.

In VM environments, the guest frequently utilizes 1GB HugeTLB pages to
reduce TLB misses and minimize page table walk overhead for
network-functions. This has the added benefit that it reduces redundant
struct page metadata overhead through Hugepage Vmemmap Optimization (HVO).

While this saves significant overhead memory, this memory is not available
for other purposes; such as the hosted VM-workload or pagecache.

The guest must balance two competing memory requirements:
HugeTLB Pool: 1GB pages reserved for high-performance NFV applications
and yielding page metadata savings.
Buddy Allocator: 4KB pages required for business logic, system services,
and page cache.

Current kernel limitations prevent fungibility of memory between these two
pools. As a starting point we propose a hugetlb-shrinker to provide one-way
fungibility wherein ~90% guest memory is allocated as 1G hugepages at boot
and then converted to buddy pages on demand.

Sourav Panda (2):
  mm: add hugepage shrinker for frozen memory
  mm/hugetlb: skip hugetlb shrinking for proactive reclaim

 include/linux/shrinker.h |   3 +
 mm/Kconfig               |   8 +++
 mm/hugetlb.c             | 131 +++++++++++++++++++++++++++++++++++++++
 mm/internal.h            |   2 +-
 mm/shrinker.c            |  12 ++--
 mm/vmscan.c              |   6 +-
 6 files changed, 154 insertions(+), 8 deletions(-)

-- 
2.53.0.959.g497ff81fa9-goog


