Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2FDC44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE076B00C1; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31726B00C5; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1F9F6B00C3; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 900BF6B00C1
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:32:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0649D120134
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:45 +0000 (UTC)
X-FDA: 84990725610.27.16500DF
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5656B1C000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:03:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XggWLaVU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3DWlXaggKCJY902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3DWlXaggKCJY902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dz86EwLqIg9rsRKy2+oVo0cZ8RAfDlpYQ8xyeR+GWfk=;
	b=kINlj1m3d5FTPgCAoO0nEIfFLcM86amLjakTJtWxQDkjS5X/FX0bmYI/CUIr3aqhjK8yt3
	ZvqbapZatlwEvopbNEo9Yj4XDJK3BUSL3cZXAsVzbmVid1Ry7bGtlarXDRk8zfYKBBgSOu
	hO6lZY8XeZtniR3G+VMRLtcKOuKtxFM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XggWLaVU;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3DWlXaggKCJY902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3DWlXaggKCJY902AC0D16EE6B4.2ECB8DKN-CCAL02A.EH6@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113423;
	b=4utczudyTDiWZ8yg2idsWFh/5Zc/qL8LMX/mBMY9576CnUAU886z6lP71SIMmamY9ZczGT
	PgXIG5J+VdEywM4S4dxt5mbPNfovWnGRx+zIIOHmdrs4kZ3ycTpPB2EOayYe8QdhqaF7Np
	+30vQLTmwd1GGJyBtKI9U4yZ+HoAgno=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493bdaf8549so50958615e9.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113422; x=1784718222; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dz86EwLqIg9rsRKy2+oVo0cZ8RAfDlpYQ8xyeR+GWfk=;
        b=XggWLaVUs/pdut5IHOYHHSLiH6wGMWd5PcW2L730Wch+Thr+A6CkPbagn72QcyvLV0
         lhXByfSphZqBHmvaX0G7YMDDre360q/g1Yzr+brmYQoXqJ7XOkN3A7BDndC+JjaXWkaa
         vvBWID7vVHjglotrxzXLUZbjQ0J7PD3y/nNK3s+GTjSzxfaJgTD9E+ahqrzE6NnStVbs
         8RRZxsmUvJ/6Mkc78LpEdGGibbKYbBFyX1YmSysX9Cwio91BqW+q1ryyaW5kISgpC5H4
         rxfUkM9EJVY2OeZC+OsjwQkDQBXS4XlFVerSoThMqYy3UGqDjZb8x0yOWyYtTJXVmA2z
         rMsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113422; x=1784718222;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dz86EwLqIg9rsRKy2+oVo0cZ8RAfDlpYQ8xyeR+GWfk=;
        b=aV8PpwPjG/Dk62LOqHC6RukannnrqrrbTmvdvE/2IvBuheAzRSzVTGMgLfT4GQYdGy
         RqCzz44KRsxODmyK9xnBE5y9P+VZ0UQM7c6PcvS9LDb7244i4pp17bo3TgqWoljY7ZIG
         bjhSiqV/yHcQs7Jv4VVbSs7yC5v2bSWw5BIYcmDAcD5AtPZVtj7l7xbdsaXqqwleTh5y
         YDaoXgO+D5rlQ3wbu8YcJFI9bO473D5w0DYVe4OaYTQgYQopvbWk6VFlY+JFMfjxENTD
         QZnUX2Twp0Hz3OaB669laoVr0fIDnjjMJ5diRzg00ZMuUXvXaxowhON9ewLJy0gDchG1
         t5Pg==
X-Gm-Message-State: AOJu0Yza1H2AweOgbPqEF+Vb7wu5tsBqbihWv0CLlMO1TLOa7ilykovf
	hO9XRMiclNhykFqz81xHDJmLhExTzOx9g5bshKRCUWw5+dRdDXdv0nuf4ryNbcSiDDRX9DfKK6Q
	pIvasXAYLa9Y+Ow==
X-Received: from wmoh4.prod.google.com ([2002:a05:600c:3144:b0:490:b2a6:e6f5])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e0d:b0:493:b499:3ef2 with SMTP id 5b1f17b1804b1-4953c299474mr25989985e9.37.1784113421736;
 Wed, 15 Jul 2026 04:03:41 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:21 +0000
