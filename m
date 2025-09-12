Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD84CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5E6E6B00BB; Fri, 12 Sep 2025 11:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C36066B00BD; Fri, 12 Sep 2025 11:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B732F6B00BE; Fri, 12 Sep 2025 11:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A77F36B00BB
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:11:01 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7027213BD74
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:11:01 +0000 (UTC)
X-FDA: 83880935922.10.DC8FF71
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8A2791C0013
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zF3zd5fK;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.179 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQyd/J78t59e431BzK+r1hLIHKrEAjBfy36U2OzrJzo=;
	b=NiKsEpvQPPcwm437bMBC+4AgZ8H7qcVBProixJOdbO6Ptpjnednz43QNS7UuNLu++D1ews
	q+LSzQFj1P+/Vc/dICuUCIo9PvoryMCXeeuhjWpfUKHv3V0h1MkQvpkH6rLlXrH1nD4JL2
	kKooPT0OlsccG1/uiyOCooSTfvIWSDc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=zF3zd5fK;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.179 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689859; a=rsa-sha256;
	cv=none;
	b=YYKT14vDHUaQGtnok5NCQWkKfGh4nuoKiA7ugAKCK/MPiJjVe3+YZfdX/uKjhbiDGTsm1D
	k1tbHxFy29RmkQiPF8kIEp3GIyakZs6+CpFJszlaheYEZ2UYyCVwYzp31LBOwUGk9Z0aFx
	NfcCuLUDKjrT06huX/3lV0riPai4LI0=
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-ea3d9ac7700so620555276.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689858; x=1758294658; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQyd/J78t59e431BzK+r1hLIHKrEAjBfy36U2OzrJzo=;
        b=zF3zd5fKmoCesGKVESGnMPv2bP8hlbNT6PiU4HBNrNFINCZ7dqnc3Mni6+QEEixsqr
         DBi+njhZLUWg3ZRxJxqn+bxTlVfV52AVxK5EDz5SWFWk5wqY3qTdsIJXDBbMtCq9Yplm
         DHQsK63LLb9GNBPeuSf1tnWLFlcmfqeuy+YqPCFKfKwEm0IbwOltRo7Gf7yOlQklPZqU
         /1SvrJ+l6qbe7P6VtPSUUzZgVtn8ilKb9P5yC8slSEyYH+cnAp1WsMRxqMQV/yjWhX1W
         YyQBPlzAF4EisPj+vsNVZglTFVaoUwfnHHHFqF6ehv3tmv6ahatuMXSqjHDeAtSoO/k2
         ZgRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689858; x=1758294658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQyd/J78t59e431BzK+r1hLIHKrEAjBfy36U2OzrJzo=;
        b=mi/ecWxz3yXcvhBGfZSiseCm6+rsx7WW9tJwXXvIRxaF47Q84rlHtTvJpypc8CVGWm
         rLeIx9D7I4UDGfu5C8gu5XpoS3C09YQCl2rZEBxk1Y9JPoSMJ0zfsvuylC8ReOVh5H4P
         phh9dqgEJIIjSpPJ6qXKfOtheUujXLsAkRqERxWAkRPebMj4Cz+kejozuz4TxdWAe936
         Ecj27B9Bckk+NPtWS3ufx2xPFEOlXH7Eoe3mHdZNXpa8bZu6YUZ4Q7PSs+9GEKvBrO4N
         8NtQZBgfEfl596yNIK3eqEL8vZP/NX9+MvMEJCqkHt+6PmXKRL+4nuZvxImuFoOZLeva
         tNvQ==
X-Forwarded-Encrypted: i=1; AJvYcCUD5atWuu8q5pTJxylSAgMTjswWCXT8FpwT6vPDrDtyky9NStDu1xRwZS8YOz1s9wLCoNxuPmGS7g==@kvack.org
X-Gm-Message-State: AOJu0YxL7HRu8Qor/f4/wuokFe/s2xOBRe5fHyyPvr1IEhIA2uosdiET
	PSIdgHxbOv8gs1sdjs/ixJkIZi+5iHqEdm7QZsRI0D2YnxO39uLnm3/RoiC213BECU7v2DGiM3e
	0sb90K324Lg==
X-Gm-Gg: ASbGncuZ8ZSAYYrH2X+Ihdjqz5mUbsXFAmzymTkhdP5TcEhOkHOZ42gUbQAo0bO3DCr
	1JHf/NJY47KYKxiDuHTp+KDm6wcPFmTyyc48cZqOgYdntfSv8nbl4JeY4NkiEAZwWBQ1CtUwdUm
	g1ceTJjGObywJfazjvy3AxknSNu4ckOMJpfrvifr3pPtokjrp9hu7zyk8ymZSzirEmNIU+kJpiQ
	3o0ZhbhMmrObgVtoZUO4VSLnbURMmUyqge+B5jQMHGYazMDiDX75BPMYI4ELwGhnJ3cZalRw8Tn
	5ojvzPih+esvX5bQlwbDp//LlMjOuTb8g0j8TyXWfgWHjluMgUPHqwKQlOjzcTOrk3/vfwouHmp
	8cIZY5j7ouN2DShjiKGlBS72L49KWyOdpYQ==
