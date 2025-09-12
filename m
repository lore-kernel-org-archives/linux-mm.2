Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47272CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3716B0022; Fri, 12 Sep 2025 06:13:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B336B0024; Fri, 12 Sep 2025 06:13:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76A2D6B0026; Fri, 12 Sep 2025 06:13:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 649FE6B0022
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:13:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30B4D160729
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:10 +0000 (UTC)
X-FDA: 83880185340.02.9D4B94D
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 52BAD80004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:13:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8ALDlrm;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clh29CJb8P7VxnXXw4h/9gdA7sU+C9WtN5xBt8cm/X4=;
	b=PCjKERm5dP8RRP9tgfcJYKFAQPW8rQdLujuLbRiedk/hTvQGFa+t9U5aUyzHlBTgE88UZE
	WivvO+3Zu+c3PMV9xmml70U84BjMHXFCVY+nktUHLqtaVfYgx/P5R+9KcIUh2GdgCjiQkI
	uB1iUzAgD5fOcjNKsPkMrT78A9eTi3o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671988; a=rsa-sha256;
	cv=none;
	b=ww5hLbLU9e2MAu/DHyaM3hASajgeHWcJ/BoM+Hzy1MQGuW7rvs3tC9qkrjFySkJkqmrqwh
	3bdi2UdgXh2++9b0NYVI+wA5CkwYedKh0deuMtGB02E3GU4HmcVuKndbgOub3RL7V4p8BH
	nvti5/ZBc1VmdBLwF8yfQ98SV1SnvzY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8ALDlrm;
	spf=pass (imf30.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7722bcb989aso1243356b3a.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671987; x=1758276787; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clh29CJb8P7VxnXXw4h/9gdA7sU+C9WtN5xBt8cm/X4=;
        b=O8ALDlrmAnCNbqTRlG4Tyxv1iipI42ydt1laW5bfbyonAmrCnNTdnV1s8CRQMWASdi
         Dp8rIc8yDqrpdreRYsq+PaiaeRlg//+QjdeB8LCBNlst6A6vpa9jOAMUf7kolUya0xdl
         UYWCnPUSZrfUym3sTQbdYYCxR0lJxW4k1TUA1pkAXMG2vA6RkoTPCrPv0uUBVgCjtw4s
         leZDiZV7rWJwZzpDICd07HFwYxXmZ1J58uJv/92LhxeMi2Ws0XCy4i3MNT2V1g0O0gR8
         JyrsKv0f7PJkIKCBRHpglYrUx2aCWHevq4iwgssdNcNRLUtsL84vz8SIWHuqaWOOK5tX
         5S+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671987; x=1758276787;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clh29CJb8P7VxnXXw4h/9gdA7sU+C9WtN5xBt8cm/X4=;
        b=Ly/JWujsmDNSeg2YaYDnj5UUn4UF+OuUm5rPRszbndb+R8VixOM/vkWx2jyvWAEy2b
         n+/eUpy5P+UKrrXlkYtfpZ/JXVNBCZMgE7pW210Q6ENgDalxunwd04l1Y9ex4Zwtch9U
         T/i6MN60P1hCc7sl2to9aydBSsQsLf0NMcEFVl8w6SbmAMYP1I7y+qsxBTe4ihUEr1kB
         wfJzurdM8F7ggHH+4AX+uDuQ/LfxkPQfactY5D+mN9VMEewHtAbnhYxGGiXctggW7yRF
         q+JxaFWwO93S7jpE8QFYHPjUXwCquN2sFEjZwppLWPeXbZiHPAFPlPoD0D82Tu2nK4+u
         eQ7Q==
X-Forwarded-Encrypted: i=1; AJvYcCXWXLvkOJYGGGEbiihne80LUNdBnl7qclBgtpHQcUx6thuoYH5QR765uYY9aOBEbKohY0YPpNs1dQ==@kvack.org
X-Gm-Message-State: AOJu0YzL7lCAAxn3nGc0k60TLnglGIwzWoqxqzDZ62uwTQtJibkUSTFR
	0zaW4J8zY31T3BDgmr9dkPoZIDSsBMTAtGXAopVoE9lkktKhvFpiJpuc
X-Gm-Gg: ASbGncvNTvDmWs9vsOSq95gMGyFVbJ5nXgsKgBKX4rtKk+UvMar1YAUlCm7xovj82MQ
	eRzCu2swgEZaMQy78bD8DvyoM4eSjbsMJgWGg14D4e+6RTDvp5bMd0hcV9V9t90AkS5OKDahnlK
	WjxxoMy1IFd60TVFsB3tVCdjbgsxzRZYtJ08CY6hDPJtLwElMWbMNv5FiF6oM+dhwjd9GRPtiN/
	VjCHlkG7knq6OHpd5z/xvXpYqOnL3vZ4P7dTvnxrll16lkwXVtpwXeq3zG1QU/N70npXhgE/1bl
	+MAa19UcwjkX6j57f3HE7t5KDU6Td7ouiyauEp+xKArb+iNoSNI287PtKZ5WrraZPo7VqwMg0oz
	sHew2hVnGIPE9/3DxlFDy+uohwBK9xbOLhDo=
X-Google-Smtp-Source: AGHT+IHaEUea7hRsSpqZl85bTv6q0KsvHQdzV/MeRfkpCvkL2MgkVHPyR0dQHBXbAqMEfqsEXUoPVA==
X-Received: by 2002:a05:6a00:982:b0:76b:d869:43fd with SMTP id d2e1a72fcca58-7761216815amr3249434b3a.18.1757671987091;
        Fri, 12 Sep 2025 03:13:07 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7760793b6b1sm4934804b3a.20.2025.09.12.03.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:13:06 -0700 (PDT)
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
Subject: [PATCH v4 14/21] mm/ksw: add self-debug helpers
Date: Fri, 12 Sep 2025 18:11:24 +0800
Message-ID: <20250912101145.465708-15-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 52BAD80004
X-Stat-Signature: qzrbn9roy16e74owasproxc83ocgf7g6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757671988-702429
X-HE-Meta: U2FsdGVkX18MCmtwmtukVQCZFQj1PeWsOJZn/sOS9K0nzckyf3zDaLxG2esHyVz+YxHZAr5Dzem2Lzzm+zqnddRJ2Rh+jDOFoQM8k2IuXJyXi/AMdQksG5hSPh20bfYH5mfchx1cvdubYhpD7PD/vK604puro05XOFAjtKR+WNQDA2yX6xm3DE7S2oU190q//Sm/ApoK/O23Ne1tFPbdCcuG/3CuaPUiDzuVbKEN0VJUkAqGC6nR7ZaCY5Ue87hLJ2SzSdDhoAJ+++4o/yUP/gu8gji8b00FS0L3ZgCD5i6mFSkC0hfytMxP3TPgTcAeziylV2aFlrGpA/Ev5Xql8l/0Jdh4EW1K90nyGQTIV957195S3F/tNIaIz6wr2mjDvPXmsB1rt5f7gyW2zD5oWsoSb1JxgIptfQnpkLhsSibzFemDra6YCoQBYTgMtUdok+AUZqA+PbzfeCiMel0QXrBrO2Ptod11EWjrY1BuRBgc+NRLOoIokYH0md3AgU7zsTqRxACLS50Z96ry2n1i1jlEz/DodajzNbuyNtLpLUdknHpIv5NkxMIQABZuO82QBY0gsVKjtO1CezwvICmO/iTGQXljgeWc+SJik5gp45tkOYU+FKA6sXnFnYpyRP3OgFpiB+zFF8+xgqMgU8/KybgUWjoRKQBnq/asNxAWY3ONCJzsb1wVhtacDXfhIrg46hs87eWoniJytWuvfcjSVk5pGBU1GjoDoQ00KShKXX5adACfsxU38FK2ZB1PEAFF4j88n94/DvPh1K/8+ZbCHxBrJ5mjFXPvURAYW63Cbm1XQIipQ9jKqX4Aaf0SbQC3hHWl0GmxTpU+fnmQ4h3jf9qvtnXQ1aeMmPL9HtbVphFylmIgd1B4jDOGec0a8zieoxSZ+lUqOPsjPcBabHuo25lMQ93SyV6LP/N/rsPtwPq0CRFGhjPS7q1vRVwOz3X7UngEwO4x1/ek2z11bqK
 r9UWbsGe
 EjWE5Iloii0T7SjKfyqX57SvUL6pqSNRsGutpud9qWWdz3AL9d4kNG3RXrvM/raLgwX59srw/7Vtt5QP2IXrylO5vPWJIRoGq48vI7aNgWrzgI8B6BaMwQMxXuWAnM3lHolDR3998BzCqKKireHzEdm8o91MMvcvddmkQXv1C5ugGR+aplvKwVt3GQ24UP/dQHPg0AP7L0swaYl0NA1uy7XKtT71SeKWOkeiDx7al7hnxrmrqMThXF+c5bbrqt8eijGjF2fuDK+XA3Mki99vP5xoJWBXSsPN/D4UkdvB8+i0tqqXJHjvj39jN21BluaMn7xfWTQeFkZx1uuWFu8lC5HUbIrk5zmlos3mZJ4Rh9n9mwr52zKxXeInnO5xj+jRq3nt43TgSmr76KTPIjg9tDTxuaY9Hm/Ny8wDIi3zX2zxVrcaHfBMB6+w89sIQwR/HpZCmioKCFr+q7jco+VW3RQrOLS53Oll802ZzV9SZV9RRZSseJyEHUsiAlnubGXUczVQKTIoLZ6WqYWKuKCRaIgibdE6NqHcNEp/+vzfAjSEgqU0Ztw+xmJxxQg==
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
 mm/kstackwatch/watch.c       | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index 5ea2db76cdfb..9a4900df8ff8 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -47,5 +47,7 @@ int ksw_watch_init(void);
 void ksw_watch_exit(void);
 int ksw_watch_on(ulong watch_addr, u16 watch_len);
 int ksw_watch_off(ulong watch_addr, u16 watch_len);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index 795e779792da..2e9294595bf3 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -161,3 +161,21 @@ void ksw_watch_exit(void)
 	unregister_wide_hw_breakpoint(watch_events);
 	watch_events = NULL;
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	pr_info("watch target bp_addr: 0x%llx len:%llu\n", watch_attr.bp_addr,
+		watch_attr.bp_len);
+}
+EXPORT_SYMBOL_GPL(ksw_watch_show);
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	char *ptr = (char *)watch_attr.bp_addr;
+
+	pr_warn("watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately for any bp_len
+}
+EXPORT_SYMBOL_GPL(ksw_watch_fire);
-- 
2.43.0


