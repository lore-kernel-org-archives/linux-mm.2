Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A671FD4F11
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 17:58:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0C46B009E; Tue, 10 Mar 2026 13:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C2A6B00A1; Tue, 10 Mar 2026 13:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EE906B00A2; Tue, 10 Mar 2026 13:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECF696B009E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 13:58:25 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C08B57397
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:25 +0000 (UTC)
X-FDA: 84530912970.21.30E48F6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD5C2180009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 17:58:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="K/jkfCPZ"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Adafq0Gul2Zbse7gcvbdTyGVQp6wWAvKLR/NocJiy5c=;
	b=hnpNEoihrg9KjUPAjJC69ig4JtU/vvSWN8ZYpwGXxbPCH8RaNg5vK5byH1mxh8S0jrJwsg
	AocbSvLXJaaJoUoactpRYIPzBTNLRB4oTePFuWugyMA6dJ2or67vh+H0BF232yW4EFzpVl
	4Pk6TaTd1ecm4NyKTNAO/GsEkAkOY9E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="K/jkfCPZ";
	spf=none (imf06.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165503; a=rsa-sha256;
	cv=none;
	b=0vy1JAhi1FnKEqgogcpw3rqX3YuwDRe5hqwlcWgqECuA/M98FIFiLds2Xb/m8u5U/LH+Hn
	NjqByAj42jHcfqDUX1pAsSiwdrG8SbPfXkygmj0mdwCjzwvls6s2JisH8bNqh9rUJrp9Hg
	J69JzN5hlaGHQgfvlHssUVdBdE3dmk4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=Adafq0Gul2Zbse7gcvbdTyGVQp6wWAvKLR/NocJiy5c=; b=K/jkfCPZkHSQw+rmes0kZY6pXk
	XzYISbxzCJfLWh7pwm5wu7MEjrPCRkxRHpg1CSsJDQuefRDXam3sTwTJnFg3/YeHEv/9+xON0YN6H
	8iB8fJtrFdqXg8wjkUTykHi6wtUjPCJzuSJNMeWxbgHxdr9SyKpGGZVdEnAAc7z2kTasy/vKFCjK1
	uu1LNuTgs8Pw9yyoCXNjAthjPELCR27LQxT/A2PrJeXZT8Pzl2d60bitIiUEGyVInU37a+mEGpefw
	yz1So2plRYKYIX9JZHiQD+q0kZoNfXEc7V5MYl6OHGFNqwuUYhimkKOQ7zChigYWXf7u9X90oBQdc
	KHWsshxQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w01LQ-003AZs-5p; Tue, 10 Mar 2026 17:58:12 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 10 Mar 2026 10:57:09 -0700
Subject: [PATCH v5 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-thp_logs-v5-3-686099175bf6@debian.org>
References: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
In-Reply-To: <20260310-thp_logs-v5-0-686099175bf6@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3491; i=leitao@debian.org;
 h=from:subject:message-id; bh=54S5CSIQXghjorDUhiNPNrDbTvMVQVjcEp0k9HQNOlw=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsFubiT+Qbo4tOy2dfd3/EQB8Y5nRx/2MGduNa
 1bgNh6kaO+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabBbmwAKCRA1o5Of/Hh3
 bUjOD/9B/LZbAZOE2fDBsLYWZL1iT/JfGNb0nfLhkmiSxOMAwEAF3rT1cVFeGwFqQuDCs9J3u0h
 +roIyfnWayPnjsn3A0RAnA7QF6IXXdulHteRH+F2iw7XeNd1snH4UqB87wJ8xPuJ4DZJ1pJwsw7
 O5EX+bkrLJs9w58Q5+oautp03Bt+/9ZOWRQLCtxkDWSGP/LBWCNP47LZMhlqMNscH0JgFqmBdqM
 SDm7Fr9gdy7/2ec4UADAqxhEFozM/dp5EtavS4fBi1/Na94NCXG2j+C9vwHhUvvdbDZe11XdnFS
 wN8/uDhIzUGnGGEfVHHylRTaViU/OagZO1bGSnK3Igks5QWi9FfyxgH49MXR6WqoNJwp1tBUS9V
 u6qYEhtVJeqtr05uzC7zDWX/cMdBkFMZh6SpRKC/68P087GQGzY9L9xUGjz77cKbyOGbLkO+vgE
 vIpcpPKdwTZ+VTQTQPuCTIXHzXm/do2Qi516dVINL2XRewDF9OGdyacIUUvWDs50sToZxWx6RPq
 19sLGHkyowDEwE8+4fpOTnDCNXo1D35OUflNkiar2NgZbxmuK7+Sl1Qo5AbVy7rC8OrQDHxr3/8
 f+pp36PSSqAwYSyTV3CFiqHCwY6u9LGgZQwiH2gzslgiqmFBSLVfQPyRjXpwQN+Yxl9ciEwRWGG
 lGj0eoXX0Daghbg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: AD5C2180009
X-Stat-Signature: 3kkun8myjgicopcwdb8qmegh4pmcj13t
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773165503-514205
X-HE-Meta: U2FsdGVkX1+2eNa1bMYcTDYJRf6BtouqU1FV7rNBsbTi3hnzTS3Tn0sK9dNng8xzhhHmwz7da6keApvWsgR5AxETioNG7mgde4d4+rxbzF7FMd1Kb0BUjZmV18okGWKSIryHidkuV1AE9IPp9Xg9gUS4cnLGn+fRO2tRmPTCsflekD0XUMHu1tXakHYRRgF6ujs0CqEviyfmrUdvz1VhDBK8+3uKNwwnaYqJHOSoMmV6V6EmqOBJf5GIX9ptffQI+mXnBWevfSi/j3Zsc7i2xmo/Shwkz70d8Guo/F3ZGNxmr6tdomd6i2OtcbxPjSVMXOAZK54DVlpNDOiZ4uKi/KNoIrxKMwgKPv7cwv2j2gM1WMRijeIC/QKEJ3bI9zsXGBCEm+vLC0KrOwTh26POV0PYYx+CkTjL9790Ga3PrNsJg1PVV10/Q6yW90ruKDHpiZKJpeZlF6tB9NTwdznZth+9WMkfnzeuGiaM0G0smzQuDrft2iZRj88tvrcZA6lnKAUNmkU6ltmLheb/0kaGRm57QXvQFndKagl9ocp1Q0KgZBzzYEtsi6DfU0VibUvTGZzJu67DNTO08gwtN5DvS4SCdsyxV8COLQPYufZQthRqzXQ7rxenC6gQPb7FZaHXRFLox/P7h+EW+4nWPq0zo3mvEz202JhPb45/CgiiCmZLsXiJS1xhzuO65hHd/5Q3jCrCZw+wXi7Zp8qgxyhjlNjWAfFD6FTy3vxAP5jfBx1oIpo5uhO0WUFRiL23FmYQ26IbN7QGrYdJgH9AfA6HDyoohOl3Z1lchZqgzkAB7xGQmgebqUVRP3yQHVBFbZSlxMlIb5NIHv9cFjlo0KlqGquz7euf7WGDuvhzeqiOLoSmesIou340fTQBpyC6+2kPSi0Ekca+NAVTnYu0/8KgGrEHO380wALisS0QSfNKPyeS/nP9gW7GDORGEpOflqHTIbz9cSW2BanYZug4i62
 7oOgpeys
 U9Thi3strB0WO3AIOZRa7782FEMhNzDBkiJy7c8zZGiXGUlwYid8r4Dx2Y/+mdJs3lDFtZNRpVY9AaMBsTgHJTwmR34PWg7bRFgAGwwIq31uTkRu0fDWOXvtvNhriTNc7vHP5Jolp4cht4ZkLqdfHD23Qjyt/MhEWwuvBa1QqhZ6jduoNohotM+RhMjWrsB7577gV6gOYtOrco5q7Jq9pNq5v06Q1Yeeg88fI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor enabled_store() to use a new change_enabled() helper.
Introduce a separate enum global_enabled_mode and
global_enabled_mode_strings[], mirroring the anon_enabled_mode
pattern from the previous commit.

A separate enum is necessary because the global THP setting does
not support "inherit", only "always", "madvise", and "never".
Reusing anon_enabled_mode would leave a NULL gap in the string
array, causing sysfs_match_string() to stop early and fail to
match entries after the gap.

The helper uses the same loop pattern as set_anon_enabled_mode(),
iterating over an array of flag bit positions and using
__test_and_set_bit()/__test_and_clear_bit() to track whether the state
actually changed.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e19dda5aaf195..cc98a3b8bc247 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS	= 0,
+	GLOBAL_ENABLED_MADVISE	= 1,
+	GLOBAL_ENABLED_NEVER	= 2,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool set_global_enabled_mode(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	enum global_enabled_mode m;
+	bool changed = false;
+
+	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(thp_flags[m],
+						       &transparent_hugepage_flags);
+		else
+			changed |= __test_and_clear_bit(thp_flags[m],
+						        &transparent_hugepage_flags);
+	}
+
+	return changed;
+}
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(global_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (set_global_enabled_mode(mode)) {
 		int err = start_stop_khugepaged();
+
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+	return count;
 }
 
 static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);

-- 
2.52.0


