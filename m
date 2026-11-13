Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA032606A886
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=lCCgsY/6
Received: by kanga.kvack.org (Postfix)
	id E41E16B00EF; Fri, 13 Nov 2026 14:26:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E19D86B05B0; Fri, 13 Nov 2026 14:26:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2FAC6B05CB; Fri, 13 Nov 2026 14:26:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B8A896B00EF
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:26:52 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 41B61140204
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:26:52 +0000 (UTC)
X-FDA: 85431078264.10.91B74D3
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7FBA740007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:26:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lCCgsY/6";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794598010;
	b=K199Y8TtzAuks1Q1xjUXLdbc7c+rJA78LHMfQpVp3vFebelPkMRJNRz0Wwam6jMJZOsQ22
	0THKHllQCbdRRR242Q9ckbNbvXuMBorddg3uVpfXPaZTyj90T+lPHHIZ+C5kCgASq8LEOb
	IjzIpIOiziCGoNya5AUnuvXBj/O+4T0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794598010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=DxM3tUlrWqef1Vb8Me+krOFyTuYnMoIMiKuZH3CS+yM=;
	b=dOfAibafPMvpZ6ek1Y001mawdsaovY20ZB/WiAR84fjuWRfyKLD0l4PeIm9n5hCto2YRUs
	Pqzlqw64M2uHb2GTGxh7eioyqGmopiykkC0kVR5Mv2RMgmU3DENBvb5q5G1BPU+ANe3ivn
	7QfG46QSaJ4yIUYfwxfFFkwuypbu0vY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lCCgsY/6";
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-93f269e335eso308056885a.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:26:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794598009; x=1795202809; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DxM3tUlrWqef1Vb8Me+krOFyTuYnMoIMiKuZH3CS+yM=;
        b=lCCgsY/6H879v/MNiXE45ZVALVktv8hxsMXurr6UYRxxyuu4BGbsMc9h/Il9uTZzlM
         SXaC5wWy7hDldeXrZLMhgDKTNpo5cnwuVM5Bh4iLNdzuqNB5/eeCaF8IaF4LgNtrbIwL
         UumwInvLxQ13LRJCZKZn2noc2KmXzK2haa/yzUzewYtLINdnn8raniDwGVvDaHqwVEqM
         tV4ziFkR4gXeAySccpTDYV4oCqkdgV/NhaLH+5C/E7APTZ+778W3lZ/lFD7B4s5QPs9o
         iSVP9AdzmLQOzZYsgEQ78yn2ysfgniLGVEcnA/F6ZYTj3a7gPOmjw0Mv/1KsLTzkoZia
         4qZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794598009; x=1795202809;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DxM3tUlrWqef1Vb8Me+krOFyTuYnMoIMiKuZH3CS+yM=;
        b=1CEdSpXyAVQeTwp6XtmtkglhcDNU2mmtuON+b9minIsDbcXYCIjzsmhAP68x47o9mV
         aHrU3CTsrn2CGd94f40ll1SGTI11zP3sFvR56jd9SdcUUY6ppK6qH2O4Ixuh6z+xKjPl
         0UtEtfvJBN7PPhX96JWC9RITCWVWlbOCrbfuZg30OD5hUtJZZNBzegtJFvAM79jwnxKk
         r7Kk7JRG6FEiq6riE8GpH9kFT8ira2mmtQSjUgw9+sNubUTdSKDrcXBC7n/YuGHbd3mT
         VdXGlAqDiWImWDwNytHRmTD32xztxaElRU4hec/uzHMZ6gg7Xk61YxLuOlsBgXwMzoeb
         b2Pg==
X-Gm-Message-State: APuU4Z827rad9llFy4VgpQXNQAbJXwz/pyHbpmPJKqo9iNsWWXq440FV
	DIG7QkrqHSEZ2BPYNURvR0HXNWfVkFe2WpBoRtWVEFf0iA2/JQLUddaoiBTNSHd2KzDe24c1GIh
	EiHnN
X-Gm-Gg: AYBFou01NUBKQulYSRIHbZy4KyZYEEz0MnqNEItPlHngkVr4/4BneTvpb1EXCY1Kbvl
	wfL9lBOMArNfJvcSfUMzOURJLdXRKWFy6ekY/kaG9gW+WQZs+vRCIQadmIY16Unicps34blpq4u
	ByVhvKiEaUjUlgWX2/v5aZjOSqzbcz6VWldGW1sdqsfCDqQSkiWzSjP1NuwiaF3Xj4CEpYxWvOd
	hZnORxccwzhYLDmgUz76AcHXQP1LKKh2JOSXJoTYsSNh9wvz+/HKTzQ3mk9GIE7XyUajlPkz+CW
	C7AnSo45leqClpcoHwwy7kHNazurWv6FDosC1XGZSBYwDGmUuslp6KquBQiF9t7dWNquoB3Y9Bw
	zAZr9b6P+YRXeD9lyM5nNd24fE31MJvwYl6PxUO3MORcD17u4Sz85zDmQJ96ofgJFAxLTUUUyug
	VReYi2xcYDCmlhH/fslMeXoJLLoHyklMAh/9y7zCU4yZIZ3WLyWjtqgUsz4F7tIQmZhG1mbzRjM
	dL8jxJZrUpEOw/CO3L1kLoQ8tih5nyrjiifT5VQBcdbXqJVvHcvRd8bmlmKCXZ/uv5/io15DUnO
	rf5qmWNx+0OVb8k40muQ20kHvsePd33FrLrvtp81jAT/mb0NCM/2QpfQzN2MqxnX/kTryJ1eDm2
	JUlTI19UJI6xzavY=
