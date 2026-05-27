Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB64CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 14:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFAE16B00E2; Wed, 27 May 2026 10:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABA06B00E4; Wed, 27 May 2026 10:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7FB6B00E5; Wed, 27 May 2026 10:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F8916B00E2
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:06:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6250AC1D39
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:55 +0000 (UTC)
X-FDA: 84813375990.06.60E8B0D
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf28.hostedemail.com (Postfix) with ESMTP id 977FDC0009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 14:06:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hXRQFsrh;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779890813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WbBaNvEUUV9dHKCwKIk01dAys3/khbUwIgj2MiKwh1k=;
	b=Z6Pwe9ExuXxgeE5Lx/tH6xbDkgI0ddlFpHfgk2MxVlkLfU0w17YE11vV44XmQ5fMuA/gaL
	IhVsy1Gy3vGkSmUR73Z4rXtIHMTeqDGR/qg3qzG56SbyGwKlw5PghlFHtabaZGuJpPzJFT
	XC+EhkJj/pjt8oSxhsqdM9oALnNGRLA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=hXRQFsrh;
	spf=pass (imf28.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779890813; a=rsa-sha256;
	cv=none;
	b=lbkL/qYTWHXwD2Gs56lfqmtTW8CX+oEaiTGtGLCjoxw5j6Yvf9mSnIWmilCJIlqIox4qs/
	oiqWzOzE5/XMoQYZh4l1p+kyRk5PLmTpFKyAZoXAbBNY/wifBRdE77kBQWbZT6kEhuLTeb
	AXuQ4kw4ZfEJLhB0zO+BeMXEGmQRe4E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=WbBaNvEUUV9dHKCwKIk01dAys3/khbUwIgj2MiKwh1k=; b=hXRQFsrhwcO5fbPxJdZLKmAlDC
	/5/Oj8hsdMcdix8mPdYre37lAs2/a0dazRsm78qecUsDQOp5/BlWTs7tgauiYVwHtQJxOrqhIHS3x
	VO5hpMsU9x5mEztCsAvkbxvTs0dJq9GXGctAJgshsRmneMVyolxiNWlwDkJ5h1uwS38n6b9v8EpBX
	mo2oPfoVqD7vv2eF3CVmTGMOiz4UJbv/Pzf1iuEHyZSdoqQQpevj2E7w/UY8w9OBcfd5/wEySNfoh
	i0LCFKR84uFanS5/q6355tzBS2KZpjzexCmeZ3aanuRFV3bRuGjHliUIrJ+CiXKBHe8qAowY90Fg/
	lmpRPmDA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wSEuG-003DTX-1N;
	Wed, 27 May 2026 14:06:48 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 27 May 2026 07:06:17 -0700
Subject: [PATCH v8 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260527-ecc_panic-v8-4-9ea0cfa16bb0@debian.org>
References: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
In-Reply-To: <20260527-ecc_panic-v8-0-9ea0cfa16bb0@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Breno Leitao <leitao@debian.org>, linux-trace-kernel@vger.kernel.org, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=3147; i=leitao@debian.org;
 h=from:subject:message-id; bh=PVkQrhhrYvBQD3vyC0lD7FiGrFyJsu0JdQyRsKIR+Qo=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqFvpbj7PVLzJ01FRE86nH7X9QE2rSaA3qgOH24
 VsAWQc/ZMOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCahb6WwAKCRA1o5Of/Hh3
 bXTiEACNvfxka9cCMrQpEcA5UqXBXxS+3NZK9HFqC8QaHpUFJgFpFNNUIv95wyLEnaUW3Iw+ZBC
 19iDONTUFs6ehBZYcThrTuVs9ww0ppdn8HF5f/a61eH+h61cHAzaWPkGDa6Uexo8aiuWhIfwy1I
 hs2DuBJMR1AQBm8nqhHlEvj7DBPAphdbdRvtWW3kYubEdNLPYZ6TFDafxZoV494fSZQcQlPCMRm
 cbTlyAL6OAysiMbSv9h0WCPUGmbF52hmFC8TFBSqqWGMBstelFYKz/glnOurkDpbLdIICoCtQnJ
 kBApBpKqWeyPupsONN6gwGp7In1ZBE9oNyggtC2tISbY4vEm1+/xlvUjpO4l43/OV8xoPZOfsxm
 gVF34Vb7oKz+pFqkvmkKQ3cdVeRC7Tb4Ump+VYQN9KrfwrvQ+Cp5JdeIThG+PVkaokGUL9Z19T+
 SA9Yl4871nAjgcczbO6hH/RQjFWQPmUt39WcevAc1Z1jXuMByn5/GCeXmND1BUq/K2/g1WElrvH
 sUu9teM90CtooOmatjcSN1YB0LVEfXGCURuOCjnzaCvhVupgFkFQWY7/haAy5Y5po2TR5mCptd4
 y0RpDvWdqPsz8Zdt5Ae6sygozIgLRGXR5NOWPE3UY12AT1Qce9YF4hNfAnakE/oTIfHDriu3vHq
 ZzTj3JTFtMHLAUg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 977FDC0009
X-Stat-Signature: 9y8wsyq41ot35ppxj6w9f5z5gowxsckp
X-HE-Tag: 1779890813-825798
X-HE-Meta: U2FsdGVkX19mFvElJhDH8Ggz40HBxX78sLDJQ/HGYd9fsQIY108JeIRnI9KBpP/SRuUoDw7fqYoFMdJezj5UdcIdhN/s6XHZOwqLF0HWS5WRgsqSm101gEejqgeE27xUggObnPIX5SNCz2fLMQUTiXVPjREC8inzalSDn9phqGJL59BpHe+CHuxT4ZKJenIA5GEWpXQCPOabLknZtTSZTCpl46gd/+5ZWfxkK3W/sH7+K67HfPU0yKgpP7GsMG9vJ1erCQ2Vy549UeWSaTHR7kO9ZBtSLZylTWFbyaZ09pN+Y5jLPPHfde2tr/D1D8wyWRc601uVmj9RwWfzqPjRkmSdeP7zao2D9zON3H0GepJ7lubPtWFwNQ3g5YrqmNThH3HKkvTzrYeOpmsrstss4IqFDopg5t2GXU6YM0UZDL/scqLRJTH7YUthJpZTrfZbWWV80K0OFykN60KRXo+h4VtjboloJ9+416RWmYAIVft+zvi+Fe9A14WrPoYTJp2+YXC3/bXHQM47pGMo+4doQMLusapSbf2LG1XzQ4q11tIfEhAzKu/Ek9qy4Hk9UC9se+qsIDieui1877a7017wZIb4Gy3Q7NnbHlV0BhHGxWHY+Sc5KeyzE37PoY233LSfBvpp0kIBXHD4uzTav8g6wLyZ72cSeWULqwSstnJ57UfQPD9HfAsWJisGHfk25NwmBAfCLLgT9o0R73xeWaG89alT4xuuDkSTqJrU8eGwR+f2D/GcIbuWLKN1bIRDPfaWN6dkKVbHaubjaF3ehojd9OnUcADpR4RXxcsZ6lQpc7DWAp+FTZykMwxyEtrutfR+tzJNJDwMNasB8yqelE0WL6Vgi2a5WrRCF4nphb889XKPrgDpwgT0lQxMHjBk29srrQTHRtVBHZfeIUagvbas6VIRvdTUd1FNTeoxojpQ34UceMLwKWvI2b/2S/oNrP2+YrrKzUfATg5V4BX3aJp
 CmCuiAy0
 cAI9o2lvOd0aj/NRadBgC/c3jKbgbEft9q/Ox8kHc1gppIbDZ/nXLXme03sb/sTL1RIinnH/QgcmDdoLv28IPZPQUv9aC9E4M9Z4lh7MAajsUJe+AbfU7Nt6mMJyfZxJlEjrizCtCpHSR1rqpLUx7JL1NE5uDQ4fjFy+D1cPtZdHlMnCg6WsSkEJxjVBSZa+EJpsO4pB6z9y/O2wj4G2IXE1fmYjDpudFaAO+MHUy1E07NXOZqrBotGtLom6pQ3LDFasfg9/pV9muSezAvx03oJMVXnGMaTNEUddkfY7I9bjxaRAeKOhWK6OdqAk3NoQpfVX0NZwxkMJAR8x52YpTe3YIQvKeBIVmYmAo
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

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 14c0a958638c..dcd53dbc6aec 100644
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
+	if (!sysctl_panic_on_unrecoverable_mf || result != MF_IGNORED)
+		return false;
+
+	return type == MF_MSG_KERNEL;
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
2.54.0


