Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCE8DCA6017
	for <linux-mm@archiver.kernel.org>; Sat, 10 Oct 2026 09:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDF8D6B008C; Sat, 10 Oct 2026 05:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7886B0092; Sat, 10 Oct 2026 05:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCCE46B0095; Sat, 10 Oct 2026 05:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 904E16B008C
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 05:41:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F703805CB
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:41:54 +0000 (UTC)
X-FDA: 85306224948.18.FC39578
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 68E6F20009
	for <linux-mm@kvack.org>; Sat, 10 Oct 2026 09:41:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W593tBr+;
	spf=pass (imf13.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791625312;
	b=Psu0hsCrK4YbffGoqxVTaNruUbeA5hu3nRmOEaD4xPvYf4J8sJV/m41B4PJT4eu3NBEIy6
	Wzkb9md5nt/rCTNS12GGOrgeOsC3CizDhyPunkbDncLmBJS8mJ7tYgXQgSjdve301f/+Q0
	FG9I9o8CpfJiKJk1awSopL05h2aTFyI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W593tBr+;
	spf=pass (imf13.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791625312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NDFNhU8esL7rlE9mU0Mv+uA5ZLgqKd4fX2GtWZW3Ak0=;
	b=QLFl7FaLFGFLwoNzOXmx8UXJ6qmiNDZFfg8tgSlyCTf+5pGxbh8+ugVH/TLPpDh815AkkT
	rdcq3ZqRHnNW9w0Fr/DrcrlPxAldFDiCpf/SD944W26QQ5UPW79bOd8aKWWM4VW8NRtZKF
	ilGSgRtWbT/2rY9hvQSLv+k5Dm8zgKc=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-35834f72d94so705329eec.0
        for <linux-mm@kvack.org>; Sat, 10 Oct 2026 02:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791625311; x=1792230111; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NDFNhU8esL7rlE9mU0Mv+uA5ZLgqKd4fX2GtWZW3Ak0=;
        b=W593tBr+iMHFDDP077qdKHqmsvyxLR39vEAFxnWd/HXZlqQJVmwHFNOU8cLpCWQs1E
         5dFTaUbEPd70EYc6D/JJszQnzUpUjp9q0Sh53YoTG6KbomDT3hNOG0d/QvIm0CKIkJW4
         eFq3dz3TpW9hntUUoK1sOZuKTqGSUaFTy0pVMadlnH1O39ONxM+QQOMsJGN00S2VeZQp
         wTXJWoXtRBAPNdAQGNNob0OA2CYo45Uv5fdB0E427Oe4WtZLtOZ4FH5TDYJuPhkxVgE6
         HiHAO/ZehhCKqM3nL+vxYha1eRGYJtSjfaN5RR/hpgftRBwUgzKRQBmhDIo5OLaisOxF
         EaIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791625311; x=1792230111;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NDFNhU8esL7rlE9mU0Mv+uA5ZLgqKd4fX2GtWZW3Ak0=;
        b=lEFKuL6tUQLDFqEKkMBE2xJEK2oQouzYYVhsdgRvX+unUASeBuVSrqOEgENZ5tKg8z
         WLyTE+L40w1dMsnHj7WN9OWIduVlHWL4HCeLhfNujsHeqDZw79Eqvrge7qoVy8sIPWPl
         Irdrlkpu9sLl4Y2jIOronyr6WaOh/RkS6UvDuR2FmhSB/nTzWOzVkCOCjVoGU1Ydq5da
         ERfJRtMPaFFtKiuZSD9YSWqAP2vFDLBHe+cqocSGstdIiFWjIEj1fkzm4r7ouMu7TvlN
         Wm/55AcCn8cL7zhiWLPkqHiGHXiuHYpS798DmPHq9pD/wCoiF2BSK9/UGqlqLmuTMles
         U8XA==
X-Forwarded-Encrypted: i=1; AKwUvBzDUMdIeMLwfTBevBdjFr57dcfvWohL4abWYbyuK6TyTurvAcGgbSn+gUiJ51OakBj/+CUnWzAp9w==@kvack.org
X-Gm-Message-State: AFq9FYI7Q8ALnlzPhduZN5dElzRGW16O5at1cOUOL75ILA1aZH/LCAJW
	ZmeTHcb3IIMMw3D0ybDFkdVdCaVcs9F6ytZCaL92Cvq+59QKx5Axk8Cq
X-Gm-Gg: AYBFou3yePi+X4gma0KRuu6CfW4aTZJYD4myT7JXEbsiZi1azwmnrspEt/MLynpot95
	ZgGJeRP9WTeoQTNY6NjHDSCCKU28hSOr+tgEcvFjd7nWwtOwyMfVszGXDT/9aosVpMrE5k2m05A
	/4GiPRdBeGp66CVnkA+a57j9X1Ko8ZvoWAywOx85C5qCuDXTrXpFD86VV7UmePb3qLCnLOwzuQk
	ottsGKYVZBp3OaInodFiWqKIHIU2TUhSGSWjPlPVIPVoN4bY4MrMilRLU6gmfBp1kTdphZbz0I2
	oRuquRnXRxv1cdYbe4CRt9GbaLyl/J7aaVb0zXyPMVNSnffZgDqKM3EK69eKlA0TIZqL/4JFnKQ
	C4C2lDbjdpBc+qMXvZvvZrTE12sNVbL1HoKjQEi6f0cEoEQsvSadxOs9ZdhUaFoMVyIDLo4An6Z
	mXB4cWWyBxJKG+wm7ZMGH92gOOuylhGFWZzOGM87mQMgBeaG+rL7gCe/bd+NsD9U+jmktGM16IM
	+zn1DOQdKkaKz8PTERHwnS6QQCJjksYCFXAb/e82brcfZSxM1xtvm+LFK/8LR5Fm0raI4B+Ig==
X-Received: by 2002:a05:693c:6394:10b0:34a:48ce:b687 with SMTP id 5a478bee46e88-3537e010c56mr5390949eec.32.1791625310936;
        Sat, 10 Oct 2026 02:41:50 -0700 (PDT)
Received: from kanishka-Inspiron-15-3530.kiet.edu ([59.145.191.142])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3537ca67b21sm13438922eec.11.2026.10.10.02.41.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 02:41:50 -0700 (PDT)
From: Kanishka Solanki <kanishkasolanki456s@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kanishka Solanki <kanishkasolanki456s@gmail.com>
Subject: [PATCH] mm/page_owner: make page_owner stack depth runtime configurable
Date: Sat, 10 Oct 2026 15:08:43 +0530
Message-ID: <20261010093843.103169-1-kanishkasolanki456s@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68E6F20009
X-Stat-Signature: 9o938tiygko45detf7yyct4eb7da8bnt
X-HE-Tag: 1791625312-816647
X-HE-Meta: U2FsdGVkX1/jqccbwt3WdI0QV495YmQp0Co4JQhZVRuEjOOSpKf+0A7+Yaa1fpDAYSdloCibS+Yy7RLrEMFUgRJbsGH92W7L1Jy6bdAclGhL3scIcw3kmVPYTm4sSAzlbbGbdzStVj8pYbeC14pAMlnx7nDthurwVcOdd1iyfSxrYBh673LQmayoM8pkAhhhu8/oHKW60gMKCjDywBblA/2chyG0ccJz21jovwrU9mNfFMAB4QdG7dURbiYZz72+gu+KSx+A7CcEDeQrTPv++DWQiifc07nf6qydkSZfzhIH6JHHuuJVLfkt8WgJEx7qYFQ778c/Pj89uzU/KrK6Swrk12UHBKWWv585P+8sy7RLDzPFR00ApKL/ExfTKsYPcmAUeVS2JdYia52Fytu/p3YWJ8bLjUkS4V5rMfT8wxb5gTISvdz40q5U9q1hmrS85aBUriyHR86M7ss0LW7PeRBveEVZnD8f2FuDDG3qlUAkvdzHYL4s6FiJncoV8KkKjLWuB9dfZMeignw34QpxO4docNBk0EjX3Kjp5u8U3TtqE/41C+A3YkS4LZFqXMmybyO4m3cptGzo7GGmcQEVuMwCFMeiAMcFZm4WjjKXx4I3hHDE16Iu/fy5O45JeKpVJx208GTnre8vZ5iT9XFjlosQlj5fYtU9DhEp4slhGkS74re+bHMctMM3CH5y5YXRs4zIdBDF6sY8lkVU45uq565EMFeN2yPZuoBhU97VrYxKDwu+plcF2YxKjNkYaoDYBfmule3G8g3q88uOQ+DFZa8aCTbgE72k37BAoaPzCvRKD2AxeroZ62NxjFbZtkeOSvFCY0dE7qXXBQ7OfLG0ApXZcfW9nHf9ixN0eUhHDVd0vBm7PvdLK2zOgL7QZd9cO3FNSUREydnCnLlNsOH/vJ/vjhgjo6yaY/Xaz944WV2W96UUCAz1PaGS00lts0jyVjPd/ibc6IZqYUiYJ3+
 pSxwNg8R
 fgIX+ArCMq+osrCDQs83wmhmtk6q9apsMJZRliSs9rh0Xa4iibBV+BF1FOQ8wnHcSn1qSa2Zb6IFgydJo0SSf0sUwK5A0Q2yyTf65Lz6zze/M/G895GF+/+Yg3g8WXAk9EOb9OtfcZFTNEDnP6rbm4qKAtE+6lQfzkFitW4O1L2pe5/18x6SgYfvU69upg0rX7cMv0iLDPgTk/ziwJZrFSXYahjfWUsB2GaeNCgOArgJE6LPOYgKx7OUue3sjTKS7REMqjiJhu5uB8qm8gGzglxxELrNQZcM3MhyiNyCSHrh86fLLI6eftCJnon/vMeyOSRp0EEYqdZ4ymJbsaZspfgOx/zMS0B7LWCyL80hz2HKlbM6VWmSImPf3xnlnLrD+E32BEQ6hO2fAFFB4iEstIJMdJbnWCECDOU89NN6PveO4TEUooqakjj1mh5kgawjKo/Z+O99iM56AjG1Hqek0oA+FwQp+R15v5CXUi1kSJxeivdSbjlk0R8AcuAxl/LFzyJ0EEOKALwcqOPP49moxDc1oJNPoZXqbtUPoOvrLhkOJkSLS2b5IWme76Y8qxyl5Xg13N2qfeOdURUuNQewrOlax2Z4ISrNkt9mL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The stack depth for page_owner allocations was previously fixed at
PAGE_OWNER_STACK_DEPTH (16).

Replace the fixed stack depth constant with a compile-time max ceiling
(PAGE_OWNER_STACK_DEPTH_MAX = 64) and expose a module parameter
'stack_depth' via module_param_named. This allows users to configure
the stack recording depth between 1 and 64 at boot or runtime via sysfs,
while preventing unbounded stack usage.

Signed-off-by: Kanishka <kanishkasolanki456s@gmail.com>
Signed-off-by: Kanishka Solanki <kanishkasolanki456s@gmail.com>
---
 mm/page_owner.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index fbbda7ba914b..fcb584070f1d 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -15,11 +15,10 @@
 
 #include "page_alloc.h"
 
-/*
- * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
- * to use off stack temporal storage
- */
-#define PAGE_OWNER_STACK_DEPTH (16)
+#define PAGE_OWNER_STACK_DEPTH_MAX (64)
+
+static unsigned int page_owner_stack_depth = 16;
+module_param_named(stack_depth, page_owner_stack_depth, uint, 0644);
 
 struct page_owner {
 	unsigned short order;
@@ -172,15 +171,17 @@ static inline struct page_owner *get_page_owner(struct page_ext *page_ext)
 
 static noinline depot_stack_handle_t save_stack(gfp_t flags)
 {
-	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
+	unsigned long entries[PAGE_OWNER_STACK_DEPTH_MAX];
 	depot_stack_handle_t handle;
 	unsigned int nr_entries;
+	unsigned int max_entries;
 
 	if (current->in_page_owner)
 		return dummy_handle;
 
 	set_current_in_page_owner();
-	nr_entries = stack_trace_save(entries, ARRAY_SIZE(entries), 2);
+	max_entries = min_t(unsigned int, page_owner_stack_depth, ARRAY_SIZE(entries));
+	nr_entries = stack_trace_save(entries, max_entries, 2);
 	handle = stack_depot_save(entries, nr_entries, flags);
 	if (!handle)
 		handle = failure_handle;
-- 
2.43.0


