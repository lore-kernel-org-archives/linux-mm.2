Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909C6C4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 18:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532846B00EB; Tue, 14 Jul 2026 14:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50A206B00ED; Tue, 14 Jul 2026 14:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 420576B00EE; Tue, 14 Jul 2026 14:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 148DF6B00EB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:32:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 866591A049C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:32:01 +0000 (UTC)
X-FDA: 84988226442.22.2B26D53
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7786100002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:31:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Aw64Ictf;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784053919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwQ36ycy2027O2OnXTT+jaKQ0lX0IY/IjFba+f+HbbQ=;
	b=Mi6htlGLYOMbJQVbQY7+QivAmb54KDIQeMK8VfrgFsvIru6fvdi7qfmm3WdwUizWqFmLaS
	AH0yneMqaRsjnay71Zz/lvFLvgfpAaMM/AK35iDhevhDQrkDDp2OAgo49pGYO4AkgxVAbu
	vCrrARavpGfiUodEnlSWEEg5VssjE5k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Aw64Ictf;
	spf=pass (imf14.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784053919;
	b=OpqvEqsqaUEn+4dDquLTgtc5de+XWR5tF9uIJhmqrbVebnwrh8ScNt8LznQLfBGz4OnbV+
	qr9hQD7C+OL81aP8eLgXBi/CS0sXQl9ovbIVtTo9cJvlorU5AWGe2388cm917iHYEcdBRt
	1AjICJ+SYTnoOkeEVcUF1C5FoLGk+kI=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so10075856d6.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784053919; x=1784658719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KwQ36ycy2027O2OnXTT+jaKQ0lX0IY/IjFba+f+HbbQ=;
        b=Aw64IctfKRePC5wGM6FxGDv3BgXtvi2LxZNqccxgSyKMXwX3L4XfBuJ2REXJwl9hSb
         kysKngXBYtgHrQfq2c119eiK55lvo0piuUK5sp/M6PcoQ1toTJPgqnkqsvntDs+E3qdb
         fFtDLdapIclarpXUKjelhyLoFTnyRYvc80ZXLFn/Lxj75LfXOvw3XwOZFYnep6GdjG4r
         lQJo77PfDZmb8tLB7XLtxcW1Np9AnuF09DrCgAyirit7u5CpuW84zBef5Sv51QpJH5GO
         kDFquOH07bgdy91QIm7znfXJ1AvZ+LmnQfJLY0kH2/1kHNCkDkJjPqlqO8XtHkoV7sxY
         Kk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784053919; x=1784658719;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KwQ36ycy2027O2OnXTT+jaKQ0lX0IY/IjFba+f+HbbQ=;
        b=bEOApx0xo6QrAlvLumj3yTqD2c+YY/Y+l/6vNmqebApLw/80qM8zGJQH/P1ZbCgtXv
         gO8CQw7O+J5Yfsuqmi2eclr3BZsRqO63x6TBRAmM+iqE2FHzuK28RJRK0/yozRuL/f8S
         7u6bjHuiiGdqpy7pUH709Sc6LPgl+CMVUSO9/JfaWKT6BusWOYkb+tkkusdDXfvzG/jg
         YvF0iZyDDL+GHUduaozXh4miIM0Uln60Eywy49TwaT8+jh1FzzSwGEqfbrAjgHrKNmnP
         okGouq29Fvjk9iuY7wNCKMi5O1fiXG5QWo86eHkbnnvwXK/1RM5xA1aNWqway1KrqUjU
         D1+g==
X-Forwarded-Encrypted: i=1; AHgh+Rp/VyfL76eSix02R0wchWRFSxvsPEgsDP/XFnhssHcn+g+G8c5XPwHxrJyJNxwMKPTPm2YSeA4KMQ==@kvack.org
X-Gm-Message-State: AOJu0YwamunNap+WJxXao0qA/OCtiSA1Wv7+94CKDCTG17+Sf2z6N5MA
	4H5j5IpR677TRHddL4ry/E2XVPtWpGFV8HDYKH0PrxpBk6ZVf4Us8fmn
X-Gm-Gg: AfdE7cmbH8oV3yWEp7jxgGektG53S8rLN22kF4bq4mVdEUlFigIZpmkWKzk5O9OUqC2
	C5OPQG6o0DcCApN35srLyD7VmbBKc0PzxrVSUjKAEjhUBbwINNpAk3U/kQ6pZkLB2HW5yE846nd
	cf/v7tbxuui+ySchgA5Z+Xz4kpenbObbYi8ph5VN0sKtz2QFUTUdYU8uFX7N/25onJtTcP2DX06
	tQn8wC1qJUjG04sabfx2/ubOyc1r+fDOm93AcH5K8LFs/sNODjRGpezu+3ZtdEhApJcA20mfaPd
	QRhs6Pbej1y/9CfofzceLEFLPdPnQuxVWSjpmh7Nyxm4tOuNpIIXt5WNm4dx4rjfFpZ4kZNRgFI
	4pK3rm2A7yNqJUEvEyBAMjixHW9Mah/Z3BftYll496JsIieDRl48Pn0Utp6JSLmdneV39HT0yf9
	lXk6MndedXWBcfk/wLWvNqOFQItjblnuytJdht8MhVufDmGtxVeQMmDumYHB4gkw==
X-Received: by 2002:a05:6214:3d0f:b0:8cc:ea7f:d3c8 with SMTP id 6a1803df08f44-90401578bbbmr161798496d6.30.1784053918640;
        Tue, 14 Jul 2026 11:31:58 -0700 (PDT)
Received: from localhost ([48.45.163.146])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd87cacb8sm178386286d6.49.2026.07.14.11.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jul 2026 11:31:58 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Matthew Wilcox <willy@infradead.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [RFC PATCH 07/13] stacktrace: export stack_trace_save_regs()
Date: Wed, 15 Jul 2026 02:31:46 +0800
Message-ID: <20260714183146.12598-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714182243.10687-1-wangjinchao600@gmail.com>
References: <20260714182243.10687-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: muwd3kpq36z3diwkp1ny61mx9cqtrz4b
X-Rspamd-Queue-Id: B7786100002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784053919-171817
X-HE-Meta: U2FsdGVkX19kmDXQygbaohbYGePUA1KlQ0LGPQBOtGOjSQ0XuqmoXJRrzYSz1fv5Y0NPLTIenB6s99sXmcw5KZKEEJc5bgu/e10RZBfnkZg+Ut+AcF3SsuFvKEOFt7tUEOsSBkrJ5AJenl+rxy2A4D1SsPKC3DYs71F/8J0NsbL0fvbY0m/9Yl/3UNTCTVa8kCHfO90Hn+WCtucGs8UpSuLcYoAEVrqSEngNg8FiuvHb+NE4lGyD0n1tDGj1xVZR0oDLkfVpIFkNcmHNFE9+PSpbKDhInyk37E8m5unKGh1XlLILdKuyBsNmJ23q5KQyusm1rH1M6kSM/of8K6CptFPncz4I4ExyW3v5apanmvP++ucWqQMEa4ZTPUVbBKg50HfdQcQxJoh17xSyEpqp7bGZOEzBCKN3sXLsi/dJEIvU1QlrAH+HXTOIOk9jPjd18D8EhiQ716z0Zdbuyt1XmkfLXZttV53cVYhPFmvhkRfowhAu21cNvkxDxQufe3vU4PIoukT23r0s1xjOtjtqHN4RPInt3pwadk5Pjc+ZlvwJGnVqZ9pbwSly1+VWZl6+hWkzPAQUtBLpum764gT0Jl7B/92jjEClInn8wwfkRZITFzDhR8XZK2Pp98+5uI/XsqiFMV8ulSOK1+abB5Vrql2bkreyYP1TFAODLwnKPgkNN6ng43WcSBu7o6Q2c0a7IQSF5heF0eT3Fia+Qz1tnmCB/FPJQjec2gxTLdi0YdFSRAqXYE7wTZatzOrYdp8INMVsGtrUJMPSPlKko622z33VoS3VbuueW4kS8+zvCbioKKDUWJA61MRvfl9Bc9pleCPx97mCVnS4P73mx9/BhCRz3FVnTYZgbIFxrTwms95YfPjbmGL2GITKbOxFu1IZPj6iY7Mc3XwvH/t1FP9ogrJKNju6FdNYFn+I6j6x/3v988OuxTRr396JEiEjPqV7ZZW2feEr6GYvXmOth29
 mAQ+qfch
 8OwznZ1rfookloPXWyOoRhRGLlDsI4lKQcB5rmnq0YUNtoTqNgVYbWuNWBqug+tQrlAW0hIgDJ9vMzP1nUSaUPgXJ4XK1XYJtxCRFD1YRSoQJpKLUUQFdtD24yD4Lx1dkKGEhXXw5oTOK1KzKiMTQfoFT6WyMycYgRPEmj5JBe9Ugc09mIe11Qqa6au1ZKJhqvM3a4NpINp+gcwC63rgWnqVQxJvO5kphhiSdgAahgvrhQMnMCVdFdURwf9yG+O3m4auirGkkzkLzttSVtAxL6NOy6guu5V5X/DlHdJ3L3hFvFIHkE59vAPwJnIiEO63QksH4NwBqRj469xwUM2cerEsfQr9jQLo2xeyZ2in91oTA16xWkedo2guf5Gg1pcwpitDSTqRQVvOQY81tSRWM2QGd14WzLjmKe3xZbbYbG8FLosZnZL23d9XrYzYvJcN9X6rF70J9dM5VritFgi2X4+lrB3jYTxZEAtWEIbhO5OjO8HFBmTeM6UhLf4VHCiVBfliwbdwBX/wI76LfSJqBq3LzWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The other stack_trace_save_*() flavours are exported, but the regs
variant is not, so no module can capture a stack trace for a given
pt_regs. KWatch, which may be built as a module, uses it to record
who wrote to a watched address from the hardware breakpoint handler.
Export it like its siblings.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 kernel/stacktrace.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index afb3c116da91..d853c40f916b 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -175,6 +175,7 @@ unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
 	arch_stack_walk(consume_entry, &c, current, regs);
 	return c.len;
 }
+EXPORT_SYMBOL_GPL(stack_trace_save_regs);
 
 #ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
 /**
@@ -325,6 +326,7 @@ unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
 	save_stack_trace_regs(regs, &trace);
 	return trace.nr_entries;
 }
+EXPORT_SYMBOL_GPL(stack_trace_save_regs);
 
 #ifdef CONFIG_HAVE_RELIABLE_STACKTRACE
 /**
-- 
2.53.0


