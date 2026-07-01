Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB69C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 17:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67A9E6B00AF; Wed,  1 Jul 2026 13:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 651E56B00B0; Wed,  1 Jul 2026 13:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 567A86B00B1; Wed,  1 Jul 2026 13:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C26C6B00AF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 13:19:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 680021C041F
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:25 +0000 (UTC)
X-FDA: 84940869090.08.0834175
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 972171C000C
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 17:19:23 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=As0ffcbF;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782926363;
	b=sIT+K73MFmpDouwrAJKngs/KGBmFwd4ad95iH3oRslew2EdGNkqvuWlduTi0xuXJjc53Qc
	reVu2lN6RwiN/8EgFykKs81SksVu75DBMc6TUx3WWCGFI3EgJQn/mpGEkAv2/51huC86Sz
	rBoSQJJ2q4MHtGUMPj9bK6EiXc7ZO8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782926363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/4dtvv/aIQO81upj+w4QSeM/a48j6z5FlMxCli/iT4=;
	b=iwjiTox3oFpCxVhnWE9510Cs7wOuYhjxHcIIhSVrhJIxA2uVpG5zpbkbBapkosP5gubaoy
	x+8OU9jyimE0WNLdulAdWe1pSswZZacQLTO9E9Rl68EbjX7MrGQN+Ud6/ni6Df/8Mpiq0f
	x8kSlgtgDfnN9fdQ7F9NHnLC+xfEUSw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=As0ffcbF;
	spf=pass (imf20.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-842358aaf36so373424b3a.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 10:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782926362; x=1783531162; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/4dtvv/aIQO81upj+w4QSeM/a48j6z5FlMxCli/iT4=;
        b=As0ffcbFu0MK/xLmPOJhRKsIjS93QrN3bQGLPyPVJ7xTUrNqJKVyGB43l/YaX6LphJ
         cx8ZxzcY7rgbq2GcsK/q883MNYgF4/48ynUgvYvb0tyF6kxIdUjsW5UbGrf6gMs4s0qS
         IN75P3xv6ewIFMibr0QMX3a7YLxmTcxN3AyfYlSGqppfvHtb9KX5H81lLmBiWaorDU3Z
         E7AyE0BLjs+oFNsVeSqOzxT/8GusJE3zXApowbnH2pE3WpNPEtP7eLiExhWgW12Gd5/E
         PoUBw3NkLCxeM98Tt/6E3pIHYzh5iXatI0s+TOpiiRX5C0K+NRTKVCgBwj/gPAtqy7Df
         4BiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782926362; x=1783531162;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a/4dtvv/aIQO81upj+w4QSeM/a48j6z5FlMxCli/iT4=;
        b=jXPUZlW8oM+ek8ePYU/ecQpU1FGH55glSrfxzMuy4KymcSDJDRXT4mtGR7TiirUANr
         lFmcCUFP3KA/TiLTypqO+MrK6y+DZQqJLIHXy0UWmj8TRFca9GrBBiJM7bq0n2SnaaEb
         9ffUHsz2m8UzFRVEnAhRml+6cGs2hBFsnOcnejgfh+mBfwGicpqb/h/TFZThtVJpmDFz
         dzy2ZFvasdnfb7k4WicDrEsckbpZSht08JYCgx4+T4zrV7BuS9LK5ABmgdPc2JHNaprX
         DWgzGOc7/7wGJrhC+vTdWlF6gFxLKsdEwFlFWelfarJJHNDDx415FpoqjdiSOtl9Z5wg
         uiKw==
X-Gm-Message-State: AOJu0YyEmHFviHIRxkEitRlxoLnOjQH3WDxgt5BjVk5T9QgUWZbrv7eO
	M/L5zEytilb9mcUTT6Kx/mLX95wt+OW5qGyeO8of9vZSnb+eIGSFSbCi
X-Gm-Gg: AfdE7cnFtmGE7sEy5baPOUkZEUU6vIeXZyjWN6BvWYslPD/jCz3d0Lu4JTpz58/0DxC
	CSd7N5fFhaFIqJiZShPi0EHemejRaFnT5qUFF0+HngNM3tNe359O/ZOQWlbdeCDZXSs1P6WwX3J
	txzsSPIVw9BGZmrosX12SMbYTGyvMDnPnYF+qUw/yTDPuCLXv4SLbveTw+1XfiLErrJy6eGa1Ie
	31huMFp1j3Wrk5LaRMQyNa/R6iWYEh0GbkhzqxyBgEFdGCdfH0FRSch388Jpl9n7nWwaT5qwHOb
	GSSS/xkpYn3DHhObcPHnHxdJvMTif5vI1Dx765QvGdixH2j7PiCaevTcKycK0wBMpiuqyt3OmcA
	rOC9ThwhtvLTJ9HoShhtsDnL1l8+tvMrxdZaj5DGlPVjnUFyWJNnN2BzpmYUMgh6Qr/GJd58XQ6
	EGcTebkpQ=
X-Received: by 2002:a05:6a00:2da2:b0:845:e146:e840 with SMTP id d2e1a72fcca58-847c077432cmr2338544b3a.24.1782926362374;
        Wed, 01 Jul 2026 10:19:22 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847cb94ab79sm105719b3a.31.2026.07.01.10.19.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2026 10:19:21 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	Yury Norov <yury.norov@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>,
	Brendan Jackman <jackmanb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	linux-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Rich Felker <dalias@libc.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 4/4] mm/page_alloc: initialize node_possible_map like the other node maps
