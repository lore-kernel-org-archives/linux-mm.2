Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39E0DC43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C32A86B011C; Tue, 30 Jun 2026 08:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B952B6B011F; Tue, 30 Jun 2026 08:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAB7A6B0120; Tue, 30 Jun 2026 08:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEE36B011C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 02F66C258C
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:57 +0000 (UTC)
X-FDA: 84936553716.26.C14ED5C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3F85F40005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cUGBidlh;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823616;
	b=WBJkSuGwXpmOS09U+u7xZCtXV8XGLxbLLGy5ZDJoOCK6hZvwl/Aqs/Rl4vlpEpaAKwe79j
	6sXUY7IPcsbz3pZ4a1of31B8jRXKPWBteK8eqzJ96BSBoU5EpdFwnCooKD75x35ARg5GdB
	xPWUnruKvMozzNxlI32vdAIOj4YxNbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCokxTSzcevyt805GhDojYbTDh8KrKHQ/7ZlaYopizI=;
	b=oEAI8jQiutw80YAdqTEkfYzDr7q2E2kdGWYhgRPDONeof/SaJj/HM/ogrdVjOJZttAoDnq
	gdDrpQ5SovKBwuNISNuuc/GdvzL7JaE96khzuSQw7Qmdy85VgAvRIQVrjIOiBc9US0JG28
	93Np/dbUuUpMNzNLJta46wKmXjSaJXA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=cUGBidlh;
	spf=pass (imf12.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=vCokxTSzcevyt805GhDojYbTDh8KrKHQ/7ZlaYopizI=; b=cUGBidlhaYaxKIhbqVjwiZJuck
	Nr3Iaik0CSCulz/qZ+raPa2GGvt8Q6SmGhUT4jrmLhj7abAJ9B7Ilp2FtE4+7Z/4DSxUfaqDIkczI
	ebRYvc/tcVfQzA7WHQok+3OnPmWIm1dQFuUw1kbK1jhMgUnn226L192kVnExpLpr3T8EM5o8ZTFhX
	6UBcFJO3TOlQVhaO9SsVK6LsZyJdLEqdvsjaB4nzipZhzPDynAetNS9gag4cNA1zhn37sPOYmXoXl
	1v1T47EWX9NhEqsPu8WaLrLZn8iiMqmJ1siLKaQe7KUAN5n7gnXVAEwi3Eng87iNJhcBc4dufn95e
	FkyYNirQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrX-0074bc-1G;
	Tue, 30 Jun 2026 12:46:51 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:07 -0700
Subject: [PATCH v10 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ecc_panic-v10-4-c6ed5b62eea2@debian.org>
References: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
In-Reply-To: <20260630-ecc_panic-v10-0-c6ed5b62eea2@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, lance.yang@linux.dev, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3199; i=leitao@debian.org;
 h=from:subject:message-id; bh=zs5d0EaDtC4b+XF1VC0WVAz8W6j9RlbDhsy/bvqeXbc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdyDcYdI/fmLTJbqkw622ovYPP9XUuCKO57
 hCIEQ/WqMuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 bRWQEACCPnekYvw9Fn2w0swAIBxv1NRCrNyM6wD9dPBFIxVUp/2s9tfmyafFCVhxZD3+L/+7k7v
 qILRHO6MdCHX40CWFGjZ2XNBn4XZ+YKHjheYIDvNkxUeGj6W8BpvoZnaMvYL4r/55u0Nx+vwzmv
 NJtKmDFFufsrhyQOnVTJ3qfHI+xdUKXQQCq0FwwdyOYdD8PfxOxhGPiuK2Bs+6mRdlxGYaLGOOB
 JZToMInRcaYJ601Y713UU7nvPenUtD2noKDnrDUvRy9IDohKMwEG7t6Y3JYstKYLzhyYdAmg7cu
 9Omyaa9jPaQjCSFnG3A/iEDQJOqRWoNs3z8YhcVv6HnHpWiKUkFhuuD7l5QXXKhAL7JO5k+u/6y
 MfSIp1Qdgsp33+s0jMsOpEB+xip/RjNMeykRNnvaL22Azj0FWB+lpbP54WIPwn8Cw9vxU/Lh8mr
 XERsZ6VlHoGOKuQC7YfV42LPVBpJjiMelczQ9HSWOuIrY9fwZU83kq8Be48SNzv32jr+Es2itfv
 NWpbIJVfHseHTg74sID0tC6uWA6xfCblW+ajFi2u+9HMe5vPBVWkvAQCyDdBJk95MJfBg8zc9v6
 ne8Uzdf1PIsJ/+E8OvedGrYRP3fqpyRkMBCdaursxuU2Ccs56CvmkpZko2PUhaAigXlS6z8HL+7
 9zP3X8sphExipWg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 3F85F40005
X-Stat-Signature: iujx6xooxn371968bso4brgkf1jhnnmx
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782823616-153493
X-HE-Meta: U2FsdGVkX18C3LbKEvFi4FMBa9vUnK9NUw+TC2yKRVYQJoTaXHyzZmGQXQLgZh3yrOkkUlqfEcYmj0liI8rJCctBuCHsyrPn06UbQaSbo2yuUMCcbCFGRibFcixdfsqYd0nQYKmCG42oB5bGaqktR/JQo1vl6IIrXHu+RWf3PvkqUBRHKY+8E41Mz4yYAOkfVq4QIHAIpAthN/UMkZ0GdHonr1QbMl7CMtFMQnLZAXhBaxr0Lmjk1Dy6RieqOa2dIHb/o/9e5cykwxBkTlUQ+ELGA2PmqOeLpvMPxipD7bP/noJQFlfYt0/yp5+LICN2ag082w5WNMOubAhac7YPF1MsAinRiM6HXUpkcdmOjcz/vO33L/Gz4mQGC55v4u35SOrHYQPgRxOkM93UQawSNK0SL2AqTdIPBG0Vtd/BxDFOPgx+AV6OFbJwWqUIeSXixLoonQFGdq/40Bh6utVHBl4iDkah7nWp201Xzp/kB/zdM2umh4ipzJ2uiaG7rP+FR3S6kg1VwPammNnndPrrHXttJIERSQ7KAlYU11LkJJJaRaprdtIBm80eFy6L1pqBL4lizQ7Sz/FRxpWHDmybkfNWoOrQqtToD3A86y3wzkLiWdKRKgJYfuWdd7fJeVAK+fKKmb13swfSoV7wrGAuRi4GVPhadniInGtMwQYU2QwrRj10IuC0X589cv5AzPXYg6+ZvA9ki5dtcANnVYAwt7Euz9Tf5sNAgdETXcdqEqHxX8f2oYqVi15qsOPYYLuT7tnOLpLW4CAOwXx9IPCeIORaripuiqHH1WXxdVKhDEpYSvojZrseoEc/oSglaQKff7oz7RJW6OcmOvXL/lgjntiQ6Zc0Y4JOyXYpzkjotac4IM1w2+9SnV8Exd8wGkczXe1TdLqn5gVyLh0Dt1k/7gGuFObwkVJ2Joa2+gLdDfUoJa19fYaw0CkFiK/82j98vzDtqhCRk10VRBMh1UZ
 di85RMhk
 kjRdWIPceuBXvqWquE7agiZiX8S1MFme704DWlXeg0B978Ef2aTASduI/26NPFs8tJk1Zi7bdyrfuT5R8ObsQzFPR8D0ntldKX5u8dDt/JaJQa6at1F4l58IwFIB1aNGzE6xweoxms/b4UhhMVsUKKDK09j/ssZvy2Bd0/vnqxvI010l34Aet7Wyyj+lYB51fESH+q/nWF1mzB2YO7Ctnl4mQ3ufdB9ppCjF7qtQYAoKNVtmQ66nq3evcepL2zvwRtt8KxCFGYeFNHGjPRonEY1EhkLxRepGQImAXgeVQLZe8Q54JDrHw1S7nvtlbDbK+23RRJmNoRW5Cefrb5fi2KVjeEFyD4hVceLXebZ23yH9Txxkq+EZbozw0q833/kKLBVMU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a sysctl panic_on_unrecoverable_memory_failure (disabled by
default) that triggers a kernel panic when memory_failure()
encounters pages that cannot be recovered.  This provides a clean
crash with useful debug information rather than allowing silent
data corruption or a delayed crash at an unrelated code path.

Panic eligibility is intentionally narrow: only MF_MSG_KERNEL with
result == MF_IGNORED panics.  After the previous patch, MF_MSG_KERNEL
covers PG_reserved pages and the kernel-owned pages promoted from
get_hwpoison_page() via -ENOTRECOVERABLE (slab, page tables,
large-kmalloc).

All other action types are excluded:

- MF_MSG_GET_HWPOISON and MF_MSG_KERNEL_HIGH_ORDER can be reached by
  transient refcount races with the page allocator (an in-flight buddy
  allocation has refcount 0 and is no longer on the buddy free list,
  briefly), and panicking on them would risk killing the box for what
  is actually a recoverable userspace page.

- MF_MSG_UNKNOWN means identify_page_state() could not classify the
  page; that is precisely the wrong basis for a panic decision.

Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 5fc3de474014d..e097fc8262cf8 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1255,6 +1266,15 @@ static void update_per_node_mf_stats(unsigned long pfn,
 	++mf_stats->total;
 }
 
+static bool panic_on_unrecoverable_mf(enum mf_action_page_type type,
+				      enum mf_result result)
+{
+	if (!sysctl_panic_on_unrecoverable_mf)
+		return false;
+
+	return type == MF_MSG_KERNEL && result == MF_IGNORED;
+}
+
 /*
  * "Dirty/Clean" indication is not 100% accurate due to the possibility of
  * setting PG_dirty outside page lock. See also comment above set_page_dirty().
@@ -1272,6 +1292,9 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (panic_on_unrecoverable_mf(type, result))
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 

-- 
2.53.0-Meta


