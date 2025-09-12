Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2288ACAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:12:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B7F88E0028; Fri, 12 Sep 2025 06:12:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FFC8E0005; Fri, 12 Sep 2025 06:12:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657C48E0028; Fri, 12 Sep 2025 06:12:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5331E8E0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:12:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23986C07BA
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:49 +0000 (UTC)
X-FDA: 83880184458.12.A5E0688
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3CF994000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:12:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jB3+ZEcE;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757671967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EqhfZKpOZ5vr6/4baQpnpDghHsngjObwVAr7pMjTC1U=;
	b=lmyzzL7St11X9S95C6PrLfFPMtQePZsJLlz6MrCdNaib49iFv+b8uET/kh52MoRDsiX0ki
	LKVE/clIXTCEQMU+57YrZnBx8sCkzV2k6cZLUxX+Ulue8UjMTd78IfE51d2XuCFq5E5zhJ
	IKk2ytpEfylxCcC8CqZhtWc2g9UJRfs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757671967; a=rsa-sha256;
	cv=none;
	b=0eroya0sI7x38KShzTUyTFRuzv4LYCMi2AP+LwubKjlc1hOyHqG/Rm69MJj7jTolyoXHtk
	SPsY5gt7NHj18wo/OaFJbLF9rAJZfN6iQ6aHp0LmY+NFHVGEJRN0Rofui98gbHdrNpZvnM
	O9FZ7ISShn1Gd3xjzdV3X7tH1tEKRAA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jB3+ZEcE;
	spf=pass (imf04.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-24c8ef94e5dso13709015ad.1
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757671966; x=1758276766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EqhfZKpOZ5vr6/4baQpnpDghHsngjObwVAr7pMjTC1U=;
        b=jB3+ZEcEf7DqfknJ0aSIUBUtpw2SrEqJBMh0Mi+GrkkBDWZRLQlU/dm0T/DEB5hro/
         8t1laWYcSYMERCgpoIAfnARU8Shm+woabAoob4ZwVNdnjjeRuAAId7Lz96a95EFX+Oun
         TG3dEOBdw3q1zKa7glv4SQ26xL4ECU49ffIO351QNGWyN23fs2WoCF+WSh5SAFvnNVgM
         TINCKEQebAVzeZgcPOcrJKauc0Z9EA3u6DV4I8Kbfd0uA7tHBttkMzZs99Ty2XPZ0RQK
         CCgzu8LXJDbVMg3ZamQtw9ImOdFEDmvuqDMjGSGn7ERoKd1CU/paGIWXKCI9hv/HcwoB
         4ccw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757671966; x=1758276766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EqhfZKpOZ5vr6/4baQpnpDghHsngjObwVAr7pMjTC1U=;
        b=A9MY2U5upHOOwHQ2dtqmQzdnIKj1qhgzgc6PYuAnfCBSrS14tOGB9/0dSW7RxGmjNB
         KZxE83Vur71SYFeLSpaW/DvoChLvC+grPznPBo6+fkbQRM4bRyTvofoWhGW0/BJWRYcc
         0GaSCwgKFtO2TKNfOPM1a5Dc6Vpx8iNq+PFPlG8ddssUqV4lYYfnvxFw9E7tTtEji8lO
         QYspXaBW3zGyAIV2ya1LAo64ukMSHhjxx2ybtPFOu37++c9UsltY3wQdc85TSYohAhoM
         nTQnaacAMJMWuNSOW9PrUyF5pgmrht2Iu6BtcRDMkvqjz+zYJIMvFY+ltX87rHbJhIN6
         qXXA==
X-Forwarded-Encrypted: i=1; AJvYcCXaRSJZ4Vjv1Po7YFs09YgzEgon+4ykfDQt0Jkc4dR2ITKmFiCoptUW+1zo+8BGt1jOhRfEIwmchA==@kvack.org
X-Gm-Message-State: AOJu0YwRJ+cPodJxT9H+eJoggrqkBjg2bYN7t1MtcNrODbOpSiaYyhAc
	NdtarMgTFGJfe0YvWSHfaJJ4ocnTSUCBckAdLKfNqNuqnqVAdBU7j9zt
X-Gm-Gg: ASbGncsMn6g0W0xV9PB4K/TBpCVus48vkGR7CbIZjnqa4ipwTbCJ5tXF72bRKEgbWO9
	Gm1ySvsIJ7AEZ+OCgPZl5DdrlCo0C5tSSVw2e9DxhenZfEvm4WNZzeicJJUSumztITowS+t6zdx
	9kpM2+LVEx4IvrpwTnEWwsSEa3QxEctWVbNx1PPGOIebYdYvXCtfASPdPVkPUmkcn/pcl3yNShJ
	Nf83NsgqUDftJB6J0s8Ct61BgoSO1JiaVRk1ohRPj0dSN+d4Cq+d6KKA9WtAeMDhC+pwAY6alHR
	fx8gO3rScrBjdIif6bsFzp1Gn2iEvhIOxWeKP/jwfpPICiWU0N5koOm4SjZt3aKBINTn+dvmRqb
	lA9ksEOtRwuXe9AjQQ7GeyDpucsNJpRJ5iwkahWA=
X-Google-Smtp-Source: AGHT+IHYvhVuQu3JkB4HjuaPSs4+WBMwwDAkSMFdp4aHblSEvg/m0jfxMexK7gmtMSLEueohiSNhCQ==
X-Received: by 2002:a17:902:e5c5:b0:253:65e4:205f with SMTP id d9443c01a7336-25bab92cc8fmr79198095ad.3.1757671965944;
        Fri, 12 Sep 2025 03:12:45 -0700 (PDT)
Received: from localhost ([185.49.34.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54a3aa1c54sm4273352a12.50.2025.09.12.03.12.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:12:45 -0700 (PDT)
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
Subject: [PATCH v4 10/21] sched: add per-task KStackWatch context
Date: Fri, 12 Sep 2025 18:11:20 +0800
Message-ID: <20250912101145.465708-11-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912101145.465708-1-wangjinchao600@gmail.com>
References: <20250912101145.465708-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3CF994000E
X-Stat-Signature: uokwzuqyhx85nyj17qqpp3ohmszncxx9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757671967-893155
X-HE-Meta: U2FsdGVkX19iHXQyz0jYY3UMArne4Q6opEs6E6izolz3DjkI25FglEGs1EoG9jIaT1maaUZtFZPK4MVxBxHTqI6qlnrMFYN55FE+xM0Ucp2n0pOAJ0hxX2f6YG49fUKxiEW0s9hdI0dcZjpZ3Tf8EZUVSnzvxddu4A137x3+f5Ty3+gCnPhG2EsSLxFOwqKsbSTAp8AQIK0eGVwIlTB27s42juyoWNgBV4fGmWtI6WD6XO9mLh2AYxnB96oZAYufo7EyxZe8Pk4J2sa5s56TVlVhjbgKdZRTUfayOUJxMsT4070VA4Lp7obKz96u0Aya6xjc/TqAruvtgZfbgz00VMqYxNJgXd2QIa6ClGcuuF0oOLOCV7MGAzeacVmgbWxRdxVJ9Na9N2TXFAgsns9Xuscraznejr/9u4eIOV4jnwZFXfyXmiM/xPaWnRRmsPWbACK7PMEwAKyDiwk7VuodMKiRghzSI5tea6aDN9W41CcT0Irr6ccmozrR5i0hVO4fDD5rAI2fsmLAwj6GCXC/yXqHsxIRMUhk4sYo9zytESh5IMx0+q1Lsv4qbUjQAaLc8zwl4sfWtZytpHmQSuc1X2Sti6mN+YhSAyrelJEo9XGM4WOcxChX9Ij5PZLK6/6yVsT283S0/j5zsvccd3oJaemECbAJH7vMdEZ7XlS8M81hxI/omroVLQDQaQU3D2a5xpHyWkuxOuGD9nFtzVSnXGNCcv+DH+t4I/Qf4Wb0kREoJFx0v5pnTdK80qf6pznKSy8Hu7gDvEzgnR4ateiQvndM5ZT57HCL5lJ98oINDUM78I3JPg/UEyLgWP4WbsUTpmYXfXFY9YtQq0bCvQNlLTAxYVccHLwpvjEMOoPC/NC9UwzgtqlwBee25MVGXosZEBUj2z4OeeGukdYd/BWBREY3fu38QjmzlcOZw1a8PAHXz3IoqzJ8FEUgtxk0JGcvbrxGyJ1J+3jZ/IvN4bQ
 NnCAVrNa
 1z96RP/EflIv0m0flWvhZyd0hmKVm5MIbM29PN4BKJhcWH2flWwOXXAXEdDr6JEf9leFHRLp9GLWqHSZAfQhEM+1z1IE9YAFuKVt9JCbS4B3Cj/6Miky4jvORdEQPmQNGVvzO3rR6wCTURs6Y4LdNQads/lhmHnbhkKgUEwvFhNi1vHOXiG7O6Mct28rjbPpxoGb1LcJERCoync/okr/7k4nbGaj9ZYxHd2xiE3Qdft/dLf35qPl33OE0lWi/ogZQ/TdADKU98k7KO046df1RhlaVAUYRDNtxQnr2/tUDfV5nIELt4QalHHif8jKlGfm/44vojUbSDFhsgN7lZ5qn7sho0EAx5zxh1JEtcU/9TsiSs+japz8Q+HoXftmLC7tgcrWE5hhNm5MPkER0/dVqvaEtFsZvmNvSts2nqFFdcDJ/8ypJ0UZNS2iIhLbV+zt6sw5o2xi0/ww5ZFm0r0t0rpe82T+ipJ1FRzLCkR5C6fXBsfteqnB+V/Sfih3ekpdG8gjHhd6YTLqDAVeLiYn6+ljNDOPBQr4Nkby1O0PB5BTMuOEIB4bnekegVUgQIaqYSAt5+bVb9gqyXmDv5rKDNzmJzpJRWI8JoxBx7jZceXD/1QbQSyGMdHXZ08NbDljhi6LC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce struct kstackwatch_ctx to enable lockless per-task state
tracking.  This is required because KStackWatch operates in NMI context
(via kprobe handler) where traditional locking is unsafe.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 include/linux/kstackwatch_types.h | 13 +++++++++++++
 include/linux/sched.h             |  5 +++++
 2 files changed, 18 insertions(+)
 create mode 100644 include/linux/kstackwatch_types.h

diff --git a/include/linux/kstackwatch_types.h b/include/linux/kstackwatch_types.h
new file mode 100644
index 000000000000..93855fcc7981
--- /dev/null
+++ b/include/linux/kstackwatch_types.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KSTACK_WATCH_TYPES_H
+#define _LINUX_KSTACK_WATCH_TYPES_H
+#include <linux/types.h>
+
+struct kstackwatch_ctx {
+	ulong watch_addr;
+	u16 watch_len;
+	u16 depth;
+	bool watch_on;
+};
+
+#endif /* _LINUX_KSTACK_WATCH_TYPES_H */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f8188b833350..1b324b458309 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -22,6 +22,7 @@
 #include <linux/sem_types.h>
 #include <linux/shm.h>
 #include <linux/kmsan_types.h>
+#include <linux/kstackwatch_types.h>
 #include <linux/mutex_types.h>
 #include <linux/plist_types.h>
 #include <linux/hrtimer_types.h>
@@ -1481,6 +1482,10 @@ struct task_struct {
 	struct kmsan_ctx		kmsan_ctx;
 #endif
 
+#if IS_ENABLED(CONFIG_KSTACK_WATCH)
+	struct kstackwatch_ctx		kstackwatch_ctx;
+#endif
+
 #if IS_ENABLED(CONFIG_KUNIT)
 	struct kunit			*kunit_test;
 #endif
-- 
2.43.0


