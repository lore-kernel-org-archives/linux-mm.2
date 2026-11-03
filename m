Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B786606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OvPrGvu1
Received: by kanga.kvack.org (Postfix)
	id 2CE4D6B05CA; Tue,  3 Nov 2026 16:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ACFD6B05CB; Tue,  3 Nov 2026 16:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1460E6B05CC; Tue,  3 Nov 2026 16:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D31F76B05CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:20:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 46F6FA0544
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:44 +0000 (UTC)
X-FDA: 85395077208.30.DC42CDF
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 62BA1A0008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:20:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OvPrGvu1;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793740842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QMSkF3CbhWR3iQTTze8f4Pz+ut+A6RY3FLtsolKrTw8=;
	b=T8zTih8NKxPADOJKPFNeszcfla8EGHNWQxvpCcQi0DZvuELhX391yNhhd87i7CCrytA7j+
	jZTvRCKSRVtUFM34Hk2nJqH6ivkUshwz0mE3qtmdBvr4JxvOI17mXHrl7ge7LDBPw0yTZ6
	kgzu7MvcF1vvB07XMMq5yglTaRbi60M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793740842;
	b=ndz8z1r88G9W6pS+TmyGffSmVZZURW6YttwQq//9ahZw0gYmEyAFU0bltwo2Txzw2RZ29O
	tap0PALkOjuwlItFyJV1YXYim4Z/mqhjzCqZuvxrufIwSK9e4Koi8zO8GLx9bjyHomAH8o
	LmncdA11HIbJG1HqqrGGacCNXHkw+Jc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=OvPrGvu1;
	spf=pass (imf25.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2e96502e447so26765ad.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 13:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793740841; x=1794345641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QMSkF3CbhWR3iQTTze8f4Pz+ut+A6RY3FLtsolKrTw8=;
        b=OvPrGvu1vBBTyoSK6ZIEtUcikf6JZb6NioaBgri8qVHObxOxPxHVLr6nmgQbh7hRTt
         dS7HyIKVIaURflA6Gcq3qEvRsvrL0j6iMbF48eujTqO2n6fmwjubW23I+2ptUVRuc4LQ
         xAqF7Du2BnYwI1I+GFwswNjK4H+JQ6f8RD5aruALVRxbFUyTnsiFXug/tqu3CqusQZJe
         QXhwd6D6BSHEyz66ZkvoEsOW2OfOEfxAlQKXyIp/1klXh+bWiDO0stk3t9gG/WHY3OS1
         5qHBJMpYMJ4BPtqdGfGC1bUscPYAY3OvYm30/dWuyqGFP+A8tGAS/bhVce632+HlBBHQ
         i2eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793740841; x=1794345641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QMSkF3CbhWR3iQTTze8f4Pz+ut+A6RY3FLtsolKrTw8=;
        b=jqo3NmtiVFwzwz7kjgAMfOSTVLf9zvi7w0d2beihDNSJjTIWml0I8qKL6HUUqjAb7o
         m3783+AVZCEATvR5NtVvdEpdAP2WEmjFM2YjLV2pMoEWzAy1PIkJYsJNRmH46NbAvy2K
         LmSwomsOiz7rrJa+OYfa7bX1NJk43hcdNv/4mWvejVk43L9o3jHsoHSPrQzJefMlalbm
         jZ7/LEHv1Sv1Bvj75I4oOAad6YXYUx9RW8x9t2nkzAQn+Bzh1drM/7jK0qDeYWzUHcby
         qsDs//GrIOudQ2B62AikNQ036l6zBCLU/q+XfT/5ul3hK2SBEhai+nvw6bWqS3mw+w+y
         ieEQ==
X-Forwarded-Encrypted: i=1; AKwUvByxmbpVSGNneOIViJ6VgsYhfm1DP+gpH+CoPrdQE6Aurm8ESqTYE0oEr/DoKzXU3qSuGNe3/OT6qw==@kvack.org
X-Gm-Message-State: APuU4Z/BQ/1HXp8W9WmdL70KgMuC1EpsOvAd8PBoSOMLOFQ0zJOelsVi
	917jTE+g2w1PUcw4azUcp9bDamBQWKHua5Y8Q3lHrlJBLOffkZ4DzXWf
X-Gm-Gg: AYBFou3MhkVAryeQoBn0En61eT+iBcWhSt4/Pm9alJNmW7UKuN1vWdeZAaKiQJ8/MAI
	IwGZoZvk5mIQPxWm5fGO/cSXTr9D1xDAVFaXHtnZ6Y18h8UHBweY66s0FcsVcdkyYvfN0yS/2Vb
	+0YVfSLJin0385mwGRoL8iE2nDB6/R/HZvlhBJvWH4YLtRtHwrtcxOde4Os0jeLF/7jziMqt/2X
	hdZLXqUlmTcSbpaYXVQ9aEwd90iEtzGAaxpnHAA6BUt6l+ZSpas1Mmz0jkIKJE9g/gX7yUw6Xg4
	Ze/9JUlhLV5xXmWGrNAP0Qcujft+CFk1iC0NKiVIxuahAuH0mbjuZSuht1Dn83n/3tIU6yKUfLO
	x87wuoXP3dtt7YeAzj67SAxTP3Ekw7DFHM5gGkhdBnwbpNlgd02YVGcVDoeKcEPE8T3Aq66Fyj9
	9DorEu+gPwhFgwCMB3Gf5+Odvo9+lSnbVOdpBofLK9QO2FgkAOfhnx58sLuMiY/Co6qSfTw3uuu
	FT1PTFo9wpVBIWa8DqVK2Y/PSAqRc2jEQgNrRVQa1fr0eeqKPTCIut6sLdtYLCDVS+jZh02qaAt
	wPh8u+j/8UyhpJZ3/GP0pVn1kitaMtEM/Uzf+aA14MT0XQsfH4XZp1hr9mRTVkglyNEJXe1IDxr
	/BPwl
X-Received: by 2002:a17:902:ffd0:b0:2e8:21a7:dd02 with SMTP id d9443c01a7336-2eb3653576dmr137775275ad.58.1793740841184;
        Tue, 03 Nov 2026 13:20:41 -0800 (PST)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed09134818sm67665ad.53.2026.11.03.13.20.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 13:20:40 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: baohua@kernel.org,
	usama.arif@linux.dev,
	hannes@cmpxchg.org,
	kas@kernel.org,
	alex@ghiti.fr,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	willy@infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v4 2/4] mm/huge_memory: don't queue folios when underused splitting is inactive
