Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62204C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 09:32:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18AF96B0096; Tue, 14 Jul 2026 05:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 118546B0098; Tue, 14 Jul 2026 05:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F221D6B0099; Tue, 14 Jul 2026 05:32:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB46E6B0096
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 05:32:20 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 554C9C02DC
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:20 +0000 (UTC)
X-FDA: 84986866440.09.CB8B846
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id A61B7140003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:32:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CG2fnK4O;
	spf=pass (imf26.hostedemail.com: domain of 3IQJWaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IQJWaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784021538;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vZCDTy++eofJtCdYVj/00BJntfZC5+UGNjKSKN7oKjA=;
	b=FA5UM0oR3gIMo0rKaxMWH58eEmzyQjzBCGMhAjWQ3xM7TBFVxurfowpvrB/eTxprHmRP36
	9xcz/tIuApPMZ9dSBqU92BqqAtQOw6kgAn0rah/qZVN5I3+0C2tLXH3k12k1AltDAUWm6F
	76pcl6dhcNIT3b3eiP7kBhCOBSwMb1s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CG2fnK4O;
	spf=pass (imf26.hostedemail.com: domain of 3IQJWaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3IQJWaggKCNYB24CE2F38GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784021538;
	b=ZPtSgO0ZKgLaqvGHwQUV2lMRpM0Y2Jn0PNWQ/Hwcp4RMp/RM7bQVfjkJqWSXvo1uMz50EO
	j+qvJb+XqkaYgW6LxiBLDZBF56cLIZvB1TrsDu4yGIuH4bgvMSxZCuNYEJPetkf5U26SeS
	zs9I+CCc9r1gfSAfatbgI1jMqysRtaE=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-473ac08a6a4so2424640f8f.0
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 02:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784021537; x=1784626337; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vZCDTy++eofJtCdYVj/00BJntfZC5+UGNjKSKN7oKjA=;
        b=CG2fnK4OlONvDWJAg6Oh7xBhbHNQquzi4DXebNh29gtq9F4FlsF/CFe6pf4PTnRxjF
         V+MHxLBg4fM0Plny61JreBCv6WeH0SOiy19WMGEBjFnIHPMa4rNxkDRZpJNiQvM3HlmF
         eMcqqPwk2UKs6iOMbXfFp4Y4XHrH9Hgvyonhi1EIWySpU5ZiNqsckPbmPGCmN2uAJ7To
         EiGFCoQl6CtDS+fqi116gxM90Pebywb8F0yRbp6XEJR5hwj32aJqZJWPIF7rCa4xpCpC
         NPv8/kNwGYd59A16A/C8lN2KPOSlOlZYhPEIjk8woQaZoKGMxxe21mUG23RuAC8Iarcu
         HEmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784021537; x=1784626337;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vZCDTy++eofJtCdYVj/00BJntfZC5+UGNjKSKN7oKjA=;
        b=jUy62UmxY2ic/wnzkfBXNzv6a4ErHHjIBSzRSQDBqioznqqEOLYy8UzI77Svu2gyTi
         xfZKCxNlRrUSiuByuRjUuQnroY1BL5F0zkpE/eIQSJP6R8lLHbZ8VtjxD2KPRNRnwDrQ
         BT/W3ZcYRI2AgOIMRwrgQLHY7i9glocRg4rhPj2xfxh6rR7SxSTGfCWrV75zq9WXQ8SM
         lXNVPhLT0RffhNpeygQwhhKsVSytOeM4jM3cmyK9oAvVj+i1PUZvi+ACGdICRi4czZfk
         UFfCIpQjgbIk6WWVWDZ2fXJWS+cvd5X5jdhHCAt1CqQ2linMIHAvdxlPv8rshpbRMch9
         MPHw==
X-Gm-Message-State: AOJu0Yx6v5mJUppzuwD3Tcuh7o5RQ8xlM43Gz8LROiA2WH3brP6LTUVU
	LMhUIOnPkifnIWjd13Obe4dMtiglIGi3TaovsYG0wjyrXXeoIMYGhKMA2nyhyxQWbA5iorXpRi0
	LtbPHgKS0YWQsRA==
X-Received: from wmcv10.prod.google.com ([2002:a05:600c:428a:b0:493:bc21:e2be])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5297:b0:492:454c:347c with SMTP id 5b1f17b1804b1-494013134aemr75960445e9.7.1784021537240;
 Tue, 14 Jul 2026 02:32:17 -0700 (PDT)
Date: Tue, 14 Jul 2026 09:32:01 +0000
In-Reply-To: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
Mime-Version: 1.0
References: <20260714-spin-trylock-followup-v2-0-3c20ed032b14@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260714-spin-trylock-followup-v2-3-3c20ed032b14@google.com>
Subject: [PATCH v2 3/4] mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	sashiko-bot@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: f98fa5wmdbt863dzkgb81y91acz1hgc3
X-Rspamd-Queue-Id: A61B7140003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784021538-939562
X-HE-Meta: U2FsdGVkX1+EmSltaJVIgRHYK0DZ0ATJdFfH79RkaZNPhvk8z9XU6LcpyReg6qAc5fTUdzu+Nrk2pgFeZFhG+mrWkcE9Ovp0FHOLb7+QvWJTS5H9AgOWbbYYPwN/qeRIjsYdwZewFdlT6Pzc+a4DncbMgGAVA0F5YlynO5kk3rnt3eLvdQv4R7VEg67ulU3pYV6FM7C2NsicK5Ww/miZCGpn8+tCM6lXMSwCU9NujZ7xpGxxsKYh9uoK7BcfR+F1xsTHRYhMU0VBZFKO1fqb/2c5GNNX93BvYTjp5u7WOuUG3tlTy7S+oMIr7UOMQnHuw84FiANIcQs0MxHzfWdObXd4I00qgO6olPwtmk6D6ww14eGYwoCQ5NRfzuJWgQpQ3C7EGLufexK56Alg2VxxERQeCYpiS9YivQsJjDDqb+Ne73ZDR0hIkNsWZq13Ucm3rKriE0zHZNpP18r8pIZKlgEw3OjADfbBGfTSGl/iGHzWlndjlNNSLuncHIQXDrYz4sKdczvxOkyQ4NHpDZPyc/8bdhtVPdVHPwkyJM3+TaiYKaSXp6ti+l+EO3XwfiGLI4IFRXsYjNPKDJYDAzDgNgUElNZUqXYS0uNneOukNTMYE62RaO2cyXWKgmg9GK2nj+fTB6ryQMdbKPEShlSzqTuX6kSk2B1xvupDg9S0Fpgv2SWCSTFGv1klMVy+FYR7Hvdc5WrcfeaILHMKVW0qpT/hMgWo6I2KdHKyUKmozxxee3hi+YOQG9i84+JbEEXAbT6zJK5Of2ru5z67umanRpgJdAQVg5iqLt8LBCJEbpB4oPEguApSNOgc2672ODDIkcTXWxaThsaWk8Qz8zndb4MRCBVox8cPuDRAwoUlJdu6Dh2D4AOVQV1r3G/PRb0lhtio0NuZQBDgFT1njlxZPnkEKvKbekYJoPVbw4f4sWT8t0K6jy+e7QThQFkzVmSQ9S3pARo+GdvZesyV87a
 BSbSJoM5
 /Pgx/IDjll1BoBT1GdlZ7W5GliMJrecKH2ZNfYwOQJ0rLJguSrAQrAn3xt7zRGZdwwD8gvWRNe6q2+CJyYApd83iFnQUqaZvmZKhTW649nr1KtNYY25J0kSsYDv29JXBY4sGVEeXFsL9rGKnMEEVVDIoLrZzRkGzpAEpXvgEJGaPxsyd8bHdpgQz9kJ5n6q+MQ8e7jqNnf5kN/A45YPH5374Q06A3bfvDFSp+46QngTkR/ihqiu4XvLv2/zMz1nm5MGb2nZ2fAzw+5iUkDws6VrVy/xHznZbFwCEGCr1hPxp5Cd7VrgLkiOJn3QpmIoFM1vnYM06SSgIDSy6R12bH8BgS2oN3XJ6gnrfDSc83W2bO91NLf49kdmz71FQ5Y7XKxqt2tf35gzE9cqtoqW3q4FAusqLykEez2ASDlEtOQF8msdvgyWoG8UfPqqVnXfgcYYqii0ymc6jCEBO5eyD6CyIb5XGhb6ePnHAKxBdlBnT4dkcPX4AKgQKO3GSzvGq2572kJDiAB+LrpkkLjLsT2A7zhau2vbdPUDQJ80haFme6H0yhzGSY5gzRfHAuyb7qDXoP3NPzXonq/z7JNg+Pz3hdl7oAdgydDtJhsIc2jIbfNfoM2aqpc5te1vOHwOjcdiZ5pZ6LxAJrdSMoKDvOXxAcJ2PCz+ah+lGoolelPY1PI8Ygu1imZ5ITwoV2AcZARGcNse7NW7F44fBjFgBhTE8LAt9ayjla48CD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the comment to reflect the recent change to allow flags in
gfp_nolock.

Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index f3f08d0313cfc..d53f858e518f7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7994,7 +7994,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, plus some flags that get set
+ *             internally regardless (see @gfp_nolock) are allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *

-- 
2.54.0


