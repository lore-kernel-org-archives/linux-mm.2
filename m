Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF752D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E676B009D; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3AEB6B00A5; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD4FB6B00A1; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 818D76B00A2
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 404871A00E8
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.06.071EF10
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 71CAD14000D
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=D8udur4h;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NYQE0/4xpxjm8d68deKwDm3nKFoSSIOI589+d+MkqSY=;
	b=qq6Y87OvoYATwavcun51Yi6tnXz3qYl7Vbu7vc3MmzUm36qoQ7xghIPrCm5lGtmZLcaXw7
	81NsStZ2Ituu3Bo8IIMINnTU/PXvlU4p5b9svYaBu6e7dG3cR0mxlWdlruidDXxHkDcWEK
	p+0Ry9b6e9Zn4GDPyIg206/5BUIai8c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=D8udur4h;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=nHHRzaqTtar06WzjVnP8R5B4B9Ytj1j3gXVlVxJ1X/8DNzhOU2iaV7nFI1ZMeR3aCLSOmV
	p2H3R2npyrMM9IyMmw6lAteGnW+/SOsRl0OLxi2jO1cpRtaChbsPNUBLFwmfH499GB0Prf
	mD2qpylqacCPPSbLzvUMYSnVCm+c5Z8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=NYQE0/4xpxjm8d68deKwDm3nKFoSSIOI589+d+MkqSY=; b=D8udur4huObW0MeP2JD6P+gkIU
	SeFREtW5He2AXWOlxBjfeigmkmEF53QTJmJUzNh7IDQh3PHtwQg4A5AXBUUv6GjfnZlBt+WcJkVg8
	YKdX97Mm1CugfdSPg3qM6Wk3l+aoysR1sXWj6d6U3lrFF/vJ3lMvrr+kqxZymEAVmrKEmfk8RRE/g
	co+NMA+99yF9cshfrQlFS6mnZ/zDYCFVyw/FjAvGbuNza6QvjOA36iDXrLf20r7/kANoHmlsYG3nG
	Ag1HnDnZndRzj1D/IMAt4lmQid3tIeOG/9qNnpmZP+h3wdLuQySYSVGKMvyHk8yZUvdNE/rDWUVM/
	bl+lQdPw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB8-000000085ZV-3ZAL;
	Sat, 10 Jan 2026 04:02:18 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 05/15] turn signal_cache static-duration
Date: Sat, 10 Jan 2026 04:02:07 +0000
Message-ID: <20260110040217.1927971-6-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 71CAD14000D
X-Stat-Signature: ui1f8u4wd7p8uy9a8ttqke5p3goznfiz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768017660-446469
X-HE-Meta: U2FsdGVkX197n2tu4EOlKFGxoRal4rVSWpYplFQ59DLecOdHxI4G64SM/+oDxJ+Kwpq0CFxnPrGdXijCTwNQ5sr09/ggJflFO+gD9VjpziBatzCMhSLulK1hiVQWRWYU0Y6FUwnQDWLMEiONjOF/NwJJMYzejuee/AMYYidClF09T+TnZIe2POp39fPUDzyKqv5pfLsySLDWNnVa+6/0cr9v7DzJ4EtpqbWD3ys2tpArnA5iIrpzTU3MpyZsb0PjvI6LrkZ5tR2BO+lvoIu+8Z9irTcqU9xPmruwMAyP07XQKSLDwA2l6D1ejD7IzcsQvAKipk7y0wztefOvI8PPsGsvEj4b2WNv9cELdLwYoS30eEtfAgeCmbkh6N0/obWy/6UOLia1qxk4Cj989WD1+oQrbrpGPXiQfoA1xH2XE1CXbrifJfIRolrLd6j+VM1gWP8C21opGYfEBdOdeOIb+AASCLk8eb1+COm9OsabyyP2aHZgidNqrunNPYA7dWibzBmHYPmUzbOCovgjRHwqzh9g2khkA9jPpFQ0BSLRCVK0R8icrmLJxzW9fFRVZjvPFpSr4rqXqeG/+d94vRZ32xiHxihu56037MxgW0PU/xQRbjouZjd1xhbiucgrfKZM3XidFxQ2lBlSxjpD6hBjdEqhk3kTiEBzSWGNDK7awOGgu9kdc7NA+yrdwOPctyEYhZwffr8IPL2uUtTim9932r2AaIY0PB4G14Zwl+83dtsNPwighcmrBk2J4OjyGCjD7NCVutiCOHpZOEKMWhnb7ar/xQmHZlItAMFA53prX4fWpHod2Q74n9DFJJ7GEmOxA4Hd1iWkCLbcjZp3T8HJBI/cuhoA9om39nI8u1MxOACwP4CYtm3qT39z1gdxFZ8jjlFKTt7181tij4/rxePNFnV2vHTbWrU54cL87JSCDrq93riJH+Yg5S+9Wi0TEzMPx57YiA9cqPJAqpY3Ji7
 lQeBV8Ud
 O+JnLD7BTxWXWBxl/wdolXNtnamIAq0WJXi+FxrFK0kWRmWoYwRVvdZbwOaLtikWl67E0fAAX1QilgarV2uV+DuwsVK3DvQ3Q/1sWBaYH1+bUY0/gd+Wkhl8iFWLvRv/5MOnfGqiyrm30UTNu5vMvpeQoEgseGxeT6uCZmuq6WTcGVJlhdL0E8/v5QTC0EtJTSWCN7+OtNsg99Uag5H02C/yjGtvIsPRwDfVDxdiCzOfM54HZwSlBRXrHdk80H0imrIjC8ETWXnPW0nHw6FHmp8Lu9vLsHMEC5PptG1rO+3i6COGo4u6awKlPbbw9MRCPu0AVcoekFHdHih3SkvgSawKug+EtJfBXl5l+ts4kgMJ4M6YgddTxazo2gLxXnFbaBgMAfprK9PX+jUyH2HtcvZ6HYTpLbJm6IvNCgAa9h2pEvkhYyQIHGCB+wyQFgwQzf1W9OqqTJc/xfxi4pSkXQKk+ju00d9uiVg+KdkWM0egBm0F1vOEB039RyA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 kernel/fork.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index ddd2558f9431..23ed80d0d6d0 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -465,7 +465,8 @@ void thread_stack_cache_init(void)
 #endif /* CONFIG_VMAP_STACK */
 
 /* SLAB cache for signal_struct structures (tsk->signal) */
-static struct kmem_cache *signal_cachep;
+static struct kmem_cache_opaque signal_cache;
+#define signal_cachep to_kmem_cache(&signal_cache)
 
 /* SLAB cache for sighand_struct structures (tsk->sighand) */
 struct kmem_cache *sighand_cachep;
@@ -3024,7 +3025,7 @@ void __init proc_caches_init(void)
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
 			SLAB_ACCOUNT, sighand_ctor);
-	signal_cachep = kmem_cache_create("signal_cache",
+	kmem_cache_setup(signal_cachep, "signal_cache",
 			sizeof(struct signal_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
 			NULL);
-- 
2.47.3