Date: Tue,  3 Nov 2026 13:20:02 -0800
Message-ID: <20261103212004.1356327-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20261103212004.1356327-1-joannelkoong@gmail.com>
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: khypxgsfubc9oa1qq9rg197e5ngzp8xu
X-Rspamd-Queue-Id: 62BA1A0008
X-Rspam-User: 
X-HE-Tag: 1793740842-688349
X-HE-Meta: U2FsdGVkX1+tPdNBx5k5mOKjdSUdiw5b7BBR6Y/QxqNng5LWzRXaQNZN67eUlRhNFt4T1mePcmzt4Kn2wriSGkeYzxqM+gZFcaIbx4RGcBtssRfxGFvQu/Zj4bJT5uu1PK67S4Y+i7VI8RX/A2kO8rTpdElHAG1uhYdW7kNakVGC8Flvfz9PZoAGRjavJAlwVq9jWtxbLt+eFPCtS9faas424cJp2ECIHMZ/Po66rYnLg2FQTB3KP25LqlP/BDXRaBbiqg7izdFPYhrPna3/BevfLpO2QjfbEWurZJ1GnDischlJUja8723ODp77IQDSuoRu0Ez/gXieemOQLPulCB1ttP+lNNCYcOUzvXj1V2y6kAJheAC6XZ/HUt59MbZN2aEdQ8DO0B9btNbhYvBzo7J76StW4ewXFknasD9SN1v37kYbJnf1Fq1ttBLyonpsABKq260vNKB51pFQ3HGRJooSVEyVIjhbtVxY2p1DLiJgYSMMp6yLAV3o5JFzhDjWRIQ5qDXOSWOQxG9CZPHWGniZsvTCfvB9fB/YgjpzLs+mbdbGFOu8HZT8T32Soh577aZjsj1W58+EP5WOYH3JwcNpE9VTuYI/Fi+PjyV2h1X85yKI0Ruu8u49RWX9OYa4Cx5lIcSaXYwc2Q/5Mr0THREyf8Pv3i8/UiOCF69NXPikE64hgPmMsgquP5dsXJvsLxVje9lY6mBZk1U+gdnX1dGVU4YS/iCt+QdbmcGfY/mo4CLBZOKiXY2hdhPW3bvI0LUX4ivcsYF6qEgO+29m7JKYw7amoBl6bJhUSyaewsmKfC/MAv3hF5EYWXMkiJxsOho0goK+CMCiDlpkfWGkFSftDrMvHTwXx50a3XrTf+e0/aN+56SBtCjxKe7bLUsgwRgi8NuKrx/leLOy2HssvHeRyx4ELJI7DNRX37WL1QLuP4cq7SLoi9qLwF5XQRMIq3DahK5DmUf086cgVMD
 vKyyUJEE
 tVsAaSqsGs5EW4ksEa0uFc1IVJaGH2i/YywyOFp6Mh7PRD9vPVHU/XdG7yKhfNWAOJvm4uFpIm1CCtFnYCT4wvb2BsB8qWHQGzhsh91d5k8TIPwHz2GxYRSc2Y7/S0TF7weJA5pcwLkwj0wt9mdrXosu4N7bUaIf3EooSFPxAD9ho8wyh48NrU34Z09V0VHE1Uo90yqHjbapWZkrvZjUJ9IN2reLIpyodCbph94iGyEp9PGRmO2KBzPMLkTYexMYZX9afmrCkKr1WcM6g6f0Pz4VZrOc5iPUObmvNh7DJjKLndHTXZ5kACGArTkGvB5les1NWT3KTyrDf2A5Ly/38BvOXdxSicR3v/rnH7LIBqQ/k8jPQFY98uZDshIFzjy4rU/d79Yi7DHonXv8dIHzoLKt3TfoY9UOfJoYS4pPVmACMCQ/9Vywo55nVyE1XZ1sBoMmT7S2h6a571Pdzkagv7dUVxclp0te1llZMsSlU5Cc8ZNOiSe7BSyrmjnpEW/DwMdNTcNFb79qvpA/bESylsVFdyH7Ha+hmdCNG32y7Tyfh8ByX339M1JNPabp84MnMVD4UQ0Ap1MIs3JvLAQf5q5VuEJA891a5JEji
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Every anonymous PMD-sized folio is put on the deferred split queue when
it is first mapped, so that the shrinker can find it under memory
pressure and split it if it turns out to be mostly zero-filled.

