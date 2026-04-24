Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9C24FED3F2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 19:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6047A6B0095; Fri, 24 Apr 2026 15:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58E006B0096; Fri, 24 Apr 2026 15:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36C276B0098; Fri, 24 Apr 2026 15:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 21DE56B0095
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:16:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE170402D5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:52 +0000 (UTC)
X-FDA: 84694406664.12.4C075B2
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1066BC0002
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 19:16:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qplvlt7R;
	spf=pass (imf10.hostedemail.com: domain of 3ocHraQgKCCoYZKbKTYJMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ocHraQgKCCoYZKbKTYJMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777058211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uhV9bgboNhnyawRNXgnugsEye6zSCci68cPGbUTJPQs=;
	b=OoLRqO3F6c1eDJKJyCAby+V88lqaTi1mZIBxBNy35Hs6Xq6/IMgeHCnW17UO33xexb2HrI
	V9aZGxv+AFm1AhWpZ25DQMN/Hs05370qXoxmUbbeipeogzIcQzdY6Q7I6k0CieJyEWrO17
	EIK3cXGE5sks9eqfu9qVemxboWH4AZs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Qplvlt7R;
	spf=pass (imf10.hostedemail.com: domain of 3ocHraQgKCCoYZKbKTYJMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--stevensd.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ocHraQgKCCoYZKbKTYJMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--stevensd.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777058211; a=rsa-sha256;
	cv=none;
	b=L5zyPdJhQgBd2c4IH80txiClYVGf3K59JwsVCNXNx3C+6N4FYeX6mqL7X5S7dxC9ocme1x
	2RzOmNGeGOnZTGpopYlkfREBVr9RrX9xdgu/pyst5eF/u6XINPagoSkQUxSnhCvutPc7ht
	2ipGuB0t6nsly7ltJCwYsT4THHt++LA=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c87ba0890so26152636c88.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 12:16:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777058210; x=1777663010; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uhV9bgboNhnyawRNXgnugsEye6zSCci68cPGbUTJPQs=;
        b=Qplvlt7RRP54yKL4wBHUcsNOlSsRal0Qa7SRc6tXS9QK/drHMnHnrz3/DKWXKlz1xi
         victyXWUwKmWo0c1+jzhfB8LIXjCpUV38PQAbuoh7nMTA0K0E1O2uxoYHlq9Sbv9NKTF
         Bfy6TvYBFoE7s91Zdf+mk44vO0RAWaLE3MFnSd4nK/h3UOy6rdTFX3ck7MldTrToicyk
         21SUZMvBZMemLxHyQ81sICNdhW/1neOcwNFhE73Xw4QR5t5kb36OlWjXAMnJRdwYZmoX
         QdfTdiifk+kn0W9mC/x4vSC01JPKkd40jEyDcAtkt6pLC/hGdonucvcCCQd7wasENV+N
         hpsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777058210; x=1777663010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uhV9bgboNhnyawRNXgnugsEye6zSCci68cPGbUTJPQs=;
        b=iWtgtiFr1bY9DzcWFm7nX8wTJiLNTI4a6lWyMVwgLwbcomKPZvA71k4GSnDzhvf/cY
         GsX1j5gqUwPPmDmKbVirdmc8TmcsgzNd/bFHVEA4rn24Mo5Y5U0J3sDGR+MaFIwXcM7u
         3SEalEJLJpFDxoUcN1/AD8gHk9tjQ2+GiPOHbEHbKfKbsnWikiBezse66NwNjqZn5oF2
         J90H/Vsih88U1mOK+xBxZrKYEkUsl3WxOx258y4iCq0ftyqlQOaFZfCl80Y4/Bu27XQV
         74becFAs0fV9VPqiZ0V+hxVp9MrbOV7ddDV5bMGzom5bUFGXdsznIn4dhtnbRJbx1vr6
         OQSw==
X-Forwarded-Encrypted: i=1; AFNElJ93JlV01DWCXDJannwZkre65PkyBrmDl2HGNuCWY20hu2UX2E8q0duA/NRzEJm3JXgUztL+WoPPYg==@kvack.org
X-Gm-Message-State: AOJu0YyJX1kPknjZ6i6lOOms4anncCInNLXLXD99CVWeSrJ/nomwVRS/
	JVuifux5HeVd57FDSBIpfra6GhXR6MwJaX57ojjJeHoAoCd3duy/Ogsu03BkzXtYLnvz/DqufiJ
	2+67IMDUdL+HwqQ==
X-Received: from dldz11-n2.prod.google.com ([2002:a05:701b:418b:20b0:12d:c368:c23a])
 (user=stevensd job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7023:b0a:b0:12d:b7e5:a67b with SMTP id a92af1059eb24-12db7e5aaafmr8877334c88.14.1777058209503;
 Fri, 24 Apr 2026 12:16:49 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:14:44 -0700
In-Reply-To: <20260424191456.2679717-1-stevensd@google.com>
Mime-Version: 1.0
References: <20260424191456.2679717-1-stevensd@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260424191456.2679717-2-stevensd@google.com>
Subject: [PATCH v2 01/13] fork: Remove assumption that vm_area->nr_pages
 equals to THREAD_SIZE
From: David Stevens <stevensd@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	Will Deacon <willdeacon@google.com>, Quentin Perret <qperret@google.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Kees Cook <kees@kernel.org>
Cc: David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 1066BC0002
X-Rspamd-Server: rspam06
X-Stat-Signature: 9s3mobpr39fqq67cibhxu8yag879oe1w
X-HE-Tag: 1777058210-31545
X-HE-Meta: U2FsdGVkX1+ZzSIpH9PWrmSu6vOeML7Is5WxW8/07iGxGGfQ1dFbDYmzQYvUc/nKH5Ldd6d9fqIq+LjnlkyZt/vmXjUo/0BUJc8ToZ1ojWbHG1mdjkl+UvJU1Brhy8+k4hEHkbJXmqXhytBtaKdbUOAALkwYoj151G2m664qqHJsjHvd3JVNWAM94Ke+P/YCkIal9e+aavB9CVt+0jAW/gCLaES/G1PJ575TtoQtrqPcLA4RhLKLFfo6Zz+GpxY/t3M0CeucsdesvHTMW8HARN+0wWG3SIuwfLzcXGX6PCYQmYu+Pk2j/uA0z9TVjoeA2Ls/iami3/bwuezTpGj4ppHXE/jwKQ2V0j5k9x7YbHlsS6d7ayQYIYA8W6LWeQhk1IAoWBXauQP+N6wlUnFguYyz3m3YZfIvreR6FG9nTHQL31XARH1wT9Vu+Fzny+3YuBggC+jhyg/jbJrdiwu3uSBvpws7jhT/lpwDThvGkBLlIHJTrhdQrLNnRL6moJo5beuhrVmpGvoCdAHjP3XdwwKHdxZyExCxBENLhBU6AIo3yx55LuGChV2KT3lzVWNOjmEMmviCPBQk00C1x70nK4ukPbtmeRbo447jiiD4pfjpzpiieCj+XjtmWobKVpkbTqYw3iEiQIMBBM61R5he1TDZV5w4gWQO0kS2btuAcICQjE/2PsXX6/8Qrn8koCgNwLuJDLOvziKv8fIdHzUBiFxQsK96sULaBTjIDBUeEI7MZ7d1kJLKnbfsBwxrxWgyfFHLzc9knlIE5bmdmODAPWPd7k1Iad7S6t7aiZ+a+J7T4RdSn9fJI8huIiIO4Gdq0ihWKaQMhVTgJOkLzMPA5EonYngjVTtEsgkQb4NkmAq/lhVCXFQtVbnEodH/31e1ksbZAeuWWWrRLm5WyDHkQwfZyPJbQo6TS6Y1HuOM9j3g+D7KUHojNZwL1IuUYbZ38c4uPRdXlO5Jp/XnR1F
 XPi0LnW+
 4O9jEIn9AVRrBIaCem2AQZiFHC+UUZnZzVbIEAtL1U6W96brUxLtGwQ0IWHq3EQWQvYXK0iv5pazYJ82J4x6RAFyM9dil/pedd/hGqsGF2/dsENtOOuDriUfFjmIojRtvLDu3gymLAmjaZNeZDk3AQ4bk7oAt4LmXdZqP8tRNNefrULxY4EeNQIa0/qfttnYUyf3Mna+e2+s5gSOP56oo88MvOOiVkAG8vG4/gVK5T+00nFecegy3UNdJzVZthyTkce3jR9NcY8UewEHMgEdPP7YsfUB/fHPCGmt5io/U/HSSQ6Ovd0HxFqVVKK4XzwcTk6D7+ttJzC0dTWKZmA6pxafF7hmv48UhnIE3ZQCBkX3pYewJPODLPf1J1hiczguTYrUzBHLY7ODSuGUKWrq6zPwUrhVN33o8BG2Q0VopmJNUJfLXTPvZe6FVWCpRaUz9QRbnPj+uIkz8Pr8nxZQtbaI+52tB9/XoYUKWlu15geCO+H5Wo63F01FpK5mjagdUooQTAIoeyGMfufSTpU++56xGlnIW2hboEDg+GhH9De6SSa7ZoJpFu+3S3npjROfwpmhv2p602jiSICtvg+OYx659wQEI04VuS1z1W1yLkO2kviToVPLJkgZt6wnpyot9jqQLfgRlP2efWP0E74x7NuOJoNIXxLuXsRtl2juI0b1wQziKhGoSDoICjuo5TLPrQJlxvJwjfVDPJ9Ac/kgVcChbH7Hwmk3+z5M/OZJvY3nJSwRDkqUBR5fHM4AoceiR9uHmZGeq5gsrdNRNJfnygziJ0xTuYnshrddM/okto9067H32zEiqlZwc5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

In many places number of pages in the stack is detremined via
(THREAD_SIZE / PAGE_SIZE). There is also a BUG_ON() that ensures that
(THREAD_SIZE / PAGE_SIZE) is indeed equals to vm_area->nr_pages.

However, with dynamic stacks, the number of pages in vm_area will grow
with stack, therefore, use vm_area->nr_pages to determine the actual
number of pages allocated in stack.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased, also skipped intermediary helper variable nr_pages]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David Stevens <stevensd@google.com>
---
 kernel/fork.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index bc2bf58b93b6..8961b895bf05 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -312,9 +312,7 @@ static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
 	int ret;
 	int nr_charged = 0;
 
-	BUG_ON(vm_area->nr_pages != THREAD_SIZE / PAGE_SIZE);
-
-	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
+	for (i = 0; i < vm_area->nr_pages; i++) {
 		ret = memcg_kmem_charge_page(vm_area->pages[i], GFP_KERNEL, 0);
 		if (ret)
 			goto err;
@@ -484,7 +482,7 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		struct vm_struct *vm_area = task_stack_vm_area(tsk);
 		int i;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < vm_area->nr_pages; i++)
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
 	} else {
@@ -505,7 +503,7 @@ void exit_task_stack_account(struct task_struct *tsk)
 		int i;
 
 		vm_area = task_stack_vm_area(tsk);
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < vm_area->nr_pages; i++)
 			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
 	}
 }
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


