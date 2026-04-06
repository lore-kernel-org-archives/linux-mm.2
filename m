Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6266EF4EA4
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 09:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F64C6B008A; Mon,  6 Apr 2026 05:09:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6B56B008C; Mon,  6 Apr 2026 05:09:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 295C56B0092; Mon,  6 Apr 2026 05:09:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 116FF6B008A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 05:09:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A064C587D3
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:13 +0000 (UTC)
X-FDA: 84627556986.13.658878E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 191B2180002
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 09:09:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rQ5GDOnL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775466552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0u7yN/wswfSJRNLNgZzfynDOOGXxpqIuuN9yGGUexAg=;
	b=jpKF0jUJDvlKS260smjDAfJtBfDwK4LkI5ILKyTdlKE1MNpC3wlHNw0ztnyBk7CQBkz3sj
	U1SEAfmtNj3TtQltXcK9UXbpwfMIcntauBMQBHpbYG6Y4nmUE7pWqVzH/Y2oCSF68e/4NV
	k0EUdgLYiSpOqlDLM46RowWXTlUgv28=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775466552; a=rsa-sha256;
	cv=none;
	b=kJ7NlMVsssWL0aHggBWX0+nfP7pnEnsGPME+KxWt1bXKEzJnFvksWbC3hwCBMFGgt0a4uA
	KFmu79BtzY/0hL7DYnUp/X005LuTHRdFEJwYMx9jlwnm0qzYiHOYrUL3cP0ipsv79AVrfN
	8bySfQr7LFMmIa014wwaj5Kff+33Gt4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rQ5GDOnL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 46425444CD;
	Mon,  6 Apr 2026 09:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB37C19425;
	Mon,  6 Apr 2026 09:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775466551;
	bh=TmavGANFAIOMlKVXwFFcm00j/9jYR4IU51JHihFbE4w=;
	h=From:To:Cc:Subject:Date:From;
	b=rQ5GDOnLY7Sf03uQ6SNcVFIcEUzX7QpwBj1PMB6AKwEewkW7HSxfY1lVHvexIiVHC
	 FfPoZKEDOf9FYwQVYhULkEDEB3iSub7kkmyxXZDtX++8sL+VqzR9WMvfEcHWZDunen
	 zhAlirxmcRTVDG2p+Eo4DNZ2brKaGPu6Heq5yAg8GpVXMA+o+vCGU3mQiiX9OkpTgx
	 wghBxmaUT7lI24+UvrbX5P/ecS7W1IMDxo4QcG48ugy81sgP/Y47+ahKEgYGlEQUDb
	 VrxdCbmnxeDm9tBGqgt4+YewEJcA+nPUJRhooUBsJIOn3tjRGpaqMkOzoo+Jafu+yC
	 iL+J8oLpGGAPg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 0/2] slub_kunit: add a test case for {kmalloc,kfree}_nolock 
