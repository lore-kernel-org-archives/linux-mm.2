Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968DACCD18A
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4168E008A; Thu,  9 Oct 2025 06:58:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74978E0002; Thu,  9 Oct 2025 06:58:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B5E8E008A; Thu,  9 Oct 2025 06:58:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFD1D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 860E213BD10
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:25 +0000 (UTC)
X-FDA: 83978276970.26.74D789C
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf16.hostedemail.com (Postfix) with ESMTP id B21C9180005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jxSjKMDx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007503; a=rsa-sha256;
	cv=none;
	b=BmAPa34kN/AMgKlOOJXF8pK3gLM1lYUFYCZ2V2PGjf+viHUvBWdr/UL71MEu2HT+9wMjXp
	LsoLPxc5VsnHMB9HqAhSEK9RZAr3SXm7p+gmZnA+z/rZzWkLmPH4nLO+gl0RouLGmWK9jo
	OFxM4tKAYNYKafGb/aGqqoHOK0eMbdM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jxSjKMDx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
	b=uKEZW3DxkuQWotBaaBYD2SUPQ4ycV+T/A27vnzB/6IajCb23m6nWiPuwDanP0Q4/+dKWLe
	vD9Qn9Ijf5rsq5tEjKRUkryDGBvBwb74sFiWpFMLVhTjjxa8pxAeqoDxmtw1UKOzNy7txV
	HcHmVvqIslnqfQFTKZiG//8MIDW7SqM=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7800ff158d5so771247b3a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007502; x=1760612302; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
        b=jxSjKMDxr8THga2354YAP1i87qVd+r91jGVMSil1YTVg4sOY4tTA8w4srZK+lw/Xtj
         wyXsBGwPi0CkqIPwGmm59boK1IZ1hIR4EbCK4hNPnLZ+srOXCf7DRvixy8Dwkm3CHWZY
         tnua+GwbqMavA92JK9ngDxJmV5JXL0JmR8SAQ/8uZqGpCbOldLUoL9oDhpbo8C+bJI7K
         B3Xa7sYFCJLDfmAb1mg3G7XvRYN7g/JEMd0n43DQ8c2p8CVHIDggBg61gxjGkROkXiK7
         4U0nBb8HMbzcTfO6iK2ngdGZZGFN5HJYbGYlil15cwKShUPWmG1Tx0qo/MP5MyrQP1Gb
         ce4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007502; x=1760612302;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ANupiyfNlS++I01zMHP5Qbsc6Wgfn8wZLgNnwRsiWjA=;
        b=bWrNybFNEIpNhsgj5LXh3xRYrgAIn1534CWUE9+kW/qAjMblbQCCO4azSdkLp45RDg
         dKkgILAr11PjlaYSdDRsjNZ33EbOQByjgx3+d35EcqAqd6qmM4/bscTyXzhVYcxSkl5h
         kNujCFjRiqzxS6mVeee0t12XP6INbqn/5iGnI1g6/hzRdbLPYfQtUmPKIzWTqje+tImH
         oCXneSz5lLCdc7LOU7dIzJyPQWH+5BcQdWJjW4tYtJz2+2kq17agI/uF+AmdYkZnHMNQ
         tNj5Pn90JmzybZ6vOjCrJHSmFKln+SP54csVGc5+yrOCSlRo/xMGUbxuNeOEtoJBQBOa
         oZ3g==
X-Forwarded-Encrypted: i=1; AJvYcCXJDjp8ZTDjoYJ7vqNQWuxrCW9t0+lA/tXlemH3He/51j34nm89Z+p1tEnNloAc2+I02MKroBrWqA==@kvack.org
X-Gm-Message-State: AOJu0Ywtru8iPxvzDFWxHRWq1pr7akq5tZvb6ZIHY12ZLZ8pAXCLDvmj
	VKPR3YeqLH+6A/3eJxrlhSku98SAMFHkAHjTdaYmU5+kCs5qt3FIATCm
X-Gm-Gg: ASbGnculcYlxXe3SQNVbzfuhOcYxPY6jdRxYnZSpb7i2zkgNTF5NLe96Mv553BfZqHb
	7lFJb3IE79Tzd1/RYFVrtpBVIWW6O6W8PRH7qzQdxmsOSo/5wrb9ccm2ETyY2SpjLW+KQ0w1K8o
	q19yzuD5pBKUyN5rSY63utyl++gs7ixEBzu2reLkyeqTbxG2sK1b1EXKAZ7LjORGwIzP6Ov7uBc
	kpflIwp2ibzIMbhokituftafX8+EM4e1pXs7/L1U7sSPN6tALjhHkpXTXgVZpLwdMeubkIerZII
	N5J6yzQ9iAi7eki7MDevRsiqP356wTUxZoKT6wcKph0bSD7XzyAQ5A0NeL2QF/d0K1TJGr4CUId
	RYFmebr2evLRwpbGT++3iOc6OHqN2u0ReFIl/F/qDXuIu7vhfMonIWOAb9AF77Q73LeJzxMY=
