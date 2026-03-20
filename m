Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7081B10987A2
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A08B46B00BA; Fri, 20 Mar 2026 12:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DFEB6B00D0; Fri, 20 Mar 2026 12:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F5C96B00E2; Fri, 20 Mar 2026 12:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACE46B00BA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:02:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0A8AB1B70D0
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:02:49 +0000 (UTC)
X-FDA: 84566909658.05.CE076FE
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE4CB2001E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:02:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=caf6z9FS;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774022567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7ZfAXqwDgdi9D6nn4G4hHw5dK24nZatfJR8ErV3Cgbk=;
	b=iNDunzvfA/vEfTXKYUAxFdrEX5RzLVGQWO3zLtgiMoR9eiSBX6bKR1u1DgSDeSrnsVGBcZ
	xjCCZhZmQzjFssx2JFHJerzVL7JhTtwAqWnOOwbiE9LU/CCbWr0NRUevhCJlDe5N/u9TZH
	MpM7bbFSjhX7N0cfQfOMdHmaD8ClwRM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=caf6z9FS;
	spf=pass (imf03.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774022567; a=rsa-sha256;
	cv=none;
	b=CNKe/J9+x/ztQZCaAssZurKu8SSUVNgnmOLZZ77C1t+7/MEsnOkLfXW1S1/22zT9P877rX
	551FuziJ0A3TTaGV7IG4FdiQOccP1w/u/aEGdOcv2GNJS1RPc2Nmxx505Px7c/Ia7pR0fZ
	vlQEsWd0uR5wiKAAwRYZtn8QCzba3lk=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-506251815a3so17923941cf.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774022565; x=1774627365; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZfAXqwDgdi9D6nn4G4hHw5dK24nZatfJR8ErV3Cgbk=;
        b=caf6z9FSkZPX3QPkYr3ttiiVtRtU2afeUjB9O4B51TxQvqYF1zClywJRBfv7MIOKqG
         Xvy/i7ZigeqEZ2TWSmDW5tziLpLA5OaGAeIgoFc7hVUHYU616cyy4iOGXiyST9SbY1BH
         dWYmMXNCCQ+yj5nc5wdszsGso5MQXV1WoXfyOldXHbxfFC23GPrMANdgfEu3Xhas8tcO
         d7Wr2oNn8nfiIwq36heQ7wE6aK+c4+5RY/EazPa8yRghlVxrW3KyVVYkUtKsY+/eE5gt
         ZYGVwIlatbi6BX/V0NwBWRp81w2HKa+c2kfl0mNz9A6B0LL9C3qOhoWPkMjDlasTbjTU
         428A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774022565; x=1774627365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZfAXqwDgdi9D6nn4G4hHw5dK24nZatfJR8ErV3Cgbk=;
        b=dXZQ4OxTL8X+vinqzD84uPez0H7xkr4FWNNAwWawVZDt+f75QwlVdESpyq8FQs3/er
         GlqRNlV44BmjAth+2Lz5awwRXd/06sU3aDDUz6oEqocuQ4gwmDktGP1S75E2kpXSz41W
         SmnvTLl+LJVVnInkNH9XdNTlg48h5jwED5R+d4uB/AxJNve8EAaJefzPK7llbHRFk3VP
         XiyItWKI+Zf+cfUiZEXVDDGyrJWKGfAgescV8wJT5Ep70SuKqe+dzOM49HV6mF74Su8J
         xrli4/ifw+T0wAQQA1tsblDuQsXZC5okV7TzMZy3/5JHjgNQDdLziNmmeifrebXlGr22
         oa6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVaIhTSzWavX99xoK2LKMvKBvpD9eAqsNrrXrlbudTkGdON7XxTcq0eODlenyC9zDDdv2dETx8fUA==@kvack.org
X-Gm-Message-State: AOJu0YyM9bOsPwVeRIt4jPoOjXFpPNiRyLZOIQCxX4s1a7gSNAGYRbxX
	9wq0CC6wmBwfFGJx+akeL6xBqygYmvZ6BbduHaom7Mgu2C2c4qKG4WOdLrODTA3Yh0I=
X-Gm-Gg: ATEYQzwze6rx6R4VyeEb4OhS+NedX3m2B6RjN+XQ9rUHUt9BMWSlP07q4ABYlim0rQ4
	g15Z6jtbCgLPb8F7B9qNugF606zdSMAl0D/doXBAJxRf8SaWDkkndXJMaNB14gjiG0IDR7F8EQF
	dklnaJRwHkNwp9fw+LfzAWXDzVJk+Xbj7j4LtGwZP6luPY/nWlwysdlwblprPx7A+D5u0UPSDJt
	M/b5xhbn8fsS3/9WDtDk/jh3NZaLiRYTemkTq8SH37hALNSRPDgXPWd0d7b/6Po5robRoQSAKu2
	81P2c8R7mMivknCI4jvPnxNKXjVmU1pHgp0OLjQbBaCPwrOVpEVOyS08bOuM+t6rs0UMumiy6a/
	bmOoJVLMkOMuxvsL+xR6ib0U/SCBXg4lKyp45y95WToyS9M52WManfzCgGr314NAeaMdh/UU4ed
	SlAorxfqQUV65Yma8dad+ouA==
X-Received: by 2002:a05:622a:4d0d:b0:50b:37a1:a013 with SMTP id d75a77b69052e-50b37a1b505mr52027721cf.40.1774022565254;
        Fri, 20 Mar 2026 09:02:45 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b36cf542dsm21705691cf.7.2026.03.20.09.02.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2026 09:02:44 -0700 (PDT)
Date: Fri, 20 Mar 2026 12:02:38 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/7] mm: switch deferred split shrinker to list_lru
Message-ID: <ab1vnhL4XftNdTSu@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <20260312205321.638053-8-hannes@cmpxchg.org>
 <61d86249-cd89-4e99-99d8-ab7c72e95f34@kernel.org>
 <absr1vgNP_tM1OEP@cmpxchg.org>
 <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9631520-857f-4f67-8944-6af7a2b47e89@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: AE4CB2001E
