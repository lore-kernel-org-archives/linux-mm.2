Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C181CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:00:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42FE8E001A; Wed, 24 Sep 2025 08:00:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A008E0001; Wed, 24 Sep 2025 08:00:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930168E001A; Wed, 24 Sep 2025 08:00:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7F5068E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2E38043737
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:18 +0000 (UTC)
X-FDA: 83924000916.08.568662A
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1799D140015
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:00:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+lVyS9s;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758715216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
	b=566swgvEQyvR0j5KhrcsK2J/br52WXkIWeZ4cNxnZ0QEozxT17bRawO22joHqGO6zSGLZ9
	St19elEhe+vN8OHcVH6EOf0UlZmKlXoNlmkjsbpVTEOfPU1V8ZKaiP03n9PY1+TGWvHbc0
	YblZyZd024aU/9QXCTsGCPs9NSAcQA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758715216; a=rsa-sha256;
	cv=none;
	b=T3Ff3kjD1L1cEV41ZGPSXTEOQj0J7/53acfuvql2F9jPR5jChGsiguD2AQrTuSY/pfZOLT
	BGENBPZdllysiy6kOWCqSkTRby+tVFSyticGghFibV0URZWuV3Djv1vcnCt97Xlu5Y1/KP
	6Z9uBK6xc90U8Wc2REYlFDiTt4HyXRo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=T+lVyS9s;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-271d1305ad7so49138045ad.2
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:00:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758715215; x=1759320015; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=T+lVyS9sP9o+KdkpC3trC57saL3B9bZ88Iw0hlW9sYzlQv/yVe6ZfCVRtBsDIalkQX
         WXkAUQrfU2uguRDx84ooooIYnoGjc8f9841pETYcD8EMwaRKQqDMCmKMfc1WBrL5iiaf
         NmoU08WPRA9/cZ9u2/3pl4SRAvAlkXeqOGJr8yoYSd9aqpLKRv5ZAkTRKvxbSNfB7AT8
         K6BP23C+xC3D8MghUqcJWsBKyakCeGo+/gyAKfa7nwOEtWoS87Uw05CKbvWFAVSn7KxQ
         d6FcLdnBRCUCEw5tAMX3bJLxTjQ/tNP7wrD9CEW3doh0lEMbGbaDJJXOwjuTFdlXZpon
         LWsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758715215; x=1759320015;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UmaGbmiuxIsK0xKTEWJ/f7gfwC2bw8p0SOLh4b9Z4FY=;
        b=QrTeGqoqVcUBHh6qjaoz5I+KrvNaV/aSOd7djlvMqDw2BRdclBuGC1G+sILRC/ufZU
         KBQeQsrtZ1Nt4QE2fbChCLg8+jh53osRvOSd8nGaxKP5g8/Tju6Nk2vop8Hf3CNR9iq9
         3hOlfxGw4Db+AhdfaXQ/2e8RHjmeSmKOzhrKE1g7p7k3NFLOdkzqMzQl2u7eLIHwM0s9
         vTwZ4yvNVfxQWAE0uv0STOc9o42YoMgJmuKorQ0gN8o5tu3N1HpSXYCwtT5h2a2bUoyE
         XArlHnwgBtmI1pUA1Zs4BsYHKGnhMuEzB9qk6adpjfBtc86gd2TzTR3OdcWp+u+ViIDL
         hZjQ==
X-Forwarded-Encrypted: i=1; AJvYcCXqFuB5FxmFmiDlmIfOrE1JpTzeqecX9SwKhceDkI70v25bl7EyQnz7ldkwU3Yym3BUKg/zSAKakA==@kvack.org
X-Gm-Message-State: AOJu0YwzGlABL1/DBuHHNALwY6tT1UP6JxzI5Rfz5VvLEm69CYkHGqDr
	UryfyI7wIJs2zsttvsmBWA0yqJkfG11zzbMbmHPR6Fx6+INyeXZZDFeM
X-Gm-Gg: ASbGncty1IcMqGOVy771pSJbxhHuPhKXYBtKa+tU5lL40z19fjzXX9tp/7I5Y51GgxD
	CgO9E2ZVxKq2RYD6AKjrqDtxR1eKmUPOb37d+EeCU14RFqMKNxHkoL1Th5fe7d4Ne5xaSBpTV7f
	guaaepcSvGkxhfyx2IqnpixDYbcnYtcE+NngcDjBKYLUrnBl8PVL803ToyaP/nIWr3+7DaCroKb
	MOfInlV2LxRZXlutdY4Pli2DCfdSalTn+4LRJQ27FJh7m9E5h5iQc5GAlKdlrDmN/ZpBj0jc9za
	6RbspAvCesntjY9wVquAyXE8h6WtZP4PeW1TPe6W1ycy4Mld/xVAjMh/hNlykoigId4KJ1Eqq6u
	rfeRS/+MFQKoRlI2a7AXdUAc=
X-Google-Smtp-Source: AGHT+IG5AidgxW/pjwMRKvZXF7BqnVmuGXBXEakixJFL1V8tNMywu8qGgSCIq0aUezqYi7cmWgbNjA==
X-Received: by 2002:a17:903:2450:b0:268:f83a:835a with SMTP id d9443c01a7336-27cc9a91248mr60312585ad.60.1758715214591;
        Wed, 24 Sep 2025 05:00:14 -0700 (PDT)
