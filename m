Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812AC606A334
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 19:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=WQFn2g6D
Received: by kanga.kvack.org (Postfix)
	id 8BA966B00EF; Tue, 17 Nov 2026 14:59:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86B526B05B0; Tue, 17 Nov 2026 14:59:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7816B6B05B1; Tue, 17 Nov 2026 14:59:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EEB86B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 14:59:42 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CBBA51A0577
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:59:41 +0000 (UTC)
X-FDA: 85445676162.07.C180B59
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id CCC9140009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 19:59:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WQFn2g6D;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794945580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+3lEqZFrEAIaz6BaymSj2rnmWToXuf3nkXT7gTYNKk=;
	b=S//ayOGWfXHoANTCnuRDOLfBkYYZA3uycNths4W+Rv5WnPUPyZv+qsVH6xAieg6wj/ZT68
	1RuFYXmekFu77IJT/6rcFEDaLfQz72FswOXQng4enzcOHbXkRdfYkFMEpk4gf0GwWzFV9y
	2eXBI+X8b3Zu18xbWgATe6RYP0VP15E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794945580;
	b=Ecwg22JBgypFyL0GeTJBl+snigW39uUrUa3tUbc7GNJzXU+paIXPVwxVMQtGatGkGuI46y
	BWBrUe1QlmALgzi7TzluCYf2GKDHiIKopLt0jSLxiLztdUDj0vm5HsE6ixlF8UR/RJC+q3
	Qm3ficVV5x4JM6c2zV/+nL3YMm2B0wg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WQFn2g6D;
	spf=pass (imf04.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5430f70c827so2553991cf.2
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 11:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794945579; x=1795550379; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n+3lEqZFrEAIaz6BaymSj2rnmWToXuf3nkXT7gTYNKk=;
        b=WQFn2g6DLGIXd2uS6o5AZ0vkeGdZhQo2lwbJ85ExHYd8EW2OnccKE+sKmpL9SJMTij
         K19UksqU0mn4lYCLcpSRPQT55JIK/lFkvn+XlV2PLZ9fl67VyWbshDuo7xjxKCncvVzR
         3i3vSsP6Qb/d/P7mNhYyRo5TJWC8lcXpI+sRCbIEImXXf0Phl17/+aZQxGY06mYF+vxt
         DUCq/V9BAGL5DA01NUS4QLrqKT+72JUu+iNXTzN3cMKvTuPWT2AAA+FlFCrLDz3VDScl
         SyJXLnDY9SqtjVJTNhwbi4JLMvodU2417sS6ylZ1RacHN6lhvxw+dbHCDAl3AjfpBnGh
         Dv+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794945579; x=1795550379;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n+3lEqZFrEAIaz6BaymSj2rnmWToXuf3nkXT7gTYNKk=;
        b=QeW+tx0aZPqR8pkJ/ewwrkYsvN1UcbfjYCYw6SmltI8YaKw4zGsRlauySEI7iIIInE
         4F8izLU9+bnThyo7Cupnx3X8uw9YmlPg+Q+IC67ui2bM9g9o902OK30TMPRhAfoRWJdf
         cZC/bzIxRvVRGRIt93H3ihxq6Ld7eQbL+tDv9U3tjmvJl2yuSFYsW4OYoh5+sFHuv+Wi
         FAU65wccrEQYYY4T35sMxbSyq8ZVaMuvHCoQfkXP0m1ozL2K+mYfj8cB9h2LLl09yMdS
         /Q/ZHn9rGtyjxg+ewMVT6/Di6IgdSR8pCmFod4/POt0EcHddy4A8Ppre4GzSK6qKq46P
         2lrg==
X-Forwarded-Encrypted: i=1; AL+hErEVXSlP3BmOJGtlWngIZthSxW7T0qBWvZEsFgyx9GG/4X6DCcWS/f8vjmlmZDZPgnshJPTaxAli9A==@kvack.org
X-Gm-Message-State: APuU4Z+yvqyNF2y9BdfI/h+3TnNr6OlZyngAIRvPo+BlnpJ+edt317Uz
	zROSjNNJHIWoZUgoXfAd6h46mIL19Nr+L8Qqq3+1qJAYM1AKjEiVSoEEilm1B65sHbxHBJS6qQB
	QqWNy
X-Gm-Gg: AYBFou1mDDq9qUiZqP2/54odTG/hBKoLhb21xac7Wxd60auR/8IrYITEROwdMgnU9Lw
	TKhiV7uBUxFHVz7b/vqgY/qyKXXlRfsjYOov8FaXVVZ1yKfodLuv0ge7lUF90GkavI7QVJP2MBs
	EABIa4Hi//GhVhLOKgRkyL8Psm8fqXzU4400+h0JDlULKm3qjPL3dbSVbvlQyNswWdD7yLmP8kg
	Dnt9XJTU1/Pe/EeZienz8IUn0hhOt6K57QTZMv4glkT6zTQiXngWRnAjR0iGyAQz+6NMqdsexVV
	v6enqrYzpybrvPWxVhb9ycWYhmWqwQDa0HjIrLaVnQKHKoE6HhN2jUvsdDFI7/KVCdIRisy01s2
	1656sqp5QKXFqNIrD7VRqcy8WAFexViu223SZU9L1RtIjMYcCG/NupEAMlFuDPJGP0anKNcmbdn
	kEcAru1TvLX4RE4IaZwUoHgbO3a1akDsJP+f3+lEE0G1LyRLAuaKxAY9gUAGif3WMHN0evBpV9v
	bd5CxhM9u3KtAfLAISxYzIv/OxynHp8fpwnz1yS0nOh6HVbYy8xWkiW+/sY3UPgA4JmhNSdNsS+
	CTXcfpwvfiddyT4Cl+GD+ndJk7UaOps3bhUSn8yXOp+cKgcCWvKNZRTajdq5HyFnKDouAc6/xrA
	nHyvP5X9oIG92WRh7D6ji0FkXiNAp
X-Received: by 2002:a05:622a:480d:b0:536:72b4:b84c with SMTP id d75a77b69052e-55d5a4d0b40mr5934331cf.27.1794945578703;
        Tue, 17 Nov 2026 11:59:38 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d59035c81sm4825961cf.12.2026.11.17.11.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 11:59:38 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] mm/mempolicy: fix copy_nodes_to_user() for odd inputs
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>, 
 "David Hildenbrand (Red Hat)" <david@kernel.org>, 
 Gregory Price <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, larips <larips950@gmail.com>, 
 stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jackie Liu <liuyun01@kylinos.cn>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <avx0Ci5uPW_hF0Jk@pazuzu>