X-Rspamd-Server: rspam08
X-Stat-Signature: 93i9khqtyhcqfyo46jyxba5jjhid4rxq
X-HE-Tag: 1774022566-518808
X-HE-Meta: U2FsdGVkX1+0TrF10nsT1M+1ccunIIThNmV/M/FUIWeZyTxV94PsP4/q+I8pUraBS1A4l8jlvHO/Wyt0EAuhITJ2o7rx+/LTiBbZGe2jUSCR6PulVhbMTpbfsh9df1PpYsDvAjTdXfA5/ryisvKZKhKXJGBUF96fYfMXEFZauWCfES2xWaz0AxaivaERLiHdZcWI3JO6pS4q9j5xmJ6Ya2bJelSKYU2p/Je/pBcw7jy+SeKtIgH1rl2oEgXaUMgtyYhz48idyk4Qgzy9z8iXmjHdukASovfmO6l8i5u/M3e9vTD7PWNOFSvazIN9D7PHblSU5DHxnr4IGY/DKtOUnaU5bspZWU/6wb40f3Daam33sI4Ns7zMfF+tHufSBnrGzCLKd2X+b0VfJYgYZMZFiYyffyI6mZwQGdxLvnYGSZtseFZQptZn9+ERn7by/wwTtO1I8U5800E3HmeSNw2MkdTomUUqvdlsOzU+6CGUJW0Os9Phap5dkBiGtrVYB6r49lV7W80CgsjW5E3mx/Ol28gsBfMIGrjhYxIR6LuaFicyaM+wKytrUPPVwAGulNVoGSQWNgptA7MJ3QSXg2frWrfolFJNeAZubb9kShDy85QqGYPADDVtQM9LcEeaboEcdN2mGL+hWM0EL9sBK0ttdeZd39eLUgEvo6k8/TL3f7P2z1Ttkpecxk2GCpRW5LWKqmE+KajCSKuHsegC/PQcZD5tulxjHSHAjNfkhng8SIGEDU+NVO1bqf6LngKWhvAUxoW0RzVCj1nMSLZtNjHTMEGDMsIM17G8IjpKkPmHV/sqvOqlO5WCd++SwBg7Xh6h0qlDz3Vxpb74NhfrZy6zEwCi+q0Q5eUfUyrf1zdTLVhNPaI6f9bje7vV+Ot3abfU9T+5UOvAaHXNvezhHZ7BRcayNiAsfb6WLd00akgm7xFBmeFuKYLPgKjREWitudUTlhsLV04FM/IlCp+VWll
 qUHMP+CN
 DZJSQNmJ3OR8fQ4aN6a1ZC7lO3bo4dMy/beJwOqhIhIP3nFnsrveK9kLV/8KjsfvPUJaS9r9Or94EHwn7trSiPPbWkgvg1q+qC3js6VQZcv+AMBTSeHcfT3X0nVnwpQfP0JnWTG6YMuE6/t2v/pAY7JUe91DkPH2B56HIPwZVYi1e5v/5QxG7oknfpWiwV677CrCIVKB/cVbzU4tBhyW6IoMcjrLYAd00ZfPgdUIdlovkPs7sk+z00mmKVQfMMnwmWWQYYbuKlnCbOcV7McWxl39i6++LBHeEaYFcLsopX2WWtnoFtizAnv/MRfShTndJSjTt+SXPc92wF0hUWLWvhyPvUBb2+nlONbztZ8ZIqjJa4VPAVNpg17fk0f/RUxLGgt0nT2xAZaN2ApdwCCM+vxp3AJX3EcVGqe3xwxqpl/MFFS4V1uE/FS9JmVBKfyCxSS/uqqXBlEuPKFbpwg3CnTXfgS2e1tip9dd+uXNW1NBQqH4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 08:21:21AM +0100, David Hildenbrand (Arm) wrote:
