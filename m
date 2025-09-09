Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27E4BCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 23:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4537C8E0005; Tue,  9 Sep 2025 19:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DB108E0001; Tue,  9 Sep 2025 19:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAA58E0005; Tue,  9 Sep 2025 19:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1BAA98E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 19:34:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DAAAF1406E7
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:20 +0000 (UTC)
X-FDA: 83871317880.29.67ECE39
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 147B016000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 23:34:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8zdWi01;
	spf=pass (imf08.hostedemail.com: domain of 3ebnAaAYKCDwqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ebnAaAYKCDwqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757460859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K6OH97ZpoRzs/QnK0sVtwK1+CTMH7EfEmnF9tlYLf0g=;
	b=6UoH1NkAi2Gpa3y43v/HZytkvQbkPzXTzoKcH0QkD/nE0YzKZUbW3Ssm/cpCN9rqxQfXcd
	LERUpYLEpTIP2tI+SXCXfzPRcm77jcjUJjRyU6qs/ecBUPdkOqzXmqeHOwc7k3814Ipx0Q
	g+S54LlGH+C6tJx0qwAZk3+a6ObGRi0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=R8zdWi01;
	spf=pass (imf08.hostedemail.com: domain of 3ebnAaAYKCDwqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3ebnAaAYKCDwqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757460859; a=rsa-sha256;
	cv=none;
	b=7qfsGI7pCwa60yBr7Kf8Mb4N9ev76H3UDpL5u4SALq1Qk6Hqfk7+UMIYnp+LAmTsJcKyHA
	cl5NTDuq0kNBsuHnVe53psSk33rxzXITHBhjJ41ywj3G+n25pZgbcwjhVVxSFvSzw4v65b
	dk2gPwgG6bKFMmzuYFFNrtzrylDJ9iA=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-76e2ea9366aso6658201b3a.2
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 16:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757460858; x=1758065658; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K6OH97ZpoRzs/QnK0sVtwK1+CTMH7EfEmnF9tlYLf0g=;
        b=R8zdWi010nmdl8GRxZuYpMgjKD71fFKqep4UejOAJm5eR3Fu17jXWSmjL8jrzgrXyV
         ySoDj8nnKMgGDMUi9OCpaYCKY6ditBtTY7qizVHbtsTLNBkxcouL5oHRYOdtOvzAzI5s
         gjw7mYJ76ZoIj+1tvYuUooxJNvfYHIVqtQzSE4mpLs4Lo7IN/Fnq/tyEcjuJVFaJJVOF
         tf0G3j/kEA2SWmbxe2IIZsjbyBNRdS5deo/18C+GbHNv99boah0noXoIhW+EVCr/KeEu
         Z4FYXaTU6Gi5e2Bj+jourx7e1CRQ2EnpN4c70GoJC4n/v6h/msjndLImlWliUsfPbUfu
         oHKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757460858; x=1758065658;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K6OH97ZpoRzs/QnK0sVtwK1+CTMH7EfEmnF9tlYLf0g=;
        b=EIq44ZEzYJjhdu3jAQZ99T8epX2YqIYbD7Qzaw76AZQuAsNXO1P7JvUkoM32JfgHno
         8CpFvJswJ9BEPGmdDm7xXaUZbJe4iBjcIHoi9njdng8XVvyHOrF9ywK0h6IUUCkFW50Y
         n4epjnkF7vl/GWp1sa6afeuLJf/Wu1neRKGVFoZmG7JbFSf6movG3ew1ts3vdm7rJeig
         JPEIXqnHHmYBcT38QPEBwkC1qK6x2p3/XDRVWCqAyQ4Q45q+/8Nk34YgN3ULtsQVffBA
         /KJAQjjE/+sIvqHyFtdVi9neFc6AeR9/I2a7tsX1rVrz7oZLFRuE7VBu3OhwPB922dfx
         XRjg==
X-Forwarded-Encrypted: i=1; AJvYcCX3kOo20WSbia2LElk6SGbXUpH2/4coLS+YVdcjEL19g5QVqGXwmJSKWV7Fh6FPjjsGcTKUylo7pw==@kvack.org
X-Gm-Message-State: AOJu0YxFAP5ZTYwfk4oeqHA9V57zmpTs5saNcHECulOchuEDWtdWxyrh
	EhNKEJxn+DpZkEbLop1xB3IC1E5I3/fUL7hDfypS2c1O8tLJZjBQt/xu7YPA1e/hBamG+UUZQQm
	tLp4xGg==
X-Google-Smtp-Source: AGHT+IFIst4jd2D334Y2PkPuCO/Ean4Ij3IT9elqE1huVfZrndSK+83KyXPa67AggUAs4pMR4FIui+Zixgs=
X-Received: from pfmm1.prod.google.com ([2002:a05:6a00:2481:b0:746:3244:f1e6])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:3e14:b0:771:d7b0:6944
 with SMTP id d2e1a72fcca58-7742dca536dmr15166038b3a.3.1757460857845; Tue, 09
 Sep 2025 16:34:17 -0700 (PDT)
Date: Tue,  9 Sep 2025 16:34:08 -0700
In-Reply-To: <20250909233409.1013367-1-surenb@google.com>
Mime-Version: 1.0
References: <20250909233409.1013367-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250909233409.1013367-3-surenb@google.com>
Subject: [PATCH 2/3] alloc_tag: prevent enabling memory profiling if it was
 shut down
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: kent.overstreet@linux.dev, vbabka@suse.cz, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	usamaarif642@gmail.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pasha.tatashin@soleen.com, souravpanda@google.com, surenb@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 147B016000B
X-Rspamd-Server: rspam05
X-Stat-Signature: 8bmzmqpfnj96mogqu4u7sqqminby8gwk
X-Rspam-User: 
X-HE-Tag: 1757460858-255885
X-HE-Meta: U2FsdGVkX1+i0f78olfedJHYFgwdfnkVMJdA+jXDOs0mA6NkkR7hVsYAUQwSddlkI+0wRQT1hhY+l23IE14huQMwwbwhXC6xwpCYsxae4NYC+J2nHI9rkD9uW1dnXkKsWQMGTHKbgwaIfdc1YdqKcqul5feuCCjvah+h1g1yMunxfEYxXepdObIP6bvJ2hDJQTkVlrk3Jfumfx2Dogs9I6a2CrPcVfTy0bYZ2XQhk715jorYhLbP9vqhnX1nc2yzqxHuYK7MPnrJbfvKq5F/1VXejp1Tow+sk3+CohnSPwR1AKpqSJd36ZSNnDgPjvPotmybLJwvOZd80XY1o5RBP6/hHZ3w8Ki+O4KgPc9oMjGxCQIsSroOMHuKj6XFiRxlUpqAtYLr6AesESrLWxZIMZSbcmR1PFmbFajPWv6IK8DXlDHb2sTQVRUBqip2Hh7evKFt2pen5+z4WR5Ldz8F1phmsszoqi6iLkkirekgQuWGf/KHGgcvxvi9atSvb5NbPD/rxO97+dH8io+ebtxoo7Bs6wqhxnWNK6E+fCfCCjGssA/vV7o91xhWdSTfb1dXu8s7PNe+x57oxnIf/1bHk00DtXqXcAgW84cL/QduXfy5AM1GjpDFY+B7dZ+Rc1PIwGA8XtYc9WzeK3vvS+rCJmkJH9/VRzMlh6kz2BpozYzYngwnLlEWECdjmZMkOQzCaabv/wY3cfhe0u/mJXfI+W7uf90IBvSbO/UV2ytBG3YILQNav/brpWzDjD0FjHqE5JOa9jDZKh5/Of2CcPvur34mwXFvZisPZXyS0T9ANXAqzyL2QMIynhxAmt+ZO+k6bFHhuonJTGW6bTKwtJ9ijiabe37Lq8cf0qnoIfpfAiXk5qIinl6ie8x5tRJxSXuhFHBJDo+f9qF2XnRIT5qZrYCN0Uf3+XO3xV6oLvmj0mWOkzPPLu87Rdbl9oIFL/w6Z4EEpbvLqw9bZHAhPpy
 VTLA0Gmr
 TOTJJRt/g/yHxOF+gPcrZvGL3mggKItZ6XafTHbY4EhglJZL7VUY4QCSozoytlkwsQxI4+jpeYBg/vDOji/rYORbOmKxW/wNvmccIk3p+preGF3iu5BTMieiWddtnDekuPpJgVVPoHWsVJU7LUorcIzIdAdM4F2MRBKSu+k89xe9H5tICgLifQ2Bi2arYcNvb1bTLTJ+eAt6pUzv+z2+h0U/IR+5HnmCklCb5jKmKK49jh6jvXuWuBK/psolIlbXWlzCHNUYY6SnMolPXyQ2n6a/a3AA8pmHlYRY6cqK0Iu8lQdPnu3squeBBiLJ7X140mH/Su09chC+rJ/6uEYkZtlEtrnYp6QdGfuCngsy+AGc1GE+6ldMw44BCfOYm9aFqbp0rSlG/YO/zvJoXveoZ79BB6SuMZXfb3ebQGkpuNp0yOBbARMXlU5iMYO5NFe8gyRY3ioQ8i8KIusqd88n3c3oWXCR7/epQ/0Uyp17nY7+hSi8VDNOh1TfbXjoNNyoIgimZgiFx59h+OK7fHyclam72+FYQYAaMzgF0Bne7oX3iyu+0CrQWCDwQ+t4uEqz5A90G/44gr/Kx/GHFKS+OdIfxZQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory profiling can be shut down due to reasons like a failure during
initialization. When this happens, the user should not be able to
re-enable it. Current sysctrl interface does not handle this properly
and will allow re-enabling memory profiling. Fix this by checking for
this condition during sysctrl write operation.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 lib/alloc_tag.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 95688c4cba7a..79891528e7b6 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -767,6 +767,16 @@ struct page_ext_operations page_alloc_tagging_ops = {
 EXPORT_SYMBOL(page_alloc_tagging_ops);
 
 #ifdef CONFIG_SYSCTL
+static int proc_mem_profiling_handler(const struct ctl_table *table, int write,
+				      void *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (!mem_profiling_support && write)
+		return -EINVAL;
+
+	return proc_do_static_key(table, write, buffer, lenp, ppos);
+}
+
+
 static struct ctl_table memory_allocation_profiling_sysctls[] = {
 	{
 		.procname	= "mem_profiling",
@@ -776,7 +786,7 @@ static struct ctl_table memory_allocation_profiling_sysctls[] = {
 #else
 		.mode		= 0644,
 #endif
-		.proc_handler	= proc_do_static_key,
+		.proc_handler	= proc_mem_profiling_handler,
 	},
 };
 
-- 
2.51.0.384.g4c02a37b29-goog


