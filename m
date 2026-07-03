Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464F2C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 04:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC8B6B00CA; Fri,  3 Jul 2026 00:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2FA6B00CB; Fri,  3 Jul 2026 00:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA5B6B00CC; Fri,  3 Jul 2026 00:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E18B26B00CA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 00:14:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 605C31685C3
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:34 +0000 (UTC)
X-FDA: 84946148868.04.5B8787C
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 982B180009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:14:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KjLezXHo;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783052072;
	b=O6eUuZZjzFCftJFu3yL0V1gpBOek/oCUPf5nlF8ZWpVlvf9R2LdUMU2IJr7O7jt2KXc3G9
	uGfbjlSqkfHQJU7dCLT3MVgrCI+YdHDZXFctn9MvvKfP8IWi03f2HYZt7hlQDYbQ90Hpag
	QW5YxF46P3HB8Y7/T/paXKd34gTo7S4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783052072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EDa87XVL//1Q+gQWaZZS4t0Al5v4r1ZYls44rvYc7DM=;
	b=Qpoa2bYObGgKo6DjLifYoR9xzb3Pult+GXVpt+nSjUNAO1a32R19o38xGDqSRfNSPB1KJq
	a3em0aBq+xgm8VkoQLwFNbePwoAexQNpYQM9N+OkH882wzgMBWrU+N6ZnrAH4GyMNpr4e8
	67gBUVuD0nvG3NXg6kCGBWmeDdi2Cd4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KjLezXHo;
	spf=pass (imf30.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-847a5528b33so63285b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 21:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783052071; x=1783656871; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EDa87XVL//1Q+gQWaZZS4t0Al5v4r1ZYls44rvYc7DM=;
        b=KjLezXHoAb8fsMc2Ce6DWWy/aQ3eOa4+cOmZb6KjIndKPMcq3QtLAiBQZxm89I5loh
         sNCcrcxiD2VsfAp8YB5sM0LgpvVyN5xo0kVZr8xrFTvabLF/839SV+SrGcVAc8mD27s/
         orbl0NcnCRcGkjCwoa9IHzHVEkyIeymF9Zexv4R/2iZRGkJpyDrr0M2Ywg3RVqodjQlz
         Vw9+G4GmkwmJsLJFJiV31sX1rlkzi6fWAWhx3+tWsq6j4154AbNHcj6fP/4vyJKK+ZwN
         rxRcGItCnobWhQsXVItqE4pJ2sNjIdGYJlAZBz7A7rtVNL9+pzHSWzPXluM3rFzcjKQp
         Lxtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783052071; x=1783656871;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EDa87XVL//1Q+gQWaZZS4t0Al5v4r1ZYls44rvYc7DM=;
        b=ORv4O7WdF5ErtwHzUipw7mrGB1LM1J0f8XYCZlAkO8DD5VJ8ayxaa106BHNUos3Jha
         JmFLfwr8cDG7qk3I0sRphodeCipDmYELIfoLVTMQ4pb8kG/1UVMd59C7Bk96eHpKDCSs
         fVo3zD8SwJYhXPLP3JOKbnEpMamsZIZPuAsaTQfUaZsLiZchWP/mvVKEFdzA4r7k1Snw
         C+Nr01wYv8ctXDRwKAQ81naKHWPAQ1bNUtuu8Zu6/angJzgmMIcknjzjlxuMdkzTVZDC
         iRJXOr1TAUvcslv1Vc0yaiiE/ToQH75Rsq60MHtO/gjpgkvmFDRrE/UIPedCi6KTQaWF
         JhMg==
X-Gm-Message-State: AOJu0YxjAtUKDQti0EZHd6fwGtg8IKOVkz0/yOoPTR28srjOQLIkPog5
	W6EyAXNNxa5UBlttqpqBlu65TB2RCy2Fo5re5RxAYUH6Rdh0DmyJ8KJX
X-Gm-Gg: AfdE7cm5JY9JFK0RvW3UsxVtMHmR3YwTEAK9Axyg63+eh7z5MFFfPLqGnq5VfCj9Cc+
	Y1vHwepcOrCzLK0uLCIWI1p96H35VIcx6wIfkoVBjeswMhVZaJEycUIBy3qTMxPiuzq+ghZcOAI
	pKfbEotvWikda0V6dO0/PWAujAD6wAUGYXQbuF65ZqpnixtY1QsOen8RQlhLF1te5hI2jxV4BSb
	OkRidyHIZeHma1J+HBrLLnjlmkKwhzP9LwEeuWHWC9/rqB9l3j1tKsrPkJQu1smryySS/mxs1pz
	ZLrXYSy1tLaq3Tm9JEBybuEug6QSET4oOczisHSP52h5Z/jj9NlUkWSm3Zbf+UOJnTwrL1U0tpi
	/SPsil7VKniOHoGJPtxM75hDuiwJCIdgBOL3fEuX/2QV7atOpN1l5EtGi9diGJkYx3gUrdxbhRg
	Jtb+lMA1M=
X-Received: by 2002:a05:6a00:2d26:b0:845:c6fc:2821 with SMTP id d2e1a72fcca58-847c506656dmr7890365b3a.22.1783052071447;
        Thu, 02 Jul 2026 21:14:31 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94bd7esm2207768b3a.38.2026.07.02.21.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 21:14:31 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH v2 7/9] mm: numa_memblks: remove redundant numa_nodemask_from_meminfo()
