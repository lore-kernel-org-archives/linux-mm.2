Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E64FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E1BE6B00FA; Mon, 29 Jun 2026 09:12:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F65C6B00FB; Mon, 29 Jun 2026 09:12:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448BB6B00FC; Mon, 29 Jun 2026 09:12:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D4336B00FA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:12:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 73701A06C8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:40 +0000 (UTC)
X-FDA: 84932989680.04.DC4FC7E
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id ADDBE4000B
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:12:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="K/IDIJNo";
	spf=pass (imf07.hostedemail.com: domain of 3RW9CaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3RW9CaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782738758;
	b=eevqNwS9/z2WPLhipZ1fm91hqvG89mj8bXis4/YaSRVS4K4sa+lm7fC3X2h1LcivIWEeGH
	RdHRJ//3XPNFa4y01UIuBYHekGivsKJl+Xg3rjCN4F5DjzPwAuZ/KfOtQEPXeIHnPA9U3F
	sEauCcn6mjL/SoJ7/uQKhhg7Vzls3AI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782738758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Mr23/ZUs7aDb6BM7e9K8eAVioMtQVUpxScWSecPbA8=;
	b=hhHTDSpk7JkLMdVdfbkhWPffZ5LBqRgmY1Sm9AcRr4XQE+yInm9s6bAYt6qED0nnUUJMBT
	2lo61KuEDghHqY/QHI7JgNdw0HzUQMUhSbQhAynrIuAmpTW/IKMd3jssL1xljyTrMFkzXJ
	UhG7ea0nhTkn91ode9iT3cbSTRq0D9s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="K/IDIJNo";
	spf=pass (imf07.hostedemail.com: domain of 3RW9CaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3RW9CaggKCIYtkmuwkxlqyyqvo.mywvsx47-wwu5kmu.y1q@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4744b72f90bso439906f8f.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 06:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782738757; x=1783343557; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mr23/ZUs7aDb6BM7e9K8eAVioMtQVUpxScWSecPbA8=;
        b=K/IDIJNoAgX2YEHZ3ol5P0mz6VxeEI2vTOARRb5c2vdXFOg5uYZjlQty1FEyEoXjBt
         PIMnYaucx+UF/1bh1+avcTiCUwIZLLMgN0V6FmgHkAjM0mowvO3xp6m7XJMr9J1DcYHj
         F/3D13GyOyDqYFjjSqqXpYNzp1Ybf+2Kp6hsjHFEDSxjwhczgWX8Sco6dXSwL8ZzU0Iv
         PjRuANHaWx2f7KrEjleUU6wd950bPB46upD677iHQFWXjQrnR1a0IpJDpmNyIKptGztE
         X3TXy/gsAXee3MZi2VFfvtjq9XOQlyodWbGarvL6s19dVtmWF+DaSz7mlweylVsb/evP
         f9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782738757; x=1783343557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8Mr23/ZUs7aDb6BM7e9K8eAVioMtQVUpxScWSecPbA8=;
        b=EMRuIKABh0n+vs0iOW4slXhPgdc3fJB/Qx2BFgK7Cf0lw8UT/wvQYekaKvjWNo2lZ+
         zSZf3mQ9o3WaBH0Mw0CBGp0Qp9tQaIbnon0M/Od6SsWgGv/Y+2LtoZd59RovU5bIXNt4
         oSOgnj7i74hmbpxeetdl3uDu6Wx76SyZcocyYcmVVjPITDC6lrXZkbO/lRfdOs0ENGY2
         iUoK/gl0xdb3DQ8NZHTxiUQVKbPdOPWH49qJprRNTAiTgWMPHCbFD+5EibylAcHzKQwi
         4zlpHsNVeKIeDTjZiovtO1XIav2KpEiPWTbYPUkq6LrRsUq9ADa6U0ym68irS9fdSgh/
         tmXQ==
X-Forwarded-Encrypted: i=1; AHgh+RofvxvUU9yT/grqwQompbSn3wd4c7oFfhQqH17v7L51Ps3s7AJtBiszSYdUra5lS1wAcTi0wu2J5A==@kvack.org
X-Gm-Message-State: AOJu0YyuetHYptGD0pB3cFbTIhcrSCf5KxOjfCVy7SB2oXeVxfjGTEM4
	hBtj6IZ9KE7cDXCPTTwxbygZUIPaLPSRWfydmtsZwHnVB23oNiStZdTk/8vlJnbbCFGPXsJxqeZ
	pZfRdJF7HGz/FPQ==
X-Received: from wrub13.prod.google.com ([2002:a5d:4d8d:0:b0:472:23aa:e797])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:438e:0:b0:473:1ccc:15b9 with SMTP id ffacd0b85a97d-474feeb1d56mr602415f8f.1.1782738757040;
 Mon, 29 Jun 2026 06:12:37 -0700 (PDT)
Date: Mon, 29 Jun 2026 13:12:05 +0000
In-Reply-To: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
Mime-Version: 1.0
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260629-alloc-trylock-v3-16-57bef0eadbc2@google.com>
Subject: [PATCH v3 16/16] mm: remove the __GFP_NO_OBJ_EXT flag
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADDBE4000B
X-Stat-Signature: meyse6ijeepo74xhnrimc1cbwgwnoqmg
X-HE-Tag: 1782738758-578728
X-HE-Meta: U2FsdGVkX1862/epygYJ+ggmFjh6bueSm14Flqbn8Ci5sekI/ViII7CGvKm3APmbd+yMDR7qJ3Kdg6XZZpErPATBiSC1fufhwmVf+BU+4Orn6ga7PZo3sIfnKnD3B+Zc96ACZBrO2/j5J8Sdb7d/wDteCYMJ3d4ffhhu2tkg8BKtShB5caxkvrebbG4nSocpP5UA0Nn7X/iGEe7tjp9A8XU7wMIicjlivZMgk4ZSYPq45ti75VWu4nK7UFI8IsK5jIhXPwjl1h01zvFlK1VbGZqXozTVz0JJ3mQaOiR5IFZgyezLitzcFU6L5skQ0hxjk9V4xwcHuqaOwTF/n63hYWyIQG0+I8Gz2+hr9dx+0Oq5sVhBJr6aPD248YNl2zaHTzYtKQqwlFJYO+27a4Lfn31Ba3khVl4yvZ+I3D9t5VBVZUKT9Er4CsK2IR/r57irCZ6k08LA5EFpeFIEnHYv50aqOQPjRH87Z75v85bzBlNEh7fv4eFb1XfS7kDuFdaUSU/X2bknOv+atnLuUBUWLcdKR4GvN+aM24aXoZki77ee8dWt5Jml/Twqln5/YRb388UYMpzXUYEt2gV9GajafgGKh0rCdRWh9ws80YU0zf5O/R+dJ5hUoNm6ijvS9ak8BucmiCyryTU3MZ5FBVMEXzNfbt3g/f1gwG9gRRXi6ztEu2xtZUYoDvdjEyR9DxP2WLID82bGNn5NZkveIpWTbFZwfwc6MLuBsW4oVZ4xWFNsaYWurLdI/5tprQtnvxhZPPZyumzFRpVzeNOorJpeBu7Xlw/qts5qhe2GOhoCUdLEGELucvyvDPXSihcjDsYc9/uc1EZ+5cUE1bEpFnyP3AM+2PVUjAICxMSYT/ozj1ElywVfitHFRlNtk7xwjqY9np/+QS2bQqGg/dh4TOKBS7FhQBEPaRP4ozOYlXAZDw6CmDf9VnF0zUxIRAc8Bp1YsThScdUsAa9xN0uhfEI
 mV5CUIOw
 wBuveDhPleugKsLCxPWgFVAmC8rMPgRytNHyG/pcHlRSRHtZkac6KVASMFNA642EbJz97I7WdG6iNeBTr0hYHZIKDQRodJk+33Ri2aGRrcFTupfYxpXzI6oVxAs4wTG7zio3Hfz6GOY2NjnDet+HuIjGracEZwrWoQx3e0/xq3DqYMrlCHiJd1pTiHPYO2TxHSjFm3E3GVzPpYFzJPDAb2EHzKCx/JSc6i4+bdp9CCCAD7oIeFUENWrOxdDnddkKnBlN94sY83Sh21zMnM6yrHlE4oO5E16DHDTytSBicR7odJGdVevVfcVhVxSDgdK8Q19IMJKmoaN3inkwpze+0aYtJShf1i1PY9SZQd/fR+gkiiea85obxNaUbhJtewIBEqRXiWbvGPCnJOlBQk9cVcx1+n2G82TamLe4v7F+DQjG6KCwrSjdwKg1iuDoz/LTr33QKNfTfJ8wjr0ev2o6tU0qHIXaxpnpR/Hd6oGj5cJaykbVk6ZRr5WfzLVeB68CywkFbv2iOIAdMRdnVJ5MjC1Otwg/LOcDI4kMb84vxFXYyts26930ZoETfTtpxlpmlRjWzIrGpfJswRuPHoaDlkoeoBvRna5kzQl7WJ6G+t/hiLCINpEnAscOtDpr0PPclumemk0gIm4VKgjk83FcWrsncKR28cpGnsQRfxNEpTqeQkBia3KUEjuQsemSDvJ79tqV2VPDsxbY9YwA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All users of the flag are converted to SLAB_ALLOC_NO_RECURSE or
ALLOC_NO_CODETAG (from __GFP_NO_CODETAG which reused the NO_OBJ_EXT bit).
Free up the flag bit.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[Rebased onto __GFP_NO_CODETAG removal]
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/include/linux/gfp_types.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/include/linux/gfp_types.h b/tools/include/linux/gfp_types.h
index 6c75df30a281d..a93b8bd200b76 100644
--- a/tools/include/linux/gfp_types.h
+++ b/tools/include/linux/gfp_types.h
@@ -55,7 +55,6 @@ enum {
 #ifdef CONFIG_LOCKDEP
 	___GFP_NOLOCKDEP_BIT,
 #endif
-	___GFP_NO_OBJ_EXT_BIT,
 	___GFP_LAST_BIT
 };
 
@@ -96,7 +95,6 @@ enum {
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
-#define ___GFP_NO_OBJ_EXT       BIT(___GFP_NO_OBJ_EXT_BIT)
 
 /*
  * Physical address zone modifiers (see linux/mmzone.h - low four bits)
@@ -137,17 +135,12 @@ enum {
  * node with no fallbacks or placement policy enforcements.
  *
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
- *
- * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
- * mark_obj_codetag_empty() should be called upon freeing for objects allocated
- * with this flag to indicate that their NULL tags are expected and normal.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
 #define __GFP_HARDWALL   ((__force gfp_t)___GFP_HARDWALL)
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
-#define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
 
 /**
  * DOC: Watermark modifiers

-- 
2.54.0


