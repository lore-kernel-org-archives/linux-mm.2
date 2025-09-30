Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 732E3CAC5B0
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB2A38E0034; Mon, 29 Sep 2025 22:45:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C63D58E0002; Mon, 29 Sep 2025 22:45:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2B258E0034; Mon, 29 Sep 2025 22:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A13D48E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:45:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 686B11DFF5A
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:52 +0000 (UTC)
X-FDA: 83944376544.24.C6F260B
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8C7421C0004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:45:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WKglSTme;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200350; a=rsa-sha256;
	cv=none;
	b=PPLjDXNr5IBnNwIrBdstGWaZuSsKXyP4nuFDlWyHKnTGj6VOUnpXbaW8SkFyIteK0ismBY
	fZyjpfLjDQ8IBuXQ8fVLqnXgrAN/CiAuz+Q0Uc+xi1O1Gutshxah5lBIUToVZyDI9/n/07
	5+iWyqeq9hOt0rkfiH4ou7V3qKkK5sw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WKglSTme;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf20.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
	b=tKloRDtWeefQPGODF8hbmqfK9SSbH9tP+mCgivxZelHEY1teyYfWfZHnL+XzO8HtKf/9go
	rra+qSr/AeEESeQxuvKQyEtnDU7iyJgvdmhP8FdkAxXNxuPAh3P/jdNmnTSj+ioy9u/Ltc
	Z19uIEdsxW7RBHhhci61Iesxdb1MaZM=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b5516ee0b0bso3856154a12.1
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 19:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759200349; x=1759805149; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
        b=WKglSTme+pZEX9Om+CbGwspsqujNWzhilRsAXG1OmDRDemTjN4YrhuLJtjMCRJsOvR
         csAVOMWsLzNmrVkQRMS8ZjAEcFPbiPnCSKfrSwogP84or/LKFe+uhBtpiWlHduyJk6kt
         cUo4xI7g+4wz4O/IjwTtRxk4obu3Y0WPmjh2dyRGBP65oBqR3yaVZwccEX0xk6XVvwQs
         291lhZ17YqvxO41tyR3VA+vmj9rlRTbt6h9jqK3g4WzQ35jygXP0WCyxx8BkU7a5lKPj
         N7smhYr+GpN0ZSvNyGOrUG6yXtSkcifY8mVvTllI47S3OFCEDTRdbDzKPYZCu23tIhNj
         mMnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759200349; x=1759805149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
        b=r9Dg40qFPkkSC7ihQcBkA8JgqwftZNCYXyDNLeSDiQUB0zLCTyjXuGXhYkQlEXpZ/G
         0xsL+xAbIbS/Fkc1grCuoOKC1zWthR7NbKyMfJ/BlThxxfXDTnZXvz7CDYQgIsue/qge
         dqUb6KIWwGxIowHIzHZ/qvwwxd4sFhRJ8ZvJanvMLYu6owWXpqicz/mgv0hXyrhNpqnm
         BayZI7tOR/ewzy1ZqafvyZdsDufwguZd2GDi7Rv33euo550PJEaRYKV3lyqzUrqDz6Wx
         lRsSDaqF79zBIUDbvOTRpCByL4NUNOEs6TJXhkiPtitfVuocjuB+KlegNX4olWaGemi5
         6S0Q==
X-Forwarded-Encrypted: i=1; AJvYcCV1kXQBReEqC1LPpI89Q1wQUjnHoFm8iX40K2f4muixjLcEX1tTMI0BsTO0+eFcXTPKZZMt79shEw==@kvack.org
X-Gm-Message-State: AOJu0YzVNtbATERXnymSAgvyL8TXGhGFHIHiqT4LZB2zGI1EP/8X9uba
	WKoN5HjAIZpZQTS6KxcZSY1mUP3D4sC4ZIG2qVEDwFWOc/jfM7Gl9Z1R
X-Gm-Gg: ASbGncs35Syq2U3wE8Q2F1m0WpdRKJuujf2vzUlmbRKuLIWdSTb5SGIR+QDbMWsFDtt
	mg7ObSmou0J/9Ousc4Ft180OKP0iR1zAsWrWotUMeH6cl85G2aiY4I+PkCi6yQa85mPbVr/Rgn+
	eOq+plI/zcgN9egcj1Zep5dl5Fn/SQoO4Ym80Wsg6bLlL3/v+aWcJ5Mw/xuIvprPKG1RxzCKTCE
	THnpbxXZTI5qDaND7ozfcQ8JvPh2DyiqwoTucqVDSdOeLcphKB3sEtCNMJPSaS3XtYg7RnWNfhW
	/gv3We/sND1ZrBGrvJlY+iFRQkw0XtT8OkpnRUxV14FpLUONNbUXP7oO8W74H8we0Ow2lla5L/A
	olHxOkqFAzhdbxdGmn8o5L7cLasinVbzjkaUma/IkG4olDMaGv5rIylXgwN9miwrv67/2ytO3hQ
	Tl
X-Google-Smtp-Source: AGHT+IEG0ThZV7fyWTs1y7QMeQlbcUpJL85C4JXPKzErGd8yhJciSmW04rCMUIpToCmcRIvMPIF8Hg==
X-Received: by 2002:a17:903:2352:b0:249:44b5:d5b6 with SMTP id d9443c01a7336-27ed4a920b9mr200539425ad.40.1759200349322;
        Mon, 29 Sep 2025 19:45:49 -0700 (PDT)