References: <20261117142628.3931151-1-arnd@kernel.org>
 <avxnIQTcFni9G4IN@gremlin>
 <541a67af-3b45-4d5d-ac4b-c741850f92e1@app.fastmail.com>
 <avx0Ci5uPW_hF0Jk@pazuzu>
Date: Tue, 17 Nov 2026 14:59:37 -0500
Message-Id: <179494557732.482102.7719202079181127037.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CCC9140009
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: dmjupk1x4udirx7piijem9xsuhdbdyio
X-HE-Tag: 1794945579-482964
X-HE-Meta: U2FsdGVkX18AL6T7chZJbUQoSU3NJVYLwGA0BbT5gaTKb8bTFuwTknEvCx1sLgi8zU3nCwgFC8o1IJNn/V8XyFGwZhQS5HioxSXdGt1elfP/DqhcWW4wfeDyEER/3k32Nt3yQLKfyJmBrSFFm5ftJWJ81KlRa05xSIIwyCe7BKd3+/RU9/y30qb3kbmmUmf1O3GMqWtg/5m58+D+t+iQuUwkbFCNrNfW+ufbxXiJjtXq78Uq9lmoj9HBwweMaXSVs6oAswVaVX8pzLKfTYmkqNEkN+pxgFtKO3I80F9+gzH5XciXoNgavIek8o2kHubJQkmWv41SFbXH/MFm4FtBTb77RS60MTGheizfqsAsS4f0KwFCdQ5cT8nVxilcfOe6vHS5RdnzvZCdM6U65AIFuIrcyqYyiN4mq+etv6LsJUAfnsl9LAkbDRaTkNDSLT4Ru/KVLkHFw651yZi5VWD84RtbyGjxX4l9Lm3sIQOeSXBiMQfcoB4W2HV6QM1/uFfB87+gkiAB6NaU8HHcjm5HycoHnHrDc9uQ940j6VhdVvDLZuG0iaZFm7E2bteUljbOGDcEexu5hGDFrDLiqdb1Wun4r0+0FBKTO0mNP2o3uXJGhT9lbgiBw/jGBE7HNm90vlg7AUFpkMFKMUW7s4dWp3j2Wv4nBnZnX2qTd9FmYOSfeq3QyLbNS5NfQhs0zXaJOuUpW6z0YniwUu8mUtgzs7qpBzdIIE6nBnrFaAIu6NbOFSUHe5ZSqt7OIzgRNVm9+OX+f2qiIti9lA/BcEHf5TLVgYRY9sK9PvHPJ9BV9b5/kxV5EqMigeiYw112lS2YuLOP0DsY1fBt0We93vOpyTwcGIsDlchAZsSlEfssm6zDwp59wLi8JFGUSyI/ob6poHwSEhhlX4fBYpN1Z8L4y8Wq+ZCnbmpAQuSX2kQ5quM40i153uDdDc7+lvl7XXI0FlbLW0zEMoHIkMwG0kf
 a5PeuB52
 TG+hbhwDivSACvnEAv4chL4gU9J/Edwt8JiZ4OrkQhjdV1rw6sfpoqclRvJJUa8H27xlPvvevfh3BrgGryLW20OXttwJUFYi0Zh8Nws8X0lt1XEcODxdK8xSjfHUyui31sPaSxkr0XvU0WxVrdFLvS8rHAqCA/m3MjVAVa41KUGb+UFbamZtqenJvRD1TC/FfBbtH45XOcPKJiG18Z4Q6KmrAz2oK0h1/s2oUt75dCK5MBwnVt2bmZ6GZ3SMVnVQFEfmKJHgagZURstyu8ipgnsQy0Ss+ChGO7vo67CiRz92MjW73BOzLGEOQLOawHeFpyWFCx4e2VOAI1gSFKVd3BfaeUGQkvxvZ8HjPmIpsbogaJilFiKuFNWtmDzE2GjG9cRJiAmUHzQw6f1HuCiuMT6a5AQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

