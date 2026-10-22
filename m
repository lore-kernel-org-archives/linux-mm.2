Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7FBC606A327
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=readmodwrite-com.20251104.gappssmtp.com header.i=@readmodwrite-com.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=sHyXblFL
Received: by kanga.kvack.org (Postfix)
	id D5EEE6B08D6; Thu, 22 Oct 2026 04:33:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D35E46B08D8; Thu, 22 Oct 2026 04:33:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4C686B08D9; Thu, 22 Oct 2026 04:33:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A07886B08D6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 04:33:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82419C07B4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:36 +0000 (UTC)
X-FDA: 85349598432.19.48E55A3
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf05.hostedemail.com (Postfix) with ESMTP id B5973100002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:33:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=sHyXblFL
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792658014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Po10xs3c1tBUXr0/TED4BRLkJvTxT4ILiaYjl5lFoSg=;
	b=MBvdMRIE/e/H0rR+2B2fotvzIISVN8+clvtficqr6z03z4LX0xpyFWUidV57VslO1LsJS+
	F3tjUUGwTcgF/N4DMTpvfNNK4/Rr6Mr1lzBsSu861XoBcCGFVBCuXz3lZQU2YAFMMKx0KV
	RD0dDqsrJ7PrQVXo3Yxge2pHdtafrnc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=sHyXblFL;
	dmarc=none;
	spf=none (imf05.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.46) smtp.mailfrom=matt@readmodwrite.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792658014;
	b=InlPrC1wSAaq24l/P+GuenmSD+0DPN7br+1ZzXJg3q7f2u9xulobg7O5ZQWyi+xho0DesQ
	COVEUZlRKKq1p7cFXC/1GUIRQS8mwxTo0ySUHFPoYyN0JPGDORigKe6y4SQ/Ngq+dRX0FQ
	M+t0eE6Ahqbr2cYFcrSeUzM4ROqygKE=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48df8fe8513so1470620f8f.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:33:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1792658013; x=1793262813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Po10xs3c1tBUXr0/TED4BRLkJvTxT4ILiaYjl5lFoSg=;
        b=sHyXblFLviNAgDt9JHRWDO1WAQK1cnyyRHQ8NLDA+Py1r6pJM//I0jsrjzteYtZpei
         9iTEGLJI88L0YWSwn3UdrZ647BBjTY7u1Hj+pHOoMhwpDGsR6mSsreHvdcM761i6zq7Q
         5X0f0wktQvt7fXvt6e2/Gb5zlMCzouFrc8KmctQLktVhNm0az+Kk3I3jvlYdU3y8/CDY
         mUPu2S/ptX+3/ERfKMN6C2ROjQBzA9/5aEOCsOI8nZie29wMUbGfZDHVfNENO8CaDazb
         VAh2+mJ5dabgpVy9xh/QskYSxwFQjfd7pcDX2aTYPCcGfn2CICU9Dkd88GupEe6KoDbN
         yoDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792658013; x=1793262813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Po10xs3c1tBUXr0/TED4BRLkJvTxT4ILiaYjl5lFoSg=;
        b=HkQP7R112fjZD4SeUKDGZnHJAmG89ZyAfSC6lcB7eWhX6hcw026AfSjGqbOmDtKGGp
         VhS9YntKh7GnpaHa8UW/6LXYeqoQNzpFbQaVFXLwGuGfADBRdxVz4v7bfj/RxO7zbnGL
         EyoOcLvPM8JQgf6WphjoMvCmgnWWNIAJtjBOZrBBclBzGMZF2jAAkhdq5THgZga16Jv8
         HTwuRB8namcD5gLtvatEfOuNUqm3eCX6dFFcBwHth20S8/V+Gbq3O6SsgGEX9schWXnn
         ByRy4lfsiJP+gbrbp68/U6xGfKmZfMp8V0+VesBf/Wwev6a++jkQmSryx59s/Gs3Ciqb
         DWRg==
