Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DC03CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 16:38:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A867B8E0050; Mon, 10 Nov 2025 11:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C7628E0003; Mon, 10 Nov 2025 11:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887AC8E0050; Mon, 10 Nov 2025 11:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68A558E0003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 11:38:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 35F40B68D5
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:28 +0000 (UTC)
X-FDA: 84095255496.07.17813C8
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5705F40008
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 16:38:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A6VQS424;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762792706; a=rsa-sha256;
	cv=none;
	b=eTvmXixzuYgJVaZ9qHqFTI3eRfrM/gn0/O/tjqy1n4SJomG2O6/oFtuboa8vKvyt0p4Ogb
	08blwrlLWTRoDG3Nig/2+kXqYH+ak/fLpEcJXZTap+SNZ5Fn/guTYSYrjcq4k0AuDkmMbG
	oMORO2mK8X2h5bX8yxBQ+RW5KwMS2SU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=A6VQS424;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762792706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV6BMzpvIqPwW8tqyoqDeqegoFqswySAQs38qdvsWjQ=;
	b=eu6/rQr8mKnU+ei3sx+Hyb4Su2iTC9fFEIMxbzpQ8Yu6dCkOoOhBwg5+Ss7Fxcq3CIEp5x
	INXclkS8vxsTCZcxpwG5PQORBip+Y2ItwUyKzUi+2Rf24av78Fu62tS/akprYy2twuS8LH
	1CtynpHTd3QjRIaVekBOw4eJZTSTb50=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7aa9be9f03aso2825693b3a.2
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:38:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762792705; x=1763397505; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OV6BMzpvIqPwW8tqyoqDeqegoFqswySAQs38qdvsWjQ=;
        b=A6VQS424itVEP3H38oM/SVLWlcHEB6jWm29TUC8OOA9WWgoDCG5+7DgtZ6cYhQQxV1
         SAbprhDzoubLHpimYAMle3H1oYN7Ridw+MgH71pWBJj7KM/WNlBOYHecWZ4tiIE5zbYK
         zMAdzdxKXb7ao6I4PdpCEPW4O14qgdqoABY1CrcrfRA7rKNaltG+CC+kX1ycVwd1AXc7
         pHkl9DIR3DTRzRQHbGEeojcZfeQ/qkAQXw+ZEqrdLRvtqOUPfmzE0ON6yLf2meXMB6kV
         5xeMI4flpRMsZWmotx4m2ti5TspEvhVBIkG+boZpet+BiScYywAPBheSpVv7jcXBX4Er
         1gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762792705; x=1763397505;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OV6BMzpvIqPwW8tqyoqDeqegoFqswySAQs38qdvsWjQ=;
        b=flroJcRxPb6N8/LuUxyaHIuYx1eXzmu77GIjDx6VSvH04ORAZkqaZBdLrNJS57gJas
         oSUaTeB3nzes9ZFmNdj38wuTAFygP39Uw8QmLSXr9ObbzEDthELUxTHmlOyUELxyHOc6
         ox7w5RNjJq+DBdYC4mjjb3iM+40AOpHnir3Gj3bqgNzVdgMtE09M+kegDaSHXBGTPZkS
         4O8yBRz6jpXR6lcF/cNiKDbDDkaDmS2jrJa5GY8QoMTGelCkWMtLu4LtB9/ixhqLk93u
         ejSqtsuSCvnRW/meDhGVAOFcPMjORURm5Vu5UguS9YNwdiyX+a5QA8QVoUAeYYARb5y3
         bS+w==
X-Forwarded-Encrypted: i=1; AJvYcCUs5pNThMIKTcb8iZUfF8uEbz0yigU07K4JEq8vcVlbtqumg0/eO9U0RbghhDLVLCAAuFecII6UxA==@kvack.org
X-Gm-Message-State: AOJu0YwoTPjhNhURxCnA2sX0a3MuchZz9w2R4OnK/ZoL7X0/uFl1KwIs
	QD2a/QmfwEfbw8L7pi3rdC0+IiS/Ki3zWctpYKH4A+cwOeNt4L+u2U16
