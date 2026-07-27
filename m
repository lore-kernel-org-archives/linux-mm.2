Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8258C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B4EE6B00DD; Mon, 27 Jul 2026 08:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D996B00DE; Mon, 27 Jul 2026 08:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753726B00DF; Mon, 27 Jul 2026 08:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7E56B00DD
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0D521C0D52
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:16 +0000 (UTC)
X-FDA: 85034549712.16.7E27D8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4FFBC180002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl1IICew;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkNplhM/y3R+94Fey7CDvmc5bFFT4YcdBJTslgRYoxk=;
	b=DTC/qp+z3Wiv4fH1gd7vjzVJkobE1b67Ke3oOtBrD42Egm2CQcoKG9SWQLQYr10jBDH4uE
	KRexRwM4oTVzLyroIIikQMVq9o2jO2eORJ9VGe4YYrUkPziIemQfz6T6DDMGsZZ+KoAq/v
	TZXZAuocyEMlRY3SbPlhDxEf9IUQDt0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156855;
	b=pQaO4e9VDSaj4C6L4MeIr5jBzL+r01Xtvh0F5GvL9HWIxD73KeJrEQopjpvxjt4JPm5wIv
	BQGtzUpHnUhCxXLMwwhkKUrcfhE0PZdGmpEZHiYI7HTVLPme8dW3eI0ELsAgF50nYWNsmx
	iPKqzOlbk1fCovX8I4GE2ciGsTbBCz4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Sl1IICew;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E546060A61;
	Mon, 27 Jul 2026 12:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0DA41F00A3A;
	Mon, 27 Jul 2026 12:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156854;
	bh=AkNplhM/y3R+94Fey7CDvmc5bFFT4YcdBJTslgRYoxk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Sl1IICewU5fK/CFdCu+iGLgFr/fFrUa9aNFj7OSJINXRLQgNvIe2aAu1rP8r9YYQV
	 4STcTsikq063EJKQuLl1rJyK5DrioXdkBKJV0unvCWHr8/Jq0PdhkpF/D+Eod3XUXc
	 NLRzJHrxyttwxK8JeA1qh6Pdmdsh5TejMiQxEDIowmpecijin89SEbjwrPjuKGv/rY
	 VcP5D78yCjxoIsEtP+VTVQKq9NhFq43iMPL36RD4BdBuaL6Cf3ld4ATp72l8/pRw4Z
	 iYHIqiJ+AZzJ0jH/I4ocGrRMGuP2HgwuIOvAMhhkBc0918hNWZtPFsyMw4bPHQB4gw
	 M68a92q4jC1BQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:56 +0200
