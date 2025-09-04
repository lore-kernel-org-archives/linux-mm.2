Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF66CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 00:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5198E8E0018; Wed,  3 Sep 2025 20:23:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1068E0003; Wed,  3 Sep 2025 20:23:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406B08E0018; Wed,  3 Sep 2025 20:23:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 305478E0003
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 20:23:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA38A11ACAE
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:39 +0000 (UTC)
X-FDA: 83849669358.21.304978D
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1457F20007
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 00:23:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WulTxKuc;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756945418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zy5btr4Cxic2TrxrfGpIdem3AHKjFkBdPXJVoZYatJg=;
	b=U4R1C+r+EO80C0bgT/zpUmjTw60TsdwH29XfFLTubZC9vAXCSSsrdzeArwjGrXqAizHzBL
	b0/bZThJqc3foV2xfkrSWr7cZs9gGpqhjLoJ76DjrTmjiTYR3UUmcUBZXTlS+lRD2TcWN2
	v3YUGIp0SAzZgB78wE29dyLE5a9H3Co=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WulTxKuc;
	spf=pass (imf13.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756945418; a=rsa-sha256;
	cv=none;
	b=iumCFsOHj076pjFj0H0TXQKnTfj7Dvoutc5c6tEcWaoFatat9SX/1G5vBDWEfBNWw3F1P4
	b1MdqYnXNLx7QqlMX30dwzrFlNzz/mN90j9L7AAtAyyK9RzmAWTnS2v2QyBrxawLXQytqJ
	nxlYx9mqZdt2k4v2a8VQIBGXhCizHjc=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b4c72885c8bso340091a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 17:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756945417; x=1757550217; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zy5btr4Cxic2TrxrfGpIdem3AHKjFkBdPXJVoZYatJg=;
        b=WulTxKuc4mztKJWXjur7XKes5r/FOfWjoHKHK7hLEYeXFwPgDW7n7hA9M/dRxFwxKC
         8UsasczfkO2V3SmRjz9+AemLZtk+M2/E6mpxeysGZ3iUsPS6+cFeRosCsnZYesEmBzUn
         qN9pRUSRMrueQqf0tbL5i4TAyPJHCZUR1HW5Q7OSCFSuZcsPTheCzIOrlj9Dq8HT5ZMD
         yAAfkSTYTkE3y99BBgUq+ybGYNs91cmB9Yvac7c0Nd/BAke8dBcnywzebmMGa2z4eXi5
         mgA7mUzhJ7RJRZDxZgWrOSOHVcHHva3DLqxAD0MdBUK3tjzbI7xAH/AQP9Sby3JeB7jn
         P9ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756945417; x=1757550217;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zy5btr4Cxic2TrxrfGpIdem3AHKjFkBdPXJVoZYatJg=;
        b=kZXqyCUTFde/sc8hM+Pq0HT6jNLVUIvtgtdyazrBfWzMhfTtBsMo6S2WH6lEQ0ypC4
         sks7IahB/8zG7livTOsivQr3MvOORnmZc6b2PFPALMdDq+6v40z1qMu/k4TbsWs4TorC
         8RJeXGuGuN6xjNi26yIv2Q3FFRCRjZxSD07OU2cySJuCwXvCVCNNB/++3QDbVGM1qC9/
         5Z2ovZFJbRHwlf5DmBkcj+9pAJeJqzIeelObXIjaLfbsdyEog7ESMioz2DToC6kMSDUm
         +LgtHSjKlbp3s2dMgHrUg7Pt5QSVv73T8LxAIRAGG01qCTDM5lPfsG4ypGgT3+vZwWrr
         LERQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXp2Ok9i3M9pC2ImCin07xH2XSEbCHlN96s+aSWUOgHrvk/CrQQfMj/Gm7Wya6qNmqn9XIMJ/Fpw==@kvack.org
X-Gm-Message-State: AOJu0Yxg5RYnJ4jumCPVr9sqSmjoB97+PdF9hBzrYzgi7YQ5QKwtKDCJ
	2uOqeTrSTna+Q52PhZXjKDTHlpms5ro6+RhI8bMpzFoFWEJxFtTbmibS
X-Gm-Gg: ASbGncstBxDsFG2yoRihXNol1PN5j/uzd89SSuqVV4wEVjskJDg2q857QMO93Nhuhs6
	N+HMIZm1NWjbRILuMd18xLm2UCgKyVaLr5Ur99NrvHjxQ6NH9jhTSj7Al8pmdgS2rGLhtWDgqP0
	cd/Kt3ma+RzNACJ01wCnwCeRAXIOqSPdaq5j/XS34fRbESS66iXgKeAImudv1ODyIFUkL38mNqm
	TUG72M1vQ9PMBGXi9xAes9dL7zFdJm9JbCaA+32uqXTSeP3BqMXf0ZDgWYCxVzLA9afAk2EL+vX
	uak2tyBPdFIP+0r60242Fe/XihigI7Inme48vSNTeYQBJJxBtFkIBZc60mK7QhJwXbJfUeeRroR
	DyLybznscC0ZMK47NLpOyLBBZMAlR9mLscii5Ypqt7+vvIsvkKc85yWRsjAQqlQ4=
X-Google-Smtp-Source: AGHT+IFj/QUfdNr54DaXrxUfOwjpV2lFcaLFWb1JY2iCOe+1SSplj0UymNXEqzVyRY1fytwFbBj4MQ==
X-Received: by 2002:a05:6a20:6a22:b0:243:7617:7fbb with SMTP id adf61e73a8af0-243d6f3941fmr24535766637.43.1756945416828;
        Wed, 03 Sep 2025 17:23:36 -0700 (PDT)
Received: from localhost.localdomain ([45.142.165.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a4bd2aesm17579551b3a.48.2025.09.03.17.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 17:23:36 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
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
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH v2 12/18] mm/ksw: add self-debug functions for kstackwatch watch
Date: Thu,  4 Sep 2025 08:21:09 +0800
Message-ID: <20250904002126.1514566-13-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250904002126.1514566-1-wangjinchao600@gmail.com>
References: <20250904002126.1514566-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c8tn89qwia6pnn6eq5npw5yibawcrbr5
X-Rspam-User: 
X-Rspamd-Queue-Id: 1457F20007
X-Rspamd-Server: rspam01
X-HE-Tag: 1756945417-91089
X-HE-Meta: U2FsdGVkX1/LhL/oBTkcslrdSuop6yXYdAq6uKmcL66RbGcts3YqBStrZqw/weeOKAHebuGULXsLnZNUVluwdSZuLAFaWOEAq0ELKReL+sF9UU8AeE1zZkZdGJLYVSf84cU1i4udPB6IkPucGsV+xg9Axdxk4d6TGgi60OihwL/VbrTFqPY2CSwdVjTxXA8cJKFA7U4kfDgkipCa7giP1SziN3W9qSKdnrkCTvrQ/FTK6Jc2FmM3k4nZMS+V9g2o938O3xVs5aNY1Z1ZXMIPxIXT5TqOLArc/2KJj4dJidxpJm1BMShpeYPaDZ/PBE2GNF4yPSUdM/vNpq7qmOf1DKSb2I+0xkzcAk5PCd2sS1J9lxXezDD0CaiBxD73stFlmy3j/fOL8ynF7jpev6aohBMRGNscB437tXvsuUuDpm2l0lzrGOlKW8B9EGnetEALbdSswAZXn8zkIo1YLHUMRJD5CjIJDewrUU3UM1dopHJZNCxUSMl5/ur0JCa0ajAyHtoUe3c8FyLzIAO/euJOVvlPNa+CZhi80Jq9ilKnCzG2nOnMK+W3tY5P1bm9hrWvmx7DVtS2+MGvF3EQv+5tSBYYJUXI2a7+v04ZtmiRrD0GYqgSNZQkp8B8sPjOP5Dog97Q0vF3zNf14B0IgA/jhgWeP7tmrItKstXISQvpQWTAxmhkHGfPeQoG6Gy6pB5lzfPUyDqiJ2XqarVnOevYlBqACfW2J8UvY3F/VzWIqGWIQZq0rfiTj8SZk/QYjfac2G6GfvRbuq3j6MnAO3pbQJkmf8QSH3mWuGc93A1NV0s7Jz+QTwWLVHGBY04Xs6MwOmz7AGoszh5fG96CCPYKFc8z/RcGjTB3RN8kPRNvMO/dEEr2pmS3EM1QjuaG3Ed8RPC6K27mJ2Q5ZaTxGmJxe/X9eQg+Mafhp5GtqXz8Zdyrfk6KHx0MFhyQzpES4ST+kNa5Qdw7JmEjMuDNBET
 dTEiVnaO
 V2baPtWt1XGDGoqldoelmFgIZHZnaIYR2Ld+XWoMpYc5WEKFCpLlU2D/hEeCl2elt5Uoig5ke/rPWhKxiBKSbYRpqCX71cmLX+DUidvW/R20cNNkRl3wbwcegKH+x30aUdCAtwoobHuND3mjmq8AxOP0AfjA2CzYrwn87J84shzYaJxYqjIlmz3BBP2MTo/u/18fVisLyCyUZlF987uVOLkNvSWhs301UUfTT6h5IwQNzSrnoThbM6poSoVVZgPJ3bWN8ofElv+zoewqmkLDv8lv3e+rxn6ITCiMyCW7AGx+mFUZSHAFj+2PbOonoYkCIGQuaK54B8e49Pgz/YSdtxG76QOVlA2jk84euTJMEUZP1dGZq8/I0s6DA1C4KfviHsXSegfABnaMJGEjqe0j1ig9owcC8xE/7qH+G2svT2TIpg920rSsOnSVNvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce ksw_watch_show() and ksw_watch_fire() for runtime debugging of
kstackwatch's watch mechanism:

 - ksw_watch_show(): prints the currently armed watch address and length
 - ksw_watch_fire(): forcibly triggers the watch by writing to the watched
   address

These functions help validate the dynamic watch behavior and facilitate
testing without requiring real events.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/kstackwatch.h |  2 ++
 mm/kstackwatch/watch.c       | 17 ++++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/mm/kstackwatch/kstackwatch.h b/mm/kstackwatch/kstackwatch.h
index bc8664af4fa6..d1bb5ae75aae 100644
--- a/mm/kstackwatch/kstackwatch.h
+++ b/mm/kstackwatch/kstackwatch.h
@@ -47,5 +47,7 @@ int ksw_watch_init(struct ksw_config *config);
 void ksw_watch_exit(void);
 int ksw_watch_on(u64 watch_addr, u64 watch_len);
 void ksw_watch_off(void);
+void ksw_watch_show(void);
+void ksw_watch_fire(void);
 
 #endif /* _KSTACKWATCH_H */
diff --git a/mm/kstackwatch/watch.c b/mm/kstackwatch/watch.c
index c563f8d17829..8f3f6cb9f17a 100644
--- a/mm/kstackwatch/watch.c
+++ b/mm/kstackwatch/watch.c
@@ -116,7 +116,6 @@ int ksw_watch_on(u64 watch_addr, u64 watch_len)
 			ksw_watch_on_local_cpu(&watch_info);
 		} else {
 			call_single_data_t *csd = &per_cpu(watch_csd, cpu);
-
 			smp_call_function_single_async(cpu, csd);
 		}
 	}
@@ -158,3 +157,19 @@ void ksw_watch_exit(void)
 
 	pr_info("KSW: watch exited\n");
 }
+
+/* self debug function */
+void ksw_watch_show(void)
+{
+	pr_info("KSW: watch target bp_addr: 0x%llx len:%llu\n",
+		watch_info.addr, watch_info.len);
+}
+
+/* self debug function */
+void ksw_watch_fire(void)
+{
+	char *ptr = (char *)watch_info.addr;
+
+	pr_warn("KSW: watch triggered immediately\n");
+	*ptr = 0x42; // This should trigger immediately
+}
-- 
2.43.0


