Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6A41606A33F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlpsnZCn
Received: by kanga.kvack.org (Postfix)
	id A04EC6B05B1; Mon, 23 Nov 2026 18:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6766B05B3; Mon, 23 Nov 2026 18:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C8F6B05B4; Mon, 23 Nov 2026 18:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7AD6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:59:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C07D91C42F5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:59:06 +0000 (UTC)
X-FDA: 85468052292.05.C2E7B20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id A89DD1C0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:59:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlpsnZCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+arina.kharlamova.mbzuai.ac.ae@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+arina.kharlamova.mbzuai.ac.ae@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795478344;
	b=pX70uLIZ3pmDq/vefYTtSHi3WxA800y65bQl05c0vmY5dNIV7sq3GPEgkDnqh+5R+ExeEZ
	NIvMTsXG0n9jc5UZm5CFv9H5Gjg931vQ6aHITI0DzNlitH1EHWZW1lSJ//9rVwfQJPVr7L
	NDHI3H1k2iFXcwIVHVQbkiGfOhYWHio=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795478344;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hwii7vj0qMB50+PolmP4b2hhHOl1mk2HpN/JxsVpo4s=;
	b=bQz5deqmZF14flAxkeGTwzVMZKZI5rUXjsCffcvrump0rkSTMtgUJTeAO22AKhqbe0UgDt
	SLkpqOlEYREPCK9lpY9rVrljrtuMjXV4rTkpHlQgUEQIO+2HHE/xtYu8oZ7ZOmge3skCMX
	Pl2/IzmyT1pWX6BicMXlel282rgEF64=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlpsnZCn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+arina.kharlamova.mbzuai.ac.ae@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+arina.kharlamova.mbzuai.ac.ae@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29EF760018;
	Mon, 23 Nov 2026 23:59:03 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795478342;
	b=s0tbTPdR+jWQhQlrAz3b4dE4ZENRC3wbNwE64JedaM5vKUKUctXnEn/dmIgFRP19UENl
	 IlNfKuUTsZK5lEdhtSDEJ2S83mr/tMbge0Ef6jP0KuNmKc3Nmi0hVGSkOR4E0deP51NH2
	 DYiXl6ppTKRuK8pprZfQulhCdzHumqSmdI6pmjsvEzqQ+w+ONSlm4/J26Ia02/zpBgQT/
	 4jU+13HLJ8pix5M/qK5DvWLkPMlxGqxAattu4Tj7ClJ0pVUWr3sP5TiNTruXz5PuvbZA/
	 1pe0U0DRnmBQ3v/JUabY5pr69315/fr0p8ACXfTRljBIUzeszZY8qhO9zw57VqwyQ7A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795478342;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Hwii7vj0qMB50+PolmP4b2hhHOl1mk2HpN/JxsVpo4s=;
	b=XYInjS1GxG7qiFVEf7LmpRchml6NeSMQqrXU1yTBdpF1bu6K32cHznHtmV9+s5+klrb0
	 MUik16lg93JnDhPGjc1ql+hpC+CQQK1cCjd38iUz7LYGHnkjDbOkFC3Y2YgNNhIRz6NLM
	 iAZxcvYHWr1dFN3U6HLJQYwQyYSY8hIoiy5bWySFd3bDNRzIf8vf67u5JvLSXOM4khN9n
	 ZKqqakOpmTQ3tbjE0VbvUAd2V2ngg2yHHKs0g58k3eI5e/TOKDQb7kUEeIqAr/BF9Iva/
	 RKxnqXMsCb+52l1x9n7PQUfzz4b9151tG9Pq8xTzfc1ue2c4Cp0nh9G+5JmaFHC8gKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ABA141F000C0;
	Mon, 23 Nov 2026 23:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795478342;
	bh=Hwii7vj0qMB50+PolmP4b2hhHOl1mk2HpN/JxsVpo4s=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=YlpsnZCnDYM5Y0Efu8Qa1tc5iLxAkr65MLam+itVHAxa2cstPu6J+PD9Ih1ZSyL1z
	 sMVeBZ35Aw24mZS5rtIK+DvMvr71FSOzWaQMmMvKbhHfTi/2KaGDmlDwKbpOnn/zm/
	 D8USCp6ArjhEw9PeN60I07WfDX3rCAGz5zO/wQKpZ4PTPzDSmIwEeGseTXhQ8yO9xk
	 myTtx1y5VEhbH1oAL9EaUShQaY1zVcTEtw7HKKZ4cwq5l4PxPyZwCh5x5BVgQ76Bwo
	 hkByU1MUQcc1itm9smeQpBCnRUMlrGBS+uEvsZABU4B/84er93dXaLZe1bTrl348Q8
	 9mzkR8XUkaFkQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0F7B44C7CC;
	Mon, 23 Nov 2026 23:58:57 +0000 (UTC)
