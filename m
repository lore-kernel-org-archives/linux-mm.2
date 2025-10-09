Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05579CCD18C
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 10:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 526318E0089; Thu,  9 Oct 2025 06:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D6518E0002; Thu,  9 Oct 2025 06:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A08E8E0089; Thu,  9 Oct 2025 06:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264618E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:58:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DC65CC083B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:21 +0000 (UTC)
X-FDA: 83978276802.18.2E0DE6F
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id 006B7C000C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:58:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mwS0t7LT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760007500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
	b=CfoFbxaeaYZATBuqi4J/ntBXbBs8Gx3to740c52QlvgKX16IVo8Vr+hFuXu46qj1HUuB8Z
	Df4w6qX3yIm/1ZppaMNElzJk5RvWsMbs2l1RlNOsqBg1+k/lwEQkhImo3Dlr+kWn38OToR
	On1ggNZ0DLGUziSCGdZ7tnLSC/ifsTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760007500; a=rsa-sha256;
	cv=none;
	b=h+Gf8vUDm6Gk6d1XRaK70MUmpMVVdNCqyIntPefbm7jl+ZsD+D+4A6wGSBltV0H/IjkvrG
	9B8rQqnhfsNa7vrphEtcm3oFurT1ZSu4CtuJuZxREBi64GuNKK6cLyJuq7W119/HOIEkqX
	wDv++jV0KyB+qhpnsFEA6OodmYw3aak=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mwS0t7LT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3304a57d842so744980a91.3
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 03:58:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760007499; x=1760612299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
        b=mwS0t7LTvJwCi++z929ptnfCUrn/SZCOntFUi/WuGABOMWJS0NHoKjjTlEQCu0nuWX
         eIaZATL63TS3X2PVigmJJvzDKbCQA65jmchz8HpuKEaPIFtsJ/aVMmBokh8OFbEeRDaq
         Ljmosqwd+qT82cAsACLsHlGwwRIJLev+E5AReEu955rv0/gVhTneuBSYbtjICMh0scKi
         mE/kmFx8GhDigC+6xF8v+e/RJ8UvtpUzjKwr1oK2pk2LtvWQJJrO9AvFn2AVAYeWMu4M
         ZUdaOtc5YmqyfbjDodJRVi05C2eZ8CUnNSfxe9+xxz6tNaNvU0QxTagUdCSc/h0/OUiy
         GD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760007499; x=1760612299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OyJZmUduTn6h/ct8/Xe3ui1NubLI+U0SzVd7OlZC6q4=;
        b=qvGJG7a39jN9E0ZiIedFqKkSXElYjXedCEJTOW4kT2pKFpA3gomvs7wmPO9IURr58q
         9GPqWGoiOYJnmZuh+mnFl/HTDCOD1kuIS7NQ/V6lzuwIQT8am007hs5EvfzgaG49Dui1
         dc3qNbsilqbKTfey+iaMSJQU5hmMxnE1KJ5ZrYHJvVXfofSZ5DzqNuONqbx/XJRPUqLJ
         8TdUqJStE/SmYRi9C/wvF8HQkGREH+Lhvbwfgf35SLz4r89kfDgPSex5ABs6BgWPVRNL
         dMXi2969gqR1fe2rG1M8jlx9oEFN9mowGNTMkXmOJESR59bmaa5olUA+VJXyR+P5wsYr
         7xuw==
X-Forwarded-Encrypted: i=1; AJvYcCUFjgcHlpXvaKd6litmYXAFwtr+NQMVeQSYjn3J3rmDNg+9ShPoEE+Y7vNzu398/RmSsecKJ8+U6A==@kvack.org
X-Gm-Message-State: AOJu0YzayD+Vln4guDq+KYyjwirhmAiOlt8wTTjAP+KlT0V7aePb4SNu
	5ELi6Bf1U7XWifiRX4/eLjBuJXuqaGydSvczRcKT/rY9yhgPSebbbJw/
X-Gm-Gg: ASbGncthooNAD/UNbejBrKx8J8o7rcaFp6Ye9THpzM+jId4j/dAuykBzwQlKLVyVAfD
	D6wOZ3AurLUFLBsR8IzfC95ZbnuRGRZKjnvIyX6VXEQikRP+nLsejCGyPe2ZRxw5KzF7pmZc2/O
	jRGrARPCwmdvjNn7Mn0oWJUbuTyOrOVuWxrbQWFbuF+e5OJO7bR50C8ytO3XPK+uV1BVzMxbW7i
	bcqAdPRRKOgVJdDvrXD37reF9/7h7Xr1eaaIJSKaedMXV55tiiOzXu3PLSazCaMA6iGoeyCCfai
	ifDzGBZXA1yqV5KOVbcotvdKAlVcGCFGWzU+qh4xCTDjeP8JPbmyiIZ43PozpHb0YfHwLa3gyCW
	JdWod8gpr8xgsHmMqv2wtC1BDbAgBDhsPpzaj9SZS91ZQnlNMjxKE6oZOty06c9L0woEBNss=
