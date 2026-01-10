Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0039FD277CA
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C4496B00A5; Fri,  9 Jan 2026 23:01:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BF86B00A4; Fri,  9 Jan 2026 23:01:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5AC6B00A6; Fri,  9 Jan 2026 23:01:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4F0B6B00A3
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:06 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 90073160110
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:06 +0000 (UTC)
X-FDA: 84314703732.21.6A15281
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id E828E4000F
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JuDAyOtt;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017665; a=rsa-sha256;
	cv=none;
	b=mnsGNZlqs157EzGDu+JEv+UPH2eIc3qJYtOUzL9Rouwfu3BT58fGxJThkYFh89WOoNEVu5
	b6ezt+ianRBUZIkU/CUMg5VKgOF4RmA9UD0TnJnGyRxdgFvxs9Sj/TcIfG87fZCzJtjAPQ
	3BdolUr4AC0JL5NrsbJsGZuRFPFLisg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=JuDAyOtt;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017665;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhChjjCCXpU6xJa0nBtwbeFUsSVl7UkLK9s6DFk/TOI=;
	b=rdPH71+Kh8T3N4S9VUxq5/Ezl2UaEjmapo9QYWMMp5SDqdYpWG9KhZs5Pi/bjHzz6iIcTc
	cYjFxPr6C3LPnLrbwZqgZwOrx8c7qSk76+ysEtJxzTUTdQzUylR+0pmO+m/t5jxD6oK8Gy
	g65p4/MPr/vLULvR51lWIBhoBunmF4c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UhChjjCCXpU6xJa0nBtwbeFUsSVl7UkLK9s6DFk/TOI=; b=JuDAyOttjDWAomFXe/G26EAstH
	eziFSZvGfJLCNUkI3ZhzWZrXM+ggkH2+DrfPYk9cP5NDfTLY3GYpQL2FEe4dpHA7Fy9ELsmhRXw2s
	vwduAcN6U0XxZoXkdDG8vpryGRGUmhMk3NQTkwBfB8rPvT53/EyjGrU5HKfbWuRPo2QTAZki5lPXH
	C7L+6BSbR2jJELUCuMh5MKbXAL4WUltdf2XVZIJzFFDNKJUbx2eY326t2QM6LI3tRucSvmOra7cHP
	TUE4Ek2tzoqwLNaq+hP+bZHVdc51V73kqKeGlgawrINN2Z4wb74+9mjzrwy+n85obY3QDmx3fYLp4
	N9YNaYhw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB9-000000085a8-1yly;
	Sat, 10 Jan 2026 04:02:19 +0000
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
Subject: [RFC PATCH 10/15] turn sighand_cache static-duration
Date: Sat, 10 Jan 2026 04:02:12 +0000
Message-ID: <20260110040217.1927971-11-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E828E4000F
X-Stat-Signature: yruxu3owtnibyy4rntyw7zwhb17ynrdu
X-Rspam-User: 
X-HE-Tag: 1768017664-557312
X-HE-Meta: U2FsdGVkX1/xgQBggd/49MNYNS/mAU/hMht783crtCOozsL+LzPn0mR2LFJ/y9vAewkEdbYk7qLNPVkpRWKm3X45BXexQOK1HeTT4eBuRehWd3baEMf0EwhQvOQM0WYNwFd110NyuJgaNzvhO3lhE+a3QZvbaD2sJhmwvjNpoHu/QpcjyfwfgsZrohVG9ly2cK6dW7EuCQmIobVAQ4T7QWhrQzkURdBcvEQsRAe97Dw3dE90a7LGGF4gwRkTH/VM5/gZ7ETO4LDcxchnrvTkRqiqcukdI9pUBXGvX8BPWXf2r07hrICj0xh/DxE01FAPDJlidos7MB4r72WiPgjmiIqxgmvAoOyONIlvhjayoaFeNsrBpfC0aPxuagDVgu19JQg4KEkJPPwz9MQZmMrQcoHLWA7Jor9hvyW4A9nZlabLjSZxI5+a+OvsIkWMTkXZxl2jozUYewICRcCvM9omkwBm5DkG6q1qaCdkEa5oYqeEAjSj29G10Y0NUV/pGR5t5PKBmuX5bH3jS76nAUa3ukgkl7IsrWcWCNLJqxESV/TrP/MT+fEgCfTurWl/hVehUKuuH6QSyAL8uEA3O5gqi0bosL7TYWxGJVJHOgg3Lh2rhLfVnsPYz3HfuppQcW/6zDbMynb1HSalN2v3XL2TwrlKmUPx0VJSSJDs1XGstuo4G+Atg97w82YJwoqBRDgt/N+n8qp/rZ6iQRscvgrOMhm9NHfZLeauTCfRILD5cvFp3yzb8Z9O36MZ80AVn8EnP7yOFQE3xbeD/gEOUBunFSGBlmzk3HHjECK73/TjGKK3X6ryjF1i+cGe9IgnwWCNiFmZdCBj5m3N4AisqL0v3iAhY2SVNcdt1MNsSfYJ1mGpkjgzEs+g+KVkI4uqFMWFo0qZBraeEV7YiulNZlX++Pj0u0v+CpzjafEv+jPrIwiAiLTDMyXGQvMswD8atyAO+xwmCYLbFvxM1dMU3nD
 QP4oeZmJ
 NSL2giwr0eB6miWkrZm13MO5u1UpbKlNUitHv9e708+w7pju07KW9eXTq9ZGIOWGS5io30IvpFx/2ZTo9G7QAJuiE94wVoyWMep9GmdIuG9e94CLmvW4fPV/rBpprwhulMXN+yow72h3PLDMqW7Po6oF++53OGCcOgLTvDRuKvgHN2clhEiUnMx9q0SPOLlen9vHOBmV855lik+Fl/wSDtMF3PuTEkUkMykXlu9P3P5t1APGPccBl1scMtVuG4DtAcOA9EYpT5kmXa/0F+mKyep5rXfQuIEkfjBtxy1q93Pc3I1RbdaYSpzRlSwC82W+EeqMkHZ8d9W5542F5n3lYtAEZ6AN3yr0M7YKRhVy6wGbu0H9t/4zVkDFgbm2KfasfBAIuAEHkracDX3AZJMwSgjRlCRVWidLP5KkV/zIgDTT4FMY/qIEreA5+spMwawUGmy40Va+UyYqTx7QnKMfLLhlEq9X+CoPra5seLtydIQDiiMJRFL/O9B5qWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/signal.h | 3 ++-
 kernel/fork.c          | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/signal.h b/include/linux/signal.h