From: Arina Kharlamova via B4 Relay <devnull+arina.kharlamova.mbzuai.ac.ae@kernel.org>
Date: Tue, 24 Nov 2026 03:58:53 +0400
Subject: [PATCH] slab: fix the kernel-doc of kmalloc_flex() on counter
 overflow
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-slab-doc-v1-1-9f14dfce47c8@mbzuai.ac.ae>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXM3QpAQBCG4VvRHNva3TbhVuRgfwYjoR2k5N4tD
 p96v+8CxkjIUGcXRDyIaZkTVJ6BH+zco6CQDFrqQiltBE/WibB4ocrKeCtNkLKAlK8ROzq/q6b
 9zbsb0W/vHu77Aa5/koJsAAAA
X-Change-ID: 20261124-slab-doc-1894ca04d006
To: Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Kees Cook <kees@kernel.org>, 
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linux-mm@kvack.org, Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795478335; l=6300;
 i=arina.kharlamova@mbzuai.ac.ae; s=20261123; h=from:subject:message-id;
 bh=5QShQXRZX54gNTgo0Gx3CJ2jzLByJpRHbpnqHOcnA1Q=;
 b=1eSZpwSTpC+3FeEXiCh//wqMlujfe0v75aaKlaNcdfpPcrsBt+RFLknIU+B407OxXm5P23JDj
 87e/QpMtB2lBBq4wxtsV6OJt5sc0ya3E/trBJjv9gwM1F/sPOy9RgXc
X-Developer-Key: i=arina.kharlamova@mbzuai.ac.ae; a=ed25519;
 pk=DzQWwMpUtJvSDuzprqvRdbrC72n4Sq8dW6cq3NRt2Mk=
X-Endpoint-Received: by B4 Relay for arina.kharlamova@mbzuai.ac.ae/20261123
 with auth_id=1625
