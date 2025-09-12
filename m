Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 481A6CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A036B6B002A; Fri, 12 Sep 2025 06:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3B46B00A4; Fri, 12 Sep 2025 06:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8546A8E0005; Fri, 12 Sep 2025 06:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF656B002A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 30F8D5AE84
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:21 +0000 (UTC)
X-FDA: 83880185802.20.94C9B40
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4471C4000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q8cAqF7y;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
	b=pstouoSTwmSY3SBYMe1CNoM4q/UBMNfeekg10/WKO1E/badDV9162zfEFSnCc52x7kk89G
	rPcTsMPVuPDEinkz2XBFBB/qOKqkUaylXqUSlR01pvOKe0qnz3ckUCblRkNQdoywVfAxYN
	JaJWnS49eZ57c3l2HUfm2Bib7ze+qAw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671999; a=rsa-sha256;
	cv=none;
	b=Ze2V3jgsLlmgFdnCzxX5xLXBBCbbtG0Ka++yffAUPBhQMhU3zOUMv336/K5IlSQvN2Eudx
	5Xwsl3t9+3bSpxxHrIGLpOcqnLYAIf+tTdF5gMQmnx8ftZM7oTaSKYXn+qn/RtXBV+9oOA
	91YCEN1/J5pROZNW7LaOupitSF0mHhM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Q8cAqF7y;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-77264a94031so1348914b3a.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671998; x=1758276798; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
        b=Q8cAqF7yCkJ1QeFT8ryYtukcr8X7HqxAk8Qf+yuVnWmHMIkCRK7QXJ1Vr4uuBzJD4D
         aL9DLvn2GzD3o85dg7vYYH7QvfnQrUjyuPj5OXopvAzBuhtEzFofGtp+l0LbT0aLTiGA
         XVIQDdkG9hHzcSGqY1PsmZ3Y7z6e2GLNP+OYrtPRV3phMwIIKDju7sOjs+c/hCsH8Ha6
         6rYheWpD9RIsAoDKP6Jsa888V507QDHU7Qliq20tZq6ObR7KzXADUFxroD4b1gyJI/W2
         K7D3t4HWvZlNHjNk5nQI+uJEr0jTNvaWhBy+GjZOR6rrIDd6tyazUJc9kOg2IGJca1DH
         IckQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671998; x=1758276798;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C6BBsZfnmfgl1Jgn+pU00vd6g5c1DTmTteWqGp/Sk64=;
        b=MRo/wxzUQXF6/Lyi6eXpl+NcmZ3CNcfiDAzymuKjkY0KH4AdgTLwJaMslNaiyoFG5Y
         sWS66mJ/fkFcQxvida1xIN30buQpuOk7GF+eMA9t+l27x3XcVSxtNype/WoyzJmC2c4t
         l3MFrViokuN2Qp3KUIrNvWDrj4wH8X+24tBx12wsrBm5J//9lELmpXVcFtECQXr36oes
         kgX5iS9ApanYSt4T+cGLa+u8dcvWDHaPzB+838HD5u+O3nC3traBDu6zYZrSgk8Gr4C6
         +UzQjzfLXGlBQp/NefDgS7wTdp8nVW3zNBwR9ZIbidTNhVBpkqvWsiDZY4YTEIXCBMVf
         laDg==
X-Forwarded-Encrypted: i=1; AJvYcCVtpcZ4b1jjWZ5lSAlmVWJxbBFbz2XMUeGbmlG8doGPp55c2xITXRzmHCo6dVtH1RJTcOjp3TBZ1Q==@kvack.org
X-Gm-Message-State: AOJu0YxeXg29asDS8b4POC+6+t0kwv5xSRyFyE+frQIH8cIifsSY+niY
	WOq52MJqCuWu4gSQec/ynMgWGoeCr2yOWycjAbjtYUM7Fq5ryNQkwxR9
X-Gm-Gg: ASbGncsT/fd0RlRelUq5yiWUsoj7JHT86i0JLVypDYbF8typgxC1RGbTavmIO//thjH
	sm5/SbeTLizPfLyY7x8ifBzcMejWo9upJlDSCuimnSlPrsS2JztJhU7fXh9CACKBkwrqUW6rpUT
	VlEqcD9RkRCo5LoTyqlh2/gwdzRa2o9ecc0CknxeiVA9nls2XEtRn1kad1JoaVv/Vf37HDHvfB4
	8jKmFWA3T4l36PshD0mXgQs3EeabaW4m9Pkxoxh8IXm/ETmympyC87K2LKdb5lH+fO2Fh5c5uIB
	ImtNoDGfBaBJinGrqC9zQ1TRIjMo5DNe/bv8lgpq7c4qt5nNh0MoDBc5LQIUd620l3cHK7T7sZe
	5ncMPWp1dg9GEH9KgLur/1DdM13O2PqyUqzgz01/Yf6xXyg==
X-Google-Smtp-Source: AGHT+IFP0Z697TA4h3v44yo8u1mt3XK26j9kYKC9Oe9buFWhspRDiIMhNWMUBIxM8GwcPJ0/MCOUpw==
X-Received: by 2002:a05:6a21:33a6:b0:246:3a6:3e41 with SMTP id adf61e73a8af0-2602a5937a8mr3020791637.6.1757671998049;
        Fri, 12 Sep 2025 03:13:18 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd98b43a7sm5206301a91.13.2025.09.12.03.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:17 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
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
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <kees@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Rong Xu <xur@google.com>,
	Naveen N Rao <naveen@kernel.org>,
	David Kaplan <david.kaplan@amd.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Nam Cao <namcao@linutronix.de>,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	"David S. Miller" <davem@davemloft.net>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linux-trace-kernel@vger.kernel.org