X-Forwarded-Encrypted: i=1; AKwUvBwlE9Rbz+alB47QGnAuWvM4j/2WDH06dAzeVyuCDSlTsbWR62DsgTMCxd1N7fuVxXLU6PfpzMJ5QA==@kvack.org
X-Gm-Message-State: AFq9FYJfo/sWSoWz3p9+h0q+374Qi2Oe2kigSbtNPneNUXZ5rZi60gLc
	fe2uAgBbTyqCDy0cAUM/h44Uh2v7fcM23tRUkKLsiM0m3Gt6YSmDSueJ8kxxHz/9Bfc=
X-Gm-Gg: AYBFou0TikF8CbS2Z9ak+R2pgtkWjswK962H7UbahBh8Kthwpcw/EJhdp9Y91Bs8HeB
	wX5nS8Y270mk+nn/Ks78ITgnItDOJxLtuADDTI4mzl2GBKbqu9F8KdSmYFxGjhStClNufhareGI
	QDhNntyziBCgdxedYhlFa6gezq5WSXMZTBgAW1Evwuu9P1E+Kvr6VKSmrfqzS+dave8wP7w7x26
	cKK8Ma0fcD0uPutz9EBOwEQV34DvHBtBRT0I/IdCiSisakjZqnGBxCVjZdDwORuKU+0buMOeRBK
	U6/TMOQRugRoo/GwRMy8fwY5cOeQKo7MgZW0dZyYcpU+JZxvSvbbsBYOzm6iTjCrc2F2xHTvwF0
	FEKP+SkbvfZWEgZUPidQCSwtrxrJOnNsqq1Bbph79hrClvRuzIVdFWqKpkccOnkMiqKOiWbj8hm
	sp9XrXP/MM5Y2V+SChQrmKhqwI4QGVPlQkSRgD+KpA36tGanA/O+j//HZMI1unPg3L47LVv4gax
	gYap9Kvzx4zTzBzDpqGbkPYW8tICVpm6NKfEfZz2MOLbj+yScqdShtLVw==
X-Received: by 2002:a05:6000:2201:b0:48e:21d:7265 with SMTP id ffacd0b85a97d-48e264c48abmr10924136f8f.34.1792658012958;
        Thu, 22 Oct 2026 01:33:32 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e2581fa7fsm10280598f8f.17.2026.10.22.01.33.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 01:33:32 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Caleb Kan <calebkan1106@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	stable@vger.kernel.org,
	kernel-team@cloudflare.com
