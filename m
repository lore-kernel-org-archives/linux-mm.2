Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50642C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 07:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694E98E0001; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C5A8E0006; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50ADD8E0005; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3FDB08E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 03:58:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0464F116289
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:17 +0000 (UTC)
X-FDA: 83749208676.12.B0B15DA
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf26.hostedemail.com (Postfix) with ESMTP id 217C2140006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 07:58:15 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KTfFx1tM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754553496; a=rsa-sha256;
	cv=none;
	b=aPoR3eIMruyMZGDuxqVDMuvRBDxwEw6GiP5C+p/m6tVDQum9DOzbBaTzfcTHoF+PNdy1gm
	rtyStcq+4y1x0NJjC1S9G1mQqv1ow34F4s/ej+z5rOJKbw5ok5gcK40v1q6wkMKi7ZWm8y
	1WWZvFp8XZVPusvnqQVqCwN6kYQmIQ8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KTfFx1tM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754553496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h92qlRGpNpOttoa5peB/v55STRwn9jHtqjasT4/y+5w=;
	b=suY9IUbPhcr0Ib4sfWxKdn7iRlzMdUOPGZ/LedL2/fcScmLX9hpuZyG360j+GJyFRYYBei
	07XghFgpcQU2ADauA/iYJtZ70cVv5nRlBGpILHn9CpthnH7FGbE812lmfzHE2QwciNcr3Q
	NKzK36iPIoEPCzr01raOMvAlNozIMvI=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-55b7e35a452so775479e87.2
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 00:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754553494; x=1755158294; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h92qlRGpNpOttoa5peB/v55STRwn9jHtqjasT4/y+5w=;
        b=KTfFx1tMJHz0FRt5wyVy3dOuZlOMEoyO3YFlOhG2SCo8TJ8JGYhG+tQs+Za5um1R43
         yTs9PwHGRMO+g7cqrveHrSg30mCu4XdhZnDKnvEGNREILxK22PaEq6YqIyqwDFGyPO/0
         eWEZouVBwyEH13zthUKcYGQZ8DjzJn5sfIpCztcvKVEdjq3KTuS4np2Y523zv5y4Ijdr
         eJaA36zEgf8tgMNPLYqNpvhvmAi7+GFMolTLII6Td6ks24PdoS39J0R/x3041mz+iqSS
         BlTyaXQT4AtQDnettI2MrMvtAIVoafbxCPtK7GE+Y94zH8cKzQk5T7T5ait/4YP6SdYW
         BZ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553494; x=1755158294;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h92qlRGpNpOttoa5peB/v55STRwn9jHtqjasT4/y+5w=;
        b=hm0v6g0CjDakPXmL247sGn9gPxXbAbz8rOSH1NDZh0aK45mvRZtdCJtV9oGOrGt8eq
         O9+bpOv+r7Qu50ofM9u6eExdosLlDl9YPr4Hd81VN8teSsPxOHrDLzNnZiXWQP86iXh8
         2v8vLo6yOPpcTydhZd8uY1hFl/KkE6gFc4KS68XIKQm9lHuyuh9GMbCGMDjm4db132oR
         fSrUdHaXJVjj6a27o4HhWI7CSBz/kPeRz9oRs1t2Z5ICTq4o1gW/XLFcQ6wIfDfgsP31
         jRo5r4JisejuSyvBmf8liq7vk2sR3OD+DihHDWg2KkK2wWM+w1VMfn28C/9MFGZToFwi
         dCKA==
X-Gm-Message-State: AOJu0Yxv0IdfJhtYdP7fQ5uK9L9ph7uoDwIaSktHFbSuz4/rhVmiefiy
	bJbHDLYZaFBt6eaRxk2qWP9jHH8+Bwzs5yXA3ma8LFj2LqN/lSw+RWze7ammFg==
X-Gm-Gg: ASbGncs7VINRov24M04TMnsq3E0FAGnpHPvqxEn0i2chD+DdKZHQn30ln74j7/Aob7v
	KlNbK+HyOByoP3sULRY6fmuzfzMbKjQ/jbyJ4s+vkJliQR0YSX3G3ykQq3WZWYW86nwWRaZGNiR
	/hYinIeUDHNMkj897eVkExrGrdZtoVv4tbb9gt8meEUHUsq5NNJ/oQFMdn1z9UXlkINaxhtY4Cu
	ldggw0yXYoxt0cjoZYtylPQoF/M3TXZlDqJirST76eoGhow35HKOrfl30K0YG1IS3msaKHmkbjL
	z4PWtwUP268PiDoBY4O+KPiO+G75fpyPVdTYtrERRanKj74jinzqehGzXcHAAsjzRZ+PAMGfsgZ
	+kB4pXLdE8JvOHpkTAA==
X-Google-Smtp-Source: AGHT+IFA0xGtyd8TAvISAHbUul+I0DeGj6jXQhulf4UCTriFlDW6HXVuVy6Cp/dIwNbD/wOAFCuoYg==
X-Received: by 2002:a05:6512:3e08:b0:55b:7345:8386 with SMTP id 2adb3069b0e04-55cb674cc53mr612797e87.17.1754553493585;
        Thu, 07 Aug 2025 00:58:13 -0700 (PDT)