X-Gm-Gg: ASbGnctSQ32PsuelAa/r8QR/QXJFCWfaemxJBrd0qvdrhYH+eZU9Slc0wWFZmaaAStX
	Iz0oZtzRR2b3z1vOOdmUSDsVK94pf+h2/0y/Dg6nwVdrF2rnrtnpTdLZCX9IIGVbenUG7NlOMP3
	jc8YPXvZ/trhIFr+UAaGTzWmVpN51lQMW9LB5TlToh46bYkNfkrjtd6CATwOoxH2Unjvckb/FaL
	7FGG3i08aRRZT7DjWOkX7NNvrwsvcRetXrMUlfsqTiNXpeZaRpOPuxEfhtYu2C3GHmMa+GJqRAm
	OWNA0VUeLoc3YcNBIjPb2TaHvekaNTno+QvmZwflvLr+8se2yK8qjXFM4gdTL0oo6lGp+dt84At
	A8Wev0+TpbYs6NRri/9Jo4hU3wTN1vi5cksoeREV59KvmxAJTyE0dkIDXmw9gA1GJsabh8PZdKG
	oUzqay6TtkgH4GHlC4Z1ZBmw==
X-Google-Smtp-Source: AGHT+IFPqCK5s7mZ0bMPwZdYahUYIC+qd++YwSpdh6nmmJ2pTVRZoEYmMMiGsvaFI6blh1/WMmJ4hA==
X-Received: by 2002:a05:6a00:883:b0:772:4319:e7ed with SMTP id d2e1a72fcca58-7b2277caeecmr11401444b3a.29.1762792705147;
        Mon, 10 Nov 2025 08:38:25 -0800 (PST)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b0ccb5a31esm12324547b3a.63.2025.11.10.08.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 08:38:24 -0800 (PST)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Ben Segall <bsegall@google.com>,
	Bill Wendling <morbo@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	David Kaplan <david.kaplan@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Jinchao Wang <wangjinchao600@gmail.com>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juri Lelli <juri.lelli@redhat.com>,
	Justin Stitt <justinstitt@google.com>,
	kasan-dev@googlegroups.com,
	Kees Cook <kees@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Liang Kan" <kan.liang@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	linux-arm-kernel@lists.infradead.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nam Cao <namcao@linutronix.de>,
	Namhyung Kim <namhyung@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Naveen N Rao <naveen@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Rong Xu <xur@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	workflows@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH v8 23/27] mm/ksw: add recursive depth test
