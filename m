Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76357606A332
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8294A6B05B2; Tue, 10 Nov 2026 20:11:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800DD6B05B3; Tue, 10 Nov 2026 20:11:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73EDA6B05B4; Tue, 10 Nov 2026 20:11:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 56F9C6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:11:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7B381601C7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:11:21 +0000 (UTC)
X-FDA: 85421059962.01.8E409FF
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf07.hostedemail.com (Postfix) with ESMTP id 01A8F40005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:11:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794359480;
	b=aJspuZ78I73dBxYWLOs82ZqI4Nje/TcXnWaf4YXQMyVyziIgGZ57+1NByyVii0ypFE+upk
	H7IpZI/QV2khZgNXHTRGOmuXP8pVds0+P+RiWC/00VWrHWDZmTpJX+Xoez17jw6EiAvKpe
	Nkp11cPLFajf4lilfK8rF2UJvdw245Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794359480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=zKSEdF9+1/4Is5GWGmFxtOqEqpvl78JV1G/SHbLFOjA=;
	b=lnfAfsYNGK2+84+5PBjeFo9yoQmxZ32ZFlq5b7ebeL/boQBmu941D7t5e3mLTnVYConIDw
	V9QWzSslhn3OWFc0XM0iDAWnL6mzA1VcJavswKNVXwxi2YSJABtTJ7Q+VPvRs69V0czT68
	vO4OX5WjyYiq1QgIQFo3b7GHga40hOk=
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8AxYdGvwPNqPmMeAA--.22907S3;
	Wed, 11 Nov 2026 09:11:11 +0800 (CST)
Received: from linux.localdomain (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJDxxMyswPNqH5wzAA--.12474S2;
	Wed, 11 Nov 2026 09:11:10 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/slub: Genericize x86-specific cmpxchg16b comment
Date: Wed, 11 Nov 2026 09:11:08 +0800
Message-ID: <20261111011108.29311-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJDxxMyswPNqH5wzAA--.12474S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj9xXoW7JF1rZry8AryDKFy8Kw4UGFX_yoWkWFbE9F
	4fXr45Gr15JFZI9r12yF15uF1Y9r1kuanFgFW2vFy7JwnYqFy8XrWDZFW5CrWrWFsakrs3
	CwsrWr9xGr17WosvyTuYvTs0mTUanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvT
	s0mT0YCTnIWjqI5I8CrVACY4xI64kE6c02F40Ex7xfYxn0WfASr-VFAUDa7-sFnT9fnUUI
	cSsGvfJTRUUUb78YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20EY4v20x
	vaj40_Wr0E3s1l1IIY67AEw4v_Jrv_JF1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVWUCVW8JwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwA2z4x0Y4vEx4A2jsIE14v26r4j6F4UM28EF7xvwVC2z280aVCY1x0267AKxVW8
	JVW8Jr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqjxCEc2xF0cIa020Ex4CE44I27wAqx4
	xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v2
	6r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU8zwZ7UUUUU==
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 01A8F40005
X-Stat-Signature: uiohnmrseqnc6zsp4xsbfmdp1pyfa551
X-Rspam-User: 
X-HE-Tag: 1794359478-299139
X-HE-Meta: U2FsdGVkX19xKT2MXjbQQugwiQbgeycqFZ3DQqvZZWXzOvGLFGp8MEZ16CCidxQoy0677Zmpeo0sCgO052n7gNHOxyAba8VVezXb6NmWafISkmYWiyW4CXnuR7rBrm3TohaQSUC/nsGLM17VC2dBn221TjoH+B0Nb7kRhBS12+xr1EZI3vAiFJLmn0Kl3AaY55wNe6x03lpv/9gn/iCdJO1CKgTDY7ABfK0xt2HdfZ0h2muz3Zw34JYWIRfONARRelDvAguseMlsRuXAsScXZZOlj4g0LDFqpr3hG/Avyup0/sYnIinlUUQOmJ8zxntnmmhEDPF3+W0VthWxQROWFRCA2aujkJ3csyRC0p0Fd0GVBHUfzYfCR26twphzERGfmbZndvJxPMZ5nk/kJmR4wuEFBHjqYbyijQE3qACakvbBtSoX6uKAXmW/yc0LN5lzc9cFu2m+jMIZhtg1QOFMm+x98ETu4U+XFbpuYo3bzpcRB2akl3l+ZSRDWilHXdw2HfvIcyx1DGEszO6n5K3ShaQ0aJQzioCk/0MPg5NKjy/LWURT96w0O7vNHAoTo+qZLUGKMvz+mugRp8geD7g9AJM/8iEqWrioxS8bo/2+z3V9MXwgQnnE+94jQvxAJjqouXWpq7XjgtpUNdGidoZ9WMdiT3puwEwAXPYEoHBuHvOG6LMcWRQK6R+Fz1OrytZtaNTkdISuaU5LLxqhe4zVlvJNKanWPGh1ftvPT5vZpFZj9BclAG73nlHWCW1Hs8+bek+/bLQtb8eS/T0okm96WkSOJcu+rg5FKJ1Dv+bYcmPcq4lQEL/lD8kap3WeZ/dFo0yCiI3IgS3h9To5GAAqNsQ1jwVFC7jahIxmvkNes8d1nTn875QpOUVBFqKZ7aE2judEOvyDZSf2cQ3exCxKGhsiytRi8tYMWWZBCsx10dDANl/4JdOMFUcB+FX9md7O+aIV1QrlR2L6UzlOG1Q
 kz6pXVPZ
 UrcyWBn0JWktT2ODc2QDP1mRmGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In __kmalloc_nolock_noprof(), update the comment from x86-specific
"cmpxchg16b" to generic "double-width atomic cmpxchg".

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
v3:
  - add missing Suggested-by tag for Harry
  - use shorter commit message as requested

 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..090302f1daeb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
 		 * kmalloc_nolock() is not supported on architectures that
-		 * don't implement cmpxchg16b and thus need slab_lock()
-		 * which could be preempted by a nmi.
+		 * don't implement double-width atomic cmpxchg and thus need
+		 * slab_lock() which could be preempted by a nmi.
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
-- 
2.42.0