Date: Mon,  6 Apr 2026 18:09:05 +0900
Message-ID: <20260406090907.11710-1-harry@kernel.org>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 191B2180002
X-Stat-Signature: hjs6ksafsd5jnnfudrepfanu8yq6b3ro
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775466551-722864
X-HE-Meta: U2FsdGVkX1/NzpcMfGMTqWtTpXr/flLPI334NklE0ghXNCFBD2W32sflPk8pCWj004aKA5G3dQ7XSPC6oCeG/cyXjhrK7SCIlThI0wsobRYlBIi2fkukdZxMnHTRK/o4rtNpc57y85728ilUuNPD338/SaSYqk3RdAGcEHDAswlO6VNh2wCfFgHnzPpbPyjnHLlL8xKzJ2/CrhiKu34UJMoSYCqctjgVjEqgFTYtMhC5kNcwNWcBlFtkkC0NfeUos8HfmiWA6ixzqqGvYDKq4DGkAvhNuUGobthvhlxYYOzS+q5ix5mfHDBc34aGQ8Rx3ghbHTamXkSewJoNGH+wHLXNKHjAos1QT5H7ICB0yQUuLP+pk/DHmGYNldCKXBiol5zL9cABKzplAXKjJE3XBS/eFTHhL4yJb3nHijbmiyXYREu5wgHPoi0RFwdS5T7K5+WndOupazmg+UxuBg0jbLaMG0sI8W43kTXGzQ06/IWjgLaN4azLnOATQzaX+ejTG/RnOiN+muwzLKkeYEj0HnwisxpB20avW7CKxfL/GxHRvZuSRw6dnOZuJOBprnpPgRGFzATHVNiQXtLKHrnEi4pnbVjC0AL4VhrqrGY5sFWwd405dgNf6k+IzYA7t6QoBeeEvXAhlNRy8VK/2rm0vd2PTD65vOkPy3PyZgnMI+3hALzNKivPAEF6ELX3wbIUtr+tqDV6DswSu+pmqFjMcg9ndQ9nQblbrr3B6mPl0dATZLvACDlQusGp3k3VgADwV/p61ZMu+oNXF9flfT/cVOjhTTLZzDsFUKOjG2P9aOG6P1EaaJcFTDsjCoKT5u7kD/P5YgU148F2go7PXnN6V8tBYQeOgHQsG4sKDvkqkxDpGk3VW73f6aUgIsj4e/9w5ZvrQJufRgVDoCKRjl9jV3eaBmrc1f1WBHb8sRBdqNJravBlS7bYdX0kFmY9rHr+sX2WwxKq55t+OXtgYaT
 CVsSN5md
 7B3M7HwYvzhfbhaAXC5uHifuAd3wwxVqhGO4J+V9i725xK6qLHqJgKUzXNYBVHdHRXnLwjY2xeRJPqXjRgkAOtsLT6YXvfRQTMAqlGbZUggHHzWuwDNrspZKAqgvnTeZLXv5TxT6mKdHaP4h1dtXlkr59KNBgx5vXk8o+SC+wE+Jg6Z6gwUxxqaRTYea5goa3SQlCXjdg/FDxnDQl3rNRnak/fxBFT1XOeLsSU5PIkfGHMnITjHY1V6lk/F/uM1Z0JMBoPq9ZVayyMfaPhtC9hfgMNRJfw4Li4dSeXXvHgGuSerKIhW9CZYLt5P90EcZafHH6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test bots don't seem to test kmalloc_nolock() and kfree_nolock(), so
subtle bugs are discovered late. To make it easier to test, add a kunit
test case that stresses these paths by combining a tight alloc/free loop
with perf-triggered interrupts that invoke {kmalloc,kfree}_nolock() from
the overflow handler.

While at it, also add the missing MAINTAINERS entry for slub_kunit.c.

v1->v2:
  - Fix build errors on arches without CONFIG_PERF_EVENTS (Thanks
    Vlastimil)
  - Rename some identifiers
  - Use GFP_KERNEL_ACCOUNT or GFP_KERNEL for kmalloc(), instead of 0 or
    __GFP_ACCOUNT (that was unnecessarily restrictive).

p.s. I was writing this test while developing kvfree_rcu_nolock(),
let's add a test case in advance.

Probably a similar test case for the page allocator is worth adding
but I'm not sure where the right place would be.

v1: https://lore.kernel.org/linux-mm/20260330120517.104743-1-harry@kernel.org

Harry Yoo (Oracle) (2):
  MAINTAINERS: add lib/tests/slub_kunit.c to SLAB ALLOCATOR section
  lib/tests/slub_kunit: add a test case for {kmalloc,kfree}_nolock

 MAINTAINERS            |  1 +
 lib/tests/slub_kunit.c | 92 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+)


base-commit: dbc785fb4d9cfa0115e69e614fe20b4ab90f8366
-- 
2.43.0


