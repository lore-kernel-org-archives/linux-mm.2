Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91356CCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 04:58:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD5AC8E0005; Fri, 17 Oct 2025 00:58:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD1A8E0002; Fri, 17 Oct 2025 00:58:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EF538E0005; Fri, 17 Oct 2025 00:58:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8D8DC8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 00:58:51 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7B2F59605
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:58:50 +0000 (UTC)
X-FDA: 84006401220.25.CA9AE0D
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E8C71C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 04:58:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5YGIGLn;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760677129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FyaD/7QF3Mu8ROsvlXVHmV8rI/Un42dcuEf3hG7QO1Q=;
	b=WgYotmOmy+X5OEF0xZxkCHZO/WX2RCql/vJ/y+N7yoqeLLssKzqx/XqrmH8mghU9GfUuy0
	/K0Iv4gSBAnU8j1ps+6tcHY6PChEgY4shED3xRSNIeHP30z1bnKo0QjqrE9kqVnFQStdBa
	5X0FHm/mtvNoMQUaK1znbsaXVXJHWrI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5YGIGLn;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760677129; a=rsa-sha256;
	cv=none;
	b=bTNoDwBBud2hCuKftDgNmtWxDu2Mj4CkydTqCtNVBD1fTuSR5MC+aYSr5VPunL8pybnYIA
	b3CRh7J/TxdhgVn4E9HhwhzfomqvWJg4dNYrS6/JLk5u97hjY431rKjFIaA4TRHY6AS6tn
	PEEQ0mCMaTsFI4O+dcCbYXCuOUpE6Vo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760677126;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FyaD/7QF3Mu8ROsvlXVHmV8rI/Un42dcuEf3hG7QO1Q=;
	b=I5YGIGLnI38dBetN2b64VAYoqXk/JdQNC02I/C5LK+TacJamLFE2wEoWc+b/bkD/DlZ+Mq
	gknKCNqSQhj8JtBR03lBVSuHpxBfons6KgJjXkbNYc7IN5bpw70NnHh+ikK/qjodSpc06/
	OULIHkqkEYjE2vMWsBBTvN0FX/746Tg=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH] slab: Avoid race on slab->obj_exts in alloc_slab_obj_exts
Date: Fri, 17 Oct 2025 12:57:49 +0800
Message-Id: <20251017045749.3060696-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 0E8C71C0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: n6s7xkm7wdchcu793uki8gzwegkestwj
X-HE-Tag: 1760677128-929952
X-HE-Meta: U2FsdGVkX1/IINwdjXES1FcM5wjhkVdegd5MpVoPMKMZBX0nKfBvTUw2JazIIBp85yfCB/zPMVxx2q3qmv2dxI8r7rPS0Up/nQdT95VAh6rWd8gHmjzM2PChNiRXs0gydbMIioG6RW1fH/8IwuquHC0O9BGy7qaK/2QqIchGYhgTTu946AkSlsandyWd45WJjUjlrzDD5aEoQlh3rwUPUbGswurzQx5mT/K6NOhcwjhVesSeNMwx3CHRBmXQlGTSc9yy9IxggiCQU4A0XumOZm/nzA00JLTWLlupiPhwggl/ubNBNUsFrW3qGYAQs1n3o/fl5HERybvlhzSdA24JeU/PgrVnsXI3dF4WJLEa11sAASaoAPmeiyFJA+QofLafDHIQAKjUU1Jq+MJy+4U0f3nnox5l1oCc3mN6CNPWCgQlIX4g7JpJ7UkaqTMvYlprGctiVOcPfQbtWUI7k6vhTPZC2VLqakjVV9+Xn2OP0+0hAVoVAAwFgf4HDWRP6ii3SrpACn/exfFotHufKO2W2ivrRlaf6/vck2McNPaCOu5a+knYDcLbO83p2OAZlv6xIiVM3HXMRbt570MoI1snkOE/Swr/aDEB4rcY9cWNT1y0UqjkVFHVlXBmntBM4fu+cV6jDfiImydWH3m9IlInl3aT4t+FYNCufqx9NZYwASyI0ou2hixGcBai+7AlBD3UoXVsdOyzjl+ULOucg63k72Q6+VdPsUl6n1wrA0dzIDcpWxayDOE0oU3lffKj9rvVRsHxBP5KZ3Vq2Q47wzGPipIDTqo4YY8wi6dLC36GUCaG0M7SV63sUtncFWL+MuHp9mCEPgpWJUBJDSxhg/Qb/m9l5/nNBF4WveUF9vWgUhCi7bNLYBhYLAJWP56+JkDN/8jnLeF5NEgA+c3RWpI92m64PNLkPaXKzXOdv0KAqFSn4sQYZPqnJgBN7IvR/qjxcIcKtMu+mAwj2PxlPUG
 Vbt0XtCx
 Box90QW+eyJIzMPEZP8r6WjaeaU1qEXpjKZt/fkXFJaS06yCLcyz4y7LakHEDlDpkVtR6j6SOOuD+PNCHipbZy/IoM26lLe2hsoMfARQO+SqInlUo1YlMwHVNVgfiSY1F9UT599ZdOwIeiWUi4eKipOS0f4VfteoeaPHxys1X4TLYRly56PM1ArpWXYpjk5q+UZRp+LFwE1DmySJLvMru/pMMRv0Bm67DrG5LLgoNyDv1vt24MWhI6zO9BQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

In the alloc_slab_obj_exts function, there is a race condition
between the successful allocation of slab->obj_exts and its
setting to OBJEXTS_ALLOC_FAIL due to allocation failure.

When two threads are both allocating objects from the same slab,
they both end up entering the alloc_slab_obj_exts function because
the slab has no obj_exts (allocated yet).

And One call succeeds in allocation, but the racing one overwrites
our obj_ext with OBJEXTS_ALLOC_FAIL. The threads that successfully
allocated will have prepare_slab_obj_exts_hook() return
slab_obj_exts(slab) + obj_to_index(s, slab, p), where slab_obj_exts(slab)
already sees OBJEXTS_ALLOC_FAIL and thus it returns an offset based
on the zero address.

And then it will call alloc_tag_add, where the member codetag_ref *ref
of obj_exts will be referenced.Thus, a NULL pointer dereference occurs,
leading to a panic.

In order to avoid that, for the case of allocation failure where
OBJEXTS_ALLOC_FAIL is assigned, we use cmpxchg to handle this assignment.

Thanks for Vlastimil and Suren's help with debugging.

Fixes: f7381b911640 ("slab: mark slab->obj_exts allocation failures unconditionally")
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
 mm/slub.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2e4340c75be2..9e6361796e34 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2054,7 +2054,7 @@ static inline void mark_objexts_empty(struct slabobj_ext *obj_exts)
 
 static inline void mark_failed_objexts_alloc(struct slab *slab)
 {
-	slab->obj_exts = OBJEXTS_ALLOC_FAIL;
+	cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
 }
 
 static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
-- 
2.25.1


