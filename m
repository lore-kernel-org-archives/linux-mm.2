Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9D7C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C2D6B0165; Mon, 13 Jul 2026 12:57:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5736B0167; Mon, 13 Jul 2026 12:57:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC4CF6B0168; Mon, 13 Jul 2026 12:57:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73E086B0165
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:57:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D4519168CA7
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:09 +0000 (UTC)
X-FDA: 84983985618.03.CA5C1A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A5CD40008
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:29:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DndLLiB9;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783952948;
	b=D3UouErQX1kgz+ItFrfu+069Xkd39ALpD0kZlVexyLW2M9r+cD1gv8e1J86Ksqu4Isg1dI
	UNdBZHlyw5WQu+gpUu2BEL3L949Uc/GMhd9bHjyWqi1XykfTPcYyLmEJPbtx1IjYvA9cLe
	bNvOkXnag197lloIdlVuyMuWrFf7UOg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DndLLiB9;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783952948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtRyuqLxHec+AIEMCGWYLc5A5j22LJ1kSJp888lWRJ4=;
	b=y+v8jdaZzoZRl1kNXz+kv23byIYavwLDuCM5xuxgZru1fDdUp2Pr60hbDArGVYgRiOG073
	S6YKdXDJSZBmdvQuVMXw7qKpMd4+IASJCUBxCVWWJA9LBokB3zx/myaG7qo86+49aIs1jZ
	miSxuOuJRRuOIWvY0C99dbnlWvM+oPc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DD074058E;
	Mon, 13 Jul 2026 14:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7571F00A3A;
	Mon, 13 Jul 2026 14:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783952947;
	bh=wtRyuqLxHec+AIEMCGWYLc5A5j22LJ1kSJp888lWRJ4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DndLLiB9yUJTEojiBiWraCz1r9jKwR36ryUJncr/4zWiv3MHsqiRNTmQNtKlVUEHV
	 UykmOD2ijPBOjopIPvnikZR3gNLAPuc7Md7uSw3p1bwi1/cV+3iUZX1czCDY99aapU
	 oZu6Eu+doMHnf/hi5CRIqnuZkDCHi1skwRclj9V75PxfK/MVMM5uHBmUxUoQJgsIW9
	 mEckIMBn9W8hQKX59fS/AGPrTF2FfqlhP2TyTjawPWf9pcqn/m1fvfZw+Wa64AXdON
	 1pAtAyfXoNMF1BhYwVrlJK4NM2vQvM0/Igszfjd8HmBp5Ms39oOx29keR4s+fP1HL7
	 J4p2nGb4R8Q6A==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 13 Jul 2026 23:28:49 +0900
Subject: [PATCH slab/for-next-fixes v3 1/4] mm/slab: fix a memory leak due
 to bootstrapping sheaves twice
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-kmalloc-no-objext-v3-1-47c7bd138de7@kernel.org>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3A5CD40008
X-Stat-Signature: o66i6f1rbri7xq5wtud63bim1sr7xoq7
X-HE-Tag: 1783952948-361444
X-HE-Meta: U2FsdGVkX1+lgKrzNRWXYQuvqqAq0mIBsodZnKE9hHyBkaiDc0tKp5gOH20uR3D1J2CUuGHxE2SnM7fAg+P04LX5YKg4BT4eL+Zn+tss+mDfCOfX5SxApoPEw+OQGuH5QsNIzfoKYs1/9SQIzOY5UH07m3ebWrDTBn4wmPOADU7I+CVDg+je9KWq1pVYs4JtumLHRNsTRss8qzYU11ZP4g/HvxBF11Ojns3JxrGjhO4Zw1lsNtL5Gbo9tNTZCqh9UdC7pj/fbSQhoIOjX4AISkFKDUuJpRhBvx6pDDo7+IRkoACnAraO5dASsnTVqgG8WR6k9ilt+bBBroAOmeGf/ISNwpaIRw7j1HSUbnW7LYES6z58Z3ShfAjzfCfC4DfgYZJS0m/kYk0n5swClmeYPA9XVBdc9xdEicVvPRW5WrXj3p3QAfTG76bw3mWLProaT/S3WSlBbRsBIIjfxJnrYhWmfTTKxecWpem7MeuxGLq/N4iZuhff5wF89S8kpTHB8yivV+lB3CtAH6y//pcru784O8UzJM+NUNQEzD5u7Ruivsxzai85wAvcxa1UI64QEQraJjdKvxlPwAxPrZ+2IkWPdkAVrUqHux9gNBH3NVf5/95XtQOt09CjAMiNxnKB6Wa4SmLMPelyu8MX3MTXNvOjKbSJjaBx/MDG2Hky40bsV7d84ClL7O5u2ZnYVWRr7PNvejwlIy1CkTok+pCqMStLKusc6DloppzIGeqImZfzpMr3ujBu2h9o7s9Lz7rT+j3sfRiyv5X/mnA9Nshm+UOqsIzamMcuzF9GNx1dhmo1XdbDue4z2uPH/s8LY7wXaKeDzEkcqPMAxzF2XiiUnP/yTvV32tgcnoBHlnQhbWz9w9WU52MkaToknKdayU3pbk2lufHu5jKqsvWL6ozCQtk2dKfilJV74GgsGor19TvANjdbhrjStjjTUGArUYKai2eLiLzFcYFiVvpjiHS
 c14lf48X
 tei7BZHi/Hl2HX9Lahx1k6Fv1yDJdBs+x5mywRHU4GPKPIpOQFvIjzaUEtEg4IitxDsk8PJh4jP74g4VQJmqGujMy1wAQfto6adVTjvDYjc5JXCkVdAqRU7ya9nQAOgQxcd5b0JZnnfLb0sij8NE/MS66WXj3dXPIaXBnWLU4eLs6/IPKw1fAtJp1xUdIpqra1TgQ0pYp8LJKxWEU9kfi7TN79uheN5BhL7jLkfB37z8Nr4okIpa3XFSSvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kmalloc caches are aliased, multiple cache pointers reference
the same kmem_cache. As a result, iterating over kmalloc indices and
bootstrapping sheaves can bootstrap the same cache more than once and
leak memory.

Currently, this could happen when the architecture specifies
minimum alignment for slab caches that is larger than
ARCH_KMALLOC_MINALIGN.

Bootstrap sheaves only when the cache does not have them already.
Add a warning when bootstrap_cache_sheaves() is called for a cache
that already has sheaves enabled.

Cc: stable@vger.kernel.org
Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 65febe957886..f9461a0c47d3 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8497,6 +8497,8 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 	bool failed = false;
 	int node, cpu;
 
+	VM_WARN_ON_ONCE(cache_has_sheaves(s));
+
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
 	/* capacity can be 0 due to debugging or SLUB_TINY */
@@ -8548,8 +8550,11 @@ static void __init bootstrap_kmalloc_sheaves(void)
 
 	for (type = KMALLOC_NORMAL; type <= KMALLOC_PARTITION_END; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
-			if (kmalloc_caches[type][idx])
-				bootstrap_cache_sheaves(kmalloc_caches[type][idx]);
+			struct kmem_cache *s = kmalloc_caches[type][idx];
+
+			/* Do not bootstrap twice when caches are aliased */
+			if (s && !cache_has_sheaves(s))
+				bootstrap_cache_sheaves(s);
 		}
 	}
 }

-- 
2.53.0