Date: Tue, 11 Nov 2025 00:36:18 +0800
Message-ID: <20251110163634.3686676-24-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251110163634.3686676-1-wangjinchao600@gmail.com>
References: <20251110163634.3686676-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5705F40008
X-Stat-Signature: re7a8uqfd6k6yuagd5sdkdhbxfhrb3ez
X-HE-Tag: 1762792706-972152
X-HE-Meta: U2FsdGVkX1/FhsFRWIhUX0nlokXZ639abSqjF1WzUFaZdGarZVNPQGePRqXlOWxVgv6RwRFR1PAjV8NgPvbESFV1LvsDIxzlGzfzW3RmaGzQbfj+zhybJpdZzGNNeYButy5sKv2Q+E1fSG2MOWgQg9QJNWsj/1sSl1pE2istZo7q6IDpIZTuxbr6cWBbf4mTflTxXKj7x90Ejbnis1U4T3IR69RsgtoE2XrczjMN5pHSeklKO8bLiUkj3DOZvXQfbDn50JSZIQ5tSFzeuhz3KUBXp2I/2fYi6/aW+LpY9bVj5Wf3iO4B3d1G/UBA4iLzCbUqxESsenI5r4CS3PzixSNrnxI8a7NqZZKmm2ttyBAv6mmbUJGrOFJjFxdMBlkSA56tOtHMKNk3nZDIYuaNW63KsXXK1RZAlnj5MqWz4Cu0ZwBM2xUVRPnsrLR64J9K0DygCAsvZWnox3YSpK8yJoFY75LMsqI2kxXcTbrxLfmN2l2ft8N+k3CpUtMwZPaU6BGhNZ2D+lgFIqUCEwhgInwTVY19y8O9IL3ejYQj86nO2VYmVoc29bBbpEOxuMDcqebT49YnAMVNNVVR3lkYMfTYJmdUQU7kKao9tgQ1QN++y/PAc/fmEom67H5/xTksth1J4yBcIUp6o4vmoBgjD4yol6cKHkL0q3p0niPfZOeLTa95jx5zC4R8K08KenIdIJx/KoGUDBPcSdwu4l/Q4Tmq3fydfbgs9tFsnk06G7woatOhM3G6UkPKSpP5b/RwwwMNtR9MMH0GP7V2+puQtITWBXpUD3wACdsCAqFsExO8bPK/xHwd0aGkVHdMFmDNStnFBBpKkIKBmFqtcSgY51cv8ghhCmCWWI0cybmg3k7vB/TyL0XDX3ZGb39ryor6ln47bE9A+se349lsST4pKjHFAkBBrHxM0EbjWD1+YHhtYZGYkOTtl7Rw9kdKecwRMGEB7KjT7CTzk313fQD
 93UI2VVY
 3d+mx+aWJptUrtF1y9BelIuzPU0jpnc5izqBau8U7xO3G3h2QTG/ndqyMMZoVIKMKNTxUNhFDpvKR7fbFB4WMpNHkuJ395xqn+2XVleHw7JmPYzzrLZ7cbH+YbNS8ogtZkbfATvZ6vclVj7aFfYR00QjmtMIhegwikM2YiKum4xESW5SC7WvKXwBiNJb8oclQxkm5k8P2Jzbh5grI3Q+juZZ1rTa0/8pYq8LPJQYGsUclo7pvIbFpvSk4nlAzJthper6cO4DZpGLEQAmiMPdMLVPEYDoCPdgXVqyp6TxBlWRO9CBs0aNM79LSkRaG2V6nthQA4NHRdaKv4W2GT5botMlOEzQzBgsIYVBr250aCg4dtsyXzWz/bug7tGk7Xh2JxPWq02xYrc/HdbmMXcBbsjfi/avbJUVkR4i8DHJApmIMq7sIeRlApc567GyaC8iWp7ZT/8NNMGgWV+TVuaJosSzdIwQlQTH6BG5QHVMN4Wb5aUqs/R3a8MBR0atXqDOIIgOK00rrbmwFoSrTYbYB93mQFzOh4Nb1QGDqDmH++oQcG3Og+DkFoTtM9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a test that performs stack writes in recursive calls to exercise
stack watch at a specific recursion depth.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index b3f363d9e1e8..1d196f72faba 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -17,6 +17,7 @@
 static struct dentry *test_file;
 
 #define BUFFER_SIZE 32
+#define MAX_DEPTH 6
 
 static void test_watch_fire(void)
 {
@@ -48,6 +49,21 @@ static void test_canary_overflow(void)
 	pr_info("exit of %s\n", __func__);
 }
 
+static void test_recursive_depth(int depth)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("entry of %s depth:%d\n", __func__, depth);
+
+	if (depth < MAX_DEPTH)
+		test_recursive_depth(depth + 1);
+
+	buffer[0] = depth;
+	barrier_data(buffer);
+
+	pr_info("exit of %s depth:%d\n", __func__, depth);
+}
+
 static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *pos)
 {
@@ -73,6 +89,9 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 1:
 			test_canary_overflow();
 			break;
+		case 2:
+			test_recursive_depth(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -94,7 +113,8 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
 		"Usage:\n"
 		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
 		" test0 - test watch fire\n"
-		" test1 - test canary overflow\n";
+		" test1 - test canary overflow\n"
+		" test2 - test recursive func\n";
 
 	return simple_read_from_buffer(buffer, count, ppos, usage,
 				       strlen(usage));
-- 
2.43.0