X-Original-From: Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>
Reply-To: arina.kharlamova@mbzuai.ac.ae
Content-Transfer-Encoding: 7bit
X-Stat-Signature: s8mkq3y4bkhshcm4m55kspn5g9za7c56
X-Rspamd-Queue-Id: A89DD1C0003
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795478344-999872
X-HE-Meta: U2FsdGVkX1/G3yPo/5aqEJ9GdL7hLkDzFltnA0PXlrisVJju12/wZzjOb0wet9hXBvfjyNOx+bbYF97Mc0iRt3hB80anP6sW2tQYHzU2DFSV4husGYXObmGgQSTnp8ThFYW3nDB8unRAsotvv7yrFbN8PTjMvKeOyeUKxt+qwVse+f3RSmTeqfLCmbydMGWQKWYCjlgPmwaiRLn8mBgG2XNZM+egGDQ1Qt423BY33M4w+kpaa+O3VPkxqWbeGSZ2OG4sirq3rOJXXfhNfhWvQn9z1kNjFU/G4sS7PoX33P6r+DBeQsZFCQHCm8fhlYDhEWsFPnEUpGPoPxGhYgNIO+FaZELFMCiJTsfEbt4MW64h4EwJnAhFBLT6/NEgFBMhlHBGbWrlUkzlEAkrFA5cxFXvp4zRuCXlXkIhc4d8rAKKXfx7FnOPisggkft0/cu/EVhJdXgfiF/+bUaDPs9FsHYeTrMEjXyKkRb9h6mRaiArwk/ZI3KA7dILXX205HyLfdTlkgc3KZEjpQN1Ffidih4m+CzwwjTV/mzJ/yXWR6IF6WjLyEUzdW33lHysnkPFSQgLPTIA4A35/qNcflgRQf/A+R5DCWiuDGwrST7IbHoPpILHW5uKb9ajJHXCOXWiO/LGJPezCgyBsIxXSxD+2UcHFRIAqRSGwMBXxPBfFPGAgqKIraEchkit5bvQ0sDB1HJmk2WbLoOLpreXRXwFoPQvzDFo60NU/L+ZB/gEL814Fi3RbEP2vuRzB3mx1R51mafSp4QJaNnWhqIHuGpFQN0om6ggY3vciLueaSE8a8HZ4BjwlIWC+cQRAaZe27Makn8edO9iC/QgE2ePPZqhMIR2cFiSY096nIFST6WTUtJRJtjB+mOt3t5JcZJER3D4Eqg1n/K/49QPYbhJCkBIH0lRoWyMoYPbBK7VG1PTwiWxxQp/Btb+zECOTWPsOvg/c1jm7xx71U5C5HXzcUq
 CZZUWMsK
 A8to+kpm8zt83h9UqZnM/TaNp5rnS9OjCEV5F7pVhpTkOsoVvkAHR4PQR8JP1oHVxCwKd4D6kN4RtCQR65FnFYotSTz9mSu0UUq6rmeIZIc5cVoYU5Bme95Cxjao750QXC1GQXm8x0w3BbzqFULt3dpPJmGi6kT7agKhqoxKEJ5pWkoPm1BIKUe58bqOSiGhuA9F+RfmdV2uXyD+Z4G8PFUEqUBgqHhWbFSJmY0bj/1c2hAAWadZVI4BlxDybGAW3d4waUGQm6iWNI4RtJyqXHsQKkkMlw3rCvrrM918hqcCNnvkrzRYeApBD1FTg9YYOy+LYUZX5R4Q/d3osfkVZC/me6gPdTkgAO6dJubskvFHwIcIebxFKwhUg6rctL3fCJ3/E92OShHfsoZZOa4naopsUsC8q+nrgoiIVOYGjVC01r4fpYSl1q7B9OC0jTePku6AFgWTM1f7KubeNy5VN3nfOM/L5/HBfClkXa1QgCnpioVH7ZArl4jhcZ8/iMJTdO9YaUnQeQg1uqRxIuq0qjpQ8HWjoGoWl39iekYgzyEzSnrI15oUHcM9vpkthkXpqW9ikbLx8AaGGwtjsKh2QbNL06zCgWAGm3kckBXk2LesV6GwDvL5mD3st5zmgtrX+a7uVOvTN0lt88IQ3LJvT2nJhTDwdC29DhHI/gZjzCD8hXPG5uJiGOPicXtvA5jfdmF1ttNePzqpQ8my3Z+us58r1tZj154oaaRzteb3QdiuALCRU+yNl7rDRhkqSgjKRbHQy4H/nqh6y3oA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>

