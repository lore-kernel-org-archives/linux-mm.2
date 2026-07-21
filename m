Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23647C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 11:19:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883356B007B; Tue, 21 Jul 2026 07:19:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85AB26B008A; Tue, 21 Jul 2026 07:19:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7721F6B008C; Tue, 21 Jul 2026 07:19:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 538426B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:19:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D404340465
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:19:55 +0000 (UTC)
X-FDA: 85012539150.27.3460944
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf03.hostedemail.com (Postfix) with ESMTP id D2BA22000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 11:19:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQOaxyJc;
	spf=pass (imf03.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784632793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=uSH6xOaL/2+ur3DFoIQmHK2qeCYPezL02KujIX/OmBU=;
	b=byf4iDj1IuBq4cy157mkWrG0FN/CPzj+1UiDRTqBvgH3U2/4O6mw7qba8vAFtqagEysqkx
	iv69fRO9kJ42xM0g6AmcPKz6QcT8N1DqLudKBwuBOly1+/ZVGI41uXhuz/3XKAJYHmFCAk
	55IbbxXN0zzQJ16piglc6bW0kgae070=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eQOaxyJc;
	spf=pass (imf03.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784632793;
	b=pmTRFi2hTVWXD8DCCih97aMhR4qpfcrOeH12ofL19yA+2RzearAJL+WwB+ouCx6MJfoeT+
	N3OZPpn1NgoW1JYBZ5zCdmQpAwyfN4ByQq5aHf3mS0w7lJurU/bSibiMOEPuwFahTH6DCX
	vzDHiUT4rPlMuzs0Ud/qy9bd8IfLGqk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784632787;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uSH6xOaL/2+ur3DFoIQmHK2qeCYPezL02KujIX/OmBU=;
	b=eQOaxyJcCAlYAbiR4y3RqVxueLsjhvF0KS7IiI463PKNcpwLd68vxYFQrfI55HkKKPnS/S
	lukSTPU1madTjYLXejpDZoDxZkc0EwMDLuM1vVcjzJVOLaC+SCJU7y5xpJyV/cOYEFCGGo
	gXhlf0ZI3bLdCDd6imLrnuh7XRKng+M=
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] docs/mm: Physical Memory: remove deferred_split_queue
Date: Tue, 21 Jul 2026 19:19:19 +0800
Message-ID: <20260721111919.22923-1-zenghui.yu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D2BA22000B
X-Rspam-User: 
X-Stat-Signature: ap1szr76ro8dxpkr3iq46byn4hkrk9ii
X-Rspamd-Server: rspam04
X-HE-Tag: 1784632792-562981
X-HE-Meta: U2FsdGVkX1+H/qh3BL3rBFhu6V9EskoZ2ie5hZikJ/18pd9rdOZo4XMTddZouKJFOWpy2A8ekPD7Z3ywmTbcy2LJEcuarcI+n+VclWjPuj9iDuB5+3umPiHiBrAO+RisxmLyieeUQSddy6RDHkkQhmSKIy/1en8H+f+2NAoB3Izya+J20ORVw8so29gD3XxqmQi7YLZ3Xf/1silIMw4fdoqiE2fP8CQHRdu5fsG0OUILb74atI23rhCTgBRRG7ahmuudDc4m62hZNLLCLlMrT1WXz7dK20BS4xVumGPFYbEfo7cnV0IPzez40kDQuG5j8E/fenkUP6Vz+hp/lEmbaYVgF98gIIKlbq4CzYO1vcLNWadyPKeVX/uWQYp6abs+rZ5ayGTbhmlGrXNZAkpOVUYIfIDqWmpmlgoVJqWKrnQWICNjC1HJQMuGnn+lLeViFMhYCqm+aQ7v6gZl3cAVUF+vUa9xbq+MFf8WQRljXshO5nB94kaqOYW0OUExwYS5xMKT7ljv/GrHXMi/ruxL3kdA7108iW1VHkBOdRnTTq+9pggZnW9rqDrZ6wvsGbsXCw6QEPxnljc7VaUGDkibrODs88dV0UgyhzRcZiiJbr9oyVhSQSfNZNUgcQwDwfS8zTNOFXmYE5JQtMzPWqild/Oe+7l57aH/rT4lAQ0l8KPpkfoAf1HmSJKmB0bHARoZ9QEturLun9IXdaBilt8RRB7Rp3WSYNShW6OQ6toepv3GyT8A54EM7cFpXB9j2rWEn1ZPluJpE3w25UMKSy17dcrW3Unnx4/TeA3DhN07NZ8yUB1/hi/jjG+SvBbcksqq/Nzy2cpzCl9pcssQjsxQklc6hSipLvTZ2PymieZVaxHQ1RONRHVJDLGXtQaIZIIL6hXsHnXIJWTor6RNbWQFC1l7svsTXNCQQ7W/HMQM+60sz2Cn98RBEX0F2+ruHSw8G7KND8S23jZPsgWtM+C
 P7lOrGNf
 T4/+0p8GxRRlkPmeGKeAZujddJni8k+EfvRwcQmsWsuwVdUUwwexLXisQ+pqlzkxzXbw8L5XklWe19++9K8+0JWY5t+1E+H1Isn++tcOvoss0AA3nPFzuOMfu2UiYEFU8hNe3KkAmki+QEmreCTvR2L7zirme1qyHD9XSyYmBhZ538d+Y0JVDcj8Wkw4mtXr6J6hpIE/IwXoRrlx1/63Ade0CiTj9nIT7wn9kQ+vRNtBrP29KDmbxsK1rqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

deferred_split_queue was removed from struct pglist_data {} in commit
fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru").  Remove
its description in doc as well.

Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 Documentation/mm/physical_memory.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index b76183545e5b..a09407d72973 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -262,9 +262,6 @@ General
   PFN that needs to be initialized. Defined only when
   ``CONFIG_DEFERRED_STRUCT_PAGE_INIT`` is enabled
 
-``deferred_split_queue``
-  Per-node queue of huge pages that their split was deferred. Defined only when ``CONFIG_TRANSPARENT_HUGEPAGE`` is enabled.
-
 ``__lruvec``
   Per-node lruvec holding LRU lists and related parameters. Used only when
   memory cgroups are disabled. It should not be accessed directly, use
-- 
2.53.0


