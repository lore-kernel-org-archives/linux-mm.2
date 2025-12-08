Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6083AD3B7DD
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 09:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CD7E6B0007; Mon,  8 Dec 2025 04:41:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A5BB6B0008; Mon,  8 Dec 2025 04:41:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 694BC6B000A; Mon,  8 Dec 2025 04:41:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52E4B6B0007
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 04:41:28 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9B231609D7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:27 +0000 (UTC)
X-FDA: 84195811014.06.855EC4C
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id F3BF31C0004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 09:41:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPmPiWV7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765186886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrNXZOKlxgRO0yUuW29s8gJG7z3xY0PKnm9mYNQSi3I=;
	b=qiQYrQxBxWHL5CNjrIZY948sIEm8x613JB6SKTHfWFyBlF+MUKZ2NktbNmkxhXSGv8qI3E
	Xg6SPT2QKByoOUBN6kzslytUAcmm04z8KdHXSrj5+FXJ+X9ppfaRli1MqtSQanAWwKvNaF
	Y15cam9YQkwUix0wHxHJpWWPF806TKY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UPmPiWV7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765186886; a=rsa-sha256;
	cv=none;
	b=cvZioydOwbjPgSbPzVD7pxlmZgaw/p/kFEqO807UlfFbzgpBL/JJISgqcPrIQUxowx8cBX
	cVpA6u6JaBesa48xsNbDWnUPWDXMf7v8rm9VJ1voW4V6CG/k2MUjcJs48ibEHFXHqBRqSq
	MFkv1gk21st/EaOCWAMjVlW1k1rbIV0=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-ba599137cf8so1547580a12.0
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 01:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765186885; x=1765791685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YrNXZOKlxgRO0yUuW29s8gJG7z3xY0PKnm9mYNQSi3I=;
        b=UPmPiWV7ID5wHdaMTOAhevMWNYAK/pSnxkOu2vrwIGPAaMhvwJ7SUg5/3PpPzzf9fh
         ICqb3vIiZVW095NyzSCN+GrtAYcXbdWf4PhVTXHAg2evP3Li24sub8ZZ6fXwqVMLVlLE
         JhHZtQWWcv0bgImAdE1awltU3nyNQ5MvREnmDW0UgIjCYQlRiywubKc/+n/HupCU5W7V
         wPpxKdIGuerfj0e2s0irVedc0k12xVHNcayN9Xq+xwP4Y4fAW0mCmbLnRcEWK+yeDHOM
         WKc8iAs7mKXaR3eNvOxKNYoXmSdUBZwTm21/e7gQfL/Td8sG6yTOQG65Oun3s8IOYC4E
         0qUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765186885; x=1765791685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YrNXZOKlxgRO0yUuW29s8gJG7z3xY0PKnm9mYNQSi3I=;
        b=HD+uU+D1UP53FAsuEKeRqZtgU/Syu++lbzZlDj18Ux3u15BYKjQoicMv8JdK/V8fZv
         peRLFbKyjMLALpNpKhFQh/3CeCuZW3VORZGqsHR/pKxH8NENcTExRZip+XGvbiW4eX6E
         vMmNaOyeqRAserE6pF4N7J9M/QO7KrWxE5UoKCsFIEQfV6OQboKbUqwoczYwcE5RLtf2
         3z4G+cWx1gEgPN6XjRDdBagQchQFba4xpIWaIa38VacDdGoDt8qq4Plr+nsWCG0HQTFq
         54NpyMgqUlMWnGbp981dbB7A96J4J9nw9qJu2RZGaMSrfc3zPY1byNZ1SmIPs6YN27y5
         vziw==
X-Forwarded-Encrypted: i=1; AJvYcCW1hOh5stAFXgnNlIviQU70e8ORNmentNo5OvuOdQvhqhceJRnu7vfZXl2uIb+arY4Af43YG9nPdQ==@kvack.org
X-Gm-Message-State: AOJu0YxfAu1u+eLtIhVg/BSh+6zixeoF0iSIK/+C43kBmMs+uP2Bt9MB
	VbQKlEWEk8gfSP2yKRF61T+yoMFaJax78UYfPqKuNvHIrMgZT1ubkPdz