In-Reply-To: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Mime-Version: 1.0
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-4-fc4d246f705d@google.com>
Subject: [PATCH v3 4/4] mm/page_alloc: remove a couple of VM_BUG_ON()st
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5656B1C000C
X-Stat-Signature: pjrui1g1qgsbzqysfdu9fnn3ewfgtt6s
X-Rspam-User: 
X-HE-Tag: 1784113423-440636
X-HE-Meta: U2FsdGVkX1+02JT5kCk5PUxW10G34CpNdU39EqgXPfCiV/AhIJDQ2ZMBmMo4oApaF0CakbeoiSHT3YHNyDZxLLYfR/AHtOY0DomOmUx38Wynpfs3RnM29oDywBdcBLLlPsRSgUYs41kjqZ2jfgydSCYiV/9UpRn0IQB0kB0VSHmXN4PstCe5r2TvfPT2OspVVh55r0bA6A9GdSY8lgqvRHRAitAn3MOXQroby8IInLBUf+1I50BV9c0MmdoK5wcuOG6gzlAUhaXF5FFHtMQpVlMoff9tqm2JSoV0El5oN77V1CpRMHS7ERobtUMjvCCsXorGeReTJishamO8RzV2NnYd/bzS2lXLqduCr+NrMUwNdQ75rfkHEHedX8dW7ffHTNWkNcPL2E5evzOOrWQl/6CfaBlG9qi+VHokxp9q/4uFLF+S3Y2Fcx7Zy6Jz+9TplawG8iH30X7g9z80y9q3hz1r1k1HsD4Hf3AzLjDfZ+aYzd/xR/yxZ6g9hsseLQO+9hO/mog6CrM9E35dDAm48HGbAapvb3eo07/Yo3ac6uphEi+/b8ezaL1BN2n4aytf9ir3531WH7YXrkyWa6hAdQWUq/8xWlwqjyizj8VaX1sMVzmMtcR4PnnRV8EQ3n+m9wC0qsTvMXqR1GNiRJ1ORC5uXQ7APdPl/2EL3spW2mSxnAVCPKwrlKJjTaU9qN6TlO1XvF8kVRjH/wBsw9auL5ncFKPW7QvwPSNvQrAYz7QQH9GLZ/JPMh/GrcKDJ8ckz8FunQ2o9tyLn94qFOhnacnOcX+0Dt9ia7ezpXOl27ItRdlrEG6sYXnE9mFID9auJ0zwpLn/mL378qQpK5dJPUZkuGV8jY/shCagljeM4XiyCojxoJpmxWO8Ki5ByJEebdRgNxzzx3DpHnBPQZWrYKIRpeOvxi8AuTP69XIs+RPH8SaGG26Qr15gFHegfAMlD6davvl+7kppwimDPoS
 UzFZsQkm
 BhAqIbZ4hzhMW2H96oCZc3dpCQyxmZbq5kH1O7oGb4o6uwd5IPTmYjUFHK/1/aHwkF+ZMLFxtW6w/PWZbJPCb/wb8gJsHfJ0g/VSg6LR12r6I55aNEeqhd+9L7pFDeAjml53Jjv09wjcjCCjzLtDCyJhTGu0e7Qj/85Y/Tz26mGEEizqDuApi5HqbiMg1ua66qxkfRNWNp6Bgf2qWv+HuqUJfkqz7fv7zYHVsyvSmGnr6qN72IyuchtUqPcPoNszNI+KwwmZBQPdV0JkINDZkBNqt353yZ4gL+dkdrTwurXnHnRrA8tatQmXFqOupRuPU4Yuf9NOWDhXEfqH6DXFsJOrNsihc7BRZB+5bxkVuQWcK23hu4H881uEytehhCpOwAldm8GF9FTA+M4wyluOwBeSzRmGjNBYb00l/sa8nFZOOJ0Fn2dgVuszl33Y+N8RyQTLLuOqiQA9+Pxmpdj2mXNr7BDq7q3Z7blF1iG9q8ElWTZGWCnW7V42v08WednTBHThyF0L1Mbn8C+ug18b1GbvZQLZgO2Dw91ESaVD4Xau7syzPZLOVs5YZp+yHl+c5S9zr1qR+PXm6dr2zpNq8jUzIKO7tvlUewzDKwYQwloYyEjtqPavd968QSVy9XNsyexCo7OPu8qkcWUH3hA8Psu0aqYw5gK9B2fQLwz+/aSb4/DgbUGc9QOE9Iw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VM_BUG_ON() is out of favour and on the way to removal, since I recently
touched alloc_pages_node_noprof() I am removing that invocation, and
also removing the __folio_alloc_node_noprof() one for consistency. If
this precondition is violated, the system will soon crash anyway.

Suggested-by: Zi Yan <ziy@nvidia.com>
Link: https://lore.kernel.org/all/7F866265-3F2E-4765-B9D4-9AB898A9C4AC@nvidia.com/
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/gfp.h | 1 -
 mm/page_alloc.c     | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index 4d57e9c0bf204..872bc53f32ec8 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -255,7 +255,6 @@ static inline void warn_if_node_offline(int this_node, gfp_t gfp_mask)
 static inline
 struct folio *__folio_alloc_node_noprof(gfp_t gfp, unsigned int order, int nid)
 {
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp);
 
 	return __folio_alloc_noprof(gfp, order, nid, NULL);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 25a83a57aab66..4c6815f84adc6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5427,7 +5427,6 @@ struct page *alloc_pages_node_noprof(int nid, gfp_t gfp_mask, unsigned int order
 	if (nid == NUMA_NO_NODE)
 		nid = numa_mem_id();
 
-	VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
 	warn_if_node_offline(nid, gfp_mask);
 
 	return __alloc_pages_noprof(gfp_mask, order, nid, NULL, ALLOC_DEFAULT);

-- 
2.54.0