What about the following:

--- 1/2 mm/mempolicy: convert maxnode to a bit count in copy_nodes_to_user()

Converts maxnode to a bit count on entry to copy_nodes_to_user() and get_nodes(), fixing the compat KASAN stack over-read and stack leak. Fixes e130242dc351, Cc stable.


Subject: [PATCH 1/2] mm/mempolicy: convert maxnode to a bit count in
 copy_nodes_to_user()

Whenever maxnode - 1 is a multiple of 32, compat_put_bitmap() reads one
more compat_ulong_t from the kernel nodemask than the caller asked for,
and writes it past the end of the caller's bitmap.

When the kernel nodemask ends there, that read goes past the on-stack
nodemask_t in kernel_get_mempolicy(), and its low 32 bits are copied
to userspace.

With CONFIG_NODES_SHIFT=6, 64 possible nodes and a 32-bit caller
passing maxnode=65:

  BUG: KASAN: stack-out-of-bounds in compat_put_bitmap+0x122/0x130
  Read of size 8 at addr ffff8880150d7ec0 by task mpoltest/241
   compat_put_bitmap+0x122/0x130
   copy_nodes_to_user+0x14a/0x250
   __ia32_sys_get_mempolicy+0x1b0/0x2b0

Convert maxnode to a bit count once, on entry, and use only that in the
rest of copy_nodes_to_user(), so the compat path gets the same size as
the native one. Do the same in get_nodes().

Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Cc: stable@vger.kernel.org
---
 mm/mempolicy.c | 36 ++++++++++++++++++++++--------------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 4da1cb8777f68..390a31a99b4ff 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1673,15 +1673,22 @@ static int get_bitmap(unsigned long *mask, const unsigned long __user *nmask,
 	return 0;
 }
 