X-Gm-Gg: ASbGnctSABT+AfIvGEwvqrZyxki30qJKCBOQVfDfe/dqT3KnaQxd0O7wh1YfWx3Eyi1
	UW7dW37+5VHgSkfds5n/eUT9fH4zZ3DJqEnAY/wQDgEeEIBu8iF5nEn043FYki9CAIFd3pSbIXM
	YsBxyN+9xPdyvwKcTlEyhS6qmg818nvIOx/qmG60sUxm7FRPyDU7wROXSRVv1Qcb8y/JfzL9Ck7
	Wpu+3nNboHNeNZHIuKKjLpVYa8Evt/xyZTmTHHeb9TgDFef5KOaUVIE0AUDBoEQ8AWyNbhwOj1u
	L3y+no1pru0ZYr8HwNO2eN6h8pFaQ3o00sgzAuAtDRsGMbmER3x4nHRBLnXZya9YSMHlT3t4ON5
	dm1PQOE1CPhdCXe7qyNxIfrbrGuPdDMfrRZ+Z4RKnrk/yBcjmzrwIRfoYR3RvYTYa1SC+3yZXoT
	Gkf5JZR8+AKy2asQQa3hljuiIP
X-Google-Smtp-Source: AGHT+IH2gvj0cqj4kadasbx5J6Um1ertdus7jcEuIr+SD+BFGC8ZCznhCkpFOtQ4+kihzfBZfZN8nQ==
X-Received: by 2002:a05:6a20:a109:b0:366:14b0:4af9 with SMTP id adf61e73a8af0-36614b052b9mr7799200637.32.1765186884634;
        Mon, 08 Dec 2025 01:41:24 -0800 (PST)
Received: from localhost.localdomain ([240f:34:212d:1:e251:d9f:c2ef:caf4])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bf6a36bbc60sm11675279a12.36.2025.12.08.01.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Dec 2025 01:41:24 -0800 (PST)
From: Akinobu Mita <akinobu.mita@gmail.com>
To: akinobu.mita@gmail.com
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com
Subject: [PATCH 1/2] mm: memory-tiers, numa_emu: enable to create memory tiers using fake numa nodes
Date: Mon,  8 Dec 2025 18:40:27 +0900
Message-ID: <20251208094028.214949-2-akinobu.mita@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251208094028.214949-1-akinobu.mita@gmail.com>
References: <20251208094028.214949-1-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cjpknunqxui9u8mxfons8z7644njnjj7
X-Rspamd-Queue-Id: F3BF31C0004
X-Rspamd-Server: rspam06
X-HE-Tag: 1765186885-991191
X-HE-Meta: U2FsdGVkX18FXd+ehJ8VaXePVBfbBefAvN3mpGwxcBSR0Hx16qRyUIoZkKH4MoapGdsuwobHndso4s91Rk/KUuYz03OscPGK0QHOKq+GHQhb2BYg5VPxbuMFZ9rodZCRCkWDUNXrFsU0hTIAY1xP0IAujj4Oi8VFtkA11bZktMkkYPAssuNFoChcgk/HB8Ghux0aFXqzKr7XUY56/x37JtuHYQNRSO8CT129bjULbAUW44e4jqnMfieisqJcKBzV6VO+QA6WctZqvMVJdL7f9dPCRlsvMWX2+FVkhezvp/pHr6LoJgQt3EDzXwbu6VxxVzZVTrB1BETBCq2jFKbn6go/xIcBKJFVlirhh9bKIiZ4SbLTXtt1ZuOYozi84WugSOfAHOshHlvE5xT8pSazdeS6VZZ9UIuTxhwiWnMiuEJp3tiZlaQ6uMNUjSAHIKqLqfjv0YlXu+Saz5BRLQukv6RgWz8eeXfS3siyzcjLvwmiuOOjmN8kKKYDCFt3E0xC5b1+TS5IEZvQ+lnScuOEdcgdq29JqmAVnbrvBLWAnw9zCYvv8rwmFiVhmyqXz26kufXCDyR81pdnlmQFnGzcnr/JtDtYRawQ/oFLrFJD2zXNAaeMhe1kT99qDJxpvJEwIChUXk6YiLJ39LMEhCC1M3HlyoZoEWgTXvgoJ/iDgAMJVqjZUeO08S1b4qka13m7SNaZzuGSw0TjnTWcKP2lEupyqpst9vBTHgH9b5WHqYx9pKsj3+tfyjY84W2CJPtXGW1XoR+lTMi7iK5RbMYMjYWYZu//PUDZCVs79qRnzOzqIpTFLWYhstvVDKE3P/68dfMOzwoTZKAVmwc3yktP5p/zLnwk7ZLpPakKxZ2E/KEXoThHdTs1qB5wuXHiJcd8at+Rli/7Y6Nj30evZE7sLjR1kEFNtRvhU4hy048iuuAikbWZY//NmqZmqoVllL1tveQt1WSknGId55/kuuS
 0OgBZwBY
 g+3ZMVgkVkUhOXHlO6rAtPCUYC/b7dnkJfL+maOQsyCuJBK2V1JbSlTUQfKNT6uVYfT7NJxNeV65cvC398BX66QelrcPGMoG36PKoGdcPBKvc/8fU256Vesi0g5pFmhu3uqXCN0mNrX/XChwckp+NLV+5uoPzgxyoXbq/NCDo6yf0DRgKCLEa75/5IKM1tg2ogJo5tpPjsxwVHu3Z4s7HD8gssY6ji3HsAUVLzIPBG340V4Uv9J9Vy9denQaxwEE/VHb6Vcj64sk/1ldpUoogQIVbB7ZB2IqVDNGnyAnxLeo4bMNJooT9MP4QE0TV7yxVsiZ9AokZO50Ha13LB7yVlF9eHhqCjJTpfgci+gInGSx3JJ7RT9dzsWhqIJXzmkKrMG6zcctCJwibJod9Xx6mgkFfPGVRYg1+Gx9jfU9O2e/b1o/zTJPYaU8dDBvvVzGHatI0cSucV5prvcpPkMQUHNM/KVYV0dZ9Ve8y+DJnVf6itI5z3tRpFE3B1YKBDZd5Ehgm3Q7WhVrCJdd4NX6SldUMw+dwzvioZqAM/fZgtwW6Jo/fO7XT2c6E31DCRUsIgA5fZoPKcMDy0hnH13+dKnOdVxLeSHFwvLIMXcE0uGgNKEfVGvSF+13J07W5dqCnm+nHZJVY5tOXuiU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This makes it possible to create memory tiers using fake numa nodes