X-Received: by 2002:a05:620a:1b90:b0:93e:bcbf:4ad with SMTP id af79cd13be357-9494bbbdf65mr506105685a.33.1794598009479;
        Fri, 13 Nov 2026 11:26:49 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23dc1a60sm26421556d6.45.2026.11.13.11.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 11:26:49 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com
Subject: [PATCH] mm/mempolicy: ignore a bind policy whose nodes have no memory
Date: Fri, 13 Nov 2026 14:26:42 -0500
Message-ID: <20261113192642.2618878-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FBA740007
X-Rspamd-Server: rspam12
X-Stat-Signature: u8t4151wukbjhhxg8jechphuak5yjmcs
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794598010-694976
X-HE-Meta: U2FsdGVkX19w8DfCziAr94Fh0RHHbO9G7YscqvaWta+byiM8z/6sui7gz2ItWKKMiYe+6pA996Rx27yB0P1893LS6++5ylhT12qFcGB03ztHUg7/P16O8vd3VZf8y5HQRUiXazi1QPdwLbPr913rytR9JRXhtwsj+fXakQ5s3H4/FaAjOAcPANkVqXftWLHTGj/Wgo27cF1pwp/dXzyZfyeH6C0hgaGLqugabJk1RqS/yQzQXZ0nlO6ycicti/UoiT+WGwwVvS4GeC3mFOeC5cVL6jVUFzRCaf2afGSV6mXljGA16+biDzJADJy5BIqXKwec4Vis50Sdp4H12KF3GenhRfCrCfD4jQ4+DtkQVSmTRb6c9nuwj/B8rHEIKUjUtMGWT279X697b6fAJSi/N5Lhp/up+HUlDtu8fSv2Zv4pwtachdVbioebPmvbSZm8XBBEgKWLqtYC1auzsZKPnpmrmvC68HJHXDbp73WHK7rTt1Ta7/UX1K9Zinnp+JITbSoNyDcwHdsfLEnEhKEQuA8htNGd4INm1mceS2oeNM2pKc85C/+GFpleCE/+uC5RrZhtt/taksSD0/yeAWmBDsa+gglsOb3YNgB9X/esBKYacNBWl8WZs/jxGYt7yWzirskwmfVhzxE3WmTSOKq0GY+enMM2ATpRRbWeBQnIwenhEKlNXyGYEH+zEnlOpVxOj79x3HylrnZGDh5ysBUXeqo9Q25qVNJ5dsDfgZEwQUo99cQlMYfwnz7jaHDDi9M3bei2FUoGXdbQL8dwVZ8ASk9hBhX/fpE0MhUJYExKStj7oyrwFOMOB5bCt8kKPt8YoRIqg4P6Mxqoj29WQse18MpcTdgFyg/33aaxZAWt6DreH38U6juupFCmQv4c1aI3H6LPaGE5TCwraaYt1dYf16+jvutoyS5GCGFqUlPBIesGdKHckAGa23rE3l0PtHkOU2odbiFtXDbqhgJpEQy
 B5ec57Z3
 FqAFjw4LRvLhjL+HREjjL8Ly0tiRA6B1LocXebsmQn4JOonl8XasuHWUfJI1kKoqG0jwD3Phc+IteRTrTvDUJnsDwNEqiLZ/GLxolKJq/uo4Me+cpq3uPvCmZfAleKN3NKGA0ohyo/3Us+SRf7Zj7rf2Af7VDFxdFjbJkdFtwmm1MhJEMZgZbX9Nd/XG65+4iJ4LGkr3eIzzLQmSZqc45QfS2Wzkc/0aa+Msb8zFZaw87/oZvX+/RPtR05dsSJtQzuFJbIrX/bz5OZN4KWIR4pSllgFT43GpYAje6liB/Ah9QCpmMR8OXy6+uN0nHxXjXtTe0CDyCNKfl0XOu2HGU1BQSXggDkD6nBNnKEoe6q1qsgADBtZ3QuIRssqIhKp474/FHwBu8sf3UTXBb6y4H6GXI4a147m8/ZFNFArrMKVegObbFf203BtHLjXFsVHkPbt82ZCfDpviEBFvH9o7+NZl6tckfIzoT/ra8jxdTrlwhTiY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

apply_policy_zone() assumes that policy->nodes intersects N_MEMORY, so
it reads a bind policy with no N_HIGH_MEMORY node as movable-only.

On systems with CONFIG_CPUSETS=n, nothing rebinds policies when memory
is removed, so offlining all memory on the nodes a bind policy names
leaves it with none. The policy is then treated as movable-only, and
movable allocations are restricted to nodes without memory.

This results in allocations failures, a VM_FAULT_OOM leak, and then
an infinitely retrying fault that hangs the process.

  page allocation failure: order:0, mode:0x140dca ... nodemask=2
  Huh VM_FAULT_OOM leaked out to the #PF handler. Retrying PF

Ignore a bind policy whose nodes have no memory. policy_nodemask()
already ignores a bind policy that does not intersect the cpuset.
This covers hugetlb's policy_mbind_nodemask() as well.

If the nodes regain memory, the policy applies again.

CPUSETS=n with HOTREMOVE=y is unlikely a common configuration, so this
isn't marked for stable.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index ca7e744727b1..5dc2d7ef1544 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2096,6 +2096,10 @@ bool apply_policy_zone(struct mempolicy *policy, enum zone_type zone)
 
 	BUG_ON(dynamic_policy_zone == ZONE_MOVABLE);
 
+	/* Memory hot-remove can leave policy->nodes without memory. */
+	if (!nodes_intersects(policy->nodes, node_states[N_MEMORY]))
+		return false;
+
 	/*
 	 * if policy->nodes has movable memory only,
 	 * we apply policy when gfp_zone(gfp) = ZONE_MOVABLE only.
-- 
2.56.0


