Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75B2ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5DF8E0021; Wed, 10 Sep 2025 01:33:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B657D8E0001; Wed, 10 Sep 2025 01:33:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2DEA8E0021; Wed, 10 Sep 2025 01:33:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8AA2B8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:33:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30F6F1605F5
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:44 +0000 (UTC)
X-FDA: 83872223568.07.CA91A3A
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4D82540004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:33:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f/ip9tkJ";
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xjx9GLpO3aNSMJAiegkOcLHgHnGs8uYVGx2kXqhm4j4=;
	b=xiUh1Ld4Tjtq/xfMfhTmVqPBtNMyKuYknDrfhaoR03NStnasVxkk5ORa6i7JTMyGWdmYix
	d1CU6d5o6Yqk12B6dxRTek/AkmuwPLOEp2ou79QDzxdEmYIPX+87xZYl8hppL1Bnj+z9EX
	ikh4+ZOf/gOsFE+cuKO7u+P0Xg3XnC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482422; a=rsa-sha256;
	cv=none;
	b=mQj4TImNda0IK6w4TlHsQ2Xw6K6gx4+Yx08XpVICA5MYFnzBMmJ4ChfKIM1vfRNg/XYqK+
	9nHxlXSpzFt+aEXpTI8gLF6uEtuLAVFZfSIDx15BZXhoc4c8a5Zp/vGO1ji2VV9EgRaje7
	87zA8kegLpN+ApRygiAkN3LUtlVJTFA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="f/ip9tkJ";
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7741991159bso5978800b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482421; x=1758087221; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjx9GLpO3aNSMJAiegkOcLHgHnGs8uYVGx2kXqhm4j4=;
        b=f/ip9tkJncHRRGNAlAdSrUotI9IhgUpg6Gn4PtnEOrPDoIXAU8VQqb0SC4oHfHY/GI
         M1k95D7O13jLAaMf0DHDkhc/CqLZ+38ff3AMKHqhw4AWiEpnXFKPKhu3jFfYPGzVR31A
         N6mS1hp7isNXPN7J7tvfSU006k31/GThP17unoN1wYxOi/TNFFLGeKLHzTmIJlGBaZRY
         cysYGvi/1R7zb0zP7T9869tYZ1Esshry1TNr3ed2OSLRsX3L3/4YghWenGwSnW8eI/oQ
         rkIFOxEe7u1t7tDBbmGpJWyD1vJPTGHALqPRDMz/gVinagMvmiRCU4PU51DU6PF2BjBj
         Pk7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482421; x=1758087221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjx9GLpO3aNSMJAiegkOcLHgHnGs8uYVGx2kXqhm4j4=;
        b=B3LEfRetxRcA3WYIQ6nAupTPfFUmCEEm1faQRmn6EB21uhH1h78oq1p98M785rH8rt
         TFy5T/G2tOhp6zQRfFMby/eBUntl8hNIcHoQHNdqiP+zRk9lK5mAl8TPdLun/ZjDInLD
         eX9wvXWiJOEl5Dxl4VaoCo5ySKoCaUvSGOR9XwANDM2PD4pT8QIzUK4kV/KC+/kpHoRm
         6mL0HxhRXmAvJExHyIu7pm+krnT+7Jc4DheedE+w3g+Acj2qyuBikhUkDwDu+a6Ay4WX
         +lzwaQUQyLiP7eU06WQwDLw/CKLdPMOyBo0pR8sygNa4MJa/jQQg74sO/czjF0SY35iN
         csSw==
X-Forwarded-Encrypted: i=1; AJvYcCUEETf+90QBSD6wXvPzXaZRXX4e/B7CdLhC+hEIHf2/9Ff4bf4rDiAnCvr6ZuaCYWGC1mlSHihPgw==@kvack.org
X-Gm-Message-State: AOJu0YzVS9ILuBQ6iYG34NZ/7sR5iEbeSoNo3Asgjvxb6FwKY6rSbUtX
	jTX2Bs+j+puuUe8EHzpmSmIMTg4zf10o6xO7erCTJlHxojCI1//Xdvnj
X-Gm-Gg: ASbGncvV7mCTIFgsbJxUAErkUUwpasvJ0LQAU5e5ZpS42tokS6+XoOiw331/EcUsZ7K
	LwAqkPs3SAr4QkvbTWk153d+nNtdGNHyFJxLMjse3B8gPjViHA/N2P1tREJBoE7r/J6Jd0PsG3v
	faSH73Bel278fJU5bnRzsw7PX37t59+U/RGEIQqWaamW3BdKvGb97jklQwapAT3G6Kusm0AMJ8c
	uKx/hCG1+KA2llWEGu9liK2+MUZ+TcpjPnq2oK17HV83cISxlDEBoK/iRIef1eIl2mo3e5RyLZh
	Pe+c10agGZtBLm/JDwGpjYMloqmh8nTe5UIs/weZGOsWoc7eUC7rs5zsPN+Vn6k+4WsJWF/8PNy
	1NLlD08EZQ0kHf2RVJLT/Ra64AiEhhDk6imjVeVUVKXTHqR4/IbfR6pMvp3Kt
