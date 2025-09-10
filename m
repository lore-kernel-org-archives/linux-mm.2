Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67246CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 05:32:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7FBC8E0019; Wed, 10 Sep 2025 01:32:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29688E0001; Wed, 10 Sep 2025 01:32:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CB288E0019; Wed, 10 Sep 2025 01:32:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 790598E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:32:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12FC213BB14
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:23 +0000 (UTC)
X-FDA: 83872220166.21.1782EE4
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2BEBE4000C
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 05:32:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N7Wc06F2;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757482341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gaYg+/0/ozWnszVW1Vg9icfOKh+UQdPJqj98WeYrJSI=;
	b=tRmYZKZaHHN2OXt3B5GS+1wGYyp4qYe09OTutY3lUS686TRNwOtMpixyumtuNSZGjV9z4L
	VQzzQhjHmds7rWiGz1xbcfkBYwuCZMdKsaOaM9AYqssY9QVWqS844ZdEJfU0zQNPyAAfN3
	cb+zKidxsvhZSVqSSQN7/JQADGLk140=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757482341; a=rsa-sha256;
	cv=none;
	b=bAqjn8k9XAr2y0dhH4YUElOdijxWn9YIQdelX1eK54Vle5ksUA8YN5W5tSOK7NtxQt6s3+
	ShFmXOkmmpq9zcPb+vm2LaEbyVUcOt1ja02wBKhYzCTX4gRjh2x0FBnclKXu32THsb4ar8
	t1mkrKD26SfHIU3JEfFPvkBAqd3q2Qg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N7Wc06F2;
	spf=pass (imf12.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7741991159bso5978003b3a.0
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 22:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757482340; x=1758087140; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gaYg+/0/ozWnszVW1Vg9icfOKh+UQdPJqj98WeYrJSI=;
        b=N7Wc06F2AWhQHsZJ1Z9D20wLonxi6ND6kJ6UfWwfAzN9xEHlwxLn26LHQKejp3EG1a
         uZawqL6BLgZo1Na2wdzDRWuX+Zzdi5nj4I5AUBoYgk6HD4Fj2VW3g5LmHbtGDVm1G7TO
         8gxvj7QwSQEvHz49ReYEdvegxboO3bBhX78LPNoGqRKKL7SFdbjhPe+WZ5SOxrgqNk+C
         kBRtDva6VHN0xhsaQKa4pSt4qtyxn9/Gt+LAdYA2HQ6X4f/YjIiJiDfEwNI46O7h5u2F
         9s04C4GgojZDlJGbNfobXso4mOHr0lLLE58QtDBMXaHBclfUMqLzhE5a6LiAA0pRFEeM
         dBvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757482340; x=1758087140;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gaYg+/0/ozWnszVW1Vg9icfOKh+UQdPJqj98WeYrJSI=;
        b=eFNGqvWhw3Xlxwf656Ao3u8B8SMmFsWBg/04bm/eYJH5ZQJ4ezkNepZ/YWw1rjl8bl
         hKSyEI2ChZmOpHjRfBKVTCxK/6RJAAV3mEyUV0vhmgeU5ijxtFuUkVinsN3H3y4Ay7Il
         IzekQdKyTnHRgwVZcb7GDr1qh63i4C5lCFInVBIGM4Ras3xgwItCrEXYfp7nDShG9sW4
         8rtFuITLIcHZiwbL4pBd59XNJUbfWKizsdAqV9moFZqISrNqh6m/0/nDbmEMHM4mEROe
         hQ2D/v8X0ImRScV5O2LGsZcYSn5LtbZhoevSEh5kb6zwlyvsqKgR2M0FSd4jBF/kuB5K
         HdIQ==
X-Forwarded-Encrypted: i=1; AJvYcCWoPwMAgCbhSaZmbcDwRX9q6rGBlQGPwp0fmeSaJTYBgwUeymgBev+UIUU7ogC8b6a75BU+FZ5Vig==@kvack.org
X-Gm-Message-State: AOJu0YwCLgukT1ECKxsNIvtky4QwE1wCzh5Wv1CIk+2CoEkueqvlZYGq
	QIVuRMSrVEM6ZhVC++6ascP2LBEUZvFAzyYtdeVbCgjzA95RzfNtKU5o
X-Gm-Gg: ASbGncvT/c+Sig7Af8hAIntVKCYdUhYQMZiEaVjT+xSJuvjXVCE5pPSHiCME6GbH7Bq
	HtxNLJkImZugr3kMX6qghrruCuaKyoK+EJX1BVUvfFWutALIye26ZAislkGAb3gKMtMJytpDktr
	oeXcmSx/QYtHe1Kg2A6o4HUj/03xYIU2GDyLtj9VFIYJhb4gibGG6G5EWuLtMTSNf3VAgtK9p6u
	CrG83NoBgS/S4xaxiMoM6l6OUCI3JkITd7oyJHgOeQiA2jfYyRTSK9SgUS8XY/gdvJRUTlZMDXg
	Bk/cZlJZWNQ2N1rfxEwpj1lZjGJmfnIh2LjAxrqGM6c3iytHtMQnH0pL0WlBm6Ent7grCWUX/tm
	0LwIpv9SzRAcFdOyCQ0jyzdGnDItvlv/w7DTJK3BTz1KnK7VvVQ==
X-Google-Smtp-Source: AGHT+IHuUHMUgi5NSwlSeu8nV+hOLxDbRn5Z00T38ZbQ9cPN7nadv+zQOWHqDyDiQunbFQJUcaGXvQ==
X-Received: by 2002:a05:6a00:1a8f:b0:772:2850:783d with SMTP id d2e1a72fcca58-7742dedf06emr18816777b3a.22.1757482339803;
        Tue, 09 Sep 2025 22:32:19 -0700 (PDT)
Received: from localhost.localdomain ([45.8.220.62])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7746628ffbesm3870342b3a.66.2025.09.09.22.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Sep 2025 22:32:19 -0700 (PDT)
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
Subject: [PATCH v3 10/19] mm/ksw: resolve stack watch addr and len
Date: Wed, 10 Sep 2025 13:31:08 +0800
Message-ID: <20250910053147.1152253-2-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250910053147.1152253-1-wangjinchao600@gmail.com>
References: <20250910052335.1151048-1-wangjinchao600@gmail.com>
 <20250910053147.1152253-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2BEBE4000C
X-Stat-Signature: noxpnx9748eeqc4njepwrjwfujq96txu
X-Rspam-User: 
X-HE-Tag: 1757482340-501060
X-HE-Meta: U2FsdGVkX1/TxvfypBy17UfL8SQCEId//nkyQ+wdpy4GwaUzjVo2qdaRzoyVxP4EQg/deorurIrg9XFT3doZG1BSJBu0KjPAMngpBYR0FUVkN14Zg7im1aqMI7/lMaNWDkZIZWM3DGn0RDLpsS7SjTlg4C29ScdOzfqV3E9J7BzXkngToAbqTx8S1mBNoks5OBCE/R+l+/1mwymKyPGadhLYzTLn2WViqv06qTbj2F2wIwvctd641Jqd5+iMNQO7/Jl1BQMy/g6PDaPSYQsffZCerB3RlbnU3QlCCaZ86LI6CB6mwOWtBFt0Xv+I9uFIKKrtOH2RFxTccHqNz7z/yZFgNM3IiZSnJS6iTwmSYPBxCEmpbtD6l9a0E/IUPZnZ5YNP/LOD8Wtsk3R/rsnktZC80F+Fa/P0BxYF2oJjLClkltpovzeNPAx6tc5EobtYG0MhwBUHQo9oAx6OX+zuBKVCOAOHyTgm8NBdsroV9cfJbHdg5XBYVv2+pfbJuVO4Q81NTev/EKg/PRWEH7HnK69lHZNB4Wn0CSDbO0NEYRqyKJ9xR+g5hd50OCpN4k5i1DSSWet9cn+maw3dLvx91n7Y+6nRrpoLAMi4IW/AItSxkYA0pEPLGvIkELIJN7zI/wP0LEP+Vd+2vIXvaZdTo2jd9h/PLXfU01S9mWpETJ8hmIumw4lnMc88ALhGLIUBfDoPYXSPdGEeazrWdvDKcS7fF0WkXzGYFEnn8CHYQLHWSlWWwtuGy1z5UkHrVGoDOlPKVjEdkO6ToZSgvu04UgcGDTj1sPsEpQ6MB0RXdywLi987eGPL2+oAtNkKzFr1rJu1lckaMPYNDgLXf4Eq28fa8MZSbd8xQwk89defGGTSoWkpxtNoLiLGwKU/FwbnCVnAMOsvUp+HPaPEn4nWehI11b7HLyaT52G6jYx90SoPgTX0Wr2rZLqIFwHjAyVE2TLOWB+feUh2O1KTeyC
 WIT0xhw2
 KRdBgUYATXEEdWuH2RfDvqV3nIRoM45NT79fKH1axVGehXx0nuul7KPLtP9FFzeOBtipkQqlekHaV4jVo2eIhJuMQ/AWrfGbKURpZ5RTYPoZD4s4eHt/omlCgox8c2vQD7JyNoybQrBOzZvN84O+qo68BR7o8zqbD7UOeveKgR2OYd9UDiXjb6coHP5sPaP371RKogw73IhlnXtrrYex6pKeRoOS8MtudPO7+k598fBI07VXc9wNZDo4GOlln+TeUNw0TDPxZe7WchoAobrQb0fbIDVRekRKe9uF4SzdoyQAhXdAxoJCgLLVz9LiFM48fkLOwBnGe+o4KsIxyGXOh5TwbpUXexbmt9eMLT4PLzXZVBaCbDN9EqlX+7k9Rj/CpmO9ZSQR/YDr8+BzObNrNmr8Mi22mPpqLGcY0ej+Vf72h+Oeamj1EPfMS8l71Srpy0mNEum0k/qgBiw3I00DqF27C1I9BcX94jQr3uvQu3GS9lkVCBLbr22M0ok1fZL4u3qgUAnICsZesiaxRwO8S6bNpBzR/zOQ/5/DP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helpers to find the stack canary or a local variable addr and len
for the probed function based on ksw_get_config(). For canary search,
limits search to a fixed number of steps to avoid scanning the entire
stack. Validates that the computed address and length are within the
kernel stack.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 mm/kstackwatch/stack.c | 86 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 3 deletions(-)

diff --git a/mm/kstackwatch/stack.c b/mm/kstackwatch/stack.c
index 72409156458f..3ea0f9de698e 100644
--- a/mm/kstackwatch/stack.c
+++ b/mm/kstackwatch/stack.c
@@ -13,14 +13,94 @@ static struct kprobe entry_probe;
 static struct fprobe exit_probe;
 #define INVALID_PID -1
 static atomic_t ksw_stack_pid = ATOMIC_INIT(INVALID_PID);
+#define MAX_CANARY_SEARCH_STEPS 128
+
+static unsigned long ksw_find_stack_canary_addr(struct pt_regs *regs)
+{
+	unsigned long *stack_ptr, *stack_end, *stack_base;
+	unsigned long expected_canary;
+	unsigned int i;
+
+	stack_ptr = (unsigned long *)kernel_stack_pointer(regs);
+
+	stack_base = (unsigned long *)(current->stack);
+
+	// TODO: limit it to the current frame
+	stack_end = (unsigned long *)((char *)current->stack + THREAD_SIZE);
+
+	expected_canary = current->stack_canary;
+
+	if (stack_ptr < stack_base || stack_ptr >= stack_end) {
+		pr_err("Stack pointer 0x%lx out of bounds [0x%lx, 0x%lx)\n",
+		       (unsigned long)stack_ptr, (unsigned long)stack_base,
+		       (unsigned long)stack_end);
+		return 0;
+	}
+
+	for (i = 0; i < MAX_CANARY_SEARCH_STEPS; i++) {
+		if (&stack_ptr[i] >= stack_end)
+			break;
+
+		if (stack_ptr[i] == expected_canary) {
+			pr_debug("canary found i:%d 0x%lx\n", i,
+				 (unsigned long)&stack_ptr[i]);
+			return (unsigned long)&stack_ptr[i];
+		}
+	}
+
+	pr_debug("canary not found in first %d steps\n",
+		 MAX_CANARY_SEARCH_STEPS);
+	return 0;
+}
+
+static int ksw_stack_validate_addr(unsigned long addr, size_t size)
+{
+	unsigned long stack_start, stack_end;
+
+	if (!addr || !size)
+		return -EINVAL;
+
+	stack_start = (unsigned long)current->stack;
+	stack_end = stack_start + THREAD_SIZE;
+
+	if (addr < stack_start || (addr + size) > stack_end)
+		return -ERANGE;
+
+	return 0;
+}
 
 static int ksw_stack_prepare_watch(struct pt_regs *regs,
 				   const struct ksw_config *config,
 				   u64 *watch_addr, u64 *watch_len)
 {
-	/* implement logic will be added in following patches */
-	*watch_addr = 0;
-	*watch_len = 0;
+	u64 addr;
+	u64 len;
+
+	/* Resolve addresses for all active watches */
+	switch (ksw_get_config()->type) {
+	case WATCH_CANARY:
+		addr = ksw_find_stack_canary_addr(regs);
+		len = sizeof(unsigned long);
+		break;
+
+	case WATCH_LOCAL_VAR:
+		addr = kernel_stack_pointer(regs) +
+		       ksw_get_config()->local_var_offset;
+		len = ksw_get_config()->local_var_len;
+		break;
+
+	default:
+		pr_err("Unknown watch type %d\n", ksw_get_config()->type);
+		return -EINVAL;
+	}
+
+	if (ksw_stack_validate_addr(addr, len)) {
+		pr_err("invalid stack addr:0x%llx len :%llu\n", addr, len);
+		return -EINVAL;
+	}
+
+	*watch_addr = addr;
+	*watch_len = len;
 	return 0;
 }
 
-- 
2.43.0


