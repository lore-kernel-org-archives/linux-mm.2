Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41888CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A05238E001D; Wed, 10 Sep 2025 01:32:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5A38E0001; Wed, 10 Sep 2025 01:32:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A4A68E001D; Wed, 10 Sep 2025 01:32:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 760538E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 443AEC0677
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:57 +0000 (UTC)
X-FDA: 83872221594.30.2F14F84
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5FAC120005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UWR1Lad+;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qrAud60iSU3AEw7FPtcpLe0K/xeVWiZU0ZsMgXrQnOs=;
	b=dGcjsY85UWUtEdm40pzXBZXPsFGr4sypHLnevnZj6UyUrcdqkM1SSEZ41ievb+m3vwiSk4
	oaaKuq4MdYlI+uKUdofO2kr8N+mI497md1/sK8BkZp+OS73s8XC4NBOn+eff55eLYByNCw
	I5t/wzrC9c3YPwLdLgalDREmQlfVwmQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482375; a=rsa-sha256;
	cv=none;
	b=X0lMxVRRLZfAkCdnZBDphrZOD9ngixTm7HXlklIDT5+L7UcgyXJ3jH3n7k0MDuNRWj94vB
	8DxBNzjNxphVB3ortnHEB/G1K7ZBtEuvfkBFXCKNkDR3LWmOzJgo918HuKS1gCcaQBi9Ie
	NgJzJOeC9HDrennRHNKkvjdnn5EsmC8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UWR1Lad+;
	spf=pass (imf03.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7723f0924a3so8422390b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:32:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482374; x=1758087174; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qrAud60iSU3AEw7FPtcpLe0K/xeVWiZU0ZsMgXrQnOs=;
        b=UWR1Lad+DKPoK1jx0cR6gJBla1uIglBMRUmGsCctv2fSsKlyHhkUmwvizGJLmO2iFP
         apAJsSv+SPaWmfUwPztvZTBflqW8aMRfRl8Zmpk2+PCwRSvlOuPhoIQQfLPV83KcTA93
         Grruz1hUBFzNeHeKdp3smzMgENKqkL7gNfy9BcBNhffBzBHDVQ94Nse4h7jeVitynz2I
         l8gBj4TKxVnqaWpCGGOXvnXdp3vdz++AHlyUK8Ruc/5E9eFmTBIbRIAZ1Li2FinsaOOB
         +Y9+tyFP0tZVzGLiBTLhec6gGgAd6sF/pch1aTVLcdl89067IdYjhxLrdr5RjNbMFYgG
         1Njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482374; x=1758087174;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qrAud60iSU3AEw7FPtcpLe0K/xeVWiZU0ZsMgXrQnOs=;
        b=ob87nadoFzzPI+JNJMwpFMTQxCnXP1a25mgGijhY8j0+ueDlDRerUZx9z+hTQWfLm3
         deheXDrPbn5Q69FUfiSl0IiftztZPt/PRsfmTDZbjcnLtOxnuAd5tvqXdWnppb1z14mt
         39gynVzA7waVzK2ixwsDx+atRVE7LM9V8C8DUIZKgiR76NWtdmLa8k/0nr/KA2+s162b
         7s9nFL3cc+HQxLzo+Mk8ONIh3xcy0nD3fqc5tMIlHyw0o1rP+XOm64M1GUAxg9SWSelm
         AhfEblqgkpvMmLXF0O/7stBu2swxTbIeMfVNzGt1bXWfrV04r7Q3UwKoyypL7B6W/MNn
         Jdaw==
X-Forwarded-Encrypted: i=1; AJvYcCWtqElSnrkwcONuu1loD+Sx+h8oaofB2ZoOWgxLYN0+xJd/vmEWR1qzXo8bMQyi/oFmVkSnGyG2Ig==@kvack.org
X-Gm-Message-State: AOJu0YzEGCmgNiS3uMcu7WcXatN211/tCcJ79K3MVCGF7/4qVNhKIeNP
	Ku8h6T4/5mWBStWlKEj+93aOjHwqUqXnn7DhlQ6Vj1OIcjnS8l9/zQSc
X-Gm-Gg: ASbGncsasQYoUIjAO3YbcJn4FFx1ltrWVzfFx9CJCjPsZJTdbwTXTHzDaDZDnZ493g3
	TF0XrcUB08t6FrvH5S2b3eBB6jKppwaJDZyPVZQGpdTY8+A6XCvnzXWpTPNfZK6+vVKZSl+UjkK
	GhofWl9y4YCM6e9CQj4EAEe4NZQsNwv2xLXXLTLi9K5ILNrJ0DQ/+Ihh7R5poDhS2nfXk788VsT
	FMi1LGENFOsdlhff/Bcv2gdUyJmnbeYNZjlzX6CPyqWOtt4UyeYcXYNEkDICs+RfrICKQNUz+QG
	tQuHezslxOsVUkISio4pK5s8SdnL6kZ6r7xgaiCcg7LdA/UdJM1FwTaqXQMM0WXOY3AccP0XrBb
	JMdBAKjiowMudr0nP1roRhFOW9VI1n5f0p1nmgwtyGD7U8Eg12A==
X-Google-Smtp-Source: AGHT+IFvtyjzKqjD1jevQiJ1bC/syfF7SnR7xc0dVXuUXiVKJ5VEJ/pwIGVUhV4HcoGZrtlei49omA==
X-Received: by 2002:a05:6a21:32a4:b0:252:2bfe:b668 with SMTP id adf61e73a8af0-2533e572dc2mr21000740637.4.1757482374278;
        Tue, 09 Sep 2025 22:32:54 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.32.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:32:53 -0700 (PDT)
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
Subject: [PATCH v3 13/19] mm/ksw: add self-debug helpers
Date: Wed, 10 Sep 2025 13:31:11 +0800
Message-ID: <20250910053147.1152253-5-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5FAC120005
X-Stat-Signature: jxqshkcnw89wj3qtpm14qp4h6pm7gpn3
X-Rspam-User: 
X-HE-Tag: 1757482375-404049
X-HE-Meta: U2FsdGVkX1/b0S5wVoQvFWyhdfEDTBPKEU/m036a2yRqU5V3ObGK1BckSaQOlHL178pBe/ISOBJhFQ2dva4fY488KLmlUQpeHYDaLjw5icTO/TroCIGcn83Fa+hF536zcxPaNiwlFXdFKRvkASeO/kyMtP6vIL8Yt68bXv60fDZPMKIvNo0tX4/qcNVTGCLPlqWH71zldlkWCLoH1YPvh+r2SArheKQ03V/oZtiSb0b9InjYRfm2w+66ZGt68DtgJdKrOiv1R6SMoL2daZbAwcLCv7ZtzgfHtWn3p83uNBbqtjJJ3pFjv6fPF+8x8RuVLHx/xlIXd3wBlzRJupo1wGkM7bEe+vK1UXx257nRwhNY0v5BnFMNLE6FeIpzFD0kn0sUv0EbbXMsn9ejCWotR9JGtRSmYyNExLaK5rDUntmlCd3H1Bla3ZBl7fKtY5yT2Zrn6pm0QQY79JDR/w6PNRJ3I7PxtbsxFuZauk5JWCjdyyrCMd5lnAk0IQaKi4BrujXNNGo50RDLBNJD6Yq/NoIx2m2ViiVDLtiNZ7IXs+qVnBbJwMwm7hVIH5FAZvso9S3TkMtzBYJhWpMKcLNG+LzCuPuZtF+or60Vc+cTumUOl8ha63Q/rmSraIXpabuiO/ju7fjGf6EmGUfYXPM/AF+ojv7/rsKxP/6hyPRsbosih5TTg+5Y80P6mpCES+SplSqztwTVG8WDKw7z2titGbhuEDJNbmOmoSuqjVa4gGzlMYMzwir/u8cFacOhPQ6TURaqA628TeP/A3FF4YH4WOqhy/oUF8ZmKBFcgWUQHnnKABwu5Rel5WrATb7Cq1t+d+ciGscgT8Jt/9LmqcyUE9g32Pagayv0yIfn++FpAlxFslTMhmyOkb5sgErxar8zQK/jR8LC0hB/IHcoA+CZd14tOmE+41pfFC+iHYtCdTd5kjHT5fRaJE53b9mXi1avpQ2YAquNtVfANpSitWL
 g6cIFYD3
 CqSXvzmoBHMEBYxk5iEKjr9u9PasxqHvswfH1F6nmxJQpvSDicGeMdU3rW4NXi8ZDaGBOLhWc4VjXnQ6Sh3yMSLVUmYMblk2XBN+xiXQdaH9zlnBepYKuDo/QJlvQroKBKNxjB5B2BunHk8oQ5YoyTJIxv5KN9I5cw9Q1aucoA6iUjoH+GOsAZac16PYHbCiA/jH/Px3a67ksCNBZ6TMVyBZG6ljduDpHwyuncNjNi+z1eFSv/cp1joimJeKDt2vBTSI7rTK3yfizJbRJHCYXNWSVfeU9OK+OAYJr4NVIBUHOWMi/ucd1QgDF/E3IuDEImq0CPBiEovHmP2nKtvCLDxgGHW4On68izeMk2YT/7E0HA98i/jGrCyHOx0Vh89VffBYKvxmBY8Adg6McmRNTwQy9vSiSglpsXrtTku+JGMVXl0db0tsq5BtIOAL1/lTLFd3nkfl5qCl2NFK77MUE3JHnjNUyNYeZrga2AUkFUYNvGEoP8X4LiFLVcp/OMNzayImC
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
index 79ca40e69268..8632b43b6a33 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -47,5 +47,7 @@ int ksw_watch_init(void);
 void ksw_watch_exit(void);
 int ksw_watch_on(u64 watch_addr, u64 watch_len);
 void ksw_watch_off(void);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index d95efefdffe9..87bbe54bb5d3 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -185,3 +185,21 @@ void ksw_watch_exit(void)
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