Subject: [PATCH v3 02/13] mm/slab: remove objs_per_slab()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260727-b4-objext_split-v3-2-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4FFBC180002
X-Stat-Signature: 79k6d8ubh1ztfi68qie76oh63crqid74
X-HE-Tag: 1785156855-526630
X-HE-Meta: U2FsdGVkX18CmAJ1Yg/Ye5gn1A4JueKPGJ6HbrC02BjaH9/ZmNBSQnlee1jhEqE0rSVmwBf6aZRMIB68/E+EJOYFyWiGHaPE4BINeYkUUehAzwDNnnrZqBsH+ah5L4SarqSeYS071OpjB6szywDBJJLhWS9mm5ebTR8qLbZgVIc2BC8EdTUiPzBZVDp17vu/xRgzIaiiZtAkb1SNyhthkw40mCOyaOOUZD7uglrTc+GMKUeR4aRnWILudZ758QCwafAcvvaBZkrV0HIrMkLg9mxbQQ5ohQV062Ev48FFlQL2qjm+BjCvlF7eZBRHRlUWbcpmIdv4waOjhsiIpe7R8uE5lcY41nI7McbjwkCv2KFibFzPqOZZKlGqfcXO5dw7RSHlhLxRFb0CAgtKiBfjfGsUD9Ll7qiqiDXDkEsNef5a1ajZlFZDb4UItPGtA58wzefcvaS9rMPJSZSxcPm1dleisZQfFyRTBFHBBWovBWN74XCT5YS6rx7rmPaHiSkdLyPPfa7fLtI6wv9hMWxTZ1fMOrzsLcZ9OlqrjhF4LZ9g76OiE5xDSfM5ystsGZE3qkutGvHbY0/aGOuWWqcKp/CIkRYwlcH3jZgRik7jYjTH6TpY2L35Cmz1kSX7t4/PDFl22IDDMRPUdO4LaZPAkoTG43e8x6CtMOAT3rdBTca+ZkeFsR52cClYybPlfXMAFP3Z+k/3K82vd7E/+n4ZTI5tg4RxAFUv8GB2ntTG5iFLrnPRcRp3RTnpfdsbHal1kkG/nUYL4gf5lc8Jjy+IXr64LhYJxrp0urm/F2wvh8Ji7KzW2OphswsCDo8IIW7xJIemuIznffSoCOqApODkEu+g04wjFQN0uPPpX4siQ9twO8VtL+jA4XuMVqtPMCOHf+QPeAxzIhNC9iT/VNZcQCZo3OySEkhv76pWa05OQtMATzPLp6NFvKadgQK/bQw2ScKSH3RgzaIV88qf2QJ
 4w3TZC0+
 0Ld8WOqN+ltl+ly3kqKt+YjyhmDvmJV9EMz9rxlACtTAXB0CYJbx0HRt4RYuvsu6bynFZfZfcdKeSo14hdJiABdBlLgckWxtXZU/XvDE5vfcyeJgQAM4kmBtvf6WrgF1GUptPXNcV8MT4gL4Xf2UlEGTEZMxw4VMKNr2dLR5FPLGxbLGut/gh5Ut5l5Lxfk5sC89sCD84WTlXEL0nUcQwTZpCReGQnTr+cet9ixkpkqsmd50D20TuVhnB8d2LccSBDgVaU2paHMt7hZTOR8YFSfMrN/2fmwAF3Xz+wnIu8VcXyESREYj7jr3OoPlQOXFmZBgOd1Mbb5/sDCwSA9+9HtIg9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function has an unused kmem_cache argument and almost nothing uses
it anyway; doing slab->objects is simpler. Remove it with the last two
users. KUNIT_EXPECT_EQ() needs a cast to avoid "error: ‘typeof’ applied
to a bit-field" but we don't need to keep a wrapper just for that.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasayan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/kfence_test.c | 2 +-
 mm/slab.h               | 6 ------
 mm/slub.c               | 3 +--
 3 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/kfence/kfence_test.c b/mm/kfence/kfence_test.c
index de2d0f7d62b1..9867c03ef0ae 100644
--- a/mm/kfence/kfence_test.c
+++ b/mm/kfence/kfence_test.c
@@ -295,7 +295,7 @@ static void *test_alloc(struct kunit *test, size_t size, gfp_t gfp, enum allocat
 			 * memcg accounting works correctly.
 			 */
 			KUNIT_EXPECT_EQ(test, obj_to_index(s, slab, alloc), 0U);
-			KUNIT_EXPECT_EQ(test, objs_per_slab(s, slab), 1);
+			KUNIT_EXPECT_EQ(test, ((unsigned int)slab->objects), 1);
 
 			if (policy == ALLOCATE_ANY)
 				return alloc;
diff --git a/mm/slab.h b/mm/slab.h
index f5e336b6b6b0..01535e1e2d3c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -330,12 +330,6 @@ static inline unsigned int obj_to_index(const struct kmem_cache *cache,
 	return __obj_to_index(cache, slab_address(slab), obj);
 }
 
-static inline int objs_per_slab(const struct kmem_cache *cache,
-				const struct slab *slab)
-{
-	return slab->objects;
-}
-
 /*
  * State of the slab allocator.
  *
diff --git a/mm/slub.c b/mm/slub.c
index d702d273253c..b94482830637 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2130,7 +2130,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
 	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
-	unsigned int objects = objs_per_slab(s, slab);
 	bool new_slab = alloc_flags & SLAB_ALLOC_NEW_SLAB;
 	unsigned long new_exts;
 	unsigned long old_exts;
@@ -2186,7 +2185,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 #endif
 retry:
 	old_exts = READ_ONCE(slab->obj_exts);
-	handle_failed_objexts_alloc(old_exts, vec, objects);
+	handle_failed_objexts_alloc(old_exts, vec, slab->objects);
 
 	if (new_slab) {
 		/*

-- 
2.55.0


