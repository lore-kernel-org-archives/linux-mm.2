Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5DACA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A3D8E001A; Wed,  3 Sep 2025 20:23:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA098E0003; Wed,  3 Sep 2025 20:23:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1D28E001A; Wed,  3 Sep 2025 20:23:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 763658E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:57 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3C02013BB70
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:57 +0000 (UTC)
X-FDA: 83849670114.03.77F6FF6
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 523F818000D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0q4iRz0;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
	b=v6TPstxgUMZWKaB6jbK60TeyhVFzbEKEJUdtqcDPUjSufSYY6ZLM5GtToRyjr58byOHVAx
	xjQDtvA1LtspZm69sh3oDV+wbO/mkGYkY+TkzpCVBgkg1k4OVVJp0X8FqsPag8ZV5vqUFD
	VWR/hTGyRgoqfWEsJbzkIMj0m2gJ1gI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0q4iRz0;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945435; a=rsa-sha256;
	cv=none;
	b=1RK8DEsCyr5gvDSFWDZKsFaOJ9xEk+rChncfzG1OUyx3j9dQ2CGefQ7gYZQYlatQwq/KdM
	fM8iYTEMhXhgDDBW5GDdtTsmp1pktJvCZfSnNlmkc1Ruz+MI49PAZvcZ2qfmrowzCR2kQp
	AiBbBvh0Kuwwi7P9e14Agm7a18aKgL4=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-772301f8ae2so429142b3a.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945434; x=1757550234; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
        b=Y0q4iRz0RaRB5zevli3NrLOJJcfgSQm70sYwT+SghrCdViBistvUKR9YFuf+sliVIF
         7RnIzxvJaffP3nuw7S7e2Uh+U7U8y1XT+GHOGXPqDwnfKLdTl745y2I2MnLfRKZmI0xn
         oQBQG5Us2QIRXQQlfkIjELF1nxjvCUDCTpznA0GPD2GjzX0Oyd9y9geuF0MNYXIg5zFg
         8bS6TlF9SGVjyu1hH35YFeIkZMsZJ/7/zx6rFNK322Gu58b5BjXhymn/s07pz2qZz5sW
         oEw5/q9cxRkdoRNBQgGOCdovHn3y9/pVHKptLawYBuERYbiIbiSXXtEyraW/q1XJQSwE
         TWCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945434; x=1757550234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Or2e3wHrlUvOPFgjfY3GC0NcILvcAZ+AmyV41U5R5a8=;
        b=N/WAkPoSChizw5NlqyesgP2N3hwlnCL8HQvDkw9mmwKl44caYzDLQ/uW1UfOhvXGmY
         BT2UBOzKzaqnorTijLZ06oMpEjQA09SUBvCLqSRo6a3FJutIDgcNsulzqq5j2ZGMx+OD
         ioS7ZtPiOpzejsdewEsrSJaM5S/VjPVBDr0x8RnXvqqNPC/wM+CtSqX7e6FOKEt6PJzA
         DMhurUezAzZ/uED6UNxh2LRbbymNcGaURlxAHVA9yUy8xp2br8gh4K/UskwqAhzhGTdN
         IZ4r5Z03FBO0AcqZmlq6JzP8gdw89bvMq811FdFi2RmUpctoL/SGT7NLXo378FuFPJE4
         6kxw==
X-Forwarded-Encrypted: i=1; AJvYcCUqq0gsYkpMcyw2G3/5bRAnp9xLYozdInf0uVyf65QhdeStfcBX8vI//9GJDXqrJCWsRQmKHhvaPA==@kvack.org
X-Gm-Message-State: AOJu0YxQ89T+P8CifMMMzmRAt5kR7nLNB7STf3nvna8xZCM/VVphbiP6
	ZcSrxxRvSeHVuKqrv2Y4bRzf4uZsXO95CK9ewtWLahA04dncLYUWuSyV
X-Gm-Gg: ASbGncun8X7MmwSwdbAU1oYX4vtD80YqMy57sq1sA83dZOfU0tc8qgxphynDilxasvW
	r9vSXtvDEGNV36MJVO1RpI4dSfSUwb8e88auER5/GUCbmQ+wqR1EXcQHv3Kcp3jQx/4s33VeElH
	xvPSHhubD0LQk3jhYvEmkM1IlPStzueNVGTSR3w9bBaHIH9wXWHqrFukb/QTvXwqCQsGQpGBvuP
	gYCyrT2AgxuRMIx7iW1rFPGwUeIYeS8EhJs5QXSSpjDtevtlBBvXkpmo2oyHwMmtn1UcSJu6dRQ
	VU/gCc2+H2DISZ2ub9N4fkQLMekC2xXU8dSU+960ZPfxZZf0eeqD9Hf+CJpsuX9I2BIPTfj5Cme
	LGA5jRO0RTebhlrusoTHyRgCcSIrc4sm2OQFAZ73aiG9gN1J3G63nLrdrRpIOVyY=
X-Google-Smtp-Source: AGHT+IEFRgUm8G3fOt9Njei098V+G0dLsLeU/egZbWUWIOvW90ec1jG3Rb7Noxb0HUZlTjRFfu3Imw==
X-Received: by 2002:a05:6a00:1399:b0:771:e2f7:5a12 with SMTP id d2e1a72fcca58-7723e1f0883mr21918504b3a.6.1756945434094;
        Wed, 03 Sep 2025 17:23:54 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:53 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 14/18] mm/ksw: add stack overflow test
