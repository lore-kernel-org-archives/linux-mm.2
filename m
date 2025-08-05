Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D43C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:40:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BFF96B00AC; Tue,  5 Aug 2025 08:40:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 570C76B00AD; Tue,  5 Aug 2025 08:40:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439946B00AE; Tue,  5 Aug 2025 08:40:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 304776B00AC
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:40:17 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A634AC03BD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:40:16 +0000 (UTC)
X-FDA: 83742661632.15.5FB8D4C
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf23.hostedemail.com (Postfix) with ESMTP id D951A14000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:40:14 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CA9uUO8X;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754397614; a=rsa-sha256;
	cv=none;
	b=lc/iR4ILAdHtkuB0Dnxma5wk2vdv6UQpKJ0u6PWFJRW+cq0OYrU3oGN3ZOFHrtU3gKwMwG
	+lD2/DXe3vo3DbGkc6qIrqmzfw6DPx6fhqKdZBJoL8sNvDWNuygTHMIjO61ZHgcG+rg7e1
	yRktz1cWFSp/8Nbze15QvOuQpC6wMvc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CA9uUO8X;
	spf=pass (imf23.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754397614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kv2WQYohyJtHe0R3wq52sTzttlbIqo5mh2LAfmPMI3s=;
	b=eJh5HXBm6FMEbmiaWUsbQeUYc14p6qKUoiWM6vcDXRlbkTevkCUbvmUILx3KVercun/thi
	5dYPlEcxV15mH/mxNtFIK1yD9a18BC7QLRJGnIxzTtF465W6MJEpSGnhRdrlWSww2MNI30
	8wVdLaEAol9+ua90G4gPF6jvbwpWSVI=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76bdea88e12so3474465b3a.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 05:40:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754397614; x=1755002414; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kv2WQYohyJtHe0R3wq52sTzttlbIqo5mh2LAfmPMI3s=;
        b=CA9uUO8XapUlopLjVGST5CtLQUHs0++/rImAQhuK45nnhXs19y6LD2CjMAkDavbeMj
         JwH7Y0gXu0ivVdAhVzwveGgwFkv5iZ5a8wEDvcwL/10CTxTxGfx3GwEPlW3SnjbrqBIO
         3yMPx2JY5HFLqzrSdyrTCr10BifPzVYCCZvNk2hqu07MfDkb0Rh7xWG4pyZwZPA6WB8f
         YV3/vBacR6EnDjLgU8ankBGbLasEVDhNJEU2aX9d+KcfTUP+4l1UomfWINhuo/QLoJRi
         ziCdcuSTpr7SqvqNf8Z4mBVKURIqif3vyA5QAJEr8U7jaDzy5p/vjbJLQ0b+o3xbJZ8o
         31Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754397614; x=1755002414;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kv2WQYohyJtHe0R3wq52sTzttlbIqo5mh2LAfmPMI3s=;
        b=TCh+Sw1TciEWkII4uCpynmA4pvZ2/4ANwlWXnw26G9mWgCbkmeynQSsV0RAVgtBGxB
         jTXfxetFQxQMD6HeKdKt/FVu8jw6Oq25h9bfnwccm1T9OiM4BAyV6T3lae+M/OqS6AUW
         ei4ql7J3W0BdNpR+hGCkatKFFm0wnSNlhJoeIK9m8iQYOdu4lYdZJuEIBUC2wIXw00yW
         i3gidlKny2QA4f/WuYjnBJB7DSK8V49Yq0SDhgnKVhGuy2BfqDST1Frxw7rk9XH4/rz3
         sseA95Pw1SoW886MuIuOO0nA0TEJVXekr2UGDy3ZURsCvJ8BFLYyQZbJYQ9P1zy6gwxG
         hl4Q==
X-Forwarded-Encrypted: i=1; AJvYcCWCcKnczW7wbARM0uV+zVbs8h93ZhVHPKbbbUcqpAZsfoEardv7f9oL28juC8ngqpz7nU0Y2gJtCw==@kvack.org
X-Gm-Message-State: AOJu0YzI69wF+0+mDnOfDpvArPZtqKmaPsc6ws9LF/mXUJ5TvQFcoXMp
	f/yH68VwzAJ2VHaC4JYcZ5tjyrOETNDkWN42uU+BbfsUkyKGbFhPwoRM
X-Gm-Gg: ASbGncvAmz8wNmXqjMqMmgt5oGPh82Egne6bbv9cLuRvDgBRE+eF1l/90ENM5NOwxwf
	X4qfJSGulc9M0fl1IdwO1uEy+E3ESSZCgI+BojB5SRWGm/OKfQ2lnUJ9FlPQke/xOUEH2Y/n8ew
	3PNKbw/6L1p9c8pR96U4n09QGK7z6vvlr1FhaxOTmSXeHneYKBkJN7v3WGVDAe7txVepTKV6dMO
	qAoHMsIaPzzbxSKLB5uBDBURGHuDdNiILCG/5pOEv0yWXhQEdB2gvhpAgQg1A3jJcvDxwarw3mt
	GtuKb0xkKVzs75oxFWglVyMU4rSrglpl7STSl1ZH8ffNlZXnV8C50m65J7k4pIBnRmh3c6Bu9Tn
	MRJcoGK24k4BWDQ+sUXQzlAQFyb8=
X-Google-Smtp-Source: AGHT+IFY5kB1KV5C1poWITqdcW+VQrnByTdSHae+6L/MEv9sSfTL4PyH/fc3hPjyUva0mXiJU3Fu7g==
X-Received: by 2002:a17:902:ec90:b0:240:3c51:1063 with SMTP id d9443c01a7336-24246f8cb59mr199307215ad.23.1754397613404;
        Tue, 05 Aug 2025 05:40:13 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241e899d347sm131088085ad.140.2025.08.05.05.40.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 05:40:13 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: sj@kernel.org,
	honggyu.kim@sk.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>
Subject: [PATCH v3] mm/damon: update expired description of damos_action
Date: Tue,  5 Aug 2025 21:39:40 +0900
Message-ID: <20250805123940.13691-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D951A14000A
X-Stat-Signature: bfbamedecpspbwobqafronem96migib3
X-HE-Tag: 1754397614-927701
X-HE-Meta: U2FsdGVkX19AQ56oZjwVETbDl34Vvxk4cKkkECA0UaEqpZzLTxnBK6FXir9mJKo8JLqNv+Y8l/bul5i26Kwt/Iklezp0H9hu791EXoj6t+IARoB5mGV5/XOrZ0WiHZT2mO2qXhJHIZRL/mmE5tl0/Q/yqp8ElRYdmEPPtApq9Vp9JoBj3Jv36EgEv9kmbLw4fLFX3rT0FTkFKT0uNWxpVxfTvwI3F6Ng30mWQadDr82CMBd+iSLHiH+fsuMniKIeMrMTRZGFyTaSafT8SnVVFUwDaPlG2KVBLr8BJxCA8y99YrwDmdcEqvmRo2tbqnhMlomlBV5LD9TaszU6Q10tS5DEU6OHDP6pNV4iBdHAdDOHiRc9FYWGxYQ4zY5yderjR4HIv7i4vLdciXBwOCF6FN47yndTg8eKj/LBhakqB8q712sqwQ0bgVE9s/oCe3KlaS0IXy4PPrsV9hmzC8HIcDVmjgpajsglrVwGROW3jARXg1ahs1VMj8DXyFOR7sI434ZPn2p46/vK60Dq9KERLzTjlKvjsWV+2w7NGfjW9KPAIei9mHegEbizER1cDhIf21tVadxZOkDl8Cf/geADJ+vVFy2w9/A/kxrO/Q1adsl9u1wGj2Co+XSHxwjbDcosTCeiVXJDCgJoB12MRpwPfmI9bJJDh2hqmmjRTgqKsy4X7TxZLnWXAKsXm0RvpQgUT7kNs++nUbXAGFQX8poTZOFlbsSPo9vQ1+vkScW74y1F+YIXXzxXGeqSEx3Jf80ZaBXnUVWsZf3/9XPzMSIRDaDB4/VBTOisekMYq7Xov6Oashc3Ic9hDSi7No2FegPUnJTz9COs9MbU/t1TLFn0+TfL06B5gmGjphaexfoMgPzbA8Y6L6BlqHYiftcoN9OvSQ577OFUzSv+f5t6XHTm0zpMXPwViULSt0D/fzTIo5NCefsLd15IXxFUKqBtP1Q9ptP6RnaznZJPbksYFCI
 rTW+DQ8t
 aS5b3o7iLsVpc/Hni7CLtGspo/iN4jTA1JgJAbZhilk4CgpOMu+8BICJGhQv14kh3eZPVG6+6fiAM0Pq3nZ3uQnIFIGOPLmcUUFJMiznOm9K63JOmF6FjLL6GUKs9DBuATJmp7yj53PH5l/MKoEzRBNZ4NLtCO2mZJSKFBMMEBh4CrWT4JJeUHc/eMgxe41/HcU07qgZMMIr45+yIBa2s2ZW9po8vEZH/ePQSMZmKL9qhABaqK7w9ntoEDcR0DfOiUgz7e5dYFk9qydiPwE5K7j7F1t9KgDkEP+aekU1R/AQgY+H2J4br4kkh+aVJ+6diCFjBekLDZsbG/Z3Tj0Mq015Uqh9rtcf2dSKCea6Vg4LZbyIE1hIbXZHRs4Ch1Qj7gcur2rT252zUVldedgJEcVQ5e8qItWVa9QRInQ7l+r1VjWEZADgSB6Du61t1nFUAV6ngezepIyCTpggqKgDUIsLeEDdXt+ZDwxtsYAL84ODNJ9w8r7mGQUeG91sexoq2NLrhScnJqRN9GnU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nowadays, damos operation actions support more various operation set.
But comments(also, generated documentation) doesn't updated.
So, fix the comments with current support status.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]:
1. change baseline from damon/next to mm/mm-new
2. Add note about DAMOS_PAGEOUT and demotion.