With the default khugepaged/max_ptes_none this is wasted work. The
default is HPAGE_PMD_NR - 1, which tells thp_underused() that any number
of zero-filled pages is tolerable, which means the shrinker will never
split any of these folios for being underused. They take the list_lru
lock at fault time, inflate the object count the shrinker reports, and
are then walked and dropped when they're first scanned.

Skip the queueing when khugepaged/max_ptes_none is at its maximum, and
factor that check out into thp_underused_never() so that
deferred_split_folio() and thp_underused() share it. Since the default
is the maximum, out of the box no folio is queued for underused
splitting at all, PMD-sized ones included. Partially mapped folios are
still queued as before.

This also matters for a subsequent patch that adds anonymous mTHP folios
to the deferred split list, as it keeps systems running the default from
paying for that on every anonymous fault.

Please note that the queue has always been best-effort. A folio that was
queued before khugepaged/max_ptes_none is lowered gets dropped from the
queue by the first scan that finds it's not underused, so changing the
sysctl has never retroactively applied to folios that were already
scanned. Requeueing eligible folios when the sysctl changes will be
addressed in a separate patch.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 mm/huge_memory.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 3720c12bdb0d..903bbe972011 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4564,6 +4564,15 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	return unqueued;	/* useful for debug warnings */
 }
 
+/*
+ * At the sysctl maximum the user tolerates any number of zero-filled pages,
+ * so no folio is ever underused.
+ */
+static bool thp_underused_never(unsigned long max_ptes_none)
+{
+	return max_ptes_none == HPAGE_PMD_NR - 1;
+}
+
 /* partially_mapped=false won't clear PG_partially_mapped folio flag */
 void deferred_split_folio(struct folio *folio, bool partially_mapped)
 {
@@ -4579,8 +4588,17 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 	if (folio_order(folio) <= 1)
 		return;
 
-	if (!partially_mapped && !split_underused_thp)
-		return;
+	if (!partially_mapped) {
+		if (!split_underused_thp)
+			return;
+		/*
+		 * Nothing will ever split this folio for being underused, so
+		 * keep it off the queue entirely rather than paying for the
+		 * list_lru lock here and a shrinker scan later.
+		 */
+		if (thp_underused_never(khugepaged_max_ptes_none))
+			return;
+	}
 
 	/*
 	 * Exclude swapcache: originally to avoid a corrupt deferred split
@@ -4630,7 +4648,7 @@ static bool thp_underused(struct folio *folio)
 	unsigned long max_ptes_none = khugepaged_max_ptes_none;
 	unsigned long i;
 
-	if (max_ptes_none == HPAGE_PMD_NR - 1)
+	if (thp_underused_never(max_ptes_none))
 		return false;
 
 	if (folio_contain_hwpoisoned_page(folio))
-- 
2.52.0


