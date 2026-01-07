Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32594CD583B
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 11:33:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2A96B0099; Wed,  7 Jan 2026 06:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983986B009B; Wed,  7 Jan 2026 06:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BAC16B009D; Wed,  7 Jan 2026 06:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F06F6B0099
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 06:33:53 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 382851402B5
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:53 +0000 (UTC)
X-FDA: 84304958346.16.3F02837
Received: from sg-1-103.ptr.blmpb.com (sg-1-103.ptr.blmpb.com [118.26.132.103])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9CF5FC0017
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:33:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZvYfk9rw;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767785631; a=rsa-sha256;
	cv=none;
	b=mn4tIC3MGkhrKF56Qm8ZDIPLeKwKtQ/vxTtrA57mHc5cnNAJCh9I2a0IcUTgtTHjxhns3h
	oosGBebejOEGVoDf3X9/E47w755LX3OqwJzVgCO3Gk6j6FugfiviiKWEwPLeXv1KJK5xTK
	/xaIDAEqoOC+jide46qWxHofvP68iF8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=ZvYfk9rw;
	spf=pass (imf28.hostedemail.com: domain of lizhe.67@bytedance.com designates 118.26.132.103 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767785631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cdN0DkMz/24rvpJgnVOmkfsKqwcFTBjxdUIoAY0F9to=;
	b=GYIiC4+L7h1dRAVUF2WGIVoCfVxP7352wTbIzl3iWKwTHC3prDONIBV00k2EKP9Iwr83ht
	IykpNrDYp+dNTxOZOHnxE2VwandVNIJhtFo/IYEy5MbpD1m9Pkd8JeD3Vp9hciEVU1ie/k
	mE8gwDY0xoSS1wq+LXzbh4N0eOpZLvk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1767785624; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=cdN0DkMz/24rvpJgnVOmkfsKqwcFTBjxdUIoAY0F9to=;
 b=ZvYfk9rw748S528ePTp5+ANPl8/4majtRwWTrxEDtF32l5vH2D+EfeogWjyslfS31jH4OP
 yg4hZoQYP6GqH+Yz5hsLJPT3kT9gHidk1TzXeo+jD3kHFURneLCxLgEIFKa9xEuaeZ9DB2
 OnxnYzxIgyuu5rD6DggpAwU3zzsdbqvcwJE8ionSwOvtyM+jxXUW6zUBUwnevRH3LaArDB
 y9F58i5/dEyAuXQnblGlR9ny+4L6xRnH+8YUzya3OZ35k3T572jT3vUHzngCWb+YaqRGCe
 d0YDTvILEQ6XH6Ut7J8Yw+WCCRJG8BRijyRwN+gHLunlS5cA9X2VZU2LpH1AiA==
To: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <fvdl@google.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, 
	<lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: [PATCH v2 5/8] mm/hugetlb: simplify function hugetlb_sysfs_add_hstate()
Content-Type: text/plain; charset=UTF-8
References: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+2695e4496+ef6498+kvack.org+lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
Date: Wed,  7 Jan 2026 19:31:27 +0800
Message-Id: <20260107113130.37231-6-lizhe.67@bytedance.com>
Mime-Version: 1.0
In-Reply-To: <20260107113130.37231-1-lizhe.67@bytedance.com>
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CF5FC0017
X-Rspamd-Server: rspam04
X-Stat-Signature: 9rkwjtshe7z7n9i6kttgx5w1f3xp5zat
X-HE-Tag: 1767785630-173654
X-HE-Meta: U2FsdGVkX18aGwWo9MAiPBKMK8Qnr2zGYwXI4ome2h4hKnvkZNIn/7xifcpV7PblNpjVBlzFfKBPZ5aPQULkWyg8udISOyWrzKsOG/cZGbvwJ8oIZqsVk10E0EsGw+Fd796rQ18wHtHeeJ+sX+ziGScEZj8z0DOOiuO4lZBuDiXiz8q44kFtDJhqwR2Jw9OGKoZ2bhLoUHbkzQh+aLVzbbGJOiP+Rx2va5WZg1fP/5FGguJpmqxLrU3OJFVuIExydG3lYwhYXT3RZA0SZILVPs3gTV8QM7WQZBips8FBlz6eNfENMkTeUKB6EUHxDElG7z0+Ft7r5OCPvo9A3WT7Iroch1k8ABHIqZeJV70OnZDueFIBVkBw2IbDPjQPGfI1DXucjXr/lewXZojNStKOtDsQmKymd3DUx6jIxLnv4Q3LZ4YSZeObJJyIuwG67SxzgvATR/ApQIYFYU4LiFIpg7rtYltAMP+10pYfPdVpuDleynUwDC0rjPuILgfu/wRJHzFhZUECasWFgTV2Qb6jLQuo1RUAcJepeuFAIYOmWLZddTXt+H7Qqe6B0LxktOuNehkiHepeQOkwhaAhybzf4OSDqemPRzc0bhCdyonnrfDAw9utQ3k6zDDrSHQAp9SlvWCgbfDcAUo4ceHaLRbM/PsO/DHVUvXBTanvZjMGWUogWksJj4Si1klY6+PfVqzO7Z/jhppEkb9mQkFwSwsmGRFc9DdXarve5llSArVrvj9NbmgxtvSXuSN3qxp6+AGbJKrvjEoHdSXfM/HoqZk+h2G7Oy8H6P0hVTeNueRYQ1/GM+aexR1MNaxKttK/VOEn1BvGz+nwFvPd607lL7w/m6HLCs5R8XXfmG89cZiJQHop/+QJKGoO8Otpy6kI4VuD05wU8vl7gn7Gu6L3Bn4ABHIvqbr7phCmaID0BZZsdH3mLn87yxawWYOABv5MTmyz1oqqKdVdL3B5dXyQudm
 5jhaeSfu
 TA1eAmxmku0ilh3vyXoKXM+0TlcAGB6JUsutFNhXHlQLUZ1JVAPvyk5DtZMh1daSlhABl63BH038JyHIyS6Rjycka8qbhrIp8qSiFA1fEAiGw/NfkrluLjmU9BkWxNFd8lFvaese0PvHaufEW+aCeP58hLcucPCFGaysuWfow8jW0FbZe7npWbf2MO+eeJhbqPtmvRN2kHfcx5/owmofI2JfGlgfn1GkHnV3IKlnLywfGYcGfdOg93rWkHji5xcmKMM1URIlXtsNokqKn2v3tqC4EG62LWThOU6TGWFt2xnwjDtM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The third parameter of hugetlb_sysfs_add_hstate() is currently an array
of struct kobject *, yet the function only ever uses a single element.
This patch narrows the argument to a pointer to that specific member,
eliminating the unused array.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 mm/hugetlb_sysfs.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 68a7372d3378..3f25a24e27cf 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -304,31 +304,30 @@ static const struct attribute_group hstate_demote_attr_group = {
 };
 
 static int hugetlb_sysfs_add_hstate(struct hstate *h, struct kobject *parent,
-				    struct kobject **hstate_kobjs,
+				    struct kobject **hstate_kobj,
 				    const struct attribute_group *hstate_attr_group)
 {
 	int retval;
-	int hi = hstate_index(h);
 
-	hstate_kobjs[hi] = kobject_create_and_add(h->name, parent);
-	if (!hstate_kobjs[hi])
+	*hstate_kobj = kobject_create_and_add(h->name, parent);
+	if (!*hstate_kobj)
 		return -ENOMEM;
 
-	retval = sysfs_create_group(hstate_kobjs[hi], hstate_attr_group);
+	retval = sysfs_create_group(*hstate_kobj, hstate_attr_group);
 	if (retval) {
-		kobject_put(hstate_kobjs[hi]);
-		hstate_kobjs[hi] = NULL;
+		kobject_put(*hstate_kobj);
+		*hstate_kobj = NULL;
 		return retval;
 	}
 
 	if (h->demote_order) {
-		retval = sysfs_create_group(hstate_kobjs[hi],
+		retval = sysfs_create_group(*hstate_kobj,
 					    &hstate_demote_attr_group);
 		if (retval) {
 			pr_warn("HugeTLB unable to create demote interfaces for %s\n", h->name);
-			sysfs_remove_group(hstate_kobjs[hi], hstate_attr_group);
-			kobject_put(hstate_kobjs[hi]);
-			hstate_kobjs[hi] = NULL;
+			sysfs_remove_group(*hstate_kobj, hstate_attr_group);
+			kobject_put(*hstate_kobj);
+			*hstate_kobj = NULL;
 			return retval;
 		}
 	}
@@ -566,8 +565,8 @@ void hugetlb_register_node(struct node *node)
 
 	for_each_hstate(h) {
 		err = hugetlb_sysfs_add_hstate(h, nhs->hugepages_kobj,
-						nhs->hstate_kobjs,
-						&per_node_hstate_attr_group);
+				&nhs->hstate_kobjs[hstate_index(h)],
+				&per_node_hstate_attr_group);
 		if (err) {
 			pr_err("HugeTLB: Unable to add hstate %s for node %d\n",
 				h->name, node->dev.id);
@@ -614,7 +613,7 @@ void __init hugetlb_sysfs_init(void)
 
 	for_each_hstate(h) {
 		err = hugetlb_sysfs_add_hstate(h, hugepages_kobj,
-					 hstate_kobjs, &hstate_attr_group);
+			&hstate_kobjs[hstate_index(h)], &hstate_attr_group);
 		if (err)
 			pr_err("HugeTLB: Unable to add hstate %s\n", h->name);
 	}
-- 
2.20.1