X-Google-Smtp-Source: AGHT+IHiWq2tZ0Zh+6RCMZ5n4YEMDF8GDIlS1UolWn0dcdm4mJQCk7ANF/Eeoayp4tEVnT1oJJ4YdQ==
X-Received: by 2002:a05:690c:6089:b0:723:9ba7:7f9e with SMTP id 00721157ae682-73064cfc375mr30364727b3.25.1757689858316;
        Fri, 12 Sep 2025 08:10:58 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:58 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 13/16] sched: Add sched_get_runqueues_area
Date: Fri, 12 Sep 2025 18:08:52 +0300
Message-ID: <20250912150855.2901211-14-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8A2791C0013
X-Stat-Signature: rmp73z5378r7814uhhpts6earyps57cj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757689859-270892
X-HE-Meta: U2FsdGVkX19VXHIZJFsiBU5hr2iFF4SDeRKPTCM0oKSQGdyTbK0fac2MQVd901S7ofRhD+Z3Su85LgHkqWg8DJh8a7smJYysMSAOKPi94jmlqh+dZKhxe1Xdfggh2YaXB5081yx8usNQ7G3lZGU8teUzjNJdGSojjJ8DJFc1WR/eNEQwpRejLFZPdaBrhZ2/QrlPiqu8kmPhaB1zxVvPRBkt29cyhiNy9Y97nXwFwHclLrX/G+/g1KR5qtYKXOEd4/WMhhd/gaEnV5XDgzV4snVO2xXjO605sZjzwtSuYmjfpqR1KuGw64ohHhee5kcH2n1+NGgdCQOoKb5J3DWj8UVQOxr7gx5CiEYycyFXBgd/axkxXktAr/zHNzD/96QNvn6Gk6LDV8iEbO5iZQb6wGBakgJhTTSILxHSx18o2YoHc6P+msxkE+oWvQQ1G8+GPzLWCZc4+4YbWAQTfpi5IyJVuVaCSyt9+mUXLXEjIEcE2py87bGkP/Ph3yYcaXHjHv7083r6LTvTuXf2nSahzQHCs7IYPXgggxuRwl0Uzg0kBlT6JoP7rS8UVRtrgg/cvi6UPM+CTATRMbRSX/4+GcTa1SQ3jjHFM7HHzrYr2U4wgb/DeZOV4RZRo9VqlTLty/lI66qht09DDKklnc0qyQV/sWLsKy31KPKhnhE8KVIJcH4mYcvBYOxDGJxgqqWr6RBW3ODYzr6so0r+iuljwidfvlJjBWinibMht2fuaLWVrilWUnUpBIJTToXNpZkQvaXlvPfp6CQgR4nAWjgRpi2cTTUwtFUwQiqtLPJC6mdcchY2VXz4JXaW706aQFPO1uN2jE1O51ISrHCRVlW5LW3RojtP8+RV7Rj+sevExAbOu25H+ga+CwBzj2t/KAH/rKkCaSprf3WOVwuem0xpDjm7zOnurM6SpxZk1xX/xqi4zSNQ5W9dEEq5pgUCrcUNVTxg9jE5waKxbL6kSyJ
 U2Fd/9MI
 Cf3XW8DR4vsafS7LTjkKKOyEeeJn/qIpt9spiLi0mXNnA4sNqOH3NwPi1DaEH3WQx751CD/kOXcxtgEebD+eKM+gUUWANmYoR9Ct6tll8R0KzDAll1PJ014J6ASDHtDI/98a6EDphGfZBbbtJ9ZeED3wnvYvO+o0XM0wG3dIjc84cNopqdHPF2+va6ulWNCibdPGHMbep7uq/oIOdiohj5xtG1YfBxHSr8vAUuhYIjvBle0CfXmBWcxA+Xe0sCiEh4cVjhv1vbuIt6LZhLPDWhTvdQw0DjcGxA7oDXirYI34H9DPVOgazhoba+t7JxYb/AU3sbIGV16VaWXmlnqLXZo3i9jVWG+Y9sldKJHq4ZQnlq6m4ULynOBwkciUdRk5oNRDPbgW5uLEHEk/J5sI4LnmXBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add simple function to get the runqueues area and size for dumping
purpose.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/sched/core.c  | 15 +++++++++++++++
 kernel/sched/sched.h |  2 ++
 2 files changed, 17 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 9af28286e61a..a054dd1fda68 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -120,6 +120,21 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(sched_compute_energy_tp);
 
 DEFINE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 
+/**
+ * sched_get_runqueues_area() - obtain runqueues area for dumping
+ * @start: pointer to the start of the area, to be filled in
+ * @size: size of the area, to be filled in
+ *
+ * The obtained area is only to be used for dumping purpose
+ *
+ * Return: none
+ */
+void sched_get_runqueues_area(void **start, size_t *size)
+{
+	*start = &runqueues;
+	*size = sizeof(runqueues);
+}
+
 #ifdef CONFIG_SCHED_PROXY_EXEC
 DEFINE_STATIC_KEY_TRUE(__sched_proxy_exec);
 static int __init setup_proxy_exec(char *str)
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index b5367c514c14..3b9cedb1fbeb 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1330,6 +1330,8 @@ DECLARE_PER_CPU_SHARED_ALIGNED(struct rq, runqueues);
 #define cpu_curr(cpu)		(cpu_rq(cpu)->curr)
 #define raw_rq()		raw_cpu_ptr(&runqueues)
 
+void sched_get_runqueues_area(void **start, size_t *size);
+
 #ifdef CONFIG_SCHED_PROXY_EXEC
 static inline void rq_set_donor(struct rq *rq, struct task_struct *t)
 {
-- 
2.43.0