Received: from pc638.lan ([2001:9b1:d5a0:a500:2d8:61ff:fec9:d743])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55b88c9b1fesm2501995e87.96.2025.08.07.00.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Aug 2025 00:58:13 -0700 (PDT)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH 1/8] lib/test_vmalloc: add no_block_alloc_test case
Date: Thu,  7 Aug 2025 09:58:03 +0200
Message-Id: <20250807075810.358714-2-urezki@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250807075810.358714-1-urezki@gmail.com>
References: <20250807075810.358714-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3c1mhhqs8zgoox9u9tiotsjb5dygjmad
X-Rspam-User: 
X-Rspamd-Queue-Id: 217C2140006
X-Rspamd-Server: rspam02
X-HE-Tag: 1754553495-51946
X-HE-Meta: U2FsdGVkX183dkrkPLToTBY4WfEVLb4tUFC9MdTzZPPFKJyw8rknZpgIH/bxNi2qBGxG8RWf5EhYy6AJJP7LqVC+tdpsMGYvcQscyeYny4sqJIi7NcR8ZN2Ncx51L3ODKqm0lrz0jr73eJdmqhhkSrqnUn6mVqzs0pQx2DBKHDpb7VurhMYmgPhVTINRXQJbC+bq3e9AIpw83kxsYQ+gGyKbK/PkLftuEKu/KMRL2g5Ry/d5lDXHXAn/b++vxLMrx3WJ+u8qg5MRtIvNtf5YHo3/3L3j9cQSlDkFnWlfEf+XLgWFIAkM8EL05eoZRzxjRiTAOIySsxFCDGWuJssoLaUtU1g4I/dB8evzjVHJ7eF4lumhqrx7RjIixPCdZ255DJ4QAc8LXghrm3OdVIJcR5wb0nCtgSjOCtcrtN3kHsXXaizkOkoPVaKy2e/nlb+fQZ4qsGDqVCGkiZNXrRYJQZisXEBpWctbT6soJFOq/IBaR6AsrKUlSd0mJiXw6x1xUYa3hVicbi8+3CT5A/XrP3MZHz02Sd/r9N6ZOVaaKf3xljBkI4MRyO06ThGeOpxwXAbV7yWelnVZO+DbJo0oS0LOSc4khhkSXdnDRXj0UexTqNLldXq+ap7sdFYd6/US8w7MmagVUtJE7IgLh4fA0O4w+02GClW74MmLjjU8Kg7SomNLFF+X+8WK49pXyAsDD37qgi6htZUhNX1DmfurcBMwLRrkMAco2iY5XPI3c13sYOERLgqlwz8tj0vHZjdp/j2kJrEITY3HRcXMH3i/JR5PDGqh+5fHG9aznTcWpVYaKdv5Hx12q6QmPvfoUYdzvi25dFjgiHdPqZqLNFUiMl98FEL+aOSZIBDRiIMjfEnedio9lOQGY8nYeyZX15mRFyl+mzP1HJteuJlZ6Fa3bGP3l1Rce2SQ0/m/kK4ZGxuBLDYTwccVH+LwCbKHHzxuJnj733wOS58azGpP4/a
 Edk0AvlV
 BQhlxs2q0Q4bMtsAOC9Dq9jfGjI6MeKJObAAUc5HiFlv+eilcU5HdnqIEwHWTfu3bFOdECRKPIfrpWxZzWpgmsL2sUbtjJNemprjBatbxkp1bZHaEsOl/51aRfvjYAwp/neqytY7o5m5r9Fji+4ij4I1nm33QT88LU5kKCwX2LdvWuWoETxbe3bSbfJd+uXeztV1zfzeVuSTijAjnJ46TXJ5jjbm8hdb1Xo6kjasp0TbKPqyADTzOoAKbyR4rqfXiKKyvl0OEMFzbG3Eyc9pko5gaKSR1CVePJk7o9oL2mJeQtJZcrDUN1DAFZ6fUK2ZHVQSeW79idFWUpsdExObAT9Iqg64sF7yeBRq7Dr6uwbVxdQPgpHTwBpg9lzvS68/v1kXsTDNbqzBbYuM3cfyPW9YfZA40wdGYljaf7PVcXPSNoKPVcdwXNKP79lRF3HGsXPEndgFqsQq0MGvHzg27/VRSbING3NarE45aiKsMKSgi2z+kqpPVBpL4Og==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new test case "no_block_alloc_test" that verifies
non-blocking allocations using __vmalloc() with GFP_ATOMIC and
GFP_NOWAIT flags.

It is recommended to build kernel with CONFIG_DEBUG_ATOMIC_SLEEP
enabled to help catch "sleeping while atomic" issues. This test
ensures that memory allocation logic under atomic constraints
does not inadvertently sleep.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 lib/test_vmalloc.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/lib/test_vmalloc.c b/lib/test_vmalloc.c
index 2815658ccc37..aae5f4910aff 100644
--- a/lib/test_vmalloc.c
+++ b/lib/test_vmalloc.c
@@ -54,6 +54,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
+		"\t\tid: 2048, name: no_block_alloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -283,6 +284,30 @@ static int fix_size_alloc_test(void)
 	return 0;
 }
 
+static int no_block_alloc_test(void)
+{
+	void *ptr;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		bool use_atomic = !!(get_random_u8() % 2);
+		gfp_t gfp = use_atomic ? GFP_ATOMIC : GFP_NOWAIT;
+		unsigned long size = (nr_pages > 0 ? nr_pages : 1) * PAGE_SIZE;
+
+		preempt_disable();
+		ptr = __vmalloc(size, gfp);
+		preempt_enable();
+
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 0;
+		vfree(ptr);
+	}
+
+	return 0;
+}
+
 static int
 pcpu_alloc_test(void)
 {
@@ -411,6 +436,7 @@ static struct test_case_desc test_case_array[] = {
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test, },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
+	{ "no_block_alloc_test", no_block_alloc_test, true },
 	/* Add a new test case here. */
 };
 
-- 
2.39.5