X-Google-Smtp-Source: AGHT+IEunPsIauBemdf3Vt4yXR6Fs2bGNhkFdCqlEcAShsnuX701aZ0gNgsx62qzOw6WTfagWUVx5Q==
X-Received: by 2002:aa7:8882:0:b0:771:e179:343a with SMTP id d2e1a72fcca58-7742dea0275mr22122301b3a.17.1757482421165;
        Tue, 09 Sep 2025 22:33:41 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.33.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:33:40 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	"Liang, Kan" <kan.liang@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v3 17/19] mm/ksw: add recursive stack corruption test
Date: Wed, 10 Sep 2025 13:31:15 +0800
Message-ID: <20250910053147.1152253-9-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4D82540004
X-Stat-Signature: djfcb67wxcu938orf4hn4xrph9tomgig
X-Rspam-User: 
X-HE-Tag: 1757482422-728619
X-HE-Meta: U2FsdGVkX1+LPRXB1mD0PzQMnNzewnbSXPuQF0TAmUL0n2G9l1r3SmHN0IGXi8EotADaEiDTfVxTysMAsa8Ns4guyVfcX4d/MNKJ8fAu0zPy2UivxIPEyE9hXy7TPsfUtz707h78+pXRkHlgv34rZVv9FsMqKKkFzrtDFvpZN3g0iHPkIiVUo/d6/RiWwwgyNCopI/XPm1O7NldA2VyOu4LHIpEQxlRxeqpiP7iYJA2nAUSvPWuEmQHO1jisyYjlogJ3EbXYhM9OVt/I7S2Ch3l+57tuiQ1OSdbad/UnA3tI4Zc4jxX7Fz/xj48XKZCJVAKGJ2EVOK1hF5qV84n/9V4SP80fXv1qrg6M+h5DPsE4qXlrE83VNBBR9XxcKE2xTPT7cBeEzE8ilX+RJYPoHI5se+H45z7CAQip4VorxlvXmTgQihXWa957ybrPl+i+VFCzQoQ+y1X9UZFxsd0+/Ko+8ZthlTa3Dxco+GuQPPG/35cr/OCgYOyDKBW562Y4murBMXiQdZfUax1deqEPd5kbs9HtcsrB7B+71ex+w+vDvDDLRATxhEca45QL7YqTeMu4Es5t7PZYTHJBu+eiGwtIDsXocCURQuk9QVTzkcd8aXKj3SGO3JgCzwvn0EAJ1fheA/ZxyXx4pK6pY+gypq4/yHJVfFF6HvE9bPYTAOD1E4SbjCezeQHeqO+8E5AMCobyZM4ne1GRpairl3OnB6cTkdS6xUpoPxVLE4wzAd5b2vsF5R4hYxuHQJL3HY6EyLCfy4F0TBJvbEkyrzTWD+RwygEMr3apMe0Gf4EWQfqdW5ZbQbd9S8/MbRwayVR35OOQfUjV4+JNjCZuonpuzj7tXipPLT5pAk3n23ZBxEMwSItyaoK14a1qRxRH34KE+oFqeBPyrqDJtjxqyYxNI6fHu+twJJsgyKqBguSUYH51W2S9KtrZeNh6glv6caJNrwhJ/lDlkRS4w47y+XO
 TB+kZ1S9
 9xAGWvwuZbviOecyS7CY03oF7AKOYoJx8Spbazr8QC7KkN1UNSIikfGo6NT13HgfZt0y0fwxQ+mOIGNRWjKKzOFZSsIiGb9HrCtw+r7sKQjURbS+QdjxhICrvRwAlCyPxidonENXtHSXWUdXBYAWCnsztUwyuqUM+LH12fiPn5L5y3A08wpV1FGYBexLvuWFTByP0aAcpxSPz+RFeAXkn6e+OvATdOOdHX1fbRFOvxan5S0Lxk3dl9eztdL4MssM6kKxnStf4beduKvVWPaBlD63D97j93XKe6qC41kEaxeCgECE6HjEIpLtQMrkfNcZe/mIFGWVBBvng8htuPNqvLWrkBoKHnJvnqXnLTzy1ge5Dq/uK7wYvtE33teVAp2W6+Syqc1exnfBUG4TaliGNgu+DOfP9oMLNkyXpzAMVHrRHunFkDHGYSaLfsMgjSc38LXMuIVKjC0MSicE+LHmRK6vJVIU5yPIDl5QzXUR0tIpggiGvTKPZUX2o6YEzmjurrLU3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a test that triggers stack writes across recursive calls,verifying
detection at specific recursion depths.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index b10465381089..6a75cd3e313d 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -147,6 +147,27 @@ static void silent_corruption_test(void)
 		silent_corruption_victim(i);
 }
 
+/*
+ * Test Case 3: Recursive Call Corruption
+ * Test corruption detection at specified recursion depth
+ */
+static void recursive_corruption_test(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("recursive call at depth %d\n", depth);
+	pr_info("buffer 0x%lx\n", (unsigned long)buffer);
+	if (depth <= MAX_DEPTH)
+		recursive_corruption_test(depth + 1);
+
+	buffer[0] = depth;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("returning from depth %d\n", depth);
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -178,6 +199,11 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("triggering silent corruption test\n");
 			silent_corruption_test();
 			break;
+		case 3:
+			pr_info("triggering recursive corruption test\n");
+			/* depth start with 0 */
+			recursive_corruption_test(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -199,7 +225,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"Usage:\n"
 		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
 		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n"
-		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n";
+		"  echo 'test2' > /proc/kstackwatch_test  - Silent corruption test\n"
+		"  echo 'test3' > /proc/kstackwatch_test  - Recursive corruption test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