> >>> @@ -3802,33 +3706,28 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
> >>>  	struct folio *new_folio, *next;
> >>>  	int old_order = folio_order(folio);
> >>>  	int ret = 0;
> >>> -	struct deferred_split *ds_queue;
> >>> +	struct list_lru_one *l;
> >>>  
> >>>  	VM_WARN_ON_ONCE(!mapping && end);
> >>>  	/* Prevent deferred_split_scan() touching ->_refcount */
> >>> -	ds_queue = folio_split_queue_lock(folio);
> >>> +	rcu_read_lock();
> >>
> >> The RCU lock is for the folio_memcg(), right?
> >>
> >> I recall I raised in the past that some get/put-like logic (that wraps
> >> the rcu_read_lock() + folio_memcg()) might make this a lot easier to get.
> >>
> >>
> >> memcg = folio_memcg_lookup(folio)
> >>
> >> ... do stuff
> >>
> >> folio_memcg_putback(folio, memcg);
> >>
> >> Or sth like that.
> >>
> >>
> >> Alternativey, you could have some helpers that do the
> >> list_lru_lock+unlock etc.
> >>
> >> folio_memcg_list_lru_lock()
> >> ...
> >> folio_memcg_list_ru_unlock(l);
> >>
> >> Just some thoughts as inspiration :)
> > 
> > I remember you raising this in the objcg + reparenting patches. There
> > are a few more instances of
> > 
> > 	rcu_read_lock()
> > 	foo = folio_memcg()
> > 	...
> > 	rcu_read_unlock()
> > 
> > in other parts of the code not touched by these patches here, so the
> > first pattern is a more universal encapsulation.
> > 
> > Let me look into this. Would you be okay with a follow-up that covers
> > the others as well?
> 
> Of course :) If list_lru lock helpers would be the right thing to do, it
> might be better placed in this series.

I'm playing around with the below. But there are a few things that
seem suboptimal:

- We need a local @memcg, which makes sites that just pass
  folio_memcg() somewhere else fatter. More site LOC on average.
- Despite being more verbose, it communicates less. rcu_read_lock()
  is universally understood, folio_memcg_foo() is cryptic.
- It doesn't cover similar accessors with the same lifetime rules,
  like folio_lruvec(), folio_memcg_check()

 include/linux/memcontrol.h | 35 ++++++++++++++++++++++++++---------
 mm/huge_memory.c           | 34 ++++++++++++++++++----------------
 mm/list_lru.c              |  5 ++---
 mm/memcontrol.c            | 17 +++++++----------
 mm/migrate.c               |  5 ++---
 mm/page_io.c               | 12 ++++++------
 mm/vmscan.c                |  7 ++++---
 mm/workingset.c            |  5 ++---
 mm/zswap.c                 | 11 ++++++-----
 9 files changed, 73 insertions(+), 58 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 0782c72a1997..5162145b9322 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -430,6 +430,17 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 	return objcg ? obj_cgroup_memcg(objcg) : NULL;
 }
 