generated by numa emulation.

The new "numa_emulation.adistance" kernel parameter allows you to set the
abstract distance for each NUMA node.

For example, if the system is booted with the parameters
"numa=fake=2 numa_emulation.adistance=576,704", it will configure memory
tiers with node0 having the default DRAM adistance value and node1 having
a lower adistance value.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 mm/numa_emulation.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..a4266da21344 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -6,6 +6,9 @@
 #include <linux/errno.h>
 #include <linux/topology.h>
 #include <linux/memblock.h>
+#include <linux/memory-tiers.h>
+#include <linux/module.h>
+#include <linux/node.h>
 #include <linux/numa_memblks.h>
 #include <asm/numa.h>
 #include <acpi/acpi_numa.h>
@@ -344,6 +347,27 @@ static int __init setup_emu2phys_nid(int *dfl_phys_nid)
 	return max_emu_nid;
 }
 
+static int adistance[MAX_NUMNODES];
+module_param_array(adistance, int, NULL, 0400);
+MODULE_PARM_DESC(adistance, "Abstract distance values for each NUMA node");
+
+static int emu_calculate_adistance(struct notifier_block *self,
+				unsigned long nid, void *data)
+{
+	if (adistance[nid]) {
+		int *adist = data;
+
+		*adist = adistance[nid];
+		return NOTIFY_STOP;
+	}
+	return NOTIFY_OK;
+}
+
+static struct notifier_block emu_adist_nb = {
+	.notifier_call = emu_calculate_adistance,
+	.priority = INT_MIN,
+};
+
 /**
  * numa_emulation - Emulate NUMA nodes
  * @numa_meminfo: NUMA configuration to massage
@@ -532,6 +556,8 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 		}
 	}
 
+	register_mt_adistance_algorithm(&emu_adist_nb);
+
 	/* free the copied physical distance table */
 	memblock_free(phys_dist, phys_size);
 	return;
-- 
2.43.0


