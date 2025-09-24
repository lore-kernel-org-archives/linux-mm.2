Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E09FFCAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E108E001D; Wed, 24 Sep 2025 08:00:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475E98E0001; Wed, 24 Sep 2025 08:00:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38BDC8E001D; Wed, 24 Sep 2025 08:00:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 24E358E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:37 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7971BBA4F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:36 +0000 (UTC)
X-FDA: 83924001672.12.ED03599
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id 98C664000B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:34 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jCcutSa9;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UG3CF7kwzv6QR3Bvbfu+t4H41didNmIt1FZDrUojazQ=;
	b=gWFSZVld+9bgqnkqW0djOQbbdN9uN8fFBol7V+I+pt8kiSkFwuBQDHx27DimMbqbwoP11B
	2i3i/9FyZxYRRtEl9h+H/p75XB3dZAHiBvnMuGjVkXGMDP35Gzr0K5uXFkP/MrkJAvZgVG
	Mf6gKuHru5b7lUxp1pQxOjycld2hmZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715234; a=rsa-sha256;
	cv=none;
	b=vOc1sHk+cGyK5OU/c5zGFXvmei7PFVKfBs3fvhQ7+yyA1VUnKDYNi0p7ZS1mDv46I3VDzd
	kEVhyXhRq9KrX7PzrI9uYvtQfCRuSYidOxYQ30FazOfVZXHHDXZGoc8rjcVbvOW5smBz3Y
	yXUbOxyP3D0xzMoHBYj2yLTh5bAVqiw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jCcutSa9;
	spf=pass (imf17.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-77f2c7ba550so3485903b3a.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715233; x=1759320033; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UG3CF7kwzv6QR3Bvbfu+t4H41didNmIt1FZDrUojazQ=;
        b=jCcutSa9FA2HWzrCQU4dZBamon5Y8V+rLL7wwUIl4u3LKPH7SXKSN4N69A5/vQO3eI
         xEzxAHoFRxejN7ZglWAP/h5bHeJMLlCmHvLpXzWyflqI8PvSzlnMpnXIf8ZPYW1E8zbv
         sko2s3gtXeuqWNRvXSiou0oF/C9oYcoIABQJXPBhUxLD4JGMT7ACAdqQk8IyuxhvZusH
         RbY1PKppa/j4Z+kz//NDF7tceIc9/JtNn1X8Nkied8KmYk+35MUeVvankEJFfppFI8zE
         NF4UAtr2hSNMXa3KdJ5J30uA9FF0cFZ4imIPFJarLa0G+8db4LQZ66D1+ixIZIAvxw90
         ht4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715233; x=1759320033;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UG3CF7kwzv6QR3Bvbfu+t4H41didNmIt1FZDrUojazQ=;
        b=uf2HEIr8Q6fPKV5LD6Jnr+/SASaOIRxfth+CirMbZRJEJddFHHueRtxe31GdJbIg9P
         Rp7HOZt+Z6vIltbPcIVlLx7Awhq9XoPk0RmJny3If41qYrDz1I99yE+yJDXtt/Fe2Uuz
         WZvyvN73sHKqa7sDlvGFQU5AGjtFA1MatMVsy1vvd6Di/44DmfaS2Pz++36otZCbwk+4
         Ik2wjHCWT6QxG07+93e6baDUROOg+S04d90vyqqPVbUoXGsZ9qQHJEKfjUe1ZDLtgWZ2
         BNrzUfn8IvlLb76+TwGFA1jodQr+Ifar29OOgCW1GkEWcllo7/34kyti296ZztZzLGs+
         66cA==
X-Forwarded-Encrypted: i=1; AJvYcCW3m5D+iArtl3SrQZEpFPXqAdU4bRCjq/4oz8Ncwuw6Gb7+y2s42gUUPqCo6eIBI8mgD3QiOmepbg==@kvack.org
X-Gm-Message-State: AOJu0Yz7vXj92FxvEMeFtZIM6xXWPcAdUJ42oc5a3GH6uMWK3yyXI41D
	OvBmm4MP+dBe7SJeTjSQd/svlDlDK3YGLSJJoz33uOuN/EJP/Z0HxI+T
X-Gm-Gg: ASbGncvE5ASDVu7LVV826aYo0Gbf0RpjU0BYlVucdiLmMxtHF0r63VmuACgPBQTu3PY
	e3QEa3xFN2HAuRVhqO8HRUvYorQMoQUqRzVcwREOWnu+Nni3EH/9Nt3CVc2poTwX420H8tOPjxC
	j03BwVCE4EUZ1H5VhO6GmgayTk+Ee6ECiIpB3uoiy+5PxTao2d64IqAZo76jgflSOu2TzxCkGTR
	qS1UR4ufcXo7sZFFPjpEmUUHqjejEJ+1IsXGzMd2xaDwW+M7/7vVJGPjqH5YtiO+MGxJbZzW2zo
	rgg5b6KIc5YAl3QSBpgC0vqg6gQOpH5JgsRjbXtzRrAV+aqdQN/pMwO1BvXKsfmXZOUk1WB8s+y
	jVw6kJGi8NkENZe6bRH+BKS0YOi6AFo2ZwA==
X-Google-Smtp-Source: AGHT+IF6XISRPA3i1YO2WYyo3MXp7Cd4Mk+kPP9SRfGztdCTTVjypRXE5hBz8PjgkCcvzgR6cUkWDg==
X-Received: by 2002:a17:902:f609:b0:26d:e984:8157 with SMTP id d9443c01a7336-27cc13808fcmr63875775ad.8.1758715233064;
        Wed, 24 Sep 2025 05:00:33 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802df57asm190476695ad.67.2025.09.24.05.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:32 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
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
Subject: [PATCH v5 19/23] mm/ksw: add recursive depth test
Date: Wed, 24 Sep 2025 19:59:25 +0800
Message-ID: <20250924115931.197077-4-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115931.197077-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
 <20250924115931.197077-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7odu6ackq6nieng6qra1a4p4mwfi3s5e
X-Rspamd-Queue-Id: 98C664000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758715234-630766
X-HE-Meta: U2FsdGVkX194uviPB4cKleGZJFeXwLhESc/ThJ2t8QhBJmorW8Wa/Fd9kCw0E6oMSKKNsO916dlvWCQwXp94ZSnPUGtjohqdeABzocnql8EPeIpMtibT3AtLMJEGJcl+Hpmo6v8ROIybnZi9jQxn45Aj4mtn3NPYcpMQMCvVw5UVqcDx4ssAkhDhGzkAHZKeRC3a71B+f3EpW+ZU1henoPMwpjmHH0F8u97A9KROsdMQ+RsHwph4NjOj6TNaNVr6XcSV3U/tqGb23NkPxOBuER18X9Tsrrkpn8jJXMc1rmhugNzLb3dWaMO2jOM11WGoaZOOpuOPnoQYxKydE6rDcJ46MCZAHeBLlp2vAYNB4ox7jFGUHYxXO2XhXTZxYum6YMsj/6ht8QOCofRzXC7nYtxneSFWL/XslRTuQmw/oruo9yZfctQAErqoNk2TN3cwvLntCiwUvvlQN1p0BbF1b9I27Q1xXVWYqBYAFEswmzqKCSCZ8QslMQxbQIFb8OyB1o9uRnw6OUVkeRifiGmAnwTtKXIzYvv25SxJGLafgsPU/xiGMbn45BJoUffyOxP8RgeF8K0sQhEUiMMHc8rJfls/xWsXwru/bDHoJ6r7TJiWi06J72F8W/z8fpntk3w9LvRg6R+FfI0AxSwjxVeHXgjlqo9ilreU6KmJRHdk9woKMFSUFX/sPCU7q+62lr3FES7upcBeBlZ2ZKuxdCOIKTxZ1OZE/V5GsL9MRSTWE1tt1wzfncx8omKtkNqROLy7pm3h66h9YloGrGJIL2oI8A88Mc+IoL0A6qy+dgmkvxWY3CpH/hbtmHNa10O5SqJaNV8awISjPxb34kNHlH+Or3TB5pX+mbc2SO1pR/iB1XCb24vaGrZbs9nfyt0InU9dS2CYS+vCEVNnB+ciXB1oO3IfFiw1qgP3kbin+ZNN7yO7BqQjxsBVu0XZOeHvQZ2/QXGnNAnsDFibrgE5Elj
 /qkdRAU8
 Vtg9MfsBCdpZ2CeS2h3aPXDUJSPLdoSLay6OA7hk4LNIpg1S8Pi54FpQ7Q8Trlyry7htRFbvJlB7ek5+5Q/H+T0e7UadI18TbyfuX5FWCap4BYGhYzDqdnXrqjjkstwWXBMW2SzGXqWBAT/Hpx5bJaEx1zFGeipXYtgh+fWELAO+E1vorTWrQhg90kwMA8omxEl7nTRII0DCjYK9LENv03pJcWuq0KUX2E/AWHMV14LTvd6cECqLHsYzEKFDQgYw/HMlj/gq6gFWUBtAk660ucyVv6Lb16r5qOyv+G9DG90kkn2w3QIROKP3hCAg++FYypziVl8lkjNyP7ioLlnskSWcfoXji4jA1v6weHPRg8FqqxsDETrEbF4VR2LupOWz5PXjff1/YdH6SJHMajCijoHm+7iFNYCTpdT5uelbGBL+q3LXbCTy9Y3qoMqjYQFLy02VKaF9Vy8VyHXalAd1NBea6LC4xQL5SZ2b1beVpVIkbftS/LhPQgWGuD9kB6plEhB9gkL3BCS6lUtMJtuqiVhhJxisDxH99lcR82xApISoANXehbu4eOC/+oA==
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
 mm/kstackwatch/test.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/test.c b/mm/kstackwatch/test.c
index 740e3c11b3ef..08e3d37c4c04 100644
--- a/mm/kstackwatch/test.c
+++ b/mm/kstackwatch/test.c
@@ -57,6 +57,20 @@ static void test_canary_overflow(void)
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
 
 static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 			       size_t count, loff_t *pos)
@@ -83,6 +97,9 @@ static ssize_t test_proc_write(struct file *file, const char __user *buffer,
 		case 1:
 			test_canary_overflow();
 			break;
+		case 2:
+			test_recursive_depth(0);
+			break;
 		default:
 			pr_err("Unknown test number %d\n", test_num);
 			return -EINVAL;
@@ -103,7 +120,8 @@ static ssize_t test_proc_read(struct file *file, char __user *buffer,
 				    "Usage:\n"
 				    "echo test{i} > /proc/kstackwatch_test\n"
 				    " test0 - test watch fire\n"
-				    " test1 - test canary overflow\n";
+				    " test1 - test canary overflow\n"
+				    " test2 - test recursive func\n";
 
 	return simple_read_from_buffer(buffer, count, pos, usage,
 				       strlen(usage));
-- 
2.43.0