+static inline struct mem_cgroup *folio_memcg_begin(struct folio *folio)
+{
+	rcu_read_lock();
+	return folio_memcg(folio);
+}
+
+static inline void folio_memcg_end(void)
+{
+	rcu_read_unlock();
+}
+
 /*
  * folio_memcg_charged - If a folio is charged to a memory cgroup.
  * @folio: Pointer to the folio.
@@ -917,11 +928,10 @@ static inline void mod_memcg_page_state(struct page *page,
 	if (mem_cgroup_disabled())
 		return;
 
-	rcu_read_lock();
-	memcg = folio_memcg(page_folio(page));
+	memcg = folio_memcg_begin(page_folio(page));
 	if (memcg)
 		mod_memcg_state(memcg, idx, val);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 
 unsigned long memcg_events(struct mem_cgroup *memcg, int event);
@@ -949,10 +959,9 @@ static inline void count_memcg_folio_events(struct folio *folio,
 	if (!folio_memcg_charged(folio))
 		return;
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	count_memcg_events(memcg, idx, nr);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 
 static inline void count_memcg_events_mm(struct mm_struct *mm,
@@ -1035,6 +1044,15 @@ static inline struct mem_cgroup *folio_memcg(struct folio *folio)
 	return NULL;
 }
 
+static inline struct mem_cgroup *folio_memcg_begin(struct folio *folio)
+{
+	return NULL;
+}
+
+static inline void folio_memcg_end(void)
+{
+}
+
 static inline bool folio_memcg_charged(struct folio *folio)
 {
 	return false;
@@ -1546,11 +1564,10 @@ static inline void mem_cgroup_track_foreign_dirty(struct folio *folio,
 	if (!folio_memcg_charged(folio))
 		return;
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	if (unlikely(&memcg->css != wb->memcg_css))
 		mem_cgroup_track_foreign_dirty_slowpath(folio, wb);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 
 void mem_cgroup_flush_foreign(struct bdi_writeback *wb);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e90d08db219d..1aa20c1dd0c1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3769,9 +3769,10 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	/* Prevent deferred_split_scan() touching ->_refcount */
 	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
 	if (dequeue_deferred) {
-		rcu_read_lock();
-		l = list_lru_lock(&deferred_split_lru,
-				  folio_nid(folio), folio_memcg(folio));
+		struct mem_cgroup *memcg;
+
+		memcg = folio_memcg_begin(folio);
+		l = list_lru_lock(&deferred_split_lru, folio_nid(folio), memcg);
 	}
 	if (folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
 		struct swap_cluster_info *ci = NULL;
@@ -3786,7 +3787,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 					MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 			}
 			list_lru_unlock(l);
-			rcu_read_unlock();
+			folio_memcg_end();
 		}
 
 		if (mapping) {
@@ -3891,7 +3892,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	} else {
 		if (dequeue_deferred) {
 			list_lru_unlock(l);
-			rcu_read_unlock();
+			folio_memcg_end();
 		}
 		return -EAGAIN;
 	}
@@ -4272,12 +4273,13 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	int nid = folio_nid(folio);
 	unsigned long flags;
 	bool unqueued = false;
+	struct mem_cgroup *memcg;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
 	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
-	rcu_read_lock();
-	l = list_lru_lock_irqsave(&deferred_split_lru, nid, folio_memcg(folio), &flags);
+	memcg = folio_memcg_begin(folio);
+	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
 	if (__list_lru_del(&deferred_split_lru, l, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
 			folio_clear_partially_mapped(folio);
@@ -4287,7 +4289,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 		unqueued = true;
 	}
 	list_lru_unlock_irqrestore(l, &flags);
-	rcu_read_unlock();
+	folio_memcg_end();
 
 	return unqueued;	/* useful for debug warnings */
 }