Date: Thu,  2 Jul 2026 02:18:51 +0900
Message-ID: <20260701171851.2447626-5-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260701171851.2447626-1-ekffu200098@gmail.com>
References: <20260701171851.2447626-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: shmxmt86hfe3s753zakcsmx55yqg5a6a
X-Rspamd-Queue-Id: 972171C000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782926363-306965
X-HE-Meta: U2FsdGVkX1/OQJ3Xs3FnXiBeQY26Ub1WTCQhRuTOVbiyhf/lT7RSvvGCCnRz78b+L/CtQamiFsnD5lZNQiQEDvNVTdMtkTSPC0MeQeNy8qLo5OCo72iOSEzYtJpTQJLWdvaX2W4mjwLolok4SrdWkILHFYuBI4p2BiW2mNqUlnnVLbIoPS0N9++rvUTXOXe3W8t77/H2iIhsD4Vd3qDjl+kM5SNqUwGswPrw+C+4+8DFpO30MkpLVAkw5Vuli6+oTB9316ZH9Tq8JnMn7G/OFYkws1ioF+lSeomlB8PUAk+mxr6KTqBHbacth3/nCIFzQ7vUu0OgBRQEYoVSr9vKLjHBdZoKhB+2AhQuVzLLMc10KIPTQYYuQszjZHLay+xljL3jTLx0ux6ormxIZ1Fouril4o0vTCE53EuU6oJ/zp7vjJ8JbqX8kOQRBzSaSx+snT+GxWi/tMAPa9oTK0hWA/50RKRRa6i/kIG7OyZ3tZ39BZIiypHQ8MvPLf/8Y5mBl0Ch4Cz6FlE8BSRwN60ezz6VSXnRYaBXjQinii9Z3+kduMt6x4YswLZTtfyCvdgaer7kXZp+jiaDx5XSCfAqXF1G8oD+0KWBa0SmcUw+vQsR9e5ougy+0UpGb2ZfC69+i0t7hp1kkB87B1GK573GPot3h75uv9HVg8i+27M6BCwlcqwXqC5jx9XCs5w80EhkLUIP9VhcUX2cnk7TMFmUGoCpjaJGlpgwwWoonD1OxF8yDLWBF9pAXEYi9/5V1wh7anu+cjbjmHEmN46ao6g1rbbpz+GeblXkPE0lUjJrcuESyDi1DQZOrt1l9qe8D3IxZUBBH0SdHUPCBgHnpDxd+UZQ3t4CO1FcrJLRoNSTKOarYIQtKOse6ztT7rWS1NiqWuDw7nH/ZBSgSVaXX0FB7x+XLIqXxRuDMp/YKcR7YSEtsyZVcOI6lQjxqYbobJaSYHelSBG049aXR49vkaq
 YOeg+VIQ
 WH3G0tD0fyUAHbCXic/5jzwrDWQz9pSys7WiWFq7oQ+uebmhkHqFQBpCAmsaULbElqrAzOeu4AImt4yKzF4RJ/Dh1v8otv7GrAjBy+w/hXOG8rgZdH6cKPilICcpGNaSVS4dqLULJPZfgF1NpGSuaAHBpSZIBAWyypT1X6PUFsVHfK8BuNTWY8XSC+G1yg7q5JQ7BpM2CSuNOlppXALsoTIblDh42y23EBVZ+qRuC5lJpLEw84ejtqwxoXFdMbvrmSXpp5xF+RNyT3hfWRoKuNf0CreoGcPuyFURO+vxcFaSfaajZ6vshO7sa+OJDn4NrlIkNWG/NLDkg0HTh56+/s3I8ywtJ9xC/kQQck8oS0Ok9Y3A5JBKMgu5cTsUo2UanriI1HfM+1uVycDfJCwyDTX8mcxWcPTtCHIU9iH/LDmUBj9ybPCxszSy2EUJaxw9dGS74BuHG39V5KYMZjNQ6Gj/UBNZLOm+i1irmPMQis0q4oggr/mJzkUzvSNN/wEMh+T0w67Zd23FaqoO4nCVvWuER5X8B6mEOmRPV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