Date: Thu,  4 Sep 2025 08:21:11 +0800
Message-ID: <20250904002126.1514566-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 523F818000D
X-Stat-Signature: 5spaxxk9z4ibxkjpeua13b4nhujztkr9
X-Rspam-User: 
X-HE-Tag: 1756945435-730830
X-HE-Meta: U2FsdGVkX1+68y3BUk2J1oLDTGQ/B+GbjGxYIKZOr5Ma9lk8MGcvJWpRZdkgOQ0iSu5UFZXN7rdKHFyYvywdh1yn9aBYkWr/1U/7cGlOcl6JMBqsQvb01/qCalrM3dWruiSwlZ7EEHutcWjSmjuU45F4r2NLGLpm1LVcXlFZPZVoPdT5r0nFOuWNsPbKfxBk2zIqZeJlhMLabTrU3UuKqBb8kdfuGwlkK/N5bFMk1LE4WYawIlgZj23qLizd7sgunJqpdunK5nptEnQU2bQ6RdHihscy5GNtPtjdZ0tDOiSucxgx6QX+BPJ5KmsKsjP5F7ktGDisSjq2mAIQnqz1Kd3kwT0Nd+px++LrIupgScgIMgWt3pASh0qg+UhXI8NH0Ks61s9+fE755vQ+hGaCmbk5EkRMLfQ49Hs4ytV2N6w55790Azv6aIWRG6KqlWn9+UPzy96853nvDTDbAwDwRkEzHyCjmjNauQVpclXeUcyOiPlrBm/bOGkykF7gApv6JvWDcUiCfuN39ulb9DlTa1IOXRjb8Lh4LYlXiW9E0TF7SHYm+2Jp9c7tOvPobg1POmpIwNVeInFVufszmiUq/LLPr4+YVE2HLCiQqd/JoyH6JDKHCiGEwZLK816fbWbTr4o33ya+pg53KI4/QJyuWLj612Ph8tgmS3KiyXyhdc2Gla3tu/b5vbpxPdrbpsiUv+NYMuTp/9QImS+6ZGQio1UwOHQBLUznwCnn/CS0RnDVPuqlj/3/o2Ut8Qh07eWiWyLpVEqqj2UxMJAu9CcltDjCqdkIbQk+E0U43O7s0ARunvV7HtZ/CsvQZ1NPqWYps+kJ5Sh6pSVX/JRwsM8/r5rUfiznYROFmJC9+bkuOEf3GXhQP2APJkY01h7adCRXnLUVM+7TmDx4qTKvI8YTTjQ0HxukednENZFiJf1CqbimlIvO9PDdHIC3JXz6bk4K2QRmKKNy/nLvHv8EZ61
 i1aDhbyS
 l9TwXhKTz2QnpNIMpYg06jIGKPnm9Kn1PY83rqgkqihVUnHUC6INxQPjIUTRnCBcKdCJvVZTDXMoqS4NIwb1eAItSq7O06pfTDZ6oRcV8Nj0WpE9Y3nW78+Qp1HABi+gjs2EAKxxDimf58xBdBjl32GQ9ut5iec8lZYGmgjP9IFtlPEgZwPhwLA/QXkTDK4NoUxXBJWv4EcFOwUTOR81KTO/cg4kezhI7zzPjsd1d1WYOFvdDWG+0aB57zcqGndPCXxQlhtPkRmvEsJthyFn3AXKhGJLRbGYcyO7RTIf8h9nagRLBctgFaHLvlXP7KZVkyAtklNPJQrvqrezp2hUDnogsp4+JJbBqLFNMhiSSHRqYH8haNqFKKJ9QlWDtYU5lDgnOHj4nRETpvcTaavGzLf1QMTMvYluC3TO87Whb2ryRjUn/9vaiQ+p0kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary.  This helps
validate KStackWatch's detection of stack corruption under overflow
conditions.

The proc interface is updated to document the new test:

 - test1: stack canary overflow test

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch_test.c | 29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/mm/kstackwatch/kstackwatch_test.c b/mm/kstackwatch/kstackwatch_test.c
index bba2ab8530ed..138163472b03 100644
--- a/mm/kstackwatch/kstackwatch_test.c
+++ b/mm/kstackwatch/kstackwatch_test.c
@@ -42,6 +42,27 @@ static void canary_test_write(void)
 	pr_info("KSW: test: canary write test completed\n");
 }
 
+/*
+ * Test Case 1: Stack Overflow (Canary Test)
+ * This function uses a u64 buffer 64-bit write
+ * to corrupt the stack canary with a single operation
+ */
+static void canary_test_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("KSW: test: starting %s with u64 write\n", __func__);
+	pr_info("KSW: test: buffer 0x%px\n", buffer);
+
+	/* intentionally overflow the u64 buffer. */
+	buffer[BUFFER_SIZE] = 0xdeadbeefdeadbeef;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("KSW: test: canary overflow test completed\n");
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -65,7 +86,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("KSW: test: triggering canary write test\n");
 			canary_test_write();
 			break;
-
+		case 1:
+			pr_info("KSW: test: triggering canary overflow test\n");
+			canary_test_overflow();
+			break;
 		default:
 			pr_err("KSW: test: Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -85,7 +109,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"KStackWatch Simplified Test Module\n"
 		"==================================\n"
 		"Usage:\n"
-		"  echo 'test0' > /proc/kstackwatch_test  - canary write test\n";
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