@@ -4322,8 +4324,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 
 	nid = folio_nid(folio);
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	l = list_lru_lock_irqsave(&deferred_split_lru, nid, memcg, &flags);
 	if (partially_mapped) {
 		if (!folio_test_partially_mapped(folio)) {
@@ -4339,7 +4340,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	}
 	__list_lru_add(&deferred_split_lru, l, &folio->_deferred_list, nid, memcg);
 	list_lru_unlock_irqrestore(l, &flags);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 
 static unsigned long deferred_split_count(struct shrinker *shrink,
@@ -4445,16 +4446,17 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 		 * don't add it back to split_queue.
 		 */
 		if (!did_split && folio_test_partially_mapped(folio)) {
-			rcu_read_lock();
+			struct mem_cgroup *memcg;
+
+			memcg = folio_memcg_begin(folio);
 			l = list_lru_lock_irqsave(&deferred_split_lru,
-						  folio_nid(folio),
-						  folio_memcg(folio),
+						  folio_nid(folio), memcg,
 						  &flags);
 			__list_lru_add(&deferred_split_lru, l,
 				       &folio->_deferred_list,
-				       folio_nid(folio), folio_memcg(folio));
+				       folio_nid(folio), memcg);
 			list_lru_unlock_irqrestore(l, &flags);
-			rcu_read_unlock();
+			folio_memcg_end();
 		}
 		folio_put(folio);
 	}
diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1ccdd45b1d14..638d084bb0f5 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -604,10 +604,9 @@ int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
 		return 0;
 
 	/* Fast path when list_lru heads already exist */
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	res = memcg_list_lru_allocated(memcg, lru);
-	rcu_read_unlock();
+	folio_memcg_end();
 	if (likely(res))
 		return 0;
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f381cb6bdff1..14732f1542f2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -965,18 +965,17 @@ void lruvec_stat_mod_folio(struct folio *folio, enum node_stat_item idx,
 	pg_data_t *pgdat = folio_pgdat(folio);
 	struct lruvec *lruvec;
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	/* Untracked pages have no memcg, no lruvec. Update only the node */
 	if (!memcg) {
-		rcu_read_unlock();
+		folio_memcg_end();
 		mod_node_page_state(pgdat, idx, val);
 		return;
 	}
 
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	mod_lruvec_state(lruvec, idx, val);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 EXPORT_SYMBOL(lruvec_stat_mod_folio);
 
@@ -1170,11 +1169,10 @@ struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 	if (!folio_memcg_charged(folio))
 		return root_mem_cgroup;
 
-	rcu_read_lock();
 	do {
-		memcg = folio_memcg(folio);
+		memcg = folio_memcg_begin(folio);
 	} while (unlikely(!css_tryget(&memcg->css)));
-	rcu_read_unlock();
+	folio_memcg_end();
 	return memcg;
 }
 
@@ -5535,8 +5533,7 @@ bool mem_cgroup_swap_full(struct folio *folio)
 	if (do_memsw_account() || !folio_memcg_charged(folio))
 		return ret;
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		unsigned long usage = page_counter_read(&memcg->swap);
 
@@ -5546,7 +5543,7 @@ bool mem_cgroup_swap_full(struct folio *folio)
 			break;
 		}
 	}
-	rcu_read_unlock();
+	folio_memcg_end();
 
 	return ret;
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index fdbb20163f66..a2d542ebf3ed 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -672,8 +672,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 		struct lruvec *old_lruvec, *new_lruvec;
 		struct mem_cgroup *memcg;
 
-		rcu_read_lock();
-		memcg = folio_memcg(folio);
+		memcg = folio_memcg_begin(folio);
 		old_lruvec = mem_cgroup_lruvec(memcg, oldzone->zone_pgdat);
 		new_lruvec = mem_cgroup_lruvec(memcg, newzone->zone_pgdat);
 
@@ -700,7 +699,7 @@ static int __folio_migrate_mapping(struct address_space *mapping,
 			mod_lruvec_state(new_lruvec, NR_FILE_DIRTY, nr);
 			__mod_zone_page_state(newzone, NR_ZONE_WRITE_PENDING, nr);
 		}
-		rcu_read_unlock();
+		folio_memcg_end();
 	}
 	local_irq_enable();
 