Commit fa5c82f4d2bb ("slab.h: disable completely broken overflow handling
in flex allocations") removed the overflows_flex_counter_type() check from
__alloc_flex(), but left the kernel-doc of __alloc_flex() and
kmalloc_flex(), and the text in deprecated.rst, saying that the
allocation fails when COUNT cannot be represented by the __counted_by()
counter.

The code instead allocates COUNT elements and stores COUNT into the
counter, truncated to the counter's type. With a u8 counter,
kmalloc_flex(*p, array, 256) returns a 256-element object whose counter
is 0. With compilers that lack __builtin_counted_by_ref() the counter is
not written at all.

A caller that relies on the documented check and does not bound COUNT
itself gets an object whose __counted_by() size is smaller than the
allocation. Accesses inside the allocation are then reported by
UBSAN_BOUNDS, and readers that loop up to the counter see fewer elements.

Make the documentation describe what the code does, and fix the
Returns: text of overflows_flex_counter_type(), which still describes
the inverted logic that the same commit corrected.

Returning NULL, as the old text described, is not done here. Some
callers allocate one element more than the counter can hold and then set
the counter themselves: ext4_htree_store_dirent() calls kzalloc_flex()
with ent_name->len + 1 elements for a struct whose name_len is a __u8,
so a 255-byte name would then fail with -ENOMEM.

Found while checking a summary of the kmalloc_obj() family against the
v7.0 to v7.4-rc2 text of slab.h with a battery of inputs compiled by
GCC 15.2, with the help of an AI coding assistant (Claude); I reviewed
the analysis and the patch. A KUnit case (not part of this patch) that
calls kmalloc_flex() with a u8 counter and COUNT 256 gets a non-NULL
object with the counter 0 on v7.4-rc2 (UML, GCC 15.2.0); with
UBSAN_BOUNDS, writing element 255 of that object reports "index 255 is
out of range for type 'u32 [*]'". This patch changes comments only;
scripts/kernel-doc -Wall reports the same warnings for slab.h and
overflow.h before and after it.

Fixes: fa5c82f4d2bb ("slab.h: disable completely broken overflow handling in flex allocations")
Signed-off-by: Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>
---
 Documentation/process/deprecated.rst |  8 ++++----
 include/linux/overflow.h             |  5 +++--
 include/linux/slab.h                 | 15 +++++++++------
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 22a5e62c92ea..f8b7fb6f9629 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -405,7 +405,7 @@ become, respectively::
 	__auto_type ptr = kmalloc_obj(struct foo [, gfp] );
 
 The argument gfp is optional, the default value is GFP_KERNEL.
-If `ptr->flex_member` is annotated with __counted_by(), the allocation
-will automatically fail if `count` is larger than the maximum
-representable value that can be stored in the counter member associated
-with `flex_member`.
+If `ptr->flex_member` is annotated with __counted_by(), the counter
+member associated with `flex_member` is set to `count` on compilers that
+support it. `count` is not checked against the type of the counter, so
+the caller must make sure it fits.
diff --git a/include/linux/overflow.h b/include/linux/overflow.h
index d0f04436343e..6ce610dbc12e 100644
--- a/include/linux/overflow.h
+++ b/include/linux/overflow.h
@@ -566,8 +566,9 @@ static __always_inline size_t __must_check size_sub(size_t minuend, size_t subtr
  * @FAM: Member name of the FAM within @TYPE.
  * @COUNT: Value to check against the __counted_by annotated @FAM's counter.
  *
- * Returns: true if @COUNT can be represented in the @FAM's counter. When
- * @FAM is not annotated with __counted_by(), always returns true.
+ * Returns: true if @COUNT cannot be represented in the @FAM's counter.
+ * When @FAM is not annotated with __counted_by(), or the compiler cannot
+ * resolve the counter, @COUNT is checked against size_t.
  */
 #define overflows_flex_counter_type(TYPE, FAM, COUNT)		\
 	(overflows_type(COUNT, typeof_flex_counter(((TYPE *)NULL)->FAM)))
diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad645967a3ee..69fa9066137f 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -1091,10 +1091,13 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
  * @FAM: The name of the flexible array member of @TYPE structure.
  * @COUNT: how many @FAM elements to allocate space for.
  *
+ * If @FAM is annotated with __counted_by() and the compiler supports
+ * __builtin_counted_by_ref(), the counter member is set to @COUNT. @COUNT
+ * is not checked against the type of that member: a value it cannot
+ * represent is stored truncated, so the caller must bound @COUNT.
+ *
  * Returns: Newly allocated pointer to @TYPE with @COUNT-many trailing
- * @FAM elements, or NULL on failure or if @COUNT cannot be represented
- * by the member of @TYPE that counts the @FAM elements (annotated via
- * __counted_by()).
+ * @FAM elements, or NULL on failure.
  */
 #define __alloc_flex(KMALLOC, GFP, TYPE, FAM, COUNT)			\
 ({									\
@@ -1137,9 +1140,9 @@ void *kmalloc_nolock(size_t size, gfp_t gfp_flags, int node);
  * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
- * failure. If @FAM has been annotated with __counted_by(), the allocation
- * will immediately fail if @COUNT is larger than what the type of the
- * struct's counter variable can represent.
+ * failure. If @FAM has been annotated with __counted_by(), the struct's
+ * counter variable is set to @COUNT when the compiler supports it. @COUNT
+ * must fit in the type of that variable; it is not checked.
  */
 #define kmalloc_flex(VAR_OR_TYPE, FAM, COUNT, ...) \
 	__alloc_flex(kmalloc, default_gfp(__VA_ARGS__), typeof(VAR_OR_TYPE), FAM, COUNT)

---
base-commit: 9b95c9eeec894e969d590f45f9b760e88ba92876
change-id: 20261124-slab-doc-1894ca04d006

Best regards,
--  
Arina Kharlamova <arina.kharlamova@mbzuai.ac.ae>