Date: Fri,  3 Jul 2026 13:13:27 +0900
Message-ID: <20260703041329.2797584-8-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260703041329.2797584-1-ekffu200098@gmail.com>
References: <20260703041329.2797584-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 982B180009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 7wcgr83zduqzxinpxbpi1su1a7ue5jzx
X-HE-Tag: 1783052072-209688
X-HE-Meta: U2FsdGVkX18xF7WX162FPvRrdR38i+n6ZIKmGz8zlG7mE3zarOsFsK2U1kZtUeshsIbyJSSlJyViC0tIxHzepKq9a/aoFK1WwNf+WW+a2lmuwRcvE99ghK2aJxk4YEYuBHc/9y9TVHBsPtaCUGrGgFFglmYoNP8nK5kXzcd+gfOBTXMgzZMo8RzreAXGK0pRqUpm5mDxaVKZc5rwC4FfdSWlhJsIxPqFIIoYr7mIUBpEX6TE1e9TnV2AK4jCcn8KKL9HLqPX/px7neTDIw75O8Cjp0ToCSdczvfiRzTYl9pvgxzdwVfxoHjGWn0/VIlKanJDpFlEDTL0/iHLV4sD6KH+aXRuwVqkmLoRL/8K1vvo1zXumKq8C5BImQ8Ad65OpmcJDc2c/RbcKk1OhN9jn6psoRBj3tC9PBp3hPX9qw1N/i/56JJxI1fE/dQ13URAxmCvhLT+mS/thLt7k4lrbRyN8G8zftU/tj8fUx6IKyh+BnC3OULnJ9HoazSmIEU/X/iYUXHxTFrNOW2fuc2QUqQdijs7pypRNJogC8tXkr5UWXlpd/AbeLfLeLo2lOLNTe2aqjgs4QgYZ5HKliozk6UIMD7KJaGphs1ECxOpaXoScgbCfHXhEa2Lpfv7AaundQ3bhmPrRCJy9LWGD4CNbronkQvS0jsypqNfd8fpbHQZ4Bj7MppN6LKbWBvd2vxDXRoUVX4CEQCVDh+/2OKXoXMdDjG/HGx1K71zkehnB/fG2yg52PKAEsCi24dJSnYHOWjRCPCjcsEIbsoS4trAB1/F84giF6dJJ9Suw7mJZUDYsaCH/f93NfEWrdFtqDwPDcLHd2lu23ntw7q1cFn2z2zdWhavsTUMk2RyShrm4G0bzO9o8FUrGrjTShlJvC/Yggj74RJLVaRInA4CsLu86lYxEdI01qtSc3qMDzqcwVRGeCtH/3zEqV1rHlA5D6/c3d57EvHcJsVJ/NBxfh2
 NLw+SCtO
 6RsC1Z8vFW9Ds7s1xd7K4rF5A7ivP/y5g5AhlVLR+NDTVpacLWiP/HKnZmuZwzB7n1pnWVWZBxnyi0NtDyrWTdld49TMKlP86hg+8GYlHYIIrCHoossuog1NO94IROkCZhCDooCkwPZ3ISBKa+tMvII8SmtiZ5ocR3xRAM5JMLqH1Lg8X5hYxTGb7MLniUphKB0XjH31Ghi+7VH95BE/MC5WrSW4MFgjlrPBGIqjQyuuZQQjL8lgo0M5/tYpzYHOCsWQIYs3Ue4Uq7aT52HKF3vA3lXwImT9g6Go5vW9+fuDdMAqLXcC2WmUNyDqZbUlYP0gswyf97fouTFDPZhNLKExJP3QdlFsEEqBfKvP3MVz2qtd18hmrGYybEQo6TlxjG3DXZmFp7t9GWfQnWwgZOEYRnOZhZgvhuOoxiKaLzvABhccR8h3BmmlOio+4VzUlOGZwJO2eZKcTzmg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

numa_add_memblk() now sets each added node in numa_nodes_parsed, so
numa_nodes_parsed already contains every node that owns memory.  The nodes
numa_nodemask_from_meminfo() adds from numa_meminfo are already set, so the
calls in numa_alloc_distance() and numa_register_meminfo() are redundant.

So remove both call sites and the unused function itself.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/numa_memblks.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/mm/numa_memblks.c b/mm/numa_memblks.c
index 9815192549c3..48428060e93f 100644
--- a/mm/numa_memblks.c
+++ b/mm/numa_memblks.c
@@ -17,20 +17,6 @@ nodemask_t numa_nodes_parsed __initdata;
 static struct numa_meminfo numa_meminfo __initdata_or_meminfo;
 static struct numa_meminfo numa_reserved_meminfo __initdata_or_meminfo;
 
-/*
- * Set nodes, which have memory in @mi, in *@nodemask.
- */
-static void __init numa_nodemask_from_meminfo(nodemask_t *nodemask,
-					      const struct numa_meminfo *mi)
-{
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(mi->blk); i++)
-		if (mi->blk[i].start != mi->blk[i].end &&
-		    mi->blk[i].nid != NUMA_NO_NODE)
-			node_set(mi->blk[i].nid, *nodemask);
-}
-
 /**
  * numa_reset_distance - Reset NUMA distance table
  *
@@ -56,7 +42,6 @@ static int __init numa_alloc_distance(void)
 
 	/* size the new table and allocate it */
 	nodes_parsed = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&nodes_parsed, &numa_meminfo);
 
 	for_each_node_mask(i, nodes_parsed)
 		cnt = i;
@@ -415,7 +400,6 @@ static int __init numa_register_meminfo(struct numa_meminfo *mi)
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
-	numa_nodemask_from_meminfo(&node_possible_map, mi);
 	if (WARN_ON(nodes_empty(node_possible_map)))
 		return -EINVAL;
 
-- 
2.43.0