-/* Copy a node mask from user space. */
+/*
+ * Copy a node mask from user space.
+ *
+ * The nodemask syscalls take maxnode as the size of the user bitmap in bits
+ * plus one.  get_nodes() and copy_nodes_to_user() take it as passed and
+ * convert it to the bitmap size, nbits, on entry.
+ */
 static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 		     unsigned long maxnode)
 {
-	--maxnode;
+	unsigned long nbits = maxnode - 1;
+
 	nodes_clear(*nodes);
-	if (maxnode == 0 || !nmask)
+	if (nbits == 0 || !nmask)
 		return 0;
-	if (maxnode > PAGE_SIZE*BITS_PER_BYTE)
+	if (nbits > PAGE_SIZE*BITS_PER_BYTE)
 		return -EINVAL;
 
 	/*
@@ -1689,31 +1696,32 @@ static int get_nodes(nodemask_t *nodes, const unsigned long __user *nmask,
 	 * if the non supported part is all zero, one word at a time,
 	 * starting at the end.
 	 */
-	while (maxnode > MAX_NUMNODES) {
-		unsigned long bits = min_t(unsigned long, maxnode, BITS_PER_LONG);
+	while (nbits > MAX_NUMNODES) {
+		unsigned long bits = min_t(unsigned long, nbits, BITS_PER_LONG);
 		unsigned long t;
 
-		if (get_bitmap(&t, &nmask[(maxnode - 1) / BITS_PER_LONG], bits))
+		if (get_bitmap(&t, &nmask[(nbits - 1) / BITS_PER_LONG], bits))
 			return -EFAULT;
 
-		if (maxnode - bits >= MAX_NUMNODES) {
-			maxnode -= bits;
+		if (nbits - bits >= MAX_NUMNODES) {
+			nbits -= bits;
 		} else {
-			maxnode = MAX_NUMNODES;
+			nbits = MAX_NUMNODES;
 			t &= ~((1UL << (MAX_NUMNODES % BITS_PER_LONG)) - 1);
 		}
 		if (t)
 			return -EINVAL;
 	}
 
-	return get_bitmap(nodes_addr(*nodes), nmask, maxnode);
+	return get_bitmap(nodes_addr(*nodes), nmask, nbits);
 }
 
 /* Copy a kernel node mask to user space */
 static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 			      nodemask_t *nodes)
 {
-	unsigned long copy = ALIGN(maxnode-1, 64) / 8;
+	unsigned long nbits = maxnode - 1;
+	unsigned long copy = ALIGN(nbits, 64) / 8;
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
@@ -1726,12 +1734,12 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
 			return -EFAULT;
 		copy = nbytes;
-		maxnode = nr_node_ids;
+		nbits = nr_node_ids;
 	}
 
 	if (compat)
 		return compat_put_bitmap((compat_ulong_t __user *)mask,
-					 nodes_addr(*nodes), maxnode);
+					 nodes_addr(*nodes), nbits);
 
 	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
 }
-- 
2.56.1



--- 2/2 mm/mempolicy: size compat get_mempolicy() copies in compat words

Rounds the compat copy size to BITS_PER_COMPAT_LONG, so 32-bit callers
no longer get 4 bytes written past odd-sized masks.


Subject: [PATCH 2/2] mm/mempolicy: size compat get_mempolicy() copies in
 compat words

copy_nodes_to_user() rounds the size of the user bitmap up to 64 bits
for compat callers too, whose bitmap is an array of 32-bit
compat_ulong_t.  

When the caller's bitmap holds an odd number of compat words and is
larger than the kernel's nodes, the clear_user() of the tail writes
four bytes past its end. 

Example: a 32-bit task asking for a 32-bit mask (maxnode=33) on a
2-node system gets 8 bytes written.

Round the compat copy size to BITS_PER_COMPAT_LONG, so it covers exactly
the words the caller passed.


Fixes: e130242dc351 ("mm: simplify compat numa syscalls")
Cc: stable@vger.kernel.org
---
 mm/mempolicy.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 390a31a99b4ff..cddca1db3d9a1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1725,8 +1725,10 @@ static int copy_nodes_to_user(unsigned long __user *mask, unsigned long maxnode,
 	unsigned int nbytes = BITS_TO_LONGS(nr_node_ids) * sizeof(long);
 	bool compat = in_compat_syscall();
 
-	if (compat)
+	if (compat) {
+		copy = ALIGN(nbits, BITS_PER_COMPAT_LONG) / 8;
 		nbytes = BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
+	}
 
 	if (copy > nbytes) {
 		if (copy > PAGE_SIZE)
-- 
2.56.1