Received: from localhost ([45.142.167.196])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6886c9csm145811695ad.88.2025.09.29.19.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Sep 2025 19:45:48 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Marco Elver <elver@google.com>,
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
Subject: [PATCH v6 18/23] mm/ksw: add stack overflow test
Date: Tue, 30 Sep 2025 10:43:39 +0800
Message-ID: <20250930024402.1043776-19-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250930024402.1043776-1-wangjinchao600@gmail.com>
References: <20250930024402.1043776-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C7421C0004
X-Stat-Signature: sege4r4o8ibsjb9xobhjw1asatsbximo
X-Rspam-User: 
X-HE-Tag: 1759200350-586896
X-HE-Meta: U2FsdGVkX1/HwHcIq5AfwhiquRUxt1lmSQq8VyzFs2dvvs7o1zi5vEdEjZ5uvRtQNdxD9d8dn/EPf7bjbGv9/FIupSuYAwoX+qTlfN8YIXyyTR0lYbCkS0Cf+6pnSo+ED0dRIx2093wLKUMiVI5yulmecZn/LAaYplRSEuiEYjTTYYlpjPeSUA0WEt7LhOM4vypnCi+71VaszQBqXpsI8fTTst6C4zNzxdq3/sVAul5X3r+vBD7wAgJHHsO1BXpnMR1TVQiezkIPxzBjTCnP3dieZ6/GeTVLKd09S+GpwtH+dvjYWVRcDZIv8hZEy9HkQgtKXPrub25Bt8qU+n7P46BDtx0mBOXGI3jmuupsd+R9ZpHCS6feHoCOROxY+vTAIKLJXdo7JsQRcOqVHvcTmo+1FJvGzW3Cr99gEfR8XIPAShFWns5g4zaa2x6iTrH/6fc+LQyKtJPYc9BFnMbLq3bYy31SRmg434Jc6Vacp+c6X5pB48ROfSiE8D8emGnIsTVCNX2U+LgWegZVsb15yf0Q0hWoIBqa0QSYImq5nrNgLzFhbS8eBllM2tw0YV/twDylU7D/0SPdluc6t+l09ly6lepqMM4icdEWymIPpF/FHP0681cfe8SL4IYU40GWi4I9bkVkGn/3exVSWUoxAFx8UGxrIqy/qrTWt4mSkblQG8hC+uMvv6CYAMS+mf/CdLnrUsWJ4MRUrC87iHhfQ1KSSg6r776CXmZznJH1k1XYJgKFB3MqTYFNShh2BVNREXo3d6c+sejJYXYuLZZFKChHYRX91CpWbfl76JcXkaNIj0/F3+pEIO5ljPzKvLdPW/KoUzcTw/mJX8fCCVKO2CvjsveLxDbDwKVRkDEhddMLJsdHPIwe5TmnaCWqRdUvhgkZ6sb8ADMjZrBp5FxIcJtQhy1eCasrFbBDvTrKmTH1HgM1IFfZLROI9evK4fURN5tjdzpYEUR+i8WD2iw
 kWyXxEbv
 CX8SaR18dAzrRRFcbgzyKO2SEo6FClj7OolG0Eps6dMIk0ATU+dPulsKupF5OZabaWC/jhEowDj6Esz6CaaoYytbnojq5Vj/CxBTc8uVlVmqLD7xM1RhhkhAUPXNWVz/+naXsM6WEWlXQClsLCU45q+HjR2HxoS3DKGsahM3Jl/ilmYs2C97Dvk/AMj0hbcq4spmUlf1G4J4H1Hli3QzLwYjPWLyUt7BnYW8F8UQOXYaR5jnhJuh2oNqteZnQ8qhCVO/H+M513FgVJfY5rFZL1jZlCTbPFoWcV2w6+NeA2G+wutPsu8mQTQ3WBeXj4VpS9F/cgRXwJOA0H4NomV6p+3spDAlSevZGuFn/wXRGL51kQUwpNLqBXjFrwnkj/xZrurGCA2WAH8N74t+TMs4QBLuSyoqERiXgGiCbVQm8bIMgeJjQTjWwX3UAtvi5amMfoeHPAP371TFL39ntyRsgJ5ibHDkNx81Qv/O5Ytl/G5xwOZs3yzR8n3Ey6Fg29fMkQudGVyrQDOgKVLEtiWtkmmM2W+P1KTi3l+ZmR0CHpn6jq0I0IO+LIHgzrQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the test module with a new test case (test1) that intentionally
overflows a local u64 buffer to corrupt the stack canary.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/test.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 80fec9cf3243..012692c97a50 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -32,6 +32,20 @@ static void test_watch_fire(void)
 	pr_info("exit of %s\n", __func__);
 }
 
+static void test_canary_overflow(void)
+{
+	u64 buffer[BUFFER_SIZE];
+
+	pr_info("entry of %s\n", __func__);
+
+	/* intentionally overflow */
+	for (int i = BUFFER_SIZE; i < BUFFER_SIZE + 10; i++)
+		buffer[i] = 0xdeadbeefdeadbeef;
+	barrier_data(buffer);
+
+	pr_info("exit of %s\n", __func__);
+}
+
 static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 				size_t count, loff_t *pos)
 {
@@ -54,6 +68,9 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 0:
 			test_watch_fire();
 			break;
+		case 1:
+			test_canary_overflow();
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -74,7 +91,8 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
 		"============ usage ===============\n"
 		"Usage:\n"
 		"echo test{i} > /sys/kernel/debug/kstackwatch/test\n"
-		" test0 - test watch fire\n";
+		" test0 - test watch fire\n"
+		" test1 - test canary overflow\n";
 
 	return simple_read_from_buffer(buffer, count, ppos, usage,
 				       strlen(usage));
-- 
2.43.0