Cc: Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v4 16/21] mm/ksw: add stack overflow test
Date: Fri, 12 Sep 2025 18:11:26 +0800
Message-ID: <20250912101145.465708-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4471C4000B
X-Stat-Signature: jk7u3r6x8sqaojcbcmn3yfifxx7h3qcs
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757671999-276305
X-HE-Meta: U2FsdGVkX1+yR8ZPKpHQniB2wwSxoluptJsvGEv8+yv6zvN3oRVMzbVMS0bsgXiDs3IqEkWgLC73Mak4DHs7GrgAIQf2Scp7IWOrbzvYaalk7xJYGgKR4gDTT9tA1EjLkoGPZ9hXBt4HdD2gfGFoDQjEOrm6xtLtAR/bHgcqZ/HQsvrg/ZsIceNOFBbySyLyat4Ja8pqqd9b//1H9N/700pQclnDxaECZLwjAi7VQGyvy+Qn0QITe22BFTaGi0RTF3ae6PTIv/yl88eirmxG2xZsOk0uqRkLu/OdvtpWyxz9tTO6x6QFB4OQn2qdE/t4qg8E7WFWP8YU6I1EMkqIe0tz8eUPo/wJiHPLvWZ4K2zjjQ1FEBszAZHjydGMyXBHHZTykbXdMU1rLO/xkxDYF8bnW+vvDaVU11k6oLqOaHwMOR363PaHmyGYb4ZDwMJX0TWqjiBvAKR/2MC9TkaMD/E1S3Q8hfgPGe7c/VVZFtrDdkjrt7kcKnz4l0uU3LhUjxNAH9cHQt/82WViaHM6vGb4kpHy4qdvc5KE8mulcHYaj0cG9Z1xFhZaZeyckMBCB0G27SF2vJxq+rTO2NEIXWlvni49kpZoimMr3ACVQDDP0coWPgROFZSvkxM0epIvN8I2PPgdywCQSHhKR2ImxT49nctayACGwifPYQ18xbQ2XXiI0bYbZ4SIixPydot1+QY8izn4YzFpY7rF47TSLY2uyRyb920c2prNPDfNhGMnUGbtYOyzCgJ5RUUBgp2jG7U2lpbdfA0a6fM9++Xr/k/HWZCybF6+pju9ve1LW9JX4IpoaxzGSQcVEHdyrFys59Je2Z18BpTHZMr0r4EBn8JPaLXN+HhvtMKfRCP0VuJKmT7SOjjF3wan37VtaEVbgV/j2cdHjFzocrZH2UM9pH9AAfyQMRUYulzy5BZwLErgsOjOl7Xna2E9Pi81iVY+GSOcoxQ8hGvB2Hgx1uu
 LIxV/rnQ
 H/tv9gAmsQubK5QKn++HSq2+/Q8+Ub7rl3Oy1SpjuDeVh3FGa5dJ0xw5pV8N1eXMxssOMfRZaBn7BBULF4ST9SR9eUFo7jPa1Xc9SF2AY8y8T6IbcF/QUG+Uarkt9YMyr+0RWLUXv0RZqdJ0RL5IiTRTH4nByTuOLvqjqVCWDNdqu+nTdLhCZ1hXbPNPwdC1XfrXQEf1HY+s2KGgVpooVkghu2VR9GH+QWjVVU+ovxns3ySoU3TqGcexbRXzUXH0fhzytRt+b1oMjRv7u2CiQIz4VyqcZZqZjbvZizOmVrrnJnM/0xnPPCNfzqwgPIPmi0+x8K2CBR8bCZ9q7ZOvERpS4wSQ1+QiVE03gYSMh/7zRjk8IzWIAA/wGMoczOJrTz61mMBoUW+gPPLz1e/KQwYluaLXueXkF03uDfJn3mzz7AXDCvN0V8hbTiwAPuK5KP3425qsrPm32lgIARClkhFHIAAOLjRzgLVAruRLZHFaP/c2Pyau9K/7P1Yu7oxL8joOyIwcRK2eZXGfmdESWVunbM2uqMhThERjle4FcKoX+2z/UDd0f30fO9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary. This helps
validate detection of stack corruption under overflow conditions.

The proc interface is updated to document the new test:

 - test1: stack canary overflow test

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 76dbfb042067..ab1a3f92b5e8 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -40,6 +40,27 @@ static void canary_test_write(void)
 	pr_info("canary write test completed\n");
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
+	pr_info("starting %s\n", __func__);
+	pr_info("buffer 0x%lx\n", (unsigned long)buffer);
+
+	/* intentionally overflow the u64 buffer. */
+	((u64 *)buffer + BUFFER_SIZE)[0] = 0xdeadbeefdeadbeef;
+
+	/* make sure the compiler do not drop assign action */
+	barrier_data(buffer);
+
+	pr_info("canary overflow test completed\n");
+}
+
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
 {
@@ -63,6 +84,10 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			pr_info("triggering canary write test\n");
 			canary_test_write();
 			break;
+		case 1:
+			pr_info("triggering canary overflow test\n");
+			canary_test_overflow();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -82,7 +107,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 		"KStackWatch Simplified Test Module\n"
 		"==================================\n"
 		"Usage:\n"
-		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n";
+		"  echo 'test0' > /proc/kstackwatch_test  - Canary write test\n"
+		"  echo 'test1' > /proc/kstackwatch_test  - Canary overflow test\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


