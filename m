Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5B4C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 12:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40596B0115; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEF906B0118; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF47E6B011B; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A31E06B0118
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:46:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21FC7404C5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:52 +0000 (UTC)
X-FDA: 84936553464.25.F6F5050
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5CDA840005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:46:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QLV75adW;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782823610;
	b=RQekOMtUDCDjiWATynygfTxNcPJaRFYxvwUPHTkhGp0flZs34IGomPsCcTEyaKptt7Imc5
	EHsvdNLul/erO+Hyw48paNfTrqCLFHfJpJbYljw6GD/qi06r7sNgUOHcw5LQmQNuyJ2Hu1
	q5QMEiAxKWvF+ov5C3E/U62LE1guPyE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782823610;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JRc6X3siF0MV7UwOUK6r+AaS4VmaqOkmIcYSgppzMs4=;
	b=ICEntU6eKKJycBXKp3KXSYhbQIVhpH+Na0Npgrf0EsGiGnaifdG4HCamGyWeFccQf4Jkjc
	m7c/A3XaJDovS4YoHRiyIJXoVBo5FDVMOJkIWnhmqL1YY86pXknozdccx0L/uG421xyKP6
	bsSIx4pEt1qjGPj1lJ4hAfIAj7yPJtg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=QLV75adW;
	spf=pass (imf04.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=JRc6X3siF0MV7UwOUK6r+AaS4VmaqOkmIcYSgppzMs4=; b=QLV75adWAdll+nLPDpabSITgCm
	WRfwp7heAEQXdj6pNmooyLOLz6U/Q//nyvCW9GtHxbihPr8K5PeP+uEjHolTYu7mMu14epk8OTEKV
	+T4IudRkrWwP0xdMERYflB87MXWBJhgyj2wq+S5n0ppS6JI0XV+Hs6Ek5soct/ZqPcBXlXP0mu3xT
	RwF2c3tR2aKhJgjOy+UzrZ8IoPGOtdW0tmxUcL9PLr61FjCQBOmUBoCFGdPjEmmtRZCY04GXIt5Zs
	savCNoyEHcVZ4kjBfGgkBm3lxuUlnEvedKmzmUPQDfzZue8tQt6HPe+UVKzGBx/WSsuhmo8mIEKMP
	xXvcmh3Q==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1weXrR-0074bY-2D;
	Tue, 30 Jun 2026 12:46:45 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 30 Jun 2026 05:46:06 -0700
Subject: [PATCH v10 3/6] mm/memory-failure: report MF_MSG_KERNEL for
 unrecoverable kernel pages
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-ecc_panic-v10-3-c6ed5b62eea2@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2455; i=leitao@debian.org;
 h=from:subject:message-id; bh=JSAYCq4FrRtXIBW3O9fBpGpm6NgSi4FFUoqeHM4uUhU=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqQ7qdbrCPdmwOUYMeBX462paxufYr9tGRerbCH
 OasygASlqmJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCakO6nQAKCRA1o5Of/Hh3
 bVVQD/4gPbn24odiOayBajbGFGEEeV5MaoKhhXG2x1/3quOUZTcQSMVzShINOIi4z9ZAlEMRTUE
 5ed/n2fywG3+FEe4q2dBRsc0/FYG3V9ELv8zNEZAX1EeSFWBFdDA2u7wgVfT+Un65/8XZ/k5KaV
 vpCH3gAO4HgKGe/uZevaJIgnb3L4eXaGu2e7kMQO8FVejK+v7knKyS3cvuLkPjhBGGHOZqJVZnV
 i7IHaqKqbE0UrR/8vO96QzE6DnjLHZnvLC4UnHNfWaze4VlfDxRyPTep3Ft86WddFeRbjKvvH09
 WMJ0j2cKBS+39po3CGSvekV/7MNXHNM8Qv6wnrASznY9CyzS5n8I5g5zZxyz9Z/DVWwIUY00KhW
 2a0FZ+pKA6b0gbIEwe++A0mcWP9dIEPyy6ZUWpoy7LdrfwtOqJ9bgGbxdtINVO71y8iypmC5WBV
 +QHCtoLaEV2LRAXfOmalZ4o7ACJRFW2oowTyLFpk6bIWxpu5bauNW1aop28+H6qmRCsMlN5rFV+
 5beF2+9R5OcrHUx/gvtOGO6whauiYOE9h45WUa32074n+BSjTdp4hd/nZTaRCoe8MR2QF4DNVZC
 ZYGxrEF34MtnDd1xCJ9T5of+4ojgSPUpMiOahFJC/EAgQNjC7/o9a3DfPebi1dSnSehwbs6LV0y
 Yyx0yYDZy/xtuSg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CDA840005
X-Stat-Signature: m9suumgb5nuk3ompuba84d6u3fh8o7bm
X-HE-Tag: 1782823610-995136
X-HE-Meta: U2FsdGVkX1+qOZj0zJZqvCVbkhYIWiQQNPxcTc9wOpS0Sw3UF4co24HeLg6NS4OS4SUBflcgh3/9sx0sb9sFZMMKEF0UTmqAY04RcqoRku2M4KO3twB3iKZfjgN48qo/Gsr9xck76dtxg57hyMQX7sCxRzEtSM6MibZu+dOl+eIWBRKwIpo0dhc1p1clMVKMvBSjJLS5GdqigATsaZU3OG6HfyAOxuU5aCitVswMYjzbhx69vJyGpSbPXD1znzz3rXVSeh9fQ6iSVPje9AonqzN1F/YlitCAVfA4uijKQA6R3rX+avU/oSpHceNn563ePbHb5vaAeAxZNOWQ3/nwmXSfyLMl/LdRIm2dLfh1j+IeqFE6RKdC5OkjcyzIuikQ6ShQ6qNY8SFidPud0BAcLZ7NOZ5ZBhgXEttKToIBX0BR4ZRDxDMeNe5WxG8n1J45y6esgbBqp+o4bqGlLTv5ZZXmdCqjDFBCEYDVoEZgidW9FwMoqA4T9ht4xCzmpWlyeC/lTHD8j47iq1qi7g8ydWYnOOG+xkUTWLs62DMu5b4bH4BzBWyCqKxRlbA5g/L1koKFKyrLRttFstQJ/Y0X1g/76Ek+rUQiaheKzI58CBpb3koqWw+t6s6q2F5g1vuovGVUjKbnHNSgUlSD9vkmkYR8+ezLVPjlSM6nEP9RvFJnjkNq0LWDFdIevkhqpZctEPVwshXrbxBCLp+fafM4b3t2skFQ3kftK9YsUBVaFBgLUE9z+BuEHlCTw/jugcweFDSyCEqse/Otdw7RSnzoywG8ppjUepNM7FB1tA2A0h7MWdLOeoI9jO/V2JIRXXgSdViLrURsmyy0pQmh/A2eOFt+UuGbgFYp5YxgXExa4PzKZGKq+njInpauvs8Xkv8izwMQagPjCe/jmcG3TQOFud4qQIUN4eKP6dKlzQS5m3LidkqnUd6wV1dD8sFs4RvfUxaAr5PmMOfG0k20EL6
 YJY6gxCD
 uQlpdJkTU9PmLpF6bAQSFw8xW6a2llaM+NMkIKHM7moCqHLNXns3fylmtuKCo8EFlScF8olO32DdDJx8qCEmkAqka7JHGZ8JSkaV4eqyPYBkM290yGE4RfSqWOJbjdBGoMLXzckSCmLCt2BRTscSiSwAfTJmvr0fqcNQOfqqRpz7j1BcGCaUgUgF5lM6PmNB1W3nbmfnblJnvGdYPaEUgznwfzT1QD4xvZIrwaVXpqomuKXk+VzyvzByBfO7t2Jk4JyPejq0oTW9wXDS1XNWJfAurVp4VRVp8Pr5SgycTZmVkZtOkgj7SuVIX7dO/5uFTtZeF3sm7Ui4LWRZkFlkf122kAJMg8zOV+KS5LEm6rIVDzpbdHBxqx08pWDBEJ6AoluxgXnlQCF/Q3bvw24B9yrAtgekO/eGD8ukZ0TcR/oCUGl8pgMAjh+pBczgqdmtmkmGFqUF6A2jJTb0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous patch teaches get_any_page() to return -ENOTRECOVERABLE
for stable unhandlable kernel pages (PG_reserved, slab, page tables,
large-kmalloc).  memory_failure() still folds every negative return
into MF_MSG_GET_HWPOISON, so callers that want to react to the
unrecoverable cases (a panic option, smarter logging) cannot tell
them apart from transient page-allocator races.

Turn the post-call branch into a switch over the get_hwpoison_page()
return code: map -ENOTRECOVERABLE to MF_MSG_KERNEL and any other
negative return to MF_MSG_GET_HWPOISON.  case 0 keeps the existing
free-buddy / kernel-high-order handling and case 1 falls through to
the rest of memory_failure() unchanged.

The MF_MSG_KERNEL label and tracepoint string are kept as
"reserved kernel page" to avoid breaking userspace tools that match
on those literals; the enum value still adequately tags the failure
even though it now also covers slab, page tables and large-kmalloc
pages.

Suggested-by: David Hildenbrand <david@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 087658484e242..5fc3de474014d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2436,7 +2436,8 @@ int memory_failure(unsigned long pfn, int flags)
 	 * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
 	 */
 	res = get_hwpoison_page(p, flags);
-	if (!res) {
+	switch (res) {
+	case 0:
 		if (is_free_buddy_page(p)) {
 			if (take_page_off_buddy(p)) {
 				page_ref_inc(p);
@@ -2455,7 +2456,19 @@ int memory_failure(unsigned long pfn, int flags)
 			res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
 		}
 		goto unlock_mutex;
-	} else if (res < 0) {
+	case 1:
+		/* Got a refcount on a handlable page. */
+		break;
+	case -ENOTRECOVERABLE:
+		/*
+		 * Stable unhandlable kernel-owned page (PG_reserved,
+		 * slab, page tables, large-kmalloc).
+		 * No recovery possible.
+		 */
+		res = action_result(pfn, MF_MSG_KERNEL, MF_IGNORED);
+		goto unlock_mutex;
+	default:
+		/* Transient lifecycle race with the page allocator. */
 		res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
 		goto unlock_mutex;
 	}

-- 
2.53.0-Meta


