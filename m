Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2063CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 18:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08BB06B00A8; Wed,  1 Jul 2026 14:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D336B00A9; Wed,  1 Jul 2026 14:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6EE16B00AB; Wed,  1 Jul 2026 14:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C3DA36B00A8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:21:13 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 55553168497
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:21:13 +0000 (UTC)
X-FDA: 84941024826.05.30E68F9
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 60191100003
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 18:21:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BTr7BAo+;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782930071;
	b=naV2S0BxALzhpbG4PXeME97Lf51KkV5QJcEdnqCCXy8MCWqO/LQbSOfjvQ0N2GjoedWX5y
	TaCQH3TbIpFILCFvtDkNcjZ7TZCXDgz8bg2L1ni+Bda5hUHkhFs54kziuRQIuQXRIIAnxk
	YNJ16Jhq/p8PuTapYYOL8LRWc92/IZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782930071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QBjYQGhoBP1Rzw+O9Mu9B3KRHSZGqqE2WAhtEsoN9xY=;
	b=ZrXGHGucqnJt3vOOpy+rnz0ImX6TyBAsJA7/7HNZanne6bIgYpADcQakMjoRbq0//fNGYA
	hMJ0n6vRALsQaW2gB2mS0DAtdq2ZhxsR1udutjumfXBGCSwk4SQuIRUc1F6XGbmZEBr3EQ
	+U+BEm29IMHM/X7Wq8Ru9BFrCQsC5PQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=BTr7BAo+;
	spf=pass (imf14.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.174 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e7c6ec9dbso24234985a.0
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 11:21:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782930070; x=1783534870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QBjYQGhoBP1Rzw+O9Mu9B3KRHSZGqqE2WAhtEsoN9xY=;
        b=BTr7BAo+Pl0M+LdRusm7E2Gi2YNjNXQcKwPlTAq3t8KRJ9zt64y8hEVnc35fmAnaHs
         1GB0ClX2PNTvdUD9IFK+v/ZlNK+w7w/MeMMnbz45oDQYF7asZqC1VqwyplJ9M14zMjiD
         tb5Q7DU/TiiZ8lBNAFd35T5yvwDzplhcof59LTkR21uogAWzXVuRQCHxSdeADXin22VB
         Cz6p/KRSTNK8Fk/89Kq9m4lv60P/h1EhvGioo+nsu5kMH74R9Pj5Vrgd9PdnOUT0BzDS
         VRJ22/aVTxgnLhaT6UUYdGpVhrPUJFJWA7V0yO97ao3rWlrCPLGbdKWaQ5Ow/IvPl1eR
         6DQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782930070; x=1783534870;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QBjYQGhoBP1Rzw+O9Mu9B3KRHSZGqqE2WAhtEsoN9xY=;
        b=DilWLTqWby2wDVdpj2b7W1kVzZhijFKtiRIJoBelw2WTycmjpEMiW0jmWy6N70PZlj
         CtkZL+zn4DkF2uGDEJP82qVbB0dLZJT/QkHgjQn9zcUbgkCHeP7PYV6Xxs9/Qf7YtbkM
         8zM3jHEYRUX+KMW09sIwEm4Sa+L4u+OfC9bEd7+lPBL5oWQ/PJDwYKlQZyVXLZYG4wNC
         haRftZ385chjYIYc8hb97cDscztVGKog4zGVyZ9kZOlT9E1LV/fincQv919QW1iVRKWZ
         JU6GMFcpg3cqYTNPrKONkOa7UN6PsctX/mgAd80+z1SOu9WT1Qjs+Jo5eNR7mXW6VVH4
         1XBg==
X-Forwarded-Encrypted: i=1; AFNElJ/U1N+160JdXe8H5BJbIBiDlsJsYZ6zFqSpS5xnBakcJjvGnaMcAakE20j/C0/w2aEIJO0dfoRx+A==@kvack.org
X-Gm-Message-State: AOJu0YzebWVRahd4vw7WpnJOAgtBdTt4+MMpdRPx7jFcGB4BK41OX1m2
	xSI9UPqbs1SAQ/D5DkjpcVqupRU9e8R1wxe/qxPQiTGJ9MLaioMIDEkQfwOrHR019B8=
X-Gm-Gg: AfdE7cnCxJ+AUAy8zoyXBmZmRh5h5Whycx4WpYroxa6gQdOPQQAoMna1hRIg+BhEg+r
	qmPSUMZNdRdxXaryw4F5BiTTMHI3Xp5dNX96UttACAdipgfE0WpckfF1RnAf9+wXXtah/TPfZHD
	c99P8hnq8uWY/sLs6kVfc9KBpT5sALfW0/0TP8HeDZRFalum6xjGUkdO8pUprUhlN5s/XZ9rI3U
	SRoTvfXSQWWcyYJcSOt3v5DeLIWSlR2to8PF24I/fb9bBEHDi/t2KRgb9C8ZN8aoLrEQSGdr1Hp
	549Y88KBCsNLPOQ6eUhZ75U5F/pS7XK6f+t1x1NFmsDKDpn84B2xi74Vw/Zg8YFdYrNO0m5Ps2q
	+uMN6d+yXqUYphMupLTofVqzpnSN6uA7KHA4V1wR5Uz9nP10HXIYjrR+LRw4SzIr2ejx8GGbGgl
	ZA9G8ql/roHfdJtADPbtyvcQ==
X-Received: by 2002:a05:620a:2851:b0:92e:52df:3523 with SMTP id af79cd13be357-92e781dc83emr395697685a.8.1782930070154;
        Wed, 01 Jul 2026 11:21:10 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e80009552sm9286785a.11.2026.07.01.11.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 11:21:06 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gregory Price <gourry@gourry.net>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: gfp_types: fix __GFP_ACCOUNT, GFP_KERNEL_ACCOUNT documentation
Date: Wed,  1 Jul 2026 14:21:02 -0400
Message-ID: <20260701182102.1586784-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ziy4mg7kxnwq733fwqhnzs7a3asnn1xn
X-Rspam-User: 
X-Rspamd-Queue-Id: 60191100003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782930071-805006
X-HE-Meta: U2FsdGVkX1/lj1RrU3B+f0Y+bNU8hf/loRITySJETF0A1U/3pmUPddZy/GehbSNB+RDbdrhzWNBgqvP2NSaQESGND9R3oaeg+OPz94y4gZ8TNTty7yvKLwkArYQvBdDi1GabDchOCF6rtU/aB/0IPqpElFvEHejG42X6P77FTLUKwcPZ6qKgUnjeM+Ylblt+SKQEoxaQfE+sd8asywRLfmy/T4gILPOZSOLtjfQ/F1p8Ofe+BFBzk7n8Iavdoxun+7ExugqP4CP0/jerJZEG43XDklLUlD4jL9698fXqt1DCZGZe5KLUnaueg7aR6EeFKPpBAnalx4Sb8X44mhqLj/2KgIX+V8FyMbjkqsivKIO2o+SsOyC638WYSbt0VBhR7p1dlbUgK4a2aSGEGt+TpmE1gUtItsojCLOoqeEHMmvf+aO0OF8k7JMGvq0VpvwlvldPlhMZxoevB/gvfht1SnKtEm7q4FUfL8hWiOTMTHaTvOfUAlC8/fLmAUl5zGLzgK0+REiaEsu+SaPZPRgL253gdir9D9+otWSs3nqzvIAE1uIcpODppP+gIFvahmLIlNo7G6IqB+KXgUdAEDmWjwXW/XGl6HYOwmDOBlSE9Z+EXVSJ+U1XzUnU8HPK431n6FFJZ08bV2EMOVtT6+v9sgzocZYqKgn2zJL15E0On5xU6RAUD0/2noDG1JVbHVvjnjmzqkB7bzI5IbXUz79wqn0dpJ+dhb2YP466BhV3NwQPH0Cj+ulqAzNhaza7MV6wXCWqULInjYpSkzx5eKVzdt23zxJ3DJFw0rE59hFFAHdJlnetg4tcHrnc+N3M2fYsGzfY1ZtwjXjsLQkUIx5m40kjTozM5rnl2n0tHdpxKPjasY29yqejmoEzleOYEV9zvSfLuVFGR/d2tRkcMvSNGbi1PXapcNjmrHYb7qg3jqRpeSVLL5liE3zwKQ4npN7qvov++R4iqfLfiv1Vb9x
 7JvdAOiv
 sM49P1zkwZR5Bmwe+WO6NgbJOZS+N2zwXvS9GgQ4c9nxrktZAQq/s0rzpYAV6xuIiJEj5lbOom2CeP7DICAzasoOLIqe+V0EcrtkbLsP5lzS2YC9qQndM0QjrCwD+rv5v4DkXRvuKOi7OcC18hFZ3915vHeVND3tBI3R12LGZ6M9skHQdo75KrT4l1QgrF6hAwiU14EP9JFvcLUohRbstSIljTe/jjj1ZyXDmobxIHx2K0pgFzuA7KUo6RB3B/VhXm5nakPAoNbm0JoQNOnkDC3CQYqUoebKCPoyBFjVEz+YAdlvaEZgX9wo0wlFxCRv+fxEFsfQzP+O25+SYOS7sIMs1MY762+889lrxiBSzvwTTgDHUtHkBKH6tEOl9F9MBr2+cXUm1VTW+xRqxbCCZOPz6Ur0pJsrWvZlMxMiJaxP4Q0u+U+BRUFUvlBCfNWELGEhMO4vulws6c2qjuQoMsgO7ud9iTHIHjpya15RlxSNt2Nz1Ud6pFpkERQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory points out that these descriptions are cursed and confusing,
considering what these flags actually do. This is mostly due to
historic implementation choices and cgroup1 baggage. Improve the
description of their actual effects.

Reported-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 include/linux/gfp_types.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 54ca0c88bab6..463b551d12d9 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -136,7 +136,8 @@ enum {
  * %__GFP_THISNODE forces the allocation to be satisfied from the requested
  * node with no fallbacks or placement policy enforcements.
  *
- * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
+ * %__GFP_ACCOUNT causes the allocation to be accounted to the active
+ * cgroup context.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
  * mark_obj_codetag_empty() should be called upon freeing for objects allocated
@@ -320,7 +321,7 @@ enum {
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
  *
  * %GFP_KERNEL_ACCOUNT is the same as GFP_KERNEL, except the allocation is
- * accounted to kmemcg.
+ * accounted to the active cgroup context.
  *
  * %GFP_NOWAIT is for kernel allocations that should not stall for direct
  * reclaim, start physical IO or use any filesystem callback.  It is very
-- 
2.55.0