X-Google-Smtp-Source: AGHT+IGL1hfkw824Dhg5abUxp0YVqhv+dnuC2o95edaELXUy1UgmRHSa3+FhXmUlSur2PmpUVijsqA==
X-Received: by 2002:a05:6a00:2d96:b0:77f:1d7a:b97f with SMTP id d2e1a72fcca58-7938782ac68mr8582957b3a.28.1760007502437;
        Thu, 09 Oct 2025 03:58:22 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-794e33f0cb3sm2487606b3a.78.2025.10.09.03.58.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:21 -0700 (PDT)
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
Subject: [PATCH v7 19/23] mm/ksw: add recursive depth test
Date: Thu,  9 Oct 2025 18:55:55 +0800
Message-ID: <20251009105650.168917-20-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5jjg31porq7sjkzkua76dgw1nkrn6o7n
X-Rspamd-Queue-Id: B21C9180005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760007503-376898
X-HE-Meta: U2FsdGVkX1/1FJAbZNUWlGpMoQqQzRguFysEZyz3mFW2TH9d3fNykA3nDkd5vqyF39xyMfILs1kcYXZ8w0GxIeG2fFaXYkcLhsPhjHnWy+KVddUGcucw4Elk5dCKajqIys2hiA+Ne4V3tbsH6ZzmdK///5Phg9X/m3Ax2rX7Swby9TTRvO6DZH6gZCGJMzASTDoJ8ZtxVlPTvCJDi/xQScOauae2MpaDuLRS/4KM77Epf8wM1iI+Y8tu9s6K664HaEPxiwBMKHnU0kH8OF38Bj7YtwFVOvCPwlKItx80yrTajIDYcgWlOGxIQ/CfHd9UqGItbExmY4+tEp/VuddAUP1NbIoGHcjdQYaRJApWHeIYmwW7fjRBJbfGI9Ftfnfnz9gUvrFtM8qkedASrH2Fp04MqcEbNZqnJOyIMaP3EUzBcdTlDFRMOly/wWRZm7vw4PHUVIZA1/+IfQIQyZgfgv3uohWJqy726088J9Pq8SpFWLWr9c3cQ3gf1bz0JSn+RKFFWxCFK9RALUOfXUjLeN73VIptObrhfwybRCvVgNpg97VWuzj+F8l9lqkJXekPm21k0keQfN7v//baEuFZDFTYPMXiWA4HnpcAGjAg9ut/kCZrN6zy4TSB1T448n/49TDJRSACzxHNHe/S8PjOb+yK/ATV05KSVBFWrvwN8PgWQCEDout59/57D+zgoE3RvaLIYxV/bsCYo+4UAUrrcHwrxb1+89gF4I85Iig29Ou/Sl8uCZqZiAtbTPxY+/ncqH8DUlIznRb1Sm6kFcgXeZxvBHgDCtHTuwjQWgrOvwoP5xI3YooSatCdMLUKYCgAGwvBdc1Ea9ZJo81dO8eJt/FUjPPJMvB+EhXP2TihLIFLIDcQxZT2Esu8JL0+gKiIDt3WRXbSYO80zDPBfZ86U3FSgj8niNaeKaVxcPf2vw3vQrk1NH+wV97oSQy8x6unpK5cTFfWGiqytSVZ1wa
 JcaTHYbq
 kLj2FL66PcgkRxdgl6gmviaQxJ+8VZnOsbKmN4WSHzveqZvr9mMARlKC+qn7wjWAh7wglwSp/Mx4YotKqjBbzjtnb5P6xSBtNJcSL24u3BZFGmXRjNS70E5mvNr1WG45ynPea0Jq2UTJIfQ9fsUqULFlgrTxbyxbu3uIsryKJR78BGxQh1UBIYPS4/oqI5n1psASl3tWm3ngDWMo6QJQvCRa+8ccgfvYbgz71GfozZJdS98WIxh2FRpsUIbcbwETc63auJPkv5MSsw/Y9ZjVQtEZVtvk8Hx6QhgBUUnupK0oo88SO6SY1TxGmKx/AgGNNrPhvRyz2CTmXXP93Vs9LdWnxMa/n+WymnQdbOVVgMWnm5NerwJ6NF4ZQElbTQvvBhDPWEK0GTqDDYxJgINgPOold+3IKLV9VayMliIgY9rPs9e09gKnqPJSXRkPi4VJQGXdtucdokqbxN3L75u7hDJqfLJ+diWvpGhaVWsUDOrIYpXhy8DhFnthD8A2GNCgSO4dZ85pvBgjZTOVPG9Z5HdtV5fVZAkV3eVcozG0l1vXJnutYC7cAf9KO9w==
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
index 012692c97a50..203fff4bec92 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -18,6 +18,7 @@
 static struct dentry *test_file;
 
 #define BUFFER_SIZE 32
+#define MAX_DEPTH 6
 
 static void test_watch_fire(void)
 {
@@ -46,6 +47,21 @@ static void test_canary_overflow(void)
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
@@ -71,6 +87,9 @@ static ssize_t test_dbgfs_write(struct file *file, const char __user *buffer,
 		case 1:
 			test_canary_overflow();
 			break;
+		case 2:
+			test_recursive_depth(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -92,7 +111,8 @@ static ssize_t test_dbgfs_read(struct file *file, char __user *buffer,
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


