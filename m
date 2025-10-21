Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B857DCCD1AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 21:22:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6B148E0014; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1AA28E0002; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB1E8E0014; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 90B1A8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 17:22:23 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 46A8F1A0529
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:23 +0000 (UTC)
X-FDA: 84023394966.04.06FE536
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C0C812000C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:22:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aiqrEdfh;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761081741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=tARCGAZzmsANWsJluBhRa8oUPjbyJYtBFot6su5eDu0=;
	b=xMHd4+djBPffLA0YvZ0qA1rRks+INCJl2VcKA8OFyS3J10uer+cvmZoIx6BRnPwXjsGDM6
	m/yNe6cgubgp+97whG0gWWtNHLI+TytuZs5XUpf/JrcOpfmDBNyqR+x1lal7LfhtYJ3h+N
	TfgG5TgFg8yYBccipDPBX4YvM+6E/KM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761081741; a=rsa-sha256;
	cv=none;
	b=4v0t0oc2BsPqq5bkOVp3e6jIt6mHmhxokfaJWZsG0jrC4o/wM/9X43qbUEQM+Hn8pbiV7c
	wQofYurXsPl/zvEjP3koj+S5Jwm9RXOrzVwt8sfylObX+AufxM3oNJtZaZPtaDp50snBu3
	PzmDqEu5pmkJDia2SXRgUGWzH2PeJpM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aiqrEdfh;
	spf=pass (imf29.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b457d93c155so925991166b.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:22:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761081740; x=1761686540; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tARCGAZzmsANWsJluBhRa8oUPjbyJYtBFot6su5eDu0=;
        b=aiqrEdfhPeg0iyxloxKU0VyGq92WaJPji5DtpsApUjoVIlgmeuqedcpWm24JU40fqF
         Bp84ITaG3KaaOJCo6vY0ogqaCp9F4HQR3V3reH+rdIpV2qezB1+MSVLUTOWnR4TbIU73
         iHfSjS0GN/sGX4+CB+BBuY+hCdjOm4xnyZZnrMDV7upvYDC5gT1JN3OrFMiFWVRD7QmM
         Vj76PMBrzbCnp34cmYpDNYNdeLWhuB5V7vB0nar4JBA8ZTKmxJx7T8k3G2IUkK7AYU3f
         J/30n8D+2aUwSKYrNjevyLj4IgwQyft1W4bpAMWzTLiVt2WCFqcWpOvP69YT5tsVvbHl
         4G+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761081740; x=1761686540;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tARCGAZzmsANWsJluBhRa8oUPjbyJYtBFot6su5eDu0=;
        b=Y2iviehZ8DzH6vAhNqWcltXCLvxlmRlSj3w2D5kckBTEx8BYPT74fJAidlGGpBOBrf
         6gYy5kDdmmrjjmwXjmlQTF/0knCo2Nx9yafRDyI7b24DwYKpo9N87LJV+0NVo+K/wKCG
         0a17pp5iDIHXkcC+ZwqtVoiWujaJizS4PUsZ+7J3uaHzAXs3ZGOqmBV0BurJl6SGICev
         vBAfc4XyRzsoiYvFYDw0JYTujob9IvN4xHgcC1hU1g6p4SvLQRV9rX8XX0yXs30nrP4F
         fFgd+Zwo15Ss0a7Ze72nNK0cYiamkjinEHxpc5FpMSJ90+ODuplAfnfGaevAZ+GLC83j
         aUUg==
X-Gm-Message-State: AOJu0YwZNoMVHX41jSrJPTwja5B1JUCjX7Uk3UTTRc7RmIz1wN+atdGF
	Qts8u4Tk1X3Nf8oXNDuWJSgHOBJ9ldBCbsrW3tpRGXvXPgFPQDGKsBwo
X-Gm-Gg: ASbGncv1sGTv34bSoz5Gn29KEaVh5tet9cy2HMSXiM+tGaU0cwLGmSPhBcnYV/Gd0IG
	YxVGtIt8RwWnf1k/aHmqWzbXM8CTuRCXucX8J0wp9r0umVj3cp1BmMJ2FSfWBiGVtx1ZdqngJUm
	oQDWbMhBjKfeBrqfij8Xz1V6jZgWq5VIvuCg2Q4MQGA4OILMY0bwqcromL0hc8Ov5W1dbgO0Kus
	45tLEPbN4tH/YOgwUMFnl8x/0ZaQdlv2j90zL4CRPqDu5GFlrhQ0urvr92ZllKpCbNq+va/4Ag9
	Vfg13i45rX13eQ9wz+HbZMvaZpuJeswWnUPAocnZW/mZRoe9NcmXtba1f8VHo31cDDIYc2/QAc3
	7/WsWW8G/ZPuWtBMxCm/7MCB4url4Y7r417HhMxD96IHhrUfdnzyAW5eJzzykQ2DZPNStR74d3V
	s=
X-Google-Smtp-Source: AGHT+IGVchGY84t0wQmubeBxXjc4o8g8wDT8ecPwU0f/8KIhpvPmbt/ILX1AxqDV8fWZd1yo1HX7dw==
X-Received: by 2002:a17:907:9489:b0:b4f:3c7d:ff5d with SMTP id a640c23a62f3a-b64749414e5mr2259177766b.51.1761081739967;
        Tue, 21 Oct 2025 14:22:19 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65e7da35c3sm1155028766b.4.2025.10.21.14.22.19
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 21 Oct 2025 14:22:19 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	wang lian <lianux.mm@gmail.com>
Subject: [Patch v3 3/4] mm/huge_memory: optimize and simplify folio stat update after split
Date: Tue, 21 Oct 2025 21:21:41 +0000
Message-Id: <20251021212142.25766-4-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251021212142.25766-1-richard.weiyang@gmail.com>
References: <20251021212142.25766-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: 6r71ymftfrii13b56euc74g8y88x9yzi
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C0C812000C
X-HE-Tag: 1761081741-911535
X-HE-Meta: U2FsdGVkX184eX4Zw9l65rezTtjad8td5LZisRNj6BTcbySS0823hiJfrngoUeAPEWbO4yTfWDS3PEBtvA7jYybMPhBq2UbOaK0CMXqiKH1kaR6UWNVId0OxTJiCtwdpP18sJnKI60FK/zvLPGnhaoof5vk9Gh1mENFRkVfWKQbH5ywOFFbmOSrU3ZMW3hHG4ChulcxrSqcukm8s+135ReC4624adA3zhXwiMvM8kZC/11/8m05KKyuCanzBN9xwhJh167dIiCRJ/cm1h4qN/r8mHFeW1mGawIdFllCVwW8d18aXLXKvI5OqP2giZFntrmCeAntikrDvPMF0PTZaa/6SO9jW21nm8ha3Pu1dvCtpSS/asBDSuVMK97kY/sj8TZ6wmSfqEwM3wrK64g57c2qfS9nj8aKW0jW2qq8a1WvizyYJN6pnEJZKlmO7AzY6FvosT+0GGhHE0gdse+tqlonARanOntebR/MLlmVvzM5UW748/PIcUevWqJIvqk22DjFnMPLxGbu8qQGx8bbtTuHMV1yLYMw4fxrT4KNAapRXJenufWKEvUB/tUTj1T5W+BVGHTSngifMzVmfRR72GuimJnPIrSVoSLtCYVPx8JNC1kMuBd/OSOw2Xigug71ffUNVHe73SvSUHByS1nCW0z8sZUNyTn+58K+USjXU7JA760fa6CEb8t9UprKXG4EtnOEClTVrvFO1OaAsfikawZ0OtmMJ0vctnDROqbe2gySAyrQwvpwao+C9YTXCx2EPfarQT7PB7Du5hDf0fgKVaEWwNPXdZIdX/rH1ZAGBJJuhpFuHh2WbrNjL5v8dADanUuALLXBn59eudzt/wfoTztAQuOuIX1Vj2rwcObsR9jXT+8dtBe91UYLypuLMPrcvjMfsfD4jVnWpASeIHbxqgz972xl8i4DOnz8XO2zxjjHdvRqzKjjx+QnR7wj1Cyh0/mJh9/O8bWgEXntQ92C
 Fy0Z73oS
 H32dPFFrrdpTt4pE3CdWgPm2vkIlQ29df0j42JCMP4GuZ1R9ezmPVCwrv/lRRg28b9ubirPwNSoXFN8E4bkp2m7EI+ykjAzwnxM2LoNhbtXdt6+1Hr3O+p6m802TDUKzWjJPOpSrswrWbcJ0/ZgKUjmx183FuH6IxU/lA0DztXq8iFwZtoJ0RV4HAFLTUh3DuSMPfWuaRICn7sTWO72TL/BuBsmXPr1Rs2r74JTdcOePS7GNnVQCz5Y8FYdxPNyRi8MXTVjuBN1K+Iqglu5T3N37iFxfNV19STyh+hiN1O5IxD6ffCwrWVt1yK2omiQIfXYY5j2FBzqzU0ywjaWGbl5agH+jCdxYZlCEgxQddE5IKMl4HLDgICl/KEJZTAaOGxLZCkWDQQ4dNczCkMkq6ljoHYvRCLUDm7mbNWsJsyIcrQCDEFbqukHG0xbgFs09WvVQkjDA/LlFqKXQie1i47RMYeE/0s6MGI7vs85OlclKB0jedFY1VcA0VD4YhZ+eXSl7kCrAwT9YVmQlYBJ5Q6+l1r+zuiGg1V3livjaHmn3up40a/WOsTMkKEw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The loop executed after a successful folio split currently has two
combined responsibilities:

  * updating statistics for the new folios
  * determining the folio for the next split iteration.

This commit refactors the logic to directly calculate and update folio
statistics, eliminating the need for the iteration step.

We can do this because all necessary information is already available:

  * All resulting new folios have the same order, which is @split_order.
  * The exact number of new folios can be calculated directly using
    @old_order and @split_order.
  * The folio for the subsequent split is simply the one containing
    @split_at.

By leveraging this knowledge, we can achieve the stat update more
cleanly and efficiently without the looping logic.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: wang lian <lianux.mm@gmail.com>
---
 mm/huge_memory.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b9a38dba8eb8..093b3ffb180f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3598,7 +3598,6 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	const bool is_anon = folio_test_anon(folio);
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
-	struct folio *next;
 	int split_order;
 
 	folio_clear_has_hwpoisoned(folio);
@@ -3610,9 +3609,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	for (split_order = start_order;
 	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
 		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
@@ -3641,19 +3639,11 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		pgalloc_tag_split(folio, old_order, split_order);
 		__split_folio_to_order(folio, old_order, split_order);
 
-		if (is_anon)
+		if (is_anon) {
 			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
-		/*
-		 * Iterate through after-split folios and update folio stats.
-		 */
-		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-			next = folio_next(new_folio);
-			if (new_folio == page_folio(split_at))
-				folio = new_folio;
-			if (is_anon)
-				mod_mthp_stat(folio_order(new_folio),
-					      MTHP_STAT_NR_ANON, 1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
+		folio = page_folio(split_at);
 	}
 
 	return 0;
-- 
2.34.1