index f19816832f05..a0c7fee8b22a 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -323,7 +323,8 @@ static inline void disallow_signal(int sig)
 	kernel_sigaction(sig, SIG_IGN);
 }
 
-extern struct kmem_cache *sighand_cachep;
+extern struct kmem_cache_opaque sighand_cache;
+#define sighand_cachep to_kmem_cache(&sighand_cache)
 
 extern bool unhandled_signal(struct task_struct *tsk, int sig);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 8c4d9a81ef42..d5b7e4d51596 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -469,7 +469,7 @@ static struct kmem_cache_opaque signal_cache;
 #define signal_cachep to_kmem_cache(&signal_cache)
 
 /* SLAB cache for sighand_struct structures (tsk->sighand) */
-struct kmem_cache *sighand_cachep;
+struct kmem_cache_opaque sighand_cache;
 
 /* SLAB cache for files_struct structures (tsk->files) */
 struct kmem_cache_opaque files_cache;
@@ -3021,7 +3021,7 @@ void __init mm_cache_init(void)
 
 void __init proc_caches_init(void)
 {
-	sighand_cachep = kmem_cache_create("sighand_cache",
+	kmem_cache_setup(sighand_cachep, "sighand_cache",
 			sizeof(struct sighand_struct), 0,
 			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_TYPESAFE_BY_RCU|
 			SLAB_ACCOUNT, sighand_ctor);
-- 
2.47.3