diff --git a/mm/page_io.c b/mm/page_io.c
index 63b262f4c5a9..862135a65848 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -239,6 +239,7 @@ static void swap_zeromap_folio_clear(struct folio *folio)
  */
 int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 {
+	struct mem_cgroup *memcg;
 	int ret = 0;
 
 	if (folio_free_swap(folio))
@@ -277,13 +278,13 @@ int swap_writeout(struct folio *folio, struct swap_iocb **swap_plug)
 		goto out_unlock;
 	}
 
-	rcu_read_lock();
-	if (!mem_cgroup_zswap_writeback_enabled(folio_memcg(folio))) {
+	memcg = folio_memcg_begin(folio);
+	if (!mem_cgroup_zswap_writeback_enabled(memcg)) {
 		rcu_read_unlock();
 		folio_mark_dirty(folio);
 		return AOP_WRITEPAGE_ACTIVATE;
 	}
-	rcu_read_unlock();
+	folio_memcg_end();
 
 	__swap_writepage(folio, swap_plug);
 	return 0;
@@ -314,11 +315,10 @@ static void bio_associate_blkg_from_page(struct bio *bio, struct folio *folio)
 	if (!folio_memcg_charged(folio))
 		return;
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	css = cgroup_e_css(memcg->css.cgroup, &io_cgrp_subsys);
 	bio_associate_blkg_from_css(bio, css);
-	rcu_read_unlock();
+	folio_memcg_end();
 }
 #else
 #define bio_associate_blkg_from_page(bio, folio)		do { } while (0)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 33287ba4a500..12ad40fa7d60 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3407,6 +3407,7 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 				   struct pglist_data *pgdat)
 {
 	struct folio *folio = pfn_folio(pfn);
+	struct mem_cgroup *this_memcg;
 
 	if (folio_lru_gen(folio) < 0)
 		return NULL;
@@ -3414,10 +3415,10 @@ static struct folio *get_pfn_folio(unsigned long pfn, struct mem_cgroup *memcg,
 	if (folio_nid(folio) != pgdat->node_id)
 		return NULL;
 
-	rcu_read_lock();
-	if (folio_memcg(folio) != memcg)
+	this_memcg = folio_memcg_begin(folio);
+	if (this_memcg != memcg)
 		folio = NULL;
-	rcu_read_unlock();
+	folio_memcg_end();
 
 	return folio;
 }
diff --git a/mm/workingset.c b/mm/workingset.c
index 07e6836d0502..77bfec58b797 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -251,8 +251,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH >
 		     BITS_PER_LONG - max(EVICTION_SHIFT, EVICTION_SHIFT_ANON));
 
-	rcu_read_lock();
-	memcg = folio_memcg(folio);
+	memcg = folio_memcg_begin(folio);
 	lruvec = mem_cgroup_lruvec(memcg, pgdat);
 	lrugen = &lruvec->lrugen;
 	min_seq = READ_ONCE(lrugen->min_seq[type]);
@@ -261,7 +260,7 @@ static void *lru_gen_eviction(struct folio *folio)
 	hist = lru_hist_from_seq(min_seq);
 	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
 	memcg_id = mem_cgroup_private_id(memcg);
-	rcu_read_unlock();
+	folio_memcg_end();
 
 	return pack_shadow(memcg_id, pgdat, token, workingset, type);
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 4f2e652e8ad3..fb035dd70d8b 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -895,14 +895,15 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
 	 * to the active LRU list in the case.
 	 */
 	if (comp_ret || !dlen || dlen >= PAGE_SIZE) {
-		rcu_read_lock();
-		if (!mem_cgroup_zswap_writeback_enabled(
-					folio_memcg(page_folio(page)))) {
-			rcu_read_unlock();
+		struct mem_cgroup *memcg;
+
+		memcg = folio_memcg_begin(page_folio(page));
+		if (!mem_cgroup_zswap_writeback_enabled(memcg)) {
+			folio_memcg_end();
 			comp_ret = comp_ret ? comp_ret : -EINVAL;
 			goto unlock;
 		}
-		rcu_read_unlock();
+		folio_memcg_end();
 		comp_ret = 0;
 		dlen = PAGE_SIZE;
 		dst = kmap_local_page(page);