X-Google-Smtp-Source: AGHT+IF7XK4PU8M1yAqeyUxzKM38g7FsehoBLZ3eJ3Xub26Q0OuA6NSoqSKwX8dJhtbar+wuz4p6HQ==
X-Received: by 2002:a17:90b:17c3:b0:335:2b86:f319 with SMTP id 98e67ed59e1d1-33b513eb68fmr9866604a91.35.1760007498698;
        Thu, 09 Oct 2025 03:58:18 -0700 (PDT)
Received: from localhost ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b511135a3sm6725691a91.11.2025.10.09.03.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 03:58:18 -0700 (PDT)
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
Subject: [PATCH v7 18/23] mm/ksw: add stack overflow test
Date: Thu,  9 Oct 2025 18:55:54 +0800
Message-ID: <20251009105650.168917-19-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251009105650.168917-1-wangjinchao600@gmail.com>
References: <20251009105650.168917-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: fbx8dbh5jfawkihfjbwkn97iduwjjm1z
X-Rspam-User: 
X-Rspamd-Queue-Id: 006B7C000C
X-HE-Tag: 1760007499-228027
X-HE-Meta: U2FsdGVkX18X2zdT9sQoxpbkh92dULpBXxCy9o0XMKdS5fzaz0Q6mlBrWM1VLduyD+pfL405ZqUhyFdaICaX5NHpZVu0lBFJjnWgWY2XeWcZfmQZzIS/OjP/FyrnzFYn/79DeFZKv4tNDP950SU8oSjP5uc3DnmXTdIF9zOrhzvA2ux49wSMm6XzGZCKXJ368SiLn2kXHJtjYk1R99O8BZh/xWUAq59+fHdqEn4AE8wNs093YeOq1gRbqHeb3IqKgCAdaqJEbMSxwAm0eFiTqVL5RWLISDNaMZPah/rDW2ST6D4+mEtyVdynxn0qEjQIBP0Vqu5Fbs7Ty+/cIrBwle72zoOjSD9OKqmz1gLTLVIHS3fIlPHu3/gJLmjqUPIKWj5qpvJT3IQHccCt/9LvymPrQxOfVjyuK31nx0d2+KhvmEMLnNAzsrB+dtiO0yCIBpOq61zhs8nhWXLWySfpi4hmmIt5jsUZOz6tjSjv1TasVJnlQ/S5PKi5esXiXoOPZ+uKShATMVAS+dkC18HlqxugrOJknHrFIbddr6jVdK8VkrFpfCFuq36sD4EZrQRR1SoiS9FYq/qr3peAn96Qz7q0fpnP/dcOQkskn9JHXFh055fAXo6Dt7qQVOCtwF5Zkw52AT8daqALOmaH3ekf7ZzeVDgj9Mua0A/6XQJC1i4ZStSXYUNwF7HiTgMNue/TcvOJmGL1GrZ3Yo+DSNX1T+maDmDopblObknOrOcVSYsjBAvtMQpwcsMZVADy5abFPE9Ti2apFMxasFednSwkJTO6Uk+X9fmEoIzzdQ8RRnnjk2Ay8ZFRYWkHn+OAmUY0Wr0ymtsPO/F86JkBK+MVMTUa1LGJT6J/ynuvVJaTXUNfhhPuxDlbxIpjetWjPz2GTLA0PbNhfwYWruD/FAyrCpb6BIcquJYdbpZHL97yjyf58eeJEr9++i43vgtog/7boUWLyUmlwE5SXN+0h/N
 eI/PyWio
 x++7ZO9frdP7JsbxCEXjHXfj7fZ/wQrKwXjhK7mGEGXbd/ZfciwaG8MoUC9nyRdPyHalLXgFXr+XY2QX8CoM8WyPXfVK2nXTngEb85UHGegnPGTnnql2DM4pnM5JsO1LQHVv/Fxs821GHYcGaIpoO9Wmk9eszsoZfWFe/tR5MqG9FsIMwQSmZLnOpWyIXWOl4Ad/aK0MVbje5BhBvG6QRfGAnJHiv4jSGYx/zYgr0bwvhd0QXAVBdRcazQ2E7B2T/byZ14YKD24XFD9nnG0dJq3Vx9MYHo14nSdZRiizw9jqSyIxHtGJmgMcDhmNaUuVLJC/Ito3WjCJr0FU16Fs04en2Vgpdnc1RVpweUa6TN199t//oN31/qN2C4xpQgYy9WdlVMxejShdVQ3dqV8hc/uGliA12oxgDbuzQXyAa7eiQWXV+/0jo5Ozm4KU9pJWx29QS/nwoYXZv7+rs4w2BRUTPHfRsvO+rOhchkQDVUWZG+XxGaSukK6wnvRv/r9Pw/iqISvWrl6ZY8VyboIFQCykoKwyGiKNOXCYKtgsLlpMrZsc5BJ3ol/AXJw==
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