node_states[N_POSSIBLE], aliased by node_possible_map, is initialized to
NODE_MASK_ALL, unlike the other entries, which are initialized with only
node 0 set.

On !NUMA, MAX_NUMNODES == 1, so initializing node_possible_map to
NODE_MASK_ALL is equivalent to initializing it with only node 0 set.

On NUMA, every architecture now sets node_possible_map after parsing its
NUMA topology, so nothing relies on the initial value.

So, instead of initializing node_possible_map to NODE_MASK_ALL, set only
node 0, like the other entries. Then NODE_MASK_ALL is no longer used, so
remove it and its only helper NODE_MASK_LAST_WORD.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 include/linux/nodemask.h | 20 --------------------
 mm/page_alloc.c          |  2 +-
 2 files changed, 1 insertion(+), 21 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index b842aa525546..484fe366a94c 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -47,7 +47,6 @@
  *					MAX_NUMNODES
  *
  * nodemask_t nodemask_of_node(node)	Return nodemask with bit 'node' set
- * NODE_MASK_ALL			Initializer - all bits set
  * NODE_MASK_NONE			Initializer - no bits set
  * unsigned long *nodes_addr(mask)	Array of unsigned long's in mask
  *
@@ -296,25 +295,6 @@ static __always_inline unsigned int __first_unset_node(const nodemask_t *maskp)
 	return min(MAX_NUMNODES, find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
-#define NODE_MASK_LAST_WORD BITMAP_LAST_WORD_MASK(MAX_NUMNODES)
-
-#if MAX_NUMNODES <= BITS_PER_LONG
-
-#define NODE_MASK_ALL							\
-((nodemask_t) { {							\
-	[BITS_TO_LONGS(MAX_NUMNODES)-1] = NODE_MASK_LAST_WORD		\
-} })
-
-#else
-
-#define NODE_MASK_ALL							\
-((nodemask_t) { {							\
-	[0 ... BITS_TO_LONGS(MAX_NUMNODES)-2] = ~0UL,			\
-	[BITS_TO_LONGS(MAX_NUMNODES)-1] = NODE_MASK_LAST_WORD		\
-} })
-
-#endif
-
 #define NODE_MASK_NONE							\
 ((nodemask_t) { {							\
 	[0 ... BITS_TO_LONGS(MAX_NUMNODES)-1] =  0UL			\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 784a6e2f8ba0..c0f17dede824 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -191,7 +191,7 @@ EXPORT_SYMBOL(latent_entropy);
  * Array of node states.
  */
 nodemask_t node_states[NR_NODE_STATES] __read_mostly = {
-	[N_POSSIBLE] = NODE_MASK_ALL,
+	[N_POSSIBLE] = { { [0] = 1UL } },
 	[N_ONLINE] = { { [0] = 1UL } },
 #ifndef CONFIG_NUMA
 	[N_NORMAL_MEMORY] = { { [0] = 1UL } },
-- 
2.43.0