Received: from localhost ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802de5dbsm189402185ad.84.2025.09.24.05.00.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 05:00:13 -0700 (PDT)
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
Subject: [PATCH v5 16/23] mm/ksw: add self-debug helpers
Date: Wed, 24 Sep 2025 19:59:22 +0800
Message-ID: <20250924115931.197077-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924115124.194940-1-wangjinchao600@gmail.com>
References: <20250924115124.194940-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rznx9ywkos9mjbrajb4y1dp9hz97u3rf
X-Rspamd-Queue-Id: 1799D140015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758715215-338030
X-HE-Meta: U2FsdGVkX1+bp5yZtS+3FhrAURwRFf69thdaDvaXYgyRZWYXH2H71WxVeFbqFGHgWkOW4MzukCTI83sq5Ehp+76wpCtXYITcufQZi0akI2/5pMc/afbpujpektKIKgxWpuVgJANvjs6Ejr7fPVx5iTLk2PwLvr+ce0OIb5AwgW2llxeZDXZmFto69krEa5iA55BEYzd4amIrg4lomJ9Kc+eoq1I4SncZ1OQ0rDRE1+JrBNb3tn3NynMpkk7Xj0cm9+qkCSJXRsvXm0W1H/3tPNExM5MjT2p8CBtzb9iLrA+jTqD/nRr5Q7kwAEEO2i0Z2kPq7WGkYcIY24almQAijnSZocTgvbruCFlV3Y/++jwfY6Gi/S5CM82A3RDhebiApj/gyNvKUln7Ov4/QJpzhorP5y0HlqFK/GN1neni9DnqBKztrcuzhBVIwv9H/8XUddrf5Xw3Qu5d5gtoIXrHqRWRVk8UjOxnI/lc+r8uIPhA8Fn15RWpuOiCx02VRMwt71fdF6ROmr5Feel80gsaGKN6RRUFWXFchqZIcvMrDq5iaR80Roz7dWvXkwmSoRrv7x6i1OCpDXM/z5uIs0nmygzYBiGRdupXUIc490h9sekUn/UdJcziFljjN956/pYTptYEf75Ea16GuWmwDHiwx/cujgXc4frLRGvqckGi5w04bSrQeZEC41kcyWhKjvKezhOFeFlYvVgF/to8lWkcRwDjr1JAshc7kLNdL1mMN96hwZH9jASz6u+X+amhZwZPuBVy7Hq3fG2heKIt4GsVr5yaciY2SBmZP4J8sBiwErVjLASwTLVvjoh6si4bzx2hBe5baxF9YIfuMN13m8f09JP8nqlf6elt9GsB2+NqE9Ct6PGMdSLWUKoYRxisWekUB3CccgR91pn7CbzdP/XKw22roiaa4kJyGcbp4T9clPbUyeP4M+GACZsBHgXVTGGO5xXIk67C7S6w1o+fuBD
 gUFmiDhH
 vkFAZN7pceiCiUcy+ACXTp7NNjtA9J4ZvYgAFIgvhDvaD9VeXCrlB70oHppuoM6YoLkYDLbrDjEjOyuk9VWMzBHJtU+Zi4uATOQDTNKIVxgc/OqHfMz16A8UT2tCOw1pVE6VaeYAhce3Tec1zsSXzoiMgYpX8PI1Z/yXvyOUGuNSaGTzDDkZkYYlNLJFSoPjaZZ0E4GV6BBXPfbh/D67RP9ZbMn9YnrIt/6pB2M5l58o5R7ULdNM/U78JDJ1WBW307/soKgXmx2nynAEHI/GHsQ1vSyFUZgJbA4jEf4U9rk6Ffm/AUGnEvN93lwGbQUcbazoLqPI4IA5zAgWFOxLtuHBHtW27Glp1ZGlmtxfFv7BO5REYdisIuplXQGjs2Yu18gbnMJkXZvKHum8EYgXK7rhNtGoH1bzr285jgfpIPTl3aYgahD/Hmnk8ZaCP66zEPGFrbWyeDZXwZ7d3Wf+d74i7+S5vxiwWnQu74lRmPwBJR4Rf9fR1F+/Wc5+urvej7q5s0Ro5ma99DL4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Provide two debug helpers:

- ksw_watch_show(): print the current watch target address and length.
- ksw_watch_fire(): intentionally trigger the watchpoint immediately
  by writing to the watched address, useful for testing HWBP behavior.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c       | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 36 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 4045890e5652..528001534047 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -52,5 +52,7 @@ void ksw_watch_exit(void);
 int ksw_watch_get(struct ksw_watchpoint **out_wp);
 int ksw_watch_on(struct ksw_watchpoint *wp, ulong watch_addr, u16 watch_len);
 int ksw_watch_off(struct ksw_watchpoint *wp);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index f32b1e46168c..9837d6873d92 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -269,3 +269,37 @@ void ksw_watch_exit(void)
 {
 	ksw_watch_free();
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	struct ksw_watchpoint *wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to show\n");
+		return;
+	}
+
+	pr_info("watch target bp_addr: 0x%llx len:%llu\n", wp->attr.bp_addr,
+		wp->attr.bp_len);
+}
+EXPORT_SYMBOL_GPL(ksw_watch_show);
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	struct ksw_watchpoint *wp;
+	char *ptr;
+
+	wp = current->ksw_ctx.wp;
+
+	if (!wp) {
+		pr_info("nothing to fire\n");
+		return;
+	}
+
+	ptr = (char *)wp->attr.bp_addr;
+	pr_warn("watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately for any bp_len
+}
+EXPORT_SYMBOL_GPL(ksw_watch_fire);
-- 
2.43.0


