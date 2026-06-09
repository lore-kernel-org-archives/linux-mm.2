Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB303CD8CA8
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:57:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270276B0095; Tue,  9 Jun 2026 06:57:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247EF6B0096; Tue,  9 Jun 2026 06:57:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F456B0098; Tue,  9 Jun 2026 06:57:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F0AD66B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:57:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF3A41A04DF
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:44 +0000 (UTC)
X-FDA: 84860073648.17.A0E4E16
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf16.hostedemail.com (Postfix) with ESMTP id 07E85180003
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:57:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PPguWdWz;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002663;
	b=HpP9tqC/rSFt14j5PJ4pPChoMXLNVZ23jSXDzjMcA2ReUDUKcf1b2+vC0+3q60NxcbgeYf
	x8y5LrkcaI1RClFBoKmCU7DXtXYLxiXVI2scY1OQCYJpdqY9129V0GoHTSBPcHJD71pjeU
	M0q2znVwZowPby8yi1sZ4g2W57tspbc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=PPguWdWz;
	spf=pass (imf16.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BtvYFqoloPPtAp1pIQqyXcufUFMrAyAb/WE85RRt7eI=;
	b=BWorGAVHbjJNmSJpsaPhAs2Vt+cVRKmqj+tdCIIvNXUeSVuQoslsImGjsZqgcO5HxjMZB8
	JWirD8hHrFFUfi7nb7feTEusa+QeNUjVX/4WptvoG0Re3+IRrvq4IdlXZpWsk7oBmrMz5a
	zPIRl4cduMR/AWhDulwIyumidR6Bs5Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=BtvYFqoloPPtAp1pIQqyXcufUFMrAyAb/WE85RRt7eI=; b=PPguWdWz7YUz61OS+TRNLJgm6N
	1aYxKyk2lPR2q4ICiU3HYfikJz1uv70/ogItEDn9gmsp+Oat4KqxF/NqEoAteLwN4GUMqOvDTYG1C
	w/w0kWaqhxYBKUiejwGfXJ04DM7P5xPHR1qRyfJEFEzIoGxWkX6gEL09fjIQWs4sRdQpnub5bXEg3
	nZKWjrXdXI6Lihmj+S37+MSZbzq23Ih9z8c69msxUwjzUpDEy4NjhXZhuHjqB3mGkPEW2vczxI+Fu
	orXfRXPzQa8W7yq3DVfGLbKK3as3qZ9DWFB7iDp1ABfNScx0pnop689ILvS2RxYDVbBe6Acg1mlON
	wvKfwVgQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wWu9E-008Ltr-0F;
	Tue, 09 Jun 2026 10:57:32 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 09 Jun 2026 03:56:58 -0700
Subject: [PATCH v9 4/6] mm/memory-failure: add panic option for
 unrecoverable pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-ecc_panic-v9-4-432a74002e74@debian.org>
References: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
In-Reply-To: <20260609-ecc_panic-v9-0-432a74002e74@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3152; i=leitao@debian.org;
 h=from:subject:message-id; bh=pptrxwgjoBdTEzfy0Zc6OZLCiUUl50m92rZCrLci1Ug=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqJ/F/uyEq1JIbPVqIFYZev6obTOmTvOQvfMd3s
 zL4LNHIrhOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaifxfwAKCRA1o5Of/Hh3
 bQCJD/9DiZd5c3g/931cj1m5gW6orYI3GnfV9eUGkKD0VFG3Jz7S+pA6eCWImC6gc2AVh6hhX63
 p4KROpQub0l5Dhc2jNMdjr+jfYqmykBfADbdWk5RWZ/Z3mYPCQeDmFM8aA8fKE+Keoingbv5uAn
 +rL2SRe2YrBIGE11QHluVBU+B7EgRV8bWn/UDhwjMIjE63XA8ZmEbg2NUWdNyqqs0cOTRzgAntu
 AixH87/fyd7qfLrAtat670Lw52FvxGSiUJ6GVGS2WQH0z0qVQ6kjZvsH5/nA/Mkgoiccs6HISK1
 IOei3GNsPLiEyxfZzUM1Jtp9u5xqr+MO4aclGMI+BAuP6SQV4Y14Fo8yNpl7SvnMxry7gM1eBK9
 UlwNX0d+thLKRbqiv+o58OK82lVbKeHPNZ4TyH6fvHY/kbmyvU5oUwXoD7lLhXFg7Wrj7dN2UJO
 UhV9m4jx/DpmKu9zaGeYK/ffepGvKN1gh6GKU4kxdzXVs7O28j6YAC4BKLvob3V7WQ7+xd1455f
 Vupd5VI4DZWurmPRFQnookUOXJshHRiH9ADMHn2x7asuaRAOF2hVVNr0y9+rK05uFzD49ckvxjK
 Br6PEI94VQa0oA15IGfFrrKwVn6rAoAHFDy7v0HR9fyDUsGNDhRKCkMfgADwO6/QnSqLfTc6tVm
 07+h3LVb5zfyi4g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 07E85180003
X-Stat-Signature: j6pqqb9uk99hwph18ah1tp8zowptcp3t
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781002662-973824
X-HE-Meta: U2FsdGVkX1+Hxciz51FabqQLjVQPk3f0dYrywjZcv7btN7IwtS9SVIUdPkAOT1tqH5Hsfb1bC0NiNZcfyKv0hCN90wXovpLKT4IHEFxfMfp3ukSGgEhTUl8prIYix1fm5Pvf+DvLQuvqRXnu6VC7iFCY+S034Ee4IdpH2fjbnCqs7PBK19CcvwMZYt5mGa9zRL133yCLp5Pi+ji0T3RVq9hVNOij1hMe6hkHNLKarAWSKRIZYQPP0nA+fnF4+ZY2Eic8pKtsr5NdxnlD0wFzBnsF9yroSWQpg519n0PbRACGXFnVx3C8M25yeh1Rio5S9hfLfme0XYchy7DcVrAcoPcP6hKOwVt6fKwWNQZb0EAqhO3Q1qThRIAUn8S94Fd/F8oDKCe6WXh/7HaSwMZEcaNa8HZ9rA2q7k7MDOwaJ3zxRMk/ozVtZ79GU7s6Bqtg7z8Yi6p4ScsawDJMPbQOJt4d2Ob2+1DhGG9AvnXE/C7OuIvu67Xv/hI9wvOQ8Ji/i9z7ehsCn+QT0ZVMNZEJ04OGYklio1f6Mftmzhy6S3UwCdQTvBx936GbyWDNXiK/wYmx1G5x7/TeKB2j8GyNyfa2ve7LBvqQZ6v0H/72+EjK3ehte0m6YGFy99Iz6wyqb7yp0oJkVX4W11asfxwblwk8AxaGNBh23s/7r+eoAf+frKCYXXWwcd8rp7HdjHS49QLr0IhJ5VPiQdZNoaqjcib3q1r5MB4ESGS5295KEAWSh+Rantut9bJLP1PSUO97Bj3518Gt9eGZ4zXRl8VLKV5fk0C/mOCIR0Y0wpxXVwT/n3Xp557D2k0HisBu/xQLj4BZoyuol45OhEm1nzbTMzhqVrXXRAcN9B13b4aHLTxN6CCst81hagrYu6Fnh0CpXae9+sVhN3AnidAayRqjxngiMWaccN1p+fPHWgbuoQHLptvAT34mJsejL6pjMvwjlqQmXddpusMiXDwl9GD
 +dpkInmU
 WKAQkVnTslrEGFFztHkJqfwY5qcvZnIKnp4ySS1a3z6fptrFgeN78cEtI/byuVRP924eeG8dDITQa4YD8MfG248JmUP/mJ19UTmvkU/bg5jF7cH/Cc+MwgO19+NUBeQCpvYVrqGY29qzafZMPSY5fXg368ri4RZKDkdSGWBAjL5UEPVK/HeLeB33QRaAtd5BzGAiMHej/nfhIHb+JBFE0Fyor9LxnajxvaRg6Bkm+I3xqlgwoMqijjAqzCl5DWJie/NFUl45oJNytXXsaXM5gO98gNeYno2Oc0PsuhNUqSGI57psqD9XEYbL8n9ABRDXOWQo9842QrjAqqBZ18fYSYTcl3hgJSZunyiLPUWp7AdmtgB4=
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
index 35f2b5d89fbe..a8b466a48b02 100644
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