Subject: [PATCH] stackdepot: stop preallocating after the final pool
Date: Thu, 22 Oct 2026 09:33:30 +0100
Message-ID: <20261022083330.3159793-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B5973100002
X-Rspam-User: 
X-Stat-Signature: krw9oi9ko8jgnngk1pp6w47mcyitzaja
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792658014-750683
X-HE-Meta: U2FsdGVkX18J67jcKRZWBvX5jq7efKijsDyV6u51YcMnBx8/n+3ogpNN+xG6dAykvJcP9upPuiSxfRmHyIErxB89E6Zaj7RyG0TeKiTQ4Ln9i54HzJHO3ad10KSqqPxuJIasojjjtUXiwr4TZO7LxE/DfW0Id5X4dqK52ntHu5uWQHjCVgTd5ucQme/RvsFJC1VPa8CNeT2W5g4oPHGNBemcu2ZDNf3RGCnSRrHIBOMTVwaTAnNJjWRJSkeYzoYEYU4GKxR5mnMJGi4IAQvpgIY+d3sZ6FOlm3dFpjiRXSKtqQZYkSl+Tt2+e+/Ih/86aVwf2mpSbB698bpq28EZa4R79mOx38AyP4oTM2ehkWb3b9XGv4GcnsLMIx6v9d2yFKdltIYHzfGKiRTVY3TVDQY5vK4NAfGJ7gNKBVelzJfm2ufEHhds4+CAaJ28K7XMwKXgWa+0hMKAG1Ivti4GWiteTdLABamuOv7qjkAbxoKpP3TihXymn/flFJuE69Mpcwe/LUAaXrni24E78pbUuaGc/KuyAbYUXivPurlKO18J7dbofEVGIGl+k3KC21wFM6tEVUJMqOiOHMgRqENwW45UbpFyBcnTIejtTeuKRfNkvZuQhRtEqzecW1+LN48VqBpIvSRTuc88haEN79hJKkNtoPZrIa329ZCTcuxmTGNIyyYPs7OmSu2AIxk7L79xWTrbooY91ifeaL5RYup6bZNtFW4fsDZWe4ygQFyG7r8bFBknC1NKzeF4SwSI5/gJgfG9bUjT116oDA86TYaVKP9glJxb091zPAaVwySpPqctvyxqWRPwftuCUe6gpc3dzFs3/WDjfEnNimRcpdd7xeXY4+ORojrgGUJEmZZG2QKi06hfI7LXFQbFa0pRPPvJufvewHuT84x2sL9JdfVRaY5IxdFD5S684ErnL9ael1AVX9Bc+Jzg2Cec8FsNXmGiiFx44b7NqO5xVDuRTmY
 pHo9QQDP
 hCIIR9HU9jdJX/+pIxTUoKYeEaUQRWIAl9GwUi7F9yiyaqIS8RRlYwSeZZwmGkRDBQcJKVL7c0NxnGYvu6fOLitjbFRelLghFLDj8e50BJxzCTNMhAgMOVIrsZMscloSD5UAajVlZkdYY50bX25E5vYrkaWpNKvUNkZLQoh+7EKVsU1+aLvQ0TCbkhi/RK1ougtsk6ZCeEy3spsfDoI92T2WRkSelAjwVOgWfu7wKPO2p4QUgj1ajgGjUuNgnkWwHWEFHAXnDv5gm7nffnGc/MGehNYq4XW+taOymSsBDYvpjm715XVDr4zpJSCOZntYPCannE6zCNQPqLrcO/5dNUDJLfHOTbbmrnVv7AISzoi1hHfFDdFwb4EFWEYxAIdI77Qo1fcuyqDqlYCyjGepYI+f9zX4IbtKRb0HzoLqGQEBjt/Zh0l9tlkAU5mhkyIq4PdtA1yu20yrzbvsDfcwqbKrGg339B9hA2YpD5BklCNgzZ+sr/uuN98q7ohsUHfc9F5nLmlOLfTWbjv4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caleb Kan <ckan@cloudflare.com>

depot_init_pool() decides whether another pool is needed before it
increments pools_num. When it registers the last allowed pool, pools_num
is still one below stack_max_pools, so the existing comparison clears
new_pool.

With new_pool cleared, stack_depot_save_flags() can allocate another
order-2 pool after a lookup miss. depot_keep_new_pool() retains its pointer
in the global new_pool, so the allocation is not lost. However, pools_num
has already reached stack_max_pools, and depot_init_pool() rejects every
attempt to register the pool. It remains allocated and unusable until
reboot. The non-NULL pointer prevents later saves from allocating more
spare pools.

Account for the pool being registered in the limit check so registering
the final pool installs STACK_DEPOT_POISON and prevents the extra
allocation.

Fixes: 31639fd6cebd ("stackdepot: use variable size records for non-evictable entries")
Cc: <stable@vger.kernel.org>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Caleb Kan <ckan@cloudflare.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
Previously posted as patch 1/11 of the stackdepot RFC v2 series:
https://lore.kernel.org/r/20260908-stackdepot-trie-v2-1-1996d5cef732@cloudflare.com

 lib/stackdepot.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index dd2717ff94bf..90c52f2e0d3f 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -323,7 +323,7 @@ static bool depot_init_pool(void **prealloc)
 	 * NULL; do not reset to NULL if we have reached the maximum number of
 	 * pools.
 	 */
-	if (pools_num < stack_max_pools)
+	if (pools_num + 1 < stack_max_pools)
 		WRITE_ONCE(new_pool, NULL);
 	else
 		WRITE_ONCE(new_pool, STACK_DEPOT_POISON);

