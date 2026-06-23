Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58967CDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:17:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 543E86B0096; Tue, 23 Jun 2026 19:17:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51B3B6B0098; Tue, 23 Jun 2026 19:17:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 432036B0099; Tue, 23 Jun 2026 19:17:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFD86B0096
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:17:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4112140198
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:17:02 +0000 (UTC)
X-FDA: 84912739884.05.5B187EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1E05940007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:17:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBxP9Nbr;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782256621;
	b=Ij3ILxHy213hKzVSU5AcRsl+J79kd6aohU0FrK/T613/1X0pVyEbnCmah1qd2fwApzZT9V
	fcB6lwAWhuFrRFkotz7KY+fFkl3OU+giVHMWS5OytfcFzLJCexblmErtsaXoxHH1Llh73q
	KZgZ2a99NZYTIBGvKIhg3iCqZ/BdhCY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782256621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wfS2cq98HLmpUobLI+w2iB53VWLqU5OG3MSQtlkIjFo=;
	b=6RzGlhytjtH0Vn2NURuovQ26SlQj2cVoyXatVGZGBjgI8PFTmLr9ZCIbng4g7KtByBxu0H
	xd/a1KwQesUs4j4AY0jlQJ+FTF/i2Y2IcElbh4wTpNR2FXtxsT1jG2zsN6DgKKZdHzicFT
	HiAFpQdw6d8qepuEK4kcT1qT3wR7dpk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBxP9Nbr;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E34D433A6;
	Tue, 23 Jun 2026 23:17:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF1891F00A3D;
	Tue, 23 Jun 2026 23:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782256620;
	bh=wfS2cq98HLmpUobLI+w2iB53VWLqU5OG3MSQtlkIjFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBxP9NbrpfckDpEk2swimjW/OsC7MAhf/P0x5VGDHqen1jj3IVmCGvAH60i5FkDq7
	 z/8e0g0PYDyIhwe8jw4BtvcMQQF41Sc2vdXH15miWTlGng97Au3n0SjTQPDyF5rXDY
	 Fb673rEDbIlq4KuqgbkAmTzpXFhHWohHQo7rh9SRL1LalbacniFG80OBSAKFURo87P
	 Qtp0Tmr8RONXDwZb28MGk2fnylWa6YegUIgJcR/OM8Cf+FKniCIwMqJcl8vazUgvSO
	 jLYbtf+BElr8zN4yYgbooVA2TXFMoxZVJMpdWEUV5Wi6+ZYN5kIA7M9Oa9HqXUjyth
	 8J/yQbK9oPFXg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baoquan.he@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	jp.kobryn@linux.dev,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>,
	Kairui Song <ryncsn@gmail.com>
Subject: [PATCH v2 4/4] mm: try to free swapcache for non-LRU folios
Date: Wed, 24 Jun 2026 07:16:35 +0800
Message-Id: <20260623231635.43086-5-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260623231635.43086-1-baohua@kernel.org>
References: <20260623231635.43086-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E05940007
X-Stat-Signature: micbfqrbwwxzf3ckbnuorqmnq1bdaxxq
X-HE-Tag: 1782256620-744192
X-HE-Meta: U2FsdGVkX18vqs3ECs/g4FtlPgNkvjX1+pgFNnePseVJEIHmQmI28YITjCThVA/qdvoDMnIRKP0ZtaVLLgua9YJGrP/ken4Sa/8YoepL88FEtjnxKPn3O7QBSwM5MmgVZJJRSgfNdbTTq4QlxS04y/J1LwlEqP7Fr3VjF1Y1l8rSgRNEE8AIXaH0sU6mSn+pz5WLL8j523oRXDIpbR3JIVPFpuG2K+hrUS/aXUW2wfKpQPLuLTGf4BAZZt3p7qOwm5KpYUI4NYlDmPRl4vehfmU2L8iM8Ygu/aJxtGrKmVWa7TEXpg/gcvMr2ehxU25RNFZkfzeYTcCRC0w5+YyXsI4VTSYD1H8By/hxijX59c5wGVdmCMSzZg5xm6YPeBoXq7sVk5tB+EYX2TxAGlzlYlE8aQcAmc7+x4Hka1Hu0+IfQWniWZ/4r2lQACxHZVDhVUYi/87TElZaExXD6ptUzoAkRkn2gcqotypP/QSHKwrxNN5HOTBx4tu3dFKIfVcdXPZKdT8kqjsOzeKPjwrvs20YvDxlR9ed8kEey7cvpkxTK1sm0/LyNyL4t9eJEf7zLeErzVX7j9cIAHt1+5KUJhoH3lyq6ywMTn41wZDBdK0iH3PNpdU2/LyodMJw4gP3j2KJtiPBGVXYWIL51rV34Miq7TP3yR+WmY/nNUtU2HbuVYDL966VyYchrFQNzSXeladB0ocDlgf/ArvsAn/EZ/RTBpf+bXnFtQbDidDCEj32dsSfqnJPJEQhThvHFw6x5m2Nykuempi4w2GCzExipFv7d2K5gSkF6hOL4nbeRXKgK8O+abYEmbbvmD4eq++d2feJgM6xCKZcz5LScJk8k6UJbyJv0BqmN5zbx/H86WRVnFbxeqon3d9pSWLNvGOJweTgY/VbqZsd5Y/FpZ3hNBlU1yHtWedmMuO2lSRyvue0DfQw9QO8s1SUcf95GDHeiRsoWp+ggZV6HGheRVb
 ftXn3pMW
 1PMRAUkKBCSSPb/c/71BMfxPTKMmVk9+W7ZIesB+snEqlgxH/YfKcS1P6FPduypq68TznjmgExLAPJS1kJTpzOT8nEAoKB/41Htwmm2Z+2uhLXH/j8EbXA8Jz5mTLP8eOileWv2DIwPZYaiqceE/voiTAP1n0/faq7ENd/NKS8GGvQbcdXwUNI3zeBjPY94x9qzBVhEK+bEa3D9V6+scpT73K9Nw/vqfDTA2jRacx3KwTAg8F0BlezOI7EDda381+gXnl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Originally, we unconditionally called lru_add_drain() for write
swap-in page faults. This might drop the reference held by the per-CPU
LRU cache if the folio happened to reside there. However, there was no
guarantee that the folio was actually cached on the current CPU.

Now that lru_add_drain() has been removed, we have lost one
opportunity to drop a reference held by the LRU cache. We could
instead incorporate that possibility into the condition evaluated by
should_try_to_free_swap().

Suggested-by: Kairui Song <ryncsn@gmail.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2983a6baf474..14577c67c61a 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5087,8 +5087,11 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 * Remove the swap entry and conditionally try to free up the swapcache.
 	 * Do it after mapping, so raced page faults will likely see the folio
 	 * in swap cache and wait on the folio lock.
+	 * Assume non-LRU folios may be queued in the LRU cache, which contributes
+	 * an additional reference to the folio.
 	 */
-	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+	if (should_try_to_free_swap(si, folio, vma, nr_pages +
+			!folio_test_lru(folio), vmf->flags))
 		folio_free_swap(folio);
 
 	folio_unlock(folio);
-- 
2.39.3 (Apple Git-146)