Changes from v2 [2]:
1. Add reference design documentation to describe support of each damos_action.

[1] https://lore.kernel.org/all/20250731132230.80046-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20250804143816.29654-1-ekffu200098@gmail.com/

---
 include/linux/damon.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f13664c62ddd..d01bfee80bd6 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -110,7 +110,7 @@ struct damon_target {
  *
  * @DAMOS_WILLNEED:	Call ``madvise()`` for the region with MADV_WILLNEED.
  * @DAMOS_COLD:		Call ``madvise()`` for the region with MADV_COLD.
- * @DAMOS_PAGEOUT:	Call ``madvise()`` for the region with MADV_PAGEOUT.
+ * @DAMOS_PAGEOUT:	Reclaim the region.
  * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
  * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
  * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
@@ -121,10 +121,10 @@ struct damon_target {
  * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
  *
  * The support of each action is up to running &struct damon_operations.
- * &enum DAMON_OPS_VADDR and &enum DAMON_OPS_FVADDR supports all actions except
- * &enum DAMOS_LRU_PRIO and &enum DAMOS_LRU_DEPRIO.  &enum DAMON_OPS_PADDR
- * supports only &enum DAMOS_PAGEOUT, &enum DAMOS_LRU_PRIO, &enum
- * DAMOS_LRU_DEPRIO, and &DAMOS_STAT.
+ * Refer to 'Operation Action' section of Documentation/mm/damon/design.rst for
+ * status of the supports.
+ *
+ * Note that DAMOS_PAGEOUT doesn't trigger demotions.
  */
 enum damos_action {
 	DAMOS_WILLNEED,
-- 
2.43.0


